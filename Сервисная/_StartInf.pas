unit _StartInf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, DBCtrls, Buttons, JvComponentBase,
  JvFormPlacement;

type
  TStartInfo = class(TForm)
    Browser: TWebBrowser;
    BitBtn1: TBitBtn;
    DBCheckBox1: TDBCheckBox;
    JvFormStorage1: TJvFormStorage;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StartInfo: TStartInfo;

implementation

uses _Data, _Main;

{$R *.dfm}

procedure TStartInfo.FormCreate(Sender: TObject);
begin
  Browser.Navigate(ExtractFilePath(Application.ExeName) + 'Start.htm');
end;

procedure TStartInfo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

end.
