unit _Task_GetDirectory;

interface
uses
  _ScheduledTask, Classes, StdCtrls, IdTCPClient;

type
  TDirectoryTaskData = record
    Host1: string;
    Port1: Integer;

    Host2: string;
    Port2: Integer;

    Host3: string;
    Port3: Integer;

    ClientID: string;
    PrivateKey: string;

    DiscVersion: Integer;
    AddresVersion: Integer;
    AgrVersion: Integer;

    CheckVersion: integer;
    NeedUpdateDiscounts: Boolean;
        
  end;

 TDirectoryTaskResult = record
//    Res_OK: Boolean;

    Res_DiscVersion: Integer;
    Res_AddresVersion: Integer;
    Res_AgrVersion: Integer;

    Res_StreamReadedDis: Integer;
    Res_StreamReadedAdd: Integer;
    Res_StreamReadedAgr: Integer;
  end;

  TTaskDirectory = class(TCommonTask)
  private
    fData: TDirectoryTaskData;
    fDataAssigned: Boolean;

    fResult: TDirectoryTaskResult;
    fResStreamAdr,fResStreamAgr,fResStreamDisc: TMemoryStream;
  protected
    function InitThread(aThread: TCommonTaskThread): Boolean; override;   //перед запуском потока
    procedure DoWorkThreadTerminate(aThread: TCommonTaskThread); override;//после завершения потока (еще не разрушен)
  public
    constructor Create; override;
    destructor Destroy; override;

    //inner data
    procedure SetTaskData(const aData: TDirectoryTaskData);
    function  GetTaskData: TDirectoryTaskData;

    //results
     function HasNewDis(): Integer; //3
     function HasNewAdd(): Integer; //1
     function HasNewAgr(): Integer; //2

{NEW}procedure GetDisc(aStream: TStream; out aVersion: Integer);
{NEW}procedure GetAddr(aStream: TStream; out aVersion: Integer);
{NEW}procedure GetAgr(aStream: TStream; out aVersion: Integer);

    class function GetTaskName: string; override;
    class function GetWorkThreadClass: TTaskThreadClass; override;
  end;

  TTaskThreadDirectory = class(TCommonTaskThread)
  private
    fOwner: TTaskDirectory;
    fTCPClient: TIdTCPClient;
    fCurProgress: string;
    
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

{ TTaskDirectory }

constructor TTaskDirectory.Create;
begin
  inherited;

  fResStreamAdr := TMemoryStream.Create;
  fResStreamAgr := TMemoryStream.Create;
  fResStreamDisc := TMemoryStream.Create;
end;

destructor TTaskDirectory.Destroy;
begin
  fResStreamAdr.Free;
  fResStreamAgr.Free;
  fResStreamDisc.Free;
  inherited;
end;

procedure TTaskDirectory.DoWorkThreadTerminate(aThread: TCommonTaskThread);
begin
  inherited;
    //забрать данные из потока
end;

procedure TTaskDirectory.GetAddr(aStream: TStream;
  out aVersion: Integer);
begin
  aStream.CopyFrom(fResStreamAdr, 0{all from begin of stream});
  aVersion := fResult.Res_AddresVersion;
end;

procedure TTaskDirectory.GetAgr(aStream: TStream;
  out aVersion: Integer);
begin
  aStream.CopyFrom(fResStreamAgr, 0{all from begin of stream});
  aVersion := fResult.Res_AgrVersion;
end;

procedure TTaskDirectory.GetDisc(aStream: TStream; out aVersion: Integer);
begin
  aStream.CopyFrom(fResStreamDisc, 0{all from begin of stream});
  aVersion := fResult.Res_DiscVersion;
end;

function TTaskDirectory.GetTaskData: TDirectoryTaskData;
begin
  Result := fData;
end;

class function TTaskDirectory.GetTaskName: string;
begin
  Result := 'Загрузка справочников по TCP';
end;

class function TTaskDirectory.GetWorkThreadClass: TTaskThreadClass;
begin
  Result := TTaskThreadDirectory;
end;

function TTaskDirectory.HasNewAdd: Integer;
begin
  Result := fResult.Res_StreamReadedAdd;
end;

function TTaskDirectory.HasNewAgr: Integer;
begin
  Result := fResult.Res_StreamReadedAgr;
end;

function TTaskDirectory.HasNewDis: Integer;
begin
  Result := fResult.Res_StreamReadedDis;
end;

