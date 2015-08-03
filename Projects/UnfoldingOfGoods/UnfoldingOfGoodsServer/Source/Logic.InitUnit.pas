unit Logic.InitUnit;

interface

uses
  System.SysUtils;

type

  ILogMethod = interface
  ['{F8750EB2-259C-4FE5-96F8-91CDE6D145DE}']
  end;

  TLog = class
  public
    class function IsLogger: Boolean;
    class function IsLogMethod: Boolean;
    class function IsFile: Boolean;
    class function IsCodeSite: Boolean;
  public
    class function LogMethod(aClass: TClass; const aName: string): ILogMethod;
    class procedure LogError(aClass: TClass; const aMessage: string);
    class procedure LogException(aException: Exception);
    class procedure LogMessage(aClass: TClass; const aMessage: string);
  end;

implementation

uses
  Winapi.Windows,
  System.SyncObjs,
  System.Generics.Collections,
  System.StrUtils,
  Vcl.Graphics,
  CodeSiteLogging,
  Logic.TFileLogger,
  Logic.Options;

type
  TLogMethod = class(TInterfacedObject, ILogMethod)
  private
    class var
      FCounter: Integer;
  private
    FClass: TClass;
    FName: string;
    function GetClassName: string;
    class constructor Create;
  public
    constructor Create(aClass: TClass; const aName: string);
    destructor Destroy; override;
  end;

var
  ClassColorList: TDictionary<TClass, Cardinal>;
  LogLock: TCriticalSection;

const
  COLOR_TABLE: array[0..9] of TColor = (clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal, clGray, clRed, clMoneyGreen);

procedure SetCategory(aClass: TClass);
var
  ColorRGB: Cardinal;
begin
  if Assigned(aClass) then
    CodeSite.Category := aClass.ClassName
  else
    CodeSite.Category := '';
  if not ClassColorList.ContainsKey(aClass) then
  begin
    if ClassColorList.Count > Length(COLOR_TABLE) - 1 then
      ColorRGB := RGB(Random(256), Random(256), Random(256))
    else
      ColorRGB := COLOR_TABLE[ClassColorList.Count];
    ClassColorList.Add(aClass, ColorRGB);
  end
  else
    ColorRGB := ClassColorList.Items[aClass];
  CodeSite.CategoryFontColor := ColorRGB;
end;

{ TLogMethod }

constructor TLogMethod.Create(aClass: TClass; const aName: string);
begin
  LogLock.Acquire();
  try
    Inc(FCounter);
    FClass := aClass;
    FName := aName;
    if TLog.IsFile then
      TFileLogger.Write(Format('%d: %s', [GetCurrentThreadId(), DupeString('--', FCounter) + GetClassName() + FName]));
    if TLog.IsCodeSite then
    begin
      try
        SetCategory(FClass);
        CodeSite.EnterMethod(GetClassName() + FName);
      except
      end;
    end;
  finally
    LogLock.Release();
  end;
end;

class constructor TLogMethod.Create;
begin
  FCounter := 0;
end;

destructor TLogMethod.Destroy;
begin
  LogLock.Acquire();
  try
    if TLog.IsFile then
      TFileLogger.Write(Format('%d: %s', [GetCurrentThreadId(), DupeString('--', FCounter) + GetClassName() + FName]));
    if TLog.IsCodeSite then
    begin
      try
        SetCategory(FClass);
        CodeSite.ExitMethod(GetClassName() + FName);
      except
      end;
    end;
    Dec(FCounter);
  finally
    LogLock.Release();
  end;
  inherited Destroy();
end;

function TLogMethod.GetClassName: string;
begin
  if Assigned(FClass) then
    Result := FClass.ClassName + '.'
  else
    Result := '';
end;

{ TLog }

class function TLog.IsCodeSite: Boolean;
begin
  LogLock.Acquire();
  try
    Result := TOptions.Options.Logging.ToCodeSite;
  finally
    LogLock.Release();
  end;
end;

class function TLog.IsFile: Boolean;
begin
  LogLock.Acquire();
  try
    Result := TOptions.Options.Logging.ToFile;
  finally
    LogLock.Release();
  end;
end;

class function TLog.IsLogger: Boolean;
begin
  LogLock.Acquire();
  try
    Result := TOptions.Options.Logging.IsLog;
  finally
    LogLock.Release();
  end;
end;

class function TLog.IsLogMethod: Boolean;
begin
  LogLock.Acquire();
  try
    Result := TOptions.Options.Logging.IsLogMethod;
  finally
    LogLock.Release();
  end;
end;

class procedure TLog.LogError(aClass: TClass; const aMessage: string);
var
  ClassName: string;
begin
  if not IsLogger then
    Exit;
  LogLock.Acquire();
  try
    if Assigned(aClass) then
      ClassName := aClass.ClassName + ': '
    else
      ClassName := '';
    if IsFile then
      TFileLogger.Write(Format('%d: %s', [GetCurrentThreadId(), 'Error: ' + ClassName + aMessage]));
    if IsCodeSite then
      try
        CodeSite.SendError(ClassName + aMessage);
      except
      end;
  finally
    LogLock.Release();
  end;
end;

class procedure TLog.LogException(aException: Exception);
begin
  if not IsLogger then
    Exit;
  LogLock.Acquire();
  try
    if IsFile then
      TFileLogger.Write(Format('%d: %s', [GetCurrentThreadId(), 'Exception: ' + aException.ToString()]));
    if IsCodeSite then
      try
        CodeSite.SendException(aException);
      except
      end;
  finally
    LogLock.Release();
  end;
end;

class procedure TLog.LogMessage(aClass: TClass; const aMessage: string);
var
  ClassName: string;
begin
  if not IsLogger then
    Exit;
  LogLock.Acquire();
  try
    SetCategory(aClass);
    if Assigned(aClass) then
      ClassName := aClass.ClassName + ': '
    else
      ClassName := '';
    if IsFile then
      TFileLogger.Write(Format('%d: %s', [GetCurrentThreadId(), ClassName + aMessage]));
    if IsCodeSite then
      try
        CodeSite.Send(ClassName + aMessage);
      except
      end;
  finally
    LogLock.Release();
  end;
end;

class function TLog.LogMethod(aClass: TClass; const aName: string): ILogMethod;
begin
  Result := nil;
  if (not IsLogger) or (not IsLogMethod) then
    Exit;
  Result := TLogMethod.Create(aClass, aName);
end;

function AssignOptions: Boolean;
var
  Options: IXMLOptionsType;
  OptionsFilePath: string;
begin
  OptionsFilePath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Options.xml';
  if not FileExists(OptionsFilePath) then
  begin
    MessageBox(0, PChar(Format('Файл %s не найден.', [OptionsFilePath])), 'Ошибка', MB_OK or MB_ICONERROR);
    Exit(False);
  end;
  Options := LoadOptions(OptionsFilePath);
  TOptions.AssignOptions(Options);
  Result := True;
end;

initialization
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Randomize();
  if not AssignOptions() then
    Halt(0);
  TFileLogger.Path := ExtractFilePath(ParamStr(0));
  if not ((FindCmdLineSwitch('Install', True)) or
          (FindCmdLineSwitch('UnInstall', True))) then
    TFileLogger.NewLog();
  ClassColorList := TDictionary<TClass, Cardinal>.Create();
  LogLock := TCriticalSection.Create();
  try
    if not ((FindCmdLineSwitch('Install', True)) or
            (FindCmdLineSwitch('UnInstall', True))) then
      CodeSite.ConnectUsingTcp();
  except
  end;

finalization
  LogLock.Free();
  ClassColorList.Free();

end.
