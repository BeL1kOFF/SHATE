unit UnitAUX;

interface
  uses Classes;
  const
    FORMATFILETIMESTAMP = '[yyyy.mm.dd hh-mm-ss]';

  var filelog: string;

  function transformFileName(OrigFileName: string): string;

  function GetFilesSeqByMask(Dir:String; mask: string):String;
  function separate(sentence: string; Open, Close: char): string;
  function substitution(ctrlstr, replacement: string): string;

  function PrintLog(Msg: string; filelog: string): boolean;
  function PrintTimestamp(Msg: string; filelog: string = ''): boolean;

  function getSysUser: string;
  function MultyReplace(str: string; templtext, repltext: string; delim: char = ';'): string;
  function GenerateParameterizedRequest(identProc, identParam: string; Nparam: integer): string;
implementation

uses
  SysUtils, Windows;

function transformFileName(OrigFileName: string): string;
var timestamp: string;
    FilePath:  string;
begin
  RESULT:=OrigFileName;
  if FileExists(OrigFileName) then
    FilePath := ExtractFilePath(OrigFileName)
   else
    exit;

  OrigFileName := ExtractFileName(OrigFileName);
  timestamp := FormatDateTime(FORMATFILETIMESTAMP,Now());
  RESULT := Concat(FilePath, timestamp, trim(OrigFileName), '._');
end;

function GetFilesSeqByMask(Dir:String; mask: string):String;
const
  CRLF = #$D#$A;
var
  Rec:TSearchRec;
  TMP:String;
//  ls: String;
//  i: integer;
begin
  TMP := '';
  try
    //exit if file not satisfy mask by condition
    if SysUtils.FindFirst(Dir+'\'+mask,faAnyFile,Rec)<>0 then exit;

    repeat
       if (Rec.Name<>'.')and(Rec.Name<>'..') and ((Rec.Attr AND faDirectory) = 0) then
          TMP:=Concat(TMP , CRLF, Rec.Name );
    until  SysUtils.FindNext(Rec)<>0;
  finally
    SysUtils.FindClose(Rec);
  end;
  if Length(TMP)>Length(CRLF) then
    RESULT := StringReplace(TMP, CRLF, '', []);
end;


function separate(sentence: string; Open, Close: char): string;
var p0, p: integer;
begin
  RESULT := '';
  p0 := pos(Open, sentence);
  p :=  p0 + pos(Close, Copy(sentence, p0+1));
  if p0*p*(p-p0)>0 then
    RESULT := copy(sentence, p0+1, p-p0-1);
end;

function substitution(ctrlstr, replacement: string): string;
begin
  if Trim(ctrlstr)>'' then
    RESULT := ctrlstr
   else
    RESULT := replacement;
end;


function PrintLog(Msg: string; filelog: string): boolean;
var logfile: text;
begin
  RESULT:=False;
  if ExtractFilePath(filelog)='' then
    ChangeFilePath(filelog,ExtractFilePath(Paramstr(0)));
  AssignFile(logfile,filelog);
  try
    if FileExists(filelog) then
      Append(logfile)
     else
      Rewrite(logfile);
    RESULT := True;
  except on E: Exception do
  end;

  if RESULT then
  try
    RESULT := False;
    Writeln(logfile, Msg);
    RESULT := True;
  finally
    CloseFile(logfile);
  end;
end;


function PrintTimestamp(Msg: string;  filelog: string = ''): boolean;
var logfile: text;
begin
  RESULT:=False;
  if filelog = '' then
    filelog := ChangeFileExt(Paramstr(0),'.file.log');
  if ExtractFilePath(filelog)='' then
    filelog:= ExtractFilePath(Paramstr(0)) + filelog;
  AssignFile(logfile,filelog);
  try
    if FileExists(filelog) then
      Append(logfile)
     else
      Rewrite(logfile);
    RESULT := True;
  except on E: Exception do
  end;

  if RESULT then
  try
    RESULT := False;
    Writeln(logfile, Concat(DateTimeToStr(Now()),#$9, Msg));
    RESULT := True;
  finally
    CloseFile(logfile);
  end;
end;

function getSysUser: string;
var
  userNameLen: Cardinal;
  user: string;
begin
  userNameLen:=255;
  setLength(user, userNameLen);
  getUserName(PChar(user),userNameLen);
  RESULT := trim(user);
end;

function MultyReplace(str: string; templtext, repltext: string; delim: char = ';'): string;
var k: integer;
  TemplList, ReplList: TStringList;
begin

  TemplList:= TStringList.Create; ReplList:= TStringList.Create;

  try
    templtext := StringReplace(templtext,delim,#$D#$A,[rfReplaceAll]);
    repltext := StringReplace(repltext,delim,#$D#$A,[rfReplaceAll]);

    TemplList.Text := templtext; ReplList.Text := repltext;

    if TemplList.Count <> ReplList.Count then exit;

    for k:=0 to TemplList.Count-1 do
     if k<ReplList.Count  then
      str:=Stringreplace(str,TemplList[k],ReplList[k],[rfReplaceAll, rfIgnoreCase])
     else break;
  finally
    TemplList.Free; ReplList.Free;
  end;
  RESULT:=str;
end;

function GenerateParameterizedRequest(identProc, identParam: string; Nparam: integer): string;
const SQL = 'SELECT * FROM "##proc##" (##paramlist##)';
var
  k, l: integer;
  paramlist: string;
begin
  RESULT := StringReplace(SQL, '##proc##',identProc, [rfIgnoreCase, rfReplaceAll]);
  paramlist := '';
  for k:=0 to Nparam - 1 do
    paramlist := paramlist + Concat(':', identparam, IntToStr(k), ',');
  l := length(paramlist);
  if l>0 then  
    SetLength(paramlist, l-1);
  RESULT := StringReplace(RESULT, '##paramlist##', paramlist, []);
end;

end.
