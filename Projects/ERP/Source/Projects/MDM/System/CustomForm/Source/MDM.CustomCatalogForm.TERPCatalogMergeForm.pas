unit MDM.CustomCatalogForm.TERPCatalogMergeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridLevel, cxGrid, System.Actions, Vcl.ActnList, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;

type
  TCatalogMergeInfo = record
    Caption: string;
    Connection: TFDConnection;
    UserName: string;
    ProcMeta: string;
    ProcSelect: string;
    ProcExecute: string;
    Id_Draft: Integer;
  end;

  TMergeResultInfo = record
    AssignValue: Boolean;
    Row: Integer;
  end;

  TMergeResultInfoArray = TArray<TMergeResultInfo>;

  TfrmCatalogMerge = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    tblMerge: TcxGridTableView;
    btnMerge: TButton;
    btnCancel: TButton;
    ActionList: TActionList;
    acCancel: TAction;
    acMerge: TAction;
    qrQuery: TFDQuery;
    qrQueryMeta: TFDQuery;
    cxStyleRepository: TcxStyleRepository;
    stlGreen: TcxStyle;
    stlRed: TcxStyle;
    ttDraftMerge: TsmFireDACTempTable;
    stlYellow: TcxStyle;
    Panel3: TPanel;
    cxLevelResult: TcxGridLevel;
    cxGridResult: TcxGrid;
    tblMergeResult: TcxGridTableView;
    stlBlue: TcxStyle;
    ttDraftId: TsmFireDACTempTable;
    procedure acCancelExecute(Sender: TObject);
    procedure acMergeUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acMergeExecute(Sender: TObject);
    procedure tblMergeStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure tblMergeCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
  private
    FCatalogMergeInfo: TCatalogMergeInfo;
    FMergeResultInfo: TMergeResultInfoArray;
    function DraftMerge: Boolean;
    function IsMerged: Boolean;
    function IsConflict: Boolean;
    function VarToBooleanDef(const aValue: Variant; aDefault: Boolean): Boolean;
    procedure CreateColumnSelect(aGrid: TcxGridTableView);
    procedure CreateColumnVersion(aGrid: TcxGridTableView);
    procedure Init;
    procedure OnChange(Sender: TObject);
    procedure OnGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure OnGetGraphicClass(AItem: TObject; ARecordIndex: Integer; APastingFromClipboard: Boolean;
      var AGraphicClass: TGraphicClass);
    procedure ReCreateColumn(aQuery, aQueryMeta: TDataSet; aGrid, aGridResult: TcxGridTableView);
    procedure RefreshData;
    procedure ChooseGoldRecord;
  public
    constructor Create(aOwner: TComponent; aCatalogMergeInfo: TCatalogMergeInfo); reintroduce;
    procedure AfterConstruction; override;
  end;

implementation

uses
  System.Math,
  cxImage,
  cxCheckBox,
  ShateM.Utils.MSSQL,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  MDM.Package.CustomForm.TcxGridTableViewHelper;

type
  ECatalogMergeException = class(Exception);

{$R *.dfm}

procedure TfrmCatalogMerge.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmCatalogMerge.acMergeExecute(Sender: TObject);
begin
  if DraftMerge() then
    Close();
end;

procedure TfrmCatalogMerge.acMergeUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := IsMerged() and not IsConflict();
end;

procedure TfrmCatalogMerge.AfterConstruction;
begin
  inherited AfterConstruction();
  try
    RefreshData();
  except
    raise ECatalogMergeException.Create('Ошибка загрузки окна Слияния');
  end;
end;

procedure TfrmCatalogMerge.ChooseGoldRecord;
var
  k, i: Integer;
  ColumnDraft: TcxGridColumn;
  ColumnIndex: Integer;
  ColumnSelectIndex: Integer;
  ColumnDraftIndex: Integer;
  Result: Variant;
  AssignValue: Variant;
  CountError: Integer;
  Row: Integer;
