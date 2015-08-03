unit _MessUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TMessUpdate = class(TForm)
    Label1: TLabel;
    btClose: TBitBtn;
    Timer1: TTimer;
    Bevel1: TBevel;
    procedure btCloseClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    cnt: integer;
  public
    { Public declarations }
  end;

var
  MessUpdate: TMessUpdate;

implementation

{$R *.dfm}

procedure TMessUpdate.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMessUpdate.FormCreate(Sender: TObject);
begin
  cnt := 15;
end;

procedure TMessUpdate.Timer1Timer(Sender: TObject);
begin
  Dec(cnt);
  if cnt = 0 then
    Close
  else
    btClose.Caption := Format('Îê (%d)', [cnt]);
end;

end.
