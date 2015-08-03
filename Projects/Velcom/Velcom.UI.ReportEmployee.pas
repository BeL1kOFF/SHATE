unit Velcom.UI.ReportEmployee;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxButtonEdit, cxLabel, cxDropDownEdit, ADODB, ActnList, dxBar, cxBarEditItem,
  cxClasses, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView,
  cxGridCustomView, cxGrid, cxTextEdit, cxCalendar, cxProgressBar, dxStatusBar, cxContainer;

type
  TfrmReportEmployee = class(TForm)
    cxGrid: TcxGrid;
    cxTable: TcxGridDBBandedTableView;
    colEmployee: TcxGridDBBandedColumn;
    cikNumbers: TcxGridDBBandedColumn;
    colDepartment: TcxGridDBBandedColumn;
    colSum: TcxGridDBBandedColumn;
    colSumWork: TcxGridDBBandedColumn;
    colSumNoWork: TcxGridDBBandedColumn;
    colEmployeeId: TcxGridDBBandedColumn;
    cxLevel: TcxGridLevel;
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
    qrQuery: TADOQuery;
    qrCallers: TADOQuery;
    dsCallers: TDataSource;
    btnSendMail: TdxBarLargeButton;
    acSendMail: TAction;
    cxBarEditItem2: TcxBarEditItem;
    sbText: TdxStatusBar;
    dxStatusBar1Container1: TdxStatusBarContainerControl;
    pb: TcxProgressBar;
    procedure acDetailUpdate(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acSaveExcelExecute(Sender: TObject);
    procedure acSaveExcelUpdate(Sender: TObject);
    procedure cxTableCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure acDetailExecute(Sender: TObject);
    procedure acRefreshUpdate(Sender: TObject);
    procedure acSendMailUpdate(Sender: TObject);
    procedure acSendMailExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function GetId_Period: Integer;
    function GetPercentOf(aValue, aTotal: Integer): Integer;
    procedure FillPeriods;
    procedure OnStatusMessage(aMessage: string);
    procedure RefreshCallers;
    procedure UpdateProgress(aPos: Integer; const aCaption: string = '');
    property Id_Period: Integer read GetId_Period;
  public
    { Public declarations }
  end;

implementation

uses
  uDataModule,
  Velcom.ISQLCursor,
  uMain,
  cxGridExportLink,
  USysGlobal,
  ShellAPI,
  DateUtils,
  Velcom.UI.ReportEmployeeDetail,
  Velcom.MultiReportExcel,
  Velcom.SendMail;

{$R *.dfm}

procedure TfrmReportEmployee.acDetailExecute(Sender: TObject);
var
  frmReportEmployeeDetail: TfrmReportEmployeeDetail;
  callers: TCallerRecArray;
  k: Integer;
begin
  SetLength(callers, cxTable.Controller.SelectedRecordCount);
  for k := 0 to cxTable.Controller.SelectedRecordCount - 1 do
  begin
    callers[k].Id_Employee := cxTable.Controller.SelectedRecords[k].Values[cxTable.GetColumnByFieldName('Id_Employee').Index];
    callers[k].Numbers := cxTable.Controller.SelectedRecords[k].Values[cxTable.GetColumnByFieldName('Numbers').Index];
    callers[k].Name := cxTable.Controller.SelectedRecords[k].Values[cxTable.GetColumnByFieldName('EmployeeName').Index];
  end;
  frmReportEmployeeDetail := TfrmReportEmployeeDetail.Create(Self, callers, Id_Period);
  try
    frmReportEmployeeDetail.ShowModal;
  finally
    frmReportEmployeeDetail.Free;
  end;
end;

procedure TfrmReportEmployee.acDetailUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.Controller.SelectedRecordCount > 0;
end;

procedure TfrmReportEmployee.acRefreshExecute(Sender: TObject);
begin
  RefreshCallers();
end;

procedure TfrmReportEmployee.acRefreshUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not VarIsNull(edtPeriods.EditValue);
end;

procedure TfrmReportEmployee.acSaveExcelExecute(Sender: TObject);

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

procedure TfrmReportEmployee.acSaveExcelUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.ViewData.RecordCount > 0;
end;

procedure TfrmReportEmployee.acSendMailExecute(Sender: TObject);
var
  CallerRecArray: TxCallerRecArray;
  FileName: string;
  k: Integer;
  total, count: Integer;
begin
  if Application.MessageBox('Вы уверенны, что хотите начать массовую рассылку отчетов?',
    'Подтверждение', MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2) = IDNO then
    Exit;

  CreateSQLCursor;
  if qrQuery.Active then
    qrQuery.Close;

  UpdateProgress(0, 'Определение списка получателей...');
  qrQuery.SQL.Text := 'rep_empl_sel_maildepartment :Id_User, :Id_Period';
  qrQuery.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
  qrQuery.Parameters.ParamValues['Id_Period'] := Id_Period;

  MainForm.Enabled := False;
  try
    qrQuery.Open;
    qrQuery.First;
    total := qrQuery.RecordCount;
    count := 1;
    while not qrQuery.Eof do
    begin
      UpdateProgress(GetPercentOf(count, total), 'Подготовка данных к построению отчета...');
      cxTable.DataController.Filter.Active := False;
      cxTable.DataController.Filter.Clear;
      cxTable.DataController.Filter.Root.AddItem(cxTable.GetColumnByFieldName('DepartmentName'),
        foEqual, qrQuery.FieldByName('Name').AsString, qrQuery.FieldByName('Name').AsString);
      cxTable.DataController.Filter.Active := True;
      if cxTable.ViewData.RecordCount > 0 then
      begin     
        SetLength(CallerRecArray, cxTable.ViewData.RecordCount);
        for k := 0 to cxTable.ViewData.RecordCount - 1 do
        begin
          CallerRecArray[k].ID := cxTable.ViewData.Records[k].Values[cxTable.GetColumnByFieldName('Id_Employee').Index];
          CallerRecArray[k].Name := cxTable.ViewData.Records[k].Values[cxTable.GetColumnByFieldName('EmployeeName').Index];
          CallerRecArray[k].AbnName := cxTable.ViewData.Records[k].Values[cxTable.GetColumnByFieldName('EmployeeName').Index];
          CallerRecArray[k].Number := cxTable.ViewData.Records[k].Values[cxTable.GetColumnByFieldName('Numbers').Index];
        end;
                         
        UpdateProgress(GetPercentOf(count, total), 'Построение отчета по отделу: ' + qrQuery.FieldByName('Name').AsString);

        FileName := MultiExportCurToExcel(MainForm.connVelcom, Id_Period,
          CallerRecArray, True, qrQuery.FieldByName('Name').AsString, OnStatusMessage);

        UpdateProgress(GetPercentOf(count, total), 'Отправка письма по отделу: ' + qrQuery.FieldByName('Name').AsString);

        SendMail(DM.IdSMTP, 'Отдел: ' + qrQuery.FieldByName('Name').AsString,
          qrQuery.FieldByName('EMail').AsString, FileName);
      end;

      Inc(count);
      qrQuery.Next;
    end;

    MsgBoxInfo('Рассылка завершена');
  finally
    cxTable.DataController.Filter.Active := False;
    cxTable.DataController.Filter.Clear;
    qrQuery.Close;
    UpdateProgress(0, ' ');
    MainForm.Enabled := True;
  end;
end;

procedure TfrmReportEmployee.acSendMailUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.ViewData.RecordCount > 0;
end;

procedure TfrmReportEmployee.cxTableCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnDetail.Click();
end;

procedure TfrmReportEmployee.FillPeriods;
var
  k: Integer;
  formatDate: TFormatSettings;
begin
  qrQuery.SQL.Text := 'rep_empl_sel_periods';
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

procedure TfrmReportEmployee.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmReportEmployee.FormShow(Sender: TObject);
begin
  if not MainForm.CurrentUser.CanWrite then
    btnSendMail.Visible := ivNever;
  FillPeriods();
end;

function TfrmReportEmployee.GetId_Period: Integer;
begin
  Result := Integer((edtPeriods.Properties as TcxComboBoxProperties).Items.Objects[(edtPeriods.Properties as TcxComboBoxProperties).Items.IndexOf(edtPeriods.EditValue)]);
end;

function TfrmReportEmployee.GetPercentOf(aValue, aTotal: Integer): Integer;
begin
  Result := (aValue * 100) div aTotal;
end;

procedure TfrmReportEmployee.OnStatusMessage(aMessage: string);
begin
  UpdateProgress(Round(pb.Position), 'Построение отчета по отделу: ' + qrQuery.FieldByName('Name').AsString + '; ' + aMessage);
end;

procedure TfrmReportEmployee.RefreshCallers;
begin
  CreateSQLCursor();
  if qrCallers.Active then
    qrCallers.Close;
  cxTable.BeginUpdate;
  try
    qrCallers.SQL.Text := 'rep_empl_sel :Id_User, :Id_Period';
    qrCallers.Parameters.ParamValues['Id_User'] := MainForm.CurrentUser.ID;
    qrCallers.Parameters.ParamValues['Id_Period'] := Id_Period;
    qrCallers.Open;
  finally
    cxTable.EndUpdate;
  end;
end;

procedure TfrmReportEmployee.UpdateProgress(aPos: Integer; const aCaption: string);
begin
  if pb.Position <> aPos then
    pb.Position := aPos;
  if aCaption <> '' then
    sbText.Panels.Items[0].Text := aCaption;
  Application.ProcessMessages;
end;

end.
