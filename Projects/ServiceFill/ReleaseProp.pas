unit ReleaseProp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, uMain,
  ADODB, DB;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    MemoNote: TMemo;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label3: TLabel;
    MemoLog: TMemo;
    Grid: TDBGridEh;
    Splitter1: TSplitter;
    Label4: TLabel;
    qBUILDS: TADOQuery;
    DataSource1: TDataSource;
    qBUILDSVERSION: TStringField;
    qBUILDSNUM: TIntegerField;
    qBUILDSPARENT_VER: TStringField;
    qBUILDSNOTE: TStringField;
    qBUILDSVER_CALC: TStringField;
    lbStatusCatalog: TLabel;
    lbStatusAnalog: TLabel;
    lbStatusOE: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    qBUILDSID: TAutoIncField;
    Timer1: TTimer;
    pnActions: TPanel;
    btDelete: TButton;
    btMoveToCurrent: TButton;
    btMoveToTemp: TButton;
    procedure qBUILDSCalcFields(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qBUILDSAfterScroll(DataSet: TDataSet);
    procedure Timer1Timer(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btMoveToCurrentClick(Sender: TObject);
    procedure GridGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
  private
    fCurrentVer, fParentVer: string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  uSysGlobal;

procedure TForm1.btDeleteClick(Sender: TObject);
var
  s: string;
begin
  s := FormMain.ExecuteSimpleSelectMS(' SELECT Cast(NUM as varchar(20))  + '' - ['' + VERSION + '']'' FROM BUILDS WHERE PARENT_VER = :VERSION ', [qBUILDSVERSION.AsString]);
  if s <> '' then
  begin
    MsgBoxWarn('Эта сборка является родительской для сборки ' + s + '.'#13#10 +
               'Удаление невозможно.');
    Exit;
  end;

  if not MsgBoxYN('Действительно хотите удалить сборку ' + qBUILDSVER_CALC.AsString) then
    Exit;

  FormMain.ExecuteQuery('BEGIN TRAN', []);
  try
    FormMain.DeleteAllTables(qBUILDSVERSION.AsString + '_');
    FormMain.ExecuteQuery('DELETE FROM BUILDS WHERE ID = :ID', [qBUILDSID.AsInteger]);
    FormMain.ExecuteQuery('COMMIT TRAN', []);
  except
    on E: Exception do
    begin
      FormMain.ExecuteQuery('ROLLBACK TRAN', []);
      raise;
    end;
  end;
  qBUILDS.Close;
  qBUILDS.Open;
end;

procedure TForm1.btMoveToCurrentClick(Sender: TObject);
var
  s: string;
begin
  s := FormMain.ExecuteSimpleSelectMS(' SELECT Cast(NUM as varchar(20))  + '' - ['' + VERSION + '']'' FROM BUILDS WHERE PARENT_VER = :VERSION ', [qBUILDSVERSION.AsString]);
  if s <> '' then
  begin
    MsgBoxWarn('Эта сборка является родительской для сборки ' + s + '.'#13#10 +
               'Перенос невозможен.');
    Exit;
  end;

  if not MsgBoxYN('Действительно хотите сделать сборку ' + qBUILDSVER_CALC.AsString + ' текущей?'#13#10 +
                  'Текущая сборка при этом будет удалена') then
    Exit;

  FormMain.ExecuteQuery('BEGIN TRAN', []);
  try
    //удаляем текущую
    FormMain.DeleteAllTables('');
    FormMain.ExecuteQuery('DELETE FROM BUILDS WHERE ISCUR = 1', []);

    //переименовываем
    s := qBUILDSVERSION.AsString + '_';
    FormMain.RenameAllTables(qBUILDSVERSION.AsString + '_', '');
    FormMain.ExecuteQuery('UPDATE BUILDS SET ISCUR = 1 WHERE ID = :ID', [qBUILDSID.AsInteger]);
    FormMain.ExecuteQuery('COMMIT TRAN', []);
  except
    on E: Exception do
    begin
      FormMain.ExecuteQuery('ROLLBACK TRAN', []);
      raise;
    end;
  end;
  qBUILDS.Close;
  qBUILDS.Open;
end;

procedure TForm1.GridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
begin
  if Column.Field = qBUILDSPARENT_VER then
    if (Column.Field.AsString <> '') and (Column.Field.AsString = fParentVer) then
    begin
//      Grid.Canvas.Brush.Color := clRed;
//      Grid.Canvas.FrameRect(Rect);
      Grid.Canvas.Font.Color := clRed;
      Grid.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 1, Column.Field.DisplayText);
    end;
{
  if Column.Field = qBUILDSVER_CALC then
    if qBUILDSVERSION.AsString = fParentVer then
    begin
      Grid.Canvas.Brush.Color := clRed;
      Grid.Canvas.FrameRect(Rect);
    end;
}    
end;

procedure TForm1.GridGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  if Column.Field = qBUILDSVER_CALC then
    if (qBUILDSVERSION.AsString <> '') and (qBUILDSVERSION.AsString = fParentVer) then
      AFont.Color := clRed;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled := False;
  qBUILDS.Close;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  pnActions.Visible := FormMain.IsAdminPermission;
  qBUILDS.Open;
end;

procedure TForm1.qBUILDSAfterScroll(DataSet: TDataSet);
begin
  fCurrentVer := qBUILDSVERSION.AsString;
  fParentVer := qBUILDSPARENT_VER.AsString;
  Grid.Repaint;
  Timer1.Enabled := False;
  Timer1.Enabled := True;
end;

procedure TForm1.qBUILDSCalcFields(DataSet: TDataSet);
begin
  qBUILDSVER_CALC.AsString := qBUILDSNUM.AsString + ' - [' + qBUILDSVERSION.AsString + ']';
end;

procedure TForm1.Timer1Timer(Sender: TObject);
  function ApplyTableStatus(const aTableName: string; aStatusLabel: TLabel): Integer;
  var
    aCount: Integer;
  begin
    aCount := FormMain.GetTableRecordCount(aTableName);
    if aCount > 0 then
    begin
      aStatusLabel.Font.Color := clBlue;
      aStatusLabel.Caption := Format('%d зап.', [aCount]);
    end
    else
    begin
      aStatusLabel.Font.Color := clBlack;
      aStatusLabel.Caption := 'Не загружен';
    end;
    Result := aCount;
  end;
begin
  Timer1.Enabled := False;
  if not qBUILDS.Active then
    Exit;
  MemoNote.Text := qBUILDSNOTE.AsString;
  MemoLog.Text := FormMain.ExecuteSimpleSelectMS(' SELECT LOGS FROM BUILDS WHERE ID = :ID ', [qBUILDSID.AsInteger]);
  ApplyTableStatus(qBUILDSVERSION.AsString + '_CATALOG', lbStatusCatalog);
  ApplyTableStatus(qBUILDSVERSION.AsString + '_ANALOG', lbStatusAnalog);
  ApplyTableStatus(qBUILDSVERSION.AsString + '_OE', lbStatusOE);
end;

end.
