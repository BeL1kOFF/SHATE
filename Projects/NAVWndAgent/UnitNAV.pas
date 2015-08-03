unit UnitNAV;

interface
uses ActiveX, SysUtils, UnitExtern, Classes, Dialogs, ComCtrls, Types,
      UnitParser;
const
        NAVCodeunit = 5;
        NAVDataport = 4;
        NAVForm = 2;
        NAVReport = 3;
        NAVTable = 1;

        NAVExePath = 'c:\Program Files\Microsoft Dynamics NAV\60\Classic\';
        NAVExeName = 'finsql.exe';

  type IObjectDesigner = {disp}interface
    ['{50000004-0000-1000-0001-0000836BD2D2}']

    function ReadObject(objectType, objectId: SYSINT; destination: IStream): SYSINT; stdcall;   //dispID 1;
    function ReadObjects(filter: WideString; destination: IStream): SYSINT; stdcall;              //   dispID 2;
    function WriteObjects(source: IStream): SYSINT; stdcall;                                     //dispID 3;
    function CompileObject(objectType, objectId: SYSINT): SYSINT; stdcall;                      //dispID 4;
    function CompileObjects(filter: WideString): SYSINT; stdcall;                                 //   dispID 5;
    function GetServerName(out serverName: WideString): SYSINT; stdcall;                           //  dispID 6;
    function GetDatabaseName(out databaseName: WideString): SYSINT; stdcall;                        // dispID 7;
    function GetServerType(out serverType: SYSINT): SYSINT; stdcall;                          //  dispID 8;
    //function GetDatabaseType(out databaseType: integer): Integer;
    function GetCSIDEVersion(out csideVersion: WideString): SYSINT; stdcall;                    //     dispID 9;
    function GetApplicationVersion(out applicationVersion: WideString): SYSINT; stdcall;         //    dispID 10;
    function GetCompanyName(out companyName: WideString): SYSINT; stdcall;                        //   dispID 11;

    {
            [PreserveSig, DispId(1)]
        int ReadObject([In] int objectType, [In] int objectId, [In] IStream destination);
        [PreserveSig, DispId(2)]
        int ReadObjects([In] string filter, [In] IStream destination);
        [PreserveSig, DispId(3)]
        int WriteObjects([In] IStream source);
        [PreserveSig, DispId(4)]
        int CompileObject([In] int objectType, [In] int objectId);
        [PreserveSig, DispId(5)]
        int CompileObjects([In] string filter);
        [PreserveSig, DispId(6)]
        int GetServerName(out string serverName);
        [PreserveSig, DispId(7)]
        int GetDatabaseName(out string databaseName);
        [PreserveSig, DispId(8)]
        int GetServerType(out int serverType);
        [PreserveSig, DispId(9)]
        int GetCSIDEVersion(out string csideVersion);
        [PreserveSig, DispId(10)]
        int GetApplicationVersion(out string applicationVersion);
        [PreserveSig, DispId(11)]
        int GetCompanyName(out string companyName);
   }
  end;

  INSRec = interface;

  INSCallbackEnum = interface
	['{50000004-0000-1000-0011-0000836BD2D2}']
	function NextRecord(Rec:INSRec):SYSINT; stdcall;
	function NextFieldValue(fieldNo: SYSINT; fieldVal: WideString; datatype: WideString):SYSINT; stdcall;
	function NextFilterValue(fieldNo: SYSINT; filterVal: WideString):SYSINT; stdcall;
	function NextTable(tableNo: SYSINT; tableName: WideString):SYSINT; stdcall;
	function NextFieldDef(fieldNo: SYSINT; fieldName: WideString; fieldCaption: WideString; dataType: WideString; dataLength: SYSINT; f: SYSINT):SYSINT; stdcall;
  End;

  INSRec = interface 
	['{50000004-0000-1000-0007-0000836BD2D2}']
	function SetFieldValue(fieldNo: SYSINT; value: WideString; validate: SYSINT{BOOL}):SYSINT; stdcall;
	function GetFieldValue(fieldNo: SYSINT; out value: WideString):SYSINT; stdcall;
	function EnumFieldValues(cbef:INSCallbackEnum):SYSINT; stdcall;
  End;

  INSTable = interface
  ['{50000004-0000-1000-0006-0000836BD2D2}']
  	function Delete(Rec: INSRec):SYSINT; stdcall;
	function Insert(Rec: INSRec):SYSINT; stdcall;
	function Modify(Rec: INSRec):SYSINT; stdcall;
	function Init(out Rec: INSRec):SYSINT; stdcall;
	function SetFilter(fieldNo: SYSINT; filterVal:WideString):SYSINT; stdcall;
	function EnumFilters(callback:INSCallbackEnum):SYSINT; stdcall;
	function EnumRecords(callback:INSCallbackEnum):SYSINT; stdcall;
	function EnumFields(callback:INSCallbackEnum; langID: SYSINT):SYSINT; stdcall;
	function Find(callback:INSCallbackEnum):SYSINT; stdcall;
	function GetID(out ID: SYSINT):SYSINT; stdcall;
  End;

  INSForm = Interface
   ['{50000004-0000-1000-0003-0000836BD2D2}']
   function GetHyperlink(out a: WideString):SYSINT; stdcall;
   function GetID(out a: WideString):SYSINT; stdcall;
   //function GetRec(out a: INSRec):SYSINT; stdcall;
   function GetTable(out a: INSTable):SYSINT; stdcall;
   function GetLanguageID(out a:SYSINT):SYSINT; stdcall;
   function proc8(out a: SYSINT): SYSINT; stdcall;
   function proc9():SYSINT; stdcall;
  End;





  INSHyperlink = interface
   ['{50000004-0000-1000-0000-0000836BD2D2}']
   function Open(link: WideString):SYSINT; stdcall;
   function GetWindowHandle(out handle:SYSINT):SYSINT; stdcall;
  End;


