unit AnalogCodeCC.UI.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxTreeView, Data.DB, Data.Win.ADODB, Vcl.ImgList, cxCheckListBox, Vcl.StdCtrls, Vcl.ActnList,
  Vcl.ExtCtrls, dxBar, cxClasses, dxSkinsCore, dxSkinsdxBarPainter, dxSkinsForm, cxLabel, dxSkinPumpkin, System.Actions,
  cxCheckBox;

type
  TfrmMain = class(TForm)
    ADOConnection: TADOConnection;
    qrQuery: TADOQuery;
    ilIcon16: TcxImageList;
    ActionList: TActionList;
    acExecute: TAction;
    Panel1: TPanel;
    Panel2: TPanel;
    tvItemGroup: TcxTreeView;
    Panel3: TPanel;
    btnRun: TButton;
    clbTM: TcxCheckListBox;
    dxBarManager: TdxBarManager;
    Panel4: TPanel;
    clbTMPart: TcxCheckListBox;
    dxBarDockControl1: TdxBarDockControl;
    dxBarManagerBar1: TdxBar;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    acSelectAll: TAction;
    acSelectNone: TAction;
    dxBarLargeButton1: TdxBarLargeButton;
    ilIcon32: TcxImageList;
    dxSkinController1: TdxSkinController;
    cxLookAndFeelController1: TcxLookAndFeelController;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    lServer: TcxLabel;
    mLog: TMemo;
    cbPartExec: TcxCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tvItemGroupDeletion(Sender: TObject; Node: TTreeNode);
    procedure tvItemGroupChange(Sender: TObject; Node: TTreeNode);
    procedure acExecuteUpdate(Sender: TObject);
    procedure acExecuteExecute(Sender: TObject);
    procedure acSelectAllExecute(Sender: TObject);
    procedure acSelectNoneExecute(Sender: TObject);
  private
    function GetSQLFolder: string;
    function GetTreeNode(aOwnerNode: TTreeNode; aNodeID: Integer): TTreeNode;
    procedure FillItemGroup;
    procedure FillTM(aNodeId: Integer);
    procedure FillTMPart;
    procedure SetAppRole;
    procedure SetConnection;
  public
  end;

const
  FILE_OPTIONS_NAME = 'Options.xml';
  CONN_STRING = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=%s;Data Source=%s';

  PROC_LOADITEMGROUP = 'LoadItemGroup.sql';
  PROC_LOADTMFROMITEMGROUP = 'LoadTMFromItemGroup.sql';
  PROC_ANALOGCODECC = 'AnalogCodeC&C.sql';
  PROC_LOADTMFROMPART = 'SELECT t.[Trade Mark Name] FROM tm t ORDER BY t.[Trade Mark Name]';

  TBL_ACCC_ITEMGROUPFILTER = 'ItemGroupFilter';
  TBL_ACCC_TMFILTER = 'TMFilter';

  TBLFLD_ACCC_ITEMGROUPFILTER_NODEID = 'NodeId INT';
  TBLFLD_ACCC_TMFILTER_TM = 'tm VARCHAR(60) COLLATE SQL_Ukrainian_CP1251_CI_AS, IsFlag INT';

  FLD_ITEMGROUP_PARENTID = 'parentid';
  FLD_ITEMGROUP_NODEID = 'NodeId';
  FLD_ITEMGROUP_CODENAME = 'CodeName';

  FLD_ACCC_IND_STATE = 0;
  FLD_ACCC_IND_TEXT = 1;

  FLD_TM_TRADEMARKNAME = 'Trade Mark Name';

  PARAM_TM_NODEID = 'nodeid';

  REPL_COMPANY = '%company';

  IL_GROUP = 0;
  IL_GROUP_SELECTED = 2;
  IL_SUBGROUP = 1;
  IL_SUBGROUP_SELECTED = 3;
  IL_BRAND = 4;

resourcestring
  RsConnectionError = 'Ошибка';
  RsResultMessage = 'Сообщение';
  RsResultError = 'Ошибка';
  RsResultWarning = 'Предупреждение';
  RsItemsCount = 'Кол-во: %d';
  RsConnectionInfo = 'Сервер: %s'#13#10'База данных: %s'#13#10'Компания: %s';

var
  frmMain: TfrmMain;

implementation

uses
  AnalogCodeCC.Logic.OptionsXML,
  AnalogCodeCC.Logic.ISQLCursor,
  AnalogCodeCC.Logic.HelpFunc;

{$R *.dfm}

function GetOptions: IXMLAnalogCodeType;
begin
  Result := LoadAnalogCode(FILE_OPTIONS_NAME);
end;

{ TfrmMain }

procedure TfrmMain.acExecuteExecute(Sender: TObject);
var
  k: Integer;
  ResultState: Integer;
  ResultText: string;
