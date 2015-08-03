unit Package.CustomInterface.ICustomSenderAdapter;

interface

uses
  System.SysUtils,
  Data.Win.ADODB;

type
  TResultReceiver = (rrNone, rrSuccess, rrError, rrPartly);

  ICustomSenderAdapter = interface
  ['{156A57A1-C1EA-42F1-99E1-AD349E86176F}']
    function GetBuffer: TBytes;
    function GetResultReceiver: TResultReceiver;
    function GetSuccessDirectory: PChar;
    function GetErrorDirectory: PChar;
    function GetPartDirectory: PChar;
    function GetIsDeleteSuccess: Boolean;
    function GetIsDeleteError: Boolean;
    function GetIsDeletePart: Boolean;
    function GetOrder: Integer;
    function GetId_ProcessingSender: Integer;
    function GetQuery: TADOQuery;
    function InMaskList(aFileName: PChar): Boolean;
    procedure LogWrite(aMessage: PChar);
    procedure ReceiverExecute(aSenderFileName: PChar);
    procedure SetBuffer(const aValue: TBytes);

    property Buffer: TBytes read GetBuffer write SetBuffer;
    property Query: TADOQuery read GetQuery;
    property ResultReceiver: TResultReceiver read GetResultReceiver;

    property Id_ProcessingSender: Integer read GetId_ProcessingSender;
    property SuccessDirectory: PChar read GetSuccessDirectory;
    property ErrorDirectory: PChar read GetErrorDirectory;
    property PartDirectory: PChar read GetPartDirectory;
    property IsDeleteSuccess: Boolean read GetIsDeleteSuccess;
    property IsDeleteError: Boolean read GetIsDeleteError;
    property IsDeletePart: Boolean read GetIsDeletePart;
    property Order: Integer read GetOrder;
  end;

implementation

end.
