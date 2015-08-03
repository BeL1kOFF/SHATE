unit _PrintCOParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst;

type
  TPrintCOParamsForm = class(TForm)
    cbExcludeNullQuants: TCheckBox;
    Button1: TButton;
    GroupBox1: TGroupBox;
    rbSortBrandGroup: TRadioButton;
    rbSortGroupBrand: TRadioButton;
    cbIncludeSubtitles: TCheckBox;
    clbColumns: TCheckListBox;
    Label1: TLabel;
    Label2: TLabel;
    Sort_off: TRadioButton;
    procedure clbColumnsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure clbColumnsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure clbColumnsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Sort_offClick(Sender: TObject);
    procedure rbSortBrandGroupClick(Sender: TObject);
    procedure rbSortGroupBrandClick(Sender: TObject);
  private
    fDragItemTo: Integer;
  public
    { Public declarations }
  end;

var
  PrintCOParamsForm: TPrintCOParamsForm;

implementation

{$R *.dfm}

procedure TPrintCOParamsForm.clbColumnsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  aMoveToIndex: Integer;
begin
  aMoveToIndex := 0;
  if (Source = clbColumns) and (clbColumns.ItemIndex >= 0) then
  begin
    fDragItemTo := clbColumns.ItemAtPos(POINT(X, Y), True);
    if fDragItemTo <> clbColumns.ItemIndex then
    begin
      if fDragItemTo >= 0 then
      begin
        aMoveToIndex := fDragItemTo;
        if clbColumns.ItemIndex < fDragItemTo then
          Dec(aMoveToIndex);
      end
      else
        aMoveToIndex := clbColumns.Count;
      clbColumns.Items.Move(clbColumns.ItemIndex, aMoveToIndex);
    end;
    clbColumns.ItemIndex := aMoveToIndex;
  end;
  fDragItemTo := -1;
end;

procedure TPrintCOParamsForm.clbColumnsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source = clbColumns) and (clbColumns.ItemIndex >= 0);
  if Accept then
    fDragItemTo := clbColumns.ItemAtPos(POINT(X, Y), True)
  else
    fDragItemTo := -1;
  clbColumns.Repaint;
end;

procedure TPrintCOParamsForm.clbColumnsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  if odSelected in State then
    clbColumns.Canvas.Brush.Color := clHotLight
  else
    clbColumns.Canvas.Brush.Color := clWindow;

  clbColumns.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top, clbColumns.Items[Index]);

  if clbColumns.Dragging and (fDragItemTo = Index) and (fDragItemTo <> clbColumns.ItemIndex) then
  begin
    clbColumns.Canvas.Pen.Color := clBlue;
    clbColumns.Canvas.MoveTo(Rect.Left, Rect.Top);
    clbColumns.Canvas.LineTo(Rect.Right, Rect.Top);
  //  clbColumns.Canvas.Brush.Color := clYellow;
  end;
end;

procedure TPrintCOParamsForm.rbSortBrandGroupClick(Sender: TObject);
begin
 cbIncludeSubtitles.Checked:=true;
 cbIncludeSubtitles.Enabled:=true;
end;

procedure TPrintCOParamsForm.rbSortGroupBrandClick(Sender: TObject);
begin
 cbIncludeSubtitles.Checked:=true;
 cbIncludeSubtitles.Enabled:=true;
end;

procedure TPrintCOParamsForm.Sort_offClick(Sender: TObject);
begin
cbIncludeSubtitles.Checked:=false;
cbIncludeSubtitles.Enabled:=false;
end;

end.
