unit Unit3WebManager;

interface

uses Windows, Messages, SysUtils, Variants, Classes,ADODB,StdCtrls, DB,inifiles,
ActiveX, MAth, UnitConfig, UnitFileUpLoad, VCLZip;

type    TDomainDescr = Record
          id: integer;
          name: string[50];
          server: string[50];
          db: string[50];
          firm: string[50];
          //filename: string[255];
        End;

        TWebRequestDesc = Record
          domain: integer;
          ClientNAV: string;
          WarhousesMask: longint;
          email: string;
        End;

      TWebManager = Class
      public
        function WebExportsMaskRequest(DomainNo: integer; ClientNAV: string; var email: string; var CY: string; var Templ: integer; webfilter: boolean): integer;
        function WebExportsRequest(var Desc: TWebRequestDesc): boolean;
        function WebExportsMaskReconfig(Mask: integer; Domain: integer; ClientNAV: string; var email: string; var CY: string; var Templ: integer; webfilter: boolean): Integer;

        function WebUserExportsMaskRequest(DomainNo: integer; Login: string; var email: string; var CY: string; var Templ: integer): integer;
        function WebUserExportsMaskReconfig(Mask: integer; DomainNo: integer; Login: string; var email: string; var CY: string; var Templ: integer): Integer;

//        function WebUserConfigOnceExport(Mask, DomainNo: Integer; Login: string; var email: string; var CY: string; var Templ: integer): Integer;
//        function WebConfigOnceExport(Mask, Domain: Integer; ClientNAV: string; var email: string; var CY: string; var Templ: integer): Integer;

        function WebUserInteractiveExport(Domain: integer; Login: string; var ClientID, PriceGroup: integer): boolean; overload;
        function WebUserInteractiveExport(Domain: integer; Login: string; idwh: integer; cy, zipname: string): boolean; overload;

        function getSALT: string;

        procedure Connect;
        procedure Disconnect;
      published
        constructor Create;
        destructor Destroy; override;
      private
        server,
        database,
        login,
        password: string;


        setapprole: boolean;


        folder: string;

        Connection: TADOConnection;
        Query: TADOQuery;

        lastError : string;

        procedure Init;


        function generateConnStringByLogin: string;

        function getClientNAVbyLogin(idd: integer; Login: string): string;

        function ConnectToNAV(DomainDsc: TDomainDescr; var NAVConn: TADOConnection): boolean;
        function DisconnectFromNAV(var NAVConn: TADOConnection): boolean;




        function GetDomainById(idd: integer):TDomainDescr;
        function SearchIDClient(idd: integer; ClientNAV: string): integer;
        function AddClientToDataBase(idd: integer; ClientNAV: string): integer;
        function GetExportsMask(ClientID: integer; var email: string; var CY: string; var Templ: Integer; webfilter: boolean): integer;


        function SwitchOffExport(ClientID, whID: integer; email, CY: string; Templ: integer): boolean;
        function SwitchOnExport(ClientID, whID: integer; email, CY: string; Templ: integer): boolean;
        function CommitExport(ClientID, whID: integer; email, CY: string; Templ: integer): boolean;

        function LocateWarehouse(cldomain, idwh: integer): integer;
//        function SwitchOffOnceExport(ClientID, whID: integer; email, CY: string; Templ: integer): boolean;
//        function SwitchOnOnceExport(ClientID, whID: integer; email, CY: string; Templ: integer): boolean;
//        function CommitOnceExport(ClientID, whID: integer; email, CY: string; Templ: integer): boolean;

//        function GetOnceExports(ClientID: integer; var email: string; var CY: string; var Templ: Integer; webfilter: boolean): integer;
//        function DiscountsForUser(Domain: integer; Login: string; var ClientID, PriceGroup: integer): boolean;


        function GetClientPriceGroup(ClientID: integer): integer;
        function InsertUserDiscounts(Domain, ClientID: integer; ClientNAV: string): boolean;
        function GeneratePriceList(ClientID, ClDomain, IDWH: integer;  cy, zipname, ClientNAV: string): boolean;
     End;

  //function WebExportsMaskRequest
var  WebManager: TWebManager;
implementation

uses UnitEventsLog;

const FILEINI = 'WebConfig.ini';
      NUMOFWAREHOUSES = 3;
      UNITNO = 3;

      CENTURY = 60*24*36525;
function x(y: string): string;
var k,l: integer;
begin
  l:=length(y);
  for k:= 1 to l do
   y[k]:=pred(y[k]);
  x:=y;
end;

function y(x: string): string;
var k,l: integer;
begin
  l:=length(x);
  for k:= 1 to l do
   x[k]:=pred(x[k]);
  y:=x;
end;


function generateConnStr(OLEDBProvider: boolean; user, serverName, dbName: string): string; overload;
var driver, server, UID, WSID, TrustConn, database, lang: string;
    provider, security, initcatalog, datasource, UserID: string;
    defcatalog: string;
    userNameLen: Cardinal;
