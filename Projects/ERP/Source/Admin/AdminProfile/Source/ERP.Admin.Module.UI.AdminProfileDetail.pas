unit ERP.Admin.Module.UI.AdminProfileDetail;

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
  TfrmAdminProfileDetail = class(TForm)
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    Panel2: TPanel;
    editIdProfile: TcxTextEdit;
    editName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel3: TcxLabel;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    cxLabel2: TcxLabel;
    chbEnabled: TcxCheckBox;
    qrQuery: TFDQuery;
    cmbProfilesGroups: TcxComboBox;
    editDescription: TcxTextEdit;
    cxLabel4: TcxLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
  private
    FFDConnection: TFDConnection;
    FId_Profile: Integer;
    function Save: Boolean;
    function CallBackClassNotFound(aControl: TControl; aField: TField): Boolean;
    procedure FillProfilesGroups(aId_Profile: Integer);
    procedure Init;
    procedure ReadItem;

  public
    constructor Create(aId_Profile: Integer; aConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_ADM_PFL_SEL_ITEM = 'adm_pfl_sel_item :Id_Profile';
  PROC_ADM_PFL_INS_ITEM = 'adm_pfl_ins_item :Id_ProfileGroup, :Name, :Description, :Enabled';
  PROC_ADM_PFL_UPD_ITEM = 'adm_pfl_upd_item  :Id_Profile,:Id_ProfileGroup, :Name, :Description, :Enabled';
  PROC_ADM_PFL_SEL_PROFILESGROUPSLIST = 'adm_pfl_sel_profilegrouplist';


  FLD_PFLGRPLIST_ID_PROFILEGROUP = 'Id_ProfileGroup';
  FLD_PFLGRPLIST_NAME = 'Name';

  FLD_ID_PROFILEGROUP = 'Id_ProfileGroup';
  FLD_ID_PROFILE = 'Id_Profile';
  FLD_NAME = 'Name';
  FLD_DESCRIPTION = 'Description';
  FLD_FILENAME = 'FileName';
  FLD_ENABLED = 'Enabled';


{ TfrmAdminModuleDetail }

procedure TfrmAdminProfileDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAdminProfileDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmAdminProfileDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (editName.Text <> '') and (cmbProfilesGroups.ItemIndex > -1);
end;

function TfrmAdminProfileDetail.CallBackClassNotFound(aControl: TControl; aField: TField): Boolean;
begin
  Result := True;
  if aControl.Name = 'cmbProfilesGroups' then
    FillProfilesGroups(aField.AsInteger)
  else
      Result := False;
end;

constructor TfrmAdminProfileDetail.Create(aId_Profile: Integer; aConnection: TFDConnection; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FFDConnection := aConnection;
  FId_Profile := aId_Profile;
end;

procedure TfrmAdminProfileDetail.FillProfilesGroups(aId_Profile: Integer);
var
  k: Integer;
begin
  cmbProfilesGroups.Properties.Items.Clear();
  qrQuery.SQL.Text := PROC_ADM_PFL_SEL_PROFILESGROUPSLIST;
  try
    qrQuery.Open();
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cmbProfilesGroups.Properties.Items.AddObject(qrQuery.FieldByName(FLD_PFLGRPLIST_NAME).AsString,
        TObject(qrQuery.FieldByName(FLD_PFLGRPLIST_ID_PROFILEGROUP).AsInteger));
      qrQuery.Next();
    end;
    cmbProfilesGroups.ItemIndex := cmbProfilesGroups.Properties.Items.IndexOfObject(TObject(aId_Profile));
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminProfileDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmAdminProfileDetail.FormShow(Sender: TObject);
begin
  Init();
  editName.SetFocus();
end;

procedure TfrmAdminProfileDetail.Init;
begin
  CreateSQLCursor();
  qrQuery.Connection := FFDConnection;
  if FId_Profile = -1 then
  begin
    editIdProfile.Text := '';
    editName.Text := '';
    editDescription.Text := '';
    chbEnabled.Checked := False;

    FillProfilesGroups(-1);
  end
  else
    ReadItem();
end;

procedure TfrmAdminProfileDetail.ReadItem;
begin
  editIdProfile.Text := IntToStr(FId_Profile);
  TERPQueryHelp.ReadItem(FFDConnection, PROC_ADM_PFL_SEL_ITEM, [TERPParamValue.Create(FId_Profile)],
    [TERPControlValue.Create(cmbProfilesGroups, FLD_ID_PROFILEGROUP),
     TERPControlValue.Create(editName, FLD_NAME),
     TERPControlValue.Create(editDescription, FLD_DESCRIPTION),
     TERPControlValue.Create(chbEnabled, FLD_ENABLED)], CallBackClassNotFound);
end;

function TfrmAdminProfileDetail.Save: Boolean;
begin
  CreateSQLCursor();
  if FId_Profile = -1 then
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_PFL_INS_ITEM,
      [TERPParamValue.Create(Integer(cmbProfilesGroups.Properties.Items.Objects[cmbProfilesGroups.ItemIndex])),
       TERPParamValue.Create(editName.Text),
       TERPParamValue.Create(editDescription.Text),
       TERPParamValue.Create(chbEnabled.Checked)])
  else
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_PFL_UPD_ITEM,
      [TERPParamValue.Create(FId_Profile),
       TERPParamValue.Create(Integer(cmbProfilesGroups.Properties.Items.Objects[cmbProfilesGroups.ItemIndex])),
       TERPParamValue.Create(editName.Text),
       TERPParamValue.Create(editDescription.Text),
       TERPParamValue.Create(chbEnabled.Checked)]);
end;

end.
