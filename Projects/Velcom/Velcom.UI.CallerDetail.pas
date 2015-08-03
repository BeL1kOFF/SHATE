unit Velcom.UI.CallerDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ActnList, DB, ADODB, StdCtrls, Mask, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxDropDownEdit, cxCalendar,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxClasses,
  cxGridCustomView, cxGrid;

type
  TfrmCallerDetail = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    qrQuery: TADOQuery;
    ActionList: TActionList;
    acCancel: TAction;
    acSave: TAction;
    btnSave: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    edNumber: TEdit;
    cxGridEmployee: TcxGrid;
    cxTableEmployee: TcxGridTableView;
    colIdEmployee: TcxGridColumn;
    colEmployee: TcxGridColumn;
    colDateActive: TcxGridColumn;
    cxLevelEmployee: TcxGridLevel;
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edNumberKeyPress(Sender: TObject; var Key: Char);
    procedure colEmployeePropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure cxTableEmployeeDataControllerNewRecord(
      ADataController: TcxCustomDataController; ARecordIndex: Integer);
  private
    FIdCaller: Integer;
    function IsCheckNumbers: Boolean;
    function Save: Boolean;
    procedure FillComboBoxEmployee;
    procedure ReadItem;
  public
    constructor Create(aOwner: TComponent; aIdCaller: Integer); reintroduce;
  end;

implementation

uses
  Velcom.ISQLCursor,
  adoDBUtils;

{$R *.dfm}

{ TfrmCallerDetail }

procedure TfrmCallerDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmCallerDetail.acSaveExecute(Sender: TObject);
begin
  if Save then
    Close();
end;

procedure TfrmCallerDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (Length(edNumber.Text) = 9) and (IsCheckNumbers());
end;

procedure TfrmCallerDetail.colEmployeePropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
  Error := False;
  cxTableEmployee.Controller.FocusedRecord.Values[0] := Integer(TcxComboBox(Sender).Properties.Items.Objects[TcxComboBox(Sender).ItemIndex]);
end;

constructor TfrmCallerDetail.Create(aOwner: TComponent; aIdCaller: Integer);
begin
  inherited Create(aOwner);
  FIdCaller := aIdCaller;
end;

procedure TfrmCallerDetail.cxTableEmployeeDataControllerNewRecord(
  ADataController: TcxCustomDataController; ARecordIndex: Integer);
begin
  ADataController.Values[ARecordIndex, 2] := Date();
end;

