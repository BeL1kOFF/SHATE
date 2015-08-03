program GarbageFiles4Update;

uses
  Forms,
  uMain in 'uMain.pas' {main},
  USysGlobal in 'common\USysGlobal.pas',
  _CSVReader in 'common\_CSVReader.pas',
  adoDBUtils in 'common\adoDBUtils.pas',
  uSelectBrandsForm in 'uSelectBrandsForm.pas' {SelectBrandsForm},
  RegExpr in 'RegExpr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tmain, main);
  Application.CreateForm(TSelectBrandsForm, SelectBrandsForm);
  Application.Run;
end.
