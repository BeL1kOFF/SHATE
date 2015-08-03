unit AclSimple;

{ АХТУНГ!!!! СЫРАЯ!!! СОВСЕМ!!! }

interface

uses
  Windows, Messages, Dialogs, SysUtils, Classes,
  AccCtrl, AclAPI;

const
  HEAP_ZERO_MEMORY = $00000008;
  MAXSIZE = 1024;
  INITIAL_SIZE = 256;

type
  ACL_SIZE_INFORMATION = record
    AceCount: DWORD;
    AclBytesInUs: DWORD;
    AclBytesFree: DWORD;
end;

type
  ACE_HEADER = record
    AceType: BYTE;
    AceFlags: BYTE;
    AceSize: WORD;
end;

type
  ACCESS_ALLOWED_ACE = record
    Header: ACE_HEADER;
    Mask: ACCESS_MASK;
    SidStart: DWORD;
end;
PACCESS_ALLOWED_ACE = ^ACCESS_ALLOWED_ACE;

procedure ConvertSidToStringSid(SID: PSID; var StringSid: LPSTR); stdcall;
  external advapi32 name 'ConvertSidToStringSidA';

procedure AclEnumerateUsers(AFile: string; List: TStrings);
procedure AclAddUser(AFile: string; AUser: string);

function CheckFileAccessRights(AFile, AUser: String): Boolean;
function GetComputerNetName: string;

implementation

procedure Rollback(ErrCode: integer);
begin
  ShowMessage(SysErrorMessage(ErrCode));
  Abort;
end;

procedure AclEnumerateUsers(AFile: string; List: TStrings);
var
  pSD: PSecurityDescriptor;
  bDaclPresent, bDaclDefaulted: Bool;
  dwSize: DWORD;
  Index: Cardinal;
  AclSizeInfo: ACL_SIZE_INFORMATION;
  paAce: PACCESS_ALLOWED_ACE;
  ppAce: Pointer;
  pcUser, pcDomain: PChar;
  dwAccBufferSize, dwDomainBufferSize, dwSIDType: Cardinal;
begin
  // Резервируем область памяти для имени пользователя
  GetMem(pcUser, INITIAL_SIZE);
  // Резервируем область памяти для имени домена
  GetMem(pcDomain, INITIAL_SIZE);
  try
    // Резервируем область памяти для дескриптора безопасности
  	pSD := HeapAlloc(GetProcessHeap, HEAP_ZERO_MEMORY, MAXSIZE);
    // Получаем саму структуру PSECURITY_DESCRIPTOR
    if not GetFileSecurity(PChar(AFile), DACL_SECURITY_INFORMATION, pSD, MAXSIZE, dwSize) then
	    RollBack(GetLastError);
    // Получаем структуру DACL для PSecurityDescriptor --> Dacl: PACL
    if not GetSecurityDescriptorDacl(pSD, bDaclPresent, pSD.Dacl, bDaclDefaulted) then
	    RollBack(GetLastError);
    // Получаем ACL информацию по DACL
    if not GetAclInformation(pSD.Dacl^, @AclSizeInfo, SizeOf(AclSizeInfo), AclSizeInformation) then
      RollBack(GetLastError);
    // Проход по всем полученным ACL входениям
    for Index := 0 to AclSizeInfo.AceCount - 1 do
    begin
      // Пытаемся получить указатель на точку контроля в ppAce
      if GetAce(pSD.Dacl^, Index, ppAce) then
      begin
        // Приводим структуру к указателю
        paAce := ppAce;
        // Задаем длину буфера для имени и домена, так как после получения данных
        // он уменьшится на длину полученных данных
		    dwAccBufferSize := INITIAL_SIZE;
		    dwDomainBufferSize := INITIAL_SIZE;
        // Смотрим данные по преложенному SID идентификатору
        if LookupAccountSid(
        	nil, // для локальной станции
          @paAce^.sidstart, // указатель на SID
          pcUser,
          dwAccBufferSize,
          pcDomain,
          dwDomainBufferSize,
          dwSIDType)
        then
          List.Add(Format('%s\%s', [pcDomain, pcUser]))
        else
          RollBack(GetLastError);
      end else
        RollBack(GetLastError);
    end;
  finally
    HeapFree(GetProcessHeap, 0, pSD);
    FreeMem(pcUser);
    FreeMem(pcDomain);
  end;
end;