begin
  mLog.Lines.Clear();
  CreateSQLCursor();
  ADOConnection.BeginTrans;
  try
    mLog.Lines.Add(Format('%s Подготовка', [FormatDateTime('yyyy-mm-dd', Now())]));
    CreateTempTable(qrQuery, TBL_ACCC_ITEMGROUPFILTER, [TBLFLD_ACCC_ITEMGROUPFILTER_NODEID]);
    try
      CreateTempTable(qrQuery, TBL_ACCC_TMFILTER, [TBLFLD_ACCC_TMFILTER_TM]);
      try
        InsertTempTable(qrQuery, TBL_ACCC_ITEMGROUPFILTER, [PInteger(tvItemGroup.Selected.Data)^]);
        for k := 0 to Length(string(clbTM.EditValue)) - 1 do
          if string(clbTM.EditValue)[k + 1] = '1' then
            InsertTempTable(qrQuery, TBL_ACCC_TMFILTER, [clbTM.Items[k].Text, 1]);
        for k := 0 to Length(string(clbTMPart.EditValue)) - 1 do
          if string(clbTMPart.EditValue)[k + 1] = '1' then
            InsertTempTable(qrQuery, TBL_ACCC_TMFILTER, [clbTMPart.Items[k].Text, 2]);
        qrQuery.SQL.LoadFromFile(GetSQLFolder() + PROC_ANALOGCODECC);
        qrQuery.SQL.Text := StringReplace(qrQuery.SQL.Text, REPL_COMPANY, GetOptions.Connection.Company, [rfReplaceAll, rfIgnoreCase]);
        qrQuery.Parameters.ParamValues['IsPartExec'] := Byte(cbPartExec.Checked);
        try
          mLog.Lines.Add(Format('%s Выполнение...', [FormatDateTime('yyyy-mm-dd', Now())]));
          qrQuery.Open();
          ResultState := qrQuery.Fields.Fields[FLD_ACCC_IND_STATE].AsInteger;
          ResultText := qrQuery.Fields.Fields[FLD_ACCC_IND_TEXT].AsString;
          mLog.Lines.Add(Format('%s Обработка закончена', [FormatDateTime('yyyy-mm-dd', Now())]));
          if ResultState >= 1 then
            Application.MessageBox(PChar(ResultText), PChar(RsResultMessage), MB_OK or MB_ICONINFORMATION)
          else
            if ResultState = 0 then
              Application.MessageBox(PChar(ResultText), PChar(RsResultWarning), MB_OK or MB_ICONWARNING)
            else
              Application.MessageBox(PChar(ResultText), PChar(RsResultError), MB_OK or MB_ICONERROR);
        finally
          qrQuery.Close();
        end;
      finally
        DropTempTable(qrQuery, TBL_ACCC_TMFILTER);
      end;
    finally
      DropTempTable(qrQuery, TBL_ACCC_ITEMGROUPFILTER);
    end;
    ADOConnection.CommitTrans;
  except on E: Exception do
  begin
    mLog.Lines.Add(Format('%s Ошибка!', [FormatDateTime('yyyy-mm-dd', Now())]));
    mLog.Lines.Add(Format('%s', [E.Message]));
    ADOConnection.RollbackTrans;
  end;
  end;
end;

procedure TfrmMain.acExecuteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Pos('1', string(clbTM.EditValue)) > 0;
end;

procedure TfrmMain.acSelectAllExecute(Sender: TObject);
var
  k: Integer;
begin
  clbTMPart.Items.BeginUpdate();
  for k := 0 to clbTMPart.Items.Count - 1 do
    clbTMPart.Items[k].State := cbsChecked;
  clbTMPart.Items.EndUpdate();
end;

procedure TfrmMain.acSelectNoneExecute(Sender: TObject);
var
  k: Integer;
begin
  clbTMPart.Items.BeginUpdate();
  for k := 0 to clbTMPart.Items.Count - 1 do
    clbTMPart.Items[k].State := cbsUnchecked;
  clbTMPart.Items.EndUpdate();
end;

procedure TfrmMain.FillItemGroup;
var
  k: Integer;
  tmpTreeNode: TTreeNode;
  NodeId: PInteger;
