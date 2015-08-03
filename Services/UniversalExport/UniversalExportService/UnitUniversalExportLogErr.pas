unit UnitUniversalExportLogErr;

interface
uses   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, ActiveX,  SyncObjs,
  _CSVReader, UnitConfig,inifiles, UnitSmtpThread;

  Type  TWarehouseDescr = Record
          id: integer;
          server: string[50];
          db: string[50];
          firm: string[50];
          filename: string[255];
        End;
        TINTARRAY = array of integer;
  // класс - демон универсального экспорта
        TExportDaemon = Class(TThread)
         public
          var Q0, QQ, QNAV: TADOQuery;
              serverName, DBName: string;
              Cmd: TADOCommand;
              ConnGeneral, ConnNAVs: TADOConnection;
              apparole: boolean;
              interval: integer;
              deleteQuants: boolean;
              filelog: string;
              hammer: boolean;
              loglevel : integer;
          procedure Run;
          procedure Execute; override;

          procedure LogTimeStamp(Msg: string);
          procedure LogAction(Msg: string);
          procedure LogResultReport(Success: boolean);
          procedure LogPrintStep(Msg: string);

         published
          //constructor Create(Plug1, Plug2: TADOConnection; Query1, Query2, Query3: TADOQuery); overload;
          constructor Create; overload;
          destructor  Destroy; override;
         private
          QuantsTableName: string;
          QuantsFieldsList: TStringList;
          QuantsFieldsTypeCodes: TINTARRAY;//array of integer;
          function Connect(connNo: integer; server, db: string): boolean;
          procedure Init;
          //procedure SetInsParameters(Q: TADOQuery; dbName, tblName: string);
          procedure CheckQuantsUpdate;
          procedure CheckExportsUpdate;
          function Disconnect(connNo: integer): boolean;
          procedure LogMessage(Msg: string; CR: boolean);
          procedure LogPrintln(Msg: string);
          procedure LogPrint(Msg: string);

          procedure ItemLinking(WH: TWarehouseDescr);
//методы перенесённые из внешних подпрограмм
          function selectWarehouses(var Q: TADOQuery): boolean;

          procedure LoadDiscountsForClient(client_id: integer; expwh_id: integer; ClientsQuery, WHQuery: TADOQuery);
          procedure processClientsDiscounts(QuExports: TADOQuery);

          procedure generatePrices(DataExports: TADOQuery);
        End;


        TNAVCSVReader = Class(TCSVReader)
        public
          function getTypedFields(index, typecode: integer): string;
          class function  Numeric(strval: string; frac: integer): string;
          function setPrefix(prefix: string): boolean;
          function setPostFix(postfix: string): boolean;
          procedure clearAppendix;
        private
          procedure ParseFields; override;
          var prefix, postfix: string;
        published
          constructor Create;
        End;
        
        NUMBSET = set of byte;
        

  var Daemon: TExportDaemon;
      sect: TCriticalSection;
  function generateConnStr(OLEDBProvider: boolean; serverName, dbName: string): string;
  function substitutionDBTblByTemplate(template, dbName, tblName: string): string;

  function selectWarehouse(datas: TADOQuery): boolean;
  function getWarehouseDsc(datas: TADOQuery): TWarehouseDescr;

  //function Numeric(strval: string): string;


  procedure SetInsParameters(Q: TADOQuery; dbName, tblName: string; Fields: TStringList);
  procedure SetInsValues(Q: TADOQuery; R: TNAVCSVReader; typecodes: TINTArray);

implementation
  function DataQueryExtrication(Q: TADOQuery; liberate: boolean): boolean;
  begin
    RESULT:=false;
    try
      if Q=nil then exit;
       Q.Close;  RESULT:=true;
    finally
       if liberate then Q.Free;
    end;
    ;
  end;

//выполняет запрос на выборку данных
//возвращает "TADOQuery открыт"
//в случае неудачи освобождает ресурсы запроса
  function DatasetByRequest(var Q: TADOQuery; Conn: TADOConnection; SQLrequest: string): boolean;
  begin
    RESULT:=false;
    Q:=TADOQuery.Create(nil);
    Q.Connection := Conn;
    Q.SQL.Text := SQLrequest;
    try
      //Q.ExecSQL;
      Q.Open;
      RESULT:=Q.RecordCount>0;
      if RESULT then exit;
      Q.Close;
    except
      FreeAndNil(Q);
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


  function substitutionDBTblByTemplate(template, dbName, tblName: string): string;
  begin
    template:=StringReplace(template,'##DATABASENAME##',dbName,[rfIgnoreCase]);
    template:=StringReplace(template,'##TABLENAME##',tblName,[rfIgnoreCase]);
    RESULT:=template;
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

  function getFieldsList(prefix: string; QuantsFieldsList: TStringList): string;
 // const      : array[0..3] of string = ('WH_ID','ID_Item', 'QNT', 'Price');
  var k, NF: integer;      //*****
  begin
    //NF:=4;
    NF:=QuantsFieldsList.Count;
    for k:=0 to NF-1 do
     RESULT:=RESULT+prefix+QuantsFieldsList[k]+', ';
    SetLength(RESULT, Length(RESULT)-2);
    //ShowMessage(RESULT);
  end;

  procedure SetInsParameters(Q: TADOQuery; dbName, tblName: string; fields: TStringList);
  const INSERTREQUEST = 'INSERT INTO [##DATABASENAME##].[dbo].[##TABLENAME##] (#Fields#) VALUES (#Parameters#)';
  var str, fldlist, parlist: string;
  begin
    Q.Prepared := False;
    str:= substitutionDBTblByTemplate(INSERTREQUEST,dbName, tblName);


    str:=StringReplace(str,'#Fields#',getFieldsList('',fields),[]);
    str:=StringReplace(str,'#Parameters#',getFieldsList(':',fields),[]);

    Q.SQL.Text := str;
    Q.Prepared := True;
  end;

  procedure SetInsValues(Q: TADOQuery; R: TNAVCSVReader; typecodes: TINTArray);
  var k: integer;
  begin
    if R.FieldsCount<>Q.Parameters.Count then exit;

    for k := 0 to R.FieldsCount - 1 do      //!!
     begin
      //ShowMessage(R.Fields[k]);
       Q.Parameters[k].Value:=R.getTypedFields(k,typecodes[k]);
     end;
    //if k>0 then Q.Parameters[0].Value := StrToInt('-'+R.Fields[0]);
    Q.ExecSQL;
  end;

