library Project1dllHook;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  Windows,Messages,Graphics, Dialogs;//
type  bit = 0..1;
const WM_NAVWIN_STATE = WM_USER + $40;
      WM_NAVWIN_SCALE = WM_USER + $48;
      WM_NAVWIN_HOOK =  WM_USER + $64;
      WM_NCUAHDRAWCAPTION = $00AE;
      WM_NCUAHDRAWFRAME = $00AF;
var
  HH : THandle;
  Status: byte;
  ga: bit;
{$R *.res}

//procedure WMNAVWINState(var Msg: TMessage); message WM_NAVWIN_STATE;
//begin
//
//end;

procedure WMNCPaint(HW: HWND; Color:TColor; Tag: string); //var Msg: TWMNCPaint;
var
  TitleRect,WinRect: TRect;
  Brush : TBrush;
  DC:Cardinal;
  pWndTitle:PAnsiChar; l:integer;
  x0,x,y0,y: integer;
  W,g,h,dh,dg: integer;
  var fnt,oldFnt:HFONT;
begin
  //inherited;
  DC := GetWindowDC(HW);//
try
    GetWindowRect(HW,WinRect);
    x0:=0;
    y0:=0;

    g:= GetSystemMetrics(SM_CXSIZE);
     dg:=GetSystemMetrics(SM_CXICON);
    h:= GetSystemMetrics(SM_CYCAPTION);
     dh:=GetSystemMetrics(SM_CXBORDER);
    W:= WinRect.Right-WinRect.Left;

        //TitleRect :=  Bounds(WinRect.Left+dg,WinRect.Top+4*dh, WinRect.Right-WinRect.Left-3*g-2*dg,h);

//    Bounds(GetSystemMetrics(SM_CXFRAME) +
//      GetSystemMetrics(SM_CXSIZE) + 1,
//      GetSystemMetrics(SM_CYFRAME),
//      GetSystemMetrics(SM_CXSIZE),
//      GetSystemMetrics(SM_CYSIZE));

(*
      Brush := TBrush.Create;
      try
        Brush.Color := Color;
        //FillRect(DC, Rect(WinRect.Left,WinRect.Top{+4*dh}, WinRect.Right-WinRect.Left-3*g-2*dg,h), Brush.Handle);//Rect(WinRect.Left,WinRect.Top,WinRect.Right,WinRect.Bottom)
        //FillRect(DC,Rect(0,0,W-3*g-2*dg,h), Brush.Handle); //WinRect.Right-WinRect.Left
        //UpdateWindow(HW);
      finally
        Brush.Free;
      end;

*)
    SetBkColor(DC,ColorToRGB(Color));
    l:=length(Tag);
    pWndTitle:=GetMemory(l+1);//GetWindowTextLength(HW)+1
try
     pWndTitle:=PAnsichar(Tag);
      //GetWindowText(HW,pWndTitle,GetWindowTextLength(HW)+1);
      //SetWindowText(HW,pWndTitle);
fnt:=CreateFont(-16*(1+2*ga){48}, 0, 0, 0, FW_BOLD, 0, 0, 0, DEFAULT_CHARSET,
OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,
DEFAULT_PITCH or FF_DONTCARE, 'Tahoma');
oldFnt:=SelectObject(dc,fnt);

      //TextOut(DC,W-3*g-2*dh{-10*l},h+8*dh,pWndTitle,l); //WinRect.Top+
      //TextOut(DC,W-4*3*g-4*dh{-10*l},h+8*dh,pWndTitle,l);
      TextOut(DC,W-(1+3*ga)*3*g-2*g*(1-ga)-(3*g div 2){(1+ga)*dh},  h+8*dh,pWndTitle,l);
SelectObject(dc,oldFnt);
DeleteObject(fnt);
finally
    FreeMemory(pWndTitle);
end;

finally
  ReleaseDC(HW, DC);
end;
//  with Canvas do
//  begin
//    pen.Color:=clred;
//    TextOut(R.Left,R.Top+2,'Тут надпись');
//  end;

end;

 function ChangeStatus(Wnd:HWND;newStatus: byte):boolean;
 var RGN: HRGN; Rect: TRect;
 begin
  RESULT:=false;
  if Status=newStatus then exit;
  Status:=newStatus;
  //if GetWindowRgn(Wnd,RGN)=ERROR then exit;
  //RedrawWindow(Wnd,nil,0,RDW_INVALIDATE);
  //InvalidateRgn(Wnd,RGN,true);
  //PostMessage(Wnd,WM_PAINT,RGN,0);
  GetWindowRect(Wnd,Rect);
  InvalidateRect(Wnd,@Rect,true);
  RedrawWindow(Wnd, @Rect, 0, RDW_FRAME or RDW_INTERNALPAINT
    or RDW_INVALIDATE or WM_ERASEBKGND  or RDW_ALLCHILDREN
    or RDW_ERASENOW or RDW_UPDATENOW);
  DrawMenuBar(Wnd);
 end;

 function ChangeScale(Wnd:HWND;newScale: byte):boolean;
 var Rect: TRect;
 begin
  RESULT:=false;
  if ga=newScale then exit;
  ga:=newScale;

  GetWindowRect(Wnd,Rect);
  InvalidateRect(Wnd,@Rect,true);
  RedrawWindow(Wnd, @Rect, 0, RDW_FRAME or RDW_INTERNALPAINT
    or RDW_INVALIDATE or WM_ERASEBKGND  or RDW_ALLCHILDREN
    or RDW_ERASENOW or RDW_UPDATENOW);
  DrawMenuBar(Wnd);
 end;
 function ProcessHook(WMsgDesc: TCWPRetStruct):LResult; stdcall; //
 var Tag,Title: string; pWndTitle: PAnsiChar;
     pp, l: integer;
     bc: byte;
     cl: TColor;
     F:Cardinal;
 begin
   Case WmsgDesc.message of
    WM_NAVWIN_STATE :  ChangeStatus(WmsgDesc.hwnd,$F AND WmsgDesc.wParam);// Status:=
    WM_NAVWIN_SCALE:   ChangeScale(WmsgDesc.hwnd, $1 AND WmsgDesc.wParam);
    WM_NAVWIN_HOOK  :  HH:= WmsgDesc.wParam;
   End;


   F:= WMsgDesc.message;
   F:= (F - WM_NCPAINT) * (F - WM_NCUAHDRAWCAPTION) * (F - WM_SIZE) * (F - WM_MOVE) * (F - WM_ACTIVATE) * (F - WM_NCACTIVATE);
   if (WMsgDesc.message = WM_NCPAINT)OR(F=0) then  // OR (WMsgDesc.message = WM_PAINT)
    begin
     l:=GetWindowTextLength(WMsgDesc.hwnd);
     pWndTitle:=GetMemory(l+1);
