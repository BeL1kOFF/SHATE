unit Velcom.UI.DepartmentForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxBar, cxClasses, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridLevel, cxGrid, ActnList, DB, ADODB, cxCheckBox;

type
  TfrmDepartment = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    cxTable: TcxGridTableView;
    btnAdd: TdxBarLargeButton;
    btnEdit: TdxBarLargeButton;
    btnDelete: TdxBarLargeButton;
    colIdDepartment: TcxGridColumn;
    colName: TcxGridColumn;
    colEmail: TcxGridColumn;
    colBeginTime: TcxGridColumn;
    colEndTime: TcxGridColumn;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    btnRefresh: TdxBarLargeButton;
    acRefresh: TAction;
    qrQuery: TADOQuery;
    btnExtCode: TdxBarLargeButton;
    acExternalCode: TAction;
    colIsExternalCode: TcxGridColumn;
    colDistributionCost: TcxGridColumn;
    colIsRoundTheClock: TcxGridColumn;
    procedure acRefreshExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure cxTableCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure acExternalCodeExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acAddUpdate(Sender: TObject);
    procedure acExternalCodeUpdate(Sender: TObject);
  private
    procedure RefreshDepartments;
    procedure ShowChild(aIdDepartment: Integer);
  end;

implementation

uses
  Velcom.ISQLCursor,
  adoDBUtils,
  uMain,
  uDataModule,
  Velcom.UI.DepartmentDetailForm,
  Velcom.UI.DepartmentExternalCode;

{$R *.dfm}

{ TfrmDepartment }

procedure TfrmDepartment.acAddExecute(Sender: TObject);
begin
  ShowChild(-1);
end;

procedure TfrmDepartment.acAddUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := MainForm.CurrentUser.CanWrite;
end;

procedure TfrmDepartment.acDeleteExecute(Sender: TObject);
var
  k: Integer;
  ResultText: string;
  ResultCode: Integer;
begin
  if Application.MessageBox('Вы уверенны, что хотите удалить выделенные записи?', 'Удаление', MB_YESNO or MB_ICONQUESTION) <> ID_YES then
    Exit;
  CreateSQLCursor();
  qrQuery.Close();
  CreateTempTable(qrQuery, 'tmpDelDepartment', ['Id_Department INT']);
  try
    for k := 0 to cxTable.Controller.SelectedRecordCount - 1 do
      InsertTempTable(qrQuery, 'tmpDelDepartment', [cxTable.Controller.SelectedRecords[k].Values[0]]);
    qrQuery.SQL.Text := 'dpt_del_item';
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
    DropTempTable(qrQuery, 'tmpDelDepartment');
  end;
  case ResultCode of
    1:
      Application.MessageBox(PChar(ResultText), 'Сообщение', MB_OK or MB_ICONINFORMATION);
    0:
      Application.MessageBox(PChar(ResultText), 'Предупреждение', MB_OK or MB_ICONWARNING);
    -1:
      Application.MessageBox(PChar(ResultText), 'Ошибка', MB_OK or MB_ICONERROR);
  end;
  RefreshDepartments();
end;

procedure TfrmDepartment.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (cxTable.Controller.SelectedRecordCount > 0) and (MainForm.CurrentUser.CanWrite);
end;

procedure TfrmDepartment.acEditExecute(Sender: TObject);
begin
  ShowChild(cxTable.Controller.FocusedRecord.Values[0]);
end;

procedure TfrmDepartment.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (cxTable.Controller.FocusedRecordIndex > -1) and
    (cxTable.Controller.SelectedRecordCount = 1) and MainForm.CurrentUser.CanUser;
end;

procedure TfrmDepartment.acExternalCodeExecute(Sender: TObject);
var
  frmDepartmentExternalCode: TfrmDepartmentExternalCodeForm;
begin
  frmDepartmentExternalCode := TfrmDepartmentExternalCodeForm.Create(Self);
  try
    frmDepartmentExternalCode.ShowModal();
  finally
    frmDepartmentExternalCode.Free();
  end;
  RefreshDepartments();
end;

procedure TfrmDepartment.acExternalCodeUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := MainForm.CurrentUser.CanWrite;
end;

procedure TfrmDepartment.acRefreshExecute(Sender: TObject);
begin
  RefreshDepartments();
end;

procedure TfrmDepartment.cxTableCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnEdit.Click();
end;

procedure TfrmDepartment.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmDepartment.FormShow(Sender: TObject);
begin
  RefreshDepartments();
end;

procedure TfrmDepartment.RefreshDepartments;
var
  k: Integer;
begin
  CreateSQLCursor();
  if qrQuery.Active then
    qrQuery.Close();
  qrQuery.SQL.Text := 'dpt_sel_itemlist :Id_User';
  qrQuery.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
  qrQuery.Open();
  qrQuery.First;
  cxTable.BeginUpdate();
  try
    cxTable.DataController.RecordCount := qrQuery.RecordCount;
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cxTable.DataController.Values[k, 0] := qrQuery.FieldByName('Id_Department').AsInteger;
      cxTable.DataController.Values[k, 1] := qrQuery.FieldByName('Name').AsString;
      cxTable.DataController.Values[k, 2] := qrQuery.FieldByName('EMail').AsVariant;
      cxTable.DataController.Values[k, 3] := qrQuery.FieldByName('BeginTime').AsDateTime;
      cxTable.DataController.Values[k, 4] := qrQuery.FieldByName('EndTime').AsDateTime;
      cxTable.DataController.Values[k, 5] := qrQuery.FieldByName('IsRoundTheClock').AsBoolean;
      cxTable.DataController.Values[k, 6] := qrQuery.FieldByName('IsExternalCode').AsBoolean;
      cxTable.DataController.Values[k, 7] := qrQuery.FieldByName('DistributionCost').AsString;
      qrQuery.Next();
    end;
  finally
    qrQuery.Close();
    cxTable.EndUpdate();
  end;
end;

procedure TfrmDepartment.ShowChild(aIdDepartment: Integer);
var
  frmDepartmentDetail: TfrmDepartmentDetail;
begin
  frmDepartmentDetail := TfrmDepartmentDetail.Create(Self, aIdDepartment);
  try
    frmDepartmentDetail.ShowModal();
  finally
    frmDepartmentDetail.Free();
  end;
  RefreshDepartments();
end;

end.
