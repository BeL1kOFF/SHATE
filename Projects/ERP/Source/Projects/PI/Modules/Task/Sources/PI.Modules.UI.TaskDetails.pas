unit PI.Modules.UI.TaskDetails;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, System.Actions, Vcl.ActnList, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit, cxCheckBox,
  FireDAC.Comp.Client;

type
  TfrmTaskDetail = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acCancel: TAction;
    acSave: TAction;
    cxLabel1: TcxLabel;
    edtName: TcxTextEdit;
    cxLabel2: TcxLabel;
    edtGuid: TcxTextEdit;
    cbEnable: TcxCheckBox;
    cbSynchronize: TcxCheckBox;
    cbIsMemory: TcxCheckBox;
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FConnection: TFDConnection;
    FId_Task: Integer;
    function Save: Boolean;
    procedure Init;
    procedure InitNew;
    procedure InitOld;
  public
    constructor Create(aOwner: TComponent; aConnection: TFDConnection; aId_Task: Integer); reintroduce;
  end;

var
  frmTaskDetail: TfrmTaskDetail;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

procedure TfrmTaskDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmTaskDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmTaskDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := edtName.Text <> '';
end;

constructor TfrmTaskDetail.Create(aOwner: TComponent; aConnection: TFDConnection; aId_Task: Integer);
begin
  inherited Create(aOwner);
  FConnection := aConnection;
  FId_Task := aId_Task;
end;

procedure TfrmTaskDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmTaskDetail.FormShow(Sender: TObject);
begin
  Init();
  edtName.SetFocus();
end;

procedure TfrmTaskDetail.Init;
begin
  CreateSQLCursor();
  if FId_Task = -1 then
    InitNew()
  else
    InitOld();
end;

procedure TfrmTaskDetail.InitNew;
begin
  edtName.Clear();
  edtGuid.Clear();
  cbEnable.Checked := False;
  cbSynchronize.Checked := False;
  cbIsMemory.Checked := False;
end;

procedure TfrmTaskDetail.InitOld;
begin
  TERPQueryHelp.ReadItem(FConnection, 'cln.task_item_sel :Id_Task', [TERPParamValue.Create(FId_Task)],
    [TERPControlValue.Create(edtName, 'Name'),
     TERPControlValue.Create(edtGuid, 'Guid'),
     TERPControlValue.Create(cbEnable, 'Enable'),
     TERPControlValue.Create(cbSynchronize, 'Synchronize'),
     TERPControlValue.Create(cbIsMemory, 'IsMemory')], nil);
end;

function TfrmTaskDetail.Save: Boolean;
begin
  CreateSQLCursor();
  if FId_Task = -1 then
    Result := TERPQueryHelp.Open(FConnection, 'cln.task_item_ins :Name, :Guid, :Enable, :Synchronize, :IsMemory',
      [TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(TGuid.NewGuid().ToString()),
       TERPParamValue.Create(cbEnable.Checked),
       TERPParamValue.Create(cbSynchronize.Checked),
       TERPParamValue.Create(cbIsMemory.Checked)])
  else
    Result := TERPQueryHelp.Open(FConnection, 'cln.task_item_upd :Id_Task, :Name, :Enable, :Synchronize, :IsMemory',
      [TERPParamValue.Create(FId_Task),
       TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(cbEnable.Checked),
       TERPParamValue.Create(cbSynchronize.Checked),
       TERPParamValue.Create(cbIsMemory.Checked)]);
end;

end.
