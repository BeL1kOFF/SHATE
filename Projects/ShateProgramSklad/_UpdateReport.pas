unit _UpdateReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, ImgList, StdCtrls, _Updater;

type
  TFormUpdateReport = class(TForm)
    pnBottom: TPanel;
    sgReport: TStringGrid;
    imgIcons16: TImageList;
    imgIcons32: TImageList;
    btClose: TButton;
    pnTop: TPanel;
    imgUpdateResult: TImage;
    lbUpdateResult: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lbSeparator1: TLabel;
    lbHeader: TLabel;
    lbSeparator2: TLabel;
    Label1: TLabel;
    cbHideUpdateReport: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure sgReportDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormResize(Sender: TObject);
  private
    fQueue: TUpdateQueue;
    fUpdateResult: TUpdateResult;
  public
    procedure Init(anUpdateResult: TUpdateResult; aQueue: TUpdateQueue);

    class function Execute(anUpdateResult: TUpdateResult; aQueue: TUpdateQueue; out aNotShowAgain: Boolean): Integer; {ModalResult}
  end;

implementation

{$R *.dfm}

const
  cMinRowHeight = 34;

class function TFormUpdateReport.Execute(anUpdateResult: TUpdateResult;
  aQueue: TUpdateQueue; out aNotShowAgain: Boolean): Integer;
begin
  with TFormUpdateReport.Create(Application) do
  try
    Init(anUpdateResult, aQueue);
    Result := ShowModal;
    aNotShowAgain := cbHideUpdateReport.Checked;
  finally
    Free;
  end;
end;

procedure TFormUpdateReport.Init(anUpdateResult: TUpdateResult;
  aQueue: TUpdateQueue);
begin
  fQueue := aQueue;
  fUpdateResult := anUpdateResult;
end;

procedure TFormUpdateReport.FormShow(Sender: TObject);
var
  i: Integer;
  aImgInd: Integer;
begin
  case fUpdateResult of
    urFail:
    begin
      lbUpdateResult.Caption := 'Обновление базы не выполнено!';
      aImgInd := 0;
    end;
    urPartially:
    begin
      lbUpdateResult.Caption := 'Некоторые пакеты обновления не были установлены';
      aImgInd := 2;
    end;
    urFully:
    begin
      lbUpdateResult.Caption := 'Обновление успешно установлено';
      aImgInd := 1;
    end;
    urAborted:
    begin
      lbUpdateResult.Caption := 'Обновление прервано';
      aImgInd := 3;
    end
    else
    begin
      lbUpdateResult.Caption := '';
      aImgInd := 0;
    end;
  end;
        
  imgUpdateResult.Picture.Bitmap.Canvas.FillRect(imgUpdateResult.Picture.Bitmap.Canvas.ClipRect);
  imgIcons32.Draw(imgUpdateResult.Picture.Bitmap.Canvas, 0, 0, aImgInd);

  sgReport.RowCount := fQueue.Count;
  sgReport.ColWidths[0] := imgIcons16.Width + 4;
  for i := 0 to fQueue.Count - 1 do
  begin
    sgReport.Cells[0, i] := IntToStr(Integer(fQueue[i].Installed));
    sgReport.Cells[1, i] := fQueue[i].PackageDescription;
    sgReport.Cells[2, i] := fQueue[i].UpdateError;
    sgReport.RowHeights[i] := cMinRowHeight;
  end;

end;

procedure TFormUpdateReport.sgReportDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  aImgInd: Integer;
  r: TRect;
  hText, hRow: Integer;
begin
  if (gdSelected in State) or (gdFocused in State) then
    sgReport.Canvas.Brush.Color := clInfoBk
  else
    sgReport.Canvas.Brush.Color := sgReport.Color;
  sgReport.Canvas.FillRect(Rect);
  sgReport.Canvas.Font.Color := sgReport.Font.Color;

  case ACol of
    0:
    begin
      aImgInd := StrToIntDef(sgReport.Cells[aCol, aRow], 0);
      sgReport.Canvas.FillRect(Rect);
      imgIcons16.Draw(sgReport.Canvas, Rect.Left + 2, (Rect.Top + Rect.Bottom - imgIcons16.Height) div 2, aImgInd);
    end;

    1:
    begin
    //  sgReport.Canvas.Font.Style := [fsUnderline];
      sgReport.Canvas.TextRect(Rect, Rect.Left + 3, Rect.Top + 3, sgReport.Cells[aCol, aRow]);
      sgReport.Canvas.Font.Style := [];
      r := Rect;
      r.Top := r.Top + sgReport.DefaultRowHeight;

      if sgReport.Cells[2, aRow] <> '' then //has error
      begin
        sgReport.Canvas.Font.Color := clRed;
        sgReport.Canvas.TextRect(r, r.Left+2, r.Top, ' - ошибка: ');
        sgReport.Canvas.Font.Color := sgReport.Font.Color;
        r.Left := r.Left + 2 + sgReport.Canvas.TextWidth(' - ошибка: ');
        //вычисляем высоту строки
        hText := DrawText(
          sgReport.Canvas.Handle,
          PAnsiChar(sgReport.Cells[2, aRow]),
          Length(sgReport.Cells[2, aRow]),
          r,
          DT_WORDBREAK or DT_CALCRECT
        );
        hRow := sgReport.DefaultRowHeight + hText + 1;
        if hRow < cMinRowHeight then
          hRow := cMinRowHeight;
        if sgReport.RowHeights[aRow] <> hRow then
          sgReport.RowHeights[aRow] := hRow
        else //выводим текст ошибки
          DrawText(sgReport.Canvas.Handle, PAnsiChar(sgReport.Cells[2, aRow]), Length(sgReport.Cells[2, aRow]), r, DT_WORDBREAK);
      end
      else
      begin
        sgReport.Canvas.Font.Color := clGreen;
        sgReport.Canvas.TextRect(r, r.Left, r.Top, ' - установлено');
      end;
    end;
  end;//case
end;

procedure TFormUpdateReport.FormResize(Sender: TObject);
begin
  sgReport.ColWidths[1] := sgReport.ClientWidth - sgReport.ColWidths[0] - sgReport.GridLineWidth;
end;

end.
