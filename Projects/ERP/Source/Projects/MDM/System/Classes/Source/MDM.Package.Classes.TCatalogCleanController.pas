unit MDM.Package.Classes.TCatalogCleanController;

interface

uses
  System.SysUtils,
  FireDAC.Stan.Param,
  MDM.Package.Interfaces.ICatalogCleanController,
  MDM.Package.Components.Types,
  MDM.Package.Classes.TCustomCatalogController;

type
  TSQLProcClean = class(TSQLProc)
  public
    SQLMoveToDraftSelect: string;
    SQLMoveToDraftCheck: string;
    SQLCopyFromSelect: string;
    SQLRestoreSelect: string;
    SQLExportMeta: string;
    SQLExport: string;
  end;

  TCatalogAccessClean = class(TCatalogAccess)
  public
    MoveToDraft: Integer;
    CopyFrom: Integer;
    Restore: Integer;
    ExportClean: Integer;
  end;

  TCatalogCleanController = class(TCustomCatalogController, ICatalogCleanController)
  private
    function CheckColumnServiceType(aServiceType: TServiceType; const aValue: Variant): Boolean;
    function GetCatalogAccess: TCatalogAccessClean;
    function GetSQLProc: TSQLProcClean;
    function IsCopyFrom: Boolean;
    function IsExport: Boolean;
    function IsMoveToDraft: Boolean;
    function IsRestore: Boolean;
  protected //ICatalogCleanController
    function UpdateCopyFrom: Boolean; virtual;
    function UpdateExportClean: Boolean; virtual;
    function UpdateMoveToDraft: Boolean; virtual;
    function UpdateRestore: Boolean; virtual;
    procedure CopyFrom; virtual;
    procedure ExportClean; virtual;
    procedure MoveToDraft; virtual;
    procedure Restore; virtual;
  protected // Класс-методы
    class function GetSQLProcClass: TSQLProcClass; override;
    class function GetCatalogAccessClass: TCatalogAccessClass; override;
  protected // Виртуальные методы
    procedure BeforeExecute(aFlag: Integer; out aContinue: Boolean); override;
    procedure SetExecuteSQLParams(aFlag: Integer; aParams: TFDParams); override;
  protected // Свойства
    property CatalogAccess: TCatalogAccessClean read GetCatalogAccess;
    property SQLProc: TSQLProcClean read GetSQLProc;
  end;

  ECatalogCleanController = class(Exception);

implementation

uses
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  ERP.Package.Components.TCatalogExportExcel,
  MDM.Package.Components.CustomCatalogColumn;

const
  FLAG_COPYFROM     = Integer(-1);
  FLAG_MOVETODRAFT  = Integer(-2);
  FLAG_RESTORE      = Integer(-3);

resourcestring
  rsRestoreConfirm       = 'Вы уверенны, что хотите восстановить выделенные записи?';

{ TCatalogCleanController }

procedure TCatalogCleanController.BeforeExecute(aFlag: Integer; out aContinue: Boolean);

  function IsCheckedMoveToDraft: Boolean;
  var
    QueryResult: TERPQueryResult;
  begin
    try
      QueryResult := TERPQueryHelp.Check(ERPForm.FDConnection, SQLProc.SQLMoveToDraftCheck,
        [TERPParamValue.Create(GetUser())]);
    except
      raise ECatalogCleanController.CreateFmt('Ошибка выполнения процедуры "%s" в методе IsCheckedMoveToDraft', [SQLProc.SQLMoveToDraftCheck]);
    end;
    if QueryResult.Status = QUERY_RESULT_WARNING then
      Result := TERPMessageHelp.BoxQuestionYN(QueryResult.Text)
    else
      Result := True;
  end;

begin
  case aFlag of
    FLAG_MOVETODRAFT:
      aContinue := IsCheckedMoveToDraft();
    else
      aContinue := True;
  end;
end;

function TCatalogCleanController.CheckColumnServiceType(aServiceType: TServiceType; const aValue: Variant): Boolean;
var
  k: Integer;
  Column: TCustomCatalogColumn;
begin
  Column := GetGridColumnFromServiceType(aServiceType);
  if not Assigned(Column) then
    Exit(False);
  for k := 0 to GridTableView.Controller.SelectedRecordCount - 1 do
    if GridTableView.Controller.SelectedRecords[k].Values[Column.Index] = aValue then
      Exit(False);
  Result := True;
end;

