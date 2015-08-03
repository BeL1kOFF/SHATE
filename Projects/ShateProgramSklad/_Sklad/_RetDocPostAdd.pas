unit _RetDocPostAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, _Data, ExtCtrls;

type
  TRetDocPostAdd = class(TForm)
    RetDocPostAdd: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Edit3: TEdit;
    Bevel1: TBevel;
    btOrdersInfo: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btOrdersInfoClick(Sender: TObject);
  private
    { Private declarations }
    procedure OrdersInfoClose(Sender: TObject);
  public
    { Public declarations }

    bNew: Boolean;
    sComments, sCode, sBrend, sDescription: string;
    procedure SaveValue();
    procedure SetParametrValue(const aCode, aBrand, aDescription, aComments: string;
      aCount: Integer; aIsNew: Boolean);
  end;


var
  RetDocPostAdd: TRetDocPostAdd;

implementation

{$R *.dfm}

uses
  _OrderedInfo;

procedure TRetDocPostAdd.BitBtn1Click(Sender: TObject);
var iPos:integer;
begin
  try
      StrToInt(Edit2.Text);
   except
      MessageDlg('Неверно введено колличество!',mtInformation,[mbOk],0);
      exit;
   end;

   if StrToInt(Edit2.Text) < 1 then
   begin
       MessageDlg('Неверно введено колличество!',mtInformation,[mbOk],0);
       exit;
   end;

 if  bNew then
   begin
     with Data.TableReturnDocPost do
     begin
         if FieldByName('RetDocPostID').AsString = '' then
         begin
           Append;
           FieldByName('Data').Value:=Now;
           FieldByName('State').Value:=0;
           Post;
          end;
     end;

      with Data.TableReturnDocPostDet do
         begin
           Last;
           iPos := FieldByName('ID').AsInteger + 1;
           Append;
           FieldByName('ID').Value := iPos;
           FieldByName('Code').Value:=sCode;
           FieldByName('Brand').Value:=sBrend;
           FieldByName('Description').Value:=sDescription;
           FieldByName('Col').Value:=StrToInt(Edit2.Text);
           FieldByName('Comments').Value := Edit3.Text;
           Post;
         end;
   end
   else
   begin
       with Data.TableReturnDocPostDet do
       begin
           Edit;
           FieldByName('Comments').Value := Edit3.Text;
           Post;
       end;
   end;
   Close;
end;

procedure TRetDocPostAdd.BitBtn2Click(Sender: TObject);
begin
    Close;
end;

procedure TRetDocPostAdd.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_ESCAPE then
      Close;

   if Key = VK_RETURN then
      SaveValue;

end;


procedure TRetDocPostAdd.Edit3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
      SaveValue;
end;

procedure TRetDocPostAdd.FormActivate(Sender: TObject);
begin
  Edit1.Text := sCode + ' '+sDescription;
  if Length(Edit2.Text) < 1 then
      Edit2.Text := '0';
  if bNew then
    ActiveControl:=Edit2
  else
    ActiveControl:=Edit3;
  Edit3.Text := sComments;
end;

procedure TRetDocPostAdd.FormCreate(Sender: TObject);
begin
   Edit1.Text := sCode + ' '+sDescription;
   Edit3.Text := sComments;
   if Length(Edit2.Text) < 1 then
      Edit2.Text := '0';

end;


procedure TRetDocPostAdd.SaveValue();

var iPos:integer;
begin
  try
      StrToInt(Edit2.Text);
   except
      MessageDlg('Неверно введено колличество!',mtInformation,[mbOk],0);
      exit;
   end;

   if StrToInt(Edit2.Text) < 1 then
   begin
       MessageDlg('Неверно введено колличество!',mtInformation,[mbOk],0);
       exit;
   end;

 if  bNew then
   begin
     with Data.TableReturnDocPost do
     begin
         if FieldByName('RetDocPostID').AsString = '' then
         begin
           Append;
           FieldByName('Data').Value:=Now;
           FieldByName('State').Value:=0;
           Post;
          end;
     end;

      with Data.TableReturnDocPostDet do
         begin
           Last;
           iPos := FieldByName('ID').AsInteger + 1;
           Append;
           FieldByName('ID').Value := iPos;
           FieldByName('Code').Value:=sCode;
           FieldByName('Brand').Value:=sBrend;
           FieldByName('Description').Value:=sDescription;
           FieldByName('Col').Value:=StrToInt(Edit2.Text);
           FieldByName('Comments').Value := Edit3.Text;
           Post;
         end;
   end
   else
   begin
       with Data.TableReturnDocPostDet do
       begin
           Edit;
           FieldByName('Comments').Value := Edit3.Text;
           Post;
       end;
   end;
   Close;

end;

procedure TRetDocPostAdd.OrdersInfoClose(Sender: TObject);
begin
  Edit2.Text := IntToStr((Sender as TFormOrderedInfo).RetQuantity);
end;

procedure TRetDocPostAdd.SetParametrValue(const aCode, aBrand, aDescription,
  aComments: string; aCount: Integer; aIsNew: Boolean);
begin
  sCode := aCode;
  sBrend := aBrand;
  sDescription := aDescription;
  sComments := aComments;
  bNew := aIsNew;
  Edit2.Text := IntToStr(aCount);
  Edit2.Enabled := aIsNew;
  btOrdersInfo.Enabled := aIsNew;
end;

procedure TRetDocPostAdd.btOrdersInfoClick(Sender: TObject);
begin
  TFormOrderedInfo.Popup(
    sCode,
    sBrend,
    sDescription,
    btOrdersInfo.ClientOrigin.X + btOrdersInfo.Width,
    btOrdersInfo.ClientOrigin.Y + btOrdersInfo.Height,
    OrdersInfoClose,
    False {IsSale}
  );
end;

end.
