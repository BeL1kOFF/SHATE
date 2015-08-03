unit MDM.Package.CustomForm.TcxGridTableViewHelper;

interface

uses
  System.Classes,
  cxGridTableView;

type
  TcxGridColumnField = class(TcxGridColumn)
  strict private
    FFieldName: string;
    FFieldType: string;
    FFieldSize: Integer;
    FIsMeta: Boolean;
  public
    constructor Create(aValue: TComponent); override;
    property FieldName: string read FFieldName write FFieldName;
    property FieldType: string read FFieldType write FFieldType;
    property FieldSize: Integer read FFieldSize write FFieldSize;
    property IsMeta: Boolean read FIsMeta write FIsMeta;
  end;

  TcxGridTableViewHelper = class helper for TcxGridTableView
  private
    function GetColumns(aIndex: Integer): TcxGridColumnField;
    procedure SetColumns(aIndex: Integer; const aValue: TcxGridColumnField);
  public
    function CreateColumnField: TcxGridColumnField;
    function FindItemByFieldName(const aFieldName: string): TcxGridColumnField;
    function FindItemByName(const aName: string): TcxGridColumnField;
    property Columns[aIndex: Integer]: TcxGridColumnField read GetColumns write SetColumns;
  end;

implementation

{ TcxGridColumnField }

constructor TcxGridColumnField.Create(aValue: TComponent);
begin
  inherited Create(aValue);
  FFieldName := '';
  FFieldType := '';
  FFieldSize := 0;
  FIsMeta := False;
end;

{ TcxGridTableViewHelper }

function TcxGridTableViewHelper.CreateColumnField: TcxGridColumnField;
begin
  Result := TcxGridColumnField.Create(Owner);
  AddItem(Result);
end;

function TcxGridTableViewHelper.FindItemByFieldName(const aFieldName: string): TcxGridColumnField;
var
  k: Integer;
begin
  for k := 0 to ItemCount - 1 do
  begin
    Result := Items[k] as TcxGridColumnField;
    if Result.FieldName = aFieldName then
      Exit;
  end;
  Result := nil;
end;

function TcxGridTableViewHelper.FindItemByName(const aName: string): TcxGridColumnField;
begin
  Result := (inherited FindItemByName(aName)) as TcxGridColumnField;
end;

function TcxGridTableViewHelper.GetColumns(aIndex: Integer): TcxGridColumnField;
begin
  Result := inherited Columns[aIndex] as TcxGridColumnField;
end;

procedure TcxGridTableViewHelper.SetColumns(aIndex: Integer; const aValue: TcxGridColumnField);
begin
  inherited Columns[aIndex] := aValue;
end;

end.
