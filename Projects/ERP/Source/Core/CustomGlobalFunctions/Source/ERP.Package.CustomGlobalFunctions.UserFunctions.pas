unit ERP.Package.CustomGlobalFunctions.UserFunctions;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Data.DB,
  FireDAC.Comp.Client;

type
  TFuncCallBackClassNotFound = function(aControl: TControl; aField: TField): Boolean of object;

  TERPParamValue = record
  private
    Value: Variant;
    ValueType: TFieldType;
  public
    class function Create(const aValue: Variant): TERPParamValue; overload; static; inline;
    class function Create(const aValue: Variant; aValueType: TFieldType): TERPParamValue; overload; static; inline;
  end;

  TERPControlValue = record
  private
    Control: TControl;
    FieldName: string;
    IsProcess: Boolean;
  public
    class function Create(aControl: TControl; const aFieldName: string): TERPControlValue; overload; static; inline;
    class function Create(aControl: TControl; const aFieldName: string; aIsProcess: Boolean): TERPControlValue; overload; static; inline;
  end;

  TERPQueryResult = record
  strict private
    FStatus: Integer;
    FText: string;
    FCode: Integer;
  public
    constructor Create(aStatus: Integer; const aText: string; aCode: Integer);
    property Status: Integer read FStatus;
    property Text: string read FText;
    property Code: Integer read FCode;
  end;

  TERPQueryHelp = record
  strict private
    class function CreateQuery(aFDConnection: TFDConnection; const aQuerySQL: string;
      const aParamValue: array of TERPParamValue): TFDQuery; static;
  public
    class function Check(aFDConnection: TFDConnection; const aQuerySQL: string;
      const aParamValue: array of TERPParamValue): TERPQueryResult; static;
    class function Open(aFDConnection: TFDConnection; const aQuerySQL: string;
      const aParamValue: array of TERPParamValue): Boolean; overload; static;
    class function Open(aQuery: TFDQuery): Boolean; overload; static;
    class procedure ReadItem(aFDConnection: TFDConnection; const aQuerySQL:
      string; const aParamValue: array of TERPParamValue; const aControls: array of TERPControlValue;
      aFuncCallBackClassNotFound: TFuncCallBackClassNotFound); static;
    class procedure FillStrings(aStrings: TStrings; aFDConnection: TFDConnection; const aQuerySQL: string;
      const aParamValue: array of TERPParamValue; const aFieldName_Id, aFieldName_Name: string); static;
  end;

  TERPMessageHelp = record
  public
    class function BoxQuestionYN(aText: string): Boolean; static; inline;
    class procedure ShowMessage(const aQueryResult: TERPQueryResult); static; inline;
  end;

  TERPMethodHelp = record
  public
    class function GetExtFileFromHeader(const aBytes: TBytes): string; static;
    class function GetImageClassNameFromMimeType(const aBytes: TBytes): string; static; deprecated;
    class function GetImageClassNameFromHeader(const aBytes: TBytes): string; static;
  end;

  EERPQueryOpen = class(Exception);

const
  ERROR_MESSAGE = 'Код: %d'#13#10'%s';

  QUERY_RESULT_ERROR   = -1;
  QUERY_RESULT_WARNING = 0;
  QUERY_RESULT_OK      = 1;

resourcestring
  rsError = 'Ошибка';
  rsWarning = 'Предупреждение';
  rsMessage = 'Сообщение';
  rsNoParamCount = 'Кол-во контролов и полей не совпадает!';
  rsExceptionNotFoundClass = 'Не найден класс %s компонента %s в визуализации';

implementation

uses
  Winapi.Windows,
  Winapi.UrlMon,
  Vcl.StdCtrls,
  Vcl.Graphics,
  cxCheckBox,
  cxTextEdit,
  cxMaskEdit,
  cxImage;

type
  EERPQueryReadItem = class(Exception);

{ TERPQueryHelp }

class function TERPQueryHelp.Check(aFDConnection: TFDConnection; const aQuerySQL: string;
  const aParamValue: array of TERPParamValue): TERPQueryResult;
var
  Query: TFDQuery;
begin
  Query := CreateQuery(aFDConnection, aQuerySQL, aParamValue);
  try
    Query.Open();
    Result.Create(Query.Fields.Fields[0].AsInteger,
                  Query.Fields.Fields[1].AsString,
                  Query.Fields.Fields[2].AsInteger);
  finally
    Query.Free();
  end;
end;

class function TERPQueryHelp.CreateQuery(aFDConnection: TFDConnection; const aQuerySQL: string;
  const aParamValue: array of TERPParamValue): TFDQuery;
var
  k: Integer;
begin
  Result := TFDQuery.Create(nil);
  try
    Result.Connection := aFDConnection;
    Result.SQL.Text := aQuerySQL;
    for k := Low(aParamValue) to High(aParamValue) do
    begin
      Result.Params.Items[k].DataType := aParamValue[k].ValueType;
      Result.Params.Items[k].Value := aParamValue[k].Value;
    end;
  except
  begin
    FreeAndNil(Result);
    raise;
  end;
  end;
