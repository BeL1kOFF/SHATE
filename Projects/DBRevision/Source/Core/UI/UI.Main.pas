unit UI.Main;

interface

uses
  System.Classes,
  System.Actions,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Menus,
  Vcl.ImgList,
  Vcl.ActnList,
  Vcl.ExtCtrls,
  Vcl.Dialogs,
  Data.DB,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxStyles,
  cxCustomData,
  cxFilter,
  cxData,
  cxDataStorage,
  cxEdit,
  cxNavigator,
  cxCheckBox,
  cxClasses,
  cxGridCustomPopupMenu,
  cxGridPopupMenu,
  cxGridLevel,
  cxGridCustomTableView,
  cxGridTableView,
  cxGridCustomView,
  cxGrid,
  cxContainer,
  cxLabel,
  cxTextEdit,
  cxProgressBar,
  dxBar,
  dxStatusBar,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Stan.Param,
  FireDAC.Phys,
  FireDAC.Phys.Intf,
  FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL,
  FireDAC.DatS,
  FireDAC.DApt,
  FireDAC.DApt.Intf,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  SynEditHighlighter,
  SynHighlighterSQL,
  SynEdit,
  SynMemo,
  SynEditMiscClasses,
  SynEditSearch,
  ShateM.Components.TsmGridColumnHide,
  Winapi.ActiveX,
  Logic.TDropTarget,
  System.Types;

