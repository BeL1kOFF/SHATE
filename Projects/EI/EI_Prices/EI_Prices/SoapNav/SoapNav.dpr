library SoapNav;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Windows,
  SysUtils,
  Classes,
  StrUtils,
  ActiveX,
  ws in 'ws.pas';

{$R *.res}

function GetSalesPrice(aItemNo2, aTMName, aServiceProgUsrID, aAgreementNo, aCurrCode: Pointer;
  out aPrice: Pointer; out aErr: Pointer): Integer; stdcall;
var
  itemNo2: WideString;
  tMName: WideString;
  serviceProgUsrID: WideString;
  agreementNo: WideString;
  currCode: WideString;
  Reslt: string;
  ErrText: string;
begin
  CoInitializeEx(nil, 0);
  try
    itemNo2 := PChar(aItemNo2);
    tMName := PChar(aTMName);
    serviceProgUsrID := PChar(aServiceProgUsrID);
    agreementNo := PChar(aAgreementNo);
    currCode := PChar(aCurrCode);
    Reslt := GetServiceProg_Port.GetSalesPrice(itemNo2, tMName, serviceProgUsrID, agreementNo, currCode);
    Move(Reslt[1], PChar(aPrice), Length(Reslt));
    ErrText := '';
    Move(ErrText[1], PChar(aErr), Length(ErrText));
    Result := 0;
  except on E: Exception do
  begin
    Move(E.Message[1], PChar(aErr), Length(E.Message));
    Result := -1;
//    CoUninitialize;
  end;
  end;
end;

function GetPriceRatio(aValue1, aValue2: Pointer; out aPriceRatio: Pointer; out aErr: Pointer): Integer; stdcall;
var
  wsValue1, wsValue2: WideString;
  sValue1, sValue2: string;
  dValue1: Double;
  ErrText, Reslt: string;
  k: Integer;
begin
  try
    wsValue1 := PChar(aValue1);
    wsValue2 := PChar(aValue2);
    sValue1 := wsValue1;
    sValue2 := wsValue2;
    dValue1 := StrToFloat(StringReplace(StringReplace(sValue1, ' ', '', [rfReplaceAll]), ',', '.', [rfReplaceAll]));
    sValue2 := StringReplace(StringReplace(sValue2, ' ', '', [rfReplaceAll]), ',', '.', [rfReplaceAll]);
    Reslt := '';
    for k := 1 to Length(sValue2) do
      if sValue2[k] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'] then
        Reslt := Reslt + sValue2[k];
    Reslt := FloatToStr(StrToFloat(Reslt) * 100 / dValue1);
    Move(Reslt[1], PChar(aPriceRatio), Length(Reslt));
    ErrText := '';
    Move(ErrText[1], PChar(aErr), Length(ErrText));
    Result := 0;
  except on E: Exception do
  begin
    Move(E.Message[1], PChar(aErr), Length(E.Message));
    Result := -1;
  end;
  end;
end;

exports GetSalesPrice, GetPriceRatio;

begin
end.
