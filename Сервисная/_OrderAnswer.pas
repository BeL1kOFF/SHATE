unit _OrderAnswer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, GridsEh, DBGridEh, ImgList, DB,
  dbisamtb, StdCtrls,Math, BSMath,
  HyperStr, Buttons, AdvAppStyler, BSStrUt, Excel_TLB,ActiveX, ComObj;

type MyElevent = class
    State:integer;
    Rect:TRect;
    iParent:integer;
    rEuro:real;
    bFirst:bool;
    iColor:integer;
    iColorPath:integer;
    bWaitList:BOOL;
    bDelete:BOOL;
end;

type
TDatePickerGrid = class(TEdit)

  private
  protected
    procedure RectSet;
  public
    //не наслед, потому что другие параметры
    constructor MyCreate(AOwner: TComponent; Aparent : TWinControl;iRow,iCol:integer); virtual;
    procedure OnExitGrid(Sender: TObject);
    procedure KeyPressEsc(Sender: TObject; var Key: Char);
    var
    iColT:integer;
    iRowT:integer;
  end;

type
  TOrderAnswer = class(TForm)
    Label1: TLabel;
    OrderDetDataSource: TDataSource;
    DBGridEh1: TDBGridEh;
    OrderAnswerQuery: TDBISAMQuery;
    OrderAnswerQueryId: TAutoIncField;
    OrderAnswerQueryOrder_id: TIntegerField;
    OrderAnswerQueryPos: TSmallintField;
    OrderAnswerQueryArt_id: TIntegerField;
    OrderAnswerQueryCode2: TStringField;
    OrderAnswerQueryBrand: TStringField;
    OrderAnswerQueryQuantity: TFloatField;
    OrderAnswerQueryPrice: TCurrencyField;
    OrderAnswerQueryState: TSmallintField;
    OrderAnswerQueryInfo: TStringField;
    OrderAnswerQueryOrdered: TSmallintField;
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
    Label2: TLabel;
    GridAnalog: TStringGrid;
    ImageListCheck: TImageList;
    ColorDialog: TColorDialog;
    AddToOficePaper: TBitBtn;
    BitBtn1: TBitBtn;
    CreateNewOrder: TBitBtn;
    FormStyler: TAdvFormStyler;
    OrderAnswerQueryRealPriceEUR: TCurrencyField;
    OrderAnswerQueryRealPriceBY: TCurrencyField;
    OrderAnswerQuerySumEUR: TCurrencyField;
    BitBtn2: TBitBtn;
    lbLotusNumber: TLabel;
    Button1: TButton;
    OrderAnswerQueryUnReserv: TFloatField;
    btSaveZak: TButton;
    SaveZak: TSaveDialog;
    procedure OrderDetTableCalcFields(DataSet: TDataSet);
    procedure OrderAnswerQueryCalcFields(DataSet: TDataSet);
    procedure FormActivate(Sender: TObject);
    function StrLeft(s:string; i:integer):string;
    function StrRight(s:string; i:integer):string;
    function StrFind(s:string; ch:char):integer;
    procedure GridAnalogDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridAnalogMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AddToOficePaperClick(Sender: TObject);
    procedure CreateNewOrderClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure GridAnalogDblClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure GridAnalogMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btSaveZakClick(Sender: TObject);

  private
    fCurrencyMain, fCurrencyDop: string;
    fCurrencyMainCode, fCurrencyDopCode: SmallInt;
    fLotusNumber: string;
    StrList: TStringList;
    ZakazanoFileName,ZamenyFileName: String;
    ZakPath: String;

    OrderedListCalculated: Boolean;
    OrderedList: TStringList;
    ReserveList: TStringList;
    procedure InitColumns;
  public
    procedure Init(aRespondList: TStringList; aCurrencyMain, aCurrencyDop, aLotusNumber: string; aOrderedList: TStringList; FileZakaz, FileZamen: String);
    function GetDescr(s1: string;s2: string): string;

  end;

var
  OrderAnswer: TOrderAnswer;
  SelectList:TList;
  iDocNumber: integer;
  sNumDoc, PrevHintValue:string;
  editkol:  TDatePickerGrid;

implementation

uses
  _Main, _Data, Types, _CommonTypes;

{$R *.dfm}


 constructor TDatePickerGrid.MyCreate(AOwner: TComponent; Aparent :    TWinControl;iRow,iCol:integer);
begin
  Create(AOwner);
  iColT:=iCol;
  iRowT:=iRow;
  parent := Aparent;
  RectSet;//координаты
  OnExit := OnExitGrid;//когда теряем фокус
  OnKeyPress:=KeyPressEsc;
BorderWidth := 1;

  Text := (parent as TStringGrid).Cells[iCol,iRow];
  SetFocus;
end;

procedure TDatePickerGrid.OnExitGrid(Sender: TObject);
begin 
  inherited destroy; //Ушли из ячейки ничего не меняем 
end;

procedure TDatePickerGrid.RectSet; // так будет правильно
var
  Rec:TRect;
begin 
   Rec:=(parent as TStringGrid).CellRect(iColT,iRowT);
   Left:=Rec.Left;
   Top := Rec.Top;//Top + (vFParent as TStringGrid).Top;
   Width := Rec.Right-Rec.Left;// (vFParent as TStringGrid).ColWidths[(vFParent as TStringGrid).Col]+3;
   Height := Rec.Bottom - Rec.Top;//(vFParent as TStringGrid).RowHeights[(vFParent as TStringGrid).row]+3;
end;

procedure TDatePickerGrid.KeyPressEsc(Sender: TObject; var Key: Char);
var vFParent: TWinControl; 
begin 
  if key = #13 then begin //Вводим значение 
    vfparent := parent;
    if Length(Text)<1 then
       exit;
    try
    if strtoint(text) <1 then
        exit;
    except
       exit;
    end;
    (vFParent as TStringGrid).Cells[iColT,iRowT] := Text;
    inherited destroy;
  end;
  if key = #27 then
  inherited destroy; // Esc ничего
end;


procedure TOrderAnswer.AddToOficePaperClick(Sender: TObject);
var
  i: integer;
  sCode: string;
  sBrand: string;
  sClientID: string;
