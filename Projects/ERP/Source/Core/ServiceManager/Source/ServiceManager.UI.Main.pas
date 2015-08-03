unit ServiceManager.UI.Main;

interface

uses
  Winapi.WinSock,
  System.Classes,
  System.Actions,
  System.Win.ScktComp,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.ActnList,
  Vcl.ImgList,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  cxClasses,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxContainer,
  cxEdit,
  cxProgressBar,
  cxPC,
  cxStyles,
  cxCustomData,
  cxFilter,
  cxData,
  cxDataStorage,
  cxNavigator,
  cxGridCustomView,
  cxGridCustomTableView,
  cxGridTableView,
  cxGridLevel,
  cxGrid,
  dxBar,
  dxStatusBar,
  dxBarBuiltInMenu,
  ERP.Package.Classes.TERPSocketStream,
  ServiceManager.Logic.TServiceManager;

type
  TProcTimerExecute = procedure of object;

  TfrmMain = class(TForm)
    dxBarManager: TdxBarManager;
    barMenu: TdxBar;
    barClient: TdxBar;
    btnServiceStart: TdxBarLargeButton;
    btnServiceStop: TdxBarLargeButton;
    btnRefresh: TdxBarLargeButton;
    btnSendMessage: TdxBarLargeButton;
    btnDisconnect: TdxBarLargeButton;
    btnConnect: TdxBarLargeButton;
    ActionList: TActionList;
    acStart: TAction;
    acStop: TAction;
    acConnect: TAction;
    acRefresh: TAction;
    acMessage: TAction;
    acDisconnect: TAction;
    cxImageList: TcxImageList;
    ClientSocket: TClientSocket;
    dxStatusBar: TdxStatusBar;
    dxStatusBarContainer0: TdxStatusBarContainerControl;
    pcProgress: TcxProgressBar;
    tmrProgress: TTimer;
    cxLookAndFeelController: TcxLookAndFeelController;
    pcMain: TcxPageControl;
    tsClientInfo: TcxTabSheet;
    dxBarDockControl1: TdxBarDockControl;
    cxGrid: TcxGrid;
    cxLevel: TcxGridLevel;
    tblClientInfo: TcxGridTableView;
    colSocketHandle: TcxGridColumn;
    colIP: TcxGridColumn;
    colHost: TcxGridColumn;
    acSave: TAction;
    colStartTime: TcxGridColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acStartExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acStartUpdate(Sender: TObject);
    procedure tmrProgressTimer(Sender: TObject);
    procedure acStopExecute(Sender: TObject);
    procedure acStopUpdate(Sender: TObject);
    procedure acConnectExecute(Sender: TObject);
    procedure acConnectUpdate(Sender: TObject);
    procedure acRefreshUpdate(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure acMessageUpdate(Sender: TObject);
    procedure acDisconnectUpdate(Sender: TObject);
    procedure acDisconnectExecute(Sender: TObject);
    procedure acMessageExecute(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
  private
    FGlobalBuffer: TERPSocketStream;
    FServiceManager: TServiceManager;
    FTimerExecute: TProcTimerExecute;
    procedure GridEditRecord(aIndex: Integer; aSocketHandle: TSocket; const aIP, aHost: string;
      const aStartTime: TDateTime);
    procedure InitTimer(const aText: string; aProcTimerExecute: TProcTimerExecute);
    procedure ProcessingCommand(const aBuffer; aSize: Integer);
    procedure ProcStart;
    procedure ProcStop;
    procedure SendClientDisconnect;
    procedure SendClientMessage(const aMessage: string);
    procedure SendRefreshClientInfo;
    procedure StartService;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  System.SysUtils,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.Classes.TCustomWinSocketHelper,
  ServiceManager.Logic.Options,
  ServiceManager.UI.Message;

const
  COL_SOCKETHANDLE = 0;
  COL_IP           = 1;
  COL_HOST         = 2;
  COL_STARTTIME    = 3;

function GetOptions: IXMLOptionsType;
begin
  Result := LoadOptions(ExtractFilePath(ParamStr(0)) + 'ERPManager.xml');
end;

procedure TfrmMain.acConnectExecute(Sender: TObject);
begin
  ClientSocket.Open();
end;

procedure TfrmMain.acConnectUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (FServiceManager.isHandle()) and (not FServiceManager.IsStopped()) and (not ClientSocket.Active);
end;

procedure TfrmMain.acDisconnectExecute(Sender: TObject);
begin
  SendClientDisconnect();
end;

procedure TfrmMain.acDisconnectUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := ClientSocket.Active and (tblClientInfo.Controller.SelectedRecordCount > 0);
end;

procedure TfrmMain.acMessageExecute(Sender: TObject);
var
  frmMessage: TfrmMessage;
begin
  frmMessage := TfrmMessage.Create(Self);
  try
    if frmMessage.ShowModal() = mrOk then
      SendClientMessage(frmMessage.mmMessage.Lines.Text);
  finally
    frmMessage.Free();
  end;
end;

procedure TfrmMain.acMessageUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := ClientSocket.Active and (tblClientInfo.Controller.SelectedRecordCount > 0);
end;

procedure TfrmMain.acRefreshExecute(Sender: TObject);
begin
  SendRefreshClientInfo();
end;

procedure TfrmMain.acRefreshUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := ClientSocket.Active;
end;

procedure TfrmMain.acStartExecute(Sender: TObject);
begin
  StartService();
end;

procedure TfrmMain.acStartUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (FServiceManager.isHandle()) and (not FServiceManager.IsRuning());
end;

procedure TfrmMain.acStopExecute(Sender: TObject);
begin
  FServiceManager.StopService();
  InitTimer('Остановка службы', ProcStop);
end;

procedure TfrmMain.acStopUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (FServiceManager.isHandle()) and (not FServiceManager.IsStopped());
end;

procedure TfrmMain.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  btnRefresh.Click();
end;

procedure TfrmMain.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  SizeReceiveBuffer: Integer;
  Buffer: TBytes;
begin
  SizeReceiveBuffer := Socket.ReceiveLength();
  if SizeReceiveBuffer > 0 then
  begin
    SetLength(Buffer, SizeReceiveBuffer);
    Socket.ReceiveBuf(Buffer[0], SizeReceiveBuffer);
    // Добавляем в буфер то, что пришло.
    FGlobalBuffer.Seek(0, soEnd);
    FGlobalBuffer.WriteBuffer(Buffer[0], Length(Buffer));
    // Вычитываем 1-ую команду (это размер сообщения, которое мы должны получить)
    FGlobalBuffer.Position := 0;
    SizeReceiveBuffer := FGlobalBuffer.ReadInteger();
    // Если в буфере лежит всё сообщение, то отправляем на выполнение
    while (SizeReceiveBuffer <= FGlobalBuffer.Size - FGlobalBuffer.Position) and (FGlobalBuffer.Size > 0) do
    begin
      // Удаляем из буфера размер сообщения
      FGlobalBuffer.Delete(0, FGlobalBuffer.Position);
      // Отправляем сообщение на обработку
      ProcessingCommand(FGlobalBuffer.Bytes[0], FGlobalBuffer.Size);
      FGlobalBuffer.Position := 0;
      // Удаляем обработанное сообщение
      FGlobalBuffer.Delete(0, SizeReceiveBuffer);
      // Вычитываем 1-ую команду (это размер сообщения, которое мы должны получить)
      if FGlobalBuffer.Size > 0 then
      begin
        FGlobalBuffer.Position := 0;
        SizeReceiveBuffer := FGlobalBuffer.ReadInteger();
      end;
    end;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ClientSocket.Host := GetOptions().Socket.Server;
  ClientSocket.Port := GetOptions().Socket.Port;
  FServiceManager := TServiceManager.Create(False);
  FServiceManager.MachineName := GetOptions().Socket.Server;
  FServiceManager.ServiceName := 'ERPServer';
  FGlobalBuffer := TERPSocketStream.Create();
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FGlobalBuffer.Free();
  FServiceManager.Free();
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  FServiceManager.ConnectManager();
end;

procedure TfrmMain.GridEditRecord(aIndex: Integer; aSocketHandle: TSocket; const aIP, aHost: string;
  const aStartTime: TDateTime);
begin
  tblClientInfo.DataController.Values[aIndex, COL_SOCKETHANDLE] := aSocketHandle;
  tblClientInfo.DataController.Values[aIndex, COL_IP] := aIP;
  tblClientInfo.DataController.Values[aIndex, COL_HOST] := aHost;
  tblClientInfo.DataController.Values[aIndex, COL_STARTTIME] := aStartTime;
end;

procedure TfrmMain.InitTimer(const aText: string; aProcTimerExecute: TProcTimerExecute);
begin
  pcProgress.Properties.Text := aText;
  pcProgress.Properties.Min := 1;
  pcProgress.Properties.Max := 100;
  pcProgress.Position := 1;
  FTimerExecute := aProcTimerExecute;
  tmrProgress.Enabled := True;
end;

procedure TfrmMain.ProcessingCommand(const aBuffer; aSize: Integer);
var
  Buffer: TERPSocketStream;
  Command: Integer;
  k: Integer;
  SocketHandle: TSocket;
  IP: string;
  Host: string;
  StartTime: TDateTime;
begin
  Buffer := TERPSocketStream.Create();
  try
    Buffer.WriteBuffer(aBuffer, aSize);
    Buffer.Position := 0;
    Command := Buffer.ReadInteger();
    case Command of
      SERVER_M_COMMAND_RESULTLISTCONNECTION:
        begin
          tblClientInfo.BeginUpdate();
          try
            tblClientInfo.DataController.RecordCount := Buffer.ReadInteger();
            for k := 0 to tblClientInfo.DataController.RecordCount - 1 do
            begin
              SocketHandle := Buffer.ReadSocket();
              IP := Buffer.ReadString();
              Host := Buffer.ReadString();
              StartTime := Buffer.ReadDataTime();
              GridEditRecord(k, SocketHandle, IP, Host, StartTime);
            end;
          finally
            tblClientInfo.EndUpdate();
          end;
        end;
      SERVER_M_COMMAND_CLIENTCONNECT:
        begin
          tblClientInfo.BeginUpdate();
          try
            tblClientInfo.DataController.RecordCount := tblClientInfo.DataController.RecordCount + 1;
            SocketHandle := Buffer.ReadSocket();
            IP := Buffer.ReadString();
            Host := Buffer.ReadString();
            StartTime := Buffer.ReadDataTime();
            GridEditRecord(tblClientInfo.DataController.RecordCount - 1, SocketHandle, IP, Host, StartTime);
          finally
            tblClientInfo.EndUpdate();
          end;
        end;
      SERVER_M_COMMAND_CLIENTDISCONNECT:
        begin
          tblClientInfo.BeginUpdate();
          try
            SocketHandle := Buffer.ReadInteger();
            for k := 0 to tblClientInfo.DataController.RecordCount - 1 do
              if tblClientInfo.DataController.Values[k, COL_SOCKETHANDLE] = SocketHandle then
              begin
                tblClientInfo.DataController.DeleteRecord(k);
                Break;
              end;
          finally
            tblClientInfo.EndUpdate();
          end;
        end;
    end;
  finally
    Buffer.Free();
  end;
end;

procedure TfrmMain.ProcStart;
begin
  case FServiceManager.ServiceStatus of
    ssStartPending:
      begin
        pcProgress.Position := pcProgress.Position + 1;
        if pcProgress.Position = 100 then
          pcProgress.Position := 1;
      end;
    ssRunning:
      begin
        tmrProgress.Enabled := False;
        pcProgress.Position := 100;
        pcProgress.Properties.Text := 'Служба запущена';
      end;
  end;
end;

procedure TfrmMain.ProcStop;
begin
  case FServiceManager.ServiceStatus of
    ssStopPending:
      begin
        pcProgress.Position := pcProgress.Position + 1;
        if pcProgress.Position = 100 then
          pcProgress.Position := 1;
      end;
    ssStopped:
      begin
        tmrProgress.Enabled := False;
        pcProgress.Position := 100;
        pcProgress.Properties.Text := 'Служба остановлена';
      end;
  end;
end;

procedure TfrmMain.SendClientDisconnect;
var
  Buffer: TERPSocketStream;
  k: Integer;
begin
  Buffer := TERPSocketStream.Create(nil);
  try
    Buffer.WriteInteger(MANAGER_COMMAND_DISCONNECT);
    Buffer.WriteInteger(tblClientInfo.Controller.SelectedRecordCount);
    for k := 0 to tblClientInfo.Controller.SelectedRecordCount - 1 do
      Buffer.WriteSocket(tblClientInfo.Controller.SelectedRecords[k].Values[COL_SOCKETHANDLE]);
    ClientSocket.Socket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
  finally
    Buffer.Free();
  end;
end;

procedure TfrmMain.SendClientMessage(const aMessage: string);
var
  Buffer: TERPSocketStream;
  k: Integer;
begin
  Buffer := TERPSocketStream.Create(nil);
  try
    Buffer.WriteInteger(MANAGER_COMMAND_MESSAGE);
    Buffer.WriteString(aMessage);
    Buffer.WriteInteger(tblClientInfo.Controller.SelectedRecordCount);
    for k := 0 to tblClientInfo.Controller.SelectedRecordCount - 1 do
      Buffer.WriteSocket(tblClientInfo.Controller.SelectedRecords[k].Values[COL_SOCKETHANDLE]);
    ClientSocket.Socket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
  finally
    Buffer.Free();
  end;
end;

procedure TfrmMain.SendRefreshClientInfo;
var
  Buffer: TERPSocketStream;
begin
  Buffer := TERPSocketStream.Create(nil);
  try
    Buffer.WriteInteger(MANAGER_COMMAND_GETLISTCONNECTION);
    ClientSocket.Socket.SendSafeBuffer(Buffer.Bytes[0], Buffer.Size);
  finally
    Buffer.Free();
  end;
end;

procedure TfrmMain.StartService;
begin
  FServiceManager.StartService();
  InitTimer('Запуск службы', ProcStart);
end;

procedure TfrmMain.tmrProgressTimer(Sender: TObject);
begin
  if Assigned(FTimerExecute) then
    FTimerExecute();
end;

end.
