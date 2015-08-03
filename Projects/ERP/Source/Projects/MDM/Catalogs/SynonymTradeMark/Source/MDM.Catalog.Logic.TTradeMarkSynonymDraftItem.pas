unit MDM.Catalog.Logic.TTradeMarkSynonymDraftItem;

interface

type
  TTradeMarkSynonymDraftItem = record
  private
    FId_TradeMarkSynonymDraft: Integer;
    FId_TradeMarkSynonym: Variant;      //Может быть Null
    FId_TradeMark: Integer;
    FName: string;
    FShowUI: Boolean;
    FVersion: Variant;                  //Может быть Null
    procedure SetId_TradeMark(const aValue: Integer);
    procedure SetId_TradeMarkSynonym(const aValue: Variant);
    procedure SetId_TradeMarkSynonymDraft(const aValue: Integer);
    procedure SetName(const aValue: string);
    procedure SetShowUI(const aValue: Boolean);
    procedure SetVersion(const aValue: Variant);
  public
    procedure SetDefault;
    property Id_TradeMarkSynonymDraft: Integer read FId_TradeMarkSynonymDraft write SetId_TradeMarkSynonymDraft;
    property Id_TradeMarkSynonym: Variant read FId_TradeMarkSynonym write SetId_TradeMarkSynonym;
    property Id_TradeMark: Integer read FId_TradeMark write SetId_TradeMark;
    property Name: string read FName write SetName;
    property ShowUI: Boolean read FShowUI write SetShowUI;
    property Version: Variant read FVersion write SetVersion;
  end;

implementation

uses
  System.Variants;

{ TTradeMarkSynonymDraftItem }

procedure TTradeMarkSynonymDraftItem.SetDefault;
begin
  FId_TradeMarkSynonymDraft := 0;
  FId_TradeMarkSynonym := Null();
  FId_TradeMark := 0;
  FName := '';
  FShowUI := False;
  FVersion := Null();
end;

procedure TTradeMarkSynonymDraftItem.SetId_TradeMark(const aValue: Integer);
begin
  FId_TradeMark := aValue;
end;

procedure TTradeMarkSynonymDraftItem.SetId_TradeMarkSynonym(const aValue: Variant);
begin
  FId_TradeMarkSynonym := aValue;
end;

procedure TTradeMarkSynonymDraftItem.SetId_TradeMarkSynonymDraft(const aValue: Integer);
begin
  FId_TradeMarkSynonymDraft := aValue;
end;

procedure TTradeMarkSynonymDraftItem.SetName(const aValue: string);
begin
  FName := aValue;
end;

procedure TTradeMarkSynonymDraftItem.SetShowUI(const aValue: Boolean);
begin
  FShowUI := aValue;
end;

procedure TTradeMarkSynonymDraftItem.SetVersion(const aValue: Variant);
begin
  FVersion := aValue;
end;

end.