procedure TfrmCallerDetail.edNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if ((not (Key in ['0'..'9'])) or (Length(TEdit(Sender).Text) >= 9)) and (not (Key in [#8])) then
    Key := #0;
end;

procedure TfrmCallerDetail.FillComboBoxEmployee;
var
  ComboBoxProp: TcxComboBoxProperties;
  k: Integer;
begin
  ComboBoxProp := cxTableEmployee.Columns[1].Properties as TcxComboBoxProperties;
  qrQuery.SQL.Text := 'cll_sel_employeelist';
  qrQuery.Open();
  qrQuery.First();
  ComboBoxProp.Items.Clear();
  for k := 0 to qrQuery.RecordCount - 1 do
  begin
    ComboBoxProp.Items.AddObject(qrQuery.FieldByName('Name').AsString, TObject(qrQuery.FieldByName('Id_Employee').AsInteger));
    qrQuery.Next();
  end;
  qrQuery.Close();
end;

procedure TfrmCallerDetail.FormShow(Sender: TObject);
begin
  FillComboBoxEmployee();
  ReadItem();
  edNumber.SetFocus();
end;

function TfrmCallerDetail.IsCheckNumbers: Boolean;
var
  k, i: Integer;
begin
  for k := 0 to cxTableEmployee.DataController.RecordCount - 1 do
  begin
    if (VarIsNull(cxTableEmployee.DataController.Values[k, 0])) or (VarIsNull(cxTableEmployee.DataController.Values[k, 2])) then
    begin
      Result := False;
      Exit;
    end
    else
      for i := k + 1 to cxTableEmployee.DataController.RecordCount - 1 do
      begin
        if (cxTableEmployee.DataController.Values[i, 2] = cxTableEmployee.DataController.Values[k, 2]) then
        begin
          Result := False;
          Exit;
        end;
      end;
  end;
  Result := True;
end;

procedure TfrmCallerDetail.ReadItem;
var
  k: Integer;
  FormatDate: TFormatSettings;
begin
  CreateSQLCursor();
  if FIdCaller = -1 then
    edNumber.Clear()
  else
  begin
    qrQuery.SQL.Text := 'cll_sel_item :Id_Caller';
    qrQuery.Parameters.ParamValues['Id_Caller'] := FIdCaller;
    try
      qrQuery.Open();
      edNumber.Text := qrQuery.FieldByName('Number').AsString;
      qrQuery.Close();
      qrQuery.SQL.Text := 'cll_sel_item_employeelist :Id_Caller';
      qrQuery.Parameters.ParamValues['Id_Caller'] := FIdCaller;
      qrQuery.Open();
      qrQuery.First();
      cxTableEmployee.DataController.RecordCount := qrQuery.RecordCount;
      cxTableEmployee.Site.SetFocus;
      FormatDate.DateSeparator := '-';
      FormatDate.ShortDateFormat := 'yyyy-mm-dd';
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        cxTableEmployee.DataController.Values[k, 0] := qrQuery.FieldByName('Id_Employee').AsInteger;
        cxTableEmployee.DataController.Values[k, 2] := StrToDate(qrQuery.FieldByName('DateActive').AsString, FormatDate);
        cxTableEmployee.Controller.FocusedRecordIndex := k;
        cxTableEmployee.Controller.EditingController.ShowEdit(cxTableEmployee.Items[1]);
        TcxComboBox(cxTableEmployee.Controller.EditingController.Edit).ItemIndex := TcxComboBox(cxTableEmployee.Controller.EditingController.Edit).Properties.Items.IndexOf(qrQuery.FieldByName('Name').AsString);
        TcxComboBox(cxTableEmployee.Controller.EditingController.Edit).PostEditValue;
        cxTableEmployee.Controller.EditingController.HideEdit(True);
        qrQuery.Next();
      end;
    finally
      qrQuery.Close();
    end;
  end;
end;

function TfrmCallerDetail.Save: Boolean;
var
  ResultCode: Integer;
  ResultText: string;
  k: Integer;
begin
  CreateSQLCursor();
  CreateTempTable(qrQuery, 'tmpCallerEmpl', ['Id_Employee INT', 'DateActive DATETIME']);
  try
    for k := 0 to cxTableEmployee.DataController.RecordCount - 1 do
      InsertTempTable(qrQuery, 'tmpCallerEmpl', [cxTableEmployee.DataController.Values[k, 0],
        cxTableEmployee.DataController.Values[k, 2]]);
    if FIdCaller = -1 then
      qrQuery.SQL.Text := 'cll_ins_item :Number'
    else
    begin
      qrQuery.SQL.Text := 'cll_edt_item :Id_Caller, :Number';
      qrQuery.Parameters.ParamValues['Id_Caller'] := FIdCaller;
    end;
    qrQuery.Parameters.ParamValues['Number'] := edNumber.Text;
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
    DropTempTable(qrQuery, 'tmpCallerEmpl');
  end;
  Result := resultCode > 0;
  case resultCode of
    1:
      Application.MessageBox(PChar(resultText), 'Сообщение', MB_OK or MB_ICONINFORMATION);
    0:
      Application.MessageBox(PChar(resultText), 'Предупреждение', MB_OK or MB_ICONWARNING);
    -1:
      Application.MessageBox(PChar(resultText), 'Ошибка', MB_OK or MB_ICONERROR);
  end;
end;

end.
