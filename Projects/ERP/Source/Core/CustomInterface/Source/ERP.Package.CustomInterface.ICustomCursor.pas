{$REGION 'Documentation'}
/// <summary>
///   ������ ��� �������� �����������, ������� � ������� ��� ������� ������ �
///   ������������ �������� �������.
/// </summary>
/// <seealso cref="ICustomCursor">
///   ICustomCursor
/// </seealso>
/// <seealso cref="TCustomCursor">
///   TCustomCursor
/// </seealso>
/// <seealso cref="CreateSQLCursor">
///   CreateSQLCursor
/// </seealso>
{$ENDREGION}
unit ERP.Package.CustomInterface.ICustomCursor;

interface

uses
  Vcl.Controls;

type
  {$REGION 'Documentation'}
  /// <summary>
  ///   ����������� ICustomCursor ��� ������� ����������� �������� ������� �
  ///   ����������� �����������.
  /// </summary>
  /// <seealso cref="TCustomCursor">
  ///   TCustomCursor
  /// </seealso>
  {$ENDREGION}
  ICustomCursor = interface
  ['{6F1E67D5-D0A1-4D34-8662-ABE7D39A4120}']
  end;
  {$REGION 'Documentation'}
  /// <summary>
  ///   TCustomCursor ��������� ��������� <see cref="ERP.Package.CustomInterface.ICustomCursor|ICustomCursor" />
  ///   . �� ����������� ���������� ����� ������ ��������. ������ �����
  ///   ����������� ������� <see cref="ERP.Package.CustomInterface.ICustomCursor|CreateSQLCursor" />
  ///   .
  /// </summary>
  /// <seealso cref="CreateSQLCursor">
  ///   CreateSQLCursor
  /// </seealso>
  {$ENDREGION}
  TCustomCursor = class(TInterfacedObject, ICustomCursor)
  private
    FOldCursor: TCursor;
  public
    constructor Create(aCursor: TCursor);
    destructor Destroy; override;
  end;
  {$REGION 'Documentation'}
  /// <summary>
  ///   ������� CreateSQLCursor ������������� ������� ����������� ������� �
  ///   crSQLWait �� ������ �� ������.
  /// </summary>
  /// <returns>
  ///   ���������� ��������� ������ TCustomCursor ������������ ���������
  ///   ICustomCursor.
  /// </returns>
  /// <example>
  ///   <code lang="Delphi">begin
  ///   CreateSQLCursor();
  ///   ...
  /// end;</code>
  ///   <code lang="Delphi">var
  ///   SQLCursor: ICustomCursor;
  /// begin
  ///   SQLCursor := CreateSQLCursor();
  ///   ...
  ///   SQLCursor := nil;  // ����� ������ �������� � ���������� ���.
  ///   ...
  /// end;</code>
  /// </example>
  {$ENDREGION}
  function CreateSQLCursor: ICustomCursor;

implementation

uses
  Vcl.Forms;

function CreateSQLCursor: ICustomCursor;
begin
  Result := TCustomCursor.Create(crSQLWait);
end;

{ TCustomCursor }

constructor TCustomCursor.Create(aCursor: TCursor);
begin
  FOldCursor := Screen.Cursor;
  Screen.Cursor := aCursor;
end;

destructor TCustomCursor.Destroy;
begin
  Screen.Cursor := FOldCursor;
  inherited Destroy();
end;

end.
