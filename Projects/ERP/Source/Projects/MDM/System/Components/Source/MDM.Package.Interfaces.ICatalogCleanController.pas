unit MDM.Package.Interfaces.ICatalogCleanController;

interface

uses
  MDM.Package.Interfaces.ICustomCatalogController;

type
  ICatalogCleanController = interface(ICustomCatalogController)
  ['{CCCF9761-52B8-4342-943E-754F4F43ED26}']
    function UpdateMoveToDraft: Boolean;
    function UpdateCopyFrom: Boolean;
    function UpdateRestore: Boolean;
    function UpdateExportClean: Boolean;
    procedure MoveToDraft;
    procedure CopyFrom;
    procedure Restore;
    procedure ExportClean;
  end;

implementation

end.
