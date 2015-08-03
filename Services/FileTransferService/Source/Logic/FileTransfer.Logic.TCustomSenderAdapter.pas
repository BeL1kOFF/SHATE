unit FileTransfer.Logic.TCustomSenderAdapter;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.Win.ADODB,
  Package.CustomInterface.ICustomSenderAdapter,
  Package.CustomInterface.ISenderAdapter,
  FileTransfer.Logic.TDBQuery,
  FileTransfer.Logic.TReceiverAdapterList;

type
  TCustomSenderAdapter = class(TInterfacedObject, ICustomSenderAdapter)
  private
    FId_ProcessingSender: Integer;
    FName: string;
    FInterval: Integer;
    FSuccessDirectory: string;
    FErrorDirectory: string;
    FPartDirectory: string;
    FIsDeleteSuccess: Boolean;
    FIsDeleteError: Boolean;
    FIsDeletePart: Boolean;
    FMaskFile: string;
    FMaskFileExcluded: string;
    FOrder: Integer;
    FTaskName: string;
    FId_Task: Integer;
    FMaskList: TStringList;
    FMaskExcludedList: TStringList;

    FReceiverAdapterList: TReceiverAdapterList;

    FResultReceiver: TResultReceiver;
    FBuffer: TBytes;

    FQuery: TDBQuery;

    FSenderAdapter: ISenderAdapter;

    function GetBuffer: TBytes;
    function GetResultReceiver: TResultReceiver;
    function GetSuccessDirectory: PChar;
    function GetErrorDirectory: PChar;
    function GetPartDirectory: PChar;
    function GetIsDeleteSuccess: Boolean;
    function GetIsDeleteError: Boolean;
    function GetIsDeletePart: Boolean;
    function GetOrder: Integer;

    function GetId_ProcessingSender: Integer;
    function GetQuery: TADOQuery;
    procedure SetBuffer(const aValue: TBytes);

    function InMaskList(aFileName: PChar): Boolean;
    procedure LoadReceiverAdapter;
    procedure ReceiverExecute(aSenderFileName: PChar);
  public
    constructor Create(aADOConnection: TADOConnection);
    destructor Destroy; override;
    procedure BeginExecute;
    procedure FinalizeAdapter;
    procedure LoadAdapter;
    procedure LogWrite(aMessage: PChar);
    procedure ParseMaskFile;
    procedure ParseMaskExcludedFile;

    property Id_ProcessingSender: Integer read FId_ProcessingSender write FId_ProcessingSender;
    property Name: string read FName write FName;
    property Interval: Integer read FInterval write FInterval;
    property SuccessDirectory: string read FSuccessDirectory write FSuccessDirectory;
    property ErrorDirectory: string read FErrorDirectory write FErrorDirectory;
    property PartDirectory: string read FPartDirectory write FPartDirectory;
    property IsDeleteSuccess: Boolean read GetIsDeleteSuccess write FIsDeleteSuccess;
    property IsDeleteError: Boolean read GetIsDeleteError write FIsDeleteError;
    property IsDeletePart: Boolean read GetIsDeletePart write FIsDeletePart;
    property MaskFile: string read FMaskFile write FMaskFile;
    property MaskFileExcluded: string read FMaskFileExcluded write FMaskFileExcluded;
    property Order: Integer read GetOrder write FOrder;
    property TaskName: string read FTaskName write FTaskName;
    property Id_Task: Integer read FId_Task write FId_Task;

    property SenderAdapter: ISenderAdapter read FSenderAdapter write FSenderAdapter;
  end;

implementation

uses
  System.Masks,
  FileTransfer.Logic.TFileLogger;

const
  CHAR_DELIMITER_MASK = ';';
  CHARS_SEPARATE_LOGMESSAGE = ': ';

resourcestring
  rsBeginExecuteThread = 'Начало выполнения нити';
  rsEndExecuteThread = 'Окончание выполнения нити';

{ TCustomSenderAdapter }

procedure TCustomSenderAdapter.BeginExecute;
begin
  LogWrite(PChar(rsBeginExecuteThread));
  FResultReceiver := rrNone;
  FSenderAdapter.BeginSenderExecute();
  LogWrite(PChar(rsEndExecuteThread));
