unit _SaleOrderInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, AdvDateTimePicker, Buttons, _Data;

type
  TSaleOrderInfo = class(TForm)
    Label1: TLabel;
    DateTimePicker: TAdvDateTimePicker;
    Label2: TLabel;
    EdComment: TEdit;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    procedure CancelButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
     bNew:bool;
     procedure SetNew(New:bool);
    { Public declarations }
  end;

var
  SaleOrderInfo: TSaleOrderInfo;

implementation

{$R *.dfm}

procedure TSaleOrderInfo.SetNew(New:bool);
begin
   bNew := New;
   DateTimePicker.Date := Now;
end;

procedure TSaleOrderInfo.CancelButtonClick(Sender: TObject);
begin
    Close;
end;

procedure TSaleOrderInfo.SaveButtonClick(Sender: TObject);
begin
  with  Data.TableSaleOrder do
  begin
      if bNew then
        begin
        Append;
        FieldByName('State').Value:=0;
        end
       else
        Edit;
      if FieldByName('State').AsString = '' then
        FieldByName('State').Value:=0;
      FieldByName('Date').Value:=DateTimePicker.Date;
      FieldByName('Comment').Value:=EdComment.Text;
      Post;
  end; 
  Close;
end;

end.
