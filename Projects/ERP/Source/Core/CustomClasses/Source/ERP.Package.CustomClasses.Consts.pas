unit ERP.Package.CustomClasses.Consts;

interface

uses
  Winapi.Messages;

const
  WM_ERP                  = WM_USER + 500;
  //Оповещение окон приложения.
  ERPM_CHILD_CLOSE        = WM_ERP + 1; //Дочернее окно уничтожается
  ERPM_MAIN_RESIZE        = WM_ERP + 2; //Главное окно изменило позицию или размер
  ERPM_APP_GET_CLIENTRECT = WM_ERP + 3; //Интерфейс запросил размеры клиентской части окна
  ERPM_APP_MODULE_OPEN    = WM_ERP + 4; //Интерфейс программно попросил открыть модуль

  //Команды обмена Сервер-клиент
  //Команды отправляемые серверу
  CLIENT_COMMAND_AUTH            = 001;
  CLIENT_COMMAND_GETDBLIST       = 002;
  CLIENT_COMMAND_GETMODULES      = 003;
  CLIENT_COMMAND_GETMENU         = 004;
  CLIENT_COMMAND_CHANGEPASSWORD  = 005;

  //Команды отправляемые клиенту
  SERVER_COMMAND_DENIDED            = 001;
  SERVER_COMMAND_ACCEPT             = 002;
  SERVER_COMMAND_RESULTDBLIST       = 003;
  SERVER_COMMAND_RESULTMODULES      = 004;
  SERVER_COMMAND_RESULTMENU         = 005;
  SERVER_COMMAND_CHANGEPASSWORD     = 006;
  SERVER_COMMAND_DISCONNECT         = 007;
  SERVER_COMMAND_MESSAGE            = 008;

  //Команды обмена сервер-менеджер
  //Команды отправляемые серверу
  MANAGER_COMMAND_GETLISTCONNECTION = 001;
  MANAGER_COMMAND_DISCONNECT        = 002;
  MANAGER_COMMAND_MESSAGE           = 003;

  //Команды отправляемые менеджеру
  SERVER_M_COMMAND_RESULTLISTCONNECTION = 001;
  SERVER_M_COMMAND_CLIENTCONNECT        = 002;
  SERVER_M_COMMAND_CLIENTDISCONNECT     = 003;

  //Картинки
  IL_ADD               = 000;
  IL_EDIT              = 001;
  IL_DELETE            = 002;
  IL_REFRESH           = 003;
  IL_ACCESS            = 004;
  IL_AUTOREGISTER      = 005;
  IL_FIND              = 006;
  IL_REENGINEERING     = 007;
  IL_RECREATE_APP_ROLE = 008;

  // Картинки MDMCatalog

  IL_MDMC_STATUSRESET = 000;
  IL_MDMC_STATUSREADY = 001;
  IL_MDMC_STATUSDELETE = 002;
  IL_MDMC_MERGE = 003;
  IL_MDMC_ANALYSIS = 004;
  IL_MDMC_APPROVE = 005;
  IL_MDMC_DRAFT = 006;
  IL_MDMC_COPY = 007;
  IL_MDMC_RESTORE = 008;
  IL_MDMC_EXPORT = 009;
  IL_MDMC_IMPORT = 010;

  //GUID типов модулей
  TYPEMODULE_ADMIN: TGUID = '{C32E0D49-DC53-44ED-B72E-CBF2667B9BF1}';
  TYPEMODULE_MODULES: TGUID = '{1B42EDC7-844E-483E-8B43-39C1806026B8}';
  TYPEMODULE_CATALOGS: TGUID = '{F8FC55C0-9A96-498D-9EDC-6F064AD7138E}';
  TYPEMODULE_REPORTS: TGUID = '{9E401BAE-9426-43A4-8DF2-C700616F5A0E}';

  //Идентификаторы БД
  TYPE_DATABASE_ADMIN = 001;
  TYPE_DATABASE_MDM   = 002;
  TYPE_DATABASE_PI    = 003;

resourcestring
  RsPackageFormNotLibrary = 'Библиотека %s не загружена';
  RsPackageFormNotProcLibrary = 'Процедура %s в библиотеке %s не найдена';

implementation

end.
