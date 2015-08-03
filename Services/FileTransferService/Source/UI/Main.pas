unit Main;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.SvcMgr,
  Data.DB,
  Data.Win.ADODB,
  FileTransfer.Logic.TSenderAdapterList;

type
  TsFileTransferService = class(TService)
    ADOConnection: TADOConnection;
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
  private
    FSenderAdapterList: TSenderAdapterList;
    procedure Init;
  public
    function GetServiceController: TServiceController; override;
  end;

var
  sFileTransferService: TsFileTransferService;

implementation

uses
  Winapi.ActiveX,
  FileTransfer.Logic.TFileLogger,
  FileTransfer.Logic.TDllScan;

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  sFileTransferService.Controller(CtrlCode);
end;

function TsFileTransferService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TsFileTransferService.Init;
begin
  FSenderAdapterList := TSenderAdapterList.Create(ADOConnection);
  FSenderAdapterList.Refresh();
end;

procedure TsFileTransferService.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
  FSenderAdapterList.Continue;
end;

procedure TsFileTransferService.ServicePause(Sender: TService;
  var Paused: Boolean);
begin
  FSenderAdapterList.Pause;
end;

procedure TsFileTransferService.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
  try
    TFileLogger.Path := ExtractFilePath(ParamStr(0));
    TFileLogger.ADOConnection := ADOConnection;
    TFileLogger.NewLog();
    CoInitializeEx(nil, 0);
    ADOConnection.Connected := True;
    TDllScan.Path := ExtractFilePath(ParamStr(0));
    TFileLogger.Write('Сервис стартует...');
    Init();
    TFileLogger.Write('Сервис стартовал.');
  except on E: Exception do
  begin
    TFileLogger.Write(E.Message);
    raise;
  end;
  end;
end;

procedure TsFileTransferService.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin
  TFileLogger.Write('Сервис останавливается...');
  FSenderAdapterList.Free();
  TDllScan.Close();
  CoUninitialize();
  TFileLogger.Write('Сервис остановился.');
  Stopped := True;
end;

end.
