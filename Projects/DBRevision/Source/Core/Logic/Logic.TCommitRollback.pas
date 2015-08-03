unit Logic.TCommitRollback;

interface

uses
  FireDAC.Comp.Client,
  cxGridTableView;

type
  TFuncBody = function(aId_SQLScript: Integer): string of object;
  TProcScript = procedure(aId_Template, aIndex: Integer) of object;

  TCallBackLog = procedure(const aMessage: string) of object;
  TCallBackProgress = procedure(aIndex, aCount: Integer) of object;

  TCommitRollback = class
  private
    FServer: string;
    FDataBase: string;
    FId_Template: Integer;
    FController: TcxGridTableController;
    FCRConnection: TFDConnection;
    FMainQuery: TFDQuery; // Connection DBRevision
    FCRQuery: TFDQuery;   // Connection База данных куда накатывается скрипт
    FCallBackLog: TCallBackLog;
    FCallBackProgress: TCallBackProgress;
    FLastExecutedIndex: Integer;
    function GetBodyCommit(aId_SQLScript: Integer): string;
    function GetBodyRollback(aId_SQLScript: Integer): string;
    function IsCommit(aIndex, aId_Template: Integer): Boolean;
    procedure CommitScript(aId_Template, aIndex: Integer);
    procedure ConnectedPrepare;
    procedure RollbackScript(aId_Template, aIndex: Integer);
    procedure Run(aIndex: Integer; aIsCommit: Boolean; aFuncBody: TFuncBody; aProcScript: TProcScript);
  public
    constructor Create(aMainConnection: TFDConnection; const aServer, aDataBase: string; aId_Template: Integer;
      aGridTableController: TcxGridTableController; aCallBackLog: TCallBackLog; aCallBackProgress: TCallBackProgress);
    destructor Destroy; override;
    procedure Commit;
    procedure Rollback;
    property LastExecutedIndex: Integer read FLastExecutedIndex;
  end;

implementation

uses
  System.SysUtils,
  FireDAC.Stan.Option,
  Logic.UserFunctions,
  UI.Main;

const
  STR_CONNECTION = 'Server=%s;Database=%s;OSAuthent=YES;DriverID=MSSQL';

{ TCommitRollback }

procedure TCommitRollback.Commit;
var
  k: Integer;
begin
  ConnectedPrepare();
  for k := 0 to FController.SelectedRecordCount - 1 do
    Run(k, True, GetBodyCommit, CommitScript);
end;

procedure TCommitRollback.CommitScript(aId_Template, aIndex: Integer);
begin
  FMainQuery.SQL.Text := 'rb_ins_commit :Id_Template, :Index, :Server, :DataBase';
  FMainQuery.Params.ParamValues['Id_Template'] := aId_Template;
  FMainQuery.Params.ParamValues['Index'] := aIndex;
  FMainQuery.Params.ParamValues['Server'] := FServer;
  FMainQuery.Params.ParamValues['DataBase'] := FDataBase;
  try
    FMainQuery.Open();
    FCRQuery.SQL.Text := 'INSERT INTO DBRevision (Id_Template, [Index], Id_SQLScriptCommited)'#13#10 +
                                      'VALUES (:Id_Template, :Index, :Id_SQLScriptCommited)';
    FCRQuery.Params.ParamValues['Id_Template'] := aId_Template;
    FCRQuery.Params.ParamValues['Index'] := aIndex;
    FCRQuery.Params.ParamValues['Id_SQLScriptCommited'] := FMainQuery.Fields.Fields[0].AsInteger;
    FCRQuery.ExecSQL();
  finally
    FMainQuery.Close();
  end;
end;

procedure TCommitRollback.ConnectedPrepare;
begin
  FCRConnection.ConnectionString := Format(STR_CONNECTION, [FServer, FDataBase]);
  FCRConnection.Connected := True;
  CheckDBRevision(FCRQuery);
end;

constructor TCommitRollback.Create(aMainConnection: TFDConnection; const aServer, aDataBase: string;
  aId_Template: Integer; aGridTableController: TcxGridTableController; aCallBackLog: TCallBackLog;
  aCallBackProgress: TCallBackProgress);
begin
  FServer := aServer;
  FDataBase := aDataBase;
  FId_Template := aId_Template;
  FController := aGridTableController;
  FCRConnection := TFDConnection.Create(nil);
  FCRQuery := TFDQuery.Create(nil);
  FCRQuery.Connection := FCRConnection;
  FMainQuery := TFDQuery.Create(nil);
  FMainQuery.Connection := aMainConnection;
  FMainQuery.FetchOptions.Mode := fmAll;
  FCallBackLog := aCallBackLog;
  FCallBackProgress := aCallBackProgress;
  FLastExecutedIndex := -1;
