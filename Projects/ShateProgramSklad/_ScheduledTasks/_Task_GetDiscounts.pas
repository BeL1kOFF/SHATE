unit _Task_GetDiscounts;

interface

uses
  _ScheduledTask, Classes, StdCtrls, IdTCPClient;

type
  TDiscountsTaskData = record
    Host1: string;
    Port1: Integer;

    Host2: string;
    Port2: Integer;

    Host3: string;
    Port3: Integer;

    ClientID: string;
    PrivateKey: string;
    DiscountsVersion: Integer;
  end;

  TDiscountsTaskResult = record
    Res_OK: Boolean;
    Res_DiscountsVersion: Integer;
    Res_StreamReaded: Boolean;
  end;

  TTaskDiscounts = class(TCommonTask)
  private
    fData: TDiscountsTaskData;
    fDataAssigned: Boolean;

    fResult: TDiscountsTaskResult;
    fResStream: TMemoryStream;
  protected
    function InitThread(aThread: TCommonTaskThread): Boolean; override;   //перед запуском потока
    procedure DoWorkThreadTerminate(aThread: TCommonTaskThread); override;//после завершения потока (еще не разрушен)
  public
    constructor Create; override;
    destructor Destroy; override;

    //inner data
    procedure SetTaskData(const aData: TDiscountsTaskData);
    function  GetTaskData: TDiscountsTaskData;

    //results
    function HasNewDiscounts: Boolean;
    function GetDiscounts(aStream: TStream; out aVersion: Integer): Boolean;

    class function GetTaskName: string; override;
    class function GetWorkThreadClass: TTaskThreadClass; override;
  end;

  TTaskThreadDiscounts = class(TCommonTaskThread)
  private
    fOwner: TTaskDiscounts;
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
  Windows, SysUtils, MD5;

{ TTaskDiscounts }


class function TTaskDiscounts.GetTaskName: string;
begin
  Result := 'Загрузка скидок по TCP';
end;

class function TTaskDiscounts.GetWorkThreadClass: TTaskThreadClass;
begin
  Result := TTaskThreadDiscounts;
end;

constructor TTaskDiscounts.Create;
begin
  inherited;

  fResStream := TMemoryStream.Create;
end;

destructor TTaskDiscounts.Destroy;
begin
  fResStream.Free;

  inherited;
end;


function TTaskDiscounts.InitThread(aThread: TCommonTaskThread): Boolean;
begin
  Result := fDataAssigned;

  ZeroMemory(@fResult, SizeOf(TDiscountsTaskResult));
  fResStream.Clear;
end;

procedure TTaskDiscounts.DoWorkThreadTerminate(aThread: TCommonTaskThread);
begin
  inherited;
  //забрать данные из потока
end;

function TTaskDiscounts.HasNewDiscounts: Boolean;
begin
  Result := fResult.Res_OK and fResult.Res_StreamReaded;
end;

function TTaskDiscounts.GetDiscounts(aStream: TStream; out aVersion: Integer): Boolean;
begin
  Result := HasNewDiscounts;
  if Result then
  begin
    aStream.CopyFrom(fResStream, 0{all from begin of stream});
    aVersion := fResult.Res_DiscountsVersion;
  end;
end;

function TTaskDiscounts.GetTaskData: TDiscountsTaskData;
begin
  Result := fData;
end;

procedure TTaskDiscounts.SetTaskData(const aData: TDiscountsTaskData);
begin
  fData := aData;
  fDataAssigned := True;
end;

{ TTaskThreadDiscounts }

constructor TTaskThreadDiscounts.Create(aOwnerTask: TCommonTask);
begin
  inherited;
  if Assigned(aOwnerTask) then
    if aOwnerTask is TTaskDiscounts then
      fOwner := aOwnerTask as TTaskDiscounts;

  fTCPClient := TIdTCPClient.Create(nil);
end;

destructor TTaskThreadDiscounts.Destroy;
begin
  fTCPClient.Disconnect;
  fTCPClient.Free;

  inherited;
end;

procedure TTaskThreadDiscounts.CallProgress(const aCaption: string);
begin
  fCurProgress := aCaption;
  Synchronize(OutProgress);
end;

procedure TTaskThreadDiscounts.DoExecute;

  function CheckPrivateKey(const aKey: string): Boolean;
  begin
    Result := Length(aKey) = 20;
  end;

  function CheckClientId(const anID: string): Boolean;
  begin
    Result := Length(anID) >= 2;
  end;

var
  i: Integer;
  iNewVersion, aDiscountVersion, iLine: Integer;
  s, pub_key: string;
begin
  inherited;

  CallProgress('TTaskThreadDiscounts.DoExecute');
{
  i := 0;
  while not Terminated do
  begin
    Inc(i);
    CallProgress(IntToStr(i));
    if i = 10 then
      Break;
    Sleep(500);
  end;
}
  if Terminated then
    Exit;

  if not Assigned(fOwner) then
    Exit;

  fOwner.fResult.Res_OK := False;

  CallProgress('check key and client');
  //не посылаем запрос на сервер если ключ не задан или неверен
  if not CheckPrivateKey(fOwner.fData.PrivateKey) or
     not CheckClientId(fOwner.fData.ClientID) then
    Exit;

  fOwner.fResStream.Clear;
  iNewVersion := 0;
  aDiscountVersion := 0;
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

      pub_key := MD5.MD5DigestToStr(MD5.MD5String(fOwner.fData.ClientID + fOwner.fData.PrivateKey) );
      CallProgress('send request');
      IOHandler.Writeln(Format('DISC_%s_%s_%d', [fOwner.fData.ClientID, pub_key, fOwner.fData.DiscountsVersion]));
      iLine := 0;
      repeat
        CallProgress('read line ' + IntToStr(iLine + 1));
        s := IOHandler.ReadLnWait;
        Inc(iLine);

        if Copy(s, 1, 8) = 'VERSION=' then
        begin
          s := Copy(s, 9, MaxInt);
          iNewVersion := StrToIntDef(s, fOwner.fData.DiscountsVersion);
        end;

        if s = 'BINFILE' then
        begin
          CallProgress('read stream');
          IOHandler.ReadStream(fOwner.fResStream, -1, False);
        end;
      until s = 'END';
    end;

  finally
    CallProgress('disconnect');
    fTCPClient.Disconnect;
  end;

  fOwner.fResult.Res_OK := True;

  if (iLine = 1) and (iNewVersion = 0) then
  begin
    fOwner.fResult.Res_DiscountsVersion := fOwner.fData.DiscountsVersion;
    fOwner.fResult.Res_StreamReaded := False;
  end
  else
  begin
    fOwner.fResult.Res_DiscountsVersion := iNewVersion;
    fOwner.fResult.Res_StreamReaded := True;
  end;
end;

procedure TTaskThreadDiscounts.OutProgress;
begin
  if Assigned(fOwner) and Assigned(fOwner.LogProc) then
    fOwner.LogProc(fCurProgress);
end;

procedure TTaskThreadDiscounts.OwnerIsDestroing;
begin
  inherited;
  fOwner := nil;
end;

end.
