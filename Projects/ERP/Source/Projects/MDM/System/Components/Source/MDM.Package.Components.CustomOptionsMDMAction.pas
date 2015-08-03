unit MDM.Package.Components.CustomOptionsMDMAction;

interface

uses
  System.Classes,
  System.Generics.Collections,
  cxGridCustomView,
  MDM.Package.Components.CatalogAction,
  MDM.Package.Components.Types;

type
  TCustomOptionsMDMAction = class(TPersistent)
  private
    FActionDictionary: TDictionary<TCatalogActionPropertyType, TCatalogAction>;
    FGridView: TcxCustomGridView;
    procedure RegisterAction(aIndex: TCatalogActionPropertyType; aAction: TCatalogAction);
    procedure UnRegisterAction(aIndex: TCatalogActionPropertyType; aAction: TCatalogAction);
  protected
    function GetPropertyAction(const aIndex: TCatalogActionPropertyType): TCatalogAction;
    procedure SetPropertyAction(const aIndex: TCatalogActionPropertyType; aValue: TCatalogAction);
    procedure AllocateDictionary; virtual; abstract;
    procedure DeallocateDictionary; virtual; abstract;
    procedure DoInitAction(const aIndex: TCatalogActionPropertyType; aCatalogAction: TCatalogAction);
    property ActionDictionary: TDictionary<TCatalogActionPropertyType, TCatalogAction> read FActionDictionary;
  public
    constructor Create(aGridView: TcxCustomGridView); virtual;
    destructor Destroy; override;
    function GetPropertyTypeFromAction(aComponent: TCatalogAction): TCatalogActionPropertyType;
    procedure Notification(aComponent: TComponent; aOperation: TOperation);
  end;

  TCustomOptionsMDMActionClass = class of TCustomOptionsMDMAction;

implementation

uses
  System.SysUtils;

type
  ECustomMCActionOptions = class(Exception);

{ TCustomOptionsMDMAction }

constructor TCustomOptionsMDMAction.Create(aGridView: TcxCustomGridView);
begin
  FGridView := aGridView;
  FActionDictionary := TDictionary<TCatalogActionPropertyType, TCatalogAction>.Create();
  AllocateDictionary();
end;

destructor TCustomOptionsMDMAction.Destroy;
begin
  DeallocateDictionary();
  FreeAndNil(FActionDictionary);
  inherited Destroy();
end;

procedure TCustomOptionsMDMAction.DoInitAction(const aIndex: TCatalogActionPropertyType;
  aCatalogAction: TCatalogAction);
begin
  if not (csLoading in FGridView.ComponentState) then
    aCatalogAction.Caption := ACTION_INFO[aIndex].Caption;
end;

function TCustomOptionsMDMAction.GetPropertyAction(const aIndex: TCatalogActionPropertyType): TCatalogAction;
begin
  Result := FActionDictionary.Items[aIndex];
end;

function TCustomOptionsMDMAction.GetPropertyTypeFromAction(aComponent: TCatalogAction): TCatalogActionPropertyType;
var
  Pair: TPair<TCatalogActionPropertyType, TCatalogAction>;
begin
  for Pair in FActionDictionary do
    if Pair.Value = aComponent then
      Exit(Pair.Key);
  raise ECustomMCActionOptions.Create('Значение в словаре не найдено');
end;

procedure TCustomOptionsMDMAction.Notification(aComponent: TComponent; aOperation: TOperation);
begin
  if (aOperation = opRemove) and (aComponent is TCatalogAction) then
    if Assigned(FActionDictionary) then
    begin
      if FActionDictionary.ContainsValue(aComponent as TCatalogAction) then
        FActionDictionary.AddOrSetValue(GetPropertyTypeFromAction(aComponent as TCatalogAction), nil);
    end;
end;

procedure TCustomOptionsMDMAction.RegisterAction(aIndex: TCatalogActionPropertyType; aAction: TCatalogAction);
begin
  aAction.FreeNotification(FGridView);
  aAction.RegisterGridView(FGridView);
end;

procedure TCustomOptionsMDMAction.SetPropertyAction(const aIndex: TCatalogActionPropertyType; aValue: TCatalogAction);
var
  Action: TCatalogAction;
begin
  if Assigned(aValue) and (FActionDictionary.ContainsValue(aValue) or Assigned(aValue.GridView)) then
    raise ECustomMCActionOptions.CreateFmt('Action %s уже связан c %s', [aValue.Name, aValue.GridView.Name]);
  Action := FActionDictionary.Items[aIndex];
  if Assigned(Action) then
    UnRegisterAction(aIndex, Action);
  FActionDictionary.AddOrSetValue(aIndex, aValue);
  if Assigned(aValue) then
  begin
    RegisterAction(aIndex, aValue);
    DoInitAction(aIndex, aValue);
  end;
end;

procedure TCustomOptionsMDMAction.UnRegisterAction(aIndex: TCatalogActionPropertyType; aAction: TCatalogAction);
begin
  aAction.UnRegisterGridView(FGridView);
  aAction.RemoveFreeNotification(FGridView);
end;

end.
