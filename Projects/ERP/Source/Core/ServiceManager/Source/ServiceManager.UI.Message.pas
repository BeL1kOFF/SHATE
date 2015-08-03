unit ServiceManager.UI.Message;

interface

uses
  Winapi.Messages,
  System.Classes,
  System.Actions,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ActnList;

type
  TfrmMessage = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnSend: TButton;
    ActionList: TActionList;
    acCancel: TAction;
    acSend: TAction;
    mmMessage: TMemo;
    procedure acCancelExecute(Sender: TObject);
    procedure acSendUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  Winapi.Windows,
  Vcl.Menus;

procedure TfrmMessage.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmMessage.acSendUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Length(mmMessage.Lines.Text) > 0;
end;

procedure TfrmMessage.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
var
  Key: Word;
  Shift: TShiftState;
begin
  ShortCutToKey(ShortCutFromMessage(Msg), Key, Shift);
  if Shift = [ssCtrl] then
  begin
    case Key of
      VK_RETURN:
        btnSend.Click();
    end;
  end;
end;

procedure TfrmMessage.FormShow(Sender: TObject);
begin
  mmMessage.SetFocus();
end;

end.
