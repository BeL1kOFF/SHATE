unit ERP.Admin.UI.AccessGroup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess, System.Actions, Vcl.ActnList,
  dxBar, cxClasses, Vcl.StdCtrls, Vcl.Buttons, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, cxCheckBox, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridCustomView, cxGrid,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.ImgList, ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;

type
  TfrmAccessGroup = class(TERPCustomForm)
    ActionList: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    acRefresh: TAction;
    acShowDB: TAction;
    acShowUsers: TAction;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    btnEdit: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    dxBarLargeButton5: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    cxGrid: TcxGrid;
    tblAccessGroup: TcxGridTableView;
    colGroupName: TcxGridColumn;
    colEnabled: TcxGridColumn;
    cxGridLevel: TcxGridLevel;
    colGroupDescr: TcxGridColumn;
    qrQuery: TFDQuery;
    colIDGroup: TcxGridColumn;
    ImageList: TcxImageList;
    dxBarLargeButton6: TdxBarLargeButton;
    acData: TAction;
    ttAccessGroup: TsmFireDACTempTable;
    procedure acEditExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acShowDBExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acShowDBUpdate(Sender: TObject);
    procedure acShowUserUpdate(Sender: TObject);
    procedure acShowUsersExecute(Sender: TObject);
    procedure AssignToolBarImages();
    procedure tblAccessGroupCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure acDataUpdate(Sender: TObject);
    procedure acDataExecute(Sender: TObject);
  private
    procedure RefreshData;
    procedure DeleteRecords;
    procedure ShowChild(aFormClass: TFormClass; aId_AccessGroup: Integer);
  public
    constructor Create(aERPClientData: IERPClientData); reintroduce;
  end;

const
  MODULE_GUID: TGUID     = '{A2BFF852-B943-4275-AD9B-8E6B65D99CC0}';

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
  ERP.Package.CustomClasses.Consts,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  ERP.Admin.UI.AccessGroupDetail,
  ERP.Admin.UI.CrossAccessGroupDataBase,
  ERP.Admin.UI.CrossAccessGroupUser,
  ERP.Admin.UI.AccessData;

const
  MODULE_NAME            = 'Группы доступа';
  MODULE_TYPEDB          = 1;

  PROC_ADM_AG_SEL_ITEMLIST = 'adm_ag_sel_itemlist';
  PROC_ADM_AG_DEL_ITEM     = 'adm_ag_del_item';

  FLD_ID_ACCESS_GROUP = 'Id_AccessGroup';
  FLD_NAME = 'Name';
  FLD_DESCRIPTION = 'Description';
  FLD_ACCESS = 'Enabled';

  COL_ID_ACCESS_GROUP = 0;
  COL_NAME = 1;
  COL_DESCRIPTION = 2;
  COL_ACCESS = 3;

resourcestring
  rsDelete         = 'Удаление';
  rsDeleteConfirm  = 'Вы уверенны, что хотите удалить выделенные записи?';

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmAccessGroup;
begin
  frmForm := TfrmAccessGroup.Create(aERPClientData);
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


{ TForm0 }

procedure TfrmAccessGroup.acAddExecute(Sender: TObject);
begin
  ShowChild(TfrmAccessGroupDetail, -1);
  RefreshData();
end;

procedure TfrmAccessGroup.acDataExecute(Sender: TObject);
begin
  ShowChild(TfrmAccessData, tblAccessGroup.Controller.FocusedRecord.Values[COL_ID_ACCESS_GROUP]);
end;

procedure TfrmAccessGroup.acDataUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblAccessGroup.Controller.SelectedRecordCount = 1;
end;

procedure TfrmAccessGroup.acDeleteExecute(Sender: TObject);
begin
 if Application.MessageBox(PChar(rsDeleteConfirm), PChar(rsDelete), MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    DeleteRecords();
    RefreshData();
  end;
end;

procedure TfrmAccessGroup.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblAccessGroup.Controller.SelectedRecordCount > 0);
end;

procedure TfrmAccessGroup.acEditExecute(Sender: TObject);
begin
  ShowChild(TfrmAccessGroupDetail, tblAccessGroup.Controller.FocusedRecord.Values[COL_ID_ACCESS_GROUP]);
  RefreshData();
end;

procedure TfrmAccessGroup.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblAccessGroup.Controller.SelectedRecordCount = 1;
end;