type
  TfrmMain = class(TForm, IDragDrop)
    sbInfo: TdxStatusBar;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    dxBarManagerBar2: TdxBar;
    cmbDBList: TdxBarCombo;
    btnProfile: TdxBarButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    FDConnection: TFDConnection;
    FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink;
    qrQuery: TFDQuery;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    SynMemoCommit: TSynMemo;
    SynSQLSyn: TSynSQLSyn;
    SynMemoRollback: TSynMemo;
    btnAdd: TdxBarLargeButton;
    ActionList: TActionList;
    acAdd: TAction;
    cmbTemplateList: TdxBarCombo;
    btnTemplateList: TdxBarButton;
    btnLinkTemplate: TdxBarButton;
    cxImageList: TcxImageList;
    acLinkTemplate: TAction;
    cxImageListLarge: TcxImageList;
    btnLabel: TdxBarLargeButton;
    acLabel: TAction;
    Splitter1: TSplitter;
    cxImageListStatus: TcxImageList;
    cxGridPopupMenu: TcxGridPopupMenu;
    pmSQLScript: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    acStatusNew: TAction;
    acStatusWork: TAction;
    acStatusReady: TAction;
    acStatusComplite: TAction;
    btnSave: TdxBarLargeButton;
    acSave: TAction;
    btnRefresh: TdxBarLargeButton;
    acRefresh: TAction;
    acRenameSQLScript: TAction;
    pmBody: TPopupMenu;
    miBodyRename: TMenuItem;
    acCompare: TAction;
    N6: TMenuItem;
    cxImageListMenu: TcxImageList;
    acCompareBody: TAction;
    miBodyCompare: TMenuItem;
    btnCommit: TdxBarLargeButton;
    btnRollback: TdxBarLargeButton;
    acCommit: TAction;
    acRollback: TAction;
    acStatusCancel: TAction;
    N9: TMenuItem;
    cxStyleRepository: TcxStyleRepository;
    stlGreen: TcxStyle;
    FDConnectionIsCommited: TFDConnection;
    qrQueryIsCommited: TFDQuery;
    dxBarButton1: TdxBarButton;
    acDataBase: TAction;
    cmbProfile: TdxBarCombo;
    pnlDBCommited: TPanel;
    Panel6: TPanel;
    cxGridSS: TcxGrid;
    tblSQLScript: TcxGridTableView;
    colIdSQLScript: TcxGridColumn;
    colIndex: TcxGridColumn;
    colIdStatus: TcxGridColumn;
    colLabel: TcxGridColumn;
    colName: TcxGridColumn;
    colCreateUser: TcxGridColumn;
    colCreateDate: TcxGridColumn;
    colChangeUser: TcxGridColumn;
    colChangeDate: TcxGridColumn;
    colIsCommit: TcxGridColumn;
    cxLevelSS: TcxGridLevel;
    cxLevelDBC: TcxGridLevel;
    cxGridDBC: TcxGrid;
    tblDBCommited: TcxGridTableView;
    Splitter2: TSplitter;
    dxStatusBar1Container0: TdxStatusBarContainerControl;
    cbDBCommited: TcxCheckBox;
    acDBCommited: TAction;
    colDBCServer: TcxGridColumn;
    colDBCDataBase: TcxGridColumn;
    colDBCIsCommited: TcxGridColumn;
    colDBCIsAccess: TcxGridColumn;
    stlRed: TcxStyle;
    colRevision: TcxGridColumn;
    btnRevision: TdxBarLargeButton;
    acRevision: TAction;
    N10: TMenuItem;
    miBodySave: TMenuItem;
    acSaveToFile: TAction;
    sdBody: TSaveDialog;
    colOrder: TcxGridColumn;
    tbnUp: TdxBarLargeButton;
    btnDown: TdxBarLargeButton;
    acUp: TAction;
    acDown: TAction;
    pmGridHeader: TPopupMenu;
    miGridHeader: TMenuItem;
    dxStatusBar1Container1: TdxStatusBarContainerControl;
    cxLabel1: TcxLabel;
    edtFind: TcxTextEdit;
    colFind: TcxGridColumn;
    stlYellow: TcxStyle;
    SynEditSearch: TSynEditSearch;
    fdBody: TFindDialog;
    acStatusPartComplite: TAction;
    N12: TMenuItem;
    dxBarLargeButton1: TdxBarLargeButton;
    acHelp: TAction;
    N13: TMenuItem;
    acCommitNow: TAction;
    N14: TMenuItem;
    acRollbackNow: TAction;
    Rollback1: TMenuItem;
    sbInfoContainer3: TdxStatusBarContainerControl;
    pbProgress: TcxProgressBar;
    dxBarLargeButton2: TdxBarLargeButton;
    acRepair: TAction;
    Splitter3: TSplitter;
    N15: TMenuItem;
    acSaveAllToFile: TAction;
    N16: TMenuItem;
    gchSQLScript: TsmGridColumnHide;
    acCompareOld: TAction;
    N7: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure btnProfileClick(Sender: TObject);
    procedure btnTemplateListClick(Sender: TObject);
    procedure acLinkTemplateUpdate(Sender: TObject);
    procedure acLinkTemplateExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmbDBListChange(Sender: TObject);
    procedure acAddUpdate(Sender: TObject);
    procedure cmbTemplateListChange(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acLabelUpdate(Sender: TObject);
    procedure colIdStatusCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure acStatusNewExecute(Sender: TObject);
    procedure acStatusWorkExecute(Sender: TObject);
    procedure acStatusReadyExecute(Sender: TObject);
    procedure acStatusCompliteExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acRefreshUpdate(Sender: TObject);
    procedure acRenameSQLScriptExecute(Sender: TObject);
    procedure SynMemoCommitChange(Sender: TObject);
    procedure SynMemoRollbackChange(Sender: TObject);
    procedure SynMemoCommitExit(Sender: TObject);
    procedure SynMemoRollbackExit(Sender: TObject);
    procedure acCompareUpdate(Sender: TObject);
    procedure acCompareExecute(Sender: TObject);
    procedure acCompareBodyUpdate(Sender: TObject);
    procedure acCompareBodyExecute(Sender: TObject);
    procedure acRenameSQLScriptUpdate(Sender: TObject);
    procedure acCommitUpdate(Sender: TObject);
    procedure acRollbackUpdate(Sender: TObject);
    procedure acCommitExecute(Sender: TObject);
    procedure acStatusCancelExecute(Sender: TObject);
    procedure acRollbackExecute(Sender: TObject);
    procedure tblSQLScriptStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure tblSQLScriptFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
    procedure acLabelExecute(Sender: TObject);
    procedure tblSQLScriptSelectionChanged(Sender: TcxCustomGridTableView);
    procedure acDataBaseExecute(Sender: TObject);
    procedure cmbProfileChange(Sender: TObject);
    procedure tblSQLScriptDataControllerDataChanged(Sender: TObject);
    procedure acDBCommitedUpdate(Sender: TObject);
    procedure acDBCommitedExecute(Sender: TObject);
    procedure tblDBCommitedStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure acRevisionUpdate(Sender: TObject);
    procedure acRevisionExecute(Sender: TObject);
    procedure acSaveToFileUpdate(Sender: TObject);
    procedure acSaveToFileExecute(Sender: TObject);
    procedure acUpUpdate(Sender: TObject);
    procedure acDownUpdate(Sender: TObject);
    procedure acUpExecute(Sender: TObject);
    procedure acDownExecute(Sender: TObject);
    procedure miGridHeaderClick(Sender: TObject);
    procedure edtFindKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SynMemoCommitKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SynMemoRollbackKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure fdBodyFind(Sender: TObject);
    procedure fdBodyShow(Sender: TObject);
    procedure SynMemoCommitEnter(Sender: TObject);
    procedure SynMemoRollbackEnter(Sender: TObject);
    procedure edtFindPropertiesChange(Sender: TObject);
    procedure acStatusPartCompliteExecute(Sender: TObject);
    procedure acCommitNowUpdate(Sender: TObject);
    procedure acCommitNowExecute(Sender: TObject);
    procedure acRollbackNowExecute(Sender: TObject);
    procedure acRollbackNowUpdate(Sender: TObject);
    procedure acHelpExecute(Sender: TObject);
    procedure acRepairUpdate(Sender: TObject);
    procedure acRepairExecute(Sender: TObject);
    procedure acSaveAllToFileUpdate(Sender: TObject);
    procedure acSaveAllToFileExecute(Sender: TObject);
    procedure acCompareOldExecute(Sender: TObject);
    procedure acCompareOldUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function MSSQLDropAllowed(const aObjName: string; pt: TPoint): Boolean;
    function MSSQLIsAccessObject(const aObjName: string): Boolean;
    procedure MSSQLDrop(const aObjName: string);
  private
    FIsEdit: Boolean;
    FComparePath: string;
    FLastActiveSynMemo: TSynMemo;
    FDropTarget: IDropTarget;
    function GetCursorSynMemo: TSynMemo;
    function GetId_DataBase: Integer;
    function GetId_Template: Integer;
    function IsEditable: Boolean;
    function IsExecutable(aIsCommit: Boolean): boolean;
    function IsSortAndFiltered: Boolean;
    function IsDown: Boolean;
    function IsUp: Boolean;
    procedure CallBackLog(const aMessage: string);
    procedure CallBackProgress(aIndex, aCount: Integer);
    procedure ChangeStatusSQLScript(aId_Status: Integer);
    procedure ClearBody;
    procedure ClearDataBaseList;
    procedure DisableBody;
    procedure EnableBody;
    procedure Init;
    procedure LoadBody(aId_SQLScript: Integer);
    procedure RefreshAll;
    procedure RefreshProfile;
    procedure RefreshDataBaseList(aId_Profile: Integer; aId_CurrentIndex: Integer);
    procedure RefreshTemplateList(aId_Template: Integer);
    procedure RefreshSQLScriptList(aFocusedId: Integer);
    procedure RefreshIsCommited;
    procedure RefreshDataBaseCommited(aId_Template, aIndex: Integer);
    procedure RefreshSelected(aIsUp: Boolean);
    procedure RegisterCompare;
    procedure SetEnableBody;
    procedure SetSynMemoMaxScroll(aSynMemo: TSynMemo);
    property CursorSynMemo: TSynMemo read GetCursorSynMemo;
    property Id_DataBase: Integer read GetId_DataBase;
  public
    property ComparePath: string read FComparePath;
    property Id_Template: Integer read GetId_Template;
  end;

const
  COL_SQLSCRIPT_ID_SQLSCRIPT = 0;
  COL_SQLSCRIPT_INDEX = 1;
  COL_SQLSCRIPT_ID_STATUS = 2;
  COL_SQLSCRIPT_LABEL = 3;
  COL_SQLSCRIPT_REVISION = 4;
  COL_SQLSCRIPT_NAME = 5;
  COL_SQLSCRIPT_CREATEUSER = 6;
  COL_SQLSCRIPT_CREATEDATE = 7;
  COL_SQLSCRIPT_CHANGEUSER = 8;
  COL_SQLSCRIPT_CHANGEDATE = 9;
  COL_SQLSCRIPT_IS_COMMIT = 10;
  COL_SQLSCRIPT_ORDER = 11;
  COL_SQLSCRIPT_FIND = 12;

  GUID_SQLSCRIPT_GRID: TGUID = '{11117B20-A8C8-4BC5-B499-1CA2BDA4B448}';

  STATUS_NEW    = 10;
  STATUS_WORK   = 20;
  STATUS_READY  = 30;
  STATUS_PARTCOMMIT = 35;
  STATUS_COMMIT = 40;
  STATUS_CANCEL = 50;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  Winapi.Windows,
  Winapi.ShellAPI,
  System.Variants,
  System.SysUtils,
  System.IOUtils,
  System.Win.Registry,
  Vcl.Graphics,
  dxCore,
  SynEditTypes,
  Logic.Options,
  Logic.UserFunctions,
  Logic.InterfaceList,
  Logic.InterfaceImpl,
  Logic.TCommitRollback,
  UI.Profile,
  UI.TemplateList,
  UI.CommitRollback,
  UI.DataBaseForm,
  UI.Help,
  UI.CompareOld;

const
  STR_CONNECTION = 'Server=%s;Database=%s;OSAuthent=YES;DriverID=MSSQL;LoginTimeout=4';

  SCRIPT_TMPL_NAME = 'CRT_SCRIPT';

  PROC_MAIN_INS_SQLSCRIPT = 'main_ins_sqlscript :Id_Template, :Count, :Name';
  PARAM_MIS_ID_TEMPLATE = 'Id_Template';
  PARAM_MIS_COUNT = 'Count';
  PARAM_MIS_NAME = 'Name';

  PROC_MAIN_SEL_SQLSCRIPT_BODY = 'main_sel_sqlscript_body :Id_SQLScript';
  PARAM_MSSB_ID_SQLSCRIPT = 'Id_SQLScript';
  FLD_MSSB_BODYCOMMIT = 'BodyCommit';
  FLD_MSSB_BODYROLLBACK = 'BodyRollback';

  COMPARE_FILE_COMMIT = 'commit.sql';
  COMPARE_FILE_ROLLBACK = 'rb.sql';

resourcestring
  RsScriptAddCaption = 'Добавление';
  RsScriptAddText = 'Имя:';
  RsError = 'Ошибка';
  RsScriptCount1100 = 'Кол-во Должно быть в пределах от 1 до 100!';

function GetOptions: IXMLOptionsType;
begin
  Result := LoadOptions(ExtractFilePath(Application.ExeName) + 'Options.xml');
end;

procedure TfrmMain.acAddExecute(Sender: TObject);
var
  Result: string;
  Count: Integer;
  Id_SQLScript: Integer;
  mr: TModalResult;
begin
  Result := SCRIPT_TMPL_NAME;
  mr := InputBoxRevision(Self, RsScriptAddCaption, RsScriptAddText, Result);
  if mr = mrOk then
  begin
    Count := 1;
    if Length(Result) > 0 then
    begin
      if Result[1] = ':' then
      begin
        Count := StrToIntDef(Copy(Result, 2, Length(Result)), 0);
        if Count > 0 then
          Result := SCRIPT_TMPL_NAME;
      end;
    end
    else
      Result := SCRIPT_TMPL_NAME;
    if (Count > 0) and (Count <= 100) then
    begin
      qrQuery.SQL.Text := PROC_MAIN_INS_SQLSCRIPT;
      qrQuery.Params.ParamValues[PARAM_MIS_ID_TEMPLATE] := Id_Template;
      qrQuery.Params.ParamValues[PARAM_MIS_COUNT] := Count;
      qrQuery.Params.ParamValues[PARAM_MIS_NAME] := Result;
      try
        qrQuery.Open();
        Id_SQLScript := qrQuery.Fields.Fields[0].AsInteger;
      finally
        qrQuery.Close();
      end;
      RefreshSQLScriptList(Id_SQLScript);
      tblSQLScript.Controller.TopRecordIndex := tblSQLScript.Controller.FocusedRecordIndex -
        (tblSQLScript.ViewInfo.RecordsViewInfo.VisibleCount + 1) div 2;
    end
    else
      Application.MessageBox(PChar(RsScriptCount1100), PChar(RsError), MB_OK or MB_ICONERROR);
  end;
end;

procedure TfrmMain.acAddUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (Id_DataBase <> -1) and (Id_Template <> -1) and (not FIsEdit);
end;

procedure TfrmMain.acCommitExecute(Sender: TObject);
var
  frmCommitRollback: TfrmCommitRollback;
begin
  frmCommitRollback := TfrmCommitRollback.Create(Self, True);
  try
    frmCommitRollback.ShowModal();
    RefreshSQLScriptList(-1);
  finally
    frmCommitRollback.Free();
  end;
end;

procedure TfrmMain.acCommitNowExecute(Sender: TObject);
var
  FCommitRollback: TCommitRollback;
begin
  if MessageBox(Handle, 'Вы хотите выполнить скрипты в текущей базе данных?', 'Вопрос', MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    pbProgress.Properties.Min := 1;
    pbProgress.Properties.Max := tblSQLScript.Controller.SelectedRecordCount;
    pbProgress.Position := 0;
    FCommitRollback := TCommitRollback.Create(FDConnection, IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).Server,
      IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).DataBase, Id_Template, tblSQLScript.Controller,
      CallBackLog, CallBackProgress);
    try
      FCommitRollback.Commit();
      FCommitRollback.Free();
      pbProgress.Properties.Text := 'Готово';
    except on E: Exception do
    begin
      MessageBox(Handle,
        PChar(Format('ОШИБКА!!! %s'#13#10#13#10'Последний номер скрипта: %d', [E.Message, FCommitRollback.LastExecutedIndex])),
        'Ошибка', MB_OK or MB_ICONERROR);
      FCommitRollback.Free();
    end;
    end;
    RefreshSQLScriptList(-1);
  end;
end;

procedure TfrmMain.acCommitNowUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblSQLScript.Controller.SelectedRecordCount > 0) and (IsExecutable(True)) and
    (not btnLinkTemplate.Enabled) and (not FIsEdit);
end;

procedure TfrmMain.acCommitUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblSQLScript.Controller.SelectedRecordCount > 0) and (IsExecutable(True)) and
    (not btnLinkTemplate.Enabled) and (not FIsEdit);
