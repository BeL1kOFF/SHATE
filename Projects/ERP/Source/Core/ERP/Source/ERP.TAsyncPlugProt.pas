unit ERP.TAsyncPlugProt;

interface

uses
  Winapi.Windows,
  Winapi.UrlMon,
  System.Classes,
  System.Win.ComObj,
  Vcl.AxCtrls;

type
  TAsyncPlugProt = class(TComObject, IInternetProtocol)
  private
    FDataStream: TOleStream;
    FHaveData: Boolean;
    FProtSink: IInternetProtocolSink;
    FReadSize: Integer;
    FTotalSize: Integer;
    FUrl: string;
    function InitData: Boolean;
    function ParseURL(AStr: string; var AData: Integer): Boolean;
  protected
    function Read(pv: Pointer; cb: ULONG; out cbRead: ULONG): HResult; stdcall;
    function Seek(dlibMove: LARGE_INTEGER; dwOrigin: DWORD; out libNewPosition: ULARGE_INTEGER): HResult; stdcall;
    function LockRequest(dwOptions: DWORD): HResult; stdcall;
    function UnlockRequest: HResult; stdcall;
    function Start(szUrl: LPCWSTR; OIProtSink: IInternetProtocolSink;
      OIBindInfo: IInternetBindInfo; grfPI, dwReserved: DWORD): HResult; stdcall;
    function Continue(const ProtocolData: TProtocolData): HResult; stdcall;
    function Abort(hrReason: HResult; dwOptions: DWORD): HResult; stdcall;
    function Terminate(dwOptions: DWORD): HResult; stdcall;
    function Suspend: HResult; stdcall;
    function Resume: HResult; stdcall;
  end;

implementation

uses
  Winapi.ActiveX,
  System.SysUtils;

{ TAsyncPlugProt }

function TAsyncPlugProt.Abort(hrReason: HResult; dwOptions: DWORD): HResult;
begin
  Result := E_NOTIMPL;
end;

function TAsyncPlugProt.Continue(const ProtocolData: TProtocolData): HResult;
begin
  Result := S_OK;
end;

function TAsyncPlugProt.InitData: Boolean;
var
  Data: Integer;
  Stream: IStream;
begin
  Result := False;
  if ParseURL(FUrl, Data) then
  begin
    Pointer(Stream) := Pointer(Data);
    FDataStream := TOleStream.Create(Stream);
    try
      FDataStream.Position := 0;
      FTotalSize := FDataStream.Size;
      Result := True;
    except
      FDataStream.Free;
    end;
  end;
end;

function TAsyncPlugProt.LockRequest(dwOptions: DWORD): HResult;
begin
  Result := S_OK;
end;

function TAsyncPlugProt.ParseURL(AStr: string; var AData: Integer): Boolean;
begin
  try
    Delete(AStr, 1, pos('://', AStr) + 2);
    Delete(AStr, Length(AStr), 1);
    AData := StrToIntDef(AStr, -1);
  except
    AData := -1;
  end;
   if AData = -1 then
     Result := False
   else
     Result := True;
end;

function TAsyncPlugProt.Read(pv: Pointer; cb: ULONG; out cbRead: ULONG): HResult;
begin
  cbRead := FDataStream.Read(pv^, cb);
  Inc(FReadSize, cbRead);
  if FReadSize = FTotalSize then
  begin
    Result := S_FALSE;
    FProtSink.ReportResult(S_OK, S_OK, nil);
  end
  else
    Result := S_OK;
end;

function TAsyncPlugProt.Resume: HResult;
begin
  Result := E_NOTIMPL;
end;

function TAsyncPlugProt.Seek(dlibMove: LARGE_INTEGER; dwOrigin: DWORD;
  out libNewPosition: ULARGE_INTEGER): HResult;
begin
  Result := E_NOTIMPL;
end;

function TAsyncPlugProt.Start(szUrl: LPCWSTR; OIProtSink: IInternetProtocolSink;
  OIBindInfo: IInternetBindInfo; grfPI, dwReserved: DWORD): HResult;
begin
  FUrl := szUrl;
  FReadSize := 0;
  FHaveData := False;
  if InitData then
  begin
    FHaveData := True;
    FProtSink := OIProtSink;
    FProtSink.ReportData(BSCF_FIRSTDATANOTIFICATION or BSCF_LASTDATANOTIFICATION or
      BSCF_DATAFULLYAVAILABLE, FTotalSize, FTotalSize);
    Result := S_OK;
  end
  else
    Result := S_FALSE;
end;

function TAsyncPlugProt.Suspend: HResult;
begin
  Result := E_NOTIMPL;
end;

function TAsyncPlugProt.Terminate(dwOptions: DWORD): HResult;
begin
  if FHaveData then
  begin
    FDataStream.Free;
    FProtSink._Release;
  end;
  Result := S_OK;
end;

function TAsyncPlugProt.UnlockRequest: HResult;
begin
  Result := S_OK;
end;

end.
