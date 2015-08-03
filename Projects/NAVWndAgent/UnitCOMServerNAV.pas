unit UnitCOMServerNAV;

interface
uses   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ADODB,
  Dialogs, ExtCtrls, ActiveX, OleCtnrs, Axctrls, ComObj, Math, IniFiles, ShellAPI
  ,UnitNAV;
type
    TStrArray = array of string;
    TVitrail = Class(TStringList)
     private
       var Kind: array of byte;

     public
      function ServersSet: TStrArray;
      function DatabasesSet: TStrArray;
      function KindsSet: TStrArray;
      function SelectMosaic(Server, Database: string): byte;
      function InsertMosaic(Server, Database: string; Mosaic: byte): Integer;
      function PaintMosaic(fileini: string): boolean;
     published
      constructor Create(fileini: string);
    End;

    TWindowPassport = array[0..7] of string;

    TNAVWindow = Record
      HW: SYSINT;//HWND;
      ThreadID: Cardinal;
      ProcessID: Cardinal;
      HH: Cardinal;
      Default,
      Server, Company, Database
      ,User   : WideString;
      cb: byte;
      timestamp:TDatetime;
      function Valid: boolean;
      function Significance : Integer;
      //function Refresh(TS: TDatetime; Server, Database, Company: string; Vitrail:TVitrail): boolean;
      function SetWindowCaption: boolean;
      function GetWindowCaption: boolean;
      function PresentPassport: TWindowPassport;
      function SendForActivate: boolean;
    End;


    TNAVWindows = Class
      private
        Windows: array of TNAVWindow;
        Num: integer;
        function getWindow(key: Integer): TNAVWindow;
        procedure setWindow(key: Integer;Window: TNAVWindow);
        function WindowByHandle(HW: HWND):TNAVWindow;
        function WindowIndexByHandle(HW: HWND): Integer;
        function PutWindow(Window: TNAVWindow): Integer;
        function KickWindow(Window: TNAVWindow): integer;
        function GetHook(index: integer): boolean;
        procedure SetHook(index: integer; Active: boolean);//: boolean
        procedure ResizeWindows(size: integer);
      public
        Vitrail: TVitrail;
        property Window[key: Integer]: TNAVWindow read getWindow write setWindow; default;
        property WinNum: integer read Num write ResizeWindows;
        property Hook[index: integer]:boolean read GetHook write SetHook;
        class function _0: TNAVWindow;
        function Refresh(Wnd: TNAVWindow): boolean;
        function RevealBySQLServer(Server: String; procid: Cardinal; var Wnd: TNAVWindow): boolean;
        function CloneWindow(Wnd0, Wnd: TNAVWindow): boolean;
        procedure ClearWindows(TS: TDateTime);
        procedure ManipulateWindow;
        procedure BroadcastWindow(MSG ,ParW, ParL: integer);
      published
       constructor Create;
       destructor Destroy;
    End;

    TPassports = array of TWindowPassport;

    TRunningCOMs = Class
      private
        nameFilter: string;
        monikersEnum: IEnumMoniker;
        mon:IMoniker;
        numFetched:Longint;
        ctx:IBindCtx ;
        runningObjectName: PWideChar;
        runningObjectVal : System.IInterface;
        ROT: IRunningObjectTable;
        function GetObject: System.IInterface;
        procedure SetObject(Obj: System.IInterface);
      public
        property RunningObject:System.IInterface read GetObject Write SetObject;
        function Open(ROT: IRunningObjectTable): boolean;
        function First: boolean;
        function Next: boolean;
        function Close: boolean;
      published
        constructor Create(Monikers: IEnumMoniker;filter: string);
        destructor Destroy;
    End;

    TNAVCOMServer = Class
      private
        ROT: IRunningObjectTable;
        RunningCOMs: TRunningCOMs;
        monikerEnumerator: IEnumMoniker;

        NAVWindows: TNAVWindows;

        ApplHost: string;
        Passports: TPassports;

        function getPassports: Pointer;

        function getMonikerEnum:  IEnumMoniker;
        procedure InitMonikerEnum(MonikerEnum: IEnumMoniker);

        function getApplHost: string;
        procedure setApplHost(filename: string);
        //function NextRunningCOM: System.IInterface;
        function getServerTempl(index: integer): string;
        procedure setServerTempl(index: integer; ServerTemp: string);
        function getDatabaseTempl(index: integer): string;
        procedure setDatabaseTempl(index: integer; DatabaseTemp: string);
        function getKindTempl(index: integer): string;
        procedure setKindTempl(index: integer; KindTemp: string);
        function NumberOfConfigurations: integer;
        function LoadObjectInfo(var WndObj: TNAVWindow): boolean;
      public
        COMObject: System.IInterface;
        property Monikers: IEnumMoniker Read getMonikerEnum Write InitMonikerEnum;
        function RefreshCOM: boolean;
        procedure ReloadNAVApps;
        function RunHostApplication(VitrailIndex: integer): boolean; overload;
        function RunHostApplication(Server, DataBase: string): boolean; overload;
        function Reconfig(index: integer; Server, Database: string; kind: byte): boolean;
        function SaveConfiguration: boolean;
        function LoadHostApplPathName: string;
        function SaveHostAppPathName: boolean;
        function LoadScale(lim: integer): integer;
        procedure ChangeScale(scale:Integer);
        function SaveScale(scale: integer): boolean;
        property ServersSet[index: integer]: string read getServerTempl write setServerTempl;
        property DatabasesSet[index: integer]: string read getDatabaseTempl write setDatabaseTempl;
        property KindsSet[index: integer]: string read getKindTempl write setKindTempl;
        property ConfigsNumber: integer read NumberOfConfigurations;
        property RunningNAVs: Pointer read getPassports;
        property fileexe: string read getApplHost write setApplHost;
        function ActivateByIndex(k: integer): boolean;
      published
       constructor Create;
       destructor Destroy;
    End;
