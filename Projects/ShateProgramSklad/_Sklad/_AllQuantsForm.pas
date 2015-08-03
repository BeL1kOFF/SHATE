unit _AllQuantsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TAllQuantsForm = class(TForm)
    lbNames: TLabel;
    lbValues: TLabel;
    Splitter1: TSplitter;
  private
    fEmbedding: Boolean;
  public
    constructor CreateEmbedded(aSite: TWinControl; aDefAlign: TAlign = alClient); virtual;
    procedure EmbedInto(AParent: TWinControl; aDefAlign: TAlign = alClient); virtual;
    procedure AfterConstruction; override;

    procedure SetQuants(aList: TStrings);
    procedure Clear(const aValuesOnly: Boolean = True);
  end;

var
  AllQuantsForm: TAllQuantsForm;

implementation

{$R *.dfm}

{ TAllQuantsForm }

procedure TAllQuantsForm.AfterConstruction;
begin
  inherited;
  if fEmbedding and not OldCreateOrder then
    Visible := True;
end;

procedure TAllQuantsForm.Clear(const aValuesOnly: Boolean);
begin
  lbValues.Caption := '';
  if not aValuesOnly then
    lbNames.Caption := '';
end;

constructor TAllQuantsForm.CreateEmbedded(aSite: TWinControl;
  aDefAlign: TAlign);
begin
  fEmbedding := True;
  Create(aSite);
  if Assigned(aSite) then
    EmbedInto(aSite, aDefAlign);
end;

procedure TAllQuantsForm.EmbedInto(AParent: TWinControl; aDefAlign: TAlign);
var
  aHeight: Integer;
begin
  fEmbedding := True;
  aHeight := ClientHeight;

  BorderStyle := Forms.bsNone;
  BevelOuter := bvNone;
  Align := aDefAlign;
  Parent := AParent;
  Height := aHeight;
  // Keep right order of events: OnCreate first, then OnShow.
  if OldCreateOrder then
    Visible := True;
end;

procedure TAllQuantsForm.SetQuants(aList: TStrings);
var
  i: Integer;
  s1, s2: string;
begin
  for i := 0 to aList.Count - 1 do
  begin
    s1 := s1 + aList.Names[i] + ' :'#13#10;
    s2 := s2 + aList.ValueFromIndex[i] + #13#10;
  end;
  lbNames.Caption := s1;
  lbValues.Caption := s2;
end;

end.
