unit Logic.Session.TSessionFactory;

interface

uses
  System.SyncObjs,
  System.Generics.Collections,
  Logic.Session.TSession;

type
  TSessionFactory = class
  private
    class var
      FLock: TCriticalSection;
      FSessionList: TList<ISession>;
      FSessionCompare: TSessionComparer;
    class constructor Create;
    class destructor Destroy;
    class procedure ExpiredSession;
  public
    class procedure Lock; static;
    class procedure Unlock; static;
    class procedure AddSession(aSession: ISession); static;
    class procedure EditSession(aSession: ISession); static;
    class procedure RemoveSession(aSession: ISession); static;
    class function GetSession(const aGuid: TGuid): ISession; static;
    class function FindSession(const aLoginName: string): ISession; static;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  Logic.InitUnit,
  Logic.Options;

{ TSessionFactory }

class procedure TSessionFactory.AddSession(aSession: ISession);
begin
  Lock();
  try
    FSessionList.Add(aSession);
    TLog.LogMessage(TSessionFactory, Format('Кол-во сессий: %d', [FSessionList.Count]));
  finally
    UnLock();
  end;
end;

class constructor TSessionFactory.Create;
begin
  FLock := TCriticalSection.Create();
  FSessionCompare := TSessionComparer.Create();
  FSessionList := TList<ISession>.Create(FSessionCompare);
end;

class destructor TSessionFactory.Destroy;
begin
  FSessionList.Free();
  FSessionCompare := nil;
  FLock.Free();
end;

class procedure TSessionFactory.EditSession(aSession: ISession);
begin
  Lock();
  try
    FSessionList.Remove(aSession);
    FSessionList.Add(aSession);
    TLog.LogMessage(TSessionFactory, Format('Кол-во сессий: %d', [FSessionList.Count]));
  finally
    UnLock();
  end;
end;

class procedure TSessionFactory.ExpiredSession;
var
  k: Integer;
  BeforeExpiredCount: Integer;
begin
  Lock();
  try
    k := 0;
    BeforeExpiredCount := FSessionList.Count;
    while k < FSessionList.Count do
    begin
      if IncSecond(FSessionList.Items[k].Started, TOptions.Options.Server.SessionExpired) < Now() then
        FSessionList.Delete(k)
      else
        Inc(k);
    end;
    if BeforeExpiredCount - FSessionList.Count > 0 then
      TLog.LogMessage(TSessionFactory, Format('Истекло сессий: %d', [BeforeExpiredCount - FSessionList.Count]));
  finally
    Unlock();
  end;
end;

class function TSessionFactory.FindSession(const aLoginName: string): ISession;
var
  Session: ISession;
begin
  Lock();
  try
    ExpiredSession();
    for Session in FSessionList do
      if Session.UserLogin.Equals(aLoginName) then
        Exit(Session.Clone());
    Result := nil;
  finally
    Unlock();
  end;
end;

class function TSessionFactory.GetSession(const aGuid: TGuid): ISession;
var
  Session: ISession;
begin
  Lock();
  try
    ExpiredSession();
    for Session in FSessionList do
      if IsEqualGUID(Session.SessionGuid, aGuid) then
        Exit(Session.Clone());
    Result := nil;
  finally
    Unlock();
  end;
end;

class procedure TSessionFactory.Lock;
begin
  FLock.Enter();
end;

class procedure TSessionFactory.RemoveSession(aSession: ISession);
begin
  Lock();
  try
    FSessionList.Remove(aSession);
    TLog.LogMessage(TSessionFactory, Format('Кол-во сессий: %d', [FSessionList.Count]));
  finally
    UnLock();
  end;
end;

class procedure TSessionFactory.Unlock;
begin
  FLock.Leave();
end;

end.
