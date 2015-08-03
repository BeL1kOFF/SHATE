unit uSmtpThreadRe;

interface

uses
  Classes, SysUtils,
  IdMessageClient, IdSMTPBase, IdSMTP, IdMessage, IdCoderHeader,
  uMain, IdAttachmentFile, _CSVReader;

const 
  cSendMailInterval = 15;
  
type
  TMyIdMessage = class(TIdMessage)
  protected
    procedure OnISO(var VTransferHeader: TTransfer; var VHeaderEncoding: Char; var VCharSet: string);
  public
    constructor Create(AOwner: TComponent);
  end;

  TSendDataRe = class
  public
    EmailTo: string;
    Name: string;
    
    StreamZakazano: TMemoryStream;
    StreamZameny: TMemoryStream;
    StreamLog: TMemoryStream;

    NameZakazano: string;
    NameZameny: string;
    NameLog: string;

    OrderDate: string;

    ClientId: string;
    Num: string;
    LotusNum: string;
    isRetDoc: Boolean;
    ReplacedCodes: string;
  public  
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
  end;
  
  TSMTPMessagesReThrd = class(TThread)
  private
    fOwnerService: TOrdServiceIMAP;
    fPrefs: TPrefs;
  private 
    fLastID: Integer;
//    procedure DoSendOld;
    procedure SendResponseBath;
    function SendResponse(aSendData: TSendDataRe): Boolean;
    
    function UnzipStream2File(aStreamIn: TStream; const aFileOut, aFileName: string; const aPassword: string = ''): Boolean;
    function UnzipStream2Stream(aStreamIn, aStreamOut: TStream; const aFileName: string; const aPassword: string = ''): Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(aOwnerService: TOrdServiceIMAP);
    procedure Init(const aPrefs: TPrefs);
  end;

implementation

uses
  Windows, ADODB, DB, VCLUnZip, IdText, uSysGlobal;

{ TSMTPMessagesReThrd }

constructor TSMTPMessagesReThrd.Create(aOwnerService: TOrdServiceIMAP);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  fOwnerService := aOwnerService;
end;

(*
procedure TSMTPMessagesReThrd.DoSendOld;
var
  aNum: Integer;
  Client: TMessSMTP;
  IdMessage: TIdMessage;
  SMTP: TIdSMTP;
  bPost: Boolean;
  aList: TList;
begin
  fOwnerService.AddLog('TSMTPThread started', True);
  try
    fOwnerService.AddLog('SMTP - старт');
    aNum := 1;
    IdMessage := TMyIdMessage.Create(nil);
    SMTP := TIdSMTP.Create(nil);
    try
      while not Terminated do
      begin
        Client := nil;
        aList := fMessages.LockList;
        try
          if aList.Count > 0 then
            Client := aList.Items[0];
        finally
          fMessages.UnlockList;
        end;

        if Assigned(Client) then
        begin
          fOwnerService.AddLog('SMTP - отправка #' + IntToStr(aNum) + ' <' + Client.ShateEmail + '>', True);

          with IdMessage do
          begin
            ContentType := 'multipart/mixed; charset=windows-1251';
            Recipients.EmailAddresses := Client.ShateEmail;
            Subject :=Client.subj;
            Body.Clear;
            Body.Text := Client.body;
            From.Text := Client.email;
            MessageParts.Clear;
          end;
          SMTP.Host  := Client.Host;
          SMTP.Port := Client.Port;
          SMTP.Username := Client.Username;
          SMTP.Password := Client.Password;
          fOwnerService.AddLog(Client.fn + ';' + Client.fn_orig);
          if Client.fn <> '' then
            TIdAttachmentFile.Create(IdMessage.MessageParts, Client.fn); 
          if Client.fn_orig <> '' then
            TIdAttachmentFile.Create(IdMessage.MessageParts, Client.fn_orig); 
          bPost := False;
          try
            with SMTP do
            begin
              try
                Connect;
                try
                  Send(IdMessage);
                  bPost := True;
                except
                  on e: Exception do
                  begin
                    fOwnerService.AddLog('SMTP - ' + e.Message);
                    bPost := False;
                  end;
                end;
              except
                on e: Exception do
                begin
                  fOwnerService.AddLog('SMTP - ' + e.Message);
                  bPost := False;
                end;
              end;
              Disconnect;
            end;
          except
            on e: Exception do
            begin
              bPost := FALSE;
              fOwnerService.AddLog('SMTP - ' + e.Message);
            end;
          end;
                                     
          if(bPost)then
          begin
            Inc(aNum);
            fOwnerService.AddLog('SMTP - отправлено');
            //thread-safe remove
            fMessages.Remove(Client);
            Client.Free;
          end
          else
          begin
            Inc(Client.TrySendCount);
            if Client.TrySendCount >= 10 then
            begin
              fOwnerService.AddLog('!SMTP - 10 неудачных попыток отправки, письмо удалено');
              fMessages.Remove(Client);
            end
            else
            begin
              //переносим в конец очереди
              aList := fMessages.LockList;
              try
                aList.Remove(Client);
                aList.Add(Client);
              finally
                fMessages.UnlockList
              end;
            end;
          end;
        end;
        if Terminated then
          Break;
        Sleep(250);
      end;
    finally
      IdMessage.Free;
      SMTP.Free;
    end;
    fOwnerService.AddLog('SMTP - стоп');

  except
    on E: Exception do
      fOwnerService.AddLog('!EXCEPTION (SMTP): ' + E.Message);
  end;
  fOwnerService.AddLog('TSMTPThread stopped', True);
end;
*)

