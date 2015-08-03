unit _QuantEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BSDlgFrm, JvComponentBase, JvFormPlacement, StdCtrls, Mask, JvExMask,
  JvToolEdit, JvBaseEdits, Buttons, ExtCtrls, AdvAppStyler, AdvPanel,
  JvExStdCtrls, JvEdit, JvValidateEdit, AdvOfficeHint, DBGridEh, DB, dbisamtb,
  DBCtrlsEh, DBLookupEh, GridsEh, DBCtrls, Animate, GIFCtrl, JvGIF,
  _Task_F7;

type
  TQuantityEdit = class(TForm)
    FormStyler: TAdvFormStyler;
    BitBtn1: TBitBtn;
    QOrders: TDBISAMQuery;
    QOrdersSource: TDataSource;
    QOrdersOrder_id: TAutoIncField;
    QOrdersDescription: TStringField;
    QOrdersType: TStringField;
    QOrdersSent: TStringField;
    QOrdersCurrency: TIntegerField;
    QOrdersIsCurrent: TStringField;
    QOrdersDate: TDateField;
    QOrdersNum: TIntegerField;
    QOrdersLookupRes: TStringField;
    pnOrder: TPanel;
    Label5: TLabel;
    OrderLookup: TDBLookupComboboxEh;
    Panel1: TPanel;
    Label2: TLabel;
    MultLabel: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    QuantityEd: TJvCalcEdit;
    MultInfo: TJvValidateEdit;
    InfoEd: TEdit;
    QOrdersCli_id: TStringField;
    animWait: TRxGIFAnimator;
    Label6: TLabel;
    Panel2: TPanel;
    ArtInfo: TMemo;
    Image1: TImage;
    SendAckQuants: TSpeedButton;
    Shape1: TShape;
    Bevel1: TBevel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FormStorage: TJvFormStorage;
    SendAckQuantsOrder: TSpeedButton;
    procedure EdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OkBtnClick(Sender: TObject);
    procedure SendAckQuantsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure QOrdersCalcFields(DataSet: TDataSet);
    procedure OrderLookupDropDownBoxGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SendAckQuantsOrderClick(Sender: TObject);
    procedure QuantityEdKeyPress(Sender: TObject; var Key: Char);
  private
    fTaskF7: TTaskF7;

    fCode: string;
    fBrand: string;
    fCheckOrderOnly: Boolean;
    fRequestQuants: Boolean;
    function GetResOrderId: Integer;
    function GetResOrderDate: TDate;

    procedure StartF7Task(aCheckOrderOnly: Boolean);
    procedure StopF7Task;

    procedure TaskF7BeforeRun(Sender: TObject; var aCanRun: Boolean);
    procedure TaskF7AfterEnd(Sender: TObject);
  public
    procedure Init(aCurrentOrderID: Integer; aCurrentClientID: string; aIsNew: Boolean{new/edit mode}; const aCode, aBrand: string; aRequestQuants: Boolean = False);
    property ResOrderId: Integer read GetResOrderId;
    property ResOrderDate: TDate read GetResOrderDate;
  end;

var
  QuantityEdit: TQuantityEdit;

implementation

uses _Main, _Data, _ScheduledTask;

{$R *.dfm}

procedure TQuantityEdit.FormActivate(Sender: TObject);
begin
  if Tag = 1 then
    Exit;
  Tag := 1;

  Color := Data.ParamTable.FieldByName('ColorOrder').AsInteger;

  if fRequestQuants and (fCode <> '') and (fBrand <> '') then
    SendAckQuants.Click;
end;

procedure TQuantityEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopF7Task;
end;

procedure TQuantityEdit.FormCreate(Sender: TObject);
var
  R: TRect;
  N: Integer;
  Buff: array[0..255] of Char;
begin
  with BitBtn1 do
  begin
    Glyph.Canvas.Font := Self.Font;
    R := Bounds(Glyph.Width, 0, Width - 6-Glyph.Width, 0);
    Glyph.Width  := Width - 6;
    Glyph.Height := Height - 6;

    StrPCopy(Buff, Caption);
    Caption := '';
    DrawText(Glyph.Canvas.Handle,Buff,StrLen(Buff),R, DT_CENTER or DT_WORDBREAK or DT_CALCRECT);
    OffsetRect(R,(Glyph.Width - R.Right) div 2,(Glyph.Height - R.Bottom) div 2);
    DrawText(Glyph.Canvas.Handle,Buff,StrLen(Buff),R, DT_CENTER or DT_WORDBREAK);
  end;
end;

procedure TQuantityEdit.FormDestroy(Sender: TObject);
begin
  QOrders.Close;
end;

