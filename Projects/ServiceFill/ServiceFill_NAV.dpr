program ServiceFill_NAV;

uses
  Forms,
  uMain in 'uMain.pas' {FormMain},
  uReleaseInfo in 'uReleaseInfo.pas' {FormReleaseInfo},
  adoDBUtils in 'common\adoDBUtils.pas',
  USysGlobal in 'common\USysGlobal.pas',
  _CSVReader in 'common\_CSVReader.pas',
  OpenDirDialog in 'common\OpenDirDialog.pas',
  ReleaseProp in 'ReleaseProp.pas' {Form1},
  uOutParamsSite2 in 'uOutParamsSite2.pas' {OutParamsSiteForm2},
  uOutParams in 'uOutParams.pas' {OutParamsForm},
  uSrezParams in 'uSrezParams.pas' {SrezParamsForm};

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
