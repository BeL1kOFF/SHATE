unit ERP.Admin.Module.UI.AdminModule;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, Vcl.ActnList, dxBar, cxClasses,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridCustomView, cxGrid, cxCheckBox,
  cxNavigator, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Actions, ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;

type
  TfrmAdminModule = class(TERPCustomForm)
    cxGrid: TcxGrid;
    tblModules: TcxGridTableView;
    cxGridLevel: TcxGridLevel;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    btnEdit: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    ActionList: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    acRefresh: TAction;
    colIdModule: TcxGridColumn;
    colTemplateDataBaseName: TcxGridColumn;
    colTypeModuleName: TcxGridColumn;
    colName: TcxGridColumn;
    colGUID: TcxGridColumn;
    colFileName: TcxGridColumn;
    colEnabled: TcxGridColumn;
    dxBarLargeButton3: TdxBarLargeButton;
    acAccess: TAction;
    colPath: TcxGridColumn;
    dxBarLargeButton5: TdxBarLargeButton;
    acAutoRegister: TAction;
    dxBarLargeButton6: TdxBarLargeButton;
    acReengineering: TAction;
    qrQuery: TFDQuery;
    ttDelModule: TsmFireDACTempTable;
    procedure FormShow(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure tblModulesCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure acAccessExecute(Sender: TObject);
    procedure acAccessUpdate(Sender: TObject);
    procedure acAutoRegisterExecute(Sender: TObject);
    procedure acReengineeringExecute(Sender: TObject);
  private
    procedure DeleteRecords;
    procedure RefreshData;
    procedure ShowChild(aId_Module: Integer);
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
{$R Resource\Template.res}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  ERP.Admin.Module.UI.AdminModuleDetail,
  ERP.Admin.Module.UI.AdminModuleAccess,
  ERP.Admin.Module.UI.AdminModuleAutoRegister,
  ERP.Admin.Module.UI.AdminModuleReengineering;

resourcestring
  rsDelete               = 'Удаление';
  rsDeleteConfirm        = 'Вы уверенны, что хотите удалить выделенные записи?';

const
  MODULE_NAME            = 'Модули';
  MODULE_GUID: TGUID     = '{1B707479-5FF8-4B81-9482-35CD9F8C7D77}';
  MODULE_TYPEDB          = 1;

  PROC_ADM_MDL_DEL_ITEM  = 'adm_mdl_del_item';
  PROC_ADM_MDL_SEL_ITEMLIST = 'adm_mdl_sel_itemlist';

  FLD_ID_MODULE = 'Id_Module';
  FLD_TEMPLATEDATABASENAME = 'TemplateDataBaseName';
  FLD_TYPEMODULENAME = 'TypeModuleName';
  FLD_NAME = 'Name';
  FLD_GUID = 'Guid';
  FLD_FILENAME = 'FileName';
  FLD_ENABLED = 'Enabled';
  FLD_PATH = 'Path';

  COL_ID_MODULE = 0;
  COL_TEMPLATEDATABASENAME = 1;
  COL_TYPEMODULENAME = 2;
  COL_NAME = 3;
  COL_GUID = 4;
  COL_FILENAME = 5;
  COL_ENABLED = 6;
  COL_PATH = 7;

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmAdminModule;
begin
  frmForm := TfrmAdminModule.Create(aERPClientData);
  Result := frmForm.Handle;
end;

procedure SetModuleInfo(aModuleInfo: IModuleInfo);
begin
  aModuleInfo.GUID := MODULE_GUID;
  aModuleInfo.Name := MODULE_NAME;
  aModuleInfo.TypeDB := MODULE_TYPEDB;
  aModuleInfo.TypeGuid := TYPEMODULE_ADMIN;
end;

procedure RegisterAccess(aModuleAccess: IModuleAccess);
begin
end;

{ TfrmAdminModule }

procedure TfrmAdminModule.acAccessExecute(Sender: TObject);
var
  frmAdminModuleAccess: TfrmAdminModuleAccess;
begin
  frmAdminModuleAccess := TfrmAdminModuleAccess.Create(tblModules.Controller.FocusedRecord.Values[COL_ID_MODULE],
    tblModules.Controller.FocusedRecord.Values[COL_PATH] + tblModules.Controller.FocusedRecord.Values[COL_FILENAME],
    FDConnection, Self);
  try
    frmAdminModuleAccess.ShowModal();
  finally
    frmAdminModuleAccess.Free();
  end;
end;

procedure TfrmAdminModule.acAccessUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblModules.Controller.SelectedRecordCount = 1;
end;

procedure TfrmAdminModule.acAddExecute(Sender: TObject);
begin
  ShowChild(-1);
  RefreshData();
end;

procedure TfrmAdminModule.acAutoRegisterExecute(Sender: TObject);
var
  frmAdminModuleAutoRegister: TfrmAdminModuleAutoRegister;
begin
  frmAdminModuleAutoRegister := TfrmAdminModuleAutoRegister.Create(FDConnection, Self);
  try
    frmAdminModuleAutoRegister.ShowModal();
  finally
    frmAdminModuleAutoRegister.Free();
  end;
  RefreshData();
end;

procedure TfrmAdminModule.acDeleteExecute(Sender: TObject);
begin
 if Application.MessageBox(PChar(rsDeleteConfirm), PChar(rsDelete), MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    DeleteRecords();
    RefreshData();
  end;
end;

procedure TfrmAdminModule.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblModules.Controller.SelectedRecordCount > 0;
end;

procedure TfrmAdminModule.acEditExecute(Sender: TObject);
begin
  ShowChild(tblModules.Controller.FocusedRecord.Values[COL_ID_MODULE]);
  RefreshData();
end;

procedure TfrmAdminModule.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblModules.Controller.SelectedRecordCount = 1;
end;

procedure TfrmAdminModule.acReengineeringExecute(Sender: TObject);
var
  frmAdminModuleReengineering: TfrmAdminModuleReengineering;
begin
  frmAdminModuleReengineering := TfrmAdminModuleReengineering.Create(Self, FDConnection);
  try
    frmAdminModuleReengineering.ShowModal();
  finally
    frmAdminModuleReengineering.Free();
  end;
end;

procedure TfrmAdminModule.acRefreshExecute(Sender: TObject);
begin
  RefreshData();
end;

constructor TfrmAdminModule.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);
  qrQuery.Connection := FDConnection;
  ttDelModule.Connection := FDConnection;
  acAdd.ImageIndex := IL_ADD;
  acEdit.ImageIndex := IL_EDIT;
  acDelete.ImageIndex := IL_DELETE;
  acRefresh.ImageIndex := IL_REFRESH;
  acAccess.ImageIndex := IL_ACCESS;
  acAutoRegister.ImageIndex := IL_AUTOREGISTER;
  acReengineering.ImageIndex := IL_REENGINEERING;
  dxBarManager.ImageOptions.LargeImages := GDDM.ilGlobal32;
end;

procedure TfrmAdminModule.DeleteRecords;
var
  k: Integer;
begin
  CreateSQLCursor();
  ttDelModule.CreateTempTable();
  try
    for k := 0 to tblModules.Controller.SelectedRecordCount - 1 do
      ttDelModule.InsertTempTable([TFieldValue.Create('Id_Module', tblModules.Controller.SelectedRecords[k].Values[COL_ID_MODULE])]);
    TERPQueryHelp.Open(FDConnection, PROC_ADM_MDL_DEL_ITEM, []);
  finally
    ttDelModule.DropTempTable();
  end;
end;

procedure TfrmAdminModule.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAdminModule.RefreshData;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := PROC_ADM_MDL_SEL_ITEMLIST;
  try
    qrQuery.Open();
    tblModules.BeginUpdate();
    try
      tblModules.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to tblModules.DataController.RecordCount - 1 do
      begin
        tblModules.DataController.Values[k, COL_ID_MODULE] := qrQuery.FieldByName(FLD_ID_MODULE).AsInteger;
        tblModules.DataController.Values[k, COL_TEMPLATEDATABASENAME] := qrQuery.FieldByName(FLD_TEMPLATEDATABASENAME).AsString;
        tblModules.DataController.Values[k, COL_TYPEMODULENAME] := qrQuery.FieldByName(FLD_TYPEMODULENAME).AsString;
        tblModules.DataController.Values[k, COL_NAME] := qrQuery.FieldByName(FLD_NAME).AsString;
        tblModules.DataController.Values[k, COL_GUID] := qrQuery.FieldByName(FLD_GUID).AsString;
        tblModules.DataController.Values[k, COL_FILENAME] := qrQuery.FieldByName(FLD_FILENAME).AsString;
        tblModules.DataController.Values[k, COL_ENABLED] := qrQuery.FieldByName(FLD_ENABLED).AsBoolean;
        tblModules.DataController.Values[k, COL_PATH] := qrQuery.FieldByName(FLD_PATH).AsString;
        qrQuery.Next();
      end;
    finally
      tblModules.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminModule.ShowChild(aId_Module: Integer);
var
  frmAdminModuleDetail: TfrmAdminModuleDetail;
begin
  frmAdminModuleDetail := TfrmAdminModuleDetail.Create(aId_Module, FDConnection, Self);
  try
    frmAdminModuleDetail.ShowModal();
  finally
    frmAdminModuleDetail.Free();
  end;
  RefreshData();
end;

procedure TfrmAdminModule.tblModulesCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnEdit.Click();
end;

end.