procedure TSMTPMessagesReThrd.Execute;
var
  t: Cardinal;
  aFirstRun: Boolean;
begin
  fLastID := 0;

  fOwnerService.AddLogRe('TSMTPThreadResponse started', True);
  aFirstRun := True;

  //Sleep(20000);
  
  t := 0;
  while not Terminated do
  begin
    if GetTickCount - t > cSendMailInterval * 1000 then //60 сек
    begin
      try
        if aFirstRun then
        begin
          aFirstRun := False;

          //sleep(20000);
          //fOwnerService.makeAllForAndroid;

          //task for first run - start here..
          //if fPrefs.RebuildAllTTNOnStartup then
          //  fOwnerService.AddAllTtn2DB;
        end;

        if not Terminated then
        begin
          SendResponseBath;
        end;

      except
        on E: Exception do
        begin
          fOwnerService.AddLogRe('!EXCEPTION(TSMTPMessagesReThrd.Execute): ' + E.Message);
          fOwnerService.AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!EXCEPTION(TSMTPMessagesReThrd.Execute): ' + E.Message, True);
        end;
      end;
      t := GetTickCount;
      fOwnerService.AddLogRe('Спим ' + IntToStr(cSendMailInterval) + ' сек...', True);
    end;
    Sleep(250);
  end;
  fOwnerService.AddLogRe('TSMTPThreadResponse stopped', True);
end;

procedure TSMTPMessagesReThrd.Init(const aPrefs: TPrefs);
begin
  fPrefs := aPrefs;
end;

