unit Velcom.UI.CallerForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxTimeEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxClasses, cxGridCustomView,
  cxGrid, DB, ADODB, dxBar, ActnList, cxDropDownEdit, cxLabel, cxBarEditItem,
  cxCalendar;

type
  TfrmCaller = class(TForm)
    ActionList: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    acRefresh: TAction;
    acExternalCode: TAction;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    btnAdd: TdxBarLargeButton;
    btnEdit: TdxBarLargeButton;
    btnDelete: TdxBarLargeButton;
    btnRefresh: TdxBarLargeButton;
    btnExtCode: TdxBarLargeButton;
    qrQuery: TADOQuery;
    cxGrid: TcxGrid;
    cxTable: TcxGridTableView;
    colIdCaller: TcxGridColumn;
    colNumber: TcxGridColumn;
    cxLevel: TcxGridLevel;
    colEmployeeName: TcxGridColumn;
    colDepartmentName: TcxGridColumn;
    dxBarManagerBar2: TdxBar;
    cmbEmployee: TcxBarEditItem;
    dxBarLargeButton1: TdxBarLargeButton;
    cxBarEditItem2: TcxBarEditItem;
    acChange: TAction;
    dtDateActive: TcxBarEditItem;
    procedure acDeleteUpdate(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure cxTableCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acAddUpdate(Sender: TObject);
    procedure acChangeUpdate(Sender: TObject);
    procedure acChangeExecute(Sender: TObject);
  private
    procedure RefreshCaller;
    procedure RefreshEmployee;
    procedure ShowChild(aIdCaller: Integer);
    procedure ApplyChangeEmployee;
  end;

implementation

uses
  adoDBUtils,
  DateUtils,
  Velcom.ISQLCursor,
  Velcom.UI.CallerDetail,
  uMain;

{$R *.dfm}

procedure TfrmCaller.acAddExecute(Sender: TObject);
begin
  ShowChild(-1);
end;

procedure TfrmCaller.acAddUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := MainForm.CurrentUser.CanWrite;
end;

procedure TfrmCaller.acChangeExecute(Sender: TObject);
var
  ComboDate: TDate;
begin
  if VarIsNull(dtDateActive.EditValue) then
    ComboDate := Today()
  else
    ComboDate := dtDateActive.EditValue;
  if Application.MessageBox(PChar(Format('Назначить номер %s сотруднику %s с %s', [string(cxTable.Controller.FocusedRecord.Values[1]),
                                                                                   VarToStrDef(cmbEmployee.EditValue, ''),
                                                                                   FormatDateTime('dd.mm.yyyy', ComboDate)])),
                            'Назначение номера', MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    ApplyChangeEmployee();
    RefreshCaller();
  end;
end;

procedure TfrmCaller.acChangeUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := MainForm.CurrentUser.CanUser and (cxTable.Controller.SelectedRecordCount = 1) and
    ((cmbEmployee.Properties as TcxComboBoxProperties).Items.IndexOf(VarToStrDef(cmbEmployee.EditValue, '')) > -1);
end;

procedure TfrmCaller.acDeleteExecute(Sender: TObject);
var
  k: Integer;
  resultText: string;
  resultCode: Integer;
begin
  if Application.MessageBox('Вы уверенны, что хотите удалить выделенные записи?', 'Удаление', MB_YESNO or MB_ICONQUESTION) <> ID_YES then
    Exit;
  CreateSQLCursor();
  qrQuery.Close();
  CreateTempTable(qrQuery, 'tmpDelCaller', ['Id_Caller INT']);
  try
    for k := 0 to cxTable.Controller.SelectedRecordCount - 1 do
      InsertTempTable(qrQuery, 'tmpDelCaller', [cxTable.Controller.SelectedRecords[k].Values[0]]);
    qrQuery.SQL.Text := 'cll_del_item';
    try
      qrQuery.Open();
      resultCode := qrQuery.Fields.Fields[0].AsInteger;
      resultText := qrQuery.Fields.Fields[1].AsString;
    except on E: Exception do
    begin
      resultCode := -1000;
      resultText := E.Message;
    end;
    end;
    qrQuery.Close();
  finally
    DropTempTable(qrQuery, 'tmpDelCaller');
  end;
  case resultCode of
    1:
      Application.MessageBox(PChar(resultText), 'Сообщение', MB_OK or MB_ICONINFORMATION);
    0:
      Application.MessageBox(PChar(resultText), 'Предупреждение', MB_OK or MB_ICONWARNING);
    -1:
      Application.MessageBox(PChar(resultText), 'Ошибка', MB_OK or MB_ICONERROR);
  end;
  RefreshCaller();
end;

procedure TfrmCaller.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (cxTable.Controller.SelectedRecordCount > 0) and MainForm.CurrentUser.CanWrite;
end;

procedure TfrmCaller.acEditExecute(Sender: TObject);
begin
  ShowChild(cxTable.Controller.FocusedRecord.Values[0]);
end;

procedure TfrmCaller.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (cxTable.Controller.FocusedRecordIndex > -1) and
    (cxTable.Controller.SelectedRecordCount = 1) and MainForm.CurrentUser.CanWrite;
end;

procedure TfrmCaller.acRefreshExecute(Sender: TObject);
begin
  RefreshCaller();
end;

procedure TfrmCaller.ApplyChangeEmployee;
var
  ResultCode: Integer;
  ResultText: string;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := 'cll_change_employee :Id_Caller, :Id_Employee, :Date';
  qrQuery.Parameters.ParamValues['Id_Caller'] := cxTable.Controller.FocusedRecord.Values[0];
  qrQuery.Parameters.ParamValues['Id_Employee'] := Integer((cmbEmployee.Properties as TcxComboBoxProperties).Items.Objects[(cmbEmployee.Properties as TcxComboBoxProperties).Items.IndexOf(VarToStrDef(cmbEmployee.EditValue, ''))]);
  if VarIsNull(dtDateActive.EditValue) then
    qrQuery.Parameters.ParamValues['Date'] := FormatDateTime('yyyymmdd', Today())
  else
    qrQuery.Parameters.ParamValues['Date'] := FormatDateTime('yyyymmdd', dtDateActive.EditValue);
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
  if ResultCode <= -1 then
    Application.MessageBox(PChar(ResultText), 'Ошибка', MB_OK or MB_ICONERROR)
  else
    if ResultCode = 0 then
      Application.MessageBox(PChar(ResultText), 'Предупреждение', MB_OK or MB_ICONWARNING)
    else
      Application.MessageBox(PChar(ResultText), 'Сообщение', MB_OK or MB_ICONINFORMATION);
end;

procedure TfrmCaller.cxTableCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnEdit.Click();
end;

procedure TfrmCaller.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmCaller.FormShow(Sender: TObject);
begin
  dtDateActive.EditValue := Today();
  RefreshEmployee();
  RefreshCaller();
end;

procedure TfrmCaller.RefreshCaller;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := 'cll_sel_itemlist :Id_User';
  qrQuery.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
  qrQuery.Open();
  try
    qrQuery.First();
    cxTable.BeginUpdate();
    try
      cxTable.DataController.RecordCount := qrQuery.RecordCount;
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        cxTable.DataController.Values[k, 0] := qrQuery.FieldByName('Id_Caller').AsInteger;
        cxTable.DataController.Values[k, 1] := qrQuery.FieldByName('Number').AsString;
        cxTable.DataController.Values[k, 2] := qrQuery.FieldByName('EmployeeName').AsString;
        cxTable.DataController.Values[k, 3] := qrQuery.FieldByName('DepartmentName').AsString;
        qrQuery.Next();
      end;
    finally
      cxTable.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmCaller.RefreshEmployee;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := 'cll_sel_employeelist_main :Id_User';
  qrQuery.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
  qrQuery.Open();
  try
    cmbEmployee.Properties.BeginUpdate();
    try
      (cmbEmployee.Properties as TcxComboBoxProperties).Items.Clear();
      qrQuery.First();
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        (cmbEmployee.Properties as TcxComboBoxProperties).Items.AddObject(qrQuery.FieldByName('Name').AsString,
          TObject(qrQuery.FieldByName('Id_Employee').AsInteger));
        qrQuery.Next();
      end;
    finally
      cmbEmployee.Properties.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmCaller.ShowChild(aIdCaller: Integer);
var
  frmCallerDetail: TfrmCallerDetail;
begin
  frmCallerDetail := TfrmCallerDetail.Create(Self, aIdCaller);
  try
    frmCallerDetail.ShowModal();
  finally
    frmCallerDetail.Free();
  end;
  RefreshCaller();
end;

end.
