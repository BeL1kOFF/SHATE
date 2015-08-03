unit _TxtAttr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BSDlgFrm, JvComponentBase, JvFormPlacement, StdCtrls, Buttons,
  ExtCtrls, JvExStdCtrls, JvEdit, JvValidateEdit;

type
  TTextAttr = class(TDialogForm)
    Memo: TMemo;
    BackgroundBtn: TBitBtn;
    FontBtn: TBitBtn;
    FormStorage: TJvFormStorage;
    ColorDialog: TColorDialog;
    FontDialog: TFontDialog;
    procedure BackgroundBtnClick(Sender: TObject);
    procedure FontBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TextAttr: TTextAttr;

implementation

uses _Main;

{$R *.dfm}

procedure TTextAttr.BackgroundBtnClick(Sender: TObject);
begin
  inherited;
  ColorDialog.Color := Memo.Color;
  if ColorDialog.Execute then
    Memo.Color := ColorDialog.Color;
end;

procedure TTextAttr.FontBtnClick(Sender: TObject);
begin
  inherited;
  FontDialog.Font := Memo.Font;
  if FontDialog.Execute then
    Memo.Font := FontDialog.Font;
end;

end.
