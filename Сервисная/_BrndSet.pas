unit _BrndSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, StdCtrls, Buttons, JvComponentBase,
  JvFormPlacement, DB, dbisamtb;

type
  TTDBrandsSetup = class(TForm)
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
  TDBrandsSetup: TTDBrandsSetup;

implementation

uses _Data;

{$R *.dfm}


procedure TTDBrandsSetup.FormShow(Sender: TObject);
begin
  with Table do
  begin
    Open;
    First;
  end;
  Grid.Col := 2;
end;

procedure TTDBrandsSetup.CloseBtnClick(Sender: TObject);
begin
  if Table.State = dsEdit then
    Table.Post;
end;

procedure TTDBrandsSetup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Table.Close;
end;

end.
