unit _RetDocAnswer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, StdCtrls, Buttons, DB, dbisamtb, Excel_TLB,ActiveX, ComObj,
  ExtCtrls;

type
  TRetDocAnswer = class(TForm)
    DBGridEh1: TDBGridEh;
    OrderAnswerQuery: TDBISAMQuery;
    OrderAnswerQueryArtCode: TStringField;
    OrderAnswerQueryArtName: TStringField;
    OrderAnswerQueryArtDescr: TStringField;
    OrderAnswerQueryArtPrice: TFloatField;
    OrderAnswerQueryArtSale: TIntegerField;
    OrderAnswerQueryArtBrandId: TStringField;
    OrderAnswerQuerySum: TFloatField;
    OrderAnswerQueryArtCodeBrand: TStringField;
    OrderAnswerQueryArtNameDescr: TStringField;
    OrderAnswerQueryPrice_koef: TFloatField;
    OrderAnswerQueryRealPriceEUR: TCurrencyField;
    OrderAnswerQueryRealPriceBY: TCurrencyField;
    OrderAnswerQuerySumEUR: TCurrencyField;
    OrderDetDataSource: TDataSource;
    Label1: TLabel;
    OrderAnswerQueryID: TAutoIncField;
    OrderAnswerQueryCode2: TStringField;
    OrderAnswerQueryBrand: TStringField;
    OrderAnswerQueryQuantity: TIntegerField;
    OrderAnswerQueryNote: TStringField;
    OrderAnswerQueryRetDoc_ID: TIntegerField;
    OrderAnswerQueryOrdered: TSmallintField;
    Panel: TPanel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure OrderAnswerQueryCalcFields(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  private
    fCurrencyMain, fCurrencyDop: string;
    fCurrencyMainCode, fCurrencyDopCode: SmallInt;
    StrList: TStringList;
    procedure InitColumns;
  public
    procedure Init(aRespondList: TStringList; aCurrencyMain, aCurrencyDop: string);
  end;

var
  RetDocAnswer: TRetDocAnswer;
  SelectList: TList;
  iDocNumber: Integer;
  sNumDoc: string;

implementation

{$R *.dfm}

uses
  _Main, _Data, BSMath, HyperStr, BSStrUt, _CommonTypes;

{ TRetDocAnswer }

procedure TRetDocAnswer.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TRetDocAnswer.BitBtn2Click(Sender: TObject);
var
    ExcelApp:TExcelApplication;
    Worksheet, Workbook: Variant;
    iRow : integer;
    aRange: Variant;
    aSumEUR, aSumBY: Double;
begin
   //печать прихода
   try
      ExcelApp := TExcelApplication.Create(nil);
      ExcelApp.Connect; // подключение
      ExcelApp.AutoQuit := False; // по умолчанию это свойство True только в unit ExcelXP
      ExcelApp.EnableEvents := FALSE;
      ExcelApp.Visible[0]:= TRUE;
      Workbook := ExcelApp.Workbooks.Add(xlWBatWorkSheet, 0);//EmptyParam, lcid());

      Worksheet := Workbook.ActiveSheet;

      //номер накладной
 //>>     Worksheet.Cells.Item[1, 1].Value := '№' + fLotusNumber;   {возможно sNumDoc}

      iRow := 1;
      //Дата командировки	Менеджер	Отдел поставок	Город	Клиент	Цель поездки
      Worksheet.Cells.Item[iRow,1].Value := 'Код';
      Worksheet.Cells.Item[iRow,2].Value := 'Описание';
      //Worksheet.Cells.Item[iRow,3].Value := 'Цена ' + fCurrencyMain;
      Worksheet.Cells.Item[iRow,4].Value := 'Цена ' + fCurrencyDop;
      Worksheet.Cells.Item[iRow,5].Value := 'Кол-во';
      //Worksheet.Cells.Item[iRow,6].Value := 'Сумма ' + fCurrencyMain;
      Worksheet.Cells.Item[iRow,7].Value := 'Сумма ' + fCurrencyDop;

      aRange := Worksheet.Cells.Item[iRow, 1].Resize[1, 7];
      aRange.Borders[xlEdgeLeft].LineStyle := xlContinuous;
      aRange.Borders[xlEdgeRight].LineStyle := xlContinuous;
      aRange.Borders[xlEdgeBottom].LineStyle := xlContinuous;
      aRange.Borders[xlEdgeBottom].Weight := xlMedium;
      aRange.Borders[xlEdgeTop].LineStyle := xlContinuous;
      aRange.Borders[xlInsideVertical].LineStyle := xlContinuous;

      //, EmptyParam,    EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,    EmptyParam, EmptyParam, EmptyParam,0);
      with OrderAnswerQuery do
      begin
        DisableControls;
        first;
        aSumEUR := 0;
        aSumBY := 0;
        while not EOF do
        begin
          iRow := iRow + 1;
          Worksheet.Cells.Item[iRow,1].Value := FieldByName('ArtCode').AsString;
          Worksheet.Cells.Item[iRow,2].Value := FieldByName('ArtDescr').AsString;
         // Worksheet.Cells.Item[iRow,3].Value := FieldByName('RealPriceBY').Value;
          Worksheet.Cells.Item[iRow,4].Value := FieldByName('RealPriceEUR').AsString;
          Worksheet.Cells.Item[iRow,5].Value := FieldByName('Quantity').AsString;
         // Worksheet.Cells.Item[iRow,6].Value := FieldByName('Sum').AsString;
          Worksheet.Cells.Item[iRow,7].Value := FieldByName('SumEUR').AsString;

          aSumBY := aSumBY + FieldByName('Sum').AsFloat;
          aSumEUR := aSumEUR + FieldByName('SumEUR').AsFloat;
          Next;
        end;

        aRange := Worksheet.Cells.Item[iRow, 1].Resize[1, 7];
        aRange.Borders[xlEdgeBottom].LineStyle := xlContinuous;
        aRange.Borders[xlEdgeBottom].Weight := xlMedium;
        Worksheet.Cells.Item[iRow + 1, 5].Value := 'Итого:';
        Worksheet.Cells.Item[iRow + 1, 5].HorizontalAlignment := xlRight;
        //Worksheet.Cells.Item[iRow + 1, 6].Value := aSumBY;
        //Worksheet.Cells.Item[iRow + 1, 6].Font.Bold := True;
        Worksheet.Cells.Item[iRow + 1, 7].Value := aSumEUR;
        Worksheet.Cells.Item[iRow + 1, 7].Font.Bold := True;

        ExcelApp.Disconnect;
        EnableControls;
      end;
   except
    on e: Exception do
          begin
            MessageDlg('Ошибка - '+e.Message, mtInformation, [mbOK],0);
            exit;
          end;
  end;

end;

procedure TRetDocAnswer.FormActivate(Sender: TObject);
var
  Path:string;
begin
  InitColumns;

  Path := GetAppDir + 'Импорт\';
  iDocNumber := Data.ReturnDocTable.RecNo;
  sNumDoc:= Data.ReturnDocTable.FieldByName('RetDoc_ID').AsString;
  OrderAnswerQuery.Active := FALSE;
  OrderAnswerQuery.DatabaseName := Main.GetCurrentBD;
  OrderAnswerQuery.SQL.Clear;
  OrderAnswerQuery.SQL.Add('SELECT * FROM [037] WHERE ORDERED = 1 AND RetDoc_ID = ' + sNumDoc);
  OrderAnswerQuery.Active := TRUE;
end;

procedure TRetDocAnswer.Init(aRespondList: TStringList; aCurrencyMain,
  aCurrencyDop: string);
begin
  StrList := aRespondList;
  fCurrencyMain := aCurrencyMain;
  fCurrencyDop := aCurrencyDop;

  if SameText(fCurrencyMain, 'BYR') then
    fCurrencyMainCode := Ord(ctBYR)
  else
    fCurrencyMainCode := Ord(ctEUR);

  if SameText(fCurrencyDop, 'BYR') then
    fCurrencyDopCode := Ord(ctBYR)
  else
    fCurrencyDopCode := Ord(ctEUR);
end;

procedure TRetDocAnswer.InitColumns;
  function FindCol(const aFieldName: string): TColumnEh;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to DBGridEh1.Columns.Count - 1 do
      if SameText(DBGridEh1.Columns[i].FieldName, aFieldName) then
      begin
        Result := DBGridEh1.Columns[i];
        Break;
      end;
  end;

var
  aCol: TColumnEh;
begin
  aCol := FindCol('RealPriceBY');
  if Assigned(aCol) then
    aCol.Title.Caption := 'Цена (' + fCurrencyMain + ')';

{  aCol := FindCol('RealPriceEUR');
  if Assigned(aCol) then
    aCol.Title.Caption := 'Цена (' + fCurrencyDop + ')';
}
  aCol := FindCol('Sum');
  if Assigned(aCol) then
    aCol.Title.Caption := 'Сумма (' + fCurrencyMain + ')';

{  aCol := FindCol('SumEUR');
  if Assigned(aCol) then
    aCol.Title.Caption := 'Сумма (' + fCurrencyDop + ')';
}
end;

procedure TRetDocAnswer.OrderAnswerQueryCalcFields(DataSet: TDataSet);

var
  i:integer;
  DetailCode:string;
  BrandName:string;
  sEURO, sBY:string;
begin
  with DataSet do
  begin
    if Data.BrandTable.Locate('Description', FieldByName('Brand').AsString, [loCaseInsensitive]) and
       Data.XCatTable.FindKey([FieldByName('Code2').AsString,
                          Data.BrandTable.FieldByName('Brand_id').AsInteger]) then
    begin
      FieldByname('ArtCode').Value := Data.XCatTable.FieldByName('Code').AsString;
      FieldByname('ArtName').Value := Data.XCatTable.FieldByName('Name').AsString;
      FieldByname('ArtDescr').Value := Data.XCatTable.FieldByName('Description').AsString;
      FieldByname('ArtPrice').Value := Data.XCatTable.FieldByName('Price').AsFloat;
      FieldByname('ArtSale').Value := Data.XCatTable.FieldByName('Sale').AsInteger;
      FieldByname('ArtBrandId').Value := Data.XCatTable.FieldByName('Brand_id').AsString;
    end;
    {
    FieldByName('Price_koef').Value :=
                XRound(Data.Rate * FieldByName('Price').AsCurrency, iif(Data.Curr = 2, -1, 2));
    }

    FieldByName('ArtNameDescr').Value := Trim(FieldByName('ArtName').AsString + ' ' +
                                              FieldByname('ArtDescr').AsString);
    FieldByName('ArtCodeBrand').Value := Trim(FieldByName('ArtCode').AsString + '_' +
                                              AnsiUpperCase(FieldByname('Brand').AsString));

    FieldByName('ArtCodeBrand').Value := Trim(FieldByName('ArtCode').AsString + '_' +
                                              AnsiUpperCase(FieldByname('Brand').AsString));
    //StrList RealPriceEUR
    I := 0;
    while i < strList.Count do
    begin
      DetailCode := ExtractDelimited(1, strList[i], [';']);
      if DetailCode = FieldByName('Code2').AsString then
        begin
          BrandName := AnsiUpperCase(ExtractDelimited(2, strList[i], [';']));
          if BrandName = AnsiUpperCase(FieldByName('Brand').AsString) then
          begin
            sEURO := ExtractDelimited(3, strList[i], [';']);
            sBY := ExtractDelimited(4, strList[i], [';']);
            FieldByName('RealPriceBY').Value := XRoundCurr(Main.AToCurr(sBY), fCurrencyMainCode);
            FieldByName('RealPriceEUR').Value := XRoundCurr(1*Main.AToCurr(sEURO), fCurrencyDopCode);

            FieldByName('Sum').Value := XRoundCurr(
              FieldByName('RealPriceBY').AsCurrency * FieldByName('Quantity').AsFloat,
              fCurrencyMainCode
            );

            FieldByName('SumEUR').Value := XRoundCurr(
              FieldByName('RealPriceEUR').AsCurrency * FieldByName('Quantity').AsFloat,
              fCurrencyDopCode
            );

            Break;
          end;
        end;
      i := i + 1;
    end;
  end;
end;

end.
