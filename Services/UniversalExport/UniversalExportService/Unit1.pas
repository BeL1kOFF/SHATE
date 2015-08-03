unit Unit1 ;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs, DB,
  ADODB, ExtCtrls, SyncObjs, ActiveX, Registry
  ,UnitUniversalExport, UnitSMTPThread, UnitConfig, UnitLogging
  , IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase,
  IdSMTP, VCLUnZip, VCLZip, FMTBcd, SqlExpr, WideStrings, DBClient, Provider;

type
  TShateUniversalExportService = class(TService)
    ADODataSet1: TADODataSet;
    Timer1: TTimer;
    IdSMTP1: TIdSMTP;
    VCLZip1: TVCLZip;
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceBeforeUninstall(Sender: TService);
  private
    { Private declarations }
    DaemonThread: TExportDaemon;
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;
const INITINTERVAL =60*1000; //    60000*30
var
  ShateUniversalExportService: TShateUniversalExportService;
  PostAgent: TSMTPMessagesThrd;
implementation

{$R *.DFM}
{$R ResLib.res}
{$R ResImport.res}
{$R ResMailer.res}
//{$R ResEvents.res}

const
      IDCATEGORYSUCCESS = $0;
      IDCATEGORYERROR = $1;
      IDCATEGORYWARNING = $2;
      IDCATEGORYINFORMATION = $4;

      IDMSGNATURAL=$100;
      IDMSGERROR = $200;
      IDMSGERRCFG = $300;
      IDMSGEXCEPTION = $400;
      IDMSGERRCREATE = $500;
      IDMSGERRDESTROY = $600;
      IDMSGERRSTART = $700;
      IDMSGERRSTOP = $800;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ShateUniversalExportService.Controller(CtrlCode);
end;

function TShateUniversalExportService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

//procedure pr1;
//begin
//  Service1.ADODataSet1.LoadFromFile('');
//end;
procedure TShateUniversalExportService.ServiceAfterInstall(Sender: TService);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_ALL_ACCESS);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    // ������ ��������� ��� ��� ����
    Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\Eventlog\Application\' + Name, True);
    Reg.WriteString('EventMessageFile', ParamStr(0));
    Reg.WriteInteger('TypesSupported', $7);
    // ����������� ���� ��������
    //Reg.WriteString('\SYSTEM\CurrentControlSet\Services\' + Name, 'Description', '������ �������������� ��������.');
  finally
    FreeAndNil(Reg);
  end;
end;


procedure TShateUniversalExportService.ServiceBeforeUninstall(Sender: TService);
var
  Reg: TRegistry;
