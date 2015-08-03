unit Velcom.UI.ReportEmployeeDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxLabel, cxTextEdit, cxCalendar, cxDropDownEdit, ActnList, ADODB, dxBar,
  cxBarEditItem, cxClasses, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGridCustomView, cxGrid;

type
  TCallerRec = record
    Id_Employee: Integer;
    Numbers: string;
    Name: string;
  end;

  TCallerRecArray = array of TCallerRec;

  TfrmReportEmployeeDetail = class(TForm)
    cxGrid: TcxGrid;
    cxTable: TcxGridDBBandedTableView;
    cxTableColumn14: TcxGridDBBandedColumn;
    cxTableColumn1: TcxGridDBBandedColumn;
    cxTableColumn2: TcxGridDBBandedColumn;
    cxTableColumn3: TcxGridDBBandedColumn;
    cxTableColumn4: TcxGridDBBandedColumn;
    cxTableColumn5: TcxGridDBBandedColumn;
    cxTableColumn6: TcxGridDBBandedColumn;
    cxTableColumn13: TcxGridDBBandedColumn;
    cxTableColumn7: TcxGridDBBandedColumn;
    cxTableColumn8: TcxGridDBBandedColumn;
    cxTableColumn9: TcxGridDBBandedColumn;
    cxTableColumn10: TcxGridDBBandedColumn;
    cxTableColumn11: TcxGridDBBandedColumn;
    cxLevel: TcxGridLevel;
    dxBarManager: TdxBarManager;
    dxBarManagerBar2: TdxBar;
    dxBarManagerBar3: TdxBar;
    dxBarManagerBar4: TdxBar;
    cxBarEditItem1: TcxBarEditItem;
    cxBarEditItem8: TcxBarEditItem;
    edtMail: TcxBarEditItem;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    edtTimeFilter: TcxBarEditItem;
    edtCaller: TcxBarEditItem;
    qrReport: TADOQuery;
    dsReport: TDataSource;
    ActionList: TActionList;
    acRefresh: TAction;
    acSaveExcel: TAction;
    acMail: TAction;
    procedure acMailUpdate(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acSaveExcelExecute(Sender: TObject);
    procedure acSaveExcelUpdate(Sender: TObject);
    procedure cxTableColumn5StylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure cxTableColumn6StylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure cxTableColumn13StylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure cxTableColumn1StylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure edtMailPropertiesChange(Sender: TObject);
    procedure acMailExecute(Sender: TObject);
  private
    FId_Period: Integer;
    function GetParamIsWorkTime(aItemIndex: Integer): Integer;
    procedure ExportMultiExcel;
    procedure ExportOneExcel;
    procedure Init(const aCallers: TCallerRecArray; aId_Period: Integer);
    procedure OnPrepareViewData(const aCallerId: Integer; out aViewData: TcxGridViewData);
    procedure RefreshDetail;
  public
    constructor Create(aOwner: TComponent; const aCallers: TCallerRecArray; aId_Period: Integer); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  uMain,
  uDataModule,
  cxGridExportLink,
  ShellAPI,
  USysGlobal,
  Velcom.ISQLCursor,
  Velcom.MultiReportExcel,
  Velcom.SendMail;

type
  TCaller = class
    Id: Integer;
    Name: string;
    Number: string;
  end;

{$R *.dfm}

{ TfrmReportEmployeeDetail }

procedure TfrmReportEmployeeDetail.acMailExecute(Sender: TObject);
var
  callerRecArray: TxCallerRecArray;
  k: Integer;
  FileName: string;
begin
  CreateSQLCursor;                      
  SetLength(callerRecArray, (edtCaller.Properties as TcxComboBoxProperties).Items.Count);
  for k := 0 to (edtCaller.Properties as TcxComboBoxProperties).Items.Count - 1 do
  begin
    callerRecArray[k].ID := TCaller((edtCaller.Properties as TcxComboBoxProperties).Items.Objects[k]).Id;
    callerRecArray[k].Name := '';
    callerRecArray[k].AbnName := '';
    callerRecArray[k].Number := (edtCaller.Properties as TcxComboBoxProperties).Items[k];
  end;
  try
    FileName := Velcom.MultiReportExcel.MultiExportCurToExcel(OnPrepareViewData,
      callerRecArray, True, '');
    SendMail(DM.IdSMTP, 'Рассылка по выбранным абонентам', edtMail.EditValue, FileName);
    MsgBoxInfo('Отчет отправлен');
  except on E: Exception do
    MsgBoxErr(E.Message);
  end;
end;

procedure TfrmReportEmployeeDetail.acMailUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (edtMail.EditValue <> '') and (not VarIsNull(edtMail.EditValue)) and
    (cxTable.ViewData.RecordCount > 0);
end;

procedure TfrmReportEmployeeDetail.acRefreshExecute(Sender: TObject);
begin
  RefreshDetail();
end;

procedure TfrmReportEmployeeDetail.acSaveExcelExecute(Sender: TObject);
begin
  if (edtCaller.Properties as TcxComboBoxProperties).Items.Count = 1 then
    ExportOneExcel
  else
    ExportMultiExcel;
end;

procedure TfrmReportEmployeeDetail.acSaveExcelUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (cxTable.ViewData.RecordCount > 0) or
    ((edtCaller.Properties as TcxComboBoxProperties).Items.Count > 1);
end;

constructor TfrmReportEmployeeDetail.Create(aOwner: TComponent; const aCallers: TCallerRecArray; aId_Period: Integer);
begin
  inherited Create(aOwner);
  Init(aCallers, aId_Period);
end;

procedure TfrmReportEmployeeDetail.cxTableColumn13StylesGetContentStyle(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin
  case ARecord.Values[cxTable.GetColumnByFieldName('IsAbonent').Index] of
    1:
      AStyle := DM.stlGreen;
    2:
      AStyle := DM.stlNavy;
  end;
end;

procedure TfrmReportEmployeeDetail.cxTableColumn1StylesGetContentStyle(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin
  if ARecord.Values[cxTable.GetColumnByFieldName('IsWorkTime').Index] = 0 then
    AStyle := DM.stlRed;
end;

procedure TfrmReportEmployeeDetail.cxTableColumn5StylesGetContentStyle(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin
  case ARecord.Values[cxTable.GetColumnByFieldName('IsAbonent').Index] of
    1:
      AStyle := DM.stlGreen;
    2:
      AStyle := DM.stlNavy;
  end;
end;

procedure TfrmReportEmployeeDetail.cxTableColumn6StylesGetContentStyle(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin
  case ARecord.Values[cxTable.GetColumnByFieldName('IsAbonent').Index] of
    1:
      AStyle := DM.stlGreen;
    2:
      AStyle := DM.stlNavy;
  end;
end;

destructor TfrmReportEmployeeDetail.Destroy;
var
  k: Integer;
begin
  for k := 0 to (edtCaller.Properties as TcxComboBoxProperties).Items.Count - 1 do
    (edtCaller.Properties as TcxComboBoxProperties).Items.Objects[k].Free();
  inherited Destroy();
end;

procedure TfrmReportEmployeeDetail.edtMailPropertiesChange(Sender: TObject);
begin
  (Sender as TcxTextEdit).PostEditValue();
end;

procedure TfrmReportEmployeeDetail.ExportMultiExcel;
var
  callerRecArray: TxCallerRecArray;
  k: Integer;
begin
  CreateSQLCursor();
  SetLength(callerRecArray, (edtCaller.Properties as TcxComboBoxProperties).Items.Count);
  for k := 0 to (edtCaller.Properties as TcxComboBoxProperties).Items.Count - 1 do
  begin
    callerRecArray[k].ID := TCaller((edtCaller.Properties as TcxComboBoxProperties).Items.Objects[k]).Id;
    callerRecArray[k].Name := '';
    callerRecArray[k].Number := (edtCaller.Properties as TcxComboBoxProperties).Items[k];
    callerRecArray[k].AbnName := '';
  end;
  Velcom.MultiReportExcel.MultiExportCurToExcel(OnPrepareViewData, callerRecArray, False, '');
end;

procedure TfrmReportEmployeeDetail.ExportOneExcel;
begin
  if DM.sdExcel.Execute() then
  begin
    ExportGridToXLSX(DM.sdExcel.FileName, cxGrid, False, True, False);
    if MsgBoxYN('Открыть файл?') then
      ShellExecute(Handle, 'open', PChar(DM.sdExcel.FileName), '', PChar(ExtractFilePath(DM.sdExcel.FileName)), SW_SHOWNORMAL);
  end;
end;

function TfrmReportEmployeeDetail.GetParamIsWorkTime(
  aItemIndex: Integer): Integer;
begin
  case aItemIndex of
    0:
      Result := -1;
    1:
      Result := 1;
    2:
      Result := 0;
    else
      Result := -1;
  end;
end;

procedure TfrmReportEmployeeDetail.Init(const aCallers: TCallerRecArray; aId_Period: Integer);
var
  k: Integer;
  caller: TCaller;
begin
  FId_Period := aId_Period;
  (edtCaller.Properties as TcxComboBoxProperties).Items.Clear();
  for k := 0 to Length(aCallers) - 1 do
  begin
    caller := TCaller.Create();
    caller.Id := aCallers[k].Id_Employee;
    caller.Name := aCallers[k].Name;
    caller.Number := aCallers[k].Numbers;
    (edtCaller.Properties as TcxComboBoxProperties).Items.AddObject(aCallers[k].Name + ' (' +
      aCallers[k].Numbers + ')', caller);
  end;
  edtCaller.EditValue := (edtCaller.Properties as TcxComboBoxProperties).Items[0];
end;

procedure TfrmReportEmployeeDetail.OnPrepareViewData(const aCallerId: Integer; out aViewData: TcxGridViewData);
var
  k: Integer;
begin
  for k := 0 to (edtCaller.Properties as TcxComboBoxProperties).Items.Count - 1 do
    if TCaller((edtCaller.Properties as TcxComboBoxProperties).Items.Objects[k]).Id = aCallerId then
    begin
      edtCaller.EditValue := (edtCaller.Properties as TcxComboBoxProperties).Items[k];
      RefreshDetail();
      Break;
    end;
  aViewData := cxTable.ViewData;
end;

procedure TfrmReportEmployeeDetail.RefreshDetail;
begin
  CreateSQLCursor();
  if qrReport.Active then
    qrReport.Close;
  qrReport.SQL.Text := 'rep_empl_sel_detail :Id_User, :Id_Period, :Id_Employee, :IsWorkTime';
  qrReport.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
  qrReport.Parameters.ParamValues['Id_Period'] := FId_Period;
  qrReport.Parameters.ParamValues['Id_Employee'] := TCaller((edtCaller.Properties as TcxComboBoxProperties).Items.Objects[(edtCaller.Properties as TcxComboBoxProperties).Items.IndexOf(edtCaller.EditValue)]).Id;
  qrReport.Parameters.ParamValues['IsWorkTime'] := GetParamIsWorkTime((edtTimeFilter.Properties as TcxComboBoxProperties).Items.IndexOf(edtTimeFilter.EditValue));
  qrReport.Open;
end;

end.