begin
  CreateSQLCursor();
  tvItemGroup.Items.Clear();
  qrQuery.SQL.LoadFromFile(GetSQLFolder() + PROC_LOADITEMGROUP);
  qrQuery.SQL.Text := StringReplace(qrQuery.SQL.Text, REPL_COMPANY, GetOptions.Connection.Company, [rfReplaceAll, rfIgnoreCase]);
  tvItemGroup.Items.BeginUpdate();
  try
    qrQuery.Open();
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      if qrQuery.FieldByName(FLD_ITEMGROUP_PARENTID).AsInteger = 0 then
      begin
        tmpTreeNode := tvItemGroup.Items.Add(nil, qrQuery.FieldByName(FLD_ITEMGROUP_CODENAME).AsString);
        tmpTreeNode.ImageIndex := IL_GROUP;
        tmpTreeNode.ExpandedImageIndex := IL_GROUP;
        tmpTreeNode.SelectedIndex := IL_GROUP_SELECTED;
      end
      else
      begin
        tmpTreeNode := GetTreeNode(tvItemGroup.Items[0], qrQuery.FieldByName(FLD_ITEMGROUP_PARENTID).AsInteger);
        tmpTreeNode := tvItemGroup.Items.AddChild(tmpTreeNode, qrQuery.FieldByName(FLD_ITEMGROUP_CODENAME).AsString);
        tmpTreeNode.ImageIndex := IL_SUBGROUP;
        tmpTreeNode.SelectedIndex := IL_SUBGROUP_SELECTED;
      end;
      New(NodeId);
      NodeId^ := qrQuery.FieldByName(FLD_ITEMGROUP_NODEID).AsInteger;
      tmpTreeNode.Data := NodeId;
      qrQuery.Next();
    end;
  finally
    tvItemGroup.Items.EndUpdate();
    qrQuery.Close();
  end;
end;

procedure TfrmMain.FillTM(aNodeId: Integer);
var
  k: Integer;
  tmpCheckListBoxItem: TcxCheckListBoxItem;
begin
  CreateSQLCursor();
  clbTM.Items.Clear();
  qrQuery.SQL.LoadFromFile(GetSQLFolder() + PROC_LOADTMFROMITEMGROUP);
  qrQuery.SQL.Text := StringReplace(qrQuery.SQL.Text, REPL_COMPANY, GetOptions.Connection.Company, [rfReplaceAll, rfIgnoreCase]);
  qrQuery.Parameters.ParamValues[PARAM_TM_NODEID] := aNodeId;
  clbTM.Items.BeginUpdate();
  try
    qrQuery.Open();
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      tmpCheckListBoxItem := clbTM.Items.Add;
      tmpCheckListBoxItem.Text := qrQuery.FieldByName(FLD_TM_TRADEMARKNAME).AsString;
      tmpCheckListBoxItem.ImageIndex := IL_BRAND;
      qrQuery.Next();
    end;
  finally
    clbTM.Items.EndUpdate();
    qrQuery.Close();
  end;
end;

procedure TfrmMain.FillTMPart;
var
  k: Integer;
  tmpCheckListBoxItem: TcxCheckListBoxItem;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := PROC_LOADTMFROMPART;
  clbTMPart.Items.BeginUpdate();
  try
    qrQuery.Open();
    clbTMPart.Items.Clear();
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      tmpCheckListBoxItem := clbTMPart.Items.Add;
      tmpCheckListBoxItem.Text := qrQuery.FieldByName(FLD_TM_TRADEMARKNAME).AsString;
      tmpCheckListBoxItem.ImageIndex := IL_BRAND;
      qrQuery.Next();
    end;
  finally
    clbTMPart.Items.EndUpdate();
    qrQuery.Close();
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  SetConnection();
  FillItemGroup();
  FillTMPart();
end;

function TfrmMain.GetSQLFolder: string;
begin
  Result := ExtractFilePath(Application.ExeName) + 'SQL\';
end;

function TfrmMain.GetTreeNode(aOwnerNode: TTreeNode; aNodeID: Integer): TTreeNode;
begin
  if PInteger(aOwnerNode.Data)^ = aNodeID then
  begin
    Result := aOwnerNode;
    Exit;
  end;
  if Assigned(aOwnerNode.getFirstChild()) then
    Result := GetTreeNode(aOwnerNode.getFirstChild(), aNodeID)
  else
    if Assigned(aOwnerNode.GetNext()) then
      Result := GetTreeNode(aOwnerNode.GetNext(), aNodeID)
    else
      Result := nil;
  if Assigned(Result) then
    Exit;
end;

procedure TfrmMain.SetAppRole;
begin
  qrQuery.SQL.Text := 'EXEC sp_setapprole ''$ndo$shadow'', ''FF5EC4E40F67BD4EDF3D04F8B84364DAD0'', ''none'', 0, 0';
  qrQuery.ExecSQL();
end;

procedure TfrmMain.SetConnection;
begin
  ADOConnection.ConnectionString := Format(CONN_STRING, [GetOptions.Connection.DataBase, GetOptions.Connection.Server]);
  try
    ADOConnection.Connected := True;
    SetAppRole();
    lServer.Caption := Format(RsConnectionInfo,
      [GetOptions.Connection.Server, GetOptions.Connection.DataBase, GetOptions.Connection.Company]);
  except on E: Exception do
    Application.MessageBox(PChar(E.Message), PChar(RsConnectionError), MB_OK or MB_ICONERROR);
  end;
end;

procedure TfrmMain.tvItemGroupChange(Sender: TObject; Node: TTreeNode);
begin
  FillTM(PInteger(Node.Data)^);
end;

procedure TfrmMain.tvItemGroupDeletion(Sender: TObject; Node: TTreeNode);
begin
  Dispose(PInteger(Node.Data));
end;

end.
