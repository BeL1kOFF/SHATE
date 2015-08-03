unit MDM.Package.Components.CustomCatalogColumnMetaOptions;

interface

uses
  cxGridCustomTableView,
  MDM.Package.Components.Types;

type
  TCustomCatalogColumnMetaOptions = class(TcxCustomGridTableItemCustomOptions)
  private
    FFieldName: string;
    FPK: Boolean;
    FServiceType: TServiceType;
    function FieldNameIsStored: Boolean;
    procedure SetPK(const aValue: Boolean);
    procedure SetServiceType(const aValue: TServiceType);
  published
    property FieldName: string read FFieldName write FFieldName stored FieldNameIsStored;
    property PK: Boolean read FPK write SetPK default False;
    property ServiceType: TServiceType read FServiceType write SetServiceType default stUnknown;
  end;

  TCustomCatalogColumnMetaOptionsClass = class of TCustomCatalogColumnMetaOptions;

implementation

uses
  System.SysUtils;

{ TCustomCatalogColumnMetaOptions }

function TCustomCatalogColumnMetaOptions.FieldNameIsStored: Boolean;
begin
  Result := not SameText(FFieldName, '');
end;

procedure TCustomCatalogColumnMetaOptions.SetPK(const aValue: Boolean);
begin
  if FPK <> aValue then
  begin
    FPK := aValue;
    if aValue then
      FServiceType := stPK
    else
      FServiceType := stUnknown;
  end;
end;

procedure TCustomCatalogColumnMetaOptions.SetServiceType(const aValue: TServiceType);
begin
  if FServiceType <> aValue then
  begin
    FServiceType := aValue;
    FPK := aValue = stPK;
  end;
end;

end.
