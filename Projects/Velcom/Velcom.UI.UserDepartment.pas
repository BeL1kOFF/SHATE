unit Velcom.UI.UserDepartment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridBandedTableView, cxClasses,
  cxGridCustomView, cxGrid, StdCtrls, ExtCtrls, dxBar, ActnList, DB, ADODB;

type
  TfrmUserDepartment = class(TForm)
    Panel11: TPanel;
    cxGrid: TcxGrid;
    cxTable: TcxGridBandedTableView;
    cxTableColumn1: TcxGridBandedColumn;
    cxTableColumn2: TcxGridBandedColumn;
    cxLevel: TcxGridLevel;
    dxBarManager1: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    ActionList: TActionList;
    acRefresh: TAction;
    acSave: TAction;
    qrQuery: TADOQuery;
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure RefreshUD;
    procedure Save;
  public
    { Public declarations }
  end;

implementation

uses
  uMain,
  uDataModule,
  Velcom.ISQLCursor,
  USysGlobal,
  cxCheckBox;

{$R *.dfm}

procedure TfrmUserDepartment.acRefreshExecute(Sender: TObject);
begin
  RefreshUD();
end;

procedure TfrmUserDepartment.acSaveExecute(Sender: TObject);
begin
  Save();
end;

procedure TfrmUserDepartment.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.ViewData.RecordCount > 0;
end;

procedure TfrmUserDepartment.FormShow(Sender: TObject);
begin
  RefreshUD();
end;

procedure TfrmUserDepartment.RefreshUD;
var
  k, i: Integer;
  column: TcxGridBandedColumn;
begin
  CreateSQLCursor();
  if qrQuery.Active then
    qrQuery.Close;
  qrQuery.SQL.Text := 'usrdep_sel_userdepartment';
  cxTable.BeginUpdate;
  while cxTable.ColumnCount > 2 do
    cxTable.Columns[2].Free;
  try
    qrQuery.Open;
    for k := 2 to qrQuery.FieldCount - 1 do
    begin
      column := cxTable.CreateColumn;
      column.Caption := Copy(qrQuery.Fields.Fields[k].FieldName, Pos('-', qrQuery.Fields.Fields[k].FieldName) + 2, Length(qrQuery.Fields.Fields[k].FieldName));
      column.Tag := StrToInt(Copy(qrQuery.Fields.Fields[k].FieldName, 1, Pos('-', qrQuery.Fields.Fields[k].FieldName) - 2));
      column.HeaderAlignmentHorz := taCenter;
      column.Position.BandIndex := 1;
      column.PropertiesClass := TcxCheckBoxProperties;
      (column.Properties as TcxCheckBoxProperties).NullStyle := nssInactive;
      (column.Properties as TcxCheckBoxProperties).ImmediatePost := True;
    end;
    cxTable.DataController.RecordCount := qrQuery.RecordCount;
    qrQuery.First;
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cxTable.DataController.Values[k, 0] := qrQuery.FieldByName('Id_User').AsInteger;
      cxTable.DataController.Values[k, 1] := qrQuery.FieldByName('UserName').AsString;
      for i := 2 to qrQuery.FieldCount - 1 do
        cxTable.DataController.Values[k, i] := qrQuery.Fields.Fields[i].AsInteger <> 0;
      qrQuery.Next;
    end;
  finally
    cxTable.EndUpdate;
  end;
end;

procedure TfrmUserDepartment.Save;
var
  k, i: Integer;
  ResultText: string;
  IsError: Boolean;
begin
  CreateSQLCursor();
  if qrQuery.Active then
    qrQuery.Close;
  qrQuery.Connection.BeginTrans;
  try
    IsError := False;
    ResultText := 'Данные сохранены';
    for k := 0 to cxTable.DataController.RecordCount - 1 do
    begin
      for i := 2 to cxTable.ColumnCount - 1 do
      begin
        if qrQuery.Active then
          qrQuery.Close;
        qrQuery.SQL.Text := 'usrdep_edt_userdepartment :Id_User, :Id_Department, :Value';
        qrQuery.Parameters.ParamValues['Id_User'] := cxTable.DataController.Values[k, 0];
        qrQuery.Parameters.ParamValues['Id_Department'] := cxTable.Columns[i].Tag;
        qrQuery.Parameters.ParamValues['Value'] := cxTable.DataController.Values[k, i];
        qrQuery.Open;
        if qrQuery.Fields.Fields[0].AsInteger = -1 then
        begin
          IsError := True;
          ResultText := qrQuery.Fields.Fields[1].AsString;
          Break;
        end;
      end;
      if IsError then
        Break;
    end;
    qrQuery.Close;
    if IsError then
      qrQuery.Connection.RollbackTrans
    else
      qrQuery.Connection.CommitTrans;
    MsgBoxInfo(ResultText);
  except
    qrQuery.Connection.RollbackTrans;
  end;
end;

end.
