unit _Task_GetRates;

interface

uses
  _ScheduledTask, Classes, StdCtrls, IdTCPClient, BSStrUt, SyncObjs;

type
  TRatesTaskData = record
    Host1: string;
    Port1: Integer;

    Host2: string;
    Port2: Integer;

    Host3: string;
    Port3: Integer;
  end;


  TTaskRates = class(TCommonTask)
  private
    fData: TRatesTaskData;
    fDataAssigned: Boolean;
    RatesList: TStringList;
  protected
    function InitThread(aThread: TCommonTaskThread): Boolean; override;   //перед запуском потока
    procedure DoWorkThreadTerminate(aThread: TCommonTaskThread); override;//после завершения потока (еще не разрушен)
  public
    constructor Create; override;
    destructor Destroy; override;
  //inner data
    procedure SetTaskData(const aData: TRatesTaskData);
    function  GetTaskData: TRatesTaskData;
  //results
    function HasNewRates: Boolean;
    function GetRates(out aRatesList: TStringList): Boolean;
  // override
    class function GetTaskName: string; override;
    class function GetWorkThreadClass: TTaskThreadClass; override;
  end;

  TTaskThreadRates = class(TCommonTaskThread)
  private
    fOwner: TTaskRates;
    fTCPClient: TIdTCPClient;
    fCurProgress: string;

    procedure OutProgress;
  protected
    procedure DoExecute; override;
    procedure CallProgress(const aCaption: string);
    procedure OwnerIsDestroing; override;
  public
    constructor Create(aOwnerTask: TCommonTask); override;
    Destructor Destroy; override;
  end;

implementation

uses
  Windows, SysUtils, MD5, _Main;

{ TTaskRates }

constructor TTaskRates.Create;
begin
  inherited;
  RatesList := TStringList.Create;
end;

destructor TTaskRates.Destroy;
begin
  RatesList.Free;
  inherited;
end;

procedure TTaskRates.DoWorkThreadTerminate(aThread: TCommonTaskThread);
begin
  inherited;
  //забрать данные из потока
end;


function TTaskRates.GetRates(out aRatesList: TStringList): Boolean;
begin
  Result := HasNewRates;
  if Result then
    aRatesList.Assign(RatesList);
end;

function TTaskRates.GetTaskData: TRatesTaskData;
begin
  Result := fData;
end;

class function TTaskRates.GetTaskName: string;
begin
  Result := 'Загрузка курсов по TCP';
end;

class function TTaskRates.GetWorkThreadClass: TTaskThreadClass;
begin
  Result := TTaskThreadRates;
end;

function TTaskRates.HasNewRates: Boolean;
begin
  Result := RatesList.Count > 1;
end;

function TTaskRates.InitThread(aThread: TCommonTaskThread): Boolean;
begin
  RatesList.Clear;
  Result := fDataAssigned;
end;

procedure TTaskRates.SetTaskData(const aData: TRatesTaskData);
begin
  fData := aData;
  fDataAssigned := True;
end;

{ TTaskThreadRates }

procedure TTaskThreadRates.CallProgress(const aCaption: string);
begin
  fCurProgress := aCaption;
  Synchronize(OutProgress);
end;

constructor TTaskThreadRates.Create(aOwnerTask: TCommonTask);
begin
  inherited;                                             

  if Assigned(aOwnerTask) then
  if aOwnerTask is TTaskRates then
    fOwner := aOwnerTask as TTaskRates;

  fTCPClient := TIdTCPClient.Create(nil);

end;

destructor TTaskThreadRates.Destroy;
begin
  fTCPClient.Disconnect;
  fTCPClient.Free;
  inherited;
end;

procedure TTaskThreadRates.DoExecute;
var
  sResultRequest: string;
 // F: TextFile;
begin
  inherited;
  CallProgress('TTaskThreadDiscounts.DoExecute');
  if Terminated then
    Exit;
  if not Assigned(fOwner) then
    Exit;
  CallProgress('Assigned fOwner');
  fOwner.RatesList.Clear;
  try
    with fTCPClient do
    begin
      Disconnect;
      try
        {$IFDEF TEST}
        Host := cTestTCPHost;
        Port := 6003;
        {$ELSE}
        Host := fOwner.fData.Host1;
        Port := fOwner.fData.Port1;
        {$ENDIF}
        CallProgress('connect1');
        Connect;
      except
        if Terminated then
          raise;
        try
          Host := fOwner.fData.Host2;
          Port := fOwner.fData.Port2;
          CallProgress('connect2');
          Connect;
        except
          if Terminated then
            raise;
          Host := fOwner.fData.Host3;
          Port := fOwner.fData.Port3;
          CallProgress('connect3');
          Connect;
        end;
      end;

      if Terminated then
        Exit;

      IOHandler.Writeln('STOCK_KURSES_ACK');
      CallProgress('Send request');
      sResultRequest := IOHandler.ReadLnWait;
      if(sResultRequest = 'END') then
        Disconnect;
      while sResultRequest <> 'END' do
      begin
        if (sResultRequest = 'FILE') or (sResultRequest = 'ENDFILE') or ((sResultRequest = 'Rates.csv'))then
        begin
          sResultRequest := IOHandler.ReadLnWait;
          Continue;
        end
        else
        begin
          fOwner.RatesList.Append(ExtractDelimited(2, sResultRequest, [';']));
          sResultRequest := IOHandler.ReadLnWait;
        end;
      end;
    end;
  finally
    CallProgress('disconnect');
    fTCPClient.Disconnect;
  end;

end;

procedure TTaskThreadRates.OutProgress;
begin
  if Assigned(fOwner) and Assigned(fOwner.LogProc) then
    fOwner.LogProc(fCurProgress);
end;

procedure TTaskThreadRates.OwnerIsDestroing;
begin
  inherited;
  fOwner := nil;
end;

end.
