unit MDM.Package.Classes.TParserHtml;

interface

uses
  Data.DB;

type
  TOnBeforeParseFieldEvent = procedure(aField: TField; var aDocument: string; var aHandled: Boolean) of object;

  TParserHtml = class
  private
    FDataSet: TDataSet;
    FOnBeforeParseField: TOnBeforeParseFieldEvent;
  public
    constructor Create(aDataSet: TDataSet);
    function Parse(const aDocument: string): string;
    property OnBeforeParseField: TOnBeforeParseFieldEvent read FOnBeforeParseField write FOnBeforeParseField;
  end;

implementation

uses
  System.Variants,
  System.SysUtils;

{ TParserHtml }

constructor TParserHtml.Create(aDataSet: TDataSet);
begin
  FDataSet := aDataSet;
end;

function TParserHtml.Parse(const aDocument: string): string;
var
  k: Integer;
  Handled: Boolean;
begin
  Result := aDocument;
  for k := 0 to FDataSet.FieldCount - 1 do
    if not VarIsNull(FDataSet.Fields.Fields[k].AsVariant) then
    begin
      Handled := False;
      if Assigned(FOnBeforeParseField) then
        FOnBeforeParseField(FDataSet.Fields.Fields[k], Result, Handled);
      if not Handled then
        Result := StringReplace(Result, '<!-- #' + FDataSet.Fields.Fields[k].FieldName + '# -->', FDataSet.Fields.Fields[k].AsVariant, [rfReplaceAll, rfIgnoreCase]);
    end;
end;

end.
