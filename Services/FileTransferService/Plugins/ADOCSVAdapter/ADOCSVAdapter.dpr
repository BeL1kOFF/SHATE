library ADOCSVAdapter;

uses
  Data.Win.ADODB,
  Package.CustomInterface.ISenderAdapter,
  Package.CustomInterface.IReceiverAdapter,
  System.SysUtils,
  System.Classes,
  ADOCSVAdapter.Logic.TADOCSVSender in 'Logic\ADOCSVAdapter.Logic.TADOCSVSender.pas',
  ADOCSVAdapter.Logic.TADOCSVReceiver in 'Logic\ADOCSVAdapter.Logic.TADOCSVReceiver.pas',
  ADOCSVAdapter.Logic.XMLOptions in 'Logic\ADOCSVAdapter.Logic.XMLOptions.pas';

const
  GUID_ADAPTER = '{1A1A7AAE-9C7E-4155-8FC3-BE2FB8DF5F1A}';
  NAME_ADAPTER = 'Забирание CSV из БД';

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

{function RegisterAdapter(aADOConnection: TADOConnection): Boolean; stdcall;
var
  adoQuery: TADOQuery;
begin
  Result := False;
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := aADOConnection;
    adoQuery.SQL.Text := 'tp_registeradapter :Guid, :Name';
    adoQuery.Parameters.ParamValues['Guid'] := GUID_ADAPTER;
    adoQuery.Parameters.ParamValues['Name'] := NAME_ADAPTER;
    try
      adoQuery.ExecSQL;
      Result := True;
    except
    end;
  finally
    adoQuery.Free();
  end;
end;}

function CreateSenderAdapter: ISenderAdapter; stdcall;
begin
  Result := TADOCSVSender.Create();
end;

function CreateReceiverAdapter: IReceiverAdapter; stdcall;
begin
  Result := TADOCSVReceiver.Create();
end;

exports CreateReceiverAdapter;
exports CreateSenderAdapter;
exports GetGUID;
exports AdapterInfo;

begin
end.
