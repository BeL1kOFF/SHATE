unit _ConfigRoundingForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, _CommonTypes;

type
  TConfigRoundingForm = class(TForm)
    cbCurrency: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edRoundPower: TEdit;
    cbRoundMethod: TComboBox;
    btOK: TButton;
    btCancel: TButton;
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCurrencyChange(Sender: TObject);
    procedure edRoundPowerExit(Sender: TObject);
    procedure cbRoundMethodExit(Sender: TObject);
    procedure cbRoundMethodChange(Sender: TObject);
  private
    fCurRound: Integer;
    fCurCurrency: TCurrencyType;
    fCurrencyRounding: TCurrencyRounding;

    procedure UpdateRoundExample;
    procedure FillCurrencyCombo;

    procedure Params2Controls;
    procedure Controls2Params;
  public
    procedure SetParams(const aCurrency: TCurrencyType; const aParams: TRoundParams);
    function GetParams(const aCurrency: TCurrencyType): TRoundParams;
  end;

var
  ConfigRoundingForm: TConfigRoundingForm;

implementation

{$R *.dfm}

uses
  Math, _Data;

{
function CalculateRound(const aValue: Double; aRoundMode: TFPURoundingMode; aRoundPower: Integer): Double;
var
  aSavedMode: TFPURoundingMode;
begin
  //rmNearest, rmDown, rmUp, rmTruncate
  aSavedMode := GetRoundMode;
  SetRoundMode(aRoundMode);
  try
    if aRoundMode = rmNearest then
      Result := SimpleRoundTo(aValue, aRoundPower)
    else
      Result := RoundTo(aValue, aRoundPower);
  finally
    SetRoundMode(aSavedMode);
  end;
end;
}

procedure TConfigRoundingForm.FillCurrencyCombo;
var
  i: TCurrencyType;
begin
  cbCurrency.Clear;
  for i := Low(TCurrencyType) to High(TCurrencyType) do
    cbCurrency.Items.Add( _Data.GetCurrencyCode(Ord(i)) );
end;

procedure TConfigRoundingForm.FormCreate(Sender: TObject);
begin
  FillCurrencyCombo;
end;

procedure TConfigRoundingForm.FormShow(Sender: TObject);
begin
  cbCurrency.ItemIndex := Ord(ctBYR);
  cbCurrencyChange(cbCurrency);
  UpdateRoundExample;
end;

procedure TConfigRoundingForm.Button1Click(Sender: TObject);
begin
  if fCurRound < 2 then Inc(fCurRound);
  UpdateRoundExample;
  Controls2Params;
end;

procedure TConfigRoundingForm.Button2Click(Sender: TObject);
begin
  if fCurRound >-3 then Dec(fCurRound);
  UpdateRoundExample;
  Controls2Params;
end;

procedure TConfigRoundingForm.cbCurrencyChange(Sender: TObject);
begin
  fCurCurrency := TCurrencyType(cbCurrency.ItemIndex);
  Params2Controls;
end;

procedure TConfigRoundingForm.UpdateRoundExample;
var
  s: string;
begin
  s := '';
  case fCurRound of
   -3: s := 'тыс€ч';
   -2: s := 'сотен';
   -1: s := 'дес€тков';
    0: s := 'целых';
    1: s := 'дес€тых';
    2: s := 'сотых';
    3: s := 'тыс€чных';
  end;

  s := s + '  (' + FormatFloat('0.######', IntPower(10, -fCurRound)) + ')';
  edRoundPower.Text := s;
end;

procedure TConfigRoundingForm.SetParams(const aCurrency: TCurrencyType;
  const aParams: TRoundParams);
begin
  fCurrencyRounding[aCurrency] := aParams;
end;

function TConfigRoundingForm.GetParams(
  const aCurrency: TCurrencyType): TRoundParams;
begin
  Result := fCurrencyRounding[aCurrency];
end;

procedure TConfigRoundingForm.Params2Controls;
begin
  cbRoundMethod.ItemIndex := Ord(fCurrencyRounding[fCurCurrency].RoundMode);
  fCurRound := fCurrencyRounding[fCurCurrency].RoundPower;
  UpdateRoundExample;
end;

procedure TConfigRoundingForm.Controls2Params;
begin
  fCurrencyRounding[fCurCurrency].RoundMode := TFPURoundingMode(cbRoundMethod.ItemIndex);
  fCurrencyRounding[fCurCurrency].RoundPower := fCurRound;
end;

procedure TConfigRoundingForm.edRoundPowerExit(Sender: TObject);
begin
  Controls2Params;
end;

procedure TConfigRoundingForm.cbRoundMethodChange(Sender: TObject);
begin
  Controls2Params;
end;

procedure TConfigRoundingForm.cbRoundMethodExit(Sender: TObject);
begin
  Controls2Params;
end;


end.
