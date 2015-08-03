unit ERP.Admin.User.UI.AdminUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, cxGridCustomTableView, cxGridTableView, cxGridCustomView, cxClasses, cxGridLevel, cxGrid, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, dxBar, System.Actions, Vcl.ActnList, Vcl.ImgList, cxCheckBox, Vcl.StdCtrls,
  ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;

type
  TfrmAdminUser = class(TERPCustomForm)
    ActionList: TActionList;
    dxBarManager: TdxBarManager;
    qrQuery: TFDQuery;
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    tblUsers: TcxGridTableView;
    btnAdd: TdxBarLargeButton;
    btnEdit: TdxBarLargeButton;
    btnDelete: TdxBarLargeButton;
    btnRefresh: TdxBarLargeButton;
    btnRecreate: TdxBarLargeButton;
    dxBarManager1Bar1: TdxBar;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    acRefresh: TAction;
    acRecreate: TAction;
    cxImageList: TcxImageList;
    colUserGroupName: TcxGridColumn;
    colPassword: TcxGridColumn;
    mLog: TMemo;
    ttDelUser: TsmFireDACTempTable;
    btnAD: TdxBarLargeButton;
    acAD: TAction;
    procedure acAddExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tblUsersDblClick(Sender: TObject);
    procedure acRecreateExecute(Sender: TObject);
    procedure acADExecute(Sender: TObject);
  private
    procedure AssignToolBarImages;
    procedure RecreateUser;
    procedure DeleteRecords;
    procedure RefreshData;
    procedure ShowChild(aId_User: Integer);
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
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.ClientInterface.IDBConnection,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  ERP.Admin.User.UI.AdminUserDetail,
  ERP.Admin.User.UI.AdminUserAD;

resourcestring
  rsDelete               = 'Удаление';
  rsDeleteConfirm        = 'Вы уверены, что хотите удалить выделенные записи?';

const
  MODULE_NAME            = 'Пользователи';
  MODULE_GUID: TGUID     = '{3264CA2B-B97F-46DF-A7F3-CD425D2AC07A}';
  MODULE_TYPEDB          = TYPE_DATABASE_ADMIN;

  COL_ID_USER       = 0;
  COL_USERGROUPNAME = 1;
  COL_USERNAME      = 2;
  COL_USERLOGIN     = 3;
  COL_WINAUTH       = 4;
  COL_ENABLED       = 5;
  COL_PASSWORD      = 6;

  FLD_ID_USER       = 'Id_User';
  FLD_USERGROUPNAME = 'UserGroupName';
  FLD_USERNAME      = 'UserName';
  FLD_LOGIN         = 'UserLogin';
  FLD_WINAUTH       = 'WinAuth';
  FLD_ENABLED       = 'Enabled';
  FLD_PASSWORD      = 'Password';

  PROC_ADM_USR_DEL_ITEM     = 'adm_usr_del_item';
  PROC_ADM_USR_SEL_ITEMLIST = 'adm_usr_sel_itemlist';

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmAdminUser;
begin
  frmForm := TfrmAdminUser.Create(aERPClientData);
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

{ TfrmAdminUser }

procedure TfrmAdminUser.acADExecute(Sender: TObject);
var
  frmAdminUserAD: TfrmAdminUserAD;
begin
  frmAdminUserAD := TfrmAdminUserAD.Create(nil, FDConnection);
  try
    frmAdminUserAD.ShowModal();
    RefreshData();
  finally
    frmAdminUserAD.Free();
  end;
end;

procedure TfrmAdminUser.acAddExecute(Sender: TObject);
begin
  ShowChild(-1);
  RefreshData();
end;

