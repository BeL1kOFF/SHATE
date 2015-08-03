unit UnitParser;

interface
uses ComCtrls, Classes, SysUtils, Dialogs, Contnrs, Types;
type TNAVParser = Class (TObject)  // TTreeView
  public
    procedure getLinesFromFile(FilePathName: string);
    function getContent(): string;

    function getKeyNode: TTreeNode;
    procedure addNode(var TreeNode: TTreeNode; tag: string);
    procedure setRoot(tagnode: TTreeNode);
//    function getTag(): string;

    function getTag: string;
    function gotoTag(Tag: string): boolean;

    function getConformity(startWith: integer; OpenBr: String; CloseBr: String) : string;
    function getPropertyBody(startWith: integer): string;
    function getBody(OpenBr, CloseBr: string): string;
    class function Body(str: String; OpenBr, CloseBr: string): string;
    class Function Proplist(str: string; OpenBr, CloseBr: string; delim: char): TStringList;

    function currentLine: string;
    function getTagsList(ij: TPoint): TStringList;

    constructor Create(TreeView: TTreeView);
    var content: TStringList;
        tree: TTreeView;
    procedure getCoord(var ij: TPoint);
    procedure setCoord(var ij: TPoint);
  private
    function indentation(line: string): Integer;
//    function identSy(sy: char; line: string): integer;
    function isTailSy(sy: char; line: string): boolean;

    function symbindex(var level: integer; line: string; OpenBr: string; CloseBr: string; symb: Char): integer;


    const
      sySpace = ' ';
      syEqu   = '=';

    var

      lineNo, cursor: integer;
      Tails: TStack;
      Root: TTreeNode;
  End;
var   PP: TNAVParser;
function identcontent(str: string): integer;

//  TOBJECTDESCRIPTOR, TFIELDDESCRIPTOR ���������� � ������ UnitNAV

implementation

procedure TNAVParser.addNode(var TreeNode: TTreeNode; tag: string);
var NewNode: TTreeNode;
begin
//  if self.SubRoot = nil then  self.tree.Items.Add(CurrentNode,tag)
//  else
  if self.Root=nil then
   begin
    NewNode:=self.tree.Items.AddFirst(self.Root,tag);
    self.Root := self.tree.Items[0];
   end
  else NewNode:=self.tree.Items.AddChild(self.Root,tag);
  if TreeNode=nil then exit;

  NewNode.Data := TreeNode.Data;
  TreeNode.Free;
  TreeNode:=NewNode;
  //self.tree.Items[self.tree.Items.Count-1].Data := TreeNode.Data;
//  if self.tree.Items.Count>0 then CurrentNode:=self.tree.Items[self.tree.Items.Count - 1]
//  else  CurrentNode:=nil;


  //! ShowMessage(tag+' is added!');
  ///////////////self.tree.Items[self.tree.Items.Count-1].Data:=TreeNode;
end;

class function TNAVParser.Body(str: string; OpenBr, CloseBr: string): string;
var k, start, fin, len: integer;
begin
  RESULT:='';
  start:=pos(OpenBr,str);
  if start=0 then exit;
  RESULT:=OpenBr;
  inc(start, length(OpenBr));

  fin:=pos(CloseBr,str);
  if fin=0 then exit;
  //RESULT:=CloseBr;
  //if fin+ then

  RESULT:=copy(str,start,fin-start);
end;

constructor TNavParser.Create(TreeView: TTreeView);
begin
  inherited Create;
  LineNo:=0;
  Self.Tails:=TStack.Create;
  Self.content := TStringList.Create ;

  Self.tree := TreeView;
end;

function TNavParser.getTag:string;
var line: string;
begin
  line:=trim(self.content.Strings[lineNo]);
  //ShowMessage(line+' -> '+IntToStr(pos(line,' ')-1));
  RESULT:=copy(line,1,pos(' ',line)-1);
  self.cursor:=pos(self.content.Strings[lineNo],RESULT)+length(RESULT);
end;

function identcontent(str: string): integer;
begin
  RESULT:= pos(trim(str),str);
end;