begin
  if OLEDBProvider then
   begin
    provider:='Provider=SQLOLEDB.1;';
    security:='Integrated Security=SSPI;Persist Security Info=True;';
    userID  :='User ID='+user+';';//copy(user,1,UserNameLen-1)+';';
    datasource:='Data Source='+serverName+';';
    InitCatalog := 'Initial Catalog='+dbName+';';
    RESULT:=provider+security+UserID+initcatalog+datasource;
   end
   else
   begin
    driver := 'DRIVER=SQL Server;';
    server := 'SERVER='+serverName+';';
    UID    := 'UID=;';
    WSID   := 'WSID='+trim(user)+';';//copy(user,1,UserNameLen-1)+';';
    TrustConn := 'Trusted_Connection=Yes;';
    database := 'DATABASE='+dbName+';';
    lang   :='LANGUAGE=русский;';
    RESULT:= driver + server + UID + WSID + TrustConn + database + lang;
   end;
end;

function generateConnStr(OLEDBProvider: boolean): string;    overload;
var driver, server, UID, WSID, TrustConn, database, lang, user: string;
    provider, security, initcatalog, datasource, UserID: string;
defcatalog: string;
userNameLen: Cardinal;
IniFile : TIniFile;  serverName, dbName: string;
begin
//  serverName := 'AMD';
//  dbName := 'UEXPORT';

  IniFile:=TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+FILEINI);
  try
    serverName:=IniFile.ReadString('MAINDATABASE','server',serverName);
    dbName := IniFile.ReadString('MAINDATABASE','database',dbName);
  finally
    FreeAndNil(IniFile);
  end;

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

function SaveToCSV(dataset: TADOQuery; csvfilename, title: string): boolean;
var i, j, M, N : integer;
  line: string;
  csv: text;
begin
  RESULT:=false;
  N:=dataset.RecordCount;
  if N=0 then exit;
  M:=dataset.Fields.Count;
  dataset.First;
  Assign(csv,csvfilename);
  //ShowMessage(csvfilename);
  try
    Rewrite(csv);
    if title<>'' then writeln(csv, title);
    for i := 0 to N - 1 do
     begin
       line:='';
       if dataset.Eof then break;      //exit вернёт false
       for j := 0 to M - 1 do
        line:=line+trim(dataset.Fields[j].AsString)+';';
       SetLength(line, length(line)-1);
       writeln(csv,line);
       dataset.Next;
     end;
    RESULT:=dataset.Eof;
  finally
    CloseFile(csv);
  end;
end;



{ TWebManager }

function TWebManager.AddClientToDataBase(idd: integer;  ClientNAV: string): integer;
var     DomainDsc: TDomainDescr;   ConnNAV: TADOConnection; Q0, QNAV: TADOQuery;
    SQLselect, SQLinsert: string;
