unit uReleaseInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uMain, Buttons, Mask, JvExMask, JvToolEdit, ComCtrls;

type
  TFormReleaseInfo = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edVersion: TEdit;
    edDiscretVersion: TEdit;
    btOK: TButton;
    btCancel: TButton;
    Label3: TLabel;
    MemoNote: TMemo;
    cbPrevRelease: TComboBox;
    Label4: TLabel;
    DateTimePicker1: TDateTimePicker;
    btDatePick: TBitBtn;
    btClearPrev: TBitBtn;
    procedure btOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btClearPrevClick(Sender: TObject);
    procedure btDatePickClick(Sender: TObject);
    procedure DateTimePicker1CloseUp(Sender: TObject);
  private
    fBuild: TBuildInfo;
    fParentVers: TStrings;
    function GetDiscretVersion: Integer;
    function GetNote: string;
    function GetVersion: string;
    function GetParentVersion: string;

    procedure FillReleases;
    procedure FillReleasesNew(aForNew: Boolean);
    function DateToVersion(aDate: TDate): string;
  private
    procedure Validate;
  public
    procedure Init(const aBuild: TBuildInfo; isNew: Boolean);

    property ParentVersion: string read GetParentVersion;
    property Version: string read GetVersion;
    property DiscretVersion: Integer read GetDiscretVersion;
    property Note: string read GetNote;
  end;

var
  FormReleaseInfo: TFormReleaseInfo;

implementation

{$R *.dfm}

uses
  ADODB;

{ TFormReleaseInfo }

function TFormReleaseInfo.DateToVersion(aDate: TDate): string;
var
  dd, mm, yy: Word;
begin
  DecodeDate(aDate, yy, mm, dd);
  yy := yy mod 100;
  Result := Format('%2d%2d%2d', [yy, mm, dd]);
  while POS(' ', Result) > 0 do
    Result[POS(' ', Result)] := '0';
end;

procedure TFormReleaseInfo.Init(const aBuild: TBuildInfo; isNew: Boolean);
begin
  fBuild := aBuild;
  if not isNew then
  begin
    edVersion.Text := aBuild.Version;
    edDiscretVersion.Text := IntToStr(aBuild.Num);
    MemoNote.Text := aBuild.Note;
  end
  else
  begin
    edVersion.Text := DateToVersion(Date);
    MemoNote.Text := 'Новая сборка от ' + FormatDateTime('dd.mm.yyyy', Date);
  end;

  FillReleasesNew(isNew);
  if not IsNew and (aBuild.CatalogCount > 0) then
  begin
    cbPrevRelease.Enabled := False;
    btClearPrev.Enabled := False;
  end;
end;

procedure TFormReleaseInfo.btClearPrevClick(Sender: TObject);
begin
  cbPrevRelease.ItemIndex := -1;
end;

procedure TFormReleaseInfo.btDatePickClick(Sender: TObject);
begin
  PostMessage(DateTimePicker1.Handle, WM_LBUTTONDOWN, MK_LBUTTON, MAKEWPARAM(DateTimePicker1.Width - 5, 5));
  PostMessage(DateTimePicker1.Handle, WM_LBUTTONUP, 0, MAKEWPARAM(DateTimePicker1.Width - 5, 5));
end;

procedure TFormReleaseInfo.btOKClick(Sender: TObject);
begin
  Validate;
  ModalResult := mrOK;
end;

procedure TFormReleaseInfo.DateTimePicker1CloseUp(Sender: TObject);
var
  dd, mm, yy: Word;
  s: string;
begin
  DecodeDate(DateTimePicker1.Date, yy, mm, dd);
  yy := yy mod 100;
  s := Format('%2d%2d%2d', [yy, mm, dd]);
  while POS(' ', s) > 0 do
    s[POS(' ', s)] := '0';
  edVersion.Text := DateToVersion(DateTimePicker1.Date);
  if edVersion.CanFocus then
    edVersion.SetFocus;
end;

function TFormReleaseInfo.GetDiscretVersion: Integer;
begin
  Result := StrToIntDef(edDiscretVersion.Text, -1);
end;

function TFormReleaseInfo.GetNote: string;
begin
  Result := MemoNote.Text;
end;

function TFormReleaseInfo.GetVersion: string;
begin
  Result := edVersion.Text;
end;

procedure TFormReleaseInfo.Validate;
begin
  if edVersion.Text = '' then
    raise Exception.Create('Версия данных не указана');

  if Length(edVersion.Text) <> 6 then
    raise Exception.Create('Укажите версию данных в формате "YYMMDD"');

  if edDiscretVersion.Text = '' then
    raise Exception.Create('Номер обновления не указан');

  if StrToIntDef(edDiscretVersion.Text, -1) = -1 then
    raise Exception.Create('Недопустимое значение для номера обновления');
end;

procedure TFormReleaseInfo.FillReleasesNew(aForNew: Boolean);
var
  aQuery: TADOQuery;
  aFirst: Boolean;
begin
  cbPrevRelease.Clear;
  fParentVers.Clear;
  
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := FormMain.msQuery.Connection;
    aQuery.SQL.Text :=
      ' SELECT * FROM BUILDS WHERE ISCUR = 0 ORDER BY VERSION DESC ';
    aQuery.Open;

    aFirst := True;
    while not aQuery.Eof do
    begin
      cbPrevRelease.Items.Add( aQuery.FieldByName('NUM').AsString + '  [' + aQuery.FieldByName('VERSION').AsString + ']');
      fParentVers.Add(aQuery.FieldByName('VERSION').AsString);

      if aForNew then
      begin
        if aFirst then
          edDiscretVersion.Text := IntToStr(aQuery.FieldByName('NUM').AsInteger + 1);
      end
      else
        if (fBuild.ParentVersion = aQuery.FieldByName('VERSION').AsString) then
          cbPrevRelease.ItemIndex := cbPrevRelease.Items.Count - 1;

      aFirst := False;
      aQuery.Next;
    end;

    aQuery.Close;
  finally
    aQuery.Free;
  end;

  if aForNew then
    cbPrevRelease.ItemIndex := 0;
end;

procedure TFormReleaseInfo.FillReleases;
var
  aQuery: TADOQuery;
begin
  cbPrevRelease.Clear;
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := FormMain.msQuery.Connection;
    aQuery.SQL.Text :=
      ' SELECT OBJECT_NAME(OBJECT_ID) AS TableName ' +
      ' FROM sys.objects ' +
      ' WHERE type = ''U'' and SCHEMA_NAME(schema_id) = ''dbo'' and OBJECT_NAME(OBJECT_ID) LIKE ''%CATALOG''';
    aQuery.Open;
    while not aQuery.Eof do
    begin
      if aQuery.Fields[0].AsString <> 'CATALOG' then //skip current
        cbPrevRelease.Items.Add(Copy(aQuery.Fields[0].AsString, 1, 6));
      aQuery.Next;
    end;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;

function TFormReleaseInfo.GetParentVersion: string;
begin
  if cbPrevRelease.ItemIndex >= 0 then
    Result := fParentVers[cbPrevRelease.ItemIndex]
  else
    Result := '';
end;

procedure TFormReleaseInfo.FormCreate(Sender: TObject);
begin
  fParentVers := TStringList.Create;
  DateTimePicker1.Date := Date;
end;

procedure TFormReleaseInfo.FormDestroy(Sender: TObject);
begin
  fParentVers.Free;
end;

end.
