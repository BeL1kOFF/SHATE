unit _PrintCOParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TPrintCOParamsForm = class(TForm)
    cbExcludeNullQuants: TCheckBox;
    Button1: TButton;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    rbSortBrandGroup: TRadioButton;
    rbSortGroupBrand: TRadioButton;
    cbIncludeSubtitles: TCheckBox;
    Sort_off: TRadioButton;
    procedure Sort_offClick(Sender: TObject);
    procedure rbSortBrandGroupClick(Sender: TObject);
    procedure rbSortGroupBrandClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrintCOParamsForm: TPrintCOParamsForm;

implementation

{$R *.dfm}

procedure TPrintCOParamsForm.rbSortBrandGroupClick(Sender: TObject);
begin
 cbIncludeSubtitles.Checked:=true;
 cbIncludeSubtitles.Enabled:=true;
end;

procedure TPrintCOParamsForm.rbSortGroupBrandClick(Sender: TObject);
begin
 cbIncludeSubtitles.Checked:=true;
 cbIncludeSubtitles.Enabled:=true;
end;

procedure TPrintCOParamsForm.Sort_offClick(Sender: TObject);
begin
cbIncludeSubtitles.Checked:=false;
cbIncludeSubtitles.Enabled:=false;
end;

end.
