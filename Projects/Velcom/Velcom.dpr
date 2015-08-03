program Velcom;

uses
  Forms,
  uMain in 'uMain.pas' {MainForm},
  uLoginForm in 'uLoginForm.pas' {LoginForm},
  Velcom.ISQLCursor in 'Velcom.ISQLCursor.pas',
  USysGlobal in 'USysGlobal.pas',
  adoDBUtils in 'adoDBUtils.pas',
  Velcom.MultiReportExcel in 'Velcom.MultiReportExcel.pas',
  Velcom.SendMail in 'Velcom.SendMail.pas',
  uDataModule in 'uDataModule.pas' {DM: TDataModule},
  Velcom.UI.DepartmentForm in 'Velcom.UI.DepartmentForm.pas' {frmDepartment},
  Velcom.UI.DepartmentDetailForm in 'Velcom.UI.DepartmentDetailForm.pas' {frmDepartmentDetail},
  Velcom.UI.DepartmentExternalCode in 'Velcom.UI.DepartmentExternalCode.pas' {frmDepartmentExternalCodeForm},
  Velcom.UI.EmployeeForm in 'Velcom.UI.EmployeeForm.pas' {frmEmployeeForm},
  Velcom.UI.EmployeeDetail in 'Velcom.UI.EmployeeDetail.pas' {frmEmployeeDetail},
  Velcom.UI.EmployeeExternalCode in 'Velcom.UI.EmployeeExternalCode.pas' {frmEmployeeExternalCode},
  Velcom.UI.TableSheet in 'Velcom.UI.TableSheet.pas' {frmTableSheet},
  Velcom.UI.ReportNumber in 'Velcom.UI.ReportNumber.pas' {frmReportNumber},
  Velcom.UI.ReportNumberDetail in 'Velcom.UI.ReportNumberDetail.pas' {frmReportNumberDetail},
  Velcom.UI.ReportEmployee in 'Velcom.UI.ReportEmployee.pas' {frmReportEmployee},
  Velcom.UI.ReportEmployeeDetail in 'Velcom.UI.ReportEmployeeDetail.pas' {frmReportEmployeeDetail},
  Velcom.UI.Costs in 'Velcom.UI.Costs.pas' {frmCost},
  Velcom.UI.ReportAll in 'Velcom.UI.ReportAll.pas' {frmReportAll},
  Velcom.UI.UserDepartment in 'Velcom.UI.UserDepartment.pas' {frmUserDepartment},
  Velcom.UI.Users in 'Velcom.UI.Users.pas' {frmUsers},
  Velcom.UI.LoadDetail in 'Velcom.UI.LoadDetail.pas' {frmLoadDetail},
  Velcom.UI.RepNumbers in 'Velcom.UI.RepNumbers.pas' {frmRepNumbers},
  Velcom.UI.CallerForm in 'Velcom.UI.CallerForm.pas' {frmCaller},
  Velcom.UI.CallerDetail in 'Velcom.UI.CallerDetail.pas' {frmCallerDetail},
  Velcom.UI.ImportExternal in 'Velcom.UI.ImportExternal.pas' {frmImportExternal},
  Velcom.UI.RepDistCost in 'Velcom.UI.RepDistCost.pas' {frmDistCost},
  Velcom.UI.ReportNumberCost in 'Velcom.UI.ReportNumberCost.pas' {frmReportNumberCost},
  Velcom.UI.ReportNumberCostDetail in 'Velcom.UI.ReportNumberCostDetail.pas' {frmReportNumberCostDetail};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