CONST GUIDAPPBASE ='{50000004-0000-1000-0010-0000836BD2D2}';
      GUIDHYPERLINK = '{50000004-0000-1000-0000-0000836BD2D2}';
var NAVCOM : TNAVCOMServer;
    dll:Cardinal;
  function InstallHook(dll: Cardinal): boolean;  stdcall; external 'Project1dllHook.dll' name 'InstallHook';
  function UnInstallHook(dll: Cardinal): boolean;  stdcall; external 'Project1dllHook.dll' name 'UnInstallHook';
   function SetupHook(dll: Cardinal; WindowID: HWND): Cardinal;  stdcall; external 'Project1dllHook.dll' name 'SetUpHook';
   function ResetHook(HookID: Cardinal): boolean;  stdcall; external 'Project1dllHook.dll' name 'ReSetHook';
implementation
const WM_NAVWIN_STATE = WM_USER + $40;
      WM_NAVWIN_SCALE = WM_USER + $48;
      WM_NAVWIN_HOOK =  WM_USER + $64;
      DEFAULTWINDOWCAPTION = 'Microsoft Dynamics NAV';
      FILECFG = 'basetypes.cfg';
      FILEINI = 'NAVWndAgent.ini';
var HWOK: HWND;
    dbname: String;
{ TNAVCOMServer }

function TNAVCOMServer.ActivateByIndex(k: integer): boolean;
begin
  RESULT:=False;
  if k<self.NAVWindows.Num then
   RESULT:=self.NAVWindows[k].SendForActivate;
end;

procedure TNAVCOMServer.ChangeScale(scale: Integer);
begin
  self.NAVWindows.BroadcastWindow(WM_NAVWIN_SCALE,scale,0);
end;

constructor TNAVCOMServer.Create;
begin
inherited Create;
self.NAVWindows:=TNAVWindows.Create;
self.ApplHost := LoadHostApplPathName;
//installHook(dll);
end;

destructor TNAVCOMServer.Destroy;
begin
self.NAVWindows.Free;
//UnInstallHook(dll);
inherited;
end;

function TNAVCOMServer.getApplHost: string;
begin
  RESULT:='';
  if FileExists(Self.ApplHost) then
    RESULT:=Self.ApplHost;
end;

function TNAVCOMServer.getDatabaseTempl(index: integer): string;
var line: string; p: integer;
begin
  RESULT:='';
  if self.NAVWindows.Vitrail.Count>index then
   begin
     line:=self.NAVWindows.Vitrail[index];
     p:=pos('.',line);
     if p>0 then RESULT:= copy(line,p+1);
   end;
end;

function TNAVCOMServer.getKindTempl(index: integer): string;
begin
  RESULT:='';
  if self.NAVWindows.Vitrail.Count>index then
   case  self.NAVWindows.Vitrail.Kind[index] of
     2: RESULT:= #2+'TEST';
     3: RESULT:= #3+'DEVELOPER';
     4: RESULT:= #4+'PRODUCTIVE';
     else RESULT:='UNKNOWN';
   end;
end;

function TNAVCOMServer.getMonikerEnum: IEnumMoniker;
begin
  RESULT:=self.monikerEnumerator;
end;

function TNAVCOMServer.getPassports: Pointer;
var k: integer;
begin
  SetLength(self.Passports,self.NAVWindows.Num);
  for k:=0 to self.NAVWindows.Num - 1 do
   self.Passports[k] := self.NAVWindows[k].PresentPassport;
  RESULT:=@self.Passports;
