unit ERP.Admin.UI.CrossAccessGroupUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, cxCheckBox, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  System.Actions, Vcl.ActnList, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxClasses, cxGridCustomView, cxGrid, ShateM.Components.TCustomTempTable,
  ShateM.Components.TFireDACTempTable;

type
  TfrmCrossAccessGroupUser = class(TForm)
    cxGrid: TcxGrid;
    tblCrossAccessGroupUser: TcxGridTableView;
    colIdUser: TcxGridColumn;
    colUsersGroup: TcxGridColumn;
    colUserName: TcxGridColumn;
    colEnabled: TcxGridColumn;
    cxGridLevel: TcxGridLevel;
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    qrQuery: TFDQuery;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    ttCrossAccessGroupUser: TsmFireDACTempTable;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure acSaveExecute(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
  private
    FFDConnection: TFDConnection;
    FId_AccessGroup: Integer;
    procedure Init;
    function Save: Boolean;
  public
    constructor Create(aId_AccessGroup: Integer; aConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

var
  frmCrossAccessGroupUser: TfrmCrossAccessGroupUser;

implementation

{$R *.dfm}
uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_CR_AG_USER_SEL_ITEMLIST = 'adm_ag_us_sel_itemlist :Id_AccessGroup';
  PROC_CR_AG_USER_ANALYS = 'adm_ag_us_analys :Id_AccessGroup';

  PARAM_ID_ACCESS_GROUP = 'Id_AccessGroup';

  FLD_ID_US = 'Id_User';
  FLD_USER_GROUP = 'Name';
  FLD_USER_NAME = 'UserName';
  FLD_CHECKED = 'Checked';

  COL_ID_US = 0;
  COL_USER_GROUP = 1;
  COL_USER_NAME = 2;
  COL_CHECKED = 3;

procedure TfrmCrossAccessGroupUser.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmCrossAccessGroupUser.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

constructor TfrmCrossAccessGroupUser.Create(aId_AccessGroup: Integer;
  aConnection: TFDConnection; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FFDConnection := aConnection;
  ttCrossAccessGroupUser.Connection := FFDConnection;
  FId_AccessGroup := aId_AccessGroup;
end;

procedure TfrmCrossAccessGroupUser.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmCrossAccessGroupUser.FormShow(Sender: TObject);
begin
  Init();
end;

procedure TfrmCrossAccessGroupUser.Init;
var
  k: integer;
begin
  CreateSQLCursor();
  qrQuery.Connection := FFDConnection;
  qrQuery.SQL.Text := PROC_CR_AG_USER_SEL_ITEMLIST;
  qrQuery.Params.ParamValues[PARAM_ID_ACCESS_GROUP] := FId_AccessGroup;
  try
    qrQuery.Open();
    tblCrossAccessGroupUser.DataController.BeginUpdate;
    try
      tblCrossAccessGroupUser.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to tblCrossAccessGroupUser.DataController.RecordCount - 1 do
      begin
        tblCrossAccessGroupUser.DataController.Values[k, COL_ID_US] := qrQuery.FieldByName(FLD_ID_US).AsString;
        tblCrossAccessGroupUser.DataController.Values[k, COL_USER_GROUP] := qrQuery.FieldByName(FLD_USER_GROUP).AsString;
        tblCrossAccessGroupUser.DataController.Values[k, COL_USER_NAME] := qrQuery.FieldByName(FLD_USER_NAME).AsString;
        tblCrossAccessGroupUser.DataController.Values[k, COL_CHECKED] := qrQuery.FieldByName(FLD_CHECKED).AsString;
        qrQuery.Next();
      end;
    finally
      tblCrossAccessGroupUser.DataController.EndUpdate;
    end;
  finally
    qrQuery.Close();
  end;
end;

function TfrmCrossAccessGroupUser.Save: Boolean;
var
  k: integer;
begin
  CreateSQLCursor();
  ttCrossAccessGroupUser.CreateTempTable();
  try
    Result := False;
    for k := 0 to tblCrossAccessGroupUser.DataController.RecordCount - 1 do
      if tblCrossAccessGroupUser.DataController.Values[k, COL_CHECKED] then
        ttCrossAccessGroupUser.InsertTempTable([TFieldValue.Create('Id_User', tblCrossAccessGroupUser.DataController.Values[k, COL_ID_US])]);
    Result := TERPQueryHelp.Open(FFDConnection, PROC_CR_AG_USER_ANALYS, [TERPParamValue.Create(FId_AccessGroup)]);
  finally
    ttCrossAccessGroupUser.DropTempTable();
  end;
end;

end.
