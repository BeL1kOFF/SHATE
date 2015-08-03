{!!! больше не используется}
unit _BrDsSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, StdCtrls, Buttons, JvComponentBase,
  JvFormPlacement, DB, dbisamtb, IniFiles;

type
  TBrandDiscSetup = class(TForm)
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
  BrandDiscSetup: TBrandDiscSetup;

implementation

uses _Data;

{$R *.dfm}


procedure TBrandDiscSetup.FormShow(Sender: TObject);
begin
  with Table do
  begin
    Open;
    First;
  end;
  Grid.Col := 2;
end;

procedure TBrandDiscSetup.CloseBtnClick(Sender: TObject);

begin
  if Table.State = dsEdit then
    Table.Post;
end;

procedure TBrandDiscSetup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Data.SaveBrandsDiscount;
  Table.Close;
end;

end.
