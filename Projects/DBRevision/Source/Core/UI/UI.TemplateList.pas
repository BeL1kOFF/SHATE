unit UI.TemplateList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, System.Actions, Vcl.ActnList, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxClasses, cxGridCustomView, cxGrid, dxBar,
  Vcl.ImgList, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Comp.UI;

type
  TfrmTemplateList = class(TForm)
    ActionList: TActionList;
    acAdd: TAction;
    acDelete: TAction;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    btnAdd: TdxBarButton;
    btnDelete: TdxBarButton;
    cxImageList: TcxImageList;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    qrQuery: TFDQuery;
    Panel3: TPanel;
    Label1: TLabel;
    dxBarDockControl1: TdxBarDockControl;
    edtTemplate: TEdit;
    Panel4: TPanel;
    cxGrid: TcxGrid;
    tblTemplateList: TcxGridTableView;
    colName: TcxGridColumn;
    cxGridLevel: TcxGridLevel;
    btnEdit: TdxBarButton;
    acEdit: TAction;
    colIdTemplate: TcxGridColumn;
    procedure FormShow(Sender: TObject);
    procedure edtTemplateKeyPress(Sender: TObject; var Key: Char);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acAddUpdate(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure tblTemplateListFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
  private
    function IsInTemplate(const aTemplate: string): Boolean;
    procedure Save(aIsNew: Boolean);
    procedure LoadTemplate;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  Logic.UserFunctions,
  UI.Main;

const
  PROC_TMPL_SEL_ITEMLIST = 'tmpl_sel_itemlist';
  PROC_TMPL_INS_ITEM = 'tmpl_ins_item :Name';
  PROC_TMPL_UPD_ITEM = 'tmpl_upd_item :Id_Template, :Name';
  PROC_TMPL_DEL_ITEM = 'tmpl_del_item :Id_Template';

  PARAM_ID_TEMPLATE = 'Id_Template';
  PARAM_NAME = 'Name';

  FLD_ID_TEMPLATE = 'Id_Template';
  FLD_NAME = 'Name';

  COL_ID_TEMPLATE = 0;
  COL_NAME = 1;

procedure TfrmTemplateList.acAddExecute(Sender: TObject);
begin
  Save(True);
end;

procedure TfrmTemplateList.acAddUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (edtTemplate.Text <> '') and (not IsInTemplate(edtTemplate.Text));
end;

procedure TfrmTemplateList.acDeleteExecute(Sender: TObject);
var
  Result: Integer;
begin
  qrQuery.SQL.Text := PROC_TMPL_DEL_ITEM;
  qrQuery.Params.ParamValues[PARAM_ID_TEMPLATE] := tblTemplateList.Controller.FocusedRecord.Values[COL_ID_TEMPLATE];
  try
    qrQuery.Open();
    Result := qrQuery.Fields.Fields[0].AsInteger;
    if Result = 0 then
      MessageBox(Handle, 'Существуют связанные записи с шаблоном!', 'Предупреждение', MB_OK or MB_ICONWARNING)
    else
      LoadTemplate();
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmTemplateList.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblTemplateList.Controller.SelectedRecordCount = 1;
end;

procedure TfrmTemplateList.acEditExecute(Sender: TObject);
begin
  Save(False);
end;

procedure TfrmTemplateList.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblTemplateList.Controller.SelectedRecordCount = 1) and (edtTemplate.Text <> '');
end;

procedure TfrmTemplateList.edtTemplateKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnEdit.Click();
  end;
end;

procedure TfrmTemplateList.FormShow(Sender: TObject);
begin
  LoadTemplate();
end;

function TfrmTemplateList.IsInTemplate(const aTemplate: string): Boolean;
var
  k: Integer;
begin
  Result := False;
  for k := 0 to tblTemplateList.DataController.RecordCount - 1 do
    if SameText(tblTemplateList.DataController.Values[k, COL_NAME], aTemplate) then
    begin
      Result := True;
      Break;
    end;
end;

procedure TfrmTemplateList.LoadTemplate;
var
  k: Integer;
begin
  qrQuery.SQL.Text := PROC_TMPL_SEL_ITEMLIST;
  tblTemplateList.BeginUpdate();
  try
    try
      qrQuery.Open();
      qrQuery.First();
      tblTemplateList.DataController.RecordCount := qrQuery.RecordCount;
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        tblTemplateList.DataController.Values[k, COL_ID_TEMPLATE] := qrQuery.FieldByName(FLD_ID_TEMPLATE).AsInteger;
        tblTemplateList.DataController.Values[k, COL_NAME] := qrQuery.FieldByName(FLD_NAME).AsString;
        qrQuery.Next();
      end;
    finally
      qrQuery.Close();
    end;
  finally
    tblTemplateList.EndUpdate();
  end;
end;

procedure TfrmTemplateList.Save(aIsNew: Boolean);
begin
  if aIsNew then
    qrQuery.SQL.Text := PROC_TMPL_INS_ITEM
  else
  begin
    qrQuery.SQL.Text := PROC_TMPL_UPD_ITEM;
    qrQuery.Params.ParamValues[PARAM_ID_TEMPLATE] := tblTemplateList.Controller.FocusedRecord.Values[COL_ID_TEMPLATE];
  end;
  qrQuery.Params.ParamValues[PARAM_NAME] := edtTemplate.Text;
  qrQuery.ExecSQL();
  LoadTemplate();
end;

procedure TfrmTemplateList.tblTemplateListFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if Assigned(AFocusedRecord) then
    edtTemplate.Text := AFocusedRecord.Values[COL_NAME];
end;

end.
