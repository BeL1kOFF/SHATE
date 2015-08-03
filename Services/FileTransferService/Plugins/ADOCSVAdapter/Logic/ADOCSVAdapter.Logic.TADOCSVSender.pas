unit ADOCSVAdapter.Logic.TADOCSVSender;

interface

uses
  Data.Win.ADODB,
  Package.CustomInterface.ICustomSenderAdapter,
  Package.CustomInterface.ISenderAdapter;

type
  TADOCSVSender = class(TInterfacedObject, ISenderAdapter)
  private
    FADOConection: TADOConnection;
    FCustomSenderAdapter: ICustomSenderAdapter;
    procedure BeginSenderExecute;
    procedure FinalizeAdapter;
    procedure InitAdapter(aCustomSenderAdapter: ICustomSenderAdapter);
    procedure LoadSenderAdapter;
  end;

implementation

uses
  System.Classes,
  Data.DB,
  System.IOUtils,
  System.SysUtils,
  ADOCSVAdapter.Logic.XMLOptions;

resourcestring
  rsSendFileReceiver = 'Файл отправляется получателям...';

{ TADOCSVSender }

procedure TADOCSVSender.BeginSenderExecute;
type
  OEMString = type AnsiString(866);
var
  qrQuery, qrQueryExec: TADOQuery;
  id: Integer;
  blob: TMemoryStream;
  tmpString: OEMString;
  tmpBuffer: TBytes;
begin
  FADOConection.Connected := True;
  while FADOConection.InTransaction do
    FADOConection.RollbackTrans;
  qrQuery := TADOQuery.Create(nil);
  qrQueryExec := TADOQuery.Create(nil);
  try
    qrQuery.Connection := FADOConection;
    qrQuery.CommandTimeout := 60000;
    qrQueryExec.Connection := FADOConection;
    qrQueryExec.CommandTimeout := 60000;
    qrQuery.SQL.Text := 'SELECT smet.KeyField, smet.[Data BLOB] FROM [Shate-M$BLOB Export Table] smet WITH (UPDLOCK, ROWLOCK) WHERE smet.[Data sending] = 0 AND smet.[Error Count] < 5 AND smet.[Export Code] = ''TMS_GOOGLE''';
    FADOConection.BeginTrans;
    try
      qrQuery.Open();
      qrQuery.First;
      while not qrQuery.Eof do
      begin
        id := qrQuery.FieldByName('KeyField').AsInteger;
        blob := TADOBlobStream.Create(TBlobField(qrQuery.FieldByName('Data BLOB')), bmRead);
        SetLength(tmpString, blob.Size);
        Move(blob.Memory^, tmpString[1], blob.Size);
        blob.Free();
        SetLength(tmpBuffer, Length(tmpString));
        Move(tmpString[1], tmpBuffer[0], Length(tmpString));
        FCustomSenderAdapter.Buffer := tmpBuffer;
        FCustomSenderAdapter.LogWrite(PChar(rsSendFileReceiver));
        FCustomSenderAdapter.ReceiverExecute('');
        if FCustomSenderAdapter.ResultReceiver = rrSuccess then
        begin
          qrQueryExec.SQL.Text := 'UPDATE [Shate-M$BLOB Export Table] SET [Data sending] = 1 WHERE KeyField = :KeyField';
          qrQueryExec.Parameters.ParamValues['KeyField'] := id;
          qrQueryExec.ExecSQL;
        end
        else
        begin
          qrQueryExec.SQL.Text := 'UPDATE [Shate-M$BLOB Export Table] SET [Error Text] = :ErrorText, [Error Count] = [Error Count] + 1 WHERE KeyField = :KeyField';
          qrQueryExec.Parameters.ParamValues['KeyField'] := id;
          qrQueryExec.Parameters.ParamValues['ErrorText'] := 'Unknown Error';
          qrQueryExec.ExecSQL;
        end;
        qrQuery.Next();
      end;
      qrQuery.Close();
      FADOConection.CommitTrans;
    except
      FADOConection.RollbackTrans;
    end;
  finally
    qrQueryExec.Free();
    qrQuery.Free();
    FADOConection.Connected := False;
  end;
end;

procedure TADOCSVSender.FinalizeAdapter;
begin
  FADOConection.Free();
  FCustomSenderAdapter := nil;
end;

procedure TADOCSVSender.InitAdapter(aCustomSenderAdapter: ICustomSenderAdapter);
begin
  FCustomSenderAdapter := aCustomSenderAdapter;
  FADOConection := TADOConnection.Create(nil);
  FADOConection.ConnectionString := Format('Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=True;Initial Catalog=%s;Data Source=%s',
    [Loadxml('TMS.xml').Options.Db, Loadxml('TMS.xml').Options.Server]);
  FADOConection.CommandTimeout := 60000;
  FADOConection.LoginPrompt := False;
end;

procedure TADOCSVSender.LoadSenderAdapter;
begin

end;

end.
