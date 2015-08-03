unit UnitReporter;

interface
uses Windows, SysUtils, Math, IBDatabase, DB, IBDatabaseINI, DBLogDlg, IBCustomDataSet, ComObj, ADODB, INIFiles, Classes
,UnitPerco, Messages, ActiveX;

  type

    TStaffCrossDesc = Record
      tabel: string[5];
      date, time: TDateTime;
      crosstype: integer;
      zone: integer;
      datetime: TDateTime;
      previousday: boolean;

      timelength, daysum: TDateTime;
      daypoint: boolean;
      dayhorizont: integer;

      area: string[31];
    End;

    TExternalDataProcessor = Class
      public
        procedure ProcessDataset(Dataset: TIBDataSet); virtual; abstract;
    End;

    TTabelintermediadateProcessor = Class(TExternalDataProcessor)
      var
        Crosses: array of TStaffCrossDesc;
      private
        FFileName: string;
        FDataBlockNumber: integer;
        FBeginDate, FEndDate: TDateTime;

        indexshift: integer;

        procedure CalculateCrosses;
        procedure SaveCrosses;
        procedure FinalizeDatablock;
        function GetDatablockfactor: boolean;
        function GetDateCrossPassport(i, j: integer): string;
        function DateIndex(i: integer): integer;
      public
        property fileout: string read FFileName write FFileName;
        property Datablockfactor: boolean read GetDatablockfactor;
        property DateCrossPassport[i, j: integer]: string read GetDateCrossPassport;
        procedure SetPeriod(BeginDate, EndDate: TDateTime);
        procedure ProcessDataset(Dataset: TIBDataset); override;
        procedure Init(filename: string = '');
        function produceStaffCrossesDataPool(tabno, filebuf: string): boolean;
    End;

    TZLEDesc = Record
      employee: string[255];
      tabelno: string[5];
      zone: string[10];
      count: integer;
      worth: real;
    End;

    TScanMode = (smGroupByWorker, smGroupDaily);

    TScanRepLoader = Class
      const OPERATIONINDEX = 1;
        WSHREPSCAN = 'RepScan';
        WSHLINESCOUNT = 'Lines';
        WSHLINESWORTH = 'Worth';
      var
        WrkChrct: array of TZLEDesc;
        Employees, ZonesWeights: TStringList;
        Excel: OleVariant; //TExcelApplication;
      private
        server, database, {firm,} login, pass: string;
        approle: boolean;
        begindate, enddate: TDateTime;
        FDailyShift: integer;
        scanmode: TScanMode;
        coeff0: Real;
        wbkfile, wbksheet: string;
        tabelcolumn, tabelrow, tabeldiapason: integer;
        Connection: TADOConnection;
        Query: TADOQuery;

        procedure SetDailyShift(value: integer);
        function generateConnStr: string;
        function Connect: boolean;
        function Disconnect: boolean;

        function InitQuery(Query: TADOQuery): boolean;
        function AttouchQuery(var Query0: TADOQuery): boolean;
        function SelectQuery(Query0: TADOQuery; tag: string = ''): boolean;
        function ShutQuery(Query0: TADOQuery): boolean;
        function DetouchQuery(Query0: TADOQuery = nil): boolean;

        function PrintZLE(tabel: string; ZLE: TZLEDesc; rowNo, rowlink: Integer): boolean; overload;
        function PrintZLE(ZLE:TZLEDesc; row, col: Integer): boolean; overload;
      public
        procedure Init(fileini: string);
        property DailyShift: integer read FDailyShift write SetDailyShift;
        function GetDataLive(tabel: string; BeginDate, EndDate: TDateTime): real;
        function ProcessingWorkbook(filexls: string = ''): boolean;
        function GetZonesLinesWorker(tabel: string): TZLEDesc;
        function isWorkerCodePresent(tabel: string): boolean;
        constructor Create();
        destructor Destroy; override;
    End;


    TReporter = Class(TThread)
      const WSHTIMES = 'Times';
        WSHENTERS = 'Enters';
        WSHEXITS = 'Exits';
        ROWDATE = 7; { TODO : параметризировать нормально через KeyRow KeyColumn }
        OPERATIONSSEQUENCE: array[0..1] of string = ('Загрузка проходов из Perco','Загрузка строк из NAV');
      var
        TabelintermediadateProcessor: TTabelintermediadateProcessor;
        RepScan: TScanRepLoader;
        DataLoader: TPercoDataLoader;
        Excel: OleVariant;

      private
        wbkName, wshName: string;
        begindate, enddate: TDateTime;
        tabeldiapason: integer;
        dayshift: integer;

        tabelrow, tabelcolumn: integer;
        tabelindex: integer;
        tabel: string;
        tabelcsv: string;

        FOperOptions: set of byte;

        FProgressPercent: real;
        function GetProgressPercent: integer;
        procedure SendLiveStatus;
        function GetFileout: string;
        procedure SetFileout(filecsv: string);
        function GetDateCrossPassport(i, j: integer): string;
        function CheckFullMonthPeriod: boolean;
        function CheckSynchronDefinition: boolean;
        function SyncDataDate(): integer;
        procedure PrintDataDate(dayshift: integer = 0);
      protected
        procedure Execute; override;
      public
        constructor Create();
        destructor Destroy(); override;

        property progressPercent: integer read GetProgressPercent;
        property fileout: string read GetFileout write SetFileout;
        procedure SetPeriod(BeginDate, EndDate: TDateTime);
        procedure ProcessDataset(Dataset: TIBDataset);
        function produceStaffCrossesDataPool(tabno, filebuf: string): boolean;
        property DateCrossPassport[i, j: integer]: string read GetDateCrossPassport;

        property SynchronParametrization: boolean read CheckSynchronDefinition;
        property FullMonthPeriod: boolean read CheckFullMonthPeriod;
        function DoRepScan: boolean;
        function CheckEmployee(tabel: string): boolean;
        function LiveWorkerSum(tabel: string): string;
        procedure Init(fileini: string);
        procedure SetOperationsSet(OperationsMask: byte);
        function CheckOperationSet(OperName: string): boolean;
        procedure SynchronizeData(filexls: string = '');
        procedure InjectData(Workbookname: string);
    End;

  const
    WM_LIVEFORM_MSG = WM_USER + $1F;
    PROC_DOCS_INS = 'DOC_STAFF_FOR_1C_$INS';
    PROC_STAFF_CROSSES_GET = '_CROSSES_FOR_PERIOD$GET';
  var
    StaffCrosses: array of TStaffCrossDesc;
    Reporter: TReporter; //TTabelintermediadateProcessor;
    AppWindowHandle: HWND;
  procedure externalprocedure(Dataset: TIBDataSet);

