unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls 
  ,UnitExportsManager;

type
  TForm5 = class(TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    Button1: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

function testEmailAdress(email:string; var sel0, sell: integer):boolean;
var i:integer;
     namePart, serverPart: string;
begin

    Result:= false;
    for i:= 1 to Length(email) do
     begin
       if not (email[i] in ['a'..'z', 'A'..'Z', '0'..'9', '_', '-', '.','@']) then
          begin
           sel0:=i; sell:=-1;
           Exit;
          end;
     end;

  sel0:=0; sell:=Length(email);

  i:= Pos('@', email);
  if i = 0 then
      Exit;

  sel0:=i; sell:=-1;

  namePart:= Copy(email, 1, i - 1);

  serverPart:= Copy(email, i + 1, Length(email));

  if (Length(namePart) = 0) or ((Length(serverPart) < 1)) then
      Exit;

i:= Pos('.', serverPart);
sel0:=sel0+i; sell:=-1;
if (i < 2) or (i > (Length(serverPart) - 1)) then
begin
   Exit;
end;
Result:= True;

end;



procedure SelLine(Memo: TMemo; Index: integer);
begin
  with Memo do
    begin
      SelStart := Perform(EM_LINEINDEX, Index, 0);
      SelLength := Length(Lines[Index]);
      SetFocus;
    end;
end;
procedure TForm5.Button1Click(Sender: TObject);
var email: string;
    sel0, sell: integer;
begin
  email:= trim(self.Edit1.Text);
  if testEmailAdress(email,sel0,sell) then
   begin
    if Memo1.Lines.IndexOf(email)>=0 then
     if MessageDlg('Указанный адрес уже имеется среди адресов рассылки. Продублировать?',mtConfirmation,mbYesNo,0)<>mrYes then exit;
    Memo1.Lines.Add(email);
   end
   else
   begin
    MessageDlg('Неверный формат электронного адреса',mtError,[mbAbort],0);
    self.Edit1.SetFocus;
    self.Edit1.SelStart:=sel0;
    self.Edit1.SelLength:=sell;
   end;
end;

procedure TForm5.Button2Click(Sender: TObject);
var index: integer;
begin
  //if not Memo1.Focused then exit;

  index:= Memo1.Perform(EM_LINEFROMCHAR, -1, 0);
  if (index<0) then exit;// and (index<self.Memo1.Lines.Count)

  self.Memo1.Lines.Delete(index);
end;

procedure TForm5.FormActivate(Sender: TObject);
begin
  self.Memo1.Lines.DelimitedText := StringReplace(Manager.ExportsTbl.FieldByName('email').AsString,',',';',[rfReplaceAll]);
end;

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if self.ModalResult<>mrOk then exit;
  Manager.ExportsTbl.Edit;
  Manager.ExportsTbl.FieldByName('email').Value := Memo1.Lines.DelimitedText;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  self.Memo1.Lines.Delimiter := ';';

  Self.Caption := 'Адреса для рассылки';
  self.Button1.Caption := 'Добавить e-mail';
  self.Button2.Caption := 'Удалить e-mail';

  self.Edit1.Clear;
end;

procedure TForm5.Memo1Click(Sender: TObject);
var lineno: integer;
begin
  lineno := Memo1.Perform(EM_LINEFROMCHAR, -1, 0);
  SelLine(self.Memo1, lineno);
  self.Edit1.Text := self.Memo1.Lines[Memo1.Perform(EM_LINEFROMCHAR, -1, 0)];
end;

end.