function TSMTPMessagesReThrd.SendResponse(aSendData: TSendDataRe): Boolean;

  function ParseZakazano(const aFileName: string; aFillCountsTo: TStrings; out aIsLocked: Boolean): string;
  var
    aReader: TCSVReader;
    i: Integer;
    aCurrencyAgr: string;
    aPrice, aPriceSum, aSum, aCount: Currency;
  begin
    Result := '';
    aReader := TCSVReader.Create;
    try
      aReader.Open(aFileName);
      
      i := 0;
      aReader.ReturnLine; //шапка

      if not SameText(aReader.Fields[0], 'Zakazano') then
        Exit;
      
      //Признак "Счет заблокирован"
      aIsLocked := False;
      if aReader.FieldsCount >= 9 then
        aIsLocked := aReader.Fields[7] = '1';
      
      aCurrencyAgr := aReader.Fields[5]; //код валюты договора
      
      aSum := 0.0;
      aPrice := 0.0;
      aPriceSum := 0.0;
      
      while not aReader.Eof do
      begin
        Inc(i);
        aReader.ReturnLine;
        //aReader.Fields[4] - цена в валюте договора
        //0281002138_BOSCH;1;;20.1999310582557739;234400;

        aPrice := StrToFloatDefUnic(aReader.Fields[4], 0.0);
        aPriceSum := aPrice * StrToFloatDefUnic(aReader.Fields[1], 0.0);
        aSum := aSum + aPriceSum;
        
        Result := Result + '  ' + IntToStr(i) + '. ' + aReader.Fields[0] + 
          ' - ' + aReader.Fields[1] + ' ' + aReader.Fields[8] + 
          ' по цене ' + FormatFloat('0.##', aPrice) + 
          ' на сумму ' + FormatFloat('0.##', aPriceSum) + #13#10;
        aFillCountsTo.Add(aReader.Fields[0] + '=' + aReader.Fields[1]);
      end;
      Result := Result + #13#10#13#10 + 'Общая сумма резерва ' + FormatFloat('0.##', aSum) + #13#10;
      
    finally
      aReader.Free;
    end;
  end;

  function ParseZameny(const aFileName: string): string;
  var
    aReader: TCSVReader;
    i: Integer;
    aCodePrev, s: string;
  begin
    Result := '';
    aReader := TCSVReader.Create;
    try
      aReader.Open(aFileName);

      i := 0;
      aCodePrev := '***';
      s := '';
      aReader.ReturnLine; //шапка
      while not aReader.Eof do
      begin
        aReader.ReturnLine;
        if aCodePrev = '***' then
          aCodePrev := aReader.Fields[6];
        //P101630_PATRON;1;87;;5.81;67169.41;0630_ZEN;346157;022255
        //SD-2118_UNIPOINT;1;85;;6.74;77921.14;0630_ZEN;653233;022255

        if (aCodePrev <> aReader.Fields[6]) then
        begin
          Inc(i);
          Result := Result + '  ' + IntToStr(i) + '. ' + aCodePrev + ' - (' + s + ')' + #13#10;
          aCodePrev := aReader.Fields[6];
          s := '';
        end;
        
        if s = '' then
          s := aReader.Fields[0]
        else  
          s := s + ', ' + aReader.Fields[0];        

        if aReader.Eof then  
        begin
          Inc(i);
          Result := Result + '  ' + IntToStr(i) + '. ' + aCodePrev + ' - (' + s + ')' + #13#10;
        end;
      end;
    finally
      aReader.Free;
    end;
  end;
  
  function ParseLog(const aFileName: string; slZakazano: TStrings; out aLost, aPart, aKrat, aErr, aSysErr: string): string;
  var
    aReader: TCSVReader;
    i: Integer;
    iLost, iPart, iKrat, iErr, iSysErr, p1, p2: Integer;
    iZak: Integer;
    sReserved, aErrText: string;
  begin
    Result := '';
    aLost := ''; iLost := 0;
    aPart := ''; iPart := 0;
    aKrat := ''; iKrat := 0;
    aErr := '';  iErr  := 0;
    aSysErr := ''; iSysErr  := 0;
    iZak := -1;
    
    aReader := TCSVReader.Create;
    try
      aReader.Open(aFileName);

      while not aReader.Eof do
      begin
        aReader.ReturnLine;
        i := StrToIntDef(aReader.Fields[0], -1);
        //<0-статус>;<1-описание статуса>;<2-товар>;<3-кол-во в заказе>;<4-зарезервировано>
        case i of
          0: ;//sWrite := '0;Не обработано;'+aQuery.Fields[1].AsString+';'+aQuery.Fields[2].AsString+';';
          1: //sWrite := '1;Товар не найден;'+aQuery.Fields[1].AsString+';'+aQuery.Fields[2].AsString+';';
          begin
            Inc(iErr);
            aErr := aErr + '  ' + IntToStr(iErr) + '. ' + aReader.Fields[2] + ' - ошибка, товар не найден'#13#10;
          end;
          2: //sWrite := '2;Некорректное кол-во;'+aQuery.Fields[1].AsString+';'+aQuery.Fields[2].AsString+';';
          begin
            Inc(iErr);
            aErr := aErr + '  ' + IntToStr(iErr) + '. ' + aReader.Fields[2] + ' - ошибка, некорректное кол-во (' + aReader.Fields[3] + ')'#13#10;
          end;
          3: //sWrite := '3;Неполный резерв;'+aQuery.Fields[1].AsString+';'+aQuery.Fields[2].AsString+';доступно;'+aQuery.Fields[3].AsString
          begin
            Inc(iPart);
            Inc(iZak);
            aPart := aPart + '  ' + IntToStr(iPart) + '. ' + aReader.Fields[2] + ' - неполный резерв (' + aReader.Fields[4] + ' из ' + aReader.Fields[3] + ')'#13#10;
          end;
          4: //sWrite := '4;Ошибка;'+aQuery.Fields[1].AsString+';'+aQuery.Fields[2].AsString;
          begin
            Inc(iErr);

            aErrText := 'ошибка';
            //Возвраты продажи запрещены на складе SHATE-S01 
            //для Все клиенты , группа договоров НАЛ. ,Все товары: , %3: %4 после 61 дней от даты продажи.
            if POS('Возвраты продажи запрещены', aReader.Fields[5]) > 0 then
            begin
              aErrText := 'Возвраты продажи запрещены ';
              p1 := POS('после', aReader.Fields[5]);
              p2 := POS('от даты продажи', aReader.Fields[5]);
              if (p1 > 0) and (p2 > 0) then
                aErrText := aErrText + Copy(aReader.Fields[5], p1, MaxInt);
            end;
            
            aErr := aErr + '  ' + IntToStr(iErr) + '. ' + aReader.Fields[2] + ' - ' + aErrText + #13#10;

            Inc(iSysErr);
            aSysErr := aSysErr + '  ' + IntToStr(iSysErr) + '. ' + aReader.Fields[2] + ' - ' + aReader.Fields[5] + #13#10;
          end;
          5: //sWrite := '5;Зарезервировано;'+aQuery.Fields[1].AsString+';'+aQuery.Fields[2].AsString;
          begin
            Inc(iZak);
            Result := Result + aReader.Fields[2] + ' - зарезервировано (' + aReader.Fields[4] + ')'#13#10;
          end;
          6: //sWrite := '6;Корректировка кол-ва;'+aQuery.Fields[1].AsString+';'+aQuery.Fields[2].AsString;
          begin
            Inc(iKrat);
            Inc(iZak);

            sReserved := '';
            {
            if (iZak >= 0) and (iZak < slZakazano.Count) then
              if aReader.Fields[2] = slZakazano.Names[iZak] then
                sReserved := slZakazano.ValueFromIndex[iZak];
            }    
            sReserved := aReader.Fields[4];
            
            aKrat := aKrat + '  ' + IntToStr(iKrat) + '. ' + aReader.Fields[2] + ' - корректировка количества по кратности (заказано ' + aReader.Fields[3] + ', увеличено до ' + sReserved + ')'#13#10;
          end;
          7: //sWrite := '7;отсутствует;'+aQuery.Fields[1].AsString+';'+aQuery.Fields[2].AsString+';доступно;'+aQuery.Fields[3].AsString
          begin
            Inc(iLost);
            aLost := aLost + '  ' + IntToStr(iLost) + '. ' + aReader.Fields[2] + ' - отсутствует (' + aReader.Fields[4] + ' из ' + aReader.Fields[3] + ')'#13#10;
          end;
        end;
      end;
    finally
      aReader.Free;
    end;
  end;

  procedure ReplaceResponseCodes(const aFileName: string; aReplacedCodes: string);
  var
    sl, slRepl: TStrings;
    s: string;
    i: Integer;
    sFrom, sTo: string;
  begin
    Exit;
    //не используется здесь - перенесено в службу которая собирает файлы ответов (ClientDataService)
  
    sl := TStringList.Create;
    slRepl := TStringList.Create;
    try
      sl.LoadFromFile(aFileName);
      s := sl.Text;

      slRepl.Text := aReplacedCodes;
      for i := 0 to slRepl.Count - 1 do
      begin
        sFrom := slRepl.ValueFromIndex[i] + ';';
        sTo := slRepl.Names[i] + ';';
        if (sFrom <> ';') and (sTo <> ';') then
          s := StringReplace(s, sFrom, sTo, [rfIgnoreCase, rfReplaceAll]);
      end;

      sl.Text := s;
      sl.SaveToFile(aFileName);
    finally
      sl.Free;
      slRepl.Free;
    end;
  end;

