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
    btOrdersInfo: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btOrdersInfoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    bNew: Boolean;
    sComments, sCode, sBrend, sDescription: string;
    procedure OrdersInfoClose(Sender: TObject);
  public
    procedure SetParametrValue(const aCode, aBrand, aDescription, aComments: string;
      aCount: Integer; aIsNew: Boolean);
  end;

var
  ReturnDocPos: TReturnDocPos;

implementation

{$R *.dfm}

uses
  _OrderedInfoSklad;
  
procedure TReturnDocPos.btOrdersInfoClick(Sender: TObject);
begin
  TFormOrderedInfoSklad.Popup(
    sCode,
    sBrend,
    sDescription,
    btOrdersInfo.ClientOrigin.X + btOrdersInfo.Width,
    btOrdersInfo.ClientOrigin.Y + btOrdersInfo.Height,
    OrdersInfoClose,
    False {IsSale}
  );
end;

procedure TReturnDocPos.FormActivate(Sender: TObject);
begin
  ArtInfo.Text := sCode + ' '+sDescription;
  if Length(QuantityEd.Text) < 1 then
      QuantityEd.Text := '0';
  if bNew then
    ActiveControl := QuantityEd
  else
    ActiveControl := InfoEd;
  InfoEd.Text := sComments;
end;

procedure TReturnDocPos.FormShow(Sender: TObject);
begin
  if QuantityEd.CanFocus then
    QuantityEd.SetFocus;
end;

procedure TReturnDocPos.OrdersInfoClose(Sender: TObject);
begin
  QuantityEd.Text := IntToStr((Sender as TFormOrderedInfoSklad).RetQuantity);
end;

procedure TReturnDocPos.SetParametrValue(const aCode, aBrand, aDescription,
  aComments: string; aCount: Integer; aIsNew: Boolean);
begin
  sCode := aCode;
  sBrend := aBrand;
  sDescription := aDescription;
  sComments := aComments;
  bNew := aIsNew;
  QuantityEd.Text := IntToStr(aCount);
  QuantityEd.Enabled := True;//aIsNew;
  btOrdersInfo.Enabled := True;//aIsNew;
end;

end.

