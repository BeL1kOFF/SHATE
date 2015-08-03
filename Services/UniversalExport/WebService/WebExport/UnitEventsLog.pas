unit UnitEventsLog;

interface

uses Windows, Registry, SysUtils;

type  TWinEvetsLog = Class
      public
        procedure EventsLogRegistration;
        function AddEvent(ctgID,UnitID: word; msg: string): boolean;
      published
        constructor Create;
        destructor Destroy;
      private
        Reg: TRegistry;
        EventSource: THandle;

        Eventtype: Word;

      End;

const
  CATEGORY_Init = 1;
  CATEGORY_Connection = 2;
  CATEGORY_SQL =3;
  CATEGORY_FILE = 4;

  MSG_ERR_WebModule = $100;
  MSG_ERR_IMPL = $200;
  MSG_ERR_Service = $300;

var EventsLog: TWinEvetsLog;
implementation

{ TWinEvetsLog }

function TWinEvetsLog.AddEvent(ctgID,UnitID: word; msg: string): boolean;
const EVLOGTYPE = EVENTLOG_ERROR_TYPE;
var collision: Cardinal;   st: string;
msgs: array[0..2] of PChar;  pmsg: PChar;

begin
//ctgID:=0;//UnitID:=0;
collision:=$C0000100;     
  //msgs[0]:= PChar(msg);
  pmsg:=PChar(msg);
  RESULT:=ReportEvent(self.EventSource,EVLOGTYPE,ctgID,($C0000000 OR UnitID),nil,1,0,@pmsg,nil);
  if NOT RESULT then
   begin
    collision := GetLastError;
    st:=IntToStr(collision);
   end;

end;

constructor TWinEvetsLog.Create;
begin
  self.EventsLogRegistration;
end;

destructor TWinEvetsLog.Destroy;
begin

inherited;
end;

procedure TWinEvetsLog.EventsLogRegistration;
var
 RegKey:String;
 AppPath:String;
 AppName:String;
 NumCategories:Integer;

begin
  AppName := 'Project1.exe';//'ISAPIWebExportConfig';
  AppPath := Paramstr(0);
  Reg:=TRegistry.Create;
  try
     Reg.Access := KEY_ALL_ACCESS;
     Reg.RootKey:=HKEY_LOCAL_MACHINE;   //\ HKEY_LOCAL_MACHINE
     RegKey:=  'SYSTEM\CurrentControlSet\Services\Eventlog\Application\'+AppName;
     //Format('SYSTEM\CurrentControlSet\Services\EventLog\Application%s',[AppName]);


     {AppPath:=IncludeTrailingBackslash(ExtractFilePath(Paramstr(0)));//Application.ExeName;
     AppName:='ISAPIWebExportsConfig';   }
     NumCategories:=3;

     Reg.OpenKey(RegKey,True);
     // Собственное имя
     Reg.WriteString('CategoryMessageFile',
                                              StringReplace(AppPath,AppName,'Resources.dll',[])
                                             {AppPath});//+AppName   +'.lll'
     // Собственное имя
     Reg.WriteString('EventMessageFile',
                                          StringReplace(AppPath,AppName,'Resources.dll',[])
                                        {AppPath});//+AppName+'.lll'
     // Максимальное количество категорий
     Reg.WriteInteger('CategoryCount',NumCategories);
     // Разрешаем все типы
     Reg.WriteInteger('TypesSupported', EVENTLOG_ERROR_TYPE);

    // EVENTLOG_SUCCESS or
    //                                   EVENTLOG_ERROR_TYPE or
    //                                   EVENTLOG_WARNING_TYPE or
    //                                   EVENTLOG_INFORMATION_TYPE);
     Reg.CloseKey;
  finally
   Reg.Free;
  end; //try..finally
   self.EventSource:=RegisterEventSource(nil,PChar(AppName));
end;//  end;

initialization
  EventsLog:= TWinEvetsLog.Create;
finalization
  EventsLog.Free;
end.