//INSAppBase = {disp}interface
//    ['{50000004-0000-1000-0010-0000836BD2D2}']
//      function GetTable(a: SYSINT): SYSINT; stdcall;   //dispID 1;
//      function GetInfos(out servername: WideString; out databasename: WideString; out company: WideString; out username: WideString): SYSINT; stdcall;   //dispID 2;
//      {
//      int GetTable([In] int a, [Out, MarshalAs(UnmanagedType.Interface)] out INSTable table);
//      int GetInfos(out string servername, out string databasename, out string company, out string username);
//      int StartTrans(); //start the write transaction in the client
//      int proc6([In] bool a);
//      int Error([In] string message);  //Display error in client, roll back the transaction
//      int EnumTables([In, MarshalAs(UnmanagedType.Interface)] INSCallbackEnum a, [In] int flag); //meaning of flag is not known for me yet
//      }
//  end;
  INSAppBase = interface
   ['{50000004-0000-1000-0010-0000836BD2D2}'] 
    function GetTable(a: SYSINT; out Table: INSTable):SYSINT; stdcall;
	function GetInfos(out serverName: WideString; out databasename: WideString; out company: WideString; out userName: WideString):SYSINT; stdcall;
	function BeginTrans():SYSINT; stdcall;
	function proc6(a:SYSINT):SYSINT; stdcall;//EndTrans? arg: bool
	function Error(ErrMsg:WideString):SYSINT; stdcall;
	function EnumTables(cbe:INSCallBackEnum; flag:SYSINT):SYSINT; stdcall;	
  End;

 INSHook = interface
  ['{50000004-0000-1000-0005-0000836BD2D2}']
	function proc3(AppBase: INSAppBase):SYSINT;stdcall;
 End;

  INSApplication = Interface
   ['{50000004-0000-1000-0002-0000836BD2D2}']
   function GetForm(out form:INSForm):SYSINT; stdcall;
  End;
  INSApplicationEvents = interface
    ['{50000004-0000-1000-0004-0000836BD2D2}']
    function onFormOpen( Form: INSForm):SYSINT;stdcall;
    function proc4(Form: INSForm; b: string):SYSINT;stdcall;
    function OnActiveChanged(active: SYSINT):SYSINT;stdcall;
    function OnCompanyClose():SYSINT;stdcall;
  End;
  INSMenuButton = interface
   ['{50000004-0000-1000-0008-0000836BD2D2}']
   function proc3(a: WideString):SYSINT; stdcall;
   function proc4(a: SYSINT; b: WideString; c: WideString):SYSINT; stdcall;
  End;

   INSMenuButtonEvents = interface
    ['{50000004-0000-1000-0009-0000836BD2D2}']
    function proc3():SYSINT;stdcall;
    function proc4(a: SYSINT):SYSINT;stdcall;
   End;





  TOBJECTDESCRIPTOR = Record
    Tag,
    ObjectType,
    No,
    CaptionRU: String;
  End;

  TOBJPROPDESCRIPTOR = Record
    Tag,
    Date,
    Time,
    VersionList: string;
  End;
  TOBJPRPDSCRPTR=^TOBJPROPDESCRIPTOR;

  TFIELDDESCRIPTOR = Record
    No: string[31];
    Space: string[3];
    Description: string;
    FieldTypelength: string;
    //Parameters: array[0..1,1..10] of string;
  End;
  TFLDDSCRPTR=^TFIELDDESCRIPTOR;

  TPROPERTYDESCRIPTOR = Record
    Count: integer;
    Tag: string;
    Values: TList;
  End;
  TPRPRTDSCRPTR=^TPROPERTYDESCRIPTOR;

  TKEYSDESCRIPTOR = Record
    keys: TList;
  End;
  TKYDSCRPTR = ^TKEYSDESCRIPTOR;

  TFLDSGRPSDESCRIPTOR = Record
    groups: TList;
  End;
  TFLDGRPSDSCPTR = ^TFLDSGRPSDESCRIPTOR;


  TCODEDESCRIPTOR = Record
    code: TStringList;
  End;
  TCODEDSCRPTR = ^TCODEDESCRIPTOR;

