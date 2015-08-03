unit CategoryTaskForm;

interface

uses
  Vcl.Forms,
  ERP.Package.CustomForm.TERPCustomForm, System.Classes, Vcl.Controls, Vcl.StdCtrls, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxRibbonSkins, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxClasses, cxGridLevel, cxGrid, dxRibbon, dxBar, Vcl.ImgList,
  Vcl.ActnList, Data.DB, System.SysUtils, ERP.Package.ClientInterface.IERPClientData, ERP.Package.ClientInterface.IModuleInfo,
  System.Generics.Collections, cxNavigator, System.Actions, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmCategoryTask = class(TERPCustomForm)
    dxBarManager: TdxBarManager;
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    cxTable: TcxGridTableView;
    dxBarManagerBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    cxImageList: TcxImageList;
    ActionList: TActionList;
    acNew: TAction;
    acEdit: TAction;
    acDelete: TAction;
    colName: TcxGridColumn;
    colId: TcxGridColumn;
    dxBarManagerBar2: TdxBar;
    dxBarLargeButton4: TdxBarLargeButton;
    acRefresh: TAction;
    qrQuery: TFDQuery;
    procedure FormShow(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acNewExecute(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
  private
    procedure DeleteRecords;
    procedure Refresh;
    procedure ShowChild(aId_CategoryTask: Integer);
  public
    constructor Create(aERPClientData: IERPClientData); reintroduce;
  end;

function GetIcon(aSize: Integer): THandle; stdcall;
procedure SetModuleInfo(aModuleInfo: IModuleInfo); stdcall;
function CreateForm(aERPClientData: IERPClientData): THandle; stdcall;
procedure RegisterAccess(out aAccess: TList<Variant>);

exports CreateForm;
exports GetIcon;
exports SetModuleInfo;
exports RegisterAccess;

implementation

{$R *.dfm}
{$R Resource\Icon.RES}

uses
  Winapi.Windows,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.CustomForm.UserFunctions,
  CategoryTaskFormDetail;

resourcestring
  rsDelete               = 'Удаление';
  rsDeleteConfirm        = 'Вы уверенны, что хотите удалить выделенные записи?';

const
  MODULE_NAME            = 'Категории';
  MODULE_BAR             = 'Задачи';
  MODULE_PAGE            = 'Задачи';
  MODULE_GUID: TGUID     = '{48C319E4-ED0F-46B0-B7ED-21FD0CF986A7}';
  MODULE_TYPEDB          = 2;

  PROC_CLNT_CT_DEL_ITEM  = 'clnt_ct_del_item';
  PROC_CLNT_CT_SEL_ITEMS = 'clnt_ct_sel_items';

  TBL_TEMP               = 'tmpDelCategory';
  COLUMN_ID_CATEGORYTASK = 'Id_CategoryTask INT';

  FLD_ID_CATEGORYTASK    = 'Id_CategoryTask';
  FLD_NAME               = 'Name';

  COL_ID_CATEGORYTASK    = 0;
  COL_NAME               = 1;

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frm: TfrmCategoryTask;
begin
  frm := TfrmCategoryTask.Create(aERPClientData);
  Result := frm.Handle;
end;

function GetIcon(aSize: Integer): THandle;
begin
  case aSize of
  16:
    Result := LoadIcon(HInstance, PChar(Format('%s%d', [TfrmCategoryTask.ClassName, 16])));
  32:
    Result := LoadIcon(HInstance, PChar(Format('%s%d', [TfrmCategoryTask.ClassName, 32])));
  else
    Result := 0;
  end;
end;

procedure SetModuleInfo(aModuleInfo: IModuleInfo);
begin
  aModuleInfo.GUID := MODULE_GUID;
  aModuleInfo.Name := MODULE_NAME;
  aModuleInfo.PageName := MODULE_PAGE;
  aModuleInfo.BarName := MODULE_BAR;
  aModuleInfo.TypeDB := MODULE_TYPEDB;
  aModuleInfo.TypeGuid := TYPEMODULE_MODULES;
end;

procedure RegisterAccess(out aAccess: TList<Variant>);
begin

end;

{ TfrmCategoryTask }

procedure TfrmCategoryTask.acDeleteExecute(Sender: TObject);
begin
  if Application.MessageBox(PChar(rsDeleteConfirm), PChar(rsDelete), MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    DeleteRecords;
    Refresh();
  end;
end;

procedure TfrmCategoryTask.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.Controller.SelectedRecordCount > 0;
end;

procedure TfrmCategoryTask.acEditExecute(Sender: TObject);
begin
  ShowChild(cxTable.Controller.FocusedRecord.Values[COL_ID_CATEGORYTASK]);
end;

procedure TfrmCategoryTask.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.Controller.FocusedRecordIndex > -1;
end;

procedure TfrmCategoryTask.acNewExecute(Sender: TObject);
begin
  ShowChild(-1);
end;

procedure TfrmCategoryTask.acRefreshExecute(Sender: TObject);
begin
  Refresh();
end;

constructor TfrmCategoryTask.Create(aERPClientData: IERPClientData);
begin
  inherited Create('Категории заданий', aERPClientData);
  qrQuery.Connection := FDConnection;
end;

procedure TfrmCategoryTask.DeleteRecords;
var
  k: Integer;
  ResultText: string;
  ResultCode: Integer;
begin
  CreateSQLCursor();
  qrQuery.Close();
  ERPCreateTempTable(FDConnection, TBL_TEMP, [COLUMN_ID_CATEGORYTASK]);
  try
    for k := 0 to cxTable.Controller.SelectedRecordCount - 1 do
      ERPInsertTempTable(FDConnection, TBL_TEMP, [cxTable.Controller.SelectedRecords[k].Values[COL_ID_CATEGORYTASK]]);
    qrQuery.SQL.Text := PROC_CLNT_CT_DEL_ITEM;
    try
      qrQuery.Open();
      ResultCode := qrQuery.Fields.Fields[0].AsInteger;
      ResultText := qrQuery.Fields.Fields[1].AsString;
    except on E: Exception do
    begin
      ResultCode := -1000;
      ResultText := E.Message;
    end;
    end;
    qrQuery.Close();
  finally
    ERPDropTempTable(FDConnection, TBL_TEMP);
  end;
  if ResultCode = 0 then
    ShowMessage(ResultText)
  else
    ShowError(ResultText);
end;

procedure TfrmCategoryTask.FormShow(Sender: TObject);
begin
  Refresh();
end;

procedure TfrmCategoryTask.Refresh;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.Close();
  qrQuery.SQL.Text := PROC_CLNT_CT_SEL_ITEMS;
  try
    cxTable.BeginUpdate();
    qrQuery.Open();
    cxTable.DataController.RecordCount := qrQuery.RecordCount;
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cxTable.DataController.Values[k, COL_ID_CATEGORYTASK] := qrQuery.FieldByName(FLD_ID_CATEGORYTASK).AsInteger;
      cxTable.DataController.Values[k, COL_NAME] := qrQuery.FieldByName(FLD_NAME).AsString;
      qrQuery.Next();
    end;
  finally
    cxTable.EndUpdate();
    qrQuery.Close();
  end;
end;

procedure TfrmCategoryTask.ShowChild(aId_CategoryTask: Integer);
var
  frmCategoryTaskDetail: TfrmCategoryTaskDetail;
begin
  frmCategoryTaskDetail := TfrmCategoryTaskDetail.Create(aId_CategoryTask, qrQuery.Connection as TFDConnection, Self);
  try
    frmCategoryTaskDetail.ShowModal();
  finally
    frmCategoryTaskDetail.Free();
  end;
  Refresh();
end;

end.
