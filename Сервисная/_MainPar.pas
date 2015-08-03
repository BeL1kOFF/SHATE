unit _MainPar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BSDlgFrm, JvComponentBase, JvFormPlacement, StdCtrls, DBCtrls,
  Buttons, Mask, ExtCtrls, DB, JvExMask, JvToolEdit, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, StrUtils,
  BSStrUt;

type
  TMainParam = class(TDialogForm)
    Label1: TLabel;
    Bevel1: TBevel;
    ShowStartCheckBox: TDBCheckBox;
    FormStorage: TJvFormStorage;
    Label7: TLabel;
    Bevel3: TBevel;
    Label17: TLabel;
    IdHTTP1: TIdHTTP;
    ClIDEd: TEdit;
    Profit_edit: TEdit;
    BitBtn4: TBitBtn;
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    EURRateEd: TDBEdit;
    EUR_USDEd: TDBEdit;
    UpdateSite: TBitBtn;
    EUR_RUBEd: TDBEdit;
    Bevel2: TBevel;
    Label5: TLabel;
    Disc_Edit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure RateEdKeyPress(Sender: TObject; var Key: Char);
    procedure UpdateSiteClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure Disc_EditKeyPress(Sender: TObject; var Key: Char);
    procedure Profit_editKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainParam: TMainParam;

implementation

uses _ClIDs, _Data, _Main, _ClIDEd;

{$R *.dfm}

procedure TMainParam.BitBtn1Click(Sender: TObject);
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

procedure TMainParam.RateEdKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key = ',') and (Pos(',', (Sender as TDBEdit).Text)>0) then
    Key := #0;
end;

procedure TMainParam.UpdateSiteClick(Sender: TObject);
var email:string;
    F: TextFile;
    Path:string;
    TCPClient:TIdTCPClient;
    s:string;
    sDateKurses:string;
    sOldEur, sOldUsd, sOldRub: string;
begin
   inherited;
   TCPClient := TIdTCPClient.Create(nil);
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
     Main.SetImageByLight(Main.INDEX_OF_RATES, True);
   end
   else
     MessageDlg('Не удалось пересчитать цены!', mtInformation, [mbOK], 0);
end;

procedure TMainParam.BitBtn4Click(Sender: TObject);
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

procedure TMainParam.Disc_EditKeyPress(Sender: TObject; var Key: Char);
begin
//   Char
  if not (Key in ['0'..'9', #13,#27, #8, '.',',']) then
            Key := #0;
end;

procedure TMainParam.FormCreate(Sender: TObject);
var
  sFilter:string;
begin
  inherited;
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
end;

procedure TMainParam.FormShow(Sender: TObject);
begin
  inherited;
  SetWindowPos(Handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
end;

procedure TMainParam.OkBtnClick(Sender: TObject);
var sFilter:string;
begin
  inherited;

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







  Close;
end;

procedure TMainParam.Profit_editKeyPress(Sender: TObject; var Key: Char);
begin
    if not (Key in ['0'..'9', #13,#27, #8, '.',',']) then
            Key := #0;
end;

end.
