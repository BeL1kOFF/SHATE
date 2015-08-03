unit MDM.Package.Classes.TCatalogDraftController;

interface

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Stan.Param,
  MDM.Package.Interfaces.ICatalogDraftController,
  MDM.Package.Components.Types,
  MDM.Package.Classes.TCustomCatalogController,
  MDM.Package.Classes.TCustomFormDetail;

type
  TSQLProcDraft = class(TSQLProc)
  public
    SQLEditReadItem: string;
    SQLInsert: string;
    SQLUpdate: string;
    SQLDelete: string;
    SQLChangeStatus: string;
    SQLMergeMeta: string;
    SQLMergeSelect: string;
    SQLMerge: string;
    SQLAnalysis: string;
    SQLApprove: string;
    SQLImportMeta: string;
    SQLImportCheck: string;
    SQLImport: string;
  end;

  TCatalogAccessDraft = class(TCatalogAccess)
  public
    Add: Integer;
    Edit: Integer;
    Delete: Integer;
    StatusReset: Integer;
    StatusReady: Integer;
    StatusDelete: Integer;
    Merge: Integer;
    Analysis: Integer;
    Approve: Integer;
    ViewAll: Integer;
    ImportDraft: Integer;
  end;

  TCatalogDraftController = class(TCustomCatalogController, ICatalogDraftController)
  private
    function CheckColumnServiceType(aServiceType: TServiceType; const aValue: array of Variant): Boolean;
    function GetCatalogAccess: TCatalogAccessDraft;
    function GetSQLProc: TSQLProcDraft;
    function IsDraftApprove: Boolean;
    function IsDraftEdit: Boolean;
    function IsDraftInitial: Boolean;
    function IsDraftReady: Boolean;
    function IsDraftToDelete: Boolean;
    procedure DraftChangeStatus(aFlag: Integer);
  protected //ICatalogDraftController
    function UpdateAdd: Boolean; virtual;
    function UpdateAnalysis: Boolean; virtual;
    function UpdateApprove: Boolean; virtual;
    function UpdateChangeStatusDelete: Boolean; virtual;
    function UpdateChangeStatusReady: Boolean; virtual;
    function UpdateChangeStatusReset: Boolean; virtual;
    function UpdateDelete: Boolean; virtual;
    function UpdateEdit: Boolean; virtual;
    function UpdateImportDraft: Boolean; virtual;
    function UpdateMerge: Boolean; virtual;
    procedure Add; virtual;
    procedure Analysis; virtual;
    procedure Approve; virtual;
    procedure ChangeStatusDelete; virtual;
    procedure ChangeStatusReady; virtual;
    procedure ChangeStatusReset; virtual;
    procedure Delete; virtual;
    procedure Edit; virtual;
    procedure ImportDraft; virtual;
    procedure Merge; virtual;
  protected // Класс-методы
    class function GetSQLProcClass: TSQLProcClass; override;
    class function GetCatalogAccessClass: TCatalogAccessClass; override;
  protected // Виртуальные методы
    function GetFormDetial(aNew: Boolean): TCustomFormDetail; virtual;
    procedure EditReadItemDataSet(aDataSet: TDataSet); virtual;
    procedure SetEditReadItemParams(aParams: TFDParams); virtual;
    procedure SetExecuteSQLParams(aFlag: Integer; aParams: TFDParams); override;
    procedure SetRefreshParams(aParams: TFDParams); override;
    procedure SetSaveParams(aParams: TFDParams); virtual;
  protected // Свойства
    property CatalogAccess: TCatalogAccessDraft read GetCatalogAccess;
    property SQLProc: TSQLProcDraft read GetSQLProc;
  public
    function IsNewItem: Boolean; virtual;
    function Save: Boolean;
    procedure ReadItem;
  end;

  ECatalogDraftController = class(Exception);

implementation

uses
  System.Variants,
  FireDAC.Comp.Client,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  ERP.Package.Components.TCatalogImportExcel,
  MDM.Package.Components.CustomCatalogColumn,
  MDM.CustomCatalogForm.TERPCatalogMergeForm;

