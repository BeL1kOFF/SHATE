unit ERP.Admin.UI.CrossAccessGroupDataBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, cxCheckBox, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxClasses, cxGridCustomView, cxGrid,
  System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, Vcl.Grids, ShateM.Components.TCustomTempTable,
  ShateM.Components.TFireDACTempTable;

type
  TfrmAccessGroupDatabase = class(TForm)
    cxGrid: TcxGrid;
    tblCrossAccessGroupDB: TcxGridTableView;
    colGroupName: TcxGridColumn;
    colGroupDescr: TcxGridColumn;
    colEnabled: TcxGridColumn;
    cxGridLevel: TcxGridLevel;
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    qrQuery: TFDQuery;
    colIdDB: TcxGridColumn;
    ttCrossAccessGroupDB: TsmFireDACTempTable;
    procedure FormShow(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FFDConnection: TFDConnection;
    FId_AccessGroup: Integer;
    procedure Init;
    function Save: Boolean;

  public
    constructor Create(aId_AccessGroup: Integer; aConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

var
  frmAccessGroupDatabase: TfrmAccessGroupDatabase;

implementation

{$R *.dfm}
uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_CR_AG_DB_SEL_ITEMLIST = 'adm_ag_db_sel_itemlist :Id_AccessGroup';
  PROC_CR_AG_DB_ANALYS = 'adm_ag_db_analys :Id_AccessGroup';

  PARAM_ID_ACCESS_GROUP = 'Id_AccessGroup';

  FLD_ID_DB = 'Id_DataBase';
  FLD_SERVER = 'ServerName';
  FLD_DB = 'DatabaseName';
  FLD_CHECKED = 'Checked';

  COL_ID_DB = 0;
  COL_SERVER = 1;
  COL_DB = 2;
  COL_CHECKED = 3;

procedure TfrmAccessGroupDatabase.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAccessGroupDatabase.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

constructor TfrmAccessGroupDatabase.Create(aId_AccessGroup: Integer;
  aConnection: TFDConnection; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FFDConnection := aConnection;
  ttCrossAccessGroupDB.Connection := FFDConnection;
  FId_AccessGroup := aId_AccessGroup;
end;

procedure TfrmAccessGroupDatabase.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmAccessGroupDatabase.FormShow(Sender: TObject);
begin
  Init();
end;

procedure TfrmAccessGroupDatabase.Init;
var
  k: integer;
begin
  CreateSQLCursor();
  qrQuery.Connection := FFDConnection;
  qrQuery.SQL.Text := PROC_CR_AG_DB_SEL_ITEMLIST;
  qrQuery.Params.ParamValues[PARAM_ID_ACCESS_GROUP] := FId_AccessGroup;
  try
    qrQuery.Open();
    tblCrossAccessGroupDB.DataController.BeginUpdate;
    try
      tblCrossAccessGroupDB.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to tblCrossAccessGroupDB.DataController.RecordCount - 1 do
      begin
        tblCrossAccessGroupDB.DataController.Values[k, COL_ID_DB] := qrQuery.FieldByName(FLD_ID_DB).AsString;
        tblCrossAccessGroupDB.DataController.Values[k, COL_SERVER] := qrQuery.FieldByName(FLD_SERVER).AsString;
        tblCrossAccessGroupDB.DataController.Values[k, COL_DB] := qrQuery.FieldByName(FLD_DB).AsString;
        tblCrossAccessGroupDB.DataController.Values[k, COL_CHECKED] := qrQuery.FieldByName(FLD_CHECKED).AsString;
        qrQuery.Next();
      end;
    finally
      tblCrossAccessGroupDB.DataController.EndUpdate;
    end;
  finally
    qrQuery.Close();
  end;
end;

function TfrmAccessGroupDatabase.Save: Boolean;
var
  k: integer;
begin
  CreateSQLCursor();
  ttCrossAccessGroupDB.CreateTempTable();
  try
    Result := False;
    for k := 0 to tblCrossAccessGroupDB.DataController.RecordCount - 1 do
      if tblCrossAccessGroupDB.DataController.Values[k, COL_CHECKED] then
        ttCrossAccessGroupDB.InsertTempTable([TFieldValue.Create('Id_database', tblCrossAccessGroupDB.DataController.Values[k, COL_ID_DB])]);
    Result := TERPQueryHelp.Open(FFDConnection, PROC_CR_AG_DB_ANALYS, [TERPParamValue.Create(FId_AccessGroup)]);
  finally
    ttCrossAccessGroupDB.DropTempTable();
  end;
end;

end.