begin
   {i:=1;
   while i< GridAnalog.RowCount do
   begin
      NewElement := SelectList.Items[i-1];
      if NewElement.State <> 0 then
      begin
        MessageDlg('Не до конца обработан заказ!',mtInformation,[MBOK],0);
      exit;
      end;
      i:=i+1;
   end;}

   for i:=1  to GridAnalog.RowCount - 1 do
    begin
    if GridAnalog.Cells[0,i]<>GridAnalog.Cells[0,i-1] then
    begin
      with Data.WaitListTable do
      begin
        sCode := Data.MakeSearchCode(strLeft(GridAnalog.Cells[0,i],strFind(GridAnalog.Cells[0,i],'_')-1));
        sBrand := strRight(GridAnalog.Cells[0,i],length(GridAnalog.Cells[0,i]) -
        strFind(GridAnalog.Cells[0,i],'_'));
        sBrand := AnsiUpperCase(sBrand);
        sClientID:=Data.OrderTable.FieldByName('Cli_id').AsString;

        if not Locate('Code2;Brand', VarArrayOf([sCode, sBrand]), [loCaseInsensitive]) then
                begin
                  Append;
                  FieldByName('Code2').Value :=
                    sCode;
                  FieldByName('Brand').Value :=
                    sBrand;
                  FieldByName('DateCreate').value := Now;
                end
                else
                  Edit;
                FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat + strtoint(GridAnalog.Cells[5,i]);
                FieldByName('cli_id').Value := sClientID;
                Post;

               Main.QueryLoadOrderISAM.SQL.Clear;
               Main.QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET ORDERED = 3 WHERE Code2 = '''+sCode+''' AND Upper(Brand) = '''+sBrand+'''  AND  Order_id = '+sNumDoc);
               Main.QueryLoadOrderISAM.ExecSQL;
               Main.QueryLoadOrderISAM.Close;
      end;
    end;
    end;
    Data.CalcWaitList;
    Data.OrderDetTable.Refresh;
    Close;
end;

procedure TOrderAnswer.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TOrderAnswer.BitBtn2Click(Sender: TObject);
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
      Worksheet.Cells.Item[1, 1].Value := '№' + fLotusNumber;

      iRow := 2;
      //Дата командировки	Менеджер	Отдел поставок	Город	Клиент	Цель поездки
      Worksheet.Cells.Item[iRow,2].Value := 'Код';
      Worksheet.Cells.Item[iRow,3].Value := 'Бренд';
      Worksheet.Cells.Item[iRow,4].Value := 'Описание';
      //Worksheet.Cells.Item[iRow,5].Value := 'Цена ' + fCurrencyMain;
      Worksheet.Cells.Item[iRow,6].Value := 'Цена ' + fCurrencyDop;
      Worksheet.Cells.Item[iRow,7].Value := 'Кол-во';
      //Worksheet.Cells.Item[iRow,8].Value := 'Стоимость ' + fCurrencyMain;
      Worksheet.Cells.Item[iRow,9].Value := 'Стоимость ' + fCurrencyDop;
      Worksheet.Cells.Item[iRow,10].Value := 'База';

      aRange := Worksheet.Cells.Item[iRow, 2].Resize[1, 9];
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
          Worksheet.Cells.Item[iRow,2].Value := FieldByName('ArtCode').AsString;
          Worksheet.Cells.Item[iRow,3].Value := FieldByName('Brand').AsString;
          Worksheet.Cells.Item[iRow,4].Value := FieldByName('ArtNameDescr').AsString;
          //Worksheet.Cells.Item[iRow,5].Value := FieldByName('RealPriceBY').AsString;
          Worksheet.Cells.Item[iRow,6].Value := FieldByName('RealPriceEUR').AsString;
          Worksheet.Cells.Item[iRow,7].Value := FieldByName('Quantity').AsString;
          //Worksheet.Cells.Item[iRow,8].Value := FieldByName('Sum').AsString;
          Worksheet.Cells.Item[iRow,9].Value := FieldByName('SumEUR').AsString;
          Worksheet.Cells.Item[iRow,10].Value := FieldByName('Price').AsString;
          aSumBY := aSumBY + FieldByName('Sum').AsFloat;
          aSumEUR := aSumEUR + FieldByName('SumEUR').AsFloat;
          Next;
        end;

        aRange := Worksheet.Cells.Item[iRow, 2].Resize[1, 9];
        aRange.Borders[xlEdgeBottom].LineStyle := xlContinuous;
        aRange.Borders[xlEdgeBottom].Weight := xlMedium;
        Worksheet.Cells.Item[iRow + 1, 7].Value := 'Итого:';
        Worksheet.Cells.Item[iRow + 1, 7].HorizontalAlignment := xlRight;
        //Worksheet.Cells.Item[iRow + 1, 8].Value := aSumBY;
        //Worksheet.Cells.Item[iRow + 1, 8].Font.Bold := True;
        Worksheet.Cells.Item[iRow + 1, 9].Value := aSumEUR;
        Worksheet.Cells.Item[iRow + 1, 9].Font.Bold := True;

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

procedure TOrderAnswer.Button1Click(Sender: TObject);
begin
  ShowMessage(OrderedList.Text);
end;

procedure TOrderAnswer.btSaveZakClick(Sender: TObject);
var
  path: string;
begin
  SaveZak.Filter := 'Текстовый файл |*.csv';
  SaveZak.InitialDir := ExtractFileDir(Application.ExeName);

  if ZakazanoFileName <> '' then
  begin
    SaveZak.FileName :=ZakazanoFileName;
    if SaveZak.Execute() then
    begin
      path := SaveZak.FileName;
      CopyFile(pchar(ZakPath+ZakazanoFileName), pchar(path), True);
      MessageDlg('Заказ успешно сохранен!',mtInformation, [mbOK],0);
    end;
  end
  else
    MessageDlg('Отсутствуют позиции для сохранения',mtError, [mbOK],0);

  if ZamenyFileName <> '' then
  begin
    if MessageDlg('Желаете сохранить замены в файл?',mtInformation, [mbYes, mbNo],0) <> mrYes then
      exit;
    SaveZak.FileName := ZamenyFileName;
    if SaveZak.Execute() then
    begin
      path := SaveZak.FileName;
      CopyFile(pchar(ZakPath+ZamenyFileName), pchar(path), True);
      MessageDlg('Замены успешно сохранены!',mtInformation, [mbOK],0);
    end;
  end;


