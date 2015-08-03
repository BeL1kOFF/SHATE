unit FTPAdapter.Logic.TFTPReceiver;

interface

uses
  System.Classes,
  System.SysUtils,
  Package.CustomInterface.ICustomReceiverAdapter,
  Package.CustomInterface.IReceiverAdapter;

type
  TFTPReceiver = class(TInterfacedObject, IReceiverAdapter)
  private
    FServer: string;
    FPort: Integer;
    FLogin: string;
    FPassword: string;
    FDirectory: string;

    FCustomReceiverAdapter: ICustomReceiverAdapter;

    function Execute(aSenderFileName: PChar; const aBuffer: TBytes): Boolean;
    function FileExists(aFileList: TStringList; aFileName: string): Boolean;
    procedure FinalizeAdapter;
    procedure InitAdapter(aCustomReceiverAdapter: ICustomReceiverAdapter);
    procedure LoadAdapter;
  end;

implementation

uses
  Winapi.Windows,
  IdFTP,
  FTPAdapter.Logic.Consts;

{ TFTPReceiver }

function TFTPReceiver.Execute(aSenderFileName: PChar;
  const aBuffer: TBytes): Boolean;
var
  tmpFileName: string;
  resFileName: string;
  tmpGUID: TGUID;
  ftp: TIdFTP;
  fileList: TStringList;
  ms: TMemoryStream;
  tmpPChar: array[0..MAX_PATH] of Char;
begin
  Result := False;
  ftp := TIdFTP.Create(nil);
  fileList := TStringList.Create();
  ms := TMemoryStream.Create();
  try
    try
      ftp.Host := FServer;
      ftp.Port := FPort;
      ftp.Username := FLogin;
      ftp.Password := FPassword;
      ftp.ConnectTimeout := 2000;
      ftp.Connect();
      ZeroMemory(@tmpPChar[0], SizeOf(tmpPChar));
      FCustomReceiverAdapter.GetParseFileName(aSenderFileName, tmpPChar[0], SizeOf(tmpPChar));
      resFileName := tmpPChar;
      ftp.ChangeDir(FDirectory);
      ftp.List(fileList, '*.*', False);
      if (not FCustomReceiverAdapter.IsOverwrite) and (FileExists(fileList, resFileName)) then
        FCustomReceiverAdapter.LogWrite(PChar(Format(rsFileExists, [resFileName])))
      else
      begin
        if FCustomReceiverAdapter.IsUseTempFile then
        begin
          CreateGUID(tmpGUID);
          tmpFileName := GUIDToString(tmpGUID) + '.tmp';
        end
        else
          tmpFileName := resFileName;
        ms.WriteBuffer(Pointer(aBuffer)^, Length(aBuffer));
        ms.Position := 0;
        ftp.Put(ms, tmpFileName);
        if FCustomReceiverAdapter.IsUseTempFile then
          ftp.Rename(tmpFileName, resFileName);
        Result := True;
        FCustomReceiverAdapter.LogWrite(PChar(rsSendFileComplite));
      end;
    except on E: Exception do
      FCustomReceiverAdapter.LogWrite(PChar(E.Message));
    end;
  finally
    ftp.Disconnect();
    ftp.Free();
    ms.Free();
    fileList.Free();
  end;
end;

function TFTPReceiver.FileExists(aFileList: TStringList;
  aFileName: string): Boolean;
begin
  Result := aFileList.IndexOf(aFileName) > -1;
end;

procedure TFTPReceiver.FinalizeAdapter;
begin
  FCustomReceiverAdapter := nil;
end;

procedure TFTPReceiver.InitAdapter(
  aCustomReceiverAdapter: ICustomReceiverAdapter);
begin
  FCustomReceiverAdapter := aCustomReceiverAdapter;
end;

procedure TFTPReceiver.LoadAdapter;
begin
  FCustomReceiverAdapter.Query.Close();
  FCustomReceiverAdapter.Query.SQL.Text := PROC_REC_SEL_FTPRECEIVER;
  FCustomReceiverAdapter.Query.Parameters.ParamValues[PARAM_REC_ID_PROCESSINGRECEIVER] :=
    FCustomReceiverAdapter.Id_ProcessingReceiver;
  try
    FCustomReceiverAdapter.Query.Open();
    FServer := FCustomReceiverAdapter.Query.FieldByName(FLD_REC_SERVER).AsString;
    FPort := FCustomReceiverAdapter.Query.FieldByName(FLD_REC_PORT).AsInteger;
    FLogin := FCustomReceiverAdapter.Query.FieldByName(FLD_REC_LOGIN).AsString;
    FPassword := FCustomReceiverAdapter.Query.FieldByName(FLD_REC_PASSWORD).AsString;
    FDirectory := FCustomReceiverAdapter.Query.FieldByName(FLD_REC_DIRECTORY).AsString;
  finally
    FCustomReceiverAdapter.Query.Close();
  end;
end;

end.
