unit Package.CustomInterface.ICustomReceiverAdapter;

interface

uses
  Data.Win.ADODB;

type
  ICustomReceiverAdapter = interface
  ['{81254E60-0D85-42E4-AC25-1D6F45EF6824}']
    function GetId_ProcessingReceiver: Integer;
    function GetIsOverwrite: Boolean;
    function GetIsUseTempFile: Boolean;
    function GetRetryError: Integer;
    function GetQuery: TADOQuery;

    function GetParseFileName(aSenderFileName: PChar; var aBuffer; aSizeBuffer: Integer): Integer;
    procedure LogWrite(aMessage: PChar);

    property Query: TADOQuery read GetQuery;

    property Id_ProcessingReceiver: Integer read GetId_ProcessingReceiver;
    property IsOverwrite: Boolean read GetIsOverwrite;
    property IsUseTempFile: Boolean read GetIsUseTempFile;
    property RetryError: Integer read GetRetryError;
  end;

implementation

end.
