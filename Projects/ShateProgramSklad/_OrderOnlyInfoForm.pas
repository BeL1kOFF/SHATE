unit _OrderOnlyInfoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExStdCtrls, JvRichEdit, ExtCtrls, AdvPanel, Menus;

type
  TOrderOnlyInfoForm = class(TForm)
    AdvPanel1: TAdvPanel;
    btOK: TButton;
    Label6: TLabel;
    Panel2: TPanel;
    Shape1: TShape;
    Image1: TImage;
    Bevel1: TBevel;
    ArtInfo: TMemo;
    procedure AdvPanel1AnchorClick(Sender: TObject; Anchor: string);
  private
    { Private declarations }
  public
    class function Execute(const aCode, aBrand, aDescr: string): Boolean;
  end;

implementation

{$R *.dfm}

uses
  ShellApi,_Data,_Main;

{ TOrderOnlyInfoForm }

procedure TOrderOnlyInfoForm.AdvPanel1AnchorClick(Sender: TObject;
  Anchor: string);
begin
  if SameText(Anchor, 'SHATE') then
  begin
    ShellExecute(Handle, nil, PAnsiChar('http://shate-m.by'), nil, nil, SW_SHOW);
  end
  else
  if SameText(Anchor, 'INFO') then
  begin
    ShellExecute(Handle, nil, PAnsiChar('http://shate-m.by/ru/489/492/'), nil, nil, SW_SHOW);
  end;
end;

class function TOrderOnlyInfoForm.Execute(const aCode, aBrand, aDescr: string): Boolean;
begin
  with TOrderOnlyInfoForm.Create(Application) do
  try
    ArtInfo.Text := aCode + ' ' + aBrand + #13#10 + aDescr;
    Result := ShowModal = mrOK;
  finally
    Free;
  end;
end;

end.

