unit Logic.TFileLogger;

interface

type
  TFileLogger = record
  private
    class procedure WriteFile(const aText: string); static;
  public
    class var
      Path: string;
    class procedure NewLog; static;
    class procedure Write(const aMessage: string); static;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  System.IOUtils{$IFDEF TEST},
  UI.MainTest,
  System.Classes,
  Vcl.Forms,
  Vcl.Controls
  {$ENDIF};

{ TFileLogger }

class procedure TFileLogger.WriteFile(const aText: string);
var
  f: TextFile;
  fileName: string;
begin
    fileName := IncludeTrailingPathDelimiter(Path) + 'log.log';
    AssignFile(F, fileName, CP_UTF8);
    if TFile.Exists(fileName) then
      Append(F)
    else
      Rewrite(F);
    Writeln(F, FormatDateTime('dd.mm.yyyy hh:nn:ss', Now()) + ': ' + aText);
    {$IFDEF TEST}
    TThread.Synchronize(nil, procedure begin
      if Assigned(Form4) and Assigned(Form4.Memo1) then
      begin
        (FindControl(GlobalHandle) as TForm4).Memo1.Lines.Add(FormatDateTime('dd.mm.yyyy hh:nn:ss', Now()) + ': ' + aText);
      end;
    end);
    {$ENDIF}
    CloseFile(F);
end;

class procedure TFileLogger.NewLog;
begin
  if FileExists(Path + 'log.log') then
    RenameFile(Path + 'log.log', Format(Path + 'log_%s.log', [StringReplace(FormatDateTime('dd.mm.yyyy hh:nn:ss', Now()), ':', '_', [rfReplaceAll])]));
end;

class procedure TFileLogger.Write(const aMessage: string);
begin
  WriteFile(aMessage);
end;

end.
