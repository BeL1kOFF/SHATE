unit MDM.Catalog.Logic.TradeMarkDraft;

interface

type
  TTradeMarkDraftBit = class
  private
    FName: Integer;
    FFullName: Integer;
    FOriginal: Integer;
    FLogo: Integer;
  public
    constructor Create(aName, aFullName, aOriginal, aLogo: Integer);
    property Name: Integer read FName;
    property FullName: Integer read FFullName;
    property Original: Integer read FOriginal;
    property Logo: Integer read FLogo;
  end;

implementation

{ TTradeMarkDraftBit }

constructor TTradeMarkDraftBit.Create(aName, aFullName, aOriginal, aLogo: Integer);
begin
  FName := aName;
  FFullName := aFullName;
  FOriginal := aOriginal;
  FLogo := aLogo;
end;

end.
