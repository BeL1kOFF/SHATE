unit ShateM.Utils.MSSQL;

interface

uses
  System.SysUtils;

type
  TMSSQLFieldType = (mftUnknown, mftTinyInt, mftSmallInt, mftInt, mftBigInt, mftDecimal, mftNumeric, mftBit,
    mftSmallMoney, mftMoney, mftFloat, mftReal, mftDate, mftTime, mftSmallDateTime, mftDateTime, mftDateTime2,
    mftDateTimeOffset, mftChar, mftVarChar, mftNChar, mftNVarChar, mftBinary, mftVarBinary, mftUniqueidentifier,
    mftImage, mftText, mftNText);

  TMSSQLFieldTypeHelper = record helper for TMSSQLFieldType
  public
    class function GetMSSQLFieldTypeFromString(const aValue: string): TMSSQLFieldType; static;
  end;

  EMSSQLFieldType = class(Exception);

implementation

uses
  System.TypInfo;

{ TMSSQLFieldTypeHelper }

class function TMSSQLFieldTypeHelper.GetMSSQLFieldTypeFromString(const aValue: string): TMSSQLFieldType;
var
  P: PTypeInfo;
  Res: Integer;
begin
  P := TypeInfo(TMSSQLFieldType);
  Res := GetEnumValue(P, 'mft' + aValue);
  if Res = -1 then
    raise EMSSQLFieldType.Create('Некорректный тип MSSQL');
  Result := TMSSQLFieldType(Res);
end;

end.
