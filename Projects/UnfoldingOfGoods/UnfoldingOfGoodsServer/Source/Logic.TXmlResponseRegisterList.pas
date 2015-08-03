unit Logic.TXmlResponseRegisterList;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Logic.XmlResponse.TCustomXmlResponse;

type
  TXmlResponseRegisterList = class
  private
    FList: TList<TCustomXmlResponseClass>;
  public
    constructor Create;
    destructor Destroy; override;
    function GetResponseClass(const aType: string): TCustomXmlResponseClass;
    procedure RegisterResponse(aCustomXmlResponseClass: TCustomXmlResponseClass);
  end;

  EXmlResponseRegisterList = class(Exception);

var
  XmlResponseRegisterList: TXmlResponseRegisterList;

implementation

uses
  Logic.InitUnit;

{ TXmlResponseRegisterList }

constructor TXmlResponseRegisterList.Create;
begin
  FList := TList<TCustomXmlResponseClass>.Create();
end;

destructor TXmlResponseRegisterList.Destroy;
begin
  FList.Free();
  inherited;
end;

function TXmlResponseRegisterList.GetResponseClass(const aType: string): TCustomXmlResponseClass;
var
  XmlResponseClass: TCustomXmlResponseClass;
  XmlResponse: TCustomXmlResponse;
begin
  try
    for XmlResponseClass in FList do
    begin
      XmlResponse := XmlResponseClass.Create();
      try
        if aType.Equals(XmlResponseClass.GetMessageType()) then
          Exit(XmlResponseClass);
      finally
        XmlResponse.Free();
      end;
    end;
  except
  end;
  Result := nil;
end;

procedure TXmlResponseRegisterList.RegisterResponse(aCustomXmlResponseClass: TCustomXmlResponseClass);
begin
  if not FList.Contains(aCustomXmlResponseClass) then
  begin
    FList.Add(aCustomXmlResponseClass);
    if not ((FindCmdLineSwitch('Install', True)) or
            (FindCmdLineSwitch('UnInstall', True))) then
      TLog.LogMessage(Self.ClassType, Format('Регистрация Response %s', [aCustomXmlResponseClass.GetMessageType()]));
  end
  else
    raise EXmlResponseRegisterList.CreateFmt('Xml Сообщение %s уже зарегистрировано', [aCustomXmlResponseClass.GetMessageType()]);
end;

initialization
  XmlResponseRegisterList := TXmlResponseRegisterList.Create();

finalization
  XmlResponseRegisterList.Free();

end.
