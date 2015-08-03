unit UnitConfig;

interface
  uses inifiles, SysUtils,  SyncObjs, Classes, Windows, ShellAPI;
  type
        TINTARRAY = array of integer;
        TINTSET = set of byte;
  //const PATHINI ='C:\Users\shingarev\Documents\RAD Studio\Projects\NAVRefresApp\';
  const FILENAMEINI = 'Config.ini';
        DESCTOPOPT =                          DESKTOP_READOBJECTS or DESKTOP_CREATEWINDOW  or DESKTOP_CREATEMENU  or
                         DESKTOP_HOOKCONTROL or DESKTOP_JOURNALRECORD or DESKTOP_JOURNALPLAYBACK or
                         DESKTOP_ENUMERATE or DESKTOP_WRITEOBJECTS or DESKTOP_SWITCHDESKTOP;
  var iniFile: TIniFile;
  SectINI: TCriticalSection; //* для синхронизации чтения ини-файла
  SectCTRL: TCriticalSection; //* для синхронизации управления потоками
  DESKTOPGENERAL, DESKTOP:  HDESK;

  function ReadServerName: string;
  function ReadDatabaseName: string;
  function ReadFirmName: string;

  function ReadTimerInterval(TimerID: integer): integer;
  function ReadSleepInterval: integer;

  function ReadChannel: integer;
  function ReadScreenRows(monitortag: string): integer;
  function ReadScreenColumns(monitortag: string): integer;

  function ReadTCPHost: string;
  function readTCPPort: integer;

  function ReadAutoHideTaskbar: boolean;
  //function ReadLogFilename: string;
  //function ReadInitCatalog: string;

//  function ReadSMTPLogin: string;
//  function ReadSMTPPassword: string;

//  function ReadSMTPConnectTimeout: integer;
//  function ReadSMTPReadTimeout: integer;
//  function ReadSMTPSleepInterval: integer;

  procedure PrintLog(filelog, msg: string);
  function listToIntArray(list: string; D: integer): TIntArray;
  function MultyReplace(str: string; Templates, Replacement: TStringList): string;
    //fileini: string
  function generateConnStr(OLEDBProvider: boolean; serverName, dbName: string): string;
  function loadTextDataByTag(tag: string): string;


  //procedure AutohideTaskbar(hide: boolean);
implementation



function ReadServerName: string;
begin
  //iniFile.WriteString('NAV','Server','SVBYPRS');
  RESULT:=iniFile.ReadString('NAV','Server','');
end;

function ReadDatabaseName: string;
begin
  RESULT:=iniFile.ReadString('NAV','Database',' ');
end;

function ReadFirmName: string;
begin
  RESULT:=iniFile.ReadString('NAV','Firm','');
end;


function ReadTimerInterval(TimerID: integer): integer;
begin
  RESULT:=iniFile.ReadInteger('INTERVALS','Fps'+IntToStr(TimerID),1);
end;

function ReadSleepInterval: integer;
begin
  //RESULT:=iniFile.ReadInteger('SERVICE','TimeUnits',1000)*1000; RESULT*
  RESULT:=iniFile.ReadInteger('INTERVALS','pause',0)*1000;
end;

function ReadChannel: integer;
begin
  RESULT:= iniFile.ReadInteger('MONITORS','Channel', 0);
end;

function ReadScreenRows(monitortag: string): integer;
begin
  RESULT:= iniFile.ReadInteger('MONITORS',monitortag+'Rows', 0);
end;
function ReadScreenColumns(monitortag: string): integer;
begin
  RESULT := iniFile.ReadInteger('MONITORS',monitortag+'Columns', 0);
end;

function ReadTCPHost: string;
begin
  RESULT:= iniFile.ReadString('SOCKETS','Host','localhost');
end;


function readTCPPort: integer;
begin
  RESULT:=iniFile.ReadInteger('SOCKETS','Port', 8088);
end;


function ReadAutoHideTaskbar: boolean;
begin
  RESULT := iniFile.ReadBool('MONITORS','AutohideTaskbar', false);
end;

procedure PrintLog(filelog, msg: string);
var log: text;
begin
  Assign(log, filelog);
  try
    if FileExists(filelog) then Append(log) else Rewrite(log);
    writeln(log, msg);
  finally
    CloseFile(log);
  end;
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





BEGIN
  //iniFile:= TIniFile.Create(FILENAMEINI);
END.

