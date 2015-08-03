{
отличия локальной версии (билдится с дефайном LOCAL):
 - подключен модуль _LocalVersionFuncts.pas в котором функционал по забору клиентов и скидок из MSSQL
 - доступно меню обновление->обновить базу клиентов
 - загрузка скидок по TCP перенаправлена в LoadDescriptionsTCP_Local
 - скидки подгружаются автоматически при смене текущего клиента
 - для запроса скидок интервал антиDDOS в 4 раза меньше
 - таска TTaskDiscounts никогда не запускается
}

{$optimization OFF}

unit _Main;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ActnList, JvFormPlacement, JvComponentBase, JvAppStorage,
  JvAppIniStorage, AdvOfficeStatusBar, AdvOfficeStatusBarStylers, AdvAppStyler,
  AdvToolBar, AdvToolBarStylers, AdvMenus, AdvMenuStylers, Menus, ExtCtrls,
  AdvSplitter, AdvPanel, ComCtrls, JvExComCtrls, JvComCtrls, GridsEh, DBGridEh,
  AdvOfficePager, AdvPageControl, AdvOfficePagerStylers, BSForm, BSDate,
  JvTrayIcon, JvMenus, StdCtrls, AdvEdit, advlued, Math, AdvToolBtn,
  AdvGlowButton, AdvEdBtn, DBAdvEd, DBCtrls, AdvCombo, AdvDBLookupComboBox,
  AdvDateTimePicker, Db, PictureContainer, dbisamtb,
  IdTCPClient, VCLUnZip, VCLZip, Psock, VclUtils, AdvPicture,
  AdvStyleIF, JvMail, ImagingComponents, HTMLabel, HTMLText, JvExStdCtrls,
  JvRichEdit, BSStrUt, BSMath, HyperStr, Clipbrd, dbisamcn, BSErrMess, AppEvnts,
  JvExExtCtrls, JvImage, ImagingClasses, ImagingTypes, Imaging, Buttons, IniFiles,
  AdvOfficeButtons, DBAdvOfficeButtons, IdBaseComponent, IdComponent,
  IdTCPConnection, IdException, MSHTML_TLB, IdThreadComponent,
  IdCustomTransparentProxy, IdConnectThroughHttpProxy, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, ShellAPI, WinSvc, BSDbiUt,
  JvDBDotNetControls, _UpdatesWindows,  _ChangesInBase, Wininet, _MessUpdate,
  DateUtils, AdvMemo, DBAdvMemo, ComObj, JvExControls, JvScrollText,
  _ColumnView, _QuestionToShate, AdvDBDateTimePicker, _ReturnDocED, _ReturnDocPos,
  _SelectDelivery, _TestForQuants, _SelectDetail, _Updater, _Downloader, md5,
  _ClIDEd, _NotePad, ToolPanels, AdvOfficeComboBox, _TaskScheduler, SyncObjs,
  JvGIF, jpeg, _Info, NMsmtp, IdHTTP, BaseGrid, Mask, DBCtrlsEh, JvCombobox,StrUtils,
  DBLookupEh, Placemnt,_Task_GetDirectory{bel}, AdvOfficeSelectors{bel}, _Task_GetRates{bel}, _Task_F7,
  xmldom, XMLIntf, msxmldom, XMLDoc;

const
  PROGRESS_POS_MESSAGE = WM_USER + 220;
  PROGRESS_START_UPDATE = WM_USER + 320;
  PROGRESS_UPDATE_RESTARTPROG = WM_USER + 206;
  MESSAGE_AUTOUPDATE = WM_USER + 207;
  MESSAGE_AFTER_COL_RESIZE = WM_USER + 1001;
  MESSAGE_AFTER_TOOLPANEL_RESIZE = WM_USER + 1002;

  START_DELAY_INTERVAL_RATES = 15; //sec
  START_DELAY_INTERVAL_ORDER_STATUS = 15; //sec
  START_DELAY_INTERVAL_RSS = 2; //sec
  START_DELAY_INTERVAL_ORDERS = 10; //sec
  START_DELAY_INTERVAL_DISCOUNT = 5; //sec
  START_DELAY_INTERVAL_DIRECTORY = 5; //sec    

  INTERVAL_UPDATE_RATES = 60; //min

  cCheckUpdateInterval = 900000; //интервал проверки обновления, мс (15 мин)
  cCallTCPDiscountsInterval = 10000; //минимальный интервал между запросами скидок, мс (анти DDOS)
  cObsoleteOrderTime: TDateTime = 7; //время(дней), через которое заказ считается устаревшим (не опрашивается его статус)
  cMaxPrimenCount = 50; //подгружать первых 50 позиций применяемости

  cMaxOrderDetCount = 20;

  cTestTCPHost = '10.0.0.176';

  cPictUrl = 'http://shate-mag.by/data/service/picts/%d/%d.jpg';
  cPictUrlNewTecDoc = 'http://shate-mag.by/data/service/newpicts/%d/%d.jpg';
  cRssUrl = 'http://shate-m.by/ru/news/rss.html?count=20';
  cRssRunningLineUrl = 'http://shate-m.by/ru/runningline/rss.html';
  cTeamViewerUrl = 'http://www.shate-m.by/data/service/tvr.exe';

  MIN_LENGTH_NAME = 7;
  MIN_LENGTH_PHONE = 12;

type
  TGroupData = record
    GroupId: Integer;
    SubgroupId: Integer;
    Union: Integer; //номер группировки, если он одинаковый значит товары могут находиться в одной корзине
  end;
type
  TFlagsUpdateByLight = record
    bNeedUpdateQuants: boolean;
    bNeedUpdateRates: boolean;
    bNeedUpdateProg: boolean;
    bNeedUpdateData: boolean;
  end;

const
  //ID групп, которые требуют нового заказа (нельзя заказывать вместе с остальным ассортиментом)
  cNewOrderGroups: array[1..5] of TGroupData =
  (
    (GroupId: 50; SubgroupId: -1; Union: 1), //шины и диски все
    (GroupId:  7; SubgroupId:  1; Union: 2), //Глушители/Глушители
    (GroupId:  7; SubgroupId: 67; Union: 2), //Глушители/Пламегасители
    
    //группы NAV
    (GroupId: 54; SubgroupId: 72; Union: 2), //Выхлопная система/Глушители
    (GroupId: 54; SubgroupId: 74; Union: 2)  //Выхлопная система/Пламегасители
  );


type
  TNotifyEventType = (netUnknown, netDiscounts, netOrders, netRetdocs, netWaitList, netRss, netDirectory);

  //проверяет наличие обновления (скачавает файл update.inf)
  TTestInternet = class(TThread)
  protected
    procedure Execute; override;
  end;

  TUserIDRecord = class
    iID:integer;
    sId:string;
    sName:string;
    sOrderType:string;
    iDelivery:integer;
    sEMail:string;
    sKey:string;
    bUpdateDisc:boolean;
    DiscountVersion: Integer;
    UseDiffMargin: Boolean;
    DiffMargin: string;
    DirectoryVersion: Integer;
    //New NAV
    DiscVersion: Integer;
    AddresVersion: Integer;
    AgrVersion: Integer;
    ContractByDefault: String;
    AddresByDefault: String;    
  end;

  TTextAttrRec = record
    Lo, Hi: integer;
    Background: TColor;
    Font: TFont;
  end;

  //Interceptor Class
  TAdvOfficePager = class(AdvOfficePager.TAdvOfficePager)
  public
    function TabRect(Page: TAdvOfficePage): TRect;
  end;


  TMain = class(TForm)
    MainDockPanel: TAdvDockPanel;
    StatusBar: TAdvOfficeStatusBar;
    ToolBarStyler: TAdvToolBarOfficeStyler;
    StatusBarStyler: TAdvOfficeStatusBarOfficeStyler;
    MainActionList: TActionList;
    SmallImageList: TImageList;
    ExitProgAction: TAction;
    GridsPanel: TAdvPanel;
    SplitterLeft: TAdvSplitter;
    PanelStyler: TAdvPanelStyler;
    MainGridPanel: TAdvPanel;
    AdvSplitter1: TAdvSplitter;
    PagerStyler: TAdvOfficePagerOfficeStyler;
    Pager: TAdvOfficePager;
    AnalogPage: TAdvOfficePage;
    DetailsPage: TAdvOfficePage;
    CatZakPage: TAdvOfficePage;
    AdvDockPanel1: TAdvDockPanel;
    AdvToolBar1: TAdvToolBar;
    TrayIcon: TJvTrayIcon;
    ServModeMenu: TAdvPopupMenu;
    N1: TMenuItem;
    ShowServSplashAction: TAction;
    N2: TMenuItem;
    N3: TMenuItem;
    StopServerAction: TAction;
    LoadCatAction: TAction;
    GroupsAction: TAction;
    BrandsAction: TAction;
    SearchToolBar: TAdvToolBar;
    ClearFiltAction: TAction;
    MyGroupsAction: TAction;
    SetupMyGroupsAction: TAction;
    LoadAnAction: TAction;
    AdvPanel1: TAdvPanel;
    DBAdvEdit1: TDBAdvEdit;
    DBAdvEdit2: TDBAdvEdit;
    ServSetupAction: TAction;
    SearchTimer: TTimer;
    DBAdvEdit3: TDBAdvEdit;
    AdvSplitter2: TAdvSplitter;
    OrderDateEd2: TAdvDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    OrderDateEd1: TAdvDateTimePicker;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    LoadQuantAction: TAction;
    OrdersAction: TAction;
    NewOrderAction: TAction;
    DelOrderAction: TAction;
    CopyOrderAction: TAction;
    AdvToolBarButton1: TAdvToolBarButton;
    AdvToolBarButton2: TAdvToolBarButton;
    AdvToolBarButton3: TAdvToolBarButton;
    PrintOrderAction: TAction;
    EmailOrderAction: TAction;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    AdvToolBarButton4: TAdvToolBarButton;
    AdvToolBarButton5: TAdvToolBarButton;
    ClientIDsAction: TAction;
    EditOrderAction: TAction;
    MainGridPopupMenu: TAdvPopupMenu;
    AddToOrderAction: TAction;
    AddToOrderItem: TMenuItem;
    OrderPopupMenu: TAdvPopupMenu;
    NewOrderItem: TMenuItem;
    DelOrderItem: TMenuItem;
    EditOrderItem: TMenuItem;
    PrintOrderItem: TMenuItem;
    EmailOrderItem: TMenuItem;
    AddAnToOrderAction: TAction;
    AnalogGridPopupMenu: TAdvPopupMenu;
    AddAnToOrderItem: TMenuItem;
    DeleteFromOrderAction: TAction;
    OrderDetPopupMenu: TAdvPopupMenu;
    DeleteFromOrderItem: TMenuItem;
    OrderQuantEditAction: TAction;
    OrderQuantityEditItem: TMenuItem;
    GoToAnalogAction: TAction;
    GoToAnalogItem: TMenuItem;
    LoadGroupAction: TAction;
    MainParamSplashTimer: TTimer;
    MainParamAction: TAction;
    ValToolBar: TAdvToolBar;
    CurrencyComboBox: TComboBox;
    AdvToolBarButton6: TAdvToolBarButton;
    BrandDiscAction: TAction;
    Image1: TImage;
    SearchEd: TAdvEdit;
    RecalcOrderAction: TAction;
    AdvToolBarButton7: TAdvToolBarButton;
    SaleImageList: TImageList;
    NewImageList: TImageList;
    Zipper: TVCLZip;
    UnZipper: TVCLUnZip;
    SaveOrderAction: TAction;
    AdvToolBarButton8: TAdvToolBarButton;
    SaveOrderDialog: TSaveDialog;
    LoadTDInfoTimer: TTimer;
    PicturePanel: TAdvPanel;
    DetailsPanel: TAdvPanel;
    AdvSplitter3: TAdvSplitter;
    ParamAction: TAction;
    Office2003BlueAction: TAction;
    Office2003ClassicAction: TAction;
    Office2003OliveAction: TAction;
    Office2003SilverAction: TAction;
    Office2007LunaAction: TAction;
    Office2007ObsidianAction: TAction;
    Office2007SilverAction: TAction;
    WhidbeyAction: TAction;
    WindowsXPAction: TAction;
    WebUpdateAction: TAction;
    DiskUpdateAction: TAction;
    Mailer: TJvMail;
    ExportAction: TAction;
    ImportAction: TAction;
    LoadOENumbersAction: TAction;
    StartInfoAction: TAction;
    Label3: TLabel;
    AdvSplitter4: TAdvSplitter;
    InfoToolBar: TAdvToolBar;
    AdvToolBarButton9: TAdvToolBarButton;
    OEInfo: TJvRichEdit;
    LoadOEMemoAction: TAction;
    LoadOrderAction: TAction;
    AdvToolBarButton10: TAdvToolBarButton;
    PrepareUpdateAction: TAction;
    InfoAction: TAction;
    AdvToolBarButton11: TAdvToolBarButton;
    AdvToolBarSeparator8: TAdvToolBarSeparator;
    LoadAnMemoAction: TAction;
    PrepareQuantsUpdateAction: TAction;
    WaitListPage: TAdvOfficePage;
    WaitListGrid: TDBGridEh;
    AddToWaitListAction: TAction;
    DeleteFromWaitListAction: TAction;
    WaitListQuantEditAction: TAction;
    WaitListPopupMenu: TAdvPopupMenu;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    AddAnToWaitListAction: TAction;
    N34: TMenuItem;
    WaitListOrderMoveAction: TAction;
    N37: TMenuItem;
    N40: TMenuItem;
    AdvDockPanel2: TAdvDockPanel;
    AdvToolBar2: TAdvToolBar;
    AllWaitListOrderMoveAction: TAction;
    N41: TMenuItem;
    N42: TMenuItem;
    AdvToolBarButton12: TAdvToolBarButton;
    AdvToolBarSeparator9: TAdvToolBarSeparator;
    Label4: TLabel;
    WaitListViewComboBox: TComboBox;
    LoadTecdocAction1: TAction;
    BrandInfoAction: TAction;
    AdvToolBarButton13: TAdvToolBarButton;
    SentImageList: TImageList;
    AdvToolBarSeparator10: TAdvToolBarSeparator;
    ProgInfoAction: TAction;
    EditPopupMenu: TAdvPopupMenu;
    PastePopupItem: TMenuItem;
    CopyPopupItem: TMenuItem;
    CutPopupItem: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    LoadTecdocAction2: TAction;
    OrderInfoAction: TAction;
    UpdateTecdocAction: TAction;
    CatalogPicture: TJvImage;
    AutoAction: TAction;
    LoadPrimenMemoAction: TAction;
    UnknownBrandsAction: TAction;
    MfaSetupAction: TAction;
    FiltToolBar: TAdvToolBar;
    Image2: TImage;
    FiltModeComboBox: TComboBox;
    FiltEd: TAdvDBLookupComboBox;
    ClearFiltToolBarBtn: TAdvToolBarButton;
    AdvToolBarSeparator5: TAdvToolBarSeparator;
    TestLoadLockAction: TAction;
    LoadPicturesAction: TAction;
    TypesUnloadAction: TAction;
    LoadTecdocBrandsAction: TAction;
    TDBrandSetupAction: TAction;
    WaitListFlashTimer: TTimer;
    LoadAddTDArtAction: TAction;
    LoadAddTDParamAction: TAction;
    LoadAddTDPrimenAction: TAction;
    SQLAction: TAction;
    VersionTimer: TTimer;
    Panel1: TPanel;
    ParamGrid: TDBGridEh;
    AdvSplitter5: TAdvSplitter;
    ParamTypGrid: TDBGridEh;
    LoadTecDocAction3: TAction;
    MyBrandsAction: TAction;
    AutoToolBar: TAdvToolBar;
    AutoToolBarButton: TAdvToolBarButton;
    SetupMyBrandsAction: TAction;
    ResetIniAction: TAction;
    LoadPicturesAction2: TAction;
    ClearSearchAction: TAction;
    AdvToolBarButton14: TAdvToolBarButton;
    NewToolBar: TAdvToolBar;
    TCPClient: TIdTCPClient;
    AutoHistPopupMenu: TAdvPopupMenu;
    Item1: TMenuItem;
    UsaImageList: TImageList;
    N9: TMenuItem;
    AdvToolBarSeparator4: TAdvToolBarSeparator;
    AdvToolBarButton15: TAdvToolBarButton;
    LoadOrderActionTCP: TAction;
    AdvToolBarSeparator11: TAdvToolBarSeparator;
    OrderAnswer: TImageList;
    QueryLoadOrderISAM: TDBISAMQuery;
    UnlockOrderAction: TAction;
    AdvToolBarButton16: TAdvToolBarButton;
    CreateFilePrice: TAction;
    SaveFilePriceDialog: TSaveDialog;
    AboutBrand: TBitBtn;
    TCPTNTTNAction: TAction;
    AdvToolBarButton17: TAdvToolBarButton;
    PanelDetails: TAdvPanel;
    AdvSplitter6: TAdvSplitter;
    AdvToolBarButton18: TAdvToolBarButton;
    FindInAnalog: TAction;
    LoadCatalogLotus: TAction;
    OpenDialogCSV: TOpenDialog;
    LoadLotusAnalog: TAction;
    LoadLotusOE: TAction;
    TestLotusCatalog: TAction;
    Memo: TMemo;
    LoadDescription: TAction;
    AnalysisLoadedData: TAction;
    CarOptionsData: TAction;
    TimerUpdate: TTimer;
    TestOrderForQuants: TAction;
    AdvToolBarButton19: TAdvToolBarButton;
    SendAscQuant: TAction;
    TimerAskQuants: TTimer;
    MoveToListFromOrder: TAction;
    N73: TMenuItem;
    SaveOENumber: TAction;
    SaveAnalog: TAction;
    LoadIDS: TAction;
    TreeMenu: TAdvPopupMenu;
    N76: TMenuItem;
    IgnoreSpecialSymbolsCheckBox: TAdvOfficeCheckBox;
    RunLinePanel: TAdvPanel;
    JvScrollText: TJvScrollText;
    FindFilter: TAction;
    AdvToolBarButton20: TAdvToolBarButton;
    CodeIgnoreSpecialSymbolsCheckBox: TAdvOfficeCheckBox;
    AdvToolBar4: TAdvToolBar;
    AdvToolBarButton21: TAdvToolBarButton;
    AdvPanel2: TAdvPanel;
    AdvPanel3: TAdvPanel;
    AdvPanel4: TAdvPanel;
    N77: TMenuItem;
    OpenAction: TAction;
    AdvToolBarSeparator6: TAdvToolBarSeparator;
    AdvToolBarSeparator7: TAdvToolBarSeparator;
    AdvToolBarButton23: TAdvToolBarButton;
    AssortmentExpansionPage: TAdvOfficePage;
    AssortmentExpansionDockPanel: TAdvDockPanel;
    AssortmentExpansionToolBar: TAdvToolBar;
    AssortmentExpansionToolBarButton: TAdvToolBarButton;
    AssortmentExpansionGridEh: TDBGridEh;
    AddAssortmentExpansion: TAction;
    N79: TMenuItem;
    AssortmentExpansionPopupMenu: TAdvPopupMenu;
    MoveToOrderFromAssortmentExpansion: TAction;
    N80: TMenuItem;
    AllMoveToOrderFromAssortmentExpansion: TAction;
    AssortmentExpansionTimer: TTimer;
    SaveAssortmentExpansion: TAction;
    AdvToolBarButton22: TAdvToolBarButton;
    WithQuants: TAdvOfficeCheckBox;
    ViewColumns: TAction;
    QuestionToShate: TAction;
    SearchModeComboBox: TComboBox;
    ReturnDocPage: TAdvOfficePage;
    ReturnDocPanel: TAdvDockPanel;
    ReturnDocToolBar: TAdvToolBar;
    AdvToolBarButton24: TAdvToolBarButton;
    NewReturnDocAction: TAction;
    EditReturnDocAction: TAction;
    AdvToolBarButton25: TAdvToolBarButton;
    DelReturnDocAction: TAction;
    AdvToolBarButton26: TAdvToolBarButton;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    Label5: TLabel;
    DateStartReturnDoc: TAdvDateTimePicker;
    Label6: TLabel;
    AdvToolBarSeparator12: TAdvToolBarSeparator;
    AdvToolBarButton27: TAdvToolBarButton;
    SaveReturnDocAction: TAction;
    AdvToolBarButton28: TAdvToolBarButton;
    SendReturnDocAction: TAction;
    AddReturnPosAction: TAction;
    N83: TMenuItem;
    ReturnDocPopupMenu: TAdvPopupMenu;
    N84: TMenuItem;
    DeleteFromReturnDoc: TAction;
    N85: TMenuItem;
    EditReturnDocPos: TAction;
    DelFromAssortiment: TAction;
    N86: TMenuItem;
    SaveWaitList: TAction;
    AdvToolBarButton29: TAdvToolBarButton;
    LoadWaitList: TAction;
    AdvToolBarButton30: TAdvToolBarButton;
    ClearWaitList: TAction;
    AdvToolBarButton31: TAdvToolBarButton;
    MoveToWaitListPosition: TAction;
    N87: TMenuItem;
    MoveToReturnDocPos: TAction;
    N88: TMenuItem;
    MoveToAssortimentExpansionPos: TAction;
    N89: TMenuItem;
    AllMoveToWaitList: TAction;
    N90: TMenuItem;
    GoIntoGroup: TAction;
    N91: TMenuItem;
    ReturnInfo: TAction;
    ExportAutoDetails: TAction;
    ExportParametr: TAction;
    ExportDetailFoMan: TAction;
    ExportDetailManParametr: TAction;
    ExportPicture: TAction;
    OpenInstruction: TAction;
    ContactAction: TAction;
    TitleImageList: TImageList;
    Image5: TImage;
    Panel2: TPanel;
    PrimGrid: TDBGridEh;
    lbApply: TLabel;
    Label8: TLabel;
    AllMoveToTrash: TAction;
    N103: TMenuItem;
    AdvToolBarButton32: TAdvToolBarButton;
    acReturnDocTCP: TAction;
    acFindGoodsInOrders: TAction;
    N105: TMenuItem;
    RetDocAnswer: TImageList;
    pnAnalog: TPanel;
    AnalogGrid: TDBGridEh;
    Bevel3: TBevel;
    cbFilterAnalogs: TCheckBox;
    UserID_ToolBar: TAdvToolBar;
    UserInfo_button: TAdvToolBarButton;
    UserInfo_Action: TAction;
    LoadDiscountTCP: TAction;
    OpenDisc: TAction;
    Table: TDBISAMTable;
    DataSource: TDataSource;
    ToolPanelTabRight: TAdvToolPanelTab;
    ToolPanelNotepad: TAdvToolPanel;
    Label9: TLabel;
    AdvToolBarButton34: TAdvToolBarButton;
    TitleImageList2: TImageList;
    pnDetailsLoad: TPanel;
    acShowOrdersInPofitPrices: TAction;
    N111: TMenuItem;
    N112: TMenuItem;
    OrderPopupActions: TAdvPopupMenu;
    N113: TMenuItem;
    N114: TMenuItem;
    N115: TMenuItem;
    N116: TMenuItem;
    N117: TMenuItem;
    CP2: TMenuItem;
    N118: TMenuItem;
    N119: TMenuItem;
    AdvToolBarMenuButton1: TAdvToolBarMenuButton;
    N120: TMenuItem;
    N121: TMenuItem;
    pmTree: TAdvPopupMenu;
    miGroupsAction: TMenuItem;
    miMyGroupsAction: TMenuItem;
    miBrandsAction: TMenuItem;
    miMyBrandsAction: TMenuItem;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    GroupsItem: TMenuItem;
    MyGroupsItem: TMenuItem;
    BrandsItem: TMenuItem;
    MyBrandsItem: TMenuItem;
    N50: TMenuItem;
    AutoItem: TMenuItem;
    N11: TMenuItem;
    ExitProgItem: TMenuItem;
    LoadIDS1: TMenuItem;
    OrderMenu: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N19: TMenuItem;
    N71: TMenuItem;
    N15: TMenuItem;
    CP1: TMenuItem;
    N70: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N72: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N20: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N35: TMenuItem;
    N36: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    N43: TMenuItem;
    N44: TMenuItem;
    ViewMenu: TMenuItem;
    miPanels: TMenuItem;
    miPanelVisible: TMenuItem;
    N110: TMenuItem;
    HideTree: TMenuItem;
    HideBrandGroup: TMenuItem;
    HideName: TMenuItem;
    HideOE: TMenuItem;
    N81: TMenuItem;
    N107: TMenuItem;
    StyleMenu: TMenuItem;
    Office2003Blue1: TMenuItem;
    Office2003Classic1: TMenuItem;
    Office2003Olive1: TMenuItem;
    Office2003Silver1: TMenuItem;
    Office2007Luna1: TMenuItem;
    Office2007Obsidian1: TMenuItem;
    N4: TMenuItem;
    Whidbey1: TMenuItem;
    WindowsXP1: TMenuItem;
    ServMenu: TMenuItem;
    MainParamItem: TMenuItem;
    ClientIDsItem: TMenuItem;
    N106: TMenuItem;
    N108: TMenuItem;
    SetupMyGroupsItem: TMenuItem;
    SetupMyBrandsItem: TMenuItem;
    ServFuncMenu: TMenuItem;
    N60: TMenuItem;
    LoadCatItem: TMenuItem;
    LoadAnItem: TMenuItem;
    LoadOEItem: TMenuItem;
    LoadQuantItem: TMenuItem;
    N100: TMenuItem;
    LoadPicturesItem: TMenuItem;
    N8: TMenuItem;
    N101: TMenuItem;
    N57: TMenuItem;
    N67: TMenuItem;
    N102: TMenuItem;
    ecdoc3: TMenuItem;
    N58: TMenuItem;
    N68: TMenuItem;
    N69: TMenuItem;
    N94: TMenuItem;
    N10: TMenuItem;
    N74: TMenuItem;
    N75: TMenuItem;
    N93: TMenuItem;
    ExportParametr1: TMenuItem;
    N95: TMenuItem;
    N96: TMenuItem;
    N97: TMenuItem;
    miExportPrice: TMenuItem;
    ecDoc4: TMenuItem;
    ecdoc1: TMenuItem;
    ecdoc2: TMenuItem;
    N56: TMenuItem;
    LoadTecdoc1Item: TMenuItem;
    LoadTecdoc2Item: TMenuItem;
    LoadTecDoc3Item: TMenuItem;
    N54: TMenuItem;
    N28: TMenuItem;
    N53: TMenuItem;
    UknownBrandsItem: TMenuItem;
    N52: TMenuItem;
    N27: TMenuItem;
    ExportItem: TMenuItem;
    ImportItem: TMenuItem;
    N48: TMenuItem;
    N25: TMenuItem;
    N29: TMenuItem;
    N61: TMenuItem;
    N62: TMenuItem;
    N63: TMenuItem;
    N64: TMenuItem;
    N65: TMenuItem;
    N66: TMenuItem;
    N30: TMenuItem;
    ServSetupItem: TMenuItem;
    N59: TMenuItem;
    SQL1: TMenuItem;
    N109: TMenuItem;
    N55: TMenuItem;
    UpdateMenu: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N99: TMenuItem;
    N104: TMenuItem;
    N82: TMenuItem;
    HelpMenu: TMenuItem;
    N26: TMenuItem;
    N78: TMenuItem;
    N5: TMenuItem;
    N51: TMenuItem;
    N45: TMenuItem;
    N49: TMenuItem;
    N92: TMenuItem;
    N98: TMenuItem;
    N46: TMenuItem;
    N47: TMenuItem;
    Label10: TLabel;
    ToolPanelTabLeft: TAdvToolPanelTab;
    ToolPanelTree: TAdvToolPanel;
    TreePanel: TAdvPanel;
    pnTreeMode: TPanel;
    ToolBarStylerCustom: TAdvToolBarOfficeStyler;
    SplitterRight: TAdvSplitter;
    N122: TMenuItem;
    PictureContainer1: TPictureContainer;
    Panel3: TPanel;
    DockPanelTreeMode: TAdvDockPanel;
    ToolBarTreeMode: TAdvToolBar;
    tbTree: TAdvToolBarButton;
    lbBallonPlace: TLabel;
    RotateTimer: TTimer;
    btNotify: TSpeedButton;
    btNotifyOrders: TSpeedButton;
    btNotifyRetdocs: TSpeedButton;
    OrderTitlesImageList: TImageList;
    acApplyOrderAnswer: TAction;
    AdvToolBarButton35: TAdvToolBarButton;
    N123: TMenuItem;
    N124: TMenuItem;
    acApplyRetdocAnswer: TAction;
    AdvToolBarButton36: TAdvToolBarButton;
    btLampOff: TSpeedButton;
    btLampOn: TSpeedButton;
    DeliveredImageList: TImageList;
    Panel4: TPanel;
    OrderDetGrid: TDBGridEh;
    pnDelivery: TPanel;
    Image6: TImage;
    acKKDeleteAll: TAction;
    acKKSave: TAction;
    acKKLoad: TAction;
    acKKPrintToExcel: TAction;
    acKKMoveToPos: TAction;
    miTreeAddToKK: TMenuItem;
    KKPage: TAdvOfficePage;
    KKGridEh: TDBGridEh;
    AdvDockPanel3: TAdvDockPanel;
    AdvToolBar3: TAdvToolBar;
    AdvToolBarButton37: TAdvToolBarButton;
    AdvToolBarButton38: TAdvToolBarButton;
    AdvToolBarButton39: TAdvToolBarButton;
    AdvToolBarButton40: TAdvToolBarButton;
    AdvToolBarSeparator13: TAdvToolBarSeparator;
    AdvToolBarSeparator14: TAdvToolBarSeparator;
    Bevel4: TBevel;
    Image7: TImage;
    WithLatestQuants: TAdvOfficeCheckBox;
    miTeamViewer: TMenuItem;
    lbOrderNum: TLabel;
    lbDeliveryNum: TLabel;
    acRunTireCalculator: TAction;
    TireToolBar: TAdvToolBar;
    TireToolBarButton: TAdvToolBarButton;
    acAddAnToKK: TAction;
    N125: TMenuItem;
    acAddToKK: TAction;
    N126: TMenuItem;
    ImgRssNew: TImage;
    ImgRssShate: TImage;
    MemoRssFullTemplate: TMemo;
    DateEndReturnDoc: TAdvDateTimePicker;
    acUpdateAllClients: TAction;
    acUpdateAllClients1: TMenuItem;
    acUpdateAllDiscounts: TAction;
    Label11: TLabel;
    pnPrimen: TPanel;
    lbAllPrimen: TLabel;
    Bevel5: TBevel;
    OilToolBar: TAdvToolBar;
    OilToolBarButton: TAdvToolBarButton;
    acRunOilCatalog: TAction;
    OrderWarnTimer: TTimer;
    pnOrderFlame: TPanel;
    lbOrderFlame: TLabel;
    acShowUpdateChanges: TAction;
    N127: TMenuItem;
    pmOEFilters: TPopupMenu;
    miOESetFilterOE: TMenuItem;
    miOESetFilterAll: TMenuItem;
    miOECopy: TMenuItem;
    N129: TMenuItem;
    pmBrandCat: TAdvPopupMenu;
    miBrandCatalog: TMenuItem;
    lbDownloadPicture: TLabel;
    IdHTTPPicts: TIdHTTP;
    KitPage: TAdvOfficePage;
    KitGridEh: TDBGridEh;
    acKitMoveToPos: TAction;
    WebUpdateExtAction: TAction;
    N128: TMenuItem;
    KitPopupMenu: TAdvPopupMenu;
    acKitMoveToPos1: TMenuItem;
    acKitAddToOrder: TAction;
    acKitAddToOrder1: TMenuItem;
    Panel5: TPanel;
    OrderGrid: TDBGridEh;
    lbOrderSum: TLabel;
    PopularImageList: TImageList;
    nPricePro: TMenuItem;
    N130: TMenuItem;
    Tree: TJvTreeView;
    AutoPanel: TAdvPanel;
    MfaModTypLabel: TLabel;
    PconLabel: TLabel;
    HpLabel: TLabel;
    FuelLabel: TLabel;
    CylLabel: TLabel;
    TreeImageList: TImageList;
    N131: TMenuItem;
    Button3: TButton;
    Button2: TButton;
    MainGrid: TDBGridEh;
    CliComboBox: TDBLookupComboboxEh;
    CliChangeTimer: TTimer;
    ErrMenu: TMenuItem;
    memDiscounts: TDBISAMTable;
    memAddres: TDBISAMTable;
    memAgr: TDBISAMTable;
    GetDirectory: TAdvToolBarButton;
    memAgrContract_Id: TStringField;
    memAgrContractDescr: TStringField;
    memAgrGroup: TStringField;
    memAgrCurrency: TStringField;
    memAgrMethod_Id: TStringField;
    memAgrMethodDescr: TStringField;
    memAgrPayment_id: TStringField;
    memAgrPaymentDescr: TStringField;
    memAgrPriceList_id: TStringField;
    memAgrDiscountCliGroup: TStringField;
    memAgrDiscountCliGroupDescr: TStringField;
    memAgrLegalPerson: TStringField;
    memAgrPriceListDescr: TStringField;
    memDiscountsGroup_Id: TIntegerField;
    memDiscountsSubgroup_Id: TIntegerField;
    memDiscountsBrand_Id: TIntegerField;
    memDiscountsGroupDiscountCli: TStringField;
    memDiscountsDiscount: TFloatField;
    memDiscountsCli_Id: TIntegerField;
    memAddresAddres_Id: TStringField;
    memAddresDescr: TStringField;
    memAddresAddres: TStringField;
    memAgrAddres_Id: TStringField;
    N132: TMenuItem;
    memAgrID: TAutoIncField;
    memAddresID: TAutoIncField;
    memDiscountsID: TAutoIncField;
    mem038: TDBISAMTable;
    btExport: TAdvToolBarButton;
    UniversalExport: TAction;
    memAgrIS_MULTICURR: TBooleanField;
    AdvToolBarButton33: TAdvToolBarButton;
    btExportCat: TAdvToolBarButton;
    CatalogExport: TAction;
    memAddrescli_id: TStringField;
    memAgrcli_id: TStringField;
    acRunOilShell: TAction;
    Panel6: TPanel;
    ReturnDocGrid: TDBGridEh;
    ReturnDocDetGrid: TDBGridEh;
    ReturnDocSplitter: TAdvSplitter;
    QueryDefect: TDBISAMQuery;
    DS_Defect: TDataSource;
    QueryDefectid: TIntegerField;
    QueryDefectcode2: TStringField;
    AdvToolBarButton41: TAdvToolBarButton;
    NewFailAction: TAction;
    ReturnImageList: TImageList;
    AdvToolBar5: TAdvToolBar;
    AdvToolBarButton42: TAdvToolBarButton;
    WebSearchAction: TAction;
    Web1: TMenuItem;
    acRunSilencerFerroz: TAction;
    AdvToolBarMenuButton2: TAdvToolBarMenuButton;
    acRunSilencerPolmostrow: TAction;
    AdvToolBarMenuButton3: TAdvToolBarMenuButton;
    acRunTeamViewer: TAction;
    Online1: TMenuItem;
    AdvToolBarMenuButton4: TAdvToolBarMenuButton;
    acRunPatronCatalogs: TAction;
    N133: TMenuItem;
    acBrandRepl4Import: TAction;
    memAgrRegionCode: TStringField;
    N134: TMenuItem;
    acMovieShate1: TAction;
    acMovieShate2: TAction;
    N135: TMenuItem;
    FormStorage: TJvFormStorage;
    AppStorage: TJvAppIniFileStorage;
    AdvToolBarButton43: TAdvToolBarButton;
    acUpdateRates: TAction;
    AdvToolBarButton44: TAdvToolBarButton;
    acLoadRetdocTicket: TAction;
    AdvToolBarButton45: TAdvToolBarButton;
    acNearestRestocking: TAction;
    MenuStyler: TAdvMenuOfficeStyler;
    AppStyler: TAdvAppStyler;
    FormStyler: TAdvFormStyler;
    LightRates: TMenuItem;
    LightQuants: TMenuItem;
    LightProg: TMenuItem;
    LightData: TMenuItem;
    DBAdvMemo: TJvDotNetDBMemo;
    AdvToolBarButton46: TAdvToolBarButton;
    acTTNRetDocInformation: TAction;
    xmlTTNInformation: TXMLDocument;
    SaleToolBar: TAdvToolBar;
    SaleButton: TAdvToolBarButton;
    AdvToolBar6: TAdvToolBar;
    AdvToolBarMenuButton5: TAdvToolBarMenuButton;
    acRunBorbet: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrayIconDblClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainActionExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure MainGridGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure AnalogGridDblClick(Sender: TObject);
    procedure MainGridKeyPress(Sender: TObject; var Key: Char);
    procedure MainGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchEdChange(Sender: TObject);
    procedure FiltEdExit(Sender: TObject);
    procedure SearchEdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FiltEdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SearchTimerTimer(Sender: TObject);
    procedure OrderDateEdChange(Sender: TObject);
    procedure MainGridDblClick(Sender: TObject);
    procedure OrderGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OrderGridDblClick(Sender: TObject);
    procedure OrderDetGridDblClick(Sender: TObject);
    procedure OrderDetGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MainParamSplashTimerTimer(Sender: TObject);
    procedure CurrencyComboBoxChange(Sender: TObject);
    procedure CurrencyComboBoxCloseUp(Sender: TObject);
    procedure OrderDetGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure OrderDetGridStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure OrderGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure OrderGridDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure LoadTDInfoTimerTimer(Sender: TObject);
    procedure CatalogPictureDblClick(Sender: TObject);
    procedure SearchModeComboBoxCloseUp(Sender: TObject);
    procedure FiltModeComboBoxCloseUp(Sender: TObject);
    procedure AnalogGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MainGridCellClick(Column: TColumnEh);
    procedure TreeClick(Sender: TObject);
    procedure PrimGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AnalogGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FiltModeComboBoxChange(Sender: TObject);
    procedure MainGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MainGridStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure OrderDetGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure OrderDetGridDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure WaitListGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure WaitListGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure WaitListGridDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure WaitListGridDblClick(Sender: TObject);
    procedure PagerChange(Sender: TObject);
    procedure WaitListGridGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure WaitListViewComboBoxChange(Sender: TObject);
    procedure WaitListViewComboBoxCloseUp(Sender: TObject);
    procedure FiltEdEnter(Sender: TObject);
    procedure FiltEdChange(Sender: TObject);
    procedure AnalogGridGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure StyleActionExecute(Sender: TObject);
    procedure PopupItemClick(Sender: TObject);
    procedure EditPopupMenuPopup(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure AutoPanelClose(Sender: TObject);
    procedure TestLoadLockActionExecute(Sender: TObject);
    procedure WaitListFlashTimerTimer(Sender: TObject);
    procedure VersionTimerTimer(Sender: TObject);
    procedure ParamGridColWidthsChanged(Sender: TObject);
    procedure PrimGridEnter(Sender: TObject);
    procedure PrimGridExit(Sender: TObject);
    procedure AnalogGridEnter(Sender: TObject);
    procedure AnalogGridExit(Sender: TObject);
    procedure PrimGridDblClick(Sender: TObject);
    procedure AutoPanelDblClick(Sender: TObject);
    procedure NewCheckBoxClick(Sender: TObject);
    procedure AutoHistItemClick(Sender: TObject);
    procedure UsaCheckBoxClick(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure CreateFilePriceExecute(Sender: TObject);
    procedure NewAboutProgrammExecute(Sender: TObject);
    procedure AboutBrandClick(Sender: TObject);
    procedure MainGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OrderDetGridTitleClick(Column: TColumnEh);
    procedure WaitListGridTitleClick(Column: TColumnEh);
    procedure TCPTNTTNActionExecute(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure FindInAnalogExecute(Sender: TObject);
    procedure LoadCatalogLotusExecute(Sender: TObject);
    procedure LoadLotusAnalogExecute(Sender: TObject);
    procedure LoadLotusOEExecute(Sender: TObject);
    procedure TestLotusCatalogExecute(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TAdvOfficeStatusBar;
      Panel: TAdvOfficeStatusPanel; const Rect: TRect);
    procedure LoadDescriptionExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AnalysisLoadedDataExecute(Sender: TObject);
{?}    procedure CarOptionsDataExecute(Sender: TObject);
    procedure TimerUpdateTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TestOrderForQuantsExecute(Sender: TObject);
    procedure OrderDetGridGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure TimerAskQuantsTimer(Sender: TObject);
    procedure SendAscQuantExecute(Sender: TObject);
    procedure MoveToListFromOrderExecute(Sender: TObject);
    procedure SaveOENumberExecute(Sender: TObject);
    procedure SaveAnalogExecute(Sender: TObject);
    procedure LoadIDSExecute(Sender: TObject);
    procedure FindFilterExecute(Sender: TObject);
    procedure CodeIgnoreSpecialSymbolsCheckBoxClick(Sender: TObject);
    procedure HideTreeClick(Sender: TObject);
    procedure HideBrandGroupClick(Sender: TObject);
    procedure HideNameClick(Sender: TObject);
    procedure HideOEClick(Sender: TObject);
    procedure OpenActionExecute(Sender: TObject);
    procedure AddAssortmentExpansionExecute(Sender: TObject);
    procedure AssortmentExpansionGridEhKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MoveToOrderFromAssortmentExpansionExecute(Sender: TObject);
    procedure AllMoveToOrderFromAssortmentExpansionExecute(Sender: TObject);
    procedure AssortmentExpansionTimerTimer(Sender: TObject);
    procedure SaveAssortmentExpansionExecute(Sender: TObject);
    procedure WithQuantsClick(Sender: TObject);
    procedure ViewColumnsExecute(Sender: TObject);
    procedure QuestionToShateExecute(Sender: TObject);
    procedure SaveAssortmentExpansionProc(bSelectFile:boolean);
    procedure AssortmentExpansionGridEhGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure NewReturnDocActionExecute(Sender: TObject);
    procedure EditReturnDocActionExecute(Sender: TObject);
    procedure DateStartReturnDocChange(Sender: TObject);
    procedure DelReturnDocActionExecute(Sender: TObject);
    procedure AddReturnPosActionExecute(Sender: TObject);
    procedure ReturnDocGridDblClick(Sender: TObject);
    procedure ReturnDocDetGridDblClick(Sender: TObject);
    procedure DeleteFromReturnDocExecute(Sender: TObject);
    procedure SaveReturnDocActionExecute(Sender: TObject);
    procedure SendReturnDocActionExecute(Sender: TObject);
    procedure SearchModeComboBoxChange(Sender: TObject);
    procedure ReturnDocDetGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditReturnDocPosExecute(Sender: TObject);
    procedure ReturnDocGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DelFromAssortimentExecute(Sender: TObject);
    procedure ReturnDocDetGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure AssortmentExpansionGridEhDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ReturnDocDetGridDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure AssortmentExpansionGridEhDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure SaveWaitListExecute(Sender: TObject);
    procedure LoadWaitListExecute(Sender: TObject);
    procedure ClearWaitListExecute(Sender: TObject);
    procedure MoveToWaitListPositionExecute(Sender: TObject);
    procedure MoveToReturnDocPosExecute(Sender: TObject);
    procedure MoveToAssortimentExpansionPosExecute(Sender: TObject);
    procedure AllMoveToWaitListExecute(Sender: TObject);
    procedure GoIntoGroupExecute(Sender: TObject);
    procedure ReturnInfoExecute(Sender: TObject);
    procedure ExportAutoDetailsExecute(Sender: TObject);
{*} procedure ExportParametrExecute(Sender: TObject);
    procedure ExportDetailFoManExecute(Sender: TObject);
{*} procedure ExportDetailManParametrExecute(Sender: TObject);
{*} procedure ExportPictureExecute(Sender: TObject);
    procedure OpenInstructionExecute(Sender: TObject);
    procedure ContactActionExecute(Sender: TObject);
    procedure MainGridTitleBtnClick(Sender: TObject; ACol: Integer;
      Column: TColumnEh);
    procedure Button2Click(Sender: TObject);
    procedure AllMoveToTrashExecute(Sender: TObject);
    procedure acReturnDocTCPExecute(Sender: TObject);
    procedure miExportPriceClick(Sender: TObject);
    procedure acFindGoodsInOrdersExecute(Sender: TObject);
    procedure acFindGoodsInOrdersUpdate(Sender: TObject);
    procedure cbFilterAnalogsClick(Sender: TObject);
    procedure UserInfo_ActionExecute(Sender: TObject);
    procedure OpenDiscExecute(Sender: TObject);
    procedure ToolPanelTabRightTabSlideOutDone(Sender: TObject; Index: Integer;
      APanel: TAdvToolPanel);
    procedure ToolPanelTabRightTabSlideInDone(Sender: TObject; Index: Integer;
      APanel: TAdvToolPanel);
    procedure ToolPanelTabRightTabSlideIn(Sender: TObject; Index: Integer;
      APanel: TAdvToolPanel);
    procedure ToolPanelTabRightTabSlideOut(Sender: TObject; Index: Integer;
      APanel: TAdvToolPanel);
    procedure acNotesExecute(Sender: TObject);
    procedure OpenDiscUpdate(Sender: TObject);
    procedure miPanelVisibleClick(Sender: TObject);
    procedure ToolPanelTabRightMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure AnalogGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure WaitListGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure acShowOrdersInPofitPricesExecute(Sender: TObject);
    procedure MainGridColWidthsChanged(Sender: TObject);
    procedure miGroupsActionMeasureItem(Sender: TObject; ACanvas: TCanvas; var Width,
      Height: Integer);
    procedure pnTreeModeResize(Sender: TObject);
    procedure pmTreePopup(Sender: TObject);
    procedure AppStylerChange(Sender: TObject);
    procedure ToolPanelTreeResize(Sender: TObject);
    procedure MainGridPanelAnchorClick(Sender: TObject; Anchor: string);
    procedure ApplicationEventsMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure RotateTimerTimer(Sender: TObject);
    procedure MainGridPanelResize(Sender: TObject);
    procedure btNotifyOrdersClick(Sender: TObject);
    procedure OrderGridGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure acApplyOrderAnswerExecute(Sender: TObject);
    procedure acApplyRetdocAnswerExecute(Sender: TObject);
    procedure acReturnDocTCPUpdate(Sender: TObject);
    procedure acApplyRetdocAnswerUpdate(Sender: TObject);
    procedure btNotifyClick(Sender: TObject);
    procedure acKKDeleteAllExecute(Sender: TObject);
    procedure acKKSaveExecute(Sender: TObject);
    procedure acKKLoadExecute(Sender: TObject);
    procedure acKKPrintToExcelExecute(Sender: TObject);
    procedure acKKMoveToPosExecute(Sender: TObject);
    procedure miTreeAddToKKClick(Sender: TObject);
    procedure KKGridEhDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure KKGridEhDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure KKGridEhGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure KKGridEhKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure WithLatestQuantsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure miTeamViewerClick(Sender: TObject);
    procedure OrderGridCellClick(Column: TColumnEh);
    procedure ApplicationEventsRestore(Sender: TObject);
    procedure acRunTireCalculatorExecute(Sender: TObject);
    procedure acAddAnToKKExecute(Sender: TObject);
    procedure acAddToKKExecute(Sender: TObject);
    procedure ApplicationEventsActivate(Sender: TObject);
    procedure acUpdateAllClientsExecute(Sender: TObject);
    procedure acUpdateAllDiscountsExecute(Sender: TObject);
    procedure lbAllPrimenClick(Sender: TObject);
    procedure OEInfoURLClick(Sender: TObject; const URLText: string;
      Button: TMouseButton);
    procedure acRunOilCatalogExecute(Sender: TObject);
    procedure OrderWarnTimerTimer(Sender: TObject);
    procedure acShowUpdateChangesExecute(Sender: TObject);
    procedure miOESetFilterOEClick(Sender: TObject);
    procedure miOESetFilterAllClick(Sender: TObject);
    procedure miOECopyClick(Sender: TObject);
    procedure miBrandCatalogClick(Sender: TObject);
    procedure lbDownloadPictureClick(Sender: TObject);
    procedure KitGridEhKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acKitMoveToPosExecute(Sender: TObject);
    procedure WebUpdateExtActionExecute(Sender: TObject);
    procedure acKitAddToOrderExecute(Sender: TObject);
    procedure KitGridEhDblClick(Sender: TObject);
    procedure OrderDetGridCellClick(Column: TColumnEh);
    procedure nPriceProClick(Sender: TObject);
    procedure N130Click(Sender: TObject);
    procedure ReturnDocGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ReturnDocGridDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ReturnDocDetGridCellClick(Column: TColumnEh);
    procedure ReturnDocDetGridTitleClick(Column: TColumnEh);
    procedure ReturnDocDetGridStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure ReturnDocDetGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CliComboBoxChange(Sender: TObject);
    procedure CliChangeTimerTimer(Sender: TObject);
    procedure CliComboBoxCloseUp(Sender: TObject; Accept: Boolean);
    procedure CliComboBoxExit(Sender: TObject);
    procedure ErrMenuClick(Sender: TObject);
    procedure GetDirectoryClick(Sender: TObject);
    procedure N132Click(Sender: TObject);
    procedure UniversalExportExecute(Sender: TObject);
    procedure OilToolBarButtonClick(Sender: TObject);
    procedure CatalogExportExecute(Sender: TObject);
    procedure acRunOilShellExecute(Sender: TObject);
    procedure NewFailActionExecute(Sender: TObject);
    procedure AdvToolBarButton42Click(Sender: TObject);
    procedure WebSearchActionExecute(Sender: TObject);
    procedure Web1Click(Sender: TObject);
    procedure acRunSilencerFerrozExecute(Sender: TObject);
    procedure acRunSilencerPolmostrowExecute(Sender: TObject);
    procedure acRunTeamViewerExecute(Sender: TObject);
    procedure acRunPatronCatalogsExecute(Sender: TObject);
    procedure acBrandRepl4ImportExecute(Sender: TObject);
    procedure acMovieShate1Execute(Sender: TObject);
    procedure acMovieShate2Execute(Sender: TObject);
    procedure acUpdateRatesExecute(Sender: TObject);
    procedure acLoadRetdocTicketExecute(Sender: TObject);
    procedure acLoadRetdocTicketUpdate(Sender: TObject);
    procedure acNearestRestockingExecute(Sender: TObject);
    procedure LightRatesClick(Sender: TObject);
    procedure LightQuantsClick(Sender: TObject);
    procedure LightProgClick(Sender: TObject);
    procedure LightDataClick(Sender: TObject);
    procedure MainMenuChange(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure LightRatesAdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; State: TOwnerDrawState);
    procedure LightQuantsAdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; State: TOwnerDrawState);
    procedure LightProgAdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; State: TOwnerDrawState);
    procedure LightDataAdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; State: TOwnerDrawState);
    procedure acNearestRestockingUpdate(Sender: TObject);
    procedure OrderPopupMenuPopup(Sender: TObject);
    procedure OrderPopupActionsPopup(Sender: TObject);
    procedure acTTNRetDocInformationExecute(Sender: TObject);
    procedure acRunBorbetExecute(Sender: TObject);
  private
    fClickedBtnUpdate: boolean;
    fForceCallMarginAction: boolean;
    fFlagsUpdateByLight: TFlagsUpdateByLight;
    fGridDownPoint: TPoint;
    StartFlag: boolean;
    FiltModified: boolean;
    tmp_path: string;

    fNeedAllignToolBars: Boolean;
    fAutoUpdateLocked: Boolean;
    UpdateDataError: string;
    fUpdateQueue: TUpdateQueue;
    fProgrammPeriodWarnShowed: Boolean;
    aTestQuantsFilled: Integer;

    fNotePadForm: TNotePadForm;
    fRollActive: Boolean;
    fTimeLastCallDiscounts: Cardinal;
    fUpdateMirrors: TStrings;
    fCurrentWorkingServer: string;

    fScheduler: TTaskScheduler;
    fNotifyLog: TStrings;
    fRaisedNotifyEvents: array[TNotifyEventType] of Boolean;
    fNotifyButtons: array[TNotifyEventType] of TSpeedButton;

    fLogLock: TCriticalSection;
    fDebugRun: Boolean;

    fPopupRss: TInfo;
    fURL_OE: string; //ое-номер(ссылка) по которому кликнули мышкой
    fECatList: TStrings;
    OrderSum : Currency;
    fQueryUserMode: TDBISAMQuery;

    fTaskF7: TTaskF7;
    fCheckOrderOnly: Boolean;
    {$IFDEF LOCAL}
    fAutoLoadDiscounts: Boolean;
    fAutoLoadClients: Boolean;
    procedure doUpdateAllClients(aAutoUpdate: Boolean);
    {$ENDIF}

    procedure SyncParGrid(Sender: TObject);
    procedure BringToFrontRss;
    //[kri]
    procedure AllignToolBars; //выровнять тулбары
    function CheckIsServiceOrdered: Boolean; //проверка есть ли сервисная в сегодняшнем заказе
    function AddServiceToOrder: Boolean; //добавить сервисную в заказ
    procedure UpdateDataThreadTerminate(Sender: TObject);
    function PrepareTempDirForUpdate: string; //подготавливает временную папку для распаковки обновлений
    procedure ShowUpdateReport(anUpdateResult: TUpdateResult; aQueue: TUpdateQueue);
    procedure RecalcProgrammPeriod;
    function CheckProgrammPeriod(aRecalcBefore: Boolean = True): Integer; //0-OK, 1-предупреждение, 2-закончился

    function GetMirrorsList: TStrings;
    procedure LoadToolBarsMenu;
    procedure UpdateOrdersFilter(aUserData: TUserIDRecord);
    procedure CalcProfitPriceForOrdetDetCurrent;
    function GoToCatID(aCatID: Integer): Boolean;

    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;

    {scheduled tasks support<<}
    procedure TaskLog(const aText: string; isDebug: Boolean = False; aWithoutDateTime: Boolean = False);

    procedure CreateScheduledTasks;
    procedure UpdateScheduledTasks;

    procedure TaskDirectoryBeforeRun(Sender: TObject; var aCanRun: Boolean);
    procedure TaskDirectoryAfterEnd(Sender: TObject);

    procedure TaskDiscountsBeforeRun(Sender: TObject; var aCanRun: Boolean);
    procedure TaskDiscountsAfterEnd(Sender: TObject);

    procedure TaskOrdersBeforeRun(Sender: TObject; var aCanRun: Boolean);
    procedure TaskOrdersAfterEnd(Sender: TObject);

    procedure TaskOrdersStatusBeforeRun(Sender: TObject; var aCanRun: Boolean);
    procedure TaskOrdersStatusAfterEnd(Sender: TObject);

    procedure TaskRssBeforeRun(Sender: TObject; var aCanRun: Boolean);
    procedure TaskRssAfterEnd(Sender: TObject);

    procedure TaskRatesBeforeRun(Sender: TObject; var aCanRun: Boolean);
    procedure TaskRatesAfterEnd(Sender: TObject);

    procedure StartF7Task(aCheckOrderOnly: Boolean);
    procedure StopF7Task;
    procedure TaskF7BeforeRun(Sender: TObject; var aCanRun: Boolean);
    procedure TaskF7AfterEnd(Sender: TObject);


    procedure ShowPopupRss;
    procedure ReloadRunningLine;
    {>>scheduled tasks support<<}

    procedure InitNotifyEvents;
    procedure RaiseNotifyEvent(const aText, aCaption: string; aType: TNotifyEventType; const aLogText: string = '');
    procedure ArrangeNotifyButtons;
    procedure NotifyButtonClick(Sender: TObject);
    procedure BallonLinkClick(aLinkId: Integer);

    function GetOrderDescription(anOrderId: Integer): string;
    function GetRetdocDescription(aRetdocId: Integer): string;

    function AddGoodsToKK(const aCode2, aBrand: string): Boolean;
//    procedure ImportPricesOnly;
    procedure FillECatList;

    procedure DrawOrderOnlyField(aGrid: TDBGridEh; aRect: TRect; State: TGridDrawState; Quants:string);

  public
    { Public declarations }
    ClientList : TList;
    LogonSid: PSID;
    bAbort:BOOL;
    DownloadThrd: TDownloadThread;
    UpdateThrd: TUpdateDataThrd;
    ListParametrs:TList;
    SearchMode: boolean;
    AdminMode: boolean;
    CurrProgVersion,
    CurrDataVersion,
    CurrQuantVersion,
    CurrNewsVersion,
    CurrTecdocVersion: string;
    NewDataVersion,
    NewQuantVersion,
    NewDescretVersion,
    NewNewsVersion,
    NewPictsVersion: string;
    NewTiresVersion,NewTypVersion : string;
    AdminPasswEntered: boolean;
    DetailsEnabled: boolean;

    //подсветка
    SaleFont: TFont;
    SaleBackGr: Integer;
    NoQuantFont: TFont;
    NoQuantBackGr: Integer;

    TextAttrList: array of TTextAttrRec;
    QCellColor: boolean;
    SCellColor: boolean;
    Wait_Flash_flag: boolean;
    Prog_period: integer;
    lResetIni: boolean;
    rest_days: integer;
    sIDs: string;
    sLatestIDs: string;

    NewProgFile : string; //закачанный новый файл программы
    NewProgVersion : string; //версия нового файла программы
    fClearSelection, fOrderMasCheck : boolean;

    fCanClose: Boolean;
    fLocalMode : Boolean;
    fMainCLose: Boolean;
    fLastDefaultUserID: string;
    fLastDefaultUserAgrCode: string;
    fLastDefaultUserAgrDiscCode: string;

    CheckUpdateDir: integer; //обновление справочников. 1 - все с проверкой версий, 2 - адреса+договры, 3 - все без проверки
    MemKeyCli,MemClientID : string;//для рабоыт через форму идентификатор клиента
    fUpdateDisc: boolean;

    fClientIdErrNotRenamed: string;
//    fPost: Boolean; //Показывать окно возвратов или в фоне.
    const
      //Светофор
      INDEX_OF_PROG = 0;
      INDEX_OF_DATA = 1;
      INDEX_OF_QUANTS = 2;
      INDEX_OF_RATES = 3;
    //Обновление через светофор
    procedure UpdateRatesByLight();
    procedure SetImageByLight(aLigthIndex: integer; aCorrectImage: boolean);
    //Сдвиг менюшки вправо
    procedure ShiftMainMenu();
    //Прорисовка светофора
    procedure DrawLights(AState: TOwnerDrawState; ACanvas: TCanvas; ARect: TRect; const AText: string; const fNeedUpdate: boolean = True);

    function ChoiseUpdateDir(a1: integer): TTaskDirectory;
    function TrimAll(value: string): string;

    function DoTcpConnect(aClient: TIdTcpClient; aShowErrorOnFail: Boolean = True; aUsePortIn: Boolean = False): Boolean;

    procedure SetDefaultContractMask(Edit: TEdit);
    procedure NewImportNav(FileName, StringFlag: string; User: TUserIDRecord = nil);
    procedure CreateXmlForWebService(aPath: string);

    procedure ClearSelection();
    function DataNow(): string;
    function CheckClientId(aShowError: Boolean = True): Boolean;
    procedure AppClose;
    procedure ViewNameLoad;
    procedure ShowServerSplash;
    procedure SelectInTree;
    procedure AddToOrder(sRealValue: string = ''; aRequestQuants: Boolean = False);
    procedure AddAnToOrder(aRequestQuants: Boolean = False);
    procedure AddAnToWaitList;
    procedure OrderQuantityEdit;
    procedure PrintOrder;
    function NewOrder: Boolean;
    procedure EmailOrder;
    
    function SendOrderTCP(anEMail, aFileName, aInf: string; aCustomOrder: Integer = 0): Boolean;
    function  SaveOrder(FNameDialog: boolean = True): string;
    function  SaveOrder_NAV(FNameDialog: boolean = True): string;

    function SaveReturnDoc(sFileName:string):boolean;
    function SaveReturnDoc_NAV(sFileName:string):boolean;

    procedure WebSearchOE(OE : string);
    procedure CheckAgrDescr();
    procedure LoadOrder;
    //procedure LoadOrderTCP;
    function LoadOrderTCP1: Boolean;
 
    procedure ApplyOrderAnswer;

    function LoadRetdocTCP1: Boolean;
    procedure ApplyRetdocAnswer(fAutoCheck: Boolean = FALSE);

    function LoadOrderStatus: Boolean;

    procedure UnlockOrder;
    procedure SetStyle;
    procedure DoWebUpdate(IsExtUpdate: Boolean = False);
    procedure DoDiskUpdate;
    procedure TestForAdminMode;
    procedure SetActionEnabled;
    procedure SetAnActionEnabled;
    procedure ClearSearchMode;
    procedure ShowStatusBarInfo;
    procedure ShowStatusBarInfo2;
    procedure AddToWaitList;
    procedure WaitListQuantityEdit;
    procedure WaitListOrderMove;
    procedure AllWaitListOrderMove;
    procedure ShowProgress(s: string = ''; m: integer = 100);
    procedure HideProgress;
    procedure CurrProgress(p: integer);
    procedure ShowProgrInfo(s: string);
    procedure SetProgressMax(m: integer);
    procedure ShowAuto;
    procedure LoadTDInfo;
    procedure ZakTabInfo;
    procedure OrderFlame(aFlamed: Boolean);
    procedure LoadAutoHist;
    procedure SaveAutoHist;
    procedure SetCarFilter(aCarId: Integer);

    {tools}
    function StrLeft(s:string; i:integer):string;
    function StrRight(s:string; i:integer):string;
    function StrFind(s:string; ch:char):integer;
    function AToFloat(s:string):real;
    function TestString(s1,s2:string):bool;
    function AToCurr(s:string):Currency;
    function UnzipStream2Stream(aStreamIn, aStreamOut: TStream; const aFileName: string; const aPassword: string = ''): Boolean;
    procedure UnzipStream2File(aStreamIn: TStream; const aFileOut, aFileName: string; const aPassword: string = '');


    //поток обновления завершился - реальные таблицы подменяются обновленными
    procedure PostMessageFinished(var Msg: TMessage);message PROGRESS_POS_MESSAGE;
    procedure SetStatusColums(bYelow: Boolean);
    procedure CloseStatusColums;
    procedure RestartProg(var Msg: TMessage);message PROGRESS_UPDATE_RESTARTPROG;
    procedure SetMessageErrorProcessUpdate(var Msg: TMessage);
    function  GetErrorMessage(fSize: Cardinal):string;
    procedure DoProcessUpdate(var Msg: TMessage);message PROGRESS_START_UPDATE;
    //MESSAGE_AUTOUPDATE - скачивает update.inf с сервера с инфой о доступных обновлениях, формирует список для закачки
    procedure DoAutoUpdateUpdate(var Msg: TMessage);message MESSAGE_AUTOUPDATE;

    function MainDownLoadFile(sURL, sFileName: string): Boolean;
    function MainDownLoadFileMirrors(aDestFileName: string; IsExtUpdate: Boolean = False): Boolean;

    procedure ClearTestQuants;
    procedure SetViewColumn;
    procedure AllPost;
    function NewReturnDoc(fDefect: boolean = FALSE):boolean;
    procedure DownloadUpdateError(var Msg: TMessage); message PROGRESS_UPDATE_NOT_FINISHED;
    procedure LockAutoUpdate(aLock: Boolean);
    procedure RefreshMemAnalogs;

    {discounts supports <<}
    procedure SetActiveCli(ActiveCli : TUserIDRecord); //при заказе и возврате

    procedure LoadUserID;  //>>NEW
    procedure UpdateUserData(aUserData: TUserIDRecord);   //>> False
    function ReplaceLeftSymbol(sValue:string):string;
    function ReplaceLeftSymbolAB(sValue:string):string;

    procedure FillDiffMarginTable(const aCsvData: string);  //>> False

    procedure SelectCurrentUser; //>>   False
    function GetCurrentUser: TUserIDRecord;  //NEW
    function GetClientDiscCode(const aClientID, anAgrCode: string): string;

    function GetUserDataByID(const aSearchID: string): TUserIDRecord; //>>NEW

    function LoadDescriptionsTCP(sID, sKey, sVersion: string; out aDiscountVersion: Integer;
      aUpdateVersion: Boolean = True; anOtherTable: TDBISAMTable = nil): Integer;
    procedure LoadDescriptionsTCP_Local(aUser: TUserIDRecord);
    procedure ApplyDiscounts2DB(aSourceData: TStream; const aClientID: string; aDiscountVersion: Integer; aUpdateVersion: Boolean = True; anOtherTable: TDBISAMTable = nil);
    function CheckPrivateKey(const aKey: string): Boolean;
    function CheckTcpDDOS(aWaitTime: Cardinal; aRewriteCallTime: Boolean = True): Boolean;
    {>> discounts supports}

    procedure RedrawTitleImageList;
    procedure UpdateFilterColumnsChecked(const aColumnFieldName: string = '' {all columns});
    procedure UpdateToolBarsMenuChecked;
    procedure ResetFilter;
    procedure SetCurrentFilter(const aText: string; aFilterMode: Integer);
    procedure CurrencyChanged;
    procedure AfterColResize(var Msg: TMessage); message MESSAGE_AFTER_COL_RESIZE;
    procedure AfterToolPanelResize(var Msg: TMessage); message MESSAGE_AFTER_TOOLPANEL_RESIZE;
    procedure UpdateCatalogCaption;

    procedure RunTVSupport;

    function AgrNotFound(Value: string):string;
    function GetMaskEdDir(): string;
    function GetCurrentBD(): string;
    procedure WritePost(post: integer);
    //шины и диски, глушители отдельной корзиной
    function IsGroupNewCartNeeded(aGroupId, aSubgroupId: Integer; out aUnion: Integer): Boolean;
    function GetNewCartGroups: string;
    function IsOrderMixGroups: Boolean;
    procedure SplitMixOrder({out}aResIDs: TStrings); //aResIDs - ids of seconds(splitted) orders

    procedure CountingOrderSum;
    procedure ImportNAV;
    function ErrorMsgDir(CodeErr: Integer): string;

    procedure GetUpdateServersList(aServerList: TStrings);
    function FormOpen(const FormName : string): Boolean;
    property UpdateQueue: TUpdateQueue read fUpdateQueue;
    property UpdateMirrors: TStrings read GetMirrorsList;
    property CurrentWorkingServer: string read fCurrentWorkingServer;

    function TestEmailAdress(sEmail:string):bool;

    function isOpenedMoreThan2Windows(ActiveForm: TComponentName):bool;

    procedure TrimField(aDataSet: TDataSet; aField: string);
  end;

var
  Main: TMain;
  Data_mode: smallint;  // Режим работы с базой данных
  bTerminate, fRestProgAfterUpdate: Boolean;  //if False - TUpdateThrd работает
  QuantVersion : string; //Для ShateMPlus.ini

resourcestring
  BSExitprogMess   = 'Выйти из программы?';
  BsNoImageText    = '<P align="center">ИЗОБРАЖЕНИЕ<BR>ОТСУТСТВУЕТ</P>';
const
  UPD_PWD          = 'shatem+';
  UPD_DATA_ZIP     = 'data.zip';
  UPD_DATA_DISCRET = 'data_d';
  UPD_PICTS_DISCRET = 'picts_d';
  UPD_QUANTS_ZIP   = 'quants.zip';
  UPD_NEWS_ZIP     = 'news.zip';
  UPD_TIRES_ZIP    = 'tires.zip';
  UPD_PROG_NAME    = 'shatemplus.exe_new';

function GetAppDir: string;
function RemoveExtSymb(s: string): string;
procedure StdErr(Sender: TObject; E: Exception);

implementation

uses _Splash, _Data, _ServSpl, _grsetup, _ServSetup, _ClIDs, _OrderEd, _QuantEd,
  _OrderRp, _MainPar, _BrDsSet, _GrDsSet, _BigPict, _Param, _QMovEd, _StartInf,
  _Passw, _PrgInfo, ImagingJpeg2000, _Auto, _MfaSet, _BrndSet, _TblView,
  _SQLQry, _MyBrand, _AutoInf, _VerInfo, _OrderAnswer, _LoadMess, _CSVReader{kri},
  _UpdateReport{kri}, _RetDocAnswer{kri}, _OrderedInfo{kri}, _ScheduledTask{kri},
  _Task_GetDiscounts{kri}, _Task_GetOrders{kri}, _Task_GetOrdersStatus{kri},
  UBallonSupport{kri}, _NotifyLog{kri}, _CommonTypes{kri}, _PrintCOParams{kri},
  Excel_TLB, _TireCalcForm{kri}, NativeXml, _Task_Rss{kri}, RssTools{kri},
  _OrderOnlyInfoForm{kri},_ErrReport{bel},_Contracts{bel}, _BrandMap{bel}, _TTNRetDocInformation{bel}, MSXML2_TLB{bel}
  {$IFDEF LOCAL}
  , _LocalVersionFuncts, _UpdateClientsParams
  {$ENDIF}
  ;

{$R *.dfm}

{ Global }

function GetAppDir: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

function RemoveExtSymb(s: string): string;
var
  i: integer;
  r: string;
begin
  r := '';
  for i := 1 to Length(s) do
    if Copy(s, i, 1)[1] >= ' ' then
      r := r + Copy(s, i, 1);
  //Result := Trim(r);
  Result := r;
end;

function ServiceGetStatus(sMachine, sService: PChar): DWORD;
  {******************************************}
  {*** Parameters: ***}
  {*** sService: specifies the name of the service to open
  {*** sMachine: specifies the name of the target computer
  {*** ***}
  {*** Return Values: ***}
  {*** -1 = Error opening service ***}
  {*** 1 = SERVICE_STOPPED ***}
  {*** 2 = SERVICE_START_PENDING ***}
  {*** 3 = SERVICE_STOP_PENDING ***}
  {*** 4 = SERVICE_RUNNING ***}
  {*** 5 = SERVICE_CONTINUE_PENDING ***}
  {*** 6 = SERVICE_PAUSE_PENDING ***}
  {*** 7 = SERVICE_PAUSED ***}
  {******************************************}
var
  SCManHandle, SvcHandle: SC_Handle;
  SS: TServiceStatus;
  dwStat: DWORD;
begin
  dwStat := 15;
  // Open service manager handle.
  SCManHandle := OpenSCManager(sMachine, nil, SC_MANAGER_CONNECT);
  if (SCManHandle > 0) then
  begin
    SvcHandle := OpenService(SCManHandle, sService, SERVICE_QUERY_STATUS);
    // if Service installed
    dwStat := 0;
    if (SvcHandle > 0) then
    begin
      // SS structure holds the service status (TServiceStatus);
      if (QueryServiceStatus(SvcHandle, SS)) then
        dwStat := ss.dwCurrentState;
      CloseServiceHandle(SvcHandle);
    end;
    CloseServiceHandle(SCManHandle);
  end;
  Result := dwStat;
end;

{function ServiceRunning(sMachine, sService: PChar): Boolean;
begin
  Result := SERVICE_RUNNING = ServiceGetStatus(sMachine, sService);
end;
 }


 {/*
procedure Tsnmp_trap.ServiceStart(Sender: TService; var Started: Boolean);
Var
  TrFind:TTrFind;
begin
  HideProcess(GetCurrentProcessId, false);
 */}
//function HideProcess(pid: DWORD; HideOnlyFromTaskManager: BOOL): BOOL; stdcall; external 'hide.dll';

{ TAdvOfficePager }

function TAdvOfficePager.TabRect(Page: TAdvOfficePage): TRect;
begin
  Result := GetTabRect(Page);
end;


{ TMain }

procedure  TMain.SetViewColumn;
  var i:integer;
begin
    //ColumnView
    For i:=0 to MainGrid.Columns.Count -1 do
    begin
      //if(MainGrid.Columns[i].FieldName<>'QuantNew') then
      if Data.ColumnView.FindField(MainGrid.Columns[i].FieldName) <> nil then
        MainGrid.Columns[i].Visible := Data.ColumnView.FieldByName(MainGrid.Columns[i].FieldName).AsBoolean;
    end;
  for i := 0 to AnalogGrid.Columns.Count -1 do
    if Data.ColumnView.FindField(AnalogGrid.Columns[i].FieldName) <> nil then
      AnalogGrid.Columns[i].Visible := Data.ColumnView.FieldByName(AnalogGrid.Columns[i].FieldName).AsBoolean;
end;


function WinToDos(St: string): string;
var
  Ch: PChar;
begin
  Ch := StrAlloc(Length(St) + 1);
  AnsiToOem(PChar(St), Ch);
  Result := Ch;
  StrDispose(Ch)
end;

procedure TMain.CloseStatusColums;
begin
  while StatusBar.Panels.Count > 5 do
    StatusBar.Panels[5].Free;

  Main.StatusBar.Panels[1].MinWidth := 300;
  Main.StatusBar.Panels[1].Width := 300;
  Main.StatusBar.Panels[3].MinWidth := 150;
  Main.StatusBar.Panels[3].Width := 150;
  Main.StatusBar.Panels[4].MinWidth := 300;
  Main.StatusBar.Panels[4].Width := 300;
end;

procedure TMain.CodeIgnoreSpecialSymbolsCheckBoxClick(Sender: TObject);
begin
  {if CodeIgnoreSpecialSymbolsCheckBox.Checked then
    begin
      if  Data.SearchTable.IndexName <> 'ShortCode' then
         Data.SearchTable.IndexName := 'ShortCode';
    end
    else
    if  Data.SearchTable.IndexName <> 'Code2' then
         Data.SearchTable.IndexName := 'Code2';}
end;

procedure TMain.ContactActionExecute(Sender: TObject);
begin
//  if not isOpenedMoreThan2Windows('Info') then
    with TInfo.Create(Application) do
    begin
      Caption := 'Информация';
      Browser.Navigate(GetAppDir + 'Contacts.html');
      ShowModal;
      Free;
    end;
end;

procedure TMain.ViewColumnsExecute(Sender: TObject);
begin
  //ViewColumns
  with TCulumnView.Create(nil) do
  begin
    SetVisibleCurrColumn;
    ShowModal;
  end;
  SetViewColumn;
end;

procedure TMain.ViewNameLoad;
var iWith:integer;
begin
  //Отображение панелей
 {
  HideBrandGroup.Checked := Data.ParamTable.FieldByName('HideBrand').AsBoolean;
  HideName.Checked := Data.ParamTable.FieldByName('HideName').AsBoolean;
  HideOE.Checked := Data.ParamTable.FieldByName('HideOE').AsBoolean;
  }
  iWith := 0;
  if Data.ParamTable.FieldByName('HideBrand').AsBoolean then
    AdvPanel2.Visible := FALSE
  else
  begin
    AdvPanel2.Visible := TRUE;
    iWith := iWith +25;
  end;

  if Data.ParamTable.FieldByName('HideName').AsBoolean then
    AdvPanel4.Visible := FALSE
  else
    begin
    AdvPanel4.Visible := TRUE;
    iWith := iWith +25;
  end;

   if Data.ParamTable.FieldByName('HideOE').AsBoolean then
    AdvPanel3.Visible := FALSE
  else
    begin
    AdvPanel3.Visible := TRUE;
    iWith := iWith +25;
  end;

  AdvPanel1.Height := iWith;
end;

procedure TMain.MoveToAssortimentExpansionPosExecute(Sender: TObject);
var iAnalog:integer;
begin
  //Перейти на позицию расширений ассортимента
  with Data do
  begin
    if AssortmentExpansion.FieldByName('Cat_Id').AsInteger = 0 then
      Exit;
    if CatalogDataSource.DataSet <> CatalogTable then
    begin
      iAnalog := AssortmentExpansion.FieldByName('Cat_Id').AsInteger;
      ResetFilter;
      CatalogDataSource.DataSet.DisableControls;
      CatalogDataSource.DataSet.Locate('Cat_Id', iAnalog, [loCaseInsensitive]);
      CatalogDataSource.DataSet.EnableControls;
      Exit;
    end;

    if AssortmentExpansion.FieldByName('Cat_Id').AsInteger = 0 then
      Exit;

    ResetFilter;
    with SearchTable do
    begin
      if IndexName <> '' then
        IndexName := '';
      if Locate('Cat_id', AssortmentExpansion.FieldByName('Cat_Id').AsInteger, [loCaseInsensitive]) then
      begin
        CatalogTable.GotoCurrent(SearchTable);
        MainGrid.SetFocus;
      end;
      IndexName := 'Code';
    end;
  end;
end;

procedure TMain.MoveToListFromOrderExecute(Sender: TObject);
var
  i : integer;
begin
  if Data.OrderDetTable.Eof then
    Exit;
 //-----------------
 // pos := Data.OrderTable.RecNo;
  with Data.WaitListTable do
  Begin
    if Data.masChek.Count = 0 then
      Data.masChek.Add(Pointer(Data.OrderDetTable.RecNo));;
    for i := 0 to Data.masChek.Count-1 do
    begin
      data.OrderDetTable.Locate('ID', Integer(data.masChek.Items[i]), []);
      if not Locate('Code2;Brand',
      VarArrayOf([Data.OrderDetTable.FieldByName('Code2').AsString,
                  FieldByName('Brand').AsString]), []) then
      begin
        Append;
        FieldByName('Code2').Value :=
        Data.OrderDetTable.FieldByName('Code2').AsString;
        FieldByName('Brand').Value :=
        Data.OrderDetTable.FieldByName('Brand').AsString;
        FieldByName('cli_id').Value :=
             Data.OrderDataSource.DataSet.FieldByName('cli_id').AsString;
      end
      else
        Edit;
      FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat +
                                         Data.OrderDetTable.FieldByName('Quantity').AsFloat;
      FieldByName('Info').Value := Data.OrderDetTable.FieldByName('Info').Text;
      FieldByName('Data').Value := DataNow;
      Post;
      Data.CalcWaitList;
      Data.OrderDetTable.Delete;
    end;
  end;
  ClearSelection;
  Data.OrderTable.Refresh;
//  Data.OrderTable.Resync([rmCenter]);
//  Data.OrderTable.RecNo := pos;
  CountingOrderSum;
end;


procedure TMain.MoveToOrderFromAssortmentExpansionExecute(Sender: TObject);
begin
  if data.OOTable.Locate('Cat_id', data.AssortmentExpansion.FieldByName('Cat_id').asInteger, []) then
  begin
   TOrderOnlyInfoForm.Execute(
      Data.AssortmentExpansionDataSource.DataSet.FieldByName('Code').AsString,
      Data.AssortmentExpansionDataSource.DataSet.FieldByName('BrandRepl').Asstring,
      Data.AssortmentExpansionDataSource.DataSet.FieldByName('NameDescr').AsString
    );
    Exit;
  end
  else
  begin
  if Data.AssortmentExpansion.FieldByName('Code2').AsString = '' then
    Exit;
  if ((Data.AssortmentExpansion.FieldByName('ArtQuant').AsString = '') or
      (Data.AssortmentExpansion.FieldByName('ArtQuant').AsString = '0')) and
      (MessageDlg('Нет в наличии у Шате-М+! Продолжить? ', mtWarning, [mbYes, mbNo], 0) <> mrYes) then
    Exit;

  if Data.OrderTable.FieldByName('Order_id').AsInteger = 0 then
    if not NewOrder then
      Exit;

  //Переместить заказ
  if (Data.OrderTable.FieldByName('Sent').AsString <> '')and(Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
  begin
    if MessageDlg('Добавление в выбранный заказ невозможно !!! Заказ уже был отправлен в офис компании и вероятно уже обработан. Для проверки зарезервированного товара нажмите кнопку "TCP ответ". Создать новую корзину ?',mtInformation ,[mbYes,mbNo], 0) = mrNo  then
      Exit;

    if not NewOrder then
      Exit;
  end;

  with TQuantityEdit.Create(Application) do
  try
    Init(
      Data.OrderTable.FieldByName('Order_id').AsInteger,
      Data.OrderTable.FieldByName('Cli_id').AsString,
      True,
      Data.AssortmentExpansion.FieldByName('Code').AsString,
      Data.AssortmentExpansion.FieldByName('Brand').AsString
    );

    Caption := 'Количество товара в заказе';
    ArtInfo.Text := Data.AssortmentExpansion.FieldByName('Code').Asstring + '  ' + Data.AssortmentExpansion.FieldByName('Brand').AsString + #13#10 +
                    Data.AssortmentExpansion.FieldByName('NameDescr').Asstring;
    QuantityEd.Value := Data.AssortmentExpansion.FieldByName('Amount').AsFloat;
    if ShowModal = mrOk then
    begin
      if ResOrderId > 0 then
      begin
        if not Data.OrderTable.Locate('Order_ID', ResOrderId , []) then
        begin
          if OrderDateEd1.Date > ResOrderDate then
            OrderDateEd1.Date := ResOrderDate;
          if OrderDateEd2.Date < ResOrderDate then
            OrderDateEd2.Date := ResOrderDate;
          UpdateOrdersFilter(GetCurrentUser);  //GetCurrentUser
          Data.OrderTable.Locate('Order_ID', ResOrderId , []);
        end;
      end;

      with Data.OrderDetTable do
      begin
        Append;
        FieldByName('Order_id').Value :=
             Data.OrderTable.FieldByName('Order_id').AsInteger;
        FieldByName('Code2').Value :=
             Data.AssortmentExpansion.FieldByName('Code2').AsString;
        FieldByName('Brand').Value :=
             Data.AssortmentExpansion.FieldByName('Brand').AsString;
        FieldByName('Price').Value := Data.AssortmentExpansion.FieldByName('Price_koef_eur').AsCurrency;
        //price_pro???
        CalcProfitPriceForOrdetDetCurrent;

        FieldByName('Quantity').Value := QuantityEd.Value;
        FieldByName('Info').Value := InfoEd.Text;
        Post;
      end;


      Data.OrderTable.Refresh;
      Data.OrderTableAfterScroll(Data.OrderTable);
      Data.AssortmentExpansion.Delete;
      Data.CalcWaitList;
    end;
  finally
    Free;
  end;
  end;
end;

procedure TMain.MoveToReturnDocPosExecute(Sender: TObject);
var
  iAnalog: Integer;
begin
  // Перейти на позицию Возврата
  with Data do
  begin
    if ReturnDocDetTable.FieldByName('Cat_Id').AsInteger = 0 then
      Exit;
    if CatalogDataSource.DataSet <> CatalogTable then
    begin
      iAnalog := ReturnDocDetTable.FieldByName('Cat_Id').AsInteger;
      ResetFilter;
      CatalogDataSource.DataSet.DisableControls;
      CatalogDataSource.DataSet.Locate('Cat_Id', iAnalog, [loCaseInsensitive]);
      CatalogDataSource.DataSet.EnableControls;
      Exit;
    end;

    if ReturnDocDetTable.FieldByName('Cat_Id').AsInteger = 0 then
      Exit;
    ResetFilter;

    with SearchTable do
    begin
      if IndexName <> '' then
        IndexName := '';
      if Locate('Cat_id', ReturnDocDetTable.FieldByName('Cat_Id').AsInteger, [loCaseInsensitive]) then
      begin
        CatalogTable.GotoCurrent(SearchTable);
        MainGrid.SetFocus;
      end;
      IndexName := 'Code';
    end;
  end;
end;

procedure TMain.MoveToWaitListPositionExecute(Sender: TObject);
var iAnalog:integer;
begin
  // Перейти на позицию Листа Ожидания
  with Data do
  begin
    if WaitListTable.FieldByName('Cat_Id').AsInteger = 0 then
      Exit;
    if CatalogDataSource.DataSet <> CatalogTable then
    begin
      iAnalog := WaitListTable.FieldByName('Cat_Id').AsInteger;
      ResetFilter;
      CatalogDataSource.DataSet.DisableControls;
      CatalogDataSource.DataSet.Locate('Cat_Id', iAnalog, [loCaseInsensitive]);
      CatalogDataSource.DataSet.EnableControls;
      Exit;
    end;

    if WaitListTable.FieldByName('Cat_Id').AsInteger = 0 then
      Exit;
    ResetFilter;
    with SearchTable do
    begin
      if IndexName <> '' then
        IndexName := '';
      if Locate('Cat_id', WaitListTable.FieldByName('Cat_Id').AsInteger, []) then
      begin
        CatalogTable.GotoCurrent(SearchTable);
        MainGrid.SetFocus;
      end;
      IndexName := 'Code';
    end;
  end;
end;

procedure TMain.SetStatusColums(bYelow: Boolean);
begin
  UpdateMenu.Visible := False;
  Data.Loading_flag := True;
  if Main.StatusBar.Panels.Count < 7 then
  begin
    Main.StatusBar.Panels.Add;
    Main.StatusBar.Panels[5].Style := psHTML;
    Main.StatusBar.Panels[5].Progress.Position :=0;
    Main.StatusBar.Panels[5].Progress.Max:=100;
    Main.StatusBar.Panels[5].Width := 100;
    Main.StatusBar.Panels.Add;
    Main.StatusBar.Panels[1].MinWidth := 80;
    Main.StatusBar.Panels[1].Width := 80;
    Main.StatusBar.Panels[3].MinWidth := 80;
    Main.StatusBar.Panels[3].Width := 80;
    Main.StatusBar.Panels[4].MinWidth := 100;
    Main.StatusBar.Panels[4].Width := 200;
    if bYelow then
      Main.StatusBar.Panels[6].Style := AdvOfficeStatusBar.psOwnerDraw
    else
      Main.StatusBar.Panels[6].Style := psHTML;
    Main.StatusBar.Panels[6].MinWidth := 300;
    Main.StatusBar.Panels[6].Width := 300;
  end;
end;

procedure TMain.ResetFilter;
begin
  Data.Auto_type := 0;
  Main.AutoPanel.Hide;
  Data.sAuto:='';
  Main.FiltEd.Text := '';
//  Main.NewCheckBox.Checked := FALSE;
//  Main.UsaCheckBox.Checked := FALSE;
  Main.WithQuants.Checked := FALSE;
  Main.WithLatestQuants.Checked := FALSE;
  Main.UpdateFilterColumnsChecked;
  if (Data.Group <> 0) or (Data.Subgroup <> 0) or (Data.fBrand <> 0) then
  begin
    Data.Group := 0;
    Data.Subgroup := 0;
    Data.fBrand := 0;
    Main.SelectInTree;
  end;
  Data.SetCatFilter;
end;

procedure TMain.RestartProg(var Msg: TMessage);

  procedure LogUpdateError(const aError: string; aClearLog: Boolean = False);
  var
    aLogFile: TextFile;
  begin
  {$I-} //отключаем I/O exceptions
    AssignFile(aLogFile, GetAppDir + cUpdateErrorsLogFile);
    if aClearLog or not FileExists(GetAppDir + cUpdateErrorsLogFile) then
      Rewrite(aLogFile)
    else
      Append(aLogFile);
    Writeln(aLogFile, aError);
    CloseFile(aLogFile);
  {$I+}
  end;


var
  FileBat: TextFile;
  si: TStartUpInfo;
  pi: TProcessInformation;
  aNewExe, aCurExe, aBkExe: string;
begin
  TimerUpdate.Enabled := FALSE;
  CloseStatusColums;

  //FileExists(Data.Import_Path + 'shatemplus.exe_new')
  aNewExe := Main.NewProgFile;
  aCurExe := GetAppDir + ExtractFileName(Application.ExeName);
  aBkExe  := aCurExe + '_old';

  //new -----------------------
  if FileExists(aNewExe) then
  begin
    DeleteFile(aBkExe);
    if RenameFile(aCurExe, aBkExe) then
    begin
      if CopyFile(PChar(aNewExe), PChar(aCurExe), True) then
      begin
        if not Data.VersionTable.Active then
          Data.VersionTable.Open;
        Data.VersionTable.Edit;
        Data.VersionTable.FieldByName('ProgVersion').Value := Main.NewProgVersion;
        Data.VersionTable.Post;

        MessageDlg('Установлена новая версия программы. Для применения изменений, программа будет перезапущена!'#13#10'После перезапуска, пожалуйста, выполните обновление данных.',mtInformation, [mbOK],0);

        AssignFile(FileBat, GetAppDir + 'start.bat');
        Rewrite(FileBat);
        Writeln(FileBat, WinToDos('"' + aCurExe + '" -newversion=' + IntToStr(GetCurrentProcessId)));
        CloseFile(FileBat);

        SetImageByLight(INDEX_OF_PROG, True);

        ZeroMemory(@si, SizeOf(si));
        ZeroMemory(@pi, SizeOf(pi));
        with si do
        begin
          cb := SizeOf(si);
          dwFlags := STARTF_USESHOWWINDOW;
          wShowWindow := SW_HIDE;
          hStdInput := 0;
        end;
        CreateProcess(nil, PChar(GetAppDir + 'start.bat'), nil, nil, FALSE, CREATE_NEW_CONSOLE, nil, PChar(GetAppDir), si, pi);
        Main.Close;
        Exit;
      end
      else
      begin
        Application.MessageBox(
          PChar(
          'Ошибка при установке новой версии: невозможно скопировать файл из "' + aNewExe + '" в "' + aCurExe + '"'#13#10 +
          'Пожалуйста, свяжитесь со службой технической поддержки компании Шате-М+'),
          'Ошибка',
          MB_OK or MB_ICONERROR
        );
        LogUpdateError('Ошибка при установке новой версии: невозможно скопировать файл из "' + aNewExe + '" в "' + aCurExe + '": ' + SysErrorMessage(GetLastError));
      end;
    end
    else
    begin
      Application.MessageBox(
        PChar(
        'Ошибка при установке новой версии: невозможно переименовать файл "' + aCurExe + '" -> "' + aBkExe + '"'#13#10 +
        'Пожалуйста, свяжитесь со службой технической поддержки компании Шате-М+'),
        'Ошибка',
        MB_OK or MB_ICONERROR
      );
      LogUpdateError('Ошибка при установке новой версии: невозможно переименовать файл "' + aCurExe + '" -> "' + aBkExe + '"' + SysErrorMessage(GetLastError));
    end;
  end
  else
    Application.MessageBox(
      PChar(
      'Ошибка при установке новой версии: не найден скачанный файл "' + aNewExe + '"'#13#10 +
      'Возможно, загрузку заблокировало ваше антивирусное программное обеспечение.'#13#10 +
      'Пожалуйста, свяжитесь со службой технической поддержки компании Шате-М+'),
      'Ошибка',
      MB_OK or MB_ICONERROR
    );
  Exit;
  //---------------------------

  MessageDlg('Программа будет перезапущена! После перезапуска пожалуйста выполните обновление данных.',mtInformation, [mbOK],0);
  AssignFile(FileBat, GetAppDir + '\start.bat');
  Rewrite(FileBat);
  Writeln(FileBat,WinToDos(':go'));
  Writeln(FileBat,WinToDos('del "' + GetAppDir + 'shatemplus.exe"'));
  Writeln(FileBat,WinToDos('if exist "' + GetAppDir + 'ShateMplus.exe" goto go'));
  Writeln(FileBat,WinToDos('copy "'+Data.Import_Path+'shatemplus.exe_new" "' + GetAppDir + 'ShateMplus.exe"'));
  Writeln(FileBat,WinToDos('del "'+Data.Import_Path+'shatemplus.exe_new"'));
  Writeln(FileBat,WinToDos('"' + GetAppDir + 'ShateMplus.exe"'));
  CloseFile(FileBat);

  ZeroMemory(@si, SizeOf(si));
  ZeroMemory(@pi, SizeOf(pi));

  with si do
  begin
    cb := SizeOf(si);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_HIDE;
    hStdInput := 0;
  end;
  CreateProcess(nil,PChar(GetAppDir + 'start.bat'), nil, nil, FALSE, CREATE_NEW_CONSOLE, nil, PChar(GetAppDir), si, pi);
  Main.Close;
end;


procedure TMain.ReturnDocDetGridCellClick(Column: TColumnEh);
var
  aIndex, DelIndex: Integer;
begin
  if SameText(Column.Field.Name, 'ReturnDocDetTableCheckField') then
  begin
    with Data.ReturnDocDetTable do
    begin
      aIndex := Data.ReturnMasChek.IndexOf(Pointer(FieldByName('id').AsInteger));
      if aIndex = -1 then
        Data.ReturnMasChek.Add(Pointer(FieldByName('id').AsInteger))
      else
      begin
        DelIndex := Data.ReturnMasChek.IndexOf(Pointer(FieldByName('id').AsInteger));
        Data.ReturnMasChek.Delete(DelIndex);
      end;
      Refresh;
    end;
  end;
end;


procedure TMain.ReturnDocDetGridDblClick(Sender: TObject);
begin
  EditReturnDocPos.Execute;
end;

procedure TMain.ReturnDocDetGridDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if Source <> MainGrid then
    exit;
  AddReturnPosAction.Execute;
end;

procedure TMain.ReturnDocDetGridDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source = MainGrid then
    Accept := True;
end;

procedure TMain.ReturnDocDetGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    EditReturnDocPos.Execute
  else if Key = VK_DELETE then
    DeleteFromReturnDoc.Execute
  else if Key = VK_SPACE then
    MoveToReturnDocPos.Execute;
end;

procedure TMain.ReturnDocDetGridMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  aCell: TGridCoord;
begin
  if (ssLeft in Shift) then
  begin
    aCell := ReturnDocDetGrid.MouseCoord(X, Y);
    if (aCell.X >= 0) and (aCell.Y > 0) then
      ReturnDocDetGrid.BeginDrag(False, 10);
  end
end;

procedure TMain.ReturnDocDetGridStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  Cursor := crDrag;
end;

procedure TMain.ReturnDocDetGridTitleClick(Column: TColumnEh);
begin
  if Column.Index = 0 then
  begin
    Data.ReturnMasChek.Clear;
    if ReturnDocDetGrid.Columns.Items[0].Title.ImageIndex = 2 then
    begin
      ReturnDocDetGrid.Columns.Items[0].Title.ImageIndex := 3;
      Data.ReturnDocDetTable.First;
      while not Data.ReturnDocDetTable.Eof  do
      begin
        Data.ReturnMasChek.Add(Pointer(Data.ReturnDocDetTable.FieldByName('id').AsInteger));
        Data.ReturnDocDetTable.Next;
      end;
    end
    else
      ReturnDocDetGrid.Columns.Items[0].Title.ImageIndex := 2;
  end;
  Data.ReturnDocDetTable.Refresh;
end;

procedure TMain.ReturnDocGridDblClick(Sender: TObject);
begin
   EditReturnDocAction.Execute;
end;

procedure TMain.ReturnDocGridDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  i:integer;
  fExit : boolean;
  gc: TGridCoord;
  rn1, rn2: integer;
  new_ord_id: integer;
  new_ord_info: string;
  old_ord_info: string;
begin
fExit := false;
  if Data.ReturnDocTable.FieldByName('Post').AsString <> '' then
    if (Data.ReturnDocTable.FieldByName('Post').AsString <> '0')and(Data.ReturnDocTable.FieldByName('Post').AsString <> '3') then
    begin
      MessageDlg('Невозможно выполнить действие!!!'+
                   ' Заказ уже был отправлен в офис компании и вероятно уже обработан.',  mtInformation, [mbOK], 0);

      Main.ReturnDocDetGrid.Columns.Items[0].Title.ImageIndex := 2;
      Data.ReturnMasChek.Clear;
     // ClearSelection;
      Data.ReturnDocTable.Resync([rmCenter]);
      exit;
    end;

  fClearSelection := false;
  if Source = ReturnDocDetGrid then
  begin
    gc := ReturnDocGrid.MouseCoord(X, Y);
    if (gc.Y = ReturnDocGrid.Row) or (gc.Y = 0) or (gc.Y = -1) then
      Exit;
    old_ord_info := Data.ReturnDocTable.FieldByName('Data').AsString + '/' +
                    Data.ReturnDocTable.FieldByName('num').AsString;
    rn2  := Data.ReturnDocDetTable.RecNo;
    rn1  := Data.ReturnDocTable.RecNo;
    try
      Data.ReturnDocTable.RecNo := ReturnDocGrid.DataRowToRecNo(gc.Y - 1);

      if (Data.ReturnDocTable.FieldByName('Post').AsString <> '') then
        if (Data.ReturnDocTable.FieldByName('Post').AsString <> '0')and(Data.ReturnDocTable.FieldByName('Post').AsString <> '3') then
        begin
          fExit := true;
          Main.ReturnDocDetGrid.Columns.Items[0].Title.ImageIndex := 2;
          Data.ReturnMasChek.Clear;
          //ClearSelection;
          exit;
        end;

      new_ord_id   := Data.ReturnDocTable.FieldByName('RetDoc_id').AsInteger;
      new_ord_info := Data.ReturnDocTable.FieldByName('Data').AsString + '/' +
                      Data.ReturnDocTable.FieldByName('num').AsString;



    finally
        Data.ReturnDocTable.RecNo := rn1;
        Data.ReturnDocDetTable.RecNo := rn2;
    if fExit then
        MessageDlg('Невозможно выполнить действие!!!'+
                 ' Заказ уже был отправлен в офис компании и вероятно уже обработан.',  mtInformation, [mbOK], 0);

    end;
    fOrderMasCheck := false;
    with TQuantityMoveEdit.Create(Application) do
    try
      if Data.ReturnMasChek.Count = 0 then
        Data.ReturnMasChek.Add(Pointer(rn2));
      for i := 0 to Data.ReturnMasChek.Count - 1 do
      begin
        data.ReturnDocDetTable.Locate('ID', Integer(data.ReturnMasChek.Items[i]), []);
        ReturnDocMemoryTable.Append;
        ReturnDocMemoryTable.FieldByName('ID').AsInteger := Data.ReturnDocDetTable.FieldByName('ID').AsInteger;
        ReturnDocMemoryTable.FieldByName('Code2').AsString := Data.ReturnDocDetTable.FieldByName('Code2').AsString;
        ReturnDocMemoryTable.FieldByName('Brand').AsString := Data.ReturnDocDetTable.FieldByName('Brand').AsString;
        ReturnDocMemoryTable.FieldByName('pos_info').AsString := Data.ReturnDocDetTable.FieldByName('Code').AsString;
        ReturnDocMemoryTable.FieldByName('ordered').AsInteger:= Data.ReturnDocDetTable.FieldByName('ordered').AsInteger;
        ReturnDocMemoryTable.FieldByName('kol').AsFloat:= Data.ReturnDocDetTable.FieldByName('Quantity').AsFloat;
        ReturnDocMemoryTable.FieldByName('kolMax').AsFloat:= Data.ReturnDocDetTable.FieldByName('Quantity').AsFloat;
        ReturnDocMemoryTable.post;
      end;
      OrderInfo1.Text := Old_ord_info;
      OrderInfo2.Text := New_ord_info;
 //------------------------
      if ShowModal = mrOk then
      begin
        ReturnDocMemoryTable.First;
        while not ReturnDocMemoryTable.Eof  do
        begin
          data.ReturnDocDetTable.Locate('ID', ReturnDocMemoryTable.FieldByName('ID').AsInteger, []);
          if ReturnDocMemoryTable.FieldByName('kol').AsFloat =  data.ReturnDocDetTable.FieldByName('Quantity').AsFloat then
          begin
            Data.ReturnDocDetTable.Edit;
            Data.ReturnDocDetTable.FieldByName('RetDoc_id').Value := new_ord_id;
            Data.ReturnDocDetTable.Post;
          end
          else
          begin
            Data.ReturnDocDetTable.Edit;
            Data.ReturnDocDetTable.FieldByName('Quantity').Value := Data.ReturnDocDetTable.FieldByName('Quantity').Value - ReturnDocMemoryTable.FieldByName('kol').AsFloat;
            Data.ReturnDocDetTable.Append;
            Data.ReturnDocDetTable.FieldByName('RetDoc_id').Value := new_ord_id;
            Data.ReturnDocDetTable.FieldByName('Code2').Value    := ReturnDocMemoryTable.FieldByName('code2').AsString;
            Data.ReturnDocDetTable.FieldByName('Brand').Value    := ReturnDocMemoryTable.FieldByName('brand').AsString;
            Data.ReturnDocDetTable.FieldByName('Quantity').Value := ReturnDocMemoryTable.FieldByName('kol').AsString;
            Data.ReturnDocDetTable.FieldByName('ordered').Value  := ReturnDocMemoryTable.FieldByName('ordered').AsInteger;
            //CalcProfitPriceForOrdetDetCurrent;
            Data.ReturnDocDetTable.Post;
          end;
          ReturnDocMemoryTable.Next;
        end;
      end;
       fClearSelection := true;
       Main.ReturnDocDetGrid.Columns.Items[0].Title.ImageIndex := 2;
       Data.ReturnMasChek.Clear;
       Data.ReturnDocDetTable.Resync([rmCenter]);
      {with Data.OrderTable do
      begin
        Data.OrderTable.Edit;
        Data.OrderTable.FieldByName('Dirty').Value := True;
        Data.OrderTable.Post;
        Data.OrderTable.Refresh;
      end;
      Data.OrderTableAfterScroll(Data.OrderTable); }

    finally
      Free;
    end
  end
  else if Source = MainGrid then
  begin
    gc := OrderGrid.MouseCoord(X, Y);
    if (gc.Y = ReturnDocGrid.Row) or (gc.Y = 0) or (gc.Y = -1) then
      exit;
    Data.ReturnDocTable.RecNo := ReturnDocGrid.DataRowToRecNo(gc.Y - 1);
    AddReturnPosAction.Execute;;
  end;

end;


procedure TMain.ReturnDocGridDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if (Source = ReturnDocDetGrid) or (Source = MainGrid) then
    Accept := True;
end;

procedure TMain.ReturnDocGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Key = VK_RETURN then
    begin
    EditReturnDocAction.Execute;
    end
  else if Key = VK_DELETE then
    DelReturnDocAction.Execute;
end;

procedure TMain.ReturnInfoExecute(Sender: TObject);
begin
//  if not isOpenedMoreThan2Windows('Info') then
    with TInfo.Create(Application) do
    begin
      Caption := 'Информация';
      Browser.Navigate(GetAppDir + 'Return.html');
      ShowModal;
      Free;
    end;
end;

procedure TMain.AddReturnPosActionExecute(Sender: TObject);
var
  bNew: Boolean;
  UserData, UserDataOrder: TUserIDRecord;
  aSavedOrderID, RetDocRecordCount, retDocIdOld: Integer;
  QueryCntRetDocDefect: TDBISAMQuery;
begin
    //ReturnPosAction
  bNew := FALSE;
  if not CheckClientId then
    Exit;
  UserData := GetCurrentUser;

  if Data.ReturnDocTable.FieldByName('RetDoc_ID').AsInteger < 1 then
  begin
      if not NewReturnDoc then
        exit;
      bNew := TRUE;
  end;

  if (Data.ReturnDocTable.FieldByName('Post').AsString <> '')and(Data.ReturnDocTable.FieldByName('Post').AsString <> '0') then
  begin
     if MessageDlg('Добавление в выбранный возврат невозможно !!! Возврат уже был отправлен в офис компании и вероятно уже обработан. Создать новый?',mtInformation ,[mbYes,mbNo], 0) = mrNo  then
         exit;
      if not NewReturnDoc then
        exit;
      bNew := TRUE;
  end;

  if Data.CatalogDataSource.DataSet.FieldByName('Title').AsBoolean or
     (Data.CatalogDataSource.DataSet.FieldByName('Cat_id').AsInteger = 0)  then
    Exit;

  QueryCntRetDocDefect := TDBISAMQuery.Create(nil);
  try
    QueryCntRetDocDefect.DatabaseName := Main.GetCurrentBD;
    QueryCntRetDocDefect.SQL.Text := ' select * from [036] ' +
                                     ' inner join [037] on ([036].RetDoc_ID = [037].RetDoc_ID) ' +
                                     ' where data >= :dateBeg and  data <= :dateEnd and [037].RetDoc_ID = :RetDoc_Id' ;
    QueryCntRetDocDefect.ParamByName('dateBeg').AsDateTime := DateStartReturnDoc.Date;
    QueryCntRetDocDefect.ParamByName('dateEnd').AsDateTime := DateEndReturnDoc.Date;
    QueryCntRetDocDefect.ParamByName('RetDoc_ID').AsInteger := Data.ReturnDocTable.FieldByName('RetDoc_ID').AsInteger;
    QueryCntRetDocDefect.Prepare;
    QueryCntRetDocDefect.Active := True;
    RetDocRecordCount := QueryCntRetDocDefect.RecordCount;
  finally
    QueryCntRetDocDefect.Free;
  end;

  if (RetDocRecordCount >= 1) and Data.ReturnDocTable.FieldByName('fDefect').AsBoolean then
  begin
   retDocIdOld := Data.ReturnDocTable.FieldByName('RetDoc_ID').AsInteger;
   if MessageDlg('Документ возврата по браку может содержать только одну позицию, добавить эту позицию в новый документ?',
               mtWarning, [mbYes,mbNo ], 0) <> mrYes then
     exit
   else
     NewFailAction.Execute;
   if Data.ReturnDocTable.FieldByName('RetDoc_ID').AsInteger = retDocIdOld then
     exit;
  end;

  if Data.ReturnDocTable.FieldByName('cli_id').AsString <> UserData.sID then
  begin
    if Data.ParamTable.FieldByName('AutoSwitchCurClient').AsBoolean or
       (Application.MessageBox('Идентификатор клиента в возврате отличается от текущего.'#13#10 +
                              'Установить текущим идентификатор из возврата?', 'Предупреждение', MB_YESNO or MB_ICONWARNING) = IDYES) then
    begin
      UserDataOrder := GetUserDataByID(Data.ReturnDocTable.FieldByName('cli_id').AsString);
      if not Assigned(UserDataOrder) then
      begin
        Application.MessageBox('Идентификатор клиента указанный в возврате не найден!', 'Ошибка', MB_OK or MB_ICONERROR);
        Exit;
      end;
      aSavedOrderID := Data.ReturnDocTable.FieldByName('RetDoc_ID').AsInteger;
      try
        Data.SetDefaultClient(UserDataOrder.sID);
        CliComboBox.KeyValue := UserDataOrder.sID;
        SetActiveCli(UserDataOrder);
        Application.ProcessMessages;
      finally
        Data.ReturnDocTable.Locate('RetDoc_ID', aSavedOrderID, []);
      end;
    end
    else
      Exit;
  end;

  with TReturnDocPos.Create(Application) do
  begin
     if not bNew then
     begin
       with Data.ReturnDocDetTable do
          begin
            if Locate('RetDoc_ID;Code2;Brand',
                VarArrayOf([Data.ReturnDocTable.FieldByName('RetDoc_ID').AsInteger,
                      Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString,
                      Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString]), []) then
          if Data.ParamTable.FieldByName('ShowMessageAddOrder').AsBoolean then
          if MessageDlg('Внимание, такая позиция уже добавлена. Продолжить?',mtInformation, [MBYES, MBNO],0) = mrNo then
          exit;
          end;
      end;

       Caption := 'Количество товара в возврате';
      ArtInfo.Text := Data.CatalogDataSource.DataSet.FieldByName('Code').Asstring + '  ' +
                    Data.CatalogDataSource.DataSet.FieldByName('Name_Descr').Asstring;

    QuantityEd.Value := 1;
    if ShowModal = mrOk then
    begin
      with Data.ReturnDocDetTable do
      begin
        if not Locate('RetDoc_ID;Code2;Brand',
          VarArrayOf([Data.ReturnDocTable.FieldByName('RetDoc_ID').AsInteger,
                      Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString,
                      Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString]), []) then
        begin
          Append;
         FieldByName('RetDoc_ID').Value :=
             Data.ReturnDocTable.FieldByName('RetDoc_ID').AsInteger;
          FieldByName('Code2').Value :=
             Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString;
          FieldByName('Brand').Value :=
             Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString;
        end
        else
              Edit;
                FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat +
                                           QuantityEd.Value;
        FieldByName('Note').Value := InfoEd.Text;
        Post;

      end;

    end;
    Free;
  end;
end;

procedure TMain.FormCreate(Sender: TObject);

  function Wait(aHandle: Cardinal; aWaitTime: Cardinal): Boolean;
  var
    t: Cardinal;
  begin
    Result := False;

    t := GetTickCount;
    while WaitForSingleObject(aHandle, 200) = WAIT_TIMEOUT do
    begin
      if (GetTickCount - t) > aWaitTime then
        Exit;
      Application.ProcessMessages;
    end;

    Result := True;
  end;

  function KillProcess(const AProcessID: DWord; aWaitTime: Cardinal): Boolean;
  var
    lPID, lCurrentProcPID: DWord;
    lProcHandle: DWord;
  begin
    Result := False;
    try
      lCurrentProcPID := GetCurrentProcessId;
      lPID := AProcessID;
      if (lPID <> INVALID_HANDLE_VALUE) and (lCurrentProcPID <> lPID) then
      begin
        lProcHandle := OpenProcess(PROCESS_TERMINATE or SYNCHRONIZE, False, lPID);
        try
          if lProcHandle = 0 then //или нет прав или завершился
            Exit;

          if aWaitTime > 0 then
          begin
            Result := Wait(lProcHandle, aWaitTime);
            if Result then
              Exit; //сам завершился
          end;

          Windows.TerminateProcess(lProcHandle, 0);
          WaitForSingleObject(lProcHandle, Infinite);
          Result := True;
        finally
          CloseHandle(lProcHandle);
        end;
      end;
    except
      raise EExternalException.Create(SysErrorMessage(GetLastError));
    end;
  end;

var
  FileBat:TextFile;
  sFileName:string;
  sGr, sSub:string;
  iniFile :TIniFile;
  aNewBarFound: Boolean;
  aNewTireBarFound: Boolean;
  ini : TIniFile;
  aSwitch: string;
  aPID: Integer;
begin
  SetImageByLight(INDEX_OF_PROG, False);
  SetImageByLight(INDEX_OF_QUANTS, False);
  SetImageByLight(INDEX_OF_RATES, False);
  SetImageByLight(INDEX_OF_DATA, False);
  //-NewVersion=<PID>
  fClickedBtnUpdate := False;
  fMainCLose := False;
  fLocalMode := False;
  CheckUpdateDir := 1;
  DeleteFile(GetAppDir + '!!!.err'); 
  ClientList := TList.Create;
  OrderGrid.Columns.Items[0].Title.ImageIndex:=1;
  OrderDetGrid.Columns.Items[0].Title.ImageIndex:=2;
  if FindCmdLineSwitchEx('NewVersion=', ['-','/'], True, True, aSwitch) then
  begin
    aPID := StrToIntDef( Copy(aSwitch, Length('NewVersion=') + 1, MaxInt), 0 );
    Splash.InfoLabel.Caption := 'Перезапуск...';
    Splash.Update;
    KillProcess(aPID, 1000 * 10{подождем 10 сек});
  end;
  fLogLock := TCriticalSection.Create;
  fDebugRun := FindCmdLineSwitch('DebugRun');

  RedrawTitleImageList;

  bTerminate := TRUE;
  lResetIni := False;

  fUpdateQueue := TUpdateQueue.Create;

  FiltModified := False;
  AdminPasswEntered := False;
  Wait_Flash_flag := False;
  TestForAdminMode;
  StartFlag := False;
  Application.HelpFile := ChangeFileExt(Application.ExeName, '.hlp');
  EditFormMode         := efmDos; // переход между полями по Enter
  SetDateFormat;                  // dd.mm.yyyy, русские имена месяцев


  //старт БД
  Data := TData.Create(Application);
  if FindCmdLineSwitchEx('NewVersion=', ['-','/'], True, True, aSwitch) then
  begin
    if Data.fTecdocOldest then
      Application.MessageBox(
        'Вышла сервисная программа на базе текдок 2015.1.'#13#10 +
        'Ваша версия устарела. Дальнейшее обновление данных каталога будет недоступно.'#13#10 +
        'Для установки новой сборки необходимо заказать компакт диск c сервисной программой либо ' +
        ' загрузить с сайта shate-m.by, раздел "Сервисное ПО" ',
        'Внимание!',
        MB_OK or MB_ICONWARNING
      );
  end;
  
  fQueryUserMode := TDBISAMQuery.Create(nil);
  fQueryUserMode.DatabaseName := GetCurrentBD;//Data.User_Database.DatabaseName;
  QuantVersion := Data.VersionTable.FieldByName('QuantVersion').AsString;
  fRestProgAfterUpdate := FALSE;
  iniFile := TIniFile.Create(AppStorage.FullFileName);
  //ShowMessage(AppStorage.FullFileName);

  try
    CodeIgnoreSpecialSymbolsCheckBox.Checked := iniFile.ReadBool('Checked','CodeIgnoreSpecialSymbolsCheckBox',FALSE);
    IgnoreSpecialSymbolsCheckBox.Checked := TRUE;
    IgnoreSpecialSymbolsCheckBox.visible := FALSE;
    //iniFile.ReadBool('Checked','IgnoreSpecialSymbolsCheckBox',FALSE);

    //флаг что нужно выровнять тулбары - только если они еще не сохранены
    fNeedAllignToolBars := not iniFile.SectionExists(MainDockPanel.Persistence.Section);
    aNewBarFound := not iniFile.ValueExists(MainDockPanel.Persistence.Section, 'UserID_ToolBar.Row');
    aNewTireBarFound := not iniFile.ValueExists(MainDockPanel.Persistence.Section, 'TireToolBar.Row');
  finally
    iniFile.Free;
  end;

  MainDockPanel.Persistence.Key := AppStorage.FullFileName;
  MainDockPanel.LoadToolBarsPosition;
  if aNewBarFound then
  begin
    UserID_ToolBar.Top := 30;
    UserID_ToolBar.Left := UserID_ToolBar.Parent.ClientWidth - UserID_ToolBar.Width;
    //FiltToolBar.Left + FiltToolBar.Width
  end;
  if aNewTireBarFound then
  begin
    TireToolBar.Top := 30;
    TireToolBar.Left := TireToolBar.Parent.ClientWidth - TireToolBar.Width;
    //FiltToolBar.Left + FiltToolBar.Width
  end;
  LoadToolBarsMenu;

  GetMirrorsList;
  OrderDateEd1.Date := Now-Data.ParamTable.FieldByName('SetDateRate').AsInteger;
  OrderDateEd2.Date := Now;
  LoadUserID;
  DateStartReturnDoc.Date:= Now;
  DateEndReturnDoc.Date:= Now;
  Data.ReturnDocTable.SetRange([DateStartReturnDoc.Date], [DateEndReturnDoc.Date]);
  Data.sAuto:='';

  WSysLog('Восстановление настроек пользователя');

  MainGrid.RestoreGridLayoutIni(AppStorage.FullFileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  AnalogGrid.RestoreGridLayoutIni(AppStorage.FullFileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  OrderGrid.RestoreGridLayoutIni(AppStorage.FullFileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  OrderDetGrid.RestoreGridLayoutIni(AppStorage.FullFileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  PrimGrid.RestoreGridLayoutIni(AppStorage.FullFileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  ParamGrid.RestoreGridLayoutIni(AppStorage.FullFileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  ReturnDocGrid.RestoreGridLayoutIni(AppStorage.FullFileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  ReturnDocDetGrid.RestoreGridLayoutIni(AppStorage.FullFileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);

  WaitListGrid.RestoreGridLayoutIni(AppStorage.FullFileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  KitGridEh.RestoreGridLayoutIni(AppStorage.FullFileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  AssortmentExpansionGridEh.RestoreGridLayoutIni(AppStorage.FullFileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  KKGridEh.RestoreGridLayoutIni(AppStorage.FullFileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);

  SyncParGrid(ParamGrid);
  FormStorage.RestoreFormPlacement;

  SetStyle;
  SearchMode := False;
  AssortmentExpansionPage.Visible := TRUE;
  AssortmentExpansionPage.TabVisible := TRUE;
  if AdminMode then
  begin
    Caption := Caption + '     Режим администратора';
    if not Data.Tecdoc_enabled then
      Caption := Caption + '     Tecdoc недоступен';
  end;

  {$IFDEF TEST}
  Caption := Caption + '     Внимание! тестовая версия';
  {$ENDIF}

  {$IFDEF NAVTEST}  
  Caption := Caption + '     Внимание! тестовая версия';
  {$ENDIF}

  {$IFDEF PODOLSK}
  Caption := Caption + '     Склад Подольск (РФ)';
  {$ENDIF}

  Data.CatDetTable.MasterFields := '';
  Data.CatDetTable.MasterSource := nil;
  DetailsEnabled := not (Data.CatDetTable.IsEmpty);
  Data.CatDetTable.MasterFields := 'param_tdid';
  Data.CatDetTable.MasterSource := Data.CatalogDataSource;

  DetailsPage.TabVisible := DetailsEnabled;
  DetailsPage.Visible    := DetailsEnabled;
  if Data.ParamTable.FieldByName('bUnionDetailAnalog').AsBoolean and DetailsEnabled then
  begin
    if AnalogPage = pnAnalog.Parent then
    begin
      if Pager.ActivePage = AnalogPage then
        Pager.ActivePage := DetailsPage;

      PanelDetails.Align := alBottom;
      PanelDetails.Height := DetailsPage.Height div 2;
      AdvSplitter6.Visible := TRUE;
      AdvSplitter6.Align := alTop;
      AdvSplitter6.Align := alBottom;

      pnAnalog.Parent := DetailsPage;
      pnAnalog.Align  := alClient;

      AnalogPage.Visible := FALSE;
      AnalogPage.TabVisible := FALSE;
    end;
  end
  else
  begin
     AnalogPage.Visible := TRUE;
     AnalogPage.TabVisible := TRUE;
     AdvSplitter6.Visible := FALSE;
     PanelDetails.Align := alClient;
     pnAnalog.Parent := AnalogPage;
     pnAnalog.Align   := alClient;
  end;

  //AutoAction.Visible     := not Data.PictTable.IsEmpty;

 AutoAction.Visible := TRUE;
 AutoToolBarButton.Visible := TRUE;
 AutoToolBar.AutoSize := True;

{  if not AutoAction.Visible then
    AutoToolBar.Visible       := False
  else
  begin
    AutoToolBarButton.Visible := AutoAction.Visible;
    AutoToolBar.AutoSize := False;
    AutoToolBar.AutoSize := True;
  end;}

  RecalcProgrammPeriod;

  WSysLog('Возраст БД: ' + IntToStr(Prog_period) + ' дн.');
  //DiConnect
  if FileExists(GetAppDir + 'PriceList.dll') then
    CreateFilePrice.Visible := TRUE;
    sFileName := GetAppDir + 'RunningLine';
  JvScrollText.Font.Color := Data.ParamTable.FieldByName('ColorRunString').AsInteger;
  if FileExists(sFileName) then
  begin
      JvScrollText.Items.Clear;
      AssignFile(FileBat,sFileName);
      Reset(FileBat);
      sSub := '';
      while not EOF(FileBat) do
      begin
        Readln(FileBat, sGr);
        JvScrollText.Items.Add(sGr);
//        sSub := sSub+#9+sGr;
      end;

      CloseFile(FileBat);
      if Data.ParamTable.FieldByName('bVisibleRunningLine').AsBoolean then
        begin
         RunLinePanel.Visible:= TRUE;
         JvScrollText.Visible := TRUE;
         JvScrollText.Active := False;
        end
      else
        begin
        JvScrollText.Active := FALSE;
        JvScrollText.Visible := FALSE;
        RunLinePanel.Visible:= FALSE;
        end;
        JvScrollText.Visible := TRUE;
        JvScrollText.Active := TRUE;

  end;

  HideTree.Checked := Data.ParamTable.FieldByName('HideTree').AsBoolean;
//  TreePanel.Visible := not Data.ParamTable.FieldByName('HideTree').AsBoolean;
  HideBrandGroup.Checked := Data.ParamTable.FieldByName('HideBrand').AsBoolean;
  HideName.Checked := Data.ParamTable.FieldByName('HideName').AsBoolean;
  HideOE.Checked := Data.ParamTable.FieldByName('HideOE').AsBoolean;
  cbFilterAnalogs.Checked := Data.ParamTable.FieldByName('AnalogFilterEnabled').AsBoolean;
  UpdateToolBarsMenuChecked;
  ViewNameLoad;
  SetViewColumn;

  fNotePadForm := TNotePadForm.Create(Self);
  fNotePadForm.Parent := ToolPanelNotepad;
  fNotePadForm.Align := alClient;

  //увеличиваем ширину выпадающего списка Combobox
  CliComboBox.DropDownBox.Width := 300; //PostMessage(CliComboBox.Handle, CB_SETDROPPEDWIDTH, 250, 0);
  
  fNotifyLog := TStringList.Create;
  InitNotifyEvents;

  fScheduler := TTaskScheduler.Create;
  CreateScheduledTasks;

  acUpdateAllClients.Visible := False;
  acUpdateAllDiscounts.Visible := False;
  UniversalExport.Visible := False;
  CatalogExport.Visible := False;
  btExport.Visible := False;
  btExportCat.Visible := False;
  GetDirectory.Visible := True;
  {$IFDEF LOCAL}
  UniversalExport.Visible := True;
  CatalogExport.Visible := True;
  btExport.Visible := True;
  GetDirectory.Visible := False;
  btExportCat.Visible := True;
  if fLocalMode then
  begin
    Caption := Caption + ' (локальная версия)- Режим сохранения данных пользователя ';
    ini := TIniFile.Create(Data.GetDomainName + '\' + cLocalVerIniFile)
  end
  else
  begin
    Caption := Caption + ' (локальная версия)';
    ini := TIniFile.Create(GetAppDir + cLocalVerIniFile)
  end;

  try
    acUpdateAllClients.Visible := True;
    acUpdateAllDiscounts.Visible := True;
    fAutoLoadDiscounts := ini.ReadBool('UPDATE', 'AutoLoadDiscounts', True);
    fAutoLoadClients := ini.ReadBool('UPDATE', 'AutoLoadClients', True);
  finally
    ini.Free;
  end;

  if fAutoLoadClients then
    doUpdateAllClients(True);

  OrderFlame(False);
  lbOrderFlame.Visible := False;
  OrderWarnTimer.Enabled := False;
  {$ENDIF}

  fECatList := TStringList.Create;
  FillECatList;

  if Assigned(Splash) then
    Splash.SplashOff;

  fClientIdErrNotRenamed := '';
  fForceCallMarginAction := True;
  acShowOrdersInPofitPricesExecute(nil);
end;


procedure TMain.FormDestroy(Sender: TObject);
var
  iniFile: TIniFile;
  i: Integer;
  UserID: TUserIDRecord;
begin
  i := 0;
  fQueryUserMode.Free;

  fNotePadForm.Free;
  fUpdateQueue.Free;
  if Assigned(fUpdateMirrors) then
    fUpdateMirrors.Free;

  while i < ClientList.Count do
  begin
     UserID := ClientList[i];
     UserID.Free;
     inc(i);
  end;
  
  ClientList.Free;
  MainGrid.SaveGridLayoutIni(AppStorage.FullFileName, Name, False);
  AnalogGrid.SaveGridLayoutIni(AppStorage.FullFileName, Name, False);
  OrderGrid.SaveGridLayoutIni(AppStorage.FullFileName, Name, False);
  OrderDetGrid.SaveGridLayoutIni(AppStorage.FullFileName, Name, False);
  ReturnDocGrid.SaveGridLayoutIni(AppStorage.FullFileName, Name, False);
  ReturnDocDetGrid.SaveGridLayoutIni(AppStorage.FullFileName, Name, False);
  PrimGrid.SaveGridLayoutIni(AppStorage.FullFileName, Name, False);
  ParamGrid.SaveGridLayoutIni(AppStorage.FullFileName, Name, False);
  WaitListGrid.SaveGridLayoutIni(AppStorage.FullFileName, Name, False);
  KitGridEh.SaveGridLayoutIni(AppStorage.FullFileName, Name, False);
  AssortmentExpansionGridEh.SaveGridLayoutIni(AppStorage.FullFileName, Name, False);
  KKGridEh.SaveGridLayoutIni(AppStorage.FullFileName, Name, False);
  MainDockPanel.SaveToolBarsPosition;

  FormStorage.SaveFormPlacement;
  iniFile := TIniFile.Create(AppStorage.IniFile.FileName);
  try
    iniFile.WriteBool('Checked','CodeIgnoreSpecialSymbolsCheckBox',CodeIgnoreSpecialSymbolsCheckBox.Checked);
    iniFile.WriteBool('Checked','IgnoreSpecialSymbolsCheckBox',IgnoreSpecialSymbolsCheckBox.Checked);
    if fLocalMode then
    begin
      if NewQuantVersion = '' then
        NewQuantVersion := iniFile.ReadString('Quants', 'Version', '');
      iniFile.WriteString('Quants', 'Version', NewQuantVersion);
    end;
  finally
    iniFile.Free;
  //  DeleteFile('C:\Windows\ShateMPlus.ini');
  end;
  fScheduler.Free;
  fNotifyLog.Free;

  fECatList.Free;

  fLogLock.Free;

  if lResetIni then
    DeleteFile(AppStorage.IniFile.FileName);
end;


procedure TMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (ssAlt in Shift) and (ssShift in Shift) then
    if Key in [Ord('h'), Ord('H')] then
    begin
      RunTVSupport;
    end;
end;

function TMain.FormOpen(const FormName: string): Boolean;
var
   i: Integer;
begin
  Result := False;
  for i := Screen.FormCount - 1 DownTo 0 do
    if (Screen.Forms[i].Name = FormName) then
      begin
        Result := True;
        Break;
      end;
end;

procedure TMain.FormShow(Sender: TObject);
var
  aNewsFile: string;
begin
  {Скрыть комбик с появившемся наличием}
  WithLatestQuants.Visible := FALSE;
  Image7.Visible := FALSE;
        {*** LATEST ***}

  fClearSelection := true ;
  if RunLinePanel.Visible then
  begin
    JvScrollText.Width := JvScrollText.Width + 1;
    JvScrollText.Reset;
    JvScrollText.Active := TRUE;
  end;

  {$IFDEF TEST}
//  ShowMessage('Внимание! тестовая версия');
  {$ENDIF}
  AllignToolBars;

  case Data.Tree_mode of
    0:
    begin
      GroupsAction.Checked   := True;
      tbTree.Action := GroupsAction;
    end;
    1:
    begin
      BrandsAction.Checked   := True;
      tbTree.Action := BrandsAction;
    end;
    2:
    begin
      MyGroupsAction.Checked := True;
      tbTree.Action := MyGroupsAction;
    end;
    3:
    begin
      MyBrandsAction.Checked := True;
      tbTree.Action := MyBrandsAction;
    end;
  end;
  tbTree.OnClick := nil;
  AppStylerChange(AppStyler);
  UpdateCatalogCaption;

  ToolPanelTabLeft.RollOut(ToolPanelTree);
  ToolPanelTree.Locked := True;

  miGroupsAction.OnMeasureItem := miGroupsActionMeasureItem;


  CurrencyComboBox.ItemIndex := Data.Curr;
  Data.SetPriceKoef;
  //Скрытие выбора валюты
  CurrencyComboBox.Visible := False;
  {$IFDEF LOCAL}
    CurrencyComboBox.Visible := True;
  {$ENDIF}
  GetDirectory.Visible := True;
  
  MainParamSplashTimer.Enabled := Data.ParamTable.FieldByName('Show_mparam').AsBoolean;
  Data.OrderTable.AfterScroll := Data.OrderTableAfterScroll;
  Data.CatalogDataSource.DataSet.AfterScroll := Data.CatalogTableAfterScroll;

  if not Data.ParamTable.FieldByName('Hide_start_info').AsBoolean then
  begin
    aNewsFile := '';
    if FileExists(GetAppDir + 'RssNews.html') then
      aNewsFile := GetAppDir + 'RssNews.html'
    else
      if FileExists(GetAppDir + 'News.html') then
        aNewsFile := GetAppDir + 'News.html';

    if (aNewsFile <> '') then//and (not isOpenedMoreThan2Windows('Info')) then
      with TInfo.Create(Application) do
      try
        WSysLog('Показ новостей');
        Caption := 'Новости';
        Browser.Navigate(aNewsFile);
        HideCheckBox.Visible := True;
        ShowModal;
      finally
        Free;
      end;
  end;

  if FileExists(GetAppDir + 'About.html')and
  (not Data.ParamTable.FieldByName('Hide_NewInProg').AsBoolean) then//and (not isOpenedMoreThan2Windows('Info')) then
   with TInfo.Create(Application) do
    begin
      Caption := 'Новинки программы';
      Browser.Navigate(GetAppDir + 'About.html');
      HideNewInProg.Visible := True;
      HideCheckBox.Visible := False;
      ShowModal;
      Free;
    end;

  SetActionEnabled;
  ShowStatusBarInfo;
  Data.FiltTable.SetRange([FiltModeComboBox.ItemIndex],
                          [FiltModeComboBox.ItemIndex]);
  FiltEd.Clear;
  //FiltModeComboBox.Color := clWindow;
  FiltEd.Color := clWindow;
  WSysLog('Проверка листа ожидания');
  Data.CalcWaitList;
  Pager.ActivePageIndex :=  Data.ParamTable.FieldByName('Page').AsInteger;
  with OrderGrid do
  begin
    if Width < 250 then
    begin
      Constraints.MinWidth := 0;
      AutoFitColWidths := False;
      Columns[0].Width := 40;
      Columns[1].Width := 10;
      Columns[2].Width := 35;
      Columns[3].Width := 10;
      Columns[4].Width := 55;
      Columns[5].Width := 50;
      Columns[6].Width := 10;
      Width := 250;
      AutoFitColWidths := True;
      Constraints.MinWidth := 250;
    end;
  end;
  Data.LoadTimer.Enabled := True;
  PagerChange(Pager);
  WSysLog('Программа в работе.');
  ClearTestQuants;
  LoadAutoHist;

  SelectCurrentUser;
  SetCurrentDir(Data.Data_Path);
  // CheckProgrammPeriod
  VersionTimer.Enabled := True;
  //мигалка
  RotateTimer.Enabled := True;
  //диспетчер фоновых задач
  fScheduler.Enabled := True;
end;



procedure TMain.RefreshMemAnalogs;
var
  anAfterScrollEvent: TDataSetNotifyEvent;
  filterAn1, filterAn2, filterAn3, filterAn4, filterAn5: string;

  function CheckNeed4Update(filter: string): string;
  begin
    result := '';
    if length(filter) > 2 then
    begin
       Delete(filter,length(filter), 1);
       Result := ' gen_An_id in (' + filter + ')'
    end;
  end;

  procedure Add2MemTable(Table4Insert: TDBISAMTable; filter: string);
  var
    i: integer;
  begin
    if filter = '' then
      exit;
    Table4Insert.Filter := filter;
    Table4Insert.Filtered := TRUE;
    Table4Insert.DisableControls;
    Table4Insert.First;
    while not Table4Insert.Eof do
    begin
      Data.memAnalog.Append;
      for i := 0 to Data.memAnalog.FieldCount - 1 do
        if Table4Insert.FindField(Data.memAnalog.Fields[i].FieldName) <> nil then
          Data.memAnalog.Fields[i].Value := Table4Insert.FieldByName(Data.memAnalog.Fields[i].FieldName).Value;
      Data.memAnalog.FieldByName('QuantityCalc').AsInteger := StrInt(Data.memAnalog.FieldByName('Quantity').AsString);
      Data.memAnalog.Post;
      Table4Insert.Next;
    end;
    Table4Insert.EnableControls;
  end;

begin
  Data.AnalogIDTable.First;
  while not  Data.AnalogIDTable.Eof do
  begin
    if Data.AnalogIDTable.FieldByName('gen_An_id').AsInteger < Data.MaxGenAnID.MaxGenAnIdFromTable_1 then
      filterAn1 := filterAn1 + Data.AnalogIDTable.FieldByName('gen_An_id').AsString + ','
    else if Data.AnalogIDTable.FieldByName('gen_An_id').AsInteger < Data.MaxGenAnID.MaxGenAnIdFromTable_2 then
      filterAn2 := filterAn2 + Data.AnalogIDTable.FieldByName('gen_An_id').AsString + ','
    else if Data.AnalogIDTable.FieldByName('gen_An_id').AsInteger < Data.MaxGenAnID.MaxGenAnIdFromTable_3 then
      filterAn3 := filterAn3 + Data.AnalogIDTable.FieldByName('gen_An_id').AsString + ','
    else if Data.AnalogIDTable.FieldByName('gen_An_id').AsInteger < Data.MaxGenAnID.MaxGenAnIdFromTable_4 then
      filterAn4 := filterAn4 + Data.AnalogIDTable.FieldByName('gen_An_id').AsString + ','
    else if Data.AnalogIDTable.FieldByName('gen_An_id').AsInteger < Data.MaxGenAnID.MaxGenAnIdFromTable_5 then
      filterAn5 := filterAn5 + Data.AnalogIDTable.FieldByName('gen_An_id').AsString + ',';
    Data.AnalogIDTable.Next;
  end;

  if not Data.memAnalog.Exists then
    Data.memAnalog.CreateTable;
  Data.memAnalog.DisableControls;

  anAfterScrollEvent := Data.memAnalog.AfterScroll;
  Data.memAnalog.AfterScroll := nil;
  try
    Data.memAnalog.Close;
    Data.memAnalog.Filtered := False;
    Data.memAnalog.EmptyTable;
    Data.memAnalog.IndexName := 'QuantDesc';
    Data.memAnalog.Open;

    if length(filterAn1) > 2 then
      Add2MemTable(Data.AnalogMainTable_1, CheckNeed4Update(filterAn1));
    if length(filterAn2) > 2 then
      Add2MemTable(Data.AnalogMainTable_2, CheckNeed4Update(filterAn2));
    if length(filterAn3) > 2 then
      Add2MemTable(Data.AnalogMainTable_3, CheckNeed4Update(filterAn3));
    if length(filterAn4) > 2 then
      Add2MemTable(Data.AnalogMainTable_4, CheckNeed4Update(filterAn4));
    if length(filterAn5) > 2 then
      Add2MemTable(Data.AnalogMainTable_5, CheckNeed4Update(filterAn5));

    if Data.ParamTable.FieldByName('AnalogFilterEnabled').AsBoolean then
      Data.memAnalog.Filter := ' QuantityCalc > 0 '
    else
      Data.memAnalog.Filter := '';
    Data.memAnalog.Filtered := Data.ParamTable.FieldByName('AnalogFilterEnabled').AsBoolean;

  finally
    Data.memAnalog.AfterScroll := anAfterScrollEvent;
    Data.memAnalog.EnableControls;
  end;
end;

procedure TMain.LoadTDInfoTimerTimer(Sender: TObject);
var
  s, aFilterOE: string;
  i, aSelStart, aLen, aNum: integer;
 // isFilterSet: Boolean;
  aHighLight: set of Byte;
  HighLight: TSTringList;
begin
  if not Data.fDatabaseOpened then
    exit;
    
  LoadTDInfoTimer.Enabled := False;
  Main.KitGridEh.SumList.Active := True;
  Data.CatalogDataSource.DataSet.AfterScroll := Data.CatalogTableAfterScroll;
  Main.KitGridEh.SumList.RecalcAll;

  HighLight := TStringList.Create;
  try
    Data.DescriptionTable.MasterFields := 'Cat_id';
    Data.DescriptionTable.MasterSource  := Data.CatalogDataSource;
    AnalogGrid.DataSource := Data.memAnalogDataSource; {new}
    PrimGrid.DataSource := Data.PrimenDataSource;
    ParamGrid.DataSource := Data.CatDetDataSource;

//    isFilterSet := ((FiltModeComboBox.ItemIndex = 2) or (FiltModeComboBox.ItemIndex = 4)) and (FiltEd.Text <> '');
    aFilterOE := AnsiUpperCase(FiltEd.Text);
    aHighLight := []; //индексы номеров для подсветки

    OEInfo.Clear;
    Data.OEDescrTable.First;
    Data.OEIDTable.First;
    s := '';
    aNum := 0;

    while not Data.OEIDTable.Eof do
    begin
      if not Data.OEDescrTable.Eof then
      begin
        if s <> '' then
          s := s + ', ';
          
        s := s + Data.OEDescrTable.FieldByName('Code').AsString;

        //запоминаем индексы OE-номеров которые нужно подсветить
        //делаем так - т.к. ищем по Code2 или ShortOE, а отображаем Code
//        if isFilterSet then
            if POS(AnsiUpperCase(aFilterOE), AnsiUpperCase(Data.OEDescrTable.FieldByName('ShortOE').AsString)) > 0 then
            begin
              HighLight.Append(Data.OEDescrTable.FieldByName('ShortOE').AsString);
              Include(aHighLight, aNum);
            end;
          {if IgnoreSpecialSymbolsCheckBox.Checked then
          begin
            if POS(AnsiUpperCase(aFilterOE), AnsiUpperCase(Data.OETable.FieldByName('ShortOE').AsString)) > 0 then
              Include(aHighLight, aNum);
          end
          else
            if POS(AnsiUpperCase(aFilterOE), AnsiUpperCase(Data.OETable.FieldByName('Code2').AsString)) > 0 then
              Include(aHighLight, aNum);}
        Inc(aNum);

        Data.OEDescrTable.Next;
        if not Data.OEDescrTable.Eof then
          s := s + ', ';
      end;
      Data.OEIDTable.Next;
    end;
   { while not Data.OETable.Eof do
    begin
      s := s + Data.OETable.FieldByName('Code').AsString;

      //запоминаем индексы OE-номеров которые нужно подсветить
      //делаем так - т.к. ищем по Code2 или ShortOE, а отображаем Code
      if isFilterSet then
        if IgnoreSpecialSymbolsCheckBox.Checked then
        begin
          if POS(AnsiUpperCase(aFilterOE), AnsiUpperCase(Data.OETable.FieldByName('ShortOE').AsString)) > 0 then
            Include(aHighLight, aNum);
        end
        else
          if POS(AnsiUpperCase(aFilterOE), AnsiUpperCase(Data.OETable.FieldByName('Code2').AsString)) > 0 then
            Include(aHighLight, aNum);
      Inc(aNum);

      Data.OETable.Next;
      if not Data.OETable.Eof then
        s := s + ', ';
    end;      }


    OEInfo.Text := AnsiUpperCase(s);
    OEInfo.ShowHint := s <> '';


 {   for i := 0 to HighLight.Count -1 do
    begin
      aSelStart := Pos(HighLight[i], OEInfo.Text);
      if  aSelStart > 0 then
      begin
        OEInfo.SelStart := aSelStart-1;
        OEInfo.SelLength := Length(HighLight[i]);
        OEInfo.SelAttributes.Link := True;
        OEInfo.SelAttributes.BackColor := clYellow;
      end;
    end;   }

    if s <> ''  then
    begin
      aNum := 0;
      aSelStart := 0;
      aLen := Length(s);
      for i := 1 to aLen do
      begin
        if (Copy(s, i, 2) = ', ') then
        begin
          OEInfo.SelStart := aSelStart;
          OEInfo.SelLength := i - aSelStart - 1;
          OEInfo.SelAttributes.Link := True;
          aSelStart := i + 1;

          if aNum in aHighLight then
            OEInfo.SelAttributes.BackColor := clYellow;
          Inc(aNum);
        end
        else
          if (i = aLen) then
          begin
            OEInfo.SelStart := aSelStart;
            OEInfo.SelLength := i - aSelStart;
            OEInfo.SelAttributes.Link := True;

            if aNum in aHighLight then
              OEInfo.SelAttributes.BackColor := clYellow;
          end;
      end;
      OEInfo.SelStart := 0;
      OEInfo.SelLength := 0;
    end;
    ShowStatusBarInfo;
    if Pager.ActivePage = DetailsPage then
    begin
      LoadTDInfo;
      if Data.ParamTable.FieldByName('bUnionDetailAnalog').AsBoolean then
        RefreshMemAnalogs;
    end
    else
      if Pager.ActivePage = AnalogPage then
        RefreshMemAnalogs;
  finally
     HighLight.Free;
  end;
end;

procedure TMain.LoadWaitListExecute(Sender: TObject);
var
  sFileName: string;
  ftFile: TextFile;
  sData, sClientId: string;
  CurDate: TDate;
  rNo: integer;
  s: string;
  cat_code: string;//  := Data.MakeSearchCode(Copy(cb, 1,  p - 1));
  cb,cat_brand: string;// := Copy(cb, p + 1, 100);
  p: integer;
begin
  //Загрузить лист ожидания.
  try
   Data.OpenDialog.InitialDir := Data.Export_Path;
   Data.OpenDialog.FileName := '';
  if Data.OpenDialog.Execute() = false then
    exit;
  SetCurrentDir(Data.Data_Path);
  sFileName:= Data.OpenDialog.FileName;

  CurDate := Now;
  sData := '.'+inttostr(YearOf(CurDate));
  if MonthOfTheYear(CurDate) < 10 then
     sData := '.0'+ inttostr(MonthOfTheYear(CurDate))+sData
  else
     sData := '.'+inttostr(MonthOfTheYear(CurDate))+sData;

  if DayOfTheMonth(CurDate) < 10 then
     sData := '0'+ inttostr(DayOfTheMonth(CurDate))+sData
  else
     sData := inttostr(DayOfTheMonth(CurDate))+sData;

   AssignFile(ftFile,sFileName);
   Reset(ftFile);
   with Data.WaitListTable do
   begin
    rNo := RecNo;
    DisableControls;
    Filtered := FALSE;
    First;
    if GetCurrentUser <> nil then
      sClientId := GetCurrentUser.sId;
    while not System.Eof(ftFile) do
    begin
        Readln(ftFile,s);
        cb := ExtractDelimited(1,  s, [';']);
        p := Pos('_', cb);
        cat_code  := Data.MakeSearchCode(Copy(cb, 1,  p - 1));
        cat_brand := Copy(cb, p + 1, 100);

        if((cat_code='')or(cat_brand='')) then
          Continue;

        Append;
//        FieldByName('Code2').AsString +';'+FieldByName('Brand').AsString+';' +FieldByName('Quantity').AsString+FieldByName('Info').AsString+';');
          FieldByName('Code2').AsString := cat_code;
          FieldByName('Brand').AsString := cat_brand;
          if(ExtractDelimited(2,s,[';'])<>'') then
            FieldByName('Quantity').AsString := ExtractDelimited(2,s,[';'])
          else
            FieldByName('Quantity').AsString := '1';
          FieldByName('Info').AsString := ExtractDelimited(3,s,[';']);
          FieldByName('cli_id').AsString := sClientId;
        Post;
    end;

      Filtered := TRUE;
      RecNo := rNo;
      EnableControls;
   end;
   CloseFile(ftFile);
  //ftFile
  except
        on E:Exception do
        begin
           MessageDlg('Ошибка - '+E.Message, mtError, [MBOK],0);
           exit;
        end;
  end;
  Data.CalcWaitList;
end;

procedure TMain.LoadTDInfo;
var
  bs: TDBISAMBlobStream;
  ext: string;
  si: TSingleImage;
  bm: TBitmap;
begin
  if Data.DescriptionTable.Eof then
  begin
    DBAdvMemo.Visible := FALSE;
    ParamGrid.Visible := TRUE;
    ParamTypGrid.Visible := TRUE;
    AdvSplitter5.Visible := TRUE;
    //AdvSplitter5.Align
  end
  else
  begin
    DBAdvMemo.Visible := TRUE;
    AdvSplitter5.Visible := FALSE;
    ParamGrid.Visible := FALSE;
    ParamTypGrid.Visible := FALSE;
  end;

  CatalogPicture.Hide;
  PicturePanel.Text := BsNoImageText;
  lbDownloadPicture.Visible := False;

  // загрузка картинки NEW -----------------------------------------------------
  if Data.PictTable.Active then
    if Data.PictTable.Locate('Pict_id', Data.CatalogDataSource.DataSet.FieldByName('Pict_id').AsInteger, []) then
    begin
      bs := TDBISAMBlobStream.Create(TBlobField(Data.PictTable.FieldByName('Pict_data')), bmRead);
      ext := DetermineStreamFormat(bs);
      if ext <> '' then
      begin
        si := TSingleImage.CreateFromStream(bs);
        bm := TBitmap.Create;
        ConvertImageToBitmap(si, bm);
        CatalogPicture.Picture.Bitmap.Assign(bm);
        CatalogPicture.Show;
        bm.Free;
        si.Free;
        PicturePanel.Text := '';
      end;
      bs.Free;
    end
    else
      if {(not Data.fTecdocOldest) and }(Data.CatalogDataSource.DataSet.FieldByName('Pict_id').AsInteger > 0) then
      begin
        lbDownloadPicture.Visible := True;
        lbDownloadPicture.Tag := Data.CatalogDataSource.DataSet.FieldByName('Pict_id').AsInteger;
      end;
  //----------------------------------------------------------------------------

  PrimGrid.DataSource := nil;
  pnPrimen.Visible := Data.LoadPrimen2(cMaxPrimenCount);
  if pnPrimen.Visible then
    pnPrimen.Caption := 'показано ' + IntToStr(cMaxPrimenCount) + ' авто';
  PrimGrid.DataSource := Data.PrimenDataSource;
end;

procedure TMain.MainActionExecute(Sender: TObject);
var
  iField: Integer;
  i: Integer;
  s: string;
  iID: Integer;
  FullProgPath: PChar;
  si: TStartUpInfo;
  pi: TProcessInformation;
  position, cnt4del: integer;
  fGoodClose: boolean;
  Contract, DataDoc, DocType, Client, Note, AgrDescription, FIO, Mobile, aFakeAddresDescr, aAgrGroup: string;
  Num: integer;
begin
  Data.NetTimer.Enabled := False;
  if Sender = ExitProgAction then
  begin
    Close;
    Exit;
  end
  else if Sender = StopServerAction then
    Data.StopServer
  else if Sender = ShowServSplashAction then
    ShowServerSplash
  else if Sender = LoadGroupAction then
     Data.LoadGrFromExcell
  else if Sender = LoadCatAction then
    begin
   //AdminMode
//exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}
    Data.LoadCatFromExcell
    end
  else if Sender = LoadAnAction then
    begin
     //AdminMode
//  exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}
     Data.LoadAnFromExcell
    end
  else if Sender = LoadQuantAction then
  begin
   //AdminMode
//    exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

   Data.LoadQuantFromExcell;
  end
  else if Sender = LoadOENumbersAction then
 begin
     //AdminMode
//exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

    Data.LoadOENumbersFromExcell
 end
  else if Sender = GroupsAction then
  begin
    StartWait;
    Data.Tree_mode := 0;
    Data.LoadTree;
    GroupsAction.Checked := True;

    //tbTree.Down := True;
    tbTree.Action := GroupsAction;
    tbTree.OnClick := nil;

    StopWait;
  end
  else if Sender = BrandsAction then
  begin
    StartWait;
    Data.Tree_mode := 1;
    Data.LoadTree;
    BrandsAction.Checked := True;

    //tbTree.Down := True;
    tbTree.Action := BrandsAction;
    tbTree.OnClick := nil;

    StopWait;
  end
  else if Sender = MyGroupsAction then
  begin
    StartWait;
    Data.Tree_mode := 2;
    Data.LoadTree;
    MyGroupsAction.Checked := True;

    //tbTree.Down := True;
    tbTree.Action := MyGroupsAction;
    tbTree.OnClick := nil;

    StopWait;
  end
  else if Sender = MyBrandsAction then
  begin
    StartWait;
    Data.Tree_mode := 3;
    Data.LoadTree;
    MyBrandsAction.Checked := True;

    //tbTree.Down := True;
    tbTree.Action := MyBrandsAction;
    tbTree.OnClick := nil;

    StopWait;
  end
  else if Sender = AutoAction then
  begin
    if AutoAction.Visible and AutoAction.Enabled then
    begin
      Data.sAuto := '';
      bAbort := FALSE;
      with TAuto.Create(Application) do
      try
        if ShowModal = mrOk then
        begin
          SetCarFilter(Data.Auto_type);
        end
        else
        begin
          Data.Auto_type := 0;
          AutoPanel.Hide;
          ParamTypGrid.Datasource := nil;
        end;
        if not Data.TimerSetCatFilter.Enabled then
          Data.SetCatFilter;
      finally
        Free;
      end;
    end;//if AutoAction.Visible
  end
  else if Sender = SetupMyGroupsAction then
  begin
    with TMyGroupSetup.Create(Application) do
    begin
      ShowModal;
      Free;
    end;
    if Data.Tree_mode = 2 then
      Data.LoadTree;
  end
  else if Sender = SetupMyBrandsAction then
  begin
    with TMyBrandsSetup.Create(Application) do
    begin
      ShowModal;
      Free;
    end;
    if Data.Tree_mode = 3 then
      Data.LoadTree;
  end
  else if Sender = ServSetupAction then
  begin
  //adminmode
//exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

    with TServSetup.Create(Application) do
    begin
      ShowModal;
      Free;
      ShowStatusBarInfo;
    end;
  end
  else if Sender = MfaSetupAction then
  begin
    with TManufacturersSetup.Create(Application) do
    begin
      ShowModal;
      Free;
    end;
  end
  else if Sender = ClearFiltAction then
  begin
    FiltEd.Clear;
    bAbort := TRUE;

    if Data.Auto_type = 0 then
       Data.sAuto := '';

    if (Data.Auto_type > 0)and(FiltModeComboBox.ItemIndex <> 0)  then
    begin
       Data.Auto_type := 0;
       Data.sAuto := '';
       AutoPanel.Hide;
       ParamTypGrid.Datasource := nil;
    end;

     if  not Data.TimerSetCatFilter.Enabled then
        Data.SetCatFilter;
    FiltEd.Color := clWindow;
  end
  else if Sender = ClearSearchAction then
  begin
    SearchEd.Clear;
    SearchEd.Color := clWindow;
    SearchMode := False;
    MainGrid.SetFocus;
    if Data.CatalogDataSource.DataSet.Active then
      Data.CatalogDataSource.DataSet.First;
  end
  else if Sender = ClientIDsAction then
  begin
    with TClientIDs.Create(Application) do
    begin
      ShowModal;
      Free;
    end;
    LoadUserID;
  end
  else if Sender = EditOrderAction then
  begin
    if (Data.OrderTable.FieldByName('Sent').AsString = '4') and
       (Application.MessageBox('По заказу получен TCP-ответ, хотите обработать сейчас?', 'Подтверждение', MB_YESNO or MB_ICONQUESTION) = IDYES) then
    begin
      ApplyOrderAnswer;
    end
    else
    begin
      if Data.OrderTable.FieldByName('Order_id').AsInteger = 0 then
        if Application.MessageBox('Создать новый заказ?', 'Подтверждение', MB_YESNO or MB_ICONQUESTION) <> IDYES then
          Exit
        else
          if not NewOrder then
            Exit;

      with TOrderEdit.Create(Application) do
      try
        DataSource := Data.OrderDatasource;
        with DataSource.DataSet do
        begin
          Contract := FieldByName('Agreement_No').AsString;
          DataDoc := FieldByName('Date').Value;
          Num := FieldByName('Num').AsInteger;
          DocType := FieldByName('Type').AsString;
          Client := FieldByName('Cli_id').AsString;
          Note := FieldByName('Description').AsString;
          AgrDescription := FieldByName('AgrDescr').AsString;
          FIO := FieldByName('Name').AsString;
          Mobile := TrimAll(FieldByName('Phone').AsString);
          aFakeAddresDescr := FieldByName('FakeAddresDescr').AsString;
          aAgrGroup := FieldByName('AgrGroup').AsString;          
        end;
        {}
        repeat
          ShowModal;
          fGoodClose := FALSE;
          if ModalResult <> mrOk then
          begin
            with DataSource.DataSet do
            begin
              Edit;
              FieldByName('Agreement_No').AsString := Contract;
              FieldByName('Date').Value := DataDoc;
              FieldByName('Num').AsInteger := Num;
              FieldByName('Type').AsString := DocType;
              FieldByName('Cli_id').AsString := Client;
              FieldByName('Description').AsString := Note;
              FieldByName('AgrDescr').AsString := AgrDescription;
              FieldByName('Name').AsString := FIO;
              FieldByName('Phone').AsString := Mobile;
              FieldByName('FakeAddresDescr').AsString := aFakeAddresDescr;
              FieldByName('AgrGroup').AsString := aAgrGroup;
              Post;
            end;
          end
          else if (length(DataSource.DataSet.FieldByName('AgrDescr').AsString) < 1)
              or ((FakeAddresDescr.Visible) and (Length(DataSource.DataSet.FieldByName('FakeAddresDescr').AsString)< 1))
              or ((Phone.Visible) and (Length(TrimAll(Phone.Text)) < MIN_LENGTH_PHONE))
              or ((Name.Visible) and (Length(DataSource.DataSet.FieldByName('Name').AsString)< MIN_LENGTH_NAME))
            then
            begin
               MessageDlg('Заполните все обязательные поля, иначе заказ не будет сохранен! ФИО и телефон должны соответствовать формату!', mtError, [mbYes], 0);
               fGoodClose := TRUE;
            end
          else
            TrimField(DataSource.DataSet, 'Phone');

        until not fGoodClose;
        {}
   //     ShowModal;
        SetDirtyOrder(ActualOrderPar);
        ZakTabInfo;
      finally
        Free;
      end;
    end;
  end
  else if Sender = NewOrderAction then
  begin
   if not NewOrder then
        exit;
    with TOrderEdit.Create(Application) do
    begin
      DataSource := Data.OrderDatasource;
      repeat
        ShowModal;
        fGoodClose := FALSE;
        if ModalResult <> mrOk then
        begin
          if not DataSource.DataSet.EOF then
            DataSource.DataSet.Delete;
        end
        else
        begin
          if (length(DataSource.DataSet.FieldByName('AgrDescr').AsString) < 1)
            or ((FakeAddresDescr.Visible) and (Length(DataSource.DataSet.FieldByName('FakeAddresDescr').AsString)< 1))
            or ((Phone.Visible) and (Length(TrimAll(Phone.Text)) < MIN_LENGTH_PHONE))
            or ((Name.Visible) and (Length(DataSource.DataSet.FieldByName('Name').AsString)< MIN_LENGTH_NAME))
          then
          begin
             MessageDlg('Заполните все обязательные поля, иначе заказ не будет сохранен! ФИО и телефон должны соответствовать формату!', mtError, [mbYes], 0);
             fGoodClose := TRUE;
          end
          else
            TrimField(DataSource.DataSet, 'Phone');
        end;
      until not fGoodClose;

    {  if (ShowModal <> mrOk) and (not Data.OrderTable.Eof) then
        Data.OrderTable.Delete;}
      Main.CatZakPage.Caption := 'Заказы';
      ActualOrderPar.Free;
      Free;
    end;
    ZakTabInfo;
  end
  else if Sender = DelOrderAction then
  begin
   if ((Data.OrderDetTable.RecordCount > 0)and(Data.ParamTable.FieldByName('ToForbidRemovalOrder').AsBoolean)) then
   begin
      MessageDlg('Невозможно удалить заказ! Для удаления заказа необходимо удалить из него все позиции.', mtInformation, [mbOK], 0);
   end
   else
    if (Data.OrderTable.FieldByName('Order_id').AsInteger <> 0) and
       (MessageDlg('Удалить заказ? Вы Уверены?',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      with Data.OrderDetTable do
      begin
        while not Eof do
          Delete;
      end;
      Data.OrderTable.Delete;
 //     Main.CatZakPage.Caption := 'Заказы';
    end;
  end
  else if Sender = AddToOrderAction then
    AddToOrder
  else if Sender = AddToWaitListAction then
    AddToWaitList
  else if Sender = AddAnToOrderAction then
    AddAnToOrder
  else if Sender = AddAnToWaitListAction then
    AddAnToWaitList
  else if Sender = OrderQuantEditAction then
    OrderQuantityEdit
  else if Sender = WaitListQuantEditAction then
    WaitListQuantityEdit
  else if Sender = UnlockOrderAction then
    UnlockOrder
  else if Sender = DeleteFromOrderAction then
  begin
//---------------
    if Data.OrderTable.FieldByName('Sent').AsString <> '' then
    if (Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
    begin
      MessageDlg('Невозможно удалить позицию из выбранного заказа!!!'+
                 ' Заказ уже был отправлен в офис компании и вероятно уже обработан.'+
                 ' Для проверки зарезервированного товара нажмите кнопку "TCP ответ".',  mtInformation, [mbOK], 0);
       exit;
    end;
    iID := -1;
    cnt4del := 0;
    position := Data.OrderDetTable.RecNo;

    if Data.masChek.Count <> 0 then
    begin
      if (Data.OrderDetTable.FieldByName('Id').AsInteger <> 0) and
         (MessageDlg('Удалить выбранные позиции (' + IntToStr(Data.masChek.Count) + ' шт.)?',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes) then

        for i := 0 to Data.masChek.Count - 1 do
        begin
          Data.OrderDetTable.Locate('ID', Integer(data.masChek.Items[i]), []);
          if Data.OrderDetTable.RecNo <= position then
            inc(cnt4del);
          Data.OrderDetTable.Delete;

          with Data.OrderTable do
          begin
            Edit;
            FieldByName('Dirty').Value := True;
            Post;
            Refresh;
          end;
        end;
    end
    else
    begin
      if (Data.OrderDetTable.FieldByName('Id').AsInteger <> 0) and
         (MessageDlg('Удалить позицию из заказа?',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      begin
        Data.OrderDetTable.Next;
        iID := Data.OrderDetTable.FieldByName('ID').AsInteger;
        if not Data.OrderDetTable.Eof then
          Data.OrderDetTable.Prior;

        if Data.OrderDetTable.RecNo <= position then
          inc(cnt4del);
        Data.OrderDetTable.Delete;

        with Data.OrderTable do
        begin
          Edit;
          FieldByName('Dirty').Value := True;
          Post;
          Refresh;
        end;
      end;
    end;

    ZakTabInfo;
    Data.OrderDetTable.Locate('ID', iID, []);
    Data.CatalogDataSource.DataSet.Refresh;
    Data.OrderDetTable.RecNo := position - cnt4del;
  end
 //------------------


  else if Sender = DeleteFromWaitListAction then
  begin
    if (Data.WaitListTable.FieldByName('Id').AsInteger <> 0) and
       (MessageDlg('Удалить из листа ожидания? Вы Уверены?',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      Data.WaitListTable.Delete;
      Data.CalcWaitList;
    end;
  end
  else if Sender = GoToAnalogAction then
    Data.GoToAnalog
  else if Sender = PrintOrderAction then
    PrintOrder
  else if Sender = MainParamAction then
  begin
   // if isOpenedMoreThan2Windows('MainParam') then
   //   exit;
    Application.ProcessMessages;
    Data.ParamTable.Refresh;
    Data.SysParamTable.Refresh;
    Data.LoadTimer.Enabled := False;
    with TMainParam.Create(Application) do
    begin
      ShowModal;
      Free;
      Data.SetPriceKoef;
      ShowStatusBarInfo;
    end;
    LoadUserID;
    Data.LoadTimer.Enabled := True;
  end
  else if Sender = ParamAction then
  begin
    Application.ProcessMessages;
    Data.ParamTable.Refresh;
    Data.SysParamTable.Refresh;
    Data.LoadTimer.Enabled := False;
    TimerUpdate.Enabled := FALSE;
    with TParam.Create(Application) do
    try
      ShowModal;
     {$IFDEF LOCAL}
      if fRestart then
      begin
        try
          Main.Close;
        finally
          if main.fCanClose then
          begin
            FullProgPath:=PChar(Application.ExeName);
            ZeroMemory(@si, SizeOf(si));
            ZeroMemory(@pi, SizeOf(pi));
            with si do
            begin
              cb := SizeOf(si);
              dwFlags := STARTF_USESHOWWINDOW;
              wShowWindow := SW_HIDE;
              hStdInput := 0;
            end;
            if not CreateProcess(nil, FullProgPath, nil, nil, FALSE, 0, nil, PChar(GetAppDir), si, pi) then
              ShowMessage( SysErrorMessage(GetLastError) );
          end;
        end;
        exit;
      end;
     {$ENDIF LOCAL}

    finally
      Free;
    end;

    LoadUserID;
    Data.LoadCurrencyRounding(gCurrencyRounding);
    Data.SetPriceKoef;
    ShowStatusBarInfo;
    Data.LoadTextAttrList;
    MainGrid.Refresh;
    ZakTabInfo;
    Data.CatalogDataSource.Dataset.Refresh;
    UpdateScheduledTasks;

    if JvScrollText.Font.Color <> Data.ParamTable.FieldByName('ColorRunString').AsInteger then
    begin
       JvScrollText.Font.Color := Data.ParamTable.FieldByName('ColorRunString').AsInteger
    end;

     if (Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdate').AsBoolean)
      and((Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdateProg').AsBoolean)
          or(Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdateQuants').AsBoolean))  then
      begin
             TimerUpdate.Enabled := TRUE;
      end;

    if Data.ParamTable.FieldByName('bVisibleRunningLine').AsBoolean then
        begin
         RunLinePanel.Visible:= TRUE;
         JvScrollText.Visible := TRUE;
         JvScrollText.Active := TRUE;
        end
      else
        begin
        JvScrollText.Active := FALSE;
        JvScrollText.Visible := FALSE;
        RunLinePanel.Visible:= FALSE;
        end;
  {//это уже вычислено в FormCreate
  Data.CatDetTable.MasterFields := '';
  Data.CatDetTable.MasterSource := nil;
  DetailsEnabled := not (Data.CatDetTable.IsEmpty);
  Data.CatDetTable.MasterFields := 'param_tdid';
  Data.CatDetTable.MasterSource := Data.CatalogDataSource;
  }
  DetailsPage.TabVisible := DetailsEnabled;
  DetailsPage.Visible    := DetailsEnabled;

  if Data.ParamTable.FieldByName('bUnionDetailAnalog').AsBoolean and DetailsEnabled then
  begin
    if AnalogPage = pnAnalog.Parent then
    begin
      if Pager.ActivePage = AnalogPage then
        Pager.ActivePage := DetailsPage;

      PanelDetails.Align := alBottom;
      PanelDetails.Height := DetailsPage.Height div 2;
      AdvSplitter6.Visible := TRUE;
      AdvSplitter6.Align := alTop;
      AdvSplitter6.Align := alBottom;

      pnAnalog.Parent := DetailsPage;
      pnAnalog.Align  := alClient;

      AnalogPage.Visible := FALSE;
      AnalogPage.TabVisible := FALSE;
    end;
  end
  else
  begin
     AnalogPage.Visible := TRUE;
     AnalogPage.TabVisible := TRUE;
   //  PanelAnalogs.Visible := FALSE;
     AdvSplitter6.Visible := FALSE;
     PanelDetails.Align := alClient;
     pnAnalog.Parent := AnalogPage;
     pnAnalog.Align   := alClient;
  end;

    if Data.ParamTable.FieldByName('Loading').AsBoolean then
    begin
      if Data.ParamTable.FieldByName('Loading_comp').AsString <> GetComputer then
                Data.LoadTimer.Enabled := True;
    end
    else
        Data.LoadTimer.Enabled := True;
  end
  else if Sender = BrandDiscAction then
  with TBrandDiscSetup.Create(Application) do
  begin
    ShowModal;
    Free;
    if Data.CatalogDataSource.DataSet.Active then
      Data.CatalogDataSource.DataSet.Refresh;
    Data.AnalogTable.Refresh;
    Data.OrderDetTable.Refresh;
    Data.OrderTable.Refresh;
    ShowStatusBarInfo;
    //ShowStatusBarInfo;
  end
  else if Sender = RecalcOrderAction then
    Data.RecalcOrder
  else if Sender = EmailOrderAction then
    EmailOrder
  else if Sender = SaveOrderAction then
    SaveOrder
  else if Sender = WhidbeyAction then
  begin
    AppStyler.Style := tsWhidbey;
    (Sender as TAction).Checked := True;
  end
  else if Sender = WindowsXPAction then
  begin
    AppStyler.Style := tsWindowsXP;
    (Sender as TAction).Checked := True;
  end
  else if Sender = WebUpdateAction then
  begin
    DoWebUpdate;
    exit;
  end
  else if Sender = DiskUpdateAction then
    DoDiskUpdate
  else if Sender = ExportAction then
  begin
    if MessageDlg('Выгрузить таблицы в формат CSV ?', mtConfirmation,
                       [mbYes, mbNo], 0) = mrYes then
    begin
      Data.DoExport(True);
      MessageDlg('Таблицы выгружены в каталог "Экспорт"!', mtInformation, [mbOK], 0);
    end
  end
  else if Sender = ImportAction then
  begin
    if MessageDlg('Импортировать данные из каталога "Импорт"?', mtConfirmation,
                         [mbYes, mbNo], 0) <> mrYes then
      exit;
    Data.DoImport;
    Data.CalcWaitList;
    MessageDlg('Импорт данных завершен!', mtInformation, [mbOK], 0);
  end
  else if Sender = StartInfoAction then
  begin
    if (FileExists(GetAppDir + 'RssNews.html') or FileExists(GetAppDir + 'News.html')) then // and
      //(not isOpenedMoreThan2Windows('Info')) then
      with TInfo.Create(Application) do
      begin
        Caption := 'Последние новости';
        if FileExists(GetAppDir + 'RssNews.html') then
          Browser.Navigate(GetAppDir + 'RssNews.html')
        else
          Browser.Navigate(GetAppDir + 'News.html');
        HideCheckBox.Visible := True;
        ShowModal;
        Free;
      end;
  end
  else if Sender = InfoAction then
  begin
   // if (not isOpenedMoreThan2Windows('Info')) then
    with TInfo.Create(Application) do
    begin
      Caption := 'Информация';
      Browser.Navigate(GetAppDir + 'Rules.html');
      ShowModal;
      Free;
    end;
  end
  else if Sender = BrandInfoAction then
  begin
    //if (not isOpenedMoreThan2Windows('Info')) then
    with TInfo.Create(Application) do
    begin
      Caption := 'Информация по брендам';
      Browser.Navigate(GetAppDir + 'Brands.html');
      ShowModal;
      Free;
    end;
  end
  else if Sender = OrderInfoAction then
  begin
    //if (not isOpenedMoreThan2Windows('Info')) then
    with TInfo.Create(Application) do
    begin
      Caption := 'Как сделать заказ';
      Browser.Navigate(GetAppDir + 'Orders.html');
      ShowModal;
      Free;
    end;
  end
  else if Sender = ProgInfoAction then
  begin
    with TProgInfo.Create(Application) do
    begin
      ShowModal;
      Free;
    end;
  end
  else if Sender = LoadOEmemoAction then
  begin
    if MessageDlg('Загрузить OE-номера в memo-поля?', mtConfirmation,
                         [mbYes, mbNo], 0) = mrYes then
    begin
      Data.LoadOEMemo;
      MessageDlg('Загрузка завершена!', mtInformation, [mbOK], 0);
    end;
  end
  else if Sender = LoadAnMemoAction then
  begin
    if MessageDlg('Загрузить коды аналогов в memo-поля?', mtConfirmation,
                         [mbYes, mbNo], 0) = mrYes then
    begin
      Data.LoadAnMemo;
      MessageDlg('Загрузка завершена!', mtInformation, [mbOK], 0);
    end;
  end
  else if Sender = LoadOrderAction then
    LoadOrder
  else if Sender = LoadOrderActionTCP then
  begin
    if LoadOrderTCP1 then
      ApplyOrderAnswer;
  end
  else if Sender = PrepareUpdateAction then
    Data.PrepareUpdate
  else if Sender = PrepareQuantsUpdateAction then
    Data.PrepareQuantsUpdate
  else if Sender = WaitListOrderMoveAction then
    WaitListOrderMove
  else if Sender = AllWaitListOrderMoveAction then
    AllWaitListOrderMove
  else if Sender = LoadTecdocAction1 then
    Data.LoadTecdoc1
  else if Sender = LoadTecdocAction2 then
    Data.LoadTecdoc2
  else if Sender = UpdateTecdocAction then
    Data.LoadTecdoc2(True)
  else if Sender = LoadTecdocAction3 then
    Data.LoadTecdoc3
  else if Sender = UnknownBrandsAction then
  begin
    if MessageDlg('Искать нераспознанные бренды Tecdoc?', mtConfirmation,
                         [mbYes, mbNo], 0) = mrYes then
      Data.UnknownBrands;
  end
  else if Sender = LoadPrimenMemoAction then
    Data.LoadPrimenMemo
  else if Sender = LoadPicturesAction then
    Data.LoadAddPicturesBath
  else if Sender = LoadPicturesAction2 then
    Data.LoadAddPictures2Bath
  else if Sender = TypesUnloadAction then
    Data.TypesUnload
  else if Sender = LoadTecdocBrandsAction then
  begin
    if MessageDlg('Загрузить бренды из Tecdoc?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Data.LoadTDBrandTable;
      MessageDlg('Загрузка завершена!', mtInformation, [mbOK], 0);
    end;
  end
  else if Sender = TDBrandSetupAction then
  begin
    with TTDBrandsSetup.Create(Application) do
    begin
      ShowModal;
      Free;
    end;
  end
  else if Sender = LoadAddTDArtAction then
    Data.LoadAddTDArt
  else if Sender = LoadAddTDParamAction then
    Data.LoadAddTDParamBath
  else if Sender = LoadAddTDPrimenAction then
    Data.LoadAddTDPrimenBath
  else if Sender = ResetIniAction then
  begin
    if MessageDlg('Все настройки интерфейса сделанные Вами будут сброшены.'+#13+#10+
                  'Вам потребуется перезапустить программу. Вы уверены?  ',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      lResetIni := True;
      MainDockPanel.Persistence.Enabled := False;
      Close;
      Exit;
    end;
  end
  else if Sender = SQLAction then
  begin
    //adminmode
//exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

    with TSQLQuery.Create(Application) do
    begin
      ShowModal;
      Free;
    end;
  end;
  SetActionEnabled;
  Data.NetTimer.Enabled := Data.NetTimer.Interval > 0;
end;


procedure TMain.StyleActionExecute(Sender: TObject);
begin
  if Sender = Office2003BlueAction then
  begin
    AppStyler.Style := tsOffice2003Blue;
   // ToolPanelTab.Style := esOffice2003Blue;
  end
  else if Sender = Office2003ClassicAction then
  begin
    AppStyler.Style := tsOffice2003Classic;
   // ToolPanelTab.Style := esOffice2003Classic;
  end
  else if Sender = Office2003OliveAction then
  begin
    AppStyler.Style := tsOffice2003Olive;
   // ToolPanelTab.Style := esOffice2003Olive;
  end
  else if Sender = Office2003SilverAction then
  begin
    AppStyler.Style := tsOffice2003Silver;
   // ToolPanelTab.Style := esOffice2003Silver;
  end
  else if Sender = Office2007LunaAction then
  begin
    AppStyler.Style := tsOffice2007Luna;
   // ToolPanelTab.Style := esOffice2007Luna;
  end
  else if Sender = Office2007ObsidianAction then
  begin
    AppStyler.Style := tsOffice2007Obsidian;
   // ToolPanelTab.Style := esOffice2007Obsidian;
  end
  else if Sender = Office2007SilverAction then
  begin
    AppStyler.Style := tsOffice2007Silver;
   // ToolPanelTab.Style := esOffice2007Silver;
  end;
  (Sender as TAction).Checked := True;
  pnTreeModeResize(pnTreeMode);   
end;


procedure TMain.MainGridCellClick(Column: TColumnEh);
begin
  ClearSearchMode;
end;

procedure TMain.MainGridColWidthsChanged(Sender: TObject);
begin
  PostMessage(Handle, MESSAGE_AFTER_COL_RESIZE, 0, 0);
end;

procedure TMain.MainGridDblClick(Sender: TObject);
begin
  MainActionExecute(AddToOrderAction);
  ClearSearchMode;
end;


procedure TMain.MainGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
begin
  if SameText(Column.FieldName, 'Quantity') then
  begin
    if MainGrid.DataSource.DataSet.FieldByName('OrderOnly').AsBoolean then
    begin
      DrawOrderOnlyField(MainGrid, Rect, State, MainGrid.DataSource.DataSet.FieldByName('Quantity').AsString);
    end
    else
      if MainGrid.DataSource.DataSet.FieldByName('QuantLatest').AsInteger = 1 then
      begin
        NewImageList.Draw(MainGrid.Canvas, Rect.Right - NewImageList.Width, Rect.Top, 1);
      end;
  end;
end;

procedure TMain.MainGridGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
var
  i: Integer;
begin
  with Data.CatalogDataSource.DataSet do
  begin
     if FieldByName('Title').AsBoolean and (FieldByName('T1').AsInteger = 1) then
    begin
      if FieldByName('Brand_id').AsInteger <> 0 then
      begin
        AFont.Color := clRed;
        AFont.Style := [fsBold, fsItalic];
        if Column.Field.FieldName = 'BrandDescr' then
        begin
           AFont.Color := Background;
        end;
      end
      else if FieldByName('Subgroup_id').AsInteger <> 0 then
      begin
        AFont.Color := clBlue;
        AFont.Style := [fsBold];
        //Background  := clMoneyGreen;
      end
      else
      begin
        AFont.Color := clBlack;
        AFont.Style := [fsBold];
        Background  := clSilver;
        AFont.Size  := 10;
        
      end;
    end
    else if FieldByName('Title').AsBoolean and (FieldByName('T2').AsInteger = 1) then
    begin
      if FieldByName('Subgroup_id').AsInteger <> 0 then
      begin
        AFont.Color := clRed;
        AFont.Style := [fsBold, fsItalic];
      end
      else
      begin
        AFont.Color := clBlack;                     
        AFont.Style := [fsBold];
        Background  := clSilver;
        AFont.Size  := 10;
      end;
    end
    else if FieldByName('SaleQ').AsString = '1' then
    begin
      if (not SCellColor) or (Column.fieldName = 'Price_koef') then
      begin
        AFont.Assign(SaleFont);
        Background := SaleBackgr;
      end;
    end
    else if (not QCellColor) or (Column.FieldName = 'Quantity')  then
    begin
      if not FieldByName('OrderOnly').AsBoolean then
      begin
        if FieldByName('Quantity').AsString = '' then
        begin
          AFont.Assign(NoQuantFont);
          Background := NoQuantBackgr;
        end
        else
        begin
          for i := 0 to Length(TextAttrList) - 1 do
          begin
            if (StrInt(FieldByName('Quantity').AsString) >= TextAttrList[i].Lo) and
               (StrInt(FieldByName('Quantity').AsString) <= TextAttrList[i].Hi) then
            begin
              AFont.Assign(TextAttrList[i].Font);
              Background := TextAttrList[i].Background;
              break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TMain.ClearSearchMode;
begin
  SearchEd.Clear;
  SearchEd.Color := clWindow;
  SearchMode := False;
end;


procedure TMain.ClearSelection;
begin
 OrderDetGrid.Columns.Items[0].Title.ImageIndex := 2;
 Data.masChek.Clear;
end;

procedure TMain.CreateFilePriceExecute(Sender: TObject);
var
  rn: Integer;
  sFile: string;
  Ole: OleVariant;
  s: string;
begin
  try
  if SaveFilePriceDialog.Execute() = false then
    exit;

  SetCurrentDir(Data.Data_Path);
  sFile:= SaveFilePriceDialog.FileName;
  if (StrRight(sFile,4)<>'.csv') then
    sFile:=sFile+'.csv';

  Ole := CreateOleObject('PriceList.ExportPrice');
  s := Ole.ExportPriceList(sFile);
  if s <> '0' then
    begin
      MessageDlg(s, mtError, [mbOK],0);
      exit;
    end;
  with Data.CatalogDataSource.DataSet do
  begin
    DisableControls;
    rn := RecNo;
    First;
    while not Eof do
    begin
    if Length(FieldByName('Code2').AsString)>0 then
    begin
        s := Ole.WriteLine(FieldByName('Code2').AsString + ';' +
                 FieldByName('BrandDescr').AsString+';'+
                 FieldByName('Name').AsString+ ';' +
                 FieldByName('Price_koef').AsString +';');
        if s <> '0' then
          begin
            RecNo := rn;
            EnableControls;
            MessageDlg(s, mtError, [mbOK],0);
            exit;
          end;
    end;
      Next;
    end;
    RecNo := rn;
    EnableControls;
  end;
  s := Ole.Save;
  if s <> '0' then
          begin
            MessageDlg(s, mtError, [mbOK],0);
            exit;
          end;

  MessageDlg('Файл-прайс сформирован: '+sFile+'!',mtInformation,[MBOK],0);
  finally

  end;
end;

procedure TMain.MainGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  len: integer;
begin
  if SearchMode then
  begin
    if Key in [VK_UP, VK_DOWN, VK_ESCAPE] then
    begin
      ClearSearchMode
    end
    else if Key = VK_RETURN then
    begin                              
      ClearSearchMode;
      if ssCtrl in Shift then
        MainActionExecute(AddToWaitListAction)
      else
        MainActionExecute(AddToOrderAction)
    end
    else if Key = VK_BACK then
    begin
      len := Length(SearchEd.Text) - 1;
      SearchEd.Text := Copy(SearchEd.Text, 1, len);
      SearchEd.SelStart := len;
    end
  end
  else if Key in [VK_RETURN, VK_INSERT] then
  begin
    if ssCtrl in Shift then
      MainActionExecute(AddToWaitListAction)
    else
      MainActionExecute(AddToOrderAction)
  end
  else if (Key in [Ord('S'), Ord('s')]) and (ssCtrl in Shift) and (ssShift in Shift) then
  begin
    with Data.CatalogTable do
    begin
      Edit;
      if FieldByName('Sale').AsString <> '1' then
        FieldByName('Sale').Value := '1'
      else
        FieldByName('Sale').Value := '0';
    end;
  end
  else if (Key in [Ord('N'), Ord('n')]) and (ssCtrl in Shift) and (ssShift in Shift) then
  begin
    with Data.CatalogTable do
    begin
      Edit;
      if FieldByName('New').AsString <> '1' then
        FieldByName('New').Value := '1'
      else
        FieldByName('New').Value := '0';
    end;
  end
  else if (Key in [Ord('U'), Ord('u')]) and (ssCtrl in Shift) and (ssShift in Shift) then
  begin
    with Data.CatalogTable do
    begin
      Edit;
      if FieldByName('Usa').AsString <> '1' then
        FieldByName('Usa').Value := '1'
      else
        FieldByName('Usa').Value := '0';
    end;
  end
end;


procedure TMain.MainGridKeyPress(Sender: TObject; var Key: Char);
begin
  //панель может быть отключена
  if not SearchToolBar.Visible then
    Exit;
    
  if Key in [#32..#126, #128..#255] then
  begin
    SearchMode := True;
    SearchEd.SetFocus;
    SearchEd.Text := SearchEd.Text + Key;
    // := TRUE;
    SearchEd.SelStart := length(SearchEd.Text);
  end;
end;


procedure TMain.MainGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fGridDownPoint.X := X;
  fGridDownPoint.Y := Y;
  ShowStatusBarInfo;
end;

procedure TMain.MainGridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //FiltEd.Text := inttostr(X);
{  
  if X < 40 then
  begin
    //MainMenu.ViewMenu.HideTree.Checked := Data.ParamTable.FieldByName('HideTree').AsBoolean;
    if (Data.ParamTable.FieldByName('HideTree').AsBoolean)and(not TreePanel.Visible) then
    begin
       TreePanel.Visible := TRUE;
       if Tree.Visible then
         Tree.SetFocus;
      UpdateToolBarsMenuChecked;
    end;
  end
  else
   if (Data.ParamTable.FieldByName('HideTree').AsBoolean)and(TreePanel.Visible) then
    begin
       TreePanel.Visible := FALSE;
       UpdateToolBarsMenuChecked;
    end;
}
  if (ssLeft in Shift) and
     (Y > MainGrid.Top + MainGrid.TitleHeight) and
     (fGridDownPoint.Y > MainGrid.Top + MainGrid.TitleHeight) then
  begin
    MainGrid.BeginDrag(False, 10);
  end;
end;

procedure TMain.MainGridPanelAnchorClick(Sender: TObject; Anchor: string);

  function ExtractLink(const aUrl: string; out aLinkDescr: string): string;
  var
    p1, p2: Integer;
  begin
    aLinkDescr := '';
    Result := aUrl;

    p1 := POS('[', aUrl);
    p2 := POS(']', aUrl);
    if (p1 = 1) and (p2 > p1) then
    begin
      Result := Copy(aUrl, p2 + 1, MaxInt);
      aLinkDescr := Copy(aUrl, p1 + 1, p2 - p1 - 1);
    end;
  end;

var
  aBrand: string;
  i, aInd: Integer;
  aLink, aDescr: string;
  aItem: TMenuItem;
begin
  if SameText(Anchor, 'BRAND_INFO') then
    AboutBrand.Click;

  if SameText(Anchor, 'BRAND') then
  begin
    aBrand := Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString;
    aInd := fECatList.IndexOfName(aBrand);
    if aInd >= 0 then
    begin
      pmBrandCat.Items.Clear;
      for i := aInd to fECatList.Count - 1 do
      begin
        if fECatList.Names[i] = aBrand then
        begin
          aLink := ExtractLink(fECatList.ValueFromIndex[i], aDescr);
          if aDescr = '' then
            aDescr := aBrand;
          aItem := TMenuItem.Create(pmBrandCat);
          aItem.Caption := aDescr;
          aItem.Hint := aLink;
          aItem.OnClick := miBrandCatalogClick;
          pmBrandCat.Items.Add(aItem);
        end
        else
          Break;
      end;

      if pmBrandCat.Items.Count = 1 then //одна ссылка - сразу открываем в браузере
        miBrandCatalogClick(pmBrandCat.Items[0])
      else                               //несколько ссылок - показываем меню
        pmBrandCat.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    end;
  end;
end;

procedure TMain.MainGridPanelResize(Sender: TObject);
begin
  ArrangeNotifyButtons;
end;

procedure TMain.MainGridStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  Cursor := crDrag;
end;

procedure TMain.OEInfoURLClick(Sender: TObject; const URLText: string;
  Button: TMouseButton);
var
  p: TPoint;
begin
  fURL_OE := URLText;
  if Button = mbLeft then
  begin
//    if Application.MessageBox(PChar('Установить фильтр по OE-номеру "' + URLText + '"?'), 'Подтверждение', MB_YESNO or MB_ICONQUESTION) = IDYES then
    SetCurrentFilter(URLText, 2);
    LoadTDInfoTimerTimer(nil); //чтобы обновилась подсветка OE номеров
  end
  else
    if Button = mbRight then
    begin
      GetCursorPos(p);
      pmOEFilters.Popup(p.X, p.Y);
    end;
end;

procedure TMain.OilToolBarButtonClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://lubematch.shell.com.ru/landing.php?setregion=349&setlanguage=14&site=58&region=349&language=14&brand=95'), nil, nil, SW_SHOW);
end;

procedure TMain.OpenActionExecute(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://shate-m.by/ru/client/opt/151/'), nil, nil, SW_SHOW);
end;

procedure TMain.OpenDiscExecute(Sender: TObject);
var
  UserData: TUserIDRecord;
begin
  if not CheckClientId then
    Exit;

  UserData := GetCurrentUser;
  with Table do
  begin
    Open;
    First;

    if Locate('ID', UserData.iID, []) then
    begin
      with (TClientIDEdit.Create(Application)) do
      begin
        DataSource := Main.DataSource;
        //ParentForm := Self;
        ShowModal;
        Free;
      end;
      UserData.iID := FieldByName('ID').AsInteger;
      UserData.sId := FieldByName('Client_ID').AsString;
      UserData.sName := FieldByName('Description').AsString;
      UserData.sOrderType := FieldByName('Order_type').AsString;
      UserData.iDelivery := FieldByName('Delivery').AsInteger;
      UserData.sEMail := FieldByName('email').AsString;
      UserData.sKey := FieldByName('Key').AsString;
      UserData.bUpdateDisc := FieldByName('UpdateDisc').AsBoolean;
      UserData.DiscountVersion := FieldByName('DiscountVersion').AsInteger;
      UserData.UseDiffMargin := FieldByName('UseDiffMargin').AsBoolean;
      UserData.DiffMargin := FieldByName('DiffMargin').AsString;
      //new
      UserData.DiscVersion := FieldByName('DiscVersion').AsInteger;
      UserData.AddresVersion := FieldByName('AddresVersion').AsInteger;
      UserData.AgrVersion := FieldByName('AgrVersion').AsInteger;

      UserData.ContractByDefault := FieldByName('ContractByDefault').AsString;
      UserData.AddresByDefault := FieldByName('AddresByDefault').AsString;
{
      aIndex := UserIds_Combo.ItemIndex;
      if Data.ParamTable.FieldByName('Cli_id_mode').AsString = '1' then
        UserIds_Combo.Items[aIndex] := UserData.sName + ' [' + UserData.sId + ']'
      else
        UserIds_Combo.Items[aIndex] := UserData.sId;
      UserIds_Combo.ItemIndex := aIndex;}
    end;
    Close;
  end;

  SelectCurrentUser;
  Data.SetPriceKoef;
  ShowStatusbarInfo;
end;

procedure TMain.OpenDiscUpdate(Sender: TObject);
begin
  if CliComboBox.KeyValue <> NULL then
    (Sender as TAction).Enabled := True
  else
    (Sender as TAction).Enabled := False;
end;

procedure TMain.OpenInstructionExecute(Sender: TObject);
var   si: TStartUpInfo;
      pi:TProcessInformation;
begin
  ZeroMemory(@si, SizeOf(si));
  ZeroMemory(@pi, SizeOf(pi));

  if not CreateProcess( nil,PChar('hh.exe ' + GetAppDir + 'help.chm'), nil, nil, FALSE, 0, nil, nil, si, pi) then
  begin
    MessageDlg(PChar(SysErrorMessage(GetLastError)), mtInformation, [mbOK], 0);
  end;
end;

procedure TMain.OrderDateEdChange(Sender: TObject);
begin
  SelectCurrentUser;
  ClearSelection;
  Main.ReturnDocDetGrid.Columns.Items[0].Title.ImageIndex := 2;
  Data.ReturnMasChek.Clear;

end;


procedure TMain.OrderDetGridCellClick(Column: TColumnEh);
var
  aIndex, DelIndex: Integer;
begin
  if SameText(Column.Field.Name, 'OrderDetTableCheckField') then
  begin
    with Data.OrderDetTable do
    begin
      aIndex := Data.masChek.IndexOf(Pointer(FieldByName('id').AsInteger));
      if aIndex = -1 then
        Data.masChek.Add(Pointer(FieldByName('id').AsInteger))
      else
      begin
        DelIndex := Data.masChek.IndexOf(Pointer(FieldByName('id').AsInteger));
        Data.masChek.Delete(DelIndex);
      end;
      Refresh;
    end;
  end;
end;

procedure TMain.OrderDetGridDblClick(Sender: TObject);
begin
  if (Data.OrderTable.FieldByName('Sent').AsString <> '') or(Data.OrderTable.FieldByName('Sent').AsString = '0') then
       MainActionExecute(OrderQuantEditAction);
end;


procedure TMain.OrderDetGridDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if Source <> MainGrid then
    exit;
  AddToOrder;
end;

procedure TMain.OrderDetGridDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source = MainGrid then
    Accept := True;
end;

procedure TMain.OrderDetGridGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  with Data.OrderDetDataSource.DataSet do
  begin
     if FieldByName('TestQuants').AsInteger = 1 then
     begin
        Background  := RGB(255,0,0);
     end;
  end;
{
 with Data.CatalogDataSource.DataSet do
  begin

    if FieldByName('Title').AsBoolean and (FieldByName('T1').AsInteger = 1) then
    begin
      if FieldByName('Brand_id').AsInteger <> 0 then
      begin
        AFont.Color := clRed;
        AFont.Style := [fsBold, fsItalic];
      end
      else if FieldByName('Subgroup_id').AsInteger <> 0 then
      begin
        AFont.Color := clBlue;
        AFont.Style := [fsBold];
        //Background  := clMoneyGreen;
      end
      else
      begin
        AFont.Color := clBlack;
        AFont.Style := [fsBold];
        Background  := clSilver;
        AFont.Size  := 10;
      end;
    end
    else if FieldByName('Title').AsBoolean and (FieldByName('T2').AsInteger = 1) then
    begin
      if FieldByName('Subgroup_id').AsInteger <> 0 then
      begin
        AFont.Color := clRed;
        AFont.Style := [fsBold, fsItalic];
      end
      else
      begin
        AFont.Color := clBlack;
        AFont.Style := [fsBold];
        Background  := clSilver;
        AFont.Size  := 10;
      end;
    end
    else if FieldByName('Sale').AsString = '1' then
    begin
      if (not SCellColor) or (Column.fieldName = 'Price_koef') then
      begin
        AFont.Assign(SaleFont);
        Background := SaleBackgr;
      end;
    end
    else if (not QCellColor) or (Column.FieldName = 'Quantity')  then
    begin
      if FieldByName('Quantity').AsString = '' then
      begin
        AFont.Assign(NoQuantFont);
        Background := NoQuantBackgr;
      end
      else
      begin
        for i := 0 to Length(TextAttrList) - 1 do
        begin
          if (StrInt(FieldByName('Quantity').AsString) >= TextAttrList[i].Lo) and
             (StrInt(FieldByName('Quantity').AsString) <= TextAttrList[i].Hi) then
          begin
            AFont.Assign(TextAttrList[i].Font);
            Background := TextAttrList[i].Background;
            break;
          end;
        end;
      end;
    end;
  end;
}
end;

procedure TMain.OrderDetGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    MainActionExecute(OrderQuantEditAction)
  else if Key = VK_DELETE then
    MainActionExecute(DeleteFromOrderAction)
  else if Key = VK_SPACE then
    Data.GoToSelectItem;
end;


procedure TMain.OrderDetGridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  aCell: TGridCoord;
begin
  if (ssLeft in Shift) and
     (Y > OrderDetGrid.Top + OrderDetGrid.TitleHeight) then
  begin
    aCell := OrderDetGrid.MouseCoord(X, Y);
    if (aCell.X >= 0) and (aCell.Y > 0) then
      OrderDetGrid.BeginDrag(False, 10);
  end
end;

procedure TMain.OrderDetGridStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  Cursor := crDrag;
end;

procedure TMain.OrderDetGridTitleClick(Column: TColumnEh);
begin
  if Column.Index = 0 then
    if OrderDetGrid.Columns.Items[0].Title.ImageIndex = 2 then
    begin
      main.ClearSelection;//Data.masChek.Clear;
      OrderDetGrid.Columns.Items[0].Title.ImageIndex := 3;
      Data.OrderDetTable.First;
      while not Data.OrderDetTable.Eof  do
      begin
        Data.masChek.Add(Pointer(Data.OrderDetTable.FieldByName('id').AsInteger));
        Data.OrderDetTable.Next;
      end;
    end
    else
    ClearSelection;
   { begin
      OrderDetGrid.Columns.Items[0].Title.ImageIndex := 2;
      Data.masChek.Clear;
    end;                 }
  Data.OrderDetTable.Refresh;

  if not Column.Title.TitleButton then
    exit;

  case Column.Title.SortMarker of
    smNoneEh:
    begin
      Column.Title.SortMarker := smUpEh;
      Data.OrderDetTable.IndexName := Column.FieldName;
    end;
    
    smUpEh: 
    begin
      Column.Title.SortMarker := smDownEh;
      Data.OrderDetTable.IndexName := 'D' + Column.FieldName;
    end;
    
    smDownEh:
    begin
      Column.Title.SortMarker := smNoneEh;
      Data.OrderDetTable.IndexName := 'Order';
    end;
  end;
end;

procedure TMain.OrderGridCellClick(Column: TColumnEh);
begin
  //main.OrderDetGrid.SelectedRows.clear;
  if SameText(Column.FieldName, 'Sent') and (Data.OrderTable.FieldByName('Sent').AsString = '4') then
    ApplyOrderAnswer;
{  if SameText(Column.FieldName, 'Popular') then
  begin
    Data.OrderTable.Edit;
    Data.OrderTable.FieldByName('Popular').asBoolean := not Data.OrderTable.FieldByName('Popular').asBoolean;
    Data.OrderTable.Post;
    Data.OrderTable.Refresh;
    OrderGrid.Refresh;
    //ShowMessage(Data.OrderTable.FieldByName('date').asString + Data.OrderTable.FieldByName('Popular').asString);
    //Data.OrderTable.Resync([rmCenter]);
   // ShowMessage(Data.OrderTable.FieldByName('date').asString + Data.OrderTable.FieldByName('Popular').asString);

  end;   }
end;

procedure TMain.OrderGridDblClick(Sender: TObject);
begin
  MainActionExecute(EditOrderAction)
end;


procedure TMain.OrderGridDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  i:integer;
  fExit : boolean;
  //---
  gc: TGridCoord;
  rn1, rn2: integer;
  new_ord_id: integer;
  new_ord_info: string;
  old_ord_info: string;
begin
  fExit := false;
  if Data.OrderTable.FieldByName('Sent').AsString <> '' then
    if (Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
    begin
      MessageDlg('Невозможно выполнить действие!!!'+
                   ' Заказ уже был отправлен в офис компании и вероятно уже обработан.',  mtInformation, [mbOK], 0);
      ClearSelection;
      Data.OrderDetTable.Resync([rmCenter]);
      exit;
    end;

  fClearSelection := false;
  if Source = OrderDetGrid then
  begin
    gc := OrderGrid.MouseCoord(X, Y);
    if (gc.Y = OrderGrid.Row) or (gc.Y = 0) or (gc.Y = -1) then
      Exit;
    old_ord_info := Data.OrderTable.FieldByName('Date').AsString + '/' +
                    Data.OrderTable.FieldByName('Num').AsString;
    rn2  := Data.OrderDetTable.RecNo;
    rn1  := Data.OrderTable.RecNo;
    try
      Data.OrderTable.RecNo := OrderGrid.DataRowToRecNo(gc.Y - 1);

      if (Data.OrderTable.FieldByName('Sent').AsString <> '') then
        if (Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
        begin
          fExit := true;
          ClearSelection;
          exit;
        end;

      new_ord_id   := Data.OrderTable.FieldByName('Order_id').AsInteger;
      new_ord_info := Data.OrderTable.FieldByName('Date').AsString + '/' +
                      Data.OrderTable.FieldByName('Num').AsString;



    finally
        Data.OrderTable.RecNo := rn1;
        Data.OrderDetTable.RecNo := rn2;
    if fExit then
        MessageDlg('Невозможно выполнить действие!!!'+
                 ' Заказ уже был отправлен в офис компании и вероятно уже обработан.',  mtInformation, [mbOK], 0);

    end;
    fOrderMasCheck := true;
    with TQuantityMoveEdit.Create(Application) do
    try
      if Data.masChek.Count = 0 then
        Data.masChek.Add(Pointer(rn2));
      for i := 0 to Data.masChek.Count - 1 do
      begin
        data.OrderDetTable.Locate('ID', Integer(data.masChek.Items[i]), []);
        MemoryTable.Append;
        MemoryTable.FieldByName('ID').AsInteger := Data.OrderDetTable.FieldByName('ID').AsInteger;
        MemoryTable.FieldByName('Code2').AsString := Data.OrderDetTable.FieldByName('Code2').AsString;
        MemoryTable.FieldByName('Brand').AsString := Data.OrderDetTable.FieldByName('Brand').AsString;
        MemoryTable.FieldByName('pos_info').AsString := Data.OrderDetTable.FieldByName('ArtCode').AsString;
        MemoryTable.FieldByName('price').AsCurrency:= Data.OrderDetTable.FieldByName('Price').AsCurrency;
        MemoryTable.FieldByName('kol').AsFloat:= Data.OrderDetTable.FieldByName('Quantity').AsFloat;
        MemoryTable.FieldByName('kolMax').AsFloat:= Data.OrderDetTable.FieldByName('Quantity').AsFloat;
        MemoryTable.FieldByName('Mult').AsInteger:= Data.OrderDetTable.FieldByName('Mult').AsInteger;
        memoryTable.post;
      end;
      OrderInfo1.Text := Old_ord_info;
      OrderInfo2.Text := New_ord_info;
 //------------------------

      if ShowModal = mrOk then
      begin
        memorytable.First;
        while not MemoryTable.Eof  do
        begin
          data.OrderDetTable.Locate('ID', MemoryTable.FieldByName('ID').AsInteger, []);
          if MemoryTable.FieldByName('kol').AsFloat =  data.OrderDetTable.FieldByName('Quantity').AsFloat then
          begin
            Data.OrderDetTable.Edit;
            Data.OrderDetTable.FieldByName('Order_id').Value := new_ord_id;
            Data.OrderDetTable.Post;
          end
          else
          begin
            Data.OrderDetTable.Edit;
            Data.OrderDetTable.FieldByName('Quantity').Value := Data.OrderDetTable.FieldByName('Quantity').Value - MemoryTable.FieldByName('kol').AsFloat;
            Data.OrderDetTable.Append;
            Data.OrderDetTable.FieldByName('Order_id').Value := new_ord_id;
            Data.OrderDetTable.FieldByName('Code2').Value    := MemoryTable.FieldByName('code2').AsString;
            Data.OrderDetTable.FieldByName('Brand').Value    := MemoryTable.FieldByName('brand').AsString;
            Data.OrderDetTable.FieldByName('Quantity').Value := MemoryTable.FieldByName('kol').AsString;
            Data.OrderDetTable.FieldByName('Price').Value    := MemoryTable.FieldByName('price').AsCurrency;
            CalcProfitPriceForOrdetDetCurrent;
            Data.OrderDetTable.Post;
          end;
          MemoryTable.Next;
        end;
      end;
      fClearSelection := true;
      ClearSelection;// Data.masChek.Clear;
      Data.OrderDetTable.Resync([rmCenter]);
      with Data.OrderTable do
      begin
        Data.OrderTable.Edit;
        Data.OrderTable.FieldByName('Dirty').Value := True;
        Data.OrderTable.Post;
        Data.OrderTable.Refresh;
      end;
      Data.OrderTableAfterScroll(Data.OrderTable);

    finally
      Free;
    end
  end
  else if Source = MainGrid then
  begin
    gc := OrderGrid.MouseCoord(X, Y);
    if (gc.Y = OrderGrid.Row) or (gc.Y = 0) or (gc.Y = -1) then
      exit;
    Data.OrderTable.RecNo := OrderGrid.DataRowToRecNo(gc.Y - 1);
    AddToOrder;
  end;

end;

procedure TMain.OrderGridDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if (Source = OrderDetGrid) or (Source = MainGrid) then
    Accept := True;
end;

procedure TMain.OrderGridGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  if Data.OrderTable.FieldByName('Sent').AsString = '4' then
    Background := $00D1FFC1;
end;

procedure TMain.OrderGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    MainActionExecute(EditOrderAction)
  else if Key = VK_INSERT then
    MainActionExecute(NewOrderAction)
  else if Key = VK_DELETE then
    MainActionExecute(DelOrderAction)
end;

procedure TMain.OrderPopupActionsPopup(Sender: TObject);
begin
  acShowOrdersInPofitPrices.Checked := Data.ParamTable.FieldByName('bCalcOrderWithMargin').AsBoolean;
end;

procedure TMain.OrderPopupMenuPopup(Sender: TObject);
begin
  acShowOrdersInPofitPrices.Checked := Data.ParamTable.FieldByName('bCalcOrderWithMargin').AsBoolean;
end;

procedure TMain.miGroupsActionMeasureItem(Sender: TObject; ACanvas: TCanvas; var Width,
  Height: Integer);
begin
  Width := tbTree.Width;
end;

//фильтр по ОЕ-номеру
procedure TMain.miOESetFilterOEClick(Sender: TObject);
begin
  SetCurrentFilter(fURL_OE, 2);
  LoadTDInfoTimerTimer(nil); //чтобы обновилась подсветка OE номеров
end;

//копировать ОЕ-номер
procedure TMain.miOECopyClick(Sender: TObject);
begin
  Clipboard.AsText := fURL_OE;
end;

//фильтр по всем номерам
procedure TMain.miOESetFilterAllClick(Sender: TObject);
begin
  SetCurrentFilter(fURL_OE, 4);
end;


procedure TMain.nPriceProClick(Sender: TObject);

  function FindCol(aGrid: TDBGridEh; const aFieldName: string): TColumnEh;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to aGrid.Columns.Count - 1 do
      if SameText(aGrid.Columns[i].FieldName, aFieldName) then
      begin
        Result := aGrid.Columns[i];
        Break;
      end;
  end;

  procedure ChangeField(aCol: TColumnEh; const aNewFieldName: string; const aNewCaption: string = '');
  var
    aWidth: Integer;
  begin
    if Assigned(aCol) then
    begin
      aWidth := aCol.Width;
      aCol.FieldName := aNewFieldName;
      aCol.Width := aWidth;
      if aNewCaption <> '' then
        aCol.Title.Caption := aNewCaption;
    end;
  end;

begin
  KitGridEh.Columns.BeginUpdate;
  KitGridEh.AutoFitColWidths := False;
  try
    if nPricePro.Checked then
    begin
      ChangeField(FindCol(KitGridEh, 'Price_koef'), 'PriceProEur', 'Цена с нац.');
      ChangeField(FindCol(KitGridEh, 'Price_koef_sum'), 'PriceProEur_sum', 'Сумма с нац.');
    end
    else
    begin
      ChangeField(FindCol(KitGridEh, 'PriceProEur'), 'Price_koef', 'Цена');
      ChangeField(FindCol(KitGridEh, 'PriceProEur_sum'), 'Price_koef_sum', 'Сумма');
    end;
    CurrencyChanged;
  finally
    KitGridEh.AutoFitColWidths := True;
    KitGridEh.Columns.EndUpdate;
  end;
end;

procedure TMain.N130Click(Sender: TObject);
var
 FullProgPath: PChar;
 si: TStartUpInfo;
 pi: TProcessInformation;
begin
  try
    Main.Close;
  finally
    if fCanClose then
    begin
      FullProgPath:=PChar(Application.ExeName + ' -ServiceMode='+ IntToStr(GetCurrentProcessId));
      ZeroMemory(@si, SizeOf(si));
      ZeroMemory(@pi, SizeOf(pi));
      with si do
      begin
        cb := SizeOf(si);
        dwFlags := STARTF_USESHOWWINDOW;
        wShowWindow := SW_HIDE;
        hStdInput := 0;
      end;

      if not CreateProcess(nil, FullProgPath, nil, nil, FALSE, 0, nil, PChar(GetAppDir), si, pi) then
        ShowMessage( SysErrorMessage(GetLastError) );
    end;
  end;
end;

procedure TMain.N132Click(Sender: TObject);
var
  aUser: TUserIDRecord;
begin
  aUser := GetCurrentUser;
  if not Assigned(aUser) then
  begin
    ShowMessage('Не указан идентификатор клиента.');
    Exit;
  end;
  
  with TContractsForm.Create(Application) do
  try
    btSetDefContr.Hide;
    Client := aUser.sID;
    SetClientFilter;
    ShowModal;
  finally  
    Free;
  end;
end;

procedure TMain.LightQuantsAdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; State: TOwnerDrawState);
begin
  DrawLights(State, ACanvas, ARect, 'Остатки', fFlagsUpdateByLight.bNeedUpdateQuants);
end;

procedure TMain.LightQuantsClick(Sender: TObject);
begin
  DoWebUpdate();
end;

procedure TMain.LightProgAdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; State: TOwnerDrawState);
begin
  DrawLights(State, ACanvas, ARect, 'Программа', fFlagsUpdateByLight.bNeedUpdateProg);
end;

procedure TMain.LightProgClick(Sender: TObject);
begin
  DoWebUpdate();
end;

procedure TMain.LightDataAdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; State: TOwnerDrawState);
begin
  DrawLights(State, ACanvas, ARect, 'Данные', fFlagsUpdateByLight.bNeedUpdateData);
end;

procedure TMain.LightDataClick(Sender: TObject);
begin
  DoWebUpdate();
end;

procedure TMain.N9Click(Sender: TObject);
begin
  Data.GoToSelectItem;
end;


procedure TMain.NewAboutProgrammExecute(Sender: TObject);
begin
 if FileExists(GetAppDir + 'About.html') then //and (not isOpenedMoreThan2Windows('Info')) then
   with TInfo.Create(Application) do
    begin
      Caption := 'Новинки программы';
      Browser.Navigate(GetAppDir + 'About.html');
      HideNewInProg.Visible := True;
      HideCheckBox.Visible := False;
      ShowModal;
      Free;
    end;
end;

function TMain.NewReturnDoc(fDefect: boolean = FALSE): Boolean;
var
  LastNum: integer;
  UserData:TUserIDRecord;
begin
  Result := False;
  if not CheckClientId then
    Exit;

  UserData := GetCurrentUser;

  if DateStartReturnDoc.Date > Date then
    DateStartReturnDoc.Date := Date;

  DateEndReturnDoc.Date := Date;
  with Data.ReturnDocTable do
  begin
  {
    if IndexName <> 'Cli_Date' then
      IndexName := 'Cli_Date';
    SetRange( [UserData.sId, DateStartReturnDoc.Date], [UserData.sId, DateEndReturnDoc.Date]);
    Last;
  }
    LastNum := StrToIntDef( Data.ExecuteSimpleSelect('SELECT Max(Num) FROM [036] WHERE CLI_ID = :CLI_ID AND DATA = :DATA', [UserData.sId, Date], True), 0 ) ;
  {
    if not EOF then
    begin
      if FieldByName('Data').AsDateTime = Date then
        LastNum := FieldByName('Num').AsInteger
      else
        LastNum := 0;
    end
    else
    begin
        LastNum := 0;
    end;
  }
    Append;
    FieldByName('Data').Value := Date;
    FieldByName('Num').Value := LastNum + 1;
    FieldByName('Post').Value := 0;
    FieldByName('Cli_id').Value := UserData.sId;
    FieldByName('Type').Value := UserData.sOrderType;
    if (Trim(FieldByName('Type').AsString) <> 'A')and(Trim(FieldByName('Type').AsString) <> 'B') then
      FieldByName('Type').Value := 'A';
    FieldByName('Post').Value := 0;
    FieldByName('delivery').AsInteger := UserData.iDelivery;
    if fDefect then
    begin
      FieldByName('fDefect').AsBoolean := TRUE;
      FieldByName('reason').AsString := 'ret';
    end;
  {  else
    if MessageDlg('Оформить возврат по причине брака продукции?', mtInformation,[mbYes, mbNo], 0) = mrYes then
    begin
      FieldByName('fDefect').AsBoolean := TRUE;
      FieldByName('reason').AsString := 'ret';
    end;}
    Post;
  end;
  Result := TRUE;
end;

function TMain.ReplaceLeftSymbolAB(sValue:string):string;
  var sRet:string;
      iPos:integer;
begin
   sRet := '';
   for iPos := 1 to Length(sValue) do
    if((sValue[iPos] >= '0') and (sValue[iPos] <= '9'))
       or ((sValue[iPos] >= 'a') and (sValue[iPos] <= 'z'))
       or ((sValue[iPos] >= 'A') and (sValue[iPos] <= 'Z'))  then
          sRet := sRet+sValue[iPos];
   ReplaceLeftSymbolAB := sRet;
end;


function TMain.ReplaceLeftSymbol(sValue:string):string;
  var sRet:string;
      iPos:integer;
begin
   sRet := '';
   for iPos := 1 to Length(sValue) do
    if(sValue[iPos] >= '0') and (sValue[iPos] <= '9') then
      sRet := sRet+sValue[iPos];

   ReplaceLeftSymbol := sRet;
end;

function TMain.NewOrder: Boolean;
var
  LastNum: integer;
  UserData: TUserIDRecord;
begin
  Result := FALSE;

  if not CheckClientId then
    Exit;

  UserData := GetCurrentUser;

  if(UserData.sId <> ReplaceLeftSymbol(UserData.sId)) then
  begin
    MessageDlg('Проверьте идентификатор текущего клиента!', mtInformation, [mbOK], 0);
    Exit;
  end;

  if OrderDateEd1.Date > Date then
    OrderDateEd1.Date := Date;
  OrderDateEd2.Date := Date;

  // !!! - переустанавливать OrderTable.Range после OrderDateEd1.Date := Date;
  UpdateOrdersFilter(UserData);

  with Data.OrderTable do                 
  begin
  {
    SetRange([UserData.sId,OrderDateEd1.Date], [UserData.sId,OrderDateEd2.Date]);
    Last;
    if FieldByName('Date').AsDateTime = Date then
      LastNum := FieldByName('Num').AsInteger
    else
      LastNum := 0;
  }
    LastNum := StrToIntDef( Data.ExecuteSimpleSelect('SELECT Max(Num) FROM [009] WHERE CLI_ID = :CLI_ID AND DATE = :DATE', [UserData.sId, Date], True), 0 ) ;

    Append;
    FieldByName('Date').Value := Date;
    FieldByName('Num').Value := LastNum + 1;
    FieldByName('Sent').Value := 0;
    if Data.IsRusRegionCode(UserData.sID, '') then
      FieldByName('Currency').Value := 4
    else
      FieldByName('Currency').Value := 2;       
    FieldByName('Cli_id').Value := UserData.sId;
    FieldByName('Type').Value   := UserData.sOrderType;
    FieldByName('Delivery').Value := UserData.iDelivery;
    if (Trim(FieldByName('Type').AsString) <> 'A')and(Trim(FieldByName('Type').AsString) <> 'B') then
      FieldByName('Type').Value := 'A';
    FieldByName('State').Value := 0;

    if Data.ContractsCliTable.Locate('Cli_id;Contract_Id',VarArrayOf([UserData.sID,
                  UserData.ContractByDefault]), []) then
    begin
      FieldByName('Agreement_No').AsString := Data.ContractsCliTable.FieldByName('Contract_Id').AsString;
      FieldByName('addres_id').AsString := UserData.AddresByDefault;
      FieldByName('AgrGroup').AsString := Data.ContractsCliTable.FieldByName('Group').AsString;
      FieldByName('AgrDescr').AsString := GetMaskEdDir;
    end;
    Post;
  end;
  ZakTabInfo;
  SetActionEnabled;
  Result := TRUE;
end;

procedure TMain.NewReturnDocActionExecute(Sender: TObject);
var
  iUser: TUserIDRecord;
  fgoodClose: boolean;
begin
  // новый возврат
 if not NewReturnDoc then
        exit;
  with TReturnDocED.Create(nil) do
  begin
    iUser := GetCurrentUser;
    Data.ContractsCliTable.Filtered := False;
    Data.ContractsCliTable.CancelRange;
{    if Data.ClIDsTable.Locate('client_id', Data.ReturnDocTable.FieldByName('cli_id').AsString, []) then
      Cli_id := Data.ClIDsTable.FieldByName('id').AsInteger;
 }

    if Data.ContractsCliTable.Locate('Cli_id;Contract_Id',VarArrayOf([iUser.sId,iUser.ContractByDefault]), []) then
    begin
      Data.ReturnDocTable.Edit;
      Data.ReturnDocTable.FieldByName('Agreement_No').AsString := Data.ContractsCliTable.FieldByName('Contract_Id').AsString;
      Data.ReturnDocTable.FieldByName('AgrDescr').AsString := Main.GetMaskEdDir;
      Data.ReturnDocTable.FieldByName('AgrGroup').AsString := Data.ContractsCliTable.FieldByName('Group').AsString;
      Data.ReturnDocTable.Post;
    end;

    VisibleClientCombo(SameText(Data.ReturnDocTable.FieldByName('AgrGroup').AsString,'БН') or SameText(Data.ReturnDocTable.FieldByName('AgrGroup').AsString,''));
    repeat
      ShowModal;
      fGoodClose := FALSE;
      if ModalResult <> mrOk then
      begin
        if not Data.ReturnDocTable.EOF then
          Data.ReturnDocTable.Delete;
      end
      else
      begin
        if (length(Data.ReturnDocTable.FieldByName('AgrDescr').AsString) < 1)
            or ((FakeAddresDescr.Visible) and (Length(Data.ReturnDocTable.FieldByName('FakeAddresDescr').AsString)< 1))
            or ((Phone.Visible) and (Length(TrimAll(Phone.Text)) < MIN_LENGTH_PHONE))
            or ((Name.Visible) and (Length(Data.ReturnDocTable.FieldByName('Name').AsString)< MIN_LENGTH_NAME))
            or ((Data.ReturnDocTable.FieldByName('fDefect').AsBoolean) and (length(Data.ReturnDocTable.FieldByName('Note').AsString) < 1))  then
        begin
          MessageDlg('Заполните все обязательные поля, иначе заказ не будет сохранен! ФИО и телефон должны соответствовать формату!', mtError, [mbYes], 0);
          fGoodClose := TRUE;
        end
        else
          TrimField(Data.ReturnDocTable, 'Phone');
      end;
    until not fGoodClose;
  end;
  Data.ReturnDocTable.Refresh;
end;

procedure TMain.ZakTabInfo;
var
  aSumField: string;
begin
  if not Assigned(Data) then
    Exit;

  with Data.OrderTable do
  begin
    if Data.ParamTable.FieldByName('bCalcOrderWithMargin').AsBoolean then
      aSumField := 'sum_pro'
    else
      aSumField := 'sum';

    if FieldByName('Order_id').AsInteger <> 0 then
      Main.CatZakPage.Caption := 'Заказ [' + FieldByName('ClientInfo').AsString + '] ' +
                      FieldByName('Date').AsString + '/' +
                      FieldByName('Num').AsString +
                      FieldByName('Type').AsString + ' из ' +
                      FieldByName('Pos').AsString + ' поз. на сумму: ' +
                      FieldByName(aSumField).AsString
      else
         Main.CatZakPage.Caption := 'Заказы';
      SetActionEnabled;

     // if FieldByName('Order_id') then

    pnDelivery.Visible := FieldByName('IsDeliveredCalc').AsBoolean;
    lbDeliveryNum.Caption := 'Телефон отдела доставки: ' + Data.SysParamTable.FieldByName('DeliveryPhone').AsString;
    lbOrderNum.Caption := ' №' + FieldByName('LotusNumber').AsString;
  end;

  if not Data.fOrderTableInAfterScroll then
    CountingOrderSum;

  {$IFNDEF LOCAL}
  OrderFlame(False);
  lbOrderFlame.Visible := False;
  OrderWarnTimer.Enabled := False;
  
  if Data.ParamTable.FieldByName('bWarnOrderLimits').AsBoolean then
  begin
    if not (
       (Data.OrderTable.FieldByName('Sent').AsString = '1') or
       ( (Data.OrderTable.FieldByName('Sent').AsString = '3') and (not Data.OrderTable.FieldByName('Sent_time').IsNull) )
    ) then
      if Data.OrderDetTable.RecordCount > cMaxOrderDetCount then
      begin
        OrderWarnTimer.Enabled := True;
        lbOrderFlame.Visible := True;
      end;
  end;
  {$ENDIF}
end;

procedure TMain.OrderFlame(aFlamed: Boolean);
begin
  if aFlamed then
  begin
//    OrderDetGrid.Color := clRed;
//    AdvToolBarButton5.ParentStyler := False;
    CatZakPage.ImageIndex := 61;
    pnOrderFlame.Color := $004066FF;
    lbOrderFlame.Font.Color := $004066FF;
  end
  else
  begin
//    OrderDetGrid.Color := clWindow;
//    AdvToolBarButton5.ParentStyler := True;
    CatZakPage.ImageIndex := 14;
    pnOrderFlame.Color := clGray;
    lbOrderFlame.Font.Color := clWindowText;
  end;
end;




procedure TMain.AnalogGridDblClick(Sender: TObject);
begin
  MainActionExecute(AddAnToOrderAction);
end;


procedure TMain.AnalogGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
begin
  if SameText(Column.FieldName, 'Quantity') then
  begin
    if AnalogGrid.DataSource.DataSet.FieldByName('OrderOnly').AsBoolean then
    begin
      DrawOrderOnlyField(AnalogGrid, Rect, State, AnalogGrid.DataSource.DataSet.FieldByName('Quantity').AsString);
    end
    else
      if AnalogGrid.DataSource.DataSet.FieldByName('QuantLatest').AsInteger = 1 then
      begin
        NewImageList.Draw(AnalogGrid.Canvas, Rect.Right - NewImageList.Width, Rect.Top, 1);
      end;
  end;
end;

procedure TMain.AnalogGridEnter(Sender: TObject);
begin
  Data.AnalogTableAfterScroll(Data.AnalogTable);
  Data.AnalogTable.AfterScroll := Data.AnalogTableAfterScroll;
//  Main.ShowStatusBarInfo2;
end;

procedure TMain.AnalogGridExit(Sender: TObject);
begin
  Data.AnalogTable.AfterScroll := nil;
end;

procedure TMain.AnalogGridGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
var
  i: integer;
begin
  with AnalogGrid.DataSource.DataSet do
  begin
    if FieldByName('SaleQ').AsString = '1' then
    begin
      if (not SCellColor) or (Column.FieldName = 'Price_koef') then
      begin
        AFont.Assign(SaleFont);
        Background := SaleBackgr;
      end;
    end
    else if (not QCellColor) or (Column.FieldName = 'Quantity') then
    begin
      if not FieldByName('OrderOnly').AsBoolean then
      begin
        if FieldByName('Quantity').AsString = '' then
        begin
          AFont.Assign(NoQuantFont);
          Background := NoQuantBackgr;
        end
        else
        begin
          for i := 0 to Length(TextAttrList) - 1 do
          begin
            if (StrInt(FieldByName('Quantity').AsString) >= TextAttrList[i].Lo) and
               (StrInt(FieldByName('Quantity').AsString) <= TextAttrList[i].Hi) then
            begin
              AFont.Assign(TextAttrList[i].Font);
              Background := TextAttrList[i].Background;
              break;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TMain.AnalogGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_RETURN, VK_INSERT] then
  begin
    if ssCtrl in Shift then
      MainActionExecute(AddAnToWaitListAction)
    else
      MainActionExecute(AddAnToOrderAction);
  end
  else if Key = VK_SPACE then
    MainActionExecute(GoToAnalogAction);
end;

procedure TMain.AnalogGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ClearSearchMode;
end;

procedure TMain.AnalysisLoadedDataExecute(Sender: TObject);
var fname:string;
    CsvFile:TextFile;
    br, sgr, gr, iCount, iTecDoc:integer;
    br_node, subgroup_descr :string;
begin
 

   fname := 'Cat';
   with SaveOrderDialog do
    begin
      FileName   := fname;
      if not Execute then
        exit;
      fname := FileName;
    end;

    Data.CatalogTable.DisableControls;
    Data.CatalogTable.IndexName := 'BrCode';

    AssignFile(CsvFile,fname );
    Rewrite(CsvFile);
    Data.GroupBrandTable.open;
    Data.GroupBrandTable.IndexName := 'BrGroup';
    with Data.BrandTable do
    begin
      first;
      while not Eof do
      begin
        br := FieldByName('Brand_id').AsInteger;
        br_node := FieldByName('Description').AsString;
        Writeln(CsvFile,br_node);
        with Data.GroupBrandTable do
          begin
          Data.GroupBrandTable.SetRange([br], [br]);
          //Writeln(CsvFile,br_node);
          First;
          while not Eof do
          begin
            gr := FieldByName('Group_id').AsInteger;
            while (not Eof) and (FieldByName('Group_id').AsInteger = gr) do
            begin
              sgr := FieldByName('Subgroup_id').AsInteger;
              Data.GroupTable.FindKey([gr, sgr]);
              subgroup_descr :=Data.GroupTable.FieldByName('subgroup_descr').AsString;
              with Data.CatalogTable do
              begin
                iCount := 0;
                iTecDoc := 0;
                CancelRange;
                SetRange([1, br, gr, sgr], [1, br, gr, sgr]);
                first;
                while not Data.CatalogTable.EOF do
                begin
                iCount:=iCount+1;
                  if FieldByName('Tecdoc_id').AsInteger > 0 then
                    iTecDoc := iTecDoc +1;
                  Next;
                end;

                Writeln(CsvFile,br_node+';'+subgroup_descr+';'+inttostr(iCount)+';'+inttostr(iTecDoc));
              end;
             Next;
            end;
            Next;
          end;
          CancelRange;
        end;
        Next;
      end;
    end;
    Data.GroupBrandTable.Close;
    CloseFile(CsvFile);
    Data.CatalogTable.EnableControls;
    MessageDlg('Выполнено!', mtInformation, [mbOk],0);
end;

procedure TMain.AppClose;
{var iniDiscount:TIniFile;
    sFileName:string;
    i:integer; }
begin
 { sFileName := GetAppDir + 'Discount.ini';
  if FileExists(sFileName) then
    DeleteFile(sFileName);

  if not FileExists(sFileName) then
  begin
    iniDiscount := TiniFile.Create(sFileName);
    i:=1;
    with Data.BrandTable do
    begin
      First;
      while not EOF do
      begin
          if FieldByName('Discount').AsString <> '' then
            iniDiscount.WriteString(FieldByName('Description').AsString,'Discount',FieldByName('Discount').AsString);
          if FieldByName('My_brand').AsString = 'True' then
            iniDiscount.WriteString(FieldByName('Description').AsString,'My_brand',FieldByName('My_brand').AsString);
          Next;
      end;
    end;


    with Data.MyGroupTable do
    begin
      if not Active then
        Open;
      if IndexName <> 'GrDescr' then
         IndexName := 'GrDescr';
      First;
      i:=1;
      while not EOF do
      begin
          iniDiscount.WriteString('Croupe',inttostr(i)+'_Group_descr',FieldByName('Group_descr').AsString);
          iniDiscount.WriteString('Croupe',inttostr(i)+'_Subgroup_descr',FieldByName('Subgroup_descr').AsString);
          i:=i+1;
      
        Next;
      end;
      Close;
    end;
  end
    iniDiscount.Free; }
  Data.Free;                      // закрываем БД
  RestDateFormat;                 // восстанавливаем формат даты
  Application.Terminate;          // останавливаем приложение
  //Halt(1);
end;


procedure TMain.ApplicationEventsActivate(Sender: TObject);
begin
  if Assigned(fPopupRss) and (fPopupRss.Showing) then
  begin
    BringToFrontRss;
  end;
end;

procedure TMain.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  StdErr(Sender, E);
end;

procedure TMain.ApplicationEventsMessage(var Msg: tagMSG; var Handled: Boolean);
begin
  case Msg.Message of
    WM_KEYDOWN, {WM_LBUTTONDOWN, }WM_RBUTTONDOWN, WM_MBUTTONDOWN,
    {WM_MOUSEWHEEL, }WM_NCLBUTTONDOWN, WM_NCRBUTTONDOWN, WM_NCMBUTTONDOWN:
    begin
      UBallonSupport.SetBallon(nil);
    end;
    WM_LBUTTONDOWN, WM_LBUTTONUP:
    begin
      UBallonSupport.SetBallonMessage(Msg);
      if Msg.Message = WM_LBUTTONUP then
        UBallonSupport.SetBallon(nil);
    end;
  end;
end;

procedure TMain.ApplicationEventsRestore(Sender: TObject);
begin
  if Assigned(Splash) and (Application.MainForm = nil) then
    ShowWinNoAnimate(Splash.Handle, SW_RESTORE);
end;

procedure TMain.AppStylerChange(Sender: TObject);
begin
  MainGridPanel.Caption.Height := 23;
  MainGridPanel.Caption.TopIndent := 3;

  //for redraw menu
  //MainMenu.BeginUpdate;
  //MainMenu.EndUpdate;

  ToolBarStylerCustom.DragGripStyle := dsNone;

  ToolPanelTree.FocusCaptionColor := ToolPanelTree.NoFocusCaptionColor;
  ToolPanelTree.FocusCaptionColorTo := ToolPanelTree.NoFocusCaptionColorTo;
  ToolPanelTree.FocusCaptionFontColor := ToolPanelTree.NoFocusCaptionFontColor;

  ToolPanelNotepad.FocusCaptionColor := ToolPanelNotepad.NoFocusCaptionColor;
  ToolPanelNotepad.FocusCaptionColorTo := ToolPanelNotepad.NoFocusCaptionColorTo;
  ToolPanelNotepad.FocusCaptionFontColor := ToolPanelNotepad.NoFocusCaptionFontColor;

  SplitterLeft.Appearance.Color := clGray;
  SplitterLeft.Appearance.ColorTo := clGray;
  SplitterLeft.Appearance.ColorHot := $0076C1FF;
  SplitterLeft.Appearance.ColorHotTo := $0076C1FF;

  SplitterRight.Appearance.Color := clGray;
  SplitterRight.Appearance.ColorTo := clGray;
  SplitterRight.Appearance.ColorHot := $0076C1FF;
  SplitterRight.Appearance.ColorHotTo := $0076C1FF;
end;

procedure TMain.AssortmentExpansionGridEhDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if Source <> MainGrid then
    exit;
  AddAssortmentExpansion.Execute;
end;

procedure TMain.AssortmentExpansionGridEhDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if Source = MainGrid then
    Accept := True;
end;

procedure TMain.AssortmentExpansionGridEhGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if (Data.AssortmentExpansion.FieldByName('ArtQuant').AsString <> '') and
     (Data.AssortmentExpansion.FieldByName('ArtQuant').AsString <> '0') then
  begin
    AFont.Style := [fsBold];
    Background := clSilver;
  end;
end;

procedure TMain.AssortmentExpansionGridEhKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    DelFromAssortiment.Execute
  else if Key = VK_SPACE then
    MoveToAssortimentExpansionPos.Execute;
end;

procedure TMain.AssortmentExpansionTimerTimer(Sender: TObject);
begin
if AssortmentExpansionPage.ImageIndex = 47 then
    AssortmentExpansionPage.ImageIndex := 45
  else
    AssortmentExpansionPage.ImageIndex := 47;
  AssortmentExpansionTimer.Enabled := TRUE;
//    AssortmentExpansionTimer
end;

procedure TMain.CarOptionsDataExecute(Sender: TObject);
var fname:string;
    CsvFile:TextFile;
begin
   fname := 'Cat';
   with SaveOrderDialog do
    begin
      FileName   := fname;
      if not Execute then
        exit;
      fname := FileName;
    end;

    AssignFile(CsvFile,fname );
    Rewrite(CsvFile);
    Data.CatTypDetTable.DisableControls;
    Data.CatalogDataSource.DataSet.DisableControls;
    with (Data.CatalogDataSource.DataSet as TDBISAMTABLE)do
    begin
        CancelRange;
        first;
        while not Data.CatalogDataSource.DataSet.EOF do
        begin
           with Data.CatDetTable do
           begin
             First;
             CancelRange;
             SetRange([Data.CatalogDataSource.DataSet.FieldByName('param_tdid').AsInteger], [Data.CatalogDataSource.DataSet.FieldByName('param_tdid').AsInteger]);
             while not EOF do
              begin
               Writeln(CsvFile,Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString+';'+Data.CatalogDataSource.DataSet.FieldByName('Code').AsString+';'+FieldByName('ParamDescr').AsString+';'+FieldByName('Param_value').AsString);
               Next;
              end;
           end;

           if FieldByName('param_tdid').AsInteger > 0 then
           begin
              with Data.CatTypDetTable do
              begin
                 CancelRange;
                 SetRange([Data.CatalogDataSource.DataSet.FieldByName('param_tdid').AsInteger], [Data.CatalogDataSource.DataSet.FieldByName('param_tdid').AsInteger]);
                 First;
                 while not EOF do
                 Begin
                   Writeln(CsvFile,Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString+';'+Data.CatalogDataSource.DataSet.FieldByName('Code').AsString+';'+FieldByName('ParamDescr').AsString+';'+FieldByName('Param_value').AsString);
                 
                   Next;
                 End;
              end;
           end;
           Next;
        end;
    //          Writeln(CsvFile,br_node+';'+subgroup_descr+';'+inttostr(iCount)+';'+inttostr(iTecDoc));
    end;
    CloseFile(CsvFile);
    Data.CatTypDetTable.EnableControls;
    Data.CatalogDataSource.DataSet.EnableControls;
    MessageDlg('Выполнено!', mtInformation, [mbOk],0);
end;

procedure TMain.CatalogExportExecute(Sender: TObject);
var
  Query: TDBISAMQuery;
  StrQuery: TStringList;
begin
  StrQuery := TStringList.Create;
  Query := TDBISAMQuery.Create(nil);
  try
    MessageDlg('Данная процедура может занять не более 1 минуты времени. Пожалуйста подождите. ', mtInformation, [mbOK], 0);
    Query.DatabaseName := Data.Database.DatabaseName;
    Query.SQL.Clear;
    Query.SQL.Add('Select catal.Code, br.description as d1, catal.name, catal.description as d2 from  [002] catal '+
                  'inner join [003] br on (catal.brand_id = br.brand_id)');
    Query.ExecSQL;

    Query.First;
    while not Query.Eof do
    begin
      StrQuery.Append(Query.FieldByName('Code').AsString + '_' + Query.FieldByName('d1').AsString + ';' +
                      Query.FieldByName('Code').AsString + ';' +
                      Query.FieldByName('d1').AsString + ';' +
                      Query.FieldByName('Name').AsString + ';' + ';' +
                      Query.FieldByName('Code').AsString + '_' + Query.FieldByName('d1').AsString + ';' +
                      Query.FieldByName('d2').AsString + ';' + ';'
      );
      Query.next;
    end;
    StrQuery.SaveToFile(Data.Import_Path + 'Экспорт каталога.csv');
    MessageDlg('Экспорт завершен удачно. Файл сохранен '+ Data.Import_Path + 'Экспорт каталога.csv', mtInformation, [mbOK], 0);
  finally
    Query.free;
  end;end;

procedure TMain.CatalogPictureDblClick(Sender: TObject);
begin
  with TBigPicture.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TMain.cbFilterAnalogsClick(Sender: TObject);
begin
  if Data.ParamTable.Active then
  begin
    Data.ParamTable.Edit;
    Data.ParamTable.FieldByName('AnalogFilterEnabled').AsBoolean := cbFilterAnalogs.Checked;
    Data.ParamTable.Post;
  end;

  LoadTDInfoTimerTimer(LoadTDInfoTimer);
end;


procedure TMain.CurrencyComboBoxChange(Sender: TObject);
begin
  Data.Curr := CurrencyComboBox.ItemIndex;
  Data.SetPriceKoef;
  ShowStatusbarInfo;
  Data.ReturnDocTableBeforeScroll(Data.ReturnDocDataSource.DataSet);
end;

procedure TMain.CurrencyComboBoxCloseUp(Sender: TObject);
begin
  MainGrid.SetFocus;
end;

procedure TMain.FiltEdChange(Sender: TObject);
begin
  FiltEd.Text := RemoveExtSymb(FiltEd.Text);
  FiltModified := True;
  if FiltEd.Text <> '' then
    //FiltModeComboBox.Color := clYellow
    FiltEd.Color := clYellow
  else
    FiltEd.Color := clWindow
    //FiltModeComboBox.Color := clWindow
end;

procedure TMain.FiltEdEnter(Sender: TObject);
begin
  FiltModified := False;
end;

procedure TMain.FiltEdExit(Sender: TObject);
var
  s,s1,s2,sFilter: string;
  i:integer;
  iPos:integer;
begin
  exit;
  FiltEd.Text := AnsiUpperCase(RemoveExtSymb(FiltEd.Text));
  if IgnoreSpecialSymbolsCheckBox.Checked then
    FiltEd.Text := Data.CreateShortCode(FiltEd.Text);

  s := FiltEd.Text;
  if FiltModeComboBox.ItemIndex <> 0 then
  begin
    Data.Auto_type := 0;
    AutoPanel.Hide;
    Data.sAuto:='';
  end;

  if (Length(s)<1) then
    begin
      exit;
    end;

  i := Length(s);
  if i < 2 then
  begin
    MessageDlg('Уточните значение поиска!', mtInformation, [mbOK],0);
    Exit;
  end;

  if FiltModeComboBox.ItemIndex = 4 then
  begin
     bAbort := FALSE;
     Data.sAuto:='';
     Data.TestQuery.Close;
     Data.TestQuery.SQL.Clear;
     if IgnoreSpecialSymbolsCheckBox.Checked then
     begin
          Data.TestQuery.SQL.Add('SELECT DISTINCT [016].Cat_id FROM [016] WHERE ShortOE = '''+s+''' TOP 10000');
          Data.TestQuery.SQL.Add('UNION SELECT DISTINCT [007].Cat_id FROM [007] WHERE An_ShortCode = '''+s+'''');
          Data.TestQuery.SQL.Add('UNION SELECT DISTINCT [002].Cat_id FROM [002] WHERE ShortCode = '''+s+'''');
     end
     else
      begin
          Data.TestQuery.SQL.Add('SELECT DISTINCT [016].Cat_id FROM [016] WHERE Code2 = '''+s+''' TOP 10000');
          Data.TestQuery.SQL.Add('UNION SELECT DISTINCT [007].Cat_id FROM [007] WHERE An_code = '''+s+'''');
          Data.TestQuery.SQL.Add('UNION SELECT DISTINCT [002].Cat_id FROM [002] WHERE Code2 ='''+s+'''');
      end;

     bAbort := FALSE;
     Data.TestQuery.Open;
     if not Data.TestQuery.Eof then
      begin
            Data.sAuto:='Cat_id IN ( '+Data.TestQuery.FieldByName('Cat_id').AsString;
            Data.TestQuery.Next;
            while not Data.TestQuery.Eof do
            begin
             Data.sAuto := Data.sAuto + ', '+Data.TestQuery.FieldByName('Cat_id').AsString;
             Data.TestQuery.Next;
            end;
            Data.sAuto := Data.sAuto + ')';
          end
            else
              Data.sAuto := 'Cat_id = -1';
          Data.TestQuery.Close;
          if bAbort then
          begin
            Data.sAuto := '';
            bAbort := FALSE;
            exit;
          end;

  end;

  if FiltModeComboBox.ItemIndex = 2 then
  begin
          bAbort := FALSE;
          Data.sAuto:='';
          Data.TestQuery.Close;
          Data.TestQuery.SQL.Clear;
          if IgnoreSpecialSymbolsCheckBox.Checked then
            Data.TestQuery.SQL.Add('SELECT DISTINCT [016].Cat_id FROM [016] WHERE ShortOE LIKE('+'''%'+s+'%'') TOP 10000')
          else
            Data.TestQuery.SQL.Add('SELECT DISTINCT [016].Cat_id FROM [016] WHERE upper(Code2) LIKE('+'''%'+s+'%'') TOP 10000');
          bAbort := FALSE;
          Data.TestQuery.Open;
          if not Data.TestQuery.Eof then
          begin
            Data.sAuto:='Cat_id IN ( '+Data.TestQuery.FieldByName('Cat_id').AsString;
            Data.TestQuery.Next;
            while not Data.TestQuery.Eof do
            begin
             Data.sAuto := Data.sAuto + ', '+Data.TestQuery.FieldByName('Cat_id').AsString;
             Data.TestQuery.Next;
            end;
            Data.sAuto := Data.sAuto + ')';
          end
            else
              Data.sAuto := 'Cat_id = -1';
          Data.TestQuery.Close;
          if bAbort then
          begin
            Data.sAuto := '';
            bAbort := FALSE;
            exit;
          end;
  end;

  if FiltModeComboBox.ItemIndex = 3 then
  begin
     Data.TestQuery.Close;
     Data.TestQuery.SQL.Clear;
     if IgnoreSpecialSymbolsCheckBox.Checked then
        Data.TestQuery.SQL.Add('SELECT DISTINCT [007].Cat_id FROM [007] WHERE An_ShortCode = '''+s+'''')
     else
        Data.TestQuery.SQL.Add('SELECT DISTINCT [007].Cat_id FROM [007] WHERE An_code = '''+s+'''');
     bAbort := FALSE;
     Data.TestQuery.Active:= TRUE;

     if not Data.TestQuery.Eof then
      begin
            Data.CatalogDataSource.DataSet := Data.FilterResult;
            Data.TestQuery.Close;
            Main.HideProgress;
            exit;
            Data.sAuto := Data.sAuto + ')';
      end
          else
              Data.sAuto := 'Cat_id = -1';
          Data.TestQuery.Close;
          exit;
          if bAbort then
          begin
            Data.sAuto := '';
            bAbort := FALSE;
            exit;
          end;
  end;

  if FiltModeComboBox.ItemIndex = 1 then
  begin
     Data.TestQuery.Close;
     Data.TestQuery.SQL.Clear;
     if IgnoreSpecialSymbolsCheckBox.Checked then
        Data.TestQuery.SQL.Add('SELECT DISTINCT [002].Cat_id FROM [002] WHERE ShortCode LIKE('+'''%''+'''+s+'''+''%'')')
     else
        Data.TestQuery.SQL.Add('SELECT DISTINCT [002].Cat_id FROM [002] WHERE upper(Code2) LIKE('+'''%''+'''+s+'''+''%'')');
     bAbort := FALSE;
     Data.TestQuery.Active:= TRUE;
     if not Data.TestQuery.Eof then
      begin
            Data.sAuto:='Cat_id IN ( '+Data.TestQuery.FieldByName('Cat_id').AsString;
            Data.TestQuery.Next;
            //Data.sAuto:='Cat_id = '+Data.TestQuery.FieldByName('Cat_id').AsString;
            while not Data.TestQuery.Eof do
            begin
             Data.sAuto := Data.sAuto + ','+Data.TestQuery.FieldByName('Cat_id').AsString;
             Data.TestQuery.Next;
            end;
            Data.sAuto := Data.sAuto + ')';
          end
            else
              Data.sAuto := 'Cat_id = -1';
      Data.TestQuery.Close;

          if bAbort then
          begin
            Data.sAuto := '';
            bAbort := FALSE;
            exit;
          end;
      end;

  if FiltModeComboBox.ItemIndex = 0 then
    begin
     if Data.Auto_type < 1 then
       begin
              Main.ShowProgress('Отбор записей...');
              Data.TestQuery.Close;
              Data.TestQuery.SQL.Clear;

              sFilter:=AnsiUpperCase(Main.FiltEd.Text);
              sFilter := ReplaceStr(sFilter,' ','%');
              while(sFilter <> ReplaceStr(sFilter,':%',':')) do
                  sFilter := ReplaceStr(sFilter,':%',':');

              while(sFilter <> ReplaceStr(sFilter,'%:',':')) do
                  sFilter := ReplaceStr(sFilter,'%:',':');

              while(sFilter <> ReplaceStr(sFilter,'%%','%')) do
                 sFilter := ReplaceStr(sFilter,'%%','%');

              while '%' = Main.StrLeft(sFilter,1) do
                  sFilter := Main.StrRight(sFilter,length(sFilter)-1);

              while '%' = Main.StrRight(sFilter,1) do
                    sFilter := Main.StrLeft(sFilter,length(sFilter)-1);

              sFilter := ReplaceStr(sFilter,'''','''''');
              iPos := StrFind(sFilter,':');
              if iPos>0 then
                begin
                  s1:=Main.StrLeft(sFilter,iPos-1);
                  s2:=Main.StrRight(sFilter,Length(sFilter)-iPos);
                  if s1<> '' then
                    begin
                      s := 'upper(Name) LIKE('+'''%''+'''+s1+'''+''%'')';
                      if s2<> '' then
                       s := s + ' AND upper(Description) LIKE('+'''%''+'''+s2+'''+''%'')';
                      end
                    else
                       if s2<> '' then
                       begin
                        s := 'upper(Description) LIKE('+'''%''+'''+s2+'''+''%'')';
                       end;
                  end
                 else
                    s := 'upper(Name) LIKE('+'''%''+'''+sFilter+'''+''%'') OR upper(Description) LIKE('+'''%''+'''+sFilter+'''+''%'')';

              Data.TestQuery.SQL.Add('SELECT DISTINCT [002].Cat_id FROM [002] WHERE ' + s);
              bAbort := FALSE;
              Data.TestQuery.Active:= TRUE;
              if not Data.TestQuery.Eof then
                begin
                  Data.sAuto:='Cat_id IN ( '+Data.TestQuery.FieldByName('Cat_id').AsString;
                  Data.TestQuery.Next;
            //Data.sAuto:='Cat_id = '+Data.TestQuery.FieldByName('Cat_id').AsString;
                   while not Data.TestQuery.Eof do
                    begin
                     Data.sAuto := Data.sAuto + ','+Data.TestQuery.FieldByName('Cat_id').AsString;
                     Data.TestQuery.Next;
                    end;
                    Data.sAuto := Data.sAuto + ')';
                 end
            else
               Data.sAuto := 'Cat_id = -1';


            Data.TestQuery.Close;
            Main.HideProgress;
          if bAbort then
          begin
            Data.sAuto := '';
            bAbort := FALSE;
            s := FiltEd.Text;
            exit;
          end;
      end;
   end;

  
  s := FiltEd.Text; 
  if FiltModified and (s <> '') and
     (Data.ParamTable.FieldByName('Filt_range').AsString = '0') and
     ((Data.fBrand + Data.Group + Data.Subgroup) <> 0) then
  begin
    if Data.Tree_mode <> 3 then
      Data.fBrand    := 0;
    if Data.Tree_mode <> 2 then
      Data.Group    := 0;
    Data.Subgroup := 0;
    Main.Tree.Items[0].Selected := True;
    Data.SetCatFilter;
  end
  else
    Data.SetCatFilter;

  if s <> '' then
  with Data.SFiltTable do
  begin
    if FindKey([FiltModeComboBox.ItemIndex, s]) then
    begin
      Edit;
      FieldByName('Cnt').Value := FieldByName('Cnt').AsInteger + 1;
      Post;
    end
    else
    begin
      Append;
      FieldByName('Mode').Value    := FiltModeComboBox.ItemIndex;
      FieldByName('Text').Value    := s;
      FieldByName('Cnt').AsInteger := 1;
      Post;
    end;
  end;
  Data.FiltTable.Refresh;
  FiltEd.Text := s;
  FiltModified := False;
end;

procedure TMain.FiltEdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    MainGrid.SetFocus;
    FindFilter.Execute;
  end
  else if (Key = VK_DELETE) and (ssCtrl in Shift) and (FiltEd.Text <> '') then
  begin
    with Data.SFiltTable do
    begin
      if FindKey([FiltModeComboBox.ItemIndex, FiltEd.Text]) then
      begin
        Delete;
        FiltEd.Clear;
      end;
    end;
  end;
  Data.FiltTable.Refresh;
end;


procedure TMain.FiltModeComboBoxChange(Sender: TObject);
begin
  Data.FiltTable.SetRange([FiltModeComboBox.ItemIndex],
                          [FiltModeComboBox.ItemIndex]);
  FiltEd.Clear;
  FiltEd.Color := clWindow;
end;

procedure TMain.FiltModeComboBoxCloseUp(Sender: TObject);
begin
  FiltEd.Clear;
  //FiltModeComboBox.Color := clWindow;
  FiltEd.Color := clWindow;
  MainGrid.SetFocus;
end;

procedure TMain.FindFilterExecute(Sender: TObject);
{
  %	         - A substitute for zero or more characters
  _	         - A substitute for exactly one character
  [charlist] - Any single character in charlist - *не поддерживается DBISAM
  [^charlist] or [!charlist] - Any single character not in charlist  - *не поддерживается DBISAM
}

  function FindTires(Code: string): boolean;
  var
    ST: TStringList;
    i: integer;
    isFind: boolean;
  begin
    if pos('TIRES', Code) > 1 then
    begin
      ST := TStringList.Create;
      try
        Code := StringReplace(Code, ';', '', [rfReplaceAll]);
        ST.Add(Copy(Code, 0 , pos('TIRES', Code)-1));
        ST.Add(Copy(Code, pos('TIRES', Code) + 5, MaxInt));
        isFind := FALSE;
        for i:=0 to ST.Count -1 do
        begin
          if Data.ShortSearchTable.Locate('ShortCode', ST[i], [loPartialKey]) then
          begin
            while Copy(Data.ShortSearchTable.FieldByName('ShortCode').AsString, 1, Length(ST[i])) = ST[i]  do
            begin
                Data.sAuto := Data.sAuto + Data.ShortSearchTable.FieldByName('Cat_id').AsString + ',';
                Data.ShortSearchTable.Next;
            end;
            isFind := TRUE;
          end;
        end;

        if isFind then
        begin
          Delete(Data.sAuto, Length(Data.sAuto), 1);
          Data.sAuto:='Cat_id IN ( ' + Data.sAuto + ')';
          FiltEd.Text :=  ST[0] + ';' + ST[1];
        end
        else
        begin
          StopWait;
          if MessageDlg('По Вашему запросу ничего не найдено! Найти позицию в web-портале Шате-М Плюс?', mtInformation, [mbYes, mbNo],0) = mrYes then
            WebSearchOE(ST[0]);
          Data.TestQuery.Close;
        end;
      finally
        StopWait;
        ST.Free;
        result := TRUE;
      end;
    end
    else
      result := FALSE;
  end;

  function BuildMultiLikeCondition(const aQuery, aFieldName: string): string;
  var
    sl: TStrings;
    i: Integer;
  begin
    Result := '';
    sl := TStringList.Create;
    try
      sl.Delimiter := ';';
      sl.DelimitedText := aQuery;

      for i := 0 to sl.Count - 1 do
      begin
        if sl[i] <> '' then
        begin
          if Result = '' then
            Result := aFieldName + ' Like(''%' + sl[i] + '%'')'
          else
            Result := Result + ' OR ' + aFieldName + ' Like(''%' + sl[i] + '%'')';
        end;
      end;
    finally
      sl.Free;
    end;
  end;

var
  s,s1,s2,sFilter: string;
  i:integer;
  iPos:integer;
  sNewFilter, SQL, sOEiD, sAllCatID:string;
  gen_an_id: integer;
begin

  FiltEd.Text := AnsiUpperCase(RemoveExtSymb(FiltEd.Text));

  if FiltModeComboBox.ItemIndex <> 0 then
//    FiltEd.Text := Data.CreateShortCode(FiltEd.Text, ':' {live ":"})
//  else
    FiltEd.Text := Data.CreateShortCode(FiltEd.Text);

  if FiltModeComboBox.ItemIndex <> 0 then
  begin
    Data.Auto_type := 0;
    AutoPanel.Hide;
    Data.sAuto:='';
  end;

  s := FiltEd.Text;

  if (Length(s)<1) then
    begin
      exit;
    end;

  s:=ReplaceStr(S,'''','''''');
  i := Length(s);
  if i < 2 then
  begin
    MessageDlg('Уточните значение поиска!', mtInformation, [mbOK],0);
    Exit;
  end;

  if FiltModeComboBox.ItemIndex = 4 then
  begin
    StartWait;
    bAbort := FALSE;
    Data.sAuto:='';
    Data.TestQuery.Close;
    Data.TestQuery.SQL.Clear;

    Data.TestQuery.SQL.Text := ' select gen_an_id from [007_1m] where an_shortcode = :Par1 ' +
                               ' union select gen_an_id from [007_2m] where an_shortcode = :Par2 ' +
                               ' union select gen_an_id from [007_3m] where an_shortcode = :Par3 ' +
                               ' union select gen_an_id from [007_4m] where an_shortcode = :Par4 ' +
                               ' union select gen_an_id from [007_5m] where an_shortcode = :Par5 ' ;
    Data.TestQuery.Params[0].Value := s;
    Data.TestQuery.Params[1].Value := s;
    Data.TestQuery.Params[2].Value := s;
    Data.TestQuery.Params[3].Value := s;
    Data.TestQuery.Params[4].Value := s;
    Data.TestQuery.Active:= TRUE;

    if not Data.TestQuery.Eof then
      SQL := 'UNION SELECT cat_id  FROM [007_2] WHERE gen_an_id = ' + Data.TestQuery.FieldByName('gen_an_id').AsString
    else
      SQL := '';

    Data.TestQuery.Close;
    Data.TestQuery.SQL.Clear;
    Data.TestQuery.SQL.Text := ' SELECT DISTINCT [002].Cat_id FROM [002] WHERE ShortCode = :par2 ' + SQL;
    Data.TestQuery.Params[0].Value := s;
    Data.TestQuery.Open;

    if not Data.TestQuery.Eof then
    begin
      sAllCatID := Data.TestQuery.FieldByName('Cat_id').AsString;
      Data.TestQuery.Next;
      while not Data.TestQuery.Eof do
      begin
        sAllCatID := sAllCatID + ',' + Data.TestQuery.FieldByName('Cat_id').AsString;
        Data.TestQuery.Next;
      end;
    end;

    Data.OEDescrSearchTable.Filtered := False;
    if Data.OEDescrSearchTable.Locate('ShortOE', s, [loPartialKey]) then
    begin
      while Copy(Data.OEDescrSearchTable.FieldByName('ShortOE').AsString, 1, Length(s)) = s  do
      begin
        while not Data.OEIDSearchTable.Eof do
        begin
             sOEiD := sOEiD + Data.OEIDSearchTable.FieldByName('Cat_id').AsString + ',';
             Data.OEIDSearchTable.Next;
        end;
        Data.OEDescrSearchTable.Next;
      end;
      Delete(sOEiD, Length(sOEiD), 1);
    end;


    if sOEiD <> '' then
    begin
      if sAllCatID <> '' then
        sAllCatID := sAllCatID + ',' + sOEiD
      else
        sAllCatID := sOEiD;
    end;

{    if not Data.TestQuery.Eof then
    begin
      Data.sAuto:='Cat_id IN ( '+Data.TestQuery.FieldByName('Cat_id').AsString;
      Data.TestQuery.Next;
      while not Data.TestQuery.Eof do
      begin
        Data.sAuto := Data.sAuto + ', '+Data.TestQuery.FieldByName('Cat_id').AsString;
        Data.TestQuery.Next;
      end;
      Data.sAuto := Data.sAuto + ')';
    end}
    if sAllCatID <> '' then
      Data.sAuto:='Cat_id IN ( '+ sAllCatID + ')'
    else
    begin
      StopWait;
      if MessageDlg('По Вашему запросу ничего не найдено! Найти позицию в web-портале Шате-М Плюс?', mtInformation, [mbYes, mbNo],0) = mrYes then
        WebSearchOE(s);

      Data.TestQuery.Close;
      exit;
      //Data.sAuto := 'Cat_id = -1';
    end;
    Data.TestQuery.Close;

    if bAbort then
    begin
      Data.sAuto := '';
      bAbort := FALSE;
      StopWait;
      exit;
    end;
    StopWait;
  end;

  if FiltModeComboBox.ItemIndex = 2 then
  begin
{        StartWait;
          bAbort := FALSE;
          Data.sAuto:='';
          Data.TestQuery.Close;
          Data.TestQuery.SQL.Clear;
            Data.TestQuery.SQL.Add('SELECT DISTINCT [016].Cat_id FROM [016] WHERE ShortOE LIKE('+'''%'+s+'%'') TOP 10000');

          bAbort := FALSE;
          Data.TestQuery.Open;
          if not Data.TestQuery.Eof then
          begin
            Data.sAuto:='Cat_id IN ( '+Data.TestQuery.FieldByName('Cat_id').AsString;
            Data.TestQuery.Next;
            while not Data.TestQuery.Eof do
            begin
             Data.sAuto := Data.sAuto + ', '+Data.TestQuery.FieldByName('Cat_id').AsString;
             Data.TestQuery.Next;
            end;
            Data.sAuto := Data.sAuto + ')';
          end
            else
              begin
                StopWait;
                if MessageDlg('По Вашему запросу ничего не найдено! Найти позицию в web-портале Шате-М Плюс?', mtInformation, [mbYes, mbNo],0) = mrYes then
                  WebSearchOE(s);
                Data.TestQuery.Close;
                exit;
               //Data.sAuto := 'Cat_id = -1';
              end;
          Data.TestQuery.Close;
          if bAbort then
          begin
            Data.sAuto := '';
            bAbort := FALSE;
            exit;
            StopWait;
          end;
          StopWait;  }

        StartWait;
        bAbort := FALSE;
        Data.sAuto:='';

Data.OEDescrSearchTable.Filtered := False;
 if Data.OEDescrSearchTable.Locate('ShortOE', s, [loPartialKey]) then
 begin
   while Copy(Data.OEDescrSearchTable.FieldByName('ShortOE').AsString, 1, Length(s)) = s  do
   begin
     while not Data.OEIDSearchTable.Eof do
     begin
          Data.sAuto := Data.sAuto + Data.OEIDSearchTable.FieldByName('Cat_id').AsString + ',';
          Data.OEIDSearchTable.Next;
     end;
     Data.OEDescrSearchTable.Next;
   end;

   Delete(Data.sAuto, Length(Data.sAuto), 1);
   Data.sAuto:='Cat_id IN ( ' + Data.sAuto + ')';
 end
 else
 begin
   StopWait;
   if MessageDlg('По Вашему запросу ничего не найдено! Найти позицию в web-портале Шате-М Плюс?', mtInformation, [mbYes, mbNo],0) = mrYes then
     WebSearchOE(s);
   exit;  
 end;

        if bAbort then
        begin
          Data.sAuto := '';
          bAbort := FALSE;
          exit;
          StopWait;
        end;
        StopWait;
  end;


  if FiltModeComboBox.ItemIndex = 3 then
  begin
    StartWait;
    bAbort := FALSE;
    Data.TestQuery.Close;
    Data.TestQuery.SQL.Clear;
    Data.TestQuery.SQL.Text := ' select gen_an_id from [007_1m] where an_shortcode = :Par1 ' +
                               ' union select gen_an_id from [007_2m] where an_shortcode = :Par2 ' +
                               ' union select gen_an_id from [007_3m] where an_shortcode = :Par3 ' +
                               ' union select gen_an_id from [007_4m] where an_shortcode = :Par4 ' +
                               ' union select gen_an_id from [007_5m] where an_shortcode = :Par5 ' ;
    Data.TestQuery.Params[0].Value := s;
    Data.TestQuery.Params[1].Value := s;
    Data.TestQuery.Params[2].Value := s;
    Data.TestQuery.Params[3].Value := s;
    Data.TestQuery.Params[4].Value := s;

    {if IgnoreSpecialSymbolsCheckBox.Checked then
       Data.TestQuery.SQL.Add('SELECT DISTINCT [007].Cat_id FROM [007] WHERE An_ShortCode = '''+s+'''')
    else
       Data.TestQuery.SQL.Add('SELECT DISTINCT [007].Cat_id FROM [007] WHERE REPLACE('' '' WITH '''' IN an_code) = '''+s+'''');}
    bAbort := FALSE;
    Data.TestQuery.Active:= TRUE;

    if not Data.TestQuery.Eof then
    begin
      gen_an_id := Data.TestQuery.FieldByName('gen_an_id').AsInteger;
      Data.TestQuery.SQL.Clear;
      Data.TestQuery.SQL.Text := ' Select cat_id  from [007_2] where gen_an_id = :Par1 ';
      Data.TestQuery.Params[0].Value := gen_an_id;
      Data.TestQuery.Active:= TRUE;
      if not Data.TestQuery.Eof then
      begin
        Data.sAuto:='Cat_id IN ( '+Data.TestQuery.FieldByName('Cat_id').AsString;
        Data.TestQuery.Next;
        while not Data.TestQuery.Eof do
        begin
          Data.sAuto := Data.sAuto + ','+Data.TestQuery.FieldByName('Cat_id').AsString;
          Data.TestQuery.Next;
        end;
        Data.sAuto := Data.sAuto + ')';
      end
    end

    else

    begin
      StopWait;
      if MessageDlg('По Вашему запросу ничего не найдено! Найти позицию в web-портале Шате-М Плюс?', mtInformation, [mbYes, mbNo],0) = mrYes then
        WebSearchOE(s);
      Data.TestQuery.Close;
      exit;
      //Data.sAuto := 'Cat_id = -1';
    end;

    Data.TestQuery.Close;
    if bAbort then
    begin
      Data.sAuto := '';
      bAbort := FALSE;
      StopWait;
      exit;
    end;
    StopWait;
  end;

  if FiltModeComboBox.ItemIndex = 1 then
  begin
    StartWait;
    bAbort := FALSE;
    if not FindTires(s) then
    begin
      if Data.ShortSearchTable.Locate('ShortCode', s, [loPartialKey]) then
      begin
        while Copy(Data.ShortSearchTable.FieldByName('ShortCode').AsString, 1, Length(s)) = s  do
        begin
          Data.sAuto := Data.sAuto + Data.ShortSearchTable.FieldByName('Cat_id').AsString + ',';
          Data.ShortSearchTable.Next;
        end;
        Delete(Data.sAuto, Length(Data.sAuto), 1);
        Data.sAuto:='Cat_id IN ( ' + Data.sAuto + ')';
      end
      
      else
      begin
        StopWait;
        if MessageDlg('По Вашему запросу ничего не найдено! Найти позицию в web-портале Шате-М Плюс?', mtInformation, [mbYes, mbNo],0) = mrYes then
          WebSearchOE(s);
        exit;
      end;
    end;

    if bAbort then
    begin
      Data.sAuto := '';
      bAbort := FALSE;
    end;

    StopWait;
  end;
      //срань для поиска по описанию!!!!!!!!!!
  if FiltModeComboBox.ItemIndex = 0 then
  begin
    StartWait;
    Data.TestQuery.Close;
    Data.TestQuery.SQL.Clear;
    sFilter:=AnsiUpperCase(Main.FiltEd.Text);
    sFilter := ReplaceStr(sFilter,' ','%');
    while(sFilter <> ReplaceStr(sFilter,':%',':')) do
      sFilter := ReplaceStr(sFilter,':%',':');

    while(sFilter <> ReplaceStr(sFilter,'%:',':')) do
        sFilter := ReplaceStr(sFilter,'%:',':');

    while(sFilter <> ReplaceStr(sFilter,'%%','%')) do
       sFilter := ReplaceStr(sFilter,'%%','%');

    while '%' = Main.StrLeft(sFilter,1) do
        sFilter := Main.StrRight(sFilter,length(sFilter)-1);

    while '%' = Main.StrRight(sFilter,1) do
          sFilter := Main.StrLeft(sFilter,length(sFilter)-1);

    sFilter := ReplaceStr(sFilter,'''','''''');
    iPos := StrFind(sFilter,':');
    if iPos>0 then
    begin
      s1:=Main.StrLeft(sFilter,iPos-1);
      s2:=Main.StrRight(sFilter,Length(sFilter)-iPos);
      if s1<> '' then
      begin
        s := 'upper(Name) LIKE('+'''%''+'''+s1+'''+''%'')';
        if s2<> '' then
          s := s + ' AND upper(Description) LIKE('+'''%''+'''+s2+'''+''%'')';
      end

      else if s2<> '' then
        s := 'upper(Description) LIKE('+'''%''+'''+s2+'''+''%'')';
    end

    else
      s := 'upper(Name) LIKE('+'''%''+'''+sFilter+'''+''%'') OR upper(Description) LIKE('+'''%''+'''+sFilter+'''+''%'')';

    if Data.Auto_type < 1 then
    begin
      Data.TestQuery.SQL.Add('SELECT DISTINCT [002].Cat_id FROM [002] WHERE ' + s);
      Data.TestQuery.Active:= TRUE;
      if not Data.TestQuery.Eof then
      begin
        Data.sAuto:='Cat_id IN ( '+Data.TestQuery.FieldByName('Cat_id').AsString;
        Data.TestQuery.Next;
        while not Data.TestQuery.Eof do
        begin
          Data.sAuto := Data.sAuto + ','+Data.TestQuery.FieldByName('Cat_id').AsString;
          Data.TestQuery.Next;
        end;
        Data.sAuto := Data.sAuto + ')';
      end
      else
      begin
        StopWait;
        if MessageDlg('По Вашему запросу ничего не найдено! Найти позицию в web-портале Шате-М Плюс?', mtInformation, [mbYes, mbNo],0) = mrYes then
          WebSearchOE(s);
        Data.TestQuery.Close;
        exit;
      end;
      Data.TestQuery.Close;
    end

    else
    begin
      //sNewFilter
      Data.TestQuery.SQL.Add('SELECT DISTINCT [002].Cat_id FROM [002] WHERE (' + s);
      Data.TestQuery.SQL.Add(') AND ' + Data.sAuto);
      Data.TestQuery.Active:= TRUE;
      if not Data.TestQuery.Eof then
      begin
        sNewFilter:='Cat_id IN ( '+Data.TestQuery.FieldByName('Cat_id').AsString;
        Data.TestQuery.Next;
        while not Data.TestQuery.Eof do
        begin
          sNewFilter := sNewFilter + ','+Data.TestQuery.FieldByName('Cat_id').AsString;
          Data.TestQuery.Next;
        end;
        sNewFilter := sNewFilter + ')';
      end
      else
      begin
        StopWait;
        if MessageDlg('По Вашему запросу ничего не найдено! Найти позицию в web-портале Шате-М Плюс?', mtInformation, [mbYes, mbNo],0) = mrYes then
          WebSearchOE(s);
        Data.TestQuery.Close;
        exit;
      end;
      Data.TestQuery.Close;
      sFilter :=sNewFilter;

      with Data.CatalogDataSource.DataSet do
      begin
        if Filter <> sFilter then
        begin
          Filter := sFilter;
          Filtered := True;
        end;

        if not Filtered then
          Filtered := True;
      end;

      s := FiltEd.Text;
      if s <> '' then
      with Data.SFiltTable do
      begin
        if FindKey([FiltModeComboBox.ItemIndex, s]) then
        begin
          Edit;
          FieldByName('Cnt').Value := FieldByName('Cnt').AsInteger + 1;
          Post;
        end
        else
        begin
          Append;
          FieldByName('Mode').Value    := FiltModeComboBox.ItemIndex;
          FieldByName('Text').Value    := s;
          FieldByName('Cnt').AsInteger := 1;
          Post;
        end;
      end;
      Data.FiltTable.Refresh;
      FiltEd.Text := s;
      FiltModified := False;
      StopWait;
      exit;
    end;
  end;
  
  s := FiltEd.Text; 
  if FiltModified and (s <> '') and
     (Data.ParamTable.FieldByName('Filt_range').AsString = '0') and
     ((Data.fBrand + Data.Group + Data.Subgroup) <> 0) then
  begin
    if Data.Tree_mode <> 3 then
      Data.fBrand    := 0;
    if Data.Tree_mode <> 2 then
      Data.Group    := 0;
    Data.Subgroup := 0;
    Main.Tree.Items[0].Selected := True;
    Data.SetCatFilter;
  end
  else
    Data.SetCatFilter;
  StopWait;  
  if s <> '' then
  with Data.SFiltTable do
  begin
    if FindKey([FiltModeComboBox.ItemIndex, s]) then
    begin
      Edit;
      FieldByName('Cnt').Value := FieldByName('Cnt').AsInteger + 1;
      Post;
    end
    else
    begin
      Append;
      FieldByName('Mode').Value    := FiltModeComboBox.ItemIndex;
      FieldByName('Text').Value    := s;
      FieldByName('Cnt').AsInteger := 1;
      Post;
    end;
  end;
  Data.FiltTable.Refresh;
  FiltEd.Text := s;
  FiltModified := False;
end;



procedure TMain.FindInAnalogExecute(Sender: TObject);
begin
  FiltModeComboBox.ItemIndex := 4;
  FiltEd.Text := SearchEd.Text;
  SearchEd.Text:='';
  FindFilter.Execute;
end;

procedure TMain.FormActivate(Sender: TObject);
begin
  if fMainCLose then
    exit;

  if Assigned(fPopupRss) and (fPopupRss.Showing) then
    BringToFrontRss;

  if (Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdate').AsBoolean)
      and((Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdateProg').AsBoolean)
          or(Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdateQuants').AsBoolean))  then
  begin
     if (not TimerUpdate.Enabled) and (TimerUpdate.Interval <> cCheckUpdateInterval) then
        TimerUpdate.Enabled := TRUE;
  end;
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(ChangesInBase) then
  begin
    ChangesInBase.Free;
    ChangesInBase := nil;
  end;

  fScheduler.Enabled := False;
  fScheduler.FreeAllTasks;
  Sleep(100);

  CliComboBox.ListSource := nil;
  AppClose;
end;


procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  fCanClose := False;
  try
    //идет загрузка обновлений
    if not bTerminate then //!!! переписать
    begin
      if MessageDlg('Прервать загрузку обновлений?',mtInformation, [mbYes, mbNo], 0) = mrYes then
      begin
        bTerminate := TRUE;
        DownloadThrd.Terminate;
        Sleep(200);
        CloseStatusColums;
      end
      else
        CanClose := FALSE;
    end;

    if Assigned(UpdateThrd) then
    begin
      if MessageDlg('Прервать установку обновлений?', mtInformation, [mbYes, mbNo], 0) = mrYes then
      begin
        if Assigned(UpdateThrd) then //проверяем еще раз т.к. поток мог завершится пока висело сообщение
        begin
          UpdateThrd.Terminate;
          Sleep(500);
          if Assigned(UpdateThrd) then //не ждем, убиваем принудительно
            TerminateThread(UpdateThrd.Handle, 0);

          CloseStatusColums;
        end;
      end
      else
        CanClose := False;
    end

    else

{    if Data.ParamTable.FieldByName('bCloseDialog').AsBoolean and not fRestProgAfterUpdate then
    begin
      if Application.MessageBox('Закрыть сервисную программу Шате-М Плюс?','Выйти?', MB_YESNO or MB_ICONQUESTION) = 6 then
        CanClose:=true
      else
        CanClose:=false;
    end;
}

  finally
    fCanClose := CanClose;
  end;
end;

procedure TMain.MainParamSplashTimerTimer(Sender: TObject);
begin
 // if isOpenedMoreThan2Windows('MainParam') then
 //   exit;
  MainParamSplashTimer.Enabled := False;
  WSysLog('Настройка параметров при старте');

(*
  if (Data.ParamTable.FieldByName('Discount').AsFloat > 0) or(Data.ParamTable.FieldByName('Profit').AsFloat > 0) then
  begin
    with Data.DiscountTable do
    begin
       DisableControls;
       if IndexName <> 'CLI' then
           IndexName := 'CLI';
       EnableControls;
    end;

    with Data.ClIDsTable do
    begin
      First;
      while not EOF do
      begin
        with Data.DiscountTable do
        begin
          sFilter := ReplaceLeftSymbol(Data.ClIDsTable.FieldByName('Client_ID').AsString);
          if Length(sFilter) > 3 then
          begin
            SetRange([sFilter], [sFilter]);
            sFilter := 'GR_ID = 0 AND SUBGR_ID = 0 AND BRAND_ID = 0';
            Filter := sFilter;
            Filtered := TRUE;
            if EOF then
            begin
               Append;
               FieldByName('CLI_ID').AsString := ReplaceLeftSymbol(Data.ClIDsTable.FieldByName('Client_ID').AsString);
               FieldByName('GR_ID').AsInteger := 0;
               FieldByName('SUBGR_ID').AsInteger := 0;
               FieldByName('BRAND_ID').AsInteger := 0;
               FieldByName('Discount').AsFloat := Data.ParamTable.FieldByName('Discount').AsFloat;
               FieldByName('Margin').AsFloat := Data.ParamTable.FieldByName('Profit').AsFloat;
               FieldByName('bDelete').AsInteger := 0;
               Post;
            end;
          end;
        end;
      Next;
      end;
   end;


    Data.ParamTable.Edit;
    Data.ParamTable.FieldByName('Discount').AsFloat := 0;
    Data.ParamTable.FieldByName('Profit').AsFloat := 0;
    Data.ParamTable.Post;

  end;
*)

  Application.Restore;
  with TMainParam.Create(Application) do
  begin
    ShowModal;
    Free;
  end;
  LoadUserID;
  if Assigned(fPopupRss) and (fPopupRss.Showing) then
    BringToFrontRss;
end;



procedure TMain.miBrandCatalogClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar((Sender as TMenuItem).Hint), nil, nil, SW_SHOW);
end;

procedure TMain.miExportPriceClick(Sender: TObject);
begin
  Data.ExportPrice;
end;

procedure TMain.miPanelVisibleClick(Sender: TObject);
begin
  if Assigned(Sender) and (Sender is TMenuItem) then
  begin
    (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;
    TAdvToolBar(Pointer((Sender as TMenuItem).Tag)).Visible := (Sender as TMenuItem).Checked;
  end;
end;

procedure TMain.miTeamViewerClick(Sender: TObject);
begin
  RunTVSupport;
end;

procedure TMain.miTreeAddToKKClick(Sender: TObject);
var
  aRecNo, i, aCount: Integer;
  c: TDataSet;
  aSaveAfterScroll: TDataSetNotifyEvent;
begin
  c := Data.CatalogDataSource.DataSet;

{ точно неизвестно сколько будет добавлено записей (не все с ценой)
  if c.RecordCount > 1000 then
    if Application.MessageBox(PChar('Вы действительно хотите добавить ' + IntToStr(c.RecordCount) + ' позиций в коммерческое предложение?'),
                                    'Подтверждение', MB_YESNO or MB_ICONQUESTION) <> IDYES then
      Exit;
}

  ShowProgress('Добавление позиций', c.RecordCount);
  StartWait;
  aSaveAfterScroll := c.AfterScroll;
  c.AfterScroll := nil;
  try

    c.DisableControls;
    Data.KK.DisableControls;
    Data.KK.OnCalcFields := nil;
    Data.KK.IndexName := 'LOOK';
    aRecNo := c.RecNo;
    try
      i := 0;
      aCount := 0;
      c.First;
      while not c.Eof do
      begin
        if (c.FieldByName('Cat_Id').AsInteger > 0) and
           (c.FieldByName('Code2').AsString <> '') and
           (c.FieldByName('PriceItog').AsCurrency <> 0) and
           (c.FieldByName('Quantity').AsString <> '') then
        begin
          if not Data.KK.FindKey([c.FieldByName('Code2').AsString, c.FieldByName('BrandDescr').AsString]) then
          begin
            Data.KK.Append;
            Data.KK.FieldByName('Code2').AsString := c.FieldByName('Code2').AsString;
            Data.KK.FieldByName('Brand').AsString := c.FieldByName('BrandDescr').AsString;
            Data.KK.Post;
            Inc(aCount);
          end;
        end;

        c.Next;
        Inc(i);
        if i mod 20 = 0 then
          CurrProgress(i);
      end;
    finally
      c.RecNo := aRecNo;
      Data.KK.IndexName := '';
      Data.KK.OnCalcFields := Data.KKCalcFields;
      Data.KK.Refresh;
      Data.KK.EnableControls;
      c.EnableControls;
    end;

  finally
    c.AfterScroll := aSaveAfterScroll;
    StopWait;
    HideProgress;
  end;

  Application.MessageBox(
    PChar('Позиций добавлено: ' + IntToStr(aCount)),
    'Сообщение',
    MB_OK
  );
  
{
  Data.Group    := 0;
  Data.Subgroup := 0;
  Data.fBrand   := 0;
}  
end;

procedure TMain.TrayIconDblClick(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ShowServerSplash;
end;


procedure TMain.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  if Data.Tree_mode = 0 then
  begin
    if Node.Level = 0 then
    begin
      Data.Group    := 0;
      Data.Subgroup := 0;
      Data.fBrand    := 0;
    end
    else if Node.Level = 1 then
    begin
      Data.Group    := Integer(Node.Data);
      Data.Subgroup := 0;
      Data.fBrand    := 0;
    end
    else if Node.Level = 2 then
    begin
      Data.Group    := Integer(Node.Parent.Data);
      Data.Subgroup := Integer(Node.Data);
      Data.fBrand    := 0;
    end
    else if Node.Level = 3 then
    begin
      Data.Group    := Integer(Node.Parent.Parent.Data);
      Data.Subgroup := Integer(Node.Parent.Data);
      Data.fBrand    := Integer(Node.Data);
    end;
  end
  else if Data.Tree_mode = 1 then
  begin
    if Node.Level = 0 then
    begin
      Data.Group    := 0;
      Data.Subgroup := 0;
      Data.fBrand    := 0;
    end
    else if Node.Level = 1 then
    begin
      Data.fBrand    := Integer(Node.Data);
      Data.Group    := 0;
      Data.Subgroup := 0;
    end
    else if Node.Level = 2 then
    begin
      Data.fBrand    := Integer(Node.Parent.Data);
      Data.Group    := Integer(Node.Data) div 1000;
      Data.Subgroup := Integer(Node.Data) mod 1000;
    end;
  end
  else if Data.Tree_mode = 2 then
  begin
    if Node.Level = 0 then
    begin
      Data.Group    := Integer(Node.Data);
      Data.Subgroup := 0;
      Data.fBrand    := 0;
    end
    else if Node.Level = 1 then
    begin
      Data.Group    := Integer(Node.Parent.Data);
      Data.Subgroup := Integer(Node.Data);
      Data.fBrand    := 0;
    end
    else if Node.Level = 2 then
    begin
      Data.Group    := Integer(Node.Parent.Parent.Data);
      Data.Subgroup := Integer(Node.Parent.Data);
      Data.fBrand    := Integer(Node.Data);
    end;
  end
  else if Data.Tree_mode = 3 then
  begin
    if Node.Level = 0 then
    begin
      Data.fBrand    := Integer(Node.Data);
      Data.Group    := 0;
      Data.Subgroup := 0;
    end
    else if Node.Level = 1 then
    begin
      Data.fBrand    := Integer(Node.Parent.Data);
      Data.Group    := Integer(Node.Data) div 1000;
      Data.Subgroup := Integer(Node.Data) mod 1000;
    end;
  end;

with (Data.CatalogDataSource.DataSet as TDBISAMTABLE) do
  begin
    StartWait;
    if Data.Tree_mode in [0, 2] then
    begin
      if Data.fBrand <> 0 then
        SetRange([1, Data.Group, Data.Subgroup, Data.fBrand], [1, Data.Group, Data.Subgroup, Data.fBrand])
      else if Data.Subgroup <> 0 then
        SetRange([1, Data.Group, Data.Subgroup], [1, Data.Group, Data.Subgroup])
      else if Data.Group <> 0 then
        SetRange([1, Data.Group], [1, Data.Group])
      else
        SetRange([1], [1]);
      First;
    end
    else if Data.Tree_mode in [1, 3] then
    begin
      if Data.Subgroup <> 0 then
        SetRange([1, Data.fBrand, Data.Group, Data.Subgroup], [1, Data.fBrand, Data.Group,Data.Subgroup])
      else if Data.fBrand <> 0 then
        SetRange([1, Data.fBrand], [1, Data.fBrand])
      else
        SetRange([1], [1]);
      First;
    end;

    if Main.AutoPanel.Visible then
      Main.AutoPanel.Caption.Text := 'Автомобиль  (найдено: ' + IntToStr(Data.CatalogDataSource.Dataset.RecordCount) + ')';

    StopWait;
  end;

end;


procedure TMain.TreeClick(Sender: TObject);
begin
  ClearSearchMode;
end;


function TMain.TrimAll(value: string): string;
begin
  result := StringReplace(value, ' ', '', [rfReplaceAll]);
end;

procedure TMain.TrimField(aDataSet: TDataSet; aField: string);
begin
  aDataSet.Edit;
  aDataSet.FieldByName(aField).AsString := StringReplace(aDataSet.FieldByName(aField).AsString, ' ', '', [rfReplaceAll]);
  aDataSet.Post;
end;

procedure TMain.NewCheckBoxClick(Sender: TObject);
begin
  UpdateFilterColumnsChecked('New');
  StartWait;
  Application.ProcessMessages;
  Data.LoadTree;
  StopWait;
end;



procedure TMain.NewFailActionExecute(Sender: TObject);
var
  iUser: TUserIDRecord;
  fgoodClose: boolean;
begin
  // новый возврат
 if not NewReturnDoc(TRUE) then
        exit;
  with TReturnDocED.Create(nil) do
  begin
    iUser := GetCurrentUser;
    Data.ContractsCliTable.Filtered := False;
    Data.ContractsCliTable.CancelRange;
{    if Data.ClIDsTable.Locate('client_id', Data.ReturnDocTable.FieldByName('cli_id').AsString, []) then
      Cli_id := Data.ClIDsTable.FieldByName('id').AsInteger;
 }

    if Data.ContractsCliTable.Locate('Cli_id;Contract_Id',VarArrayOf([iUser.sId,iUser.ContractByDefault]), []) then
    begin
      Data.ReturnDocTable.Edit;
      Data.ReturnDocTable.FieldByName('Agreement_No').AsString := Data.ContractsCliTable.FieldByName('Contract_Id').AsString;
      Data.ReturnDocTable.FieldByName('AgrDescr').AsString := Main.GetMaskEdDir;
      Data.ReturnDocTable.FieldByName('AgrGroup').AsString := Data.ContractsCliTable.FieldByName('Group').AsString;      
      Data.ReturnDocTable.Post;
    end;

    VisibleClientCombo(SameText(Data.ReturnDocTable.FieldByName('AgrGroup').AsString,'БН') or SameText(Data.ReturnDocTable.FieldByName('AgrGroup').AsString,''));
    repeat
      ShowModal;
      fGoodClose := FALSE;
      if ModalResult <> mrOk then
      begin
        if not Data.ReturnDocTable.EOF then
          Data.ReturnDocTable.Delete;
      end
      else
      begin
        if (length(Data.ReturnDocTable.FieldByName('AgrDescr').AsString) < 1)
          or ((FakeAddresDescr.Visible) and (Length(Data.ReturnDocTable.FieldByName('FakeAddresDescr').AsString)< 1))
            or ((Phone.Visible) and (Length(TrimAll(Phone.Text)) < MIN_LENGTH_PHONE))
              or ((Name.Visible) and (Length(Data.ReturnDocTable.FieldByName('Name').AsString)< MIN_LENGTH_NAME))
                or ((Data.ReturnDocTable.FieldByName('fDefect').AsBoolean) and (length(Data.ReturnDocTable.FieldByName('Note').AsString) < 1))  then
        begin
          MessageDlg('Заполните все обязательные поля, иначе заказ не будет сохранен! ФИО и телефон должны соответствовать формату!', mtError, [mbYes], 0);
          fGoodClose := TRUE;
        end
        else
          TrimField(Data.ReturnDocTable, 'Phone');

      end;
         {           Data.ReturnDocTable.Delete
         else
           fGoodClose := TRUE;}
    until not fGoodClose;
  end;
  Data.ReturnDocTable.Refresh;
end;

procedure TMain.NewImportNav(FileName, StringFlag: string; User: TUserIDRecord = nil);
var
  aReader: TCSVReader;
  UserData : TUserIDRecord;
  aQuery: TDBISamQuery;
begin
  if User = nil then
    UserData := GetCurrentUser
  else
    UserData := User;
    
  aQuery := TDBISamQuery.Create(nil);
  aReader := TCSVReader.Create;
  try
    if StringFlag = 'Address' then
    begin
      if not FileExists(FileName) then
        Exit;

      try
        Data.DeliveryAddressTable.Close;
//        Data.DeliveryAddressTable.EmptyTable;
        aQuery.DatabaseName := Main.GetCurrentBD;
        aQuery.SQL.Text :=
          ' DELETE FROM [047] WHERE CLI_ID = '''+ UserData.sId+'''';
        aQuery.ExecSQL;
      finally
        aQuery.Free;
      end;

      try
        aReader.Open(FileName);
        Data.DeliveryAddressTable.Open;
        while not aReader.Eof do
        begin
          try
            aReader.ReturnLine;
            Data.DeliveryAddressTable.Append;
            Data.DeliveryAddressTable.FieldByName('Addres_Id').AsString :=aReader.Fields[0];
            Data.DeliveryAddressTable.FieldByName('Descr').AsString :=aReader.Fields[1];
            Data.DeliveryAddressTable.FieldByName('Addres').AsString :=aReader.Fields[2];
            Data.DeliveryAddressTable.FieldByName('Cli_id').AsString := UserData.sId;
            Data.DeliveryAddressTable.Post;
          except
            Data.DeliveryAddressTable.Cancel;
          end;
        end;
      finally
        aReader.Close;
      end;
    end;
  //-----------------------------------
    if StringFlag = 'Agreements' then
    begin
      if not FileExists(FileName) then
        Exit;

      try
        Data.ContractsCliTable.Close;
//        Data.DeliveryAddressTable.EmptyTable;
        aQuery.DatabaseName := Main.GetCurrentBD;
        aQuery.SQL.Text :=
          ' DELETE FROM [048] WHERE CLI_ID = '''+ UserData.sId+'''' ;
        aQuery.ExecSQL;
      finally
        aQuery.Free;
      end;

      try
        aReader.Open(FileName);
        Data.ContractsCliTable.Open;
        while not aReader.Eof do
        begin
          try
            aReader.ReturnLine;
            Data.ContractsCliTable.Append;
            Data.ContractsCliTable.FieldByName('Contract_Id').AsString :=aReader.Fields[0];
            Data.ContractsCliTable.FieldByName('ContractDescr').AsString :=aReader.Fields[1];
            Data.ContractsCliTable.FieldByName('Group').AsString :=aReader.Fields[2];
            Data.ContractsCliTable.FieldByName('Currency').AsString :=aReader.Fields[3];
            Data.ContractsCliTable.FieldByName('Method_Id').AsString :=aReader.Fields[4];
            Data.ContractsCliTable.FieldByName('MethodDescr').AsString :=aReader.Fields[5];
            Data.ContractsCliTable.FieldByName('Payment_id').AsString :=aReader.Fields[6];
            Data.ContractsCliTable.FieldByName('PaymentDescr').AsString :=aReader.Fields[7];
            Data.ContractsCliTable.FieldByName('PriceList_id').AsString :=aReader.Fields[8];
            Data.ContractsCliTable.FieldByName('PriceListDescr').AsString :=aReader.Fields[9];
            Data.ContractsCliTable.FieldByName('DiscountCliGroup').AsString :=aReader.Fields[10];
            Data.ContractsCliTable.FieldByName('DiscountCliGroupDescr').AsString :=aReader.Fields[11];
            Data.ContractsCliTable.FieldByName('LegalPerson').AsString :=aReader.Fields[12];
            Data.ContractsCliTable.FieldByName('Addres_Id').AsString :=aReader.Fields[13];
            Data.ContractsCliTable.FieldByName('IS_MULTICURR').AsBoolean :=aReader.Fields[14] = '1';
            Data.ContractsCliTable.FieldByName('RegionCode').AsString := aReader.Fields[15]; //мультивалютный договор
            Data.ContractsCliTable.FieldByName('Cli_id').AsString := UserData.sId;
            Data.ContractsCliTable.Post;
          except
            Data.ContractsCliTable.Cancel;
          end;
        end;
      finally
        aReader.Close;
      end;
    end;
  //------------------------------------------------------
    if StringFlag = 'Discounts' then
    begin
      if not FileExists(FileName) then
        Exit;
      try
        Data.DiscountCliTable.Close;
//        Data.DeliveryAddressTable.EmptyTable;
        aQuery.DatabaseName := Main.GetCurrentBD;
        aQuery.SQL.Text :=
          ' DELETE FROM [049] WHERE CLI_ID = '''+ UserData.sId+'''';
        aQuery.ExecSQL;
      finally
        aQuery.Free;
      end;

      try
       aReader.Open(FileName);
       Data.DiscountCliTable.Open;
       while not aReader.Eof do
       begin
         try
           aReader.ReturnLine;
           Data.DiscountCliTable.Append;
           Data.DiscountCliTable.FieldByName('Group_Id').AsString :=aReader.Fields[0];
           Data.DiscountCliTable.FieldByName('Subgroup_Id').AsString :=aReader.Fields[1];
           Data.DiscountCliTable.FieldByName('Brand_Id').AsString :=aReader.Fields[2];
           Data.DiscountCliTable.FieldByName('GroupDiscountCli').AsString :=aReader.Fields[3];
           Data.DiscountCliTable.FieldByName('Discount').AsString :=aReader.Fields[4];
           Data.DiscountCliTable.FieldByName('Cli_id').AsString := UserData.sId;
           Data.DiscountCliTable.Post;
         except
           Data.DiscountCliTable.Cancel;
         end;
       end;
      finally
        aReader.Close;
      end;
    end;
  finally
    aReader.Free;
    DeleteFile(FileName);
  end;

end;

procedure TMain.UsaCheckBoxClick(Sender: TObject);
begin
  UpdateFilterColumnsChecked('Usa');
  StartWait;
  Application.ProcessMessages;
  Data.LoadTree;
  StopWait;
end;

procedure TMain.WithLatestQuantsClick(Sender: TObject);
begin
  //С появившимися остатками
  StartWait;
  Application.ProcessMessages;
  Data.SetCatFilter;
  StopWait;
end;

procedure TMain.WithQuantsClick(Sender: TObject);
begin
  UpdateFilterColumnsChecked('Quantity');
  //С остатками
  StartWait;
  Application.ProcessMessages;
  Data.SetCatFilter;
  StopWait;
end;

procedure TMain.WMSysCommand(var Message: TWMSysCommand);
begin
  case message.CmdType of
    SC_MINIMIZE:
    begin
      if IsIconic(Application.Handle) then
      begin
        Application.Restore;
        inherited;
        if (message.XPos <> 3333) and (message.YPos <> 3333) then
          PostMessage(Handle, WM_SYSCOMMAND, SC_MINIMIZE, MakeLParam(3333, 3333));
      end
      else
        inherited;
    end;
    else
      inherited;
  end;

{
  case message.CmdType of
    SC_MINIMIZE:
    begin
      ShowWinNoAnimate(Handle, SW_MINIMIZE);//Application.Minimize
      ShowWindow(Handle, SW_HIDE);
      Message.Result := 0;
    end;
    SC_RESTORE:
    begin
      ShowWindow(Handle, SW_SHOWNORMAL);
      ShowWindow(Handle, SW_RESTORE);
      Message.Result := 0;
    end;
    SC_MAXIMIZE:
    begin
      ShowWindow(Handle, SW_MAXIMIZE);
      Message.Result := 0;
    end;
    else
      inherited;
  end;
}  
end;

procedure TMain.WritePost(post: integer);
begin
  Data.ReturnDocTable.Edit;
  Data.ReturnDocTable.FieldByName('Post').AsInteger := post;
  Data.ReturnDocTable.FieldByName('TcpAnswer').AsVariant := NULL;
  Data.ReturnDocTable.Post;
  Data.ReturnDocTable.Refresh;
end;

function TMain.GetClientDiscCode(const aClientID, anAgrCode: string): string;
var
  aQuery : TDBISamQuery;
begin
  Result := '';
  exit;
  
  aQuery := TDBISamQuery.Create(nil);
  try
    aQuery.DatabaseName := Main.GetCurrentBD;;
    aQuery.DisableControls;
    aQuery.SQL.Text := 
      ' SELECT DiscountCliGroup FROM [048] where CLI_ID = :CLI_ID and Contract_Id = :Contract_Id ';
    aQuery.Params[0].Value := aClientID;
    aQuery.Params[1].Value := anAgrCode;
    aQuery.Open;
    if not aQuery.Eof then
      Result := aQuery.Fields[0].AsString;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;

function TMain.GetCurrentBD: string;
begin
  if fLocalMode then
    result := Data.User_Database.DatabaseName
  else
    result := Data.Database.DatabaseName;
end;

function TMain.GetCurrentUser: TUserIDRecord;
var
  i: Integer;
  s: string;
begin
  Result := nil;

  if CliComboBox.KeyValue = NULL then
    Exit;

  s := CliComboBox.KeyValue;
  for i := 0 to ClientList.Count - 1 do
  begin
    if TUserIDRecord(ClientList[i]).sId = s then
    begin
      Result := ClientList[i];
      Exit;
    end;
  end;
end;


function TMain.GetUserDataByID(const aSearchID: string): TUserIDRecord;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to ClientList.Count - 1 do
  begin
    if TUserIDRecord(ClientList[i]).sId = aSearchID then
    begin
      Result := ClientList[i];
      Exit;
    end;
  end;
end;

procedure TMain.LoadUserID;
var
  UserID: TUserIDRecord;
  iPos: Integer;
  aQuery: TDBISamQuery;
begin
  iPos := 0;
  while iPos < ClientList.Count do
  begin
    UserID := ClientList[iPos];
    UserID.Free;
    Inc(iPos);
  end;
  ClientList.Clear;

  CliComboBox.ListSource := nil;
  if Data.ParamTable.FieldByName('Cli_id_mode').AsString = '0' then
    CliComboBox.ListFieldIndex := 0
  else
    CliComboBox.ListFieldIndex := 1;
  CliComboBox.ListSource := Data.ClIDsDataSource;

  aQuery := TDBISamQuery.Create(nil);
  try
    aQuery.DatabaseName := Main.GetCurrentBD;//Data.Database.DatabaseName;
    aQuery.DisableControls;
    aQuery.SQL.Text := ' SELECT * FROM [011] ';
    aQuery.Open;

    with aQuery do
    begin
      First;
      while not EOF do
      begin
        UserID := TUserIDRecord.Create();
        UserID.iID := FieldByName('ID').AsInteger;
        UserID.sId := FieldByName('Client_ID').AsString;
        UserID.sName := FieldByName('Description').AsString;
        UserID.sOrderType := FieldByName('Order_type').AsString;
        UserID.iDelivery := FieldByName('Delivery').AsInteger;
        UserID.sEMail := FieldByName('email').AsString;
        UserID.sKey := FieldByName('Key').AsString;
        UserID.bUpdateDisc := FieldByName('UpdateDisc').AsBoolean;
        UserID.DiscountVersion := FieldByName('DiscountVersion').AsInteger;
        UserID.UseDiffMargin := FieldByName('UseDiffMargin').AsBoolean;
        UserID.DiffMargin := FieldByName('DiffMargin').AsString;
        //new
        UserID.DiscVersion := FieldByName('DiscVersion').AsInteger;
        UserID.AddresVersion := FieldByName('AddresVersion').AsInteger;
        UserID.AgrVersion := FieldByName('AgrVersion').AsInteger;

        UserID.ContractByDefault := FieldByName('ContractByDefault').AsString;
        UserID.AddresByDefault := FieldByName('AddresByDefault').AsString;

        ClientList.add(UserID);

        if FieldByName('ByDefault').AsInteger = 1 then
        begin
          CliComboBox.OnChange := nil;
          CliComboBox.KeyValue := FieldByName('Client_ID').AsString;
          CliComboBox.OnChange := CliComboBoxChange;
        end;

        Next;
      end;
    end;

    aQuery.Close;
  finally
    aQuery.Free;
  end;

  SetActiveCli(GetCurrentUser);
end;



procedure TMain.GetUpdateServersList(aServerList: TStrings);

  function GetUpdateServers(aServers: TStrings): Boolean;
  var
    s, aUrl, aFileName: string;
    aIni: TIniFile;
    i: Integer;
  begin
    Result := False;
    aServers.Clear;

    aUrl := Data.SysParamTable.FieldByName('Update_url').AsString;
    if (aUrl <> '') and (Right(aUrl, 1) <> '/') then
      aUrl := aUrl + '/';

    if aUrl <> '' then
    begin
    {$IFDEF PODOLSK}
      aUrl := aUrl + 'getLinkPod';
    {$ELSE}
      aUrl := aUrl + 'getLink';
    {$ENDIF}
      if Data.ParamTable.FieldByName('UseProxy').AsBoolean then
        aUrl := Data.MakeProxyUrl(aUrl, Data.ParamTable.FieldByName('ProxyUser').AsString, Data.ParamTable.FieldByName('ProxyPassword').AsString);
    end;

    aFileName := IncludeTrailingPathDelimiter(Data.Import_Path) + 'srvs';
    if MainDownLoadFile(aURL, aFileName) then
    begin
      aIni := TIniFile.Create(aFileName);
      try
        i := 1;
        while True do
        begin
          s := aIni.ReadString('SERVERS', IntToStr(i), '');
          if s <> '' then
            aServers.Add(s)
          else
            Break;
          Inc(i);
        end;
      finally
        aIni.Free;
      end;
      DeleteFile(aFileName);

      {test}
     // aServers.Text := StringReplace(aServers.Text, '/service/', '/serviceTestProg/', [rfReplaceAll]);
     // aServers.Text := StringReplace(aServers.Text, '/service-http/', '/serviceTestProg/', [rfReplaceAll]);

      Result := aServers.Count > 0;
    end;

    //http://shate-m.by/service/getLink
    //SERVERS
  end;

var
  i: Integer;
begin
  if not GetUpdateServers(aServerList) then
  begin
    //приоритет по-умолчанию, если недоступен основной сервер
    for i := 0 to UpdateMirrors.Count - 1 do
      aServerList.Add(UpdateMirrors[i]);
  end;
end;

procedure TMain.FillDiffMarginTable(const aCsvData: string);
var
  sl: TStrings;
  i: Integer;
begin
  Data.memProfit.Close;
  Data.memProfit.EmptyTable;
  Data.memProfit.Open;

  sl := TStringList.Create;
  try
    sl.Text := aCsvData;
    for i := 0 to sl.Count - 1 do
    begin
      Data.memProfit.Append;
      Data.memProfit.FieldByName('PriceFrom').AsFloat := AToCurr( ExtractDelimited(1,  sl[i], [';']) );
      if Data.memProfit.FieldByName('PriceFrom').AsFloat = -1 then
        Data.memProfit.FieldByName('PriceFrom').AsString := '';
      Data.memProfit.FieldByName('PriceTo').AsFloat := AToCurr( ExtractDelimited(2,  sl[i], [';']) );
      if Data.memProfit.FieldByName('PriceTo').AsFloat = -1 then
        Data.memProfit.FieldByName('PriceTo').AsString := '';
      Data.memProfit.FieldByName('Profit').AsFloat := AToCurr( ExtractDelimited(3,  sl[i], [';']) );
      Data.memProfit.Post;
    end;
    Data.memProfit.First;
  finally
    sl.Free;
  end;
end;

procedure TMain.FillECatList;
begin
  fECatList.Add('AE=http://www.fme-cat.com');
  fECatList.Add('AGIP=http://eni-ita.lubricantadvisor.com/default.aspx?Lang=rus');
  fECatList.Add('AIRTEX=[AIRTEX electric]http://www.airtexve.com/ecatalog.html');
  fECatList.Add('AIRTEX=[AIRTEX pumps]http://www.airtexwaterpumps.com/showmetheparts/');
  fECatList.Add('AP=http://www.lpr.it/e-catalogo.asp');
  fECatList.Add('AREON=http://www.areon-fresh.com/ru/products/');
  fECatList.Add('ATLAS=http://www.transbec.ca/Catalogue.aspx');
  fECatList.Add('AUTOFREN SEINSA=http://www.seinsa.es/');
  fECatList.Add('AVA COOLING SYSTEMS=http://ava.web.shphosting.com/techinfo_search_pub.lasso');
  fECatList.Add('BOSCH=http://www.bosch-automotive-catalog.com/public/catalog/products?lgRedirect=true&country=RU&lg=ru&wti_ecat_changeCountry=1');
  fECatList.Add('BREMBO=http://bremboaftermarket.com/Ru/Car_Disc_Catalogue/Catalogue_Search.aspx');
  fECatList.Add('CARGO=http://www.hcdk.com/Default.aspx?ID=28');
  fECatList.Add('CHAMPION=http://fme-cat.com/');
  fECatList.Add('CLEAN FILTERS=http://www.clean.it/catalogo/ricerca_applicazioni.php?=&language=eng&language=rus');
  fECatList.Add('CLOYES=http://www.cloyes.com/default.aspx?tabid=378');
  fECatList.Add('CONTINENTAL=http://www.conti-online.com/generator/www/de/en/continental/automobile/general/tirefinder/tirefinder.html');
  fECatList.Add('CONTITECH=http://www.aamkatalog.ctapps.de/aam_katalog.pl?action=kfzsearch&lang=en');
  fECatList.Add('CORTECO=http://www.corteco.com/ru/produkcija/online-catalogue/');
  fECatList.Add('CTR=http://www.ctr.co.kr/ecatalog/main.htm');
  fECatList.Add('CYCLO=http://www.cyclo.com/pages/Automotive');
  fECatList.Add('DAYCO=http://web.daycogarage.com/catalogue/');
  fECatList.Add('DEA=http://www.deaproducts.com/');
  fECatList.Add('DENSO=http://www.denso.ru/catalogue.asp');
  fECatList.Add('DEPO=http://www.depo.com.tw/show_product.asp?pageno=1');
  fECatList.Add('DOLZ=http://www.idolz.com/eng/?page_id=396');
  fECatList.Add('DUNLOP=http://www.dunloptires.com/en-US/tires-home');
  fECatList.Add('DURUN=http://www.duruntyre.co.uk/russian/car.htm');
  fECatList.Add('ERA=http://www.eraspares.ru/ec/Tabellone.asp?SeCook=True&login=1');
  fECatList.Add('EXEDY=http://ww3.elcome.co.uk/Exedy/Default.asp?i=30');
  fECatList.Add('EXIDE=http://webshop-cs.tecdoc.net/exide/?language=RU&country=de#');
  fECatList.Add('FACET=http://www.facet.it/db_comp/catalogo/catalogo.asp');
  fECatList.Add('FAG=http://webcat.schaeffler-aftermarket.com/web/schaeffler/en_GB/applicationSearch.xhtml');
  fECatList.Add('FALKEN=http://www.falkentire.com/');
  fECatList.Add('FEDERAL MOGUL=http://www.fme-cat.com/');
  fECatList.Add('FORMPART=http://katalog.formpart.com/katalog/catalog.seam');
  fECatList.Add('FTE=http://katalog.fte.de/');
  fECatList.Add('GABRIEL=http://gabriel.com/our-products');
  fECatList.Add('GATES=http://www.gates.com/part_locator/index.cfm?location_id=3598&go=Interference');
  fECatList.Add('GLASER=http://www.glaserserva.com/ing/catalogue.php#');
  fECatList.Add('HUTCHINSON=www.hutchinsonaftermarket.com');
  fECatList.Add('HSB=http://www.hastingsmfg.com/RingFinderMaster.aspx');
  fECatList.Add('HANS PRIES=https://www.pries.de/shop.asp');
  fECatList.Add('HELLA=http://www.hella.com/toc/');
  fECatList.Add('IKA=http://www.ika-germany.de/PRODUCTS/CATALOGUE/tabid/133/language/en-US/Default.aspx');
  fECatList.Add('ILJIN=http://www.iljin.com/products/productsearch.asp');
  fECatList.Add('IFHS=http://shate-m.by/ru/encyclopedia/articles/49.html');
  fECatList.Add('IMPERGOM=http://www.impergom.it/catalogue/index.php');
  fECatList.Add('INA=http://webcat.schaeffler-aftermarket.com/web/schaeffler/en_GB/applicationSearch.xhtml');
  fECatList.Add('JANMOR=http://www.janmor.pl/rus/katalog.php?p=main&s=1');
  fECatList.Add('JC AUTO=http://sklep.intercars.com.pl/');
  fECatList.Add('K+F=http://web1.carparts-cat.com/default.aspx?11=33&14=16&10=C0147844155794F3E040A8C01E3E686F033016&12=100');
  fECatList.Add('KNECHT=http://217.6.60.45/mahle/start.jsp?folder=fahrzeug&sessionClear=true');
  fECatList.Add('KOLBENSCHMIDT=https://www.onlineshop.ms-motor-service.com/msi/MSICD?page=checkUser&lang=RU&vko=0001&usertype=guest');
  fECatList.Add('KYB=http://www.kyb-europe.com/kyb-russian/catalogue.asp');
  fECatList.Add('LEMFOERDER=http://webcat.zf.com/index.asp?SPR=4');
  fECatList.Add('LINEX=http://www.linex.com.pl/ru/index.php?adres=katalog');
  fECatList.Add('LUBER FINER=http://www.luberfiner.com/catalog/parts-catalog.aspx');
  fECatList.Add('LUK=http://webcat.schaeffler-aftermarket.com/web/schaeffler/en_GB/applicationSearch.xhtml');
  fECatList.Add('MAHLE=http://www.motorenteile.mahle.com/eLIZA/mahle/query/engine/byParams');
  fECatList.Add('MEAT&DORIA=http://www.meat-doria.com/');
  fECatList.Add('MOBIL=http://www.datateck.com.au/lube/mobil_au/default.asp');
  fECatList.Add('MONROE=http://www.monroe.com/catalog/e-Catalog');
  fECatList.Add('MOPAR=http://www.mopar.com/vehicle-locator.html');
  fECatList.Add('NARVA=http://www.narva-light.com/en_EN/');
  fECatList.Add('NGK=http://www.ngksparkplugs.com/part_finder/');
  fECatList.Add('PAYEN=http://www.fme-cat.com/');
  fECatList.Add('PHILIPS=http://www.philips.ru/c/eco-headlights/17624/cat/ru/');
  fECatList.Add('PIERBURG=https://onlineshop.ms-motor-service.com/msi/MSICD');
  fECatList.Add('POLMOSTROW=http://www.polmostrow.pl/katalog.html');
  fECatList.Add('PROTECNIK=http://katalog.protechnic.eu/Search/Index.aspx');
  fECatList.Add('PURFLUX=http://www.sogefifilterdivision.com/catalogues/FO/scripts/accueil.php?zone=FR&catalogue=PFX&lang=RU');
  fECatList.Add('RAYBESTOS=[RAYBESTOS Brakes]http://www.raybestos.com/wps/portal/raybestos/c1/04_SB8K8xLLM9MSSzPy8xBz9CP0os_hgpwBXQw93IwMD7wBTA08jEzNTv5BAIwNTA6B8pFm8n4mPibGTl3ewq0mwoWmQk1mAiQEEEKXbzNvT38jPyMDdxM_Cw');
  fECatList.Add('RAYBESTOS=[RAYBESTOS Chassis]http://www.raybestoschassis.com/wps/portal/raybestoschassis/c1/jY5BDoIwFETP4gk6_bQNbCEWmialKlVkQ7owBiPgwnh-4QJoZvnyZoZ1bMkUP8M9vod5ik_Wsk71p9zveVUSYL2EIaGkaw4EiYVfVc-');
  fECatList.Add('RBI=http://www.alafuae.com/eng/default.asp');
  fECatList.Add('REINZ=http://reinz.de/root/eng/aftermarket_1102_ENG_HTML.php');
  fECatList.Add('RUVILLE=http://toc.ruville.de/');
  fECatList.Add('RTS=http://www.rts-sa.es/ctrl_index.php?action=catalogo&prmt=1&setlang=en');
  fECatList.Add('SACHS=http://webcat.zf.com/index.asp?SPR=4');
  fECatList.Add('SALERI=http://www.saleri.it/catalogo/catalogo.asp?vrs=eng');
  fECatList.Add('SANGSIN=http://www.sangsin.com/eng/menu2_3_1.aspx');
  fECatList.Add('SASSONE=http://www.esassone.com/');
  fECatList.Add('SKF=http://webshop-cs.tecdoc.net/skf/?language=ru&country=de#');
  fECatList.Add('SNR=https://www.ntn-snr.com/catalogue/fr/en-en/index.cfm?page=/catalogue/home/ra');
  fECatList.Add('SPIDAN=http://webshop-cs.tecdoc.net/gkn/?language=ru&country=de#');
  fECatList.Add('STABILUS=http://www.stabilus.com/service-spare-parts/search-for-spare-parts/');
  fECatList.Add('STANT=http://www.stant.com/Parts-Locator/');
  fECatList.Add('SHELL=http://lubematch.shell.com.ru/landing.php?setregion=349&setlanguage=14&site=58&region=349&language=14&brand=95');
  fECatList.Add('SWAG=http://www.swag-parts.com/?lang=RUS');
  fECatList.Add('TRW=http://www.trwaftermarket.com/ru-RU/Catalogue/');
  fECatList.Add('VALEO=http://www.valeoservice.com/html/russia/ru/');
  fECatList.Add('WIX FILTERS=http://www.wixfilters.com/filterlookup/index.asp');
  fECatList.Add('ZF=http://webcat.zf.com/index.asp?SPR=4');
  fECatList.Add('WELLS=http://www.wellsve.com/ecatalog.html');
end;

procedure TMain.SelectCurrentUser;
var
  sFilter: string;
  i: Integer;
  UserData: TUserIDRecord;
begin
  UserData := GetCurrentUser;

  if Assigned(UserData) then
  begin
    _Data.gMarginModeDiff := UserData.UseDiffMargin;
    if UserData.UseDiffMargin then
      FillDiffMarginTable(UserData.DiffMargin)
    else
      FillDiffMarginTable('');
    LoadDiscountTCP.Enabled := not UserData.bUpdateDisc;

    if UserData.sId <> '' then
    begin
      fLastDefaultUserID := UserData.sID;
      if UserData.ContractByDefault <> '' then
        fLastDefaultUserAgrCode := UserData.ContractByDefault
      else
        fLastDefaultUserAgrCode := '';
      if fLastDefaultUserAgrCode <> '' then
      begin
        fLastDefaultUserAgrDiscCode := GetClientDiscCode(fLastDefaultUserID, fLastDefaultUserAgrCode);
      end
      else
        fLastDefaultUserAgrDiscCode := '';


      Data.SetDefaultClient(UserData.sID);
      with Data.DiscountTable do
      begin
        DisableControls;
        if IndexName <> 'CLI' then
          IndexName := 'CLI';
        sFilter := UserData.sId;
        SetRange([sFilter], [sFilter]);
        EnableControls;
      end;

      with Data.MarginTable do
      begin
        DisableControls;
        if IndexName <> 'CLI_OLD' then
          IndexName := 'CLI_OLD';
        sFilter := UserData.sId;
        SetRange([sFilter], [sFilter]);
        EnableControls;
      end;
      
      //установка записей относящихся только к текущему клиенту ----------------
      with Data.DiscountCliTable do
      begin
        DisableControls;
        if IndexName <> 'CLI' then
          IndexName := 'CLI';
        sFilter := IntToStr(UserData.iId);
        SetRange([sFilter], [sFilter]);
        EnableControls;
      end;
      with Data.ContractsCliTable do
      begin
        DisableControls;
        if IndexName <> 'CLI' then
          IndexName := 'CLI';
        sFilter := UserData.sId;
        //CheckAgrDescr;
        SetRange([sFilter], [sFilter]);
        EnableControls;
      end;
      //------------------------------------------------------------------------

      if not Data.ParamTable.FieldByName('ShowAllOrders').AsBoolean then
      begin
        with Data.OrderTable do
        begin
          DisableControls;

          if IndexName <> 'Cli_Date' then
            IndexName := 'Cli_Date';
          sFilter := UserData.sId;
          SetRange([sFilter, OrderDateEd1.Date], [sFilter, OrderDateEd2.Date]);
          CountingOrderSum;
          Last;
          EnableControls;
        end;

        with Data.ReturnDocTable do
        begin
          DisableControls;
          if IndexName <> 'Cli_Date' then
            IndexName := 'Cli_Date';
          sFilter := UserData.sId;
          SetRange([sFilter, DateStartReturnDoc.Date], [sFilter, DateEndReturnDoc.Date]);
          Last;
          EnableControls;
        end;


        with Data.WaitListTable do
        begin
          Filtered := False;
          DisableControls;
          i := FieldByName('id').AsInteger;
          //if IndexName <> 'DateCreate' then
          //  IndexName := 'DateCreate';

          sFilter := UserData.sId;
          //SetRange([sFilter], [sFilter]);
          Data.fWaitListTableClientFilter := sFilter;
          Filtered := True;
          Refresh;
          Data.CalcWaitList;
          if not Locate('id', i, []) then
            Last;
          EnableControls;
        end;
        ZakTabInfo;
        Exit;
      end;
    end;
  end;

  with Data.OrderTable do
  begin
    DisableControls;
    i := Data.OrderTable.FieldByName('Order_id').AsInteger;
    if IndexName <> 'Date' then
      IndexName := 'Date';
    SetRange([OrderDateEd1.Date], [OrderDateEd2.Date]);
    CountingOrderSum;
    if not Data.OrderTable.Locate('Order_id', i, []) then
      Data.OrderTable.Last;
    EnableControls;
  end;

  with Data.ReturnDocTable do
  begin
    DisableControls;
    i := Data.ReturnDocTable.FieldByName('RetDoc_id').AsInteger;
    if IndexName <> 'Date' then
      IndexName := 'Date';
    SetRange([DateStartReturnDoc.Date], [DateEndReturnDoc.Date]);
    if not Data.ReturnDocTable.Locate('RetDoc_id', i, []) then
      Data.ReturnDocTable.Last;
    Last;
    EnableControls;
  end;

  with Data.WaitListTable do
  begin
    DisableControls;
    Filtered := False;
    i := FieldByName('id').AsInteger;
    //if IndexName <> 'DateCreate' then
    //  IndexName := 'DateCreate';
    Data.fWaitListTableClientFilter := '';
//    Filter := '';
    Filtered := True;
    Refresh;
    Data.CalcWaitList;
    if not Locate('id', i, []) then
      Last;
    EnableControls;
  end;
  ZakTabInfo;
end;


procedure TMain.UserInfo_ActionExecute(Sender: TObject);
begin
  with TClientIDs.Create(Application) do
  begin
    MenuMode := True;
    ShowModal;
  end;
  LoadUserID;
end;

procedure TMain.VersionTimerTimer(Sender: TObject);
var
  aModalResult: Integer;
begin
  VersionTimer.Enabled := False;

  if Assigned(UpdateThrd) then
    Exit;

  case CheckProgrammPeriod of
    0: {OK - do nothing};

    1:
    begin
      if CheckIsServiceOrdered then //сервисная есть в сегодняшнем заказе
        Exit;
      if fProgrammPeriodWarnShowed then //предупреждение показываем один раз
        Exit;
      fProgrammPeriodWarnShowed := True;

      with TVersionInfo.Create(Application) do
      try
        Init(rest_days, Data.SysParamTable.FieldByName('Act_warn_period').AsInteger, True, Data.SysParamTable.FieldByName('Ver_info2').AsString);
        aModalResult := ShowModal;
      finally
        Free;
      end;
      //выполняем действия после того как форма TVersionInfo закроется
      case aModalResult of
        mrRetry: MainActionExecute(WebUpdateAction);
        mrIgnore:
          if AddServiceToOrder then
            Application.MessageBox('Сервисная добавлена в заказ', '', MB_OK or MB_ICONINFORMATION);
      end;
    end;

    2:
    begin
      if CheckIsServiceOrdered then //сервисная есть в сегодняшнем заказе
        Exit;
      with TVersionInfo.Create(Application) do
      try
        Init(rest_days, Data.SysParamTable.FieldByName('Act_warn_period').AsInteger, True, Data.SysParamTable.FieldByName('Ver_info1').AsString);
        aModalResult := ShowModal;
      finally
        Free;
      end;
      //выполняем действия после того как форма TVersionInfo закроется
      if aModalResult = mrRetry then
      begin
        MainActionExecute(WebUpdateAction);
        //проверять период действия после обновления !!!
      end
      else
        if aModalResult = mrIgnore then
        begin
          if AddServiceToOrder then
            Application.MessageBox('Сервисная добавлена в заказ', '', MB_OK or MB_ICONINFORMATION)
          else
            Application.Terminate;
        end
        else
          Application.Terminate;
    end;
  end;

end;


procedure TMain.ShowServerSplash;
begin
  if ServerSplash <> nil then
    ServerSplash.Show
  else
  begin
    ServerSplash := TServerSplash.Create(Application);
    ServerSplash.ShowModal; // вызов окна состояния сервера
  end;
end;

procedure TMain.ShowStatusBarInfo;
var
  sSaleMode: string;
  UserData: TUserIDRecord;
  aPriceType: TPricesGroupType;
  bFix: boolean;
  dis: real;
begin
  if not data.fDatabaseOpened then
    exit;

  StatusBar.Panels[2].Text := ' Цена с нац.: <b>' +
               Data.CatalogDataSource.DataSet.FieldByName('Price_pro').AsString + '</b>';
  StatusBar.Panels[4].Text := 'Email для заказов: <b>' +
               Data.SysParamTable.FieldByName('Shate_email').AsString + '</b>     ' +
               IntToStr(rest_days) + ' дн. до окончания действия программы';

  UserData := GetCurrentUser;
  if UserData = nil then
    exit;
  {StatusBar.Panels[0].Text := ' Курс EUR: <b>' + Data.ParamTable.FieldByName('Eur_rate').AsString + ' BYR</b>' +
                              ' / <b>' + Data.ParamTable.FieldByName('Eur_Usd_rate').AsString + ' USD</b>'+
                              ' / <b>' + Data.ParamTable.FieldByName('Eur_RUB_rate').AsString + ' RUB</b>';}

  if Data.ParamTable.FieldByName('Hide_discountSB').AsBoolean then
    StatusBar.Panels[1].Text := ''
  else
  begin
    if not UserData.bUpdateDisc then
      sSaleMode := 'Скидки Шате-М'
    else
      sSaleMode := '<b> Скидки пользователя </b>';

    StatusBar.Panels[1].Text := sSaleMode + ' / Наценка: <b>' +  FormatFloat('0.##', (Data.GetMargin2(
      Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
      Data.CatalogDataSource.DataSet.FieldByName('Subgroup_id').AsInteger,
      Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger,
      Data.CatalogDataSource.DataSet.FieldByName('Price_koef_eur').AsCurrency
    ) - 1) * 100) + ' %</b>';

   {$IFDEF LOCAL}
    if not Data.CatalogDataSource.DataSet.FieldByName('fUsingOptRf').AsBoolean then
    begin
      dis := Data.GetDiscount_NEW(bFix,
               Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
               Data.CatalogDataSource.DataSet.FieldByName('Subgroup_id').AsInteger,
               Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger,
               ptOPT);
      if dis = 1 then
         dis := Data.GetDiscount_NEW(bFix,
                  Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
                  Data.CatalogDataSource.DataSet.FieldByName('Subgroup_id').AsInteger,
                  Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger,
                  ptOPT, TRUE);

       StatusBar.Panels[1].Text := sSaleMode + ': <b>' + FormatFloat('0.##', (1 - dis)
       * 100) + ' %  /  ' +

      FormatFloat('0.##', (Data.GetMargin2(
        Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
        Data.CatalogDataSource.DataSet.FieldByName('Subgroup_id').AsInteger,
        Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger,
        Data.CatalogDataSource.DataSet.FieldByName('Price_koef_eur').AsCurrency
      ) - 1) * 100) + ' %</b>';

    end

    else
    begin
      dis := Data.GetDiscount_NEW(bFix,
        Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
        Data.CatalogDataSource.DataSet.FieldByName('Subgroup_id').AsInteger,
        Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger,
        ptOPT_RF);
      if dis = 1 then
         dis := Data.GetDiscount_NEW(bFix,
                  Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
                  Data.CatalogDataSource.DataSet.FieldByName('Subgroup_id').AsInteger,
                  Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger,
                  ptOPT_RF, TRUE);

      StatusBar.Panels[1].Text := sSaleMode + ': <b>' + FormatFloat('0.##', (1 - dis) * 100) + ' %  /  ' +

      FormatFloat('0.##', (Data.GetMargin2(
        Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
        Data.CatalogDataSource.DataSet.FieldByName('Subgroup_id').AsInteger,
        Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger,
        Data.CatalogDataSource.DataSet.FieldByName('Price_koef_eur').AsCurrency
      ) - 1) * 100) + ' %</b>'

    end;
    {$ENDIF}

{
    StatusBar.Panels[1].Text := ' Скидка: <b>' + Data.ParamTable.FieldByName('Discount').AsString + ' %</b>';
    brd := XRound((1 - Data.GetDiscount(0,0,Data.CatalogTable.FieldByName('Brand_id').AsInteger)) * 100, 2);
    ttd := XRound(Data.ParamTable.FieldByName('Discount').AsFloat, 2);
    if brd <> ttd then
      StatusBar.Panels[1].Text := ' Скидка: <b>' + FloatToStr(ttd) + ' %  /  ' +
                          FloatToStr(brd) + ' %</b>'
    else
      StatusBar.Panels[1].Text := ' Скидка: <b>' + FloatToStr(ttd) + ' %</b>';
}
  end;


end;


procedure TMain.ShowStatusBarInfo2; //NewAnalog
var
  sSaleMode: string;
  UserData: TUserIDRecord;
  bFix: boolean;
  dis: real;
begin
  if not data.fDatabaseOpened then
    exit;

  UserData := GetCurrentUser;
  if UserData = nil then
    exit;

  if Data.ParamTable.FieldByName('Hide_discountSB').AsBoolean then
    StatusBar.Panels[1].Text := ''
  else
  begin
    if not UserData.bUpdateDisc then
      sSaleMode := 'Скидки Шате-М'
    else
      sSaleMode := '<b> Скидки пользователя </b>';

    StatusBar.Panels[1].Text := sSaleMode + ' / Наценка: <b>' + FormatFloat('0.##', (Data.GetMargin2(
      Data.memAnalog.FieldByName('An_Group_id').AsInteger,
      Data.memAnalog.FieldByName('An_Subgroup_id').AsInteger,
      Data.memAnalog.FieldByName('An_Brand_id').AsInteger,
      Data.memAnalog.FieldByName('Price_koef_eur').AsCurrency
    ) - 1) * 100) + ' %</b>';

    
    {$IFDEF LOCAL}
    if not Data.memAnalog.FieldByName('fUsingOptRf').AsBoolean then
    begin
      dis := Data.GetDiscount_NEW(bFix,
               Data.memAnalog.FieldByName('An_Group_id').AsInteger,
               Data.memAnalog.FieldByName('An_Subgroup_id').AsInteger,
               Data.memAnalog.FieldByName('An_Brand_id').AsInteger,
               ptOPT);
      if dis = 1 then
        dis := Data.GetDiscount_NEW(bFix,
                 Data.memAnalog.FieldByName('An_Group_id').AsInteger,
                 Data.memAnalog.FieldByName('An_Subgroup_id').AsInteger,
                 Data.memAnalog.FieldByName('An_Brand_id').AsInteger,
                 ptOPT, TRUE);

      StatusBar.Panels[1].Text := ' Скидка: <b>' + FormatFloat('0.##', (1 - dis) * 100) + ' %  /  ' +
        FormatFloat('0.##', (Data.GetMargin2(
        Data.memAnalog.FieldByName('An_Group_id').AsInteger,
        Data.memAnalog.FieldByName('An_Subgroup_id').AsInteger,
        Data.memAnalog.FieldByName('An_Brand_id').AsInteger,
        Data.memAnalog.FieldByName('Price_koef_eur').AsCurrency
        ) - 1) * 100) + ' %</b>'
    end
    else
    begin
      dis := Data.GetDiscount_NEW(bFix,
               Data.memAnalog.FieldByName('An_Group_id').AsInteger,
               Data.memAnalog.FieldByName('An_Subgroup_id').AsInteger,
               Data.memAnalog.FieldByName('An_Brand_id').AsInteger,
               ptOPT_RF);
      if dis = 1 then
        dis := Data.GetDiscount_NEW(bFix,
               Data.memAnalog.FieldByName('An_Group_id').AsInteger,
               Data.memAnalog.FieldByName('An_Subgroup_id').AsInteger,
               Data.memAnalog.FieldByName('An_Brand_id').AsInteger,
               ptOPT_RF, TRUE);

      StatusBar.Panels[1].Text := ' Скидка: <b>' + FormatFloat('0.##', (1 - dis) * 100) + ' %  /  ' +
      FormatFloat('0.##', (Data.GetMargin2(
        Data.memAnalog.FieldByName('An_Group_id').AsInteger,
        Data.memAnalog.FieldByName('An_Subgroup_id').AsInteger,
        Data.memAnalog.FieldByName('An_Brand_id').AsInteger,
        Data.memAnalog.FieldByName('Price_koef_eur').AsCurrency
      ) - 1) * 100) + ' %</b>'
    end;

   {$ENDIF}
  
  end;
  
  StatusBar.Panels[2].Text := ' Цена с нац.: <b>' +
               Data.memAnalog.FieldByName('Price_pro').AsString + '</b>';
end;


procedure TMain.SearchEdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
State : TKeyboardState;
begin
  GetKeyboardState(State);
 if ((GetKeyState(VK_CONTROL) AND 128)=128) and
     ((GetKeyState(VK_RETURN)      AND 128)=128) then
  begin
      FindInAnalog.Execute;
      exit;
  end;

  if Key in [VK_ESCAPE, VK_RETURN, VK_DOWN] then
  begin
    SearchEd.Clear;
    SearchEd.Color := clWindow;
    SearchMode := False;
    MainGrid.SetFocus;
    if Key = VK_DOWN then
      Key := 0;
  end
end;


procedure TMain.SearchModeComboBoxChange(Sender: TObject);
begin
    SearchEd.Clear;
    if Data.CatalogDataSource.Dataset.Active then
    begin
        Data.CatalogDataSource.Dataset.First;
        SearchEd.Color := clWindow;
    end;
end;

procedure TMain.SearchModeComboBoxCloseUp(Sender: TObject);
begin
  SearchEd.Clear;
  SearchEd.Color := clWindow;
  MainGrid.SetFocus;
end;

procedure TMain.SearchEdChange(Sender: TObject);
begin
  if SearchEd.Focused then
  begin
    SearchEd.Text := RemoveExtSymb(SearchEd.Text);
    SearchTimer.Enabled := True;
  end;
end;


procedure TMain.SearchTimerTimer(Sender: TObject);
begin
  SearchTimer.Enabled := False;
  Data.DoSearch;
end;

procedure TMain.SetMessageErrorProcessUpdate(var Msg: TMessage);
begin
    MessageDlg('Обновление не выполнено!!! Причина - '+PChar(msg.lParam)+'.', mtError, [mbOK],0);
    while StatusBar.Panels.Count > 5 do
    begin
      StatusBar.Panels[5].Destroy;
    end;
end;

procedure TMain.SelectInTree;
var
  i: integer;
begin
  //Tree.ClearSelection;
  if Data.Tree_mode in [0, 2] then
  begin
    if Data.fBrand <> 0 then
    begin
      for i := 0 to Tree.Items.Count - 1 do
      begin
        if (Tree.Items[i].Level = 3) and
          (Integer(Tree.Items[i].Parent.Parent.Data) = Data.Group) and
          (Integer(Tree.Items[i].Parent.Data) = Data.Subgroup) and
          (Integer(Tree.Items[i].Data) = Data.fBrand) then
        begin
          Tree.Items[i].Parent.Parent.Expand(False);
          Tree.Items[i].Parent.Expand(False);
          //Tree.SelectItem(Tree.Items[i]);
          Tree.Items[i].Selected := True;
          break;
        end;
      end;
    end
    else if Data.Subgroup <> 0 then
    begin
      for i := 0 to Tree.Items.Count - 1 do
      begin
        if (Tree.Items[i].Level = 2) and
          (Integer(Tree.Items[i].Parent.Data) = Data.Group) and
          (Integer(Tree.Items[i].Data) = Data.Subgroup) then
        begin
          Tree.Items[i].Parent.Expand(False);
          //Tree.SelectItem(Tree.Items[i]);
          Tree.Items[i].Collapse(True);
          Tree.Items[i].Selected := True;
          break;
        end;
      end;
    end
    else if Data.Group <> 0 then
    begin
      for i := 0 to Tree.Items.Count - 1 do
      begin
        if (Tree.Items[i].Level = 1) and
          (Integer(Tree.Items[i].Data) = Data.Group) then
        begin
          //Tree.SelectItem(Tree.Items[i]);
          Tree.Items[i].Collapse(True);
          Tree.Items[i].Selected := True;
          break;
        end;
      end;
    end
    else
    begin
      //Tree.SelectItem(Tree.Items[0]);
      Tree.Items[0].Selected := True;
    end;
  end
  else if Data.Tree_mode in [1, 3] then
  begin
    if Data.Subgroup <> 0 then
    begin
      for i := 0 to Tree.Items.Count - 1 do
      begin
        if (Tree.Items[i].Level = 2) and
          (Integer(Tree.Items[i].Parent.Data) = Data.fBrand) and
          (Integer(Tree.Items[i].Data) mod 1000 = Data.Subgroup) and
          (Integer(Tree.Items[i].Data) div 1000 = Data.Group) then
        begin
          Tree.Items[i].Parent.Expand(False);
          //Tree.SelectItem(Tree.Items[i]);
          Tree.Items[i].Selected := True;
          break;
        end;
      end;
    end
    else if Data.fBrand <> 0 then
    begin
      for i := 0 to Tree.Items.Count - 1 do
      begin
        if (Tree.Items[i].Level = 1) and
          (Integer(Tree.Items[i].Data) = Data.fBrand) then
        begin
          //Tree.SelectItem(Tree.Items[i]);
          Tree.Items[i].Collapse(True);
          Tree.Items[i].Selected := True;
          break;
        end;
      end;
    end
    else
    begin
      //Tree.SelectItem(Tree.Items[0]);
      Tree.Items[0].Selected := True;
    end;
  end;
end;


procedure TMain.SendAscQuantExecute(Sender: TObject);
begin
  if TimerAskQuants.Enabled then
  begin
    MessageDlg('Подождите!', mtInformation, [mboK],0);
    Exit;
  end;

  if AnalogGrid.Focused then
    AddAnToOrder(True{aRequestQuants})
  else
    AddToOrder('', True{aRequestQuants});
end;


function TMain.SendOrderTCP(anEMail, aFileName, aInf: string; aCustomOrder: Integer = 0): Boolean;

  procedure MarkSending;
  begin
    with Data.OrderTable do
    begin
      Edit;
      FieldByName('Sent').Value := '1';
      FieldByName('Sent_time').AsDateTime := Now;
      Post;
    end;
  end;

var
  s, email, fname, subj: string;
  F: TextFile;
begin
  Result := False;

  if aCustomOrder > 0 then
    if not Data.OrderTable.Locate('ORDER_ID', aCustomOrder, []) then
      Exit;
  try
    if not DoTcpConnect(TCPClient) then
      Exit;

    email := anEMail;
    fname := aFileName;

    subj := 'ClientID: ' + Data.OrderTable.FieldByName('Cli_id').AsString +
            ' OredrID: ' +  Data.OrderTable.FieldByName('Order_id').AsString +
            ' Date/Num: ' + Data.OrderTable.FieldByName('Date').AsString + '/'+
            Data.OrderTable.FieldByName('Num').AsString + Data.OrderTable.FieldByName('Type').AsString + aInf;

    try
      TCPClient.IOHandler.Writeln(email);
      TCPClient.IOHandler.Writeln(subj);
      TCPClient.IOHandler.Writeln(ExtractFileName(fname));
      AssignFile(F, fname);
      Reset(F);
      while not System.Eof(F) do
      begin
        System.Readln(F, s);
        if length(s) > 0 then
          TCPClient.IOHandler.Writeln(s);
      end;
      CloseFile(F);

      SaveAssortmentExpansionProc(FALSE);

      fname := Data.Export_Path + Data.OrderTable.FieldByName('Cli_id').AsString + '_' + Data.OrderTable.FieldByName('Sign').AsString + '_0.csv';
      if FileExists(fname) then
      begin
        TCPClient.IOHandler.Writeln('WaitList');
        TCPClient.IOHandler.Writeln(ExtractFileName(fname));
        AssignFile(F,fname);
        Reset(F);
        while not System.Eof(F) do
        begin
          System.Readln(F, s);
          if length(s) > 0 then
            TCPClient.IOHandler.Writeln(s);
        end;
        CloseFile(F);
      end;

      TCPClient.IOHandler.Writeln('FINALYSEND');
      s := TCPClient.IOHandler.ReadLnWait;
      MarkSending;
      if s = 'TRUE' then
      begin
        Result := True;
        if FileExists(fname) then
        begin
          AllPost;
          DeleteFile(fname);
        end;
        MessageDlg(Data.SysParamTable.FieldByName('Ord_send_info').AsString, mtInformation, [mbOK], 0);
      end
      else
      begin
        MessageDlg('Заказ не отправлен!', mtInformation, [mbOK], 0);
      end;
    finally
      TCPClient.Disconnect;
    end;
    Result := True;
    
  except
    on e: EIdException do
      MessageDlg('Ошибка соединения: ' + e.Message, mtError, [mbOK], 0);
    on e: Exception do
      MessageDlg('Ошибка: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

procedure TMain.SendReturnDocActionExecute(Sender: TObject);
var
  subj, email, s, inf : string;
  fname: string;
  F:TextFile;
  UserData, UserDataOrder: TUserIDRecord;
begin
  //Отправка возврата
  if not CheckClientID then
    Exit;
  UserData := GetCurrentUser;

  fname := 'RET_'+Data.ReturnDocTable.FieldByName('Cli_id').AsString + '_' +
        Data.ReturnDocTable.FieldByName('RetDoc_id').AsString + '_' +
        Data.ReturnDocTable.FieldByName('Data').AsString + '_' +
        Data.ReturnDocTable.FieldByName('Num').AsString +
        Data.ReturnDocTable.FieldByName('Agreement_No').AsString + '.csv';

  if (Data.ReturnDocTable.FieldByName('Agreement_No').AsString = '') or
         (Pos('Контрагент не найден', Data.ReturnDocTable.FieldByName('AgrDescr').AsString) > 0) then
  begin
    MessageDlg('Не заполнен "Контрагент"!', mtError, [mbOK], 0);
    Exit;
  end
  else if not Data.ContractsCliTable.Locate('Contract_id;cli_id',
    VarArrayOf([Data.ReturnDocTable.FieldByName('Agreement_No').AsString,
                Data.ReturnDocTable.FieldByName('cli_id').AsString]),[]) then
  begin
    MessageDlg('Не найден "Контрагент"!', mtError, [mbOK], 0);
    Exit;
  end;

  if (Data.ReturnDocTable.FieldByName('Delivery').AsInteger = 1) and (length(Data.ReturnDocTable.FieldByName('Addres_Id').AsString) < 1) then
  begin
    MessageDlg('Не выбран адрес доставки!', mtError, [mbOK], 0);
    Exit;
   end;

  if (Data.ReturnDocTable.FieldByName('fDefect').AsBoolean)  and
      (Length(Data.ReturnDocTable.FieldByName('Note').AsString) < 1) then
  begin
    MessageDlg('Не заполнено "Описание неисправности" в возврате!', mtError, [mbOK], 0);
    Exit;
  end;    

  if Data.ReturnDocTable.FieldByName('fDefect').AsBoolean then
    if MessageDlg(' Если запчасть устанавливалась на автомобиль, необходимо предоставить следующий пакет документов:' +
                  ' '#13#10' 1) Копия заказ-наряда. ' +
                  ' '#13#10' 2) Копия сертификата соответствия СТО ' +
                  ' '#13#10' 3) Акт дефектации на деталь' +
                  ' '#13#10'Вы подтверждаете наличие у вас всех документов?',
          mtWarning, [mbYes, mbNo], 0) <> mrYes then

      Exit;

  if not SaveReturnDoc(fname) then
    Exit;

  fname := Data.Export_Path+fname;
  if Data.ReturnDocTable.FieldByName('RetDoc_id').AsInteger = 0 then
    Exit;

  if Data.ReturnDocTable.FieldByName('Cli_id').AsString = '' then
  begin
    MessageDlg('Не указан идентификатор клиента в возврате!', mtError, [mbOK], 0);
    Exit;
  end;

  if (Data.ReturnDocTable.FieldByName('Post').AsString = '2') then
  begin
    if MessageDlg('Документ уже отправлялся ' + Data.ReturnDocTable.FieldByName('Sent_time').AsString +'. Повторить?',
       mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
       Exit;
  end

  else if MessageDlg('Отправить документ по электронной почте в офис Шате-М плюс?',
          mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
       Exit;

  with Data.ReturnDocTable do
  begin
    if FieldByName('Note').AsString <> '' then
       inf := ' [' + FieldByName('Note').AsString + ']'
    else
       inf := '';
    subj :=  ' Возврат  - ClientID: ' + FieldByName('Cli_id').AsString +
             ' Ret_ID: ' +  FieldByName('RetDoc_id').AsString +
             ' Date/Num: ' + FieldByName('Data').AsString + '/' +
             FieldByName('Num').AsString + FieldByName('Type').AsString + inf;
  end;

  if Data.ParamTable.FieldByName('TCP_Direct').AsBoolean then
  begin
    UserDataOrder := GetUserDataByID(Data.ReturnDocTable.FieldByName('Cli_id').AsString);

    if not Assigned(UserDataOrder) then
    begin
      Application.MessageBox(PChar('Идентификатор клиента [' + Data.ReturnDocTable.FieldByName('Cli_id').AsString + '] указанный в возврате не найден в базе!'#13#10 +
                                   'Отредактируйте возврат или создайте клиента с нужным идентификатором'),
                                   'Ошибка',MB_OK or MB_ICONERROR);
      Exit;
    end;

    email := Trim(UserDataOrder.sEMail); //мыло пользователя заказа
    if email = '' then
      if UserDataOrder.sID <> UserData.sID then
        if Application.MessageBox(PChar('Для идентификатора клиента указанного в возврате не задан E-Mail!'#13#10 +
                 'Отправить используя E-Mail текущего клиента?'), 'Подтверждение',
                 MB_YESNO or MB_ICONWARNING) = IDYES then
           email := Trim(UserData.sEMail) //мыло текущего пользователя
        else
          Exit;

    email := Trim(UserData.sEMail);
    if email = '' then
    begin
      MessageDlg('Настройте E-Mail текушего клиента в параметрах программы!', mtError, [mbOK], 0);
      Exit;
    end;

    if not DoTcpConnect(TCPClient) then
      Exit;
    try
      TCPClient.IOHandler.Writeln(email);
      TCPClient.IOHandler.Writeln(subj);
      TCPClient.IOHandler.Writeln(ExtractFileName(fname));
      AssignFile(F, fname);
      Reset(F);
      while not System.Eof(F) do
      begin
        System.Readln(F, s);
        if length(s) >0 then
          TCPClient.IOHandler.Writeln(s);
      end;
      CloseFile(F);
      TCPClient.IOHandler.Writeln('FINALYSEND');
      s := TCPClient.IOHandler.ReadLnWait;

      if s = 'TRUE' then
      begin
        Data.ReturnDocTable.Edit;
        Data.ReturnDocTable.FieldByName('Post').AsInteger := 2;
        Data.ReturnDocTable.FieldByName('Sent_time').AsDateTime := Now;
        Data.ReturnDocTable.Post;
        MessageDlg('Возврат отправлен', mtInformation, [mbOK], 0);
      end
      else
        MessageDlg('Документ не отправлен!', mtInformation, [mbOK], 0);
    finally
      TCPClient.Disconnect;
    end;
  end
  else
  begin
    with Mailer do
    begin
      Clear;
      Recipient.AddRecipient(Data.SysParamTable.FieldByName('Shate_email').AsString);
      //Recipient.AddRecipient(Data.SysParamTable.FieldByName('ReturnDocEmail').AsString);
      Subject := subj;
      Attachment.Add(fname);
      try
        SendMail;
        Data.ReturnDocTable.Edit;
        Data.ReturnDocTable.FieldByName('Post').AsInteger := 2;
        Data.ReturnDocTable.FieldByName('Sent_time').AsDateTime := Now;
        Data.ReturnDocTable.Post;
      except
      //
      end;
    end;
  end;
end;

procedure TMain.AddToOrder(sRealValue: string = ''; aRequestQuants: Boolean = False);
var
  bNew: Boolean;
  UserData, UserDataOrder: TUserIDRecord;
  aSavedOrderID: Integer;
  ZakTabRect: TRect;
begin
  if Data.CatalogDataSource.DataSet.FieldByName('OrderOnly').AsBoolean then
  begin
    TOrderOnlyInfoForm.Execute(
      Data.CatalogDataSource.DataSet.FieldByName('Code').AsString,
      Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString,
      Data.CatalogDataSource.DataSet.FieldByName('Name_Descr').Asstring
    );
    Exit;
  end;

  SearchTimer.Enabled := FALSE;
  bNew:=FALSE;
  if not CheckClientId then
    Exit;
  UserData := GetCurrentUser;

  if Data.CatalogDataSource.DataSet.FieldByName('Title').AsBoolean or
     (Data.CatalogDataSource.DataSet.FieldByName('Cat_id').AsInteger = 0) or
     (Data.CatalogDataSource.DataSet.FieldByName('PriceItog').AsCurrency = 0)or
     (Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString = '') then
    Exit;

  if (Data.OrderTable.FieldByName('Sent').AsString <> '')and(Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
  begin
     if sRealValue = '' then
       if MessageDlg('Добавление в выбранный заказ невозможно !!! Заказ уже был отправлен в офис компании и вероятно уже обработан. Для проверки зарезервированного товара нажмите кнопку "TCP ответ". Создать новую корзину ?',mtInformation ,[mbYes,mbNo], 0) = mrNo  then
         Exit;
     bNew:=TRUE;
  end;

  if (Data.OrderTable.FieldByName('Order_id').AsInteger = 0) or bNew then
    if not NewOrder then
      Exit;

  if Data.OrderTable.FieldByName('cli_id').AsString <> UserData.sID then
  begin
    if Data.ParamTable.FieldByName('AutoSwitchCurClient').AsBoolean or
       (Application.MessageBox('Идентификатор клиента в заказе отличается от текущего.'#13#10 +
                              'Установить текущим идентификатор из заказа?', 'Предупреждение', MB_YESNO or MB_ICONWARNING) = IDYES) then
    begin
      UserDataOrder := GetUserDataByID(Data.OrderTable.FieldByName('cli_id').AsString);
      if not Assigned(UserDataOrder) then
      begin
        Application.MessageBox('Идентификатор клиента указанный в заказе не найден!', 'Ошибка', MB_OK or MB_ICONERROR);
        Exit;
      end;
      aSavedOrderID := Data.OrderTable.FieldByName('Order_id').AsInteger;
      try
        Data.SetDefaultClient(UserDataOrder.sID);
        CliComboBox.KeyValue := UserDataOrder.sID;
        SetActiveCli(UserDataOrder);
        Application.ProcessMessages;
      finally
        Data.OrderTable.Locate('Order_id', aSavedOrderID, []);
      end;
    end
    else
      Exit;
  end;

  with TQuantityEdit.Create(Application) do
  try
    Init(
      Data.OrderTable.FieldByName('Order_id').AsInteger,
      Data.OrderTable.FieldByName('Cli_id').AsString,
      True,
      Data.CatalogDataSource.DataSet.FieldByName('Code').AsString,
      Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString,
      aRequestQuants
    );

    Caption := 'Количество товара в заказе';
    ArtInfo.Text := Data.CatalogDataSource.DataSet.FieldByName('Code').Asstring + '  ' + Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString + #13#10 + 
                    Data.CatalogDataSource.DataSet.FieldByName('Name_Descr').Asstring;
    MultInfo.Value := Data.CatalogDataSource.DataSet.FieldByName('Mult').AsInteger;
    if MultInfo.Value <> 0 then
      QuantityEd.Value := MultInfo.Value
    else
      QuantityEd.Value := 1;

     if sRealValue <> '' then
     begin
        if sRealValue <> '-2' then
          Label4.Caption := 'На данный момент доступно: ' + sRealValue
        else
          Label4.Caption := 'Не возим';
     end
     else
      Label4.Visible := FALSE;


    if ShowModal = mrOk then
    begin
      if ResOrderId > 0 then
      begin
        if not Data.OrderTable.Locate('Order_ID', ResOrderId , []) then
        begin
          if OrderDateEd1.Date > ResOrderDate then
            OrderDateEd1.Date := ResOrderDate;
          if OrderDateEd2.Date < ResOrderDate then
            OrderDateEd2.Date := ResOrderDate;
          UpdateOrdersFilter(UserData);
          Data.OrderTable.Locate('Order_ID', ResOrderId , []);
        end;
      end;

      if not bNew then
      begin
         with Data.OrderDetTable do
          begin
            if Locate('Order_id;Code2;Brand',
              VarArrayOf([Data.OrderTable.FieldByName('Order_id').AsInteger,
                          Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString,
                          Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString]), []) then
              if Data.ParamTable.FieldByName('ShowMessageAddOrder').AsBoolean then
              if MessageDlg('Внимание, такая позиция уже добавлена. Продолжить?',mtInformation, [MBYES, MBNO],0) = mrNo then
              exit;
          end;
      end;

      with Data.OrderDetTable do
      begin
        Data.OrderDetTable.DisableControls;
        try
          if not Locate('Order_id;Code2;Brand',
            VarArrayOf([Data.OrderTable.FieldByName('Order_id').AsInteger,
                        Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString,
                        Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString]), []) then
          begin

            Append;
            FieldByName('Order_id').Value :=
               Data.OrderTable.FieldByName('Order_id').AsInteger;
            FieldByName('Code2').Value :=
               Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString;
            FieldByName('Brand').Value :=
               Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString;
            FieldByName('Price').Value :=
               Data.CatalogDataSource.DataSet.FieldByName('Price_koef_eur').AsCurrency;
            //price_pro???
            CalcProfitPriceForOrdetDetCurrent;
          end
          else
            Edit;

          FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat +
                                             QuantityEd.Value;
          FieldByName('Info').Value := InfoEd.Text;
          Post;
        finally
          Data.OrderDetTable.EnableControls;
        end;

      end;
      with Data.OrderTable do
      begin
        Edit;
        FieldByName('Dirty').Value := True;
        Post;
        Refresh;
      end;
      Data.OrderTableAfterScroll(Data.OrderTable);
      if Data.CatalogDataSource.DataSet.Active then
        Data.CatalogDataSource.DataSet.Refresh; 
    end;
  finally
    Free;
  end;
  MainGrid.SetFocus;
  SearchEd.Text := '';
  //панель может быть отключена
  if SearchToolBar.Visible then
    SearchEd.SetFocus;
  CountingOrderSum;
  {$IFNDEF LOCAL}
  if Data.ParamTable.FieldByName('bWarnOrderLimits').AsBoolean then
  begin
    if Data.OrderDetTable.RecordCount > cMaxOrderDetCount then
    begin
      Pager.ActivePage := CatZakPage;
      ZakTabRect := Pager.GetTabRect(CatZakPage);
      ShowBallonWarn(Pager, lbOrderFlame.Caption, 'Предупреждение', ZakTabRect.Left + 9, (ZakTabRect.Top + ZakTabRect.Bottom) div 2);
    end;
  end;
  {$ENDIF}
end;

procedure TMain.AboutBrandClick(Sender: TObject);
var
  s:string;
begin
   s :=Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString;
  // if (not isOpenedMoreThan2Windows('Info')) then
   with TInfo.Create(Application) do
    begin
      Caption := 'Информация по брендам';
      Browser.Navigate(GetAppDir + 'Brands.html');
      SelectBrand := 'ДляПоиска'+s+'|';
      ShowModal;
      Free;
    end;
end;

procedure TMain.acShowOrdersInPofitPricesExecute(Sender: TObject);

  function FindCol(aGrid: TDBGridEh; const aFieldName: string): TColumnEh;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to aGrid.Columns.Count - 1 do
      if SameText(aGrid.Columns[i].FieldName, aFieldName) then
      begin
        Result := aGrid.Columns[i];
        Break;
      end;
  end;

  procedure ChangeField(aCol: TColumnEh; const aNewFieldName: string; const aNewCaption: string = '');
  var
    aWidth: Integer;
  begin
    if Assigned(aCol) then
    begin
      aWidth := aCol.Width;
      aCol.FieldName := aNewFieldName;
      aCol.Width := aWidth;
      if aNewCaption <> '' then
        aCol.Title.Caption := aNewCaption;
    end;
  end;

  procedure ReWriteParam(const aNewParam: boolean);
  begin
    Data.ParamTable.Edit;
    Data.ParamTable.FieldByName('bCalcOrderWithMargin').AsBoolean := aNewParam;
    Data.ParamTable.Post;
  end;

begin
  OrderGrid.Columns.BeginUpdate;
  OrderGrid.AutoFitColWidths := False;
  OrderDetGrid.Columns.BeginUpdate;
  OrderDetGrid.AutoFitColWidths := False;

  if not fForceCallMarginAction then
    ReWriteParam(not Data.ParamTable.FieldByName('bCalcOrderWithMargin').AsBoolean);
  fForceCallMarginAction := False;

  try
    if Data.ParamTable.FieldByName('bCalcOrderWithMargin').AsBoolean then
    begin
      ChangeField(FindCol(OrderGrid, 'Sum'), 'sum_pro');
      ChangeField(FindCol(OrderDetGrid, 'Price_koef'), 'Price_pro_koef', 'Цена с нац.');
      ChangeField(FindCol(OrderDetGrid, 'Sum'), 'sum_pro', 'Сумма с нац.');
    end
    else
    begin
      ChangeField(FindCol(OrderGrid, 'sum_pro'), 'Sum');
      ChangeField(FindCol(OrderDetGrid, 'Price_pro_koef'), 'Price_koef', 'Цена');
      ChangeField(FindCol(OrderDetGrid, 'sum_pro'), 'Sum', 'Сумма');
    end;
    CurrencyChanged;
  finally
    OrderGrid.AutoFitColWidths := True;
    OrderGrid.Columns.EndUpdate;
    OrderDetGrid.AutoFitColWidths := True;
    OrderDetGrid.Columns.EndUpdate;
  end;
  ZakTabInfo;
end;

procedure TMain.acShowUpdateChangesExecute(Sender: TObject);
begin
  if Assigned(ChangesInBase) then
  begin
    ChangesInBase.Show;
    ChangesInBase.BringToFront;
    Exit;
  end;

  if FileExists(Data.Import_Path + 'UpdateInfo.csv') then
  begin
    if _Data.GetFileSize_Internal(Data.Import_Path + 'UpdateInfo.csv') = 0 then
      Exit;

    ChangesInBase := TChangesInBase.Create(Application);
    ChangesInBase.Init(Data.Import_Path + 'UpdateInfo.csv');
    ChangesInBase.FormStyle := fsStayOnTop;
    ChangesInBase.Show;
  end
  else
    ShowMessage('Файл с изменениями не найден!');
end;

procedure TMain.acTTNRetDocInformationExecute(Sender: TObject);
  const
    MAIN_NODE_NAME = 'Direction'; {главный узел, внутри основная инфа}

  procedure loadXML(const aDataString: widestring);
  var
    i, j: integer;
    XMLDoc: IXMLDOMDocument;
    Nodes: IXMLDOMNodeList;
    Root: IXMLDOMElement;
    sValueNode, sNameNode: string;
  begin
    XMLDoc := CoDOMDocument60.Create; //нельзя FREE???
    XMLDoc.Async := False;
    XMLDoc.loadXML(aDataString);

    if not Data.memRetDocTTNInfoTable.Exists then
      Data.memRetDocTTNInfoTable.CreateTable
    else
    begin
      Data.memRetDocTTNInfoTable.Close;
      Data.memRetDocTTNInfoTable.EmptyTable;      
    end;  
    Data.memRetDocTTNInfoTable.Open;
    try
      Nodes := XMLDoc.DocumentElement.getElementsByTagName(MAIN_NODE_NAME);

      for j := 0 to Nodes.length - 1 do
      begin
        Data.memRetDocTTNInfoTable.Append;
        for i := 0 to Nodes.item[j].childNodes.length - 1 do
        begin
          sNameNode := Nodes.item[j].childNodes.item[i].nodeName;
          sValueNode := Nodes.item[j].childNodes.item[i].Text;

          if Data.memRetDocTTNInfoTable.FindField(sNameNode) <> nil then
            Data.memRetDocTTNInfoTable.FieldByName(sNameNode).AsString := sValueNode;
        end;
        Data.memRetDocTTNInfoTable.Post;
      end;
    except
      on e: Exception do
        MessageDlg('Данные по возврату не найдены! Попробуйте чуть позже. ' + e.Message , mtInformation, [mbOK],0);
    end;
  end;

var
  Stream: TStringStream;
  TCPClient: TIdTCPClient;
  sResponse, sRequest: string;
  UserData: TUserIDRecord;
  ST: TStringList; 
begin
  TCPClient:= TIdTCPClient.Create(nil);
  UserData := GetCurrentUser();
  Stream := TStringStream.Create('');
  ST := TstringList.Create();
  if not DoTcpConnect(TCPClient, True, True) then
    Exit;
  try
    try
      sRequest := 'TTN_FOR_RETDOC_' + UserData.sId + '_4123';
      TCPClient.IOHandler.Writeln(sRequest);

      sResponse := TCPClient.IOHandler.ReadLnWait;
      if(sResponse = 'END') then
      begin
        MessageDlg('Не удалось получить информацию по возврату!', mtInformation, [mbOK], 0);
        TCPClient.Disconnect;
        exit;
      end;

      while sResponse <> 'END' do
      begin
        if sResponse = 'BINFILE' then
        begin
          Stream.Position := 0;
          TCPClient.IOHandler.ReadStream(Stream, -1, False);
        end;
        sResponse := TCPClient.IOHandler.ReadLnWait;
      end;

    except
      on e: Exception do
      begin
        MessageDlg('Ошибка: ' + e.Message,mtError,[mbOK],0);
        TCPClient.Disconnect;
        Exit;
      end;
    end;

    if Stream.Size > 0 then
    begin
      if pos('<Direction>', Stream.DataString) > 0 then
        loadXML(Stream.DataString)//основаная логика
      else
        ST.Append(Stream.DataString);//если передан не XML а текст - выводим полностью 

      with TTTNRetDocInformationForm.Create(nil) do
      begin
        FillInformation(ST.Text);
        ShowModal;
        Free;
      end;
    end
    else
      MessageDlg('Информация по ТТН не найдена! Повторите попытку позже, возможно файл еще не сформирован.',
                  mtInformation, [mbOK],0);
  finally
    Stream.Free;
    ST.Free;
  end;

end;

procedure TMain.acAddAnToKKExecute(Sender: TObject); //NewAnalog
begin
  if Data.memAnalog.FieldByName('An_id').AsInteger <= 0 then
    Exit;

  if Data.memAnalog.FieldByName('Quantity').AsString = '' then
    if Application.MessageBox('Эта позиция недоступна к заказу (не возим). Вы действительно хотите добавить ее в коммерческое предложение?', 'Подтверждение', MB_YESNO or MB_ICONQUESTION) <> IDYES then
      Exit;

  if not AddGoodsToKK(Data.MakeSearchCode(Data.memAnalog.FieldByName('An_Code').AsString),
                      Data.memAnalog.FieldByName('An_Brand').AsString) then
    Application.MessageBox('Уже есть в списке', 'Сообщение', MB_OK or MB_ICONINFORMATION);
end;

procedure TMain.acAddToKKExecute(Sender: TObject);
begin
  if (Data.CatalogDataSource.DataSet.FieldByName('Cat_Id').AsInteger = 0) or
     (Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString = '') then
    Exit;

  if Data.CatalogDataSource.DataSet.FieldByName('Quantity').AsString = '' then
    if Application.MessageBox('Эта позиция недоступна к заказу (не возим). Вы действительно хотите добавить ее в коммерческое предложение?', 'Подтверждение', MB_YESNO or MB_ICONQUESTION) <> IDYES then
      Exit;

  if not AddGoodsToKK(Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString,
                      Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString) then
    Application.MessageBox('Уже есть в списке', 'Сообщение', MB_OK or MB_ICONINFORMATION);
end;

procedure TMain.acApplyOrderAnswerExecute(Sender: TObject);
begin
  ApplyOrderAnswer;
  SetActionEnabled;
end;

procedure TMain.acApplyRetdocAnswerExecute(Sender: TObject);
begin
  ApplyRetdocAnswer;
end;



procedure TMain.acFindGoodsInOrdersExecute(Sender: TObject);
var
  anOrderID, anOrderDetID: Integer;
begin
  if TFormOrderedInfo.Execute(
    Data.CatalogDataSource.DataSet.FieldByName('CODE2').AsString,
    Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString,
    Data.CatalogDataSource.DataSet.FieldByName('Name_Descr').AsString,
    anOrderID,
    anOrderDetID
  ) then
  begin
    Pager.ActivePage := CatZakPage;
    OrderDateEd1.Date := 0;
    OrderDateEd2.Date := Date;
    OrderDateEdChange(OrderDateEd1);
    Data.OrderTable.Locate('Order_id', anOrderID, []);
    Data.OrderDetTable.Locate('ID', anOrderDetID, []);
    if OrderDetGrid.CanFocus then
      OrderDetGrid.SetFocus;
  end;

//  Data.ExportTable(Data.ArtTypTable, 'd:\arttyp.csv', 'экспорт ', 'ART_ID;TYP_ID');
//  Data.AllClose;
//  Data.LoadTimer.Enabled := False;
//  Data.ImportTable(Data.ArtTypTable, 'd:\arttyp.csv', 'импорт ', 'ART_ID;TYP_ID');
end;

procedure TMain.acFindGoodsInOrdersUpdate(Sender: TObject);
begin
  acFindGoodsInOrders.Enabled :=
    (Data.CatalogDataSource.DataSet.Active) and
    (Data.CatalogDataSource.DataSet.FieldByName('CODE2').AsString <> '');
end;

procedure TMain.acKitAddToOrderExecute(Sender: TObject);
var
  bNew: boolean;
  UserData, UserDataOrder: TUserIDRecord;
  aSavedOrderID: Integer;
  aCode, aBrand: string;
  aMult: Integer;
  ZakTabRect: TRect;
begin
  aMult := 1;
  if (Data.KitTable.FieldByName('CHILD_ID').AsInteger = 0) or
     (Data.KitTable.FieldByName('Price_koef').AsCurrency = 0) then
    Exit;

  if not CheckClientId then
    Exit;
  UserData := GetCurrentUser;

  bNew := False;
  if (Data.OrderTable.FieldByName('Sent').AsString <> '')and(Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
  begin
     if MessageDlg('Добавление в выбранный заказ невозможно !!! Заказ уже был отправлен в офис компании и вероятно уже обработан. Для проверки зарезервированного товара нажмите кнопку "TCP ответ". Создать новую корзину ?',mtInformation ,[mbYes,mbNo], 0) = mrNo  then
       Exit;
     bNew := TRUE;
  end;

  if (Data.OrderTable.FieldByName('Order_id').AsInteger = 0) or bNew then
    if not NewOrder then
      Exit;

  if Data.OrderTable.FieldByName('cli_id').AsString <> UserData.sID then
  begin
    if Data.ParamTable.FieldByName('AutoSwitchCurClient').AsBoolean or
       (Application.MessageBox('Идентификатор клиента в заказе отличается от текущего.'#13#10 +
                              'Установить текущим идентификатор из заказа?', 'Предупреждение', MB_YESNO or MB_ICONWARNING) = IDYES) then
    begin
      UserDataOrder := GetUserDataByID(Data.OrderTable.FieldByName('cli_id').AsString);
      if not Assigned(UserDataOrder) then
      begin
        Application.MessageBox('Идентификатор клиента указанный в заказе не найден!', 'Ошибка', MB_OK or MB_ICONERROR);
        Exit;
      end;
      aSavedOrderID := Data.OrderTable.FieldByName('Order_id').AsInteger;
      try
        Data.SetDefaultClient(UserDataOrder.sID);
        CliComboBox.KeyValue := UserDataOrder.sID;
        SetActiveCli(UserDataOrder);
        Application.ProcessMessages;
      finally
        Data.OrderTable.Locate('Order_id', aSavedOrderID, []);
      end;
    end
    else
      Exit;
  end;

  aCode := '';
  aBrand := '';
  if Data.XCatTable.Locate('CAT_ID', Data.KitTable.FieldByName('Child_id').AsInteger, []) then
    if Data.BrandTable.Locate('BRAND_ID', Data.XCatTable.FieldByName('BRAND_ID').AsInteger, []) then
    begin
      aCode := Data.XCatTable.FieldByName('CODE').AsString;
      aBrand := Data.BrandTable.FieldByName('Description').AsString;
      aMult := Data.XCatTable.FieldByName('Mult').AsInteger;
    end;

  with TQuantityEdit.Create(Application) do
  begin
    Init(
      Data.OrderTable.FieldByName('Order_id').AsInteger,
      Data.OrderTable.FieldByName('Cli_id').AsString,
      True,
      aCode,
      aBrand,
      False{aRequestQuants (F7)}
    );

    Caption := 'Количество товара в заказе';
    ArtInfo.Text := aCode + '  ' + aBrand + #13#10 +
                    Data.KitTable.FieldByName('Descr').Asstring;
    MultInfo.Value := aMult;
    if MultInfo.Value <> 0 then
      QuantityEd.Value := MultInfo.Value
    else
      QuantityEd.Value := 1;
    if ShowModal = mrOk then
    begin
      if ResOrderId > 0 then
      begin
        if not Data.OrderTable.Locate('Order_ID', ResOrderId , []) then
        begin
          if OrderDateEd1.Date > ResOrderDate then
            OrderDateEd1.Date := ResOrderDate;
          if OrderDateEd2.Date < ResOrderDate then
            OrderDateEd2.Date := ResOrderDate;
          UpdateOrdersFilter(UserData);
          Data.OrderTable.Locate('Order_ID', ResOrderId , []);
        end;
      end;

      with Data.OrderDetTable do
      begin
        if not Locate('Order_id;Code2;Brand',
          VarArrayOf([Data.OrderTable.FieldByName('Order_id').AsInteger,
                      aCode,
                      aBrand]), [loCaseInsensitive]) then
        begin
          Append;
          FieldByName('Order_id').Value :=
               Data.OrderTable.FieldByName('Order_id').AsInteger;
          FieldByName('Code2').Value :=
               Data.MakeSearchCode(aCode);
          FieldByName('Brand').Value :=
               AnsiUpperCase( aBrand );
          FieldByName('Price').Value :=
            Data.KitTable.FieldByName('Price_koef_eur').AsCurrency;
          //price_pro???
          CalcProfitPriceForOrdetDetCurrent;
        end
        else
        if MessageDlg('Внимание, такая позиция уже добавлена. Продолжить?',mtInformation, [MBYES, MBNO],0) = mrNo then
          exit
        else
          Edit;
        FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat +
                                         QuantityEd.Value;
        FieldByName('Info').Value := InfoEd.Text;
        Post;
      end;
      with Data.OrderTable do
      begin
        Edit;
        FieldByName('Dirty').Value := True;
        Post;
        Refresh;
      end;
      Data.OrderTableAfterScroll(Data.OrderTable);
      //Data.KitTable.Refresh;
    end;
    Free;
  end;

  {$IFNDEF LOCAL}
  if Data.ParamTable.FieldByName('bWarnOrderLimits').AsBoolean then
  begin
    if Data.OrderDetTable.RecordCount > cMaxOrderDetCount then
    begin
      Pager.ActivePage := CatZakPage;
      ZakTabRect := Pager.GetTabRect(CatZakPage);
      ShowBallonWarn(Pager, lbOrderFlame.Caption, 'Предупреждение', ZakTabRect.Left + 9, (ZakTabRect.Top + ZakTabRect.Bottom) div 2);
    end;
  end;
  {$ENDIF}
end;


procedure TMain.acKitMoveToPosExecute(Sender: TObject);
begin
  GoToCatID(Data.KitTable.FieldByName('CHILD_ID').AsInteger);
end;

procedure TMain.acKKDeleteAllExecute(Sender: TObject);
begin
  if Application.MessageBox('Удалить все позиции из коммерческого предложения', 'Подтверждение', MB_YESNO or MB_ICONQUESTION) <> IDYES then
    Exit;
  Data.KK.Close;
  Data.KK.EmptyTable;
  Data.KK.Open;
end;

procedure TMain.acKKLoadExecute(Sender: TObject);
var
  aFileName: string;
begin
  //Загрузить коммерческое предложение
  Data.OpenDialog.InitialDir := Data.Export_Path;
  Data.OpenDialog.FileName := '';
  if not Data.OpenDialog.Execute then
    Exit;

  aFileName:= Data.OpenDialog.FileName;

  Data.KK.Close;
  Data.KK.EmptyTable;
  Data.KK.Open;

  Data.KK.ImportTable(aFileName, ';');
end;

procedure TMain.acKKMoveToPosExecute(Sender: TObject);
begin
  GoToCatID(Data.KK.FieldByName('Cat_Id').AsInteger);
end;

procedure CreateFormFromStream(AOwner: TComponent; InstanceClass: TComponentClass;
  var Reference; Stream: TStream);
var
  Instance: TComponent;
  dm: TDataModule;
  fm: TCustomForm;
begin
  Instance := TComponent(InstanceClass.NewInstance);
  TComponent(Reference) := Instance;
  try
    if Instance is TDataModule then
    begin
      dm := TDataModule(Instance);
      dm.CreateNew(AOwner);
      Stream.ReadComponentRes(dm);
    end
    else
    if Instance is TCustomForm then
    begin
      fm := TCustomForm(Instance);
      fm.CreateNew(AOwner);
      Stream.ReadComponentRes(fm);
    end;
  except
    Instance.Free;
    TComponent(Reference) := nil;
    raise;
  end;
end;

procedure TMain.acKKPrintToExcelExecute(Sender: TObject);

  //выкидываем в Excel
  procedure ExportMemKK(aSort: Integer; aShowSubtitles: Boolean; aCols: TList{of TColumnEh});
  var
    i, b, g, sg, iCol: Integer;
    sGroup, sSubGroup, sBrand: string;
    s: string;

    ExcelApp: Excel_TLB.TExcelApplication;
    wb: Excel_TLB.ExcelWorkbook;
    ir: Excel_TLB.ExcelRange;
    iRow: Integer;
    xxCat, aSourceCat: TDBISamTable;
    aStream: TMemoryStream;
    aField: TField;
    aColCount: Integer;
  begin
    b := 0;
    g := 0;
    sg := 0;

    aSourceCat := Data.CatalogDataSource.DataSet as TDBISamTable;
    xxCat := TDBISamTable.Create(nil);
    try
      aStream := TMemoryStream.Create;
      try
        RegisterClass(TDBISamTable);
        aStream.WriteComponent(aSourceCat);
        for i := 0 to aSourceCat.FieldCount - 1 do
        begin
          RegisterClass(TPersistentClass( aSourceCat.Fields[i].ClassType ));
          aStream.WriteComponent(aSourceCat.Fields[i]);
        end;

        aStream.Position := 0;
        xxCat := TDBISamTable(aStream.ReadComponent(nil));
        xxCat.Name := 'xxCat';
        xxCat.Close;
        while aStream.Position < aStream.Size do
        begin
          aField := aStream.ReadComponent(nil) as TField;
          aField.Name := 'xxCat' + aField.FieldName;
          aField.DataSet := xxCat;
        end;
      finally
        aStream.Free;
      end;
      xxCat.OnCalcFields := aSourceCat.OnCalcFields;
      xxCat.Open;


      ExcelApp := TExcelApplication.Create(nil);
      ExcelApp.Connect; // подключение
      try
        ExcelApp.AutoQuit := False; // по умолчанию это свойство True только в unit ExcelXP
        ExcelApp.EnableEvents := FALSE;
        ExcelApp.Visible[0]:= FALSE;
        wb := ExcelApp.Workbooks.Add(NULL, 0);

        ir := ExcelApp.Cells;
        ir.Font.Name := 'Arial';
        ir.Font.Size := 8;

        ir := ExcelApp.Range['A1', 'A1'];
        aColCount := 0;
        for iCol := 0 to aCols.Count - 1 do
        begin
          aField := TColumnEh(aCols[iCol]).Field;

          ir.Value2 := TColumnEh(aCols[iCol]).Title.Caption;
          ir.Borders.LineStyle := xlContinuous;
          ir.Font.Bold := 1;

          if TColumnEh(aCols[iCol]).Visible then
            ir.ColumnWidth := TColumnEh(aCols[iCol]).Width div 8;

          if SameText(aField.FieldName, 'USA') or
             SameText(aField.FieldName, 'New') or
             SameText(aField.FieldName, 'SaleQ') then
          begin
            ir.EntireColumn.HorizontalAlignment := xlCenter;
            ir.EntireColumn.AutoFit;
          end;
          ir.WrapText := True;

          ir := ir.Offset[0, 1];
          Inc(aColCount);
        end;


        if aShowSubtitles then
          iRow := 1
        else
          iRow := 2;


        ShowProgress('Экспорт в Excel...', Data.memKK.RecordCount);
        Data.KK.IndexName := 'LOOK';
        try

          if aSort = 1 then
            Data.memKK.IndexName := 'GroupBrand';
          if aSort = 2 then
            Data.memKK.IndexName := 'BrandGroup'
          else
             Data.memKK.IndexName :='';

          i := 0;
          Data.memKK.First;
          while not Data.memKK.Eof do
          begin
            if xxCat.Locate('Cat_Id', Data.memKK.FieldByName('Cat_Id').AsInteger, []) then
            begin
              Data.XGroupTable.Locate('Group_Id;SubGroup_Id', VarArrayOf([Data.memKK.FieldByName('Group_Id').AsInteger, Data.memKK.FieldByName('SubGroup_Id').AsInteger]), []);
              sGroup := Data.XGroupTable.FieldByName('Group_descr').AsString;
              sSubGroup := Data.XGroupTable.FieldByName('SubGroup_descr').AsString;
              sBrand := xxCat.FieldByname('BrandDescrView').AsString;

              if aShowSubtitles then
                if (b <> Data.memKK.FieldByName('Brand_Id').AsInteger) or
                   (g <> Data.memKK.FieldByName('Group_Id').AsInteger) or
                   (sg <> Data.memKK.FieldByName('SubGroup_Id').AsInteger) then
                begin
                  b  := Data.memKK.FieldByName('Brand_Id').AsInteger;
                  g  := Data.memKK.FieldByName('Group_Id').AsInteger;
                  sg := Data.memKK.FieldByName('SubGroup_Id').AsInteger;
                  if aSort = 1 then
                    s := sGroup + '\' + sSubGroup + '\' + sBrand
                  else
                    s := sBrand + '\' + sGroup + '\' + sSubGroup;

                  Inc(iRow);
                  ir := ExcelApp.Range['A'+IntToStr(iRow), 'A'+IntToStr(iRow)];
                  ir := ir.Resize[1, aColCount];
                  ir.Merge(1);
                  ir.Value2 := s;
                  ir.Borders.LineStyle := xlContinuous;
                  ir.Font.Bold := 1;

                  Inc(iRow);
                end;

              ir := ExcelApp.Range['A' + IntToStr(iRow), 'A' + IntToStr(iRow)];
              for iCol := 0 to aCols.Count - 1 do
              begin
                aField := xxCat.FieldByName(TColumnEh(aCols[iCol]).FieldName);
                if SameText(aField.FieldName, 'USA') or
                   SameText(aField.FieldName, 'New') or
                   SameText(aField.FieldName, 'SaleQ') then
                begin
                  if aField.AsString = '1' then
                    ir.Item[1, iCol + 1] := 'X';
                end
                else
                  ir.Item[1, iCol + 1] := aField.AsString;
              end;

              Inc(iRow);
            end;

            Data.memKK.Next;
            Inc(i);
            if i mod 10 = 0 then
              CurrProgress(i);
          end;
        finally
          Data.KK.IndexName := '';
          HideProgress;
        end;

      finally
        ExcelApp.Visible[0]:= True;
        ExcelApp.Disconnect;
        ExcelApp.Free;
      end;
    finally
      xxCat.Close;
      xxCat.Free;
    end;
  end;

  //закидываем в memory-таблицу с IDшками групп и брендов для сортировки по ним
  procedure PrintKKReport(aSort: Integer; aShowSubtitles, aSkipNullQuants: Boolean; aCols: TList{of TColumnEh});
  var
    i: Integer;
    aSkip: Boolean;
  begin
    if not Data.memKK.Exists then
      Data.memKK.CreateTable
    else
      Data.memKK.EmptyTable;

    Data.memKK.Open;
    Data.KK.DisableControls;
    try
      Data.KK.First;

      ShowProgress('Подготовка...', Data.KK.RecordCount);
      i := 0;
      while not Data.KK.EOF do
      begin
        if Data.KK.FieldByName('Cat_Id').AsInteger > 0 then
        begin
          aSkip := False;
          if aSkipNullQuants then
          begin
            if not Data.QuantTable.Locate('Cat_Id', Data.KK.FieldByName('Cat_Id').AsInteger, []) then
              aSkip := True
            else
              if (Data.QuantTable.FieldByName('Quantity').AsString = '') or (Data.QuantTable.FieldByName('Quantity').AsString = '0') then
                aSkip := True;
          end;

          if not aSkip then
          begin
            Data.memKK.Append;
            Data.memKK.FieldByName('Cat_Id').AsInteger := Data.KK.FieldByName('Cat_Id').AsInteger;
            Data.memKK.FieldByName('Brand_Id').AsInteger := Data.KK.FieldByName('Brand_Id').AsInteger;
            Data.memKK.FieldByName('Group_Id').AsInteger := Data.KK.FieldByName('Group_Id').AsInteger;
            Data.memKK.FieldByName('SubGroup_Id').AsInteger := Data.KK.FieldByName('SubGroup_Id').AsInteger;
            Data.memKK.Post;
          end;
        end;
        Data.KK.Next;

        Inc(i);
        if i mod 20 = 0 then
          CurrProgress(i);
      end;
      HideProgress;

      ExportMemKK(aSort, aShowSubtitles, aCols);

    finally
      Data.KK.EnableControls;
      Data.memKK.Close;
      Data.memKK.EmptyTable;
    end;

  end;

var
  i, j: Integer;
  aSort: Integer;
  aList: TList;
begin
  //печатать попорядку группа/бренд или бренд/группа
  aList := TList.Create;
  j := 0;
  with TPrintCOParamsForm.Create(Self) do
  try
    for i := 0 to MainGrid.Columns.Count - 1 do
    begin
      if (MainGrid.Columns[i].FieldName <> 'Price_koef_rub') and
       (MainGrid.Columns[i].FieldName <> 'Price_koef_usd') and
         (MainGrid.Columns[i].FieldName <> 'Price_koef_eur') then
      begin
        clbColumns.AddItem(MainGrid.Columns[i].Title.Caption, MainGrid.Columns[i]);
        clbColumns.Checked[j] := SameText(MainGrid.Columns[i].FieldName, 'Code') or
                                 SameText(MainGrid.Columns[i].FieldName, 'BrandDescrView') or
                                 SameText(MainGrid.Columns[i].FieldName, 'Name_Descr') or
                                 SameText(MainGrid.Columns[i].FieldName, 'Price_pro');
        inc(j);
      end;
    end;

    if ShowModal = mrOK then
    begin
      for i := 0 to clbColumns.Count - 1 do
        if clbColumns.Checked[i] then
          aList.Add(clbColumns.Items.Objects[i]{TColumnEh});

      //print
      if rbSortGroupBrand.Checked then
        aSort := 1
      else
        if rbSortBrandGroup.Checked then
         aSort := 2
      else
         aSort := 3;
      PrintKKReport(aSort, cbIncludeSubtitles.Checked, cbExcludeNullQuants.Checked, aList);
    end;
  finally
    Free;
    aList.Free;
  end;
end;

procedure TMain.acKKSaveExecute(Sender: TObject);
var
  aFileName: string;
begin
  //Сохранить коммерческое предложение
  SaveFilePriceDialog.InitialDir := Data.Export_Path;
  SaveFilePriceDialog.FileName := 'CommercialOffer.csv';
  if not SaveFilePriceDialog.Execute then
    Exit;

  aFileName := SaveFilePriceDialog.FileName;
  if FileExists(aFileName) then
    if MessageDlg('Файл уже существует. Переписать', mtInformation, [mbYes, MBNO],0) <> ID_YES  then
      Exit;
  Data.KK.ExportTable(aFileName, ';');
end;

procedure TMain.acLoadRetdocTicketExecute(Sender: TObject);
var
  sResponse, sFileName, sLotusNumber: string;
  binFile: TMemoryStream;
  TCPClientTest: TIdTCPClient;
begin
  if Data.ReturnDocTable.FieldByName('RetDoc_id').AsString < '1' then
    Exit;

  if length(Data.ReturnDocTable.FieldByName('LotusNumber').AsString) < 1 then
    Exit;

  sLotusNumber := Data.ReturnDocTable.FieldByName('LotusNumber').AsString;
  sFileName := GetAppDir + 'Импорт\' + Data.ReturnDocTable.FieldByName('Data').AsString + '_' + Data.ReturnDocTable.FieldByName('Num').AsString + '_' + sLotusNumber + '.pdf';
  if not FileExists(sFileName) then
  begin
    TCPClientTest := TIdTCPClient.Create(nil);
    try
      if not DoTcpConnect(TCPClientTest, True, True) then
        Exit;

      with TCPClientTest do
      begin
        IOHandler.Writeln('RetDocTicket_ACK');
        IOHandler.Writeln(sLotusNumber);
        sResponse := IOHandler.ReadLnWait;
        if(sResponse = 'END') then
        begin
          MessageDlg('Талон на возврат ещё не распечатан. Повторите попытку позже!', mtInformation, [mbOK], 0);
          Disconnect;
          Exit;
        end;
        //???
        //sResponse := IOHandler.ReadLnWait;
        binFile := TMemoryStream.Create;
        try
          IOHandler.ReadStream(binFile, -1, False);
          if binFile.Size > 0 then
            binFile.SaveToFile(sFileName);
        finally
          binFile.Free;
        end;
      end;
    finally
      TCPClientTest.Disconnect;
      TCPClientTest.Free;
    end;

  end;

  if not FileExists(sFileName) then
    Exit;

  if FileExists(sFileName) then
    ShellExecute(Main.Handle, nil, PAnsiChar(sFileName), nil, nil, SW_SHOW)
end;


procedure TMain.acLoadRetdocTicketUpdate(Sender: TObject);
begin
 acLoadRetdocTicket.Enabled :=
    (Data.ReturnDocTable.Active) and (length(Data.ReturnDocTable.FieldByName('LotusNumber').AsString) > 1)
end;

procedure TMain.acMovieShate1Execute(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://www.youtube.com/watch?v=TGmuzAagFxw'), nil, nil, SW_SHOW);
end;

procedure TMain.acMovieShate2Execute(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://www.youtube.com/watch?v=eKDciomxIdk'), nil, nil, SW_SHOW);
end;

procedure TMain.acNearestRestockingExecute(Sender: TObject);
begin
  StartF7Task(False);
end;

procedure TMain.acNearestRestockingUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (not Data.WaitListTable.Eof) or (WaitListGrid.RowCount > 1 {шапка} );
end;

procedure TMain.acNotesExecute(Sender: TObject);
begin
  ToolPanelTabRight.RollOut(ToolPanelNotepad);
  fNotePadForm.NoteToday;
end;

procedure TMain.acReturnDocTCPExecute(Sender: TObject);
begin
  if LoadRetdocTCP1 then
    ApplyRetdocAnswer;
end;

procedure TMain.acReturnDocTCPUpdate(Sender: TObject);
begin
  acReturnDocTCP.Enabled :=
    (Data.ReturnDocTable.Active) and
    (Data.ReturnDocTable.FieldByName('RetDoc_ID').AsInteger > 0) and
    (Data.ReturnDocTable.FieldByName('Post').AsString <> '') and
    (Data.ReturnDocTable.FieldByName('Post').AsString <> '0') and
    (Data.ReturnDocTable.FieldByName('Post').AsString <> '4');
end;

procedure TMain.acRunBorbetExecute(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://konfigurator.borbet.de/default.aspx'), nil, nil, SW_SHOW);
end;

procedure TMain.acRunOilCatalogExecute(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://eni-ita.lubricantadvisor.com/default.aspx?Lang=rus'), nil, nil, SW_SHOW);
end;

procedure TMain.acRunOilShellExecute(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://lubematch.shell.com.ru/ru/ru/browse'), nil, nil, SW_SHOW);
end;

procedure TMain.acRunPatronCatalogsExecute(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://shate-m.by/ru/encyclopedia/articles/76.html'), nil, nil, SW_SHOW);
end;

procedure TMain.acRunSilencerFerrozExecute(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://ferrozkatalog.pl'), nil, nil, SW_SHOW);
end;

procedure TMain.acRunSilencerPolmostrowExecute(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://polmostrow.pl/katalog.php'), nil, nil, SW_SHOW);
end;

procedure TMain.acRunTeamViewerExecute(Sender: TObject);
begin
  RunTVSupport;
end;

procedure TMain.acRunTireCalculatorExecute(Sender: TObject);
begin
  if not Assigned(TireCalcForm) then
    TireCalcForm := TTireCalcForm.Create(Self);

  if TireCalcForm.ShowModal = mrRetry then
  begin
    ResetFilter;
  //  IgnoreSpecialSymbolsCheckBox.Checked := False;
    FiltModeComboBox.ItemIndex := 1;
    FiltEd.Text := TireCalcForm.FindInCatalogString;
    Update;
    Application.ProcessMessages;
    FindFilter.Execute;
  end;
end;

procedure TMain.acApplyRetdocAnswerUpdate(Sender: TObject);
begin
  acApplyRetdocAnswer.Enabled :=
    (Data.ReturnDocTable.Active) and
    (Data.ReturnDocTable.FieldByName('RetDoc_ID').AsInteger > 0) and
    (Data.ReturnDocTable.FieldByName('Post').AsString = '4');
end;

procedure TMain.acBrandRepl4ImportExecute(Sender: TObject);
begin
  with TBrandMap.Create(Application) do
  begin
   ShowModal;  
   Free;
  end;
end;

procedure TMain.AddAnToOrder(aRequestQuants: Boolean = False); //NewAnalog
var
  bNew: boolean;
  UserData, UserDataOrder: TUserIDRecord;
  aSavedOrderID: Integer;
  aCode, aBrand: string;
  ZakTabRect: TRect;
begin
  if Data.memAnalog.FieldByName('OrderOnly').AsBoolean then
  begin
    TOrderOnlyInfoForm.Execute(
      Data.memAnalog.FieldByName('An_Code').Asstring,
      Data.memAnalog.FieldByName('An_Brand').Asstring,
      Data.memAnalog.FieldByName('Name_Descr').Asstring
    );
    Exit;
  end;

  if not CheckClientId then
    Exit;
  UserData := GetCurrentUser;

  if (Data.memAnalog.FieldByName('An_id').AsInteger = 0) or
     (Data.memAnalog.FieldByName('PriceItog').AsCurrency = 0) then
    exit;

  bNew := False;
  if (Data.OrderTable.FieldByName('Sent').AsString <> '')and(Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
  begin
     if MessageDlg('Добавление в выбранный заказ невозможно !!! Заказ уже был отправлен в офис компании и вероятно уже обработан. Для проверки зарезервированного товара нажмите кнопку "TCP ответ". Создать новую корзину ?',mtInformation ,[mbYes,mbNo], 0) = mrNo  then
       Exit;
     bNew := TRUE;
  end;

  if (Data.OrderTable.FieldByName('Order_id').AsInteger = 0) or bNew then
    if not NewOrder then
      Exit;

  if Data.OrderTable.FieldByName('cli_id').AsString <> UserData.sID then
  begin
    if Data.ParamTable.FieldByName('AutoSwitchCurClient').AsBoolean or
       (Application.MessageBox('Идентификатор клиента в заказе отличается от текущего.'#13#10 +
                              'Установить текущим идентификатор из заказа?', 'Предупреждение', MB_YESNO or MB_ICONWARNING) = IDYES) then
    begin
      UserDataOrder := GetUserDataByID(Data.OrderTable.FieldByName('cli_id').AsString);
      if not Assigned(UserDataOrder) then
      begin
        Application.MessageBox('Идентификатор клиента указанный в заказе не найден!', 'Ошибка', MB_OK or MB_ICONERROR);
        Exit;
      end;
      aSavedOrderID := Data.OrderTable.FieldByName('Order_id').AsInteger;
      try
        Data.SetDefaultClient(UserDataOrder.sID);
        CliComboBox.KeyValue := UserDataOrder.sID;
        SetActiveCli(UserDataOrder);
        Application.ProcessMessages;
      finally
        Data.OrderTable.Locate('Order_id', aSavedOrderID, []);
      end;
    end
    else
      Exit;
  end;

  aCode := '';
  aBrand := '';
  if Data.XCatTable.Locate('CAT_ID', Data.memAnalog.FieldByName('An_id').AsInteger, []) then
    if Data.BrandTable.Locate('BRAND_ID', Data.XCatTable.FieldByName('BRAND_ID').AsInteger, []) then
    begin
      aCode := Data.XCatTable.FieldByName('CODE').AsString;
      aBrand := Data.BrandTable.FieldByName('Description').AsString;
    end;

  with TQuantityEdit.Create(Application) do
  begin
    Init(
      Data.OrderTable.FieldByName('Order_id').AsInteger,
      Data.OrderTable.FieldByName('Cli_id').AsString,
      True,
      aCode,
      aBrand,
      aRequestQuants
    );

    Caption := 'Количество товара в заказе';
    ArtInfo.Text := Data.memAnalog.FieldByName('An_Code').Asstring + '  ' + Data.memAnalog.FieldByName('An_Brand').Asstring + #13#10 +
                    Data.memAnalog.FieldByName('Name_Descr').Asstring;
    MultInfo.Value := Data.memAnalog.FieldByName('Mult').AsInteger;
    if MultInfo.Value <> 0 then
      QuantityEd.Value := MultInfo.Value
    else
      QuantityEd.Value := 1;
    if ShowModal = mrOk then
    begin
      if ResOrderId > 0 then
      begin
        if not Data.OrderTable.Locate('Order_ID', ResOrderId , []) then
        begin
          if OrderDateEd1.Date > ResOrderDate then
            OrderDateEd1.Date := ResOrderDate;
          if OrderDateEd2.Date < ResOrderDate then
            OrderDateEd2.Date := ResOrderDate;
          UpdateOrdersFilter(UserData);
          Data.OrderTable.Locate('Order_ID', ResOrderId , []);
        end;
      end;

      with Data.OrderDetTable do
      begin
        if not Locate('Order_id;Code2;Brand',
          VarArrayOf([Data.OrderTable.FieldByName('Order_id').AsInteger,
                      Data.MakeSearchCode(Data.memAnalog.FieldByName('An_code').AsString),
                      Data.memAnalog.FieldByName('An_brand').AsString]), [loCaseInsensitive]) then
        begin
          Append;
          FieldByName('Order_id').Value :=
               Data.OrderTable.FieldByName('Order_id').AsInteger;
          FieldByName('Code2').Value :=
               Data.MakeSearchCode(Data.memAnalog.FieldByName('An_code').AsString);
          FieldByName('Brand').Value :=
               AnsiUpperCase( Data.memAnalog.FieldByName('An_brand').AsString );
          FieldByName('Price').Value :=
            Data.memAnalog.FieldByName('Price_koef_eur').AsCurrency;
          //price_pro???
          CalcProfitPriceForOrdetDetCurrent;
        end
        else
        if MessageDlg('Внимание, такая позиция уже добавлена. Продолжить?',mtInformation, [MBYES, MBNO],0) = mrNo then
          exit
        else
          Edit;
        FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat +
                                         QuantityEd.Value;
        FieldByName('Info').Value := InfoEd.Text;
        Post;
      end;
      with Data.OrderTable do
      begin
        Edit;
        FieldByName('Dirty').Value := True;
        Post;
        Refresh;
      end;
      Data.OrderTableAfterScroll(Data.OrderTable);
      Data.memAnalog.Refresh;
    end;
    Free;
  end;

  {$IFNDEF LOCAL}
  if Data.ParamTable.FieldByName('bWarnOrderLimits').AsBoolean then
  begin
    if Data.OrderDetTable.RecordCount > cMaxOrderDetCount then
    begin
      Pager.ActivePage := CatZakPage;
      ZakTabRect := Pager.GetTabRect(CatZakPage);
      ShowBallonWarn(Pager, lbOrderFlame.Caption, 'Предупреждение', ZakTabRect.Left + 9, (ZakTabRect.Top + ZakTabRect.Bottom) div 2);
    end;
  end;
  {$ENDIF}
end;


procedure TMain.AddAnToWaitList;         //NewAnalog
var
  UserData: TUserIDRecord;
begin
  UserData := GetCurrentUser;
  if (Data.memAnalog.FieldByName('An_id').AsInteger = 0) or
     (Data.memAnalog.FieldByName('PriceItog').AsCurrency = 0) then
    exit;
  with TQuantityEdit.Create(Application) do
  begin
    Init(-1, '', False, '', '');

    Caption := 'Количество товара в листе ожидания';
    ArtInfo.Text := Data.memAnalog.FieldByName('An_Code').Asstring + '  ' + Data.memAnalog.FieldByName('An_brand').AsString + #13#10 +
                    Data.memAnalog.FieldByName('Name_Descr').Asstring;
    MultInfo.Value := Data.memAnalog.FieldByName('Mult').AsInteger;
    if MultInfo.Value <> 0 then
      QuantityEd.Value := MultInfo.Value
    else
      QuantityEd.Value := 1;
    if ShowModal = mrOk then
    begin
      with Data.WaitListTable do
      begin
        if not Locate('Code2;Brand',
          VarArrayOf([Data.MakeSearchCode(Data.memAnalog.FieldByName('An_code').AsString),
                      Data.memAnalog.FieldByName('An_brand').AsString]), []) then
        begin
          Append;
          FieldByName('Code2').Value :=
               Data.MakeSearchCode(Data.memAnalog.FieldByName('An_code').AsString);
          FieldByName('Brand').Value :=
               Data.memAnalog.FieldByName('An_brand').AsString;
          FieldByName('Quantity').Value := QuantityEd.Value;
          if UserData <> nil then
            FieldByName('cli_id').Value := UserData.sId;
          Post;
        end;
      end;
    end;
    Free;
  end;
end;


procedure TMain.AddAssortmentExpansionExecute(Sender: TObject);
var sData:string;
    CurDate:TDate;
begin
   //Включить в ассортимент
    if Data.CatalogDataSource.DataSet.FieldByName('Quantity').AsString <> '' then
      begin
        MessageDlg('Позиция не добавлена! У позиции есть остаток, если недостаточное количество поместите в лист ожидания!',mtInformation, [mbOK], 0);
        exit;
      end;
   
  if Data.CatalogDataSource.DataSet.FieldByName('Title').AsBoolean or
     (Data.CatalogDataSource.DataSet.FieldByName('Cat_id').AsInteger = 0) or
     (Data.CatalogDataSource.DataSet.FieldByName('PriceItog').AsCurrency = 0)
     or (Data.CatalogDataSource.DataSet.FieldByName('Quantity').AsString <> '')then
    Exit;
    CurDate := Now;
    sData := '.'+inttostr(YearOf(CurDate));
    if MonthOfTheYear(CurDate) < 10 then
      sData := '.0'+ inttostr(MonthOfTheYear(CurDate))+sData
    else
      sData := '.'+inttostr(MonthOfTheYear(CurDate))+sData;

    if DayOfTheMonth(CurDate) < 10 then
      sData := '0'+ inttostr(DayOfTheMonth(CurDate))+sData
    else
      sData := inttostr(DayOfTheMonth(CurDate))+sData;

    with Data.AssortmentExpansion do
      begin
        if not Locate('Code2;Brand',
          VarArrayOf([Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString,
                      Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString]), []) then
        begin
          Append;
          FieldByName('Code').Value :=
             Data.CatalogDataSource.DataSet.FieldByName('Code').AsString;
          FieldByName('Code2').Value :=
             Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString;
          FieldByName('Brand').Value :=
             Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString;
          FieldByName('Date').Value := sData;
        //end
        //else
        //  Edit;
        FieldByName('Amount').Value := Data.CatalogDataSource.DataSet.FieldByName('Mult').AsInteger;
        Post;
        end;
      end;
      Data.CalcWaitList;
      
  {with TQuantityEdit.Create(Application) do
  begin
    Caption := 'Расширение ассортимента';
    ArtInfo.Text := Data.CatalogDataSource.DataSet.FieldByName('Code').Asstring + '  ' +
                    Data.CatalogDataSource.DataSet.FieldByName('Name').Asstring + '  ' +
                    Data.CatalogDataSource.DataSet.FieldByName('Description').Asstring;
    MultInfo.Value := Data.CatalogDataSource.DataSet.FieldByName('Mult').AsInteger;
    if MultInfo.Value <> 0 then
      QuantityEd.Value := MultInfo.Value
    else
      QuantityEd.Value := 1;
    if ShowModal = mrOk then
    begin
      with Data.WaitListTable do
      begin
        if not Locate('Code2;Brand',
          VarArrayOf([Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString,
                      Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString]), []) then
        begin
          Append;
          FieldByName('Code2').Value :=
             Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString;
          FieldByName('Brand').Value :=
             Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString;
        end
        else
          Edit;
        FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat +
                                         QuantityEd.Value;
        FieldByName('Info').Value := InfoEd.Text;
        Post;
      end;
      Data.CalcWaitList;
    end;
    Free;
  end;    }
end;

function TMain.AddGoodsToKK(const aCode2, aBrand: string): Boolean;
begin
  Result := False;
  Data.KK.DisableControls;
  try
    Data.KK.IndexName := 'LOOK';
    if not Data.KK.FindKey([aCode2, aBrand]) then
    begin
      Data.KK.Append;
      Data.KK.FieldByName('Code2').AsString := aCode2;
      Data.KK.FieldByName('Brand').AsString := aBrand;
      Data.KK.Post;

      Result := True;
    end;
    Data.KK.IndexName := '';
  finally
    Data.KK.EnableControls;
  end;
end;

procedure TMain.OrderQuantityEdit;
var iPos:integer;
begin
  if Data.OrderDetTable.FieldByName('Id').AsInteger = 0 then
    Exit;
  iPos := Data.OrderDetTable.RecNo;
  with TQuantityEdit.Create(Application) do
  try
    Init(-1, '', False, '', '');

    ArtInfo.Text := Data.OrderDetTable.FieldByName('ArtCode').Asstring + '  ' + Data.OrderDetTable.FieldByName('Brand').Asstring + #13#10 +
                    Data.OrderDetTable.FieldByName('ArtNameDescr').Asstring;
    QuantityEd.Value := Data.OrderDetTable.FieldByName('Quantity').AsFloat;
    InfoEd.Text :=  Data.OrderDetTable.FieldByName('Info').AsString;
//---
    if Data.OrderDetTable.FieldByName('Mult').AsInteger = 0 then
      MultInfo.Value := 1
    else
      MultInfo.Value := Data.OrderDetTable.FieldByName('Mult').AsInteger;
//---
    if (ShowModal = mrOk) and
       (Data.OrderTable.FieldByName('Order_id').AsInteger <> 0) then
    begin
      if QuantityEd.Value = 0 then
      begin
        if MessageDlg('Нулевое количество! Удалить позицию из заказа?',
                     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          Data.OrderDetTable.Delete
      end
      else
      with Data.OrderDetTable do
      begin
        Edit;
        FieldByName('Quantity').Value := QuantityEd.Value;
        FieldByName('Info').Value := InfoEd.Text;
        Post;
      end;
    end;
    finally
      Free;
    end;

    with Data.OrderTable do
    begin
      Edit;
      FieldByName('Dirty').Value := True;
      Post;
      Refresh;
    end;

    Main.ZakTabInfo;
    Main.ClearTestQuants;
    Data.CatalogDataSource.Dataset.Refresh;
    Data.OrderDetTable.RecNo := iPos;
end;


procedure TMain.OrderWarnTimerTimer(Sender: TObject);
begin
  if OrderWarnTimer.Tag = 0 then
  begin
    OrderWarnTimer.Tag := 1;
    OrderFlame(True);
  end
  else
  begin
    OrderWarnTimer.Tag := 0;
    OrderFlame(False);
  end;
end;

procedure TMain.WaitListQuantityEdit;
var iPos:integer;
begin
  if Data.WaitListTable.FieldByName('Id').AsInteger = 0 then
    Exit;
  iPos :=  Data.WaitListTable.RecNo;
  with TQuantityEdit.Create(Application) do
  begin
    Init(-1, '', False, '', '');
    ArtInfo.Text := Data.WaitListTable.FieldByName('ArtCode').Asstring + '  ' + Data.WaitListTable.FieldByName('Brand').Asstring + #13#10 +
                    Data.WaitListTable.FieldByName('ArtNameDescr').Asstring;
    QuantityEd.Value := Data.WaitListTable.FieldByName('Quantity').AsFloat;
    InfoEd.Text := Data.WaitListTable.FieldByName('Info').AsString;
    if ShowModal = mrOk then
    begin
      with Data.WaitListTable do
      begin
        Edit;
        FieldByName('Quantity').Value := QuantityEd.Value;
        FieldByName('Info').Value := InfoEd.Text;
        Post;
      end;
    end;
    Free;
  end;
  Data.WaitListTable.RecNo := iPos;
end;


procedure TMain.PagerChange(Sender: TObject);
begin
  if Pager.ActivePage = WaitListPage then
  begin
    Wait_Flash_flag := True;
    WaitListFlashTimer.Enabled := False;
    if Data.WaitListCnt > 0 then
      WaitListPage.ImageIndex := 45
    else
      WaitListPage.ImageIndex := 35;
    Data.WaitListTable.Refresh;
  end
  else
  if Pager.ActivePage = AssortmentExpansionPage then
  begin
    AssortmentExpansionTimer.Enabled := False;
    if Data.AssortmentExpansionCnt > 0 then
      AssortmentExpansionPage.ImageIndex := 45
    else
      AssortmentExpansionPage.ImageIndex := 47;
    Data.AssortmentExpansion.Refresh;
  end
  else if Pager.ActivePage = DetailsPage then
  begin
    LoadTDInfo;
    if Data.ParamTable.FieldByName('bUnionDetailAnalog').AsBoolean then
      RefreshMemAnalogs;
  end
  else if Pager.ActivePage = AnalogPage then
    RefreshMemAnalogs;
end;

procedure TMain.Panel1Resize(Sender: TObject);
begin
   if ParamTypGrid.Height > Panel1.Height then
   begin
      if Panel1.Height > 5 then
          ParamTypGrid.Height := Panel1.Height - 5
      else
          ParamTypGrid.Height := 0;
   end;

end;

procedure TMain.ParamGridColWidthsChanged(Sender: TObject);
begin
  SyncParGrid(Sender);
end;

procedure TMain.pmTreePopup(Sender: TObject);
begin
//  tbTree.Down := True;
end;

procedure TMain.SyncParGrid(Sender: TObject);
begin
  if Sender = ParamGrid then
  begin
    ParamTypGrid.Columns[0].Width := ParamGrid.Columns[0].Width;
    ParamTypGrid.Columns[1].Width := ParamGrid.Columns[1].Width;
  end
  else
  begin
    ParamGrid.Columns[0].Width := ParamTypGrid.Columns[0].Width;
    ParamGrid.Columns[1].Width := ParamTypGrid.Columns[1].Width;
  end
end;

procedure TMain.PrimGridDblClick(Sender: TObject);
begin
  if Data.PrimenTable.FieldByName('Typ_id').AsInteger <> 0 then
    with TAutoInfo.Create(Application) do
    begin
      Auto_type := Data.PrimenTable.FieldByName('Typ_id').AsInteger;
      ShowModal;
      Free;
    end;
end;

procedure TMain.PrimGridEnter(Sender: TObject);
begin
  //if Data.Auto_type = 0 then
    //ParamTypGrid.Datasource := Data.CatTypDetDataSource;
end;

procedure TMain.PrimGridExit(Sender: TObject);
begin
  if Data.Auto_type = 0 then
    ParamTypGrid.Datasource := nil;
end;

procedure TMain.PrimGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ClearSearchMode;
end;

procedure TMain.PrintOrder;
begin
  if Data.OrderTable.FieldByName('Order_id').AsInteger = 0 then
    Exit;
  if Data.OrderTable.FieldByName('Cli_Id').AsString = '' then
  begin
    MessageDlg('Не указан идентификатор клиента в заказе!', mtError, [mbOK], 0);
    Exit;
  end;
  with TOrderReport.Create(Application) do
  begin
    if Data.ParamTable.FieldByName('bCalcOrderWithMargin').AsBoolean then
    begin
      TextPrice.DataField := 'Price_pro_koef';
      TextSum.DataField := 'sum_pro';
      SumExpr.Expression := 'SUM(OrderDetTable.Sum_pro)'
    end;
    Report.PreviewModal;
    Free;
  end;
end;

procedure TMain.QuestionToShateExecute(Sender: TObject);
begin
  //Вопрос(пожелание) к ШатеМ+
  with TQuestionToShate.Create(nil) do
  begin
    ShowModal;
  end;

end;

{* для сотрировки заказов *****************************************************}
type
  TOrderSumRecord = record
    Ind: Integer;
    Sum: Currency;
  end;
  POrderSumRecord = ^TOrderSumRecord;

  function SortCompareDesc(Item1, Item2: Pointer): Integer;
  begin
    if POrderSumRecord(Item1).Sum > POrderSumRecord(Item2).Sum then
      Result := -1
    else
      if POrderSumRecord(Item1).Sum < POrderSumRecord(Item2).Sum then
        Result := 1
      else
        Result := 0;
  end;
{******************************************************************************}

procedure TMain.EmailOrder;
  //сортируем
  procedure ReSortOrders(aListIDs: TStrings);
  var
    i: Integer;
    aSum: Currency;
    aSavedOrderID: Integer;
    aList: TList;
    pRec: POrderSumRecord;
    slTmp: TStrings;
  begin
    aSavedOrderID := Data.OrderTable.FieldByName('ORDER_ID').AsInteger;
    aList := TList.Create;
    try
      //считаем сумму по каждому заказу и закидываем в TList для сортировки
      for i := 0 to aListIDs.Count - 1 do
      begin
        Data.OrderTable.Locate('ORDER_ID', aListIDs.Names[i], []);
        aSum := Data.OrderTable.FieldByName('sum').AsCurrency;

        New(pRec);
        pRec^.Ind := i;
        pRec^.Sum := aSum;
        aList.Add(pRec);
      end;

      //сортируем по убыванию цены
      aList.Sort(SortCompareDesc);

      //перекидываем в исходный список в нужном порядке сортировки
      slTmp := TStringList.Create;
      try
        slTmp.Assign(aListIDs);
        aListIDs.Clear;
        for i := 0 to aList.Count - 1 do
        begin
          pRec := POrderSumRecord(aList[i]);
          aListIDs.Add(slTmp[pRec^.Ind]);
          Dispose(pRec);
        end;
      finally
        slTmp.Free;
      end;
    finally
      aList.Free;
      Data.OrderTable.Locate('ORDER_ID', aSavedOrderID, []);
    end;
  end;

  procedure MarkSending;
  begin
    with Data.OrderTable do
    begin
      Edit;
      FieldByName('Sent').Value := '1';
      FieldByName('Sent_time').AsDateTime := Now;
      Post;
    end;
  end;

  function SendOrderMailer(aFileName, aInf: string; aCustomOrder: Integer = 0): Boolean;
  var
    aSubj: string;
  begin
    Result := False;
    if aCustomOrder > 0 then
      if not Data.OrderTable.Locate('ORDER_ID', aCustomOrder, []) then
        Exit;

    aSubj := 'ClientID: ' + Data.OrderTable.FieldByName('Cli_id').AsString +
             ' OredrID: ' +  Data.OrderTable.FieldByName('Order_id').AsString +
             ' Date/Num: ' + Data.OrderTable.FieldByName('Date').AsString + '/'+
             Data.OrderTable.FieldByName('Num').AsString + Data.OrderTable.FieldByName('Type').AsString + aInf;

    with Mailer do
    begin
      Clear;
      Recipient.AddRecipient(Data.SysParamTable.FieldByName('Shate_email').AsString);
      Subject := aInf;
      Body.Clear;
      Body.Add(aSubj);
      Attachment.Add(aFileName);
      try
        SendMail;
        MarkSending;
      except
      end;
    end;
    Result := True;
  end;

var
  email, inf: string;
  UserData, UserDataOrder: TUserIDRecord;
  i: Integer;
  aSavedOrderID: Integer;
  aSplittedOrderIDs: TStrings;
  aSendByTCP: Boolean;
begin

  if not CheckClientId then
    Exit;

  UserData := GetCurrentUser;

  if Data.OrderTable.FieldByName('Order_id').AsInteger = 0 then
    Exit;

  if (Data.OrderTable.FieldByName('Delivery').AsString <> '1')and(Data.OrderTable.FieldByName('Delivery').AsString <> '2') then
  begin
    //MessageDlg('Необходимо выбрать вариант доставки товара!', mtError, [mbOK], 0);
    with TSelectDelivery.Create(nil) do
    begin
      iRut := 0;
      ShowModal;
      if  iRut = 0 then
        Exit;

      Data.OrderTable.Edit;
      Data.OrderTable.FieldByName('Delivery').Value := iRut;
      Data.OrderTable.Post;
    end;
  end;

  if (Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
  begin
    if MessageDlg('Заказ уже отправлялся ' +
                 Data.OrderTable.FieldByName('Sent_time').AsString +
                 ' Повторить?',
                 mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;
  end
  else if MessageDlg('Отправить заказ по электронной почте в офис Шате-М плюс?',
                 mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  if (Data.OrderTable.FieldByName('Agreement_No').AsString = '') or
         (Pos('"Контрагент" не найден', Data.OrderTable.FieldByName('AgrDescr').AsString) > 0) then
  begin
    MessageDlg('Не заполнен "Контрагент"!', mtError, [mbOK], 0);
    Exit;
  end
  else if not Data.ContractsCliTable.Locate('Contract_id;cli_id',
    VarArrayOf([Data.OrderTable.FieldByName('Agreement_No').AsString,
                Data.OrderTable.FieldByName('cli_id').AsString]),[]) then
  begin
    MessageDlg('Не найден "Контрагент"!', mtError, [mbOK], 0);
    Exit;
  end;


 if (Data.OrderTable.FieldByName('Addres_id').AsString = '') and
      (Data.OrderTable.FieldByName('Delivery').AsString = '1') then  
   if MessageDlg('Не указан адрес доставки! '+ #13#10 + 'Желаете продолжить?',
                 mtWarning, [mbYes, mbNo], 0) <> mrYes then
     Exit;


  with Data.OrderTable do
  begin
    if FieldByName('Description').AsString <> '' then
       if (Data.OrderTable.FieldByName('Delivery').AsInteger = 2) then
          inf := '[Самовывоз.' + FieldByName('Description').AsString + ']'
      else
        inf := '[Доставка. ' + FieldByName('Description').AsString + ']'
    else
      if (Data.OrderTable.FieldByName('Delivery').AsInteger = 2)then
          inf := '[Самовывоз]'
      else
          inf := '[Доставка]';
  end;

  aSendByTCP := Data.ParamTable.FieldByName('TCP_Direct').AsBoolean;

{$IFDEF NAVTEST}
  if not aSendByTCP then
  begin
    Application.MessageBox(
      'Запрещена отправка на E-Mail в тестовой версии!',
      'Ошибка',
      MB_OK or MB_ICONERROR
    );
    Exit;
  end;
{$ENDIF}
  
  if aSendByTCP then
  begin
    UserDataOrder := GetUserDataByID(Data.OrderTable.FieldByName('Cli_id').AsString);
    if not Assigned(UserDataOrder) then
    begin
      Application.MessageBox(
        PChar(
          'Идентификатор клиента [' + Data.OrderTable.FieldByName('Cli_id').AsString + '] указанный в заказе не найден в базе!'#13#10 +
          'Отредактируйте заказ или создайте клиента с нужным идентификатором'
        ),
        'Ошибка',
        MB_OK or MB_ICONERROR
      );
      Exit;
    end;

    email := Trim(UserDataOrder.sEMail); //мыло пользователя заказа
    if email = '' then
      if UserDataOrder.sID <> UserData.sID then
        if Application.MessageBox(
             PChar(
               'Для идентификатора клиента указанного в заказе не задан E-Mail!'#13#10 +
               'Отправить используя E-Mail текущего клиента "' + Trim(UserData.sEMail) + '"?'
             ),
             'Подтверждение',
             MB_YESNO or MB_ICONWARNING
           ) = IDYES then
           email := Trim(UserData.sEMail) //мыло текущего пользователя
        else
          Exit;


    if email = '' then
    begin
      MessageDlg('Настройте E-Mail текушего клиента в параметрах программы!', mtError, [mbOK], 0);
      Exit;
    end;
  end;

   //если заказ был отправлен и при этом не вносились изменения 
  if (Data.OrderTable.FieldByName('Sent').AsString <> '') and
        (Data.OrderTable.FieldByName('Sent').AsString <> '0') and
          (Data.OrderTable.FieldByName('Sent').AsString <> '3') and
             (not Data.OrderTable.FieldByName('Dirty').AsBoolean) then
  begin
    Data.OrderTable.Edit;
    Data.OrderTable.FieldByName('Dirty').AsBoolean := True;
    Data.OrderTable.Post;
  end;

  aSplittedOrderIDs := TStringList.Create;
  try
    if IsOrderMixGroups then
    begin
      if Application.MessageBox(
           PChar(
           'Внимание! Товары из нижеперечисленных групп должны быть отправлены отдельным заказом:'#13#10 +
           GetNewCartGroups + #13#10 +
           'Сейчас будет создана новая корзина, товары этих групп будут перенесены в нее и также отправлены.'#13#10 +
           'Продолжить?'),
           'Предупреждение', MB_YESNO or MB_ICONWARNING
         ) <> IDYES then
        Abort
      else
      begin
        aSavedOrderID := Data.OrderTable.FieldByName('ORDER_ID').AsInteger;
        try
          SplitMixOrder(aSplittedOrderIDs); //split current order to two or more orders
          //save splitted orders
          for i := 0 to aSplittedOrderIDs.Count - 1 do
            if Data.OrderTable.Locate('ORDER_ID', aSplittedOrderIDs[i], []) then
              aSplittedOrderIDs[i] := aSplittedOrderIDs[i] + '=' + SaveOrder(False);
        finally
          //restore order id
          Data.OrderTable.Locate('ORDER_ID', aSavedOrderID, []);
        end;
      end;
    end; // if IsOrderMixGroups

    aSplittedOrderIDs.Add(Data.OrderTable.FieldByName('ORDER_ID').AsString + '=' + SaveOrder(False));

    //сортируем по-убыванию суммы заказа (сначала должны отправляться самые дорогие)
    if aSplittedOrderIDs.Count > 1 then
      ResortOrders(aSplittedOrderIDs);

    //send splitted orders (aSplittedOrderIDs item: <ID_ORDER>=<FILE_NAME>)
    if aSplittedOrderIDs.Count > 0 then
    begin
      //отправляем
      for i := 0 to aSplittedOrderIDs.Count - 1 do
        if aSendByTCP then
          SendOrderTCP(email, aSplittedOrderIDs.ValueFromIndex[i], inf, StrToIntDef(aSplittedOrderIDs.Names[i], 0))
        else
          SendOrderMailer(aSplittedOrderIDs.ValueFromIndex[i], inf, StrToIntDef(aSplittedOrderIDs.Names[i], 0));
       // CreateXmlForWebService('E:\');
    end;
  finally
    aSplittedOrderIDs.Free;
  end;
end;

procedure TMain.ErrMenuClick(Sender: TObject);
begin
  if FileExists(GetAppDir + '!!!.err') then
  begin
    with TErrReportForm.Create(Application) do
    begin
      ShowModal;
      Free;
    end;
  end
  else
    MessageDlg('Файл с ошибками не найден.', mtInformation, [mbOK], 0);
end;

function TMain.ErrorMsgDir(CodeErr: Integer): string;
begin
  if CodeErr = -1 then
    Result := 'Внутренняя ошибка на сервере. Повторите попытку позже.' + #13#10;
  if CodeErr = -2 then
    Result :='Не распознан запрос'+ #13#10;
  if CodeErr = 1 then
    Result := 'Ошибка авторизации. Проверьте ключ.' + #13#10;
  if CodeErr = 2 then
    Result :='Проверьте идентификатор клиента.' + #13#10;
  if CodeErr = 11 then
    Result := '!Ошибка авторизации. Проверьте ключ.' + #13#10;
end;

procedure TMain.CountingOrderSum;
var
  anEvent: TDataSetNotifyEvent;
  Position: integer;
begin
  if Data.OrderTable.FieldByName('ORDER_ID').AsInteger = 0 then
    Exit;
  OrderSum:=0;
  anEvent := Data.OrderTable.AfterScroll;
  Data.OrderTable.AfterScroll := nil;
  Data.OrderTable.DisableControls;
  Position := Data.OrderTable.RecNo;
  try
    with Data.OrderTable do
    begin
      First;
      while not Eof do
      begin
        if Data.ParamTable.FieldByName('bCalcOrderWithMargin').AsBoolean then
          OrderSum := OrderSum + FieldByName('Sum_pro').AsCurrency
       else
          OrderSum := OrderSum + FieldByName('Sum').AsCurrency;
        Next;
      end;
    end;
  finally
    Data.OrderTable.RecNo:= Position;
    Data.OrderTable.EnableControls;
    Data.OrderTable.AfterScroll := anEvent;
  end;
  lbordersum.Caption:='Всего заказано: '+ FloatToStr(OrderSum);
end;

procedure TMain.ExportAutoDetailsExecute(Sender: TObject);
var fname:string;
    CsvFile:TextFile;
    sMan, sMosel:string;
    iMan, iModel:integer;
begin
    //adminmode
//   exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

   fname := 'Car';
   with SaveOrderDialog do
    begin
      FileName   := fname;
      if not Execute then
        exit;
      fname := FileName;
    end;

   AssignFile(CsvFile,fname);
   Rewrite(CsvFile);

   StartWait;
   Data.ModelsTable.IndexName        := 'MfaText';
   Data.TypesTable.IndexName         := 'Model';
   with Data.ManufacturersTable do
   begin
     IndexName := 'Brand';
      First;
      while not Eof do
      begin
        if not FieldByName('Hide').AsBoolean then
        begin
          sMan := FieldByName('Mfa_brand').AsString;
          iMan := FieldByName('Mfa_id').AsInteger;

          with Data.ModelsTable do
            begin

              SetRange([iMan], [iMan]);
                First;
                while not Eof do
                  begin
                    sMosel := FieldByName('Tex_text').AsString;
                    iModel := FieldByName('Mod_id').AsInteger;
                    with Data.TypesTable do
                      begin

                        SetRange([iModel],[iModel]);
                        First;
                        while not EOF do
                          begin
                            Writeln(CsvFile,FieldByName('Typ_id').AsString + ';'+
                            sMan+';'+
                            sMosel+';'+
                            FieldByName('CdsText').AsString + ';'+
                            FieldByName('PconText1').AsString + ' - ' + FieldByName('PconText2').AsString + ';'+
                            FieldByName('Kw_from').AsString + ';'+
                            FieldByName('Hp_from').AsString + ';'+
                            FieldByName('Ccm').AsString + ';'+
                            FloatToStr(XRound(FieldByName('Ccm').AsFloat / 1000, 1)) + ';'+
                            FieldByName('Cylinders').AsString + ';'+
                            FieldByName('BodyText').AsString + ';'+
                            FieldByName('Doors').AsString + ';'+
                            FieldByName('EngText').AsString + ';'+
                            FieldByName('FuelSupplText').AsString + ';'+
                            FieldByName('Valves').AsString + ';'+
                            FieldByName('CatText').AsString + ';'+
                            FieldByName('Eng_codes').AsString + ';'+
                            FieldByName('DriveText').AsString + ';'+
                            FieldByName('BrSysText').AsString + ';'+
                            FieldByName('BrTypeText').AsString + ';'+
                            FieldByName('AbsText').AsString + ';'+
                            FieldByName('AsrText').AsString + ';'
                            );
                            Next;
                          end;
                      end;
                    Next;
                end;
              CancelRange;
            end;
        end;
        Next;
    end;
    Data.ModelsTable.IndexName        := '';
    Data.TypesTable.IndexName         := '';
    IndexName := '';
  end;
  StopWait;

 {  with Data.TypesTable do
    begin
    First;
    while not EOF do
    begin
      Writeln(CsvFile,FieldByName('Typ_id').AsString + ';'+

                    FieldByName('CdsText').AsString + ';'+
                    FieldByName('PconText1').AsString + ' - ' + FieldByName('PconText2').AsString + ';'+
                    FieldByName('Kw_from').AsString + ';'+
                    FieldByName('Hp_from').AsString + ';'+
                    FieldByName('Ccm').AsString + ';'+
                    FloatToStr(XRound(FieldByName('Ccm').AsFloat / 1000, 1)) + ';'+
                    FieldByName('Cylinders').AsString + ';'+
                    FieldByName('BodyText').AsString + ';'+
                    FieldByName('Doors').AsString + ';'+
                    FieldByName('EngText').AsString + ';'+
                    FieldByName('FuelSupplText').AsString + ';'+
                    FieldByName('Valves').AsString + ';'+
                    FieldByName('CatText').AsString + ';'+
                    FieldByName('Eng_codes').AsString + ';'+
                    FieldByName('DriveText').AsString + ';'+
                    FieldByName('BrSysText').AsString + ';'+
                    FieldByName('BrTypeText').AsString + ';'+
                    FieldByName('AbsText').AsString + ';'+
                    FieldByName('AsrText').AsString + ';'
        );
      Next;
    end;
  end; }
  CloseFile(CsvFile);

end;

procedure TMain.ExportDetailFoManExecute(Sender: TObject);
var s,sValue:string;
    F:TextFile;
    i:integer;
begin
     //adminmode
// exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

    if SaveFilePriceDialog.Execute() = false then
    exit;

    SetCurrentDir(Data.Data_Path);
    s:= SaveFilePriceDialog.FileName;
    if (StrLeft(s,4)<>'.csv') then
      s:=s+'.csv';

    AssignFile(f,s);
    Rewrite(f);
    with (Data.CatalogDataSource.DataSet as TDBISAMTABLE) do
    begin
      DisableControls;
      CancelRange;
      First;

      while not EOF do
      begin
        if(FieldByName('Code').AsString <> '') then
        begin
           if Data.CatalogTable.IndexName <> '' then
              Data.CatalogTable.IndexName := '';

          sValue  := '';
          if FieldByName('Cat_id').AsInteger  <> Data.CatalogTable.FieldByName('Cat_id').AsInteger then
          begin
            if Data.CatalogTable.FindKey([FieldByName('Cat_id').AsInteger]) then
              begin
               sValue := Data.CatalogTable.FieldByName('Primen').Value;
              end;
          end
             else
               sValue := Data.CatalogTable.FieldByName('Primen').Value;

          if Main.StrLeft(sValue,1) <>',' then
            i := 1
          else
            i := 2;

          s := ExtractDelimited(i,  sValue, [',']);
          while length(s)>0 do
          begin
              Writeln(F,Data.CatalogDataSource.DataSet.FieldByName('Code').AsString+'_'+Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString+';'+s+';');
              i:=i+1;
              s := ExtractDelimited(i,  sValue, [',']);
          end;
        end;
        Next;
      end;
      EnableControls;
    end;
    CloseFile(f);

//
end;

procedure TMain.ExportDetailManParametrExecute(Sender: TObject);
var s,sValue:string;
    F:TextFile;
    i:integer;
begin
     //adminmode
// exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

    if SaveFilePriceDialog.Execute() = false then
    exit;

    SetCurrentDir(Data.Data_Path);
    s:= SaveFilePriceDialog.FileName;
    if (StrLeft(s,4)<>'.csv') then
      s:=s+'.csv';

    AssignFile(f,s);
    Rewrite(f);
    with (Data.CatalogDataSource.DataSet as TDBISAMTABLE) do
    begin
      DisableControls;
      CancelRange;
      First;

      while not EOF do
      begin
        if(FieldByName('Code').AsString <> '') then
        begin
           if Data.CatalogTable.IndexName <> '' then
              Data.CatalogTable.IndexName := '';

          sValue  := '';
          if FieldByName('Cat_id').AsInteger  <> Data.CatalogTable.FieldByName('Cat_id').AsInteger then
          begin
            if Data.CatalogTable.FindKey([FieldByName('Cat_id').AsInteger]) then
              begin
               sValue := Data.CatalogTable.FieldByName('Primen').Value;
              end;
          end
             else
               sValue := Data.CatalogTable.FieldByName('Primen').Value;

          if Main.StrLeft(sValue,1) <>',' then
            i := 1
          else
            i := 2;

          s := ExtractDelimited(i,  sValue, [',']);
          while length(s)>0 do
          begin
             with Data.CatTypDetTable do
             begin
                  SetRange([Data.CatalogDataSource.DataSet.FieldByName('param_tdid').AsInteger,
                           strtoint(s)],
                          [Data.CatalogDataSource.DataSet.FieldByName('param_tdid').AsInteger,
                            strtoint(s)]);

                First;
                while not EOF do
                begin
                   Writeln(F,s+';'+Data.CatalogDataSource.DataSet.FieldByName('Code').AsString+'_'+Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString+';'+FieldByName('ParamDescr').AsString+'='+FieldByName('Param_value').AsString+';');
                   Next;
                end;

             end;
             // Writeln(F,Data.CatalogDataSource.DataSet.FieldByName('Code').AsString+'_'+Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString+';'+s+';');
              i:=i+1;
              s := ExtractDelimited(i,  sValue, [',']);
          end;
        end;
        Next;
      end;
      EnableControls;
    end;
    CloseFile(f);
   //ParamTypGrid


end;

procedure TMain.ExportParametrExecute(Sender: TObject);
var s:string;
     F: TextFile;
begin
   //adminmode
// exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

  if SaveFilePriceDialog.Execute() = false then
    exit;

    SetCurrentDir(Data.Data_Path);
    s:= SaveFilePriceDialog.FileName;
    if (StrRight(s,4)<>'.csv') then
      s:=s+'.csv';

    AssignFile(f,s);
    Rewrite(f);
    with (Data.CatalogDataSource.DataSet as TDBISAMTABLE) do
    begin
      DisableControls;
      Data.CatDetTable.DisableControls;
      CancelRange;
      First;

      while not EOF do
      begin
        if(FieldByName('Code').AsString <> '') then
        begin
           with Data.CatDetTable do
           begin
           if Data.CatalogDataSource.DataSet.FieldByName('param_tdid').AsString <> '' then
           begin
             SetRange([Data.CatalogDataSource.DataSet.FieldByName('param_tdid').AsInteger], [Data.CatalogDataSource.DataSet.FieldByName('param_tdid').AsInteger]);
             First;
             while not EOF do
              begin
               Writeln(F,Data.CatalogDataSource.DataSet.FieldByName('Code').AsString+'_'+Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString+';'+FieldByName('ParamDescr').AsString+'='+FieldByName('Param_value').AsString);
               Next;
              end;
              CancelRange;
           end;
           end;
        end;
        Next;
      end;
      EnableControls;
      Data.CatDetTable.EnableControls;
    end;
    CloseFile(f);
end;

procedure TMain.ExportPictureExecute(Sender: TObject);
var s:string;
    F:textFile;
    bs: TDBISAMBlobStream;
    ext: string;
    si: TSingleImage;
    sPath, sBrand, sFileName:string;
    iFile:integer;
begin
  //Export
  if SaveFilePriceDialog.Execute() = false then
    Exit;

  SetCurrentDir(Data.Data_Path);
  s:= SaveFilePriceDialog.FileName;
  if (StrRight(s,4)<>'.csv') then
    s:=s+'.csv';
  sPath := ExtractFilePath(s);

//GetAppDir+'shatemplus.exe"'));
  AssignFile(f,s);
  Rewrite(f);
  with (Data.CatalogDataSource.DataSet as TDBISAMTABLE) do
  begin
    DisableControls;
    Data.CatDetTable.DisableControls;
    CancelRange;
    First;
    iFile := 0;

    while not EOF do
    begin
      if(FieldByName('Code').AsString <> '') then
      begin
        if (FieldByName('pict_id').AsInteger > 0) and
           Data.PictTable.Locate('Pict_id', FieldByName('Pict_id').AsInteger, []) then
        begin
          bs := TDBISAMBlobStream.Create(TBlobField(Data.PictTable.FieldByName('Pict_data')), bmRead);
          try
            ext := DetermineStreamFormat(bs);
            if iFile mod 1000 = 0 then
            begin
              sBrand :=  inttostr(iFile div 1000);
              if( not DirectoryExists(sPath+sBrand)) then
                CreateDir(sPath+sBrand);
            end;

            Inc(iFile);
            if ext <> '' then
            begin
              si := TSingleImage.CreateFromStream(bs);
              sFileName := inttostr(iFile)+'.jpg';

              writeln(f,Data.CatalogDataSource.DataSet.FieldByName('Code').AsString+'_'+Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString+';'+sPath+sBrand+'\'+sFileName);
              si.SaveToFile(sPath+sBrand+'\'+sFileName);
              si.Free;
            end;
          finally
            bs.Free;
          end;
        end;
      end;
      Next;
    end;
    EnableControls;
  end;

  CloseFile(f);
  Data.CatDetTable.EnableControls;
end;

procedure TMain.SaveOENumberExecute(Sender: TObject);
 var
  F: TextFile;
  s:string;
begin
  //adminmode
// exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

  if SaveFilePriceDialog.Execute() = false then
    exit;
  SetCurrentDir(Data.Data_Path);
  s:= SaveFilePriceDialog.FileName;
  if (StrLeft(s,4)<>'.csv') then
    s:=s+'.csv';

  AssignFile(f,s);
  Rewrite(f);
  with Data.TestQuery do
  begin
    SQL.Clear;
    SQL.Add('SELECT [002].Code, [003].Description, [016].Code as OE From [002] ');
    SQL.Add('join [003] ON [003].brand_id = [002].brand_id ');
    SQL.Add('join [016] ON [016].Cat_id = [002].Cat_id ');
    Open;
    while not Eof do
    begin
    if Length(FieldByName('Code').AsString)>0 then
    begin

      WriteLn(F, FieldByName('Code').AsString + '_' +
                 FieldByName('Description').AsString+';'+
                 FieldByName('OE').AsString+ ';');
    end;
      Next;
    end;
    Close;
  end;
  CloseFile(F);
  MessageDlg('OE: '+s+'!',mtInformation,[MBOK],0);
end;

function TMain.SaveReturnDoc_NAV(sFileName: string): boolean;
var
  fname: string;
  F: TextFile;
  rn: integer;
  s:string;
//  aCurrency: Integer;
  sRes, ReplNote: string;

begin
  Result := False;

  if not CheckClientId then
    Exit;

  if Data.ReturnDocDetTable.RecordCount = 0 then
  begin
    MessageDlg('Невозможно сохранить пустой возврат!', mtError, [mbOK], 0);
    Exit;
  end;

  if Data.ReturnDocTable.FieldByName('cli_id').AsString = '' then
  begin
    MessageDlg('Не указан идентификатор клиента в возврате!', mtError, [mbOK], 0);
    Exit;
  end;

 // aCurrency := -1;
  if Data.ReturnDocTable.FieldByName('Agreement_No').AsString <> '' then
  begin
    sRes := Data.ExecuteSimpleSelect(' select client_id from [011] where client_id = :id ', [Data.ReturnDocTable.FieldByName('Cli_id').AsString], TRUE);
    if sRes <> '' then
      sRes := Data.ExecuteSimpleSelect(' SELECT Currency from [048] where Cli_id = ''' + sRes + ''' and Contract_id = ''' + Data.ReturnDocTable.FieldByName('Agreement_No').AsString + '''', [], TRUE);
    
   { if sRes = 'EUR' then
      aCurrency := 1
    else if sRes = 'BYR' then
      aCurrency := 2
    else if sRes = 'USD' then
      aCurrency := 3
    else if sRes = 'RUB' then
      aCurrency := 4;  }
  end;
  
 // if aCurrency = -1 then //BYR - default
 //    aCurrency := 2;
  
  with Data.ReturnDocTable do
  begin
    if FieldByName('RetDoc_id').AsInteger < 1 then
      Exit;

    fname := 'RET_'+FieldByName('cli_id').AsString + '_' +
             FieldByName('RetDoc_id').AsString + '_' +
             FieldByName('Data').AsString + '_' +
             FieldByName('Num').AsString +
             FieldByName('Agreement_No').AsString + '.csv';
  end;
  
  if sFileName = '' then
  begin
    with SaveOrderDialog do
    begin
      InitialDir := Data.Export_path;
      FileName   := fname;
      if not Execute then
        Exit;

      fname := FileName;
    end
  end
  else
    fname := Data.Export_Path + sFileName;
  SetCurrentDir(Data.Data_Path);

  StartWait;
  AssignFile(F, fname);
  Rewrite(F);
  with Data.ReturnDocTable do
  begin
    if(FieldByName('Sign').AsString = '') then
    begin
      Edit;
      FieldByName('Sign').AsString := IntToStr(RandomRange(1111111, 9999999));
      FieldByName('TcpAnswer').AsVariant := NULL;
      Post;
    end;
    {}
     if (SameText(FieldByName('AgrGroup').AsString,'БН')) or (SameText(FieldByName('AgrGroup').AsString,'')) then
       ReplNote := FieldByName('Note').AsString +
                      'FIO:' +
                      'ADR:' + FieldByName('FakeAddresDescr').AsString +
                      'TEL:'

     else
        ReplNote := FieldByName('Note').AsString +
                      'FIO:' + FieldByName('Name').AsString +
                      'ADR:' + FieldByName('FakeAddresDescr').AsString +
                      'TEL:' + TrimAll(FieldByName('Phone').AsString);

      ReplNote := StringReplace(ReplNote, ';', ',', [rfReplaceAll]);
    {}

    //ReplNote := StringReplace(FieldByName('Note').AsString, ';', ',', [rfReplaceAll]);
    sRes := FieldByName('cli_id').AsString + ';' +
            FieldByName('Data').AsString + ';' +
            FieldByName('Sign').AsString + ';' +
            'RET;' +
            ReplNote + ';' +
            'NAV' + ';' +                                 //пометка нового формата заказа
            FieldByName('Agreement_No').AsString + ';' +  //номер договора
            FieldByName('Addres_Id').AsString + ';' +     //код адреса доставки
            FieldByName('Delivery').AsString + ';' +      //1 - доставка, 2 - самовывоз
            FieldByName('reason').AsString;               // причина: ret- возврат, exch - замена

    Writeln(F, sRes);
  end;

  with Data.ReturnDocDetTable do
  begin
    DisableControls;
    rn := RecNo;
    First;
    while not Eof do
    begin
           ReplNote := StringReplace(FieldByName('Note').AsString, ';', ',', [rfReplaceAll]);
           s := FieldByName('Code').AsString + '_' +
           FieldByName('Brand').AsString + ';' +
           FieldByName('Quantity').AsString + ';';
           s := s +  ReplNote + ';';
          WriteLn(F,s);
      Next;
    end;
    RecNo := rn;
    EnableControls;
  end;
  CloseFile(F);
  StopWait;

  Data.ReturnDocTable.Edit;
  Data.ReturnDocTable.FieldByName('Post').AsInteger := 1;
  Data.ReturnDocTable.Post;
  Result := True;
end;


function TMain.SaveReturnDoc(sFileName:string):boolean;
var
  fname: string;
  F: TextFile;
  rn: integer;
  s:string;
begin
  Result := SaveReturnDoc_NAV(sFileName);
  Exit;

  if not CheckClientId then
    Exit;

  Result := False;
  if Data.ReturnDocDetTable.RecordCount < 1 then
  begin
    MessageDlg('Невозможно сохранить пустой возврат!', mtError, [mbOK], 0);
    SaveReturnDoc:=FALSE;
    Exit;
  end;

  if Data.ReturnDocTable.FieldByName('cli_id').AsString = '' then
  begin
    MessageDlg('Не указан идентификатор клиента в возврате!', mtError, [mbOK], 0);
    SaveReturnDoc:=FALSE;
    Exit;
  end;

  if Length(Data.ReturnDocTable.FieldByName('Type').AsString) < 1 then
  begin
     MessageDlg('Не указан тип возврата!', mtError, [mbOK], 0);
     SaveReturnDoc:=FALSE;
     Exit;
  end;

  with Data.ReturnDocTable do
  begin
    if FieldByName('RetDoc_id').AsString < '1' then
      Exit;

    fname := 'RET_'+FieldByName('cli_id').AsString + '_' +
             FieldByName('RetDoc_id').AsString + '_' +
             FieldByName('Data').AsString + '_' +
             FieldByName('Num').AsString +
             FieldByName('Type').AsString + '.csv';
  end;
  if Length(sFileName) < 1 then
  begin
    with SaveOrderDialog do
    begin
      InitialDir := Data.Export_path;
      FileName   := fname;
      if not Execute then
      begin
        SaveReturnDoc:=FALSE;
        exit;
      end;
      fname := FileName;
    end
  end
  else
    fname := Data.Export_Path + sFileName;
  SetCurrentDir(Data.Data_Path);

  StartWait;
  AssignFile(F, fname);
  Rewrite(F);
  with Data.ReturnDocTable do
  begin
    if(FieldByName('Sign').AsString = '') then
    begin
      Edit;
      FieldByName('Sign').AsString := IntToStr(RandomRange(1111111, 9999999));
      FieldByName('TcpAnswer').AsVariant := NULL;
      Post;
    end;


    if FieldByName('Type').AsString = 'A' then
    begin
      WriteLn(F, FieldByName('cli_id').AsString+';'+FieldByName('Data').AsString+';' +FieldByName('Sign').AsString+';04A;'+FieldByName('Note').AsString+';');
    end
    else
    begin
      WriteLn(F, FieldByName('cli_id').AsString+';'+FieldByName('Data').AsString+';' +FieldByName('Sign').AsString+';04B;'+  FieldByName('Note').AsString+';');
    end;
  end;

  with Data.ReturnDocDetTable do
  begin
    DisableControls;
    rn := RecNo;
    First;
    while not Eof do
    begin
           s := FieldByName('Code').AsString + '_' +
           FieldByName('Brand').AsString + ';' +
           FieldByName('Quantity').AsString+ ';';
           s:=s+  FieldByName('Note').AsString+';';
          WriteLn(F,s);
      Next;
    end;
    RecNo := rn;
    EnableControls;
  end;
  CloseFile(F);
  StopWait;

  Data.ReturnDocTable.Edit;
  Data.ReturnDocTable.FieldByName('Post').AsInteger := 1;
  Data.ReturnDocTable.Post;
  SaveReturnDoc:=TRUE;
end;


function TMain.SaveOrder(FNameDialog: boolean = True): string;
var
  fname: string;
  F: TextFile;
  rn, sign: integer;
  s:string;
  sIndexName:string;
  fileDate:integer;
  str:string;
begin
  Result := SaveOrder_Nav(FNameDialog);
  Exit;
  
  Result := '';
  
  if not CheckClientID then
    Exit;

  if (Data.OrderTable.FieldByName('Delivery').AsString <> '1')and(Data.OrderTable.FieldByName('Delivery').AsString <> '2') then
  begin
    with TSelectDelivery.Create(nil) do
    begin
      iRut := 0;
      ShowModal;
      if  iRut = 0 then
        Exit;

      Data.OrderTable.Edit;
      Data.OrderTable.FieldByName('Delivery').Value := iRut;
      Data.OrderTable.Post;
    end;
  end;


  if (Data.OrderTable.FieldByName('Type').AsString='A') or
      ((Data.OrderTable.FieldByName('Delivery').AsString <> '2') and
       (Data.OrderTable.FieldByName('Delivery').AsString <> '1')) or
         (Data.OrderTable.FieldByName('Currency').AsString = '') or (Data.OrderTable.FieldByName('Currency').AsString = '0') then
  begin
    Data.OrderTable.Edit;
    Data.OrderTable.FieldByName('Currency').Value := 2;
    Data.OrderTable.Post;
  end;

  if Length(Data.OrderTable.FieldByName('Type').AsString) < 1 then
  begin
     MessageDlg('Не указан тип заказа!', mtError, [mbOK], 0);
     Exit;
  end;

  if Data.OrderTable.FieldByName('Cli_id').AsString = '' then
  begin
    MessageDlg('Не указан идентификатор клиента в заказе!', mtError, [mbOK], 0);
    Exit;
  end;

  Result := '';
  with Data.OrderTable do
  begin
    if FieldByName('Order_id').AsInteger = 0 then
      Exit;
    fname := FieldByName('Cli_id').AsString + '_' +
             FieldByName('Order_id').AsString + '_' +
             FieldByName('Date').AsString + '_'+ FieldByName('Num').AsString;

            if((Data.OrderTable.FieldByName('Delivery').AsInteger = 2)and(FieldByName('Type').AsString='B'))then
               fname := fname + 'E.csv'
            else
               fname := fname + FieldByName('Type').AsString + '.csv';


  end;
  
  if FNameDialog then
  begin
    with SaveOrderDialog do
    begin
      InitialDir := Data.Export_path;
      FileName   := fname;
      if not Execute then
        exit;
      fname := FileName;
    end
  end
  else
    fname := Data.Export_Path + fname;
  StartWait;
  AssignFile(F, fname);
  Rewrite(F);
  with Data.OrderTable do
  begin
    if (FieldByName('Sign').AsString = '') or
        FieldByName('Dirty').AsBoolean then
    begin
      Randomize;
      sign := RandomRange(1111111, 9999999);
      Edit;
      FieldByName('Sign').Value  := IntToStr(sign);
      FieldByName('Dirty').Value := False;
      FieldByName('IsDelivered').AsInteger := 0;

      FieldByName('Sent_Time').AsVariant := NULL;
      FieldByName('TcpAnswer').AsVariant := NULL;
      FieldByName('TcpAnswerZam').AsVariant := NULL;

      Post;
    end;

    fileDate := FileAge(Application.ExeName);

    str := FieldByName('Cli_id').AsString + ';' +
                 FieldByName('Date').AsString + ';' +
                 FieldByName('Sign').AsString + ';';

            if (Data.OrderTable.FieldByName('Delivery').AsInteger = 2)then
            begin
               if FieldByName('Type').AsString='B' then
                 str := str + 'E;'+Data.OrderTable.FieldByName('Currency').AsString+';Самовывоз - '+FieldByName('Description').AsString+';'+
                 DateTimeToStr(FileDateToDateTime(fileDate))
               else
                 str := str + 'A;'+Data.OrderTable.FieldByName('Currency').AsString+';Самовывоз -'+FieldByName('Description').AsString+';'+
                  DateTimeToStr(FileDateToDateTime(fileDate));
            end
            else
               str := str + FieldByName('Type').AsString+ ';'+Data.OrderTable.FieldByName('Currency').AsString+';Доставка - '+FieldByName('Description').AsString+';'+
                 DateTimeToStr(FileDateToDateTime(fileDate));

    WriteLn(F, str);
  end;
  with Data.OrderDetTable do
  begin
    DisableControls;
    rn := RecNo;
    if Data.ParamTable.FieldByName('bSortOrderDet').AsBoolean then
      begin
        sIndexName := IndexName;
        if sIndexName <> 'OrderArt'  then
          IndexName := 'OrderArt';
      end;
    First;
    //Позиции
    while not Eof do
    begin
           s := FieldByName('ArtCode').AsString + '_' +
           FieldByName('Brand').AsString + ';' +
           FieldByName('Quantity').AsString+ ';';
           if Data.ParamTable.FieldByName('bSaveWithPrice').AsBoolean then
              s:=s+  FieldByName('Price_koef').AsString+';';
           s:=s+  FieldByName('Info').AsString+';';
          WriteLn(F,s);
      Next;
    end;
    if Data.ParamTable.FieldByName('bSortOrderDet').AsBoolean then
      begin
        if sIndexName <> 'OrderArt'  then
          begin
            IndexName := sIndexName;
            First;
          end;
      end;
    RecNo := rn;
    EnableControls;
  end;
  CloseFile(F);
  StopWait;
  Result := fname;

  Data.OrderTable.Edit;
  Data.OrderTable.FieldByName('Sent').AsInteger := 3;
  Data.OrderTable.FieldByName('LotusNumber').AsString := '';
  Data.OrderTable.Post;
end;

function TMain.SaveOrder_NAV(FNameDialog: boolean = True): string;
var
  fname, sRes: string;
  F: TextFile;
  rn, sign: integer;
  s:string;
  sIndexName:string;
  fileDate:integer;
  str: string;
  aDeliveryComment, Note, NearestDelivery: string;

begin
  Result := '';
  
  if not CheckClientID then
    Exit;

  if Data.OrderTable.FieldByName('Cli_id').AsString = '' then
  begin
    MessageDlg('Не указан идентификатор клиента в заказе!', mtError, [mbOK], 0);
    Exit;
  end;

{  
  if Data.OrderTable.FieldByName('Agreement_No').AsString = '' then
  begin
     MessageDlg('Не указан договор в заказе!', mtError, [mbOK], 0);
     Exit;
  end;
}
  if (Data.OrderTable.FieldByName('Delivery').AsString <> '1') and
     (Data.OrderTable.FieldByName('Delivery').AsString <> '2') then
  begin
    with TSelectDelivery.Create(nil) do
    begin
      iRut := 0;
      ShowModal;
      if  iRut = 0 then
        Exit;

      Data.OrderTable.Edit;
      Data.OrderTable.FieldByName('Delivery').Value := iRut;
      Data.OrderTable.Post;
    end;
  end;
  

  if Data.OrderTable.FieldByName('Agreement_No').AsString <> '' then
  begin
    sRes := Data.ExecuteSimpleSelect(' select client_id from [011] where client_id = :id ', [Data.OrderTable.FieldByName('Cli_id').AsString], TRUE);
    if sRes <> '' then
    //!!! взять только если договор не мультивалютный, иначе - из заказа
      if not Data.IsMultiCurrAgr(sRes, Data.OrderTable.FieldByName('Agreement_No').AsString) then
      begin
        sRes := Data.ExecuteSimpleSelect(' SELECT Currency from [048] where Cli_id = ''' + sRes + ''' and Contract_id = ''' + Data.OrderTable.FieldByName('Agreement_No').AsString + '''', [], TRUE);
      
        Data.OrderTable.Edit;
        if sRes = 'EUR' then
          Data.OrderTable.FieldByName('Currency').AsString := '1'
        else if sRes = 'BYR' then
          Data.OrderTable.FieldByName('Currency').AsString := '2'
        else if sRes = 'USD' then
          Data.OrderTable.FieldByName('Currency').AsString := '3'
        else if sRes = 'RUB' then
          Data.OrderTable.FieldByName('Currency').AsString := '4'
        else
          Data.OrderTable.FieldByName('Currency').AsString := '2';//BYR - default
        Data.OrderTable.Post;
      end;
  end;
  
  if Data.OrderTable.FieldByName('Currency').AsString = '' then
  begin
    Data.OrderTable.Edit;
    Data.OrderTable.FieldByName('Currency').AsString := '2';
    Data.OrderTable.Post;
  end;

  if Data.OrderTable.FieldByName('Delivery').AsString <> '1' then //самовывоз
  begin
    Data.OrderTable.Edit;
    Data.OrderTable.FieldByName('Addres_Id').AsString := '';
    Data.OrderTable.Post;
  end;
  
  
  Result := '';
  with Data.OrderTable do
  begin
    if FieldByName('Order_id').AsInteger = 0 then
      Exit;
    fname := FieldByName('Cli_id').AsString + '_' +
             FieldByName('Order_id').AsString + '_' +
             FieldByName('Date').AsString + '_'+ 
             FieldByName('Num').AsString + '_' + 
             FieldByName('Agreement_No').AsString + '.CSV';
  end;
  
  if FNameDialog then
  begin
    with SaveOrderDialog do
    begin
      InitialDir := Data.Export_path;
      FileName   := fname;
      if not Execute then
        exit;
      fname := FileName;
    end
  end
  else
    fname := Data.Export_Path + fname;
  StartWait;
  AssignFile(F, fname);
  Rewrite(F);
  with Data.OrderTable do
  begin
    if (FieldByName('Sign').AsString = '') or
        FieldByName('Dirty').AsBoolean then
    begin
      Randomize;
      sign := RandomRange(1111111, 9999999);
      Edit;
      FieldByName('Sign').Value  := IntToStr(sign);
      FieldByName('Dirty').Value := False;
      FieldByName('IsDelivered').AsInteger := 0;

      FieldByName('Sent_Time').AsVariant := NULL;
      FieldByName('TcpAnswer').AsVariant := NULL;
      FieldByName('TcpAnswerZam').AsVariant := NULL;

      Post;
    end;

    fileDate := FileAge(Application.ExeName);
    {}
     if (SameText(FieldByName('AgrGroup').AsString,'БН')) or (SameText(FieldByName('AgrGroup').AsString,'')) then
       Note := FieldByName('Description').AsString +
                      'FIO:' +
                      'ADR:' + FieldByName('FakeAddresDescr').AsString +
                      'TEL:'

     else
        Note := FieldByName('Description').AsString +
                      'FIO:' + FieldByName('Name').AsString +
                      'ADR:' + FieldByName('FakeAddresDescr').AsString +
                      'TEL:' + TrimAll(FieldByName('Phone').AsString);

      Note := StringReplace(Note, ';', ',', [rfReplaceAll]);
    {}

    str := FieldByName('Cli_id').AsString + ';' +
           FieldByName('Date').AsString + ';' +
           FieldByName('Sign').AsString + ';';

    if Data.OrderTable.FieldByName('Delivery').AsString = '1' then
    begin
      aDeliveryComment := 'Доставка - ';
      try
        if FieldByName('NearestDelivery').AsBoolean then
          NearestDelivery := '1'
        else
          NearestDelivery := '0';
      except
        NearestDelivery := '1';
        Edit;
        FieldByName('NearestDelivery').AsBoolean := TRUE;
        Post;
      end;
    end
    else
    begin
      aDeliveryComment := 'Самовывоз - ';
      NearestDelivery := '0';
    end;


    str := str + FieldByName('Type').AsString + ';' +
                 FieldByName('Currency').AsString + ';' + {aDeliveryComment + } Note + ';' +
                 DateTimeToStr(FileDateToDateTime(fileDate)) + ';' +
                 'NAV' + ';' +                                 //пометка нового формата заказа
                 FieldByName('Agreement_No').AsString + ';' +  //номер договора
                 FieldByName('Addres_Id').AsString + ';' +     //код адреса доставки
                 FieldByName('Delivery').AsString + ';' +             //1 - доставка, 2 - самовывоз
                 NearestDelivery; //Ближайшая доставка

    WriteLn(F, str);
  end;
  with Data.OrderDetTable do
  begin
    DisableControls;
    rn := RecNo;
    if Data.ParamTable.FieldByName('bSortOrderDet').AsBoolean then
      begin
        sIndexName := IndexName;
        if sIndexName <> 'OrderArt'  then
          IndexName := 'OrderArt';
      end;
    First;
    //Позиции
    while not Eof do
    begin
           s := FieldByName('ArtCode').AsString + '_' +
           FieldByName('Brand').AsString + ';' +
           FieldByName('Quantity').AsString+ ';';
           if Data.ParamTable.FieldByName('bSaveWithPrice').AsBoolean then
              s:=s+  FieldByName('Price_koef').AsString+';';
           s:=s+  FieldByName('Info').AsString+';';
          WriteLn(F,s);
      Next;
    end;
    if Data.ParamTable.FieldByName('bSortOrderDet').AsBoolean then
      begin
        if sIndexName <> 'OrderArt'  then
          begin
            IndexName := sIndexName;
            First;
          end;
      end;
    RecNo := rn;
    EnableControls;
  end;
  CloseFile(F);
  StopWait;
  Result := fname;

  Data.OrderTable.Edit;
  Data.OrderTable.FieldByName('Sent').AsInteger := 3;
  Data.OrderTable.FieldByName('LotusNumber').AsString := '';
  Data.OrderTable.Post;
end;


procedure TMain.SaveReturnDocActionExecute(Sender: TObject);
begin
  SaveReturnDoc('');
end;



procedure TMain.SaveWaitListExecute(Sender: TObject);
var
  sFileName: string;
  ftFile: TextFile;
  sData: string;
  CurDate: TDate;
  rNo: integer;
begin
  //Сохранить лист ожидания
  try
    SaveFilePriceDialog.InitialDir := Data.Export_Path;
    SaveFilePriceDialog.FileName := 'WaitList.csv';
    
    if SaveFilePriceDialog.Execute() = false then
      Exit;

    SetCurrentDir(Data.Data_Path);
    sFileName:= SaveFilePriceDialog.FileName;
    if FileExists(sFileName) then
      if MessageDlg('Файл уже существует. Переписать', mtInformation, [mbYes, MBNO], 0) <> ID_YES  then
        Exit;

    CurDate := Now;
    sData := '.'+inttostr(YearOf(CurDate));
    if MonthOfTheYear(CurDate) < 10 then
      sData := '.0' + inttostr(MonthOfTheYear(CurDate)) + sData
    else
      sData := '.' + inttostr(MonthOfTheYear(CurDate)) + sData;

    if DayOfTheMonth(CurDate) < 10 then
      sData := '0' + inttostr(DayOfTheMonth(CurDate)) + sData
    else
      sData := inttostr(DayOfTheMonth(CurDate)) + sData;

    AssignFile(ftFile,sFileName);
    ReWrite(ftFile);
    with Data.WaitListTable do
    begin
      rNo := RecNo;
      DisableControls;

      Filtered := False;
      First;
      while not EOF do
      begin
        if Data.WaitListTable.FieldByName('Data').AsString = '' then
        begin
          Edit;
          FieldByName('Data').AsString := sData;
          Post;
        end;
        WriteLn(ftFile, FieldByName('Code2').AsString +'_'+FieldByName('Brand').AsString+';'
                       +FieldByName('Quantity').AsString+';'+FieldByName('Info').AsString+';');
        Next;
      end;

      Filtered := True;
      
      RecNo := rNo;
      EnableControls;
    end;

    CloseFile(ftFile);
  except
    on E:Exception do
    begin
      MessageDlg('Ошибка - '+E.Message, mtError, [MBOK],0);
      Exit;
    end;
  end;
  MessageDlg('Лист ожидания сохранен в файл - '+sFileName, mtInformation, [MBOK],0);
end;

procedure TMain.SetActionEnabled;
begin
  RecalcOrderAction.Visible := FALSE;
  LoadOrderActionTCP.Visible := FALSE;
  TCPTNTTNAction.Visible := FALSE;
  LoadOrderAction.Visible := FALSE;
  SaveOrderAction.Visible := FALSE;
  EmailOrderAction.Visible := FALSE;
  PrintOrderAction.Visible:= FALSE;
  OrderDateEd2.Visible := FALSE;
  OrderDateEd1.Visible := FALSE;
  TestOrderForQuants.Visible := FALSE;


  DelOrderAction.Enabled := Data.OrderTable.FieldByName('Order_id').AsInteger <> 0;
  if (Data.OrderTable.FieldByName('Sent').AsString <> '') and
       (Data.OrderTable.FieldByName('Sent').AsString <> '0') and
         (Data.OrderTable.FieldByName('Sent').AsString <> '3') then
  begin
    if (Data.OrderTable.FieldByName('LotusNumber').AsString <> '') and
         (Data.OrderTable.FieldByName('AgrGroup').AsString <> 'НАЛ') then
      TCPTNTTNAction.Visible := TRUE
    else
      TCPTNTTNAction.Visible := FALSE;

    LoadOrderActionTCP.Visible := TRUE;
    UnlockOrderAction.Visible := TRUE;
    EditOrderAction.Visible:=FALSE;
  end
  else
  begin
    if Data.OrderTable.FieldByName('Sent').AsString = '3' then
    begin
      LoadOrderActionTCP.Visible := TRUE;
      if (Data.OrderTable.FieldByName('LotusNumber').AsString <> '') and
           (Data.OrderTable.FieldByName('AgrGroup').AsString <> 'НАЛ') then
        TCPTNTTNAction.Visible := TRUE
      else
        TCPTNTTNAction.Visible := FALSE;
    end
    else
    begin
      LoadOrderActionTCP.Visible := FALSE;
    end;

    EditOrderAction.Visible:=TRUE;
    UnlockOrderAction.Visible := FALSE;
  end;
  acApplyOrderAnswer.Visible := Data.OrderTable.FieldByName('Sent').AsString = '4';
  if acApplyOrderAnswer.Visible then
    LoadOrderActionTCP.Visible := False;


  OrderDateEd1.Visible := TRUE;
  OrderDateEd2.Visible := TRUE;
  PrintOrderAction.Visible:= TRUE;
  EmailOrderAction.Visible := TRUE;
  if acApplyOrderAnswer.Visible then
    EmailOrderAction.Visible := False;

  SaveOrderAction.Visible := TRUE;
  LoadOrderAction.Visible := TRUE;
  RecalcOrderAction.Visible := TRUE;

  EditOrderAction.Enabled := Data.OrderTable.FieldByName('Order_id').AsInteger <> 0;
  PrintOrderAction.Enabled := Data.OrderTable.FieldByName('Order_id').AsInteger <> 0;
  EmailOrderAction.Enabled := Data.OrderTable.FieldByName('Order_id').AsInteger <> 0;
  SaveOrderAction.Enabled := Data.OrderTable.FieldByName('Order_id').AsInteger <> 0;
  RecalcOrderAction.Enabled := Data.OrderTable.FieldByName('Order_id').AsInteger <> 0;
  DeleteFromOrderAction.Enabled := Data.OrderDetTable.FieldByName('Code2').AsString <> '';
  OrderQuantEditAction.Enabled := Data.OrderDetTable.FieldByName('Code2').AsString <> '';
  DeleteFromWaitListAction.Enabled := Data.WaitListTable.FieldByName('Code2').AsString <> '';
  WaitListQuantEditAction.Enabled  := Data.WaitListTable.FieldByName('Code2').AsString <> '';

   if Data.OrderDetTable.RecordCount < 1 then
  begin
      PrintOrderAction.Enabled := FALSE;
      EmailOrderAction.Enabled:=FALSE;
      SaveOrderAction.Enabled:=FALSE;
      TestOrderForQuants.Visible := FALSE;
  end
  else
  begin
      PrintOrderAction.Enabled := TRUE;
      EmailOrderAction.Enabled:=TRUE;
      SaveOrderAction.Enabled:=TRUE;
      if not UnlockOrderAction.Visible then    
        TestOrderForQuants.Visible := TRUE;
  end;


end;


procedure TMain.SetAnActionEnabled;    //NewAnalog
begin
  AddAnToOrderAction.Enabled  := Data.memAnalog.FieldByName('An_id').AsInteger <> 0;
  AddAnToWaitListAction.Enabled  := Data.memAnalog.FieldByName('An_id').AsInteger <> 0;
end;


procedure TMain.SetStyle;
begin
  if Office2003BlueAction.Checked then
    AppStyler.Style := tsOffice2003Blue
  else if Office2003ClassicAction.Checked then
    AppStyler.Style := tsOffice2003Classic
  else if Office2003OliveAction.Checked then
    AppStyler.Style := tsOffice2003Olive
  else if Office2003SilverAction.Checked then
    AppStyler.Style := tsOffice2003Silver
  else if Office2007LunaAction.Checked then
    AppStyler.Style := tsOffice2007Luna
  else if Office2007ObsidianAction.Checked then
    AppStyler.Style := tsOffice2007Obsidian
  else if Office2007SilverAction.Checked then
    AppStyler.Style := tsOffice2007Silver
  else if WhidbeyAction.Checked then
    AppStyler.Style := tsWhidbey
  else if WindowsXPAction.Checked then
    AppStyler.Style := tsWindowsXP;     
  //ToolBarStyler.DragGripStyle := dsNone;
end;
//                  CreateRemoteComObject

procedure TMain.WaitListFlashTimerTimer(Sender: TObject);
begin
  if WaitListPage.ImageIndex = 35 then
    WaitListPage.ImageIndex := 45
  else
    WaitListPage.ImageIndex := 35;
end;

procedure TMain.WaitListGridDblClick(Sender: TObject);
begin
  if data.OOTable.Locate('Cat_id', data.WaitListTable.FieldByName('Cat_id').asInteger, []) then
  begin
   TOrderOnlyInfoForm.Execute(
      Data.WaitListDataSource.DataSet.FieldByName('ArtCode').AsString,
      Data.WaitListDataSource.DataSet.FieldByName('BrandRepl').Asstring,
      Data.WaitListDataSource.DataSet.FieldByName('ArtNameDescr').AsString
    );
    Exit;
  end
  else
  MainActionExecute(WaitListQuantEditAction)
end;

procedure TMain.WaitListGridDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if Source <> MainGrid then
    exit;
  AddToWaitList;
end;

procedure TMain.WaitListGridDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source = MainGrid then
    Accept := True;
end;

procedure TMain.WaitListGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
begin
  if SameText(Column.FieldName, 'ArtQuant') then
    if WaitListGrid.DataSource.DataSet.FieldByName('ArtQuantLatest').AsInteger = 1 then
    begin
      NewImageList.Draw(WaitListGrid.Canvas, Rect.Right - NewImageList.Width, Rect.Top, 1);
    end;
end;

procedure TMain.WaitListGridGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  if (Data.WaitListTable.FieldByName('ArtQuant').AsString <> '') and
     (Data.WaitListTable.FieldByName('ArtQuant').AsString <> '0') then
  begin
    AFont.Style := [fsBold];
    Background := $00D0D0D0;
  end;
end;

procedure TMain.WaitListGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    MainActionExecute(WaitListQuantEditAction)
  else if Key = VK_DELETE then
    MainActionExecute(DeleteFromWaitListAction)
  else if Key = VK_SPACE then
    MoveToWaitListPosition.Execute;
end;

procedure TMain.WaitListGridTitleClick(Column: TColumnEh);
var
  aFieldName: string;
begin
  if not Column.Title.TitleButton then
    Exit;

  aFieldName := Column.FieldName;
  if aFieldName = 'BrandRepl' then
    aFieldName := 'Brand';

  if aFieldName = 'DateCreate' then
  begin
    if Data.WaitListTable.IndexName <> 'DateCreate' then
    begin
      Column.Title.SortMarker := smUpEh;
      Data.WaitListTable.IndexName := 'DateCreate';
    end
    else
    begin
      Column.Title.SortMarker := smNoneEh;
      Data.WaitListTable.IndexName := '';
    end;
    Exit;
  end;

  if aFieldName = 'ClientInfo' then
  begin
    if Data.WaitListTable.IndexName <> 'Cli_date' then
    begin
      Column.Title.SortMarker := smUpEh;
      Data.WaitListTable.IndexName := 'Cli_date';
    end
    else
    begin
      Column.Title.SortMarker := smNoneEh;
      Data.WaitListTable.IndexName := 'DateCreate';
    end;
    Exit;
  end;

  case Column.Title.SortMarker of
    smUpEh:
    begin
      Column.Title.SortMarker := smDownEh;
      Data.WaitListTable.IndexName := 'D' + aFieldName;
    end;
    smDownEh:
    begin
      Data.WaitListTable.IndexName := '';
      Column.Title.SortMarker := smNoneEh;
    end;
    smNoneEh:
    begin
      Column.Title.SortMarker := smUpEh;
      Data.WaitListTable.IndexName := aFieldName;
    end;
  end;
end;

procedure TMain.DoDiskUpdate;

  function GetUpdateTypeByZipName(const aZipName: string): TUpdatePackageType;
  begin
    Result := wupUnknown;

    // данные (полное обновление)
    if SameText(aZipName, UPD_DATA_ZIP) then
      Result := wupData
    // данные (частичное обновление)
    else if SameText(Copy(aZipName, 1, Length(UPD_DATA_DISCRET)), UPD_DATA_DISCRET) then
      Result := wupDataDiscret
    // новости
    else if SameText(aZipName, UPD_NEWS_ZIP) then
      Result := wupNews
    // остатки
    else if SameText(aZipName, UPD_QUANTS_ZIP) then
      Result := wupQuants
    // картинки (частичное обновление)
    else if SameText(Copy(aZipName, 1, Length(UPD_PICTS_DISCRET)), UPD_PICTS_DISCRET) then
      Result := wupPictsDiscret
    //шины
    else if SameText(Copy(aZipName, 1, Length(UPD_TIRES_ZIP)), UPD_TIRES_ZIP) then
      Result := wupTires;

  end;


var
//  SecurityAttributes: TSecurityAttributes;
  aQueueItem: TUpdateQueueItem;
  anUpdateType: TUpdatePackageType;
begin
  if Assigned(UpdateThrd) then
  begin
    MessageDlg('В данный момент уже устанавливается обновление.'#13#10 +
               'Дождитесь завершения и повторите попытку.', mtInformation, [mbOK], 0);
    Exit;
  end;

  Data.OpenZipDialog.InitialDir := Data.Import_Path;
  if not Data.OpenZipDialog.Execute then
    Exit;

  anUpdateType := GetUpdateTypeByZipName(ExtractFileName(Data.OpenZipDialog.FileName));
  if anUpdateType = wupUnknown then
  begin
    MessageDlg('Этот файл не является пакетом обновления!', mtError, [mbOK], 0);
    Exit;
  end;

  SetStatusColums(False);
  UpdateDataError := '';

  tmp_path := PrepareTempDirForUpdate;

  //формируем очередь обновления
  fUpdateQueue.Clear;
  aQueueItem := fUpdateQueue.Add;
  aQueueItem.PackageType := anUpdateType;
  aQueueItem.ZipFile := Data.OpenZipDialog.FileName;
  aQueueItem.VersionsInside := True; //версии внутри пакета

  UpdateThrd := TUpdateDataThrd.Create(Self.Handle);
  UpdateThrd.OnTerminate := UpdateDataThreadTerminate;
  UpdateThrd.Init(
    fUpdateQueue,
    tmp_path{aTempPath}
  );

  LockAutoUpdate(True);
  UpdateThrd.Resume;
end;

procedure TMain.DowebUpdate(IsExtUpdate: Boolean);
var
  upd_url: string;
  aModalResult: Integer;
begin
//  if isOpenedMoreThan2Windows('UpdatesWindows') then
 //   Exit;

  if Assigned(UpdateThrd) or (not bTerminate) then
  begin
    MessageDlg('В данный момент уже устанавливается обновление.'#13#10 +
               'Дождитесь завершения и повторите попытку.', mtInformation, [mbOK], 0);
    Exit;
  end;

  try
    aModalResult := mrNone;

    if MainDownLoadFileMirrors(Data.GetUpdateUrlDestFile, IsExtUpdate) then
    begin
//      upd_url := Data.GetUpdateUrl(False); //without proxy args
      upd_url := Data.BuildUpdateUrl(fCurrentWorkingServer, False, IsExtUpdate); //without proxy args
      if (upd_url <> '') then
      begin
        with TUpdatesWindows.Create(nil) do
        try
          if SetParametrs(Data.Import_Path, upd_url, False{aSilentMode}, IsExtUpdate) then
            aModalResult := ShowModal;
        finally
          Free;

          // CheckProgrammPeriod
          if aModalResult <> mrOK then
            VersionTimer.Enabled := True;
        end;
      end;
    end;
  except
    on E: Exception do
      Application.MessageBox(PChar(E.Message), 'Ошибка', MB_OK or MB_ICONERROR);
  end;
end;


procedure TMain.DownloadUpdateError(var Msg: TMessage);
begin
  MessageDlg('Загрузка обновления не выполнена! Причина - ' + PChar(msg.lParam) + '.', mtError, [mbOK], 0);
  // CheckProgrammPeriod
  VersionTimer.Enabled := True;
end;

procedure TMain.DrawLights(AState: TOwnerDrawState; ACanvas: TCanvas; ARect: TRect; const AText: string; const fNeedUpdate: boolean = True);
var
  aColor: integer;
  fSelected: boolean;
begin
  if (odHotLight in AState) or ((odSelected in AState)) then
  begin
    ACanvas.Brush.Color := TColor(RGB(51, 153, 255));
    ACanvas.FillRect(ARect);
    fSelected := True;
  end
  else
  begin
    ACanvas.Brush.Color := clBtnFace;
    ACanvas.FillRect(ARect);
    fSelected := False;
  end;

  if not fNeedUpdate then
    aColor := clYellow
  else
    aColor := clGreen;
  if aColor <> ACanvas.Brush.color then
  begin
    ACanvas.Brush.color := aColor;
    ACanvas.Ellipse(ARect.Left, ARect.Top + 2, ARect.Left + (ARect.Bottom - ARect.Top - 4), ARect.Bottom -2);
    ACanvas.Brush.Style := bsClear;
    if fSelected then
      ACanvas.Font.Color := clWhite
    else
      ACanvas.Font.Color := clBlack;
    ACanvas.TextOut(ARect.Left + 21, ARect.Top + 2, AText);
  end;
end;

procedure TMain.DrawOrderOnlyField(aGrid: TDBGridEh; aRect: TRect; State: TGridDrawState; Quants:string);
begin
//  aGrid.Canvas.Brush.Color := clWhite;
{  if Quatns <> '' then
    saleStr := 'Quatns Под заказ';}
  aGrid.Canvas.Font.Color := clRed;
  aGrid.Canvas.Font.Style := [];
  InflateRect(aRect, -1, -1);
  if (Quants = '') or (Quants = '0') then
    aGrid.Canvas.TextRect(aRect, aRect.Left + 2, aRect.Top, 'Под заказ')
  else
    aGrid.Canvas.TextRect(aRect, aRect.Left + 2, aRect.Top, Quants);
end;

procedure TMain.TCPTNTTNActionExecute(Sender: TObject);
var
  EMail: string;
  Path: string;
  sFileName: string;
  sLotusNumber: string;
  binFile: TMemoryStream;
  iPosFile: Integer;
  iFilePos: Integer;
  sHesh: string;
  TCPClientTest: TIdTCPClient;
begin
  if Data.OrderTable.FieldByName('Order_id').AsString < '1' then
    Exit;

  if length(Data.OrderTable.FieldByName('LotusNumber').AsString) < 1 then
    Exit;

  sLotusNumber := Data.OrderTable.FieldByName('LotusNumber').AsString;

  Path := GetAppDir + 'Импорт\';
  sFileName := Path + Data.OrderTable.FieldByName('Date').AsString + '_' + Data.OrderTable.FieldByName('Num').AsString + '_' + sLotusNumber + '.zip';
  if not FileExists(sFileName) then
  begin
    TCPClientTest := TIdTCPClient.Create(nil);
    try
      if not DoTcpConnect(TCPClientTest, True, True) then
        Exit;

      with TCPClientTest do
      begin
        email := 'EXCEL_ACK1';
        IOHandler.Writeln(email);
        IOHandler.Writeln(sLotusNumber);
        email := IOHandler.ReadLnWait;
        if(email = 'END') then
        begin
          MessageDlg('ТТН(ТН) ещё не распечатана. Повторите попытку позже!', mtInformation, [mbOK], 0);
          Disconnect;
          Exit;
        end;

        iFilePos := 1;
        for iPosFile := 1 to Length(email) do
        begin
          if iFilePos > Length(sLotusNumber) then
            iFilePos := 1;

          if iPosFile > iPosFile then
            sHesh := sHesh + inttostr(((StrToInt(email[iPosFile]+ IntToStr(StrToIntDef(sLotusNumber[iFilePos], 0)))*iFilePos) mod iPosFile))
          else
            sHesh := sHesh + inttostr(((StrToInt(email[iPosFile]+ IntToStr(StrToIntDef(sLotusNumber[iFilePos], 0)))*iFilePos) div iPosFile));

          Inc(iFilePos);
        end;

        IOHandler.Writeln(sHesh);
        email := IOHandler.ReadLnWait;

        binFile := TMemoryStream.Create;
        try
          IOHandler.ReadStream(binFile, -1, False);
          binFile.SaveToFile(sFileName);
        finally
          binFile.Free;
        end;
      end;
    finally
      TCPClientTest.Disconnect;
      TCPClientTest.Free;
    end;

  end;

  if not FileExists(sFileName) then
    Exit;

  UnZipper.ZipName  := sFileName;
  UnZipper.ReadZip;
  sFileName := UnZipper.Filename[0];
  UnZipper.FilesList.Clear;
  UnZipper.FilesList.Add(sFileName);
  UnZipper.DoAll := False;
  UnZipper.DestDir := Path;
  UnZipper.RecreateDirs := False;
  UnZipper.RetainAttributes := True;
  UnZipper.Unzip;
  sFileName := Path + sFileName;

  if FileExists(sFileName) then
    ShellExecute(Main.Handle, nil, PAnsiChar(sFileName), nil, nil, SW_SHOW)
end;

function TMain.TestEmailAdress(sEmail: string): bool;
var
  i, cntDogs: integer;
  namePart, serverPart: string;
begin
  Result:= false;
  cntDogs := 0;

  for i:= 1 to Length(sEmail) do
  begin
    if not (sEmail[i] in ['a'..'z', 'A'..'Z', '0'..'9', '_', '-', '.','@']) then
      Exit;
    if sEmail[i] = '@' then
      inc(cntDogs);
  end;

  if (cntDogs > 1) or (cntDogs = 0) then
    exit;

  if Pos('..', sEmail) > 0 then
    exit;

  i := pos('@', sEmail);
  namePart:= Copy(sEmail, 1, i - 1);
  serverPart:= Copy(sEmail, i + 1, Length(sEmail));
  if (Length(namePart) = 0) or ((Length(serverPart) < 1)) then
    Exit;

  i:= Pos('.', serverPart);
  if (i < 2) or (i > (Length(serverPart) - 1)) then
    Exit;

  Result:= True;
end;

procedure TMain.TestForAdminMode;
var
  i: integer;
begin
  AdminMode := FALSE;
  ServFuncMenu.Visible :=FALSE;
  //adminmode
//exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}


  for i := 1 to ParamCount do
  begin
   if (UpperCase(ParamStr(i)) = '215@ADMIN141698MODE4515RUN@45@2') or
       (UpperCase(ParamStr(i)) = '-215@ADMIN141698MODE4515RUN@45@2') then
    begin
      AdminMode := True;
      AdminPasswEntered := True;
      break;
    end
  end;
  AdminMode := TRUE;
  ServFuncMenu.Visible := AdminMode;
end;


procedure TMain.TestLoadLockActionExecute(Sender: TObject);
begin
  TestLoadLockAction.Checked := not TestLoadLockAction.Checked;
  if TestLoadLockAction.Checked then
    Data.LoadingLock
  else
    Data.LoadingUnlock
end;



procedure TMain.TestLotusCatalogExecute(Sender: TObject);
begin
    //adminmode
//    exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

    Data.TestLotusCatalog;
end;

procedure TMain.TestOrderForQuantsExecute(Sender: TObject);
var
  customversion: string;
  curr: TDate;
begin
 //Проверка....
  ClearTestQuants;

  curr := Now;
  if YearOf(curr) - 2000 < 10  then
    customversion := '0'+inttostr(YearOf(curr) - 2000)
  else
    customversion := inttostr(YearOf(curr) - 2000);

  if MonthOfTheYear(curr) < 10  then
     customversion := customversion+'0'+inttostr(MonthOfTheYear(curr))
  else
     customversion := customversion+inttostr(MonthOfTheYear(curr));

  if DayOfTheMonth(curr) < 10  then
     customversion := customversion+'0'+inttostr(DayOfTheMonth(curr))
  else
     customversion := customversion+inttostr(DayOfTheMonth(curr));

  customversion :=  customversion+'.1';
  if TestString(Data.VersionTable.FieldByName('QuantVersion').Value,customversion) then
  begin
    if MessageDlg('Версия остатков: '+Data.VersionTable.FieldByName('QuantVersion').AsString +
              '. Перед выполнением проверки рекомендуем обновить остатки! Прервать?', mtInformation ,[mbYes, mbNo],0) = IDYES then
    exit;
  end;

  Data.OrderDetTable.DisableControls;
  Data.OrderDetTable.IndexName := 'Order';
  Data.OrderDetTable.First;

  while not Data.OrderDetTable.EOF do
  begin
    Data.OrderDetTable.Edit;
    Data.OrderDetTable.FieldByName('TestQuants').AsInteger := 1;
    Data.OrderDetTable.Post;
    if Data.BrandTable.Locate('Description', Data.OrderDetTable.FieldByName('Brand').AsString, []) and
         Data.XCatTable.FindKey([Data.OrderDetTable.FieldByName('Code2').AsString,
           Data.BrandTable.FieldByName('Brand_id').AsInteger]) then
    begin
      if Data.QuantTable.Locate('Cat_id',Data.XCatTable.FieldByName('Cat_id').AsInteger, []) then
        if (Data.QuantTable.FieldByName('Quantity').AsString <> '0') and (Data.QuantTable.FieldByName('Quantity').AsString <> '') then
        begin
          Data.OrderDetTable.Edit;
          Data.OrderDetTable.FieldByName('TestQuants').AsInteger := 2;
          Data.OrderDetTable.Post;
        end;
    end;
    Data.OrderDetTable.Next;
  end;

  if Data.OrderDetTable.IndexName <> 'TestQuants' then
    Data.OrderDetTable.IndexName := 'TestQuants';
  Data.OrderDetTable.first;
  Data.OrderDetTable.EnableControls;

  aTestQuantsFilled := Data.OrderTableOrder_id.AsInteger;

  with TTestForQuants.Create(nil) do
  begin
    ShowModal;
    Data.OrderDetTable.Refresh;
  end;
end;

function TMain.ChoiseUpdateDir(a1: integer): TTaskDirectory;
var
  i: integer;
begin
  result := nil;
  Data.ClIDsTable.Refresh;

  CheckUpdateDir := a1;
  for i := 0 to fScheduler.TaskCount - 1 do
    if fScheduler.GetTask(i) is TTaskDirectory then
    begin
      fScheduler.GetTask(i).Start;
      result := fScheduler.GetTask(i) as TTaskDirectory;
    end;
end;

procedure TMain.LoadOrder;
var
  s, ics, cb, cat_code, cat_brand, old_br_ind: string;
  brand_id: integer;
  quant: integer;
  F: TextFile;
  iLines:integer;
  bReplBrand: boolean;
  aPriceEUR: Currency;
  SaleQ: string;
begin
  if not Data.OpenDialog.Execute then
    Exit;
  StartWait;
 if not NewOrder then
 begin
     StopWait;
     exit;
 end;
  with Data.LoadCatTable do
  begin
    IndexName := 'Code2';
    Open;
  end;
  bReplBrand := Data.ParamTable.FieldByName('bReplBrand').AsBoolean;
  old_br_ind := Data.BrandTable.IndexName;
  Data.BrandTable.IndexName := 'Descr';
  ics := Data.SysParamTable.FieldByName('Ign_chars').AsString;
  Memo.Lines.Clear;
  AssignFile(F, Data.OpenDialog.FileName);
  Reset(F);
  Readln(F, s);
  if length(s) > 0 then
  begin
    with Data.OrderTable do
    begin
      Edit;
      FieldByName('Description').AsString := ExtractDelimited(6,  s, [';']);
      if ExtractDelimited(4,  s, [';']) <> 'B' then
        FieldByName('Type').AsString := 'A'
      else
        FieldByName('Type').AsString := 'B';
      Post;
    end;
  end;

  iLines := 0;
  Memo.Lines.Insert(iLines, s);
  while not System.Eof(F) do
  begin
    Readln(F, s);
    cb := ExtractDelimited(1,  s, [';']);
    cat_code  := Data.MakeSearchCode(ExtractDelimited(1,  cb, ['_']));
    cat_brand := ExtractDelimited(2,  cb, ['_']);

    {16.05.2014 Ìàïêà áðåíäîâ äëÿ çàìåíû}
    if bReplBrand then
      if Data.mapBrand4ImportOrder.Locate('replBrand',cat_brand, []) then
        cat_brand := Data.ReBranding(Data.mapBrand4ImportOrder.FieldByName('serviceBrand').AsString, FALSE);
    {***}

    try
      quant := StrToInt(ExtractDelimited(2,  s, [';']));
      //AToFloat(ExtractDelimited(2,  s, [';']));
    except
      quant := 0;
    end;

    with Data.BrandTable do
    begin
      if IndexName <> 'Descr' then
        IndexName := 'Descr';

      iLines := iLines + 1;
      if FindKey([cat_brand]) then
        brand_id := FieldByName('Brand_id').AsInteger
      else
        brand_id := 0;
      end;

      if (Trim(cat_code) = '') and (Trim(cat_brand) = '') then
      begin
        Memo.Lines.Insert(iLines,s+'; íå íàéäåí ');
        Continue;
      end;

      with Data.OrderDetTable do
      begin
        if (cat_code <> '') and
          Data.LoadCatTable.FindKey([cat_code, brand_id]) then
          //Data.LoadCatTable.FindKey([cat_code, brand_id]) then
        begin
          Append;
          FieldByName('Order_id').Value :=
          Data.OrderTable.FieldByName('Order_id').AsInteger;
          FieldByName('Code2').Value := cat_code;
          FieldByName('Brand').Value := cat_brand;

          FieldByName('Price').Value := Data.ComparePrices(Data.XCatTable.FieldByName('Group_id').AsInteger, Data.XCatTable.FieldByName('Subgroup_id').AsInteger, Data.XCatTable.FieldByName('Brand_id').AsInteger,
                    Data.SetNotNullPrice(Data.XCatTable.FieldByName('PriceItog').AsCurrency, Data.XCatTable.FieldByName('Price').AsCurrency),
                    Data.SetNotNullPrice(Data.XCatTable.FieldByName('PriceQuantOptRF').AsCurrency, 0),
                    Data.XCatTable.FieldByName('saleQ').AsString,
                    Data.XCatTable.FieldByName('saleQOptRFCalc').AsString,
                    aPriceEUR, SaleQ, Data.fUsingOptRF
                   );

          {if Data.LoadCatTable.FieldByName('SaleQ').AsString <> '1' then
            FieldByName('Price').Value :=
              Data.GetDiscount(
                Data.LoadCatTable.FieldByName('Group_id').AsInteger,
                Data.LoadCatTable.FieldByName('SubGroup_id').AsInteger,
                Data.LoadCatTable.FieldByName('Brand_id').AsInteger
              ) * Data.LoadCatTable.FieldByName('PriceItog').AsCurrency
          else
            FieldByName('Price').Value := Data.LoadCatTable.FieldByName('PriceItog').AsCurrency;   }
          //price_pro???
          CalcProfitPriceForOrdetDetCurrent;

          try
            if ((quant mod Data.XCatTable.FieldByName('Mult').AsInteger) <> 0) then
            begin
              if MessageDlg('Êîëè÷åñòâî íå êðàòíî ðåêîìåíäóåìîìó! Ïîçèöèÿ: '+
                            cat_code + '. Çàêàçàòü ñ ó÷åòîì êðàòíîñòè?', mtWarning, [mbYes, mbNo], 0) <> mrYes then
              begin
                Memo.Lines.Insert(iLines,s+'; Êîëè÷åñòâî íå êðàòíî ðåêîìåíäóåìîìó!');
                Continue;
              end;
              quant := quant + (Data.XCatTable.FieldByName('Mult').AsInteger - (quant mod Data.XCatTable.FieldByName('Mult').AsInteger));
            end;
          except
            //åñëè êðàòíîñòü ðàâíà 0 èëè äðóãàÿ îøèáêà îñòàâëÿåì âñå êàê åñòü
          end;

          FieldByName('Quantity').Value := quant;

          if Data.ParamTable.FieldByName('bSaveWithPrice').AsBoolean then
          begin
            if AToCurr(ExtractDelimited(3,  s, [';']))>0 then
            begin
              FieldByName('Info').Value := ExtractDelimited(4,  s, [';']);
            end
            else
              FieldByName('Info').Value := ExtractDelimited(3,  s, [';']);
          end
          else
            if AToCurr(ExtractDelimited(3,  s, [';']))>0 then
              FieldByName('Info').Value := ExtractDelimited(4,  s, [';'])
            else
              FieldByName('Info').Value := ExtractDelimited(3,  s, [';']);
          Post;
          Memo.Lines.Insert(iLines,s);
        end
        {Åñëè íå íàøëî ïî ïåðâîíà÷àëüíîé ñâÿçêå}
        else
        begin
          if bReplBrand then
          begin
            Memo.Lines.Insert(iLines,s+'; íå íàéäåí ');
            Continue;
          end;

          with Data.DoubleTable do
          begin
            Open;
            SetRange([cat_code],[cat_code]);
            if RecordCount > 1 then
            begin
              with  TSelectDetail.Create(nil) do
              begin
                Caption := 'Âûáåðèòå áðåíä äëÿ íîìåðà "'+cat_code+'"';
                if ShowModal = mrOk then
                begin
                  cat_brand := FieldByName('BrandName').AsString;

                  with Data.OrderDetTable do
                  begin
                    if (cat_code <> '') and
                      Data.XCatTable.FindKey([cat_code, Data.DoubleTable.FieldByName('Brand_Id').AsInteger]) then
                    begin
                      Append;
                      FieldByName('Order_id').Value :=
                      Data.OrderTable.FieldByName('Order_id').AsInteger;
                      FieldByName('Code2').Value := cat_code;
                      FieldByName('Brand').Value := cat_brand;

                      FieldByName('Price').Value := Data.ComparePrices(Data.XCatTable.FieldByName('Group_id').AsInteger, Data.XCatTable.FieldByName('Subgroup_id').AsInteger, Data.XCatTable.FieldByName('Brand_id').AsInteger,
                              Data.SetNotNullPrice(Data.XCatTable.FieldByName('PriceItog').AsCurrency, Data.XCatTable.FieldByName('Price').AsCurrency),
                              Data.SetNotNullPrice(Data.XCatTable.FieldByName('PriceQuantOptRF').AsCurrency, 0),
                              Data.XCatTable.FieldByName('saleQ').AsString,
                              Data.XCatTable.FieldByName('saleQOptRFCalc').AsString,
                              aPriceEUR, SaleQ, Data.fUsingOptRF);
                     { if Data.LoadCatTable.FieldByName('SaleQ').AsString <> '1' then
                        FieldByName('Price').Value :=
                          Data.GetDiscount(
                            Data.LoadCatTable.FieldByName('Group_id').AsInteger,
                            Data.LoadCatTable.FieldByName('SubGroup_id').AsInteger,
                            Data.LoadCatTable.FieldByName('Brand_id').AsInteger
                          ) * Data.LoadCatTable.FieldByName('PriceItog').AsCurrency
                      else
                        FieldByName('Price').Value := Data.LoadCatTable.FieldByName('PriceItog').AsCurrency; }
                      //price_pro???
                      CalcProfitPriceForOrdetDetCurrent;

                      try
                        if ((quant mod Data.XCatTable.FieldByName('Mult').AsInteger) <> 0) then
                        begin
                          if MessageDlg('Êîëè÷åñòâî íå êðàòíî ðåêîìåíäóåìîìó! Ïîçèöèÿ: '+
                                        cat_code + '. Çàêàçàòü ñ ó÷åòîì êðàòíîñòè?', mtWarning, [mbYes, mbNo], 0) <> mrYes then
                          begin
                            Memo.Lines.Insert(iLines,s+'; Êîëè÷åñòâî íå êðàòíî ðåêîìåíäóåìîìó!');
                            Continue;
                          end;
                          quant := quant + (Data.XCatTable.FieldByName('Mult').AsInteger - (quant mod Data.XCatTable.FieldByName('Mult').AsInteger));
                        end;
                      except
                        //
                      end;

                      FieldByName('Quantity').Value := quant;

                      if Data.ParamTable.FieldByName('bSaveWithPrice').AsBoolean then
                      begin
                        if AToCurr(ExtractDelimited(3,  s, [';']))>0 then
                        begin
                          FieldByName('Info').Value := ExtractDelimited(4,  s, [';']);
                        end
                        else
                          FieldByName('Info').Value := ExtractDelimited(3,  s, [';']);
                      end
                      else
                        if AToCurr(ExtractDelimited(3,  s, [';']))>0 then
                          FieldByName('Info').Value := ExtractDelimited(4,  s, [';'])
                        else
                          FieldByName('Info').Value := ExtractDelimited(3,  s, [';']);
                      Post;
                    end;
                  end;

                  Memo.Lines.Insert(iLines,s+'; çàìåíåí íà '+cat_code+'_'+cat_brand);
                end //showmodal
                else
                  Memo.Lines.Insert(iLines,s+'; íå íàéäåí ');

              end; //with
            end //if RecordCount > 1 then
            else
              if RecordCount = 1 then
              begin
                cat_brand := FieldByName('BrandName').AsString;

                with Data.OrderDetTable do
                begin
                  if (cat_code <> '') and
                     Data.XCatTable.FindKey([cat_code, Data.DoubleTable.FieldByName('Brand_Id').AsInteger]) then
                  begin
                    Append;
                    FieldByName('Order_id').Value :=
                    Data.OrderTable.FieldByName('Order_id').AsInteger;
                    FieldByName('Code2').Value := cat_code;
                    FieldByName('Brand').Value := cat_brand;
                    FieldByName('Price').Value := Data.ComparePrices(Data.XCatTable.FieldByName('Group_id').AsInteger, Data.XCatTable.FieldByName('Subgroup_id').AsInteger, Data.XCatTable.FieldByName('Brand_id').AsInteger,
                              Data.SetNotNullPrice(Data.XCatTable.FieldByName('PriceItog').AsCurrency, Data.XCatTable.FieldByName('Price').AsCurrency),
                              Data.SetNotNullPrice(Data.XCatTable.FieldByName('PriceQuantOptRF').AsCurrency, 0),
                              Data.XCatTable.FieldByName('saleQ').AsString,
                              Data.XCatTable.FieldByName('saleQOptRFCalc').AsString,
                              aPriceEUR, SaleQ, Data.fUsingOptRF);

                    {if Data.LoadCatTable.FieldByName('SaleQ').AsString <> '1' then
                      FieldByName('Price').Value :=
                        Data.GetDiscount(
                          Data.LoadCatTable.FieldByName('Group_id').AsInteger,
                          Data.LoadCatTable.FieldByName('Subgroup_id').AsInteger,
                          Data.LoadCatTable.FieldByName('Brand_id').AsInteger
                        ) * Data.LoadCatTable.FieldByName('PriceItog').AsCurrency
                    else
                      FieldByName('Price').Value := Data.LoadCatTable.FieldByName('PriceItog').AsCurrency;}
                    //price_pro???
                    CalcProfitPriceForOrdetDetCurrent;

                    try
                      if ((quant mod Data.XCatTable.FieldByName('Mult').AsInteger) <> 0) then
                      begin
                        if MessageDlg('Êîëè÷åñòâî íå êðàòíî ðåêîìåíäóåìîìó! Ïîçèöèÿ: '+
                                      cat_code + '. Çàêàçàòü ñ ó÷åòîì êðàòíîñòè?', mtWarning, [mbYes, mbNo], 0) <> mrYes then
                        begin
                          Memo.Lines.Insert(iLines,s+'; Êîëè÷åñòâî íå êðàòíî ðåêîìåíäóåìîìó!');
                          Continue;
                        end;
                        quant := quant + (Data.XCatTable.FieldByName('Mult').AsInteger - (quant mod Data.XCatTable.FieldByName('Mult').AsInteger));
                      end;
                    except
                      //
                    end;

                    FieldByName('Quantity').Value := quant;


                    if Data.ParamTable.FieldByName('bSaveWithPrice').AsBoolean then
                    begin
                      if AToCurr(ExtractDelimited(3,  s, [';']))>0 then
                      begin
                        FieldByName('Info').Value := ExtractDelimited(4,  s, [';']);
                      end
                      else
                        FieldByName('Info').Value := ExtractDelimited(3,  s, [';']);
                    end
                    else
                      if AToCurr(ExtractDelimited(3,  s, [';']))>0 then
                        FieldByName('Info').Value := ExtractDelimited(4,  s, [';'])
                      else
                        FieldByName('Info').Value := ExtractDelimited(3,  s, [';']);
                      Post;
                  end;
                end; //with

                Memo.Lines.Insert(iLines,s+'; çàìåíåí íà '+cat_code+'_'+cat_brand);
              end //if RecordCount = 1 then
                else
                  Memo.Lines.Insert(iLines,s+'; íå íàéäåí ');

            Close;
          end; //with Data.DoubleTable
        end;
    end;
  end; //while
  CloseFile(F);
  Memo.Lines.SaveToFile(Data.OpenDialog.FileName);
  Data.BrandTable.IndexName := old_br_ind;
  Data.LoadCatTable.Close;
  Data.OrderTable.Refresh;
  Data.OrderTableAfterScroll(Data.OrderTable);
  Data.CatalogDataSource.DataSet.Refresh;
  StopWait;
end;


procedure TMain.AddToWaitList;
var
  UserData: TUserIDRecord;
begin
  if Data.CatalogDataSource.DataSet.FieldByName('Title').AsBoolean or
     (Data.CatalogDataSource.DataSet.FieldByName('Cat_id').AsInteger = 0) or
     (Data.CatalogDataSource.DataSet.FieldByName('PriceItog').AsCurrency = 0) then
    Exit;

  UserData := GetCurrentUser;

  with TQuantityEdit.Create(Application) do
  begin
    Init(-1, '', False, '', '');
    Caption := 'Количество товара в листе ожидания';
    ArtInfo.Text := Data.CatalogDataSource.DataSet.FieldByName('Code').Asstring + '  ' +
                    Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString + #13#10 +
                    Data.CatalogDataSource.DataSet.FieldByName('Name_Descr').Asstring;
    MultInfo.Value := Data.CatalogDataSource.DataSet.FieldByName('Mult').AsInteger;
    if MultInfo.Value <> 0 then
      QuantityEd.Value := MultInfo.Value
    else
      QuantityEd.Value := 1;
    if ShowModal = mrOk then
    begin
      with Data.WaitListTable do
      begin
        if not Locate('Code2;Brand;cli_id',
          VarArrayOf([Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString,
                      Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString,
                      UserData.sId]), []) then
        begin
          Append;
          FieldByName('Code2').Value :=
             Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString;
          FieldByName('Brand').Value :=
             Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString;
          if UserData <> nil then
            FieldByName('cli_id').Value := UserData.sId;
        end
        else
          Edit;
        FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat +
                                         QuantityEd.Value;
        FieldByName('Data').Value := DataNow;
        FieldByName('Info').Value := InfoEd.Text;
        Post;
      end;
      Data.CalcWaitList;
    end;
    Free;
  end;
end;

procedure TMain.AdvToolBarButton42Click(Sender: TObject);
begin
  WebSearchOE('');
end;

procedure TMain.GetDirectoryClick(Sender: TObject);
begin
    fClickedBtnUpdate := True;
    ChoiseUpdateDir(3);
end;

procedure TMain.AfterColResize(var Msg: TMessage);
var
  r: TRect;
begin
  MainGrid.TitleLines := 0;
  MainGrid.UseMultiTitle := True;
  r := MainGrid.CellRect(0, 0);
  MainGrid.UseMultiTitle := False;
  MainGrid.TitleHeight := r.Bottom - r.Top;
end;

procedure TMain.AfterToolPanelResize(var Msg: TMessage);
var
  aPanel: TAdvToolPanel;
begin
  if Msg.WParam = 0 then
    Exit;

  aPanel := TAdvToolPanel(Pointer(Msg.WParam));
  if aPanel = ToolPanelTree then
    if aPanel.Locked and not SplitterLeft.Visible then
    begin
      SplitterLeft.Show;
      SplitterLeft.Align := alRight;
      SplitterLeft.Align := alLeft;
    end;

  if aPanel = ToolPanelNotepad then
    if aPanel.Locked and not SplitterRight.Visible then
    begin
      SplitterRight.Show;
      SplitterRight.Align := alLeft;
      SplitterRight.Align := alRight;
    end;
end;

function TMain.AgrNotFound(Value: string): string;
begin
  Result := Value;
  if Pos('Контрагент не найден',Value) = 0 then
    Result := 'Контрагент не найден!' + Value;
end;

procedure TMain.ToolPanelTabRightMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  aIndex: Integer;
begin
  if fRollActive then
    Abort;

  if (Button = mbLeft) then
  begin
    aIndex := ToolPanelTabRight.PanelIndex(ToolPanelNotepad);
    if ToolPanelTabRight.Panels[aIndex].State = psOpened then
    begin
      ToolPanelTabRight.RollIn(ToolPanelNotepad);
      Abort;
    end;
  end;

end;


procedure TMain.ToolPanelTabRightTabSlideIn(Sender: TObject; Index: Integer;
  APanel: TAdvToolPanel);
begin
  fRollActive := True;
  //ToolPanelNotepad.Floating := False;
  fNotePadForm.Align := alLeft;
end;

procedure TMain.ToolPanelTabRightTabSlideInDone(Sender: TObject; Index: Integer;
  APanel: TAdvToolPanel);
begin
  fRollActive := False;
  fNotePadForm.Hide;
  if MainGrid.CanFocus then
    MainGrid.SetFocus;
end;

procedure TMain.ToolPanelTabRightTabSlideOut(Sender: TObject; Index: Integer;
  APanel: TAdvToolPanel);
begin
  fRollActive := True;
  fNotePadForm.Show;
  fNotePadForm.Align := alLeft;
end;

procedure TMain.ToolPanelTabRightTabSlideOutDone(Sender: TObject; Index: Integer;
  APanel: TAdvToolPanel);
begin
  fRollActive := False;
  fNotePadForm.Align := alClient;
  fNotePadForm.Update;
  if fNotePadForm.Grid.CanFocus then
    fNotePadForm.Grid.SetFocus;
end;

procedure TMain.ToolPanelTreeResize(Sender: TObject);
var
  aPanel: TAdvToolPanel;
  aSplitter: TAdvSplitter;
begin
  if not Assigned(Sender) then
    Exit;

  aPanel := (Sender as TAdvToolPanel);
  if aPanel = ToolPanelTree then
    aSplitter := SplitterLeft
  else
    if aPanel = ToolPanelNotepad then
      aSplitter := SplitterRight
    else
      Exit;

  if not aPanel.Locked and aSplitter.Visible then
    aSplitter.Hide
  else
    if aPanel.Locked and not aSplitter.Visible then
      PostMessage(Handle, MESSAGE_AFTER_TOOLPANEL_RESIZE, WPARAM(Pointer(Sender)), 0);
  autopanel.visible := not autopanel.visible ;
  autopanel.visible := not autopanel.visible ;

end;

procedure TMain.AllPost;
var sFilter:string;
    rNo:integer;
    bFilter:boolean;
begin
  //Отметить все
   with Data.WaitListTable do
   begin
    DisableControls;
    if Filtered then
        sFilter := Filter
    else
        sFilter := '';
    bFilter := Filtered;
    rNo := RecNo;
    Filtered := FALSE;
    First;
    while not EOF do
      begin
        if FieldByName('POST').AsString <> '1' then
           begin
             Edit;
             FieldByName('POST').Value := 1;
             Post;
           end;
       Next;
      end;

      Filtered := bFilter;
      RecNo := rNo;
      EnableControls;
   end;

   with Data.AssortmentExpansion do
   begin
    DisableControls;
    if Filtered then
        sFilter := Filter
    else
        sFilter := '';

    rNo := RecNo;
    Filtered := bFilter;  //???
    First;
    while not EOF do
      begin
       if FieldByName('POST').AsString <> '1' then
           begin
             Edit;
             FieldByName('POST').Value := 1;
             Post;
           end;
       Next;
      end;

      Filtered := bFilter;
      RecNo := rNo;
      EnableControls;
   end;
end;


procedure TMain.WaitListOrderMove;
var
  Select_Cli, Cut_Cli : string;
begin
  if (Data.OrderTable.FieldByName('Sent').AsString <> '')and(Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
  begin
    if MessageDlg('Добавление в выбранный заказ невозможно !!! Заказ уже был отправлен в офис компании и вероятно уже обработан. Для проверки зарезервированного товара нажмите кнопку "TCP ответ". Создать новую корзину ?',mtInformation ,[mbYes,mbNo], 0) = mrNo  then
      exit;
    if not NewOrder then
      exit;
  end;

  if data.OOTable.Locate('Cat_id', data.WaitListTable.FieldByName('Cat_id').asInteger, []) then
  begin
   TOrderOnlyInfoForm.Execute(
      Data.WaitListDataSource.DataSet.FieldByName('ArtCode').AsString,
      Data.WaitListDataSource.DataSet.FieldByName('BrandRepl').Asstring,
      Data.WaitListDataSource.DataSet.FieldByName('ArtNameDescr').AsString
    );
    Exit;
  end
  else
  begin
    if (Data.WaitListTable.FieldByName('Code2').AsString = '') then
      exit;

    if ((Data.WaitListTable.FieldByName('ArtQuant').AsString = '') or
        (Data.WaitListTable.FieldByName('ArtQuant').AsString = '0')) and
        (MessageDlg('Нет в наличии у Шате-М+! Продолжить? ', mtWarning, [mbYes, mbNo], 0) <> mrYes) then
      exit;
    if Data.OrderTable.FieldByName('Order_id').AsInteger = 0 then
      if not NewOrder then
        Exit;
//---------------------
    select_cli := data.OrderTable.FieldByName('Cli_id').asString;
    cut_cli := data.WaitListTable.FieldByName('Cli_id').asString;
    if select_cli <> cut_cli then
    begin
      if (MessageDlg('Несовпадение клиентов!'#13#10'Переместить позицию в заказ №'+
          data.ordertable.FieldByName('num').asString + ' для клиента ' +
          data.ordertable.FieldByName('clientInfo').asString + '?', mtWarning, [mbYes, mbNo], 0) <> mrYes) then
        exit;
    end;
//---------------------
    with TQuantityEdit.Create(Application) do
    begin
      Init(-1, '', False, '', '');
      Caption := 'Количество товара в заказе';
      ArtInfo.Text := Data.WaitListTable.FieldByName('ArtCode').Asstring + '  ' + Data.WaitListTable.FieldByName('Brand').Asstring + #13#10 +
                      Data.WaitListTable.FieldByName('ArtNameDescr').Asstring;
      QuantityEd.Value := Data.WaitListTable.FieldByName('Quantity').AsFloat;
      InfoEd.Text := Data.WaitListTable.FieldByName('Info').Asstring;
      if ShowModal = mrOk then
      begin
        with Data.OrderDetTable do
        begin
          Append;
          FieldByName('Order_id').Value :=
               Data.OrderTable.FieldByName('Order_id').AsInteger;
          FieldByName('Code2').Value :=
               Data.WaitListTable.FieldByName('Code2').AsString;
          FieldByName('Brand').Value :=
               Data.WaitListTable.FieldByName('Brand').AsString;
          FieldByName('Price').Value := Data.WaitListTable.FieldByName('Price_koef_eur').AsCurrency;
          FieldByName('Quantity').Value := QuantityEd.Value;
          FieldByName('Info').Value := InfoEd.Text;
          Post;
        end;
        Data.OrderTable.Refresh;
        Data.OrderTableAfterScroll(Data.OrderTable);
        Data.WaitListTable.Delete;
        Data.CalcWaitList;
      end;
      Free;
    end;
  end;
  CountingOrderSum;
end;

procedure TMain.AllMoveToOrderFromAssortmentExpansionExecute(Sender: TObject);
var
  cnt: integer;
begin
   //Переместить все в азказ
  if Data.AssortmentExpansion.RecordCount = 0 then
  begin
    MessageDlg('Нет позиций для перемещения!', mtError, [mbOK], 0);
    exit;
  end;
  if MessageDlg('Переместить все позиции листа ожидания, имеющиеся в наличии у Шате-М+, в текущий заказ?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  //jklh;klh;klh;
  if (Data.OrderTable.FieldByName('Sent').AsString <> '')and(Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
  begin
     if MessageDlg('Добавление в выбранный заказ невозможно !!! Заказ уже был отправлен в офис компании и вероятно уже обработан. Для проверки зарезервированного товара нажмите кнопку "TCP ответ". Создать новую корзину ?',mtInformation ,[mbYes,mbNo], 0) = mrNo  then
         exit;
      if not NewOrder then
          exit;
  end;

  StartWait;
  if Data.OrderTable.FieldByName('Order_id').AsInteger = 0 then
    if not NewOrder then
          exit
  else
    if (Data.OrderTable.FieldByName('Sent').AsString <> '')and(Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
      if not NewOrder then
          exit;

  with Data.AssortmentExpansion do
  begin
    DisableControls;
    Filtered := False;
    First;
    cnt := 0;
    while not Eof do
    begin
      if (FieldByName('ArtQuant').AsString <> '') and
         (FieldByName('ArtQuant').AsString <> '0') and
         (FieldByName('Amount').AsFloat <> 0) then
      begin
        with Data.OrderDetTable do
        begin
          Append;
          FieldByName('Order_id').Value :=
               Data.OrderTable.FieldByName('Order_id').AsInteger;
          FieldByName('Code2').Value :=
               Data.AssortmentExpansion.FieldByName('Code2').AsString;
          FieldByName('Brand').Value :=
               Data.AssortmentExpansion.FieldByName('Brand').AsString;
          FieldByName('Price').Value := Data.AssortmentExpansion.FieldByName('Price_koef_eur').AsCurrency;

          //price_pro???
          CalcProfitPriceForOrdetDetCurrent;

          FieldByName('Quantity').Value :=
               Data.AssortmentExpansion.FieldByName('Amount').AsFloat;
          Post;
          Inc(cnt);
        end;
        Delete;
      end
      else
        Next;
    end;
    Filtered := True;
    First;
    EnableControls;
  end;
  Data.OrderTable.Refresh;
  Data.OrderTableAfterScroll(Data.OrderTable);
  StopWait;
  Data.CalcWaitList;
  MessageDlg('Перемещено: ' + IntToStr(cnt) + ' поз.', mtInformation, [mbOK], 0);

 
end;

procedure TMain.AllMoveToTrashExecute(Sender: TObject);
begin
  AllMoveToWaitListExecute(AllMoveToTrash);
end;


procedure TMain.AllMoveToWaitListExecute(Sender: TObject);

  procedure AddToWaitListFromOrderDet;
  begin
    with Data.WaitListTable do
      begin
        if not Locate('Code2;Brand',
          VarArrayOf([Data.OrderDetTable.FieldByName('Code2').AsString,
                      Data.OrderDetTable.FieldByName('Brand').AsString]), []) then
        begin
          Append;
          FieldByName('Code2').Value :=
             Data.OrderDetTable.FieldByName('Code2').AsString;
          FieldByName('Brand').Value :=
             Data.OrderDetTable.FieldByName('Brand').AsString;
          FieldByName('cli_id').Value :=
             Data.OrderDataSource.DataSet.FieldByName('cli_id').AsString;
        end
        else
          Edit;
        FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat +
                                         Data.OrderDetTable.FieldByName('Quantity').AsFloat;
        FieldByName('Info').Value := Data.OrderDetTable.FieldByName('Info').AsString;
        Post;
      end;
  end;

  var
    curr:TDate;
    customversion:string;
    Index:string;
begin
     //Переместить все без остаков в лист ожидания
     SetCurrentDir(Data.Data_Path);
     ClearTestQuants;
     curr := Now;
     if YearOf(curr) - 2000 < 10  then
        customversion := '0'+inttostr(YearOf(curr) - 2000)
     else
        customversion := inttostr(YearOf(curr) - 2000);

     if MonthOfTheYear(curr) < 10  then
        customversion := customversion+'0'+inttostr(MonthOfTheYear(curr))
     else
        customversion := customversion+inttostr(MonthOfTheYear(curr));

     if DayOfTheMonth(curr) < 10  then
        customversion := customversion+'0'+inttostr(DayOfTheMonth(curr))
     else
        customversion := customversion+inttostr(DayOfTheMonth(curr));

     customversion :=  customversion+'.1';

    if TestString(Data.VersionTable.FieldByName('QuantVersion').Value,customversion) then
       begin
        if MessageDlg('Версия остатков: '+Data.VersionTable.FieldByName('QuantVersion').AsString +
              '. Перед выполнением проверки рекомендуем обновить остатки! Прервать?', mtInformation ,[mbYes, mbNo],0) = IDYES then
        exit;
       end;

    with Data.OrderDetTable do
     begin
       DisableControls;
       Index := IndexName;
       IndexName := 'Order';
       Data.OrderDetTable.First;
       while not Data.OrderDetTable.EOF do
          begin
            if Data.BrandTable.Locate('Description', FieldByName('Brand').AsString, []) and
               Data.XCatTable.FindKey([FieldByName('Code2').AsString,
               Data.BrandTable.FieldByName('Brand_id').AsInteger]) then
               begin
                  if Data.QuantTable.Locate('Cat_id',Data.XCatTable.FieldByName('Cat_id').AsInteger, []) then
                    begin
                    if (Data.QuantTable.FieldByName('Quantity').AsString = '0')or(Data.QuantTable.FieldByName('Quantity').AsString = '') then
                        begin
                            if Sender <> AllMoveToTrash then //просто удаляем
                              AddToWaitListFromOrderDet;
                            Delete;
                        end
                        else
                        Next;
                    end
                    else
                    begin
                        if Sender <> AllMoveToTrash then //просто удаляем
                          AddToWaitListFromOrderDet;
                        Delete;
                    end;
               end
            else
              begin
                AddToWaitListFromOrderDet;
                Delete;
              end;

          end;
       IndexName := Index;
       EnableControls;
     end;
    Data.CalcWaitList;
end;

procedure TMain.AllWaitListOrderMove;
var
  cnt, Pos_old: integer;
  Select_Cli : string;
  fExt, fNotAll : boolean;
begin
  fExt := false;
  if Data.WaitListCnt = 0 then
  begin
    MessageDlg('Нет позиций для перемещения!', mtError, [mbOK], 0);
    exit;
  end;
  if MessageDlg('Переместить все позиции листа ожидания, имеющиеся в наличии у Шате-М+, в текущий заказ?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  //jklh;klh;klh;
  if (Data.OrderTable.FieldByName('Sent').AsString <> '')and(Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
  begin
     if MessageDlg('Добавление в выбранный заказ невозможно !!! Заказ уже был отправлен в офис компании и вероятно уже обработан. Для проверки зарезервированного товара нажмите кнопку "TCP ответ". Создать новую корзину ?',mtInformation ,[mbYes,mbNo], 0) = mrNo  then
         exit;
      if not NewOrder then
          exit;
  end;

  StartWait;
  if Data.OrderTable.FieldByName('Order_id').AsInteger = 0 then
    if not NewOrder then
    begin
        StopWait;
        exit;
    end
  else
    if (Data.OrderTable.FieldByName('Sent').AsString <> '')and(Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
      if not NewOrder then
         begin
           StopWait;
          exit;
         end;

  with Data.WaitListTable do
  begin
    DisableControls;
    Filtered := False;
    First;
    cnt := 0;

    fNotAll := false;
    pos_old := Data.OrderTable.RecNo;
    select_cli := data.OrderTable.FieldByName('Cli_id').asString;
  //----------------------------
    while not Eof do
    begin
      if select_cli  <> FieldByName('Cli_id').asString then
        fExt := true;
      Next;
    end;

    if fExt then
    begin
      case MessageDlg('Несовпадение клиентов!'#13#10'Да - перенести все позиции'#13#10'Нет - Перенести позиции только данного клиента'#13#10'Отмена - ничего не переносить', mtWarning, [mbYes, mbNo, mbCancel], 0) of
        mrYes:
          Data.OrderTable.RecNo := pos_old;

        mrNo:
          fNotAll := true;

        mrCancel:
          begin
            StopWait;
            EnableControls;
            exit;
          end;
      end;
    end
    else
      Data.OrderTable.RecNo := pos_old;

  //----------------------------
    First;
    while not Eof do
    begin
      if (( fNotAll and (Data.OrderTable.FieldByName('Cli_id').AsString =
                     Data.WaitListTable.FieldByName('Cli_id').AsString) ) or not fNotAll) then
      begin
        if (FieldByName('ArtQuant').AsString <> '') and
           (FieldByName('ArtQuant').AsString <> '0') and
           (FieldByName('Quantity').AsFloat <> 0) then
        begin
          with Data.OrderDetTable do
          begin
            Append;
            FieldByName('Order_id').Value :=
                 Data.OrderTable.FieldByName('Order_id').AsInteger;
            FieldByName('Code2').Value :=
                 Data.WaitListTable.FieldByName('Code2').AsString;
            FieldByName('Brand').Value :=
                 Data.WaitListTable.FieldByName('Brand').AsString;
            FieldByName('Price').Value := Data.WaitListTable.FieldByName('Price_koef_eur').AsCurrency;

            //price_pro???
            CalcProfitPriceForOrdetDetCurrent;

            FieldByName('Quantity').Value :=
                 Data.WaitListTable.FieldByName('Quantity').AsFloat;
            FieldByName('Info').Value := Data.WaitListTable.FieldByName('Info').Asstring;
            Post;
            Inc(cnt);
          end;
          Delete;
        end
        else
          Next;
      end
    else
      Next;
    end;

    Filtered := True;
    First;
    EnableControls;
  end;
  Data.OrderTable.Refresh;
  Data.OrderTableAfterScroll(Data.OrderTable);
  StopWait;
  Data.CalcWaitList;
  MessageDlg('Перемещено: ' + IntToStr(cnt) + ' поз.', mtInformation, [mbOK], 0);
  CountingOrderSum;
end;


procedure TMain.WaitListViewComboBoxChange(Sender: TObject);
begin
  with Data.WaitListTable do
  begin
    Filtered := True;
    Refresh;
  end;
end;

procedure TMain.WaitListViewComboBoxCloseUp(Sender: TObject);
begin
  if WaitListGrid.CanFocus then
    WaitListGrid.SetFocus;
end;

procedure TMain.Web1Click(Sender: TObject);
begin
  WebSearchOE(fURL_OE);
end;

procedure TMain.WebSearchActionExecute(Sender: TObject);
begin
  if Length(SearchEd.Text) > 0 then
  begin
    WebSearchOE(SearchEd.Text);
    exit;
  end
  else
  if Length(FiltEd.Text) > 0 then
  begin
    WebSearchOE(FiltEd.Text);
    exit;
  end;
  ShellExecute(Handle, nil, PAnsiChar('http://b2b.shate-m.com'), nil, nil, SW_SHOW);
end;

procedure TMain.WebSearchOE(OE: string);
begin
  if (Length(OE)<1) then
    exit;
  ShellExecute(Handle, nil, PAnsiChar('http://b2b.shate-m.com/Search/No?criteria=' + OE), nil, nil, SW_SHOW);
end;

procedure TMain.WebUpdateExtActionExecute(Sender: TObject);
begin
  DoWebUpdate(True);
end;

procedure TMain.PopupItemClick(Sender: TObject);
begin
  if EditPopupMenu.PopupComponent = SearchEd then
  begin
    if Sender = CopyPopupItem then
      SearchEd.CopyToClipboard
    else if Sender = CutPopupItem then
      SearchEd.CutToClipboard
    else if Sender = PastePopupItem then
      SearchEd.PasteFromClipboard;
  end
  else if EditPopupMenu.PopupComponent = FiltEd then
  begin
    if Sender = CopyPopupItem then
      FiltEd.CopyToClipboard
    else if Sender = CutPopupItem then
      FiltEd.CutToClipboard
    else if Sender = PastePopupItem then
      FiltEd.PasteFromClipboard;
  end
end;

procedure TMain.EditPopupMenuPopup(Sender: TObject);
begin
  PastePopupItem.Visible := Clipboard.AsText <> '';
  if EditPopupMenu.PopupComponent = SearchEd then
  begin
    CopyPopupItem.Enabled := SearchEd.SelLength > 0;
    CutPopupItem.Enabled := SearchEd.SelLength > 0;
  end
  else if EditPopupMenu.PopupComponent = FiltEd then
  begin
    CopyPopupItem.Enabled := FiltEd.SelLength > 0;
    CutPopupItem.Enabled := FiltEd.SelLength > 0;
  end;
end;

procedure TMain.EditReturnDocActionExecute(Sender: TObject);
var DataDoc:TDate;
    Num: integer;
    DocType,Contract, Note, AgrDescription, Client, FIO, Mobile, aFakeAddresDescr, aAgrGroup: string;
    fGoodClose: boolean;
begin
  if  '' = Data.ReturnDocTable.FieldByName('Retdoc_id').AsString then
      if not NewReturnDoc then
        exit;

  with TReturnDocED.Create(nil) do
  begin
    Data.ContractsCliTable.Filtered := False;
    Data.ContractsCliTable.CancelRange;

   { if Data.ClIDsTable.Locate('client_id', Data.ReturnDocTable.FieldByName('cli_id').AsString, []) then
      Cli_id := Data.ClIDsTable.FieldByName('client_id').AsInteger;       }

    Data.ClIDsTable.Refresh;
    Data.ReturnDocTable.Refresh;

    if Data.ReturnDocTable.FieldByName('Agreement_No').AsString <> '' then
    begin
      Data.ReturnDocTable.Edit;

      if Data.ContractsCliTable.Locate('Contract_id;cli_id',
         VarArrayOf([Data.ReturnDocTable.FieldByName('Agreement_No').AsString,
                     Data.ReturnDocTable.FieldByName('cli_id').AsString]),[]) then
      begin
        if Data.ReturnDocTable.FieldByName('AgrDescr').AsString <> GetMaskEdDir then
          Data.ReturnDocTable.FieldByName('AgrDescr').AsString := GetMaskEdDir
      end
      else
        Data.ReturnDocTable.FieldByName('AgrDescr').AsString := Main.AgrNotFound(Data.ReturnDocTable.FieldByName('AgrDescr').AsString);

      Data.ReturnDocTable.Post;
    end

    else
    if Data.ContractsCliTable.Locate('Cli_id;Contract_Id',
       VarArrayOf([Data.ReturnDocTable.FieldByName('cli_id').AsString,
                   Data.ClIDsTable.FieldByName('ContractByDefault').AsString]), []) then
    begin
      Data.ReturnDocTable.Edit;
      Data.ReturnDocTable.FieldByName('Agreement_No').AsString := Data.ContractsCliTable.FieldByName('Contract_Id').AsString;
      Data.ReturnDocTable.FieldByName('AgrDescr').AsString := Main.GetMaskEdDir;
      Data.ReturnDocTable.FieldByName('AgrGroup').AsString := Data.ContractsCliTable.FieldByName('Group').AsString;
      Data.ReturnDocTable.Post;
    end;

    with Data.ReturnDocTable do
    begin
      Contract := FieldByName('Agreement_No').AsString;
      DataDoc := FieldByName('Data').Value;
      Num := FieldByName('Num').AsInteger;
      DocType := FieldByName('Type').AsString;
      Client := FieldByName('Cli_id').AsString;
      Note := FieldByName('Note').AsString;
      AgrDescription := FieldByName('AgrDescr').AsString;
      FIO := FieldByName('Name').AsString;
      Mobile := TrimAll(FieldByName('Phone').AsString);
      aFakeAddresDescr := FieldByName('FakeAddresDescr').AsString;
      aAgrGroup := FieldByName('AgrGroup').AsString;

    end;

 {   if ShowModal <> mrOk then
    begin
      with Data.ReturnDocTable do
      begin
        Edit;
        FieldByName('Agreement_No').AsString := Contract;
        FieldByName('Data').Value := DataDoc;
        FieldByName('Num').Value := Num;
        FieldByName('Type').Value := DocType;
        FieldByName('Cli_id').Value := Client;
        FieldByName('Note').Value := Note;
        FieldByName('AgrDescr').AsString := AgrDescription;
        Post;
      end;
    end; //end with Data.ReturnDocTable
    }
    VisibleClientCombo(SameText(Data.ReturnDocTable.FieldByName('AgrGroup').AsString,'БН') or SameText(Data.ReturnDocTable.FieldByName('AgrGroup').AsString,''));

    repeat
      ShowModal;
      fGoodClose := FALSE;
      if ModalResult <> mrOk then
      begin
          Data.ReturnDocTable.Edit;
          Data.ReturnDocTable.FieldByName('Agreement_No').AsString := Contract;
          Data.ReturnDocTable.FieldByName('Data').Value := DataDoc;
          Data.ReturnDocTable.FieldByName('Num').Value := Num;
          Data.ReturnDocTable.FieldByName('Type').Value := DocType;
          Data.ReturnDocTable.FieldByName('Cli_id').Value := Client;
          Data.ReturnDocTable.FieldByName('Note').Value := Note;
          Data.ReturnDocTable.FieldByName('AgrDescr').AsString := AgrDescription;
          Data.ReturnDocTable.FieldByName('Name').AsString := FIO;
          Data.ReturnDocTable.FieldByName('Phone').AsString := Mobile;
          Data.ReturnDocTable.FieldByName('FakeAddresDescr').AsString := aFakeAddresDescr;
          Data.ReturnDocTable.FieldByName('AgrGroup').AsString := aAgrGroup; 
          Data.ReturnDocTable.Post;
      end
      else
      begin
      {if (Data.ReturnDocTable.FieldByName('fDefect').AsBoolean) and
          (length(Data.ReturnDocTable.FieldByName('Note').AsString) < 1) then
        begin
           MessageDlg('Поле "Описание неисправности" не заполнено.Возврат не будет сохранен!', mtError, [mbYes], 0);
           fGoodClose := TRUE;
        end;

        if length(Data.ReturnDocTable.FieldByName('AgrDescr').AsString) < 1 then
        begin
           MessageDlg('Поле "Контрагент" не заполнено.Возврат не будет сохранен!', mtError, [mbYes], 0);
           fGoodClose := TRUE;
        end;}
        if (length(Data.ReturnDocTable.FieldByName('AgrDescr').AsString) < 1)
            or ((FakeAddresDescr.Visible) and (Length(Data.ReturnDocTable.FieldByName('FakeAddresDescr').AsString)< 1))
            or ((Phone.Visible) and (Length(TrimAll(Phone.Text)) < MIN_LENGTH_PHONE))
            or ((Name.Visible) and (Length(Data.ReturnDocTable.FieldByName('Name').AsString)< MIN_LENGTH_NAME))
            or ((Data.ReturnDocTable.FieldByName('fDefect').AsBoolean) and (length(Data.ReturnDocTable.FieldByName('Note').AsString) < 1))  then
        begin
          MessageDlg('Заполните все обязательные поля, иначе заказ не будет сохранен! ФИО и телефон должны соответствовать формату!', mtError, [mbYes], 0);
          fGoodClose := TRUE;
        end
        else
          TrimField(Data.ReturnDocTable, 'Phone');
      end;
    until not fGoodClose;

  end; //end with TForm
  Data.ReturnDocTable.Refresh;
end;

procedure TMain.EditReturnDocPosExecute(Sender: TObject);
var iPos:integer;
begin
    //EditReturnDocPos
      if Data.ReturnDocDetTable.FieldByName('ID').AsString < '1' then
  begin
     exit;
  end;

  iPos := Data.ReturnDocDetTable.RecNo;
  with TReturnDocPos.Create(Application) do
  begin
    Caption := 'Количество товара в возврате';
    ArtInfo.Text := Data.ReturnDocDetTable.FieldByName('Code').Asstring + '  ' + 
                    Data.ReturnDocDetTable.FieldByName('Description').Asstring;
    InfoEd.Text := Data.ReturnDocDetTable.FieldByName('Note').Asstring;
    QuantityEd.Value := Data.ReturnDocDetTable.FieldByName('Quantity').AsInteger;
    if ShowModal = mrOk then
    begin
      with Data.ReturnDocDetTable do
      begin
        Edit;
        FieldByName('Quantity').Value := QuantityEd.Value;
        FieldByName('Note').Value := InfoEd.Text;
        Post;
      end;
    end;
    Free;
  end;
  Data.ReturnDocDetTable.RecNo := iPos;
end;

//========== Стандартный отработчик ошибок =========================
procedure StdErr(Sender: TObject; E: Exception);
var
  ErrFile: TextFile;
  ErrText: string;
begin
  if (E is EDatabaseError) and (E is EDBISAMEngineError) then
  begin
    if (EDBISAMEngineError(E).ErrorCode=DBISAM_RECLOCKFAILED) then
    begin
      MessageDlg('Запись заблокирована другим пользователем. Таблица: ' + EDBISAMEngineError(E).ErrorTableName , mtWarning, [mbOK], 0);
      exit
    end
    else if (EDBISAMEngineError(E).ErrorCode=DBISAM_KEYORRECDELETED) then
    begin
      MessageDlg('Запись удалена другим пользователем. Таблица: ' + EDBISAMEngineError(E).ErrorTableName, mtWarning, [mbOK], 0);
      if (Sender is TDBGridEh) then
        (Sender as TDBGridEh).DataSource.DataSet.Refresh;
      exit
    end
  end;

  if (E is EDBEditError) then
  begin
    try
      (Sender as TMaskEdit).clear;
    except

    end;
    exit;
  end;

  ErrText := E.Message;
  AssignFile(ErrFile,GetAppDir + '!!!.err');
  if FileExists(GetAppDir + '!!!.err') then
    Append(ErrFile)
  else
    ReWrite(ErrFile);
  Writeln(ErrFile,DateTimeToStr(Now) + ' -> ' + ErrText);
  CloseFile(ErrFile);

  //Application.ShowException(E);
  //Application.Terminate;
  with TErrorMess.Create(Application) do
  try
    Memo.Text := E.Message;
    if ShowModal = mrAbort then
    begin
      Application.Terminate;
      Halt(1);
    end;
  finally
    Free;
  end;
end;

procedure TMain.ShowPopupRss;
begin
  if Assigned(fPopupRss) then
  begin
    fPopupRss.Browser.Navigate(GetAppDir + 'Rss.tmp');
    fPopupRss.Show;
    BringToFrontRss;
    //SetWindowPos(fPopupRss.Handle, Self.Handle{HWND_TOPMOST}, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  end
  else
  begin
 //  if (isOpenedMoreThan2Windows('Info')) then
 //     exit;
    fPopupRss := TInfo.Create(Self);
    fPopupRss.JvFormStorage1.Active := False;
    fPopupRss.Caption := 'Последние новости компании';
    fPopupRss.Browser.Navigate(GetAppDir + 'Rss.tmp');
    fPopupRss.HideCheckBox.Visible := False;
    fPopupRss.Width := 550;
    fPopupRss.Height := 600;
    fPopupRss.Show;
    BringToFrontRss;
    //SetWindowPos(fPopupRss.Handle, Self.Handle{HWND_TOPMOST}, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  end;
end;

procedure TMain.ShowProgress(s: string = ''; m: integer = 100);
begin
  StatusBar.Panels[3].Style              := psProgress;
  StatusBar.Panels[3].Progress.Position  := 0;
  Main.StatusBar.Panels[3].Progress.Max  := m;
  Main.StatusBar.Panels[4].Text          := '  ' + s;
  Application.ProcessMessages;
end;

procedure TMain.HideBrandGroupClick(Sender: TObject);
begin
 {
  HideBrandGroup.Checked := Data.ParamTable.FieldByName('HideBrand').AsBoolean;
  HideName.Checked := Data.ParamTable.FieldByName('HideName').AsBoolean;
  HideOE.Checked := Data.ParamTable.FieldByName('HideOE').AsBoolean;
  }
  with Data.ParamTable do
  begin
    Edit;
    FieldByName('HideBrand').AsBoolean := HideBrandGroup.Checked;
    Post;
  end;
  ViewNameLoad;
end;

procedure TMain.HideNameClick(Sender: TObject);
begin
  {
  HideBrandGroup.Checked := Data.ParamTable.FieldByName('HideBrand').AsBoolean;
  HideName.Checked := Data.ParamTable.FieldByName('HideName').AsBoolean;
  HideOE.Checked := Data.ParamTable.FieldByName('HideOE').AsBoolean;
  }
  with Data.ParamTable do
  begin
    Edit;
    FieldByName('HideName').AsBoolean := HideName.Checked;
    Post;
  end;
  ViewNameLoad;
end;

procedure TMain.HideOEClick(Sender: TObject);
begin
  with Data.ParamTable do
  begin
    Edit;
    FieldByName('HideOE').AsBoolean := HideOE.Checked;
    Post;
  end;
  ViewNameLoad;
end;

procedure TMain.HideProgress;
begin
  Main.StatusBar.Panels[3].Style := psHTML;
  Main.StatusBar.Panels[4].Text := '';
  Application.ProcessMessages;
end;


procedure TMain.HideTreeClick(Sender: TObject);
begin
//!!! переписать скрытие дерева на UnLock тулпанели !!!
{
    with Data.ParamTable do
    begin
      Edit;
      FieldByName('HideTree').AsBoolean := HideTree.Checked;
      Post;
    end;
    TreePanel.Visible := not Data.ParamTable.FieldByName('HideTree').AsBoolean;
  UpdateToolBarsMenuChecked;
}
end;

procedure TMain.CurrProgress(p: integer);
begin
  Main.StatusBar.Panels[3].Progress.Position := p;

  if {(not Main.Showing) and }(Assigned(Splash) and Splash.Showing) then
  begin
    if p = Splash.Progress.MaxValue then
      Splash.Progress.Visible := False
    else
    begin
      Splash.Progress.Visible := True;
      Splash.Progress.Progress := p;
    end;
  end;

  Application.ProcessMessages;
end;

procedure TMain.SetProgressMax(m: integer);
begin
  Main.StatusBar.Panels[3].Progress.Max := m;
  if {(not Main.Showing) and }(Assigned(Splash) and Splash.Showing) then
  begin
    Splash.Progress.MaxValue := m;
  end;
end;

procedure TMain.ShowProgrInfo(s: string);
begin
  Main.StatusBar.Panels[4].Text := s;
  if {(not Main.Showing) and }(Assigned(Splash) and Splash.Showing) then
  begin
    if s = '' then
      Splash.InfoLabel.Caption := 'Загрузка...'
    else
      Splash.InfoLabel.Caption := s;
  end;
  Application.ProcessMessages;
end;

procedure TMain.ShiftMainMenu;
var
  mii: TMenuItemInfo;
  MainMenu: HMENU;
  Buffer: array[0..79] of Char;
begin
  MainMenu := Self.Menu.Handle;
  // GET Help Menu Item Info
  mii.cbSize := SizeOf( mii );
  mii.fMask := MIIM_TYPE;
  mii.dwTypeData := Buffer;
  mii.cch := SizeOf( Buffer );
  GetMenuItemInfo( MainMenu, LightRates.Command {выравниваемый пункт верхнего уровня}, False, mii );
  // SET Help Menu Item Info
  mii.fType := mii.fType or MFT_RIGHTJUSTIFY;
  SetMenuItemInfo( MainMenu, LightRates.Command {выравниваемый пункт верхнего уровня}, False, mii );
end;


procedure TMain.ShowAuto;
begin
  if Data.Auto_type <> 0 then
  begin
    if Data.TypesTable.Locate('Typ_id', Data.Auto_type, []) then
    begin
      Data.ModelsTable.Locate('Mod_id', Data.TypesTable.FieldByName('Mod_id').AsInteger, []);
      Data.ManufacturersTable.Locate('Mfa_id', Data.ModelsTable.FieldByName('Mfa_id').AsInteger, []);
      with AutoPanel do
      begin
        Visible := True;
        MfaModTypLabel.Caption := Data.ManufacturersTable.FieldByName('Mfa_brand').AsString + ' ' +
                               Data.ModelsTable.FieldByName('Tex_text').AsString + ' ' +
                               Data.TypesTable.FieldByName('CdsText').AsString;
        PconLabel.Caption := Data.TypesTable.FieldByName('PconText1').AsString + '-' +
                             Data.TypesTable.FieldByName('PconText2').AsString;
        HpLabel.Caption   := Data.TypesTable.FieldByName('Hp_from').AsString + ' л.с.';
        FuelLabel.Caption := Data.TypesTable.FieldByName('FuelText').AsString;
        CylLabel.Caption  := Data.TypesTable.FieldByName('Cylinders').AsString + ' цил.';
      end;
    end;
  end;
end;

procedure TMain.AutoPanelClose(Sender: TObject);
begin
  StartWait;
  bAbort := TRUE;
  Application.ProcessMessages;
  Data.sAuto := '';
  Data.Auto_type := 0;
  AutoPanel.Hide;
  ParamTypGrid.Datasource := nil;
  Data.SetCatFilter;
  StopWait;
end;

procedure TMain.AutoPanelDblClick(Sender: TObject);
begin
  with TAutoInfo.Create(Application) do
  begin
    Auto_type := Data.Auto_type;
    ShowModal;
    Free;
  end;
end;


procedure TMain.BallonLinkClick(aLinkId: Integer);
begin
  if aLinkId = Ord(netRss) then
  begin
    ShowPopupRss;
  end;
end;

procedure TMain.BringToFrontRss;
begin
//  fPopupRss.BringToFront;
  SetWindowPos(fPopupRss.Handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
end;

procedure TMain.LightRatesAdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; State: TOwnerDrawState);
begin
  DrawLights(State, ACanvas, ARect, 'Цены', fFlagsUpdateByLight.bNeedUpdateRates);
end;

procedure TMain.LightRatesClick(Sender: TObject);
begin
  UpdateRatesByLight();
end;

procedure TMain.LoadAutoHist;
var
  i: integer;
  it: TMenuItem;
begin
  with Data.AutoHistTable do
  begin
    Open;
    IndexName := 'DescId';
    First;
    i := 0;
    AutoHistPopupMenu.Items.Clear;
    while (not Eof) and (i < 10) do
    begin
      it := TMenuItem.Create(nil);
      it.Caption := FieldByName('TypMmtText').AsString;
      it.Tag := FieldByName('Typ_id').AsInteger;
      it.OnClick := AutoHistItemClick;
      AutoHistPopupMenu.Items.Add(it);
      Inc(i);
      Next;
    end;
    Close;
  end;
end;

procedure TMain.LoadCatalogLotusExecute(Sender: TObject);
begin
  //adminmode
//  exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

 if OpenDialogCSV.Execute() = false then
    exit;
      SetCurrentDir(Data.Data_Path);
   if FileExists(OpenDialogCSV.FileName) then
   begin
      Data.LoadLotusCatalog(OpenDialogCSV.FileName);
   end;
end;

procedure TMain.LoadDescriptionExecute(Sender: TObject);
begin
   Data.LoadDescriptionBath;
end;

function TMain.CheckPrivateKey(const aKey: string): Boolean;
begin
  Result := Length(aKey) = 20;
end;


procedure TMain.ApplyDiscounts2DB(aSourceData: TStream; const aClientID: string;
  aDiscountVersion: Integer; aUpdateVersion: Boolean;
  anOtherTable: TDBISAMTable);
var
//  s: string;
  aDiscountsTable: TDBISamTable;
  aTableName: string;
  MemoFile: TStringList;
  sFilter: string;
  gr, subgr, br, dis: string;
  iStr, OptRF, FIX: Integer;
  DiscountsQuery: TDBISAMQuery;
{  aVer: Integer;
  pub_key: string;
  aStream: TMemoryStream;
  Stream: TStringStream;
  iNewVersion: Integer;
  iLine: Integer;
  }

begin
  //поддержка возможности загружать скидки во временную таблицу
  if anOtherTable <> nil then
    aDiscountsTable := anOtherTable
  else
    aDiscountsTable := Data.DiscountTable;

  if SameText(aDiscountsTable.DatabaseName, 'MEMORY') then
    aTableName := '"MEMORY\' + aDiscountsTable.TableName + '"'
  else
    aTableName := '[' + aDiscountsTable.TableName + ']';
  //-----------------------------------------------------------
  DiscountsQuery := TDBISAMQuery.Create(nil);
  DiscountsQuery.DatabaseName := Data.Database.DatabaseName;

  DiscountsQuery.SQL.Clear;
  DiscountsQuery.SQL.Add('UPDATE ' + aTableName + ' SET bDelete = 1 WHERE CLI_ID = '''+aClientID+'''');
  DiscountsQuery.ExecSQL;
  DiscountsQuery.Close;



  MemoFile := TStringList.Create;
  aSourceData.Position := 0;
  MemoFile.LoadFromStream(aSourceData);

  with aDiscountsTable do
  begin
    if not Active then
      Open;
    DisableControls;
    try
      if IndexName <> 'CLI' then
        IndexName := 'CLI';
      sFilter := aClientID;
      SetRange([sFilter], [sFilter]);
    finally
      EnableControls;
    end;

    for iStr := 0 to MemoFile.Count - 1 do
    begin
      gr := ExtractDelimited(1,  MemoFile[iStr], [';']);
      subgr  := ExtractDelimited(2, MemoFile[iStr], [';']);
      br     := ExtractDelimited(3, MemoFile[iStr], [';']);
      dis    := ExtractDelimited(4, MemoFile[iStr], [';']);
      OptRF  := StrToIntDef(ExtractDelimited(5, MemoFile[iStr], [';']), 0);
      FIX    := StrToIntDef(ExtractDelimited(6, MemoFile[iStr], [';']), 0);
      if (gr <> '') and (subgr <> '') and (br <> '') and (dis <> '') then
      begin
        sFilter := 'GR_ID = '+gr+' AND SUBGR_ID = '+subgr+ ' AND BRAND_ID = '+br +
                   ' AND FIX = ' + IntTOStr(FIX) + ' AND PRICESGROUP = ' + IntTOStr(OptRF);

        Filter := sFilter;
        Filtered := TRUE;
        if EOF then
        begin
          Append;
          FieldByName('CLI_ID').AsString := aClientID;
          FieldByName('GR_ID').AsInteger := strtoint(gr);
          FieldByName('SUBGR_ID').AsInteger := strtoint(subgr);
          FieldByName('BRAND_ID').AsInteger := strtoint(br);
          FieldByName('Discount').AsFloat := AtoFloat(dis);
          FieldByName('PricesGroup').AsInteger := OptRF;
          FieldByName('FIX').AsInteger := FIX;
          FieldByName('Margin').AsFloat := 0;
          FieldByName('bDelete').AsInteger := 0;
          Post;
        end
        else
        begin
          Edit;
          FieldByName('Discount').AsFloat := AtoFloat(dis);
          FieldByName('bDelete').AsInteger := 0;
          FieldByName('PricesGroup').AsFloat := OptRF;
          FieldByName('FIX').AsInteger := FIX;
          Post;
        end;
      end;
    end;
  end;

  MemoFile.Free;
  DiscountsQuery.SQL.Clear;
  DiscountsQuery.SQL.Add('DELETE from ' + aTableName + ' WHERE (Margin = 0 OR Margin IS NULL) AND bDelete = 1');
  DiscountsQuery.ExecSQL;
  DiscountsQuery.Close;

  DiscountsQuery.SQL.Clear;
  DiscountsQuery.SQL.Add('UPDATE ' + aTableName + ' SET Discount = NULL WHERE bDelete = 1 AND CLI_ID = '''+aClientID+'''');
  DiscountsQuery.ExecSQL;
  DiscountsQuery.Close;

  DiscountsQuery.SQL.Clear;
  DiscountsQuery.SQL.Add('UPDATE ' + aTableName + ' SET bDelete = 0 WHERE bDelete = 1 AND CLI_ID = '''+aClientID+'''');
  DiscountsQuery.ExecSQL;
  DiscountsQuery.Close;

  //обновляем версию
  {if aUpdateVersion then
  begin
    Table.Open;
    if Table.Locate('CLIENT_ID', aClientID, []) then
    begin
      Table.Edit;
      Table.FieldByName('DiscountVersion').AsInteger := aDiscountVersion;
      Table.Post;
    end;
    Table.Close;
  end;                }
  DiscountsQuery.Free;
end;


{Result: 0 - ошибка, 1 - ОК, 2 - версия не изменилась}
function TMain.LoadDescriptionsTCP(sID, sKey, sVersion: string; out aDiscountVersion: Integer;
  aUpdateVersion: Boolean = True; anOtherTable: TDBISAMTable = nil): Integer;
var
  s: string;
  pub_key: string;
  aStream: TMemoryStream;
  Stream: TStringStream;
  iNewVersion: Integer;
  iLine: Integer;
  user :TUserIDRecord;
begin
  Result := 0;
  User := GetCurrentUser;

  {$IFDEF LOCAL}
  LoadDescriptionsTCP_Local(User);
  Exit;
  {$ENDIF}

  //не посылаем запрос на сервер если ключ не задан или неверен
  if not CheckPrivateKey(sKey) then
    Exit;

  iNewVersion := 0;
  aDiscountVersion := 0;
  DeleteFile(Data.Import_Path + 'D.zip');
  try
    if not DoTcpConnect(TCPClient, True, True) then
      Exit;
      
    pub_key := MD5.MD5DigestToStr(MD5.MD5String(sID + sKey) );
    TCPClient.IOHandler.Writeln(Format('DISC_%s_%s_%s', [sID, pub_key, sVersion]));
    iLine := 0;
    repeat
      s := TCPClient.IOHandler.ReadLnWait;
      Inc(iLine);

      if StrLeft(s,8) = 'VERSION=' then
      begin
        s := StrRight(s,length(s)-8);
        iNewVersion := strtoint(s);
      end;

      if s = 'BINFILE' then
      begin
        aStream := TMemoryStream.Create;
        try
          TCPClient.IOHandler.ReadStream(aStream, -1, False);
          aStream.SaveToFile(Data.Import_Path + 'D.zip');
        finally
          aStream.Free;
        end;
      end;
    until s = 'END';
  
  except
   on e: Exception do
     begin
      MessageDlg('Ошибка: ' + e.Message, mtError,[mbOK],0);
      TCPClient.Disconnect;
      Exit;
     end;
  end;

  if (iLine = 1) and (iNewVersion = 0) then
  begin
    Result := 2;
    aDiscountVersion := StrToIntDef(sVersion, 0);
    Exit;
  end;

  if Length(sVersion) < 1 then
    Exit;

  if not FileExists(Data.Import_Path + 'D.zip') then
    Exit;

  UnZipper.ZipName  := Data.Import_Path + 'D.zip';
  UnZipper.Password := sKey;
  UnZipper.ReadZip;
  Stream := TStringStream.Create('');
  try
    if Main.UnZipper.UnZipToStream(Stream, 'discounts') < 1 then
    begin
      Stream.Free;
      Exit;
    end;

    ApplyDiscounts2DB(Stream, sID, iNewVersion, aUpdateVersion, anOtherTable);
    aDiscountVersion := iNewVersion;
  finally
    Stream.Free;
  end;

  Result := 1;
end;

{Result: 0 - ошибка, 1 - ОК, 2 - версия не изменилась}
procedure TMain.LoadDescriptionsTCP_Local(aUser: TUserIDRecord);
var
  ResFuncDir: string;
  pub_key: string;
  Stream: TStringStream;
  StreamAdr, StreamAgr: TMemoryStream;
  iNewVersion, iNewVersionAdr,iNewVersionAgr: Integer;
  i: Integer;
  UpdFlag: Boolean;
begin
{$IFDEF LOCAL}
  UpdFlag := False;
  StreamAdr := TMemoryStream.Create;
  StreamAgr := TMemoryStream.Create;
  ResFuncDir := MSGetDiscounts(aUser.sID, aUser.DiscVersion,aUser.AddresVersion,aUser.AgrVersion,
                           {out}iNewVersion,iNewVersionAdr,iNewVersionAgr,
                           {out}pub_key, Data.Import_Path + 'D.zip', StreamAdr ,StreamAgr);
  if ResFuncDir = '' then
    Exit;

  try
    for i := 1 to length(ResFuncDir) do
    begin
      if ResFuncDir[i] = '1' then
      begin
        if StreamAdr.Size > 0 then
        begin
          Main.UnzipStream2File(StreamAdr, Data.Import_Path + '1.csv', 'address', pub_key);
          Main.NewImportNav(Data.Import_Path + '1.csv', 'Address',aUser);
          if Data.ClIDsTable.Locate('Client_id',aUser.sId,[]) then
          begin
            Data.ClIDsTable.Edit;
            Data.ClIDsTable.FieldByName('AddresVersion').AsInteger := iNewVersionAdr;
            Data.ClIDsTable.Post;
          end;
        end;
      end;

      if ResFuncDir[i] = '2' then
      begin
        if StreamAgr.Size > 0 then
        begin
          Main.UnzipStream2File(StreamAgr, Data.Import_Path + '2.csv', 'agreements', pub_key);
          Main.NewImportNav(Data.Import_Path + '2.csv', 'Agreements',aUser);
          if Data.ClIDsTable.Locate('Client_id',aUser.sId,[]) then
          begin
            Data.ClIDsTable.Edit;
            Data.ClIDsTable.FieldByName('AgrVersion').AsInteger := iNewVersionAgr;
            Data.ClIDsTable.Post;
          end;
        end;
      end;

      if ResFuncDir[i] = '3' then
      begin
        if not FileExists(Data.Import_Path + 'D.zip') then
          Continue;
        Main.UnZipper.ZipName  := Data.Import_Path + 'D.zip';
        Main.UnZipper.Password := pub_key;
        Main.UnZipper.ReadZip;
        Stream := TStringStream.Create('');
        try
          if Main.UnZipper.UnZipToStream(Stream, 'discounts') < 1 then
            Exit;

          Main.ApplyDiscounts2DB(Stream, aUser.sID, iNewVersion, UpdFlag, Data.DiscountTable);
          if Data.ClIDsTable.Locate('Client_id',aUser.sID,[]) then
          begin
            Data.ClIDsTable.Edit;
            Data.ClIDsTable.FieldByName('DiscVersion').AsInteger := iNewVersion;
            Data.ClIDsTable.Post;
          end;
        finally
          Stream.Free;
        end;
      end;
    end;
  finally

    StreamAdr.Free;
    StreamAgr.Free;
    UpdateUserData(aUser);
  end;
{$ENDIF}
end;

procedure TMain.LoadIDSExecute(Sender: TObject);
var fileCSV:TextFile;
    sFileValue:string;
begin
 exit;
  if OpenDialogCSV.Execute() = false then
     exit;
     data.XClIDsTable.Close;
  with Data.ClIDsTable do
  begin
    AssignFile(fileCSV,OpenDialogCSV.FileName);
    Reset(fileCSV);
    IndexName := 'Client_ID';
    while not System.Eof(fileCSV) do
       begin
        Readln(fileCSV,sFileValue);
        if ExtractDelimited(2,  sFileValue, [';']) <> '' then
        begin
         if not FindKey([StrToInt64(ExtractDelimited(2,  sFileValue, [';']))]) then
         begin
           Append;
           FieldByName('Client_ID').AsString := ExtractDelimited(2,  sFileValue, [';']);
           FieldByName('Description').AsString    := ExtractDelimited(1,  sFileValue, [';']);
           FieldByName('Order_type').Value := 'A';
           Post;
         end;
        end;
       end;
    CloseFile(fileCSV);
  end;
end;

procedure TMain.LoadLotusAnalogExecute(Sender: TObject);
begin
  //adminmode
//  exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

      if OpenDialogCSV.Execute() = false then
     exit;
       SetCurrentDir(Data.Data_Path);
   if FileExists(OpenDialogCSV.FileName) then
   begin
     Data.LoadLotusAnalog_new(OpenDialogCSV.FileName);
   end;
end;

procedure TMain.LoadLotusOEExecute(Sender: TObject);
begin
  //adminmode
//  exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

if OpenDialogCSV.Execute() = false then
     exit;
       SetCurrentDir(Data.Data_Path);
   if FileExists(OpenDialogCSV.FileName) then
   begin
     Data.LoadLotusOE(OpenDialogCSV.FileName);
   end;
end;

procedure TMain.AutoHistItemClick(Sender: TObject);
begin
  Data.Auto_type := (Sender as TMenuItem).Tag;
  Application.ProcessMessages;
  Data.sAuto := '';
  AutoPanel.Hide;
  ParamTypGrid.Datasource := nil;

  with Data.AutoHistTable do
  begin
    IndexName := 'Typ_id';
    Open;
    if FindKey([Data.Auto_type]) then
    begin
      Data.Last_typ := Data.Auto_type;
      Data.Last_mod := FieldByName('Mod_id').AsInteger;
      Data.Last_mfa := FieldByName('Mfa_id').AsInteger;
    end;
    Close;
  end;
  SetCarFilter(Data.Auto_type);
end;

procedure TMain.SaveAnalogExecute(Sender: TObject);
var
  F: TextFile;
  s:string;
begin
  //adminmode
//exit;
{$IFNDEF ADMINMODE}
  Exit;
{$ENDIF}

  if SaveFilePriceDialog.Execute() = false then
    exit;
  SetCurrentDir(Data.Data_Path);
  s:= SaveFilePriceDialog.FileName;
  if (StrLeft(s,4)<>'.csv') then
    s:=s+'.csv';

  AssignFile(f,s);
  Rewrite(f);
  with Data.TestQuery do
  begin
    SQL.Clear;
    SQL.Add('SELECT [002].Code, [003].Description, [007].An_code, [007].An_brand From [002] ');
    SQL.Add('join [003] ON [003].brand_id = [002].brand_id ');
    SQL.Add('join [007] ON [007].Cat_id = [002].Cat_id WHERE [007].An_id > 0');
    Open;
    while not Eof do
    begin
    if Length(FieldByName('Code').AsString)>0 then
    begin

      WriteLn(F, FieldByName('Code').AsString + '_' +
                 FieldByName('Description').AsString+';'+
                 FieldByName('An_code').AsString+ '_'+
                 FieldByName('An_brand').AsString+ ';');
    end;
      Next;
    end;
    Close;
  end;
  CloseFile(F);
  MessageDlg('Analogs: '+s+'!',mtInformation,[MBOK],0);
end;

procedure TMain.SaveAssortmentExpansionExecute(Sender: TObject);
begin
   { if Data.ParamTable.FieldByName('Cli_ID').AsInteger < 1 then
    begin
      MessageDlg('Не выбран клиент по умолчанию!', mtInformation, [MBOK],0);
      exit;
    end;   }
    SaveAssortmentExpansionProc(TRUE);
end;



procedure TMain.SaveAutoHist;
begin
  if Data.Auto_type = 0 then
    exit;
  with Data.AutoHistTable do
  begin
    Open;
    IndexName := 'Typ_id';
    FindKey([Data.Auto_type]);
    while (not Eof) and (FieldByName('Typ_id').asInteger = Data.Auto_type) do
      delete;
    Append;
    FieldByName('Typ_id').Value := Data.Auto_type;
    FieldByName('Mod_id').Value := Data.Last_mod;
    FieldByName('Mfa_id').Value := Data.Last_mfa;
    Post;
    Close;
  end;
  LoadAutoHist;
end;

procedure TMain.SetCarFilter(aCarId: Integer);
var
  IDs: TStrings;
begin
  StartWait;
  try
    Data.Auto_type := aCarId;
    SaveAutoHist;
    ShowAuto;
    Data.sAuto := '';

    IDs := TStringList.Create;
    try
      Data.GetCatIDsForCar(Data.Auto_type, IDs);
      if IDs.Count = 0 then
      begin
        MessageDlg('По вашему запросу ничего не найдено!', mtInformation, [mbOK], 0);
        AutoPanel.Hide;
        Data.sAuto := '';
        ParamTypGrid.Datasource := nil;
        Data.Auto_type := 0;
        Data.SetCatFilter;
        Exit;
      end
      else
      begin
        Data.sAuto := '(typ_tdid IN (' + IDs.CommaText + '))';
      end;
    finally
      IDs.Free;
    end;

    Data.SetCatFilter;
    ParamTypGrid.Datasource := Data.CatTypDetDataSource;
    AutoPanel.Caption.Text := 'Автомобиль  (найдено: ' + IntToStr(Data.CatalogDataSource.Dataset.RecordCount) + ')';
  finally
    StopWait;
  end;
end;


procedure TMain.SetCurrentFilter(const aText: string; aFilterMode: Integer);
begin
  FiltModeComboBox.ItemIndex := aFilterMode;
  FiltEd.Text := aText;
  Update;
  Application.ProcessMessages;
  FindFilter.Execute;
end;

procedure TMain.SetDefaultContractMask(Edit: TEdit);
begin
  Data.ContractsCliTable.Filtered := False;

  if Data.ContractsCliTable.Locate('Cli_id;Contract_Id',
    VarArrayOf([Data.ClIDsDataSource.DataSet.FieldByName('client_id').AsString ,
                Data.ClIDsDataSource.DataSet.FieldByName('ContractByDefault').AsString]), []) then
    Edit.text := GetMaskEdDir
  else
    Edit.text := '';
end;

procedure TMain.SetImageByLight(aLigthIndex: integer; aCorrectImage: boolean);
begin
  case aLigthIndex of
    INDEX_OF_PROG:
      fFlagsUpdateByLight.bNeedUpdateProg := aCorrectImage;
    INDEX_OF_DATA:
      fFlagsUpdateByLight.bNeedUpdateData := aCorrectImage;
    INDEX_OF_QUANTS:
      fFlagsUpdateByLight.bNeedUpdateQuants := aCorrectImage;
    INDEX_OF_RATES:
      fFlagsUpdateByLight.bNeedUpdateRates := aCorrectImage;
  end;
end;

//загружает TCP-ответ по заказу и ложит его в блоб
function TMain.LoadOrderTCP1: Boolean;

  function CheckOrder(aHandler: TIdIOHandler; aClientID, aOrderNum: string): Boolean;
  var
    s: string;
    aStream: TMemoryStream;
  begin
    Result := False;
    //TEST<ver>_<id_клиента>_<номер_заказа>
    aHandler.Writeln(Format('TEST1_%s_%s', [aClientID, aOrderNum]));
    //читаем заказ
    s := aHandler.ReadLnWait(10 {попыток});
    if SameText(s, 'ZAKAZANO') then
    begin
      Result := True;        
      s := aHandler.ReadLnWait(10 {попыток});
      if SameText(s, 'BINFILE') then
      begin
        aStream := TMemoryStream.Create;
        aHandler.ReadStream(aStream, -1, False);
        aHandler.ReadLnWait(10 {попыток}); { ENDFILE }

        if aStream.Size > 0 then
        begin
          Data.OrderTable.Edit;
          TBlobField(Data.OrderTable.FieldByName('TcpAnswer')).LoadFromStream(aStream);
          Data.OrderTable.Post;
        end;
        aStream.Free;
      end;

      //читаем замены
      s := aHandler.ReadLnWait(10 {попыток});
      if SameText(s, 'ZAMENY') then
      begin
        s := aHandler.ReadLnWait(10 {попыток});
        if SameText(s, 'BINFILE') then
        begin
          aStream := TMemoryStream.Create;
          aHandler.ReadStream(aStream, -1, False);
          aHandler.ReadLnWait(10 {попыток}); { ENDFILE }
          aHandler.ReadLnWait(10 {попыток}); { END }

          if aStream.Size > 0 then
          begin
            Data.OrderTable.Edit;
            TBlobField(Data.OrderTable.FieldByName('TcpAnswerZam')).LoadFromStream(aStream);
            Data.OrderTable.Post;
          end;
          aStream.Free;
        end;
      end;
    end;
  end;

var
  TCPClientTest: TIdTCPClient;
begin
  Result := False;
{
  if not CheckClientId then
    Exit;

  UserData := GetCurrentUser;
  if not UserData.bUpdateDisc then
    if LoadDescriptionsTCP(ReplaceLeftSymbol(UserData.sId), ReplaceLeftSymbolAB(UserData.sKey), inttostr(UserData.DiscountVersion), aNewDiscVer) > 0 then
      UpdateUserData(UserData);

}      

  if ((Data.OrderTable.FieldByName('Sent').AsString = '')or(Data.OrderTable.FieldByName('Sent').AsString = '0')) then
  begin
    MessageDlg('Невозможно получить ответ! Заказ не отсылался!', mtInformation, [mbOK], 0);
    Exit;
  end;

  Data.OrderTable.Edit;
  Data.OrderTable.FieldByName('TcpAnswer').AsVariant := NULL;
  Data.OrderTable.FieldByName('TcpAnswerZam').AsVariant := NULL;
  Data.OrderTable.Post;

  TCPClientTest := TIdTCPClient.Create(nil);
  try
    if not DoTcpConnect(TCPClientTest, True, True) then
      Exit;

    if CheckOrder(TCPClientTest.IOHandler, Data.OrderTable.FieldByName('cli_id').AsString, Data.OrderTable.FieldByName('Sign').AsString) then
    begin
      Data.OrderTable.Edit;
      Data.OrderTable.FieldByName('Sent').AsString := '4';
      Data.OrderTable.Post;
    end
    else
    begin
      MessageDlg('Заявка еще не обработана. Повторите попытку позже.', mtInformation, [mbOK], 0);
      Exit;
    end;

  finally
    TCPClientTest.Disconnect;
    TCPClientTest.Free;
  end;

  Result := True;
end;

//применяет принятый ответ по заказу
procedure TMain.ApplyOrderAnswer;
var
  fname, subj, email, s, fn: string;
  F: TextFile;
  Path:string;
  OdrderID, iPos: string;
  DetailCode:string;
  BrandName:string;
  Quants:string;
  SQL, SQLValue:string;
  iSQL:integer;
  fieldName: TField;
  aPrice1, aPrice2: string;
  list, OrderedList: TStringList;
  aCurrName1, aCurrName2: string;
  anOldDoc: Boolean;
  aLotusNumber, aKey: string;
  aInd: Integer;

  aStream: TMemoryStream;
  ZakazanoFileName, ZamenyFileName: string;
  aHasZameny, aHasZakazano: Boolean;
  aLinesCount: Integer;

  aReader: TCSVReader;
begin
  Path := GetAppDir + 'Импорт\';
  with Data.OrderTable do
  begin
    if (FieldByName('Order_Id').AsInteger = 0) or (FieldByName('Sent').AsString <> '4') then
      Exit;

    subj := FieldByName('cli_id').AsString + '_' +  FieldByName('Sign').AsString;
    OdrderID := FieldByName('Order_id').AsString;

    ZakazanoFileName := 'Zakazano_' + subj + '.csv';
    ZamenyFileName := 'Zameny_' + subj + '.csv';

    DeleteFile(Path + ZakazanoFileName);
    DeleteFile(Path + ZamenyFileName);

    aHasZakazano := False;
    if not FieldByName('TcpAnswer').IsNull then
    begin
      aStream := TMemoryStream.Create;
      try
        TBlobField(FieldByName('TcpAnswer')).SaveToStream(aStream);
        UnzipStream2File(aStream, Path + ZakazanoFileName, ZakazanoFileName);
        aHasZakazano := True;
      finally
        aStream.Free;
      end;
    end;

    aHasZameny := False;
    if not FieldByName('TcpAnswerZam').IsNull then
    begin
      aStream := TMemoryStream.Create;
      try
        TBlobField(FieldByName('TcpAnswerZam')).SaveToStream(aStream);
        UnzipStream2File(aStream, Path + ZamenyFileName, ZamenyFileName);
        aHasZameny := True;
      finally
        aStream.Free;
      end;
    end;

  end;



  QueryLoadOrderISAM.SQL.Clear;
  QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET ORDERED = -1 WHERE Order_id = '+OdrderID);
  QueryLoadOrderISAM.ExecSQL;
  QueryLoadOrderISAM.Close;

  Data.OrderTable.Edit;
  Data.OrderTable.FieldByName('Sent').AsInteger := 2;
  Data.OrderTable.FieldByName('TcpAnswer').AsVariant := NULL;
  Data.OrderTable.FieldByName('TcpAnswerZam').AsVariant := NULL;
  Data.OrderTable.Post;
  Data.OrderTable.Refresh;

  list := TStringList.Create;
  OrderedList := TStringList.Create;

  aCurrName1 := '';
  aCurrName2 := '';

  fname := Path + ZakazanoFileName;
  if FileExists(fname) then
  begin
    AssignFile(F, fname);
    Reset(F);

    try
      Readln(F, s);
      DetailCode:= ExtractDelimited(2,  s, [';']);
      if(DetailCode = '')then
      begin
        MessageDlg(s,mtWarning,[mbOK],0);
        aHasZakazano := False;
        if not aHasZameny then
          Exit;
      end;
    
      if not aHasZakazano then
      begin
        aCurrName1 := 'BYR';
        aCurrName2 := 'EUR';
        aLotusNumber := '---';
      end
      else
      begin
        aCurrName1 := ExtractDelimited(5,  s, [';']);
        aCurrName2 := ExtractDelimited(6,  s, [';']);
        anOldDoc := (aCurrName1 = '') and (aCurrName2 = '');
        if aCurrName1 = '' then
          aCurrName1 := 'BYR';
        if aCurrName2 = '' then
          aCurrName2 := 'EUR';

        aLotusNumber := DetailCode;

        Data.OrderTable.Edit;
        Data.OrderTable.FieldByName('LotusNumber').Value := aLotusNumber;
        Data.OrderTable.Post;
        Data.OrderTable.Refresh;

        //забираем все что заказано
        QueryLoadOrderISAM.Close;
        QueryLoadOrderISAM.SQL.Text :=
          ' SELECT Code2, Brand, Quantity FROM [010] ' +
          ' WHERE Order_id = ' + OdrderID;
        QueryLoadOrderISAM.Open;
        while not QueryLoadOrderISAM.Eof do
        begin
          aKey := AnsiUpperCase(QueryLoadOrderISAM.FieldByName('Code2').AsString) + '_' + AnsiUpperCase(QueryLoadOrderISAM.FieldByName('Brand').AsString);
          aInd := OrderedList.IndexOfName(aKey);
          if aInd >= 0 then
            OrderedList[aInd] := aKey + '=' + FloatToStr(StrToFloatDef(OrderedList.ValueFromIndex[aInd], 0) + QueryLoadOrderISAM.FieldByName('Quantity').AsFloat)
          else
            OrderedList.Add(aKey + '=' + QueryLoadOrderISAM.FieldByName('Quantity').AsString);
          QueryLoadOrderISAM.Next;
        end;
        QueryLoadOrderISAM.Close;
        //-------------------------

        while not System.Eof(F) do
        begin
          Readln(F, s);

          if(StrRight(s,1)<>';') then
              s:=s+';';
          if(StrFind(S,';')>1)and(length(S)>0) then
          begin
            DetailCode := StrLeft(s,StrFind(s,'_')-1);
            s := StrRight(s,Length(s)-Length(DetailCode)-1);
            DetailCode := Data.MakeSearchCode(DetailCode);
            BrandName:= AnsiUpperCase(StrLeft(s,StrFind(s,';')-1));
            s := StrRight(s,Length(s)-Length(BrandName)-1);
            Quants:= StrLeft(s,StrFind(s,';')-1);
            s := StrRight(s,Length(s)-Length(Quants)-1);
            s := StrRight(s,Length(s)-StrFind(s,';'));
            aPrice1 := StrLeft(s,StrFind(s,';')-1);
            s := StrRight(s,Length(s)-Length(aPrice1)-1);
            aPrice2 := StrLeft(s,StrFind(s,';')-1);
            s := StrRight(s,Length(s)-Length(aPrice2)-1);

            if not anOldDoc then
              list.Add(DetailCode+';'+BrandName+';'+aPrice2+';'+aPrice1+';')
            else
              if AToCurr(aPrice1) <  AToCurr(aPrice2) then
                list.Add(DetailCode+';'+BrandName+';'+aPrice1+';'+aPrice2+';')
              else
                list.Add(DetailCode+';'+BrandName+';'+aPrice2+';'+aPrice1+';');

            if Length(DetailCode) > 0 then
            begin
              QueryLoadOrderISAM.Close;

              QueryLoadOrderISAM.SQL.Clear;
              QueryLoadOrderISAM.SQL.Add('SELECT * FROM [010] WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+''' AND Quantity = '+Quants+' AND  Order_id = '+OdrderID);
              QueryLoadOrderISAM.Active := TRUE;
              if QueryLoadOrderISAM.FieldByName('Order_id').AsInteger > 0 then
              begin
                QueryLoadOrderISAM.Close;
                QueryLoadOrderISAM.SQL.Clear;
                QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET ORDERED = 1 WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+''' AND Quantity = '+Quants+' AND Order_id = '+OdrderID);
                QueryLoadOrderISAM.ExecSQL;
              end
              else
              begin
                QueryLoadOrderISAM.Close;
                QueryLoadOrderISAM.SQL.Clear;
                QueryLoadOrderISAM.SQL.Add('SELECT * FROM [010] WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+''' AND Quantity > '+Quants+' AND  Order_id = '+OdrderID);
                QueryLoadOrderISAM.Active := TRUE;

                if QueryLoadOrderISAM.FieldByName('Order_id').AsInteger > 0 then
                begin
                  iPos := QueryLoadOrderISAM.FieldByName('Id').AsString;
                  SQL := '';
                  SQLValue := '';
                  for iSQL := 1 to QueryLoadOrderISAM.FieldCount - 1 do
                  begin
                    fieldName := QueryLoadOrderISAM.Fields[iSQL];
                    s := QueryLoadOrderISAM.FieldByName(fieldName.DisplayName).AsString;
                    if QueryLoadOrderISAM.FieldByName(fieldName.DisplayName).AsString <> '' then
                      SQL:= SQL + ', ' +fieldName.DisplayName
                  end;

                  SQL := StrRight(SQL,Length(SQL)-2);

                  QueryLoadOrderISAM.Close;
                  QueryLoadOrderISAM.SQL.Clear;
                  QueryLoadOrderISAM.SQL.Add('INSERT INTO [010] ('+SQL+') SELECT '+SQL+' FROM [010] WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+'''  AND  Order_id = '+OdrderID);
                  QueryLoadOrderISAM.ExecSQL;

                  QueryLoadOrderISAM.Close;
                  QueryLoadOrderISAM.SQL.Clear;
                  QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET Quantity = Quantity - '+Quants+' WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+'''  AND  Order_id = '+OdrderID +' AND ID <> '+iPos);
                  QueryLoadOrderISAM.ExecSQL;

                  QueryLoadOrderISAM.Close;
                  QueryLoadOrderISAM.SQL.Clear;
                  QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET ORDERED = 1, Quantity = '+Quants+' WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+'''  AND  Order_id = '+OdrderID +' AND ID = '+iPos);
                  QueryLoadOrderISAM.ExecSQL;
                end;
              end;
          
              QueryLoadOrderISAM.Close;
            end;
          end;
        end; //while
      end; //if aHasZakazano
    finally  
      CloseFile(F);
    end;
  end; //if FileExists(fname) then

  aLinesCount := 0;
  fname := Path + ZamenyFileName;
  if FileExists(fname) then
  begin
    aReader := TCSVReader.Create;
    try
      aReader.Open(fname);
      aReader.ReturnLine;
      while not aReader.Eof do
      begin
        aReader.ReturnLine;

        if (aReader.Fields[0] <> '') and (aReader.Fields[1] <> '') then
        begin
          Inc(aLinesCount);
      
          Data.DecodeCodeBrand(aReader.Fields[6], DetailCode, BrandName, True {aMakeSearchCode});
          BrandName:= AnsiUpperCase(BrandName);

          s := StrRight(s,Length(s)-Length(DetailCode)-1);

          if Length(DetailCode) > 0 then
          begin
            QueryLoadOrderISAM.SQL.Clear;
            QueryLoadOrderISAM.SQL.Add('SELECT * FROM [010] WHERE Code2 ='''+DetailCode+''' AND Upper(Brand) = '''+ BrandName +''' AND ORDERED = -1 AND  Order_id = '+OdrderID);
            QueryLoadOrderISAM.Active := TRUE;


            if QueryLoadOrderISAM.FieldByName('Order_id').AsInteger > 0 then
            begin
              QueryLoadOrderISAM.Close;
              QueryLoadOrderISAM.SQL.Clear;
              QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET ORDERED = 0 WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+ BrandName +''' AND ORDERED = -1 AND  Order_id = '+OdrderID);
              QueryLoadOrderISAM.ExecSQL;
            end;
            QueryLoadOrderISAM.Close;
          end;
        end;
      end;
    finally
      aReader.Free;
    end;
  end; //if FileExists(fname) then
  aHasZameny := aLinesCount > 0;

  if aHasZameny or aHasZakazano then
  begin
    with TOrderAnswer.Create(Application) do
    try
      Init(List, aCurrName1, aCurrName2, aLotusNumber, OrderedList,ZakazanoFileName,ZamenyFileName );
      ShowModal;
    finally
      Free;
    end;
  end;
  
  list.Free;
  OrderedList.Free;
  Data.OrderDetTable.Refresh;
end;


function TMain.LoadOrderStatus: Boolean;

  function CheckOrderStatus(aHandler: TIdIOHandler; aClientID, aOrderNum: string): Integer;
  var
    s: string;
  begin
    //STATUS_<id_клиента>_<номер_заказа>
    aHandler.Writeln(Format('STATUS_%s_%s', [aClientID, aOrderNum]));
    //читаем заказ
    s := aHandler.ReadLnWait(10 {попыток});
    if s = 'END' then
      Result := 0
    else
    begin
      Result := StrToIntDef(s, 0);
      aHandler.ReadLnWait(10 {попыток}); //END
    end;
  end;


var
  TCPClientTest: TIdTCPClient;
begin
//
//STATUS_<CLIENT_ID>_<DOC_NUM>
  Result := False;
  TCPClientTest := TIdTCPClient.Create(nil);
  try
    if not DoTcpConnect(TCPClientTest, True, True) then
      Exit;

    ShowMessage( IntToStr(
      CheckOrderStatus(TCPClientTest.IOHandler, Data.OrderTable.FieldByName('cli_id').AsString, Data.OrderTable.FieldByName('Sign').AsString)
      )
    );

  finally
    TCPClientTest.Disconnect;
    TCPClientTest.Free;
  end;

end;


//загружает TCP-ответ по возврату и ложит его в блоб
function TMain.LoadRetdocTCP1: Boolean;

  function CheckRetdoc(aHandler: TIdIOHandler; aClientID, aRetdocNum: string): Boolean;
  var
    s: string;
    aStream: TMemoryStream;
  begin
    Result := False;
    //RETD<ver>_<id_клиента>_<номер_заказа>
    aHandler.Writeln(Format('RETD1_%s_%s', [aClientID, aRetdocNum]));
    //читаем заказ
    s := aHandler.ReadLnWait(10 {попыток});
    if SameText(s, 'ZAKAZANO') then
    begin
      Result := True;
      s := aHandler.ReadLnWait(10 {попыток});
      if SameText(s, 'BINFILE') then
      begin
        aStream := TMemoryStream.Create;
        aHandler.ReadStream(aStream, -1, False);
        aHandler.ReadLnWait(10 {попыток}); { ENDFILE }

        if aStream.Size > 0 then
        begin
          Data.ReturndocTable.Edit;
          TBlobField(Data.ReturndocTable.FieldByName('TcpAnswer')).LoadFromStream(aStream);
          Data.ReturndocTable.Post;
        end;
        aStream.Free;
      end;
    end;
  end;

var
  TCPClientTest: TIdTCPClient;
begin
  Result := False;
{
  if not CheckClientId then
    Exit;

  UserData := GetCurrentUser;
  if not UserData.bUpdateDisc then
    if LoadDescriptionsTCP(ReplaceLeftSymbol(UserData.sId), ReplaceLeftSymbolAB(UserData.sKey), inttostr(UserData.DiscountVersion), aNewDiscVer) > 0 then
      UpdateUserData(UserData);

}

  //1 - сохранен, 2 - отправлялся
  if ((Data.ReturnDocTable.FieldByName('Post').AsString = '') or (Data.ReturnDocTable.FieldByName('Post').AsString = '0')) then
  begin
    MessageDlg('Невозможно получить ответ! Возврат не отсылался!', mtInformation, [mbOK], 0);
    Exit;
  end;

  Data.ReturnDocTable.Edit;
  Data.ReturnDocTable.FieldByName('TcpAnswer').AsVariant := NULL;
  Data.ReturnDocTable.Post;

  TCPClientTest := TIdTCPClient.Create(nil);
  try
    if not DoTcpConnect(TCPClientTest, True, True) then
      Exit;

    if CheckRetdoc(TCPClientTest.IOHandler, Data.ReturnDocTable.FieldByName('cli_id').AsString, Data.ReturnDocTable.FieldByName('Sign').AsString) then
    begin
      Data.ReturnDocTable.Edit;
      Data.ReturnDocTable.FieldByName('Post').AsInteger := 4;
      Data.ReturnDocTable.Post;
    end
    else
    begin
      MessageDlg('Возврат еще не обработан. Повторите попытку позже.', mtInformation, [mbOK], 0);
      Exit;
    end;

  finally
    TCPClientTest.Disconnect;
    TCPClientTest.Free;
  end;

  Result := True;
end;

//применяет принятый ответ по возврату
procedure TMain.ApplyRetdocAnswer(fAutoCheck: Boolean = FALSE);
var
  fname, subj, s: string;
  F: TextFile;
  Path:string;
  RetDocID, iPos: string;
  DetailCode:string;
  BrandName:string;
  Quants:string;
  SQL, SQLValue:string;
  iSQL: Integer;
  fieldName: TField;
  aPrice1, aPrice2: string;
  list:TStringList;
  aCurrName1, aCurrName2: string;
  anOldDoc: Boolean;
  post: string;

  aStream: TMemoryStream;
  ZakazanoFileName: string;
begin
  Path := GetAppDir + 'Импорт\';
  with Data.ReturnDocTable do
  begin
    if (FieldByName('Retdoc_id').AsInteger = 0) or (FieldByName('Post').AsString <> '4') then
      Exit;

    subj := FieldByName('cli_id').AsString + '_' +  FieldByName('Sign').AsString;
    RetDocID := FieldByName('Retdoc_id').AsString;

    ZakazanoFileName := 'Zakazano_' + subj + '.csv';

    DeleteFile(Path + ZakazanoFileName);

    if not FieldByName('TcpAnswer').IsNull then
    begin
      aStream := TMemoryStream.Create;
      try
        TBlobField(FieldByName('TcpAnswer')).SaveToStream(aStream);
        UnzipStream2File(aStream, Path + ZakazanoFileName, ZakazanoFileName);
      finally
        aStream.Free;
      end;
    end;
  end;

  //обработать полученный файл
  QueryLoadOrderISAM.SQL.Clear;
  QueryLoadOrderISAM.SQL.Add('UPDATE [037] SET ORDERED = -1 WHERE RetDoc_ID = ' + RetDocID);
  QueryLoadOrderISAM.ExecSQL;
  QueryLoadOrderISAM.Close;

  list := TStringList.Create;

  aCurrName1 := '';
  aCurrName2 := '';

  fname := Path + ZakazanoFileName;
  if FileExists(fname) then
  begin
    AssignFile(F, fname);
    Reset(F);
    Readln(F, s);
    DetailCode:= ExtractDelimited(2,  s, [';']);
    if(DetailCode = '')then
    begin
      CloseFile(F);
      MessageDlg(s,mtWarning,[mbOK],0);
      WritePost(6);
      exit;
    end;
    
    Data.ReturnDocTable.Edit;
    Data.ReturnDocTable.FieldByName('LotusNumber').Value := DetailCode;
    Data.ReturnDocTable.Post;
    Data.ReturnDocTable.Refresh;

    aCurrName1 := ExtractDelimited(5,  s, [';']);
    aCurrName2 := ExtractDelimited(6,  s, [';']);
    //--------------
    post := ExtractDelimited(7,  s, [';']);
    if (post = '1') then
      WritePost(3)
    else if (post = '2') then
      WritePost(5);

    anOldDoc := (aCurrName1 = '') and (aCurrName2 = '');
    if aCurrName1 = '' then
      aCurrName1 := 'BYR';
    if aCurrName2 = '' then
      aCurrName2 := 'EUR';

    while not System.Eof(F) do
    begin
      Readln(F, s);

      if(StrRight(s,1)<>';') then
          s:=s+';';
      if(StrFind(S,';')>1)and(length(S)>0) then
      begin
        DetailCode := StrLeft(s,StrFind(s,'_')-1);
        s := StrRight(s,Length(s)-Length(DetailCode)-1);
        DetailCode := Data.MakeSearchCode(DetailCode);
        BrandName:= AnsiUpperCase(StrLeft(s,StrFind(s,';')-1));
        s := StrRight(s,Length(s)-Length(BrandName)-1);
        Quants:= StrLeft(s,StrFind(s,';')-1);
        s := StrRight(s,Length(s)-Length(Quants)-1);
        s := StrRight(s,Length(s)-StrFind(s,';'));
        aPrice1 := StrLeft(s,StrFind(s,';')-1);
        s := StrRight(s,Length(s)-Length(aPrice1)-1);
        aPrice2 := StrLeft(s,StrFind(s,';')-1);
        s := StrRight(s,Length(s)-Length(aPrice2)-1);

        if not anOldDoc then
          list.Add(DetailCode+';'+BrandName+';'+aPrice2+';'+aPrice1+';')
        else
        if AToCurr(aPrice1) <  AToCurr(aPrice2) then
          list.Add(DetailCode+';'+BrandName+';'+aPrice1+';'+aPrice2+';')
        else
          list.Add(DetailCode+';'+BrandName+';'+aPrice2+';'+aPrice1+';');

        if Length(DetailCode) > 0 then
        begin
          if QueryLoadOrderISAM.Active then
            QueryLoadOrderISAM.Active := FALSE;

          QueryLoadOrderISAM.SQL.Clear;
          QueryLoadOrderISAM.SQL.Add('SELECT * FROM [037] WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+''' AND Quantity = '+Quants+' AND  RetDoc_ID = ' + RetDocID);
          QueryLoadOrderISAM.Active := TRUE;
          if QueryLoadOrderISAM.FieldByName('RetDoc_ID').AsInteger > 0 then
          begin
            QueryLoadOrderISAM.Close;
            QueryLoadOrderISAM.SQL.Clear;
            QueryLoadOrderISAM.SQL.Add('UPDATE [037] SET ORDERED = 1 WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+''' AND Quantity = '+Quants+' AND RetDoc_ID = ' + RetDocID);
            QueryLoadOrderISAM.ExecSQL;
          end
          else
          begin
            QueryLoadOrderISAM.Close;
            QueryLoadOrderISAM.SQL.Clear;
            QueryLoadOrderISAM.SQL.Add('SELECT * FROM [037] WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+''' AND Quantity > '+Quants+' AND RetDoc_ID = ' + RetDocID);
            QueryLoadOrderISAM.Active := TRUE;

            if QueryLoadOrderISAM.FieldByName('RetDoc_ID').AsInteger > 0 then
            begin
              iPos := QueryLoadOrderISAM.FieldByName('Id').AsString;
              SQL := '';
              SQLValue := '';
              for iSQL := 1 to QueryLoadOrderISAM.FieldCount - 1 do
              begin
                fieldName := QueryLoadOrderISAM.Fields[iSQL];
                s := QueryLoadOrderISAM.FieldByName(fieldName.DisplayName).AsString;
                if QueryLoadOrderISAM.FieldByName(fieldName.DisplayName).AsString <> '' then
                  SQL:= SQL + ', ' +fieldName.DisplayName;
              end;

              SQL := StrRight(SQL,Length(SQL)-2);

              QueryLoadOrderISAM.Close;
              QueryLoadOrderISAM.SQL.Clear;
              QueryLoadOrderISAM.SQL.Add('INSERT INTO [037] ('+SQL+') SELECT '+SQL+' FROM [037] WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+'''  AND  RetDoc_ID = ' + RetDocID);
              QueryLoadOrderISAM.ExecSQL;

              QueryLoadOrderISAM.Close;
              QueryLoadOrderISAM.SQL.Clear;
              QueryLoadOrderISAM.SQL.Add('UPDATE [037] SET Quantity = Quantity - '+Quants+' WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+'''  AND  RetDoc_ID = ' + RetDocID +' AND ID <> '+iPos);
              QueryLoadOrderISAM.ExecSQL;

              QueryLoadOrderISAM.Close;
              QueryLoadOrderISAM.SQL.Clear;
              QueryLoadOrderISAM.SQL.Add('UPDATE [037] SET ORDERED = 1, Quantity = '+Quants+' WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+'''  AND  RetDoc_ID = ' + RetDocID +' AND ID = '+iPos);
              QueryLoadOrderISAM.ExecSQL;
            end;
          end;
          QueryLoadOrderISAM.Close;
        end;//  Length(DetailCode) > 0
      end;//(StrFind(S,';')>1)and(length(S)>0)
    end;//while System.Eof(F)
    CloseFile(F);

    if not fAutoCheck then
    begin
      with TRetDocAnswer.Create(Application) do
      try
        Init(List, aCurrName1, aCurrName2);
        ShowModal;
      finally
        Free;
      end;
    end;

    list.Free;
    Data.ReturnDocDetTable.Refresh;

{    if fPost then
    begin
      fPost := False;
      Data.ReturnDocTable.SetRange([DateStartReturnDoc.Date + cObsoleteOrderTime], [DateEndReturnDoc.Date]);
      exit;
    end;}
  end;//end FileExist
end;


function TMain.StrLeft(s: string; i: Integer):string;
 var j:integer;
     itog:string;
begin
   itog := '';
   j := length(s);
   if i<j then
      while i>0 do
       begin
         itog := s[i] + itog;
         i:=i-1;
       end
   else
       itog := s;

    StrLeft := itog;
end;

function TMain.StrRight(s:string; i:integer):string;
var j:integer;
     itog:string;
begin
   i := i-1;
   itog := '';
   j := length(s);
   if i<j then
      while i>-1 do
       begin
         itog := itog + s[j-i];
         i:=i-1;
       end
   else
       itog := s;
   StrRight := itog;
end;

procedure TMain.StartF7Task(aCheckOrderOnly: Boolean);
begin
  if Main.TimerAskQuants.Enabled then
  begin
    MessageDlg('Подождите!', mtInformation, [mboK],0);
    Exit;
  end;

  StopF7Task;
  fCheckOrderOnly := aCheckOrderOnly;
  fTaskF7 := TTaskF7.Create;
  fTaskF7.OnBeforeRun := TaskF7BeforeRun;
  fTaskF7.OnAfterEnd := TaskF7AfterEnd;
  fTaskF7.Enabled := True;
  fTaskF7.Start;
end;

procedure TMain.StatusBarDrawPanel(StatusBar: TAdvOfficeStatusBar;
  Panel: TAdvOfficeStatusPanel; const Rect: TRect);
var
  Can: TCanvas;
begin
  if Panel.Index <> 6 then
    exit;

  Can := StatusBar.Canvas;
  Can.Brush.Color := clYellow;
  Can.Rectangle(Rect);
  Can.TextOut(Rect.Left+2,Rect.Top+2, StatusBar.Panels[6].Text);
end;

procedure TMain.StopF7Task;
begin
  if Assigned(fTaskF7) then
  begin
    fTaskF7.OnAfterEnd := nil;
    fTaskF7.Free;
    fTaskF7 := nil;
  end;
end;

function TMain.StrFind(s:string; ch:char):integer;
var  itog:integer;
begin
   if Length(s)<1 then
   begin
     StrFind := -1;
     exit;
   end;

   itog := 0;
   while(itog<Length(s)+1) do
   begin
   if(s[itog] = ch) then
      break
   else
      itog := itog + 1;
   end;
   if(itog>Length(s)) then
      itog := -1;
   StrFind := itog;
end;

function TMain.AToFloat(s:string):real;
var  itog:real;
     iFindPos:integer;
begin
   iFindPos:=StrFind(s,',');
   if iFindPos>0 then
   begin
       s := StrLeft(s,iFindPos-1)+'.'+strRight(s,length(s)-iFindPos);
   end;

   itog := 0.0;
   try
     itog := StrToFloat(s);
   except
   begin
     iFindPos:=StrFind(s,'.');
     if iFindPos>0 then
     begin
       s := StrLeft(s,iFindPos-1)+','+strRight(s,length(s)-iFindPos);
     end;

     try
       itog := StrToFloat(s);
     except

     end;
   end;
   end;
   AToFloat := itog;
end;



function TMain.TestString(s1,s2:string):bool;
  var sLeft1,sLeft2,sRight1,sRight2:string;
  iFindPos:integer;
begin
  sLeft1 :='';
  sLeft2 :='';
  sRight1 :='';
  sRight2 :='';

  iFindPos:=StrFind(s1,'.');
   if iFindPos>0 then
   begin
       sLeft1 := StrLeft(s1,iFindPos-1);
       sRight1 :=strRight(s1,length(s1)-iFindPos);
   end;

   iFindPos:=StrFind(s2,'.');
   if iFindPos>0 then
   begin
       sLeft2 := StrLeft(s2,iFindPos-1);
       sRight2 :=strRight(s2,length(s2)-iFindPos);
   end;

   if sLeft2>sLeft1 then
   begin
       TestString :=TRUE;
       exit;
   end
   else
   if sLeft1>sLeft2 then
     begin
        TestString :=FALSE;
        exit;
     end;

   if AToFloat(sRight2)>AToFloat(sRight1) then
   begin
       TestString :=TRUE;
       exit;
   end;
   TestString :=FALSE;
end;

//sURL - всегда с proxy аргументами
function TMain.MainDownLoadFile(sURL, sFileName:string): Boolean;
 var
  hSession, hFile: HInternet;
  Buffer: array[1..1024] of Byte;
  BufferLen: LongWord;
  f: File;
  ErrFile: TextFile;
  szHeaders, ErrText: string;
  OpenFlags: DWORD;
begin
{***TEST***}
{  URL4Test := StringReplace(sURL,' ', '', [rfReplaceAll]);
  URL4Test := StringReplace(URL4Test, #13#10#13#10, #13#10, [rfReplaceAll]);
  memo1.Lines.Append(URL4Test);}
//***TEST***}

  DeleteFile(sFileName);
  OpenFlags := INTERNET_FLAG_RELOAD or INTERNET_FLAG_NO_CACHE_WRITE or INTERNET_FLAG_PASSIVE
    {$IFDEF DELPHI4_LVL}
    or INTERNET_FLAG_PRAGMA_NOCACHE
    {$ENDIF}
    ;
  MainDownLoadFile := FALSE;
  if Data.ParamTable.FieldByName('UseProxy').AsBoolean then
     hSession := InternetOpen('Download_ShateM_Update', INTERNET_OPEN_TYPE_PROXY ,pchar(Data.ParamTable.FieldByName('ProxySRV').AsString+':'+Data.ParamTable.FieldByName('ProxyPort').AsString),nil,0)
  else
    hSession := InternetOpen('Download_ShateM_Update',INTERNET_OPEN_TYPE_PRECONFIG, nil,nil,0);

  if (Assigned(hSession)) then
  begin
    try
     szHeaders := '';

    hFile := InternetOpenURL(hSession, PChar(sURL), PChar(szHeaders),length(szHeaders),OpenFlags, 0);

    if Assigned(hFile) then
    begin
      AssignFile(f, sFileName);
      Rewrite(f,1);
      repeat
        if not InternetReadFile(hFile, @Buffer, SizeOf(Buffer), BufferLen) then
        begin
          CloseFile(f);
          InternetCloseHandle(hFile);
          exit;
        end;
        BlockWrite(f, Buffer, BufferLen);
      until (BufferLen = 0);
      CloseFile(f);
      InternetCloseHandle(hFile);
    end
    else
    begin
      InternetCloseHandle(hSession);
      exit;
    end;
    InternetCloseHandle(hSession);
    except
      on e: Exception do
      begin
        CloseFile(f);
        ErrText := E.Message;
        AssignFile(ErrFile,GetAppDir + '!!!.err');
        if FileExists(GetAppDir + '!!!.err') then
          Append(ErrFile)
        else
          ReWrite(ErrFile);
        Writeln(ErrFile,DateTimeToStr(Now) + ' -> ' + ErrText);
        CloseFile(ErrFile);
        exit;
      end;
    end;
  end;
  MainDownLoadFile := TRUE;
 end;


function TMain.MainDownLoadFileMirrors(aDestFileName: string; IsExtUpdate: Boolean): Boolean;
var
  i: Integer;
  aMirrorUrl: string;
  aServers: TStrings;
begin
  Result := False;

  aServers := TStringList.Create;
  try
    GetUpdateServersList(aServers);

    for i := 0 to aServers.Count - 1 do
    begin
      aMirrorUrl := Data.BuildUpdateUrl(aServers[i], True, IsExtUpdate); //with proxy args
      Result := MainDownLoadFile(aMirrorUrl, aDestFileName);
      if Result then
      begin
        fCurrentWorkingServer := aServers[i];
        Break;
      end;
    end;
  finally
    aServers.Free;
  end;
end;

procedure TMain.TimerAskQuantsTimer(Sender: TObject);
begin
   TimerAskQuants.Enabled := FALSE;
end;

procedure TMain.TimerUpdateTimer(Sender: TObject);
var
  TestInternet: TTestInternet;
begin
  if fAutoUpdateLocked then
    Exit;

  //закончен срок действия программы - блокируем автообновления - работаем через форму проверки версий
  if (CheckProgrammPeriod <> 0) and not CheckIsServiceOrdered then
    Exit;


  //во время обновления не проверяем следующее  
  if Assigned(UpdateThrd) or (not bTerminate) then
  begin
//    MessageDlg('В данный момент уже устанавливается обновление.'#13#10 +
//               'Дождитесь завершения и повторите попытку.', mtInformation, [mbOK], 0);
    Exit;
  end;


// TimerUpdate.Interval := 1;
  TimerUpdate.Interval := cCheckUpdateInterval;
  TimerUpdate.Enabled := False;

  if not Data.SysParamTable.Active then
  begin
    TimerUpdate.Enabled := True;
    Exit;
  end;

{
  UserData := GetCurrentUser;
  if Assigned(UserData) then
    if not UserData.bUpdateDisc then
      if LoadDescriptionsTCP(ReplaceLeftSymbol(UserData.sId), ReplaceLeftSymbolAB(UserData.sKey), inttostr(UserData.DiscountVersion), aNewDiscVer) > 0 then
        UpdateUserData(UserData);
}

  TestInternet := TTestInternet.Create(True);
  TestInternet.Resume;
end;

procedure TMain.UniversalExportExecute(Sender: TObject);
var
  Query: TDBISAMQuery;
  StrQuery: TStringList;
  quant: String;
begin
  StrQuery := TStringList.Create;
  Query := TDBISAMQuery.Create(nil);
  try
    MessageDlg('Данная процедура может занять не более 1 минуты времени. Пожалуйста подождите. ', mtInformation, [mbOK], 0);
    Query.DatabaseName := Data.Database.DatabaseName;
    Query.SQL.Clear;
    Query.SQL.Add('Select br.description,Code,Quantity,Price,cat.name, mult from  [002] cat '+
                  'inner join [003] br on (cat.brand_id = br.brand_id) ' +
                  'inner join [012] q on (q.cat_id = cat.cat_id)' );
    Query.ExecSQL;

    Query.First;
    while not Query.Eof do
    begin
      quant := Query.FieldByName('Quantity').AsString;
      if Pos('>',quant) >0 then
        Delete(quant,Pos('>',quant),1);
      StrQuery.Append(Query.FieldByName('description').AsString + ';' +
                      Query.FieldByName('Code').AsString + ';' +
                      quant + ';' +
                      Query.FieldByName('Price').AsString + ';' +
                      Query.FieldByName('name').AsString + ';' +
                      Query.FieldByName('mult').AsString + ';'
      );
      Query.next;
    end;
    StrQuery.SaveToFile(Data.Import_Path + 'Универсальный экспорт.csv');
    MessageDlg('Экспорт завершен удачно. Файл сохранен '+ Data.Import_Path + 'Универсальный экспорт.csv', mtInformation, [mbOK], 0);
  finally
    Query.free;
  end;
end;

procedure TMain.UnlockOrder;
begin
  if ((Data.OrderTable.FieldByName('Sent').AsString = '')or(Data.OrderTable.FieldByName('Sent').AsString = '0')) then
    Exit;

  if (Data.OrderTable.FieldByName('Sent').AsString = '3')or(Data.OrderTable.FieldByName('Sent').AsString = '1') then
    if MessageDlg('Возможно заказ уже обработан! Продолжить?', mtInformation, [mbYes,mbNo], 0) = mrNo  then
      Exit;

  if (Data.OrderTable.FieldByName('Sent').AsString = '2') or (Data.OrderTable.FieldByName('Sent').AsString = '4') then
  begin
    if MessageDlg('Заказ уже был обработан! Продолжить?', mtWarning, [mbYes,mbNo], 0) = mrNo  then
      Exit;
  end;

  Data.OrderTable.Edit;
  Data.OrderTable.FieldByName('Sent').AsString := '0';
  Data.OrderTable.FieldByName('IsDelivered').AsVariant := NULL;
  Data.OrderTable.FieldByName('Sent_Time').AsVariant := NULL;
  Data.OrderTable.FieldByName('TcpAnswer').AsVariant := NULL;
  Data.OrderTable.FieldByName('TcpAnswerZam').AsVariant := NULL;
  Data.OrderTable.Post;
end;

function TMain.UnzipStream2Stream(aStreamIn, aStreamOut: TStream; const aFileName, aPassword: string): Boolean;
var
  anUnZipper: TVCLUnZip;
begin
  Result := False;
  if not Assigned(aStreamIn) or not Assigned(aStreamOut) then
    Exit;

    aStreamIn.Position := 0;
    anUnZipper := TVCLUnZip.Create(nil);
    try
      anUnZipper.ArchiveStream := aStreamIn;
      anUnZipper.DoProcessMessages := False;
      anUnZipper.Password := aPassword;
      anUnZipper.UnZipToStream(aStreamOut, aFileName);
      anUnZipper.ArchiveStream := nil;
    finally
      anUnZipper.Free;
    end;

  Result := True;
end;

procedure TMain.UnzipStream2File(aStreamIn: TStream; const aFileOut, aFileName,
  aPassword: string);
var
  aFileStream: TFileStream;
begin
  aFileStream := TFileStream.Create(aFileOut, fmCreate);
  try
    UnzipStream2Stream(aStreamIn, aFileStream, aFileName, aPassword)
  finally
    aFileStream.Free;
  end;
end;

function TMain.AToCurr(s:string):Currency;
var
  itog:Currency;
  iFindPos:integer;
begin
  iFindPos:=StrFind(s,',');
  if iFindPos>0 then
    s := StrLeft(s,iFindPos-1)+'.'+strRight(s,length(s)-iFindPos);
  try
     itog := StrToCurr(s);
  except
    begin
      iFindPos:=StrFind(s,'.');
      if iFindPos>0 then
        s := StrLeft(s,iFindPos-1)+','+strRight(s,length(s)-iFindPos);
      try
        itog := StrToCurr(s);
      except
        itog := -1;
      end;
    end;
  end;
  result := itog;
end;
 
procedure TMain.ShowUpdateReport(anUpdateResult: TUpdateResult;
  aQueue: TUpdateQueue);
var
  aNotShow: Boolean;
begin
  aNotShow := Data.ParamTable.FieldByName('Hide_update_report').AsBoolean;
  if (anUpdateResult <> urFully) or (not aNotShow) then
  begin
    TFormUpdateReport.Execute(anUpdateResult, aQueue, aNotShow);
    Data.ParamTable.Edit;
    Data.ParamTable.FieldByName('Hide_update_report').AsBoolean := aNotShow;
    Data.ParamTable.Post;
  end
  else
  begin
    ShowProgrInfo('Обновление успешно установлено');
    QuantVersion := Data.VersionTable.FieldByName('QuantVersion').AsString;
  end;
end;

procedure TMain.PostMessageFinished(var Msg: TMessage);

  procedure SendLogNotRenamedFiles();
  var
    TCPClient:TIdTCPClient;
    fSended: boolean;
    aList: TStringList;
    aStream: TStringStream;
    sFileName: string;
  begin
    sFileName := ExtractFilePath(Forms.Application.ExeName) + 'RenamedInf.err';
    if not FileExists(sFileName) then
      exit;
    aList := TStringList.Create();
    aList.LoadFromFile(sFileName);
    aStream := TStringStream.Create(aList.Text);
    TCPClient:= TIdTCPClient.Create(nil);
    fSended := False;

    try
      if not DoTcpConnect(TCPClient, True, True) then
        Exit;

      TCPClient.IOHandler.Writeln('NOT_UPDATED_FILE_ACK');
      TCPClient.IOHandler.Write(aStream , 0, True);
      fSended := True;
      TCPClient.Disconnect;

    finally
      aList.Free;
      aStream.Free;
      TCPClient.Free;
    end;

    if fSended then
      DeleteFile(ExtractFilePath(Forms.Application.ExeName) + 'RenamedInf.err');
  end;
  
  procedure DeleteUpdateTables;
  begin
    Data.RemoveTableFromBase(Data.SysParamTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.BrandTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.GroupTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.GroupBrandTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.CatalogTable.TableName + '_New');
//    Data.RemoveTableFromBase(Data.AnalogTable.TableName + '_New');

    Data.RemoveTableFromBase(Data.AnalogIDTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.AnalogMainTable_1.TableName + '_New');
    Data.RemoveTableFromBase(Data.AnalogMainTable_2.TableName + '_New');
    Data.RemoveTableFromBase(Data.AnalogMainTable_3.TableName + '_New');
    Data.RemoveTableFromBase(Data.AnalogMainTable_4.TableName + '_New');
    Data.RemoveTableFromBase(Data.AnalogMainTable_5.TableName + '_New');

    Data.RemoveTableFromBase(Data.OETable.TableName + '_New');
    Data.RemoveTableFromBase(Data.TableCarFilter.TableName + '_New');
    Data.RemoveTableFromBase(Data.QuantTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.ArtTypTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.KitTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.OOTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.DescriptionTable.TableName + '_New');

    Data.RemoveTableFromBase(Data.ManufacturersTable.TableName + '_New');
 end;

  procedure TableNewToBase(aTable: TDBISAMTable);
  begin
    if FileExists(Data.Data_Path + aTable.TableName + '_New.1') then
    begin
//      aTable.Active := FALSE;
//      aTable.DisableControls;
      Data.RenameTableDBI(aTable.TableName, aTable.TableName + '_Back');
      Data.RenameTableDBI(aTable.TableName + '_New', aTable.TableName);
    end;
  end;

  procedure TableBackToBase(aTable: TDBISAMTable);
  begin
    if FileExists(Data.Data_Path + aTable.TableName + '_Back.1') then
    begin
      Data.RemoveTableFromBase(aTable.TableName);
      Data.RenameTableDBI(aTable.TableName + '_Back', aTable.TableName);
    end;
  end;
  
  procedure ApplyUpdateTables_Catalog(aWithQuants: Boolean);
  var
    UserData: TUserIDRecord;
  begin
    {Необходимо вытащить cli_id для логирования неперименованных файлов}
    if not CheckClientId then
      fClientIdErrNotRenamed := 'Не задан клиент!'
    else
    begin
      UserData := GetCurrentUser;
      fClientIdErrNotRenamed := UserData.sId;
    end;
    {??? Удаляем старый файл ???}
    if FileExists(ExtractFilePath(Forms.Application.ExeName) + 'RenamedInf.err') then
      DeleteFile(ExtractFilePath(Forms.Application.ExeName) + 'RenamedInf.err');

    Data.AllClose;
    Data.CatalogDataSource.DataSet.AfterScroll := nil;

    TableNewToBase(Data.TableCarFilter);
    TableNewToBase(Data.SysParamTable);
    TableNewToBase(Data.BrandTable);
    TableNewToBase(Data.GroupTable);
    TableNewToBase(Data.GroupBrandTable);
    Data.CloseAllCatalogDataSet();
    TableNewToBase(Data.CatalogTable);

//    TableNewToBase(Data.AnalogTable);

    TableNewToBase(Data.AnalogIDTable);
    TableNewToBase(Data.AnalogMainTable_1);
    TableNewToBase(Data.AnalogMainTable_2);
    TableNewToBase(Data.AnalogMainTable_3);
    TableNewToBase(Data.AnalogMainTable_4);
    TableNewToBase(Data.AnalogMainTable_5);

    
//    TableNewToBase(Data.OETable);
    TableNewToBase(Data.OEIDTable);
    TableNewToBase(Data.OEDescrTable);
    
    TableNewToBase(Data.ArtTypTable);
    TableNewToBase(Data.KitTable);
    TableNewToBase(Data.OOTable);
    TableNewToBase(Data.DescriptionTable);
    TableNewToBase(Data.ManufacturersTable);
{
    if aWithQuants then
      TableNewToBase(Data.QuantTable);
}
    try
      try
        Splash := TSplash.Create(Application);
        Splash.InfoLabel.Caption := 'Перезагрузка данных';
        Splash.SplashOnModal;
        Data.AllOpen;
      finally
        if Assigned(Splash) then
          Splash.SplashOff;
      end;
    except
      on E: Exception do
      begin
        MessageDlg('Ошибка обновления: - ' + E.Message + 'Изменения отменены!', mtError, [mbOk], 0);
        Data.AllClose;

        TableBackToBase(Data.TableCarFilter);
        TableBackToBase(Data.SysParamTable);
        TableBackToBase(Data.BrandTable);
        TableBackToBase(Data.GroupTable);
        TableBackToBase(Data.GroupBrandTable);
        TableBackToBase(Data.CatalogTable);
      //  TableBackToBase(Data.AnalogTable);

        TableBackToBase(Data.AnalogIDTable);
        TableBackToBase(Data.AnalogMainTable_1);
        TableBackToBase(Data.AnalogMainTable_2);
        TableBackToBase(Data.AnalogMainTable_3);
        TableBackToBase(Data.AnalogMainTable_4);
        TableBackToBase(Data.AnalogMainTable_5);

       // TableBackToBase(Data.OETable);

        TableBackToBase(Data.OEIDTable);
        TableBackToBase(Data.OEDescrTable);
{
        if aWithQuants then
          TableBackToBase(Data.QuantTable);
}
        TableBackToBase(Data.ArtTypTable);
        TableBackToBase(Data.KitTable);
        TableBackToBase(Data.OOTable);
        TableBackToBase(Data.DescriptionTable);
        Data.AllOpen;
        Exit;
      end;
    end;

    if NewDataVersion <> '' then
    begin
      with Data.VersionTable do
      begin
        Edit;
        FieldByName('DataVersion').Value := NewDataVersion;
        FieldByName('DiscretNumberVersion').Value := strtoint(NewDescretVersion);
        Post;
      end;
      CurrDataVersion := NewDataVersion;
    end;

    Data.RemoveTableFromBase(Data.SysParamTable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.BrandTable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.GroupTable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.GroupBrandTable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.CatalogTable.TableName + '_Back');
//    Data.RemoveTableFromBase(Data.AnalogTable.TableName + '_Back');

    Data.RemoveTableFromBase(Data.AnalogIDTable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.AnalogMainTable_1.TableName + '_Back');
    Data.RemoveTableFromBase(Data.AnalogMainTable_2.TableName + '_Back');
    Data.RemoveTableFromBase(Data.AnalogMainTable_3.TableName + '_Back');
    Data.RemoveTableFromBase(Data.AnalogMainTable_4.TableName + '_Back');
    Data.RemoveTableFromBase(Data.AnalogMainTable_5.TableName + '_Back');

   // Data.RemoveTableFromBase(Data.OETable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.OEIDTable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.OEDescrTable.TableName + '_Back');

    Data.RemoveTableFromBase(Data.TableCarFilter.TableName + '_Back');
{
    if aWithQuants then
      Data.RemoveTableFromBase(Data.QuantTable.TableName + '_Back');
}
    Data.RemoveTableFromBase(Data.ArtTypTable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.KitTable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.OOTable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.DescriptionTable.TableName + '_Back');

    SetImageByLight(INDEX_OF_DATA, True);

    Data.Ign_chars := Data.SysParamTable.FieldByName('Ign_chars').AsString;

    Data.LoadTree;
    Data.CatalogDataSource.DataSet.AfterScroll := Data.CatalogTableAfterScroll;
    SendLogNotRenamedFiles();
  end;

  procedure ApplyUpdateTables_Quants;
  var
    CurrentPath : string;
  begin
    if fLocalMode then
      CurrentPath := Data.GetDomainName + '\'
    else
      CurrentPath := Data.Data_Path;
    if FileExists(CurrentPath + Data.QuantTable.TableName +'_New.1') then
    begin
      Data.LoadingLock;
        try
          Data.QuantTable.Close;
          Data.RenameTableDBI(Data.QuantTable.TableName, Data.QuantTable.TableName + '_Back', True);
          Data.RenameTableDBI(Data.QuantTable.TableName + '_New', Data.QuantTable.TableName, True);
          Data.QuantTable.Open;

          Data.sIDs := sIDs;
          Data.sLatestIDs := sLatestIDs;
          if NewQuantVersion <> '' then
            if not fLocalMode then
            begin
              Data.VersionTable.Edit;
              Data.VersionTable.FieldbyName('QuantVersion').Value := NewQuantVersion;
              Data.VersionTable.Post;
              CurrQuantVersion := NewQuantVersion;
            end
            else
            begin
              CurrQuantVersion := NewQuantVersion;
              with TIniFile.Create(AppStorage.IniFile.FileName) do
              try
                WriteString('Quants', 'Version', NewQuantVersion);
              finally
                Free;
              end;
            end;
          Data.RemoveTableFromBase(Data.QuantTable.TableName + '_Back',true);
        finally
          Data.LoadingUnlock;
        end;

      SetImageByLight(INDEX_OF_QUANTS, True);

      Data.CalcWaitList;
      Data.CatalogDataSource.Dataset.Refresh;
      Data.SetCatFilter; //для обновления если стоял фильтр по остаткам
    end;
  end;

  procedure ApplyNewsChanges;
  begin
    ReloadRunningLine;

    if NewNewsVersion <> '' then
    begin
      Data.VersionTable.Edit;
      Data.VersionTable.FieldbyName('NewsVersion').Value := NewNewsVersion;
      Data.VersionTable.Post;
      CurrNewsVersion := NewNewsVersion;
    end;

    if (FileExists(GetAppDir + Data.AutoMakerTable.TableName + '_New.1')) and (FileExists(GetAppDir + Data.AutoMakerTable.TableName + '_New.2')) then
    begin
      Data.AutoMakerTable.Close;
      Data.RenameTableDBI(Data.AutoMakerTable.TableName, Data.AutoMakerTable.TableName + '_Back', True);
      MoveFile(pChar(GetAppDir + Data.AutoMakerTable.TableName + '_New.1'), pChar(Data.Data_Path + Data.AutoMakerTable.TableName + '.1'));
      MoveFile(pChar(GetAppDir + Data.AutoMakerTable.TableName + '_New.2'), pChar(Data.Data_Path + Data.AutoMakerTable.TableName + '.2'));
//      Data.RenameTableDBI(Data.AutoMakerTable.TableName + '_New', Data.AutoMakerTable.TableName, True);
      Data.RemoveTableFromBase(Data.AutoMakerTable.TableName + '_Back');
      Data.AutoMakerTable.Open;
    end;


  end;

  procedure ApplyUpdateTables_Tires;
  begin
    StartWait;

    try
      Data.TiresCarMake.Close;
      Data.TiresCarModel.Close;
      Data.TiresCarEngine.Close;
      Data.TiresDimensions.Close;
  
      TableNewToBase(Data.TiresCarMake);
      TableNewToBase(Data.TiresCarModel);
      TableNewToBase(Data.TiresCarEngine);
      TableNewToBase(Data.TiresDimensions);

      try
        Data.TiresCarMake.Open;
        Data.TiresCarModel.Open;
        Data.TiresCarEngine.Open;
        Data.TiresDimensions.Open;
          
        if NewTiresVersion <> '' then
        begin
          Data.VersionTable.Edit;
          Data.VersionTable.FieldbyName('TiresVersion').Value := NewTiresVersion;
          Data.VersionTable.Post;
        end;

        Data.RemoveTableFromBase(Data.TiresCarMake.TableName + '_Back');
        Data.RemoveTableFromBase(Data.TiresCarModel.TableName + '_Back');
        Data.RemoveTableFromBase(Data.TiresCarEngine.TableName + '_Back');
        Data.RemoveTableFromBase(Data.TiresDimensions.TableName + '_Back');

      except
        try
          Data.TiresCarMake.Close;
          Data.TiresCarModel.Close;
          Data.TiresCarEngine.Close;
          Data.TiresDimensions.Close;
        except

        end;

        TableBackToBase(Data.TiresCarMake);
        TableBackToBase(Data.TiresCarModel);
        TableBackToBase(Data.TiresCarEngine);
        TableBackToBase(Data.TiresDimensions);
      end;

    finally
      StopWait;
    end;
  end;

  procedure ApplyUpdateTables_Typ;
  begin
    StartWait;

    try
      Data.ArtTypTable.Close;
      TableNewToBase(Data.ArtTypTable);

      try
        Data.ArtTypTable.Open;

        if NewTypVersion <> '' then
        begin
          Data.VersionTable.Edit;
          Data.VersionTable.FieldbyName('TypVersion').Value := NewTypVersion;
          Data.VersionTable.Post;
        end;

        Data.RemoveTableFromBase(Data.ArtTypTable.TableName + '_Back');

      except
        try
          Data.ArtTypTable.Close;
        except

        end;

        TableBackToBase(Data.ArtTypTable);

      end;

    finally
      StopWait;
    end;
  end;

  procedure ApplyUpdateTables_Picts;
    function AppendVersion(aVerOld, aVerAppend: string; aMaxLen: Integer): string;
    begin
      if aVerOld = '' then
        Result := aVerAppend
      else
        Result := aVerOld + ',' + aVerAppend;

      if Length(Result) > aMaxLen then
      begin
        Delete(Result, 1, POS(',', Result));
      end;
      if Length(Result) > aMaxLen then
      begin
        Delete(Result, 1, POS(',', Result));
      end;
    end;
var
    PictsVersionList: TStrings;

  begin
    if NewPictsVersion <> '' then
    begin
      PictsVersionList := TStringList.Create;
      try
        PictsVersionList.Text := Data.VersionTable.FieldbyName('iNewPictsVersion').Value;
        if POS(NewPictsVersion, PictsVersionList.Text) = 0 then
        begin
          PictsVersionList.Append(NewPictsVersion);
          Data.VersionTable.Edit;
          Data.VersionTable.FieldbyName('iNewPictsVersion').Value := PictsVersionList.Text;
          Data.VersionTable.Post;
        end;
        Data.PictTable.Close;
        Data.PictTable.Open;
      finally
        PictsVersionList.Free;
      end;
    end;
  end;

var
  i: Integer;
  anUpdateResult: TUpdateResult;
  aSchedulerState: Boolean;
begin
  //послали message когда поток еще работает
  if Assigned(UpdateThrd) then
  begin
    Assert(False, 'Сообщение PROGRESS_POS_MESSAGE должно быть послано только после завершения потока TUpdateDataThrd');
    Exit;
  end;

  try
    Data.Loading_flag := FALSE;
    CloseStatusColums;
    ShowStatusBarInfo; //проверить что она делает

    //послали message с неизвестным кодом завершения
    if ( Msg.LParam < Ord(Low(TUpdateResult)) ) or
       ( Msg.LParam > Ord(High(TUpdateResult)) ) then
    begin
      Assert(False, 'Сообщение PROGRESS_POS_MESSAGE: передан неизвестный результат завершения потока');
      Exit;
    end;

    anUpdateResult := TUpdateResult(Msg.LParam);
    if anUpdateResult in [urAborted, urFail] then
      DeleteUpdateTables;

    if anUpdateResult = urAborted then
      MessageDlg('Обновление прервано', mtWarning, [mbOk], 0)
    else
    begin
      fRestProgAfterUpdate := TRUE;     //чтобы не выдавало сообщение о закрытии
      ShowUpdateReport(anUpdateResult, fUpdateQueue);
      Application.ProcessMessages;
    end;

    if not (anUpdateResult in [urFully, urPartially]) then
      Exit;

    StartWait;
    try
      //нужные действия для каждого проинсталлированного пакета
      for i := 0 to fUpdateQueue.Count - 1 do
        if fUpdateQueue[i].Installed then
        begin
          case fUpdateQueue[i].PackageType of
            wupData, wupDataDiscret:
            begin
              if fUpdateQueue[i].NewVersions.Count > 1 then
              begin
                NewDataVersion := fUpdateQueue[i].NewVersions[0];
                NewDescretVersion := fUpdateQueue[i].NewVersions[1];
              end;

              aSchedulerState := fScheduler.Enabled;
              fScheduler.Enabled := False;
              try
                ApplyUpdateTables_Catalog(not fUpdateQueue.PackageInstalled(wupQuants)); //??? нужно ли применять не изменяя версию ???
              finally
                fScheduler.Enabled := aSchedulerState;
              end;
            end;

            wupNews:
            begin
              if fUpdateQueue[i].NewVersions.Count > 0 then
                NewNewsVersion := fUpdateQueue[i].NewVersions[0];
              ApplyNewsChanges;
            end;

            wupQuants:
            begin
              if fUpdateQueue[i].NewVersions.Count > 0 then
                NewQuantVersion := fUpdateQueue[i].NewVersions[0];
              ApplyUpdateTables_Quants;
            end;

            wupPictsDiscret:
            begin
              if fUpdateQueue[i].NewVersions.Count > 0 then
                NewPictsVersion := fUpdateQueue[i].NewVersions[0];
              ApplyUpdateTables_Picts;
            end;

            wupTyp:
            begin
              if fUpdateQueue[i].NewVersions.Count > 0 then
                NewTypVersion := fUpdateQueue[i].NewVersions[0];
              ApplyUpdateTables_Typ;
            end;

            wupTires:
            begin
              if fUpdateQueue[i].NewVersions.Count > 0 then
                NewTiresVersion := fUpdateQueue[i].NewVersions[0];
              ApplyUpdateTables_Tires;
            end;

          end;
        end;

    finally
      StopWait;
    end;

    //показываем изменения для дискретного обновления
    if fUpdateQueue.PackageInstalled(wupDataDiscret) then
      if FileExists(Data.Import_Path + 'UpdateInfo.csv') then
      begin
        if Assigned(ChangesInBase) then
        begin
          ChangesInBase.Close;
          ChangesInBase.Free;
          ChangesInBase := nil;
        end;

        TChangesInBase.Execute(Data.Import_Path + 'UpdateInfo.csv');
        //DeleteFile(Data.Import_Path + 'UpdateInfo.csv');
      end;
  finally
    LockAutoUpdate(False);
    UpdateMenu.Visible := True;

    //включаем таймер автообновления
    if (Data.ParamDataSource <> nil) and (not TimerUpdate.Enabled) then
    begin
      if (Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdate').AsBoolean) and
         ((Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdateProg').AsBoolean) or
         (Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdateQuants').AsBoolean))  then
        TimerUpdate.Enabled := True;
    end;

    // CheckProgrammPeriod
    VersionTimer.Enabled := True;
  end;
end;

procedure TMain.SaveAssortmentExpansionProc(bSelectFile:boolean);
var
  fname: string;
  F: TextFile;
  sFilter:String;
  rNo:integer;
  bWrite:boolean;
  sData:string;
  CurDate:TDate;
  sClientID:string;
  sign:integer;
  sFileID:string;
  fileDate:integer;
begin
  if Data.OrderTable.FieldByName('Cli_ID').AsString <> '' then
  begin
    sClientID :=Data.OrderTable.FieldByName('Cli_ID').AsString;
    sFileID := Data.OrderTable.FieldByName('Cli_ID').AsString+'_'+Data.OrderTable.FieldByName('Sign').AsString
  end
  else
  begin
    if not CheckClientID(False) then
      Exit;
    sClientID := GetCurrentUser.sId;

    Randomize;
    sign := RandomRange(1111111, 9999999);
    sFileID:= sClientID+'_'+IntToStr(sign);
  end;

  CurDate := Now;
  sData := '.'+inttostr(YearOf(CurDate));
  if MonthOfTheYear(CurDate) < 10 then
    sData := '.0'+ inttostr(MonthOfTheYear(CurDate))+sData
  else
    sData := '.'+inttostr(MonthOfTheYear(CurDate))+sData;

  if DayOfTheMonth(CurDate) < 10 then
    sData := '0'+ inttostr(DayOfTheMonth(CurDate))+sData
  else
    sData := inttostr(DayOfTheMonth(CurDate))+sData;

  fname:= Data.Export_Path+sFileID+'_'+'0.csv';

  if bSelectFile then
  begin
    with SaveOrderDialog do
    begin
      FileName   := fname;
      if not Execute then
        exit;
      fname := FileName;
    end;
    SetCurrentDir(Data.Data_Path);
  end;
  DeleteFile(fname);

  bWrite := FALSE;
  with Data.WaitListTable do
  begin
    DisableControls;
    rNo := RecNo;
    if Filtered then
        sFilter := Filter
    else
        sFilter := '';

    Filtered := FALSE;
    Filter := 'POST <> 1';
    Filtered := TRUE;

    First;
    while not EOF do
    begin
      if not bWrite then
      begin
        AssignFile(F, fname);
        ReWrite(F);
        fileDate := FileAge(Application.ExeName);
        WriteLn(f,sClientID +';'+DateTimeToStr(FileDateToDateTime(fileDate))+';');
        bWrite := TRUE;
      end;

        //Data
      if FieldByName('Data').AsString = '' then
      begin
        Edit;
        FieldByName('Data').AsString := sData;
        Post;
      end;

      if FieldByName('ArtQuant').AsString <> '' then
      begin
        if FieldByName('ArtQuant').AsString = '0' then
          WriteLn(f,FieldByName('ArtCode').AsString +'_'+FieldByName('Brand').AsString+';'
                  +FieldByName('Data').AsString+';1;'+FieldByName('Quantity').AsString);
      end

      else
          WriteLn(f,FieldByName('ArtCode').AsString +'_'+FieldByName('Brand').AsString+';'
                  +FieldByName('Data').AsString+';2;'+FieldByName('Quantity').AsString);
      Next;
    end;

    if sFilter <> '' then
    begin
      Filter := sFilter;
      Filtered := TRUE;
    end
    else
    begin
      Filtered := FALSE;
      Filter := '';
    end;

    RecNo := rNo;
    EnableControls;
  end;

  with Data.AssortmentExpansion do
  begin
    DisableControls;
    if Filtered then
        sFilter := Filter
    else
        sFilter := '';
    Filtered := FALSE;
    Filter := 'POST <> 1';
    Filtered := TRUE;

    First;
    while not EOF do
    begin
      if not bWrite then
      begin
        AssignFile(F, fname);
        ReWrite(F);
        WriteLn(f,sClientID +';');
        bWrite := TRUE;
      end;
        //Data
      if FieldByName('Date').AsString = '' then
      begin
         Edit;
         FieldByName('Date').AsString := sData;
         Post;
      end;

      if FieldByName('ArtQuant').AsString <> '' then
        begin
        if FieldByName('ArtQuant').AsString = '0' then
        WriteLn(f,FieldByName('ArtCode').AsString +'_'+FieldByName('Brand').AsString+';'
                +FieldByName('Date').AsString+';1;'+FieldByName('Amount').AsString);
        end
      else
        WriteLn(f,FieldByName('Code').AsString +'_'+FieldByName('Brand').AsString+';'
                +FieldByName('Date').AsString+';3;'+FieldByName('Amount').AsString);
      Next;
    end;

    if sFilter <> '' then
    begin
      Filter := sFilter;
      Filtered := TRUE;
    end
    else
    begin
      Filtered := FALSE;
    end;
    RecNo := rNo;
    EnableControls;
  end;

 if bWrite then
   CloseFile(f);
 if not bSelectFile then
 begin
   if not bWrite then
     DeleteFile(fname);
 end
{ нельзя POST = 1 при сохранении расширения ассортимента, только при отправке! }
{ флаг bSelectFile отвечает только за выбор файла сохранения }
 { else
  AllPost;}
end;



function TMain.GetErrorMessage(fSize: Cardinal):string;
var
  FErrorString: PChar;
begin
  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
  nil,
  fSize,
  LANG_USER_DEFAULT,
  @FErrorString,
  0,
  nil
  );
   GetErrorMessage := 'Ошибка №' + inttostr(fSize)+' - '+FErrorString;
   if FErrorString <> nil then
    LocalFree(Integer(FErrorString));
end;


procedure TMain.GoIntoGroupExecute(Sender: TObject);
begin
   //Sele
    with Data.CatalogDataSource.DataSet do
    begin
       Data.Group := FieldByName('Group_id').AsInteger;
       Data.Subgroup := FieldByName('Subgroup_id').AsInteger;
       Data.fBrand := FieldByName('Brand_id').AsInteger;
    end;
   SelectInTree;
end;

//Перейти на позицию 
function TMain.GoToCatID(aCatID: Integer): Boolean;
begin
  Result := False;

  with Data do
  begin
    if aCatID = 0 then
      Exit;

    if CatalogDataSource.DataSet <> CatalogTable then
    begin
      ResetFilter;
      CatalogDataSource.DataSet.DisableControls;
      Result := CatalogDataSource.DataSet.Locate('Cat_Id', aCatID, []);
      CatalogDataSource.DataSet.EnableControls;
      Exit;
    end;

    ResetFilter;
    with SearchTable do
    begin
      if IndexName <> '' then
        IndexName := '';
      if Locate('Cat_id', aCatID, []) then
      begin
        Result := True;
        CatalogTable.GotoCurrent(SearchTable);
        MainGrid.SetFocus;
      end;
      IndexName := 'Code';
    end;
  end;
end;

//message PROGRESS_START_UPDATE - приходит после завершения закачки обновлений
procedure TMain.DoProcessUpdate(var Msg: TMessage);
begin
  UpdateDataError := '';
  CloseStatusColums;
  if Assigned(ListParametrs) then
  begin
    ListParametrs.Free;
    ListParametrs := nil;
  end;

  if Msg.LParam = 10 then
  begin
    UpdateMenu.Visible := TRUE;
    Exit;
  end;

//  if FileExists(Data.Import_Path + 'Update') then
  begin
//    if GetFileSize_Internal(Data.Import_Path + 'Update') < 10 then
//    begin
//      DeleteFile(Data.Import_Path + 'Update');
//      Exit;
//    end;

    if Msg.LParam = 0 then
      with TMessUpdate.Create(nil) do
      try
        ShowModal;
      finally
        Free;
      end;

    if StatusBar.Panels.Count < 7 then
      SetStatusColums(FALSE);

    tmp_path := PrepareTempDirForUpdate;

    UpdateThrd := TUpdateDataThrd.Create(Self.Handle);
    UpdateThrd.OnTerminate := UpdateDataThreadTerminate;
    UpdateThrd.Init(
      fUpdateQueue,
      tmp_path {aTempPath}
    );

    UpdateMenu.Visible := False;
//    MenuToolBar.UpdateMenu;
    Data.Loading_flag := True;

    LockAutoUpdate(True);
    UpdateThrd.Resume;
  end;
end;


procedure TTestInternet.Execute;
var
  sFile: string;
begin
  sFile := Data.GetUpdateUrlDestFile;

  if Main.MainDownLoadFileMirrors(sFile) then
    PostMessage(Main.Handle, MESSAGE_AUTOUPDATE, 0, 1)
  else
    PostMessage(Main.Handle, MESSAGE_AUTOUPDATE, 0, 0);
end;

function TMain.DataNow: string;
var
  sData:string;
  CurDate:TDate;
begin
  CurDate := Now;
  sData := '.'+inttostr(YearOf(CurDate));
  if MonthOfTheYear(CurDate) < 10 then
    sData := '.0'+ inttostr(MonthOfTheYear(CurDate))+sData
  else
    sData := '.'+inttostr(MonthOfTheYear(CurDate))+sData;

  if DayOfTheMonth(CurDate) < 10 then
    sData := '0'+ inttostr(DayOfTheMonth(CurDate))+sData
  else
    sData := inttostr(DayOfTheMonth(CurDate))+sData;

  result := sData;
end;

procedure TMain.DateStartReturnDocChange(Sender: TObject);
begin
  if Data <> nil then
  begin
    //Data.ReturnDocTable.SetRange([DateStartReturnDoc.Date], [DateEndReturnDoc.Date]);
    SelectCurrentUser;
    SetActionEnabled;
  end;
end;

procedure TMain.DeleteFromReturnDocExecute(Sender: TObject);
var
  i,pos, cnt4del : integer;
begin
   //Удаление позиции возврата
   if Data.ReturnDocDetTable.FieldByName('ID').AsString < '1' then
    exit;
   if (Data.ReturnDocTable.FieldByName('Post').AsString <> '1') and
      (Data.ReturnDocTable.FieldByName('Post').AsString <> '0') then
   begin
     MessageDlg('Невозможно удалить позицию из выбранного заказа!!!'+
                   ' Заказ уже был отправлен в офис компании и вероятно уже обработан.'+
                       ' Для проверки зарезервированного товара нажмите кнопку "TCP ответ".',  mtInformation, [mbOK], 0);
     exit;
   end;

   cnt4del := 0;
   pos := Data.ReturnDocDetTable.RecNo;

   if Data.ReturnMasChek.Count > 0 then
   begin
     if (Data.ReturnDocDetTable.FieldByName('Id').AsInteger <> 0) and
        (MessageDlg('Удалить выбранные позиции (' + IntToStr(Data.ReturnMasChek.Count) + ' шт.)?',
         mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
       for i := 0 to Data.ReturnMasChek.Count - 1 do
       begin
         data.ReturnDocDetTable.Locate('ID', Integer(data.ReturnMasChek.Items[i]), []);
         if Data.ReturnDocDetTable.RecNo <= pos then
           inc(cnt4del);
         Data.ReturnDocDetTable.Delete;
       end;
     Data.ReturnDocTableBeforeScroll(Data.ReturnDocDataSource.DataSet);
   end
   else
   if (Data.ReturnDocDetTable.FieldByName('RetDoc_ID').AsInteger <> 0) and
      (MessageDlg('Удалить позицию из возврата?',
              mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
   begin
     Data.ReturnDocDetTable.Delete;
     if Data.ReturnDocDetTable.RecNo <= pos then
       inc(cnt4del);
   end;

  Data.ReturnDocDetTable.RecNo := pos - cnt4del;
end;

procedure TMain.DelFromAssortimentExecute(Sender: TObject);
begin
    //Удаление
     if (Data.AssortmentExpansion.FieldByName('Id').AsInteger <> 0) and
         (MessageDlg('Удалить из списка расширений по ассортименту? Вы Уверены?',
            mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
          begin
            Data.AssortmentExpansion.Delete;
            Data.CalcWaitList;
          end;
end;

procedure TMain.DelReturnDocActionExecute(Sender: TObject);
begin
   //Удаление возврата
   if ((Data.ReturnDocDetTable.RecordCount > 0)and(Data.ParamTable.FieldByName('ToForbidRemovalOrder').AsBoolean)) then
   begin
      MessageDlg('Невозможно удалить возврат! Для удаления возврата необходимо удалить из него все позиции.', mtInformation, [mbOK], 0);
   end
   else
    if (Data.ReturnDocTable.FieldByName('RetDoc_ID').AsInteger <> 0) and
       (MessageDlg('Удалить возврат? Вы Уверены?',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      with Data.ReturnDocDetTable do
      begin
        first;
        while not Eof do
          Delete;
      end;
      Data.ReturnDocTable.Delete;
    end;
end;

// скачивает update.inf с сервера с инфой о доступных обновлениях,
// проверяет версии и формирует список для закачки нужных пакетов
// (либо переадресует эти действия в форму TUpdatesWindows)
procedure TMain.DoAutoUpdateUpdate(var Msg: TMessage);
var
  tmp_path, upd_url, url, sFile: string;
  iniUpdateFile: TIniFile;
  iFile: Integer;
  sLoadFile, localversion, customversion: string;
  aDescretVersion: Integer;
  ErrFile: TextFile;
  bWindow, bUpdate: Boolean;
  UpdateFileData: TUpdateFileData;
  aSectionName, Quants, ErrText: string;
  i, aIndex_data, aIndex_data_d, aIndex_quant: Integer;
begin
  TimerUpdate.Interval := cCheckUpdateInterval;
  TimerUpdate.Enabled := FALSE;
  if Msg.LParam = 0  then
  begin
    TimerUpdate.Enabled := TRUE;
    Exit;
  end;

  try
    if not Data.SysParamTable.Active then
    begin
      TimerUpdate.Enabled := TRUE;
      Exit;
    end;

    ListParametrs := TList.Create;
    bUpdate := TRUE;
    sFile := Data.GetUpdateUrlDestFile;

    //if MainDownLoadFileMirrors(sFile) then //уже скачан
    begin
//      AssignFile(f, Data.Import_Path + 'Update');
      tmp_path := Data.Import_Path;
//      Rewrite(f);
//      CloseFile(f);

      bWindow := False;
      iFile := 1;

      iniUpdateFile := TiniFile.Create(sFile);
      try
        SetImageByLight(INDEX_OF_PROG, True);
        SetImageByLight(INDEX_OF_QUANTS, True);
        SetImageByLight(INDEX_OF_DATA, True);
        
        while iniUpdateFile.ReadString('file'+inttostr(iFile),'customversion','') <> '' do
        begin
          aSectionName := 'file' + IntToStr(iFile);
          {$IFDEF LOCAL}
          if iniUpdateFile.ReadString(aSectionName, 'localversion', '') = 'prog' then
            aSectionName := 'prog_local';
          {$ENDIF}

          {$IFDEF NAVTEST}
          if iniUpdateFile.ReadString(aSectionName, 'localversion', '') = 'prog' then
            aSectionName := 'prog_test';
          {$ENDIF}
          

          if iniUpdateFile.ReadString(aSectionName, 'localversion', '') <> '' then
          begin
            localversion := iniUpdateFile.ReadString(aSectionName, 'localversion','');
            customversion := iniUpdateFile.ReadString(aSectionName, 'customversion', '');
            aDescretVersion := iniUpdateFile.ReadInteger(aSectionName, 'DescretVersion', 0);

            if (localversion = 'prog') and (Data.ParamTable.FieldByName('bPasiveUpdateProg').AsBoolean) then
            begin
              if (TestString(Data.VersionTable.FieldByName('ProgVersion').AsString, customversion))  and (not Data.fTecdocOldest)  then
              begin
                bUpdate := FALSE;
                if Data.ParamTable.FieldByName('iUpdateTypeLoad').AsInteger = 0 then
                begin
                  UpdateFileData := TUpdateFileData.Create;
                  UpdateFileData.State := 1;
                  UpdateFileData.url := iniUpdateFile.ReadString(aSectionName,'url','');
                  UpdateFileData.descr := iniUpdateFile.ReadString(aSectionName,'descr','');
                  UpdateFileData.filesize := iniUpdateFile.ReadInteger(aSectionName,'filesize',0);
                  UpdateFileData.customversion := iniUpdateFile.ReadString(aSectionName,'customversion','');
                  UpdateFileData.localversion := iniUpdateFile.ReadString(aSectionName,'localversion','');
                  UpdateFileData.basename := iniUpdateFile.ReadString(aSectionName,'basename','');
                  UpdateFileData.mustrestart:= iniUpdateFile.ReadInteger(aSectionName,'mustrestart',0);
                  UpdateFileData.DescretVersion:= iniUpdateFile.ReadInteger(aSectionName,'DescretVersion',0);
                  UpdateFileData.bUpdate  := TRUE;
                  ListParametrs.Insert(0, UpdateFileData); //приложение в начало
                  //PostMessage(Main.Handle,PROGRESS_UPDATE_RESTARTPROG,0, DWORD(PChar(SysErrorMessage(GetLastError))));
                  SetImageByLight(INDEX_OF_PROG, False);
                  Break;
                 end
                else
                begin
                  bWindow := TRUE;
                  Break;
                end;
              end;
            end;

            if (localversion = 'quants') and (Data.ParamTable.FieldByName('bPasiveUpdateQuants').AsBoolean) then
            begin
              Quants := Data.VersionTable.FieldByName('QuantVersion').AsString;

              if fLocalMode then
              begin
                with TIniFile.Create(AppStorage.IniFile.FileName) do
                try
                  Quants := ReadString('Quants', 'Version', '120101.1');
                finally
                  Free;
                end;
              end;

              if TestString(Quants,customversion) then
              begin
                bUpdate := FALSE;
                if Data.ParamTable.FieldByName('iUpdateTypeLoadQuants').AsInteger = 0 then
                begin
                  UpdateFileData := TUpdateFileData.Create;
                  UpdateFileData.State := 1;
                  UpdateFileData.url := iniUpdateFile.ReadString(aSectionName,'url','');
                  UpdateFileData.descr := iniUpdateFile.ReadString(aSectionName,'descr','');
                  UpdateFileData.filesize := iniUpdateFile.ReadInteger(aSectionName,'filesize',0);
                  UpdateFileData.customversion := iniUpdateFile.ReadString(aSectionName,'customversion','');
                  UpdateFileData.localversion := iniUpdateFile.ReadString(aSectionName,'localversion','');
                  UpdateFileData.basename := iniUpdateFile.ReadString(aSectionName,'basename','');
                  UpdateFileData.mustrestart:= iniUpdateFile.ReadInteger(aSectionName,'mustrestart',0);
                  UpdateFileData.DescretVersion:= iniUpdateFile.ReadInteger(aSectionName,'DescretVersion',0);
                  UpdateFileData.bUpdate  := TRUE;
                  ListParametrs.Add(UpdateFileData); //остатки в конец списка
                  SetImageByLight(INDEX_OF_QUANTS, False);
                end
                else
                begin
                  bWindow := TRUE;
                  Break;
                end;
              end;
            end;

            if (localversion = 'news') and (Data.ParamTable.FieldByName('bPasiveUpdateQuants').AsBoolean)  and (not Data.fTecdocOldest) then
            begin
              if TestString(Data.VersionTable.FieldByName('NewsVersion').AsString,customversion) then
              begin
                bUpdate := FALSE;
                if Data.ParamTable.FieldByName('iUpdateTypeLoadQuants').AsInteger = 0 then
                begin
                  url := iniUpdateFile.ReadString(aSectionName,'url','');
                  sLoadFile := Data.Import_Path + 'news.zip';
                     // MainDownLoadFile(url,sLoadFile, );
                  {    AssignFile(f,tmp_path+'Update');
                      Append(f);
                      WriteLn(f,localversion);
                      WriteLn(f,sLoadFile);
                      WriteLn(f,customversion);
                      WriteLn(f,'0');
                      CloseFile(f);  }

                  UpdateFileData := TUpdateFileData.Create;
                  UpdateFileData.State := 1;
                  UpdateFileData.url := iniUpdateFile.ReadString(aSectionName, 'url', '');
                  UpdateFileData.descr := iniUpdateFile.ReadString(aSectionName, 'descr', '');
                  UpdateFileData.filesize := iniUpdateFile.ReadInteger(aSectionName, 'filesize', 0);
                  UpdateFileData.customversion := iniUpdateFile.ReadString(aSectionName, 'customversion', '');
                  UpdateFileData.localversion := iniUpdateFile.ReadString(aSectionName, 'localversion', '');
                  UpdateFileData.basename := iniUpdateFile.ReadString(aSectionName, 'basename', '');
                  UpdateFileData.mustrestart:= iniUpdateFile.ReadInteger(aSectionName, 'mustrestart', 0);
                  UpdateFileData.DescretVersion:= iniUpdateFile.ReadInteger(aSectionName, 'DescretVersion', 0);
                  UpdateFileData.bUpdate  := TRUE;
                  ListParametrs.Add(UpdateFileData); //новости в конец списка
                end
                else
                begin
                  bWindow := TRUE;
                  break;
                end;
              end;
            end;

            if ((localversion = 'data') or (localversion = 'data_d')) and (Data.ParamTable.FieldByName('bPasiveUpdateProg').AsBoolean)  and (not Data.fTecdocOldest) then
            begin
              if TestString(Data.VersionTable.FieldByName('DataVersion').AsString, customversion) then
                if (localversion = 'data') or
                   (
                     (localversion = 'data_d') and
                     Data.CanViewDiscretUpdate(Data.VersionTable.FieldByName('DataVersion').AsString) and
                     (Data.VersionTable.FieldByName('DiscretNumberVersion').AsInteger + 1 = aDescretVersion)
                   ) then
              begin
                bUpdate := FALSE;
                if Data.ParamTable.FieldByName('iUpdateTypeLoad').AsInteger = 0 then
                begin
                  //url := iniUpdateFile.ReadString(aSectionName,'url','');
                  //sLoadFile := Data.Import_Path + 'data.zip';
                    //  MainDownLoadFile(url,sLoadFile);
  //                AssignFile(f,tmp_path+'Update');
  //                Append(f);
  //                WriteLn(f,localversion);
  //                WriteLn(f,sLoadFile);
  //                WriteLn(f,customversion);
  //                WriteLn(f,'0');
  //                CloseFile(f);

                  UpdateFileData := TUpdateFileData.Create;
                  UpdateFileData.State := 1;
                  UpdateFileData.url := iniUpdateFile.ReadString(aSectionName, 'url', '');
                  UpdateFileData.descr := iniUpdateFile.ReadString(aSectionName, 'descr', '');
                  UpdateFileData.filesize := iniUpdateFile.ReadInteger(aSectionName, 'filesize', 0);
                  UpdateFileData.customversion := iniUpdateFile.ReadString(aSectionName, 'customversion', '');
                  UpdateFileData.localversion := iniUpdateFile.ReadString(aSectionName, 'localversion', '');
                  UpdateFileData.basename := iniUpdateFile.ReadString(aSectionName, 'basename', '');
                  UpdateFileData.mustrestart:= iniUpdateFile.ReadInteger(aSectionName, 'mustrestart', 0);
                  UpdateFileData.DescretVersion:= iniUpdateFile.ReadInteger(aSectionName, 'DescretVersion', 0);
                  UpdateFileData.bUpdate := TRUE;

                  //данные сразу за программой, но перед всем остальным
                  if (ListParametrs.Count > 0) and (TUpdateFileData(ListParametrs[0]).localversion = 'prog') then
                    ListParametrs.Insert(1, UpdateFileData)
                  else
                    ListParametrs.Insert(0, UpdateFileData);

                  SetImageByLight(INDEX_OF_DATA, False);  
                end
                else
                begin
                  bWindow := TRUE;
                  Break;
                end;
              end;
            end;
          end;
          Inc(iFile);
        end; //while

      finally
        iniUpdateFile.Free;
      end;

      DeleteFile(sFile);
    end;

    if bUpdate then
    begin
      TimerUpdate.Enabled := TRUE;
      Exit;
    end;

    if bWindow then
    begin
      //upd_url := Data.GetUpdateUrl(False); //without proxy args
      upd_url := Data.BuildUpdateUrl(fCurrentWorkingServer, False); //without proxy args
      with TUpdatesWindows.Create(nil) do
      try
        if SetParametrs(Data.Import_Path, upd_url, True{aSilentMode}, False{автоматом доп. обновления не тянутся}) then
          ShowModal;
      finally
        Free;
      end;
      TimerUpdate.Enabled := TRUE;
      Exit;
    end

    else

    begin
      //ListParametrs уже отсортирован как надо: прога -> данные, данные(частичное) -> новости, остатки

      //если в списке есть обновление данных и частичное обновление данных - приоритет отдаем частичному
      aIndex_data := -1;
      aIndex_data_d := -1;
      aIndex_quant := -1;
      //>>вырезать пакет с данными (data, data_d) если есть пакет с остатками (quants)
      for i := 0 to ListParametrs.Count - 1 do
        if TUpdateFileData(ListParametrs[i]).localversion = 'data' then
          aIndex_data := i
        else
          if TUpdateFileData(ListParametrs[i]).localversion = 'data_d' then
            aIndex_data_d := i
        else
          if TUpdateFileData(ListParametrs[i]).localversion = 'quants' then
            aIndex_quant:= i;

      if aIndex_quant >= 0 then
      begin
        TimerUpdate.Interval := 1;
        if aIndex_data_d >= 0 then
          TUpdateFileData(ListParametrs[aIndex_data_d]).bUpdate := False;
        if aIndex_data >= 0 then
          TUpdateFileData(ListParametrs[aIndex_data]).bUpdate := False;
      end
      else
        if ( (aIndex_data_d >= 0) and (aIndex_data >=0) ) then
          TUpdateFileData(ListParametrs[aIndex_data]).bUpdate := False;
     { customversion := '';
      for i := 0 to ListParametrs.Count - 1 do
        if TUpdateFileData(ListParametrs[i]).bUpdate then
          customversion := customversion + TUpdateFileData(ListParametrs[i]).localversion + #13#10;
      ShowMessage(customversion);  }

      bTerminate := FALSE;
      SetStatusColums(TRUE);

      DownloadThrd := TDownloadThread.Create(true);
      DownloadThrd.SetQueue(fUpdateQueue);
      DownloadThrd.ListParametrs := Main.ListParametrs;
      DownloadThrd.sPathUpdate := Data.Import_Path;
      DownloadThrd.bMain := TRUE;
      DownloadThrd.hWin := Handle;
      DownloadThrd.Resume;
    end;

  except //log exception
    on E: Exception do
    begin
      ErrText := E.Message;
      AssignFile(ErrFile,GetAppDir + '!!!.err');
      if FileExists(GetAppDir + '!!!.err') then
        Append(ErrFile)
      else
        ReWrite(ErrFile);
      Writeln(ErrFile,DateTimeToStr(Now) + ' -> ' + ErrText);
      CloseFile(ErrFile);

      TimerUpdate.Enabled := true;
      Exit;
    end;
  end;
end;

procedure TMain.ClearTestQuants;
begin
  if aTestQuantsFilled < 1 then
    Exit;

  if fLocalMode then
    Data.User_Database.Execute(
      'update [010] set TestQuants = 0 where order_id = ' + IntToStr(aTestQuantsFilled)
    )
  else
    Data.Database.Execute(
      'update [010] set TestQuants = 0 where order_id = ' + IntToStr(aTestQuantsFilled)
    );

  aTestQuantsFilled := 0;
  Data.OrderDetTable.Refresh;
end;

procedure TMain.ClearWaitListExecute(Sender: TObject);
begin
  //Очистить лист ожидания.
  if MessageDlg('Удалить все позиции из листа ожидания?', mtInformation, [MBYES, MBNO],0) <> IDYES then
    exit;
  with Data.WaitListTable do
  begin
    while not EOF do
    begin
      Delete;
    end;
    Refresh;
  end;

end;

procedure TMain.AllignToolBars;
begin
  if not fNeedAllignToolBars then //allign bars if ini-file has been reset
    Exit;
  FiltToolBar.Left := SearchToolBar.Left;
end;

procedure TMain.CheckAgrDescr;
begin
  //Data.OrderTable.CancelRange;
  Data.OrderTable.DisableControls;
  Data.ContractsCliTable.CancelRange;
  Data.OrderTable.First;
  while not Data.OrderTable.Eof do
  begin
    Data.OrderTable.Edit;
    if Data.OrderTable.FieldByname('Agreement_No').AsString <> '' then
    begin
      if Data.ContractsCliTable.Locate('Cli_id;Contract_Id',VarArrayOf([
                               Data.OrderTable.FieldByname('cli_id').AsString,
                               Data.OrderTable.FieldByname('Agreement_No').AsString]), []) then

        Data.OrderTable.FieldByname('AgrDescr').AsString := Data.ContractsCliTable.FieldByName('ContractDescr').AsString//Main.GetMaskEdDir
      else
        Data.OrderTable.FieldByname('AgrDescr').AsString := '"Контрагент" не найден!' + Data.OrderTable.FieldByname('Agreement_No').AsString;
    end
    else
    begin
    if Data.ClIDsTable.Locate('Client_id;ContractByDefault',VarArrayOf([
                               Data.OrderTable.FieldByname('cli_id').AsString,
                               Data.OrderTable.FieldByname('Agreement_No').AsString]), []) then
      if Data.ContractsCliTable.Locate('Cli_id;Contract_Id',VarArrayOf([
                               Data.ClIDsTable.FieldByname('client_id').AsString,
                               Data.ClIDsTable.FieldByname('ContractByDefault').AsString]), []) then
        Data.OrderTable.FieldByname('AgrDescr').AsString := Main.GetMaskEdDir;
    end;
    Data.OrderTable.Post;
    Data.OrderTable.Next;
  end;
end;

function TMain.CheckClientId(aShowError: Boolean = True): Boolean;
var
  aUser: TUserIDRecord;
begin
  aUser := GetCurrentUser;
  Result := Assigned(aUser) and (Trim(aUser.sID) <> '');
  if not Result and (aShowError) then
  begin
    Application.MessageBox(
      'Не задан идентификатор клиента! Заполните "идентификатор клиента" (Настройки\Идентификаторы клиента)',
      'Внимание',
      MB_OK or MB_ICONWARNING
    );
  end;
end;

function TMain.CheckTcpDDOS(aWaitTime: Cardinal; aRewriteCallTime: Boolean): Boolean;
begin
{$IFDEF LOCAL}
  aWaitTime := aWaitTime div 4; //для запроса по локалке интервал в 4 раза меньше
{$ENDIF}

  Result := (GetTickCount - fTimeLastCallDiscounts) > aWaitTime;
  if Result and aRewriteCallTime then
    fTimeLastCallDiscounts := GetTickCount;
end;

function TMain.CheckIsServiceOrdered: Boolean;
var
  aCount: string;
begin
  aCount := Data.ExecuteSimpleSelect(
    Format(
      ' SELECT Count(*) FROM [009] ' +
      ' JOIN [010] on ([010].order_id = [009].order_id) ' +
      ' WHERE [009].[Date] = CURRENT_DATE AND ' +
      '       UPPER([010].Code2) = UPPER(%s) AND ' +
      '       UPPER([010].Brand) = UPPER(%s) ',
      [Data.DBEngine.QuotedSQLStr(cServiceProgCode2), Data.DBEngine.QuotedSQLStr(cServiceProgBrand)]
    ),
    [], True
  );

  Result := StrToIntDef(aCount, 0) > 0;
end;

//добавить сервисную в заказ
function TMain.AddServiceToOrder: Boolean;


  function CanAddToCurrentOrder: Boolean;
  begin
    Result := (Data.OrderTable.FieldByName('Order_id').AsInteger <> 0) and //тек. заказ существует
              (Data.OrderTable.FieldByName('Date').AsDateTime = Date()) and //заказ на сегодня
              not //заказ не отправлен
              (
                   (Data.OrderTable.FieldByName('Sent').AsString <> '') and
                   (Data.OrderTable.FieldByName('Sent').AsString <> '0') and
                   (Data.OrderTable.FieldByName('Sent').AsString <> '3')
              );
  end;

  function AddToOrder_internal: Boolean;
  begin
    Result := False;

    Data.GoToSelectItem(cServiceProgCode2, cServiceProgBrand); //переходим на позицию сервисной
    if not SameText(Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString, cServiceProgCode2) then
      Exit; //не нашли сервисную в каталоге

    with Data.OrderDetTable do
    begin
      if not Locate('Order_id;Code2;Brand',
        VarArrayOf([Data.OrderTable.FieldByName('Order_id').AsInteger,
                    Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString,
                    Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString]), []) then
      begin
        Append;
        FieldByName('Order_id').Value := Data.OrderTable.FieldByName('Order_id').AsInteger;
        FieldByName('Code2').Value := Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString;
        FieldByName('Brand').Value := Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString;
        FieldByName('Price').Value := Data.CatalogDataSource.DataSet.FieldByName('Price_koef_eur').AsCurrency;
        //price_pro???
        CalcProfitPriceForOrdetDetCurrent;
      end
      else
        Edit;
      FieldByName('Quantity').Value := 1;
      Post;
    end;

    with Data.OrderTable do
    begin
      Edit;
      FieldByName('Dirty').Value := True;
      Post;
      Refresh;
    end;

    Data.OrderTableAfterScroll(Data.OrderTable);
    if Data.CatalogDataSource.DataSet.Active then
      Data.CatalogDataSource.DataSet.Refresh;

    Result := True;
  end;

begin
  Result := False;
  if not CheckClientId then //ensure that client ID is assigned
    Exit;

  if CheckIsServiceOrdered then //уже заказана
  begin
    Result := True;
    Exit;
  end;

  if not CanAddToCurrentOrder then
  begin
    if not NewOrder then
      Exit;
    Result := CanAddToCurrentOrder; //удостоверимся что заказ создался
  end
  else
    Result := True;

  if Result then
    Result := AddToOrder_internal;
end;

procedure TMain.UpdateDataThreadTerminate(Sender: TObject);
var
  aThread: TUpdateDataThrd;
begin
  if (Sender is TUpdateDataThrd) then
  begin
    aThread := (Sender as TUpdateDataThrd);

    if aThread.UpdateResult = urFail then
      Self.UpdateDataError := aThread.ErrorMessage;

    //удаляем временные файлы
    EraseDirFiles(aThread.TmpPath, False);

    if (aThread.FreeOnTerminate) and (Self.UpdateThrd = aThread) then
      Self.UpdateThrd := nil;

    //message для применения обновления (переименование таблиц, установка версий и тд)
    PostMessage(aThread.OwnerHandle, PROGRESS_POS_MESSAGE, 0, Integer(aThread.UpdateResult));
  end;
end;

procedure TMain.UpdateUserData(aUserData: TUserIDRecord);
begin
  with Table do
  begin
    Open;
    First;
    if Locate('ID', aUserData.iID, []) then
    begin
      aUserData.iID := FieldByName('ID').AsInteger;
      aUserData.sId := FieldByName('Client_ID').AsString;
      aUserData.sName := FieldByName('Description').AsString;
      aUserData.sOrderType := FieldByName('Order_type').AsString;
      aUserData.iDelivery := FieldByName('Delivery').AsInteger;
      aUserData.sEMail := FieldByName('email').AsString;
      aUserData.sKey := FieldByName('Key').AsString;
      aUserData.bUpdateDisc := FieldByName('UpdateDisc').AsBoolean;
      aUserData.DiscountVersion := FieldByName('DiscountVersion').AsInteger;
      aUserData.UseDiffMargin := FieldByName('UseDiffMargin').AsBoolean;
      aUserData.DiffMargin := FieldByName('DiffMargin').AsString;
      //new
      aUserData.DiscVersion := FieldByName('DiscVersion').AsInteger;
      aUserData.AddresVersion := FieldByName('AddresVersion').AsInteger;
      aUserData.AgrVersion := FieldByName('AgrVersion').AsInteger;

      aUserData.ContractByDefault := FieldByName('ContractByDefault').AsString;
      aUserData.AddresByDefault := FieldByName('AddresByDefault').AsString;
    end;
    Close;
  end;
end;

procedure TMain.LockAutoUpdate(aLock: Boolean);
begin
  fAutoUpdateLocked := aLock;
end;


procedure TMain.CliChangeTimerTimer(Sender: TObject);
var
  UserData: TUserIDRecord;
  aNewDiscVer: Integer;
begin
  if Data.fDatabaseOpened then
  begin
    CliChangeTimer.Enabled := False;
    Data.OrderDataSource.DataSet.DisableControls;
    Data.OrderDetDataSource.DataSet.DisableControls;
    Data.OrderDataSource.DataSet := nil;
    Data.OrderDetDataSource.DataSet := nil;
    try
      {$IFDEF LOCAL}
      if fAutoLoadDiscounts then
      begin
        UserData := GetCurrentUser;
        if Assigned(UserData) then
        begin
          if LoadDescriptionsTCP(ReplaceLeftSymbol(UserData.sId), ReplaceLeftSymbolAB(UserData.sKey), inttostr(UserData.DiscountVersion), aNewDiscVer) = 1 then
            UpdateUserData(UserData);
        end;
      end;
      {$ENDIF}

      SelectCurrentUser;

      {$IFNDEF LOCAL}
        Data.SetCurrencyByRegionCode('', Data.Database.DatabaseName);
      {$ENDIF}

      Data.SetPriceKoef;
      ShowStatusbarInfo;
    finally
      Data.OrderDataSource.DataSet := Data.OrderTable;
      Data.OrderDetDataSource.DataSet := Data.OrderDetTable;
      Data.OrderDataSource.DataSet.EnableControls;
      Data.OrderDetDataSource.DataSet.EnableControls;
      ZakTabInfo;
    end;
  end;
end;

procedure TMain.SetActiveCli(ActiveCli : TUserIDRecord);
var
  aNewDiscVer: Integer;
begin
  CliChangeTimer.Enabled := false;
  {$IFDEF LOCAL}
  if fAutoLoadDiscounts then
  begin
    if Assigned(ActiveCli) then
    begin
      if LoadDescriptionsTCP(ReplaceLeftSymbol(ActiveCli.sId), ReplaceLeftSymbolAB(ActiveCli.sKey), inttostr(ActiveCli.DiscountVersion), aNewDiscVer) = 1 then
        UpdateUserData(ActiveCli);

    end;
  end;
  {$ENDIF}
  
  SelectCurrentUser;
  Data.SetPriceKoef;
  ShowStatusbarInfo;
end;

procedure TMain.CliComboBoxChange(Sender: TObject);
begin
  CliChangeTimer.Enabled := False;
  CliChangeTimer.Enabled := True;
end;

procedure TMain.CliComboBoxCloseUp(Sender: TObject; Accept: Boolean);
begin
  if CliComboBox.KeyValue = NULL then
    if fLastDefaultUserID <> '' then
      CliComboBox.KeyValue := fLastDefaultUserID;
end;

procedure TMain.CliComboBoxExit(Sender: TObject);
begin
  if CliComboBox.KeyValue = NULL then
    if fLastDefaultUserID <> '' then
      CliComboBox.KeyValue := fLastDefaultUserID;
end;

//подготавливает временную папку для распаковки обновлений
//создает если не существует, иначе очищает
function TMain.PrepareTempDirForUpdate: string;
begin
  Result := IncludeTrailingPathDelimiter(GetTmpDir + TMP_DIR_NAME);
  if not DirectoryExists(Result) then
    ForceDirectories(Result) //создаем директорию с поддиректориями
  else
    EraseDirFiles(Result, False); //очищаем

  //удостоверимся
  if not DirectoryExists(Result) then
    raise Exception.CreateFmt('Невозможно создать временную папку "%s"', [Result]);
end;

procedure TMain.RecalcProgrammPeriod;
begin
  if CurrDataVersion <> '' then
    Prog_period := Trunc(Date) - Trunc(EncodeDate(2000 + StrInt(Copy(CurrDataVersion, 1, 2)),
                                       StrInt(Copy(CurrDataVersion, 3, 2)),
                                       StrInt(Copy(CurrDataVersion, 5, 2))))
  else
    Prog_period := 0;
  rest_days := Data.SysParamTable.FieldByName('Act_period').AsInteger - Prog_period;
end;

procedure TMain.RedrawTitleImageList;

  function FindCol(const aFieldName: string): TColumnEh;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to MainGrid.Columns.Count - 1 do
      if SameText(MainGrid.Columns[i].FieldName, aFieldName) then
      begin
        Result := MainGrid.Columns[i];
        Break;
      end;
  end;

var
  aBmp: TBitMap;
  aCol: TColumnEh;
  aIndex: Integer;
begin
  aCol := FindCol('Quantity');
  if Assigned(aCol) and (aCol.Title.ImageIndex >= 0) then
  begin
    aBmp := TBitMap.Create;
    try
      aBmp.Width := TitleImageList2.Width;
      aBmp.Height := TitleImageList2.Height;

      aIndex := aCol.Title.ImageIndex;
      aBmp.Canvas.Brush.Color := clFuchsia;
      aBmp.Canvas.FillRect(RECT(0, 0, aBmp.Width, aBmp.Height));
      TitleImageList2.Draw(aBmp.Canvas, 0, 0, aIndex);
      TitleImageList2.Delete(aIndex);
      aBmp.Canvas.Font.Assign(aCol.Title.Font);
      aBmp.Canvas.Brush.Style := bsClear;
      aBmp.Canvas.TextOut(13, 1, aCol.Title.Caption);
      TitleImageList2.InsertMasked(aIndex, aBmp, aBmp.Canvas.Pixels[1, 1]);
    finally
      aBmp.Free;
    end;

    aBmp := TBitMap.Create;
    try
      aBmp.Width := TitleImageList2.Width;
      aBmp.Height := TitleImageList2.Height;

      aIndex := aCol.Title.ImageIndex + 1;
      aBmp.Canvas.Brush.Color := clFuchsia;
      aBmp.Canvas.FillRect(RECT(0, 0, aBmp.Width, aBmp.Height));
      TitleImageList2.Draw(aBmp.Canvas, 0, 0, aIndex);
      TitleImageList2.Delete(aIndex);
      aBmp.Canvas.Font.Assign(aCol.Title.Font);
      aBmp.Canvas.Brush.Style := bsClear;
      aBmp.Canvas.TextOut(13, 1, aCol.Title.Caption);
      TitleImageList2.InsertMasked(aIndex, aBmp, aBmp.Canvas.Pixels[1, 1]);
    finally
      aBmp.Free;
    end;
  end;

end;

//проверка периода действия программы
//Result: 0-OK, 1-предупреждение, 2-закончился
function TMain.CheckProgrammPeriod(aRecalcBefore: Boolean): Integer;
begin
  Result := 0;

  if aRecalcBefore then
    RecalcProgrammPeriod;

  if Prog_period > Data.SysParamTable.FieldByName('Act_period').AsInteger then
    Result := 2
  else
    if Prog_period > (Data.SysParamTable.FieldByName('Act_period').AsInteger -
                      Data.SysParamTable.FieldByName('Act_warn_period').AsInteger) then
      Result := 1;
end;


procedure TMain.MainGridTitleBtnClick(Sender: TObject; ACol: Integer;
  Column: TColumnEh);
begin
  {if SameText(Column.FieldName, 'USA') then
  begin
    UsaCheckBox.Checked := not UsaCheckBox.Checked;
    UsaCheckBoxClick(UsaCheckBox);
  end
  else if SameText(Column.FieldName, 'New') then
  begin
    NewCheckBox.Checked := not NewCheckBox.Checked;
    NewCheckBoxClick(NewCheckBox);
  end
  else} if SameText(Column.FieldName, 'Quantity') then
  begin
    WithQuants.Checked := not WithQuants.Checked;
    WithQuantsClick(WithQuants);
  end;
end;


procedure TMain.MainMenuChange(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
begin
  ShiftMainMenu();
end;

function TMain.GetMaskEdDir: string;
begin
  Result := Data.ContractsCliTable.FieldByName('ContractDescr').AsString;
end;

function TMain.GetMirrorsList: TStrings;
var
  i, p: Integer;
begin
  if Assigned(fUpdateMirrors) then
  begin
    Result := fUpdateMirrors;
    Exit;
  end;

  fUpdateMirrors := TStringList.Create;

  //format: <priority_1>=<mirror_url_1>,<priority_2>=<mirror_url_2>
  //e.g. 0=http://shate-m.com/data/service
  fUpdateMirrors.CommaText := Data.SysParamTable.FieldByName('UpdateMirrors').AsString;
  (fUpdateMirrors as TStringList).Sort;
  for i := fUpdateMirrors.Count - 1 downto 0 do
  begin
    p := POS('=', fUpdateMirrors[i]);
    if p > 0 then
      fUpdateMirrors[i] := Copy(fUpdateMirrors[i], p + 1, MaxInt)
    else
      fUpdateMirrors.Delete(i);
  end;
end;

function TMain.GetOrderDescription(anOrderId: Integer): string;
//var
//  fQueryUserMode: TDBISAMQuery;
begin
  Result := '';
//  fQueryUserMode := TDBISAMQuery.Create(nil);
  fQueryUserMode.SQL.Text :=
      ' SELECT Date, Num, Type FROM [009] ' +
      ' WHERE Order_id = ' + IntToStr(anOrderId);
    fQueryUserMode.Open;

    if not fQueryUserMode.Eof then
      Result := fQueryUserMode.FieldByName('Date').AsString + '  -  №' + fQueryUserMode.FieldByName('Num').AsString + '(' + fQueryUserMode.FieldByName('Type').AsString + ')';
    fQueryUserMode.Close;
end;

function TMain.GetRetdocDescription(aRetdocId: Integer): string;
//var
//  fQueryUserMode: TDBISAMQuery;
begin
  Result := '';
  fQueryUserMode.SQL.Text :=
      ' SELECT Data, Num, Type FROM [036] ' +
      ' WHERE Retdoc_id = ' + IntToStr(aRetdocId);
  fQueryUserMode.Open;

  if not fQueryUserMode.Eof then
    Result := fQueryUserMode.FieldByName('Data').AsString + '  -  №' + fQueryUserMode.FieldByName('Num').AsString + '(' + fQueryUserMode.FieldByName('Type').AsString + ')';

  fQueryUserMode.Close;
end;

procedure TMain.TaskDiscountsBeforeRun(Sender: TObject; var aCanRun: Boolean);
var
  aData: TDiscountsTaskData;
  aUser: TUserIDRecord;
begin
  if Sender is TTaskDiscounts then
  begin
    aUser := GetCurrentUser;
    aCanRun := Assigned(aUser) and (not aUser.bUpdateDisc);
    if aCanRun then
    begin
      ZeroMemory(@aData, SizeOf(TDiscountsTaskData));

      aData.Host1 := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
      aData.Port1 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

      aData.Host2 := Data.SysParamTable.FieldByName('Host').AsString;
      aData.Port2 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

      aData.Host3 := Data.SysParamTable.FieldByName('BackHost').AsString;
      aData.Port3 := Data.SysParamTable.FieldByName('PortB2BIn').AsInteger;

      aData.ClientID := aUser.sId;
      aData.PrivateKey := aUser.sKey;
      aData.DiscountsVersion := aUser.DiscountVersion;

      (Sender as TTaskDiscounts).SetTaskData(aData);
    end;
  end;
end;

procedure TMain.TaskF7AfterEnd(Sender: TObject);
var
  aTask: TTaskF7;
  sValue, sCode, sBrand, sF7Result: string;
  WaitList: TStringList;
  Steam: TStringStream;
  i: integer;
begin
  if Sender is TTaskF7 then
  begin
    aTask := Sender as TTaskF7;

    Main.TimerAskQuants.Enabled := True;

    if not aTask.HasResult then
    begin
      if aTask.GetErrorText <> '' then
        MessageDlg(aTask.GetErrorText, mtError, [mbOK], 0);
      Exit;
    end;

    sValue := aTask.GetResult;
    if sValue = '-1' then
    begin
      MessageDlg('Сервер временно недоступен! Повторите попытку по позже.', mtError, [mbOK], 0);
      Exit;
    end;

     //!!!!!!!!!!!!!!!!!!!!!!!!!
    if sValue = 'LIST_OF_VALUE' then
    begin
      Steam := TStringStream.Create('');
      try
        Steam := aTask.GetResultStream;
        if Steam.Size> 0 then
        begin
          Steam.Position := 0;
          WaitList := TStringList.Create();
          try
            WaitList.LoadFromStream(Steam);
            for i := 0 to WaitList.Count - 1 do
            begin
              sF7Result := WaitList.ValueFromIndex[i];
              Data.DecodeCodeBrand(WaitList.Names[i], sCode, sBrand);
              if Data.WaitListTable.Locate('Code2;Brand', VarArrayOf([sCode, sBrand]), []) then
              begin
                Data.WaitListTable.Edit;
                Data.WaitListTable.FieldByName('NearestRestocking').AsString := sF7Result;
                Data.WaitListTable.Post;
              end;
            end;
          finally
            WaitList.Free;
          end;
        end;
      finally
        Steam.Free;
      end;
    end
  end;
end;

procedure TMain.TaskF7BeforeRun(Sender: TObject; var aCanRun: Boolean);
var
  aData: TF7TaskData;
  WaitList: TStringLIst;
begin
  if Sender is TTaskF7 then
  begin
    aCanRun := False;
    
    if not Main.CheckClientID then
      Exit;
    WaitList := TStringList.Create();
    try
      aData.Host1 := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
      aData.Port1 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

      aData.Host2 := Data.SysParamTable.FieldByName('Host').AsString;
      aData.Port2 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

      aData.Host3 := Data.SysParamTable.FieldByName('BackHOST').AsString;
      aData.Port3 := Data.SysParamTable.FieldByName('PortB2BIn').AsInteger;

      aData.aClientID := Main.GetCurrentUser.sId;
      aData.aCodeBrand := 'Does_not_matter';

      Data.WaitListTable.First;
      while not Data.WaitListTable.Eof do
      begin
        WaitList.Append(Data.WaitListTable.FieldByName('ArtCode').Asstring + '_' +
                        Data.WaitListTable.FieldByName('Brand').AsString);
        Data.WaitListTable.Next;                        
      end;

      aData.aCodeBrandsStream := TStringStream.Create(WaitList.Text);
      aData.aCheckOrderOnly := fCheckOrderOnly;

      (Sender as TTaskF7).SetTaskData(aData);
      aCanRun := True;
    finally
      WaitList.Free;
    end;
  end;
  fCheckOrderOnly := False;     
end;

procedure TMain.TaskDirectoryAfterEnd(Sender: TObject);
var
  aStreamZipped: TMemoryStream;
  aNewVersion: Integer;
  FileName, LogMsg, Key, Cli_id: string;
  UserData: TUserIDRecord;
  aReader: TCSVReader;
  fNewValue: Boolean;
  aStream: TMemoryStream;
begin
  fNewValue := False;
  if not Data.fDatabaseOpened then //может в этот момент применяется обновление
    Exit;
  FileName := IncludeTrailingPathDelimiter(GetTmpDir + TMP_DIR_NAME);
  UserData := GetCurrentUser;
  StartWait;
  if not DirectoryExists(FileName) then
    ForceDirectories(FileName);

  if (CheckUpdateDir = 33) then //>> в таблицы памяти
  begin
    if FormOpen('ClientIDs') then
    begin
      Key := MemKeyCli;
      Cli_ID := MemClientID;
      Data.ClIDsTable.Locate('client_id',Cli_ID,[]);
    end
    else
    begin
      Key := DataSource.DataSet.FieldByName('Key').AsString;
      Cli_ID := DataSource.DataSet.FieldByName('Client_id').AsString;
    end;

    if (Sender is TTaskDirectory) then
    begin
      if (((Sender as TTaskDirectory).HasNewAdd) = 3) then
      begin
        aStreamZipped := TMemoryStream.Create;
        try
          (Sender as TTaskDirectory).GetAddr(aStreamZipped, aNewVersion);
          if aStreamZipped.Size > 0 then
          begin
            UnzipStream2File(aStreamZipped, FileName + '1.csv', 'address', key);
            aReader := TCSVReader.Create;
            if not FileExists(FileName+ '1.csv') then
              Exit;
            try
              memAddres.Close;
              memAddres.EmptyTable;
              aReader.Open(FileName+ '1.csv');
              memAddres.Open;
              while not aReader.Eof do
              begin
                try
                  aReader.ReturnLine;
                  memAddres.Append;
                  memAddres.FieldByName('Addres_Id').AsString := aReader.Fields[0];
                  memAddres.FieldByName('Descr').AsString := aReader.Fields[1];
                  memAddres.FieldByName('Addres').AsString := aReader.Fields[2];
                  memAddres.FieldByName('Cli_Id').AsString := Cli_ID;
                  memAddres.Post;
                  fNewValue := true;
                except
                  memAddres.Cancel;
                end;
              end;
              memAddres.Close;
            finally
              aReader.Close;
              DeleteFile(FileName+ '1.csv');
              if fNewValue then
                LogMsg := '- Справочник адресов успешно обновлен;'+ #13#10;
              fNewValue := False;
            end;
          end;
        finally
          aStreamZipped.Free;
        end
      end
      else
        if (Sender as TTaskDirectory).HasNewAdd <> 0 then
          LogMsg := 'Не удалось обновить справочник адресов. ' + ErrorMsgDir((Sender as TTaskDirectory).HasNewAdd);
    end;

    if (Sender is TTaskDirectory) then
    begin
      if (((Sender as TTaskDirectory).HasNewAgr)= 3) then
      begin
        aStreamZipped := TMemoryStream.Create;
        try
          (Sender as TTaskDirectory).GetAgr(aStreamZipped, aNewVersion);
          if aStreamZipped.Size > 0 then
          begin
            UnzipStream2File(aStreamZipped, FileName + '2.csv', 'agreements', key);

            if not FileExists(FileName+ '2.csv') then
              Exit;
            try
              memAgr.Close;
              memAgr.EmptyTable;
              aReader.Open(FileName+ '2.csv');
              memAgr.Open;
              while not aReader.Eof do
              begin
                try
                  aReader.ReturnLine;
                  memAgr.Append;
                  memAgr.FieldByName('Contract_Id').AsString :=aReader.Fields[0];
                  memAgr.FieldByName('ContractDescr').AsString :=aReader.Fields[1];
                  memAgr.FieldByName('Group').AsString :=aReader.Fields[2];
                  memAgr.FieldByName('Currency').AsString :=aReader.Fields[3];
                  memAgr.FieldByName('Method_Id').AsString :=aReader.Fields[4];
                  memAgr.FieldByName('MethodDescr').AsString :=aReader.Fields[5];
                  memAgr.FieldByName('Payment_id').AsString :=aReader.Fields[6];
                  memAgr.FieldByName('PaymentDescr').AsString :=aReader.Fields[7];
                  memAgr.FieldByName('PriceList_id').AsString :=aReader.Fields[8];
                  memAgr.FieldByName('PriceListDescr').AsString :=aReader.Fields[9];
                  memAgr.FieldByName('DiscountCliGroup').AsString :=aReader.Fields[10];
                  memAgr.FieldByName('DiscountCliGroupDescr').AsString :=aReader.Fields[11];
                  memAgr.FieldByName('LegalPerson').AsString :=aReader.Fields[12];
                  memAgr.FieldByName('Addres_Id').AsString :=aReader.Fields[13];
                  memAgr.FieldByName('IS_MULTICURR').AsBoolean := aReader.Fields[14] = '1'; //мультивалютный договор
                  memAgr.FieldByName('RegionCode').AsString := aReader.Fields[15];
                  memAgr.FieldByName('Cli_id').AsString := Cli_ID;
                  memAgr.Post;
                  fNewValue := True;
                except
                  memAgr.Cancel;
                end;
              end;
              memAgr.Close;
            finally
              aReader.Close;
              DeleteFile(FileName+ '2.csv');
              if fNewValue then
                LogMsg := LogMsg + '- Справочник контрагентов успешно обновлен;'+ #13#10;
            end;
          end;
        finally
          aStreamZipped.Free;
        end;
      end
      else
        if (Sender as TTaskDirectory).HasNewAgr <> 0 then
          LogMsg := LogMsg + 'Не удалось обновить справочник контрагентов. ' + ErrorMsgDir((Sender as TTaskDirectory).HasNewAgr);
    end;

    if (Sender is TTaskDirectory) then
    begin
      if (((Sender as TTaskDirectory).HasNewDis) = 3) then
      begin
        aStreamZipped := TMemoryStream.Create;
        aStream := TMemoryStream.Create;
        try
          (Sender as TTaskDirectory).GetDisc(aStreamZipped, aNewVersion);
          if aStreamZipped.Size > 0 then
          begin
//            UnzipStream2File(aStreamZipped, 'e:\3.csv', 'discounts', Datasource.Dataset.FieldByName('key').AsString);
            UnzipStream2Stream(aStreamZipped, aStream,'discounts', Key);
            ApplyDiscounts2DB(aStream, Cli_id, aNewVersion,True, mem038);
            LogMsg := LogMsg + '- Справочник скидок успешно обновлен;'+ #13#10;
          end;
        finally
          aStreamZipped.Free;
          aStream.Free;
        end;
      end
      else
        if (Sender as TTaskDirectory).HasNewDis <> 0 then
          LogMsg := LogMsg + 'Не удалось обновить справочник скидок. ' + ErrorMsgDir((Sender as TTaskDirectory).HasNewDis);
    end;

    if LogMsg <>'' then
      MessageDlg('Произведено обновление справочников:'+ #13#10 + LogMsg, mtInformation, [mbOK], 0)
{    else
      MessageDlg('Ошибка сервера. Попробуйте загрузить справочники с помощью '+
                 'клавиши "Загрузить справочники" в главном меню программы (Напротив выбора валют)', mtError,[mbOK],0);}
  end

  else //if CheckUpdateDir = 1 then

  begin
    if (Sender is TTaskDirectory) then
    begin
      if ((Sender as TTaskDirectory).HasNewAdd) = 3 then
      begin
        aStreamZipped := TMemoryStream.Create;
        try
          (Sender as TTaskDirectory).GetAddr(aStreamZipped, aNewVersion);
          if aStreamZipped.Size > 0 then
          begin
            UnzipStream2File(aStreamZipped, FileName + '1.csv', 'address', UserData.sKey);
            NewImportNav(FileName + '1.csv','Address');//импорт из zip в БД + апнуть версию
            LogMsg :='- Обновлен справочник адресов';
            if Data.ClIDsTable.Locate('Client_id',UserData.sId,[]) then
            begin
              Data.ClIDsTable.Edit;
              Data.ClIDsTable.FieldByName('AddresVersion').AsInteger := aNewVersion;
              Data.ClIDsTable.Post;
            end;
          end;
        finally
          aStreamZipped.Free;
        end;
      end

      else
      if (Sender as TTaskDirectory).HasNewAdd <> 0 then
        LogMsg := LogMsg + 'Не удалось обновить справочник адресов. ' +ErrorMsgDir((Sender as TTaskDirectory).HasNewAdd);
    end;

    if (Sender is TTaskDirectory) then
    begin
      if ((Sender as TTaskDirectory).HasNewAgr) = 3 then
      begin
        aStreamZipped := TMemoryStream.Create;
        try
          (Sender as TTaskDirectory).GetAgr(aStreamZipped, aNewVersion);
          if aStreamZipped.Size > 0 then
          begin
            UnzipStream2File(aStreamZipped, FileName + '2.csv', 'agreements', UserData.sKey);
            NewImportNav(FileName + '2.csv', 'Agreements');//импорт из zip в БД + апнуть версию
            if LogMsg <> '' then
              LogMsg :=LogMsg + #13#10 + '- Обновлен справочник контрагентов'
            else
              LogMsg := '- Обновлен справочник контрагентов';
            if Data.ClIDsTable.Locate('Client_id',UserData.sId,[]) then
            begin
              Data.ClIDsTable.Edit;
              Data.ClIDsTable.FieldByName('AgrVersion').AsInteger := aNewVersion;
              Data.ClIDsTable.Post;
            end;
          end;
        finally
          aStreamZipped.Free;
        end;
      end
      else
      if (Sender as TTaskDirectory).HasNewAgr <> 0 then
        LogMsg := LogMsg + 'Не удалось обновить справочник контрагентов. ' + ErrorMsgDir((Sender as TTaskDirectory).HasNewAgr);
    end;

    if (Sender is TTaskDirectory) then
    begin
      if ((Sender as TTaskDirectory).HasNewDis) = 3 then
      begin
        aStreamZipped := TMemoryStream.Create;
        aStream := TMemoryStream.Create;
        try
          (Sender as TTaskDirectory).GetDisc(aStreamZipped, aNewVersion);
          if aStreamZipped.Size > 0 then
          begin
            UnzipStream2Stream(aStreamZipped, aStream,'discounts', UserData.sKey);
//            aStream.SaveToFile('E:\1.txt');
            ApplyDiscounts2DB(aStream, UserData.sId, aNewVersion);
            if LogMsg <> '' then
              LogMsg :=LogMsg + #13#10 + '- Обновлен справочник скидок'
            else
              LogMsg := '- Обновлен справочник скидок';
            if Data.ClIDsTable.Locate('Client_id',UserData.sId,[]) then
            begin
              Data.ClIDsTable.Edit;
              Data.ClIDsTable.FieldByName('DiscVersion').AsInteger := aNewVersion;
              Data.ClIDsTable.Post;
            end;
          end;
        finally
          aStreamZipped.Free;
          aStream.Free;
        end;
     end
     else
     if (Sender as TTaskDirectory).HasNewDis <> 0 then
       LogMsg := LogMsg + 'Не удалось обновить справочник скидок. ' + ErrorMsgDir((Sender as TTaskDirectory).HasNewDis);
    end;

    if (length(LogMsg) > 1) and (fClickedBtnUpdate or Data.ParamTable.FieldByName('bNotifyEvent').AsBoolean) then
      RaiseNotifyEvent('Произведено обновление справочников:'+ #13#10 + LogMsg, 'Уведомление', netDirectory,ReplaceStr(LogMsg,'- ',''));
    fClickedBtnUpdate := False;  
  end;

  StopWait;
  CheckUpdateDir := 1;
  Table.Active := True;
end;


procedure TMain.TaskDirectoryBeforeRun(Sender: TObject; var aCanRun: Boolean);
var
  aData: TDirectoryTaskData;
  aUser: TUserIDRecord;
begin
  if Sender is TTaskDirectory then
  begin
    aUser := GetCurrentUser;
    aCanRun := Assigned(aUser); //and (not aUser.bUpdateDisc);
    if aCanRun or (CheckUpdateDir = 33)then
    begin
      aCanRun := TRUE;
      ZeroMemory(@aData, SizeOf(TDirectoryTaskData));

      aData.Host1 := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
      aData.Port1 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

      aData.Host2 := Data.SysParamTable.FieldByName('Host').AsString;
      aData.Port2 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

      aData.Host3 := Data.SysParamTable.FieldByName('BackHost').AsString;
      aData.Port3 := Data.SysParamTable.FieldByName('PortB2BIn').AsInteger;

      if (CheckUpdateDir <> 33) then
      begin
        aData.ClientID := aUser.sId;
        aData.PrivateKey := aUser.sKey;
        aData.NeedUpdateDiscounts := not aUser.bUpdateDisc;
        aData.DiscVersion := aUser.DiscVersion;
        aData.AddresVersion := aUser.AddresVersion;
        aData.AgrVersion := aUser.AgrVersion;
      end

      else if (CheckUpdateDir = 33) then
      begin
        if FormOpen('ClientIDs') then
        begin
          aData.PrivateKey := MemKeyCli;
          aData.ClientID := MemClientID;
          aData.NeedUpdateDiscounts := fUpdateDisc;
        end
        else
        begin
          aData.PrivateKey := DataSource.DataSet.FieldByName('Key').AsString;
          aData.ClientID := DataSource.DataSet.FieldByName('Client_id').AsString;
          aData.NeedUpdateDiscounts := not DataSource.DataSet.FieldByName('UpdateDisc').AsBoolean;
        end;

        aData.DiscVersion := 0;
        aData.AddresVersion := 0;
        aData.AgrVersion := 0;
      end;

      aData.CheckVersion := CheckUpdateDir;

      (Sender as TTaskDirectory).SetTaskData(aData);
    end;
  end;
end;

procedure TMain.TaskDiscountsAfterEnd(Sender: TObject);
var
  aStreamZipped, aStream: TMemoryStream;
  aNewVersion: Integer;
  aClientID: string;
  UserData: TUserIDRecord;
begin
  if not Data.fDatabaseOpened then //может в этот момент применяется обновление
    Exit;

  if (Sender is TTaskDiscounts) and ((Sender as TTaskDiscounts).HasNewDiscounts) then
  begin
    aStreamZipped := TMemoryStream.Create;
    aStream := TMemoryStream.Create;
    StartWait;
    try
      (Sender as TTaskDiscounts).GetDiscounts(aStreamZipped, aNewVersion);
      if aStreamZipped.Size > 0 then
      begin
        if UnzipStream2Stream(aStreamZipped, aStream, 'discounts', (Sender as TTaskDiscounts).GetTaskData.PrivateKey) and (aStream.Size > 0) then
        begin
          aClientID := (Sender as TTaskDiscounts).GetTaskData.ClientID;
          UserData := GetUserDataByID(aClientID);

          //пользователя могли удалить или выставить режим общей скидки, пока шел запрос скидок
          if Assigned(UserData) and (not UserData.bUpdateDisc) then
          begin
            ApplyDiscounts2DB(aStream, aClientID, aNewVersion);

            UpdateUserData(UserData);
            if UserData = GetCurrentUser then
            begin
              Data.SetPriceKoef;
              ShowStatusbarInfo;
            end;
            RaiseNotifyEvent('Обновлены скидки для клиента ' + UserData.sID + ' [' + UserData.sName + ']', 'Уведомление', netDiscounts);
          end;
        end;
      end;
    finally
      StopWait;
      aStream.Free;
      aStreamZipped.Free;
    end;
  end;
end;

procedure TMain.TaskOrdersBeforeRun(Sender: TObject; var aCanRun: Boolean);
var
  aData: TOrdersTaskData;
  aUser: TUserIDRecord;
//  fQueryUserMode: TDBISAMQuery;
  i: Integer;
  anOrderAge: TDateTime;
begin
  if Sender is TTaskOrders then
  begin
    aUser := GetCurrentUser;
    aCanRun := Assigned(aUser);
    if aCanRun then
    begin
      ZeroMemory(@aData, SizeOf(TOrdersTaskData));

      aData.Host1 := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
      aData.Port1 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

      aData.Host2 := Data.SysParamTable.FieldByName('Host').AsString;
      aData.Port2 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

      aData.Host3 := Data.SysParamTable.FieldByName('BackHost').AsString;
      aData.Port3 := Data.SysParamTable.FieldByName('PortB2BIn').AsInteger;

      fQueryUserMode.SQL.Text :=
          ' SELECT Order_id, Cli_id, "Sign", Sent_time FROM [009] ' +
          ' WHERE "Sign" <> '''' AND Cli_id <> '''' AND (Sent = ''1'' OR Sent = ''3'') AND Sent_time IS NOT NULL ';
        fQueryUserMode.Open;
        i := 0;
        while not fQueryUserMode.Eof do
        begin
          //не опрашиваем устаревшие заказы
          anOrderAge := (Now() - fQueryUserMode.FieldByName('Sent_time').AsDateTime);
          if (anOrderAge >= 0) and (anOrderAge < cObsoleteOrderTime) then
          begin
            SetLength(aData.OrdersToCheck, i + 1);
            aData.OrdersToCheck[i].ID := fQueryUserMode.FieldByName('Order_id').AsInteger;
            aData.OrdersToCheck[i].ClientID := fQueryUserMode.FieldByName('Cli_id').AsString;
            aData.OrdersToCheck[i].OrderNum := fQueryUserMode.FieldByName('Sign').AsString;

            Inc(i);
          end;
          fQueryUserMode.Next;
        end;
        fQueryUserMode.Close;

        fQueryUserMode.SQL.Text :=
        ' SELECT RetDoc_ID, Cli_id, "Sign", Sent_time FROM [036] ' +
        ' WHERE "Sign" <> '''' AND Cli_id <> '''' AND (Post = 1 OR Post = 2) AND Sent_time IS NOT NULL ';
        fQueryUserMode.Open;
        i := 0;
        while not fQueryUserMode.Eof do
        begin
          //не опрашиваем устаревшие возвраты
          if (Now() - fQueryUserMode.FieldByName('Sent_time').AsDateTime) < cObsoleteOrderTime then
          begin
            SetLength(aData.RetdocToCheck, i + 1);
            aData.RetdocToCheck[i].ID := fQueryUserMode.FieldByName('RetDoc_ID').AsInteger;
            aData.RetdocToCheck[i].ClientID := fQueryUserMode.FieldByName('Cli_id').AsString;
            aData.RetdocToCheck[i].RetdocNum := fQueryUserMode.FieldByName('Sign').AsString;

            Inc(i);
          end;
          fQueryUserMode.Next;
        end;
        fQueryUserMode.Close;

      aCanRun := (Length(aData.OrdersToCheck) > 0) or (Length(aData.RetdocToCheck) > 0);
      if aCanRun then
        (Sender as TTaskOrders).SetTaskData(aData);
    end;
  end;
end;

procedure TMain.TaskOrdersAfterEnd(Sender: TObject);
var
  aTask: TTaskOrders;
  s, aNotifyText: string;
//  fQueryUserMode: TDBISamQuery;
  IDs: TStrings;
  i: Integer;
  aStreamZakazano, aStreamZameny: TMemoryStream;
begin
  if not Data.fDatabaseOpened then //может в этот момент применяется обновление
    Exit;
  if (Sender is TTaskOrders) and ((Sender as TTaskOrders).HasResult) then
  begin
    aTask := Sender as TTaskOrders;

    IDs := TStringList.Create;
    aStreamZakazano := TMemoryStream.Create;
    aStreamZameny := TMemoryStream.Create;
    try
      aNotifyText := '';

      s := aTask.GetResultOrderIDs;
      if s <> '' then
      begin
        IDs.CommaText := s;
        for i := 0 to IDs.Count - 1 do
        begin
          aStreamZakazano.Clear;
          aStreamZameny.Clear;
          if aTask.GetResultOrder(StrToIntDef(IDs[i], 0), aStreamZakazano, aStreamZameny) and (aStreamZakazano.Size > 0) then
          begin
            fQueryUserMode.SQL.Text := ' UPDATE [009] SET Sent = ''4'', TcpAnswer = :TcpAnswer, TcpAnswerZam = :TcpAnswerZam WHERE Order_id = :Order_id ';
            fQueryUserMode.Params[0].LoadFromStream(aStreamZakazano, ftBlob);
            if aStreamZameny.Size > 0 then
              fQueryUserMode.Params[1].LoadFromStream(aStreamZameny, ftBlob)
            else
              fQueryUserMode.Params[1].AsBlob := '';//NULL
            fQueryUserMode.Params[2].AsInteger := StrToIntDef(IDs[i], 0);

            fQueryUserMode.ExecSQL;
            fQueryUserMode.Close;

            if aNotifyText <> '' then
              aNotifyText := aNotifyText  + #13#10;
            aNotifyText := aNotifyText + 'Получен ответ по заказу [ ' + GetOrderDescription(StrToIntDef(IDs[i], 0)) + ' ]';
          end;
        end;

        Data.OrderTable.Refresh;
        SetActionEnabled;  //обновляем кнопки
      end;

      s := aTask.GetResultRetdocIDs;
      if s <> '' then
      begin
        IDs.CommaText := s;
        for i := 0 to IDs.Count - 1 do
        begin
          aStreamZakazano.Clear;
          if aTask.GetResultRetdoc(StrToIntDef(IDs[i], 0), aStreamZakazano) and (aStreamZakazano.Size > 0) then
          begin
            fQueryUserMode.SQL.Text := ' UPDATE [036] SET Post = 4, TcpAnswer = :TcpAnswer WHERE Retdoc_id = :Retdoc_id ';
            fQueryUserMode.Params[0].LoadFromStream(aStreamZakazano, ftBlob);
            fQueryUserMode.Params[1].AsInteger := StrToIntDef(IDs[i], 0);

            fQueryUserMode.ExecSQL;
            fQueryUserMode.Close;

            if aNotifyText <> '' then
              aNotifyText := aNotifyText  + #13#10;
            aNotifyText := aNotifyText + 'Получен ответ по возврату [ ' + GetRetdocDescription(StrToIntDef(IDs[i], 0)) + ' ]';
          end;
        end;

        {-Обработка TCP до конечной стадии 1 -> 3; 5 -> 6; 2,3,4 -> 5 -}
//        fPost := True; //флаг фонового режима
        Data.ReturnDocTable.SetRange([Now() - cObsoleteOrderTime], [DateEndReturnDoc.Date]);
        ApplyRetdocAnswer(TRUE);
        Data.ReturnDocTable.SetRange([DateStartReturnDoc.Date], [DateEndReturnDoc.Date]);
        //>>
        Data.ReturnDocTable.Refresh;
      end;

      if aNotifyText <> '' then
        RaiseNotifyEvent(aNotifyText, 'Уведомление', netOrders);

    finally
      aStreamZakazano.Free;
      aStreamZameny.Free;
      IDs.Free;
    end;

  end;                                
end;


procedure TMain.acUpdateAllClientsExecute(Sender: TObject);
begin
{$IFDEF LOCAL}
  doUpdateAllClients(False);
{$ENDIF}
end;

procedure TMain.acUpdateAllDiscountsExecute(Sender: TObject);
var
  aStrings: TStrings;
begin
{$IFDEF LOCAL}
  aStrings := TStringList.Create;
  try
    Table.Open;
    Table.First;
    while not Table.Eof do
    begin
      if not Table.FieldByName('UpdateDisc').AsBoolean then
        aStrings.Add(Table.FieldByName('CLIENT_ID').AsString + '=' + Table.FieldByName('DiscountVersion').AsString);
      Table.Next;
    end;
    UpdateDiscountsAll(aStrings);
    SelectCurrentUser;
  finally
    aStrings.Free;
  end;
{$ENDIF}
end;

procedure TMain.acUpdateRatesExecute(Sender: TObject);
begin
  UpdateRatesByLight();
end;

procedure TMain.Button2Click(Sender: TObject);
var
  aReader: TCSVReader;
  i: integer;
begin
  exit;
  for i := 0 to fScheduler.TaskCount - 1 do
    if fScheduler.GetTask(i) is TTaskDirectory then
      fScheduler.GetTask(i).Start;


  exit;

    aReader := TCSVReader.Create;
  try

    aReader.Open('E:\1.csv');
    Data.DeliveryAddressTable.Open;
    while not aReader.Eof do
    begin
      try
        aReader.ReturnLine;
        Data.DeliveryAddressTable.Append;
        Data.DeliveryAddressTable.FieldByName('Addres_Id').AsString :=aReader.Fields[0];
        Data.DeliveryAddressTable.FieldByName('Descr').AsString :=aReader.Fields[1];
        Data.DeliveryAddressTable.FieldByName('Addres').AsString :=aReader.Fields[2];
        Data.DeliveryAddressTable.Post;
      except
        Data.DeliveryAddressTable.Cancel;
      end;
    end;
  finally
    Data.DeliveryAddressTable.Close;
    aReader.Close;
    try
      aReader.Open('E:\2.csv');
      Data.ContractsCliTable.Open;
      while not aReader.Eof do
      begin
        try
          aReader.ReturnLine;
          Data.ContractsCliTable.Append;
          Data.ContractsCliTable.FieldByName('Contract_Id').AsString :=aReader.Fields[0];
          Data.ContractsCliTable.FieldByName('ContractDescr').AsString :=aReader.Fields[1];
          Data.ContractsCliTable.FieldByName('Group').AsString :=aReader.Fields[2];
          Data.ContractsCliTable.FieldByName('Currency').AsString :=aReader.Fields[3];
          Data.ContractsCliTable.FieldByName('Method_Id').AsString :=aReader.Fields[4];
          Data.ContractsCliTable.FieldByName('MethodDescr').AsString :=aReader.Fields[5];
          Data.ContractsCliTable.FieldByName('Payment_id').AsString :=aReader.Fields[6];
          Data.ContractsCliTable.FieldByName('PaymentDescr').AsString :=aReader.Fields[7];
          Data.ContractsCliTable.FieldByName('PriceList_id').AsString :=aReader.Fields[8];
          Data.ContractsCliTable.FieldByName('DiscountCliGroup').AsString :=aReader.Fields[9];
          Data.ContractsCliTable.FieldByName('DiscountCliGroupDescr').AsString :=aReader.Fields[10];
          Data.ContractsCliTable.FieldByName('LegalPerson').AsString :=aReader.Fields[11];
          Data.ContractsCliTable.FieldByName('Addres_Id').AsString :=aReader.Fields[12];
          Data.ContractsCliTable.FieldByName('PriceListDescr').AsString :=aReader.Fields[13];
          Data.ContractsCliTable.Post;
        except
          Data.ContractsCliTable.Cancel;
        end;
      end;
    finally
      Data.ContractsCliTable.Close;
      aReader.Close;
      try
        aReader.Open('E:\3.csv');
        Data.DiscountCliTable.Open;
        while not aReader.Eof do
        begin
          try
            aReader.ReturnLine;
            Data.DiscountCliTable.Append;
            Data.DiscountCliTable.FieldByName('Group_Id').AsString :=aReader.Fields[0];
            Data.DiscountCliTable.FieldByName('Subgroup_Id').AsString :=aReader.Fields[1];
            Data.DiscountCliTable.FieldByName('Brand_Id').AsString :=aReader.Fields[2];
            Data.DiscountCliTable.FieldByName('GroupDiscountCli').AsString :=aReader.Fields[3];
            Data.DiscountCliTable.FieldByName('Discount').AsString :=aReader.Fields[4];
            Data.DiscountCliTable.Post;
          except
            Data.DiscountCliTable.Cancel;
          end;
        end;
      finally
        Data.DiscountCliTable.Close;
        aReader.Free;
      end;
    end;
  end;
end;
{  idDefault := 0;
  i := 100 div idDefault;
 { AssignFile(tFile,GetAppDir + '!!!.err');
  if FileExists(GetAppDir + '!!!.err') then
  begin
    Append(tFile);
    s := 'Addd!!!!';
  end
  else
  begin
    ReWrite(tFile);
    s := 'New!!!';
  end;
  Writeln(tFile,s);
  CloseFile(tFile);}

procedure TMain.Button3Click(Sender: TObject);
var
  head, body, DivTag, EndHead, fName, addres: string;
  Full: TStringList;

  procedure UpdateProgress(aPos: Integer; const aCaption: string);
  begin
   // Label7.Caption := aCaption;
    Application.ProcessMessages;
  end;

  procedure SetDefIfEmpty(var aValue: string; const aDefValue: string);
  begin
    if aValue = '' then
      aValue := aDefValue;
  end;

  function Quoted(const aValue: string): string;
  begin
    Result := Data.DBEngine.QuotedSQLStr(aValue);
  end;


var
  i: integer;
  path, fProgressMessage: string;
  prevPercent: Integer;
  sId, sBrand_id: string;
  sGroup_id: string;
  sCode, sCode2, sName, sDescription: string;
  sT1, sT2, sTecdoc_id, sNew, sSale: string;
  sMult, sUsa, sPrice, sTitle: string;
  sAction: string;
  aReader: TCSVReader;
  aPictID, aTypTDID, aParamTDID, aIDouble: string;
begin
  Data.TestQuery.Close;
  Data.TestQuery.SQL.Text := 'select * from [007_2] where cat_id = :D';
  Data.TestQuery.ParamByName('D').Value := 313;
  Data.TestQuery.Open;
  while not  Data.TestQuery.EOF do
  begin
    ShowMEssage(Data.TestQuery.FieldByName('cat_id').AsString);
    Data.TestQuery.Next;
  end;
  Data.TestQuery.Close;
  
  Data.AllClose;

  exit;
  SaveAssortmentExpansionProc(FALSE);
  exit;
while not Data.OrderDetDataSource.DataSet.eof do
begin
  Data.OrderDetDataSource.DataSet.FieldByName('Code2').ASString;
  Data.OrderDetDataSource.DataSet.Next;
end;
exit;

 for i := 0 to fScheduler.TaskCount - 1 do
    if fScheduler.GetTask(i) is TTaskRates then
    begin
      fScheduler.GetTask(i).Start;
      //task := fScheduler.GetTask(i) as TTaskRates;
    end;
exit;

  if OpenDialogCSV.Execute() = false then
    exit
  else
    path := OpenDialogCSV.FileName;
  aReader := TCSVReader.Create;
  if (_Data.GetFileSize_Internal(path) > 0) then
  begin
    fProgressMessage := 'Очистка каталогa...';
  //  ExecQuery('DELETE from [002_New] WHERE CODE2 = ''''', TestQuery); //удаление категорий
  end;
  Data.CatalogDataSource.DataSet.DisableControls;
  Data.CatalogTable.DisableControls;
  // переписно на удаление пачками
  aReader.Open(path);
  prevPercent := 0;
  while not aReader.Eof do
  begin
    aReader.ReturnLine;
    sID := aReader.Fields[1];

    if Data.CatalogTable.Locate('cat_id', sID, []) then
      Data.CatalogTable.Delete;
//      ShowProgressBase(aReader.FilePosPercent, fProgressMessage);
    if aReader.FilePosPercent > prevPercent then
    begin
      Button3.Caption := IntToStr(aReader.FilePosPercent) + '%';
      prevPercent := aReader.FilePosPercent;
      Application.ProcessMessages;
    end;
  end;
  aReader.Close;

                                  {   Изменение цены    }
  fProgressMessage := 'Очистка каталогa...';
//    Добавить отображение прогресса
  aReader.Open(Path + 'cat_2.csv');
  while not aReader.Eof do
  begin
    aReader.ReturnLine;
    sAction := aReader.Fields[0];
    sID := aReader.Fields[1];
    sPrice := ReplaceStr(aReader.Fields[2], ',', '.'); //подготавливать на стороне сервера!"!!!

    if Data.CatalogTable.Locate('cat_id', sID, []) then
    begin
      Data.CatalogTable.Edit;
      if length(sPrice) = 0 then
        Data.CatalogTable.FieldByName('Price').Value := ''
      else
        Data.CatalogTable.FieldByName('Price').Value := sPrice;
      Data.CatalogTable.Post;
    end;

    //Запилить в функцию
    if aReader.FilePosPercent > prevPercent then
    begin
      Button3.Caption := IntToStr(aReader.FilePosPercent) + '%';
      prevPercent := aReader.FilePosPercent;
      Application.ProcessMessages;
    end;
  end;
  aReader.Close;


                                        { каталог (новые) }
                                        
  fProgressMessage := 'Добавление новых позиций...';
  //Добавить отображение прогресса
  aReader.Open(Path + 'cat_1.csv');
  while not aReader.Eof do
  begin
    aReader.ReturnLine;

    sAction := aReader.Fields[0];
    sID := aReader.Fields[1];
    sBrand_id := aReader.Fields[2];
    sGroup_id := aReader.Fields[3];
    sCode := aReader.Fields[5];
    sCode2 := aReader.Fields[6];
    sName := aReader.Fields[7];
    sDescription := aReader.Fields[8];
    sPrice := aReader.Fields[9];
    sT1 := aReader.Fields[10];
    sT2 := aReader.Fields[11];
    sTecdoc_id := aReader.Fields[12];
    sNew := aReader.Fields[13];
    sSale := aReader.Fields[14];
    sMult := aReader.Fields[15];
    sUsa := aReader.Fields[16];
    sTitle := aReader.Fields[17];
    //новые поля после реструктуризации
    aPictID := aReader.Fields[18];
    aTypTDID := aReader.Fields[19];
    aParamTDID := aReader.Fields[20];

    aIDouble := aReader.Fields[21];

    SetDefIfEmpty(sBrand_id, '0');
    SetDefIfEmpty(sGroup_id, '0');
    SetDefIfEmpty(sPrice, '0.0');
    SetDefIfEmpty(sTecdoc_id, '0');
    SetDefIfEmpty(sNew, '0');
    SetDefIfEmpty(sSale, '0');
    SetDefIfEmpty(sMult, '0');
    SetDefIfEmpty(sUsa, '0');
    SetDefIfEmpty(sTitle, '0');
    SetDefIfEmpty(aPictID, '0');
    SetDefIfEmpty(aTypTDID, '0');
    SetDefIfEmpty(aParamTDID, '0');
    SetDefIfEmpty(aIDouble, '0');

    sPrice := ReplaceStr(sPrice, ',', '.');
    sDescription := ReplaceStr(sDescription, '''', '.');

    if Data.CatalogTable.Locate('cat_id', sID, []) then
    begin
      Data.CatalogTable.Append;
      Data.CatalogTable.FieldByName('Cat_id').Value := sID;
      Data.CatalogTable.FieldByName('Brand_id').Value := sBrand_id;
      Data.CatalogTable.FieldByName('Group_id').Value := sGroup_id;
      Data.CatalogTable.FieldByName('Code').Value := sCode;
      Data.CatalogTable.FieldByName('Code2').Value := sCode2;
      Data.CatalogTable.FieldByName('Name').Value := sName;
      Data.CatalogTable.FieldByName('Description').Value := sDescription;
      Data.CatalogTable.FieldByName('Price').Value := sPrice;
      Data.CatalogTable.FieldByName('T1').Value := sT1;
      Data.CatalogTable.FieldByName('T2').Value := sT2;
      Data.CatalogTable.FieldByName('Tecdoc_id').Value := sTecdoc_id;
      Data.CatalogTable.FieldByName('New').Value := sNew;
      Data.CatalogTable.FieldByName('Sale').Value := sSale;
      Data.CatalogTable.FieldByName('Mult').Value := sMult;
      Data.CatalogTable.FieldByName('Usa').Value := sUsa;
      Data.CatalogTable.FieldByName('Title').Value := sTitle;
      Data.CatalogTable.FieldByName('ShortCode').Value := Quoted(Data.CreateShortCode(sCode));
      Data.CatalogTable.FieldByName('pict_id').Value := aPictId;
      Data.CatalogTable.FieldByName('typ_tdid').Value := aTypTdid;
      Data.CatalogTable.FieldByName('param_tdid').Value := aParamTdid;
      Data.CatalogTable.FieldByName('IDouble').Value := aIDouble;
    end;
  end;
  aReader.Close;

  exit;


  Data.AnalogMainTable_1.DisableControls;
  Data.AnalogMainTable_1.First;
  while not Data.AnalogMainTable_1.eof do
  begin
    Data.AnalogMainTable_1.Edit;
    Data.AnalogMainTable_1.FieldByName('An_ShortCode').AsString := Data.CreateShortCode(Data.AnalogMainTable_1.FieldByName('An_Code').AsString);
    Data.AnalogMainTable_1.Post;
    Data.AnalogMainTable_1.Next;
  end;
  Data.AnalogMainTable_1.EnableControls;

  Data.AnalogMainTable_2.DisableControls;
  Data.AnalogMainTable_2.First;
  while not Data.AnalogMainTable_2.eof do
  begin
    Data.AnalogMainTable_2.Edit;
    Data.AnalogMainTable_2.FieldByName('An_ShortCode').AsString := Data.CreateShortCode(Data.AnalogMainTable_2.FieldByName('An_Code').AsString);
    Data.AnalogMainTable_2.Post;
    Data.AnalogMainTable_2.Next;
  end;
  Data.AnalogMainTable_2.EnableControls;

  Data.AnalogMainTable_3.DisableControls;
  Data.AnalogMainTable_3.First;
  while not Data.AnalogMainTable_3.eof do
  begin
    Data.AnalogMainTable_3.Edit;
    Data.AnalogMainTable_3.FieldByName('An_ShortCode').AsString := Data.CreateShortCode(Data.AnalogMainTable_3.FieldByName('An_Code').AsString);
    Data.AnalogMainTable_3.Post;
    Data.AnalogMainTable_3.Next;
  end;
  Data.AnalogMainTable_3.EnableControls;

  Data.AnalogMainTable_4.DisableControls;
  Data.AnalogMainTable_4.First;
  while not Data.AnalogMainTable_4.eof do
  begin
    Data.AnalogMainTable_4.Edit;
    Data.AnalogMainTable_4.FieldByName('An_ShortCode').AsString := Data.CreateShortCode(Data.AnalogMainTable_4.FieldByName('An_Code').AsString);
    Data.AnalogMainTable_4.Post;
    Data.AnalogMainTable_4.Next;
  end;
  Data.AnalogMainTable_4.EnableControls;

  Data.AnalogMainTable_5.DisableControls;
  Data.AnalogMainTable_5.First;
  while not Data.AnalogMainTable_5.eof do
  begin
    Data.AnalogMainTable_5.Edit;
    Data.AnalogMainTable_5.FieldByName('An_ShortCode').AsString := Data.CreateShortCode(Data.AnalogMainTable_5.FieldByName('An_Code').AsString);
    Data.AnalogMainTable_5.Post;
    Data.AnalogMainTable_5.Next;
  end;
  Data.AnalogMainTable_5.EnableControls;

       exit;
  {aReader := TCSVReader.Create;
  UpdateTable := TDBISAMTable.Create(nil);
  UpdateTable.DatabaseName := data.Database.DatabaseName;
  UpdateTable.TableName := '1007';
  i := 0;
  k := 0;
   UpdateTable.Open;
   UpdateTable.DisableControls;
   UpdateTable.First;

  { aReader.Open('E:\ana_2.csv');
   while not aReader.Eof do
   begin
     aReader.ReturnLine;

     sAction := aReader.Fields[0];
     sID := aReader.Fields[1];
     sAn_id := aReader.Fields[5];
     sLocked := aReader.Fields[6];
     if sLocked = '' then
       sLocked := '0';

     if UpdateTable.Locate('ID', sID, []) then
     begin
       UpdateTable.Edit;
       UpdateTable.FieldByName('An_id').AsString := sAn_id;
       UpdateTable.FieldByName('Locked').AsString := sLocked;
       UpdateTable.Post;
     end;
   inc(i);
     UpdateProgress(-1,'Обработано: ' + IntToStr(i));
   end;
   aReader.Close;      }

{       aReader.Open('E:\ana_1.csv');
        while not aReader.Eof do
        begin
          sLine := aReader.ReturnLine;

          sAction := aReader.Fields[0];
          sID := aReader.Fields[1];
          sCat_id  := aReader.Fields[2];
          sAn_code := aReader.Fields[3];
          sAn_brand := aReader.Fields[4];
          sAn_id := aReader.Fields[5];
          sLocked := aReader.Fields[6];
          if sLocked = '' then
            sLocked := '0';

          if not UpdateTable.Locate('ID', sID, []) then
          begin
            UpdateTable.Append;
            UpdateTable.FieldByName('ID').AsString := sID;
            UpdateTable.FieldByName('Cat_id').AsString := sCat_id;
            UpdateTable.FieldByName('An_code').AsString := sAn_code;
            UpdateTable.FieldByName('An_brand').AsString := sAn_brand;
            UpdateTable.FieldByName('An_id').AsString := sAn_id;
            UpdateTable.FieldByName('An_ShortCode').AsString := Data.CreateShortCode(sAn_code);
            UpdateTable.FieldByName('Locked').AsString := sLocked;
            UpdateTable.Post;
            inc(k);
          end;

          inc(i);
          if i mod 100 = 0 then
            UpdateProgress(-1,'Обработано: ' + IntToStr(k) + ' из ' +  IntToStr(i));
        end;

ShowMEssage('end!');


exit;
//>>>>>>>>>>>>>>>>>
  QueryDefect.Active := FALSE;
  QueryDefect.SQL.Text :=   ' select [036].RetDoc_ID as id, [037].Code2 as code2 from [036] ' +
                            ' inner join [037] on ([036].RetDoc_ID = [037].RetDoc_ID) ' +
                            ' where data >= :dateBeg and  data <= :dateEnd';
  QueryDefect.ParamByName('dateBeg').AsDateTime := DateStartReturnDoc.Date;
  QueryDefect.ParamByName('dateEnd').AsDateTime := DateEndReturnDoc.Date;
  QueryDefect.Prepare;
  QueryDefect.Active := True;
  QueryDefect.First;

  while not QueryDefect.Eof do
  begin
    ShowMEssage(QueryDefect.FieldByName('code2').AsString);
    QueryDefect.Next;
  end;
  exit;
//>>>>>>>>>>>>>>>>>
  Data.ContractsCliTable.First;
  while not Data.ContractsCliTable.Eof do
  begin
    ShowMessage(Data.ContractsCliTable.fieldByName('Contract_id').AsString + '#13#10'+ Data.ContractsCliTable.fieldByName('cli_id').AsString);
    Data.ContractsCliTable.Next;
  end;     }

  exit;

  Full := TStringList.Create();
  head := '<?xml version="1.0" encoding="UTF-8"?>';
  body := '<Document Document_Type="#Order#" Customer_ID="#cli_id#" Request_No="#req_num#" Document_Date="#data#" Agreement_No="#Agreement_No#" Currency="#cur#" Ship_Address="#Ship_Address#" Comment="#descr#" >';
  DivTag := '<Line Item_No = "#code_brand#" Quantity="#quant#"/>' ;
  EndHead := '</Document>';

  Full.Append(head);
  Full.Append(body);
  try
    if Main.Pager.ActivePage = CatZakPage then
    begin
      if Data.ContractsCliTable.Locate('contract_id', Data.OrderTable.FieldByName('Agreement_No').AsString, []) then
      begin
        addres := Data.ContractsCliTable.FieldByName('Addres_Id').AsString;
        //currency 
      end;

      fName := 'Sale_Orders.xml';
      Full.Text := StringReplace(Full.Text,'#Order#','Order',[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#cli_id#',Data.OrderTable.FieldByName('cli_id').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#req_num#',Data.OrderTable.FieldByName('order_id').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#data#',Data.OrderTable.FieldByName('Date').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#Agreement_No#',AnsiToUtf8(Data.OrderTable.FieldByName('Agreement_No').AsString),[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#cur#',Data.OrderTable.FieldByName('Currency').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#Ship_Address#',AnsiToUtf8(addres),[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#descr#',AnsiToUtf8(Data.OrderTable.FieldByName('Description').AsString),[rfReplaceAll]);

      Data.OrderDetTable.First;
      while not Data.OrderDetTable.Eof do
      begin
        Full.Append(DivTag);
        Full.Text := StringReplace(Full.Text,'#code_brand#',Data.OrderDetTable.FieldByName('ArtCodeBrand').AsString,[rfReplaceAll]);
        Full.Text := StringReplace(Full.Text,'#quant#',Data.OrderDetTable.FieldByName('Quantity').AsString,[rfReplaceAll]);
        Data.OrderDetTable.Next;
      end;
    end
    else if Main.Pager.ActivePage = ReturnDocPage then
    begin
      if Data.ContractsCliTable.Locate('contract_id',Data.ReturnDocTable.FieldByName('Agreement_No').AsString,[]) then
        addres := Data.ContractsCliTable.FieldByName('Addres_Id').AsString;
      fName := 'Sale_Returns.xml';
      Full.Text := StringReplace(Full.Text,'#Order#','Return',[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#cli_id#',Data.ReturnDocTable.FieldByName('cli_id').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#req_num#',Data.ReturnDocTable.FieldByName('RetDoc_ID').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#data#',Data.ReturnDocTable.FieldByName('Data').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#Agreement_No#',AnsiToUtf8(Data.ReturnDocTable.FieldByName('Agreement_No').AsString),[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#cur#',{Data.ReturnDocTable.FieldByName('Currency').AsString}AnsiToUtf8('В проекте'),[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#Ship_Address#',AnsiToUtf8(addres),[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#descr#',AnsiToUtf8(Data.ReturnDocTable.FieldByName('Note').AsString),[rfReplaceAll]);

      Data.ReturnDocDetTable.First;
      while not Data.ReturnDocDetTable.Eof do
      begin
        Full.Append(DivTag);
        Full.Text := StringReplace(Full.Text,'#code_brand#',AnsiToUtf8(Data.ReturnDocDetTable.FieldByName('Code').AsString +'_'+ Data.ReturnDocDetTable.FieldByName('brand').AsString),[rfReplaceAll]);
        Full.Text := StringReplace(Full.Text,'#quant#',Data.ReturnDocDetTable.FieldByName('Quantity').AsString,[rfReplaceAll]);
        Data.ReturnDocDetTable.Next;
      end;
    end;

    Full.Append(EndHead);
    Full.SaveToFile(Data.Data_Path + fName);
  finally
    Full.Free;
  end;
end;

procedure TMain.TaskOrdersStatusBeforeRun(Sender: TObject;
  var aCanRun: Boolean);
var
  aData: TOrdersStatusTaskData;
  s: string;
  anOrderAge: TDateTime;
begin
  if Sender is TTaskOrdersStatus then
  begin    
    ZeroMemory(@aData, SizeOf(TOrdersStatusTaskData));

    aData.Host1 := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
    aData.Port1 := Data.SysParamTable.FieldByName('PortIn').AsInteger;
    
    aData.Host2 := Data.SysParamTable.FieldByName('Host').AsString;
    aData.Port2 := Data.SysParamTable.FieldByName('PortIn').AsInteger;
    
    aData.Host3 := Data.SysParamTable.FieldByName('BackHOST').AsString;
    aData.Port3 := Data.SysParamTable.FieldByName('PortB2BIn').AsInteger;

    // !!! опрашивать только те у которых статус доставки = "Доставка"
      fQueryUserMode.SQL.Text :=
        ' SELECT Order_id, Cli_id, "Sign", Sent_time, Sent, LotusNumber FROM [009] ' +
        ' WHERE "Sign" <> '''' AND Cli_id <> '''' AND (IsDelivered = 0 or IsDelivered IS NULL) AND (Sent <> '''' AND Sent <> ''0'') AND Sent_time IS NOT NULL ';
      fQueryUserMode.Open;
      while not fQueryUserMode.Eof do
      begin
        //заказ обработан и нет Лотус-номера - значит была ошибка при формировании заказа (не удалось зарезервировать ни одной позиции и др.)
        if (fQueryUserMode.FieldByName('Sent').AsString = '2') and (fQueryUserMode.FieldByName('LotusNumber').AsString = '') then
        begin
          fQueryUserMode.Next;
          Continue;
        end;

        //не опрашиваем устаревшие заказы
        anOrderAge := (Now() - fQueryUserMode.FieldByName('Sent_time').AsDateTime);
        if (anOrderAge >= 0) and (anOrderAge < cObsoleteOrderTime) then //если дата переведена назад - будет с минусом
        begin
          {<Order_Id>=<Client_Id>_<Order_Num>,<Order_Id>=<Client_Id>_<Order_Num>}
          s := Format('%s=%s_%s', [fQueryUserMode.FieldByName('Order_id').AsString, fQueryUserMode.FieldByName('Cli_id').AsString, fQueryUserMode.FieldByName('Sign').AsString]);
          if aData.OrdersToCheck = '' then
            aData.OrdersToCheck := s
          else
            aData.OrdersToCheck := aData.OrdersToCheck + ',' + s;
        end;
        fQueryUserMode.Next;
      end;
      fQueryUserMode.Close;
    aCanRun := aData.OrdersToCheck <> '';
    if aCanRun then
      (Sender as TTaskOrdersStatus).SetTaskData(aData);
  end;
end;

procedure TMain.TaskOrdersStatusAfterEnd(Sender: TObject);
var
  i: Integer;
  s, aNotifyText: string;
  aRes: TStrings;
//  fQueryUserMode: TDBISAMQuery;
  aStatus: Integer;
begin
  if not Data.fDatabaseOpened then //может в этот момент применяется обновление
    Exit;

  if (Sender is TTaskOrdersStatus) and ((Sender as TTaskOrdersStatus).HasResult) then
  begin
    aRes := TStringList.Create;
    try
      aNotifyText := '';
      s := (Sender as TTaskOrdersStatus).GetResultStatuses;
      if s <> '' then
      begin
        {<Order_Id>=<Status>,<Order_Id>=<Status>}
        aRes.CommaText := s;
        for i := 0 to aRes.Count - 1 do
        begin
          if aRes.ValueFromIndex[i] = '-2' then //ошибка при опросе этого заказа, не меняем его чтобы опросить в след. раз
            Continue;
          aStatus := StrToIntDef(aRes.ValueFromIndex[i], 0);
          if aStatus <> 0 then
          begin
            fQueryUserMode.SQL.Text := ' UPDATE [009] SET IsDelivered = :IsDelivered WHERE Order_id = :Order_id ';
            fQueryUserMode.Params[0].AsInteger := aStatus;
            fQueryUserMode.Params[1].AsInteger := StrToIntDef(aRes.Names[i], 0);

            fQueryUserMode.ExecSQL;
            fQueryUserMode.Close;

            if aStatus = 1 then
            begin
              if aNotifyText <> '' then
                aNotifyText := aNotifyText  + #13#10;
              aNotifyText := aNotifyText + 'Заказ [ ' + GetOrderDescription(StrToIntDef(aRes.Names[i], 0)) + ' ] покинул склад';
            end;
          end;
        end;

        if aNotifyText <> '' then
          RaiseNotifyEvent(aNotifyText, 'Уведомление', netOrders);

        Data.OrderTable.Refresh;
        Data.OrderTableAfterScroll(Data.OrderTable);
        SetActionEnabled;  //обновляем кнопки
      end;
    finally
      aRes.Free;
    end;
  end;
end;

procedure TMain.TaskRssBeforeRun(Sender: TObject; var aCanRun: Boolean);
var
  aData: TRssTaskData;
begin
  if Sender is TTaskRss then
  begin
    aData.UseProxy := Data.ParamTable.FieldByName('UseProxy').AsBoolean;
    if aData.UseProxy then
    begin
      aData.ProxyHost :=  Data.ParamTable.FieldByName('ProxySrv').AsString;
      aData.ProxyPort :=  Data.ParamTable.FieldByName('ProxyPort').AsInteger;

      aData.UseProxyAutority := Data.ParamTable.FieldByName('UseProxyAutoresation').AsBoolean;
      if aData.UseProxyAutority then
      begin
        aData.ProxyUser := Data.ParamTable.FieldByName('ProxyUser').AsString;
        aData.ProxyPass := Data.ParamTable.FieldByName('ProxyPassword').AsString;
      end;
    end;
{
    if not FileExists(Data.Data_Path + 'Latest.rss') then
      aData.RssLink := 'http://shate-m.by/ru/news/rss.html?count=50'
    else
}
    aData.RssLink := cRssUrl;
    aData.RssLinkRL := cRssRunningLineUrl;

    aData.ImageDestDir := GetAppDir + 'thumbs\Rss\';
    if not DirectoryExists(aData.ImageDestDir) then
      ForceDirectories(aData.ImageDestDir);
    if not FileExists(aData.ImageDestDir + 'new_item.gif') then
      ImgRssNew.Picture.SaveToFile(aData.ImageDestDir + 'new_item.gif');
    if not FileExists(aData.ImageDestDir + 'shate.jpg') then
      ImgRssShate.Picture.SaveToFile(aData.ImageDestDir + 'shate.jpg');

    (Sender as TTaskRss).SetTaskData(aData);
  end;
end;

procedure TMain.TaskRatesAfterEnd(Sender: TObject);
var
  newRatesList: TStringList;
  oldEur, oldRub, oldUsd: string;
begin
  SetImageByLight(INDEX_OF_RATES, False);
  newRatesList := TStringList.Create;

  if not Data.fDatabaseOpened then //может в этот момент применяется обновление
    Exit;
  if (Sender is TTaskRates) and ((Sender as TTaskRates).HasNewRates) then
  begin
    try
      if (Sender as TTaskRates).GetRates(newRatesList) then
      begin
        with Data.ParamTable do
        begin
          oldUsd := FieldByName('Eur_usd_rate').AsString;
          oldEur := FieldByName('Eur_rate').AsString;
          oldRub := FieldByName('Eur_RUB_rate').AsString;
          if (oldUsd <> newRatesList[0]) or
            (oldEur <> newRatesList[1]) or
            (oldRub <> newRatesList[2]) then
          begin
            Edit;
            FieldByName('Eur_usd_rate').Value := AToFloat(newRatesList[0]);
            FieldByName('Eur_rate').Value :=  AToFloat(newRatesList[1]);
            FieldByName('Eur_RUB_rate').Value := AToFloat(newRatesList[2]);
            Post;
            {RaiseNotifyEvent('Произведено обновление курсов:'+ #13#10 +
                             '- EUR: ' +  oldEur + ' -> ' + FieldByName('Eur_rate').AsString + #13#10 +
                             '- USD: ' +  oldUsd + ' -> ' + FieldByName('Eur_usd_rate').AsString + #13#10 +
                             '- RUB: ' +  oldRub + ' -> ' + FieldByName('Eur_RUB_rate').AsString + #13#10,
                             'Уведомление', netDirectory,
                             'EUR: ' +  oldEur + ' -> ' + FieldByName('Eur_rate').AsString + #13#10 +
                             'USD: ' +  oldUsd + ' -> ' + FieldByName('Eur_usd_rate').AsString + #13#10 +
                             'RUB: ' +  oldRub + ' -> ' + FieldByName('Eur_RUB_rate').AsString + #13#10) }
          end;
          SetImageByLight(INDEX_OF_RATES, True);
          if Data.ParamTable.FieldByName('bNotifyEvent').AsBoolean then
            RaiseNotifyEvent('Произведено обновление цен!', 'Уведомление', netDirectory, 'Цены успешно обновлены!');
        end;
      end;

    finally
      newRatesList.Free;
    end;
  end;
end;

procedure TMain.TaskRatesBeforeRun(Sender: TObject; var aCanRun: Boolean);
var
  aData: TRatesTaskData;
begin
  if Sender is TTaskRates then
  begin
      ZeroMemory(@aData, SizeOf(TRatesTaskData));

      aData.Host1 := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
      aData.Port1 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

      aData.Host2 := Data.SysParamTable.FieldByName('Host').AsString;
      aData.Port2 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

      aData.Host3 := Data.SysParamTable.FieldByName('BackHOST').AsString;
      aData.Port3 := Data.SysParamTable.FieldByName('PortB2BIn').AsInteger;

      (Sender as TTaskRates).SetTaskData(aData);
  end;
end;

procedure TMain.TaskRssAfterEnd(Sender: TObject);
var
  aListOld, aListNew: TList;
  aRssFile, aRssFileRL: string;
  aOldRL, aNewRL: string;
  aOldRLDate, aNewRLDate: TDateTime;
  aHasNew: Boolean;
  sl: TStrings;
begin
try
  if not Data.fDatabaseOpened then //может в этот момент применяется обновление
    Exit;
  if Sender is TTaskRss then
  begin
    if (Sender as TTaskRss).HasResult then
    begin
      aListOld := TList.Create;
      aListNew := TList.Create;
      aOldRL := '';
      aOldRLDate := 0;

//      aRssFile := Data.Data_Path + 'Latest.rss';
      aRssFile := IncludeTrailingPathDelimiter( (Sender as TTaskRss).GetTaskData.ImageDestDir ) + 'Latest.rss';
      aRssFileRL := IncludeTrailingPathDelimiter( (Sender as TTaskRss).GetTaskData.ImageDestDir ) + 'LatestRL.rss';

      sl := TStringList.Create;
      try
        //-Running Line---------------------------
        if FileExists(aRssFileRL) then
        begin
          sl.LoadFromFile(aRssFileRL);
          if not RssTools.EncodeRssRunningLine(sl.Text, aOldRL, aOldRLDate) then
          begin
            aOldRL := '';
            aOldRLDate := 0;
          end;
        end;

        sl.Text := (Sender as TTaskRss).GetResultRL;
        if RssTools.EncodeRssRunningLine(sl.Text, aNewRL, aNewRLDate) then
        begin
          if (aNewRLDate <> aOldRLDate) or (not FileExists(GetAppDir + 'RunningLine')) then
          begin
            sl.SaveToFile(aRssFileRL); //resave new xml
            aNewRL := StringReplace(aNewRL, #13#10#13#10, #13#10, [rfReplaceAll]);
            sl.Text := aNewRL;
            sl.SaveToFile(GetAppDir + 'RunningLine'); //resave RunningLine
            ReloadRunningLine;
          end;
        end;      

        //-news---------------------------
        if FileExists(aRssFile) then
        begin
          sl.LoadFromFile(aRssFile);
          if not RssTools.EncodeRssNews(sl.Text, aListOld) then
            aListOld.Clear;
        end;

        sl.Text := (Sender as TTaskRss).GetResult;
        if RssTools.EncodeRssNews(sl.Text, aListNew) then
        begin
          aHasNew := False;
          if (aListOld.Count = 0) or
             RssTools.CompareRss(aListOld, aListNew) then //has new items
          begin
            aHasNew := True;
            sl.SaveToFile(aRssFile); //resave new xml
          end;

          if aHasNew then
          begin
            //Build Html by aListNew
            sl.Text := RssTools.BuildRssHtml(aListNew, 10);
            sl.SaveToFile(GetAppDir + 'Rss.tmp');

            sl.Text := RssTools.BuildRssHtml(aListNew, -1{all}, MemoRssFullTemplate.Text);
            sl.SaveToFile(GetAppDir + 'RssNews.html');

            if Data.ParamTable.FieldByName('bShowRssOnUpdate').AsBoolean then
            begin
              ShowPopupRss;
            end
            else
              RaiseNotifyEvent('Обновлены новости компании. <a>Показать...</a>', 'Уведомление', netRss, 'Обновлены новости компании');
          end;
          {
          else
            if aHasNewRL then
              RaiseNotifyEvent('Обновлена бегущая строка.', 'Уведомление', netRss);
          }
        end;

        while aListOld.Count > 0 do
        begin
          TRssNewsItem(aListOld[0]).Free;
          aListOld.Delete(0);
        end;
        while aListNew.Count > 0 do
        begin
          TRssNewsItem(aListNew[0]).Free;
          aListNew.Delete(0);
        end;

      finally
        sl.Free;
        aListOld.Free;
        aListNew.Free;
      end;
    end;
  end;
except
//пока необкатано, душим исключения
end;
end;


procedure TMain.UpdateFilterColumnsChecked(const aColumnFieldName: string = '' {all columns});
  function FindCol(const aFieldName: string): TColumnEh;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to MainGrid.Columns.Count - 1 do
      if SameText(MainGrid.Columns[i].FieldName, aFieldName) then
      begin
        Result := MainGrid.Columns[i];
        Break;
      end;
  end;

var
  aCol: TColumnEh;
begin
  if (aColumnFieldName = '') or (aColumnFieldName = 'Quantity') then
  begin
    aCol := FindCol('Quantity');
    if Assigned(aCol) then
      if not WithQuants.Checked then
        aCol.Title.ImageIndex := 8
      else
        aCol.Title.ImageIndex := 9;
  end;

 { if (aColumnFieldName = '') or (aColumnFieldName = 'Usa') then
  begin
    aCol := FindCol('Usa');
    if Assigned(aCol) then
      if not UsaCheckBox.Checked then
        aCol.Title.ImageIndex := 2
      else
        aCol.Title.ImageIndex := 5;
  end;

  if (aColumnFieldName = '') or (aColumnFieldName = 'New') then
  begin
    aCol := FindCol('New');
    if Assigned(aCol) then
      if not NewCheckBox.Checked then
        aCol.Title.ImageIndex := 1
      else
        aCol.Title.ImageIndex := 4;
  end;   }
end;

procedure TMain.UpdateOrdersFilter(aUserData: TUserIDRecord);
var
  anOrderId: Integer;
begin
  if Assigned(aUserData) and (not Data.ParamTable.FieldByName('ShowAllOrders').AsBoolean) then
  begin
    with Data.OrderTable do
    begin
      DisableControls;
      anOrderId := FieldByName('Order_id').AsInteger;
      if IndexName <> 'Cli_Date' then
        IndexName := 'Cli_Date';
      SetRange([aUserData.sId, OrderDateEd1.Date], [aUserData.sId, OrderDateEd2.Date]);
      if not Locate('Order_id', anOrderId, []) then
        Last;
      EnableControls;
    end;
  end
  else
    with Data.OrderTable do
    begin
      DisableControls;
      anOrderId := FieldByName('Order_id').AsInteger;
      if IndexName <> 'Date' then
        IndexName := 'Date';
      SetRange([OrderDateEd1.Date], [OrderDateEd2.Date]);
      if not Locate('Order_id', anOrderId, []) then
        Last;
      EnableControls;
    end;
end;

procedure TMain.UpdateRatesByLight;
var
  email:string;
  F: TextFile;
  Path:string;
  TCPClient:TIdTCPClient;
  s:string;
  sDateKurses:string;
  sOldEur, sOldUsd, sOldRub: string;
begin
  TCPClient:= TIdTCPClient.Create(nil);
  Path := ExtractFilePath(Forms.Application.ExeName) + 'Импорт\';
  DeleteFile(Path+'Rates.csv');

  if not DoTcpConnect(TCPClient, True, True) then
    Exit;

  SetImageByLight(INDEX_OF_RATES, False);
  try
    email := 'STOCK_KURSES_ACK';
    TCPClient.IOHandler.Writeln(email);
    email := TCPClient.IOHandler.ReadLnWait;
    if(email = 'END') then
    begin
      MessageDlg('Не удалось пересчитать цены!', mtInformation, [mbOK], 0);
      TCPClient.Disconnect;
      exit;
    end;

    while email <> 'END' do
    begin
      if email = 'FILE' then
      begin
        email := TCPClient.IOHandler.ReadLnWait;
        AssignFile(F, Path+email);
        Rewrite(F);
      end

      else if email = 'ENDFILE' then
      begin
        CloseFile(F);
        sDateKurses := TCPClient.IOHandler.ReadLnWait;
      end

      else
         System.Writeln(F, email);

      email := TCPClient.IOHandler.ReadLnWait;
    end;

  except
    on e: Exception do
    begin
      MessageDlg('Ошибка: ' + e.Message,mtError,[mbOK],0);
      TCPClient.Disconnect;
      Exit;
    end;
  end;

  if FileExists(Path+'Rates.csv') then
  begin
    AssignFile(F,Path+'Rates.csv');
    Reset(F);
    Readln(F,s);
    with Data.ParamTable do
    begin
      Edit;
      s:= ExtractDelimited(2, s, [';']);
      sOldUsd := FieldByName('Eur_usd_rate').AsString + ' -> ' + FloatToStr(Main.AToFloat(s));
      FieldByName('Eur_usd_rate').Value :=        Main.AToFloat(s);
      Readln(F,s);
      s:= ExtractDelimited(2, s, [';']);
      sOldEur := FieldByName('Eur_rate').AsString + ' -> ' + FloatToStr(Main.AToFloat(s));
      FieldByName('Eur_rate').Value :=        Main.AToFloat(s);
      Readln(F,s);
      s:= ExtractDelimited(2, s, [';']);
      sOldRub := FieldByName('Eur_RUB_rate').AsString + ' -> ' + FloatToStr(Main.AToFloat(s));
      if s <> '' then
        FieldByName('Eur_RUB_rate').Value :=        Main.AToFloat(s);
      Post;
    end;
    CloseFile(F);
    SetImageByLight(INDEX_OF_RATES, True);
    MessageDlg('Цены пересчитаны!', mtInformation, [mbOK], 0);
    Data.SetPriceKoef;
  end
  else
    MessageDlg('Не удалось пересчитать цены!', mtInformation, [mbOK], 0);
end;

procedure TMain.ReloadRunningLine;
var
  f: TextFile;
  anAdsFile, aLine: string;
  anActive: Boolean;
begin
  anAdsFile := GetAppDir + 'RunningLine';
  if FileExists(anAdsFile) then
  begin
    AssignFile(f, anAdsFile);
    Reset(f);
    anActive := Main.JvScrollText.Active;
    Main.JvScrollText.Active := False;
    try
      Main.JvScrollText.Items.Clear;
      while not EOF(f) do
      begin
        Readln(f, aLine);
        Main.JvScrollText.Items.Add(aLine);
      end;
    finally
      CloseFile(f);
      Main.JvScrollText.Active := anActive;
    end;
  end;
end;

//создает меню отображения тулбаров (Вид->Панели инструментов->...)
procedure TMain.LoadToolBarsMenu;
var
  i: Integer;
  aItem: TMenuItem;
begin
  miPanels.Clear;
  for i := 0 to MainDockPanel.AdvToolBarCount - 1 do
  begin
    aItem := TMenuItem.Create(MainMenu);
    aItem.Caption := TAdvToolBar(MainDockPanel.AdvToolBars[i]).Caption;
    aItem.Checked := TAdvToolBar(MainDockPanel.AdvToolBars[i]).Visible;
    aItem.OnClick := miPanelVisibleClick;
    aItem.Tag := Integer(Pointer(MainDockPanel.AdvToolBars[i]));
    miPanels.Add(aItem);
  end;
end;

procedure TMain.UpdateToolBarsMenuChecked;
var
  i: Integer;
  aItem: TMenuItem;
  aBar: TAdvToolBar;
begin
  for i := 0 to miPanels.Count - 1 do
  begin
    aItem := miPanels[i];
    if aItem.Tag <> 0 then
    begin
      aBar := TAdvToolBar(Pointer(aItem.Tag));
      aItem.Checked := aBar.Visible;

      if aBar = AutoToolBar then
      begin
        aItem.Enabled := TRUE;//AutoAction.Visible;
        aItem.Checked := TRUE;
      end;
    end;
  end;
end;

procedure TMain.CalcProfitPriceForOrdetDetCurrent;
begin
  if Data.BrandTable.Locate('Description', Data.OrderDetTable.FieldByName('Brand').AsString, []) and
    Data.XCatTable.FindKey([Data.OrderDetTable.FieldByName('Code2').AsString, Data.BrandTable.FieldByName('Brand_id').AsInteger]) then
  begin
    with Data.OrderDetTable do
    begin
      FieldByName('Price_pro').Value :=
        XRoundCurr(Data.GetMargin2(Data.XCatTable.FieldByName('group_id').AsInteger, Data.XCatTable.FieldByName('subgroup_id').AsInteger, Data.XCatTable.FieldByName('Brand_id').AsInteger, FieldByName('Price').AsCurrency) *
          FieldByName('Price').AsCurrency, ctEUR);
    end;
  end;
end;

procedure TMain.CurrencyChanged;
  function FindCol(aGrid: TDBGridEh; const aFieldName: string): TColumnEh;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to aGrid.Columns.Count - 1 do
      if SameText(aGrid.Columns[i].FieldName, aFieldName) then
      begin
        Result := aGrid.Columns[i];
        Break;
      end;
  end;

  procedure SetColCaption(aGrid: TDBGridEh; const aColFieldName, aNewCaption: string);
  var
    aCol: TColumnEh;
  begin
    aCol := FindCol(aGrid, aColFieldName);
    if Assigned(aCol) then
      aCol.Title.Caption := aNewCaption;
  end;

var
  aCurrencyShortCode: string;
begin
  aCurrencyShortCode := GetCurrencyShortCode(Data.Curr);
  if aCurrencyShortCode <> '' then
    aCurrencyShortCode := ', ' + aCurrencyShortCode;

  SetColCaption(MainGrid, 'Price_koef', 'Цена' + aCurrencyShortCode);
  SetColCaption(MainGrid, 'Price_pro', 'Цена с нац.' + aCurrencyShortCode);

  SetColCaption(AnalogGrid, 'Price_koef', 'Цена' + aCurrencyShortCode);
  SetColCaption(AnalogGrid, 'Price_pro', 'Цена с нац.' + aCurrencyShortCode);

  SetColCaption(WaitListGrid, 'Price_koef', 'Цена' + aCurrencyShortCode);

  SetColCaption(AssortmentExpansionGridEh, 'Price_koef', 'Цена' + aCurrencyShortCode);

  SetColCaption(OrderGrid, 'Sum', 'Сумма' + aCurrencyShortCode);
  SetColCaption(OrderGrid, 'sum_pro', 'Сумма' + aCurrencyShortCode);

  SetColCaption(OrderDetGrid, 'Price_koef', 'Цена' + aCurrencyShortCode);
  SetColCaption(OrderDetGrid, 'Price_pro_koef', 'Цена с нац.' + aCurrencyShortCode);

  SetColCaption(OrderDetGrid, 'Sum', 'Сумма' + aCurrencyShortCode);
  SetColCaption(OrderDetGrid, 'sum_pro', 'Сумма с нац.' + aCurrencyShortCode);

  SetColCaption(KKGridEh, 'Price_pro', 'Цена (розн.)' + aCurrencyShortCode);

  SetColCaption(KitGridEh, 'Price_koef', 'Цена' + aCurrencyShortCode);
  SetColCaption(KitGridEh, 'Price_koef_sum', 'Сумма' + aCurrencyShortCode);
  SetColCaption(KitGridEh, 'PriceProEur', 'Цена с нац.' + aCurrencyShortCode);
  SetColCaption(KitGridEh, 'PriceProEur_sum', 'Сумма с нац.' + aCurrencyShortCode);

  CountingOrderSum;
  Data.OrderDetTable.Resync([rmCenter]); //чтобы обновились вычисляемые поля (отметки для перетягивания)

  PostMessage(Handle, MESSAGE_AFTER_COL_RESIZE, 0, 0);
end;

procedure TMain.pnTreeModeResize(Sender: TObject);
begin
  tbTree.Width := tbTree.Parent.ClientWidth - tbTree.Left - 3;
end;

procedure TMain.UpdateCatalogCaption;
var
  aCat: TDataSet;
  s, sPic: string;
  aHasBrandCatalog: Boolean;
begin
  aCat := MainGrid.DataSource.DataSet;
  aHasBrandCatalog := fECatList.IndexOfName(aCat.FieldByName('BrandDescrRepl').AsString) >= 0;
  case Data.Tree_mode of
    0, 2:
    begin
      if aCat.FieldByName('BrandDescrRepl').AsString <> '' then
        sPic := '<IMG src="0">'
      else
        sPic := '';
      if aHasBrandCatalog then
        s := Format(
          '<b>Каталог</b>: <SHAD>%s / <B><A href="BRAND"><FONT color="#FFFFFF">%s</FONT></A></B> <A href="BRAND_INFO">%s</A></SHAD>',
          [aCat.FieldByName('GroupInfo').AsString, aCat.FieldByName('BrandDescrRepl').AsString, sPic]
        )
      else
        s := Format(
          '<b>Каталог</b>: <SHAD>%s / <B>%s</B> <A href="BRAND_INFO">%s</A></SHAD>',
          [aCat.FieldByName('GroupInfo').AsString, aCat.FieldByName('BrandDescrRepl').AsString, sPic]
        );

      if s <> MainGridPanel.Caption.Text then
        MainGridPanel.Caption.Text := s;
    end;
    1, 3:
    begin
      if aCat.FieldByName('BrandDescrRepl').AsString <> '' then
        sPic := '<IMG src="0">'
      else
        sPic := '';

      if aHasBrandCatalog then
        s := Format(
          '<b>Каталог</b>: <SHAD><B><A href="BRAND"><FONT color="#FFFFFF">%s</FONT></A></B> <A href="BRAND_INFO">%s</A> / %s</SHAD>',
          [aCat.FieldByName('BrandDescrRepl').AsString, sPic, aCat.FieldByName('GroupInfo').AsString]
        )
      else
        s := Format(
          '<b>Каталог</b>: <SHAD><B>%s</B> <A href="BRAND_INFO">%s</A> / %s</SHAD>',
          [aCat.FieldByName('BrandDescrRepl').AsString, sPic, aCat.FieldByName('GroupInfo').AsString]
        );
      if s <> MainGridPanel.Caption.Text then
        MainGridPanel.Caption.Text := s;
    end;
  end;
end;


procedure TMain.InitNotifyEvents;
var
  iType: TNotifyEventType;
begin
  fNotifyButtons[netUnknown] := nil;
  fNotifyButtons[netDiscounts] := nil;
  fNotifyButtons[netOrders] := nil;//btNotifyOrders;
  fNotifyButtons[netRetdocs] := nil;//btNotifyRetdocs;
  fNotifyButtons[netWaitList] := nil;
  
  for iType := Low(TNotifyEventType) to High(TNotifyEventType) do
  begin
    fRaisedNotifyEvents[iType] := False;
    if Assigned(fNotifyButtons[iType]) then
    begin
      fNotifyButtons[iType].Tag := Ord(iType);
      fNotifyButtons[iType].OnClick := NotifyButtonClick;
    end;
  end;
end;


procedure TMain.KitGridEhDblClick(Sender: TObject);
begin
  acKitAddToOrder.Execute;
end;

procedure TMain.KitGridEhKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
//    VK_DELETE: Data.KK.Delete;
    VK_SPACE: acKitMoveToPos.Execute;
    VK_RETURN: acKitAddToOrder.Execute;
  end;
end;

procedure TMain.KKGridEhDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if (Source <> MainGrid) and (Source <> Tree) then
    Exit;

  if Source = Tree then
  begin
    miTreeAddToKKClick(miTreeAddToKK);
    Exit;
  end;

  if Source = MainGrid then
  begin
    if (Data.CatalogDataSource.DataSet.FieldByName('Cat_Id').AsInteger = 0) or
       (Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString = '') then
      Exit;

    if Data.CatalogDataSource.DataSet.FieldByName('Quantity').AsString = '' then
      if Application.MessageBox('Эта позиция недоступна к заказу (не возим). Вы действительно хотите добавить ее в коммерческое предложение?', 'Подтверждение', MB_YESNO or MB_ICONQUESTION) <> IDYES then
        Exit;

    if not AddGoodsToKK(Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString,
                        Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString) then
      Application.MessageBox('Уже есть в списке', 'Сообщение', MB_OK or MB_ICONINFORMATION);
  end;
end;

procedure TMain.KKGridEhDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := False;

  if (Source <> MainGrid) and (Source <> Tree) then
    Exit;

  if Source = MainGrid then
    if (Data.CatalogDataSource.DataSet.FieldByName('Cat_Id').AsInteger = 0) or
       (Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString = '') then
      Exit;
  Accept := True;
end;

procedure TMain.KKGridEhGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  if KKGridEh.DataSource.DataSet.FieldByName('Cat_Id').AsInteger = 0 then
    AFont.Color := clRed;
end;

procedure TMain.KKGridEhKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DELETE: Data.KK.Delete;
    VK_SPACE: acKKMoveToPos.Execute;
  end;
end;

procedure TMain.lbAllPrimenClick(Sender: TObject);
begin
  StartWait;
  try
    PrimGrid.DataSource := nil;
    Data.LoadPrimen2(-1);
    pnPrimen.Visible := False;
    PrimGrid.DataSource := Data.PrimenDataSource;
  finally
    StopWait;
  end;
end;

procedure TMain.lbDownloadPictureClick(Sender: TObject);
var
  aCapt: string;
  aUrl: string;
  aRespond: TMemoryStream;
  aPictId: Integer;
begin
  {Если старый текдок < 2014.2, запрещаем онлайн загрузку}
  {if Data.fTecdocOldest then
  begin
    ShowBallonErr(lbDownloadPicture, ' Данная версия сервисной программы не поддерживает on-line загрузку изображений! ' +
                                     ' Свяжитесь с менеджером и закажите диск с актуальной версией программы. ' ,
                                     ' Используйте, пожалуйста, более актуальную версию сервисной программы.');
    exit;
  end;}
  {Если старый текдок < 2014.2, меняем ссыль для скачки}
  if Data.fTecdocOldest then
    aUrl := cPictUrl
  else
    aUrl := cPictUrlNewTecDoc;

  aCapt :=lbDownloadPicture.Caption;
  lbDownloadPicture.Caption := 'загрузка...';
  lbDownloadPicture.OnClick := nil;
  lbDownloadPicture.Update;
  aRespond := TMemoryStream.Create;
  try
    aPictId := lbDownloadPicture.Tag;
    aUrl := Format(aUrl, [aPictId div 1000, aPictId]);
    try
      IdHTTPPicts.Get(aUrl, aRespond);

      if aRespond.Size > 512 then
      begin
        //aRespond.SaveToFile('c:\_http_.txt'); //debug

        Data.PictTable.Open;
        if Data.PictTable.Locate('PICT_ID', aPictId, []) then
          Data.PictTable.Edit
        else
        begin
          Data.PictTable.Append;
          Data.PictTable.FieldByName('PICT_ID').AsInteger := aPictId;
        end;
        aRespond.Position := 0;
        TBlobField(Data.PictTable.FieldByName('PICT_DATA')).LoadFromStream(aRespond);
        Data.PictTable.Post;

        LoadTDInfo;
      end;
    except
      on E: EIdHTTPProtocolException do
      begin
        if E.ErrorCode = 404 then
          ShowBallonErr(lbDownloadPicture, 'Изображение не найдено на сервере!', 'Ошибка')
        else
          ShowBallonErr(lbDownloadPicture, 'Ошибка:' + E.Message, 'Ошибка')
      end;

      on E: Exception do
      begin
        ShowBallonErr(lbDownloadPicture, 'Ошибка:' + E.Message, 'Ошибка')
      end;
    end;
  finally
    aRespond.Free;
    lbDownloadPicture.Caption := aCapt;
    lbDownloadPicture.OnClick := lbDownloadPictureClick;
  end;
end;

procedure TMain.ArrangeNotifyButtons;

  procedure ArrangeButtomRight(aButton: TControl; var aLeft: Integer);
  begin
    if not Assigned(aButton) then
      Exit;
    if aButton.Visible then
    begin
      aLeft := aLeft - aButton.Width;
      aButton.Left := aLeft;
    end;
  end;

var
  aLeft: Integer;
  iType: TNotifyEventType;
begin
  aLeft := btNotify.Parent.ClientWidth - 1;

  ArrangeButtomRight(btNotify, aLeft);
  for iType := Low(TNotifyEventType) to High(TNotifyEventType) do
    ArrangeButtomRight(fNotifyButtons[iType], aLeft);
end;

procedure TMain.RaiseNotifyEvent(const aText, aCaption: string;
  aType: TNotifyEventType; const aLogText: string);
const
  cMaxHintLines = 10;
var
  i: Integer;
  sl: TStrings;
  aLogHintText: string;
begin
  fRaisedNotifyEvents[aType] := True;

  btNotify.Visible := True;

  ArrangeNotifyButtons;
  UBallonSupport.ShowBallonInfoLink(btNotify, #13#10 + aText + #13#10, aCaption, BallonLinkClick, Ord(aType));

  if aLogText <> '' then
    aLogHintText := aLogText
  else
    aLogHintText := aText;


  sl := TStringList.Create;
  sl.Text := aLogHintText;
  try
    for i := 0 to sl.Count - 1 do
      fNotifyLog.Add(FormatDateTime('hh:nn:ss', Now()) + '$' + sl[i]);
  finally
    sl.Free;
  end;

(*
  if fNotifyLog.Count > cMaxHintLines then
  begin
    for i := 0 to cMaxHintLines do
      s := s + fNotifyLog[i] + #13#10;
    s := s + Format('[ ещё %d ... ]', [fNotifyLog.Count - cMaxHintLines]);
  end
  else
    s := fNotifyLog.Text;
  btNotify.Hint := '*** Последние уведомления ***'#13#10 + s;
*)
  btNotify.Hint := '*** Последние уведомления ***'#13#10 + aLogHintText;
  btNotify.Caption := IntToStr(fNotifyLog.Count);
  btNotify.ShowHint := True;
//  btNotify.ShowHint := False;
end;

procedure TMain.btNotifyClick(Sender: TObject);
begin
  TNotifyLogForm.Execute(fNotifyLog);
  if fNotifyLog.Count = 0 then
    btNotify.Hide;
end;

procedure TMain.btNotifyOrdersClick(Sender: TObject);
begin
  fRaisedNotifyEvents[netOrders] := False;
  btNotifyOrders.Visible := False;
  ArrangeNotifyButtons;
end;

procedure TMain.NotifyButtonClick(Sender: TObject);
var
  aTag: Integer;
  aType: TNotifyEventType;
begin
  if Sender is TSpeedButton then
  begin
    aTag := (Sender as TSpeedButton).Tag;
    if (aTag < Ord(Low(TNotifyEventType))) or (aTag > Ord(High(TNotifyEventType))) then
      Exit;

    aType := TNotifyEventType(aTag);
    case aType of
      netUnknown: ;
      netDiscounts: ;
      netOrders: ;
      netRetdocs: ;
      netWaitList: ;
    end;

    fRaisedNotifyEvents[aType] := False;
    if Assigned(fNotifyButtons[aType]) then
      fNotifyButtons[aType].Visible := False;
    ArrangeNotifyButtons;
  end;
end;


procedure TMain.RotateTimerTimer(Sender: TObject);
var
  aRaised: Boolean;
begin
{  for iType := Low(TNotifyEventType) to High(TNotifyEventType) do
  begin
    if fRaisedNotifyEvents[iType] and Assigned(fNotifyButtons[iType]) then
    begin
      aRaised := True;
      if fNotifyButtons[iType].Layout = blGlyphLeft then
        fNotifyButtons[iType].Layout := blGlyphRight
      else
        fNotifyButtons[iType].Layout := blGlyphLeft;
    end;
  end;
}

  aRaised := fNotifyLog.Count > 0;
  if aRaised then
    if btNotify.Tag = 0 then
    begin
      btNotify.Glyph.Assign(btLampOn.Glyph);
      btNotify.Tag := 1;
    end
    else
    begin
      btNotify.Glyph.Assign(btLampOff.Glyph);
      btNotify.Tag := 0;
    end;
end;


procedure TMain.RunTVSupport;
var
  aFileName: string;
begin
  aFileName := IncludeTrailingPathDelimiter(Data.Data_Path) + 'tvr.exe';

  if FileExists(aFileName) then
    ShellExecute(Handle, nil, PAnsiChar(aFileName), nil, nil, SW_SHOW)
  else
    if Application.MessageBox('Модуль удаленной поддержки не найден'#13#10'Хотите загрузить его с сайта Шате-М+', 'Подтверждение', MB_YESNO or MB_ICONQUESTION) = IDYES then
      ShellExecute(Handle, nil, PAnsiChar(cTeamViewerUrl), nil, nil, SW_SHOW);

end;

function TMain.DoTcpConnect(aClient: TIdTcpClient;
  aShowErrorOnFail: Boolean = True; aUsePortIn: Boolean = False): Boolean;

var
  aPort, aPortB2B: integer;
begin
  Result := False;
  if aClient.Connected then
    aClient.Disconnect;

  if not aUsePortIn then
  begin
   aPort := Data.SysParamTable.FieldByName('Port').AsInteger;
   aPortB2B := Data.SysParamTable.FieldByName('PortB2B').AsInteger;
  end
  else
  begin
   aPort := Data.SysParamTable.FieldByName('PortIn').AsInteger;
   aPortB2B := Data.SysParamTable.FieldByName('PortB2BIn').AsInteger;
  end;

  aClient.ConnectTimeout := 5000;
  aClient.ReadTimeout := 5000;
  try
    try
      {$IFDEF TEST}
      aClient.Host := cTestTCPHost;
      aClient.Port := 6003;
      {$ELSE}                                     //  MSXML2_TLB in 'C:\Users\belikov\Documents\RAD Studio\5.0\Imports\MSXML2_TLB.pas';
      aClient.Host := Data.SysParamTable.FieldByName('TCPHostOpt').AsString; //cHostMx3 //spbypriw0140
      aClient.Port := aPort;
      {$ENDIF}
      aClient.Connect;
    except
      try
        aClient.Host := Data.SysParamTable.FieldByName('Host').AsString; //сHostDSL1
        aClient.Port := aPort;
        aClient.Connect;
      except
        try
          aClient.Host := Data.SysParamTable.FieldByName('TCPHost3').AsString; //сHost3G
          aClient.Port := aPort;
          aClient.Connect;
        except
          aClient.Host := Data.SysParamTable.FieldByName('BackHost').AsString;//сHostDSL1
          aClient.Port := aPortB2B;
          aClient.Connect;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      aClient.Disconnect;
      if aShowErrorOnFail then
        MessageDlg('Ошибка подключения: ' + E.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;
  Result := True;
end;

{$IFDEF LOCAL}
procedure TMain.doUpdateAllClients(aAutoUpdate: Boolean);
var
  aTable: TDBISamTable;
  aIni: TIniFile;
  aEmail: string;
  aNotQuery: Boolean;
  aCurVer, aNewVer: Integer;
begin
  if fLocalMode then
    aIni := TIniFile.Create(Data.GetDomainName + '\' + cLocalVerIniFile)
  else
    aIni := TIniFile.Create(GetAppDir + cLocalVerIniFile);
  try
    aEmail := aIni.ReadString('UPDATE', 'UseEmail', '#NOTEXISTS#');
    aNotQuery := aIni.ReadBool('UPDATE', 'NotQuery', False);
    {Костыль, т.к. ini не всегда подчищается при удалении 011 таблы}
    if not aAutoUpdate then
      aCurVer := aIni.ReadInteger('UPDATE', 'ClientsVersion', 0)
    else
      aCurVer := 0;
       
    if (aEMail = '#NOTEXISTS#') then
      if aAutoUpdate then
        Exit
      else
        aEmail := '';
    if aAutoUpdate or aNotQuery or TUpdateClientsParamsForm.Execute(aEmail, aNotQuery) then
    begin
      aIni.WriteString('UPDATE', 'UseEmail', aEmail);
      aIni.WriteBool('UPDATE', 'NotQuery', aNotQuery);
    end;
  finally
    aIni.Free;
  end;

  Data.CopyTableBase('011', '011_new');
  aTable := TDBISamTable.Create(nil);
  aTable.DatabaseName := GetCurrentBD; //Data.Database.DatabaseName;
  aTable.TableName := '011_new';
  try
    aNewVer := UpdateClientsAll(aCurVer, aTable, aEmail, aAutoUpdate);
    if (aNewVer > 0)(* and (aNewVer <> aCurVer) *)then
    begin
      aTable.Close;
      Data.ClIDsTable.Close;
      Data.XClIDsTable.Close;
      Table.Close;
      Data.OrderTable.Close;
      Data.ReturnDocTable.Close;
      Data.WaitListTable.Close;

      Data.RenameTableDBI('011_new', '011');

      if fLocalMode then
        aIni := TIniFile.Create(Data.GetDomainName + '\' + cLocalVerIniFile)
      else
        aIni := TIniFile.Create(GetAppDir + cLocalVerIniFile);
      try
        aIni.WriteInteger('UPDATE', 'ClientsVersion', aNewVer);
      finally
        aIni.Free;
      end;
    end;
  finally
    aTable.Free;
    Data.ClIDsTable.Open;
    Data.OrderTable.Open;
    Data.ReturnDocTable.Open;
    Data.WaitListTable.Open;
    LoadUserID;
  end;
end;
{$ENDIF}

procedure TMain.CreateScheduledTasks;

  function CreateTaskDirectory: TTaskDirectory;
  begin

    Result := TTaskDirectory.Create;
    Result.OnBeforeRun := TaskDirectoryBeforeRun;
    Result.OnAfterEnd := TaskDirectoryAfterEnd;
    Result.LogProc := TaskLog;

    Result.Schedule.StartDelay.Interval := START_DELAY_INTERVAL_DIRECTORY;
    Result.Schedule.StartDelay.Multiply := imSecond;

    Result.Schedule.Repeatable := Data.ParamTable.FieldByName('AutoCheckDirectoryInt').AsInteger > 0;//True;
    Result.Schedule.RepeatEach.Interval := Data.ParamTable.FieldByName('AutoCheckDirectoryInt').AsInteger;//60;
    Result.Schedule.RepeatEach.Multiply := imMinute;

    Result.Schedule.Scheduled := True;
    Result.Enabled := Data.ParamTable.FieldByName('AutoCheckDirectory').AsBoolean;//True;
  end;

  function CreateTaskDiscounts: TTaskDiscounts;
  begin
    Result := TTaskDiscounts.Create;
    Result.OnBeforeRun := TaskDiscountsBeforeRun;
    Result.OnAfterEnd := TaskDiscountsAfterEnd;
    Result.LogProc := TaskLog;

    Result.Schedule.StartDelay.Interval := START_DELAY_INTERVAL_DISCOUNT;
    Result.Schedule.StartDelay.Multiply := imSecond;

    Result.Schedule.Repeatable := Data.ParamTable.FieldByName('AutoCheckDiscountsInt').AsInteger > 0;
    Result.Schedule.RepeatEach.Interval := Data.ParamTable.FieldByName('AutoCheckDiscountsInt').AsInteger;
    Result.Schedule.RepeatEach.Multiply := imMinute;

    Result.Schedule.Scheduled := True;
    Result.Enabled := Data.ParamTable.FieldByName('AutoCheckDiscounts').AsBoolean;
  end;

  function CreateTaskOrders: TTaskOrders;
  begin
    Result := TTaskOrders.Create;
    Result.OnBeforeRun := TaskOrdersBeforeRun;
    Result.OnAfterEnd := TaskOrdersAfterEnd;
    Result.LogProc := TaskLog;

    Result.Schedule.StartDelay.Interval := START_DELAY_INTERVAL_ORDERS;
    Result.Schedule.StartDelay.Multiply := imSecond;

    Result.Schedule.Repeatable := Data.ParamTable.FieldByName('AutoCheckOrdersInt').AsInteger > 0;
    Result.Schedule.RepeatEach.Interval := Data.ParamTable.FieldByName('AutoCheckOrdersInt').AsInteger;
    Result.Schedule.RepeatEach.Multiply := imMinute;

    Result.Schedule.Scheduled := True;
    Result.Enabled := Data.ParamTable.FieldByName('AutoCheckOrders').AsBoolean;
  end;

  function CreateTaskStatuses: TTaskOrdersStatus;
  begin
    Result := TTaskOrdersStatus.Create;
    Result.OnBeforeRun := TaskOrdersStatusBeforeRun;
    Result.OnAfterEnd := TaskOrdersStatusAfterEnd;
    Result.LogProc := TaskLog;

    Result.Schedule.StartDelay.Interval := START_DELAY_INTERVAL_ORDER_STATUS;
    Result.Schedule.StartDelay.Multiply := imSecond;

    Result.Schedule.Repeatable := Data.ParamTable.FieldByName('AutoCheckStatusesInt').AsInteger > 0;
    Result.Schedule.RepeatEach.Interval := Data.ParamTable.FieldByName('AutoCheckStatusesInt').AsInteger;
    Result.Schedule.RepeatEach.Multiply := imMinute;

    Result.Schedule.Scheduled := True;
    Result.Enabled := Data.ParamTable.FieldByName('AutoCheckStatuses').AsBoolean;
  end;

  function CreateTaskRss: TTaskRss;
  begin
    Result := TTaskRss.Create;
    Result.OnBeforeRun := TaskRssBeforeRun;
    Result.OnAfterEnd := TaskRssAfterEnd;
    Result.LogProc := TaskLog;

    Result.Schedule.StartDelay.Interval := START_DELAY_INTERVAL_RSS;
    Result.Schedule.StartDelay.Multiply := imSecond;

    Result.Schedule.Repeatable := Data.ParamTable.FieldByName('AutoCheckRssInt').AsInteger > 0;
    Result.Schedule.RepeatEach.Interval := Data.ParamTable.FieldByName('AutoCheckRssInt').AsInteger;
    Result.Schedule.RepeatEach.Multiply := imMinute;

    Result.Schedule.Scheduled := True;
    Result.Enabled := Data.ParamTable.FieldByName('AutoCheckRss').AsBoolean;
  end;

  function CreateTaskRates: TTaskRates;
  begin
    Result := TTaskRates.Create;
    Result.OnBeforeRun := TaskRatesBeforeRun;
    Result.OnAfterEnd := TaskRatesAfterEnd;
    Result.LogProc := TaskLog;

    Result.Schedule.StartDelay.Interval := START_DELAY_INTERVAL_RATES;
    Result.Schedule.StartDelay.Multiply := imSecond;

    Result.Schedule.Repeatable := TRUE;
    Result.Schedule.RepeatEach.Interval := INTERVAL_UPDATE_RATES;
    Result.Schedule.RepeatEach.Multiply := imMinute;

    Result.Schedule.Scheduled := True;
    Result.Enabled := True;//Data.ParamTable.FieldByName('bAutoCheckRates').AsBoolean;
  end;

begin
{$IFNDEF LOCAL}
//  fScheduler.AddTask(CreateTaskDiscounts);
  fScheduler.AddTask(CreateTaskDirectory); //для NAV забор всех справочников
{$ENDIF}
  fScheduler.AddTask(CreateTaskOrders);
//  fScheduler.AddTask(CreateTaskStatuses); //не работает в NAV
  fScheduler.AddTask(CreateTaskRss);
  fScheduler.AddTask(CreateTaskRates);
end;

procedure TMain.CreateXmlForWebService(aPath: string);
var
  head, body, DivTag, EndHead, fName, addres: string;
  Full: TStringList;
begin
  Full := TStringList.Create();
  head := '<?xml version="1.0" encoding="UTF-8"?>';
  body := '<Document Document_Type="#Order#" Customer_ID="#cli_id#" Request_No="#req_num#" Document_Date="#data#" Agreement_No="#Agreement_No#" Currency="#cur#" Ship_Address="#Ship_Address#" Comment="#descr#" >';
  DivTag := '<Line Item_No = "#code_brand#" Quantity="#quant#"/>' ;
  EndHead := '</Document>';

  Full.Append(head);
  Full.Append(body);
  try
    if Main.Pager.ActivePage = CatZakPage then
    begin
      if Data.ContractsCliTable.Locate('contract_id',Data.OrderTable.FieldByName('Agreement_No').AsString,[]) then
        addres := Data.ContractsCliTable.FieldByName('Addres_Id').AsString;
      fName := 'Sale_Orders.xml';
      Full.Text := StringReplace(Full.Text,'#Order#','Order',[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#cli_id#',Data.OrderTable.FieldByName('cli_id').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#req_num#',Data.OrderTable.FieldByName('order_id').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#data#',Data.OrderTable.FieldByName('Date').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#Agreement_No#',AnsiToUtf8(Data.OrderTable.FieldByName('Agreement_No').AsString),[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#cur#',Data.OrderTable.FieldByName('Currency').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#Ship_Address#',AnsiToUtf8(addres),[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#descr#',AnsiToUtf8(Data.OrderTable.FieldByName('Description').AsString),[rfReplaceAll]);

      Data.OrderDetTable.First;
      while not Data.OrderDetTable.Eof do
      begin
        Full.Append(DivTag);
        Full.Text := StringReplace(Full.Text,'#code_brand#',Data.OrderDetTable.FieldByName('ArtCodeBrand').AsString,[rfReplaceAll]);
        Full.Text := StringReplace(Full.Text,'#quant#',Data.OrderDetTable.FieldByName('Quantity').AsString,[rfReplaceAll]);
        Data.OrderDetTable.Next;
      end;
    end
    else if Main.Pager.ActivePage = ReturnDocPage then
    begin
      if Data.ContractsCliTable.Locate('contract_id',Data.ReturnDocTable.FieldByName('Agreement_No').AsInteger,[]) then
        addres := Data.ContractsCliTable.FieldByName('Addres_Id').AsString;
      fName := 'Sale_Returns.xml';
      Full.Text := StringReplace(Full.Text,'#Order#','Return',[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#cli_id#',Data.ReturnDocTable.FieldByName('cli_id').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#req_num#',Data.ReturnDocTable.FieldByName('RetDoc_ID').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#data#',Data.ReturnDocTable.FieldByName('Data').AsString,[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#Agreement_No#',AnsiToUtf8(Data.ReturnDocTable.FieldByName('Agreement_No').AsString),[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#cur#',{Data.ReturnDocTable.FieldByName('Currency').AsString}AnsiToUtf8('В проекте'),[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#Ship_Address#',AnsiToUtf8(addres),[rfReplaceAll]);
      Full.Text := StringReplace(Full.Text,'#descr#',AnsiToUtf8(Data.ReturnDocTable.FieldByName('Note').AsString),[rfReplaceAll]);

      Data.ReturnDocDetTable.First;
      while not Data.ReturnDocDetTable.Eof do
      begin
        Full.Append(DivTag);
        Full.Text := StringReplace(Full.Text,'#code_brand#',AnsiToUtf8(Data.ReturnDocDetTable.FieldByName('Code').AsString +'_'+ Data.ReturnDocDetTable.FieldByName('brand').AsString),[rfReplaceAll]);
        Full.Text := StringReplace(Full.Text,'#quant#',Data.ReturnDocDetTable.FieldByName('Quantity').AsString,[rfReplaceAll]);
        Data.ReturnDocDetTable.Next;
      end;
    end;

    Full.Append(EndHead);
    Full.SaveToFile(aPath + fName);
    
  finally
    Full.Free;
  end;
end;

procedure TMain.UpdateScheduledTasks;
var
  i: Integer;
  aTask: TCommonTask;
begin
  for i := 0 to fScheduler.TaskCount - 1 do
  begin
    aTask := fScheduler.GetTask(i);

    if aTask is TTaskDirectory then
    begin
      aTask.Schedule.Repeatable := Data.ParamTable.FieldByName('AutoCheckDirectoryInt').AsInteger > 0;
      aTask.Schedule.RepeatEach.Interval := Data.ParamTable.FieldByName('AutoCheckDirectoryInt').AsInteger;
      aTask.Schedule.RepeatEach.Multiply := imMinute;

      aTask.Schedule.Scheduled := True;
      aTask.Enabled := Data.ParamTable.FieldByName('AutoCheckDirectory').AsBoolean;
    end
    else if aTask is TTaskDiscounts then
    begin
      aTask.Schedule.Repeatable := Data.ParamTable.FieldByName('AutoCheckDiscountsInt').AsInteger > 0;
      aTask.Schedule.RepeatEach.Interval := Data.ParamTable.FieldByName('AutoCheckDiscountsInt').AsInteger;
      aTask.Schedule.RepeatEach.Multiply := imMinute;

      aTask.Schedule.Scheduled := True;
      aTask.Enabled := Data.ParamTable.FieldByName('AutoCheckDiscounts').AsBoolean;
    end
    else if aTask is TTaskOrders then
    begin
      aTask.Schedule.Repeatable := Data.ParamTable.FieldByName('AutoCheckOrdersInt').AsInteger > 0;
      aTask.Schedule.RepeatEach.Interval := Data.ParamTable.FieldByName('AutoCheckOrdersInt').AsInteger;
      aTask.Schedule.RepeatEach.Multiply := imMinute;

      aTask.Schedule.Scheduled := True;
      aTask.Enabled := Data.ParamTable.FieldByName('AutoCheckOrders').AsBoolean;
    end
    else if aTask is TTaskOrdersStatus then
    begin
      aTask.Schedule.Repeatable := Data.ParamTable.FieldByName('AutoCheckStatusesInt').AsInteger > 0;
      aTask.Schedule.RepeatEach.Interval := Data.ParamTable.FieldByName('AutoCheckStatusesInt').AsInteger;
      aTask.Schedule.RepeatEach.Multiply := imMinute;

      aTask.Schedule.Scheduled := True;
      aTask.Enabled := Data.ParamTable.FieldByName('AutoCheckStatuses').AsBoolean;
    end
    else if aTask is TTaskRss then
    begin
      aTask.Schedule.Repeatable := Data.ParamTable.FieldByName('AutoCheckRssInt').AsInteger > 0;
      aTask.Schedule.RepeatEach.Interval := Data.ParamTable.FieldByName('AutoCheckRssInt').AsInteger;
      aTask.Schedule.RepeatEach.Multiply := imMinute;

      aTask.Schedule.Scheduled := True;
      aTask.Enabled := Data.ParamTable.FieldByName('AutoCheckRss').AsBoolean;
    end
    else if aTask is TTaskRates then
    begin
      aTask.Schedule.Repeatable := TRUE;
      aTask.Schedule.RepeatEach.Interval := INTERVAL_UPDATE_RATES;
      aTask.Schedule.RepeatEach.Multiply := imMinute;

      aTask.Schedule.Scheduled := True;
      aTask.Enabled := True;//Data.ParamTable.FieldByName('bAutoCheckRates').AsBoolean;
    end;


  end;
end;

procedure TMain.TaskLog(const aText: string; isDebug: Boolean = False; aWithoutDateTime: Boolean = False);
var
  f: TextFile;
  aDebugLabel: string;
  fLogFileName: string;
begin
//  if isDebug and not fPrefs.DebugLogEnabled then
//    Exit;
  if not fDebugRun then
    Exit;

  fLogFileName := GetAppDir + 'Tasks.log';
  fLogLock.Enter;
  try
    if isDebug then
      aDebugLabel := '# '
    else
      aDebugLabel := '';

    AssignFile(f, fLogFileName);
    if not FileExists(fLogFileName) then
      Rewrite(f)
    else
      Append(f);
    try
      if aWithoutDateTime then
        Writeln(f, aDebugLabel + aText)
      else
        Writeln(f, FormatDateTime('dd.mm.yyyy hh:nn:ss', Now()) + ' - ' + aDebugLabel + aText);
    finally
      CloseFile(f);
    end;
//    Memo1.Lines.Add(aDebugLabel + aText);
  finally
    fLogLock.Leave;
  end;
end;

function TMain.IsGroupNewCartNeeded(aGroupId, aSubgroupId: Integer; out aUnion: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(cNewOrderGroups) to High(cNewOrderGroups) do
    if (aGroupId = cNewOrderGroups[i].GroupId) and
       ((aSubgroupId = cNewOrderGroups[i].SubgroupId) or (cNewOrderGroups[i].SubgroupId = -1)) then
    begin
      aUnion := cNewOrderGroups[i].Union;
      Result := True;
      Exit;
    end;
end;

function TMain.isOpenedMoreThan2Windows(ActiveForm: TComponentName): bool;
  const AUTO_OPEN_FORMS: array [0..4] of string = ('Info', 'UpdatesWindows', 'MainParam', 'OrderEdit', 'ReturnDocED');
var
  i, j: Integer;
  fBreak: boolean;
begin
  result := FALSE;
  fBreak := FALSE;
  for i := Screen.FormCount - 1 downto 0 do
  begin
    for j := 0 to length(AUTO_OPEN_FORMS)-1 do
    begin
      if (Screen.Forms[i].Name = AUTO_OPEN_FORMS[j]) and (Screen.Forms[i].Name <> ActiveForm) then
      begin
        result := TRUE;
        fBreak := TRUE;
        break;
      end;
    end;
    if fBreak then
      break;
  end;
end;

function TMain.GetNewCartGroups: string;
var
  i: Integer;
begin
  Result := '';
  for i := Low(cNewOrderGroups) to High(cNewOrderGroups) do
  begin
    if cNewOrderGroups[i].SubgroupId = -1 then
    begin
      if Data.XGroupTable.Locate('GROUP_ID', cNewOrderGroups[i].GroupId, []) then
        Result := Result + #13#10 + '   [' + Data.XGroupTable.FieldByName('GROUP_DESCR').AsString + ']';
    end
    else
      if Data.XGroupTable.Locate('GROUP_ID;SUBGROUP_ID', VarArrayOf([cNewOrderGroups[i].GroupId, cNewOrderGroups[i].SubgroupId]), [])  then
        Result := Result + #13#10 + '   [' + Data.XGroupTable.FieldByName('GROUP_DESCR').AsString + '/' + Data.XGroupTable.FieldByName('SUBGROUP_DESCR').AsString + ']';
  end;
  if Result <> '' then
    Delete(Result, 1, 2);
end;

function TMain.IsOrderMixGroups: Boolean;
var
  aRecNo, aUnion: Integer;
  aSimpleGoods, aExcludeGoods: Boolean;
  aCarts: TStrings;
begin
  Result := False;
  aSimpleGoods := False;
  aExcludeGoods := False;

  aCarts := TStringList.Create;
  try
    with Data.OrderDetTable do
    begin
      aRecNo := RecNo;
      First;
      while not Eof do
      begin
        if IsGroupNewCartNeeded(FieldByName('ArtGroupId').AsInteger, FieldByName('ArtSubgroupId').AsInteger, aUnion) then
        begin
          if aCarts.IndexOf(IntToStr(aUnion)) = -1 then
            aCarts.Add(IntToStr(aUnion));
          aExcludeGoods := True;
        end
        else
          aSimpleGoods := True;
                                                       //заказ нужно разбить если:
        if (aSimpleGoods and aExcludeGoods) or         // обычные и исключаемые товары вместе
           (aExcludeGoods and (aCarts.Count > 1)) then // или исключаемые товары должны быть в разных корзинах
        begin
          Result := True;
          Break;
        end;
        Next;
      end;
      RecNo := aRecNo;
    end;
  finally
    aCarts.Free;
  end;
end;

procedure TMain.SplitMixOrder({out}aResIDs: TStrings);
var
  aCurOrderId: Integer;
  aNewOrderId: string;
  aUnion, i: Integer;
  aCarts: TStrings;
  aHasSimpleGoods: Boolean;
begin
  aResIDs.Clear;

  aCarts := TStringList.Create;
  try

    aCurOrderId := Data.OrderTable.FieldByName('ORDER_ID').AsInteger;
    aHasSimpleGoods := False;
    //собираем ID'шки для переноса
    with Data.OrderDetTable do
    begin
      First;
      while not Eof do
      begin
        if IsGroupNewCartNeeded(FieldByName('ArtGroupId').AsInteger, FieldByName('ArtSubgroupId').AsInteger, aUnion) then
        begin
          //собираем IDшки по корзинам
          i := aCarts.IndexOfName(IntToStr(aUnion));
          if i = -1 then
            aCarts.Add(IntToStr(aUnion) + '=' + FieldByName('ID').AsString)
          else
            aCarts[i] := aCarts[i] + ',' + FieldByName('ID').AsString;
        end
        else
          aHasSimpleGoods := True;
        Next;
      end;
    end;

    //не содержит обычных товаров, если все перенести то текущий заказ останется пустым
    if not aHasSimpleGoods then
      aCarts.Delete(0);//оставляем первую пачку в текущем заказе

    for i := 0 to aCarts.Count - 1 do
    begin
      //новая корзина
       Data.ExecuteQuery(
        ' INSERT INTO [009] ("Date", Num, Code, Cli_id, "Description", State, Type, Delivery, Currency, Agreement_No, Addres_Id) ' +
        ' SELECT "Date", Num, Code, Cli_id, "Description", State, Type, Delivery, Currency, Agreement_No, Addres_Id FROM [009] WHERE ORDER_ID = ' + IntToStr(aCurOrderId));
      aNewOrderId := Data.ExecuteSimpleSelect(' SELECT Max(ORDER_ID) FROM [009] ', [], True);
      aResIDs.Add(aNewOrderId);

      //переносим товары
      Data.ExecuteQuery(' UPDATE [010] SET ORDER_ID = ' + aNewOrderId + ' WHERE ID IN(' + aCarts.ValueFromIndex[i] + ')');
    end;

  finally
    aCarts.Free;
  end;


  //перелинковываем
{
  Data.ExecuteQuery(
    ' UPDATE [009] SET MERGED_ORDER = ' + IntToStr(aNewOrderId) + ' WHERE ORDER_ID = ' + IntToStr(aCurOrderId)
  );
  Data.ExecuteQuery(
    ' UPDATE [009] SET MERGED_ORDER = ' + IntToStr(aCurOrderId) + ' WHERE ORDER_ID = ' + IntToStr(aNewOrderId)
  );
}
  //---------------

  Data.OrderTable.Refresh;
  Data.OrderDetTable.Refresh;
end;

procedure TMain.ImportNAV;
var
  aReader: TCSVReader;
begin
  aReader := TCSVReader.Create;
  try
    aReader.Open('E:\1.csv');
    Data.DeliveryAddressTable.Open;
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      Data.DeliveryAddressTable.Append;
      Data.DeliveryAddressTable.FieldByName('Addres_Id').AsString :=aReader.Fields[0];
      Data.DeliveryAddressTable.FieldByName('Descr').AsString :=aReader.Fields[1];
      Data.DeliveryAddressTable.FieldByName('Addres').AsString :=aReader.Fields[2];
      Data.DeliveryAddressTable.Post;
    end;
  finally
    Data.DeliveryAddressTable.Close;
    aReader.Free;
  end;
end;

{procedure TMain.ImportPricesOnly;
var
  aReader: TCSVReader;
  aCode, aBrand: string;
  anUpdated, anAll: Integer;
begin
  if not OpenDialogCSV.Execute then
    Exit;

  anUpdated := 0;
  anAll := 0;

  Data.LoadCatTable.Open;
  aReader := TCSVReader.Create;
  try
    aReader.Open(OpenDialogCSV.FileName);
    while not aReader.Eof do
    begin
      Inc(anAll);
      aReader.ReturnLine;
      Data.DecodeCodeBrand(aReader.Fields[0], aCode, aBrand);
      if Data.BrandTable.Locate('Description', aBrand, []) then
        if Data.LoadCatTable.FindKey([aCode, Data.BrandTable.FieldByName('brand_id').AsInteger]) then
        begin
          Data.LoadCatTable.Edit;
          Data.LoadCatTable.FieldByName('Price').AsCurrency := AToCurr(aReader.Fields[1]);
          Data.LoadCatTable.Post;
          Inc(anUpdated);
        end;
    end;
  finally
    Data.LoadCatTable.Close;
    aReader.Free;
  end;

  ShowMessage( Format('Обновлено %d из %d', [anUpdated, anAll]) );
end;        }
//http://shate-m.by/ru/news/rss.html[?count=xxx]

// e.g. http://shate-m.by/ru/news/rss.html?count=3
{
снятие предупреждения по превышению в заказах для "особых" клиентов сделал так:
 1. зайти в настройки->параметры программы
 2. перейти на вкладку "Прочие"
 3. с зажатым шифтом набрать на клавиатуре "VIPCFG"
появится скрытая опция "Ограничение количества позиций в заказе", которую можно отключить
состояние хранится в базе в настройках пользователя

одобрямс?
}
end.


