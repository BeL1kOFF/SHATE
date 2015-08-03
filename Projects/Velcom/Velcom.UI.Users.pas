unit Velcom.UI.Users;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxBar, cxClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridLevel, cxGrid,
  cxCheckBox, ActnList, DB, ADODB;

type
  TfrmUsers = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    cxTable: TcxGridTableView;
    colId: TcxGridColumn;
    colName: TcxGridColumn;
    colLogin: TcxGridColumn;
    colUser: TcxGridColumn;
    colWrite: TcxGridColumn;
    colAdmin: TcxGridColumn;
    dxBarLargeButton5: TdxBarLargeButton;
    ActionList: TActionList;
    acAdd: TAction;
    acDelete: TAction;
    acRefresh: TAction;
    qrQuery: TADOQuery;
    procedure acRefreshExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxTableEditValueChanged(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
  private
    procedure RefreshUser;
  public
    { Public declarations }
  end;

implementation

uses
  uMain,
  uDataModule,
  Velcom.ISQLCursor;

{$R *.dfm}

{ TfrmUsers }

procedure TfrmUsers.acRefreshExecute(Sender: TObject);
begin
  RefreshUser();
end;

procedure TfrmUsers.cxTableEditValueChanged(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
var
  resultCode: Integer;
  resultText: string;
begin
  qrQuery.SQL.Text := 'usr_edt_item :Id_User, :Field, :Value';
  qrQuery.Parameters.ParamValues['Id_User'] := cxTable.Controller.FocusedRecord.Values[0];
  qrQuery.Parameters.ParamValues['Field'] := AItem.AlternateCaption;
  qrQuery.Parameters.ParamValues['Value'] := AItem.EditValue;
  try
    qrQuery.Open();
    resultCode := qrQuery.Fields.Fields[0].AsInteger;
    resultText := qrQuery.Fields.Fields[1].AsString;
  except on E: Exception do
  begin
    resultCode := -1000;
    resultText := E.Message;
  end;
  end;
  qrQuery.Close();
  if resultCode > 0 then
  begin
    if resultText <> '' then
      Application.MessageBox(PChar(resultText), 'Сообщение', MB_OK or MB_ICONINFORMATION);
  end
  else
    Application.MessageBox(PChar(resultText), 'Ошибка', MB_OK or MB_ICONERROR);
end;

procedure TfrmUsers.FormShow(Sender: TObject);
begin
  RefreshUser();
end;

procedure TfrmUsers.RefreshUser;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := 'usr_sel_itemlist';
  qrQuery.Open();
  cxTable.BeginUpdate();
  try
    cxTable.DataController.RecordCount := qrQuery.RecordCount;
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cxTable.DataController.Values[k, 0] := qrQuery.FieldByName('Id_User').AsInteger;
      cxTable.DataController.Values[k, 1] := qrQuery.FieldByName('Name').AsString;
      cxTable.DataController.Values[k, 2] := qrQuery.FieldByName('CanLogin').AsBoolean;
      cxTable.DataController.Values[k, 3] := qrQuery.FieldByName('CanUser').AsBoolean;
      cxTable.DataController.Values[k, 4] := qrQuery.FieldByName('CanWrite').AsBoolean;
      cxTable.DataController.Values[k, 5] := qrQuery.FieldByName('CanAdmin').AsBoolean;
      qrQuery.Next();
    end;  
  finally
    cxTable.EndUpdate();
  end;
  qrQuery.Close();
end;

end.
