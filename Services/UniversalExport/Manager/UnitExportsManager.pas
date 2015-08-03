unit UnitExportsManager;

interface

uses   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Grids, DBGrids, DBCtrls
  ,HSAdvAPI , Masks
  ,inifiles;

type

      TDomainDescr = Record
          id: integer;
          name: string[50];
          server: string[50];
          db: string[50];
          firm: string[50];
          //filename: string[255];
        End;

      TExportsManager = Class

      public
        defaultfolder : string;
        newClient: boolean;
        newExport : boolean;
        searchkey: string;
        filterClients,
        filterExports : boolean;

        Connection : TADOConnection;
        server, database :string;

        ClientID,
        ExportID  : integer;
        ClientsTbl,
        ExportsTbl :TADOTable;

        ClientsSrc,
        ExportsSrc :TDataSource;

        DomainsTbl: TADOTable;
        DomainsSrc: TDataSource;


        TemplatesTbl: TADOTable;
        TemplatesSrc: TDataSource;

        WarehousesTbl: TADOTable;
        WarehousesSrc: TDataSource;

        PriceListsTbl: TADOTable;
        PriceListsSrc: TDataSource;

        PriceGroupsTbl: TADOTable;
        PriceGroupsSrc: TDataSource;

        CurrenciesTbl: TADOTable;
        CurrenciesSrc: TDataSource;

        procedure Init;

        procedure Connect;
        procedure Disconnect;

        procedure appendClient;
        procedure appendExport;

        function updateDomain: boolean;
        //function updateClientDomain(NAVSrc: TDataSource;var DD: TDomainDescr):boolean;
        procedure ConfigTableByDomain(Tbl: TADOTable; tablename: string);
        function generateFileName: string;
        function generateMailSubject: string;
        function generateConnStringByLogin: string;
        procedure OpenExportFile(FileName: string);
        class function AccordanceToMask(str, mask: string): boolean;
      published
        constructor Create;
        destructor Destroy;
      private
        login: string;
        password: string;
        user: string;
        DD: TDomainDescr;
        fileslocation: string;
        function y(x: string):string;
        function x(y: string): string;

      End;

const EXPORTFIELDNAMES: array[0..17] of string =
        (//'ID',''
        'ID'
,'Priority'
,'ID_Client'
,'ID_WH'
,'CY'
,'blocked'
,'PRICE'
,'NAV_Client'
,'INTERVAL'
,'LAST_EXPORT'
,'NEXT_EXPORT'
,'FILE_NAME'
,'ID_TEMPL'
,'emailflag'
,'email'
,'emailsubj'
,'emailbody'
,'emailzip'
           );

 var
      Manager: TExportsManager;

 procedure TablesRelationLinking(DataSource: TDataSource; masterTable, slaveTable: TADOTable; masterFields, slaveFields: string);
 function generateConnStr(OLEDBProvider: boolean; user, serverName, dbName: string): string; overload;
 function generateConnStr(OLEDBProvider: boolean): string; overload;
implementation
const FILEINI = 'Config.ini';
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

//'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=True;User ID=shingarev;Initial Catalog=;Data Source=AMD;';
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



procedure TablesRelationLinking(DataSource: TDataSource; masterTable, slaveTable: TADOTable; masterFields, slaveFields: string);
begin
  masterTable.MasterSource := nil;

  masterTable.MasterFields :='';
  masterTable.IndexFieldNames := '';

  slaveTable.MasterFields := masterFields;
  slaveTable.IndexFieldNames := slaveFields;

  slaveTable.MasterSource  := DataSource;
end;

{ TExportsManager }

//функционал реализован в IsLike()
class function TExportsManager.AccordanceToMask(str, mask: string): boolean;
var k, l, p, m: integer;
    buf: string;
    Parts: TStringList;
begin
  RESULT := MatchesMask(trim(str),trim(mask));
  exit;
  RESULT:=false;
  str:=trim(str);
  l:=length(mask);
  if l = 0 then exit;

  Parts:= TStringList.Create;
  try
//    Parts.Delimiter := '*';
//    Parts.DelimitedText :=  mask;
    buf:='';
    for k := 1 to l do
      if mask[k] in ['*', '?'] then
       begin
        if buf<>'' then Parts.Add(buf);
        Parts.Add(Mask[k]);
        buf:='';
       end
      else       
        buf := buf + mask[k];
      begin
      end;
    if buf <> '' then Parts.Add(buf);

    k:=1; l:= length(str);
    m:=0;
    repeat
    //for m := 0 to Parts.Count - 1 do
     begin
      if k>l then break;
     end;
      Case Parts[m][1] of
       '*':
       begin
        if m+1 = Parts.Count then break;
        inc(m);
        p:=pos(Parts[m],copy(str,k));
        if p = 0 then exit;
        k := p + length(Parts[m]);
       end;
       '?': k:=k+1;
       else if pos(Parts[m],str)<>k then  exit else inc(k, length(Parts[m]));

      End;
      inc(m);
    until m > Parts.Count-1;
    RESULT:= (Parts[Parts.Count-1]='*') OR ((k>l) AND (Parts.Count = m));
  finally
    Parts.Free;
  end;




