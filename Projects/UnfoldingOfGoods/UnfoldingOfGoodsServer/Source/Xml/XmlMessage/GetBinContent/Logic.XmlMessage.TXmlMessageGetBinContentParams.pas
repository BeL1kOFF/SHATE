unit Logic.XmlMessage.TXmlMessageGetBinContentParams;

interface

uses
  Logic.XmlMessage.TCustomXmlMessageParams;

type
  IXmlMessageGetBinContentParams = interface(ICustomXmlMessageParams)
  ['{BCADC6CE-F786-4E1F-99D4-28608F77D2B4}']
    function GetItemNo: string;

    property ItemNo: string read GetItemNo;
  end;

  TXmlMessageGetBinContentParams = class(TCustomXmlMessageParams, IXmlMessageGetBinContentParams)
  private
    function GetItemNo: string;
  end;

implementation

{ TXmlMessageGetBinContentParams }

function TXmlMessageGetBinContentParams.GetItemNo: string;
begin
  Result := GetAttribute('ItemNo');
end;

end.
