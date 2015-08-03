unit UI.DataBaseForm;

interface

uses
  System.Classes,
  System.Actions,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.ActnList,
  Data.DB,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxStyles,
  cxCustomData,
  cxFilter,
  cxData,
  cxDataStorage,
  cxEdit,
  cxNavigator,
  cxClasses,
  cxGridLevel,
  cxGridCustomTableView,
  cxGridTableView,
  cxGridCustomView,
  cxGrid,
  cxCheckBox,
  dxBar,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TfrmDataBase = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    btnRefresh: TdxBarLargeButton;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    tblDataBase: TcxGridTableView;
    colServer: TcxGridColumn;
    colDataBase: TcxGridColumn;
    ActionList: TActionList;
    acSave: TAction;
    acRefresh: TAction;
    btnSave: TdxBarLargeButton;
    qrQuery: TFDQuery;
    colIdDataBase: TcxGridColumn;
    colLocal: TcxGridColumn;
    procedure acRefreshExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tblDataBaseEditValueChanged(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
    procedure acSaveUpdate(Sender: TObject);
  private
    FIsEdit: Boolean;
    function IsNull(const aValue, aOut: Variant): Variant;
    procedure RefreshDataBase;
    procedure SaveDataBase;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  Winapi.Windows,
  System.Variants,
  Logic.UserFunctions,
  UI.Main;

{ TfrmDataBase }

procedure TfrmDataBase.acRefreshExecute(Sender: TObject);
begin
  if MessageBox(Handle, 'Данные не сохранены. Обновить?', 'Вопрос', MB_YESNO or MB_ICONQUESTION) = ID_YES then
    RefreshDataBase();
end;

procedure TfrmDataBase.acSaveExecute(Sender: TObject);
begin
  SaveDataBase();
end;

procedure TfrmDataBase.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FIsEdit;
end;

procedure TfrmDataBase.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FIsEdit then
    CanClose := MessageBox(Handle, 'Данные не сохранены. Закрыть?', 'Вопрос', MB_YESNO or MB_ICONQUESTION) = ID_YES;
end;

procedure TfrmDataBase.FormShow(Sender: TObject);
begin
  RefreshDataBase();
end;

function TfrmDataBase.IsNull(const aValue, aOut: Variant): Variant;
begin
  if VarIsNull(aValue) then
    Result := aOut
  else
    Result := aValue;
end;

procedure TfrmDataBase.RefreshDataBase;
var
  k: Integer;
begin
  qrQuery.SQL.Text := 'dbl_sel_itemlist';
  try
    qrQuery.Open();
    qrQuery.First();
    tblDataBase.BeginUpdate();
    try
      tblDataBase.DataController.RecordCount := qrQuery.RecordCount;
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        tblDataBase.DataController.Values[k, 0] := qrQuery.FieldByName('Id_DataBase').AsInteger;
        tblDataBase.DataController.Values[k, 1] := qrQuery.FieldByName('Server').AsString;
        tblDataBase.DataController.Values[k, 2] := qrQuery.FieldByName('DataBase').AsString;
        tblDataBase.DataController.Values[k, 3] := qrQuery.FieldByName('Local').AsBoolean;
        qrQuery.Next();
      end;
      FIsEdit := False;
    finally
      tblDataBase.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmDataBase.SaveDataBase;
var
  k: Integer;
  ResultCode: Integer;
  ResultText: string;
begin
  CreateTempTable(frmMain.FDConnection, 'tmpDataBase', ['Id_DataBase INT NULL', 'Server NVARCHAR(128) NOT NULL',
    '[DataBase] NVARCHAR(128) NOT NULL', '[Local] BIT']);
  try
    for k := 0 to tblDataBase.DataController.RecordCount  -1 do
      InsertTempTable(frmMain.FDConnection, 'tmpDataBase', [IsNull(tblDataBase.DataController.Values[k, 0], 0),
        tblDataBase.DataController.Values[k, 1], tblDataBase.DataController.Values[k, 2],
        IsNull(tblDataBase.DataController.Values[k, 3], False)]);
    qrQuery.SQL.Text := 'dbl_upd_item';
    try
      qrQuery.Open();
      ResultCode := qrQuery.Fields.Fields[0].AsInteger;
      ResultText := qrQuery.Fields.Fields[1].AsString;
      case ResultCode of
        -1:
          Application.MessageBox(PChar(ResultText), 'Ошибка', MB_OK or MB_ICONERROR);
        0:
          Application.MessageBox(PChar(ResultText), 'Предупреждение', MB_OK or MB_ICONWARNING);
        else
          FIsEdit := False;
      end;
    finally
      qrQuery.Close();
    end;
  finally
    DropTempTable(frmMain.FDConnection, 'tmpDataBase');
  end;
end;

procedure TfrmDataBase.tblDataBaseEditValueChanged(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
  FIsEdit := True;
end;

end.