//  function Numeric(strval: string): string;
//  const decsep = '.';
//  begin
//    strval:=stringReplace(strval,',',decsep,[rfReplaceAll]);
//    strval:=stringReplace(strval,#$A0,'',[rfReplaceAll]);
//    Numeric:=stringReplace(strval,#$0A,'',[rfReplaceAll]);
//  end;

  function selectWarehouse(datas: TADOQuery): boolean;
  const REQUESTWAREHOSES = 'SELECT * FROM [Warehouses]';
  begin
    RESULT:=false;
    datas.SQL.Text := REQUESTWAREHOSES;
    datas.Open;
    RESULT:=datas.RecordCount>0;
  end;

  function getWarehouseDsc(datas: TADOQuery): TWarehouseDescr;
  begin
   try
    RESULT.id :=datas.Fields[0].AsInteger;
    RESULT.server := trim(datas.Fields[3].AsString);
    RESULT.db := trim(datas.Fields[4].AsString);
    RESULT.firm := trim(datas.Fields[5].AsString);
    RESULT.filename := trim(datas.Fields[6].AsString);
   finally
     ;
   end;
  end;

  function SelectClientWarehouses(id_client: integer; QueryExports: TADOQuery): NUMBSET;
  const REQUESTWH = 'SELECT DISTINCT [ID_WH] FROM [Exports] WHERE [ID_Client] = ';
  begin
    RESULT:=[];
    QueryExports.SQL.Text := REQUESTWH + IntToStr(id_client);
    QueryExports.ExecSQL;
    QueryExports.Open;
    if QueryExports.RecordCount >0 then
     begin
      QueryExports.First;
      repeat
        if not(QueryExports.Fields[0].IsNull) then
          RESULT:=RESULT + [Byte(QueryExports.Fields[0].AsInteger)];
        QueryExports.Next;
      until QueryExports.Eof;
     end;
    QueryExports.Close;
  end;

  function NavClientCode(idClient: integer; QueryClients: TADOQuery; var whID: integer):string;
  const   REQUESTCLIENTNAV = 'SELECT [NAV_Client], [ID_WH] FROM [Clients] WHERE [ID] = ';
  begin
    RESULT:='';
    QueryClients.SQL.Text := REQUESTCLIENTNAV + IntToStr(idClient);
    QueryClients.ExecSQL;
    QueryClients.Open;
    if QueryClients.RecordCount<1  then exit;

    if QueryClients.Fields[0].IsNull  then exit;
    RESULT:=trim(QueryClients.Fields[0].AsString);

    if QueryClients.Fields[1].IsNull  then exit;
    whID:=QueryClients.Fields[1].AsInteger;

    QueryClients.Close;
  end;

  function wahrehouseByID(id_wh: integer; whQuery: TADOQuery): TWarehouseDescr;
  begin
    whQuery.SQL.Text:= 'SELECT * FROM [WAREHOUSES] WHERE [ID] = '+IntToStr(id_wh);
    //whQuery.ExecSQL;
    whQuery.Open;
    if whQuery.RecordCount=0  then exit;
    whQuery.First;  
    RESULT := getWarehouseDsc(whQuery);
    whQuery.Close;
  end; 





//перегрузить скидки для клиента из таблицы 21074593 в DISCOUNTS
  procedure LoadDiscountsForClientID(client_id: integer; expwh_id: integer; WH: TWarehouseDescr; DiscountsQuery: TADOQuery);
  const SQLCLIENTDISCOUNTSFILENAME = 'SQLSELECT_client_discounts.qry';//'SQLSELECTMAXdiscount.qry';//'SQLdiscountsbyClientNav.qry';
        SQLCLIENTDISCOUNTS = 'SQLSELECT_client_discounts';
        SQLINSERTDISCOUNTSFILENAME = 'SQLInsertDiscountsValues.qry';
        SQLINSERTDISCOUNTS = 'SQLInsertDiscountsValues';
        CODESKIND : array[0..1] of string = ('ТМ','ТОВЛИНИЯ');
        TM = 0;
        TL = 1;
  var sqlreqdisc, sqlreqins, clientNAV:  string;
      i, j, h, hh: integer;
      NewNAVConn: TADOConnection;
      NewNAVQuery, QuantsQuery: TADOQuery;
      //groupcode :  string;  //  array[0..1] of
     //RecordsAffected: Integer; Parameters: OleVariant;
  begin

  try

//      NAVConn.Execute(loadStrFromFile('SQLMAGICWORD.QRY'));// )
//      NAVConn.Connected := True;

  //**** главный склад клиента
      clientNAV := NavClientCode(client_id, DiscountsQuery, h); //заполнение clientNAV и h=№осн склада

      //выбор основного склада клиента и его настроек
      DiscountsQuery.SQL.Text:= 'SELECT * FROM [WAREHOUSES] WHERE [ID] = '+IntToStr(h);
      DiscountsQuery.ExecSQL;
      DiscountsQuery.Open;
      wh := getWarehouseDsc(DiscountsQuery);
      DiscountsQuery.Close;


  //***
  //соединение с NAV
      NewNAVConn:=TADOConnection.Create(nil);
      NewNAVConn.ConnectionString := generateConnStr(false, wh.server, wh.db);
      NewNAVConn.LoginPrompt :=False;
      NewNAVConn.Connected := True;
      if Daemon.apparole  then NewNAVConn.Execute(loadTextDataByTag('SQLMAGICWORD'){loadStrFromFile('SQLMAGICWORD.QRY')},cmdText,[eoExecuteNoRecords]);
      Daemon.apparole:=false;



      sqlreqdisc:=loadTextDataByTag(SQLCLIENTDISCOUNTS);  //loadStrFromFile(SQLCLIENTDISCOUNTSFILENAME);
      sqlreqdisc:=StringReplace(sqlreqdisc,'##IDCLIENT##',IntToStr(client_id),[rfReplaceAll]);
      sqlreqdisc:=StringReplace(sqlreqdisc,'##DATABASE##', WH.db, [rfReplaceAll]);
      sqlreqdisc:=StringReplace(sqlreqdisc,'##FIRM##', WH.firm, [rfReplaceAll]);
      sqlreqdisc:=StringReplace(sqlreqdisc,'##CLIENTNAV##',clientNAV,[rfReplaceAll]);

      NewNAVQuery:=TADOQuery.Create(nil);

        newNAVQuery.Connection := NewNAVConn;


      //запрос остатков для склада указанного в экспорте
//закомментировано в связи с исключением поиска максимальной скидки на этом этапе
//      QuantsQuery:= TADOQuery.Create(nil);
//      QuantsQuery.Connection:=DiscountsQuery.Connection;
//      QuantsQuery.SQL.Text:= 'SELECT DISTINCT [Brand],[Line] FROM [QUANTS] WHERE [ID_WH] = '+IntToStr(expwh_id);
//      QuantsQuery.ExecSQL;
//      QuantsQuery.Open;
//
//
//      QuantsQuery.First;     //цикл по всем сочетаниям бренд-линейка
//      repeat
//        for i := TM to TL do          //i=0, 1
//         try
//              NewNAVQuery.SQL.Text :=
//                StringReplace(
//                 StringReplace(
//                  StringReplace(sqlreqdisc,'##CODENO##',IntToStr(i),[rfIgnoreCase])
//                  ,'##CODEKIND##',CODESKIND[i],[rfIgnoreCase])
//                  ,'##GROUPCODE##',QuantsQuery.Fields[i].AsString,[rfReplaceAll]);
//              NewNAVQuery.ExecSQL;
//
//              NewNAVQuery.Open;
//              if NewNAVQuery.RecordCount=0   then Continue;
//
//
//              sqlreqins:=loadstrFromFile(SQLINSERTDISCOUNTSFILENAME);
//              DiscountsQuery.SQL.Text := sqlreqins;
//              DiscountsQuery.Prepared :=True;
//
//              NewNAVQuery.First; //в верхней строке нужное значение скидки
//              repeat
//                for j:=0 to DiscountsQuery.Parameters.Count-1 do  // NewNAVQuery.FieldCount
//                  DiscountsQuery.Parameters[j].Value := NewNavQuery.Fields[j].Value;
//                DiscountsQuery.ExecSQL;
//                NewNavQuery.Next;
//              until NewNavQuery.Eof;
//
//        finally
//              newNAVQuery.Close;
//              DiscountsQuery.Prepared := False;
//        end;
//
//
//        QuantsQuery.Next;
//      until QuantsQuery.Eof;

//****альтернатива

      NewNAVQuery.SQL.Text :=  sqlreqdisc;
      ShowMessage(sqlreqdisc);
      NewNAVQuery.ExecSQL;
      NewNavQuery.Open;
