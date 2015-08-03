unit UI.InputBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmInputBox = class(TForm)
    lText: TLabel;
    edtValue: TEdit;
    btnCancel: TButton;
    btnOK: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    function GetValueText: string;
    { Private declarations }
  public
    constructor Create(aOwner: TComponent; aCaption, aText, aValue: string); reintroduce;
    property ValueText: string read GetValueText;
  end;

implementation

{$R *.dfm}

{ TForm1 }

constructor TfrmInputBox.Create(aOwner: TComponent; aCaption, aText, aValue: string);
begin
  inherited Create(aOwner);
  Caption := aCaption;
  lText.Caption := aText;
  edtValue.Text := aValue;
end;

procedure TfrmInputBox.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnOK.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmInputBox.FormShow(Sender: TObject);
begin
  edtValue.SetFocus();
end;

function TfrmInputBox.GetValueText: string;
begin
  Result := edtValue.Text;
end;

end.
