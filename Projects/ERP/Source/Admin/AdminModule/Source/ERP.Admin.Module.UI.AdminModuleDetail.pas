unit ERP.Admin.Module.UI.AdminModuleDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.ActnList, cxMaskEdit, cxLabel, cxTextEdit, Vcl.StdCtrls, Vcl.ExtCtrls, cxDropDownEdit,
  cxCheckBox, Data.DB, System.Actions, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmAdminModuleDetail = class(TForm)
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    Panel2: TPanel;
    edIdModule: TcxTextEdit;
    edtName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel3: TcxLabel;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    cxLabel2: TcxLabel;
    cmbTypeModule: TcxComboBox;
    cxLabel5: TcxLabel;
    cmbTemplate: TcxComboBox;
    cxLabel4: TcxLabel;
    edtGUID: TcxTextEdit;
    cxLabel6: TcxLabel;
    edtFileName: TcxTextEdit;
    chbEnabled: TcxCheckBox;
    qrQuery: TFDQuery;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
  private
    FFDConnection: TFDConnection;
    FId_Module: Integer;
    function Save: Boolean;
    function CallBackClassNotFound(aControl: TControl; aField: TField): Boolean;
    procedure FillTemplates(aId_Template: Integer);
    procedure FillTypeModule(aId_TypeModule: Integer);
    procedure Init;
    procedure ReadItem;
  public
    constructor Create(aId_Module: Integer; aConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_ADM_MDL_SEL_ITEM = 'adm_mdl_sel_item :Id_Module';
  PROC_ADM_MDL_INS_ITEM = 'adm_mdl_ins_item :Id_TypeModule, :Id_TemplateDataBase, :Name, :Guid, :FileName, :Enabled';
  PROC_ADM_MDL_UPD_ITEM = 'adm_mdl_upd_item :Id_Module, :Id_TypeModule, :Id_TemplateDataBase, :Name, :Guid, :FileName, :Enabled';
  PROC_ADM_MDL_SEL_TEMPLATELIST = 'adm_mdl_sel_templatelist';
  PROC_ADM_MDL_SEL_TYPEMODULE = 'adm_mdl_sel_typemodule';

  FLD_TMPL_ID_TEMPLATEDATABASE = 'Id_TemplateDataBase';
  FLD_TMPL_NAME = 'Name';

  FLD_TM_ID_TYPEMODULE = 'Id_TypeModule';
  FLD_TM_NAME = 'Name';

  FLD_NAME = 'Name';
  FLD_GUID = 'Guid';
  FLD_FILENAME = 'FileName';
  FLD_ENABLED = 'Enabled';
  FLD_ID_TYPEMODULE = 'Id_TypeModule';
  FLD_ID_TEMPLATEDATABASE = 'Id_TemplateDataBase';

{ TfrmAdminModuleDetail }

procedure TfrmAdminModuleDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAdminModuleDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmAdminModuleDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (edtName.Text <> '') and (edtGUID.Text <> '') and (edtFileName.Text <> '') and
    (cmbTypeModule.ItemIndex > -1) and (cmbTemplate.ItemIndex > -1);
end;

function TfrmAdminModuleDetail.CallBackClassNotFound(aControl: TControl; aField: TField): Boolean;
begin
  Result := True;
  if aControl.Name = 'cmbTypeModule' then
    FillTypeModule(aField.AsInteger)
  else
    if aControl.Name = 'cmbTemplate' then
      FillTemplates(aField.AsInteger)
    else
      Result := False;
end;

constructor TfrmAdminModuleDetail.Create(aId_Module: Integer; aConnection: TFDConnection; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FFDConnection := aConnection;
  FId_Module := aId_Module;
end;

procedure TfrmAdminModuleDetail.FillTemplates(aId_Template: Integer);
begin
  TERPQueryHelp.FillStrings(cmbTemplate.Properties.Items, FFDConnection, PROC_ADM_MDL_SEL_TEMPLATELIST, [],
    FLD_TMPL_ID_TEMPLATEDATABASE, FLD_TMPL_NAME);
  cmbTemplate.ItemIndex := cmbTemplate.Properties.Items.IndexOfObject(TObject(aId_Template));
end;

procedure TfrmAdminModuleDetail.FillTypeModule(aId_TypeModule: Integer);
begin
  TERPQueryHelp.FillStrings(cmbTypeModule.Properties.Items, FFDConnection, PROC_ADM_MDL_SEL_TYPEMODULE, [],
    FLD_TM_ID_TYPEMODULE, FLD_TM_NAME);
  cmbTypeModule.ItemIndex := cmbTypeModule.Properties.Items.IndexOfObject(TObject(aId_TypeModule));
end;

procedure TfrmAdminModuleDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmAdminModuleDetail.FormShow(Sender: TObject);
begin
  Init();
  edtName.SetFocus();
end;

procedure TfrmAdminModuleDetail.Init;
begin
  CreateSQLCursor();
  qrQuery.Connection := FFDConnection;
  if FId_Module = -1 then
  begin
    edIdModule.Text := '';
    edtName.Text := '';
    edtGUID.Text := '';
    edtFileName.Text := '';
    chbEnabled.Checked := False;
    FillTypeModule(-1);
    FillTemplates(-1);
  end
  else
    ReadItem();
end;

procedure TfrmAdminModuleDetail.ReadItem;
begin
  edIdModule.Text := IntToStr(FId_Module);
  TERPQueryHelp.ReadItem(FFDConnection, PROC_ADM_MDL_SEL_ITEM, [TERPParamValue.Create(FId_Module)],
    [TERPControlValue.Create(edtName, FLD_NAME),
     TERPControlValue.Create(edtGUID, FLD_GUID),
     TERPControlValue.Create(edtFileName, FLD_FILENAME),
     TERPControlValue.Create(chbEnabled, FLD_ENABLED),
     TERPControlValue.Create(cmbTypeModule, FLD_ID_TYPEMODULE),
     TERPControlValue.Create(cmbTemplate, FLD_ID_TEMPLATEDATABASE)], CallBackClassNotFound);
end;

function TfrmAdminModuleDetail.Save: Boolean;
begin{ TODO 1 : Добавть проверку на корректность GUID }
  CreateSQLCursor();
  if FId_Module = -1 then
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_MDL_INS_ITEM,
      [TERPParamValue.Create(Integer(cmbTypeModule.Properties.Items.Objects[cmbTypeModule.ItemIndex])),
       TERPParamValue.Create(Integer(cmbTemplate.Properties.Items.Objects[cmbTemplate.ItemIndex])),
       TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(edtGUID.Text),
       TERPParamValue.Create(edtFileName.Text),
       TERPParamValue.Create(chbEnabled.Checked)])
  else
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_MDL_UPD_ITEM,
      [TERPParamValue.Create(FId_Module),
       TERPParamValue.Create(Integer(cmbTypeModule.Properties.Items.Objects[cmbTypeModule.ItemIndex])),
       TERPParamValue.Create(Integer(cmbTemplate.Properties.Items.Objects[cmbTemplate.ItemIndex])),
       TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(edtGUID.Text),
       TERPParamValue.Create(edtFileName.Text),
       TERPParamValue.Create(chbEnabled.Checked)]);
end;

end.
