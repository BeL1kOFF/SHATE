unit _LoadMess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TLoadingMess = class(TForm)
    Label1: TLabel;
    ExitBtn: TBitBtn;
    procedure ExitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoadingMess: TLoadingMess;

implementation

uses _Main, _Data;

{$R *.dfm}

procedure TLoadingMess.ExitBtnClick(Sender: TObject);
begin
  Data.AllOpen;
  Main.AppClose;
end;

procedure TLoadingMess.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
