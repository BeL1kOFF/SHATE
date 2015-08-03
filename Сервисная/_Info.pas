unit _Info;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, DBCtrls, Buttons, JvComponentBase,
  JvFormPlacement, MSHTML_TLB, ExtCtrls;

const
  WM_THREAD_COMPLETE = WM_USER + 1;

 type
  TOpenThrd = class(TThread)
  hWin:HWnd;
  Browser: TWebBrowser;
  SelectBrand:String;
  protected
    procedure Execute; override;
  end;

type
  TInfo = class(TForm)
    Browser: TWebBrowser;
    BitBtn1: TBitBtn;
    JvFormStorage1: TJvFormStorage;
    HideCheckBox: TDBCheckBox;
    HideNewInProg: TDBCheckBox;
    Button1: TButton;
    Bevel1: TBevel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BrowserVisible(ASender: TObject; Visible: WordBool);
    procedure HandleThreadCompletion(var Message: TMessage); message WM_THREAD_COMPLETE;
    procedure BitBtn1Click(Sender: TObject);
    procedure BrowserBeforeNavigate2(ASender: TObject; const pDisp: IDispatch;
      var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    SelectBrand:String;
    { Public declarations }
  end;

var
  Info: TInfo;

implementation

uses _Data, _Main, ShellAPI;

{$R *.dfm}

procedure TInfo.HandleThreadCompletion(var Message: TMessage);
var  Txt: IHTMLTxtRange;
     Doc:IHTMLDocument2;
     Body:IHTMLBodyElement;
Begin
     if Length(SelectBrand)<1 then
        exit;
        while Browser.Busy do
           Sleep(20);
        Doc := Browser.Document as IHTMLDocument2;
        Body := Doc.body as IHTMLBodyElement;
        if Body <> nil then
        begin

          Txt := Body.createTextRange;
          if Txt.findText( SelectBrand, Length(SelectBrand), 0)  then
          begin
            Browser.OleObject.Document.ParentWindow.ScrollBy(0,Browser.OleObject.Document.Body.ScrollHeight);
            Txt.scrollIntoView(True);
          end;
        end;
End;

procedure TInfo.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrOK;
  Close; //for not modal mode
end;

procedure TInfo.BrowserBeforeNavigate2(ASender: TObject; const pDisp: IDispatch;
  var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
  var Cancel: WordBool);
var
  aUrl: string;
  isExternal: Boolean;
begin
  aUrl := URL;

  isExternal := False;
  if SameText( Copy(aURL, 1, 7), 'http://') then
  begin
    isExternal := True;
    Delete(aURL, 1, 7);
    if not SameText( Copy(aURL, 1, 4), 'www.') then
      aURL := 'www.' + aUrl;
    aUrl := 'http://' + aUrl;
  end
  else
    if SameText( Copy(aURL, 1, 4), 'www.') then
    begin
      isExternal := True;
      aUrl := 'http://' + aUrl;
    end;

  if isExternal then
  begin
    Cancel := True;
//    if Application.MessageBox('Перейти по внешней ссылке?', 'Подтверждение', MB_YESNO) = mrYes then
    ShellExecute(Handle, nil, PAnsiChar(aURL), nil, nil, SW_SHOW);
  end;
end;

procedure TInfo.BrowserVisible(ASender: TObject; Visible: WordBool);
var
  Txt: IHTMLTxtRange;
  Doc:IHTMLDocument2;
  Body:IHTMLBodyElement;
begin
    if Visible = FALSE Then
     exit;

    if Length(SelectBrand)<1 then
      exit;

     try
      while Browser.Busy do
            Sleep(20);
      Doc := Browser.Document as IHTMLDocument2;
      Body := Doc.body as IHTMLBodyElement;
      Browser.OleObject.Document.ParentWindow.ScrollBy(0,Browser.OleObject.Document.Body.ScrollHeight);
      Txt := Body.createTextRange;
      if Txt.findText( SelectBrand, Length(SelectBrand), 0)  then
        Txt.scrollIntoView(True);

      except

      on e: Exception do

      end;
end;

procedure TInfo.Button1Click(Sender: TObject);
var
  OpenThrd:TOpenThrd;
begin
   try
      OpenThrd := TOpenThrd.Create(TRUE);
      OpenThrd.Browser := Browser;
      OpenThrd.FreeOnTerminate := True;
      OpenThrd.SelectBrand :=SelectBrand;
      OpenThrd.hWin := Handle;
      OpenThrd.Resume;
  except
    on e: Exception do
        MessageDlg(e.Message,mtWarning,[mbOk],0);
    end;

end;

procedure TOpenThrd.Execute;
var
     Doc:IHTMLDocument2;
     Body:IHTMLBodyElement;
Begin
     if Length(SelectBrand)<1 then
        exit;

     while True do
     begin
        while Browser.Busy do
           Sleep(20);
        Doc := Browser.Document as IHTMLDocument2;
        Body := Doc.body as IHTMLBodyElement;
        if Body <> nil then
        begin
          PostMessage(hWin, WM_THREAD_COMPLETE, 0, 0);
          break;
        end;
        Sleep(20);
    end;
End;

procedure TInfo.FormActivate(Sender: TObject);
var
  OpenThrd:TOpenThrd;
begin
  Self.BringToFront;
   try
      OpenThrd := TOpenThrd.Create(TRUE);
      OpenThrd.Browser := Browser;
      OpenThrd.FreeOnTerminate := True;
      OpenThrd.SelectBrand :=SelectBrand;
      OpenThrd.hWin := Handle;
      OpenThrd.Resume;
  except
    on e: Exception do
        MessageDlg(e.Message,mtWarning,[mbOk],0);
    end;
end;

procedure TInfo.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

begin
  if Key = VK_ESCAPE then
    Close;


end;

procedure TInfo.FormShow(Sender: TObject);
begin
  SetWindowPos(Handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
end;

end.
