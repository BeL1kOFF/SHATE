unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs, Registry, ActiveX,
  UnitPerco;

type
  TPercoIntegrationService = class(TService)
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceBeforeUninstall(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceExecute(Sender: TService);
  private
    { Private declarations }
    SleepInterval: integer;
    DebugMode: boolean;
    RegKey: string;
    procedure Config;
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  PercoIntegrationService: TPercoIntegrationService;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  PercoIntegrationService.Controller(CtrlCode);
end;

procedure TPercoIntegrationService.Config;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ); //
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    // Чтение данных
    if Reg.KeyExists(Self.RegKey) then
    try
      if Reg.OpenKeyReadOnly(Self.RegKey) then
      try
        Self.SleepInterval := Reg.ReadInteger('Interval');
        Self.DebugMode := Reg.ReadBool('DebugMode');
      finally
        Reg.CloseKey;
      end;
    except on E: Exception do
      Self.LogMessage(E.Message);
    end;
  finally
    FreeAndNil(Reg);
  end;
end;

function TPercoIntegrationService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TPercoIntegrationService.ServiceAfterInstall(Sender: TService);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_ALL_ACCESS);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    // Создаём системный лог для себя
    Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\Eventlog\Application\' + Name, True);
    try
      Reg.WriteString('EventMessageFile', ParamStr(0));
      Reg.WriteInteger('TypesSupported', $7);
          // Прописываем себе описание
    //Reg.WriteString('\SYSTEM\CurrentControlSet\Services\' + Name, 'Description', 'Служба ... .');
    finally
      Reg.CloseKey;
    end;

    if Reg.KeyExists('\SYSTEM\CurrentControlSet\Services\' + Name) then
      if Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Name + '\Configuration', true) then
      try
        Reg.WriteInteger('Interval',15);
        Reg.WriteBool('DebugMode', true);
      finally
        Reg.CloseKey;
      end;


  finally
    FreeAndNil(Reg);
  end;


end;

procedure TPercoIntegrationService.ServiceBeforeUninstall(Sender: TService);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_ALL_ACCESS);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    // Удалим свой системный лог
    Reg.DeleteKey('\SYSTEM\CurrentControlSet\Services\Eventlog\Application\' + Name);
    Reg.DeleteKey('\SYSTEM\CurrentControlSet\Services\' + Name + '\Configuration');
  finally
    FreeAndNil(Reg);
  end;
end;

procedure TPercoIntegrationService.ServiceCreate(Sender: TObject);

begin
  Self.SleepInterval := 15;

  Self.RegKey := '\SYSTEM\CurrentControlSet\Services\' + Name + '\Configuration';

  Self.Config;


  PercoCOM := TPercoCOMProcessor.Create();  { TODO : избавиться в конструкторе от бесполезного аргумента }
  if PercoCOM.Text <> '' then Self.LogMessage(PercoCOM.Text);

try
    PercoImport := TPercoDataLoader.Create;
except on E: Exception do
  Self.LogMessage(E.Message);
end;

  ScanDaemon := TPercoDataScaner.Create(0); //создаём сканер в основном потоке службы

end;

procedure TPercoIntegrationService.ServiceDestroy(Sender: TObject);
begin
 FreeAndNil(ScanDaemon);
 FreeAndNil(PercoImport);
 FreeAndNil(PercoCOM);
end;

procedure TPercoIntegrationService.ServiceExecute(Sender: TService);
var
  t0, ts: TDateTime;
begin
  Self.LogMessage('Служба запущена',EVENTLOG_INFORMATION_TYPE);
  ScanDaemon.Print(Format('Сканирование "%s" запущено',[ScanDaemon.ScanDirectory]));
//Single Thread Service Activity implementation
  t0 := 0;
  repeat
    ServiceThread.ProcessRequests(False);
    Self.ReportStatus;
    ts := Now();
    Sleep(1000);
    if (ts-t0)>(Self.SleepInterval/86400)  then
    try
      t0 := ts;
      Self.Config;
      ScanDaemon.Debug := Self.DebugMode;
      if ScanDaemon.doScenario then
        ScanDaemon.ScenAct;
      ScanDaemon.Scan; //run in main thread
    except on E: Exception do
      Self.LogMessage(Format('Runtime scan error with message: "%s"',[E.Message]));
    end;

  until Self.Terminated;
  ScanDaemon.Print(Format('Сканирование "%s" остановлено',[ScanDaemon.ScanDirectory]));
  Self.LogMessage('Служба остановлена',EVENTLOG_INFORMATION_TYPE);
end;

procedure TPercoIntegrationService.ServiceStart(Sender: TService; var Started: Boolean);
const FILEINIDEFAULT = 'PercoIntegrationService.ini';
var fileini: string;
begin
try
    Self.LogMessage('Инициализация', EVENTLOG_INFORMATION_TYPE);
    CoInitializeEx(nil, 0);
    Started := False;
  
    //Sleep(2*Self.SleepInterval*1000);
  
  
    //***
    fileini := ChangeFileExt(Paramstr(0),'.ini');
    if fileini=Paramstr(0) then
      fileini := FILEINIDEFAULT;
  
    PercoCom.Init(fileini);
    PercoImport.Init(fileini);
    ScanDaemon.Init(fileini);
  
  
    //***
    Started := True;
except on E: Exception do
  Self.LogMessage('Ошибка инициализации: '+E.Message);
end;

end;

procedure TPercoIntegrationService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  //Termination All Threads
  Stopped := True;
  CoUninitialize();
end;

end.
