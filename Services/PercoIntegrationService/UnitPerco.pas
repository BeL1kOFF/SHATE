unit UnitPerco;

interface
uses UnitCSVReader, Windows, SysUtils, INIFiles, Classes
    ,IBDatabase, DB, IBDatabaseINI, DBLogDlg, IBCustomDataSet, IBStoredProc,
    XMLDoc, xmldom, ComObj, MSXML2_TLB, PERCo_S20_SDK_TLB,
    IdSMTP, IdCoderHeader, IdMessage, UnitDataExtProcessing;//
type

  TExternalProcessor = procedure (Dataset: TIBDataset);

  TDataPool = Record
    datacsv: string;
    kit: string;
    safe: boolean;
    extproc: TExternalProcessor;
    function dataExists: boolean;
    function datainterface: TCSVInterfaceType;
  End;

  TPercoDataLoader = Class
    private
      csvReader: UnitCSVReader.IUniversalCSVReader; //TCSVXReader;
      FFDBName, FFDBServer: string;
      FStoredProc: TIBStoredProc;
      FFBDatabase: TIBDatabase;
//      FDataPool: TDataPool;
      UserName, Password: string;

      function InitDataPool(DataPool: TDataPool): boolean;
      function ScanDataPool(DataPool: TDataPool): boolean;
