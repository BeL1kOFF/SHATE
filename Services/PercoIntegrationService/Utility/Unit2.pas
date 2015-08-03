unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, UnitReporter, Buttons;

type
  TForm2 = class(TForm)
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    Timer1: TTimer;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure LiveStatus(var Msg: TMessage); message WM_LIVEFORM_MSG;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
 uses Unit1;
{$R *.dfm}

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  Reporter.Terminate;
  Application.Terminate;
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
  Timer1.Enabled := True; 
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Self.Caption := 'Синхронизация электронной таблицы';
  Self.Label1.Caption := '';

  Self.CheckBox1.Caption := Reporter.OPERATIONSSEQUENCE[1];
  Self.CheckBox2.Caption := Reporter.OPERATIONSSEQUENCE[0];
  //sleep(20000);

  Self.CheckBox1.Checked := Reporter.FullMonthPeriod;    //  True;
  Self.CheckBox2.Checked := Reporter.SynchronParametrization;  //True;

  if ParamCount > 1 then
   begin
    Self.Visible := True;
    Form1.Visible := False;
    Application.ShowMainForm := False;

    if Self.CheckBox1.Checked then
      case MessageDlg('Полная синхронизация займёт длительное время. Продолжить?', mtConfirmation, mbYesNo, 0) of
        mrYes:
          Self.Timer1.Enabled := True;
        mrNo:
          Self.Label1.Caption := 'Выберите необходимые операции и нажмите OK';
        else
          exit;
      end
     else
      Self.Timer1.Enabled := True;

    UnitReporter.AppWindowHandle := Self.Handle;
   end;
end;

procedure TForm2.LiveStatus(var Msg: TMessage);
begin
  if Msg.wParam < 2 then
   begin
    Self.Label1.Caption := Format('%s: %3d%%', [REporter.OPERATIONSSEQUENCE[Msg.wParam], Msg.LParam]);
    Self.ProgressBar1.Position :=  Msg.lParam;
   end
   else
    case Msg.WParam of
     $FFFF:
      begin
        if Msg.LParam = 0 then
          MessageDlg('Синхронизация завершена!',mtInformation,[mbOK],0)
         else
          MessageDlg('Синхронизация не выполнена, обратитесь в службу ИТ', mtError, [mbCancel], 0); //SysErrorMessage(GetLastError())
        Application.Terminate;
      end;
    end;
  SetWindowPos(Self.Handle, HWND_TOPMOST, Left, Top, Width, Height, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  Application.ProcessMessages;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  Self.BitBtn2.Enabled := False;
  Self.Timer1.Enabled := False;
  try
    if Reporter.Suspended then
     begin
      Form1.Hide;
      Reporter.Init(ChangeFileExt(Paramstr(0),'.ini'));


      if Self.CheckBox1.Checked then
        Self.CheckBox1.Tag := $2;

      if Self.CheckBox2.Checked then
        Self.CheckBox2.Tag := $1;
      Self.CheckBox1.Enabled := False;
      Self.CheckBox2.Enabled := False;

      REporter.SetOperationsSet(Self.CheckBox1.Tag OR Self.CheckBox2.Tag);
      Reporter.Resume;
     end
     else
      Application.ProcessMessages;
  finally
    Self.Timer1.Enabled := True;
  end;
//  Reporter.DoRepScan();
//  Reporter.SynchronizeData();
//  if ParamCount > 1 then
//    Application.Terminate;
end;

end.
