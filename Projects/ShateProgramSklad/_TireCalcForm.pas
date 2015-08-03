{$Optimization off}
unit _TireCalcForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,  JvExControls, JvLabel, Grids, Spin, jpeg,
  DBGridEh, Mask, DBCtrlsEh, DBLookupEh, AdvOfficePager, DB, dbisamtb, Buttons;

type
  TLabelArray = array of TLabel;

  TTireCalcForm = class(TForm)
    Pager: TAdvOfficePager;
    CalcPage: TAdvOfficePage;
    SelectionTiresPage: TAdvOfficePage;
    lbFindNew: TLabel;
    lbFindOld: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    cbOldW: TComboBox;
    cbOldH: TComboBox;
    cbOldR: TComboBox;
    cbNewW: TComboBox;
    cbNewH: TComboBox;
    cbNewR: TComboBox;
    Panel2: TPanel;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel8: TJvLabel;
    JvLabel9: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel11: TJvLabel;
    JvLabel12: TJvLabel;
    JvLabel13: TJvLabel;
    newA: TJvLabel;
    difA: TJvLabel;
    oldB: TJvLabel;
    newB: TJvLabel;
    oldA: TJvLabel;
    oldC: TJvLabel;
    difB: TJvLabel;
    newC: TJvLabel;
    difC: TJvLabel;
    oldD: TJvLabel;
    newD: TJvLabel;
    difD: TJvLabel;
    JvLabel26: TJvLabel;
    newSpeed: TJvLabel;
    difSpeed: TJvLabel;
    difClearense: TJvLabel;
    Image1: TImage;
    oldSpeed: TEdit;
    btCalc: TButton;
    lbMark: TLabel;
    lbModel: TLabel;
    lbEngine: TLabel;
    MarksComboBox: TDBLookupComboboxEh;
    ModelComboBox: TDBLookupComboboxEh;
    engineComboBox: TDBLookupComboboxEh;
    lbSearch: TLabel;
    lbTires_1: TLabel;
    lbTires_2: TLabel;
    procedure oldSpeedKeyPress(Sender: TObject; var Key: Char);
    procedure btCalcClick(Sender: TObject);
    procedure JvLabel26Click(Sender: TObject);
    procedure lbFindOldClick(Sender: TObject);
    procedure lbFindNewClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbOldWKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MarksComboBoxChange(Sender: TObject);
    procedure ModelComboBoxChange(Sender: TObject);
    procedure engineComboBoxChange(Sender: TObject);
    procedure MarksComboBoxDropDown(Sender: TObject);
    procedure MarksComboBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure FindTires(Sender: TObject);
    procedure ModelComboBoxDropDown(Sender: TObject);
    procedure ModelComboBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure engineComboBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure engineComboBoxDropDown(Sender: TObject);
  private
    lab: TLabelArray;

    function BuildFindCondition(aWidth, aHeight, aRadius: string): string;
    procedure ClearLabel(var mas: TLabelArray);
  public
    FindInCatalogString: string;
  end;

var
  TireCalcForm: TTireCalcForm;

implementation

{$R *.dfm}

uses
  _Main, _Data,  Math;

//правльно учитываем 5-ку
function MyRound(aValue: Extended): Int64;
begin
  Result := Trunc(SimpleRoundTo(aValue, 0));
end;

procedure TTireCalcForm.btCalcClick(Sender: TObject);
var
  oW, oH, oRad, nW, nH, nRad: Integer;
  oC, nC, oD, nD, oB, nB: Integer;
  oS: Integer;
  nS: Double;