procedure TfrmAccessGroup.acRefreshExecute(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAccessGroup.acShowDBExecute(Sender: TObject);
begin
  ShowChild(TfrmAccessGroupDatabase, tblAccessGroup.Controller.FocusedRecord.Values[COL_ID_ACCESS_GROUP]);
end;

procedure TfrmAccessGroup.acShowDBUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblAccessGroup.Controller.SelectedRecordCount = 1;
end;

procedure TfrmAccessGroup.acShowUsersExecute(Sender: TObject);
begin
  ShowChild(TfrmCrossAccessGroupUser, tblAccessGroup.Controller.FocusedRecord.Values[COL_ID_ACCESS_GROUP]);
end;

procedure TfrmAccessGroup.acShowUserUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblAccessGroup.Controller.SelectedRecordCount = 1;
end;

procedure TfrmAccessGroup.AssignToolBarImages;
  function CopyIL(aIndex: Integer): Integer;
  var
    Icon: TIcon;
  begin
    Icon := TIcon.Create();
    try
      GDDM.ilGlobal32.GetIcon(aIndex, Icon);
      Result := ImageList.AddIcon(Icon);
    finally
      Icon.Free();
    end;
  end;

begin
  acAdd.ImageIndex := CopyIL(IL_ADD);
  acEdit.ImageIndex := CopyIL(IL_EDIT);
  acDelete.ImageIndex := CopyIL(IL_DELETE);
  acRefresh.ImageIndex := CopyIL(IL_REFRESH);
  acShowUsers.ImageIndex := 0;
  acShowDB.ImageIndex := 1;
  acData.ImageIndex := 2;
  dxBarManager.LargeImages := ImageList;
end;

constructor TfrmAccessGroup.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);
  qrQuery.Connection := FDConnection;
  ttAccessGroup.Connection := FDConnection;
  AssignToolBarImages();
end;

procedure TfrmAccessGroup.DeleteRecords;
var
  k: integer;
begin
  CreateSQLCursor();
  ttAccessGroup.CreateTempTable();
  try
    for k := 0 to tblAccessGroup.Controller.SelectedRecordCount - 1 do
      ttAccessGroup.InsertTempTable([TFieldValue.Create('Id_AccessGroup', tblAccessGroup.Controller.SelectedRecords[k].Values[COL_ID_ACCESS_GROUP])]);
    TERPQueryHelp.Open(FDConnection, PROC_ADM_AG_DEL_ITEM, []);
  finally
    ttAccessGroup.DropTempTable();
  end;
end;

procedure TfrmAccessGroup.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAccessGroup.RefreshData;
var
  k:integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := PROC_ADM_AG_SEL_ITEMLIST;
  try
    qrQuery.Open();
    tblAccessGroup.DataController.BeginUpdate;
    try
      tblAccessGroup.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to tblAccessGroup.DataController.RecordCount - 1 do
      begin
        tblAccessGroup.DataController.Values[k, COL_ID_ACCESS_GROUP] := qrQuery.FieldByName(FLD_ID_ACCESS_GROUP).AsInteger;
        tblAccessGroup.DataController.Values[k, COL_NAME] := qrQuery.FieldByName(FLD_NAME).AsString;
        tblAccessGroup.DataController.Values[k, COL_DESCRIPTION] := qrQuery.FieldByName(FLD_DESCRIPTION).AsString;
        tblAccessGroup.DataController.Values[k, COL_ACCESS] := qrQuery.FieldByName(FLD_ACCESS).AsString;
        qrQuery.Next();
      end;
    finally
      tblAccessGroup.DataController.EndUpdate;
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAccessGroup.ShowChild(aFormClass: TFormClass; aId_AccessGroup: Integer);
var
  frmChild: TForm;
begin
  if aFormClass = TfrmAccessGroupDetail then
    frmChild := TfrmAccessGroupDetail.Create(aId_AccessGroup, FDConnection, Self)
  else
    if aFormClass = TfrmAccessGroupDatabase then
      frmChild := TfrmAccessGroupDatabase.Create(aId_AccessGroup, FDConnection, Self)
    else
      if aFormClass = TfrmCrossAccessGroupUser then
        frmChild := TfrmCrossAccessGroupUser.Create(aId_AccessGroup, FDConnection, Self)
      else
        frmChild := TfrmAccessData.Create(FDConnection, aId_AccessGroup, ERPClientData, Self);
  try
    frmChild.ShowModal();
  finally
    frmChild.Free();
  end;
  RefreshData();
end;

procedure TfrmAccessGroup.tblAccessGroupCellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnEdit.Click();
end;

end.
