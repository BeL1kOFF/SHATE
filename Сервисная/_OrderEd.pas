unit _OrderEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BSDlgFrm, StdCtrls, Mask, DBCtrls, ComCtrls, JvExComCtrls,
  JvDateTimePicker, JvDBDateTimePicker, Buttons, ExtCtrls, JvComponentBase,
  JvFormPlacement, JvExControls, JvButton, JvTransparentButton, AdvPanel,
  AdvToolBtn, AdvGlowButton, JvExStdCtrls, JvDBCombobox, JclSysUtils, JvCombobox,
  DB, dbisamtb, DBGridEh, DBCtrlsEh, DBLookupEh, JvExMask, JvToolEdit,
  JvDBLookup, JvDBLookupComboEdit, JvMaskEdit, JvDBControls, AdvEdit, DBAdvEd,
  AppEvnts;

type
  TOrderEdit = class(TDialogForm)
    FormStorage: TJvFormStorage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lbNameCli: TLabel;
    DateEd: TJvDBDateTimePicker;
    NumEd: TDBEdit;
    DescriptionEd: TDBEdit;
    ClientComboBox: TDBLookupComboBox;
    ClearClientBtn: TAdvGlowButton;
    Label5: TLabel;
    TypeComboBox: TJvDBComboBox;
    DeliveryComboBox: TJvDBComboBox;
    Label6: TLabel;
    Label7: TLabel;
    CurrCombo: TJvDBComboBox;
    TableCli: TDBISAMTable;
    DataSourceCli: TDataSource;
    AddresQuery: TDBISAMQuery;
    DS_Addres: TDataSource;
    DBEdit1: TDBEdit;
    OrderCliChangeTimer: TTimer;
    Label8: TLabel;
    btOpenContr: TButton;
    AgrDescr: TDBEdit;
    lbAddr: TLabel;
    Name: TDBEdit;
    Phone1: TDBEdit;
    lbFIO: TLabel;
    lbMobile: TLabel;
    FakeAddresDescr: TDBEdit;
    btOpenAddr: TButton;
    lbRedStarAgr: TLabel;
    lbRedStarAdr: TLabel;
    lbRedStarPhone: TLabel;
    lbRedStarCli: TLabel;
    Label12: TLabel;
    edNameExample: TEdit;
    edPhoneExample1: TEdit;
    Phone: TDBAdvMaskEdit;
    cbNearestDelivery: TDBCheckBox;
    procedure ClearClientBtnClick(Sender: TObject);
    procedure ClientComboBoxCloseUp(Sender: TObject);
    procedure ClientComboBoxEnter(Sender: TObject);
    procedure DeliveryComboBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TypeComboBoxChange(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure btOpenContrClick(Sender: TObject);
    procedure ClientComboBoxClick(Sender: TObject);

    procedure SelectAddresByDefault(Cli_id: String);
    procedure FillAddresCB(const Cli_id: String; Addr_ID: string = 'Д1');
    procedure SetNearestDeliveryVisible(const aComment: string);

    procedure SaveActualOrderPar(Par: TStringList);
    procedure SetDirtyOrder(Par: TStringList);
    procedure DBEdit1Change(Sender: TObject);
    procedure OrderCliChangeTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btOpenAddrClick(Sender: TObject);
    procedure VisibleClientCombo(flag: boolean);
    procedure edNameExampleEnter(Sender: TObject);
    procedure NameExit(Sender: TObject);
    procedure NameKeyPress(Sender: TObject; var Key: Char);
    procedure PhoneExit(Sender: TObject);
    procedure DescriptionEdChange(Sender: TObject);
    procedure FakeAddresDescrKeyPress(Sender: TObject; var Key: Char);
    procedure edNameExampleKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    OldCli: string;
  public
    procedure UpdateCurrencyControls;
  end;

var
  OrderEdit: TOrderEdit;
  Cli_id: string;
  ActualOrderPar: TStringList;

implementation

uses _Main, _Data, _Contracts;

{$R *.dfm}

procedure TOrderEdit.btOpenContrClick(Sender: TObject);
begin
  inherited;
  with TContractsForm.Create(Application) do
  begin
    Client := Cli_id;
    SetClientFilter;
    ShowModal;
    if ModalResult = 1 then
    begin
      datasource.DataSet.FieldByName('AgrDescr').AsString := DS_Contract.DataSet.FieldByName('ContractDescr').AsString;
      DataSource.DataSet.FieldByName('Agreement_No').AsString := DS_Contract.DataSet.FieldByName('Contract_Id').AsString;
      DataSource.DataSet.FieldByName('AgrGroup').AsString := DS_Contract.DataSet.FieldByName('Group').AsString;
      SelectAddresByDefault(Cli_id);

      VisibleClientCombo(SameText(DataSource.DataSet.FieldByName('AgrGroup').AsString,'БН') or
                     SameText(DataSource.DataSet.FieldByName('AgrGroup').AsString,''));
    end;
    Free;
  end;
end;

procedure TOrderEdit.btOpenAddrClick(Sender: TObject);
begin
  inherited;
  with TContractsForm.Create(Application) do
  begin
    Client := Cli_id;
    SetClientFilterAddr;
    Caption := 'Адрес получателя';
    ShowModal;
    if ModalResult = 1 then
    begin
      datasource.DataSet.FieldByName('FakeAddresDescr').AsString :=
                             DS_Addr.DataSet.FieldByName('Addres').AsString;
      datasource.DataSet.FieldByName('Addres_Id').AsString :=
                             DS_Addr.DataSet.FieldByName('Addres_Id').AsString;
      FakeAddresDescr.ReadOnly := Data.OrderTable.FieldByName('Addres_Id').AsString = '';
      SelectAddresByDefault(Cli_id);
    end;
    Free;
  end;

end;

procedure TOrderEdit.ClearClientBtnClick(Sender: TObject);
begin
  inherited;
  Data.OrderTable.FieldByName('Cli_id').Clear;
  OldCli := '';
end;

procedure TOrderEdit.ClientComboBoxClick(Sender: TObject);
begin
  inherited;

  if Data.ClIDsTable.Locate('client_id', Data.OrderTable.FieldByName('cli_id').AsString, []) then
    Cli_id := Data.ClIDsTable.FieldByName('client_id').AsString;

  DataSource.DataSet.FieldByName('Agreement_No').AsString :=
            Data.ClIDsTable.FieldByName('ContractbyDefault').AsString;

  if Data.ContractsCliTable.Locate('Cli_id;Contract_Id',
    VarArrayOf([Data.ClIDsDataSource.DataSet.FieldByName('client_id').AsString ,
                Data.ClIDsDataSource.DataSet.FieldByName('ContractByDefault').AsString]), []) then
    datasource.DataSet.FieldByName('AgrDescr').AsString := Main.GetMaskEdDir
  else
    datasource.DataSet.FieldByName('AgrDescr').AsString := '';

//  SelectAddresByDefault(cli_id);
  if Data.ClIDsTable.FieldByName('AddresByDefault').AsString = '' then
    FillAddresCB(Cli_id)
  else
    FillAddresCB(Cli_id, Data.ClIDsTable.FieldByName('AddresByDefault').AsString);


  SelectAddresByDefault(Cli_id);
end;

procedure TOrderEdit.ClientComboBoxCloseUp(Sender: TObject);
var
  Cli: string;
begin
  inherited;
  Cli := iff(ClientComboBox.KeyValue <> null, ClientComboBox.KeyValue, 0);
  if Cli <> OldCli then
  begin
    with Data.ClIDsTable do
    begin
      if FieldByName('Client_ID').AsString <> Cli then
        Locate('Client_ID', Cli, []);
      {$IFDEF LOCAL}
        OrderCliChangeTimer.Enabled := False;
        OrderCliChangeTimer.Enabled := True;
      {$ENDIF}
      Data.OrderTable.FieldByName('Type').Value := FieldByName('Order_type').AsString;
      ClientComboBox.ListFieldIndex := 1;
      if FieldByName('Order_type').AsString = '' then
        FieldByName('Order_type').Value := 'A';
    end;
    OldCli := Cli;
  end;
end;

procedure TOrderEdit.ClientComboBoxEnter(Sender: TObject);
begin
  inherited;
  ClientComboBox.ListFieldIndex := 1;
  OldCli := iff(ClientComboBox.KeyValue <> null, ClientComboBox.KeyValue, 0);
end;

procedure TOrderEdit.DBEdit1Change(Sender: TObject);
begin
  inherited;
  UpdateCurrencyControls;
end;

procedure TOrderEdit.DeliveryComboBoxChange(Sender: TObject);
begin
  //AddresComboBox.Visible := DeliveryComboBox.ItemIndex = 0;
  //Label9.Visible := DeliveryComboBox.ItemIndex = 0;
  FakeAddresDescr.Visible := DeliveryComboBox.ItemIndex = 0;
  lbAddr.Visible := DeliveryComboBox.ItemIndex = 0;
  btOpenAddr.Visible := DeliveryComboBox.ItemIndex = 0;
  lbRedStarAdr.Visible := DeliveryComboBox.ItemIndex = 0;
  cbNearestDelivery.Visible := DeliveryComboBox.ItemIndex = 0;
   
  Exit; //SD

 (* if (TypeComboBox.ItemIndex = 1) and(DeliveryComboBox.ItemIndex = 1) then
  begin
//    CurrCombo.Visible := TRUE;
//    Label7.Visible := TRUE;

    CurrCombo.ItemIndex := -1;

    CurrCombo.Items.Clear;
    CurrCombo.Items.Insert(0,'EUR');
    CurrCombo.Items.Insert(1,'BYR');
    CurrCombo.Items.Insert(2,'USD');
    CurrCombo.Items.Insert(3,'RUB');

    CurrCombo.Values.Clear;
    CurrCombo.Values.Insert(0,'1');
    CurrCombo.Values.Insert(1,'2');
    CurrCombo.Values.Insert(2,'3');
    CurrCombo.Values.Insert(3,'4');
    CurrCombo.ItemIndex := 1;
  end
  else
     if (TypeComboBox.ItemIndex = 1) and(DeliveryComboBox.ItemIndex = 0) then
  begin
//    CurrCombo.Visible := TRUE;
//    Label7.Visible := TRUE;

    CurrCombo.ItemIndex := -1;

    CurrCombo.Items.Clear;
    CurrCombo.Items.Insert(0,'BYR');
    CurrCombo.Items.Insert(1,'USD');
    CurrCombo.Items.Insert(2,'RUB');

    CurrCombo.Values.Clear;
    CurrCombo.Values.Insert(0,'2');
    CurrCombo.Values.Insert(1,'3');
    CurrCombo.Values.Insert(2,'4');
    CurrCombo.ItemIndex := 0;

  end
  else
  begin
    CurrCombo.Visible := FALSE;
    CurrCombo.ItemIndex := 1;
    Label7.Visible := FALSE;
  end;
     *)
end;

procedure TOrderEdit.DescriptionEdChange(Sender: TObject);
begin
  inherited;
  SetNearestDeliveryVisible(DescriptionEd.Text);
end;

procedure TOrderEdit.edNameExampleEnter(Sender: TObject);
begin
  inherited;
  edNameExample.Visible := FALSE;
  Name.SetFocus;
end;

procedure TOrderEdit.edNameExampleKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key in ['a'..'z', 'A'..'Z']) then
    Key := #0;
