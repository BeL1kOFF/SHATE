unit ERP.Admin.ProfileGroup.AdminProfileGroupDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.ActnList, cxMaskEdit, cxLabel, cxTextEdit, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Comp.Client,
  System.Actions;

type
  TfrmAdminProfileGroupDetail = class(TForm)
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    Panel2: TPanel;
    edtIdProfileGroup: TcxTextEdit;
    edtName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    edtDescription: TcxTextEdit;
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FFDConnection: TFDConnection;
    FId_ProfileGroup: Integer;
    function Save: Boolean;
    procedure Init;
    procedure ReadItem;
  public
    constructor Create(aId_ProfileGroup: Integer; aConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_ADM_PG_SEL_ITEM = 'adm_pg_sel_item :Id_ProfileGroup';
  PROC_ADM_PG_INS_ITEM = 'adm_pg_ins_item :Name, :Description';
  PROC_ADM_PG_UPD_ITEM = 'adm_pg_upd_item :Id_ProfileGroup, :Name, :Description';

  FLD_NAME = 'Name';
  FLD_DESCRIPTION = 'Description';

{ TfrmAdminProfileGroupDetail }

procedure TfrmAdminProfileGroupDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAdminProfileGroupDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmAdminProfileGroupDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := edtName.Text <> '';
end;

constructor TfrmAdminProfileGroupDetail.Create(aId_ProfileGroup: Integer; aConnection: TFDConnection;
  aOwner: TComponent);
begin
  inherited Create(aOwner);
  FFDConnection := aConnection;
  FId_ProfileGroup := aId_ProfileGroup;
end;

procedure TfrmAdminProfileGroupDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmAdminProfileGroupDetail.FormShow(Sender: TObject);
begin
  Init();
  edtName.SetFocus();
end;

procedure TfrmAdminProfileGroupDetail.Init;
begin
  CreateSQLCursor();
  if FId_ProfileGroup = -1 then
  begin
    edtIdProfileGroup.Text := '';
    edtName.Text := '';
    edtDescription.Text := '';
  end
  else
    ReadItem();
end;

procedure TfrmAdminProfileGroupDetail.ReadItem;
begin
  edtIdProfileGroup.Text := IntToStr(FId_ProfileGroup);
  TERPQueryHelp.ReadItem(FFDConnection, PROC_ADM_PG_SEL_ITEM, [TERPParamValue.Create(FId_ProfileGroup)],
    [TERPControlValue.Create(edtName, FLD_NAME),
     TERPControlValue.Create(edtDescription, FLD_DESCRIPTION)], nil);
end;

function TfrmAdminProfileGroupDetail.Save: Boolean;
begin
  CreateSQLCursor();
  if FId_ProfileGroup = -1 then
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_PG_INS_ITEM,
      [TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(edtDescription.Text)])
  else
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_PG_UPD_ITEM,
      [TERPParamValue.Create(FId_ProfileGroup),
       TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(edtDescription.Text)]);
end;

end.