type
  TStatusDraft = record
  public
    Flag: Integer;
    Status: Integer;
    class function GetStatus(aFlag: Integer): Integer; static;
  end;

const
  FLAG_DELETE         = Integer(-1);
  FLAG_STATUS_RESET   = Integer(-2);
  FLAG_STATUS_READY   = Integer(-3);
  FLAG_STATUS_DELETE  = Integer(-4);
  FLAG_ANALYSIS       = Integer(-5);
  FLAG_APPROVE        = Integer(-6);

  STATUSDRAFT: array[0..2] of TStatusDraft = ((Flag: FLAG_STATUS_RESET;  Status: 10),
                                              (Flag: FLAG_STATUS_READY;  Status: 20),
                                              (Flag: FLAG_STATUS_DELETE; Status: 30));

{ TCatalogDraftController }

procedure TCatalogDraftController.Add;
var
  frmDetail: TCustomFormDetail;
begin
  frmDetail := GetFormDetial(True);
  try
    frmDetail.NewItem := True;
    frmDetail.ShowModal();
    Refresh();
  finally
    frmDetail.Free();
  end;
end;

procedure TCatalogDraftController.Analysis;
begin
  try
    ExecuteSQL(FLAG_ANALYSIS, SQLProc.SQLAnalysis);
  except
    raise ECatalogDraftController.Create('Ошибка выполнения Analysis.');
  end;
end;

procedure TCatalogDraftController.Approve;
begin
  try
    ExecuteSQL(FLAG_APPROVE, SQLProc.SQLApprove);
  except
    raise ECatalogDraftController.Create('Ошибка выполнения Approve.');
  end;
end;

procedure TCatalogDraftController.ChangeStatusDelete;
begin
  DraftChangeStatus(FLAG_STATUS_DELETE);
end;

procedure TCatalogDraftController.ChangeStatusReady;
begin
  DraftChangeStatus(FLAG_STATUS_READY);
end;

procedure TCatalogDraftController.ChangeStatusReset;
begin
  DraftChangeStatus(FLAG_STATUS_RESET);
end;

function TCatalogDraftController.CheckColumnServiceType(aServiceType: TServiceType;
  const aValue: array of Variant): Boolean;
var
  k, i: Integer;
  Column: TCustomCatalogColumn;
begin
  Column := GetGridColumnFromServiceType(aServiceType);
  if not Assigned(Column) then
    Exit(False);
  for k := 0 to GridTableView.Controller.SelectedRecordCount - 1 do
    for i := Low(aValue) to High(aValue) do
      if GridTableView.Controller.SelectedRecords[k].Values[Column.Index] = aValue[i] then
        Exit(False);
  Result := True;
end;

procedure TCatalogDraftController.Delete;
begin
  ExecuteSQL(FLAG_DELETE, SQLProc.SQLDelete);
end;

procedure TCatalogDraftController.DraftChangeStatus(aFlag: Integer);
begin
  try
    ExecuteSQL(aFlag, SQLProc.SQLChangeStatus);
  except
    raise ECatalogDraftController.CreateFmt('Ошибка выполнения DraftChangeStatus. Status = %d', [TStatusDraft.GetStatus(aFlag)]);
  end;
end;

procedure TCatalogDraftController.Edit;
var
  frmDetail: TCustomFormDetail;
begin
  frmDetail := GetFormDetial(False);
  try
    frmDetail.NewItem := False;
    frmDetail.ShowModal();
    Refresh();
  finally
    frmDetail.Free();
  end;
end;

procedure TCatalogDraftController.EditReadItemDataSet(aDataSet: TDataSet);
begin
  Assert(False, 'EditReadItemDataSet is not implemented');
end;

function TCatalogDraftController.GetCatalogAccess: TCatalogAccessDraft;
begin
  Result := TCatalogAccessDraft(inherited CatalogAccess);
end;

class function TCatalogDraftController.GetCatalogAccessClass: TCatalogAccessClass;
begin
  Result := TCatalogAccessDraft;
