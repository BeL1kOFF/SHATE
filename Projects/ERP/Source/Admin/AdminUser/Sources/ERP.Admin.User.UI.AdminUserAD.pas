unit ERP.Admin.User.UI.AdminUserAD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, System.Actions, Vcl.ActnList, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxLabel, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxClasses, cxGridLevel, cxGrid, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, ShateM.Components.TCustomTempTable,
  ShateM.Components.TFireDACTempTable;

type
  TfrmAdminUserAD = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acCancel: TAction;
    acSave: TAction;
    cxLabel2: TcxLabel;
    cmbUsersGroups: TcxComboBox;
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    tblUsers: TcxGridTableView;
    colUserLogin: TcxGridColumn;
    qrQuery: TFDQuery;
    btnAddUserAD: TButton;
    acAdd: TAction;
    smFireDACTempTable: TsmFireDACTempTable;
    colUserName: TcxGridColumn;
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
  private
    FFDConnection: TFDConnection;
    function IsFindUserInGrid(const aUser: string): Boolean;
    function IsSave: Boolean;
    procedure AddUsersFromAD;
    procedure FillUsersGroups;
  public
    constructor Create(aOwner: TComponent; aConnection: TFDConnection); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  Winapi.ActiveX,
  JwaActiveX,
  JwaObjSel,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_ADM_USR_SEL_USERSGROUPSLIST = 'adm_usr_sel_usergrouplist';

  FLD_USRGRPLIST_ID_USERGROUP = 'Id_UserGroup';
  FLD_USRGRPLIST_NAME = 'Name';

{ TfrmAdminUserAD }

procedure TfrmAdminUserAD.acAddExecute(Sender: TObject);
begin
  AddUsersFromAD();
end;

procedure TfrmAdminUserAD.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAdminUserAD.acSaveExecute(Sender: TObject);
begin
  if IsSave() then
    Close();
end;

procedure TfrmAdminUserAD.acSaveUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (cmbUsersGroups.ItemIndex > -1) and (tblUsers.DataController.RecordCount > 0);
end;

procedure TfrmAdminUserAD.AddUsersFromAD;
var
  Picker: IDsObjectPicker;
  DatObj: IDataObject;
  ScopeInit: array [0..0] of TDSOPScopeInitInfo;
  InitInfo: TDSOPInitInfo;
  FmtEtc: TFormatEtc;
  StgMed: TStgMedium;
  SelLst: PDSSelectionList;
  k: Integer;
  User: string;
  Name: string;
