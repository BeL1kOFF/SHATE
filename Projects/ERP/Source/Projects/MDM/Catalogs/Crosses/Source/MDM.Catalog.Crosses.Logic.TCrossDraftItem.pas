unit MDM.Catalog.Crosses.Logic.TCrossDraftItem;

interface

type
  TCrossDraftItem = record
  private
    FId_CrossDraft: Integer;
    FId_Cross: Variant;
    FId_TradeMark1: Integer;
    FId_TradeMark2: Integer;
    FId_Article1: Integer;
    FId_Article2: Integer;
    FVersion: Variant;
    procedure SetId_Article1(const aValue: Integer);
    procedure SetId_Article2(const aValue: Integer);
    procedure SetId_Cross(const aValue: Variant);
    procedure SetId_CrossDraft(const aValue: Integer);
    procedure SetVersion(const aValue: Variant);
    procedure SetId_TradeMark1(const aValue: Integer);
    procedure SetId_TradeMark2(const aValue: Integer);
  public
    procedure SetDefault;
    property Id_CrossDraft: Integer read FId_CrossDraft write SetId_CrossDraft;
    property Id_Cross: Variant read FId_Cross write SetId_Cross;
    property Id_TradeMark1: Integer read FId_TradeMark1 write SetId_TradeMark1;
    property Id_TradeMark2: Integer read FId_TradeMark2 write SetId_TradeMark2;
    property Id_Article1: Integer read FId_Article1 write SetId_Article1;
    property Id_Article2: Integer read FId_Article2 write SetId_Article2;
    property Version: Variant read FVersion write SetVersion;
  end;

implementation

uses
  System.Variants;

{ TCrossDraftItem }

procedure TCrossDraftItem.SetDefault;
begin
  FId_CrossDraft := 0;
  FId_Cross := Null();
  FId_TradeMark1 := 0;
  FId_TradeMark2 := 0;
  FId_Article1 := 0;
  FId_Article2 := 0;
  FVersion := Null();
end;

procedure TCrossDraftItem.SetId_Article1(const aValue: Integer);
begin
  FId_Article1 := aValue;
end;

procedure TCrossDraftItem.SetId_Article2(const aValue: Integer);
begin
  FId_Article2 := aValue;
end;

procedure TCrossDraftItem.SetId_Cross(const aValue: Variant);
begin
  FId_Cross := aValue;
end;

procedure TCrossDraftItem.SetId_CrossDraft(const aValue: Integer);
begin
  FId_CrossDraft := aValue;
end;

procedure TCrossDraftItem.SetId_TradeMark1(const aValue: Integer);
begin
  FId_TradeMark1 := aValue;
end;

procedure TCrossDraftItem.SetId_TradeMark2(const aValue: Integer);
begin
  FId_TradeMark2 := aValue;
end;

procedure TCrossDraftItem.SetVersion(const aValue: Variant);
begin
  FVersion := aValue;
end;

end.
