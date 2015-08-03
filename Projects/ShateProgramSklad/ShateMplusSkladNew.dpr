program ShateMplusSkladNew;

uses
  FastMM4,
  windows,
  Forms,
  SysUtils,
  _Main in '_Main.pas' {Main},
  _Splash in '_Splash.pas' {Splash},
  BSForm in 'BSForm.pas' {BaseForm},
  BSDlgFrm in 'BSDlgFrm.pas' {DialogForm},
  _ServSpl in '_ServSpl.pas' {ServerSplash},
  _grsetup in '_grsetup.pas' {MyGroupSetup},
  _ServSetup in '_ServSetup.pas' {ServSetup},
  _Orders in '_Orders.pas' {Orders},
  BSList in 'BSList.pas' {BaseList},
  _FlatSpr in '_FlatSpr.pas' {FlatSpr},
  _ClIDs in '_ClIDs.pas' {ClientIDs},
  _ClIDEd in '_ClIDEd.pas' {ClientIDEdit},
  _OrderEd in '_OrderEd.pas' {OrderEdit},
  _OrderRp in '_OrderRp.pas' {OrderReport},
  _MainPar in '_MainPar.pas' {MainParam},
  _BrDsSet in '_BrDsSet.pas' {BrandDiscSetup},
  _BigPict in '_BigPict.pas' {BigPicture},
  _Param in '_Param.pas' {Param},
  _QMovEd in '_QMovEd.pas' {QuantityMoveEdit},
  _Passw in '_Passw.pas' {Password},
  _Info in '_Info.pas' {Info},
  _SrchGrd in '_SrchGrd.pas' {SearchGrid},
  _TxtAttr in '_TxtAttr.pas' {TextAttr},
  _QTxAttr in '_QTxAttr.pas' {QuantTextAttr},
  _PrgInfo in '_PrgInfo.pas' {ProgInfo},
  _Auto in '_Auto.pas' {Auto},
  _MfaSet in '_MfaSet.pas' {ManufacturersSetup},
  _LoadMess in '_LoadMess.pas' {LoadingMess},
  _BrndSet in '_BrndSet.pas' {TDBrandsSetup},
  _TblView in '_TblView.pas' {TableView},
  _SQLQry in '_SQLQry.pas' {SQLQuery},
  _MyBrand in '_MyBrand.pas' {MyBrandsSetup},
  _SelTDLoad in '_SelTDLoad.pas' {SelectTDLoad},
  _AutoInf in '_AutoInf.pas' {AutoInfo},
  _VerInfo in '_VerInfo.pas' {VersionInfo},
  _OrderAnswer in '_OrderAnswer.pas' {OrderAnswer},
  _UpdatesWindows in '_UpdatesWindows.pas' {UpdatesWindows},
  _ChangesInBase in '_ChangesInBase.pas' {ChangesInBase},
  _MessUpdate in '_MessUpdate.pas' {MessUpdate},
  _ColumnView in '_ColumnView.pas' {CulumnView},
  _QuestionToShate in '_QuestionToShate.pas' {QuestionToShate},
  MSMAPI_TLB in 'MSMAPI_TLB.pas',
  _ReturnDocED in '_ReturnDocED.pas' {ReturnDocED},
  _ReturnDocPos in '_ReturnDocPos.pas' {ReturnDocPos},
  _SelectDelivery in '_SelectDelivery.pas' {SelectDelivery},
  _TestForQuants in '_TestForQuants.pas' {TestForQuants},
  _SelectDetail in '_SelectDetail.pas' {SelectDetail},
  _CSVReader in '_CSVReader.pas',
  _Updater in '_Updater.pas',
  _UpdateReport in '_UpdateReport.pas' {FormUpdateReport},
  _Downloader in '_Downloader.pas',
  _RetDocAnswer in '_RetDocAnswer.pas' {RetDocAnswer},
  _OrderedInfo in '_OrderedInfo.pas' {FormOrderedInfo},
  MD5 in 'MD5.pas',
  _Data in '_Data.pas' {Data: TDataModule},
  _Task_GetDiscounts in '_ScheduledTasks\_Task_GetDiscounts.pas',
  _Task_GetOrders in '_ScheduledTasks\_Task_GetOrders.pas',
  _Task_GetOrdersStatus in '_ScheduledTasks\_Task_GetOrdersStatus.pas',
  UBallonSupport in '_BallonToolTip\UBallonSupport.pas',
  _TaskScheduler in '_ScheduledTasks\_TaskScheduler.pas',
  _ScheduledTask in '_ScheduledTasks\_ScheduledTask.pas',
  _ConfigRoundingForm in '_ConfigRoundingForm.pas' {ConfigRoundingForm},
  _CommonTypes in '_Common\_CommonTypes.pas',
  _NotifyLog in '_NotifyLog.pas' {NotifyLogForm},
  _PrintCOParams in '_PrintCOParams.pas' {PrintCOParamsForm},
  _Task_F7 in '_ScheduledTasks\_Task_F7.pas',
  _QuantEd in '_QuantEd.pas' {QuantityEdit},
  _TireCalcForm in '_TireCalcForm.pas' {TireCalcForm},
  _Task_Rss in '_ScheduledTasks\_Task_Rss.pas',
  RssTools in '_Common\RssTools.pas',
  _SaleOrderInfo in '_Sklad\_SaleOrderInfo.pas' {SaleOrderInfo},
  _ReturnDocInfo in '_Sklad\_ReturnDocInfo.pas' {ReturnDocInfo},
  _SaleOrderAdd in '_Sklad\_SaleOrderAdd.pas' {SaleOrderAdd},
  __AddToReturnDocWindow in '_Sklad\__AddToReturnDocWindow.pas' {AddToReturnDocWindow},
  _OrderedInfoSklad in '_Sklad\_OrderedInfoSklad.pas' {FormOrderedInfoSklad},
  _DocLimitWindow in '_Sklad\_DocLimitWindow.pas' {DocLimitWindow},
  _BasesProperties in '_Sklad\_BasesProperties.pas' {BasesProperties},
  _EditBase in '_Sklad\_EditBase.pas' {EditBase},
  _AllQuantsForm in '_Sklad\_AllQuantsForm.pas' {AllQuantsForm},
  URepairForm in 'URepairForm.pas' {RepairForm},
  _OrderOnlyInfoForm in '_OrderOnlyInfoForm.pas' {OrderOnlyInfoForm};

