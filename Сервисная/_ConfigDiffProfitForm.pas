unit _ConfigDiffProfitForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Buttons, DB, dbisamtb, GridsEh, DBGridEh;

type
  TConfigDiffProfitForm = class(TForm)
    Label6: TLabel;
    Label1: TLabel;
    btCancel: TButton;
    btOK: TButton;
    memProfit: TDBISAMTable;
    memProfitPriceFrom: TFloatField;
    memProfitPriceTo: TFloatField;
    memProfitProfit: TFloatField;
    Grid: TDBGridEh;
    dsMemProfit: TDataSource;
    memProfitRecNum: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure memProfitCalcFields(DataSet: TDataSet);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    fData: string;
    procedure DataToTable(const aData: string);
    function TableToData: string;
    function Validate: Boolean;
  public
    procedure Init(const aData: string);
    function GetData: string;
    class function Execute(var aData: string): Boolean;
  end;

var
  ConfigDiffProfitForm: TConfigDiffProfitForm;

implementation

{$R *.dfm}

uses
  BSStrUt, _Main;

class function TConfigDiffProfitForm.Execute(var aData: string): Boolean;
begin
  Result := False;
  with TConfigDiffProfitForm.Create(Application) do
  try
    Init(aData);
    if ShowModal = mrOk then
    begin
      aData := GetData;
      Result := True;
    end;
  finally
    Free;
  end;
end;

procedure TConfigDiffProfitForm.FormCreate(Sender: TObject);
begin
  if not memProfit.Exists then
    memProfit.CreateTable;
  memProfit.Open;
end;

procedure TConfigDiffProfitForm.FormDestroy(Sender: TObject);
begin
  memProfit.Close;
  memProfit.Free;
end;

procedure TConfigDiffProfitForm.Init(const aData: string);
begin
  fData := aData;
  DataToTable(fData);
end;

procedure TConfigDiffProfitForm.memProfitCalcFields(DataSet: TDataSet);
begin
  memProfitRecNum.AsInteger := memProfit.RecNo;
end;

procedure TConfigDiffProfitForm.btOKClick(Sender: TObject);
begin
  if not Validate then
    ModalResult := mrNone;
end;

procedure TConfigDiffProfitForm.DataToTable(const aData: string);
var
  sl: TStrings;
  i: Integer;
begin
  memProfit.Close;
  memProfit.EmptyTable;
  memProfit.Open;

  sl := TStringList.Create;
  try
    sl.Text := aData;
    for i := 0 to sl.Count - 1 do
    begin
      memProfit.Append;
      memProfitPriceFrom.AsFloat := Main.AToCurr(ExtractDelimited(1,  sl[i], [';']));
      if memProfitPriceFrom.AsFloat = -1 then
        memProfitPriceFrom.AsString := '';
      memProfitPriceTo.AsFloat := Main.AToCurr(ExtractDelimited(2,  sl[i], [';']));
      if memProfitPriceTo.AsFloat = -1 then
        memProfitPriceTo.AsString := '';
      memProfitProfit.AsFloat := Main.AToCurr(ExtractDelimited(3,  sl[i], [';']));
      memProfit.Post;
    end;
    memProfit.First;
  finally
    sl.Free;
  end;
end;

function TConfigDiffProfitForm.TableToData: string;
var
  sl: TStrings;
begin
  Result := '';
  sl := TStringList.Create;
  try
    memProfit.First;
    while not memProfit.Eof do
    begin
      sl.Add(
        memProfitPriceFrom.AsString + ';' +
        memProfitPriceTo.AsString + ';' +
        FormatFloat('0.####', memProfitProfit.AsFloat)
      );
      memProfit.Next;
    end;
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

function TConfigDiffProfitForm.GetData: string;
begin
  Result := TableToData;
end;

procedure TConfigDiffProfitForm.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  if SameText(Column.FieldName, 'PriceFrom') or SameText(Column.FieldName, 'Profit') then
    if Column.Field.AsString = '' then
    begin
      Grid.Canvas.Pen.Color := $004080FF;
//      Grid.Canvas.Pen.Style := psDot;
      Grid.Canvas.MoveTo(Rect.Left + 3, Rect.Bottom - 1);
      Grid.Canvas.LineTo(Rect.Right - 3, Rect.Bottom - 1);
  //    Grid.Canvas.Pen.Style := psSolid;
    end;
end;

procedure TConfigDiffProfitForm.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    if memProfit.RecordCount > 0 then
      if Application.MessageBox('Удалить запись?', 'Подтверждение', MB_ICONQUESTION or MB_YESNO) = IDYES then
        memProfit.Delete;
end;

function TConfigDiffProfitForm.Validate: Boolean;
begin
  Result := False;
  memProfit.First;
  while not memProfit.Eof do
  begin
    if memProfitPriceFrom.AsString = '' then
    begin
      Grid.SelectedField := memProfitPriceFrom;
      Application.MessageBox('Не задано начало диапазона', 'Ошибка', MB_OK or MB_ICONWARNING);
      Grid.SetFocus;
      Exit;
    end;
    if memProfitProfit.AsString = '' then
    begin
      Grid.SelectedField := memProfitProfit;
      Application.MessageBox('Не задана наценка', 'Ошибка', MB_OK or MB_ICONWARNING);
      Grid.SetFocus;
      Exit;
    end;
    //check other errors..
    memProfit.Next;
  end;
  Result := True;
end;

end.

