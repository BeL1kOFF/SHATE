program DBRevision;

uses
  Vcl.Forms,
  UI.Main in 'Source\Core\UI\UI.Main.pas' {frmMain},
  UI.Profile in 'Source\Core\UI\UI.Profile.pas' {frmProfile},
  Logic.UserFunctions in 'Source\Core\Logic\Logic.UserFunctions.pas',
  UI.TemplateList in 'Source\Core\UI\UI.TemplateList.pas' {frmTemplateList},
  Logic.InterfaceList in 'Source\Core\Logic\Logic.InterfaceList.pas',
  Logic.InterfaceImpl in 'Source\Core\Logic\Logic.InterfaceImpl.pas',
  Logic.Options in 'Source\Core\Logic\Logic.Options.pas',
  UI.CommitRollback in 'Source\Core\UI\UI.CommitRollback.pas' {frmCommitRollback},
  UI.DataBaseForm in 'Source\Core\UI\UI.DataBaseForm.pas' {frmDataBase},
  Logic.TCommitRollback in 'Source\Core\Logic\Logic.TCommitRollback.pas',
  UI.Help in 'Source\Core\UI\UI.Help.pas' {frmHelp},
  UI.InputBox in 'Source\Core\UI\UI.InputBox.pas' {frmInputBox},
  UI.CompareOld in 'Source\Core\UI\UI.CompareOld.pas' {frmCompareOld},
  Logic.TDropTarget in 'Source\Core\Logic\Logic.TDropTarget.pas',
  Logic.ScriptName.InstructionActionImpl in 'Source\Core\Logic\Logic.ScriptName.InstructionActionImpl.pas',
  Logic.ScriptName.TInstructionFactory in 'Source\Core\Logic\Logic.ScriptName.TInstructionFactory.pas',
  Logic.ScriptName.IInstruction in 'Source\Core\Logic\Logic.ScriptName.IInstruction.pas',
  Logic.ScriptName.IInstructionAction in 'Source\Core\Logic\Logic.ScriptName.IInstructionAction.pas',
  Logic.ScriptName.IInstructionFactory in 'Source\Core\Logic\Logic.ScriptName.IInstructionFactory.pas',
  Logic.ScriptName.TInstructionRegisterList in 'Source\Core\Logic\Logic.ScriptName.TInstructionRegisterList.pas',
  Logic.ScriptName.TInstruction in 'Source\Core\Logic\Logic.ScriptName.TInstruction.pas',
  Logic.ScriptName.TInstructionBehavior in 'Source\Core\Logic\Logic.ScriptName.TInstructionBehavior.pas',
  Logic.ScriptName.InstructionImpl in 'Source\Core\Logic\Logic.ScriptName.InstructionImpl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
