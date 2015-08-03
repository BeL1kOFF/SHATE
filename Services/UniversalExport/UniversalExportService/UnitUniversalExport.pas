unit UnitUniversalExport;

interface
uses   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, ActiveX,  SyncObjs,  SqlExpr,    WideStrings, DBClient, Provider,
  _CSVReader, UnitConfig,inifiles, UnitSmtpThread, Math, UnitLogging;

  Type  TDomainDescr = Record
          id: integer;
          server: string[50];
          db: string[50];
          firm: string[50];
          //filename: string[255];
        End;
//          server: string[50];
//          db: string[50];
//          firm: string[50];

        TUnloadDescr = Record
          active: boolean;
          id: integer;
          idd: integer;
          whNo : integer;
          priceGroupID: integer;
          CY: string[3];
          filename: string[255];
          linking: boolean;
          filter: string;
        End;

   //класс предназначенный для ответвления впоследствии в отдельный поток
        TImportSubDaemon = Class{(TThread)}
          public
            ConnGeneral : TADOConnection;
            filelog: string;
            domainsSet: TINTSET;
            whNo, domain: integer;
            serverName, DBName : string;
            serverNAV, dbNAV, Firm: string;
            
            go: ^boolean;
            function LoadIerarchy(domainNo: Integer): boolean;
            function LoadItems(domainNo: integer): boolean;
            function LoadCurrencies: boolean;
            function LoadPrices(domainNo: integer): boolean;
            function LoadStocks(domainNo: integer): boolean;
            function LoadCosts(domainNo: integer): boolean;
            procedure Init;
            procedure Run;
          var fresh: boolean;  function LoadCurrenciesTest: boolean;
          published
            Logger: TLogger;
            constructor Create; overload;
            destructor  Destroy; override;
          private
          const DD = 2; //существующие домены: 1..DD
            //function CheckItemsUpdate(var itemts, iigts, umts: int64): boolean;
            function LoadData(whNo, W: integer; map0list,map_list, types_list, donortag,acceptortag: string): boolean;
            function getSingleValueByRequest(SQLstatement, ServerName, database: string): string;
            function execut(SQLstatement, ServerName, database: string):boolean;
            function CheckImportsUpdate: boolean;

            function ResetImports(Q0: TADOQuery): boolean;
            procedure ReadConfigParameters;

            function getWarehouses(WhQ: TADOQuery): boolean;

            procedure LogTimeStamp(Msg: string);
        End;


  // класс - демон универсального экспорта
        TExportDaemon = Class(TThread)
         public
          var Live: boolean;
              Active :boolean;
              Debug: boolean;
              Q0, QQ, QNAV: TADOQuery;
              serverName, DBName: string;
              Cmd: TADOCommand;
              ConnGeneral, ConnNAVs: TADOConnection;
              apparole: boolean;
              interval: integer;
              timesleep: integer;
              timeout: integer;
              deleteQuants, refreshLinks: boolean;
              filelog: string;
              hammer: boolean;
              reconfig: boolean;
              loglevel : integer;
              Import: TImportSubDaemon;
          procedure Run;
          procedure Execute; override;



          procedure LogTimeStamp(Msg: string);
          procedure LogAction(Msg: string);
          procedure LogResultReport(Success: boolean);
          procedure LogPrintStep(Msg: string);
          procedure LogError(Msg: string);


         published
          Logger: TLogger;
          //constructor Create(Plug1, Plug2: TADOConnection; Query1, Query2, Query3: TADOQuery); overload;
          constructor Create; overload;
          destructor  Destroy; override;
         private
          
          QuantsTableName: string;
          QuantsFieldsList: TStringList;
          QuantsFieldsTypeCodes: TINTARRAY;//array of integer;
          function Connect(connNo: integer; server, db: string): boolean;
          procedure Init;
          procedure ReadConfigParameters;
          function reinitialization: boolean;
          //procedure SetInsParameters(Q: TADOQuery; dbName, tblName: string);
          procedure QuantsUpdate;
          procedure CheckQuantsUpdate;
          procedure CheckExportsUpdate;
          function Disconnect(connNo: integer): boolean;
          procedure LogMessage(Msg: string; CR: boolean);
          procedure LogPrintln(Msg: string);
          procedure LogPrint(Msg: string);

          procedure ItemLinking(XWH: TUnloadDescr; rewritemode: boolean);
//методы перенесённые из внешних подпрограмм
          function selectWarehouseXs(var Q: TADOQuery): boolean;
          function getUnLoadDsc(datas: TADOQuery): TUnloadDescr;

          function LoadDiscountsForClient(client_id: integer; ClientsQuery: TADOQuery): boolean;
          procedure processClientsDiscounts(QuExports: TADOQuery);


          function generateQuantsRequestByWarehouseX(whXid: integer): string;
          procedure generatePrices(DataExports: TADOQuery; var procexplist: string);
          function SavingToFile(dataset: TADOQuery; var filename, title: string; extformat:boolean=false): boolean;


          function DomainDescByID(idd: integer): TDomainDescr;

          function csvBrandLine(ItemID: string; domain: integer): string;

          procedure Death(Sender: TObject);
        End;


        TNAVCSVReader = Class(TCSVReader)
        public
          function getTypedFields(index, typecode: integer): string;
          function isConsiderableField(index, typecode: integer):boolean;
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

          TConnRef = class of TCustomConnection;
          TDataRef = class of TDataSet;
          TSupportClass = class of TSupport;


          IBridgeConnection = interface
            ['{6A4DD3BC-F26F-49B2-87F0-65E4D0954A30}']

            //property ConnectingString: string;
            //property Connected: boolean;
            procedure Open;
            procedure Close;
            procedure Execute(commandString:string);

          end;

          IBridgeDataSet = interface
            ['{1A049A2C-1D13-4946-94E9-68F2A15F2E10}']

            //property statementSQL: string;
            //property tablename: string;
            function getFields: TFields;

            property Fields: TFields read getFields;
            procedure Config(goal: string);
            procedure Open;
            procedure First;
            procedure Next;
            procedure Last;
            function Eof: boolean;
            procedure Append;
            procedure Post;
            procedure Close;

          end;




          TBank = Record
            b: boolean; //берег false - драйвер SQL SERVER (к NAV); берег true - OLEDBProvider (AMD)
            servername,
            dbname: string;

            place: string;
            map: TINTARRAY;
          End;
          TSupport = Class(TInterfacedObject, IBridgeConnection, IBridgeDataSet)

            procedure OpenConnection;  virtual; abstract;
            procedure OpenData;        virtual; //abstract;

            procedure IBridgeConnection.Open = OpenConnection;
            procedure IBridgeDataSet.Open = OpenData;

            procedure Execute(commandString: string); virtual; abstract;

            procedure ConfigData(device: string); virtual;
            procedure IBridgeDataSet.Config = ConfigData;

            procedure CloseConnection; virtual; //abstract;
            procedure CloseData;       virtual; //abstract;
            procedure IBridgeConnection.Close = CloseConnection;
            procedure IBridgeDataSet.Close = CloseData;

            procedure disconnectRecordset; virtual; abstract;
            procedure reconnectRecordset; virtual;abstract;

            function getFields: TFields; virtual;

            procedure First;  virtual;
            procedure Next;   virtual;
            procedure Last;   virtual;
            function Eof: boolean;
            procedure Append; virtual;
            procedure Post;   virtual;

            class function Datatech(b: boolean): TDataRef;  virtual; abstract;
            class function Detected(CONNECTINGTYPE: TConnRef): TSupportClass;

            var Bank: TBank;
            art : boolean;
            DisconnectedRecordset: boolean;
           private

            Connection: TCustomConnection;
            Data: TDataSet;
            ConnType: TConnRef;
            DataType: TDataRef;
           published
            constructor Create(DataBank: TBank);   virtual;//;ConnectionType: TConnRef
            destructor Destroy; override;
          End;

          TADOSupport = Class(TSupport)
            procedure OpenConnection;   override;
            procedure Execute(commandString: string); override;
            procedure ConfigData(device: string); override;
            procedure OpenData; override;
           private
            class function Datatech(b: boolean): TDataRef;  override;
           published
            constructor Create(DataBank: TBank);   override;
            destructor Destroy; override;
          End;

          TSQLSupport = Class(TSupport)
            procedure OpenConnection;      override;
            procedure Execute(commandString: string); override;
            procedure ConfigData(device: string); override;
            function getFields: TFields; override;
            procedure CloseData; override;

            procedure OpenData; override;
            procedure First;  override;
            procedure Next;   override;
            procedure Last;   override;
            //function Eof: boolean; override;
            procedure Append; override;
            procedure Post;   override;


           private
            class function Datatech(b: boolean): TDataRef;  override;
            var DataProvider: TDataSetProvider;
                Cache : TClientDataSet;
           published
            constructor Create(DataBank: TBank);    override;
            destructor Destroy; override;
          End;

          TDataBridge = Class
          public

             //конфигурация отправляющей и принимающей сторон
             class function setBank(bf: boolean; server, db, plc, coords: string; w: integer):TBank;

             //перенос данных из базы в базу
             procedure Cross;
             procedure Proclaim(motto: string);
             var hq, target: string;
              map0, map, types:  TINTARRAY; // array of integer;
              Dim: integer;
              SQLStatement: string;
              filelog: String;
              concentration: integer;
              BridgeTooFar : boolean;
          published
            constructor Create(SrcBank, DstBank: TBank; Dimension: integer; tt: TINTARRAY);
            destructor  Destroy; override;
          private
            Constructions: array[0..1] of TSupport;
            Devise : string;
            LeftSupport, RightSupport: IBridgeConnection;  (*==RightSupport0: TSQLConnection;*)
            QDepart: IBridgeDataSet;
            QArrivee: IBridgeDataSet; (*QArrivee0: TSQLTable;*)

             procedure connect;
             procedure disconnect;

            function TypedField(fld: string; typecode: integer): string;
            class function  Numeric(strval: string; frac: integer): string;
          End;

          TBridge = Class
          public

             //конфигурация отправляющей и принимающей сторон
             class function setBank(bf: boolean; server, db, plc, coords: string; w: integer):TBank;

             //перенос данных из базы в базу
             procedure Cross;

             var hq, target: string;
              map0, map, types:  TINTARRAY; // array of integer;
              Dim: integer;
              SQLStatement: string;
              filelog: String;
              concentration: integer;
              BridgeTooFar : boolean;
              depth: boolean;

              Logger: TLogger;
              IRQ: ^boolean;
          published
            constructor Create(SrcBank, DstBank: TBank; Dimension: integer; tt: TINTARRAY);
            destructor  Destroy; override;
          private
            LeftSupport, RightSupport: TADOConnection;  (*==RightSupport0: TSQLConnection;*)
            QDepart: TADOQuery;
            QArrivee: TADOTable; (*QArrivee0: TSQLTable;*)

             procedure connect;
             procedure disconnect;

             function select(SQL: string): boolean;  //не задействована
            function TypedField(fld: string; typecode: integer): string;
            class function  Numeric(strval: string; frac: integer): string;
          End;
  var Daemon: TExportDaemon;
      //* перенесено в UnitConfig sect: TCriticalSection;
//  function generateConnStr(OLEDBProvider: boolean; serverName, dbName: string): string;
  function substitutionDBTblByTemplate(template, dbName, tblName: string): string;

  function selectWarehouse(datas: TADOQuery): boolean;
  function getDomainDsc(datas: TADOQuery): TDomainDescr;
  function getWarehouseXDsc(datas: TADOQuery): TUnloadDescr;
  //function Numeric(strval: string): string;


  procedure SetInsParameters(Q: TADOQuery; dbName, tblName: string; Fields: TStringList);
  procedure SetInsValues(Q: TADOQuery; R: TNAVCSVReader; typecodes: TINTArray);

implementation

  var ExportLogger, ImportLogger: TLogger;

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

function requestByTag(sqltag, adds: string; DataS: TADOQuery): boolean;
var request: string;  isSELECT: boolean;
begin
  RESULT:=false;
  request:=loadTextDataByTag(sqltag);
  if request = '' then exit;

  request := concat(request,adds);
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
    Raise; //fix: E => AccessVoilationError
    //if not(RESULT) then DataS.Close;
  end;
end;

//function requestFromFile(sqlfilename: string; DataS: TADOQuery): boolean;
//var request: string;
//begin
//  RESULT:=false;
//  request:=loadStrFromFile(sqlfilename);
//  if request = '' then exit;
//  DataS.SQL.Text := request;
//  try
//
//    DataS.ExecSQL;
//    //DataS.Open;
//    RESULT:=true; //(DataS.RecordCount >0);
//  finally
//    ;
//  end;
//end;
//  function loadStrFromFile(filename: string): string;
//  var ff: text; line: string;
//  begin
//    RESULT:='';
//    if FileExists(filename) then Assign(ff, filename)
//    else exit;
//
//    try
//      Reset(ff);
//      repeat
//        readln(ff,line);
//        RESULT:=RESULT+#13#10+line;
//      until eof(ff)=true;
//    finally
//      CloseFile(ff);
//      RESULT:=RESULT+#13#10;
//    end;
//
//  end;
//
//  function loadTextDataByTag(tag: string): string;
//  var
//    Resource, resinfo: THandle;
//  begin
//    RESULT:='';
//    resinfo:=   FindResource(hInstance, PANSICHAR(tag), 'TEXT');
//    Resource := LoadResource(hInstance, resinfo);
//    RESULT := PChar(LockResource(Resource));
//    SetLength(RESULT, SizeOfResource(hInstance, resinfo));
//
//    UnLockResource(Resource);
//    FreeResource(Resource);
//
//    //RESULT:=loadStrFromFile(tag+'.qry');
//  end;


  function substitutionDBTblByTemplate(template, dbName, tblName: string): string;
  begin
    template:=StringReplace(template,'##DATABASENAME##',dbName,[rfIgnoreCase]);
    template:=StringReplace(template,'##TABLENAME##',tblName,[rfIgnoreCase]);
    RESULT:=template;
  end;

{
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
}
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

  function getWarehouseXDsc(datas: TADOQuery): TUnloadDescr;
  begin
   try
    RESULT.id :=datas.Fields[0].AsInteger;
    //RESULT.server := trim(datas.Fields[3].AsString);
    //RESULT.db := trim(datas.Fields[4].AsString);
    //RESULT.firm := trim(datas.Fields[5].AsString);
    //RESULT.filename := trim(datas.Fields[6].AsString);
   finally
     ;
   end;
  end;

  function getDomainDsc(datas: TADOQuery): TDomainDescr;
  begin
   try
    RESULT.id :=datas.Fields[0].AsInteger;
    RESULT.server := trim(datas.Fields[3].AsString);
    RESULT.db := trim(datas.Fields[4].AsString);
    RESULT.firm := trim(datas.Fields[5].AsString);
    //RESULT.filename := trim(datas.Fields[6].AsString);
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

  function NavClientCode(idClient: integer; QueryClients: TADOQuery; var IDD: integer):string;
  const   REQUESTCLIENTNAV = 'SELECT [NAV_Client], [DOM] FROM [Clients] WHERE [ID] = ';
  begin
    RESULT:='';
    QueryClients.SQL.Text := REQUESTCLIENTNAV + IntToStr(idClient);
    QueryClients.ExecSQL;
    QueryClients.Open;
    if QueryClients.RecordCount<1  then exit;

    if QueryClients.Fields[0].IsNull  then exit;
    RESULT:=trim(QueryClients.Fields[0].AsString);

    if QueryClients.Fields[1].IsNull  then exit;
    IDD:=QueryClients.Fields[1].AsInteger;

    QueryClients.Close;
  end;

  function wahrehouseXByID(id_wh: integer; whQuery: TADOQuery): TUnloadDescr;
  begin
    whQuery.SQL.Text:= 'SELECT * FROM [WAREHOUSES] WHERE [ID] = '+IntToStr(id_wh);
    //whQuery.ExecSQL;
    whQuery.Open;
    if whQuery.RecordCount=0  then exit;
    whQuery.First;
    RESULT := getWarehouseXDsc(whQuery);
    whQuery.Close;
  end;

