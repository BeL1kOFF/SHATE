unit uOutParamsSite2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, GridsEh, DBGridEh, DB, dbisamtb;

type
  TOutParamsSiteForm2 = class(TForm)
    btOK: TButton;
    cbZipAll: TCheckBox;
    edZipName: TEdit;
    cbZipEach: TCheckBox;
    memParams: TDBISAMTable;
    DBGridEh1: TDBGridEh;
    memParamsID: TAutoIncField;
    memParamsCAPTION: TStringField;
    memParamsUP_F: TBooleanField;
    memParamsUP_D: TBooleanField;
    DS_Params: TDataSource;
    rbAll_full: TRadioButton;
    rbAll_discret: TRadioButton;
    cbZip_shateby: TCheckBox;
    edZipName_shateby: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure cbZipAllClick(Sender: TObject);
    procedure cbZipEachClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rbAll_discretClick(Sender: TObject);
    procedure rbAll_fullClick(Sender: TObject);
    procedure memParamsUP_FChange(Sender: TField);
    procedure memParamsUP_DChange(Sender: TField);
  private
    procedure Validate;
    procedure InitParams;
  public
  end;

var
  OutParamsSiteForm2: TOutParamsSiteForm2;

implementation

{$R *.dfm}

{ TOutParamsForm }

procedure TOutParamsSiteForm2.btOKClick(Sender: TObject);
begin
  Validate;
  ModalResult := mrOK;
end;

procedure TOutParamsSiteForm2.FormCreate(Sender: TObject);
begin
  memParams.CreateTable;
  InitParams;

  rbAll_discret.Checked := True;
end;

procedure TOutParamsSiteForm2.FormDestroy(Sender: TObject);
begin
  memParams.Close;
//  memParams.EmptyTable;
  memParams.DeleteTable;
end;

procedure TOutParamsSiteForm2.InitParams;

  procedure AddParam(const aCaption: string);
  begin
    memParams.Append;
    memParamsCAPTION.AsString := aCaption;
    memParamsUP_D.Value := True;
    memParamsUP_F.Value := False;
    memParams.Post;
  end;
  
begin
  memParams.Open;
  AddParam('Каталог');
  AddParam('Аналоги');
  AddParam('ОЕ');
  AddParam('Автомобили');
  AddParam('Применяемость');
  AddParam('Ограничения');
  AddParam('Описания');
  AddParam('Картинки');
  memParams.First;
end;

procedure TOutParamsSiteForm2.memParamsUP_DChange(Sender: TField);
begin
  if memParamsUP_D.Value then
    memParamsUP_F.Value := False;
end;

procedure TOutParamsSiteForm2.memParamsUP_FChange(Sender: TField);
begin
  if memParamsUP_F.Value then
    memParamsUP_D.Value := False;
end;

procedure TOutParamsSiteForm2.rbAll_discretClick(Sender: TObject);
var
  aRecNo: Integer;
begin
  aRecNo := memParams.RecNo;
  memParams.DisableControls;
  try
    memParams.First;
    while not memParams.Eof do
    begin
      memParams.Edit;
      memParamsUP_D.Value := rbAll_discret.Checked;
      memParams.Post;
      memParams.Next;
    end;
  finally
    memParams.EnableControls;
  end;
  memParams.RecNo := aRecNo;
end;

procedure TOutParamsSiteForm2.rbAll_fullClick(Sender: TObject);
var
  aRecNo: Integer;
begin
  aRecNo := memParams.RecNo;
  memParams.DisableControls;
  try
    memParams.First;
    while not memParams.Eof do
    begin
      memParams.Edit;
      memParamsUP_F.Value := rbAll_full.Checked;
      memParams.Post;
      memParams.Next;
    end;
  finally
    memParams.EnableControls;
  end;
  memParams.RecNo := aRecNo;
end;

procedure TOutParamsSiteForm2.Validate;
var
  aHasParams: Boolean;
  aRecNo: Integer;
begin
  aHasParams := False;
  
  aRecNo := memParams.RecNo;
  memParams.DisableControls;
  try
    memParams.First;
    while not memParams.Eof do
    begin
      aHasParams := aHasParams or memParamsUP_D.Value or memParamsUP_F.Value;
      memParams.Next;
    end;
  finally
    memParams.EnableControls;
  end;
  memParams.RecNo := aRecNo;
  
  if not aHasParams then
    raise Exception.Create('Ничего не выбрано');

  if cbZipAll.Checked then
    if edZipName.Text = '' then
      raise Exception.Create('Не указано имя архива!');
end;

procedure TOutParamsSiteForm2.cbZipAllClick(Sender: TObject);
begin
  if cbZipAll.Checked then
    cbZipEach.Checked := False;
end;


procedure TOutParamsSiteForm2.cbZipEachClick(Sender: TObject);
begin
  if cbZipEach.Checked then
    cbZipAll.Checked := False;
end;

end.