begin
  RESULT:=0;
  DomainDsc := self.GetDomainById(idd);
  if self.ConnectToNAV(DomainDsc,ConnNAV) then
  try
    Q0:=TADOQuery.Create(nil);
    try
      Q0.Connection := self.Connection;

      SQLInsert:=' INSERT INTO Clients([NAV_Client],[NAME],[DOM],[e_mail],[pricegroup]) '  //*! запрос дописать
      ;
      QNAV:=TADOQuery.Create(nil);
      try
        QNAV.Connection := ConnNAV;
        QNAV.LockType := ltReadOnly;
        QNAV.CursorType := ctStatic;

        SQLselect :=  'SELECT  [No_] ,[Name],[E-Mail]'
        +',CASE [Customer Price Group] WHEN ''ОПТ'' THEN NULL WHEN ''ОПТ РБ'' THEN 1 WHEN ''ОПТ РФ'' THEN 2 ELSE NULL END as PrGr'
        +'  FROM ['+DomainDsc.firm+'$Customer] WHERE  [No_] =';
        QNAV.SQL.Text := Concat(SQLselect,''''+ClientNAV+'''');

try
        QNAV.Open;
        if QNAV.RecordCount<1 then exit;

        QNAV.First;
        SQLSelect := ' VALUES ';

        SQLselect := SQLSelect +' ('''+ trim(QNAV.FieldByName('No_').AsString)+'''';
        SQLselect := SQLSelect +', '''+ trim(QNAV.FieldByName('Name').AsString)+'''';
        SQLSelect := SQLSelect +', '+ IntToStr(idd);
        SQLselect := SQLSelect +', '''+ trim(QNAV.FieldByName('E-mail').AsString)+'''';
        if QNAV.FieldByName('PrGr').IsNull then SQLselect := SQLSelect +', NULL'
         else SQLselect := SQLSelect +', '+ trim(QNAV.FieldByName('PrGr').AsString);
        SQLselect := SQLSelect +' )';
        QNAV.Close;
        SQLInsert := Concat(SQLinsert,SQLselect);



except on E: Exception do
  begin
    self.lastError:=E.Message;
    EventsLog.AddEvent(CATEGORY_SQL,UNITNO,'Не удалось получить данные из таблицы клиентов NAV: '+E.Message);
    exit;
  end;
end;

        SQLSelect := ' SELECT SCOPE_IDENTITY()';
        Q0.SQL.Text:= Concat(SQLInsert,';',SQLSELECT);

        Q0.Connection.BeginTrans;
try
          Q0.Open;
          Q0.First;
          RESULT:=Q0.Fields[0].AsInteger;
          Q0.Close;
          Q0.Connection.CommitTrans;
except on E: Exception do
          begin
            self.lastError := E.Message;
            Q0.Connection.RollbackTrans;
            EventsLog.AddEvent(CATEGORY_SQL,UNITNO,'Не удалось дополнить таблицу клиентов в базе Универсального экспорта: '+E.Message);
          end;
end;
      finally
        QNAV.Free;
      end;
        //ни в коем случае! Q0.ExecSQL;
    finally
    Q0.Free;
    end;
  finally
    self.DisconnectFromNAV(ConnNAV);
  end;

end;

function TWebManager.CommitExport(ClientID, whID: integer; email,
  CY: string; Templ: integer): boolean;
begin
  self.SwitchOffExport(ClientID,whID,email,CY,Templ);
  self.SwitchOnExport(ClientID,WhID,email,CY,Templ);
end;

procedure TWebManager.Connect;
const TIMEOUT = 300;
begin
try
    self.Connection.Connected := False;

    Self.Connection.ConnectionString := self.generateConnStringByLogin;
    Self.Connection.CommandTimeout := TIMEOUT;
    Self.Connection.Open;
except on E: Exception do
  EventsLog.AddEvent(CATEGORY_Connection,UNITNO,E.Message);
end;
end;





function TWebManager.ConnectToNAV(DomainDsc: TDomainDescr;   var NAVConn: TADOConnection): boolean;
var
 userNameLen: Cardinal; user: string;
begin

  RESULT:=false;
  userNameLen:=255;
  setLength(user, userNameLen);
  getUserName(PAnsiChar(user),userNameLen);
  SetLength(user,userNameLen);
  NAVConn:=TADOConnection.Create(nil);
try
    try
      NAVConn.ConnectionString:=generateConnStr(false, user, DomainDsc.server, DomainDsc.db);
      NAVConn.LoginPrompt := False;
      //repeat
      //until (NAVConn.Connected OR self.setapprole);
        NAVConn.Open;
        try
          {if not self.setapprole then }
          NAVConn.Execute('EXEC [sp_setapprole] ''$ndo$shadow'', ''FF5EC4E40F67BD4EDF3D04F8B84364DAD0'', ''none'', 0, 0');
        except on Err: Exception do
          self.setapprole := not(self.setapprole);
        end;
        RESULT:=NAVConn.Connected;
    finally
      //FreeAndNil(ConnNAV);
    end;
except on E: Exception do
  begin
    self.lastError :=E.Message + ' [' + NAVConn.ConnectionString+']';
    EventsLog.AddEvent(CATEGORY_Connection,UNITNO,'Неудача при соединении с сервером NAV: '+E.Message);
  end;
end;

end;

constructor TWebManager.Create;
begin
  inherited;
  self.Connection := TADOConnection.Create(nil);
end;

destructor TWebManager.Destroy;
begin
  self.Connection.Free;
  inherited;
end;

procedure TWebManager.Disconnect;
begin
  self.Connection.Close;
end;


function TWebManager.DisconnectFromNAV(var NAVConn: TADOConnection): boolean;
begin
  RESULT:=False;
try

    //NAVConn.Execute('EXEC [sp_unsetapprole] ''none'' ' );
except on E: Exception do self.lastError := E.Message;
end;
try
  try
    NAVConn.Close;
  finally
    FreeAndNil(NAVConn);
  end;
  RESULT:=True;
except on E: Exception do
  begin
    self.lastError :=E.Message;    //+' ['+NAVConn.ConnectionString+']'*!*
    EventsLog.AddEvent(CATEGORY_Connection,UNITNO,'Неудача при отсоединении от сервера NAV: '+E.Message);
  end;
end;
end;

function TWebManager.generateConnStringByLogin: string;
var driver, server, UID, WSID, TrustConn, database, lang, user, PWD: string;
provider, security, initcatalog, datasource, UserID: string;
begin
   begin //подключение через провайдер OLE DB
      provider:='Provider=SQLOLEDB.1;';
      security:='Integrated Security=SSPI;';//Persist Security Info=True;
      userID  :='User ID='+self.login+';';
      datasource:='Data Source='+self.server+';';
      InitCatalog := 'Initial Catalog='+self.database+';';
      RESULT:=provider+security+UserID+initcatalog+datasource;
   end
end;
function TWebManager.GeneratePriceList(ClientID, ClDomain, IDWH: integer;   cy, zipname, ClientNAV: string): boolean;//function TExportDaemon.generateQuantsRequestByWarehouseX(whXid:integer): string;
const PRICEREQUEST ='SQLPriceRequest';
      PRICECOEFF = '1.05 ';
      DEFAULTTEMPL = 'RTrim(Item_Brand), RTrim(Code), RTrim(Item_Name),Qq = RTrim (Case when QNTY<10 then cast(QNTY as char) when QNTY<50 then ''10>'' when QNTY<100 then ''50>'' else ''100>''  END), Shipment, cy,';
      SHAREDFOLDER = 'C:\Service\Files';
      REQUESTTIMEOUT = 150;
var pricereq, fldlist: string;
    PrGr: Integer;
    TemplList,ReplList: TStringList;
    QPrice: TADOQuery;
    Zip: TVCLZip;
    filename, fileext, folder: string;
    ftptransfer: boolean;
begin
  RESULT:=false;
  pricereq :=loadTextDataByTag(PRICEREQUEST); //+ IntToStr(-IDWH) {+' AND Adds = 0'}
  fldlist:=DEFAULTTEMPL;
  folder:= getTempDir(true);  // temp dir with ending backslash SHAREDFOLDER;


  fileext:='.csv';
  case IDwh of
    1:
     filename:='Minsk';
    2:
     filename:='Podolsk';
    3:
     filename:='Ekaterinburg';
    end;
    filename := 'export'+'_'+filename+'_';
    filename :=filename+Trim(CY)+'_'+ClientNAV+fileext; //fileext:=''''+fileext+'''';

    filename:=folder+filename; //+fileext'''' ++''''
  filename:=trim(filename);

  zipname:=Trim(zipname);
  ftptransfer:= ExtractFilePath(zipname)='';
  if ftptransfer then
   zipname:=folder+zipname;

  PrGr:=self.GetClientPriceGroup(ClientID);
  if PrGr=0 then exit;

//  pricereq:=StringReplace(pricereq,'##CLIENT_DOMAIN##',IntToStr(PrGr),[rfReplaceAll]);
//  pricereq:=StringReplace(pricereq,'##CYCODE##',cy,[rfReplaceAll]);
//  pricereq:=StringReplace(pricereq,'##CLIENT_ID##',IntToStr(ClientID),[rfReplaceAll]);
//  pricereq:=StringReplace(pricereq,'*',fldlist,[]);

  TemplList:=TStringList.Create; ReplList:=TStringList.Create;
  try
    TemplList.Add('##EXP_ID##');ReplList.Add('0'); // 0 for unspecified export => without trademark filters
    TemplList.Add('##IDWH##');ReplList.Add(IntToStr(IDWH));
    TemplList.Add('##CLIENT_ID##');ReplList.Add(IntToStr(-ClientID));
    TemplList.Add('##CLPRGR##');ReplList.Add(IntToStr(PrGr));//##CLIENT_DOMAIN##
    TemplList.Add('##ABROADFILTER##');ReplList.Add('Item_Brand');
    TemplList.Add('##ABROADLINEFILTER##');ReplList.Add('Line');
    TemplList.Add('##CYCODE##');ReplList.Add(cy);
    TemplList.Add('*,');ReplList.Add(fldlist);

    if self.LocateWarehouse(ClDomain,IDWH)>0 then
     begin   //транспортная надбавка для удалённого склада
       TemplList.Add('Qq.price*');ReplList.Add(PRICECOEFF+'*Qq.price*'); // 1.025
     end;

    pricereq:=MultyReplace(pricereq,TemplList,ReplList);
  finally
     FreeAndNil(TemplList);FreeAndNil(ReplList);
  end;

  QPrice:=TADOQuery.Create(nil);
  try
    QPrice.Connection:=self.Connection;
    QPrice.CursorLocation:=clUseClient;
    QPrice.CursorType:=ctStatic;//*
    QPrice.DisableControls;;
try
  QPrice.SQL.Text:=pricereq;
      QPrice.CommandTimeout := REQUESTTIMEOUT;
      QPrice.Open;
      if SaveToCSV(QPrice,filename,'') then
       begin
         Zip:=TVCLZip.Create(nil);
         try
           Zip.ZipName := zipname;//ChangeFileExt(filename,'.zip');
           Zip.FilesList.Add(filename);
           if FileExists(Zip.ZipName) then DeleteFile(Zip.ZipName);
           if Zip.Zip>0 then
            if ftptransfer then
            try
              RESULT:=PutFTP(zipname);
              if NOT RESULT then
                EventsLog.AddEvent(CATEGORY_FILE, UNITNO, 'Ошибка FTP');
            finally
              DeleteFile(zipname);
            end
            else RESULT:=True;

         finally
           FreeAndNil(Zip);
           try
             DeleteFile(filename);
           except on E: Exception do

           end;
         end;
       end
       else
       EventsLog.AddEvent(CATEGORY_FILE, UNITNO, 'Не удалось выполнить сохранение!');;


except on E: Exception do
  //self.lastError:=E.Message;
  EventsLog.AddEvent(CATEGORY_FILE, UNITNO, E.Message);
end;

  finally
    FreeAndNil(QPrice);
  end;

end;

//   begin
//    driver := 'DRIVER=SQL Server;';
//    server := 'SERVER='+self.server+';';
//    UID    := 'UID='+self.login+';';
//    WSID   := '';//'WSID='+copy(user,1,UserNameLen-1)+';';
//    PWD    := 'PWD='+self.password+';';
//
//    TrustConn := '';//'Trusted_Connection=Yes;';
//    database := 'DATABASE='+self.database+';';
//    lang   :='LANGUAGE=русский;';
//    RESULT:= driver + server + UID + WSID + PWD + TrustConn + database + lang;
//   end;

function TWebManager.getClientNAVbyLogin(idd: integer; Login: string): string;
var ConnNAV: TADOConnection; QCU: TADOQuery; DomainDsc:TDomainDescr; //firm: string;
begin
RESULT:='';
  Login := ''''+Login+'''';
  DomainDsc := self.GetDomainById(idd); //   firm:='Shate-M';
  if self.ConnectToNAV(DomainDsc,ConnNAV) then
  try
      QCU:=TADOQuery.Create(nil);
      try
        QCU.Connection:=ConnNAV;
        QCU.SQL.Text := 'SELECT [Customer No_] FROM ['+DomainDsc.firm
        +'$Web User] WHERE [Login]='+Login;
        try
          QCU.Open;

          if QCU.RecordCount<>1 then exit;
          QCU.First;
          if QCU.Fields[0].IsNull then exit;
          RESULT:=Trim(QCU.Fields[0].AsString);
          QCU.Close;

         except
          on Err: Exception do
            begin
              self.lastError :=Err.Message;
              EventsLog.AddEvent(CATEGORY_SQL,UNITNO,'Не удалось идентифицировать код клиента: '+Err.Message);
            end;
        end;
      finally
        FreeAndNil(QCU);
      end;
  finally
    self.DisconnectFromNAV(ConnNAV);
  end;
end;

function TWebManager.GetClientPriceGroup(ClientID: integer): integer;

var Qq: TADOQuery;
begin
  Qq:= TADOQuery.Create(nil);
try
      Qq.Connection := self.Connection;
      //self.Connect;

      Qq.SQL.Text := 'SELECT COALESCE([pricegroup],[DOM]) FROM [Clients] WHERE id = '+IntToStr(ClientID);
      RESULT :=0;


try
        Qq.Open;
        if Qq.RecordCount=0 then exit;

        Qq.First;
        Qq.Fields[0].IsNull;
        RESULT:=Qq.Fields[0].AsInteger;








except on E: Exception do
  begin
    self.lastError :=E.Message;
    EventsLog.AddEvent(CATEGORY_SQL,UNITNO,'Неудачная попытка ценовую группу клиента: '+E.Message);//РќРµСѓРґР°С‡РЅР°СЏ РїРѕРїС‹С‚РєР° С†РµРЅРѕРІСѓСЋ РіСЂСѓРїРїСѓ РєР»РёРµРЅС‚Р°
  end;
end;
      //self.Disconnect;
finally
  FreeAndNIl(Qq);
end;
end;

function TWebManager.GetDomainById(idd: integer): TDomainDescr;
var Qq: TADOQuery;
begin
  Qq:= TADOQuery.Create(nil);
try
      Qq.Connection := self.Connection;
      //self.Connect;

      Qq.SQL.Text := 'SELECT * FROM Domains WHERE id = '+IntToStr(idd);
      RESULT.id :=0;
try
        Qq.Open;
        if Qq.RecordCount=0 then exit;

        Qq.First;
        with RESULT do
        begin
          id := QQ.FieldByName('ID').AsInteger;
          name := trim(QQ.FieldByName('Name').AsString);
          server := trim(QQ.FieldByName('Server').AsString);
          db := trim(QQ.FieldByName('DB').AsString);
          firm := trim(QQ.FieldByName('Firm').AsString);
        end;
except on E: Exception do
  begin
    self.lastError :=E.Message;
    EventsLog.AddEvent(CATEGORY_SQL,UNITNO,'Неудачная попытка получить описатель домена: '+E.Message);
  end;
end;
      //self.Disconnect;
finally
  FreeAndNIl(Qq);
end;
end;

function TWebManager.GetExportsMask(ClientID: integer; var email: string; var CY: string; var Templ: Integer;
  webfilter: boolean): integer;
var Q0: TADOQuery;
SQLstr, emailfilter: string;
h, m, p: integer;

begin
  RESULT:=0;
  Q0:=TADOQuery.Create(nil);
try
    Q0.Connection := self.Connection;
    Q0.CursorType := ctStatic;
    Q0.LockType := ltReadOnly;

    SQLstr :=  'SELECT * FROM Exports WHERE ID_Client = '+IntToStr(ClientID);
    if email<>'' then emailfilter:=' AND email like ''%' + email + '%'' '
     else emailfilter := email;

    if webfilter then SQLstr := Concat(SQlstr,' AND Web = 1 ', emailfilter)//SQLStr := SQLstr + ;
     else SQLstr := Concat(SQlstr, emailfilter);

    SQLstr:=SQLstr +' AND INTERVAL>0 AND emailflag = 1 ';
    Q0.SQL.Text :=  SQLStr + ' ORDER BY ID_WH ASC, ID DESC ';

try
      Q0.Open;
      RESULT:=1; //младший бит маски индицирует что связь была установлена
      if Q0.RecordCount<1 then exit;
      Q0.First; h:=0;
      repeat
        if Q0.FieldByName('ID_WH').AsInteger>h then
         begin
          //inc(h);
          h:=Q0.FieldByName('ID_WH').AsInteger;
          M:=1; M:=M SHL h;    //M = 2^h
          RESULT:=(RESULT OR M);
          if email = '' then  email:=trim(Q0.FieldByName('email').AsString);
          if CY='' then CY:=Q0.FieldByName('CY').AsString;
          if Templ=0 then
           if not Q0.FieldByName('ID_Templ').IsNull then
            Templ:=Q0.FieldByName('ID_Templ').AsInteger;

         end;
        Q0.Next;
      until Q0.Eof;
except on E: Exception do
  begin
    self.lastError :=E.Message;
    EventsLog.AddEvent(CATEGORY_SQL,UNITNO,'Не удалось получить список активных экспортов: '+E.Message);
  end;
end;
finally
  FreeAndNil(Q0);
end;



end;

function TWebManager.getSALT: string;
begin
  RESULT:='kuzmich';
end;

procedure TWebManager.Init;
//Init;
var iniFile: TIniFile;
begin
  IniFile:=TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+FILEINI);
  try
    //параметры подключения к основной базе SQL
    self.server:=IniFile.ReadString('MAINDATABASE','server',server);
    self.database := IniFile.ReadString('MAINDATABASE','database',database);

    self.login := y(IniFile.ReadString('SECURITY','Login',''));
    self.password := y(IniFile.ReadString('SECURITY','Pass',''));

    self.folder:=IniFile.ReadString('SERVICE','Folder','C:\Services\UniversalExport');
    //self.fileslocation:=IniFile.ReadString('SERVICE','Share','C:');
    //self.
  finally
    FreeAndNil(IniFile);
  end;

  self.setapprole := false; //инициализация первого подключения к NAV

end;

function TWebManager.InsertUserDiscounts(Domain, ClientID: integer; ClientNAV: string): boolean;
const SQLCLIENTDISCOUNTS = 'SQLSELECT_client_discounts';
      SQLINSERTDISCOUNTS = 'SQLInsertDiscountsValues';
var DomainDsc: TDomainDescr; ConnNAV: TADOConnection;    Q0, QNAV: TADOQuery;
SQLSelect,SQLInsert: string;
client_id, j: integer;
    TemplList, ReplList :TStringList;
begin
  RESULT:=False;
  DomainDsc := self.GetDomainById(Domain);
  if self.ConnectToNAV(DomainDsc,ConnNAV) then
  try
    Q0:=TADOQuery.Create(nil);
    try
      Q0.Connection := self.Connection;
      Q0.Connection.BeginTrans;
      try
        //+++++++++++++++++
        client_id:= -ClientID;//SearchIDClient(Domain,ClientNAV);

        Q0.Connection.Execute('DELETE FROM DISCOUNTS WHERE ID_CLIENT = '+IntTOStr(client_id));
        SQLInsert := loadTextDataByTag(SQLINSERTDISCOUNTS);
        Q0.Prepared :=False;
        Q0.SQL.Text := SQLInsert;
        Q0.Prepared := True;     //+++++++++++?????????????????????????????????????????????????????????????
        try       //СЃРѕР·РґР°РЅРёРµ РґРµС„РѕР»С‚РЅРѕР№ РІС‹СЂРѕР¶РґРµРЅРЅРѕР№ СЃРєРёРґРєРё

            Q0.Parameters[0].Value :=  client_id;
              Q0.Parameters[1].Value := 0;
                  Q0.Parameters[2].Value := '';      //!
                        Q0.Parameters[3].Value := 0;
                              Q0.Parameters[4].Value := 0;
            Q0.Parameters[20].Value := ''; //! [Location Code]

            Q0.ExecSQL;
        except on E: Exception do
          SQLInsert := E.Message;
        end;

        SQLSelect :=  loadTextDataByTag(SQLCLIENTDISCOUNTS);

        TemplList:=TStringList.Create; ReplList:=TStringList.Create;
        with DomainDsc do
         try
          TemplList.Add('##IDCLIENT##');ReplList.Add(IntToStr(client_id));      //<0!
               TemplList.Add('##DATABASE##');ReplList.Add(db);
                    TemplList.Add('##FIRM##');ReplList.Add(firm);
                         TemplList.Add('##CLIENTNAV##');ReplList.Add(clientNAV);
          SQLSelect := MultyReplace(SQLSelect,TemplList,ReplList);
         finally
          FreeAndNil(TemplList);FreeAndNil(ReplList);
         end;

        QNAV:=TADOQuery.Create(nil);
        try
          QNAV.Connection := ConnNAV;
          QNAV.LockType := ltReadOnly;
          QNAV.CursorType := ctStatic;

          QNAV.SQL.Text := SQLSelect;

          try
            QNAV.Open;

            if QNAV.RecordCount=0 then exit;

            QNAV.First; //С†РёРєР»  РїРѕ Р·Р°РїРёСЃСЏРј РїРѕР»СѓС‡РµРЅРЅС‹Рј РґР»СЏ РєР»РёРµРЅС‚Р°
            repeat

              for j:=0 to Q0.Parameters.Count-1 do
                Q0.Parameters[j].Value := QNAV.Fields[j].Value;

try
                Q0.ExecSQL;
except on E: Exception do
   begin SQLInsert := E.Message;      Raise; end;
end;//
              QNAV.Next;
            until QNAV.Eof;

            RESULT:=True;


          finally
            QNAV.Close;
          end;


        finally
          FreeAndNIl(QNAV);
        end;
  SQLSelect := SQLInsert;
        Q0.Connection.CommitTrans;
      except on E: Exception do
        Q0.Connection.RollbackTrans;
      end;
    finally
      FreeAndNil(Q0);
    end;
  finally
    DisconnectFromNAV(ConnNAV);
  end;


end;

function TWebManager.LocateWarehouse(cldomain, idwh: integer): integer;
const SQLWHDOMAIN = 'SELECT [Domain] FROM [Warehouses] WHERE [ID] =';
var Q0: TADOQuery;
begin
  RESULT:=0;
  Q0:=TADOQuery.Create(nil);
  try
    Q0.Connection:=self.Connection;
    Q0.CursorType := ctStatic;
    Q0.LockType := ltReadOnly;
    Q0.SQL.Text := SQLWHDOMAIN + IntToStr(idwh);

    Q0.Open;

    if Q0.Fields[0].IsNull then exit;
    if Q0.Fields[0].AsInteger=cldomain then exit;
    RESULT:=1;
  finally
    FreeAndNIl(Q0);
  end;
end;

function TWebManager.SearchIDClient(idd: integer; ClientNAV: string): integer;
var Q0: TADOQuery;
begin
  RESULT:=0;
  if ClientNAV = '' then exit;

  ClientNAV := '''' + Trim(ClientNAV)+'''';

  Q0:=TADOQuery.Create(nil);
try
    Q0.Connection := self.Connection;
    Q0.CursorType := ctStatic;
    Q0.LockType := ltReadOnly;

    Q0.SQL.Text := 'SELECT TOP 1 * FROM Clients WHERE DOM = '+IntToStr(idd)+' AND NAV_Client = '+ClientNAV + ' ORDER BY ID DESC' ;
    try
      Q0.Open;
      if Q0.RecordCount<1 then exit;


          Q0.First;
          RESULT := Q0.FieldByName('ID').AsInteger;
    except on E: Exception do
  begin
    self.lastError :=E.Message;
    EventsLog.AddEvent(CATEGORY_SQL,UNITNO,'Не удалось получить идентификатор в таблице клиентов: '+E.Message);
  end;
    end;
finally
  FreeAndNil(Q0);
end;
end;

function TWebManager.SwitchOffExport(ClientID, whID: integer; email,
  CY: string; Templ: integer): boolean;
var Q0: TADOQuery;
begin
  RESULT:=False;
  Q0:=TADOQuery.Create(nil);
try
    Q0.Connection := self.Connection;
    Q0.SQL.Text := 'UPDATE Exports SET Emailflag = 0, Interval = NULL, Next_Export = NULL '
    +' WHERE web=1'
    + ' AND ID_Client ='+IntToStr(ClientID)
    + ' AND ID_WH = ' + IntToStr(whID);
try
    RESULT:=  (Q0.ExecSQL > 0);
except on E: Exception do
  begin
    self.lastError :=E.Message;
    EventsLog.AddEvent(CATEGORY_SQL,UNITNO,'Не удалось отключить экспорт: '+E.Message);
  end;
end;
finally
  FreeAndNil(Q0);
end;
end;

function TWebManager.SwitchOnExport(ClientID, whID: integer; email,
  CY: string; Templ: integer): boolean;
var Q0: TADOQuery;
    filename, fileext, subject: string;
begin
  RESULT:=False;
  Q0:=TADOQuery.Create(nil);
try
    Q0.Connection := self.Connection;
    Q0.SQL.Text := 'UPDATE Exports SET Emailflag = 1,  email = '''+ email +''''
    +',blocked = 0, Interval = 1440, NEXT_Export = DATEADD(hh, 12, GetDate())'
    +', CY = '''+ CY +''''
    +',[ID_TEMPL] ='+IntToStr(Templ)
    +' WHERE web=1'
    + ' AND ID_Client ='+IntToStr(ClientID)
    + ' AND ID_WH = ' + IntToStr(whID);
try
    RESULT:=  (Q0.ExecSQL > 0);

    if RESULT then exit;


    fileext:='.csv';
    case whID of
    1:
     begin filename:='Minsk'; subject:='Минск' end;
    2:
     begin filename:='Podolsk'; subject:='Подольск' end;
    3:
     begin filename:='Ekaterinburg'; subject:='Екатеринбург' end;
    end;
    filename := 'export'+'_'+filename+'_';
    filename :=filename+Trim(CY)+'_'; fileext:=''''+fileext+'''';
    filename:='''' +IncludeTrailingBackslash(self.folder)+filename+'''';
    subject :=Concat('Склад ',' '+subject+'. ','Актуальное предложение Шате-М Плюс');

    Q0.SQL.Text := 'INSERT INTO Exports ([ID_Client],[ID_WH],[CY],[blocked],[PRICE],[NAV_Client],[INTERVAL],[NEXT_EXPORT]'
          +' ,[FILE_NAME],[ID_TEMPL],[emailflag],[email],[emailsubj],[web])'
     + ' VALUES ('+INtToStr(ClientID)+','+IntToStr(whID)+','''+CY+''','
     + ' 0 , ''Web'' , (SELECT RTRIM(NAV_Client) FROM Clients WHERE ID ='+IntToStr(ClientID)+') , 1440 , DATEADD(hh,+12,GETDATE()) ,'
     + filename+'+(SELECT RTRIM(NAV_Client) FROM Clients WHERE ID ='+IntToStr(ClientID)+')+'+fileext
     +' , '+IntToStr(Templ)+' , 1, '''+email+''','+''''+subject+''''
     +' ,1 ) ';

    RESULT:=  (Q0.ExecSQL > 0);




except on E: Exception do
  begin
    self.lastError :=E.Message;
    EventsLog.AddEvent(CATEGORY_SQL,UNITNO,'Не удалось включить экспорт: '+E.Message);
  end;
end;
finally
  FreeAndNil(Q0);
end;

end;

function TWebManager.WebExportsMaskReconfig(Mask, Domain: integer;
  ClientNAV: string; var email, CY: string; var Templ: integer; webfilter: boolean): Integer;

var ClientID: integer;
    h, act, Mask0: integer;   email0, CY0: string; Templ0, ShifTmpl: integer;
begin
  RESULT := 0;

  ClientID:=self.SearchIDClient(Domain,ClientNAV);
  //если нет клиента создаем нового
  if ClientID=0 then ClientID:=self.AddClientToDataBase(Domain,  ClientNAV);
  if ClientID=0 then exit; //выход если не удалось ничего поделать

  Templ0:=0;
  Mask0:=self.WebExportsMaskRequest(Domain, ClientNAV,email0,CY0,Templ0,webfilter); //-false -существующее положение дел

  for h := 1 to NUMOFWAREHOUSES do  //*число складов тоже получить по запросу
   begin
     //для выгрузки с иностранного склада выбирается шаблон со смещением +30
     if (Templ<6) OR (Templ>35) then ShifTmpl:=0 else
      ShifTmpl:=30*self.LocateWarehouse(Domain,h);

     act:=sign( ((Mask shr h)AND 0001)-((Mask0 shr h)AND 0001) );
     case act of   // выбор типа действия для указанного намера склада
     -1:     //отключение экспорта
         self.SwitchOffExport(ClientID,h,email, CY, Templ+ShifTmpl);
     +1:    //включение экспорта
         self.SwitchOnExport(ClientID,h,email, CY, Templ+ShifTmpl);
     0:    //обновление параметров экспорта для включенных
      if ( Mask AND Mask0 AND (1 shl h) )<>0 then
       if (CY<>CY0)OR(email<>email0)OR(Templ+ShifTmpl<>Templ0) then self.CommitExport(ClientID,h,email, CY, Templ+SHifTmpl);
     end;
   end;




  RESULT := Mask OR 1;
end;

function TWebManager.WebExportsMaskRequest(DomainNo: integer; ClientNAV: string; var email: string;var CY: string; var Templ: integer; webfilter: boolean): integer;
var
    ClientID: integer;
begin
  RESULT:=0;
  ClientID := self.SearchIDClient(DomainNo, ClientNAV);
  if ClientID=0 then exit;    //*!* что делать если нет связи?
  RESULT:= self.GetExportsMask(ClientID,email,CY,Templ,webfilter); //*true фильтр включен-*false отключенный вэб-фильтр
end;

function TWebManager.WebExportsRequest(var Desc: TWebRequestDesc): boolean;
var     DomainDsc: TDomainDescr;
begin
  DomainDsc := GetDomainById(Desc.domain);
end;

function TWebManager.WebUserExportsMaskReconfig(Mask, DomainNo: integer;
  Login: string; var email, CY: string; var Templ: integer): Integer;
var ClientNAV: string;
begin
  RESULT:=0;
  ClientNAV:=self.getClientNAVbyLogin(DomainNo,Login);
  if ClientNAV = ''  then exit;

  RESULT:=self.WebExportsMaskReconfig(Mask,DomainNo,ClientNAV,email,CY,Templ,true);

end;

function TWebManager.WebUserExportsMaskRequest(DomainNo: integer; Login: string;
  var email, CY: string; var Templ: integer): integer;
var ClientNAV: string;
begin
  RESULT:=0;
  ClientNAV:=self.getClientNAVbyLogin(DomainNo,Login);
  if ClientNAV = ''  then exit;

  RESULT:=self.WebExportsMaskRequest(DomainNo,ClientNAV,email,CY,Templ,true);

end;

function TWebManager.WebUserInteractiveExport(Domain: integer; Login: string;  idwh: integer; cy, zipname: string): boolean;
var ClientNAV: string;
  ClientID: integer;
  filename, fileext: string;
begin
  RESULT:=False;
  ClientNAV:=self.getClientNAVbyLogin(Domain,Login);
  if ClientNAV = ''  then exit;
  ClientID:=SearchIDClient(Domain, ClientNAV);
  if ClientID=0 then  ClientID:=AddClientToDataBase(Domain, ClientNAV);   //РїРѕС‚СЂРµР±СѓРµС‚СЃСЏ С‚Р°РєР¶Рµ РІС‹С‚СЏРЅСѓС‚СЊ С†РµРЅРѕРІСѓСЋ РіСЂСѓРїРїСѓ РєР»РёРµРЅС‚Р°
  if self.InsertUserDiscounts(Domain, ClientID, ClientNAV) then
    RESULT:=self.GeneratePriceList(ClientID,Domain,idwh,cy,zipname, Trim(ClientNAV));

  if NOT RESULT then
   try
    EventsLog.AddEvent(CATEGORY_SQL, UNITNO, self.lastError);
   except

   end;
end;

function TWebManager.WebUserInteractiveExport(Domain: integer; Login: string; var ClientID, PriceGroup: integer): boolean;
var ClientNAV: string;
begin
  RESULT:=False;
  ClientNAV:=self.getClientNAVbyLogin(Domain,Login);
  if ClientNAV = ''  then exit;
  ClientID:=SearchIDClient(Domain, ClientNAV);
  if ClientID=0 then  ClientID:=AddClientToDataBase(Domain, ClientNAV);   //РїРѕС‚СЂРµР±СѓРµС‚СЃСЏ С‚Р°РєР¶Рµ РІС‹С‚СЏРЅСѓС‚СЊ С†РµРЅРѕРІСѓСЋ РіСЂСѓРїРїСѓ РєР»РёРµРЅС‚Р°

  if ClientID=0 then exit;

  PriceGroup:=GetClientPriceGroup(ClientID);
  if PriceGroup=0 then exit;

  if self.InsertUserDiscounts(Domain, ClientID, ClientNAV) then
    RESULT:=True;

  //RESULT:=self.WebExportsMaskRequest(DomainNo,ClientNAV,email,CY,Templ,true);
end;

initialization
try
    CoInitializeEx(nil, COINIT_MULTITHREADED);
    WebManager := TWebManager.Create;
    WebManager.Init;
except on E: Exception do
 begin
  EventsLog.AddEvent(CATEGORY_Init,UNITNO, E.Message);
  Raise;
 end;
end;
finalization
  WebManager.Free;
  CoUninitialize;
end.
