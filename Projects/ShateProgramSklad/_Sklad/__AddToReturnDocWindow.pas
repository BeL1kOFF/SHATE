unit __AddToReturnDocWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, _Data, Buttons, ExtCtrls;

type
  TAddToReturnDocWindow = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    EdGoods: TEdit;
    EdQuantity: TEdit;
    EdPrice: TEdit;
    Ok: TBitBtn;
    Cancel: TBitBtn;
    Label1: TLabel;
    EdPrim: TEdit;
    btOrdersInfo: TBitBtn;
    Bevel1: TBevel;
    Label7: TLabel;
    edMult: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure EdQuantityChange(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdGoodsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdQuantityKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboPriceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdPrimKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OkClick(Sender: TObject);
    procedure btOrdersInfoClick(Sender: TObject);
  private
    { Private declarations }
    fCode, fBrand, fPrice, fDescription: string;
    iItemCode, Mult: Integer;
    procedure OrdersInfoClose(Sender: TObject);
  public
    procedure SetParametrValue(const aCode, aBrand, aDescription, aComment, aCount, aPrice: string; catMult,i: Integer);
    procedure SaveValue();
  end;

var
  AddToReturnDocWindow: TAddToReturnDocWindow;

implementation

{$R *.dfm}

uses
  _OrderedInfoSklad;

procedure TAddToReturnDocWindow.SaveValue();
var iPos:integer;
begin
   if  iItemCode < 1 then
   begin

   try
      StrToFloat(EdPrice.Text);
   except
      MessageDlg('Неверно введена цена !',mtInformation,[mbOk],0);
      exit;
   end;


   try
      StrToInt(EdQuantity.Text);
   except
      MessageDlg('Неверно введено колличество!',mtInformation,[mbOk],0);
      exit;
   end;

   if ((StrToInt(EdQuantity.Text) mod Mult) <> 0) or (StrToInt(EdQuantity.Text) <= 0)then
   begin
     MessageDlg('Количество не кратно рекомендуемому!', mtWarning, [mbOK], 0);
     exit;
   end;

     with Data.TableReturnDoc do
     begin
         if FieldByName('ReturnDocId').AsString = '' then
         begin
           Append;
           FieldByName('Date').Value:=Date;
           Post;
          end;
     end;

      with Data.TableReturnDocDet do
         begin
           Last;
           iPos := FieldByName('ID').AsInteger + 1;
           Append;
           FieldByName('ID').Value := iPos;
           FieldByName('Code').Value := fCode;
           FieldByName('Brand').Value := fBrand;
           FieldByName('Description').Value := fDescription;
           FieldByName('Col').Value := StrToInt(EdQuantity.Text);
           FieldByName('Price').Value := StrToFloat(edPrice.Text);
           FieldByName('ReturnDocId').Value := Data.TableReturnDoc.FieldByName('ReturnDocId').AsInteger;
           FieldByName('Comments').Value := EdPrim.Text;
           //EdPrim

           Post;
         end;
   end
   else
   begin
       with Data.TableReturnDocDet do
       begin
           Edit;
           FieldByName('Comments').Value := EdPrim.Text;
           Post;
       end;
   end;
   Data.CatalogTable.Refresh;
   Close;

end;


procedure TAddToReturnDocWindow.SetParametrValue(const aCode, aBrand, aDescription, aComment, aCount, aPrice: string; catMult,i: Integer);
begin
   fCode := aCode;
   fBrand := aBrand;
   fDescription := aDescription;
   fPrice := aPrice;
   iItemCode := i;
   EdQuantity.Text := aCount;
   EdPrice.Text := fPrice;
   EdGoods.Text := fCode + ' ' + fDescription;
   EdPrim.Text := aComment;
   edMult.Text := IntToStr(catMult);

   if CatMult <= 0  then
     Mult := 1
   else
     Mult := CatMult;
end;

procedure TAddToReturnDocWindow.CancelClick(Sender: TObject);
begin
       Close;
end;

procedure TAddToReturnDocWindow.ComboPriceKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    if Key = VK_ESCAPE then
      Close;
    if Key = VK_RETURN then
      SelectNext(ActiveControl, true, true);
end;

procedure TAddToReturnDocWindow.EdGoodsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_ESCAPE then
      Close;
end;

procedure TAddToReturnDocWindow.EdPrimKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_ESCAPE then
      Close;
end;

procedure TAddToReturnDocWindow.EdQuantityChange(Sender: TObject);
begin
    if EdQuantity.Text = '' then
    exit;

   try
     StrToInt(EdQuantity.Text);
   except
     EdQuantity.Text := '1';
   end;
end;

procedure TAddToReturnDocWindow.EdQuantityKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    if Key = VK_ESCAPE then
      Close;
    if Key = VK_RETURN then
       SelectNext(ActiveControl, true, true);
end;

procedure TAddToReturnDocWindow.FormActivate(Sender: TObject);
begin
  Color := Data.ParamTable.FieldByName('ColorReturnOrder').AsInteger;
  Label3.Color := Color;
  Label5.Color := Color;
  Label2.Color := Color;
end;

procedure TAddToReturnDocWindow.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_ESCAPE then
      Close;
end;

procedure TAddToReturnDocWindow.OkClick(Sender: TObject);
begin
   SaveValue();
end;

procedure TAddToReturnDocWindow.OrdersInfoClose(Sender: TObject);
begin
  edPrice.Text := FloatToStr((Sender as TFormOrderedInfoSklad).RetPrice);
 // EdQuantity.Text := IntToStr((Sender as TFormOrderedInfo).RetQuantity);
end;

procedure TAddToReturnDocWindow.btOrdersInfoClick(Sender: TObject);
begin
  TFormOrderedInfoSklad.Popup(
    fCode,
    fBrand,
    fDescription,
    btOrdersInfo.ClientOrigin.X + btOrdersInfo.Width,
    btOrdersInfo.ClientOrigin.Y + btOrdersInfo.Height,
    OrdersInfoClose,
    True {IsSale}
  );
end;

end.
