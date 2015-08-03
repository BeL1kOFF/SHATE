program ERPAuth;

uses
  ERP.Package.ERPAuthClasses.TAuthMain;

{$R *.res}

var
  main: TAuthMain;

begin
  main := TAuthMain.Create();
  main.Run;
  main.Free();
end.
