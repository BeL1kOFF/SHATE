unit ERP.Package.Components.UI.TExportForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, System.Actions, Vcl.ActnList, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxClasses, cxGridLevel, cxGrid, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxCheckBox,
  FireDAC.Comp.Client, dxStatusBar,
  cxContainer, cxProgressBar,
  ERP.Package.Components.TCatalogExportExcel,
  ShateM.Components.TCustomTempTable,
  ShateM.Components.TFireDACTempTable;

type
  TExportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnExport: TButton;
    ActionList: TActionList;
    acExport: TAction;
    acCancel: TAction;
    cxLevelExport: TcxGridLevel;
    cxGridExport: TcxGrid;
    tblExport: TcxGridTableView;
    colFieldName: TcxGridColumn;
    colFieldCaption: TcxGridColumn;
    colCheck: TcxGridColumn;
    sdExport: TSaveDialog;
    sbBar: TdxStatusBar;
    sbBarContainer1: TdxStatusBarContainerControl;
    pbExport: TcxProgressBar;
    tmpExport: TsmFireDACTempTable;
    procedure acCancelExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acExportUpdate(Sender: TObject);
    procedure acExportExecute(Sender: TObject);
  private
    FCatalogExportExcel: TCatalogExportExcel;
    function IsCheck: Boolean;
    procedure ExportToExcel;
    procedure FillColumn;
  public
    constructor Create(aOwner: TComponent); override;
  end;

implementation

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.ExcelFunctions;

{$R *.dfm}

procedure TExportForm.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TExportForm.acExportExecute(Sender: TObject);
begin
  ExportToExcel();
  Close();
end;

procedure TExportForm.acExportUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := IsCheck();
end;

constructor TExportForm.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FCatalogExportExcel := aOwner as TCatalogExportExcel;
  tmpExport.Connection := FCatalogExportExcel.Connection;
end;

procedure TExportForm.ExportToExcel;
var
  qrQuery: TFDQuery;
  k: Integer;
begin
  if sdExport.Execute() then
  begin
    CreateSQLCursor();
    tmpExport.CreateTempTable();
    try
      for k := 0 to FCatalogExportExcel.TableView.Controller.SelectedRecordCount - 1 do
        tmpExport.InsertTempTable([TFieldValue.Create('Id', FCatalogExportExcel.TableView.Controller.SelectedRecords[k].Values[FCatalogExportExcel.TableViewIndexId])]);
      qrQuery := TFDQuery.Create(Self);
      try
        qrQuery.Connection := FCatalogExportExcel.Connection;
        qrQuery.SQL.Text := FCatalogExportExcel.ProcName;
        try
          qrQuery.Open();
          ExportQueryToExcel(qrQuery, tblExport.DataController, False, FCatalogExportExcel.SheetName, sdExport.FileName, pbExport);
          Application.MessageBox('Экспорт завершен', 'Сообщение', MB_OK or MB_ICONINFORMATION);
        finally
          qrQuery.Close();
        end;
      finally
        qrQuery.Free();
      end;
    finally
      tmpExport.DropTempTable();
    end;
  end;
end;

procedure TExportForm.FillColumn;
var
  k: Integer;
  qrQuery: TFDQuery;
begin
  tblExport.BeginUpdate();
  try
    qrQuery := TFDQuery.Create(Self);
    try
      qrQuery.Connection := FCatalogExportExcel.Connection;
      qrQuery.SQL.Text := FCatalogExportExcel.ProcMeta;
      try
        qrQuery.Open();
        tblExport.DataController.RecordCount := qrQuery.RecordCount;
        qrQuery.First();
        for k := 0 to tblExport.DataController.RecordCount - 1 do
        begin
          tblExport.DataController.Values[k, 0] := qrQuery.FieldByName('FieldName').AsString;
          tblExport.DataController.Values[k, 1] := qrQuery.FieldByName('FieldCaption').AsString;
          tblExport.DataController.Values[k, 2] := True;
          qrQuery.Next();
        end;
      finally
        qrQuery.Close();
      end;
    finally
      qrQuery.Free();
    end;
  finally
    tblExport.EndUpdate();
  end;
end;

procedure TExportForm.FormShow(Sender: TObject);
begin
  FillColumn();
end;

function TExportForm.IsCheck: Boolean;
var
  k: Integer;
begin
  for k := 0 to tblExport.DataController.RecordCount - 1 do
    if tblExport.DataController.Values[k, 2] then
      Exit(True);
  Result := False;
end;

end.