implementation
 uses MSExcel,  IBStoredProc, UnitAUX;

procedure externalprocedure(Dataset: TIBDataSet);
begin
  Reporter.ProcessDataSet(Dataset);
end;

{ TTabelintermediadateProcessor }

procedure TTabelintermediadateProcessor.CalculateCrosses;
var
  k0, k, l: integer;
  datemark: TDateTime;
begin
  l := Length(Self.Crosses);
  if l = 0 then exit;

  for k := 1 to l - 1 do
    if (Self.Crosses[k].tabel = Self.Crosses[k-1].tabel) and (Self.Crosses[k].datetime - Self.Crosses[k-1].datetime < 1) then
      Self.Crosses[k].timelength := Self.Crosses[k].crosstype * Sign(Self.Crosses[k].crosstype - Self.Crosses[k-1].crosstype) * (Self.Crosses[k].datetime - Self.Crosses[k-1].datetime)   //Sign(Self.Crosses[k].crosstype - Self.Crosses[k-1].crosstype) *
     else
      Self.Crosses[k].timelength := 0;


  k0 := 0;
//  k := 0;
  repeat
    datemark := Self.Crosses[k0].date;  //опорная дата
    //k := k0 + 1;

    if datemark < Self.FBeginDate then Self.FBeginDate := datemark
     else
      if datemark > Self.FEndDate then Self.FEndDate := datemark;


    while (k0<l) do       //цикл до начала смены
      if (Self.Crosses[k0].date = datemark) and Self.Crosses[k0].previousday then
        inc(k0)
       else
        break;
    if k0 >= l then break;
    if (Self.Crosses[k0].date) <> datemark then
      continue;

    while k0 < l do  //цикл до до первого входа
      if ((1-Self.Crosses[k0].crosstype) * Self.Crosses[k0].zone  = 0) then  //!* fix error (?)
        inc(k0)
       else
        break;
    if k0 >= l then break;
    if (Self.Crosses[k0].date) <> datemark then
      continue;

    Self.Crosses[k0].daypoint := true;
    k := k0;
    while (k<l) do      //цикл до конца смены
      if (Self.Crosses[k].date) = datemark then
       begin
        Self.Crosses[k0].daysum := Self.Crosses[k0].daysum + Self.Crosses[k].zone * Self.Crosses[k].timelength;
        Self.Crosses[k0].dayhorizont := Self.Crosses[k0].dayhorizont + (k - Self.Crosses[k0].dayhorizont)*Sign(Self.Crosses[k].crosstype);
        inc(k);
       end
       else
       begin
        while (k<l) do
          if (Self.Crosses[k].previousday) and (Self.Crosses[k].date = datemark + 1)  then
           begin
            Self.Crosses[k0].daysum := Self.Crosses[k0].daysum + Self.Crosses[k].zone * Self.Crosses[k].timelength;
            Self.Crosses[k0].dayhorizont := Self.Crosses[k0].dayhorizont + (k - Self.Crosses[k0].dayhorizont)*Sign(Self.Crosses[k].crosstype);
            inc(k);
           end
           else
            break;
        break;
       end;
    k0:=k;
  until (k0>l);
end;

function TTabelintermediadateProcessor.DateIndex(i: integer): integer;
var k, l: integer;
begin
  l := length(Self.Crosses);
  RESULT := l;
  if l = 0 then exit;

  if l - 1 < indexshift then
    indexshift := 0;

  if (Self.Crosses[indexshift].date = Self.FBeginDate + i) and Self.Crosses[indexshift].daypoint then
   begin
    RESULT := indexshift;
    exit;
   end;

  if Self.Crosses[indexshift].date > Self.FBeginDate + i then
   begin
    for k := 0 to l - 1 do
     if Self.Crosses[k].daypoint and (Self.Crosses[k].date = Self.FBeginDate + i) then
      begin
       RESULT := k;
       break;
      end;
   end
   else
   begin
    for k := l - 1 downto 0 do
     if Self.Crosses[k].daypoint and (Self.Crosses[k].date = Self.FBeginDate + i) then
      begin
        RESULT := k;
        break;
      end;
   end;

  if RESULT < l then
    indexshift := RESULT;
end;

procedure TTabelintermediadateProcessor.FinalizeDatablock;
begin
  inc(Self.FDataBlockNumber);
end;

function TTabelintermediadateProcessor.GetDatablockfactor: boolean;
begin
  RESULT := Self.FDataBlockNumber = 1;
end;

function TTabelintermediadateProcessor.GetDateCrossPassport(i, j: integer): string;
const
  //CLMN_TABEL = 0;
  CLMN_DATEIN = 0;
  CLMN_TIMEIN = 1;
  CLMN_TIMESUM = 2;
  CLMN_TIMEOUT = 3;
  CLMN_DATEOUT = 4;
  CLMN_AREAIN = 5;
  CLMN_AREA = 6;
  CLMN_AREAOUT = 7;
var k, l: integer;
  link: integer;
begin
  RESULT := '';
  k := Self.DateIndex(i);
  l := Length(Self.Crosses);
  if k = l then
   begin
    if j = 0 then
      RESULT := DateToStr(Self.FBeginDate + i);
    exit;
   end;


  case j of
