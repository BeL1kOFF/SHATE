unit Velcom.UI.ReportNumberCost;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLabel, cxDropDownEdit, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView, cxClasses,
  cxGridCustomView, cxGrid, ADODB, ActnList, dxBar, cxBarEditItem, cxTextEdit;

type
  TfrmReportNumberCost = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarManagerBar1: TdxBar;
    dxBarManagerBar2: TdxBar;
    cxBarEditItem1: TcxBarEditItem;
    edtPeriods: TcxBarEditItem;
    btnRefresh: TdxBarLargeButton;
    btnDetail: TdxBarLargeButton;
    dxBarLargeButton1: TdxBarLargeButton;
    ActionList: TActionList;
    acRefresh: TAction;
    acDetail: TAction;
    acSaveExcel: TAction;
    qrCallers: TADOQuery;
    dsCallers: TDataSource;
    qrQuery: TADOQuery;
    cxGrid: TcxGrid;
    cxTable: TcxGridDBBandedTableView;
    colNumber: TcxGridDBBandedColumn;
    colCostName: TcxGridDBBandedColumn;
    colSum: TcxGridDBBandedColumn;
    colSumWork: TcxGridDBBandedColumn;
    colSumNoWork: TcxGridDBBandedColumn;
    colCallerId: TcxGridDBBandedColumn;
    cxLevel: TcxGridLevel;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    acExpand: TAction;
    acCollapse: TAction;
    colIdCost: TcxGridDBBandedColumn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acRefreshUpdate(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acSaveExcelUpdate(Sender: TObject);
    procedure acSaveExcelExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acExpandUpdate(Sender: TObject);
    procedure acCollapseUpdate(Sender: TObject);
    procedure acExpandExecute(Sender: TObject);
    procedure acCollapseExecute(Sender: TObject);
    procedure acDetailUpdate(Sender: TObject);
    procedure acDetailExecute(Sender: TObject);
    procedure cxTableCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    function GetId_Period: Integer;
    procedure FillPeriods;
    procedure RefreshNumberCost;
    property Id_Period: Integer read GetId_Period;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  uMain,
  uDataModule,
  cxGridExportLink,
  USysGlobal,
  ShellAPI,
  Velcom.ISQLCursor,
  Velcom.UI.ReportNumberCostDetail;

procedure TfrmReportNumberCost.acCollapseExecute(Sender: TObject);
begin
  cxTable.ViewData.Collapse(True);
end;

procedure TfrmReportNumberCost.acCollapseUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.ViewData.RecordCount > 0;
end;

procedure TfrmReportNumberCost.acDetailExecute(Sender: TObject);
var
  frmReportNumberCostDetail: TfrmReportNumberCostDetail;
  CallerRec: TCallerRec;
begin
  CallerRec.Id_Caller := cxTable.Controller.FocusedRecord.Values[cxTable.GetColumnByFieldName('Id_Caller').Index];
  CallerRec.Id_Cost := cxTable.Controller.FocusedRecord.Values[cxTable.GetColumnByFieldName('Id_Cost').Index];
  frmReportNumberCostDetail := TfrmReportNumberCostDetail.Create(Self, CallerRec, Id_Period);
  try
    frmReportNumberCostDetail.ShowModal();
  finally
    frmReportNumberCostDetail.Free();
  end;
end;

procedure TfrmReportNumberCost.acDetailUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (cxTable.Controller.SelectedRecordCount = 1) and
    (cxTable.Controller.FocusedRecord.Level = 1);
end;

procedure TfrmReportNumberCost.acExpandExecute(Sender: TObject);
begin
  cxTable.ViewData.Expand(True);
end;

procedure TfrmReportNumberCost.acExpandUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.ViewData.RecordCount > 0;
end;

procedure TfrmReportNumberCost.acRefreshExecute(Sender: TObject);
begin
  RefreshNumberCost();
end;

procedure TfrmReportNumberCost.acRefreshUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not VarIsNull(edtPeriods.EditValue);
end;

procedure TfrmReportNumberCost.acSaveExcelExecute(Sender: TObject);

  procedure SetColumnRepositoryItem(aRepositoryItem: TcxEditRepositoryItem);
  begin
    colSum.RepositoryItem := aRepositoryItem;
    colSumWork.RepositoryItem := aRepositoryItem;
    colSumNoWork.RepositoryItem := aRepositoryItem;
  end;

begin
  if DM.sdExcel.Execute() then
  begin
    cxTable.BeginUpdate();
    try
      SetColumnRepositoryItem(nil);
      ExportGridToXLSX(DM.sdExcel.FileName, cxGrid, False, True, False);
      SetColumnRepositoryItem(DM.edtRepFloat);
    finally
      cxTable.EndUpdate();
    end;
    if MsgBoxYN('Открыть файл?') then
      ShellExecute(Handle, 'open', PChar(DM.sdExcel.FileName), '', PChar(ExtractFilePath(DM.sdExcel.FileName)), SW_SHOWNORMAL);
  end;
end;

procedure TfrmReportNumberCost.acSaveExcelUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.ViewData.RecordCount > 0;
end;

procedure TfrmReportNumberCost.cxTableCellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnDetail.Click();
end;

procedure TfrmReportNumberCost.FillPeriods;
var
  k: Integer;
  formatDate: TFormatSettings;
begin
  qrQuery.SQL.Text := 'rep_numbcost_sel_periods';
  qrQuery.Open();
  (edtPeriods.Properties as TcxComboBoxProperties).Items.Clear();
  qrQuery.First();
  formatDate.DateSeparator := '-';
  formatDate.ShortDateFormat := 'yyyy-mm-dd';
  for k := 0 to qrQuery.RecordCount - 1 do
  begin
    (edtPeriods.Properties as TcxComboBoxProperties).Items.AddObject(
      Format('%s %d  [%s - %s]', [cMonthNames[qrQuery.FieldByName('Month').AsInteger],
                                  qrQuery.FieldByName('Year').AsInteger,
                                  FormatDateTime('DD.MM.YYYY', StrToDate(qrQuery.FieldByName('BeginDate').AsString, formatDate)),
                                  FormatDateTime('DD.MM.YYYY', StrToDate(qrQuery.FieldByName('EndDate').AsString, formatDate))]),
      TObject(qrQuery.FieldByName('Id_Period').AsInteger));
    qrQuery.Next();
  end;
  qrQuery.Close();
end;

procedure TfrmReportNumberCost.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmReportNumberCost.FormShow(Sender: TObject);
begin
  FillPeriods();
end;

function TfrmReportNumberCost.GetId_Period: Integer;
begin
  Result := Integer((edtPeriods.Properties as TcxComboBoxProperties).Items.Objects[(edtPeriods.Properties as TcxComboBoxProperties).Items.IndexOf(edtPeriods.EditValue)]);
end;

procedure TfrmReportNumberCost.RefreshNumberCost;
begin
  CreateSQLCursor();
  if qrCallers.Active then
    qrCallers.Close;
  cxTable.BeginUpdate;
  try
    qrCallers.SQL.Text := 'rep_numbcost_sel :Id_User, :Id_Period';
    qrCallers.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
    qrCallers.Parameters.ParamValues['Id_Period'] := Id_Period;
    qrCallers.Open;
  finally
    cxTable.EndUpdate;
  end;
end;

end.
