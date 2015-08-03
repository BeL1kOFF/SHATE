program AnalogCodeCC;

uses
  Vcl.Forms,
  AnalogCodeCC.UI.Main in 'Source\Core\UI\AnalogCodeCC.UI.Main.pas' {frmMain},
  AnalogCodeCC.Logic.OptionsXML in 'Source\Core\Logic\AnalogCodeCC.Logic.OptionsXML.pas',
  AnalogCodeCC.Logic.ISQLCursor in 'Source\Core\Logic\AnalogCodeCC.Logic.ISQLCursor.pas',
  AnalogCodeCC.Logic.HelpFunc in 'Source\Core\Logic\AnalogCodeCC.Logic.HelpFunc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
