unit _Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer, IdException,
  IdContext, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase, IdSMTP, IdMessage, IdAttachmentFile, IniFiles, Forms,
  IdCoderHeader, DateUtils, VCLUnZip, VCLZip, {Excel_TLB, }ActiveX, ComObj, Variants,
  DB, ADODB, SyncObjs, InvokeRegistry, Rio, SOAPHTTPClient, ServProg, BSStrUt;

const
  cAMDConnectionString = 'Provider=SQLOLEDB.1;Persist Security Info=False;';
  cCustomAutorityParams = 'Data Source=%s;Initial Catalog=%s;User ID=%s;Password=%s;';

  //параматры подключения к БД по скидкам
  cSQLServerDef = 'SVBYMINSD9';
  cDatabaseNameDef = 'CLIENT_INFO';
  cDBUserDef = 'DiscountsService';
  cDBPasswordDef = 'DiscountsService';

  //параматры подключения к БД по ответам
  cAnswerSQLServerDef = 'SVBYMINSD9';
  cAnswerDatabaseNameDef = 'CLIENT_DATA';
  cAnswerDBUserDef = 'DiscountsService';
  cAnswerDBPasswordDef = 'DiscountsService';

  //Уникальный номер отчета возвратного талона в NAV 
  cUnicIDRetDocTicket = '21093710';

  cEXIST = -1;
  cNOT_EXIST = -3;
  cEXIST_UPDATE = -2;
  cERROR = -4;
  cLIST_FOUND_MESSAGE = 'LIST_OF_VALUE';
type

  TFileDocType = (fdtUnknown, fdtZakazano, fdtZameny, fdtTTN);
  TClientCatalogType = (cctDiscounts, cctAddress, cctAgreements);
  TQueryActionType = (qatInsert, qatUpdate);

  TClientInfo = record
    ClientID: string;
    PublicKey: string;
    DiscountsVersion: Integer;
  end;

  TClientVersions = record
    DISCOUNT_VER: Integer;
    ADDRESS_VER: Integer;
    AGREEMENTS_VER: Integer;
  end;

  TDBConnectInfo = record
    Connection: TAdoConnection;

    TestMSSQLConnection: Boolean;
    SqlServerName: string;
    DatabaseName: string;
    DBUser: string;
    DBPassword: string;
  end;

    TShateM_QOS = class(TService)
    TCPServer: TIdTCPServer;
    discountsConnection: TADOConnection;
    answersConnection: TADOConnection;
    HTTPRIO: THTTPRIO;
 //   Zipper: TVCLZip;

    procedure ServiceCreate(Sender: TObject);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure TCPServerExecute(AContext: TIdContext);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceDestroy(Sender: TObject);
  private
    {discounts support}
    fDB_Discounts: TDBConnectInfo;
    {answers support}
    fDB_Answers: TDBConnectInfo;

    fTmpDir: string;
    fLastExceptionTicks: Cardinal;
    fTimeValidCash: integer;

    // [HTTPRIO]
    fIPServer: string;
    fHTTPRIOService: string;
    fHTTPRIOPort: string;
    fWebNodeUserName: string;
    fWebNodePassword: string;

    fCodesMapFile: string;
    fCodesMap: TStrings;

    //procedure DBConnect(const aConnectInfo: TDBConnectInfo);
    //procedure DBDisconnect(const aConnectInfo: TDBConnectInfo);

    function DBConnectNew(const aConnectInfo: TDBConnectInfo): TAdoConnection;
    procedure DBDisconnectNew(var aConnection: TAdoConnection);

    function DecodeDiscountQuery(const aQueryMsg: string; out aClientInfo: TClientInfo): Boolean;
    function GetClientDiscount(const aClientInfo: TClientInfo;
      out aVersion: Integer; aRes: TStream): Integer;
    function CheckPublicKey(const aClientID, aPublicKey, aPrivateKey: string): Boolean;

    function GetClientOrder(const aClientID, aNum: string; aResZakazano, aResZameny: TStream): Integer;
    function GetClientOrderStatus(const aClientID, aNum: string): Integer;
    function GetClientOrderStatusBatch(aQueryes: TStrings): Integer;
    function GetClientRetdoc(const aClientID, aNum: string; aRes: TStream): Integer;
    function GetClientTTN(const aNum: string; aRes: TStream): Integer;
    function GetClientretDocTicket(const aNum: string; aRes: TMemoryStream): boolean;
    //F7(для листа ожидания)
    function GetF7RecordFromTable(const aCode: string; out aID, aActionID: integer):string;
    procedure UpdateF7Table(const aAction: TQueryActionType; const aCode, aAnswer: string; const aID: integer = 0);
    function ParseF7List(const aF7List: TStringList): TStream;
    function EncodeOrderOnly(const aValue: string): string;
    function GetRecord(aCodeBrand: string): string;

    //новое для NAV
    function GetClientVersions(const aClientID, aPublicKey: string; out aRes: TClientVersions): Integer;
    function GetClientCatalog(const aClientID, aPublicKey: string; aCatalogType: TClientCatalogType;
      out aVersion: Integer; aRes: TStream): Integer;
    //!!! тестовая заглушка
    procedure WriteDummyCatalog(aCatalogType: TClientCatalogType; aPrivateKey: string; aRes: TStream);

    //
    function DeCodeQuants(const aQuant: string): string;
    function ReplaceCode(aCodeBrand: string): string;
  public
    fCoInitialized: Boolean;
    fLogLock: TCriticalSection;
    
    ZipUseNetDisk: Integer;
    ZipDiskName: string;
    ZipFilesPath: string;
    PDFRetDocTicketFilesPath: string;
    ZipLocalName: string;
    flogname: string;
    fRatesCustomFile: string;

    //поддержка старых запросов
    FilesPath: string;
    LocalName: string;
    iUseNetDisk:integer;
    //-------------------------

    function GetServiceController: TServiceController; override;
    procedure LogSnd(s: string);
    function StrLeft(s:string; i:integer):string;
    function StrRight(s:string; i:integer):string;
  end;

var
  ShateM_QOS: TShateM_QOS;
  sDateKurses: string;

implementation

{$R *.DFM}

uses
  IdIOHandler, MD5;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ShateM_QOS.Controller(CtrlCode);
end;


function TShateM_QOS.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TShateM_QOS.ServiceCreate(Sender: TObject);
var
  ini: TIniFile;
  NR: TNetResource;
  dwResult: DWORD;
