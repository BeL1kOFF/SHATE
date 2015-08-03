unit FileAdapter.Logic.TFileSender;

interface

uses
  Package.CustomInterface.ICustomSenderAdapter,
  Package.CustomInterface.ISenderAdapter;

type
  TFileSender = class(TInterfacedObject, ISenderAdapter)
  private
    FSourceDirectory: string;
    FCustomSenderAdapter: ICustomSenderAdapter;
    procedure BeginSenderExecute;
    procedure EndSenderExecute(const aSenderFileName: string);
    procedure FinalizeAdapter;
    procedure InitAdapter(aCustomSenderAdapter: ICustomSenderAdapter);
    procedure LoadSenderAdapter;
  end;

implementation

uses
  System.Types,
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  FileAdapter.Logic.Consts;

{ TFileSender }

procedure TFileSender.BeginSenderExecute;
var
  fs: TFileStream;
  fileList: TStringDynArray;
  fileItem: string;
  fileName: string;
  tmpBuffer: TBytes;
begin
  fileList := TDirectory.GetFiles(FSourceDirectory);
  for fileItem in fileList do
  begin
    fileName := ExtractFileName(fileItem);
    if not FCustomSenderAdapter.InMaskList(PChar(fileName)) then
      System.Continue;
    FCustomSenderAdapter.LogWrite(PChar(Format(rsFindFile, [fileName])));
    try
      fs := TFile.Open(fileItem, TFileMode.fmOpen, TFileAccess.faRead, TFileShare.fsNone);
      try
        SetLength(tmpBuffer, fs.Size);
        if fs.Size > 0 then
          fs.ReadBuffer(Pointer(tmpBuffer)^, fs.Size);
        FCustomSenderAdapter.Buffer := tmpBuffer;
        FCustomSenderAdapter.LogWrite(PChar(rsSendFileReceiver));
        FCustomSenderAdapter.ReceiverExecute(PChar(fileName));
      finally
        fs.Free();
      end;
      EndSenderExecute(fileName);
    except on E: Exception do
    begin
      FCustomSenderAdapter.LogWrite(PChar(E.Message));
      SetLength(tmpBuffer, 0);
    end;
    end;
  end;
end;

procedure TFileSender.EndSenderExecute(const aSenderFileName: string);
var
  source, dest: string;
  rr: TResultReceiver;
begin
  source := FSourceDirectory + aSenderFileName;
  rr := FCustomSenderAdapter.ResultReceiver;
  case rr of
  rrError:
    dest := FCustomSenderAdapter.ErrorDirectory + aSenderFileName;
  rrSuccess:
    dest := FCustomSenderAdapter.SuccessDirectory + aSenderFileName;
  rrPartly:
    dest := FCustomSenderAdapter.PartDirectory + aSenderFileName;
  rrNone:
    dest := '';
  end;
  if (source <> '') and (dest <> '') then
    if (FCustomSenderAdapter.IsDeleteSuccess) and (rr = rrSuccess) or
       (FCustomSenderAdapter.IsDeleteError) and (rr = rrError) or
       (FCustomSenderAdapter.IsDeletePart) and (rr = rrPartly) then
      TFile.Move(source, dest)
    else
      TFile.Copy(source, dest);
end;

procedure TFileSender.FinalizeAdapter;
begin
  FCustomSenderAdapter := nil;
end;

procedure TFileSender.InitAdapter(aCustomSenderAdapter: ICustomSenderAdapter);
begin
  FCustomSenderAdapter := aCustomSenderAdapter;
end;

procedure TFileSender.LoadSenderAdapter;
begin
  FCustomSenderAdapter.Query.Close();
  FCustomSenderAdapter.Query.SQL.Text := PROC_SEL_FILESENDER;
  FCustomSenderAdapter.Query.Parameters.ParamValues[PARAM_ID_PROCESSINGSENDER] :=
    FCustomSenderAdapter.Id_ProcessingSender;
  try
    FCustomSenderAdapter.Query.Open();
    FSourceDirectory := FCustomSenderAdapter.Query.FieldByName(FLD_SOURCEDIRECTORY).AsString;
  finally
    FCustomSenderAdapter.Query.Close();
  end;
end;

end.
