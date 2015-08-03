unit _OrderedInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, GridsEh, DBGridEh, dbisamtb, StdCtrls, ExtCtrls;

type
  TFormOrderedInfo = class(TForm)
    QueryOrders: TDBISAMQuery;
    DataSource1: TDataSource;
    lbGoodsName: TLabel;
    pnInfo: TPanel;
    lbGoodsInfo: TLabel;
    GridOrders: TDBGridEh;
    pnMain: TPanel;
    Panel1: TPanel;
    btGotoOrder: TButton;
    procedure GridOrdersDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btGotoOrderClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    fRetOrderID: Integer;
    fRetOrderDetID: Integer;
    fCode, fBrand, fDescription: string;
  public
    class function Execute(const aCode, aBrand, aDescription: string;
      out anOrderID, anOrderDetID: Integer): Boolean;

    property RetOrderID: Integer read fRetOrderID;
    property RetOrderDetID: Integer read fRetOrderDetID;
  end;

implementation

{$R *.dfm}

uses
  _Main, _Data;

{ TFormOrderedInfo }

procedure TFormOrderedInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  QueryOrders.Close;
end;

procedure TFormOrderedInfo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN: btGotoOrderClick(nil);
    VK_ESCAPE: Close;
  end;
end;

procedure TFormOrderedInfo.FormShow(Sender: TObject);
begin
  lbGoodsName.Caption := 'Товар:  ' + fCode + ' ' + fBrand;
  lbGoodsInfo.Caption := fDescription;
  pnInfo.Caption := 'поиск...';
  GridOrders.Visible := False;
  lbGoodsInfo.AutoSize := False;
  lbGoodsInfo.AutoSize := True;
  lbGoodsInfo.AutoSize := False;
  lbGoodsInfo.Height := lbGoodsInfo.Height + 5;
  Update;
  QueryOrders.DatabaseName := Main.GetCurrentBD;
  QueryOrders.Sql.Text :=
    ' select o."Date", od.Code2, od.Brand, od.Quantity, od.Price, od.Info, od.Order_ID OrderID, od.ID OrderDetID from [010] od ' +
    ' inner join [009] o on (o.order_id = od.order_id)                   ' +
    ' where UPPER(Code2) = UPPER(:Code) and UPPER(Brand) = UPPER(:Brand) ' +
    ' order by o."Date" desc                                             ';

  QueryOrders.ParamByName('Code').AsString := fCode;
  QueryOrders.ParamByName('Brand').AsString := fBrand;
  QueryOrders.Open;
  btGotoOrder.Enabled := QueryOrders.RecordCount > 0;
  if QueryOrders.RecordCount > 0 then
  begin
    GridOrders.Visible := True;
    if (QueryOrders.FieldByName('Price') is TCurrencyField) then
      (QueryOrders.FieldByName('Price') as TCurrencyField).DisplayFormat := ',0.00';
  end
  else
    pnInfo.Caption := 'Товар не найден в заказах';
end;

procedure TFormOrderedInfo.GridOrdersDblClick(Sender: TObject);
begin
  btGotoOrderClick(nil);
end;

procedure TFormOrderedInfo.btGotoOrderClick(Sender: TObject);
begin
  if QueryOrders.RecordCount > 0 then
  begin
    fRetOrderID := QueryOrders.FieldByName('OrderID').AsInteger;
    fRetOrderDetID := QueryOrders.FieldByName('OrderDetID').AsInteger;
    ModalResult := mrOK;
  end;
end;

class function TFormOrderedInfo.Execute(const aCode, aBrand, aDescription: string;
  out anOrderID, anOrderDetID: Integer): Boolean;
begin
  with TFormOrderedInfo.Create(Application) do
  try
    fCode := aCode;
    fBrand := aBrand;
    fDescription := aDescription;
    Result := ShowModal = mrOK;
    if Result then
    begin
      anOrderID := fRetOrderID;
      anOrderDetID := fRetOrderDetID;
    end;
  finally
    Free;
  end;
end;

end.