end;

function TNAVCOMServer.getServerTempl(index: integer): string;
var line: string; p: integer;
begin
  RESULT:='';
  if self.NAVWindows.Vitrail.Count>index then
   begin
     line:=self.NAVWindows.Vitrail[index];
     p:=pos('.',line);
     if p>0 then RESULT:= copy(line,1,p-1);
   end;
end;

procedure TNAVCOMServer.InitMonikerEnum(MonikerEnum:IEnumMoniker);
begin
  self.monikerEnumerator:= nil;
end;

function TNAVCOMServer.LoadHostApplPathName: string;
const DEFAULTFINSQLPATH = 'C:\Program Files\Microsoft Dynamics NAV\60\Classic\finsql.exe';
var iniFile: TIniFile;
begin
  RESULT:=ApplHost;
  if FileExists(FILEINI) then RESULT:=''
   else exit;
  iniFile := TIniFile.Create(ExtractFilePath(Paramstr(0))+FILEINI);
  try
    RESULT:=iniFile.ReadString('APPLICATION','PathName',DEFAULTFINSQLPATH);
    if not FileExists(RESULT) then RESULT := self.ApplHost;
  finally
    iniFile.Free;
  end;
end;

function TNAVCOMServer.LoadObjectInfo(var WndObj: TNAVWindow): boolean;
var ObjAppBase: INSAppBase; Hyperlink: INSHyperlink;
    magnitude: integer;
    l, pos0, pos1, pos2: integer;
begin
  RESULT:=False;
  
  l := length(self.RunningCOMs.runningObjectName);
  pos0 := pos('?',self.RunningCOMs.runningObjectName);
//  if l>pos0 then
//   magnitude := 8;
  pos1 := pos('&',copy(self.RunningCOMs.runningObjectName,pos0+1));
//  if pos1>0 then
//   magnitude := magnitude+4;
  pos2 := pos('&',copy(self.RunningCOMs.runningObjectName,pos0+pos1+2));
  magnitude := 8*Sign(l-pos0)+4*Sign(pos1)+2*Sign(pos2)+1;
  self.RunningCOMs.RunningObject.QueryInterface(StringToGUID(GUIDAPPBASE),ObjAppBase);
  self.RunningCOMs.RunningObject.QueryInterface(StringToGUID(GUIDHYPERLINK),Hyperlink);
  if Hyperlink.GetWindowHandle(WndObj.HW)=S_OK then
   if ObjAppBase.GetInfos(WndObj.Server,WndObj.Database,WndObj.Company, WndObj.User)=S_OK then
    begin
      WndObj.ThreadID := GetWindowThreadProcessId(WndObj.HW,@WndObj.ProcessID);
      RESULT:=(magnitude=WndObj.Significance);
    end;
end;

function TNAVCOMServer.LoadScale(lim: integer): integer;
var iniFile: TIniFile;
begin
  lim := abs(lim);
  RESULT:=lim;
  if FileExists(FILEINI) then RESULT:=0
   else exit;
  iniFile := TIniFile.Create(FILEINI);
  try
    RESULT:=iniFile.ReadInteger('DISPALY','FontScale',0);
    if RESULT>lim then RESULT:= RESULT mod (lim+1);
  finally
    iniFile.Free;
  end;
end;

function TNAVCOMServer.NumberOfConfigurations: integer;
begin
  if Assigned(self.NAVWindows) then
   if Assigned(self.NAVWindows.Vitrail) then
    RESULT:=self.NAVWindows.Vitrail.Count;
end;

function TNAVCOMServer.Reconfig(index: integer; Server, Database: string;  kind: byte): boolean;
var line: string; k: integer;
begin
  RESULT:=False;
  line:=trim(server)+'.'+trim(Database);
  if index<self.NAVWindows.Vitrail.Count then
   begin
     k:=index;
     self.NAVWindows.Vitrail[k]:=line;
     self.NAVWindows.Vitrail.Kind[k]:=kind;
   end
   else
   begin
    k:=self.NAVWindows.Vitrail.Add(line);
    if length(self.NAVWindows.Vitrail.Kind)<k+1 then
     Setlength(self.NAVWindows.Vitrail.Kind,k+1);
    self.NAVWindows.Vitrail.Kind[k]:=kind;
   end;
   RESULT:=k=index;
end;

function TNAVCOMServer.RefreshCOM: boolean;
begin
//  RESULT:=False;
//  if GetRunningObjectTable(0, ROT)=S_OK then
////   if ROT.EnumRunning(monikerEnumerator)=S_OK then
////    RESULT:=monikerEnumerator.Reset()=S_OK;
   RESULT:= GetRunningObjectTable(0,self.ROT)=S_OK;
