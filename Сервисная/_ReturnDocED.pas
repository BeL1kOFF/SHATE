unit _ReturnDocED;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponentBase, JvFormPlacement, StdCtrls, JvExStdCtrls,
  JvDBCombobox, AdvGlowButton, DBCtrls, Mask, ComCtrls, JvExComCtrls,
  JvDateTimePicker,JclSysUtils, JvDBDateTimePicker, Buttons, ExtCtrls, DBGridEh,
  DB, dbisamtb, DBCtrlsEh, DBLookupEh, AdvEdit, DBAdvEd;

type
  TReturnDocED = class(TForm)
    BtnBevel: TBevel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lbNameCli: TLabel;
    Label5: TLabel;
    DateEd: TJvDBDateTimePicker;
    NumEd: TDBEdit;
    DescriptionEd: TDBEdit;
    ClientComboBox: TDBLookupComboBox;
    TypeComboBox: TJvDBComboBox;
    FormStorage: TJvFormStorage;
    Label8: TLabel;
    btOpenContr: TButton;
    AgrDescr: TDBEdit;
    Label6: TLabel;
    Label9: TLabel;
    DeliveryComboBox: TJvDBComboBox;
    DS_Addres: TDataSource;
    AddresQuery: TDBISAMQuery;
    lbDefect: TLabel;
    lbReason: TLabel;
    ReasonComboBox: TJvDBComboBox;
    lbRedStar: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    lbRedStarReason: TLabel;
    lbMobile: TLabel;
    Phone1: TDBEdit;
    lbFIO: TLabel;
    Name: TDBEdit;
    FakeAddresDescr: TDBEdit;
    btOpenAddr: TButton;
    lbRedStarPhone: TLabel;
    lbRedStarAdr: TLabel;
    lbRedStarCli: TLabel;
    edPhoneExample: TEdit;
    edNameExample: TEdit;
    Label4: TLabel;
    Phone: TDBAdvMaskEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btOpenContrClick(Sender: TObject);
    procedure ClientComboBoxClick(Sender: TObject);

    procedure FillAddresCB(const Cli_id: String; Addr_ID: string = 'Д1');
    procedure SelectAddresByDefault(Cli_id: String);

    procedure DeliveryComboBoxChange(Sender: TObject);
    procedure btOpenAddrClick(Sender: TObject);
    procedure VisibleClientCombo(flag: boolean);
    procedure edPhoneExampleEnter(Sender: TObject);
    procedure edNameExampleEnter(Sender: TObject);
    procedure NameExit(Sender: TObject);
    procedure Phone1Exit(Sender: TObject);
    procedure Phone1KeyPress(Sender: TObject; var Key: Char);
    procedure NameKeyPress(Sender: TObject; var Key: Char);
    procedure PhoneExit(Sender: TObject);
    procedure FakeAddresDescrKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReturnDocED: TReturnDocED;
  Old_Cli_index : string;
     Cli_id: String;

implementation

{$R *.dfm}
Uses _Data, _Contracts, _Main;

procedure TReturnDocED.btOpenAddrClick(Sender: TObject);
begin
  with TContractsForm.Create(Application) do
  begin
    if Data.ClIDsTable.Locate('client_id', Data.ReturnDocTable.FieldByName('cli_id').AsString, []) then
      Client := Data.ClIDsTable.FieldByName('client_id').AsString;
    SetClientFilterAddr;
    Caption := 'Адрес получателя';
    ShowModal;
    if ModalResult = 1 then
    begin
      Data.ReturnDocTable.Edit;
      Data.ReturnDocTable.FieldByName('FakeAddresDescr').AsString := DS_Addr.DataSet.FieldByName('Addres').AsString;
      Data.ReturnDocTable.FieldByName('Addres_Id').AsString := DS_Addr.DataSet.FieldByName('Addres_Id').AsString;
      FakeAddresDescr.ReadOnly := Data.ReturnDocTable.FieldByName('Addres_Id').AsString = '';
      Data.ReturnDocTable.Post;
    end;
    Free;
  end;
end;