function TNAVParser.getTagsList(ij : TPoint): TStringList;
var  line: string;   i, j : integer;
begin
  RESULT:=TStringList.Create;
  j:=ij.X ;
  i:=ij.Y ;
  repeat
    line:=self.content.Strings[i];
    if (length(trim(line))>0)and(identcontent(line)<j) then exit;
    if (identcontent(line)=j)and(pos(trim(line),'{}')=0) then RESULT.Add(trim(line));
    inc(i);
  until i=self.content.Count;
end;

function TNAVParser.gotoTag(tag: string): boolean;
var i, j, p: integer; line: string;
begin
RESULT:=false;
  if self.content.Count=0 then exit;

  i := 0;
  //self.lineNo;
  j := self.cursor;
  for i := 0 to self.content.Count - 1 do
   begin
    line := trim(copy(self.content[(self.lineNo + i)  mod self.content.Count],j));
    if (pos(Tag,trim(line))=1)then
     begin
      j:=pos(Tag, line)+length(Tag);
      if (j<length(line)) and (NOT(line[j] in [#13, #0, ' '])) then  continue;
      if line[j] in [#0, #13] then
       begin
        self.lineNo := (self.lineNo + i + 1)  mod self.content.Count;
        self.cursor := pos(Tag, line);
       end
      else
       begin
        self.lineNo := (self.lineNo + i)  mod self.content.Count;
        self.cursor := j;
       end;
      RESULT:=true;
      exit;
     end;
   end;
   
end;

function TNAVParser.indentation(line: string): integer;
var k, l: integer;
begin
  RESULT:=0;
  l:=length(line);
  k:=0;
  Repeat
    inc(k);
    if  k>l then exit;
  Until line[k]<>sySpace;
  RESULT:=k;
end;

//function TNAVParser.identSy(sy: char; line: string): integer;
//var k, l: integer;
//begin
//  RESULT:=0;
//  l:=length(line);
//  k:=0;
//  Repeat
//    inc(k);
//    if  k>l then exit;
//  Until line[k]=sy;
//  RESULT:=k;
//end;
function TNAVParser.isTailSy(sy: char; line: string): boolean ;
begin
  RESULT:=(line[length(line)]=sy);
end;


class function TNAVParser.Proplist(str: string; OpenBr, CloseBr: string; delim: char): TStringList;
var k, l, lvl: integer;
begin
  RESULT:=TStringList.Create;
  RESULT.Delimiter :=delim;
  str:=TNAVParser.Body(str,OpenBr,CloseBr);
  str:=StringReplace(str,' ',#$B6,[rfReplaceAll]);
  if delim=';' then
  begin
    RESULT.QuoteChar := '"';
    //RESULT.Strings.

    lvl:=0;
    l:=length(str);
    for k := 1 to l do
     begin
       case str[k] of
       ';': if lvl>0 then str[k]:=#$A1;
       '[': inc(lvl);
       ']': dec(lvl);
       //'_': str[k]:=#
       eND;
     end;

        ;
  end;


  //RESULT.LineBreak #13#10   StringOfChar(' ', 11)
//  str:=StringReplace(str,#10,'10',[rfReplaceAll]);
//  str:=StringReplace(str,#0 ,'0',[rfReplaceAll]);
  //str:=StringReplace(str,'[',']',[rfReplaceAll]);

  RESULT.DelimitedText := str;

  //exit;


  for k := 0 to RESULT.Count - 1 do
    begin
      //InputBox('','',(RESULT.Strings[k]));
       if delim=';' then RESULT.Strings[k]:=StringReplace(RESULT.Strings[k],#$A1,';',[rfReplaceAll]); //'[ '+ +' ]'
      //InputBox('','',(RESULT.Strings[k]));
      RESULT.Strings[k]:=trim(StringReplace(RESULT.Strings[k],#$B6,' ',[rfReplaceAll]));
      //      InputBox('','',(RESULT.Strings[k]));
    end;
end;

procedure TNAVParser.getLinesFromFile(FilePathName: string);
begin
  try
    self.content.LoadFromFile(FilePathName);
  except
    MessageDlg('��������� � ����� "'+FilePathName +'" ����������� ��������' ,mtError,[mbCancel],0);
  end;
end;

function TNAVParser.getContent: string;
var LineIndex: integer;
    ptr: Pointer;
begin
  inc(LineNo);
  LineIndex:=LineNo;
  cursor:=1;
  ShowMessage(self.getConformity(cursor,'{','}'));

  ptr:= @(self.content.Strings[lineNo][1]);
  self.Tails.Push(ptr);
  self.lineNo := LineIndex;
end;

procedure TNAVParser.getCoord(var ij: TPoint);
begin
  ij.X := self.cursor;
  ij.Y := self.lineNo;
end;

function TNAVParser.getKeyNode: TTreeNode;
begin
  RESULT:=self.tree.Items[self.tree.Items.Count-1];
end;

procedure TNAVParser.setCoord(var ij: TPoint);
begin
  self.cursor := ij.X ;
  self.lineNo := ij.Y ;
end;


procedure TNAVParser.setRoot(tagnode: TTreeNode);
begin      //var k: integer;
//  k:= self.Root.Inde
//  repeat
//    self.tree.Items[self.tree.Items.Count -1 ];
//  until ;
  if tagnode = nil then exit;
  //tagnode.
  if self.Root.IndexOf(tagnode)>0 then
    self.Root :=self.tree.Items[self.Root.IndexOf(tagnode)];// .Items[self.tree.Items.Count -1 ];
end;

function TNavParser.currentLine: string;
begin
  currentLine:=self.content.Strings[lineNo];
end;

function compareWithBracket(OpenBracket, CloseBracket, line: String; var index: integer): integer;
var l0, ll, indextmp: integer;
begin
  indextmp:=index;
  l0:=length(OpenBracket);
  ll:=length(CloseBracket);

  RESULT:=+1;
  index:=indextmp+l0-1;
  if copy(line,indextmp,l0)=OpenBracket then exit;

  RESULT:=-1;
  index:=indextmp+ll-1;
  if copy(line,indextmp,ll)=CloseBracket then exit;

  RESULT:=0;
  index:=indextmp;
end;

//������� ���������� ���������� ����, � ��������
//����������� ������ ����������� ����� ������� �������
function TNAVParser.getConformity(startWith: integer; OpenBr: String; CloseBr: String) : string;
var level, l: integer;
    i, j: integer;
    line, str: string;
begin
  RESULT:='';

  //�������� � ��������� ������� � ������� ������
  i:=lineNo;
  line:=copy(self.content.Strings[i],startWith);

  //���� ������ ����������� ������
  repeat
    j:=pos(OpenBr, line);
    if j>0 then break;
    inc(i);
    line:=self.content.Strings[i];     //������ ��������� ������
  until i=self.content.Count;

  if j=0 then exit //����������� ����� => �����
  else  level:=1;  //���� ���-�� �������...

  //� j ������� ����������� ������
  repeat
     self.lineNo:=i;       //****
     str:='';           //������� ������ ��������
     l:=length(line);   //����� ������



     repeat
      inc(j);           //����� �������
//      case comparewithbracket(OpenBr,CloseBr, line,j) of   //������������ ��������� ������� line[j]
//        +1: inc(level);
//        -1: dec(level);
//      //else
//      end;

      inc(level,comparewithbracket(OpenBr,CloseBr, line,j));

      if level=0 then break  //���� ��������� ����� ���� ����� �� �����
      else  str:=str+line[j]; //����� ��������� �������

     until j>=l; //��������� ����� ������

     RESULT:=concat(RESULT,#13#10,str); //�������� ������ ��������
     if level=0 then //exit;       //�������� ��������� - ������ happy end
         begin ShowMessage('['+IntToStr(i)+','+IntToStr(j)+']: '+str); exit; end;
     //������� �� ����� ������
     j:=0;
     repeat
       line:=self.content.Strings[i];
       inc(i);
       if i>166 then ShowMessage('!');

       if i=self.content.Count then break;
     until line<>'';
  until i=self.content.Count;

  if level<>0 then ShowMessage(str+' :' +IntToStr(i)+' '+ IntToStr(level));//RESULT:=''; //����� ��� � �� ��������
end;


//������� ���������� ������� �������� ������� ������������ �� ��������� ��������
function TNAVParser.symbindex(var level: integer; line: string; OpenBr: string; CloseBr: string; symb: Char): integer;
var k,l: integer;
begin
  l:=length(line);
  for k:=1 to l do
    if line[k]=symb then
      begin
        RESULT:=k;
        exit;
      end
      else
      inc(level,comparewithbracket(OpenBr,CloseBr, line,k));
//   case line[k] of
//    OpenBr:  inc(level);
//    CloseBr: dec(level);
//    symb:
//      if level=0 then
//       begin
//         RESULT:=k;
//         exit;
//       end;
//   end;

  RESULT:=0;
end;

//������� ���������� �������� ��-��
//����������� �� ��� ��� ��������� �������
function TNAVParser.getPropertyBody(startWith: integer): string;
var i,j,l,ident, level, m: integer;
    line, propBody: string;
begin

  i:=lineNo;
  line:=copy(self.content.Strings[i],startWith);
  j:=pos(syEqu,line);

  level:=0;
  m:=self.symbindex(level,line,'[',']',';');
  if m>0  then  //���� �������� ��-�� ������������ � ����� ������
  begin
    RESULT:=copy(line,j,m-1);
    exit;
  end;

  //...����� ������������� �� �������
  propBody:=copy(line,j);
  ident:=j+1;
  inc(i);
  while i<self.content.Count do
   begin

    line:=self.content.Strings[i];     //������ ��������� ������
    if self.indentation(line)<ident  then
     begin
//      if propBody[length(propBody)]=';' then
      if self.isTailSy(';',propBody)  then
        RESULT:=copy(propBody,1,length(propBody)-1)
       else RESULT:=propBody;
      exit;  //���� ��-�� ��������
     end;
    RESULT:=concat(RESULT,#13#10,line);
    inc(i);    
   end;

  RESULT:='';
end;

//������� ��������� ���� ���� ������������ � ��������������� ������
function TNavParser.getBody(OpenBr, CloseBr: string): string;
var i,j,l,ident, lvl, m: integer;
    line, body: string;
begin
  RESULT:='';
  i:=self.lineNo; //�������� ������� ����� ������

  //j:=pos(OpenBr[1],line);
  j:=self.cursor;   //j:=1;            //������������� ������
  m:=0;                              //���������� ������ �����������
  repeat   //���� �������� �����
    line:=self.content.Strings[i];
    l := length(line);
    j:=1;
    repeat
      ident:=j;
      m:=compareWithBracket(OpenBr,CloseBr,line,j);   //��� ������
      if m=1 then                   //����� ���� ����������� �������
        break;
      inc(j);
    until j>l;

    if m=1 then Break;              //..� ����� �� ������� ����
    inc(i);                         //����� �� �������� ������
    //j:=pos(OpenBr[1],line);
  until i=self.content.Count;
  if m<>1 then exit;         //����� ���� ������ ��������� ������ �� �����������
  self.cursor:=0;
  inc(j);//ident:=j;                 //���������� ������ �������
  lvl:=1;                   //������ ������ ������� ����������� 1

  repeat        //���� � ������� ��������������� �����������
    m:=compareWithBracket(OpenBr,CloseBr,line,j);//j ��������� � ������� �� �������
    inc(lvl,m);      //���������� ������ ����������� ������ � ������ �������
    if lvl=0 then break //����� �� ���� ������
    else RESULT:=RESULT+line[j];   //����� �������� ������ � ���������
    inc(j);
  until j>l;

  if lvl=0 then exit;      //

  inc(i);                    //���� �� �������� ������ �������� �� ���� �������
  if i=self.content.Count then exit;

  repeat    //���� �� ������� � ������� ����������� ������ �����. ������
    line:= self.content.Strings[i];
    //� ������� ��� ����������� ������ ����� ��������������� ������
//    if i = 88 then
//    ShowMessage(copy(line,3,1));
    j := ident;
    if compareWithBracket(OpenBr, CloseBr, line, j)=-1 then exit
    else RESULT:=concat(RESULT,#13#10, self.content.Strings[i]);
    inc(i);
  until i=self.content.Count;
  //lvl:=0;
  //m:=self.symbindex(lvl,line,'[',']',';');

end;


end.
