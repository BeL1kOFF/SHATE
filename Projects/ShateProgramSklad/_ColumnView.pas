unit _ColumnView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Buttons, ExtCtrls;

type
  TCulumnView = class(TForm)
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    DBCheckBox6: TDBCheckBox;
    DBCheckBox7: TDBCheckBox;
    DBCheckBox8: TDBCheckBox;
    DBCheckBox9: TDBCheckBox;
    DBCheckBox10: TDBCheckBox;
    BitBtn1: TBitBtn;
    DBCheckBox13: TDBCheckBox;
    Bevel1: TBevel;
    DBCheckBox14: TDBCheckBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CulumnView: TCulumnView;

implementation

{$R *.dfm}

uses
  _Data, DB;

procedure TCulumnView.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TCulumnView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Data.ColumnView.State in [dsEdit, dsInsert] then
    Data.ColumnView.Post;
end;

end.
