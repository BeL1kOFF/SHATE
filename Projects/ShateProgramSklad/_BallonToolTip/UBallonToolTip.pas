unit UBallonToolTip;

interface

uses
  Windows, Controls, CommCtrl, Graphics;

type
  TToolTipIcon = (ttiNone, ttiInfo, ttiWarning, ttiError, ttiUser);
  TOnBallonLinkClick = procedure (aLinkId: Integer) of object;
  
  IToolTipParams = interface
  ['{D93632B4-5A9E-4487-AD68-7CB9B04C6069}']
    function SetLeft(aValue: Integer): IToolTipParams;
    function SetTop(aValue: Integer): IToolTipParams;
    function SetWidth(aValue: Integer): IToolTipParams;
    function SetCentred(aValue: Boolean): IToolTipParams;
    function SetTitle(const aValue: string): IToolTipParams;
    function SetIcon(aValue: TToolTipIcon; aUserIcon: HICON = 0): IToolTipParams;
    function SetTextColor(aValue: TColor): IToolTipParams;
    function SetBkColor(aValue: TColor): IToolTipParams;
    function SetTime(aValue: Integer): IToolTipParams;
    function SetLink(aLinkID: Integer; aProc: TOnBallonLinkClick): IToolTipParams;

    function GetLeft: Integer;
    function GetTop: Integer;
    function GetWidth: Integer;
    function GetCentred: Boolean;
    function GetTitle: string;
    function GetIcon: TToolTipIcon;
    function GetUserIcon: HICON;
    function GetTextColor: TColor;
    function GetBkColor: TColor;
    function GetTime: Integer;
    function GetOnLinkClick: TOnBallonLinkClick;
    function GetLinkId: Integer;
  end;


  TBallonToolTip = class(TObject)
  private
    fHandle: HWND;
    fControl: TControl;
    fParams: IToolTipParams;

    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure ShowBallon(const aMessage: string);
  protected
    function ClientToScreen(const aPoint: TPoint): TPoint; virtual;
    function GetHandle: HWND; virtual;
    function IsValidControl: Boolean; virtual;

    procedure LinkClicked;
  public
    constructor Create(aControl: TControl; const aMessage: string; aParams: IToolTipParams);
    destructor Destroy; override;
    function GetToolHandle: HWND;
  end;

function makeToolTipParams: IToolTipParams;

implementation

uses
  Classes, SysUtils, Messages, Forms;

const
  TTN_GETDISPINFOA  = TTN_FIRST - 0;
  TTN_GETDISPINFOW  = TTN_FIRST - 10;
  TTN_SHOW          = TTN_FIRST - 1;
  TTN_POP           = TTN_FIRST - 2;
  TTN_LINKCLICK     = TTN_FIRST - 3;
  TTN_GETDISPINFO   = TTN_GETDISPINFOA;

  TTS_BALLOON = $40;
  TTM_SETTITLE = (WM_USER + 32);  // wParam = TTI_*, lParam = char* szTitle

type
  TToolTipParams = class(TInterfacedObject, IToolTipParams)
  private
    fLeft: Integer;
    fTop: Integer;
    fWidth: Integer;
    fCentred: Boolean;
    fTitle: string;
    fIcon: TToolTipIcon;
    fUserIcon: HICON;
    fTextColor: TColor;
    fBkColor: TColor;
    fTime: Integer;
    fLinkId: Integer;
    fLinkClickProc: TOnBallonLinkClick;
  protected
    { IToolTipParams }
    function SetLeft(aValue: Integer): IToolTipParams;
    function SetTop(aValue: Integer): IToolTipParams;
    function SetWidth(aValue: Integer): IToolTipParams;
    function SetCentred(aValue: Boolean): IToolTipParams;
    function SetTitle(const aValue: string): IToolTipParams;
    function SetIcon(aValue: TToolTipIcon; aUserIcon: HICON = 0): IToolTipParams;
    function SetTextColor(aValue: TColor): IToolTipParams;
    function SetBkColor(aValue: TColor): IToolTipParams;
    function SetTime(aValue: Integer): IToolTipParams;
    function SetLink(aLinkID: Integer; aProc: TOnBallonLinkClick): IToolTipParams;

    function GetLeft: Integer;
    function GetTop: Integer;
    function GetWidth: Integer;
    function GetCentred: Boolean;
    function GetTitle: string;
    function GetIcon: TToolTipIcon;
    function GetUserIcon: HICON;
    function GetTextColor: TColor;
    function GetBkColor: TColor;
    function GetTime: Integer;
    function GetOnLinkClick: TOnBallonLinkClick;
    function GetLinkId: Integer;
  public
    constructor Create;
  end;

