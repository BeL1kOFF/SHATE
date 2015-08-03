unit UnitExtern;

interface
 uses ActiveX, Classes, Windows, SysUtils, tlhelp32, ShellAPI;
 type
  TExternStream = class(TStream)
  protected
    FSource : IStream;
    procedure SetSize(const NewSize: Int64); override;
  public
    constructor Create(Source : IStream);
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
    function ReadToLimit(var Buffer): Longint; //override;
  end;

  TTokenizer = Class(TStringList)
  public
    constructor Create(str: string);
    //destructor Destroy; override;
    procedure appendLine(str: string);
  private
    Caption: String;
    OpenBracket, CloseBracket: char;
    level: integer;
    //;
  End;
  function DosToAnsi(S: String): String;
  function SaveIStreamToFile(const StmSrc: IStream; const FileName: string): boolean;
  function csvtoList(str:string; delimiter: char): TStringList;
  procedure TextSeek(const F: TextFile; Pos: LongInt);

  Function DiskInDrive(ADriveLetter : Char) : Boolean;
  function executingProcess(exePathName: string): boolean;

  function GetEnvVarValue(const VarName: string): string;
implementation

function SaveIStreamToFile(const StmSrc: IStream; const FileName: string): boolean;
var
  StmTgt: IStream;
  sz, szRead, szWrite: int64;
begin
  StmSrc.Seek(0, soFromEnd, sz);
  StmSrc.Seek(0, soFromBeginning, int64(nil^));
  StmTgt:=TStreamAdapter.Create(TFileStream.Create(FileName, fmOpenReadWrite and fmShareDenyRead), soOwned);
  StmTgt.Seek(0, soFromEnd, int64(nil^));
  StmSrc.CopyTo(StmTgt, sz, szRead, szWrite);
  Result:=(sz = szRead) and (sz = szWrite);
end;

   { TExternStream }

constructor TExternStream.Create(Source: IStream);
begin
  inherited Create;
  FSource := Source;
end;
destructor TExternStream.Destroy;
begin
  FSource := nil;
  inherited;
end;

function TExternStream.Read(var Buffer; Count: Integer): Longint;
begin
  if FSource.Read(@Buffer, Count, @Result) <> S_OK
  then
    Result := 0;
end;
function TExternStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  FSource.Seek(Offset, byte(Origin), Result);
end;
procedure TExternStream.SetSize(const NewSize: Int64);
begin
  FSource.SetSize(NewSize);
end;
function TExternStream.Write(const Buffer; Count: Integer): Longint;
begin
  if FSource.Write(@Buffer, Count, @Result) <> S_OK
  then
    Result := 0;
end;

function TExternStream.ReadToLimit(var Buffer): LongInt;
var Buf0: Variant;
const INFINITY=MAXINT;
begin
  Result:=Self.Read(Buffer,Self.Read(Buf0,INFINITY));
end;

constructor TTokenizer.Create(str: string);
begin
  //inherited;
  self.Create(str);
end;

procedure TTokenizer.appendLine(str:string);
begin
  self.Add(str)
end;

function csvtoList(str:string; delimiter: char): TStringList;
begin
  RESULT:=TStringList.Create;
  RESULT.Text := StringReplace(str,delimiter,#13#10,[rfReplaceAll]);
end;

function DosToAnsi(S: String): String;
begin
  SetLength(Result, Length(S));
  OEMToCharBuff(PChar(S), PChar(Result), Length(S));
end;
function AnsiToDos(S: String): String;
begin
  SetLength(Result, Length(S));
  AnsiToOEMBuff(PChar(S), PChar(Result), Length(S));
end;

// Перемещение на позиций в текстовом файле, обозначенную байтовым
// значением. В описании процедуры SetlnOutRes смотрите ту же
// процедуру с обработкой ошибок. Предполагаем, что буфер файла
// пуст.
procedure TextSeek(const F: TextFile; Pos: LongInt);
begin
  SetFilePointer(TTextRec(F).Handle, Pos, nil, File_Begin);
end;



//Проверка доступности устройства
Function DiskInDrive(ADriveLetter : Char) : Boolean;
var
  SectorsPerCluster,
  BytesPerSector,
  NumberOfFreeClusters,
  TotalNumberOfClusters : Cardinal;
begin
  Result := GetDiskFreeSpace(PChar(ADriveLetter+':\'),
  SectorsPerCluster,
  BytesPerSector,
  NumberOfFreeClusters,
  TotalNumberOfClusters);

end;

function IsRunning(sName: string): boolean; // проверяет, запущен ли процесс sName
var
  han: THandle;
  ProcStruct: PROCESSENTRY32;
  sID: string;
begin
  Result := false;
 
  han := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  if han = 0 then
    exit;
 
 
  ProcStruct.dwSize := sizeof(PROCESSENTRY32);
  if Process32First(han, ProcStruct) then
  begin
    repeat
      sID := ExtractFileName(ProcStruct.szExeFile);
 
      if uppercase(copy(sId, 1, length(sName))) = uppercase(sName) then
      begin
 
        Result := true;
        Break;
      end;
    until not Process32Next(han, ProcStruct);
  end;
 
  CloseHandle(han);
end;

function executingProcess(exePathName: string): boolean;
var processname: string;
    si : TStartupInfo;
    pi : TProcessInformation;
begin
  processName:=ExtractFileName(exePathName);
  RESULT:=processName<>'';
  try
    try
      if IsRunning(processName) then exit;

      ZeroMemory(@si,SizeOf(si));
      si.cb := SizeOf(si);
      si.dwFlags := STARTF_USESHOWWINDOW;
      si.wShowWindow := SW_MINIMIZE;

      RESULT:=CreateProcess(nil,PChar(exePathName),nil,nil,False,0,nil,nil,si,pi); //nil,nil
    except
      RESULT:=false;
    end;
    //CreateProcess(exePathName,SW_SHOWNORMAL);
    //ShellExecute(
  finally

  end;
end;

function GetEnvVarValue(const VarName: string): string;
var
  BufSize: Integer;  // buffer size required for value
begin
  // Get required buffer size (inc. terminal #0)
  BufSize := GetEnvironmentVariable(
    PChar(VarName), nil, 0);
  if BufSize > 0 then
  begin
    // Read env var value into result string
    SetLength(Result, BufSize - 1);
    GetEnvironmentVariable(PChar(VarName),
      PChar(Result), BufSize);
  end
  else
    // No such environment variable
    Result := '';
end;

BEGIN
  ;
END.




