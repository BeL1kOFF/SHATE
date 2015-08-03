unit _Task_F7;

interface

uses
  _ScheduledTask, Classes, StdCtrls, IdTCPClient;

type
  TF7TaskData = record
    Host1: string;
    Port1: Integer;

    Host2: string;
    Port2: Integer;

    Host3: string;
    Port3: Integer;

    aClientID: string;
    aCodeBrand: string;
    aCodeBrandsStream: TStringStream;
    aCheckOrderOnly: Boolean; //только проверка ожидаемого прихода к Ўате-ћ
  end;

  TF7TaskResult = record
    Res_OK: Boolean;
    TcpReturn: string;
    TcpReturnStream: TStringStream;    
    ErrorText: string;
  end;

  TTaskF7 = class(TCommonTask)
  private
    fData: TF7TaskData;
    fDataAssigned: Boolean;

    fResult: TF7TaskResult;

    procedure ClearResults;
  protected
    function InitThread(aThread: TCommonTaskThread): Boolean; override;   //перед запуском потока
    procedure DoWorkThreadTerminate(aThread: TCommonTaskThread); override;//после завершени€ потока (еще не разрушен)
  public
    constructor Create; override;
    destructor Destroy; override;

    //inner data
    procedure SetTaskData(const aData: TF7TaskData);
    function  GetTaskData: TF7TaskData;

    //results
    function HasResult: Boolean;

    function GetResult: string;
    function GetResultStream: TStringStream;

    function GetErrorText: string; //assigned, if HasResult = False

    class function GetTaskName: string; override;
    class function GetWorkThreadClass: TTaskThreadClass; override;
  end;

  TTaskThreadF7 = class(TCommonTaskThread)
  private
    fOwner: TTaskF7;
    fTCPClient: TIdTCPClient;

    fCurProgress: string;

    fData: TF7TaskData;
    fResult: TF7TaskResult;

    procedure OutProgress;
    procedure Connect;
    procedure Disconnect;
  protected
    procedure DoExecute; override;
    procedure CallProgress(const aCaption: string);
    procedure OwnerIsDestroing; override;
  public
    procedure Init(const aData: TF7TaskData);
    function GetResult: TF7TaskResult;

    constructor Create(aOwnerTask: TCommonTask); override;
    Destructor Destroy; override;
  end;

implementation

uses
  Windows, SysUtils, IdIOHandler,
  MD5;

{ TTaskF7 }


class function TTaskF7.GetTaskName: string;
begin
  Result := 'ѕроверка остатков по TCP';
end;

class function TTaskF7.GetWorkThreadClass: TTaskThreadClass;
begin
  Result := TTaskThreadF7;
end;

constructor TTaskF7.Create;
begin
  inherited;

end;

destructor TTaskF7.Destroy;
begin
  ClearResults;
  inherited;
end;

procedure TTaskF7.ClearResults;
begin
  ZeroMemory(@fResult, SizeOf(TF7TaskResult));
end;

function TTaskF7.InitThread(aThread: TCommonTaskThread): Boolean;
begin
  Result := fDataAssigned;
  if fDataAssigned then
    (aThread as TTaskThreadF7).Init(fData);

  ClearResults;
end;

procedure TTaskF7.DoWorkThreadTerminate(aThread: TCommonTaskThread);
begin
  inherited;
  //забрать данные из потока
  fResult := (aThread as TTaskThreadF7).GetResult;
end;

function TTaskF7.HasResult: Boolean;
begin
  Result := fResult.Res_OK;
end;

function TTaskF7.GetResult: string;
begin
  Result := fResult.TcpReturn;
end;

function TTaskF7.GetResultStream: TStringStream;
begin
  Result := fResult.TcpReturnStream;
end;

function TTaskF7.GetErrorText: string;
begin
  Result := fResult.ErrorText;
end;

function TTaskF7.GetTaskData: TF7TaskData;
begin
  Result := fData;
end;

procedure TTaskF7.SetTaskData(const aData: TF7TaskData);
begin
  fData := aData;
  fDataAssigned := True;
end;

{ TTaskThreadF7 }

constructor TTaskThreadF7.Create(aOwnerTask: TCommonTask);
begin
  inherited;
  if Assigned(aOwnerTask) then
    if aOwnerTask is TTaskF7 then
      fOwner := aOwnerTask as TTaskF7;

  fTCPClient := TIdTCPClient.Create(nil);
end;

destructor TTaskThreadF7.Destroy;
begin
  fTCPClient.Disconnect;
  fTCPClient.Free;

  inherited;
end;

procedure TTaskThreadF7.CallProgress(const aCaption: string);
begin
  fCurProgress := aCaption;
  Synchronize(OutProgress);
end;

