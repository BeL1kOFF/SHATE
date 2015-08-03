unit _LocalVersionFuncts;

interface

uses
  Classes, ADODB, SysUtils, DB, dbisamtb;

const
  cLocalVerIniFile = 'LocalVer.ini';

function MSGetDiscounts(const aClientId: string; CurVersion: Integer; CurVersionAdr: Integer; CurVersionAgr: Integer;
                        out aNewVersion,aNewVersionAdr,aNewVersionAgr: Integer;
                        out aPass: string;
                        const aSaveToFile: string; const aSaveToStreamAdr,aSaveToStreamAgr:TMemoryStream): String;
function UpdateDiscountsAll(aVersions: TStrings): Integer; {version}
function UpdateClientsAll(aCurVersion: Integer; aClientsTable: TDBISamTable; const aCustomEmail: string; aSilentMode: Boolean): Integer; {version}

implementation

uses
  Windows, IniFiles, _Main, Forms, _Data;

function GetMsConnection: TAdoConnection;
var
  aIni: TIniFile;
  aHost, aDB, aUser, aPass: string;
begin
  if Main.fLocalMode then
    aIni := TIniFile.Create(Data.GetDomainName + '\' + cLocalVerIniFile)
  else
    aIni := TIniFile.Create(GetAppDir + cLocalVerIniFile);
  try
    aHost := aIni.ReadString('DATABASE', 'HOST', 'svbyprissq8'); //19.11.2014
    //aHost := aIni.ReadString('DATABASE', 'HOST', 'svbyprisa0012');
    aDB := aIni.ReadString('DATABASE', 'DB', 'CLIENT_INFO');

    aUser := 'Client_Data';
    aPass := 'Asdfa^%H';
  //  aUser := 'LocalSPtest';
  //  aPass := 'SPLocal';
    {$IFDEF PODOLSK}
      aHost := 'SVRUPODSA0014';
      aUser :=  Chr($73) + Chr($65) + Chr($72) + Chr($76) + Chr($69) + Chr($63) + Chr($65) +
                Chr($5F) + Chr($64) + Chr($69) + Chr($73) + Chr($63) + Chr($6F) + Chr($75) +
                Chr($6E) + Chr($74);
      aPass :=  Chr($53) + Chr($65) + Chr($72) + Chr($76) + Chr($69) + Chr($63) + Chr($65) +
                Chr($21) + Chr($21) + Chr($21);
    {$ENDIF}
  finally
    aIni.Free;
  end;

  Result := TAdoConnection.Create(nil);
  Result.LoginPrompt := False;
  Result.ConnectionString := 'Provider=SQLOLEDB.1;Persist Security Info=True;' +
    Format('Data Source=%s;Initial Catalog=%s;User ID=%s;Password=%s;', [aHost, aDB, aUser, aPass]);
end;

function GetMsQuery(aConnection: TAdoConnection): TAdoQuery;
begin
  Result := TAdoQuery.Create(nil);
  Result.Connection := aConnection;
end;

function MSGetDiscounts(const aClientId: string; CurVersion,CurVersionAdr,CurVersionAgr: Integer;
                        out aNewVersion,aNewVersionAdr,aNewVersionAgr: Integer;
                        out aPass: string;
                        const aSaveToFile: string; const aSaveToStreamAdr,aSaveToStreamAgr:TMemoryStream): String;
var
  aConnection: TAdoConnection;
  aQuery: TAdoQuery;
begin
  Result := '';
  aPass := '';
  try
    aConnection := GetMsConnection;
    aQuery := GetMsQuery(aConnection);
    try
      aConnection.Connected := True;

      aQuery.SQL.Text :=
        ' SELECT DISCOUNT_VER, RESPOND_ZIP, PRIVATE_KEY, ADDRESS_VER, ADDRESS_ZIP, AGREEMENTS_VER, AGREEMENTS_ZIP FROM CLIENTS WHERE CLIENT_ID = ''' + aClientId + ''' ';
      aQuery.Open;
      if not aQuery.Eof then
      begin
        aNewVersion := aQuery.FieldByName('DISCOUNT_VER').AsInteger;
        aNewVersionAdr := aQuery.FieldByName('ADDRESS_VER').AsInteger;
        aNewVersionAgr := aQuery.FieldByName('AGREEMENTS_VER').AsInteger;
        aPass := aQuery.FieldByName('PRIVATE_KEY').AsString;

        Result := '';
        if CurVersion <= aNewVersion then
        begin
          DeleteFile(pChar(aSaveToFile));
          TBlobField(aQuery.FieldByName('RESPOND_ZIP')).SaveToFile(aSaveToFile);
          Result := '3';
        end;

        if CurVersionAdr <= aNewVersionAdr then
        begin
          TBlobField(aQuery.FieldByName('ADDRESS_ZIP')).SaveToStream(aSaveToStreamAdr);
          Result := Result + '1';
        end;

        if CurVersionAgr <= aNewVersionAgr then
        begin
          TBlobField(aQuery.FieldByName('AGREEMENTS_ZIP')).SaveToStream(aSaveToStreamAgr);
          Result := Result + '2';
        end
      end; //else - клиент не найден
      aQuery.Close;

      aConnection.Connected := False;
    finally
      aQuery.Free;
      aConnection.Free;
    end;
  except
    Exit;
  end;
end;

function UpdateDiscountsAll(aVersions: TStrings): Integer; {version}
var
  i: Integer;
  aConnection: TAdoConnection;
  aQuery: TAdoQuery;
  aNewVersion, aCurVersion: Integer;
  aClientId: string;
  aStreamZipped, aStream: TMemoryStream;
begin
  Result := 0;

  try
    Main.ShowProgrInfo('Загрузка скидок...');
    Main.ShowProgress('Загрузка скидок...');
    aConnection := GetMsConnection;
    aQuery := GetMsQuery(aConnection);

    aStreamZipped := TMemoryStream.Create;
    aStream := TMemoryStream.Create;
    try
      aConnection.Connected := True;

      aQuery.SQL.Text :=
        ' SELECT VERSION FROM VERSIONS WHERE PARAM = ''DISCOUNTS'' ';
      aQuery.Open;
      Result := aQuery.FieldByName('VERSION').AsInteger;
      aQuery.Close;

      for i := 0 to aVersions.Count - 1 do
      begin
        aClientId := aVersions.Names[i];
        aCurVersion := StrToIntDef(aVersions.ValueFromIndex[i], 0);

        aQuery.SQL.Text :=
          ' SELECT DISCOUNT_VER, RESPOND_ZIP, PRIVATE_KEY FROM CLIENTS WHERE CLIENT_ID = ''' + aClientId + ''' ';
        aQuery.Open;
        if not aQuery.Eof then
        begin
          aNewVersion := aQuery.FieldByName('DISCOUNT_VER').AsInteger;
          if aCurVersion <> aNewVersion then
          begin
            aStreamZipped.Clear;
            aStream.Clear;
            TBlobField(aQuery.FieldByName('RESPOND_ZIP')).SaveToStream(aStreamZipped);

            if Main.UnzipStream2Stream(aStreamZipped, aStream, 'discounts', aQuery.FieldByName('PRIVATE_KEY').AsString) then
              Main.ApplyDiscounts2DB(aStream, aClientID, aNewVersion);
          end;
        end; //else - клиент не найден

        Main.CurrProgress((i + 1) * 100 div aVersions.Count);
        
        aQuery.Close;
      end;

      aConnection.Connected := False;
    finally
      Main.HideProgress;
      aStreamZipped.Free;
      aStream.Free;
      aQuery.Free;
      aConnection.Free;
    end;
  except
    Exit;
  end;
end;

function UpdateClientsAll(aCurVersion: Integer; aClientsTable: TDBISamTable; const aCustomEmail: string; aSilentMode: Boolean): Integer; {version}
var
  i, iMax: Integer;
  aConnection: TAdoConnection;
  aQuery: TAdoQuery;
  p: Integer;
  aDescr, aEMail: string;
  aCountInsert, aCountUpdate, aCountDelete: Integer;
  slDelete: TStrings;
  aInd: Integer;
begin
  aCountInsert := 0;
  aCountUpdate := 0;
  aCountDelete := 0;

  try
    Main.ShowProgrInfo('Загрузка базы клиентов...');
    Main.ShowProgress('Загрузка базы клиентов...');
    aConnection := GetMsConnection;
    aQuery := GetMsQuery(aConnection);

    slDelete := TStringList.Create;

    aClientsTable.IndexName := 'Client_ID';
    aClientsTable.Open;
    aClientsTable.First;
    while not aClientsTable.Eof do
    begin
      slDelete.Add(aClientsTable.FieldByName('CLIENT_ID').AsString);
      aClientsTable.Next;
    end;

    try
      aConnection.Connected := True;

      aQuery.SQL.Text :=
        ' SELECT VERSION FROM VERSIONS WHERE PARAM = ''CLIENTS'' ';
      aQuery.Open;
      Result := aQuery.FieldByName('VERSION').AsInteger;
      aQuery.Close;

      if aCurVersion = Result then
      begin
        if not aSilentMode then
        begin
          if Application.MessageBox(
            PChar('У Вас самая последния версия, обновить принудительно?'),
            'Подтверждение',
            MB_YESNO or MB_ICONINFORMATION
          ) <> IDYES then
            Exit;
        end
        else
          Exit;
      end;

      aQuery.SQL.Text := ' SELECT Count(*) FROM CLIENTS ';
      aQuery.Open;
      iMax := aQuery.Fields[0].AsInteger;
      aQuery.Close;

      aQuery.SQL.Text :=
        ' SELECT c.CLIENT_ID, cd.NAME, cd.DESCRIPTION FROM clients c ' +
        ' LEFT JOIN CLIENTS_DESCR cd ON (cd.CLIENT_ID = c.CLIENT_ID) ';
      aQuery.Open;

      i := 0;
      while not aQuery.Eof do
      begin
        if aClientsTable.FindKey([aQuery.FieldByName('CLIENT_ID').AsString]) then
        begin
          aClientsTable.Edit;
          aInd := slDelete.IndexOf(aQuery.FieldByName('CLIENT_ID').AsString);
          if aInd >= 0 then
            slDelete.Delete(aInd);
          Inc(aCountUpdate);
        end
        else
        begin
          aClientsTable.Append;
          aClientsTable.FieldByName('CLIENT_ID').AsString := aQuery.FieldByName('CLIENT_ID').AsString;
          aClientsTable.FieldByName('UpdateDisc').AsBoolean := False;

          Inc(aCountInsert);
        end;

        aDescr := aQuery.FieldByName('DESCRIPTION').AsString;
        if aCustomEmail <> '' then
          aEMail := aCustomEmail
        else
        begin
          p := POS(', E-Mail: ', aDescr);
          if p > 0 then
            aEMail := Copy(aDescr, p + Length(', E-Mail: '), MaxInt)
          else
            aEMail := '';
        end;

        aClientsTable.FieldByName('Description').AsString := aQuery.FieldByName('NAME').AsString;
        aClientsTable.FieldByName('email').AsString := aEMail;
        aClientsTable.FieldByName('Key').AsString := '';
        if aClientsTable.FieldByName('Order_type').IsNull then
          aClientsTable.FieldByName('Order_type').AsString := 'A';
        if aClientsTable.FieldByName('Delivery').IsNull then
          aClientsTable.FieldByName('Delivery').AsInteger := 1;

        aClientsTable.Post;

        aQuery.Next;

        Inc(i);
        if (i mod 100 = 0) or (i = iMax) then
          Main.CurrProgress(i * 100 div iMax);
      end;
                        
      for i := 0 to slDelete.Count - 1 do
      begin
        if aClientsTable.FindKey([slDelete[i]]) then
        begin
          aClientsTable.Delete;
          Inc(aCountDelete);
        end;
      end;
      aClientsTable.Close;

      aQuery.Close;
      aConnection.Connected := False;
    finally
      Main.HideProgress;
      aQuery.Free;
      aConnection.Free;
      aClientsTable.Close;
      slDelete.Free;
    end;
  except
    on E: Exception do
    begin
      Result := 0;

      if not aSilentMode then
        Application.MessageBox(PChar('Ошибка при обновлении базы клиентов: ' + E.Message), 'Ошибка', MB_OK or MB_ICONWARNING);

      Exit;
    end;
  end;

  if not aSilentMode then
    Application.MessageBox(
      PChar(Format('Добавлено: %d'#13#10'Обновлено: %d'#13#10'Удалено: %d', [aCountInsert, aCountUpdate, aCountDelete])),
      'Отчет',
      MB_OK or MB_ICONINFORMATION
    );
end;

end.

