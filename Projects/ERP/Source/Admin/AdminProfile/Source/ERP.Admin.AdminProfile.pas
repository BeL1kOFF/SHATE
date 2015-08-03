unit ERP.Admin.AdminProfile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, System.Actions,
  Vcl.ActnList, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, dxBar, cxCheckBox,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.ImgList,
  ERP.Admin.Module.UI.AdminProfileCross, ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;

type

  TfrmAdminProfile = class(TERPCustomForm)
    ActionList: TActionList;
    actAdd: TAction;
    actEdit: TAction;
    actDelete: TAction;
    actRefresh: TAction;
    actModules: TAction;
    actFunctions: TAction;
    actUsers: TAction;
    dxBarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    dxBarLargeButton5: TdxBarLargeButton;
    dxBarLargeButton6: TdxBarLargeButton;
    dxBarLargeButton7: TdxBarLargeButton;
    cxGrid: TcxGrid;
    tblViewProfiles: TcxGridTableView;
    cxTblProfilesClmn1Name: TcxGridColumn;
    cxTblProfilesClmn2Description: TcxGridColumn;
    cxTblProfilesClmn3Enabled: TcxGridColumn;
    qrQuery: TFDQuery;
    cxLevel: TcxGridLevel;
    cxImageList: TcxImageList;
    cxTblProfilesClmn0ProfileID: TcxGridColumn;
    ttDelProfile: TsmFireDACTempTable;
    procedure FormShow(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actModulesExecute(Sender: TObject);
    procedure actFunctionsExecute(Sender: TObject);
    procedure actUsersExecute(Sender: TObject);
    procedure actDeleteUpdate(Sender: TObject);
    procedure actEditUpdate(Sender: TObject);
    procedure actModulesUpdate(Sender: TObject);
    procedure actFunctionsUpdate(Sender: TObject);
    procedure actUsersUpdate(Sender: TObject);
    procedure tblViewProfilesCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
  private
    { Private declarations }
    FId_Profile: integer;
    FProfileTag: string;
    procedure AssignToolBarImages;
    procedure RefreshData;
    procedure ShowChild(aId_Profile: Integer);
    procedure DeleteRecords;
    procedure RunChild(aId_Profile: integer; aChildType: TTypeChild; Caption: string);
    function GetIdProfile: integer;
    function GetProfileTag: string;
    property Id_Profile: integer read GetIdProfile;
    property ProfileTag: string read GetProfileTag;
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
  ERP.Package.CustomClasses.Consts,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  ERP.Admin.Module.UI.AdminProfileDetail;

resourcestring
  rsDelete               = 'Удаление';
  rsDeleteConfirm        = 'Вы уверены, что хотите удалить выделенные записи?';

const
  MODULE_NAME            = 'Профили';
  MODULE_GUID: TGUID     = '{94A52F7D-A835-4BA8-9228-F2B3B7BBDA00}';
  MODULE_TYPEDB          = 1;
  //--
  COL_ID_PROFILE = 0;
  COL_PROFILENAME = 1;
  COL_PROFILEDESCRIPTION = 2;
  COL_ENABLED = 3;

  FLD_ID_PROFILE = 'Id_Profile';
  FLD_PROFILENAME = 'ProfileName';
  FLD_PROFILEDESCRIPTION = 'Description';
  FLD_ENABLED = 'Enabled';

  PROC_ADM_PFL_DEL_ITEM  = 'adm_pfl_del_item';
  PROC_ADM_PFL_SEL_ITEMLIST = 'adm_pfl_sel_itemlist';

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmAdminProfile;
begin
  frmForm := TfrmAdminProfile.Create(aERPClientData);
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


{ TfrmAdminProfile }

procedure TfrmAdminProfile.actAddExecute(Sender: TObject);
begin
  ShowChild(-1);
  RefreshData();
end;

procedure TfrmAdminProfile.actDeleteExecute(Sender: TObject);
begin
 if Application.MessageBox(PChar(rsDeleteConfirm), PChar(rsDelete), MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    DeleteRecords();
    RefreshData();
  end;
end;

procedure TfrmAdminProfile.actDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblViewProfiles.Controller.SelectedRecordCount > 0);
end;

procedure TfrmAdminProfile.actEditExecute(Sender: TObject);
begin
  ShowChild(Id_Profile);
  RefreshData();
end;

procedure TfrmAdminProfile.actEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblViewProfiles.Controller.SelectedRecordCount = 1);
end;

procedure TfrmAdminProfile.actFunctionsExecute(Sender: TObject);
begin
  RunChild(Id_Profile, tcPflCrossFunctions, ProfileTag);
end;

procedure TfrmAdminProfile.actFunctionsUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblViewProfiles.Controller.SelectedRecordCount = 1);
end;

procedure TfrmAdminProfile.actModulesExecute(Sender: TObject);
begin
  RunChild(Id_Profile, tcPflCrossModules, ProfileTag);
end;

procedure TfrmAdminProfile.actModulesUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblViewProfiles.Controller.SelectedRecordCount = 1);
end;

