unit ConfigPackage.Logic.TSectionAttribute;

interface

type
  /// <summary>
  /// Класс аттрибута для хранения наименования секции ini-файла
  /// </summary>
  /// <remarks>
  /// <para>
  /// <b>Пример использования:</b>
  /// </para>
  /// <para>
  /// [TSection('<i>наименование секции</i>')]
  /// </para>
  /// </remarks>
  TSectionAttribute = class(TCustomAttribute)
  public
    /// <summary>
    /// Конструктор класса
    /// </summary>
    /// <param name="AName">
    /// Наименование секции
    /// </param>
    constructor Create(const AName: string); reintroduce;
  strict private
    FName: string;
    function GetName: string;
  public
    /// <summary>
    /// Наименование секции
    /// </summary>
    /// <remarks>
    /// только для чтения
    /// </remarks>
    property name: string read GetName nodefault;
  end;

implementation

constructor TSectionAttribute.Create(const AName: string);
begin
  inherited Create();
  FName := AName;
end;

function TSectionAttribute.GetName(): string;
begin
  Result := FName;
end;

end.
