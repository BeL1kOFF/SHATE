unit Logic.ScriptName.TInstruction;

interface

uses
  System.Classes,
  Logic.ScriptName.IInstruction;

type
  TInstruction = class(TInterfacedObject, IInstruction)
  private
    FBody: TStrings;
    FBodyString: string;
    procedure BodyStringProcessing;
  protected
    function GetObjectName: string; virtual;
    function GetScriptName: string; virtual;
    function ParseObjectName(const aString: string): string;
    class function GetInstruction: string; virtual; abstract;
    class function GetPrefix: string; virtual; abstract;
    property Body: TStrings read FBody;
    property BodyString: string read FBodyString;
  public
    constructor Create(aBody: TStrings); virtual;
    class function IsAppropriateClass(aBody: TStrings): Boolean; virtual;
  end;

  TInstructionClass = class of TInstruction;

implementation

uses
  System.SysUtils;

{ TInstruction }

procedure TInstruction.BodyStringProcessing;
begin
  FBodyString := FBody.Text;
  while FBodyString.Contains(#13) do
    FBodyString := FBodyString.Replace(#13, ' ');
  while FBodyString.Contains(#10) do
    FBodyString := FBodyString.Replace(#10, ' ');
  while FBodyString.Contains('  ') do
    FBodyString := FBodyString.Replace('  ', ' ');
end;

constructor TInstruction.Create(aBody: TStrings);
begin
  FBody := aBody;
  BodyStringProcessing();
end;

function TInstruction.GetObjectName: string;
var
  Instruction: string;
  PosIndex: Integer;
begin
  Instruction := GetInstruction();
  PosIndex := Pos(Instruction, FBody.Text);
  Result := Copy(FBody.Text, PosIndex + Length(Instruction) + 1, Length(FBody.Text));
  Result := ParseObjectName(Result);
end;

function TInstruction.GetScriptName: string;
begin
  Result := Format('%s %s', [GetPrefix(), GetObjectName()]);
end;

class function TInstruction.IsAppropriateClass(aBody: TStrings): Boolean;
var
  k: Integer;
begin
  for k := 0 to aBody.Count - 1 do
    if aBody.Strings[k].Contains(GetInstruction()) then
      Exit(True);
  Result := False;
end;

function TInstruction.ParseObjectName(const aString: string): string;
const
  SETCHAR: TSysCharSet = ['a'..'z', 'A'..'Z', '_', '@', '#', '0'..'9', '$',
    'à', 'á', 'â', 'ã', 'ä', 'å', '¸', 'æ', 'ç', 'è', 'é', 'ê', 'ë', 'ì', 'í', 'î', 'ï', 'ð', 'ñ', 'ò', 'ó', 'ô', 'õ',
    'ö', '÷', 'ø', 'ù', 'ü', 'û', 'ú', 'ý', 'þ', 'ÿ', 'À', 'Á', 'Â', 'Ã', 'Ä', 'Å', '¨', 'Æ', 'Ç', 'È', 'É', 'Ê', 'Ë',
    'Ì', 'Í', 'Î', 'Ï', 'Ð', 'Ñ', 'Ò', 'Ó', 'Ô', 'Õ', 'Ö', '×', 'Ø', 'Ù', 'Ü', 'Û', 'Ú', 'Ý', 'Þ', 'ß'];

var
  k: Integer;
  RSBIndex: Integer;
begin
  if aString[1] = '[' then
  begin
    RSBIndex := Pos(']', aString);
    if Length(aString) = RSBIndex then
      Result := Copy(aString, 2, RSBIndex - 2)
    else
      if aString[RSBIndex + 1] = '.' then
        Result := ParseObjectName(Copy(aString, RSBIndex + 2, Length(aString)))
      else
        Result := Copy(aString, 2, RSBIndex - 2);
  end
  else
  begin
    Result := '';
    for k := 1 to Length(aString) do
    begin
      if CharInSet(aString[k], SETCHAR) then
        Result := Result + aString[k]
      else
        if aString[k] = '.' then
        begin
          Result := ParseObjectName(Copy(aString, k + 1, Length(aString)));
          Break;
        end
        else
          Break;
    end;
  end;
end;

end.