procedure AclAddUser(AFile: string; AUser: string);
var
  pSD: PSECURITY_DESCRIPTOR;
  exAc: EXPLICIT_ACCESS;
  bDaclPresent, bDaclDefaulted: Bool;
  OldAcl, NewAcl: PACL;
  ErrCode, dwSize, dwDomain: DWORD;
  psidEveryOne: PSID;
  pcDomainName, pcUserName: PChar;
  SNU: SID_NAME_USE;
begin
  try
    // Резервируем область памяти для дескриптора безопасности
  	pSD := HeapAlloc(GetProcessHeap, HEAP_ZERO_MEMORY, MAXSIZE);
    // Получаем саму структуру PSECURITY_DESCRIPTOR
    if not GetFileSecurity(PChar(AFile), DACL_SECURITY_INFORMATION, pSD, MAXSIZE, dwSize) then
	    RollBack(GetLastError);
    // Получаем структуру DACL для PSecurityDescriptor --> OldAcl
    if not GetSecurityDescriptorDacl(pSD, bDaclPresent, OldAcl, bDaclDefaulted) then
	    RollBack(GetLastError);
    // Резервируем область памяти для имени пользователя
    GetMem(pcUserName, INITIAL_SIZE);
    // Резервируем область памяти для имени домена
    GetMem(pcDomainName, INITIAL_SIZE);
    // Резервируем область памяти для SID пользователя
    GetMem(psidEveryOne, INITIAL_SIZE);
    // Пытаемся получить указатель на SID для пользователя
    if not LookupAccountName(nil, PChar(AUser), psidEveryOne, dwSize, pcDomainName, dwDomain, SNU) then
	    RollBack(GetLastError);
    // Тестируем перевод полученного SID в его строковое представление
    ConvertSidToStringSid(psidEveryOne, pcUserName);
    // Тестируем получение имени пользователя по заданному SID
    if not LookupAccountSID(nil, psidEveryOne, pcUserName, dwSize, pcDomainName, dwDomain, SNU) then
 	    RollBack(GetLastError);

    // Дальше начинаются пляски с бубном, перебор всех возможныз вариантов
    //    ZeroMemory(@exAc, sizeof(EXPLICIT_ACCESS));
    //    BuildExplicitAccessWithNameA(@exAc, psidEveryOne, MAXIMUM_ALLOWED, GRANT_ACCESS, INHERIT_ONLY);
    //    BuildTrusteeWithSid(@exAc.Trustee, psidEveryOne);
    //    BuildExplicitAccessWithName(@exAc, PChar(AUser), MAXIMUM_ALLOWED, GRANT_ACCESS, INHERIT_ONLY);
    //    exAc.grfAccessPermissions := MAXIMUM_ALLOWED;
    //    exAc.grfAccessMode := SET_ACCESS;
    //    exAc.grfInheritance := NO_INHERITANCE;
    //    exAc.Trustee.TrusteeForm := TRUSTEE_IS_SID;
    //    exAc.Trustee.TrusteeType := TRUSTEE_IS_USER;
    //    exAc.Trustee.ptstrName := psidEveryOne;

    // Тут всегда возникает ошибка 87, хотя если смотреть по документации MSDN - все парамтеры
    // передаются верно :(((
    ErrCode := SetEntriesInAclA(1, @exAc, @OldAcl, NewAcl);
    if (ErrCode <> ERROR_SUCCESS) then RollBack(ErrCode);

    if not InitializeSecurityDescriptor(@pSD, SECURITY_DESCRIPTOR_REVISION) then
      RollBack(getLastError);

    if not SetSecurityDescriptorDacl(@pSD, True, NewAcl, False) then
      RollBack(getLastError);

    if not SetFileSecurity(PChar(AFile), DACL_SECURITY_INFORMATION, @pSD) then
      RollBack(GetLastError)
      
  finally
    HeapFree(GetProcessHeap, 0, pSD);
  end;
end;

function CheckFileAccessRights(AFile, AUser: String): Boolean;
      var
        k: integer;
        ACEList: TStringList;
begin
  RESULT:=False;
  if AFile='' then exit;

  ACEList:=TStringList.Create;
  try
    AclEnumerateUsers(AFile,ACEList);

    for k := 0 to ACEList.Count - 1 do
     if UpperCase(ACEList[k])=UpperCase(AUser) then RESULT:=True;
  finally
    ACEList.Free;
  end;
end;

function GetComputerNetName: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := buffer
  else
    Result := ''
end;

end.
