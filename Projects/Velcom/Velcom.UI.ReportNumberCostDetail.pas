unit Velcom.UI.ReportNumberCostDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxLabel, cxTextEdit, cxDropDownEdit, ActnList, ADODB, dxBar, cxBarEditItem,
  cxClasses, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGridCustomView, cxGrid;

type
  TCallerRec = record
    Id_Caller: Integer;
    Id_Cost: Integer;
  end;

  TfrmReportNumberCostDetail = class(TForm)
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
    cxBarEditItem8: TcxBarEditItem;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    edtTimeFilter: TcxBarEditItem;
    qrReport: TADOQuery;
    dsReport: TDataSource;
    ActionList: TActionList;
    acRefresh: TAction;
    acSaveExcel: TAction;
    procedure acRefreshExecute(Sender: TObject);
    procedure cxTableColumn1StylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure cxTableColumn5StylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure cxTableColumn6StylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    procedure edtMailPropertiesChange(Sender: TObject);
    procedure acSaveExcelExecute(Sender: TObject);
    procedure acSaveExcelUpdate(Sender: TObject);
  private
    FId_Period: Integer;
    FCallerRec: TCallerRec;
    function GetParamIsWorkTime(aItemIndex: Integer): Integer;
    procedure ExportOneExcel;
    procedure RefreshDetail;
  public
    constructor Create(aOwner: TComponent; const aCallerRec: TCallerRec; aId_Period: Integer); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  uMain,
  uDataModule,
  cxGridExportLink,
  USysGlobal,
  ShellAPI,
  Velcom.ISQLCursor;

{ TfrmReportNumberCostDetail }

procedure TfrmReportNumberCostDetail.acRefreshExecute(Sender: TObject);
begin
  RefreshDetail();
end;

procedure TfrmReportNumberCostDetail.acSaveExcelExecute(Sender: TObject);
begin
  ExportOneExcel();
end;

procedure TfrmReportNumberCostDetail.acSaveExcelUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (cxTable.ViewData.RecordCount > 0);
end;

constructor TfrmReportNumberCostDetail.Create(aOwner: TComponent; const aCallerRec: TCallerRec;
  aId_Period: Integer);
begin
  inherited Create(aOwner);
  FId_Period := aId_Period;
  FCallerRec.Id_Caller := aCallerRec.Id_Caller;
  FCallerRec.Id_Cost := aCallerRec.Id_Cost;
end;

procedure TfrmReportNumberCostDetail.cxTableColumn1StylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin
  if ARecord.Values[cxTable.GetColumnByFieldName('IsWorkTime').Index] = 0 then
    AStyle := DM.stlRed;
end;

procedure TfrmReportNumberCostDetail.cxTableColumn5StylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin
  case ARecord.Values[cxTable.GetColumnByFieldName('IsAbonent').Index] of
    1:
      AStyle := DM.stlGreen;
    2:
      AStyle := DM.stlNavy;
  end;
end;

procedure TfrmReportNumberCostDetail.cxTableColumn6StylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
begin
  case ARecord.Values[cxTable.GetColumnByFieldName('IsAbonent').Index] of
    1:
      AStyle := DM.stlGreen;
    2:
      AStyle := DM.stlNavy;
  end;
end;

procedure TfrmReportNumberCostDetail.edtMailPropertiesChange(Sender: TObject);
begin
  (Sender as TcxTextEdit).PostEditValue();
end;

procedure TfrmReportNumberCostDetail.ExportOneExcel;
begin
  if DM.sdExcel.Execute() then
  begin
    ExportGridToXLSX(DM.sdExcel.FileName, cxGrid, False, True, False);
    if MsgBoxYN('Открыть файл?') then
      ShellExecute(Handle, 'open', PChar(DM.sdExcel.FileName), '', PChar(ExtractFilePath(DM.sdExcel.FileName)), SW_SHOWNORMAL);
  end;
end;

function TfrmReportNumberCostDetail.GetParamIsWorkTime(
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

procedure TfrmReportNumberCostDetail.RefreshDetail;
begin
  CreateSQLCursor();
  if qrReport.Active then
    qrReport.Close;
  qrReport.SQL.Text := 'rep_numbcost_sel_detail :Id_User, :Id_Period, :Id_Caller, :Id_Cost, :IsWorkTime';
  qrReport.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
  qrReport.Parameters.ParamValues['Id_Period'] := FId_Period;
  qrReport.Parameters.ParamValues['Id_Caller'] := FCallerRec.Id_Caller;
  qrReport.Parameters.ParamValues['Id_Cost'] := FCallerRec.Id_Cost;
  qrReport.Parameters.ParamValues['IsWorkTime'] := GetParamIsWorkTime((edtTimeFilter.Properties as TcxComboBoxProperties).Items.IndexOf(edtTimeFilter.EditValue));
  qrReport.Open;
end;

end.