procedure TQuantityEdit.StartF7Task(aCheckOrderOnly: Boolean);
begin
  if Main.TimerAskQuants.Enabled then
  begin
    MessageDlg('Подождите!', mtInformation, [mboK],0);
    Exit;
  end;
 // MessageDlg('Функция онлайн проверки наличия более недоступна.', mtInformation, [mbYes], 0);
  StopF7Task;
  fCheckOrderOnly := aCheckOrderOnly;
  fTaskF7 := TTaskF7.Create;
  fTaskF7.OnBeforeRun := TaskF7BeforeRun;
  fTaskF7.OnAfterEnd := TaskF7AfterEnd;
  fTaskF7.Enabled := True;
  fTaskF7.Start;  
end;

procedure TQuantityEdit.StopF7Task;
begin
  if Assigned(fTaskF7) then
  begin
    fTaskF7.OnAfterEnd := nil;
    fTaskF7.Free;
    fTaskF7 := nil;
  end;
end;

procedure TQuantityEdit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    if Assigned(fTaskF7) and (fTaskF7.State = tsRunning) then
    begin
      Key := 0;

      SendAckQuants.Visible := True;
      SendAckQuantsOrder.Visible := True;
      animWait.Animate := False;
      animWait.Visible := False;
      Label4.Caption := '';
      Label4.Visible := False;

      StopF7Task;
    end
    else
      ModalResult := mrCancel;
end;

procedure TQuantityEdit.FormShow(Sender: TObject);
begin
  if QuantityEd.CanFocus then
    QuantityEd.SetFocus;
end;

function TQuantityEdit.GetResOrderDate: TDate;
begin
  if (OrderLookup.KeyValue = NULL) or (not QOrders.Active) then
    Result := 0
  else
    Result := QOrders.FieldByName('Date').AsDateTime;
end;

function TQuantityEdit.GetResOrderId: Integer;
begin
  if OrderLookup.KeyValue = NULL then
    Result := 0
  else
    Result := OrderLookup.KeyValue;
end;

procedure TQuantityEdit.OkBtnClick(Sender: TObject);
begin
  inherited;
  if QuantityEd.Value <= 0 then
  begin
    MessageDlg('Количество должно быть больше 0!', mtError, [mbOK], 0);
    QuantityEd.SetFocus;
    ModalResult := 0;
  end;
  if (MultInfo.Value > 0) and ((QuantityEd.Value mod MultInfo.Value) <> 0) then
  begin
    MessageDlg('Позиция не может быть добавлена в заказ! Количество не кратно рекомендуемому.', mtError,
                [mbYes], 0);
    QuantityEd.SetFocus;
    ModalResult := 0;
  end;
end;

procedure TQuantityEdit.OrderLookupDropDownBoxGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if OrderLookup.DropDownBox.ListSource.DataSet.FieldByName('IsCurrent').AsString <> '' then
    AFont.Style := [fsBold];
end;

procedure TQuantityEdit.SendAckQuantsClick(Sender: TObject);
begin
  StartF7Task(False);
end;

procedure TQuantityEdit.SendAckQuantsOrderClick(Sender: TObject);
begin
  StartF7Task(True);
end;

procedure TQuantityEdit.BitBtn1Click(Sender: TObject);
begin
  inherited;
  Main.AddAssortmentExpansion.Execute;
  Close;
end;

procedure TQuantityEdit.EdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  DoKrat : integer;
begin
  if Key = VK_RETURN then
  begin
     Key := 0;
     OkBtn.Click;
     Exit;  //do not call inherited
  end;
  if not (Key in [VK_UP, VK_DOWN]) then
  Exit;
  try
    if QuantityEd.value = MultInfo.Value then
      case Key of
        VK_UP: QuantityEd.Text := IntToStr(strtointdef(QuantityEd.text, MultInfo.Value) + MultInfo.Value) ;
      end
    else
      if QuantityEd.Value <= 0  then
        QuantityEd.Value := MultInfo.Value
      else
        if QuantityEd.Value mod MultInfo.Value <> 0 then
        begin
          DoKrat := QuantityEd.Value mod MultInfo.Value;
          case Key of
            VK_UP:
            begin
              DoKrat := MultInfo.Value - DoKrat;
              QuantityEd.text:=inttostr((strtointdef(QuantityEd.text,MultInfo.Value))+DoKrat);
            end;

            VK_DOWN:
            begin
              DoKrat := strToInt(QuantityEd.text) - DoKrat;
              QuantityEd.text:=inttostr((strtointdef(QuantityEd.text,MultInfo.Value))-DoKrat);
            end;
          end;
        end
        else
          case key of
            VK_UP: QuantityEd.text := inttostr(strtointdef(QuantityEd.text,MultInfo.Value)+MultInfo.Value);
            VK_DOWN: QuantityEd.text := inttostr(strtointdef(QuantityEd.text,MultInfo.Value)-MultInfo.Value);
          end;
  except
    //QuantityEd.Text := MultInfo.Value;
  end;
end;

procedure TQuantityEdit.Init(aCurrentOrderID: Integer; aCurrentClientID: string;
  aIsNew: Boolean; const aCode, aBrand: string; aRequestQuants: Boolean);