procedure TCatalogCleanController.CopyFrom;
begin
  try
    ExecuteSQL(FLAG_COPYFROM, SQLProc.SQLCopyFromSelect);
  except
    raise ECatalogCleanController.Create('Ошибка выполнения CopyFrom');
  end;
end;

procedure TCatalogCleanController.ExportClean;
var
  ceeTradeMark: TCatalogExportExcel; { TODO 1 : Надо перенсти компонент сюда и заменить обычным классом. }
begin
  ceeTradeMark := TCatalogExportExcel.Create(nil);
  try
    ceeTradeMark.Connection := ERPForm.FDConnection;
    ceeTradeMark.TableViewIndexId := GetGridColumnFromServiceType(stPK).Index;
    ceeTradeMark.ProcMeta := SQLProc.SQLExportMeta;
    ceeTradeMark.ProcName := SQLProc.SQLExport;
    ceeTradeMark.SheetName := ERPForm.Caption;
    ceeTradeMark.TableView := GridTableView;
    ceeTradeMark.ShowExportForm();
  finally
    ceeTradeMark.Free();
  end;
end;

function TCatalogCleanController.GetCatalogAccess: TCatalogAccessClean;
begin
  Result := TCatalogAccessClean(inherited CatalogAccess);
end;

class function TCatalogCleanController.GetCatalogAccessClass: TCatalogAccessClass;
begin
  Result := TCatalogAccessClean;
end;

function TCatalogCleanController.GetSQLProc: TSQLProcClean;
begin
  Result := TSQLProcClean(inherited SQLProc);
end;

class function TCatalogCleanController.GetSQLProcClass: TSQLProcClass;
begin
  Result := TSQLProcClean;
end;

function TCatalogCleanController.IsCopyFrom: Boolean;
begin
  Result := CheckColumnServiceType(stEnabled, False);
end;

function TCatalogCleanController.IsExport: Boolean;
begin
  Result := CheckColumnServiceType(stEnabled, False);
end;

function TCatalogCleanController.IsMoveToDraft: Boolean;
begin
  Result := CheckColumnServiceType(stEnabled, False);
end;

function TCatalogCleanController.IsRestore: Boolean;
begin
  Result := CheckColumnServiceType(stEnabled, True);
end;

procedure TCatalogCleanController.MoveToDraft;
begin
  try
    ExecuteSQL(FLAG_MOVETODRAFT, SQLProc.SQLMoveToDraftSelect);
  except
    raise ECatalogCleanController.Create('Ошибка выполнения MoveToDraft');
  end;
end;

procedure TCatalogCleanController.Restore;
begin
  if TERPMessageHelp.BoxQuestionYN(rsRestoreConfirm) then
    try
      ExecuteSQL(FLAG_RESTORE, SQLProc.SQLRestoreSelect);
    except
      raise ECatalogCleanController.Create('Ошибка выполнения Restore');
    end;
end;

procedure TCatalogCleanController.SetExecuteSQLParams(aFlag: Integer; aParams: TFDParams);
begin
  case aFlag of
    FLAG_COPYFROM, FLAG_MOVETODRAFT:
      aParams.ParamByName('UserName').AsString := GetUser();
  end;
end;

function TCatalogCleanController.UpdateCopyFrom: Boolean;
begin
  Result := ModuleAccess.ContainsBit(CatalogAccess.CopyFrom) and
            ModuleAccess.Items[CatalogAccess.CopyFrom]^.Access and
            (GridTableView.Controller.SelectedRecordCount > 0) and
            IsCopyFrom();
end;

function TCatalogCleanController.UpdateExportClean: Boolean;
begin
  Result := ModuleAccess.ContainsBit(CatalogAccess.ExportClean) and
            ModuleAccess.Items[CatalogAccess.ExportClean]^.Access and
            (GridTableView.Controller.SelectedRecordCount > 0) and
            IsExport();
end;

function TCatalogCleanController.UpdateMoveToDraft: Boolean;
begin
  Result := ModuleAccess.ContainsBit(CatalogAccess.MoveToDraft) and
            ModuleAccess.Items[CatalogAccess.MoveToDraft]^.Access and
            (GridTableView.Controller.SelectedRecordCount > 0) and
            IsMoveToDraft();
end;

function TCatalogCleanController.UpdateRestore: Boolean;
begin
  Result := ModuleAccess.ContainsBit(CatalogAccess.Restore) and
            ModuleAccess.Items[CatalogAccess.Restore]^.Access and
            (GridTableView.Controller.SelectedRecordCount > 0) and
            IsRestore();
end;

end.
