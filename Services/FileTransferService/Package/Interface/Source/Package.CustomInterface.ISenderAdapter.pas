unit Package.CustomInterface.ISenderAdapter;

interface

uses
  Package.CustomInterface.ICustomSenderAdapter;

type
  ISenderAdapter = interface
  ['{93792FAF-E71A-4CC9-ACBB-E474DDA87E36}']
    procedure BeginSenderExecute;
    procedure FinalizeAdapter;
    procedure InitAdapter(aCustomSenderAdapter: ICustomSenderAdapter);
    procedure LoadSenderAdapter;
  end;

implementation

end.