end;

procedure TOrderAnswer.CreateNewOrderClick(Sender: TObject);
  var
  LastNum: integer;
  sType:string;
  sClientID:string;
  i:integer;
  NewElement:MyElevent;
  sCode:string;
  sBrand:string;
  sCodeNew:string;
  sBrandNew:string;
  iDeliviry:integer;
begin
  sType:=Data.OrderTable.FieldByName('Type').AsString;
  sClientID:=Data.OrderTable.FieldByName('Cli_id').AsString;
  iDeliviry := Data.OrderTable.FieldByName('Delivery').AsInteger;
  if Main.OrderDateEd1.Date > Date then
    Main.OrderDateEd1.Date := Date;

  Main.OrderDateEd2.Date := Date;

  with Data.OrderTable do
  begin
    if data.ParamDataSource.DataSet.FieldByName('ShowAllOrders').AsBoolean then
      SetRange([Main.OrderDateEd1.Date], [Main.OrderDateEd2.Date])
    else
      SetRange([sClientID, Main.OrderDateEd1.Date], [sClientID, Main.OrderDateEd2.Date]);
    Last;
    if FieldByName('Date').AsDateTime = Date then
      LastNum := FieldByName('Num').AsInteger
    else
      LastNum := 0;
    Append;
    FieldByName('Date').Value := Date;
    FieldByName('Sent').Value := 0;
    FieldByName('Num').Value := LastNum + 1;
    FieldByName('Cli_id').Value := sClientID;
    FieldByName('Type').Value   := sType;
    if Trim(FieldByName('Type').AsString) = '' then
      FieldByName('Type').Value := sType;
    FieldByName('State').Value := 0;
    FieldByName('Delivery').Value := iDeliviry;
    Post;
  end;

  Main.ZakTabInfo;
  Main.SetActionEnabled;

  i:=1;
   while i< GridAnalog.RowCount do
   begin
      NewElement := SelectList.Items[i-1];
      if NewElement.bDelete = FALSE then
        begin
          if NewElement.State = 1  then
          begin
             sCode := Data.MakeSearchCode(strLeft(GridAnalog.Cells[0,i],strFind(GridAnalog.Cells[0,i],'_')-1));
             sBrand := strRight(GridAnalog.Cells[0,i],length(GridAnalog.Cells[0,i]) -
                    strFind(GridAnalog.Cells[0,i],'_'));
             sBrand := AnsiUpperCase(sBrand);

            if NewElement.bWaitList = TRUE then
            begin
              with Data.WaitListTable do
              begin


                if not Locate('Code2;Brand',
                  VarArrayOf([sCode, sBrand]), [loCaseInsensitive]) then
                begin
                  Append;
                  FieldByName('Code2').Value :=
                    sCode;
                  FieldByName('Brand').Value :=
                    sBrand;
                  FieldByName('DateCreate').value := Now;
                end
                else
                  Edit;
                FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat + strtoint(GridAnalog.Cells[5,i]);
                FieldByName('cli_id').Value := sClientID;
                Post;

               Main.QueryLoadOrderISAM.SQL.Clear;
               Main.QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET ORDERED = 3 WHERE Code2 = '''+sCode+''' AND Upper(Brand) = '''+sBrand+'''  AND  Order_id = '+sNumDoc);
               Main.QueryLoadOrderISAM.ExecSQL;
               Main.QueryLoadOrderISAM.Close;
              end;
            end
            else
            begin
              with Data.OrderDetTable do
                begin
                sCodeNew := GridAnalog.Cells[2,i];
                sCodeNew := Data.MakeSearchCode(sCodeNew);
                sBrandNew := AnsiUpperCase( GridAnalog.Cells[3,i] );

                if not Locate('Order_id;Code2;Brand',
                  VarArrayOf([Data.OrderTable.FieldByName('Order_id').AsInteger,
                  sCodeNew,
                  sBrandNew]), [loCaseInsensitive]) then
                begin
                  Append;
                  FieldByName('Order_id').Value :=
                    Data.OrderTable.FieldByName('Order_id').AsInteger;
                  FieldByName('Code2').Value :=
                    sCodeNew;
                  FieldByName('Brand').Value :=
                    sBrandNew;
                  FieldByName('Price').Value := NewElement.rEuro;
                end
                else
                 Edit;
                FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat +
                  strtoint(GridAnalog.Cells[5,i]);
                Post;

               Main.QueryLoadOrderISAM.SQL.Clear;
               Main.QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET ORDERED = 2 WHERE Code2 = '''+sCode+''' AND Upper(Brand) = '''+sBrand+'''  AND  Order_id = '+sNumDoc);
               Main.QueryLoadOrderISAM.ExecSQL;
               Main.QueryLoadOrderISAM.Close;
            end;
        end;
     end;
   end;
   //select * from [010] where Order_id = 50
   i:=i+1;
   end;
   Data.CalcWaitList;
   Data.OrderTable.Refresh;

   if(Data.OrderDetTable.RecordCount = 0) then
   begin
      Data.OrderTable.Delete;
      Data.OrderTable.RecNo:=iDocNumber;
   end;
   Data.OrderDetTable.Refresh;
   Close;
end;

procedure TOrderAnswer.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if SameText(Column.FieldName, 'UnReserv') then
    if Column.Field.AsString <> '' then
      Background := clRed;
end;

procedure TOrderAnswer.FormActivate(Sender: TObject);
var
     Path:string; 
     fname:string;
     F: TextFile;
     s:string;
     sLeft:string;
     iWidth:integer;
     NewElement:MyElevent;
     NewElem:MyElevent;
     RecCell:TRect;
     iPar:integer;
     iFindPos:integer;
     iColor:integer;
     iColorPath:integer;
     i:integer;
     sEvro:string;
     sCodeNew:string;
     sBrandNew:string;
     
     aKey: string;
     aInd: Integer;
     aValue: Double;
