unit _Contracts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, Buttons, GridsEh, DBGridEh, DBCtrlsEh,
  DBLookupEh, ExtCtrls, AdvPanel, ComCtrls, DB, ADODB, dbisamtb, JvExExtCtrls,
  JvBevel;

type
  TContractsForm = class(TForm)
    Q1: TDBISAMQuery;
    ContractGrid: TDBGridEh;
    Bevel1: TBevel;
    JvBevel1: TJvBevel;
    GroupBox: TComboBox;
    Label1: TLabel;
    CurrencyBox: TComboBox;
    Label2: TLabel;
    btSetDefContr: TBitBtn;
    ContractQuery: TDBISAMQuery;
    DS_Contract: TDataSource;
    AddresGrid: TDBGridEh;
    DS_Addr: TDataSource;
    procedure FilterComboBox(ActiveBox, PassiveBox1: TComboBox);
    function GetFieldName(BoxName:string): string;
    procedure CurrencyBoxChange(Sender: TObject);
    procedure GroupBoxChange(Sender: TObject);
    procedure SetDefaultContract();
    procedure SetClientFilter();
    procedure SetClientFilterAddr();
    procedure btSetDefContrClick(Sender: TObject);
    procedure ContractGridDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure AddresGridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ContractsForm: TContractsForm;
  Client: string;

implementation

uses
 _Main, _Data, _ClIDEd;
{$R *.dfm}

procedure TContractsForm.btSetDefContrClick(Sender: TObject);
begin
  SetDefaultContract();
end;

procedure TContractsForm.CurrencyBoxChange(Sender: TObject);
begin
  FilterComboBox(CurrencyBox,GroupBox);
end;

procedure TContractsForm.AddresGridDblClick(Sender: TObject);
begin
  if DS_Addr.DataSet.FieldByName('Addres').AsString = '' then
    MessageDlg('Не выбран адрес!', mtError, [mbOK], 0)
  else
    ModalResult := mrOK;
end;

procedure TContractsForm.ContractGridDblClick(Sender: TObject);
begin
  if btSetDefContr.Visible then
    btSetDefContrClick(nil);
end;

procedure TContractsForm.FilterComboBox(ActiveBox, PassiveBox1: TComboBox);
var
  SQL: String;
begin
  if not main.memAgr.IsEmpty then
    SQL := 'select *, Adr.Addres + '' ('' +Adr.Addres_id + '')'' as AdrField from "Memory\memAgr" Agr Left Join "Memory\memAddres" Adr on (Agr.Addres_id = Adr.Addres_id and Agr.cli_id = Adr.cli_id) where Agr.cli_id = '''+ Client+''''
  else
    SQL := 'select *,[047].Addres + '' ('' + [047].Addres_id + '')'' as AdrField from [048] Left Join [047] on ([048].Addres_id = [047].Addres_id and [048].cli_id = [047].cli_id ) where [048].cli_id = '''+ Client+'''';

  if ActiveBox.ItemIndex > -1 then
  begin
    SQL := SQL + ' and '+ GetFieldName(ActiveBox.name) + ''''+ ActiveBox.Items.Strings[ActiveBox.ItemIndex]+ '''';
    if PassiveBox1.ItemIndex > -1 then
      SQL := SQL + ' and '+ GetFieldName(PassiveBox1.name) + ''''+ PassiveBox1.Items.Strings[PassiveBox1.ItemIndex]+ '''';
  end
  else
    if PassiveBox1.ItemIndex > -1 then
      SQL := SQL + ' and '+ GetFieldName(PassiveBox1.name) + ''''+ PassiveBox1.Items.Strings[PassiveBox1.ItemIndex]+ '''';

  Q1.SQL.Clear;
  Q1.SQL.Add(SQL);
  Q1.ExecSQL;

end;

procedure TContractsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  main.memAgr.Close;
  main.memAddres.Close;
end;

procedure TContractsForm.FormCreate(Sender: TObject);
begin
 {$IFDEF LOCAL}
  Q1.DatabaseName := Main.GetCurrentBD;
 {$ENDIF}
end;

function TContractsForm.GetFieldName(BoxName:string): string;
begin
  if copy(BoxName,1,5)='Curre' then
    result := 'Currency='
  else if copy(BoxName,1,5)='Group' then
    result := 'Group=';
end;

procedure TContractsForm.GroupBoxChange(Sender: TObject);
begin
  FilterComboBox(GroupBox, CurrencyBox);
end;

procedure TContractsForm.SetClientFilter;
var
  Qwery : TDBISAMQuery;
  SQL1, SQL2: String;
begin
  Qwery := TDBISAMQuery.Create(nil);
  try
    Qwery.DatabaseName := Data.Database.DatabaseName;
    DS_Contract.DataSet := Q1;
    Data.ContractsCliTable.Active := True;
    main.memAgr.Open;
    main.memAddres.Open;
    if not main.memAgr.IsEmpty then
    begin
      SQL1 := 'select DISTINCT Currency from "Memory\memAgr" where cli_id = '''+ Client+'''';
      SQL2 := 'select DISTINCT Group from "Memory\memAgr" where cli_id =  '''+ Client+''''
    end
    else
    begin
      SQL1 := 'select DISTINCT Currency from [048] where cli_id = '''+ Client+'''';
      SQL2 := 'select DISTINCT Group from [048] where cli_id =  '''+ Client+''''
    end;
    Qwery.sql.Clear;
    Qwery.sql.Add(SQL1);
    Qwery.ExecSQL;
    Qwery.First;
    while not Qwery.Eof do
    begin
      CurrencyBox.Items.Add(Qwery.FieldByName('Currency').AsString);
      Qwery.Next;
    end;

    Qwery.sql.Clear;
    Qwery.sql.Add(SQL2);
    Qwery.ExecSQL;
    Qwery.First;
    while not Qwery.Eof do
    begin
      GroupBox.Items.Add(Qwery.FieldByName('Group').AsString);
      Qwery.Next;
    end;
  finally
    Qwery.Free;
  end;

  FilterComboBox(GroupBox, CurrencyBox);
end;

procedure TContractsForm.SetClientFilterAddr;
var
  SQL: string;
begin
    AddresGrid.Visible := TRUE;
    q1.DatabaseName := Main.GetCurrentBD;
    try
      main.memAgr.Open;
      main.memAddres.Open;
      if not main.memAgr.IsEmpty then
        SQL := 'select addres,Addres_Id from "Memory\memAddres" where cli_id = '''+ Client+''''
      else
        SQL := 'select addres,Addres_Id from [047] where cli_id = '''+ Client+'''';
      q1.SQL.Clear;
      q1.SQL.Add(SQL);
      q1.Open;
    except
      //
    end;   
end;

procedure TContractsForm.SetDefaultContract();
begin
 { if DS_Contract.DataSet.FieldByName('Contract_Id').AsString = '' then
    MessageDlg('Не выбран контрагент!', mtError, [mbOK], 0)
  else
    ModalResult := mrOK;}
  if AddresGrid.Visible then
  begin
    if DS_Addr.DataSet.FieldByName('Addres_Id').AsString = '' then
      MessageDlg('Не выбран адрес!', mtError, [mbOK], 0)
    else
      ModalResult := mrOK;
  end
  else
  begin
    if DS_Contract.DataSet.FieldByName('Contract_Id').AsString = '' then
      MessageDlg('Не выбран контрагент!', mtError, [mbOK], 0)
    else
      ModalResult := mrOK;
  end;
  
end;

end.

