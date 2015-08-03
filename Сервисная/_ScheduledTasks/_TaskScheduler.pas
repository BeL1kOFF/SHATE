unit _TaskScheduler;
{
управл€емый пул потоков
требовани€:
 - стартовать/останавливать потоки
 - пауза/возобновление
 - перезапуск
 - получение текущего состо€ни€ (прогресс, описание прогресса)
 - синхронизаци€ разделени€ ресурсов


ћенеджер задач
 - создать задачу
 - зарегистрировать задачу в менеджере
 - менеджер следит за временем и запускает задачи по расписанию
 - запуск немедленно по требованию
 - проверка запущена ли задача

«адача
 - расписание хранитс€ в отдельном объекте - триггере
 - если триггер сработал - задача запускаетс€
 - создает поток при запуске
 - имеет тип задачи (проверка обновлени€, запрос скидок и тд.)
 - свойства в задаче, можно ли запускать вторую такого же типа

“риггер
 - хранит параметры расписани€
 - имеет состо€ние сработал/нет
}

interface

uses
  Classes, SysUtils, Windows, Messages,
  _ScheduledTask;

type
  TTaskScheduler = class
  private
    fTaskList: TList;
    FTimerHandle: Cardinal;
    FEnabled: Boolean;
    procedure SetEnabled(const Value: Boolean);
  protected
    procedure WndProc(var Message: TMessage); virtual;
    procedure DoTimerMessage(aTimerId: Cardinal);
    procedure CheckToRunTasks;
  public
    constructor Create;
    destructor Destroy; override;

    function TaskCount: Integer;
    function GetTask(Index: Integer): TCommonTask;
    function AddTask(aTask: TCommonTask): Integer; {task handle}
    function RemoveTask(aTask: TCommonTask; aCancelIfRunning: Boolean = True): Boolean;

    procedure FreeAllTasks;

    property Enabled: Boolean read FEnabled write SetEnabled;
  //notifications from tasks about theire states changed
  end;

implementation

const
  cRecalcTimerId = 1;
  cRecalcTimerInterval = 500;


{ TTaskScheduler }

procedure TTaskScheduler.CheckToRunTasks;
var
  i: Integer;
  aTask: TCommonTask;
begin
  for i := 0 to TaskCount - 1 do
  begin
    aTask := fTaskList[i];
    if aTask.IsNeedToStart then
      aTask.Start;
  end;
end;

constructor TTaskScheduler.Create;
begin
  fTaskList := TList.Create;
  FTimerHandle := Classes.AllocateHWnd(WndProc); //for timer messages
end;

destructor TTaskScheduler.Destroy;
begin
  { TODO : free all tasks? }
  fTaskList.Free;

  KillTimer(FTimerHandle, cRecalcTimerId);
  Classes.DeallocateHWnd(FTimerHandle);

  inherited;
end;

procedure TTaskScheduler.WndProc(var Message: TMessage);
begin
  with Message do
    if (Msg = WM_TIMER) then
    begin
      DoTimerMessage(Message.WParam);
    end
    else
    if Msg = WM_QUERYENDSESSION then
      Result := 1 // Correct shutdown
    else
      Result := DefWindowProc(FTimerHandle, Msg, wParam, lParam);
end;

procedure TTaskScheduler.DoTimerMessage(aTimerId: Cardinal);
begin
  case aTimerId of
    cRecalcTimerId:
    begin
      if not fEnabled then
        Exit;
      KillTimer(FTimerHandle, aTimerId);
      //process tasks
      CheckToRunTasks;
      
      SetTimer(FTimerHandle, aTimerId, cRecalcTimerInterval, nil);
    end;
  end;
end;

function TTaskScheduler.AddTask(aTask: TCommonTask): Integer;
begin
  if fTaskList.IndexOf(aTask) >= 0 then
    raise Exception.Create('The task has already been added in scheduler');
  Result := fTaskList.Add(aTask);
end;

function TTaskScheduler.RemoveTask(aTask: TCommonTask; aCancelIfRunning: Boolean): Boolean;
var
  aIndex: Integer;
begin
  Result := False;

  aIndex := fTaskList.IndexOf(aTask);
  if aIndex >= 0 then
  begin
    if (aTask.State = tsRunning) and aCancelIfRunning then
      Exit;
    fTaskList.Delete(aIndex);
  end
  else
    Exit;

  Result := True;
end;

procedure TTaskScheduler.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    if FEnabled then
      SetTimer(FTimerHandle, cRecalcTimerId, cRecalcTimerInterval, nil)
    else
      KillTimer(FTimerHandle, cRecalcTimerId);
  end;
end;

procedure TTaskScheduler.FreeAllTasks;
var
  i: Integer;
  aTask: TCommonTask;
begin
  for i := 0 to TaskCount - 1 do
  begin
    try
      aTask := fTaskList[i];
      aTask.Free;
    except
      //¬ случае если таска уже удалена
    end;
  end;
end;

function TTaskScheduler.GetTask(Index: Integer): TCommonTask;
begin
  Result := fTaskList[Index];
end;

function TTaskScheduler.TaskCount: Integer;
begin
  Result := fTaskList.Count;
end;

end.
