unit ERP.Package.ERPClasses.ExceptionHack;

interface

implementation

uses
  System.SysUtils;

var
  OldRaiseExceptObject: Pointer;

type
  EExceptionHack = class
  public
    FMessage: string;
    FHelpContext: Integer;
    FInnerException: Exception;
    FStackInfo: Pointer;
    FAcquireInnerException: Boolean;
  end;

procedure RaiseExceptObjectHack(P: PExceptionRecord);
type
  TRaiseExceptObjectProc = procedure(P: PExceptionRecord);
begin
  if TObject(P^.ExceptObject) is Exception then
    EExceptionHack(P^.ExceptObject).FAcquireInnerException := True;

  if Assigned(OldRaiseExceptObject) then
    TRaiseExceptObjectProc(OldRaiseExceptObject)(P);
end;

initialization
  OldRaiseExceptObject := RaiseExceptObjProc;
  RaiseExceptObjProc := @RaiseExceptObjectHack;

end.
