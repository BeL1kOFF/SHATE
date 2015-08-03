unit Logic.XmlMessage.TXmlMessageGetExpiredDataParams;

interface

uses
  Logic.XmlMessage.TCustomXmlMessageParams;

type
  IXmlMessageGetExpiredDataParams = interface(ICustomXmlMessageParams)
  ['{5BACCB64-B954-43B0-A981-E3BF74AA0461}']
    function GetDateTime: TDateTime;
    function GetVersion: string;

    property DateTime: TDateTime read GetDateTime;
    property Version: string read GetVersion;
  end;

  TXmlMessageGetExpiredDataParams = class(TCustomXmlMessageParams, IXmlMessageGetExpiredDataParams)
  private
    function GetDateTime: TDateTime;
    function GetVersion: string;
  end;

implementation

uses
  System.SysUtils;

{ TXmlMessageGetExpiredDataParams }

function TXmlMessageGetExpiredDataParams.GetDateTime: TDateTime;
var
  FormatSettings: TFormatSettings;
begin
  FormatSettings.ShortDateFormat := 'dd.mm.yyyy';
  FormatSettings.DateSeparator := '.';
  FormatSettings.ShortTimeFormat := 'hh:nn:ss';
  FormatSettings.TimeSeparator := ':';
  Result := StrToDateTime(GetAttribute('DateTime'), FormatSettings);
end;

function TXmlMessageGetExpiredDataParams.GetVersion: string;
begin
  Result := GetAttribute('Version');
end;

end.
