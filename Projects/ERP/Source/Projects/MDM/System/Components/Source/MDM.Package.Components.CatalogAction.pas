unit MDM.Package.Components.CatalogAction;

interface

uses
  System.Classes,
  Vcl.ActnList,
  cxGridCustomView,
  MDM.Package.Components.CatalogActionOptions;

type
  TCatalogAction = class(TAction)
  private
    FGridView: TcxCustomGridView;
    FCatalogActionOptions: TCatalogActionOptions;
    function BasicActionExecute: Boolean;
    procedure SetOptions(const aValue: TCatalogActionOptions);
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
    function Update: Boolean; override;
    procedure RegisterGridView(aGridView: TcxCustomGridView);
    procedure UnRegisterGridView(aGridView: TcxCustomGridView);
    property GridView: TcxCustomGridView read FGridView;
  published
    property Options: TCatalogActionOptions read FCatalogActionOptions write SetOptions;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  Vcl.Controls,
  Vcl.Forms,
  MDM.Package.Components.CustomCatalogTableView,
  MDM.Package.Components.Types;

{ TCatalogAction }

function TCatalogAction.BasicActionExecute: Boolean;
begin
  if Assigned(OnExecute) then
  begin
    OnExecute(Self);
    Result := True;
  end
  else
    Result := False;
end;

constructor TCatalogAction.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FCatalogActionOptions := TCatalogActionOptions.Create();
  DisableIfNoHandler := False;
end;

destructor TCatalogAction.Destroy;
begin
  FreeAndNil(FCatalogActionOptions);
  inherited Destroy();
end;

function TCatalogAction.Execute: Boolean; //Из-за корявости реализации предков пришлось полностью продублировать и заменить метод
begin
  Result := False;
  if Suspended then
    Exit;
  Update();
  if Enabled and AutoCheck then
    if not Checked or Checked and (GroupIndex = 0) then
      Checked := not Checked;
  Result := Enabled;
  if Result then
  begin
    Result := False;
    if Assigned(FGridView) and (FCatalogActionOptions.EnableExecute in [aemInner, aemBoth]) then
    begin
      try
        (FGridView as TCustomCatalogTableView).CatalogTableViewController.ActionExecute(Self);
      except on E: Exception do
        Application.MessageBox(PChar(E.ToString), 'Ошибка', MB_OK or MB_ICONERROR);
      end;
      Result := True;
    end;
    if FCatalogActionOptions.EnableExecute in [aemOuter, aemBoth] then
      Result := ((ActionList <> nil) and ActionList.ExecuteAction(Self)) or
                 (Application.ExecuteAction(Self)) or
                 (BasicActionExecute()) or
                 (SendAppMessage(CM_ACTIONEXECUTE, 0, LPARAM(Self)) = 1);
  end;
end;

procedure TCatalogAction.RegisterGridView(aGridView: TcxCustomGridView);
begin
  Assert(Assigned(aGridView), 'TCatalogAction');
  FGridView := aGridView;
end;

procedure TCatalogAction.SetOptions(const aValue: TCatalogActionOptions);
begin
  FCatalogActionOptions.Assign(aValue);
end;

procedure TCatalogAction.UnRegisterGridView(aGridView: TcxCustomGridView);
begin
  Assert(Assigned(aGridView), 'TCatalogAction');
  if FGridView = aGridView then
    FGridView := nil;
end;

function TCatalogAction.Update: Boolean;
begin
  Result := False;
  if Assigned(FGridView) and (FCatalogActionOptions.EnableUpdate in [aemInner, aemBoth]) then
  begin
    (FGridView as TCustomCatalogTableView).CatalogTableViewController.ActionUpdate(Self);
    Result := True;
  end;
  if FCatalogActionOptions.EnableUpdate in [aemOuter, aemBoth] then
    Result := inherited Update();
end;

end.
