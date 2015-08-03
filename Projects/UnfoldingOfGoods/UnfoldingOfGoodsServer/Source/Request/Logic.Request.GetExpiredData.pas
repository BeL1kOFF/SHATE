unit Logic.Request.GetExpiredData;

interface

uses
  Logic.Request.TCustomRequest,
  Logic.Request.IRequest,
  Logic.XmlMessage.TXmlMessageGetExpiredData,
  Logic.XmlResponse.TXmlResponseGetExpiredData;

type
  TRequestGetExpiredData = class(TCustomRequest, IRequest)
  private
    procedure GetProcessedXml;
    function GetXmlMessage: IXmlMessageGetExpiredData;
    function GetXmlResponse: IXmlResponseGetExpiredData;
  protected
    property XmlMessage: IXmlMessageGetExpiredData read GetXmlMessage;
    property XmlResponse: IXmlResponseGetExpiredData read GetXmlResponse;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  System.Classes,
  Logic.Options,
  Logic.InitUnit,
  Logic.TErrorFactory;

{ TRequestGetExpiredData }

procedure TRequestGetExpiredData.GetProcessedXml;

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
  TLog.LogMethod(Self.ClassType, 'GetProcessedXml');
  if CheckVersion(XmlMessage.Params.Version) then
  begin
    if HoursBetween(Now(), XmlMessage.Params.DateTime) >= 1 then
      XmlResponse.Result := 1
    else
      XmlResponse.Result := 0;
  end
  else
    TErrorFactory.SetIncorrectClientVersion(XmlResponse.Error);
end;

function TRequestGetExpiredData.GetXmlMessage: IXmlMessageGetExpiredData;
begin
  Result := inherited XmlMessage as IXmlMessageGetExpiredData;
end;

function TRequestGetExpiredData.GetXmlResponse: IXmlResponseGetExpiredData;
begin
  Result := inherited XmlResponse as IXmlResponseGetExpiredData;
end;

end.
