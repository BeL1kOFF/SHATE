unit FileTransfer.Logic.TReceiverAdapterList;

interface

uses
  System.SysUtils,
  Data.Win.ADODB,
  System.Generics.Collections,
  Package.CustomInterface.ICustomSenderAdapter,
  Package.CustomInterface.ICustomReceiverAdapter,
  FileTransfer.Logic.TDBQuery;

type
  TReceiverAdapterList = class(TDBQuery)
  private
    FItems: TList<ICustomReceiverAdapter>;
    procedure FreeItems;
  public
    constructor Create(aADOConnection: TADOConnection); override;
    destructor Destroy; override;
    function Execute(const aSenderFileName: string; const aBuffer: TBytes): TResultReceiver;
    procedure Refresh(aId_ProcessingSender: Integer);
  end;

implementation

uses
  FileTransfer.Logic.TDllScan,
  FileTransfer.Logic.TCustomReceiverAdapter;

const
  PROC_SEL_RECEIVERLIST     = 'sel_receiverlist :Id_ProcessingSender';

  PARAM_ID_PROCESSINGSENDER = 'Id_ProcessingSender';

  FLD_ID_TRANSPORTPROTOCOL  = 'Id_TransportProtocol';
  FLD_NAME                  = 'Name';
  FLD_ISOVERWRITE           = 'IsOverwrite';
  FLD_ISUSETEMPFILE         = 'IsUseTempFile';
  FLD_RETRYERROR            = 'RetryError';
  FLD_ID_PROCESSINGRECEIVER = 'Id_ProcessingReceiver';
  FLD_FILENAME              = 'FileName';
  FLD_GUID                  = 'Guid';
  FLD_SENDERNAME            = 'SenderName';
  FLD_TASKNAME              = 'TaskName';
  FLD_ID_TASK               = 'Id_Task';
  FLD_ID_PROCESSINGSENDER   = 'Id_ProcessingSender';

{ TReceiverAdapterList }

constructor TReceiverAdapterList.Create(aADOConnection: TADOConnection);
begin
  inherited Create(aADOConnection);
  FItems := TList<ICustomReceiverAdapter>.Create();
end;

destructor TReceiverAdapterList.Destroy;
begin
  FreeItems();
  FItems.Free();
  inherited Destroy();
end;

function TReceiverAdapterList.Execute(const aSenderFileName: string; const aBuffer: TBytes): TResultReceiver;
var
  k: Integer;
begin
  Result := rrNone;
  for k := 0 to FItems.Count - 1 do
  begin
    if TCustomReceiverAdapter(FItems.Items[k]).Execute(aSenderFileName, aBuffer) then
      case Result of
      rrNone:
        Result := rrSuccess;
      rrError:
        Result := rrPartly;
      end
    else
      case Result of
      rrNone:
        Result := rrError;
      rrSuccess:
        Result := rrPartly;
      end;
  end;
end;

procedure TReceiverAdapterList.FreeItems;
var
  k: Integer;
begin
  for k := 0 to FItems.Count - 1 do
  begin
    TCustomReceiverAdapter(FItems.Items[k]).FinalizeAdapter();
    FItems.Items[k] := nil;
  end;
  FItems.Clear();
end;

procedure TReceiverAdapterList.Refresh(aId_ProcessingSender: Integer);
var
  receiverAdapter: ICustomReceiverAdapter;
begin
  FreeItems();
  QueryClose();
  ADOQuery.SQL.Text := PROC_SEL_RECEIVERLIST;
  ADOQuery.Parameters.ParamValues[PARAM_ID_PROCESSINGSENDER] := aId_ProcessingSender;
  try
    ADOQuery.Open();
    ADOQuery.First();
    while not ADOQuery.Eof do
    begin
      receiverAdapter := TCustomReceiverAdapter.Create(ADOConnection);
      TCustomReceiverAdapter(receiverAdapter).ReceiverAdapter :=
        TDLLScan.GetReceiverClass(ADOQuery.FieldByName(FLD_GUID).AsString);
      TCustomReceiverAdapter(receiverAdapter).Name := ADOQuery.FieldByName(FLD_NAME).AsString;
      TCustomReceiverAdapter(receiverAdapter).IsOverwrite := ADOQuery.FieldByName(FLD_ISOVERWRITE).AsBoolean;
      TCustomReceiverAdapter(receiverAdapter).IsUseTempFile := ADOQuery.FieldByName(FLD_ISUSETEMPFILE).AsBoolean;
      TCustomReceiverAdapter(receiverAdapter).RetryError := ADOQuery.FieldByName(FLD_RETRYERROR).AsInteger;
      TCustomReceiverAdapter(receiverAdapter).Id_ProcessingReceiver :=
        ADOQuery.FieldByName(FLD_ID_PROCESSINGRECEIVER).AsInteger;
      TCustomReceiverAdapter(receiverAdapter).FileName := ADOQuery.FieldByName(FLD_FILENAME).AsString;
      TCustomReceiverAdapter(receiverAdapter).SenderName := ADOQuery.FieldByName(FLD_SENDERNAME).AsString;
      TCustomReceiverAdapter(receiverAdapter).TaskName := ADOQuery.FieldByName(FLD_TASKNAME).AsString;
      TCustomReceiverAdapter(receiverAdapter).Id_Task := ADOQuery.FieldByName(FLD_ID_TASK).AsInteger;
      TCustomReceiverAdapter(receiverAdapter).Id_ProcessingSender :=
        ADOQuery.FieldByName(FLD_ID_PROCESSINGSENDER).AsInteger;
      TCustomReceiverAdapter(receiverAdapter).LoadAdapter();
      FItems.Add(receiverAdapter);
      ADOQuery.Next();
    end;
  finally
    QueryClose();
  end;
end;

end.