begin
  fCode := aCode;
  fBrand := aBrand;
  fRequestQuants := aRequestQuants;

  SendAckQuants.Visible := (fCode <> '') and (fBrand <> '');
  SendAckQuantsOrder.Visible := SendAckQuants.Visible;

  //aIsNew := False;
  if aIsNew then
  begin
    QOrders.SQL.Text :=
     ' SELECT * FROM [009] ' +
     ' WHERE (Sent is NULL or Sent = '''' or Sent = ''0'' or Sent = ''3'') and cli_id = :cli_id ' +
     ' ORDER BY Date DESC, Num Desc ';
    QOrders.Params[0].Value := aCurrentClientID;
    QOrders.Open;
    OrderLookup.KeyValue := aCurrentOrderID;
  end
  else
  begin
    pnOrder.Visible := False;
    Self.Height := Self.Height - pnOrder.Height;
  end;
end;

procedure TQuantityEdit.QOrdersCalcFields(DataSet: TDataSet);
begin
  inherited;
  if QOrdersOrder_id.Value = Data.OrderTableOrder_id.Value then
    QOrdersIsCurrent.Value := ' * '
  else
    QOrdersIsCurrent.Value := '';

  QOrdersLookupRes.Value := QOrdersIsCurrent.Value + QOrdersDate.AsString + '  -  №' + QOrdersNum.AsString + ' (' + QOrdersType.AsString + ')';
  if QOrdersDescription.AsString <> '' then
    QOrdersLookupRes.Value := QOrdersLookupRes.Value + '  "' + QOrdersDescription.Value + '"';
end;

procedure TQuantityEdit.QuantityEdKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', Chr(VK_DELETE), Chr(VK_BACK)]) then
    Key := #0;
end;

procedure TQuantityEdit.TaskF7BeforeRun(Sender: TObject; var aCanRun: Boolean);
var
  aData: TF7TaskData;
begin
  if Sender is TTaskF7 then
  begin
    aCanRun := False;
    if (fCode = '') or (fBrand = '') then
      Exit;

    if not Main.CheckClientID then
      Exit;

    SendAckQuants.Visible := False;
    SendAckQuantsOrder.Visible := False;
    animWait.Animate := True;
    animWait.Visible := True;
    if fCheckOrderOnly then
      Label4.Caption := 'запрос поставки...'
    else
      Label4.Caption := 'запрос наличия...';
    Label4.Visible := True;
//    Application.ProcessMessages;

//    aData.Host1 := Data.SysParamTable.FieldByName('Host').AsString;
    aData.Host1 := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
    aData.Port1 := Data.SysParamTable.FieldByName('ITNPort').AsInteger;
//    aData.Host2 := Data.SysParamTable.FieldByName('BackHost').AsString;
    aData.Port2 := Data.SysParamTable.FieldByName('ITNPort').AsInteger;
    aData.Host3 := Data.SysParamTable.FieldByName('TCPHost3').AsString;
    aData.Port3 := Data.SysParamTable.FieldByName('ITNPort').AsInteger;

    aData.aClientID := Main.GetCurrentUser.sId;
    aData.aCodeBrand := fCode + '_' + fBrand;
    aData.aCheckOrderOnly := fCheckOrderOnly;

    (Sender as TTaskF7).SetTaskData(aData);
    aCanRun := True;
  end;
  fCheckOrderOnly := False;
end;

procedure TQuantityEdit.TaskF7AfterEnd(Sender: TObject);
var
  aTask: TTaskF7;
  sValue: string;
begin
  if not Self.Showing then
    Exit;
    
  if Sender is TTaskF7 then
  begin
    aTask := Sender as TTaskF7;

    Main.TimerAskQuants.Enabled := True;

    SendAckQuants.Visible := True;
    SendAckQuantsOrder.Visible := True;
    animWait.Animate := False;
    animWait.Visible := False;

    if not aTask.HasResult then
    begin
      if aTask.GetErrorText <> '' then
        MessageDlg(aTask.GetErrorText, mtError, [mbOK], 0);

      Label4.Caption := '';
      Label4.Visible := False;
      Exit;
    end;


    sValue := aTask.GetResult;
    if sValue = '-1' then
    begin
      Label4.Caption := '';
      Label4.Visible := False;

      MessageDlg('Сервер временно недоступен! Повторите попытку по позже.', mtError, [mbOK], 0);
      Exit;
    end;

    if sValue <> '' then
    begin
      if sValue = '-2' then
        if aTask.GetTaskData.aCheckOrderOnly then
          Label4.Caption := 'Не заказано'
        else
          Label4.Caption := 'Не возим'
      else
      begin
        if aTask.GetTaskData.aCheckOrderOnly then
          Label4.Caption := sValue
        else
          if Length(sValue) < 5 then
            Label4.Caption := 'Доступно: ' + sValue
          else
            Label4.Caption := sValue;
      end;
      Label4.Visible := True;
    end
    else
      Label4.Visible := False;
  end;
end;

end.