end;

procedure TfrmMain.acCompareBodyExecute(Sender: TObject);
var
  TmpPath: string;
  TempPathLen: DWORD;
  FileName1, FileName2: string;
begin
  SetLength(TmpPath, MAX_PATH + 1);
  TempPathLen := GetTempPath(MAX_PATH, PChar(TmpPath));
  SetLength(TmpPath, TempPathLen);
  FileName1 := Format('%s%d_%s', [TmpPath, Integer(tblSQLScript.Controller.FocusedRecord.Values[COL_SQLSCRIPT_INDEX]),
    COMPARE_FILE_COMMIT]);
  if TFile.Exists(FileName1) then
    TFile.Delete(FileName1);
  TFile.WriteAllText(FileName1, SynMemoCommit.Lines.Text);
  FileName2 := Format('%s%d_%s', [TmpPath, Integer(tblSQLScript.Controller.FocusedRecord.Values[COL_SQLSCRIPT_INDEX]),
    COMPARE_FILE_ROLLBACK]);
  if TFile.Exists(FileName2) then
    TFile.Delete(FileName2);
  TFile.WriteAllText(FileName2, SynMemoRollback.Lines.Text);
  ShellExecute(Application.Handle, 'open', PChar(FComparePath), PChar(Format('%s %s', [FileName2, FileName1])), '', SW_SHOW);
end;

procedure TfrmMain.acCompareBodyUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (SynMemoCommit.Lines.Text <> '') and (SynMemoRollback.Lines.Text <> '') and (FComparePath <> '');
end;

procedure TfrmMain.acCompareExecute(Sender: TObject);
var
  TmpPath: string;
  TempPathLen: DWORD;
  FileName1, FileName2: string;
begin
  qrQuery.SQL.Text := PROC_MAIN_SEL_SQLSCRIPT_BODY;
  qrQuery.Params.ParamValues[PARAM_MSSB_ID_SQLSCRIPT] := tblSQLScript.Controller.SelectedRecords[0].Values[COL_SQLSCRIPT_ID_SQLSCRIPT];
  try
    qrQuery.Open();
    SetLength(TmpPath, MAX_PATH + 1);
    TempPathLen := GetTempPath(MAX_PATH, PChar(TmpPath));
    SetLength(TmpPath, TempPathLen);
    FileName1 := Format('%s%d.sql', [TmpPath, Integer(tblSQLScript.Controller.SelectedRecords[0].Values[COL_SQLSCRIPT_INDEX])]);
    if TFile.Exists(FileName1) then
      TFile.Delete(FileName1);
    TFile.WriteAllText(FileName1, qrQuery.FieldByName(FLD_MSSB_BODYCOMMIT).AsString);
    qrQuery.Close();
    qrQuery.Params.ParamValues[PARAM_MSSB_ID_SQLSCRIPT] := tblSQLScript.Controller.SelectedRecords[1].Values[COL_SQLSCRIPT_ID_SQLSCRIPT];
    qrQuery.Open();
    FileName2 := Format('%s%d.sql', [TmpPath, Integer(tblSQLScript.Controller.SelectedRecords[1].Values[COL_SQLSCRIPT_INDEX])]);
    if TFile.Exists(FileName2) then
      TFile.Delete(FileName2);
    TFile.WriteAllText(FileName2, qrQuery.FieldByName(FLD_MSSB_BODYCOMMIT).AsString);
    ShellExecute(Application.Handle, 'open', PChar(FComparePath), PChar(Format('%s %s', [FileName1, FileName2])), '', SW_SHOW);
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmMain.acCompareOldExecute(Sender: TObject);
var
  frmCompareOld: TfrmCompareOld;
begin
  frmCompareOld := TfrmCompareOld.Create(Self, tblSQLScript.Controller.FocusedRecord.Values[COL_SQLSCRIPT_ID_SQLSCRIPT],
    CursorSynMemo);
  try
    frmCompareOld.ShowModal();
  finally
    frmCompareOld.Free();
  end;
end;

procedure TfrmMain.acCompareOldUpdate(Sender: TObject);
var
  SynMemo: TSynMemo;
begin
  SynMemo := CursorSynMemo;
  if Assigned(SynMemo) then
    TAction(Sender).Enabled := (not SynMemo.ReadOnly) and (FComparePath <> '')
  else
    TAction(Sender).Enabled := False;
end;

procedure TfrmMain.acCompareUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblSQLScript.Controller.SelectedRecordCount = 2) and (FComparePath <> '');
end;

procedure TfrmMain.acDataBaseExecute(Sender: TObject);
var
  frmDataBase: TfrmDataBase;
begin
  frmDataBase := TfrmDataBase.Create(Self);
  try
    frmDataBase.ShowModal();
  finally
    frmDataBase.Free();
  end;
end;

procedure TfrmMain.acLabelExecute(Sender: TObject);
var
  k: Integer;
  Result: string;
  ResultCode: Integer;
  ResultText: string;
  mr: TModalResult;
begin
  Result := '';
  mr := InputBoxRevision(Self, 'Метка', 'Метка', Result);
  if mr = mrOk then
  begin
    CreateTempTable(FDConnection, 'tmpSQLScriptLabel', ['Id_SQLScript INT', 'Label NVARCHAR(20)']);
    try
      for k := 0 to tblSQLScript.Controller.SelectedRecordCount - 1 do
        InsertTempTable(FDConnection, 'tmpSQLScriptLabel', [tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ID_SQLSCRIPT],
          tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_LABEL]]);
      qrQuery.SQL.Text := 'main_upd_sqlscript_label :Label';
      qrQuery.Params.ParamValues['Label'] := Result;
      try
        qrQuery.Open();
        ResultCode := qrQuery.Fields.Fields[0].AsInteger;
        ResultText := qrQuery.Fields.Fields[1].AsString;
        if ResultCode = 0 then
          Application.MessageBox(PChar(ResultText), 'Предупреждение', MB_OK or MB_ICONWARNING)
        else
          RefreshSQLScriptList(-1);
      finally
        qrQuery.Close();
      end;
    finally
      DropTempTable(FDConnection, 'tmpSQLScriptLabel');
    end;
  end;
end;

procedure TfrmMain.acLabelUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblSQLScript.Controller.SelectedRecordCount > 0) and (not FIsEdit);
end;

procedure TfrmMain.acLinkTemplateExecute(Sender: TObject);
var
  ResultText: string;
begin
  qrQuery.SQL.Text := 'main_upd_link_dbtemplate :Id_DataBase, :Id_Template';
  qrQuery.Params.ParamValues['Id_DataBase'] := IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).Id_DataBase;
  qrQuery.Params.ParamValues['Id_Template'] := Id_Template;
  try
    qrQuery.Open();
    ResultText := qrQuery.Fields.Fields[1].AsString;
    Application.MessageBox(PChar(ResultText), 'Сообщение', MB_OK or MB_ICONINFORMATION);
    RefreshDataBaseList(Integer(cmbProfile.Items.Objects[cmbProfile.ItemIndex]), cmbDBList.ItemIndex);
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmMain.acLinkTemplateUpdate(Sender: TObject);
begin
  if (cmbDBList.ItemIndex > -1) and (cmbTemplateList.ItemIndex > -1) then
    TAction(Sender).Enabled := (Id_Template <> IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).Id_Template)
  else
    TAction(Sender).Enabled := False;
end;

procedure TfrmMain.acRefreshExecute(Sender: TObject);
var
  k: Integer;
begin
  for k := 0 to tblSQLScript.ColumnCount - 1 do
  begin
    tblSQLScript.Columns[k].SortOrder := soNone;
    tblSQLScript.Columns[k].Filtered := False;
  end;
  RefreshSQLScriptList(-1);
end;

procedure TfrmMain.acRefreshUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (Id_DataBase <> -1) and (Id_Template <> -1);
end;

procedure TfrmMain.acRenameSQLScriptExecute(Sender: TObject);
var
  Result: string;
  mr: TModalResult;
begin
  Result := GenerateScriptName(SynMemoCommit.Lines);
  mr := InputBoxRevision(Self, 'Переименование', 'Название:', Result);
  if mr = mrOk then
  begin
    qrQuery.SQL.Text := 'main_upd_sqlscript_name :Id_SQLScript, :Name';
    qrQuery.Params.ParamValues['Id_SQLScript'] := tblSQLScript.Controller.FocusedRecord.Values[COL_SQLSCRIPT_ID_SQLSCRIPT];
    qrQuery.Params.ParamValues['Name'] := Result;
    qrQuery.ExecSQL();
    tblSQLScript.Controller.FocusedRecord.Values[COL_SQLSCRIPT_NAME] := Result;
  end;
