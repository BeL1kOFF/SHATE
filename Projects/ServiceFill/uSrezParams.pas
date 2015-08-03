unit uSrezParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSrezParamsForm = class(TForm)
    cbParam_Primen: TCheckBox;
    cbParam_Picts: TCheckBox;
    cbParam_Descr: TCheckBox;
    cbParam_Det: TCheckBox;
    cbParam_DetTyp: TCheckBox;
    btOK: TButton;
    procedure btOKClick(Sender: TObject);
  private
    procedure Validate;
  public
  end;

var
  SrezParamsForm: TSrezParamsForm;

implementation

{$R *.dfm}

procedure TSrezParamsForm.btOKClick(Sender: TObject);
begin
  Validate;
  ModalResult := mrOk;
end;

procedure TSrezParamsForm.Validate;
begin
  if not (
    cbParam_Primen.Checked or
    cbParam_Picts.Checked or
    cbParam_Descr.Checked or
    cbParam_Det.Checked or
    cbParam_DetTyp.Checked
  ) then
    raise Exception.Create('Ничего не выбрано');
end;

end.

