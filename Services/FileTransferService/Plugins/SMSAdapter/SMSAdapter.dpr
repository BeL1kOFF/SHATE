library SMSAdapter;

uses
  System.SysUtils,
  System.Classes,
  Package.CustomInterface.ISenderAdapter,
  Package.CustomInterface.IReceiverAdapter,
  SMSAdapter.Logic.TSMSAdapterSender in 'Source\SMSAdapter.Logic.TSMSAdapterSender.pas',
  SMSAdapter.Logic.TSMSAdapterReceiver in 'Source\SMSAdapter.Logic.TSMSAdapterReceiver.pas',
  SMSAdapter.Logic.XMLOptions in 'Source\SMSAdapter.Logic.XMLOptions.pas',
  SMSAdapter.Logic.XMLSMSQuery in 'Source\SMSAdapter.Logic.XMLSMSQuery.pas';

const
  GUID_ADAPTER = '{A7705B69-7F6A-4308-A798-1AD861009831}';
  NAME_ADAPTER = 'SMS рассылка';

{$R *.res}

function GetGUID: PChar; stdcall;
begin
  Result := GUID_ADAPTER;
end;

function AdapterInfo(out aGUID; var cGUID: Integer; out aName; var cName: Integer): Integer; stdcall;
begin
  if cGUID < Length(GUID_ADAPTER) * StringElementSize(GUID_ADAPTER) then
    Result := 1
  else
    if cName < Length(NAME_ADAPTER) * StringElementSize(NAME_ADAPTER) then
      Result := 2
    else
    begin
      Move(GUID_ADAPTER[1], aGUID, Length(GUID_ADAPTER) * StringElementSize(GUID_ADAPTER));
      Move(NAME_ADAPTER[1], aName, Length(NAME_ADAPTER) * StringElementSize(NAME_ADAPTER));
      cGUID := Length(GUID_ADAPTER) * StringElementSize(GUID_ADAPTER);
      cName := Length(NAME_ADAPTER) * StringElementSize(NAME_ADAPTER);
      Result := 0;
    end;
end;

function CreateSenderAdapter: ISenderAdapter; stdcall;
begin
  Result := TSMSAdapterSender.Create();
end;

function CreateReceiverAdapter: IReceiverAdapter; stdcall;
begin
  Result := TSMSAdapterReceiver.Create();
end;

exports CreateReceiverAdapter;
exports CreateSenderAdapter;
exports GetGUID;
exports AdapterInfo;

begin
end.
