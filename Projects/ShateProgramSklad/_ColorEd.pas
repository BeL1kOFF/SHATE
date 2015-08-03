unit _ClIDEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BSDlgFrm, StdCtrls, Buttons, ExtCtrls,  JvComponentBase,
  JvFormPlacement, Mask, DBCtrls;

type
  TClientIDEdit = class(TDialogForm)
    FormStorage: TJvFormStorage;
    Label1: TLabel;
    ClientIdEd: TDBEdit;
    Label2: TLabel;
    DescriptionEd: TDBEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClientIDEdit: TClientIDEdit;

implementation

uses _Main;

{$R *.dfm}

procedure TClientIDEdit.FormShow(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  for i := 0 to ControlCount - 1 do
    if Controls[i] is TDBEdit then
      (Controls[i] as TDBEdit).DataSource := DataSource
end;

end.
