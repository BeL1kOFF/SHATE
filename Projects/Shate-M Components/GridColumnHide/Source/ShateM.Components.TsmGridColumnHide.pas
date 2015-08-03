unit ShateM.Components.TsmGridColumnHide;

interface

uses
  System.Classes,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.StorageXML,
  cxGridTableView;

type
  TsmGridColumnHide = class(TComponent)
  private
    FMemTable: TFDMemTable;
    FFileXMLName: string;
    FForcedRecreate: Boolean;
    FTableView: TcxGridTableView;
    function GetCurrentDataSet: TDataSet;
    function GetResourceString(const aResourceName: string): string;
    procedure BeforeClose(aDataSet: TDataSet);
    procedure CheckExists;
    procedure InitXMLParam;
    procedure RefreshColumnFromDataSet(aDataSet: TDataSet; const aUserName, aModuleName: string);
    property CurrentDataSet: TDataSet read GetCurrentDataSet;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure RefreshColumn(const aUserName, aModuleName: string);
    procedure ShowUserColumnForm(const aUserName, aModuleName: string);
  published
    property FileXMLName: string read FFileXMLName write FFileXMLName;
    property ForcedRecreate: Boolean read FForcedRecreate write FForcedRecreate default True;
    property TableView: TcxGridTableView read FTableView write FTableView;
  end;

procedure Register;

implementation

{$R smGridColumnHide.res}
{$R Resource\Template.RES}

uses
  Winapi.Windows,
  System.Variants,
  System.SysUtils,
  System.IOUtils,
  Xml.xmldom,
  Xml.xmlutil,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  ShateM.Components.TsmGridColumnHide.UI.ColumnCaption;

type
  EGridColumnHideException = class(Exception);

const
  RESOURCE_TEMPLATE_XML = 'Template_XML';
  MEMTABLE_NAME = 'GridColumnHide';

resourcestring
  RsCheckNotTable = 'Не задана таблица!';
  RsCheckNotPath = 'Не верный путь к директории!';

procedure Register;
begin
  RegisterComponents('Shate-M', [TsmGridColumnHide]);
end;

{ TsmGridColumnHide }

procedure TsmGridColumnHide.BeforeClose(aDataSet: TDataSet);
begin
  if aDataSet is TFDMemTable then
    if (aDataSet as TFDMemTable).UpdatesPending then
      (aDataSet as TFDMemTable).ApplyUpdates();
end;

procedure TsmGridColumnHide.CheckExists;
begin
  if not Assigned(FTableView) then
    raise EGridColumnHideException.Create(RsCheckNotTable)
  else
    if not TDirectory.Exists(ExtractFilePath(FFileXMLName)) then
      raise EGridColumnHideException.Create(RsCheckNotPath)
    else
    begin
      if not TFile.Exists(FFileXMLName) then
        (LoadDocFromString(GetResourceString(RESOURCE_TEMPLATE_XML)) as IDomPersist).save(FFileXMLName);
      InitXMLParam();
      try
        FMemTable.Open();
      except
        FMemTable.Close();
        if FForcedRecreate then
        begin
          if TFile.Exists(FFileXMLName) then
            TFile.Delete(FFileXMLName);
          (LoadDocFromString(GetResourceString(RESOURCE_TEMPLATE_XML)) as IDomPersist).save(FFileXMLName);
        end;
      end;
    end;
end;

constructor TsmGridColumnHide.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FForcedRecreate := True;
  FMemTable := TFDMemTable.Create(Self);
  FMemTable.Name := MEMTABLE_NAME;
  FMemTable.BeforeClose := BeforeClose;
end;

function TsmGridColumnHide.GetCurrentDataSet: TDataSet;
begin
  Result := FMemTable;
end;

destructor TsmGridColumnHide.Destroy;
begin
  FMemTable.Free();
  inherited Destroy;
end;

function TsmGridColumnHide.GetResourceString(const aResourceName: string): string;
var
  Res: TResourceStream;
  tmpString: TStringList;
begin
  Res := TResourceStream.Create(HInstance, aResourceName, RT_RCDATA);
  try
    tmpString := TStringList.Create();
    try
      tmpString.LoadFromStream(Res);
      Result := tmpString.Text;
    finally
      tmpString.Free();
    end;
  finally
    Res.Free();
  end;
end;

procedure TsmGridColumnHide.InitXMLParam;
begin
  FMemTable.ResourceOptions.PersistentFileName := FFileXMLName;
  FMemTable.CachedUpdates := True;
  FMemTable.FetchOptions.Mode := fmAll;
  FMemTable.ResourceOptions.SilentMode := True;
  FMemTable.ResourceOptions.Persistent := True;
end;

procedure TsmGridColumnHide.RefreshColumn(const aUserName, aModuleName: string);
begin
  CheckExists();
  RefreshColumnFromDataSet(CurrentDataSet, aUserName, aModuleName);
end;

procedure TsmGridColumnHide.RefreshColumnFromDataSet(aDataSet: TDataSet; const aUserName, aModuleName: string);
var
  k: Integer;
begin
  try
    aDataSet.Open();
    for k := 0 to FTableView.ColumnCount - 1 do
      if FTableView.Columns[k].Caption <> '' then
        FTableView.Columns[k].Visible := not aDataSet.Locate(DATASOURCE_LOCATE_FIELDS,
          VarArrayOf([aUserName, aModuleName, FTableView.Name, FTableView.Columns[k].Name]), []);
  finally
    aDataSet.Close();
  end;
end;

procedure TsmGridColumnHide.ShowUserColumnForm(const aUserName, aModuleName: string);
var
  frmColumnCaption: TfrmColumnCaption;
begin
  CheckExists();
  frmColumnCaption := TfrmColumnCaption.Create(Self, CurrentDataSet, FTableView, aUserName, aModuleName);
  try
    frmColumnCaption.ShowModal();
    RefreshColumn(aUserName, aModuleName);
  finally
    frmColumnCaption.Free();
  end;
end;

end.