end;

procedure TExportsManager.appendClient;
begin
try
  self.ClientsTbl.Append;

  
except on Err: Exception do
 begin
  MessageDlg(Err.Message,mtError,[mbCancel],0);
  self.ClientsTbl.CancelUpdates;
 end;
end;
end;

procedure TExportsManager.appendExport;
begin
try
  self.ExportsTbl.Append;

  self.ExportsTbl.FieldByName('Priority').Value:=NULL;                                       //Priority
  self.ExportsTbl.FieldByName('ID_Client').Value:=self.ClientsTbl.FieldByName('ID').asString; //ID_Client
  self.ExportsTbl.FieldByName('NAV_Client').Value := self.ClientsTbl.FieldByName('NAV_client').asString;

  self.ExportsTbl.FieldByName('ID_WH').Value := NULL;
    self.ExportsTbl.FieldByName('CY').Value := 'RUB';
      self.ExportsTbl.FieldByName('blocked').Value := false;
        self.ExportsTbl.FieldByName('Price').Value := self.user;

  self.ExportsTbl.FieldByName('INTERVAL').Value := 1440;
  self.ExportsTbl.FieldByName('LAST_EXPORT').Value := DatetimeToStr(Now());
  self.ExportsTbl.FieldByName('NEXT_EXPORT').Value := DatetimeToStr(Now()+1);            
  

 self.ExportsTbl.FieldByName('ID_TEMPL').Value := NULL;
 self.ExportsTbl.FieldByName('emailflag').Value := true;
 self.ExportsTbl.FieldByName('email').Value := ' '; 
 self.ExportsTbl.FieldByName('emailsubj').Value := NULL;
 self.ExportsTbl.FieldByName('emailbody').Value := NULL;
 self.ExportsTbl.FieldByName('emailzip').Value := NULL;
    
except on Err: Exception do
 begin
  MessageDlg(Err.Message,mtError,[mbCancel],0);
  self.ExportsTbl.CancelUpdates;
 end;
end;

end;

procedure TExportsManager.ConfigTableByDomain(Tbl: TADOTable;
  tablename: string);
begin
  Tbl.Connection.Connected:=False;
  Tbl.Connection.ConnectionString := generateConnStr(false,self.user,DD.server,DD.db);   //user
  Tbl.TableName := '['+DD.firm+'$'+tablename+']';
  Tbl.Connection.Connected:=True;
try
  Tbl.Connection.Execute('EXEC [sp_setapprole] ''$ndo$shadow'', ''FF5EC4E40F67BD4EDF3D04F8B84364DAD0'', ''none'', 0, 0');
except on E: Exception do
end;
end;

procedure TExportsManager.Connect;
begin
  self.Connection.Connected:=True;
end;

constructor TExportsManager.Create;
var userLen: Cardinal;
begin
  inherited;


  userLen:=255;
  setLength(user, userLen);
  getUserName(PAnsiChar(self.user),userLen);
end;

destructor TExportsManager.Destroy;
begin

  FreeAndNil(self.ClientsSrc);
  FreeAndNil(self.ClientsTbl);

  FreeAndNil(self.ExportsSrc);
  FreeAndNil(self.ExportsTbl);


  FreeAndNil(self.TemplatesSrc);
  FreeAndNil(self.TemplatesTbl);

  FreeAndNil(self.WarehousesSrc);
  FreeAndNil(self.WarehousesTbl);

  FreeAndNil(self.PriceListsSrc);
  FreeAndNil(self.PriceListsTbl);

  FreeAndNil(self.CurrenciesSrc);
  FreeAndNil(self.CurrenciesTbl);

  inherited;
end;

procedure TExportsManager.Disconnect;
begin
  self.Connection.Connected := False;
end;

function TExportsManager.generateConnStringByLogin: string;
var driver, server, UID, WSID, TrustConn, database, lang, user, PWD: string;
provider, security, initcatalog, datasource, UserID: string;

begin
   begin
    driver := 'DRIVER=SQL Server;';
    server := 'SERVER='+self.server+';';
    UID    := 'UID='+self.login+';';
    WSID   := '';//'WSID='+copy(user,1,UserNameLen-1)+';';
    PWD    := 'PWD='+self.password+';';

    TrustConn := '';//'Trusted_Connection=Yes;';
    database := 'DATABASE='+self.database+';';
    lang   :='LANGUAGE=русский;';
    RESULT:= driver + server + UID + WSID + PWD + TrustConn + database + lang;
   end;