procedure TReturnDocED.btOpenContrClick(Sender: TObject);
begin
  with TContractsForm.Create(Application) do
  begin
    if Data.ClIDsTable.Locate('client_id', Data.ReturnDocTable.FieldByName('cli_id').AsString, []) then
      Client := Data.ClIDsTable.FieldByName('client_id').AsString;
    SetClientFilter;
    ShowModal;
    if ModalResult = 1 then
    begin
      Data.ReturnDocTable.Edit;
      Data.ReturnDocTable.FieldByName('Agreement_No').AsString := DS_Contract.DataSet.FieldByName('Contract_Id').AsString;
      Data.ReturnDocTable.FieldByName('AgrDescr').AsString := DS_Contract.DataSet.FieldByName('ContractDescr').AsString;
      Data.ReturnDocTable.FieldByName('AgrGroup').AsString := DS_Contract.DataSet.FieldByName('Group').AsString;
      Data.ReturnDocTable.Post;
      VisibleClientCombo(SameText(Data.ReturnDocTable.FieldByName('AgrGroup').AsString,'БН') or
                         SameText(Data.ReturnDocTable.FieldByName('AgrGroup').AsString,''));
    end;
    Free;
  end;
end;

procedure TReturnDocED.ClientComboBoxClick(Sender: TObject);
begin
  Data.ContractsCliTable.Filtered := False;

  if Data.ClIDsTable.Locate('client_id', Data.ReturnDocTable.FieldByName('cli_id').AsString, []) then
    Cli_id := Data.ClIDsTable.FieldByName('client_id').AsString;

  if Data.ContractsCliTable.Locate('Cli_id;Contract_Id',
    VarArrayOf([Cli_id,
                Data.ClIDsDataSource.DataSet.FieldByName('ContractByDefault').AsString]), []) then
  begin
    Data.ReturnDocDataSource.DataSet.FieldByName('Agreement_No').AsString :=
           Data.ContractsCliTable.FieldByName('Contract_Id').AsString;
    Data.ReturnDocDataSource.DataSet.FieldByName('AgrDescr').AsString := Main.GetMaskEdDir;
  end

  else
  begin
    Data.ReturnDocDataSource.DataSet.FieldByName('Agreement_No').AsString := '';
    Data.ReturnDocDataSource.DataSet.FieldByName('AgrDescr').AsString := '';
  end;

  if Data.ClIDsTable.FieldByName('AddresByDefault').AsString = '' then
    FillAddresCB(Cli_id)
  else
    FillAddresCB(Cli_id, Data.ClIDsTable.FieldByName('AddresByDefault').AsString);

  SelectAddresByDefault(Cli_id);
end;

procedure TReturnDocED.DeliveryComboBoxChange(Sender: TObject);
begin
//  AddresComboBox.Visible := DeliveryComboBox.ItemIndex = 0;
  Label9.Visible := DeliveryComboBox.ItemIndex = 0;
  btOpenAddr.Visible := DeliveryComboBox.ItemIndex = 0;
  FakeAddresDescr.Visible := DeliveryComboBox.ItemIndex = 0;
  lbRedStarAdr.Visible := DeliveryComboBox.ItemIndex = 0;
end;

procedure TReturnDocED.edNameExampleEnter(Sender: TObject);
begin
  edNameExample.Visible := FALSE;
  Name.SetFocus;
end;

procedure TReturnDocED.edPhoneExampleEnter(Sender: TObject);
begin
//  edPhoneExample.Visible := FALSE;
//  Phone.SetFocus;
end;

procedure TReturnDocED.FakeAddresDescrKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['a'..'z', 'A'..'Z']) then
    Key := #0;
end;

procedure TReturnDocED.FillAddresCB(const Cli_id: String; Addr_ID: string = 'Д1');
begin
  AddresQuery.SQL.Clear;
  AddresQuery.SQL.Add('select addres_id, addres from [047] where cli_id = :CLI_ID and Addres_ID = :Addres_ID');
  AddresQuery.Prepared := TRUE;
  AddresQuery.Params[0].Value := Cli_id;
  AddresQuery.Params[1].Value := Addr_ID;   
  AddresQuery.ExecSQL;
end;


procedure TReturnDocED.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Data.ClIDsTable.IndexName := Old_Cli_index;
end;

