unit PI.Modules.UI.Task;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridCustomView, cxGrid, System.Actions, Vcl.ActnList, dxBar, cxCheckBox,
  ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;

type
  TfrmTask = class(TERPCustomForm)
    dxBarManager: TdxBarManager;
    barMain: TdxBar;
    btnAdd: TdxBarLargeButton;
    btnEdit: TdxBarLargeButton;
    btnDelete: TdxBarLargeButton;
    btnRefresh: TdxBarLargeButton;
    ActionList: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    acRefresh: TAction;
    cxGrid: TcxGrid;
    tblTask: TcxGridTableView;
    cxLevel: TcxGridLevel;
    colId_Task: TcxGridColumn;
    colName: TcxGridColumn;
    colGuid: TcxGridColumn;
    colEnable: TcxGridColumn;
    colSynchronize: TcxGridColumn;
    colIsMemory: TcxGridColumn;
    ttTaskDel: TsmFireDACTempTable;
    procedure acRefreshExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure tblTaskCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
  private
    procedure AssignImage;
    procedure DeleteRecords;
    procedure RefreshData;
    procedure ShowChild(aId_Task: Integer);
  public
    constructor Create(aERPClientData: IERPClientData); reintroduce;
  end;

function CreateForm(aERPClientData: IERPClientData): THandle; stdcall;
procedure RegisterAccess(aModuleAccess: IModuleAccess); stdcall;
procedure SetModuleInfo(aModuleInfo: IModuleInfo); stdcall;

exports CreateForm;
exports RegisterAccess;
exports SetModuleInfo;

implementation

{$R *.dfm}
{$R Resource\Icon.res}

uses
  FireDAC.Comp.Client,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  PI.Modules.UI.TaskDetails;

const
  MODULE_NAME            = 'Задания';
  MODULE_GUID: TGUID     = '{F213D346-DC46-4F21-878B-21DFF4EC0FFA}';
  MODULE_TYPEDB          = TYPE_DATABASE_PI;

  COL_ID_TASK = 0;

resourcestring
  rsDelete               = 'Удаление';
  rsDeleteConfirm        = 'Вы уверенны, что хотите удалить выделенные записи?';

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmTask;
begin
  frmForm := TfrmTask.Create(aERPClientData);
  Result := frmForm.Handle;
end;

procedure SetModuleInfo(aModuleInfo: IModuleInfo);
begin
  aModuleInfo.GUID := MODULE_GUID;
  aModuleInfo.Name := MODULE_NAME;
  aModuleInfo.TypeDB := MODULE_TYPEDB;
  aModuleInfo.TypeGuid := TYPEMODULE_MODULES;
end;

procedure RegisterAccess(aModuleAccess: IModuleAccess);
begin

end;

{ TForm1 }

procedure TfrmTask.acAddExecute(Sender: TObject);
begin
  ShowChild(-1);
end;

procedure TfrmTask.acDeleteExecute(Sender: TObject);
begin
 if Application.MessageBox(PChar(rsDeleteConfirm), PChar(rsDelete), MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    DeleteRecords();
    RefreshData();
  end;
end;

procedure TfrmTask.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblTask.Controller.SelectedRecordCount > 0;
end;

procedure TfrmTask.acEditExecute(Sender: TObject);
begin
  ShowChild(tblTask.Controller.FocusedRecord.Values[COL_ID_TASK]);
end;

procedure TfrmTask.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblTask.Controller.SelectedRecordCount = 1;
end;

procedure TfrmTask.acRefreshExecute(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmTask.AssignImage;
begin
  acAdd.ImageIndex := IL_ADD;
  acEdit.ImageIndex := IL_EDIT;
  acDelete.ImageIndex := IL_DELETE;
  acRefresh.ImageIndex := IL_REFRESH;

  dxBarManager.ImageOptions.LargeImages := GDDM.ilGlobal32;
end;

constructor TfrmTask.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);

  ttTaskDel.Connection := FDConnection;

  AssignImage();
end;

procedure TfrmTask.DeleteRecords;
var
  k: Integer;
begin
  CreateSQLCursor();
  ttTaskDel.CreateTempTable();
  try
    for k := 0 to tblTask.Controller.SelectedRecordCount - 1 do
      ttTaskDel.InsertTempTable([TFieldValue.Create('Id_Task', tblTask.Controller.SelectedRecords[k].Values[COL_ID_TASK])]);
    TERPQueryHelp.Open(FDConnection, 'cln.task_item_del', []);
  finally
    ttTaskDel.DropTempTable();
  end;
end;

procedure TfrmTask.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmTask.RefreshData;
var
  Query: TFDQuery;
  k: Integer;
begin
  CreateSQLCursor();
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FDConnection;
    Query.SQL.Text := 'cln.task_itemlist_sel';
    Query.Open();
    Query.First();
    tblTask.DataController.RecordCount := Query.RecordCount;
    for k := 0 to Query.RecordCount - 1 do
    begin
      tblTask.DataController.Values[k, COL_ID_TASK] := Query.FieldByName('Id_Task').AsInteger;
      tblTask.DataController.Values[k, 1] := Query.FieldByName('Name').AsString;
      tblTask.DataController.Values[k, 2] := Query.FieldByName('Guid').AsString;
      tblTask.DataController.Values[k, 3] := Query.FieldByName('Enable').AsBoolean;
      tblTask.DataController.Values[k, 4] := Query.FieldByName('Synchronize').AsBoolean;
      tblTask.DataController.Values[k, 5] := Query.FieldByName('IsMemory').AsBoolean;
      Query.Next();
    end;
  finally
    Query.Free();
  end;
end;

procedure TfrmTask.ShowChild(aId_Task: Integer);
var
  frmTaskDetail: TfrmTaskDetail;
begin
  frmTaskDetail := TfrmTaskDetail.Create(Self, FDConnection, aId_Task);
  try
    frmTaskDetail.ShowModal();
  finally
    frmTaskDetail.Free();
  end;
  RefreshData();
end;

procedure TfrmTask.tblTaskCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnEdit.Click();
end;

end.
