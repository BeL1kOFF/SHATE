unit ConfigPackage.Logic.TDefaultValueAttribute;

interface

uses
  System.Rtti;

type
  /// <summary>
  /// Класс аттрибута для хранения значения по-умолчанию для свойства
  /// </summary>
  /// <remarks>
  /// <para>
  /// <b>Пример использования:</b>
  /// </para>
  /// <para>
  /// [TDefaultValue('<i>значение</i>')]
  /// </para>
  /// <para>
  /// [TDefaultValue(<i>True</i>)]
  /// </para>
  /// <para>
  /// [TDefaultValue(<i>22</i>)]
  /// </para>
  /// </remarks>
  TDefaultValueAttribute = class(TCustomAttribute)
  public
    /// <summary>
    /// Конструктор класса для значений типа <b>Integer</b>
    /// </summary>
    /// <param name="AValue">
    /// Значение по-умолчанию
    /// </param>
    constructor Create(const AValue: Integer); overload;

    /// <summary>
    /// Конструктор класса для значений типа <b>Boolean</b>
    /// </summary>
    /// <param name="AValue">
    /// Значение по-умолчанию
    /// </param>
    constructor Create(const AValue: Boolean); overload;

    /// <summary>
    /// Конструктор класса для значений типа <b>string</b>
    /// </summary>
    /// <param name="AValue">
    /// Значение по-умолчанию
    /// </param>
    constructor Create(const AValue: string); overload;
  strict private
    FValue: TValue;
    function GetValue(): TValue;
  public
    /// <summary>
    /// Значение по-умолчанию
    /// </summary>
    property Value: TValue read GetValue nodefault;
  end;

implementation

constructor TDefaultValueAttribute.Create(const AValue: Integer);
begin
  FValue := AValue;
end;

constructor TDefaultValueAttribute.Create(const AValue: Boolean);
begin
  FValue := AValue;
end;

constructor TDefaultValueAttribute.Create(const AValue: string);
begin
  FValue := AValue;
end;

function TDefaultValueAttribute.GetValue(): TValue;
begin
  Result := FValue;
end;

end.