end;

class procedure TERPQueryHelp.FillStrings(aStrings: TStrings; aFDConnection: TFDConnection; const aQuerySQL: string;
  const aParamValue: array of TERPParamValue; const aFieldName_Id, aFieldName_Name: string);
var
  Query: TFDQuery;
  k: Integer;
begin
  Query := CreateQuery(aFDConnection, aQuerySQL, aParamValue);
  try
    try
      Query.Open();
      Query.First();
      aStrings.Clear();
      for k := 0 to Query.RecordCount - 1 do
      begin
        aStrings.AddObject(Query.FieldByName(aFieldName_Name).AsString, TObject(Query.FieldByName(aFieldName_Id).AsInteger));
        Query.Next();
      end;
    finally
      Query.Close();
    end;
  finally
    Query.Free();
  end;
end;

class function TERPQueryHelp.Open(aQuery: TFDQuery): Boolean;
var
  MemTable: TFDMemTable;
  QueryResult: TERPQueryResult;
begin
  try
    aQuery.Open();
    MemTable := TFDMemTable.Create(nil);
    try
      while aQuery.Active do
      begin
        MemTable.Close();
        MemTable.Data := aQuery.Data;
        aQuery.NextRecordSet();
      end;
      QueryResult.Create(MemTable.Fields.Fields[0].AsInteger,
                         MemTable.Fields.Fields[1].AsString,
                         MemTable.Fields.Fields[2].AsInteger);
    finally
      MemTable.Free();
    end;
  except on E: Exception do
    QueryResult.Create(QUERY_RESULT_ERROR, E.Message, 1000);
  end;
  Result := QueryResult.Status = QUERY_RESULT_OK;
  if QueryResult.Code <> 1000 then
    TERPMessageHelp.ShowMessage(QueryResult)
  else
    raise EERPQueryOpen.CreateFmt('Ошибка выполнения TERPQueryHelp.Open'#13#10'%s', [QueryResult.Text]);
end;

class function TERPQueryHelp.Open(aFDConnection: TFDConnection; const aQuerySQL: string;
  const aParamValue: array of TERPParamValue): Boolean;
var
  Query: TFDQuery;
begin
  Query := CreateQuery(aFDConnection, aQuerySQL, aParamValue);
  try
    Result := Open(Query);
  finally
    Query.Free();
  end;
end;

class procedure TERPQueryHelp.ReadItem(aFDConnection: TFDConnection; const aQuerySQL: string;
  const aParamValue: array of TERPParamValue; const aControls: array of TERPControlValue;
  aFuncCallBackClassNotFound: TFuncCallBackClassNotFound);
var
  Query: TFDQuery;
  Control: TControl;
  FieldName: string;
  IsProcess: Boolean;
  k: Integer;
  Buffer: TBytes;
  Stream: TBytesStream;
  Graphic: TGraphic;

  procedure ExecClassNotFound;
  begin
    if Assigned(aFuncCallBackClassNotFound) then
    begin
      if not aFuncCallBackClassNotFound(Control, Query.FieldByName(FieldName)) then
        raise EERPQueryReadItem.CreateFmt(rsExceptionNotFoundClass, [Control.ClassName, Control.Name]);
    end
    else
      raise EERPQueryReadItem.CreateFmt(rsExceptionNotFoundClass, [Control.ClassName, Control.Name]);
  end;

begin
  Query := CreateQuery(aFDConnection, aQuerySQL, aParamValue);
  try
    Query.Open();
    for k := Low(aControls) to High(aControls) do
    begin
      Control := aControls[k].Control;
      FieldName := aControls[k].FieldName;
      IsProcess := aControls[k].IsProcess;
      if IsProcess then
        if Control.ClassType = TEdit then
          (Control as TEdit).Text := Query.FieldByName(FieldName).AsString
        else
        if Control.ClassType = TCheckBox then
          (Control as TCheckBox).Checked := Query.FieldByName(FieldName).AsBoolean
        else
        if Control.ClassType = TcxCheckBox then
          (Control as TcxCheckBox).Checked := Query.FieldByName(FieldName).AsBoolean
        else
        if Control.ClassType = TcxTextEdit then
          (Control as TcxTextEdit).Text := Query.FieldByName(FieldName).AsString
        else
        if Control.ClassType = TcxMaskEdit then
          (Control as TcxMaskEdit).Text := Query.FieldByName(FieldName).AsString
        else
        if Control.ClassType = TcxImage then
        begin
          Buffer := Query.FieldByName(FieldName).AsBytes;
          (Control as TcxImage).Properties.GraphicClassName := TERPMethodHelp.GetImageClassNameFromMimeType(Buffer);
          if not SameText((Control as TcxImage).Properties.GraphicClassName, '') then
          begin
            Stream := TBytesStream.Create(Buffer);
            try
              Graphic := (Control as TcxImage).Properties.GraphicClass.Create();
              try
                Graphic.LoadFromStream(Stream);
                (Control as TcxImage).Picture.Graphic := Graphic;
              finally
                Graphic.Free();
              end;
            finally
              Stream.Free();
            end;
          end
          else
            (Control as TcxImage).Picture.Graphic := nil;
        end
        else
          ExecClassNotFound()
      else
        ExecClassNotFound();
    end;
  finally
    Query.Free();
  end;
end;

{ TERPMessageHelp }

class function TERPMessageHelp.BoxQuestionYN(aText: string): Boolean;
begin
  Result := MessageBox(GetActiveWindow(), PChar(aText), 'Вопрос', MB_YESNO or MB_ICONQUESTION) = ID_YES;
end;

class procedure TERPMessageHelp.ShowMessage(const aQueryResult: TERPQueryResult);
begin
  case aQueryResult.Status of
    QUERY_RESULT_ERROR:
      MessageBox(GetActiveWindow(), PChar(Format(ERROR_MESSAGE, [aQueryResult.Code, aQueryResult.Text])), PChar(rsError), MB_OK or MB_ICONERROR);
    QUERY_RESULT_WARNING:
      MessageBox(GetActiveWindow(), PChar(aQueryResult.Text), PChar(rsWarning), MB_OK or MB_ICONWARNING);
    QUERY_RESULT_OK:
      if not SameText(aQueryResult.Text, '') then
        MessageBox(GetActiveWindow(), PChar(aQueryResult.Text), PChar(rsMessage), MB_OK or MB_ICONINFORMATION);
  end;
end;

{ TERPQueryResult }

constructor TERPQueryResult.Create(aStatus: Integer; const aText: string; aCode: Integer);
begin
  Self.FStatus := aStatus;
  Self.FText := aText;
  Self.FCode := aCode;
end;

{ TERPControlValue }

class function TERPControlValue.Create(aControl: TControl; const aFieldName: string;
  aIsProcess: Boolean): TERPControlValue;
begin
  Result.Control := aControl;
  Result.FieldName := aFieldName;
  Result.IsProcess := aIsProcess;
end;

class function TERPControlValue.Create(aControl: TControl; const aFieldName: string): TERPControlValue;
begin
  Result := Create(aControl, aFieldName, True);
end;

{ TERPParamValue }

class function TERPParamValue.Create(const aValue: Variant; aValueType: TFieldType): TERPParamValue;
begin
  Result.Value := aValue;
  Result.ValueType := aValueType;
end;

class function TERPParamValue.Create(const aValue: Variant): TERPParamValue;
begin
  Result := Create(aValue, ftUnknown);
end;

{ TERPMethodHelp }

class function TERPMethodHelp.GetExtFileFromHeader(const aBytes: TBytes): string;
type
  THeaderFile = record
    Header: array[0..7] of Byte;
    Size: Byte;
    Ext: string;
  end;

  THeaders = array[0..4] of THeaderFile;

const
  Headers: THeaders = ((Header: ($00, $00, $01, $00, $00, $00, $00, $00); Size: 4; Ext: 'ico'),
                       (Header: ($4D, $42, $00, $00, $00, $00, $00, $00); Size: 2; Ext: 'bmp'),
                       (Header: ($42, $4D, $00, $00, $00, $00, $00, $00); Size: 2; Ext: 'bmp'),
                       (Header: ($FF, $D8, $00, $00, $00, $00, $00, $00); Size: 2; Ext: 'jpg'),
                       (Header: ($89, $50, $4E, $47, $0D, $0A, $1A, $0A); Size: 8; Ext: 'png'));

var
  k: Integer;

begin
  if Length(aBytes) > 0 then
    for k := Low(Headers) to High(Headers) do
      if CompareMem(@aBytes[0], @Headers[k].Header[0], Headers[k].Size) then
        Exit(Headers[k].Ext);
  Result := '';
end;

class function TERPMethodHelp.GetImageClassNameFromHeader(const aBytes: TBytes): string;
begin
  Result := GetExtFileFromHeader(aBytes);
  if SameText(Result, 'ico') then
    Result := 'TIcon'
  else
    if SameText(Result, 'jpg') then
      Result := 'TJPEGImage'
    else
      if SameText(Result, 'bmp') then
        Result := 'TBitmap'
      else
        if SameText(Result, 'png') then
          Result := 'TdxPNGImage'
        else
          Result := '';
end;

class function TERPMethodHelp.GetImageClassNameFromMimeType(const aBytes: TBytes): string;
var
  MimeType: PChar;
begin
  if Length(aBytes) > 0 then
    if FindMimeFromData(nil, nil, @aBytes[0], Length(aBytes), nil, 0, MimeType, 0) = NOERROR then
      if SameText(MimeType, 'image/bmp') then
        Result := 'TBitmap'
      else
        if SameText(MimeType, 'image/pjpeg') then
          Result := 'TJPEGImage'
        else
          if SameText(MimeType, 'image/x-png') then
            Result := 'TdxPNGImage'
          else
            Result := ''
    else
      Result := ''
  else
    Result := '';
end;

end.
