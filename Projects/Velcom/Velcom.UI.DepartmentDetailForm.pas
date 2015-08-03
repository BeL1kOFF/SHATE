unit Velcom.UI.DepartmentDetailForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ActnList, StdCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxSpinEdit, cxTimeEdit, DB, ADODB, cxCheckBox;

type
  TfrmDepartmentDetail = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acCancel: TAction;
    acSave: TAction;
    Label1: TLabel;
    edtName: TEdit;
    Label2: TLabel;
    edtEmail: TEdit;
    Label3: TLabel;
    teBegin: TcxTimeEdit;
    Label4: TLabel;
    teEnd: TcxTimeEdit;
    qrQuery: TADOQuery;
    Label5: TLabel;
    edtDistributionCost: TEdit;
    cbRoundClock: TcxCheckBox;
    acRoundClock: TAction;
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure acRoundClockExecute(Sender: TObject);
  private
    FIdDepartment: Integer;
    function Save: Boolean;
    procedure ReadItem;
  public
    constructor Create(aOwner: TComponent; aIdDepartment: Integer); reintroduce;
  end;

implementation

uses
  Velcom.ISQLCursor,
  uMain;

{$R *.dfm}

procedure TfrmDepartmentDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmDepartmentDetail.acRoundClockExecute(Sender: TObject);
begin
  teBegin.Enabled := not ((Sender as TAction).ActionComponent as TcxCheckBox).Checked;
  teEnd.Enabled := not ((Sender as TAction).ActionComponent as TcxCheckBox).Checked;
end;

procedure TfrmDepartmentDetail.acSaveExecute(Sender: TObject);
begin
  if Save then
    Close();
end;

procedure TfrmDepartmentDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (edtName.Text <> '') and (teBegin.Time <= teEnd.Time);
end;

constructor TfrmDepartmentDetail.Create(aOwner: TComponent; aIdDepartment: Integer);
begin
  inherited Create(aOwner);
  FIdDepartment := aIdDepartment;
end;

procedure TfrmDepartmentDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmDepartmentDetail.FormShow(Sender: TObject);
begin
  ReadItem();
  edtName.SetFocus();
end;

procedure TfrmDepartmentDetail.ReadItem;
begin
  CreateSQLCursor();
  if FIdDepartment = -1 then
  begin
    edtName.Clear();
    edtEmail.Clear();
    teBegin.Text := '09:00';
    teEnd.Text := '18:00';
    cbRoundClock.Checked := False;
  end
  else
  begin
    qrQuery.SQL.Text := 'dpt_sel_item :Id_Department';
    qrQuery.Parameters.ParamValues['Id_Department'] := FIdDepartment;
    qrQuery.Open();
    edtName.Text := qrQuery.FieldByName('Name').AsString;
    if not(VarIsNull(qrQuery.FieldByName('EMail').AsVariant)) then
      edtEmail.Text := qrQuery.FieldByName('EMail').AsString
    else
      edtEmail.Text := '';
    teBegin.Time := qrQuery.FieldByName('BeginTime').AsDateTime;
    teEnd.Time := qrQuery.FieldByName('EndTime').AsDateTime;
    edtDistributionCost.Text := qrQuery.FieldByName('DistributionCost').AsString;
    cbRoundClock.Checked := qrQuery.FieldByName('IsRoundTheClock').AsBoolean;
    qrQuery.Close();
  end;
end;

function TfrmDepartmentDetail.Save: Boolean;
var
  ResultCode: Integer;
  ResultText: string;
begin
  CreateSQLCursor();
  if FIdDepartment = -1 then
    qrQuery.SQL.Text := 'dpt_ins_item :Name, :EMail, :BeginTime, :EndTime, :DistributionCost, :IsRoundTheClock'
  else
  begin
    qrQuery.SQL.Text := 'dpt_edt_item :Id_Department, :Name, :EMail, :BeginTime, :EndTime, :DistributionCost, :IsRoundTheClock';
    qrQuery.Parameters.ParamValues['Id_Department'] := FIdDepartment;
  end;
  qrQuery.Parameters.ParamValues['Name'] := edtName.Text;
  qrQuery.Parameters.ParamValues['EMail'] := edtEmail.Text;
  qrQuery.Parameters.ParamValues['BeginTime'] := teBegin.Text;
  qrQuery.Parameters.ParamValues['EndTime'] := teEnd.Text;
  qrQuery.Parameters.ParamValues['DistributionCost'] := edtDistributionCost.Text;
  qrQuery.Parameters.ParamValues['IsRoundTheClock'] := cbRoundClock.Checked;
  try
    qrQuery.Open();
    ResultCode := qrQuery.Fields.Fields[0].AsInteger;
    ResultText := qrQuery.Fields.Fields[1].AsString;
  except on E: Exception do
  begin
    ResultCode := -1000;
    ResultText := E.Message;
  end;
  end;
  qrQuery.Close();
  Result := ResultCode > 0;
  if Result then
    Application.MessageBox(PChar(ResultText), 'Сообщение', MB_OK or MB_ICONINFORMATION)
  else
    Application.MessageBox(PChar(ResultText), 'Ошибка', MB_OK or MB_ICONERROR);
end;

end.
