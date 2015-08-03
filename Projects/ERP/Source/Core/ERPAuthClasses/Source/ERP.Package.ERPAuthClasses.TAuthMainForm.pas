unit ERP.Package.ERPAuthClasses.TAuthMainForm;

interface

uses
  Vcl.Forms,
  ERP.Package.CustomClasses.TCustomPackageForm;

type
  TAuthMainForm = class(TCustomPackageForm)
  private
    function GetMainFormClass: TFormClass;
  public
    property MainFormClass: TFormClass read GetMainFormClass;
  end;

implementation

{ TAuthMainForm }

function TAuthMainForm.GetMainFormClass: TFormClass;
begin
  Result := FormClass['RegisterMainForm'];
end;

end.
