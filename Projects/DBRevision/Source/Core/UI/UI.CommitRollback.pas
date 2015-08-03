unit UI.CommitRollback;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, System.Actions, Vcl.ActnList, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, Data.DB, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGrid, cxContainer, cxProgressBar, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  cxCheckBox, cxTextEdit, cxMaskEdit, cxDropDownEdit;

type
  TfrmCommitRollback = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnRun: TButton;
    btnCancel: TButton;
    ActionList: TActionList;
    acRun: TAction;
    acCancel: TAction;
    Panel4: TPanel;
    qrQuery: TFDQuery;
    Panel3: TPanel;
    mLog: TMemo;
    Panel5: TPanel;
    Panel6: TPanel;
    cxGrid: TcxGrid;
    tblServer: TcxGridTableView;
    tblServerColumn1: TcxGridColumn;
    tblServerColumn2: TcxGridColumn;
    tblServerColumn3: TcxGridColumn;
    cxGridLevel: TcxGridLevel;
    cxProgressBar: TcxProgressBar;
    cmbProfile: TcxComboBox;
    FDConnectionCommitRollback: TFDConnection;
    procedure FormShow(Sender: TObject);
    procedure acRunUpdate(Sender: TObject);
    procedure acRunExecute(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure cmbProfilePropertiesChange(Sender: TObject);
  private
    FIsCommit: Boolean;
    FIsError: Boolean;
    function IsCheckServerList: Boolean;
    procedure RefreshProfile;
    procedure RefreshServerList(aId_Profile: Integer);
    procedure CallBackLog(const aMessage: string);
    procedure CallBackProgress(aIndex, aCount: Integer);
  public
    constructor Create(aOwner: TComponent; aIsCommit: Boolean); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  Logic.TCommitRollback,
  UI.Main;

const
  STR_CONNECTION = 'Server=%s;Database=%s;OSAuthent=YES;DriverID=MSSQL';

{ TfrmCommitRollback }

procedure TfrmCommitRollback.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmCommitRollback.acRunExecute(Sender: TObject);
var
  k: Integer;
  FCommitRollback: TCommitRollback;
begin
  if not IsCheckServerList then
    Exit;
  cxProgressBar.Properties.Min := 1;
  cxProgressBar.Properties.Max := tblServer.Controller.SelectedRecordCount * frmMain.tblSQLScript.Controller.SelectedRecordCount;
  cxProgressBar.Position := 0;
  for k := 0 to tblServer.Controller.SelectedRecordCount - 1 do
  begin
    mLog.Lines.Add(Format('Обработка %s.%s', [tblServer.Controller.SelectedRecords[k].Values[0],
      tblServer.Controller.SelectedRecords[k].Values[1]]));
    FCommitRollback := TCommitRollback.Create(frmMain.FDConnection, tblServer.Controller.SelectedRecords[k].Values[0],
      tblServer.Controller.SelectedRecords[k].Values[1], frmMain.Id_Template, frmMain.tblSQLScript.Controller,
      CallBackLog, CallBackProgress);
    try
      if FIsCommit then
        FCommitRollback.Commit()
      else
        FCommitRollback.Rollback();
      tblServer.DataController.Values[k, 2] := True;
      FCommitRollback.Free();
    except on E: Exception do
    begin
      FIsError := True;
      mLog.Lines.Add(Format('ОШИБКА!!! %s', [E.Message]));
      FCommitRollback.Free();
    end;
    end;
    cxProgressBar.Position := (k + 1) * frmMain.tblSQLScript.Controller.SelectedRecordCount;
    cxProgressBar.Update();
    cxGrid.Update();
  end;
  if not FIsError then
    Close();
end;

procedure TfrmCommitRollback.acRunUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblServer.Controller.SelectedRecordCount > 0) and (not FIsError);
end;

procedure TfrmCommitRollback.CallBackLog(const aMessage: string);
begin
  mLog.Lines.Add(aMessage);
end;

procedure TfrmCommitRollback.CallBackProgress(aIndex, aCount: Integer);
begin
  cxProgressBar.Position := cxProgressBar.Position + 1;
  cxProgressBar.Update();
end;

procedure TfrmCommitRollback.cmbProfilePropertiesChange(Sender: TObject);
begin
  if (Sender as TcxComboBox).ItemIndex > -1 then
    RefreshServerList(Integer((Sender as TcxComboBox).Properties.Items.Objects[(Sender as TcxComboBox).ItemIndex]))
  else
    tblServer.DataController.RecordCount := 0;
end;

constructor TfrmCommitRollback.Create(aOwner: TComponent; aIsCommit: Boolean);
begin
  inherited Create(aOwner);
  FIsCommit := aIsCommit;
  FIsError := False;
end;

procedure TfrmCommitRollback.FormShow(Sender: TObject);
begin
  RefreshProfile();
end;

function TfrmCommitRollback.IsCheckServerList: Boolean;
var
  k: Integer;
begin
  Result := True;
  for k := 0 to tblServer.Controller.SelectedRecordCount - 1 do
  begin
    FDConnectionCommitRollback.ConnectionString := Format(STR_CONNECTION, [tblServer.Controller.SelectedRecords[k].Values[0],
      tblServer.Controller.SelectedRecords[k].Values[1]]);
    try
      FDConnectionCommitRollback.Connected := True;
    except on E: Exception do
    begin
      Result := False;
      FDConnectionCommitRollback.Connected := False;
      mLog.Lines.Add(Format('Сервер: %s.%s', [tblServer.Controller.SelectedRecords[k].Values[0],
        tblServer.Controller.SelectedRecords[k].Values[1]]));
      mLog.Lines.Add(Format('Ошибка подключения %s', [E.Message]));
      Break;
    end;
    end;
    FDConnectionCommitRollback.Connected := False;
  end;
end;

procedure TfrmCommitRollback.RefreshProfile;
var
  k: Integer;
begin
  qrQuery.SQL.Text := 'rb_sel_profilelist';
  try
    qrQuery.Open();
    qrQuery.First();
    cmbProfile.Properties.Items.BeginUpdate();
    try
      cmbProfile.Properties.Items.Clear();
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        cmbProfile.Properties.Items.AddObject(qrQuery.FieldByName('Name').AsString,
          TObject(qrQuery.FieldByName('Id_Profile').AsInteger));
        qrQuery.Next();
      end;
    finally
      cmbProfile.Properties.Items.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
  cmbProfile.ItemIndex := -1;
end;

procedure TfrmCommitRollback.RefreshServerList(aId_Profile: Integer);
var
  k: Integer;
begin
  qrQuery.SQL.Text := 'rb_sel_serverlist :Id_Profile, :Id_Template';
  qrQuery.Params.ParamValues['Id_Profile'] := aId_Profile;
  qrQuery.Params.ParamValues['Id_Template'] := frmMain.Id_Template;
  try
    qrQuery.Open();
    qrQuery.First();
    tblServer.BeginUpdate();
    try
      tblServer.DataController.RecordCount := qrQuery.RecordCount;
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        tblServer.DataController.Values[k, 0] := qrQuery.FieldByName('Server').AsString;
        tblServer.DataController.Values[k, 1] := qrQuery.FieldByName('DataBase').AsString;
        tblServer.DataController.Values[k, 2] := False;
        qrQuery.Next();
      end;
    finally
      tblServer.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

end.