end;

function TCatalogDraftController.GetFormDetial(aNew: Boolean): TCustomFormDetail;
begin
  Assert(False, 'GetFormDetial is not implemented');
  raise ECatalogDraftController.Create('GetFormDetial is not implemented');
end;

function TCatalogDraftController.GetSQLProc: TSQLProcDraft;
begin
  Result := TSQLProcDraft(inherited SQLProc);
end;

class function TCatalogDraftController.GetSQLProcClass: TSQLProcClass;
begin
  Result := TSQLProcDraft;
end;

procedure TCatalogDraftController.ImportDraft;
var
  cieTradeMark: TCatalogImportExcel;
begin
  cieTradeMark := TCatalogImportExcel.Create(nil);
  try
    cieTradeMark.Connection := ERPForm.FDConnection;
    cieTradeMark.UserName := GetUser();
    cieTradeMark.ProcMeta := SQLProc.SQLImportMeta;
    cieTradeMark.ProcCheck := SQLProc.SQLImportCheck;
    cieTradeMark.ProcName := SQLProc.SQLImport;
    if cieTradeMark.ShowImportForm() then
      Refresh();
  finally
    cieTradeMark.Free();
  end;
end;

function TCatalogDraftController.IsDraftApprove: Boolean;
begin
  Result := CheckColumnServiceType(stStatus, [TStatusDraft.GetStatus(FLAG_STATUS_RESET)]);
end;

function TCatalogDraftController.IsDraftEdit: Boolean;
begin
  Result := CheckColumnServiceType(stStatus, [TStatusDraft.GetStatus(FLAG_STATUS_READY),
                                              TStatusDraft.GetStatus(FLAG_STATUS_DELETE)]);
end;

function TCatalogDraftController.IsDraftInitial: Boolean;
begin
  Result := CheckColumnServiceType(stStatus, [TStatusDraft.GetStatus(FLAG_STATUS_RESET)]);
end;

function TCatalogDraftController.IsDraftReady: Boolean;
var
  k, i: Integer;
  ColumnStatus: TCustomCatalogColumn;
  ColumnCondition: TCustomCatalogColumn;
  ColumnPK: TCustomCatalogColumn;
  ColumnPKClean: TCustomCatalogColumn;
begin
  ColumnStatus := GetGridColumnFromServiceType(stStatus);
  ColumnCondition := GetGridColumnFromServiceType(stCondition);
  ColumnPK := GetGridColumnFromServiceType(stPK);
  ColumnPKClean := GetGridColumnFromServiceType(stPKClean);
  if not Assigned(ColumnStatus) or not Assigned(ColumnCondition) or not Assigned(ColumnPK) or not Assigned(ColumnPKClean) then
    Exit(False);
  for k := 0 to GridTableView.Controller.SelectedRecordCount - 1 do
  begin
    if not (Integer(GridTableView.Controller.SelectedRecords[k].Values[ColumnStatus.Index]) in [10]) then
      Exit(False);
    if GridTableView.Controller.SelectedRecords[k].Values[ColumnCondition.Index] = 2 then
      Exit(False);
    for i := k + 1 to GridTableView.Controller.SelectedRecordCount - 1 do
      if (GridTableView.Controller.SelectedRecords[k].Values[ColumnPKClean.Index] = GridTableView.Controller.SelectedRecords[i].Values[ColumnPKClean.Index]) and
         (not VarIsNull(GridTableView.Controller.SelectedRecords[k].Values[ColumnPKClean.Index])) then
        Exit(False);
    for i := 0 to GridTableView.DataController.RecordCount - 1 do
      if (GridTableView.Controller.SelectedRecords[k].Values[ColumnPKClean.Index] = GridTableView.DataController.Values[i, ColumnPKClean.Index]) and
         (GridTableView.Controller.SelectedRecords[k].Values[ColumnPK.Index] <> GridTableView.DataController.Values[i, ColumnPK.Index]) and
         (Integer(GridTableView.DataController.Values[i, ColumnStatus.Index]) in [20, 30]) and
         (not VarIsNull(GridTableView.Controller.SelectedRecords[k].Values[ColumnPKClean.Index])) then
        Exit(False);
  end;
  Result := True;
