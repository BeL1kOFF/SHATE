unit _ReturnDocInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, AdvDateTimePicker, _Data;

type
  TReturnDocInfo = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    DateTimePicker: TAdvDateTimePicker;
    EdComment: TEdit;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
      bNew:bool;
     procedure SetNew(New:bool);
  end;

var
  ReturnDocInfo: TReturnDocInfo;

implementation

{$R *.dfm}

procedure TReturnDocInfo.SetNew(New:bool);
begin
   bNew := New;
end;

procedure TReturnDocInfo.CancelButtonClick(Sender: TObject);
begin
   Close;
end;

procedure TReturnDocInfo.SaveButtonClick(Sender: TObject);
begin
   with  Data.TableReturnDoc do
  begin
      if bNew then
        Append
       else
        Edit;
      FieldByName('Date').Value:=DateTimePicker.Date;
      FieldByName('Coments').Value:=EdComment.Text;
      Post;
  end; 
  Close;
end;

end.