begin
  tblMergeResult.BeginUpdate();
  try
    ColumnSelectIndex := tblMerge.FindItemByName('colSelect').Index;
    for k := 0 to tblMergeResult.ColumnCount - 1 do
      if tblMergeResult.Columns[k].IsMeta then
      begin
        CountError := 0;
        tblMergeResult.DataController.Values[0, k] := Null();
        FMergeResultInfo[k].AssignValue := False;
        FMergeResultInfo[k].Row := -1;
        ColumnIndex := tblMerge.FindItemByFieldName(tblMergeResult.Columns[k].FieldName).Index;
        ColumnDraft := tblMerge.FindItemByFieldName('Draft' + tblMergeResult.Columns[k].FieldName);
        if Assigned(ColumnDraft) then
        begin
          ColumnDraftIndex := ColumnDraft.Index;

          Result := Null();
          AssignValue := False;
          Row := -1;

          for i := tblMerge.DataController.RecordCount - 1 downto 0 do
            if VarToBooleanDef(tblMerge.DataController.Values[i, ColumnSelectIndex], False) then
              if ((not AssignValue) or (tblMerge.DataController.Values[i, ColumnDraftIndex] >= 1)) and (CountError < 2) then
              begin
                if tblMerge.DataController.Values[i, ColumnDraftIndex] >= 2 then
                  Inc(CountError);
                if CountError >= 2 then
                begin
                  Result := Null();
                  AssignValue := False;
                  Row := -1;
                  Break;
                end
                else
                begin
                  Result := tblMerge.DataController.Values[i, ColumnIndex];
                  AssignValue := True;
                  Row := i;
                end;
              end;
        end
        else
        begin
          Result := tblMerge.DataController.Values[tblMerge.DataController.RecordCount - 1, ColumnIndex];
          AssignValue := True;
          Row := tblMerge.DataController.RecordCount - 1;
        end;
        if tblMergeResult.Columns[k].PropertiesClass = TcxImageProperties then
        begin
          if VarIsNull(Result) then
          begin
            tblMergeResult.DataController.Values[0, k + 1] := '';
            tblMergeResult.DataController.Values[0, k] := Result;
          end
          else
          begin
            tblMergeResult.DataController.Values[0, k + 1] := TERPMethodHelp.GetImageClassNameFromMimeType(BytesOf(string(Result)));
            tblMergeResult.DataController.Values[0, k] := StringOf(BytesOf(string(Result)));
          end;
        end
        else
          tblMergeResult.DataController.Values[0, k] := Result;
        FMergeResultInfo[k].AssignValue := AssignValue;
        FMergeResultInfo[k].Row := Row;
      end;
    for k := tblMerge.DataController.RecordCount - 1 downto 0 do
      if VarToBooleanDef(tblMerge.DataController.Values[k, ColumnSelectIndex], False) then
      begin
        tblMergeResult.DataController.Values[0, tblMergeResult.FindItemByName('colResultVersion').Index] := tblMerge.DataController.Values[k, tblMerge.FindItemByFieldName('Version').Index];
        Break;
      end;
  finally
    tblMergeResult.EndUpdate();
  end;
  tblMerge.Invalidate(True);
end;

constructor TfrmCatalogMerge.Create(aOwner: TComponent; aCatalogMergeInfo: TCatalogMergeInfo);
begin
  inherited Create(aOwner);
  FCatalogMergeInfo := aCatalogMergeInfo;
  Init();
end;

procedure TfrmCatalogMerge.CreateColumnSelect(aGrid: TcxGridTableView);
var
  Column: TcxGridColumnField;
begin
  Column := aGrid.CreateColumnField();
  Column.Caption := 'Слияние';
  Column.Name := 'colSelect';
  Column.HeaderAlignmentHorz := taCenter;
  Column.PropertiesClass := TcxCheckBoxProperties;
  (Column.Properties as TcxCheckBoxProperties).NullStyle := nssUnchecked;
  (Column.Properties as TcxCheckBoxProperties).ImmediatePost := True;
  (Column.Properties as TcxCheckBoxProperties).OnChange := OnChange;
end;

procedure TfrmCatalogMerge.CreateColumnVersion(aGrid: TcxGridTableView);
var
  Column: TcxGridColumnField;
begin
  Column := aGrid.CreateColumnField();
  Column.Caption := 'Версия';
  Column.HeaderAlignmentHorz := taCenter;
  Column.Name := 'colResultVersion';
  Column.Styles.Content := stlYellow;
end;

function TfrmCatalogMerge.DraftMerge: Boolean;
var
  k: Integer;
  MSSQLFieldTable: TMSSQLFieldTable;
  InsertValues: array of TFieldValue;
  ColumnIndexSelect: Integer;
