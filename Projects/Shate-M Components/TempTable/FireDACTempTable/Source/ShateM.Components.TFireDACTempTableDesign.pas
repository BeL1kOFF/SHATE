unit ShateM.Components.TFireDACTempTableDesign;

interface

uses
  System.Classes,
  ShateM.Components.TFireDACTempTable;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Shate-M', [TsmFireDACTempTable]);
end;

end.