//        StringReplace(
//         StringReplace(
//          StringReplace(sqlreqdisc,'##CODENO##',IntToStr(i),[rfIgnoreCase])
//          ,'##CODEKIND##',CODESKIND[i],[rfIgnoreCase])
//          ,'##GROUPCODE##',QuantsQuery.Fields[i].AsString,[rfReplaceAll]);

      sqlreqins:=loadTextDataByTag(SQLINSERTDISCOUNTS);  //   loadstrFromFile(SQLINSERTDISCOUNTSFILENAME)
      DiscountsQuery.SQL.Text := sqlreqins;
      DiscountsQuery.Prepared :=True;

      NewNAVQuery.First; //цикл  по записям полученным для клиента
      repeat
        for j:=0 to DiscountsQuery.Parameters.Count-1 do  // NewNAVQuery.FieldCount
          DiscountsQuery.Parameters[j].Value := NewNavQuery.Fields[j].Value;
        DiscountsQuery.ExecSQL;
        NewNavQuery.Next;
      until NewNavQuery.Eof;
      NewNAVQuery.ExecSQL;

//****конец  альтернативы




      DiscountsQuery.Close;
finally
    //ShowMessage(NewNAVConn.ConnectionString);
    FreeAndNil(QuantsQuery);
    NewNAVConn.Connected := False;
    FreeAndNil(NewNavQuery);
    FreeAndNil(NewNavConn);
end;


  end;

 // procedure processClientsDiscounts(id_Client: integer; QueryWarehouses, QueryDiscounts, QueryNAV: TADOQuery; Magic: TADOCommand; Conn: TADOConnection);

 procedure processClientsDiscounts(QuExports, QuQu, QuNAV: TADOQuery; PlugNAV: TADOConnection);
  const DELCLIENTDISC = 'DELETE FROM [DISCOUNTS] WHERE [ID_CLIENT]=';
        MAGICWORD = '';
        INXFLDCLIENT = 0;
        INXFLDWHID = 1;
  var
      h: byte;
      whset: NUMBSET;
      wh: TWarehouseDescr;
      WHQ: TADOQuery;
      id_Client, id_expwarehouse: integer;

  begin
    // очищаем в MainQuery Discounts данные по клиенту...
    //...
    //MainQuery должно быть подключено
    {DeleteFromDiscountsByID}


//**********исключено поскольку не перебираем склады
//    whset := SelectClientWarehouses(id_Client, QueryWareHouses);
//    if not((whset<>[]) and (selectWarehouse(QueryWareHouses))) then exit;
//
//    QueryWareHouses.First;
//    for h := 0 to QueryWareHouses.RecordCount - 1 do
//     begin
//      wh:=getWarehouseDsc(QueryWareHouses);
//      if Byte(QueryWareHouses.Fields[0].AsInteger) in whset then
//        LoadDiscountsForClientID(id_Client, wh, QueryDiscounts, QueryNAV);
//      QueryWareHouses.Next;
//     end;
//    QueryWarehouses.Close;
//**********все лишь для одного склада

  //wh:=getWarehouseDsc(QueryWareHouses);

  if QuExports.RecordCount <1 then exit;

  QuQu.SQL.Text :='DELETE FROM [DISCOUNTS]';
  QuQu.ExecSQL;

  QuExports.First;
  repeat
    if QuExports.Fields[INXFLDCLIENT].IsNull  then begin QuExports.Next; continue; end;     //0   Fields[1].IsNull

    id_Client:=QuExports.Fields[INXFLDCLIENT].AsInteger;
    id_expwarehouse := QuExports.Fields[INXFLDWHID].AsInteger;
    LoadDiscountsForClientID(id_Client, id_expwarehouse, wh, QuQu);;
    QuExports.Next;
  until QuExports.Eof;
    ;
  end;

  function fieldslistByTemplate(TemplID: integer; tmplQuery: TADOQuery): string;
  const TEMPLREQUEST = 'SELECT [SQL] FROM [TEMPLATES] WHERE [ID] =';
  begin
    tmplQuery.SQL.Text := TEMPLREQUEST + IntToStr(TemplID);
    RESULT:='';
    tmplQuery.ExecSQL;
    tmplQuery.Open;
    if tmplQuery.RecordCount > 0 then
     begin
       tmplQuery.First;
       RESULT:=trim(tmplQuery.Fields[0].AsString);
       //if pos(',',RESULT)>0 then RESULT:='('+RESULT+')';
     end;
     //вывести(*) ?
     tmplQuery.Close;
  end;

  function quantsRequestbyWareHouse(whID: integer): string;
  const PRICEREQUEST ='SQLPriceRequest'; //.qry'SELECT * FROM [QUANTS] WHERE [QUANTS].[ID_WH] =';
  begin
    RESULT:= loadTextDataByTag(PRICEREQUEST){LoadStrFromFile()}+ IntToStr(whID);
  end;

  procedure SaveToCSV(dataset: TADOQuery; csvfilename: string);
  var i, j, M, N : integer;
    line: string;
    csv: text;
  begin
    N:=dataset.RecordCount;
    if N=0 then exit;
    M:=dataset.Fields.Count;
    dataset.First;
    Assign(csv,csvfilename);
    //ShowMessage(csvfilename);
    try
      Rewrite(csv);
      for i := 0 to N - 1 do
       begin
         line:='';
         if dataset.Eof then exit;
         for j := 0 to M - 1 do
          line:=line+trim(dataset.Fields[j].AsString)+';';
         SetLength(line, length(line)-1);
         writeln(csv,line);
         dataset.Next;
       end;
    finally
      CloseFile(csv);
    end;
  end;

  procedure generatePrice(DataExports, DataTemp: TADOQuery);
  const INDWH = 2;       //индекс поля номера склада
        INDCLIENT = 1;    //индекс поля номера клиента
        INDTEMPL = 8;    //индекс поля шаблона
        INDFLNAME = 7;   //индекс поля имени файла экспорта
  var fldlist, pricereq: string;
    cli: integer;
    i,
    h,
    tplNo: integer;
    pricefile: string;
  begin
    DataExports.Open;
    DataExports.First;
    repeat
      pricefile :=  DataExports.Fields[INDFLNAME].AsString;
      h    := DataExports.Fields[INDWH].AsInteger;
      tplNo:= DataExports.Fields[INDTEMPL].AsInteger;
      fldlist:=fieldslistByTemplate(tplNo,DataTemp);

      pricereq:=quantsRequestbyWareHouse(h);

      cli:=DataExports.Fields[INDCLIENT].AsInteger;
      pricereq:=StringReplace(pricereq,'##CLIENT_ID##',IntToStr(Cli),[rfReplaceAll]);
      ShowMessage(StringReplace(pricereq,'*',fldlist,[]));
      DataTemp.SQL.Text:=StringReplace(pricereq,'*',fldlist,[]);
      try
        //DataTemp.ExecSQL;
        DataTemp.Open;
        SaveToCSV(DataTemp,pricefile);
      finally
        DataTemp.Close;
      end;
      DataExports.Next;
    until DataExports.Eof;


  end;


{ TExportDaemon }

function TExportDaemon.Connect(connNo: integer; server, db: string): boolean;
const TMPLTCONNSTR = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=True;User ID=shingarev;Initial Catalog=;Data Source=AMD;';
var Connection: TADOConnection;
    status: string;                                                                                                                         // ETK
