unit _ReturnDocED;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponentBase, JvFormPlacement, StdCtrls, JvExStdCtrls,
  JvDBCombobox, AdvGlowButton, DBCtrls, Mask, ComCtrls, JvExComCtrls,
  JvDateTimePicker, JvDBDateTimePicker, Buttons, ExtCtrls;

type
  TReturnDocED = class(TForm)
    BtnBevel: TBevel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DateEd: TJvDBDateTimePicker;
    NumEd: TDBEdit;
    DescriptionEd: TDBEdit;
    ClientComboBox: TDBLookupComboBox;
    ClearClientBtn: TAdvGlowButton;
    TypeComboBox: TJvDBComboBox;
    FormStorage: TJvFormStorage;
    procedure ClearClientBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReturnDocED: TReturnDocED;
  Old_Cli_index : string;

implementation

{$R *.dfm}
Uses _Data;


procedure TReturnDocED.ClearClientBtnClick(Sender: TObject);
begin
  Data.ReturnDocTable.FieldByName('Cli_id').Clear;
end;

procedure TReturnDocED.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Data.ClIDsTable.IndexName := Old_Cli_index;
end;

procedure TReturnDocED.FormCreate(Sender: TObject);
begin
  Old_Cli_index := Data.ClIDsTable.IndexName;
  Data.ClIDsTable.IndexName := 'Descr';
end;

end.