begin  exit;
  Reg := TRegistry.Create(KEY_ALL_ACCESS);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    // ������ ���� ��������� ���
    Reg.DeleteKey('\SYSTEM\CurrentControlSet\Services\Eventlog\Application\' + Name);
  finally
    FreeAndNil(Reg);
  end;
end;

procedure TShateUniversalExportService.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
  self.DaemonThread.LogTimeStamp('...������������� ������ ������');
  //self.DaemonThread.ReadConfigParameters;
  self.DaemonThread.reconfig := true;   //������ ���������������
  Timer1.Enabled := True;
  self.DaemonThread.Resume;
  PostAgent.Resume;
end;

procedure TShateUniversalExportService.ServiceCreate(Sender: TObject);
var errlog: text;  nickname: string;
begin
  //sleep(15*1000);  self.ReportStatus;
  writelnintofile(DatetimetoStr(Now())+#9+'�������� ������',FILEMAINLOG);
//  self.DaemonThread := TExportDaemon.Create;
  AssignFile(errlog, FILEERRLOG);
  try
    Rewrite(errlog);
  finally
    try
      CloseFile(errlog);
    finally
      ;
    end;
  end;
  //*CoInitializeEx(nil, COINIT_MULTITHREADED);
try
  //nickname:=;
  nickname:=StringReplace(copy(self.ClassName,2),'Service','',[]); //service classname is unique in a system
  UniversalLogger:=TLogger.Create(Concat(nickname,'_','Daemon'),0);//'UNIVERSAL',
  UniversalLogger.setMessages('�������','��������');
  MailLogger:=TLogger.Create(Concat(nickname,'_','MailAgent'),0);//'Mail'
  MailLogger.setMessages('�������','��������');

  Timer1.Enabled := False;
  Timer1.Interval := INITINTERVAL;
  SectINI:=TCriticalSection.Create;
  SectCTRL:=TCriticalSection.Create; //*
  SectLOG:=TCriticalSection.Create;
  SMTPQueue := TThreadList.Create;
  Zip:=self.VCLZip1;

   writelnintofile(DatetimetoStr(Now())+#9+'�������� ������ �����',FILEMAINLOG);
    PostAgent := TSMTPMessagesThrd.Create(SMTPQueue);
      writelnintofile(DatetimetoStr(Now())+#9+'����� ����� ������',FILEMAINLOG);
//    PostAgent.Logger := MailLogger; ���������� � ��������� ������ ������
except on E: Exception do
  self.LogMessage(E.Message,EVENTLOG_ERROR_TYPE,IDCATEGORYERROR, IDMSGERRCREATE); // writelnintofile(E.Message,FILEERRLOG);
end;

end;

procedure TShateUniversalExportService.ServiceDestroy(Sender: TObject);
begin
  //*CoUninitialize;
  try
      SectINI.Free;
      SectCTRL.Free; //*
      SectLOG.Free;

      SMTPQueue.Free;
      //FreeAndNil(self.DaemonThread);
      PostAgent.Free;

      MailLogger.Free;
      UniversalLogger.Free;
  except on E: Exception do
    self.LogMessage(E.Message,EVENTLOG_ERROR_TYPE,IDCATEGORYERROR,IDMSGERRDESTROY);
  end;
end;

procedure TShateUniversalExportService.ServicePause(Sender: TService;
  var Paused: Boolean);
begin
  Timer1.Enabled := False;
  self.DaemonThread.LogTimeStamp('������ ������������������...');
  self.DaemonThread.Suspend;
  PostAgent.Suspend;
end;

procedure TShateUniversalExportService.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
try
    Started:=false;
try
      self.DaemonThread := TExportDaemon.Create;
      //self.DaemonThread.Import:=TImportSubDaemon.Create;  //*
      if Assigned(self.DaemonThread) then
       begin
        self.DaemonThread.FreeOnTerminate :=False; //True
        self.DaemonThread.Logger := UniversalLogger;

        self.DaemonThread.Logger.setDB(self.DaemonThread.serverName,self.DaemonThread.DBName);
        debugmode:=Self.DaemonThread.Debug;
        if debugmode then
          self.DaemonThread.Logger.direction:= 0;
        Self.DaemonThread.Import.Logger:=self.DaemonThread.Logger;
       end;
except on E: Exception do
 begin
   self.LogMessage(E.Message,EVENTLOG_ERROR_TYPE,IDCATEGORYERROR,IDMSGERRCFG);
   //Raise;
 end;
end;
    //self.DaemonThread.Resume;
    //self.DaemonThread.WaitFor;
    self.ReportStatus;
    PostAgent.Init;
    PostAgent.Logger := MailLogger;
    PostAgent.Logger.setDB(PostAgent.SQLSRV,PostAgent.SQLDB);
    if debugmode then
      PostAgent.Logger.direction :=0;
    PostAgent.Resume;
    //������ ���������� ������ ������ ����� ������ ����� ������ �������
    Timer1.Interval := INITINTERVAL;//self.DaemonThread.interval;
    Timer1.Enabled := True;
    Started:=True;
except on E: Exception do
  self.LogMessage(E.Message,EVENTLOG_ERROR_TYPE,IDCATEGORYERROR,IDMSGERRSTART);
end;
end;

procedure TShateUniversalExportService.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin

try
    Timer1.Enabled := False;
  if Assigned(self.DaemonThread) then  //fix ������� ������ ����� ��������� �������������
   begin
    SectCTRL.Enter;
    try
      if self.DaemonThread.Live then
       begin
        if self.DaemonThread.hammer then //���� ����� �� �������� ������
         begin
           if not self.DaemonThread.Suspended then self.DaemonThread.Suspend;
           self.DaemonThread.hammer := false;
         end;
        self.DaemonThread.FreeOnTerminate := True;
        self.DaemonThread.Terminate;    //..����� ����� ����
        self.DaemonThread.Resume;
       end
       else  self.DaemonThread.Free;////FreeAndNil(self.DaemonThread);

       self.ReportStatus;
    finally
     SectCTRL.Leave;
    end;
   end;
   if Assigned(PostAgent) then
    begin
      PostAgent.inhibit := True;         //������ �����
      PostAgent.Terminate;               //..��������� ����� ����
      self.ReportStatus; //new
      PostAgent.WaitFor;                  //��� ����� ����������
    end;
except on E: Exception do
  self.LogMessage(E.Message,EVENTLOG_ERROR_TYPE,IDCATEGORYERROR,IDMSGERRSTOP);
end;
end;

procedure TShateUniversalExportService.Timer1Timer(Sender: TObject);
begin
  if DaemonThread=nil then //�������� � ������ ���� �������������
   begin
     self.LogMessage('������������� ������������ ������������� ������',EVENTLOG_WARNING_TYPE,IDCATEGORYWARNING,IDMSGNATURAL);
     Timer1.Enabled:=False;
     if Timer1.Interval=INITINTERVAL then //������ ������ --
      begin
        self.LogMessage('����� '+INtToStr(10*INITINTERVAL div 1000)+'� ����� ����������� ����������' ,EVENTLOG_INFORMATION_TYPE,IDCATEGORYINFORMATION,IDMSGNATURAL);
        Timer1.Interval:=10*INITINTERVAL; //=> ��� ����������
        Timer1.Enabled:=True;   // ������� �������� �������
        exit;                   // ���-�!
      end;
     if Assigned(PostAgent) then
      begin
        if NOT PostAgent.inhibit then
         begin
          self.LogMessage('����������� �������� ����� ����� ' +IntToStr(1+20*PostAgent.ql)+' �',EVENT_MODIFY_STATE,IDCATEGORYSUCCESS,IDMSGNATURAL);
          PostAgent.inhibit:=True;
          sleep((1+20*PostAgent.ql)*1000);
         end;
      end;
     writelnintofile(DatetimetoStr(Now())+#9+'���������� ������...',FILEMAINLOG);
     self.LogMessage('���������� ������',EVENTLOG_WARNING_TYPE,IDCATEGORYSUCCESS,IDMSGNATURAL);
     RestartService(self.ClassName);
     exit;
   end;
  if self.DaemonThread.Live then  // DaemonThread<>nil
   try try
    if not(self.DaemonThread.Suspended) then exit;
    self.LogMessage('���� ������ �������������� ��������',EVENTLOG_INFORMATION_TYPE,IDCATEGORYINFORMATION,IDMSGNATURAL);
    timer1.Interval := self.DaemonThread.interval;
    timer1.Enabled := False;
     //RestartService(self.Name);
    if not (PostAgent.isRunning OR PostAgent.inhibit) then   //if not(PostAgent.inhibit) then  ContextExsists(PostAgent.Handle)
     begin //���������� ���� ����� �� ���� �������� ���� �������� ����������
      self.LogMessage('������������ ������� ��������� ������' ,EVENTLOG_WARNING_TYPE,IDCATEGORYWARNING,IDMSGNATURAL);
      if TSMTPMessagesThrd.Restart(PostAgent) then
        self.LogMessage('�������� ���������� ������ �������� �����',EVENTLOG_SUCCESS,IDCATEGORYSUCCESS,IDMSGNATURAL)
       else
       begin
        self.LogMessage('���� ����������� ������ �������� �����' ,EVENTLOG_ERROR_TYPE,IDCATEGORYSUCCESS,IDMSGNATURAL);
        self.DaemonThread.Terminate;
        self.LogMessage('����������� ���������� ������!' ,EVENTLOG_WARNING_TYPE,IDCATEGORYINFORMATION,IDMSGNATURAL);
       end;
     end;
    self.DaemonThread.hammer := self.DaemonThread.Live;
    self.DaemonThread.Resume;
    //self.DaemonThread.WaitFor;
   except on Err: Exception do
    self.LogMessage(Err.Message, EVENTLOG_ERROR_TYPE, IDCATEGORYERROR, IDMSGEXCEPTION);//PrintLog(FILEERRLOG, Err.Message);
   end;
   finally
    timer1.Enabled := True;
   end
   else RestartService(self.ClassName);
end;

end.