//      function GrabbingDataPool(DataPool: TDataPool): boolean;
      function GrabbingDataPool(DataPool: TDataPool): boolean;
      procedure SetDatabaseName(fileFBD: string);
    public
      property FDBName: string read FFDBName write SetDatabaseName;
      property FDBServer: string read FFDBServer write FFDBServer;
      property StoredProc: TIBStoredProc read FStoredProc write FStoredProc;//; //read FStoredProc
      function ProcessingDataPool(DataPool: TDataPool): boolean;
      function IBInit(StoredProc: TIBStoredProc): boolean;

      procedure Init(fileini: string);
      constructor Create(); //Database: string
      destructor Destroy;  override;
  End;

  TAttributeDscr = Record
    attrName,
    attrvalue: string;
    isnotnull: boolean;
  End;

  TAttributesArray = array of TAttributeDscr;

  TAttributesProducer = Class
    var
      NodesList: TStringList;
    private
      FXMLDoc : IXMLDOMDocument;
      FTreeKeyIndex: integer;
      AttributesMap: array of TAttributesArray;
      function GetAttributeByName(nodename, attrname: string): string;
      function GenerateAttributeByName(nodename, attrname: string): IXMLDOMNode;
      procedure SetNodeAttributesString(node: string; attrSequence: string);
      function GetNodeAttrByIndex(index: integer): TAttributesArray;
      procedure SetNodeAttrByIndex(index: integer; AttrArr: TAttributesArray);
      function GetTreeKey: string;
      procedure SetTreeKey(TreeKeyName: string);
    public
      property Attribute[node: string; tag: string]: string read GetAttributeByName;
      property AttributeNode[node: string; tag: string]: IXMLDOMNode read GenerateAttributeByName;
      property NodeAttributesStr[node: string]: string write SetNodeAttributesString;
      property NodeAttributes[index: integer]: TAttributesArray read GetNodeAttrByIndex write SetNodeAttrByIndex;

      property TreeKey: string read GetTreeKey write SetTreeKey;
      procedure ProduceNodeAttributes(Node: IXMLDOMNode);
      function AddLine(Titles, Line: string; Node: IXMLDOMNode = nil): integer;
      procedure ProduceTreeAttributes(createKeyChild: boolean = false);
    class function ProduceAttributes(AttrNames, AttrValues: string; const delimiter: char = ';'; const null: char = #$A0): TAttributesArray;
    class function CloneAttributes(SourceNode, DestinationNode: IXMLDOMNode): TAttributesArray;
    constructor Create(XML: IXMLDOMDocument; specification: string);
    destructor Destroy; override;
  End;

  TMyIdMessage = class(TIdMessage)
  private
    logmsg: string;
  protected
    procedure OnISO(var VTransferHeader: TTransfer; var VHeaderEncoding: Char; var VCharSet: string);
  public
    constructor Create(AOwner: TComponent);
    function PostBySMTP(SMTP: TIdSMTP): boolean;
  end;

  TPercoCOMProcessor = Class//(TPERCO_1C_S20)
    const
      ACTTRANSL = 'append=СОЗДАН;update=изменён;delete=удалён;recovery=восстановлен';
      TYPETRANSL = 'staff=Сотрудники;appoint=Должности;subdiv=Подразделения';
      TYPEORDER = 'staff;appoint;subdiv';
      ENCODINGXML = 'Windows-1251';
    var
      ExtraProc: TPercoObjectsManager;
      ActList, TypeList: TStringList;
      OrdList: TStringList;
    private
      //XML: TXMLDocument;
      FText: string;

//      ExchangeMainIntf: Variant;

      FServer, FPort, FLogin, FPassword: string;
//      FileName: string;
      FDataType: string;
      FActionMode: string;
      FContentCode: string;
      FCSVFile: TCSVXReader;

      FDebugMode: boolean;
      FFaultConnection: integer;
      function GetFaultConn: boolean;
//      Attributer: TAttributesProducer
//      function GenerateXMLRequest(requesttype: string; params: TAttributesArray): IXMLDOMDocument;
      function GenerateXMLRequestEx(specification: string; paramparam: array of TAttributesArray): IXMLDOMDocument;
    public
      Intf: IExchangeMain;
      function GenerateDocumentRequest(attributes: TAttributesArray; var Node: IXMLDOMNode): IXMLDOMDocument;
      function GenerateNodesStairs(Node: IXMLDOMNode; Specification: string; AttrSet: TAttributesProducer): IXMLDOMNode;
      function ErrorRequest(): IXMLDOMDocument;

      function ErrorXMLtoString(ErrorXML: IXMLDOMDocument): string;

      class function SearchNodeByKey(Nodes: IXMLDOMNodeList; key: string; value: string): IXMLDOMNode;
      class procedure ClearNodes(Root: IXMLDOMNode; key: string);
    private
      procedure SetLogin(user: string);
      procedure SetPassword(pass: string);

      function getText: string;

      procedure InitSubstLists;
      procedure FreeSubstLists;
    public
      property Login: string read FLogin write SetLogin;
      property password: string write SetPassword;

      property Text: string read getText;
      property DebugMode: boolean read FDebugMode write FDebugMode;

      property FaultConn: boolean read GetFaultConn;

      procedure Init(fileini: string);

      function CheckAvailableConn: boolean;
//      procedure LoadPercoSTAFF;
//      procedure LoadPercoSTAFFEx;
//      procedure LoadPercoSubdivs;
//      procedure LoadPercoSubdivsEx;

      function ProcessingDataFile(Filename: string): boolean;
      function ProcessingCatalogue(filecsv, filexml, deltaxml: string): boolean;

      function ActionDescription(var title, translate: string):boolean;

      function SendFileRequest(Filename: string): boolean;
      function LoadFileRequest(typeNo: integer; FileName: string): boolean;
      function UpdateFileRequest(Filename: string):boolean;

      function LoadXMLRequest(tag: string): IXMLDOMDOcument;
      function MergeData(IXML: IXMLDOMDocument; filecsv: string; key: string; reportfile: string): IXMLDOMDocument;
      function UpdateXMLRequest(IXML: IXMLDOMDOcument): boolean;  //не задействовано
      function MatchingXMLData(IXML: IXMLDOMDocument): boolean;
      function TransformDOMDocument(IXML: IXMLDOMDocument; filexsl: string): IXMLDOMDocument;
      constructor Create();
      destructor Destroy; override;
  End;


  TPercoDataScaner = Class(TThread)
      ID: integer;
    private
      SDK: TPercoCOMProcessor;
      FBDBKit: TPercoDataLoader;

      FScanInterval: integer;
      FScanDirectory: string;
      FScanMask: string;
      FWorkdir: string;
      FScenario: string;
      FLogFile: string;
      FSMTP: TIdSMTP;
      FeMsg: TMyIdMessage;
      FeMailRet, FeMail: string;
      FeMailSubjTempl, FeMailMsgTempl: string;

      FDebug: boolean;
      FLastError: string;

      function GetScanInterval: integer;
      procedure SetScanInterval(interval: integer);
      function GetScanDir: string;
      procedure SetScanDir(Dir: string);
//      function GetScanMask: string;
//      procedure SetScanMask(Mask: string);
//      function GetSubDir: string;
//      procedure SetSubDir(SubDir: string);

      procedure SetMode(debug: boolean);
      function getLastErrorMsg: string;

      function GetScenarioChecking: boolean;

      function SendEmail(success: boolean): boolean;

      function TryMoveFile(var filename: string; trylimit: integer): integer;

      procedure PrintLogMsg(Msg: string);
    public
      property ScanInterval: integer read GetScanInterval write SetScanInterval;
      property ScanDirectory: string read GetScanDir write SetScanDir;
      property ScanMask: string read FScanMask write FScanMask;
      property WorkDir: string read FWorkdir write FWorkdir;
      property doScenario: boolean read GetScenarioChecking;

      property Debug: boolean read FDebug write SetMode;
      property LastError: string read getLastErrorMsg;

      procedure Init(Fileini: string);
      function ScenAct: boolean;
      procedure Scan;
      procedure Print(Msg: string);
      procedure Execute; override;
      constructor Create(index: integer = 0);
      destructor Destroy;  override;
  End;

//const
//  PROC_DOCS_INS = 'DOC_STAFF_FOR_1C_$INS';
//  PROC_STAFF_CROSSES_GET = '_CROSSES_FOR_PERIOD$GET';
var PercoImport: TPercoDataLoader;
    PercoCOM: TPercoCOMProcessor;
    ScanDaemon: TPercoDataScaner;
    SMTP: TIdSMTP;
implementation

uses  UnitAUX;

{ TPercoDataUploader }

constructor TPercoDataLoader.Create(); //Database: string
begin
  inherited;
  //! self.csvReader:= TInterfacedCSVFileReader.Create; //;{TCSVXReader} TInterfacedCSVStreamReader.Create;//
  Self.FFBDatabase := TIBDatabase.Create(nil);  //self.FFDBName := Database;
end;

destructor TPercoDataLoader.Destroy;
begin
  FreeAndNil(Self.FFBDatabase);
  //self.csvReader.Free;
inherited;
end;



function TPercoDataLoader.IBInit(StoredProc: TIBStoredProc): boolean;
//var   fileFBD: string;
begin
  Result := False;
  self.StoredProc := StoredProc;
  if StoredProc = nil then exit;

  if StoredProc.Database = nil then
    Self.StoredProc.Database := Self.FFBDatabase;
  self.StoredProc.Database.DatabaseName := Concat(Self.FFDBServer, ':', Self.FFDBName);

  Self.StoredProc.Database.LoginPrompt := False;
end;

procedure TPercoDataLoader.Init(fileini: string);
var
  iniFile: TINIFile;
begin
  iniFile := TINIFile.Create(fileini);
  try
    Self.FFDBServer := iniFile.ReadString('Perco', 'Host', '');
    Self.FFDBName := iniFile.ReadString('FirebirdDB','File','');
    Self.UserName := iniFile.ReadString('FirebirdDB','user_name','SYSDBA');
    Self.password := iniFile.ReadString('FirebirdDB','password','masterke');
  finally
    iniFile.Free;
  end;
end;

function TPercoDataLoader.InitDataPool(DataPool: TDataPool): boolean;
begin
  RESULT:=False;
  Self.csvReader.Line0Titles := DataPool.safe; //true => safe linking parameters by it's names
  if DataPool.dataExists then     //FileExists(Datapool.datacsv) or (true)
   begin
    RESULT:=self.csvReader.Open(DataPool.datacsv);
//    if   self.csvReader.Eof then self.csvReader.Close
//     else True;
   end;
end;

function TPercoDataLoader.ProcessingDataPool(DataPool: TDataPool): boolean;
begin
  RESULT:=False;
  if self.FStoredProc = nil then exit;
  if self.FStoredProc.Database = nil then exit;

  self.FStoredProc.Database.Connected := False;
  //self.FStoredProc.Database.DatabaseName := self.FDBName;
  self.FStoredProc.Database.Params.Clear;
  self.FStoredProc.Database.Params.Add('user_name='+Self.UserName);
  Self.FStoredProc.Database.Params.Add('PASSWORD='+Self.Password);

  Self.FStoredProc.Transaction.DefaultDatabase := Self.FStoredProc.Database;

  self.FStoredProc.StoredProcName := DataPool.kit;
  self.csvReader := BirthCSVInterface(DataPool.datainterface);
  if InitDataPool(DataPool) then
    RESULT := ScanDataPool(DataPool);
end;





function TPercoDataLoader.GrabbingDataPool(DataPool: TDataPool): boolean;
var
  Dataset: TIBDataSet;
  i: integer;
begin
  Result := False;
  DataSet := TIBDataSet.Create(nil);
  try  //self.FStoredProc.ExecProc;
    DataSet.Database := Self.FStoredProc.Database;
    DataSet.Transaction := Self.FStoredProc.Transaction;

    Dataset.SelectSQL.Text := GenerateParameterizedRequest(DataPool.kit,'Param',self.csvReader.FieldsCount);
    DataSet.Prepare;
    for i := 0 to DataSet.Params.Count - 1 do
      DataSet.Params[i].Value := Self.FStoredProc.ParamByName(Self.csvReader.Titles[i]).Value;
    DataSet.Open;
    try
      Datapool.extproc(DataSet);
    finally
      Dataset.Close;
    end;
  finally
    DataSet.Free;
  end;
end;

function TPercoDataLoader.ScanDataPool(DataPool: TDataPool): boolean;
var k, w: integer;
  procreport: string;
begin
  RESULT:=False;

  procreport := ChangeFilePath(self.csvReader.CurFileName, ExtractFilePath(Paramstr(0)));
  procreport := ChangeFileExt(transformFileName(procreport),'.report');
try
  self.FStoredProc.Database.Connected := True;
  self.FStoredProc.Prepare;


  try
      repeat
        self.csvReader.ReturnLine;
        if self.csvReader.Line0Titles then
         begin   // params assigned by it's names
          w := self.csvReader.TitlesCount;
          for k := 0 to w - 1 do
          try
            if Assigned(self.FStoredProc.ParamByName(self.csvReader.Titles[k])) then
              self.FStoredProc.ParamByName(self.csvReader.Titles[k]).Value:=self.csvReader.Fields[k];
          except on E: EDatabaseError do
            begin
              PrintLog(Format('Обработка строки {%s} вызвало исключение "%s"',[Self.csvReader.CurrentLine,E.Message]),procreport);
              if Self.csvReader.LineNum < 1 + Cardinal(Self.csvReader.Line0Titles) then
               begin
                PrintTimestamp('Выполнение прервано', procreport);
                exit;
               end
               else
                continue;
            end;
          end;
         end
         else
         begin // params assigned by it's order
          w := self.FStoredProc.ParamCount;

          for k := 0 to w - 1 do
            if k < self.csvReader.FieldsCount then
              self.FStoredProc.Params[k].Value:=self.csvReader.Fields[k];
         end;
        if Assigned(DataPool.extproc) then
          Self.GrabbingDataPool(DataPool) //saving results for external processing
         else
          self.FStoredProc.ExecProc;      //simple
      until self.csvReader.Eof;

  except on E: Exception do
   begin
    PrintLog(Format('Обработка строки {%s} вызвало исключение "%s"',[Self.csvReader.CurrentLine,E.Message]),procreport);
    if Self.csvReader.LineNum < 1 + Cardinal(Self.csvReader.Line0Titles) then
     begin
      PrintTimestamp('Вполнение прервано', procreport);
      exit;
     end;
   end;
    //self.FStoredProc.Database.DefaultTransaction.Rollback;
  end;
  RESULT := self.csvReader.Eof;
finally
    self.csvReader.Close;
    self.FStoredProc.Database.Connected := False;
end;

end;

procedure TPercoDataLoader.SetDatabaseName(fileFBD: string);
var RootFBD: string;
    p0s: Integer;
begin
  p0s := pos(':',fileFBD);
  if p0s = 0 then p0s := pos('$', fileFBD);
  if p0s = 0  then exit;

  RootFBD := copy(fileFBD, 1, p0s-1);
  if p0s = 2 then
   begin
    Self.FFDBName := fileFBD;
    if Self.FFDBServer = '' then Self.FFDBServer := 'localhost';
   end
   else
   begin
    Self.FFDBServer := RootFBD; //ExtractFileDir(RootFBD);

//    p0s := pos(':',fileFBD);
//    if p0s = 0 then p0s := pos('$', fileFBD);

    Self.FFDBName := copy(fileFBD, p0s+1);
   end;
end;

{ TPercoCOMProcessor }

function TPercoCOMProcessor.CheckAvailableConn: boolean;
begin
  Self.FFaultConnection := Self.Intf.SetConnect(Self.FServer, Self.FPort, Self.FLogin, Self.FPassword);
  if Self.FFaultConnection=0 then
    Self.Intf.DisConnect
   else
    Self.FText := Self.ErrorXMLtoString(Self.ErrorRequest());

  RESULT := Self.FFaultConnection=0;
end;

class procedure TPercoCOMProcessor.ClearNodes(Root: IXMLDOMNode; key: string);
const CLEARVALUE = '';
var
  {k,} L: integer;
  Node, Attr: IXMLDOMNode;
  Nodes: IXMLDOMNodelist;
begin
  Nodes := Root.childNodes;
  L := Nodes.length;
  if L = 0 then exit;

  Node := Nodes.item[0];
  repeat
    Attr := Node.attributes.getNamedItem(key);

    if Assigned(Attr) then 
     if Attr.nodeValue = CLEARVALUE then
      Root.removeChild(Node); 
      
    Node := Nodes.nextNode;
   until Node = nil;
end;

constructor TPercoCOMProcessor.Create();
begin
  inherited;

  Intf := CreateOleObject('PERCo_S20_SDK.ExchangeMain') as IExchangeMain;

  Self.FCSVFile := {TCSVXReader} TInterfacedCSVFileReader.Create;


  Self.FServer := '10.0.20.177';
  Self.FPort := '211';
  Self.FLogin := 'tester';
  Self.FPassword := '12345';
end;

destructor TPercoCOMProcessor.Destroy;
begin

  Self.FreeSubstLists;

  {Self.FCSVFile.Free;}
  inherited;
end;

function TPercoCOMProcessor.ErrorRequest: IXMLDOMDocument;
var Error: IXMLDOMDocument;//: IDispatch;//Variant;
begin
  Error := CreateOleObject('MSXML2.DOMDocument.3.0') as IXMLDOMDocument;
  Self.Intf.GetErrorDescription(IDispatch(Error));
  RESULT:=Error as IXMLDOMDocument;
end;

function TPercoCOMProcessor.ErrorXMLtoString(ErrorXML: IXMLDOMDocument): string;
var
  NodeList: IXMLDOMNodeList;
  Node: IXMLDOMNode;
  k: integer;
  strErr: string;
begin
  RESULT:='';
  NodeList := ErrorXML.getElementsByTagName('error');
  for k := 0 to NodeList.length - 1 do
   begin
    Node := NodeList.item[k].attributes.getNamedItem('error');
    strErr := strErr + Node.nodeValue + #10 + #13;
   end;
  if strErr <> '' then
    RESULT := strErr; 
end;

procedure TPercoCOMProcessor.FreeSubstLists;
begin
  FreeAndNil(Self.OrdList);

  FreeAndNil(Self.ActList);
  FreeAndNil(Self.TypeList);
end;

function TPercoCOMProcessor.GenerateDocumentRequest(attributes: TAttributesArray; var Node: IXMLDOMNode): IXMLDOMDocument;
const
  REQUEST = 'documentrequest';
var IXML: IXMLDOMDocument;
  IRoot, IAttribute: IXMLDOMNode;
  k, l: integer;
  PreambleXML: string;
begin
  RESULT := nil;
  PreambleXML := Format('version="1.0" encoding="%s"  standalone="yes"',[Self.ENCODINGXML]);

  IXML := CreateOleObject('MSXML2.DOMDocument.3.0') as IXMLDOMDocument;//XML.DOMDocument;    UTF-8
  IRoot := IXML.appendChild(IXML.createProcessingInstruction('xml',PreambleXML));//IXML.createElement('xml'));

  Node := IXML.appendChild(IXML.createElement(REQUEST));

  l := Length(attributes);
  for k := 0 to l - 1 do
   begin
    IAttribute := IXML.createAttribute(attributes[k].attrName);
    if attributes[k].isnotnull then
      IAttribute.nodeValue := attributes[k].attrvalue;
    Node.attributes.setNamedItem(IAttribute);
   end;
  RESULT := IXML;
end;

function TPercoCOMProcessor.GenerateNodesStairs(Node: IXMLDOMNode; Specification: string;
  AttrSet: TAttributesProducer): IXMLDOMNode;
var
  ListNodes : TStringList;
  k{, l}: integer;
  XMLDoc: IXMLDOMDocument;

begin
  RESULT := nil;
  if Node = nil then exit;

  XMLDoc := Node.ownerDocument;

  ListNodes := TStringList.Create;
  try
    ListNodes.Delimiter := ';';
    ListNodes.DelimitedText := Specification;
//    l := ListNodes.Count;
    for k := 0 to ListNodes.Count - 1 do
     begin
      Node := Node.appendChild(XMLDoc.createElement(ListNodes[k]));
      AttrSet.ProduceNodeAttributes(Node);
     end;
  finally
    ListNodes.Free;
  end;
  RESULT := Node;
end;

(*function TPercoCOMProcessor.GenerateXMLRequest(requesttype: string; params: TAttributesArray): IXMLDOMDocument;
const
  REQUEST = 'documentrequest';
var IXML: IXMLDOMDocument;//Variant;//IDOMDocument;
  IRoot, INode, {IChild,} IAttribute: Variant;
  k, l: integer;
begin
  IXML := CreateOleObject('MSXML2.DOMDocument.3.0') as IXMLDOMDocument;//XML.DOMDocument;    UTF-8
  IRoot := IXML.appendChild(IXML.createProcessingInstruction('xml','version="1.0" encoding="Windows-1251"  standalone="yes"'));//IXML.createElement('xml'));

  INode := IXML.appendChild(IXML.createElement(REQUEST));
  IAttribute := IXML.createAttribute('type');
  IAttribute.nodeValue := requesttype;
  INode.attributes.setNamedItem(IAttribute);

  l:=Length(params);
  for k := 0 to l - 1 do
   begin
    IAttribute := IXML.createAttribute(params[k].attrName);
    if params[k].isnotnull then
     IAttribute.nodeValue := params[k].attrvalue;
    INode.attributes.setNamedItem(IAttribute);
   end;
  RESULT:=IXML ;  // as IXMLDOMDocument
end;*)

function TPercoCOMProcessor.GenerateXMLRequestEx(specification: string;
  paramparam: array of TAttributesArray): IXMLDOMDocument;
const
  delim = ';';
var IXML: IXMLDOMDocument;//Variant;//IDOMDocument;
  IRoot, INode, {IChild, }IAttribute: Variant;
  k, l: integer;
  p: integer;
  factor: string;
  ll: integer;
  params: TAttributesArray;
begin
  IXML := CreateOleObject('MSXML2.DOMDocument.3.0') as IXMLDOMDocument;//XML.DOMDocument;  UTF-8
  IRoot := IXML.appendChild(IXML.createProcessingInstruction('xml','version="1.0" encoding="Windows-1251"  standalone="yes"'));//IXML.createElement('xml'));

  INode := IXML;
  ll:=length(paramparam);
  repeat
    p:=pos(delim,specification);
    if p>0 then
     begin
      factor := copy(specification,1,p-1);
      specification := copy(specification,p+1);
     end
     else
      factor := specification;
    factor := trim(factor);
    if factor<>'' then
     begin
      INode := INode.appendChild(IXML.createElement(factor));

      if ll>0 then
       begin
        params:=paramparam[length(paramparam)-ll];
        l:=Length(params);
        for k := 0 to l - 1 do
         begin
          IAttribute := IXML.createAttribute(params[k].attrName);
          if params[k].isnotnull then
           IAttribute.nodeValue := params[k].attrvalue;
          INode.attributes.setNamedItem(IAttribute);
         end;
       end;

       if factor<>self.FDataType then
        IRoot := INode
       else
        INode := IRoot;
     end;
    dec(ll);
  until p*ll=0;
  
  RESULT:=IXML ;
end;

function TPercoCOMProcessor.GetFaultConn: boolean;
begin
  RESULT := Self.FFaultConnection<>0;
end;

function TPercoCOMProcessor.getText: string;
begin
  RESULT := self.FText;
end;

procedure TPercoCOMProcessor.Init(fileini: string);
var
  iniFile: TINIFile;
begin
  iniFile := TINIFile.Create(fileini);
  try
    Self.FServer := iniFile.ReadString('PERCO','Host','');
    Self.FPort := iniFile.ReadString('PERCO','Port','');
    Self.Login := iniFile.ReadString('PERCO','userlogin','');
    Self.password := iniFile.ReadString('PERCO','userpassword','');




  finally
    iniFile.Free;
  end;
  Self.ExtraProc := PercoObjectsManager;
  InitSubstLists();
end;



procedure TPercoCOMProcessor.InitSubstLists;

begin
  TypeList := TStringList.Create;

  //TypeList.Delimiter := ';';
  TypeList.NameValueSeparator:='=';
  TypeList.Text := StringReplace(TYPETRANSL,';',#$D#$A,[rfReplaceAll]);
  
  ActList := TStringList.Create;

  //ActList.Delimiter := ';';
  ActList.NameValueSeparator := '=';
  ActList.Text := StringReplace(ACTTRANSL,';',#$D#$A,[rfReplaceAll]);
    
  OrdList := TStringList.Create;
  OrdList.NameValueSeparator := '=';
  OrdList.Text := StringReplace(TYPEORDER,';',#$D#$A,[rfReplaceAll]);

  //OrdList.InsertObject();
end;

function TPercoCOMProcessor.ProcessingCatalogue(filecsv, filexml, deltaxml: string): boolean;
const KEY = 'id_external';
var //p0, p: integer;
  IXML: IXMLDOMDOcument;
  filename, filexslt, filereport: string;
  doMatching: boolean;
begin
  RESULT :=False;
  Self.FText := filecsv;
  if not FileExists(filecsv) then exit;

  doMatching := (filexml = '') and ((deltaxml = '') or self.FDebugMode);

  //Self.FDataType := '';
  filename := ExtractFileName(filecsv);
//  p0:=pos('=',filename);
//  p:=p0 + pos('=',copy(filename,p0+1));
//  if p0*p*(p-p0)>0 then
//    Self.FDataType := copy(filename,p0+1,p-p0-1);
  Self.FDataType := separate(filename,'=','=');

  if filexml = '' then
   begin
  //выгрузка справочника в XML
    IXML := Self.LoadXMLRequest(self.FDataType);
    if IXML = nil then exit;
   end
   else
   begin
  //вариант загрузки предварительно сохранённого справочника
    IXML := CreateOleObject('MSXML2.DOMDocument.3.0') as IXMLDOMDocument;
    if not IXML.load(filexml) then exit;
   end;

  //IXML.save('C:\Subdivs_beforeTransform');
  filexslt := Concat('=',Self.FDataType,'=}','.xtr');   //трансформация в каталоге приложения ExtractFilePath(filename),
  if FileExists(filexslt) then
    IXML := Self.TransformDOMDocument(IXML,filexslt);
  { TODO 2 : add here success operration check and saving report }

  filereport := Concat(ExtractFilePath(filecsv), FormatDateTime(FORMATFILETIMESTAMP,Now())+'=' + Self.FDataType + '=.report');
  //IXML.save('C:\MergeSubdivs');
  IXML := Self.MergeData(IXML, filecsv, KEY, filereport);
  if IXML = nil then exit;

  if deltaxml > '' then  IXML.save(deltaxml);



  filexslt := Concat('{=',Self.FDataType,'=','.xtr');
  if FileExists(filexslt) then
    IXML := Self.TransformDOMDocument(IXML,filexslt);

//  if (filexml > '') or (deltaxml > '') then exit;
  if Assigned(IXML) then
   begin
    if self.FDebugMode then
      IXML.save(transformFileName('Merging(='+Self.FDataType+'=).xml') );
    if doMatching then
      RESULT := Self.MatchingXMLData(IXML)  //Self.UpdateXMLRequest(IXML);;
     else
      RESULT := True;
   end;
end;

function TPercoCOMProcessor.ProcessingDataFile(Filename: string): boolean;
const LOAD_SPECIFICATION = 'documentrequest;login;workmode';
var //p0, p: integer;
    AttrArr2 : array of TAttributesArray;
    Specification: string;
    Titles: string;//TStringList;
    Line: string;
    L: integer;
    IXML: IXMLDOMDocument;
    //IRoot, INode, IChild, IAttribute: Variant;
    saveFilename: string;
begin
  RESULT :=False;
  Self.FText := FileName;

  if not FileExists(FileName) then exit;


  Self.FCSVFile.Open(Filename);
  try

    FileName := ExtractFileName(Filename);
//    p0:=pos('[',Filename);
//    p:=pos(']',Filename);
//    Self.FDataType := copy(FileName,p0+1,p-p0-1);

    Self.FDataType := separate(Filename,'[',']');

    //FileName := copy(FileName, p+1);
    //Self.FActionMode := 'all_action';
//    if FileName<>'' then
//     begin
//      p0:=pos('{',Filename);
//      p:=pos('}',Filename);
//      if p0*p*(p-p0)>0 then
//       Self.FActionMode := copy(FileName,p0+1,p-p0-1);
//     end;

    Self.FActionMode := substitution(separate(Filename, '{','}'), 'all_action');


//    Self.FContentCode := '';
//    if FileName<>'' then
//     begin
//      p0:=pos('#',Filename);
//      p:=p0+pos('#',copy(Filename,p0+1));
//      if p0*p*(p-p0)>0 then
//       Self.FContentCode := copy(FileName,p0+1,p-p0-1);
//     end;
    Self.FContentCode := separate(Filename, '#', '#');

    SetLength(AttrArr2,3);
    AttrArr2[0] := TAttributesProducer.ProduceAttributes('type',Self.FDataType);
      AttrArr2[1] := TAttributesProducer.ProduceAttributes('loginname',self.FLogin);
        AttrArr2[2] := TAttributesProducer.ProduceAttributes('mode',self.FActionMode);  //'all_action'

    Specification := LOAD_SPECIFICATION;
    Titles := Self.FCSVFile.ReturnLine;
    Self.FText := Titles;
    if self.FCSVFile.Eof then exit;
    L := Length(AttrArr2);
    repeat
      Line := Self.FCSVFile.ReturnLine;
      if Line = '' then break;
      Self.FText := Line;
      Specification := Specification +';'+ Self.FDataType;
      SetLength(AttrArr2, L+1);
      AttrArr2[L] := TAttributesProducer.ProduceAttributes(Titles,Line);
      inc(L);
    until Self.FCSVFile.Eof;

  finally
    Self.FCSVFile.Close;
  end;

  if self.Intf.SetConnect(Self.FServer,Self.FPort,Self.FLogin,Self.FPassword) = 0 then
  try
    Self.FFaultConnection := 0;
    IXML := Self.GenerateXMLRequestEx(Specification,AttrArr2);
    if IXML <> nil then
     begin

      if Self.FDebugMode then      
       begin
        saveFileName := FormatDateTime(FORMATFILETIMESTAMP, Now());
        saveFilename := ExtractFilePath(Paramstr(0)) +'Set'+Self.FDataType+ saveFilename+'.XML';
        if DirectoryExists(ExtractFilePath(Paramstr(0))+'\XMLRequests') then
          ChangeFilePath(saveFilename,ExtractFilePath(Paramstr(0))+'\XMLRequests');
        IXML.save(saveFilename);
       end;
      Self.ExtraProc.PreProcessing(Self.FDataType, Self.FActionMode, Self.FContentCode);
      if self.Intf.SendData(IXML as IDispatch)<>0 then
        self.FText := Self.ErrorXMLtoString(Self.ErrorRequest())
       else
        RESULT := True;
      Self.ExtraProc.PostProcessing(Self.FDataType, Self.FActionMode, Self.FContentCode);
     end;
  finally
    self.Intf.DisConnect;
  end
  else
  begin
    Self.FFaultConnection := 1;
    Self.FText := Format('Пользователю %s НЕ удалось установить соединение с сервером %s ', [FLogin, FServer]);
  end;
end;

function TPercoCOMProcessor.LoadFileRequest(typeNo: integer; FileName: string): boolean;
const
  REQUEST = 'documentrequest';
var IXML: IXMLDOMDOcument;
//  IRoot, INode, IChild, IAttribute: IXMLDOMNode;
  arr: array of TAttributesArray;
  TypeTag {, AttrNames, AttrValues}: string;
begin
  RESULT:=False;
  setLength(arr,0); TypeTag := '';
  case  TypeNo of
  0:
    begin //staff
      setLength(arr,1);
      arr[0] :=  (TAttributesProducer.ProduceAttributes('type;mode_display','staff;employ'));
      TypeTag := 'staff';
    end;
  1:
    begin  //appoints
      setLength(arr,1);
      arr[0] :=  (TAttributesProducer.ProduceAttributes('type','appoint'));
      TypeTag := 'appoints';
    end;
  2:
    begin   //subdivs
      setLength(arr,1);
      arr[0] :=  (TAttributesProducer.ProduceAttributes('type','subdiv'));
      TypeTag := 'subdivs';
    end;

  end;


  if self.Intf.SetConnect(self.FServer,Self.FPort,Self.FLogin,Self.FPassword) = 0 then
  try

    IXML := self.GenerateXMLRequestEx(REQUEST,arr); //employ
    if IXML <> nil then
     begin
      IXML.save(ExtractFilePath(Paramstr(0)) +Concat('=',TypeTag,'=') +'Get.XML');
      if self.Intf.GetData(IXML as IDispatch)<>0 then
        self.FText := Self.ErrorXMLtoString(Self.ErrorRequest())
       else
       begin
        IXML.save(FileName);
        self.FText := IXML.xml;
        RESULT := True;
       end;
     end;
  finally
    self.Intf.DisConnect;
  end;
end;

function TPercoCOMProcessor.LoadXMLRequest(tag: string): IXMLDOMDOcument;
const
  REQUEST = 'documentrequest';
  DIMNAME = 0;
  DIMVAL = 1;
  ATTRSEQUENCE: array[0..2, 0..1] of string = (('type;mode_display','staff;employ'),('type','appoint'),('type','subdiv'));
var IXML: IXMLDOMDOcument;
  typeindex: integer;
//  IRoot, INode, IChild, IAttribute: IXMLDOMNode;
  arr: array of TAttributesArray;
  //TypeTag , AttrNames, AttrValues: string;
begin
  RESULT := nil;
  typeindex := Self.OrdList.IndexOf(tag);
  if typeindex<0 then exit;

  setLength(arr,1);
  arr[0] :=  (TAttributesProducer.ProduceAttributes(ATTRSEQUENCE[typeindex,DIMNAME],ATTRSEQUENCE[typeindex,DIMVAL]));


  if self.Intf.SetConnect(self.FServer,Self.FPort,Self.FLogin,Self.FPassword) = 0 then
  try
    IXML := self.GenerateXMLRequestEx(REQUEST,arr);
    if IXML <> nil then
      if Self.Intf.GetData(IXML as IDispatch)<>0 then
        Self.FText := Self.ErrorXMLtoString(Self.ErrorRequest())
       else
        RESULT := IXML;
  finally
    self.Intf.DisConnect;
  end;
end;

function TPercoCOMProcessor.MatchingXMLData(IXML: IXMLDOMDocument): boolean;
const ACTORDER: array[1 .. 3] of string = ('append','update','delete');
var
//  workmode , datatype: string;
  attributes: TAttributesArray;
  AttrProducer: TAttributesProducer;
  specification: string;
  
  CommandXML: IXMLDOMDocument;
  Root0, Node0,  NodeChild, Node {, NodeLine}: IXMLDOMNode;
  ChildNodes: IXMLDOMNodelist;
  actindex: integer;
begin
  RESULT := False;
  Root0 := IXML.getElementsByTagName('Root').item[0];
  if Root0 = nil then exit;

  for actindex := Low(ACTORDER) to High(ACTORDER) do
   begin
    if IXML.getElementsByTagName(ACTORDER[actindex]).length = 0 then continue;
    
    Node0 := IXML.getElementsByTagName(ACTORDER[actindex]).item[0];  // <append>, <update> or <delete> ...
    if Node0.hasChildNodes then
     begin
      ChildNodes := Node0.childNodes;    //большая разница!!!
      NodeChild := Node0.childNodes[0];
      while Assigned(NodeChild) do
        if (NodeChild.nodeName <> Self.FDataType) then
          NodeChild := ChildNodes.nextNode
         else
          break; //search for <staff>, <subdiv> or <appoint>
      if NodeChild = nil then continue; // absend actions node
      Node0 := NodeChild;
      if Node0.hasChildNodes then
       begin
        ChildNodes := Node0.childNodes;
        NodeChild := ChildNodes.item[0];
        repeat
          if NodeChild.nodeName = Self.FDataType + 'node' then
           begin
             //processing action
            attributes := TAttributesProducer.ProduceAttributes('type',Self.FDataType);

            CommandXML := Self.GenerateDocumentRequest(attributes, Node);

            specification := 'login;workmode';
            AttrProducer := TAttributesProducer.Create(CommandXML,specification);
            try
              AttrProducer.NodeAttributesStr['login']:= Format('loginname=%s',[Self.FLogin]);
              AttrProducer.NodeAttributesStr['workmode']:= Format('mode=%s',[ACTORDER[actindex]]);
              Node := Self.GenerateNodesStairs(Node, specification, AttrProducer);
              Node := Node.appendChild(CommandXML.createElement(Self.FDataType));
              AttrProducer.CloneAttributes(NodeChild, Node);
            finally
              FreeAndNil(AttrProducer);
            end;

            if self.Intf.SetConnect(Self.FServer,Self.FPort,Self.FLogin,Self.FPassword) = 0 then
            try
              //CommandXML.save(transformFileName('C:\CommandXML'));
              if self.Intf.SendData(CommandXML as IDispatch)<>0 then //Update
                //self.FText := Self.ErrorXMLtoString(Self.ErrorRequest());
                PrintLog(Self.ErrorXMLtoString(Self.ErrorRequest()),'Errors.log');
            finally
              Self.Intf.DisConnect;
            end;

           end;
          NodeChild := ChildNodes.nextNode;
        until NodeChild = nil;
       end;
     end;
   end;
  RESULT := True;
end;

function TPercoCOMProcessor.MergeData(IXML: IXMLDOMDocument;  filecsv, key, reportfile: string): IXMLDOMDocument;
const 
  ACTAPPEND = 'append';
  ACTUPDATE = 'update';
  ACTDELETE = 'delete';
var
  k, w: integer;
  line {, title}: string;
  ProtectedAttributes: array of boolean;
//  keyindex: integer;
  keyvalue: string;
  reportline: string;
  RootNode, LineNode, Attribute:  IXMLDOMNode;
  NodesList: IXMLDOMNodeList;
  actionTag: string;
  Delta: IXMLDOMDocument;
  DeltaTree: IXMLDOMNode;
  BranchAppend, BranchUpdate, BranchDelete: IXMLDOMNode;
  DiffNode: IXMLDOMNode;
begin
  RESULT := nil;
  Delta := CreateOleObject('MSXML2.DOMDocument.3.0') as IXMLDOMDocument;
  DeltaTree := Delta.appendChild(Delta.createProcessingInstruction('xml','version="1.0" encoding="Windows-1251"  standalone="yes"'));
  RootNode:=Delta.appendChild(Delta.createElement('Root'));
  BranchAppend := RootNode.appendChild(Delta.createElement(ACTAPPEND));
    BranchAppend := BranchAppend.appendChild(Delta.createElement(self.FDataType));
  BranchUpdate := RootNode.appendChild(Delta.createElement(ACTUPDATE));
    BranchUpdate := BranchUpdate.appendChild(Delta.createElement(self.FDataType));
  BranchDelete := RootNode.appendChild(Delta.createElement(ACTDELETE));
//  Self.FCSVFile.
  Self.FCSVFile.Line0Titles := True;
  if Self.FCSVFile.Open(filecsv) then
  try
    w := Self.FCSVFile.TitlesCount;
    NodesList:= IXML.getElementsByTagName(Self.FDataType);

    if NodesList = nil then exit;
    if NodesList.length > 0 then
      RootNode := NodesList.item[0]
     else
      exit;
    if RootNode.hasChildNodes then
      NodesList := RootNode.childNodes
     else
      exit;

    SetLength(ProtectedAttributes, w);
    for k := 0 to w - 1 do
     ProtectedAttributes[k] := Self.FCSVFile.Titles[k] = UpperCase(Self.FCSVFile.Titles[k]);
    Self.FCSVFile.TitleLine := LowerCase(Self.FCSVFile.TitleLine);

    repeat
      line := Self.FCSVFile.ReturnLine;
      keyvalue:=Self.FCSVFile.Field[key];
      actionTag := '';
      { TODO : here search XML node and merging attributes with csv fields }
      LineNode := SearchNodeByKey(NodesList, key, keyvalue);
      if LineNode = nil then
       begin
        actionTag := ACTAPPEND;
        reportline := 'Не удалось сопоставить строку справочника #' + keyvalue;
        PrintLog(reportline, reportfile);
        { TODO : here addition to treeappend }
        LineNode := Delta.createElement(self.FDataType + 'node');
        for k := 0 to w - 1 do
         begin
          Attribute := Delta.createAttribute(Self.FCSVFile.Titles[k]);
          Attribute.nodeValue := Self.FCSVFile.Fields[k];
          LineNode.attributes.setNamedItem(Attribute);
         end;
         BranchAppend.appendChild(LineNode);
        continue;
       end;


      for k := 0 to w - 1 do
       begin
        if ProtectedAttributes[k] then continue;

        Attribute := LineNode.attributes.getNamedItem(Self.FCSVFile.Titles[k]);
        if Attribute = nil then
         begin
           reportline := '#' + keyvalue + ' Не удалось сопоставить атрибут ' + Self.FCSVFile.Titles[k];
           PrintLog(reportline, reportfile);
           continue; //for ...
         end;

        if Self.FCSVFile.Titles[k]<>key then
         begin //не ключевой атрибут
          if Attribute.nodeValue <> Self.FCSVFile.Fields[k] then
           begin                  
            actionTag := ACTUPDATE;
            reportline := '#' + keyvalue + ': '+Attribute.nodeName+' = ' + Attribute.nodeValue + ' --> ';
            Attribute.nodeValue := Self.FCSVFile.Fields[k];  //бесполезно
            { TODO : here addition to treeupdate }
            reportline := reportline + Self.FCSVFile.Fields[k];
            PrintLog(reportline, reportfile);
           end;  { TODO : "else ..."  - here may be possible delete attributes which were not modified }
         end
         else //ключевой атрибут помечаем как сопоставленный
            Attribute.nodeValue := '';
       end;
      if actionTag = ACTUPDATE then
       begin        
        DiffNode := BranchUpdate.appendChild(LineNode.cloneNode(True)); //clone node for update parameters
        { TODO :Note!  node clone and rename to DiffTree,
          --mode "update" performed by internal identifier}
        DiffNode.attributes.getNamedItem(key).nodeValue := keyvalue;    //recovery external key in clone  
       end;
      RootNode.removeChild(LineNode);
    until Self.FCSVFile.Eof;
    //IXML.save('C:\TewstDeleted');
    { TODO : here addition to treedelete }
    ClearNodes(RootNode, key); //удаление пока не трогаем поскольку неопределена дата увольнения
    //IXML.save('C:\TewstDeleted0');
    //RESULT := Self.FCSVFile.Eof;
    BranchDelete.appendChild(RootNode.cloneNode(true));
    RESULT := Delta;
    if self.FDebugMode then
      Delta.save(transformFileName('Delta(='+Self.FDataType+'=).xml') );
  finally
    Self.FCSVFile.Close;
  end;
end;

class function TPercoCOMProcessor.SearchNodeByKey(Nodes: IXMLDOMNodeList; key, value: string): IXMLDOMNode;
var
  k, L: integer;
  Node, Attr: IXMLDOMNode;
begin
  RESULT := nil;
  if value='' then exit;

  L := Nodes.length;
   { TODO : for optimization in future: k may takes not all values and finded values must be marked }
  for k:= 0 to L - 1 do
   begin
    Node := Nodes.item[k];
    if Node = nil then exit;

    Attr := Node.attributes.getNamedItem(key);
    if Attr = nil then continue;

    if Attr.nodeValue = value then
     begin
      RESULT := Node;
      break; //possible mark k-value as linking
     end;
   end;
   //if k<L then RESULT := Node; //after optimization in future
   
end;

function TPercoCOMProcessor.SendFileRequest(Filename: string): boolean;
var IXML: IXMLDOMDOcument;
begin
  Result := False;
  if self.Intf.SetConnect(Self.FServer,Self.FPort,Self.FLogin,Self.FPassword) = 0 then
  try

    IXML := CreateOleObject('MSXML2.DOMDocument.3.0') as IXMLDOMDocument;

    if IXML <> nil then
     begin
      IXML.load(Filename);
      if self.Intf.SendData(IXML as IDispatch)<>0 then //Update
       self.FText := Self.ErrorXMLtoString(Self.ErrorRequest());
     end;
  finally
    self.Intf.DisConnect;
  end;
end;

procedure TPercoCOMProcessor.SetLogin(user: string);
begin
  Self.FLogin := Trim(user);
end;

procedure TPercoCOMProcessor.SetPassword(pass: string);
begin
  Self.FPassword := pass;
end;

function TPercoCOMProcessor.TransformDOMDocument(IXML: IXMLDOMDocument; filexsl: string): IXMLDOMDocument;
var
  XML, XSLT: IXMLDOMDocument;
begin
  RESULT := IXML;
  { TODO 1 : here doing XSLT transformation into typical XML-catalogue format }
  XSLT := CreateOleObject('MSXML2.DOMDocument.3.0') as IXMLDOMDocument;
  if XSLT.load(filexsl) then
   try
    XML := CreateOleObject('MSXML2.DOMDocument.3.0') as IXMLDOMDocument;
    Assert(Assigned(XML));
    IXML.transformNodeToObject(XSLT, XML);  //fix - XML.loadXML(IXML.transformNode(XSLT));
    
    if XML.parseError.errorCode = 0 then
      RESULT := XML;
   except
     raise;
   end;
end;

function TPercoCOMProcessor.ActionDescription(var title, translate: string): boolean;
begin
  title := Concat(Self.FDataType,';', Self.FActionMode,';', Self.FContentCode);
  translate := Concat(Self.TypeList.Values[FDataType],';',Self.ActList.Values[FActionMode],';', Self.FContentCode);
  RESULT := True;
end;

function TPercoCOMProcessor.UpdateFileRequest(Filename: string): boolean;
var IXML: IXMLDOMDOcument;
begin
  Result := False;
  if self.Intf.SetConnect(Self.FServer,Self.FPort,Self.FLogin,Self.FPassword) = 0 then
  try

    IXML := CreateOleObject('MSXML2.DOMDocument.3.0') as IXMLDOMDocument;

    if IXML <> nil then
     begin
      IXML.load(Filename);
      if self.Intf.UpdateData(IXML as IDispatch)<>0 then //Update
       self.FText := Self.ErrorXMLtoString(Self.ErrorRequest());
     end;
  finally
    self.Intf.DisConnect;
  end;
end;

function TPercoCOMProcessor.UpdateXMLRequest(IXML: IXMLDOMDOcument): boolean;
begin
  RESULT := False;
  if self.Intf.SetConnect(Self.FServer,Self.FPort,Self.FLogin,Self.FPassword) = 0 then
  try
    //IXML := CreateOleObject('MSXML2.DOMDocument.3.0') as IXMLDOMDocument;   //bug!!!
    if IXML <> nil then
      if self.Intf.UpdateData(IXML as IDispatch)<>0 then
        self.FText := Self.ErrorXMLtoString(Self.ErrorRequest())
       else
        RESULT := True;
  finally
    self.Intf.DisConnect;
  end;
end;

{ TAttributesProducer }

function TAttributesProducer.AddLine(Titles, Line: string; Node: IXMLDOMNode = nil): integer;
begin
  RESULT := Self.NodesList.Count;
  ;
  SetLength(Self.AttributesMap, RESULT+1);
  if Assigned(Node) then
    RESULT := Self.NodesList.AddObject(Node.nodeName, @Node)
   else
    RESULT := Self.NodesList.Add(Self.NodesList[RESULT]);
end;

class function TAttributesProducer.CloneAttributes(SourceNode, DestinationNode: IXMLDOMNode): TAttributesArray;
var k, L: integer;
  Attribute0, Attribute: IXMLDOMNode;

begin
  SetLength(RESULT, 0);
  if (SourceNode = nil) or (DestinationNode = nil) then exit;

  L:=SourceNode.attributes.length;
  if L = 0 then exit;

  
  SetLength(RESULT, L);
  for k := 0 to L - 1 do    
   begin
    Attribute0 := SourceNode.attributes.item[k];
    Attribute := DestinationNode.ownerDocument.createAttribute(Attribute0.nodeName);
    Attribute.nodeValue := Attribute0.nodeValue;
    DestinationNode.attributes.setNamedItem(Attribute);
    ;
    with RESULT[k] do
     begin
      attrName := Attribute.nodeName;
      attrvalue := Attribute.nodeValue;
      isnotnull := True;
     end; 
   end;
  
end;

constructor TAttributesProducer.Create(XML: IXMLDOMDocument; specification: string);
begin
  inherited Create;

  if Assigned(XML) then  
    Self.FXMLDoc := XML;
  
  Self.NodesList := TStringList.Create;
  if specification <> '' then
    Self.NodesList.Text := StringReplace(specification,';',#$D#$A,[rfReplaceAll]);
  SetLength(Self.AttributesMap, Self.NodesList.Count);
  Self.FTreeKeyIndex := Self.NodesList.Count;
end;

destructor TAttributesProducer.Destroy;
begin
    SetLength(Self.AttributesMap, 0);
  Self.NodesList.Free;
  inherited;
end;

function TAttributesProducer.GenerateAttributeByName(nodename, attrname: string): IXMLDOMNode;
var
  index: integer;
  k, l: integer;
begin
  RESULT := nil;
  index := Self.NodesList.IndexOf(nodename);
  if index<0 then exit; // specified node do not have such attribute

  if index < Length(Self.AttributesMap)  then
   begin
    l := Length(Self.AttributesMap[index]);
    for k := 0 to l - 1 do
      if Self.AttributesMap[index][k].attrName = attrname then
       begin
        RESULT := Self.FXMLDoc.createElement(Self.AttributesMap[index][k].attrName);
        if  Self.AttributesMap[index][k].isnotnull then           
          RESULT.nodeValue := Self.AttributesMap[index][k].attrvalue;   
        break;
       end;
   end;

end;

function TAttributesProducer.GetAttributeByName(nodename, attrname: string): string;
var
  nodeindex: integer;
  k, l: integer;
begin
  RESULT := '';
  nodeindex := Self.NodesList.IndexOf(nodename);
  if nodeindex<0 then exit; // specified node do not have such attribute

  if nodeindex < Length(Self.AttributesMap)  then
   begin
    l := Length(Self.AttributesMap[nodeindex]);
    for k := 0 to l - 1 do
      if Self.AttributesMap[nodeindex][k].attrName = attrname then
       begin
        if  Self.AttributesMap[nodeindex][k].isnotnull then
          RESULT := Self.AttributesMap[nodeindex][k].attrvalue;
        break;
       end;
   end;
end;

function TAttributesProducer.GetNodeAttrByIndex(index: integer): TAttributesArray;
begin
  SetLength(RESULT, 0);
  if (index < 0) or (index > length(Self.AttributesMap)-1) then exit;

  RESULT := Self.AttributesMap[index];
end;

function TAttributesProducer.GetTreeKey: string;
begin
  RESULT := '';
  if (0>Self.FTreeKeyIndex) and (Self.FTreeKeyIndex<Self.NodesList.Count) then
    RESULT := Self.NodesList[Self.FTreeKeyIndex];
end;

class function TAttributesProducer.ProduceAttributes(AttrNames, AttrValues: string; const delimiter,
  null: char): TAttributesArray;
var p, q, {m, n,} l: integer;
  attr : TAttributeDscr;
begin
  l := 0;
  SetLength(RESULT,0);

  AttrNames := trim(AttrNames);
  if AttrNames = '' then exit;

 // AttrValues := StringReplace(AttrValues, delimiter+delimiter, delimiter + null + delimiter, [rfReplaceAll]);

  repeat
    // парсинг строки имён аттрибутов
    p := pos(delimiter,AttrNames);
    if (p>0) then
     begin
      attr.attrName := copy(AttrNames,1,p-1);
      AttrNames := copy(AttrNames,p+1);
     end
     else
      attr.attrName := AttrNames;
    if attr.attrName <> '' then
     begin
       inc(l);
       SetLength(RESULT, l);
     end;

    //парсинг строки значений аттрибутов 
    q := pos(delimiter,AttrValues);
    if (q>0) then
     begin
      attr.attrvalue := copy(AttrValues,1,q-1);
      AttrValues := copy(AttrValues,q+1);
     end
     else
      attr.attrvalue := AttrValues;

    attr.isnotnull := attr.attrvalue <> null;

    if attr.attrName <> '' then
      RESULT[l-1] := attr;

  until p*q = 0;
end;

procedure TAttributesProducer.ProduceNodeAttributes(Node: IXMLDOMNode);
var 
  index: integer;
  k, l: integer;
  Attribute: IXMLDOMNode;
begin
  if Node = nil then exit;

  index := Self.NodesList.IndexOfObject(@Node);
  if index<0 then
    index := Self.NodesList.IndexOf(Node.nodeName);
  if index<0 then exit;

  l := Length(Self.AttributesMap[index]);
  for k:= 0 to l-1 do
   begin          //Self.AttributesMap[index][k].attrName
    Attribute := Self.FXMLDoc.createAttribute(Self.AttributesMap[index][k].attrName);
    Attribute.nodeValue := Self.AttributesMap[index][k].attrvalue;
    Node.attributes.setNamedItem(Attribute);
   end;
end;

procedure TAttributesProducer.ProduceTreeAttributes(createKeyChild: boolean = false);
var i, j, l: integer;
  p: Pointer;
  Node: IXMLDOMNode;
  Attribute: IXMLDOMNode;
begin
  for i := 0 to NodesList.Count - 1 do
   begin
    if Assigned(NodesList.Objects[i]) then
     begin
      p := NodesList.Objects[i];
      Node := IXMLDOMNode(p^);
      if createKeyChild then
        { TODO : 
        note, that subnode name may by not "<keynode>node",
        this case must be checked and correctly processed here }
        Node := Node.appendChild(Self.FXMLDoc.createElement(Node.nodeName + 'node'));
     end
     else
      if Assigned(Self.FXMLDoc.getElementsByTagName(NodesList[i])) then
        Node := Self.FXMLDoc.getElementsByTagName(NodesList[i]).item[0]
       else
        continue; //try go to next line


    l := length(Self.AttributesMap[i]);
    for j := 0 to l - 1 do
     begin
      ;
      Attribute := Self.FXMLDoc.createAttribute(Self.AttributesMap[i][j].attrName);
      Attribute.nodeValue := Self.AttributesMap[i][j].attrvalue;
      Node.attributes.setNamedItem(Attribute);
     end;
    Self.ProduceNodeAttributes(Node);
   end;
end;

procedure TAttributesProducer.SetNodeAttrByIndex(index: integer; AttrArr: TAttributesArray);
begin
  if (index < 0) or (index > length(Self.AttributesMap)-1) then exit;

  SetLength(Self.AttributesMap[index], Length(AttrArr)); //?
  Self.AttributesMap[index] := AttrArr;
end;

procedure TAttributesProducer.SetNodeAttributesString(node, attrSequence: string);
var
  index: integer;
  AttrList: TStringList;
  k, l: integer;
begin
  index := Self.NodesList.IndexOf(node);
  if index<0 then exit;
  if index>=Length(Self.AttributesMap)  then exit;

  AttrList := TStringList.Create;
  try
    AttrList.Delimiter := ';';
    AttrList.DelimitedText := attrSequence;
    l := AttrList.Count;

    SetLength(Self.AttributesMap[index], l);
    for k := 0 to l - 1 do
     begin
      Self.AttributesMap[index][k].attrName := AttrList.Names[k];
      Self.AttributesMap[index][k].attrvalue := AttrList.Values[AttrList.Names[k]];
      Self.AttributesMap[index][k].isnotnull := AttrList.Values[AttrList.Names[k]] > '';
     end;
  finally
    AttrList.Free;
  end;
end;

procedure TAttributesProducer.SetTreeKey(TreeKeyName: string);
var index: integer;
begin
  index := Self.NodesList.IndexOf(TreeKeyName);
  if Self.NodesList.Objects[index] = nil then
    Self.FTreeKeyIndex := index;
end;

{ TPercoDataScaner }

constructor TPercoDataScaner.Create(index: integer);
begin
  inherited Create(true);
  FreeOnTerminate := False;
  if index>0 then
    Self.ID := index;

  if Assigned(PercoCOM) then
    Self.SDK := PercoCOM
   else exit;

  if Assigned(SMTP) then
    Self.FSMTP := SMTP;

  if Assigned(PercoImport) then
    Self.FBDBKit := PercoImport;
end;

destructor TPercoDataScaner.Destroy;
begin
  Self.SDK := nil;
  Self.FSMTP:=nil;

  Self.FBDBKit := nil;
  inherited;
end;

procedure TPercoDataScaner.Execute;
begin
  repeat
    Self.Scan;
    Suspend;
  until Self.Terminated;
end;

function TPercoDataScaner.getLastErrorMsg: string;
begin
  Self.FLastError := '';
  if Assigned(Self.SDK) then
  Self.FLastError := Self.SDK.Text;
  RESULT := Self.FLastError;
end;

function TPercoDataScaner.GetScanDir: string;
begin
  RESULT := Self.FScanDirectory;
end;

function TPercoDataScaner.GetScanInterval: integer;
begin
  RESULT := 1000 * Self.FScanInterval;
end;

function TPercoDataScaner.GetScenarioChecking: boolean;
begin
  RESULT := Length(Trim(Self.FScenario))>0;
end;

//function TPercoDataScaner.GetSubDir: string;
//begin
//  RESULT := Self.FWorkdir;
//end;

procedure TPercoDataScaner.Init(Fileini: string);
var
  iniFile: TINIFile;
  Tag: string;
begin
  iniFile := TINIFile.Create(fileini);
  Tag:='Scaner';
  if Self.ID>0 then
   begin
     if Self.ID<10 then Tag := Tag + '0';
     Tag:=Tag + IntToStr(self.ID);
   end;
  Self.FLogFile := Concat(ExtractFilePath(Paramstr(0)),Tag,'Daemon.log');

  try
    Self.FScanDirectory := iniFile.ReadString(Tag,'Catalog',ExtractFileDir(Paramstr(0)));
    Self.FScanInterval := iniFile.ReadInteger(Tag,'Interval',0);
    Self.FScanMask := iniFile.ReadString(Tag,'FileMask','*[*]*.csv');
    Self.FWorkdir := iniFile.ReadString(Tag,'WorkDir',ExtractFileDir(Paramstr(0)));

    Self.FScenario := iniFile.ReadString(Tag,'Scenario',ExtractFilePath(Self.FScanDirectory)+Tag+'Scenario.csv');

    Self.FeMail := iniFile.ReadString(Tag,'email', 'Perco@shate-m.com');
    Self.FeMailSubjTempl := iniFile.ReadString(Tag,'emailSubj', 'Perco');
    Self.FeMailMsgTempl := iniFile.ReadString(Tag, 'emailMsg', 'Hi!');
    Self.FeMailRet := iniFile.ReadString('SMTP','sender', 'anonimous@hacker.net');

    if Assigned(Self.FSMTP) then
     begin
      Self.FSMTP.Host := iniFile.ReadString('SMTP','host','localhost');
      Self.FSMTP.Port := iniFile.ReadInteger('SMTP','Port',25);
      Self.FSMTP.Username := '';
      Self.FSMTP.Password := '';
     end;

    Self.Debug := iniFile.ReadBool(Tag,'DebugMode', True);

    Self.PrintLogMsg('Инициализация успешно завершена');
  finally
    iniFile.Free;
  end;
end;

procedure TPercoDataScaner.Print(Msg: string);
begin
  { TODO : Here must be thread-safe print to log file (Synchronized print) }

try
    if Self.ID = 0 then
      Self.PrintLogMsg(Msg);  
except on E: Exception do
end;

end;

procedure TPercoDataScaner.PrintLogMsg(Msg: string);
begin
  PrintTimestamp(Msg, Self.FLogFile);
end;

procedure TPercoDataScaner.Scan;
const
  CR = #$D;
  CRLF = #$D#$A;
var ScanList: TStringList;
    k, l: integer;
    origfilename, newfilename: string;
    underlines: shortint;
begin
  if not Self.SDK.CheckAvailableConn then
   begin
    Self.PrintLogMsg(Concat('#','Соединение с сервером не доступно: "',Self.SDK.Text,'"'));
    exit;
   end;

  Self.FLastError := 'Сканирование';
  ScanList := TStringList.Create;
  try
    ScanList.Delimiter := CR;
    ScanList.Text := StringReplace(GetFilesSeqByMask(Self.ScanDirectory, Self.ScanMask),CRLF,CR,[rfReplaceAll]);
    Self.PrintLogMsg('Список обнаруженных файлов: [{ "' +StringReplace(trim(ScanList.Text),CRLF,'", ',[rfReplaceAll]) +'" }]');
    l := ScanList.Count;

    for k := 0 to l - 1 do
     begin

      origfilename := Concat(Self.FScanDirectory,'\',ScanList[k]);
      Self.PrintLogMsg('Обработка файла '+ origfilename);


      underlines := TryMoveFile(origfilename, $10); //0;
//      repeat
//        inc(underlines);
//        newfilename :=  Concat(self.FWorkdir, '\',StringOfChar('_',underlines)+ScanList[k]);
//
//        if RenameFile(origfilename, newfilename) then
//         begin
//          origfilename := newfilename;
//          Self.PrintLogMsg('Файл переименован "'+newfilename+'"');
//          break;
//         end
//         else  //target directory is not available for saving
//          if not FileExists(newfilename) then
//           begin
//            origfilename := Concat(Self.FScanDirectory,'\',ScanList[k]);
//            underlines := 0;
//           end;
//      until underlines mod $10 = 0; //max number of attempts

      if Self.SDK.ProcessingDataFile(origfilename) then
       begin
        Self.PrintLogMsg('Файл "'+origfilename+'" успешно обработан');
        newfilename := transformFileName(origfilename);                   // ExtractFilePath(newfilename)+ ExtractFilePath(newfilename)+
        newfilename := StringReplace(newfilename, StringOfChar('_',underlines)+ScanList[k], ScanList[k],[]);
        if RenameFile(origfilename, newfilename) then
          Self.PrintLogMsg('Файл сохранён как "'+ExtractFileName(newfilename)+'"')
         else
          Self.PrintLogMsg('Не удалось переименовать обработанный файл');

        if Self.SendEmail(True) then
          Self.PrintLogMsg('Уведомление отправлено')
         else
          Self.PrintLogMsg('Не удалось отправить уведомление');
       end
       else
       begin
        Self.SendEmail(False);
        Self.PrintLogMsg('Обработка не выполнена:'+Concat('"'+Self.SDK.Text+'"'));
        if Self.SDK.FaultConn then
          if RenameFile(origfilename, Concat(Self.FScanDirectory,'\',ExtractFileName(origfilename))) then
            Self.PrintLogMsg('Файл перемещён обратно для повторной обработки');
       end;
     end;
  finally
    ScanList.Free;
  end;
end;

function TPercoDataScaner.ScenAct: boolean;
const
  //FLDTIMESTAMP = 0;
  FLDPROC = 1;
  FLDFILE = 0;
  FLDSAFE = 2;
var
  Pool: TDataPool;
  CSV: IUniversalCSVReader; {TCSVXReader;}
  scenfilename: string;
  Proc: TIBStoredProc;
  Transaction: TIBTransaction;
begin
  RESULT := False;

  if Self.FBDBKit = nil then exit;

  if not FileExists(Self.FScenario) then exit;

  scenfilename := Concat(Self.WorkDir,'\',ExtractFileName(Self.FScenario));
  if FileExists(scenfilename) then DeleteFile(scenfilename);
  
  if not RenameFile(Self.FScenario, scenfilename) then
   begin
     Self.Print('Не удалось переместить файл сценария ' + ExtractFileName(Self.FScenario));
     exit;
   end;



  CSV := {TCSVXReader} TInterfacedCSVFileReader.Create;
  try
    if CSV.Open(scenfilename) then
     try
      repeat
        CSV.ReturnLine;
        Pool.datacsv := trim(CSV.Fields[FLDFILE]);
        Pool.kit := trim(CSV.Fields[FLDPROC]);
        Pool.safe := CSV.Fields[FLDSAFE]>'0';
        //Pool.datainterface := CSVINTERFACEFILE;
        if FileExists(Pool.datacsv) then
         begin
          Transaction := TIBTransaction.Create(nil);
          try
            Proc := TIBStoredProc.Create(nil);
            try
              Proc.Transaction := Transaction;
              Self.FBDBKit.IBInit(Proc);
              //if FileDateToDateTime(FileAge(Pool.datacsv)) > StrToDateTime(CSV.Fields[FLDTIMESTAMP]) then
              try
                Self.Print(Format('Выполнение сценария %s параметризированного по вектору из "%s" ...',[Pool.kit,Pool.datacsv]));
                RESULT := Self.FBDBKit.ProcessingDataPool(Pool);
                if RESULT then Self.Print('...OK');

              except on E: Exception do
                Self.Print(Format('Ошибка выполнения элемента %s сценария: "%s"', [Pool.kit,E.Message]));
              end;
            finally
              Self.FBDBKit.IBInit(nil);
              FreeAndNil(Proc);
            end;
          finally
            Transaction.Free;
          end;
         end
         else
          Self.Print('Не удалось найти файл ' + Pool.datacsv);
      until CSV.Eof;
     finally
      CSV.Close;
     end
     else
      Self.Print('Не удалось открыть сценарий '+scenfilename);
  finally
    {CSV.Free;}
  end;

end;

function TPercoDataScaner.SendEmail(success: boolean): boolean;
const
  TMPLDATATYPE = '##DATATYPE##';
  TMPLACTIONMODE = '##ACTIONMODE##';
  TMPLIDENTIFIER = '##IDENTIFIER##';
  TMPLACTIONTRANSLATE = '##ACTIONTRANSLATE##';
  TMPLDATATRANSLATE = '##DATATRANSLATE##';
var subjtmpl, subjrepl, bodytmpl, bodyrepl: string;
    //datatypetransl , actionmodetransl, identifierstr: string;
//    statusmessage: string;
begin
  Result := False;
  Self.FeMsg := TMyIdMessage.Create(nil);
  try
    subjtmpl := Concat(TMPLDATATYPE,';', TMPLACTIONMODE,';', TMPLIDENTIFIER);
    bodytmpl := Concat(TMPLDATATRANSLATE,';', TMPLACTIONTRANSLATE,';', TMPLIDENTIFIER);
    if Self.SDK.ActionDescription(subjrepl, bodyrepl) then
     begin
      with Self.FeMsg do
       begin
        CharSet:='windows-1251';
        ContentType := 'multipart/mixed; charset=windows-1251';
        Recipients.EmailAddresses := Self.FeMail;
        BccList.EMailAddresses := '';

        Body.Clear;
        MessageParts.Clear;

        From.Text := Self.FeMailRet;
        FSubject := MultyReplace(Self.FeMailSubjTempl, subjtmpl, subjrepl);
        FBody.Add(MultyReplace(Self.FeMailMsgTempl, bodytmpl, bodyrepl));


        if success then
         begin
           { TODO : If linked processing takes place,
here must be added report additional operations
 (such as staff rights changes etc.) }
          if Self.SDK.ExtraProc.ResultMessage > '' then          
            FSubject := Concat('$ ',FSubject);
          FBody.Add(Self.SDK.ExtraProc.ResultMessage);
         end
         else
         begin
           FSubject := Concat('# ',FSubject);
           FBody.Add(Self.SDK.FText);
         end;


       end;
     end
     else
      exit;
    //
    try
      RESULT:=Self.FeMsg.PostBySMTP(Self.FSMTP);
    except
    end;
  finally
    Self.FeMsg.Free;
  end;
end;

procedure TPercoDataScaner.SetMode(debug: boolean);
begin
  Self.FDebug := debug;
  if Assigned(Self.SDK) then
    Self.SDK.DebugMode := debug;
end;

procedure TPercoDataScaner.SetScanDir(Dir: string);
begin
  if DirectoryExists(Dir) then
    Self.FScanDirectory := Dir;
end;

procedure TPercoDataScaner.SetScanInterval(interval: integer);
begin
  if interval>0 then
    Self.FScanInterval := interval div 1000
   else
    Self.ScanInterval := 0;    //reinitialization  needed
end;

//procedure TPercoDataScaner.SetSubDir(SubDir: string);
//begin
//  if pos('/', SubDir)+pos(':', SubDir)+pos('?', SubDir)+pos('*', SubDir)+pos('\', SubDir) > 0 then
//    exit;
//
//  SubDir := IncludeTrailingPathDelimiter(Self.FScanDirectory)
//end;

function TPercoDataScaner.TryMoveFile(var filename: string; trylimit: integer): integer;
var underlines: shortint;
  movefilename: string;
begin
    underlines := 0;
    repeat
      inc(underlines);
      movefilename :=  Concat(self.FWorkdir, '\',StringOfChar('_',underlines)+ExtractFileName(filename));

      if RenameFile(filename, movefilename) then
       begin
        filename := movefilename;
        Self.PrintLogMsg('Файл переименован "'+movefilename+'"');
        break;
       end
       else  //target directory is not available for saving
        if not FileExists(movefilename) then
         begin
          //filename := Concat(Self.FScanDirectory,'\',filename);
          underlines := 0;
         end;
    until underlines mod trylimit = 0; //max number of attempts
    RESULT := underlines;
end;

{ TMyIdMessage }

constructor TMyIdMessage.Create(AOwner: TComponent);
begin
  inherited;
  OnInitializeISO := OnISO;
end;

procedure TMyIdMessage.OnISO(var VTransferHeader: TTransfer; var VHeaderEncoding: Char; var VCharSet: string);
begin
  VCharSet:='windows-1251';
  VTransferHeader := bit8;
  VHeaderEncoding := '8';
end;

function TMyIdMessage.PostBySMTP(SMTP: TIdSMTP): boolean;
begin
//  RESULT := False;
  try
    with SMTP do
    begin
      try
        if (Connected) then Disconnect;
        Connect;
        try
          Send(Self);
           RESULT := True;
        except
          on e: Exception do
          begin
            //fOwnerService.AddLog('SMTP - ' + e.Message);
            logmsg:='SENDING FAULT: "'+e.Message+'"';
            RESULT := False;
          end;
        end;
      except
        on e: Exception do
        begin
          //fOwnerService.AddLog('SMTP - ' + e.Message);
          logmsg:='CONNECTING FAULT: "'+e.Message+'"';
          RESULT := False;
        end;
      end;
      Disconnect;
    end;
  except
    on e: Exception do
    begin
      RESULT := FALSE;
      //fOwnerService.AddLog('SMTP - ' + e.Message);
      logmsg:=e.Message;
    end;
  end;
end;
{ TDataPool }

function TDataPool.dataExists: boolean;
begin
  if ExtractFilePath(datacsv)='' then
    RESULT := True    { TODO : check StringStreamExists here }
   else
    RESULT := FileExists(datacsv);
end;

function TDataPool.datainterface: TCSVInterfaceType;
begin
  if ExtractFilePath(datacsv) = '' then
    RESULT := CSVINTERFACEMEMORY
   else
    RESULT := CSVINTERFACEFILE; 
end;

initialization
  SMTP := TIdSMTP.Create(nil);
finalization
  SMTP.Free;
end.

