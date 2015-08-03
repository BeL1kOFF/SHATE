unit UBallonSupport;

interface

uses
  Windows, SysUtils, Controls, UBallonToolTip;

procedure ShowBallon(Control: TControl; const Msg: string);
procedure ShowBallonCustom(Control: TControl; const Msg: string; aParams: IToolTipParams);
procedure ShowBallonInfo(Control: TControl; const Msg: string; const aTitle: string; x: Integer = -1; y: Integer = -1);
procedure ShowBallonInfoLink(Control: TControl; const Msg: string; const aTitle: string; OnLinkClickProc: TOnBallonLinkClick; aLinkID: Integer = 0; x: Integer = -1; y: Integer = -1);
procedure ShowBallonWarn(Control: TControl; const Msg: string; const aTitle: string; x: Integer = -1; y: Integer = -1);
procedure ShowBallonErr(Control: TControl; const Msg: string; const aTitle: string; x: Integer = -1; y: Integer = -1);

procedure SetBallon(aBallon: TObject);
procedure SetBallonMessage(const aMsg: tagMSG);

var
  gBallon: TObject;

implementation

uses
  Forms, ComCtrls;

procedure SetBallon(aBallon: TObject);
var
  aBallonOld: TObject;
begin
  aBallonOld := gBallon;
  gBallon := aBallon;
  aBallonOld.Free;
end;

procedure SetBallonMessage(const aMsg: tagMSG);
begin
  if Assigned(gBallon) then
    SendMessage((gBallon as TBallonToolTip).GetToolHandle, aMsg.message, aMsg.wParam, aMsg.lParam);
end;

procedure ShowBallon(Control: TControl; const Msg: string);
begin
  ShowBallonCustom(Control, Msg, nil);
end;

procedure ShowBallonCustom(Control: TControl; const Msg: string; aParams: IToolTipParams);
begin
  SetBallon(
    TBallonToolTip.Create(Control, Msg, aParams)
  );
end;

procedure ShowBallonInfo(Control: TControl; const Msg: string; const aTitle: string; x: Integer = -1; y: Integer = -1);
var
  aBallon: TBallonToolTip;
begin
  aBallon := TBallonToolTip.Create(Control, Msg,
    makeToolTipParams
    .SetLeft(x)
    .SetTop(y)
    .SetIcon(ttiInfo)
    .SetTitle(aTitle)
    .SetBkColor($00FFFFFF)
    .SetTextColor($00FF0000)
  );
  SetBallon(aBallon);
end;

procedure ShowBallonInfoLink(Control: TControl; const Msg: string; const aTitle: string; OnLinkClickProc: TOnBallonLinkClick; aLinkID: Integer = 0; x: Integer = -1; y: Integer = -1);
var
  aBallon: TBallonToolTip;
begin
  aBallon := TBallonToolTip.Create(Control, Msg,
    makeToolTipParams
    .SetLeft(x)
    .SetTop(y)
    .SetIcon(ttiInfo)
    .SetTitle(aTitle)
    .SetBkColor($00FFFFFF)
    .SetTextColor($00FF0000)
    .SetLink(aLinkID, OnLinkClickProc)
  );
  SetBallon(aBallon);
end;

procedure ShowBallonWarn(Control: TControl; const Msg: string; const aTitle: string; x: Integer = -1; y: Integer = -1);
var
  aBallon: TBallonToolTip;
begin
  aBallon := TBallonToolTip.Create(Control, Msg,
    makeToolTipParams
    .SetLeft(x)
    .SetTop(y)
    .SetIcon(ttiWarning)
    .SetTitle(aTitle)
    .SetBkColor($00FFFFFF)
    .SetTextColor($004066FF)
  );
  SetBallon(aBallon);
end;

procedure ShowBallonErr(Control: TControl; const Msg: string; const aTitle: string; x: Integer = -1; y: Integer = -1);
var
  aBallon: TBallonToolTip;
begin
  aBallon := TBallonToolTip.Create(Control, Msg,
    makeToolTipParams
    .SetLeft(x)
    .SetTop(y)
    .SetIcon(ttiError)
    .SetTitle(aTitle)
    .SetBkColor($00FFFFFF)
    .SetTextColor($000000FF)
  );
  SetBallon(aBallon);
end;

end.
