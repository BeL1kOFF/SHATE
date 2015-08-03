unit MDM.Catalog.Article.Logic.TArticleDraftItem;

interface

type
  TArticleDraftItem = record
  private
    FId_ArticleDraft: Integer;
    FId_Article: Variant;
    FId_TradeMark: Integer;
    FNumber: string;
    FNumberShort: string;
    FId_ArticleNorm: Variant;
    FName: string;
    FDescription: string;
    FVersion: Variant;
    procedure SetDescription(const aValue: string);
    procedure SetId_Article(const aValue: Variant);
    procedure SetId_ArticleDraft(const aValue: Integer);
    procedure SetId_ArticleNorm(const aValue: Variant);
    procedure SetId_TradeMark(const aValue: Integer);
    procedure SetName(const aValue: string);
    procedure SetNumber(const aValue: string);
    procedure SetNumberShort(const aValue: string);
    procedure SetVersion(const aValue: Variant);
  public
    procedure SetDefault;
    property Id_ArticleDraft: Integer read FId_ArticleDraft write SetId_ArticleDraft;
    property Id_Article: Variant read FId_Article write SetId_Article;
    property Id_TradeMark: Integer read FId_TradeMark write SetId_TradeMark;
    property Number: string read FNumber write SetNumber;
    property NumberShort: string read FNumberShort write SetNumberShort;
    property Id_ArticleNorm: Variant read FId_ArticleNorm write SetId_ArticleNorm;
    property Name: string read FName write SetName;
    property Description: string read FDescription write SetDescription;
    property Version: Variant read FVersion write SetVersion;
  end;

implementation

uses
  System.Variants;

{ TArticleDraftItem }

procedure TArticleDraftItem.SetDefault;
begin
  FId_ArticleDraft := 0;
  FId_Article := Null();
  FId_TradeMark := 0;
  FNumber := '';
  FNumberShort := '';
  FId_ArticleNorm := 0;
  FName := '';
  FDescription := '';
  FVersion := Null();
end;

procedure TArticleDraftItem.SetDescription(const aValue: string);
begin
  FDescription := aValue;
end;

procedure TArticleDraftItem.SetId_Article(const aValue: Variant);
begin
  FId_Article := aValue;
end;

procedure TArticleDraftItem.SetId_ArticleDraft(const aValue: Integer);
begin
  FId_ArticleDraft := aValue;
end;

procedure TArticleDraftItem.SetId_ArticleNorm(const aValue: Variant);
begin
  FId_ArticleNorm := aValue;
end;

procedure TArticleDraftItem.SetId_TradeMark(const aValue: Integer);
begin
  FId_TradeMark := aValue;
end;

procedure TArticleDraftItem.SetName(const aValue: string);
begin
  FName := aValue;
end;

procedure TArticleDraftItem.SetNumber(const aValue: string);
begin
  FNumber := aValue;
end;

procedure TArticleDraftItem.SetNumberShort(const aValue: string);
begin
  FNumberShort := aValue;
end;

procedure TArticleDraftItem.SetVersion(const aValue: Variant);
begin
  FVersion := aValue;
end;

end.