//    CLMN_TABEL:
//      RESULT := Self.Crosses[k].tabel;
    CLMN_DATEIN:
      RESULT := DateTimeToStr(Self.Crosses[k].date);
    CLMN_TIMEIN:
      RESULT := TimeToStr(Self.Crosses[k].time);
    CLMN_TIMESUM:
      RESULT := TimeToStr(Self.Crosses[k].daysum);
    CLMN_TIMEOUT:
     begin
      link := Self.Crosses[k].dayhorizont;
      if (link = 0) or (link > l - 1) then exit;
      RESULT := TimeToStr(Self.Crosses[link].time);
     end;
    CLMN_DATEOUT:
     begin
      link := Self.Crosses[k].dayhorizont;
      if (link = 0) or (link > l - 1) then exit;
      if Self.Crosses[link].date = Self.Crosses[k].date then
        RESULT := '..'
       else
        if (Self.Crosses[link].previousday) then
          RESULT := DateTimeToStr(Self.Crosses[link].date)
         else
          RESULT := '??';
     end;
    CLMN_AREAIN:
     begin
      if k > 0 then
       begin
        if (Self.Crosses[k - 1].crosstype = 1) then
          RESULT := trim(Self.Crosses[k-1].area)
         else RESULT := '??';
       end
       else
        RESULT := '??';
     end;
    CLMN_AREA:
      RESULT := trim(Self.Crosses[k-1].area);
    CLMN_AREAOUT:
     begin
      link := Self.Crosses[k].dayhorizont;
      if (link = 0) or (link > l - 2) then exit;
      if Self.Crosses[link+1].crosstype = 0 then
        RESULT := Self.Crosses[link+1].area;
     end;
  end;
end;

procedure TTabelintermediadateProcessor.Init(filename: string);
begin
  Self.SetPeriod(Now(), 0);
  Self.FFileName := filename;
  Self.FDataBlockNumber := 0;
end;

procedure TTabelintermediadateProcessor.ProcessDataset(Dataset: TIBDataset);
const
  FLD_TABEL_NO = 'TABEL_NO';
  FLD_DATEPASS = 'DATEPASS';
  FLD_TIMEPASS = 'TIMEPASS';
  FLD_SHIFTING = 'SHIFTING';
  FLD_CODEPASS = 'CODEPASS';
  FLD_AREA = 'AREA';
  FLD_DEVICE = 'DEVICE';
  FLD_ZONE = 'ZONE';
const   SHIFTHOUR = 7;
var
  i {, j}: integer;
begin
  i := 0;
  SetLength(Self.Crosses,0);
  DataSet.Last;
  SetLength(Self.Crosses, Dataset.RecordCount);
  if DataSet.RecordCount = 0 then exit;

  DataSet.First;
  repeat  //цикл по табельному номеру
    //i:= DataSet.RecNo - 1;
    with Self.Crosses[i] do
     begin
      tabel :=  Trim(DataSet.FieldByName(FLD_TABEL_NO).AsString);
      date  := DataSet.FieldByName(FLD_DATEPASS).AsDateTime;
      time :=  DataSet.FieldByName(FLD_TIMEPASS).AsDateTime;
      crosstype := Dataset.FieldByName(FLD_CODEPASS).AsInteger;
      zone := DataSet.FieldByName(FLD_ZONE).AsInteger;
      datetime := date + time;
      previousday := DataSet.FieldByName(FLD_SHIFTING).AsInteger > 0; //time < SHIFTHOUR / 24

      area := trim(copy(Dataset.FieldByName(FLD_AREA).AsString, 1, 31));
     end;
     inc(i);
    DataSet.Next;
  until DataSet.Eof;
  //SetLength(Self.Crosses, Dataset.RecordCount);

  CalculateCrosses;
  SaveCrosses;//Array(ChangeFileExt(DataPool.datacsv, '.out.csv'));
  FinalizeDatablock;
end;
function TTabelintermediadateProcessor.produceStaffCrossesDataPool(tabno, filebuf: string): boolean;
const TITLESLINE = 'TABNO;D0;DFIN;HOURSHIFT';
var line: string;
  ff:text;
begin
  RESULT := False;
  AssignFile(ff, filebuf);
  try
    rewrite(ff);
    try
      writeln(ff, TITLESLINE);
      line := Concat(tabno, ';',DateTimeToStr(Self.FBeginDate), ';', DateToStr(Self.FEndDate), ';', '7');
      writeln(ff, line);
      RESULT := True;
    finally
      CloseFile(ff);
    end; 
  except
     { TODO : обработать ошибку! }
  end;
end;

procedure TTabelintermediadateProcessor.SaveCrosses;
var k, l: integer;
  ff: Text;
  line: string;   filename: string;
begin
  l := Length(Self.Crosses);
  if l=0 then exit;

  if Self.FFileName = '' then  exit;
//    filename := Format('discipline{%s}[%s..%s].csv',[Self.Crosses[0].tabel, DateTimeToStr(Self.FBeginDate),DateTimeToStr(Self.FEndDate)])
//   else
  filename := Self.FFileName;
  Assign(ff, filename);

  if Self.FDataBlockNumber = 0 then
    Rewrite(ff)
   else
    if FileExists(Self.FFileName) then Append(ff)
     else Rewrite(ff);

  try
    for k:=0 to l-1 do
     if Self.Crosses[k].daypoint then
      begin
        line := Concat(Self.Crosses[k].tabel, ';', DateToStr(Self.Crosses[k].date),';', FloatToStr(Round(Self.Crosses[k].daysum * 24)));
        writeln(ff, line);
      end;

  finally
    CloseFile(ff);
  end;
end;

procedure TTabelintermediadateProcessor.SetPeriod(BeginDate, EndDate: TDateTime);
begin
  Self.FBeginDate := Trunc(BeginDate);
  Self.FEndDate := Trunc(EndDate);
end;

{ TScanRepLoader }

function TScanRepLoader.AttouchQuery(var Query0: TADOQuery): boolean;
begin
//  RESULT := True;
//  if (Self.scanmode = smGroupByWorker) and (Query0 <> nil) then exit;
//  if (Self.scanmode = smGroupDaily) and (Query0 = nil) then exit;
  RESULT := Query0 = nil;
