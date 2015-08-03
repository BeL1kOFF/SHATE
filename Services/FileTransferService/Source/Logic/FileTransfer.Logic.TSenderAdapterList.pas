unit FileTransfer.Logic.TSenderAdapterList;

interface

uses
  System.Generics.Collections,
  Data.Win.ADODB,
  FileTransfer.Logic.TDBQuery,
  FileTransfer.Logic.TThreadAdapter;

type
  TSenderAdapterList = class(TDBQuery)
  private
    FItems: TList<TThreadAdapter>;
    procedure DllScan;
    procedure FreeItems;
    procedure FreeThread;
    procedure Terminate;
    procedure UnRegistredAdapters;
    procedure WaitTerminate;
  public
    constructor Create(aADOConnection: TADOConnection); override;
    destructor Destroy; override;
    procedure Continue;
    procedure Pause;
    procedure Refresh;
  end;

implementation

uses
  System.SysUtils,
  FileTransfer.Logic.TFileLogger,
  FileTransfer.Logic.TDllScan,
  FileTransfer.Logic.TCustomSenderAdapter;

const
  PROC_SEL_PROCESSING = 'sel_processing';
  PROC_TP_UNREGISTREDADAPTER = 'tp_unregistredadapter';

  FLD_ID_TRANSPORTPROTOCOL = 'Id_TransportProtocol';
  FLD_ID_PROCESSINGSENDER = 'Id_ProcessingSender';
  FLD_INTERVAL = 'Interval';
  FLD_NAME = 'Name';
  FLD_SUCCESSDIRECTORY = 'SuccessDirectory';
  FLD_ERRORDIRECTORY = 'ErrorDirectory';
  FLD_PARTDIRECTORY = 'PartDirectory';
  FLD_ISDELETESUCCESS = 'IsDeleteSuccess';
  FLD_ISDELETEERROR = 'IsDeleteError';
  FLD_ISDELETEPART = 'IsDeletePart';
  FLD_MASKFILE = 'MaskFile';
  FLD_MASKFILEEXCLUDED = 'MaskFileExcluded';
  FLD_ORDER = 'Order';
  FLD_GUID = 'Guid';
  FLD_TASKNAME = 'TaskName';
  FLD_ID_TASK = 'Id_Task';

resourcestring
  rsCountBeginThread = 'Кол-во запущенных нитей: ';

{ TSenderAdapterList }

procedure TSenderAdapterList.Continue;
var
  k: Integer;
begin
  for k := 0 to FItems.Count - 1 do
    FItems.Items[k].Continue();
end;

constructor TSenderAdapterList.Create(aADOConnection: TADOConnection);
begin
  inherited Create(aADOConnection);
  FItems := TList<TThreadAdapter>.Create();
end;

destructor TSenderAdapterList.Destroy;
begin
  FreeItems();
  FItems.Free();
  inherited Destroy();
end;

procedure TSenderAdapterList.DllScan;
begin
  UnRegistredAdapters();
  TDllScan.Scan();
  TDllScan.RegisterAdapter(ADOConnection);
end;

procedure TSenderAdapterList.FreeItems;
begin
  Terminate();
  WaitTerminate();
  FreeThread();
  FItems.Clear();
end;

procedure TSenderAdapterList.FreeThread;
var
  k: Integer;
begin
  for k := 0 to FItems.Count - 1 do
    FItems.Items[k].Free();
end;

procedure TSenderAdapterList.Pause;
var
  k: Integer;
begin
  for k := 0 to FItems.Count - 1 do
    FItems.Items[k].Pause();
end;

procedure TSenderAdapterList.Refresh;
var
  threadAdapter: TThreadAdapter;
begin
  FreeItems();
  DllScan();
  QueryClose();
  ADOQuery.SQL.Text := PROC_SEL_PROCESSING;
  try
    ADOQuery.Open();
    ADOQuery.First();
    while not ADOQuery.Eof do
    begin
      threadAdapter := TThreadAdapter.Create(ADOConnection);
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).SenderAdapter :=
        TDllScan.GetSenderClass(ADOQuery.FieldByName(FLD_GUID).AsString);
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).Id_ProcessingSender :=
        ADOQuery.FieldByName(FLD_ID_PROCESSINGSENDER).AsInteger;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).Interval := ADOQuery.FieldByName(FLD_INTERVAL).AsInteger;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).Name := ADOQuery.FieldByName(FLD_NAME).AsString;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).SuccessDirectory :=
        ADOQuery.FieldByName(FLD_SUCCESSDIRECTORY).AsString;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).ErrorDirectory :=
        ADOQuery.FieldByName(FLD_ERRORDIRECTORY).AsString;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).PartDirectory :=
        ADOQuery.FieldByName(FLD_PARTDIRECTORY).AsString;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).IsDeleteSuccess := ADOQuery.FieldByName(FLD_ISDELETESUCCESS).AsBoolean;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).IsDeleteError := ADOQuery.FieldByName(FLD_ISDELETEERROR).AsBoolean;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).IsDeletePart := ADOQuery.FieldByName(FLD_ISDELETEPART).AsBoolean;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).MaskFile := ADOQuery.FieldByName(FLD_MASKFILE).AsString;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).MaskFileExcluded := ADOQuery.FieldByName(FLD_MASKFILEEXCLUDED).AsString;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).Order := ADOQuery.FieldByName(FLD_ORDER).AsInteger;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).TaskName := ADOQuery.FieldByName(FLD_TASKNAME).AsString;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).Id_Task := ADOQuery.FieldByName(FLD_ID_TASK).AsInteger;
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).ParseMaskFile();
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).ParseMaskExcludedFile();
      TCustomSenderAdapter(threadAdapter.CustomSenderAdapter).LoadAdapter();

      threadAdapter.Start();
      FItems.Add(threadAdapter);
      ADOQuery.Next();
    end;
  finally
    QueryClose();
  end;
  TFileLogger.Write(rsCountBeginThread + IntToStr(FItems.Count));
end;

procedure TSenderAdapterList.Terminate;
var
  k: Integer;
begin
  for k := 0 to FItems.Count - 1 do
    FItems.Items[k].Terminate();
end;

procedure TSenderAdapterList.UnRegistredAdapters;
begin
  QueryClose();
  ADOQuery.SQL.Text := PROC_TP_UNREGISTREDADAPTER;
  try
    ADOQuery.ExecSQL;
  finally
    QueryClose;
  end;
end;

procedure TSenderAdapterList.WaitTerminate;
var
  k: Integer;
begin
  for k := 0 to FItems.Count - 1 do
    if Assigned(FItems.Items[k]) then
      FItems.Items[k].WaitFor();
end;

end.