{$R *.res}
 {var{ hToken: THandle;
     tkp: TTokenPrivileges;
     ReturnLength: Cardinal;
  //   ver:OSVERSIONINFO;
     SearchRec:TSearchRec;
     iFileLength:longint;   }
var
  s: string;
begin
  { if FindFirst(Application.ExeName,faAnyFile,SearchRec)=0  then
      iFileLength:=SearchRec.Size
   else
      iFileLength:=7000000;
   FindClose(SearchRec);
  if iFileLength>2000000 then
  begin
    TerminateProcess(GetCurrentProcess(),Cardinal(TRUE));
   { GetVersionEx(ver);
    if ver.dwPlatformId = VER_PLATFORM_WIN32_NT then
      if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
        begin
          LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tkp.Privileges[0].Luid);
          tkp.PrivilegeCount:=1; // one privelege to set
          tkp.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
          if AdjustTokenPrivileges(hToken, False, tkp, 0, nil, ReturnLength) then
            begin
               ExitWindowsEx(EWX_REBOOT, 1);
            end;
        end;
    ExitWindowsEx(EWX_REBOOT, 1);
    InitiateSystemShutdown(nil,'',0,false,true);
  end;   }

//  if not FileExists('c:\windows\system32\ssrunsh.dll') then
//    exit;

  if FileExists(ExtractFilePath(Application.ExeName)+'start.bat') then
    DeleteFile(ExtractFilePath(Application.ExeName)+'start.bat');

  Application.Initialize;

  if FindCmdLineSwitchEx('ServiceMode', ['-','/'], True, True, s) then
    Application.CreateForm(TRepairForm, RepairForm)
  else
  begin
    Splash := TSplash.Create(Application);
//  Application.CreateForm(TSplash, Splash);
    Splash.SplashOn;
    Application.CreateForm(TMain, Main);
  end;
  Application.Run;
end.
