unit ERP.Admin.UI.AccessGroupDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls, cxLabel, cxTextEdit, Vcl.ExtCtrls, cxCheckBox, FireDAC.Comp.Client, Data.DB;

type
  TfrmAccessGroupDetail = class(TForm)
    Panel2: TPanel;
    edtIdProfileGroup: TcxTextEdit;
    edtName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    edtDescription: TcxTextEdit;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    chbEnabled: TcxCheckBox;
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    procedure FormShow(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure acSaveUpdate(Sender: TObject);
  private
    FFDConnection: TFDConnection;
    FId_AccessGroup: Integer;

    procedure Init;
    procedure ReadItem;
    function Save: Boolean;

  public
    constructor Create(aId_AccessGroup: Integer; aConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

var
  frmAccessGroupDetail: TfrmAccessGroupDetail;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;


const
  PROC_ADM_AG_SEL_ITEM = 'adm_ag_sel_item :Id_AccessGroup';
  PROC_ADM_AG_INS_ITEM = 'adm_ag_ins_item :Name, :Description, :Enabled';
  PROC_ADM_AG_UPD_ITEM = 'adm_ag_upd_item :Id_AccessGroup, :Name, :Description, :Enabled';

  FLD_NAME = 'Name';
  FLD_DESCRIPTION = 'Description';
  FLD_ACCESS = 'Enabled';

procedure TfrmAccessGroupDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAccessGroupDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmAccessGroupDetail.acSaveUpdate(Sender: TObject);
begin
    TAction(Sender).Enabled := edtName.Text <> '';
end;

constructor TfrmAccessGroupDetail.Create(aId_AccessGroup: Integer;
  aConnection: TFDConnection; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FFDConnection := aConnection;
  FId_AccessGroup := aId_AccessGroup;
end;

procedure TfrmAccessGroupDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmAccessGroupDetail.FormShow(Sender: TObject);
begin
  Init();
  edtName.SetFocus();
end;

procedure TfrmAccessGroupDetail.Init;
begin
  CreateSQLCursor();
  if FId_AccessGroup = -1 then
  begin
    edtIdProfileGroup.Text := '';
    edtName.Text := '';
    edtDescription.Text := '';
    chbEnabled.Checked := False;
  end
  else
    ReadItem();
end;

procedure TfrmAccessGroupDetail.ReadItem;
begin
  edtIdProfileGroup.Text := IntToStr(FId_AccessGroup);
  TERPQueryHelp.ReadItem(FFDConnection, PROC_ADM_AG_SEL_ITEM, [TERPParamValue.Create(FId_AccessGroup)],
    [TERPControlValue.Create(edtName, FLD_NAME),
     TERPControlValue.Create(edtDescription, FLD_DESCRIPTION),
     TERPControlValue.Create(chbEnabled, FLD_ACCESS)], nil);
end;

function TfrmAccessGroupDetail.Save: Boolean;
begin
  CreateSQLCursor();
  if FId_AccessGroup = -1 then
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_AG_INS_ITEM,
      [TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(edtDescription.Text),
       TERPParamValue.Create(chbEnabled.Checked)])
  else
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_AG_UPD_ITEM,
      [TERPParamValue.Create(FId_AccessGroup),
       TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(edtDescription.Text),
       TERPParamValue.Create(chbEnabled.Checked)]);
end;

end.
