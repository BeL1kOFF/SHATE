unit _ReturnDocPos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvAppStyler, JvComponentBase, JvFormPlacement, JvExStdCtrls, JvEdit,
  JvValidateEdit, StdCtrls, Mask, JvExMask, JvToolEdit, JvBaseEdits, Buttons,
  ExtCtrls;

type
  TReturnDocPos = class(TForm)
    BtnBevel: TBevel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    QuantityEd: TJvCalcEdit;
    ArtInfo: TEdit;
    InfoEd: TEdit;
    FormStorage: TJvFormStorage;
    FormStyler: TAdvFormStyler;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReturnDocPos: TReturnDocPos;

implementation

{$R *.dfm}

procedure TReturnDocPos.FormShow(Sender: TObject);
begin
  if QuantityEd.CanFocus then
    QuantityEd.SetFocus;
end;

end.