end;

function TCatalogDraftController.IsDraftToDelete: Boolean;
begin
  Result := CheckColumnServiceType(stStatus, [20, 30]);
end;

function TCatalogDraftController.IsNewItem: Boolean;
begin
  Assert(False, 'IsNewItem is not implemented');
  raise ECatalogDraftController.Create('IsNewItem is not implemented');
end;

procedure TCatalogDraftController.Merge;
var
  frmCatalogMerge: TfrmCatalogMerge;
  CatalogMergeInfo: TCatalogMergeInfo;
  Column: TCustomCatalogColumn;
begin
  Column := GetGridColumnFromServiceType(stPK);
  if Assigned(Column) then
  begin
    CatalogMergeInfo.Caption := ERPForm.Caption;
    CatalogMergeInfo.Connection := ERPForm.FDConnection;
    CatalogMergeInfo.UserName := GetUser();
    CatalogMergeInfo.ProcMeta := SQLProc.SQLMergeMeta;
    CatalogMergeInfo.ProcSelect := SQLProc.SQLMergeSelect;
    CatalogMergeInfo.ProcExecute := SQLProc.SQLMerge;
    CatalogMergeInfo.Id_Draft := GridTableView.Controller.FocusedRecord.Values[Column.Index];
    try
      frmCatalogMerge := TfrmCatalogMerge.Create(ERPForm, CatalogMergeInfo);
      try
        frmCatalogMerge.ShowModal();
        Refresh();
      finally
        frmCatalogMerge.Free();
      end;
    except
      raise ECatalogDraftController.Create('Ошибка выполнения Merge.');
    end;
  end;
end;

procedure TCatalogDraftController.ReadItem;
var
  qrQuery: TFDQuery;
begin
  qrQuery := TFDQuery.Create(nil);
  try
    qrQuery.Connection := ERPForm.FDConnection;
    qrQuery.SQL.Text := SQLProc.SQLEditReadItem;
    if qrQuery.ParamCount > 0 then
      SetEditReadItemParams(qrQuery.Params);
    try
      qrQuery.Open();
    except
      raise ECatalogDraftController.CreateFmt('Ошибка выполнения процедуры "%s" в методе ReadItem', [SQLProc.SQLEditReadItem]);
    end;
    EditReadItemDataSet(qrQuery);
  finally
    qrQuery.Free();
  end;
end;

function TCatalogDraftController.Save: Boolean;
var
  qrQuery: TFDQuery;
begin
  qrQuery := TFDQuery.Create(nil);
  try
    qrQuery.Connection := ERPForm.FDConnection;
    if IsNewItem() then
      qrQuery.SQL.Text := SQLProc.SQLInsert
    else
      qrQuery.SQL.Text := SQLProc.SQLUpdate;
    if qrQuery.ParamCount > 0 then
      SetSaveParams(qrQuery.Params);
    Result := TERPQueryHelp.Open(qrQuery);
  finally
    qrQuery.Free();
  end;
end;

procedure TCatalogDraftController.SetEditReadItemParams(aParams: TFDParams);
begin
  Assert(False, 'SetEditReadParams is not implemented');
end;

procedure TCatalogDraftController.SetExecuteSQLParams(aFlag: Integer; aParams: TFDParams);
begin
  case aFlag of
    FLAG_STATUS_RESET, FLAG_STATUS_READY, FLAG_STATUS_DELETE:
      aParams.ParamByName('Id_StatusDraft').AsInteger := TStatusDraft.GetStatus(aFlag);
  end;
end;

procedure TCatalogDraftController.SetRefreshParams(aParams: TFDParams);
begin
  if ERPForm.ERPClientData.ModuleAccess.ContainsBit(CatalogAccess.ViewAll) and
     ERPForm.ERPClientData.ModuleAccess.Items[CatalogAccess.ViewAll]^.Access then
  begin
    aParams.ParamByName('UserName').DataType := ftString;
    aParams.ParamByName('UserName').Value := Null();
  end
  else
    aParams.ParamByName('UserName').Value := GetUser();
