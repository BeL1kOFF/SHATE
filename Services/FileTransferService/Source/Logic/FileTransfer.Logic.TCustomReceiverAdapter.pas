unit FileTransfer.Logic.TCustomReceiverAdapter;

interface

uses
  System.SysUtils,
  Data.Win.ADODB,
  Package.CustomInterface.ICustomReceiverAdapter,
  Package.CustomInterface.IReceiverAdapter,
  FileTransfer.Logic.TDBQuery;

type
  TOnFileLogger = procedure(aText: PChar);

  TCustomReceiverAdapter = class(TInterfacedObject, ICustomReceiverAdapter)
  private
    FSenderName: string;
    FId_Task: Integer;
    FTaskName: string;
    FName: string;
    FIsOverwrite: Boolean;
    FIsUseTempFile: Boolean;
    FRetryError: Integer;
    FId_ProcessingReceiver: Integer;
    FId_ProcessingSender: Integer;
    FFileName: string;

    FQuery: TDBQuery;

    FReceiverAdapter: IReceiverAdapter;
    function GetId_ProcessingReceiver: Integer;
    function GetIsOverwrite: Boolean;
    function GetIsUseTempFile: Boolean;
    function GetRetryError: Integer;
    function GetQuery: TADOQuery;
    function GetParseFileName(aSenderFileName: PChar; var aBuffer; aSizeBuffer: Integer): Integer;
    procedure LogWrite(aMessage: PChar);
  public
    constructor Create(aADOConnection: TADOConnection);
    destructor Destroy; override;
    function Execute(const aSenderFileName: string; const aBuffer: TBytes): Boolean;
    procedure FinalizeAdapter;
    procedure LoadAdapter;

    property Id_ProcessingReceiver: Integer read FId_ProcessingReceiver write FId_ProcessingReceiver;
    property Id_ProcessingSender: Integer read FId_ProcessingSender write FId_ProcessingSender;
    property Name: string read FName write FName;
    property IsOverwrite: Boolean read FIsOverwrite write FIsOverwrite;
    property IsUseTempFile: Boolean read FIsUseTempFile write FIsUseTempFile;
    property FileName: string read FFileName write FFileName;
    property SenderName: string read FSenderName write FSenderName;
    property TaskName: string read FTaskName write FTaskName;
    property Id_Task: Integer read FId_Task write FId_Task;
    property RetryError: Integer read GetRetryError write FRetryError;

    property ReceiverAdapter: IReceiverAdapter read FReceiverAdapter write FReceiverAdapter;
  end;

implementation

uses
  FileTransfer.Logic.TFileLogger;

const
  COMMAND_FILENAME = ':FN';
  COMMAND_TIME = ':TIME';
  COMMAND_GUID = ':GUID';

  CHARS_SEPARATE_LOGMESSAGE = ': ';

{ TCustomReceiverAdapter }

constructor TCustomReceiverAdapter.Create(aADOConnection: TADOConnection);
begin
  FQuery := TDBQuery.Create(aADOConnection);
end;

destructor TCustomReceiverAdapter.Destroy;
begin
  FQuery.Free();
  FReceiverAdapter := nil;
  inherited Destroy();
end;

function TCustomReceiverAdapter.Execute(const aSenderFileName: string;
  const aBuffer: TBytes): Boolean;
var
  countError: Integer;
begin
  LogWrite(PChar('Получено управление от ' + FSenderName));
  countError := 1;
  Repeat
    if countError > 1 then
      LogWrite(PChar(Format('Ошибка Receiver адаптера. Попытка %d из %d', [countError, FRetryError])));
    Result := FReceiverAdapter.Execute(PChar(aSenderFileName), aBuffer);
    if not Result then
      Inc(countError);
  Until (Result) or (countError > FRetryError);
end;

procedure TCustomReceiverAdapter.FinalizeAdapter;
begin
  FReceiverAdapter.FinalizeAdapter();
end;

function TCustomReceiverAdapter.GetId_ProcessingReceiver: Integer;
begin
  Result := FId_ProcessingReceiver;
end;

function TCustomReceiverAdapter.GetIsOverwrite: Boolean;
begin
  Result := FIsOverwrite;
end;

function TCustomReceiverAdapter.GetIsUseTempFile: Boolean;
begin
  Result := FIsUseTempFile;
end;

function TCustomReceiverAdapter.GetParseFileName(aSenderFileName: PChar; var aBuffer; aSizeBuffer: Integer): Integer;
var
  tmpGUID: TGUID;
  tmpStr: string;
  size: Integer;
begin
  tmpStr := StringReplace(FileName, COMMAND_FILENAME, ChangeFileExt(aSenderFileName, ''), [rfReplaceAll, rfIgnoreCase]);
  tmpStr := StringReplace(tmpStr, COMMAND_TIME, TimeToStr(Now()), [rfReplaceAll, rfIgnoreCase]);
  CreateGUID(tmpGUID);
  tmpStr := StringReplace(tmpStr, COMMAND_GUID, GUIDToString(tmpGUID), [rfReplaceAll, rfIgnoreCase]);
  tmpStr := StringReplace(tmpStr, ':', ' ', [rfReplaceAll, rfIgnoreCase]);
  tmpStr := tmpStr + ExtractFileExt(aSenderFileName);
  if aSizeBuffer < Length(tmpStr) * StringElementSize(tmpStr) then
    size := aSizeBuffer
  else
    size := Length(tmpStr) * StringElementSize(tmpStr);
  Move(PChar(tmpStr)^, aBuffer, size);
  Result := size;
end;

function TCustomReceiverAdapter.GetQuery: TADOQuery;
begin
  Result := FQuery.ADOQuery;
end;

function TCustomReceiverAdapter.GetRetryError: Integer;
begin
  Result := FRetryError;
end;

procedure TCustomReceiverAdapter.LoadAdapter;
begin
  FReceiverAdapter.InitAdapter(Self);
  FReceiverAdapter.LoadAdapter();
end;

procedure TCustomReceiverAdapter.LogWrite(aMessage: PChar);
begin
  TFileLogger.Write(FId_Task, FTaskName, FId_ProcessingSender, FSenderName, FId_ProcessingReceiver, FName, aMessage);
end;

end.
