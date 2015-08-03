unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, Math,  SyncObjs,  inifiles, Menus,  StdCtrls,
  UnitConfig, UnitMonitoring, FullScreenUnit, UnitTelevision, IdCustomTCPServer,   IdContext,
  IdTCPServer, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdAntiFreezeBase, IdAntiFreeze;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Colorinqueue1: TMenuItem;
    ColorReady1: TMenuItem;
    ColorDialog1: TColorDialog;
    ColorDialog2: TColorDialog;
    FontDialog1: TFontDialog;
    Font1: TMenuItem;
    StringGrid1: TStringGrid;
    Timer2: TTimer;
    IdTCPClient1: TIdTCPClient;
    IdTCPServer1: TIdTCPServer;
    IdAntiFreeze1: TIdAntiFreeze;
    procedure FormDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Colorinqueue1Click(Sender: TObject);
    procedure ColorReady1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure StringGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Font1Click(Sender: TObject);
    procedure ColorDialog1Close(Sender: TObject);
    procedure ColorDialog2Close(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure IdTCPServer1Execute(AContext: TIdContext);
  private
    { Private declarations }
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
                                                    message WM_GETMINMAXINFO;
  public
    { Public declarations }
  protected
  procedure CreateParams(var Params: TCreateParams); override;

  end;

const MONITORNAME = 'Monitor1';  

var  F: integer;
  Form1: TForm1;
  Screen : IMonitoring;
  ScreenFrame: TFrame;
  hidetaskbar: boolean;
  host: string;
  port: integer;
implementation

{$R *.dfm}
Const   //сдесь определяем Ваш цвет. Так же можно использовать
        //цвета по умолчанию.
  clPaleGreen = TColor($CCFFCC);
  clPaleRed =   TColor($CCCCFF);
  clPaleYellow = TColor($FFFF00);
  clPaleSilver = TColor($C0C0C0);


  REVCOLORMASK = $00FFFFFF;//$7FFFFFFF;
//const
  COLTAG = 0;
  COLQUEUE = 2;
  COLREADY = 1;
  COLPROGRESS = 3;
  //M = 20; //кол-во позиций в очереди
  //M
var ScreenH, ScreenW: integer;
    dH, dW: integer;
    QueueColor, ReadyColor: TColor;  TagFont: TFont;
    M, N: integer;
    fps: integer;
procedure ConfigScreen;
begin
  iniFile:=TINIFile.Create(ExtractFilePath(Paramstr(0))+FILENAMEINI);
  try
    F:=ReadChannel; //0 - сервер (монитор); 1..N - клиент (телевизор)
    M:= ReadScreenRows(MONITORNAME);
    N:= ReadScreenColumns(MONITORNAME);
    fps := ReadTimerInterval(1);
    hidetaskbar := ReadAutoHideTaskbar;

    host:=ReadTCPHost;
    port:=readTCPPort;

  finally
    iniFile.Free;
  end;
end;

procedure FullScreen(Form: TForm);
begin
   if NOT FullScreenHandler.InFullScreenMode then
     FullScreenHandler.Maximize(Form)
   else
     FullScreenHandler.Restore(Form);
//   Form.Hide;
   //!AutohideTaskbar(FullScreenHandler.InFullScreenMode);
//   Form.Show;
   //Form.Refresh;
end;

procedure StringGridDrawCell(StringGrid: TStringGrid; Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; Color: TColor);
begin

//Если ячейка получает фокус, то нам надо закрасить её другими цветами
{if (gdFocused in State) then begin
   StringGrid.Canvas.Brush.Color := clBlack;
   StringGrid.Canvas.Font.Color := clWhite;
end
else}  //Если же ячейка теряет фокус
    StringGrid.Canvas.Brush.color := Color;
//Теперь закрасим ячейки, но только, если ячейка не Title- Row/Column
//Естевственно это завит от того, есть у Вас title-Row/Columns или нет.
(*If (ACol > 0) and (ARow>0) then*)
  begin
      //Закрашиваем бэкграунд
    StringGrid.canvas.fillRect(Rect);
    //InvalidateRect(Form1.Handle, @Rect, False);
      //Закрашиваем текст (Text). Также здесь можно добавить выравнивание и т.д..
    //StringGrid.canvas.TextOut(Rect.Left,Rect.Top,StringGrid.Cells[ACol,ARow]);
    if Assigned(TagFont) then StringGrid.Canvas.Font:=TagFont;
    DrawText(StringGrid.canvas.Handle,PChar(StringGrid.Cells[ACol,ARow]),-1,Rect
    ,DT_SINGLELINE or DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS or DT_NOPREFIX)
  end;
  (*         DT_RIGHT
  else //StringGrid.canvas.TextOut(Rect.Left,Rect.Top,StringGrid.Cells[ACol,ARow]);
    DrawText(StringGrid.canvas.Handle,PChar(StringGrid.Cells[ACol,ARow]),-1,Rect
    ,DT_SINGLELINE or DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS or DT_NOPREFIX)
    *)
end;

procedure DrawCell(StringGrid: TStringGrid; col,row: integer; Rect: TRect; Color: TColor; text: string; font: TFont);
var labeltext: string;
    h,HH: integer;
    FM: Cardinal;
begin
  if text='' then labeltext:=StringGrid.Cells[col,row]
   else labeltext := text;
  HH:=StringGrid.RowHeights[row];
  if Assigned(Font) then StringGrid.Canvas.Font:=Font;

  if pos(#$D#$A,labeltext)>0 then FM := DT_WORDBREAK else FM:=DT_SINGLELINE;
  FM:=FM OR DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS or DT_NOPREFIX;

  repeat
    StringGrid.Canvas.Brush.Color:=Color;
    StringGrid.Canvas.FillRect(Rect);

    h:=DrawText(StringGrid.Canvas.Handle,PChar(labeltext),length(labeltext),Rect,FM);
    if StringGrid.Canvas.Font.Height<=1 then break;
    if h>HH then StringGrid.Canvas.Font.Height:=StringGrid.Canvas.Font.Height div 2;
  until h<=HH;
end;

procedure progressDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Progress: Single;
  R: TRect;
  Txt: String;
begin
  with TStringGrid(Sender) do
    if {(ACol = 4) and} (ARow >= FixedRows) then
    begin        Canvas.Brush.Color := clGray;
      Progress := StrToFloatDef(Cells[ACol, ARow], 0) / 100;
      Canvas.FillRect(Rect);
      R := Rect;
      R.Right := R.Left + Trunc((R.Right - R.Left) * Progress);
      Canvas.Brush.Color := clNavy;
      Canvas.Rectangle(R);
      Txt := Cells[ACol, ARow] + '%';
      Canvas.Brush.Style := bsClear;
      IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
      Canvas.Font.Color := clHighlightText;
      DrawText(Canvas.Handle, PChar(Txt), -1, Rect, DT_SINGLELINE or
        DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS or DT_NOPREFIX);
      SelectClipRgn(Canvas.Handle, 0);
      ExcludeClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
      Canvas.Font.Color := clWindowText;
      DrawText(Canvas.Handle, PChar(Txt), -1, Rect, DT_SINGLELINE or
        DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS or DT_NOPREFIX);
      SelectClipRgn(Canvas.Handle, 0);
    end;
end;


function arrowshift(Y: string):string;
const SPACE=' '; ARROW=#$1A;  PLACEHOLDERS = 3;
var p, l: integer;
    prefix,postfix: string;
begin
  RESULT:=Y;
  l:=length(Y);
  p:=pos(ARROW,Y);
  if p=0 then exit;
  repeat
     dec(p);
     if Y[p]<>SPACE then break;
  until p=1;

  prefix:=copy(RESULT,1,p);

  repeat
    dec(l);
    if Y[l] in [SPACE,ARROW] then break;
  until l<=p;
  postfix:=copy(Y,l+1); //  postfix:=#$A0;

  Y:=copy(Y,p+1,l-p);
  l:=length(Y);
  if l<PLACEHOLDERS then Y:=concat(StringOfChar(SPACE,PLACEHOLDERS-l),Y);
  l:=length(Y);
  p:=pos(ARROW,Y);
  p:=(p+1) mod l;
  Y:=concat(StringOfChar(SPACE,p-1),ARROW,StringOfChar(SPACE,l-p));
  RESULT:=concat(prefix,Y,postfix); // prefix+Y+postfix;
  Y:=RESULT;  //каким боком это влияет???
end;
//procedure blinkCells(StringGrid: TStringGrid);
//const REVCOLORMASK = $7FFFFFFF;
//var i, j: integer;
//  ReverseColor: TColor;
//  
//begin
//  for i := 0 to StringGrid.ColCount - 1 do
//    for j := 0 to StringGrid.RowCount - 1 do
//      if StringGrid.Cells[i,j][length(StringGrid.Cells[i,j])]=#$A0 then
//       begin
//        StringGrid.Canvas.Brush.color := REVCOLORMASK XOR StringGrid.Canvas.Brush.color;
//        StringGrid.canvas.fillRect(Rect);     
//       end;        
//end;

//***************************************************************************//
//                  заполнение грида по таймеру
//***************************************************************************//
procedure reLoadList2Grid(Grid: TStringGrid; Frame: TFrame);// List: TList

var Rec: TOrderDsc; OrderBox: TOrder;
  k, i, j, l: integer;     p: string;
begin
try  try  Grid.DoubleBuffered:=True;//Grid.Hide;
    l:=0;
    if Assigned(Frame) then l:=length(Frame);

    if l=0 then exit;

   if (0<M*N) AND (M*N<l) then
    begin
      M:=0;
      N:=0;
    end;


   if M>0 then Grid.RowCount:=M;
   if N>0 then Grid.ColCount:=N;

   if M * N = 0 then
    if M + N > 0 then
     begin
       if N=0 then Grid.ColCount := 1+ length(Frame) div Grid.RowCount;
       if M=0 then Grid.RowCount := 1+ length(Frame) div Grid.ColCount;
     end
     else
     begin
      k:=0;
      repeat
        inc(k)
      until k*k>=l;
      Grid.RowCount := k; Grid.ColCount := k;
     end;
    Grid.ScrollBars := ssNone;  //ssBoth;
    Grid.DefaultRowHeight := ScreenH div Grid.RowCount;
    Grid.DefaultColWidth := ScreenW div Grid.ColCount;
    Grid.ScrollBars := ssNone;
    if (TagFont=nil)OR(M*N=0)  then     //*для адаптации размера шрифта
     begin    //рамер шрифта не изменяется если жестко задана сетка ячеек
      Grid.Font.Height := Grid.DefaultRowHeight div 2; //3 //-  Grid.DefaultRowHeight
      if TagFont= nil then TagFont:=Grid.Font else TagFont.Size:=Grid.Font.Size;//
     end;

    i:=0; j:=0;
    for k := 0 to l - 1 do
     begin
      Rec := Frame[k];

  //    if Rec.progress < 100 then Grid.Cells[i,j]:=Rec.tag
  //     else Grid.Cells[i,j]:=#$A0+Rec.tag;
      if Rec.state then Grid.Cells[i,j]:=#$A0+Rec.tag
       else Grid.Cells[i,j]:=Rec.tag;
      if Rec.d then Grid.Cells[i,j]:=Grid.Cells[i,j]+#$D#$A+' '+#$1A;

      if Rec.f then Grid.Cells[i,j]:= Grid.Cells[i,j]+#$A0;

      inc(j);
      if j=Grid.RowCount then
       begin
        j:=0; inc(i);
       end;
     end;

    while i*j<Grid.RowCount*Grid.ColCount do
     begin
      if j=Grid.RowCount then
       begin
        j:=0; inc(i);
       end;
      Grid.Cells[i,j]:='';
      inc(j);
     end;

    Grid.ScrollBy(0, ScreenH div Grid.RowCount);
except
  on Err: Exception do  MessageDlg('Error in reload grid: '+Err.Message,mtError,[mbYes],0);
end;
finally    Grid.Invalidate; //Grid.Show;
end;

end;

procedure RefillGridContent(StringGrid: TStringGrid);
var ARow, ACol: integer;
begin
  for ACol := 0 to StringGrid.ColCount - 1 do
   for ARow := 0 to StringGrid.RowCount - 1 do
   if (pos(#$A0,StringGrid.Cells[ACol,ARow])>1) AND (pos(#$1A,StringGrid.Cells[ACol,ARow])>0)then
    StringGrid.Cells[ACol,ARow]:=arrowshift(StringGrid.Cells[ACol,ARow]);
end;
//****************************************************************************

{ TForm1 }

procedure TForm1.ColorDialog1Close(Sender: TObject);
begin
  if ScreenFrame<>nil then   reLoadList2Grid(StringGrid1 , ScreenFrame);
end;

procedure TForm1.ColorDialog2Close(Sender: TObject);
begin
  if ScreenFrame<>nil then   reLoadList2Grid(StringGrid1 , ScreenFrame);
end;

procedure TForm1.Colorinqueue1Click(Sender: TObject);
begin
  if self.ColorDialog1.Execute then QueueColor := self.ColorDialog1.Color;  
end;

procedure TForm1.ColorReady1Click(Sender: TObject);
begin
  if self.ColorDialog2.Execute then ReadyColor := self.ColorDialog2.Color;
end;

procedure TForm1.CreateParams(var Params: TCreateParams);
begin

  inherited CreateParams(Params);
//sleep(5000);
//  with Params do
//    Style := (Style or WS_POPUP) and (not WS_DLGFRAME);;
end;

procedure TForm1.Font1Click(Sender: TObject);
begin
  if TagFont<>nil then self.FontDialog1.Font:=TagFont;
  if self.FontDialog1.Execute then TagFont := self.FontDialog1.Font;
  if ScreenFrame<>nil then   reLoadList2Grid(StringGrid1 , ScreenFrame);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  self.Caption := 'ORDERS MONITOR';
  self.DoubleBuffered:=true;       //чтобы не было мерцания

  SectINI := TCriticalSection.Create;
  SectINI.Enter;
  try
    ConfigScreen;
  finally
    SectINI.Leave;
  end;

  dH:=80; dW:=0;     //20
  ScreenH:=GetDeviceCaps(GetDC(0),VERTRES)-dH;
  ScreenW:=GetDeviceCaps(GetDC(0),HORZRES)-dW;

  ReadyColor:=clGreen;
  QueueColor := clYellow;
  self.ColorDialog1.Color := QueueColor;
  self.ColorDialog2.Color := ReadyColor;
  self.FontDialog1.Font:=stringGrid1.Font;
  //TagFont:=nil;
  if hidetaskbar then AutohideTaskbar(true);
  ShowWindow(Self.Handle ,WS_MAXIMIZE);//BOX


  if F=0 then
   begin
    Dispatcher:= TOrdersDispatcher.Create;
    Screen:= Dispatcher.Monitoring;
    SectINI.Enter;
    try
      Dispatcher.Init;
    finally
      SectINI.Leave;
    end;
    Dispatcher.Resume;

    if port>0 then    //приложение сконфигурировано как сервер
     begin
      BroadCaster := TBroadcaster.Create(Dispatcher.Monitoring, self.IdTCPServer1);
      self.IdTCPServer1.DefaultPort :=Port;
      self.IdTCPServer1.Active := True;
     end;
   end
   else
   begin
    Screen:=TTelevisor.Create(self.IdTCPClient1, F);
    self.IdTCPClient1.Host:=host;
    self.IdTCPClient1.Port := port;
   end; 
end;

procedure TForm1.FormDblClick(Sender: TObject);
var WS: Cardinal;
begin
 // exit;
  WS:=GetWindowLong(handle,GWL_STYLE);
  WS:= WS XOR (WS_DLGFRAME AND NOT WS_POPUP);
  WS:=SetWindowLong(handle,GWL_STYLE,WS);
  //ShowMessage(IntToStr(WS));
  //self.Repaint;
  //self.RecreateWnd;
  //if (WS AND (WS_DLGFRAME AND NOT WS_POPUP)) then

  //ShowWindow(FindWindow('Shell_TrayWnd', nil), sw_hide);
//  ShowWindow(FindWindow('Shell_TrayWnd', nil), 1-sign(WS AND (WS_DLGFRAME AND NOT WS_POPUP)));
//  ShowWindow(FindWindow('Button', nil), 1-sign(WS AND (WS_DLGFRAME AND NOT WS_POPUP)));
  FullScreen(self);
  inc(ScreenH,(2*sign(WS AND (WS_DLGFRAME AND NOT WS_POPUP))-1)*dH);    // 1-
  //showMessage(IntToStr(2*sign(WS AND (WS_DLGFRAME AND NOT WS_POPUP))-1));
  if ScreenFrame<>nil then   reLoadList2Grid(StringGrid1 , ScreenFrame);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  try
    ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_NORMAL);;
  except
    on Err: Exception do
      MessageDlg(Err.Message,mtError,[mbYes],0);
  end;
  //Screen._Release;

  if F=0 then
   begin
    if port>0 then
     begin
      self.IdTCPServer1.Active:=False;
      BroadCaster.Free;
     end;
     

      Dispatcher.Free;
      SectINI.Free;
   end;

  if hidetaskbar then AutohideTaskbar(false);
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=27 then
   begin
    if (WS_DLGFRAME AND NOT WS_POPUP) AND GetWindowLong(handle,GWL_STYLE)=0 then
     self.FormDblClick(Sender);
    ShowWindow(FindWindow('Shell_TrayWnd', nil), SW_NORMAL);
    ShowWindow(FindWindow('Button', nil), SW_NORMAL);
   end;
end;

procedure TForm1.IdTCPServer1Execute(AContext: TIdContext);
begin
  BroadCaster.Session(AContext);
end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
begin
  self.FormDblClick(Sender);
end;

procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var StateColor: Integer;    //clGreen  clYellow
    p:TPoint;   ColStr: string;   flag: boolean;
begin
 if not Screen.live then
 begin
   StringGridDrawCell(self.StringGrid1,Sender,ACol,ARow,Rect,State,clRed);
   self.Caption := Screen.getError;
   exit;
 end;
 self.Caption:='ORDERS MONITOR';

 if pos(#$A0,self.StringGrid1.Cells[ACol,ARow])>1 then
  if (pos(#$1A,self.StringGrid1.Cells[ACol,ARow])>0) then
   if self.StringGrid1.Tag=0 then
    begin
     { if pos(' '+#$1A,self.StringGrid1.Cells[ACol,ARow])>0 then
        self.StringGrid1.Cells[ACol,ARow]:=StringReplace(self.StringGrid1.Cells[ACol,ARow],' '+#$1A,#$1A+' ',[])
       else
        self.StringGrid1.Cells[ACol,ARow]:=StringReplace(self.StringGrid1.Cells[ACol,ARow],#$1A+' ',' '+#$1A,[]);
 } //    Copy(self.StringGrid1.Cells[ACol,ARow],1,1)=#$A0;
      self.StringGrid1.Cells[ACol,ARow]:=arrowshift(self.StringGrid1.Cells[ACol,ARow]);
      self.StringGrid1.Tag:=1;
      StringGridDrawCell(self.StringGrid1,Sender,ACol,ARow,Rect,State,clSilver);  //clAquaREVCOLORMASK XOR self.StringGrid1.Font.Color
      self.StringGrid1.DoubleBuffered:=false;
      self.StringGrid1.Update;
      exit;
    end
    else
    begin
      self.StringGrid1.Tag:=0;
      exit;
    end;

 if Copy(self.StringGrid1.Cells[ACol,ARow],1,1)=#$A0 then StateColor:=ReadyColor else StateColor:=QueueColor;

 if Copy(self.StringGrid1.Cells[ACol,ARow],length(self.StringGrid1.Cells[ACol,ARow]),1)=#$A0 then
  begin
   p:=StringGrid1.CellRect(ACol,ARow).TopLeft;
   p.X:=p.X+1;
   p.Y:=p.Y+1;
   //ColStr := ColorToString(StringGrid1.Canvas.Pixels[P.X,P.Y]);
   if (StringGrid1.Canvas.Pixels[P.X,P.Y])*(REVCOLORMASK - StringGrid1.Canvas.Pixels[P.X,P.Y])=0 then
     StringGrid1.Canvas.Pixels[P.X,P.Y]:=StateColor //на первый раз
    else
      if (REVCOLORMASK XOR StringGrid1.Canvas.Pixels[P.X,P.Y]) = ReadyColor then
        StringGrid1.Canvas.Pixels[P.X,P.Y]:=QueueColor
       else StringGrid1.Canvas.Pixels[p.X,p.Y]:=ReadyColor;   


   StateColor := REVCOLORMASK XOR StringGrid1.Canvas.Pixels[P.X,P.Y];
   flag:=True;
   //ColStr:=Concat(ColStr,'-->'+ColorToString(REVCOLORMASK XOR StringGrid1.Canvas.Pixels[P.X,P.Y])+'-->'+ColorToString(StateColor));
   //InputBox('Color','',ColStr);
   //StringGrid1.Canvas.Pixels[P.X,P.Y]:=StateColor;
  end
  else flag:=false;



 StringGridDrawCell(self.StringGrid1,Sender,ACol,ARow,Rect,State,StateColor);
 if flag then
  begin
    self.StringGrid1.DoubleBuffered:=false;
    self.StringGrid1.Update;
    //self.StringGrid1.DoubleBuffered:=True;
  end;
end;

procedure TForm1.StringGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  self.FormKeyUp(Sender,Key,Shift);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
self.Timer1.Enabled:=False;
try
    self.Timer2.Enabled := False;
    if fps = 0 then
     try
      SectINI.Enter;
      fps := ReadTimerInterval(1);
     finally
      SECTINI.Leave;
     end
     else
     begin
      //этого нельзя делать - уничтожается объект по ссылке! FreeAndNil(OrdersList);
      ScreenFrame:=Screen.getFrameFromChannel(F);
      if ScreenFrame<>nil then   reLoadList2Grid(StringGrid1 , ScreenFrame);;
     end;
    if fps>0 then self.Timer1.Interval := 1000*fps;   //fixed ошибка инициализации таймера
finally
self.Timer2.Enabled := True;
self.Timer1.Enabled:=True;
end;

    //   finally
//
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  {RefillGridContent(StringGrid1);}
  //self.StringGrid1.DoubleBuffered := False;
  self.StringGrid1.Invalidate; //Form1.StringGrid1.Repaint;
end;

procedure TForm1.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
var
 Sz : SIZE;
begin
 Sz := FullScreenHandler.MaxSize;
 with Message.MinMaxInfo^ do begin
   ptMaxSize := TPoint(Sz);
   ptMaxTrackSize := TPoint(Sz);
 end;
 inherited;
end;

end.