end;

procedure TfrmMain.acRenameSQLScriptUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblSQLScript.Controller.SelectedRecordCount = 1;
end;

procedure TfrmMain.acRepairExecute(Sender: TObject);
var
  k: Integer;
begin
  if MessageBox(Handle, 'Вы хотите выполнить ремонт базы данных?', 'Вопрос', MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    FDConnectionIsCommited.ConnectionString := Format(STR_CONNECTION, [IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).Server,
      IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).DataBase]);
    FDConnectionIsCommited.Connected := True;
    try
      qrQueryIsCommited.SQL.Text := 'SELECT Id_Template, [Index] FROM DBRevision';
      try
        qrQueryIsCommited.Open();
        qrQueryIsCommited.First();
        CreateTempTable(FDConnection, 'tmpRepair', ['Id_Template INT', '[Index] INT']);
        try
          for k := 0 to qrQueryIsCommited.RecordCount - 1 do
          begin
            InsertTempTable(FDConnection, 'tmpRepair', [qrQueryIsCommited.FieldByName('Id_Template').AsInteger,
              qrQueryIsCommited.FieldByName('Index').AsInteger]);
            qrQueryIsCommited.Next();
          end;
          qrQuery.SQL.Text := 'main_upd_sqlscriptcommited_repair :Server, :DataBase';
          qrQuery.Params.ParamValues['Server'] := IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).Server;
          qrQuery.Params.ParamValues['DataBase'] := IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).DataBase;
          qrQuery.ExecSQL();
          MessageBox(Handle, 'Ремонт завершен', 'Сообщение', MB_OK or MB_ICONINFORMATION);
        finally
          DropTempTable(FDConnection, 'tmpRepair');
        end;
      finally
        qrQueryIsCommited.Close();
      end;
    finally
      FDConnectionIsCommited.Connected := False;
    end;
  end;
end;

procedure TfrmMain.acRepairUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (Id_DataBase <> -1) and (Id_Template <> -1) and (not FIsEdit) and (not btnLinkTemplate.Enabled);
end;

procedure TfrmMain.acRevisionExecute(Sender: TObject);
var
  k: Integer;
  Result: string;
  ResultCode: Integer;
  ResultText: string;
  mr: TModalResult;
begin
  Result := '';
  mr := InputBoxRevision(Self, 'Ревизия', 'Ревизия::', Result);
  if mr = mrOk then
  begin
    CreateTempTable(FDConnection, 'tmpSQLScriptRev', ['Id_SQLScript INT', 'Revision NVARCHAR(20)']);
    try
      for k := 0 to tblSQLScript.Controller.SelectedRecordCount - 1 do
        InsertTempTable(FDConnection, 'tmpSQLScriptRev', [tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ID_SQLSCRIPT],
          tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_REVISION]]);
      qrQuery.SQL.Text := 'main_upd_sqlscript_revision :Revision';
      qrQuery.Params.ParamValues['Revision'] := Result;
      try
        qrQuery.Open();
        ResultCode := qrQuery.Fields.Fields[0].AsInteger;
        ResultText := qrQuery.Fields.Fields[1].AsString;
        if ResultCode = 0 then
          Application.MessageBox(PChar(ResultText), 'Предупреждение', MB_OK or MB_ICONWARNING)
        else
          RefreshSQLScriptList(-1);
      finally
        qrQuery.Close();
      end;
    finally
      DropTempTable(FDConnection, 'tmpSQLScriptRev');
    end;
  end;
end;

procedure TfrmMain.acRevisionUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblSQLScript.Controller.SelectedRecordCount > 0) and (not FIsEdit);
end;

procedure TfrmMain.acRollbackExecute(Sender: TObject);
var
  frmCommitRollback: TfrmCommitRollback;
begin
  frmCommitRollback := TfrmCommitRollback.Create(Self, False);
  try
    frmCommitRollback.ShowModal();
    RefreshSQLScriptList(-1);
  finally
    frmCommitRollback.Free();
  end;
end;

procedure TfrmMain.acRollbackNowExecute(Sender: TObject);
var
  FCommitRollback: TCommitRollback;
begin
  if MessageBox(Handle, 'Вы хотите откатить скрипты в текущей базе данных?', 'Вопрос', MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    pbProgress.Properties.Min := 1;
    pbProgress.Properties.Max := tblSQLScript.Controller.SelectedRecordCount;
    pbProgress.Position := 0;
    FCommitRollback := TCommitRollback.Create(FDConnection, IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).Server,
      IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).DataBase, Id_Template, tblSQLScript.Controller,
      CallBackLog, CallBackProgress);
    try
      FCommitRollback.Rollback();
      FCommitRollback.Free();
      pbProgress.Properties.Text := 'Готово';
    except on E: Exception do
    begin
      MessageBox(Handle,
        PChar(Format('ОШИБКА!!! %s'#13#10#13#10'Последний выполненный номер скрипта: %d', [E.Message, FCommitRollback.LastExecutedIndex])),
        'Ошибка', MB_OK or MB_ICONERROR);
      FCommitRollback.Free();
    end;
    end;
    RefreshSQLScriptList(-1);
  end;
end;

procedure TfrmMain.acRollbackNowUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblSQLScript.Controller.SelectedRecordCount > 0) and (IsExecutable(False)) and
    (not btnLinkTemplate.Enabled) and (not FIsEdit);
end;

procedure TfrmMain.acRollbackUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblSQLScript.Controller.SelectedRecordCount > 0) and (IsExecutable(False)) and
    (not btnLinkTemplate.Enabled) and (not FIsEdit);
end;

procedure TfrmMain.acSaveAllToFileExecute(Sender: TObject);
var
  CommitList: TStringList;
  RollbackList: TStringList;
  k: Integer;
  CaptionC: string;
  CaptionRB: string;
  Go: string;
begin
  sdBody.FileName := '';
  if sdBody.Execute() then
  begin
    CommitList := TStringList.Create();
    try
      RollbackList := TStringList.Create();
      try
        for k := 0 to tblSQLScript.Controller.SelectedRecordCount - 1 do
        begin
            qrQuery.SQL.Text := PROC_MAIN_SEL_SQLSCRIPT_BODY;
            qrQuery.Params.ParamValues[PARAM_MSSB_ID_SQLSCRIPT] := tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ID_SQLSCRIPT];
            try
              qrQuery.Open();
              CaptionC := Format('-- № %d. "%s"--', [Integer(tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_INDEX]),
                string(tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_NAME])]);
              CaptionRB := Format('-- RB № %d. "%s"--', [Integer(tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_INDEX]),
                string(tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_NAME])]);
              Go := #13#10'GO'#13#10;
              CommitList.Add(CaptionC);
              CommitList.Add(qrQuery.FieldByName(FLD_MSSB_BODYCOMMIT).AsString);
              CommitList.Add(Go);
              RollbackList.Add(Go);
              RollbackList.Add(qrQuery.FieldByName(FLD_MSSB_BODYROLLBACK).AsString);
              RollbackList.Add(CaptionRB);
            finally
              qrQuery.Close();
            end;
        end;
        CommitList.Add(#13#10'-- Секция Rollback --'#13#10);
        for k := RollbackList.Count - 1 downto 0 do
          CommitList.Add(RollbackList.Strings[k]);
        CommitList.SaveToFile(sdBody.FileName);
      finally
        RollbackList.Free();
      end;
    finally
      CommitList.Free();
    end;
  end;
end;

procedure TfrmMain.acSaveAllToFileUpdate(Sender: TObject);
begin
  if tblSQLScript.Focused then
    TAction(Sender).Enabled := tblSQLScript.Controller.SelectedRecordCount > 0
  else
    TAction(Sender).Enabled := False;
end;

procedure TfrmMain.acSaveExecute(Sender: TObject);
var
  ResultCode: Integer;
  ResultText: string;
begin
  qrQuery.SQL.Text := 'main_upd_sqlscript_body :Id_SQLScript, :BodyCommit, :BodyRollback, :ChangeUser';
  qrQuery.Params.ParamValues['Id_SQLScript'] := tblSQLScript.Controller.FocusedRecord.Values[COL_SQLSCRIPT_ID_SQLSCRIPT];
  qrQuery.Params.ParamByName('BodyCommit').AsWideMemo := SynMemoCommit.Lines.Text;
  qrQuery.Params.ParamByName('BodyRollback').AsWideMemo := SynMemoRollback.Lines.Text;
  qrQuery.Params.ParamValues['ChangeUser'] := tblSQLScript.Controller.FocusedRecord.Values[COL_SQLSCRIPT_CHANGEUSER];
  try
    qrQuery.Open();
    ResultCode := qrQuery.Fields.Fields[0].AsInteger;
    ResultText := qrQuery.Fields.Fields[1].AsString;
    if ResultCode = 0 then
      Application.MessageBox(PChar(ResultText), 'Предупреждение', MB_OK or MB_ICONWARNING)
    else
    begin
      FIsEdit := False;
      RefreshSQLScriptList(-1);
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmMain.acSaveToFileExecute(Sender: TObject);
begin
  if Assigned(FLastActiveSynMemo) then
  begin
    sdBody.FileName := '';
    if sdBody.Execute() then
      FLastActiveSynMemo.Lines.SaveToFile(sdBody.FileName);
  end;
end;

procedure TfrmMain.acSaveToFileUpdate(Sender: TObject);
begin
  if SynMemoCommit.Focused then
    TAction(Sender).Enabled := SynMemoCommit.Lines.Text <> ''
  else
    if SynMemoRollback.Focused then
      TAction(Sender).Enabled := SynMemoRollback.Lines.Text <> ''
    else
      TAction(Sender).Enabled := False;
end;

procedure TfrmMain.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblSQLScript.Controller.SelectedRecordCount = 1) and (FIsEdit);
end;

