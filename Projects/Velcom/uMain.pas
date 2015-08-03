{
данные по роумингу могут иметь дату другого месяца! (09/12 попадает в 08/12)
}
unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxRibbonSkins, StdCtrls, dxBar, ActnList, DB,
  ADODB, AppEvnts, cxClasses, dxRibbon;

const
//  cAMDConnectionString = 'Provider=SQLNCLI11.1;Persist Security Info=False;Initial Catalog=VELCOM;Data Source=SPBYPRIW0057;';
//  cAMDConnectionString = 'Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=VELCOM;Data Source=SPBYPRIW0057;';
//  cAMDConnectionString = 'Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=VELCOM;Data Source=SVBYMINSSQ1;';
  cAMDConnectionString = 'Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=VELCOM;Data Source=svbyprissq8;';
  cAMDConnectionStringParam = 'Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=%s;Data Source=%s;';

  cWindowsAutorityParams = 'Integrated Security=SSPI;';
  cCustomAutorityParams = 'User ID=%s;Password=%s;';

  cMonthNames: array[1..12] of string = (
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь'
  );

type
  TUserRights = record
    ID: Integer;
    Name: string;
    CanLogin,
    CanUser,
    CanWrite,
    CanAdmin: Boolean;
  end;

  TMainForm = class(TForm)
    connVelcom: TADOConnection;
    ApplicationEvents1: TApplicationEvents;
    qrQuery: TADODataSet;
    ActionList: TActionList;
    dxBarManager: TdxBarManager;
    barReference: TdxBar;
    btnDepartment: TdxBarLargeButton;
    btnEmployee: TdxBarLargeButton;
    acDepartment: TAction;
    acEmployee: TAction;
    btnSheetTable: TdxBarLargeButton;
    acTimeSheet: TAction;
    rtReference: TdxRibbonTab;
    dxRibbon1: TdxRibbon;
    dxRibbon1Tab3: TdxRibbonTab;
    rtAdmin: TdxRibbonTab;
    dxRibbon1Tab2: TdxRibbonTab;
    barReports: TdxBar;
    btnNumberCall: TdxBarLargeButton;
    acReportNumber: TAction;
    btnEmployeeCall: TdxBarLargeButton;
    acReportEmployee: TAction;
    barModules: TdxBar;
    btnCost: TdxBarLargeButton;
    acCost: TAction;
    btnAllCall: TdxBarLargeButton;
    acReportAll: TAction;
    barAdmin: TdxBar;
    btnUserDepartment: TdxBarLargeButton;
    acUserDepartment: TAction;
    btnUsers: TdxBarLargeButton;
    acUser: TAction;
    btnLoadDetail: TdxBarLargeButton;
    acLoadDetail: TAction;
    lbInfo: TLabel;
    btnNumberHistory: TdxBarLargeButton;
    acRepNumbers: TAction;
    dxBarLargeButton2: TdxBarLargeButton;
    acCaller: TAction;
    btnImportExternal: TdxBarLargeButton;
    acImportExternal: TAction;
    btnDistCost: TdxBarLargeButton;
    acRepDistCost: TAction;
    dxBarLargeButton1: TdxBarLargeButton;
    acRepNumberCost: TAction;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure acDepartmentExecute(Sender: TObject);
    procedure acEmployeeExecute(Sender: TObject);
    procedure acTimeSheetExecute(Sender: TObject);
    procedure acReportNumberExecute(Sender: TObject);
    procedure acReportEmployeeExecute(Sender: TObject);
    procedure acCostExecute(Sender: TObject);
    procedure acReportAllExecute(Sender: TObject);
    procedure acUserDepartmentExecute(Sender: TObject);
    procedure acUserExecute(Sender: TObject);
    procedure acLoadDetailExecute(Sender: TObject);
    procedure acRepNumbersExecute(Sender: TObject);
    procedure acCallerExecute(Sender: TObject);
    procedure acImportExternalExecute(Sender: TObject);
    procedure acRepDistCostExecute(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure acRepNumberCostExecute(Sender: TObject);
  private
    fCurrentConnectionString: string;
    fCurrUser: TUserRights;
    FConnect: Boolean;
    function DoLogin(const aUser, aPassword: string; aUseWinAuthority: Boolean): Boolean;
    function LoadUser(out aUserRec: TUserRights; const aUserName: string = ''{use current}): Boolean; {found}
    procedure DoAfterConnect;
    procedure CheckFillCost;
  public
    property CurrentUser: TUserRights read fCurrUser;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uLoginForm, USysGlobal, uDataModule, Menus, Velcom.UI.DepartmentForm, Velcom.UI.EmployeeForm,
  Velcom.UI.TableSheet, Velcom.UI.ReportNumber, Velcom.UI.ReportEmployee, Velcom.UI.Costs, Velcom.UI.ReportAll,
  Velcom.UI.UserDepartment, Velcom.UI.Users, Velcom.UI.LoadDetail, Velcom.UI.RepNumbers, Velcom.UI.CallerForm,
  Velcom.UI.ImportExternal, Velcom.UI.RepDistCost, Velcom.UI.ReportNumberCost;

function TMainForm.LoadUser(out aUserRec: TUserRights; const aUserName: string): Boolean;
var
  aUser: string;
begin
  Result := False;
  ZeroMemory(@aUserRec, SizeOf(aUserRec));
  if aUserName = '' then
  begin
    qrQuery.CommandText := ' select SYSTEM_USER ';
    qrQuery.Open();
    aUser := qrQuery.Fields[0].AsString;
    qrQuery.Close();
  end
  else
    aUser := aUserName;

  qrQuery.CommandText := 'call_sel_userrights :UserName';
  qrQuery.Parameters.ParamValues['UserName'] := aUser;
  qrQuery.Open;
  if qrQuery.RecordCount > 0 then
  begin
    Result := True;
    aUserRec.ID := qrQuery.FieldByName('Id_User').AsInteger;
    aUserRec.Name := aUser;
    aUserRec.CanLogin := qrQuery.FieldByName('CanLogin').AsBoolean;
    aUserRec.CanUser := qrQuery.FieldByName('CanUser').AsBoolean;
    aUserRec.CanWrite := qrQuery.FieldByName('CanWrite').AsBoolean;
    aUserRec.CanAdmin := qrQuery.FieldByName('CanAdmin').AsBoolean;
  end;
  qrQuery.Close;
end;

procedure TMainForm.acCallerExecute(Sender: TObject);
var
  frmCaller: TfrmCaller;
begin
  frmCaller := TfrmCaller.Create(Self);
  frmCaller.Show();
end;

procedure TMainForm.acCostExecute(Sender: TObject);
var
  frmCost: TfrmCost;
begin
  frmCost := TfrmCost.Create(Self);
  frmCost.Show();
end;

procedure TMainForm.acDepartmentExecute(Sender: TObject);
var
  frmDepartment: TfrmDepartment;
begin
  frmDepartment := TfrmDepartment.Create(Self);
  frmDepartment.Show();
end;

procedure TMainForm.acEmployeeExecute(Sender: TObject);
var
  frmEmployeeForm: TfrmEmployeeForm;
begin
  frmEmployeeForm := TfrmEmployeeForm.Create(Self);
  frmEmployeeForm.Show();
end;

procedure TMainForm.acImportExternalExecute(Sender: TObject);
var
  frmImportExternal: TfrmImportExternal;
begin
  frmImportExternal := TfrmImportExternal.Create(Self);
  try
    frmImportExternal.ShowModal();
  finally
    frmImportExternal.Free();
  end;
end;

procedure TMainForm.acLoadDetailExecute(Sender: TObject);
var
  frmLoadDetail: TfrmLoadDetail;
begin
  frmLoadDetail := TfrmLoadDetail.Create(Self);
  try
    frmLoadDetail.ShowModal();
  finally
    frmLoadDetail.Free();
  end;
end;

procedure TMainForm.acReportAllExecute(Sender: TObject);
var
  frmReportAll: TfrmReportAll;
begin
  frmReportAll := TfrmReportAll.Create(Self);
  frmReportAll.Show();
end;

procedure TMainForm.acReportEmployeeExecute(Sender: TObject);
var
  frmReportEmployee: TfrmReportEmployee;
begin
  frmReportEmployee := TfrmReportEmployee.Create(Self);
  frmReportEmployee.Show();
end;

procedure TMainForm.acReportNumberExecute(Sender: TObject);
var
  frmReportNumber: TfrmReportNumber;
begin
  frmReportNumber := TfrmReportNumber.Create(Self);
  frmReportNumber.Show();
end;

procedure TMainForm.acTimeSheetExecute(Sender: TObject);
var
  frmTableSheet: TfrmTableSheet;
begin
  frmTableSheet := TfrmTableSheet.Create(Self);
  frmTableSheet.Show();
end;

procedure TMainForm.acRepDistCostExecute(Sender: TObject);
var
  frmDistCost: TfrmDistCost;
begin
  frmDistCost := TfrmDistCost.Create(Self);
  frmDistCost.Show();
end;

procedure TMainForm.acRepNumberCostExecute(Sender: TObject);
var
  frmReportNumberCost: TfrmReportNumberCost;
begin
  frmReportNumberCost := TfrmReportNumberCost.Create(Self);
  frmReportNumberCost.Show();
end;

procedure TMainForm.acRepNumbersExecute(Sender: TObject);
var
  frmRepNumbers: TfrmRepNumbers;
begin
  frmRepNumbers := TfrmRepNumbers.Create(Self);
  frmRepNumbers.Show();
end;

procedure TMainForm.acUserDepartmentExecute(Sender: TObject);
var
  frmUserDepartment: TfrmUserDepartment;
begin
  frmUserDepartment := TfrmUserDepartment.Create(Self);
  try
    frmUserDepartment.ShowModal();
  finally
    frmUserDepartment.Free();
  end;
end;

procedure TMainForm.acUserExecute(Sender: TObject);
var
  frmUsers: TfrmUsers;
begin
  frmUsers := TfrmUsers.Create(Self);
  try
    frmUsers.ShowModal();
  finally
    frmUsers.Free();
  end;
end;

procedure TMainForm.ApplicationEvents1Activate(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i] is TLoginForm then
      ShowWindow((Screen.Forms[i] as TLoginForm).Handle, SW_SHOW);
end;

procedure TMainForm.CheckFillCost;
begin
  if qrQuery.Active then
    qrQuery.Close;
  qrQuery.CommandText := 'call_sel_checkfillcost';
  qrQuery.Open;
  lbInfo.Caption := '';
  if qrQuery.FieldByName('IsVAT').AsBoolean then
    lbInfo.Caption := lbInfo.Caption + 'Внимание! Существуют статьи в которых не указан НДС! По умолчанию будет считаться 0!'#13#10;
  if qrQuery.FieldByName('IsSubscriberService').AsBoolean then
    lbInfo.Caption := lbInfo.Caption + 'Внимание! Существуют статьи в которых не указан признак "Абон. плата"! По умолчанию "Нет"!'#13#10;
  qrQuery.Close;
end;

procedure TMainForm.DoAfterConnect;
begin
  FConnect := True;
  rtAdmin.Visible := fCurrUser.CanAdmin;
  if not fCurrUser.CanUser then
  begin
    btnDepartment.Visible := ivNever;
    btnEmployee.Visible := ivNever;
    btnSheetTable.Visible := ivNever;
    btnCost.Visible := ivNever;    
  end;
  if not fCurrUser.CanWrite then
  begin
    btnLoadDetail.Visible := ivNever;
    btnImportExternal.Visible := ivNever;
  end;
end;

function TMainForm.DoLogin(const aUser, aPassword: string;
  aUseWinAuthority: Boolean): Boolean;
var
  Server: string;
  DataBase: string;
begin
  Result := False;

  if ParamCount = 2 then
  begin
    Server := ParamStr(1);
    DataBase := ParamStr(2);
    fCurrentConnectionString := Format(cAMDConnectionStringParam, [DataBase, Server]);
  end
  else
    fCurrentConnectionString := cAMDConnectionString;

  if aUseWinAuthority then
    fCurrentConnectionString := fCurrentConnectionString + cWindowsAutorityParams
  else
    fCurrentConnectionString := fCurrentConnectionString + Format(cCustomAutorityParams, [aUser, aPassword]);

  connVelcom.ConnectionString := fCurrentConnectionString;
  connVelcom.LoginPrompt := False;
  connVelcom.Connected := True;

  if not LoadUser(fCurrUser, '') or not fCurrUser.CanLogin then
  begin
    MsgBoxWarn('У Вас нет прав на использование программы', 'Авторизация');
    connVelcom.Connected := False;
    Exit;
  end;

  Result := True;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if FConnect then
    CheckFillCost();
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if not TLoginForm.Execute(DoLogin) then
  begin
    FConnect := False;
    Application.Terminate;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW);
    Exit;
  end;
  DoAfterConnect;
end;

procedure TMainForm.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
var
  Key: Word;
  Shift: TShiftState;
begin
  ShortCutToKey(ShortCutFromMessage(Msg), Key, Shift);
  if [ssCtrl] = Shift then
  begin
    case Key of
      VK_ADD:
        ShowMessage(Format('Сервер: %s; БД: %s', [connVelcom.Properties.Item['Data Source'].Value,
                                                  connVelcom.Properties.Item['Initial Catalog'].Value]));
    end;
  end;
end;

end.
