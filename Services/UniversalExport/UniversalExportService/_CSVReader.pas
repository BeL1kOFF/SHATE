unit _CSVReader;

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

implementation

uses
  Windows;
  
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
    raise Exception.CreateFmt('TBaseCSVReader: Файл "%s" не найден', [aFileName]);

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
    raise Exception.Create('TBaseCSVReader: Файл не открыт');

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
    raise Exception.CreateFmt('TStreamReader: Файл "%s" не найден', [aFileName]);

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
  i: Integer;
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

      //добавляем остаток вычинанный с предыдущего буфера
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
//    raise Exception.Create('TStreamReader: Файл не открыт');

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

end.
