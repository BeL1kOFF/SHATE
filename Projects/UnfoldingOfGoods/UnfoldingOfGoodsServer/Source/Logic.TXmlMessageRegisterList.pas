unit Logic.TXmlMessageRegisterList;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Logic.XmlMessage.TCustomXmlMessage;

type
  TXmlMessageRegisterList = class
  private
    FList: TList<TCustomXmlMessageClass>;
  public
    constructor Create;
    destructor Destroy; override;
    function GetMessageClass(const aXml: string): TCustomXmlMessageClass;
    procedure RegisterMessage(aCustomXmlMessageClass: TCustomXmlMessageClass);
  end;

  EXmlMessageRegisterList = class(Exception);

var
  XmlMessageRegisterList: TXmlMessageRegisterList;

implementation

uses
  Logic.InitUnit;

{ TXmlMessageRegisterList }

constructor TXmlMessageRegisterList.Create;
begin
  FList := TList<TCustomXmlMessageClass>.Create();
end;

destructor TXmlMessageRegisterList.Destroy;
begin
  FList.Free();
  inherited;
end;

function TXmlMessageRegisterList.GetMessageClass(const aXml: string): TCustomXmlMessageClass;
var
  XmlMessageClass: TCustomXmlMessageClass;
  XmlMessage: ICustomXmlMessage;
begin
  try
    for XmlMessageClass in FList do
    begin
      XmlMessage := XmlMessageClass.Create(aXml);
      try
        if XmlMessage.Type_.Equals(XmlMessageClass.GetMessageType()) then
          Exit(XmlMessageClass);
      finally
        XmlMessage := nil;
      end;
    end;
  except
  end;
  Result := nil;
end;

procedure TXmlMessageRegisterList.RegisterMessage(aCustomXmlMessageClass: TCustomXmlMessageClass);
begin
  if not FList.Contains(aCustomXmlMessageClass) then
  begin
    FList.Add(aCustomXmlMessageClass);
    if not ((FindCmdLineSwitch('Install', True)) or
            (FindCmdLineSwitch('UnInstall', True))) then
      TLog.LogMessage(Self.ClassType, Format('Регистрация Message %s', [aCustomXmlMessageClass.GetMessageType()]));
  end
  else
    raise EXmlMessageRegisterList.CreateFmt('Xml Сообщение %s уже зарегистрировано', [aCustomXmlMessageClass.GetMessageType()]);
end;

initialization
  XmlMessageRegisterList := TXmlMessageRegisterList.Create();

finalization
  XmlMessageRegisterList.Free();

end.
