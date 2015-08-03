unit _NotifyLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, StdCtrls, Buttons;

type
  TNotifyLogForm = class(TForm)
    sgLog: TStringGrid;
    Panel1: TPanel;
    Button1: TButton;
    btClear: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btClearClick(Sender: TObject);
  private
    fMessages: TStrings;
    procedure FillMessages;
  public
    procedure Init(aMessages: TStrings);

    class function Execute(aMessages: TStrings): Boolean;
  end;

var
  NotifyLogForm: TNotifyLogForm;

implementation

{$R *.dfm}

{ TNotifyLogForm }

class function TNotifyLogForm.Execute(aMessages: TStrings): Boolean;
var
  f: TNotifyLogForm;
begin
  f := TNotifyLogForm.Create(Application);
  try
    f.Init(aMessages);
    f.ShowModal;
    aMessages.Assign(f.fMessages);
  finally
    f.Free;
  end;
end;

procedure TNotifyLogForm.FormCreate(Sender: TObject);
begin
  fMessages := TStringList.Create;
end;

procedure TNotifyLogForm.FormDestroy(Sender: TObject);
begin
  fMessages.Free;
end;

procedure TNotifyLogForm.Init(aMessages: TStrings);
begin
  fMessages.Assign(aMessages);
end;

procedure TNotifyLogForm.FormShow(Sender: TObject);
begin
  FillMessages;
end;

procedure TNotifyLogForm.FormResize(Sender: TObject);
begin
  sgLog.ColWidths[1] := sgLog.ClientWidth - sgLog.ColWidths[0] - sgLog.GridLineWidth;
end;

procedure TNotifyLogForm.FillMessages;
var
  i, p: Integer;
  s: string;
begin
  sgLog.RowCount := fMessages.Count;
  sgLog.Rows[0].Clear;
  for i := 0 to fMessages.Count - 1 do
  begin
    s := fMessages[fMessages.Count - 1 - i];
    p := POS('$', s);
    if p = 0 then
      sgLog.Cells[1, i] := s
    else
    begin
      sgLog.Cells[0, i] := Copy(s, 1, p - 1);
      sgLog.Cells[1, i] := Copy(s, p + 1, MaxInt);
    end;
  end;
end;

procedure TNotifyLogForm.btClearClick(Sender: TObject);
begin
  fMessages.Clear;
  FillMessages;
  Close;
end;



end.
