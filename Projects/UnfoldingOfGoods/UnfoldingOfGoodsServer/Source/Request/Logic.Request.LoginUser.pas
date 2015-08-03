unit Logic.Request.LoginUser;

interface

uses
  Logic.Request.TCustomRequest,
  Logic.Request.IRequest,
  Logic.XmlResponse.TXmlResponseLoginUser,
  Logic.XmlMessage.TXmlMessageLoginUser;

type
  TRequestLoginUser = class(TCustomRequest, IRequest)
  private
    procedure GetProcessedXml;
    function GetXmlMessage: IXmlMessageLoginUser;
    function GetXmlResponse: IXmlResponseLoginUser;
  protected
    property XmlMessage: IXmlMessageLoginUser read GetXmlMessage;
    property XmlResponse: IXmlResponseLoginUser read GetXmlResponse;
  end;

implementation

uses
  System.SyncObjs,
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  Logic.Session.TSessionFactory,
  Logic.Session.TSession,
  Logic.WmsRoutingWebServices,
  Logic.InitUnit,
  Logic.TErrorFactory,
  Logic.Options;

{ TRequestLoginUser }

procedure TRequestLoginUser.GetProcessedXml;
var
  Session: ISession;
  UserName: string;

  procedure AssignSessionResult(aSession: ISession);
  begin
    XmlResponse.Result.Session := aSession.SessionGuid;
    XmlResponse.Result.UserFio := aSession.UserName;
    XmlResponse.Result.DateTime := aSession.Started;
  end;

  function CheckVersion(const aVersion: string): Boolean;
  var
    tmpClientVersion: TStringList;
    tmpOptionsVersion: TStringList;
    k: Integer;
  begin
    tmpClientVersion := TStringList.Create();
    try
      tmpOptionsVersion := TStringList.Create();
      try
        tmpClientVersion.Delimiter := '.';
        tmpClientVersion.DelimitedText := aVersion;
        tmpOptionsVersion.Delimiter := '.';
        tmpOptionsVersion.DelimitedText := TOptions.Options.Server.ClientVersion;
        for k := 0 to 1 do
          if (StrToIntDef(tmpClientVersion.Strings[k], -1) < StrToIntDef(tmpOptionsVersion.Strings[k], 0)) then
            Exit(False);
        Result := True;
      finally
        tmpOptionsVersion.Free();
      end;
    finally
      tmpClientVersion.Free();
    end;
  end;

begin
  TLog.LogMethod(ClassType, 'GetProcessedXml');
  if CheckVersion(XmlMessage.Params.Version) then
  begin
    Session := TSessionFactory.FindSession(XmlMessage.Params.UserName);
    if Assigned(Session) then
    begin
      if (not Session.RemoteName.Equals(XmlMessage.Params.MachineName)) or
         (not Session.Location.Equals(XmlMessage.Params.UserLocation)) then
        TErrorFactory.SetUseLoginOtherTSD(XmlResponse.Error, TOptions.Options.Server.SessionExpired - SecondsBetween(Now(), Session.Started))
      else
      begin
        Session.Started := Now();
        AssignSessionResult(Session);
        TSessionFactory.EditSession(Session);
      end;
    end
    else
    begin
      if GetWmsRoutingWebServices_Port().LoginUser(XmlMessage.Params.UserName, XmlMessage.Params.UserLocation, UserName) then
      begin
        Session := TSession.Create();
        try
          Session.SessionGuid := TGUID.NewGuid();
          Session.UserLogin := XmlMessage.Params.UserName;
          Session.UserName := UserName;
          Session.Location := XmlMessage.Params.UserLocation;
          Session.Started := Now();
          Session.RemoteName := XmlMessage.Params.MachineName;
          AssignSessionResult(Session);
          TSessionFactory.AddSession(Session);
          TLog.LogMessage(ClassType, Format('Подключен %s на ТСД %s', [Session.UserName, Session.RemoteName]));
        except
          Session := nil;
          raise;
        end;
      end
      else
        TErrorFactory.SetInvalidUser(XmlResponse.Error);
    end;
  end
  else
    TErrorFactory.SetIncorrectClientVersion(XmlResponse.Error);
end;

function TRequestLoginUser.GetXmlMessage: IXmlMessageLoginUser;
begin
  Result := inherited XmlMessage as IXmlMessageLoginUser;
end;

function TRequestLoginUser.GetXmlResponse: IXmlResponseLoginUser;
begin
  Result := inherited XmlResponse as IXmlResponseLoginUser;
end;

end.