{ Global }

function makeToolTipParams: IToolTipParams;
begin
  Result := TToolTipParams.Create;
end;

{ TBallonToolTip2 }

const
  CM_DESTROYWINDOW = $8FFE;

var
  BallonWindow: HWND;
  BallonCount: Integer;

procedure FreeBallonWindow;
begin
  if BallonWindow <> 0 then
  begin
    DestroyWindow(BallonWindow);
    BallonWindow := 0;
  end;
end;

function GetWndToolTip(aWnd: HWND): TBallonToolTip;
begin
  Result := TBallonToolTip(GetWindowLong(aWnd, GWL_USERDATA));
  assert((Result = nil) or Result.InheritsFrom(TBallonToolTip));
end;

procedure SetWndToolTip(aWnd: HWND; Value: TBallonToolTip);
begin
  SetWindowLong(aWnd, GWL_USERDATA, Integer(Value));
end;

function BallonWndProc(Window: HWND; Message, wParam, lParam: Longint): Longint; stdcall;
var
  aBallon: HWND;
  r: trect;
begin
  case Message of
{    WM_LBUTTONDOWN:
    begin
            aBallon := PNMHdr(lParam).hwndFrom;
            GetWndToolTip(aBallon).LinkClicked;
            Result := 0;
    end;}
    WM_NOTIFY:
      case PNMHdr(lParam).Code of
        TTN_POP:
          begin
            aBallon := PNMHdr(lParam).hwndFrom;
            GetWndToolTip(aBallon).Free;
            Result := 0;
          end;

        TTN_GETDISPINFOW,
        TTN_GETDISPINFOA:
          begin
            //lpttd = (LPNMTTDISPINFO)lpnmhdr;
            SendMessage(PNMHdr(lParam).hwndFrom, TTM_SETMAXTIPWIDTH, 0, 300);
            //lpttd->lpszText = szLongMessage;

            Result := 0;
          end;
        TTN_LINKCLICK:
          begin
            aBallon := PNMHdr(lParam).hwndFrom;
            GetWndToolTip(aBallon).LinkClicked;
            Result := 0;
          end
        else
          Result := DefWindowProc(Window, Message, wParam, lParam);
      end;

    CM_DESTROYWINDOW:
      begin
        FreeBallonWindow;
        Result := 0;
      end;
  else
    Result := DefWindowProc(Window, Message, wParam, lParam);
  end;
end;

var
  BallonWindowClass: TWndClass = (
    style: 0;
    lpfnWndProc: @BallonWndProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: nil;
    lpszClassName: 'TBallonWindow');

procedure AddBallon;

  function AllocateWindow: HWND;
  var
    TempClass: TWndClass;
    ClassRegistered: Boolean;
  begin
    BallonWindowClass.hInstance := HInstance;
    ClassRegistered := GetClassInfo(HInstance, BallonWindowClass.lpszClassName,
      TempClass);
    if not ClassRegistered or (TempClass.lpfnWndProc <> @BallonWndProc) then
    begin
      if ClassRegistered then
        Windows.UnregisterClass(BallonWindowClass.lpszClassName, HInstance);
      Windows.RegisterClass(BallonWindowClass);
    end;
    Result := CreateWindow(BallonWindowClass.lpszClassName, '', 0,
      0, 0, 0, 0, 0, 0, HInstance, nil);
  end;

begin
  if BallonCount = 0 then
    BallonWindow := AllocateWindow;
  Inc(BallonCount);
end;

procedure RemoveBallon;
begin
  Dec(BallonCount);
  if BallonCount = 0 then
    PostMessage(BallonWindow, CM_DESTROYWINDOW, 0, 0);
end;

{ TBallonToolTip }

function TBallonToolTip.ClientToScreen(const aPoint: TPoint): TPoint;
begin
  Result := fControl.ClientToScreen(aPoint);
end;

constructor TBallonToolTip.Create(aControl: TControl; const aMessage: string; aParams: IToolTipParams);
begin
  inherited Create;
  fControl := aControl;
  fParams := aParams;
  ShowBallon(aMessage);
end;

function TBallonToolTip.GetHandle: HWND;
begin
  if IsValidControl then
    Result := TWinControl(fControl).Handle
  else
    Result := 0;
end;

function TBallonToolTip.GetHeight: Integer;
var
  aHandle: HWND;
  aRect: TRect;
begin
  aHandle := GetHandle;
  if aHandle <> 0 then
  begin
    GetWindowRect(GetHandle, aRect);
    Result := aRect.Bottom - aRect.Top;
  end
  else if fControl <> nil then
    Result := fControl.Height
  else
    Result := 0;