begin
  if Succeeded(CoCreateInstance(CLSID_DsObjectPicker, nil, CLSCTX_INPROC_SERVER, IID_IDsObjectPicker, Picker)) then
    try
      ZeroMemory(@ScopeInit, SizeOf(ScopeInit));
      ScopeInit[0].cbSize := SizeOf(TDSOPScopeInitInfo);
      ScopeInit[0].flType := DSOP_SCOPE_TYPE_ENTERPRISE_DOMAIN or DSOP_SCOPE_TYPE_GLOBAL_CATALOG;
      ScopeInit[0].flScope := DSOP_SCOPE_FLAG_WANT_PROVIDER_WINNT;
      ScopeInit[0].FilterFlags.Uplevel.flBothModes := DSOP_FILTER_USERS;
      ScopeInit[0].FilterFlags.flDownlevel := DSOP_DOWNLEVEL_FILTER_USERS;
      ZeroMemory(@InitInfo, SizeOf(TDSOPInitInfo));
      InitInfo.cbSize := SizeOf(TDSOPInitInfo);
      InitInfo.cDsScopeInfos := 1;
      InitInfo.aDsScopeInfos := @ScopeInit;
      InitInfo.flOptions := DSOP_FLAG_MULTISELECT;
      if Succeeded(Picker.Initialize(InitInfo)) then
      begin
        case Picker.InvokeDialog(Handle, DatObj) of
          S_OK:
            begin
              FmtEtc.cfFormat := RegisterClipboardFormat(CFSTR_DSOP_DS_SELECTION_LIST);
              FmtEtc.ptd := nil;
              FmtEtc.dwAspect := DVASPECT_CONTENT;
              FmtEtc.lindex := -1;
              FmtEtc.tymed := TYMED_HGLOBAL;
              if Succeeded(DatObj.GetData(FmtEtc, StgMed)) then
              begin
                SelLst := PDsSelectionList(GlobalLock(StgMed.hGlobal));
                if Assigned(SelLst) then
                begin
                  try
                    tblUsers.BeginUpdate();
                    try
                      for k := 0 to SelLst.cItems - 1 do
                      begin
                        {$UNDEF R_OLD}
                        {$IFOPT R+}
                          {$DEFINE R_OLD}
                          {$R-}
                        {$ENDIF}
                        User := WideCharToString(SelLst.aDsSelection[k].pwzADsPath);
                        Name := WideCharToString(SelLst.aDsSelection[k].pwzName);
                        {$IFDEF R_OLD}
                          {$UNDEF R_OLD}
                          {$R+}
                        {$ENDIF}
                        Delete(User, 1, Length('WinNT://'));
                        User := StringReplace(User, '/', '\', []);
                        if not IsFindUserInGrid(User) then
                        begin
                          tblUsers.DataController.RecordCount := tblUsers.DataController.RecordCount + 1;
                          tblUsers.DataController.Values[tblUsers.DataController.RecordCount - 1, 0] := User;
                          tblUsers.DataController.Values[tblUsers.DataController.RecordCount - 1, 1] := Name;
                        end;
                      end;
                    finally
                      tblUsers.EndUpdate();
                    end;
                  finally
                    GlobalUnlock(StgMed.hGlobal);
                  end;
                end;
                ReleaseStgMedium(Winapi.ActiveX.TStgMedium(StgMed));
              end;
            end;
        end;
        DatObj := nil;
      end;
    finally
      Picker := nil;
    end;
end;

constructor TfrmAdminUserAD.Create(aOwner: TComponent; aConnection: TFDConnection);
begin
  inherited Create(aOwner);

  FFDConnection := aConnection;
  qrQuery.Connection := aConnection;
  smFireDACTempTable.Connection := aConnection;
end;

procedure TfrmAdminUserAD.FillUsersGroups;
var
  k: Integer;
begin
  cmbUsersGroups.Properties.Items.Clear();
  qrQuery.SQL.Text := PROC_ADM_USR_SEL_USERSGROUPSLIST;
  try
    qrQuery.Open();
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cmbUsersGroups.Properties.Items.AddObject(qrQuery.FieldByName(FLD_USRGRPLIST_NAME).AsString,
        TObject(qrQuery.FieldByName(FLD_USRGRPLIST_ID_USERGROUP).AsInteger));
      qrQuery.Next();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminUserAD.FormShow(Sender: TObject);
begin
  FillUsersGroups();
end;

function TfrmAdminUserAD.IsFindUserInGrid(const aUser: string): Boolean;
begin
  Result := tblUsers.DataController.FindRecordIndexByText(0, 0, aUser, True, False, True) > -1;
end;

function TfrmAdminUserAD.IsSave: Boolean;
var
  k: Integer;
begin
  CreateSQLCursor();
  smFireDACTempTable.CreateTempTable();
  try
    for k := 0 to tblUsers.DataController.RecordCount - 1 do
      smFireDACTempTable.InsertTempTable([TFieldValue.Create('UserLogin', tblUsers.DataController.Values[k, 0]),
                                          TFieldValue.Create('UserName', tblUsers.DataController.Values[k, 1])]);
    Result := TERPQueryHelp.Open(FFDConnection, 'adm_usr_ins_ad :Id_UserGroup', [TERPParamValue.Create(Integer(cmbUsersGroups.Properties.Items.Objects[cmbUsersGroups.ItemIndex]))]);
  finally
    smFireDACTempTable.DropTempTable();
  end;
end;

end.
