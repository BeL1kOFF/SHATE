unit Velcom.UI.ReportNumberDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLabel, cxCalendar, cxDropDownEdit, cxTextEdit, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, dxBar, ADODB,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView, cxClasses,
  cxGridCustomView, cxGrid, cxBarEditItem, dxBarExtItems, ActnList, StdCtrls;

type
  TCallerRec = record
    CALLER_ID: Integer;
    Employees: string;
    NUMBER: string;
  end;

  TCallerRecArray = array of TCallerRec;

  TfrmReportNumberDetail = class(TForm)
    dxBarManager: TdxBarManager;
    cxBarEditItem1: TcxBarEditItem;
    dxBarManagerBar2: TdxBar;
    cxBarEditItem8: TcxBarEditItem;
    edtMail: TcxBarEditItem;
    dxBarLargeButton1: TdxBarLargeButton;
    cxGrid: TcxGrid;
    cxTable: TcxGridDBBandedTableView;
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
    cxLevel: TcxGridLevel;
    dxBarLargeButton2: TdxBarLargeButton;
    cxTableColumn14: TcxGridDBBandedColumn;
    qrReport: TADOQuery;
    dsReport: TDataSource;
    dxBarManagerBar3: TdxBar;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    ActionList: TActionList;
    acRefresh: TAction;
    edtTimeFilter: TcxBarEditItem;
    edtCaller: TcxBarEditItem;
    dxBarManagerBar4: TdxBar;
    acSaveExcel: TAction;
    acMail: TAction;
    cxTableColumn11: TcxGridDBBandedColumn;
    procedure acRefreshExecute(Sender: TObject);
    procedure cxTableColumn1StylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure cxTableColumn5StylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure cxTableColumn6StylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure cxTableColumn13StylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure acMailExecute(Sender: TObject);
    procedure acMailUpdate(Sender: TObject);
    procedure acSaveExcelUpdate(Sender: TObject);
    procedure acSaveExcelExecute(Sender: TObject);
    procedure edtMailPropertiesChange(Sender: TObject);
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
  Velcom.ISQLCursor,
  Velcom.MultiReportExcel,
  USysGlobal,
  Velcom.SendMail,
  cxGridExportLink,
  ShellAPI;

type
  TCaller = class
    Id: Integer;
    Name: string;
    Number: string;
  end;

{$R *.dfm}

{ TfrmReportNumberDetail }

procedure TfrmReportNumberDetail.acMailExecute(Sender: TObject);
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

procedure TfrmReportNumberDetail.acMailUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (edtMail.EditValue <> '') and (not VarIsNull(edtMail.EditValue)) and
    (cxTable.ViewData.RecordCount > 0);
end;

procedure TfrmReportNumberDetail.acRefreshExecute(Sender: TObject);
begin
  RefreshDetail();
end;

procedure TfrmReportNumberDetail.acSaveExcelExecute(Sender: TObject);
begin
  if (edtCaller.Properties as TcxComboBoxProperties).Items.Count = 1 then
    ExportOneExcel
  else
    ExportMultiExcel;
end;

procedure TfrmReportNumberDetail.acSaveExcelUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (cxTable.ViewData.RecordCount > 0) or
    ((edtCaller.Properties as TcxComboBoxProperties).Items.Count > 1);
end;

constructor TfrmReportNumberDetail.Create(aOwner: TComponent; const aCallers: TCallerRecArray; aId_Period: Integer);
begin
  inherited Create(aOwner);
  Init(aCallers, aId_Period);
end;