var
  IdMessage: TMyIdMessage;
  SMTP: TIdSMTP;
  UnzipPath: string;
  sOrderType, s: string;

  sLost, sPart, sKrat, sErr, sSysErr: string;
  slZakazano: TStrings;
  idTextPart: TIdText;
  aEmailManager: string;
  aIsLocked: Boolean;
  aLineNumLocked: Integer;
begin
  Result := False;

  fOwnerService.AddLogRe('', False, True);
  fOwnerService.AddLogRe(Format('>>Отправка %s_%s - %s', [aSendData.ClientId, aSendData.Num, aSendData.EmailTo]));

  sLost := '';
  sPart := '';
  sKrat := '';
  sErr := '';
  sSysErr := '';
  aEmailManager := '';
  
  if aSendData.isRetDoc then
    sOrderType := 'возврат'
  else  
    sOrderType := 'заказ';

  slZakazano := TStringList.Create;
  IdMessage := TMyIdMessage.Create(nil);
  idTextPart := TIdText.Create(IdMessage.MessageParts, nil);
  
  SMTP := TIdSMTP.Create(nil);
  try
    with IdMessage do
    begin
      CharSet := 'windows-1251';
      ContentType := 'multipart/mixed';
      Encoding := meMIME;
      
      Recipients.EmailAddresses := aSendData.EmailTo; {'Doynikov@shate-m.com';}
      aEmailManager := fOwnerService.ManagersMap.Values[aSendData.ClientId];
      if aEmailManager <> '' then
        BccList.EMailAddresses := aEmailManager;// + ',Doynikov@shate-m.com';
      fOwnerService.AddLogRe('bcc: ' + aEmailManager);
        
      Subject := sOrderType + ' ' + aSendData.Num + ' от ' + aSendData.OrderDate + ' (' + aSendData.Name + ')';

      From.Text := 'Служба оповещения "Шате-М+"';
      From.Name := 'Служба оповещения "Шате-М+"';
      From.Address := 'noreply@shate-m.com';  
      
      Body.Clear;

