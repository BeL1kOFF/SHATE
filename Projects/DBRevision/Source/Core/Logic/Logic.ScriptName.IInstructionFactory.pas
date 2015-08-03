unit Logic.ScriptName.IInstructionFactory;

interface

uses
  Logic.ScriptName.IInstruction;

type
  IInstructionFactory = interface
  ['{BA040278-7642-4F40-99AF-E8B75DAE827E}']
    function GetInstruction: IInstruction;
  end;

implementation

end.