procedure TfrmMain.acDBCommitedExecute(Sender: TObject);
begin
  pnlDBCommited.Visible := ((Sender as TAction).ActionComponent as TcxCheckBox).Checked;
  Splitter2.Visible := pnlDBCommited.Visible;
  if pnlDBCommited.Visible then
    RefreshDataBaseCommited(Id_Template, tblSQLScript.Controller.FocusedRecord.Values[COL_SQLSCRIPT_INDEX]);
end;

procedure TfrmMain.acDBCommitedUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblSQLScript.Controller.SelectedRecordCount = 1;
end;

procedure TfrmMain.acDownExecute(Sender: TObject);
var
  k: Integer;
  ResultCode: Integer;
  ResultText: string;
begin
  CreateTempTable(FDConnection, 'tmpSQLScriptSortDown', ['Id_SQLScript INT, [Order] INT']);
  try
    for k := 0 to tblSQLScript.Controller.SelectedRecordCount - 1 do
      InsertTempTable(FDConnection, 'tmpSQLScriptSortDown', [tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ID_SQLSCRIPT],
        tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ORDER]]);
    qrQuery.SQL.Text := 'main_upd_sqlscript_order_down :Id_Template';
    qrQuery.Params.ParamValues['Id_Template'] := Id_Template;
    try
      qrQuery.Open();
      ResultCode := qrQuery.Fields.Fields[0].AsInteger;
      ResultText := qrQuery.Fields.Fields[1].AsString;
      if ResultCode = 0 then
        Application.MessageBox(PChar(ResultText), 'Предупреждение', MB_OK or MB_ICONWARNING)
      else
      begin
        RefreshSQLScriptList(-1);
        RefreshSelected(False);
      end;
    finally
      qrQuery.Close();
    end;
  finally
    DropTempTable(FDConnection, 'tmpSQLScriptSortDown');
  end;
end;

procedure TfrmMain.acDownUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblSQLScript.Controller.SelectedRecordCount > 0) and (IsDown()) and (not FIsEdit);
end;

procedure TfrmMain.acHelpExecute(Sender: TObject);
var
  frmHelp: TfrmHelp;
begin
  frmHelp := TfrmHelp.Create(Self);
  try
    frmHelp.ShowModal();
  finally
    frmHelp.Free();
  end;
end;

procedure TfrmMain.acStatusCancelExecute(Sender: TObject);
begin
  ChangeStatusSQLScript(STATUS_CANCEL);
end;

procedure TfrmMain.acStatusCompliteExecute(Sender: TObject);
begin
  ChangeStatusSQLScript(STATUS_COMMIT);
end;

procedure TfrmMain.acStatusNewExecute(Sender: TObject);
begin
  ChangeStatusSQLScript(STATUS_NEW);
end;

procedure TfrmMain.acStatusPartCompliteExecute(Sender: TObject);
begin
  ChangeStatusSQLScript(STATUS_PARTCOMMIT);
end;

procedure TfrmMain.acStatusReadyExecute(Sender: TObject);
begin
  ChangeStatusSQLScript(STATUS_READY);
end;

procedure TfrmMain.acStatusWorkExecute(Sender: TObject);
begin
  ChangeStatusSQLScript(STATUS_WORK);
end;

procedure TfrmMain.acUpExecute(Sender: TObject);
var
  k: Integer;
  ResultCode: Integer;
  ResultText: string;
begin
  CreateTempTable(FDConnection, 'tmpSQLScriptSortUp', ['Id_SQLScript INT, [Order] INT']);
  try
    for k := 0 to tblSQLScript.Controller.SelectedRecordCount - 1 do
      InsertTempTable(FDConnection, 'tmpSQLScriptSortUp', [tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ID_SQLSCRIPT],
        tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ORDER]]);
    qrQuery.SQL.Text := 'main_upd_sqlscript_order_up :Id_Template';
    qrQuery.Params.ParamValues['Id_Template'] := Id_Template;
    try
      qrQuery.Open();
      ResultCode := qrQuery.Fields.Fields[0].AsInteger;
      ResultText := qrQuery.Fields.Fields[1].AsString;
      if ResultCode = 0 then
        Application.MessageBox(PChar(ResultText), 'Предупреждение', MB_OK or MB_ICONWARNING)
      else
      begin
        RefreshSQLScriptList(-1);
        RefreshSelected(True);
      end;
    finally
      qrQuery.Close();
    end;
  finally
    DropTempTable(FDConnection, 'tmpSQLScriptSortUp');
  end;
end;

procedure TfrmMain.acUpUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblSQLScript.Controller.SelectedRecordCount > 0) and (IsUp()) and (not FIsEdit);
end;

procedure TfrmMain.btnProfileClick(Sender: TObject);
var
  frmProfile: TfrmProfile;
begin
  frmProfile := TfrmProfile.Create(Self);
  try
    frmProfile.ShowModal();
  finally
    frmProfile.Free();
  end;
  RefreshAll();
end;

procedure TfrmMain.btnTemplateListClick(Sender: TObject);
var
  frmTemplateList: TfrmTemplateList;
begin
  frmTemplateList := TfrmTemplateList.Create(Self);
  try
    frmTemplateList.ShowModal();
  finally
    frmTemplateList.Free();
  end;
  RefreshAll();
end;

procedure TfrmMain.CallBackLog(const aMessage: string);
begin
  pbProgress.Properties.Text := aMessage;
  pbProgress.Update();
end;

procedure TfrmMain.CallBackProgress(aIndex, aCount: Integer);
begin
  pbProgress.Position := pbProgress.Position + 1;
  pbProgress.Update();
end;

procedure TfrmMain.ChangeStatusSQLScript(aId_Status: Integer);
var
  k: Integer;
  ResultCode: Integer;
  ResultText: string;
begin
  CreateTempTable(FDConnection, 'tmpStatusSQLScript', ['Id_SQLScript INT, Id_Status INT']);
  try
    for k := 0 to tblSQLScript.Controller.SelectedRecordCount - 1 do
      InsertTempTable(FDConnection, 'tmpStatusSQLScript', [tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ID_SQLSCRIPT],
        tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ID_STATUS]]);
    qrQuery.SQL.Text := 'main_upd_status_sqlscript :Id_Status';
    qrQuery.Params.ParamValues['Id_Status'] := aId_Status;
    try
      qrQuery.Open();
      ResultCode := qrQuery.Fields.Fields[0].AsInteger;
      ResultText := qrQuery.Fields.Fields[1].AsString;
      if ResultCode = 0 then
        Application.MessageBox(PChar(ResultText), 'Предупреждение', MB_OK or MB_ICONWARNING);
      RefreshSQLScriptList(-1);
      SetEnableBody();
    finally
      qrQuery.Close();
    end;
  finally
    DropTempTable(FDConnection, 'tmpStatusSQLScript');
  end;
end;

procedure TfrmMain.ClearBody;
begin
  SynMemoCommit.Lines.Clear();
  SynMemoRollback.Lines.Clear();
end;

procedure TfrmMain.ClearDataBaseList;
var
  k: Integer;
begin
  for k := 0 to cmbDBList.Items.Count - 1 do
  begin
    IDataBase(Integer(cmbDBList.Items.Objects[k]))._Release();
    cmbDBList.Items.Objects[k] := nil;
  end;
  cmbDBList.Items.Clear();
end;

procedure TfrmMain.cmbDBListChange(Sender: TObject);
begin
  if (Sender as TdxBarCombo).ItemIndex > -1 then
    RefreshTemplateList(IDataBase(Integer((Sender as TdxBarCombo).Items.Objects[(Sender as TdxBarCombo).ItemIndex])).Id_Template)
  else
    cmbTemplateList.ItemIndex := -1;
end;

procedure TfrmMain.cmbProfileChange(Sender: TObject);
begin
  if (Sender as TdxBarCombo).ItemIndex > -1 then
    RefreshDataBaseList(Integer((Sender as TdxBarCombo).Items.Objects[(Sender as TdxBarCombo).ItemIndex]), -1)
  else
    cmbDBList.ItemIndex := -1;
end;

procedure TfrmMain.cmbTemplateListChange(Sender: TObject);
begin
  if (Sender as TdxBarCombo).ItemIndex <> -1 then
    RefreshSQLScriptList(-1)
  else
    tblSQLScript.DataController.RecordCount := 0;
end;