//  if Self.scanmode = smGroupDaily then
//    Query0 := Self.Query;
//  if RESULT then exit;


  //RESULT := False;
  case Self.scanmode of
   smGroupDaily:
   begin
    Query0 := Self.Query;
    if RESULT then exit;

    Self.InitQuery(Query0);
    //Query0.Parameters.ParamByName('NAMECODE').Value :=  ''
    Self.SelectQuery(Query0);
   end;
   smGroupByWorker:
   begin
    Query0 := TADOQuery.Create(nil);
    Self.InitQuery(Query0);

   end;
//   else
//    raise Ex;
  end;
  RESULT := True; //Self.InitQuery(Query0);
end;

function TScanRepLoader.Connect: boolean;
const SQLMAGICWORD = 'EXEC [sp_setapprole] ''$ndo$shadow'', ''FF5EC4E40F67BD4EDF3D04F8B84364DAD0'', ''none'', 0, 0';
begin
//  RESULT := False;
  Self.Connection.Connected := False;

  Self.Connection.LoginPrompt := False;
  Self.Connection.ConnectionString := Self.generateConnStr;

  Self.Connection.Open();
  if self.approle then
  try
    Self.Connection.Execute(SQLMAGICWORD);
  except
    self.approle := False;
  end;

  RESULT := Self.Connection.Connected;
end;

constructor TScanRepLoader.Create();
begin
  Self.Connection := TADOConnection.Create(nil);
  Self.Query := TADOQuery.Create(nil);
  Self.Employees := TStringList.Create();
  Self.ZonesWeights := TStringList.Create();
end;

destructor TScanRepLoader.Destroy;
begin
  Self.ZonesWeights.Free;
  Self.Employees.Free;
  Self.Query.Free;
  Self.Connection.Free;
inherited;
end;

function TScanRepLoader.DetouchQuery(Query0: TADOQuery): boolean;
begin

  case Self.scanmode of
    smGroupByWorker: //;
      if Assigned(Query0) then
        FreeAndNil(Query0);
//       else
//        Self.Query.Close
    smGroupDaily: //;
      if Query0 = nil then
        Self.Query.Close;
  end;



  RESULT := Query0 = nil;
end;

function TScanRepLoader.Disconnect: boolean;
begin
  Result := False;
  Self.Connection.Close;
end;

function TScanRepLoader.generateConnStr: string;
var driver, server, UID, PWD, WSID, TrustConn, database, lang, user: string;
  userNameLen: Cardinal;
begin
  userNameLen:=255;
  setLength(user, userNameLen);
  getUserName(PAnsiChar(user),userNameLen);
  driver := 'DRIVER=SQL Server;';
  server := 'SERVER='+Self.server+';';
  if Self.login = ''  then //Trusted Connection
   begin
    UID    := 'UID=;';
    PWD    := '';
    WSID   := 'WSID='+copy(user,1,UserNameLen-1)+';';
    TrustConn := 'Trusted_Connection=Yes;';
   end
   else
   begin
    UID    := 'UID='+self.login+';';
    WSID   := '';
    PWD    := 'PWD='+self.pass+';';
    TrustConn := '';
   end;
  database := 'DATABASE='+Self.database+';';
  lang   :='LANGUAGE=русский;';
  RESULT:= driver + server + UID + PWD + WSID + TrustConn + database + lang;
end;

function TScanRepLoader.GetDataLive(tabel: string; BeginDate, EndDate: TDateTime): real;
var ZLE: TZLEDesc;
begin
  Self.begindate := BeginDate;
  Self.enddate := EndDate;
//
//  if (EndDate = Trunc(Now()) - 1) then
//    Self.enddate := Trunc(Now);

  //Self.scanmode := smGroupByWorker;
  if Self.Connect then
  try
    ZLE := GetZonesLinesWorker(tabel);
  finally
    Self.Disconnect;
  end;

  RESULT := ZLE.worth;
end;

function TScanRepLoader.GetZonesLinesWorker(tabel: string): TZLEDesc;
//const
//  CLMNINDTABEL = 1;
//  CLMNINDCODE = 2;
//  CLMNINDVAL = 3;
var
  Query: TADOQuery;
  nn: integer;
  LL: TZLEDesc;

  zone: string;
  employees: string;
  p, l: integer;
begin
    //Self.Connect;
    RESULT.tabelno := tabel;
    RESULT.employee := '';
    RESULT.worth:= 0;
    RESULT.count := 0;
    nn := Self.Employees.IndexOfName(tabel);
    if nn<0 then exit;

    LL := RESULT; //инициализация
    employees := Self.Employees.Values[tabel];

    Query := nil;
    if Self.AttouchQuery(Query) then //TADOQuery.Create(nil);
    try
      repeat
        l:=length(employees);
        p := pos(',', employees);
        if p = l then break;

        if (p>0) then
         begin
          LL.employee := trim(copy(employees, 1, p - 1));
          employees := trim(copy(employees, p + 1));
         end
         else
          LL.employee := trim(employees);

        if LL.employee = '' then break;

        Self.SelectQuery(Query, LL.employee);

        try
          Query.First;
          if Query.RecordCount > 0 then
          repeat
            zone := Trim(Query.FieldByName('id_Zone').AsString);
            LL.count := LL.count + Query.FieldByName('ConDay').AsInteger;
            
            LL.worth := LL.worth + Query.FieldByName('ConDay').AsInteger
                                    * ifthen(Self.ZonesWeights.IndexOfName(zone) > -1,
                                        StrToFloat(Self.ZonesWeights.Values[zone])
                                        , Self.coeff0);
            Query.Next;
          until Query.Eof;
        finally
          Self.ShutQuery(Query); //Query.Close;
        end;
      until p = 0;
      LL.tabelno := tabel;
      LL.employee := Self.Employees.Values[tabel];
    finally
      Self.DetouchQuery(Query); //FreeAndNil(Query);
    end;
    RESULT := LL;

end;