begin
  if (cbOldW.ItemIndex = -1) or (cbNewW.ItemIndex = -1) or
     (cbOldH.ItemIndex = -1) or (cbNewH.ItemIndex = -1) or
     (cbOldR.ItemIndex = -1) or (cbNewR.ItemIndex = -1) then
  begin
    Application.MessageBox('Заполните параметры шин для нового и старого размеров', 'Ошибка', MB_OK or MB_ICONWARNING);
    Exit;
  end;   


  oW := StrToInt(cbOldW.Text);
  oH := StrToInt(cbOldH.Text);
  oRad := StrToInt(cbOldR.Text);

  nW := StrToInt(cbNewW.Text);
  nH := StrToInt(cbNewH.Text);
  nRad := StrToInt(cbNewR.Text);

  oS := StrToIntDef(oldSpeed.Text, 90);
  oldSpeed.Text := IntToStr(oS);

  oldA.Caption := IntToStr(oW);
  newA.Caption := IntToStr(nW);
  difA.Caption := IntToStr(nW - oW);

  oC := MyRound(oRad * 25.4);
  nC := MyRound(nRad * 25.4);
  oldC.Caption := IntToStr(oC);
  newC.Caption := IntToStr(nC);
  difC.Caption := IntToStr(nC - oC);

  oD := MyRound(oW * oH * 0.02 + oRad * 25.4);
  nD := MyRound(nW * nH * 0.02 + nRad * 25.4);
  oldD.Caption := IntToStr(oD);
  newD.Caption := IntToStr(nD);
  difD.Caption := IntToStr(nD - oD);

  oB := MyRound((oD - oC) / 2);
  nB := MyRound((nD - nC) / 2);
  oldB.Caption := IntToStr(oB);
  newB.Caption := IntToStr(nB);
  difB.Caption := IntToStr(nB - oB);

  difClearense.Caption := FormatFloat('0.##', (nD - oD) / 2);

  nS := MyRound(nD / oD * oS * 100) / 100;
  newSpeed.Caption := FormatFloat('0.##', nS);
  difSpeed.Caption := FormatFloat('0.##', nS - oS);
end;

procedure TTireCalcForm.FindTires(Sender: TObject);
var
  tire : string;
begin
  if sender is TLabel then
  begin
    Tire :=(sender as TLabel).Caption;
    FindInCatalogString := BuildFindCondition(
                           Copy(Tire, 1, Pos('/', Tire) - 1),
                           Copy(Tire, Pos('/', Tire) + 1, Pos('R', Tire) - Pos('/', Tire) - 1),
                           Copy(Tire, Pos('R', Tire)+1, length(Tire) - Pos('/', Tire)));
    ModalResult := mrRetry;
  end;
end;

procedure TTireCalcForm.FormShow(Sender: TObject);
begin
  FindInCatalogString := '';
end;

procedure TTireCalcForm.JvLabel26Click(Sender: TObject);
begin
  if oldSpeed.CanFocus then
    oldSpeed.SetFocus;
end;

procedure TTireCalcForm.oldSpeedKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0', '1'..'9']) then
    Key := #0;
end;

function TTireCalcForm.BuildFindCondition(aWidth, aHeight, aRadius: string): string;
begin
  //подстановочные знаки для Like (пока не работают)
  if aWidth = '' then
    aWidth := '___';
  if aHeight = '' then
    aHeight := '__';
  if aRadius = '' then
    aRadius := '__';
  Result := aWidth + '/' + aHeight + 'R' + aRadius + ';' +
            aWidth + '/' + aHeight + 'ZR' + aRadius;
end;

procedure TTireCalcForm.cbOldWKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btCalcClick(btCalc);
end;

procedure TTireCalcForm.ClearLabel(var mas: TLabelArray);
var
  i: Integer;
begin
  for i := Low(mas) to High(mas) do
    mas[i].Free;
  mas := nil;
end;

procedure TTireCalcForm.engineComboBoxChange(Sender: TObject);
var
  Top, count, i: integer;
  flag: boolean;
