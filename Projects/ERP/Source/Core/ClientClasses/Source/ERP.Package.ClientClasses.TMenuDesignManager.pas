unit ERP.Package.ClientClasses.TMenuDesignManager;

interface

uses
  System.Generics.Collections;

type
  TMenuDesignItem = class
  public
    Id_MenuDesign: Integer;
    Id_MenuDesignParent: Integer;
    Id_Module: Integer;
    Caption: string;
    Level: Integer;
    Guid: TGUID;
  end;

  TMenuDesignManager = class
  private
    FList: TList<TMenuDesignItem>;
    function GetCount: Integer;
    function GetItems(aIndex: Integer): TMenuDesignItem;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(aId_MenuDesign, aId_MenuDesignParent, aId_Module: Integer; const aCaption: string; aLevel: Integer;
      const aGuid: TGUID);
    procedure Clear;
    property Count: Integer read GetCount;
    property Items[aIndex: Integer]: TMenuDesignItem read GetItems;
  end;

implementation

{ TMenuDesignManager }

procedure TMenuDesignManager.Add(aId_MenuDesign, aId_MenuDesignParent, aId_Module: Integer; const aCaption: string;
  aLevel: Integer; const aGuid: TGUID);
var
  MenuDesignItem: TMenuDesignItem;
begin
  MenuDesignItem := TMenuDesignItem.Create();
  MenuDesignItem.Id_MenuDesign := aId_MenuDesign;
  MenuDesignItem.Id_MenuDesignParent := aId_MenuDesignParent;
  MenuDesignItem.Id_Module := aId_Module;
  MenuDesignItem.Caption := aCaption;
  MenuDesignItem.Level := aLevel;
  MenuDesignItem.Guid := aGuid;
  FList.Add(MenuDesignItem);
end;

procedure TMenuDesignManager.Clear;
var
  k: Integer;
begin
  for k := 0 to FList.Count - 1 do
    FList.Items[k].Free();
  FList.Clear();
end;

constructor TMenuDesignManager.Create;
begin
  FList := TList<TMenuDesignItem>.Create();
end;

destructor TMenuDesignManager.Destroy;
begin
  Clear();
  FList.Free();
  inherited Destroy();
end;

function TMenuDesignManager.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TMenuDesignManager.GetItems(aIndex: Integer): TMenuDesignItem;
begin
  Result := FList.Items[aIndex];
end;

end.