end;

procedure TNAVCOMServer.ReloadNAVApps;
var //ObjAppBase: INSAppBase; Hyperlink: INSHyperlink;
    Wnd, Wnd0: TNAVWindow;
begin
  Wnd.timestamp:=Now(); //self.NAVWindows.ClearWindows;
  if self.RefreshCOM then
   try
     self.RunningCOMs:=TRunningCOMs.Create(self.monikerEnumerator,'!C/SIDE!navision');
     try
       if self.RunningCOMs.Open(self.ROT) then
        if  self.RunningCOMs.First then
         repeat
          if self.LoadObjectInfo(Wnd) then
           begin
            Wnd0:=self.NAVWindows[-Wnd.HW];
            if Wnd0.Valid then
              if Wnd0.Significance<Wnd.Significance then self.NAVWindows[-Wnd.HW]:=Wnd //Wnd0
               else
                if (Wnd0.Significance=Wnd.Significance)and(Wnd0.timestamp=Wnd.timestamp) then
                  self.NAVWindows.CloneWindow(Wnd0, Wnd)
                 else self.NAVWindows.Refresh(Wnd)
             else self.NAVWindows.PutWindow(Wnd);
           end;
         until NOT self.RunningCOMs.Next;

     finally
       self.RunningCOMs.Free;
     end;
     self.NAVWindows.ManipulateWindow;
     self.NAVWindows.ClearWindows(Wnd.timestamp);
   except

   end;
end;

function TNAVCOMServer.RunHostApplication(VitrailIndex: integer): boolean;
var
  Server, Database: string;
begin
  RESULT:=False;
  Server := self.NAVWindows.Vitrail.ServersSet[VitrailIndex];
  Database := self.NAVWindows.Vitrail.DatabasesSet[VitrailIndex];
  RESULT:=self.RunHostApplication(Server,Database);
end;

function TNAVCOMServer.RunHostApplication(Server, DataBase: string): boolean;
var strParams: string;
begin
  strParams := '';
//  Server := 'servername='+Server;
//  Database := 'database='+Database;
  strParams := Format('servername=%s, database=%s',[Server, database]);
  ShellExecute(0,PChar('open'),PChar(self.ApplHost),PChar(strParams),nil,SW_SHOWDEFAULT);
end;

function TNAVCOMServer.SaveConfiguration: boolean;
begin
  RESULT:=self.NAVWindows.Vitrail.PaintMosaic(FILECFG);
end;

function TNAVCOMServer.SaveHostAppPathName: boolean;
var iniFile: TIniFile;
begin
  RESULT:=false;
  if not FileExists(self.ApplHost) then exit;

  iniFile := TIniFile.Create(ExtractFilePath(Paramstr(0))+FILEINI);
  try
    iniFile.WriteString('APPLICATION','PathName',self.ApplHost);
  finally
    iniFile.Free;
  end;
end;

function TNAVCOMServer.SaveScale(scale: integer): boolean;
var iniFile: TIniFile;
begin
  RESULT:=false;
  //if FileExists(FILEINI) then

  iniFile := TIniFile.Create(ExtractFilePath(Paramstr(0))+FILEINI);
  try
    iniFile.WriteInteger('DISPLAY','FontScale',scale);
  finally
    iniFile.Free;
  end;
end;

procedure TNAVCOMServer.setApplHost(filename: string);
begin
  if FileExists(FileName) then
    Self.ApplHost:=filename;
end;

procedure TNAVCOMServer.setDatabaseTempl(index: integer; DatabaseTemp: string);
begin

end;

procedure TNAVCOMServer.setKindTempl(index: integer; KindTemp: string);
begin

end;

procedure TNAVCOMServer.setServerTempl(index: integer; ServerTemp: string);
begin

end;

{ TRunningCOM }

function TRunningCOMs.Close: boolean;
begin
  RESULT:=False;
  self.monikersEnum:=nil;
  self.ROT:=nil;
  RESULT:=True;
end;

constructor TRunningCOMs.Create(Monikers: IEnumMoniker;filter: string);
begin
  self.monikersEnum:=Monikers;
  self.nameFilter:=filter;
end;

destructor TRunningCOMs.Destroy;
begin

end;

function TRunningCOMs.First: boolean;
begin
  RESULT:=false;
  if Assigned(self.monikersEnum) then
try
     if self.monikersEnum.Reset()<>S_OK then exit;
     RESULT:=self.Next;
except on E: Exception do
end;
end;

function TRunningCOMs.GetObject: System.IInterface;
begin
  RESULT:=self.runningObjectVal;
end;

