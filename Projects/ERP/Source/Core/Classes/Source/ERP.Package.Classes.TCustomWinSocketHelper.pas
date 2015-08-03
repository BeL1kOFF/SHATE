unit ERP.Package.Classes.TCustomWinSocketHelper;

interface

uses
  System.Win.ScktComp;

type
  TCustomWinSocketHelper = class helper for TCustomWinSocket
    procedure SendSafeBuffer(var aBuf; aCount: Integer);
  end;

implementation

uses
  ERP.Package.Classes.TERPSocketStream;

{ TCustomWinSocketHelper }

procedure TCustomWinSocketHelper.SendSafeBuffer(var aBuf; aCount: Integer);
var
  Buffer: TERPSocketStream;
begin
  Buffer := TERPSocketStream.Create(nil);
  try
    Buffer.WriteInteger(aCount);
    Buffer.WriteBuffer(aBuf, aCount);
    SendBuf(Buffer.Bytes[0], Buffer.Size);
  finally
    Buffer.Free();
  end;
end;

end.