procedure TScanRepLoader.Init(fileini: string);
const
  FILEEMPLOYEECODES = 'employees.list';
  FILEZONESWEIGTHS = 'zones.list';  //wgh
var
  //Np: integer;
    param: string;
    iniFile: TIniFile;
    //zwfile: string;
begin
  Self.approle := True;
  //MSExcel.Excel := Self.Excel;
  iniFile := TIniFile.Create(fileini);
  try
    Self.server := iniFile.ReadString('NAV','Server','');
    Self.database := iniFile.ReadString('NAV','Database','');

    Self.login :=  iniFile.ReadString('NAV','UID','');
    Self.pass := iniFile.ReadString('NAV','PWD','');


    Self.scanmode := TScanMode(iniFile.ReadInteger('REPSCAN', 'mode', Ord(smGroupDaily)));
    Self.coeff0 := iniFile.ReadFloat('REPSCAN', 'DefaultZoneCoeff', 0);
    Self.tabelcolumn := iniFile.ReadInteger('EXCEL','TabelColumnIndex', 2);
    Self.tabelrow := iniFile.ReadInteger('EXCEL','TabelRowIndex', 9);
  finally
    FreeAndNil(iniFile);
  end;

  Self.Employees.LoadFromFile( ExtractFilePath(Paramstr(0)) + FILEEMPLOYEECODES);
  Self.ZonesWeights.LoadFromFile(ExtractFilePath(Paramstr(0)) + FILEZONESWEIGTHS);

//  Np := ParamCount();

  //if Np <>  then

  param := ParamStr(1);
  if param > '' then
    Self.wbkfile := param
   else
    exit;

  param := ParamStr(2);
  if param > '' then
    Self.wbksheet := param
   else
    exit;

  param := ParamStr(3);
  if param > '' then
    Self.begindate := StrToInt(param)
   else
    exit;

  param := ParamStr(4);
  if param > '' then
    Self.enddate := StrToInt(param)
   else
    exit;

  param := ParamStr(5);
  if param > '' then
    Self.tabeldiapason := StrToInt(param)
   else
    exit;


end;

function TScanRepLoader.InitQuery(Query: TADOQuery): boolean;
const
  REPSCANREQUESTFILE = 'repscan-U.qry';
  REPSCANSQL = 'EXEC report_sel_workerzonelines :BEGINDATE, :ENDDATE, :NAMECODE';
begin
  Result := False;
  Query.Connection := Self.Connection;
  Query.CursorLocation := clUseClient;
  Query.CursorType := ctStatic;
  Query.LockType := ltReadOnly;
  Query.CommandTimeout := 60;

  if FileExists(ExtractFilePath(Paramstr(0)) + REPSCANREQUESTFILE) then
   begin
    Query.SQL.LoadFromFile(ExtractFilePath(Paramstr(0)) + REPSCANREQUESTFILE);
    Query.SQL.Text := copy(Query.SQL.Text, 2);
   end
   else
   Query.SQL.Text := REPSCANSQL;

  Query.Prepared := True;
  Query.Parameters.ParamByName('BEGINDATE').Value :=  FormatDateTime('YYYYMMDD',Self.begindate); //'20140301';
  Query.Parameters.ParamByName('ENDDATE').Value :=  FormatDateTime('YYYYMMDD',Self.enddate); //'20140331';
end;

function TScanRepLoader.isWorkerCodePresent(tabel: string): boolean;
begin
  RESULT := Self.Employees.IndexOfName(tabel) > -1
end;

function TScanRepLoader.PrintZLE(tabel: string; ZLE: TZLEDesc; rowNo, rowlink: Integer): boolean;
const
  INDCLMN_TABEL = 1;
  INDCLMN_EMPLOYEE = 2;
  INDCLMN_COUNT = 3;
  INDCLMN_VALUE = 4;
  INDCLMN_ROWLINK = 5;
begin
  Result := False;
  MSExcel.SetCellFormat(WSHREPSCAN, rowNo, INDCLMN_TABEL, FMTTEXT);

  if ZLE.employee>'' then
   begin
    MSExcel.WriteCellValue(WSHREPSCAN, rowNo, INDCLMN_TABEL, ZLE.tabelno);
    MSExcel.WriteCellValue(WSHREPSCAN, rowNo, INDCLMN_EMPLOYEE, ZLE.employee);
    MSExcel.WriteCellValue(WSHREPSCAN, rowNo, INDCLMN_COUNT, ZLE.count);
    MSExcel.WriteCellValue(WSHREPSCAN, rowNo, INDCLMN_VALUE, ZLE.worth);
   end
   else
   begin
    MSExcel.WriteCellValue(WSHREPSCAN, rowNo, INDCLMN_TABEL, tabel);
    MSExcel.WriteCellValue(WSHREPSCAN, rowNo, INDCLMN_EMPLOYEE, '??????');
   end;
  MSExcel.WriteCellValue(WSHREPSCAN, rowNo, INDCLMN_ROWLINK, rowlink);
end;

function TScanRepLoader.PrintZLE(ZLE: TZLEDesc; row, col: Integer): boolean;
var k, dd: integer;
begin
  Result := False;
  dd := Round(Self.enddate - Self.begindate);
  for k := 1 to dd do
   begin
    MSExcel.WriteCellValue(WSHLINESCOUNT, row, col - k, 0);
    MSExcel.WriteCellValue(WSHLINESWORTH, row, col - k, 0);
   end;
  MSExcel.WriteCellValue(WSHLINESCOUNT, row, col, ZLE.count);
  MSExcel.WriteCellValue(WSHLINESWORTH, row, col, ZLE.worth);
end;

function TScanRepLoader.ProcessingWorkbook(filexls: string = ''): boolean;

var
  workbookname: string;
  k, l: integer;
  tabel {, namecode}: string;
//  nn:integer;
  //repscanindex: integer;
begin
  Result := False;

  if filexls = '' then
    workbookname := Self.wbkfile//ExtractFileName()
   else
    workbookname := filexls;//ExtractFileName()

