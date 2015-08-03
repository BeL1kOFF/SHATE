program Project1WindowAgent;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UnitNAV in 'UnitNAV.pas',
  UnitCOMServerNAV in 'UnitCOMServerNAV.pas',
  UnitExtern in 'UnitExtern.pas',
  UnitParser in 'UnitParser.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
