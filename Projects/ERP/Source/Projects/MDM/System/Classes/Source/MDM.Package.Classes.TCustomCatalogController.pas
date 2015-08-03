unit MDM.Package.Classes.TCustomCatalogController;

interface

uses
  Winapi.ActiveX,
  System.Types,
  System.SysUtils,
  Data.DB,
  FireDAC.Stan.Param,
  ShateM.Components.TFireDACTempTable,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IModuleAccess,
  MDM.Package.Interfaces.ICustomCatalogController,
  MDM.Package.Components.CustomCatalogTableView,
  MDM.Package.Components.CustomCatalogColumn,
  MDM.Package.Components.Types;

type
  TSQLProc = class
  public
    SQLMetaSelect: string;
    SQLRefreshSelect: string;
    SQLRefreshDetailsSelect: TStringDynArray;
  end;

  TSQLProcClass = class of TSQLProc;

  TCatalogAccess = class
  end;

  TCatalogAccessClass = class of TCatalogAccess;

  TCustomCatalogController = class(TInterfacedObject, ICustomCatalogController)
  private // Поля
//    FMetaQuery: TFDQuery; { TODO 1 : Зарезервировано }
    FForm: TERPCustomForm;
    FGridTableView: TCustomCatalogTableView;
    FSQLProc: TSQLProc;
    FCatalogAccess: TCatalogAccess;
  private // Методы
    function GetModuleAccess: IModuleAccess;
    procedure FillTempTable(aTempTable: TsmFireDACTempTable);
    procedure PrepareTempTable(aTempTable: TsmFireDACTempTable);

    procedure WebBrowserTemplateChange(aSender: TObject);
  protected //ICustomCatalogController
    function LoadDetails: IStream; virtual;
    function UpdateRefresh: Boolean; virtual;
    procedure Refresh; virtual;
  protected // Класс-методы
    class function GetCatalogAccessClass: TCatalogAccessClass; virtual;
    class function GetSQLProcClass: TSQLProcClass; virtual;
  protected // Обычные Методы
    function GetGridColumnFromServiceType(aServiceType: TServiceType): TCustomCatalogColumn;
    function GetUser: string;
    procedure ExecuteSQL(aFlag: Integer; const aSQL: string);
    procedure InitMeta;
    procedure RefreshGrid(const aSQL: string);
  protected // Абстрактные методы
    procedure InitCatalogAccess; virtual; abstract;
    procedure InitSQL; virtual; abstract;
  protected // Виртуальные методы
    procedure AfterExecute(aFlag: Integer); virtual;
    procedure BeforeExecute(aFlag: Integer; out aContinue: Boolean); virtual;
    procedure SetExecuteSQLParams(aFlag: Integer; aParams: TFDParams); virtual;
    procedure SetRefreshParams(aParams: TFDParams); virtual;

    procedure LoadDetailsParserField(aField: TField; var aDocument: string; var aHandled: Boolean); virtual;
  protected // Свойства
    property CatalogAccess: TCatalogAccess read FCatalogAccess;
    property GridTableView: TCustomCatalogTableView read FGridTableView;
    property SQLProc: TSQLProc read FSQLProc;
//    property Meta: TFDQuery read FMetaQuery;
    property ModuleAccess: IModuleAccess read GetModuleAccess;
  public
    constructor Create(aForm: TERPCustomForm; aGridTableView: TCustomCatalogTableView); virtual;
    destructor Destroy; override;
    property ERPForm: TERPCustomForm read FForm;
  end;

  ECustomCatalogController = class(Exception);

implementation

uses
  System.Classes,
  System.Variants,
  System.IOUtils,
  FireDAC.Comp.Client,
  cxImage,
  ShateM.Utils.MSSQL,
  ShateM.Components.TCustomTempTable,
  ERP.Package.Components.TERPWebBrowser,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  MDM.Package.Classes.TParserHtml;

{ TCustomCatalogController }

procedure TCustomCatalogController.AfterExecute(aFlag: Integer);
begin

end;

procedure TCustomCatalogController.BeforeExecute(aFlag: Integer; out aContinue: Boolean);
begin
  aContinue := True;
end;

constructor TCustomCatalogController.Create(aForm: TERPCustomForm; aGridTableView: TCustomCatalogTableView);
begin
  Assert((aForm <> nil) and (aGridTableView <> nil), 'aForm or aGridTableView is nil');
  if (aForm = nil) or (aGridTableView = nil) then
    raise ECustomCatalogController.Create('aForm or aGridTableView is nil');
  FForm := aForm;
  FGridTableView := aGridTableView;
  if Assigned(FGridTableView.OptionsMDM.WebBrowser) then
    FGridTableView.OptionsMDM.WebBrowser.RegisterServiceEvent(seTemplateCheck, WebBrowserTemplateChange);
  FSQLProc := GetSQLProcClass().Create();
  FCatalogAccess := GetCatalogAccessClass().Create();
  InitCatalogAccess();
  InitSQL();
  InitMeta();