try
        l:= GetWindowText(WMsgDesc.hwnd,pWndTitle,l+1);
        if l>0 then
             begin
              Title := copy(pWndTitle,1,l);
              //l:=length(Title);
              pp:= pos(#$A0,Title);
              if pp*Status>0  then
               try
                     //begin
                  case Status of
                   0: cl:=clBlack; //$00000000
                   1: cl:=clBlue;  //$000000FF
                   2: cl:=clLime;  //$0000FF00
                   3: cl:=clAqua; //$0000FFFF
                   4: cl:=clRed;  //$00FF0000
                   5: cl:=clFuchsia;//$00FF00FF
                   6: cl:=clYellow; //$00FFFF00
                   7: cl:=clWhite; //$00FFFFFF;
                   else exit;
                  end;

                   case Status of
                     2: Tag:='===TEST===';
                     3: Tag:='*DEVELOPER*';
                     4: Tag:='!PRODUCTIVE!';
                     6: Tag:='? UNKNOWN  ?';
                     else Tag :=  '            '
                   end;
                  //ShowMessage('do something');

                  WMNCPaint(WMsgDesc.hwnd,cl,Tag);      ;
                 exit;
               except
                 exit;
               end ;// else exit
              if (pp>0)AND(pp+1<l) then
               if Title[pp+2]=#$A0 then
                begin
                  bc:=Ord(Title[pp+1]);
                  //ShowMessage(IntToStr(bc));
                  case bc of
                   0: cl:=clBlack; //$00000000
                   1: cl:=clBlue;  //$000000FF
                   2: cl:=clLime;  //$0000FF00
                   3: cl:=clAqua; //$0000FFFF
                   4: cl:=clRed;  //$00FF0000
                   5: cl:=clFuchsia;//$00FF00FF
                   6: cl:=clYellow; //$00FFFF00
                   7: cl:=clWhite; //$00FFFFFF;
                   else exit;
                  end;
                  pWndTitle:=PAnsiChar(Title);
                   case bc of
                     2: Tag:='=TEST=';
                     3: Tag:='*DEVELOPER*';
                     4: Tag:='!PRODUCTIVE!';
                     6: Tag:= '?UNKNOWN?';
                     else Tag :=  ''
                   end;
                  //ShowMessage('do something');

                  WMNCPaint(WMsgDesc.hwnd,cl,Tag);
                end;
             end;
finally
      FreeMemory(pWndTitle);
end;
    end;
 end;

 function WndHook(code, wParam, lParam : integer): Lresult; stdcall;
 var pStruct: ^TCWPRetStruct; //
 begin
   if code=HC_ACTION then
    //if wParam<>0 then
try
try
          pStruct:=Pointer(lParam);
          ProcessHook(pStruct^);  
except on E: Exception do
end;
finally
    if HH>0 then
    try
     RESULT:=CallNextHookEx(HH, code, wParam, lParam);
    except on E: Exception do
    end;
end;


 end;

 function InstallHook(dll: Cardinal): boolean;      stdcall;
 begin
   HH:=SetWindowsHookEx(WH_CALLWNDPROCRET,@WndHook,dll,0); //
   RESULT:=HH>0;
 end;

 function UninstallHook: boolean;                  stdcall;
 begin
  RESULT:=false;
  if HH>0 then
   RESULT:=UnhookWindowsHookEx(HH);
 end;

 function SetUpHook(dll: Cardinal; WindowID: HWND): Cardinal;   stdcall;
 var ThreadID: Cardinal;
 begin
  RESULT:=0;
try
    ThreadID:=GetWindowThreadProcessId(WindowID);
    if ThreadID>0 then
     RESULT:=SetWindowsHookEx(WH_CALLWNDPROCRET,@WndHook,dll,ThreadID);
    if RESULT>0 then PostThreadMessage(ThreadID,WM_NAVWIN_HOOK,RESULT,0);
    
except on E: Exception do
end;
 end;

 function ReSetHook(HookID: Cardinal): boolean;    stdcall;
 begin
   RESULT:=False;
   if HookID>0 then
   try
     //PostThreadMessage(ThreadID,WM_NAVWIN_HOOK,0,0);
     RESULT:=UnhookWindowsHookEx(HookID);
   except

   end;
 end;

 exports
  SetupHook, ResetHook,
  InstallHook, UninstallHook;
begin
ga:=1;
end.