begin
  InitColumns;
  lbLotusNumber.Caption := '№ документа: ' + fLotusNumber;

    Path := ExtractFilePath(Forms.Application.ExeName) + 'Импорт\';
    iDocNumber := Data.OrderTable.RecNo;
    sNumDoc:= Data.OrderTable.FieldByName('Order_ID').AsString;
    OrderAnswerQuery.Active := FALSE;
    OrderAnswerQuery.SQL.Clear;
    OrderAnswerQuery.SQL.Add('SELECT * FROM [010] WHERE ORDERED = 1 AND Order_Id = '+Data.OrderTable.FieldByName('Order_Id').AsString);
    OrderAnswerQuery.Active := TRUE;

    OrderAnswerQuery.First;
    while not OrderAnswerQuery.Eof do
    begin
      aKey := AnsiUpperCase(OrderAnswerQuery.FieldByName('Code2').AsString) + '_' + AnsiUpperCase(OrderAnswerQuery.FieldByName('Brand').AsString);
      aInd := OrderedList.IndexOfName(aKey);
      if aInd >= 0 then
      begin
        aValue := StrToFloatDef(OrderedList.ValueFromIndex[aInd], 0);
        aValue := aValue - OrderAnswerQuery.FieldByName('Quantity').AsFloat;
        OrderedList[aInd] := aKey + '=' + FloatToStr(aValue);
      end;
      OrderAnswerQuery.Next;
    end;

    OrderAnswerQuery.First;
    while not OrderAnswerQuery.Eof do
    begin
      aKey := AnsiUpperCase(OrderAnswerQuery.FieldByName('Code2').AsString) + '_' + AnsiUpperCase(OrderAnswerQuery.FieldByName('Brand').AsString);
      aInd := OrderedList.IndexOfName(aKey);
      if aInd >= 0 then
        OrderedList[aInd] := OrderAnswerQuery.FieldByName('ID').AsString + '=' + OrderedList.ValueFromIndex[aInd];

      OrderAnswerQuery.Next;
    end;
    OrderAnswerQuery.First;
    OrderedListCalculated := True;
    OrderAnswerQuery.Refresh;

    GridAnalog.ColCount :=7;
    GridAnalog.RowCount :=1;
    GridAnalog.Cells[0,0]:= 'Код';
    GridAnalog.Cells[1,0]:= 'Цена';
    GridAnalog.Cells[2,0]:= 'Код аналога';
    GridAnalog.Cells[3,0]:= 'Бренд аналога';
    GridAnalog.Cells[4,0]:= 'Цена';
    GridAnalog.Cells[5,0]:= 'Кол-во';
    GridAnalog.Cells[6,0]:= 'Заказать';
    GridAnalog.RowHeights[0]:= 20;


    fname := Path+'Zameny_'+Data.OrderTable.FieldByName('Cli_ID').AsString+'_'+Data.OrderTable.FieldByName('Sign').AsString+'.csv';
    if FileExists(fname) then
   begin
    SelectList := TList.Create;

    AssignFile(F, fname);
    Reset(F);
    Readln(F, s);

    iWidth := 31;
    iPar := 0;
    iColor := 12189695;
    iColorPath:= 13828095;
    while not EOF(f) do
    begin

       NewElement := MyElevent.Create;
       NewElement.bFirst:=FALSE;
       NewElement.bWaitList :=FALSE;
       NewElement.bDelete:=FALSE;
       Readln(F, s);
       if Length(s)<10 then
       begin
         S:=s+'1';
       end;
       if StrFind(s,'_')<2 then
          break;
       GridAnalog.RowCount := GridAnalog.RowCount + 1;
       GridAnalog.RowHeights[GridAnalog.RowCount-1]:= 20;
       begin
         GridAnalog.Cells[2,GridAnalog.RowCount-1]:= StrLeft(s,StrFind(s,'_')-1);
         s:= StrRight(s,Length(s)-StrFind(s,'_'));
         GridAnalog.Cells[3,GridAnalog.RowCount-1]:= StrLeft(s,StrFind(s,';')-1);
         s:= StrRight(s,Length(s)-StrFind(s,';'));
         GridAnalog.Cells[5,GridAnalog.RowCount-1]:= StrLeft(s,StrFind(s,';')-1);
         s:= StrRight(s,Length(s)-StrFind(s,';'));
         s:= StrRight(s,Length(s)-StrFind(s,';'));
         s:= StrRight(s,Length(s)-StrFind(s,';'));

         GridAnalog.Cells[4,GridAnalog.RowCount-1]:= StrLeft(s,StrFind(s,';')-1);


         iFindPos:=StrFind(GridAnalog.Cells[4,GridAnalog.RowCount-1],',');
         if iFindPos>0 then
         begin
             GridAnalog.Cells[4,GridAnalog.RowCount-1] := StrLeft(GridAnalog.Cells[4,GridAnalog.RowCount-1],iFindPos-1)+'.'+strRight(GridAnalog.Cells[4,GridAnalog.RowCount-1],length(GridAnalog.Cells[4,GridAnalog.RowCount-1])-iFindPos);
         end;
         s:= StrRight(s,Length(s)-StrFind(s,';'));
         sEvro := StrLeft(s,StrFind(s,';')-1);

         iFindPos:=StrFind(sEvro,',');
         if iFindPos>0 then
         begin
             sEvro := StrLeft(sEvro,iFindPos-1)+'.'+strRight(sEvro,length(sEvro)-iFindPos);
         end;

         if Main.AToFloat(GridAnalog.Cells[4,GridAnalog.RowCount-1])> Main.AToFloat(sEvro) then
          GridAnalog.Cells[4,GridAnalog.RowCount-1]:=sEvro;


         s:= StrRight(s,Length(s)-StrFind(s,';'));
         
         //отрезаем - вконце кода_бренда в NAV приходит +2 поля (код_NAV;код_замены_NAV)
         iFindPos := StrFind(s, ';');
         if iFindPos > 0 then
           s := StrLeft(s, iFindPos - 1);
           
         GridAnalog.Cells[0,GridAnalog.RowCount-1]:= s;//StrLeft(s,StrFind(s,'_')-1);//TMain.StrLeft(s,TMain.StrFind(s,';'));
         if GridAnalog.Cells[0,GridAnalog.RowCount-1] <> GridAnalog.Cells[0,GridAnalog.RowCount-2] then
         with Data.OrderDetTable do
           begin
                DisableControls;
                sCodeNew := strLeft(GridAnalog.Cells[0,GridAnalog.RowCount-1],strFind(GridAnalog.Cells[0,GridAnalog.RowCount-1],'_')-1);
                sCodeNew := Data.MakeSearchCode(sCodeNew);
                sBrandNew := strRight(GridAnalog.Cells[0,GridAnalog.RowCount-1],length(GridAnalog.Cells[0,GridAnalog.RowCount-1]) -
                    strFind(GridAnalog.Cells[0,GridAnalog.RowCount-1],'_'));
                sBrandNew := AnsiUpperCase(sBrandNew);

                sCodeNew := Data.MakeSearchCode(sCodeNew);
                if Locate('Order_id;Code2;Brand',
                  VarArrayOf([sNumDoc,sCodeNew,
                  sBrandNew]), [loCaseInsensitive]) then
                begin
                   GridAnalog.Cells[1,GridAnalog.RowCount-1]:= Data.OrderDetTable.FieldByName('Price').AsString;
                end;
                EnableControls;
            end;

         if GridAnalog.Cells[0,GridAnalog.RowCount-1] <> GridAnalog.Cells[0,GridAnalog.RowCount-2] then
         begin

            if GridAnalog.RowCount>2 then
            begin
               NewElem := MyElevent.Create;
               NewElem.State :=0;
               NewElem.Rect.Left:=0;
               NewElem.Rect.right:=0;
               NewElem.Rect.top:=0;
               NewElem.Rect.bottom:=0;
               NewElem.iParent:=iPar;
               NewElem.bFirst:=FALSE;
               NewElem.iColor := iColor;
               NewElem.iColorPath := iColorPath;
               GridAnalog.RowCount := GridAnalog.RowCount+1;
               NewElem.bWaitList := TRUE;
               NewElem.bDelete := FALSE;
               for I := 0 to GridAnalog.ColCount - 1 do
                  begin
                    GridAnalog.Cells[i,GridAnalog.RowCount-1] := GridAnalog.Cells[i,GridAnalog.RowCount-2];
                    GridAnalog.Cells[i,GridAnalog.RowCount-2]:='';
                  end;
               GridAnalog.Cells[5,GridAnalog.RowCount-2]:=GridAnalog.Cells[5,GridAnalog.RowCount-3];
               GridAnalog.Cells[0,GridAnalog.RowCount-2]:=GridAnalog.Cells[0,GridAnalog.RowCount-3];
               GridAnalog.Cells[4,GridAnalog.RowCount-2]:= strleft(GridAnalog.Cells[0,GridAnalog.RowCount-2],StrFind(GridAnalog.Cells[0,GridAnalog.RowCount-2],'_')-1)+' добавить в лист ожидания';
               SelectList.Add(NewElem);

               NewElem := MyElevent.Create;
               NewElem.State :=1;
               NewElem.Rect.Left:=0;
               NewElem.Rect.right:=0;
               NewElem.Rect.top:=0;
               NewElem.Rect.bottom:=0;
               NewElem.iParent:=iPar;
               NewElem.bFirst:=FALSE;
               NewElem.iColor := iColor;
               NewElem.iColorPath := iColorPath;
               GridAnalog.RowCount := GridAnalog.RowCount+1;
               NewElem.bWaitList := FALSE;
               NewElem.bDelete := TRUE;
               for I := 0 to GridAnalog.ColCount - 1 do
                  begin
                    GridAnalog.Cells[i,GridAnalog.RowCount-1] := GridAnalog.Cells[i,GridAnalog.RowCount-2];
                    GridAnalog.Cells[i,GridAnalog.RowCount-2]:='';
                  end;
               GridAnalog.Cells[0,GridAnalog.RowCount-2]:=GridAnalog.Cells[0,GridAnalog.RowCount-3];
               GridAnalog.Cells[4,GridAnalog.RowCount-2]:='Пропустить ';
               SelectList.Add(NewElem);
            end;
            iPar :=iPar+1;
            NewElement.bFirst:=TRUE;
 //           dfds
