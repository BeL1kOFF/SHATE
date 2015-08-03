unit _TblView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, JvComponentBase, JvFormPlacement, Grids, DBGrids, VCLUtils;

type
  TTableView = class(TForm)
    DBGrid1: TDBGrid;
    FormStorage: TJvFormStorage;
    DataSource: TDataSource;
    ADOConnection: TADOConnection;
    ADODataSet: TADODataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TableView: TTableView;

implementation

uses _Main, _Data;

{$R *.dfm}

procedure TTableView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ADODataSet.Close;
end;

procedure TTableView.FormCreate(Sender: TObject);
begin
  StartWait;
  with ADODataSet do
  begin
    CommandText := 'SELECT GRD_ID FROM TOF_GRA_DATA_5 WHERE GRD_ID=12091';
    Open;
  end;
  StopWait;
end;

end.
