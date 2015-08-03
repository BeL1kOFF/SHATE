unit ERP.Admin.User.UI.AdminUserDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.ActnList, cxMaskEdit, cxLabel, cxTextEdit, Vcl.StdCtrls, Vcl.ExtCtrls, cxDropDownEdit,
  cxCheckBox, Data.DB, System.Actions, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmAdminUserDetail = class(TForm)
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    Panel2: TPanel;
    edtIdUser: TcxTextEdit;
    edtName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel3: TcxLabel;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    cxLabel2: TcxLabel;
    cbEnabled: TcxCheckBox;
    qrQuery: TFDQuery;
    cmbUsersGroups: TcxComboBox;
    edtLogin: TcxTextEdit;
    cxLabel4: TcxLabel;
    edtPassword: TcxMaskEdit;
    cxLabel5: TcxLabel;
    cbChangePassword: TCheckBox;
    cbWinAuth: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure cbWinAuthClick(Sender: TObject);
  private
    FFDConnection: TFDConnection;
    FId_User: Integer;
    FIsWinAuthOld: Boolean;
    function Save: Boolean;
    function CallBackClassNotFound(aControl: TControl; aField: TField): Boolean;
    procedure FillUsersGroups(aId_User: Integer);
    procedure Init;
    procedure ReadItem;

  public
    constructor Create(aId_User: Integer; aConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

type
  PHCRYPTPROV = ^HCRYPTPROV;
  HCRYPTPROV = ULONG_PTR;
  ALG_ID = UINT;
  HCRYPTKEY = ULONG_PTR;
  PHCRYPTHASH = ^HCRYPTHASH;
  HCRYPTHASH = ULONG_PTR;

function CryptAcquireContext(phProv: PHCRYPTPROV; szContainer, szProvider: LPCWSTR;
  dwProvType, dwFlags: DWORD): BOOL; stdcall; external advapi32 name 'CryptAcquireContextW';

function CryptReleaseContext(hProv: HCRYPTPROV; dwFlags: DWORD): BOOL; stdcall; external advapi32;

function CryptCreateHash(hProv: HCRYPTPROV; Algid: ALG_ID; hKey: HCRYPTKEY; dwFlags: DWORD;
  phHash: PHCRYPTHASH): BOOL; stdcall; external advapi32;

function CryptDestroyHash(hHash: HCRYPTHASH): BOOL; external advapi32;

function CryptHashData(hHash: HCRYPTHASH; pbData: PByte; dwDataLen, dwFlags: DWORD): BOOL; stdcall; external advapi32;

function CryptGetHashParam(hHash: HCRYPTHASH; dwParam: DWORD; pbData: PByte; pdwDataLen: PDWORD;
  dwFlags: DWORD): BOOL; stdcall; external advapi32;

const
  PROC_ADM_USR_SEL_ITEM = 'adm_usr_sel_item :Id_User';
  PROC_ADM_USR_INS_ITEM = 'adm_usr_ins_item :Id_UserGroup, :Name, :Login, :MD5Pass, :WinAuth, :ChangePass, :Enabled';
  PROC_ADM_USR_UPD_ITEM = 'adm_usr_upd_item  :Id_User, :Id_UserGroup, :Name, :Login, :MD5Pass, :WinAuth, :ChangePass, :Enabled';
  PROC_ADM_USR_SEL_USERSGROUPSLIST = 'adm_usr_sel_usergrouplist';

  FLD_USRGRPLIST_ID_USERGROUP = 'Id_UserGroup';
  FLD_USRGRPLIST_NAME = 'Name';

  FLD_ID_USERGROUP = 'Id_UserGroup';
  FLD_ID_USER = 'Id_User';
  FLD_NAME = 'UserName';
  FLD_LOGIN = 'UserLogin';
  FLD_MD5PASS = 'MD5Pass';
  FLD_WINAUTH = 'WinAuth';
  FLD_CHANGEPASS = 'ChangePass';
  FLD_ENABLED = 'Enabled';

function MD5(const aText: string): string;
var
  hCrypt: HCRYPTPROV;
  hHash: HCRYPTHASH;
  HashSize: DWORD;
  Data: TBytes;
  DataString: TBytes;
  i: DWORD;
begin
  { TODO 1 : Реализовать отдельный Unit для CryptAPI }
  Result := '';
  if aText <> '' then
  begin
    if CryptAcquireContext(@hCrypt, nil, nil, 1, $F0000000) then
    begin
      if CryptCreateHash(hCrypt, 32771, 0, 0, @hHash) then
      begin
        if CryptHashData(hHash, @aText[1], Length(aText) * StringElementSize(aText), 0) then
          if CryptGetHashParam(hHash, $04, @HashSize, @i, 0) then
          begin
            SetLength(Data, HashSize);
            if CryptGetHashParam(hHash, $02, @Data[0], @HashSize, 0) then
            begin
              SetLength(DataString, Length(Data) * 2);
              BinToHex(Data, 0, DataString, 0, Length(Data));
              Result := StringOf(DataString);
            end;
          end;
        CryptDestroyHash(hHash);
      end;
      CryptReleaseContext(hCrypt, 0);
    end;
    if Result = '' then
      raise Exception.Create('Текст не зашифрован!');
  end;
end;

{ TfrmAdminModuleDetail }

procedure TfrmAdminUserDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAdminUserDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmAdminUserDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (edtName.Text <> '') and (cmbUsersGroups.ItemIndex > -1) and (edtLogin.Text <> '') and
                              ((edtPassword.Text <> '') or (cbWinAuth.Checked) or ((FId_User <> -1) and (not FIsWinAuthOld)));
end;

function TfrmAdminUserDetail.CallBackClassNotFound(aControl: TControl; aField: TField): Boolean;
begin
  Result := True;
  if aControl.Name = 'cmbUsersGroups' then
    FillUsersGroups(aField.AsInteger)
  else
    Result := False;
end;

procedure TfrmAdminUserDetail.cbWinAuthClick(Sender: TObject);
begin
  edtPassword.Enabled := not TCheckBox(Sender).Checked;
  cbChangePassword.Enabled := not TCheckBox(Sender).Checked;
end;

constructor TfrmAdminUserDetail.Create(aId_User: Integer; aConnection: TFDConnection; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FFDConnection := aConnection;
  FId_User := aId_User;
end;

procedure TfrmAdminUserDetail.FillUsersGroups(aId_User: Integer);
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
    cmbUsersGroups.ItemIndex := cmbUsersGroups.Properties.Items.IndexOfObject(TObject(aId_User));
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminUserDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmAdminUserDetail.FormShow(Sender: TObject);
begin
  Init();
  edtName.SetFocus();
end;

procedure TfrmAdminUserDetail.Init;
begin
  CreateSQLCursor();
  qrQuery.Connection := FFDConnection;
  if FId_User = -1 then
  begin
    edtName.Text := '';
    edtLogin.Text := '';
    cbEnabled.Checked := False;
    cbChangePassword.Checked := True;
    cbWinAuth.Checked := False;
    FillUsersGroups(-1);
  end
  else
    ReadItem();
  edtPassword.Text := '';
  edtPassword.Enabled := not cbWinAuth.Checked;
  cbChangePassword.Enabled := not cbWinAuth.Checked;
  FIsWinAuthOld := cbWinAuth.Checked;
end;

procedure TfrmAdminUserDetail.ReadItem;
begin
  edtIdUser.Text := IntToStr(FId_User);
  TERPQueryHelp.ReadItem(FFDConnection, PROC_ADM_USR_SEL_ITEM, [TERPParamValue.Create(FId_User)],
    [TERPControlValue.Create(cmbUsersGroups, FLD_ID_USERGROUP),
     TERPControlValue.Create(edtName, FLD_NAME),
     TERPControlValue.Create(edtLogin, FLD_LOGIN),
     TERPControlValue.Create(cbWinAuth, FLD_WINAUTH),
     TERPControlValue.Create(cbChangePassword, FLD_CHANGEPASS),
     TERPControlValue.Create(cbEnabled, FLD_ENABLED)], CallBackClassNotFound);
end;

function TfrmAdminUserDetail.Save: Boolean;
var
  Password: Variant;
  ChangePassword: Boolean;
begin
  CreateSQLCursor();
  if not cbWinAuth.Checked then
    Password := MD5(edtPassword.Text)
  else
    Password := '';
  if Password = '' then
    Password := Null;
  ChangePassword := cbChangePassword.Checked;
  if cbWinAuth.Checked then
    ChangePassword := False;
  if FId_User = -1 then
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_USR_INS_ITEM,
      [TERPParamValue.Create(Integer(cmbUsersGroups.Properties.Items.Objects[cmbUsersGroups.ItemIndex])),
       TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(edtLogin.Text),
       TERPParamValue.Create(Password, ftString),
       TERPParamValue.Create(cbWinAuth.Checked),
       TERPParamValue.Create(ChangePassword),
       TERPParamValue.Create(cbEnabled.Checked)])
  else
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_USR_UPD_ITEM,
      [TERPParamValue.Create(FId_User),
       TERPParamValue.Create(Integer(cmbUsersGroups.Properties.Items.Objects[cmbUsersGroups.ItemIndex])),
       TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(edtLogin.Text),
       TERPParamValue.Create(Password, ftString),
       TERPParamValue.Create(cbWinAuth.Checked),
       TERPParamValue.Create(ChangePassword),
       TERPParamValue.Create(cbEnabled.Checked)]);
end;

end.