//            GridAnalog.Cells[2,GridAnalog.RowCount-1]:= ;


            if iColor <> 12189695 then
            begin
               iColorPath:=13828095;
               iColor := 12189695
            end
            else
            begin
               iColor := 13828095;
               iColorPath:=12189695;
            end;
            end;
            NewElement.iColor:= iColor;
            NewElement.iColorPath:= iColorPath;
       end;
       NewElement.State := 0;
       NewElement.bWaitList:=FALSE;
       NewElement.rEuro := Main.AToFloat(GridAnalog.Cells[4,GridAnalog.RowCount-1]);
       NewElement.iParent := iPar;
       SelectList.Add(NewElement);

       if iWidth+31>GridAnalog.Height then
       begin
          RecCell:=GridAnalog.CellRect(5,GridAnalog.RowCount-1);
        //  GridAnalog.Height:= RecCell.Bottom+5;
          iWidth:=-1
       end
       else
         if iWidth>0 then
            iWidth:=iWidth+31;
   end;
    CloseFile(F);

    if GridAnalog.RowCount>2 then
    begin
         NewElem := MyElevent.Create;
         NewElem.State :=0;
         NewElem.Rect.Left:=0;
         NewElem.Rect.right:=0;
         NewElem.Rect.top:=0;
         NewElem.Rect.bottom:=0;
         NewElem.iParent:=iPar;
         NewElem.bFirst:=FALSE;
         NewElem.iColor := iColor;
         NewElem.iColorPath := iColorPath;
         NewElem.bWaitList := TRUE;
         NewElem.bDelete := FALSE;
         GridAnalog.RowCount := GridAnalog.RowCount+1;
         GridAnalog.Cells[0,GridAnalog.RowCount-1]:=GridAnalog.Cells[0,GridAnalog.RowCount-2];
         GridAnalog.Cells[5,GridAnalog.RowCount-1]:=GridAnalog.Cells[5,GridAnalog.RowCount-2];
         GridAnalog.Cells[4,GridAnalog.RowCount-1]:= strleft(GridAnalog.Cells[0,GridAnalog.RowCount-1],StrFind(GridAnalog.Cells[0,GridAnalog.RowCount-1],'_')-1)+' добавить в лист ожидания';
         SelectList.Add(NewElem);

          NewElem := MyElevent.Create;
         NewElem.State :=1;
         NewElem.Rect.Left:=0;
         NewElem.Rect.right:=0;
         NewElem.Rect.top:=0;
         NewElem.Rect.bottom:=0;
         NewElem.iParent:=iPar;
         NewElem.bFirst:=FALSE;
         NewElem.bDelete := TRUE;
         NewElem.iColor := iColor;
         NewElem.iColorPath := iColorPath;
         NewElem.bWaitList := FALSE;
         GridAnalog.RowCount := GridAnalog.RowCount+1;
         GridAnalog.Cells[0,GridAnalog.RowCount-1]:=GridAnalog.Cells[0,GridAnalog.RowCount-2];
         GridAnalog.Cells[4,GridAnalog.RowCount-1]:='Пропустить ';
         SelectList.Add(NewElem);
    end;
    end
    else
      AddToOficePaper.Visible := FALSE;


    if(GridAnalog.RowCount>1) then
      GridAnalog.FixedRows :=1;

    iWidth := (GridAnalog.ClientWidth - (60 * 4)) div (GridAnalog.ColCount - 4);
    GridAnalog.ColWidths[0]:= iWidth;
    GridAnalog.ColWidths[1]:= 60;
    GridAnalog.ColWidths[2]:= iWidth;
    GridAnalog.ColWidths[3]:= iWidth;
    GridAnalog.ColWidths[4]:= 60;
    GridAnalog.ColWidths[5]:= 60;
    GridAnalog.ColWidths[6]:= 60;


  for i:=1 to GridAnalog.RowCount do
  begin
    if (GridAnalog.Cells[2,i]<>'') and (GridAnalog.Cells[3,i]<>'') then
      GridAnalog.Cells[100, i] := GetDescr(GridAnalog.Cells[2,i], GridAnalog.Cells[3,i]);
  end;

  OrderAnswerQuery.First;
  while not OrderAnswerQuery.Eof do
  begin
    for i:=0 to GridAnalog.RowCount do
    begin
      if OrderAnswerQuery.FieldByName('ArtCode').AsString = GridAnalog.Cells[2,i] then
        GridAnalog.Cells[99,i] := IntToStr(i);
    end;
    OrderAnswerQuery.next;
  end;

