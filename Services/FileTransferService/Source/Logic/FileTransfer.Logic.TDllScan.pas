unit FileTransfer.Logic.TDllScan;

interface

uses
  System.Types,
  System.Generics.Collections,
  Data.Win.ADODB,
  Package.CustomInterface.ISenderAdapter,
  Package.CustomInterface.IReceiverAdapter;

type
  TDllItem = class
  strict private
    FHandle: THandle;
  public
    FileName: string;
    destructor Destroy; override;
    function GetGUID: string;
    function GetSenderClass: ISenderAdapter;
    function GetReceiverClass: IReceiverAdapter;
    function Open: Boolean;
    function RegisterAdapter(aADOConnection: TADOConnection): Boolean;
    procedure Close;
  end;

  TDllScan = record
  private
    class var
      FItems: TList<TDllItem>;
  public
    class var
      Path: string;
    class function GetSenderClass(const aGUID: string): ISenderAdapter; static;
    class function GetReceiverClass(const aGUID: string): IReceiverAdapter; static;
    class procedure Close; static;
    class procedure RegisterAdapter(aADOConnection: TADOConnection); static;
    class procedure Scan; static;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  System.IOUtils,
  FileTransfer.Logic.TFileLogger;

{ TDllScan }

class procedure TDllScan.Close;
var
  k: Integer;
begin
  for k := 0 to FItems.Count - 1 do
    FItems.Items[k].Free();
  FItems.Free();
end;

class function TDllScan.GetReceiverClass(const aGUID: string): IReceiverAdapter;
var
  k: Integer;
begin
  Result := nil;
  for k := 0 to FItems.Count - 1 do
    if SameText(FItems.Items[k].GetGUID, aGUID) then
    begin
      Result := FItems.Items[k].GetReceiverClass();
      Break;
    end;
end;

class function TDllScan.GetSenderClass(const aGUID: string): ISenderAdapter;
var
  k: Integer;
begin
  Result := nil;
  for k := 0 to FItems.Count - 1 do
    if SameText(FItems.Items[k].GetGUID, aGUID) then
    begin
      Result := FItems.Items[k].GetSenderClass;
      Break;
    end;
end;

class procedure TDllScan.RegisterAdapter(aADOConnection: TADOConnection);
var
  k: Integer;
begin
  for k := 0 to FItems.Count - 1 do
    FItems.Items[k].RegisterAdapter(aADOConnection);
end;

class procedure TDllScan.Scan;
var
  items: TStringDynArray;
  k: Integer;
  dllItem: TDllItem;
begin
  FItems := TList<TDllItem>.Create();
  items := TDirectory.GetFiles(Path, '*.dll');
  for k := 0 to Length(items) - 1 do
  begin
    dllItem := TDllItem.Create();
    dllItem.FileName := items[k];
    if dllItem.Open() then
      FItems.Add(dllItem)
    else
      dllItem.Free();
  end;
  TFileLogger.Write('Кол-во зарегистрированных адаптеров: ' + IntToStr(FItems.Count));
end;

{ TDllItem }

procedure TDllItem.Close;
begin
  FreeLibrary(FHandle);
end;

destructor TDllItem.Destroy;
begin
  if FHandle > 0 then
    Close();
  inherited Destroy();
end;

function TDllItem.GetGUID: string;
type
  TFuncGetGUID = function: PChar; stdcall;
var
  p: Pointer;
begin
  Result := '';
  p := GetProcAddress(FHandle, 'GetGUID');
  if p <> nil then
    Result := TFuncGetGUID(p);
end;

function TDllItem.GetReceiverClass: IReceiverAdapter;
type
  TFuncCreateReceiverAdapter = function: IReceiverAdapter; stdcall;
var
  p: Pointer;
begin
  Result := nil;
  p := GetProcAddress(FHandle, 'CreateReceiverAdapter');
  if p <> nil then
    Result := TFuncCreateReceiverAdapter(p);
end;

function TDllItem.GetSenderClass: ISenderAdapter;
type
  TFuncCreateSenderAdapter = function: ISenderAdapter; stdcall;
var
  p: Pointer;
begin
  Result := nil;
  p := GetProcAddress(FHandle, 'CreateSenderAdapter');
  if p <> nil then
    Result := TFuncCreateSenderAdapter(p);
end;

function TDllItem.Open: Boolean;
var
  p: Pointer;
begin
  Result := False;
  FHandle := LoadLibrary(PChar(FileName));
  if FHandle > 0 then
  begin
    p := GetProcAddress(FHandle, 'GetGUID');
    if p <> nil then
    begin
      p := GetProcAddress(FHandle, 'AdapterInfo');
      if p <> nil then
      begin
        p := GetProcAddress(FHandle, 'CreateSenderAdapter');
        if p <> nil then
        begin
          p := GetProcAddress(FHandle, 'CreateReceiverAdapter');
          if p <> nil then
            Result := True;
        end;
      end;
    end;
    if not Result then
      Close();
  end;
end;

function TDllItem.RegisterAdapter(aADOConnection: TADOConnection): Boolean;
type
//  TFuncRegisterAdapter = function(aADOConnection: TADOConnection): Boolean; stdcall;
  TFuncAdapterInfo = function (out aGUID; var cGUID: Integer; out aName; var cName: Integer): Integer; stdcall;
var
  p: Pointer;
  guid: string;
  name: string;
  cG, cN: Integer;
  res: Integer;
  adoQuery: TADOQuery;
begin
  Result := False;
  p := GetProcAddress(FHandle, 'AdapterInfo');
  if p <> nil then
  begin
    cG := 100;
    cN := 400;
    SetLength(guid, cG);
    SetLength(name, cN);
    res := TFuncAdapterInfo(p)(guid[1], cG, name[1], cN);
    if res = 0 then
    begin
      SetLength(guid, cG div StringElementSize(guid));
      SetLength(name, cN div StringElementSize(name));
      adoQuery := TADOQuery.Create(nil);
      try
        adoQuery.Connection := aADOConnection;
        adoQuery.SQL.Text := 'tp_registeradapter :Guid, :Name';
        adoQuery.Parameters.ParamValues['Guid'] := guid;
        adoQuery.Parameters.ParamValues['Name'] := name;
        try
          adoQuery.ExecSQL;
          Result := True;
        except
        end;
      finally
        adoQuery.Free();
      end;
    end
    else
      Result := False;
  end;
end;

end.
