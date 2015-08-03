unit _BrandMap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, DBCtrls, GridsEh, DBGridEh, Menus;

type
  TBrandMap = class(TForm)
    Button1: TButton;
    Button2: TButton;
    DBCheckBox1: TDBCheckBox;
    DBGridEh1: TDBGridEh;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1Columns1EditButtonClick(Sender: TObject;
      var Handled: Boolean);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BrandMap: TBrandMap;

implementation

uses _Main, _Data, _BrandAdd;



{$R *.dfm}

procedure TBrandMap.Button1Click(Sender: TObject);
begin
  with TAddBrand.Create(Application) do
  begin
   Data.mapBrand4ImportOrder.Append;
   ShowModal;
   Data.mapBrand4ImportOrder.FieldByName('serviceBrand').AsString := DataSource1.DataSet.FieldByName('Description').AsString;
   if DBEdit2.Text <> '' then
      Data.mapBrand4ImportOrder.Post
   else
      Data.mapBrand4ImportOrder.Cancel;
   Free;
  end;
end;

procedure TBrandMap.Button2Click(Sender: TObject);
begin
  if MessageDlg('Удалить? Вы уверены? ', mtWarning, [mbYes, mbNo], 0) = mrYes then
    Data.mapBrand4ImportOrder.Delete;
end;

procedure TBrandMap.DBGridEh1Columns1EditButtonClick(Sender: TObject;
  var Handled: Boolean);
begin
  with TAddBrand.Create(Application) do
  begin
   Data.mapBrand4ImportOrder.Edit;
   ShowModal;
   if DBEdit2.Text <> '' then
      Data.mapBrand4ImportOrder.Post
   else
      Data.mapBrand4ImportOrder.Cancel;
   Free;
  end;
end;

procedure TBrandMap.FormCreate(Sender: TObject);
begin
  Data.mapBrand4ImportOrder.IndexName := 'serviceBrand';
end;

procedure TBrandMap.N1Click(Sender: TObject);
begin
  if MessageDlg('Удалить? Вы уверены? ', mtWarning, [mbYes, mbNo], 0) = mrYes then
    Data.mapBrand4ImportOrder.Delete;
end;

procedure TBrandMap.N2Click(Sender: TObject);
begin
  with TAddBrand.Create(Application) do
  begin
   Data.mapBrand4ImportOrder.Edit;
   ShowModal;
   if DBEdit2.Text <> '' then
      Data.mapBrand4ImportOrder.Post
   else
      Data.mapBrand4ImportOrder.Cancel;
   Free;
  end;
end;

procedure TBrandMap.N3Click(Sender: TObject);
begin
  with TAddBrand.Create(Application) do
  begin
   Data.mapBrand4ImportOrder.Append;
   ShowModal;
   Data.mapBrand4ImportOrder.FieldByName('serviceBrand').AsString := DataSource1.DataSet.FieldByName('Description').AsString;
   if DBEdit2.Text <> '' then
      Data.mapBrand4ImportOrder.Post
   else
      Data.mapBrand4ImportOrder.Cancel;
   Free;
  end;
end;

end.