end;


procedure TOrderAnswer.FormCreate(Sender: TObject);
begin
  ReserveList := TStringList.Create;
  OrderAnswerQuery.DatabaseName := Main.GetCurrentBD;
end;

procedure TOrderAnswer.FormDestroy(Sender: TObject);
begin
  ReserveList.Free;
end;

function TOrderAnswer.StrLeft(s:string; i:integer):string;
 var j:integer;
     itog:string;
begin
   itog := '';
   j := length(s);
   if i<j then
      while i>0 do
       begin
         itog := s[i] + itog;
         i:=i-1;
       end
   else
       itog := s;

    StrLeft := itog;
end;

function TOrderAnswer.StrRight(s:string; i:integer):string;
var j:integer;
     itog:string;
begin
   i := i-1;
   itog := '';
   j := length(s);
   if i<j then
      while i>-1 do
       begin
         itog := itog + s[j-i];
         i:=i-1;
       end
   else
       itog := s;
   StrRight := itog;
end;

function TOrderAnswer.StrFind(s:string; ch:char):integer;
var  itog:integer;
begin
   itog := 0;
   while(itog<Length(s)) do
   begin
   if(s[itog] = ch) then
      break
   else
      itog := itog + 1;
   end;
   if(itog>=Length(s)) then
      itog := -1;
   StrFind := itog;
end;

function TOrderAnswer.GetDescr(s1, s2: string): string;
begin
  Result := '';
  if Data.BrandTable.Locate('Description', s2, []) and
     Data.XCatTable.FindKey([Data.MakeSearchCode(s1)]) then
  Result := Data.XCatTable.FieldByName('Name_Descr').Value;
end;

procedure TOrderAnswer.GridAnalogDblClick(Sender: TObject);
var
  I,MX,MY, iRow,iCol:Integer;
  Rect:TRect;
begin
    iRow :=0;
    iCol :=0;
    MX:=Mouse.CursorPos.X - GridAnalog.ClientOrigin.X;
    MY:=Mouse.CursorPos.Y - GridAnalog.ClientOrigin.Y;
    for I := 0 to GridAnalog.RowCount -1 do
    begin
      Rect:=GridAnalog.CellRect(0,I);
      if((MY>=Rect.Top)and(MY<=Rect.Bottom)) then
         iRow := i;
    end;

    if iRow < 1 then exit;

    for I := 0 to GridAnalog.ColCount -1 do
    begin
      Rect:=GridAnalog.CellRect(I,0);
      if((MX>=Rect.Left)and(MX<=Rect.Right)) then
         iCol := i;
    end;

    if iCol <> 5 then exit;
    if Length(GridAnalog.Cells[iCol,iRow])<1 then exit;

    editkol := TDatePickerGrid.MyCreate(self, (Sender as TStringGrid), iRow, iCol);
end;

procedure TOrderAnswer.GridAnalogDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  NewElement:MyElevent;
  IconLeft,IconWidth,IconTop,IconHeight:Integer;
  IconNew:TIcon;
  iIter:integer;
  StringGrid: TStringGrid;
  Can: TCanvas;
  iWidthLiter, i:integer;
