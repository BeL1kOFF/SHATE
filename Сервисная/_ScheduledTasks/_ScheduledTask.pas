unit _ScheduledTask;

interface

uses
  Classes, Messages;

const
  cTestTCPHost = '10.0.0.176';
  
type
  TTriggerType = (ttPeriodic, ttTimeLine{, ...});
  TIntervalMultiply = (imSecond, imMinute, imHour, imDay);

  TTimeInterval = record
    Interval: Integer;
    Multiply: TIntervalMultiply;
  end;


  TTaskClass = class of TCommonTask;
  TTaskThreadClass = class of TCommonTaskThread;

  TTaskState = (tsWait, tsRunning, tsTerminating, tsComplete);

  TTaskBeforeRunEvent = procedure(Sender: TObject; var aCanRun: Boolean) of object;
  TTaskLogProc = procedure(const aText: string; isDebug: Boolean = False; aWithoutDateTime: Boolean = False) of object;

  TTaskTrigger = class;
  TSchedule = class;
  TCommonTaskThread = class;

  TCommonTask = class
  private
    FAutoDelete: Boolean;
    FState: TTaskState;
    FEnabled: Boolean;
    function GetEnabled: Boolean;
    procedure SetEnabled(const Value: Boolean);
    procedure SetAutoDelete(const Value: Boolean);
    procedure SetExclusive(const Value: Boolean);
  private
    //fOwnerScheduler: TTaskScheduler;
    fHoldStop: Boolean;
    fAborted: Boolean;

    fWorkThread: TCommonTaskThread;
    fWorkThreadClass: TTaskThreadClass;
    fTrigger: TTaskTrigger;
    FExclusive: Boolean;
    fOnTaskStateChanged: TNotifyEvent;
    FHandle: Cardinal;
    FOnBeforeRun: TTaskBeforeRunEvent;
    FOnAfterEnd: TNotifyEvent;
    FLogProc: TTaskLogProc;

    procedure WorkThreadTerminate(Sender: TObject);
    procedure WorkThreadTerminateMSG(Sender: TObject);
    function GetSchedule: TSchedule;
    procedure SetSchedule(const Value: TSchedule);
    procedure SetOnBeforeRun(const Value: TTaskBeforeRunEvent);
    procedure SetOnAfterEnd(const Value: TNotifyEvent);
  protected
    procedure WndProc(var Message: TMessage); virtual;

    procedure Init; virtual; //init after create

    function DoStart: Boolean; virtual;
    function DoStop: Boolean; virtual;

    function GetWorkThread: TCommonTaskThread;
    function InitThread(aThread: TCommonTaskThread): Boolean; virtual;
    procedure DoWorkThreadTerminate(aThread: TCommonTaskThread); virtual;

    function IsCanStop: Boolean; virtual;
    procedure SetState(aState: TTaskState);
    procedure TaskStateChanged;

  public
    constructor Create; virtual;
    destructor Destroy; override;
    function GetTaskClass: TTaskClass;

    function Start: Boolean; //create thread and start
    function Stop(aHoldStop: Boolean = False): Boolean;  //stop thread
//    function HoldStop: Boolean;  //stop thread without events

    function IsNeedToStart: Boolean;

    //config
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property AutoDelete: Boolean read FAutoDelete write SetAutoDelete;
    property Exclusive: Boolean read FExclusive write SetExclusive;
    property Schedule: TSchedule read GetSchedule write SetSchedule;

    //states
    property State: TTaskState read FState;
    property Aborted: Boolean read fAborted;
{
    function GetState: TTaskState;
    function GetNextTimeOfRun: TDateTime;
    function GetNextRunAfter: Cardinal;
    function GetWaitTime: Cardinal;
    function GetWorkTime: Cardinal;
    function GetEnabled: Boolean;
}
    //events
    property LogProc: TTaskLogProc read FLogProc write FLogProc;

    property OnTaskStateChanged: TNotifyEvent read fOnTaskStateChanged write fOnTaskStateChanged;
    property OnBeforeRun: TTaskBeforeRunEvent read FOnBeforeRun write SetOnBeforeRun;
    property OnAfterEnd: TNotifyEvent read FOnAfterEnd write SetOnAfterEnd;

    class function GetTaskName: string; virtual; abstract;
    class function GetWorkThreadClass: TTaskThreadClass; virtual; abstract;
  end;

  TCommonTaskThread = class(TThread)
  private
    fAborted: Boolean;
    fOwnerTask: TCommonTask;
  protected
    function GetOwnerTask: TCommonTask;
    procedure Execute; override;
    procedure DoExecute; virtual; abstract;
    procedure OwnerIsDestroing; virtual;
  public
    constructor Create(aOwnerTask: TCommonTask); virtual;
  end;

  TSchedule = class
    Scheduled: Boolean;
    Repeatable: Boolean;

    StartDelay: TTimeInterval;
    RepeatEach: TTimeInterval;

    procedure Assign(aSource: TSchedule); virtual;

    function SaveToString: string;
    procedure LoadFromString(const aSource: string);
  end;

  TTaskTrigger = class
  private
    //aOwnerTask: TCommonTask;
    //TJclScheduledTask
    fSchedule: TSchedule;
    fEnabled: Boolean;

    fStartedTime: TDateTime;
    fStartedTics: Cardinal;

    fCompleteCount: Integer;
    fCompleteTime: TDateTime;
    fCompleteTics: Cardinal;

    procedure SetEnabled(const Value: Boolean);
    procedure SetSchedule(const Value: TSchedule);
    function GetWillBeRunned: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    property Schedule: TSchedule read fSchedule write SetSchedule;
    procedure ReStart;
    procedure Complete;
    function Check: Boolean;

    property Enabled: Boolean read fEnabled write SetEnabled;
    property WillBeRunned: Boolean read GetWillBeRunned;
  end;


