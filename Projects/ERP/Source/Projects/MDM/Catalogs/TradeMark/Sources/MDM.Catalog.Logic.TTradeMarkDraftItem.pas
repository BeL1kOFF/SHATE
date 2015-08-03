unit MDM.Catalog.Logic.TTradeMarkDraftItem;

interface

type
  TTradeMarkDraftItem = record
  private
    FId_TradeMarkDraft: Integer;
    FId_TradeMark: Variant;     //Может быть Null
    FName: string;
    FFullName: string;
    FDescription: string;
    FIsOriginal: Boolean;
    FLogo: Variant;             //Может быть Null
    FURLSite: string;
    FURLCatalog: string;
    FVersion: Variant;          //Может быть Null
    procedure SetName(const aValue: string);
    procedure SetFullName(const aValue: string);
    procedure SetIsOriginal(const aValue: Boolean);
    procedure SetId_TradeMark(const aValue: Variant);
    procedure SetDescription(const aValue: string);
    procedure SetLogo(const aValue: Variant);
    procedure SetURLCatalog(const aValue: string);
    procedure SetURLSite(const aValue: string);
    procedure SetVersion(const aValue: Variant);
    procedure SetId_TradeMarkDraft(const aValue: Integer);
  public
    procedure SetDefault;
    property Id_TradeMarkDraft: Integer read FId_TradeMarkDraft write SetId_TradeMarkDraft;
    property Id_TradeMark: Variant read FId_TradeMark write SetId_TradeMark;
    property Name: string read FName write SetName;
    property FullName: string read FFullName write SetFullName;
    property Description: string read FDescription write SetDescription;
    property IsOriginal: Boolean read FIsOriginal write SetIsOriginal;
    property Logo: Variant read FLogo write SetLogo;
    property URLSite: string read FURLSite write SetURLSite;
    property URLCatalog: string read FURLCatalog write SetURLCatalog;
    property Version: Variant read FVersion write SetVersion;
  end;

implementation

uses
  System.Variants;

{ TTradeMarkDraftItem }

procedure TTradeMarkDraftItem.SetDefault;
begin
  FId_TradeMarkDraft := 0;
  FId_TradeMark := Null();
  FName := '';
  FFullName := '';
  FDescription := '';
  FIsOriginal := False;
  FLogo := Null();
  FURLSite := '';
  FURLCatalog := '';
  FVersion := Null();
end;

procedure TTradeMarkDraftItem.SetDescription(const aValue: string);
begin
  FDescription := aValue;
end;

procedure TTradeMarkDraftItem.SetFullName(const aValue: string);
begin
  FFullName := aValue;
end;

procedure TTradeMarkDraftItem.SetId_TradeMark(const aValue: Variant);
begin
  FId_TradeMark := aValue;
end;

procedure TTradeMarkDraftItem.SetId_TradeMarkDraft(const aValue: Integer);
begin
  FId_TradeMarkDraft := aValue;
end;

procedure TTradeMarkDraftItem.SetIsOriginal(const aValue: Boolean);
begin
  FIsOriginal := aValue;
end;

procedure TTradeMarkDraftItem.SetLogo(const aValue: Variant);
begin
  FLogo := aValue;
end;

procedure TTradeMarkDraftItem.SetName(const aValue: string);
begin
  FName := aValue;
end;

procedure TTradeMarkDraftItem.SetURLCatalog(const aValue: string);
begin
  FURLCatalog := aValue;
end;

procedure TTradeMarkDraftItem.SetURLSite(const aValue: string);
begin
  FURLSite := aValue;
end;

procedure TTradeMarkDraftItem.SetVersion(const aValue: Variant);
begin
  FVersion := aValue;
end;

end.
