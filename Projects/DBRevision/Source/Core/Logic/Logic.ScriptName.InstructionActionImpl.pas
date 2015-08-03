unit Logic.ScriptName.InstructionActionImpl;

interface

uses
  Logic.ScriptName.IInstructionAction;

type
  // Instruction Actions

  TInstructionCreate = class(TInterfacedObject, IInstructionAction)
  private
    function GetName: string;
    function GetPrefix: string;
  end;

  TInstructionAlter = class(TInterfacedObject, IInstructionAction)
  private
    function GetName: string;
    function GetPrefix: string;
  end;

  TInstructionDrop = class(TInterfacedObject, IInstructionAction)
  private
    function GetName: string;
    function GetPrefix: string;
  end;

  TInstructionTruncate = class(TInterfacedObject, IInstructionAction)
  private
    function GetName: string;
    function GetPrefix: string;
  end;

implementation

{ TInstructionCreate }

function TInstructionCreate.GetName: string;
begin
  Result := 'CREATE';
end;

function TInstructionCreate.GetPrefix: string;
begin
  Result := 'CRT';
end;

{ TInstructionAlter }

function TInstructionAlter.GetName: string;
begin
  Result := 'ALTER';
end;

function TInstructionAlter.GetPrefix: string;
begin
  Result := 'ALT';
end;

{ TInstructionDrop }

function TInstructionDrop.GetName: string;
begin
  Result := 'DROP';
end;

function TInstructionDrop.GetPrefix: string;
begin
  Result := 'DRP';
end;

{ TInstructionTruncate }

function TInstructionTruncate.GetName: string;
begin
  Result := 'TRUNCATE';
end;

function TInstructionTruncate.GetPrefix: string;
begin
  Result := 'DEL';
end;

end.