end;

procedure TOrderEdit.FakeAddresDescrKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key in ['a'..'z', 'A'..'Z']) then
    Key := #0;
end;

procedure TOrderEdit.FillAddresCB(const Cli_id: String; Addr_ID: string = 'Д1');
begin
  AddresQuery.SQL.Clear;
  AddresQuery.SQL.Add('select addres_id, addres from [047] where cli_id = :CLI_ID and Addres_ID = :Addres_ID');
  AddresQuery.Prepared := TRUE;
  AddresQuery.Params[0].Value := Cli_id;
  AddresQuery.Params[1].Value := Addr_ID;   
  AddresQuery.ExecSQL;
end;

procedure TOrderEdit.FormCreate(Sender: TObject);
begin
  AddresQuery.DatabaseName := Main.GetCurrentBD;
  TableCli.DatabaseName := Main.GetCurrentBD;
  ActualOrderPar := TStringList.Create;
  TableCli.Open;

  CurrCombo.ItemIndex := -1;
  CurrCombo.Items.Clear;

  CurrCombo.Items.Insert(0,'BYR');
  CurrCombo.Items.Insert(1,'USD');
  CurrCombo.Items.Insert(2,'RUB');
  CurrCombo.Values.Clear;

  CurrCombo.Values.Insert(0,'2');
  CurrCombo.Values.Insert(1,'3');
  CurrCombo.Values.Insert(2,'4');

  if (Data.OrderTable.FieldByName('Currency').AsString = '0') or (Data.OrderTable.FieldByName('Currency').AsString = '') then
    CurrCombo.ItemIndex := 0
  else
    CurrCombo.ItemIndex := Data.OrderTable.FieldByName('Currency').AsInteger-2;

  Data.ContractsCliTable.Filtered := False;
  Data.ContractsCliTable.CancelRange;

  if Data.ClIDsTable.Locate('client_id', Data.OrderTable.FieldByName('cli_id').AsString, []) then
    Cli_id := Data.ClIDsTable.FieldByName('client_id').AsString;

  if Data.ClIDsTable.FieldByName('AddresByDefault').AsString = '' then
    FillAddresCB(Cli_id)
  else
    FillAddresCB(Cli_id, Data.ClIDsTable.FieldByName('AddresByDefault').AsString);

  if Data.OrderTable.FieldByName('Agreement_No').AsString <> '' then
  begin
    Data.OrderTable.Edit;
    if Data.ContractsCliTable.Locate('Contract_id;cli_id',
            VarArrayOf([Data.OrderTable.FieldByName('Agreement_No').AsString, cli_id]),[]) then
    begin
      if Data.OrderTable.FieldByName('AgrDescr').AsString <> Main.GetMaskEdDir then
        Data.OrderTable.FieldByName('AgrDescr').AsString := Main.GetMaskEdDir;
    end
    else
      Data.OrderTable.FieldByName('AgrDescr').AsString := Main.AgrNotFound(Data.OrderTable.FieldByName('AgrDescr').AsString);

    Data.OrderTable.Post;
    SaveActualOrderPar(ActualOrderPar);
  end
  else
  begin
    if Data.ContractsCliTable.Locate('Cli_id;Contract_Id',
       VarArrayOf([cli_id,Data.ClIDsTable.FieldByName('ContractByDefault').AsString]), []) then
    begin
      Data.OrderTable.Edit;
      Data.OrderTable.FieldByName('Agreement_No').AsString := Data.ContractsCliTable.FieldByName('Contract_Id').AsString;
      Data.OrderTable.FieldByName('AgrDescr').AsString := Main.GetMaskEdDir;
      Data.OrderTable.FieldByName('AgrGroup').AsString := Data.ContractsCliTable.FieldByName('Group').AsString;
      Data.OrderTable.Post;
      SaveActualOrderPar(ActualOrderPar);
    end;

    SelectAddresByDefault(Cli_id); //в Select в комбик!
  end;

  if Data.OrderTable.FieldByName('Phone').AsString = '' then
  begin
    Data.OrderTable.Edit;
    Data.OrderTable.FieldByName('Phone').AsString := Main.TrimAll(DataSourceCli.DataSet.FieldByName('Phone').AsString);
    Data.OrderTable.Post;
  end;

  if Data.OrderTable.FieldByName('Name').AsString = '' then
  begin
    Data.OrderTable.Edit;
    Data.OrderTable.FieldByName('Name').AsString := DataSourceCli.DataSet.FieldByName('Name').AsString;
    Data.OrderTable.Post;
  end;

  FakeAddresDescr.ReadOnly := Data.OrderTable.FieldByName('Addres_Id').AsString = '';

  VisibleClientCombo(SameText(Data.OrderTable.FieldByName('AgrGroup').AsString,'БН') or
                     SameText(Data.OrderTable.FieldByName('AgrGroup').AsString,''));
  SelectAddresByDefault(Cli_id);
  UpdateCurrencyControls;
  DeliveryComboBoxChange(nil);
