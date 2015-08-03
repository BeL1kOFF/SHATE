unit _Param;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BSDlgFrm, ComCtrls, StdCtrls, Buttons, ExtCtrls, Placemnt,
  JvComponentBase, JvFormPlacement, AdvPageControl, Mask, DBCtrls, JvExMask,
  JvToolEdit, DB, AdvEdit, DBAdvEd, AdvOfficeStatusBarStylers, AdvAppStyler,
  AdvToolBarStylers, AdvMenuStylers, AdvOfficePagerStylers, AdvStyleIF,
  JvExStdCtrls, JvDBCombobox, GridsEh, DBGridEh, JvPageList, JvExControls,
  JvExComCtrls, JvPageListTreeView, BSStrUt, ActnList, BSDbiUt, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, JvDBCheckBox, dbisamtb;

type
  TParam = class(TDialogForm)
    FormStorage: TJvFormStorage;
    FormStyler: TAdvFormStyler;
    PageListTreeView: TJvPageListTreeView;
    Pager: TJvPageList;
    MainPage: TJvStandardPage;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label17: TLabel;
    ShowStartCheckBox: TDBCheckBox;
    EMailPage: TJvStandardPage;
    Label6: TLabel;
    ShateEmailEd: TDBAdvEdit;
    TextAttrPage: TJvStandardPage;
    Label11: TLabel;
    Label12: TLabel;
    SaleTextEd: TJvComboEdit;
    TextAttrGrid: TDBGridEh;
    AddTextAttrBtn: TBitBtn;
    DelTextAttrBtn: TBitBtn;
    EditTextAttrBtn: TBitBtn;
    OtherPage: TJvStandardPage;
    Label10: TLabel;
    FiltComboBox: TJvDBComboBox;
    ActionList: TActionList;
    AddTextAttrAction: TAction;
    DelTextAttrAction: TAction;
    EditTextAttrAction: TAction;
    Label13: TLabel;
    NoPresentEd: TJvComboEdit;
    QCellCheckBox: TDBCheckBox;
    Bevel4: TBevel;
    SCellCheckBox: TDBCheckBox;
    Label14: TLabel;
    NetIntervEd: TDBEdit;
    Label15: TLabel;
    CliIdModeComboBox: TJvDBComboBox;
    TCPDirectCheckBox: TDBCheckBox;
    ToForbidRemovalOrder: TDBCheckBox;
    DBCheckBox1: TDBCheckBox;
    Label19: TLabel;
    Proxy: TJvStandardPage;
    Label20: TLabel;
    DBEdit_ProxySRV: TDBEdit;
    DBCheckBox_UseProxy: TDBCheckBox;
    DBEdit_ProxyPort: TDBEdit;
    Label21: TLabel;
    DBCheckBox_UseProxyAutoresation: TDBCheckBox;
    Label22: TLabel;
    DBEdit_ProxyUser: TDBEdit;
    DBEdit_ProxyPassword: TDBEdit;
    Label23: TLabel;
    BitBtn1: TBitBtn;
    DBCheckBox2: TDBCheckBox;
    ClIDEd: TEdit;
    BitBtn2: TBitBtn;
    UpdatePager: TJvStandardPage;
    PasiveUpdate: TJvDBCheckBox;
    PasiveUpdateProg: TJvDBCheckBox;
    PasiveUpdateQuants: TJvDBCheckBox;
    UpdateActions: TJvDBComboBox;
    Label24: TLabel;
    UpdateActionsQuants: TJvDBComboBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    JvComboEdit1: TJvComboEdit;
    ColorDialog: TColorDialog;
    DBCheckBox6: TDBCheckBox;
    JvDBCheckBox1: TJvDBCheckBox;
    cbHideUpdateReport: TJvDBCheckBox;
    Profit_edit: TEdit;
    TestQuery: TDBISAMQuery;
    BitBtn4: TBitBtn;
    DBCheckBox8: TDBCheckBox;
    DBCheckBox9: TDBCheckBox;
    TcpPage: TJvStandardPage;
    lbTitle: TLabel;
    DBCheckBox10: TDBCheckBox;
    Label18: TLabel;
    DBEdit2: TDBEdit;
    Label29: TLabel;
    btConfigRounding: TBitBtn;
    Label31: TLabel;
    Label32: TLabel;
    DBCheckBox13: TDBCheckBox;
    DBEdit4: TDBEdit;
    DBCheckBox14: TDBCheckBox;
    cbWarnOrderLimits: TDBCheckBox;
    SetDateRate: TDBEdit;
    Label33: TLabel;
    lbTvr: TLabel;
    LocalMode: TDBCheckBox;
    DBCheckBox15: TDBCheckBox;
    Label34: TLabel;
    DBEdit5: TDBEdit;
    Label35: TLabel;
    DBCheckBox12: TDBCheckBox;
    Label25: TLabel;
    DBEdit3: TDBEdit;
    Label30: TLabel;
    bCloseDialog: TDBCheckBox;
    DBCheckBox11: TDBCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    EURRateEd: TDBEdit;
    EUR_USDEd: TDBEdit;
    EUR_RUBEd: TDBEdit;
    Disc_Edit: TEdit;
    Label5: TLabel;
    Label7: TLabel;
    DBEdit1: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    Label16: TLabel;
    Label28: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    DBEdit11: TDBEdit;
    Label40: TLabel;
    DBCheckBox16: TDBCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure ClIDEdButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TextAttrActionExecute(Sender: TObject);
    procedure TextAttrGridGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure SaleTextEdButtonClick(Sender: TObject);
    procedure NoPresentEdButtonClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure RateEdKeyPress(Sender: TObject; var Key: Char);
    procedure ProxyShow(Sender: TObject);
    procedure VisibleUpdate;
    procedure DBCheckBox_UseProxyClick(Sender: TObject);
    procedure DBCheckBox_UseProxyAutoresationClick(Sender: TObject);
    procedure UpdateSiteClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure PasiveUpdateChange(Sender: TObject);
    procedure UpdatePagerShow(Sender: TObject);
    procedure JvComboEdit1ButtonClick(Sender: TObject);
    procedure JvComboEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure Disc_EditKeyPress(Sender: TObject; var Key: Char);
    procedure Profit_editKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn4Click(Sender: TObject);
    procedure DBCheckBox8Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PageListTreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure btConfigRoundingClick(Sender: TObject);
    procedure lbTvrClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    aVIPCode: string;
    fLatestKeyPress: Cardinal;
  public
    { Public declarations }
    fRestart : boolean;
  end;

