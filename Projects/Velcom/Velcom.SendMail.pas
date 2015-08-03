unit Velcom.SendMail;

interface

uses
  IdSMTP,
  IdMessage,
  IdCoderHeader,
  Classes;

type
  TMyIdMessage = class(TIdMessage)
  protected
    procedure OnISO(var VTransferHeader: TTransfer; var VHeaderEncoding: Char; var VCharSet: string);
  public
    constructor Create(AOwner: TComponent);
  end;

  procedure SendMail(aIdSMTP: TIdSMTP; const aBody, aMailAddress, aFileName: string);

implementation

uses
  Windows,
  SysUtils,
  IdAttachmentFile;

procedure SendMail(aIdSMTP: TIdSMTP; const aBody, aMailAddress, aFileName: string);
var
  msg: TIdMessage;
begin
  aIdSMTP.Connect;

  msg := TMyIdMessage.Create(nil);
  try
    msg.Body.Add(aBody);
    msg.Subject := 'Расшифровка ' + 'Velcom';
    msg.From.Address := 'noreply@shate-m.com';
    msg.From.Name := 'Служба оповещения "Шате-М+';
    msg.ContentType := 'multipart/mixed; charset=windows-1251';
    msg.Recipients.EMailAddresses := aMailAddress;
    msg.IsEncoded := True;
    msg.CharSet := 'windows-1251';
    TIdAttachmentFile.Create(msg.MessageParts, aFileName);
    aIdSMTP.Send(msg);
  finally
    msg.Free;
    aIdSMTP.Disconnect;
  end;
      
  SysUtils.DeleteFile(aFileName);
end;

{ TMyIdMessage }

constructor TMyIdMessage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OnInitializeISO := OnISO;
end;

procedure TMyIdMessage.OnISO(var VTransferHeader: TTransfer;
  var VHeaderEncoding: Char; var VCharSet: string);
begin
  VCharSet := 'windows-1251';
  VTransferHeader := bit8;
  VHeaderEncoding := '8';
end;

end.
