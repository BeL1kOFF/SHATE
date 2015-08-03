unit USysGlobal;

interface

uses
  Classes, SysUtils, Windows, Forms, Controls;

type
  T3State = (tsFalse, tsTrue, tsUnknown);

  ENormal = class(Exception)
  end;

  EUserAbort = class(ENormal)
  end;

  ENormalWarn = class(ENormal)
  end;

  ENormalErr = class(ENormal)
  end;

  TStringAs = class
  private
    FValue: string;
    procedure SetValue(const Value: string);
  public
    constructor Create(const aValue: string);

    function AsInteger(const aDef: Integer = 0): Integer;
    function AsBoolean(const aDef: Boolean = False): Boolean;
    function AsDouble(const aDef: Double = 0.0): Double;
    property Value: string read FValue write SetValue;
  end;

function HasBeenHere(var aValue: Boolean): Boolean;
function IsKeyDown(aKey: Integer): Boolean;

function GetAppDir: string;
function GetWinTempDir: string;
function GetAppHandle: THandle;

procedure EnableControls(aEnable: Boolean; aControls: array of TWinControl; aRecursive: Boolean);
procedure ShowControls(aShow: Boolean; aControls: array of TControl);

function StrToFloatUnic(const aValue: string): Double;
function StrToFloatDefUnic(const aValue: string; aDef: Extended): Double;
function StrGetName(const aValue: string): string;
function StrGetValue(const aValue: string): string;
procedure StrArray2Strings(const aSource: array of string; aDest: TStrings);

function  MsgBox(const aText: string; const aCaption: string = ''; Flags: Longint = MB_OK): Integer;
procedure MsgBoxErr(const aText: string; const aCaption: string = 'Ошибка');
procedure MsgBoxWarn(const aText: string; const aCaption: string = 'Внимание');
procedure MsgBoxInfo(const aText: string; const aCaption: string = '');
function  MsgBoxYN(const aText: string; const aCaption: string = ''): Boolean;
procedure RaiseWarn(const aMessage: string);
procedure RaiseErr(const aMessage: string);

function cif(v: Boolean; a, b: Cardinal): Cardinal; overload;
function cif(v: Boolean; a, b: Double): Double; overload;
function cif(v: Boolean; const a, b: string): string; overload;
//function cif(v: Boolean; const a, b: TColor): TColor; overload;

function toStr(const aValue: Integer): string; overload;
function toStr(const aValue: Double): string; overload;
function toStr(const aValue: Boolean): string; overload;

function StrAs(const aValue: string): TStringAs;

function makeList: TList;
function makeStrings: TStringList;
function GenerateGUID: string;

function EqStr(const a, b: string; aCaseSens: Boolean = False): Boolean;
function StrPlus(const aPrev, aSeparator, aNext: string): string;

procedure FreeAndNil(var aObj: TObject); {overload;}
//procedure FreeAndNil(aObjs: array of TObject); overload;

implementation

function HasBeenHere(var aValue: Boolean): Boolean;
begin
  Result := aValue;
  if not aValue then
    aValue := True;
end;

function IsKeyDown(aKey: Integer): Boolean;
begin
  Result := (GetKeyState(aKey) and 128) <> 0;
end;

function GetAppDir: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

function GetWinTempDir: string;
var
  buf: PChar;
  aSize: Integer;
begin
  Result := '';
  GetMem(buf, 512);
  ZeroMemory(buf, 512);
  try
    aSize := GetTempPath(511, buf);
    if aSize = 0 then
      Exit;

    if aSize > 511 then //не хватило размера буфера
    begin
      FreeMem(buf);
      GetMem(buf, aSize + 1);
      ZeroMemory(buf, aSize + 1);
      GetTempPath(aSize, buf);
    end;
    Result := StrPas(buf);
  finally
    FreeMem(buf);
  end;
end;

function GetAppHandle: THandle;
begin
  if Assigned(Application) and Assigned(Application.MainForm) then
    Result := Application.MainForm.Handle
  else
    Result := 0;
end;

procedure EnableControls(aEnable: Boolean;
  aControls: array of TWinControl; aRecursive: Boolean);
var
  i: Integer;
  j: Integer;
begin
  for i := Low(aControls) to High(aControls) do
  begin
    aControls[i].Enabled := aEnable;

    if (aRecursive) then
      for j := 0 to aControls[i].ControlCount - 1 do
        if aControls[i].Controls[j] is TWinControl then
          EnableControls(aEnable, [aControls[i].Controls[j] as TWinControl], True);
  end;
end;

procedure ShowControls(aShow: Boolean; aControls: array of TControl);
var
  i: Integer;
begin
  for i := Low(aControls) to High(aControls) do
    aControls[i].Visible := aShow;
end;

function StrToFloatUnic(const aValue: string): Double;
var
  aNorm: string;
begin
  aNorm := aValue;
  if DecimalSeparator <> '.' then
    aNorm := StringReplace(aNorm, '.', DecimalSeparator, [rfReplaceAll]);
  if DecimalSeparator <> ',' then
    aNorm := StringReplace(aNorm, ',', DecimalSeparator, [rfReplaceAll]);
  Result := StrToFloat(aNorm);
end;

function StrToFloatDefUnic(const aValue: string; aDef: Extended): Double;
var
  aNorm: string;
