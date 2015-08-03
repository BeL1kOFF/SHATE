unit ShateM.Components.TADOTempTableDesign;

interface

uses
  System.Classes,
  ShateM.Components.TADOTempTable;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Shate-M', [TsmADOTempTable]);
end;

end.
