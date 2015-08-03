unit ERP.Package.Components.UI.TImportForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, Vcl.ExtCtrls, System.Actions, Vcl.ActnList, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxClasses, cxGridLevel, cxGrid,
  ERP.Package.Components.TCatalogImportExcel, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable, cxLabel;

type
  TImportForm = class(TForm)
    GroupBox1: TGroupBox;
    edtFileName: TcxButtonEdit;
    odImport: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    ActionList: TActionList;
    acImport: TAction;
    acCancel: TAction;
    btnExport: TButton;
    btnCancel: TButton;
    cxLevelImport: TcxGridLevel;
    cxGridImport: TcxGrid;
    tblImport: TcxGridTableView;
    colBaseCaption: TcxGridColumn;
    colExcelField: TcxGridColumn;
    memQuery: TFDMemTable;
    cxStyleRepository: TcxStyleRepository;
    stlYellow: TcxStyle;
    colPK: TcxGridColumn;
    colBaseField: TcxGridColumn;
    colBaseType: TcxGridColumn;
    colBaseSize: TcxGridColumn;
    ttImportExcel: TsmFireDACTempTable;
    edtLabel: TcxTextEdit;
    cxLabel1: TcxLabel;
    procedure edtFileNamePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure acCancelExecute(Sender: TObject);
    procedure tblImportDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure tblImportDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure acImportUpdate(Sender: TObject);
    procedure acImportExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tblImportStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FCatalogImportExcel: TCatalogImportExcel;
    FileLock: TFileStream;
    function GetFieldNamePK: string;
    function IsCheckedImport: Boolean;
    procedure CreateFieldMemTable;
    procedure RefreshGridDB;
    procedure RefreshGridExcel;
    procedure ImportFromExcel;
  public
    constructor Create(aOwner: TComponent); override;
  end;

var
  ImportForm: TImportForm;

implementation

uses
  System.Math,
  ERP.Package.CustomInterface.ICustomCursor,
  Excel_TLB,
  ShateM.Utils.MSSQL,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  ERP.Package.CustomGlobalFunctions.ExcelFunctions;

const
  COL_BASEFIELD   = 0;
  COL_BASECAPTION = 1;
  COL_EXCELFIELD  = 2;
  COL_PK          = 3;
  COL_BASETYPE    = 4;
  COL_BASESIZE    = 5;

{$R *.dfm}

procedure TImportForm.acCancelExecute(Sender: TObject);
begin
  Close();
  ModalResult := mrCancel;
end;

procedure TImportForm.acImportExecute(Sender: TObject);
begin
  ImportFromExcel();
end;

procedure TImportForm.acImportUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblImport.DataController.RecordCount > 0;
end;

constructor TImportForm.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FCatalogImportExcel := aOwner as TCatalogImportExcel;
  FileLock := nil;
end;

procedure TImportForm.CreateFieldMemTable;
var
  k: Integer;
  FieldName: string;
  DataType: string;
  Size: Integer;
begin
  memQuery.FieldDefs.Clear();
  for k := 0 to tblImport.DataController.RecordCount - 1 do
    if not SameText(tblImport.DataController.Values[k, COL_EXCELFIELD], '') then
    begin
      FieldName := tblImport.DataController.Values[k, COL_EXCELFIELD];
      DataType := tblImport.DataController.Values[k, COL_BASETYPE];
      Size := tblImport.DataController.Values[k, COL_BASESIZE];
      memQuery.FieldDefs.Add(FieldName, ttImportExcel.GetCrossDataType(TMSSQLFieldType.GetMSSQLFieldTypeFromString(DataType)));
      if memQuery.FieldDefs.Items[memQuery.FieldDefs.Count - 1].DataType in [ftWideString, ftString] then
        if Size > 0 then
          memQuery.FieldDefs.Items[memQuery.FieldDefs.Count - 1].Size := Size
        else
          memQuery.FieldDefs.Items[memQuery.FieldDefs.Count - 1].Size := 0;
    end;
end;

procedure TImportForm.edtFileNamePropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
  if odImport.Execute() then
  begin
    if Assigned(FileLock) then
      FileLock.Free();
    edtFileName.Text := odImport.FileName;
    FileLock := TFileStream.Create(edtFileName.Text, fmOpenRead or fmShareDenyWrite);
    CreateSQLCursor();
    RefreshGridDB();
    RefreshGridExcel();
  end;
end;

procedure TImportForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FileLock) then
    FileLock.Free();
end;

