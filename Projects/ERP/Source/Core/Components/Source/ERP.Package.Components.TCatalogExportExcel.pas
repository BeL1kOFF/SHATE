unit ERP.Package.Components.TCatalogExportExcel;

interface

uses
  System.Classes,
  FireDAC.Comp.Client,
  cxGridTableView;

type
  TCatalogExportExcel = class(TComponent)
  private
    FConnection: TFDConnection;
    FProcMeta: string;
    FProcName: string;
    FSheetName: string;
    FTableView: TcxGridTableView;
    FTableViewIndexId: Integer;
  public
    constructor Create(aOwner: TComponent); override;
    procedure ShowExportForm;
  published
    property Connection: TFDConnection read FConnection write FConnection;
    property ProcMeta: string read FProcMeta write FProcMeta;
    property ProcName: string read FProcName write FProcName;
    property SheetName: string read FSheetName write FSheetName;
    property TableView: TcxGridTableView read FTableView write FTableView;
    property TableViewIndexId: Integer read FTableViewIndexId write FTableViewIndexId;
  end;

implementation

uses
  ERP.Package.Components.UI.TExportForm;

{$R TCatalogExportExcel.res}

{ TCatalogExportExcel }

constructor TCatalogExportExcel.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FConnection := nil;
  FProcName := '';
  FSheetName := '';
  FTableView := nil;
  FTableViewIndexId := 0;
end;

procedure TCatalogExportExcel.ShowExportForm;
var
  frmExport: TExportForm;
begin
  frmExport := TExportForm.Create(Self);
  try
    frmExport.ShowModal();
  finally
    frmExport.Free();
  end;
end;

end.
