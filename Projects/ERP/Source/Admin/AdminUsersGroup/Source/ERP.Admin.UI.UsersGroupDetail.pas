unit ERP.Admin.UI.UsersGroupDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.ActnList, cxMaskEdit, cxLabel, cxTextEdit, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Comp.Client,
  System.Actions;

type
  TfrmUserGroupDetail = class(TForm)
    Panel2: TPanel;
    edtIdProfileGroup: TcxTextEdit;
    edtName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    edtDescription: TcxTextEdit;
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    procedure acSaveExecute(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    FFDConnection: TFDConnection;
    FId_UserGroup: Integer;
    function Save: Boolean;
    procedure Init;
    procedure ReadItem;
  public
    constructor Create(aId_UserGroup: Integer; aConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_ADM_UG_SEL_ITEM = 'adm_ug_sel_item :Id_UserGroup';
  PROC_ADM_UG_INS_ITEM = 'adm_ug_ins_item :Name, :Description';
  PROC_ADM_UG_UPD_ITEM = 'adm_ug_upd_item :Id_UserGroup, :Name, :Description';

  FLD_NAME = 'Name';
  FLD_DESCRIPTION = 'Description';


{ TfrmUserGroupDetail }

procedure TfrmUserGroupDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmUserGroupDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmUserGroupDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := edtName.Text <> '';
end;

constructor TfrmUserGroupDetail.Create(aId_UserGroup: Integer;
  aConnection: TFDConnection; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FFDConnection := aConnection;
  FId_UserGroup := aId_UserGroup;
end;

procedure TfrmUserGroupDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmUserGroupDetail.FormShow(Sender: TObject);
begin
  Init();
  edtName.SetFocus();
end;

procedure TfrmUserGroupDetail.Init;
begin
  CreateSQLCursor();
  if FId_UserGroup = -1 then
  begin
    edtIdProfileGroup.Text := '';
    edtName.Text := '';
    edtDescription.Text := '';
  end
  else
    ReadItem();
end;

procedure TfrmUserGroupDetail.ReadItem;
begin
  edtIdProfileGroup.Text := IntToStr(FId_UserGroup);
  TERPQueryHelp.ReadItem(FFDConnection, PROC_ADM_UG_SEL_ITEM, [TERPParamValue.Create(FId_UserGroup)],
    [TERPControlValue.Create(edtName, FLD_NAME),
     TERPControlValue.Create(edtDescription, FLD_DESCRIPTION)], nil);

end;

function TfrmUserGroupDetail.Save: Boolean;
begin
  CreateSQLCursor();
  if FId_UserGroup = -1 then
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_UG_INS_ITEM,
      [TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(edtDescription.Text)])
  else
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_UG_UPD_ITEM,
      [TERPParamValue.Create(FId_UserGroup),
       TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(edtDescription.Text)]);
end;

end.