begin
  if length(lab)>0 then
    ClearLabel(lab);
  if (ModelComboBox.Text <> '') and (engineComboBox.Text<>'') then
  begin
  lbSearch.Caption := 'Результаты поиска:' + MarksComboBox.Text + ModelComboBox.Text + engineComboBox.Text;
  Data.TiresDimensions.Filter := 'engine_id = ' + Data.TiresCarEngine.FieldByName('engine_id').AsString;
  Data.TiresDimensions.Filtered := true;
  Data.TiresDimensions.First;
  Top := 160;
  Count := 0;
  flag := True;
  i:=0;
  while not Data.TiresDimensions.Eof do
  begin
    SetLength(lab,length(lab) + 1);
    if Data.TiresDimensions.FieldByName('unique').AsInteger = 1 then
    begin
      lab[i] := TLabel.Create(SelectionTiresPage);
      lab[i].Caption := Data.TiresDimensions.FieldByName('dimensions').AsString;
      lab[i].Parent := SelectionTiresPage;

      lab[i].Font.Size := 9;
      lab[i].Font.Style := [fsUnderline];
      lab[i].Left := 6;
      lab[i].Top := 160;
      lab[i].Visible := true;
      lab[i].Font.Color := clBlue;
      lab[i].Cursor := crHandPoint;
      lab[i].OnClick := FindTires;
    end
    else
    begin
      lab[i] := TLabel.Create(SelectionTiresPage);
      lab[i].Parent := SelectionTiresPage;
      lab[i].Caption := Data.TiresDimensions.FieldByName('dimensions').AsString;
      lab[i].Font.Size := 9;
      lab[i].Font.Style := [fsUnderline];

      if (Count<6) and flag then
        lab[i].Left := 208
      else
      if (Count>=6) and  flag then
      begin
        lab[i].Left := 315;
        flag := false;
        Top := 160;
      end;
      if not flag then
        lab[i].Left := 315;
      lab[i].Top := Top;
      Top := Top + 20;
      lab[i].Font.Color := clBlue;
      lab[i].Cursor := crHandPoint;
      inc(Count);
      lab[i].Visible := true;
      lab[i].OnClick := FindTires;
    end;
    inc(i);
    Data.TiresDimensions.Next;
  end;
  end;
end;

procedure TTireCalcForm.engineComboBoxDropDown(Sender: TObject);
begin
  EngineComboBox.ReadOnly := False;
end;

procedure TTireCalcForm.engineComboBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  EngineComboBox.ReadOnly := True;
  if key = vk_delete then
    Key:= 0;
end;

procedure TTireCalcForm.lbFindOldClick(Sender: TObject);
begin
  if (cbOldW.Text = '') or (cbOldH.Text = '') or (cbOldR.Text = '') then
  begin
    Application.MessageBox('Заполните все параметры', 'Ошибка', MB_OK or MB_ICONWARNING);
    Exit;
  end;

  FindInCatalogString := BuildFindCondition(cbOldW.Text, cbOldH.Text, cbOldR.Text);
  ModalResult := mrRetry;
end;

procedure TTireCalcForm.MarksComboBoxChange(Sender: TObject);
begin
  Data.TiresCarModel.Filter := 'mark_id = ' + Data.TiresCarMake.FieldByName('mark_id').AsString;
  Data.TiresCarModel.Filtered := true;
  if length(lab)>0 then
    ClearLabel(lab);
  ModelComboBox.Enabled := True;
  EngineComboBox.Enabled := False;
  ModelComboBox.text := '';
  EngineComboBox.text := '';
end;

procedure TTireCalcForm.MarksComboBoxDropDown(Sender: TObject);
begin
  MarksComboBox.ReadOnly := False;
end;

procedure TTireCalcForm.MarksComboBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  MarksComboBox.ReadOnly := True;
  if key = vk_delete then
    Key:= 0;
end;

procedure TTireCalcForm.ModelComboBoxChange(Sender: TObject);
begin
  Data.TiresCarEngine.Filter := 'model_id = ' + Data.TiresCarModel.FieldByName('model_id').AsString;
  Data.TiresCarEngine.Filtered := true;
  if length(lab)>0 then
    ClearLabel(lab);

  EngineComboBox.Enabled := True;
  EngineComboBox.text := '';
end;

procedure TTireCalcForm.ModelComboBoxDropDown(Sender: TObject);
begin
  ModelComboBox.ReadOnly := False;
end;

procedure TTireCalcForm.ModelComboBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ModelComboBox.ReadOnly := True;
  if key = vk_delete then
    Key:= 0;
end;