end;

destructor TCommitRollback.Destroy;
begin
  FMainQuery.Free();
  FCRQuery.Free();
  FCRConnection.Connected := False;
  FCRConnection.Free();
  inherited Destroy();
end;

function TCommitRollback.GetBodyCommit(aId_SQLScript: Integer): string;
begin
  FMainQuery.SQL.Text := 'main_sel_sqlscript_body :Id_SQLScript';
  FMainQuery.Params.ParamValues['Id_SQLScript'] := aId_SQLScript;
  try
    FMainQuery.Open();
    Result := FMainQuery.FieldByName('BodyCommit').AsString;
  finally
    FMainQuery.Close();
  end;
end;

function TCommitRollback.GetBodyRollback(aId_SQLScript: Integer): string;
begin
  FMainQuery.SQL.Text := 'main_sel_sqlscript_body :Id_SQLScript';
  FMainQuery.Params.ParamValues['Id_SQLScript'] := aId_SQLScript;
  try
    FMainQuery.Open();
    Result := FMainQuery.FieldByName('BodyRollback').AsString;
  finally
    FMainQuery.Close();
  end;
end;

function TCommitRollback.IsCommit(aIndex, aId_Template: Integer): Boolean;
begin
  FCRQuery.SQL.Text := 'SELECT [Index] FROM DBRevision WHERE [Index] = :Index AND Id_Template = :Id_Template';
  FCRQuery.Params.ParamValues['Index'] := aIndex;
  FCRQuery.Params.ParamValues['Id_Template'] := aId_Template;
  try
    Result := False;
    FCRQuery.Open();
    Result := FCRQuery.RecordCount = 1;
  finally
    FCRQuery.Close();
  end;
end;

procedure TCommitRollback.Rollback;
var
  k: Integer;
begin
  ConnectedPrepare();
  for k := FController.SelectedRecordCount - 1 downto 0 do
    Run(k, False, GetBodyRollback, RollbackScript);
end;

procedure TCommitRollback.RollbackScript(aId_Template, aIndex: Integer);
begin
  FMainQuery.SQL.Text := 'rb_del_commit :Id_Template, :Index, :Server, :DataBase';
  FMainQuery.Params.ParamValues['Id_Template'] := aId_Template;
  FMainQuery.Params.ParamValues['Index'] := aIndex;
  FMainQuery.Params.ParamValues['Server'] := FServer;
  FMainQuery.Params.ParamValues['DataBase'] := FDataBase;
  FMainQuery.ExecSQL();
  FCRQuery.SQL.Text := 'DELETE FROM DBRevision'#13#10 +
                                    'WHERE [Index] = :Index AND Id_Template = :Id_Template';
  FCRQuery.Params.ParamValues['Index'] := aIndex;
  FCRQuery.Params.ParamValues['Id_Template'] := aId_Template;
  FCRQuery.ExecSQL();
end;

procedure TCommitRollback.Run(aIndex: Integer; aIsCommit: Boolean; aFuncBody: TFuncBody; aProcScript: TProcScript);
var
  Index: Integer;
  Id_SQLScript: Integer;
  OldEscapeExpand: Boolean;
begin
  Index := FController.SelectedRecords[aIndex].Values[COL_SQLSCRIPT_INDEX];
  if ((not IsCommit(Index, FId_Template)) and (aIsCommit)) or
         (IsCommit(Index, FId_Template) and (not aIsCommit)) then
  begin
    if Assigned(FCallBackLog) then
      FCallBackLog(Format('Выполнение №%d', [Index]));
    Id_SQLScript := FController.SelectedRecords[aIndex].Values[COL_SQLSCRIPT_ID_SQLSCRIPT];
    OldEscapeExpand := FCRQuery.ResourceOptions.EscapeExpand;
    FCRQuery.ResourceOptions.EscapeExpand := False;
    FCRQuery.SQL.Text := Format('EXEC (%s)', [QuotedStr(aFuncBody(Id_SQLScript))]);
    FCRQuery.Connection.StartTransaction();
    try
      try
        FMainQuery.Connection.StartTransaction();
        try
          FCRQuery.ExecSQL();
          FLastExecutedIndex := Index;
          aProcScript(FId_Template, Index);
          FMainQuery.Connection.Commit();
        except
          FMainQuery.Connection.Rollback();
          raise;
        end;
        FCRQuery.Connection.Commit();
      except
        FCRQuery.Connection.Rollback();
        raise;
      end;
    finally
      FCRQuery.ResourceOptions.EscapeExpand := OldEscapeExpand;
    end;
  end;
  if Assigned(FCallBackProgress) then
    FCallBackProgress(aIndex, FController.SelectedRecordCount);
end;

end.
