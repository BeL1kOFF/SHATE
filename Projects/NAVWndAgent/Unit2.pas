unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls;

type
  TForm2 = class(TForm)
    StringGrid1: TStringGrid;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure LoadGrid;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
uses UnitCOMServerNAV, Unit1;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caHide;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Self.Caption := 'Монитор экземпляров NAV Classic';

  Self.StringGrid1.Cells[0,0]:='№';           Self.StringGrid1.ColWidths[0]:=50;
  Self.StringGrid1.Cells[1,0]:='Сервер';      Self.StringGrid1.ColWidths[1]:=125;
  Self.StringGrid1.Cells[2,0]:='База данных'; Self.StringGrid1.ColWidths[2]:=125;
  Self.StringGrid1.Cells[3,0]:='Фирма';       Self.StringGrid1.ColWidths[3]:=125;
  Self.StringGrid1.Cells[4,0]:='Процесс';     Self.StringGrid1.ColWidths[4]:=50;
  Self.StringGrid1.Cells[5,0]:='Поток';       Self.StringGrid1.ColWidths[5]:=50;
  Self.StringGrid1.Cells[6,0]:='Окно';        Self.StringGrid1.ColWidths[6]:=50;
  Self.StringGrid1.Cells[7,0]:='Время';       Self.StringGrid1.ColWidths[7]:=250;


end;

procedure TForm2.FormHide(Sender: TObject);
begin
  self.Timer1.Enabled := False;
end;

procedure TForm2.FormResize(Sender: TObject);
begin
  if self.WindowState = wsMinimized then
    self.Hide
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  self.Timer1.Enabled := True;
end;

procedure TForm2.LoadGrid;
var ArrNAV: TPassports;
    M,N,i,j: integer;
begin
  ArrNAV := TPassports(NAVCOM.RunningNAVs^);
  N:= Length(ArrNAV);

  if N = 0 then
   begin
    self.StringGrid1.RowCount := 1;
    exit;
   end;
  
  self.StringGrid1.RowCount :=  1 + N;//self.StringGrid1.FixedRows
  self.StringGrid1.FixedRows := 1;
  M:=8;
  for j := self.StringGrid1.FixedRows to self.StringGrid1.FixedRows + N - 1 do
   for i := 0 to  M - 1 do
    self.StringGrid1.Cells[i,j]:=ArrNAV[j-1,i];
  for j := self.StringGrid1.FixedRows to self.StringGrid1.FixedRows + N - 1 do
    self.StringGrid1.Cells[0,j]:=StringGrid1.Cells[0,j]+IntToStr(j);
end;

procedure TForm2.StringGrid1DblClick(Sender: TObject);
begin
  NAVCOM.ActivateByIndex(self.StringGrid1.Row-1);
end;

procedure TForm2.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var Color: TColor;
    Pt: TPoint;
begin
  if ARow<self.StringGrid1.FixedRows then inherited
   else
   if length(StringGrid1.Cells[0,ARow])<1 then inherited
    else
    begin
      case (StringGrid1.Cells[0,ARow][1]) of
        #2: Color:=clLime;
        #3: Color:=clAqua;
        #4: Color:=clRed;
        #6: Color:=clYellow;
        else
         begin
           Pt:=StringGrid1.CellRect(ACol,ARow).TopLeft;
           Pt.X:=Pt.X+1;
           Pt.Y:=Pt.Y+1;
           Color:=StringGrid1.Canvas.Pixels[Pt.X,Pt.Y];
         end;
      end;
      StringGridDrawCell(self.StringGrid1, Sender, ACol, ARow, Rect, State, Color);
    end;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  if self.Visible then self.LoadGrid;
end;

end.