//  Self.wbkfile := filexls;

  MSExcel.CallExcel(true);

  MSExcel.ActivateWorkBook(workbookname); //Excel.Application.Workbooks.Item[workbookname].Activate;

  if DailyShift = 0 then
   begin
    if MSExcel.WorkSheetIndex(workbookname, WSHREPSCAN)=0  then
      MSExcel.AddWorkSheet(workbookname, WSHREPSCAN);
   end
   else
   begin
    if MSExcel.WorkSheetIndex(workbookname, WSHLINESCOUNT)=0  then
      MSExcel.AddWorkSheet(workbookname, WSHLINESCOUNT);
    if MSExcel.WorkSheetIndex(workbookname, WSHLINESWORTH)=0  then
      MSExcel.AddWorkSheet(workbookname, WSHLINESWORTH);
   end;
  {Self.tabeldiapason := 10; Self.wbksheet := 'Март';} Self.tabelcolumn := 10;


  //repscanindex := 0;
  if Self.Connect then
  try
    l := 0;
    if Self.AttouchQuery(Self.Query) then
    try
      for k := 0 to Self.tabeldiapason - 1 do
       begin
        tabel := MSExcel.ReadCellValue(Self.wbksheet, Self.tabelrow + k, Self.tabelcolumn);
        if length(tabel) <> 5 then continue;

        inc(l);
        SetLength(Self.WrkChrct, l);

        Self.WrkChrct[l - 1] := Self.GetZonesLinesWorker(tabel);

        if Self.DailyShift = 0 then        
          Self.PrintZLE(tabel, Self.WrkChrct[l-1], l, Self.tabelrow + k)//;
         else
          Self.PrintZLE(Self.WrkChrct[l-1], Self.tabelrow + k, Self.DailyShift);

        if AppWindowHandle>0 then
          PostMessage(AppWindowHandle, WM_LIVEFORM_MSG, Self.OPERATIONINDEX, Integer(Round(100*k div Self.tabeldiapason)));//, 50)
       end;
    finally
      Self.DetouchQuery();
    end;
  finally
    Self.Disconnect;
  end;

  //Self.GetData();


  //MSExcel.CloseExcel;
end;

function TScanRepLoader.SelectQuery(Query0: TADOQuery; tag: string): boolean;
begin
  RESULT := False;
  //if (tag = '') and (Query0 = Self.Query) then exit;  //smMonthly out

  Query0.Parameters.ParamByName('NAMECODE').Value :=  tag;
  case Self.scanmode of
    smGroupByWorker:
//      if tag = '' then

     begin

      Query0.Open;
           ;
     end;
    smGroupDaily:
      if tag = '' then
        Query0.Open
       else
       begin
        Query0.Filter := 'Employee =' + QuotedStr(tag);
        Query0.Filtered := True;
       end;
  end;
  //if Query0 = Self.Query then


end;

procedure TScanRepLoader.SetDailyShift(value: integer);
var day, month, year: Word;
begin
  if value<>0 then
   begin
    DecodeDate(value, year, month, day);
    Self.FDailyShift := day;
   end
   else
    Self.FDailyShift := value;
end;

function TScanRepLoader.ShutQuery(Query0: TADOQuery): boolean;
begin
  Result := False;
  case Self.scanmode of
    smGroupByWorker:
      //if Self.Query = Query0 then
      Query0.Close;
    smGroupDaily:
      Query0.Filtered:=False;
  end;
end;

{ TReporter }

function TReporter.CheckEmployee(tabel: string): boolean;
begin
  Result := False;
  if Assigned(Self.RepScan) then
    RESULT := Self.RepScan.isWorkerCodePresent(tabel);
end;

function TReporter.CheckFullMonthPeriod: boolean;
var partmonth, partday, partyear: word;
  currentmonth, month: word;
begin
  RESULT := False;

  if Self.begindate * Self.enddate = 0 then
   try
    if ParamCount > 4 then
      Self.SetPeriod(StrToInt(Paramstr(3)), StrToInt(ParamStr(4)));
   except
    exit;
   end;
   //else exit



  DecodeDate(Now(), partyear, partmonth, partday);
  currentmonth := partmonth;

  DecodeDate(Self.begindate, partyear, partmonth, partday);
  if partmonth = currentmonth then exit;
  month := partmonth;
  if partday>1 then exit;

  Decodedate(Self.enddate, partyear, partmonth, partday);
  if partmonth<>month then exit;

  Decodedate(Self.enddate + 1, partyear, partmonth, partday);
  RESULT := partmonth = month + 1;
end;

function TReporter.CheckOperationSet(OperName: string): boolean;
var
  k: Integer;
begin
  RESULT := False;
  for k := 0 to 1 do
    if OPERATIONSSEQUENCE[k] = OperName then
      RESULT := k in Self.FOperOptions;
end;

function TReporter.CheckSynchronDefinition: boolean;
begin
  RESULT := False;//Self.tabelcsv > '';
  if ParamCount() < 6 then exit;

  RESULT := ParamStr(6) > '';
end;

constructor TReporter.Create;
begin
  inherited Create(True);
  Self.FreeOnTerminate := False;

  Self.TabelintermediadateProcessor := TTabelintermediadateProcessor.Create;
  Self.DataLoader := TPercoDataLoader.Create();
  //Self.RepScan := TScanRepLoader.Create;
end;

destructor TReporter.Destroy;
begin
  //FreeandNil(Self.RepScan);
  FreeAndNil(Self.DataLoader);
  FreeAndNil(Self.TabelintermediadateProcessor);
  inherited;
end;

procedure TReporter.Execute;
var retcode: Integer;
begin
  retcode := 0;
  CoInitializeEx(nil, COINIT_MULTITHREADED);
  try
    if Reporter.CheckOperationSet(Reporter.OPERATIONSSEQUENCE[Self.RepScan.OPERATIONINDEX]) then
      Reporter.DoRepScan();

    if Reporter.CheckOperationSet(Reporter.OPERATIONSSEQUENCE[0]) then    
      Reporter.SynchronizeData();
  except on E: Exception do
   begin
    retcode := -1;
    PrintTimestamp(Concat('*',E.ClassName,'*: "',E.Message,'"'), 'Errors.log');
   end;
  end;
  CoUninitialize;
  PostMessage(AppWindowHandle, WM_LIVEFORM_MSG, $FFFF, retcode);
