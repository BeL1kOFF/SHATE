unit _SaleOrderAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, _Data;

type
  TSaleOrderAdd = class(TForm)
    Label1: TLabel;
    EdGoods: TEdit;
    Label2: TLabel;
    EdQuantity: TEdit;
    Label3: TLabel;
    Ok: TBitBtn;
    Cancel: TBitBtn;
    Label4: TLabel;
    EdPrice: TEdit;
    Label5: TLabel;
    EdPrim: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edMult: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure EdQuantityChange(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure OkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdQuantityKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdPriceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdPrimKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    iMax:integer;
    cMinPrice:Currency;
    iItemCode, Mult:integer;
    sCose, sBrend,sPrice, sDescription:string;
    procedure SetMaxValue(i:integer; MinPrice:Currency);
    procedure SetParametrValue(s1,s2,s3,s4:string; CatMult, i:integer);
    procedure SaveValue();
    { Public declarations }
  end;

var
  SaleOrderAdd: TSaleOrderAdd;

implementation
 uses _Main;
{$R *.dfm}

procedure TSaleOrderAdd.SaveValue();
var
  iPos: Integer;
  aValue: Double;
  DecimalSeparatorOld: Char;
begin
   try
      StrToInt(EdQuantity.Text);
   except
      MessageDlg('Неверно введено колличество!',mtInformation,[mbOk],0);
      exit;
   end;
   if StrToInt(EdQuantity.Text) > iMax then
     MessageDlg('Неверно введено колличество!',mtInformation,[mbOk],0);

  if ((StrToInt(EdQuantity.Text) mod Mult) <> 0) or (StrToInt(EdQuantity.Text) <= 0) then
   begin
     MessageDlg('Количество не кратно рекомендуемому!', mtWarning, [mbOK], 0);
     exit;
   end;

   try
      if Main.AToCurr(EdPrice.Text) < cMinPrice then
      begin
        with createmessagedialog('Установленная цена превышает максимально разрешенную скидку! Продолжить?',mtInformation,[mbYes,mbNo],mbNo) do
        begin
           if ShowModal = mrNo then
              exit;
        end;
      end;
   except
      MessageDlg('Неверно введена не корректная цена!',mtInformation,[mbOk],0);
      exit;
   end;


   if  iItemCode < 1 then
   begin
     with Data.TableSaleOrder do
     begin
         if FieldByName('SaleOrderID').AsString = '' then
         begin
           Append;
           FieldByName('Date').Value:=Date;
           FieldByName('State').Value:=0;
           Post;
          end;
     end;

      with Data.TableSaleOrderDet do
         begin
           Last;
           iPos := FieldByName('ID').AsInteger + 1;
           Append;
           FieldByName('ID').Value := iPos;
           FieldByName('Code').Value:=sCose;
           FieldByName('Brand').Value:=sBrend;
           FieldByName('Description').Value:=sDescription;
           FieldByName('Col').Value:=StrToInt(EdQuantity.Text);

           //всегда сохраняем цену с '.'
           aValue := Main.AToCurr(EdPrice.Text);
           DecimalSeparatorOld := DecimalSeparator;
           DecimalSeparator := '.';
           try
             FieldByName('Price').AsString := FormatFloat('0.00', aValue);
           finally
             DecimalSeparator := DecimalSeparatorOld;
           end;
           FieldByName('SaleOrderID').Value := Data.TableSaleOrder.FieldByName('SaleOrderID').AsInteger;
           FieldByName('Comments').Value := EdPrim.Text;
           Post;
         end;
   end
   else
   begin
       with Data.TableSaleOrderDet do
       begin
           Edit;
           FieldByName('Comments').Value := EdPrim.Text;
           Post;
       end;
   end;
   Data.CatalogTable.Refresh;
   Close;

end;

procedure TSaleOrderAdd.SetParametrValue(s1,s2,s3,s4:string; CatMult, i:integer);
begin
   sCose := s1;
   sBrend :=s2;
   sDescription := s3;
   EdGoods.Text := sCose + ' '+sDescription;
   iItemCode:=i;
   EdQuantity.Text:='1';
   sPrice := s4;
   EdPrice.Text := sPrice;
   edMult.Text := IntToStr(CatMult);
   if CatMult <= 0  then
     Mult := 1
   else
     Mult := CatMult;
end;

procedure TSaleOrderAdd.SetMaxValue(i:integer;MinPrice:Currency);
begin
   iMax:=i;
   cMinPrice:=MinPrice;
end;

procedure TSaleOrderAdd.CancelClick(Sender: TObject);
begin
   Close;
end;

procedure TSaleOrderAdd.EdPriceKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_RETURN then
      SelectNext(ActiveControl, true, true);
end;

procedure TSaleOrderAdd.EdPrimKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
      SaveValue();
end;

procedure TSaleOrderAdd.EdQuantityChange(Sender: TObject);
begin
  if EdQuantity.Text = '' then
    exit;

   try
     StrToInt(EdQuantity.Text);
     if StrToInt(EdQuantity.Text) > iMax then
       EdQuantity.Text := IntToStr(iMax);

   except
     EdQuantity.Text := '1';
   end;
end;

procedure TSaleOrderAdd.EdQuantityKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Key = VK_RETURN then
      SelectNext(ActiveControl, true, true);
     
end;

procedure TSaleOrderAdd.FormActivate(Sender: TObject);
begin
    Color := Data.ParamTable.FieldByName('ColorSaleOrder').AsInteger;
    Label3.Caption := 'Макс. кол-во - '+IntToStr(iMax);
    Label6.Caption := 'Мин. цена - '+CurrToStr(cMinPrice);
    Label3.Color := Color;
    Label6.Color := Color;
    Label1.Color := Color;
    Label2.Color := Color;
    Label4.Color := Color;
end;

procedure TSaleOrderAdd.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_ESCAPE then
      Close;
end;

procedure TSaleOrderAdd.OkClick(Sender: TObject);
begin
  SaveValue();
end;

end.
