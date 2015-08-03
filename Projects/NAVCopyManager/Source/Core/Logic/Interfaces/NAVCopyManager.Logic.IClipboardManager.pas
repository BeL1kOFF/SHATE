unit NAVCopyManager.Logic.IClipboardManager;

interface

uses
  System.Classes,
  Winapi.Windows;

type
  IClipboardManager = interface
    ['{C401CE5A-F954-48BC-9335-589A754DEC88}']
    function GetHandle: HWND;
    property Handle: HWND read GetHandle;
    procedure ClipboardProcessing(const aList: TStrings = nil; const aSaveUncommonFormatData: Boolean = False);
  end;

implementation

end.
