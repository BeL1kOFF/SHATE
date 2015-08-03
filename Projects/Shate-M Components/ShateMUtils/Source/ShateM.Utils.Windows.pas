unit ShateM.Utils.Windows;

interface

uses
  Winapi.Windows;

type
  {$MINENUMSIZE 4}
  EXTENDED_NAME_FORMAT = (enfNameUnknown = 0, enfNameFullyQualifiedDN = 1, enfNameSamCompatible = 2, enfNameDisplay = 3,
                          enfNameUniqueId = 6, enfNameCanonical = 7, enfNameUserPrincipal = 8, enfNameCanonicalEx = 9,
                          enfNameServicePrincipal = 10, enfNameDnsDomain = 12);
  {$MINENUMSIZE 1}
  TExtendedNameFormat = type EXTENDED_NAME_FORMAT;

  TWindows = record
  public
    class function GetUserName: string; static;
    class function GetUserNameEx(const aNameFormat: TExtendedNameFormat): string; static;
    class function GetActiveWindowCaption(): string; static;
  end;

implementation

uses
  System.SysUtils;

  function GetUserNameEx(NameFormat: TExtendedNameFormat; lpNameBuffer: LPTSTR; lpnSize: PULONG): BOOL; stdcall; external 'secur32.dll' Name 'GetUserNameExW';

{ TWindows }

class function TWindows.GetActiveWindowCaption(): string;
var
  tmpActiveWindowHandle: HWND;
  tmpNameBuffer: PChar;
begin
  Result := EmptyStr;
  tmpNameBuffer := StrAlloc(1000);
  try
    tmpActiveWindowHandle := GetForegroundWindow();
    if GetWindowText(tmpActiveWindowHandle, tmpNameBuffer, StrBufSize(tmpNameBuffer)) = 0 then
    begin
      Exit;
    end;
    Result := tmpNameBuffer;
  finally
    StrDispose(tmpNameBuffer);
  end;
end;

class function TWindows.GetUserName: string;
var
  SizeBuffer: DWORD;
  ResultBoolean: BOOL;
  LastError: DWORD;
begin
  SetLastError(ERROR_SUCCESS);
  SizeBuffer := 0;
  ResultBoolean := Winapi.Windows.GetUserName(nil, SizeBuffer);
  LastError := GetLastError();
  if (not ResultBoolean) and (LastError = ERROR_INSUFFICIENT_BUFFER) then
  begin
    SetLength(Result, SizeBuffer);
    ResultBoolean := Winapi.Windows.GetUserName(PChar(Result), SizeBuffer);
    if ResultBoolean then
      SetLength(Result, SizeBuffer - 1)
    else
      Result := EmptyStr;
  end
  else
    Result := EmptyStr;
end;

class function TWindows.GetUserNameEx(const aNameFormat: TExtendedNameFormat): string;
var
  SizeBuffer: ULONG;
  ResultBoolean: BOOL;
  LastError: DWORD;
begin
  SetLastError(ERROR_SUCCESS);
  SizeBuffer := 0;
  ResultBoolean := ShateM.Utils.Windows.GetUserNameEx(aNameFormat, nil, @SizeBuffer);
  LastError := GetLastError();
  if (not ResultBoolean) and (LastError = ERROR_MORE_DATA) then
  begin
    SetLength(Result, SizeBuffer);
    ResultBoolean := ShateM.Utils.Windows.GetUserNameEx(aNameFormat, PChar(Result), @SizeBuffer);
    if ResultBoolean then
      SetLength(Result, SizeBuffer)
    else
      Result := EmptyStr;
  end
  else
    Result := EmptyStr;
end;

end.
