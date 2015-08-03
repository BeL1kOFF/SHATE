unit _BrandAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, StdCtrls, Buttons, Mask, DBCtrls, DB, dbisamtb;

type
  TAddBrand = class(TForm)
    DBGridEh1: TDBGridEh;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    DataSource1: TDataSource;
    DBISAMTable1: TDBISAMTable;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddBrand: TAddBrand;

implementation
uses
  _Data;

{$R *.dfm}

procedure TAddBrand.DBGridEh1CellClick(Column: TColumnEh);
begin
  Data.mapBrand4ImportOrder.FieldByName('serviceBrand').AsString := DataSource1.DataSet.FieldByName('Description').AsString;
end;

procedure TAddBrand.FormCreate(Sender: TObject);
begin
  DBISAMTable1.Open;
end;

end.
