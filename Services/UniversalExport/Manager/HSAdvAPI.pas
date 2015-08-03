unit HSAdvAPI;

interface

uses
 Windows;
function MyCreateProcess(ConstCommandLine, Login, Pass: string):Boolean;
function CreateProcessWithLogonW(const lpUsername: PWideChar;
 const lpDomain: PWideChar; const lpPassword: PWideChar;
 dwLogonFlags: DWORD; const lpApplicationName: PWideChar;
 lpCommandLine: PWideChar; dwCreationFlags: DWORD;
 lpEnvironment: Pointer; const lpCurrentDirectory: PWideChar;
 lpStartupInfo: PStartupInfo;
 lpProcessInfo: PProcessInformation): Boolean; stdcall;

const
 LOGON_WITH_PROFILE = $00000001;
 LOGON_NETCREDENTIALS_ONLY = $00000002;
 LOGON_ZERO_PASSWORD_BUFFER = $80000000;

implementation
uses
 SysUtils;
{ ADVAPI32.DLL functions }
type
 TCreateProcessWithLogonW =
   function(const lpUsername: PWideChar;
   const lpDomain: PWideChar; const lpPassword: PWideChar;
   dwLogonFlags: DWORD; const lpApplicationName: PWideChar;
   lpCommandLine: PWideChar; dwCreationFlags: DWORD;
   lpEnvironment: Pointer; const lpCurrentDirectory: PWideChar;
   lpStartupInfo: PStartupInfo;
   lpProcessInfo: PProcessInformation): Boolean; stdcall;

const
 DllName = 'advapi32.dll';

var
 DllHandle: THandle;
 _CreateProcessWithLogonW: TCreateProcessWithLogonW;

function InitLib: Boolean;
begin
 if DllHandle = 0 then
   if Win32Platform = VER_PLATFORM_WIN32_NT then
   begin
     DllHandle := LoadLibrary(DllName);
     if DllHandle <> 0 then
     begin
       @_CreateProcessWithLogonW := GetProcAddress(DllHandle,
         'CreateProcessWithLogonW');
     end;
   end;
 Result := (DllHandle <> 0);
end;

function NotImplementedBool: Boolean;
begin
 SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
 Result := false;
end;

function CreateProcessWithLogonW(const lpUsername: PWideChar;
 const lpDomain: PWideChar; const lpPassword: PWideChar;
 dwLogonFlags: DWORD; const lpApplicationName: PWideChar;
 lpCommandLine: PWideChar; dwCreationFlags: DWORD;
 lpEnvironment: Pointer; const lpCurrentDirectory: PWideChar;
 lpStartupInfo: PStartupInfo;
 lpProcessInfo: PProcessInformation): Boolean; stdcall;
begin
 if InitLib and Assigned(_CreateProcessWithLogonW) then
   Result := _CreateProcessWithLogonW(lpUsername, lpDomain, lpPassword,
     dwLogonFlags, lpApplicationName, lpCommandLine, dwCreationFlags,
     lpEnvironment, lpCurrentDirectory, lpStartupInfo, lpProcessInfo)
 else
   Result := NotImplementedBool;
end;

function MyCreateProcess(ConstCommandLine, Login, Pass: string):Boolean;
var
 CommandLine: array[0..512] of WideChar;
begin
 StringToWideChar(ConstCommandLine, CommandLine,
   Sizeof(CommandLine) div SizeOf(WideChar));
 if not CreateProcessWithLogonW(PWideChar(login), nil,
   PWideChar(Pass), LOGON_WITH_PROFILE, CommandLine,
   CommandLine, 1, nil, nil, nil, nil) then
   result:=false
 else
 begin
   result:=true;
 end;
end;

initialization
finalization
 if DllHandle <> 0 then
   FreeLibrary(DllHandle);
end.
