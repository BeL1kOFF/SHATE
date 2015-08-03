unit Velcom.UI.ImportExternal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxClasses, cxGridCustomView, cxGrid,
  ActnList, dxBar, DB, ADODB;

type
  TfrmImportExternal = class(TForm)
    qrQuery: TADOQuery;
    dxBarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    ActionList: TActionList;
    acRefresh: TAction;
    acImport: TAction;
    cxGrid: TcxGrid;
    cxTable: TcxGridTableView;
    cxLevel: TcxGridLevel;
    colIdImportEmployee: TcxGridColumn;
    colEmployeeExternalCode: TcxGridColumn;
    colFIO: TcxGridColumn;
    colDepartmentExternalCode: TcxGridColumn;
    colNameDepartment: TcxGridColumn;
    colStatus: TcxGridColumn;
    colSystemName: TcxGridColumn;
    colIdExternalSystem: TcxGridColumn;
    dxBarLargeButton3: TdxBarLargeButton;
    acDelete: TAction;
    procedure acRefreshExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acImportUpdate(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acImportExecute(Sender: TObject);
    procedure cxTableKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure RefreshImport;
  public
  end;

implementation

uses
  Velcom.ISQLCursor,
  adoDBUtils,
  Clipbrd;

{$R *.dfm}

{ TfrmImportExternal }

procedure TfrmImportExternal.acDeleteExecute(Sender: TObject);
var
  k: Integer;
  ResultText: string;
  ResultCode: Integer;
begin
  if Application.MessageBox('Вы уверенны, что хотите удалить выделенные записи?', 'Удаление', MB_YESNO or MB_ICONQUESTION) <> ID_YES then
    Exit;
  CreateSQLCursor();
  qrQuery.Close();
  CreateTempTable(qrQuery, 'tmpDelImport', ['Id_ImportEmployee INT']);
  try
    for k := 0 to cxTable.Controller.SelectedRecordCount - 1 do
      InsertTempTable(qrQuery, 'tmpDelImport', [cxTable.Controller.SelectedRecords[k].Values[0]]);
    qrQuery.SQL.Text := 'ie_del_employee';
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
    DropTempTable(qrQuery, 'tmpDelImport');
  end;
  case ResultCode of
    1:
      Application.MessageBox(PChar(ResultText), 'Сообщение', MB_OK or MB_ICONINFORMATION);
    0:
      Application.MessageBox(PChar(ResultText), 'Предупреждение', MB_OK or MB_ICONWARNING);
    -1:
      Application.MessageBox(PChar(ResultText), 'Ошибка', MB_OK or MB_ICONERROR);
  end;
  RefreshImport();
end;

procedure TfrmImportExternal.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.Controller.SelectedRecordCount > 0;
end;

procedure TfrmImportExternal.acImportExecute(Sender: TObject);
var
  k: Integer;
  ResultText: string;
  ResultCode: Integer;
begin
  CreateSQLCursor();
  qrQuery.Close();
  CreateTempTable(qrQuery, 'tmpImportEmployee', ['Id_ImportEmployee INT']);
  try
    for k := 0 to cxTable.Controller.SelectedRecordCount - 1 do
      InsertTempTable(qrQuery, 'tmpImportEmployee', [cxTable.Controller.SelectedRecords[k].Values[0]]);
    qrQuery.SQL.Text := 'ie_import_employee';
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
    DropTempTable(qrQuery, 'tmpImportEmployee');
  end;
  case ResultCode of
    1:
      Application.MessageBox(PChar(ResultText), 'Сообщение', MB_OK or MB_ICONINFORMATION);
    0:
      Application.MessageBox(PChar(ResultText), 'Предупреждение', MB_OK or MB_ICONWARNING);
    -1:
      Application.MessageBox(PChar(ResultText), 'Ошибка', MB_OK or MB_ICONERROR);
  end;
  RefreshImport();
end;

procedure TfrmImportExternal.acImportUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.Controller.SelectedRecordCount > 0;
end;

procedure TfrmImportExternal.acRefreshExecute(Sender: TObject);
begin
  RefreshImport();
end;

procedure TfrmImportExternal.cxTableKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ((Shift - [ssCtrl] = []) and (Key = 67) or       
      (Shift - [ssShift] = []) and (Key = 45)) and (cxTable.OptionsSelection.CellSelect) then
    Clipboard.AsText := cxTable.Controller.FocusedRow.Values[cxTable.Controller.FocusedColumn.Index];
end;

procedure TfrmImportExternal.FormShow(Sender: TObject);
begin
  RefreshImport();
end;

procedure TfrmImportExternal.RefreshImport;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := 'ie_sel_employee';
  qrQuery.Open();
  cxTable.BeginUpdate();
  try
    cxTable.DataController.RecordCount := qrQuery.RecordCount;
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cxTable.DataController.Values[k, 0] := qrQuery.FieldByName('Id_ImportEmployee').AsInteger;
      cxTable.DataController.Values[k, 1] := qrQuery.FieldByName('EmployeeExternalCode').AsString;
      cxTable.DataController.Values[k, 2] := qrQuery.FieldByName('FIO').AsString;
      cxTable.DataController.Values[k, 3] := qrQuery.FieldByName('DepartmentExternalCode').AsString;
      cxTable.DataController.Values[k, 4] := qrQuery.FieldByName('NameDepartment').AsString;
      cxTable.DataController.Values[k, 5] := qrQuery.FieldByName('Status').AsString;
      cxTable.DataController.Values[k, 6] := qrQuery.FieldByName('Id_ExternalSystem').AsInteger;
      cxTable.DataController.Values[k, 7] := qrQuery.FieldByName('SystemName').AsString;
      qrQuery.Next();
    end;  
  finally
    cxTable.EndUpdate();
  end;
  qrQuery.Close();
end;

end.
