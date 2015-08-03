unit _Task_GetOrders;

interface

uses
  _ScheduledTask, Classes, StdCtrls, IdTCPClient;
  
type
  TOrderInfo = record
    ID: Integer;
    ClientID: string;
    OrderNum: string;
  end;

  TRetdocInfo = record
    ID: Integer;
    ClientID: string;
    RetdocNum: string;
  end;


  TOrdersTaskData = record
    Host1: string;
    Port1: Integer;

    Host2: string;
    Port2: Integer;

    Host3: string;
    Port3: Integer;

    OrdersToCheck: array of TOrderInfo;
    RetdocToCheck: array of TRetdocInfo;
  end;


  TOrderResult = record
    ID: Integer;
    Readed: Boolean;

    StreamZakazano: TMemoryStream;
    StreamZameny: TMemoryStream;
  end;

  TRetdocResult = record
    ID: Integer;
    Readed: Boolean;

    StreamZakazano: TMemoryStream;
  end;

  TOrdersTaskResult = record
    Res_OK: Boolean;
    OrdersChecked: array of TOrderResult;
    RetdocChecked: array of TRetdocResult;
  end;

  TTaskOrders = class(TCommonTask)
  private
    fData: TOrdersTaskData;
    fDataAssigned: Boolean;

    fResult: TOrdersTaskResult;

    procedure ClearResults;
  protected
    function InitThread(aThread: TCommonTaskThread): Boolean; override;   //перед запуском потока
    procedure DoWorkThreadTerminate(aThread: TCommonTaskThread); override;//после завершения потока (еще не разрушен)
  public
    constructor Create; override;
    destructor Destroy; override;

    //inner data
    procedure SetTaskData(const aData: TOrdersTaskData);
    function  GetTaskData: TOrdersTaskData;

    //results
    function HasResult: Boolean;

    function HasResultOrder(anOrderID: Integer): Boolean;
    function GetResultOrder(anOrderID: Integer; aStreamZakazano, aStreamZameny: TStream): Boolean;
    function GetResultOrderIDs: string;

    function HasResultRetdoc(aRetdocID: Integer): Boolean;
    function GetResultRetdoc(aRetdocID: Integer; aStreamZakazano: TStream): Boolean;
    function GetResultRetdocIDs: string;

    class function GetTaskName: string; override;
    class function GetWorkThreadClass: TTaskThreadClass; override;
  end;

  TTaskThreadOrders = class(TCommonTaskThread)
  private
    fOwner: TTaskOrders;
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
  Windows, SysUtils, IdIOHandler,
  MD5;

{ TTaskOrders }


class function TTaskOrders.GetTaskName: string;
begin
  Result := 'Проверка заказов по TCP';
end;

class function TTaskOrders.GetWorkThreadClass: TTaskThreadClass;
begin
  Result := TTaskThreadOrders;
end;

constructor TTaskOrders.Create;
begin
  inherited;

end;

destructor TTaskOrders.Destroy;
begin
  ClearResults;
  inherited;
end;

procedure TTaskOrders.ClearResults;
var
  i: Integer;
begin
  for i := Low(fResult.OrdersChecked) to High(fResult.OrdersChecked) do
  begin
    if fResult.OrdersChecked[i].StreamZakazano <> nil then
      fResult.OrdersChecked[i].StreamZakazano.Free;
    if fResult.OrdersChecked[i].StreamZameny <> nil then
      fResult.OrdersChecked[i].StreamZameny.Free;
  end;
  fResult.OrdersChecked := nil;

  for i := Low(fResult.RetdocChecked) to High(fResult.RetdocChecked) do
  begin
    if fResult.RetdocChecked[i].StreamZakazano <> nil then
      fResult.RetdocChecked[i].StreamZakazano.Free;
  end;
  fResult.RetdocChecked := nil;

  ZeroMemory(@fResult, SizeOf(TOrdersTaskResult));
end;

function TTaskOrders.InitThread(aThread: TCommonTaskThread): Boolean;
begin
  Result := fDataAssigned;
  ClearResults;