procedure TTireCalcForm.lbFindNewClick(Sender: TObject);
begin
  if (cbNewW.Text = '') or (cbNewH.Text = '') or (cbNewR.Text = '') then
  begin
    Application.MessageBox('Заполните все параметры', 'Ошибка', MB_OK or MB_ICONWARNING);
    Exit;
  end;
  FindInCatalogString := BuildFindCondition(cbNewW.Text, cbNewH.Text, cbNewR.Text);
  ModalResult := mrRetry;
end;


end.

//function calculate()
{

	var oldA = document.getElementById('oldA');

	var newA = document.getElementById('newA');

	var difA = document.getElementById('difA');



	var oldB = document.getElementById('oldB');

	var newB = document.getElementById('newB');

	var difB = document.getElementById('difB');



	var oldC = document.getElementById('oldC');

	var newC = document.getElementById('newC');

	var difC = document.getElementById('difC');



	var oldD = document.getElementById('oldD');

	var newD = document.getElementById('newD');

	var difD = document.getElementById('difD');



	var oldWidth = document.getElementById('oldWidth');

	var newWidth = document.getElementById('newWidth');

	var oldRadius = document.getElementById('oldRadius');

	var newRadius = document.getElementById('newRadius');

	var newProfile = document.getElementById('newProfile');

	var oldProfile = document.getElementById('oldProfile');

	var newSpeed = document.getElementById('newSpeed');

	var oldSpeed = document.getElementById('oldSpeed');



	var difClearense = document.getElementById ('difClearense');

	var newSpeed = document.getElementById ('newSpeed');

	var difSpeed = document.getElementById ('difSpeed');



	oldA.innerHTML = oldWidth.options[oldWidth.selectedIndex].value;	

	newA.innerHTML = newWidth.options[newWidth.selectedIndex].value;	

	difA.innerHTML = newA.innerHTML - oldA.innerHTML;



	oldC.innerHTML = Math.round(oldRadius.options[oldRadius.selectedIndex].value*25.4);

	newC.innerHTML = Math.round(newRadius.options[newRadius.selectedIndex].value*25.4);

	difC.innerHTML = newC.innerHTML - oldC.innerHTML;



	oldD.innerHTML = Math.round(oldWidth.options[oldWidth.selectedIndex].value*oldProfile.options[oldProfile.selectedIndex].value*0.02

      +oldRadius.options[oldRadius.selectedIndex].value*25.4);

	newD.innerHTML = Math.round(newWidth.options[newWidth.selectedIndex].value*newProfile.options[newProfile.selectedIndex].value*0.02

      +newRadius.options[newRadius.selectedIndex].value*25.4);

	difD.innerHTML = newD.innerHTML - oldD.innerHTML;



	oldB.innerHTML = Math.round((oldD.innerHTML - oldC.innerHTML)/2);

	newB.innerHTML = Math.round((newD.innerHTML - newC.innerHTML)/2);

	difB.innerHTML = newB.innerHTML - oldB.innerHTML;



	difClearense.innerHTML = (Math.round(newWidth.options[newWidth.selectedIndex].value*newProfile.options[newProfile.selectedIndex].value*0.02

      +newRadius.options[newRadius.selectedIndex].value*25.4)

      -Math.round(oldWidth.options[oldWidth.selectedIndex].value*oldProfile.options[oldProfile.selectedIndex].value*0.02

      +oldRadius.options[oldRadius.selectedIndex].value*25.4))/2;

      

	newSpeed.innerHTML = Math.round((Math.round(newWidth.options[newWidth.selectedIndex].value*newProfile.options[newProfile.selectedIndex].value*0.02

      +newRadius.options[newRadius.selectedIndex].value*25.4)

      /Math.round(oldWidth.options[oldWidth.selectedIndex].value*oldProfile.options[oldProfile.selectedIndex].value*0.02

      +oldRadius.options[oldRadius.selectedIndex].value*25.4))*oldSpeed.value*100)/100;

	difSpeed.innerHTML = Math.round((newSpeed.innerHTML - oldSpeed.value)*100)/100;

}
