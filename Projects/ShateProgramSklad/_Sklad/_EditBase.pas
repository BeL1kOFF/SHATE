unit _EditBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, _Data, Buttons;

type
    TEditBase = class(TForm)
    Label1: TLabel;
    TextCode: TEdit;
    Label2: TLabel;
    TextName: TEdit;
    Label3: TLabel;
    TextSystemName: TEdit;
    Label4: TLabel;
    TextFileName: TEdit;
    Cancel: TBitBtn;
    Save: TBitBtn;
    Label5: TLabel;
    EdClient: TEdit;
    procedure CancelClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure CancelKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TextCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TextNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdClientKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TextSystemNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TextFileNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
  public
    iGlobalCode:integer;
  end;

var
  EditBase: TEditBase;

implementation
uses _BasesProperties;
{$R *.dfm}

procedure TEditBase.CancelClick(Sender: TObject);
begin
  Close;
end;


procedure TEditBase.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin
inherited;
end;

procedure TEditBase.CancelKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_ESCAPE then Close;

end;

procedure TEditBase.EdClientKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_ESCAPE then Close;
end;

procedure TEditBase.SaveClick(Sender: TObject);
var
   iCode:integer;
begin
  if Length(TextCode.Text) > 7 then
    begin
       MessageDlg('Слишком длинный код!', mtError, [mbOK], 0);
       exit;
    end;

    try
       iCode := StrToInt(TextCode.Text);
     except
        begin
         MessageDlg('В поле код введено не целое число!', mtError, [mbOK], 0);
         exit;
       end;
    end;

    if (Length(EdClient.Text) < 1)or(Length(TextName.Text) < 1) or (Length(TextCode.Text) < 1)or (Length(TextSystemName.Text) < 1)or (Length(TextFileName.Text) < 1) then
    begin
       MessageDlg('Введены не все параметры!', mtError, [mbOK], 0);
       exit;
    end;     


    with Data.TableBases do
    begin
        if iGlobalCode < 1 then
        begin
             BasesProperties.Query.SQL.Clear;
             BasesProperties.Query.SQL.Add('SELECT MAX(ID) as ID FROM [090]');
             BasesProperties.Query.ExecSQL;
             iGlobalCode := BasesProperties.Query.FieldByName('ID').AsInteger + 1;
             BasesProperties.Query.Close;
             if iGlobalCode < 1 then
              iGlobalCode := 1;
              Append;
              FieldByName('ID').Value := iGlobalCode;

        end
        else
         Edit;
         FieldByName('Code').Value := iCode;
         FieldByName('Name').Value := TextName.Text;
         FieldByName('MaskName').Value := TextSystemName.Text;
         FieldByName('FileName').Value := TextFileName.Text;
         FieldByName('Client').Value := EdClient.Text;
         FieldByName('Activate').Value := 1;
         Post;
         Update;
    end;
    
  Close;
end;

procedure TEditBase.TextCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      if Key = VK_ESCAPE then Close;
end;

procedure TEditBase.TextFileNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_ESCAPE then Close;
end;

procedure TEditBase.TextNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Key = VK_ESCAPE then Close;
end;

procedure TEditBase.TextSystemNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_ESCAPE then Close;
end;

end.
