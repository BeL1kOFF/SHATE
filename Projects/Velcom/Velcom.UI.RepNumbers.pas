unit Velcom.UI.RepNumbers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxBar, cxClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridLevel, cxGrid, ActnList, DB, ADODB;

type
  TfrmRepNumbers = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    cxTable: TcxGridTableView;
    ActionList: TActionList;
    acRefresh: TAction;
    colNumber: TcxGridColumn;
    colEmployee: TcxGridColumn;
    qrQuery: TADOQuery;
    colBeginDate: TcxGridColumn;
    colEndDate: TcxGridColumn;
    dxBarLargeButton2: TdxBarLargeButton;
    acExcel: TAction;
    procedure FormShow(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acExcelUpdate(Sender: TObject);
    procedure acExcelExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure RefreshNumbers;
  public
    { Public declarations }
  end;

implementation

uses
  uMain,
  uDataModule,
  Velcom.ISQLCursor,
  ExcelXP,
  adoDBUtils,
  cxGridExportLink,
  USysGlobal,
  ShellAPI;

{$R *.dfm}

{ TfrmRepNumbers }

procedure TfrmRepNumbers.acExcelExecute(Sender: TObject);
begin
  if DM.sdExcel.Execute() then
  begin
    ExportGridToXLSX(DM.sdExcel.FileName, cxGrid, False, True, False);
    if MsgBoxYN('Открыть файл?') then
      ShellExecute(Handle, 'open', PChar(DM.sdExcel.FileName), '', PChar(ExtractFilePath(DM.sdExcel.FileName)), SW_SHOWNORMAL);
  end;
end;

procedure TfrmRepNumbers.acExcelUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.ViewData.RecordCount > 0;
end;

procedure TfrmRepNumbers.acRefreshExecute(Sender: TObject);
begin
  RefreshNumbers();
end;

procedure TfrmRepNumbers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmRepNumbers.FormShow(Sender: TObject);
begin
  RefreshNumbers();
end;

procedure TfrmRepNumbers.RefreshNumbers;
var
  k: Integer;
  formatDate: TFormatSettings;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := 'rep_numbhist_sel';
  qrQuery.Open();
  cxTable.BeginUpdate();
  try
    cxTable.DataController.RecordCount := qrQuery.RecordCount;
    qrQuery.First();
    formatDate.DateSeparator := '-';
    formatDate.ShortDateFormat := 'yyyy-mm-dd';
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cxTable.DataController.Values[k, 0] := qrQuery.FieldByName('Number').AsString;
      cxTable.DataController.Values[k, 1] := qrQuery.FieldByName('Name').AsString;
      cxTable.DataController.Values[k, 2] := StrToDate(qrQuery.FieldByName('BeginDate').AsString, formatDate);
      if not VarIsNull(qrQuery.FieldByName('EndDate').AsVariant) then
        cxTable.DataController.Values[k, 3] := StrToDate(qrQuery.FieldByName('EndDate').AsString, formatDate)
      else
        cxTable.DataController.Values[k, 3] := Null;
      qrQuery.Next();
    end;  
  finally
    cxTable.EndUpdate();
  end;
  qrQuery.Close();
end;

end.