end;

procedure TCatalogDraftController.SetSaveParams(aParams: TFDParams);
begin
  Assert(False, 'SetSaveParams is not implemented');
end;

function TCatalogDraftController.UpdateAdd: Boolean;
begin
  Result := ModuleAccess.ContainsBit(CatalogAccess.Add) and
            ModuleAccess.Items[CatalogAccess.Add]^.Access;
end;

function TCatalogDraftController.UpdateAnalysis: Boolean;
begin
   Result := ModuleAccess.ContainsBit(CatalogAccess.Analysis) and
             ModuleAccess.Items[CatalogAccess.Analysis]^.Access and
             (GridTableView.Controller.SelectedRecordCount > 0);
end;

function TCatalogDraftController.UpdateApprove: Boolean;
begin
  Result := ModuleAccess.ContainsBit(CatalogAccess.Approve) and
            ModuleAccess.Items[CatalogAccess.Approve]^.Access and
            (GridTableView.Controller.SelectedRecordCount > 0) and
            IsDraftApprove();
end;

function TCatalogDraftController.UpdateChangeStatusDelete: Boolean;
begin
  Result := ModuleAccess.ContainsBit(CatalogAccess.StatusDelete) and
            ModuleAccess.Items[CatalogAccess.StatusDelete]^.Access and
            (GridTableView.Controller.SelectedRecordCount > 0) and
            IsDraftToDelete();
end;

function TCatalogDraftController.UpdateChangeStatusReady: Boolean;
begin
  Result := ModuleAccess.ContainsBit(CatalogAccess.StatusReady) and
            ModuleAccess.Items[CatalogAccess.StatusReady]^.Access and
            (GridTableView.Controller.SelectedRecordCount > 0) and
            IsDraftReady();
end;

function TCatalogDraftController.UpdateChangeStatusReset: Boolean;
begin
  Result := ModuleAccess.ContainsBit(CatalogAccess.StatusReset) and
            ModuleAccess.Items[CatalogAccess.StatusReset]^.Access and
            (GridTableView.Controller.SelectedRecordCount > 0) and
            IsDraftInitial();
end;

function TCatalogDraftController.UpdateDelete: Boolean;
begin
  Result := ModuleAccess.ContainsBit(CatalogAccess.Delete) and
            ModuleAccess.Items[CatalogAccess.Delete]^.Access and
            (GridTableView.Controller.SelectedRecordCount > 0);
end;

function TCatalogDraftController.UpdateEdit: Boolean;
begin
  Result := ModuleAccess.ContainsBit(CatalogAccess.Edit) and
            ModuleAccess.Items[CatalogAccess.Edit]^.Access and
            (GridTableView.Controller.SelectedRecordCount = 1) and
            IsDraftEdit();
end;

function TCatalogDraftController.UpdateImportDraft: Boolean;
begin
  Result := ModuleAccess.ContainsBit(CatalogAccess.ImportDraft) and
            ModuleAccess.Items[CatalogAccess.ImportDraft]^.Access;
end;

function TCatalogDraftController.UpdateMerge: Boolean;
begin
  Result := ModuleAccess.ContainsBit(CatalogAccess.Merge) and
            ModuleAccess.Items[CatalogAccess.Merge]^.Access and
            (GridTableView.Controller.SelectedRecordCount = 1);
end;

{ TStatusDraft }

class function TStatusDraft.GetStatus(aFlag: Integer): Integer;
var
  k: Integer;
begin
  for k := Low(STATUSDRAFT) to High(STATUSDRAFT) do
    if STATUSDRAFT[k].Flag = aFlag then
      Exit(STATUSDRAFT[k].Status);
  Assert(False, 'TStatusDraft.GetStatus. aFlag not found');
  raise ECatalogDraftController.Create('TStatusDraft.GetStatus. aFlag not found');
end;

end.
