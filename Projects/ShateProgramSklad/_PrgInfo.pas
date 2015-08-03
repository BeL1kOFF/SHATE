unit _PrgInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvPanel, ExtCtrls, ComCtrls, AdvProgr, VclUtils, StdCtrls, Buttons,
  JvExButtons, JvBitBtn;

type
  TProgInfo = class(TForm)
    Panel: TAdvPanel;
    Image1: TImage;
    PanelStyler: TAdvPanelStyler;
    OkBtn: TJvBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ProgInfoLabel: TLabel;
    DataInfoLabel: TLabel;
    QuantsInfoLabel: TLabel;
    Label4: TLabel;
    NewsInfoLabel: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lbTecdocInfo: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProgInfo: TProgInfo;

implementation

uses _Main;

{$R *.dfm}


procedure TProgInfo.FormCreate(Sender: TObject);
begin
  ProgInfoLabel.Caption   := Main.CurrProgVersion;
  DataInfoLabel.Caption   := Main.CurrDataVersion;
  QuantsInfoLabel.Caption := Main.CurrQuantVersion;
  NewsInfoLabel.Caption   := Main.CurrNewsVersion;
  if Main.CurrTecdocVersion <> '' then
    lbTecdocInfo.Caption := 'Tecdoc ' + Main.CurrTecdocVersion
  else
    lbTecdocInfo.Caption := '';   
end;

end.
