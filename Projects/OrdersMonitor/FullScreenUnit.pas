{
  ������: FullScreenUnit

  ��������: ��������� ��������� ���������� ����� ���� �� ���� �����.
            ��������: ������ ���� ������� � MSDN Magazine � 6(12) 2002 �.

  ����������� �������������: ����, ���������� ����� �������� ������ ����
                             ���������� �� ���� �����, ������ ������������
                             ��������� WM_GETMINMAXINFO � �������������
                             ���� ������������ ������ ������, ��� ������
                             ������.

  ������: ��� ������� (�++, MFC), ����� �������� (Delphi)

  ���� ��������: 09.01.2003

  ������� ���������:
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
   { ���������� ���������� ������� ���� �� ���� ����� }
   procedure Maximize (AWinControl : TWinControl);
   { ������������ ���������� ������� ���� }
   procedure Restore (AWinControl : TWinControl);
   { ���������� �� ���������� ������� ���� �� ���� ����� }
   property InFullScreenMode : Boolean read GetInFullScreenMode;
   { ����������� ��������� ������ ����, �����, ����� ���������� �������
     ���������� �� ���� �����. }
   property MaxSize : SIZE read GetMaxSize;
 end;
procedure AutohideTaskbar(hide: boolean);
var
 FullScreenHandler : TFullScreenHandler;

implementation
uses
 Forms; { ��� Screen }

function TFullScreenHandler.GetInFullScreenMode : Boolean;
begin
 Result := not IsRectEmpty(FRestoreRect);
end;

function TFullScreenHandler.GetMaxSize : SIZE;
var
 ARect : TRect;
begin
{
 ��� ������� ������� ��������� � ��������� ���������� Screen ����� ��������
 �� ������ ������� GetSystemMetrics(SM_CXSCREEN) �
 GetSystemMetrics(SM_CYSCREEN).
}
 SetRect(ARect, 0, 0, Screen.Width, Screen.Height);
 InflateRect(ARect, 10, 50{100500,100500}); //����� �����, ���� �� ��������� ������
                             //������������ ������� ����
 Result.cx := ARect.Right - ARect.Left;
 Result.cy := ARect.Bottom - ARect.Top;
end;

procedure TFullScreenHandler.Maximize (AWinControl : TWinControl);
var
 RcClient, RcNewWindow : TRect;
begin
 RcClient := AWinControl.ClientRect;
{ ������� ��������� ���������� ������� ���� � �������� }
 MapWindowPoints(AWinControl.Handle, HWND_DESKTOP, RcClient, 2);
{ �������� ������� ���� ��� �������������� }
 GetWindowRect(AWinControl.Handle, FRestoreRect);
{
 ��� ������� ������� ��������� � ��������� ���������� Screen ����� ��������
 �� ������ ������� GetSystemMetrics(SM_CXSCREEN) �
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


