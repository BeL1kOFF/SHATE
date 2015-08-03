unit RoutinesPackage.Logic.IEventLogger;

interface

uses
  Winapi.Windows;

type
  IEventLogger = interface(IInterface)
    ['{DDE88847-959D-40B9-8E8F-3C312C31CF08}']
    procedure LogMessage(const aMessage: string; aEventType: DWORD = 1; aCategory: Integer = 0; aId: Integer = 0);
  end;

implementation

end.
