unit _GrDsSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, StdCtrls, Buttons, JvComponentBase,
  JvFormPlacement, DB, dbisamtb;

type
  TGroupDiscSetup = class(TForm)
    CloseBtn: TBitBtn;
    Grid: TDBGridEh;
    FormStorage: TJvFormStorage;
    DataSource: TDataSource;
    Table: TDBISAMTable;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GroupDiscSetup: TGroupDiscSetup;

implementation

{$R *.dfm}


procedure TGroupDiscSetup.FormShow(Sender: TObject);
begin
  with Table do
  begin
    Filter := 'Subgroup_id=1';
    Open;
    FindFirst;
  end;
  Grid.Col := 2;
end;

procedure TGroupDiscSetup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Table.Close;
end;

end.