//      idTextPart.ContentType:='text/plain';
      idTextPart.ContentType:='text/plain';
      idTextPart.CharSet := 'windows-1251';
      idTextPart.ParentPart := -1;        
      
      idTextPart.Body.Add('*Это письмо создано автоматически, отвечать на него не нужно*');
      idTextPart.Body.Add('');
      aLineNumLocked := idTextPart.Body.Count - 1;
      idTextPart.Body.Add('Уважаемый клиент ' + aSendData.Name);
      idTextPart.Body.Add('На ваш ' + sOrderType + ' ' + aSendData.Num + ' от ' + aSendData.OrderDate + ' сообщаем ');
    end;
    
    UnzipPath := ExtractFilePath(ParamStr(0)) + 'Response\';
    if aSendData.NameZakazano <> '' then
    begin
//      fOwnerService.AddLogRe('UnzipStream2File');
      UnzipStream2File(aSendData.StreamZakazano, UnzipPath + aSendData.NameZakazano, aSendData.NameZakazano);

      ReplaceResponseCodes(UnzipPath + aSendData.NameZakazano, aSendData.ReplacedCodes);
      
//      fOwnerService.AddLogRe('UnzipStream2File ok');
      TIdAttachmentFile.Create(IdMessage.MessageParts, UnzipPath + aSendData.NameZakazano);
      fOwnerService.AddLogRe(aSendData.NameZakazano);

      idTextPart.Body.Add('');

      aIsLocked := False;
      s := ParseZakazano(UnzipPath + aSendData.NameZakazano, slZakazano, aIsLocked);
      if s = '' then
        idTextPart.Body.Add('Не удалось зарезервировать ни одной позиции')
      else
      begin
        if aIsLocked then
        begin
          idTextPart.Body.Insert(aLineNumLocked, '!ВНИМАНИЕ! Ваш счет заблокирован. Пожалуйста, свяжитесь со своим менеджером.');
          idTextPart.Body.Insert(aLineNumLocked, '');
          IdMessage.Subject := 'Ваш счет заблокирован! ' + IdMessage.Subject;
        end;
          
        idTextPart.Body.Add('');
        idTextPart.Body.Add('Успешно зарезервирован следующий товар: см. вложение ' + aSendData.NameZakazano);
        idTextPart.Body.Add(s);
        idTextPart.Body.Add('Внутренний номер заказа ' + aSendData.LotusNum + ' (назовите его для ускорения обработки оператором при обращении в нашу компанию)');
      end;  
    end;


    if aSendData.NameLog <> '' then
    begin
      UnzipStream2File(aSendData.StreamLog, UnzipPath + aSendData.NameLog, aSendData.NameLog);

      ReplaceResponseCodes(UnzipPath + aSendData.NameLog, aSendData.ReplacedCodes);
      
      //TIdAttachmentFile.Create(IdMessage.MessageParts, UnzipPath + aSendData.NameLog);
      fOwnerService.AddLogRe(aSendData.NameLog);
      
      idTextPart.Body.Add('');
