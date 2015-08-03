program OrdSrv_IMAP;

uses
  SvcMgr,
  uMain in 'uMain.pas' {OrdServiceIMAP: TService},
  uIMAPThread in 'uIMAPThread.pas',
  MD5 in '..\..\common\MD5.pas',
  adoDBUtils in '..\..\common\adoDBUtils.pas',
  uSmtpThread in 'uSmtpThread.pas',
  uWSThread in 'uWSThread.pas',
  _CSVReader in '..\..\common\_CSVReader.pas',
  uSmtpThreadRe in 'uSmtpThreadRe.pas',
  USysGlobal in '..\..\common\USysGlobal.pas',
  WS in 'WS.pas';

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
  Application.CreateForm(TOrdServiceIMAP, OrdServiceIMAP);
  Application.Run;
end.
