unit UI.MainTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Logic.TMain;

type
  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FMain: TMain;
  end;

var
  Form4: TForm4;
  GlobalHandle: THandle;

implementation

uses
  Logic.InitUnit;

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
begin
  Memo1.Lines.Clear();
  GlobalHandle := Handle;
  FMain := TMain.Create();
  TLog.LogMessage(nil, 'Служба запущена');
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  TLog.LogMessage(nil, 'Служба останавливается');
  FMain.Free();
  TLog.LogMessage(nil, 'Служба остановлена');
end;

end.
