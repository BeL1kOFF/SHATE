unit _TestForQuants;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,BSMath, GridsEh, DBGridEh, DB, dbisamtb, Grids,
  Buttons, ImgList,  ComCtrls, BSStrUt;



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

  TTestForQuants = class(TForm)
    Label_Available: TLabel;
    PanelTop: TPanel;
    Grid_Available: TDBGridEh;
    Query_Available: TDBISAMQuery;
    Query_AvailableArtCode: TStringField;
    Available_DataSource: TDataSource;
    Query_AvailableBrand: TStringField;
    Query_AvailableArtNameDescr: TStringField;
    Query_AvailableArtName: TStringField;
    Query_AvailableArtDescr: TStringField;
    Query_AvailablePrice_koef: TFloatField;
    Query_AvailableQuantity: TFloatField;
    Query_AvailableSumm: TCurrencyField;
    Query_AvailableCode2: TStringField;
    Query_AvailablePrice: TCurrencyField;
    Panel_Bottom: TPanel;
    Panel_Absent: TPanel;
    Label2: TLabel;
    GridAnalog: TStringGrid;
    BitBtn1: TBitBtn;
    Query_Analog: TDBISAMQuery;
    ImageListCheck: TImageList;
    BitBtn2: TBitBtn;
    MemoHint: TMemo;
    AnalogID: TDBISAMTable;
    DS_AnalogDescr: TDataSource;
    procedure Query_AvailableCalcFields(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);
    function StrLeft(s:string; i:integer):string;
    function StrRight(s:string; i:integer):string;
    function StrFind(s:string; ch:char):integer;
    procedure GridAnalogDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridAnalogDblClick(Sender: TObject);
    procedure GridAnalogMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GridAnalogMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TestForQuants: TTestForQuants;
  SelectList:TList;
  editkol:  TDatePickerGrid;

implementation
uses _Main, _Data;
{$R *.dfm}

procedure TTestForQuants.BitBtn1Click(Sender: TObject);
begin
 Close;
end;

procedure TTestForQuants.BitBtn2Click(Sender: TObject);
var
  i:integer;
  NewElement:MyElevent;
  sCode:string;
  sBrand:string;
  sCodeNew:string;
  sBrandNew:string;
  sID:string;
  sNumDoc:string;
