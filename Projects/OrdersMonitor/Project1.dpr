program Project1;

uses
  Forms,
  Windows,
  Unit1 in 'Unit1.pas' {Form1},
  UnitConfig in 'UnitConfig.pas',
  FullScreenUnit in 'FullScreenUnit.pas',
  UnitTelevision in 'UnitTelevision.pas',
  IdCustomHTTPServer in 'IdCustomHTTPServer.pas';

{$R *.res}

begin

  //GetThreadDesktop(GetCurrentThreadId());


  Application.Initialize;
  Application.MainFormOnTaskbar := True;
//
//  DESKTOPGENERAL := GetDesktopWindow;
//  DESKTOP:=CreateDesktop(PChar('Monitor0'),nil,nil,0,DESCTOPOPT,nil);
//
//
//  SwitchDesktop(DESKTOP);
//  SetThreadDesktop(DESKTOP);
  Application.CreateForm(TForm1, Form1);
  Application.Run;

//  SwitchDesktop(DESKTOPGENERAL);
//  CloseDeskTop(DESKTOP);
end.
