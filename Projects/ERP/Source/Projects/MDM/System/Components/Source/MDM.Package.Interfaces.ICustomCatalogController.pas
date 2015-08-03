unit MDM.Package.Interfaces.ICustomCatalogController;

interface

uses
  Winapi.ActiveX;

type
  ICustomCatalogController = interface
  ['{D24610E5-9B9D-450F-9D0A-CB259DD443C2}']
    function LoadDetails: IStream;
    function UpdateRefresh: Boolean;
    procedure Refresh;
  end;

implementation

end.
