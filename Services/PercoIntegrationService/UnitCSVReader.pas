{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O-,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
unit UnitCSVReader;

interface

uses
  Classes, SysUtils;

type
  TBaseCSVReader = class
  private
    fFile: TextFile;
    fOpened: Boolean;
    fCurrentLine: string;
    fBufReaded: string;

    FFilePos: Int64;
    FFileSize: Int64;
    FFileName: string;
    FFilePosPercent: Cardinal;
    FLineNum: Cardinal;
    function GetEof: Boolean;
    procedure RecalcPercent;
  public
    destructor Destroy; override;

    procedure Open(const aFileName: string);
    procedure Close;
    function ReturnLine: string; virtual;

    property CurFileName: string read FFileName;
    property FileSize: Int64 read FFileSize;
    property FilePos: Int64 read FFilePos;
    property FilePosPercent: Cardinal read FFilePosPercent;
    property Eof: Boolean read GetEof;

    property CurrentLine: string read fCurrentLine write fCurrentLine;
    property LineNum: Cardinal read FLineNum;
  end;

  
const
  cReadBufSize = 1024 * 4; //4k

type
  TStreamReader = class
  private
    fBuf: array[0..cReadBufSize - 1] of Char;
    fPrevStr: string;
    fPrevChar: Char;

    fBufSize: Cardinal;
    fBufPos: Cardinal;

    fStream: TFileStream;
    fCurrentLine: string;

    FFilePos: Int64;
    FFileSize: Int64;
    FFileName: string;
    FFilePosPercent: Cardinal;
    FLineNum: Cardinal;
    function GetEof: Boolean;
    procedure RecalcPercent;
    function ReadNextMemBlock: Boolean;
    function ReadLineFromMem(out aResult: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Open(const aFileName: string);
    procedure Close;
    function ReturnLine: string; virtual;

    property CurFileName: string read FFileName;
    property FileSize: Int64 read FFileSize;
    property FilePos: Int64 read FFilePos;
    property FilePosPercent: Cardinal read FFilePosPercent;
    property Eof: Boolean read GetEof;

    property CurrentLine: string read fCurrentLine;
    property LineNum: Cardinal read FLineNum;
  end;


  TBaseStreamCSVReader = class
  private
//    fBuf: array[0..cReadBufSize - 1] of Char;
    fPrevStr: string;
    fPrevChar: Char;

    fBufSize: Cardinal;
    fBufPos: Cardinal;

    fStream: TStringStream;
    fCurrentLine: string;

    FFilePos: Int64;
    FFileSize: Int64;
    FFileName: string;
    FFilePosPercent: Cardinal;
    FLineNum: Cardinal;
    function GetEof: Boolean;
    procedure RecalcPercent;
    //function ReadNextMemBlock: Boolean;
    //function ReadLineFromMem(out aResult: string): Boolean;
  public
    destructor Destroy; override;

    function Open(const aStreamName: string): boolean;
    procedure Close;
    function ReturnLine: string; virtual;

    property CurFileName: string read FFileName;
    property FileSize: Int64 read FFileSize;
    property FilePos: Int64 read FFilePos;
    property FilePosPercent: Cardinal read FFilePosPercent;
    property Eof: Boolean read GetEof;

    property CurrentLine: string read fCurrentLine;
    property LineNum: Cardinal read FLineNum;
  end;

  TStreamCSVReader = Class(TBaseStreamCSVReader)
  private
    fFieldsDelimitters: TSysCharSet;
    fFields: TStrings;
    FDosToAnsiEncode: Boolean;

    function GetFields(Index: Integer): string;
    function GetFieldsCount: Integer;
    function GetFieldsData: TStrings;
    procedure SetDosToAnsiEncode(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    function ReturnLine: string; override;
    property Fields[Index: Integer]: string read GetFields;
    property FieldsData: TStrings read GetFieldsData;
    property FieldsCount: Integer read GetFieldsCount;
    property FieldsDelimitters: TSysCharSet read fFieldsDelimitters write fFieldsDelimitters;
    property DosToAnsiEncode: Boolean read FDosToAnsiEncode write SetDosToAnsiEncode;
  protected
    procedure ParseFields;  virtual;
  End;

  TStreamCSVXReader = Class(TStreamCSVReader)
  private

    FTitles: TStrings;
    FLine0Titles: boolean;

    function GetTitles(Index: Integer): string;
    function GetTitleLine: string;
    procedure SetTitleLine(Line: string);
    function GetLine0Titles: boolean;
    procedure SetLine0Titles(const Value: boolean);
    function GetTitlesCount: integer;

    function GetFieldbyName(tag: string): string;
    function GetFieldByIndex(index: integer): string;
  public
    property Line0Titles: boolean read GetLine0Titles write SetLine0Titles;
    property Titles[Index: Integer]: string read GetTitles;
    property TitleLine: string read GetTitleLine write SetTitleLine;
    property TitlesCount: integer read GetTitlesCount;

    property Field[tag: string]: string  read GetFieldByName;  //default;

    function Open(const streamaddr: string): boolean;

    constructor Create;
    destructor Destroy;   override;
  End;

  TCSVStreamsManager = Class
    StreamTag: string;
    StreamsPool: TStringList;
    Streams: TThreadList;
    StreamsList: TList;
    index: integer;
  private
    Stream: TStringStream;
    Lines: TStringList;
  public
    procedure Assign(var p: pointer; address: string); overload;
    procedure Assign(var id: integer; streamname: string); overload;
    procedure Rewrite(p: pointer); overload;
    procedure Rewrite(id: Integer); overload;
    procedure writeln(p: pointer; line: string);  overload;
    procedure writeln(id: integer; line: string); overload;
    procedure Finit(p: pointer);  overload;
    procedure Finit(id: integer); overload;

    function GetStreamByTag(Tag: string): TStringStream;
    
    class function pointer2addr(p: pointer): string;
    class function addr2pointer(addr: string): pointer;

    constructor Create;
    destructor Destroy; override;
  End;


  TCSVReader = class(TBaseCSVReader {faster than TStreamReader})
  private
    fFieldsDelimitters: TSysCharSet;
    fFields: TStrings;
    FDosToAnsiEncode: Boolean;
    //procedure ParseFields;
    function GetFields(Index: Integer): string;
    function GetFieldsCount: Integer;
    function GetFieldsData: TStrings;
    procedure SetDosToAnsiEncode(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    function ReturnLine: string; override;
    property Fields[Index: Integer]: string read GetFields;
    property FieldsData: TStrings read GetFieldsData;
    property FieldsCount: Integer read GetFieldsCount;
    property FieldsDelimitters: TSysCharSet read fFieldsDelimitters write fFieldsDelimitters;
    property DosToAnsiEncode: Boolean read FDosToAnsiEncode write SetDosToAnsiEncode;
  protected
    procedure ParseFields;  virtual;

  end;

  TCSVXReader = class(TCSVReader)
  private
    //FTitlesExsists: boolean;
    FTitles: TStrings;
    FLine0Titles: boolean;

    function GetTitles(Index: Integer): string;
    function GetTitleLine: string;
    procedure SetTitleLine(Line: string);
    function GetLine0Titles: boolean;
    procedure SetLine0Titles(const Value: boolean);
    function GetTitlesCount: integer;

    function GetFieldbyName(tag: string): string;
    function GetFieldByIndex(index: integer): string;
  public
    property Line0Titles: boolean read GetLine0Titles write SetLine0Titles;
    property Titles[Index: Integer]: string read GetTitles;
    property TitleLine: string read GetTitleLine write SetTitleLine;
    property TitlesCount: integer read GetTitlesCount;

    property Field[tag: string]: string  read GetFieldByName;  //default;
    //property Fields[index: integer]: string  read GetFieldByIndex;
//    function ReturnLine: string; override;
    function Open(const filename: string): boolean;

    constructor Create;
    destructor Destroy;    override;
  End;


  IUniversalCSVReader = Interface ['{34783287-3010-4008-9040-B61B116167F6}']
    function GetTitles(Index: Integer): string;
    function GetTitleLine: string;
    procedure SetTitleLine(Line: string);
    function GetLine0Titles: boolean;
    procedure SetLine0Titles(const Value: boolean);
    function GetTitlesCount: integer;
    function GetFieldbyName(tag: string): string;
    function GetFieldByIndex(index: integer): string;
    function GetFieldsCount: integer;

    property Line0Titles: boolean read GetLine0Titles write SetLine0Titles;
    property Titles[Index: Integer]: string read GetTitles;
    property TitleLine: string read GetTitleLine write SetTitleLine;
    property TitlesCount: integer read GetTitlesCount;

    property Field[tag: string]: string  read GetFieldByName;  //default;
    property FieldsCount: integer read GetFieldsCount;

    function Open(const filename: string): boolean;
    procedure Close;

    function ReturnLine: string;

    function GetFields(Index: Integer): string;
    property Fields[Index: Integer]: string read GetFields;

    function GetCurFileName: string;
    property CurFileName: string read GetCurFileName;

    function GetCurrentLine: string;
    property CurrentLine: string read GetCurrentLine;

    function GetLineNum: Cardinal;
    property LineNum: Cardinal read GetLineNum;

    function GetEof: boolean;
    property Eof: Boolean read GetEof;


  End;

  TCSVInterfaceType = (CSVINTERFACEFILE, CSVINTERFACEMEMORY);
  
  TInterfacedCSVFileReader = Class(TCSVXReader, IUniversalCSVReader)
  protected
    FRefCount: Integer;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  private
    function GetCurFileName: string;
    function GetCurrentLine: string;
    function GetLineNum: Cardinal;
  public
    property CurFileName: string read GetCurFileName;
    property CurrentLine: string read GetCurrentLine;
    property LineNum: Cardinal read GetLineNum;
  End;


  TInterfacedCSVStreamReader = Class(TStreamCSVXReader, IUniversalCSVReader)
  protected
    FRefCount: Integer;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  private
    function GetCurFileName: string;
    function GetCurrentLine: string;
    function GetLineNum: Cardinal;
  public
    property CurFileName: string read GetCurFileName;
    property CurrentLine: string read GetCurrentLine;
    property LineNum: Cardinal read GetLineNum;
  End;

  var StringStreamsManager:  TCSVStreamsManager;
  function BirthCSVInterface(CSVInterfaceType: TCSVInterfaceType): IUniversalCSVReader;

implementation

uses
  Windows;

function BirthCSVInterface(CSVInterfaceType: TCSVInterfaceType): IUniversalCSVReader;
begin
  RESULT := nil;
  case CSVInterfaceType of
    CSVINTERFACEFILE:
      RESULT := TInterfacedCSVFileReader.Create;
    CSVINTERFACEMEMORY:
      RESULT := TInterfacedCSVStreamReader.Create;
  end;
end;


{ TBaseCSVReader }

destructor TBaseCSVReader.Destroy;
begin
  Close;

  inherited;
end;

function TBaseCSVReader.GetEof: Boolean;
begin
  Result := (not fOpened) or System.EOF(fFile);
end;

procedure TBaseCSVReader.Open(const aFileName: string);
var
  aStream: TFileStream;
begin
  if not FileExists(aFileName) then
    raise Exception.CreateFmt('TBaseCSVReader: ‘айл "%s" не найден', [aFileName]);

  Close; //close previous file if has assigned


  aStream := TFileStream.Create(aFileName, fmOpenRead);
  try
    FFileSize := aStream.Size;
  finally
    aStream.Free;
  end;

  AssignFile(fFile, aFileName);
  Reset(fFile);

  FFilePos := 0;
  FFileName := aFileName;
  fOpened := True;
  fBufReaded := '';
end;

procedure TBaseCSVReader.RecalcPercent;
begin
  if FFileSize = 0 then
    FFilePosPercent := 100
  else
    FFilePosPercent := (FFilePos * 100) div FFileSize;
end;

function TBaseCSVReader.ReturnLine: string;
begin
  if not fOpened then
    raise Exception.Create('TBaseCSVReader: ‘айл не открыт');

  Result := '';
  fCurrentLine := '';

  if Eof then
    Exit;


  //Readln(fFile, fBufReaded);

  Readln(fFile, Result);
  fCurrentLine := Result;
  Inc(FFilePos, Length(Result) + 2);
  Inc(FLineNum);
  RecalcPercent;
end;

procedure TBaseCSVReader.Close;
begin
  if fOpened then
  begin
    CloseFile(fFile);
    fOpened := False;
    fFileName := '';
    FFileSize := 0;
    FFilePos := 0;
    FFilePosPercent := 0;
    FLineNum := 0;
    fCurrentLine := '';
  end;
end;

{ TStreamReader }

procedure TStreamReader.Close;
begin
  if Assigned(fStream) then
  begin
    fStream.Free;
    fStream := nil;
    fFileName := '';
    FFileSize := 0;
    FFilePos := 0;
    FFilePosPercent := 0;
    FLineNum := 0;
    fCurrentLine := '';

    fPrevStr := '';
    fPrevChar := #0;
    fBufPos := 0;
    fBufSize := 0;
  end;
end;

constructor TStreamReader.Create;
begin

end;

destructor TStreamReader.Destroy;
begin
  Close;

  inherited;
end;

function TStreamReader.GetEof: Boolean;
begin
  Result := ( not Assigned(fStream) ) or
            ( (fStream.Position = fStream.Size) and (fBufSize = 0) );
end;

procedure TStreamReader.Open(const aFileName: string);
begin
  if not FileExists(aFileName) then
    raise Exception.CreateFmt('TStreamReader: ‘айл "%s" не найден', [aFileName]);

  Close; //close previous file if has assigned

  fStream := TFileStream.Create(aFileName, fmOpenRead, fmShareDenyWrite);
  FFileSize := fStream.Size;
  FFilePos := 0;
  FFileName := aFileName;
end;

function TStreamReader.ReadNextMemBlock: Boolean;
begin
  fBufSize := fStream.Read(fBuf, cReadBufSize);
  fBufPos := 0;
  Result := fBufSize > 0;
end;

function TStreamReader.ReadLineFromMem(out aResult: string): Boolean;
var
  aBeg, n2: Cardinal;
  Readed: Cardinal;
  aTmpStr: string;
  aLen: Integer;
//  i: Integer;
begin
  Result := False;

  if (fBufSize = 0) then
    if (not Self.Eof) then
      ReadNextMemBlock
    else
      Exit;

(*
try
  aBeg := fBufPos;
  while fBufPos < fBufSize do
  begin
    if fBuf[fBufPos] = #10 { and (fPrevChar = #13) }then
    begin
      Readed := fBufPos - aBeg;
      SetLength(aResult, Readed);
      System.Move(fBuf[aBeg], aResult[1], Readed - 1);

    //  fPrevChar := fBuf[fBufPos];
      Inc(fBufPos);
      aBeg := fBufPos;
      Exit;
    end;
    //fPrevChar := fBuf[fBufPos];
    Inc(fBufPos);
  end;
  Exit;

finally
  if fBufSize <= fBufPos then
    fBufSize := 0;
end;

*)
  aBeg := fBufPos;
  n2 := fBufPos;
  while True do
  begin
    //вычитали весь текущий буффер
    if fBufSize = 0 then
    begin
      Readed := fBufPos - aBeg;
      aTmpStr := fPrevStr;
      SetLength(fPrevStr, Readed);
      System.Move(fBuf[aBeg], fPrevStr[1], Readed); //запоминаем последний считанный кусок
      if aTmpStr <> '' then
        fPrevStr := aTmpStr + fPrevStr;


      if not ReadNextMemBlock then //конец файла
      begin
        aResult := fPrevStr;
        Break;
      end;
      aBeg := fBufPos;
    end;

    if (fBuf[fBufPos] = #10) then
      n2 := fBufPos;

    if (fBuf[fBufPos] = #10) and (fPrevChar = #13) then
    begin

      Readed := n2 - aBeg;
      if Readed > 1 then
      begin
        SetLength(aResult, Readed - 1);
        System.Move(fBuf[aBeg], aResult[1], Readed - 1);
        if aResult = #13 then
          aResult := '';
      end;

      //добавл€ем остаток вычинанный с предыдущего буфера
      if fPrevStr <> '' then
      begin
        aLen := Length(fPrevStr);
        if fPrevStr[aLen] = #13 then
          aResult := Copy(fPrevStr, 1, aLen - 1) + aResult
        else
          aResult := fPrevStr + aResult;
        fPrevStr := '';
      end;

      fPrevChar := fBuf[fBufPos];
      Dec(fBufSize);
      Inc(fBufPos);
      Break;
    end;
    fPrevChar := fBuf[fBufPos];
    Dec(fBufSize);
    Inc(fBufPos);
  end;
end;

procedure TStreamReader.RecalcPercent;
begin
  if FFileSize = 0 then
    FFilePosPercent := 100
  else
    FFilePosPercent := (FFilePos * 100) div FFileSize;
end;

function TStreamReader.ReturnLine: string;
begin
//  if not Assigned(fStream) then
//    raise Exception.Create('TStreamReader: ‘айл не открыт');

  //Result := '';
  if Self.Eof then
    Exit;

  ReadLineFromMem(Result);
  fCurrentLine := Result;
  FFilePos := fStream.Position - fBufSize;
  Inc(FLineNum);
  RecalcPercent;
end;


{ TCSVReader }

constructor TCSVReader.Create;
begin
  fFieldsDelimitters := [';'];
  fFields := TStringList.Create;
end;

destructor TCSVReader.Destroy;
begin
  fFields.Free;
  inherited;
end;

function TCSVReader.GetFields(Index: Integer): string;
begin
  if (Index >= 0) and (Index < fFields.Count)  then
    Result := fFields[Index]
  else
    Result := '';
end;

function TCSVReader.GetFieldsCount: Integer;
begin
  Result := fFields.Count;
end;

function TCSVReader.GetFieldsData: TStrings;
begin
  Result := fFields;
end;

function TCSVReader.ReturnLine: string;

  function Dos2Ansi(const aStr: string): string;
  begin
    Result := '';
    if aStr = '' then
      Exit;

    SetLength(Result, Length(aStr));
    if not OemToChar(PChar(aStr), PChar(Result)) then
      raise Exception.Create(SysErrorMessage(GetLastError));
  end;

begin
  if FDosToAnsiEncode then
  begin
    Result := Dos2Ansi(inherited ReturnLine);
    fCurrentLine := Result;
  end
  else
    Result := inherited ReturnLine;
  ParseFields;
end;

procedure TCSVReader.SetDosToAnsiEncode(const Value: Boolean);
begin
  FDosToAnsiEncode := Value;
end;

procedure TCSVReader.ParseFields;
var
  i, n1, aLen: Integer;
begin
  fFields.Clear;
  if fCurrentLine = '' then
    Exit;

  aLen := Length(fCurrentLine);
  n1 := 1;
  for i := 1 to aLen do
  begin
    if (fCurrentLine[i] in fFieldsDelimitters) then
    begin
      fFields.Add( Copy(fCurrentLine, n1, i - n1) );
      n1 := i + 1;
    end
    else
      if (i = aLen) then
        fFields.Add( Copy(fCurrentLine, n1, i - n1 + 1) );
  end;
end;

{ TCSVXReader }

constructor TCSVXReader.Create;
begin
  inherited;
  Self.FTitles := TStringList.Create;
end;

destructor TCSVXReader.Destroy;
begin
  Self.FTitles.Free;
  inherited;
end;

function TCSVXReader.GetFieldByIndex(index: integer): string;
begin
  RESULT := inherited Fields[index];
end;

function TCSVXReader.GetFieldbyName(tag: string): string;
var index: integer;
begin
  RESULT := '';
  if Self.Line0Titles then
   begin
     index := Self.FTitles.IndexOf(tag);
     if index<0 then exit;

     if index<Self.FieldsCount then
      RESULT := inherited Fields[index];
   end;
end;

function TCSVXReader.GetLine0Titles: boolean;
begin
  RESULT := Self.FLine0Titles and ((Self.FLineNum=0)or(Self.FTitles.Count>0));
end;

function TCSVXReader.GetTitleLine: string;
begin
  RESULT := Self.FTitles.Text;
end;

function TCSVXReader.GetTitles(Index: Integer): string;
begin
  RESULT:='';
  if (Index<0) or (Index>Self.FTitles.Count-1) then   exit;

  RESULT := Self.FTitles[Index];
end;

function TCSVXReader.GetTitlesCount: integer;
begin
  if Self.Line0Titles then  
    RESULT := Self.FTitles.Count
   else
    RESULT := 0; 
end;

//при открытии заполн€ютс€ заголовки если выставлена опци€
function TCSVXReader.Open(const filename: string): boolean;
begin
  RESULT := False;

  try
        TBaseCSVReader(Self).Open(filename);
  except on E: Exception do
    Exit;
  end;

  if Self.Line0Titles then
   begin
     //Self.FTitles.Delimiter := ';';

     Self.FTitles.Text := StringReplace(Self.ReturnLine, ';', #$D#$A, [rfReplaceAll]);

     if Self.Eof then Self.Close;
   end;
  RESULT := Self.fOpened;
end;

//function TCSVXReader.ReturnLine: string;
//var isLine0:boolean;
//  //Line: string;
//  k: integer;
//begin
//  isLine0 := (Self.Line0Titles) and (Self.FLineNum = 0);
//  RESULT := inherited ReturnLine;
//  if isLine0 then
//   begin
//    Self.ParseFields;
//    //Self.FTitles.Delimiter := ';';
//    Self.FTitles.Text := Self.CurrentLine;
//    RESULT := inherited ReturnLine;
//   end;
//end;

procedure TCSVXReader.SetLine0Titles(const Value: boolean);
begin
  FLine0Titles := Value;
end;

procedure TCSVXReader.SetTitleLine(Line: string);
begin
  Self.FTitles.Text := Line;

  Self.FLine0Titles :=  (Line<>'');
end;

{ TInterfacedCSVXReader }

function TInterfacedCSVFileReader.GetCurFileName: string;
begin
  RESULT := FFileName;
end;

function TInterfacedCSVFileReader.GetCurrentLine: string;
begin
  RESULT := fCurrentLine;
end;

function TInterfacedCSVFileReader.GetLineNum: Cardinal;
begin
  RESULT := FLineNum;
end;

function TInterfacedCSVFileReader.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TInterfacedCSVFileReader._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TInterfacedCSVFileReader._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then
    Destroy;
end;

{ TStreamCSVReader }

procedure TBaseStreamCSVReader.Close;
begin
  if Assigned(fStream) then
  begin
    fStream.Free;
    fStream := nil;
    fFileName := '';
    FFileSize := 0;
    FFilePos := 0;
    FFilePosPercent := 0;
    FLineNum := 0;
    fCurrentLine := '';

    fPrevStr := '';
    fPrevChar := #0;
    fBufPos := 0;
    fBufSize := 0;
  end;
end;

destructor TBaseStreamCSVReader.Destroy;
begin
  Close;
  inherited;
end;

function TBaseStreamCSVReader.GetEof: Boolean;
begin
  Result := ( not Assigned(fStream) ) or
            ( (fStream.Position = fStream.Size) and (fBufSize = 0) );
end;

function TBaseStreamCSVReader.Open(const aStreamName: string): boolean;
var //TryFileName: string;
  StreamAdress: Int64;
begin
{ TODO : open stream or load from file into stream here }
//  if ExtractFilePath(aStreamName)> '' then //equally FileName
//   begin
//     Self.fStream.;
//   end;

  RESULT := False;

  if Assigned(StringStreamsManager) then
   begin
    Self.fStream := StringStreamsManager.GetStreamByTag(aStreamName);
    if Assigned(fStream) then
     begin
      Self.FFileSize := fStream.Size;         
      RESULT := True;
      exit;
     end;
   end;
  

  if TryStrToInt64(aStreamName, StreamAdress) then
    try
      Self.fStream := TStringStream(Pointer(StreamAdress)^);
      Self.FFileSize := fStream.Size;
    except on E: Exception do
      Exit;
    end
   else
    Exit;

  FFilePos := 0;
  FFileName := aStreamName;
  RESULT := True;
end;

procedure TBaseStreamCSVReader.RecalcPercent;
begin
  if FFileSize = 0 then
    FFilePosPercent := 100
  else
    FFilePosPercent := (FFilePos * 100) div FFileSize;
end;

function TBaseStreamCSVReader.ReturnLine: string;
const EOL = #$D#$A;
var p: integer;
begin
  if Self.Eof then
    Exit;
  
  
  p := pos(EOL, copy(fStream.DataString, fStream.Position + 1));
  if p = 0 then
    p := MAXWORD; 
  fCurrentLine := fStream.ReadString(p-1); //ReadLineFromMem(Result);

  if fStream.Position < fStream.Size  then
    fStream.Seek(Length(EOL), soCurrent);
    
  FFilePos := fStream.Position; //!- fBufSize;
  Inc(FLineNum);
  RecalcPercent;

  Result := fCurrentLine;
end;

{ TStreamCSVReader }

constructor TStreamCSVReader.Create;
begin
  fFieldsDelimitters := [';'];
  fFields := TStringList.Create;
end;

destructor TStreamCSVReader.Destroy;
begin
  fFields.Free;
  inherited;
end;

function TStreamCSVReader.GetFields(Index: Integer): string;
begin
  if (Index >= 0) and (Index < fFields.Count)  then
    Result := fFields[Index]
  else
    Result := '';
end;

function TStreamCSVReader.GetFieldsCount: Integer;
begin
  Result := fFields.Count;
end;

function TStreamCSVReader.GetFieldsData: TStrings;
begin
  Result := fFields;
end;

procedure TStreamCSVReader.ParseFields;
var
  i, n1, aLen: Integer;
begin
  fFields.Clear;
  if fCurrentLine = '' then
    Exit;

  aLen := Length(fCurrentLine);
  n1 := 1;
  for i := 1 to aLen do
  begin
    if (fCurrentLine[i] in fFieldsDelimitters) then
    begin
      fFields.Add( Copy(fCurrentLine, n1, i - n1) );
      n1 := i + 1;
    end
    else
      if (i = aLen) then
        fFields.Add( Copy(fCurrentLine, n1, i - n1 + 1) );
  end;
end;

function TStreamCSVReader.ReturnLine: string;

  function Dos2Ansi(const aStr: string): string;
  begin
    Result := '';
    if aStr = '' then
      Exit;

    SetLength(Result, Length(aStr));
    if not OemToChar(PChar(aStr), PChar(Result)) then
      raise Exception.Create(SysErrorMessage(GetLastError));
  end;

begin
  if FDosToAnsiEncode then
  begin
    Result := Dos2Ansi(inherited ReturnLine);
    fCurrentLine := Result;
  end
  else
    Result := inherited ReturnLine;
  ParseFields;
end;

procedure TStreamCSVReader.SetDosToAnsiEncode(const Value: Boolean);
begin
  FDosToAnsiEncode := Value;
end;

{ TStreamCSVXReader }

constructor TStreamCSVXReader.Create;
begin
  inherited;
  Self.FTitles := TStringList.Create;
end;

destructor TStreamCSVXReader.Destroy;
begin
  Self.FTitles.Free;
  inherited;
end;

function TStreamCSVXReader.GetFieldByIndex(index: integer): string;
begin
  RESULT := inherited Fields[index];
end;

function TStreamCSVXReader.GetFieldbyName(tag: string): string;
var index: integer;
begin
  RESULT := '';
  if Self.Line0Titles then
   begin
     index := Self.FTitles.IndexOf(tag);
     if index<0 then exit;

     if index<Self.FieldsCount then
      RESULT := inherited Fields[index];
   end;
end;

function TStreamCSVXReader.GetLine0Titles: boolean;
begin
  RESULT := Self.FLine0Titles and ((Self.FLineNum=0)or(Self.FTitles.Count>0));
end;

function TStreamCSVXReader.GetTitleLine: string;
begin
  RESULT := Self.FTitles.Text;
end;

function TStreamCSVXReader.GetTitles(Index: Integer): string;
begin
  RESULT:='';
  if (Index<0) or (Index>Self.FTitles.Count-1) then   exit;

  RESULT := Self.FTitles[Index];
end;
  
function TStreamCSVXReader.GetTitlesCount: integer;
begin
  if Self.Line0Titles then  
    RESULT := Self.FTitles.Count
   else
    RESULT := 0;
end;

function TStreamCSVXReader.Open(const streamaddr: string): boolean;
var Opened: boolean;
begin
  Opened := inherited Open(streamaddr);
  if Self.Line0Titles then
   begin
     Self.FTitles.Text := StringReplace(Self.ReturnLine, ';', #$D#$A, [rfReplaceAll]);
     if Self.Eof then Self.Close;
   end;
  RESULT := Opened;
end;

procedure TStreamCSVXReader.SetLine0Titles(const Value: boolean);
begin
  FLine0Titles := Value;
end;

procedure TStreamCSVXReader.SetTitleLine(Line: string);
begin
  Self.FTitles.Text := Line;

  Self.FLine0Titles :=  (Line<>'');
end;

{ TInterfacedCSVStreamReader }

function TInterfacedCSVStreamReader.GetCurFileName: string;
begin
  RESULT := FFileName;
end;

function TInterfacedCSVStreamReader.GetCurrentLine: string;
begin
  RESULT := fCurrentLine;
end;

function TInterfacedCSVStreamReader.GetLineNum: Cardinal;
begin
  RESULT := FLineNum;
end;

function TInterfacedCSVStreamReader.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TInterfacedCSVStreamReader._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TInterfacedCSVStreamReader._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then
    Destroy;
end;

{ TCSVStreamsManager }

class function TCSVStreamsManager.addr2pointer(addr: string): pointer;
var DecAddr: Int64;
begin
  RESULT := nil;
  if addr[1] <> '@' then
    exit;

  if TryStrToInt64(copy(addr, 2), DecAddr) then
    RESULT := pointer(DecAddr);
end;

procedure TCSVStreamsManager.Assign(var p: pointer; address: string);
begin
  p := Self.addr2pointer(address);
end;

procedure TCSVStreamsManager.Assign(var id: integer; streamname: string);
begin
  Self.StreamTag := streamname;

  id := Self.StreamsPool.IndexOf(Self.StreamTag);
  if id < 0 then
    id := Self.StreamsPool.Count;
end;

constructor TCSVStreamsManager.Create;
begin
  Self.StreamsPool := TStringList.Create;
  Self.Lines := TStringLIst.Create;
end;

destructor TCSVStreamsManager.Destroy;
var k: integer;
begin
  Self.Lines.Free;
  for k := 0 to Self.StreamsPool.Count - 1 do
    if Assigned(Self.StreamsPool.Objects[k]) then
      (Self.StreamsPool.Objects[k] as TStringStream).Free;
    
  Self.StreamsPool.Free;
  inherited;
end;

procedure TCSVStreamsManager.Finit(id: integer);
begin
  Self.Stream := TStringStream.Create(Self.Lines.Text);
  Self.StreamsPool.Objects[id] := Self.Stream;
end;

function TCSVStreamsManager.GetStreamByTag(Tag: string): TStringStream;
var k: integer;
begin
  RESULT := nil;
  k:= Self.StreamsPool.IndexOf(Tag);
  if k<0 then exit;

  RESULT := TStringStream(Self.StreamsPool.Objects[k]);
  
end;

procedure TCSVStreamsManager.Finit(p: pointer);
begin

  Self.Stream := TStringStream.Create(Self.Lines.Text);
  Self.StreamsList[index] := @Self.Stream;
  Self.Streams.UnlockList;
end;

class function TCSVStreamsManager.pointer2addr(p: pointer): string;
begin
  RESULT := '';
  if Assigned(p) then
    RESULT := Concat('@', IntToStr(Int64(p)));
end;

procedure TCSVStreamsManager.Rewrite(id: Integer);
begin
  Self.Lines.Clear;
//  if Self.StreamNames.Count > id then
//   begin
//    exit;
//    if Assigned(Self.StreamNames.Objects[id]) then
//      (TStringStream(Self.StreamNames.Objects[id])).Free;      
//   end;

  if Self.StreamsPool.Count = id then
   Self.StreamsPool.Add(Self.StreamTag);//(Self.StreamTag, nil);
end;

procedure TCSVStreamsManager.Rewrite(p: pointer);
begin
  Self.Lines.Clear;
  StreamsList :=  Self.Streams.LockList;

  index := StreamsList.IndexOf(p);
  if index < 0 then exit;
    try
      Self.Stream := TStringStream(p^);
      FreeAndNil(Self.Stream);
    except on E: Exception do

    end;

end;

procedure TCSVStreamsManager.writeln(p: pointer; line: string);
begin
  Self.Lines.Add(line);
end;

procedure TCSVStreamsManager.writeln(id: integer; line: string);
begin
  Self.Lines.Add(line);
end;
initialization
  StringStreamsManager := TCSVStreamsManager.Create;
finalization
    StringStreamsManager.Free;  
end.
