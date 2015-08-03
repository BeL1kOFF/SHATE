unit Logic.ScriptName.TInstructionBehavior;

interface

uses
  System.Classes,
  System.Generics.Collections,
  Logic.ScriptName.IInstructionAction,
  Logic.ScriptName.TInstruction;

type
  TInstructionBehavior = class(TInstruction)
  private class var
    FListAction: TDictionary<string, TList<IInstructionAction>>;
    class function GetAction(aBody: TStrings): IInstructionAction;
  protected
    function GetScriptName: string; override;
    class procedure RegisterInstructionAction(aInstructionAction: IInstructionAction);
  public
    class constructor Create;
    class destructor Destroy;
    class function IsAppropriateClass(aBody: TStrings): Boolean; override;
  end;

implementation

uses
  System.SysUtils;

{ TInstructionBehavior }

class constructor TInstructionBehavior.Create;
begin
  FListAction := TDictionary<string, TList<IInstructionAction>>.Create();
end;

class destructor TInstructionBehavior.Destroy;
var
  Pair: TPair<string, TList<IInstructionAction>>;
begin
  for Pair in FListAction do
    Pair.Value.Free();
  FListAction.Free();
end;

class function TInstructionBehavior.GetAction(aBody: TStrings): IInstructionAction;

  function FindAction(aClassType: TClass): IInstructionAction; overload;
  var
    k, i: Integer;
    List: TList<IInstructionAction>;
  begin
    if FListAction.ContainsKey(aClassType.ClassName) then
    begin
      List := FListAction.Items[aClassType.ClassName];
      for i := 0 to aBody.Count - 1 do
        for k := 0 to List.Count - 1 do
          if aBody.Strings[i].Contains(Format('%s %s', [List.Items[k].GetName(), GetInstruction()])) then
            Exit(List.Items[k]);
    end;
    if aClassType.ClassParent <> nil then
      Result := FindAction(aClassType.ClassParent);
  end;

begin
  Result := FindAction(Self);
end;

function TInstructionBehavior.GetScriptName: string;
begin
  Result := Format('%s_%s', [GetAction(Body).GetPrefix(), inherited GetScriptName()]);
end;

class function TInstructionBehavior.IsAppropriateClass(aBody: TStrings): Boolean;
begin
  Result := Assigned(GetAction(aBody));
end;

class procedure TInstructionBehavior.RegisterInstructionAction(aInstructionAction: IInstructionAction);
var
  List: TList<IInstructionAction>;
begin
  if not FListAction.ContainsKey(ClassName) then
  begin
    List := TList<IInstructionAction>.Create();
    FListAction.Add(ClassName, List);
  end
  else
    List := FListAction.Items[ClassName];
  List.Add(aInstructionAction);
end;

end.
