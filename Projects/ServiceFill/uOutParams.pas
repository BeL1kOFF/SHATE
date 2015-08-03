unit uOutParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst;

type
  TOutParamsForm = class(TForm)
    btOK: TButton;
    cbParams: TCheckListBox;
    cbAll: TCheckBox;
    cbMakeUpdate: TCheckBox;
    cbBuildPrimen: TCheckBox;
    procedure cbAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbParamsClickCheck(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  OutParamsForm: TOutParamsForm;

implementation

{$R *.dfm}

{ TOutParamsForm }

procedure TOutParamsForm.cbAllClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to cbParams.Count - 1 do
    cbParams.Checked[i] := cbAll.Checked;
  cbParamsClickCheck(nil);  
end;

procedure TOutParamsForm.cbParamsClickCheck(Sender: TObject);
begin
  cbBuildPrimen.Enabled := cbParams.Checked[0];
  if not cbBuildPrimen.Enabled then
    cbBuildPrimen.Checked := False;
end;

procedure TOutParamsForm.FormCreate(Sender: TObject);
begin
  cbAll.Checked := True;
end;

end.
