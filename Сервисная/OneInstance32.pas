unit OneInstance32;

interface

const
  PROCESS_TERMINATE = $0001;

function OneInstance(const aUnicName: string): Boolean;
function OneInstance2(const aUnicName, aProcName: string; aAppHandle: THandle; aActivatePrev: Boolean = True): Boolean;
function isMoreThenOneProcessShate: boolean;
function KillTask(ExeFileName: string): Integer;

implementation

uses
  Windows, Tlhelp32, SysUtils;
var
  g_hAppMutex: THandle;
  HM: THandle;
  g_FHandle: THandle;

function KillTask(ExeFileName: string): Integer;
  const PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName))
        or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
    begin
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE,
                                                     BOOL(0),
                                                     FProcessEntry32.th32ProcessID),
                                                     0
                                         )
                       );
      break;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;
   
function isMoreThenOneProcessShate: boolean;
begin
  HM := OpenMutex(MUTEX_ALL_ACCESS, false, 'MyOwnMutex');
  Result := (HM <> 0);
  if HM = 0 then
    HM := CreateMutex(nil, false, 'MyOwnMutex');
end;


//through Mutex
function OneInstance(const aUnicName: string): Boolean;
var
  dw: Longint;
begin
  Result := False;
  g_hAppMutex := CreateMutex(nil, False, PChar(aUnicName));

  if g_hAppMutex > 0 then
  begin
    if GetLastError() <> ERROR_ALREADY_EXISTS then
    begin
      dw := WaitForSingleObject(g_hAppMutex, 0);
      Result := (dw <> WAIT_TIMEOUT);
    end;
  end;
end; // OneInstance

//through FileMapping
function OneInstance2(const aUnicName, aProcName: string; aAppHandle: THandle; aActivatePrev: Boolean): Boolean;
var
  FHandle, TmpHandle: THandle;
  FMemory: Pointer;
Begin
  Result := False;

  // Создаем в страничной памяти "файл" с уникальным
  // именем aUnicName, проецируем его в свое адресное пространство
  // и проверяем, был ли он создан или просто открыт.
  FHandle := CreateFileMapping($FFFFFFFF, Nil, PAGE_READWRITE, 0, SizeOf(THandle), PChar(aUnicName));
  FMemory := MapViewOfFile(FHandle, FILE_MAP_WRITE, 0, 0, SizeOf(THandle));
  If GetLastError = ERROR_ALREADY_EXISTS then //если уже есть
  begin
    Move(FMemory^, TmpHandle, SizeOf(THandle)); //считываем handle предыдущего приложения
//    if IsWindowVisible(TmpHandle) then
    begin
      if IsIconic(TmpHandle) then
        ShowWindow(TmpHandle, SW_RESTORE);
      SetForegroundWindow(TmpHandle)//восстанавливаем его
//        KillTask(aProcName);
      //FlashWindow(TmpHandle, False);
    end
  end else //если это приложение первое
  begin
    Result := True;
    TmpHandle := aAppHandle;
    Move(TmpHandle, FMemory^, SizeOf(THandle)); //записываем handle этого приложения
    g_FHandle := FHandle;
  end;
  // Освобождаем ресурс и тем самым разрешаем следующий запуск.
  UnmapViewOfFile(FMemory);
  //CloseHandle(FHandle)
end;

initialization
  g_hAppMutex := 0;
  g_FHandle := 0;

finalization
  if LongBool(g_hAppMutex) then
  begin
    ReleaseMutex(g_hAppMutex);
    CloseHandle(g_hAppMutex );
  end;

  if LongBool(g_FHandle) then
    CloseHandle(g_FHandle)
end.