{ Global }
function TimeIntervalToTics(const aInterval: TTimeInterval): Cardinal;

implementation

uses
  Windows, SysUtils, UPrefs;

const
  cMSG_TASK_THREAD_TERMINATED = WM_USER + 1234;

{ Global }

function CreateTask(aTaskClass: TTaskClass): TCommonTask;
begin
  Result := aTaskClass.Create;
  //other inits..
end;

function TimeIntervalToTics(const aInterval: TTimeInterval): Cardinal;
begin
  case aInterval.Multiply of
    imSecond: Result := aInterval.Interval * 1000;
    imMinute: Result := aInterval.Interval * 1000 * 60;
    imHour:   Result := aInterval.Interval * 1000 * 60 * 60;
    imDay:    Result := aInterval.Interval * 1000 * 60 * 60 * 24;
  else
    Result := 0;
  end;
end;

{ TCommonTask }
procedure TCommonTask.WndProc(var Message: TMessage);
begin
  with Message do
    if (Msg = cMSG_TASK_THREAD_TERMINATED) then
    begin
      WorkThreadTerminateMSG(TObject(Pointer(lParam)));
    end
    else
    if Msg = WM_QUERYENDSESSION then
      Result := 1 // Correct shutdown
    else
      Result := DefWindowProc(FHandle, Msg, wParam, lParam);
end;

constructor TCommonTask.Create;
begin
  fTrigger := TTaskTrigger.Create;
  fWorkThreadClass := GetWorkThreadClass;

  FHandle := Classes.AllocateHWnd(WndProc); //for thread messages and timer

  Init;
end;

destructor TCommonTask.Destroy;
var
  aHandle: Cardinal;
begin
  aHandle := 0;
  
  if Assigned(fWorkThread) then
    aHandle := fWorkThread.Handle;

  Stop(True);

  if Assigned(fWorkThread) then
  begin
    fWorkThread.OwnerIsDestroing;
    fWorkThread.OnTerminate := nil; //не допускаем вызова события, когда объект таски уже распущен
    fWorkThread := nil;
    TerminateThread(aHandle, 0);

    {
    fWorkThread.OnTerminate := nil; //не допускаем вызова события, когда объект таски уже распущен
    fWorkThread.FreeOnTerminate := True; //не ждем завершения потока, сам распустится
    fWorkThread.OwnerIsDestroing;
    }
  end;

  Classes.DeallocateHWnd(FHandle);
  fTrigger.Free;

  inherited;
end;

function TCommonTask.DoStart: Boolean;
var
  aCanRun: Boolean;
begin
  Result := False;
  Assert(fState <> tsRunning, 'DoStart: недопустимое состояние задачи - tsRunning');
  Assert(not Assigned(fWorkThread), 'Поток выполнения задачи "' + GetTaskName + '" не завершился');

  fHoldStop := False;
  fAborted := False;

  aCanRun := True;
  if Assigned(FOnBeforeRun) then
    FOnBeforeRun(Self, aCanRun);

  if aCanRun then
  begin
    fWorkThread := fWorkThreadClass.Create(Self);
    fWorkThread.FreeOnTerminate := False;
    fWorkThread.OnTerminate := WorkThreadTerminate;

    Result := InitThread(fWorkThread);
    if not Result then
    begin
      fWorkThread.Free;
      fWorkThread := nil;
      fTrigger.Complete;
      Exit;
    end;
    SetState(tsRunning);
    fWorkThread.Resume;
  end
  else
    fTrigger.Complete;
