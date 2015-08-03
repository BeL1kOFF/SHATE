unit ERP.Package.Classes.TERPSocketStream;

interface

uses
  Winapi.WinSock,
  System.Classes,
  System.SysUtils;

type
  TERPSocketStream = class(TBytesStream)
  private
    procedure WriteExtBuffer(const Buffer; aSize: Integer); overload;
    procedure WriteExtBuffer(const Buffer: TBytes; aCount: Integer); overload;
  public
    function ReadDataTime: TDateTime;
    function ReadGUID: TGUID;
    function ReadInteger: Integer;
    function ReadSocket: TSocket;
    function ReadString: string;
    procedure Delete(aFrom, aCount: Integer);
    procedure WriteDateTime(const aValue: TDateTime);
    procedure WriteGUID(const aValue: TGUID);
    procedure WriteInteger(aValue: Integer);
    procedure WriteSocket(aValue: TSocket);
    procedure WriteString(const aValue: string);
  end;

implementation

{ TERPSocketStream }

procedure TERPSocketStream.Delete(aFrom, aCount: Integer);
var
  tmpStream: TBytesStream;
  OldPosition: Integer;
begin
  OldPosition := Position;
  tmpStream := TBytesStream.Create(nil);
  try
    Position := 0;
    tmpStream.LoadFromStream(Self);
    Clear();
    if aFrom > 0 then
      WriteBuffer(tmpStream.Bytes[0], aFrom);
    if tmpStream.Size - (aFrom + aCount) > 0 then
      WriteBuffer(tmpStream.Bytes[aFrom + aCount], tmpStream.Size - (aFrom + aCount));
  finally
    tmpStream.Free();
  end;
  if OldPosition <= aFrom then
    Position := OldPosition
  else
    if (OldPosition > aFrom) and (OldPosition < (aFrom + aCount)) then
      Position := aFrom
    else
      Position := OldPosition - aCount;
end;

function TERPSocketStream.ReadDataTime: TDateTime;
var
  SizeOfSize: Integer;
begin
  ReadBuffer(SizeOfSize, SizeOf(SizeOfSize));
  ReadBuffer(Result, SizeOfSize);
end;

function TERPSocketStream.ReadGUID: TGUID;
var
  SizeOfSize: Integer;
begin
  ReadBuffer(SizeOfSize, SizeOf(SizeOfSize));
  ReadBuffer(Result.D1, SizeOfSize);
end;

function TERPSocketStream.ReadInteger: Integer;
var
  SizeOfSize: Integer;
begin
  ReadBuffer(SizeOfSize, SizeOf(SizeOfSize));
  ReadBuffer(Result, SizeOfSize);
end;

function TERPSocketStream.ReadSocket: TSocket;
var
  SizeOfSize: Integer;
begin
  ReadBuffer(SizeOfSize, SizeOf(SizeOfSize));
  ReadBuffer(Result, SizeOfSize);
end;

function TERPSocketStream.ReadString: string;
var
  SizeOfSize: Integer;
  BytesTemp: TBytes;
begin
  ReadBuffer(SizeOfSize, SizeOf(SizeOfSize));
  SetLength(BytesTemp, SizeOfSize);
  ReadBuffer(BytesTemp, SizeOfSize);
  Result := StringOf(BytesTemp);
end;

procedure TERPSocketStream.WriteDateTime(const aValue: TDateTime);
begin
  WriteExtBuffer(aValue, SizeOf(aValue));
end;

procedure TERPSocketStream.WriteExtBuffer(const Buffer: TBytes; aCount: Integer);
begin
  WriteBuffer(aCount, SizeOf(aCount));
  WriteBuffer(Buffer, aCount);
end;

procedure TERPSocketStream.WriteExtBuffer(const Buffer; aSize: Integer);
begin
  WriteBuffer(aSize, SizeOf(aSize));
  WriteBuffer(Buffer, aSize);
end;

procedure TERPSocketStream.WriteGUID(const aValue: TGUID);
begin
  WriteExtBuffer(aValue.D1, SizeOf(aValue));
end;

procedure TERPSocketStream.WriteInteger(aValue: Integer);
begin
  WriteExtBuffer(aValue, SizeOf(aValue));
end;

procedure TERPSocketStream.WriteSocket(aValue: TSocket);
begin
  WriteExtBuffer(aValue, SizeOf(aValue));
end;

procedure TERPSocketStream.WriteString(const aValue: string);
var
  BytesTemp: TBytes;
begin
  BytesTemp := BytesOf(aValue);
  WriteExtBuffer(BytesTemp, Length(BytesTemp));
end;


end.
