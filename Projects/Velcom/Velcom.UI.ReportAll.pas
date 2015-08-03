unit Velcom.UI.ReportAll;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLabel, cxDropDownEdit, dxBar, cxBarEditItem, cxClasses, ActnList, DB, ADODB, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxDBData,
  cxButtonEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView,
  cxGridCustomView, cxGrid;

type
  TfrmReportAll = class(TForm)
    qrCallers: TADOQuery;
    dsCallers: TDataSource;
    qrQuery: TADOQuery;
    ActionList: TActionList;
    acRefresh: TAction;
    acSaveExcel: TAction;
    dxBarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarManagerBar1: TdxBar;
    cxBarEditItem1: TcxBarEditItem;
    edtPeriods: TcxBarEditItem;
    btnRefresh: TdxBarLargeButton;
    dxBarLargeButton1: TdxBarLargeButton;
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
    colDistributionCost: TcxGridDBBandedColumn;
    procedure acRefreshExecute(Sender: TObject);
    procedure acSaveExcelExecute(Sender: TObject);
    procedure acSaveExcelUpdate(Sender: TObject);
    procedure cikAbonentNameStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure FormShow(Sender: TObject);
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
  cxGridExportLink,
  USysGlobal,
  ShellAPI,
  Velcom.ISQLCursor,
  DateUtils;

{$R *.dfm}

{ TfrmReportAll }

procedure TfrmReportAll.acRefreshExecute(Sender: TObject);
begin
  RefreshCallers();
end;

procedure TfrmReportAll.acRefreshUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not VarIsNull(edtPeriods.EditValue);
end;

procedure TfrmReportAll.acSaveExcelExecute(Sender: TObject);

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

procedure TfrmReportAll.acSaveExcelUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.ViewData.RecordCount > 0;
end;

procedure TfrmReportAll.cikAbonentNameStylesGetContentStyle(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin
  if ARecord.Values[cxTable.GetColumnByFieldName('IsAbonentExists').Index] = 0 then
    AStyle := DM.stlAbnGray;
end;

procedure TfrmReportAll.FillPeriods;
var
  k: Integer;
  formatDate: TFormatSettings;
begin
  qrQuery.SQL.Text := 'rep_all_sel_periods';
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

procedure TfrmReportAll.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmReportAll.FormShow(Sender: TObject);
begin
  FillPeriods();
end;

function TfrmReportAll.GetId_Period: Integer;
begin
  Result := Integer((edtPeriods.Properties as TcxComboBoxProperties).Items.Objects[(edtPeriods.Properties as TcxComboBoxProperties).Items.IndexOf(edtPeriods.EditValue)]);
end;

procedure TfrmReportAll.RefreshCallers;
begin
  CreateSQLCursor();
  if qrCallers.Active then
    qrCallers.Close;
  cxTable.BeginUpdate;
  try
    qrCallers.SQL.Text := 'rep_all_sel :Id_User, :Id_Period';
    qrCallers.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
    qrCallers.Parameters.ParamValues['Id_Period'] := Id_Period;
    qrCallers.Open;
  finally
    cxTable.EndUpdate;
  end;
end;

end.
