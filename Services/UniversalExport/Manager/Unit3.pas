unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, DB
  ,UnitExportsManager, Buttons, JvExStdCtrls, JvDBCombobox, ADODB, Grids,
  DBGrids, JvExDBGrids, JvDBGrid, GridsEh, DBGridEh;

type
  TForm3 = class(TForm)
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    Label5: TLabel;
    DataSource1: TDataSource;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ADOTable1: TADOTable;
    ADOConnection1: TADOConnection;
    JvDBComboBox1: TJvDBComboBox;
    JvDBGrid1: TJvDBGrid;
    DBLookupComboBox3: TDBLookupComboBox;
    DBGridEh1: TDBGridEh;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure DBEdit2Enter(Sender: TObject);
    procedure DBEdit3Enter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure JvDBComboBox1Change(Sender: TObject);
    procedure DBLookupComboBox1CloseUp(Sender: TObject);
    procedure ADOTable1AfterScroll(DataSet: TDataSet);
    procedure ADOTable1AfterOpen(DataSet: TDataSet);
    procedure JvDBGrid1CellClick(Column: TColumn);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1Enter(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    FieldsControls: array[1..5] of TWinControl;
    fieldsindex: integer;
  end;

var
  Form3: TForm3;
  searchField: string;
implementation

{$R *.dfm}

function liveSearch(Edit: TEdit; searchField: string; Table: TADOTable): boolean;
begin
  RESULT:=False;
  if Edit.Text = '' then Edit.Color:=clWhite else Edit.Color:=clRed;
  if Table.Locate(searchField,Edit.Text,[loPartialKey]) then Edit.Color:=clYellow else exit;
  if Table.Locate(searchField,Edit.Text,[]) then Edit.Color:=clLime else exit;
  RESULT:=True;
end;

procedure TForm3.ADOTable1AfterOpen(DataSet: TDataSet);
const FIELDNAMES = 'No_ Name E-Mail [Customer Price Group]';
var j : integer;
begin
  for j  := 0 to Form3.ADOTable1.Fields.Count - 1 do
   begin
     Form3.JvDBGrid1.Columns[j].Visible  :=  pos(Form3.ADOTable1.Fields[j].FieldName, FIELDNAMES)>0;
     if (Form3.ADOTable1.Fields[j].FieldName<>'No_') and (Form3.ADOTable1.Fields[j].FieldName<>'Customer Price Group') and Form3.JvDBGrid1.Columns[j].Visible then Form3.JvDBGrid1.Columns[j].Width := 200;
   end;
  {   Form3.DBGridEh1.Columns[j].Visible := false;
  //Form3.DBGridEh1.FieldColumns.Visible := False;
  Form3.DBGridEh1.FieldColumns['No_'].Visible := true;; //Fields[j].Visible  :=  pos(Form3.ADOTable1.Fields[j].FieldName, FIELDNAMES)>0;
  Form3.DBGridEh1.FieldColumns['Name'].Visible := true;
  Form3.DBGridEh1.FieldColumns['E-Mail'].Visible := true;
  Form3.DBGridEh1.FieldColumns['Customer Price Group'].Visible := true;
  }
end;


procedure TForm3.ADOTable1AfterScroll(DataSet: TDataSet);
begin
  Form3.DBEdit1.Text := Form3.ADOTable1.FieldByName('No_').AsString;
  Form3.DBEdit2.Text := Form3.ADOTable1.FieldByName('Name').AsString;
  Form3.DBEdit3.Text := Form3.ADOTable1.FieldByName('E-Mail').AsString;
  //Form3.DBEdit1.Text := Form3.ADOTable1.FieldByName('[E-Mail]').AsString;
end;

procedure TForm3.DBEdit2Enter(Sender: TObject);
begin
  Form3.DBEdit2.SelStart:=0;
  Form3.DBEdit2.SelLength := Length(Trim(DBEdit1.DataSource.DataSet.FieldByName(DBEdit2.DataField).AsString));
end;

procedure TForm3.DBEdit3Enter(Sender: TObject);
begin
  Form3.DBEdit3.SelStart:=0;
  Form3.DBEdit3.SelLength := Length(Trim(DBEdit3.DataSource.DataSet.FieldByName(DBEdit3.DataField).AsString));

end;


procedure TForm3.DBLookupComboBox1CloseUp(Sender: TObject);
begin
  if Self.DBLookupComboBox1.Text = '' then exit;
  Form3.JvDBGrid1.Enabled := true;
  if Manager.updateDomain then
  begin
    Form3.ADOTable1.Close;
    Manager.ConfigTableByDomain(Form3.ADOTable1,'Customer');



    Form3.ADOTable1.Open;
  end;
end;

procedure TForm3.Edit1Change(Sender: TObject);
begin
   liveSearch(edit1,searchField,ADOTable1);
end;

procedure TForm3.Edit1Click(Sender: TObject);
begin
  if self.Edit1.Text='<Enter value here...>' then self.Edit1.Clear;
end;

procedure TForm3.Edit1Enter(Sender: TObject);
begin
  //self.BitBtn2.ModalResult := mrNone;
end;

procedure TForm3.Edit1Exit(Sender: TObject);
begin
//  self.Edit1.Visible := false;
//  self.BitBtn2.ModalResult:=mrCancel;
end;

procedure TForm3.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var KeyBoardState: TKeyboardState;
begin
//  GetKeyboardState(KeyBoardState);
//  if (KeyBoardState[VK_ESCAPE] and 128)=0 then exit;
//  self.Edit1.Visible := false;   key:=0;
end;

procedure TForm3.Edit1KeyPress(Sender: TObject; var Key: Char);
var KeyBoardState: TKeyboardState;
begin
//  GetKeyboardState(KeyBoardState);
//  if (KeyBoardState[VK_ESCAPE] and 128)=0 then exit;
//  self.Edit1.Visible := false;   key:=#0;
end;

procedure TForm3.FormActivate(Sender: TObject);
begin
  if Manager.newClient then  self.fieldsindex:=3;

  With Form3.DBEdit1 do
   begin
    ReadOnly := Manager.newClient;
    ParentColor := Manager.newClient;
    if not ParentColor then  Color := clWindow;
   end;
  With Form3.DBEdit2 do
   begin
    ReadOnly := Manager.newClient;
    ParentColor := Manager.newClient;
    if not ParentColor then  Color := clWindow;
   end;
  With Form3.DBEdit3 do
   begin
    ReadOnly := Manager.newClient;
    ParentColor := Manager.newClient;
    if not ParentColor then  Color := clWindow;
   end;

  Form3.JvDBGrid1.Enabled := (Self.DBLookupComboBox1.Text <> '');
  Form3.DBLookupComboBox1.SetFocus;
  if self.fieldsindex = 0 then self.SetFocus
   else self.SetFocusedControl(self.FieldsControls[self.fieldsindex]);
end;

procedure TForm3.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not self.Edit1.Visible;
  self.Edit1.Visible := false;
  if CanClose then
   if ModalResult=mrOK then
    CanClose:= (
    MessageDlg('Сохранить изменения?',mtConfirmation,[mbYes,mbCancel],0)=mrYes
    )
    else
    CanClose:= (
    MessageDlg('Выйти без сохранения?',mtConfirmation,[mbYes,mbCancel],0)=mrYes
    );  
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  //ShowMessage('');
  Form3.Caption := 'Выбор клиента';//'Select Clients:';


  FieldsControls[1] := Form3.DBEdit1;
  FieldsControls[2] := Form3.DBEdit2;// nil;//Box1;
  FieldsControls[4]:=Form3.DBEdit3;
  FieldsControls[3]:=Form3.DBLookupComboBox1;
  FieldsControls[5]:=Form3.DBLookupComboBox2;



  With Form3 do
   begin
     Label1.Caption:='Код клиента в NAV';
          Label2.Caption:='Наименование клиента';
               Label3.Caption:='Основной e-mail';
                    Label4.Caption:='Домен';
                      Label5.Caption:='Ценовая группа';
   end;

  //Form3.DataSource1:=Manager.ClientsSrc;

end;

procedure TForm3.FormDeactivate(Sender: TObject);
var LookUpResult: Variant;
begin
try
   if Form3.ModalResult = mrOK then
    begin
     if Manager.newClient then
      begin
        LookUpResult:= Manager.ClientsTbl.Lookup('NAV_Client;DOM'//
                    ,VarArrayOf([self.DBEdit1.Text,//Manager.ClientsTbl.FieldByName('NAV_Client').AsString
                    Manager.ClientsTbl.FieldByName('DOM').AsString])
                    ,'ID');

        if VarIsNumeric(LookUpResult) then
         if LookUpResult<>Manager.ClientsTbl.FieldByName('ID').AsInteger then
          if MessageDlg('В выбранном домене уже существует клиент с указанным номером.'
           +' Всё равно добавить двойника?',mtWarning,mbYesNoCancel,0)<>mrYes then
           begin
             Manager.ClientsTbl.CancelUpdates; //иначе каким-то образом всё равно добавляет
             Manager.ClientsTbl.Locate('ID',LookUpResult,[]);
             //Form3.ShowModal;
             exit;
           end;
      end;

//      Manager.ClientsTbl.Lookup('NAV_Client;ID_WH',
//      Manager.ClientsTbl.FieldByName('NAV_Client').AsString+';'+Manager.ClientsTbl.FieldByName('ID_WH').AsString,'ID')) then




      Manager.ClientsTbl.Edit;



      if Form3.DBLookupComboBox2.KeyValue = 0 then
        Manager.ClientsTbl.FieldByName('PriceGroup').Value:=NULL;
      self.fieldsindex := 0;
      Manager.ClientsTbl.Post;
      Manager.newClient := False;
    end
   else Manager.ClientsTbl.CancelUpdates;
   Form3.fieldsindex := 0;
except on Err: Exception do
	MessageDlg(Err.Message, mtError, [mbAbort],0);
end;
end;

procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  if Key<>VK_ESCAPE then exit;
//
//  if self.Edit1.Visible then
//   begin
//    self.Edit1.Visible := false;
//    //key := 0; //
//   end;   
end;

procedure TForm3.FormShow(Sender: TObject);
begin

    Form3.DBEdit1.DataSource:=Manager.ClientsSrc;
    Form3.DBEdit1.DataField:='NAV_Client';


    Form3.DBEdit2.DataSource:=Manager.ClientsSrc;
    Form3.DBEdit2.DataField:='Name';


  Form3.DBEdit3.DataSource:=Manager.ClientsSrc;
  Form3.DBEdit3.DataField:='e_mail';

  Manager.DomainsTbl.Open;
  Form3.DBLookupComboBox1.DataSource:=Manager.ClientsSrc;
  Form3.DBLookupComboBox1.DataField:='DOM';
  Form3.DBLookupComboBox1.ListSource := Manager.DomainsSrc;
  Form3.DBLookupComboBox1.ListField := 'Name';
  Form3.DBLookupComboBox1.KeyField := 'ID';

  Manager.PriceGroupsTbl.Open;
  Form3.DBLookupComboBox2.DataSource:=Manager.ClientsSrc;
  Form3.DBLookupComboBox2.DataField:='PriceGroup';
  Form3.DBLookupComboBox2.ListSource := Manager.PriceGroupsSrc;
  Form3.DBLookupComboBox2.ListField := 'SalesCode';
  Form3.DBLookupComboBox2.KeyField := 'ID';

//  if self.fieldsindex = 0 then self.SetFocus
//   else self.SetFocusedControl(self.FieldsControls[self.fieldsindex]);


  Form3.DBLookupComboBox3.DataSource:=Manager.ClientsSrc;
  Form3.DBLookupComboBox3.DataField:='NAV_Client';
end;

procedure TForm3.JvDBComboBox1Change(Sender: TObject);
begin

  ;
end;

procedure TForm3.JvDBGrid1CellClick(Column: TColumn);
var
  Pt: TPoint;
  Coord: TGridCoord;
  ClickCol: Integer;
  indexCol: integer;
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  if ((State[VK_SHIFT] and 128) = 0) then exit;
  Pt := jvDBGrid1.ScreenToClient(Mouse.CursorPos);
  Coord := TGridCoord(jvDBGrid1.MouseCoord(Pt.X, Pt.Y));
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

  searchField := self.jvDBGrid1.Fields[ClickCol].FieldName; //Column.FieldName; //.Field.Name;
  if (searchField='No_') AND (Manager.searchkey<>'') then self.Edit1.Text := Manager.searchkey;

  self.Edit1.Left:=self.jvDBGrid1.Left-(self.Edit1.Width div 3)+Pt.X;
  self.Edit1.Top :=self.jvDBGrid1.Top+self.Edit1.Height+Pt.Y;
  self.Edit1.Visible:=True;
  self.Edit1.BringToFront;
  self.Edit1.SetFocus;
end;

end.