var
  Param: TParam;
  OldLocalMode : boolean;

implementation

uses
  _Main, _Data, _ClIDs, _TxtAttr, _QTxAttr, VCLUtils, _ClIDEd,
  _ConfigRoundingForm, _CommonTypes;

{$R *.dfm}

procedure TParam.VisibleUpdate;
begin
    if not DBCheckBox_UseProxy.Checked then
  begin
    DBEdit_ProxySRV.Visible :=false;
    DBCheckBox_UseProxyAutoresation.Visible  := FALSE;
    Label20.Visible:=false;
    DBEdit_ProxyPort.Visible :=false;
    Label21.Visible:=false;
    DBEdit_ProxyUser.Visible :=false;
    Label22.Visible:=false;
    DBEdit_ProxyPassword.Visible :=false;
    Label23.Visible:=false;
  end
  else
  begin
    DBEdit_ProxySRV.Visible :=TRUE;
    Label20.Visible:=TRUE;
    DBEdit_ProxyPort.Visible :=TRUE;
    DBCheckBox_UseProxyAutoresation.Visible  := TRUE;
    Label21.Visible:=TRUE;
    if not DBCheckBox_UseProxyAutoresation.Checked then
    begin
      DBEdit_ProxyUser.Visible :=FALSE;
      Label22.Visible:=FALSE;
      Label23.Visible:=FALSE;
      DBEdit_ProxyPassword.Visible :=FALSE;
    end       
    else
    begin
      DBEdit_ProxyUser.Visible :=TRUE;
      DBEdit_ProxyPassword.Visible :=TRUE;
      Label22.Visible:=TRUE;
      Label23.Visible:=TRUE;
    end;
  end;

  if PasiveUpdate.Checked then
  begin
    PasiveUpdateProg.Visible := TRUE;
    PasiveUpdateQuants.Visible := TRUE;
    PasiveUpdateProg.Visible := TRUE;
    UpdateActionsQuants.Visible := TRUE;
    UpdateActions.Visible := TRUE;
    Label24.Visible := TRUE;
  end
  else
  begin
    UpdateActionsQuants.Visible := FALSE;
    UpdateActions.Visible := FALSE;
    PasiveUpdateProg.Visible := FALSE;
    PasiveUpdateProg.Checked := FALSE;
        PasiveUpdateQuants.Checked := FALSE;
    PasiveUpdateQuants.Visible := FALSE;
    UpdateActionsQuants.Visible := FALSE;
    Label24.Visible := FALSE;    
  end
