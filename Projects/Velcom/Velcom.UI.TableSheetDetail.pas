unit Velcom.UI.TableSheetDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, StdCtrls, ExtCtrls, DB, ADODB, ActnList;

type
  TfrmTableSheetDetail = class(TForm)
    ActionList: TActionList;
    acCancel: TAction;
    acSave: TAction;
    qrQuery: TADOQuery;
    Panel2: TPanel;
    Label1: TLabel;
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    cxComboBox1: TcxComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