end;

function TCommonTask.DoStop: Boolean;
begin
  Result := True;
  Assert(Assigned(fWorkThread), 'TCommonTask.DoStop поток не создан');
  if Assigned(fWorkThread) then
    fWorkThread.Terminate;
end;

procedure TCommonTask.DoWorkThreadTerminate(aThread: TCommonTaskThread);
begin
  fAborted := aThread.fAborted;
//ancestor can get result from thread in override
end;

function TCommonTask.GetEnabled: Boolean;
begin
  Result := fEnabled and fTrigger.Enabled;
end;

function TCommonTask.GetSchedule: TSchedule;
begin
  Result := fTrigger.Schedule;
end;

procedure TCommonTask.SetAutoDelete(const Value: Boolean);
begin
  FAutoDelete := Value;
end;

procedure TCommonTask.SetEnabled(const Value: Boolean);
begin
  fEnabled := Value;
  fTrigger.Enabled := Value;
end;

procedure TCommonTask.SetExclusive(const Value: Boolean);
begin
  FExclusive := Value;
end;

procedure TCommonTask.SetOnAfterEnd(const Value: TNotifyEvent);
begin
  FOnAfterEnd := Value;
end;

procedure TCommonTask.SetOnBeforeRun(const Value: TTaskBeforeRunEvent);
begin
  FOnBeforeRun := Value;
end;

procedure TCommonTask.SetSchedule(const Value: TSchedule);
begin
  fTrigger.Schedule := Value;
end;

procedure TCommonTask.SetState(aState: TTaskState);
begin
  if fState <> aState then
  begin
    fState := aState;
    if fState = tsComplete then
      fTrigger.Complete;
    TaskStateChanged;
  end;
end;

function TCommonTask.GetTaskClass: TTaskClass;
begin
  Result := TTaskClass(Self.ClassType);
end;

function TCommonTask.GetWorkThread: TCommonTaskThread;
begin
  Result := fWorkThread;
end;

{function TCommonTask.HoldStop: Boolean;
begin
  Stop(True);
end;}

procedure TCommonTask.Init;
begin
  //do in ancestor
end;

function TCommonTask.InitThread(aThread: TCommonTaskThread): Boolean;
begin
  Result := True;
  //наследник инициализирует поток и проверяет можно ли продолжать
end;

function TCommonTask.IsCanStop: Boolean;
begin
  Result := True;
end;

function TCommonTask.IsNeedToStart: Boolean;
begin
  Result := (State <> tsRunning) and Enabled and fTrigger.Check;
end;

function TCommonTask.Start: Boolean;
begin
  Result := False;
  if (State = tsTerminating) or (State = tsRunning) then
    Exit;
  Result := DoStart;
end;

function TCommonTask.Stop(aHoldStop: Boolean): Boolean;
begin
  Result := True;
  if fState <> tsRunning then
    Exit;

  fHoldStop := aHoldStop;
  if IsCanStop then
  begin
    SetState(tsTerminating);
    Result := DoStop; {async stop}
  end
  else
    Result := False;
end;

procedure TCommonTask.TaskStateChanged;
begin
  if not fHoldStop then
    if Assigned(fOnTaskStateChanged) then
      fOnTaskStateChanged(Self);
end;

//TThread->OnTerminate
procedure TCommonTask.WorkThreadTerminate(Sender: TObject);
var
  aThread: TCommonTaskThread;
begin
  if Sender is TCommonTaskThread then
  begin
    aThread := Sender as TCommonTaskThread;

    DoWorkThreadTerminate(aThread);
    if not fHoldStop then
      if Assigned(fOnAfterEnd) then
        fOnAfterEnd(Self);

    if fWorkThread = aThread then
      if aThread.FreeOnTerminate then
      begin
        //вариант 1: не убиваем поток
        fWorkThread := nil;
        SetState(tsComplete);
        { TODO : 1 если задача еще будет запускаться - установить состояние в tsWait }
      end
      else
        //вариант 2: посылаем сообщение что поток завершился
        //call --> WorkThreadTerminateMSG
        PostMessage(FHandle, cMSG_TASK_THREAD_TERMINATED, 0, lParam(Pointer(Sender)));
  end;
end;

procedure TCommonTask.WorkThreadTerminateMSG(Sender: TObject);
var
  aThread: TCommonTaskThread;
begin
  if Sender is TCommonTaskThread then
  begin
    aThread := Sender as TCommonTaskThread;

    if fWorkThread = aThread then
    begin
      fWorkThread.WaitFor;
      fWorkThread.Free;
      fWorkThread := nil;

      SetState(tsComplete);
      { TODO : 2 если задаяа еще будет запускаться - установить состояние в tsWait }
    end;
  end;
