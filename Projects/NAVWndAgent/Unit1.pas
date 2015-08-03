unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ActiveX, OleCtnrs, Axctrls, ComObj,ShellAPI
  , UnitNAV, UnitExtern, UNitCOMServerNAV, Menus, Grids, StdCtrls, Buttons, ActnList
  ,Unit2;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    StringGrid1: TStringGrid;

    BitBtn1: TBitBtn;
    Button1: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    RadioGroup1: TRadioGroup;
    ComboBox3: TComboBox;
    ActionList1: TActionList;
    Action1Cfg: TAction;
    Action2Run: TAction;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    OpenDialog1: TOpenDialog;
    PopupMenu2: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Action3Monitoring: TAction;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure Action1CfgExecute(Sender: TObject);
    procedure Action2RunExecute(Sender: TObject);
    procedure Action3MonitoringExecute(Sender: TObject);
  private
    { Private declarations }
    FIconData:TNotifyIconData;
  protected
    procedure WndProc(var Msg: TMessage); Override;
    procedure ControlWindow(var Msg: TMessage); message WM_SYSCOMMAND;  
  public
    { Public declarations }
    var CellRow, CellColumn: integer;
        EditMode: boolean;
  end;

CONST GUIDAPPBASE ='{50000004-0000-1000-0010-0000836BD2D2}';
      GUIDHYPERLINK = '{50000004-0000-1000-0000-0000836BD2D2}';

var
  Form1: TForm1;
procedure StringGridDrawCell(StringGrid: TStringGrid; Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; Color: TColor);
implementation

{$R *.dfm}