function TTaskDirectory.InitThread(aThread: TCommonTaskThread): Boolean;
begin
  Result := fDataAssigned;

  ZeroMemory(@fResult, SizeOf(TDirectoryTaskResult));
  fResStreamAdr.Clear;
  fResStreamAgr.Clear;
  fResStreamDisc.Clear;
end;

procedure TTaskDirectory.SetTaskData(const aData: TDirectoryTaskData);
begin
  fData := aData;
  fDataAssigned := True;
end;

{ TTaskThreadDirectory }

procedure TTaskThreadDirectory.CallProgress(const aCaption: string);
begin
  if Assigned(fOwner) and Assigned(fOwner.LogProc) then
    fOwner.LogProc(fCurProgress);
end;

constructor TTaskThreadDirectory.Create(aOwnerTask: TCommonTask);
begin
  inherited;
  if Assigned(aOwnerTask) then
    if aOwnerTask is TTaskDirectory then
      fOwner := aOwnerTask as TTaskDirectory;

  fTCPClient := TIdTCPClient.Create(nil);
end;

destructor TTaskThreadDirectory.Destroy;
begin
  fTCPClient.Disconnect;
  fTCPClient.Free;

  inherited;
end;

procedure TTaskThreadDirectory.DoExecute;
 var
  i: Integer;
  iLine: Integer;
  s, pub_key: string;

  function CheckPrivateKey(const aKey: string): Boolean;
  begin
    Result := Length(aKey) = 20;
  end;

  function CheckClientId(const anID: string): Boolean;
  begin
    Result := Length(anID) >= 2;
  end;

  procedure ChoiseAndQueryToHost(Query: string);
  var
    ThreadName: string;
  begin
    CallProgress('send request');
    iLine := 0;
    fTCPClient.IOHandler.Writeln(Format(Query, [fOwner.fData.ClientID, pub_key]));
    ThreadName := Copy(Query,1,7);
    repeat
      CallProgress('read line ' + IntToStr(iLine + 1));
      s := fTCPClient.IOHandler.ReadLnWait;
      Inc(iLine);
      if ThreadName = 'GET_ADD' then
      begin
        try
          if Copy(s, 1, 8) = 'VERSION=' then
            fOwner.fResult.Res_AddresVersion := StrToIntDef(Copy(s, 9, MaxInt), fOwner.fData.AddresVersion);

          if s = 'BINFILE' then
          begin
            CallProgress('read stream');
            fTCPClient.IOHandler.ReadStream(fOwner.fResStreamAdr, -1, False);
          end;

          if Copy(s, 1, 6) = 'ERROR=' then
            fOwner.fResult.Res_StreamReadedAdd := StrToIntDef(Copy(s, 7, MaxInt), 0);

        except
          fOwner.fResult.Res_StreamReadedAdd := 0;
          fOwner.fResult.Res_AddresVersion := fOwner.fData.AddresVersion;
        end;
      end;

      if ThreadName = 'GET_AGR' then
      begin
        try
          if Copy(s, 1, 8) = 'VERSION=' then
            fOwner.fResult.Res_AgrVersion := StrToIntDef(Copy(s, 9, MaxInt), fOwner.fData.AgrVersion);

          if s = 'BINFILE' then
          begin
            CallProgress('read stream');
            fTCPClient.IOHandler.ReadStream(fOwner.fResStreamAgr, -1, False);
          end;

          if Copy(s, 1, 6) = 'ERROR=' then
            fOwner.fResult.Res_StreamReadedAgr := StrToIntDef(Copy(s, 7, MaxInt), 0);

        except
          fOwner.fResult.Res_StreamReadedAgr := 0;
          fOwner.fResult.Res_AgrVersion := fOwner.fData.AgrVersion;
        end;
      end;

      if ThreadName = 'GET_DIS' then
      begin
        try
          if Copy(s, 1, 8) = 'VERSION=' then
            fOwner.fResult.Res_DiscVersion := StrToIntDef(Copy(s, 9, MaxInt), fOwner.fData.DiscVersion);

          if s = 'BINFILE' then
          begin
            CallProgress('read stream');
            fTCPClient.IOHandler.ReadStream(fOwner.fResStreamDisc, -1, False);
          end;

          if Copy(s, 1, 6) = 'ERROR=' then
            fOwner.fResult.Res_StreamReadedDis := StrToIntDef(Copy(s, 7, MaxInt), 0);

        except
          fOwner.fResult.Res_StreamReadedDis := 0;
          fOwner.fResult.Res_DiscVersion := fOwner.fData.DiscVersion;
        end;
      end;
    until s = 'END';
  end;

  function MainQueryToHost(): string;
  var
    res: string;
    disc,addr,agr: integer;
  begin
    res := '';
    disc := 0;
    addr := 0;
    agr := 0;
    
    pub_key := MD5.MD5DigestToStr(MD5.MD5String(fOwner.fData.ClientID + fOwner.fData.PrivateKey) );
    CallProgress('send request');
    iLine := 0;

    fTCPClient.IOHandler.Writeln(Format('VERSIONS_%s_%s', [fOwner.fData.ClientID, pub_key]));

    repeat
      CallProgress('read line ' + IntToStr(iLine + 1));
      s := fTCPClient.IOHandler.ReadLnWait;
      Inc(iLine);

      if Copy(s, 1, 7) = 'V_DISC=' then
      begin
        s := Copy(s, 8, MaxInt);
        DISC := StrToIntDef(s, fOwner.fData.DiscVersion);
      end;

      if Copy(s, 1, 7) = 'V_ADDR=' then
      begin
        s := Copy(s, 8, MaxInt);
        ADDR := StrToIntDef(s, fOwner.fData.AddresVersion);
      end;

      if Copy(s, 1, 6) = 'V_AGR=' then
      begin
        s := Copy(s, 7, MaxInt);
        AGR := StrToIntDef(s, fOwner.fData.AgrVersion);
      end;
    until s = 'END';

    {Сравнение версий}
    if (fOwner.fData.CheckVersion = 3) or (fOwner.fData.CheckVersion = 33) then
      Result := '123'
    else if fOwner.fData.CheckVersion = 1 then
    begin
      if ADDR > fOwner.fData.AddresVersion then
        Res := Res + '1';
      if AGR > fOwner.fData.AgrVersion then
        Res := Res + '2';
      if DISC > fOwner.fData.DiscVersion then
        Res := Res + '3';
      Result := Res;
    end;


  end;

  function ConnectToHost: Boolean;
  begin
    Result := False;
    CallProgress('TTaskThreadDirectory.DoExecute');

    if Terminated then
      Exit;

    if not Assigned(fOwner) then
      Exit;

