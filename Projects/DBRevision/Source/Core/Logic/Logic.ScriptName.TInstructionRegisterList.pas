unit Logic.ScriptName.TInstructionRegisterList;

interface

uses
  System.Generics.Collections,
  Logic.ScriptName.TInstruction;

type
  TInstructionRegisterList = class
  private
    FList: TList<TInstructionClass>;
    function GetCount: Integer;
    function GetItems(aIndex: Integer): TInstructionClass;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterInstructionBehavior(aInstructionBehavior: TInstructionClass); overload;
    procedure RegisterInstructionBehavior(aInstructionBehavior: array of TInstructionClass); overload;
    procedure UnRegisterInstructionBehavior(aInstructionBehavior: TInstructionClass);
    property Count: Integer read GetCount;
    property Items[aIndex: Integer]: TInstructionClass read GetItems;
  end;

var
  InstructionRegisterList: TInstructionRegisterList;

implementation

{ TInstructionRegisterList }

constructor TInstructionRegisterList.Create;
begin
  FList := TList<TInstructionClass>.Create();
end;

destructor TInstructionRegisterList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function TInstructionRegisterList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TInstructionRegisterList.GetItems(aIndex: Integer): TInstructionClass;
begin
  Result := FList.Items[aIndex];
end;

procedure TInstructionRegisterList.RegisterInstructionBehavior(aInstructionBehavior: array of TInstructionClass);
var
  k: Integer;
begin
  for k := Low(aInstructionBehavior) to High(aInstructionBehavior) do
    RegisterInstructionBehavior(aInstructionBehavior[k]);
end;

procedure TInstructionRegisterList.RegisterInstructionBehavior(aInstructionBehavior: TInstructionClass);
begin
  FList.Add(aInstructionBehavior);
end;

procedure TInstructionRegisterList.UnRegisterInstructionBehavior(aInstructionBehavior: TInstructionClass);
begin
  FList.Remove(aInstructionBehavior);
end;

initialization
  InstructionRegisterList := TInstructionRegisterList.Create();

finalization
  InstructionRegisterList.Free();

end.
