unit Velcom.ISQLCursor;

interface

uses
  Controls;

type

  ISQLCursor = interface
  ['{0957B6B5-A0F2-44E3-8E62-D627D0B3D45B}']
  end;

  TSQLCursor = class(TInterfacedObject, ISQLCursor)
  private
    FOldCursor: TCursor;
  public
    constructor Create;
    destructor Destroy;override;
  end;

  function CreateSQLCursor: ISQLCursor;

implementation

uses
  Forms;

function CreateSQLCursor: ISQLCursor;
begin
  Result := TSQLCursor.Create;
end;

procedure SetSQLCursor;
begin
  Screen.Cursor := crSQLWait;
end;

{ TSQLCursor }

constructor TSQLCursor.Create;
begin
  FOldCursor := Screen.Cursor;
  SetSQLCursor;
end;

destructor TSQLCursor.Destroy;
begin
  Screen.Cursor := FOldCursor;
  inherited;
end;

end.
