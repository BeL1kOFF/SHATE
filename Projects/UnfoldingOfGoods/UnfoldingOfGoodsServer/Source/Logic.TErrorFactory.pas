unit Logic.TErrorFactory;

interface

uses
  Logic.XmlResponse.TCustomXmlResponseError;

type
  TErrorFactory = class
  public
    class procedure SetSuccess(aError: ICustomXmlResponseError);
    class procedure SetUnknownMessage(aError: ICustomXmlResponseError);
    class procedure SetServerError(aError: ICustomXmlResponseError);
    class procedure SetServerError2(aError: ICustomXmlResponseError);
    class procedure SetExpiredSession(aError: ICustomXmlResponseError);
    class procedure SetUseLoginOtherTSD(aError: ICustomXmlResponseError; aSecondYet: Integer);
    class procedure SetInvalidUser(aError: ICustomXmlResponseError);
    class procedure SetInnerWebService(aError: ICustomXmlResponseError);
    class procedure SetIncorrectLoginForSession(aError: ICustomXmlResponseError);
    class procedure SetIncorrectClientVersion(aError: ICustomXmlResponseError);
    class procedure SetWebServiceError(aError: ICustomXmlResponseError; aErrorCode: Integer);
    class procedure SetWebServiceInnerError(aError: ICustomXmlResponseError; const aErrorText: string);
  end;

implementation

uses
  System.SysUtils,
  Logic.Options;

{ TErrorFactory }

class procedure TErrorFactory.SetExpiredSession(aError: ICustomXmlResponseError);
begin
  aError.Code := 3;
  aError.NodeValue := 'Сессия истекла или не найдена';
end;

class procedure TErrorFactory.SetIncorrectClientVersion(aError: ICustomXmlResponseError);
begin
  aError.Code := 9;
  aError.NodeValue := Format('Программа устарела. Необходимо обновить до версии %s', [TOptions.Options.Server.ClientVersion]);
end;

class procedure TErrorFactory.SetIncorrectLoginForSession(aError: ICustomXmlResponseError);
begin
  aError.Code := 8;
  aError.NodeValue := 'Некорректный логин для сессии';
end;

class procedure TErrorFactory.SetInnerWebService(aError: ICustomXmlResponseError);
begin
  aError.Code := 4;
  aError.NodeValue := 'Внутренняя ошибка веб-сервиса';
end;

class procedure TErrorFactory.SetInvalidUser(aError: ICustomXmlResponseError);
begin
  aError.Code := 7;
  aError.NodeValue := 'Пользователь не найден';
end;

class procedure TErrorFactory.SetServerError(aError: ICustomXmlResponseError);
begin
  aError.Code := 2;
  aError.NodeValue := 'Внутренняя ошибка сервера';
end;

class procedure TErrorFactory.SetServerError2(aError: ICustomXmlResponseError);
begin
  aError.Code := 5;
  aError.NodeValue := 'Внутренняя ошибка сервера';
end;

class procedure TErrorFactory.SetSuccess(aError: ICustomXmlResponseError);
begin
  aError.Code := 0;
  aError.NodeValue := '';
end;

class procedure TErrorFactory.SetUnknownMessage(aError: ICustomXmlResponseError);
begin
  aError.Code := 1;
  aError.NodeValue := 'Полученное сообщение не опознано';
end;

class procedure TErrorFactory.SetUseLoginOtherTSD(aError: ICustomXmlResponseError; aSecondYet: Integer);
begin
  aError.Code := 6;
  aError.NodeValue := Format('Авторизация не возможна. Время сессии не истекло на другом ТСД. Осталось %d секунд', [aSecondYet]);
end;

class procedure TErrorFactory.SetWebServiceError(aError: ICustomXmlResponseError; aErrorCode: Integer);
var
  ErrorMessage: string;
begin
  aError.Code := 10;
  case aErrorCode of
    12002:
      ErrorMessage := 'Истек срок ожидания ответа вебсервиса Navision';
    12007:
      ErrorMessage := 'Вебсервис Navision недоступен';
    else
      ErrorMessage := Format('Ошибка вебсервиса %d', [aErrorCode]);
  end;
  aError.NodeValue := ErrorMessage;
end;

class procedure TErrorFactory.SetWebServiceInnerError(aError: ICustomXmlResponseError; const aErrorText: string);
begin
  aError.Code := 4;
  aError.NodeValue := Format('Внутренняя ошибка веб-сервиса. %s', [aErrorText]);
end;

end.
