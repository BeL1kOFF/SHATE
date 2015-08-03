unit Logic.XmlMessage.TXmlMessageLoginUserParams;

interface

uses
  Logic.XmlMessage.TCustomXmlMessageParams;

type
  IXmlMessageLoginUserParams = interface(ICustomXmlMessageParams)
  ['{EC8BE67E-C233-495E-A2E8-B10346316A4D}']
    function GetMachineName: string;
    function GetUserLocation: string;
    function GetUserName: string;
    function GetVersion: string;

    property UserName: string read GetUserName;
    property UserLocation: string read GetUserLocation;
    property MachineName: string read GetMachineName;
    property Version: string read GetVersion;
  end;

  TXmlMessageLoginUserParams = class(TCustomXmlMessageParams, IXmlMessageLoginUserParams)
  private
    function GetMachineName: string;
    function GetUserLocation: string;
    function GetUserName: string;
    function GetVersion: string;
  end;

implementation

{ TXmlMessageLoginUserParams }

function TXmlMessageLoginUserParams.GetMachineName: string;
begin
  Result := GetAttribute('MachineName');
end;

function TXmlMessageLoginUserParams.GetUserLocation: string;
begin
  Result := GetAttribute('UserLocation');
end;

function TXmlMessageLoginUserParams.GetUserName: string;
begin
  Result := GetAttribute('UserName');
end;

function TXmlMessageLoginUserParams.GetVersion: string;
begin
  Result := GetAttribute('Version');
end;

end.
