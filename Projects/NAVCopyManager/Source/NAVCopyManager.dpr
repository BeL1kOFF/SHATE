program NAVCopyManager;

uses
  Winapi.Windows,
  NAVCopyManager.Logic.IClipboardManager in 'Core\Logic\Interfaces\NAVCopyManager.Logic.IClipboardManager.pas',
  NAVCopyManager.Logic.TClipboardManager in 'Core\Logic\Classes\NAVCopyManager.Logic.TClipboardManager.pas',
  NAVCopyManager.Logic.TLoggedObject in 'Core\Logic\Classes\NAVCopyManager.Logic.TLoggedObject.pas';

{$R *.res}

var
  ClipboardManager: IClipboardManager;
  Msg: TMsg;

begin
  ClipboardManager := TClipboardManager.Create();
  repeat
    if PeekMessage(Msg, ClipboardManager.Handle, 0, 0, PM_NOREMOVE) then
    begin
      if GetMessage(Msg, ClipboardManager.Handle, 0, 0) then
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
    end;
    WaitMessage();
  until False;
end.
