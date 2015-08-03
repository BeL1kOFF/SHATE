unit ERP.Package.ClientInterface.IModuleAccess;

interface

type
  PAccessCaption = ^TAccessCaption;
  TAccessCaption = packed record
    Caption: PChar;
    Access: Boolean;
  end;

  IModuleAccess = interface
  ['{7845341C-CD08-4CAB-9A49-C27B4ED1DDEF}']
    function ContainsBit(aBit: Integer): Boolean;
    function GetBit(aIndex: Integer): Integer;
    function GetCount: Integer;
    function GetItems(aBit: Integer): PAccessCaption;
    procedure Add(aCaption: PChar; aBit: Integer);

    property Bit[aIndex: Integer]: Integer read GetBit;
    property Count: Integer read GetCount;
    property Items[aBit: Integer]: PAccessCaption read GetItems;
  end;

implementation

end.
