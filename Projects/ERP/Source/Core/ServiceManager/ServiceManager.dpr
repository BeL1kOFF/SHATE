program ServiceManager;

uses
  Vcl.Forms,
  ServiceManager.UI.Main in 'Source\ServiceManager.UI.Main.pas' {frmMain},
  ServiceManager.Logic.Options in 'Source\ServiceManager.Logic.Options.pas',
  ServiceManager.Logic.TServiceManager in 'Source\ServiceManager.Logic.TServiceManager.pas',
  ServiceManager.UI.Message in 'Source\ServiceManager.UI.Message.pas' {frmMessage};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
