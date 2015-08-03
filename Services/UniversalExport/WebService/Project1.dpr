program Project1;

{$APPTYPE GUI}

uses
  Forms,
  SockApp,
  UnitEventsLog in 'WebExport\UnitEventsLog.pas',
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {WebModule2: TWebModule},
  WebUniversalExportImpl in 'WebUniversalExportImpl.pas',
  WebUniversalExportIntf in 'WebUniversalExportIntf.pas',
  Unit3WebManager in 'Unit3WebManager.pas',
  Unit5MD5 in 'Unit5MD5.pas',
  UnitConfig in 'UnitConfig.pas';

{$R *.res}
{$R ResLib.RES}
//{$R webevlmsg1251cat.RES}
//{$R webevlmsg1251.RES}

begin
try
    Application.Initialize;
    Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TWebModule2, WebModule2);
  finally
  EventsLog.AddEvent((*666*)CATEGORY_Init,MSG_ERR_WebModule,'это тест и никакая это не ошибка!')
end;
try
      Application.Run;
finally
end;
end.
