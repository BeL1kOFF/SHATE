unit Package.CustomInterface.IReceiverAdapter;

interface

uses
  System.SysUtils,
  Package.CustomInterface.ICustomReceiverAdapter;

type
  IReceiverAdapter = interface
  ['{871921C9-E12D-498D-BFF5-73F0CFA4111E}']
    function Execute(aSenderFileName: PChar; const aBuffer: TBytes): Boolean;
    procedure FinalizeAdapter;
    procedure InitAdapter(aCustomReceiverAdapter: ICustomReceiverAdapter);
    procedure LoadAdapter;
  end;

implementation

end.
