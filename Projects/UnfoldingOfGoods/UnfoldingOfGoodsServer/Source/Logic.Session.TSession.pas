unit Logic.Session.TSession;

interface

uses
  System.Generics.Defaults;

type
  ISession = interface
  ['{2457C355-41D5-4F3F-9CDC-E85D9E88087B}']
    function GetSession: TGUID;
    function GetUserLogin: string;
    function GetUserName: string;
    function GetLocation: string;
    function GetStarted: TDateTime;
    function GetRemoteName: string;

    procedure SetSession(const aValue: TGUID);
    procedure SetUserLogin(const aValue: string);
    procedure SetUserName(const aValue: string);
    procedure SetLocation(const aValue: string);
    procedure SetStarted(const aValue: TDateTime);
    procedure SetRemoteName(const aValue: string);

    function Clone: ISession;

    property SessionGuid: TGUID read GetSession write SetSession;
    property UserLogin: string read GetUserLogin write SetUserLogin;
    property UserName: string read GetUserName write SetUserName;
    property Location: string read GetLocation write SetLocation;
    property Started: TDateTime read GetStarted write SetStarted;
    property RemoteName: string read GetRemoteName write SetRemoteName;
  end;

  TSession = class(TInterfacedObject, ISession)
  strict private
    FSession: TGUID;
    FUserLogin: string;
    FUserName: string;
    FLocation: string;
    FStarted: TDateTime;
    FRemoteName: string;
    function GetSession: TGUID;
    function GetUserLogin: string;
    function GetUserName: string;
    function GetLocation: string;
    function GetStarted: TDateTime;
    function GetRemoteName: string;

    procedure SetSession(const aValue: TGUID);
    procedure SetUserLogin(const aValue: string);
    procedure SetUserName(const aValue: string);
    procedure SetLocation(const aValue: string);
    procedure SetStarted(const aValue: TDateTime);
    procedure SetRemoteName(const aValue: string);
  private
    function Clone: ISession;
  end;

type
  TSessionComparer = class(TComparer<ISession>)
  public
    function Compare(const Left, Right: ISession): Integer; override;
  end;

implementation

uses
  System.SysUtils;

{ TSession }

function TSession.Clone: ISession;
begin
  Result := TSession.Create();
  Result.SessionGuid := FSession;
  Result.UserLogin := FUserLogin;
  Result.UserName := FUserName;
  Result.Location := FLocation;
  Result.Started := FStarted;
  Result.RemoteName := FRemoteName;
end;

function TSession.GetLocation: string;
begin
  Result := FLocation;
end;

function TSession.GetRemoteName: string;
begin
  Result := FRemoteName;
end;

function TSession.GetSession: TGUID;
begin
  Result := FSession;
end;

function TSession.GetStarted: TDateTime;
begin
  Result := FStarted;
end;

function TSession.GetUserLogin: string;
begin
  Result := FUserLogin;
end;

function TSession.GetUserName: string;
begin
  Result := FUserName;
end;

procedure TSession.SetLocation(const aValue: string);
begin
  FLocation := aValue;
end;

procedure TSession.SetRemoteName(const aValue: string);
begin
  FRemoteName := aValue;
end;

procedure TSession.SetSession(const aValue: TGUID);
begin
  FSession := aValue;
end;

procedure TSession.SetStarted(const aValue: TDateTime);
begin
  FStarted := aValue;
end;

procedure TSession.SetUserLogin(const aValue: string);
begin
  FUserLogin := aValue;
end;

procedure TSession.SetUserName(const aValue: string);
begin
  FUserName := aValue;
end;

{ TSessionComparer }

function TSessionComparer.Compare(const Left, Right: ISession): Integer;
begin
  Result := AnsiCompareText(Left.SessionGuid.ToString(), Right.SessionGuid.ToString());
end;

end.