//-----класс секции и его потомки реализующие особенности считывани€----------//
  TNavSection = Class(TObject)
    public

      class function NAVCreateSectionObject(DataParser: TNAVParser; tag: string; typecode: integer): TNavSection;
      //function ReadTag: string; //abstract;
      //function ReadContent: string; //abstract;
      function isTag(keyword: string): boolean;
      procedure setContent(str: string);
      function getContent: string;
      procedure saveTagToFile(dirname, filename: string);

      procedure getSectionTagsList;

      procedure showTag;
      procedure showText;
      procedure showSection;

      Function Parse: TTreeNodes; virtual;

      constructor Create(DataParser: TNavParser; keyword: string); overload;
      constructor Create(Node: TTreeNode);  overload;virtual; //   (tag: string; content: string)
    private
      Owner: TNavParser;
      tagList: TStringList;
      tagkeyword: string;
      txt: string;
      ident: integer;
      level: integer;

      node: TTreeNode;
  End;

  TNAVSectionClass = class of TNavSection;

  TNavHead = Class(TNavSection)
    public
      function ReadTag: string;
      //function ReadContent: string;
      constructor Create(DataParser: TNavParser; keyword: string);
    private
      descr: TOBJECTDESCRIPTOR;
  End;

  TNavObjProp = Class(TNavSection)
    public
//      function ReadTag: string;
//      function ReadContent: string;
      Function Parse: TTreeNodes; override;
    private
      descr: TOBJPROPDESCRIPTOR;
  End;

  TNavProperties = Class(TNavSection)
    public
//      function ReadTag: string;
//      function ReadContent: string;
      Function Parse: TTreeNodes; override;
    private
      descr: TPROPERTYDESCRIPTOR;
  End;

  TNavFields = Class(TNavSection)
    public
//      function ReadTag: string;
//      function ReadContent: string;
      Function Parse: TTreeNodes; override;
    private
      descr: TFIELDDESCRIPTOR;
  End;

  TNavKEYS = Class(TNavSection)
    public
//      function ReadTag: string;
//      function ReadContent: string;
      Function Parse: TTreeNodes; override;
    private
      descr: TKEYSDESCRIPTOR;
  End;

  TNavFldGrps = Class(TNavSection)
    public
//      function ReadTag: string;
//      function ReadContent: string;
    private
      descr: TFLDSGRPSDESCRIPTOR;
  End;

  TNavCode = Class(TNavSection)
    public
//      function ReadTag: string;
//      function ReadContent: string;
    private
      descr: TCODEDESCRIPTOR;
  End;

  TNavValues = Class(TNavSection)
    public
