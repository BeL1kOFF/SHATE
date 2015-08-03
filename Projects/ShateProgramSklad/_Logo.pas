unit _Logo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvPanel, ExtCtrls, ComCtrls, AdvProgr;

type
  TLogo = class(TForm)
    Panel: TAdvPanel;
    Image1: TImage;
    PanelStyler: TAdvPanelStyler;
    Progress: TAdvProgress;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Logo: TLogo;

implementation

{$R *.dfm}

end.