begin
  RESULT:=false;
  case connNo of
    1: Connection:=self.ConnGeneral;
    2: Connection:=self.ConnNAVs;
    else exit;
  end;
  try
    Connection.LoginPrompt := False;
    //self.Connection.ConnectionString:=stringReplace(TMPLTCONNSTR,'Initial Catalog=;','Initial Catalog='+dbName+';',[]);
    Connection.ConnectionString := generateConnStr(connNo=1, server, db);
    self.LogAction('Соединение с... '+Connection.ConnectionString);
    Connection.Connected :=True;
    //Connection.CommandTimeout
    //if Connection.Connected then status:='..успешно' else status:='..неудачно';
    //self.LogMessage(status, true);
    self.LogResultReport(Connection.Connected);
  finally
    RESULT:=Connection.Connected;
  end;
  ;
end;



constructor TExportDaemon.Create;
var ferr: text;
begin
try
    inherited Create(True); //создаём остановленный поток
    CoInitializeEx(nil, COINIT_MULTITHREADED);
    self.QuantsTableName := 'Quants';//'UNIEXPORT_Quants';

    self.QuantsFieldsList := TStringList.Create;
    self.ConnGeneral := TADOConnection.Create(nil);
    self.Q0 := TADOQuery.Create(nil);
    self.Q0.Connection := self.ConnGeneral;
    self.Q0.CommandTimeout := 0;
    //считываем конфигурацию запуска...
    self.Init;
    self.hammer:=false;
    self.loglevel := 0;
    self.LogTimeStamp('Служба запущена');
except
    on Err: exception do
     begin
      AssignFile(ferr,'C:\Services\UniiversalExport\FatalErrors.log');

      try
        Append(ferr);
        writeln(ferr, '!ошибка инициализации: ' +Err.Message);
      finally
        CloseFile(ferr);
      end;
     end;
end;
end;

//constructor QuantsDaemon.Create(Plug1, Plug2: TADOConnection; Query1, Query2, Query3: TADOQuery);
//begin
//  inherited Create;
//  self.Q0 := Query1;
//  self.QNAV := Query2;
//  self.QQ:= Query3;
//
//  //self.Cmd:=TADOCommand.Create(nil);
//  self.ConnGeneral := Plug1;
//  self.ConnNAVs := Plug2;
//
//  self.QuantsTableName := 'Quants';//'UNIEXPORT_Quants';
//  //считываем сист. конфигурацию...
//  self.QuantsFieldsList := TStringList.Create;
//  self.setSysParameters;
//end;



destructor TExportDaemon.Destroy;
begin
  //разрушить созданные объекты....
  try
    self.QuantsFieldsList.Free;
    self.Q0.Free;
    self.ConnGeneral.Free;
  finally
  CoUninitialize;
  self.LogTimeStamp(' Служба остановлена');
  inherited;
  end;
end;

function TExportDaemon.Disconnect(connNo: integer): boolean;
var Connection: TADOConnection;
begin
  RESULT:=false;
  case connNo of
   1:   Connection:=self.ConnGeneral ;
   2:   Connection:=self.ConnNAVs ;
   else exit;
  end;
  Connection.Connected := false;
  self.LogTimeStamp('Разорвано соединение '+Connection.ConnectionString);
  self.LogPrintln('');
  RESULT:=not(Connection.Connected);
end;


procedure TExportDaemon.Execute;
begin
  inherited;
  repeat
    if self.hammer  then
     begin
      if self.Terminated then exit;
      
      self.Run;
      Sect.Enter;
      try
        if (self.hammer)then self.hammer:=false else exit;
      finally
        Sect.Leave;
      end;
     end
     else  exit;
    self.Suspend;
    //if self.Terminated then exit;
  until (self.Terminated);
end;

procedure TExportDaemon.generatePrices(DataExports: TADOQuery);
  const INDWH = 2;       //индекс поля номера склада
        INDCLIENT = 1;    //индекс поля номера клиента
        INDTEMPL = 8;    //индекс поля шаблона
        INDFLNAME = 7;   //индекс поля имени файла экспорта
        INDEMAILBIT = 9; //
        INDEMAIL = 10;  //индекс адреса отправки
        INDPRICETAG =3;
        INDCLCODE = 4;
  var fldlist, pricereq: string;
    cli: integer;
    i,
    h,
    tplNo: integer;
    sendflag: boolean;
    email: string;
    msgbody: string;

    pricefile: string;
    DataTemp: TADOQuery;
    sccPrc: boolean;

  begin
    self.LogAction('Формирование файлов прайсов');   sccPrc:=false;
    DataTemp:=TADOQuery.Create(nil);
    try
      DataTemp.Connection := self.ConnGeneral;

      DataExports.Open; //?

      DataExports.First;
      repeat   //цикл по записям экспорта
        pricefile :=  DataExports.Fields[INDFLNAME].AsString;
        h    := DataExports.Fields[INDWH].AsInteger;
        tplNo:= DataExports.Fields[INDTEMPL].AsInteger;
        fldlist:=fieldslistByTemplate(tplNo,DataTemp);

        pricereq:=quantsRequestbyWareHouse(h);
        //если флаг отправки NULL то письмо уходит по адресу
        //указанному в экспорте, если адрес адекватный (для тестирования)
        if DataExports.Fields[INDEMAILBIT].IsNull  then
          sendflag:= not(DataExports.Fields[INDEMAIL].IsNull)
        else sendflag:=DataExports.Fields[INDEMAILBIT].AsBoolean;

        email:=trim(DataExports.Fields[INDEMAIL].AsString);
        sendflag := sendflag AND (email<>'');
        if DataExports.Fields[INDPRICETAG].IsNull  then
         if DataExports.Fields[INDCLCODE].IsNull  then
          msgbody:= EMAILSUBJECT +''
         else msgbody:= EMAILSUBJECT +#$D#$A+trim(DataExports.Fields[INDCLCODE].AsString)
        else  msgbody:=trim(DataExports.Fields[INDPRICETAG].AsString);


        cli:=DataExports.Fields[INDCLIENT].AsInteger;
        pricereq:=StringReplace(pricereq,'##CLIENT_ID##',IntToStr(Cli),[rfReplaceAll]);
        //ShowMessage(StringReplace(pricereq,'*',fldlist,[]));
        DataTemp.SQL.Text:=StringReplace(pricereq,'*',fldlist,[]);
        self.LogPrintln(Datatemp.SQL.Text);
        try
          //DataTemp.ExecSQL;
          DataTemp.Open;
          SaveToCSV(DataTemp,pricefile);
          if sendflag then AddEmail2Queue(msgbody, email, pricefile, SMTPQueue);  //  'кракозябры'
        finally
          DataTemp.Close;
        end;
        DataExports.Next;
      until DataExports.Eof;
      self.LogPrintStep('Файлы получены');
      sccPrc:=true;
    finally
      self.LogResultReport(sccPrc);
      FreeAndNil(DataTemp);
    end;


  end;

procedure TExportDaemon.LoadDiscountsForClient(client_id, expwh_id: integer;
   ClientsQuery, WHQuery: TADOQuery);
const SQLCLIENTDISCOUNTS = 'SQLSELECT_client_discounts';
      SQLINSERTDISCOUNTS = 'SQLInsertDiscountsValues';
//        CODESKIND : array[0..1] of string = ('ТМ','ТОВЛИНИЯ');
//        TM = 0;
//        TL = 1;
var clientNAV: string;
    h, j: integer;
    WH: TWarehouseDescr;
    SQLreqDISC, SQLreqINS: string;
    DiscountsQuery: TADOQuery;
    sccCl: boolean;
begin
  self.LogPrintStep('Получение данных по клиенту '+ IntToStr(client_id));
  clientNAV := NavClientCode(client_id, ClientsQuery , h); //заполнение clientNAV и h=№осн склада
  WH:= wahrehouseByID(h,WHQuery);

  //!! отследить случай когда WH не заполнен
  try
      self.ConnNAVs := TADOConnection.Create(nil);