procedure TReturnDocED.FormCreate(Sender: TObject);
begin
  Old_Cli_index := Data.ClIDsTable.IndexName;
  Data.ClIDsTable.IndexName := 'Descr';
  AddresQuery.DatabaseName := Main.GetCurrentBD;

  if Data.ClIDsTable.Locate('client_id', Data.ReturnDocTable.FieldByName('cli_id').AsString, []) then
    Cli_id := Data.ClIDsTable.FieldByName('client_id').AsString;

  if Data.ClIDsTable.FieldByName('AddresByDefault').AsString = '' then
    FillAddresCB(Cli_id)
  else
    FillAddresCB(Cli_id, Data.ClIDsTable.FieldByName('AddresByDefault').AsString);

  DeliveryComboBoxChange(nil);

  //****DEFECT********
  if Data.ReturnDocTable.FieldByName('fDefect').AsBoolean then
    self.Caption := 'БРАК'
  else
    self.Caption := 'Возврат';

  lbDefect.Visible := Data.ReturnDocTable.FieldByName('fDefect').AsBoolean;
  lbReason.Visible := Data.ReturnDocTable.FieldByName('fDefect').AsBoolean;
  ReasonComboBox.Visible := Data.ReturnDocTable.FieldByName('fDefect').AsBoolean;
  lbRedStar.Visible := Data.ReturnDocTable.FieldByName('fDefect').AsBoolean;
  lbRedStarReason.Visible := Data.ReturnDocTable.FieldByName('fDefect').AsBoolean;


  if Data.ReturnDocTable.FieldByName('Phone').AsString = '' then
  begin
    Data.ReturnDocTable.Edit;
    Data.ReturnDocTable.FieldByName('Phone').AsString := Main.TrimAll(Data.ClIDsDataSource.DataSet.FieldByName('Phone').AsString);
    Data.ReturnDocTable.Post;
  end;

  if Data.ReturnDocTable.FieldByName('Name').AsString = '' then
  begin
    Data.ReturnDocTable.Edit;
    Data.ReturnDocTable.FieldByName('Name').AsString := Data.ClIDsDataSource.DataSet.FieldByName('Name').AsString;
    Data.ReturnDocTable.Post;
  end;

  FakeAddresDescr.ReadOnly := Data.OrderTable.FieldByName('Addres_Id').AsString = '';
  SelectAddresByDefault(Cli_id);
 // edPhoneExample.Visible := Length(Phone.Text) = 0;
  edNameExample.Visible := Length(Name.Text) = 0;
end;

procedure TReturnDocED.NameExit(Sender: TObject);
begin
  edNameExample.Visible := (Length(Name.Text) = 0);
end;

procedure TReturnDocED.NameKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['0'..'9', ',', '-', '+', '\' , '/', '=', 'a'..'z', 'A'..'Z']) then
    Key := #0;
end;

procedure TReturnDocED.Phone1Exit(Sender: TObject);
begin
//  edPhoneExample.Visible := (Length(Phone.Text) = 0);
end;

procedure TReturnDocED.Phone1KeyPress(Sender: TObject; var Key: Char);
begin
{  if not (Key in ['0'..'9', '+', #8]) then
    Key := #0
  else if (Key = '+') then
    if (pos('+', Phone.text) = 1) or (Length(Phone.text) > 0) then
      Key := #0}
end;

procedure TReturnDocED.PhoneExit(Sender: TObject);
begin
  Main.TrimField(Data.ReturnDocTable, 'Phone');
end;

procedure TReturnDocED.SelectAddresByDefault(Cli_id: String);
begin
  if (FakeAddresDescr.Visible) and (Data.ReturnDocTable.FieldByName('FakeAddresDescr').AsString = '') then
  begin
    Data.ReturnDocTable.Edit;
    if (Data.ClIDsTable.FieldByName('AddresDescrByDefault').AsString <> '') then
      Data.ReturnDocTable.FieldByName('FakeAddresDescr').AsString :=  Data.ClIDsTable.FieldByName('AddresDescrByDefault').AsString
    else
      Data.ReturnDocTable.FieldByName('FakeAddresDescr').AsString :=  AddresQuery.FieldByName('Addres').AsString;
    Data.ReturnDocTable.FieldByName('Addres_Id').AsString := AddresQuery.FieldByName('Addres_Id').AsString;    Data.ReturnDocTable.Post;
  end;
end;

procedure TReturnDocED.VisibleClientCombo(flag: boolean);
begin
  lbNameCli.Visible := flag;
  ClientComboBox.Visible := flag;

  lbFIO.Visible := not flag;
  Name.Visible := not flag;
  Phone.Visible := not flag;
  lbMobile.Visible := not flag;
  lbRedStarPhone.Visible := not flag;

//  edPhoneExample.Visible := (not flag) and (Length(Phone.Text) = 0);
  edNameExample.Visible := (not flag) and (Length(Name.Text) = 0);
end;

end.