//      idTextPart.Body.Add('Корректировки: см. вложение ' + aSendData.NameLog);
      
      s := ParseLog(UnzipPath + aSendData.NameLog, slZakazano, sLost, sPart, sKrat, sErr, sSysErr);

      if (sKrat <> '') or (sPart <> '') then
      begin
        idTextPart.Body.Add('');
        idTextPart.Body.Add('----------------------------------------------------');
        //idTextPart.Body.Add('Для следующего товара были осуществлены корректировки: см. вложение ' + aSendData.NameLog);
        idTextPart.Body.Add('Для следующего товара были осуществлены корректировки: ');
        if (sKrat <> '') then
          idTextPart.Body.Add(sKrat);
        if (sPart <> '') then
          idTextPart.Body.Add(sPart);
      end;
      
      if sLost <> '' then
      begin
        idTextPart.Body.Add('');
        idTextPart.Body.Add('----------------------------------------------------');
        idTextPart.Body.Add('Следующий товар не был зарезервирован по причине отсутствия:');
        idTextPart.Body.Add(sLost);
      end;

      if sErr <> '' then
      begin
        idTextPart.Body.Add('');
        idTextPart.Body.Add('----------------------------------------------------');
        idTextPart.Body.Add('Следующий товар не был зарезервирован по другим причинам:');
        idTextPart.Body.Add(sErr);
      end;
      
      //idTextPart.Body.Add(s);
    end;
    
    
    if aSendData.NameZameny <> '' then
    begin
      UnzipStream2File(aSendData.StreamZameny, UnzipPath + aSendData.NameZameny, aSendData.NameZameny);
      ReplaceResponseCodes(UnzipPath + aSendData.NameZameny, aSendData.ReplacedCodes);
      
      s := ParseZameny(UnzipPath + aSendData.NameZameny);
      if s <> '' then
      begin
        TIdAttachmentFile.Create(IdMessage.MessageParts, UnzipPath + aSendData.NameZameny);
        fOwnerService.AddLogRe(aSendData.NameZameny);
        idTextPart.Body.Add('');
        idTextPart.Body.Add('Предлагаемые замены для отсутствующего товара: см. вложение ' + aSendData.NameZameny);
        idTextPart.Body.Add(s);
      end;
    end;
    
     
    idTextPart.Body.Add('');
    idTextPart.Body.Add('');
    idTextPart.Body.Add('');
    idTextPart.Body.Add('Спасибо за заказ');
    idTextPart.Body.Add('=====================');
    idTextPart.Body.Add('С уважением отдел продаж Шате-М +');
    
    
    try
      SMTP.Host  := fPrefs.MailHost;
      SMTP.Port := fPrefs.MailPort;
      SMTP.Username := '';
      SMTP.Password := '';

      with SMTP do
      begin
        try
          fOwnerService.AddLogRe('<<Отправка - start..');
          Connect;
          try
            Send(IdMessage);
            fOwnerService.AddLogRe('<<Отправка - ОК');
            Result := True;

            //копия письма с системными ошибками - менеджеру и мне
            if sSysErr <> '' then
            begin
              if aEmailManager <> '' then
                IdMessage.Recipients.EmailAddresses := aEmailManager
              else  
                IdMessage.Recipients.EmailAddresses := 'Yury.Kornelyuk@shate-m.com';
                
              IdMessage.CCList.EMailAddresses := 'Sergey.Doynikov@shate-m.com';
              IdMessage.Subject := 
                '!ошибка резерва! ' + sOrderType + ' ' + aSendData.Num + ' от ' + aSendData.OrderDate + ' (' + aSendData.Name + ')';
              idTextPart.Body.Insert(0, '!Внимание! Следующие товары не были зарезервированы в связи с техническими ошибками:'#13#10 + sSysErr + #13#10);  
              Send(IdMessage); 
            end;

            
          except
            on e: Exception do
            begin
              fOwnerService.AddLogRe('SMTP - ' + e.Message);
            end;
          end;

        except
          on e: Exception do
          begin
            fOwnerService.AddLogRe('SMTP - ' + e.Message);
          end;
        end;

        Disconnect;
      end;
    except
      on e: Exception do
      begin
        fOwnerService.AddLogRe('SMTP - ' + e.Message);
      end;
    end;
  
  finally
    slZakazano.Free;
    idTextPart.Free;
    IdMessage.Free;
    SMTP.Free;
  end;
end;

procedure TSMTPMessagesReThrd.SendResponseBath;
var
  aConn: TAdoConnection;
  aQuery, aQueryUpdate: TAdoQuery;
  aClientPrev, aNumPrev, aPrevID: string;
  aSendData: TSendDataRe;
  aQueryClients: TAdoQuery;
begin
  fOwnerService.AddLogRe('Отправка пачки..');
  aConn := fOwnerService.DBConnectNew;
  aQuery := TAdoQuery.Create(nil);
  aQueryClients := TAdoQuery.Create(nil);
  aQueryUpdate := TAdoQuery.Create(nil);
  try
    aQueryUpdate.Connection := aConn;
    aQueryClients.Connection := aConn;
  
    aQuery.Connection := aConn;
    aQuery.CursorLocation := clUseClient;
    aQuery.CursorType := ctStatic;
    aQuery.SQL.Text := 
      ' SELECT TOP 100 i.ID, i.CLIENT_ID, i.NUM, i.EMAIL, f.DATA, f.FILE_TYPE, f.FILE_NAME, i.DT_INSERT, f.LOTUS_NUM, f.IS_RETDOC, i.REPLACED_CODES FROM INCOMING i ' +
      ' LEFT JOIN Files f on (i.CLIENT_ID = f.CLIENT_ID and i.NUM = f.NUM) ' +
      ' WHERE i.SEND_ASK = 1 AND i.CLIENT_ID <> ''123456789'' AND i.SEND_RESPONSE_COUNT < :SEND_RESPONSE_COUNT' +
      ' ORDER BY i.ID, i.CLIENT_ID, i.NUM ';
    aQuery.Parameters[0].Value := fPrefs.SendResponseCount;
    aQuery.Open;

    fOwnerService.AddLogRe('Query opened');
    
    aPrevID := '';
    aClientPrev := '';
    aNumPrev := '';
    aSendData := TSendDataRe.Create;
    
    while not aQuery.Eof do 
    begin
      if Terminated then
        Break;
        
      if (aClientPrev <> '') and (
         (aClientPrev <> aQuery.FieldByName('CLIENT_ID').AsString) or
         (aNumPrev <> aQuery.FieldByName('NUM').AsString) ) then
      begin //начало пачки файлов для отправки по клиенту/заказу
        //отправить предыдущую пачку
        if SendResponse(aSendData) then
        begin
          aQueryUpdate.SQL.Text := ' UPDATE INCOMING SET RESPONSE_SENDED = 1, SEND_ASK = 0 WHERE ID = :ID ';
          aQueryUpdate.Parameters[0].Value := aPrevID;
          aQueryUpdate.ExecSQL;
          fLastID := StrToIntDef(aPrevID, 0);
        end
        else
        begin
          aQueryUpdate.SQL.Text :=
            ' UPDATE INCOMING SET ' +
            '   SEND_RESPONSE_COUNT = COALESCE(SEND_RESPONSE_COUNT, 0) + 1 ' +
            ' WHERE ID = :ID ';
          aQueryUpdate.Parameters[0].Value := aPrevID;
          aQueryUpdate.ExecSQL;
        end;
        //--------------
        aSendData.Clear;
      end;

      aPrevID := aQuery.FieldByName('ID').AsString;
      aClientPrev := aQuery.FieldByName('CLIENT_ID').AsString;
      aNumPrev := aQuery.FieldByName('NUM').AsString;

      
      aSendData.ClientId := aQuery.FieldByName('CLIENT_ID').AsString;
      aSendData.Num := aQuery.FieldByName('NUM').AsString;
      aSendData.EmailTo := aQuery.FieldByName('EMAIL').AsString;
      aSendData.OrderDate := FormatDateTime('DD.MM.YYYY', aQuery.FieldByName('DT_INSERT').AsDateTime);
      case aQuery.FieldByName('FILE_TYPE').AsInteger of
        1:
        begin
          aSendData.ReplacedCodes := aQuery.FieldByName('REPLACED_CODES').AsString;
          aSendData.StreamZakazano.Clear;
          TBlobField(aQuery.FieldByName('DATA')).SaveToStream(aSendData.StreamZakazano);
          aSendData.NameZakazano := aQuery.FieldByName('FILE_NAME').AsString;
          aSendData.LotusNum := aQuery.FieldByName('LOTUS_NUM').AsString;
          aSendData.isRetDoc := aQuery.FieldByName('IS_RETDOC').AsInteger = 1;

          aQueryClients.SQL.Text := ' SELECT [NAME] FROM [CLIENT_INFO].[dbo].[CLIENTS_DESCR] WHERE CLIENT_ID = :CLIENT_ID ';
          aQueryClients.Parameters[0].Value := aSendData.ClientId;
          aQueryClients.Open;
          if not aQueryClients.Eof then
            aSendData.Name := aQueryClients.Fields[0].AsString;
          aQueryClients.Close;
        end;
        2:
        begin
          aSendData.StreamZameny.Clear;
          TBlobField(aQuery.FieldByName('DATA')).SaveToStream(aSendData.StreamZameny);
          aSendData.NameZameny := aQuery.FieldByName('FILE_NAME').AsString;
        end;
        4:
        begin
          aSendData.StreamLog.Clear;
          TBlobField(aQuery.FieldByName('DATA')).SaveToStream(aSendData.StreamLog);
          aSendData.NameLog := aQuery.FieldByName('FILE_NAME').AsString;
        end;
      end;

      aQuery.Next;

      if aQuery.Eof then
      begin
        //отправить предыдущую пачку
        if SendResponse(aSendData) then
        begin
          aQueryUpdate.SQL.Text := ' UPDATE INCOMING SET RESPONSE_SENDED = 1, SEND_ASK = 0 WHERE ID = :ID ';
          aQueryUpdate.Parameters[0].Value := aPrevID;
          aQueryUpdate.ExecSQL;
          fLastID := StrToIntDef(aPrevID, 0);
        end
        else
        begin
          aQueryUpdate.SQL.Text :=
            ' UPDATE INCOMING SET ' +
            ' SEND_RESPONSE_COUNT = COALESCE(SEND_RESPONSE_COUNT, 0) + 1 ' +
            ' WHERE ID = :ID ';
          aQueryUpdate.Parameters[0].Value := aPrevID;
          aQueryUpdate.ExecSQL;
        end;
        //--------------
      end;

    end;
    aSendData.Free;
    
  finally
    fOwnerService.DBDisconnectNew(aConn);
  end;
end;


function TSMTPMessagesReThrd.UnzipStream2File(aStreamIn: TStream;
  const aFileOut, aFileName, aPassword: string): Boolean;
var
  aFileStream: TFileStream;
begin
  aFileStream := TFileStream.Create(aFileOut, fmCreate);
  try
    UnzipStream2Stream(aStreamIn, aFileStream, aFileName, aPassword)
  finally
    aFileStream.Free;
  end;
end;

function TSMTPMessagesReThrd.UnzipStream2Stream(aStreamIn, aStreamOut: TStream;
  const aFileName, aPassword: string): Boolean;
var
  anUnZipper: TVCLUnZip;
begin
  Result := False;
  if not Assigned(aStreamIn) or not Assigned(aStreamOut) then
    Exit;

  aStreamIn.Position := 0;
  anUnZipper := TVCLUnZip.Create(nil);
  try
    anUnZipper.ArchiveStream := aStreamIn;
    anUnZipper.DoProcessMessages := False;
    anUnZipper.Password := aPassword;
    anUnZipper.UnZipToStream(aStreamOut, aFileName);
    anUnZipper.ArchiveStream := nil;
  finally
    anUnZipper.Free;
  end;

  Result := True;
end;

{ TMyIdMessage }

constructor TMyIdMessage.Create(AOwner: TComponent);
begin
  inherited;
  OnInitializeISO := OnISO;
end;

procedure TMyIdMessage.OnISO(var VTransferHeader: TTransfer;
  var VHeaderEncoding: Char; var VCharSet: string);
begin
  VCharSet:='windows-1251';
  VTransferHeader := bit8;
  VHeaderEncoding := '8';
end;

{ TSendDataRe }

procedure TSendDataRe.Clear;
begin
  StreamZakazano.Clear;
  StreamZameny.Clear;
  StreamLog.Clear;
  NameZakazano := '';
  NameZameny := '';
  NameLog := '';
  EmailTo := '';
  ClientId := '';
  Num := '';
  OrderDate := '';
  LotusNum := '';
  isRetDoc := False;
  Name := '';
end;

constructor TSendDataRe.Create;
begin
  StreamZakazano := TMemoryStream.Create;
  StreamZameny   := TMemoryStream.Create;
  StreamLog      := TMemoryStream.Create;
end;

destructor TSendDataRe.Destroy;
begin
  StreamZakazano.Free;
  StreamZameny.Free;
  StreamLog.Free;
  
  inherited;
end;

end.

