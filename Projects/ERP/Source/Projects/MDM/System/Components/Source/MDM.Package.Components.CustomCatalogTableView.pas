unit MDM.Package.Components.CustomCatalogTableView;

interface

uses
  System.Classes,
  cxGridCustomTableView,
  cxGridTableView,
  MDM.Package.Components.CustomCatalogTableViewController,
  MDM.Package.Components.CustomCatalogTableViewOptionsMDM,
  MDM.Package.Components.CustomCatalogColumn;

type
  TCustomCatalogTableView = class(TcxGridTableView)
  private
    FCatalogTableViewController: TCustomCatalogTableViewController;
    FOptionsMDM: TCustomCatalogTableViewOptionsMDM;
    procedure SetOptionsMDM(const aValue: TCustomCatalogTableViewOptionsMDM);
    function GetColumn(aIndex: Integer): TCustomCatalogColumn;
    procedure SetColumn(aIndex: Integer; const aValue: TCustomCatalogColumn);
    procedure LoadDetails(Sender: TObject);
  protected
    class function GetCatalogTableViewControllerClass: TCustomCatalogTableViewControllerClass; virtual;
    class function GetOptionsMDMClass: TCustomCatalogTableViewOptionsMDMClass; virtual;
    function GetItemClass: TcxCustomGridTableItemClass; override;
    procedure CreateOptions; override;
    procedure DestroyOptions; override;
    procedure InitProperty; virtual;
    procedure DoFocusedRecordChanged(aPrevFocusedRecordIndex, aFocusedRecordIndex,
      aPrevFocusedDataRecordIndex, aFocusedDataRecordIndex: Integer;
      aNewItemRecordFocusingChanged: Boolean); override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    function GetColumnByFieldName(const aFieldName: string): TCustomCatalogColumn;
    property CatalogTableViewController: TCustomCatalogTableViewController read FCatalogTableViewController;
    property OptionsMDM: TCustomCatalogTableViewOptionsMDM read FOptionsMDM write SetOptionsMDM;
    property Columns[aIndex: Integer]: TCustomCatalogColumn read GetColumn write SetColumn;
  end;

implementation

uses
  System.SysUtils;

{ TCustomCatalogTableView }

constructor TCustomCatalogTableView.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FCatalogTableViewController := GetCatalogTableViewControllerClass().Create(Self);
  InitProperty();
end;

procedure TCustomCatalogTableView.CreateOptions;
begin
  inherited CreateOptions();
  FOptionsMDM := GetOptionsMDMClass().Create(Self);
  FOptionsMDM.InnerTimer.OnTimer := LoadDetails;
end;

destructor TCustomCatalogTableView.Destroy;
begin
  FreeAndNil(FCatalogTableViewController);
  inherited Destroy();
end;

procedure TCustomCatalogTableView.DestroyOptions;
begin
  FreeAndNil(FOptionsMDM);
  inherited DestroyOptions();
end;

procedure TCustomCatalogTableView.DoFocusedRecordChanged(aPrevFocusedRecordIndex, aFocusedRecordIndex,
  aPrevFocusedDataRecordIndex, aFocusedDataRecordIndex: Integer; aNewItemRecordFocusingChanged: Boolean);
begin
  inherited DoFocusedRecordChanged(aPrevFocusedRecordIndex, aFocusedRecordIndex, aPrevFocusedDataRecordIndex,
    aFocusedDataRecordIndex, aNewItemRecordFocusingChanged);
  FOptionsMDM.InnerTimer.Enabled := False;
  FOptionsMDM.InnerTimer.Enabled := True;
end;

function TCustomCatalogTableView.GetColumn(aIndex: Integer): TCustomCatalogColumn;
begin
  Result := TCustomCatalogColumn(inherited Columns[aIndex]);
end;

function TCustomCatalogTableView.GetColumnByFieldName(const aFieldName: string): TCustomCatalogColumn;
var
  k: Integer;
begin
  for k := 0 to ColumnCount - 1 do
    if SameText(Columns[k].MetaOptions.FieldName, aFieldName) then
      Exit(Columns[k]);
  Result := nil;
end;

function TCustomCatalogTableView.GetItemClass: TcxCustomGridTableItemClass;
begin
  Result := TCustomCatalogColumn;
end;

class function TCustomCatalogTableView.GetCatalogTableViewControllerClass: TCustomCatalogTableViewControllerClass;
begin
  Result := TCustomCatalogTableViewController;
end;

class function TCustomCatalogTableView.GetOptionsMDMClass: TCustomCatalogTableViewOptionsMDMClass;
begin
  Result := TCustomCatalogTableViewOptionsMDM;
end;

procedure TCustomCatalogTableView.InitProperty;
begin
  OptionsView.ColumnAutoWidth := True;
  OptionsView.GroupByBox := False;
  OptionsSelection.CellSelect := False;
  OptionsSelection.MultiSelect := True;
  OptionsData.Appending := False;
  OptionsData.CancelOnExit := False;
  OptionsData.Deleting := False;
  OptionsData.DeletingConfirmation := False;
  OptionsData.Editing := False;
  OptionsData.Inserting := False;
end;

procedure TCustomCatalogTableView.LoadDetails(Sender: TObject);
begin
  FOptionsMDM.InnerTimer.Enabled := False;
  if Assigned(FOptionsMDM.WebBrowser) then
    if Assigned(FCatalogTableViewController.Controller) then
      FOptionsMDM.WebBrowser.Navigate(FCatalogTableViewController.Controller.LoadDetails());
end;

procedure TCustomCatalogTableView.SetColumn(aIndex: Integer; const aValue: TCustomCatalogColumn);
begin
  inherited Columns[aIndex] := aValue;
end;

procedure TCustomCatalogTableView.SetOptionsMDM(const aValue: TCustomCatalogTableViewOptionsMDM);
begin
  FOptionsMDM.Assign(aValue);
end;

end.
