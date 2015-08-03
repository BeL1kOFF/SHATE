program ERP;

uses
  ERP.Package.ERPClasses.ExceptionHack,
  ERP.Package.ERPClasses.TMain,
  ERP.ComServ in 'Source\ERP.ComServ.pas',
  ERP.TAsyncPlugProt in 'Source\ERP.TAsyncPlugProt.pas';

{$R *.res}

var
  Main: TMain;
  MainComServ: TMainComServ;

begin
  MainComServ := TMainComServ.Create();
  try
    MainComServ.AppStart();
    Main := TMain.Create();
    try
      if not Main.IsExecuted() then
        Main.Run();
    finally
      MainComServ.AppStop();
      Main.Free();
    end;
  finally
    MainComServ.Free();
  end;
end.
