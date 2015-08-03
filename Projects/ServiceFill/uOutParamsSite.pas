unit uOutParamsSite;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst;

type
  TOutParamsSiteForm = class(TForm)
    btOK: TButton;
    cbParams: TCheckListBox;
    cbAll: TCheckBox;
    cbZipAll: TCheckBox;
    edZipName: TEdit;
    cbZipEach: TCheckBox;
    procedure cbAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbZipAllClick(Sender: TObject);
    procedure cbZipEachClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    procedure Validate;
  public
  end;

var
  OutParamsSiteForm: TOutParamsSiteForm;

implementation

{$R *.dfm}

{ TOutParamsForm }

procedure TOutParamsSiteForm.btOKClick(Sender: TObject);
begin
  Validate;
  ModalResult := mrOK;
end;

procedure TOutParamsSiteForm.cbAllClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to cbParams.Count - 1 do
    cbParams.Checked[i] := cbAll.Checked;
end;

procedure TOutParamsSiteForm.FormCreate(Sender: TObject);
begin
  cbAll.Checked := True;
end;

procedure TOutParamsSiteForm.Validate;
var
  aHasParams: Boolean;
  i: Integer;
begin
  aHasParams := False;
  for i := 0 to cbParams.Count - 1 do
    aHasParams := aHasParams or cbParams.Checked[i];
  if not aHasParams then
    raise Exception.Create('Ничего не выбрано');

  if cbZipAll.Checked then
    if edZipName.Text = '' then
      raise Exception.Create('Не указано имя архива!');
end;

procedure TOutParamsSiteForm.cbZipAllClick(Sender: TObject);
begin
  if cbZipAll.Checked then
    cbZipEach.Checked := False;
end;


procedure TOutParamsSiteForm.cbZipEachClick(Sender: TObject);
begin
  if cbZipEach.Checked then
    cbZipAll.Checked := False;
end;

end.
