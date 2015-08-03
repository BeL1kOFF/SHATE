unit ERP.Package.ERPAuthClasses.TAuthMain;

interface

type
  TAuthMain = class
  public
    procedure Run;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  Vcl.Forms,

  ERP.Package.ERPAuthClasses.TAuthMainForm;

const
  BPL_MAINFORM_PATH = 'System\ERP.Package.AuthMainForm.bpl';

var
  GlobalMainForm: TAuthMainForm;

resourcestring
  rsModuleNoFound = 'Модуль главной формы не найден!';
  rsError = 'Ошибка';

{ TAuthMain }

procedure TAuthMain.Run;
var
  formMainClass: TFormClass;
  frmMain: TForm;
begin
  formMainClass := GlobalMainForm.MainFormClass;
  if formMainClass <> nil then
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(formMainClass, frmMain);
    Application.Run;
  end
  else
    Application.MessageBox(PChar(rsModuleNoFound), PChar(rsError), MB_OK or MB_ICONERROR);
end;

initialization
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  GlobalMainForm := TAuthMainForm.Create(ExtractFilePath(Application.ExeName) + BPL_MAINFORM_PATH);

finalization
  GlobalMainForm.Free();

end.
