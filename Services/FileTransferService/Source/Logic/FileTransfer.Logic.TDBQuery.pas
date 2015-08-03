unit FileTransfer.Logic.TDBQuery;

interface

uses
  Data.Win.ADODB;

type
  TDBQuery = class
  private
    FADOConnection: TADOConnection;
    FADOQuery: TADOQuery;
  public
    constructor Create(aADOConnection: TADOConnection); virtual;
    destructor Destroy; override;
    procedure QueryClose;
    property ADOConnection: TADOConnection read FADOConnection;
    property ADOQuery: TADOQuery read FADOQuery;
  end;

implementation

{ TDBQuery }

constructor TDBQuery.Create(aADOConnection: TADOConnection);
begin
  FADOConnection := aADOConnection;
  FADOQuery := TADOQuery.Create(nil);
  FADOQuery.Connection := FADOConnection;
end;

destructor TDBQuery.Destroy;
begin
  FADOQuery.Free();
  inherited Destroy;
end;

procedure TDBQuery.QueryClose;
begin
  if FADOQuery.Active then
    FADOQuery.Close();
end;

end.
