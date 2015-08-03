unit MDM.Package.Components.CustomCatalogColumn;

interface

uses
  System.Classes,
  cxGridTableView,
  MDM.Package.Components.CustomCatalogColumnMetaOptions;

type
  TCustomCatalogColumn = class(TcxGridColumn)
  private
    FMetaOptions: TCustomCatalogColumnMetaOptions;
    procedure SetMetaOptions(const aValue: TCustomCatalogColumnMetaOptions);
  protected
    class function GetMetaOptionsClass: TCustomCatalogColumnMetaOptionsClass; virtual;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure InitProperty; virtual;
  public
    constructor Create(aOwner: TComponent); override;
  published
    property MetaOptions: TCustomCatalogColumnMetaOptions read FMetaOptions write SetMetaOptions;
  end;

implementation

uses
  System.SysUtils;

{ TCustomCatalogColumn }

constructor TCustomCatalogColumn.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  InitProperty();
end;

procedure TCustomCatalogColumn.CreateSubClasses;
begin
  inherited CreateSubClasses();
  FMetaOptions := GetMetaOptionsClass().Create(Self);
end;

procedure TCustomCatalogColumn.DestroySubClasses;
begin
  FreeAndNil(FMetaOptions);
  inherited DestroySubClasses();
end;

class function TCustomCatalogColumn.GetMetaOptionsClass: TCustomCatalogColumnMetaOptionsClass;
begin
  Result := TCustomCatalogColumnMetaOptions;
end;

procedure TCustomCatalogColumn.InitProperty;
begin
  HeaderAlignmentHorz := taCenter;
end;

procedure TCustomCatalogColumn.SetMetaOptions(const aValue: TCustomCatalogColumnMetaOptions);
begin
  FMetaOptions.Assign(aValue);
end;

end.