end;

function TBallonToolTip.GetToolHandle: HWND;
begin
  Result := fHandle;
end;

function TBallonToolTip.GetWidth: Integer;
var
  aHandle: HWND;
  aRect: TRect;
begin
  aHandle := GetHandle;
  if aHandle <> 0 then
  begin
    GetWindowRect(GetHandle, aRect);
    Result := aRect.Right - aRect.Left;
  end
  else if fControl <> nil then
    Result := fControl.Width
  else
    Result := 0;
end;

function TBallonToolTip.IsValidControl: Boolean;
begin
  Result := (fControl is TWinControl) and not (csDestroying in fControl.ComponentState);
end;

procedure TBallonToolTip.LinkClicked;
var
  aProc: TOnBallonLinkClick;
begin
  aProc := fParams.GetOnLinkClick;

  ShowWindow(fHandle, SW_HIDE);

  if Assigned(aProc) then
    aProc(fParams.GetLinkId);

//  PostMessage(fHandle, TTM_POP, 0, 0);
//  Self.Free;
end;

Type
  TCustomFormExt = class(TCustomForm); // <-- Only for access to protected properties

procedure TBallonToolTip.ShowBallon(const aMessage: string);
var
  ti: TTOOLINFO;
  p: TPoint;
  aControlHandle: THandle;
  aForm: TCustomForm;
  x, y, aWidth: Integer;
  aTitle: string;
begin
  AddBallon;
  aControlHandle := GetHandle;
  fHandle := CreateWindow(TOOLTIPS_CLASS,
                          nil,
                          WS_POPUP or TTS_NOPREFIX or TTS_BALLOON{ or $100=TTS_USEVISUALSTYLE},
                          0, 0,
                          0, 0,
                          aControlHandle, 0,
                          hInstance,
                          nil);
  SetWndToolTip(fHandle, self);

  if fControl <> nil then
  begin
    {
    aForm := GetParentForm(fControl);
    if (aForm <> nil) and (TCustomFormExt(aForm).FormStyle = fsStayOnTop) then
      SetWindowPos(fHandle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or
        SWP_NOSIZE or SWP_NOACTIVATE);
    }
    //always topmost
    SetWindowPos(fHandle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or
      SWP_NOSIZE or SWP_NOACTIVATE);
  end;


  ZeroMemory(@ti, SizeOf(ti));
  ti.cbSize := SizeOf(ti);
  ti.uFlags := TTF_TRANSPARENT or TTF_SUBCLASS or TTF_TRACK or $1000{=TTF_PARSELINKS};

  if Assigned(fParams) and (fParams.GetCentred) then
    ti.uFlags := ti.uFlags or TTF_CENTERTIP;

  if IsValidControl then
    ti.uFlags := ti.uFlags or TTF_IDISHWND;

  ti.hwnd := BallonWindow;

  ti.uId := 0;
  if IsValidControl then
    ti.uId := aControlHandle;

  ti.hinst := hInstance;
  ti.lpszText := PChar(aMessage);
  ti.LParam := LParam(Self);

  ti.Rect.TopLeft := ClientToScreen(Point(0, 0));
  ti.Rect.BottomRight := ClientToScreen(Point(GetWidth, GetHeight));

  SendMessage(fHandle, TTM_ADDTOOL, 0, LPARAM(@ti) );
  if Assigned(fParams) then
    SendMessage(fHandle, TTM_SETDELAYTIME, TTDT_INITIAL, 10{fParams.GetTime})
  else
    SendMessage(fHandle, TTM_SETDELAYTIME, TTDT_INITIAL, 10);

  x := -1;
  y := -1;
  if Assigned(fParams) then
  begin
    x := fParams.GetLeft;
    y := fParams.GetTop;
  end;

  if x < 0 then
    x := GetWidth div 2;
  if y < 0 then
    y := GetHeight;
  p := ClientToScreen(Point(x, y));

  if p.x < 0 then
    p.x := 0;
  if p.y < 0 then
    p.y := 0;

  SendMessage(fHandle, TTM_TRACKPOSITION, 0, MakeLong(p.x, p.y));

  aWidth := 0;
  if Assigned(fParams) then
    aWidth := fParams.GetWidth;

  if aWidth = 0 then
    aWidth := Screen.DesktopWidth;
  SendMessage(fHandle, TTM_SETMAXTIPWIDTH, 0, aWidth);

  if Assigned(fParams) then
  begin
    if fParams.GetBkColor <> -1 then
      SendMessage(fHandle, TTM_SETTIPBKCOLOR, WPARAM(fParams.GetBkColor), 0);
    if fParams.GetTextColor <> -1 then
      SendMessage(fHandle, TTM_SETTIPTEXTCOLOR, WPARAM(fParams.GetTextColor), 0);

    if (fParams.GetIcon <> ttiNone) or (fParams.GetTitle <> '') then
    begin
      aTitle := fParams.GetTitle;
      if aTitle = '' then
        aTitle := ' ';
      if (fParams.GetIcon = ttiUser) and (fParams.GetUserIcon <> 0) then
        SendMessage(fHandle, TTM_SETTITLE, WPARAM(Ord(fParams.GetUserIcon)), LPARAM(PChar(aTitle)))
      else
        SendMessage(fHandle, TTM_SETTITLE, WPARAM(Ord(fParams.GetIcon)), LPARAM(PChar(aTitle)));
    end;
  end;
  
  SendMessage(fHandle, TTM_TRACKACTIVATE, WPARAM(TRUE), LPARAM(@ti));