function TRunningCOMs.Next: boolean;
begin
  RESULT:=false;
  if Assigned(self.monikersEnum) then
   repeat
        if self.monikersEnum.Next(1,mon,@numFetched)<>S_OK then exit;
         if numFetched<>1 then exit;
         CreateBindCtx(0,ctx);      //получить контекст привязки погоняла
         mon.GetDisplayName(ctx, nil, runningObjectName); //имя объекта

         mon.BindToObject(ctx,nil,StringToGUID('{00000000-0000-0000-C000-000000000046}'),self.runningObjectVal);
                  (*
           ROT.GetObject(mon, self.runningObjectVal);
         *)
   until Pos(self.nameFilter,runningObjectName)>0;//'!C/SIDE!navision'
   RESULT:=True;
end;

function TRunningCOMs.Open(ROT: IRunningObjectTable): boolean;
begin
   RESULT:=False;
   self.ROT:=ROT;
   RESULT:=ROT.EnumRunning(self.monikersEnum)=S_OK;
end;

procedure TRunningCOMs.SetObject(Obj: System.IInterface);
begin
  exit;
end;

{ TNAVWindows }

function TNAVWindows.PutWindow(Window: TNAVWindow): Integer;
var Wnd: TNAVWindow;
    p: integer;
begin
  Window.GetWindowCaption;
  Window.cb := self.Vitrail.SelectMosaic(Window.Server,Window.Database);
  Wnd:=self.WindowByHandle(Window.HW);
  if Wnd.Valid then
   begin
     self[self.WindowIndexByHandle(Window.HW)]:=Window; //Wnd:=
     exit;
   end;

  p:= self.WinNum;
  self.WinNum := self.WinNum + 1;
  self.Windows[p]:=Window;
  self.Hook[p]:=True; //set hook!
  RESULT:=p;
end;

procedure TNAVWindows.BroadcastWindow(MSG ,ParW, ParL: integer);
const SENDTIMEOUT = 100;
var k: integer;   result: Cardinal;
begin
 for k:=0 to self.WinNum-1 do
   //PostMessage(self[k].HW,MSG,ParW, ParL);
  SendMessageTimeout (self[k].HW,MSG,ParW,ParL
                      ,SMTO_ABORTIFHUNG,SENDTIMEOUT, result);

end;

procedure TNAVWindows.ClearWindows(TS: TDateTime);
var k: integer;
begin
  if TS=0 then
   begin
    for k := self.WinNum-1 downto 0 do
      self.Hook[k]:=false; //reset hook!
    self.WinNum :=0;
   end
   else
   begin
    k:=0;
    if self.WinNum>k then
      repeat
        if self[k].timestamp<TS then
         begin
          self.Windows[k].Default := copy('Microsoft Dynamics NAV',1);
          self.Windows[k].Server := 'UNDEFINED';
          self.Windows[k].Database :='UNDEFINED';
          self.Windows[k].SetWindowCaption;
          if self.Windows[k].cb>0 then
           begin
             self.Windows[k].cb:=0;
             self.Windows[k].timestamp:=TS;
             inc(k);
             continue;
           end;
          if self.KickWindow(self[k])<>k then break;
         end
         else inc(k);
      until k>=self.WinNum;
   end;
end;

function TNAVWindows.CloneWindow(Wnd0, Wnd: TNAVWindow): boolean;
var procid: Cardinal;
begin
  RESULT:=False;
  //Wnd0.ThreadID:=GetWindowThreadProcessId(Wnd.HW,@procid);
  //Wnd0.ProcessID := procid;
  procid := Wnd0.ProcessID;
  if self.RevealBySQLServer(Wnd0.Server,procid,Wnd) then
   begin
    //self.Windows[self.WindowIndexByHandle(Wnd0.HW)]:=Wnd0;  // note ProcessID, ThreadID
    Wnd0 := self[-Wnd.HW];
    if Wnd0.Valid then
      if Wnd0.Significance<Wnd.Significance then
        self[-Wnd.HW]:=Wnd //Wnd0
       else self.Refresh(Wnd)
     else self.PutWindow(Wnd);
   end;
end;

constructor TNAVWindows.Create;
begin
  self.Vitrail := TVitrail.Create(FILECFG);
end;

destructor TNAVWindows.Destroy;
begin
  self.ClearWindows(0);
  self.Vitrail.Free;
end;

function TNAVWindows.GetHook(index: integer): boolean;
begin
  RESULT:=False;
  if index<self.WinNum then
   if self[index].Valid then    
    RESULT:=self[index].HH>0;
end;

function TNAVWindows.getWindow(key: Integer): TNAVWindow;
begin
  RESULT:=_0;
  if (key<0) OR (key>=self.Num) then
    key:=self.WindowIndexByHandle(abs(key));//self.Windows[]self.WindowByHandle(abs(key))
  if (key<0) OR (key>=self.Num) then exit;

  RESULT:=self.Windows[key];