//      function ReadTag: string;
//      function ReadContent: string;
      Function Parse: TTreeNodes; override;
      constructor Create(Node: TTreeNode); override;  // virtual;
    private
      list: TStringList;
      OpenBr, CloseBr: string;
      delimiter: char;
  End;

  TNAVSubFields = Class(TNavValues)
      Function Parse: TTreeNodes; override;
      constructor Create(Node: TTreeNode); override;
  End;

  function readhead(const ff:text; tag: string):TOBJECTDESCRIPTOR;
  function readfield(const ff:text; OpenBr, Delim, CloseBr: char; var line0: string):TFieldDESCRIPTOR;
  function SearchCaptionRU(const ff: textfile): string;
  function SearchParameterValue(const ff: text; const tag: string):string;
  function readUpToTag(const ff: text; tag: String):boolean;

  procedure parseFile(const filename: string; var headstring: string);
  procedure parseSection(ParentSection: TNavSection; SECTION: TNavSectionClass);
  var FormTreeView: TTreeView;
implementation

function lastSy(str: string):char;
begin
  lastSy:=str[length(str)]
end;

//возвращает описатель объекта с заполненными пол€ми в кодировке windows
function readhead(const ff:text; tag: string):TOBJECTDESCRIPTOR;
const MM=3;
var head: string;
    k, l, m, p: integer;
    params: array [0..MM] of string;
begin
  readln(ff,head);
  head:=head+' ';
  l:=length(head);
  m:=0;
  k:=1;
  repeat
    p:=k-1+pos(' ',copy(head,k));
    if p<k then break;
    params[m]:=trim(copy(head,k,p-k));
    k:=p+1; inc(m);
    if (m=MM) and (k<l) then
     begin
       params[MM]:=params[m]+copy(head,p,l-p);    //??
       break;
     end;
  until k>l;
  if params[0]=tag then
   begin
    RESULT.ObjectType :=  params[1];
    RESULT.No         :=  params[2];
    RESULT.CaptionRU  :=  DosToAnsi(params[3]);
   end
   else RESULT.Tag:='';
end;


//функци€ чтени€ описател€ пол€
function readfield(const ff:text; OpenBr, Delim, CloseBr: char; var line0: string):TFieldDESCRIPTOR;
const MM=4;       //предельное число считываемых параметров
var line: string;
    k, l, m, p: integer;
    params: array [0..MM] of variant;   //массив параметров
    originPos: Integer;                 //позици€ описател€
    dsc: TFieldDESCRIPTOR;
begin
  dsc.No:=''; RESULT.No:='';
  if eof(ff) then exit;


  OriginPos:=FilePos(ff);               //запоминаем начало описател€
  readln(ff,line);                      //считываем строку
  line0:=line;
  if pos(OpenBr,trim(line))<>1 then exit;  //фигн€ если начинаетс€ не с "{"


  line:=StringReplace(line,OpenBr+' ',OpenBr+Delim,[]);
  line:=line+Delim;                     //дабы облегчить жизнь
  l:=length(line);
  m:=0;                                 //инициализаци€ счетчика параметров
  k:=1;                                 //инициализаци€ курсора
  repeat           //цикл посимвольного прохода по строке
    p:=k-1+pos(Delim,copy(line,k));   //конец первого токена
    if p<k then break;                //если токен не найден - всЄ
    params[m]:=trim(copy(line,k,p-k));      //читаем параметр
    k:=p+1;                   //движем курсор
    if (m=MM) and (k<l) then    break;
//     begin                            //все параметры считаны но путь не пройден
//
//
//     end;
    inc(m);                            // увеличение счетчика
  until k>l;
try
  if params[0]=OpenBr then           //если корректно открытый тег описател€...
   begin                             //... заполн€ем поля описател€ пќл€
//    RESULT.No    :=  params[1];
//    RESULT.Space :=  params[2];
//    RESULT.Description :=  params[3];
//      RESULT.FieldTypelength := params[4];
dsc.No:=params[1];
//if dsc.No='105' then    ShowMessage('!!!');

dsc.Space := params[2];
dsc.Description := params[3];
dsc.FieldTypelength := params[4];
RESULT:=dsc;
    //if k<l then  TextSeek(ff,OriginPos);    //...отодвигаемс€ к началу линии
   end
   else RESULT.No :='';
 // if RESULT.No='105' then  ShowMessage('!!');
except
  ShowMessage(line+' => is incorrect. error!');   //if RESULT.No=105 then  ShowMessage('!!');
end;


end;



function readUpToTag(const ff: text; tag: String):boolean;
var preambl: string; l: integer;
begin
  l:=length(tag);
  repeat
    readln(ff,preambl);
    preambl:=copy(trim(preambl),1,l);
    if (preambl=tag) then break;
  until eof(ff);
  RESULT:=(preambl=tag);