end;

destructor TBallonToolTip.Destroy;
var
  ti: TTOOLINFO;
begin
  ZeroMemory(@ti, SizeOf(ti));
  ti.cbSize := sizeof(ti);
  ti.hwnd := BallonWindow;
  if IsValidControl then
    ti.uId := GetHandle;

  SetWndToolTip(fHandle, nil); // destroy fHandle call object destroy 
  SendMessage(fHandle, TTM_DELTOOL, 0, LParam(@ti));
  Windows.DestroyWindow(fHandle);
  fHandle := 0;
  inherited;
  RemoveBallon;
end;

{ TToolTipParams }

constructor TToolTipParams.Create;
begin
  inherited Create;
  fLeft := -1;
  fTop := -1;
  fTextColor := -1;
  fBkColor := -1;
end;

function TToolTipParams.GetBkColor: TColor;
begin
  Result := fBkColor;
end;

function TToolTipParams.GetCentred: Boolean;
begin
  Result := fCentred;
end;

function TToolTipParams.GetIcon: TToolTipIcon;
begin
  Result := fIcon;
end;

function TToolTipParams.GetLeft: Integer;
begin
  Result := fLeft;
end;

function TToolTipParams.GetLinkId: Integer;
begin
  Result := fLinkId;
end;

function TToolTipParams.GetOnLinkClick: TOnBallonLinkClick;
begin
  Result := fLinkClickProc;
end;

function TToolTipParams.GetTextColor: TColor;
begin
  Result := fTextColor;
end;

function TToolTipParams.GetTime: Integer;
begin
  Result := fTime;
end;

function TToolTipParams.GetTitle: string;
begin
  Result := fTitle;
end;

function TToolTipParams.GetTop: Integer;
begin
  Result := fTop;
end;

function TToolTipParams.GetUserIcon: HICON;
begin
  Result := fUserIcon;
end;

function TToolTipParams.GetWidth: Integer;
begin
  Result := fWidth;
end;

function TToolTipParams.SetBkColor(aValue: TColor): IToolTipParams;
begin
  fBkColor := aValue;
  Result := Self;
end;

function TToolTipParams.SetCentred(aValue: Boolean): IToolTipParams;
begin
  fCentred := aValue;
  Result := Self;
end;

function TToolTipParams.SetIcon(aValue: TToolTipIcon;
  aUserIcon: HICON): IToolTipParams;
begin
  fIcon := aValue;
  fUserIcon := aUserIcon;
  Result := Self;
end;

function TToolTipParams.SetLeft(aValue: Integer): IToolTipParams;
begin
  fLeft := aValue;
  Result := Self;
end;

function TToolTipParams.SetLink(aLinkId: Integer;
  aProc: TOnBallonLinkClick): IToolTipParams;
begin
  fLinkId := aLinkId;
  fLinkClickProc := aProc;
  Result := Self;
end;

function TToolTipParams.SetTextColor(aValue: TColor): IToolTipParams;
begin
  fTextColor := aValue;
  Result := Self;
end;

function TToolTipParams.SetTime(aValue: Integer): IToolTipParams;
begin
  fTime := aValue;
  Result := Self;
end;

function TToolTipParams.SetTitle(const aValue: string): IToolTipParams;
begin
  fTitle := aValue;
  Result := Self;
end;

function TToolTipParams.SetTop(aValue: Integer): IToolTipParams;
begin
  fTop := aValue;
  Result := Self;
end;

function TToolTipParams.SetWidth(aValue: Integer): IToolTipParams;
begin
  fWidth := aValue;
  Result := Self;
end;

end.