end;

function TReporter.DoRepScan: boolean;
begin
  Result := False;
   begin
     RepScan := TScanRepLoader.Create;
     try
       RepScan.Init(ChangeFileExt(Paramstr(0), '.ini'));
      if Self.FullMonthPeriod then
        RepScan.DailyShift := 0
       else
        RepScan.DailyShift := Trunc(RepScan.enddate);
       RepScan.ProcessingWorkbook(); //'D:\WORK\perco\GraphWorkReports\Files\TabelTemplate.xls' GetZonesLinesWorker('00299');

     finally
       RepScan.Free;
     end;
   end;
end;

function TReporter.GetDateCrossPassport(i, j: integer): string;
begin
  RESULT := Self.TabelintermediadateProcessor.DateCrossPassport[i, j];
end;

function TReporter.GetFileout: string;
begin
  RESULT := Self.TabelintermediadateProcessor.fileout;
end;

function TReporter.GetProgressPercent: integer;
begin
  RESULT := Round(Self.FProgressPercent);
end;

procedure TReporter.Init(fileini: string);
var param: string;
  iniFile: TIniFile;
begin
  Self.DataLoader.Init(fileini);
  Self.TabelintermediadateProcessor.Init();

  iniFile := TIniFile.Create(fileini);
  try
    Self.tabelcolumn := iniFile.ReadInteger('EXCEL','TabelColumnIndex', 2);
    Self.tabelrow := iniFile.ReadInteger('EXCEL','TabelRowIndex', 9);
  finally
    iniFile.Free;
  end;

  param := ParamStr(1);
  if param > '' then
    Self.wbkName := param
   else
    exit;

  param := ParamStr(2);
  if param > '' then
    Self.wshName := param
   else
    exit;

  param := ParamStr(3);
  if param > '' then
    Self.begindate := StrToInt(param)
   else
    exit;

  param := ParamStr(4);
  if param > '' then
    Self.enddate := StrToInt(param)
   else
    exit;

  param := ParamStr(5);
  if param > '' then
    Self.tabeldiapason := StrToInt(param)
   else
    exit;

  param := ParamStr(6);
  if param > '' then
    Self.tabelcsv := param
   else
    exit;
end;

procedure TReporter.InjectData(Workbookname: string);
const
  INDEXHOURSPRESENT = 2;
  INDEXTIMEENTER = 1;
  INDEXTIMEEXIT = 3;
var
  k, l: integer;
  k0: integer;
  tabel: string;
  r: integer;
  timestr: string;
begin

    if Workbookname = '' then exit;

    Self.SetPeriod(Self.begindate, Self.enddate);
    if Length(Self.TabelintermediadateProcessor.Crosses)>0 then
      Self.tabel := Self.TabelintermediadateProcessor.Crosses[0].tabel
     else
     begin
      Self.tabel := '';
      exit;
     end;

    k0 := 1 + Self.dayshift;
    l := k0 + Round(Self.enddate - Self.begindate);
    for k := k0 to l do  //цикл по датам интервала
     begin
      r := self.tabelindex;
      repeat
        tabel := MSExcel.ReadCellValue(Self.wshName, r, Self.tabelcolumn);
        if tabel = Self.tabel then
         begin
          timestr := Self.DateCrossPassport[k - k0,INDEXHOURSPRESENT];
          if timestr > '' then
            timestr := IntToStr(Round(24*StrToTime(timestr))) //FloatToStrF(24*StrToTime(timestr), ffFixed, 3, 1)
           else
            timestr := '0';

          MSExcel.WriteCellValue(WSHTIMES, r, k, timestr);

          timestr := Self.DateCrossPassport[k - k0,INDEXTIMEENTER];
          if timestr = '' then
            timestr := '??';
          MSExcel.WriteCellValue(WSHENTERS, r, k, timestr);
          timestr := Self.DateCrossPassport[k - k0,INDEXTIMEEXIT];
          if timestr = '' then
            timestr := '??';
          MSExcel.WriteCellValue(WSHEXITS, r, k, timestr);

          self.tabelindex := r;
          break;
         end;
        if r > Self.tabeldiapason + Self.tabelrow then r := 0;
        inc(r);
      until (r = Self.tabelindex);
      //if length(tabel) <> 5 then continue;
     end;
    MSExcel.SetCellFormat(WSHTIMES, Self.tabelindex, l + 1,FMTTEXT);
    MSExcel.WriteCellValue(WSHTIMES, Self.tabelindex, l + 1, Self.tabel);

    if Self.tabeldiapason>0 then
     begin
      Self.FProgressPercent := 100*(Self.tabelindex-Self.tabelrow)/Self.tabeldiapason;
      Self.SendLiveStatus;
     end;
end;

function TReporter.LiveWorkerSum(tabel: string): string;
var  zleval: real;
begin
  RESULT := '0.0';
  if Length(tabel)<>5 then exit;

  RepScan := TScanRepLoader.Create;
  try
    RepScan.Init(ChangeFileExt(Paramstr(0), '.ini'));

    RepScan.scanmode := smGroupByWorker;
    if RepScan.isWorkerCodePresent(tabel) then
     begin
      zleval := RepScan.GetDataLive(tabel, Self.begindate, Self.enddate);
      RESULT := FloatToStrF(zleval, ffFixed, 7, 2);
     end
     else
     RESULT := '<??>';
  finally
   RepScan.Free;
  end;

end;

procedure TReporter.PrintDataDate(dayshift: integer);
var k, l: integer;
  k0: integer;
