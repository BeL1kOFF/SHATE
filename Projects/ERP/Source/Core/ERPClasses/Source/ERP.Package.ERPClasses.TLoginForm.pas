unit ERP.Package.ERPClasses.TLoginForm;

interface

uses
  Vcl.Forms,
  ERP.Package.CustomClasses.TCustomPackageForm;

type
  TLoginForm = class(TCustomPackageForm)
  private
    function GetLoginFormClass: TFormClass;
  public
    property LoginFormClass: TFormClass read GetLoginFormClass;
  end;

implementation

{ TLoginForm }

function TLoginForm.GetLoginFormClass: TFormClass;
begin
  Result := FormClass['RegisterLoginForm'];
end;

end.
