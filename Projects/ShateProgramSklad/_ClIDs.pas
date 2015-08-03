unit _ClIDs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, _FlatSpr, AdvToolBar, AdvToolBarStylers, ImgList, ActnList,
  JvComponentBase, JvFormPlacement, DB, dbisamtb, Menus, StdCtrls, GridsEh,
  DBGridEh, ExtCtrls, BSStrUt;

type
  TClientIDs = class(TFlatSpr)
    TableId: TAutoIncField;
    TableClient_ID: TStringField;
    TableDescription: TStringField;
    TableOrder_type: TStringField;
    TableDelivery: TIntegerField;
    AdvToolBarButton1: TAdvToolBarButton;
    ByDefault: TAction;
    TableByDefault: TIntegerField;
    ByDefault_ImageList: TImageList;
    Tableemail: TStringField;
    TableKey: TStringField;
    TableUpdateDisc: TBooleanField;
    Query: TDBISAMQuery;
    TableDiscountVersion: TIntegerField;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ActionExecute(Sender: TObject);
    procedure Grid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Grid1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure Grid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddItem; override;
    procedure SetAsCurrent;
  end;

var
  ClientIDs: TClientIDs;

implementation

uses _Main, _Data, _ClIDEd;

{$R *.dfm}

procedure TClientIDs.ActionExecute(Sender: TObject);
begin
  with Table do
  begin
    Edit;
      if FieldByName('Delivery').AsString =''  then
        FieldByName('Delivery').Value := 3;
    Post;
  end;
  inherited;
  with Table do
  begin
    Edit;
    FieldByName('Client_ID').Value := ReplaceStr(FieldByName('Client_ID').AsString, ' ','');
    Post;
  end;
end;

procedure TClientIDs.AddItem;
begin
  inherited;
  with Table do
  begin
    Edit;
    if FieldByName('Order_type').AsString =''  then
      FieldByName('Order_type').Value := 'A';

    if FieldByName('Delivery').AsString =''  then
      FieldByName('Delivery').Value := '3';
    Post;

  end;
end;

procedure TClientIDs.FormCreate(Sender: TObject);
begin
  inherited;
  EditFormClass := TClientIDEdit;
  CodeField := 'Client_id';
  NameField := 'Description';
  NewItemDescr := 'Новый ID';
  ToolBarStyler.Style := Main.ToolBarStyler.Style;
  ToolBarStyler.DragGripStyle := dsNone;
end;

procedure TClientIDs.FormShow(Sender: TObject);
begin
  inherited;
  Table.IndexName := 'Descr';
  Table.Locate('ByDefault', 1, []);
end;

procedure TClientIDs.Grid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
begin
  inherited;
(*
  if Table.FieldByName('ByDefault').AsInteger = 1 then
  begin
    Grid1.Canvas.Font.Color := clRed;
    Grid1.Canvas.Font.Style := [fsBold];
//    Grid1.Canvas.Font.Color := clWhite;
//    Grid1.Canvas.Brush.Color := clRed;
    Grid1.Canvas.FillRect(Rect);
  end;

  if Column.Field = Table.FieldByName('ByDefault') then
  begin
    if Table.FieldByName('ByDefault').AsInteger = 1 then
      ByDefault_ImageList.Draw(Grid1.Canvas, Rect.Left + 2, Rect.Top, 0);
      //Grid1.Canvas.Draw(Rect.Left + 2, Rect.Top + 2, Image1.Picture.Graphic);
  end
  else
    Grid1.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 1, Column.Field.DisplayText);
*)
end;

procedure TClientIDs.Grid1GetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  inherited;
  if Table.FieldByName('ByDefault').AsInteger = 1 then
    AFont.Style := [fsBold];
end;

procedure TClientIDs.Grid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var iRow, MX,MY,i:integer;
      iCol:integer;
      Rect:TRect;
begin
  inherited;
    iRow :=0;
    iCol :=0;
    MX:=Mouse.CursorPos.X - (Sender as TDBGridEh).ClientOrigin.X;
    MY:=Mouse.CursorPos.Y - (Sender as TDBGridEh).ClientOrigin.Y;
    for I := 0 to (Sender as TDBGridEh).RowCount -1 do
    begin
      Rect:=(Sender as TDBGridEh).CellRect(0,I);
      if((MY>=Rect.Top)and(MY<=Rect.Bottom)) then
         iRow := i;
    end;

    if iRow < 1 then exit;

    for I := 0 to (Sender as TDBGridEh).Columns.Count -1 do
    begin
      Rect:=(Sender as TDBGridEh).CellRect(I,0);
      if((MX>=Rect.Left)and(MX<=Rect.Right)) then
         iCol := i;
    end;

    if iCol <> 0 then exit;

   // Table.Edit;

   Table.DisableControls;
    if Table.FieldByName('ByDefault').AsInteger = 1 then
    begin
      //Table.FieldByName('ByDefault').AsInteger := 0
      Query.SQL.Clear;
      Query.SQL.Add('update [011] set ByDefault = 0');
      Query.ExecSQL;
    end
    else
    begin
      Query.SQL.Clear;
      Query.SQL.Add('update [011] set ByDefault = 0');
      Query.ExecSQL;

      Query.SQL.Clear;
      Query.SQL.Add('update [011] set ByDefault = 1 where ID = '+Table.FieldByName('ID').AsString);
      Query.ExecSQL;
    end;
    Table.Refresh;
    Table.EnableControls;
    //Table.Post;
    //MessageDlg('bvgfsdgfds', mtInformation, [mbOK],0);
end;

procedure TClientIDs.GridDblClick(Sender: TObject);
begin
  SetAsCurrent;
  ModalResult := mrOK;
end;

procedure TClientIDs.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    SetAsCurrent;
    ModalResult := mrOK;
    Exit;
  end;
  inherited;
end;

procedure TClientIDs.SetAsCurrent;
begin
  Table.DisableControls;
  try
    Query.SQL.Clear;
    Query.SQL.Add('update [011] set ByDefault = 0');
    Query.ExecSQL;

    Query.SQL.Clear;
    Query.SQL.Add('update [011] set ByDefault = 1 where ID = ' + Table.FieldByName('ID').AsString);
    Query.ExecSQL;

    Table.Refresh;
  finally
    Table.EnableControls;
  end;
  Grid.Repaint;
  Sleep(100);
end;

end.
