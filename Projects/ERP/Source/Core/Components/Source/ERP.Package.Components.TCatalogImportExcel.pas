unit ERP.Package.Components.TCatalogImportExcel;

interface

uses
  System.Classes,
  FireDAC.Comp.Client;

type
  TCatalogImportExcel = class(TComponent)
  private
    FConnection: TFDConnection;
    FProcMeta: string;
    FProcCheck: string;
    FProcName: string;
    FSheetName: string;
    FUserName: string;
  public
    constructor Create(aOwner: TComponent); override;
    function ShowImportForm: Boolean;
  published
    property Connection: TFDConnection read FConnection write FConnection;
    property ProcMeta: string read FProcMeta write FProcMeta;
    property ProcCheck: string read FProcCheck write FProcCheck;
    property ProcName: string read FProcName write FProcName;
    property SheetName: string read FSheetName write FSheetName;
    property UserName: string read FUserName write FUserName;
  end;

implementation

uses
  Vcl.Controls,
  ERP.Package.Components.UI.TImportForm;

{$R TCatalogImportExcel.res}

{ TCatalogImportExcel }

constructor TCatalogImportExcel.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FConnection := nil;
  FProcName := '';
  FSheetName := '';
end;

function TCatalogImportExcel.ShowImportForm: Boolean;
var
  frmImport: TImportForm;
begin
  frmImport := TImportForm.Create(Self);
  try
    Result := frmImport.ShowModal() = mrOk;
  finally
    frmImport.Free();
  end;
end;

end.
