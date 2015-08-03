{
  Модуль: FullScreenUnit

  Описание: Поддержка разворота клиентской части окна во весь экран.
            Источник: статья Пола Дилация в MSDN Magazine № 6(12) 2002 г.

  Особенности использования: Окно, клиентская часть которого должна быть
                             развернута во весь экран, должно обрабатывать
                             сообщение WM_GETMINMAXINFO и устанавливать
                             свой максимальный размер больше, чем размер
                             экрана.

  Авторы: Пол Дилация (С++, MFC), Игорь Шевченко (Delphi)

  Дата создания: 09.01.2003

  История изменений:
}
unit FullScreenUnit;

interface
uses
 Windows, Controls, ShellAPI;

type
 TFullScreenHandler = class
 private
   FRestoreRect : TRect;
   function GetInFullScreenMode : Boolean;
   function GetMaxSize : SIZE;
 public
   { Развернуть клиентскую область окна во весь экран }
   procedure Maximize (AWinControl : TWinControl);
   { Восстановить клиентскую область окна }
   procedure Restore (AWinControl : TWinControl);
   { Развернута ли клиентская область окна во весь экран }
   property InFullScreenMode : Boolean read GetInFullScreenMode;
   { Максимально возможный размер окна, такой, чтобы клиентская область
     уместилась во весь экран. }
   property MaxSize : SIZE read GetMaxSize;
 end;
procedure AutohideTaskbar(hide: boolean);
var
 FullScreenHandler : TFullScreenHandler;

implementation
uses
 Forms; { Для Screen }

function TFullScreenHandler.GetInFullScreenMode : Boolean;
begin
 Result := not IsRectEmpty(FRestoreRect);
end;

function TFullScreenHandler.GetMaxSize : SIZE;
var
 ARect : TRect;
begin
{
 При большом желании обращение к свойствам переменной Screen можно заменить
 на вызовы функции GetSystemMetrics(SM_CXSCREEN) и
 GetSystemMetrics(SM_CYSCREEN).
}
 SetRect(ARect, 0, 0, Screen.Width, Screen.Height);
 InflateRect(ARect, 10, 50{100500,100500}); //Любые числа, лишь бы превышали размер
                             //неклиентской области окон
 Result.cx := ARect.Right - ARect.Left;
 Result.cy := ARect.Bottom - ARect.Top;
end;

procedure TFullScreenHandler.Maximize (AWinControl : TWinControl);
var
 RcClient, RcNewWindow : TRect;
begin
 RcClient := AWinControl.ClientRect;
{ Перевод координат клиентской области окна в экранные }
 MapWindowPoints(AWinControl.Handle, HWND_DESKTOP, RcClient, 2);
{ Сохраним размеры окна для восстановления }
 GetWindowRect(AWinControl.Handle, FRestoreRect);
{
 При большом желании обращение к свойствам переменной Screen можно заменить
 на вызовы функции GetSystemMetrics(SM_CXSCREEN) и
 GetSystemMetrics(SM_CYSCREEN).
}
 SetRect(RcNewWindow, 0, 0, Screen.Width, Screen.Height);
 with RcNewWindow do begin
   Inc(Left, FRestoreRect.Left - RcClient.Left);
   Inc(Top, FRestoreRect.Top - RcClient.Top);
   Inc(Right, FRestoreRect.Right - RcClient.Right);
   Inc(Bottom, FRestoreRect.Bottom - RcClient.Bottom);
   SetWindowPos (AWinControl.Handle, 0, Left, Top, Right - Left, Bottom - Top,
                 SWP_NOZORDER);
 end;
end;

procedure TFullScreenHandler.Restore (AWinControl : TWinControl);
begin
 with FRestoreRect do
   SetWindowPos (AWinControl.Handle, 0, Left, Top, Right - Left, Bottom - Top,
                 SWP_NOZORDER);
 SetRectEmpty(FRestoreRect);
end;
procedure AutohideTaskbar(hide: boolean);
const
  ABM_SETSTATE = $0a;
var
  pData: TAppBarData;
begin
  ZeroMemory(@pData, SizeOf(TAppBarData));
  pData.cbSize:=SizeOf(TAppBarData);
  pData.hWnd:=FindWindow('Shell_TrayWnd', '');
  if hide then pData.lParam:=ABS_AUTOHIDE
   else pData.lParam:=ABS_ALWAYSONTOP;//0
  SHAppBarMessage(ABM_SETSTATE, pData);
end;
initialization
 FullScreenHandler := TFullScreenHandler.Create();
finalization
 FullScreenHandler.Free();
end.


