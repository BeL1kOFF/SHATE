unit Velcom.UI.EmployeeDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, DB, ADODB, ActnList,
  StdCtrls, cxTextEdit, cxMaskEdit, cxSpinEdit, cxTimeEdit, ExtCtrls, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxClasses, cxGridLevel, cxGrid,
  cxDropDownEdit, cxCalendar, cxImageComboBox;

type
  TfrmEmployeeDetail = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acCancel: TAction;
    acSave: TAction;
    qrQuery: TADOQuery;
    edtName: TEdit;
    Label1: TLabel;
    cxGrid: TcxGrid;
    cxTable: TcxGridTableView;
    colName: TcxGridColumn;
    colDate: TcxGridColumn;
    cxLevel: TcxGridLevel;
    colIdDepartment: TcxGridColumn;
    cxGridNumber: TcxGrid;
    cxTableNumber: TcxGridTableView;
    colNumber: TcxGridColumn;
    colDateActive: TcxGridColumn;
    cxLevelNumber: TcxGridLevel;
    Panel3: TPanel;
    chbTime: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    teBegin: TcxTimeEdit;
    teEnd: TcxTimeEdit;
    colIdCaller: TcxGridColumn;
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure colNamePropertiesValidate(Sender: TObject; var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure cxTableDataControllerNewRecord(ADataController: TcxCustomDataController; ARecordIndex: Integer);
    procedure acSaveUpdate(Sender: TObject);
    procedure cxTableNumberDataControllerNewRecord(ADataController: TcxCustomDataController; ARecordIndex: Integer);
    procedure chbTimeClick(Sender: TObject);
    procedure colNumberPropertiesValidate(Sender: TObject; var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FIdEmployee: Integer;
    function IsCheckDepartments: Boolean;
    function IsCheckNumbers: Boolean;
    function Save: Boolean;
    procedure FillCbDepartment;
    procedure FillCbCaller;
    procedure ReadItem;
    procedure FillTime;
  public
    constructor Create(aOwner: TComponent; aIdEmployee: Integer); reintroduce;
  end;

implementation

uses
  Velcom.ISQLCursor,
  adoDBUtils,
  uMain;

{$R *.dfm}

{ TfrmEmployeeDetail }

procedure TfrmEmployeeDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmEmployeeDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmEmployeeDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (edtName.Text <> '') and (IsCheckDepartments) and (IsCheckNumbers);
end;

procedure TfrmEmployeeDetail.chbTimeClick(Sender: TObject);
begin
  teBegin.Enabled := TCheckBox(Sender).Checked;
  teEnd.Enabled := TCheckBox(Sender).Checked;
  if TCheckBox(Sender).Checked then
    FillTime();
end;

procedure TfrmEmployeeDetail.colNamePropertiesValidate(Sender: TObject; var DisplayValue: Variant;
  var ErrorText: TCaption; var Error: Boolean);
begin
  Error := False;
  cxTable.Controller.FocusedRecord.Values[0] := Integer(TcxComboBox(Sender).Properties.Items.Objects[TcxComboBox(Sender).ItemIndex]);
end;

procedure TfrmEmployeeDetail.colNumberPropertiesValidate(Sender: TObject; var DisplayValue: Variant;
  var ErrorText: TCaption; var Error: Boolean);
begin
  Error := False;
  cxTableNumber.Controller.FocusedRecord.Values[0] := Integer(TcxComboBox(Sender).Properties.Items.Objects[TcxComboBox(Sender).ItemIndex]);
end;

constructor TfrmEmployeeDetail.Create(aOwner: TComponent; aIdEmployee: Integer);
begin
  inherited Create(aOwner);
  FIdEmployee := aIdEmployee;
end;

procedure TfrmEmployeeDetail.cxTableDataControllerNewRecord(ADataController: TcxCustomDataController;
  ARecordIndex: Integer);
begin
  ADataController.Values[ARecordIndex, 2] := Date();
end;

procedure TfrmEmployeeDetail.cxTableNumberDataControllerNewRecord(ADataController: TcxCustomDataController;
  ARecordIndex: Integer);
begin
  ADataController.Values[ARecordIndex, 2] := Date();
end;

procedure TfrmEmployeeDetail.FillCbCaller;
var
  k: Integer;
  cbProp: TcxComboBoxProperties;
begin
  cbProp := cxTableNumber.Columns[1].Properties as TcxComboBoxProperties;
  qrQuery.SQL.Text := 'empl_sel_callerlist';
  qrQuery.Open();
  qrQuery.First();
  cbProp.Items.Clear();
  for k := 0 to qrQuery.RecordCount - 1 do
  begin
    cbProp.Items.AddObject(qrQuery.FieldByName('Number').AsString, TObject(qrQuery.FieldByName('Id_Caller').AsInteger));
    qrQuery.Next();
  end;
  qrQuery.Close();
end;

procedure TfrmEmployeeDetail.FillCbDepartment;
var
  k: Integer;
  cbProp: TcxComboBoxProperties;
begin
  cbProp := cxTable.Columns[1].Properties as TcxComboBoxProperties;
  qrQuery.SQL.Text := 'empl_sel_departmentlist';
  qrQuery.Open();
  qrQuery.First();
  cbProp.Items.Clear();
  for k := 0 to qrQuery.RecordCount - 1 do
  begin
    cbProp.Items.AddObject(qrQuery.FieldByName('Name').AsString, TObject(qrQuery.FieldByName('Id_Department').AsInteger));
    qrQuery.Next();
  end;
  qrQuery.Close();
end;

procedure TfrmEmployeeDetail.FillTime;
begin
  if FIdEmployee = -1 then
    Exit;
  qrQuery.SQL.Text := 'empl_sel_timedepartment :Id_Employee';
  qrQuery.Parameters.ParamValues['Id_Employee'] := FIdEmployee;
  qrQuery.Open();
  teBegin.EditValue := qrQuery.FieldByName('BeginTime').AsVariant;
  teEnd.EditValue := qrQuery.FieldByName('EndTime').AsVariant;
  qrQuery.Close();
end;

procedure TfrmEmployeeDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmEmployeeDetail.FormShow(Sender: TObject);
begin
  FillCbDepartment();
  FillCbCaller();
  ReadItem();
  edtName.SetFocus();
end;

function TfrmEmployeeDetail.IsCheckDepartments: Boolean;
var
  k, i: Integer;
begin
  for k := 0 to cxTable.DataController.RecordCount - 1 do
  begin
    if (VarIsNull(cxTable.DataController.Values[k, 0])) or (VarIsNull(cxTable.DataController.Values[k, 2])) then
    begin
      Result := False;
      Exit;
    end
    else
      for i := k + 1 to cxTable.DataController.RecordCount - 1 do
        if cxTable.DataController.Values[i, 2] = cxTable.DataController.Values[k, 2] then
        begin
          Result := False;
          Exit;
        end;
  end;
  Result := True;
end;

function TfrmEmployeeDetail.IsCheckNumbers: Boolean;
var
  k, i: Integer;
begin
  for k := 0 to cxTableNumber.DataController.RecordCount - 1 do
  begin
    if (VarIsNull(cxTableNumber.DataController.Values[k, 0])) or (VarIsNull(cxTableNumber.DataController.Values[k, 2])) then
    begin
      Result := False;
      Exit;
    end
    else
      for i := k + 1 to cxTableNumber.DataController.RecordCount - 1 do
      begin
        if (cxTableNumber.DataController.Values[i, 2] = cxTableNumber.DataController.Values[k, 2]) and
           (cxTableNumber.DataController.Values[i, 0] = cxTableNumber.DataController.Values[k, 0]) then
        begin
          Result := False;
          Exit;
        end;
      end;
  end;
  Result := True;
end;

procedure TfrmEmployeeDetail.ReadItem;
var
  k: Integer;
  formatDate: TFormatSettings;
begin
  CreateSQLCursor();
  if FIdEmployee = -1 then
  begin
    edtName.Clear();
    cxTable.DataController.RecordCount := 0;
  end
  else
  begin
    qrQuery.SQL.Text := 'empl_sel_item :Id_Employee';
    qrQuery.Parameters.ParamValues['Id_Employee'] := FIdEmployee;
    qrQuery.Open();
    edtName.Text := qrQuery.FieldByName('Name').AsString;
    if VarIsNull(qrQuery.FieldByName('BeginTime').AsVariant) then
    begin
      chbTime.Checked := False;
      teBegin.Text := '00:00:00';
      teEnd.Text := '00:00:00';
    end
    else
      chbTime.Checked := True;
    qrQuery.Close();
    qrQuery.SQL.Text := 'empl_sel_item_departmentlist :Id_Employee';
    qrQuery.Parameters.ParamValues['Id_Employee'] := FIdEmployee;
    qrQuery.Open();
    qrQuery.First();
    cxTable.DataController.RecordCount := qrQuery.RecordCount;
    cxTable.Site.SetFocus;
    formatDate.DateSeparator := '-';
    formatDate.ShortDateFormat := 'yyyy-mm-dd';
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cxTable.DataController.Values[k, 0] := qrQuery.FieldByName('Id_Department').AsInteger;
      cxTable.DataController.Values[k, 2] := StrToDate(qrQuery.FieldByName('DateActive').AsString, formatDate);
      cxTable.Controller.FocusedRecordIndex := k;
      cxTable.Controller.EditingController.ShowEdit(cxTable.Items[1]);
      TcxComboBox(cxTable.Controller.EditingController.Edit).ItemIndex := TcxComboBox(cxTable.Controller.EditingController.Edit).Properties.Items.IndexOf(qrQuery.FieldByName('Name').AsString);
      TcxComboBox(cxTable.Controller.EditingController.Edit).PostEditValue;
      cxTable.Controller.EditingController.HideEdit(True);
      qrQuery.Next();
    end;
    qrQuery.Close();
    qrQuery.SQL.Text := 'empl_sel_item_numberlist :Id_Employee';
    qrQuery.Parameters.ParamValues['Id_Employee'] := FIdEmployee;
    qrQuery.Open();
    qrQuery.First();
    cxTableNumber.DataController.RecordCount := qrQuery.RecordCount;
    cxTableNumber.Site.SetFocus;
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cxTableNumber.DataController.Values[k, 0] := qrQuery.FieldByName('Id_Caller').AsInteger;
      cxTableNumber.DataController.Values[k, 2] := StrToDate(qrQuery.FieldByName('DateActive').AsString, formatDate);
      cxTableNumber.Controller.FocusedRecordIndex := k;
      cxTableNumber.Controller.EditingController.ShowEdit(cxTableNumber.Items[1]);
      TcxComboBox(cxTableNumber.Controller.EditingController.Edit).ItemIndex := TcxComboBox(cxTableNumber.Controller.EditingController.Edit).Properties.Items.IndexOf(qrQuery.FieldByName('Number').AsString);
      TcxComboBox(cxTableNumber.Controller.EditingController.Edit).PostEditValue;
      cxTableNumber.Controller.EditingController.HideEdit(True);
      qrQuery.Next();
    end;
    qrQuery.Close();
  end;
end;

function TfrmEmployeeDetail.Save: Boolean;
var
  k: Integer;
  ResultCode: Integer;
  ResultText: string;
begin
  CreateSQLCursor();
  CreateTempTable(qrQuery, 'tmpEmplDepartment', ['Id_Department INT', 'DateActive DATETIME']);
  try
    for k := 0 to cxTable.DataController.RecordCount - 1 do
      InsertTempTable(qrQuery, 'tmpEmplDepartment', [cxTable.DataController.Values[k, 0],
        cxTable.DataController.Values[k, 2]]);
    CreateTempTable(qrQuery, 'tmpEmplCaller', ['Id_Caller INT', 'DateActive DATETIME']);
    try
      for k := 0 to cxTableNumber.DataController.RecordCount - 1 do
        InsertTempTable(qrQuery, 'tmpEmplCaller', [cxTableNumber.DataController.Values[k, 0],
          cxTableNumber.DataController.Values[k, 2]]);
      if FIdEmployee = -1 then
        qrQuery.SQL.Text := 'empl_ins_item :Name, :BeginTime, :EndTime'
      else
      begin
        qrQuery.SQL.Text := 'empl_edt_item :Id_Employee, :Name, :BeginTime, :EndTime';
        qrQuery.Parameters.ParamValues['Id_Employee'] := FIdEmployee;
      end;
      qrQuery.Parameters.ParamValues['Name'] := edtName.Text;
      if chbTime.Checked then
      begin
        qrQuery.Parameters.ParamValues['BeginTime'] := teBegin.Text;
        qrQuery.Parameters.ParamValues['EndTime'] := teEnd.Text;
      end
      else
      begin
        qrQuery.Parameters.ParamValues['BeginTime'] := Null;
        qrQuery.Parameters.ParamValues['EndTime'] := Null;
      end;
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
      DropTempTable(qrQuery, 'tmpEmplCaller');
    end;
  finally
    DropTempTable(qrQuery, 'tmpEmplDepartment');
  end;
  Result := ResultCode > 0;
  if Result then
    Application.MessageBox(PChar(ResultText), 'Сообщение', MB_OK or MB_ICONINFORMATION)
  else
    Application.MessageBox(PChar(ResultText), 'Ошибка', MB_OK or MB_ICONERROR);
end;

end.
