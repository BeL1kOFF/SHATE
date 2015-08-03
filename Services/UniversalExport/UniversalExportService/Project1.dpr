program Project1;

uses
  SvcMgr,
  Unit1 in 'Unit1.pas' {_UniversalExportService: TService},
  UnitUniversalExport in 'UnitUniversalExport.pas',
  _CSVReader in '_CSVReader.pas',
  UnitSmtpThread in 'UnitSmtpThread.pas',
  UnitLogging in 'UnitLogging.pas',
  UnitConfig in 'UnitConfig.pas',
  UnitIdSMTP in 'UnitIdSMTP.pas',
  UnitIdSMTPBase in 'UnitIdSMTPBase.pas',
  VCLZip in 'VCLZip.pas',
  KPLib in 'KPLib.pas',
  kpMatch in 'kpMatch.pas',
  kpZipObj in 'kpZipObj.pas',
  VCLUnZip in 'VCLUnZip.pas';

{$R *.RES}
{$R ResEvents.res}
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
  Application.CreateForm(TShateUniversalExportService, ShateUniversalExportService);
  Application.Run;
end.