procedure TfrmReportNumberDetail.cxTableColumn13StylesGetContentStyle(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin
  case ARecord.Values[cxTable.GetColumnByFieldName('IsAbonent').Index] of
    1:
      AStyle := DM.stlGreen;
    2:
      AStyle := DM.stlNavy;
  end;
end;

procedure TfrmReportNumberDetail.cxTableColumn1StylesGetContentStyle(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin
  if ARecord.Values[cxTable.GetColumnByFieldName('IsWorkTime').Index] = 0 then
    AStyle := DM.stlRed;
end;

procedure TfrmReportNumberDetail.cxTableColumn5StylesGetContentStyle(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin
  case ARecord.Values[cxTable.GetColumnByFieldName('IsAbonent').Index] of
    1:
      AStyle := DM.stlGreen;
    2:
      AStyle := DM.stlNavy;
  end;
end;

procedure TfrmReportNumberDetail.cxTableColumn6StylesGetContentStyle(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin
  case ARecord.Values[cxTable.GetColumnByFieldName('IsAbonent').Index] of
    1:
      AStyle := DM.stlGreen;
    2:
      AStyle := DM.stlNavy;
  end;
end;

destructor TfrmReportNumberDetail.Destroy;
var
  k: Integer;
begin
  for k := 0 to (edtCaller.Properties as TcxComboBoxProperties).Items.Count - 1 do
    (edtCaller.Properties as TcxComboBoxProperties).Items.Objects[k].Free();
  inherited Destroy();
end;

procedure TfrmReportNumberDetail.edtMailPropertiesChange(Sender: TObject);
begin
  (Sender as TcxTextEdit).PostEditValue();
end;

procedure TfrmReportNumberDetail.ExportMultiExcel;
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
    callerRecArray[k].AbnName := '';
    callerRecArray[k].Number := (edtCaller.Properties as TcxComboBoxProperties).Items[k];
  end;
  Velcom.MultiReportExcel.MultiExportCurToExcel(OnPrepareViewData,
    callerRecArray, False, '');
end;

procedure TfrmReportNumberDetail.ExportOneExcel;
begin
  if DM.sdExcel.Execute() then
  begin
    ExportGridToXLSX(DM.sdExcel.FileName, cxGrid, False, True, False);
    if MsgBoxYN('Открыть файл?') then
      ShellExecute(Handle, 'open', PChar(DM.sdExcel.FileName), '', PChar(ExtractFilePath(DM.sdExcel.FileName)), SW_SHOWNORMAL);
  end;
end;

function TfrmReportNumberDetail.GetParamIsWorkTime(aItemIndex: Integer): Integer;
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

procedure TfrmReportNumberDetail.Init(const aCallers: TCallerRecArray; aId_Period: Integer);
var
  k: Integer;
  caller: TCaller;
begin
  FId_Period := aId_Period;
  (edtCaller.Properties as TcxComboBoxProperties).Items.Clear();
  for k := 0 to Length(aCallers) - 1 do
  begin
    caller := TCaller.Create();
    caller.Id := aCallers[k].CALLER_ID;
    caller.Name := aCallers[k].Employees;
    caller.Number := aCallers[k].NUMBER;
    (edtCaller.Properties as TcxComboBoxProperties).Items.AddObject(aCallers[k].NUMBER + ' (' +
      aCallers[k].Employees + ')', caller);
  end;
  edtCaller.EditValue := (edtCaller.Properties as TcxComboBoxProperties).Items[0];
end;

procedure TfrmReportNumberDetail.OnPrepareViewData(const aCallerId: Integer; out aViewData: TcxGridViewData);
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

procedure TfrmReportNumberDetail.RefreshDetail;
begin
  CreateSQLCursor();
  if qrReport.Active then
    qrReport.Close;
  qrReport.SQL.Text := 'rep_numb_sel_detail :Id_User, :Id_Period, :Id_Caller, :IsWorkTime';
  qrReport.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
  qrReport.Parameters.ParamValues['Id_Period'] := FId_Period;
  qrReport.Parameters.ParamValues['Id_Caller'] := TCaller((edtCaller.Properties as TcxComboBoxProperties).Items.Objects[(edtCaller.Properties as TcxComboBoxProperties).Items.IndexOf(edtCaller.EditValue)]).Id;
  qrReport.Parameters.ParamValues['IsWorkTime'] := GetParamIsWorkTime((edtTimeFilter.Properties as TcxComboBoxProperties).Items.IndexOf(edtTimeFilter.EditValue));
  qrReport.Open;
end;

end.