procedure TfrmAdminProfile.actRefreshExecute(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAdminProfile.actUsersExecute(Sender: TObject);
begin
  RunChild(Id_Profile, tcPflCrossUsers, ProfileTag);
end;

procedure TfrmAdminProfile.actUsersUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblViewProfiles.Controller.SelectedRecordCount = 1);
end;

procedure TfrmAdminProfile.AssignToolBarImages;

  function CopyIL(aIndex: Integer): Integer;
  var
    Icon: TIcon;
  begin
    Icon := TIcon.Create();
    try
      GDDM.ilGlobal32.GetIcon(aIndex, Icon);
      Result := cxImageList.AddIcon(Icon);
    finally
      Icon.Free();
    end;
  end;

begin
  actAdd.ImageIndex := CopyIL(IL_ADD);
  actEdit.ImageIndex := CopyIL(IL_EDIT);
  actDelete.ImageIndex := CopyIL(IL_DELETE);
  actRefresh.ImageIndex := CopyIL(IL_REFRESH);

  dxBarManager.LargeImages := cxImageList;
end;

constructor TfrmAdminProfile.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);

  qrQuery.Connection := FDConnection;
  ttDelProfile.Connection := FDConnection;

  AssignToolBarImages();

  FId_Profile := 0;
  FProfileTag := '';
end;

procedure TfrmAdminProfile.tblViewProfilesCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  actEdit.Execute();
end;

procedure TfrmAdminProfile.DeleteRecords;
var
  k: Integer;
begin
  CreateSQLCursor();
  ttDelProfile.CreateTempTable();
  try
    for k := 0 to tblViewProfiles.Controller.SelectedRecordCount - 1 do
      ttDelProfile.InsertTempTable([TFieldValue.Create('Id_Profile', tblViewProfiles.Controller.SelectedRecords[k].Values[COL_ID_PROFILE])]);
    TERPQueryHelp.Open(FDConnection, PROC_ADM_PFL_DEL_ITEM, []);
  finally
    ttDelProfile.DropTempTable();
  end;
end;

procedure TfrmAdminProfile.FormShow(Sender: TObject);
begin
  RefreshData();
end;

function TfrmAdminProfile.GetIdProfile: integer;
begin
  if Assigned(tblViewProfiles.Controller.FocusedRecord) then
   FId_Profile := tblViewProfiles.Controller.FocusedRecord.Values[COL_ID_PROFILE];
  RESULT := FId_Profile;
end;

function TfrmAdminProfile.GetProfileTag: string;
begin
  if Assigned(tblViewProfiles.Controller.FocusedRecord) then
   FProfileTag := tblViewProfiles.Controller.FocusedRecord.Values[COL_PROFILENAME];
  RESULT := FProfileTag;
end;

procedure TfrmAdminProfile.RefreshData;
var
  k: Integer;
begin
  CreateSQLCursor();

  qrQuery.SQL.Text := PROC_ADM_PFL_SEL_ITEMLIST;
  qrQuery.Open();
  try
    tblViewProfiles.DataController.RecordCount := qrQuery.RecordCount;
    tblViewProfiles.BeginUpdate();
    try
      for k := 0 to tblViewProfiles.DataController.RecordCount - 1 do
      begin
        tblViewProfiles.DataController.Values[k, COL_ID_PROFILE] := qrQuery.FieldByName(FLD_ID_PROFILE).AsInteger;
        tblViewProfiles.DataController.Values[k, COL_PROFILENAME] := qrQuery.FieldByName(FLD_PROFILENAME).AsString;
        tblViewProfiles.DataController.Values[k, COL_PROFILEDESCRIPTION] := qrQuery.FieldByName(FLD_PROFILEDESCRIPTION).AsString;
        tblViewProfiles.DataController.Values[k, COL_ENABLED] := qrQuery.FieldByName(FLD_ENABLED).AsString;
        qrQuery.Next();
      end;
    finally
      tblViewProfiles.EndUpdate;
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminProfile.RunChild(aId_Profile: integer; aChildType: TTypeChild; Caption: string);
var ChildForm: TfrmAdminProfileCross;
    ChildDescr: TChildDescr;
begin
  ChildDescr.Kind := aChildType;
  ChildDescr.caption := Caption;

  ChildForm := TfrmAdminProfileCross.Create(aId_Profile, ChildDescr, FDConnection, Self);
  try
    ChildForm.Position := poOwnerFormCenter;
    ChildForm.ShowModal;
  finally
    ChildForm.Free;
  end;
end;

procedure TfrmAdminProfile.ShowChild(aId_Profile: Integer);
var
  frmAdminProfileDetail: TfrmAdminProfileDetail;
begin
  frmAdminProfileDetail := TfrmAdminProfileDetail.Create(aId_Profile, FDConnection, Self);
  try
    frmAdminProfileDetail.Position := poOwnerFormCenter;
    frmAdminProfileDetail.ShowModal();
  finally
    frmAdminProfileDetail.Free();
  end;
  RefreshData();
end;

end.