//   begin
//    provider:='Provider=SQLOLEDB.1;';
//    security:='Integrated Security=SSPI;Persist Security Info=True;';
//    userID  :='User ID='+self.login+';';
//    datasource:='Data Source='+self.server+';';
//    InitCatalog := 'Initial Catalog='+self.database+';';
//    RESULT:=provider+security+UserID+initcatalog+datasource;
//   end
end;

function TExportsManager.generateFileName: string;
var city, CY, clientNAV, ext: string;
begin
  //city :=
  ext := '.csv';
  city := trim(self.WarehousesTbl.FieldByName('City').AsString);
//  if city = 'Минск' then city := 'Minsk' else
//   if city = 'Подольск' then city := 'Podolsk' else
//    if city = 'Екатеринбург' then city := 'Ekaterinburg' else city := '';

  city := copy('Minsk   Podolsk   Ekaterinburg',
     pos(city, 'Минск   Подольск  Екатеринбург'),length(trim(city))+2);
  city := trim(city);

  CY := trim(self.ExportsTbl.FieldByName('CY').AsString);
  clientNAV := trim(self.ClientsTbl.FieldByName('NAV_Client').AsString);


  RESULT := concat('export','_',city,'_',CY,'_',clientNAV, ext);
end;

function TExportsManager.generateMailSubject: string;
var city, CY: string;
begin
  city := trim(self.WarehousesTbl.FieldByName('City').AsString);
  city := 'Склад '+city+'. ';
  CY := trim(self.ExportsTbl.FieldByName('CY').AsString);
  if CY<>'' then CY := concat(' (',CY,') ');
  RESULT := 'Актуальное предложение Шате-М Плюс';
  RESULT := concat(city, RESULT, CY);
end;

procedure TExportsManager.Init;
var iniFile: TIniFile;
begin
  IniFile:=TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+FILEINI);
  try

    self.server:=IniFile.ReadString('MAINDATABASE','server',server);
    self.database := IniFile.ReadString('MAINDATABASE','database',database);

    self.login := self.y(IniFile.ReadString('SECURITY','Login',''));
    self.password :=self.y(IniFile.ReadString('SECURITY','Pass',''));

    self.defaultfolder:=IniFile.ReadString('SERVICE','Folder','C:\Services\UniversalExport');
    self.fileslocation:=IniFile.ReadString('SERVICE','Share','C:');
    //self.
  finally
    FreeAndNil(IniFile);
  end;
  //self.Connection:=TADOConnection.Create(nil);
  self.Connection.ConnectionString := self.generateConnStringByLogin; //generateConnStr(true);
  self.Connection.LoginPrompt:=False;

  //self.ClientsTbl:=TADOTable.Create(nil);
  self.ClientsTbl.TableName:='Clients';
  self.ClientsTbl.Connection:=self.Connection;
//  self.ClientsSrc:=TDataSource.Create(nil);
  self.ClientsSrc.DataSet:=self.ClientsTbl;

//  self.ExportsTbl:=TADOTable.Create(nil);
  self.ExportsTbl.TableName:='Exports';
  self.ExportsTbl.Connection:=self.Connection;
//  self.ExportsSrc:=TDataSource.Create(nil);
  self.ExportsSrc.DataSet:=self.ExportsTbl;


  self.ClientsTbl.CursorLocation:=clUseClient;
  self.ClientsTbl.CursorType:=ctStatic;
  self.ClientsTbl.LockType:=ltOptimistic;


  self.ExportsTbl.CursorLocation:=clUseClient;
  self.ExportsTbl.CursorType:=ctStatic;
  self.ExportsTbl.LockType:=ltOptimistic;


  self.TemplatesTbl:=TADOTable.Create(nil);
  self.TemplatesTbl.TableName:='Templates';
  self.TemplatesTbl.Filter := 'Display = 1';
  self.TemplatesTbl.Filtered := True;
  self.TemplatesTbl.Connection:=self.Connection;
  self.TemplatesSrc:=TDataSource.Create(nil);
  self.TemplatesSrc.DataSet:=self.TemplatesTbl;

  self.TemplatesTbl.ReadOnly:=True;


  self.DomainsTbl := TADOTable.Create(nil);
  self.DomainsTbl.TableName := 'Domains';
  self.DomainsTbl.Connection := self.Connection;
  self.DomainsSrc := TDataSource.Create(nil);
  self.DomainsSrc.DataSet := self.DomainsTbl;

  self.WarehousesTbl:=TADOTable.Create(nil);
  self.WarehousesTbl.TableName:='Warehouses';
  self.WarehousesTbl.Connection:=self.Connection;
  self.WarehousesSrc:=TDataSource.Create(nil);
  self.WarehousesSrc.DataSet:=self.WarehousesTbl;

  self.WarehousesTbl.ReadOnly:=True;


  self.PriceListsTbl:=TADOTable.Create(nil);
  self.PriceListsTbl.TableName:='PriceLists';
  self.PriceListsTbl.Connection:=self.Connection;
  self.PriceListsSrc:=TDataSource.Create(nil);
  self.PriceListsSrc.DataSet:=self.PriceListsTbl;

  self.PriceListsTbl.ReadOnly:=True;