end;

function TNAVWindows.KickWindow(Window: TNAVWindow): integer;
var i,j: integer;  HW: Cardinal;
begin

  RESULT:=0;
  if self.WinNum=0 then exit;;
  i:=self.WinNum;
  repeat
    dec(i);
    if Window.HW=self[i].HW then
     begin
      self.Hook[i]:=false;  //reset hook!
      for j:=i to self.WinNum-2 do
       self[i]:=self[i+1];
      self.WinNum:=self.WinNum-1;
      RESULT:=i;
     end;
  until i=0;

end;

function TNAVWindows.WindowByHandle(HW: HWND): TNAVWindow;  //поиск окна по его хэндлу
var k: Integer;
begin
  RESULT.HW:=0;
  for k := self.Num - 1 downto 0 do
   if self.Windows[k].HW=HW then
    begin;
      RESULT:=self.Windows[k];
      break;
    end;
end;

function TNAVWindows.WindowIndexByHandle(HW: HWND): Integer;
var k: Integer;
begin
  RESULT:=self.Num;
  for k := self.Num - 1 downto 0 do
   if self.Windows[k].HW=HW then
    RESULT:=k;
end;

class function TNAVWindows._0: TNAVWindow;
begin
  with RESULT do
   begin
     HW:=0;
     ThreadID:=0;
     ProcessID:=0;
     timestamp:=0;
     Default:='';
     Server:='';
     Company:='';
     Database:='';
     User:='';
     cb:=0;
   end;
end;

procedure TNAVWindows.ManipulateWindow;
const SENDTIMEOUT = 1000;
var k: integer;   result: Cardinal;
begin
  for k:=0 to self.WinNum-1 do
   begin



    if IsWindow(self[k].HW) then
     begin
      self[k].SetWindowCaption;
      //self.Hook[k]:=true;
      SendMessageTimeout (self[k].HW,WM_NAVWIN_STATE,self.Windows[k].cb,0
                      ,SMTO_ABORTIFHUNG,SENDTIMEOUT, result);

     end
     else
     begin
      //self.Hook[k]:=false;
      with self[k] do {HW} timestamp:=0; //Window must die!
     end;
   end;
end;

function TNAVWindows.Refresh(Wnd: TNAVWindow): boolean;
var key: integer;  Wnd0: TNAVWindow;
    cb0: byte;
begin
  RESULT:=False;
  key:=self.WindowIndexByHandle(Wnd.HW);
  if key=self.Num then exit;

  Wnd0:=self.Windows[key];
  if Wnd.timestamp>=Wnd0.timestamp then
   begin
     Wnd.GetWindowCaption;
     cb0:=self.Windows[key].cb;
     Wnd.cb:=self.Vitrail.SelectMosaic(Wnd.Server,Wnd.Database);

//     if cb0=Wnd.cb then
//     // exit;

     self.Windows[key]:=Wnd;
     RESULT:=cb0<>Wnd.cb;
   end;
end;

procedure TNAVWindows.ResizeWindows(size: integer);
begin
  self.Num := size;
  SetLength(self.Windows, self.Num);
end;

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


  function CallBackCheck(HW: HWND; Param: LParam): BOOL;  stdcall;
  var ThreadID, ProcID: Cardinal;
      l: Integer;
      Caption, Classname: String;
      pBuf: PChar;
      WinClass: array[0..255] of Char;
  begin
    RESULT := TRUE;
    HWOK :=0;
    ProcID:=0;
    // Param := Param ; AND ($FFFF)
    ThreadID := GetWindowThreadProcessId(HW,@ProcID);
    if ProcID = Param then //окно принадлежит процессу
     begin
       l:=GetWindowTextLength(HW); // l:=0;
       if l>0 then
        try
          pBuf:=GetMemory(l+1);
          l := GetWindowText(HW, pBuf, l+1);
          Caption := String(pBuf);
          SetLength(Caption, l);

          if pos(DEFAULTWINDOWCAPTION,Caption)>0 then
            HWOK :=HW;
        finally
           FreeMemory(pBuf);
        end;
//        else
//        try
//          //pBuf:=GetMemory(255);
//          GetClassName(HW,WinClass,SizeOf(WinClass));
//          ClassName := String(WinClass);
//          //SetLength(ClassName,l);
//        finally
//          //FreeMemory(pBuf);
//        end;         
     end;
     RESULT := BOOL(HWOK=0);
  end;

function SearchProcessWindowByCaption(ProcessID: Cardinal; Tag: String): BOOL;
var
  res: BOOL;
  //HWOK: HWND;
  Param: LParam;
