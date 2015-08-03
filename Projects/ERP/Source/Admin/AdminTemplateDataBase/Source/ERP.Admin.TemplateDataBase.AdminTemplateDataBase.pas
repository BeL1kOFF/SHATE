unit ERP.Admin.TemplateDataBase.AdminTemplateDataBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxCheckBox, Vcl.ActnList, dxBar, cxClasses, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridCustomView, cxGrid, Data.DB,
  cxNavigator, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Actions, ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;

type
  TfrmAdminTemplateDataBase = class(TERPCustomForm)
    cxGrid: TcxGrid;
    tblTemplate: TcxGridTableView;
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
    colIdTemplateDataBase: TcxGridColumn;
    colName: TcxGridColumn;
    colTypeDB: TcxGridColumn;
    qrQuery: TFDQuery;
    colVisible: TcxGridColumn;
    ttDelTemplateDataBase: TsmFireDACTempTable;
    procedure FormShow(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure tblTemplateCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
  private
    procedure DeleteRecords;
    procedure RefreshData;
    procedure ShowChild(aId_TemplateDataBase: Integer);
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
{$R Resource\Icon.RES}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  ERP.Admin.TemplateDataBase.AdminTemplateDataBaseDetail;

resourcestring
  rsDelete               = 'Удаление';
  rsDeleteConfirm        = 'Вы уверенны, что хотите удалить выделенные записи?';

const
  MODULE_NAME            = 'Шаблоны баз данных';
  MODULE_GUID: TGUID     = '{A43D9DD7-C5D3-4814-BD15-263CC537EA2B}';
  MODULE_TYPEDB          = 1;

  PROC_ADM_TDB_DEL_ITEM  = 'adm_tdb_del_item';
  PROC_ADM_TDB_SEL_ITEMLIST = 'adm_tdb_sel_itemlist';

  FLD_ID_TEMPLATEDATABASE = 'Id_TemplateDataBase';
  FLD_NAME = 'Name';
  FLD_TYPEDB = 'TypeDB';
  FLD_VISIBLE = 'Visible';

  COL_ID_TEMPLATEDATABASE = 0;
  COL_NAME = 1;
  COL_TYPEDB = 2;
  COL_VISIBLE = 3;

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmAdminTemplateDataBase;
begin
  frmForm := TfrmAdminTemplateDataBase.Create(aERPClientData);
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

{ TfrmAdminTemplateDataBase }

procedure TfrmAdminTemplateDataBase.acAddExecute(Sender: TObject);
begin
  ShowChild(-1);
  RefreshData();
end;

procedure TfrmAdminTemplateDataBase.acDeleteExecute(Sender: TObject);
begin
 if Application.MessageBox(PChar(rsDeleteConfirm), PChar(rsDelete), MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    DeleteRecords();
    RefreshData();
  end;
end;

procedure TfrmAdminTemplateDataBase.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblTemplate.Controller.SelectedRecordCount > 0;
end;

procedure TfrmAdminTemplateDataBase.acEditExecute(Sender: TObject);
begin
  ShowChild(tblTemplate.Controller.FocusedRecord.Values[COL_ID_TEMPLATEDATABASE]);
  RefreshData();
end;

procedure TfrmAdminTemplateDataBase.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblTemplate.Controller.SelectedRecordCount = 1;
end;

procedure TfrmAdminTemplateDataBase.acRefreshExecute(Sender: TObject);
begin
  RefreshData();
end;

constructor TfrmAdminTemplateDataBase.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);
  acAdd.ImageIndex := IL_ADD;
  acEdit.ImageIndex := IL_EDIT;
  acDelete.ImageIndex := IL_DELETE;
  acRefresh.ImageIndex := IL_REFRESH;
  dxBarManager.ImageOptions.LargeImages := GDDM.ilGlobal32;
  qrQuery.Connection := FDConnection;
  ttDelTemplateDataBase.Connection := FDConnection;
end;

procedure TfrmAdminTemplateDataBase.DeleteRecords;
var
  k: Integer;
begin
  CreateSQLCursor();
  ttDelTemplateDataBase.CreateTempTable();
  try
    for k := 0 to tblTemplate.Controller.SelectedRecordCount - 1 do
      ttDelTemplateDataBase.InsertTempTable([TFieldValue.Create('Id_TemplateDataBase', tblTemplate.Controller.SelectedRecords[k].Values[COL_ID_TEMPLATEDATABASE])]);
    TERPQueryHelp.Open(FDConnection, PROC_ADM_TDB_DEL_ITEM, []);
  finally
    ttDelTemplateDataBase.DropTempTable();
  end;
end;

procedure TfrmAdminTemplateDataBase.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAdminTemplateDataBase.RefreshData;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := PROC_ADM_TDB_SEL_ITEMLIST;
  try
    qrQuery.Open();
    tblTemplate.BeginUpdate();
    try
      tblTemplate.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to tblTemplate.DataController.RecordCount - 1 do
      begin
        tblTemplate.DataController.Values[k, COL_ID_TEMPLATEDATABASE] := qrQuery.FieldByName(FLD_ID_TEMPLATEDATABASE).AsInteger;
        tblTemplate.DataController.Values[k, COL_NAME] := qrQuery.FieldByName(FLD_NAME).AsString;
        tblTemplate.DataController.Values[k, COL_TYPEDB] := qrQuery.FieldByName(FLD_TYPEDB).AsInteger;
        tblTemplate.DataController.Values[k, COL_VISIBLE] := qrQuery.FieldByName(FLD_VISIBLE).AsBoolean;
        qrQuery.Next();
      end;
    finally
      tblTemplate.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminTemplateDataBase.ShowChild(aId_TemplateDataBase: Integer);
var
  frmAdminTemplateDataBaseDetail: TfrmAdminTemplateDataBaseDetail;
begin
  frmAdminTemplateDataBaseDetail := TfrmAdminTemplateDataBaseDetail.Create(aId_TemplateDataBase, FDConnection, Self);
  try
    frmAdminTemplateDataBaseDetail.ShowModal();
  finally
    frmAdminTemplateDataBaseDetail.Free();
  end;
  RefreshData();
end;

procedure TfrmAdminTemplateDataBase.tblTemplateCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnEdit.Click();
end;

end.