end;

{ TTaskTrigger }

procedure TTaskTrigger.Complete;
begin
  Inc(fCompleteCount);
  fCompleteTics := GetTickCount;
  fCompleteTime := Now;
end;

constructor TTaskTrigger.Create;
begin
  fSchedule := TSchedule.Create;
  ReStart;
end;

destructor TTaskTrigger.Destroy;
begin
  fSchedule.Free;
  
  inherited;
end;

function TTaskTrigger.GetWillBeRunned: Boolean;
begin
  Result := fSchedule.Scheduled and fSchedule.Repeatable;
end;

function TTaskTrigger.Check: Boolean;
begin
  Result := False;
  if (not fSchedule.Scheduled) or (not fEnabled) then
    Exit;

  if fCompleteCount = 0 then
  begin
    if GetTickCount > fStartedTics + TimeIntervalToTics(fSchedule.StartDelay) then
      Result := True;
  end
  else
    if fSchedule.Repeatable and (GetTickCount > fCompleteTics + TimeIntervalToTics(fSchedule.RepeatEach)) then
      Result := True;

{ DONE : разобраться с повторяемыми триггерами}
end;

procedure TTaskTrigger.ReStart;
begin
  fStartedTics := GetTickCount;
  fStartedTime := Now;
end;

procedure TTaskTrigger.SetEnabled(const Value: Boolean);
begin
  if fEnabled <> Value then
  begin
    fEnabled := Value;
    if fEnabled then
      ReStart;
  end;
end;

procedure TTaskTrigger.SetSchedule(const Value: TSchedule);
begin
  fSchedule.Assign(Value);
  ReStart;
end;

{ TSchedule }

procedure TSchedule.Assign(aSource: TSchedule);
begin
  if not Assigned(aSource) then
    Exit;
    
  Scheduled  := aSource.Scheduled;
  StartDelay := aSource.StartDelay;
  Repeatable := aSource.Repeatable;
  RepeatEach := aSource.RepeatEach;
end;

procedure TSchedule.LoadFromString(const aSource: string);
var
  aPrefs: TPreferences;
begin
  aPrefs := TPreferences.Create;
  try
    aPrefs.Prefix := 'Schedule.';
    aPrefs.SetAsText(aSource);

    Scheduled := aPrefs['Scheduled'].AsBoolDef(Scheduled);
    Repeatable := aPrefs['Repeatable'].AsBoolDef(Repeatable);

    StartDelay.Interval := aPrefs['StartDelay.Interval'].AsIntDef(StartDelay.Interval);
    StartDelay.Multiply := TIntervalMultiply(aPrefs['StartDelay.Multiply'].AsIntDef(Ord(StartDelay.Multiply)));

    RepeatEach.Interval := aPrefs['RepeatEach.Interval'].AsIntDef(RepeatEach.Interval);
    RepeatEach.Multiply := TIntervalMultiply(aPrefs['RepeatEach.Multiply'].AsIntDef(Ord(RepeatEach.Multiply)));
  finally
    aPrefs.Free;
  end;
end;

function TSchedule.SaveToString: string;
var
  aPrefs: TPreferences;
begin
  aPrefs := TPreferences.Create;
  try
    aPrefs.Prefix := 'Schedule.';
    
    aPrefs['Scheduled'].AsBool := Scheduled;
    aPrefs['Repeatable'].AsBool := Repeatable;

    aPrefs['StartDelay.Interval'].AsInt := StartDelay.Interval;
    aPrefs['StartDelay.Multiply'].AsInt := Ord(StartDelay.Multiply);

    aPrefs['RepeatEach.Interval'].AsInt := RepeatEach.Interval;
    aPrefs['RepeatEach.Multiply'].AsInt := Ord(RepeatEach.Multiply);

    Result := aPrefs.GetAsText;
  finally
    aPrefs.Free;
  end;
end;

{ TCommonTaskThread }

constructor TCommonTaskThread.Create(aOwnerTask: TCommonTask);
begin
  inherited Create(True);
  fOwnerTask := aOwnerTask;
end;

procedure TCommonTaskThread.Execute;
begin
  inherited;
  try
    try
      fAborted := False;
      DoExecute;
      { TODO : записать результат в переменные }
    finally
      fAborted := Terminated; 
    end;
  except
    { TODO : записать ошибки в переменные }
    //..
  end;
end;

function TCommonTaskThread.GetOwnerTask: TCommonTask;
begin
  Result := fOwnerTask;
end;

procedure TCommonTaskThread.OwnerIsDestroing;
begin
//
end;

end.
