unit ERPService.Logic.TFileLogger;

interface

uses
  System.Classes;

type
  TFileLogger = class
  private
    FIsFileRename: Boolean;
    FFileExt: string;
    FFileName: string;
    FPath: string;
    FFileStream: TFileStream;
    function GetFullFileName: string;
    procedure FileClose;
    procedure FileOpen;
    procedure StartMove;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    procedure WriteLog(const aText: string);
    property IsFileRename: Boolean read FIsFileRename write FIsFileRename;
    property FileExt: string read FFileExt write FFileExt;
    property FileName: string read FFileName write FFileName;
    property Path: string read FPath write FPath;
  end;

implementation

uses
  System.IOUtils,
  System.SysUtils;

{ TFileLogger }

constructor TFileLogger.Create;
begin
  FIsFileRename := False;
  FFileExt := 'log';
  FFileName := TFileLogger.ClassName;
  FPath := ExtractFilePath(ParamStr(0));
end;

destructor TFileLogger.Destroy;
begin
  inherited Destroy();
end;

function TFileLogger.GetFullFileName: string;
begin
  Result := Format('%s%s.%s', [IncludeTrailingPathDelimiter(FPath), FFileName, FFileExt]);
end;

procedure TFileLogger.FileClose;
begin
  if Assigned(FFileStream) then
    FFileStream.Free();
end;

procedure TFileLogger.FileOpen;
begin
  if not TFile.Exists(GetFullFileName()) then
    FFileStream := TFile.Create(GetFullFileName())
  else
    FFileStream := TFile.OpenWrite(GetFullFileName());
  FFileStream.Seek(0, soEnd);
end;

procedure TFileLogger.Init;
begin
  if FIsFileRename then
    StartMove();
end;

procedure TFileLogger.StartMove;
var
  DestFileName: string;
begin
  if TFile.Exists(GetFullFileName()) then
  begin
    DestFileName := Format('%s%s %s.%s', [IncludeTrailingPathDelimiter(FPath), FFileName, FormatDateTime('yyyy.mm.dd hh.nn.ss', Now()), FFileExt]);
    TFile.Move(GetFullFileName(), DestFileName);
  end;
end;

procedure TFileLogger.WriteLog(const aText: string);
var
  Buffer: TBytes;
begin
  FileOpen();
  try
    Buffer := BytesOf(Format('%s: %s%s', [FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz', Now()), aText, #13#10]));
    FFileStream.WriteBuffer(Buffer[0], Length(Buffer));
  finally
    FileClose();
  end;
end;

end.