end;

function SearchParameterValue(const ff: text; const tag: string):string;
const CLOSE = ']';
var line: string;
    //posRU, l, endp: integer;
    p, l, endp: integer ;
begin
  RESULT:='';
  repeat
    readln(ff,line);
    p:=pos(tag,line);//    posRU:=pos(RUflag,line);
    if (p>0) then
     begin
       p:=p+length(tag);
       line:=copy(line,p);
       l:=length(line);

       endp:=pos(CLOSE,line);
       if endp>0 then l:=endp;

       endp:=pos(';',line);
       if (endp>0) and (endp<l) then l:=endp;

       RESULT:=copy(line,1,l-1);
       break;
     end;

  until eof(ff);
end;

function SearchCaptionRU(const ff: text):string;
const RUflag='RUS=';
      CLOSE = ']';
var line: string;
    posRU, l, endp: integer;
begin
  RESULT:='';
  repeat
    readln(ff,line);
    posRU:=pos(RUflag,line);
    if (posRU>0) then
     begin
       posRU:=posRU+length(RUflag);
       line:=copy(line,posRU);
       l:=length(line);

       endp:=pos(CLOSE,line);
       if endp>0 then l:=endp;

       endp:=pos(';',line);
       if (endp>0) and (endp<l) then l:=endp;

       RESULT:=copy(line,1,l-1);
       break;
     end;

  until eof(ff);
end;

//--**************--***********--***************--**************--**********--//
//реализаци€ классов секций
constructor TNavSection.Create(DataParser: TNAVParser; keyword: string);
begin
  inherited Create;
  self.Owner := DataParser;
  self.tagkeyword:=keyword;
  self.tagList := TStringList.Create;


  if self.Owner.gotoTag(self.tagkeyword)  then
   self.setContent(self.Owner.getBody('{','}')); // красна€ строка trim( )
  //!self.showSection;

  //self.Owner.tree.Items.AddChild(self.Owner.tree.Items[self.Owner.tree.Items.Count]);
  self.node:= TTreeNode.Create(self.Owner.tree.Items);
  self.node.Data := self;//Pointer(self);
//  self.node.Text := keyword
  //self.showText; TNavSection(self.node.Data).showText;
  //почему? self.node.Text := keyword;
  self.Owner.addNode(self.node, keyword);
  //TNavSection(self.node.Data).showTag; self.showTag;
end;

constructor TNavSection.Create(Node: TTreeNode);//(tag: string; content: string);
begin
  inherited Create;
  //self.node; := node;
//  self.tagkeyword:=tag;
//  self.setContent(content);
  self.node := Node;
  self.tagkeyword := Node.Text ;
  //self.txt := TNavSection(Node.Data).txt;
end;

function TNavSection.getContent: string;
begin
  RESULT:=self.txt;
end;

procedure TNavSection.getSectionTagsList;
var xy: TPoint;
begin
  self.Owner.getCoord(xy);
  xy.X:=xy.X -length(self.tagkeyword);    //продолжение заголовка имеетс€
  xy := Point(xy.X +2, xy.Y +2);
  self.tagList := self.Owner.getTagsList(xy);
  self.tagList.SaveToFile('C:\1.tags');
end;

function TNavSection.isTag(keyword: string): BOOLEAN;
begin
  RESULT:= (trim(self.tagkeyword) = trim(keyword))
end;

class function TNavSection.NAVCreateSectionObject(DataParser: TNAVParser;
  tag: string; typecode: integer): TNavSection;
begin
  case typecode of
  0: RESULT:=TNavHead.Create(DataParser, tag);
  1: RESULT:=TNavObjProp.Create(DataParser, tag);
  2: RESULT:=TNavProperties.Create(DataParser, tag);
  3: RESULT:=TNavFields.Create(DataParser, tag);
  4: RESULT:=TNavKEYS.Create(DataParser, tag);
  5: RESULT:=TNavFldGrps.Create(DataParser, tag);
  6: RESULT:=TNavCode.Create(DataParser, tag);
  else
    RESULT:=TNAVSection.Create(DataParser, tag);
  end;

end;

function TNavSection.Parse: TTreeNodes;
begin
  RESULT:=nil;
end;