//      self.ConnNAVs.ConnectionString := generateConnStr(wh.server, wh.db);
//      self.ConnNAVs.LoginPrompt :=False;
//      self.ConnNAVs.Connected := True;
      self.Connect(2,wh.server, wh.db);
      try
        if self.apparole  then
          ConnNAVs.Execute(loadTextDataByTag('SQLMAGICWORD'){loadStrFromFile('SQLMAGICWORD.QRY')},cmdText,[eoExecuteNoRecords]);
      except
        self.apparole:=false;
      end;

      sqlreqdisc:=loadTextDataByTag(SQLCLIENTDISCOUNTS);  //loadStrFromFile(SQLCLIENTDISCOUNTSFILENAME);
      sqlreqdisc:=StringReplace(sqlreqdisc,'##IDCLIENT##',IntToStr(client_id),[rfReplaceAll]);
      sqlreqdisc:=StringReplace(sqlreqdisc,'##DATABASE##', WH.db, [rfReplaceAll]);
      sqlreqdisc:=StringReplace(sqlreqdisc,'##FIRM##', WH.firm, [rfReplaceAll]);
      sqlreqdisc:=StringReplace(sqlreqdisc,'##CLIENTNAV##',clientNAV,[rfReplaceAll]);

      self.QNAV :=TADOQuery.Create(nil);
      self.QNAV.Connection := self.ConnNAVs;
      self.QNAV.SQL.Text :=  sqlreqdisc;

      self.LogAction('Запрос скидок для клиента '+ clientNAV); sccCl:=false;
      //self.QNAV.ExecSQL;
      try
        self.QNAV.Open;
      except
        if self.apparole then  exit
        else  ConnNAVs.Execute(loadTextDataByTag('SQLMAGICWORD'));

        self.QNAV.Open;
      end;


      if self.QNAV.RecordCount = 0  then exit;

      sqlreqins:=loadTextDataByTag(SQLINSERTDISCOUNTS);

      DiscountsQuery:= TADOQuery.Create(nil);
      DiscountsQuery.Connection := self.ConnGeneral;
      //DiscountsQuery.SQL.Text := 'INSERT INTO [DISCOUNTS]([ID_CLIENT],[ID_TYPE],[ItemsGroupCode], VAL, [Force]) VALUES (1,0,0,0,0)';
      //DiscountsQuery.ExecSQL;

      //ShowMessage(IntToStr(DiscountsQuery.Parameters.Count) );
//      for j:=0 to DiscountsQuery.Parameters.Count-1 do
//          DiscountsQuery.Parameters[j].Value := NULL;

      DiscountsQuery.SQL.Text := sqlreqins;

//      DiscountsQuery.SQL.Text := 'INSERT INTO [DISCOUNTS]([ID_CLIENT],[ID_TYPE],[ItemsGroupCode], VAL, [Force]) VALUES (:p0,:p1,:p2,:p3,:p4)';
//      DiscountsQuery.Prepared :=True;
      try
      //перестраховаться на случай отсутствия данных по скидкам клиента
      //:ID_CLIENT, :ID_TYPE,:ItemsGroupCode, :VAL, :Force


        DiscountsQuery.Parameters[0].Value :=  client_id;
          DiscountsQuery.Parameters[1].Value := 0;
              DiscountsQuery.Parameters[2].Value := 0;
                    DiscountsQuery.Parameters[3].Value := 0;
                          DiscountsQuery.Parameters[4].Value := 0;
        DiscountsQuery.ExecSQL;
//


      except on E: Exception do
        LogMessage(DiscountsQuery.SQL.text+'***'+e.Message+' -- Не удалось создать нулевую скидку для клиента :'
                        +ClientNAV,true)
        //DiscountsQuery.Parameters.Clear;
      end;
      DiscountsQuery.Prepared :=False;
//      DiscountsQuery.Parameters.Clear;
//      DiscountsQuery.ParamCheck:=False;

//      showMessage(DiscountsQuery.SQL.Text);
//     DiscountsQuery.Parameters.ParseSQL(sqlreqins,true);
      //DiscountsQuery.SQL.Strings[0]:=StringReplace(DiscountsQuery.SQL.Strings[0],'[DISCOUNTS]','[UEXPORT].[dbo].[DISCOUNTS]',[rfIgnoreCase]);
      DiscountsQuery.Prepared :=True;

      self.QNAV.First; //цикл  по записям полученным для клиента
      repeat
//      for j:=0 to DiscountsQuery.Parameters.Count-1 do
//       SQLreqINS:=StringReplace(SQLreqINS,':'+DiscountsQuery.Parameters[j].Name,self.QNAV.Fields[j].AsString,[]);
//        PrintLogMessage(SQLreqIns,true);
//      PrintLogMessage('',true);

//        for j:=0 to DiscountsQuery.Parameters.Count-1 do
//          ShowMessage(DiscountsQuery.Parameters[j].Name+' <-- '+self.QNAV.Fields[j].Name+'='+ self.QNAV.Fields[j].AsString);
//        showMessage(DiscountsQuery.SQL.Text);

        for j:=0 to DiscountsQuery.Parameters.Count-1 do
          DiscountsQuery.Parameters[j].Value := self.QNAV.Fields[j].Value;
//         if pos('Date',DiscountsQuery.Parameters[j].Name)>0 then
//          DiscountsQuery.Parameters[j].Value := self.QNAV.Fields[j].AsDateTime
//         else
          
//        showMessage(DiscountsQuery.Parameters[j].Name);
//        DiscountsQuery.Parameters[10].Value := self.QNAV.Fields[10].AsDateTime;
//        DiscountsQuery.Parameters[12].Value := self.QNAV.Fields[12].AsDateTime;
//        DiscountsQuery.Parameters[19].Value := self.QNAV.Fields[19].AsDateTime;

        DiscountsQuery.ExecSQL; //ShowMessage(IntToStr());        
        self.QNAV.Next;
      until self.QNAV.Eof;
      sccCl:=true;
  finally
      self.LogResultReport(sccCl);
      FreeAndNil(DiscountsQuery);
      //self.ConnNAVs.Connected := False;
      self.Disconnect(2); 
      FreeAndNil(self.QNAV);
      FreeAndNil(self.ConnNAVs);
  end;

end;