procedure TImportForm.FormShow(Sender: TObject);
begin
  ttImportExcel.Connection := FCatalogImportExcel.Connection;
end;

function TImportForm.GetFieldNamePK: string;
var
  k: Integer;
begin
  for k := 0 to tblImport.DataController.RecordCount - 1 do
    if tblImport.DataController.Values[k, COL_PK] then
      Exit(tblImport.DataController.Values[k, COL_EXCELFIELD]);
  Result := '';
end;

procedure TImportForm.ImportFromExcel;
var
  k, i: Integer;
  TempFieldTable: TMSSQLFieldTable;
  ArrFieldValue: array of TFieldValue;
  ColumnCount: Integer;
  RecordCount: Integer;
begin
  CreateSQLCursor();
  CreateFieldMemTable();
  ImportQueryFromExcel(memQuery, FCatalogImportExcel.SheetName, edtFileName.Text);

  ColumnCount := tblImport.DataController.RecordCount;
  RecordCount := memQuery.RecordCount;

  ttImportExcel.Fields.Clear();
  for k := 0 to ColumnCount - 1 do
  begin
    TempFieldTable := ttImportExcel.Fields.Add();
    TempFieldTable.FieldName := tblImport.DataController.Values[k, COL_BASEFIELD];
    TempFieldTable.MSSQLDataType := TMSSQLFieldType.GetMSSQLFieldTypeFromString(tblImport.DataController.Values[k, COL_BASETYPE]);
    TempFieldTable.SetSizeScalePrecision(tblImport.DataController.Values[k, COL_BASESIZE]);
  end;
  ttImportExcel.CreateTempTable();
  try
    memQuery.First();
    SetLength(ArrFieldValue, ColumnCount);
    for k := 0 to RecordCount - 1 do
    begin
      if not SameText(GetFieldNamePK(), '') then
        if memQuery.FieldByName(GetFieldNamePK()).AsInteger = 0 then
        begin
          memQuery.Edit();
          memQuery.FieldByName(GetFieldNamePK()).AsVariant := Null;
          memQuery.Post();
        end;
      for i := 0 to ColumnCount - 1 do
        if SameText(tblImport.DataController.Values[i, COL_EXCELFIELD], '') then
          ArrFieldValue[i] := TFieldValue.Create(tblImport.DataController.Values[i, COL_BASEFIELD], Null)
        else
          if not SameText(tblImport.DataController.Values[i, COL_BASEFIELD], '') then
            ArrFieldValue[i] := TFieldValue.Create(tblImport.DataController.Values[i, COL_BASEFIELD], memQuery.Fields.FieldByName(tblImport.DataController.Values[i, COL_EXCELFIELD]).AsVariant);
      ttImportExcel.InsertTempTable(ArrFieldValue);
      memQuery.Next();
    end;
    memQuery.Close();
    if IsCheckedImport() then
    begin
      if not TERPQueryHelp.Open(FCatalogImportExcel.Connection, FCatalogImportExcel.ProcName,
               [TERPParamValue.Create(FCatalogImportExcel.UserName),
                TERPParamValue.Create(edtLabel.Text)]) then
        ModalResult := mrNone
      else
      begin
        Close();
        ModalResult := mrOk;
      end;
    end;
  finally
    ttImportExcel.DropTempTable();
  end;
end;

function TImportForm.IsCheckedImport: Boolean;
var
  QueryResult: TERPQueryResult;
begin
  QueryResult := TERPQueryHelp.Check(FCatalogImportExcel.Connection, FCatalogImportExcel.ProcCheck,
                                     [TERPParamValue.Create(FCatalogImportExcel.UserName)]);
  Result := QueryResult.Status = QUERY_RESULT_OK;
  if QueryResult.Status = QUERY_RESULT_WARNING then
    Result := TERPMessageHelp.BoxQuestionYN(QueryResult.Text);
end;

procedure TImportForm.RefreshGridDB;
var
  k: Integer;
  qrQuery: TFDQuery;
begin
  tblImport.BeginUpdate();
  try
    qrQuery := TFDQuery.Create(Self);
    try
      qrQuery.Connection := FCatalogImportExcel.Connection;
      qrQuery.SQL.Text := FCatalogImportExcel.ProcMeta;
      qrQuery.Open();
      tblImport.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to tblImport.DataController.RecordCount - 1 do
      begin
        tblImport.DataController.Values[k, COL_BASEFIELD] := qrQuery.FieldByName('FieldName').AsString;
        tblImport.DataController.Values[k, COL_BASECAPTION] := qrQuery.FieldByName('FieldCaption').AsString;
        tblImport.DataController.Values[k, COL_BASETYPE] := qrQuery.FieldByName('TypeName').AsString;
        tblImport.DataController.Values[k, COL_BASESIZE] := qrQuery.FieldByName('Size').AsInteger;
        tblImport.DataController.Values[k, COL_PK] := qrQuery.FieldByName('IsPrimaryKey').AsBoolean;
        qrQuery.Next();
      end;
    finally
      qrQuery.Close();
    end;
  finally
    tblImport.EndUpdate();
  end;
