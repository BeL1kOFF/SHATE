unit ERP.Package.ERPClasses.TMainForm;

interface

uses
  Vcl.Forms,
  ERP.Package.CustomClasses.TCustomPackageForm;

type
  TMainForm = class(TCustomPackageForm)
  private
    function GetMainFormClass: TFormClass;
  public
    property MainFormClass: TFormClass read GetMainFormClass;
  end;

implementation

{ TMainForm }

function TMainForm.GetMainFormClass: TFormClass;
begin
  Result := FormClass['RegisterMainForm'];
end;

end.