begin
  Param:=ProcessID;
  RESULT:=EnumWindows(@CallBackCheck,Param); //LParam()
  RESULT := BOOL(HWOK>0);
end;

function TNAVWindows.RevealBySQLServer(Server: String;  procid: Cardinal; var Wnd: TNAVWindow): boolean;
const
  SQLEXEC = 'EXEC agnt_sel_nav_conns ';
  ROOTDB =  'master'; 
var 
    Connection: TADOConnection;
    Query: TADOQuery;
    
    RES : BOOL;
    Wnd0: TNAVWindow;
    params: string;
begin
try
    RESULT:=False;

    dbname := Wnd.Database;
    Connection := TADOConnection.Create(nil);
    try
      Connection.ConnectionString := generateConnStr(true,Server,ROOTDB);
      Query := TADOQuery.Create(nil);
      try
        Query.Connection := Connection;
  
        Query.CursorLocation := clUseClient;
        Query.CursorType := ctStatic;
        params := Concat(IntToStr(procid),',',''''+Wnd.Database+'''');
        Query.SQL.Text := SQLEXEC + params;

        Query.Open;
        try
          if Query.RecordCount=0 then exit;
  
          Query.First;
          repeat
            procid:=Query.Fields[0].AsInteger; //копия приложения - ID процесса

            RES:=SearchProcessWindowByCaption(procid,DEFAULTWINDOWCAPTION); //хэндл принадлежащего процессу окна
            if RES then
             begin
              Wnd0 := self[-HWOK];
              if Wnd0.Valid then
               if Wnd0.timestamp=Wnd.timestamp then HWOK := 0;               
             end;
            if (HWOK>0) then   // окно найдено
             begin  
               Wnd.HW := HWOK; //новый хэндл окна для текущего
               Wnd.ProcessID := procid;
               Wnd.ThreadID := 0;
               RESULT:=True;
               break;
             end;
            Query.Next;
          until Query.Eof;
  
        finally
          Query.Close;
        end;
  
  
      finally
        Query.Free;
      end;
    finally
      Connection.Free
    end;
except on E: Exception do
  //ShowMessage(E.Message);
end;
end;

procedure TNAVWindows.SetHook(index: integer; Active: boolean);//: boolean
begin
  //RESULT:=false;
  if self.WinNum > index then
  if self[index].Valid then
  try
    if Active then
      with self[index] do HH:=SetupHook(dll,HW) // self[index].
     else
      {RESULT:=}ResetHook(self[index].HH);

  except

  end;
end;

procedure TNAVWindows.setWindow(key: Integer; Window: TNAVWindow);
var Wnd: TNAVWindow;
begin
  if key<0 then
   begin
     Wnd:=self.WindowByHandle(abs(key));
     if Wnd.Valid then
      begin
        self.Windows[self.WindowIndexByHandle(abs(key))]:=Window;// Wnd:=Window;

        exit; //присвоение значения по хэндлу
      end;
   end;

  if key>self.WinNum then
     self.WinNum:=key+1;

  self.Windows[key]:=Window;


end;

{ TNAVWindow }

function TNAVWindow.GetWindowCaption: boolean;
var pTitle: PAnsiChar; l,p:integer;
begin
  RESULT:=false;
  if HW=0 then exit;
  l:=GetWindowTextLength(HW);
  pTitle:=GetMemory(l+1);
  RESULT:=GetWindowText(HW,pTitle,l+1)=S_OK;
  Default:=copy(pTitle,1,l);  setLength(Default,l);  //Default:=str;
  p:=pos(#$A0,Default);
  if p>0 then SetLength(Default,p-1);
end;


function TNAVWindow.PresentPassport: TWindowPassport;
begin
  RESULT[0]:=chr(self.cb);
  RESULT[1]:=self.Server;
  RESULT[2]:=self.Database;
  RESULT[3]:=self.Company;
  RESULT[4]:=IntToStr(self.ProcessID);
  RESULT[5]:=IntToStr(self.ThreadID);
  RESULT[6]:=IntToStr(self.HW);
  RESULT[7]:=DateTimeToStr(self.timestamp);
end;

function TNAVWindow.SendForActivate: boolean;
var res: Cardinal;
begin
  //RESULT:=False;
  RESULT:= SendMessageTimeout(self.HW,WM_SYSCOMMAND, SC_RESTORE, 0{,self.HW},SMTO_ABORTIFHUNG,4000,res)<>0;
  RESULT:=SetForegroundWindow(self.HW);
end;

function TNAVWindow.SetWindowCaption: boolean;
var WTitle: String;
begin
  RESULT:=False;
  if Server ='' then exit;
  if Company = '' then
    WTitle:=Server+'.'+Database
   else WTitle:=Server+'.'+Company+'$'+Database;
try
    WTitle := Concat(Default,#$A0,CHR(cb),#$A0,WTitle);
    RESULT:=SetWindowText(HW,PAnsiChar(WTitle));
except on E: Exception do
end; 
end;

function TNAVWindow.Significance: Integer;
begin
  RESULT:=Sign(HW)*(8*Sign(length(trim(Server))) + 4*Sign(length(trim(Database)))+2*Sign(length(trim(Company)))+1);
end;

function TNAVWindow.Valid: boolean;
begin
  RESULT:=self.HW>0;
end;
{ TVitrail }

constructor TVitrail.Create(fileini: string);
var   line: string; //iniFile: TIniFile;
l,p, k,code: integer;
ff: textfile;
ch:  byte;
begin
  inherited Create;
  self.CaseSensitive:=false;
  if FileExists(fileini) then
   begin
     AssignFile(ff,fileini);
     Reset(ff);
     try
       repeat
        readln(ff,line);
        p:=pos('=',line);
        if p>0 then
         begin
           Val(copy(line,p+1),ch,code);
           if code=0 then
            begin
              setlength(line,p-1);
              l:=p-1;
              p:=pos('.',line);
              self.InsertMosaic(copy(line,1,p-1),copy(line,p+1,l),ch);
            end;
         end;
       until Eof(ff);
     finally
       CloseFile(ff);
     end;
   end; 
end;



function TVitrail.InsertMosaic(Server, Database: string; Mosaic: byte): Integer;
var p: integer;
begin
  Server:=trim(Server);
  if server[1]='[' then
   begin
    Server:=copy(Server,2);
    p:=pos(']',server);
    if p>0 then Setlength(Server,p);
    Server:=trim(Server);
   end;

  Database:=trim(Database);
  if Database[1]='[' then
   begin
    Database:=copy(Database,2);
    p:=pos(']',Database);
    if p>0 then Setlength(Database,p);
    Database:=trim(Database);
   end;

  p:=self.Add(Concat(UpperCase(Server),'.',UpperCase(Database)));
  if p>=0 then
   begin
     if p>=length(self.Kind) then
      SetLength(self.Kind, p+1);
     self.Kind[p]:=Mosaic;
   end;
end;



function TVitrail.SelectMosaic(Server, Database: string): byte;
var p: integer;
begin
  RESULT:=6;
  p:=self.IndexOf(UpperCase(Server)+'.'+UpperCase(Database));
  if p>-1 then  
   if length(self.Kind)>p then
    RESULT:= self.Kind[p];
end;



function TVitrail.DatabasesSet: TStrArray;
var k,p: integer; line: string;
begin
  k:=self.Count;
  if k<=0 then exit;

  SetLength(RESULT,self.Count);//RESULT:=TStringList.Create;
  for k := 0 to self.Count - 1 do
   begin
     line:=self[k];
     p:=pos('.',line);
     if p>0 then
      RESULT[k]:=(copy(line,p+1));
   end;
end;

function TVitrail.KindsSet: TStrArray;
var k: integer;
begin
  k:=self.Count;
  if k<=0 then exit;

  SetLength(RESULT,self.Count);////RESULT:=TStringList.Create;
  for k := 0 to self.Count - 1 do
   case self.Kind[k] of
     4: RESULT[k]:=('PRODUCTIVE');
     3: RESULT[k]:=('DEVELOPER');
     2: RESULT[k]:=('TEST');
   end;
end;

function TVitrail.PaintMosaic(fileini: string): boolean;
var ff: textfile; k: integer;
begin
  RESULT:=false;
  AssignFile(ff,fileini);
try
    Rewrite(ff);
    try
      for k:=0 to self.Count-1 do
        writeln(ff,self[k]+'='+IntToStr(self.Kind[k]));
    finally
      CloseFile(ff);
    end;
    RESULT:=True;
except on E: Exception do
  MessageDlg('Схоранение в файл "'+fileini+'" вызвало исключение "'+E.Message+'"',mtError,[mbCancel],0)
end;
end;

function TVitrail.ServersSet: TStrArray;
var k,p: integer; line: string;
begin
  k:=self.Count;
  if k<=0 then exit;

  SetLength(RESULT,self.Count);////RESULT:=TStringList.Create;
  for k := 0 to self.Count - 1 do
   begin
     line:=self[k];
     p:=pos('.',line);
     if p>0 then
      RESULT[k]:=(copy(line,1,p-1));
   end;
end;


initialization
  dll:=LoadLibrary('Project1dllHook.dll');
finalization
  FreeLibrary(dll);
end.