procedure TfrmAdminUser.acDeleteExecute(Sender: TObject);
begin
 if Application.MessageBox(PChar(rsDeleteConfirm), PChar(rsDelete), MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    DeleteRecords();
    RefreshData();
  end;
end;

procedure TfrmAdminUser.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblUsers.Controller.SelectedRecordCount > 0;
end;

procedure TfrmAdminUser.acEditExecute(Sender: TObject);
begin
  ShowChild(tblUsers.Controller.FocusedRecord.Values[COL_ID_USER]);
  RefreshData();
end;

procedure TfrmAdminUser.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblUsers.Controller.SelectedRecordCount = 1;
end;

procedure TfrmAdminUser.acRecreateExecute(Sender: TObject);
begin
  RecreateUser();
end;

procedure TfrmAdminUser.acRefreshExecute(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAdminUser.AssignToolBarImages;

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
  acAdd.ImageIndex := CopyIL(IL_ADD);
  acEdit.ImageIndex := CopyIL(IL_EDIT);
  acDelete.ImageIndex := CopyIL(IL_DELETE);
  acRefresh.ImageIndex := CopyIL(IL_REFRESH);
  acRecreate.ImageIndex := 0;
  acAD.ImageIndex := 1;

  dxBarManager.LargeImages := cxImageList;
end;

constructor TfrmAdminUser.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);
  qrQuery.Connection := FDConnection;
  ttDelUser.Connection := FDConnection;
  AssignToolBarImages();
end;

procedure TfrmAdminUser.tblUsersDblClick(Sender: TObject);
begin
  btnEdit.Click();
end;

procedure TfrmAdminUser.DeleteRecords;
var
  k: Integer;
begin
  CreateSQLCursor();
  ttDelUser.CreateTempTable();
  try
    for k := 0 to tblUsers.Controller.SelectedRecordCount - 1 do
      ttDelUser.InsertTempTable([TFieldValue.Create('Id_User', tblUsers.Controller.SelectedRecords[k].Values[COL_ID_USER])]);
    TERPQueryHelp.Open(FDConnection, PROC_ADM_USR_DEL_ITEM, []);
  finally
    ttDelUser.DropTempTable();
  end;
end;

procedure TfrmAdminUser.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAdminUser.RecreateUser;
var
  k, i: Integer;
  DBConnection: IDBConnection;
  RemoteConnection: TFDConnection;
  RemoteQuery: TFDQuery;
  IsServer: Integer;
  IsDataBase: Integer;
  Login: string;
  Password: string;
  IsWinAuth: Boolean;
  Log: TStringList;
begin
  CreateSQLCursor();
  Log := TStringList.Create();
  try
    try
      for k := 0 to tblUsers.Controller.SelectedRecordCount - 1 do
      begin
        Login := tblUsers.Controller.SelectedRecords[k].Values[COL_USERLOGIN];
        Password := tblUsers.Controller.SelectedRecords[k].Values[COL_PASSWORD];
        IsWinAuth := tblUsers.Controller.SelectedRecords[k].Values[COL_WINAUTH];
        Log.Add(Format('Обработка пользователя %s', [Login]));
        qrQuery.SQL.Text := 'adm_usr_sel_databaselist :Id_User';
        qrQuery.Params.ParamValues['Id_User'] := tblUsers.Controller.SelectedRecords[k].Values[COL_ID_USER];
        try
          qrQuery.Open();
          qrQuery.First();
          for i := 0 to qrQuery.RecordCount - 1 do
          begin
            DBConnection := ERPClientData.ERPApplication.CreateFDConnection(qrQuery.FieldByName('Id_DataBase').AsInteger, MODULE_GUID);
            Log.Add(Format('Выбрана БД [%s].[%s]', [DBConnection.Server, DBConnection.DataBase]));
            DBConnection.UnsetAppRole();
            try
              RemoteConnection := TFDConnection.Create(Self);
              try
                RemoteConnection.ResourceOptions.SilentMode := True;
                RemoteConnection.FetchOptions.Mode := fmAll;
                RemoteConnection.SharedCliHandle := DBConnection.FDConnectionHandle;
                RemoteQuery := TFDQuery.Create(Self);
                try
                  RemoteQuery.Connection := RemoteConnection;
                  RemoteQuery.SQL.Text :=
                    'SELECT'#13#10 +
                    '  (SELECT COUNT(sp.principal_id) FROM sys.server_principals sp WHERE sp.name = :UserLogin) AS IsServer,'#13#10 +
                    '  (SELECT COUNT(dp.principal_id) FROM sys.database_principals dp WHERE dp.name = :UserLogin) AS IsDataBase';
                  RemoteQuery.Params.ParamValues['UserLogin'] := Login;
                  try
                    RemoteQuery.Open();
                    IsServer := RemoteQuery.FieldByName('IsServer').AsInteger;
                    IsDataBase := RemoteQuery.FieldByName('IsDataBase').AsInteger;
                  finally
                    RemoteQuery.Close();
                  end;
                  if IsServer = 0 then
                  begin
                    if IsWinAuth then
                      RemoteQuery.SQL.Text := Format('CREATE LOGIN [%s] FROM WINDOWS', [Login])
                    else
                      RemoteQuery.SQL.Text := Format('CREATE LOGIN [%s] WITH PASSWORD=N''%s'', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF', [Login, Password]);
                    RemoteQuery.ExecSQL();
                    Log.Add('CREATE LOGIN');
                  end
                  else
                    if not IsWinAuth then
                    begin
                      RemoteQuery.SQL.Text := Format('ALTER LOGIN [%s] WITH PASSWORD=N''%s''', [Login, Password]);
                      RemoteQuery.ExecSQL();
                      Log.Add('ALTER LOGIN');
                    end;
                  if IsDataBase = 1 then
                  begin
                    RemoteQuery.SQL.Text := Format('DROP USER [%s]', [Login]);
                    RemoteQuery.ExecSQL();
                    Log.Add('DROP USER');
                  end;
                  RemoteQuery.SQL.Text := Format('CREATE USER [%s] FOR LOGIN [%s]', [Login, Login]);
                  RemoteQuery.ExecSQL();
                  Log.Add('CREATE USER');
                finally
                  RemoteQuery.Free();
                end;
              finally
                RemoteConnection.Free();
              end;
            finally
              DBConnection.SetAppRole();
            end;
            qrQuery.Next();
          end;
        finally
          qrQuery.Close();
        end;
      end;
    except on E: Exception do
    begin
      Log.Add(E.Message);
      raise;
    end;
    end;
  finally
    mLog.Lines.Assign(Log);
    Log.Free();
  end;
end;

procedure TfrmAdminUser.RefreshData;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := PROC_ADM_USR_SEL_ITEMLIST;
  qrQuery.Open();
  try
    tblUsers.BeginUpdate();
    try
      tblUsers.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to tblUsers.DataController.RecordCount - 1 do
      begin
        tblUsers.DataController.Values[k, COL_ID_USER] := qrQuery.FieldByName(FLD_ID_USER).AsInteger;
        tblUsers.DataController.Values[k, COL_USERGROUPNAME] := qrQuery.FieldByName(FLD_USERGROUPNAME).AsString;
        tblUsers.DataController.Values[k, COL_USERNAME] := qrQuery.FieldByName(FLD_USERNAME).AsString;
        tblUsers.DataController.Values[k, COL_USERLOGIN] := qrQuery.FieldByName(FLD_LOGIN).AsString;
        tblUsers.DataController.Values[k, COL_WINAUTH] := qrQuery.FieldByName(FLD_WINAUTH).AsBoolean;
        tblUsers.DataController.Values[k, COL_ENABLED] := qrQuery.FieldByName(FLD_ENABLED).AsBoolean;
        tblUsers.DataController.Values[k, COL_PASSWORD] := qrQuery.FieldByName(FLD_PASSWORD).AsString;
        qrQuery.Next();
      end;
    finally
      tblUsers.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminUser.ShowChild(aId_User: Integer);
var
  frmAdminUserDetail: TfrmAdminUserDetail;
begin
  frmAdminUserDetail := TfrmAdminUserDetail.Create(aId_User, FDConnection, Self);
  try
    frmAdminUserDetail.ShowModal();
  finally
    frmAdminUserDetail.Free();
  end;
  RefreshData();
end;

end.
