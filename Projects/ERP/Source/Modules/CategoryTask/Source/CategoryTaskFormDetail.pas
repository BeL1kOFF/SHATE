unit CategoryTaskFormDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ActnList, Vcl.StdCtrls, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Actions;

type
  TfrmCategoryTaskDetail = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    ActionList: TActionList;
    acOK: TAction;
    acCancel: TAction;
    Label1: TLabel;
    edtName: TEdit;
    Label2: TLabel;
    mDescription: TMemo;
    qrQuery: TFDQuery;
    procedure acCancelExecute(Sender: TObject);
    procedure acOKExecute(Sender: TObject);
    procedure acOKUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FId_CategoryTask: Integer;
    function Save: Boolean;
    procedure Init;
    procedure Read;
  public
    constructor Create(aId_CategoryTask: Integer; aFDConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

implementation

{$R *.dfm}

resourcestring
  rsError = 'Ошибка';
  rsMessage = 'Сообщение';

const
  PROC_CLNT_CT_SEL_ITEM = 'clnt_ct_sel_item :Id_CategoryTask';
  PROC_CLNT_CT_INS_ITEM = 'clnt_ct_ins_item :Name, :Description';
  PROC_CLNT_CT_EDT_ITEM = 'clnt_ct_edt_item :Id_CategoryTask, :Name, :Description';

  PARAM_ID_CATEGORYTASK = 'Id_CategoryTask';
  PARAM_NAME = 'Name';
  PARAM_DESCRIPTION = 'Description';

  FLD_NAME = 'Name';
  FLD_DESCRIPTION = 'Description';

procedure TfrmCategoryTaskDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmCategoryTaskDetail.acOKExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmCategoryTaskDetail.acOKUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := edtName.Text <> '';
end;

constructor TfrmCategoryTaskDetail.Create(aId_CategoryTask: Integer; aFDConnection: TFDConnection; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FId_CategoryTask := aId_CategoryTask;
  qrQuery.Connection := aFDConnection;
end;

procedure TfrmCategoryTaskDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
  #13:
    btnOK.Click();
  #27:
    btnCancel.Click();
  end;
end;

procedure TfrmCategoryTaskDetail.FormShow(Sender: TObject);
begin
  Init();
end;

procedure TfrmCategoryTaskDetail.Init;
begin
  if FId_CategoryTask = -1 then
  begin
    edtName.Clear();
    mDescription.Lines.Clear();
  end
  else
    Read();
  edtName.SetFocus();
end;

procedure TfrmCategoryTaskDetail.Read;
begin
  qrQuery.Close();
  qrQuery.SQL.Text := PROC_CLNT_CT_SEL_ITEM;
  qrQuery.Params.ParamValues[PARAM_ID_CATEGORYTASK] := FId_CategoryTask;
  try
    qrQuery.Open();
    edtName.Text := qrQuery.FieldByName(FLD_NAME).AsString;
    mDescription.Lines.Text := qrQuery.FieldByName(FLD_DESCRIPTION).AsString;
  finally
    qrQuery.Close();
  end;
end;

function TfrmCategoryTaskDetail.Save: Boolean;
var
  ResultCode: Integer;
  ResultText: string;
begin
  qrQuery.Close();
  if FId_CategoryTask = -1 then
    qrQuery.SQL.Text := PROC_CLNT_CT_INS_ITEM
  else
  begin
    qrQuery.SQL.Text := PROC_CLNT_CT_EDT_ITEM;
    qrQuery.Params.ParamValues[PARAM_ID_CATEGORYTASK] := FId_CategoryTask;
  end;
  qrQuery.Params.ParamValues[PARAM_NAME] := edtName.Text;
  qrQuery.Params.ParamValues[PARAM_DESCRIPTION] := mDescription.Lines.Text;
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
  Result := ResultCode = 0;
  if Result then
    Application.MessageBox(PChar(ResultText), PChar(rsMessage), MB_OK or MB_ICONINFORMATION)
  else
    Application.MessageBox(PChar(ResultText), PChar(rsError), MB_OK or MB_ICONERROR);
end;

end.
