unit _Orders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ActnList, AdvToolBar, GridsEh, DBGridEh, JvComponentBase,
  JvFormPlacement, ExtCtrls, AdvSplitter, AdvPanel;

type
  TOrders = class(TForm)
    CatalogPanel: TAdvPanel;
    AdvSplitter1: TAdvSplitter;
    Details: TAdvPanel;
    FormStorage: TJvFormStorage;
    DBGridEh1: TDBGridEh;
    DBGridEh2: TDBGridEh;
    AdvDockPanel1: TAdvDockPanel;
    AdvToolBar1: TAdvToolBar;
    AdvDockPanel2: TAdvDockPanel;
    AdvToolBar2: TAdvToolBar;
    OrdersActionList: TActionList;
    ImageList: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Orders: TOrders;

implementation

uses _Main;

{$R *.dfm}

end.
