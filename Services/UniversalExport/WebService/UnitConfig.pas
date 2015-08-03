unit UnitConfig;

interface
  uses inifiles, SysUtils,  SyncObjs, Classes, Windows, ShellAPI;
  type
        TINTARRAY = array of integer;
        TINTSET = set of byte;
        THREADCONTEXT = _CONTEXT;
  //const PATHINI ='C:\Users\shingarev\Documents\RAD Studio\Projects\NAVRefresApp\';
  const FILENAMEINI = 'UniExpConfig.ini';
        FILEERRLOG = 'UniExpErrors';
        FILEMAINLOG = 'UniExpServiceMain.log';
  var iniFile: TIniFile;
  SectINI: TCriticalSection; //* для синхронизации чтения ини-файла
  SectCTRL: TCriticalSection; //* для синхронизации управления потоками
  function ReadServerName: string;
  function ReadDatabaseName: string;

  function ReadExportActivity: boolean;
  //function ReadConnStr: string;
  function ReadTimerInterval: integer;
  function ReadSleepInterval: integer;
  function ReadLogFilename: string;
  function ReadInitCatalog: string;
  function ReadRemoveOption: boolean;
  function ReadRefreshLinksOption: boolean;

  function ReadDomain: integer;
  function ReadDomainsList:string;
  function ReadWarehousesList:string;

  function ReadSMTPServer: string;
  function ReadSMTPPort: integer;
  function ReadReturnAddress: string;
  function ReadAddressees: string;
  function ReadSMTPLogin: string;
  function ReadSMTPPassword: string;

  function ReadSMTPConnectTimeout: integer;
  function ReadSMTPReadTimeout: integer;
  function ReadSMTPSleepInterval: integer;

  function ReadFTPServer: string;
  function ReadFTPPort: integer;
  function ReadFTPUsername: string;
  function ReadFTPPassword: string;
  function ReadFTPDir: string;



  procedure PrintLog(filelog, msg: string);
  function listToIntArray(list: string; D: integer): TIntArray;
  function MultyReplace(str: string; Templates, Replacement: TStringList): string;
    //fileini: string
  function generateConnStr(OLEDBProvider: boolean; serverName, dbName: string): string;
  function loadTextDataByTag(tag: string): string;
  
  function writelnintofile(msg: string; filename: string): boolean;

  procedure RestartService(serviceClassName: string);

  function DatetimeIntervalToString(interval: TDAteTime): string;
  function GetTempDir(trailer: boolean): String;
implementation

function ReadExportActivity: boolean;
begin
  RESULT := iniFile.ReadBool('SERVICE','Export',true);
end;

function ReadServerName: string;
begin
  RESULT:=iniFile.ReadString('MAINDATABASE','server','');
end;

function ReadDatabaseName: string;
begin
  RESULT:=iniFile.ReadString('MAINDATABASE','database','');
end;

//function ReadConnStr: string;
//begin
//  RESULT:=iniFile.ReadString('MAINDATABASE','ConnectionString',''); ;
//end;

function ReadTimerInterval: integer;
begin
  RESULT:=iniFile.ReadInteger('SERVICE','TimeUnits',1000)*1000;
  RESULT:=RESULT*iniFile.ReadInteger('SERVICE','ResumeInterval',0);
end;

function ReadSleepInterval: integer;
begin
  //RESULT:=iniFile.ReadInteger('SERVICE','TimeUnits',1000)*1000; RESULT*
  RESULT:=iniFile.ReadInteger('SERVICE','pause',0);
end;


function ReadLogFileName: string;
begin
  RESULT:=iniFile.ReadString('SERVICE','LogFileName','');
end;

function ReadInitCatalog: string;
begin
  RESULT:=iniFile.ReadString('MAINDATABASE','InitialCatalog','');
end;

function ReadRemoveOption: boolean;
begin
  RESULT:=iniFile.ReadBool('SERVICE','DeleteAfterRead',false);
end;

function ReadRefreshLinksOption: boolean;
begin
  RESULT:=iniFile.ReadBool('SERVICE','RefreshLinks',false);
end;

function ReadSMTPServer: string;
begin
  RESULT:=iniFile.ReadString('SMTP','HostIP','') ;  // признак что почтальон не запускается 10.0.1.152
end;

function ReadSMTPPort: integer;
begin
  RESULT:=iniFile.ReadInteger('SMTP','PortNo',25);
end;

function ReadReturnAddress: string;
begin
  RESULT:=iniFile.ReadString('MAIL','ReturnAddress','info@shate-m.com');;
