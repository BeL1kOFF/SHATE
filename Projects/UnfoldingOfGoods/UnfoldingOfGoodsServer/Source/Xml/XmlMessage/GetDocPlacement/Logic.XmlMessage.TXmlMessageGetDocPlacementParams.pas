unit Logic.XmlMessage.TXmlMessageGetDocPlacementParams;

interface

uses
  Logic.XmlMessage.TCustomXmlMessageParams;

type
  IXmlMessageGetDocPlacementParams = interface(ICustomXmlMessageParams)
  ['{EC8BE67E-C233-495E-A2E8-B10346316A4D}']
    function GetDocNo: string;

    property DocNo: string read GetDocNo;
  end;

  TXmlMessageGetDocPlacementParams = class(TCustomXmlMessageParams, IXmlMessageGetDocPlacementParams)
  private
    function GetDocNo: string;
  end;

implementation

{ TXmlMessageGetDocPlacementParams }

function TXmlMessageGetDocPlacementParams.GetDocNo: string;
begin
  Result := GetAttribute('DocNo');
end;

end.