//  self.TemplatesTbl.CursorLocation:=clUseClient;
//  self.TemplatesTbl.CursorType:=ctStatic;
//  self.TemplatesTbl.LockType:=ltOptimistic;

  self.PriceGroupsTbl := TADOTable.Create(nil);
  self.PriceGroupsTbl.TableName := 'PriceGroups';
  self.PriceGroupsTbl.Connection := self.Connection;
  self.PriceGroupsSrc := TDataSource.Create(nil);
  self.PriceGroupsSrc.DataSet := self.PriceGroupsTbl;


  self.CurrenciesTbl:=TADOTable.Create(nil);
  self.CurrenciesTbl.TableName:='Currencies';
  self.CurrenciesTbl.Connection:=self.Connection;
  self.CurrenciesSrc:=TDataSource.Create(nil);
  self.CurrenciesSrc.DataSet:=self.CurrenciesTbl;

  self.CurrenciesTbl.ReadOnly:=True;

  self.filterClients:=false;
  self.filterExports := false;
end;

procedure TExportsManager.OpenExportFile(FileName: string);
var
cl, l: integer;
SI : TStartupInfo;
PI : TProcessInformation;
  RS:NETRESOURCE;
  err: integer;
  TempPathName: string;
  TempFileName: string;
begin

try
    begin
    RS.lpLocalName:= ''; // W:
    RS.lpProvider := nil;
    RS.dwType := RESOURCETYPE_DISK;
    RS.lpRemoteName:= PAnsiChar(ExcludeTrailingPathDelimiter(self.fileslocation)); //'\\boss\base'; 'vps891vps'
  
    err := WNetAddConnection2(RS,PAnsichar(self.x(LowerCase(self.password))),PAnsichar('shate\'+self.x(self.login)),0);
    //ShowMessage(SysErrorMessage(err));
    end;

    FileName:=self.fileslocation + ExtractFileName(Trim(FileName));
  //  l := length(Filename);
  //  cl:=pos(':',FileName);
  //  if cl>0 then FileName := self.fileslocation + copy(FileName, cl+1, l - cl);

    if FileExists(FileName) then
     try
      GetStartupInfo(SI);
  //    CreateProcessWithLogonW(
  //    PWideChar(self.login),nil,pass,logonflaggs,notepad,
  //    )

      SetLength(TempPathName, MAX_PATH);
      l := GetTempPath(Length(TempPathName), PChar(TempPathName));
      SetLength(TempPathName, l);
      TempFileName := IncludeTrailingPathDelimiter(TempPathName)+ExtractFileName(FileName) ;
      CopyFile(PAnsiChar(FileName), PAnsiChar(TempFileName),true);
      WNetCancelConnection2('',0,True);
      CreateProcess(nil, PChar('notepad.exe '+TempFileName), //PChar('D:\setup.exe',
    nil, nil, FALSE, CREATE_NEW_CONSOLE, nil, nil, SI, PI);


     except
       on Err: Exception do
        ShowMessage(Err.Message);
     end;
except on E: Exception do
   ShowMessage(E.Message);
end;



end;

function TExportsManager.updateDomain: boolean;
begin
RESULT:=False;
try
    with self.DD do
    begin
      id := self.DomainsTbl.FieldByName('ID').AsInteger;
      name := trim(self.DomainsTbl.FieldByName('Name').AsString);
      server := trim(self.DomainsTbl.FieldByName('Server').AsString);
      db := trim(self.DomainsTbl.FieldByName('DB').AsString);
      firm := trim(self.DomainsTbl.FieldByName('Firm').AsString);
    end;
RESULT:=True;
except on Err: Exception do
  MessageDlg(Err.Message,mtError,[mbAbort],0);
end;

end;



function TExportsManager.x(y: string): string;
var k,l: integer;
begin
  l:=length(y);
  for k:= 1 to l do
   y[k]:=pred(y[k]);
  x:=y;
end;

function TExportsManager.y(x: string): string;
var k,l: integer;
begin
  l:=length(x);
  for k:= 1 to l do
   x[k]:=pred(x[k]);
  y:=x;
end;

//function TExportsManager.updateClientDomain(NAVSrc: TDataSource;
//  var DD: TDomainDescr): boolean;
//begin
//
//end;

end.
