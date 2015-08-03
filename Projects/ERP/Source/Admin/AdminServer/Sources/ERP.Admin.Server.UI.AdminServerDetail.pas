unit ERP.Admin.Server.UI.AdminServerDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ActnList, Vcl.StdCtrls, Data.DB, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxCheckBox, Vcl.Menus, cxButtons, cxTextEdit,
  System.Actions, FireDAC.Comp.Client;

type
  TfrmAdminServerDetail = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    Label1: TLabel;
    Label2: TLabel;
    chbEnabled: TcxCheckBox;
    edtId: TcxTextEdit;
    edtName: TcxTextEdit;
    procedure acSaveUpdate(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    FFDConnection: TFDConnection;
    FId_Server: Integer;
    function Save: Boolean;
    procedure Init;
    procedure ReadItem;
  public
    constructor Create(aId_Server: Integer; aConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

implementation

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_ADM_SRV_INS_ITEM = 'adm_srv_ins_item :ServerName, :Enabled';
  PROC_ADM_SRV_UPD_ITEM = 'adm_srv_upd_item :Id_Server, :ServerName, :Enabled';
  PROC_ADM_SRV_SEL_ITEM = 'adm_srv_sel_item :Id_Server';

  FLD_ID_SERVER = 'Id_Server';
  FLD_SERVERNAME = 'ServerName';
  FLD_ENABLED = 'Enabled';

{$R *.dfm}

{ TfrmAdminServerDetail }

procedure TfrmAdminServerDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAdminServerDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmAdminServerDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := edtName.Text <> '';
end;

constructor TfrmAdminServerDetail.Create(aId_Server: Integer; aConnection: TFDConnection; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FFDConnection := aConnection;
  FId_Server := aId_Server;
end;

procedure TfrmAdminServerDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmAdminServerDetail.FormShow(Sender: TObject);
begin
  Init();
  edtName.SetFocus();
end;

procedure TfrmAdminServerDetail.Init;
begin
  CreateSQLCursor();
  if FId_Server = -1 then
  begin
    edtId.Text := '';
    edtName.Text := '';
    chbEnabled.Checked := False;
  end
  else
    ReadItem();
end;

procedure TfrmAdminServerDetail.ReadItem;
begin
  TERPQueryHelp.ReadItem(FFDConnection, PROC_ADM_SRV_SEL_ITEM, [TERPParamValue.Create(FId_Server)],
    [TERPControlValue.Create(edtId, FLD_ID_SERVER),
     TERPControlValue.Create(edtName, FLD_SERVERNAME),
     TERPControlValue.Create(chbEnabled, FLD_ENABLED)], nil);
end;

function TfrmAdminServerDetail.Save: Boolean;
begin
  CreateSQLCursor();
  if FId_Server = -1 then
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_SRV_INS_ITEM, [TERPParamValue.Create(edtName.Text),
                                                                        TERPParamValue.Create(chbEnabled.Checked)])
  else
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_SRV_UPD_ITEM, [TERPParamValue.Create(FId_Server),
                                                                        TERPParamValue.Create(edtName.Text),
                                                                        TERPParamValue.Create(chbEnabled.Checked)]);
end;

end.
