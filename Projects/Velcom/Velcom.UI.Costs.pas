unit Velcom.UI.Costs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxClasses, cxGridCustomView, cxGrid,
  StdCtrls, ExtCtrls, DB, ADODB, dxBar, ActnList, cxCheckBox;

type
  TfrmCost = class(TForm)
    Panel6: TPanel;
    cxGrid: TcxGrid;
    cxTable: TcxGridTableView;
    colId_Costs: TcxGridColumn;
    colName: TcxGridColumn;
    colNDS: TcxGridColumn;
    cxLevel: TcxGridLevel;
    qrQuery: TADOQuery;
    dxBarManager1: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    ActionList: TActionList;
    acRefresh: TAction;
    acSave: TAction;
    colIsSubscriberService: TcxGridColumn;
    procedure acSaveExecute(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure RefreshCost;
    procedure Save;
  public
    { Public declarations }
  end;

implementation

uses
  uMain,
  uDataModule,
  Velcom.ISQLCursor,
  USysGlobal;

{$R *.dfm}

procedure TfrmCost.acRefreshExecute(Sender: TObject);
begin
  RefreshCost();
end;

procedure TfrmCost.acSaveExecute(Sender: TObject);
begin
  Save();
end;

procedure TfrmCost.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cxTable.ViewData.RecordCount > 0;
end;

procedure TfrmCost.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmCost.FormShow(Sender: TObject);
begin
  RefreshCost();
end;

procedure TfrmCost.RefreshCost;
var
  k: Integer;
begin
  CreateSQLCursor();
  if qrQuery.Active then
    qrQuery.Close;
  qrQuery.SQL.Text := 'cst_sel_item';
  cxTable.BeginUpdate;
  try
    qrQuery.Open;
    cxTable.DataController.RecordCount := qrQuery.RecordCount;
    qrQuery.First;
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cxTable.DataController.Values[k, 0] := qrQuery.FieldByName('Id_Cost').AsInteger;
      cxTable.DataController.Values[k, 1] := qrQuery.FieldByName('Name').AsString;
      cxTable.DataController.Values[k, 2] := qrQuery.FieldByName('Vat').AsVariant;
      cxTable.DataController.Values[k, 3] := qrQuery.FieldByName('IsSubscriberService').AsVariant;
      qrQuery.Next;
    end;
  finally
    cxTable.EndUpdate;
  end;
  qrQuery.Close();
end;

procedure TfrmCost.Save;
var
  k: Integer;
  ResultText: string;
  IsError: Boolean;
begin
  CreateSQLCursor();
  if qrQuery.Active then
    qrQuery.Close;
  qrQuery.Connection.BeginTrans;
  try
    IsError := False;
    ResultText := 'Данные сохранены';
    for k := 0 to cxTable.DataController.RecordCount - 1 do
    begin
      if qrQuery.Active then
        qrQuery.Close;
      qrQuery.SQL.Text := 'cst_edt_item :Id_Cost, :Vat, :IsSubscriberService';
      qrQuery.Parameters.ParamValues['Id_Cost'] := cxTable.DataController.Values[k, 0];
      qrQuery.Parameters.ParamValues['Vat'] := cxTable.DataController.Values[k, 2];
      qrQuery.Parameters.ParamValues['IsSubscriberService'] := cxTable.DataController.Values[k, 3];
      qrQuery.Open;
      if qrQuery.Fields.Fields[0].AsInteger = -1 then
      begin
        IsError := True;
        ResultText := qrQuery.Fields.Fields[1].AsString;
        Break;
      end;
    end;
    qrQuery.Close;
    if IsError then
      qrQuery.Connection.RollbackTrans
    else
      qrQuery.Connection.CommitTrans;
    MsgBoxInfo(ResultText);
  except
    qrQuery.Connection.RollbackTrans;
  end;
end;

end.