begin
  CreateSQLCursor();
  ttDraftId.CreateTempTable();
  try
    ColumnIndexSelect := tblMerge.FindItemByName('colSelect').Index;
    for k := 0 to tblMerge.DataController.RecordCount - 1 do
      if VarToBooleanDef(tblMerge.DataController.Values[k, ColumnIndexSelect], False) then
        ttDraftId.InsertTempTable([TFieldValue.Create('Id_Draft', tblMerge.DataController.Values[k, 0])]);

    ttDraftMerge.Fields.Clear();
    for k := 0 to tblMergeResult.ColumnCount - 1 do
      if tblMergeResult.Columns[k].IsMeta then
      begin
        MSSQLFieldTable := ttDraftMerge.Fields.Add();
        MSSQLFieldTable.FieldName := tblMergeResult.Columns[k].FieldName;
        MSSQLFieldTable.MSSQLDataType := TMSSQLFieldType.GetMSSQLFieldTypeFromString(tblMergeResult.Columns[k].FieldType);
        MSSQLFieldTable.Size := tblMergeResult.Columns[k].FieldSize;
      end;
    ttDraftMerge.CreateTempTable();
    try
      SetLength(InsertValues, 0);
      for k := 0 to tblMergeResult.ColumnCount - 1 do
        if tblMergeResult.Columns[k].IsMeta then
        begin
          SetLength(InsertValues, Length(InsertValues) + 1);
          InsertValues[Length(InsertValues) - 1] := TFieldValue.Create(tblMergeResult.Columns[k].FieldName,
                                                                       tblMergeResult.DataController.Values[0, k]);
        end;
      ttDraftMerge.InsertTempTable(InsertValues);
      Result := TERPQueryHelp.Open(FCatalogMergeInfo.Connection, FCatalogMergeInfo.ProcExecute,
        [TERPParamValue.Create(FCatalogMergeInfo.UserName),
         TERPParamValue.Create(tblMergeResult.DataController.Values[0, tblMergeResult.FindItemByName('colResultVersion').Index])]);
    finally
      ttDraftMerge.DropTempTable();
    end;
  finally
    ttDraftId.DropTempTable();
  end;
end;

procedure TfrmCatalogMerge.FormShow(Sender: TObject);
begin
{  try
    RefreshData();
  except
    raise ECatalogMergeException.Create('Ошибка загрузки окна Слияния');
  end;}
end;

procedure TfrmCatalogMerge.Init;
begin
  Caption := FCatalogMergeInfo.Caption + ' Слияние';
  qrQuery.Connection := FCatalogMergeInfo.Connection;
  qrQueryMeta.Connection := FCatalogMergeInfo.Connection;
  qrQueryMeta.SQL.Text := FCatalogMergeInfo.ProcMeta;
  ttDraftMerge.Connection := FCatalogMergeInfo.Connection;
  ttDraftId.Connection := FCatalogMergeInfo.Connection;
end;

function TfrmCatalogMerge.IsConflict: Boolean;
var
  k: Integer;
begin
  for k := 0 to tblMergeResult.ColumnCount - 1 do
    if tblMergeResult.Columns[k].IsMeta then
      if not FMergeResultInfo[k].AssignValue then
        Exit(True);
  Exit(False);
end;

function TfrmCatalogMerge.IsMerged: Boolean;
var
  k: Integer;
  Count: Integer;
begin
  Count := 0;
  for k := 0 to tblMerge.DataController.RecordCount - 1 do
  begin
    if VarToBooleanDef(tblMerge.DataController.Values[k, tblMerge.FindItemByName('colSelect').Index], False) then
      Inc(Count);
    if Count >= 2 then
      Exit(True);
  end;
  Result := False;
end;

procedure TfrmCatalogMerge.OnChange(Sender: TObject);
begin
  ChooseGoldRecord();
end;

procedure TfrmCatalogMerge.OnGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
var
  Column: TcxGridColumnField;
  ColumnSelect: TcxGridColumnField;
  k: Integer;
begin
  if SameText(Sender.Name, 'tblMerge') then
  begin
    Column := (Sender as TcxGridTableView).FindItemByFieldName('Draft' + (AItem as TcxGridColumnField).FieldName);
    ColumnSelect := Sender.FindItemByName('colSelect') as TcxGridColumnField;
    if Assigned(Column) then
    begin
      case ARecord.Values[Column.Index] of
        0:;
        1:
            AStyle := stlGreen;
        else
          begin
            AStyle := stlGreen;

            if VarToBooleanDef(ARecord.Values[ColumnSelect.Index], False) then
              for k := 0 to Sender.DataController.RecordCount - 1 do
                if (VarToBooleanDef(Sender.DataController.Values[k, ColumnSelect.Index], False)) and
                   (k <> ARecord.Index) and
                   (Sender.DataController.Values[k, Column.Index] >= 2) then
                  AStyle := stlRed;
          end;
      end;
      if Length(FMergeResultInfo) > 0 then
        for k := 0 to Length(FMergeResultInfo) - 1 do
          if not VarIsNull(FMergeResultInfo[k].Row) then
            if FMergeResultInfo[k].Row <> -1 then
              if (VarToBooleanDef(Sender.DataController.Values[FMergeResultInfo[k].Row, ColumnSelect.Index], False)) then
              begin
                Column := tblMerge.FindItemByFieldName(tblMergeResult.Columns[k].FieldName);
                if Assigned(Column) then
                  if (FMergeResultInfo[k].Row = ARecord.Index) and (Column.Index = AItem.Index) then
                    AStyle := stlBlue;
              end;
    end;
  end
  else
    if Length(FMergeResultInfo) > 0 then
      if FMergeResultInfo[AItem.Index].AssignValue then
        AStyle := stlYellow;
