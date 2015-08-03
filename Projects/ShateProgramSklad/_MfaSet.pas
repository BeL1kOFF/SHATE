unit _MfaSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, StdCtrls, Buttons, JvComponentBase,
  JvFormPlacement, DB, dbisamtb;

type
  TManufacturersSetup = class(TForm)
    CloseBtn: TBitBtn;
    Grid: TDBGridEh;
    FormStorage: TJvFormStorage;
    Table: TDBISAMTable;
    DataSource: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ManufacturersSetup: TManufacturersSetup;

implementation

uses _Data;

{$R *.dfm}


procedure TManufacturersSetup.FormShow(Sender: TObject);
begin
  with Table do
  begin
    Open;
    First;
  end;
  Grid.Col := 2;
end;

procedure TManufacturersSetup.CloseBtnClick(Sender: TObject);
begin
  if Table.State = dsEdit then
    Table.Post;
end;

procedure TManufacturersSetup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Table.Close;
  Data.SaveToBlockMfaTable;
end;

end.