end;

procedure TTaskOrders.DoWorkThreadTerminate(aThread: TCommonTaskThread);
begin
  inherited;
  //забрать данные из потока
end;

function TTaskOrders.HasResult: Boolean;
begin
  Result := fResult.Res_OK;
end;

function TTaskOrders.HasResultOrder(anOrderID: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(fResult.OrdersChecked) to High(fResult.OrdersChecked) do
  begin
    if fResult.OrdersChecked[i].ID = anOrderID then
    begin
      Result := fResult.OrdersChecked[i].Readed and
                ((fResult.OrdersChecked[i].StreamZakazano <> nil) or (fResult.OrdersChecked[i].StreamZameny <> nil));
      Break;
    end;
  end;
end;

function TTaskOrders.GetResultOrderIDs: string;
var
  i: Integer;
begin
  Result := '';
  for i := Low(fResult.OrdersChecked) to High(fResult.OrdersChecked) do
  begin
    if fResult.OrdersChecked[i].Readed and ((fResult.OrdersChecked[i].StreamZakazano <> nil) or (fResult.OrdersChecked[i].StreamZameny <> nil)) then
      if Result = '' then
        Result := IntToStr(fResult.OrdersChecked[i].ID)
      else
        Result := Result + ',' + IntToStr(fResult.OrdersChecked[i].ID);
  end;
end;

function TTaskOrders.GetResultOrder(anOrderID: Integer;
  aStreamZakazano, aStreamZameny: TStream): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(fResult.OrdersChecked) to High(fResult.OrdersChecked) do
  begin
    if fResult.OrdersChecked[i].ID = anOrderID then
    begin
      Result := fResult.OrdersChecked[i].Readed and
                ((fResult.OrdersChecked[i].StreamZakazano <> nil) or (fResult.OrdersChecked[i].StreamZameny <> nil));
      if fResult.OrdersChecked[i].StreamZakazano <> nil then
        aStreamZakazano.CopyFrom(fResult.OrdersChecked[i].StreamZakazano, 0);
      if fResult.OrdersChecked[i].StreamZameny <> nil then
        aStreamZameny.CopyFrom(fResult.OrdersChecked[i].StreamZameny, 0);
      Break;
    end;
  end;
end;

function TTaskOrders.HasResultRetdoc(aRetdocID: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(fResult.RetdocChecked) to High(fResult.RetdocChecked) do
  begin
    if fResult.RetdocChecked[i].ID = aRetdocID then
    begin
      Result := fResult.RetdocChecked[i].Readed and
                (fResult.RetdocChecked[i].StreamZakazano <> nil);
      Break;
    end;
  end;
end;

function TTaskOrders.GetResultRetdoc(aRetdocID: Integer;
  aStreamZakazano: TStream): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(fResult.RetdocChecked) to High(fResult.RetdocChecked) do
  begin
    if fResult.RetdocChecked[i].ID = aRetdocID then
    begin
      Result := fResult.RetdocChecked[i].Readed and
                (fResult.RetdocChecked[i].StreamZakazano <> nil);

      if fResult.RetdocChecked[i].StreamZakazano <> nil then
        aStreamZakazano.CopyFrom(fResult.RetdocChecked[i].StreamZakazano, 0);

      Break;
    end;
  end;
end;

function TTaskOrders.GetResultRetdocIDs: string;
var
  i: Integer;
begin
  Result := '';
  for i := Low(fResult.RetdocChecked) to High(fResult.RetdocChecked) do
  begin
    if fResult.RetdocChecked[i].Readed and (fResult.RetdocChecked[i].StreamZakazano <> nil) then
      if Result = '' then
        Result := IntToStr(fResult.RetdocChecked[i].ID)
      else
        Result := Result + ',' + IntToStr(fResult.RetdocChecked[i].ID);
  end;
end;

function TTaskOrders.GetTaskData: TOrdersTaskData;
begin
  Result := fData;
end;

procedure TTaskOrders.SetTaskData(const aData: TOrdersTaskData);
begin
  fData := aData;
  fDataAssigned := True;
end;

{ TTaskThreadOrders }


constructor TTaskThreadOrders.Create(aOwnerTask: TCommonTask);
begin
  inherited;
  if Assigned(aOwnerTask) then
    if aOwnerTask is TTaskOrders then
      fOwner := aOwnerTask as TTaskOrders;

  fTCPClient := TIdTCPClient.Create(nil);
end;

destructor TTaskThreadOrders.Destroy;
begin
  fTCPClient.Disconnect;
  fTCPClient.Free;

  inherited;
end;

procedure TTaskThreadOrders.CallProgress(const aCaption: string);
begin
  fCurProgress := aCaption;
  Synchronize(OutProgress);
end;

procedure TTaskThreadOrders.Connect;
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
      try
        Host := fOwner.fData.Host2;
        Port := fOwner.fData.Port2;
        CallProgress('connect2');
        Connect;
      except
        Host := fOwner.fData.Host3;
        Port := fOwner.fData.Port3;
        CallProgress('connect3');
        Connect;
      end;
    end;
  end;
end;

procedure TTaskThreadOrders.Disconnect;
begin
  CallProgress('disconnect');
  fTCPClient.Disconnect;
end;

procedure TTaskThreadOrders.DoExecute;

  function CheckClientId(const anID: string): Boolean;
  begin
    Result := Length(anID) >= 2;
  end;


  function CheckOrder(aHandler: TIdIOHandler; const aInfo: TOrderInfo; var aRes: TOrderResult): Boolean;
  var
    s: string;
    aStream: TMemoryStream;
  begin
    CallProgress('send request');
    aRes.Readed := False;
    //TEST<ver>_<id_клиента>_<номер_заказа>
    aHandler.Writeln(Format('TEST1_%s_%s', [aInfo.ClientID, aInfo.OrderNum]));
    //читаем заказ
    s := aHandler.ReadLnWait(10 {попыток});
    if SameText(s, 'ZAKAZANO') then
    begin
      s := aHandler.ReadLnWait(10 {попыток});
      if SameText(s, 'BINFILE') then
      begin
        CallProgress('read stream');
        aStream := TMemoryStream.Create;
        aHandler.ReadStream(aStream, -1, False);
        aHandler.ReadLnWait(10 {попыток}); { ENDFILE }

        if aStream.Size > 0 then
          aRes.StreamZakazano := aStream
        else
          aStream.Free;
      end;

      //читаем замены
      s := aHandler.ReadLnWait(10 {попыток});
      if SameText(s, 'ZAMENY') then
      begin
        s := aHandler.ReadLnWait(10 {попыток});
        if SameText(s, 'BINFILE') then
        begin
          CallProgress('read stream');
          aStream := TMemoryStream.Create;
          aHandler.ReadStream(aStream, -1, False);
          aHandler.ReadLnWait(10 {попыток}); { ENDFILE }
          aHandler.ReadLnWait(10 {попыток}); { END }

          if aStream.Size > 0 then
            aRes.StreamZameny := aStream
          else
            aStream.Free;
        end;
      end;
      aRes.Readed := True;
    end
    else
      if SameText(s, 'END') then
        aRes.Readed := True;
    Result := True;    
  end;

  function CheckRetdoc(aHandler: TIdIOHandler; const aInfo: TRetdocInfo; out aRes: TRetdocResult): Boolean;
  var
    s: string;
    aStream: TMemoryStream;
  begin
    CallProgress('send request');
    aRes.Readed := False;
    //RETD<ver>_<id_клиента>_<номер_возврата>
    aHandler.Writeln(Format('RETD1_%s_%s', [aInfo.ClientID, aInfo.RetdocNum]));
    //читаем возврат
    s := aHandler.ReadLnWait(10 {попыток});
    if SameText(s, 'ZAKAZANO') then
    begin
      aRes.Readed := True;
      s := aHandler.ReadLnWait(10 {попыток});
      if SameText(s, 'BINFILE') then
      begin
        CallProgress('read stream');
        aStream := TMemoryStream.Create;
        aHandler.ReadStream(aStream, -1, False);
        aHandler.ReadLnWait(10 {попыток}); { ENDFILE }
        aHandler.ReadLnWait(10 {попыток}); { END }

        if aStream.Size > 0 then
          aRes.StreamZakazano := aStream
        else
          aStream.Free;
      end;
    end
    else
      if SameText(s, 'END') then
        aRes.Readed := True;
    Result := True;
  end;


var
  i: Integer;
  s: string;
begin
  inherited;

  CallProgress('TTaskThreadOrders.DoExecute');
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


  // !!! добавить инструкцию проверки(только проверки) пачки заказов !!!
  {
     >> BATCH_TEST<ver>_[%s_%s,%s_%s,%s_%s,%s_%s]
     << 1;0;1;1

     после нее уже забирать сами документы
  }


    //инициализируем структуры для приема результата
    SetLength(fOwner.fResult.OrdersChecked, Length(fOwner.fData.OrdersToCheck));
    for i := Low(fOwner.fData.OrdersToCheck) to High(fOwner.fData.OrdersToCheck) do
    begin
      fOwner.fResult.OrdersChecked[i].ID := fOwner.fData.OrdersToCheck[i].ID;
      fOwner.fResult.OrdersChecked[i].Readed := False;
      fOwner.fResult.OrdersChecked[i].StreamZakazano := nil; //создастся в CheckOrder
      fOwner.fResult.OrdersChecked[i].StreamZameny := nil;   //создастся в CheckOrder
    end;

    SetLength(fOwner.fResult.RetdocChecked, Length(fOwner.fData.RetdocToCheck));
    for i := Low(fOwner.fData.RetdocToCheck) to High(fOwner.fData.RetdocToCheck) do
    begin
      fOwner.fResult.RetdocChecked[i].ID := fOwner.fData.RetdocToCheck[i].ID;
      fOwner.fResult.RetdocChecked[i].Readed := False;
      fOwner.fResult.RetdocChecked[i].StreamZakazano := nil;
    end;

    if Terminated then
      Exit;

    //получаем данные по TCP
    for i := Low(fOwner.fData.OrdersToCheck) to High(fOwner.fData.OrdersToCheck) do
    begin
      CallProgress('check client');
      //не посылаем запрос на сервер если ключ не задан или неверен
      if not CheckClientId(fOwner.fData.OrdersToCheck[i].ClientID) then
        Continue;

      Connect;
      if Terminated then
        Exit;
      try
        CheckOrder(fTCPClient.IOHandler, fOwner.fData.OrdersToCheck[i], fOwner.fResult.OrdersChecked[i]);
      finally
        Disconnect;
      end;

      if Terminated then
        Exit;
    end;

//не использовать переменные таски здесь - она может быть распущена до остановки потока

    for i := Low(fOwner.fData.RetdocToCheck) to High(fOwner.fData.RetdocToCheck) do
    begin
      CallProgress('check client');
      //не посылаем запрос на сервер если ключ не задан или неверен
      if not CheckClientId(fOwner.fData.RetdocToCheck[i].ClientID) then
        Continue;

      Connect;
      try
        if Terminated then
          Exit;
        CheckRetdoc(fTCPClient.IOHandler, fOwner.fData.RetdocToCheck[i], fOwner.fResult.RetdocChecked[i]);
      finally
        Disconnect;
      end;
      
      if Terminated then
        Exit;
    end;

  fOwner.fResult.Res_OK := True;
end;

procedure TTaskThreadOrders.OutProgress;
begin
  if Assigned(fOwner) and Assigned(fOwner.LogProc) then
    fOwner.LogProc(fCurProgress);
end;

procedure TTaskThreadOrders.OwnerIsDestroing;
begin
  inherited;
  fOwner := nil;
end;

end.
