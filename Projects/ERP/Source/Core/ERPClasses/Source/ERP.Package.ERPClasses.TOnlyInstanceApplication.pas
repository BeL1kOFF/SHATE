unit ERP.Package.ERPClasses.TOnlyInstanceApplication;

interface

uses
  Winapi.Windows,
  System.SyncObjs;

type
//wrSession - Allow only one instance per login session
//wrDesktop - Allow only one instance on current desktop
//wrTrustee - Allow only one instance for current user
//wrSystem  - Allow only one instance at all (on the whole system)
  TWayToRun = (wrSystem, wrDesktop, wrSession, wrTrustee);

  TOnlyInstanceApplication = class
  private
    FMutex: TMutex;
    FName: string;
    FResult: DWORD;
    FWayToRun: TWayToRun;
    function CreateUniqueName: string;
  public
    constructor Create(aWayToRun: TWayToRun; const aName: string);
    destructor Destroy; override;
    function IsInstancePresent: Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TOnlyInstanceApplication }

constructor TOnlyInstanceApplication.Create(aWayToRun: TWayToRun; const aName: string);
begin
  FWayToRun := aWayToRun;
  FName := aName;
  FMutex := TMutex.Create(nil, False, CreateUniqueName);
  FResult := GetLastError();
end;

function TOnlyInstanceApplication.CreateUniqueName: string;
var
  desktop: HDESK;
  len: DWORD;
  res: BOOL;
  resultError: DWORD;
  buffer, buffer2: TBytes;
  token: THandle;
  uid: LUID;
begin
  case FWayToRun of
    wrSystem:
      Result := FName;
    wrDesktop:
    begin
      desktop := GetThreadDesktop(GetCurrentThreadId());
      res := GetUserObjectInformation(desktop, UOI_NAME, nil, 0, len);
      resultError := GetLastError();
      if (not res) and (resultError = ERROR_INSUFFICIENT_BUFFER) then
      begin
        SetLength(buffer, len);
        GetUserObjectInformation(desktop, UOI_NAME, @buffer[0], len, len);
        Result := FName + '-' + PChar(@buffer[0]);
      end
      else
        Result := FName + '-Win9x';
    end;
    wrSession:
    begin
      res := OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, token);
      if res then
      begin
        GetTokenInformation(token, TokenStatistics, nil, 0, len);
        SetLength(buffer, len);
        GetTokenInformation(token, TokenStatistics, @buffer[0], len, len);
        uid := PTokenStatistics(@buffer[0]).AuthenticationId;
        Result := FName + Format('-%.8x%.8x', [uid.HighPart, uid.LowPart]);
      end
      else
        Result := FName;
    end;
    wrTrustee:
    begin
      SetLength(buffer, 255);
      if GetUserName(@buffer[0], len) then
      begin
        SetLength(buffer, len * 2);
        SetLength(buffer2, 255);
        len := ExpandEnvironmentStrings('%USERDOMAIN%', @buffer2[0], 255);
        SetLength(buffer2, len);
        Result := FName + Format('-%s-%s', [PChar(@buffer2[0]), PChar(@buffer[0])]);
      end
      else
        Result := FName;
    end;
  end;
end;

destructor TOnlyInstanceApplication.Destroy;
begin
  FMutex.Free();
  inherited Destroy();
end;

function TOnlyInstanceApplication.IsInstancePresent: Boolean;
begin
  Result := (FResult = ERROR_ALREADY_EXISTS) or (FResult = ERROR_ACCESS_DENIED);
end;

end.
