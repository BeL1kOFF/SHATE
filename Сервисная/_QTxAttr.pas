unit _QTxAttr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, _TxtAttr, JvExStdCtrls, JvEdit, JvValidateEdit, StdCtrls,
  JvComponentBase, JvFormPlacement, Buttons, ExtCtrls;

type
  TQuantTextAttr = class(TTextAttr)
    Label1: TLabel;
    LoEd: TJvValidateEdit;
    Label2: TLabel;
    HiEd: TJvValidateEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  QuantTextAttr: TQuantTextAttr;

implementation

{$R *.dfm}

end.
