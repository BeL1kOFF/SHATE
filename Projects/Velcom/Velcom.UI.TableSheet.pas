unit Velcom.UI.TableSheet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxClasses, cxGridCustomView, cxGrid, DB,
  ADODB, dxBar, ActnList, cxGridBandedTableView, cxLabel, cxCalendar, cxBarEditItem;

type
  TfrmTableSheet = class(TForm)
    ActionList: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    acRefresh: TAction;
    acExternalCode: TAction;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    btnRefresh: TdxBarLargeButton;
    qrQuery: TADOQuery;
    cxGrid: TcxGrid;
    cxLevel: TcxGridLevel;
    cxTable: TcxGridBandedTableView;
    colIdEmployee: TcxGridBandedColumn;
    colEmployeeName: TcxGridBandedColumn;
    dxBarManagerBar2: TdxBar;
    cxBarEditItem1: TcxBarEditItem;
    edtBeginDate: TcxBarEditItem;
    cxBarEditItem3: TcxBarEditItem;
    edtEndDate: TcxBarEditItem;
    colDepartmentName: TcxGridBandedColumn;
    colDistributionCost: TcxGridBandedColumn;
    procedure acRefreshExecute(Sender: TObject);
    procedure cxTableCustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure cxTableEditValueChanged(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
    procedure FormShow(Sender: TObject);
    procedure acRefreshUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure TableSheetRefresh;
    procedure Save(const aValue: string);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  adoDBUtils,
  Velcom.ISQLCursor,
  uDataModule,
  uMain;

const
  COL_ID_EMPLOYEE      = 0;
  COL_EMPLOYEENAME     = 1;
  COL_DEPARTMENTNAME   = 2;
  COL_DISTRIBUTIONCOST = 3;

  COL_FIRST_DATE = 4;

{ TfrmTableSheet }

procedure TfrmTableSheet.acRefreshExecute(Sender: TObject);
begin
  TableSheetRefresh();
end;

procedure TfrmTableSheet.acRefreshUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := StrToDate(edtBeginDate.EditValue) <= StrToDate(edtEndDate.EditValue);
end;

procedure TfrmTableSheet.cxTableCustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
var
  size: TSize;
  rect: TRect;
  clipRegion: TcxRegion;
  k: Integer;
begin
  ACanvas.SetFontAngle(90);
  GetTextExtentPoint32(ACanvas.Handle, PChar(AViewInfo.Text), Length(AViewInfo.Text), size);
  rect := AViewInfo.Bounds;
  Sender.Painter.LookAndFeelPainter.DrawHeader(ACanvas, AViewInfo.Bounds, rect, AViewInfo.Neighbors, AViewInfo.Borders,
    cxbsNormal, taCenter, vaCenter, False, False, '', ACanvas.Font, clNone, Color);
  rect.Left := rect.Right - ((rect.Right - rect.Left) div 2) - (size.cy div 2);
  rect.Right := rect.Left + size.cy;
  rect.Bottom := (rect.Bottom + rect.Top + size.cx) div 2;
  rect.Top := rect.Bottom - size.cx;
  ACanvas.Brush.Style := bsClear;
  ACanvas.Canvas.TextOut(rect.Left, rect.Bottom, AViewInfo.Column.Caption);
  clipRegion := ACanvas.GetClipRegion();
  for k := 0 to AViewInfo.AreaViewInfoCount - 1 do
    AViewInfo.AreaViewInfos[k].Paint();
  ACanvas.SetClipRegion(clipRegion, roSet);
  ADone := True;
end;

procedure TfrmTableSheet.cxTableEditValueChanged(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
  Sender.DataController.PostEditingData;
  if VarIsNull(AItem.EditValue) then
    Save('')
  else
    Save(AItem.EditValue);
end;

procedure TfrmTableSheet.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmTableSheet.FormShow(Sender: TObject);
begin
  edtBeginDate.EditValue := Date();
  edtEndDate.EditValue := Date();
end;

procedure TfrmTableSheet.Save(const aValue: string);
var
  ResultText: string;
  ResultCode: Integer;
  formatSettings: TFormatSettings;
begin
  formatSettings.ShortDateFormat := 'yyyy.mm.dd';
  formatSettings.DateSeparator := '.';
  qrQuery.SQL.Text := 'tbs_edt_item :Id_Employee, :Date, :Type';
  qrQuery.Parameters.ParamValues['Id_Employee'] := cxTable.Controller.FocusedRecord.Values[COL_ID_EMPLOYEE];
  qrQuery.Parameters.ParamValues['Date'] := FormatDateTime('yyyymmdd', StrToDate(cxTable.Controller.FocusedColumn.Caption, formatSettings));
  qrQuery.Parameters.ParamValues['Type'] := aValue;
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
  if ResultCode > 0 then
  begin
    if ResultText <> '' then
      Application.MessageBox(PChar(ResultText), 'Сообщение', MB_OK or MB_ICONINFORMATION);
  end
  else
    Application.MessageBox(PChar(ResultText), 'Ошибка', MB_OK or MB_ICONERROR);
end;

procedure TfrmTableSheet.TableSheetRefresh;
var
  k, i: Integer;
  column: TcxGridBandedColumn;
begin
  CreateSQLCursor();
  StrToDate(edtBeginDate.EditValue);
  qrQuery.SQL.Text := 'tbs_sel_itemlist :Id_User, :BeginDate, :EndDate';
  qrQuery.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
  qrQuery.Parameters.ParamValues['BeginDate'] := FormatDateTime('yyyymmdd', StrToDate(edtBeginDate.EditValue));
  qrQuery.Parameters.ParamValues['EndDate'] := FormatDateTime('yyyymmdd', StrToDate(edtEndDate.EditValue));
  cxTable.BeginUpdate();
  try
    qrQuery.Open();
    while cxTable.ColumnCount > COL_FIRST_DATE do
      cxTable.Columns[COL_FIRST_DATE].Free();
    for k := COL_FIRST_DATE to qrQuery.FieldCount - 1 do
    begin
      column := cxTable.CreateColumn();
      column.Caption := qrQuery.Fields.Fields[k].FieldName;
      column.HeaderAlignmentHorz := taCenter;
      column.Position.BandIndex := 1;
      column.MinWidth := 5;
      column.RepositoryItem := DM.edtTextCenter;
    end;
    cxTable.DataController.RecordCount := qrQuery.RecordCount;
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cxTable.DataController.Values[k, COL_ID_EMPLOYEE] := qrQuery.FieldByName('Id_Employee').AsInteger;
      cxTable.DataController.Values[k, COL_EMPLOYEENAME] := qrQuery.FieldByName('EmployeeName').AsString;
      cxTable.DataController.Values[k, COL_DEPARTMENTNAME] := qrQuery.FieldByName('DepartmentName').AsString;
      cxTable.DataController.Values[k, COL_DISTRIBUTIONCOST] := qrQuery.FieldByName('DistributionCost').AsString;
      for i := COL_FIRST_DATE to qrQuery.FieldCount - 1 do
        cxTable.DataController.Values[k, i] := qrQuery.Fields.Fields[i].AsString;
      qrQuery.Next();
    end;  
  finally
    qrQuery.Close();
    cxTable.EndUpdate();
  end;
  cxTable.OptionsView.HeaderHeight := 70;  
  cxTable.ApplyBestFit();
end;

end.