end;

procedure TParam.OkBtnClick(Sender: TObject);
var
  sFilter:string;
begin
  inherited;
  {$IFDEF LOCAL}
  fRestart := OldLocalMode <> data.ParamDataSource.DataSet.FieldByName('LocalMode').AsBoolean;
  {$ENDIF}
  with Data.ClIDsTable do
      begin
        First;
        Locate('ByDefault', 1, []);
        CLIDEd.Text := FieldByName('Client_id').AsString;
      end;

   sFilter := Main.ReplaceLeftSymbol(CLIDEd.Text);
   if Length(sFilter) > 3 then
   begin
     with Data.DiscountTable do
      begin
          DisableControls;
          if IndexName <> 'CLI' then
            IndexName := 'CLI';


          SetRange([sFilter], [sFilter]);
          sFilter := 'GR_ID = 0 AND SUBGR_ID = 0 AND BRAND_ID = 0';
          Filter := sFilter;
          Filtered := TRUE;
          if EOF then
            begin
               Append;
               FieldByName('CLI_ID').AsString := Main.ReplaceLeftSymbol(CLIDEd.Text);
               FieldByName('GR_ID').AsInteger := 0;
               FieldByName('SUBGR_ID').AsInteger := 0;
               FieldByName('BRAND_ID').AsInteger := 0;
               if length(Disc_Edit.Text) >0 then
                 FieldByName('Discount').AsFloat := Main.AToFloat(Disc_Edit.Text);
               if length(Profit_edit.Text) >0 then
                 FieldByName('Margin').AsFloat := Main.AToFloat(Profit_edit.Text);
               FieldByName('bDelete').AsInteger := 0;
               Post;
            end
          else
            begin
               Edit;
               if length(Disc_Edit.Text)>0 then
                FieldByName('Discount').AsFloat := Main.AToFloat(Disc_Edit.Text)
               else
                FieldByName('Discount').AsFloat := 0;


               if length(Profit_edit.Text) >0 then
                FieldByName('Margin').AsFloat := Main.AToFloat(Profit_edit.Text)
               else
                FieldByName('Margin').AsFloat := 0;
               Post;
            end;
          EnableControls;
      end;
   end
   else
   begin
       Profit_edit.ReadOnly := TRUE;
       Disc_Edit.ReadOnly := TRUE;
   end;

     
  with Data.ParamTable do
  begin
    Edit;
    FieldByName('Sale_backgr').Value := SaleTextEd.Color;
    FieldByName('Sale_font').Value := FontToStr(SaleTextEd.Font);
    FieldByName('Noquant_backgr').Value := NoPresentEd.Color;
    FieldByName('Noquant_font').Value := FontToStr(NoPresentEd.Font);
    FieldByName('ColorRunString').Value := JvComboEdit1.Color;
    Post;
  end;
  if Data.SysParamTable.State = dsEdit then
    Data.SysParamTable.Post;
  with Data.TextAttrTable do
  begin
    EmptyTable;
    Open;
  end;
  with Data.MTextAttrTable do
  begin
    First;
    while not Eof do
    begin
      Data.TextAttrTable.Append;
      CopyRecord(Data.MTextAttrTable, Data.TextAttrTable);
      Data.TextAttrTable.Post;
      Next;
    end;
  end;
  Data.TextAttrTable.Close;