end;

procedure TImportForm.RefreshGridExcel;
var
  k: Integer;
  Loc: LCID;
  Excel: _Application;
  Wb: _Workbook;
  Ws: _Worksheet;
  Cells: ExcelRange;
begin
  tblImport.BeginUpdate();
  try
    Loc := GetUserDefaultLCID();
    Excel := CoExcelApplication.Create();
    try
      Excel.Visible[Loc] := False;
      Excel.DisplayAlerts[Loc] := False;
      Wb := Excel.Workbooks.Open(edtFileName.Text, EmptyParam(), False, EmptyParam(), EmptyParam(), EmptyParam(), True,
        EmptyParam(), EmptyParam(), False, False, EmptyParam(), False, False, xlNormalLoad, Loc);
      if not SameText(FCatalogImportExcel.SheetName, '') then
      begin
        Ws := nil;
        for k := 0 to Wb.Worksheets.Count - 1 do
          if SameText((Wb.Worksheets.Item[k + 1] as _Worksheet).Name, FCatalogImportExcel.SheetName) then
          begin
            Ws := Wb.Worksheets.Item[k + 1] as _Worksheet;
            Break;
          end;
      end
      else
        Ws := Wb.Worksheets.Item[1] as _Worksheet;
      if Assigned(Ws) then
      begin
        Cells := Ws.UsedRange[Loc];
        tblImport.DataController.RecordCount := Max(Cells.Columns.Count, tblImport.DataController.RecordCount);
        for k := 0 to tblImport.DataController.RecordCount - 1 do
        begin
          tblImport.DataController.Values[k, COL_EXCELFIELD] := Cells.Item[1, k + 1];
          if SameText(tblImport.DataController.Values[k, COL_BASEFIELD], '') then
            tblImport.DataController.Values[k, COL_PK] := False;
        end;
      end
      else
        Exception.Create('Имя листа не найдено');
      Excel.Quit();
    finally
      Excel := nil;
    end;
  finally
    tblImport.EndUpdate();
  end;
end;

procedure TImportForm.tblImportDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  GridSite: TcxGridSite;
  GridTableView: TcxGridTableView;
  HitTestRecord: TcxGridRecordCellHitTest;
  TempString: string;
begin
  GridSite := (Sender as TcxGridSite);
  HitTestRecord := GridSite.ViewInfo.GetHitTest(X, Y) as TcxGridRecordCellHitTest;
  GridTableView := GridSite.GridView as TcxGridTableView;
  TempString := GridTableView.Controller.FocusedRecord.Values[GridTableView.Controller.FocusedColumnIndex];
  GridTableView.Controller.FocusedRecord.Values[GridTableView.Controller.FocusedColumnIndex] :=
    HitTestRecord.GridRecord.Values[HitTestRecord.Item.Index];
  HitTestRecord.GridRecord.Values[HitTestRecord.Item.Index] := TempString;
end;

procedure TImportForm.tblImportDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  GridSite: TcxGridSite;
  HitTest: TcxCustomGridHitTest;
  HitTestRecord: TcxGridRecordCellHitTest;
  GridTableView: TcxGridTableView;
begin
  GridSite := (Sender as TcxGridSite);
  HitTest := GridSite.ViewInfo.GetHitTest(X, Y);
  if HitTest is TcxGridRecordCellHitTest then
  begin
    HitTestRecord := HitTest as TcxGridRecordCellHitTest;
    GridTableView := GridSite.GridView as TcxGridTableView;
    Accept := (HitTestRecord.GridRecord.RecordIndex <> GridSite.GridView.DataController.FocusedRecordIndex) and
      (HitTestRecord.Item.Index = GridTableView.Controller.FocusedColumnIndex) and
      (GridTableView.Controller.FocusedColumnIndex = COL_EXCELFIELD);
  end
  else
    Accept := False;
end;

procedure TImportForm.tblImportStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  if ARecord.Values[COL_PK] then
    AStyle := stlYellow;
end;

end.