end;

function ReadAddressees: string;
begin
  RESULT:=iniFile.ReadString('MAIL','Addressees','');;
end;

function ReadSMTPLogin: string;
begin
  RESULT:=iniFile.ReadString('SMTP','Login','');;
end;

function ReadSMTPPassword: string;
begin
  RESULT:=iniFile.ReadString('SMTP','Pass','');;
end;

function ReadSMTPConnectTimeout: integer;
begin
  RESULT:=iniFile.ReadInteger('SMTP','ConnectionTimeout',5);
end;
function ReadSMTPReadTimeout: integer;
begin
  RESULT:=iniFile.ReadInteger('SMTP','ReadTimeout',20);;
end;

function ReadSMTPSleepInterval: integer;
begin
  RESULT:=iniFile.ReadInteger('SMTP','SleepInterval',1000);;
end;


function ReadDomain: integer;
begin
  RESULT:=iniFile.ReadInteger('SERVICE','Domain',0);
end;


function ReadDomainsList:string;
begin
  RESULT:=iniFile.ReadString('SERVICE','Domains','');;
end;

function ReadWarehousesList:string;
begin
  RESULT:=iniFile.ReadString('SERVICE','Warehouses','');
end;

procedure PrintLog(filelog, msg: string);
var log: text;
begin
  if ExtractFilePath(filelog)='' then
    filelog:=IncludeTrailingBackslash(ExtractFilePath(Paramstr(0)))+filelog;
  Assign(log, filelog);
  try
    if FileExists(filelog) then Append(log) else Rewrite(log);
    writeln(log, msg);
  finally
    CloseFile(log);
  end;
end;


function ReadFTPServer: string;
begin
  RESULT:=iniFile.ReadString('FTP','Host','ftp.shate-m.by') ;  // признак что почтальон не запускается 10.0.1.152
end;

function ReadFTPPort: integer;
begin
  RESULT:=iniFile.ReadInteger('FTP','Port',21);
end;

function ReadFTPUsername: string;
begin
  RESULT:=iniFile.ReadString('FTP','Login','uniexport');;
end;

function ReadFTPPassword: string;
begin
  RESULT:=iniFile.ReadString('FTP','Password','ibyufhtd');;
end;

function ReadFTPDir: string;
begin
  RESULT:=iniFile.ReadString('FTP','Dir','ue');
end;

///****************************************************************************
//                функции импорта
///****************************************************************************

  function listToIntArray(list: string; D: integer): TIntArray;
  const DLM = ',';
  var k, p: integer;
  begin
    list:=trim(list);
    if length(list)=0 then exit;

    SetLength(RESULT, D);
    k:=0;
    try
      repeat
        if D=0 then   SetLength(RESULT,k+1);   //* если длина списка заранеее не задана то динамически определяется
        p:=pos(DLM,list);
        if p>0 then
         begin
          RESULT[k]:=StrToInt(copy(list,1,p-1));
          list:=trim(copy(list,p+1));    {l-p}
         end
         else RESULT[k]:=StrToInt(list);
        inc(k);
      until (k=D)OR(p=0);
    except on E: Exception do
      SetLength(RESULT,0); //* возвращает пустой массив при некорректных данных
    end;
  end;


  function MultyReplace(str: string; Templates, Replacement: TStringList): string;
  var k: integer;
  begin
    for k:=0 to Templates.Count-1 do
     if k<Replacement.Count  then
      str:=Stringreplace(str,Templates[k],Replacement[k],[rfReplaceAll, rfIgnoreCase])
     else break;
    RESULT:=str;
  end;
