unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Grids, DBGrids, DBCtrls
  ,inifiles//, StrMask
  ,Unit2,Unit3, Unit4
  ,UnitExportsManager, Buttons, GridsEh, DBGridEh, ComCtrls, JvExComCtrls,
  JvComCtrls, JvExDBGrids, JvDBGrid, JvDataSource, ExtCtrls, ADOInt;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Button1: TButton;
    Button2: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button3: TButton;
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ADOTable2: TADOTable;
    TabSheet2: TTabSheet;
    CheckBox4: TCheckBox;
    Label1: TLabel;
    ADOQuery1: TADOQuery;
    Timer1: TTimer;
    JvDataSource1: TJvDataSource;
    JvDBGrid1: TJvDBGrid;
    CheckBox5: TCheckBox;
    RadioGroup1: TRadioGroup;
    Panel1: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    RadioButton3: TRadioButton;
    SpeedButton1: TSpeedButton;
    Edit2: TEdit;
    ADOQuery2: TADOQuery;
    JvDataSource2: TJvDataSource;
    JvDBGrid2: TJvDBGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ADOTable1AfterScroll(DataSet: TDataSet);
    procedure CheckBox1Click(Sender: TObject);
    procedure ADOTable2AfterScroll(DataSet: TDataSet);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure ADOTable2FilterRecord(DataSet: TDataSet; var Accept: Boolean);

    procedure Edit1Change(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit1DblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure TabSheet2Show(Sender: TObject);
    procedure TabSheet2Hide(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure JvDBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ADOTable1AfterOpen(DataSet: TDataSet);
    procedure ADOTable2AfterOpen(DataSet: TDataSet);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure ADOTable1FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure Edit2Change(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure JvDBGrid1CellClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure Edit2DblClick(Sender: TObject);
    procedure ADOQuery1FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ADOQuery1AfterScroll(DataSet: TDataSet);
    procedure CheckBox5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const VERSION = '1.3';
var
  Form1: TForm1;
  ADOTable01, ADOTable02: TADOTable;
  DataSource01,DataSource02: TDataSource;
  ADOConnection01: TADOConnection;
  searchField, monitorSearchField: string; mouseX, mouseY: integer;
implementation

{$R *.dfm}



function IsLike(AString, Pattern: string): boolean;
var
   j, n, n1, n2: integer ;
   p1, p2: pchar ;
label
   match, nomatch;
begin
   AString := UpperCase(AString) ;
   Pattern := UpperCase(Pattern) ;
   n1 := Length(AString) ;
   n2 := Length(Pattern) ;
   if n1 < n2 then n := n1 else n := n2;

   p1 := pchar(AString) ;
   p2 := pchar(Pattern) ;
   for j := 1 to n do begin
     if p2^ = '*' then goto match;
     if (p2^ <> '?') and ( p2^ <> p1^ ) then goto nomatch;
     inc(p1) ; inc(p2) ;
   end;
   if n1 > n2 then begin
nomatch:
     Result := False;
     exit;
   end else if n1 < n2 then begin
     for j := n1 + 1 to n2 do begin
       if not ( p2^ in ['*','?'] ) then goto nomatch ;
       inc(p2) ;
     end;
   end;
match:
   Result := True 
end;





{процедуры выбора режима навигации}
//добавлено при переносе функционала на новые элементы управления
procedure SetIndependentNavigation;
var IDClient: integer;
begin
  IDClient := Manager.ClientsTbl.FieldByName('ID').AsInteger;
  {Form1.CheckBox1.Checked := False;}

  Form1.ADOTable1.MasterSource := nil;
  Form1.ADOTable2.MasterSource := nil;

  Form1.ADOTable2.MasterFields := '';
  Form1.ADOTable2.IndexFieldNames := '';

  Form1.ADOTable1.MasterFields := '';
  Form1.ADOTable1.IndexFieldNames := '';;
  //ShowMessage(IntToStr(IDClient)+' '+Manager.ClientsTbl.FieldByName('ID').AsString);
  Manager.ClientsTbl.Locate('ID',IDClient,[]);
end;

procedure SetLinkClientsToExports;
var IDClient: integer;
begin
 IDClient := Manager.ClientsTbl.FieldByName('ID').AsInteger;
 {Form1.RadioButton1.Checked := True;}//   if Form1.RadioButton1.Checked then //связь [Clients] --> [Exports]
 if Form1.CheckBox2.Checked then  //если связь по коду клиента
  TablesRelationLinking(Form1.DataSource1, Form1.ADOTable1,Form1.ADOTable2,'NAV_Client','NAV_Client')
 else                             //если связь по идентификатору
  TablesRelationLinking(Form1.DataSource1, Form1.ADOTable1,Form1.ADOTable2,'ID','ID_Client');
 Manager.ClientsTbl.Locate('ID',IDClient,[]);
end;

procedure SetLinkExportsToClients;
var IDExport: integer;
begin     //fix 07.05.2014 ошибка при копировании логики
 IDExport := Manager.ExportsTbl.FieldByName('ID').AsInteger;  
 {Form1.RadioButton2.Checked:= True;} //if Form1.RadioButton2.Checked then //связь [Exports] --> [Clients]
 if Form1.CheckBox2.Checked then   //если связь по коду клиента
  TablesRelationLinking(Form1.DataSource2, Form1.ADOTable2,Form1.ADOTable1,'NAV_Client','NAV_Client')
 else                              //если связь по идентификатору
  TablesRelationLinking(Form1.DataSource2, Form1.ADOTable2,Form1.ADOTable1,'ID_Client','ID');
 Manager.ExportsTbl.Locate('ID',IDExport,[]);
end;

procedure configClientsTable;
begin
  ;  //if Manager. then
  Form1.DBGrid1.ReadOnly := True;

  Form1.DBGrid1.Columns[0].Visible :=False; //ID
  Form1.DBGrid1.Columns[1].Title.Caption := 'Код в NAV';
  //Form1.DBGrid1.Columns[1].Title.Caption := 'Код в NAV';
             Form1.DBGrid1.Columns[2].Width := 50;
  Form1.DBGrid1.Columns[2].Title.Caption := 'Наименование клиента';
             Form1.DBGrid1.Columns[2].Width := 250;
  Form1.DBGrid1.Columns[3].Visible := false; //ID_WH
  Form1.DBGrid1.Columns[4].Title.Caption := 'Основной e-mail'; //e-mail
              Form1.DBGrid1.Columns[4].Width := 200;
  Form1.DBGrid1.Columns[5].Visible := false; //PriceGroup

end;

procedure configExportsTable;
begin
  ;
  Form1.DBGrid2.Columns[0].Visible := false;//ID
  Form1.DBGrid2.Columns[1].Visible := false;//priority
  Form1.DBGrid2.Columns[2].Visible := false;//ID_Client
  //Form1.DBGrid2.Columns[3].Visible := false;//priority

  Form1.DBGrid2.Columns[3].Width := 50;
  Form1.DBGrid2.Columns[3].Title.Caption := 'склад';//'№ склада';    //

  Form1.DBGrid2.Columns[4].Width := 50;
  Form1.DBGrid2.Columns[4].Title.Caption := 'Валюта';//'Код валюты';

  Form1.DBGrid2.Columns[5].Visible := false;//blocked
  Form1.DBGrid2.Columns[6].Visible := false;//Price


  Form1.DBGrid2.Columns[7].Width := 50;
  Form1.DBGrid2.Columns[7].Title.Caption := 'Клиент';//'Код клиента';


  Form1.DBGrid2.Columns[8].Visible := false;//INTERVAL

  Form1.DBGrid2.Columns[9].Width := 150;
  Form1.DBGrid2.Columns[9].Title.Caption := 'Время последнего экспорта';

  Form1.DBGrid2.Columns[10].Width := 150;
  Form1.DBGrid2.Columns[10].Title.Caption := 'Время очередного экспорта';


  Form1.DBGrid2.Columns[11].Visible := false;//File_NAME

  Form1.DBGrid2.Columns[12].Width := 50;
  Form1.DBGrid2.Columns[12].Title.Caption := 'шаблон';//'№ шаблона';

  Form1.DBGrid2.Columns[13].Visible := false;//emailflag

  Form1.DBGrid2.Columns[14].Width := 200;
  Form1.DBGrid2.Columns[14].Title.Caption := 'адреса рассылки';

  Form1.DBGrid2.Columns[15].Width := 400;
  Form1.DBGrid2.Columns[15].Title.Caption := 'Тема рассылки';

  Form1.DBGrid2.Columns[16].Visible := false;//emailbody;
  Form1.DBGrid2.Columns[17].Visible := false;//emailzip;
end;

procedure configexportmonitor;
begin

  Form1.JvDBGrid1.Columns[0].Visible := False;  //ID

  Form1.JvDBGrid1.Columns[1].Title.Caption := '№';
  Form1.JvDBGrid1.Columns[1].Width := 20;

  Form1.JvDBGrid1.Columns[2].Visible := false;  //#stt

  Form1.JvDBGrid1.Columns[3].Title.Caption := 'Состояние';
  Form1.JvDBGrid1.Columns[3].Width := 100;

  Form1.JvDBGrid1.Columns[4].Title.Caption := 'Клиент';
  Form1.JvDBGrid1.Columns[4].Width := 66;


  Form1.JvDBGrid1.Columns[5].Title.Caption := 'Склад';
  Form1.JvDBGrid1.Columns[5].Width := 166;


//  Form1.JvDBGrid1.Columns[6].Title.Caption := 'Валюта';
//  Form1.JvDBGrid1.Columns[6].Width := 66;

  Form1.JvDBGrid1.Columns[7].Visible := false; //Interval
  Form1.JvDBGrid1.Columns[8].Visible := false; //blocked
  Form1.JvDBGrid1.Columns[9].Visible := false; //LastExport

  Form1.JvDBGrid1.Columns[10].Title.Caption := 'Следующий запуск';
  //Form1.JvDBGrid1.Columns[10].Width := 250;
end;
procedure configmailsmonitor; 
begin
  Form1.JvDBGrid2.Columns[0].Visible := False;

  Form1.JvDBGrid2.Columns[1].Title.Caption := 'e-mail';
  Form1.JvDBGrid2.Columns[1].Width := 400;

  Form1.JvDBGrid2.Columns[2].Title.Caption := 'Последнее неотправленное';
  Form1.JvDBGrid2.Columns[2].Width := 200;

  Form1.JvDBGrid2.Columns[3].Visible := False; //ProcessingTimestamp==NULL
  Form1.JvDBGrid2.Columns[4].Visible := False; //AddingTimestamp==NULL

  Form1.JvDBGrid2.Columns[5].Title.Caption := 'Последний раз отправлено';
  Form1.JvDBGrid2.Columns[5].Width := 200;

end;
function safeRefresh(Table: TADOTable; key: string):boolean;
var tag: string;
begin
  tag := Table.FieldByName(key).AsString;
  Table.Close; Table.Open;
  try
    RESULT:=Table.Locate(key,tag,[]);
  except
    on Err: Exception do
  end;
end;
procedure refreshClients;
begin
  Form1.DBGrid1.DataSource:=Form1.DataSource1;
  if Form1.ADOTable1.Active then safeRefresh(Form1.ADOTable1,'ID')//Form1.ADOTable1.Active := false;
   else Form1.ADOTable1.Open;
  //if Form1.BitBtn1.Enabled then exit;
  Form1.BitBtn1.Enabled := True;
end;

procedure refreshExports;
begin
;
  Form1.DBGrid2.DataSource:=Form1.DataSource2;
  if Form1.ADOTable2.Active then safeRefresh(Form1.ADOTable2,'ID')//Form1.ADOTable2.Active := false;
   else Form1.ADOTable2.Open;
  Form1.BitBtn2.Enabled := True;
end;

function liveSearch(Edit: TEdit; searchField: string; Table: TADOTable): boolean;   overload;
begin
  RESULT:=False;
  if Edit.Text = '' then Edit.Color:=clWhite else Edit.Color:=clRed;
  if Table.Locate(searchField,Edit.Text,[loPartialKey]) then Edit.Color:=clYellow else exit;
  if Table.Locate(searchField,Edit.Text,[]) then Edit.Color:=clLime else exit;
  RESULT:=True;
end;

function liveSearch(Edit: TEdit; searchField: string; Query: TADOQuery): boolean;   overload;
begin
  RESULT:=False;
  if Edit.Text = '' then Edit.Color:=clWhite else Edit.Color:=clRed;
  if Query.Locate(searchField,Edit.Text,[loPartialKey]) then Edit.Color:=clYellow else exit;
  if Query.Locate(searchField,Edit.Text,[]) then Edit.Color:=clLime else exit;
  RESULT:=True;
end;

function search(field, value: string; ADODataset: TDataset): boolean;
var id: integer;
begin
    RESULT:=value>'';
    if value='' then exit;
    id:=ADODataset.FieldByName('ID').AsInteger;
    repeat
      if ADODataset.Eof then  ADODataset.First else ADODataset.Next;
      if ADODataset.FieldByName(field).IsNull then continue;
      if pos(Trim(value),ADODataset.FieldByName(field).AsString)>0 then exit;
    until  ADODataset.FieldByName('ID').AsInteger=id;
    RESULT:=False;
end;

function filteringByMask(DataSet: TDataSet; Edit: TEdit;  var filtering: boolean): boolean;
begin                                                    {key: string;}
try
    filtering := true;
    DataSet.Filtered := false;
    DataSet.Filtered := true;
    filtering := false;
//    if not DataSet.Locate(key,edit.Text,[loCaseInsensitive]) then  //   'NAV_Client'  кода клиента
//      MessageDlg('Осторожно! Точного совпадения не найдено',mtWarning,[mbCancel],0);
except on E: EDataBaseError do//xception do
end;
end;
//** прежняя реализация фильтрации
procedure TForm1.ADOQuery1AfterScroll(DataSet: TDataSet);
begin
  self.ADOQuery2.Filtered:=False;
  if self.ADOQuery1.FieldByName('ID').IsNull then exit;
  self.ADOQuery2.Filter := 'ID = '+self.ADOQuery1.FieldByName('ID').AsString;
  self.ADOQuery2.Filtered:=True;
end;

procedure TForm1.ADOQuery1FilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept:=True;
  if not Manager.filterExports then exit;  
  Accept := Accept AND Manager.AccordanceToMask(DataSet[monitorsearchField],Edit2.Text);
end;

procedure TForm1.ADOTable1AfterOpen(DataSet: TDataSet);
begin
  configClientsTable;
  Form1.BitBtn1.Enabled := true;
end;

procedure TForm1.ADOTable1AfterScroll(DataSet: TDataSet);
 begin exit;
  if Form1.RadioButton1.Checked then
    Form1.ADOTable2.Filter:= ' ID_Client = '
    + Form1.ADOTable1.FieldByName('ID').AsString;
end;

procedure TForm1.ADOTable1FilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := (DataSet['ID']>0);
  Accept := Accept AND (DataSet['NAV_Client']<>NULL);

  //фильтрация клиентов помеченных как двойники
  Accept := Accept AND ((self.RadioGroup1.ItemIndex = 2) OR (copy(DataSet['NAV_Client'],1,1)<>'_'));
  if not Manager.filterClients then exit;
  Accept := Accept AND Manager.AccordanceToMask(DataSet[searchField],Edit1.Text);   // isLike
end;

procedure TForm1.ADOTable2AfterOpen(DataSet: TDataSet);
begin
    configExportsTable;
    Form1.BitBtn2.Enabled := true;
end;

procedure TForm1.ADOTable2AfterScroll(DataSet: TDataSet);
begin   exit;
  if Form1.RadioButton2.Checked then
    Form1.ADOTable1.Filter:= ' ID = '
    + Form1.ADOTable2.FieldByName('ID_Client').AsString;
end;

procedure TForm1.ADOTable2FilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := True;
  if Form1.CheckBox3.Checked then
     Accept := not(DataSet.FieldByName('Interval').IsNull);

  Accept := Accept AND Dataset['ID_Client']>0;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  Manager.newClient := true;
  SetIndependentNavigation; self.RadioGroup1.ItemIndex := 0;
  Manager.appendClient;
  Form3.ShowModal;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  if Manager.ClientsTbl.Active = false then
   begin
    MessageDlg('Невозможно добавить новый экспорт безотносительно клиента',mtInformation,[mbCancel],0);
    exit;
   end;
  Manager.ClientID := Manager.ClientsTbl.FieldByName('ID').AsInteger;
  SetIndependentNavigation; self.RadioGroup1.ItemIndex := 0;
  if not Manager.ClientsTbl.Locate('ID',Manager.ClientID,[]) then exit;
  Manager.newExport := true;
  Manager.appendExport;
  Form2.ShowModal;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  refreshClients; configClientsTable;
  refreshExports; configExportsTable;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin

  refreshExports;
  configExportsTable;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Form4.Show;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if (Form1.CheckBox1.Checked) then //разрешить связку
   begin
    if Form1.RadioButton1.Checked then
      TablesRelationLinking(Form1.DataSource1, Form1.ADOTable1,Form1.ADOTable2,'ID','ID_Client');

    if Form1.RadioButton2.Checked then
      TablesRelationLinking(Form1.DataSource2, Form1.ADOTable2,Form1.ADOTable1,'ID_Client','ID');
   end
   else                             //независимая навигация
    begin
      Form1.ADOTable1.MasterSource := nil;
      Form1.ADOTable2.MasterSource := nil;

      Form1.ADOTable2.MasterFields := '';
      Form1.ADOTable2.IndexFieldNames := '';

      Form1.ADOTable1.MasterFields := '';
      Form1.ADOTable1.IndexFieldNames := '';
      ;
    end;
//  Form1.ADOTable1.Filtered := Form1.CheckBox1.Checked;
//  Form1.ADOTable2.Filtered := Form1.CheckBox1.Checked;
//  Form1.RadioButton1.Enabled:= Form1.CheckBox1.Checked;
//  Form1.RadioButton2.Enabled:= Form1.CheckBox1.Checked;
  Form1.RadioButton1.Checked:= Form1.CheckBox1.Checked AND Form1.RadioButton1.Checked;
  Form1.RadioButton2.Checked:= Form1.CheckBox1.Checked AND Form1.RadioButton2.Checked;


  Form1.CheckBox2.Enabled := Form1.CheckBox1.Checked;
  Form1.CheckBox3.Enabled := not(Form1.CheckBox1.Checked);

end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
   SetIndependentNavigation;
   case self.RadioGroup1.ItemIndex of
   0: exit;
   1:
    if self.CheckBox2.Checked then
      TablesRelationLinking(Form1.DataSource1, Form1.ADOTable1,Form1.ADOTable2,'NAV_Client','NAV_Client')
     else
      TablesRelationLinking(Form1.DataSource1, Form1.ADOTable1,Form1.ADOTable2,'ID','ID_Client');
   2:
    if self.CheckBox2.Checked then
      TablesRelationLinking(Form1.DataSource2, Form1.ADOTable2,Form1.ADOTable1,'NAV_Client','NAV_Client')
     else
      TablesRelationLinking(Form1.DataSource2, Form1.ADOTable2,Form1.ADOTable1,'ID_Client','ID');

   end;
   refreshClients; refreshExports;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
//неприменимо поскольку заодно отключает фильтрацию зарезервированных строк
 //Form1.ADOTable2.Filtered := Form1.CheckBox3.Checked;
 refreshExports;
end;



procedure TForm1.CheckBox5Click(Sender: TObject);
begin
  Self.JvDBGrid2.Enabled := self.CheckBox5.Checked;
  Form1.ADOQuery2.Active := self.CheckBox5.Checked;
  if self.CheckBox5.Checked then
   begin
    self.ADOQuery2.Filtered:=False;
    if self.ADOQuery1.FieldByName('ID').IsNull then exit;
    self.ADOQuery2.Filter := 'ID = '+self.ADOQuery1.FieldByName('ID').AsString;
    self.ADOQuery2.Filtered:=True;
    //Form1.ADOQuery2.Close; Form1.ADOQuery2.Open;
    configmailsmonitor;
   end;



end;

procedure TForm1.DBGrid1CellClick(Column: TColumn);
var
  Pt: TPoint;
  Coord: TGridCoord;
  ClickCol: Integer;
  indexCol: integer;
  State: TKeyboardState;
  w,j: integer;
begin
  GetKeyboardState(State);
  if ((State[VK_SHIFT] and 128) = 0) then exit;
  Pt := DBGrid1.ScreenToClient(Mouse.CursorPos);
  Coord := TGridCoord(DBGrid1.MouseCoord(Pt.X, Pt.Y));
  ClickCol := Coord.X-1;
  //ShowMessage('You clicked column ' + IntToStr(ClickCol));
//end;
  indexCol:=0;
//  repeat
//    if  ClickCol=0 then break;
//    if self.DBGrid1.Columns[indexCol].Visible then dec(ClickCol);
//    inc(indexCol);
//  until (indexCol=self.DBGrid1.Columns.Count);
//  if ClickCol<>0 then exit;
  //Pt:= self.DBGrid1. Columns[ClickCol]
  w:=0;
  for j:=0 to ClickCol-1 do
    w:=self.DBGrid1.Columns[j].Width+w +1;
  Pt.X := w + 13;
  Pt.Y := - self.Edit1.Height + self.DBGrid1.Height;
  if self.Edit1.Text = '' then
    self.Edit1.Width := self.DBGrid1.Columns[ClickCol].Width+1;

  if searchField<>self.DBGrid1.Fields[ClickCol].FieldName then
   begin
    searchField := self.DBGrid1.Fields[ClickCol].FieldName;
    Edit1.Text := '<Enter search value here...>';
    Edit1.Color := clWhite;
   end
   else
   begin
    if StringReplace(Edit1.Text,'<Enter search value here...>','',[])<>'' then    
     if not Manager.ClientsTbl.Locate(searchField,trim(self.Edit1.Text),[]) then
      self.Edit1.Clear;
   end;




  self.Edit1.Left:=self.DBGrid1.Left{-(self.Edit1.Width div 3)}+Pt.X;
  self.Edit1.Top :=self.DBGrid1.Top  {+self.Edit1.Height}+Pt.Y;
  self.Edit1.Visible:=True;
  self.Edit1.BringToFront;
  self.Edit1.SetFocus;
end;

procedure TForm1.DBGrid1DblClick(Sender: TObject);
var  State : TKeyboardState;
begin
  GetKeyboardState(State);
  if ((State[vk_Control] and 128) = 0) then exit;
  //Form3.DataSource1:=Form1.DataSource1;
  if ((State[VK_INSERT] and 128) > 0) then
    if DBGrids.dgEditing in Self.DBGrid1.Options then
      Self.DBGrid1.Options:=Self.DBGrid1.Options-[DBGrids.dgEditing]
    else
      Self.DBGrid1.Options:=Self.DBGrid1.Options+[DBGrids.dgEditing];
  Form3.fieldsindex:=Form1.DBGrid1.SelectedIndex;
  Form3.ShowModal;
end;

procedure TForm1.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
if ord(key)=VK_RETURN then //значит был нажат на ентер
 begin
   if self.RadioGroup1.ItemIndex = 2 then
     Manager.ExportID := Manager.ExportsTbl.FieldByName('ID').AsInteger
    else Manager.ExportID := 0;   //пока не замечена аналогичная проблема
   //твоя процедура
   Form3.ShowModal;
 end;
end;

procedure TForm1.DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mouseX := X;
  mouseY := Y;
end;

procedure TForm1.DBGrid1TitleClick(Column: TColumn);
begin
  if self.ADOTable1.Sort = '['+Column.FieldName+'] ASC' then
    self.ADOTable1.Sort := '['+Column.FieldName+'] DESC'
   else
    self.ADOTable1.Sort := '['+Column.FieldName+'] ASC';

exit;
  if Column.FieldName<>'NAV_Client' then exit;
  Form1.Edit1.Visible := not Form1.Edit1.Visible;
end;

procedure TForm1.DBGrid2CellClick(Column: TColumn);
begin
  if Column.Index=0 then Form2.ShowModal;
end;

procedure TForm1.DBGrid2DblClick(Sender: TObject);
var  State : TKeyboardState;
begin
  GetKeyboardState(State);
  if ((State[vk_Control] and 128) = 0) then exit;
  if ((State[VK_INSERT] and 128) > 0) then
    if DBGrids.dgEditing in Self.DBGrid2.Options then
      Self.DBGrid2.Options:=Self.DBGrid2.Options-[DBGrids.dgEditing]
    else
      Self.DBGrid2.Options:=Self.DBGrid2.Options+[DBGrids.dgEditing];
  //Form2.DataSource2:=Form1.DataSource2;
  Form2.fieldsindex:=Form1.DBGrid2.SelectedIndex;
  Form2.ShowModal;
end;

procedure TForm1.DBGrid2KeyPress(Sender: TObject; var Key: Char);
var KeyBoard: TKeyBoardState;
begin
if ord(key)=VK_RETURN then //значит был нажат на ентер
 begin
  GetKeyboardState(KeyBoard);
  if (KeyBoard[VK_SHIFT] AND 128)<>0 then
   begin
    if not self.ADOQuery1.Active then self.ADOQuery1.Open; //нажатие <SHIFT>+<Enter> принесёт желаемый результат
    if self.ADOQuery1.Locate('ID',Manager.ExportsTbl.FieldByName('ID').AsInteger,[]) then
       begin
        Form1.PageControl1.ActivePage := TabSheet2;
        Form1.SetFocusedControl(Form1.jvDBGrid1);
        Form1.jvDBGrid1.SetFocus;
        Key:=#0;
       end;
     exit;
   end;


   //твоя процедура
   Form2.fieldsindex := Form1.DBGrid2.SelectedIndex;
   Manager.ExportID := Manager.ExportsTbl.FieldByName('ID').AsInteger;
   //fix 05.05.2014 SetIndependentNavigation; self.RadioGroup1.ItemIndex := 0;
   if self.RadioGroup1.ItemIndex=1 then //при сязанной навигации необходимо перемещать курсор по клиентам
    Manager.ClientID := Manager.ClientsTbl.FieldByName('ID').AsInteger;

   Form2.ShowModal;
 end;
end;

procedure TForm1.DBGrid2TitleClick(Column: TColumn);
begin
  if self.ADOTable2.Sort = '['+Column.FieldName+'] ASC' then
    self.ADOTable2.Sort := '['+Column.FieldName+'] DESC'
   else
    self.ADOTable2.Sort := '['+Column.FieldName+'] ASC';
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
//dbgrid1.Perform(LB_SELECTSTRING,-1,longint(Pchar(edit1.text)));
  //ADOTable1.Locate('NAV_Client',edit1.Text,[loPartialKey]);     
try 
  if Edit1.Text<>'<Enter search value here...>' then  
    liveSearch(edit1,searchField,ADOTable1)
   else Edit1.Color := clWhite;   
except on E: EDatabaseError do//xception do  

end;
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  if self.Edit1.Text='<Enter search value here...>' then self.Edit1.Clear;
  
end;

procedure TForm1.Edit1DblClick(Sender: TObject);
var  State : TKeyboardState;
begin
  GetKeyboardState(State);
  if ((State[vk_Control] and 128) = 0) then exit;

  
try
    Manager.filterClients := true;
    self.ADOTable1.Filtered := false;
    self.ADOTable1.Filtered := true;
    Manager.filterClients := false;
    if not ADOTable1.Locate(searchField,edit1.Text,[loCaseInsensitive]) then  //   'NAV_Client'  кода клиента
      MessageDlg('Осторожно! Точного совпадения не найдено',mtWarning,[mbCancel],0);                                                                                                                                                                                                               
except on E: EDataBaseError do//xception do                                                                                                                                                           
end;
end;

procedure TForm1.Edit1Exit(Sender: TObject);
begin
  if searchField='NAV_Client' then Manager.searchkey:=Trim(Edit1.Text)  //для передачи кода клиента
   else Manager.searchkey:='';
  self.Edit1.Visible := false;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
var KeyBoardState: TKeyboardState;
begin
  GetKeyboardState(KeyBoardState);

  if (KeyBoardState[VK_RETURN] and 128)<>0 then //if Key  = #13 then
   begin
    filteringByMask(ADOTable1,Edit1,Manager.filterClients);
    Key := #0;
    exit;
   end;

  if (KeyBoardState[VK_ESCAPE] and 128)=0 then exit;



  self.Edit1.Visible := false;
end;



procedure TForm1.Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
//var KeyBoardState: TKeyboardState; LookupRes: Variant; id: integer;
begin

  if Key=VK_F3 then
   begin
    if Edit1.Color=clRed then exit;
    if StringReplace(Edit1.Text,'<Enter search value here...>','',[rfReplaceAll]) = ''  then exit;

    if ADOTable1.Eof then exit;
    search(searchField,Edit1.Text,ADOTable1);
   end;
end;


procedure TForm1.Edit2Change(Sender: TObject);
begin
try
  if Edit2.Text<>'<Enter search value here...>' then  
    liveSearch(edit2,monitorSearchField,ADOQuery1)
   else
    Edit2.Color := clWhite;  
except on E: EDatabaseError do//xception do
end;
end;

procedure TForm1.Edit2Click(Sender: TObject);
begin
  if self.Edit2.Text='<Enter search value here...>' then self.Edit2.Clear;
end;

procedure TForm1.Edit2DblClick(Sender: TObject);
var State: TKeyBoardState;
begin
  GetKeyboardState(State);
  if ((State[vk_Control] and 128) = 0) then exit;

  
try
    Manager.filterExports := true;
    self.ADOQuery1.Filtered := false;
    self.ADOQuery1.Filtered := true;
    Manager.filterExports := false;
    if not ADOQuery1.Locate(monitorSearchField,edit2.Text,[loCaseInsensitive]) then  //   'NAV_Client'  кода клиента
      MessageDlg('Осторожно! Точного совпадения не найдено',mtWarning,[mbCancel],0);                                                                                                                                                                                                               
except on E: EDataBaseError do//xception do                                                                                                                                                           
end;
end;

procedure TForm1.Edit2Exit(Sender: TObject);
begin
  self.Edit2.Visible := false;
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
var KeyBoardState: TKeyboardState;
begin
  GetKeyboardState(KeyBoardState);

    if (KeyBoardState[VK_RETURN] and 128)<>0 then //if Key  = #13 then
   begin
    filteringByMask(ADOQuery1,Edit1,Manager.filterExports);
    Key := #0;
    exit;
   end;
   
  if (KeyBoardState[VK_ESCAPE] and 128)=0 then exit;
  self.Edit2.Visible := false;
end;
procedure TForm1.Edit2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=VK_F3 then
   begin
    if ADOQuery1.Eof then exit;
    if Edit2.Color=clRed then exit;
    
    if StringReplace(Edit2.Text,'<Enter search value here...>','',[rfReplaceAll]) = ''  then exit;

    if self.CheckBox5.Checked then
      search(monitorsearchField,Edit2.Text,ADOQuery1);
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Caption := 'Обозреватель экспортов'+' V.'+VERSION ;//'Exports Browser';

  Form1.TabSheet1.Caption := 'Настройка';
  Form1.TabSheet2.Caption := 'Мониторинг';

  Form1.Button1.Caption := 'Обновить данные';//'Refresh Clients';
  Form1.Button2.Caption := 'Обновить данные';//'Refresh Exports';
  Form1.Button3.Caption := 'Show exports queue...';

  Form1.StaticText1.Caption := 'КЛИЕНТЫ';
    Form1.StaticText2.Caption := 'ЭКСПОРТЫ';

  Form1.CheckBox1.Caption := 'Show Link tables by client';
  Form1.RadioButton1.Caption := 'Link [Clients]-->[Exports]';
  Form1.RadioButton2.Caption := 'Link [Exports]-->[Clients]';


  Form1.CheckBox2.Caption := 'Разрешить связку по коду клиента';//'Enable linking by Client_NAV';
  Form1.CheckBox3.Caption := 'Показывать только активные';//'Show only active exports';
  Form1.CheckBox5.Caption := 'Заморозить обновление';
  //Form1.Edit1.Text := '<Enter NAV Code>';
  Form1.BitBtn1.Caption := 'Новый клиент...';//'Add...';
  Form1.BitBtn2.Caption := 'Новый экспорт...';//'Add...';

  Form1.BitBtn1.Enabled := False;
  Form1.BitBtn2.Enabled := False;

  Form1.Edit1.Visible := False;
  Form1.Edit2.Visible := False;

  Form1.RadioGroup1.Caption := 'Тип навигации';



  Manager := TExportsManager.Create;
{
//утечка памяти  - не грозит
  ADOTable01:=Form1.ADOTable1;
  ADOTable02:=Form1.ADOTable2;

  DataSource01:=Form1.DataSource1;
  DataSource02:=Form1.DataSource2;
}
//  ADOConnection01:= Form1.ADOConnection1;

  Manager.Connection := Form1.ADOConnection1;
//  Form1.ADOConnection1.ConnectionString := generateConnStr(true);


//  Form1.ADOConnection1:=Manager.Connection;


  Manager.ClientsTbl:=Form1.ADOTable1;
  Manager.ExportsTbl := Form1.ADOTable2;

//  Form1.ADOTable1:=Manager.ClientsTbl;
//  Form1.ADOTable2:=Manager.ExportsTbl;
//
  Manager.ClientsSrc := Form1.DataSource1;
  Manager.ExportsSrc := Form1.DataSource2;
//  Form1.DataSource1:=Manager.ClientsSrc;
//  Form1.DataSource2:=Manager.ExportsSrc;


  Manager.Init;
//
  //Form1.ADOConnection1.Connected:=True;
  Form1.ADOTable1.Open;
  Form1.ADOTable2.Open;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Manager);
{
  Form1.ADOTable1:=ADOTable01;
  Form1.ADOTable2:=ADOTable02;

  Form1.DataSource1:=DataSource01;
  Form1.DataSource2:=DataSource02;

  Form1.ADOConnection1.Connected:=False;
  Form1.ADOConnection1:=ADOConnection01;
}
end;

procedure TForm1.JvDBGrid1CellClick(Column: TColumn);
var
  Pt: TPoint;
  Coord: TGridCoord;
  ClickCol: Integer;
  indexCol: integer;
  State: TKeyboardState;

   j, w: integer;
begin
  GetKeyboardState(State);
  if ((State[VK_SHIFT] and 128) = 0) then exit;
  Pt := JvDBGrid1.ScreenToClient(Mouse.CursorPos);
  Coord := TGridCoord(JvDBGrid1.MouseCoord(Pt.X, Pt.Y));
  ClickCol := Coord.X-1;
  //ShowMessage('You clicked column ' + IntToStr(ClickCol));
//end;
  indexCol:=0;
//  repeat
//    if  ClickCol=0 then break;
//    if self.DBGrid1.Columns[indexCol].Visible then dec(ClickCol);
//    inc(indexCol);
//  until (indexCol=self.DBGrid1.Columns.Count);
//  if ClickCol<>0 then exit;

  monitorSearchField := self.jvDBGrid1.Fields[ClickCol].FieldName; //Column.FieldName; //.Field.Name;

  w:=0;
  for j:=0 to ClickCol-1 do
    w:=self.JvDBGrid1.Columns[j].Width+w +1;
  Pt.X := w + 13;
  Pt.Y := - self.Edit2.Height + self.JvDBGrid1.Height;
  self.Edit2.Width := self.JvDBGrid1.Columns[ClickCol].Width+1;

  self.Edit2.Left:=self.JvDBGrid1.Left{-(self.Edit2.Width div 3)}+Pt.X;
  self.Edit2.Top :=self.JvDBGrid1.Top{+self.Edit2.Height}+Pt.Y;
  self.Edit2.Visible:=True;
  self.Edit2.BringToFront;
  self.Edit2.SetFocus;
end;

procedure TForm1.JvDBGrid1KeyPress(Sender: TObject; var Key: Char);
var KeyBoard : TKeyboardState;
begin
if ord(key)=VK_RETURN then //значит был нажат на ентер
 begin
   GetKeyboardState(KeyBoard);
   if (KeyBoard[VK_SHIFT] AND 128)=0 then exit;
   //твоя процедура
   if Manager.ExportsTbl.Active then
    begin

      if Manager.ExportsTbl.Locate('ID',Form1.ADOQuery1.FieldByName('ID').AsInteger,[]) then
       begin
        Form1.Timer1.Enabled :=False;
        SetLinkExportsToClients; self.RadioGroup1.ItemIndex:=2;

        Form1.PageControl1.ActivePage := TabSheet1; //.Show;
        //Form1.PageControl1.ActivePageIndex := TabSheet1.PageIndex;
        Application.ProcessMessages;
        //Form1.TabSheet1.Show;
        Form2.fieldsindex:=0;
        
        if Form1.DBGrid2.CanFocus then
          Form1.DBGrid2.SetFocus
         else  Form1.SetFocusedControl(Form1.DBGrid2);         Application.ProcessMessages; //помогло!
        //Form2.ShowModal;
        Key:=#0;
       end;
   //Form2.fieldsindex := Form1.DBGrid2.SelectedIndex;
      //Form2.ShowModal;
    end;
 end;
end;
procedure TForm1.RadioButton1Click(Sender: TObject);
begin    exit;
  if Form1.RadioButton1.Checked then //связь [Clients] --> [Exports]
   if Form1.CheckBox2.Checked then  //если связь по коду клиента
    TablesRelationLinking(Form1.DataSource1, Form1.ADOTable1,Form1.ADOTable2,'NAV_Client','NAV_Client')
   else                             //если связь по идентификатору
    TablesRelationLinking(Form1.DataSource1, Form1.ADOTable1,Form1.ADOTable2,'ID','ID_Client');
    //Form1.ADOTable1.Filter:='';
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin    exit;
  if Form1.RadioButton2.Checked then //связь [Exports] --> [Clients]
   if Form1.CheckBox2.Checked then   //если связь по коду клиента
    TablesRelationLinking(Form1.DataSource2, Form1.ADOTable2,Form1.ADOTable1,'NAV_Client','NAV_Client')
   else                              //если связь по идентификатору
    TablesRelationLinking(Form1.DataSource2, Form1.ADOTable2,Form1.ADOTable1,'ID_Client','ID');
    //Form1.ADOTable2.Filter:='';
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  case self.RadioGroup1.ItemIndex of
  0: SetIndependentNavigation;
  1: SetLinkClientsToExports;
  2: SetLinkExportsToClients;
  end;
  refreshClients; refreshExports;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  self.ADOTable1.Sort := '';
  self.ADOTable2.Sort := '';
  Manager.filterClients := false; Manager.filterExports := false;
  refreshClients; configClientsTable;
  refreshExports; configExportsTable;
end;

procedure TForm1.TabSheet2Hide(Sender: TObject);
begin
  Form1.Timer1.Enabled := False;
end;

procedure TForm1.TabSheet2Show(Sender: TObject);
begin
  Form1.ADOConnection1.Connected := True;

  Form1.ADOQuery1.Open;  //Form1.ADOQuery2.Open;

//
//    self.ADOQuery2.Filtered:=False;
//    if self.ADOQuery1.FieldByName('ID').IsNull then exit;
//    self.ADOQuery2.Filter := 'ID = '+self.ADOQuery1.FieldByName('ID').AsString;
//    self.ADOQuery2.Filtered:=True;

  Form1.Timer1.Enabled := not Form1.CheckBox5.Checked;
  Form1.JvDBGrid2.Enabled := Form1.CheckBox5.Checked;
  configexportmonitor;
    //Form1.JvDBGrid1.Columns[1].Visible := False;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var tag: string;
begin
 try  //призвано исправить ошибку "Index out of the bounds(0)"
    if Form1.CheckBox5.Checked then exit;
    if not Form1.ADOQuery1.Active then exit;

    tag := Form1.ADOQuery1.Fields[0].AsString;
    if tag='0' then exit;    //fix? 05.05.2014

    Form1.ADOQuery1.Close; Form1.ADOQuery1.Open;
    Form1.ADOQuery1.Locate('ID',tag,[]);

//    self.ADOQuery2.Filtered:=False;
//    if self.ADOQuery1.FieldByName('ID').IsNull then exit;
//    self.ADOQuery2.Filter := 'ID = '+self.ADOQuery1.FieldByName('ID').AsString;
//    self.ADOQuery2.Filtered:=True;
//
//
//    Form1.ADOQuery2.Close; Form1.ADOQuery2.Open;


    configexportmonitor;
 except on E: Exception do
 end;
end;

end.