end;

procedure TfrmCatalogMerge.OnGetGraphicClass(AItem: TObject; ARecordIndex: Integer; APastingFromClipboard: Boolean;
  var AGraphicClass: TGraphicClass);
var
  Value: string;
begin
  Value := (AItem as TcxGridColumn).GridView.DataController.Values[ARecordIndex, (AItem as TcxGridColumn).Index + 1];
  if not SameText(Value, '') then
    AGraphicClass := GetGraphicClassByName(Value);
end;

procedure TfrmCatalogMerge.ReCreateColumn(aQuery, aQueryMeta: TDataSet; aGrid, aGridResult: TcxGridTableView);
var
  k: Integer;
  FieldName: string;
  Column: TcxGridColumnField;
  ColumnResult: TcxGridColumnField;
  ColumnCaption: string;

  procedure AssignColumnImage(aGrid: TcxGridTableView; aColumn: TcxGridColumnField);
  var
    FieldName: string;
  begin
    aColumn.PropertiesClass := TcxImageProperties;
    (aColumn.Properties as TcxImageProperties).OnGetGraphicClass := OnGetGraphicClass;
    (aColumn.Properties as TcxImageProperties).GraphicClassName := '';
    FieldName := aColumn.FieldName;
    aColumn := aGrid.CreateColumnField();
    aColumn.Visible := False;
    aColumn.Name := 'col' + aColumn.GetParentComponent.Name + FieldName + 'ImageType';
  end;

  procedure AssignColumnCheck(aColumn: TcxGridColumn);
  begin
    aColumn.PropertiesClass := TcxCheckBoxProperties;
    aColumn.Properties.ReadOnly := True;
  end;

begin
  aGrid.ClearItems();
  aGridResult.ClearItems();
  for k := 0 to aQuery.FieldCount - 1 do
  begin
    FieldName := aQuery.Fields.Fields[k].FieldName;
    Column := aGrid.CreateColumnField();
    Column.Options.Editing := False;
    Column.HeaderAlignmentHorz := taCenter;
    Column.FieldName := FieldName;
    ColumnCaption := FieldName;
    if aQueryMeta.Locate('FieldName', FieldName, []) then
    begin
      ColumnCaption := aQueryMeta.FieldByName('FieldCaption').AsString;
      ColumnResult := aGridResult.CreateColumnField();
      ColumnResult.HeaderAlignmentHorz := taCenter;
      ColumnResult.FieldName := FieldName;
      ColumnResult.Caption := ColumnCaption;
      ColumnResult.Styles.OnGetContentStyle := OnGetContentStyle;
      ColumnResult.IsMeta := True;
      ColumnResult.FieldType := aQueryMeta.FieldByName('TypeName').AsString;
      ColumnResult.FieldSize := aQueryMeta.FieldByName('Size').AsInteger;

      Column.FieldType := aQueryMeta.FieldByName('TypeName').AsString;
      Column.FieldSize := aQueryMeta.FieldByName('Size').AsInteger;
      Column.IsMeta := True;
      Column.Caption := ColumnCaption;
      Column.Styles.OnGetContentStyle := OnGetContentStyle;
      if not VarIsNull(aQueryMeta.FieldByName('Id_MetaType').AsVariant) then
        case aQueryMeta.FieldByName('Id_MetaType').AsInteger of
          1:
            begin
              AssignColumnImage(aGrid, Column);
              AssignColumnImage(aGridResult, ColumnResult);
            end;
          2:
            begin
              AssignColumnCheck(Column);
              AssignColumnCheck(ColumnResult);
            end;
        end;
    end
    else
      Column.Visible := False;
  end;

  CreateColumnVersion(aGridResult);
  CreateColumnSelect(aGrid);
end;

procedure TfrmCatalogMerge.RefreshData;
var
  k, i: Integer;
  ImageBuf: TBytes;
  FieldName: string;
  ColumnIndex: Integer;
  ColumnIndexImageType: Integer;