//******************************************************************************
///****************************************************************************
//                конфигурация подключения
///****************************************************************************
  function generateConnStr(OLEDBProvider: boolean; serverName, dbName: string): string;
  //'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=True;User ID=shingarev;Initial Catalog=;Data Source=AMD;';
  var driver, server, UID, WSID, TrustConn, database, lang, user: string;
      provider, security, initcatalog, datasource, UserID: string;
  defcatalog: string;
  userNameLen: Cardinal;
  begin

    userNameLen:=255;
    setLength(user, userNameLen);
    getUserName(PAnsiChar(user),userNameLen);

    if OLEDBProvider then
     begin
      provider:='Provider=SQLOLEDB.1;';
      security:='Integrated Security=SSPI;Persist Security Info=True;';
      userID  :='User ID='+copy(user,1,UserNameLen-1)+';';
      datasource:='Data Source='+serverName+';';
      InitCatalog := 'Initial Catalog='+dbName+';';
      RESULT:=provider+security+UserID+initcatalog+datasource;
     end
     else
     begin
      driver := 'DRIVER=SQL Server;';
      server := 'SERVER='+serverName+';';
      UID    := 'UID=;';
      WSID   := 'WSID='+copy(user,1,UserNameLen-1)+';';
      TrustConn := 'Trusted_Connection=Yes;';
      database := 'DATABASE='+dbName+';';
      lang   :='LANGUAGE=русский;';
      RESULT:= driver + server + UID + WSID + TrustConn + database + lang;
     end;

  end;

  function loadStrFromFile(filename: string): string;
  var ff: text; line: string;
  begin
    RESULT:='';
    if FileExists(filename) then Assign(ff, filename)
    else exit;

    try
      Reset(ff);
      repeat
        readln(ff,line);
        RESULT:=RESULT+#13#10+line;
      until eof(ff)=true;
    finally
      CloseFile(ff);
      RESULT:=RESULT+#13#10;
    end;

  end;

  function loadTextDataByTag(tag: string): string;
  var
    Resource, resinfo: THandle;
  begin
    RESULT:='';
    resinfo:=   FindResource(hInstance, PANSICHAR(tag), 'TEXT');
    Resource := LoadResource(hInstance, resinfo);
    RESULT := PChar(LockResource(Resource));
    SetLength(RESULT, SizeOfResource(hInstance, resinfo));

    UnLockResource(Resource);
    FreeResource(Resource);

    //RESULT:=loadStrFromFile(tag+'.qry');
  end;

  procedure RestartService(serviceClassName: string);
  var filebat: string; ff: text;
  begin
    filebat:='Restart'+serviceClassName+'.bat';
    try try
      AssignFile(ff,filebat);
      Rewrite(ff);
      writeln(ff,'net stop '+serviceClassName);
      writeln(ff, 'net start '+serviceClassName);
    except

    end;
    finally
      CloseFile(ff);
    end;
    if FileExists(filebat) then
     try
        ShellExecute(0,'open',PChar(filebat),nil,nil,SW_SHOWNORMAL);
        sleep(100);
     except
     end;

  end;

function writelnintofile(msg: string; filename: string): boolean;
var ff: text;
begin
  RESULT:=false;
  if ExtractFilePath(filename)='' then
    filename:=IncludeTrailingBackslash(ExtractFilePath(Paramstr(0)))+filename;
  AssignFile(ff,filename);
try
    if FileExists(filename) then Append(ff)
     else Rewrite(ff);
    try
      writeln(ff, msg);
    finally
      CloseFile(ff);
      RESULT:=FileExists(filename);
    end;
except on E: Exception do
end;
end;


function DatetimeIntervalToString(interval: TDAteTime): string;
const    DAYHOURS =     24;
         DAYMIN = 60*DAYHOURS;
         DAYSEC = 60*DAYMIN;
var timepart : TDateTime;
begin

  if interval<1 then  RESULT:=''
  else
   begin
     RESULT:= IntToStr(trunc(interval))+ ' сут. ' ;
     interval := frac(interval);
   end;
  timepart:=interval;
  RESULT:= Concat(RESULT, Format('%.2d:',[trunc(DAYHOURS*timepart)]));//IntToStr(trunc(DAYHOURS*timepart)),':');
  timepart := frac(DAYHOURS*timepart) / DAYHOURS;
  RESULT:= Concat(RESULT, Format('%.2d:',[trunc(DAYMIN*timepart)]));//IntToStr(trunc(DAYMIN*(interval))),':');
  timepart := frac(DAYMIN*timepart) / DAYMIN;
  RESULT:= Concat(RESULT,Format('%.2d#%.3f',[trunc(DAYSEC*timepart),frac(DAYSEC*timepart)])); //FloatToStrF(DAYSEC*(timepart),ffFixed,2,3));
  RESULT:=StringReplace(RESULT,'#0','',[])
end;


function GetTempDir(trailer: boolean): String;
var
buffer: String;
len: UINT;
begin
  SetLength(buffer, MAX_PATH + 1);
  len:= GetTempPath(MAX_PATH, PAnsiChar(buffer));
  SetLength(buffer, len);
  if trailer then
    buffer:=IncludeTrailingPathDelimiter(buffer)
   else
    buffer:=ExcludeTrailingPathDelimiter(buffer);
  GetTempDir:= buffer;
end;


BEGIN
  //iniFile:= TIniFile.Create(FILENAMEINI);
END.
