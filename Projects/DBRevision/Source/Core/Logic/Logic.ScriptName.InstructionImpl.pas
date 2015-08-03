unit Logic.ScriptName.InstructionImpl;

interface

uses
  Logic.ScriptName.TInstruction,
  Logic.ScriptName.TInstructionBehavior;

type
  TInstructionCAD = class(TInstructionBehavior)
  public
    class constructor Create;
  end;

  TInstructionProcedure = class(TInstructionCAD)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  end;

  TInstructionFunction = class(TInstructionCAD)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  end;

  TInstructionTrigger = class(TInstructionCAD)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  end;

  TInstructionSynonim = class(TInstructionCAD)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  end;

  TInstructionView = class(TInstructionCAD)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  end;

  TInstructionTable = class(TInstructionCAD)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  public
    class constructor Create;
  end;

  TInstructionIndex = class(TInstructionBehavior)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  public
    class constructor Create;
  end;

  TInstructionUniqueNonclusteredIndex = class(TInstructionBehavior)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  public
    class constructor Create;
  end;

  TInstructionUniqueIndex = class(TInstructionBehavior)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  public
    class constructor Create;
  end;

  TInstructionNonclusteredIndex = class(TInstructionBehavior)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  public
    class constructor Create;
  end;

  TInstructionSelect = class(TInstruction)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  end;

  TInstructionUpdate = class(TInstruction)
  protected
    function GetObjectName: string; override;
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  end;

  TInstructionInsert = class(TInstruction)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  end;

  TInstructionDelete = class(TInstruction)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  end;

  TInstructionWith = class(TInstruction)
  protected
    class function GetInstruction: string; override;
    class function GetPrefix: string; override;
  end;

implementation

uses
  System.SysUtils,
  Logic.ScriptName.TInstructionRegisterList,
  Logic.ScriptName.InstructionActionImpl;

{ TInstructionCAD }

class constructor TInstructionCAD.Create;
begin
  RegisterInstructionAction(TInstructionCreate.Create());
  RegisterInstructionAction(TInstructionAlter.Create());
  RegisterInstructionAction(TInstructionDrop.Create());
end;

{ TInstructionProcedure }

class function TInstructionProcedure.GetInstruction: string;
begin
  Result := 'PROCEDURE';
end;

class function TInstructionProcedure.GetPrefix: string;
begin
  Result := 'PROC';
end;

{ TInstructionFunction }

class function TInstructionFunction.GetInstruction: string;
begin
  Result := 'FUNCTION';
end;

class function TInstructionFunction.GetPrefix: string;
begin
  Result := 'FUNC';
end;

{ TInstructionTrigger }

class function TInstructionTrigger.GetInstruction: string;
begin
  Result := 'TRIGGER';
end;

class function TInstructionTrigger.GetPrefix: string;
begin
  Result := 'TR';
end;

{ TInstructionSynonim }

class function TInstructionSynonim.GetInstruction: string;
begin
  Result := 'SYNONYM';
end;

class function TInstructionSynonim.GetPrefix: string;
begin
  Result := 'SYN';
end;

{ TInstructionView }

class function TInstructionView.GetInstruction: string;
begin
  Result := 'VIEW';
end;

class function TInstructionView.GetPrefix: string;
begin
  Result := 'VIEW';
end;

{ TInstructionTable }

class constructor TInstructionTable.Create;
begin
  RegisterInstructionAction(TInstructionTruncate.Create());
end;

class function TInstructionTable.GetInstruction: string;
begin
  Result := 'TABLE';
end;

class function TInstructionTable.GetPrefix: string;
begin
  Result := 'TBL';
end;

{ TInstructionIndex }

class constructor TInstructionIndex.Create;
begin
  RegisterInstructionAction(TInstructionCreate.Create());
  RegisterInstructionAction(TInstructionDrop.Create());
end;

class function TInstructionIndex.GetInstruction: string;
begin
  Result := 'INDEX';
end;

class function TInstructionIndex.GetPrefix: string;
begin
  Result := 'IX';
end;

{ TInstructionUniqueNonclusteredIndex }

class constructor TInstructionUniqueNonclusteredIndex.Create;
begin
  RegisterInstructionAction(TInstructionCreate.Create());
end;

class function TInstructionUniqueNonclusteredIndex.GetInstruction: string;
begin
  Result := 'UNIQUE NONCLUSTERED INDEX';
end;

class function TInstructionUniqueNonclusteredIndex.GetPrefix: string;
begin
  Result := 'UQ';
end;

{ TInstructionUniqueIndex }

class constructor TInstructionUniqueIndex.Create;
begin
  RegisterInstructionAction(TInstructionCreate.Create());
end;

class function TInstructionUniqueIndex.GetInstruction: string;
begin
  Result := 'UNIQUE INDEX';
end;

class function TInstructionUniqueIndex.GetPrefix: string;
begin
  Result := 'UQ';
end;

{ TInstructionNonclusteredIndex }

class constructor TInstructionNonclusteredIndex.Create;
begin
  RegisterInstructionAction(TInstructionCreate.Create());
end;

class function TInstructionNonclusteredIndex.GetInstruction: string;
begin
  Result := 'NONCLUSTERED INDEX';
end;

class function TInstructionNonclusteredIndex.GetPrefix: string;
begin
  Result := 'IX';
end;

{ TInstructionSelect }

class function TInstructionSelect.GetInstruction: string;
begin
  Result := 'SELECT';
end;

class function TInstructionSelect.GetPrefix: string;
begin
  Result := 'SEL';
end;

{ TInstructionUpdate }

class function TInstructionUpdate.GetInstruction: string;
begin
  Result := 'UPDATE';
end;

function TInstructionUpdate.GetObjectName: string;
var
  InstructionPos: Integer;
  SetPos: Integer;
  FromPos: Integer;
begin
  InstructionPos := Pos(GetInstruction(), BodyString);
  SetPos := Pos('SET', BodyString, InstructionPos);
  FromPos := Pos('FROM', BodyString, SetPos);
  if FromPos = 0 then
    Result := Copy(BodyString, FromPos + Length(GetInstruction()) + 1, Length(BodyString))
  else
    Result := Copy(BodyString, FromPos + Length('FROM') + 1, Length(BodyString));
  Result := ParseObjectName(Trim(Result));
end;

class function TInstructionUpdate.GetPrefix: string;
begin
  Result := 'UPD';
end;

{ TInstructionInsert }

class function TInstructionInsert.GetInstruction: string;
begin
  Result := 'INSERT INTO';
end;

class function TInstructionInsert.GetPrefix: string;
begin
  Result := 'INS';
end;

{ TInstructionDelete }

class function TInstructionDelete.GetInstruction: string;
begin
  Result := 'DELETE FROM';
end;

class function TInstructionDelete.GetPrefix: string;
begin
  Result := 'DEL';
end;

{ TInstructionWith }

class function TInstructionWith.GetInstruction: string;
begin
  Result := 'WITH';
end;

class function TInstructionWith.GetPrefix: string;
begin
  Result := 'WTH';
end;

initialization
  InstructionRegisterList.RegisterInstructionBehavior([TInstructionProcedure, TInstructionFunction, TInstructionTrigger,
    TInstructionSynonim, TInstructionView, TInstructionTable, TInstructionIndex, TInstructionUniqueNonclusteredIndex,
    TInstructionUniqueIndex, TInstructionNonclusteredIndex, TInstructionSelect, TInstructionUpdate, TInstructionInsert,
    TInstructionDelete, TInstructionWith]);

end.