procedure writelog(Msg: string);
const Filelog='C:\NAVWindowsAgent.log';
var ff: text;
begin
Assign(ff,filelog);
if FileExists(filelog)  then Append(ff) else Rewrite(ff);
try
  writeln(ff,DateTimeToStr(Now())+#9+Msg);
finally
  CloseFile(ff);
end;

end;

procedure StringGridDrawCell(StringGrid: TStringGrid; Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; Color: TColor);
begin

//Если ячейка получает фокус, то нам надо закрасить её другими цветами
if {(gdFocused in State)AND} (Form1.EditMode) AND (ARow=Form1.CellRow) AND (ACol<2)   then
 begin
   StringGrid.Canvas.Brush.Color := StringGrid.Color; //clBlack;
   StringGrid.Canvas.Font.Color := clGrayText;//clWhite;
 end
else  //Если же ячейка теряет фокус
    StringGrid.Canvas.Brush.color := Color;
//Теперь закрасим ячейки, но только, если ячейка не Title- Row/Column
//Естевственно это завит от того, есть у Вас title-Row/Columns или нет.
If (ACol > StringGrid.FixedCols-1) and (ARow>StringGrid.FixedRows-1) then
  begin
      //Закрашиваем бэкграунд
    StringGrid.canvas.fillRect(Rect);
      //Закрашиваем текст (Text). Также здесь можно добавить выравнивание и т.д..
    //StringGrid.canvas.TextOut(Rect.Left,Rect.Top,StringGrid.Cells[ACol,ARow]);
    //if Assigned(TagFont) then StringGrid.Canvas.Font:=TagFont;
    DrawText(StringGrid.canvas.Handle,PChar(StringGrid.Cells[ACol,ARow]),-1,Rect
    ,DT_SINGLELINE or DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS or DT_NOPREFIX)
  end;
  (*         DT_RIGHT
  else //StringGrid.canvas.TextOut(Rect.Left,Rect.Top,StringGrid.Cells[ACol,ARow]);
    DrawText(StringGrid.canvas.Handle,PChar(StringGrid.Cells[ACol,ARow]),-1,Rect
    ,DT_SINGLELINE or DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS or DT_NOPREFIX)
    *)
end;



procedure TForm1.Action1CfgExecute(Sender: TObject);
begin
  self.EditMode:=True;
  Self.Action2Run.Enabled := False;
  self.Button1.Caption := 'Сохранить изменения';
  case self.CellColumn of
   0: self.ComboBox1.SetFocus;
   1: self.ComboBox2.SetFocus;
   2: self.RadioGroup1.SetFocus;
  end;

end;

procedure TForm1.Action2RunExecute(Sender: TObject);
begin
  if StringGrid1.Row<StringGrid1.FixedRows then exit;
  if Self.Edit1.Text='' then
    if OpenDialog1.Execute then
      NAVCOM.fileexe:=OpenDialog1.FileName
     else exit;
  NAVCOM.RunHostApplication(StringGrid1.Row-StringGrid1.FixedRows);
end;

procedure TForm1.Action3MonitoringExecute(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  if MessageDlg('Записать в файл текущую конфигурацию?',mtConfirmation,mbOKCancel,0)<>mrOK then exit;

  if NAVCOM.SaveConfiguration then
     MessageDlg('Конфигурационный файл успешно обновлён',mtInformation,[mbOK],0)
   else
     MessageDlg('Внимание! Не удалось сохранить текущие настройки и после закрытия программы они могут быть утеряны',mtWarning,[mbCancel],0);
end;

procedure TForm1.Button1Click(Sender: TObject);
var N: integer; cb: byte;
begin
  if self.EditMode then
   begin  //в режиме редактирования изменяются записи таблице
     case MessageDlg('Запись могла быть изменена. Для сохранения изменений нажмите "OK"',mtConfirmation,[mbOK, mbCancel],0) of
      mrOK:
            begin
              NAVCOM.Reconfig(CellRow-self.StringGrid1.FixedRows, self.StringGrid1.Cells[0,CellRow], self.StringGrid1.Cells[1,CellRow], ORD(self.StringGrid1.Cells[2,CellRow][1]));
            end;
      mrCancel:
            begin
              self.StringGrid1.Cells[0,CellRow]:=NAVCOM.ServersSet[CellRow-self.StringGrid1.FixedRows];
              self.StringGrid1.Cells[1,CellRow]:=NAVCOM.DatabasesSet[CellRow-self.StringGrid1.FixedRows];
              self.StringGrid1.Cells[2,CellRow]:=NAVCOM.KindsSet[CellRow-self.StringGrid1.FixedRows];
            end;
     end;
     self.EditMode :=False;
     Self.Action2Run.Enabled := True;
     self.StringGrid1.EditorMode:=False;
     self.StringGrid1.Options:=self.StringGrid1.Options-[goEditing];
     self.Button1.Caption := 'Добавить в настройки';
     self.StringGrid1.Refresh; //exit;
   end
   else
   begin //в режиме вставки добавляется заись в конец
      N:=  self.StringGrid1.RowCount  ;
      self.StringGrid1.RowCount:=N+1;
      self.StringGrid1.Cells[0,N]:=self.ComboBox1.Text;
      self.StringGrid1.Cells[1,N]:=self.ComboBox2.Text;
      case self.RadioGroup1.ItemIndex of
       0: self.StringGrid1.Cells[2,N]:=chr(2)+'TEST';
       1: self.StringGrid1.Cells[2,N]:=chr(3)+'DEVELOPER';
       2: self.StringGrid1.Cells[2,N]:=chr(4)+'PRODUCTIVE';
       3: self.StringGrid1.Cells[2,N]:=chr(6)+'UNKNOWN';
      end;
      NAVCOM.Reconfig(N-self.StringGrid1.FixedRows, self.StringGrid1.Cells[0,N], self.StringGrid1.Cells[1,N], ORD(self.StringGrid1.Cells[2,N][1]));
   end;
   self.Refresh;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
 if self.EditMode then 
 if CellColumn=0 then
  self.StringGrid1.Cells[CellColumn,CellRow]:=self.ComboBox1.Text;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
 if self.EditMode then  
 if CellColumn=1 then
  self.StringGrid1.Cells[CellColumn,CellRow]:=self.ComboBox2.Text;
end;

procedure TForm1.ComboBox3Change(Sender: TObject);
begin
  if  self.ComboBox3.ItemIndex>=0 then
    NAVCOM.ChangeScale(self.ComboBox3.ItemIndex);
end;

procedure TForm1.ControlWindow(var Msg: TMessage);
begin
  // Если в заголовке окна программы нажаты кнопки Закрыть или Свернуть,
  // скрываем форму
  case Msg.WParam of
    SC_MINIMIZE:
      ShowWindow(Handle, SW_HIDE);
    SC_CLOSE:
      case MessageDlg('Завершить работу агента?  Выберите "Yes" для завершения; для минимизации в трей выберите "No"',mtConfirmation,mbYesNoCancel,0) of
       mrYes: inherited;
       mrNo: ShowWindow(Handle, SW_HIDE);
       mrCancel: exit;
      end;
    else
      inherited;
  end;
end;

procedure LoadCombobox(Combobox: TComboBox;Strings: TStrings; shift: integer);
var j,N: integer;
begin
  COmbobox.Text:= ' < '+Strings[0]+' > ';
  N:=Strings.Count;
  for j := 0 to N - 1 do
   if (j>=shift) AND (Combobox.Items.IndexOf(Strings[j])<0) then
    Combobox.AddItem(Strings[j],nil);
end;

procedure LoadConfigurationGrid(StringGrid: TStringgrid; NAVServer: TNAVCOMServer);
var i,j,M,N: integer;
begin
  StringGrid.Cells[0,0]:= 'SERVER';
  StringGrid.Cells[1,0]:= 'DB';
  StringGrid.Cells[2,0]:= 'TYPE';
  StringGrid.RowCount := StringGrid.FixedRows + NAVServer.ConfigsNumber;
  N:=StringGrid.RowCount;
  M:=StringGrid.ColCount;

  for j := 0 to N - 1 do
   //for i := 0 to M - 1 do
    begin
      StringGrid.Cells[0,StringGrid.FixedRows +j]:=NAVServer.ServersSet[j];
      StringGrid.Cells[1,StringGrid.FixedRows +j]:=NAVServer.DatabasesSet[j];
      StringGrid.Cells[2,StringGrid.FixedRows +j]:=NAVServer.KindsSet[j];
    end; 
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  self.Caption := 'NAV Windows Agent';

  NAVCOM:=TNAVCOMServer.Create;
  self.ComboBox3.ItemIndex := NAVCOM.LoadScale(self.ComboBox3.Items.Count-1);

  LoadConfigurationGrid(self.StringGrid1,NAVCOM);
  self.Button1.Caption:='Добавить в настройки';
  LoadCombobox(self.ComboBox1,self.StringGrid1.Cols[0],self.StringGrid1.FixedRows);
  LoadCombobox(self.ComboBox2,self.StringGrid1.Cols[1],self.StringGrid1.FixedRows);
  Self.RadioGroup1.Caption := 'Выбор типа базы';

  Self.CheckBox1.Caption := 'Запускать NAV по двойному щелчку';
  Self.Edit1.Enabled := False;
  Self.Edit1.Text := NAVCOM.LoadHostApplPathName;
  Self.Action1Cfg.Caption := 'Редактировать';
  Self.Action2Run.Caption := 'Запустить';
  Self.Action3Monitoring.Caption := 'Мониторинг';

  Form2:=TForm2.Create(self);

  Application.ShowMainForm:=False;
  // Подготавливаем иконку для System Tray
  with FIconData do begin
    cbSize:=SizeOf(FIconData);
    Wnd:=Handle;
    uID:=100;
    uFlags:=NIF_MESSAGE+NIF_ICON+NIF_TIP;
    uCallbackMessage:=WM_USER+1;
    hIcon:=Application.Icon.Handle;
    szTip:='NAV Windows Agent';
  end;
  // Все готово - помещаем иконку в System Tray
  Shell_NotifyIcon(NIM_ADD, @FIconData);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  NAVCOM.SaveScale(self.ComboBox3.ItemIndex);  //обновление ini-файла
  NAVCOM.SaveHostAppPathName;
  // Перед уничтожение формы удаляем иконку из SysTray
  Shell_NotifyIcon(NIM_DELETE, @FIconData);
  NAVCOM.Free;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  self.Close;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  ShowWindow(Handle, SW_NORMAL);
  self.Show;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  if CellRow<self.StringGrid1.FixedRows then exit;
  if self.EditMode then  
    case self.RadioGroup1.ItemIndex of
     0: self.StringGrid1.Cells[2,CellRow]:=chr(2)+'TEST';
     1: self.StringGrid1.Cells[2,CellRow]:=chr(3)+'DEVELOPER';
     2: self.StringGrid1.Cells[2,CellRow]:=chr(4)+'PRODUCTIVE';
     3: self.StringGrid1.Cells[2,CellRow]:=chr(6)+'UNKNOWN';
    end;
end;

procedure TForm1.StringGrid1Click(Sender: TObject);
begin
  if self.EditMode then
   begin  //в режиме редактирования изменяются записи таблице
    self.StringGrid1.Cells[0,CellRow]:=NAVCOM.ServersSet[CellRow-self.StringGrid1.FixedRows];
    self.StringGrid1.Cells[1,CellRow]:=NAVCOM.DatabasesSet[CellRow-self.StringGrid1.FixedRows];
    self.StringGrid1.Cells[2,CellRow]:=NAVCOM.KindsSet[CellRow-self.StringGrid1.FixedRows];
   end
end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
var KeyBoard: TKeyboardState;
begin
  GetKeyboardState(Keyboard);
  if  (KeyBoard[VK_SHIFT] and 128)*(KeyBoard[VK_CONTROL] and 128) > 0 then
   begin
     self.Action3Monitoring.Execute;
     exit;
   end;
  if (KeyBoard[VK_SHIFT] and 128) > 0 then
    Self.Action1Cfg.Execute
   else
    if (KeyBoard[VK_CONTROL] and 128) > 0 then
      Self.Action2Run.Execute
     else
      case self.CheckBox1.Checked of
        True: Self.Action2Run.Execute;
        False: Self.Action1Cfg.Execute;
      end;
end;

procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var Color: TColor;
begin
  if ARow<self.StringGrid1.FixedRows then inherited
   else
   if length(StringGrid1.Cells[2,ARow])<1 then inherited
    else
    begin
      case (StringGrid1.Cells[2,ARow][1]) of
        #2: Color:=clLime;
        #3: Color:=clAqua;
        #4: Color:=clRed;
        #6: Color:=clYellow;
        else  Color:=StringGrid1.Color;
      end;
      StringGridDrawCell(self.StringGrid1, Sender, ACol, ARow, Rect, State, Color);
    end;
end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  //if ACol<>2 then exit;

  self.CellRow:=ARow;
  self.CellColumn:=ACol;

  if length(self.StringGrid1.Cells[2,ARow])<1 then exit;

  case self.StringGrid1.Cells[2,ARow][1] of
    #2: self.RadioGroup1.ItemIndex:=0;
    #3: self.RadioGroup1.ItemIndex:=1;
    #4: self.RadioGroup1.ItemIndex:=2;
    else self.RadioGroup1.ItemIndex:=3;
  end;
  self.ComboBox1.ItemIndex:=self.ComboBox1.Items.IndexOf(self.StringGrid1.Cells[0,ARow]);
  self.ComboBox2.ItemIndex:=self.ComboBox2.Items.IndexOf(self.StringGrid1.Cells[1,ARow]);

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled := False;
try
  NAVCOM.ReloadNAVApps;
  NAVCOM.ChangeScale(self.ComboBox3.ItemIndex);
finally
Timer1.Enabled := True;
end;

end;
procedure TForm1.WndProc(var Msg: TMessage);
var
  Pt: TPoint;
begin
  inherited;
  if Msg.Msg=WM_USER+1 then begin
    case Msg.LParam of
      WM_LBUTTONDBLCLK:
        begin
            ShowWindow(Handle, SW_NORMAL);
            self.Show;
        end;
      WM_LBUTTONDOWN:
        begin
          SetForegroundWindow(Handle);      // Восстанавливаем программу в качестве переднего окна
          GetCursorPos(Pt);                  // Запоминаем координаты курсора мыши
          PopupMenu1.Popup(Pt.X,Pt.Y);        // Показываем pop-up меню
          PostMessage(Handle,WM_NULL,0,0)   // Обнуляем сообщение
        end;
      WM_RBUTTONDOWN:  // Нажата правая кнопка мыши - показываем pop-up меню
        begin
          SetForegroundWindow(Handle);      // Восстанавливаем программу в качестве переднего окна
          GetCursorPos(Pt);                  // Запоминаем координаты курсора мыши
          PopupMenu1.Popup(Pt.X,Pt.Y);        // Показываем pop-up меню
          PostMessage(Handle,WM_NULL,0,0)   // Обнуляем сообщение
        end;
    end;
  end;
end;


end.
