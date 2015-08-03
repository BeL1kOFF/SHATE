unit Velcom.UI.EmployeeForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxClasses, cxGridCustomView, cxGrid, DB,
  ADODB, ActnList, dxBar, cxTimeEdit, cxCheckBox;

type
  TfrmEmployeeForm = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    btnAdd: TdxBarLargeButton;
    btnEdit: TdxBarLargeButton;
    btnDelete: TdxBarLargeButton;
    btnRefresh: TdxBarLargeButton;
    btnExtCode: TdxBarLargeButton;
    ActionList: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    acRefresh: TAction;
    acExternalCode: TAction;
    qrQuery: TADOQuery;
    cxGrid: TcxGrid;
    cxTable: TcxGridTableView;
    cxLevel: TcxGridLevel;
    colIdEmployee: TcxGridColumn;
    colName: TcxGridColumn;
    colDepartment: TcxGridColumn;
    colNumber: TcxGridColumn;
    colBeginTime: TcxGridColumn;
    colEndTime: TcxGridColumn;
    colIsExternalCode: TcxGridColumn;
    procedure acRefreshExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure cxTableCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure acExternalCodeExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acAddUpdate(Sender: TObject);
    procedure acExternalCodeUpdate(Sender: TObject);
  private
    procedure RefreshEmployee;
    procedure ShowChild(aIdEmployee: Integer);
  public
    { Public declarations }
  end;

implementation

uses
  Velcom.ISQLCursor,
  adoDBUtils,
  uMain,
  Velcom.UI.EmployeeDetail,
  Velcom.UI.EmployeeExternalCode;

{$R *.dfm}

{ TfrmEmployeeForm }

procedure TfrmEmployeeForm.acAddExecute(Sender: TObject);
begin
  ShowChild(-1);
end;

procedure TfrmEmployeeForm.acAddUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := MainForm.CurrentUser.CanWrite;
end;

procedure TfrmEmployeeForm.acDeleteExecute(Sender: TObject);
var
  k: Integer;
  ResultText: string;
  ResultCode: Integer;
begin
  if Application.MessageBox('Вы уверенны, что хотите удалить выделенные записи?', 'Удаление', MB_YESNO or MB_ICONQUESTION) <> ID_YES then
    Exit;
  CreateSQLCursor();
  qrQuery.Close();
  CreateTempTable(qrQuery, 'tmpDelEmployee', ['Id_Employee INT']);
  try
    for k := 0 to cxTable.Controller.SelectedRecordCount - 1 do
      InsertTempTable(qrQuery, 'tmpDelEmployee', [cxTable.Controller.SelectedRecords[k].Values[0]]);
    qrQuery.SQL.Text := 'empl_del_item';
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
  finally
    DropTempTable(qrQuery, 'tmpDelEmployee');
  end;
  case ResultCode of
    1:
      Application.MessageBox(PChar(ResultText), 'Сообщение', MB_OK or MB_ICONINFORMATION);
    0:
      Application.MessageBox(PChar(ResultText), 'Предупреждение', MB_OK or MB_ICONWARNING);
    -1:
      Application.MessageBox(PChar(ResultText), 'Ошибка', MB_OK or MB_ICONERROR);
  end;
  RefreshEmployee();
end;

procedure TfrmEmployeeForm.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (cxTable.Controller.SelectedRecordCount > 0) and MainForm.CurrentUser.CanWrite;
end;

procedure TfrmEmployeeForm.acEditExecute(Sender: TObject);
begin
  ShowChild(cxTable.Controller.FocusedRecord.Values[0]);
end;

procedure TfrmEmployeeForm.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (cxTable.Controller.FocusedRecordIndex > -1) and
    (cxTable.Controller.SelectedRecordCount = 1) and MainForm.CurrentUser.CanWrite;
end;

procedure TfrmEmployeeForm.acExternalCodeExecute(Sender: TObject);
var
  frmEmployeeExternalCode: TfrmEmployeeExternalCode;
begin
  frmEmployeeExternalCode := TfrmEmployeeExternalCode.Create(Self);
  try
    frmEmployeeExternalCode.ShowModal();
  finally
    frmEmployeeExternalCode.Free();
  end;
end;

procedure TfrmEmployeeForm.acExternalCodeUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := MainForm.CurrentUser.CanWrite;
end;

procedure TfrmEmployeeForm.acRefreshExecute(Sender: TObject);
begin
  RefreshEmployee();
end;

procedure TfrmEmployeeForm.cxTableCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnEdit.Click();
end;

procedure TfrmEmployeeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmEmployeeForm.FormShow(Sender: TObject);
begin
  RefreshEmployee();
end;

procedure TfrmEmployeeForm.RefreshEmployee;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := 'empl_sel_itemlist :Id_User';
  qrQuery.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
  qrQuery.Open();
  qrQuery.First();
  cxTable.BeginUpdate();
  try
    cxTable.DataController.RecordCount := qrQuery.RecordCount;
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cxTable.DataController.Values[k, 0] := qrQuery.FieldByName('Id_Employee').AsInteger;
      cxTable.DataController.Values[k, 1] := qrQuery.FieldByName('Name').AsString;
      cxTable.DataController.Values[k, 2] := qrQuery.FieldByName('DepartmentName').AsString;
      cxTable.DataController.Values[k, 3] := qrQuery.FieldByName('Number').AsString;
      cxTable.DataController.Values[k, 4] := qrQuery.FieldByName('BeginTime').AsVariant;
      cxTable.DataController.Values[k, 5] := qrQuery.FieldByName('EndTime').AsVariant;
      cxTable.DataController.Values[k, 6] := qrQuery.FieldByName('IsExternalCode').AsBoolean;
      qrQuery.Next();
    end;
  finally
    qrQuery.Close();
    cxTable.EndUpdate();
  end;
end;

procedure TfrmEmployeeForm.ShowChild(aIdEmployee: Integer);
var
  frmEmployeeDetail: TfrmEmployeeDetail;
begin
  frmEmployeeDetail := TfrmEmployeeDetail.Create(Self, aIdEmployee);
  try
    frmEmployeeDetail.ShowModal();
  finally
    frmEmployeeDetail.Free();
  end;
  RefreshEmployee();
end;

end.
