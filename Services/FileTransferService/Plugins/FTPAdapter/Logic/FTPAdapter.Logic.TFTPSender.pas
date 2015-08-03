unit FTPAdapter.Logic.TFTPSender;

interface

uses
  System.SysUtils,
  IdComponent,
  IdFTP,
  Package.CustomInterface.ICustomSenderAdapter,
  Package.CustomInterface.ISenderAdapter;

type
  TFTPSender = class(TInterfacedObject, ISenderAdapter)
  private
    FServer: string;
    FPort: Integer;
    FLogin: string;
    FPassword: string;
    FDirectory: string;
    FMaxSize: Int64;
    FArrPercent: array[0..10] of Boolean;
    FStart: Boolean;

    FCustomSenderAdapter: ICustomSenderAdapter;
    function Percent(aValue, aMax: Int64): Byte;
    procedure BeginSenderExecute;
    procedure DoWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure EndSenderExecute(aFTP: TIdFTP; const aSenderFileName: string; const aBuffer: TBytes);
    procedure FinalizeAdapter;
    procedure InitAdapter(aCustomSenderAdapter: ICustomSenderAdapter);
    procedure LoadSenderAdapter;
  end;

implementation

uses
  System.Classes,
  FTPAdapter.Logic.Consts;

{ TFTPSender }

procedure TFTPSender.BeginSenderExecute;
var
  ftp: TIdFTP;
  ms: TMemoryStream;
  fileList: TStringList;
  fileName: string;
  k: Integer;
  tmpBuffer: TBytes;
begin
  ftp := TIdFTP.Create(nil);
  ftp.OnWork := DoWork;
  ms := TMemoryStream.Create;
  fileList := TStringList.Create;
  try
    try
      ftp.Host := FServer;
      ftp.Port := FPort;
      ftp.Username := FLogin;
      ftp.Password := FPassword;
      ftp.ConnectTimeout := 2000;
      ftp.Connect;
      ftp.ChangeDir(FDirectory);
      ftp.List(fileList, '*.*', False);
      for k := 0 to fileList.Count - 1 do
      begin
        fileName := fileList.Strings[k];
        if not FCustomSenderAdapter.InMaskList(PChar(fileName)) then
          System.Continue;
        FCustomSenderAdapter.LogWrite(PChar(Format(rsFindFile, [fileName])));
        FMaxSize := ftp.Size(fileName);
        FillChar(FArrPercent[0], 11, False);
        FStart := True;
        ftp.Get(fileName, ms);
        FStart := False;
        ms.Position := 0;
        SetLength(tmpBuffer, ms.Size);
        if ms.Size > 0 then
          ms.ReadBuffer(Pointer(tmpBuffer)^, ms.Size);
        FCustomSenderAdapter.Buffer := tmpBuffer;
        FCustomSenderAdapter.LogWrite(PChar(rsSendFileReceiver));
        FCustomSenderAdapter.ReceiverExecute(PChar(fileName));
        EndSenderExecute(ftp, fileName, tmpBuffer);
      end;
    except on E: Exception do
    begin
      if Copy(E.Message, Length(E.Message) - 1, 2) = #13#10 then
        E.Message := Copy(E.Message, 1, Length(E.Message) - 2);
      FCustomSenderAdapter.LogWrite(PChar(E.Message));
    end;
    end;
  finally
    ftp.Disconnect;
    fileList.Free;
    ms.Free;
    ftp.Free;
  end;
end;

procedure TFTPSender.DoWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
var
  prcnt: Byte;
  index: Byte;
begin
  if not FStart then
    Exit;
  prcnt := Percent(AWorkCount, FMaxSize);
  index := prcnt div 10;
  if not FArrPercent[index] then
    if prcnt mod 10 = 0 then
    begin
      FArrPercent[index] := True;
      FCustomSenderAdapter.LogWrite(PChar(Format(rsReadBytesPercent, [prcnt])));
    end;
end;

procedure TFTPSender.EndSenderExecute(aFTP: TIdFTP;
  const aSenderFileName: string; const aBuffer: TBytes);
var
  dest: string;
  ms: TMemoryStream;
  rr: TResultReceiver;
begin
  rr := FCustomSenderAdapter.ResultReceiver;
  case rr of
  rrError:
    dest := FCustomSenderAdapter.ErrorDirectory;
  rrSuccess:
    dest := FCustomSenderAdapter.SuccessDirectory;
  rrPartly:
    dest := FCustomSenderAdapter.PartDirectory;
  rrNone:
    dest := '';
  end;
  if dest <> '' then
  begin
    ms := TMemoryStream.Create;
    try
      ms.WriteBuffer(Pointer(aBuffer)^, Length(aBuffer));
      ms.SaveToFile(dest + aSenderFileName);
      if (FCustomSenderAdapter.IsDeleteSuccess) and (rr = rrSuccess) or
         (FCustomSenderAdapter.IsDeleteError) and (rr = rrError) or
         (FCustomSenderAdapter.IsDeletePart) and (rr = rrPartly) then
      begin
        aFtp.ChangeDir(FDirectory);
        aFTP.Delete(aSenderFileName);
      end;
    finally
      ms.Free;
    end;
  end;
end;

procedure TFTPSender.FinalizeAdapter;
begin
  FCustomSenderAdapter := nil;
end;

procedure TFTPSender.InitAdapter(aCustomSenderAdapter: ICustomSenderAdapter);
begin
  FCustomSenderAdapter := aCustomSenderAdapter;
end;

procedure TFTPSender.LoadSenderAdapter;
begin
  FCustomSenderAdapter.Query.Close();
  FCustomSenderAdapter.Query.SQL.Text := PROC_SND_SEL_FTPSENDER;
  FCustomSenderAdapter.Query.Parameters.ParamValues[PARAM_SND_ID_PROCESSINGSENDER] :=
    FCustomSenderAdapter.Id_ProcessingSender;
  try
    FCustomSenderAdapter.Query.Open();
    FServer := FCustomSenderAdapter.Query.FieldByName(FLD_SND_SERVER).AsString;
    FPort := FCustomSenderAdapter.Query.FieldByName(FLD_SND_PORT).AsInteger;
    FLogin := FCustomSenderAdapter.Query.FieldByName(FLD_SND_LOGIN).AsString;
    FPassword := FCustomSenderAdapter.Query.FieldByName(FLD_SND_PASSWORD).AsString;
    FDirectory := FCustomSenderAdapter.Query.FieldByName(FLD_SND_DIRECTORY).AsString;
  finally
    FCustomSenderAdapter.Query.Close();
  end;
end;

function TFTPSender.Percent(aValue, aMax: Int64): Byte;
begin
  if aMax > 0 then
    Result := aValue * 100 div aMax
  else
    Result := 0;
end;

end.