end;

procedure TOrderEdit.FormDeactivate(Sender: TObject);
begin
  inherited;
  TableCli.Close;
end;

procedure TOrderEdit.FormShow(Sender: TObject);
begin
  inherited;
//
end;

procedure TOrderEdit.NameExit(Sender: TObject);
begin
  inherited;
  edNameExample.Visible := (Length(Name.Text) = 0);
end;

procedure TOrderEdit.NameKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key in ['0'..'9', ',', '-', '+', '\' , '/', '=', 'a'..'z', 'A'..'Z']) then
    Key := #0;
end;

procedure TOrderEdit.OrderCliChangeTimerTimer(Sender: TObject);
var
  Cli: String;
  i: integer;
  User: TUserIDRecord;
begin
  inherited;
  user := nil;
  OrderCliChangeTimer.Enabled := False;
  Cli := iff(ClientComboBox.KeyValue <> null, ClientComboBox.KeyValue, 0);
  with Data.ClIDsTable do
  begin
    if FieldByName('Client_ID').AsString <> Cli then
      if not Locate('Client_ID', Cli, []) then
        exit;
   // User := TUserIDRecord.Create;
    try
    for i := 0 to Main.ClientList.Count - 1 do
    begin
      if TUserIDRecord(Main.ClientList[i]).sId = Cli then
      begin
        User := Main.ClientList[i];
        Break;
      end;
    end;
    Main.LoadDescriptionsTCP_Local(User);
    finally
      //User.Free;
    end;
  end;
end;

procedure TOrderEdit.PhoneExit(Sender: TObject);
begin
  inherited;
  Main.TrimField(Data.OrderTable, 'Phone');
end;

procedure TOrderEdit.SaveActualOrderPar(Par: TStringList);
begin
  Par.Append(Data.OrderTable.FieldByName('Addres_id').AsString);
  Par.Append(cli_id);
  Par.Append(Data.OrderTable.FieldByName('Delivery').AsString);
  Par.Append(Data.OrderTable.FieldByName('Agreement_No').AsString);
end;

procedure TOrderEdit.SelectAddresByDefault(Cli_id: String);
begin
  with Data.OrderTable do
  begin
    if (FakeAddresDescr.Visible) and (FieldByName('FakeAddresDescr').AsString = '') then
    begin
      Edit;
      if (Data.ClIDsTable.FieldByName('AddresDescrByDefault').AsString <> '') then
        FieldByName('FakeAddresDescr').AsString :=  Data.ClIDsTable.FieldByName('AddresDescrByDefault').AsString
      else
        FieldByName('FakeAddresDescr').AsString :=  AddresQuery.FieldByName('Addres').AsString;
      //анализируем при выполнении запроса
      FieldByName('Addres_Id').AsString := AddresQuery.FieldByName('Addres_Id').AsString;
      Post;
    end;
  end;
end;

procedure TOrderEdit.SetDirtyOrder(Par: TStringList);
begin
  if Par.Count > 0 then
    if (Par[0] <> Data.OrderTable.FieldByName('Addres_id').AsString)
        or (Par[1] <> cli_id)
          or (Par[2] <> Data.OrderTable.FieldByName('Delivery').AsString)
            or (Par[3] <> Data.OrderTable.FieldByName('Agreement_No').AsString) then
    begin
      DataSource.Dataset.Edit;
      DataSource.Dataset.FieldByName('Dirty').Value := True;
      DataSource.Dataset.Post;
    end;
  Par.Free;
end;

procedure TOrderEdit.SetNearestDeliveryVisible(const aComment: string);
begin
  if Data.OrderTable.FieldByName('NearestDelivery').AsBoolean <> (length(aComment) = 0) then
  begin
    Data.OrderTable.Edit;
    Data.OrderTable.FieldByName('NearestDelivery').AsBoolean := length(aComment) = 0;
    Data.OrderTable.Post;
  end;
end;

procedure TOrderEdit.TypeComboBoxChange(Sender: TObject);
begin
(*exit; //SD

  if (TypeComboBox.ItemIndex = 1) and(DeliveryComboBox.ItemIndex = 1) then
  begin
//    CurrCombo.Visible := TRUE;
//    Label7.Visible := TRUE;

    CurrCombo.ItemIndex := -1;

    CurrCombo.Items.Clear;
    CurrCombo.Items.Insert(0,'EUR');
    CurrCombo.Items.Insert(1,'BYR');
    CurrCombo.Items.Insert(2,'USD');
    CurrCombo.Items.Insert(3,'RUB');

    CurrCombo.Values.Clear;
    CurrCombo.Values.Insert(0,'1');
    CurrCombo.Values.Insert(1,'2');
    CurrCombo.Values.Insert(2,'3');
    CurrCombo.Values.Insert(3,'4');
    CurrCombo.ItemIndex := 1;                            
  end
  else
    if (TypeComboBox.ItemIndex = 1) and(DeliveryComboBox.ItemIndex = 0) then
  begin
//    CurrCombo.Visible := TRUE;
//    Label7.Visible := TRUE;

    CurrCombo.ItemIndex := -1;

    CurrCombo.Items.Clear;
    CurrCombo.Items.Insert(0,'BYR');
    CurrCombo.Items.Insert(1,'USD');
    CurrCombo.Items.Insert(2,'RUB');

    CurrCombo.Values.Clear;
    CurrCombo.Values.Insert(0,'2');
    CurrCombo.Values.Insert(1,'3');
    CurrCombo.Values.Insert(2,'4');
    CurrCombo.ItemIndex := 0;

  end
  else
  begin
    CurrCombo.Visible := FALSE;
    CurrCombo.ItemIndex := 1;
    Label7.Visible := FALSE;
  end;

       *)
end;

procedure TOrderEdit.UpdateCurrencyControls;
begin
  //exit;
  CurrCombo.Hide;
  Label7.Hide;

  if Data.OrderTable.FieldByName('Agreement_No').AsString <> '' then
  begin
    if Data.IsMultiCurrAgr(Cli_id, Data.OrderTable.FieldByName('Agreement_No').AsString) and
       Data.IsRusRegionCode(Data.OrderTable.FieldByName('Cli_id').AsString,
                            Data.OrderTable.FieldByName('Agreement_No').AsString) then
    begin
      CurrCombo.ItemIndex := -1;

      CurrCombo.Items.Clear;
      CurrCombo.Values.Clear;

      CurrCombo.Items.Insert(0,'BYR');
      CurrCombo.Items.Insert(1,'USD');
      CurrCombo.Items.Insert(2,'RUB');

      CurrCombo.Values.Insert(0,'2');
      CurrCombo.Values.Insert(1,'3');
      CurrCombo.Values.Insert(2,'4');
      
      CurrCombo.ItemIndex := 2;

      //CurrCombo.Show;
     // Label7.Show;
    end;
  end;
end;

procedure TOrderEdit.VisibleClientCombo(flag: boolean);
begin
  lbNameCli.Visible := flag;
  ClientComboBox.Visible := flag;
  ClearClientBtn.Visible := flag;

  lbFIO.Visible := not flag;
  Name.Visible := not flag;
  Phone.Visible := not flag;
  lbMobile.Visible := not flag;
  lbRedStarPhone.Visible := not flag;

  //edPhoneExample.Visible := (not flag) and (Length(Phone.Text) = 0);
  edNameExample.Visible := (not flag) and (Length(Name.Text) = 0);
end;

end.
