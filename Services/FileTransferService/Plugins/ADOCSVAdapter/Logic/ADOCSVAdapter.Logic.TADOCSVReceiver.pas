unit ADOCSVAdapter.Logic.TADOCSVReceiver;

interface

uses
  Classes,
  System.SysUtils,
  Package.CustomInterface.ICustomReceiverAdapter,
  Package.CustomInterface.IReceiverAdapter,
  CloudWebDav;

type
  TADOCSVReceiver = class(TInterfacedObject, IReceiverAdapter)
  private
    FCustomReceiverAdapter: ICustomReceiverAdapter;
    FAdvCardDav: TAdvCardDav;
    function Execute(aSenderFileName: PChar; const aBuffer: TBytes): Boolean;
    procedure FinalizeAdapter;
    procedure InitAdapter(aCustomReceiverAdapter: ICustomReceiverAdapter);
    procedure LoadAdapter;

    procedure DeleteContact(const aTrName: string);
    procedure AddContact(const aTrName, aCSVText: string);
  end;

implementation

uses
  Windows,
  DateUtils,
  CloudvCard,
  ADOCSVAdapter.Logic.XMLOptions;

{ TADOCSVReceiver }

procedure TADOCSVReceiver.AddContact(const aTrName, aCSVText: string);
var
  ts, tsMes: TStringList;
  k: Integer;
  cdi: TCardDavItem;
  tmpStr: string;
  phone: TvPhone;
begin
  ts := TStringList.Create;
  try
    ts.Text := aCSVText;
    for k := 0 to ts.Count - 1 do
    begin
      tsMes := TStringList.Create;
      try
        tmpStr := ts.Strings[k];
        tmpStr := StringReplace(tmpStr, ';', #13#10, [rfReplaceAll, rfIgnoreCase]);
        tsMes.Text := tmpStr;
        cdi := FAdvCardDav.Items.Insert;
        cdi.vCard.vContacts.Add;
        cdi.vCard.vContacts[0].LastName := aTrName;
        cdi.vCard.vContacts[0].FirstName := tsMes.Strings[0];
        cdi.vCard.vContacts[0].Emails.Add.EmailAddress := tsMes.Strings[1];
        tmpStr := Trim(tsMes.Strings[2]);
        while (Pos(',', tmpStr) > 0) do
        begin
          phone := cdi.vCard.vContacts[0].PhoneNumbers.Add;
          phone.PhoneNumber := Copy(tmpStr, 1, Pos(',', tmpStr) - 1);
          phone.FieldType := ftWork;
          tmpStr := Copy(tmpStr, Pos(',', tmpStr) + 1, Length(tmpStr));
        end;
        if tmpStr <> '' then
        begin
          phone := cdi.vCard.vContacts[0].PhoneNumbers.Add;
          phone.PhoneNumber := tmpStr;
          phone.FieldType := ftWork;
        end;
        cdi.vCard.vContacts[0].Addresses.Add;
        cdi.vCard.vContacts[0].Addresses[0].Country := tsMes.Strings[3];
        cdi.vCard.vContacts[0].Addresses[0].AddressType := ftWork;
        cdi.Post();
      finally
        tsMes.Free();
      end;
    end;
  finally
    ts.Free();
  end;
end;

procedure TADOCSVReceiver.DeleteContact(const aTrName: string);
var
  k: Integer;
  dt, dtNow: TDateTime;
  SecondUpdated: Int64;
  st: SYSTEMTIME;
begin
  for k := FAdvCardDav.Items.Count - 1 downto 0 do
  begin
    dt := FAdvCardDav.Items[k].vCard.vContacts[0].Updated;
    GetSystemTime(st);
    dtNow := EncodeDateTime(st.wYear, st.wMonth, st.wDay, st.wHour, st.wMinute, st.wSecond, st.wMilliseconds);
    SecondUpdated := SecondsBetween(dt, dtNow);
    if (SecondUpdated > Loadxml('TMS.xml').Options.Lifetime * MinsPerHour * SecsPerMin) or
       (FAdvCardDav.Items[k].vCard.vContacts[0].LastName = aTrName) then
      FAdvCardDav.Items[k].Delete();
  end;
end;

function TADOCSVReceiver.Execute(aSenderFileName: PChar; const aBuffer: TBytes): Boolean;
type
  OEM = type AnsiString(866);
var
  tmpOEMString: OEM;
  tmpString: string;
  account: string;
  trName: string;
  k: Integer;
  pass, login: string;
begin
  Result := False;
  SetLength(tmpOEMString, Length(aBuffer));
  Move(aBuffer[0], tmpOEMString[1], Length(aBuffer));
  tmpString := string(tmpOEMString);
  account := Copy(tmpString, 1, Pos(';', tmpString) - 1);
  trName := Copy(tmpString, Pos(';', tmpString) + 1, Length(tmpString));
  trName := Copy(trName, 1, Pos(';', trName) - 1);
  FCustomReceiverAdapter.LogWrite(PChar('Обработка строки. Код телефона = ' + account + '; Рейс = ' + trName));
  login := '';
  pass := '';
  for k := 0 to Loadxml('TMS.xml').Account.Count - 1 do
    if Loadxml('TMS.xml').Account.Items[k].Code = account then
    begin
      login := Loadxml('TMS.xml').Account.Items[k].Login;
      pass := Loadxml('TMS.xml').Account.Items[k].Password;
      Break;
    end;
  if (login = '') or (pass = '') then
    FCustomReceiverAdapter.LogWrite('Данные авторизации не найдены')
  else
  begin
    FCustomReceiverAdapter.LogWrite(PChar('Подключение к аккаунту ' + login));
    FAdvCardDav := TAdvCardDav.Create(nil);
    try
      FAdvCardDav.Url := 'http://owncloud.shate-m.com/remote.php/carddav/addressbooks';
      FAdvCardDav.Password := pass;
      FAdvCardDav.Username := login;
      try
        FAdvCardDav.Open();
        FCustomReceiverAdapter.LogWrite(PChar('Удалние контактов'));
        DeleteContact(trName);
        FCustomReceiverAdapter.LogWrite(PChar('Импорт контактов'));
        tmpString := Copy(tmpString, Pos(';', tmpString) + 1, Length(tmpString));
        tmpString := Copy(tmpString, Pos(';', tmpString) + 3, Length(tmpString));
        AddContact(trName, tmpString);
        Result := True;
      except on E: Exception do
      begin
        FCustomReceiverAdapter.LogWrite(PChar('Ошибка: = ' + E.Message));
      end;
      end;
    finally
      FAdvCardDav.Free();
    end;
  end;
end;

procedure TADOCSVReceiver.FinalizeAdapter;
begin
  FCustomReceiverAdapter := nil;
end;

procedure TADOCSVReceiver.InitAdapter(aCustomReceiverAdapter: ICustomReceiverAdapter);
begin
  FCustomReceiverAdapter := aCustomReceiverAdapter;
end;

procedure TADOCSVReceiver.LoadAdapter;
begin

end;

end.
