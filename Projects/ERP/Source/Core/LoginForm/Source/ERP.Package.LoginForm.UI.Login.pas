unit ERP.Package.LoginForm.UI.Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxGDIPlusClasses, dxSkinsCore, dxSkinCaramel,
  cxLookAndFeels, dxSkinsForm, cxGraphics, cxControls, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxLabel,
  cxCheckBox, Vcl.ExtCtrls, Vcl.Menus, Vcl.StdCtrls, cxButtons, Vcl.ActnList, System.Win.ScktComp,
  cxProgressBar, ERP.Package.ClientClasses.TERPSocketClient, System.Actions, cxClasses;

type
  TfrmLogin = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    dxSkinController: TdxSkinController;
    edtLogin: TcxTextEdit;
    edtPassword: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    chbWindows: TcxCheckBox;
    btnCancel: TcxButton;
    btnEnter: TcxButton;
    ActionList: TActionList;
    acCancel: TAction;
    acEnter: TAction;
    acWindows: TAction;
    pbProgress: TcxProgressBar;
    procedure acWindowsExecute(Sender: TObject);
    procedure acEnterUpdate(Sender: TObject);
    procedure acEnterExecute(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FModuleError: TStringList;
    function GetCurrentUserAndDomain(aUser: PChar; var aUserSize: DWORD;
      aDomain: PChar; var aDomainSize: DWORD): Boolean;
    function GetUserDomainName: string;
    procedure DisableEnter;
    procedure DoCommand(aCommand: Integer);
    procedure DoError(Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DoLogger(const aEvent: TClientConnectionLoggerEventType; Socket: TCustomWinSocket);
    procedure EnableEnter;
    procedure Init;
    procedure OnScanLogger(aIndex, aCount: Integer; const aFileName: string);
    procedure OnErrorLogger(const aFileName, aError: string);
    function ShowChangePassword(out aPassword: string): Integer;
  end;

function RegisterLoginForm: TFormClass; stdcall;

exports RegisterLoginForm;

implementation

uses
  ERP.Package.CustomClasses.Consts,
  ERP.Package.ClientClasses.Variable,
  ERP.Package.LoginForm.UI.ChangePassword;

{$R *.dfm}

function RegisterLoginForm: TFormClass;
begin
  Result := TfrmLogin;
end;

procedure TfrmLogin.acCancelExecute(Sender: TObject);
begin
  Close();
  ModalResult := mrCancel;
end;

procedure TfrmLogin.acEnterExecute(Sender: TObject);
begin
  DisableEnter();
  pbProgress.Properties.Min := 0;
  pbProgress.Properties.Max := 100;
  pbProgress.Position := 0;
  ClientManager.UserLogin := edtLogin.Text;
  ClientManager.Password := edtPassword.Text;
  ClientManager.IsWinAuth := chbWindows.Checked;
  ClientManager.SocketClient.SendAuthData(edtLogin.Text, edtPassword.Text);
end;

procedure TfrmLogin.acEnterUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := chbWindows.Checked or ((edtLogin.Text <> '') and (edtPassword.Text <> ''));
end;

procedure TfrmLogin.acWindowsExecute(Sender: TObject);
var
  tmpCheckBox: TcxCheckBox;
begin
  tmpCheckBox := ((Sender as TAction).ActionComponent as TcxCheckBox);
  edtLogin.Enabled := not tmpCheckBox.Checked;
  edtPassword.Enabled := not tmpCheckBox.Checked;
  if tmpCheckBox.Checked then
  begin
    edtLogin.Text := GetUserDomainName();
    edtPassword.Text := '';
  end
  else
  begin
    edtLogin.Text := '';
    edtPassword.Text := '';
  end;
end;

procedure TfrmLogin.DisableEnter;
begin
  chbWindows.Enabled := False;
  edtLogin.Enabled := False;
  edtPassword.Enabled := False;
  btnEnter.Enabled := False;
end;

procedure TfrmLogin.DoCommand(aCommand: Integer);
var
  ResultPassword: Integer;
  PasswordNew: string;
begin
  case aCommand of
    SERVER_COMMAND_DENIDED:
      begin
        pbProgress.Position := 0;
        EnableEnter();
      end;
    SERVER_COMMAND_CHANGEPASSWORD:
      begin
        ResultPassword := ShowChangePassword(PasswordNew);
        if ResultPassword = mrOk then
          ClientManager.SocketClient.SendChangePassword(edtLogin.Text, PasswordNew);
      end;
    SERVER_COMMAND_ACCEPT:
      begin
        pbProgress.Position := 50;
        pbProgress.Properties.Text := FloatToStr(pbProgress.Position) + '% ' + '';
      end;
    SERVER_COMMAND_RESULTDBLIST:
      begin
        ClientManager.PluginManager.PackageModuleScan.OnPackageScanOnScanEvent := OnScanLogger;
        ClientManager.PluginManager.PackageModuleScan.OnPackageScanOnErrorEvent := OnErrorLogger;
        FModuleError := TStringList.Create();
        try
          ClientManager.PluginManager.LoadPluginList();
          if FModuleError.Count > 0 then
            Application.MessageBox(PChar(FModuleError.Text), 'Ошибка загрузки модулей', MB_OK or MB_ICONWARNING);
        finally
          FModuleError.Free();
        end;
        pbProgress.Position := 100;
        Close();
        ModalResult := mrOk;
      end;
  end;
end;

procedure TfrmLogin.DoError(Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  DisableEnter();
  Application.MessageBox(PChar(SysErrorMessage(ErrorCode)), 'Ошибка', MB_OK or MB_ICONERROR);
  ErrorCode := 0;
end;

procedure TfrmLogin.DoLogger(const aEvent: TClientConnectionLoggerEventType; Socket: TCustomWinSocket);
begin
  case aEvent of
    ccletConnect:
      EnableEnter();
    ccletDisconnect:
    begin
      DisableEnter();
      Application.MessageBox('Подключение к серверу не доступно!', 'Сообщение', MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TfrmLogin.EnableEnter;
begin
  chbWindows.Enabled := True;
  chbWindows.Checked := True;
  btnEnter.Enabled := True;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  Init();
end;

function TfrmLogin.GetCurrentUserAndDomain(aUser: PChar; var aUserSize: DWORD; aDomain: PChar;
  var aDomainSize: DWORD): Boolean;
var
 hToken: THandle;
 cbBuf: Cardinal;
 ptiUser: PTokenUser;
 snu: SID_NAME_USE;
begin
  Result := False;
  // Получаем маркер доступа текущего потока нашего процесса
  if not OpenThreadToken(GetCurrentThread(), TOKEN_QUERY, True, hToken) then
  begin
    if GetLastError() <> ERROR_NO_TOKEN then
      Exit;
    // В случее ошибки - получаем маркер доступа нашего процесса.
    if not OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, hToken) then
      Exit;
  end;

  // Вывываем GetTokenInformation для получения размера буфера
  if not GetTokenInformation(hToken, TokenUser, nil, 0, cbBuf) then
    if GetLastError() <> ERROR_INSUFFICIENT_BUFFER then
    begin
      CloseHandle(hToken);
      Exit;
    end;

  if cbBuf = 0 then
    Exit;

 // Выделяем память под буфер
  ptiUser := AllocMem(cbBuf);

 // В случае удачного вызова получим указатель на TOKEN_USER
  if GetTokenInformation(hToken, TokenUser, ptiUser, cbBuf, cbBuf) then
  begin
    // Ищем имя пользователя и его домен по его SID
    if LookupAccountSid(nil, ptiUser.User.Sid, aUser, aUserSize, aDomain, aDomainSize, snu) then
      Result := True;
  end;

 // Освобождаем ресурсы
 CloseHandle(hToken);
 FreeMem(ptiUser);
end;

function TfrmLogin.GetUserDomainName: string;
var
  pcDomain, pcUser: PChar;
  cDomain, cUser: Cardinal;
begin
  cUser := 255;
  cDomain := 255;
  pcUser := StrAlloc(cUser);
  pcDomain := StrAlloc(cDomain);
  if GetCurrentUserAndDomain(pcUser, cUser, pcDomain, cDomain) then
    Result := pcDomain + '\' + pcUser
  else
    Result := '';
  StrDispose(pcDomain);
  StrDispose(pcUser);
end;

procedure TfrmLogin.Init;
begin
  edtLogin.Text := GetUserDomainName();
  DisableEnter();
  ClientManager.SocketClient.SetSocketEvent(DoError, DoLogger, DoCommand);
  ClientManager.SocketClient.Open();
end;

procedure TfrmLogin.OnErrorLogger(const aFileName, aError: string);
begin
  FModuleError.Add(Format('Модуль %s не загружен.'#13#10'Ошибка: %s'#13#10, [ExtractFileName(aFileName), aError]));
end;

procedure TfrmLogin.OnScanLogger(aIndex, aCount: Integer; const aFileName: string);
var
  PercentScan: Single;
  StepProgress: Single;
begin
  PercentScan := aIndex * 100 / aCount;
  StepProgress := 1 * 50 / 100;
  pbProgress.Position := Round(PercentScan * StepProgress + 50);
  pbProgress.Properties.Text := FloatToStr(pbProgress.Position) + '% ' + ' ' + ExtractFileName(aFileName);
  pbProgress.Update();
end;

function TfrmLogin.ShowChangePassword(out aPassword: string): Integer;
var
  frmChangePassword: TfrmChangePassword;
begin
  frmChangePassword := TfrmChangePassword.Create(Self);
  try
    Result := frmChangePassword.ShowModal();
    if Result = mrOk then
      aPassword := frmChangePassword.edtPassword.Text;
  finally
    frmChangePassword.Free();
  end;
end;

end.