end;

constructor TCustomSenderAdapter.Create(aADOConnection: TADOConnection);
begin
  FQuery := TDBQuery.Create(aADOConnection);
  FMaskList := TStringList.Create();
  FMaskExcludedList := TStringList.Create();
  FReceiverAdapterList := TReceiverAdapterList.Create(aADOConnection);
end;

destructor TCustomSenderAdapter.Destroy;
begin
  FReceiverAdapterList.Free();
  FMaskExcludedList.Free();
  FMaskList.Free();
  FQuery.Free();
  FSenderAdapter := nil;
  inherited Destroy();
end;

procedure TCustomSenderAdapter.FinalizeAdapter;
begin
  FSenderAdapter.FinalizeAdapter();
end;

function TCustomSenderAdapter.GetBuffer: TBytes;
begin
  Result := FBuffer;
end;

function TCustomSenderAdapter.GetErrorDirectory: PChar;
begin
  Result := PChar(FErrorDirectory);
end;

function TCustomSenderAdapter.GetId_ProcessingSender: Integer;
begin
  Result := FId_ProcessingSender;
end;

function TCustomSenderAdapter.GetIsDeleteError: Boolean;
begin
  Result := FIsDeleteError;
end;

function TCustomSenderAdapter.GetIsDeletePart: Boolean;
begin
  Result := FIsDeletePart
end;

function TCustomSenderAdapter.GetIsDeleteSuccess: Boolean;
begin
  Result := FIsDeleteSuccess;
end;

function TCustomSenderAdapter.GetOrder: Integer;
begin
  Result := FOrder;
end;

function TCustomSenderAdapter.GetPartDirectory: PChar;
begin
  Result := PChar(FPartDirectory);
end;

function TCustomSenderAdapter.GetQuery: TADOQuery;
begin
  Result := FQuery.ADOQuery;
end;

function TCustomSenderAdapter.GetResultReceiver: TResultReceiver;
begin
  Result := FResultReceiver;
end;

function TCustomSenderAdapter.GetSuccessDirectory: PChar;
begin
  Result := PChar(FSuccessDirectory);
end;

function TCustomSenderAdapter.InMaskList(aFileName: PChar): Boolean;
var
  k: Integer;
begin
  Result := False;
  for k := 0 to FMaskList.Count - 1 do
    if MatchesMask(aFileName, FMaskList.Strings[k]) then
    begin
      Result := True;
      Break;
    end;
  if Result then
    for k := 0 to FMaskExcludedList.Count - 1 do
      if MatchesMask(aFileName, FMaskExcludedList.Strings[k]) then
      begin
        Result := False;
        Break;
      end;
end;

procedure TCustomSenderAdapter.LoadAdapter;
begin
  FSenderAdapter.InitAdapter(Self);
  FSenderAdapter.LoadSenderAdapter();
  LoadReceiverAdapter();
end;

procedure TCustomSenderAdapter.LoadReceiverAdapter;
begin
  FReceiverAdapterList.Refresh(FId_ProcessingSender);
end;

procedure TCustomSenderAdapter.LogWrite(aMessage: PChar);
begin
  TFileLogger.Write(FId_Task, FTaskName, FId_ProcessingSender, FName, -1, '', aMessage);
end;

procedure TCustomSenderAdapter.ParseMaskExcludedFile;
begin
  FMaskExcludedList.Clear();
  FMaskExcludedList.Delimiter := CHAR_DELIMITER_MASK;
  FMaskExcludedList.DelimitedText := FMaskFileExcluded;
end;

procedure TCustomSenderAdapter.ParseMaskFile;
begin
  FMaskList.Clear();
  FMaskList.Delimiter := CHAR_DELIMITER_MASK;
  FMaskList.DelimitedText := FMaskFile;
end;

procedure TCustomSenderAdapter.ReceiverExecute(aSenderFileName: PChar);
begin
  FResultReceiver := FReceiverAdapterList.Execute(aSenderFileName, FBuffer);
end;

procedure TCustomSenderAdapter.SetBuffer(const aValue: TBytes);
begin
  SetLength(FBuffer, Length(aValue));
  Move(Pointer(aValue)^, Pointer(FBuffer)^, Length(aValue));
end;

end.
