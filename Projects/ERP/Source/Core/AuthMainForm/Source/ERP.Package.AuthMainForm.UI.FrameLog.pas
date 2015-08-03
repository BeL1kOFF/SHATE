unit ERP.Package.AuthMainForm.UI.FrameLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmLog = class(TFrame)
    Memo1: TMemo;
  private
    { Private declarations }
  public
    procedure AddLog(const aMessage: string);
  end;

implementation

{$R *.dfm}

{ TfrmLog }

procedure TfrmLog.AddLog(const aMessage: string);
begin
  memo1.Lines.Add(DateTimeToStr(Now()) + ': ' + aMessage);
end;

end.