procedure TNavSection.saveTagToFile(dirname, filename: string);
var ff: text;
begin
  filename:=StringReplace(filename,ExtractFileExt(filename),'.',[])+self.tagkeyword;
  assign(ff, IncludeTrailingPathDelimiter(dirname)+filename);
  try
    rewrite(ff);
    writeln(ff,self.txt);
  finally
    closefile(ff);
  end;
end;



procedure TNavSection.setContent(str: string);
begin
  if pos(#0#$D#$A,str)=1 then   str:=copy(str,4);
  self.txt:=DosToAnsi(str);
end;



procedure TNavSection.showTag;
begin
  ShowMessage(self.tagkeyword);
end;

procedure TNavSection.showText;
begin
  ShowMessage(self.txt);
end;

procedure TNavSection.showSection;
begin
  ShowMessage('       '+self.tagkeyword+'  : '+ #13#10
             +'*********************'
  + #13#10  +self.txt
  + #13#10 +  '*********************');
end;

constructor TNavHead.Create(DataParser: TNavParser; keyword: string);
begin
  inherited Create(DataParser, keyword);
  with self.descr do
   begin
    Tag := ''; ObjectType :='';  No:=''; CaptionRU :='';
   end;
  //self.node.Data := @self;
  //self.node.Text := keyword;
  //self.Owner.tree.Items.Add(nil,keyword);

end;

function TNavHead.ReadTag: string;
const MM=3;
var head: string;
    k, l, m, p: integer;
    params: array [0..MM] of string;
begin
  head:=self.Owner.currentLine;

  if not self.isTag(self.Owner.getTag) then exit;

  l:=length(head);   //длина строки
  m:=0;              //счетчик  параметров
  k:=1;              //курсор
  repeat
    p:=k-1+pos(' ',copy(head,k));  //позици€ конца токена
    if p<k then break;   //если слово единственное в своЄм роде
    params[m]:=trim(copy(head,k,p-k));
    k:=p+1; inc(m);
    if (m=MM) and (k<l) then
     begin
       params[MM]:=params[m]+copy(head,p,l-p+1);    //??
       break;
     end;
  until k>l;
  if self.isTag(UpperCase(params[0])) then
   begin
    self.descr.Tag :=  trim(params[0]);
    self.descr.ObjectType :=  trim(params[1]);
    self.descr.No         :=  trim(params[2]);
    self.descr.CaptionRU  :=  trim(DosToAnsi(params[3]));
    RESULT:= self.descr.Tag+';'+self.descr.ObjectType+';'+self.descr.No+';'+self.descr.CaptionRU;
   end
   else RESULT:='';
end;



procedure parseFile(const filename: string; var headstring: string);
//const FLNM='0000000003=Payment Terms=.nav';
var

  xy: TPoint;
  NavObj: TNavHead;
  NavObjProp: TNavObjProp;
  NavProp: TNavProperties;
  NavFields: TNavFields;
  NavKeys: TNavKEYS;
  NavFldGrps: TNavFldGrps;
  NavCode: TNavCode;

  NavSections: array of TNavSection;
  k: integer;

begin
  FormTreeView.Items.Clear;
  PP:=TNAVParser.Create(FormTreeView);
  if filename='' then exit;//filename:=FLNM;

  PP.getLinesFromFile(filename);     //считываетс€ содержимое файла

  if PP.content.Count = 0  then exit; //файл пуст
  

  NavObj:=TNavHead.Create(PP,'OBJECT');
  ShowMessage(NavObj.ReadTag);  //!дл€ отладки
  //!дл€ отладки ShowMessage(trim(NavObj.Owner.getBody('{','}')));

  headstring:=NavObj.descr.Tag + ' '+NavObj.descr.ObjectType + ' '
          + NavObj.descr.No + ' ' + NavObj.descr.CaptionRU ;
  xy := Point(0,0);

  PP.setCoord(xy); //!!!!! (X=столбец,Y=строка)
  //ShowMessage();

  PP.gotoTag('OBJECT');

  PP.setRoot(NavObj.node);
  NavObj.getSectionTagsList;
  
  xy := Point(1,1);
  PP.setCoord(xy);

  SetLength(NavSections,NavObj.tagList.Count);
  for k:= 0 to NavObj.tagList.Count - 1 do
    NavSections[k]:=TNavSection.NAVCreateSectionObject(PP,NavObj.tagList[k],k+1);    //Create(PP,NavObj.tagList[k]);
  FormTreeView.FullExpand;


  exit;
  //********* код --- не --- выполн€етс€ ********************************//
  PP.setCoord(xy);

  NavObjProp := TNavObjProp.Create(PP,'OBJECT-PROPERTIES');

//  ShowMessage('!');
//  if PP.gotoTag()  then
//   begin
//    ShowMessage( trim(PP.getBody('{','}')) );
//   end;

  NavProp := TNavProperties.Create(PP, 'PROPERTIES');
//  if PP.gotoTag()  then
//   begin
//    ShowMessage( trim(PP.getBody('{','}')) );
//   end;

  NavFields := TNavFields.Create(PP, 'FIELDS');

//  if PP.gotoTag()  then
//   begin
//    ShowMessage( trim(PP.getBody('{','}')) );
//   end;

  NavKeys:=TNavKEYS.Create(PP,'KEYS');

//  if PP.gotoTag()  then
//   begin
//    ShowMessage( trim(PP.getBody('{','}')) );
//   end;

  NavFldGrps := TNavFldGrps.Create(PP,'FIELDGROUPS');
//  if PP.gotoTag()  then
//   begin
//    ShowMessage( trim(PP.getBody('{','}')) );
//   end;

  NavCode := TNavCode.Create(PP,'CODE');
  NavCode.saveTagToFile('D:\work\NAV\objects\',filename) ;
//  if PP.gotoTag()  then
//   begin
//    ShowMessage( trim(PP.getBody('{','}')) );
//   end;

  //******** финализаци€ ************************************************//
  NavObj.Free;
  NavObj:=nil;

  PP.Free;
  PP:=nil;

end;

procedure parseSection(ParentSection: TNavSection; SECTION: TNAVSectionClass);
var lines: TStrings;
    line, str: string;
    Num, k, space, equpos: integer;
    root, child: TTreeNode;
    txt, OpBr, ClBr: string;
    dlm: char;
begin

  lines:=TStringList.Create;
  lines.Text:=ParentSection.getContent;

//  case trim() of
//
//  end;

  Num:=0;
  if lines.Count = 0 then exit;

  root:=ParentSection.node;

  k:=0;
  repeat
    inc(Num);
    str:='';
    if length(trim(lines[k]))=0 then
     if (k+1<lines.Count) then begin inc(k); continue; end else exit;

    space:=identcontent(lines[k]);
    repeat
      str:=str+lines[k];
      inc(k);
    until (k=lines.Count) OR (identcontent(lines[k])<=space);

    //ShowMessage(str);

    equpos:=pos('=',str);
//    if pos(';',str)<equpos then equpos:=pos(';',str);

    //TNavSection(root.Data).showSection;
    child:=FormTreeView.Items.AddChild(root, copy(str,1,equpos-1));

    child.Data:=SECTION.Create(child);//TNAVSection.Create(child);(copy(str,1,equpos-1), str);    //root.GetLastChild
    TNAVSection(child.Data).txt :=str;    //  TNavSection
  until k=lines.Count;
  //ShowMessage(IntToStr(Num));
//    TNavValues(child.Data).OpenBr := OpBr;
//    TNavValues(child.Data).CloseBr := ClBr;
//    TNavValues(child.Data).delimiter := dlm;
end;

procedure parseValues(ParentSection: TNavValues; SECTION: TNAVSectionClass);
var str, OpBr, ClBr: string;
  i: Integer;
  root, child: TTreeNode;
  subsection: TNavSection;
  dlm: char;
begin

  with ParentSection do
   begin
    if list<>nil then exit; // ParentSection.

    str:=ParentSection.getContent;
    root:=ParentSection.node;

    if pos(OpenBr+'VAR ',str)=pos(OpenBr,str+OpenBr)  then
     begin
      List:= TStringList.Create;//*** 
      List.Text:=str;
      child:=FormTreeView.Items.AddChildFirst(root,  '{ CODE }');
      subsection:=SECTION.Create(child);
      str:=StringReplace(str, 'VAR   ', 'VAR'+#13#10+'   ',[]);
      str:=StringReplace(str, 'BEGIN   ', 'BEGIN'+#13#10+'   ',[]);
      subsection.txt := StringReplace(copy(str,pos(OpenBr,str)+1),';   ',';'+#13#10+'   ',[rfReplaceAll]);
      child.Data:=subsection;
//      TNavSection(child.Data).txt:=str;
      exit;
     end;
    
// ...else...
    if pos(OpenBr+'[',str)=pos(OpenBr,str+OpenBr)  then
     begin
       OpBr:='[';
       ClBr:=']';
       dlm:=';';
     end
    else
     begin
       OpBr:=OpenBr;
       ClBr:=CloseBr;
       dlm:=delimiter;
     end;
      list:=TNAVParser.Proplist(str,OpBr,ClBr,dlm);//ParentSection.ParentSection. ParentSection.

    //Open:=copy(trim(str),1, pos(' ',trim(str)));
    //ParentSection.list:=TStringList.Create;


    if ParentSection.list.Count >0 then
     for i := 0 to List.Count - 1 do    //   ParentSection.
      begin
        //TTreeNode.Create();     Object , child                 ;
        if pos('=', List.Strings[i])<pos(' ', List.Strings[i]+' ') then
          str:=copy(List.Strings[i],1, pos('=', List.Strings[i]+'=')-1)
        else
          str:=List.Strings[i];
        child:=FormTreeView.Items.AddChild(root,  str);//= + tagkeyword+'.' +'[' +']'
        subsection:=SECTION.Create(child);
        child.Data:=subsection;
         TNavSection(child.Data).txt:=List.Strings[i]+' ;';
      end;

   end;
end;





{ TNavObjProp }

function TNavObjProp.Parse: TTreeNodes;
var N: integer; valline: string;
begin
  if self.node.Count >0 then exit;

  parseSection(TNavObjProp(self.node.Data),TNavValues);
  RESULT:=self.Owner.tree.Items;   //!!!!

  self.descr.Date := TNAVParser.Body(TNavSection(self.node.Item[0].Data).getContent,'=',';');
  self.descr.Time := TNAVParser.Body(TNavSection(self.node.Item[1].Data).getContent,'=[','];');
  self.descr.VersionList := TNAVParser.Body(TNavSection(self.node.Item[2].Data).getContent,'=',';');


end;

{ TNavProperties }

function TNavProperties.Parse: TTreeNodes;
var N: integer;
begin
  if self.node.Count >0 then exit;

  parseSection(TNavProperties(self.node.Data),TNavValues);
  RESULT:=self.Owner.tree.Items;   //!!!!
end;

{ TNavFields }

function TNavFields.Parse: TTreeNodes;
var  N, i, semicolonpos: integer;
//  Obj: TNavFields;
begin
  if self.node.Count >0 then exit;

  parseSection(TNavFields(self.node.Data),TNAVSubFields);
  RESULT:=self.Owner.tree.Items;   //!!!!
  semicolonpos:=pos(';', self.getContent);
  for i := 0 to self.node.Count - 1 do
    self.node.Item[i].Text:= trim(copy(StringReplace(TNavFields(self.node.Item[i].Data).getContent,';','}',[]),1, semicolonpos+1));

end;

{ TNavKEYS }

function TNavKEYS.Parse: TTreeNodes;
var  N, i, semicolonpos: integer;
begin
  if self.node.Count >0 then exit;

  parseSection(TNavKEYS(self.node.Data),TNavSubFields);
  RESULT:=self.Owner.tree.Items;   //!!!!

  semicolonpos:=pos(';', self.getContent);
  for i := 0 to self.node.Count - 1 do
    self.node.Item[i].Text:= trim(copy(StringReplace(TNavFields(self.node.Item[i].Data).getContent,';','{',[]),semicolonpos,40))+'}';


end;

{ TNavValues }

constructor TNavValues.Create(Node: TTreeNode);
begin
  inherited Create;
  self.node := Node;
  self.tagkeyword := Node.Text ;
//  self.list:=TStringList.Create;
  self.OpenBr := '=';
  self.CloseBr:= ';';
  self.delimiter := ',';
end;

function TNavValues.Parse: TTreeNodes;
var N: integer;
begin
  parseValues(self,TNavValues);  // TNavValues(self.node.Data)
end;

{ TNAVSubFields }

constructor TNAVSubFields.Create(Node: TTreeNode);
begin
  inherited Create(Node);
  self.OpenBr := '{';
  self.CloseBr:= '}';
  self.delimiter := ';';
end;

function TNAVSubFields.Parse: TTreeNodes;
begin
  parseValues(self,TNavValues);  //   TNavSubFields(self.node.Data)
end;

end.

