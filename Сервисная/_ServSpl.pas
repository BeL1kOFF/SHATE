unit _ServSpl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BSForm, StdCtrls, Buttons, ExtCtrls, JvComponentBase, JvFormPlacement;

type
  TServerSplash = class(TBaseForm)
    StopBtn: TBitBtn;
    CloseBtn: TBitBtn;
    Timer: TTimer;
    InfoLabel: TLabel;
    JvFormStorage: TJvFormStorage;
    procedure CloseBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetInfo;
  end;

var
  ServerSplash: TServerSplash;

resourcestring
  BSSessionsCount = 'Работает пользователей: %d.';

implementation

uses _Data, _Main;

{$R *.dfm}

procedure TServerSplash.CloseBtnClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TServerSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
  ServerSplash := nil;
end;

procedure TServerSplash.FormShow(Sender: TObject);
begin
  inherited;
  SetInfo;
end;

procedure TServerSplash.SetInfo;
begin
  InfoLabel.Caption := Format(BSSessionsCount,
                              [Data.DBEngine.GetServerConnectedSessionCount]);
end;

procedure TServerSplash.StopBtnClick(Sender: TObject);
begin
  inherited;
  Data.StopServer;
end;

procedure TServerSplash.TimerTimer(Sender: TObject);
begin
  inherited;
  SetInfo;
end;

end.
