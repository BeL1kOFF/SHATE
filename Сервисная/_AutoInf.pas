unit _AutoInf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, DB, dbisamtb, JvComponentBase, JvFormPlacement,
  StdCtrls, Buttons, BSMath;

type
  TAutoInfo = class(TForm)
    CloseBtn: TBitBtn;
    TypNameLabel: TLabel;
    FormStorage: TJvFormStorage;
    AutoInfoTable: TDBISAMTable;
    AutoInfoTableParam: TStringField;
    AutoInfoTableValue: TStringField;
    AutoInfoTableCaption: TBooleanField;
    DataSource: TDataSource;
    Grid: TDBGridEh;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GridGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Auto_type: integer;
  end;

var
  AutoInfo: TAutoInfo;

implementation

uses _Main, _Data;

{$R *.dfm}

procedure TAutoInfo.FormCreate(Sender: TObject);
begin
  Grid.RestoreGridLayoutIni(Main.AppStorage.IniFile.FileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  AutoInfoTable.CreateTable;
  AutoInfoTable.Open;
end;

procedure TAutoInfo.FormDestroy(Sender: TObject);
begin
  Grid.SaveGridLayoutIni(Main.AppStorage.IniFile.FileName, Name, False);
  AutoInfoTable.Close;
  AutoInfoTable.DeleteTable;
end;

procedure TAutoInfo.FormShow(Sender: TObject);

  procedure AddTitle(s: string);
  begin
    with AutoInfoTable do
    begin
      Append;
      FieldByName('Param').Value   := s;
      FieldByName('Caption').Value := True;
      Post;
    end;
  end;

  procedure AddParam(s, v: string);
  begin
    with AutoInfoTable do
    begin
      Append;
      FieldByName('Param').Value   := s;
      FieldByName('Value').Value   := v;
      FieldByName('Caption').Value := False;
      Post;
    end;
  end;

begin
  with Data.TypesTable do
  begin
    Locate('Typ_id', Auto_type, []);
    TypNameLabel.Caption := FieldByName('MmtCdsText').AsString;
    AddTitle('Базовые данные:');
    AddParam('Тип:', FieldByName('CdsText').AsString);
    AddParam('Год выпуска:', FieldByName('PconText1').AsString + ' - ' +
                             FieldByName('PconText2').AsString);
    AddParam('Мощность двигателя,кВт:', FieldByName('Kw_from').AsString);
    AddParam('Мощность двигателя,л.с.:', FieldByName('Hp_from').AsString);
    AddParam('Рабочий объем в см.куб.(технические данные):', FieldByName('Ccm').AsString);
    AddParam('Объем (литры):', FloatToStr(XRound(FieldByName('Ccm').AsFloat / 1000, 1)));
    AddParam('Число цилиндров:', FieldByName('Cylinders').AsString);
    AddTitle('Кузов:');
    AddParam('Тип кузова:', FieldByName('BodyText').AsString);
    if FieldByName('Doors').AsInteger > 0 then
      AddParam('Количество дверей:', FieldByName('Doors').AsString);
    AddTitle('Двигатель:');
    AddParam('Тип двигателя:', FieldByName('EngText').AsString);
    AddParam('Подача топлива:', FieldByName('FuelSupplText').AsString);
    if FieldByName('Valves').AsInteger > 0 then
      AddParam('Число клапанов на камеру сгорания:', FieldByName('Valves').AsString);
    if FieldByName('CatText').AsString <> '' then
      AddParam('Тип катализатора:', FieldByName('CatText').AsString);
    AddParam('Коды двигателя:', FieldByName('Eng_codes').AsString);
    AddTitle('Привод:');
    AddParam('Тип привода:', FieldByName('DriveText').AsString);
    AddTitle('Тормоза:');
    AddParam('Система тормозов:', FieldByName('BrSysText').AsString);
    if FieldByName('BrTypeText').AsString <> '' then
      AddParam('Тип тормозов:', FieldByName('BrTypeText').AsString);
    if FieldByName('AbsText').AsString <> '' then
      AddParam('ABS:', FieldByName('AbsText').AsString);
    if FieldByName('AsrText').AsString <> '' then
      AddParam('ASR:', FieldByName('AsrText').AsString);
  end;
end;

procedure TAutoInfo.GridGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  if AutoInfoTable.FieldByName('Caption').AsBoolean then
    Background := clYellow;
end;

end.