begin
  if dayshift < 0 then
    dayshift := 0;

  k0 := 1 + dayshift;
  l := k0 + Round(Self.enddate - Self.begindate);
  for k := k0 to l do  //цикл по датам интервала
  try
      //MSExcel.SetCellFormat(WSHTIMES, Self.ROWDATE, k, FMTDATE); //формат необязателен
      MSExcel.WriteCellValue(WSHTIMES, Self.ROWDATE, k, DateToStr(Self.begindate + (k-k0)));
  except on E: Exception do
    PrintTimestamp(E.Message, 'Errors.log'); { TODO : обработать ошибку! некритичная добавить в лог ошибок }
  end;

end;

procedure TReporter.ProcessDataset(Dataset: TIBDataset);
begin
  if Self.Terminated then
    raise Exception.Create('Во время выполнения операции поступил сигнал внешнего завершения');
  Self.TabelintermediadateProcessor.ProcessDataset(Dataset);
  Self.InjectData(Self.wbkName);
end;


//функция возвращает смещение первой рассинхронизированной даты
//значение <0 означает что интервал дат невозможно синхронизировать
// значение 0 предполагает необходимость синхронизироваться с первой даты beginperiod
// значение >0 означает смещение в днях относительно первой даты на листе
function TReporter.SyncDataDate: integer;
var k, l: integer;
  datestr: string;
  celldate: TDateTime;
  dateshift: integer;
  k0: integer;
begin
  RESULT:=0;
  datestr := MSExcel.ReadCellValue(Self.WSHTIMES, ROWDATE, 1);
  if datestr>'' then
  try
    celldate := StrToDate(datestr);
    dateshift := Round(Self.begindate - celldate);
    if dateshift<0 then exit;
    //if dateshift > (Self.enddate - Self.begindate) then exit;
    RESULT := dateshift;
    exit;
  except
    exit;
  end;
  //синхронизация начала периода
  k := 0;
  repeat
    inc(k);
    datestr := MSExcel.ReadCellValue(Self.WSHTIMES, ROWDATE, k);
    if datestr>'' then
    try
      celldate := StrToDate(datestr);
      if Self.begindate < celldate then
       begin
         RESULT := Round(Self.begindate - celldate);
         exit;
       end;
      if Trunc(Self.begindate) = Trunc(celldate) then
        break;
    except
      datestr := '';
    end;
  until datestr = '';

  if datestr = '' then  //начало периода не найдено на листе  Times
    exit;               //возвращаем 0

  k0 := k; //нормальное значение: k0 = 1
  //поиск первой рассинхронизированной даты
  l := k0 + Round(Self.enddate - Self.begindate);
  repeat
    inc(k);
    datestr := MSExcel.ReadCellValue(Self.WSHTIMES, ROWDATE, k);
    if datestr='' then
     begin
      RESULT := k; //возвращаем смещение первой рассинхронизированной даты
      exit;
     end;
  until k > l;
end;

procedure TReporter.SynchronizeData(filexls: string);
var DataPool: TDataPool;
    Proc: TIBStoredProc;
    Transaction: TIBTransaction;
begin
  Self.SetPeriod(Self.begindate, Self.enddate);
  Self.tabelindex := Self.tabelrow;

  MSExcel.CallExcel(false);
  if MSExcel.WorkSheetIndex(Self.wbkName, WSHTIMES)=0 then
    MSExcel.AddWorkSheet(Self.wbkName, WSHTIMES);
  if MSExcel.WorkSheetIndex(Self.wbkName, WSHENTERS)=0 then
    MSExcel.AddWorkSheet(Self.wbkName, WSHENTERS);
  if MSExcel.WorkSheetIndex(Self.wbkName, WSHEXITS)=0 then
    MSExcel.AddWorkSheet(Self.wbkName, WSHEXITS);

  Self.dayshift := Self.SyncDataDate;   { TODO : очистить лист в зависимости от ответа }
//  if Self.dayshift > Self.enddate - Self.begindate then
//    exit; //данные уже синхронизированы
  if Self.dayshift < 0 then
    Self.dayshift := 0;

  DataPool.datacsv := Self.tabelcsv;
  DataPool.kit := PROC_STAFF_CROSSES_GET;
  DataPool.safe := True;
  DataPool.extproc :=  UnitReporter.externalprocedure;

  if FileExists(DataPool.datacsv) then
   begin
    Transaction := TIBTransaction.Create(nil);
    try
      Proc := TIBStoredProc.Create(nil);
      try
        Proc.Transaction := Transaction;
        DataLoader.IBInit(Proc);
        DataLoader.ProcessingDataPool(DataPool);
      finally
        FreeAndNil(Proc);
      end;
    finally
      Transaction.Free;
    end;
    Self.PrintDataDate(Self.dayshift);
    DeleteFile(DataPool.datacsv);
   end;
end;

function TReporter.produceStaffCrossesDataPool(tabno, filebuf: string): boolean;
begin
  RESULT := Self.TabelintermediadateProcessor.produceStaffCrossesDataPool(tabno, filebuf);
end;

procedure TReporter.SendLiveStatus;
begin
  if AppWindowHandle > 0 then
    PostMessage(AppWindowHandle,WM_LIVEFORM_MSG,0,Self.progressPercent);
end;

procedure TReporter.SetFileout(filecsv: string);
begin
  Self.TabelintermediadateProcessor.fileout := filecsv;
end;

procedure TReporter.SetOperationsSet(OperationsMask: byte);
var k: integer;
begin
  for k := 0 to  1 do
    if (OperationsMask AND ($01 SHL k)) > 0 then
      Self.FOperOptions := Self.FOperOptions + [k];
end;

procedure TReporter.SetPeriod(BeginDate, EndDate: TDateTime);
begin
  Self.TabelintermediadateProcessor.SetPeriod(BeginDate, EndDate);
  Self.begindate := Trunc(BeginDate);
  Self.enddate := Trunc(EndDate);
end;

initialization
  AppWindowHandle := 0;
  //CoInitializeEx(nil, COINIT_MULTITHREADED);
  Reporter := TReporter.Create; //TTabelintermediadateProcessor.Create;
finalization
  Reporter.Free;
  //CoUninitialize;
end.
