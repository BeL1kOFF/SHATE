unit _SelectDelivery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TSelectDelivery = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
     iRut:integer;
    { Public declarations }
  end;

var
  SelectDelivery: TSelectDelivery;

implementation

{$R *.dfm}

procedure TSelectDelivery.BitBtn1Click(Sender: TObject);
begin
   iRut:=1;
   Close;
end;

procedure TSelectDelivery.BitBtn2Click(Sender: TObject);
begin
   iRut:=2;
   Close;
end;

end.