begin
//  exit;
  StringGrid := Sender as TStringGrid;
  Can := StringGrid.Canvas;
  Can.Font := StringGrid.Font;
  if (ARow >= 1) and (ACol >= 0) then
  begin
    NewElement := SelectList.Items[ARow-1];


    if (NewElement.bWaitList)and(ACol>1) then
    begin
      Can.Brush.Color := RGB(255,255,255);
      Can.Rectangle(Rect);
      Rect.top:=Rect.top+1;
    end;

    if (NewElement.bDelete) then
    begin
      Can.Brush.Color := RGB(255,255,255);
      Can.Rectangle(Rect);
      Rect.bottom:=Rect.bottom-1;
    end;

    if aCol = 0 then
    begin
      Can.Brush.Color := RGB(255,255,255);
      Can.Rectangle(Rect);
      Rect.Left:=Rect.Left+1;
    end;

    if aCol = 1 then
    begin
      Can.Brush.Color := RGB(255,255,255);
      Can.Rectangle(Rect);
      Rect.Right:=Rect.Right-1;
    end;

    if aCol = 6 then
    begin
      Can.Brush.Color := RGB(255,255,255);
      Can.Rectangle(Rect);
      Rect.Right:=Rect.Right-1;
    end;

    if ARow = GridAnalog.RowCount-1  then
    begin
      Can.Brush.Color := RGB(255,255,255);
      Can.Rectangle(Rect);
      Rect.bottom:=Rect.bottom-1;
    end;

    if (NewElement.bFirst) and (ARow>1) then
    begin
      Can.Brush.Color := RGB(255,255,255);
      Can.Rectangle(Rect);
      Rect.top:=Rect.top+1;
    end;

    iWidthLiter := StringGrid.Font.Size-2;

    if ACol < 2 then
      Can.Brush.Color := NewElement.iColorPath
    else
      Can.Brush.Color := NewElement.iColor;//StringGrid.Color

    if (StringGrid.Cells[ACol, ARow]<>'')or(ACol=1)or(ACol=6)or(NewElement.bWaitList)or(NewElement.bDelete) then
      Can.FillRect(Rect);

   i:=0;
   while GridAnalog.RowCount <> i  do
   begin
     if GridAnalog.Cells[99,i] <> '' then
     if (aRow = StrToInt(GridAnalog.Cells[99,i])) and (aCol > 1) then
     begin
       gridanalog.Canvas.Brush.Color:= rgb(255,212,212);
       gridanalog.Canvas.FillRect(Rect);
     end;
     inc(i);
   end;

    if (StringGrid.Cells[ACol, ARow] <> StringGrid.Cells[ACol, ARow -1])and(ACol = 0) then
      Can.TextOut(Rect.Left+2,Rect.Top+2, StrLeft(StringGrid.Cells[ACol, ARow],StrFind(StringGrid.Cells[ACol, ARow],'_')-1))
    else
    if (ACol = 4) or (ACol = 5) then
      Can.TextOut(Rect.Right - iWidthLiter*length(StringGrid.Cells[ACol, ARow]),Rect.Top+2, StringGrid.Cells[ACol, ARow])
    else
    if ACol <> 0 then
      Can.TextOut(Rect.Left+2,Rect.Top+2, StringGrid.Cells[ACol, ARow]);
  end
  else
  begin
    Can.Brush.Color := StringGrid.FixedColor;
    Can.Rectangle(Rect);
    Can.Brush.Color := StringGrid.FixedColor;
    if aCol = 0 then
    Rect.Left:=Rect.Left+1;
    Rect.Right:=Rect.Right-1;
    Rect.Top:=Rect.Top+1;
    Rect.Bottom:=Rect.Bottom-1;
    Can.FillRect(Rect);
    Can.TextOut(Rect.Left+2,Rect.Top+2, StringGrid.Cells[ACol, ARow]);
  end;

  IconNew := TIcon.Create;

  for iIter:=1 to  GridAnalog.TopRow-1 do
  begin
    NewElement := SelectList.Items[iIter-1];
    NewElement.Rect.Left:= 0;
    NewElement.Rect.Right:= 0;
    NewElement.Rect.Top:= 0;
    NewElement.Rect.Bottom:=  0;
  end;
  with GridAnalog do
  begin
    if ARow > 0 then
    begin
    NewElement := SelectList.Items[ARow-1];
      if ACol = 6 then
      begin
        Canvas.Brush.Style:=bsClear;
        Canvas.Font.Color := clWhite;
        if NewElement.State = 1 then
          ImageListCheck.GetIcon(1,IconNew)
        else
          ImageListCheck.GetIcon(2,IconNew);
        Rect.Left:= Rect.Left+ GridAnalog.ColWidths[5] div 2;
        Rect.Left:=Rect.Left - (16 div 2);
        Rect.Top := Rect.Top + (DefaultRowHeight div 2);
        Rect.Top := Rect.Top  - (16 div 2);
        IconLeft:= Rect.Left ;
        IconWidth:= (IconLeft + 16 );
        IconTop:=  Rect.Top ;
        IconHeight:= IconTop +16;

        NewElement.Rect.Left:= IconLeft;
        NewElement.Rect.Right:= IconWidth;
        NewElement.Rect.Top:= IconTop;
        NewElement.Rect.Bottom:=  IconHeight;
        Canvas.StretchDraw(NewElement.Rect,IconNew);

        for iIter:=ARow to  GridAnalog.RowCount-2 do
        begin
          NewElement := SelectList.Items[iIter];
          NewElement.Rect.Left:= 0;
          NewElement.Rect.Right:= 0;
          NewElement.Rect.Top:= 0;
          NewElement.Rect.Bottom:=  0;
        end;
      end;
    end;
  end;
end;

procedure TOrderAnswer.GridAnalogMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  x1,y1 : integer;
  HintValue, HintValueRaw : string;
  i: integer;
begin
  GridAnalog.MouseToCell(x,y,x1,y1);
  if (x1 = 2) and (y1 > 0) then
  begin
    HintValueRaw := GridAnalog.Cells[100,y1];
    if (GridAnalog.Cells[2,y1] <> '') then
    begin
      if (HintValueRaw <> PrevHintValue)then
      begin
        i:=100;
        HintValue := HintValueRaw;
        while length(HintValue) > i do
        begin
          if HintValue[i] = ' ' then
          begin
            HintValue[i] := chr(13);
            i := i + 90;
          end;
          inc(i);
        end;
        GridAnalog.ShowHint := true;
        GridAnalog.Hint := HintValue;
        Application.ActivateHint(Types.Point(X, Y));
        PrevHintValue := HintValueRaw;
      end;
    end
    else
    begin
      GridAnalog.ShowHint := false;
      PrevHintValue := '';
    end;
  end
  else
  begin
    GridAnalog.ShowHint := false;
    PrevHintValue := '';
  end;
end;

procedure TOrderAnswer.GridAnalogMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  iItem:integer;
  NewElement,OldElement:MyElevent;
  MX,MY:Integer;
  bVisibleOrder:BOOL;
