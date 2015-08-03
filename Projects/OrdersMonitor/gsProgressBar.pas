//**! ----------------------------------------------------------
//**! This unit is a part of GSPackage project (Gregory Sitnin's
//**! Delphi Components Package).
//**! ----------------------------------------------------------
//**! You may use or redistribute this unit for your purposes
//**! while unit's code and this copyright notice is unchanged
//**! and exists.
//**! ----------------------------------------------------------
//**! (c) Gregory Sitnin, 2001-2002. All rights reserved.
//**! ----------------------------------------------------------

unit gsProgressBar;

{***} interface {***}

uses
  Windows, Messages, Classes, Graphics, ComCtrls;

type
  TgsProgressBar = class(TProgressBar)
  private
    { Private declarations }
    FColor: TColor;
    procedure SetColor(const Value: TColor);
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure CreateWnd; override;
  published
    { Published declarations }
    property Color: TColor read FColor write SetColor;
  end;

procedure Register;

{***} implementation {***}
const PBM_SETBARCOLOR = WM_USER+9;
procedure Register;
begin
  RegisterComponents('GSPackage', [TgsProgressBar]);
end;

{ TgsProgressBar }

procedure TgsProgressBar.CreateWnd;
begin
  inherited;
  if HandleAllocated then
    SendMessage(Handle, PBM_SETBARCOLOR, 0, FColor);
end;

procedure TgsProgressBar.SetColor(const Value: TColor);
begin
  FColor := Value;
  if HandleAllocated then
    SendMessage(Handle, PBM_SETBARCOLOR, 0, FColor);
end;

end.
