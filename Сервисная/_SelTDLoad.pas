unit _SelTDLoad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BSDlgFrm, StdCtrls, Buttons, ExtCtrls, JvComponentBase,
  JvFormPlacement;

type
  TSelectTDLoad = class(TDialogForm)
    DesTextCheckBox: TCheckBox;
    CdsTextCheckBox: TCheckBox;
    ArtCheckBox: TCheckBox;
    ArtTypCheckBox: TCheckBox;
    TypesCheckBox: TCheckBox;
    ModelsCheckBox: TCheckBox;
    MfaCheckBox: TCheckBox;
    CatDetCheckBox: TCheckBox;
    CatTypDetCheckBox: TCheckBox;
    CatParCheckBox: TCheckBox;
    CatPictCheckBox: TCheckBox;
    PictCheckBox: TCheckBox;
    PrimenCheckBox: TCheckBox;
    FormStorage: TJvFormStorage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectTDLoad: TSelectTDLoad;

implementation

uses _Main;

{$R *.dfm}

end.
