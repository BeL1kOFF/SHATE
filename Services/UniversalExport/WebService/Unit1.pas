unit Unit1;

interface

uses
  SysUtils, Classes, Forms, UnitEventsLog;

type
  TForm1 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses SockApp;

{$R *.dfm}
//{$R webevlmsg.RES}
initialization
try
    TWebAppSockObjectFactory.Create('WebApp')  
except on E: Exception do
 begin
  EventsLog.AddEvent(CATEGORY_Init,MSG_ERR_WebModule,E.Message);
  Raise;
 end;
end;

end.
