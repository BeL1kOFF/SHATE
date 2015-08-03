library Project1;

uses
  ActiveX,
  ComObj,
  WebBroker,
  ISAPIApp,
  ISAPIThreadPool,
  oleauto,
  UnitISAPIWebModule in 'UnitISAPIWebModule.pas' {WebModuleISAPI: TWebModule},
  WebUniversalExportIntf in '..\WebUniversalExportIntf.pas',
  WebUniversalExportImpl in '..\WebUniversalExportImpl.pas',
  Unit5MD5 in '..\Unit5MD5.pas',
  Unit3WebManager in '..\Unit3WebManager.pas',
  UnitEventsLog in 'UnitEventsLog.pas',
  UnitConfig in '..\UnitConfig.pas';

{$R *.res}
{$R ResLib.RES}
exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  CoInitFlags := COINIT_MULTITHREADED;
  Application.Initialize;
  Application.CreateForm(TWebModuleISAPI, WebModuleISAPI);
  Application.Run;
end.