// Реализовано через прорисовку, т.к. по Blob нет фильтра.
procedure TfrmMain.colIdStatusCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);

  function GetIconIndexOfStatus(aId_Status: Integer): Integer;
  begin
    case aId_Status of
      STATUS_NEW:
        Result := 0;
      STATUS_WORK:
        Result := 1;
      STATUS_READY:
        Result := 2;
      STATUS_PARTCOMMIT:
        Result := 3;
      STATUS_COMMIT:
        Result := 4;
      STATUS_CANCEL:
        Result := 5;
      else
        Result := -1;
    end;
  end;

begin
  if not Assigned(AViewInfo) then
    Exit;
  ACanvas.FillRect(AViewInfo.Bounds);
  ACanvas.Brush.Color := clWhite;
  cxImageListStatus.Draw(ACanvas.Canvas, AViewInfo.Bounds.CenterPoint.X - 8, AViewInfo.Bounds.CenterPoint.Y - 8, GetIconIndexOfStatus(AViewInfo.DisplayValue));
  ADone := True;
end;

procedure TfrmMain.edtFindKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  k: Integer;
begin
  if (Sender as TcxTextEdit).Text = '' then
    Exit;
  if Key = VK_RETURN then
  begin
    qrQuery.SQL.Text := 'main_sel_search :Id_Template, :Text';
    qrQuery.Params.ParamValues['Id_Template'] := Id_Template;
    qrQuery.Params.ParamValues['Text'] := (Sender as TcxTextEdit).Text;
    try
      qrQuery.Open();
      for k := 0 to tblSQLScript.ViewData.RecordCount - 1 do
      begin
        if qrQuery.Locate('Id_SQLScript', tblSQLScript.ViewData.Records[k].Values[COL_SQLSCRIPT_ID_SQLSCRIPT], []) then
          tblSQLScript.ViewData.Records[k].Values[COL_SQLSCRIPT_FIND] := 1
        else
          tblSQLScript.ViewData.Records[k].Values[COL_SQLSCRIPT_FIND] := 0;
      end;
    finally
      qrQuery.Close();
    end;
  end;
end;

procedure TfrmMain.edtFindPropertiesChange(Sender: TObject);
begin
  fdBody.FindText := (Sender as TcxTextEdit).Text;
end;

procedure TfrmMain.DisableBody;
begin
  SynMemoCommit.ReadOnly := True;
  SynMemoRollback.ReadOnly := True;
  SynMemoCommit.Color := clBtnFace;
  SynMemoRollback.Color := clBtnFace;
end;

procedure TfrmMain.EnableBody;
begin
  SynMemoCommit.ReadOnly := False;
  SynMemoRollback.ReadOnly := False;
  SynMemoCommit.Color := clWindow;
  SynMemoRollback.Color := clWindow;
end;

procedure TfrmMain.fdBodyFind(Sender: TObject);
var
  Options: TSynSearchOptions;
begin
  if Assigned(FLastActiveSynMemo) then
  begin
    Options := [];
    if frWholeWord in (Sender as TFindDialog).Options then
      Options := Options + [ssoWholeWord];
    if frMatchCase in (Sender as TFindDialog).Options then
      Options := Options + [ssoMatchCase];
    if not (frDown in (Sender as TFindDialog).Options) then
      Options := Options + [ssoBackwards];
    FLastActiveSynMemo.SearchReplace((Sender as TFindDialog).FindText, '', Options);
  end;
end;

procedure TfrmMain.fdBodyShow(Sender: TObject);
var
  CaretBegin: TBufferCoord;
begin
  CaretBegin.Line := 0;
  CaretBegin.Char := 0;
  FLastActiveSynMemo.CaretXY := CaretBegin;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FDropTarget := TDropTarget.Create(Handle, Self);
  RegisterDragDrop(Handle, FDropTarget);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  ClearDataBaseList();
  RevokeDragDrop(Handle);
  FDropTarget := nil;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  Init;
end;

function TfrmMain.GetId_Template: Integer;
begin
  if cmbTemplateList.ItemIndex > -1 then
    Result := Integer(cmbTemplateList.Items.Objects[cmbTemplateList.ItemIndex])
  else
    Result := -1;
end;

function TfrmMain.GetCursorSynMemo: TSynMemo;
var
  Pt: TPoint;

  function GetSynMemo(aSynMemo: TSynMemo): TSynMemo;
  begin
    if aSynMemo.BoundsRect.Contains(aSynMemo.Parent.ScreenToClient(Pt)) then
      Result := aSynMemo
    else
      Result := nil;
  end;

begin
  Pt := Mouse.CursorPos;
  Result := GetSynMemo(SynMemoCommit);
  if not Assigned(Result) then
    Result := GetSynMemo(SynMemoRollback);
end;

function TfrmMain.GetId_DataBase: Integer;
begin
  if cmbDBList.ItemIndex > -1 then
    Result := IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).Id_DataBase
  else
    Result := -1;
end;

procedure TfrmMain.Init;
begin
  FComparePath := '';
  FDConnection.ConnectionString := Format(STR_CONNECTION, [GetOptions().Connection.Server, GetOptions().Connection.DataBase]);
  FDConnection.Connected := True;
  sbInfo.Panels.Items[2].Text := Format(' Сервер: %s  База данных: %s', [GetOptions().Connection.Server, GetOptions().Connection.DataBase]);
  RegisterCompare();
  gchSQLScript.FileXMLName := Format('%s%s', [IncludeTrailingPathDelimiter(TPath.GetDocumentsPath()), 'DBRevisionColumn.xml']);
  gchSQLScript.RefreshColumn(GetUserName(), GUID_SQLSCRIPT_GRID.ToString());
  RefreshAll();
end;

function TfrmMain.IsDown: Boolean;
var
  k: Integer;
  Index: Integer;
begin
  if IsSortAndFiltered() then
    Result := False
  else
    if tblSQLScript.Controller.SelectedRecordCount > 0 then
      if tblSQLScript.Controller.SelectedRecords[tblSQLScript.Controller.SelectedRecordCount - 1].Index = tblSQLScript.DataController.RecordCount - 1 then
        Result := False
      else
      begin
        Result := True;
        Index := tblSQLScript.Controller.SelectedRecords[tblSQLScript.Controller.SelectedRecordCount - 1].Values[COL_SQLSCRIPT_ORDER];
        for k := tblSQLScript.Controller.SelectedRecordCount - 2 downto 0 do
        begin
          if (tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ORDER] + 1 <> Index) or
             (tblSQLScript.Controller.SelectedRecords[k].Index = tblSQLScript.DataController.RecordCount - 1) then
          begin
            Result := False;
            Break;
          end;
          Index := tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ORDER];
        end;
      end
    else
      Result := False;
end;

function TfrmMain.IsEditable: Boolean;
var
  k: Integer;
begin
  if tblSQLScript.Controller.SelectedRecordCount = 0 then
    Result := False
  else
    Result := True;
  for k := 0 to tblSQLScript.Controller.SelectedRecordCount - 1 do
    if Integer(tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ID_STATUS]) in [STATUS_PARTCOMMIT,
                                                                                               STATUS_READY,
                                                                                               STATUS_COMMIT,
                                                                                               STATUS_CANCEL] then
    begin
      Result := False;
      Break;
    end;
end;

function TfrmMain.IsExecutable(aIsCommit: Boolean): boolean;
var
  k: Integer;
begin
  if IsSortAndFiltered() then
    Result := False
  else
  begin
    Result := True;
    for k := 0 to tblSQLScript.Controller.SelectedRecordCount - 1 do
      if Integer(tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ID_STATUS]) = STATUS_CANCEL then
      begin
        Result := False;
        Break;
      end;
  end;
end;

function TfrmMain.IsSortAndFiltered: Boolean;
var
  k: Integer;
begin
  Result := False;
  for k := 0 to tblSQLScript.ColumnCount - 1 do
    if (tblSQLScript.Columns[k].SortOrder <> soNone) or (tblSQLScript.Columns[k].Filtered) then
    begin
      Result := True;
      Break;
    end;
end;

function TfrmMain.IsUp: Boolean;
var
  k: Integer;
  Index: Integer;
begin
  if IsSortAndFiltered() then
    Result := False
  else
    if tblSQLScript.Controller.SelectedRecordCount > 0 then
      if tblSQLScript.Controller.SelectedRecords[0].Index = 0 then
        Result := False
      else
      begin
        Result := True;
        Index := tblSQLScript.Controller.SelectedRecords[0].Values[COL_SQLSCRIPT_ORDER];
        for k := 1 to tblSQLScript.Controller.SelectedRecordCount - 1 do
        begin
          if (tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ORDER] - 1 <> Index) or
             (tblSQLScript.Controller.SelectedRecords[k].Index = 0) then
          begin
            Result := False;
            Break;
          end;
          Index := tblSQLScript.Controller.SelectedRecords[k].Values[COL_SQLSCRIPT_ORDER];
        end;
      end
    else
      Result := False;
end;

