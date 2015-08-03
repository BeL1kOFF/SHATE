unit ERP.Package.ERPClasses.TMain;

interface

uses
  ERP.Package.ERPClasses.TPackageSystemScan,
  ERP.Package.ERPClasses.TOnlyInstanceApplication,
  ERP.Package.ERPClasses.TLoginForm;

type
  TMain = class
  private
    FOnlyInstanceApplication: TOnlyInstanceApplication;
    FLoginForm: TLoginForm;
    FPackageSystemScan: TPackageSystemScan;
    function IsInstalledDriver: Boolean;
    function ShowLogin: Boolean;
    procedure LoadSystemPackage;
  public
    constructor Create;
    destructor Destroy; override;
    function IsExecuted: Boolean;
    procedure Run;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  System.Odbc,
  Vcl.Controls,
  Vcl.Forms,
  ERP.Package.ERPClasses.TMainForm;

const
  GUID_APPLICATION = '{015031D9-8558-4151-897C-D04FCACD9E68}';
  BPL_LOGINFORM_PATH = 'System\ERP.Package.LoginForm.bpl';
  BPL_MAINFORM_PATH = 'System\ERP.Package.MainForm.bpl';

  SQL_DRIVER = 'SQL Server Native Client 11.0';

resourcestring
  rsModuleNoFound = 'Модуль главной формы не найден!';
  rsError = 'Ошибка';

var
  GlobalMainForm: TMainForm;

{ TMain }

constructor TMain.Create;
begin
  FOnlyInstanceApplication := TOnlyInstanceApplication.Create(wrSystem, GUID_APPLICATION);
  FPackageSystemScan := TPackageSystemScan.Create;
end;

destructor TMain.Destroy;
begin
  FPackageSystemScan.Free();
  FOnlyInstanceApplication.Free();
  inherited Destroy();
end;

function TMain.IsExecuted: Boolean;
begin
  Result := FOnlyInstanceApplication.IsInstancePresent;
end;

function TMain.IsInstalledDriver: Boolean;
var
  hEnv: SQLHENV;
  BufSize, BufSize2: SQLSMALLINT;
  Buffer, Buffer2: PChar;
  Direct: SQLSMALLINT;
  Driver: string;
begin
  Result := False;
  hEnv := nil;
  SQLAllocHandle(SQL_HANDLE_ENV, SQLPOINTER(SQL_NULL_HENV), hEnv);
  try
    SQLSetEnvAttr(hEnv, SQL_ATTR_ODBC_VERSION, SQLPOINTER(SQL_OV_ODBC3), SQL_IS_INTEGER);
    BufSize := 1024;
    BufSize2 := BufSize;
    Buffer := AllocMem(BufSize * 2);
    try
      Buffer2 := AllocMem(BufSize2 * 2);
      try
        Direct := SQL_FETCH_FIRST;
        while SQLDrivers(hEnv, Direct, Buffer, BufSize, BufSize, Buffer2, BufSize2, BufSize2) <> SQL_NO_DATA do
        begin
          Direct := SQL_FETCH_NEXT;
          SetLength(Driver, BufSize);
          Move(Buffer^, Driver[1], BufSize * 2);
          if SameText(Driver, SQL_DRIVER) then
          begin
            Result := True;
            Break;
          end;
          BufSize := 1024;
        end;
      finally
        FreeMem(Buffer2);
      end;
    finally
      FreeMem(Buffer);
    end;
  finally
    SQLFreeHandle(SQL_HANDLE_ENV, hEnv);
  end;
end;

procedure TMain.LoadSystemPackage;
begin
  FPackageSystemScan.MultiMask := '*.bpl';
  FPackageSystemScan.MultiPath := ExtractFilePath(Application.ExeName) + 'System\';
  FPackageSystemScan.MultiScan(True);
end;

procedure TMain.Run;
var
  formMainClass: TFormClass;
  frmMain: TForm;
begin
  if IsInstalledDriver() then
  begin
    LoadSystemPackage();
    if ShowLogin() then
    begin
      formMainClass := GlobalMainForm.MainFormClass;
      if formMainClass <> nil then
      begin
        Application.Initialize;
        Application.MainFormOnTaskbar := True;
        Application.CreateForm(formMainClass, frmMain);
        Application.Run;
      end
      else
        Application.MessageBox(PChar(rsModuleNoFound), PChar(rsError), MB_OK or MB_ICONERROR);
    end;
  end
  else
    Application.MessageBox(PChar(Format('Драйвер %s не установлен', [SQL_DRIVER])), 'Ошибка запуска', MB_OK or MB_ICONWARNING);
end;

function TMain.ShowLogin: Boolean;
var
  formLoginClass: TFormClass;
  frmLogin: TForm;
begin
  FLoginForm := TLoginForm.Create(ExtractFilePath(Application.ExeName) + BPL_LOGINFORM_PATH);
  formLoginClass := FLoginForm.LoginFormClass;
  if formLoginClass <> nil then
  begin
    frmLogin := formLoginClass.Create(nil);
    try
      Result := frmLogin.ShowModal = mrOk;
    finally
      frmLogin.Free();
    end;
  end
  else
    Result := False;
  FLoginForm.Free();
end;

initialization
  ReportMemoryLeaksOnShutdown := True;
  GlobalMainForm := TMainForm.Create(ExtractFilePath(Application.ExeName) + BPL_MAINFORM_PATH);

finalization
  GlobalMainForm.Free();

end.
