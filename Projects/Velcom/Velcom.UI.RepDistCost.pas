unit Velcom.UI.RepDistCost;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxBar, cxClasses, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridLevel, cxGrid, ActnList, DB, ADODB, cxLabel,
  cxDropDownEdit, cxBarEditItem;

type
  TfrmDistCost = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    btnRefresh: TdxBarLargeButton;
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    tblReport: TcxGridTableView;
    ActionList: TActionList;
    acRefresh: TAction;
    colDistributionCost: TcxGridColumn;
    colPrice: TcxGridColumn;
    colPercentPrice: TcxGridColumn;
    qrQuery: TADOQuery;
    dxBarManagerBar2: TdxBar;
    dxBarEdit1: TdxBarEdit;
    cxBarEditItem1: TcxBarEditItem;
    cxBarEditItem2: TcxBarEditItem;
    cbPeriod: TcxBarEditItem;
    dxBarLargeButton1: TdxBarLargeButton;
    acExcel: TAction;
    procedure acRefreshExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acRefreshUpdate(Sender: TObject);
    procedure acExcelUpdate(Sender: TObject);
    procedure acExcelExecute(Sender: TObject);
  private
    function GetId_Period: Integer;
    procedure FillPeriods;
    procedure RefreshData;
    property Id_Period: Integer read GetId_Period;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  Velcom.ISQLCursor,
  cxGridExportLink,
  USysGlobal,
  ShellAPI,
  uDataModule,
  uMain;

procedure TfrmDistCost.acExcelExecute(Sender: TObject);
begin
  if DM.sdExcel.Execute() then
  begin
    ExportGridToXLSX(DM.sdExcel.FileName, cxGrid, False, True, False);
    if MsgBoxYN('Открыть файл?') then
      ShellExecute(Handle, 'open', PChar(DM.sdExcel.FileName), '', PChar(ExtractFilePath(DM.sdExcel.FileName)), SW_SHOWNORMAL);
  end;
end;

procedure TfrmDistCost.acExcelUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblReport.ViewData.RecordCount > 0;
end;

procedure TfrmDistCost.acRefreshExecute(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmDistCost.acRefreshUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not VarIsNull(cbPeriod.EditValue);
end;

procedure TfrmDistCost.FillPeriods;
var
  k: Integer;
  formatDate: TFormatSettings;
begin
  qrQuery.SQL.Text := 'rep_distcost_sel_periods';
  qrQuery.Open();
  (cbPeriod.Properties as TcxComboBoxProperties).Items.Clear();
  qrQuery.First();
  formatDate.DateSeparator := '-';
  formatDate.ShortDateFormat := 'yyyy-mm-dd';
  for k := 0 to qrQuery.RecordCount - 1 do
  begin
    (cbPeriod.Properties as TcxComboBoxProperties).Items.AddObject(
      Format('%s %d  [%s - %s]', [cMonthNames[qrQuery.FieldByName('Month').AsInteger],
                                  qrQuery.FieldByName('Year').AsInteger,
                                  FormatDateTime('DD.MM.YYYY', StrToDate(qrQuery.FieldByName('BeginDate').AsString, formatDate)),
                                  FormatDateTime('DD.MM.YYYY', StrToDate(qrQuery.FieldByName('EndDate').AsString, formatDate))]),
      TObject(qrQuery.FieldByName('Id_Period').AsInteger));
    qrQuery.Next();
  end;
  qrQuery.Close(); 
end;

procedure TfrmDistCost.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmDistCost.FormShow(Sender: TObject);
begin
  FillPeriods();
end;

function TfrmDistCost.GetId_Period: Integer;
begin
  Result := Integer((cbPeriod.Properties as TcxComboBoxProperties).Items.Objects[(cbPeriod.Properties as TcxComboBoxProperties).Items.IndexOf(cbPeriod.EditValue)]);
end;

procedure TfrmDistCost.RefreshData;
var
  k: Integer;
  formatDate: TFormatSettings;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := 'rep_distcost_sel :Id_Period';
  qrQuery.Parameters.ParamValues['Id_Period'] := Id_Period;
  qrQuery.Open();
  tblReport.BeginUpdate();
  try
    tblReport.DataController.RecordCount := qrQuery.RecordCount;
    qrQuery.First();
    formatDate.DateSeparator := '-';
    formatDate.ShortDateFormat := 'yyyy-mm-dd';
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      tblReport.DataController.Values[k, 0] := qrQuery.FieldByName('DistributionCost').AsString;
      tblReport.DataController.Values[k, 1] := qrQuery.FieldByName('Price').AsFloat;
      tblReport.DataController.Values[k, 2] := qrQuery.FieldByName('PercentPrice').AsFloat;
      qrQuery.Next();
    end;  
  finally
    tblReport.EndUpdate();
  end;
  qrQuery.Close();
end;

end.
