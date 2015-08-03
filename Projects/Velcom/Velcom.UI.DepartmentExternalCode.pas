unit Velcom.UI.DepartmentExternalCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxClasses, dxBar, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridLevel, cxGrid,
  ActnList, DB, ADODB, cxGridBandedTableView, cxTextEdit;

type
  TfrmDepartmentExternalCodeForm = class(TForm)
    dxBarManager1: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    dxBarLargeButton1: TdxBarLargeButton;
    ActionList1: TActionList;
    acRefresh: TAction;
    qrQuery: TADOQuery;
    cxTable: TcxGridBandedTableView;
    cxTableColumn1: TcxGridBandedColumn;
    cxTableColumn2: TcxGridBandedColumn;
    dxBarLargeButton2: TdxBarLargeButton;
    procedure FormShow(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure cxTableEditValueChanged(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
  private
    procedure RefreshExtCode;
    procedure Save(const aValue: string; aIdExternalSystem: Integer);
  public
    { Public declarations }
  end;

implementation

uses
  Velcom.ISQLCursor,
  uDataModule,
  uMain;

{$R *.dfm}

{ TfrmDepartmentExternalCodeForm }

procedure TfrmDepartmentExternalCodeForm.acRefreshExecute(Sender: TObject);
begin
  RefreshExtCode();
end;

procedure TfrmDepartmentExternalCodeForm.cxTableEditValueChanged(Sender: TcxCustomGridTableView;
  AItem: TcxCustomGridTableItem);
begin
  Sender.DataController.PostEditingData;
  if VarIsNull(AItem.EditValue) then
    Save('', AItem.Tag)
  else
    Save(AItem.EditValue, AItem.Tag);
end;

procedure TfrmDepartmentExternalCodeForm.FormShow(Sender: TObject);
begin
  RefreshExtCode();
end;

procedure TfrmDepartmentExternalCodeForm.RefreshExtCode;
var
  k, i: Integer;
  column: TcxGridBandedColumn;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := 'dpt_sel_extcodelist :Id_User';
  qrQuery.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
  cxTable.BeginUpdate();
  try
    qrQuery.Open();
    while cxTable.ColumnCount > 2 do
      cxTable.Columns[2].Free();
    for k := 2 to qrQuery.FieldCount - 1 do
    begin
      column := cxTable.CreateColumn();
      column.Caption := Copy(qrQuery.Fields.Fields[k].FieldName, Pos('-', qrQuery.Fields.Fields[k].FieldName) + 2, Length(qrQuery.Fields.Fields[k].FieldName));
      column.Tag := StrToInt(Copy(qrQuery.Fields.Fields[k].FieldName, 1, Pos('-', qrQuery.Fields.Fields[k].FieldName) - 2));
      column.HeaderAlignmentHorz := taCenter;
      column.Position.BandIndex := 1;
    end;
    cxTable.DataController.RecordCount := qrQuery.RecordCount;
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cxTable.DataController.Values[k, 0] := qrQuery.FieldByName('Id_Department').AsInteger;
      cxTable.DataController.Values[k, 1] := qrQuery.FieldByName('DepartmentName').AsString;
      for i := 2 to qrQuery.FieldCount - 1 do
        cxTable.DataController.Values[k, i] := qrQuery.Fields.Fields[i].AsString;
      qrQuery.Next();
    end;  
  finally
    qrQuery.Close();
    cxTable.EndUpdate();
  end;
end;

procedure TfrmDepartmentExternalCodeForm.Save(const aValue: string; aIdExternalSystem: Integer);
var
  ResultText: string;
  ResultCode: Integer;
begin
  qrQuery.SQL.Text := 'dpt_edt_extcode :Id_Department, :DepartmentExternalCode, :Id_ExternalSystem';
  qrQuery.Parameters.ParamValues['Id_Department'] := cxTable.Controller.FocusedRecord.Values[0];
  qrQuery.Parameters.ParamValues['DepartmentExternalCode'] := aValue;
  qrQuery.Parameters.ParamValues['Id_ExternalSystem'] := aIdExternalSystem;
  try
    qrQuery.Open();
    ResultCode := qrQuery.Fields.Fields[0].AsInteger;
    ResultText := qrQuery.Fields.Fields[1].AsString;
  except on E: Exception do
  begin
    ResultCode := -1000;
    ResultText := E.Message;
  end;
  end;
  qrQuery.Close();
  if ResultCode > 0 then
  begin
    if ResultText <> '' then
      Application.MessageBox(PChar(ResultText), 'Сообщение', MB_OK or MB_ICONINFORMATION);
  end
  else
    Application.MessageBox(PChar(ResultText), 'Ошибка', MB_OK or MB_ICONERROR);
end;

end.