begin
  bVisibleOrder:= FALSE;
  MX:=Mouse.CursorPos.X - GridAnalog.ClientOrigin.X;
  MY:=Mouse.CursorPos.Y - GridAnalog.ClientOrigin.Y;
  GridAnalog.Refresh;

  GridAnalog.Cursor := crDefault;
  iItem:= GridAnalog.TopRow-1;
  if iItem < 0 then
    exit;

  while(iItem<SelectList.Count) do
  begin
    NewElement:=SelectList.Items[iItem];

    if(NewElement.Rect.Left<=MX) and (NewElement.Rect.Right>=MX)
      and(NewElement.Rect.Top<=MY) and (NewElement.Rect.Bottom>=MY) then
    begin
      if(NewElement.State = 0) then
      begin
        NewElement.State := 1;
        for iItem := 0 to SelectList.Count - 1 do
        begin
          OldElement:=SelectList.Items[iItem];
          if (OldElement.iParent = NewElement.iParent) and (OldElement <> NewElement) then
            OldElement.State :=0;
        end;
        GridAnalog.Refresh;
      end

      else if NewElement.State = 1 then
      begin
        NewElement.State := 0;
        for iItem := 0 to SelectList.Count - 1 do
        begin
          OldElement:=SelectList.Items[iItem];
          if (OldElement.iParent = NewElement.iParent) and (OldElement <> NewElement) then
            OldElement.State :=0;
        end;
        GridAnalog.Refresh;
      end;
      //   break;
    end;

    iItem:=iItem+1;

  end;

  iItem :=0;
  while(iItem<SelectList.Count) do
  begin
    NewElement:=SelectList.Items[iItem];
    if NewElement.State <> 0 then
    begin
      bVisibleOrder := TRUE;
      break;
    end;
    iItem:=iItem+1;
  end;

  if bVisibleOrder then
  begin
    CreateNewOrder.Visible := TRUE;
    AddToOficePaper.Visible := FALSE;
  end
  else
  begin
    CreateNewOrder.Visible := FALSE;
    AddToOficePaper.Visible := TRUE;
  end;
end;

procedure TOrderAnswer.OrderAnswerQueryCalcFields(DataSet: TDataSet);
var
  i:integer;
  DetailCode:string;
  BrandName:string;
  sEURO, sBY:string;
  aValue: Double;
begin
  with DataSet do
  begin
    if OrderedListCalculated then
    begin
      aValue := StrToFloatDef(OrderedList.Values[FieldByName('ID').AsString], 0);
      if aValue > 0 then
        FieldByName('UnReserv').AsString := OrderedList.Values[FieldByName('ID').AsString]
      else
        FieldByName('UnReserv').AsString := '';
    end;


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
    FieldByName('Price_koef').Value :=
                XRoundCurr(Data.Rate * FieldByName('Price').AsCurrency, Data.Curr);


    FieldByName('ArtNameDescr').Value := Trim(FieldByName('ArtName').AsString + ' ' +
                                              FieldByname('ArtDescr').AsString);
    FieldByName('ArtCodeBrand').Value := Trim(FieldByName('ArtCode').AsString + '_' +
                                              AnsiUpperCase( FieldByname('Brand').AsString) );

    FieldByName('ArtCodeBrand').Value := Trim(FieldByName('ArtCode').AsString + '_' +
                                              AnsiUpperCase( FieldByname('Brand').AsString) );
    //StrList RealPriceEUR
    I := 0;
    while i < strList.Count do
    begin
      DetailCode := ExtractDelimited(1, strList[i], [';']);
      if DetailCode = FieldByName('Code2').AsString then
        begin
          BrandName := AnsiUpperCase( ExtractDelimited(2, strList[i], [';']) );
          if BrandName = AnsiUpperCase( FieldByName('Brand').AsString ) then
          begin
            sEURO := ExtractDelimited(3, strList[i], [';']);
            sBY := ExtractDelimited(4, strList[i], [';']);
            FieldByName('RealPriceBY').Value := XRoundCurr(Main.AToCurr(sBY), fCurrencyMainCode);
            FieldByName('RealPriceEUR').Value := XRoundCurr(1 * Main.AToCurr(sEURO), fCurrencyDopCode);

            FieldByName('Sum').Value := XRoundCurr(
              FieldByName('RealPriceBY').AsCurrency * FieldByName('Quantity').AsFloat,
              fCurrencyMainCode
            );

            FieldByName('SumEUR').Value := XRoundCurr(
              FieldByName('RealPriceEUR').AsCurrency * FieldByName('Quantity').AsFloat,
              fCurrencyDopCode
            );

            break;
          end;
        end;
      i := i + 1;
    end;
  end;
end;

procedure TOrderAnswer.OrderDetTableCalcFields(DataSet: TDataSet);
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
    FieldByName('Price_koef').Value :=
                XRoundCurr(Data.Rate * FieldByName('Price').AsCurrency, Data.Curr);
    FieldByName('Sum').Value :=
                XRoundCurr(FieldByName('Price_koef').AsCurrency *
                  FieldByName('Quantity').AsFloat, Data.Curr);
    FieldByName('ArtNameDescr').Value := Trim(FieldByName('ArtName').AsString + ' ' +
                                              FieldByname('ArtDescr').AsString);
    FieldByName('ArtCodeBrand').Value := Trim(FieldByName('ArtCode').AsString + '_' +
                                              AnsiUpperCase( FieldByname('Brand').AsString) );
  end;
end;

procedure TOrderAnswer.Init(aRespondList: TStringList; aCurrencyMain,
  aCurrencyDop, aLotusNumber: string; aOrderedList: TStringList;FileZakaz, FileZamen: String);
begin
  StrList := aRespondList;
  OrderedList := aOrderedList;
  
  fCurrencyMain := aCurrencyMain;
  fCurrencyDop := aCurrencyDop;
  fLotusNumber := aLotusNumber;

  if SameText(fCurrencyMain, 'BYR') then
    fCurrencyMainCode := Ord(ctBYR)    
  else
    fCurrencyMainCode := Ord(ctEUR);

  if SameText(fCurrencyDop, 'BYR') then
    fCurrencyDopCode := Ord(ctBYR)
  else
    fCurrencyDopCode := Ord(ctEUR);

  ZakPath := ExtractFileDir(Application.ExeName) + '\' + 'Импорт\';
  if FileExists(ZakPath+FileZakaz) then
    ZakazanoFileName := FileZakaz;
  if FileExists(ZakPath+FileZamen) then
    ZamenyFileName := FileZamen;
end;

procedure TOrderAnswer.InitColumns;

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
{
  aCol := FindCol('SumEUR');
  if Assigned(aCol) then
    aCol.Title.Caption := 'Сумма (' + fCurrencyDop + ')';
}
end;


end.