begin
  fLogLock := TCriticalSection.Create;
  fTmpDir := ExtractFilePath(ParamStr(0)) + 'Temp\';
  fCodesMap := TStringList.Create;
  if not DirectoryExists(fTmpDir) then
    ForceDirectories(fTmpDir);
  
  fRatesCustomFile := '';
  flogname := ChangeFileExt(Forms.Application.ExeName, '.log');
  LogSnd('Инициализация службы');
  ini := TIniFile.Create(ChangeFileExt(Forms.Application.ExeName, '.ini'));
  try
    try
      TCPServer.DefaultPort := ini.ReadInteger('System', 'TCPPort', 6003);

      //[DATABASE_DISCOUNTS]
      fDB_Discounts.Connection := discountsConnection;
      fDB_Discounts.TestMSSQLConnection := INI.ReadBool('DATABASE_DISCOUNTS', 'TestConnection', False);
      fDB_Discounts.SqlServerName := INI.ReadString('DATABASE_DISCOUNTS', 'SqlServerName', cSQLServerDef);
      fDB_Discounts.DatabaseName := INI.ReadString('DATABASE_DISCOUNTS', 'DatabaseName', cDatabaseNameDef);
      fDB_Discounts.DBUser := INI.ReadString('DATABASE_DISCOUNTS', 'DBUser', '');
      fDB_Discounts.DBPassword := INI.ReadString('DATABASE_DISCOUNTS', 'DBPassword', '');
      if fDB_Discounts.DBUser = '' then
      begin
        fDB_Discounts.DBUser := cDBUserDef;
        fDB_Discounts.DBPassword := cDBPasswordDef;
      end;

      LogSnd('Ответ по заказу');

      //[DATABASE_ANSWERS]
      fDB_Answers.Connection := answersConnection;
      fDB_Answers.TestMSSQLConnection := INI.ReadBool('DATABASE_ANSWERS', 'TestConnection', False);
      fDB_Answers.SqlServerName := INI.ReadString('DATABASE_ANSWERS', 'SqlServerName', cAnswerSQLServerDef);
      fDB_Answers.DatabaseName := INI.ReadString('DATABASE_ANSWERS', 'DatabaseName', cAnswerDatabaseNameDef);
      fDB_Answers.DBUser := INI.ReadString('DATABASE_ANSWERS', 'DBUser', '');
      fDB_Answers.DBPassword := INI.ReadString('DATABASE_ANSWERS', 'DBPassword', '');
      if fDB_Answers.DBUser = '' then
      begin
        fDB_Answers.DBUser := cAnswerDBUserDef;
        fDB_Answers.DBPassword := cAnswerDBPasswordDef;
      end;

      //поддержка старых запросов
      FilesPath := ini.ReadString('System', 'FilesPath', 'C:\Temp\');
      iUseNetDisk := ini.ReadInteger('System', 'UseNetDisk', 0);
      if iUseNetDisk > 0 then
      begin
        LocalName:= ini.ReadString('System', 'DiskName', 'P:');
        LogSnd('Монтирование диска ' + LocalName);
        NR.dwType := RESOURCEType_DISK;
        NR.lpLocalName := PChar(LocalName);
        NR.lpRemoteName := PChar(FilesPath);
        NR.lpProvider:=nil;
        dwResult := WNetAddConnection2(NR,PChar('ordquerry'),PChar('shate\ord_querry'), 0);
        FilesPath:= LocalName;
        if dwResult <> NO_ERROR then
          LogSnd('Ошибка монтирования диска ' + LocalName + ' - ' + IntToStr(GetLastError));
      end;

      if (StrRight(FilesPath,1) <> '\') then
          FilesPath:=FilesPath+'\';

      LogSnd('Курсы');
      ZipFilesPath := ini.ReadString('System', 'ZipFilesPath', '');
      PDFRetDocTicketFilesPath := ini.ReadString('System', 'PDFRetDocTicketFilesPath', '');
      ZipUseNetDisk:= ini.ReadInteger('System', 'UseNetDisk', 0);
      fTimeValidCash := ini.ReadInteger('System', 'TimeValidCash', 10);
      
      if ZipUseNetDisk > 0 then
      begin
        ZipLocalName:= ini.ReadString('System', 'ZipDiskName', 'P:');
        LogSnd('Монтирование диска ' + ZipLocalName);
        NR.dwType := RESOURCEType_DISK;
        NR.lpLocalName := PChar(ZipLocalName);
        NR.lpRemoteName := PChar(ZipFilesPath);
        NR.lpProvider:=nil;
        dwResult := WNetAddConnection2(NR,PChar('ordquerry'),PChar('shate\ord_querry'), 0);
        ZipFilesPath:= ZipLocalName;
        if dwResult <> NO_ERROR then
          LogSnd('Ошибка монтирования диска ' + ZipLocalName + ' - '+IntToStr(GetLastError));
      end;

      ZipFilesPath := IncludeTrailingPathDelimiter(ZipFilesPath);
      PDFRetDocTicketFilesPath := IncludeTrailingPathDelimiter(PDFRetDocTicketFilesPath);
      LogSnd('ZipFilesPath: ' + ZipFilesPath);
      LogSnd('PDFRetDocTicketFilesPath: ' + PDFRetDocTicketFilesPath);

      fRatesCustomFile := ini.ReadString('System', 'ForceRatesFile', '');
      if fRatesCustomFile <> '' then
        LogSnd('Файл курсов указан принудительно: ' + fRatesCustomFile);
      LogSnd('-----------------------------------------------------------');

      // [HTTPRIO]
      fIPServer := ini.ReadString('HTTPRIO', 'WSDL', ChangeFileExt(Forms.Application.ExeName, '.WSDL'));
      fHTTPRIOService := ini.ReadString('HTTPRIO', 'Service', '');
      fHTTPRIOPort := ini.ReadString('HTTPRIO', 'Port', '');
      fWebNodeUserName := ini.ReadString('HTTPRIO', 'WebNodeUserName', '');
      fWebNodePassword := ini.ReadString('HTTPRIO', 'WebNodePassword', '');

      HTTPRIO.WSDLLocation := fIPServer;
      HTTPRIO.Service := fHTTPRIOService;
      HTTPRIO.Port := fHTTPRIOPort;
      HTTPRIO.HTTPWebNode.ConnectTimeout := 1000 * 5;
      HTTPRIO.HTTPWebNode.ReceiveTimeout := 1000 * 5;
      HTTPRIO.HTTPWebNode.SendTimeout := 1000 * 5;
      HTTPRIO.HTTPWebNode.UserName := fWebNodeUserName;
      HTTPRIO.HTTPWebNode.Password := fWebNodePassword;

      LogSnd('ConnectTimeout: ' + IntToStr(HTTPRIO.HTTPWebNode.ConnectTimeout));
      LogSnd('ReceiveTimeout: ' + IntToStr(HTTPRIO.HTTPWebNode.ReceiveTimeout));
      LogSnd('SendTimeout: ' + IntToStr(HTTPRIO.HTTPWebNode.SendTimeout));

      fCodesMapFile := ini.ReadString('System', 'CodesMapFile', '');
      if (Copy(fCodesMapFile, 1, 2) <> '\\') and (Copy(fCodesMapFile, 2, 2) <> ':\') then
        fCodesMapFile := ExtractFilePath(ParamStr(0)) + fCodesMapFile;
      if FileExists(fCodesMapFile) then
        fCodesMap.LoadFromFile(fCodesMapFile);
      LogSnd('Файл замены кодов ' + fCodesMapFile + ', загружено: ' + IntToStr(fCodesMap.Count));

    except
      on E: Exception do
      begin
        LogSnd('Ошибка - '+e.Message);
      end;
    end;
  finally
    ini.Free;
  end;

end;

procedure TShateM_QOS.ServiceDestroy(Sender: TObject);
begin
  fLogLock.Free;
  fCodesMap.Free;
end;

procedure TShateM_QOS.ServiceStart(Sender: TService; var Started: Boolean);
var
  aConnection: TAdoConnection;
  FindRes:Integer;
  seachrec:TSearchRec;
  fname: string;
begin
  LogSnd('Начало обработки');

  if fDB_Discounts.TestMSSQLConnection then
  begin
    LogSnd('Проверка подключения к MSSQL (скидки)');
    aConnection := DBConnectNew(fDB_Discounts);
    DBDisconnectNew(aConnection);
  end;

  if fDB_Answers.TestMSSQLConnection then
  begin
    LogSnd('Проверка подключения к MSSQL (ответы)');
    aConnection := DBConnectNew(fDB_Answers);
    DBDisconnectNew(aConnection);
  end;

  fname:= ZipFilesPath + 'Rates.csv';
  FindRes := FindFirst(fname, faAnyFile, seachrec);
  try
    if FindRes = 0 then
      sDateKurses := DateToStr(FileDateToDateTime(seachrec.Time));
  finally
    FindClose(seachrec);
  end;

  TCPServer.Active := True;
  Started := True;
end;


procedure TShateM_QOS.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
//поддержка старых запросов
  if iUseNetDisk > 0 then
  begin
    WinExec(Pchar('net use '+LocalName+' /delete'),sw_hide);
    LogSnd('net use '+LocalName+' /delete');
  end;
//-------------------------

  Sleep(200);
  if ZipUseNetDisk > 0 then
  begin
    WinExec(Pchar('net use '+ZipLocalName+' /delete'),sw_hide);
    LogSnd('net use '+ZipLocalName+' /delete');
  end;

  LogSnd('конец обработки');
end;

procedure TShateM_QOS.TCPServerExecute(AContext: TIdContext);

  function DecodeAnswerQuery(const aQueryMsg: string; out aClientId: string; out aNum: string): Boolean;
  var
    p: Integer;
  begin
    Result := False;
    p := POS('_', aQueryMsg);
    if p > 0 then
    begin
      aClientId := Copy(aQueryMsg, 1, p - 1);
      aNum := Copy(aQueryMsg, p + 1, MaxInt);
      Result := ( Length(aClientId) > 1 ) and ( Length(aNum) > 3 );
    end;
  end;
  
//поддержка старых запросов ---------------------------------------------------//
  procedure SendFile(const aPath, aFileName: string; aHandler: TIdIOHandler);
  var
    F: TextFile;
    s: string;
  begin
    aHandler.Writeln('FILE');
    aHandler.Writeln(aFileName);

    AssignFile(F, IncludeTrailingPathDelimiter(aPath) + aFileName);
    Reset(F);
    try
      while not System.Eof(F) do
      begin
        System.Readln(F, s);
        aHandler.Writeln(s);
      end;
      aHandler.Writeln('ENDFILE');
    finally
      CloseFile(F);
    end;
  end;

  procedure TrySendFile(const aPath, aFileName: string; aHandler: TIdIOHandler);
  begin
    if FileExists(IncludeTrailingPathDelimiter(aPath) + aFileName) then
    begin
      LogSnd('Найден файл: ' + aFileName);
      SendFile(aPath, aFileName, aHandler)
    end
    else
      LogSnd('Не найден файл: ' + aFileName);
  end;

//***** новое для NAV ********************************************************//
  function DecodeCatalogQuery(const aQueryMsg: string; out aClientId: string; out aPK: string): Boolean;
  var
    p: Integer;
  begin
    Result := False;
    p := POS('_', aQueryMsg);
    if p > 0 then
    begin
      aClientId := Copy(aQueryMsg, 1, p - 1);
      aPK := Copy(aQueryMsg, p + 1, MaxInt);
      Result := ( Length(aClientId) > 1 ) and ( Length(aPK) > 3 );
    end;
  end;

  procedure TrySend_Versions(const aQueryMsg: string; aHandler: TIdIOHandler);
  var
    aClientId, aPK: string;
    errorCode: Integer;
    aRes: TClientVersions;
  begin
    errorCode := 0;

    try
      if not DecodeCatalogQuery(aQueryMsg, aClientId, aPK) then
      begin
        LogSnd('#Запрос не распознан: "' + aQueryMsg + '"');
        errorCode := -2;
        Exit;
      end;
    
      if Length(aPK) <> 32 then
      begin
        LogSnd('#Неверный public_key: "' + aQueryMsg + '"');
        errorCode := 1;    
        Exit;
      end;
      
      case GetClientVersions(aClientId, aPK, aRes) of
        0: //- OK;
        begin
          aHandler.Writeln('V_DISC=' + IntToStr(aRes.DISCOUNT_VER) );
          aHandler.Writeln('V_ADDR=' + IntToStr(aRes.ADDRESS_VER) );
          aHandler.Writeln('V_AGR=' + IntToStr(aRes.AGREEMENTS_VER) );
          LogSnd('>>>Запрос версий - OK');
        end;
        1: //- public_key не прошел идентификацию
        begin
          LogSnd('#Неверный public_key: "' + aQueryMsg + '"');
          errorCode := 1;
        end;

        2: //- клиент не найден по переданному ClientID
        begin
          LogSnd('#Клиент не найден в БД: "' + aQueryMsg + '"');
          errorCode := 2;
        end;

        -1: //- ошибка подключения к SQL-серверу
        begin
          {ошибка логируется в функции подключения DBConnect}
          errorCode := -1;
        end;
      end;
      
    finally
      if errorCode <> 0 then
        aHandler.Writeln('ERROR=' + IntToStr(errorCode));
    end;
  end;

  procedure TrySend_Catalog(const aQueryMsg: string; aHandler: TIdIOHandler; aCatalogType: TClientCatalogType);
  var
    aClientId, aPK: string;
    aCatalogVersion: Integer;
    errorCode: Integer;
    aStream: TMemoryStream;
  begin
    errorCode := 0;

    try
      if not DecodeCatalogQuery(aQueryMsg, aClientId, aPK) then
      begin
        LogSnd('#Запрос не распознан: "' + aQueryMsg + '"');
        errorCode := -2;
        Exit;
      end;

      if Length(aPK) <> 32 then
      begin
        LogSnd('#Неверный public_key: "' + aQueryMsg + '"');
        errorCode := 1;
        Exit;
      end;

      aStream := TMemoryStream.Create;
      try
        case GetClientCatalog(aClientId, aPK, aCatalogType, aCatalogVersion, aStream) of
          0: //- OK;
          begin
            aHandler.Writeln('VERSION=' + IntToStr(aCatalogVersion));
            aHandler.Writeln('BINFILE');
            aHandler.Write(aStream, 0{all stream}, True{aWriteByteCount});
            aHandler.Writeln('ENDFILE');

            LogSnd('>>>Запрос каталога - OK');
          end;
          1: //- public_key не прошел идентификацию
          begin
            LogSnd('#Неверный public_key: "' + aQueryMsg + '"');
            errorCode := 1;
          end;

          2: //- клиент не найден по переданному ClientID
          begin
            LogSnd('#Клиент не найден в БД: "' + aQueryMsg + '"');
            errorCode := 2;
          end;

          -1: //- ошибка подключения к SQL-серверу
          begin
            {ошибка логируется в функции подключения DBConnect}
            errorCode := -1;
          end;
        end;
      finally
        aStream.Free;
      end;

    finally
      if errorCode <> 0 then
        aHandler.Writeln('ERROR=' + IntToStr(errorCode));
    end;
  end;
//****************************************************************************//
  
//------------
  procedure TrySend_Discounts(const aQueryMsg: string; aHandler:  TIdIOHandler);
  var
    aClientInfo: TClientInfo;
    aDiscountsVersionDB: Integer;
    aStream: TMemoryStream;
    errorCode: Integer;
  begin
    errorCode := 0;
    if DecodeDiscountQuery(aQueryMsg, aClientInfo) then
    begin
      aStream := TMemoryStream.Create;
      try
        case GetClientDiscount(aClientInfo, aDiscountsVersionDB, aStream) of
          0: //- OK;
          begin
            if aClientInfo.DiscountsVersion < aDiscountsVersionDB then
            begin
              aHandler.Writeln('VERSION=' + IntToStr(aDiscountsVersionDB));
              aHandler.Writeln('BINFILE');
              aHandler.Write(aStream, 0{all stream}, True{aWriteByteCount});
              aHandler.Writeln('ENDFILE');

              LogSnd('>>>Запрос скидок - OK+');
            end
            else
              LogSnd('>>>Запрос скидок - OK');
          end;

          1: //- public_key не прошел идентификацию
          begin
            LogSnd('#Неверный public_key: "' + aQueryMsg + '"');
            errorCode := 1;
          end;

          2: //- клиент не найден по переданному ClientID
          begin
            LogSnd('#Клиент не найден в БД: "' + aQueryMsg + '"');
            errorCode := 2;
          end;

          -1: //- ошибка подключения к SQL-серверу
          begin
            {ошибка логируется в функции подключения DBConnect}
            errorCode := -1;
          end;
        end;
      finally
        aStream.Free;
      end;
    end
    else
    begin
      errorCode := -2;
      LogSnd('#Запрос не распознан: "' + aQueryMsg + '"');
    end;
    if errorCode <> 0 then
      aHandler.Writeln('ERROR=' + IntToStr(errorCode));
  end;

  procedure TrySend_Order(const aQueryMsg: string; aHandler: TIdIOHandler);
  var
    aClientId, aNum: string;
    aStreamZakazano, aStreamZameny: TMemoryStream;
  begin
    if not DecodeAnswerQuery(aQueryMsg, aClientId, aNum) then
    begin
      LogSnd('#Запрос не распознан: "' + aQueryMsg + '"');
      Exit;
    end;

    aStreamZakazano := TMemoryStream.Create;
    aStreamZameny := TMemoryStream.Create;
    try
      case GetClientOrder(aClientId, aNum, aStreamZakazano, aStreamZameny) of
        //- OK
        0:
        begin
          if aStreamZakazano.Size > 0 then
          begin
            aHandler.Writeln('ZAKAZANO');
            aHandler.Writeln('BINFILE');
            aHandler.Write(aStreamZakazano, 0{all stream}, True{aWriteByteCount});
            aHandler.Writeln('ENDFILE');
          end;

          if aStreamZameny.Size > 0 then
          begin
            aHandler.Writeln('ZAMENY');
            aHandler.Writeln('BINFILE');
            aHandler.Write(aStreamZameny, 0{all stream}, True{aWriteByteCount});
            aHandler.Writeln('ENDFILE');
          end;
          LogSnd('>>>Запрос заказа - OK+');
        end;

        //- документа еще нет
        1: LogSnd('документ не найден: "' + aQueryMsg + '"');

        //- ошибка подключения к SQL-серверу
       -1: ;{ошибка логируется в функции подключения DBConnect}
      end;
    finally
      aStreamZakazano.Free;
      aStreamZameny.Free;
    end;
  end;

  procedure TrySend_RetDoc(const aQueryMsg: string; aHandler: TIdIOHandler);
  var
    aClientId, aNum: string;
    aStream: TMemoryStream;
  begin
    if not DecodeAnswerQuery(aQueryMsg, aClientId, aNum) then
    begin
      LogSnd('#Запрос не распознан: "' + aQueryMsg + '"');
      Exit;
    end;

    aStream := TMemoryStream.Create;
    try
      case GetClientRetdoc(aClientId, aNum, aStream) of
        //- OK
        0:
        begin
          aHandler.Writeln('ZAKAZANO');
          aHandler.Writeln('BINFILE');
          aHandler.Write(aStream, 0{all stream}, True{aWriteByteCount});
          aHandler.Writeln('ENDFILE');
          LogSnd('>>>Запрос возврата - OK+');
        end;

        //- документа еще нет
        1: LogSnd('документ не найден: "' + aQueryMsg + '"');

        //- ошибка подключения к SQL-серверу
       -1: ;{ошибка логируется в функции подключения DBConnect}
      end;
    finally
      aStream.Free;
    end;                         
  end;

  procedure TrySend_OrderStatus(const aQueryMsg: string; aHandler: TIdIOHandler);
  var
    aClientId, aNum: string;
    aStreamZakazano, aStreamZameny: TMemoryStream;
  begin
    if not DecodeAnswerQuery(aQueryMsg, aClientId, aNum) then
    begin
      LogSnd('#Запрос не распознан: "' + aQueryMsg + '"');
      Exit;
    end;

    case GetClientOrderStatus(aClientId, aNum) of
      //- OK
      0:
      begin
        aHandler.Writeln('0');
        LogSnd('>>>Запрос статуса заказа - OK(0)');
      end;

      1:
      begin
        aHandler.Writeln('1');
        LogSnd('>>>Запрос статуса заказа - OK(1)');
      end;

      -1:
      begin
        aHandler.Writeln('-1');
        LogSnd('>>>Запрос статуса заказа - OK(-1)');
      end;

      //- ошибка подключения к SQL-серверу
     -2: ;{ошибка логируется в функции подключения DBConnect}
    end;
  end;

  procedure TrySend_OrderStatusBatch(const aQueryMsg: string; aHandler: TIdIOHandler);
  var
    aClientId, aNum, s: string;
    aStreamZakazano, aStreamZameny: TMemoryStream;
    sl: TStrings;
    i: Integer;
  begin
    sl := TStringList.Create;
    try

      // (<CLIENT_ID>_<DOC_NUM>,<CLIENT_ID>_<DOC_NUM>,<CLIENT_ID>_<DOC_NUM>...)
      if (aQueryMsg <> '') and
         (Copy(aQueryMsg, 1, 1) = '(') and
         (Copy(aQueryMsg, Length(aQueryMsg), 1) = ')') then
      begin
        sl.CommaText := Copy(aQueryMsg, 2, Length(aQueryMsg) - 2);
        for i := 0 to sl.Count - 1 do
        begin
          if not DecodeAnswerQuery(sl[i], aClientId, aNum) then
          begin
            LogSnd('#Запрос не распознан: "' + aQueryMsg + '"');
            Exit;
          end;
        end;
      end
      else
      begin
        LogSnd('#Запрос не распознан: "' + aQueryMsg + '"');
        Exit;
      end;

      if GetClientOrderStatusBatch(sl) = 0 then
      begin
        s := '';
        for i := 0 to sl.Count - 1 do
        begin
          if s = '' then
            s := sl.ValueFromIndex[i]
          else
            s := s + ',' + sl.ValueFromIndex[i];
        end;
        aHandler.Writeln(s);
        LogSnd('>>>Запрос статуса заказа - OK(' + s + ')');
      end;
    finally
      sl.Free;
    end;

  end;

  procedure TrySend_TTN(const aQueryMsg: string; aHandler: TIdIOHandler);
  var
    aStream: TMemoryStream;
    aNum: string;

    s, sign, sHesh: string;
    iFilePos, iPosFile: Integer;
  begin
    aNum := aQueryMsg;
    aStream := TMemoryStream.Create;
    try                                                      
      case GetClientTTN(aNum, aStream) of
        //- OK
        0:
        begin

          sign := '';
          while Length(sign) < 16 do
            sign := sign + IntToStr(Random(9));

          aHandler.Writeln(sign);
          
          iFilePos := 1;
          sHesh := '';
          s := aNum;
          for iPosFile := 1 to Length(sign) do
          begin
            if iFilePos > Length(s) then
              iFilePos :=1;

            if iPosFile > iPosFile then
              sHesh := sHesh + inttostr(((StrToInt(sign[iPosFile]+ IntToStr(StrToIntDef(s[iFilePos], 0)))*iFilePos) mod iPosFile))
            else
              sHesh := sHesh + inttostr(((StrToInt(sign[iPosFile]+ IntToStr(StrToIntDef(s[iFilePos], 0)))*iFilePos) div iPosFile));
            iFilePos := iFilePos + 1;
          end;

          s := aHandler.ReadlnWait;
          LogSnd('Хэш наш/присланный/номер заявки : ' + sHesh + ' / ' + s + ' / ' + aQueryMsg);
          if s <> sHesh then
            Exit;

          aHandler.Writeln('BINFILE');
          aHandler.Write(aStream, 0{all stream}, True{aWriteByteCount});
          aHandler.Writeln('ENDFILE');
          LogSnd('>>>Запрос ТТН - OK+');
        end;

        //- документа еще нет
        1: LogSnd('документ ТТН не найден: "' + aQueryMsg + '"');

        //- ошибка подключения к SQL-серверу
       -1: ;{ошибка логируется в функции подключения DBConnect}
      end;
    finally
      aStream.Free;
    end;
  end;

  procedure TrySend_RetDocTicket(const aQueryMsg: string; aHandler: TIdIOHandler);
  var
    aStream: TMemoryStream;
  begin
    aStream := TMemoryStream.Create;
    try                                                      
      if GetClientretDocTicket(aQueryMsg, aStream) then
      begin
        aHandler.Writeln('BINFILE');
        aHandler.Write(aStream, 0{all stream}, True{aWriteByteCount});
        aHandler.Writeln('ENDFILE');
        LogSnd('>>>Запрос талона на возврат - OK+');
      end
      else
     //- документа еще нет
        LogSnd('Талон на возврат не найден: "' + aQueryMsg + '"');
    finally
      aStream.Free;
    end;
  end;

  procedure TryToSendF7(aHandler: TIdIOHandler);
  var
    sValue, sNavReturnedValue: WideString;
    sClient: string;
    sign, s, sHesh, sQuants, sDate: string;
    i, j, p: integer;
    aStream: TStringStream;
    aList: TstringList;
    aCheckOrderOnly: Boolean;
  begin
    aStream := TStringStream.Create('');
    aList := TStringList.Create;

    try
      sValue := aHandler.ReadlnWait;
      sClient := aHandler.ReadlnWait;
      //хэш от ддоса
      sign := '';
      while Length(sign) < 30 do
        sign :=sign + inttostr(Random(9));
      aHandler.Writeln(sign);
      sHesh := '';
      s := sValue + sClient;
      j := 1;
      for i := 1 to Length(sign) do
      begin
        if j > Length(s) then
          j := 1;
        sHesh := sHesh + inttostr(((StrToInt(sign[i]+ s[j])*j) div i));
        inc(j);
      end;
      s:= aHandler.ReadlnWait;
      if s <> sHesh then
      begin
        aHandler.WriteLn('END');
        exit;
      end;
      // MAIN LOGIC
      try
        aHandler.WriteLn('NO_END');

        //Если вместо 1-ой позиции передан флаг, то сохраняем как лист
        sValue := aHandler.ReadlnWait;
        if sValue = cLIST_FOUND_MESSAGE then
        begin
          aHandler.ReadStream(aStream, -1, False);
          if aStream.Size > 0 then
          begin
            aStream.Position := 0;
            aList.LoadFromStream(aStream);
          end;
        end;

        aCheckOrderOnly := False;
        //Если передан лист
        if aList.Count > 0 then
        begin
          LogSnd('Обработка листа');
          aHandler.Write(ParseF7List(aList), 0, True);
          aHandler.WriteLn(cLIST_FOUND_MESSAGE);
          LogSnd('Обработка закончена');
          exit;
        end
        //Если передано ближайшая поставка
        else
        if Copy(sValue, 1, 1) = '@' then
        begin
          aCheckOrderOnly := True;
          Delete(sValue, 1, 1);
          LogSnd(sValue + '-[приход]');
          sNavReturnedValue := GetRecord(sValue);
        end
        //Если передано наличие
        else
        begin
          sValue := ReplaceCode(sValue); //подмена переименованных кодов
          LogSnd(sValue);
          sNavReturnedValue := (HTTPRIO as ServiceProg_Port).GetItemStock(sValue);
        end;
      except
        on E: Exception do
          LogSnd('Ошибка - ' + E.Message);
      end;

      sQuants := sNavReturnedValue;
      ////При запросе наличия кодируем наличие
      if not aCheckOrderOnly then
      begin
        sNavReturnedValue := DeCodeQuants(sNavReturnedValue);
        if (sNavReturnedValue = '') or (sNavReturnedValue = '-1') then
          sNavReturnedValue := '-2';
      end;

      LogSnd(sValue + ': ' + sQuants + ' (' + sNavReturnedValue + ')');
      aHandler.WriteLn(sNavReturnedValue);
    finally
      aStream.Free;
      aList.Free;
    end;
  end;

  procedure GetRates(aHandler: TIdIOHandler);
  var
    Query: TADOQuery;
    Connection:TADOConnection;
    ID: integer;
  begin
     Connection :=  DBConnectNew(fDB_Answers);
     Query := TADOQuery.Create(nil);
     try
       Query.Connection := Connection;
       Query.CursorLocation := clUseClient;
       Query.CursorType := ctStatic;
       Query.DisableControls;

       Query.SQL.Text :=
         ' SELECT RATE, CURRENCY FROM [CLIENT_DATA].[dbo].[RATES] ' +
         ' ORDER by [ORDER] ' ;
       Query.Open;

       aHandler.Writeln('FILE');
       aHandler.Writeln('Rates.csv');

       while not Query.Eof do
       begin
         aHandler.Writeln(Query.FieldByName('CURRENCY').AsString + ';' + Query.FieldByName('Rate').AsString);
         Query.Next;
       end;

       aHandler.Writeln('ENDFILE');
       aHandler.Writeln(FormatDateTime('dd.mm.yyyy hh:mm', Now()));

       Query.Close;
     finally
       Query.Free;
       DBDisconnectNew(Connection);
     end;
  end;

  procedure TrySend_NotUpdatedFile(aHandler: TIdIOHandler);
  var
    i: integer;
    aStream: TStringStream;
    aList: TstringList;
    aQuery: TAdoQuery;
    aConnection: TAdoConnection;
  begin
    aStream := TStringStream.Create('');
    aList := TStringList.Create;
    try
      aHandler.ReadStream(aStream, -1, False);
      if aStream.Size > 0 then
      begin
        aStream.Position := 0;
        aList.LoadFromStream(aStream);
        
        try
          aConnection := DBConnectNew(fDB_Discounts);
        except
          Exit;
        end;

        aQuery := TAdoQuery.Create(nil);
        try
          aQuery.Connection := aConnection;
          aQuery.CursorLocation := clUseServer;
          aQuery.CursorType := ctOpenForwardOnly;
          aQuery.SQL.Text :=
            ' INSERT INTO [NOT_RENAMED_TABLES] ([TABLE], [CLIENT_ID], [DATE], [MSG]) ' +
            ' VALUES (:TABLE, :CLIENT_ID, :DATE, :MSG) ';

          for i:=0 to aList.Count -1 do
          begin
            aQuery.Parameters[0].Value := ExtractDelimited(1,  aList[i], [';']);
            aQuery.Parameters[1].Value := ExtractDelimited(2,  aList[i], [';']);
            aQuery.Parameters[2].Value := ExtractDelimited(3,  aList[i], [';']);
            aQuery.Parameters[3].Value := Copy(ExtractDelimited(4,  aList[i], [';']), 1, 256);
            aQuery.ExecSQL;
          end;

        finally
          aQuery.Free;
        end;

      end;

    finally
      aStream.Free;
      aList.Free;
    end;
  end;

  procedure TrySend_TTN_FOR_RETDOC(const aQueryMsg: string; aHandler: TIdIOHandler);
  var
    aClientId, aNum: string;
    aStream: TStringStream;
    aNavXML, aErr: WideString;
  begin
    if not DecodeAnswerQuery(aQueryMsg, aClientId, aNum) then
    begin
      LogSnd('#Запрос не распознан: "' + aQueryMsg + '"');
      Exit;
    end;

    aStream := TStringStream.Create('');
    try
      //дерг вебсервиса НАВ
      aErr := '';
      (HTTPRIO as ServiceProg_Port).GetDirection(aClientId, aNavXML, aErr);
      if aErr <> '' then
        aNavXML := aErr;

      aStream.WriteString(aNavXML);
      aStream.Position := 0;

      aHandler.Writeln('TTN_FOR_RETDOC');
      aHandler.Writeln('BINFILE');
      aHandler.Write(aStream, 0{all stream}, True{aWriteByteCount});
      aHandler.Writeln('ENDFILE');
      LogSnd('>>>Запрос ТТН для возврата - OK+');
    finally
      aStream.Free;
    end;
  end;


var
  MessageText: string;
  F: TextFile;
  fname:string;
  s:string;

  //поддержка старых запросов
  binFile:TMemoryStream;
  iPosFile:integer;
  iFilePos:integer;
  sign, sHesh:string;
  FindRes:Integer;
  seachrec:TSearchRec;
begin
  with AContext.Connection do
  begin
    try //finally
      try //except
        IOHandler.MaxLineLength := 32 * 1024;
        try
          MessageText := IOHandler.ReadlnWait;
        except
          on E: Exception do
          begin
            if E.Message = 'Max line length exceeded.' then
            begin
              //логируем этот exception не чаще раза в минуту
              if GetTickCount - fLastExceptionTicks > 1000 * 60 then
              begin
                fLastExceptionTicks := GetTickCount;
                LogSnd('#!!!Exception: ' + E.Message);
              end;
            end
            else
              LogSnd('#Exception: ' + E.Message);

            Exit; //do disconnect in finally section
          end;
        end;

        LogSnd('<<<' + MessageText);

        
//***** новые запросы для NAV **************************************************
//1. запрос версий справочников клиента:
//>> VERSIONS_<id_клиента>_<открытый_ключ>
        if (StrLeft(MessageText, 9) = 'VERSIONS_') then
        begin
          LogSnd('Запрос версий справочников');
          MessageText := StrRight(MessageText, Length(MessageText) - 9);
          TrySend_Versions(MessageText, IOHandler);
        end
        
//2. Запрос справочника скидок:
//>> GET_DISC_<id_клиента>_<открытый_ключ>        
        //справочники - сделать забор через одну функцию
        else if (StrLeft(MessageText, 9) = 'GET_DISC_') then  
        begin
          LogSnd('Запрос справочника скидок');
          MessageText := StrRight(MessageText, Length(MessageText) - 9);
          TrySend_Catalog(MessageText, IOHandler, cctDiscounts);
        end
//3. Запрос справочника договоров:
//>> GET_AGR_<id_клиента>_<открытый_ключ>
        else if (StrLeft(MessageText, 8) = 'GET_AGR_') then
        begin
          LogSnd('Запрос справочника договоров');
          MessageText := StrRight(MessageText, Length(MessageText) - 8);
          TrySend_Catalog(MessageText, IOHandler, cctAgreements);
        end

//4. Запрос справочника адресов:
//>> GET_ADDR_<id_клиента>_<открытый_ключ>
        else if (StrLeft(MessageText, 9) = 'GET_ADDR_') then
        begin
          LogSnd('Запрос справочника адресов');
          MessageText := StrRight(MessageText, Length(MessageText) - 9);
          TrySend_Catalog(MessageText, IOHandler, cctAddress);
        end
        
//******************************************************************************
        
        
(*
        //*** ответ по скидкам ***
        else if (StrLeft(MessageText, 5) = 'DISC_') then  //DISC_<CLIENT_ID>_<PUBLIC_KEY>_<DISCOUNT_VERSION>
        begin
          LogSnd('Запрос скидок');
          MessageText :=  StrRight(MessageText, Length(MessageText) - 5);
          TrySend_Discounts(MessageText, IOHandler);
        end
*)
        //*** ответ по возвратам ***
        else if (StrLeft(MessageText, 6) = 'RETD1_') then //RETD<ver>_<CLIENT_ID>_<DOC_NUM>
        begin
          LogSnd('Запрос возврата');
          MessageText :=  StrRight(MessageText, Length(MessageText) - 6);
          TrySend_RetDoc(MessageText, IOHandler);
        end

        //*** ответ по заказу ***
        else if (StrLeft(MessageText, 6) = 'TEST1_') then //TEST<ver>_<CLIENT_ID>_<DOC_NUM>
        begin
          LogSnd('Запрос заказа');
          MessageText :=  StrRight(MessageText, Length(MessageText) - 6);
          TrySend_Order(MessageText, IOHandler);
        end
(*
        //*** статус заказа ***
        else if (StrLeft(MessageText, 8) = 'STATUS1_') then //STATUS<ver>_<CLIENT_ID>_<DOC_NUM>
        begin
          LogSnd('Запрос статуса заказа');
          MessageText :=  StrRight(MessageText, Length(MessageText) - 8);
          TrySend_OrderStatus(MessageText, IOHandler);
        end

        //*** пачка статусов заказа ***
        else if (StrLeft(MessageText, 14) = 'BATCH_STATUS1_') then //BATCH_STATUS<ver>_(<CLIENT_ID>_<DOC_NUM>[,<CLIENT_ID>_<DOC_NUM>])
        begin
          LogSnd('Запрос пачки статусов заказов');
          MessageText :=  StrRight(MessageText, Length(MessageText) - 14);
          TrySend_OrderStatusBatch(MessageText, IOHandler);
        end
*)
        //*** ответ по накладным ***
        else if (MessageText = 'EXCEL_ACK1') then
        begin
          LogSnd('Запрос ТТН');

          s:= IOHandler.ReadlnWait;
          TrySend_TTN(s, IOHandler);
        end

        //*** ответ по талонам на возврат ***
        else if (MessageText = 'RetDocTicket_ACK') then
        begin
          LogSnd('Запрос талона на возврат');

          s := IOHandler.ReadlnWait;
          TrySend_RetDocTicket(s, IOHandler);
        end

   //*** ответ по курсам розница (рынки\магазины)***
        else if (MessageText = 'STOCK_KURSES_ACK') then
          GetRates(IOHandler)

        //*** ответ по наличию ***
        else if (MessageText = 'F7_ACK') then
        begin
          LogSnd('F7');
          TryToSendF7(IOHandler);
        end

        //*** Логирование ошибок обновления ***
        else if (MessageText = 'NOT_UPDATED_FILE_ACK') then
        begin
          LogSnd('NOT_UPDATED_FILE_ACK');
          TrySend_NotUpdatedFile(IOHandler);
        end

        //*** Получить данные ТТН для возврата ***
        else if (StrLeft(MessageText, 15) = 'TTN_FOR_RETDOC_') then //TTN_FOR_RETDOC_<id_клиента>_<0>
        begin
          LogSnd('Данные ТТН для возврата');
          MessageText := StrRight(MessageText, Length(MessageText) - 15);
          TrySend_TTN_FOR_RETDOC(MessageText, IOHandler);
        end;

//- поддержка старых запросов --------------------------------------------------
(*
        // *** ответ по возвратам ***
        else if (StrLeft(MessageText, 5) = 'RETD_') then
        begin
          LogSnd('Запрос возврата(old)');
          MessageText :=  StrRight(MessageText, Length(MessageText) - 5);
          //fname := 'RETD_' + MessageText + '.csv';
          //возвраты называются также как и заказы (и имеют то же содержимое)
          fname := 'Zakazano_' + MessageText + '.csv';
          TrySendFile(FilesPath, fname, IOHandler);
        end

        //*** ответ по заказу ***
        else if (StrLeft(MessageText, 5) = 'TEST_') then
        begin
          LogSnd('Запрос заказа(old)');
          MessageText :=  StrRight(MessageText, Length(MessageText) - 5);
          fname := 'Zakazano_' + MessageText + '.csv';
          TrySendFile(FilesPath, fname, IOHandler);

          fname := 'Zameny_' + MessageText + '.csv';
          TrySendFile(FilesPath, fname, IOHandler);
        end

        //*** ответ по накладным ***
        else if (MessageText = 'EXCEL_ACK') then
        begin
          LogSnd('Запрос ТТН(old)');
          s:= IOHandler.ReadlnWait;
          fname:= ZipFilesPath+'*-'+s+'-*.zip';
          LogSnd('Ищем ='+fname);
          FindRes := FindFirst(fname,faAnyFile,seachrec);
          if FindRes = 0 then
          begin
            fname:= ZipFilesPath+seachrec.Name;
          end;
          FindClose(seachrec);

          if FileExists(fname) then
          begin
            LogSnd('Найден файл : ' + fname);
            binFile := TMemoryStream.Create;
            try
              sign:='';
              while Length(sign)<16 do
                sign :=sign+inttostr(Random(9));

              IOHandler.Writeln(sign);
              iFilePos:=1;
              sHesh:='';
              for iPosFile:=1 to Length(sign) do
              begin
                if iFilePos > Length(s) then
                  iFilePos :=1;

                if iPosFile > iPosFile then
                  sHesh := sHesh + inttostr(((StrToInt(sign[iPosFile]+ s[iFilePos])*iFilePos) mod iPosFile))
                else
                  sHesh := sHesh + inttostr(((StrToInt(sign[iPosFile]+ s[iFilePos])*iFilePos) div iPosFile));
                iFilePos := iFilePos+1;
              end;

              s:= IOHandler.ReadlnWait;
              LogSnd('Наш Хеш: '+sHesh);
              LogSnd('Присланный Хеш: '+s);
              if s = sHesh then
              begin
                IOHandler.Writeln('FILE');
                IOHandler.WriteBufferOpen;
                binFile.LoadFromFile(fname);
                IOHandler.Write(binFile);
                IOHandler.WriteBufferClose;
              end;
            finally
              binFile.Free;
            end;
          end
          else
            LogSnd('Не найден файл ZIP: '+fname);
        end;
*)
//----------------------------------------------------------------------------//

        IOHandler.WriteLn('END');

      except
        on E: EIdConnClosedGracefully do
        begin
          LogSnd('#Exception+: ' + e.Message);
          raise;
        end;
        on E: Exception do
        begin
          LogSnd('#Exception: ' + e.Message);
        end;
      end;
    finally
      Disconnect;
    end;
  end;
end;

procedure TShateM_QOS.UpdateF7Table(const aAction: TQueryActionType;
  const aCode, aAnswer: string; const aID: integer);
var
  aQuery: TAdoQuery;
  aConnection: TAdoConnection;
begin
  try
    aConnection := DBConnectNew(fDB_Discounts);
  except
    on E: Exception do
    begin
        LogSnd('Ошибка - '+e.Message);
        Exit;
    end;
  end;

  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := aConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;

    if aAction = qatUpdate then
    begin
      aQuery.SQL.Text :=
        ' UPDATE [WL_QUERIES] SET ' +
        ' ANSWER = :ANSWER, DATE_CREATE = :DATE_CREATE ' +
        ' WHERE ID = :ID ';
      aQuery.Parameters[0].Value := aAnswer;
      aQuery.Parameters[1].Value := Now();
      aQuery.Parameters[2].Value := aID;
      aQuery.ExecSQL;
    end
    else
    if aAction = qatInsert then
    begin
      aQuery.SQL.Text :=
        ' INSERT INTO [WL_QUERIES] (QUERY, ANSWER, DATE_CREATE)' +
        ' VALUES (:QUERY, :ANSWER, :DATE_CREATE) ';
      aQuery.Parameters[0].Value := aCode;
      aQuery.Parameters[1].Value := aAnswer;
      aQuery.Parameters[2].Value := Now();
      aQuery.ExecSQL;
    end;

    aQuery.Close;
  finally
    aQuery.Free;
    DBDisconnectNew(aConnection);
  end;
end;

procedure TShateM_QOS.WriteDummyCatalog(aCatalogType: TClientCatalogType; aPrivateKey: string; aRes: TStream);
var
  aPath, aFileName: string;
  aStream: TMemoryStream;
  aZipper: TVCLZip;
begin
  case aCatalogType of
    cctDiscounts:  aFileName := 'discounts';
    cctAgreements: aFileName := 'agreements';
    cctAddress:    aFileName := 'address';
  end;

  aPath := IncludeTrailingPathDelimiter( ExtractFilePath(ParamStr(0)) );

  //пакуем сразу в потоке
  aZipper := TVCLZip.Create(nil);
  aStream := TMemoryStream.Create;
  try
    try
      if not FileExists(aPath + aFileName + '.csv') then
        raise Exception.CreateFmt('Файл не найден "%s"', [aPath + aFileName + '.csv']);
      aStream.LoadFromFile(aPath + aFileName + '.csv');
      aStream.Position := 0;
                                                                                         
      aZipper.Password := aPrivateKey; //private key как пароль
      aZipper.ArchiveStream := aRes;
      aZipper.ZipFromStream(aStream, aFileName);
      aZipper.ArchiveStream := nil;
    except
      on E: Exception do
        LogSnd('!Exception (WriteDummyCatalog): ' + E.Message);
    end;
  finally
    aZipper.Free;
    aStream.Free;
  end;
end;

procedure TShateM_QOS.LogSnd(s: string);
var
  FLog: TextFile;
begin
  fLogLock.Enter;
  try
    AssignFile(FLog, flogname);
    if not FileExists(flogname) then
      Rewrite(FLog)
    else
      Append(FLog);
    try
      WriteLn(FLog, FormatDateTime('dd.mm.yyyy hh:nn:ss', Now) + ': ' + s);
    finally
      CloseFile(FLog);
    end;
  finally
    fLogLock.Leave;
  end;
end;

function TShateM_QOS.ParseF7List(const aF7List: TStringList): TStream;
var
  i, iID, iAction: integer;
  aListOut: TStringList;
  sValue, sDecoded: WideString;

begin
  Result := TStringStream.Create('');
  iID := -1;
  aListOut := TStringList.Create;
  try
    for i:= 0 to aF7List.Count - 1 do
    begin
      try
        sValue := GetRecord(aF7List[i]);
        if sValue <> '-1' then
        begin
          aListOut.Append(aF7List[i] + '=' + sValue);
          LogSnd(aF7List[i] + ': ' + sValue);
        end;
      except
        on E: Exception do
        begin
          LogSnd('Ошибка - ' + E.Message);
          aListOut.Append(aF7List[i] + '=' + '?');
        end;
      end;
    end;

    if aListOut.Count > 0 then
      Result := TStringStream.Create(aListOut.Text);

  finally
    aListOut.Free;
  end;
end;

function TShateM_QOS.StrLeft(s:string; i:integer):string;
 var j:integer;
     itog:string;
begin
   itog := '';
   j := length(s);
   if i<j then
      while i>0 do
       begin
         itog := s[i] + itog;
         i:=i-1;
       end
   else
       itog := s;

    StrLeft := itog;
end;

function TShateM_QOS.StrRight(s:string; i:integer):string;
var j:integer;
     itog:string;
begin
   i := i-1;
   itog := '';
   j := length(s);
   if i<j then
      while i>-1 do
       begin
         itog := itog + s[j-i];
         i:=i-1;
       end
   else
       itog := s;
   StrRight := itog;
end;

(*
procedure TShateM_QOS.DBConnect(const aConnectInfo: TDBConnectInfo);
begin
 if not fCoInitialized then
    CoInitialize(nil); //откомментить если выполняется не в основном потоке
  fCoInitialized := True;

  aConnectInfo.Connection.Connected := False;
  aConnectInfo.Connection.ConnectionString :=
    cAMDConnectionString +
    Format(cCustomAutorityParams, [aConnectInfo.SqlServerName, aConnectInfo.DatabaseName, aConnectInfo.DBUser, aConnectInfo.DBPassword]);
  try
    aConnectInfo.Connection.Connected := True;
  except
    on E: Exception do
    begin
      LogSnd('#Ошибка подключения к SQL-серверу: ' + E.Message);
      raise;
    end;
  end;
end;

procedure TShateM_QOS.DBDisconnect(const aConnectInfo: TDBConnectInfo);
begin
  aConnectInfo.Connection.Connected := False;
//  CoUninitialize; //откомментить если выполняется не в основном потоке
end;
*)

function TShateM_QOS.DBConnectNew(const aConnectInfo: TDBConnectInfo): TAdoConnection;
begin
// if not fCoInitialized then
//    CoInitialize(nil); //откомментить если выполняется не в основном потоке
//  fCoInitialized := True;
  try

    try
      Result := TAdoConnection.Create(nil);
    except
      on E: EOleSysError do
      begin
        //LogSnd('EOleSysError, code = ' + Format('%d', [E.ErrorCode]));
        if E.ErrorCode = -2147221008 then //$800401F0
        begin
          LogSnd('CoInitializeEx(nil, COINIT_MULTITHREADED)');
          CoInitializeEx(nil, COINIT_MULTITHREADED);
          Result := TAdoConnection.Create(nil);
        end
        else
          raise;
      end;

      on E: Exception do
        raise;
    end;

  except
    on E: Exception do
    begin
      LogSnd('#Ошибка создания TAdoConnection: ' + E.Message);
      raise;
    end;
  end;


  
  Result.ConnectionString :=
    cAMDConnectionString +
    Format(cCustomAutorityParams, [aConnectInfo.SqlServerName, aConnectInfo.DatabaseName, aConnectInfo.DBUser, aConnectInfo.DBPassword]);

  try
    Result.Connected := True;
  except
    on E: Exception do
    begin
      LogSnd('#Ошибка подключения к SQL-серверу: ' + E.Message);
      Result.Free;
      Result := nil;
      raise;
    end;
  end;
  
end;

procedure TShateM_QOS.DBDisconnectNew(var aConnection: TAdoConnection);
begin
  if Assigned(aConnection) then
  begin
    aConnection.Connected := False;
    aConnection.Free;
    aConnection := nil;
  end;
end;

//проверяет идентичность по private_key
function TShateM_QOS.CheckPublicKey(const aClientID, aPublicKey,
  aPrivateKey: string): Boolean;
begin
  Result := MD5.MD5DigestToStr( MD5.MD5String(aClientID + aPrivateKey) ) = aPublicKey;
end;


//забирает из БД ответ по каталогу
//Result:
//  0 - OK;
//  1 - private_key не прошел идентификацию
//  2 - клиент не найден по переданному ClientID
// -1 - ошибка подключения к SQL-серверу
function TShateM_QOS.GetClientCatalog(const aClientID, aPublicKey: string; aCatalogType: TClientCatalogType; 
  out aVersion: Integer; aRes: TStream): Integer;
var
  aConnection: TAdoConnection;
  aQuery: TAdoQuery;
  aPrivateKey: string;
  aVersionField, aRespondField: string;
begin
  try
    aConnection := DBConnectNew(fDB_Discounts);
  except
    Result := -1;
    Exit;
  end;

  case aCatalogType of
    cctDiscounts:
    begin
//      aVersionField := 'DISCOUNTS_VER';
//      aRespondField := 'DISCOUNTS_ZIP';
      aVersionField := 'DISCOUNT_VER';
      aRespondField := 'RESPOND_ZIP';
    end;
    cctAgreements:
    begin
      aVersionField := 'AGREEMENTS_VER';
      aRespondField := 'AGREEMENTS_ZIP';
    end;
    cctAddress:
    begin
      aVersionField := 'ADDRESS_VER';
      aRespondField := 'ADDRESS_ZIP';
    end;
  end;
  
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := aConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.SQL.Text :=
      ' SELECT PRIVATE_KEY, ' + aVersionField + ', ' + aRespondField + ' FROM CLIENTS WHERE CLIENT_ID = :CLIENT_ID ';
    aQuery.Parameters[0].Value := aClientID;
    aQuery.Open;
    if aQuery.Eof then
    begin
      Result := 2;
      Exit;
    end
    else
    begin
      aPrivateKey := aQuery.FieldByName('PRIVATE_KEY').AsString;
      aVersion := aQuery.FieldByName(aVersionField).AsInteger;
      TBlobField(aQuery.FieldByName(aRespondField)).SaveToStream(aRes);

      //заглушка для тестирования !!!!!!!!!!!!!!!!!!!!!!!!!!
      //забираем файлы из папки где лежит служба и пакуем с паролем = PrivateKey
      //WriteDummyCatalog(aCatalogType, aPrivateKey, aRes);
      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    end;
    aQuery.Close;

    if not CheckPublicKey(aClientID, aPublicKey, aPrivateKey) then
      Result := 1
    else
      Result := 0;
  finally
    aQuery.Free;
    DBDisconnectNew(aConnection);
  end;
end;


function TShateM_QOS.GetClientDiscount(const aClientInfo: TClientInfo;
  out aVersion: Integer; aRes: TStream): Integer;
var
  aConnection: TAdoConnection;
  aQuery: TAdoQuery;
  aPrivateKey: string;
begin
  try
    aConnection := DBConnectNew(fDB_Discounts);
  except
    Result := -1;
    Exit;
  end;
  
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := aConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.SQL.Text :=
      ' SELECT PRIVATE_KEY, DISCOUNT_VER, RESPOND_ZIP FROM CLIENTS WHERE CLIENT_ID = :CLIENT_ID ';
    aQuery.Parameters[0].Value := aClientInfo.ClientID;
    aQuery.Open;
    if aQuery.Eof then
    begin
      Result := 2;
      Exit;
    end
    else
    begin
      aPrivateKey := aQuery.FieldByName('PRIVATE_KEY').AsString;
      aVersion := aQuery.FieldByName('DISCOUNT_VER').AsInteger;
      TBlobField(aQuery.FieldByName('RESPOND_ZIP')).SaveToStream(aRes);
    end;
    aQuery.Close;

    if not CheckPublicKey(aClientInfo.ClientID, aClientInfo.PublicKey, aPrivateKey) then
      Result := 1
    else
      Result := 0;
  finally
    aQuery.Free;
    DBDisconnectNew(aConnection);
  end;
end;

//декодирует строку запроса скидок (<CLIENT_ID>_<PUBLIC_KEY>_<DISCOUNT_VERSION>)
function TShateM_QOS.DecodeDiscountQuery(const aQueryMsg: string; out aClientInfo: TClientInfo): Boolean;
var
  i, p: Integer;
  s, sClientID, sPublicKey, sVersion: string;
begin
  Result := False;
  s := aQueryMsg;

  p := POS('_', s);
  if p = 0 then
    Exit;
  sClientID := Copy(s, 1, p - 1);
  Delete(s, 1, p);

  p := POS('_', s);
  if p = 0 then
    Exit;
  sPublicKey := Copy(s, 1, p - 1);
  Delete(s, 1, p);

  sVersion := s;

  if StrToIntDef(sVersion, -1) = -1 then
    Exit;
  if Length(sPublicKey) <> 32 then
    Exit;
  for i := 1 to Length(sClientID) do
    if not (sClientID[i] in ['0'..'9']) then
      Exit;

  aClientInfo.ClientID := sClientID;
  aClientInfo.PublicKey := sPublicKey;
  aClientInfo.DiscountsVersion := StrToIntDef(sVersion, -1);
  Result := True;
end;


function TShateM_QOS.EncodeOrderOnly(const aValue: string): string;
var
  p: integer;
  sDate, sQuant: string;
begin
{ *** Варианты от ВэбСервиса ***
«-1» -> Товар не найден!!!
«Товар %1 не заказан» -> Не заказан
«Количество_Дата»  - true
«Поставщик не отгружает с %1» ->  Поставщик не отгружает с %1
«-» -> Не заказан
Номер 2 -> Товар не найден!!!
Огромное INT значение вида 738275482374237589072305723 - Товар не найден!!!
Пустоту - Товар не найден!!!
}
  if aValue = '-1' then
  begin
    Result := 'Товар не найден!';
    Exit;
  end;

  sDate := '';
  p := POS('_', aValue);
  if p > 0 then
  begin
    sDate := Copy(aValue, p + 1, MaxInt){дата};
    if sDate <> '' then
    begin
      sQuant := DeCodeQuants(Copy(aValue, 1, p - 1));
      if sQuant = '' then // '-2' - не возим/не заказано
        Result := 'Товар не заказан!'
      else
        Result := 'Ожидается: ' + sQuant + ' ' + sDate
    end;
  end
  else if (aValue = '-') or (pos('не заказан' ,aValue) > 0) then
    Result := 'Товар не заказан'
  else
    Result := aValue;
end;

function TShateM_QOS.DeCodeQuants(const aQuant: string): string;
var
  i, iLen, iQuant: Integer;
begin
  Result := '';
  if aQuant <> '' then
  begin
    iLen := Length(aQuant);
    for i := 1 to iLen do
      if aQuant[i] in ['1'..'9', '0', '-'] then
        Result := Result + aQuant[i];

    iQuant := StrToIntDef(Result, -1);
    if (iQuant >= 10) and (iQuant < 50) then
      Result := '10>'
    else
      if (iQuant >= 50) and (iQuant < 100) then
        Result := '50>'
      else
        if (iQuant >= 100) then
          Result := '100>';
  end
end;


function TShateM_QOS.ReplaceCode(aCodeBrand: string): string;
begin
  Result := fCodesMap.Values[AnsiUpperCase(aCodeBrand)];
  if Result = '' then
    Result := aCodeBrand;
end;

//****************************************************************************//
//забирает из БД ответ по заказу
//Result:
//  0 - OK;
//  1 - документ не найден
// -1 - ошибка подключения к SQL-серверу
function TShateM_QOS.GetClientOrder(const aClientID, aNum: string;
  aResZakazano, aResZameny: TStream): Integer;
var
  aQuery: TAdoQuery;
  aConnection: TAdoConnection;
begin
  try
    aConnection := DBConnectNew(fDB_Answers);
  except
    Result := -1;
    Exit;
  end;

  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := aConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.SQL.Text :=
      ' SELECT DATA, FILE_TYPE FROM FILES ' +
      ' WHERE CLIENT_ID = :CLIENT_ID AND ' +
      '       NUM = :NUM AND ' +
      '       (FILE_TYPE = :FILE_TYPE1 OR FILE_TYPE = :FILE_TYPE2) ';
    aQuery.Parameters[0].Value := aClientID;
    aQuery.Parameters[1].Value := aNum;
    aQuery.Parameters[2].Value := Ord(fdtZakazano);
    aQuery.Parameters[3].Value := Ord(fdtZameny);
    aQuery.Open;
    if aQuery.Eof then
    begin
      Result := 1;
      Exit;
    end;

    while not aQuery.Eof do
    begin
      if aQuery.FieldByName('FILE_TYPE').AsInteger = Ord(fdtZakazano) then
        TBlobField(aQuery.FieldByName('DATA')).SaveToStream(aResZakazano)
      else
        TBlobField(aQuery.FieldByName('DATA')).SaveToStream(aResZameny);
      aQuery.Next;
    end;
    Result := 0;

    aQuery.Close;
  finally
    aQuery.Free;
    DBDisconnectNew(aConnection);
  end;
end;


//забирает из БД статус заказа, если не определен - ставит в очередь на опрос вебсервиса (другая служба)
//Result:
//  0 - не уехал
//  1 - уехал клиенту
// -1 - документ не найден в Лотус-базе
// -2 - ошибка подключения к SQL-серверу
function TShateM_QOS.GetClientOrderStatus(const aClientID,
  aNum: string): Integer;
var
  aQuery: TAdoQuery;
  aConnection: TAdoConnection;
begin
  Result := 0;

  try
    aConnection := DBConnectNew(fDB_Answers);
  except
    Result := -2;
    Exit;
  end;

  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := aConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.SQL.Text :=
      ' SELECT ID, CLIENT_ID, IS_DELIVERED FROM ORDER_STATUSES ' +
      ' WHERE CLIENT_ID = :CLIENT_ID AND ' +
      '       NUM = :NUM ';
    aQuery.Parameters[0].Value := aClientID;
    aQuery.Parameters[1].Value := aNum;
    aQuery.Open;
    if aQuery.Eof then //не найден - поставить в очередь на опрос
    begin
      Result := 0;

      aQuery.Close;
      aQuery.SQL.Text :=
        ' INSERT INTO ORDER_STATUSES ( CLIENT_ID,  NUM,  REQUEST_DATE) ' +
        '                     VALUES (:CLIENT_ID, :NUM, :REQUEST_DATE) ';

      aQuery.Parameters[0].Value := aClientID;
      aQuery.Parameters[1].Value := aNum;
      aQuery.Parameters[2].Value := Now;
      aQuery.ExecSQL;
    end
    else
      Result := aQuery.FieldByName('IS_DELIVERED').AsInteger;

    aQuery.Close;
  finally
    aQuery.Free;
    DBDisconnectNew(aConnection);
  end;
end;


//забирает из БД пачку статусов заказа, если не определен - ставит в очередь на опрос вебсервиса (другая служба)
//Result:
//  0 - OK
// -2 - ошибка подключения к SQL-серверу
//aQueryes - список в формате <CLIENT_ID>_<DOC_NUM>
//результат запишется как value для каждого ключа в aQueryes //e.g. <CLIENT_ID>_<DOC_NUM>=0
function TShateM_QOS.GetClientOrderStatusBatch(aQueryes: TStrings): Integer;

  function DecodeKey(const aKey: string; out aClientId: string; out aNum: string): Boolean;
  var
    p: Integer;
  begin
    Result := False;
    aClientId := '';
    aNum := '';
    
    p := POS('_', aKey);
    if p > 0 then
    begin
      aClientId := Copy(aKey, 1, p - 1);
      aNum := Copy(aKey, p + 1, MaxInt);
      Result := ( Length(aClientId) > 3 ) and ( Length(aNum) > 3 );
    end;
  end;

var
  aQuery: TAdoQuery;
  aConnection: TAdoConnection;
  i: Integer;
  aWhere, s, aClient, aNum: string;
begin
  Result := 0;

  try
    aConnection := DBConnectNew(fDB_Answers);
  except
    Result := -2;
    Exit;
  end;

  aWhere := '';
  for i := 0 to aQueryes.Count - 1 do
  begin
    DecodeKey(aQueryes[i], aClient, aNum);
    s := '(CLIENT_ID = ''' + aClient + ''' AND NUM = ''' + aNum + ''')';

    if aWhere = '' then
      aWhere := s
    else
      aWhere := aWhere + ' OR ' + s;

    aQueryes[i] := aQueryes[i] + '='; //чтобы отработал aQueryes.IndexOfName
  end;

  aQuery := TAdoQuery.Create(nil);
  try
    try
    aQuery.Connection := aConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.SQL.Text :=
      ' SELECT ID, CLIENT_ID, NUM, IS_DELIVERED FROM ORDER_STATUSES ' +
      ' WHERE ' + aWhere;
    aQuery.Open;
    while not aQuery.Eof do
    begin
      s := aQuery.FieldByName('CLIENT_ID').AsString + '_' + aQuery.FieldByName('NUM').AsString;
      aQueryes.Values[s] := IntToStr(aQuery.FieldByName('IS_DELIVERED').AsInteger); //AsString даст '' для NULL - aQueryes.Values[s] при этом удалит строку
      aQuery.Next;
    end;
    aQuery.Close;
    except
      on E: Exception do
      begin
        LogSnd('GetClientOrderStatusBatch: ' + E.Message);
        raise;
      end;
    end;
    //поставить в очередь на опрос
    for i := 0 to aQueryes.Count - 1 do
    begin
      if aQueryes.ValueFromIndex[i] = '' then //статуса нет
      begin
        aQueryes.ValueFromIndex[i] := '0';
        aQuery.Close;
        aQuery.SQL.Text :=
          ' INSERT INTO ORDER_STATUSES ( CLIENT_ID,  NUM,  REQUEST_DATE) ' +
          '                     VALUES (:CLIENT_ID, :NUM, :REQUEST_DATE) ';
        DecodeKey(aQueryes.Names[i], aClient, aNum);
        aQuery.Parameters[0].Value := aClient;
        aQuery.Parameters[1].Value := aNum;
        aQuery.Parameters[2].Value := Now;
        aQuery.ExecSQL;
        aQuery.Close;
      end;
    end;

    Result := 0;
  finally
    aQuery.Free;
    DBDisconnectNew(aConnection);
  end;
end;

//забирает из БД ответ по возврату
//Result:
//  0 - OK;
//  1 - документ не найден
// -1 - ошибка подключения к SQL-серверу
function TShateM_QOS.GetClientRetdoc(const aClientID, aNum: string;
  aRes: TStream): Integer;
var
  aQuery: TAdoQuery;
  aConnection: TAdoConnection;
begin
  try
    aConnection := DBConnectNew(fDB_Answers);
  except
    Result := -1;
    Exit;
  end;
  
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := aConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.SQL.Text :=
      ' SELECT DATA, FILE_TYPE FROM FILES ' +
      ' WHERE CLIENT_ID = :CLIENT_ID AND ' +
      '       NUM = :NUM AND ' +
      '       FILE_TYPE = :FILE_TYPE ';
    aQuery.Parameters[0].Value := aClientID;
    aQuery.Parameters[1].Value := aNum;
    aQuery.Parameters[2].Value := Ord(fdtZakazano);
    aQuery.Open;
    if aQuery.Eof then
    begin
      Result := 1;
      Exit;
    end;

    TBlobField(aQuery.FieldByName('DATA')).SaveToStream(aRes);
    Result := 0;

    aQuery.Close;
  finally
    aQuery.Free;
    DBDisconnectNew(aConnection);
  end;
end;

function TShateM_QOS.GetClientretDocTicket(const aNum: string;
  aRes: TMemoryStream): boolean;
var
  aFileName: string;
begin
  aFileName := PDFRetDocTicketFilesPath + cUnicIDRetDocTicket + '_' + aNum + '.pdf';
  result := FileExists(aFileName);
  if result then
    aRes.LoadFromFile(aFileName);
end;

//забирает из БД ответ по ТТН
//Result:
//  0 - OK;
//  1 - документ не найден
// -1 - ошибка подключения к SQL-серверу
function TShateM_QOS.GetClientTTN(const aNum: string; aRes: TStream): Integer;
var
  aQuery: TAdoQuery;
  aConnection: TAdoConnection;
begin
  try
    aConnection := DBConnectNew(fDB_Answers);
  except
    Result := -1;
    Exit;
  end;
  
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := aConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.SQL.Text :=
      ' SELECT DATA FROM TTN ' +
      ' WHERE FILE_NAME LIKE ''%-' + aNum + '-%'' ' +
      ' ORDER BY FILE_DATE DESC ';
    aQuery.Open;
    if aQuery.Eof then
    begin
      Result := 1;
      Exit;
    end;
    
    TBlobField(aQuery.FieldByName('DATA')).SaveToStream(aRes);
    Result := 0;

    aQuery.Close;
  finally
    aQuery.Free;
    DBDisconnectNew(aConnection);
  end;
end;


function TShateM_QOS.GetClientVersions(const aClientID, aPublicKey: string;
  out aRes: TClientVersions): Integer;
var
  aConnection: TAdoConnection;
  aQuery: TAdoQuery;
  aPrivateKey: string;
begin
  try
    aConnection := DBConnectNew(fDB_Discounts);
  except
    Result := -1;
    Exit;
  end;
  
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := aConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.SQL.Text :=
      ' SELECT PRIVATE_KEY, DISCOUNTS_VER, ADDRESS_VER, AGREEMENTS_VER, DISCOUNT_VER FROM CLIENTS WHERE CLIENT_ID = :CLIENT_ID ';
    aQuery.Parameters[0].Value := aClientID;
    aQuery.Open;
    if aQuery.Eof then
    begin
      Result := 2;
      Exit;
    end
    else
    begin
      aPrivateKey := aQuery.FieldByName('PRIVATE_KEY').AsString;
      aRes.DISCOUNT_VER := aQuery.FieldByName('DISCOUNT_VER').AsInteger;//aQuery.FieldByName('DISCOUNTS_VER').AsInteger;
      aRes.ADDRESS_VER := aQuery.FieldByName('ADDRESS_VER').AsInteger;
      aRes.AGREEMENTS_VER := aQuery.FieldByName('AGREEMENTS_VER').AsInteger;
    end;
    aQuery.Close;

    if not CheckPublicKey(aClientID, aPublicKey, aPrivateKey) then
      Result := 1
    else
      Result := 0;
  finally
    aQuery.Free;
    DBDisconnectNew(aConnection);
  end;
end;

function TShateM_QOS.GetF7RecordFromTable(const aCode: string; out aID,
  aActionID: integer): string;
var
  aQuery: TAdoQuery;
  aConnection: TAdoConnection;
begin
  Result := '';

  try
    aConnection := DBConnectNew(fDB_Discounts);
  except
    aActionID := cERROR;
    Exit;
  end;

  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := aConnection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.SQL.Text :=
      ' SELECT ID, ANSWER, DATE_CREATE FROM [WL_QUERIES] ' +
      ' WHERE QUERY = :QUERY ';
    aQuery.Parameters[0].Value := aCode;
    aQuery.Open;

    aQuery.First;

    if aQuery.Eof then
      aActionID := cNOT_EXIST
    else
    begin
      aID := aQuery.FieldByName('ID').AsInteger;
      if HoursBetween(Now(), aQuery.FieldByName('DATE_CREATE').AsDateTime) < fTimeValidCash then
      begin
        aActionID := cEXIST;
        Result := aQuery.FieldByName('ANSWER').AsString;
      end
      else
        aActionID := cEXIST_UPDATE;
    end;

    aQuery.Close;
  finally
    aQuery.Free;
    DBDisconnectNew(aConnection);
  end;
end;

function TShateM_QOS.GetRecord(aCodeBrand: string): string;

  function FindItem(const aCodeBrand: string): string;
  begin
    Result := (HTTPRIO as ServiceProg_Port).GetItemStock(aCodeBrand);
      if (Result = '') or (Result = '-1') or (Result = '0') then
        Result := EncodeOrderOnly((HTTPRIO as ServiceProg_Port).GetItemPurchase(aCodeBrand))
      else
        Result := 'В наличии';
  end;

var
  sExistAnswer: string;
  i, iID, iAction: integer;
  sDecoded: WideString;
begin
  Result := '-1';
  aCodeBrand := ReplaceCode(aCodeBrand); //подмена переименованных кодов
  sExistAnswer := GetF7RecordFromTable(aCodeBrand, iID, iAction);
  case iAction of
  cERROR:
    begin
      LogSnd('Нет соединения с БД');
      sDecoded := '-1';
    end;
  cNOT_EXIST:
    begin
      sDecoded := FindItem(aCodeBrand);
      UpdateF7Table(qatInsert, aCodeBrand, sDecoded);
    end;
  cEXIST_UPDATE:
    begin
      sDecoded := FindItem(aCodeBrand);
      UpdateF7Table(qatUpdate, aCodeBrand, sDecoded, iID);
    end;
  else
    sDecoded := sExistAnswer;
  end;

  Result := sDecoded
end;

end.

// протокол обмена данными
// *** запрос ЗАКАЗА ***
{
>>  TEST_<id_клиента>_<номер_заказа>

<<  ZAKAZANO
<<  BINFILE
<<  <бинарные данные>
<<  ENDFILE
<<  ZAMENY
<<  BINFILE
<<  <бинарные данные>
<<  ENDFILE
<<  END
}


// *** запрос ВОЗВРАТА ***
{
>>  RETD_<<id_клиента>_<номер_заказа>

<<  ZAKAZANO
<<  BINFILE
<<  <бинарные данные>
<<  ENDFILE
<<  END
}


// *** запрос ТТН ***
{
>>  EXCEL_ACK
>>  <номер_заказа_по_лотусу>

<<  <проверочный код>

>>  <хэш>

<<  BINFILE
<<  <бинарные данные>
<<  ENDFILE
}





// протокол обмена данными при запросе скидок
{
формат запроса:
>>
    DISC_<id_клиента>_<открытый_ключ>_<текущая_версия_скидок>
<<

формат ответа:
если версии скидок совпадают:
>>
    END
<<

если есть изменения в скидках - передача скидок:
>>
    VERSION=<версия_скидок_на_сервере>
    BINFILE
    <бинарные данные>
    ENDFILE
    END
<<

если возникла ошибка:
>>
ERROR=<код_ошибки>
END
<<
__________________________
коды ошибок:
-1 - внутренняя ошибка на сервере (клиенту сказать чтоб повторил попытку позже)
-2 - не распознан запрос (не удовлетворяет формату DISC_<id_клиента>_<открытый_ключ>_<текущая_версия_скидок>)
1 - ошибка авторизации (проверка ключа не прошла)
2 - данные клиента не найдены в БД (передан неверный ID-клиента или еще не попал в базу нужный файлик)
}