begin
  try
    qrQueryMeta.Open();
    qrQuery.SQL.Text := FCatalogMergeInfo.ProcSelect;
    qrQuery.Params[0].AsInteger := FCatalogMergeInfo.Id_Draft;
    try
      qrQuery.Open();
      tblMerge.BeginUpdate();
      try
        ReCreateColumn(qrQuery, qrQueryMeta, tblMerge, tblMergeResult);
        tblMerge.DataController.RecordCount := qrQuery.RecordCount;
        qrQuery.First();
        for k := 0 to qrQuery.RecordCount - 1 do
        begin
          for i := 0 to qrQuery.FieldCount - 1 do
          begin
            FieldName := qrQuery.Fields.Fields[i].FieldName;
            ColumnIndex := (tblMerge.FindItemByFieldName(FieldName) as TcxGridColumn).Index;
            if qrQueryMeta.Locate('FieldName', FieldName, []) then
            begin
              if not VarIsNull(qrQueryMeta.FieldByName('Id_MetaType').AsVariant) then
                case qrQueryMeta.FieldByName('Id_MetaType').AsInteger of
                  1:
                    begin
                      ColumnIndexImageType := tblMerge.FindItemByName('col' + tblMerge.Name + FieldName + 'ImageType').Index;
                      ImageBuf := qrQuery.Fields.Fields[i].AsBytes;
                      tblMerge.DataController.Values[k, ColumnIndexImageType] := TERPMethodHelp.GetImageClassNameFromMimeType(ImageBuf);
                      if not SameText(tblMerge.DataController.Values[k, ColumnIndexImageType], '') then
                        tblMerge.DataController.Values[k, ColumnIndex] := StringOf(ImageBuf)
                      else
                        tblMerge.DataController.Values[k, ColumnIndex] := Null;
                    end;
                  2:
                    tblMerge.DataController.Values[k, ColumnIndex] := qrQuery.Fields.Fields[i].AsBoolean;
                  else
                    tblMerge.DataController.Values[k, ColumnIndex] := qrQuery.Fields.Fields[i].AsVariant;
                end
              else
                tblMerge.DataController.Values[k, ColumnIndex] := qrQuery.Fields.Fields[i].AsVariant;
            end
            else
              tblMerge.DataController.Values[k, ColumnIndex] := qrQuery.Fields.Fields[i].AsVariant;
          end;
          qrQuery.Next();
        end;
      finally
        tblMerge.EndUpdate();
      end;
    finally
      qrQuery.Close();
    end;
  finally
    qrQueryMeta.Close();
  end;
  tblMergeResult.DataController.RecordCount := 1;
  SetLength(FMergeResultInfo, tblMergeResult.ColumnCount);
  ChooseGoldRecord();
end;

procedure TfrmCatalogMerge.tblMergeCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
var
  ColumnResultIndex: Integer;
  FieldName: string;
begin
  FieldName := (ACellViewInfo.Item as TcxGridColumnField).FieldName;
  ColumnResultIndex := tblMergeResult.FindItemByFieldName(FieldName).Index;
  tblMergeResult.BeginUpdate();
  try
    if ACellViewInfo.Item.PropertiesClass = TcxImageProperties then
    begin
      tblMergeResult.DataController.Values[0, ColumnResultIndex] := Null();
      if VarIsNull(tblMerge.DataController.Values[ACellViewInfo.RecordViewInfo.Index, ACellViewInfo.Item.Index]) then
        tblMergeResult.DataController.Values[0, ColumnResultIndex + 1] := ''
      else
        tblMergeResult.DataController.Values[0, ColumnResultIndex + 1] := TERPMethodHelp.GetImageClassNameFromMimeType(BytesOf(tblMerge.DataController.Values[ACellViewInfo.RecordViewInfo.Index, ACellViewInfo.Item.Index]));
    end;
    tblMergeResult.DataController.Values[0, ColumnResultIndex] := tblMerge.DataController.Values[ACellViewInfo.RecordViewInfo.Index, ACellViewInfo.Item.Index];
    FMergeResultInfo[ColumnResultIndex].AssignValue := True;
    FMergeResultInfo[ColumnResultIndex].Row := ACellViewInfo.RecordViewInfo.Index;
  finally
    tblMergeResult.EndUpdate();
  end;
  tblMerge.Invalidate(True);
end;

procedure TfrmCatalogMerge.tblMergeStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  if VarIsNull(ARecord.Values[0]) then
    AStyle := stlYellow;
end;

function TfrmCatalogMerge.VarToBooleanDef(const aValue: Variant; aDefault: Boolean): Boolean;
begin
  if VarIsNull(aValue) then
    Result := aDefault
  else
    Result := aValue;
end;

end.
