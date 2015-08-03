program FileTransfer;

uses
//  FastMM4,
  Vcl.SvcMgr,
  Main in 'UI\Main.pas' {sFileTransferService: TService},
  FileTransfer.Logic.TThreadAdapter in 'Logic\FileTransfer.Logic.TThreadAdapter.pas',
  FileTransfer.Logic.TSenderAdapterList in 'Logic\FileTransfer.Logic.TSenderAdapterList.pas',
  FileTransfer.Logic.TDBQuery in 'Logic\FileTransfer.Logic.TDBQuery.pas',
  FileTransfer.Logic.TFileLogger in 'Logic\FileTransfer.Logic.TFileLogger.pas',
  FileTransfer.Logic.TCustomReceiverAdapter in 'Logic\FileTransfer.Logic.TCustomReceiverAdapter.pas',
  FileTransfer.Logic.TReceiverAdapterList in 'Logic\FileTransfer.Logic.TReceiverAdapterList.pas',
  FileTransfer.Logic.TDllScan in 'Logic\FileTransfer.Logic.TDllScan.pas',
  FileTransfer.Logic.TCustomSenderAdapter in 'Logic\FileTransfer.Logic.TCustomSenderAdapter.pas';

{$R *.RES}

begin
  // Windows 2003 Server requires StartServiceCtrlDispatcher to be
  // called before CoRegisterClassObject, which can be called indirectly
  // by Application.Initialize. TServiceApplication.DelayInitialize allows
  // Application.Initialize to be called from TService.Main (after
  // StartServiceCtrlDispatcher has been called).
  //
  // Delayed initialization of the Application object may affect
  // events which then occur prior to initialization, such as
  // TService.OnCreate. It is only recommended if the ServiceApplication
  // registers a class object with OLE and is intended for use with
  // Windows 2003 Server.
  //
  // Application.DelayInitialize := True;
  //
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TsFileTransferService, sFileTransferService);
  Application.Run;
end.
