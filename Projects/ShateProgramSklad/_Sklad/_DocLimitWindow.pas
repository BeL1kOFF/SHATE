unit _DocLimitWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, _Data, Buttons;

type
  TDocLimitWindow = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    EdCode: TEdit;
    EdBrand: TEdit;
    EdOldValue: TEdit;
    EdNewValue: TEdit;
    EdDescription: TEdit;
    Label5: TLabel;
    procedure BitBtnCancelClick(Sender: TObject);
    procedure BitBtnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BitBtnCancelKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdNewValueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SaveValue();
  private

    { Private declarations }
  public
    GlobalID:integer;
    sDocLimitBrand, sDocLimitCode, sLimitNew,sLimitOld:string;

    { Public declarations }
  end;

var
  DocLimitWindow: TDocLimitWindow;

implementation

{$R *.dfm}

procedure TDocLimitWindow.BitBtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TDocLimitWindow.BitBtnCancelKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      if Key = VK_ESCAPE then
      Close;
end;

procedure TDocLimitWindow.BitBtnOkClick(Sender: TObject);
begin
    SaveValue();
end;

procedure TDocLimitWindow.EdNewValueKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      if Key = VK_ESCAPE then
      Close;
      if Key = VK_RETURN then
      SaveValue();
end;

procedure TDocLimitWindow.FormActivate(Sender: TObject);
begin
       Color := Data.ParamTable.FieldByName('ColorLimit').AsInteger;
end;

procedure TDocLimitWindow.SaveValue();
var lastNum:integer;
begin
  try
      StrToInt(EdNewValue.Text);
  except
    MessageDlg('¬ведено не целое число "'+EdNewValue.Text+'"', mtInformation, [mbOk],0);
    exit;
  end;

  if EdOldValue.Text <> EdNewValue.Text then
  begin

     with Data.TableDocLimit do
      begin
         if FieldByName('DocLimitID').AsInteger < 1 then
         begin
         Last;
         Append;
         FieldByName('Date').Value   := Now;
         FieldByName('State').Value := 0;
         Post;
         end;
      end;


      with Data.TableDocLimitDet do
      begin
         if Locate('Code;Brand', VarArrayOf([EdCode.Text, EdBrand.Text]), []) then
          begin
          Edit;
          FieldByName('NewValue').AsInteger :=  StrToInt(EdNewValue.Text);
          Post;
          end
          else
          begin
          Last;
          LastNum := FieldByName('ID').AsInteger;
          LastNum := LastNum+1;
          Append;
          FieldByName('ID').Value :=  LastNum;
          FieldByName('Code').Value :=  EdCode.Text;
          FieldByName('Brand').Value :=  EdBrand.Text;
          FieldByName('NewValue').Value :=  StrToInt(EdNewValue.Text);
          FieldByName('OldValue').Value :=  StrToInt(EdOldValue.Text);
          FieldByName('DocLimitID').Value :=  Data.TableDocLimit.FieldByName('DocLimitID').AsInteger;
          FieldByName('Description').Value :=  EdDescription.Text;
          Post;
          end;

      end;


  end;
  Close;
end;

end.
