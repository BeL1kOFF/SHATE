unit Velcom.UI.ReportNumber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridBandedTableView, cxClasses,
  dxBar, cxGridLevel, cxGrid, ActnList, DB, cxDBData, cxButtonEdit, cxGridDBBandedTableView, cxLabel, cxCalendar,
  cxDropDownEdit, cxBarEditItem, ADODB, cxTextEdit, cxImageComboBox, cxColorComboBox, cxCheckComboBox;

type
  TfrmReportNumber = class(TForm)
    dxBarManager: TdxBarManager;
    ActionList: TActionList;
    dxBarManager1Bar1: TdxBar;
    cxGrid: TcxGrid;
    cxTable: TcxGridDBBandedTableView;
    colNumber: TcxGridDBBandedColumn;
    cikAbonentName: TcxGridDBBandedColumn;
    colDepartment: TcxGridDBBandedColumn;
    colSum: TcxGridDBBandedColumn;
    colSumWork: TcxGridDBBandedColumn;
    colSumNoWork: TcxGridDBBandedColumn;
    colCallerId: TcxGridDBBandedColumn;
    colAbonentExists: TcxGridDBBandedColumn;
    cxLevel: TcxGridLevel;
    cxBarEditItem1: TcxBarEditItem;
    edtPeriods: TcxBarEditItem;
    dxBarManagerBar1: TdxBar;
    btnRefresh: TdxBarLargeButton;
    acRefresh: TAction;
    dxBarManagerBar2: TdxBar;
    btnDetail: TdxBarLargeButton;
    acDetail: TAction;
    qrQuery: TADOQuery;
    qrCallers: TADOQuery;
    dsCallers: TDataSource;
    dxBarLargeButton1: TdxBarLargeButton;
    acSaveExcel: TAction;
    procedure FormShow(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acDetailUpdate(Sender: TObject);
    procedure cxTableCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure cikAbonentNameStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure acSaveExcelUpdate(Sender: TObject);
    procedure acSaveExcelExecute(Sender: TObject);
    procedure acDetailExecute(Sender: TObject);
    procedure acRefreshUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function GetId_Period: Integer;
    procedure FillPeriods;
    procedure RefreshCallers;
    property Id_Period: Integer read GetId_Period;
  public
    { Public declarations }
  end;

implementation

uses
  uMain,
  uDataModule,
  Velcom.ISQLCursor,
  DateUtils,
  cxGridExportLink,
  USysGlobal,
  ShellAPI,
  Velcom.UI.ReportNumberDetail;

{$R *.dfm}

{ TfrmReportNumber }

procedure TfrmReportNumber.acDetailExecute(Sender: TObject);
var
  frmReportNumberDetail: TfrmReportNumberDetail;
  callers: TCallerRecArray;
  k: Integer;
begin
  SetLength(callers, cxTable.Controller.SelectedRecordCount);
  for k := 0 to cxTable.Controller.SelectedRecordCount - 1 do
  begin
    callers[k].CALLER_ID := cxTable.Controller.SelectedRecords[k].Values[cxTable.GetColumnByFieldName('Id_Caller').Index];
    callers[k].Employees := cxTable.Controller.SelectedRecords[k].Values[cxTable.GetColumnByFieldName('AbonentName').Index];
    callers[k].NUMBER := cxTable.Controller.SelectedRecords[k].Values[cxTable.GetColumnByFieldName('Number').Index];
  end;
  frmReportNumberDetail := TfrmReportNumberDetail.Create(Self, callers, Id_Period);
  try
    frmReportNumberDetail.ShowModal;
  finally
    frmReportNumberDetail.Free;
  end;
end;

procedure TfrmReportNumber.acDetailUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.Controller.SelectedRecordCount > 0;
end;

procedure TfrmReportNumber.acRefreshExecute(Sender: TObject);
begin
  RefreshCallers();
end;

procedure TfrmReportNumber.acRefreshUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not VarIsNull(edtPeriods.EditValue);
end;

procedure TfrmReportNumber.acSaveExcelExecute(Sender: TObject);

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

procedure TfrmReportNumber.acSaveExcelUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.ViewData.RecordCount > 0;
end;

procedure TfrmReportNumber.cikAbonentNameStylesGetContentStyle(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin
  if ARecord.Values[cxTable.GetColumnByFieldName('IsAbonentExists').Index] = 0 then
    AStyle := DM.stlAbnGray;
end;

procedure TfrmReportNumber.cxTableCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnDetail.Click();
end;

procedure TfrmReportNumber.FillPeriods;
var
  k: Integer;
  formatDate: TFormatSettings;
begin
  qrQuery.SQL.Text := 'rep_numb_sel_periods';
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

procedure TfrmReportNumber.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmReportNumber.FormShow(Sender: TObject);
begin
  FillPeriods();
end;

function TfrmReportNumber.GetId_Period: Integer;
begin
  Result := Integer((edtPeriods.Properties as TcxComboBoxProperties).Items.Objects[(edtPeriods.Properties as TcxComboBoxProperties).Items.IndexOf(edtPeriods.EditValue)]);
end;

procedure TfrmReportNumber.RefreshCallers;
begin
  CreateSQLCursor();
  if qrCallers.Active then
    qrCallers.Close;
  cxTable.BeginUpdate;
  try
    qrCallers.SQL.Text := 'rep_numb_sel :Id_User, :Id_Period';
    qrCallers.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
    qrCallers.Parameters.ParamValues['Id_Period'] := Id_Period;
    qrCallers.Open;
  finally
    cxTable.EndUpdate;
  end;
end;

end.
