program ERPService;

uses
  Vcl.SvcMgr,
  ERPService.DataModule in 'Source\ERPService.DataModule.pas' {ERPServer: TService},
  ERPService.Logic.TFileLogger in 'Source\ERPService.Logic.TFileLogger.pas';

{$R *.RES}

begin
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TERPServer, ERPServer);
  Application.Run;
end.
