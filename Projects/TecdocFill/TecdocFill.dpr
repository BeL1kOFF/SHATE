program TecdocFill;

uses
  Forms,
  Unit1 in 'Unit1.pas' {FormMain},
  USysGlobal in '..\common\USysGlobal.pas',
  _CSVReader in '..\common\_CSVReader.pas',
  adoDBUtils in '..\common\adoDBUtils.pas',
  MD5 in '..\common\MD5.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