procedure TfrmMain.LoadBody(aId_SQLScript: Integer);
begin
  qrQuery.SQL.Text := PROC_MAIN_SEL_SQLSCRIPT_BODY;
  qrQuery.Params.ParamValues[PARAM_MSSB_ID_SQLSCRIPT] := aId_SQLScript;
  try
    qrQuery.Open();
    SynMemoCommit.Lines.Text := qrQuery.FieldByName(FLD_MSSB_BODYCOMMIT).AsString;
    SynMemoRollback.Lines.Text := qrQuery.FieldByName(FLD_MSSB_BODYROLLBACK).AsString;
    FIsEdit := False;
    SetSynMemoMaxScroll(SynMemoCommit);
    SetSynMemoMaxScroll(SynMemoRollback);
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmMain.miGridHeaderClick(Sender: TObject);
begin
  gchSQLScript.ShowUserColumnForm(GetUserName(), GUID_SQLSCRIPT_GRID.ToString());
end;

procedure TfrmMain.MSSQLDrop(const aObjName: string);
var
  ObjName: string;
begin
  FDConnectionIsCommited.ConnectionString := Format(STR_CONNECTION, [IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).Server,
    IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).DataBase]);
  FDConnectionIsCommited.Connected := True;
  try
    ObjName := Copy(aObjName, Pos('.', aObjName) + 1, Length(aObjName));
    if SameText(ObjName[1], '[') then
      ObjName := Copy(ObjName, 2, Length(ObjName) - 2);
    qrQueryIsCommited.SQL.Text := 'SELECT sm.definition FROM sys.all_objects ao JOIN sys.sql_modules sm ON sm.[object_id] = ao.[object_id] WHERE ao.name = ' + QuotedStr(ObjName);
    try
      qrQueryIsCommited.Open();
      if qrQueryIsCommited.RecordCount = 1 then
      begin
        SynMemoCommit.Lines.Text := qrQueryIsCommited.FieldByName('definition').AsString;
        SynMemoCommit.SetFocus();
        FIsEdit := True;
        SetSynMemoMaxScroll(SynMemoCommit);
      end;
    finally
      qrQueryIsCommited.Close();
    end;
  finally
    FDConnectionIsCommited.Connected := False;
  end;
end;

function TfrmMain.MSSQLDropAllowed(const aObjName: string; pt: TPoint): Boolean;
var
  SynMemo: TSynMemo;
begin
  SynMemo := GetCursorSynMemo();
  if Assigned(SynMemo) and SameText(SynMemo.Name, SynMemoCommit.Name) and (not SynMemoCommit.ReadOnly) then
    Result := True
  else
    Result := False;
end;

function TfrmMain.MSSQLIsAccessObject(const aObjName: string): Boolean;
var
  ObjName: string;
begin
  if (Id_DataBase = -1) or (Id_Template = -1) then
    Exit(False);
  FDConnectionIsCommited.ConnectionString := Format(STR_CONNECTION, [IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).Server,
    IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).DataBase]);
  FDConnectionIsCommited.Connected := True;
  try
    Result := False;
    ObjName := Copy(aObjName, Pos('.', aObjName) + 1, Length(aObjName));
    if SameText(ObjName[1], '[') then
      ObjName := Copy(ObjName, 2, Length(ObjName) - 2);
    qrQueryIsCommited.SQL.Text := 'SELECT * FROM sys.all_objects ao WHERE ao.name = ' + QuotedStr(ObjName);
    try
      qrQueryIsCommited.Open();
      Result := qrQueryIsCommited.RecordCount = 1;
    finally
      qrQueryIsCommited.Close();
    end;
  finally
    FDConnectionIsCommited.Connected := False;
  end;
end;

procedure TfrmMain.RefreshAll;
begin
  cmbTemplateList.Items.Clear();
  ClearDataBaseList();
  RefreshProfile();
end;

procedure TfrmMain.RefreshDataBaseCommited(aId_Template, aIndex: Integer);
var
  k: Integer;
begin
  qrQuery.SQL.Text := 'main_sel_dblisttemplate :Id_Template';
  qrQuery.Params.ParamValues['Id_Template'] := aId_Template;
  try
    qrQuery.Open();
    qrQuery.First();
    tblDBCommited.BeginUpdate();
    try
      tblDBCommited.DataController.RecordCount := qrQuery.RecordCount;
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        tblDBCommited.DataController.Values[k, 0] := qrQuery.FieldByName('Server').AsString;
        tblDBCommited.DataController.Values[k, 1] := qrQuery.FieldByName('DataBase').AsString;
        tblDBCommited.DataController.Values[k, 2] := False;
        tblDBCommited.DataController.Values[k, 3] := False;

        FDConnectionIsCommited.ConnectionString := Format(STR_CONNECTION, [qrQuery.FieldByName('Server').AsString,
          qrQuery.FieldByName('DataBase').AsString]);
        try
          FDConnectionIsCommited.Connected := True;
          qrQueryIsCommited.SQL.Text := 'SELECT [Index] FROM DBRevision WHERE Id_Template = :Id_Template AND [Index] = :Index';
          qrQueryIsCommited.Params.ParamValues['Id_Template'] := aId_Template;
          qrQueryIsCommited.Params.ParamValues['Index'] := aIndex;
          try
            qrQueryIsCommited.Open();
            tblDBCommited.DataController.Values[k, 2] := qrQueryIsCommited.RecordCount = 1;
          finally
            qrQueryIsCommited.Close();
          end;
          tblDBCommited.DataController.Values[k, 3] := True;
          FDConnectionIsCommited.Connected := False;
        except
        begin
          tblDBCommited.DataController.Values[k, 2] := False;
          tblDBCommited.DataController.Values[k, 3] := False;
          FDConnectionIsCommited.Connected := False;
        end;
        end;
        qrQuery.Next();
      end;
    finally
      tblDBCommited.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmMain.RefreshDataBaseList(aId_Profile: Integer; aId_CurrentIndex: Integer);
var
  k: Integer;
  DataBase: IDataBase;
begin
  ClearDataBaseList();
  qrQuery.SQL.Text := 'main_sel_dblist :Id_Profile';
  qrQuery.Params.ParamValues['Id_Profile'] := aId_Profile;
  try
    qrQuery.Open();
    qrQuery.First();
    cmbDBList.Items.BeginUpdate();
    try
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        DataBase := TDataBase.Create();
        DataBase.Id_DataBase := qrQuery.FieldByName('Id_DataBase').AsInteger;
        DataBase.Server := qrQuery.FieldByName('Server').AsString;
        DataBase.DataBase := qrQuery.FieldByName('DataBase').AsString;
        DataBase.Id_Template := qrQuery.FieldByName('Id_Template').AsInteger;
        DataBase._AddRef();
        cmbDBList.Items.AddObject(Format('%s - %s', [qrQuery.FieldByName('Server').AsString, qrQuery.FieldByName('DataBase').AsString]),
          TObject(Integer(DataBase)));
        DataBase := nil;
        qrQuery.Next();
      end;
    finally
      cmbDBList.Items.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
  cmbDBList.ItemIndex := aId_CurrentIndex;
end;

procedure TfrmMain.RefreshIsCommited;
begin
  FDConnectionIsCommited.ConnectionString := Format(STR_CONNECTION, [IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).Server,
    IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).DataBase]);
  FDConnectionIsCommited.Connected := True;
  CheckDBRevision(qrQueryIsCommited);
  qrQueryIsCommited.SQL.Text := 'SELECT [Index], Id_Template FROM DBRevision';
  qrQueryIsCommited.Open();
end;

procedure TfrmMain.RefreshProfile;
var
  k: Integer;
begin
  qrQuery.SQL.Text := 'main_sel_profilelist';
  try
    qrQuery.Open();
    qrQuery.First();
    cmbProfile.Items.BeginUpdate();
    try
      cmbProfile.Items.Clear();
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        cmbProfile.Items.AddObject(qrQuery.FieldByName('Name').AsString,
          TObject(qrQuery.FieldByName('Id_Profile').AsInteger));
        qrQuery.Next();
      end;
    finally
      cmbProfile.Items.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
  cmbProfile.ItemIndex := -1;
end;

procedure TfrmMain.RefreshSelected(aIsUp: Boolean);
var
  k: Integer;
begin
  if aIsUp then
  begin
    for k := 0 to tblSQLScript.Controller.SelectedRecordCount - 1 do
      tblSQLScript.ViewData.Records[tblSQLScript.Controller.SelectedRecords[k].Index - 1].Selected := True;
    tblSQLScript.ViewData.Records[tblSQLScript.Controller.SelectedRecords[tblSQLScript.Controller.SelectedRecordCount - 1].Index].Selected := False;
  end
  else
  begin
    for k := 0 to tblSQLScript.Controller.SelectedRecordCount - 1 do
      tblSQLScript.ViewData.Records[tblSQLScript.Controller.SelectedRecords[k].Index + 1].Selected := True;
    tblSQLScript.ViewData.Records[tblSQLScript.Controller.SelectedRecords[0].Index].Selected := False;
  end;
end;

procedure TfrmMain.RefreshSQLScriptList(aFocusedId: Integer);
var
  k: Integer;
  FocusedIndex: Integer;
