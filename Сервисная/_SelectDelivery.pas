unit _SelectDelivery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DBGridEh, Mask, DBCtrlsEh, DBLookupEh, DB,
  dbisamtb, ExtCtrls;

type
  TSelectDelivery = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    AddresQuery: TDBISAMQuery;
    DS_Addres: TDataSource;
    Panel: TPanel;
    AddresComboBox: TDBLookupComboboxEh;
    Label9: TLabel;
    Button1: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
     iRut:integer;
    { Public declarations }
  end;

var
  SelectDelivery: TSelectDelivery;

implementation

uses _Data, _Main;
{$R *.dfm}

procedure TSelectDelivery.BitBtn1Click(Sender: TObject);
begin
   if Data.OrderTable.FieldByName('Addres_id').AsString = '' then
   begin
     MessageDlg('Не заполнен адрес доставки!', mtError,[mbOK],0);
     Panel.Visible := True;
     self.Height := 149;
     Exit;
   end;
   iRut:=1;
   Close;
end;

procedure TSelectDelivery.BitBtn2Click(Sender: TObject);
begin
   iRut:=2;
   Close;
end;

procedure TSelectDelivery.Button1Click(Sender: TObject);
begin
  if Data.OrderDataSource.DataSet.FieldByName('Addres_id').AsString <> '' then
  begin
    Data.OrderTable.Post;
    self.Height := 111;
    Exit;
  end;
end;

procedure TSelectDelivery.FormCreate(Sender: TObject);
begin
  self.Height := 111;
  AddresQuery.DatabaseName := Main.GetCurrentBD;
  AddresQuery.SQL.Clear;
  AddresQuery.SQL.Add('select addres_id, addres from [047] where cli_id = '''+ Data.OrderTable.FieldByName('cli_id').AsString+'''');
  AddresQuery.ExecSQL;
end;

end.
