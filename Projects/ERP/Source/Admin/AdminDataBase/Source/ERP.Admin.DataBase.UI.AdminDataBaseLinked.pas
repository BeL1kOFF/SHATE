unit ERP.Admin.DataBase.UI.AdminDataBaseLinked;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, System.Actions, Vcl.ActnList, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxClasses, cxGridLevel, cxGrid,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, cxCheckBox,
  ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;

type
  TfrmAdminDataBaseLinked = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    tblLinked: TcxGridTableView;
    qrQuery: TFDQuery;
    colId_DataBase: TcxGridColumn;
    colServer: TcxGridColumn;
    colDataBase: TcxGridColumn;
    colDataBaseName: TcxGridColumn;
    colChecked: TcxGridColumn;
    ttLinkedDB: TsmFireDACTempTable;
    procedure acCancelExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FConnection: TFDConnection;
    FId_DataBase: Integer;
    function Save: Boolean;
    procedure RefreshData;
  public
    constructor Create(aOwner: TComponent; aConnection: TFDConnection; aId_DataBase: Integer); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_ADM_DB_SEL_LINKEDDB = 'adm_db_sel_linkeddb :Id_DataBase';
  PARAM_ID_DATABASE = 'Id_DataBase';
  FLD_ID_DATABASE = 'Id_DataBase';
  FLD_SERVERNAME = 'ServerName';
  FLD_DATABASE = 'DataBase';
  FLD_DATABASENAME = 'DataBaseName';
  FLD_CHECKED = 'Checked';

  PROC_ADM_DB_UPD_LINKEDDB = 'adm_db_upd_linkeddb :Id_DataBaseMaster';

  TBL_TEMP = 'tmpLinkedDB';
  COLUMN_ID_DATABASEDETAIL = 'Id_DataBaseDetail INT';

  COL_ID_DATABASE = 0;
  COL_SERVER = 1;
  COL_DATABASE = 2;
  COL_DATABASENAME = 3;
  COL_CHECKED = 4;

procedure TfrmAdminDataBaseLinked.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAdminDataBaseLinked.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

constructor TfrmAdminDataBaseLinked.Create(aOwner: TComponent; aConnection: TFDConnection; aId_DataBase: Integer);
begin
  inherited Create(aOwner);
  FConnection := aConnection;
  FId_DataBase := aId_DataBase;
  qrQuery.Connection := FConnection;
  ttLinkedDB.Connection := FConnection;
end;

procedure TfrmAdminDataBaseLinked.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmAdminDataBaseLinked.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAdminDataBaseLinked.RefreshData;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := PROC_ADM_DB_SEL_LINKEDDB;
  qrQuery.Params.ParamValues[PARAM_ID_DATABASE] := FId_DataBase;
  try
    qrQuery.Open();
    tblLinked.BeginUpdate();
    try
      tblLinked.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        tblLinked.DataController.Values[k, COL_ID_DATABASE] := qrQuery.FieldByName(FLD_ID_DATABASE).AsInteger;
        tblLinked.DataController.Values[k, COL_SERVER] := qrQuery.FieldByName(FLD_SERVERNAME).AsString;
        tblLinked.DataController.Values[k, COL_DATABASE] := qrQuery.FieldByName(FLD_DATABASE).AsString;
        tblLinked.DataController.Values[k, COL_DATABASENAME] := qrQuery.FieldByName(FLD_DATABASENAME).AsString;
        tblLinked.DataController.Values[k, COL_CHECKED] := qrQuery.FieldByName(FLD_CHECKED).AsBoolean;
        qrQuery.Next();
      end;
    finally
      tblLinked.EndUpdate();
    end;
  finally
    qrQuery.Close()
  end;
end;

function TfrmAdminDataBaseLinked.Save: Boolean;
var
  k: Integer;
begin
  CreateSQLCursor();
  ttLinkedDB.CreateTempTable();
  try
    Result := False;
    for k := 0 to tblLinked.DataController.RecordCount - 1 do
      if Boolean(tblLinked.DataController.Values[k, COL_CHECKED]) then
        ttLinkedDB.InsertTempTable([TFieldValue.Create('Id_DataBaseDetail', tblLinked.DataController.Values[k, COL_ID_DATABASE])]);
    Result := TERPQueryHelp.Open(FConnection, PROC_ADM_DB_UPD_LINKEDDB, [TERPParamValue.Create(FId_DataBase)]);
  finally
    ttLinkedDB.DropTempTable();
  end;
end;

end.
