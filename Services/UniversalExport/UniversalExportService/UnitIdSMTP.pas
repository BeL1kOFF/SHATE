unit UnitIdSMTP;
{
  $Project$
  $Workfile$
  $Revision$
  $DateUTC$
  $Id$

  This file is part of the Indy (Internet Direct) project, and is offered
  under the dual-licensing agreement described on the Indy website.
  (http://www.indyproject.org/)

  Copyright:
   (c) 1993-2005, Chad Z. Hower and the Indy Pit Crew. All rights reserved.
}
{
  $Log$
}
{
{   Rev 1.19    10/01/2005 16:31:20  ANeillans
{ Minor bug fix for Exim compatibility.
}
{
{   Rev 1.18    11/27/04 3:03:22 AM  RLebeau
{ Bug fix for 'STARTTLS' response handling
}
{
    Rev 1.17    6/11/2004 9:38:44 AM  DSiders
  Added "Do not Localize" comments.
}
{
{   Rev 1.16    2004.02.03 5:45:46 PM  czhower
{ Name changes
}
{
{   Rev 1.15    2004.02.03 2:12:18 PM  czhower
{ $I path change
}
{
{   Rev 1.14    1/28/2004 8:08:10 PM  JPMugaas
{ Fixed a bug in SendGreeting.  It was sending an invalid EHLO and probably an
{ invalid HELO command.  The problem is that it was getting the computer name.
{ There's an issue in NET with that which  Kudzu commented on in IdGlobal.
{ Thus, "EHLO<space>" and probably "HELO<space>" were being sent causing a
{ failure.  The fix is to to try to get the local computer's DNS name with
{ GStack.HostName.  We only use the computer name if GStack.HostName fails.
}
{
{   Rev 1.13    1/25/2004 3:11:48 PM  JPMugaas
{ SASL Interface reworked to make it easier for developers to use.
{ SSL and SASL reenabled components.
}
{
{   Rev 1.12    2004.01.22 10:29:58 PM  czhower
{ Now supports default login mechanism with just username and pw.
}
{
{   Rev 1.11    1/21/2004 4:03:24 PM  JPMugaas
{ InitComponent
}
{
{   Rev 1.10    22/12/2003 00:46:36  CCostelloe
{ .NET fixes
}
{
{   Rev 1.9    4/12/2003 10:24:08 PM  GGrieve
{ Fix to Compile
}
{
{   Rev 1.8    25/11/2003 12:24:22 PM  SGrobety
{ various IdStream fixes with ReadLn/D6
}
{
    Rev 1.7    10/17/2003 1:02:56 AM  DSiders
  Added localization comments.
}
{
{   Rev 1.6    2003.10.14 1:31:16 PM  czhower
{ DotNet
}
{
{   Rev 1.5    2003.10.12 6:36:42 PM  czhower
{ Now compiles.
}
{
{   Rev 1.4    10/11/2003 7:14:36 PM  BGooijen
{ Changed IdCompilerDefines.inc path
}
{
{   Rev 1.3    10/10/2003 10:45:12 PM  BGooijen
{ DotNet
}
{
{   Rev 1.2    2003.10.02 9:27:54 PM  czhower
{ DotNet Excludes
}
{
{   Rev 1.1    6/15/2003 03:28:24 PM  JPMugaas
{ Minor class change.
}
{
{   Rev 1.0    6/15/2003 01:06:48 PM  JPMugaas
{ TIdSMTP and TIdDirectSMTP now share common code in this base class.
}
interface

uses
  IdAssignedNumbers,
  IdEMailAddress,
  IdException,
  IdExplicitTLSClientServerBase,
  IdHeaderList,
  IdMessage,
  IdMessageClient,
  IdSASL,
  IdSASLCollection,
  UnitIdSMTPBase,
  IdSys,
  IdBaseComponent,
  IdGlobal,
  IdObjs;

type
  TIdSMTPAuthenticationType = (atNone, atDefault, atSASL);

const
  DEF_SMTP_Use_ImplicitTLS = False;
  DEF_SMTP_PIPELINE = True;
  DEF_SMTP_AUTH = atDefault;

type
//FSASLMechanisms
  TIdSMTP = class(TIdSMTPBase)
  protected
    FAuthType: TIdSMTPAuthenticationType;
    // This is just an internal flag we use to determine if we already authenticated to the server.
    FDidAuthenticate: Boolean;
    // FSASLMechanisms : TIdSASLList;
    FSASLMechanisms : TIdSASLEntries;
    //
    procedure SetAuthType(const Value: TIdSMTPAuthenticationType);
    procedure SetUseEhlo(const Value: Boolean); override;
    procedure SetUseTLS(AValue: TIdUseTLS); override;
    procedure SetSASLMechanisms(AValue: TIdSASLEntries);
    procedure InitComponent; override;
    procedure Notification(AComponent: TIdNativeComponent; Operation: TIdOperation); override;

    //
    // holger: .NET compatibility change, OnConnected being reintroduced 
    property OnConnected;
  public
    destructor Destroy; override;
    procedure Assign(Source: TIdPersistent); override;
    function Authenticate: Boolean; virtual;
    procedure Connect; override;
    procedure Disconnect(AImmediate: Boolean); override;
    procedure DisconnectNotifyPeer; override;
    class procedure QuickSend(const AHost, ASubject, ATo, AFrom, AText: string);
    procedure Send (AMsg: TIdMessage); override;
    procedure Expand( AUserName : String; AResults : TIdStrings); virtual;
    function Verify( AUserName : String) : String; virtual;

    //
    property DidAuthenticate: Boolean read FDidAuthenticate;
  published
    property AuthType: TIdSMTPAuthenticationType read FAuthType write FAuthType
     default DEF_SMTP_AUTH;
    property Host;
    property Password;
    property Port default IdPORT_SMTP;
   // property SASLMechanisms: TIdSASLList read FSASLMechanisms write FSASLMechanisms;
    property SASLMechanisms : TIdSASLEntries read FSASLMechanisms write SetSASLMechanisms;
    property UseTLS;
    property Username;
    //
    property OnTLSNotAvailable;
  end;


implementation

uses
  IdCoderMIME,
  IdGlobalProtocols,
  IdReplySMTP,
  IdSSL,
  IdResourceStringsProtocols,
  IdTCPConnection;

{ TIdSMTP }

procedure TIdSMTP.Assign(Source: TIdPersistent);
var
  LS: TIdSMTP;

begin
  if Source is TIdSMTP then begin
    LS := Source as TIdSMTP;
    AuthType := LS.AuthType;
    HeloName := LS.HeloName;
    SASLMechanisms := LS.SASLMechanisms;
    UseEhlo := LS.UseEhlo;
    UseTLS := LS.UseTLS;
    Host := LS.Host;
    MailAgent := LS.MailAgent;
    Port := LS.Port;
    Tag := LS.Tag;
    Username := LS.Username;
    Password := LS.Password;
    //events
    OnTLSNotAvailable := LS.OnTLSNotAvailable;
    OnTLSHandShakeFailed := LS.OnTLSHandShakeFailed;
    OnTLSNegCmdFailed := LS.OnTLSNegCmdFailed;

    OnConnected := LS.OnConnected;
    OnDisconnected := LS.OnDisconnected;
    OnWork := LS.OnWork;
    OnWorkBegin := LS.OnWorkBegin;
    OnWorkEnd := LS.OnWorkEnd;
    OnStatus := LS.OnStatus;
  end else begin
    inherited;
  end;
end;

function TIdSMTP.Authenticate : Boolean;
var
  s : TIdStrings;
begin
  if FDidAuthenticate then
  begin
    Result := True;
    Exit;
  end;

  //This will look strange but we have logic in that method to make
  //sure that the STARTTLS command is used appropriately.
  //Note we put this in Authenticate only to ensure that TLS negotiation
  //is done before a password is sent over a network unencrypted.
  StartTLS;

  //note that we pass the reply numbers as strings so the SASL stuff can work
  //with IMAP4 and POP3 where non-numeric strings are used for reply codes
  case FAuthType of
    atNone:
      begin
        //do nothing
        FDidAuthenticate := True;
      end;
    atDefault:
      begin
        if Username <> '' then begin
          s := SASLMechanisms.ParseCapaReply(Capabilities);
          try
            //many servers today do not use username/password authentication
            if s.IndexOf('LOGIN') > -1 then begin
              with TIdEncoderMIME.Create(nil) do try
                SendCmd('AUTH LOGIN', 334);
                SendCmd(Encode(Username), 334);
                SendCmd(Encode(Password), 235);
              finally
                Free;
              end;
              FDidAuthenticate := True;
            end;
          finally
            Sys.FreeAndNil(s);
          end;
        end;
{
        RLebeau: TODO - implement the following code in the future
        instead of the code above.  This way, TIdSASLLogin can be utilized.

        EIdSASLMechNeeded.IfTrue(SASLMechanisms.Count = 0, RSASLRequired);
        FDidAuthenticate := SASLMechanisms.LoginSASL('AUTH', 'LOGIN', ['235'], ['334'], Self, Capabilities);
}
      end;
    atSASL:
      begin
        EIdSASLMechNeeded.IfTrue(SASLMechanisms.Count = 0, RSASLRequired);
        FDidAuthenticate := SASLMechanisms.LoginSASL('AUTH', ['235'], ['334'], Self, Capabilities); {do not localize}
      end;
  end;
  Result := FDidAuthenticate;
end;

procedure TIdSMTP.Connect;
begin
  inherited Connect; try
    GetResponse(220);
    SendGreeting;
  except
    Disconnect;
    Raise;
  end;
end;

procedure TIdSMTP.InitComponent;
begin
  inherited;
  FSASLMechanisms := TIdSASLEntries.Create(Self);
  FAuthType := DEF_SMTP_AUTH;
  FUseEhlo := IdDEF_UseEhlo;
  FImplicitTLSProtPort := IdPORT_ssmtp;
  FRegularProtPort := IdPORT_SMTP;
  FPipeLine := DEF_SMTP_PIPELINE;
  Port := IdPORT_SMTP;
end;

procedure TIdSMTP.DisconnectNotifyPeer;
begin
  inherited;
  SendCmd('QUIT', 221);    {Do not Localize}
end;

procedure TIdSMTP.Expand(AUserName: String; AResults: TIdStrings);
begin
  SendCMD('EXPN ' + AUserName, [250, 251]);    {Do not Localize}
end;

class procedure TIdSMTP.QuickSend (const AHost, ASubject, ATo, AFrom, AText : String);
var
  LSMTP: TIdSMTP;
  LMsg: TIdMessage;
begin
  LSMTP := TIdSMTP.Create(nil); try
    LMsg := TIdMessage.Create(LSMTP); try
      with LMsg do begin
        Subject := ASubject;
        Recipients.EMailAddresses := ATo;
        From.Text := AFrom;
        Body.Text := AText;
      end;
      with LSMTP do begin
        Host := AHost;
        Connect; try;
          Send(LMsg);
        finally Disconnect; end;
      end;
    finally Sys.FreeAndNil(LMsg); end;
  finally Sys.FreeAndNil(LSMTP); end;
end;

procedure TIdSMTP.Send(AMsg: TIdMessage);
var
  LRecipients : TIdEMailAddressList;
begin
  //Authenticate now calls StartTLS
  //so that you do not send login information before TLS negotiation (big oops security wise).
  //It also should see if authentication should be done according to your settings.
  Authenticate;

  AMsg.ExtraHeaders.Values[XMAILER_HEADER] := MailAgent;
  //LRecipients := TIdEMailAddressList.Create(nil);
  LRecipients := TIdEMailAddressList.Create(Self);
  try
    LRecipients.EMailAddresses := AMsg.Recipients.EMailAddresses;
    if AMsg.CCList.Count > 0 then begin
      LRecipients.EMailAddresses := LRecipients.EMailAddresses + ', ' + AMsg.CCList.EMailAddresses;
    end;
    if AMsg.BccList.Count > 0 then begin
      LRecipients.EMailAddresses := LRecipients.EMailAddresses + ', ' + AMsg.BccList.EMailAddresses;
    end;
    InternalSend(AMsg, LRecipients);
  finally
    Sys.FreeAndNil(LRecipients);
  end;
end;

procedure TIdSMTP.SetAuthType(const Value: TIdSMTPAuthenticationType);
Begin
  FAuthType := Value;
  if Value = atSASL then begin
    FUseEhlo := True;
  end;
end;

procedure TIdSMTP.SetUseEhlo(const Value: Boolean);
Begin
  FUseEhlo := Value;
  if NOT Value then
  begin
    FAuthType := atDefault;
    if FUseTLS in ExplicitTLSVals then
    begin
      FUseTLS := DEF_USETLS;
      FPipeLine := False;
    end;
  end;
End;

function TIdSMTP.Verify(AUserName: string): string;
begin
  SendCMD('VRFY ' + AUserName, [250, 251]);    {Do not Localize}
  Result := LastCmdResult.Text[0];
end;

procedure TIdSMTP.Notification(AComponent: TIdNativeComponent;
  Operation: TIdOperation);
begin
  if (Operation = opRemove) and (FSASLMechanisms <> nil) then begin
    FSASLMechanisms.RemoveByComp(AComponent);
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TIdSMTP.SetUseTLS(AValue: TIdUseTLS);
begin
  inherited;
  if FUseTLS in ExplicitTLSVals then
  begin
    UseEhlo := True;
  end;
end;

procedure TIdSMTP.SetSASLMechanisms(AValue: TIdSASLEntries);
begin
  FSASLMechanisms.Assign(AValue);
end;

destructor TIdSMTP.Destroy;
begin
  Sys.FreeAndNil(FSASLMechanisms);
  inherited Destroy;
end;

procedure TIdSMTP.Disconnect(AImmediate: Boolean);
begin
  inherited;
  FDidAuthenticate := False;
end;

end.


