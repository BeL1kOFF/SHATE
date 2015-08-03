unit _MyBrand;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, StdCtrls, Buttons, JvComponentBase,
  JvFormPlacement, DB, dbisamtb, VclUtils;

type
  TMyBrandsSetup = class(TForm)
    Grid: TDBGridEh;
    FormStorage: TJvFormStorage;
    Table: TDBISAMTable;
    DataSource: TDataSource;
    MyBrandTable: TDBISAMTable;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadMyBrands;
    procedure SaveMyBrands;
  end;

var
  MyBrandsSetup: TMyBrandsSetup;

implementation

uses _Data;

{$R *.dfm}


procedure TMyBrandsSetup.FormShow(Sender: TObject);
begin
  with Table do
  begin
    Open;
    First;
  end;
  Grid.Col := 2;
end;

procedure TMyBrandsSetup.LoadMyBrands;
begin
  StartWait;
  MyBrandTable.Open;
  with Table do
  begin
    Open;
    First;
    while not Eof do
    begin
      Edit;
      FieldByName('My_brand').Value := MyBrandTable.FindKey([FieldByName('Description').AsString]);
      Post;
      Next;
    end;
    Close;
  end;
  MyBrandTable.Close;
  StopWait;
end;

procedure TMyBrandsSetup.OkBtnClick(Sender: TObject);
begin
  if Table.State = dsEdit then
    Table.Post;
  SaveMyBrands;
end;

procedure TMyBrandsSetup.SaveMyBrands;
begin
  StartWait;
  MyBrandTable.Open;
  with Table do
  begin
    DisableControls;
    First;
    while not Eof do
    begin
      if FieldByName('My_brand').AsBoolean then
      begin
        if not MyBrandTable.FindKey([FieldByName('Description').AsString]) then
        begin
          MyBrandTable.Append;
          MyBrandTable.FieldByName('Brand_descr').Value := FieldByName('Description').AsString;
          MyBrandTable.Post;
        end;
      end
      else
      begin
        if MyBrandTable.FindKey([FieldByName('Description').AsString]) then
          MyBrandTable.Delete;
      end;
      Next;
    end;
    First;
    EnableControls;
  end;
  MyBrandTable.Close;
  StopWait;
end;

procedure TMyBrandsSetup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Table.Close;
end;

procedure TMyBrandsSetup.FormCreate(Sender: TObject);
begin
  LoadMyBrands;
end;

procedure TMyBrandsSetup.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F10 then
    OkBtn.Click;
end;

end.