procedure TExportDaemon.LogAction(Msg: string);
begin

  inc(self.loglevel);
  self.LogPrintln(IntToStr(self.Handle)+':');
  Msg:=StringOfChar(#9,self.loglevel)+Msg;
  self.LogTimeStamp(' '); self.LogPrintln(Msg);
end;

procedure TExportDaemon.LogMessage(Msg: string; CR: boolean);
var log: text;
    indent: string;
    k: integer;
begin
  Assign(log,'C:\Services\UniiversalExport\FatalErrors.log');
  try
    Append(log);
    writeln(log, msg);
  finally
    CloseFile(log);
  end;
  if self.filelog='' then exit;
  Assign(log,self.filelog);
  if FileExists(self.filelog)  then  Append(log) else Rewrite(log);

//  for k := 0 to self.loglevel - 1 do
//    indent:= indent+#9;

//  begin

//    try
//
//    except
//      exit;
//    end;
    try
//      Msg:=StringOfChar(#9,self.loglevel)+Msg;
      if (CR) then Writeln(log, Msg)
      else Write(log, Msg);
    finally
      CloseFile(log);
    end;
//  end;
end;

procedure TExportDaemon.LogPrint(Msg: string);
begin
  self.LogMessage(Msg, false);
end;

procedure TExportDaemon.LogPrintln(Msg: string);
begin
  self.LogMessage(Msg, true);
end;

procedure TExportDaemon.LogPrintStep(Msg: string);
begin
  self.LogPrintln(#9#9#9+StringOfChar(#9,self.loglevel)+Msg);
end;

procedure TExportDaemon.LogResultReport(Success: boolean);
const SUCCMSG = '...успешно';
      FAILMSG = '...неудачно';
var msg: string;
begin
  msg:=StringOfChar(#9,self.loglevel);
  if Success then msg:=msg+SUCCMSG else msg:=msg+FAILMSG;
  self.LogTimeStamp(''); self.LogPrintln(Msg);
  dec(self.loglevel);
end;

procedure TExportDaemon.LogTimeStamp(Msg: string);
begin
  if Msg<>'' then Msg:=#9+' '+Msg;
  self.LogPrint(DateTimeToStr(Now())+Msg);
end;

procedure TExportDaemon.processClientsDiscounts(QuExports: TADOQuery);
const
        INXFLDCLIENT = 0;
        INXFLDWHID = 1;
var QuQu, QqClients, QqWH: TADOQuery;
      //h: byte;
      //whset: NUMBSET;
      wh: TWarehouseDescr;
      //WHQ: TADOQuery;
      id_Client, id_expwarehouse: integer;
      sccDisc: boolean;
begin
    self.LogAction('Выполняем обновление скидок по клиентам '); sccDisc:=false;
  //if QuExports.RecordCount <1 then exit; не надо
    QuQu:=TADOQuery.Create(nil);
    QuQu.Connection := self.ConnGeneral;


    try

        QuQu.SQL.Text :='DELETE FROM [DISCOUNTS]';
        QuQu.ExecSQL;

        QqClients:=TADOQuery.Create(nil);
        QqClients.Connection := self.ConnGeneral;

        QqWH:=TADOQuery.Create(nil);
        QqWH.Connection := self.ConnGeneral;


        QuExports.First;
        repeat
          if QuExports.Fields[INXFLDCLIENT].IsNull  then begin QuExports.Next; continue; end;     //0   Fields[1].IsNull

          id_Client:=QuExports.Fields[INXFLDCLIENT].AsInteger;
          id_expwarehouse := QuExports.Fields[INXFLDWHID].AsInteger;
          self.LoadDiscountsForClient(id_Client,id_expwarehouse,QqClients, QqWH);  //LoadDiscountsForClientID(id_Client, id_expwarehouse, wh, QuQu);;
          QuExports.Next;
        until QuExports.Eof;
        sccDisc:=true;
    finally
        self.LogResultReport(sccDisc);
        FreeAndNil(QuQu);
        FreeAndNil(QqClients);
        FreeAndNil(QqWH);
    end;
end;

function requestByTag(sqltag: string; DataS: TADOQuery): boolean;
var request: string;  isSELECT: boolean;
begin
  RESULT:=false;
  request:=loadTextDataByTag(sqltag);
  if request = '' then exit;
  isSELECT:= pos('SELECT', UpperCASE(trim(request)))=1;
  DataS.SQL.Text := request;
  try
    DataS.CommandTimeout := 0;
    if isSELECT then
     begin
      DataS.Open;
      if DataS.RecordCount>0 then RESULT:=true else DataS.Close;
     end
    else RESULT:=(DataS.ExecSQL>0);
    //DataS.ExecSQL;
    //DataS.Open;
    //RESULT:=true; //(DataS.RecordCount >0);
  except
   on E: Exception do
    Raise E;
    //if not(RESULT) then DataS.Close;
  end;
end;

function requestFromFile(sqlfilename: string; DataS: TADOQuery): boolean;
var request: string;
begin
  RESULT:=false;
  request:=loadStrFromFile(sqlfilename);
  if request = '' then exit;
  DataS.SQL.Text := request;
  try

    DataS.ExecSQL;
    //DataS.Open;
    RESULT:=true; //(DataS.RecordCount >0);
  finally
    ;
  end;
end;

procedure TExportDaemon.CheckExportsUpdate;
const
      SQLUPDATEEMAILS = 'EmailsUpDate';
      SQLMARK0FILENAME = 'SQLQueryMarkZero.qry';
      SQLMARK0 =  'SQLQueryMarkZero';
      SQLMARKTFILENAME = 'SQLQueryMarkTime.qry';
      SQLMARKT =  'SQLQueryMarkTime';
      SQLSELECTFILENAME = 'SQLSELECTEXPORTCLIENTS.qry';
      SQLSELECTEXPCL = 'SQLSELECTEXPORTCLIENTS';
      SQLSELECT0FILENAME='SQLQuerySelectByZero.qry';
      SQLSELECT0 = 'SQLQuerySelectByZero';
var sccExp: boolean;
begin
    self.Connect(1,self.serverName,self.dbName);
    try
try
        self.Q0 := TADOQuery.Create(nil);
        self.Q0.Connection := self.ConnGeneral;
        self.Q0.CommandTimeout := 0 ;
  //      if requestFromFile(SQLMARK0FILENAME, self.Q0) then
  //       requestFromFile(SQLSELECTFILENAME, self.Q0)
  //      else exit;
        self.Q0.Connection.Execute(loadTextDatabytag(SQLUPDATEEMAILS));
        self.LogAction('Проверка наличия экспортов'); sccExp:=false;
        if requestByTag(SQLMARK0, self.Q0)    then //если помечены страждущие экспорты
         begin if not(requestByTag(SQLSELECTEXPCL, self.Q0)) then exit end // получаем список..
                                                // клиент-склад требующих экспорта
        else exit;
        self.LogPrintStep('Список актуальных экспортов получен');
        //self.LogMessage('Выполняем обновление скидок по клиентам ', true);
        //self.Q0.Open; датасет открыт предыдущей командой

        //в Q0 загружены записи клиент-склад требующие экспорта
        if self.Terminated  then exit;

        self.processClientsDiscounts(self.Q0);

        if self.Terminated  then exit;


        requestByTag(SQLSELECT0, self.Q0);   //requestFromFile(SQLSELECT0FILENAME, self.Q0);

        self.generatePrices(self.Q0);  //generatePrice(self.Q0,self.QQ);

        requestByTag(SQLMARKT, self.Q0);   //requestFromFile(SQLMARKTFILENAME, self.Q0);
except on E: Exception do
        self.LogPrintln(E.Message);
end;
      sccExp:=true;//self.LogMessage('Экспорт завершен успешно', true);
    finally
      self.LogResultReport(sccExp);
      DataQueryExtrication(self.Q0, true);  //self.Q0.Close;
      //self.QQ.Connection := self.ConnNAVs;
      self.Disconnect(1);
    end;
end;

procedure TExportDaemon.CheckQuantsUpdate;
const DELETEREQUEST='DELETE [##DATABASENAME##].[dbo].[##TABLENAME##]  WHERE [ID_WH] = ';   //ETK

var WHouse:TWarehouseDescr;
    h: integer;
    Reader: TNAVCSVReader;
    sqlstr: string;
    k: integer;
    sccQ: boolean;
    //ff: text;  ext: string;
    indexQNT: integer;
begin
//sleep(15000);
  self.LogPrintStep('Проверка наличия файлов остатков');
  self.Connect(1,self.serverName,self.dbName);    //подключение к серверу из ini
  indexQNT := self.QuantsFieldsList.IndexOf('QNT');
try

    //получение списка складов по основному подключению
    //if not selectWarehouse(self.Q0) then exit;
    if not self.selectWarehouses(self.Q0) then exit; //выход если не получили

    //запрос на утверждение обновления остатков
    sqlstr:=loadTextDataByTag('QuantsUpDate');  //loadStrFromFile('.qry');
    sqlstr:=substitutionDBTblByTemplate(sqlstr,self.dbName,self.QuantsTableName);

    self.QQ:=TADOQuery.Create(nil);
    self.QQ.Connection := self.ConnGeneral;
    QQ.CommandTimeout := 0;
    Reader := TNAVCSVReader.Create;
    self.LogAction('Цикл прохода по складам');
    self.Q0.First;
    //цикл по складам
    for h := 0 to Q0.RecordCount  - 1 do
     begin
       WHouse:=getWarehouseDsc(self.Q0); //описание настроек склада
       self.ItemLinking(WHouse);
       self.LogPrintStep('проверка завершения предыдущей транзакции...');
          Self.QQ.SQL.Text :=   //удаление следов предыдущей транзакции
           substitutionDBTblByTemplate(DELETEREQUEST,self.DBName,self.QuantsTableName)
            +IntToStr(-WHouse.id);
          if QQ.ExecSQL>0 then self.LogPrintStep('.. следы удалены')
          else self.LogPrintStep('.. следов не обнаружено');

       if FileExists(WHouse.filename)  then  //если найден файл универсального экспорта
        try
          self.LogAction('Обработка файла "'+WHouse.filename+'"...');
          try
            Reader.Open(WHouse.filename);
              //TRANSACTION BEGIN
                     //****except TRANSACTION ROLLBACK
                      //настройка параметров вставки
                      Reader.setPrefix(IntToStr(-WHouse.id)+';');
                      SetInsParameters(QQ, self.DBName, self.QuantsTableName, self.QuantsFieldsList);
                    //*****
                      self.LogAction('Цикл обновления таблицы остатков'); sccQ:=false;
                      if Reader.FileSize > 0 then
                       repeat
if self.Terminated  then exit;
                        Reader.ReturnLine;
                        //?if Reader.Eof then break;

                        //пропускаем запись с нулевым остатком
                        //if StrToInt('0'+Reader.getTypedFields(2,0){'0'+Reader.Fields[2]})>0 then //continue;
                        if StrToInt('0'+Reader.getTypedFields (indexQNT,0))=0 then continue;
                          SetInsValues(QQ, Reader, self.QuantsFieldsTypeCodes);
                       until Reader.Eof;
                      self.LogResultReport(Reader.Eof);
                      Reader.Close;

                      self.LogPrintStep('удаление устаревших остатков...');
//                      FreeAndNil(self.QQ);
//                      self.QQ:=TADOQuery.Create(nil);
//                      self.QQ.Connection := self.ConnGeneral;
//                      QQ.CommandTimeout := 0;
                      Self.QQ.SQL.Text :=   //удаление устаревших остатков
                       substitutionDBTblByTemplate(DELETEREQUEST,self.DBName,self.QuantsTableName)
                        +IntToStr(WHouse.id);

                       //***StringReplace(DELETEREQUEST, '[ETK].[dbo]',WHouse.db,[]);
                      self.QQ.ExecSQL;

                      self.LogPrintStep('утвердить изменения...');
                      //Self.QQ.SQL.LoadFromFile('SQLQuantsUpDate.qry');// 'QuantsUpdate.qry'   Self.QQ.SQL.Text
                      //ShowMessage(QQ.SQL.Text);
//                      FreeAndNil(self.QQ);
//                      self.QQ:=TADOQuery.Create(nil);
//                      self.QQ.Connection := self.ConnGeneral;
//                      QQ.CommandTimeout := 0;
                      Self.QQ.SQL.Text := StringReplace(sqlstr, '##WH_ID##', IntToStr(WHouse.id),[rfReplaceAll]);
                      //ShowMessage(QQ.SQL.Text);

                      self.QQ.ExecSQL;   //утвердить обновление остатков
                      //переименование исходного файла
                      //Assign(ff,WHouse.filename);
                      //ext:=ExtractFileExt(WHouse.filename); //if ext='' then ext:='.';
                      //Rename(ff,StringReplace(WHouse.filename, ext,'_'+ext,[]));

          except on E: Exception do
            self.LogMessage(E.Message, true);
          end;
  //TRANSACTION COMMIT
          //self.Cmd.Prepared := false;
        finally
          //self.Disconnect(2);
          Reader.Close;

          try
            self.LogPrintStep('удаление обработанного файла...');
            if self.deleteQuants then    DeleteFile(WHouse.filename)
            else RenameFile(WHouse.filename,
            ChangeFileExt(WHouse.filename, '_'+ExtractFileExt(WHouse.filename)));
          except
            on Ef: Exception do
              self.LogMessage(Ef.Message, true)
          end;

          self.LogResultReport(FileExists(WHouse.filename));
        end
        else self.LogPrintln('Файл "'+WHouse.filename+'" не найден');
        if self.Terminated  then exit;

        Q0.Next;
     end;

   //self.LogMessage('Завершено успешно! ', true);
finally
   self.LogResultReport(h=Q0.RecordCount);
   FreeAndNil(QQ);    //разрушаем явно созданный компонент запроса остатков
   DataQueryExtrication(Q0, true); //освобождение компонента запроса складов
   self.Disconnect(1);    //отсоединение от базы
end;
  //if True then
end;

procedure TExportDaemon.Run;
begin

  self.LogPrintln('');
  self.LogTimeStamp('Демон пронулся');
  self.CheckQuantsUpdate;  //проверка наличия файлов остатков

  if self.Terminated  then exit;

  self.CheckExportsUpdate; //проверка необходимости выполнить экспорт
  self.LogTimeStamp('Демон заснул');
  self.LogPrintln('');
end;
//procedure QuantsDaemon.SetInsParameters(Q: TADOQuery; dbName, tblName: string);
//begin
//
//end;

function TExportDaemon.selectWarehouses(var Q: TADOQuery): boolean;
  const REQUESTWAREHOSES = 'SELECT * FROM [Warehouses]';
begin
  RESULT:=false;
  try
    self.LogAction('получение списка складов');
    RESULT:=DatasetByRequest(Q,self.ConnGeneral,REQUESTWAREHOSES);
  finally
    self.LogResultReport(RESULT);
  end;
end;



procedure TExportDaemon.Init;
const REQUESTFIELDSLIST = 'SELECT [FieldName],[TypeCode] FROM [UNIFIELDS] WHERE [POS] IS NOT NULL ORDER BY [POS]';
var k: integer;
    ff: text;
begin

  iniFile:=TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+FILENAMEINI);
 // Showmessage(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))));

  self.interval := ReadTimerInterval;
  self.filelog := ReadLogFileName;
  self.serverName := ReadServerName;
  self.DBName := ReadDatabaseName;// +';'+'Initial Catalog='+ReadInitCatalog
  self.deleteQuants := ReadRemoveOption;

  if not(FileExists(self.filelog)) then
   try
    Assign(ff, self.filelog);
    Rewrite(ff);
   finally
    Close(ff);
   end;

  self.LogPrintln('');
  self.LogPrintln('thread: '+ IntToStr(self.Handle));
  self.LogTimeStamp('');
  
  //self.ConnGeneral.ConnectionString :=  ReadConnStr;
  //ShowMessage(serverName+' '+DBName);//     IntToStr( )  'java_config.ini'
try
    self.Connect(1, self.serverName,self.DBName);
except on E: Exception do self.LogMessage(E.Message, true);
end;
  self.Q0.SQL.Text := REQUESTFIELDSLIST;
  self.QuantsFieldsList.Clear;
  self.apparole := True;
  try
    self.Q0.ExecSQL;
    self.Q0.Open;
    setlength(self.QuantsFieldsTypeCodes,self.Q0.RecordCount);
    self.Q0.First; k:=0;
    repeat
      self.QuantsFieldsList.Add(trim(self.Q0.Fields[0].AsString));
      self.QuantsFieldsTypeCodes[k]:=self.Q0.Fields[1].AsInteger;
      inc(k);
      self.Q0.Next;
    until self.Q0.Eof;
  finally
    self.Q0.Close;
    self.Disconnect(1);
    FreeAndNil(iniFile);
  end;

end;

procedure TExportDaemon.ItemLinking(WH: TWarehouseDescr);
const DELETEREQUEST = 'DELETE FROM [UEXPORT].[dbo].[Products] WHERE [WH_ID]= ';
      SQLSELLINKS = 'SQLSELECTItemLinks';     //##WHID##   +'Termin'+#$D#$A
      LINKSFIELDS = 'Item_ID'+#$D#$A+'Brand'+#$D#$A+'Line'+#$D#$A+'Action'
                    +#$D#$A+'WH_ID';
      TABLENAME   = 'Products';
var sqlstr: string;
    QL: TADOQuery;
    filecsv: string;
    LinksFieldsList: TStringList;
    RR: TNAVCSVReader;
    LinksFieldsTypeCodes: TINTARRAY;
    sccLinking: boolean;
begin
  filecsv:=IncludeTrailingBackslash(ExtractFilePath(WH.filename))+'ProductsLinksWH#'+IntToStr(WH.id)+'.csv';

  SetLength(LinksFieldsTypeCodes, 7);
  LinksFieldsTypeCodes[0]:=0;
   LinksFieldsTypeCodes[1]:=20;
    LinksFieldsTypeCodes[2]:=20;
     LinksFieldsTypeCodes[3]:=20;
      LinksFieldsTypeCodes[4]:=0;
       LinksFieldsTypeCodes[5]:=0;
        LinksFieldsTypeCodes[6]:=0;

  if (FileExists(filecsv)) then  exit;
  try
    self.ConnNAVs := TADOConnection.Create(nil);
    self.Connect(2,wh.server, wh.db);
    try
      if self.apparole  then
        ConnNAVs.Execute(loadTextDataByTag('SQLMAGICWORD'),cmdText,[eoExecuteNoRecords]);
    except
      self.apparole:=false;
    end;

    QL:=TADOQuery.Create(nil);
    QL.Connection:=self.ConnNAVs;
    //self.Connect(2,WH.server, WH.db);

    sqlstr:=loadTextDataByTag(SQLSELLINKS);
    sqlstr:=Stringreplace(sqlstr, '##DATABASE##', WH.db, [rfReplaceAll]);
    sqlstr:=Stringreplace(sqlstr, '##FIRM##', WH.firm, [rfReplaceAll]);
    //задействован постфикс sqlstr:=StringReplace(sqlstr,'##WHID##',IntToStr(WH.id),[rfReplaceAll]);
    QL.SQL.Text:=sqlstr;
    QL.CursorType := ctStatic;
    QL.CommandTimeout := 0;//self.interval div 2;
    self.LogAction('Запрос привязок товаров по складу ...'+IntToStr(WH.id));
    sccLinking:=false;
    try
try
        QL.Open;
        self.LogTimeStamp('Сохранение во временный файл '+filecsv);
        if  QL.RecordCount>0 then
          SaveToCSV(QL,filecsv);   //!!! в последствии сделать QuerySelect->QueryInsert
        sccLinking:=True;
except on E: Exception do
        self.LogMessage(E.Message,true);
end;
    finally
    self.LogResultReport(sccLinking);
      //FreeAndNil(QL);
        QL.Close;
    end;
  finally
    self.Disconnect(2);
    FreeAndNil(self.ConnNAVs);
  end;
//сохранение результата из файла в таблицу UExport.Products на SQLServer
  //self.ConnGeneral подключено к серверу во внешней процедуре
  QL.Connection:=self.ConnGeneral;
  if FileExists(filecsv) then
  try
    QL.Connection.Execute(DELETEREQUEST+IntToStr(WH.id));
    LinksFieldsList:=TStringList.Create;
    LinksFieldsList.Text :=LINKSFIELDS;
    //sqlstr:='...';
    SetInsParameters(QL,self.DBName, TABLENAME, LinksFieldsList);
    RR:=TNAVCSVReader.Create;
    try
      RR.Open(filecsv);
      self.LogAction('Заполнение таблицы Products...'); sccLinking:=false;
      RR.setPostFix(';'+IntToStr(WH.id));
      if RR.FileSize > 0 then
       repeat
        RR.ReturnLine;
        SetInsValues(QL, RR, LinksFieldsTypeCodes);
       until RR.Eof
      else exit;
      sccLinking:=true;
    finally
      self.LogResultReport(sccLinking);
      FreeAndNil(RR);
    end;
  finally
  end
  else
   self.LogMessage('Не найден временный файл '+filecsv, true);
end;

{ TNAVCSVReader }

procedure TNAVCSVReader.clearAppendix;
begin
  self.prefix :='';
  self.postfix:='';
end;

constructor TNAVCSVReader.Create;
begin
  inherited Create;
  self.clearAppendix;
//  self.prefix := '';
//  self.postfix :='';
end;

function TNAVCSVReader.getTypedFields(index, typecode: integer): String;
begin
  RESULT:=self.Fields[index];
  //if typecode<0 then exit;
  RESULT:=trim(RESULT); //**опция
  if typecode <= 0 then
    RESULT:=Numeric(RESULT, -typecode)
  else
    if length(RESULT)>typecode then setlength(RESULT, typecode);
end;

class function TNAVCSVReader.Numeric(strval: string; frac: integer): string;
  const decsep = '.';
  var antisep: char;
  int: boolean;
  k, l, p: integer;
begin
  case decsep of
  '.': antisep:=',';
  ',': antisep:='.';
   else antisep:=decsep;
  end;
  //if StrToFloat(strval)>0 then
  begin
    //if (pos(antisep,strval)<pos(decsep,strval)) then
    //возможен вариант вывода антиразделителя как разделителя разрядов
    //требуется предусмотреть вариант

    strval:=stringReplace(strval,antisep,decsep,[rfReplaceAll]);
    //strval:=stringReplace(strval,'.',decsep,[rfReplaceAll]);
    strval:=stringReplace(strval,#$A0,'',[rfReplaceAll]);
    RESULT:=stringReplace(strval,#$0A,'',[rfReplaceAll]);
    p:=pos(decsep, RESULT);
    if (frac<0)or(p=0) then exit;


    if frac=0 then Numeric:=copy(RESULT,1,p-1)
    else Numeric:=copy(RESULT,1,p+frac);

//    if k=0 then exit;
//    l:=length(RESULT);
//    if l=0 then exit;
//
//    int:=true;
//    while (int) and(k<l) do
//     begin
//      inc(k);
//      int:=int and (RESULT[k]='0');
//     end;
//
//    if int then
//      Numeric:='0'+copy(RESULT,1, pos(decsep,RESULT)-1);
  end;
end;

procedure TNAVCSVReader.ParseFields;
begin
  self.CurrentLine := prefix+self.CurrentLine+postfix;
  inherited;
//  if Length(self.prefix)>0 then self.fFields.Insert(0,self.prefix);
//  if Length(self.postfix)>0 then self.fFields.Add(self.postfix);

end;

function TNAVCSVReader.setPostFix(postfix: string): boolean;
begin
  self.postfix := postfix;
end;

function TNAVCSVReader.setPrefix(prefix: string): boolean;
begin
  self.prefix := prefix;
end;

end.