//перенесено в метод TUniversalExport
//  function DomainByID(idd: integer; DomQuery: TADOQuery): TDomainDescr;
//  begin
//    DomQuery.SQL.Text:= 'SELECT * FROM [DOMAINS] WHERE [ID] = '+IntToStr(idd);
//    //whQuery.ExecSQL;
//    DomQuery.Open;
//    if DomQuery.RecordCount=0  then exit;
//    DomQuery.First;
//    RESULT := getDomainDsc(DomQuery);
//    DomQuery.Close;
//  end;

  function fieldslistByTemplate(TemplID: integer; tmplQuery: TADOQuery; var csvtitles: string): string;
  const TEMPLREQUEST = 'SELECT [SQL], [CSV] FROM [TEMPLATES] WHERE [ID] =';
  begin
    tmplQuery.SQL.Text := TEMPLREQUEST + IntToStr(TemplID);
    RESULT:='';
    tmplQuery.ExecSQL;
    tmplQuery.Open;
    if tmplQuery.RecordCount > 0 then
     begin
       tmplQuery.First;
       RESULT:=trim(tmplQuery.Fields[0].AsString);
       if  tmplQuery.Fields[1].isNull then csvtitles:='' // ошибка инициализации!         // not
        else csvtitles:=trim(tmplQuery.Fields[1].AsString);
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

  function FilePathLocalization(var filename, share: string; subdir: string): boolean;
  var p:integer;
  begin
    share:= ExtractFileDrive(filename); //для определения типа имени файла
    if share =''   then   // если в имени файла ни диска ни шары
     begin
      p:=pos('\',filename);
      case p of       
       0: // - относительный путь
          filename := Concat(ExtractFilePath(paramstr(0)),subdir,filename); //дописываем папку по умолчанию
       1: // - подвязка по подкаталогу либо каталогу исполняемого файла
          if pos('\'+subdir,filename)>0 then filename:=Concat(ExtractFileDir(paramstr(0)),copy(filename,pos('\'+subdir,filename)))
               else filename := Concat(ExtractFilePath(paramstr(0)),filename);
       else // - префиксный путь просто игнорируется
          filename:= Concat(ExtractFilePath(paramstr(0)),ExtractFileName(filename));
      end;   
     end
     else
      if copy(share,1,2)='\\' then //назначение на удалённом сервере
       begin    //сохранение шары в буфер & подстановка каталога для локального сохранения
        share:=filename;
        filename:=ChangeFilePath(filename,ExtractFilePath(paramstr(0)));
       end
       else share:=''; // share='<Drive>:\' => исходный путь не требует преобразования
    RESULT:=share<>''; //в результате "выполнена подмена на локальный путь сохранения"
  end;

  //функция сохранения данных в текстовом формате с возможностью определения разделителя полей по расширению   
  function SaveToFile(dataset: TADOQuery; filename, title: string; extformat :boolean=false): boolean;
    var i, j, M, N : integer;
    line: string;
    datafile: text;
    ext: string;
    delimiter, space: char;
    FormatSettings: TFormatSettings;
  begin
    RESULT:=false;
    if trim(ExtractFilename(filename))='' then exit;
    if ExtractFilePath(filename)<>'' then
     if not DirectoryExists(ExtractFileDir(filename)) then exit;

    ext:=ExtractFileExt(filename);
    //если разрешен автоопределение формата по расширению
    if extformat then
     begin
      if ext='.csv' then delimiter:=';'
      else if ext='.txt' then delimiter:=#$9;

      case delimiter of
      #$9: title:=StringReplace(title,';',delimiter,[rfReplaceAll]);
      end;      
     end else delimiter:=';';
  
    if delimiter<>' ' then space:= ' ' else space:=#$A0;

    //если файл существует и нет возможности его удалить то временный файл не создаётся
    if FileExists(filename) then    
     if not DeleteFile(filename) then ext:='';

    //сохранение во временный файл
    if ext<>'' then    
      filename:= ChangeFileExt(filename,'._'+copy(ext,2)+'_');

    GetLocaleFormatSettings(LOCALE_USER_DEFAULT, FormatSettings);
    FormatSettings.DecimalSeparator:='.';
    //FormatSettings.ThousandSeparator:='';

    N:=dataset.RecordCount;
    if N=0 then exit;
    M:=dataset.Fields.Count;
    dataset.First;
    Assign(datafile,filename);
    //ShowMessage(csvfilename);
    try
      Rewrite(datafile);
      if title<>'' then writeln(datafile, title);
      for i := 0 to N - 1 do
       begin
         line:='';
         if dataset.Eof then break;      //exit вернёт false
         for j := 0 to M - 1 do
          if dataset.Fields[j].DataType=ftFloat then
           line:=line+trim(FormatFloat('0.##',dataset.Fields[j].AsFloat,FormatSettings))+delimiter
          else
           line:=line+trim(StringReplace(dataset.Fields[j].AsString,delimiter,space,[rfReplaceAll]))+delimiter;
         SetLength(line, length(line)-1);
         writeln(datafile,line);
         dataset.Next;
       end;
      //RESULT:=dataset.Eof;
    finally
      CloseFile(datafile);
    end;
try
      if dataset.Eof then
       if ext<>''then
         RESULT:=RenameFile(filename,ChangeFileExt(filename,ext)) //при сохранении через временный файл
        else RESULT:= True;  //при прямом сохранении
except on Err: Exception do
end;
  end;

 // function DataSetSaveToCSV(dataset: TADOQuery; csvfilename, title: string): boolean;


{ TExportDaemon }

function TExportDaemon.Connect(connNo: integer; server, db: string): boolean;
const TMPLTCONNSTR = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=True;User ID=shingarev;Initial Catalog=;Data Source=AMD;';
var Connection: TADOConnection;
    status: string; 
    Action: IAction;                                                                                                                        // ETK
begin
  RESULT:=false;
  case connNo of
    1: Connection:=self.ConnGeneral;
    2: Connection:=self.ConnNAVs;
    else exit;
  end;

  try  Action:=TAction.Create('Соединение с сервером',self.Logger);
    try   Action.Start;
      if Connection.Connected then exit; 
      Connection.LoginPrompt := False;
      //self.Connection.ConnectionString:=stringReplace(TMPLTCONNSTR,'Initial Catalog=;','Initial Catalog='+dbName+';',[]);
      Connection.ConnectionString := generateConnStr(connNo=1, server, db);
      self.LogAction('Соединение с... '+Connection.ConnectionString);
          Action.Stamp('Строка соединения: '+Connection.ConnectionString);
      Connection.Connected :=True;
          Action.Resume(Connection.Connected);
          Action.Finish;
    except on E: Exception do Action.Catch(E);
    end;  Action.Report;

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
  //Action: IAction;
begin
try
    inherited Create(True); //создаём остановленный поток
    self.Priority := tpLower;
    CoInitializeEx(nil, COINIT_MULTITHREADED);  //*
    self.QuantsTableName := 'Quants';//'UNIEXPORT_Quants';

    self.QuantsFieldsList := TStringList.Create;
    self.ConnGeneral := TADOConnection.Create(nil);
    self.Q0 := TADOQuery.Create(nil);
    self.Q0.Connection := self.ConnGeneral;
    self.Q0.CommandTimeout := 0;

    self.Logger := UniversalLogger; //   перенесено в запуск службы - Unit1

    //Action:= TAction.Create('Инициализация демона',self.Logger);//пока неизвестно куда логгировать

    //считываем конфигурацию запуска...
    self.Init;
//    if NOT self.Debug then
//      self.Logger.setDB(self.serverName,self.DBName);

//***************Import**********************
    self.Import:=TImportSubDaemon.Create;
    self.Import.serverName := self.serverName;
    self.Import.DBName := self.DBName;
    self.Import.filelog := self.filelog;
    self.Import.ConnGeneral := self.ConnGeneral;
    //self.Import.Logger := self.Logger; //импорт и экспорт в один лог  - перенесено в Unit1
    self.Import.go := @self.hammer;
//*******************************************
    self.OnTerminate :=  Death;
    self.hammer:=false;
    self.loglevel := 0;
    self.LogTimeStamp('Служба запущена');
except
    on Err: exception do
     begin
      AssignFile(ferr,FILEERRLOG);

      try
        Append(ferr);
        writeln(ferr, '!ошибка инициализации: ' +Err.Message);
      finally
        CloseFile(ferr);
      end;
      Raise;
     end;
end;
end;

function TExportDaemon.csvBrandLine(ItemID: string; domain: integer): string;
const BRANDLINEREQUEST = 'select ID_Item, Brand, Line from Items ';
var Q: TADOQuery;    SQLstr: string;
begin
  RESULT:='';
  Q:= TADOQuery.Create(nil);
  try
    Q.Connection:=self.ConnGeneral;
    SQLstr := BRANDLINEREQUEST + ' where ';
    SQLstr:= SQLstr + ' ID_Item = ' +'''' + ItemID  + ' and DomainNo =' + IntToStr(domain);
    Q.SQL.Text := SQLstr;
    Q.Open;
    RESULT:=Q.FieldByName('Brand').AsString + ';'+ Q.FieldByName('Line').AsString;
    Q.Close;
  finally
    FreeAndNil(Q);
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



procedure TExportDaemon.Death(Sender: TObject);
begin
  self.Live := False;
  //self.Suspend
end;

destructor TExportDaemon.Destroy;
begin
  //разрушить созданные объекты....
  try
    FreeAndNil(self.QuantsFieldsList);
    FreeAndNil(self.Q0);
    FreeAndNil(self.ConnGeneral);
    FreeAndNil(self.Import); //*Import для переноса
  finally
  CoUninitialize;  //*
  self.LogTimeStamp(' Служба остановлена');
  inherited;
  end;
end;

function TExportDaemon.Disconnect(connNo: integer): boolean;
var Connection: TADOConnection;
    Action: IAction;
begin
  RESULT:=false;
  case connNo of
   1:   Connection:=self.ConnGeneral ;
   2:   Connection:=self.ConnNAVs ;
   else exit;
  end;
  Action:= TAction.Create('Отсоединение', self.Logger);
try
    Action.Start;
try
      if NOT Connection.Connected then exit;
      Connection.Connected := false;
      Action.Stamp('Разорвано соединение "'+Connection.ConnectionString+'"');
      Action.Resume(NOT Connection.Connected);
      Action.Finish;
except on E: Exception do  Action.Catch(E);
end;
finally
      Action.Report;
end;
  self.LogTimeStamp('Разорвано соединение '+Connection.ConnectionString);
  self.LogPrintln('');
  RESULT:=not(Connection.Connected);
end;


function TExportDaemon.DomainDescByID(idd: integer): TDomainDescr;
var DomQuery: TADOQuery;
begin
      DomQuery:=TADOQuery.Create(nil);
try
      DomQuery.SQL.Text:= 'SELECT * FROM [DOMAINS] WHERE [ID] = '+IntToStr(idd);
      DomQuery.Connection:=self.ConnGeneral;
      DomQuery.Open;
      if DomQuery.RecordCount=0  then exit;
      DomQuery.First;
      RESULT := getDomainDsc(DomQuery);
      DomQuery.Close;
finally
      FreeAndNil(DomQuery);
end;

end;

procedure TExportDaemon.Execute;
var Action: IAction;
begin
  inherited;
  //--------тестирование импорта
  //sleep(15000);
  {
  try
   try
    }self.Import.Init;{
    self.Import.Run;
    self.QuantsUpdate;
   except
    on E: exception do
      self.LogError(e.Message);
   end;
  finally
    FreeAndNil(self.Import);

  end;  }
  //exit;
  //--------конец

try    Action:=TAction.Create( 'Цикл исполнения',self.Logger, false);
  try Action.Start;
      repeat
        if self.hammer  then
         begin
          if self.Terminated then Action.Interrupt;
          //raise Exception.Create('Тест рестарта');
          self.Import.Run;
          Action.Stamp('Проверка свежести импорта');
          if self.Import.fresh then self.QuantsUpdate;
          if self.Terminated then exit;
          Action.Stamp('Проверка активности экспорта');
          if self.Active then self.Run;
          Action.Stamp('Спустить курок');
          SectCTRL.Enter;
          try
            if (self.hammer)then self.hammer:=false else exit;
          finally
            SectCTRL.Leave;
          end;
         end
         else  exit;
         Action.Stamp('Погружение в сон');
        self.Suspend;
        //if self.Terminated then exit;
      until (self.Terminated);
      Action.Finish;
  except on E: Exception do
      Action.Catch(E);
  end;
finally  Action.Report;
end;

end;

procedure TExportDaemon.generatePrices(DataExports: TADOQuery; var procexplist: string);
  const INDWH = 2;       //индекс поля номера склада
        INDCLIENT = 1;    //индекс поля номера клиента
        INDTEMPL = 8;    //индекс поля шаблона
        INDFLNAME = 7;   //индекс поля имени файла экспорта
        INDEMAILBIT = 9; //
        INDEMAIL = 10;  //индекс адреса отправки
        INDCYTAG =3;
        INDCLCODE = 4;
        INDPRGR = 13;//INDDOMAIN = 13; //домен вернётся в 13 поз после рефакторинга
        INDEMAILSUBJ = 11; //?? запрос экспортов переделать номера сместятся!!!
        INDEMAILBODY = 12;
        INDARCHBIT =14;
  var fldlist, dscpricereq, pricereq: string;
    pos0, pos_: integer;
    cli: integer;
    i,
    h,
    tplNo: integer;
    sendflag: boolean;
    email: string;
    msgbody: string;
    msgsubj: string;
    sendcopies: boolean;

    pricefile, share, subdir: string;
    DataTemp: TADOQuery;
    sccPrc: boolean;
    csvtitles: string;

    BlackListFilter: string;
    clprgr: integer; //{,domainNo} номер домена будет вновь задействован после рефакторинга
    cy: string;
    attacharch: boolean;
    EmailDesc: TEmailDscr;

    Action, ExpAction :IAction;
    affect: integer;
  begin
    Action := TAction.Create('Формирование файлов прайсов',Self.Logger);
    self.LogAction('Формирование файлов прайсов');   sccPrc:=false;
    DataTemp:=TADOQuery.Create(nil);
    try    Action.Start;
try
        DataTemp.Connection := self.ConnGeneral;
        procexplist:='';
        //DataExports.Open; //*!?  Набор экспортов передаваться в предварительно уже открытом виде

        DataExports.First;
        repeat   //цикл по записям экспорта
          sleep(self.timesleep);//*
          if self.Terminated then break;    //+*! прерываем обработку в случае внешнего сигнал завершения


          h    := DataExports.Fields[INDWH].AsInteger;
          tplNo:= DataExports.Fields[INDTEMPL].AsInteger;
          fldlist:=fieldslistByTemplate(tplNo,DataTemp, csvtitles);


          //если флаг отправки NULL то письмо уходит по адресу
          //указанному в экспорте, если адрес адекватный (для тестирования)
          if DataExports.Fields[INDEMAILBIT].IsNull  then
            sendflag:= not(DataExports.Fields[INDEMAIL].IsNull)
          else sendflag:=DataExports.Fields[INDEMAILBIT].AsBoolean;

          email:=trim(DataExports.Fields[INDEMAIL].AsString);
          sendflag := sendflag AND (email<>'');

          if DataExports.Fields[INDARCHBIT].IsNull then attacharch := true //совместимость
          else
          attacharch := DataExports.Fields[INDARCHBIT].AsBoolean;

          sendcopies := not DataExports.Fields[INDEMAILBIT].IsNull;   //в тестовом варианте копии не уйдут
          if DataExports.Fields[INDEMAILSUBJ].IsNull  then
            msgsubj := '' else msgsubj:=trim(DataExports.Fields[INDEMAILSUBJ].AsString);

          if DataExports.Fields[INDCLCODE].IsNull  then
            msgbody:= ''
          else
            if  DataExports.Fields[INDEMAILBODY].IsNull then  msgbody:=msgsubj+#$D#$A+trim(DataExports.Fields[INDCLCODE].AsString)
             else            msgbody:= DataExports.Fields[INDEMAILBODY].AsString;

          pricereq:=self.generateQuantsRequestByWarehouseX(h);//*! quantsRequestbyWareHouse(h)
  //*******идентификатор экспорта************************************************************
          //для получения связанных данных из дополнительных таблиц
          pricereq:=StringReplace(pricereq,'##EXP_ID##',IntToStr(DataExports.Fields[0].AsInteger),[rfReplaceAll]);

  //******общий фильтр экспорта
          BlackListFilter := 'Item_Brand'; //для отключения пограничной фильтрации:  BlackListFilter := ''
          pricereq:=StringReplace(pricereq,'##ABROADFILTER##',BlackListFilter,[rfReplaceAll]);
          BlackListFilter := 'Line';
          pricereq:=StringReplace(pricereq,'##ABROADLINEFILTER##',BlackListFilter,[rfReplaceAll]);
  //*******для формирования прайса нужной ценовой группы клиента
          //**после рефакторинга будет добавлено для определения группы скидки по домену клиента
          //domainNo:=DataExports.Fields[INDDOMAIN].AsInteger; //домен клиента будет после рефакторинга
          //pricereq:=StringReplace(pricereq,'##CLIENT_DOMAIN##',IntToStr(domainNo),[rfReplaceAll]);
          clprgr := DataExports.Fields[INDPRGR].AsInteger; //домен ценовой группы
          pricereq := StringReplace(pricereq,'##CLPRGR##',IntToStr(clprgr),[rfReplaceAll]);//*!*
  //*******для формирования прайса в нужной валюте*******************************
          cy:=trim(DataExports.Fields[INDCYTAG].AsString);
            //pricereq:=StringReplace(pricereq,,cy,[rfReplaceAll])
          pricereq:=StringReplace(pricereq,'##CYCODE##',cy,[rfReplaceAll]);
  //*****************************************************************************

          cli:=DataExports.Fields[INDCLIENT].AsInteger;
          pricereq:=StringReplace(pricereq,'##CLIENT_ID##',IntToStr(Cli),[rfReplaceAll]);

          //*закомментировано: привязка осуществляется по складу экспорта
          //pricereq:=StringReplace(pricereq, '##DOMAIN##', IntToStr(domainNo), [rfReplaceAll]);

          //pricereq := StringReplace(pricereq, '##IDWH##', IntToStr(h), [rfReplaceAll]);  //перенесено вовнутрь

          if pos('#Price#',fldlist)>0 then
           begin
             pos0:=pos('*,',pricereq)+length('*,');;
             pos_:=pos('DscPrice',pricereq)+length('DscPrice');
             dscpricereq:=copy(pricereq,pos0, pos_-pos0);
             pricereq := StringReplace(pricereq,','+dscpricereq,' ',[]);
             dscpricereq:=StringReplace(dscpricereq,'DscPrice',' ',[]);//исключается имя поля ради того чтобы была возможность округлять   после увеличения на 2,5%
             fldlist:=StringReplace(fldlist,'#Price#',dscpricereq,[]);
           end;

          //ShowMessage(StringReplace(pricereq,'*',fldlist,[]));
          DataTemp.SQL.Text:=StringReplace(pricereq,'SELECT *','SELECT '+fldlist,[]);   //'*'-->'SELECT *' fix замена первой встречной звёздочки!
          //self.LogPrintln(Datatemp.SQL.Text);
          self.LogTimeStamp('Запрос прайса для клиента №'+IntToStr(Cli));
          try  ExpAction:= TAction.Create('Прайс-лист для клиента №'+IntToStr(Cli), self.Logger, False); //True перехват исключения
try       ExpAction.Start;  affect:=0;
              //DataTemp.ExecSQL;      //**!** эксперимент с типом курсора
              DataTemp.CursorLocation:=clUseClient;
              DataTemp.CursorType:=ctStatic;//*
              DataTemp.CommandTimeout := self.timeout;  
              DataTemp.Open;  DataTemp.DisableControls;

              if self.Terminated then break; //выход из цикла по сигналу завершения

              {subdir:='Files\';
              pricefile :=  trim(DataExports.Fields[INDFLNAME].AsString);
              share:= ExtractFileDrive(pricefile);
              if share =''   then   // если в имени файла ни диска ни шары
                pricefile := Concat(ExtractFilePath(paramstr(0)),subdir,pricefile) //дописываем папку по умолчанию
               else
                if copy(share,1,2)='\\' then //назначение на удалённом сервере
                 begin
                  share:=pricefile;
                  pricefile:=ChangeFilePath(pricefile,ExtractFilePath(paramstr(0)));
                 end
                 else share:='';
              }
              pricefile :=  trim(DataExports.Fields[INDFLNAME].AsString); //*
              self.LogTimeStamp('Сохранение в формате CSV...');
              ExpAction.timeStamp('Сохранение в файл');//впоследствии возможны другие форматы
              //if SaveToCSV
              if self.SavingToFile(DataTemp,pricefile, csvtitles) then
               begin
                self.LogTimeStamp('Сохранено');
                {
                if share<>'' then
                 if CopyFile(PANSIChar(pricefile),PANSIChar(share),true) then
                  self.LogTimeStamp('Скопировано в '+share)
                  else self.LogTimeStamp('Не удалось скопировать в '+share);
                }
                if sendflag then
                 begin
                  with EMailDesc do
                   begin
                     mailTo:=email;
                     //copies := ''
                     bcc :=sendcopies;
                     subj := msgsubj;
                     body := msgbody;
                     attouch := pricefile;
                     arch := attacharch;
                   end;

                  if self.Terminated then break;
                  ExpAction.timeStamp('Размещение файла в очереди отправки...');

                  if Pass2Mailer(DataExports.Fields[0].AsInteger,EmailDesc,self.ConnGeneral) then
                 //письма передаются напрямую в очередь отправки
                 // AddEmail2Queue(msgbody, email, msgsubj, pricefile, sendcopies, attacharch, SMTPQueue);  //  'кракозябры'
                   begin
                    self.LogTimeStamp('Письмо "'+msgsubj+'" добавлено в очередь отправки <'+EmailDesc.mailTo+'>');
                    ExpAction.timeStamp('Экспорт №'+IntToStr(DataExports.Fields[0].AsInteger)+' Письмо "'+msgsubj+'" добавлено в очередь отправки');
                   end;
                 end;
    //             //добавить экспорт в успешно завершенный
    //             explist:= sccexplist + trim(DataExports.Fields[0].AsString)+',';
                //!! заблокировать запись в новой версии

                ///чтобы не устраивать сатисфакцию старых экспортов
                ///для всех прочих эквивалентно  'UPDATE [EXPORTS] SET [Last_Export]=GetDate() WHERE [ID] = '
//                DataExports.Connection.Execute(StringReplace(loadTextDataByTag('SQLQueryMarkTime')+trim(DataExports.Fields[0].AsString),'EX.NEXT_EXPORT','[NEXT_EXPORT]',[rfIgnoreCase]),affect);
                DataExports.Connection.Execute(loadTextDataByTag('SQLQueryMarkTime')+trim(DataExports.Fields[0].AsString),affect);
               end
               else self.LogTimeStamp('Сохранение не выполнено');
          ExpAction.Resume(affect>0);
          ExpAction.Finish;
except on E: Exception do
            ExpAction.Catch(E);
end;
          finally ExpAction.Report;
            DataTemp.Close;
            if  self.Terminated then Action.Interrupt //передача исключения при
             else
  //             //добавить экспорт в успешно завершенный
              procexplist:= procexplist + trim(DataExports.Fields[0].AsString)+','; {
    в случае сбоя во время последующей операции экспорт будет заблокирован
    наряду с успешно выполненными
    в случае ошибки специфичной для данного экспорта
    это позволит продолжить выполнение остальных экспортов
    к заблокированному экспорту демон вернется уже после обновления данных
}
          end;
          DataExports.Next; //*!*при сбое в одном экспорте выполнение продолжается
        until DataExports.Eof;
        self.LogPrintStep('Файлы получены');
        sccPrc:=DataExports.Eof;  //сигнал завершения может прервать обработку
        if self.Terminated then Action.Interrupt; //timeStamp('# Получен сигнал завершения #');
        Action.Resume(sccPrc);
        Action.Finish;
except on E: Exception do
    Action.Catch(E);
end;
    finally  Action.Report;
      self.LogResultReport(sccPrc);
      FreeAndNil(DataTemp);
    end;


  end;

function TExportDaemon.generateQuantsRequestByWarehouseX(whXid:integer): string;
const PRICEREQUEST ='SQLPriceRequest';
begin
  RESULT := StringReplace(loadTextDataByTag(PRICEREQUEST), '##IDWH##', IntToStr(whXid), [rfReplaceAll]);
  if RESULT[length(trim(RESULT))]='=' then
    RESULT :=loadTextDataByTag(PRICEREQUEST) + IntToStr(-whXid);  exit; //фильтрация по Adds включена в ресурс
//  if whXid<0 then RESULT:=RESULT+' OR Adds = ' + IntToStr(-whXid)//*SIGN(ISNULL(Adds, -1))
//   else RESULT := RESULT+' AND Adds = 0'
end;

function TExportDaemon.getUnLoadDsc(datas: TADOQuery): TUnloadDescr;
begin
//    RESULT.id :=datas.Fields[0].AsInteger;
//    RESULT.server := trim(datas.Fields[3].AsString);
//    RESULT.db := trim(datas.Fields[4].AsString);
//    RESULT.firm := trim(datas.Fields[5].AsString);
//    RESULT.filename := trim(datas.Fields[6].AsString);;
  RESULT.active := False;
  if datas.FieldByName('UNLOADID').IsNull then exit;
  RESULT.active := datas.FieldByName('act').AsBoolean;

  RESULT.id := datas.FieldByName('UNLOADID').AsInteger;
  RESULT.idd := datas.FieldByName('idD').AsInteger;
  RESULT.whNo := datas.FieldByName('whNo').AsInteger;
  RESULT.priceGroupID:=datas.FieldByName('PrGrDomain').AsInteger;
  RESULT.CY := datas.FieldByName('CY').AsString;
  RESULT.filename := trim(datas.FieldByName('FileName').AsString);
  RESULT.linking := datas.FieldByName('Relink').AsBoolean;

  RESULT.filter := trim(datas.FieldByName('filter').AsString);
end;

function TExportDaemon.LoadDiscountsForClient(client_id: integer; ClientsQuery: TADOQuery): boolean;
const SQLCLIENTDISCOUNTS = 'SQLSELECT_client_discounts';
      SQLINSERTDISCOUNTS = 'SQLInsertDiscountsValues';
//        CODESKIND : array[0..1] of string = ('ТМ','ТОВЛИНИЯ');
//        TM = 0;
//        TL = 1;
var clientNAV: string;
    h, j: integer;
    DD: TDomainDescr;
    SQLreqDISC, SQLreqINS: string;
    DiscountsQuery: TADOQuery;
    sccCl: boolean;

    TemplList, ReplList :TStringList;

    Action: IAction;
begin
  RESULT:=False;
  Action := TAction.Create('Получение скидок для клиента №'+ IntToStr(client_id),self.Logger, false); //fix сбой недоступности одного из серверов NAV
  self.LogPrintStep('Получение данных по клиенту '+ IntToStr(client_id));
  try Action.Start;
try
  clientNAV := NavClientCode(client_id, ClientsQuery , h); //заполнение clientNAV и h=№осн склада
  DD:= DomainDescByID(h);
  Action.Stamp('['+trim(DD.firm)+'] '+clientNAV);
  //!! отследить случай когда WH не заполнен

        self.ConnNAVs := TADOConnection.Create(nil);

        self.Connect(2,DD.server, DD.db);
        try
          if self.apparole  then
            ConnNAVs.Execute(loadTextDataByTag('SQLMAGICWORD'){loadStrFromFile('SQLMAGICWORD.QRY')},cmdText,[eoExecuteNoRecords]);
        except
          self.apparole:=false;
        end;

        sqlreqdisc:=loadTextDataByTag(SQLCLIENTDISCOUNTS);  //loadStrFromFile(SQLCLIENTDISCOUNTSFILENAME);
        TemplList:=TStringList.Create; ReplList:=TStringList.Create;
        try
          TemplList.Add('##IDCLIENT##');ReplList.Add(IntToStr(client_id));
               TemplList.Add('##DATABASE##');ReplList.Add(DD.db);
                    TemplList.Add('##FIRM##');ReplList.Add(DD.firm);
                         TemplList.Add('##CLIENTNAV##');ReplList.Add(clientNAV);
          sqlreqdisc := MultyReplace(sqlreqdisc,TemplList,ReplList);
        finally
          FreeAndNil(TemplList);FreeAndNil(ReplList);
        end;
        //то же самое записано через списки
  //      sqlreqdisc:=StringReplace(sqlreqdisc,'##IDCLIENT##',IntToStr(client_id),[rfReplaceAll]);
  //      sqlreqdisc:=StringReplace(sqlreqdisc,'##DATABASE##', DD.db, [rfReplaceAll]);
  //      sqlreqdisc:=StringReplace(sqlreqdisc,'##FIRM##', DD.firm, [rfReplaceAll]);
  //      sqlreqdisc:=StringReplace(sqlreqdisc,'##CLIENTNAV##',clientNAV,[rfReplaceAll]);

        self.QNAV :=TADOQuery.Create(nil);
        self.QNAV.Connection := self.ConnNAVs;
        self.QNAV.SQL.Text :=  sqlreqdisc;

        self.QNAV.CursorLocation := clUseClient;
        self.QNAV.CursorType := ctStatic;
        self.QNAV.LockType := ltBatchOptimistic;

        self.LogAction('Запрос скидок для клиента '+ clientNAV); sccCl:=false;
        Action.timeStamp('Запрос скидок для клиента '+ clientNAV);
        try  Action.Note(self.QNAV.SQL.Text);
          self.QNAV.Open;
        except
          if self.apparole then  exit
          else  ConnNAVs.Execute(loadTextDataByTag('SQLMAGICWORD'));
          Action.timeStamp('...повторный запрос ');
          self.QNAV.Open;
        end;
        self.QNAV.Connection:=nil; //набор данных отключается от источника


        sqlreqins:=loadTextDataByTag(SQLINSERTDISCOUNTS);

        DiscountsQuery:= TADOQuery.Create(nil);
        DiscountsQuery.Connection := self.ConnGeneral;
  

        DiscountsQuery.SQL.Text := sqlreqins;

  //      DiscountsQuery.SQL.Text := 'INSERT INTO [DISCOUNTS]([ID_CLIENT],[ID_TYPE],[ItemsGroupCode], VAL, [Force]) VALUES (:p0,:p1,:p2,:p3,:p4)';
  //      DiscountsQuery.Prepared :=True;
        try
        //перестраховаться на случай отсутствия данных по скидкам клиента
        //:ID_CLIENT, :ID_TYPE,:ItemsGroupCode, :VAL, :Force
        Action.timeStamp('Запись нулевой скидки');

          DiscountsQuery.Parameters[0].Value :=  client_id;
            DiscountsQuery.Parameters[1].Value := 0;
                DiscountsQuery.Parameters[2].Value := '';      //!
                      DiscountsQuery.Parameters[3].Value := 0;
                            DiscountsQuery.Parameters[4].Value := 0;
          DiscountsQuery.Parameters[20].Value := ''; //! [Location Code]
          DiscountsQuery.Parameters[6].Value := '';//! [CustPriceGroupCode]
          DiscountsQuery.ExecSQL;
  //

  
        except on E: Exception do
         begin
            LogMessage(DiscountsQuery.SQL.text+'***'+e.Message+' -- Не удалось создать нулевую скидку для клиента :'
                            +ClientNAV,true);
            Raise;
         end;
        end;
        DiscountsQuery.Prepared :=False;

        //перенесено сюда; приводило к ошибке для клиента
        //не имеющего ни одной строки скидки
        RESULT:=self.QNAV.RecordCount = 0;
        if RESULT then //exit;
         begin
           Action.Finish;  //без финализации акции черевато (Raise GetLastError)
           exit; // - происходит завершение по логике ошибки
         end;

        Action.timeStamp('...добавление скидок клиента в таблицу...');
        DiscountsQuery.Prepared :=True;

        self.QNAV.First; //цикл  по записям полученным для клиента
        repeat


          for j:=0 to DiscountsQuery.Parameters.Count-1 do
            DiscountsQuery.Parameters[j].Value := self.QNAV.Fields[j].Value;


          DiscountsQuery.ExecSQL; //ShowMessage(IntToStr());
          self.QNAV.Next;
        until self.QNAV.Eof;
        sccCl:=true;
        Action.Resume(sccCl);
        Action.Finish;
except on E: Exception do
        Action.Catch(E);
end;
  finally   Action.Report;
      self.LogResultReport(sccCl);
      FreeAndNil(DiscountsQuery);
      //self.ConnNAVs.Connected := False;
      self.Disconnect(2);
      FreeAndNil(self.QNAV);
      FreeAndNil(self.ConnNAVs);
  end;
  RESULT:=sccCl;  //скидки клиента корректно загружены
end;

procedure TExportDaemon.LogAction(Msg: string);
begin

  inc(self.loglevel);
  self.LogPrintln(IntToStr(self.Handle)+':');
  Msg:=StringOfChar(#9,self.loglevel)+Msg;
  self.LogTimeStamp(' '); self.LogPrintln(Msg);
end;

procedure TExportDaemon.LogError(Msg: string);
begin
  self.LogMessage(Msg,true);
end;

procedure TExportDaemon.LogMessage(Msg: string; CR: boolean);
var log: text;
    indent: string;
    k: integer;
begin
//  Assign(log,'C:\Services\UniiversalExport\FatalErrors.log');
//  try
//    Append(log);
//    writeln(log, msg);
//  finally
//    CloseFile(log);
//  end;
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
  self.LogTimeStamp(' '); self.LogPrintln(Msg);
  dec(self.loglevel);
end;

procedure TExportDaemon.LogTimeStamp(Msg: string);
begin
  if Msg<>'' then Msg:=#9+' '+Msg;
  self.LogPrint(DateTimeToStr(Now())+Msg+#$D#$A);
end;

procedure TExportDaemon.processClientsDiscounts(QuExports: TADOQuery);
const
        INXFLDCLIENT = 0;
        //INXFLDWHID = 1;   //*!* убрать из запроса в SQLSELECTEXPORTCLIENTS.qry
var QuQu, QqClients, QqWH: TADOQuery;
      //h: byte;
      //whset: NUMBSET;
      wh: TDomainDescr;
      //WHQ: TADOQuery;
      id_Client: integer;
      sccDisc: boolean;
      Action: IAction;
      DscFailList: string;
begin
    self.LogAction('Выполняем обновление скидок по клиентам '); sccDisc:=false;
    Action:= TAction.Create('Обновление скидок по клиентам',self.Logger);
  //if QuExports.RecordCount <1 then exit; не надо
    QuQu:=TADOQuery.Create(nil);
    QuQu.Connection := self.ConnGeneral;


    try
    Action.Start;
try

          QuQu.SQL.Text :='DELETE FROM [DISCOUNTS] WHERE ID_Client IN (SELECT DISTINCT ID_Client FROM Exports WHERE Last_Export = 0)' ;  //
          QuQu.ExecSQL;   Action.timeStamp('Удалены устаревшие скидки для клиентов');

          QqClients:=TADOQuery.Create(nil);        //создание запроса..
          QqClients.Connection := self.ConnGeneral; //..для подключения к таблице клиентов

          QqWH:=TADOQuery.Create(nil);
          QqWH.Connection := self.ConnGeneral;

          DscFailList:='';
          Action.Stamp('Перебор клиентов...');
          QuExports.First;
          repeat
            if self.Terminated then Action.Interrupt;    //**
            
            if QuExports.Fields[INXFLDCLIENT].IsNull  then begin QuExports.Next; continue; end;     //0   Fields[1].IsNull
  
            id_Client:=QuExports.Fields[INXFLDCLIENT].AsInteger;
            //id_expwarehouse := QuExports.Fields[INXFLDWHID].AsInteger;
            if self.LoadDiscountsForClient(id_Client,QqClients) then sccDisc:=True  //хотя бы один запрос успешен
             else DscFailList:=' '+DscFailList+IntToStr(id_Client)+',';
            QuExports.Next;
          until QuExports.Eof;
          
          if DscFailList<>'' then
           begin
             SetLength(DscFailList,Length(DscFailList)-1); //','
             Action.Stamp('Для следующих клиентов не удалось получить актуальный список скидок:'+DscFailList);
             DscFailList:=' AND [ID_Client] IN ('+DscFailList+')';
             Action.Note(DscFailList);
             sccDisc:=requestByTag('SQLSETblocking',DscFailList,QuExports); //Q0?
           end
           else sccDisc:=true;   //
           
          Action.Resume(sccDisc);
          Action.Finish;
except on E: Exception do
        Action.Catch(E);
end;
    finally   Action.Report;

        self.LogResultReport(sccDisc);
        FreeAndNil(QuQu);
        FreeAndNil(QqClients);
        FreeAndNil(QqWH);
    end;
end;



procedure TExportDaemon.ReadConfigParameters;
begin
  self.Active := ReadExportActivity;
  self.Debug := ReadDebugMode;

  self.interval := ReadTimerInterval;
  self.timesleep := ReadSleepInterval;
  self.timeout := ReadQueryTimeout;
  self.filelog := ReadLogFileName;
  self.serverName := ReadServerName;
  self.DBName := ReadDatabaseName;// +';'+'Initial Catalog='+ReadInitCatalog
  self.deleteQuants := ReadRemoveOption;
  self.refreshLinks := ReadRefreshLinksOption;

  self.reconfig :=false;
end;

function TExportDaemon.reinitialization: boolean;
var Action: IAction;
begin
  RESULT:=false;
  if self.Terminated  then exit;

  if self.reconfig  then
   try Action:=TAction.Create('Реконфигурация',self.Logger); try     
     SectINI.Enter;
     if Assigned(iniFile)  then exit; //не дать переопределить объект инишки
   Action.Start;
     iniFile:=TiniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+FILENAMEINI);
     self.LogPrintStep('Реконфигурация...');
     self.ReadConfigParameters;
   Action.Finish;
   except
    on Err: Exception do  Action.Catch(Err); //exit;
   end;
   Action.Report;
   finally
     FreeAndNil(iniFile);
     SectINI.Leave;
     self.reconfig := false;   //??
   end
  else exit;
  RESULT:=true;
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
      SQLSELECT0 = 'SQLQuerySelectByZero';//; 'SQLSELECTbyINTERVAL'
      SQLSETblocking = 'SQLSETblocking';
var sccExp: boolean;
    scclist, SQLmarksccT: string;   ErrCode: DWord;
    Action: IAction;
begin
    Action:=TAction.Create('Проверка экспортов',self.Logger,false); //сбой в обработке экспортов не должен привести к останову
    try Action.Start;

    self.Connect(1,self.serverName,self.dbName);

try
        self.Q0 := TADOQuery.Create(nil);
        self.Q0.Connection := self.ConnGeneral;
        self.Q0.CommandTimeout := 0 ;

        self.Q0.Connection.Execute(loadTextDatabytag(SQLUPDATEEMAILS));  //e-mails по умолчанию

        self.LogAction('Проверка наличия экспортов'); sccExp:=false;
        Action.Stamp('Проверка наличия экспортов');
        scclist := ''; SQLmarksccT := '';
        if requestByTag(SQLMARK0,'', self.Q0)    then //если помечены страждущие экспорты
         begin if not(requestByTag(SQLSELECTEXPCL, '',self.Q0)) then exit end // получаем список..
                                                // клиент-склад требующих экспорта
        else exit;
        //в находятся Q0 загружены записи клиент-склад требующие экспорта

        self.LogPrintStep('Список актуальных экспортов получен'); Action.Stamp(IntToStr(Q0.RecordCount)+' активированных экспортов');

        if self.Terminated  then exit;

        self.processClientsDiscounts(self.Q0);//получение скидок по клиентам

        if self.Terminated  then exit;

        if requestByTag(SQLSELECT0,'', self.Q0) then  //записи могут быть блокированы                          //requestFromFile(SQLSELECT0FILENAME, self.Q0);
         begin
          self.generatePrices(self.Q0, scclist);  //создание прайс-листов для экспортов в Q0
          sccExp:= self.Q0.RecordCount < length(sccList);
         end;
        if self.Terminated then  Action.Interrupt;

//        requestByTag(SQLMARKT, self.Q0);   //время экспорта для каждого индивидуально
        //if scclist='' then exit; ни одного успешного экспорта  -- выход и так и так


        // sccExp:= self.Q0.RecordCount < length(sccList);true;//Exception если Q0 закрыт хотя бы 1 Экспорт завершен успешно;
        Action.Finish;
except on E: Exception do
        begin
          self.LogPrintln(E.Message);
          Action.Catch(E);
        end;
end;

      while scclist<>''  do
       try Action.Start; try
          

          scclist:=trim(scclist);
          if scclist[length(scclist)]=',' then
            SetLength(scclist,length(scclist)-1);
          SQLmarksccT :=  ' AND [ID] IN ('+scclist+')';
          //блокировка успешно выполненных экспортов
          requestByTag(SQLSETblocking,SQLmarksccT,self.Q0);
          scclist:=StringReplace(scclist,',',', ',[rfReplaceAll]);
          self.LogPrintStep('Итоговый список экспортов: [' +scclist+']');
          Action.Stamp('Итоговый список экспортов: [' +scclist+']');
          Action.Resume(scclist>'');
          Action.Finish; //scclist:=''; действие выполняется в finally
       except
            on E: Exception do
             try
              ErrCode:=GetLastError;
              self.LogTimeStamp(E.Message+#$D#$A+' Код ошибки:'+IntToStr(ErrCode));
              //if E.Message ='Ошибка подключения' then
//              repeat
//                if (self.Terminated) OR NOT(self.hammer)   then exit;
//                sleep(1000);
//                self.LogTimeStamp('Ожидание связи...');
//                self.Suspend;
//              until self.ConnGeneral.Connected;

               //Raise E;  //зачем выбрасывать ошибку?

             finally
                Action.Catch(E);
             end;

       end;
       finally
          scclist:='';
       end;

    finally
      self.LogResultReport(sccExp);
      Action.Report;
      DataQueryExtrication(self.Q0, true);  //self.Q0.Close;
      //self.QQ.Connection := self.ConnNAVs;
      self.Disconnect(1);
    end;
end;

procedure TExportDaemon.CheckQuantsUpdate;
const DELETEREQUEST='DELETE [##DATABASENAME##].[dbo].[##TABLENAME##]  WHERE [ID_WH] = ';   //ETK
      DELETEQUANTS = 'DELETE FROM QUANTS WHERE [ADDS] = ##PRICELISTNO## AND [ID_WH]=##IDWH## AND [PriceGroupDomain]=##DOMAIN##  AND [CY]=''##PRICELISTCY##'' ' ;//
      RESETBLOCKING = 'SQLRESETblocking';
      BAND = 1.000;//0.666;
      BANDFILTER = '[LAST_Export] = 0  OR DATEDIFF(mi,GETDATE(), ISNULL([NEXT_EXPORT],GETDATE()))	< [INTERVAL]*';//##BAND##
      CYFILTER =   'CY = ';
      PRICEGROUPFILTER = ' (select COALESCE(cl.PriceGroup, cl.DOM) from Clients cl where cl.ID = [ID_Client]) = ';

var XWHouse:TUnloadDescr;   //расширение склада - со спецификацией ценовой группы и валюты
    h: integer;
    Reader: TNAVCSVReader;
    sqlstr: string;
    k: integer;
    sccQ: boolean;
    //ff: text;  ext: string;
    indexFF: integer;
    quantsrename: string;

    PrGr: integer;
    TemplList,ReplList: TStringList;
    where: string;
    Action, FileAction: IAction;
begin
//sleep(15000);
   
  self.LogPrintStep('Проверка наличия файлов остатков');
try  Action:=TAction.Create('Проверка наличия файлов остатков',self.Logger); try
  Action.Start;
  self.Connect(1,self.serverName,self.dbName);    //подключение к серверу из ini

  indexFF:=0;//  indexQNT := self.QuantsFieldsList.IndexOf('QNT');


    //получение списка {складов} по основному подключению
    //!получаем список активных выгрузок
    //!
    //if not selectWarehouse(self.Q0) then exit;
    if not self.selectWarehouseXs(self.Q0) then exit; //выход если не получили

    //запрос на утверждение обновления остатков - sqlstr не применяется??
    sqlstr:=loadTextDataByTag('QuantsUpDate');  //loadStrFromFile('.qry');
    sqlstr:=substitutionDBTblByTemplate(sqlstr,self.dbName,self.QuantsTableName);

    self.QQ:=TADOQuery.Create(nil);
    self.QQ.Connection := self.ConnGeneral;
    QQ.CommandTimeout := 0;
    Reader := TNAVCSVReader.Create;
    self.LogAction('Цикл прохода по складам');  Action.timeStamp('Цикл прохода по складам');
    self.Q0.First;
    //цикл по складам
    for h := 0 to Q0.RecordCount  - 1 do
     begin
       XWHouse:=getUnLoadDsc(self.Q0); //получениек настроек выгрузки --//описание настроек склада
       if not XWHouse.active then continue; //!* проверка активности выгрузки

       if XWHouse.linking then //перелинковка только для определенных выгрузок
        self.ItemLinking(XWHouse, FileExists(XWHouse.filename));//
       self.LogPrintStep('проверка завершения предыдущей транзакции...');
       Action.Stamp('проверка завершения предыдущей транзакции...');
          Self.QQ.SQL.Text :=   //удаление следов предыдущей транзакции
           substitutionDBTblByTemplate(DELETEREQUEST,self.DBName,self.QuantsTableName)
            +IntToStr(-abs(XWHouse.whNo));//(-XWHouse.id); теперь удаляем по номеру склада
          if QQ.ExecSQL>0 then self.LogPrintStep('.. следы удалены')
          else self.LogPrintStep('.. следов не обнаружено');

       if FileExists(XWHouse.filename)  then  //если найден файл универсального экспорта
        try
          self.LogAction('Обработка файла "'+XWHouse.filename+'"...');
          FileAction:=TAction.Create('Обработка файла "'+XWHouse.filename+'"',self.Logger,false); //timeStamp('Обработка файла "'+XWHouse.filename+'"...');
          try FileAction.Start;
            Reader.Open(XWHouse.filename);
              //TRANSACTION BEGIN
                     //****except TRANSACTION ROLLBACK
                      //настройка параметров вставки
                      //PrGr:=2; //1;для нади евлаш //*Import* домен ценовой группы файла для склада
                      PrGr:=XWHouse.priceGroupID;//! считанное значение ценовой группы
                      if PrGr = 0 then PrGr:=XWHouse.idd; //для выбора по фильтру склад/ценоваяГруппа/валюта

                      if XWHouse.filter<>'' then
                        indexFF := self.QuantsFieldsList.IndexOf(XWHouse.filter)
                       else indexFF:=0;

                      Reader.setPrefix(IntToStr(-XWHouse.whNo)+';');//!id уже указывает на номер выгрузки!  // вариант с префиксом: +IntToStr(PrGr)+';'
                      SetInsParameters(QQ, self.DBName, self.QuantsTableName, self.QuantsFieldsList);
                    //*****
                      self.LogAction('Цикл обновления таблицы остатков'); sccQ:=false;
                      if Reader.FileSize > 0 then
                       repeat
if self.Terminated  then exit;
                        Reader.ReturnLine;
                        //?if Reader.Eof then break;

                        //теперь НЕ пропускаем запись с нулевым остатком
                        //***if StrToInt('0'+Reader.getTypedFields (indexQNT,0))=0 then continue;
                        if (indexFF<=0) OR Reader.isConsiderableField(indexFF,self.QuantsFieldsTypeCodes[indexFF]) then
                          SetInsValues(QQ, Reader, self.QuantsFieldsTypeCodes);
                       until Reader.Eof;

                      self.LogResultReport(Reader.Eof);
                      //Reader.Close; //!!!!! два раза?!

                      self.LogPrintStep('удаление устаревших остатков...');
                      {
                      Self.QQ.SQL.Text :=   //удаление устаревших остатков
                       substitutionDBTblByTemplate(DELETEREQUEST,self.DBName,self.QuantsTableName)
                        +IntToStr(WHouse.id);
                      }
                      //*!Import*
                      SQLStr:= DELETEQUANTS;//loadTextDataByTag('SQLDeleteQuants');// //*!  backup
                      TemplList := TStringList.Create; ReplList := TStringList.Create;
                      try
                        TemplList.Add('##IDWH##');ReplList.Add(IntToStr(XWHouse.whNo));//*!
                        TemplList.Add('##PRICELISTNO##');ReplList.Add(IntToStr(XWHouse.id));
                        TemplList.Add('##DOMAIN##');ReplList.Add(IntToStr(PrGr));
                        TemplList.Add('##PRICELISTCY##');ReplList.Add(XWHouse.CY);  //!*введено в действие
                        //!! ERROR !! TemplList.Add('##DOMAIN##'); ReplList.Add(IntToStr(XWHouse.idd)); //для автоматического заполнения привязок в Quants
                        self.QQ.SQL.Text:=MultyReplace(SQLstr,TemplList,ReplList);
                        ;
                      finally
                        FreeAndNil(TemplList); FreeAndNil(ReplList);
                      end;
                       FileAction.Note(self.QQ.SQL.Text);  //***StringReplace(DELETEREQUEST, '[ETK].[dbo]',WHouse.db,[]);
                      self.QQ.ExecSQL;

                      self.LogPrintStep('утвердить изменения...');

                      sqlstr:=loadTextDataByTag('SQLQuantsAcknowlege');  //вариант...
                      //sqlstr := StringReplace(sqlstr,'##DOMAIN##',IntToStr(XWHouse.idd),[rfReplaceAll,rfIgnoreCase]); //для автоматического заполнения привязок в Quants//*
                      Case PrGr of
                        0: sqlstr:=StringReplace(sqlstr,'##PRCGRP##','NULL',[rfReplaceAll]);//...без префикса
                        else sqlstr:=StringReplace(sqlstr,'##PRCGRP##',IntToStr(PrGr),[rfReplaceAll]);//...без префикса
                      End;

                      sqlstr:=StringReplace(sqlstr,'##UNLOADID##',IntToStr(XWHouse.id),[rfReplaceAll]); //!* добавлено пометка номера выгрузки в поле Adds
                      sqlstr:=StringReplace(sqlstr,'##DOMAIN##',IntToStr(XWHouse.idd),[rfReplaceAll]); //!* добавлено пометка номера домена для загрузки привязок "на лету"
                      Self.QQ.SQL.Text := StringReplace(sqlstr, '##WH_ID##', IntToStr(XWHouse.whNo),[rfReplaceAll]);   //  .id
                      //ShowMessage(QQ.SQL.Text);
                      FileAction.Note(self.QQ.SQL.Text);
                      self.QQ.ExecSQL;   //утвердить обновление остатков
                      //переименование исходного файла
                      //Assign(ff,WHouse.filename);
                      //ext:=ExtractFileExt(WHouse.filename); //if ext='' then ext:='.';
                      //Rename(ff,StringReplace(WHouse.filename, ext,'_'+ext,[]));

                      //!после разбиения таблицы Warehouses и добавления валюты и ценовой группы добавить фильтр по валюте
                      where := ' AND '+ PRICEGROUPFILTER + IntToStr(PrGr) //;
                      + ' AND (' + BANDFILTER + FloatToStr(BAND)
                      //+ ') AND (' + CYFILTER + '''' +CURRENCIES[j]      +'''' не забвая про кавычку
                      + ') AND (' + CYFILTER + XWHouse.CY
                      //+ ') AND (' + PRICEGROUPFILTER + IntToStr(i) + ')';
                      + ') AND (' + PRICEGROUPFILTER + IntToStr(XWHouse.priceGroupID) + ')';
                      where:=  concat( #$D#$A ,' ',where );

                      where := ' OR ([blocked]=1 AND [ID_WH] ='+IntToStr(-XWhouse.id)+')';//*! после отладки перекомпилировать в ресурс

                      requestByTag(RESETblocking,IntToStr(XWHouse.whNo)+where,self.QQ);//.id

                      //вариант запроса от которого отказались
                      //станет актуальным после перегрузки requestByTag() с возможностью внутренней подстановки по шаблону
//                      TemplList := TStringList.Create; ReplList := TStringList.Create;
//                      try //!разблокировка экспортов связанных с обновлением
//                        //QQ.Connection.Execute(loadTextDataByTag(RESETblocking)+IntToStr(WHouse.id));
//                        //не работает с новым запросом requestByTag(RESETblocking,IntToStr(WHouse.id),self.QQ);
//                        TemplList.Add('##BAND##');ReplList.Add(FloatToStr(BAND));
//                        TemplList.Add('AND CY = ##CYCODE##');ReplList.Add('');
//                        SQLstr := MultyReplace(loadTextDataByTag(RESETBLOCKING),TemplList,ReplList);
//                        self.ConnGeneral.Execute(SQLstr);
//                      finally
//                        FreeAndNil(TemplList); FreeAndNil(ReplList);
//                      end;
                      sccQ:=True;  //для того чтобы не удалить необраб.
                      FileAction.Resume(sccQ);
                      FileAction.Finish;
          except on E: Exception do
            begin 
              self.LogMessage(E.Message, true);
              FileAction.Catch(E);
            end;
          end;
  //TRANSACTION COMMIT
          //self.Cmd.Prepared := false;
        finally
          FileAction.Report;
          //self.Disconnect(2);
          Reader.Close;
          if sccQ  then
          try FileAction.Start; FileAction.timeStamp('удаление обработанного файла...');
            self.LogPrintStep('удаление обработанного файла...');
            if self.deleteQuants then    DeleteFile(XWHouse.filename)
            else
             begin
              quantsrename := ChangeFileExt(XWHouse.filename,
                                        '_'+ExtractFileExt(XWHouse.filename));
              if FileExists(quantsrename) then DeleteFile(quantsrename);
              FileAction.Resume(RenameFile(XWHouse.filename, quantsrename));
             end;
            FileAction.Finish; 
          except
            on Ef: Exception do
             begin
              FileAction.Catch(Ef);
              self.LogMessage(Ef.Message, true)
             end;
          end;
          FileAction.Report;
          self.LogResultReport(not(FileExists(XWHouse.filename)));
        end
        else self.LogPrintln('Файл "'+XWHouse.filename+'" не найден');
        if self.Terminated  then exit;

        Q0.Next;
     end;
   Action.Finish;
except
   on E: Exception do
    begin
      self.LogError(E.Message);
      Action.Catch(E);
    end;    
end;     
   //self.LogMessage('Завершено успешно! ', true);
finally
   Action.Report;  //Report только в блоке finally если имеется логический выход из процедуры внутри действия 
   self.LogResultReport(sccQ);// h=Q0.RecordCount
   FreeAndNil(QQ);    //разрушаем явно созданный компонент запроса остатков
   DataQueryExtrication(Q0, true); //освобождение компонента запроса складов
   self.Disconnect(1);    //отсоединение от базы
end;
  //if True then
end;
procedure TExportDaemon.QuantsUpdate;
const
      CC = 4; //$3
      CURRENCIES: array[1..CC] of string[3] = ('EUR','RUR','USD','BYR');    //$$$
      DD = 2;
      RESETBLOCKING = 'SQLRESETblocking';
      BAND = 0.666;
      BANDFILTER = '[LAST_Export] = 0  OR DATEDIFF(mi,GETDATE(), ISNULL([NEXT_EXPORT],GETDATE()))	< [INTERVAL]*';//##BAND##
      CYFILTER =   'CY = ';
      PRICEGROUPFILTER = ' (select COALESCE(cl.PriceGroup, cl.DOM) from Clients cl where cl.ID = [ID_Client]) = ';
      BRANDSFILTER = ' AND [Item_Brand] NOT IN ';
var h, i, j: byte; //№№ склад, домен(ценовая группа), валюта
    SQLstr: string;
    Templ, Repl: TStringList;
    where: string; Qbl, Qwh: TADOQuery;
    blacklist, filter: string;
    Action: IAction;
begin
  SQLstr:=loadTextDataByTag('SQLDELETEQuantsINSERTFROMSELECT');

  blacklist:=self.Import.getSingleValueByRequest('SELECT Blacklist FROM Blacklists WHERE ID='+IntToStr(self.Import.domain)
                                                 ,self.Import.serverName, self.Import.DBName);
  if blacklist<>'' then
   begin
    if pos('''',blacklist)=0 then
     begin
      blacklist:=''''+trim(blacklist)+'''';
      blacklist:= StringReplace(blacklist,' ','',[rfReplaceAll]);
      blacklist:= StringReplace(blacklist,',',''''+','+'''',[rfReplaceAll]);
     end;
    if (length(blacklist)-length(StringReplace(blacklist,'''','',[rfReplaceAll])))div 2 <> 0 then
     blacklist:='';                 
   end;

  Templ:= TStringList.Create;
  Repl:= TStringList.Create;

  self.Connect(1,self.serverName,self.DBName);
  self.LogTimeStamp('Заполнение Quants из внутренних таблиц...');
  Qwh := TADOQuery.Create(nil);
try  Action:=TAction.Create('Заполнение Quants из внутренних таблиц...',self.Logger);
try Action.Start;
    self.ConnGeneral.CommandTimeout:=300;    //время ожидания параллельного процесса

    if Self.Import.getWarehouses(Qwh) then
    repeat
      h:=Qwh.Fields[0].AsInteger;
      for i := 1 to DD do
       if i in self.Import.domainsSet then//для ценовой группы из множества доменов
        for j := 1 to CC do
         begin           //в евро тоже грузим if (i=2)AND(CURRENCIES[j]='EUR') then continue;
           if self.Terminated then Action.Interrupt;

           if (i<>self.Import.domain) AND (blacklist<>'') then // для неосновных ценовых групп домена...
             filter:=concat(SQLStr,' ',BRANDSFILTER,'(',blacklist,')') //фильтрация по брэндам
            else filter := ''; 
             

           Action.timeStamp(Qwh.FieldByName('Code').AsString+' '
                            +'PriceGroup='+IntToStr(i)+'  '+'CY='+CURRENCIES[j]);

           self.LogTimeStamp(Qwh.FieldByName('Code').AsString+' '
                            +'PriceGroup='+IntToStr(i)+'  '+'CY='+CURRENCIES[j]);
           self.ConnGeneral.BeginTrans; //Execute('BEGIN TRAN');
           try
            Templ.Add('##DOMAIN##'); Repl.Add(IntToStr(self.Import.domain));
            Templ.Add('##IDWH##');Repl.Add(IntToStr(h));//self.Import.whNo
            Templ.Add('##PRCGRP##');Repl.Add(IntToStr(i));
            Templ.Add('##CYCODE##');Repl.Add(CURRENCIES[j]);
            self.ConnGeneral.Execute(MultyReplace(SQLstr+filter,Templ,Repl));
            Templ.Clear; Repl.Clear;


            //снять блокировку
            where := ' AND (' + BANDFILTER + FloatToStr(BAND)
                  + ') AND (' + CYFILTER +''''+ CURRENCIES[j]+''''
                  + ') AND (' + PRICEGROUPFILTER + IntToStr(i) + ')';
            where:=  concat( #$D#$A ,' ',where );
            Qbl:=TADOQuery.Create(nil);
            try
              Qbl.Connection := self.ConnGeneral;
              requestbyTag(RESETBLOCKING,IntToStr(h)+where, Qbl);//self.Import.whNo
            finally
              FreeAndNil(Qbl);
            end;

            self.ConnGeneral.CommitTrans; //Execute('COMMIT TRAN');
            self.LogTimeStamp('...OK');
            Action.timeStamp('...OK');
           except
            on E: Exception do
             begin
              self.ConnGeneral.RollbackTrans;// Execute('ROLLBACK TRAN');
              self.LogError(e.Message);

              if self.Terminated then Action.Interrupt else Action.Catch(E);
             end;
           end;
           ;
         end;
      Qwh.Next;
    until Qwh.Eof;
      self.Import.fresh:=false;
     Action.Resume(Qwh.Eof);
     Action.Finish; 
except on E: Exception do  Action.Catch(E);
end;
finally Action.Report;
  FreeAndNil(Templ); FreeAndNil(Repl);
  FreeAndNil(Qwh);
  self.Disconnect(1);
end;

end;
procedure TExportDaemon.Run;
begin
  self.reinitialization;
  self.LogPrintln('');
  self.LogTimeStamp('Демон пронулся');
  self.CheckQuantsUpdate;  //проверка наличия файлов остатков

  if self.Terminated  then exit;
  self.reinitialization;

  self.CheckExportsUpdate; //проверка необходимости выполнить экспорт
  self.LogTimeStamp('Демон заснул');
  self.LogPrintln('');
end;

//метод сохранения в файл filename данных из dataset с заголовком полей title
//при установке признака extformat автоопределение формата файла
function TExportDaemon.SavingToFile(dataset: TADOQuery; var filename, title: string;  extformat: boolean): boolean;
var Action: IAction;
    share,subdir: string;
begin
  RESULT:=False;
  Action:=TAction.Create('Сохранение в файл '+ filename,self.Logger, FALSE);//true
  try  Action.Start;
   try
    //---------------------
    subdir:='Files\';
    FilePathLocalization(filename,share,subdir);

    if SaveToFile(dataset,filename,title,extformat) then
     begin
      if share<>'' then
       begin
        if self.Terminated then Action.Interrupt;        
        Action.timeStamp('Копирование в '+share+' ...');
        if CopyFile(PANSIChar(filename),PANSIChar(share),false) then
          RESULT:=True
         else
          Action.Stamp('Сбой копирования: '+SysErrorMessage(GetLastError));
       end
       else RESULT:=True; //файл сохранён - чего же ещё желать
     end;
     Action.Resume(RESULT);
    //---------------------
    Action.Finish;
   except on E: Exception do
    Action.Catch(E);
   end;
  finally
    Action.Report;
  end;
end;

//procedure QuantsDaemon.SetInsParameters(Q: TADOQuery; dbName, tblName: string);
//begin
//
//end;

function TExportDaemon.selectWarehouseXs(var Q: TADOQuery): boolean;
  const REQUESTEXTWAREHOSES =
 'SELECT Whs.ID as whNo, Whs.Domain as idD,PrL.ID as UNLOADID,Prl.Filename as FileName, Prl.PriceGroup as PrGrDomain, Prl.CyCode as CY, PrL.Active as act,Whs.Linking as ReLink,ISNULL(Prl.Filter,'''') as filter'
 +' FROM [Warehouses] Whs LEFT JOIN [PriceLists] PrL ON Whs.ID = PrL.WarehouseNo WHERE PrL.Active=1';//REQUESTWAREHOSES = 'SELECT * FROM [Warehouses]';
begin
  RESULT:=false;
  try
    self.LogAction('получение списка складов');
    RESULT:=DatasetByRequest(Q,self.ConnGeneral,REQUESTEXTWAREHOSES);
  finally
    self.LogResultReport(RESULT);
  end;
end;



procedure TExportDaemon.Init;
const REQUESTFIELDSLIST = 'SELECT [FieldName],[TypeCode] FROM [UNIFIELDS] WHERE [POS] IS NOT NULL ORDER BY [POS]';
var k: integer;
    ff: text;
    Action: IAction;
begin
    Action:=TAction.Create('Инициализация демона', self.Logger);
try
      Action.Start;
      Action.Stamp('Чтение файла конфигурации');
     //* безопасное чтение инишки
      SectINI.Enter;
      try
        iniFile:=TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+FILENAMEINI);
     // Showmessage(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))));
        ReadConfigParameters;
      finally
       FreeAndNil(iniFile);
       SectINI.Leave;
      end;
     //*
  //  self.interval := ReadTimerInterval;
  //  self.filelog := ReadLogFileName;
  //  self.serverName := ReadServerName;
  //  self.DBName := ReadDatabaseName;// +';'+'Initial Catalog='+ReadInitCatalog
  //  self.deleteQuants := ReadRemoveOption;
  //  self.refreshLinks := ReadRefreshLinksOption;

    Action.Stamp('Создание файла лога');
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
    Action.Stamp('Инициализация вектора полей универсального экспорта');
      self.Connect(1, self.serverName,self.DBName);


    self.Q0.SQL.Text := REQUESTFIELDSLIST;
    self.QuantsFieldsList.Clear;
    self.apparole := True;
    try
      Action.Note(self.Q0.SQL.Text);  //self.Q0.ExecSQL; бессмысленно
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
    end;
  except on E: Exception do begin self.LogMessage(E.Message, true); Raise; end;
  end;
    self.Live := true;
    Action.Resume(self.QuantsFieldsList.Count>0);
    Action.Finish;
except on E: Exception do
    Action.Catch(E);
end;
    Action.Report;
end;

procedure TExportDaemon.ItemLinking(XWH: TUnloadDescr; rewritemode: boolean);
const DELETEREQUEST = 'DELETE FROM [Products] WHERE [WH_ID]= ';                 //   [UEXPORT].[dbo].
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
    DD: TDomainDescr;
begin
//  filecsv:=IncludeTrailingBackslash(ExtractFilePath(WH.filename))+'ProductsLinksWH#'+IntToStr(WH.id)+'.csv';
  filecsv:=IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)))+'NAV_Links\'+'ProductsLinksWH#'+IntToStr(XWH.whNo)+'.csv';
  //rewritemode:=self.refreshLinks AND (rewritemode OR self.deleteQuants);
  SetLength(LinksFieldsTypeCodes, 7);
  LinksFieldsTypeCodes[0]:=0;
   LinksFieldsTypeCodes[1]:=20;
    LinksFieldsTypeCodes[2]:=20;
     LinksFieldsTypeCodes[3]:=20;
      LinksFieldsTypeCodes[4]:=0;
       LinksFieldsTypeCodes[5]:=0;
        LinksFieldsTypeCodes[6]:=0;
  QL:=TADOQuery.Create(nil);
  //временный файл формируется в следующих случаях
  // -1- Когда он отсутствует и выставлен флаг рефреша привязок
  // -2- Когда выставлен признак режима перезаписи (штатный режим) и флаг рефреша привязок
  //В случае когда временный файл существует и выставлен признак рефреша привязок
  //то действие выполняется на базе существующего файла
  //в прочих случаях процедура не выполняет действий
  //if () then  exit;
  sccLinking:=false;
  if self.refreshLinks AND (NOT(FileExists(filecsv)) OR rewritemode)  then
  try
    DD:=DomainDescByID(XWH.idd);
    self.ConnNAVs := TADOConnection.Create(nil);
    self.Connect(2,DD.server, DD.db);
    try
      if self.apparole  then
        ConnNAVs.Execute(loadTextDataByTag('SQLMAGICWORD'),cmdText,[eoExecuteNoRecords]);
    except
      self.apparole:=false;
    end;


    QL.Connection:=self.ConnNAVs;
    //self.Connect(2,WH.server, WH.db);

    sqlstr:=loadTextDataByTag(SQLSELLINKS);
    sqlstr:=Stringreplace(sqlstr, '##DATABASE##', DD.db, [rfReplaceAll]);
    sqlstr:=Stringreplace(sqlstr, '##FIRM##', DD.firm, [rfReplaceAll]);
    //задействован постфикс sqlstr:=StringReplace(sqlstr,'##WHID##',IntToStr(WH.id),[rfReplaceAll]);
    QL.SQL.Text:=sqlstr;
    QL.CursorType := ctStatic;
    QL.LockType:=ltReadOnly;  //*
    QL.CursorLocation := clUseClient; //*
    QL.CommandTimeout := 0;//self.interval div 2;
    QL.DisableControls;
    self.LogAction('Запрос привязок товаров по складу ...'+IntToStr(XWH.whNo));

    try
try
        QL.Open;
        self.LogTimeStamp('Сохранение во временный файл '+filecsv);
        if  QL.RecordCount>0 then
          sccLinking:=SaveToCSV(QL,filecsv,'');   //!!! в последствии сделать QuerySelect->QueryInsert
        //True;
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

  if not(self.refreshLinks AND sccLinking) then exit;

  if (FileExists(filecsv)) then
  try
    QL.Connection:=self.ConnGeneral;
    QL.Connection.Execute(DELETEREQUEST+IntToStr(XWH.whNo));
    LinksFieldsList:=TStringList.Create;
    LinksFieldsList.Text :=LINKSFIELDS;
    //sqlstr:='...';
    SetInsParameters(QL,self.DBName, TABLENAME, LinksFieldsList);
    RR:=TNAVCSVReader.Create;
    try
      RR.Open(filecsv);
      self.LogAction('Заполнение таблицы Products...'); sccLinking:=false;
      RR.setPostFix(';'+IntToStr(XWH.whNo));
      if RR.FileSize > 0 then
       repeat
        RR.ReturnLine;
        SetInsValues(QL, RR, LinksFieldsTypeCodes);
       until RR.Eof
      else exit;
      sccLinking:=true;
    finally
      self.LogResultReport(sccLinking);
      RR.Close;
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

function TNAVCSVReader.isConsiderableField(index, typecode: integer): boolean;
var Code: integer; value: Extended;
begin
  RESULT:=index<0; //для неопределённого фильтра результат положительный
  //выход результат если неликвидный индекс либо пустое поле
  if Self.FieldsCount<=index then exit;
  if self.Fields[index]='' then exit;

  if typecode=0 then //для целочисленного значения значащий результат не равен нулю
    RESULT:=StrToInt(self.getTypedFields(index,0))>0
   else   //для строкового значения результат умещается в длину поля
    if typecode>0 then RESULT:=(0<length(self.Fields[index]))AND(length(self.Fields[index])<=typecode)
     else
     begin
      val(self.Fields[index],value,Code); 
      RESULT:=Code=0; //для значения с плавающей точкой значащий результат указан в верном формате
     end; 
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
    strval:=stringReplace(strval,#$0A,'',[rfReplaceAll]);
    RESULT:=stringReplace(strval,#$FF,'',[rfReplaceAll]);  //fix я-косяк
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

{ TBridge }

procedure TBridge.connect;
begin
 //self.RightSupport.ConnectionString :=   self.RightSupport.ConnectionString; + 'Packet Size=8192;'
  self.LeftSupport.Connected := true;
  (*self.RightSupport0.Connected := true;*)
  try
    self.LeftSupport.Execute(loadTextDataByTag('SQLMAGICWORD'));
  except

  end;
end;

constructor TBridge.Create(SrcBank, DstBank: TBank; Dimension: integer;
  tt: TINTARRAY);
begin
  inherited Create;
  LeftSupport := TADOConnection.Create(nil);
  RightSupport:= TADOConnection.Create(nil);

  LeftSupport.ConnectionString :=generateConnStr(SrcBank.b, SrcBank.servername, SrcBank.dbname);
  RightSupport.ConnectionString :=generateConnStr(DstBank.b, DstBank.servername, DstBank.dbname);

  LeftSupport.LoginPrompt := False;
  RightSupport.LoginPrompt := False;

  LeftSupport.CommandTimeout :=300;
  RightSupport.CommandTimeout :=300;

  self.Dim := length(tt);

  self.types := tt;


  SetLength(self.map0, self.Dim);
  SetLength(self.map, self.Dim);
  self.map0 := SrcBank.map;
  self.map := DstBank.map;

  self.hq := SrcBank.place;
  self.target := DstBank.place;
  self.concentration:=0;

  self.BridgeTooFar := false;
  //dbExpress
(*
    RightSupport0 := TSQLConnection.Create(nil);


    RightSupport0.ConnectionName := 'MSSQLConnection';
    RightSupport0.DriverName := 'MSSQL';
    RightSupport0.LoginPrompt := False;
    RightSupport0.GetDriverFunc := 'getSQLDriverMSSQL';
    RightSupport0.LibraryName := 'dbxmss30.dll';
    RightSupport0.VendorLib := 'oledb';
    with RightSupport0.Params do
    begin
      Values['HostName'] := DstBank.servername;   //    HostName
      Values['DataBase'] := DstBank.dbname;
      Values['OS Authentication'] := 'True';
      Values['SchemaOverride'] := 'sa.dbo';
  //    Values[''] := '';
    end;
*)
  self.Logger := UniversalLogger;
end;

procedure TBridge.Cross;
const PAUSE = 1000;  CYCLES = INTEGER($100)-1;   //= 1000;
var i,j: integer;(* Provider : TDataSetProvider; DataSet : TClientDataSet;*)
    t0, dt: TDateTime;

    Action : IAction;
begin

try    Action := TAction.Create('Операция по перегрузке данных', self.Logger, True);
  try  Action.Start;
      self.connect;
      self.QDepart := TADOQuery.Create(nil);
      self.QDepart.Connection := self.LeftSupport;

      //безболезненный запрос
      //не задействовано self.QDepart.CursorLocation := clUseServer;
      self.QDepart.CursorType := ctStatic;
      self.QDepart.LockType := ltBatchOptimistic;//ltReadOnly
      self.QDepart.CursorLocation := clUseClient;
      self.QDepart.DisableControls;

      self.QArrivee := TADOTable.Create(nil);
      self.QArrivee.Connection := self.RightSupport;
      self.QArrivee.CursorType := ctStatic;
      if Self.depth then
       begin
        self.QArrivee.LockType := ltBatchOptimistic;//;   //self.QArrivee.MarshalOptions:=moMarshalModifiedOnly;
        self.QArrivee.CursorLocation := clUseClient;    //*
       end
       else
       begin
        self.QArrivee.LockType := ltOptimistic;
        self.QArrivee.CursorLocation := clUseServer;
       end; 
      self.QArrivee.DisableControls;
    (*

    *)
      self.QDepart.SQL.Text := StringReplace(self.SQLStatement, '##Firm##',self.hq,[rfReplaceAll, rfIgnoreCase ]) ;  //
      self.QArrivee.TableName := self.target;
      self.QArrivee.TableDirect:=true;



      
      if self.filelog<>'' then PrintLog(self.filelog,DateTimeToStr(Now())+#9+ ' Концентрация... ');
    try Action.timeStamp('Концентрация...'); Action.Note(QDepart.SQL.Text);
        self.QDepart.CommandTimeout:=300;
        self.QDepart.Open;     self.QDepart.DisableControls;

        self.QDepart.Connection := nil; //отключённый набор данных в натуре
        self.RightSupport.Connected := False;

        self.QArrivee.Open; self.QArrivee.DisableControls;
        //*self.QArrivee.Connection := nil;
      (*

      *)
      (* *)
        self.QArrivee.Last;

        Action.timeStamp('Форсирование...');
      if self.filelog<>'' then PrintLog(self.filelog,DateTimeToStr(Now())+#9+ ' Форсирование');
        self.QDepart.First; i:=0; t0:=Now; dt := FloatToDateTime(0.00001/1000*(10*PAUSE));
        repeat
          //пауза из расчёта режима работы 10/1
          if i AND CYCLES = 0 then
           if Now>t0+dt then
            begin
              sleep(PAUSE);
              if NOT(self.IRQ^) then break;

              t0 := Now;
            end;

          self.QArrivee.Append;
          for j := 0 to self.Dim-1 do
            self.QArrivee.Fields[map[j]].Value:=self.TypedField(self.QDepart.Fields[map0[j]].AsString, self.types[j]);

          if not Self.depth then
            self.QArrivee.Post;

          inc(i);
          self.QDepart.Next;
        until self.QDepart.Eof;

        if Self.depth then
          self.QArrivee.UpdateBatch();

      //     begin
      //      //if map[j]<0 then continue; //зарезервировано для фильтрации select'а
      //                                                        {self.map[]}
      //     end;
      Action.Note(IntToStr(i)+'/'+INtToStr(self.QDepart.RecordCount));
      if NOT(self.IRQ^) then Action.Interrupt;

      Action.timeStamp('Выполнено: кол-во позиций '+IntToStr(i));
      if self.filelog<>'' then PrintLog(self.filelog,DateTimeToStr(Now())+#9+  'Выполнено: кол-во позиций '+IntToStr(i));
      Action.Resume(self.QDepart.Eof);//i=Self.QDepart.RecordCount
    finally
      FreeAndNil(self.QDepart);
      FreeAndNil(self.QArrivee);
    end;
      (*FreeAndNil(self.QArrivee0);    FreeAndNil(Provider); FreeAndNil(DataSet);*)

      Action.Finish;
  except on E: Exception do   Action.Catch(E);
  end;
finally    Action.Report;
      self.disconnect;
end;
end;
//    self.BridgeTooFar := False;
//    if self.BridgeTooFar then
//     begin
//       ;
//      //self.QArrivee.SaveToFile('DataFile.ADTG');
//     end
//     else
//     begin
//       ;
//      //*self.QArrivee.Connection := self.RightSupport;
//      //*self.QArrivee.UpdateBatch();     //AdCriteriaKeyсинхронизация по ключу AdCriteriaKey
//     end;
    (**)
destructor TBridge.Destroy;
begin
  FreeAndNil(LeftSupport);
  FreeAndNil(RightSupport);
  (*FreeAndNil(RightSupport0); *)
  inherited;
end;

procedure TBridge.disconnect;
begin
  self.LeftSupport.Connected := false;
  self.RightSupport.Connected := false;
end;

class function TBridge.Numeric(strval: string; frac: integer): string;
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

    //if (pos(antisep,strval)<pos(decsep,strval)) then
    //возможен вариант вывода антиразделителя как разделителя разрядов
    //требуется предусмотреть вариант

  strval:=stringReplace(strval,antisep,decsep,[rfReplaceAll]);
  //strval:=stringReplace(strval,'.',decsep,[rfReplaceAll]);
  strval:=stringReplace(strval,#$A0,'',[rfReplaceAll]);
  RESULT:=stringReplace(strval,#$0A,'',[rfReplaceAll]);

  if (Trim(RESULT)='')  then // and (frac>=0)
   begin
    RESULT:='0';
    exit;
   end;
  if (frac<0) then exit; //неправильный ввод

  p:=pos(decsep, RESULT);

  if p>0 then
    if frac=0 then Numeric:=copy(RESULT,1,p-1)
    else Numeric:=copy(RESULT,1,p+frac)
  else   //десятичного разделителя нет но должен быть
    if frac=0 then Numeric:=RESULT
    else Numeric:=RESULT+decsep+StringOfChar('0',frac);
end;

function TBridge.select(SQL: string): boolean;
begin

end;

class function TBridge.setBank(bf: boolean; server, db, plc, coords: string; w: integer):TBank;
begin
  if w>0 then     //w -- количество полей
   with RESULT do
    begin
      b :=bf;    //признак "принимающая сторона"
      servername := server;
      dbname := db;
      place:=plc;  // тэг в массиве данных (фирма, таблица)
      map := listToIntArray(coords,w);    //карта соответствия полей
    end;
end;

//функция удаляет служебные символы и обрезает строку до указанного формата
function charfield(str: string; typecode: integer): string;
var TemplList, ReplList: TStringList;
begin
  RESULT:='';
  TemplList:=TStringList.Create; ReplList:=TStringList.Create;
  try
    TemplList.Add(#$D); ReplList.Add(' #');
    TemplList.Add(#$A); ReplList.Add('# ');
    TemplList.Add(';'); ReplList.Add('.,');
    RESULT:=MultyReplace(str,TemplList,ReplList);
  finally
    FreeAndNil(TemplList); FreeAndNil(ReplList);
  end;
  if length(RESULT)>typecode then setlength(RESULT, typecode);
end;


function TBridge.TypedField(fld: string; typecode: integer): string;
begin
  RESULT:=fld;

  RESULT:=trim(RESULT);
  if typecode <= 0 then
    RESULT:=TBridge.Numeric(RESULT, -typecode)
  else
    RESULT:=charfield(RESULT,typecode); //удалить служ символы и обрезать
    //
end;

{ TImportSubDaemon }



//function TImportSubDaemon.CheckItemsUpdate(var itemts, iigts,
//  umts: int64): boolean;
//begin
//
//end;

constructor TImportSubDaemon.Create;
begin
  inherited;
end;

destructor TImportSubDaemon.Destroy;
begin

  inherited;
end;

function TImportSubDaemon.execut(SQLstatement, ServerName,
  database: string): boolean;
var  Conn: TADOConnection;
begin
  RESULT:=false;
  Conn:=TADOConnection.Create(nil);

  try
      Conn.ConnectionString := generateConnStr(SERVERNAME=self.serverName, ServerName, database);
      Conn.LoginPrompt := false;
      Conn.CommandTimeout :=0;
      Conn.Connected := True;
      Conn.Execute(SQLstatement);
      RESULT:=true;
  finally
    FreeAndNil(Conn);
  end;

end;

function TImportSubDaemon.getSingleValueByRequest(SQLstatement, ServerName,
  database: string): string;
var  Conn: TADOConnection; Q0: TADOQuery;
     //j: integer;
begin
  RESULT:='';
  Conn:=TADOConnection.Create(nil);

  try
      Conn.ConnectionString := generateConnStr(SERVERNAME=self.serverName, ServerName, database);
      Conn.LoginPrompt := false;
      Conn.CommandTimeout :=0;
      Conn.Connected := True;
      Q0:=TADOQuery.Create(nil);
    try
          Q0.Connection :=Conn;

          Q0.SQL.Text := SQLstatement;  //'SELECT SalesCode FROM PriceGroups WHERE ID='+IntToStr(2);
try
            Q0.Open;  
except on E: Exception do  exit; //в случае ошибки  в запросе возвращаем пустую  строку
end;
          Q0.First;
          if Q0.FieldCount >0 then
           begin
            if Q0.Fields[0].IsNull  then exit
             else RESULT:=Q0.Fields[0].AsString;
           end;
          Conn.Connected := False;
    finally
      FreeAndNil(Q0);
    end;
  finally
    FreeAndNil(Conn);
  end;
end;





function TImportSubDaemon.getWarehouses(WhQ: TADOQuery): boolean;
const SQLSELECTWAREHOSESBYDOMAIN = 'SELECT [ID] ,[Code] FROM [Warehouses] WHERE Domain = ';
begin
  RESULT:=False;
  if not Assigned(WhQ) then exit;
  try
    WhQ.Connection := self.ConnGeneral;
    WhQ.CursorLocation := clUseClient;
    WhQ.LockType := ltReadOnly;
    WhQ.SQL.Text := SQLSELECTWAREHOSESBYDOMAIN + IntToStr(self.domain);
    WhQ.Open;
    if WhQ.RecordCount = 0 then exit;
    WhQ.First;
  except
    on Err: Exception do
      self.LogTimeStamp(Err.Message);
  end;

  RESULT:=True;
end;

function TImportSubDaemon.LoadData(whNo, W: integer; map0list,map_list,
  types_list, donortag,acceptortag: string): boolean;
var src, dst: TBank;
    Bridge: TDataBridge;
    tt: TIntArray;
begin
  src:=TBridge.setBank(false,'serverNAV','Shate-M','Shate-M',map0list, W);
  dst:=TBridge.setBank(true,self.serverName,self.DBName,acceptortag,map_list,W);

  tt:=listToIntArray(types_list,W);
  Bridge:=TDataBridge.Create(src,dst,W,tt);
  try
    Bridge.Cross
  finally
    FreeAndNil(Bridge);
  end;
end;
function TImportSubDaemon.LoadCurrenciesTest: boolean;
const
	    WIDTH_CY = 3;
      MAP0CY  = '0, 1, 2'; // : ARRAY[0..2] OF INTEGER= (0, 1, 2)
      MAP_CY  = '1, 2, 4'; //: ARRAY[0..2] OF INTEGER = (1, 2, 4);
      TYPES_CY  = '3,-4,0';  //: ARRAY[0..2] OF INTEGER =(3,-4,0);
var src,dst: TBank;
    Bridge: TDataBridge;
    tt: TIntArray;
    //SQLstr: string;
begin
  RESULT:=FALSE;
self.LogTimeStamp('Загрузка курсов');
//*****выполнимо в LoadData()
  src:=TBridge.setBank(false,self.serverNAV,self.dbNAV,self.Firm,MAP0CY, WIDTH_CY);
  dst:=TBridge.setBank(true,self.serverName,self.DBName,'Currencies',MAP_CY,WIDTH_CY);

  tt:=listToIntArray(TYPES_CY,WIDTH_CY );
  Bridge:=TDataBridge.Create(src,dst,WIDTH_CY,tt);     Bridge.filelog:=self.filelog;
//self.LogTimeStamp('Удаление устаревших...');
//  self.execut('DELETE FROM CURRENCIES',self.serverName,self.DBName);
//  Bridge.SQLStatement := loadTextDataByTag('SQLLoadCurrencies');
  Bridge.Proclaim('select top 1 ''CHF'' as cy, 1 as rate, -2 as typecode from [##Firm##$Currency Exchange Rate]');
  try
    Bridge.Cross
  finally
    FreeAndNil(Bridge);
  end;
  RESULT:=TRUE;
end;
function TImportSubDaemon.LoadCosts(domainNo: integer): boolean;
const
	  WIDTH_COSTS = 3;
    MAP0COSTS =    ' 0, 1, 2';
    MAP_COSTS =     ' 1, 2, 3';
    TYPES_COSTS =  '20, -10, 0';
var src,dst: TBank;
    Bridge: TBridge;
    tt: TIntArray;

    SQLstr: string;
    IDthrshld: int64;
   //TemplList, ReplList: TStringList;

    Action : IAction;
begin
  RESULT:=FALSE;
  self.LogTimeStamp('Загрузка себестоимости');
//*****выполнимо в LoadData()
  src:=TBridge.setBank(false,self.serverNAV,self.dbNAV,self.Firm,MAP0COSTS, WIDTH_COSTS);
  dst:=TBridge.setBank(true,self.serverName,self.DBName,'Costs',MAP_COSTS,WIDTH_COSTS);

  tt:=listToIntArray(TYPES_COSTS, WIDTH_COSTS);

  //TemplList:= TStringList.Create; ReplList:=TStringList.Create;

try   Action:= TAction.Create('Загрузка себестоимости',self.Logger);
  try  Action.Start;

    SQLstr:='SELECT COALESCE(MAX(ID),0)FROM Costs';
    IDthrshld:=StrToInt64(self.getSingleValueByRequest(SQLstr,self.serverName,self.DBName));

    if NOT(self.go^) then Action.Interrupt;

    Bridge:=TBridge.Create(src,dst,WIDTH_COSTS,tt);    Bridge.filelog:=self.filelog;  Bridge.IRQ := @(self.go^);
    SQLstr := loadTextDataByTag('SQLLoadCosts');      //SQLstr:=StringReplace(SQLstr,'##IDWH##',IntToStr(h),[rfReplaceAll]);
//    TemplList.Add('##IDWH##'); ReplList.Add(IntToStr(h));
//    TemplList.Add('##WHLOCATION##'); ReplList.Add(loccode);
    Bridge.SQLStatement := StringReplace(SQLStr, '##DOMAIN##', IntToStr(domainNo), []);
    //MultyReplace(SQLstr,TemplList,ReplList);
//    TemplList.Clear; ReplList.Clear;
    //мост можно создавать&разрушать или в цикле или вне цикла
    Bridge.depth := True;
    try
      Bridge.Cross
    finally
      FreeAndNil(Bridge);
    end;

    //удаление устаревшей себестоимости
    Action.timeStamp('удаление себестоимости по пороговому значению индекса');
    SQLstr:='DELETE FROM COSTS WHERE ID<=##THRSHLD## AND DomainNo ='+IntToStr(domainNo);
    SQLStr:=StringReplace(SQLstr,'##THRSHLD##',IntToStr(IDthrshld),[rfReplaceAll]);
    Action.Note(SQLstr);
    self.execut(SQLstr,self.serverName,self.DBName);

    if NOT(self.go^) then Action.Interrupt;

    //self.fresh:=true;

    RESULT:=True;
    Action.Resume(RESULT);
    Action.Finish;
except on E: Exception do Action.Catch(E);
end;
finally  Action.Report;
    //FreeAndNil(TemplList); FreeAndNil(ReplList);
end;     
end;

function TImportSubDaemon.LoadCurrencies: boolean;
const
	    WIDTH_CY = 3;
      MAP0CY  = '0, 1, 2'; // : ARRAY[0..2] OF INTEGER= (0, 1, 2)
      MAP_CY  = '1, 2, 4'; //: ARRAY[0..2] OF INTEGER = (1, 2, 4);
      TYPES_CY  = '3,-4,0';  //: ARRAY[0..2] OF INTEGER =(3,-4,0);
var src,dst: TBank;
    Bridge: TBridge;
    tt: TIntArray;
    //SQLstr: string;
    Action : IAction;
begin
  RESULT:=FALSE;
self.LogTimeStamp('Загрузка курсов');
try  Action := TAction.Create('Загрузка курсов',self.Logger, True); //ошибка в модуле передаётся в вызывающюю процедуру
  try Action.Start;
    //*****выполнимо в LoadData()
      src:=TBridge.setBank(false,self.serverNAV,self.dbNAV,self.Firm,MAP0CY, WIDTH_CY);
      dst:=TBridge.setBank(true,self.serverName,self.DBName,'Currencies',MAP_CY,WIDTH_CY);

    //self.ConnGeneral.BeginTrans;    //атомарная операция; нельзя прерывать!
    self.LogTimeStamp('Удаление устаревших...'); Action.timeStamp('Удаление устаревших...');

      self.ConnGeneral.Execute('DELETE FROM CURRENCIES');
      //self.execut('DELETE FROM CURRENCIES',self.serverName,self.DBName);

      tt:=listToIntArray(TYPES_CY,WIDTH_CY );
      Bridge:=TBridge.Create(src,dst,WIDTH_CY,tt);     Bridge.filelog:=self.filelog; Bridge.IRQ := @(self.go^);

      Bridge.SQLStatement := loadTextDataByTag('SQLLoadCurrencies');

      try
        Bridge.Cross
      finally
        FreeAndNil(Bridge);
      end;
      //self.ConnGeneral.CommitTrans;
      RESULT:=TRUE;
  except on E: Exception do
    //self.ConnGeneral.RollbackTrans; //во избежание опустошения таблицы курсов
  end;
  Action.Finish;
finally  Action.Report;
end;
end;

function TImportSubDaemon.LoadIerarchy(domainNo: Integer): boolean;
const
      WIDTH_ITEMS = 9;
      MAP0ITEMS  =' 0, 1,  2,  3, 4,  5, 6,  7,  8';
      MAP_ITEMS = ' 1, 2,  5,  6, 7,  8, 9, 10, 11';
      TYPES_ITEMS ='0, 0, 20, 50, 0, 50, 0, 50,  0';

var src,dst: TBank;
    Bridge: TBridge;
    tt: TIntArray;

    SQLstr, SQLstrtempl: string;
    TmplList, ReplList: TStringList;

    idthrshld: int64;

    Action: IAction;
begin
  RESULT:=False;

  tt:=listToIntArray(TYPES_ITEMS,WIDTH_ITEMS);
  src:=TBridge.setBank(false,self.serverNAV,self.DBNav,self.Firm,MAP0ITEMS, WIDTH_ITEMS);
  dst:=TBridge.setBank(true,self.serverName,self.DBName,'Ierarchy',MAP_ITEMS,WIDTH_ITEMS);
  Bridge:=TBridge.Create(src,dst,WIDTH_ITEMS,tt);   Bridge.IRQ := @(self.go^);
  Bridge.filelog:=self.filelog;

  TmplList:=TStringList.Create; ReplList:=TStringList.Create;
  try Action:=TAction.Create('Загрузка иерархии товарных групп',self.Logger);
    try Action.Start;

      Action.Stamp('Получение порогового идентификатора таблицы');
      SQLstr:='SELECT ISNULL(MAX(ID),0)FROM IERARCHY';
      idthrshld:=StrToInt64(self.getSingleValueByRequest(SQLstr,self.serverName,self.DBName));

      SQLstr := loadTextDataByTag('SQLLoadIerarchy');
      TmplList.Add('##IDD##'); ReplList.Add(InttoStr(domainNo));
      SQLStr:=MultyReplace(SQLstr,TmplList,ReplList);
      TmplList.Clear; ReplList.Clear;

      if NOT(self.go^) then Action.Interrupt;

      Bridge.SQLStatement := SQLstr;

      Bridge.Cross;

      Action.Stamp('Актуализация обновлённой иерархии');
//      SQLStr:= ' DELETE FROM Ierarchy WHERE ID <=##IDTHRSHLD##  AND Domain= '+IntToStr(self.domain);
//      SQLStr:= SQLStr
//      + ' Update Ierarchy Set [TradeGroup] = Case [level0] when 0 then g2 when 1 then g1 when 2 then g2 End '
//      + ' ,[Tag] =  Case [TradeGroup] when g0 then [Tag] else  g0 end '
//      + ' Where ID >##IDTHRSHLD## AND Domain = '+IntToStr(self.domain);

      SQLStr:=loadTextDataByTag('SQLUpdateIerarchy');
      TmplList.Add('##Domain##'); ReplList.Add(IntToStr(self.domain));

      TmplList.Add('##IDTHRSHLD##'); ReplList.Add(InttoStr(idthrshld));
      SQLStr:=MultyReplace(SQLstr,TmplList,ReplList);

      Self.ConnGeneral.Execute(SQLStr);

      RESULT:=TRUE;
      Action.Finish;
    except on E: Exception do
      Action.Catch(E);
    end;
  finally Action.Report;
    TmplList.Free; ReplList.Free;
    FreeAndNil(Bridge);
  end;


end;

function TImportSubDaemon.LoadItems(domainNo: integer): boolean;
const
      WIDTH_ITEMS = 15;
      MAP0ITEMS  =' 0,1, 2,  3, 4, 5,  6,  7,8, 9,10,11,12,13,14'; //:   ARRAY[0..13] OF INTEGER =   ( 0,1, 2,  3, 4, 5,  6,  7,8, 9,10,11,12,13);
      MAP_ITEMS =' 1,2, 3,  4, 5, 6,  7,  8,9,10,11,12,13,14,15'; //: ARRAY[0..13] OF INTEGER =   ( 1,2, 3,  4, 5, 6,  7,  8,9,10,11,12,13,14);
      TYPES_ITEMS ='20,0,20,255,20,20,255,255,0,20,-3,-3,-3,-3,0';//: ARRAY[0..13] OF INTEGER = (20,0,20,255,20,20,255,255,0,20,-3,-3,-3,-3);



var src,dst: TBank;
    Bridge: TBridge;
    tt: TIntArray;

    SQLstr, SQLstrtempl: string;
    TmplList, ReplList: TStringList;

     idthrshld,     itts0, igts0, umts0: int64;
                    itts, igts, umts: int64;

    Action: IAction;
begin
  RESULT:=FALSE;
self.LogTimeStamp('Загрузка продуктов');

    //*****выполнимо в LoadData()
      src:=TBridge.setBank(false,self.serverNAV,self.DBNav,self.Firm,MAP0ITEMS, WIDTH_ITEMS);
      dst:=TBridge.setBank(true,self.serverName,self.DBName,'Items',MAP_ITEMS,WIDTH_ITEMS);

      tt:=listToIntArray(TYPES_ITEMS,WIDTH_ITEMS);
      Bridge:=TBridge.Create(src,dst,WIDTH_ITEMS,tt);   Bridge.IRQ := @(self.go^);
      Bridge.filelog:=self.filelog;
    //***************************

      TmplList:=TStringList.Create; ReplList:=TStringList.Create;
try   Action:=TAction.Create('Загрузка продуктов',self.Logger);
try   Action.Start;
    //********* кусок кода специфичный для LoadItems *******
      //получение временных меток последней версии
      SQLstrtempl:=loadTextDataByTag('SQLSelectDataVersionThreshold');
    
      SQLStrtempl:=StringReplace(SQLstrtempl,'##DomainID##',IntToStr(domainNo),[rfReplaceAll]);
      Action.timeStamp('Получение версии предыдущего обновления таблиц');
      //[Item].[timestamp]
      SQLStr:=StringReplace(SQLstrtempl,'##Tag##','Item',[rfReplaceAll, rfIgnoreCase] );
      itts0:=StrToInt64(self.getSingleValueByRequest(SQLstr,self.serverName,self.DBName));

      //[Item Item Group].[timestamp]
      SQLStr:=StringReplace(SQLstrtempl,'##Tag##','ItemItemGroup',[rfReplaceAll, rfIgnoreCase] );
      igts0:=StrToInt64(self.getSingleValueByRequest(SQLstr,self.serverName,self.DBName));

      //[Item Unit Of Measure].[timestamp]
      SQLStr:=StringReplace(SQLstrtempl,'##Tag##','ItemUnitOfMeasure',[rfReplaceAll, rfIgnoreCase] );
      umts0:=StrToInt64(self.getSingleValueByRequest(SQLstr,self.serverName,self.DBName));

      Action.timeStamp('Получение версии актуального обновления данных');
      //получение текущих временных меток
      //обязательно ДО заливки
      //иначе изменения ВО ВРЕМЯ заливки будут утеряны
      SQLstrtempl:=loadTextDataByTag('SQLSelectTimestamp');
      SQLStrtempl:=StringReplace(SQLstrtempl,'##Firm##',self.Firm,[rfReplaceAll]);

       //[Item].[timestamp]
      SQLStr:=StringReplace(SQLstrtempl,'##Table##','Item',[rfReplaceAll, rfIgnoreCase] );
      itts:=StrToInt64(self.getSingleValueByRequest(SQLstr,self.serverNAV,self.dbNAV));
      if NOT(self.go^) then Action.Interrupt; //**
      //[Item Item Group].[timestamp]
      SQLStr:=StringReplace(SQLstrtempl,'##Table##','Item Item Group',[rfReplaceAll, rfIgnoreCase] );
      igts:=StrToInt64(self.getSingleValueByRequest(SQLstr,self.serverNAV,self.dbNAV));
      if NOT(self.go^) then Action.Interrupt;
      //[Item Unit Of Measure].[timestamp]
      SQLStr:=StringReplace(SQLstrtempl,'##Table##','Item Unit Of Measure',[rfReplaceAll, rfIgnoreCase] );
      umts:=StrToInt64(self.getSingleValueByRequest(SQLstr,self.serverNAV,self.dbNAV));
      if NOT(self.go^) then Action.Interrupt; //**

      Action.timeStamp('Получение порогового идентификатора таблицы');
      //  TmplList.Add('##Tag##'); ReplList.Add('');
    //  TmplList.Add('/*##InfoCondition##*/'); ReplList.Add(' ');
    //  TmplList.Add('##DomainNo##'); ReplList.Add(IntToStr(whNo));
      SQLstr:='SELECT COALESCE(MAX(ID),0)FROM Items';
      idthrshld:=StrToInt64(self.getSingleValueByRequest(SQLstr,self.serverName,self.DBName));
      if NOT(self.go^) then Action.Interrupt;
    //******************************************************



      SQLstr := loadTextDataByTag('SQLLoadItems');


      //шаблоны ограничения на новые записи
      TmplList.Add('##THRSHLDItem##');  ReplList.Add(IntToStr(itts0));
      TmplList.Add('##THRSHLDItemGroup##');  ReplList.Add(IntToStr(igts0));
      TmplList.Add('##THRSHLDUnitOfMeasure##');  ReplList.Add(IntToStr(umts0));


      // шаблон идентификации склада  **домена
      TmplList.Add('##DOMAIN##');  ReplList.Add(IntToStr(domainNo));

      SQLStr:=MultyReplace(SQLstr,TmplList,ReplList);
      TmplList.Clear; ReplList.Clear;
      Bridge.SQLStatement := SQLstr;

      Action.Note(SQLstr);
      //TmplList.Add('####');
      Bridge.depth := false;
      try
        Bridge.Cross
      finally
        FreeAndNil(Bridge);
      end;

      if NOT(self.go^) then Action.Interrupt;
     //********* кусок кода специфичный для LoadItems *******
      SQLstrtempl := loadTextDataByTag('SQLUpdateDataVersionThreshold');
      SQLStrtempl:=StringReplace(SQLstrtempl,'##DomainID##',IntToStr(domainNo),[rfReplaceAll]);

      Action.timeStamp('Сохранение обновленной версии данных');
      //Сохранение последних значений timestamp

      //[Item].[timestamp]
      TmplList.Add('##Tag##');  ReplList.Add('Item');
      TmplList.Add('##THRSHLDValue##');  ReplList.Add(IntToStr(itts));
      SQLStr:=MultyReplace(SQLstrtempl,TmplList,ReplList);
      TmplList.Clear; ReplList.Clear;
      self.execut(SQLstr,self.serverName,self.DBName);


      //[Item Item Group].[timestamp]
      TmplList.Add('##Tag##');  ReplList.Add('ItemItemGroup');
      TmplList.Add('##THRSHLDValue##');  ReplList.Add(IntToStr(igts));
      SQLStr:=MultyReplace(SQLstrtempl,TmplList,ReplList);
      TmplList.Clear; ReplList.Clear;
      self.execut(SQLstr,self.serverName,self.DBName);

      //[Item Unit Of Measure].[timestamp]
      TmplList.Add('##Tag##');  ReplList.Add('ItemUnitOfMeasure');
      TmplList.Add('##THRSHLDValue##');  ReplList.Add(IntToStr(umts));
      SQLStr:=MultyReplace(SQLstrtempl,TmplList,ReplList);
      TmplList.Clear; ReplList.Clear;
      self.execut(SQLstr,self.serverName,self.DBName);

      //удаление устаревших записей
      SQLstr:=loadTextDataByTag('SQLDeleteItems');
      TmplList.Add('##DOMAIN##');  ReplList.Add(IntToStr(domainNo));
      TmplList.Add('##THRSHLD##');  ReplList.Add(IntToStr(idthrshld));
      SQLStr:=MultyReplace(SQLstr,TmplList,ReplList);
      TmplList.Clear; ReplList.Clear;
      self.execut(SQLstr,self.serverName,self.DBName);
    RESULT:=TRUE;
    Action.Resume(RESULT);
    Action.Finish;
except on E: Exception do Action.Catch(E);
end;
finally  Action.Report;
    TmplList.Free; ReplList.Free;
end;
end;

function TImportSubDaemon.LoadPrices(domainNo: integer): boolean;
const
	    WIDTH_PRC = 9;
      MAP0PRC   = '0, 1, 2, 3, 4, 5, 6, 7, 8';// : ARRAY[0..6] OF INTEGER =  (0, 1, 2, 3, 4, 5, 6);
      MAP_PRC   = '1, 2, 3, 4, 5, 6, 7, 8, 9';//: ARRAY[0..6] OF INTEGER =  (1, 2, 3, 4, 5, 6, 7);
      TYPES_PRC = '20,0, 0, 20, 0, 0, 3,-3,0';//: ARRAY[0..6] OF INTEGER= (20,0, 0, 0, 0, 3,-2);
      SQLCYRATE = 'SELECT [Rate] FROM [Currencies] WHERE CY=';
//      SQLSALESPRICEWHERECONDITION = 'WHERE "Starting Date"<GETDATE()  '+
//       'AND ("Ending Date">DATEADD(DAY, DATEDIFF(day, 0, GETDATE()), 0) OR "Ending Date"<"Starting Date")';
  DATETIMEFORMAT = 'yyyymmdd hh:nn:ss';
var src,dst: TBank;
    Bridge: TBridge;
    tt: TIntArray;

    SQLstr, SQLstrtempl: string;
    TmplList, ReplList: TStringList;

    idD, p: byte;
    salesCode: string;
    idthrshld ,spts0, spts : int64;

    date0, date: TDateTime;

    rateBYR, rateRUR, rateUSD: string;
    Action: IAction;
begin
  RESULT:=FALSE;
self.LogTimeStamp('Загрузка цен');
//*****выполнимо в LoadData()
  src:=TBridge.setBank(false,self.serverNAV,self.dbNAV,self.Firm,MAP0PRC, WIDTH_PRC);
  dst:=TBridge.setBank(true,self.serverName,self.DBName,'Prices',MAP_PRC,WIDTH_PRC);

  tt:=listToIntArray(TYPES_PRC,WIDTH_PRC);
  Bridge:=TBridge.Create(src,dst,WIDTH_PRC,tt);   Bridge.filelog:=self.filelog;    Bridge.IRQ := @(self.go^);
  Bridge.depth := false;
  TmplList:=TStringList.Create; ReplList:=TStringList.Create;    //*
//***************************
try   Action:=TAction.Create('Загрузка цен',self.Logger);
 try  Action.Start;
     SQLstr:='SELECT COALESCE(MAX(ID),0)FROM Prices';
     idthrshld:=StrToInt64(self.getSingleValueByRequest(SQLstr,self.serverName,self.DBName));
     self.execut(SQLstr,self.serverName,self.DBName);//выборка порогового значения

    self.LogTimeStamp('ID_THRESHOLD='+IntToStr(idthrshld));

    Action.timeStamp('Получение версии предыдущего обновления таблицы');
  //***************выборка цен по порогу****** написать по прообразу Items
    //получение временных меток последней версии
    SQLstrtempl:=loadTextDataByTag('SQLSelectDataVersionThreshold');

    SQLStrtempl:=StringReplace(SQLstrtempl,'##DomainID##',IntToStr(domainNo),[rfReplaceAll]);

    //[SalesPrice].[timestamp]
    SQLStr:=StringReplace(SQLstrtempl,'##Tag##','SalesPrice',[rfReplaceAll, rfIgnoreCase] );
    spts0:=StrToInt64(self.getSingleValueByRequest(SQLstr,self.serverName,self.DBName));

    SQLStr := 'SELECT CONVERT(CHAR(12),DateTimeStamp,104) FROM DataVersions WHERE Tag = ''SalesPrice'' AND DomainNo = ' +  IntToStr(domainNo);

    date0 := StrToDate(self.getSingleValueByRequest(SQLstr,self.serverName,self.DBName));
    date := Now();

    if NOT(self.go^) then Action.Interrupt;

     //получение текущих временных меток
    //обязательно ДО заливки
    //иначе изменения ВО ВРЕМЯ заливки будут утеряны
    SQLstrtempl:=loadTextDataByTag('SQLSelectTimestamp');  //SQLSelectSalesPriceTimestamp
    TmplList.Add('##Firm##');ReplList.Add(self.Firm);
    TmplList.Add('##Table##');ReplList.Add('Sales Price');
  //  //TmplList.Add('/*##WHERE##*/');ReplList.Add(SQLSALESPRICEWHERECONDITION);

    SQLstr:=MultyReplace(SQLStrTempl,TmplList,ReplList);
    TmplList.Clear;ReplList.Clear;
  //  SQLStr:=StringReplace(SQLstrtempl,'##Firm##',self.Firm,[rfReplaceAll]);
     //[Sales Price].[timestamp]
    //SQLStr:=StringReplace(SQLstrtempl,'##Table##','Sales Price',[rfReplaceAll, rfIgnoreCase] );
    spts:=StrToInt64(self.getSingleValueByRequest(SQLstr,self.serverNAV,self.dbNAV));
    self.LogTimeStamp('timestampNew='+IntToStr(spts));
  //*******************************************

    SQLstrtempl := loadTextDataByTag('SQLLoadPrices');
    TmplList.Add('##DOMAIN##');ReplList.Add(IntToStr(domainNo));
    TmplList.Add('##THRSHLDPrices##');ReplList.Add(IntToStr(spts0)); //####
    TmplList.Add('##DATESTAMP##');ReplList.Add(DateToStr(date0));
    //...место для запроса курсов валют и модификации
    //TmplList.Add('##rate##');ReplList.Add(FloatToStr(rate));
    rateBYR:=getSingleValueByRequest(SQLCYRATE+'''BYR''',self.serverName,self.DBName);
    TmplList.Add('##RATEBYR##');ReplList.Add(rateBYR);
    rateRUR:=getSingleValueByRequest(SQLCYRATE+'''RUR''',self.serverName,self.DBName);
    TmplList.Add('##RATERUR##');ReplList.Add(rateRUR);
    rateUSD:=getSingleValueByRequest(SQLCYRATE+'''USD''',self.serverName,self.DBName);
    TmplList.Add('##RATEUSD##');ReplList.Add(rateUSD);
    SQLstrtempl := MultyReplace(SQLstrtempl, TmplList, ReplList);
    TmplList.Clear;ReplList.Clear;

    for idD := 1 to self.DD do
    // if <проверка на необходимость выполнения для домена> then
    if idD in self.domainsSet  then
     begin
     if NOT(self.go^) then Action.Interrupt;

       p:=idD * sign(abs(idD-domainNo));
       SQLstr:='SELECT SalesCode FROM PriceGroups WHERE ID='+IntToStr(p);
       salesCode:=self.getSingleValueByRequest(SQLstr,Self.serverName,self.DBName);
  self.LogTimeStamp('Ценовая группа: '+salesCode);  Action.timeStamp('Ценовая группа: '+salesCode);
       TmplList.Add('##PRGRPID##');ReplList.Add(IntToStr(p));
       TmplList.Add('##PRICEGROUP##');ReplList.Add(salesCode);
       SQLstr := MultyReplace(SQLstrtempl, TmplList, ReplList);
       TmplList.Clear;ReplList.Clear;

       Bridge.SQLStatement := SQLstr;

       Action.Note(SQLstr);

       Bridge.Cross;

       if NOT(self.go^) then Action.Interrupt;


       //удаление старых цен   для перелитой ценовой группы
       //SQLstr:='DELETE FROM PRICES WHERE ID<=##THRSHLD## AND ID_PriceGroup = ##PRGRPID## AND ID_WH = ##WHID##';
       SQLstr:=loadTextDataByTag('SQLDeletePrices');//удаление устаревших записей
       TmplList.Add('##PRGRPID##');ReplList.Add(IntToStr(p));
       TmplList.Add('##DOMAIN##');ReplList.Add(IntToStr(domainNo));
       TmplList.Add('##THRSHLD##');ReplList.Add(IntToStr(idthrshld));
       SQLstr := MultyReplace(SQLstr, TmplList, ReplList);
       TmplList.Clear;ReplList.Clear;
       self.LogTimeStamp('Удаление устаревших записей...'); Action.timeStamp('Удаление устаревших записей...');
       self.execut(SQLstr,self.serverName,self.DBName);
     end;
   //********* кусок кода НЕ специфичный для LoadItems *******
    Action.timeStamp('Запоминание новой версии данных: '+IntToStr(spts));
    SQLstrtempl := loadTextDataByTag('SQLUpdateDataVersionThreshold');
    SQLStrtempl:=StringReplace(SQLstrtempl,'##DomainID##',IntToStr(domainNo),[rfReplaceAll]);
    //Сохранение последних значений timestamp
    //[Sales Price].[timestamp]
    TmplList.Add('##Tag##');  ReplList.Add('SalesPrice');
    TmplList.Add('##THRSHLDValue##');  ReplList.Add(IntToStr(spts));
    SQLStr:=MultyReplace(SQLstrtempl,TmplList,ReplList);
    TmplList.Clear; ReplList.Clear;
    Action.Note(SQLstr);
    self.execut(SQLstr,self.serverName,self.DBName);

    if trunc(date)>trunc(date0) then
     begin
      Action.Stamp('обновление даты синхронизации...');
      SQLStrtempl := 'UPDATE DataVersions SET DateTimeStamp = ''##TimestampValue##'' WHERE Tag =''SalesPrice'' AND DomainNo=';
      SQLStr := StringReplace(SQLstrtempl, '##TimestampValue##', FormatDateTime(DATETIMEFORMAT,date), []) + IntToStr(domainNo);
      Action.Note(SQLstr);
      self.execut(SQLstr,self.serverName,self.DBName);
     end;

    RESULT:=TRUE;
    Action.Resume(RESULT);
    Action.Finish;
except on E: Exception do
    Action.Catch(E);
end;
    finally   Action.Report;
      FreeAndNil(Bridge);
      FreeAndNil(TmplList); FreeAndNil(ReplList); //** утечка ресурсов
    end;

end;

function TImportSubDaemon.LoadStocks(domainNo: integer): boolean;
const
	  WIDTH_STOCKS = 5;
    MAP0STOCKS =    ' 0, 1, 2, 3, 4';  //: ARRAY[0..4] OF INTEGER =   ( 0, 1, 2, 3, 4);
    MAP_STOCKS=     ' 1, 2, 3, 4, 5';   //: ARRAY[0..4] OF INTEGER =   ( 1, 2, 3, 4, 5);
    TYPES_STOCKS =  '20, 0, 0, 0, 0';//: ARRAY[0..4] OF INTEGER = (20, 0, 0, 0, 0);
var src,dst: TBank;
    Bridge: TBridge;
    tt: TIntArray;

    SQLstr: string;
    IDthrshld: int64;

    h: integer; loccode: string;   //**
    Qwh: TADOQuery;               //**
    TemplList, ReplList: TStringList;

    Action : IAction;
begin
  RESULT:=FALSE;
self.LogTimeStamp('Загрузка остатков');
//*****выполнимо в LoadData()
  src:=TBridge.setBank(false,self.serverNAV,self.dbNAV,self.Firm,MAP0STOCKS, WIDTH_STOCKS);
  dst:=TBridge.setBank(true,self.serverName,self.DBName,'Stocks',MAP_STOCKS,WIDTH_STOCKS);

  tt:=listToIntArray(TYPES_STOCKS, WIDTH_STOCKS);

  TemplList:= TStringList.Create; ReplList:=TStringList.Create;

  Qwh := TADOQuery.Create(nil);
try   Action:= TAction.Create('Загрузка остатков',self.Logger);
  try  Action.Start;
    //удаление устаревших остатков по пороговому значению индекса
    SQLstr:='SELECT COALESCE(MAX(ID),0)FROM Stocks';
    idthrshld:=StrToInt64(self.getSingleValueByRequest(SQLstr,self.serverName,self.DBName));

    if self.getWarehouses(Qwh) then    //если благополучно получена таблица доменов
     repeat

        if NOT(self.go^) then Action.Interrupt;

        h:=Qwh.Fields[0].AsInteger;   loccode := trim(Qwh.Fields[1].AsString);
        Bridge:=TBridge.Create(src,dst,WIDTH_STOCKS,tt);    Bridge.filelog:=self.filelog;  Bridge.IRQ := @(self.go^);
        SQLstr := loadTextDataByTag('SQLLoadStocks');      //SQLstr:=StringReplace(SQLstr,'##IDWH##',IntToStr(h),[rfReplaceAll]);
        TemplList.Add('##IDWH##'); ReplList.Add(IntToStr(h));
        TemplList.Add('##WHLOCATION##'); ReplList.Add(loccode);
        Bridge.SQLStatement := MultyReplace(SQLstr,TemplList,ReplList);
        TemplList.Clear; ReplList.Clear;
        //мост можно создавать&разрушать или в цикле или вне цикла
        Bridge.depth := True;
        try
          Bridge.Cross
        finally
          FreeAndNil(Bridge);
        end;

        //удаление устаревших остатков
        Action.timeStamp('удаление устаревших остатков по пороговому значению индекса');
        SQLstr:='DELETE FROM STOCKS WHERE ID<##THRSHLD## AND ID_WH='+IntToStr(h);
        SQLStr:=StringReplace(SQLstr,'##THRSHLD##',IntToStr(IDthrshld),[rfReplaceAll]);
        Action.Note(SQLstr);
        self.execut(SQLstr,self.serverName,self.DBName);

        if NOT(self.go^) then Action.Interrupt;


        Action.timeStamp('Расчёт остатка с учётом резервирования');
        SQLstr:='UPDATE STOCKS SET STOCK=EntryWH-COALESCE(EntryReserv,0), _STOCK=EntryWH-COALESCE(EntryLedger,0) WHERE ID_WH='+IntToStr(h);
        self.execut(SQLstr,self.serverName,self.DBName);

        if NOT(self.go^) then Action.Interrupt;

        Action.timeStamp('ограничение белого остатка');
        SQLstr:='UPDATE STOCKS SET _STOCK=STOCK  WHERE _STOCK>STOCK AND ID_WH='+IntToStr(h);
        self.execut(SQLstr,self.serverName,self.DBName);

        if NOT(self.go^) then Action.Interrupt;

        Action.timeStamp('кодирование остатков');
        SQLstr:='UPDATE STOCKS SET QNT=CASE WHEN STOCK<=0 THEN ''0''  WHEN STOCK<10 THEN CAST(STOCK as CHAR(1)) WHEN STOCK<100 THEN ''10>'' ELSE ''100>'' END WHERE ID_WH='+IntToStr(h);
        self.execut(SQLstr,self.serverName,self.DBName);
        SQLstr:='UPDATE STOCKS SET _QNT=CASE WHEN _STOCK<=0 THEN ''0'' WHEN _STOCK<10 THEN CAST(_STOCK as CHAR(1)) WHEN _STOCK<100 THEN ''10>'' ELSE ''100>'' END WHERE ID_WH='+IntToStr(h);
        self.execut(SQLstr,self.serverName,self.DBName);

        Qwh.Next;
     until Qwh.Eof;
     self.fresh:=true;
     Qwh.Connection.Connected := False; //*
  RESULT:=True;
     Action.Resume(RESULT);
     Action.Finish;
except on E: Exception do Action.Catch(E);
end;
finally  Action.Report;
    FreeAndNil(TemplList); FreeAndNil(ReplList);
    FreeAndNil(Qwh);
end;
//***************************

end;
procedure TImportSubDaemon.LogTimeStamp(Msg: string);
begin
  PrintLog(self.filelog,Msg);
end;

procedure TImportSubDaemon.ReadConfigParameters;
var domainslist, warehouseslist: string;
    domains, warehouses: TINTARRAY;
    k: integer;
begin
  self.filelog :=  ReadLogFilename;

  domainslist := ReadDomainsList;
  domains:= listToIntArray(domainslist,0);
  for k := 0 to Length(domains) - 1 do
   self.domainsSet:= self.domainsSet +[byte(domains[k] mod 256)];
    
  self.domain := ReadDomain;
  warehouseslist := ReadWarehousesList;
  warehouses:= listToIntArray(warehouseslist,0);
  self.whNo:=warehouses[0]; //** устаревшая логика можно использовать для фильтрации получения данных по складам
  if self.domain = 0 then self.domain := self.whNo; //временная обратная совместимость со старой инишкой
  
  //for k := 0 to Length(warehouses) - 1 do
  // self.domainsSet:= self.domainsSet + domains[k];
end;
function TImportSubDaemon.ResetImports(Q0:TADOQuery): boolean;
const
      RESETDATAVERSIONTHRESHOLDS = 'UPDATE DATAVERSIONS SET Threshold = 0 WHERE Tag = ''##TABLE##'' AND DomainNo = ';
      CLEARRECORDS = 'DELETE FROM ##TABLE## WHERE DomainNo = ';
      MARKZERO = 'UPDATE [Imports] SET [Last_Import]=0 WHERE TableName = ''##TABLE##'' AND Domain = ';
var     TemplList, ReplList: TStringList;
      //SQLstr: string;
      Action: IAction;
begin
  RESULT:=False;
try       Action:=TAction.Create('Перезагрузка таблиц импорта',self.Logger, false);
    TemplList := TStringList.Create;     ReplList  := TStringList.Create;
    TemplList.Add('##TABLE##');
    //TemplList.Add('##IDWH##');
    try  Action.Start;
      Q0.Connection.Execute('BEGIN TRANSACTION');;
      ReplList.Add('Item');
      Q0.SQL.Text:=MultyReplace(RESETDATAVERSIONTHRESHOLDS + IntToStr(self.domain),TemplList,ReplList); //**whNo
      Q0.ExecSQL;               //обнуление порога версии данных
      Action.timeStamp('Сброшено пороговое значение');
      ReplList.Clear;
      ReplList.Add('Items');     //ошибка
      Q0.SQL.Text:=MultyReplace(CLEARRECORDS + IntToStr(self.domain),TemplList,ReplList);//**whNo
      Q0.ExecSQL;               //очищение данных в таблице
      Action.timeStamp('Очищена таблица');

      Q0.SQL.Text:=MultyReplace(MARKZERO + IntToStr(self.domain),TemplList,ReplList);//**whNo
      Q0.ExecSQL;
      Action.timeStamp('Предопределён импорт для таблицы');
      ReplList.Clear;




      if NOT(self.go^) then Action.Interrupt;


      ReplList.Add('SalesPrice');
      Q0.SQL.Text:=MultyReplace(RESETDATAVERSIONTHRESHOLDS + IntToStr(self.domain),TemplList,ReplList);//**whNo
      Q0.ExecSQL;               //обнуление порога версии данных
      Action.timeStamp('Сброшено пороговое значение');
      ReplList.Clear;
      ReplList.Add('Prices');   //ошибка
      Q0.SQL.Text:=MultyReplace(CLEARRECORDS + IntToStr(self.domain),TemplList,ReplList);//**whNo
      Q0.ExecSQL;               //очищение данных в таблице
      Action.timeStamp('Очищена таблица');

      Q0.SQL.Text:=MultyReplace(MARKZERO + IntToStr(self.domain),TemplList,ReplList);//**whNo
      Q0.ExecSQL;
      Action.timeStamp('Предопределён импорт для таблицы');
      ReplList.Clear;

       //Q0.Connection.Execute('UPDATE Imports Set [Last_Import]=GetDate() WHERE TableName = ''RESET'' AND [Last_Import] = 0  AND Domain = ' + IntToStr(self.whNo));//UPDATE Imports Set [Last_Export]=0 WHERE [Last_Export] IS NOT NULL AND Domain =
      self.fresh:=false;
      Q0.Connection.Execute('COMMIT TRANSACTION');
      RESULT:=True;
      Action.Finish;
    except
      on E:Exception do
       begin
        Q0.Connection.Execute('ROLLBACK TRANSACTION');
        Action.Catch(E);
       end;
    end;
finally    Action.Report;
    FreeAndNil(TemplList); FreeAndNil(ReplList);
end;
end;

procedure TImportSubDaemon.Init;
var DD : TDomainDescr;
    Conn0: TADOConnection;
    Q0: TADOQuery;
    Action: IAction;
begin
  Action:=TAction.Create('Инициализация импорта',UNiversalLogger);
try Action.Start;
    SectINI.Enter;
    iniFile:=TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+FILENAMEINI);
    try
      self.ReadConfigParameters;
    finally
      FreeAndNil(iniFile);
      SectINI.Leave;
    end;
    Action.Finish;
except on E: Exception do
  Action.Catch(E);
end;
  Action.Report;

{
    self.domainsSet := [1, 2];//
    self.whNo := 1;
}

  Conn0:=TADOConnection.Create(nil);
  try
    Conn0.ConnectionString:=generateConnStr(true,self.serverName,self.DBName);
    Conn0.Connected :=true;
    Q0:=TADOQuery.Create(nil);
    try
      Q0.Connection :=Conn0;
      //Q0.SQL.Text := 'SELECT * FROM Warehouses WHERE ID = '+IntToStr(self.whNo);
      //*!выбираются настройки домена NAV;
      //*!для импорта 2 складов сделать выборку множества [whNo] из Warehouses по DomainNo
      Q0.SQL.Text := 'SELECT * FROM Domains WHERE ID = '+IntToStr(self.domain);//**whNo
      Q0.Open;
      DD:=getDomainDsc(Q0);
      Q0.Close;
    finally
      FreeAndNil(Q0);
    end;
  finally
    FreeAndNil(Conn0);
  end;

  self.serverNAV := DD.server;
  self.dbNAV := DD.db;
  self.Firm := DD.firm;
{
  self.serverName:='SVBYPRISA0023';
  self.DBName :='UNIVERSALEXPORT';

  self.serverName:='AMD';;//'SVBYPRISA0023';
  self.DBName :='UEXPORT';//'UNIVERSALEXPORT';



  self.serverNAV:='SVBYMINSSQ1';//'SVBYPRISA0012';
  self.dbNAV := 'Shate-M';//'shate-m-sdev';
  self.Firm := 'Shate-M';
  //
  self.serverNAV :='SVBYPRISA0012';
  self.dbNAV :=  'shate-m-test';
}
end;

function TImportSubDaemon.CheckImportsUpdate: boolean;
const SQLMARK0 = 'SQLImportMarkZero';
      SQLMARKT = 'SQLImportMarkTime';
      SQLSELECT0 = 'SQLImportsSelectByZero';
//      IMPORTSREQUEST = 'SELECT '
      NN = 7;//6 + Costs// 5 + Ierarchy
      INDITEMS=1;INDCURRENCIES=2;INDPRICES=3;INDSTOCKS=4;INDIERARCHY=5; INDCOSTS = 6;
      TABLES : array[0..NN-1] of string = ('RESET','Items','Currencies','Prices','Stocks','Ierarchy', 'Costs');
var
    importflags: array [0..NN-1] of boolean;
    Q0: TADOQuery;
    Conn0: TADOConnection;
    i: integer;
    SQLstr0, SQLstr: string;
    TemplList, ReplList: TStringList;
    WhereCondition: string;
    Action: IAction;
begin
    RESULT:=False;
    Conn0:= self.ConnGeneral; //TADOConnection.Create(nil);
    try
      Conn0.ConnectionString:=generateConnStr(true,self.serverName,self.DBName);
      Conn0.Open; //.Connected :=true;
      Q0:= TADOQuery.Create(nil);
      Q0.Connection:=Conn0;

      SQLstr0:=loadTextDataByTag(SQLSELECT0);
      TemplList:= TStringList.Create;
      ReplList:=TStringList.Create;

      try  Action := TAction.Create('Проверка наличия импортов',self.Logger);
try       Action.Start;
          WhereCondition :=  ' AND [DOMAIN] = ' + IntToStr(self.domain);  //помечаются таблицы только своего домена
          if requestByTag(SQLMARK0,WhereCondition,Q0) then //помечены импорты
           for i := 0 to NN - 1 do
            begin
              //TemplList.Add('####'); ReplList.Add();
              TemplList.Add('##TABLE##'); ReplList.Add(TABLES[i]);
              TemplList.Add('##DOMAIN##'); ReplList.Add(IntToStr(self.domain));//**whNo
              SQLstr:=MultyReplace(SQLstr0,TemplList, ReplList);
              TemplList.Clear; ReplList.Clear;
              importflags[i]:=getSingleValueByRequest(SQLstr,self.serverName,self.DBName)='True';
            end
           else exit;

           WhereCondition:=' AND  Domain='+IntToStr(self.domain)+' AND Tablename = '; //**whNo
  //{
  //*

           if  NOT(go^) then Action.Interrupt;

  {
              неотлаженный вариант
              опасность опустошения таблицы Items Prices
              проверять перед обновлением Quants
  }
             //при выставлении флага полного сброса
             if importflags[0] then
              begin
                importflags[0]:= self.ResetImports(Q0) ;
                if importflags[0] then
                 begin;
                  importflags[INDITEMS]:=True;
                  importflags[INDCURRENCIES] := (self.domain = 1);
                  importflags[INDPRICES]:=True;
                  requestByTag(SQLMARKT,WhereCondition+''''+ TABLES[0] +'''',Q0);
                 end;
              end;

  //*
           if importflags[INDIERARCHY] then
            if self.LoadIerarchy(self.domain) then
              importflags[INDIERARCHY]:=NOT(requestByTag(SQLMARKT,WhereCondition+''''+ TABLES[INDIERARCHY] +'''',Q0));
           if NOT(go^) then Action.Interrupt;


           if importflags[INDITEMS] then
            if self.LoadItems(self.domain) then  //whNo
              importflags[INDITEMS]:=NOT(requestByTag(SQLMARKT,WhereCondition+''''+ TABLES[INDITEMS] +'''',Q0));
           ;
           if  NOT(go^) then Action.Interrupt;

           if importflags[INDCURRENCIES]  then
            if self.LoadCurrencies  then
              importflags[INDCURRENCIES]:=NOT(requestByTag(SQLMARKT,WhereCondition+''''+ TABLES[INDCURRENCIES] +'''',Q0));

           if  NOT(go^) then Action.Interrupt;
           //RESULT:= ;
           if importflags[INDPRICES] then
            if self.LoadPrices(self.domain) then //**whNo
              importflags[INDPRICES] :=NOT(requestByTag(SQLMARKT,WhereCondition+''''+ TABLES[INDPRICES] +'''',Q0));

           if  NOT(go^) then Action.Interrupt;

           if importflags[INDSTOCKS]  then
            if self.LoadStocks(self.domain) then   //**whNo
              importflags[INDSTOCKS] :=NOT(requestByTag(SQLMARKT,WhereCondition+''''+ TABLES[INDSTOCKS] +'''',Q0));;
   //}
           if importflags[INDCOSTS]  then
            if self.LoadCosts(self.domain) then   //**whNo
              importflags[INDCOSTS] :=NOT(requestByTag(SQLMARKT,WhereCondition+''''+ TABLES[INDCOSTS] +'''',Q0));;

          //успешно выполнено если сброшены флаги всех выбранных экспортов
          RESULT:=NOT(importflags[INDITEMS] OR importflags[INDCURRENCIES] OR importflags[INDPRICES] OR importflags[INDSTOCKS] OR importflags[INDCOSTS]);
          //RESULT:=RESULT AND NOT(importflags[0]);
  {
              //помечается временем завершения
              requestByTag(SQLMARKT,'',Q0);
              RESULT:=True;
  }
          Action.Resume(RESULT);
          Action.Finish;
except on E: Exception do
  Action.Catch(E);
end;
      finally
        FreeAndNil(TemplList); FreeAndNil(ReplList);
        FreeAndNil(Q0);
        //self.ConnGeneral.Connected := False;  //***
      end;
    finally
      Conn0.Close; //FreeAndNil(Conn0);
    end;



end;




procedure TImportSubDaemon.Run;
var scc: boolean;
    Action: IAction;
begin
//LoadCurrenciesTest;
//exit;
 //инициализация настроек основного сервера выполняется при ExportDaemon.Create
 //здесь добавлено для удобства отладки
 //настройки сервера NAV тут
  //self.Init;
  //self.LoadCurrencies;
  //self.LoadItems(self.whNo);
  //PrintLog('C:\Services\ImportLog.log','Загрузка...');
try  Action := TAction.Create('Импорт данных',self.Logger);
    try Action.Start;
  //    SetLength(TrueBoolStrs,1);
  //    SetLength(FalseBoolStrs,1);
  //    BoolToStr(self.fresh)
  //    TrueBoolStrs[0]:='YES';
  //    FalseBoolStrs[0]:='NO';
      self.LogTimeStamp('Импорта данных...');
      scc:=  self.CheckImportsUpdate ;
      self.fresh:= scc AND self.fresh;
      self.LogTimeStamp('...Импорт завершён ');
  //      PrintLog('C:\Services\ImportLog6.log','Загрузка остатков'); self.LoadStocks(self.whNo);
  
  //      PrintLog('C:\Services\ImportLog6.log','Загрузка валют');
  //      self.LoadCurrencies;
  //
  //      PrintLog('C:\Services\ImportLog6.log','Загрузка цен');
  //      self.LoadPrices(self.whNo);
  
  //      PrintLog('C:\Services\ImportLog6.log','Загрузка остатков');
  //      self.LoadStocks(self.whNo);
          Action.Resume(self.fresh);
          Action.Finish;
    except
      on Err:exception do
       begin
          self.LogTimeStamp(Err.Message);
          Action.Catch(Err);
       end;
        //PrintLog('C:\Services\ImportLog6.log',Err.Message);
    end;
finally   Action.Report;
end;
  //self.LoadPrices(self.whNo);
end;

{ TSupport }

procedure TSupport.Append;
begin
  if self.Bank.b then self.Data.Append;
end;

procedure TSupport.CloseConnection;
begin
  self.Connection.Close;
end;

procedure TSupport.CloseData;
begin
  self.Data.Close;
end;

procedure TSupport.ConfigData;
begin

end;

constructor TSupport.Create(DataBank: TBank);//ConnectionType: TConnRef);
begin
//  self.Connection := ConnectionType.Create(nil);
//  self.Connection.LoginPrompt := False;
  self.Bank := DataBank;
  self.art := self.Bank.b;
  //self.DataType:=self.Data.ClassType.;
//  self.Data := self.Datatech(DataBank.b).Create(nil);
end;

//constructor TSupport.Create;
//begin
//  inherited;
//
//end;


destructor TSupport.Destroy;
begin
  //*?* FreeAndNil(self.Connection);
  inherited;
end;

function TSupport.Eof: boolean;
begin
  RESULT := self.Data.Eof;
end;

procedure TSupport.First;
begin
  self.data.First;
end;

class function TSupport.Detected(CONNECTINGTYPE: TConnRef): TSupportClass;
begin
  if CONNECTINGTYPE = TADOConnection then RESULT:= TADOSupport
  else if CONNECTINGTYPE = TSQLConnection then RESULT := TSQLSupport;
end;

function TSupport.getFields: TFields;
begin
  RESULT:=self.Data.Fields;
end;

procedure TSupport.Last;
begin
  self.Data.Last;
end;

procedure TSupport.Next;
begin
  self.Data.Next;
end;

//procedure TSupport.OpenConnection;
//begin
//  (self.Connection as self.ConnType).Connected := True;
//end;

procedure TSupport.OpenData;
begin
  self.Data.Open;
  self.Data.DisableControls;
end;

procedure TSupport.Post;
begin
  if self.Bank.b then self.Data.Post;
end;

{ TADOSupport }

procedure TADOSupport.ConfigData(device: string);
begin
  inherited;
//  with (self.Data as TADOTable) do
//   begin
//
//   end;

  if self.Bank.b then
   with (self.Data as TADOTable) do
    begin

     CursorType := ctStatic;
     CursorLocation := TCursorLocation(1-ord(self.Bank.b));   //0-->Client 1-->Server
     LockType:=TADOLockType(4-ord(self.Bank.b));

      TableName := self.Bank.place;
    end
  else
   with (self.Data as TADOQuery) do
    begin

     CursorType := ctStatic;
     CursorLocation := TCursorLocation(1-ord(self.Bank.b));   //0-->Client 1-->Server
     LockType:=TADOLockType(4-ord(self.Bank.b));

      SQL.Text := StringReplace(device, '##Firm##',self.Bank.place,[rfReplaceAll, rfIgnoreCase ]) ;
    end
end;

constructor TADOSupport.Create(DataBank: TBank);
begin
  inherited Create(DataBank);// ,TADOConnection

  self.Connection := TADOConnection.Create(nil);
  self.Connection.LoginPrompt := False;

  (self.Connection as TADOConnection).CommandTimeout := 300;

  self.Data := self.Datatech(DataBank.b).Create(nil);
  (self.Data as TCustomADODataSet).Connection := (self.Connection as TADOConnection);
  //if DataBank.b then self.Data := TADOQuery.Create(nil);
end;

class function TADOSupport.Datatech(b: boolean): TDataRef;
begin
  if b then RESULT := TADOTable
   else RESULT:=TADOQuery;
end;

destructor TADOSupport.Destroy;
begin

  inherited;
end;

procedure TADOSupport.Execute(commandString: string);
begin
  (self.Connection as TADOConnection).Execute(commandString);
end;

procedure TADOSupport.OpenConnection;
  var driver, server, UID, WSID, TrustConn, database, lang, user: string;
      provider, security, initcatalog, datasource, UserID: string;
  defcatalog: string;
  userNameLen: Cardinal;
  begin
    userNameLen:=255;
    setLength(user, userNameLen);
    getUserName(PAnsiChar(user),userNameLen);

    if self.Bank.b then
     begin
      provider:='Provider=SQLOLEDB.1;';
      security:='Integrated Security=SSPI;Persist Security Info=True;';
      userID  :='User ID='+copy(user,1,UserNameLen-1)+';';
      datasource:='Data Source='+self.Bank.serverName+';';
      InitCatalog := 'Initial Catalog='+self.Bank.dbname+';';
      (self.Connection as TADOConnection).ConnectionString :=
                               provider+security+UserID+initcatalog+datasource;
     end
     else
     begin
      driver := 'DRIVER=SQL Server;';
      server := 'SERVER='+self.Bank.serverName+';';
      UID    := 'UID=;';
      WSID   := 'WSID='+copy(user,1,UserNameLen-1)+';';
      TrustConn := 'Trusted_Connection=Yes;';
      database := 'DATABASE='+self.Bank.dbName+';';
      lang   :='LANGUAGE=русский;';
      (self.Connection as TADOConnection).ConnectionString :=
                     driver + server + UID + WSID + TrustConn + database + lang;
     end;
    (self.Connection as TADOConnection).Connected :=True;
    //inherited OpenConnection;
end;

procedure TADOSupport.OpenData;
begin
  inherited;
  if self.DisconnectedRecordset then
   begin
    (self.Data as TADOTable).Connection:=nil;
    (self.Connection as TADOConnection).Connected := False;
   end;
end;

{ TSQLSupport }

procedure TSQLSupport.Append;
begin
  //inherited;
  if self.Bank.b then self.Cache.Append
   else
  inherited;
end;

procedure TSQLSupport.CloseData;
begin
  if self.Bank.b then self.Cache.ApplyUpdates(1);   //0
  inherited;
end;

procedure TSQLSupport.ConfigData(device: string);
begin
  inherited;

  if self.Bank.b then (self.Data as TSQLTable).TableName := self.Bank.place;

  with (self.Data as TCustomSQLDataSet) do
   begin
     SQLConnection := (self.Connection as TSQLConnection);
     GetMetadata := False;
   end;
end;

constructor TSQLSupport.Create(DataBank: TBank);
begin
  inherited Create(DataBank);//,TSQLConnection

  self.Connection := TSQLConnection.Create(nil);
  self.Connection.LoginPrompt := False;
  self.Data := self.Datatech(DataBank.b).Create(nil);


  self.DataProvider := TDataSetProvider.Create(nil);
  self.DataProvider.DataSet := Self.Data;
  self.Cache := TClientDataSet.Create(nil);
  Cache.SetProvider(DataProvider);

end;

class function TSQLSupport.Datatech(b: boolean): TDataRef;
begin
  if b then RESULT := TSQLTable
   else RESULT := TSQLQuery;
end;

destructor TSQLSupport.Destroy;
begin
  FreeAndNil(self.DataProvider);
  FreeAndNil(self.Cache);
  inherited;
end;

//function TSQLSupport.Eof: boolean;
//begin
//  if self.Bank.b then self.ClientData.Append else exit;
//end;

procedure TSQLSupport.Execute(commandString: string);
begin
  (self.Connection as TSQLConnection).Execute(commandString, nil);
end;

procedure TSQLSupport.First;
begin
  inherited;

end;

function TSQLSupport.getFields: TFields;
begin
  if self.Bank.b then RESULT := self.Cache.Fields
   else RESULT:= self.Data.Fields;
end;

procedure TSQLSupport.Last;
begin
    if self.Bank.b then self.Cache.Last
     else
  inherited;

end;

procedure TSQLSupport.Next;
begin
  if self.Bank.b then self.Cache.Next
   else inherited;

end;

procedure TSQLSupport.OpenConnection;
begin
  (self.Connection as TSQLConnection).ConnectionName := 'MSSQLConnection';
  (self.Connection as TSQLConnection).DriverName := 'MSSQL';
  (self.Connection as TSQLConnection).LoginPrompt := False;
  (self.Connection as TSQLConnection).GetDriverFunc := 'getSQLDriverMSSQL';
  (self.Connection as TSQLConnection).LibraryName := 'dbxmss30.dll';
  (self.Connection as TSQLConnection).VendorLib := 'oledb';
  with (self.Connection as TSQLConnection).Params do
  begin
    Values['HostName'] := self.Bank.servername;   //    HostName
    Values['DataBase'] := self.Bank.dbname;
    Values['OS Authentication'] := 'True';
    Values['SchemaOverride'] := 'sa.dbo';
  end;
  (self.Connection as TSQLConnection).Connected := True;
  //inherited OpenConnection;
end;

procedure TSQLSupport.OpenData;
var j: integer;
begin
  inherited;
  if self.Bank.b then
   begin
    for j := 0 to Self.Data.FieldCount - 1 do
    Self.Data.Fields[j].Required:=False;
    self.Cache.Open;
   end;
end;

procedure TSQLSupport.Post;
begin
  if self.Bank.b then self.Cache.Post
  else inherited;
end;

{ TDataBridge }

procedure TDataBridge.connect;
begin
  self.RightSupport.Open;
  self.LeftSupport.Open;
  try
    self.LeftSupport.Execute(loadTextDataByTag('SQLMAGICWORD'));
  except

  end;
end;

constructor TDataBridge.Create(SrcBank, DstBank: TBank; Dimension: integer;
  tt: TINTARRAY);
begin
  inherited Create;
  Constructions[0]:= TSupport.Detected(TADOConnection).Create(SrcBank);
  Constructions[1]:= TSupport.Detected(TSQLConnection).Create(DstBank);//TSQLConnection
  LeftSupport := Constructions[0];
  RightSupport:= Constructions[1];
  QDepart := Constructions[0];
  QArrivee:=Constructions[1];

  self.Dim := length(tt);

  self.types := tt;


  SetLength(self.map0, self.Dim);
  SetLength(self.map, self.Dim);
  self.map0 := SrcBank.map;
  self.map := DstBank.map;

  self.hq := SrcBank.place;
  self.target := DstBank.place;
  self.concentration:=0;

  self.BridgeTooFar := false;
end;

procedure TDataBridge.Cross;
var i,j: integer;
begin
  self.connect;
  //self.RightSupport.Open;
  self.QDepart.Config(self.Devise);
  //self.LeftSupport.Open;
  self.QArrivee.Config('');



if self.filelog<>'' then PrintLog(self.filelog,DateTimeToStr(Now())+#9+ ' Концентрация... ');

  QDepart.Open;
  QArrivee.Open;
  self.QArrivee.Last;
if self.filelog<>'' then PrintLog(self.filelog,DateTimeToStr(Now())+#9+ ' Форсирование');
    self.QDepart.First; i:=0;
    repeat
      //if i AND CYCLES = 0 then sleep(PAUSE);
      self.QArrivee.Append;
      for j := 0 to self.Dim-1 do
        self.QArrivee.Fields[map[j]].Value:=self.TypedField(self.QDepart.Fields[map0[j]].AsString, self.types[j]);
      self.QArrivee.Post; inc(i);
      self.QDepart.Next;
    until self.QDepart.Eof;
   QArrivee.Close;
if self.filelog<>'' then PrintLog(self.filelog,DateTimeToStr(Now())+#9+  'Выполнено: кол-во позиций '+IntToStr(i));
end;

destructor TDataBridge.Destroy;
begin

  inherited;
end;

procedure TDataBridge.disconnect;
begin

end;

class function TDataBridge.Numeric(strval: string; frac: integer): string;
begin
  RESULT:=TBridge.Numeric(strval, frac);
end;

procedure TDataBridge.Proclaim(motto: string);
begin
  self.Devise := motto;
end;

class function TDataBridge.setBank(bf: boolean; server, db, plc, coords: string;
  w: integer): TBank;
begin
  RESULT:= TBridge.setBank(bf,server,db,plc,coords,w);
end;

function TDataBridge.TypedField(fld: string; typecode: integer): string;
begin
 begin
  RESULT:=fld;

  RESULT:=trim(RESULT);
  if typecode <= 0 then
    RESULT:=TBridge.Numeric(RESULT, -typecode)
  else
    RESULT:=charfield(RESULT,typecode); //удалить служ символы и обрезать
    //
end;
end;
initialization
//*  CoInitializeEx(nil, COINIT_MULTITHREADED);
finalization
//*  CoUninitialize;
end.