end;

destructor TCustomCatalogController.Destroy;
begin
{  if Assigned(FMetaQuery) then
    FreeAndNil(FMetaQuery);}
  FreeAndNil(FCatalogAccess);
  FreeAndNil(FSQLProc);
  inherited Destroy;
end;

procedure TCustomCatalogController.ExecuteSQL(aFlag: Integer; const aSQL: string);
var
  TempTable: TsmFireDACTempTable;
  Query: TFDQuery;
  ResultContinue: Boolean;
begin
  CreateSQLCursor();
  TempTable := TsmFireDACTempTable.Create(nil);
  try
    PrepareTempTable(TempTable);
    TempTable.CreateTempTable();
    try
      FillTempTable(TempTable);
      try
        BeforeExecute(aFlag, ResultContinue);
      except
        raise ECustomCatalogController.CreateFmt('Ошибка выполнения BeforeExecute. Flag = %d.', [aFlag]);
      end;
      if ResultContinue then
      begin
        Query := TFDQuery.Create(nil);
        try
          Query.Connection := ERPForm.FDConnection;
          Query.SQL.Text := aSQL;
          if Query.ParamCount > 0 then
            try
              SetExecuteSQLParams(aFlag, Query.Params);
            except
              raise ECustomCatalogController.CreateFmt('Ошибка выполнения SetExecuteSQLParams. Flag = %d', [aFlag]);
            end;
          try
            TERPQueryHelp.Open(Query);
          except
            raise ECustomCatalogController.CreateFmt('Ошибка выполнения процедуры "%s" в методе ExecuteSQL. Flag = %d', [aSQL, aFlag]);
          end;
          try
            AfterExecute(aFlag);
          except
            raise ECustomCatalogController.CreateFmt('Ошибка выполнения AfterExecute. Flag = %d', [aFlag]);
          end;
          Refresh();
        finally
          Query.Free();
        end;
      end;
    finally
      TempTable.DropTempTable();
    end;
  finally
    TempTable.Free();
  end;
end;

procedure TCustomCatalogController.FillTempTable(aTempTable: TsmFireDACTempTable);
var
  k, i: Integer;
begin
  for k := 0 to GridTableView.Controller.SelectedRecordCount - 1 do
    for i := 0 to GridTableView.ColumnCount - 1 do
      if GridTableView.Columns[i].MetaOptions.PK then
        aTempTable.InsertTempTable([
          TFieldValue.Create(GridTableView.Columns[i].MetaOptions.FieldName,
                             GridTableView.Controller.SelectedRecords[k].Values[GridTableView.Columns[i].Index])]);
end;

class function TCustomCatalogController.GetCatalogAccessClass: TCatalogAccessClass;
begin
  Result := TCatalogAccess;
end;

function TCustomCatalogController.GetGridColumnFromServiceType(aServiceType: TServiceType): TCustomCatalogColumn;
var
  k: Integer;
begin
  for k := 0 to GridTableView.ColumnCount - 1 do
    if GridTableView.Columns[k].MetaOptions.ServiceType = aServiceType then
      Exit(GridTableView.Columns[k]);
  Result := nil;
end;

function TCustomCatalogController.GetModuleAccess: IModuleAccess;
begin
  Result := FForm.ERPClientData.ModuleAccess;
end;

class function TCustomCatalogController.GetSQLProcClass: TSQLProcClass;
begin
  Result := TSQLProc;
end;

function TCustomCatalogController.GetUser: string;
begin
  Result := FForm.ERPClientData.ERPApplication.ModuleConnection.User;
end;

procedure TCustomCatalogController.InitMeta;
begin
{  if not Assigned(FMetaQuery) then
  begin
    FMetaQuery := TFDQuery.Create(nil);
    try
      FMetaQuery.Connection := FForm.FDConnection;
      FMetaQuery.SQL.Text := FSQLProc.SQLMetaSelect;
      FMetaQuery.Open();
    except
      FreeAndNil(FMetaQuery);
    end;
  end;}
end;

function TCustomCatalogController.LoadDetails: IStream;
var
  HtmlStream: TStringStream;
  Query: TFDQuery;
  k: Integer;
  s: string;
  ParserHtml: TParserHtml;
  WebBrowser: TERPWebBrowser;