procedure TTaskThreadF7.Connect;
begin
  with fTCPClient do
  begin
    Disconnect;
    try
      {$IFDEF TEST}
      Host := cTestTCPHost;
      Port := 6004;
      {$ELSE}
      Host := fData.Host1; 
      Port := fData.Port1;
      {$ENDIF}
      CallProgress('connect1');
      Connect;
    except
      if Terminated then
        raise;
      try
        Host := fData.Host2;
        Port := fData.Port2;
        CallProgress('connect2');
        Connect;
      except
        if Terminated then
          raise;
        Host := fData.Host3;
        Port := fData.Port3;
        CallProgress('connect3');
        Connect;
      end;
    end;
  end;
end;

procedure TTaskThreadF7.Disconnect;
begin
  CallProgress('disconnect');
  fTCPClient.Disconnect;
end;

procedure TTaskThreadF7.DoExecute;

  function CheckDataIn: Boolean;
  begin
    Result := (Length(fData.aClientID) >= 2) and
              (Length(fData.aCodeBrand) > 4);
  end;

  //проверка остатка на складе
  //aCheckOrder - только проверка ожидаемого прихода к Ўате-ћ
  function CheckQuant(aHandler: TIdIOHandler; const aClientID, aCodeBrand: string; aCheckOrder: Boolean = False): string;
  const
    FLAG_EXIST_STREAM = 'LIST_OF_VALUE';
  var
    s, aSignIn, aSignOut, aHesh: string;
    i, j: Integer;
    Stream: TStringStream;
  begin
    Result := '';
//    Stream := TStringStream.Create('');
    fResult.TcpReturnStream := TStringStream.Create('');
    try
      aHandler.Writeln('F7_ACK');
      CallProgress('send request');
      aSignIn := '';
      while Length(aSignIn) < 30 do
        aSignIn := aSignIn + IntToStr(Random(9));
      aHandler.Writeln(aSignIn);
      aHandler.Writeln(aClientID);
      aSignOut := aHandler.ReadLnWait;
      s := aSignIn + aClientID;

      j := 1;
      for i := 1 to Length(aSignOut) do
      begin
        if j > Length(s) then
          j := 1;

        if i > i then  //???????????
          aHesh := aHesh + IntToStr( ((StrToInt(aSignOut[i]+ s[j])*j) mod i) )
        else
          aHesh := aHesh + IntToStr( ((StrToInt(aSignOut[i]+ s[j])*j) div i) );
        Inc(j);
      end;

      aHandler.Writeln(aHesh);
      s := aHandler.ReadLnWait;
      if SameText(s, 'END') then
        Exit;

      if fData.aCodeBrandsStream.Size > 0 then
      begin
        aHandler.Writeln(FLAG_EXIST_STREAM);
        aHandler.Write(fData.aCodeBrandsStream, 0, True);
        fResult.TcpReturnStream.Position := 0;
        aHandler.ReadStream(fResult.TcpReturnStream, -1, False);
        //Stream.Position := 0;
        //aHandler.ReadStream(Stream, -1, False);
        //fResult.TcpReturnStream.CopyFrom(Stream, Stream.Size);
      end
      else
      if aCheckOrder then
        aHandler.Writeln('@' + aCodeBrand)
      else
        aHandler.Writeln(aCodeBrand);
      Result := aHandler.ReadLnWait;
    finally
      Stream.Free;
    end;
  end;

begin
  inherited;

  CallProgress('TTaskThreadF7.DoExecute');

  if Terminated then
    Exit;

  if not Assigned(fOwner) then
    Exit;

  fResult.Res_OK := False;

  //проверка входных данных
  if not CheckDataIn then
  begin
    fResult.ErrorText := 'Ќеверный идентификатор клиента или код товара';
    Exit;
  end;

  try
    Connect;
  except
    on E: Exception do
    begin
      fResult.ErrorText := 'Ќет св€зи с сервером!'#13#10 + E.Message; //connect error
      Exit;
    end;
  end;

  try
    if Terminated then
      Exit;
      
    try
      //получаем данные по TCP
      fResult.TcpReturn := CheckQuant(fTCPClient.IOHandler, fData.aClientID, fData.aCodeBrand, fData.aCheckOrderOnly);
      fResult.Res_OK := True;
    except
      on E: Exception do
        fResult.ErrorText := E.Message; //receive error
    end;
  finally
    Disconnect;
  end;
end;

function TTaskThreadF7.GetResult: TF7TaskResult;
begin
  Result := fResult;
end;

procedure TTaskThreadF7.Init(const aData: TF7TaskData);
begin
  fData := aData;
  ZeroMemory(@fResult, SizeOf(TF7TaskResult));
end;

procedure TTaskThreadF7.OutProgress;
begin
  //do nothing
end;

procedure TTaskThreadF7.OwnerIsDestroing;
begin
  inherited;
  fOwner := nil;
end;

end.


