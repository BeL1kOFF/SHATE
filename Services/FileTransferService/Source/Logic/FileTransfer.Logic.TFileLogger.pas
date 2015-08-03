unit FileTransfer.Logic.TFileLogger;

interface

uses
  Data.Win.ADODB;

type
  TFileLogger = record
  private
    class function GetNull(aValue: Integer): Variant; static;
    class procedure WriteDB(const aMessage: string); overload; static;
    class procedure WriteDB(aId_Task: Integer; const aTaskName: string; aId_SenderAdapter: Integer;
      const aSenderName: string; aId_ReceiverAdapter: Integer; const aReceiverName, aText: string); overload; static;
    class procedure WriteFile(const aText: string); static;
  public
    class var
      Path: string;
      ADOConnection: TADOConnection;
    class procedure NewLog; static;
    class procedure Write(const aMessage: string); overload; static;
    class procedure Write(aId_Task: Integer; const aTaskName: string; aId_SenderAdapter: Integer;
      const aSenderName: string; aId_ReceiverAdapter: Integer; const aReceiverName, aText: string); overload; static;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  System.Variants,
  System.SyncObjs,
  System.IOUtils;

const
  CHARS_SEPARATE_LOGMESSAGE = ': ';

var
  crGlobal: TCriticalSection;

{ TFileLogger }

class procedure TFileLogger.WriteFile(const aText: string);
var
  f: TextFile;
  fileName: string;
begin
    fileName := Path + 'log.log';
    AssignFile(F, fileName, CP_UTF8);
    if TFile.Exists(fileName) then
      Append(F)
    else
      Rewrite(F);
    Writeln(F, DateTimeToStr(Now()) + ': ' + aText);
    CloseFile(F);
end;

class function TFileLogger.GetNull(aValue: Integer): Variant;
begin
  if aValue = -1 then
    Result := Null
  else
    Result := aValue;
end;

class procedure TFileLogger.NewLog;
begin
  if FileExists(Path + 'log.log') then
    RenameFile(Path + 'log.log', Format(Path + 'log_%s.log', [StringReplace(DateTimeToStr(Now()), ':', '_', [rfReplaceAll])]));
end;

class procedure TFileLogger.Write(aId_Task: Integer; const aTaskName: string; aId_SenderAdapter: Integer;
  const aSenderName: string; aId_ReceiverAdapter: Integer; const aReceiverName, aText: string);
begin
  crGlobal.Enter();
  try
    WriteFile(aTaskName + CHARS_SEPARATE_LOGMESSAGE + aSenderName + CHARS_SEPARATE_LOGMESSAGE + aReceiverName +
      CHARS_SEPARATE_LOGMESSAGE + aText);
    WriteDB(aId_Task, aTaskName, aId_SenderAdapter, aSenderName, aId_ReceiverAdapter, aReceiverName, aText);
  finally
    crGlobal.Leave();
  end;
end;

class procedure TFileLogger.WriteDB(const aMessage: string);
var
  query: TADOQuery;
begin
  if ADOConnection.Connected then
  begin
    query := TADOQuery.Create(nil);
    query.Connection := ADOConnection;
    query.SQL.Text := 'lgapp_ins_message :Message';
    query.Parameters.ParamValues['Message'] := aMessage;
    try
      query.ExecSQL;
    finally
      query.Free();
    end;
  end;
end;

class procedure TFileLogger.Write(const aMessage: string);
begin
  WriteFile(aMessage);
  WriteDB(aMessage);
end;

class procedure TFileLogger.WriteDB(aId_Task: Integer; const aTaskName: string; aId_SenderAdapter: Integer;
  const aSenderName: string; aId_ReceiverAdapter: Integer; const aReceiverName, aText: string);
var
  query: TADOQuery;
begin
  query := TADOQuery.Create(nil);
  query.Connection := ADOConnection;
  query.SQL.Text := 'lgproc_ins_message :Id_Task, :TaskName, :Id_SenderAdapter, :SenderName, :Id_ReceiverAdapter,' +
    ':ReceiverName, :Message';
  query.Parameters.ParamValues['Id_Task'] := GetNull(aId_Task);
  query.Parameters.ParamValues['TaskName'] := aTaskName;
  query.Parameters.ParamValues['Id_SenderAdapter'] := GetNull(aId_SenderAdapter);
  query.Parameters.ParamValues['SenderName'] := aSenderName;
  query.Parameters.ParamValues['Id_ReceiverAdapter'] := GetNull(aId_ReceiverAdapter);
  query.Parameters.ParamValues['ReceiverName'] := aReceiverName;
  query.Parameters.ParamValues['Message'] := aText;
  try
    query.ExecSQL;
  finally
    query.Free();
  end;
end;

initialization
  crGlobal := TCriticalSection.Create();
finalization
  crGlobal.Free();

end.