begin
  if not Assigned(GridTableView.Controller.FocusedRecord) then
    Exit;
  if Length(SQLProc.SQLRefreshDetailsSelect) = 0 then //Заглушка. Надо убрать???!!!
    Exit;
  WebBrowser := GridTableView.OptionsMDM.WebBrowser;
  if WebBrowser.ERPOptions.TemplateList.ActiveIndex = -1 then
    Exit;
  for k := Low(SQLProc.SQLRefreshDetailsSelect) to High(SQLProc.SQLRefreshDetailsSelect) do
  begin
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := FForm.FDConnection;
      Query.SQL.Text := SQLProc.SQLRefreshDetailsSelect[k];
      Query.Params.Items[0].AsInteger := GridTableView.Controller.FocusedRecord.Values[GetGridColumnFromServiceType(stPK).Index];
      Query.Open();
      s := TFile.ReadAllText(WebBrowser.ERPOptions.TemplateList.Items[WebBrowser.ERPOptions.TemplateList.ActiveIndex].TemplateFile);
      ParserHtml := TParserHtml.Create(Query);
      ParserHtml.OnBeforeParseField := LoadDetailsParserField;
      try
        s := ParserHtml.Parse(s);
      finally
        ParserHtml.Free();
      end;
    finally
      Query.Free();
    end;
  end;
  HtmlStream := TStringStream.Create();
  try
    HtmlStream.WriteString(s);
    HtmlStream.Seek(0, soBeginning);
    Result := TStreamAdapter.Create(HtmlStream, soOwned);
  except
    HtmlStream.Free();
  end;
end;

procedure TCustomCatalogController.LoadDetailsParserField(aField: TField; var aDocument: string; var aHandled: Boolean);
begin

end;

procedure TCustomCatalogController.PrepareTempTable(aTempTable: TsmFireDACTempTable);
var
  MSSQLFieldTable: TMSSQLFieldTable;
  k: Integer;
begin
  aTempTable.Connection := ERPForm.FDConnection;
  for k := 0 to GridTableView.ColumnCount - 1 do
    if GridTableView.Columns[k].MetaOptions.PK then
    begin
      MSSQLFieldTable := aTempTable.Fields.Add();
      MSSQLFieldTable.FieldName := GridTableView.Columns[k].MetaOptions.FieldName;
      MSSQLFieldTable.MSSQLDataType := mftInt;
      MSSQLFieldTable.Attributes := [fttaRequired];
    end;
  case GridTableView.OptionsMDM.CatalogType of
    ctDraft:
      aTempTable.TableName := 'tmpDraft';
    ctClean:
      aTempTable.TableName := 'tmpClean';
  end;
end;

procedure TCustomCatalogController.Refresh;
begin
  RefreshGrid(SQLProc.SQLRefreshSelect);
  if Assigned(GridTableView.Controller.FocusedRecord) then
    if Assigned(GridTableView.OptionsMDM.WebBrowser) then
      GridTableView.OptionsMDM.WebBrowser.Navigate(LoadDetails());
end;

procedure TCustomCatalogController.RefreshGrid(const aSQL: string);
var
  Query: TFDQuery;
  k, i: Integer;
  Column: TCustomCatalogColumn;
begin
  CreateSQLCursor();
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := ERPForm.FDConnection;
    Query.SQL.Text := aSQL;
    if Query.ParamCount > 0 then
      SetRefreshParams(Query.Params);
    Query.Open();
    try
      GridTableView.BeginUpdate();
      try
        GridTableView.DataController.RecordCount := Query.RecordCount;
        {for k := 0 to Query.FieldCount - 1 do
        begin
          Column := GridTableView.GetColumnByFieldName(Query.Fields.Fields[k].FieldName);
          if Assigned(Column) then
            if FMetaQuery.Locate('FieldName', Query.Fields.Fields[k].FieldName, []) then
            begin
              if SameText(Column.Caption, '') then
                Column.Caption := FMetaQuery.FieldByName('FieldCaption').AsString;
            end;
        end;}
        Query.First();
        for k := 0 to Query.RecordCount - 1 do
        begin
          for i := 0 to Query.FieldCount - 1 do
          begin
            Column := GridTableView.GetColumnByFieldName(Query.Fields.Fields[i].FieldName);
            if Assigned(Column) then
            begin
              if (Column.PropertiesClass = TcxImageProperties) and (not VarIsNull(Query.Fields.Fields[i].AsVariant)) then
              begin
                GridTableView.DataController.Values[k, Column.Index] := StringOf(Query.Fields.Fields[i].AsBytes);
              end
              else
                GridTableView.DataController.Values[k, Column.Index] := Query.Fields.Fields[i].AsVariant;
            end;
          end;
          Query.Next();
        end;
      finally
        GridTableView.EndUpdate();
      end;
    finally
      Query.Close();
    end;
  finally
    Query.Free();
  end;
end;

procedure TCustomCatalogController.SetExecuteSQLParams(aFlag: Integer; aParams: TFDParams);
begin
  Assert(False, 'SetExecuteSQLParams is not implemented');
end;

procedure TCustomCatalogController.SetRefreshParams(aParams: TFDParams);
begin
  Assert(False, 'SetRefreshParams is not implemented');
end;

function TCustomCatalogController.UpdateRefresh: Boolean;
begin
  Result := True;
end;

procedure TCustomCatalogController.WebBrowserTemplateChange(aSender: TObject);
begin
  (aSender as TERPWebBrowser).Navigate(LoadDetails());
end;

end.
