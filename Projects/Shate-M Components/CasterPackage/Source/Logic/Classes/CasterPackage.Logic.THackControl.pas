unit CasterPackage.Logic.THackControl;

interface

uses
  VCL.Controls;

type
  THackControl = class(TControl)
  public
    procedure SetParent(AParent: TWinControl); override;
  end;

implementation

procedure THackControl.SetParent(AParent: TWinControl);
begin
  inherited;
end;

end.