//    fOwner.fResult.Res_OK := False;

    CallProgress('check key and client');
    //не посылаем запрос на сервер если ключ не задан или неверен
    if not CheckPrivateKey(fOwner.fData.PrivateKey) or
       not CheckClientId(fOwner.fData.ClientID) then
    begin
      fOwner.fResult.Res_StreamReadedAdd := 11;
      fOwner.fResult.Res_StreamReadedAgr := 11;
      fOwner.fResult.Res_StreamReadedDis := 11;
      Exit;
    end;

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
    end;
    Result := True;
  end;

 {------------------------------MAIN-------------------------------}
var
  ChoiceQuery: string;
begin
  inherited;

  try
    fOwner.fResStreamAdr.Clear;
    fOwner.fResStreamAgr.Clear;
    fOwner.fResStreamDisc.Clear;

    if not ConnectToHost then
      exit;
    ChoiceQuery := MainQueryToHost;
  finally
    CallProgress('disconnect');
    fTCPClient.Disconnect;
  end;

  if length(ChoiceQuery) = 0 then
    exit;
    
  for i := 1 to length(ChoiceQuery) do
  begin
    try
      if not ConnectToHost then
        exit;

      if ChoiceQuery[i] = '1' then
      begin
        fOwner.fResult.Res_StreamReadedAdd := 3;
        ChoiseAndQueryToHost('GET_ADDR_%s_%s');
      end;
      if ChoiceQuery[i] = '2' then
      begin
        fOwner.fResult.Res_StreamReadedAgr := 3;
        ChoiseAndQueryToHost('GET_AGR_%s_%s');
      end;
      if (ChoiceQuery[i] = '3') and (fOwner.fData.NeedUpdateDiscounts) then
      begin
        fOwner.fResult.Res_StreamReadedDis := 3;
        ChoiseAndQueryToHost('GET_DISC_%s_%s');
      end;
    finally
      CallProgress('disconnect');
      fTCPClient.Disconnect;
    end;
  end;

//  fOwner.fResult.Res_OK := True;
end;

procedure TTaskThreadDirectory.OwnerIsDestroing;
begin
  inherited;
  fOwner := nil;
end;

end.
