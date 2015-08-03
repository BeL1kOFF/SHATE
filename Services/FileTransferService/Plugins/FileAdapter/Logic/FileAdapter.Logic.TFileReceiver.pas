unit FileAdapter.Logic.TFileReceiver;

interface

uses
  System.SysUtils,
  Package.CustomInterface.ICustomReceiverAdapter,
  Package.CustomInterface.IReceiverAdapter;

type
  TFileReceiver = class(TInterfacedObject, IReceiverAdapter)
  private
    FTargetDirectory: string;
    FCustomReceiverAdapter: ICustomReceiverAdapter;
    function Execute(aSenderFileName: PChar; const aBuffer: TBytes): Boolean;
    procedure FinalizeAdapter;
    procedure InitAdapter(aCustomReceiverAdapter: ICustomReceiverAdapter);
    procedure LoadAdapter;
  end;

implementation

uses
  Winapi.Windows,
  System.IOUtils,
  FileAdapter.Logic.Consts;

{ TFileReceiver }

function TFileReceiver.Execute(aSenderFileName: PChar; const aBuffer: TBytes): Boolean;
var
  tmpFileName: string;
  resFileName: string;
  tmpGUID: TGUID;
  tmpPChar: array[0..MAX_PATH] of Char;
begin
  Result := False;
  try
    ZeroMemory(@tmpPChar[0], SizeOf(tmpPChar));
    FCustomReceiverAdapter.GetParseFileName(aSenderFileName, tmpPChar[0], SizeOf(tmpPChar));
    resFileName := tmpPChar;
    if (not FCustomReceiverAdapter.IsOverwrite) and (TFile.Exists(FTargetDirectory + resFileName)) then
      FCustomReceiverAdapter.LogWrite(PChar(Format(rsFileExists, [resFileName])))
    else
    begin
      if FCustomReceiverAdapter.IsUseTempFile then
      begin
        CreateGUID(tmpGUID);
        tmpFileName := FTargetDirectory + GUIDToString(tmpGUID) + '.tmp';
      end
      else
        tmpFileName := FTargetDirectory + resFileName;
      TFile.WriteAllBytes(tmpFileName, aBuffer);
      if FCustomReceiverAdapter.IsUseTempFile then
        RenameFile(tmpFileName, FTargetDirectory + resFileName);
      Result := True;
      FCustomReceiverAdapter.LogWrite(PChar(rsSendFileComplite));
    end;
  except on E: Exception do
    FCustomReceiverAdapter.LogWrite(PChar(E.Message));
  end;
end;

procedure TFileReceiver.FinalizeAdapter;
begin
  FCustomReceiverAdapter := nil;
end;

procedure TFileReceiver.InitAdapter(
  aCustomReceiverAdapter: ICustomReceiverAdapter);
begin
  FCustomReceiverAdapter := aCustomReceiverAdapter;
end;

procedure TFileReceiver.LoadAdapter;
begin
  FCustomReceiverAdapter.Query.Close();
  FCustomReceiverAdapter.Query.SQL.Text := PROC_SEL_FILERECEIVER;
  FCustomReceiverAdapter.Query.Parameters.ParamValues[PARAM_ID_PROCESSINGRECEIVER] :=
    FCustomReceiverAdapter.Id_ProcessingReceiver;
  try
    FCustomReceiverAdapter.Query.Open();
    FTargetDirectory :=
      IncludeTrailingPathDelimiter(FCustomReceiverAdapter.Query.FieldByName(FLD_TARGETDIRECTORY).AsString);
  finally
    FCustomReceiverAdapter.Query.Close();
  end;
end;

end.
