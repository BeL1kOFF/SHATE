unit ERP.Package.AuthMainForm.UI.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxRibbonSkins,
  dxBar, cxClasses, dxRibbon, Vcl.ActnList, ERP.Package.AuthMainForm.UI.FrameLog, System.Win.ScktComp,
  ERP.Package.AuthMainForm.UI.FrameConnections, ERP.Package.ServerClasses.IServerManager, dxRibbonCustomizationForm,
  System.Actions, ERP.Package.ServerClasses.ServerTypes, ERP.Package.ServerClasses.IServerCustomManager;

type
  TfrmMain = class(TForm)
    dxBarManager: TdxBarManager;
    dxRibbonTab1: TdxRibbonTab;
    dxRibbon: TdxRibbon;
    dxBarManagerBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    ActionList: TActionList;
    acConnections: TAction;
    acLog: TAction;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acConnectionsExecute(Sender: TObject);
    procedure acLogExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FFrameLog: TfrmLog;
    FFrameConnections: TfrmConnections;
    FServerManager: IServerManager;
    procedure Init;
    procedure InitFrame;
    procedure ShowFrameConnections;
    procedure ShowFrameLog;
    procedure DoProcLoggerCustomManager(aServerCustomManager: IServerCustomManager;
      aEventTypeSocketThread: TEventTypeSocketThread; aServerSocketCustomThread: TServerClientThread);
  end;

var
  frmMain: TfrmMain;

function RegisterMainForm: TFormClass; stdcall;

exports RegisterMainForm;

implementation

{$R *.dfm}

uses
  ERP.Package.ServerClasses.TServerManager;

function RegisterMainForm: TFormClass;
begin
  Result := TfrmMain;
end;

procedure TfrmMain.acConnectionsExecute(Sender: TObject);
begin
  ShowFrameConnections();
end;

procedure TfrmMain.acLogExecute(Sender: TObject);
begin
  ShowFrameLog();
end;

procedure TfrmMain.DoProcLoggerCustomManager(aServerCustomManager: IServerCustomManager;
  aEventTypeSocketThread: TEventTypeSocketThread; aServerSocketCustomThread: TServerClientThread);
begin
  case aEventTypeSocketThread of
    etstConnect:
    begin
      FFrameConnections.AddConnect(aServerSocketCustomThread.ServerSocket.SocketHandle,
                                   aServerSocketCustomThread.ClientSocket.RemoteAddress,
                                   aServerSocketCustomThread.ClientSocket.RemoteHost);
      FFrameLog.AddLog('Подключение клиента: ' + aServerSocketCustomThread.ClientSocket.RemoteAddress);
    end;
    etstDisconnect:
    begin
      FFrameConnections.DeleteConnect(aServerSocketCustomThread.ServerSocket.SocketHandle);
      FFrameLog.AddLog('Отключение клиента: ' + aServerSocketCustomThread.ClientSocket.RemoteAddress);
    end;
    etstRead:
    begin
      FFrameLog.AddLog('Получена команда от ' + aServerSocketCustomThread.ClientSocket.RemoteAddress + ': ' + string(''));
    end;
    etstProcess:
    begin
      FFrameLog.AddLog('Обработана команда от ' + aServerSocketCustomThread.ClientSocket.RemoteAddress + ': ' + string(''));
    end;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Init();
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FServerManager := nil;
  FFrameLog.Free();
  FFrameConnections.Free();
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  ShowFrameConnections();
  try
    FServerManager.Open();
  except on E: Exception do
    FFrameLog.AddLog(E.Message);
  end;
end;

procedure TfrmMain.Init;
begin
  FServerManager := TServerManager.Create(DoProcLoggerCustomManager);
  InitFrame();
end;

procedure TfrmMain.InitFrame;
begin
  FFrameConnections := TfrmConnections.Create(Self);
  FFrameConnections.Parent := Self;
  FFrameConnections.Align := alClient;
  FFrameLog := TfrmLog.Create(Self);
  FFrameLog.Parent := Self;
  FFrameLog.Align := alClient;
end;

procedure TfrmMain.ShowFrameConnections;
begin
  FFrameConnections.Show();
  FFrameLog.Hide();
end;

procedure TfrmMain.ShowFrameLog;
begin
  FFrameLog.Show();
  FFrameConnections.Hide();
end;

end.
