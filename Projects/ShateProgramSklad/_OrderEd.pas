unit _OrderEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BSDlgFrm, StdCtrls, Mask, DBCtrls, ComCtrls, JvExComCtrls,
  JvDateTimePicker, JvDBDateTimePicker, Buttons, ExtCtrls, JvComponentBase,
  JvFormPlacement, JvExControls, JvButton, JvTransparentButton, AdvPanel,
  AdvToolBtn, AdvGlowButton, JvExStdCtrls, JvDBCombobox, JclSysUtils, JvCombobox;

type
  TOrderEdit = class(TDialogForm)
    FormStorage: TJvFormStorage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
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
    procedure ClearClientBtnClick(Sender: TObject);
    procedure ClientComboBoxCloseUp(Sender: TObject);
    procedure ClientComboBoxEnter(Sender: TObject);
    procedure DeliveryComboBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TypeComboBoxChange(Sender: TObject);
  private
    { Private declarations }
    OldKli: string;
  public
    { Public declarations }
  end;

var
  OrderEdit: TOrderEdit;

implementation

uses _Main, _Data;

{$R *.dfm}

procedure TOrderEdit.ClearClientBtnClick(Sender: TObject);
begin
  inherited;
  Data.OrderTable.FieldByName('Cli_id').Clear;
  OldKli := '';
end;

procedure TOrderEdit.ClientComboBoxCloseUp(Sender: TObject);
var
  kli: string;
begin
  inherited;
  kli := iff(ClientComboBox.KeyValue <> null, ClientComboBox.KeyValue, 0);
  if kli <> OldKli then
  begin
    with Data.ClIDsTable do
    begin
      if FieldByName('Client_ID').AsString <> kli then
        Locate('Client_ID', kli, []);
      Data.OrderTable.FieldByName('Type').Value := FieldByName('Order_type').AsString;
      ClientComboBox.ListFieldIndex := 1; 
      if FieldByName('Order_type').AsString = '' then
        FieldByName('Order_type').Value := 'A';
    end;
    OldKli := kli;
  end;
end;

procedure TOrderEdit.ClientComboBoxEnter(Sender: TObject);
begin
  inherited;
  ClientComboBox.ListFieldIndex := 1;
  OldKli := iff(ClientComboBox.KeyValue <> null, ClientComboBox.KeyValue, 0);
end;

procedure TOrderEdit.DeliveryComboBoxChange(Sender: TObject);
var CurrIdex:integer;
begin
  if (TypeComboBox.ItemIndex = 1) and(DeliveryComboBox.ItemIndex = 1) then
  begin
    CurrCombo.Visible := TRUE;
    Label7.Visible := TRUE;

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
    CurrCombo.Visible := TRUE;
    Label7.Visible := TRUE;

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

end;

procedure TOrderEdit.FormCreate(Sender: TObject);
begin

 if (TypeComboBox.ItemIndex = 1) and(DeliveryComboBox.ItemIndex = 1) then
  begin
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
    if (Data.OrderTable.FieldByName('Currency').AsString = '0') or (Data.OrderTable.FieldByName('Currency').AsString = '') then
       CurrCombo.ItemIndex := 1
    else
        CurrCombo.ItemIndex := Data.OrderTable.FieldByName('Currency').AsInteger-1;

  end
  else
    if (TypeComboBox.ItemIndex = 1) and(DeliveryComboBox.ItemIndex = 0) then
  begin
    CurrCombo.Visible := TRUE;
    Label7.Visible := TRUE;

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

    if (Data.OrderTable.FieldByName('Currency').AsString = '0') or (Data.OrderTable.FieldByName('Currency').AsString = '') then
       CurrCombo.ItemIndex := 0
    else
        CurrCombo.ItemIndex := Data.OrderTable.FieldByName('Currency').AsInteger-2;

  end
  else
  begin
    CurrCombo.Visible := FALSE;
    CurrCombo.ItemIndex := 1;
    Label7.Visible := FALSE;
  end;

end;

procedure TOrderEdit.TypeComboBoxChange(Sender: TObject);
begin
  if (TypeComboBox.ItemIndex = 1) and(DeliveryComboBox.ItemIndex = 1) then
  begin
    CurrCombo.Visible := TRUE;
    Label7.Visible := TRUE;

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
    CurrCombo.Visible := TRUE;
    Label7.Visible := TRUE;

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


end;

end.