begin
  aNorm := aValue;
  if DecimalSeparator <> '.' then
    aNorm := StringReplace(aNorm, '.', DecimalSeparator, [rfReplaceAll]);
  if DecimalSeparator <> ',' then
    aNorm := StringReplace(aNorm, ',', DecimalSeparator, [rfReplaceAll]);
  Result := StrToFloatDef(aNorm, aDef);
end;

function StrGetName(const aValue: string): string;
var
  p: Integer;
begin
  p := POS('=', aValue);
  if p > 0 then
    Result := Copy(aValue, 1, p - 1)
  else
    Result := aValue;
end;

function StrGetValue(const aValue: string): string;
var
  p: Integer;
begin
  p := POS('=', aValue);
  if p > 0 then
    Result := Copy(aValue, p + 1, MAXINT)
  else
    Result := '';
end;

procedure StrArray2Strings(const aSource: array of string; aDest: TStrings);
var
  i: Integer;
begin
  if not Assigned(aDest) then
    Exit;

  for i := Low(aSource) to High(aSource) do
    aDest.Add(aSource[i]);
end;


function GenerateGUID: string;
var
  aGUID: TGUID;
begin
  CreateGUID(aGUID);
  Result := GUIDToString(aGUID);
end;

function StrAs(const aValue: string): TStringAs;
begin
  Result := TStringAs.Create(aValue);
end;

function cif(v: Boolean; a, b: Cardinal): Cardinal; overload;
begin
  if v then
    Result := a
  else
    Result := b;
end;

function cif(v: Boolean; const a, b: string): string; overload;
begin
  if v then
    Result := a
  else
    Result := b;
end;

function cif(v: Boolean; a, b: Double): Double; overload;
begin
  if v then
    Result := a
  else
    Result := b;
end;

{function cif(v: Boolean; const a, b: TColor): TColor; overload;
begin
  if v then
    Result := a
  else
    Result := b;
end;
 }
function toStr(const aValue: Integer): string; overload;
begin
  Result := IntToStr(aValue);
end;

function toStr(const aValue: Double): string; overload;
begin
  Result := FormatFloat('0.000000', aValue);
end;

function toStr(const aValue: Boolean): string; overload;
begin
  Result := cif(aValue, '1', '0');
end;


function MsgBox(const aText: string; const aCaption: string = ''; Flags: Longint = MB_OK): Integer;
var
  aCapt: string;
begin
  if aCaption = '' then
    aCapt := Application.Title
  else
    aCapt := aCaption;
  Result := Application.MessageBox(PChar(aText), PChar(aCapt), Flags);
end;

procedure MsgBoxErr(const aText: string; const aCaption: string);
begin
  MsgBox(aText, aCaption, MB_OK or MB_ICONERROR);
end;

procedure MsgBoxWarn(const aText: string; const aCaption: string);
begin
  MsgBox(aText, aCaption, MB_OK or MB_ICONWARNING);
end;

procedure MsgBoxInfo(const aText: string; const aCaption: string);
begin
  MsgBox(aText, aCaption, MB_OK or MB_ICONINFORMATION);
end;

function MsgBoxYN(const aText: string; const aCaption: string): Boolean;
begin
  Result := MsgBox(aText, aCaption, MB_YESNO or MB_ICONQUESTION) = IDYES;
end;

procedure RaiseWarn(const aMessage: string);
begin
  raise ENormalWarn.Create(aMessage);
end;
procedure RaiseErr(const aMessage: string);
begin
  raise ENormalErr.Create(aMessage);
end;

function makeList: TList;
begin
  Result := TList.Create;
end;

function makeStrings: TStringList;
begin
  Result := TStringList.Create;
end;

function EqStr(const a, b: string; aCaseSens: Boolean = False): Boolean;
begin
  Result := (not aCaseSens) and (CompareText(a, b) = 0) or
            (aCaseSens) and (CompareStr(a, b) = 0);
end;

function StrPlus(const aPrev, aSeparator, aNext: string): string;
begin
  if aPrev = '' then
    Result := aNext
  else if aNext = '' then
    Result := aPrev
  else
    Result := aPrev + aSeparator + aNext;
end;

procedure FreeAndNil(var aObj: TObject);
begin
  if not Assigned(aObj) then
    Exit;
  aObj.Free;
  aObj := nil;
end;
{
procedure FreeAndNil(aObjs: array of TObject);
var
  i: Integer;
begin
  for i := Low(aObjs) to High(aObjs) do
    FreeAndNil(aObjs[i]);
end;
}
{ TStringAs }

constructor TStringAs.Create(const aValue: string);
begin
  FValue := aValue;
end;

procedure TStringAs.SetValue(const Value: string);
begin
  FValue := Value;
end;


function TStringAs.AsBoolean(const aDef: Boolean): Boolean;
begin
  if FValue = '1' then
    Result := True
  else
    if FValue = '0' then
      Result := False
    else
      Result := aDef;
end;

function TStringAs.AsDouble(const aDef: Double): Double;
begin
  Result := StrToFloatDef(FValue, aDef);
end;

function TStringAs.AsInteger(const aDef: Integer): Integer;
begin
  Result := StrToIntDef(FValue, aDef);
end;

end.