begin
  try
    FocusedIndex := -1;
    RefreshIsCommited();
    tblSQLScript.BeginUpdate();
    try
      qrQuery.SQL.Text := 'main_sel_sqlscriptlist :Id_Template, :Server, :DataBase';
      qrQuery.Params.ParamValues['Id_Template'] := Id_Template;
      qrQuery.Params.ParamValues['Server'] := IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).Server;
      qrQuery.Params.ParamValues['DataBase'] := IDataBase(Integer(cmbDBList.Items.Objects[cmbDBList.ItemIndex])).DataBase;
      try
        qrQuery.Open();
        qrQuery.First();
        tblSQLScript.DataController.RecordCount := qrQuery.RecordCount;
        for k := 0 to qrQuery.RecordCount - 1 do
        begin
          tblSQLScript.DataController.Values[k, COL_SQLSCRIPT_ID_SQLSCRIPT] := qrQuery.FieldByName('Id_SQLScript').AsInteger;
          tblSQLScript.DataController.Values[k, COL_SQLSCRIPT_INDEX] := qrQuery.FieldByName('Index').AsInteger;
          tblSQLScript.DataController.Values[k, COL_SQLSCRIPT_ID_STATUS] := qrQuery.FieldByName('Id_Status').AsInteger;
          tblSQLScript.DataController.Values[k, COL_SQLSCRIPT_LABEL] := qrQuery.FieldByName('Label').AsString;
          tblSQLScript.DataController.Values[k, COL_SQLSCRIPT_REVISION] := qrQuery.FieldByName('Revision').AsString;
          tblSQLScript.DataController.Values[k, COL_SQLSCRIPT_NAME] := qrQuery.FieldByName('Name').AsString;
          tblSQLScript.DataController.Values[k, COL_SQLSCRIPT_CREATEUSER] := qrQuery.FieldByName('CreateUser').AsString;
          tblSQLScript.DataController.Values[k, COL_SQLSCRIPT_CREATEDATE] := FormatDateTime('yyyy-mm-dd hh:nn:ss', qrQuery.FieldByName('CreateDate').AsDateTime);
          tblSQLScript.DataController.Values[k, COL_SQLSCRIPT_CHANGEUSER] := qrQuery.FieldByName('ChangeUser').AsString;
          tblSQLScript.DataController.Values[k, COL_SQLSCRIPT_CHANGEDATE] := FormatDateTime('yyyy-mm-dd hh:nn:ss', qrQuery.FieldByName('ChangeDate').AsDateTime);
          tblSQLScript.DataController.Values[k, COL_SQLSCRIPT_IS_COMMIT] :=
            qrQueryIsCommited.Locate('Index;Id_Template', VarArrayOf([qrQuery.FieldByName('Index').AsInteger, Id_Template]), []);
          tblSQLScript.DataController.Values[k, COL_SQLSCRIPT_ORDER] := qrQuery.FieldByName('Order').AsInteger;
          tblSQLScript.DataController.Values[k, COL_SQLSCRIPT_FIND] := 0;
          if qrQuery.FieldByName('Id_SQLScript').AsInteger = aFocusedId then
            FocusedIndex := k;
          qrQuery.Next();
        end;
      finally
        qrQuery.Close();
      end;
    finally
      tblSQLScript.EndUpdate();
    end;
  finally
    qrQueryIsCommited.Close();
    FDConnectionIsCommited.Connected := False;
  end;
  if aFocusedId > -1 then
    tblSQLScript.Controller.FocusRecord(tblSQLScript.DataController.GetRowIndexByRecordIndex(FocusedIndex, False), True);
  if tblSQLScript.Controller.FocusedRecordIndex > -1 then
    LoadBody(tblSQLScript.Controller.FocusedRecord.Values[COL_SQLSCRIPT_ID_SQLSCRIPT]);
  if pnlDBCommited.Visible then
    if tblSQLScript.Controller.FocusedRecordIndex > -1 then
      RefreshDataBaseCommited(Id_Template, tblSQLScript.Controller.FocusedRecord.Values[COL_SQLSCRIPT_INDEX]);
end;

procedure TfrmMain.RefreshTemplateList(aId_Template: Integer);
var
  k: Integer;
begin
  cmbTemplateList.Items.Clear();
  qrQuery.SQL.Text := 'main_sel_templatelist';
  try
    qrQuery.Open();
    qrQuery.First();
    cmbTemplateList.Items.BeginUpdate();
    try
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        cmbTemplateList.Items.AddObject(qrQuery.FieldByName('Name').AsString,
          TObject(qrQuery.FieldByName('Id_Template').AsInteger));
        qrQuery.Next();
      end;
    finally
      cmbTemplateList.Items.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
  cmbTemplateList.ItemIndex := cmbTemplateList.Items.IndexOfObject(TObject(aId_Template));
end;

procedure TfrmMain.RegisterCompare;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create();
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly('Software\Scooter Software\Beyond Compare\') then
      FComparePath := Reg.ReadString('ExePath');
    if SameText(FComparePath, '') then
    begin
      Reg.CloseKey();
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKeyReadOnly('SOFTWARE\Wow6432Node\Scooter Software\Beyond Compare\') then
        FComparePath := Reg.ReadString('ExePath');
      if SameText(FComparePath, '') then
      begin
        Reg.CloseKey();
        if Reg.OpenKeyReadOnly('SOFTWARE\Wow6432Node\Scooter Software\Beyond Compare 3\') then
          FComparePath := Reg.ReadString('ExePath');
      end;
    end;
  finally
    Reg.CloseKey();
    Reg.Free();
  end;
end;

procedure TfrmMain.SetEnableBody;
begin
  if IsEditable() then
    EnableBody()
  else
    DisableBody();
end;

procedure TfrmMain.SetSynMemoMaxScroll(aSynMemo: TSynMemo);

  function GetMaxRow(aList: TStrings): Integer;
  var
    k: Integer;
  begin
    if aList.Count = 0 then
      Exit(0);
    Result := Length(aList[0]);
    for k := 1 to aList.Count - 1 do
      if Result < Length(aList[k]) then
        Result := Length(aList[k]);
  end;

begin
  aSynMemo.MaxScrollWidth := GetMaxRow(aSynMemo.Lines) + 1;
end;

procedure TfrmMain.SynMemoCommitChange(Sender: TObject);
begin
  FIsEdit := True;
  SetSynMemoMaxScroll(Sender as TSynMemo);
end;

procedure TfrmMain.SynMemoCommitEnter(Sender: TObject);
begin
  FLastActiveSynMemo := Sender as TSynMemo;
end;

procedure TfrmMain.SynMemoCommitExit(Sender: TObject);
begin
  if (FIsEdit) and (not SynMemoRollback.Focused) then
    if Application.MessageBox('Скрипт изменился. Вы уверены, что хотите продолжить?', 'Вопрос', MB_YESNO or MB_ICONQUESTION)= ID_NO then
      (Sender as TSynEdit).SetFocus()
    else
      FIsEdit := False;
end;

procedure TfrmMain.SynMemoCommitKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift = [ssCtrl] then
    if Key = 70 then
      fdBody.Execute();
end;

procedure TfrmMain.SynMemoRollbackChange(Sender: TObject);
begin
  FIsEdit := True;
  SetSynMemoMaxScroll(Sender as TSynMemo);
end;

procedure TfrmMain.SynMemoRollbackEnter(Sender: TObject);
begin
  FLastActiveSynMemo := Sender as TSynMemo;
end;

procedure TfrmMain.SynMemoRollbackExit(Sender: TObject);
begin
  if (FIsEdit) and (not SynMemoCommit.Focused) then
    if Application.MessageBox('Скрипт изменился. Вы уверены, что хотите продолжить?', 'Вопрос', MB_YESNO or MB_ICONQUESTION)= ID_NO then
      (Sender as TSynEdit).SetFocus()
    else
      FIsEdit := False;
end;

procedure TfrmMain.SynMemoRollbackKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift = [ssCtrl] then
    if Key = 70 then
      fdBody.Execute();
end;

procedure TfrmMain.tblDBCommitedStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  if Boolean(ARecord.Values[2]) then
    AStyle := stlGreen
  else
    if not Boolean(ARecord.Values[3]) then
      AStyle := stlRed;
end;

procedure TfrmMain.tblSQLScriptDataControllerDataChanged(Sender: TObject);
begin
  if (Sender as TcxGridDataController).RecordCount = 0 then
  begin
    ClearBody();
    DisableBody();
  end;
end;

procedure TfrmMain.tblSQLScriptFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if Assigned(AFocusedRecord) then
  begin
    LoadBody(AFocusedRecord.Values[COL_SQLSCRIPT_ID_SQLSCRIPT]);
    if pnlDBCommited.Visible then
      RefreshDataBaseCommited(Id_Template, AFocusedRecord.Values[COL_SQLSCRIPT_INDEX]);
  end;
end;

procedure TfrmMain.tblSQLScriptSelectionChanged(Sender: TcxCustomGridTableView);
begin
  SetEnableBody();
end;

procedure TfrmMain.tblSQLScriptStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  if ARecord.Values[COL_SQLSCRIPT_FIND] = 1 then
    AStyle := stlYellow
  else
    if ARecord.Values[COL_SQLSCRIPT_IS_COMMIT] then
      AStyle := stlGreen;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
