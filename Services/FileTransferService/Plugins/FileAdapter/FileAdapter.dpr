library FileAdapter;

uses
  FastMM4,
  System.SysUtils,
  Data.Win.ADODB,
  Package.CustomInterface.ISenderAdapter,
  Package.CustomInterface.IReceiverAdapter,
  FileAdapter.Logic.TFileSender in 'Logic\FileAdapter.Logic.TFileSender.pas',
  FileAdapter.Logic.TFileReceiver in 'Logic\FileAdapter.Logic.TFileReceiver.pas',
  FileAdapter.Logic.Consts in 'Logic\FileAdapter.Logic.Consts.pas';

const
  GUID_ADAPTER = '{4FD32D88-2367-4750-8CE8-1D371759C8A1}';
  NAME_ADAPTER = 'Файловая система';

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
  Result := TFileSender.Create();
end;

function CreateReceiverAdapter: IReceiverAdapter; stdcall;
begin
  Result := TFileReceiver.Create;
end;

exports CreateReceiverAdapter;
exports CreateSenderAdapter;
exports GetGUID;
//exports RegisterAdapter;
exports AdapterInfo;

begin
end.