begin
  sNumDoc := Data.OrderTable.FieldByName('Order_Id').AsString;
  with Data.OrderDetTable do
  begin
    i:=1;
    while i< GridAnalog.RowCount do
    begin
      NewElement := SelectList.Items[i-1];
      if NewElement.bDelete = FALSE then
      begin
        if NewElement.State = 1  then
        begin
          sCode := Data.MakeSearchCode(ExtractDelimited(1, GridAnalog.Cells[0,i], ['_']));
          sBrand := ExtractDelimited(2, GridAnalog.Cells[0,i], ['_']);
          sID := ExtractDelimited(3, GridAnalog.Cells[0,i], ['_']);

          if NewElement.bWaitList = TRUE then
          begin
            with Data.WaitListTable do
            begin
              if not Locate('Code2;Brand',VarArrayOf([sCode,sBrand]), []) then
              begin
                Append;
                FieldByName('Code2').Value := sCode;
                FieldByName('Brand').Value := sBrand;
              end
              else
                Edit;
              FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat + strtoint(GridAnalog.Cells[5,i]);
              Post;

              Main.QueryLoadOrderISAM.SQL.Clear;
              Main.QueryLoadOrderISAM.SQL.Add('DELETE FROM [010] WHERE Code2 = '''+sCode+''' AND Brand = '''+sBrand+'''  AND  Order_id = '+sNumDoc);
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
              sBrandNew := GridAnalog.Cells[3,i];
              sCode := Data.MakeSearchCode(ExtractDelimited(1, GridAnalog.Cells[0,i], ['_']));
              sBrand := ExtractDelimited(2, GridAnalog.Cells[0,i], ['_']);
              sID := ExtractDelimited(3, GridAnalog.Cells[0,i], ['_']);
              if not Locate('Order_id;Code2;Brand',
                VarArrayOf([Data.OrderTable.FieldByName('Order_id').AsInteger,
                  sCodeNew,sBrandNew]), []) then
              begin
                Append;
                FieldByName('Order_id').Value := Data.OrderTable.FieldByName('Order_id').AsInteger;
                FieldByName('Code2').Value := sCodeNew;
                FieldByName('Brand').Value := sBrandNew;
                FieldByName('Price').Value := NewElement.rEuro;
              end
              else
                Edit;

              FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat + strtoint(GridAnalog.Cells[5,i]);
              Post;

              Main.QueryLoadOrderISAM.SQL.Clear;
              Main.QueryLoadOrderISAM.SQL.Add('DELETE  FROM [010] WHERE Code2 = '''+sCode+''' AND Brand = '''+sBrand+'''  AND  Order_id = '+sNumDoc);
              Main.QueryLoadOrderISAM.ExecSQL;
              Main.QueryLoadOrderISAM.Close;
            end;
          end;
        end; //state = 1

      end //NewElement.bDelete = FALSE

      else
      begin
        sCode := Data.MakeSearchCode(ExtractDelimited(1, GridAnalog.Cells[0,i], ['_']));
        sBrand := ExtractDelimited(2, GridAnalog.Cells[0,i], ['_']);
        sID := ExtractDelimited(3, GridAnalog.Cells[0,i], ['_']);

        Main.QueryLoadOrderISAM.SQL.Clear;
        Main.QueryLoadOrderISAM.SQL.Add('DELETE  FROM [010] WHERE Code2 = ''' +
                                        sCode+''' AND Brand = ''' + sBrand + '''  AND  Order_id = ' + sNumDoc);
        Main.QueryLoadOrderISAM.ExecSQL;
        Main.QueryLoadOrderISAM.Close;
      end;
      i:=i+1;
    end; //while
  end; //with
  Close;
end;

procedure TTestForQuants.FormCreate(Sender: TObject);
var iWidth:integer;
    iPar:integer;
    iFindPos:integer;
    iColor:integer;
    iColorPath:integer;
    NewElement:MyElevent;
    NewElem:MyElevent;
    I:integer;
    RecCell:TRect;
    SQL:string;
    anAgrCode, SaleQ: string;
    PriceItog: Currency;
    //  DS_AnalogDescr: TDataSource;

  function getAnalog(gen_an_id: string): TDBISAMTable;
  begin
    result := nil;
    
    if StrToIntDef(gen_an_id, 0) < Data.MaxGenAnID.MaxGenAnIdFromTable_1 then
    begin
      Data.AnalogMainTable_1.Filter := 'gen_an_id = ' + gen_an_id;
      Data.AnalogMainTable_1.Filtered := TRUE;
      result := Data.AnalogMainTable_1;
    end
    else if StrToIntDef(gen_an_id, 0) < Data.MaxGenAnID.MaxGenAnIdFromTable_2 then
    begin
      Data.AnalogMainTable_2.Filter := 'gen_an_id = ' + gen_an_id;
      Data.AnalogMainTable_2.Filtered := TRUE;
      result := Data.AnalogMainTable_2;
    end
    else if StrToIntDef(gen_an_id, 0) < Data.MaxGenAnID.MaxGenAnIdFromTable_3 then
    begin
      Data.AnalogMainTable_3.Filter := 'gen_an_id = ' + gen_an_id;
      Data.AnalogMainTable_3.Filtered := TRUE;
      result := Data.AnalogMainTable_3;
    end
    else if StrToIntDef(gen_an_id, 0) < Data.MaxGenAnID.MaxGenAnIdFromTable_4 then
    begin
      Data.AnalogMainTable_4.Filter := 'gen_an_id = ' + gen_an_id;
      Data.AnalogMainTable_4.Filtered := TRUE;
      result := Data.AnalogMainTable_4;
    end
    else if StrToIntDef(gen_an_id, 0) < Data.MaxGenAnID.MaxGenAnIdFromTable_5 then
    begin
      Data.AnalogMainTable_5.Filter := 'gen_an_id = ' + gen_an_id;
      Data.AnalogMainTable_5.Filtered := TRUE;
      result := Data.AnalogMainTable_5;
    end
  end;              

begin
  anAgrCode := Data.OrderTable.FieldByName('Agreement_No').AsString;
  Query_Available.DatabaseName := Main.GetCurrentBD;

  iWidth := 21;
  iPar := 0;
  iColor := 12189695;
  iColorPath:= 13828095;

  SelectList := TList.Create;
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
  SetCurrentDir(Data.Data_Path);
  with Data do
  begin
    Main.OrderDetGrid.DataSource := Nil;
    OrderDetTable.First;
//    AnalogOrderDet.Open;
    AnalogID.Open;
    while not OrderDetTable.Eof do
    begin
      if OrderDetTable.FieldByName('TestQuants').AsInteger = 1 then
      begin
        AnalogID.Filtered := FALSE;
        AnalogID.Filter := 'cat_id = ' + OrderDetTable.FieldByName('Cat_id').AsString;
        AnalogID.Filtered := TRUE;
        while not AnalogID.Eof do
        begin
          DS_AnalogDescr.DataSet := nil;
          DS_AnalogDescr.DataSet := getAnalog(AnalogID.FieldByName('gen_an_id').AsString);
          if not DS_AnalogDescr.DataSet.Eof then
          begin
            if (DS_AnalogDescr.DataSet.FieldByName('Quantity').AsString <> '')and(DS_AnalogDescr.DataSet.FieldByName('Quantity').AsString <> '0') then
            begin
              NewElement := MyElevent.Create;
              NewElement.bFirst:=FALSE;
              NewElement.bWaitList :=FALSE;
              NewElement.bDelete:=FALSE;

              GridAnalog.RowCount := GridAnalog.RowCount + 1;
              GridAnalog.RowHeights[GridAnalog.RowCount-1]:= 20;

              GridAnalog.Cells[0,GridAnalog.RowCount-1]:= OrderDetTable.FieldByName('Code2').AsString + '_' + OrderDetTable.FieldByName('Brand').AsString;
              GridAnalog.Cells[2,GridAnalog.RowCount-1]:= DS_AnalogDescr.DataSet.FieldByName('An_Code').AsString;
              GridAnalog.Cells[3,GridAnalog.RowCount-1]:= DS_AnalogDescr.DataSet.FieldByName('An_Brand').AsString;
              GridAnalog.Cells[5,GridAnalog.RowCount-1]:= OrderDetTable.FieldByName('Quantity').AsString;
              GridAnalog.Cells[10, GridAnalog.RowCount-1] := DS_AnalogDescr.DataSet.FieldByName('Description').AsString;

              GridAnalog.Cells[4,GridAnalog.RowCount-1]:= FloatToStr(DS_AnalogDescr.DataSet.FieldByName('Price_koef').Value);
             { if Data.Curr = 2 then
                                if DS_AnalogDescr.DataSet.FieldByName('SaleQ').AsString = '1' then
                  GridAnalog.Cells[4,GridAnalog.RowCount-1]:= FloatToStr(XRound(Data.Rate * DS_AnalogDescr.DataSet.FieldByName('Price').AsCurrency,-1))
                else
                  GridAnalog.Cells[4,GridAnalog.RowCount-1] :=  FloatToStr(
                            XRound(  Data.Rate *
                                    (Data.GetDiscount(0,0,DS_AnalogDescr.DataSet.FieldByName('An_Brand_id').AsInteger)) *
                                     DS_AnalogDescr.DataSet.FieldByName('Price').AsCurrency,-1
                                  ))

              else if DS_AnalogDescr.DataSet.FieldByName('SaleQ').AsString = '1' then
                  GridAnalog.Cells[4,GridAnalog.RowCount-1]:= FloatToStr(XRound(Data.Rate * DS_AnalogDescr.DataSet.FieldByName('Price').AsCurrency,2))


              else
                    GridAnalog.Cells[4,GridAnalog.RowCount-1]:= FloatToStr(
                              XRound( Data.Rate *(
                                      Data.GetDiscount(0,0,DS_AnalogDescr.DataSet.FieldByName('An_Brand_id').AsInteger)) *
                                      DS_AnalogDescr.DataSet.FieldByName('Price').AsCurrency,2
                                    )); }

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
                  GridAnalog.Cells[10, GridAnalog.RowCount-1] := GridAnalog.Cells[10,GridAnalog.RowCount-2];
                  GridAnalog.Cells[10, GridAnalog.RowCount-2] := '';

                  GridAnalog.Cells[5,GridAnalog.RowCount-2]:=GridAnalog.Cells[5,GridAnalog.RowCount-3];
                  GridAnalog.Cells[0,GridAnalog.RowCount-2]:=GridAnalog.Cells[0,GridAnalog.RowCount-3];
                  GridAnalog.Cells[4,GridAnalog.RowCount-2]:= strleft(GridAnalog.Cells[0,GridAnalog.RowCount-2],StrFind(GridAnalog.Cells[0,GridAnalog.RowCount-2],'_')-1)+' добавить в лист ожидания';
                  SelectList.Add(NewElem);
                end;

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

                iPar :=iPar+1;
                NewElement.bFirst:=TRUE;
                if Data.Curr = 2 then
                  GridAnalog.Cells[1,GridAnalog.RowCount-1]:= floattostr(XRound(Data.Rate * OrderDetTable.FieldByName('Price').AsCurrency,-1))
                else
                  GridAnalog.Cells[1,GridAnalog.RowCount-1]:= floattostr(XRound(Data.Rate * OrderDetTable.FieldByName('Price').AsCurrency, 2));
              end;


              NewElement.iColor:= iColor;
              NewElement.iColorPath:= iColorPath;
              NewElement.State := 0;
              NewElement.bWaitList:=FALSE;
              { if DS_AnalogDescr.DataSet.FieldByName('SaleQ').AsString = '1' then
                NewElement.rEuro := XRound(DS_AnalogDescr.DataSet.FieldByName('Price').AsCurrency,2)
              else
                NewElement.rEuro := XRound( (Data.GetDiscount(0,0,DS_AnalogDescr.DataSet.FieldByName('An_Brand_id').AsInteger))
                                           * DS_AnalogDescr.DataSet.FieldByName('Price').AsCurrency,2
                                          );
              }
              NewElement.rEuro := DS_AnalogDescr.DataSet.FieldByName('Price_koef_eur').Value;
              NewElement.iParent := iPar;
              SelectList.Add(NewElement);
              if iWidth+21>GridAnalog.Height then
              begin
                RecCell:=GridAnalog.CellRect(5,GridAnalog.RowCount-1);
                iWidth:=-1
              end
              else
              if iWidth>0 then
                iWidth:=iWidth+21;

            end;
          end; //endIF DS_AnalogDescr
          AnalogID.Next;
        end;//endWhile AnalogID

      end;
      OrderDetTable.Next;
    end;//OrderDetTable

    Main.OrderDetGrid.DataSource := Data.OrderDetDataSource;
  end;

  if GridAnalog.RowCount>1 then
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
    GridAnalog.Cells[10,GridAnalog.RowCount-1]:=GridAnalog.Cells[10,GridAnalog.RowCount-2];
    SelectList.Add(NewElem);
  end;

  iWidth := Round((GridAnalog.ClientWidth)/(GridAnalog.ColCount));
  GridAnalog.ColWidths[0]:= iWidth;
  GridAnalog.ColWidths[1]:= iWidth;
  GridAnalog.ColWidths[2]:= iWidth;
  GridAnalog.ColWidths[3]:= iWidth;
  GridAnalog.ColWidths[4]:= iWidth;
  GridAnalog.ColWidths[5]:= iWidth;
  GridAnalog.ColWidths[6]:= GridAnalog.ClientWidth - (GridAnalog.ColCount-1)*iWidth;

  Query_Available.Active := FALSE;
  Query_Available.SQL.Clear;
  Query_Available.SQL.Add('SELECT * FROM [010] WHERE TestQuants = 2 AND Order_Id = '+Data.OrderTable.FieldByName('Order_Id').AsString);
  Query_Available.Active := TRUE;
end;

procedure TTestForQuants.FormDestroy(Sender: TObject);
begin
   SelectList.Free;
end;

procedure TTestForQuants.GridAnalogDblClick(Sender: TObject);
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

procedure TTestForQuants.GridAnalogDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  NewElement:MyElevent;
  IconLeft,IconWidth,IconTop,IconHeight:Integer;
  IconNew:TIcon;
  iIter:integer;
  StringGrid: TStringGrid;
  Can: TCanvas;
  iWidthLiter:integer;
begin
  StringGrid := Sender as TStringGrid;
  Can := StringGrid.Canvas;
  Can.Font := StringGrid.Font;
  if (ARow >= 1) and (ACol >= 0)
   then
   begin
      NewElement := SelectList.Items[ARow-1];
      if ARow=5 then
        ARow := 5;
      if (NewElement.bWaitList)and(ACol>1) then
        begin
        Can.Brush.Color := RGB(255,255,255);
        Can.Rectangle(Rect);
        Rect.top:=Rect.top+1;
        end;

    {  if (NewElement.bDelete) then
        begin
        Can.Brush.Color := RGB(255,255,255);
        Can.Rectangle(Rect);
        Rect.bottom:=Rect.bottom-1;
        end;}

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



      if (NewElement.bFirst) and (ARow>1) then
        begin
        Can.Brush.Color := RGB(255,255,255);
        Can.Rectangle(Rect);
        Rect.top:=Rect.top+1;
        end;

      if ARow = GridAnalog.RowCount-1  then
        begin
        Can.Brush.Color := RGB(255,255,255);
        Can.Rectangle(Rect);
        Rect.bottom:=Rect.bottom-1;
        end;

      if (NewElement.bWaitList) then
        begin
         Can.Brush.Color := RGB(255,255,255);
         Can.Rectangle(Rect); 
         Rect.bottom:=Rect.bottom-1;
        end;



      iWidthLiter:=StringGrid.Font.Size-2;

      if ACol < 2 then
         Can.Brush.Color := NewElement.iColorPath
      else
        Can.Brush.Color := NewElement.iColor;//StringGrid.Color

      if (StringGrid.Cells[ACol, ARow] <>'')or(ACol=1)or(ACol=6)or(NewElement.bWaitList)or(NewElement.bDelete) then
            Can.FillRect(Rect);

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
      begin
      if ACol = 6 then
      Begin
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

        End;
      end;
      end;
    end;

end;

procedure TTestForQuants.GridAnalogMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
  aCol, aRow: Integer;
  i: Integer;
  s: string;
begin
  GetCursorPos(p);

  GridAnalog.MouseToCell(X, Y, aCol, aRow);
  if (aCol = 2) and (aRow >= GridAnalog.FixedRows) and (GridAnalog.Cells[aCol, aRow] <> '') then
  begin
    MemoHint.Text := GridAnalog.Cells[10, aRow];
    s := '';
    for i := 0 to MemoHint.Lines.Count - 1 do
      if s = '' then
        s := MemoHint.Lines[i]
      else
        s := s + #13#10 + MemoHint.Lines[i];
    GridAnalog.Hint := s;
  end
  else
    GridAnalog.Hint := '';
  Application.ActivateHint(p);
end;

procedure TTestForQuants.GridAnalogMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  iItem:integer;
   NewElement,OldElement:MyElevent;
   MX,MY:Integer;
begin
  MX:=Mouse.CursorPos.X - GridAnalog.ClientOrigin.X;
  MY:=Mouse.CursorPos.Y - GridAnalog.ClientOrigin.Y;
  GridAnalog.Refresh;


  GridAnalog.Cursor := crDefault;
  iItem:= GridAnalog.TopRow-1;
  if iItem < 0 then
    iItem := 0;

  while(iItem<SelectList.Count) do
  begin
    NewElement:=SelectList.Items[iItem];

    if(NewElement.Rect.Left<=MX)
      and(NewElement.Rect.Right>=MX)
        and(NewElement.Rect.Top<=MY)
          and(NewElement.Rect.Bottom>=MY) then
    begin
      if(NewElement.State = 0) then
      begin
        NewElement.State := 1;
        for iItem := 0 to SelectList.Count - 1 do
        begin
          OldElement:=SelectList.Items[iItem];
            if (OldElement.iParent = NewElement.iParent)AND(OldElement <> NewElement) then
              OldElement.State :=0;
        end;
        GridAnalog.Refresh;
      end
      else
      if NewElement.State = 1 then
      begin
        NewElement.State := 0;
        for iItem := 0 to SelectList.Count - 1 do
        begin
          OldElement:=SelectList.Items[iItem];
          if (OldElement.iParent = NewElement.iParent)AND(OldElement <> NewElement) then
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
      break;
    iItem:=iItem+1;
  end;
end;

procedure TTestForQuants.Query_AvailableCalcFields(DataSet: TDataSet);
begin
   //Раси
  with DataSet do
  begin
    if Data.BrandTable.Locate('Description', FieldByName('Brand').AsString, []) and
       Data.XCatTable.FindKey([FieldByName('Code2').AsString,
                          Data.BrandTable.FieldByName('Brand_id').AsInteger]) then
    begin
      FieldByname('ArtCode').Value := Data.XCatTable.FieldByName('Code').AsString;
      FieldByname('ArtName').Value := Data.XCatTable.FieldByName('Name').AsString;
      FieldByname('ArtDescr').Value := Data.XCatTable.FieldByName('Description').AsString;
    end
    else
      FieldByname('ArtCode').Value := FieldByName('Code2').AsString;

    FieldByName('ArtNameDescr').Value := Trim(FieldByName('ArtName').AsString + ' ' +
                                              FieldByname('ArtDescr').AsString);
    FieldByName('Price_koef').Value := XRoundCurr(Data.Rate * FieldByName('Price').AsCurrency, Data.Curr);

      FieldByName('Summ').Value := FieldByName('Price_koef').AsCurrency *
              FieldByName('Quantity').AsFloat;
  end;
end;

function TTestForQuants.StrLeft(s:string; i:integer):string;
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

function TTestForQuants.StrRight(s:string; i:integer):string;
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

function TTestForQuants.StrFind(s:string; ch:char):integer;
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
//  vFParent: TWinControl;
  Rec:TRect;
begin
//   vfparent := parent;
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



end.
