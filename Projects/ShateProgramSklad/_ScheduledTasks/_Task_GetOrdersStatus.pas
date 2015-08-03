unit _Task_GetOrdersStatus;

interface

uses
  _ScheduledTask, Classes, StdCtrls, IdTCPClient;

type
  TOrdersStatusTaskData = record
    Host1: string;
    Port1: Integer;

    Host2: string;
    Port2: Integer;

    Host3: string;
    Port3: Integer;

    OrdersToCheck: string; {<Order_Id>=<Client_Id>_<Order_Num>,<Order_Id>=<Client_Id>_<Order_Num>}
  end;


  TOrdersStatusTaskResult = record
    Res_OK: Boolean;
    OrdersChecked: string; {<Order_Id>=<Status>,<Order_Id>=<Status>}
  end;

  TTaskOrdersStatus = class(TCommonTask)
  private
    fData: TOrdersStatusTaskData;
    fDataAssigned: Boolean;

    fResult: TOrdersStatusTaskResult;

    procedure ClearResults;
  protected
    function InitThread(aThread: TCommonTaskThread): Boolean; override;   //перед запуском потока
    procedure DoWorkThreadTerminate(aThread: TCommonTaskThread); override;//после завершения потока (еще не разрушен)
  public
    constructor Create; override;
    destructor Destroy; override;

    //inner data
    procedure SetTaskData(const aData: TOrdersStatusTaskData);
    function  GetTaskData: TOrdersStatusTaskData;

    //results
    function HasResult: Boolean;
    function GetResultStatuses: string; //just getting from TOrdersStatusTaskResult.OrdersChecked

    class function GetTaskName: string; override;
    class function GetWorkThreadClass: TTaskThreadClass; override;
  end;

  TTaskThreadOrdersStatus = class(TCommonTaskThread)
  private
    fOwner: TTaskOrdersStatus;
    fTCPClient: TIdTCPClient;

    fCurProgress: string;

    procedure OutProgress;
    procedure Connect;
    procedure Disconnect;
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
  Windows, SysUtils, IdIOHandler;

{ TTaskOrdersStatus }


class function TTaskOrdersStatus.GetTaskName: string;
begin
  Result := 'Проверка заказов по TCP';
end;

class function TTaskOrdersStatus.GetWorkThreadClass: TTaskThreadClass;
begin
  Result := TTaskThreadOrdersStatus;
end;

constructor TTaskOrdersStatus.Create;
begin
  inherited;

end;

destructor TTaskOrdersStatus.Destroy;
begin
  ClearResults;
  inherited;
end;

procedure TTaskOrdersStatus.ClearResults;
begin                                      
  ZeroMemory(@fResult, SizeOf(TOrdersStatusTaskResult));
end;

function TTaskOrdersStatus.InitThread(aThread: TCommonTaskThread): Boolean;
begin
  Result := fDataAssigned;
  ClearResults;
end;

procedure TTaskOrdersStatus.DoWorkThreadTerminate(aThread: TCommonTaskThread);
begin
  inherited;
  //забрать данные из потока
end;

function TTaskOrdersStatus.HasResult: Boolean;
begin
  Result := fResult.Res_OK;
end;


function TTaskOrdersStatus.GetResultStatuses: string;
begin
  Result := fResult.OrdersChecked;
end;

function TTaskOrdersStatus.GetTaskData: TOrdersStatusTaskData;
begin
  Result := fData;
end;

procedure TTaskOrdersStatus.SetTaskData(const aData: TOrdersStatusTaskData);
begin
  fData := aData;
  fDataAssigned := True;
end;

{ TTaskThreadOrdersStatus }


constructor TTaskThreadOrdersStatus.Create(aOwnerTask: TCommonTask);
begin
  inherited;
  if Assigned(aOwnerTask) then
    if aOwnerTask is TTaskOrdersStatus then
      fOwner := aOwnerTask as TTaskOrdersStatus;

  fTCPClient := TIdTCPClient.Create(nil);
end;

destructor TTaskThreadOrdersStatus.Destroy;
begin
  fTCPClient.Disconnect;
  fTCPClient.Free;

  inherited;
end;

procedure TTaskThreadOrdersStatus.CallProgress(const aCaption: string);
begin
  fCurProgress := aCaption;
  Synchronize(OutProgress);
end;

procedure TTaskThreadOrdersStatus.Connect;
begin
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
  end;
end;

procedure TTaskThreadOrdersStatus.Disconnect;
begin
  CallProgress('disconnect');
  fTCPClient.Disconnect;
end;

