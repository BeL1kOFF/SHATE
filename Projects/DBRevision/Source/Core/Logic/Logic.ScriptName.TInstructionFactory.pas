unit Logic.ScriptName.TInstructionFactory;

interface

uses
  System.Classes,
  Logic.ScriptName.IInstructionFactory,
  Logic.ScriptName.IInstruction;

type
  TInstructionFactory = class(TInterfacedObject, IInstructionFactory)
  private
    FBody: TStrings;
    function GetInstruction: IInstruction;
    procedure BodyProcessing;
  public
    constructor Create(aBody: TStrings);
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils,
  Logic.ScriptName.TInstructionRegisterList;

{ TInstructionFactory }

procedure TInstructionFactory.BodyProcessing;
begin
  while FBody.Text.Contains(#$09) do
    FBody.Text := FBody.Text.Replace(#$09, ' ');
  while FBody.Text.Contains('  ') do
    FBody.Text := FBody.Text.Replace('  ', ' ');
end;

constructor TInstructionFactory.Create(aBody: TStrings);
begin
  FBody := TStringList.Create();
  FBody.Assign(aBody);
  BodyProcessing();
end;

destructor TInstructionFactory.Destroy;
begin
  FBody.Free();
  inherited Destroy();
end;

function TInstructionFactory.GetInstruction: IInstruction;
var
  k, i: Integer;
  LocalBody: TStrings;
begin
  LocalBody := TStringList.Create();
  try
    for i := 0 to FBody.Count - 1 do
    begin
      LocalBody.Text := FBody.Strings[i];
      for k := 0 to InstructionRegisterList.Count - 1 do
        if InstructionRegisterList.Items[k].IsAppropriateClass(LocalBody) then
          Exit(InstructionRegisterList.Items[k].Create(FBody));
    end;
  finally
    LocalBody.Free;
  end;
end;

end.
