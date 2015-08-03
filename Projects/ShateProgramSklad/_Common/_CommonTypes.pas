unit _CommonTypes;

interface

uses
  Math, SysUtils;

type
  TCurrencyType = (ctEUR, ctUSD, ctBYR, ctRUB);

  TRoundParams = record
    RoundPower: Integer;
    RoundMode: TFPURoundingMode;
  end;

  TCurrencyRounding = array[TCurrencyType] of TRoundParams;

  TCalcPrices = record
//    Base: Currency;   //базовая
//    Client: Currency; //закупочная (со скидкой клиента)
//    Retail: Currency; //розничная (с наценкой клиента)
    PriceItog: Currency;//цена в EUR
    Price_koef_eur: Currency;//цена с учетом скидки в eur
    Price_koef_usd: Currency;//цена с учетом скидки в usd
    Price_koef_rub: Currency;//цена с учетом скидки в rub
    Price_koef: Currency;//цена для отображения с учетом скидки
    Price_pro: Currency;//цена с наценкой
  end;

function FindCmdLineSwitchEx(const Switch: string; const Chars: TSysCharSet;
  IgnoreCase: Boolean; aFindByPart: Boolean; var aWholeSwitch: string): Boolean;

implementation

function FindCmdLineSwitchEx(const Switch: string; const Chars: TSysCharSet;
  IgnoreCase: Boolean; aFindByPart: Boolean; var aWholeSwitch: string): Boolean;
var
  I: Integer;
  S: string;
  aCount: Integer;
begin
  aCount := MaxInt;
  if aFindByPart then
    aCount := Length(Switch);

  for I := 1 to ParamCount do
  begin
    S := ParamStr(I);
    if (Chars = []) or (S[1] in Chars) then
      if IgnoreCase then
      begin
        if (AnsiCompareText(Copy(S, 2, aCount), Switch) = 0) then
        begin
          Result := True;
          aWholeSwitch := Copy(S, 2, MaxInt);
          Exit;
        end;
      end
      else begin
        if (AnsiCompareStr(Copy(S, 2, aCount), Switch) = 0) then
        begin
          Result := True;
          aWholeSwitch := Copy(S, 2, MaxInt);
          Exit;
        end;
      end;
  end;
  Result := False;
end;

end.
