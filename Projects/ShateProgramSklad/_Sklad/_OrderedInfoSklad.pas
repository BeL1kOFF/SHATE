unit _OrderedInfoSklad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, GridsEh, DBGridEh, dbisamtb, StdCtrls, ExtCtrls;

type
  TFormOrderedInfoSklad = class(TForm)
    QueryOrders: TDBISAMQuery;
    DataSource1: TDataSource;
    lbGoodsName: TLabel;
    pnInfo: TPanel;
    lbGoodsInfo: TLabel;
    GridOrders: TDBGridEh;
    pnMain: TPanel;
    procedure GridOrdersDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fRetPrice: Double;
    fRetQuantity: Integer;
    fOnFormClose: TNotifyEvent;
    fRetOK: Boolean;
  public
    class procedure Popup(const aCode, aBrand, aDescription: string;
      aLeft, aTop: Integer; OnFormCloseHandler: TNotifyEvent; isSale: Boolean);

    property RetOK: Boolean read fRetOK;
    property RetPrice: Double read fRetPrice;
    property RetQuantity: Integer read fRetQuantity;
  end;

implementation

{$R *.dfm}

uses
  _Main;

{ TFormOrderedInfo }

procedure TFormOrderedInfoSklad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if fRetOK and Assigned(fOnFormClose) then
    fOnFormClose(Self);
  QueryOrders.Close;
  Action := caFree;
end;

procedure TFormOrderedInfoSklad.FormDeactivate(Sender: TObject);
begin
  Close;
end;

procedure TFormOrderedInfoSklad.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN: GridOrdersDblClick(GridOrders);
    VK_ESCAPE: Close;
  end;
end;

procedure TFormOrderedInfoSklad.GridOrdersDblClick(Sender: TObject);
begin
  if QueryOrders.RecordCount > 0 then
  begin
    fRetPrice := Main.AToCurr(QueryOrders.FieldByName('Price').AsString);
    fRetQuantity := Trunc(QueryOrders.FieldByName('Quantity').AsFloat);
    fRetOK := True;
    Close;
  end;
end;

class procedure TFormOrderedInfoSklad.Popup(const aCode, aBrand,
  aDescription: string; aLeft, aTop: Integer; OnFormCloseHandler: TNotifyEvent; isSale: Boolean);
begin
  with TFormOrderedInfoSklad.Create(Application) do
  begin
    Left := aLeft - Width;
    Top := aTop;

    lbGoodsName.Caption := 'Товар:  ' + aCode + ' ' + aBrand;
    lbGoodsInfo.Caption := aDescription;
    fOnFormClose := OnFormCloseHandler;

    pnInfo.Caption := 'поиск...';
    GridOrders.Visible := False;
    Show;
    lbGoodsInfo.AutoSize := False;
    lbGoodsInfo.AutoSize := True;
    lbGoodsInfo.AutoSize := False;
    lbGoodsInfo.Height := lbGoodsInfo.Height + 5;
    Update;

    if isSale then
      QueryOrders.Sql.Text :=
        ' select o."Date", od.Code Code2, od.Brand, od.Col Quantity, od.Price, od.Comments Info from [53] od ' +
        ' inner join [52] o on (o.SaleOrderID = od.SaleOrderID)             ' +
        ' where UPPER(Code) = UPPER(:Code) and UPPER(Brand) = UPPER(:Brand) ' +
        ' order by o."Date" desc                                            '
    else
      QueryOrders.Sql.Text :=
        'select o."Date", od.Code2, od.Brand, od.Quantity, od.Price, od.Info from [010] od ' +
        'inner join [009] o on (o.order_id = od.order_id)                   ' +
        'where UPPER(Code2) = UPPER(:Code) and UPPER(Brand) = UPPER(:Brand)  ' +
        'order by o."Date" desc                                             ';

    QueryOrders.ParamByName('Code').AsString := aCode;
    QueryOrders.ParamByName('Brand').AsString := aBrand;
    QueryOrders.Open;
    if QueryOrders.RecordCount > 0 then
    begin
      GridOrders.Visible := True;
      if (QueryOrders.FieldByName('Price') is TCurrencyField) then
        (QueryOrders.FieldByName('Price') as TCurrencyField).DisplayFormat := ',0.00';
    end
    else
      pnInfo.Caption := 'Товар не найден в заказах';

    fRetOK := False;
  end;
end;

end.
{
select o."Date", od.Code2, od.Brand, od.Quantity, od.Price, od.Info from [010] od
inner join [009] o on (o.order_id = od.order_id)
where UPPER(Code) = UPPER(:Code) and UPPER(Brand) = UPPER(:Brand)
order by o."Date" desc
}

{
select o."Date", od.Code Code2, od.Brand, CAST(od.Col, FLOAT) Quantity, od.Price, od.Comments Info from [53] od
inner join [52] o on (o.SaleOrderID = od.SaleOrderID)
where UPPER(Code) = UPPER(:Code) and UPPER(Brand) = UPPER(:Brand)
order by o."Date" desc
}


