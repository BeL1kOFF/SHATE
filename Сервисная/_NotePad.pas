unit _NotePad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids, ImgList, Menus, Buttons;

const
  cHeaderHeight = 16;
  cMarginLeft = 10;
  cMarginRight = 10;
  cMarginTop = 5;
  cMarginBottom = 20;

  cMaxMemoHeight = 145;
  
type
  TNotesFilter = record
    Name: string;
    Date1, Date2: TDate;                              
    Filter: string;
  end;

  TNotePadForm = class(TForm)
    Panel2: TPanel;
    Grid: TDrawGrid;
    Memo1: TMemo;
    ImageList1: TImageList;
    Panel1: TPanel;
    Label1: TLabel;
    lbFilter: TLabel;
    pm: TPopupMenu;
    miWeek: TMenuItem;
    miMonth: TMenuItem;
    miAll: TMenuItem;
    N4: TMenuItem;
    miLast10: TMenuItem;
    lbCurrentRange: TLabel;
    miToday: TMenuItem;
    pnDelete: TPanel;
    btDelete: TSpeedButton;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure GridDblClick(Sender: TObject);
    procedure Memo1Exit(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure lbFilterClick(Sender: TObject);
    procedure miAllClick(Sender: TObject);
    procedure miWeekClick(Sender: TObject);
    procedure miMonthClick(Sender: TObject);
    procedure miLast10Click(Sender: TObject);
    procedure miTodayClick(Sender: TObject);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridExit(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
  private
    fCurRec: Integer;
    fDisableDraw: Boolean;
    fEditing: Boolean;
    fEditingRow: Integer;
    OldClientWidth: Integer;
    fCurFilter: TNotesFilter;

    procedure RecalcRowHeights;
    function CalcTextHeigth(const aText: string; aWidth: Integer): Integer;
    function CalcTextHeigthFull(const aText: string; aWidth: Integer): Integer;
    procedure ReopenData;
    procedure AddToday;
    function FindToday: Integer;
    procedure HideEditor;
    procedure RestoreFilter;
  public
    procedure SetFilter(aDate1, aDate2: TDate; const aFilterName: string);
    procedure NoteToday;
  end;

var
  NotePadForm: TNotePadForm;

implementation

{$R *.dfm}

uses
  _Data, DateUtils;

function TNotePadForm.FindToday: Integer;
begin
  Result := -1;
  if not Data.Notes.Active then
    Exit;

  Data.Notes.First;
  while not Data.Notes.Eof do
  begin
    if Trunc(Data.NotesDate.AsDateTime) = Date then
    begin
      Result := Data.Notes.RecNo;
      Break;
    end;
    Data.Notes.Next;
  end;
end;

procedure TNotePadForm.FormCreate(Sender: TObject);
begin
  fDisableDraw := True;
  pnDelete.Hide;

  if not Data.Notes.Exists then
    Data.Notes.CreateTable;

  Data.Notes.Open;
  AddToday;

  //load filter ..
  //set filter ..

  SetFilter(0, 0, '* все *');
end;

procedure TNotePadForm.FormShow(Sender: TObject);
begin
  Data.Notes.Open;
  AddToday;
  RestoreFilter;
{
  Grid.ColWidths[0] := Grid.ClientWidth;
  RecalcRowHeights;
}  
end;

procedure TNotePadForm.GridDblClick(Sender: TObject);
var
  r: TRect;
  p: TPoint;
begin
  if not Data.Notes.Active then
    Exit;

  fEditing := True;
  fEditingRow := Grid.Row;

  r := Grid.CellRect(Grid.Col, Grid.Row);
  r.Top := r.Top + cMarginTop;
  r.Bottom := r.Bottom - cMarginBottom;
  OffsetRect(r, Grid.Left + Grid.ClientRect.Left, Grid.Top + Grid.ClientRect.Top);

  r.Top := r.Top + cHeaderHeight;
  r.Left := r.Left + cMarginLeft;
  r.Right := r.Right - cMarginRight;
  OffsetRect(r, -1, 2);
  Memo1.Left := r.Left;
  Memo1.Top := r.Top;
  Memo1.Width := r.Right - r.Left + 6;
  Memo1.Height := r.Bottom - r.Top + 1;

  fCurRec := Grid.Row - Grid.FixedRows + 1;
  Data.Notes.RecNo := fCurRec;
  Memo1.Text := Data.NotesNote.AsString;
  Memo1.Show;
  Memo1.SetFocus;
  SendMessage(Memo1.Handle, WM_VSCROLL, SB_TOP, 0);
  
  if Sender <> nil then
  begin
    GetCursorPos(p);
    p := Memo1.ScreenToClient(p);
    PostMessage(Memo1.Handle, WM_LBUTTONDOWN, MK_LBUTTON, MAKEWPARAM(p.x, p.y));
    PostMessage(Memo1.Handle, WM_LBUTTONUP, 0, MAKEWPARAM(p.x, p.y));
  end
  else
    Memo1.CaretPos := POINT(0, 0);
  Grid.Repaint;
end;

procedure TNotePadForm.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  c: TCanvas;
  aText: string;
  r: TRect;
  b: Integer;
  sDate: string;
  imgIndex: Integer;
  isToday: Boolean;
begin
  if fDisableDraw then
    Exit;

  if ARow < Grid.FixedRows then
    Exit;

  if not Data.Notes.Active then
  begin
    c := Grid.Canvas;
    c.Brush.Color := Grid.Color;
    c.FillRect(Rect);
    Exit;
  end;

  if Data.Notes.RecordCount = 0 then
  begin
    c := Grid.Canvas;
    c.Brush.Color := Grid.Color;
    c.FillRect(Rect);
    Exit;
  end;

  c := Grid.Canvas;
  Data.Notes.RecNo := ARow - Grid.FixedRows + 1;
  isToday := Trunc(Data.NotesDate.AsDateTime) = Date;

  r := Rect;
  c.Brush.Color := Grid.Color;
  c.FillRect(r);
  r.Right := r.Right - 1;

//header
  r.Bottom := r.Top + cHeaderHeight;

  sDate := Data.NotesDate.AsString;
  if isToday then
    sDate := sDate + ' (сегодня)';
  //c.TextRect(r, r.Left + 22, r.Top + 1, sDate);
  c.Pen.Width := 1;
  imgIndex := 0;
  if fEditing and (fEditingRow = ARow) then
  begin
    imgIndex := 1;
    c.Font.Color :=$00C0723D; //$00BC9D7F;
    c.Pen.Color := $00BC9D7F;
   // c.Pen.Width := 2;
    c.Font.Style := [fsBold];
  end
  else
  begin
    c.Font.Color := clWindowText;
    if isToday then
      c.Font.Color := clBlue;
    c.Pen.Color := clSilver;//$00197CCB;
  end;

  if gdFocused in State then
  begin
    c.Font.Style := [fsBold];
   // c.Pen.Width := 2;
  end;

  b := r.Bottom - c.TextHeight(sDate) div 2;
  c.MoveTo(r.Left + ImageList1.Width + 6 + c.TextWidth(sDate) + 1, b);
  c.LineTo(r.Right - 4, b);
  ImageList1.Draw(c, r.Left + 2, r.Top, imgIndex);
  c.TextOut(r.Left + ImageList1.Width + 6, r.Top + 1, sDate);

  if (gdFocused in State) then
  begin
    pnDelete.Left := r.Right - pnDelete.Width - 1 + Grid.ClientRect.Left;
    pnDelete.Top := b + Grid.ClientRect.Top - 5;
//    if isToday then
  //    pnDelete.Top := -1000;
    pnDelete.Show;
  end;

//data
  aText := Data.NotesNote.AsString;

  c.Font.Style := [];
  c.Font.Color := clWindowText;
  c.Brush.Color := clWhite;
  r := Rect;
  r.Top := r.Top + cHeaderHeight + cMarginTop;
  r.Bottom := r.Bottom - cMarginBottom;
  r.left := r.left + cMarginLeft;
  r.Right := r.Right - cMarginRight;
  DrawText(c.Handle, PChar(aText), Length(aText), r, DT_WORDBREAK);
  if not (fEditing and (fEditingRow = ARow)) then
    if CalcTextHeigth(aText, r.Right - r.Left) <> CalcTextHeigthFull(aText, r.Right - r.Left) then
      c.Draw(r.Left, r.Bottom, Image1.Picture.Graphic);

//frame
  r := Rect;
  r.Top := r.Top + cHeaderHeight;
  r.Right := r.Right - 1;
  if fEditing and (fEditingRow = ARow) then
  begin
    c.Pen.Color := $00BC9D7F;
    c.MoveTo(r.Left + 5 {cMarginLeft}, r.Bottom - cMarginBottom + 4);
    c.LineTo(r.Right - 4, r.Bottom - cMarginBottom + 4);

    c.MoveTo(r.Left + 5, r.Bottom - cMarginBottom + 4);
    c.LineTo(r.Left + 5, r.Bottom - cMarginBottom + 4 - 7);

    c.MoveTo(r.Right - 4, r.Bottom - cMarginBottom + 4);
    c.LineTo(r.Right - 4, r.Bottom - cMarginBottom + 4 - 7);

    c.MoveTo(r.Right - 4, b);
    c.LineTo(r.Right - 4, b + 7);
//    c.FrameRect(r);
  end;

  if gdFocused in State then
  begin
    c.Pen.Color := clGray;
//    c.MoveTo(r.Left, r.Bottom - 3);
//    c.LineTo(r.Right, r.Bottom - 3);
//    c.DrawFocusRect(r);
  end;
end;

procedure TNotePadForm.GridExit(Sender: TObject);
begin
  pnDelete.Hide;
end;

procedure TNotePadForm.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    GridDblClick(nil)
  else
    if Key = VK_ESCAPE then
      Self.Parent.SetFocus;
end;

procedure TNotePadForm.HideEditor;
begin
  Memo1.Hide;
end;

procedure TNotePadForm.lbFilterClick(Sender: TObject);
begin
  pm.Popup(lbFilter.ClientOrigin.X + lbFilter.Width, lbFilter.ClientOrigin.Y + lbFilter.Height);
end;

procedure TNotePadForm.Memo1Change(Sender: TObject);
var
  aHeight: Integer;
begin
  aHeight := CalcTextHeigth(Memo1.Text, Grid.ColWidths[0]);
  if aHeight <> CalcTextHeigthFull(Memo1.Text, Grid.ColWidths[0]) then
  begin
    Memo1.OnExit := nil;
    Memo1.ScrollBars := ssVertical;
    Memo1.OnExit := Memo1Exit;
  end
  else
  begin
    Memo1.OnExit := nil;
    Memo1.ScrollBars := ssNone;
    Memo1.OnExit := Memo1Exit;
  end;

  Grid.RowHeights[Grid.Row] := aHeight + cHeaderHeight + cMarginTop + cMarginBottom;
  Memo1.Height := aHeight + 4;
end;

procedure TNotePadForm.Memo1Exit(Sender: TObject);
begin
  fEditing := False;
  Memo1.Hide;
  if not Data.Notes.Active then
    Exit;
  Data.Notes.RecNo := fCurRec;
  Data.Notes.Edit;
  Data.NotesNote.AsString := Memo1.Text;
  Data.Notes.Post;

  if Grid.CanFocus then
    Grid.SetFocus;

  Grid.Repaint;
end;

procedure TNotePadForm.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    HideEditor;
end;

procedure TNotePadForm.miAllClick(Sender: TObject);
begin
  HideEditor;
  SetFilter(0, 0, (Sender as TMenuitem).Caption);
end;

procedure TNotePadForm.miWeekClick(Sender: TObject);
var
  d1, d2: TDate;
begin
  HideEditor;
  d1 := Date - DayOfTheWeek(Date) + 1;
  d2 := d1 + 6;
  SetFilter(d1, d2, (Sender as TMenuitem).Caption);
end;

procedure TNotePadForm.NoteToday;
var
  i: Integer;
begin
  i := FindToday;
  if i >= 0 then
  begin
    Grid.Row := i + Grid.FixedRows - 1;
    GridDblClick(nil);
  end;
end;

procedure TNotePadForm.miMonthClick(Sender: TObject);
var
  dd, mm, yy: Word;
  d1, d2: TDate;
begin
  HideEditor;
  DecodeDate(Date, yy, mm, dd);
  d1 := EncodeDate(yy, mm, 1);
  Inc(mm);
  if mm > 12 then
  begin
    Inc(yy);
    mm := 1;
  end;
  d2 := EncodeDate(yy, mm, 1) - 1;
  SetFilter(d1, d2, (Sender as TMenuitem).Caption);
end;

procedure TNotePadForm.miTodayClick(Sender: TObject);
begin
  HideEditor;
  SetFilter(Date, Date, (Sender as TMenuitem).Caption);
end;

procedure TNotePadForm.miLast10Click(Sender: TObject);
begin
  HideEditor;
  SetFilter(0, 0, (Sender as TMenuitem).Caption);
end;

procedure TNotePadForm.Panel2Resize(Sender: TObject);
begin
  if OldClientWidth = Grid.ClientWidth then
    Exit;
  OldClientWidth := Grid.ClientWidth;
  Grid.ColWidths[0] := Grid.ClientWidth;
  RecalcRowHeights;
end;

procedure TNotePadForm.AddToday;
var
  aHasToday: Boolean;
begin
  if not Data.Notes.Active then
    Exit;

  aHasToday := False;
  Data.Notes.CancelRange;
  Data.Notes.First;
  while not Data.Notes.Eof do
  begin
    if Trunc(Data.NotesDate.AsDateTime) = Date then
    begin
      aHasToday := True;
      Break;
    end;
    Data.Notes.Next;
  end;

  if not aHasToday then
  begin
    Data.Notes.Edit;
    Data.Notes.Append;
    Data.NotesDate.AsDateTime := Date;
    Data.NotesNote.AsString := '';
    Data.Notes.Post;
  end;
end;

procedure TNotePadForm.btDeleteClick(Sender: TObject);
begin
  if not Data.Notes.Active then
    Exit;

//  if Application.MessageBox('Удалить заметку?', 'Подтверждение', MB_ICONQUESTION or MB_YESNO) = IDYES then
  begin
    Data.Notes.RecNo := Grid.Row - Grid.FixedRows + 1;
    if Trunc(Data.NotesDate.AsDateTime) = Date then
    begin
      Data.Notes.Edit;
      Data.NotesNote.AsString := '';
      Data.Notes.Post;
    end
    else
      Data.Notes.Delete;
    RestoreFilter;
  end;
end;

function TNotePadForm.CalcTextHeigth(const aText: string;
  aWidth: Integer): Integer;
var
  r: TRect;
  aTxt: string;
begin
  aTxt := aText;
  if aTxt = '' then
    aTxt := ' ';
  r := RECT(0, 0, aWidth, 10);
  Result := DrawText(Grid.Canvas.Handle, PChar(aTxt), Length(aTxt), r, DT_WORDBREAK or DT_CALCRECT);

  if Result > cMaxMemoHeight then
    Result := cMaxMemoHeight;
end;


function TNotePadForm.CalcTextHeigthFull(const aText: string;
  aWidth: Integer): Integer;
var
  r: TRect;
  aTxt: string;
begin
  aTxt := aText;
  if aTxt = '' then
    aTxt := ' ';
  r := RECT(0, 0, aWidth, 10);
  Result := DrawText(Grid.Canvas.Handle, PChar(aTxt), Length(aTxt), r, DT_WORDBREAK or DT_CALCRECT);
end;

procedure TNotePadForm.RecalcRowHeights;
var
  aText: string;
  aHeight: Integer;
begin
  if not Data.Notes.Active then
    Exit;

  fDisableDraw := True;
  try
    Data.Notes.First;
    while not Data.Notes.Eof do
    begin
      aText := Data.NotesNote.AsString;
      aHeight := CalcTextHeigth(aText, Grid.ColWidths[0]);
      Grid.RowHeights[Data.Notes.RecNo + Grid.FixedRows - 1] := aHeight + cHeaderHeight + cMarginTop + cMarginBottom;
      Data.Notes.Next;
    end;
  finally
    fDisableDraw := False;
    Grid.Repaint;
    Panel2Resize(nil);
  end;
end;

procedure TNotePadForm.ReopenData;
begin
  fDisableDraw := True;
  try
    Grid.RowCount := Data.Notes.RecordCount + Grid.FixedRows;
    Grid.Enabled := Data.Notes.RecordCount > 0;
    RecalcRowHeights;
  finally
    fDisableDraw := False;
    Grid.Repaint;
  end;
end;

procedure TNotePadForm.RestoreFilter;
begin
  SetFilter(fCurFilter.Date1, fCurFilter.Date2, fCurFilter.Name);
end;

procedure TNotePadForm.SetFilter(aDate1, aDate2: TDate; const aFilterName: string);
begin
  if not Data.Notes.Active then
    Exit;

  fCurFilter.Date1 := aDate1;
  fCurFilter.Date2 := aDate2;
  fCurFilter.Filter := '';
  fCurFilter.Name := aFilterName;

  lbFilter.Caption := aFilterName;
  if (aDate1 = 0) and (aDate2 = 0) then
  begin
    Data.Notes.CancelRange;
    lbCurrentRange.Caption := '';
  end
  else
  begin
    Data.Notes.SetRange([aDate1], [aDate2]);
    lbCurrentRange.Caption := FormatDateTime('dd.mm.yyyy', aDate1) + ' - ' + FormatDateTime('dd.mm.yyyy', aDate2);
  end;
  ReopenData;
  Grid.Row := Grid.RowCount - 1;
end;

end.