procedure TTaskThreadOrdersStatus.DoExecute;

  function CheckClientId(const aClient_aNUM: string): Boolean;
  var
    p: Integer;
  begin
    Result := False;
    p := POS('_', aClient_aNUM);
    if p > 0 then
    begin
      Result := ( Length(Copy(aClient_aNUM, 1, p - 1)) >= 2 ) and
                ( Length(Copy(aClient_aNUM, p + 1, MaxInt)) > 4 );
    end;
  end;


  function CheckOrderStatus(aHandler: TIdIOHandler; const aClient_aNUM: string): Integer; //0, 1, (-2 error)
  var
    s: string;
    aStream: TMemoryStream;
  begin
    CallProgress('send request');
    try
      //STATUS<ver>_<id_клиента>_<номер_заказа>
      aHandler.Writeln(Format('STATUS1_%s', [aClient_aNUM]));
      //читаем заказ
      s := aHandler.ReadLnWait(10 {попыток});
      if SameText(s, 'END') then
        Result := -2 //ошибка?, опросить в следующий раз
      else
      begin
        Result := StrToIntDef(s, -1);
        aHandler.ReadLnWait(10 {попыток}); { END }
      end;
    except
      Result := -2;
    end;
  end;

  function CheckOrderStatusBatch(aHandler: TIdIOHandler; const aClient_aNUM_list: string): string; //'0,1,-1,0' ('' error)
  var
    s: string;
    aStream: TMemoryStream;
  begin
    //BATCH_STATUS<ver>_(<CLIENT_ID>_<DOC_NUM>[,<CLIENT_ID>_<DOC_NUM>])
    CallProgress('send request');
    try
      //STATUS<ver>_<id_клиента>_<номер_заказа>
      aHandler.Writeln(Format('BATCH_STATUS1_(%s)', [aClient_aNUM_list]));
      //читаем заказ
      s := aHandler.ReadLnWait(10 {попыток});
      if SameText(s, 'END') then
        Result := '' //ошибка?, опросить в следующий раз
      else
      begin
        Result := s;
        aHandler.ReadLnWait(10 {попыток}); { END }
      end;
    except
      Result := '';
    end;
  end;


var
  i, aStatus, p: Integer;
  s, sStatus: string;
  anIDs, aRes: TStrings;
  aBatch: string;
begin
  inherited;

  CallProgress('TTaskThreadOrdersStatus.DoExecute');
{
  i := 0;
  while not Terminated do
  begin
    Inc(i);
    CallProgress(IntToStr(i));
    if i = 3 then
      Break;
    Sleep(500);
  end;
}
  if Terminated then
    Exit;

  if not Assigned(fOwner) then
    Exit;

  fOwner.fResult.Res_OK := False;
  fOwner.fResult.OrdersChecked := '';

    if Terminated then
      Exit;

    //получаем данные по TCP
    anIDs := TStringList.Create;
    aRes := TStringList.Create;
    try
      anIDs.CommaText := fOwner.fData.OrdersToCheck;
      aBatch := '';
      for i := 0 to anIDs.Count - 1 do
      begin
        CallProgress('check client');
        //не посылаем запрос на сервер если клиент не задан или неверен
        if not CheckClientId(anIDs.ValueFromIndex[i]) then
          Continue;
  {
        Connect;
        try
          aStatus := CheckOrderStatus(fTCPClient.IOHandler, anIDs.ValueFromIndex[i]);
          if aStatus <> -2 then //<id>=<status>,<id>=<status>
            if fOwner.fResult.OrdersChecked = '' then
              fOwner.fResult.OrdersChecked := anIDs.Names[i] + '=' + IntToStr(aStatus)
            else
              fOwner.fResult.OrdersChecked := fOwner.fResult.OrdersChecked + ',' + anIDs.Names[i] + '=' + IntToStr(aStatus);
        finally
          Disconnect;
        end;
  }

        aRes.Add(anIDs.Names[i]);//IDшки, которые опрашивались
        //собираем запрос <CLIENT_ID>_<DOC_NUM>,<CLIENT_ID>_<DOC_NUM>,<CLIENT_ID>_<DOC_NUM>...
        if aBatch = '' then
          aBatch := anIDs.ValueFromIndex[i]
        else
          aBatch := aBatch + ',' + anIDs.ValueFromIndex[i];

        if Terminated then
          Exit;
      end;

      // проверка пачки статусов заказов
      if aBatch <> '' then
      begin
        Connect;
        try
          if Terminated then
            Exit;
          s := CheckOrderStatusBatch(fTCPClient.IOHandler, aBatch);
        finally
          Disconnect;
        end;

        if s <> '' then //0,1,0,-1,1
        begin
          for i := 0 to aRes.Count - 1 do
          begin
            p := POS(',', s);
            if p > 0 then
            begin
              sStatus := Copy(s, 1, p - 1);
              Delete(s, 1, p);
            end
            else
              sStatus := s;

            aRes[i] := aRes[i] + '=' + sStatus;
          end;
          fOwner.fResult.OrdersChecked := aRes.CommaText; //<id>=<status>,<id>=<status>,<id>=<status>...
        end;
      end;

    finally
      anIDs.Free;
      aRes.Free;
    end;

  fOwner.fResult.Res_OK := True;
end;

procedure TTaskThreadOrdersStatus.OutProgress;
begin
  if Assigned(fOwner) and Assigned(fOwner.LogProc) then
    fOwner.LogProc(fCurProgress);
end;

procedure TTaskThreadOrdersStatus.OwnerIsDestroing;
begin
  inherited;
  fOwner := nil;
end;

end.