end;

procedure TParam.PageListTreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  if Assigned(Node) then
    lbTitle.Caption := Node.Text;
end;

procedure TParam.PasiveUpdateChange(Sender: TObject);
begin
  inherited;
  //sdfhasjklhf
  VisibleUpdate;
  {if PasiveUpdate.Checked then
  begin
    PasiveUpdateProg.Visible := TRUE;
    PasiveUpdateQuants.Visible := TRUE;
    PasiveUpdateProg.Checked  := TRUE;
    PasiveUpdateProg.Visible := TRUE;
    PasiveUpdateQuants.Checked := TRUE;
    UpdateActionsQuants.Visible := TRUE;
    UpdateActions.Visible := TRUE;
    Label24.Visible := TRUE;
  end
  else
  begin
    UpdateActionsQuants.Visible := FALSE;
    UpdateActions.Visible := FALSE;
    PasiveUpdateProg.Visible := FALSE;
    PasiveUpdateQuants.Visible := FALSE;
    UpdateActionsQuants.Visible := FALSE;
    Label24.Visible := FALSE;
  end           }
end;

procedure TParam.Profit_editKeyPress(Sender: TObject; var Key: Char);
begin
    if not (Key in ['0'..'9', #13,#27, #8, '.',',', '-']) then
            Key := #0;
end;

procedure TParam.ProxyShow(Sender: TObject);
begin
  inherited;
  VisibleUpdate;
end;

procedure TParam.SaleTextEdButtonClick(Sender: TObject);
begin
  inherited;
  with TTextAttr.Create(Application) do
  begin
    with Data.ParamTable do
    begin
      Memo.Color := FieldByName('Sale_BackGr').AsInteger;
      Memo.Font  := StrToFont(FieldByName('Sale_Font').AsString);
      if ShowModal = mrOk then
      begin
        SaleTextEd.Color := Memo.Color;
        SaleTextEd.Font.Assign(Memo.Font);
      end;
    end;
    Free;
  end;
end;

procedure TParam.TextAttrActionExecute(Sender: TObject);
begin
  inherited;
  if Sender = AddTextAttrAction then
  begin
    with TQuantTextAttr.Create(Application) do
    begin
      with Data.MTextAttrTable do
      begin
        if ShowModal = mrOk then
        begin
          Append;
          FieldByName('Lo').Value := LoEd.Value;
          FieldByName('Hi').Value := HiEd.Value;
          FieldByName('BackGround').Value := Memo.Color;
          FieldByName('Font').Value := FontToStr(Memo.Font);
          Post;
        end;
      end;
      Free;
    end;                                          
  end
  else if Sender = DelTextAttrAction then
  begin
    if (MessageDlg('Удалить? Вы уверены?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      Data.MTextAttrTable.Delete;
  end
  else if Sender = EditTextAttrAction then
  begin
    with TQuantTextAttr.Create(Application) do
    begin
      with Data.MTextAttrTable do
      begin
        LoEd.Value := FieldByName('Lo').AsInteger;
        HiEd.Value := FieldByName('Hi').AsInteger;
        Memo.Color := FieldByName('BackGround').AsInteger;
        Memo.Font  := StrToFont(FieldByName('Font').AsString);
        if ShowModal = mrOk then
        begin
          Edit;
          FieldByName('Lo').Value := LoEd.Value;
          FieldByName('Hi').Value := HiEd.Value;
          FieldByName('BackGround').Value := Memo.Color;
          FieldByName('Font').Value := FontToStr(Memo.Font);
          Post;
        end;
      end;
      Free;
    end;
  end;
end;


procedure TParam.TextAttrGridGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  inherited;
  with Data.MTextAttrTable do
  begin
    if (FieldByName('Id').AsInteger <> 0) and (Column.FieldName = 'Sample') then
    begin
      Background := FieldByName('Background').AsInteger;
      AFont.Assign(StrToFont(FieldByName('Font').AsString));
    end;
  end;
end;

procedure TParam.UpdatePagerShow(Sender: TObject);
begin
  inherited;
  VisibleUpdate;
end;

procedure TParam.UpdateSiteClick(Sender: TObject);
var email:string;
    F: TextFile;
    Path:string;
    TCPClient:TIdTCPClient;
    s:string;
begin
   inherited;
//   if not Data.HostProtection then
//     exit;

   TCPClient:= TIdTCPClient.Create(nil);
   Path := ExtractFilePath(Forms.Application.ExeName) + 'Импорт\';
   DeleteFile(Path+'USDXEUR.csv');
   DeleteFile(Path+'BYRXEUR.csv');

   try
     if not Main.DoTcpConnect(TCPClient, True, True) then
       Exit;

     email := 'STOCK_KURSES_ACK';
     TCPClient.IOHandler.Writeln(email);
     email := TCPClient.IOHandler.ReadLnWait;

     if(email = 'END') then
     begin
       MessageDlg('Курсы не выставленны!', mtInformation, [mbOK], 0);
       TCPClient.Disconnect;
       exit;
     end;

     while email <> 'END' do
     begin
       if email = 'FILE' then
       begin
         email := TCPClient.IOHandler.ReadLnWait;
         AssignFile(F, Path+email);
         Rewrite(F);
       end
       else if email = 'ENDFILE' then
         CloseFile(F)
       else
         System.Writeln(F, email);
       email := TCPClient.IOHandler.ReadLnWait;
     end;

     except
       on e: Exception do
          begin
            MessageDlg('Ошибка: ' + e.Message,mtError,[mbOK],0);
            TCPClient.Disconnect;
             Exit;
          end;
     end;

   if FileExists(Path+'BYRXEUR.csv') then
   begin
      AssignFile(F,Path+'BYRXEUR.csv');
      Reset(F);
      Readln(F,s);

      with Data.ParamTable do
        begin
          Edit;
          FieldByName('Eur_rate').Value := Main.AToFloat(s);
          Post;
        end;
      CloseFile(F);
   end;

   if FileExists(Path+'USDXEUR.csv') then
   begin
      AssignFile(F,Path+'USDXEUR.csv');
      Reset(F);
      Readln(F,s);

      with Data.ParamTable do
        begin
          Edit;
          FieldByName('Eur_usd_rate').Value := Main.AToFloat(s);
          Post;
        end;
      CloseFile(F);
   end;

end;

procedure TParam.BitBtn1Click(Sender: TObject);
var email:string;
    F: TextFile;
    Path:string;
    TCPClient:TIdTCPClient;
    s:string;
    sDateKurses:string;
    sOldEur, sOldUsd, sOldRub: string;
begin
//   if not Data.HostProtection then
//     exit;
   TCPClient:= TIdTCPClient.Create(nil);
   Path := ExtractFilePath(Forms.Application.ExeName) + 'Импорт\';
   DeleteFile(Path+'Rates.csv');

   if not Main.DoTcpConnect(TCPClient, True, True) then
     Exit;

   email := 'STOCK_KURSES_ACK';
   TCPClient.IOHandler.Writeln(email);
   email := TCPClient.IOHandler.ReadLnWait;
   if(email = 'END') then
   begin
     MessageDlg('Не удалось пересчитать цены!', mtInformation, [mbOK], 0);
     TCPClient.Disconnect;
     exit;
   end;

   while email <> 'END' do
   begin
     if email = 'FILE' then
     begin
       email := TCPClient.IOHandler.ReadLnWait;
       AssignFile(F, Path+email);
       Rewrite(F);
     end

     else
     if email = 'ENDFILE' then
     begin
       CloseFile(F);
       sDateKurses := TCPClient.IOHandler.ReadLnWait;
     end

     else
       System.Writeln(F, email);

     email := TCPClient.IOHandler.ReadLnWait;
   end;

   TCPClient.Disconnect;
   if FileExists(Path+'Rates.csv') then
   begin
     AssignFile(F,Path+'Rates.csv');
     Reset(F);
     Readln(F,s);
     with Data.ParamTable do
     begin
       Edit;
       s:= ExtractDelimited(2, s, [';']);
       sOldUsd := FieldByName('Eur_usd_rate').AsString + ' -> ' + FloatToStr(Main.AToFloat(s));
       FieldByName('Eur_usd_rate').Value :=        Main.AToFloat(s);
       Readln(F,s);
       s:= ExtractDelimited(2, s, [';']);
       sOldEur := FieldByName('Eur_rate').AsString + ' -> ' + FloatToStr(Main.AToFloat(s));
       FieldByName('Eur_rate').Value :=        Main.AToFloat(s);
       Readln(F,s);
       s:= ExtractDelimited(2, s, [';']);
       sOldRub := FieldByName('Eur_RUB_rate').AsString + ' -> ' + FloatToStr(Main.AToFloat(s));
       if s <> '' then
          FieldByName('Eur_RUB_rate').Value :=        Main.AToFloat(s);
       Post;
     end;
     CloseFile(F);
     MessageDlg('Цены пересчитаны!', mtInformation, [mbOK], 0);
   end
   else
     MessageDlg('Не удалось пересчитать цены!', mtInformation, [mbOK], 0);
end;

procedure TParam.BitBtn2Click(Sender: TObject);
var sFilter : string;
begin
  inherited;

  with TClientIDs.Create(Application) do
  begin
    MenuMode := True;
    ShowModal;
    Free;
  end;

  with Data.ClIDsTable do
  begin
   First;
   Locate('ByDefault', 1, []);
   CLIDEd.Text := FieldByName('Client_id').AsString;
   Disc_Edit.Enabled := FieldByName('UpdateDisc').AsBoolean;
  end;

  if Length(CLIDEd.Text) > 3 then
  begin
    BitBtn4.Enabled := True;
     Profit_edit.ReadOnly := FALSE;
     Disc_Edit.ReadOnly := FALSE;
     with Data.DiscountTable do
     begin
          DisableControls;
          if IndexName <> 'CLI' then
            IndexName := 'CLI';
          sFilter := Main.ReplaceLeftSymbol(CLIDEd.Text);
          SetRange([sFilter], [sFilter]);
          sFilter := 'GR_ID = 0 AND SUBGR_ID = 0 AND BRAND_ID = 0';
          Filter := sFilter;
          Filtered := TRUE;
          if EOF then
            begin
               Profit_edit.Text := '';
               Disc_Edit.Text := '';
            end
          else
            begin
               Profit_edit.Text := FieldByName('Margin').AsString;
               Disc_Edit.Text := FieldByName('Discount').AsString;
            end;
          EnableControls;
     end;
   end
   else
   begin
     BitBtn4.Enabled := False;
       Profit_edit.Text := '';
       Disc_Edit.Text := '';
       Profit_edit.ReadOnly := TRUE;
       Disc_Edit.ReadOnly := TRUE;
   end;
end;

procedure TParam.BitBtn4Click(Sender: TObject);
var
  sID, sFilter: string;
begin
  inherited;

  sId := Main.ReplaceLeftSymbol(CLIDEd.Text);
  if sID = '' then
    Exit;

  with Main.Table do
  begin
    Open;
    First;
    Locate('CLIENT_ID', sID, []);

    if not EOF then
      begin
         with (TClientIDEdit.Create(Application)) do
           begin
             DataSource := Main.DataSource;
             //ParentForm := Self;
             ShowModal;
             Free;
          end;
      end;
      Disc_Edit.Enabled := FieldByName('UpdateDisc').AsBoolean;
      Close;
  end;

  if Length(CLIDEd.Text) > 3 then
  begin
    BitBtn4.Enabled := True;
     Profit_edit.ReadOnly := FALSE;
     Disc_Edit.ReadOnly := FALSE;
     with Data.DiscountTable do
      begin
          DisableControls;
          if IndexName <> 'CLI' then
            IndexName := 'CLI';
          sFilter := Main.ReplaceLeftSymbol(CLIDEd.Text);
          SetRange([sFilter], [sFilter]);
          sFilter := 'GR_ID = 0 AND SUBGR_ID = 0 AND BRAND_ID = 0';
          Filter := sFilter;
          Filtered := TRUE;
          if EOF then
            begin
               Profit_edit.Text := '';
               Disc_Edit.Text := '';
            end
          else
            begin
               Profit_edit.Text := FieldByName('Margin').AsString;
               Disc_Edit.Text := FieldByName('Discount').AsString;
            end;

          EnableControls;
      end;
   end
   else
   begin
     BitBtn4.Enabled := False;
       Profit_edit.Text := '';
       Disc_Edit.Text := '';
       Profit_edit.ReadOnly := TRUE;
       Disc_Edit.ReadOnly := TRUE;
   end;
end;

procedure TParam.btConfigRoundingClick(Sender: TObject);
var
  i: TCurrencyType;
  aRounding: TCurrencyRounding;
begin
  inherited;
  with TConfigRoundingForm.Create(Self) do
  try
    Data.LoadCurrencyRounding(aRounding);

    for i := Low(TCurrencyType) to High(TCurrencyType) do
      SetParams(i, aRounding[i]);

    if ShowModal = mrOK then
    begin
      for i := Low(TCurrencyType) to High(TCurrencyType) do
        aRounding[i] := GetParams(i);

      Data.SaveCurrencyRounding(aRounding);
    end;
    
  finally
    Free;
  end;
end;

procedure TParam.CancelBtnClick(Sender: TObject);
begin
  inherited;
  Data.SysParamTable.Cancel;
end;

procedure TParam.ClIDEdButtonClick(Sender: TObject);
begin
  inherited;
  with TClientIDs.Create(Application) do
  begin
    MenuMode := True;
    if ShowModal = mrOk then
      ClIDEd.Text := Table.FieldByName('Client_Id').AsString;
    Free;
  end
end;

procedure TParam.DBCheckBox8Click(Sender: TObject);
begin
  inherited;
  DBCheckBox9.Enabled := DBCheckBox8.Checked;
end;

procedure TParam.DBCheckBox_UseProxyAutoresationClick(Sender: TObject);
begin
  inherited;
  VisibleUpdate;
end;

procedure TParam.DBCheckBox_UseProxyClick(Sender: TObject);
begin
  inherited;
  VisibleUpdate;
end;

procedure TParam.Disc_EditKeyPress(Sender: TObject; var Key: Char);
begin
    if not (Key in ['0'..'9', #13,#27, #8, '.',',']) then
            Key := #0;

end;

procedure TParam.RateEdKeyPress(Sender: TObject; var Key: Char);
begin
{
  if (Key = ',') or (Key = '.') then
    Key := DecimalSeparator;
}    
    
  if (Key = DecimalSeparator) and (Pos(DecimalSeparator, (Sender as TDBEdit).Text) > 0) then
    Key := #0;
end;

procedure TParam.FormCreate(Sender: TObject);
var
  i: Integer;
   sFilter:string;
begin
  inherited;
  fRestart := False;
  DataSource := Data.ParamDataSource;
  with Data.ClIDsTable do
  begin
    First;
    Locate('ByDefault', 1, []);
    CLIDEd.Text := FieldByName('Client_id').AsString;
    Disc_Edit.Enabled := FieldByName('UpdateDisc').AsBoolean;
  end;

   if Length(CLIDEd.Text) > 3 then
   begin
     BitBtn4.Enabled := True;
     Profit_edit.ReadOnly := FALSE;
     Disc_Edit.ReadOnly := FALSE;
     with Data.DiscountTable do
      begin
          DisableControls;
          if IndexName <> 'CLI' then
            IndexName := 'CLI';
          sFilter := Main.ReplaceLeftSymbol(CLIDEd.Text);
          SetRange([sFilter], [sFilter]);
          sFilter := 'GR_ID = 0 AND SUBGR_ID = 0 AND BRAND_ID = 0';
          Filter := sFilter;
          Filtered := TRUE;
          if EOF then
            begin
               Profit_edit.Text := '';
               Disc_Edit.Text := '';
            end
          else
            begin
               Profit_edit.Text := FieldByName('Margin').AsString;
               Disc_Edit.Text := FieldByName('Discount').AsString;
            end;
          EnableControls;
      end;
   end
   else
   begin
     BitBtn4.Enabled := False;
       Profit_edit.Text := '';
       Disc_Edit.Text := '';
       Profit_edit.ReadOnly := TRUE;
       Disc_Edit.ReadOnly := TRUE;
   end;


  Data.TextAttrTable.CopyTable('Memory', 'Text_Attr');
  Data.MTextAttrTable.Open;
  with PageListTreeView do
    for i := 0 to Items.Count - 1 do
      TJvPageIndexNode(Items[i]).PageIndex := i;
  SaleTextEd.Color  := Data.ParamTable.FieldByName('Sale_BackGr').AsInteger;
  SaleTextEd.Font.Assign(StrToFont(Data.ParamTable.FieldByName('Sale_Font').AsString));
  NoPresentEd.Color := Data.ParamTable.FieldByName('NoQuant_BackGr').AsInteger;
  NoPresentEd.Font.Assign(StrToFont(Data.ParamTable.FieldByName('NoQuant_Font').AsString));
  JvComboEdit1.Color :=  Data.ParamTable.FieldByName('ColorRunString').AsInteger;

  {$IFDEF LOCAL}    // блокировка обновлений при Режиме сохранения данных

  OldLocalMode := data.ParamDataSource.DataSet.FieldByName('LocalMode').AsBoolean;
  if OldLocalMode then
  begin
    Data.ParamDataSource.DataSet.Edit;
    Data.ParamDataSource.DataSet.FieldByName('iUpdateTypeLoad').AsInteger := 1;
    Data.ParamDataSource.DataSet.Post;
    UpdateActions.Enabled := False;
    PasiveUpdateProg.Enabled := False;
  end;
  {$ENDIF}

  {$IFDEF ADMINMODE}
    LocalMode.Enabled := True;
  {$ENDIF}

end;

procedure TParam.FormDestroy(Sender: TObject);
begin
  inherited;
  Data.MTextAttrTable.Close;
  Data.MTextAttrTable.DeleteTable;
end;

procedure TParam.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (ssCtrl in Shift) and (Pager.ActivePage = OtherPage) then
    lbTvr.Visible := True;
end;

procedure TParam.FormKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if (GetKeyState(VK_SHIFT) and 128) <> 0 then
  begin
    if (GetTickCount - fLatestKeyPress) > 1500 then
      aVIPCode := '';
    fLatestKeyPress := GetTickCount;
    
    aVIPCode := aVIPCode + Key;
    if AnsiUpperCase(aVIPCode) = 'VIPCFG' then
    begin
      cbWarnOrderLimits.Visible := True;
    end;
  end;
end;

procedure TParam.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if not (ssCtrl in Shift) then
    lbTvr.Visible := False;
end;

procedure TParam.FormShow(Sender: TObject);
begin
  inherited;
  DBCheckBox9.Enabled := DBCheckBox8.Checked;
  lbTvr.Visible := False;
  cbWarnOrderLimits.Visible := False;
  {$IFDEF LOCAL}    // блокировка обновлений при Режиме сохранения данных
    if Data.ParamTable.FieldByName('LocalMode').AsBoolean then
      PageListTreeView.Items.Item[4].Delete;
  {$ENDIF}
end;

procedure TParam.JvComboEdit1ButtonClick(Sender: TObject);
begin
  inherited;
  ColorDialog.Color := JvComboEdit1.Color;
  if ColorDialog.Execute then
    JvComboEdit1.Color := ColorDialog.Color;
end;

procedure TParam.JvComboEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  Key := #0; 
end;

procedure TParam.lbTvrClick(Sender: TObject);
begin
  inherited;
  Main.RunTVSupport;
end;

procedure TParam.NoPresentEdButtonClick(Sender: TObject);
begin
  inherited;
  with TTextAttr.Create(Application) do
  begin
    with Data.ParamTable do
    begin
      Memo.Color := FieldByName('NoQuant_BackGr').AsInteger;
      Memo.Font.Assign(StrToFont(FieldByName('NoQuant_Font').AsString));
      if ShowModal = mrOk then
      begin
        NoPresentEd.Color := Memo.Color;
        NoPresentEd.Font.Assign(Memo.Font);
      end;
    end;
    Free;
  end;
end;

end.
