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
  IdTCPClient, VCLUnZip, VCLZip, NMpop3, Psock, {NMsmtp, }VclUtils, AdvPicture,
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
  JvGIF, jpeg, _Info, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdMessage, IdAttachmentFile, _AllQuantsForm, IdCoderHeader,
  IdHTTP, Mask, DBCtrlsEh, DBLookupEh;

const
  PROGRESS_POS_MESSAGE = WM_USER + 220;
  PROGRESS_START_UPDATE = WM_USER + 320;
  PROGRESS_UPDATE_RESTARTPROG = WM_USER + 206;
  MESSAGE_AUTOUPDATE = WM_USER + 207;
  MESSAGE_AFTER_COL_RESIZE = WM_USER + 1001;
  MESSAGE_AFTER_TOOLPANEL_RESIZE = WM_USER + 1002;

  cCheckUpdateInterval = 900000; //интервал проверки обновления (15 мин)
  cCallTCPDiscountsInterval = 10000; //минимальный интервал между запросами скидок (анти DDOS)
  cObsoleteOrderTime: TDateTime = 7{дней}; //время, через которое заказ считается устаревшим (не опрашивается его статус)

  cMaxPrimenCount = 50; //подгружать первых 50 позиций применяемости
  cMaxOrderDetCount = 20;

  cTestTCPHost = '10.0.0.93';
  //ID групп, которые требуют нового заказа (нельзя заказывать вместе с остальным ассортиментом)
  cNewOrderGroups: array[1..1] of Integer = (50);

  cPictUrl = 'http://www.shate-mag.by/data/service/picts/%d/%d.jpg';
  cRssUrl = 'http://shate-m.by/ru/news/rss.html?count=20';
  cRssRunningLineUrl = 'http://shate-m.by/ru/runningline/rss.html';
  cTeamViewerUrl = 'http://www.shate-m.by/data/service/tvr.exe';

type
  TNotifyEventType = (netUnknown, netDiscounts, netOrders, netRetdocs, netWaitList, netRss);

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
  end;

  TTextAttrRec = record
    Lo, Hi: integer;
    Background: TColor;
    Font: TFont;
  end;

  TMain = class(TForm)
    MainDockPanel: TAdvDockPanel;
    StatusBar: TAdvOfficeStatusBar;
    MenuStyler: TAdvMenuOfficeStyler;
    ToolBarStyler: TAdvToolBarOfficeStyler;
    AppStyler: TAdvAppStyler;
    FormStyler: TAdvFormStyler;
    StatusBarStyler: TAdvOfficeStatusBarOfficeStyler;
    AppStorage: TJvAppIniFileStorage;
    FormStorage: TJvFormStorage;
    MainActionList: TActionList;
    SmallImageList: TImageList;
    ExitProgAction: TAction;
    GridsPanel: TAdvPanel;
    SplitterLeft: TAdvSplitter;
    PanelStyler: TAdvPanelStyler;
    MainGridPanel: TAdvPanel;
    AdvSplitter1: TAdvSplitter;
    MainGrid: TDBGridEh;
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
    ExitToolBar: TAdvToolBar;
    ExitProgToolBarBtn: TAdvToolBarButton;
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
    NMPOP3: TNMPOP3;
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
    DBAdvMemo: TJvDotNetDBMemo;
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
    ReturnDocGrid: TDBGridEh;
    ReturnDocSplitter: TAdvSplitter;
    ReturnDocDetGrid: TDBGridEh;
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
    Label7: TLabel;
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
    AdvToolBarButton33: TAdvToolBarButton;
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
    Tree: TJvTreeView;
    AutoPanel: TAdvPanel;
    MfaModTypLabel: TLabel;
    PconLabel: TLabel;
    HpLabel: TLabel;
    FuelLabel: TLabel;
    CylLabel: TLabel;
    Button2: TButton;
    pnTreeMode: TPanel;
    ToolBarStylerCustom: TAdvToolBarOfficeStyler;
    SplitterRight: TAdvSplitter;
    N122: TMenuItem;
    PictureContainer1: TPictureContainer;
    Panel3: TPanel;
    DockPanelTreeMode: TAdvDockPanel;
    ToolBarTreeMode: TAdvToolBar;
    tbTree: TAdvToolBarButton;
    Button3: TButton;
    lbBallonPlace: TLabel;
    RotateTimer: TTimer;
    btNotify: TSpeedButton;
    btNotifyOrders: TSpeedButton;
    btNotifyRetdocs: TSpeedButton;
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
    CatZakCliPage: TAdvOfficePage;
    ReturnDocCliPage: TAdvOfficePage;
    DocLimitPage: TAdvOfficePage;
    NewSaleOrder: TAction;
    EditSaleOrder: TAction;
    DelSaleOrder: TAction;
    EmaleSaleOrder: TAction;
    SaveSaleOrder: TAction;
    UnlockSaleOrder: TAction;
    SaleOrderDockPanel: TAdvDockPanel;
    SaleOrderToolBar: TAdvToolBar;
    NewSaleOrderButton: TAdvToolBarButton;
    EditSaleOrderButton: TAdvToolBarButton;
    DelOrderActionButton: TAdvToolBarButton;
    Label11: TLabel;
    Label12: TLabel;
    AdvToolBarButton41: TAdvToolBarButton;
    AdvToolBarButton42: TAdvToolBarButton;
    AdvToolBarSeparator15: TAdvToolBarSeparator;
    AdvToolBarButton43: TAdvToolBarButton;
    SaleOrderStart: TAdvDateTimePicker;
    SaleOrderEnd: TAdvDateTimePicker;
    SaleOrderGrid: TDBGridEh;
    AdvSplitter8: TAdvSplitter;
    SaleOrderGridDet: TDBGridEh;
    NewSaleReturnDoc: TAction;
    EditSaleReturnDoc: TAction;
    DelSaleReturnDoc: TAction;
    UnlockSaleReturnDoc: TAction;
    SaveSaleReturnDoc: TAction;
    EmailSaleReturnDoc: TAction;
    AdvDockPanel4: TAdvDockPanel;
    AdvToolBar5: TAdvToolBar;
    AdvToolBarButton44: TAdvToolBarButton;
    AdvToolBarButton45: TAdvToolBarButton;
    AdvToolBarButton46: TAdvToolBarButton;
    AdvToolBarSeparator16: TAdvToolBarSeparator;
    Label13: TLabel;
    Label14: TLabel;
    AdvToolBarButton47: TAdvToolBarButton;
    AdvToolBarButton48: TAdvToolBarButton;
    AdvToolBarButton49: TAdvToolBarButton;
    DocReturnStartAdvDate: TAdvDateTimePicker;
    DocReturnEndAdvDate: TAdvDateTimePicker;
    GridReturnDoc: TDBGridEh;
    AdvSplitter9: TAdvSplitter;
    GridDocReturnDet: TDBGridEh;
    DocLimitAddAction: TAction;
    DocLimitDelAction: TAction;
    UnlockDocLimitAction: TAction;
    SaveDocLimit: TAction;
    EmailDocLimit: TAction;
    DocLimitDockPanel: TAdvDockPanel;
    DocLimitAdvToolBar: TAdvToolBar;
    DocLimitToolBarButtonNew: TAdvToolBarButton;
    DocLimitToolBarButtonDel: TAdvToolBarButton;
    AdvToolBarSeparator17: TAdvToolBarSeparator;
    Label15: TLabel;
    Label16: TLabel;
    AdvToolBarSeparator18: TAdvToolBarSeparator;
    AdvToolBarButton50: TAdvToolBarButton;
    AdvToolBarButton51: TAdvToolBarButton;
    AdvToolBarButton52: TAdvToolBarButton;
    DocLimitStartAdvDate: TAdvDateTimePicker;
    DocLimitEndAdvDate: TAdvDateTimePicker;
    DocLimitGrid: TDBGridEh;
    DocLimitAdvSplitter: TAdvSplitter;
    DocLimitGridDetail: TDBGridEh;
    IdMessage: TIdMessage;
    SMTP: TIdSMTP;
    BasesPropertiesOpen: TAction;
    N127: TMenuItem;
    DateEndReturnDoc: TAdvDateTimePicker;
    AddToDocLimitAction: TAction;
    AddToSaleReturnDoc: TAction;
    AddToSaleOrder: TAction;
    pnAllQuantsHost: TPanel;
    pnAllQuantsHostAn: TPanel;
    WebUpdateStockAction: TAction;
    N128: TMenuItem;
    splitterAllQuantsHost: TAdvSplitter;
    splitterAllQuantsHostAn: TAdvSplitter;
    AddAnToSaleOrder: TAction;
    N129: TMenuItem;
    acShowUpdateChanges: TAction;
    N131: TMenuItem;
    acRunOilCatalog: TAction;
    lbDownloadPicture: TLabel;
    pnPrimen: TPanel;
    lbAllPrimen: TLabel;
    Bevel5: TBevel;
    IdHTTPPicts: TIdHTTP;
    KitPage: TAdvOfficePage;
    KitGridEh: TDBGridEh;
    acKitMoveToPos: TAction;
    acKitAddToOrder: TAction;
    KitPopupMenu: TAdvPopupMenu;
    acKitMoveToPos1: TMenuItem;
    acKitAddToOrder1: TMenuItem;
    nPricePro: TMenuItem;
    WebUpdateExtAction: TAction;
    WebUpdateExtAction1: TMenuItem;
    Panel5: TPanel;
    lbOrderSum: TLabel;



    OrderGrid: TDBGridEh;
    OrderTitlesImageList: TImageList;
    TreeImageList: TImageList;
    CliChangeTimer: TTimer;
    PopularImageList: TImageList;
    SentImageList: TImageList;
    CliComboBox: TDBLookupComboboxEh;
    AdvToolBar6: TAdvToolBar;
    AdvToolBarButton53: TAdvToolBarButton;
    AdvToolBarButton54: TAdvToolBarButton;
    acRunOliShell: TAction;
    AdvToolBarMenuButton2: TAdvToolBarMenuButton;
    acRunSilencerFerroz: TAction;
    acRunSilencerPolmostrow: TAction;
    acRunTeamViewer: TAction;
    AdvToolBarMenuButton3: TAdvToolBarMenuButton;
    Online1: TMenuItem;
    acRunPatronCatalogs: TAction;
    AdvToolBarMenuButton4: TAdvToolBarMenuButton;
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
    procedure WebUpdateCustomValidate(Sender: TObject; Msg, Param: string;
      var Allow: Boolean);
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
    procedure AutoHistItemClick(Sender: TObject);
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
    procedure UserIds_ComboChange(Sender: TObject);
    procedure LoadDiscountTCPExecute(Sender: TObject);
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
    procedure UserIds_ComboKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    procedure UnlockSaleOrderExecute(Sender: TObject);
    procedure EmaleSaleOrderExecute(Sender: TObject);
    procedure SaveSaleOrderExecute(Sender: TObject);
    procedure UnlockSaleReturnDocExecute(Sender: TObject);
    procedure SaveSaleReturnDocExecute(Sender: TObject);
    procedure EmailSaleReturnDocExecute(Sender: TObject);
    procedure UnlockDocLimitActionExecute(Sender: TObject);
    procedure SaveDocLimitExecute(Sender: TObject);
    procedure EmailDocLimitExecute(Sender: TObject);
    procedure SaleOrderGridDblClick(Sender: TObject);
    procedure SaleOrderGridDetDblClick(Sender: TObject);
    procedure SaleOrderGridDetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SaleOrderGridDetTitleClick(Column: TColumnEh);
    procedure GridReturnDocDblClick(Sender: TObject);
    procedure GridDocReturnDetDblClick(Sender: TObject);
    procedure GridDocReturnDetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridDocReturnDetTitleClick(Column: TColumnEh);
    procedure DocLimitGridDetailDblClick(Sender: TObject);
    procedure DocLimitGridDetailKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DocLimitGridDetailTitleClick(Column: TColumnEh);
    procedure BasesPropertiesOpenExecute(Sender: TObject);
    procedure SaleOrderStartChange(Sender: TObject);
    procedure DocReturnStartAdvDateChange(Sender: TObject);
    procedure DocLimitStartAdvDateChange(Sender: TObject);
    procedure AddToDocLimitActionExecute(Sender: TObject);
    procedure AddToSaleReturnDocExecute(Sender: TObject);
    procedure AddToSaleOrderExecute(Sender: TObject);
    procedure WebUpdateStockActionExecute(Sender: TObject);
    procedure AddAnToSaleOrderExecute(Sender: TObject);
    procedure acShowUpdateChangesExecute(Sender: TObject);
    procedure acRunOilCatalogExecute(Sender: TObject);
    procedure OEInfoURLClick(Sender: TObject; const URLText: string;
      Button: TMouseButton);
    procedure IdMessageInitializeISO(var VTransferHeader: TTransfer;
      var VHeaderEncoding: Char; var VCharSet: string);
    procedure lbDownloadPictureClick(Sender: TObject);
    procedure lbAllPrimenClick(Sender: TObject);
    procedure acKitMoveToPosExecute(Sender: TObject);
    procedure acKitAddToOrderExecute(Sender: TObject);
    procedure KitGridEhDblClick(Sender: TObject);
    procedure KitGridEhKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure nPriceProClick(Sender: TObject);
    procedure WebUpdateExtActionExecute(Sender: TObject);
    procedure OrderDetGridCellClick(Column: TColumnEh);
    procedure N46Click(Sender: TObject);
    procedure ReturnDocDetGridCellClick(Column: TColumnEh);
    procedure ReturnDocGridDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ReturnDocGridDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ReturnDocDetGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ReturnDocDetGridStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure ReturnDocDetGridTitleClick(Column: TColumnEh);
    procedure CliComboBoxChange(Sender: TObject);
    procedure CliChangeTimerTimer(Sender: TObject);
    procedure CliComboBoxCloseUp(Sender: TObject; Accept: Boolean);
    procedure CliComboBoxExit(Sender: TObject);
    procedure AdvToolBarButton53Click(Sender: TObject);
    procedure acRunOliShellExecute(Sender: TObject);
    procedure acRunSilencerPolmostrowExecute(Sender: TObject);
    procedure acRunSilencerFerrozExecute(Sender: TObject);
    procedure acRunTeamViewerExecute(Sender: TObject);
    procedure acRunPatronCatalogsExecute(Sender: TObject);
  private
    //sklad
    fActiveBases: TStrings;
    fBasicTextFont: TFont;
    
    fQuantsInfo: TAllQuantsForm;
    fQuantsInfoAn: TAllQuantsForm;
  private
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
    OrderSum : Currency;
    fCanClose: Boolean;
    procedure SyncParGrid(Sender: TObject);

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

    function DoTcpConnect(aClient: TIdTcpClient; aShowErrorOnFail: Boolean = True): Boolean;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;

    {scheduled tasks support<<}
    procedure TaskLog(const aText: string; isDebug: Boolean = False; aWithoutDateTime: Boolean = False);
    procedure DebugLog(const aText: string; isDebug: Boolean = False; aWithoutDateTime: Boolean = False);

    procedure CreateScheduledTasks;
    procedure UpdateScheduledTasks;

    procedure TaskDiscountsBeforeRun(Sender: TObject; var aCanRun: Boolean);
    procedure TaskDiscountsAfterEnd(Sender: TObject);

    procedure TaskOrdersBeforeRun(Sender: TObject; var aCanRun: Boolean);
    procedure TaskOrdersAfterEnd(Sender: TObject);

    procedure TaskOrdersStatusBeforeRun(Sender: TObject; var aCanRun: Boolean);
    procedure TaskOrdersStatusAfterEnd(Sender: TObject);

    procedure TaskRssBeforeRun(Sender: TObject; var aCanRun: Boolean);
    procedure TaskRssAfterEnd(Sender: TObject);
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
    procedure ImportPricesOnly;
    procedure DrawOrderOnlyField(aGrid: TDBGridEh; aRect: TRect; State: TGridDrawState);
  public
    //sklad>>
    WriteBasesMode: Boolean;
    QuantsLargeMode: Boolean;
    
    sNameGlobalBase: string;
    sNameGlobalQuants: string;
    sNameGlobalClient: string;
    sNameGlobalID: string;
    //<<sklad

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
                
    NewProgFile: string; //закачанный новый файл программы
    NewProgVersion: string; //версия нового файла программы

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
    //очистка
    fClearSelection, fOrderMasCheck : boolean;
    ClientList : TList;

    fLastDefaultUserID: string;
    fPostOrder: boolean;
    procedure ClearSelection();
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
    function  SaveOrder_Old(FNameDialog: Boolean = True): string;
    procedure LoadOrder;
    //procedure LoadOrderTCP;
    function LoadOrderTCP1: Boolean;
    function LoadOrderTCP1_emul: Boolean;
    procedure ApplyOrderAnswer;

    function LoadRetdocTCP1: Boolean;
    procedure ApplyRetdocAnswer;

    function LoadOrderStatus: Boolean;

    procedure WebSearchOE(OE : string);

    procedure UnlockOrder;
    procedure SetStyle;
    procedure DoWebUpdate(IsExtUpdate: Boolean = False);
    procedure DoWebUpdateStock(aAutoUpdate: Boolean);
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
    procedure LoadAutoHist;
    procedure SaveAutoHist;
    function SetCarFilter(aCarId: Integer): Boolean;

    {tools}
    function StrLeft(s:string; i:integer):string;
    function StrRight(s:string; i:integer):string;
    function StrFind(s:string; ch:char):integer;
    function AToFloat(s:string):real;
    function TestString(s1,s2:string):bool;
    function AToCurr(s:string):Currency;
    function UnzipStream2Stream(aStreamIn, aStreamOut: TStream; const aFileName: string; const aPassword: string = ''): Boolean;
    function UnzipStream2File(aStreamIn: TStream; const aFileOut, aFileName: string; const aPassword: string = ''): Boolean;


    //поток обновления завершился - реальные таблицы подменяются обновленными
    procedure PostMessageFinished(var Msg: TMessage);message PROGRESS_POS_MESSAGE;
    procedure SetStatusColums(bYelow: Boolean);
    procedure CloseStatusColums;
    procedure RestartProg(var Msg: TMessage);message PROGRESS_UPDATE_RESTARTPROG;
    procedure SetMessageErrorProcessUpdate(var Msg: TMessage);
    function GetErrorMessage(fSize: Cardinal):string;
    procedure DoProcessUpdate(var Msg: TMessage);message PROGRESS_START_UPDATE;
    //MESSAGE_AUTOUPDATE - скачивает update.inf с сервера с инфой о доступных обновлениях, формирует список для закачки
    procedure DoAutoUpdateUpdate(var Msg: TMessage);message MESSAGE_AUTOUPDATE;

    function MainDownLoadFile(sURL, sFileName: string): Boolean;
    function MainDownLoadFileMirrors(aDestFileName: string; IsExtUpdate: Boolean = False; aUrlDir: string = ''): Boolean;

    procedure ClearTestQuants;
    procedure SetViewColumn;
    procedure AllPost;
    function NewReturnDoc:boolean;
    function SaveReturnDoc(sFileName: string): Boolean;
    function SaveReturnDoc_Old(var sFileName: string; aWithoutSaveDialog: Boolean = False): Boolean;
    function SendReturnDoc: Boolean;
    function SendReturnDoc_Old: Boolean;
    procedure DownloadUpdateError(var Msg: TMessage); message PROGRESS_UPDATE_NOT_FINISHED;
    procedure LockAutoUpdate(aLock: Boolean);
    procedure RefreshMemAnalogs;

    {discounts supports <}
    procedure SetActiveCli(ActiveCli : TUserIDRecord); //при заказе и возврате
    procedure LoadUserID;
    procedure UpdateUserData(aUserData: TUserIDRecord);
    function ReplaceLeftSymbol(sValue:string):string;
    function ReplaceLeftSymbolAB(sValue:string):string;
    procedure FillDiffMarginTable(const aCsvData: string);

    procedure SelectCurrentUser;
    function GetCurrentUser: TUserIDRecord;
    function GetUserDataByID(const aSearchID: string): TUserIDRecord;

    function LoadDescriptionsTCP(sID, sKey, sVersion: string; out aDiscountVersion: Integer;
      aUpdateVersion: Boolean = True; anOtherTable: TDBISAMTable = nil): Integer;
    procedure ApplyDiscounts2DB(aSourceData: TStream; const aClientID: string; aDiscountVersion: Integer; aUpdateVersion: Boolean = True; anOtherTable: TDBISAMTable = nil);
    function CheckPrivateKey(const aKey: string): Boolean;
    function CheckTcpDDOS(aWaitTime: Cardinal; aRewriteCallTime: Boolean = True): Boolean;
    procedure LoadClientsPass(aFileName: string);
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
    procedure WritePost(post: integer);
    
    //шины и диски отдельной корзиной
    function IsGroupNewCartNeeded(aGroupId: Integer): Boolean;
    function GetNewCartGroups: string;
    function IsOrderMixGroups: Boolean;
    function SplitMixOrder: Integer; {id of second(splitted) order}
    procedure CountingOrderSum;
    
    //sklad---------------------------------------------------------------------
    function CheckNeedMult(brand_id,group_id, subgroup_id, Mult : integer): integer;
    function CheckDocumentEnabled(anEditAction: TAction): Boolean;
    function UnlockDocument(aTable: TDBISamTable): Boolean;
    procedure BasesChanged;
    procedure ChangeInterfaceForScladCurr(Curr: string);
    function GetAllQuantsInfo(aCatId: Integer): string; overload;
    procedure GetAllQuantsInfo(aCatId: Integer; aRes: TStrings); overload;
    procedure UpdateAllQuantsInfo(aForCatalog, aForAnalog: Boolean);
    function  IsQuantsBaseActive(aBaseCode: Integer): Boolean;
    //--------------------------------------------------------------------------

    function SendEMailByTCP(const aFrom, aTo, aSubject, aBody, aFileToAttach: string): Boolean;
    function GetUpdateServersList(aServerList: TStrings): Boolean;

    property UpdateQueue: TUpdateQueue read fUpdateQueue;
    property UpdateMirrors: TStrings read GetMirrorsList;
    property CurrentWorkingServer: string read fCurrentWorkingServer;
  end;

var
  Main: TMain;
  Data_mode: smallint;  // Режим работы с базой данных
  bTerminate: Boolean;  //if False - TUpdateThrd работает

resourcestring
  BSExitprogMess   = 'Выйти из программы?';
  BsNoImageText    = '<P align="center">ИЗОБРАЖЕНИЕ<BR>ОТСУТСТВУЕТ</P>';
const
  UPD_PWD          = 'shatem+';
  UPD_DATA_ZIP     = 'data.zip';
  UPD_DATA_DISCRET = 'data_d';
  UPD_PICTS_DISCRET= 'picts_d';
  UPD_QUANTS_ZIP   = 'quants.zip';
  UPD_NEWS_ZIP     = 'news.zip';
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
  Excel_TLB, _TireCalcForm{kri}, NativeXml, _Task_Rss{kri}, RssTools{kri}, _OrderOnlyInfoForm{kri},
  {sklad}
  _SaleOrderInfo, _SaleOrderAdd, _ReturnDocInfo, __AddToReturnDocWindow,
  _DocLimitWindow, _BasesProperties;

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
  i, pos : integer;
begin
  if Data.OrderDetTable.Eof then
    Exit;

    {
     with Data.OrderDetTable do
      begin
        Append;
        FieldByName('Order_id').Value :=
             Data.OrderTable.FieldByName('Order_id').AsInteger;
        FieldByName('Code2').Value :=
             Data.WaitListTable.FieldByName('Code2').AsString;
        FieldByName('Brand').Value :=
             Data.WaitListTable.FieldByName('Brand').AsString;
        if FieldByName('ArtSale').AsString <> '1' then
          FieldByName('Price').Value :=
            Data.GetDiscount(Data.WaitListTable.FieldByName('ArtBrandId').AsInteger) *
            Data.WaitListTable.FieldByName('ArtPrice').AsCurrency
        else
          FieldByName('Price').Value :=
            Data.WaitListTable.FieldByName('ArtPrice').AsCurrency;
        FieldByName('Quantity').Value := QuantityEd.Value;
        FieldByName('Info').Value := InfoEd.Text;
        Post;
      end;

    }
  with Data.WaitListTable do
  begin
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
    Post;
    Data.CalcWaitList;
    Data.OrderDetTable.Delete;
    end;
  end;
  ClearSelection;
  Data.OrderTable.Refresh;
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
          UpdateOrdersFilter(GetCurrentUser);
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
//  MainMenu.UpdateMenu;
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
     //(Y > ReturnDocDetGrid.Top + ReturnDocDetGrid.TitleHeight)
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
    EditReturnDocAction.Execute;
  if Key = VK_DELETE then
    DelReturnDocAction.Execute;
end;

procedure TMain.ReturnInfoExecute(Sender: TObject);
begin
    //смчсм
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
  aSavedOrderID: Integer;
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
  try
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
          Exit;
      end;
    end;

    SetParametrValue(
      Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString,
      Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString,
      Data.CatalogDataSource.DataSet.FieldByName('Name_Descr').AsString,
      '',
      1,
      True {aIsNew}
    );

    Color := Data.ParamTable.FieldByName('ColorReturnPost').AsInteger;
    Caption := Caption + ' [добавление]';
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
          FieldByName('RetDoc_ID').Value := Data.ReturnDocTable.FieldByName('RetDoc_ID').AsInteger;
          FieldByName('Code2').Value := Data.CatalogDataSource.DataSet.FieldByName('Code2').AsString;
          FieldByName('Brand').Value := Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString;
        end
        else
          Edit;
        FieldByName('Quantity').Value := FieldByName('Quantity').AsFloat + QuantityEd.Value;
        FieldByName('Note').Value := InfoEd.Text;
        Post;
      end;
    end;
  finally
    Free;
  end;
end;

procedure TMain.FormCreate(Sender: TObject);

  function FindCmdLineSwitchEx(const Switch: string; const Chars: TSysCharSet;
    IgnoreCase: Boolean; aFindByPart: Boolean; var aWholeSwitch: string): Boolean;
  var
    I: Integer;
    S: string;
    aCount: Integer;
  begin
    aCount := MaxInt;
    if aFindByPart then
      aCount := Length(Switch);

    for I := 1 to ParamCount do
    begin
      S := ParamStr(I);
      if (Chars = []) or (S[1] in Chars) then
        if IgnoreCase then
        begin
          if (AnsiCompareText(Copy(S, 2, aCount), Switch) = 0) then
          begin
            Result := True;
            aWholeSwitch := Copy(S, 2, MaxInt);
            Exit;
          end;
        end
        else begin
          if (AnsiCompareStr(Copy(S, 2, aCount), Switch) = 0) then
          begin
            Result := True;
            aWholeSwitch := Copy(S, 2, MaxInt);
            Exit;
          end;
        end;
    end;
    Result := False;
  end;

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

  aSwitch: string;
  aPID: Integer;
Begin
  //-NewVersion=<PID>
  ClientList := TList.Create;
  if FindCmdLineSwitchEx('NewVersion=', ['-','/'], True, True, aSwitch) then
  begin
    aPID := StrToIntDef( Copy(aSwitch, Length('NewVersion=') + 1, MaxInt), 0 );
    Splash.InfoLabel.Caption := 'Перезапуск...';
    Splash.Update;
    KillProcess(aPID, 1000 * 10{подождем 10 сек});
  end;

  WriteBasesMode := FindCmdLineSwitch('$ADMINBASES$'); //sklad

  fActiveBases := TStringList.Create; //sklad
  fLogLock := TCriticalSection.Create;
  fDebugRun := FindCmdLineSwitch('DebugRun');

  RedrawTitleImageList;    

  bTerminate := TRUE;
  lResetIni := False;

  fUpdateQueue := TUpdateQueue.Create;

  iniFile := TIniFile.Create(AppStorage.IniFile.FileName);
  try
    CodeIgnoreSpecialSymbolsCheckBox.Checked := iniFile.ReadBool('Checked','CodeIgnoreSpecialSymbolsCheckBox',FALSE);
    IgnoreSpecialSymbolsCheckBox.Checked := iniFile.ReadBool('Checked','IgnoreSpecialSymbolsCheckBox',FALSE);

    IgnoreSpecialSymbolsCheckBox.Checked := TRUE;
    IgnoreSpecialSymbolsCheckBox.Visible := FALSE;
    //флаг что нужно выровнять тулбары - только если они еще не сохранены
    fNeedAllignToolBars := not iniFile.SectionExists(MainDockPanel.Persistence.Section);
    aNewBarFound := not iniFile.ValueExists(MainDockPanel.Persistence.Section, 'UserID_ToolBar.Row');
    aNewTireBarFound := not iniFile.ValueExists(MainDockPanel.Persistence.Section, 'TireToolBar.Row');
  finally
    iniFile.Free;
  end;

  MainDockPanel.Persistence.Key := AppStorage.IniFile.FileName;
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

  FiltModified := False;
  AdminPasswEntered := False;
  Wait_Flash_flag := False;
  TestForAdminMode;
  StartFlag := False;
  Application.HelpFile := ChangeFileExt(Application.ExeName, '.hlp');
  EditFormMode         := efmDos; // переход между полями по Enter
  SetDateFormat;                  // dd.mm.yyyy, русские имена месяцев


  //sklad>>
  DocLimitStartAdvDate.Date:= Now;
  DocLimitEndAdvDate.Date:= Now;

  SaleOrderStart.Date:= Now;
  SaleOrderEnd.Date:= Now;

  DocReturnStartAdvDate.Date:= Now;
  DocReturnEndAdvDate.Date:= Now;

  //DocReturnPostStartAdvDate.Date := Now;
  //DocReturnPostEndAdvDate.Date := Now;
  //<<sklad
  DateStartReturnDoc.Date:= Now;
  DateEndReturnDoc.Date:= Now;

  fQuantsInfo := TAllQuantsForm.CreateEmbedded(pnAllQuantsHost);
  fQuantsInfo.Color := pnAllQuantsHost.Color;
  fQuantsInfo.Clear(False);
  fQuantsInfoAn := TAllQuantsForm.CreateEmbedded(pnAllQuantsHostAn);
  fQuantsInfoAn.Color := pnAllQuantsHostAn.Color;
  fQuantsInfoAn.Clear(False);


  //старт БД
  Data := TData.Create(Application);
  BasesChanged; //перестройка столбцов грида
  WSysLog('Загрузка дерева');
  Data.LoadTree;


  GetMirrorsList;
  OrderDateEd1.Date := Now-Data.ParamTable.FieldByName('SetDateRate').AsInteger;
  OrderDateEd2.Date := Now;
  LoadUserID;
  Data.sAuto:='';

  if Assigned(Splash) then
    Splash.SplashOff;

  WSysLog('Восстановление настроек пользователя');

  MainGrid.RestoreGridLayoutIni(AppStorage.IniFile.FileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  AnalogGrid.RestoreGridLayoutIni(AppStorage.IniFile.FileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  OrderGrid.RestoreGridLayoutIni(AppStorage.IniFile.FileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  OrderDetGrid.RestoreGridLayoutIni(AppStorage.IniFile.FileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  PrimGrid.RestoreGridLayoutIni(AppStorage.IniFile.FileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  ParamGrid.RestoreGridLayoutIni(AppStorage.IniFile.FileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  ReturnDocGrid.RestoreGridLayoutIni(AppStorage.IniFile.FileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);
  ReturnDocDetGrid.RestoreGridLayoutIni(AppStorage.IniFile.FileName, Name,
           [grpColIndexEh, grpColWidthsEh, grpColVisibleEh, grpRowHeightEh]);

  SyncParGrid(ParamGrid);
  FormStorage.RestoreFormPlacement;
  SetStyle;
  SearchMode := False;
  if AdminMode then
  begin
    Caption := Caption + '     Режим администратора';
    if not Data.Tecdoc_enabled then
      Caption := Caption + '     Tecdoc недоступен';
  end;

  {$IFDEF TEST}
  Caption := Caption + '     Внимание! тестовая версия';
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

  AutoAction.Visible     := not Data.PictTable.IsEmpty;
  {$IFDEF SKLAD}
  AutoAction.Visible := False;
  {$ENDIF}

  //wareHouse{
 // AutoAction.Visible  := FALSE;
 // AutoAction.Enabled  := FALSE;
 // FiltToolBar.Visible  := FALSE;
 // FiltToolBar.Enabled  := FALSE;
  //}
  
  if not AutoAction.Visible then
    AutoToolBar.Visible       := False
  else
  begin
    AutoToolBarButton.Visible := AutoAction.Visible;
    AutoToolBar.AutoSize := False;
    AutoToolBar.AutoSize := True;
  end;

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
end;


procedure TMain.FormDestroy(Sender: TObject);
var
  iniFile: TIniFile;
  i: Integer;
  UserID: TUserIDRecord;
begin
  fActiveBases.Free;
  fNotePadForm.Free;
  if Assigned(ChangesInBase) then
    ChangesInBase.Free;

  fUpdateQueue.Free;
  if Assigned(fUpdateMirrors) then
    fUpdateMirrors.Free;

  //распускаем записи об идентификаторах клиентов  
  while i < ClientList.Count do
  begin
     UserID := ClientList[i];
     UserID.Free;
     inc(i);
  end;
  ClientList.Free;
  
  FormStorage.SaveFormPlacement;
  MainGrid.SaveGridLayoutIni(AppStorage.IniFile.FileName, Name, False);
  AnalogGrid.SaveGridLayoutIni(AppStorage.IniFile.FileName, Name, False);
  OrderGrid.SaveGridLayoutIni(AppStorage.IniFile.FileName, Name, False);
  OrderDetGrid.SaveGridLayoutIni(AppStorage.IniFile.FileName, Name, False);
  PrimGrid.SaveGridLayoutIni(AppStorage.IniFile.FileName, Name, False);
  ParamGrid.SaveGridLayoutIni(AppStorage.IniFile.FileName, Name, False);
  MainDockPanel.SaveToolBarsPosition;

  iniFile := TIniFile.Create(AppStorage.IniFile.FileName);
  try
    iniFile.WriteBool('Checked','CodeIgnoreSpecialSymbolsCheckBox',CodeIgnoreSpecialSymbolsCheckBox.Checked);
    iniFile.WriteBool('Checked','IgnoreSpecialSymbolsCheckBox',IgnoreSpecialSymbolsCheckBox.Checked);
  finally
    iniFile.Free;
  end;

  if lResetIni then
    DeleteFile(AppStorage.IniFile.FileName);

  fScheduler.Free;
  fNotifyLog.Free;

  fLogLock.Free;
end;


procedure TMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (ssAlt in Shift) and (ssShift in Shift) then
    if Key in [Ord('h'), Ord('H')] then
    begin
      RunTVSupport;
    end;
end;

procedure TMain.FormShow(Sender: TObject);
var
  aNewsFile: string;
begin
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

    if aNewsFile <> '' then
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
  (not Data.ParamTable.FieldByName('Hide_NewInProg').AsBoolean) then
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
  ZakTabInfo;
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
  i, saveRecNo: Integer;
  anAfterScrollEvent: TDatasetNotifyEvent;
  filter: TStringList;
  timer1 : TTimer;
  beg,endd :cardinal;
  query: TDBISAMQuery;
  mas: array of Integer;
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
  beg := GetTickCount;

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

    {***}
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
    {***}

    if Data.ParamTable.FieldByName('AnalogFilterEnabled').AsBoolean then
      Data.memAnalog.Filter := ' QuantityCalc > 0 '
    else
      Data.memAnalog.Filter := '';
    Data.memAnalog.Filtered := Data.ParamTable.FieldByName('AnalogFilterEnabled').AsBoolean;

    UpdateAllQuantsInfo(False, True); 
  finally
    Data.memAnalog.AfterScroll := anAfterScrollEvent;
    Data.memAnalog.EnableControls;
  end;
end;

procedure TMain.LoadTDInfoTimerTimer(Sender: TObject);
var
{  s, sOE, aFilterOE: string;
  p, l, i, saveRecNo, aNum, aSelStart, aLen: Integer;
  AFont: TFont;

  isFilterSet: Boolean;
  aHighLight: set of Byte;}

  s, sOE, aFilterOE: string;
  p, l, i, saveRecNo, aSelStart, aLen, aNum: integer;
  AFont: TFont;
  isFilterSet: Boolean;
  aHighLight: set of Byte;
  HighLight: TSTringList;
begin
LoadTDInfoTimer.Enabled := False;
  Main.KitGridEh.SumList.Active := True;
  Data.CatalogDataSource.DataSet.AfterScroll := Data.CatalogTableAfterScroll;
  Main.KitGridEh.SumList.RecalcAll;

  try
    HighLight := TStringList.Create;
    Data.DescriptionTable.MasterFields := 'Cat_id';
    Data.DescriptionTable.MasterSource  := Data.CatalogDataSource;
    AnalogGrid.DataSource := Data.memAnalogDataSource; {new}
    PrimGrid.DataSource := Data.PrimenDataSource;
    ParamGrid.DataSource := Data.CatDetDataSource;

    isFilterSet := ((FiltModeComboBox.ItemIndex = 2) or (FiltModeComboBox.ItemIndex = 4)) and (FiltEd.Text <> '');
    aFilterOE := AnsiUpperCase(FiltEd.Text);
    aHighLight := []; //индексы номеров для подсветки

    OEInfo.Clear;
    Data.OEDescrTable.First;
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
        if POS(AnsiUpperCase(aFilterOE), AnsiUpperCase(Data.OEDescrTable.FieldByName('ShortOE').AsString)) > 0 then
        begin
          HighLight.Append(Data.OEDescrTable.FieldByName('ShortOE').AsString);
          Include(aHighLight, aNum);
        end;

        Inc(aNum);

        Data.OEDescrTable.Next;
        if not Data.OEDescrTable.Eof then
          s := s + ', ';
      end;
      Data.OEIDTable.Next;
    end;

    OEInfo.Text := AnsiUpperCase(s);
    OEInfo.ShowHint := s <> '';

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
 { LoadTDInfoTimer.Enabled := False;

  Main.KitGridEh.SumList.Active := True;
  Data.CatalogDataSource.DataSet.AfterScroll := Data.CatalogTableAfterScroll;
  Main.KitGridEh.SumList.RecalcAll;

  try
    Data.DescriptionTable.MasterFields := 'Cat_id';
    Data.DescriptionTable.MasterSource  := Data.CatalogDataSource;
    AnalogGrid.DataSource := Data.memAnalogDataSource;
    PrimGrid.DataSource := Data.PrimenDataSource;
    ParamGrid.DataSource := Data.CatDetDataSource;

    isFilterSet := (FiltModeComboBox.ItemIndex = 2) and (FiltEd.Text <> '');
    aFilterOE := AnsiUpperCase(FiltEd.Text);
    aHighLight := []; //индексы номеров для подсветки

    OEInfo.Clear;
    Data.OETable.First;
    s := '';
    aNum := 0;
    while not Data.OETable.Eof do
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
    end;
    OEInfo.Text := AnsiUpperCase(s);
    OEInfo.ShowHint := s <> '';

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
   // pnDetailsLoad.Visible := False;
  end;}
end;

//создает меню отображения тулбаров (Вид->Панели инструментов->...)
procedure TMain.LoadWaitListExecute(Sender: TObject);
var sFileName, sFilter:string;
    ftFile:TextFile;
    sData, sClientId:string;
    CurDate:TDate;
    rNo:integer;
    s:string;
    cat_code:string;//  := Data.MakeSearchCode(Copy(cb, 1,  p - 1));
    cb,cat_brand:string;// := Copy(cb, p + 1, 100);
    p:integer;
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
      if (not Data.fTecdocOldest) and (Data.CatalogDataSource.DataSet.FieldByName('Pict_id').AsInteger > 0) then
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
  pos: integer;
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
        ShowModal;
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
      if (ShowModal <> mrOk) and (not Data.OrderTable.Eof) then
        Data.OrderTable.Delete;
        Main.CatZakPage.Caption := 'Заказы поставщику';
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
    if Data.OrderTable.FieldByName('Sent').AsString <> '' then
    if (Data.OrderTable.FieldByName('Sent').AsString <> '0')and(Data.OrderTable.FieldByName('Sent').AsString <> '3') then
    begin
      MessageDlg('Невозможно удалить позицию из выбранного заказа!!!'+
                   ' Заказ уже был отправлен в офис компании и вероятно уже обработан.'+
                       ' Для проверки зарезервированного товара нажмите кнопку "TCP ответ".',  mtInformation, [mbOK], 0);
       exit;
    end;
    iID := -1;
    if Data.masChek.Count <> 0 then
    begin
      if (Data.OrderDetTable.FieldByName('Id').AsInteger <> 0) and
         (MessageDlg('Удалить выбранные позиции (' + IntToStr(Data.masChek.Count) + ' шт.)?',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
        for i := 0 to Data.masChek.Count - 1 do
        begin
          data.OrderDetTable.Locate('ID', Integer(data.masChek.Items[i]), []);
          Data.OrderDetTable.Delete;
          pos :=  Data.OrderDetTable.RecNo;
          
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

        Data.OrderDetTable.Delete;
        pos :=  Data.OrderDetTable.RecNo;
        
        with Data.OrderTable do
        begin
          Edit;
          FieldByName('Dirty').Value := True;
          Post;
          Refresh;
        end;
        Data.OrderDetTable.RecNo := pos -1 ;
      end;
    end;

    ZakTabInfo;
    Data.OrderDetTable.Locate('ID', iID, []);
    Data.CatalogDataSource.DataSet.Refresh;
    Data.OrderDetTable.RecNo := pos;
  end
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
    finally
      Free;
    end;
    //sklad >>
    FreeAndNil(fBasicTextFont); //переассайнится при прорисовке грида
    if QuantsLargeMode <> Data.ParamTable.FieldByName('bQuantsInGrid').AsBoolean then
    begin
      Data.SetQuantsLargeMode(Data.ParamTable.FieldByName('bQuantsInGrid').AsBoolean);
      BasesChanged;
    end;
    //<< sklad  
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
    ShowStatusBarInfo;
  end
  else if Sender = RecalcOrderAction then
    Data.RecalcOrder
  else if Sender = EmailOrderAction then
    EmailOrder
  else if Sender = SaveOrderAction then
    SaveOrder_Old
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
    if FileExists(GetAppDir + 'RssNews.html') or FileExists(GetAppDir + 'News.html') then
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
    if LoadOrderTCP1 then //LoadOrderTCP1_emul
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
//#new----------------------  
  else if Sender = NewSaleOrder then
  begin
     with TSaleOrderInfo.Create(nil) do
     begin
       Caption := 'Продажи';
       SetNew(TRUE);
       ShowModal;
     end;
  end
  else if Sender = EditSaleOrder then
  begin
     if Data.TableSaleOrder.FieldByName('SaleOrderID').AsInteger < 1 then
       Exit;

     if not CheckDocumentEnabled(EditSaleOrder) then
       Exit;

     with TSaleOrderInfo.Create(nil) do
     begin
       Caption := 'Продажи';
       DateTimePicker.Date := Data.TableSaleOrder.FieldByName('Date').AsDateTime;
       EdComment.Text := Data.TableSaleOrder.FieldByName('Comment').AsString;
       SetNew(FALSE);
       ShowModal;
     end;
  end
  else if Sender = DelSaleOrder then
  begin
      with Data.TableSaleOrder do
      begin
          if FieldByName('SaleOrderID').AsInteger < 1 then
            exit;
      end;

      if not CheckDocumentEnabled(DelSaleOrder) then
        Exit;

      if (Data.ParamTable.FieldByName('ToForbidSalelOrder').AsBoolean)and(Data.TableSaleOrderDet.RecordCount > 0) then
     begin
      MessageDlg('Невозможно удалить не пустой список!',mtInformation,[mbOk],0);
      exit;
     end;


      if MessageDlg('Удалить весь список продаж?',mtInformation,[mbYes,mbNo],0) =  mrNo then
            exit;

      with Data.TableSaleOrderDet do
      begin
          First;
          while not Eof do
          begin
             if Data.TableSaleOrder.FieldByName('SaleOrderID').AsInteger = Data.TableSaleOrderDet.FieldByName('SaleOrderID').AsInteger then
                Delete
             else
                Next;
          end;
      end;

      with Data.TableSaleOrder do
      begin
          Delete;
      end;

      Data.CatalogDataSource.DataSet.Refresh;
  end
  else if Sender = NewSaleReturnDoc then
  begin
     with TReturnDocInfo.Create(nil) do
     begin
       Caption := 'Продажи';
       DateTimePicker.Date := Now;
       SetNew(TRUE);
       ShowModal;
     end;
     Data.TableReturnDoc.Refresh;
  end
  else if Sender = EditSaleReturnDoc then
  begin
     if Data.TableReturnDoc.FieldByName('ReturnDocId').AsInteger < 1 then
      exit;

      if not CheckDocumentEnabled(EditSaleReturnDoc) then
        Exit;

     with TReturnDocInfo.Create(nil) do
     begin
       Caption := 'Продажи';
       DateTimePicker.Date := Data.TableSaleOrder.FieldByName('Date').AsDateTime;
       EdComment.Text := Data.TableSaleOrder.FieldByName('Comment').AsString;
       SetNew(FALSE);
       ShowModal;
     end;
        Data.TableReturnDoc.Refresh;
  end
  else if Sender = DelSaleReturnDoc then
  begin
    if not CheckDocumentEnabled(DelSaleReturnDoc) then
      Exit;

     if Data.TableReturnDoc.FieldByName('ReturnDocId').AsInteger < 1 then
      exit;
     if (Data.ParamTable.FieldByName('ToForbidReturnOrder').AsBoolean)and(Data.TableReturnDocDet.RecordCount > 0) then
     begin
      MessageDlg('Невозможно удалить не пустой список!',mtInformation,[mbOk],0);
      exit;
     end;

     if MessageDlg('Удалить весь список возвратов?',mtInformation,[mbYes,mbNo],0) =  mrNo then
            exit;
      with Data.TableReturnDocDet do
      begin
          First;
          while not Eof do
          begin
             if Data.TableReturnDoc.FieldByName('ReturnDocId').AsInteger = Data.TableReturnDocDet.FieldByName('ReturnDocId').AsInteger then
                Delete
             else
                Next;
          end;
      end;

      with Data.TableReturnDoc do
      begin
          Delete;
      end;
         Data.TableReturnDoc.Refresh;
  end
  else if Sender = DocLimitAddAction then
  begin
      with Data.TableDocLimit do
      begin
         Append;
         FieldByName('Date').Value   := now;
         FieldByName('State').Value := 0;
         Post;
      end;
  end
  else if Sender = DocLimitDelAction then
  begin
      with Data.TableDocLimit do
      begin
          if FieldByName('DocLimitID').AsInteger < 1 then
            exit;
      end;

     if not CheckDocumentEnabled(DocLimitDelAction) then
       Exit;

     if (Data.ParamTable.FieldByName('ToForbidLimit').AsBoolean)and(Data.TableDocLimitDet.RecordCount > 0) then
     begin
      MessageDlg('Невозможно удалить не пустой список!',mtInformation,[mbOk],0);
      exit;
     end;
     

      if MessageDlg('Удалить весь список лимитов?',mtInformation,[mbYes,mbNo],0) =  mrNo then
            exit;
      with Data.TableDocLimitDet do
      begin
          First;
          while not Data.TableDocLimitDet.Eof do
          begin
             if Data.TableDocLimit.FieldByName('DocLimitID').AsInteger = Data.TableDocLimitDet.FieldByName('DocLimitID').AsInteger then
                Delete
             else
                Next;
          end;
      end;

      with Data.TableDocLimit do
      begin
          Delete;
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
  //sklad>>
  if Pager.ActivePage = CatZakPage then
  begin
    AddToOrderAction.Execute;
    ClearSearchMode;
    Exit;
  end;

  if Pager.ActivePage = ReturnDocPage then
  begin
     AddReturnPosAction.Execute;
     ClearSearchMode;
     exit;
  end;


  if Pager.ActivePage = WaitListPage then
  begin
    MainActionExecute(AddToOrderAction);
    ClearSearchMode;
  end;

  if Pager.ActivePage = DocLimitPage then
  begin
    AddToDocLimitAction.Execute;
    ClearSearchMode;
    Exit;
  end;

  if Pager.ActivePage = ReturnDocCliPage then
  begin
    AddToSaleReturnDoc.Execute;
    ClearSearchMode;
    Exit;
  end;

  if Pager.ActivePage = CatZakCliPage then
  begin
    AddToSaleOrder.Execute;
    ClearSearchMode;
    Exit;
  end;

  //else as default create new sale
  //if Pager.ActivePage = ReturnDocCliPage then
  begin
    AddToSaleOrder.Execute;
    ClearSearchMode;
    Exit;
  end;
  //sklad<<
end;


procedure TMain.MainGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
begin
  if SameText(Column.FieldName, 'Quantity') then
  begin
    if MainGrid.DataSource.DataSet.FieldByName('OrderOnly').AsBoolean then
    begin
      DrawOrderOnlyField(MainGrid, Rect, State);
    end
    else
      if MainGrid.DataSource.DataSet.FieldByName('QuantLatest').AsInteger = 1 then
      begin
        NewImageList.Draw(MainGrid.Canvas, Rect.Right - NewImageList.Width, Rect.Top, 1);
      end;
  end;

  if SameText(Column.FieldName, 'Basic') then
  begin
    MainGrid.Canvas.Pen.Color := Data.ParamTable.FieldByName('BasicColor').AsInteger;
    MainGrid.Canvas.MoveTo(Rect.Left - 1, Rect.Top);
    MainGrid.Canvas.LineTo(Rect.Left - 1, Rect.Bottom + 1);

    MainGrid.Canvas.MoveTo(Rect.Right, Rect.Top);
    MainGrid.Canvas.LineTo(Rect.Right, Rect.Bottom + 1);
  end;
end;

procedure TMain.DrawOrderOnlyField(aGrid: TDBGridEh; aRect: TRect; State: TGridDrawState);
begin
//  aGrid.Canvas.Brush.Color := clWhite;
  aGrid.Canvas.Font.Color := clRed;
  aGrid.Canvas.Font.Style := [];
  InflateRect(aRect, -1, -1);
  aGrid.Canvas.TextRect(aRect, aRect.Left + 2, aRect.Top, 'Под заказ');
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
        if Column.FieldName = 'BrandDescr' then
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
    //sklad >>
    else if SameText(Column.FieldName, 'Basic') then
    begin
      //Background := Data.ParamTable.FieldByName('BasicColor').AsInteger;
      if not Assigned(fBasicTextFont) then
        fBasicTextFont := StrToFont(Data.ParamTable.FieldByName('BasicTextFont').AsString);
      AFont.Assign(fBasicTextFont);

      if Data.ParamTable.FieldByName('bApplyColorQuantsBase').AsBoolean then
      begin
        if FieldByName(sNameGlobalQuants).AsString = '' then
        begin
          AFont.Assign(NoQuantFont);
          Background := NoQuantBackgr;
        end
        else
        begin
          for i := 0 to Length(TextAttrList) - 1 do
          begin
            if (StrInt(FieldByName(sNameGlobalQuants).AsString) >= TextAttrList[i].Lo) and
               (StrInt(FieldByName(sNameGlobalQuants).AsString) <= TextAttrList[i].Hi) then
            begin
              AFont.Assign(TextAttrList[i].Font);
              Background := TextAttrList[i].Background;
              Break;
            end;
          end;
        end;
      end;
    end
    //<< sklad
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
    end
  end;
end;

procedure TMain.ClearSearchMode;
begin
  SearchEd.Clear;
  SearchEd.Color := clWindow;
  SearchMode := False;
end;


procedure TMain.CreateFilePriceExecute(Sender: TObject);
var
  rn: Integer;
  F: TextFile;
  sFile, sNumber: string;
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
      MainGridDblClick(MainGrid);
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
      MainGridDblClick(MainGrid);
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
begin
  if SameText(Anchor, 'BRAND_INFO') then
    AboutBrand.Click;
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
  end;{
  else
    if Button = mbRight then
    begin
      GetCursorPos(p);
      pmOEFilters.Popup(p.X, p.Y);
    end; }
end;

procedure TMain.OpenActionExecute(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://shate-m.by/ru/client/opt/151/'), nil, nil, SW_SHOW);
{
  if FileExists(GetAppDir + 'Actions.html') then
      with TInfo.Create(Application) do
         begin
            Caption := 'Акции';
            Browser.Navigate(GetAppDir + 'Actions.html');
            HideCheckBox.Visible := FALSE;
            ShowModal;
            Free;
          end;
}
end;

procedure TMain.OpenDiscExecute(Sender: TObject);
var
  UserData: TUserIDRecord;
  aIndex: Integer;
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
      {aIndex := UserIds_Combo.ItemIndex;                        
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
//
  ZeroMemory(@si, SizeOf(si));
  ZeroMemory(@pi, SizeOf(pi));

  if not CreateProcess( nil,PChar('hh.exe ' + GetAppDir + 'help.chm'), nil, nil, FALSE, 0, nil, nil, si, pi) then
   begin
       MessageDlg(PChar(SysErrorMessage(GetLastError)), mtInformation, [mbOK],0);
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
    aCell :=OrderDetGrid.MouseCoord(X, Y);
    if (aCell.X >= 0) and (aCell.Y > 0) then
      OrderDetGrid.BeginDrag(False, 10);
  end
end;

procedure TMain.OrderDetGridStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  Cursor := crDrag;
end;

procedure TMain.ClearSelection;
begin
 OrderDetGrid.Columns.Items[0].Title.ImageIndex := 2;
 Data.masChek.Clear;
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
  if SameText(Column.FieldName, 'Sent') and (Data.OrderTable.FieldByName('Sent').AsString = '4') then
    ApplyOrderAnswer;
end;

procedure TMain.OrderGridDblClick(Sender: TObject);
begin
  MainActionExecute(EditOrderAction)
end;


procedure TMain.OrderGridDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  gc: TGridCoord;
  rn1, rn2, i, r: integer;
  new_ord_id: integer;
  new_ord_info: string;
  old_ord_info: string;
  pos_info: string;
  kol: real;
  code2, brand: string;
  price: Currency;
  fExit : boolean;
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
      if fExit then
        MessageDlg('1Невозможно выполнить действие!!!'+
                 ' Заказ уже был отправлен в офис компании и вероятно уже обработан.',  mtInformation, [mbOK], 0);
      Data.OrderTable.RecNo := rn1;
      Data.OrderDetTable.RecNo := rn2;
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
      ClearSelection;
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


procedure TMain.miGroupsActionMeasureItem(Sender: TObject; ACanvas: TCanvas; var Width,
  Height: Integer);
begin
  Width := tbTree.Width;
end;

procedure TMain.N46Click(Sender: TObject);
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

procedure TMain.N9Click(Sender: TObject);
begin
  Data.GoToSelectItem;
end;


procedure TMain.NewAboutProgrammExecute(Sender: TObject);
begin
 if FileExists(GetAppDir + 'About.html') then
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

function TMain.NewReturnDoc: Boolean;
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
    LastNum := StrToIntDef( Data.ExecuteSimpleSelect('SELECT Max(Num) FROM [036] WHERE CLI_ID = :CLI_ID AND DATA = :DATA', [UserData.sId, Date]), 0 ) ;
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
  oldInd: string;
  UserData: TUserIDRecord;
  iOrder: Integer;
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
    LastNum := StrToIntDef( Data.ExecuteSimpleSelect('SELECT Max(Num) FROM [009] WHERE CLI_ID = :CLI_ID AND DATE = :DATE', [UserData.sId, Date]), 0 ) ;

    Append;
    FieldByName('Date').Value := Date;
    FieldByName('Num').Value := LastNum + 1;
    FieldByName('Sent').Value := 0;
    FieldByName('Currency').Value := 2;    
    FieldByName('Cli_id').Value := UserData.sId;
    FieldByName('Type').Value   := UserData.sOrderType;
    FieldByName('Delivery').Value := UserData.iDelivery;
    if (Trim(FieldByName('Type').AsString) <> 'A')and(Trim(FieldByName('Type').AsString) <> 'B') then
      FieldByName('Type').Value := 'A';
    FieldByName('State').Value := 0;
    Post;
  end;
  ZakTabInfo;
  SetActionEnabled;
  Result := TRUE;
end;

procedure TMain.NewReturnDocActionExecute(Sender: TObject);
begin
  // новый возврат
 if not NewReturnDoc then
        exit;
  with TReturnDocED.Create(nil) do
  begin
    if ShowModal <> mrOk then
      if not Data.ReturnDocTable.EOF then
        Data.ReturnDocTable.Delete;
  end;
  Data.ReturnDocTable.Refresh;
  CountingOrderSum;
end;

procedure TMain.ZakTabInfo;
var
  aSumField: string;
begin
  if not Assigned(Data) then
    Exit;
    
  with Data.OrderTable do
  begin
    if acShowOrdersInPofitPrices.Checked then
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
         Main.CatZakPage.Caption := 'Заказы поставщику';
      SetActionEnabled;

     // if FieldByName('Order_id') then

    pnDelivery.Visible := FieldByName('IsDeliveredCalc').AsBoolean;
    lbDeliveryNum.Caption := 'Телефон отдела доставки: ' + Data.SysParamTable.FieldByName('DeliveryPhone').AsString;
    lbOrderNum.Caption := ' №' + FieldByName('LotusNumber').AsString;
  end;
  if not Data.fOrderTableInAfterScroll then
  CountingOrderSum;
end;




procedure TMain.AnalogGridDblClick(Sender: TObject);
begin
  AddAnToSaleOrder.Execute;
end;


procedure TMain.AnalogGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
begin
  if SameText(Column.FieldName, 'Quantity') then
  begin
    if AnalogGrid.DataSource.DataSet.FieldByName('OrderOnly').AsBoolean then
    begin
      DrawOrderOnlyField(AnalogGrid, Rect, State);
    end
    else
      if AnalogGrid.DataSource.DataSet.FieldByName('QuantLatest').AsInteger = 1 then
      begin
        NewImageList.Draw(AnalogGrid.Canvas, Rect.Right - NewImageList.Width, Rect.Top, 1);
      end;
  end;

  if SameText(Column.FieldName, 'Basic') then
  begin
    AnalogGrid.Canvas.Pen.Color := Data.ParamTable.FieldByName('BasicColor').AsInteger;
    AnalogGrid.Canvas.MoveTo(Rect.Left - 1, Rect.Top);
    AnalogGrid.Canvas.LineTo(Rect.Left - 1, Rect.Bottom + 1);

    AnalogGrid.Canvas.MoveTo(Rect.Right, Rect.Top);
    AnalogGrid.Canvas.LineTo(Rect.Right, Rect.Bottom + 1);
  end;
end;

procedure TMain.AnalogGridEnter(Sender: TObject);
begin
  Data.AnalogTableAfterScroll(Data.AnalogTable);
  Data.AnalogTable.AfterScroll := Data.AnalogTableAfterScroll;
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
    //sklad >>
    if SameText(Column.FieldName, 'Basic') then
    begin
      //Background := Data.ParamTable.FieldByName('BasicColor').AsInteger;
      if not Assigned(fBasicTextFont) then
        fBasicTextFont := StrToFont(Data.ParamTable.FieldByName('BasicTextFont').AsString);
      AFont.Assign(fBasicTextFont);

      //Background := Data.ParamTable.FieldByName('BasicColor').AsInteger;
      if Data.ParamTable.FieldByName('bApplyColorQuantsBase').AsBoolean then
      begin
        if FieldByName(sNameGlobalQuants).AsString = '' then
        begin
          AFont.Assign(NoQuantFont);
          Background := NoQuantBackgr;
        end
        else
        begin
          for i := 0 to Length(TextAttrList) - 1 do
          begin
            if (StrInt(FieldByName(sNameGlobalQuants).AsString) >= TextAttrList[i].Lo) and
               (StrInt(FieldByName(sNameGlobalQuants).AsString) <= TextAttrList[i].Hi) then
            begin
              AFont.Assign(TextAttrList[i].Font);
              Background := TextAttrList[i].Background;
              Break;
            end;
          end;
        end;
      end;
    end
    //<< sklad
    else if FieldByName('SaleQ').AsString = '1' then
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
    fPopupRss.BringToFront;
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
 // MainMenu.BeginUpdate;
 // MainMenu.EndUpdate;

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
  lFound: boolean;
begin

 { FiltEd.Text := AnsiUpperCase(RemoveExtSymb(FiltEd.Text));
  if IgnoreSpecialSymbolsCheckBox.Checked then
  begin
    if FiltModeComboBox.ItemIndex = 0 then
      FiltEd.Text := Data.CreateShortCode(FiltEd.Text, ':' {live ":"}//)
{    else
      FiltEd.Text := Data.CreateShortCode(FiltEd.Text);
  end
  else
  if FiltModeComboBox.ItemIndex <> 0 then
    FiltEd.Text := Data.MakeSearchCode(FiltEd.Text);

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
      begin
          StopWait;
          MessageDlg('По Вашему запросу ничего не найдено, проверьте введенный номер.', mtInformation, [mbOK],0);
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
        StartWait;
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
              begin
                 StopWait;
                MessageDlg('По Вашему запросу ничего не найдено, проверьте введенный номер.', mtInformation, [mbOK],0);
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
          StopWait;
  end;


  if FiltModeComboBox.ItemIndex = 3 then
  begin
     StartWait;
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
              begin
                StopWait;
                MessageDlg('По Вашему запросу ничего не найдено, проверьте введенный номер.', mtInformation, [mbOK],0);
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
     Data.TestQuery.Close;
     Data.TestQuery.SQL.Clear;
     if IgnoreSpecialSymbolsCheckBox.Checked then
        Data.TestQuery.SQL.Add('SELECT DISTINCT [002].Cat_id FROM [002] WHERE ' + BuildMultiLikeCondition(s, 'ShortCode'))
     else
        Data.TestQuery.SQL.Add('SELECT DISTINCT [002].Cat_id FROM [002] WHERE ' + BuildMultiLikeCondition(s, 'UPPER(Code2)'));
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
              begin
                StopWait;
                MessageDlg('По Вашему запросу ничего не найдено, проверьте введенный номер.', mtInformation, [mbOK],0);
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
          StopWait;
      end;

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
                    else
                       if s2<> '' then
                       begin
                        s := 'upper(Description) LIKE('+'''%''+'''+s2+'''+''%'')';
                       end;
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
                MessageDlg('По Вашему запросу ничего не найдено, проверьте введенные данные.', mtInformation, [mbOK],0);
                Data.TestQuery.Close;
                exit;
               //Data.sAuto := 'Cat_id = -1';
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
                MessageDlg('По Вашему запросу ничего не найдено, проверьте введенные данные.', mtInformation, [mbOK],0);
                Data.TestQuery.Close;
                exit;
               //Data.sAuto := 'Cat_id = -1';
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
                begin
                  Filtered := True;
                 end;
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
  FiltModified := False;   }
  FiltEd.Text := AnsiUpperCase(RemoveExtSymb(FiltEd.Text));

//  if FiltModeComboBox.ItemIndex = 0 then
//    FiltEd.Text := Data.CreateShortCode(FiltEd.Text, ':' {live ":"})
//  else
//    FiltEd.Text := Data.CreateShortCode(FiltEd.Text);

  if FiltModeComboBox.ItemIndex <> 0 then
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
    Data.TestQuery.Prepare;
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
    Data.TestQuery.Prepare;
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

    if sAllCatID <> '' then
      Data.sAuto:='Cat_id IN ( '+ sAllCatID + ')'
    else
    begin
      StopWait;
      if MessageDlg('По Вашему запросу ничего не найдено! Найти позицию в web-портале Шате-М Плюс?', mtInformation, [mbYes, mbNo],0) = mrYes then
        WebSearchOE(s);

      Data.TestQuery.Close;
      exit;
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
    Data.TestQuery.Prepare;
    Data.TestQuery.Params[0].Value := s;
    Data.TestQuery.Params[1].Value := s;
    Data.TestQuery.Params[2].Value := s;
    Data.TestQuery.Params[3].Value := s;
    Data.TestQuery.Params[4].Value := s;

    bAbort := FALSE;
    Data.TestQuery.Active:= TRUE;

    if not Data.TestQuery.Eof then
    begin
      gen_an_id := Data.TestQuery.FieldByName('gen_an_id').AsInteger;
      Data.TestQuery.SQL.Clear;
      Data.TestQuery.SQL.Text := ' Select cat_id  from [007_2] where gen_an_id = :Par1 ';
      Data.TestQuery.Prepare;
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
  if Assigned(fPopupRss) and (fPopupRss.Showing) then
    fPopupRss.BringToFront;

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
        Sleep(300);
        if Assigned(UpdateThrd) then //не ждем, убиваем принудительно
          TerminateThread(UpdateThrd.Handle, 0);

        CloseStatusColums;
      end;
    end
    else
      CanClose := False;
      end;
  finally
    fCanClose := CanClose;
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


procedure TMain.LoadUserID;
var
  UserID: TUserIDRecord;
  iPos, iPosDef: Integer;
  cl_id: integer;
begin
  iPos:=0;
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
  iPosDef := -1;
  with Data.ClIDsTable do
  begin
    DisableControls;
    try
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

        iPos := ClientList.add(UserID);

         if FieldByName('ByDefault').AsInteger = 1 then
        begin
          CliComboBox.OnChange := nil;
          CliComboBox.KeyValue := FieldByName('Client_ID').AsString;
          CliComboBox.OnChange := CliComboBoxChange;
        end;

        Next;
      end;

      //CliComboBoxChange(nil);
    finally
      EnableControls;
    end;
  end;

  SetActiveCli(GetCurrentUser);
end;


procedure TMain.MainParamSplashTimerTimer(Sender: TObject);
var sFilter:string;
begin
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
    fPopupRss.BringToFront;
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
    fPostOrder := True;
end;

function TMain.GetCurrentUser: TUserIDRecord;
var
  i:integer;
  s : string;
begin
 Result := nil;
 
 if CliComboBox.KeyValue = NULL then
   Exit;

 s := CliComboBox.KeyValue;
 for i:= 0 to ClientList.Count -1 do
 begin
   if TUserIDRecord(ClientList[i]).sId = s then
   begin
     result := ClientList[i];
     exit;
   end;
 end;
end;

function TMain.GetUpdateServersList(aServerList: TStrings): Boolean;

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
      aUrl := aUrl + 'getLink';
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
      Result := aServers.Count > 0;
    end;

    //http://shate-m.by/service/getLink
    //SERVERS
  end;

var
  aCurSrv: string;
  i: Integer;
begin
  if not GetUpdateServers(aServerList) then
  begin
    //приоритет по-умолчанию, если недоступен основной сервер
    for i := 0 to UpdateMirrors.Count - 1 do
      aServerList.Add(UpdateMirrors[i]);
  end;
end;

function TMain.GetUserDataByID(const aSearchID: string): TUserIDRecord;
var
  i:integer;
begin
 result := nil;
 for i:= 0 to ClientList.Count -1 do
 begin
   if TUserIDRecord(ClientList[i]).sId = aSearchID then
   begin
     result := ClientList[i];
     exit;
   end;
 end;
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
          DisableControls;
          i := Data.WaitListTable.FieldByName('id').AsInteger;
          //if IndexName <> 'DateCreate' then
          //  IndexName := 'DateCreate';

          sFilter := UserData.sId;
          //SetRange([sFilter], [sFilter]);
          Data.fWaitListTableClientFilter := sFilter;
          Filtered := True;
          Refresh;

          if not Data.WaitListTable.Locate('id', i, []) then
            Data.WaitListTable.Last;
          EnableControls;
        end;

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
    i := Data.WaitListTable.FieldByName('id').AsInteger;
    //if IndexName <> 'DateCreate' then
    //  IndexName := 'DateCreate';
    Data.fWaitListTableClientFilter := '';  
    Filtered := True;
    Refresh;
    if not Data.WaitListTable.Locate('id', i, []) then
      Data.WaitListTable.Last;
    EnableControls;
  end;

end;

procedure TMain.UserIds_ComboChange(Sender: TObject);
begin
  SelectCurrentUser;
  Data.SetPriceKoef;
  ShowStatusbarInfo;
  Data.CalcWaitList;
end;

procedure TMain.UserIds_ComboKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
{$IFDEF TEST}

  if (ssCtrl in Shift) and (ssAlt in Shift) and (ssShift in Shift)  then
    if Key = 76{l} then
      LoadClientsPass('')
    else
      if Key = 75{k} then
        LoadClientsPass(ExtractFilePath(ParamStr(0)) + 'AllClients.csv');
{$ENDIF}
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

  aModalResult := mrNone;
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
        if acShowOrdersInPofitPrices.Checked then
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
  brd, ttd: real;
begin
  StatusBar.Panels[0].Text := ' Курс EUR: <b>' + Data.ParamTable.FieldByName('Eur_rate').AsString + ' BYR</b>' +
                              ' / <b>' + Data.ParamTable.FieldByName('Eur_Usd_rate').AsString + ' USD</b>'+
                              ' / <b>' + Data.ParamTable.FieldByName('Eur_RUB_rate').AsString + ' RUB</b>';

  if Data.ParamTable.FieldByName('Hide_discountSB').AsBoolean then
    StatusBar.Panels[1].Text := ''
  else
  begin
    StatusBar.Panels[1].Text := ' Скидка: <b>' + FormatFloat('0.##', (1 - Data.GetDiscount(
      Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
      Data.CatalogDataSource.DataSet.FieldByName('Subgroup_id').AsInteger,
      Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger
    )) * 100) + ' %  /  ' +

    FormatFloat('0.##', (Data.GetMargin(
      Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
      Data.CatalogDataSource.DataSet.FieldByName('Subgroup_id').AsInteger,
      Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger
    ) - 1) * 100) + ' %</b>';

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

  StatusBar.Panels[2].Text := ' Цена с нац.: <b>' +
               Data.CatalogDataSource.DataSet.FieldByName('Price_pro').AsString + '</b>';
  StatusBar.Panels[4].Text := 'Email для заказов: <b>' +
               Data.SysParamTable.FieldByName('Shate_email').AsString + '</b>     ' +
               IntToStr(rest_days) + ' дн. до окончания действия программы'
end;


procedure TMain.ShowStatusBarInfo2;
var
  brd, ttd: real;
begin
  if Data.ParamTable.FieldByName('Hide_discountSB').AsBoolean then
    StatusBar.Panels[1].Text := ''
  else
  begin
    StatusBar.Panels[1].Text := ' Скидка: <b>' + FormatFloat('0.##', (1 - Data.GetDiscount(
      Data.memAnalog.FieldByName('An_Group_id').AsInteger,
      Data.memAnalog.FieldByName('An_Subgroup_id').AsInteger,
      Data.memAnalog.FieldByName('An_Brand_id').AsInteger
    )) * 100) + ' %  /  ' +

    FormatFloat('0.##', (Data.GetMargin(
      Data.memAnalog.FieldByName('An_Group_id').AsInteger,
      Data.memAnalog.FieldByName('An_Subgroup_id').AsInteger,
      Data.memAnalog.FieldByName('An_Brand_id').AsInteger
    ) - 1) * 100) + ' %</b>';

{
    brd := XRound((1 - Data.GetDiscount(0,0,Data.memAnalog.FieldByName('An_Brand_id').AsInteger)) * 100, 2);
    ttd := XRound(Data.ParamTable.FieldByName('Discount').AsFloat, 2);
    if brd <> ttd then
      StatusBar.Panels[1].Text := ' Скидка: <b>' + FloatToStr(ttd) + ' %  /  ' +
                          FloatToStr(brd) + ' %</b>'
    else
      StatusBar.Panels[1].Text := ' Скидка: <b>' + FloatToStr(ttd) + ' %</b>';
}      
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
var
  email: string;
  iFilePos, iPosFile: Integer;
  sign, s, sHesh: string;
  sValue: string;
  UserData: TUserIDRecord;
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

  with TCPClient do
  try
    try
      Host := Data.SysParamTable.FieldByName('Host').AsString;
      Port := Data.SysParamTable.FieldByName('Port').AsInteger;
      Connect;
      except
        try
          Host := Data.SysParamTable.FieldByName('BackHost').AsString;
          Port := Data.SysParamTable.FieldByName('Port').AsInteger;
          Connect;
        except
          Host := Data.SysParamTable.FieldByName('TCPHost3').AsString;
          Port := Data.SysParamTable.FieldByName('Port').AsInteger;
          Connect;
        end;
      end;

    email := anEMail;
    fname := aFileName;

    subj := 'ClientID: ' + Data.OrderTable.FieldByName('Cli_id').AsString +
            ' OredrID: ' +  Data.OrderTable.FieldByName('Order_id').AsString +
            ' Date/Num: ' + Data.OrderTable.FieldByName('Date').AsString + '/'+
            Data.OrderTable.FieldByName('Num').AsString + Data.OrderTable.FieldByName('Type').AsString + aInf;

    try
      IOHandler.Writeln(email);
      IOHandler.Writeln(subj);
      IOHandler.Writeln(ExtractFileName(fname));
      AssignFile(F, fname);
      Reset(F);
      while not System.Eof(F) do
      begin
        System.Readln(F, s);
        if length(s) > 0 then
          IOHandler.Writeln(s);
      end;
      CloseFile(F);

      SaveAssortmentExpansionProc(FALSE);

      fname := Data.Export_Path + Data.OrderTable.FieldByName('Cli_id').AsString + '_' + Data.OrderTable.FieldByName('Sign').AsString + '_0.csv';
      if FileExists(fname) then
      begin
        IOHandler.Writeln('WaitList');
        IOHandler.Writeln(ExtractFileName(fname));
        AssignFile(F,fname);
        Reset(F);
        while not System.Eof(F) do
        begin
          System.Readln(F, s);
          if length(s) > 0 then
            IOHandler.Writeln(s);
        end;
        CloseFile(F);
      end;

      IOHandler.Writeln('FINALYSEND');
      s := IOHandler.ReadLnWait;
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
      Disconnect;
    end;
    Result := True;
  except
    on e: EIdException do
      MessageDlg('Ошибка соединения: ' + e.Message, mtError, [mbOK], 0);
    on e: Exception do
      MessageDlg('Ошибка: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

//Отправка возврата
function TMain.SendReturnDoc: Boolean;
var
  subj, email, s, inf: string;
  fname: string;
  F:TextFile;
  UserData, UserDataOrder: TUserIDRecord;
begin
  if Data.ReturnDocTable.FieldByName('RetDoc_id').AsInteger = 0 then
    Exit;
    
  if not CheckClientID then
    Exit;
  UserData := GetCurrentUser;

  fname := 'RET_'+Data.ReturnDocTable.FieldByName('Cli_id').AsString + '_' +
        Data.ReturnDocTable.FieldByName('RetDoc_id').AsString + '_' +
        Data.ReturnDocTable.FieldByName('Data').AsString + '_' +
        Data.ReturnDocTable.FieldByName('Num').AsString +
        Data.ReturnDocTable.FieldByName('Type').AsString + '.csv';


  if not SaveReturnDoc(fname) then
    Exit;


  if Data.ReturnDocTable.FieldByName('Cli_id').AsString = '' then
  begin
    MessageDlg('Не указан идентификатор клиента в возврате!', mtError, [mbOK], 0);
    Exit;
  end;

  fname := Data.Export_Path + fname;

     if (Data.ReturnDocTable.FieldByName('Post').AsString = '2') then
        begin
          if MessageDlg('Документ уже отправлялся ' +
                 Data.ReturnDocTable.FieldByName('Sent_time').AsString +
                 '. Повторить?',
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
            Application.MessageBox(
              PChar(
                'Идентификатор клиента [' + Data.OrderTable.FieldByName('Cli_id').AsString + '] указанный в возврате не найден в базе!'#13#10 +
                'Отредактируйте возврат или создайте клиента с нужным идентификатором'
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
                     'Для идентификатора клиента указанного в возврате не задан E-Mail!'#13#10 +
                     'Отправить используя E-Mail текущего клиента?'
                   ),
                   'Подтверждение',
                   MB_YESNO or MB_ICONWARNING
                 ) = IDYES then
                email := Trim(UserData.sEMail) //мыло текущего пользователя
              else
                Exit;


            //email := Trim(UserData.sEMail);
            if email = '' then
            begin
              MessageDlg('Настройте E-Mail текушего клиента в параметрах программы!', mtError, [mbOK], 0);
              Exit;
            end;

            with TCPClient do
            try
                begin
                try
                Host := Data.SysParamTable.FieldByName('Host').AsString;
                Port := Data.SysParamTable.FieldByName('Port').AsInteger;
                Connect;
                  except
                    try
                      Host := Data.SysParamTable.FieldByName('BackHost').AsString;
                      Port := Data.SysParamTable.FieldByName('Port').AsInteger;
                      Connect;
                     except
                        Host := Data.SysParamTable.FieldByName('TCPHost3').AsString;
                        Port := Data.SysParamTable.FieldByName('Port').AsInteger;
                        Connect;
                     end;
                  end;
                end;

                try
                  IOHandler.Writeln(email);
                  IOHandler.Writeln(subj);
                  IOHandler.Writeln(ExtractFileName(fname));
                  AssignFile(F, fname);
                  Reset(F);
                  while not System.Eof(F) do
                    begin
                      System.Readln(F, s);
                      if length(s) >0 then
                        IOHandler.Writeln(s);
                    end;
                  CloseFile(F);
                  IOHandler.Writeln('FINALYSEND');
                  s := IOHandler.ReadLnWait;
                  if s = 'TRUE' then
                    begin
                      Data.ReturnDocTable.Edit;
                      Data.ReturnDocTable.FieldByName('Post').AsInteger := 2;
                      Data.ReturnDocTable.FieldByName('Sent_time').AsDateTime := Now;
                      Data.ReturnDocTable.Post;
                      MessageDlg(Data.SysParamTable.FieldByName('Ord_send_info').AsString, mtInformation, [mbOK], 0);
                    end
                  else
                    begin
                      MessageDlg('Документ не отправлен!', mtInformation, [mbOK], 0);
                    end;
              finally
                Disconnect;
              end;
          except
             on e: EIdException do
                MessageDlg('Ошибка соединения: ' + e.Message, mtError, [mbOK], 0);
             on e: Exception do
                MessageDlg('Ошибка: ' + e.Message, mtError, [mbOK], 0);
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
              end;
    end;
  end;
end;


function TMain.SendReturnDoc_Old: Boolean;
var
  sFileName, email: string;
  UserData, UserDataOrder: TUserIDRecord;
begin
  Result := False;

  if Data.ReturnDocTable.FieldByName('RetDoc_id').AsInteger = 0 then
    Exit;

  if Data.ReturnDocDetTable.RecordCount < 1 then
    Exit;


  if not CheckClientId then
    Exit;

  UserData := GetCurrentUser;

  sFileName := '';
  if not SaveReturnDoc_Old(sFileName, True {without save dialog, but generate file name}) then
    Exit;

  if Data.ParamTable.FieldByName('TCP_Direct').AsBoolean then
  begin
    UserDataOrder := GetUserDataByID(Data.ReturnDocTable.FieldByName('Cli_id').AsString);
    if not Assigned(UserDataOrder) then
    begin
      Application.MessageBox(
        PChar(
          'Идентификатор клиента [' + Data.ReturnDocTable.FieldByName('Cli_id').AsString + '] указанный в возврате не найден в базе!'#13#10 +
          'Отредактируйте возврат или создайте клиента с нужным идентификатором'
        ),
        'Ошибка',
        MB_OK or MB_ICONERROR
      );
      Exit;
    end;

    email := Trim(UserDataOrder.sEMail); //мыло пользователя возврата
    if email = '' then
      if UserDataOrder.sID <> UserData.sID then
        if Application.MessageBox(
             PChar(
               'Для идентификатора клиента указанного в возврате не задан E-Mail!'#13#10 +
               'Отправить используя E-Mail текущего клиента?'
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


    if SendEMailByTCP(
      Trim(email),
      Data.SysParamTable.FieldByName('EmailReturn').AsString,
      'Возврат от клиента ' + sNameGlobalClient + '(' + sNameGlobalBase + ')',
      'Возврат от клиента ' + sNameGlobalClient + '(' + sNameGlobalBase + ')',
      sFileName
    ) then
    begin
      MessageDlg('Отправлен возврат!', mtInformation, [mbOK], 0);
    end
    else
      Exit; {do not save post status 2}
  end //TCP_Direct
  else
  begin
    with Mailer do
    begin
      Clear;
      Recipient.AddRecipient(Data.SysParamTable.FieldByName('EmailReturn').AsString);
      Subject := 'Возврат от клиента ' + sNameGlobalClient;
      Attachment.Add(sFileName);
      try
        SendMail;
      except
        Exit;
      end;
    end;
  end;

  Data.ReturnDocTable.Edit;
  Data.ReturnDocTable.FieldByName('Post').AsInteger := 2;
  Data.ReturnDocTable.FieldByName('Sent_time').AsDateTime := Now;
  Data.ReturnDocTable.Post;

  Result := True;
end;

procedure TMain.SendReturnDocActionExecute(Sender: TObject);
begin
  SendReturnDoc_Old;
end;

procedure TMain.AddToDocLimitActionExecute(Sender: TObject);
begin
  if not CheckDocumentEnabled(DocLimitDelAction) then
    Exit;

  with TDocLimitWindow.Create(Application) do
  begin
    EdDescription.Text  :=  Data.CatalogDataSource.DataSet.FieldByName('Name_Descr').AsString;
    EdCode.Text := Data.CatalogDataSource.DataSet.FieldByName('Code').AsString;
    EdBrand.Text := Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString;
    if Data.CatalogDataSource.DataSet.FieldByName('Limit').AsString <> '' then
    begin
      EdOldValue.Text := Data.CatalogDataSource.DataSet.FieldByName('Limit').AsString;
      EdNewValue.Text := Data.CatalogDataSource.DataSet.FieldByName('Limit').AsString;
    end
    else
    begin
      EdOldValue.Text := '0';
      EdNewValue.Text := '0';
    end;
    EdNewValue.TabOrder := 0;
    GlobalID := -1;
    ShowModal;
  end;
end;

procedure TMain.AddToOrder(sRealValue: string = ''; aRequestQuants: Boolean = False);
var
  bNew: Boolean;
  UserData, UserDataOrder: TUserIDRecord;
  aSavedOrderID: Integer;
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
        DisableControls;
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
          EnableControls;
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
end;


procedure TMain.AddToSaleOrderExecute(Sender: TObject);
begin
  try
    Data.CatalogDataSource.DataSet.FieldByName(sNameGlobalQuants).AsInteger;
  except
    Exit;
  end;

  if not CheckDocumentEnabled(EditSaleOrder) then
    Exit;

  if Data.CatalogDataSource.DataSet.FieldByName(sNameGlobalQuants).AsInteger - Data.CatalogDataSource.DataSet.FieldByName('Reserve').AsInteger< 1 then
  begin
    if (Data.CatalogDataSource.DataSet.FieldByName(sNameGlobalQuants).AsInteger > 0) and (Data.CatalogDataSource.DataSet.FieldByName('Reserve').AsInteger > 0) then
      Application.MessageBox(
        PChar(Format('Нет в наличии (сейчас в резерве %d из %d)', [Data.CatalogDataSource.DataSet.FieldByName('Reserve').AsInteger, Data.CatalogDataSource.DataSet.FieldByName(sNameGlobalQuants).AsInteger])),
        'Внимание',
        MB_OK or MB_ICONWARNING
      );
    Exit;
  end;

  with TSaleOrderAdd.Create(nil) do
  try
    SetMaxValue(
      Data.CatalogDataSource.DataSet.FieldByName(sNameGlobalQuants).AsInteger - Data.CatalogDataSource.DataSet.FieldByName('Reserve').AsInteger,
      XRound(Data.Rate*Data.CatalogDataSource.DataSet.FieldByName('PriceItog').AsCurrency * (100 - Data.SysParamTable.FieldByName('MaxDiscount').AsInteger) / 100, 2)
    );
    SetParametrValue(
      Data.CatalogDataSource.DataSet.FieldByName('Code').AsString,
      Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString,
      Data.CatalogDataSource.DataSet.FieldByName('Name_Descr').AsString,
      Data.CatalogDataSource.DataSet.FieldByName('Price_koef').AsString,
      CheckNeedMult(Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger,
                    Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
                    Data.CatalogDataSource.DataSet.FieldByName('SubGroup_id').AsInteger,
                    Data.CatalogDataSource.DataSet.FieldByName('Mult').AsInteger),
      -1
    );
    ShowModal;
  finally
    Free;
  end;
  Data.TableSaleOrder.Refresh;
  Data.CatalogDataSource.DataSet.Refresh;
end;


procedure TMain.AddAnToSaleOrderExecute(Sender: TObject);
begin
  try
    Data.AnalogTable.FieldByName(sNameGlobalQuants).AsInteger;
  except
    Exit;
  end;

  if not CheckDocumentEnabled(EditSaleOrder) then
    Exit;

  if Data.MemAnalog.FieldByName(sNameGlobalQuants).AsInteger - Data.MemAnalog.FieldByName('Reserve').AsInteger < 1 then
  begin
    if (Data.MemAnalog.FieldByName(sNameGlobalQuants).AsInteger > 0) and (Data.MemAnalog.FieldByName('Reserve').AsInteger > 0) then
      Application.MessageBox(
        PChar(Format('Нет в наличии (сейчас в резерве %d из %d)', [Data.MemAnalog.FieldByName('Reserve').AsInteger, Data.MemAnalog.FieldByName(sNameGlobalQuants).AsInteger])),
        'Внимание',
        MB_OK or MB_ICONWARNING
      );
    Exit;
  end;

  with TSaleOrderAdd.Create(nil) do
  try
    SetMaxValue(
      Data.MemAnalog.FieldByName(sNameGlobalQuants).AsInteger - Data.MemAnalog.FieldByName('Reserve').AsInteger,
      XRound(Data.Rate*Data.MemAnalog.FieldByName('PriceItog').AsCurrency * (100 - Data.SysParamTable.FieldByName('MaxDiscount').AsInteger) / 100, 2)
    );
    SetParametrValue(
      Data.MemAnalog.FieldByName('An_Code').AsString,
      Data.MemAnalog.FieldByName('An_Brand').AsString,
      Data.MemAnalog.FieldByName('Description').AsString,
      Data.MemAnalog.FieldByName('Price_koef').AsString,
      CheckNeedMult(Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger,
                    Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
                    Data.CatalogDataSource.DataSet.FieldByName('SubGroup_id').AsInteger,
                    Data.CatalogDataSource.DataSet.FieldByName('Mult').AsInteger),

      -1
    );
    ShowModal;
  finally
    Free;
  end;
  Data.TableSaleOrder.Refresh;
  Data.AnalogTable.Refresh;
  Data.CatalogDataSource.DataSet.Refresh;  
end;

procedure TMain.AddToSaleReturnDocExecute(Sender: TObject);
begin
  if not CheckDocumentEnabled(EditSaleReturnDoc) then
    Exit;

  with TAddToReturnDocWindow.Create(Application) do
  begin
    SetParametrValue(
      Data.CatalogDataSource.DataSet.FieldByName('Code').AsString,
      Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString,
      Data.CatalogDataSource.DataSet.FieldByName('Name_Descr').AsString,
      '',
      '1',
      Data.CatalogDataSource.DataSet.FieldByName('Price_koef').AsString,
      CheckNeedMult(Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger,
                    Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
                    Data.CatalogDataSource.DataSet.FieldByName('SubGroup_id').AsInteger,
                    Data.CatalogDataSource.DataSet.FieldByName('Mult').AsInteger),

      -1
    );
    ShowModal;
    Data.TableReturnDoc.Refresh;
  end;
end;

procedure TMain.AboutBrandClick(Sender: TObject);
var
  s:string;
begin
   s :=Data.CatalogDataSource.DataSet.FieldByName('BrandDescr').AsString;
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

var
  aCol: TColumnEh;
begin
  OrderGrid.Columns.BeginUpdate;
  OrderGrid.AutoFitColWidths := False;
  OrderDetGrid.Columns.BeginUpdate;
  OrderDetGrid.AutoFitColWidths := False;
  try
    if acShowOrdersInPofitPrices.Checked then
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

procedure TMain.acAddAnToKKExecute(Sender: TObject);
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

procedure TMain.acKKPrintToExcelExecute(Sender: TObject);

  //выкидываем в Excel
  procedure ExportMemKK(aSort: Integer; aShowSubtitles: Boolean);
  var
    i, b, g, sg: Integer;
    sGroup, sSubGroup, sBrand: string;
    s: string;

    ExcelApp: Excel_TLB.TExcelApplication;
    wb: Excel_TLB.ExcelWorkbook;
    ir: Excel_TLB.ExcelRange;
    iRow: Integer;
  begin
    i := 0;
    b := 0;
    g := 0;
    sg := 0;

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
      ir.Value2 := 'Код';
      ir.ColumnWidth := 20;
      ir.Borders.LineStyle := xlContinuous;
      ir.Font.Bold := 1;


      ir := ir.Offset[0, 1];
      ir.Value2 := 'Бренд';
      ir.ColumnWidth := 16;
      ir.Borders.LineStyle := xlContinuous;
      ir.Font.Bold := 1;

      ir := ir.Offset[0, 1];
      ir.Value2 := 'Описание';
      ir.ColumnWidth := 40;
      ir.Borders.LineStyle := xlContinuous;
      ir.Font.Bold := 1;

      ir := ir.Offset[0, 1];
      ir.Value2 := 'Цена, ' + GetCurrencyShortCode(Data.Curr);
      ir.ColumnWidth := 8;
      ir.Borders.LineStyle := xlContinuous;
      ir.Font.Bold := 1;

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
          
        Data.memKK.First;
        while not Data.memKK.Eof do
        begin
          if Data.XCatTable.Locate('Cat_Id', Data.memKK.FieldByName('Cat_Id').AsInteger, []) then
          begin
            Data.GroupTable.Locate('Group_Id;SubGroup_Id', VarArrayOf([Data.memKK.FieldByName('Group_Id').AsInteger, Data.memKK.FieldByName('SubGroup_Id').AsInteger]), []);
            sGroup := Data.GroupTable.FieldByName('Group_descr').AsString;
            sSubGroup := Data.GroupTable.FieldByName('SubGroup_descr').AsString;
            sBrand := Data.XCatTable.FieldByname('BrandDescr').AsString;

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
                ir := ir.Resize[1, 4];
                ir.Merge(1);
                ir.Value2 := s;
                ir.Borders.LineStyle := xlContinuous;
                ir.Font.Bold := 1;

                Inc(iRow);
              end;

            if Data.KK.FindKey([Data.XCatTable.FieldByName('Code2').AsString, sBrand]) then
            begin
              ir := ExcelApp.Range['A'+IntToStr(iRow), 'A'+IntToStr(iRow)];
              ir.Item[1, 1] := '''' + Data.KK.FieldByName('Code').AsString;
              ir.Item[1, 2] := Data.KK.FieldByName('Brand').AsString;
              ir.Item[1, 3] := Data.KK.FieldByName('Descr').AsString;
              ir.Item[1, 4] := Data.KK.FieldByName('Price_pro').AsString;
              Inc(iRow);
            end;
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
  end;

  //закидываем в memory-таблицу с IDшками групп и брендов для сортировки по ним
  procedure PrintKKReport(aSort: Integer; aShowSubtitles, aSkipNullQuants: Boolean);
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

      ExportMemKK(aSort, aShowSubtitles);

    finally
      Data.KK.EnableControls;
      Data.memKK.Close;
      Data.memKK.EmptyTable;
    end;

  end;

var
  aSort: Integer;
begin
  //печатать попорядку группа/бренд или бренд/группа
  with TPrintCOParamsForm.Create(Self) do
  try
    if ShowModal = mrOK then
    begin
     //print
      if rbSortGroupBrand.Checked then
        aSort := 1
      else
      if rbSortBrandGroup.Checked then
        aSort := 2
      else
        aSort := 3;
      PrintKKReport(aSort, cbIncludeSubtitles.Checked, cbExcludeNullQuants.Checked);
    end;

  finally
    Free;
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

procedure TMain.acRunOilCatalogExecute(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://eni-ita.lubricantadvisor.com/default.aspx?Lang=rus'), nil, nil, SW_SHOW);
end;

procedure TMain.acRunOliShellExecute(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://lubematch.shell.com.ru/landing.php?setregion=349&setlanguage=14&site=58&region=349&language=14&brand=95'), nil, nil, SW_SHOW);
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
  ShellExecute(Handle, nil, PAnsiChar(' http://polmostrow.pl/katalog.php'), nil, nil, SW_SHOW);
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
    IgnoreSpecialSymbolsCheckBox.Checked := False;
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

procedure TMain.acKitAddToOrderExecute(Sender: TObject);
var
  bNew: boolean;
  UserData, UserDataOrder: TUserIDRecord;
  aSavedOrderID: Integer;
  aCode, aBrand: string;
  aMult: Integer;
begin
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
 { if Data.ParamTable.FieldByName('bWarnOrderLimits').AsBoolean then
  begin
    if Data.OrderDetTable.RecordCount > cMaxOrderDetCount then
    begin
      Pager.ActivePage := CatZakPage;
      ZakTabRect := Pager.GetTabRect(CatZakPage);
      ShowBallonWarn(Pager, lbOrderFlame.Caption, 'Предупреждение', ZakTabRect.Left + 9, (ZakTabRect.Top + ZakTabRect.Bottom) div 2);
    end;
  end;  }
  {$ENDIF}
end;

procedure TMain.acKitMoveToPosExecute(Sender: TObject);
begin
  GoToCatID(Data.KitTable.FieldByName('CHILD_ID').AsInteger);
end;

procedure TMain.AddAnToOrder(aRequestQuants: Boolean = False);
var
  bNew: boolean;
  UserData, UserDataOrder: TUserIDRecord;
  aSavedOrderID: Integer;
  aCode, aBrand: string;
begin
  if Data.memAnalog.FieldByName('OrderOnly').AsBoolean then
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
end;


procedure TMain.AddAnToWaitList;
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
          if UserData.sId <> '' then
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

    if Data.OrderDetTable.FieldByName('Mult').AsInteger = 0 then
      MultInfo.Value := 1
    else
      MultInfo.Value := Data.OrderDetTable.FieldByName('Mult').AsInteger;

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
    if acShowOrdersInPofitPrices.Checked then
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

procedure TMain.EmailDocLimitExecute(Sender: TObject);
var
  sFileName: string;
  aUser: TUserIDRecord;
begin
  if Data.TableDocLimitDet.RecordCount < 1 then
    Exit;

  if not CheckClientId then
    Exit;
  aUser := GetCurrentUser;

     with Data.TableDocLimit do
      begin
          if FieldByName('DocLimitID').AsInteger < 1 then
            exit;
          if FieldByName('State').AsString > '0' then
            begin
              with createmessagedialog('Возможно документ уже отправлялся! Продолжить?',mtInformation,[mbYes,mbNo],mbNo) do
              begin
                if ShowModal = mrNo then
                  exit;
              end;
              sFileName := DateTimeToStr(Now)+'_.csv';
              sFileName := ReplaceStr(sFileName, ':','_');
              sFileName :=Data.Export_path+'Лимиты_'+sNameGlobalBase+'_'+Data.TableDocLimit.FieldByName('Date').AsString+'_Повтор_'+sFileName;

            end
          else
          begin
            sFileName :=Data.Export_path+'Лимиты_'+sNameGlobalBase+'_'+Data.TableDocLimit.FieldByName('Date').AsString+'.csv';
          end;
      end;
      Memo.Lines.Clear;

      with Data.TableDocLimitDet do
      begin
          First;
          while not Data.TableDocLimitDet.Eof do
          begin
             if Data.TableDocLimit.FieldByName('DocLimitID').AsInteger = FieldByName('DocLimitID').AsInteger then
                Memo.Lines.Add(FieldByName('Code').AsString+'_'+FieldByName('Brand').AsString+';'+FieldByName('NewValue').AsString+';'+sNameGlobalBase+';');
                Next;
          end;
      end;



      Memo.Lines.SaveToFile(sFileName);
      with Data.TableDocLimit do
      begin
          Edit;
          FieldByName('State').Value := 2;
          Post;
      end;


      if Data.ParamTable.FieldByName('TCP_Direct').AsBoolean then
      begin
        if Trim(aUser.sEMail) = '' then
        begin
          MessageDlg('Настройте E-Mail текушего клиента в параметрах программы!', mtError, [mbOK], 0);
          Exit;
        end;

        if SendEMailByTCP(
          Trim(aUser.sEMail),
          Trim(Data.SysParamTable.FieldByName('EmailLimit').AsString),
          'Лимиты ' + sNameGlobalBase + ' ' + Data.TableDocLimit.FieldByName('Date').AsString,
          'Лимиты ' + sNameGlobalBase + ' ' + Data.TableDocLimit.FieldByName('Date').AsString,
          sFileName
        ) then
        begin
          with Data.TableDocLimit do
          begin
            Edit;
            FieldByName('State').Value := 1;
            Post;
          end;
          MessageDlg('Отправлен лимит!', mtInformation, [mbOK],0);
        end;
      end
      else
      begin
        with Mailer do
        begin
          Clear;
          Recipient.AddRecipient(Data.SysParamTable.FieldByName('EmailLimit').AsString);
          Subject := 'Лимиты '+sNameGlobalBase+' '+Data.TableDocLimit.FieldByName('Date').AsString;
          Attachment.Add(sFileName);
          try
            SendMail;
             with Data.TableDocLimit do
             begin
                 Edit;
                 FieldByName('State').Value := 1;
                 Post;
              end;
      except
      end;
        end;

    end;
end;

procedure TMain.EmailOrder;

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
  fname, fNameSplitted, subj, subjSplitted, email, s, inf: string;
  F: TextFile;
  UserData, UserDataOrder: TUserIDRecord;
  aNewDiscVer: Integer;
  aSavedOrderID, aSplittedOrderID: Integer;
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
    
  with Data.OrderTable do
  begin
    if FieldByName('Description').AsString <> '' then
       if (Data.OrderTable.FieldByName('Delivery').AsInteger = 2) then
          inf := ' [Самовывоз. ' + FieldByName('Description').AsString + ']'
      else
        inf := ' [Доставка. ' + FieldByName('Description').AsString + ']'
    else
      if (Data.OrderTable.FieldByName('Delivery').AsInteger = 2)then
          inf := ' [Самовывоз]'
      else
          inf := ' [Доставка]';
  end;

  if Data.ParamTable.FieldByName('TCP_Direct').AsBoolean then
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
               'Отправить используя E-Mail текущего клиента?'
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

    aSplittedOrderID := 0;
    if IsOrderMixGroups then
      if Application.MessageBox(
        PChar(
        'Внимание! Товары из нижеперечисленных групп должны быть отправлены отдельным заказом:'#13#10 +
        GetNewCartGroups + #13#10 +
        'Сейчас будет создана новая корзина, товары этих групп будут перенесены в нее и также отправлены.'#13#10 +
        'Продолжить?'),
        'Предупреждение', MB_YESNO or MB_ICONWARNING) <> IDYES then
        Abort
      else
      begin
        aSavedOrderID := Data.OrderTable.FieldByName('ORDER_ID').AsInteger;
        try
          aSplittedOrderID := SplitMixOrder; //split current order to two orders
          //save splitted order
          if not Data.OrderTable.Locate('ORDER_ID', aSplittedOrderID, []) then
            Exit;
          fNameSplitted := SaveOrder(False);
        finally
          //restore order id
          Data.OrderTable.Locate('ORDER_ID', aSavedOrderID, []);
        end;
      end;

    fname := SaveOrder_Old(False);

    if SendOrderTCP(email, fName, inf) then //send current order
      if aSplittedOrderID > 0 then
      begin
        SendOrderTCP(email, fNameSplitted, inf, aSplittedOrderID); //send splitted order
      end;
    end
  else
  begin
    fname := SaveOrder_Old(False);
    subj := 'ClientID: ' + Data.OrderTable.FieldByName('Cli_id').AsString +
            ' OredrID: ' +  Data.OrderTable.FieldByName('Order_id').AsString +
            ' Date/Num: ' + Data.OrderTable.FieldByName('Date').AsString + '/'+
            Data.OrderTable.FieldByName('Num').AsString + Data.OrderTable.FieldByName('Type').AsString + Inf;

    with Mailer do
    begin
      Clear;
      Recipient.AddRecipient(Data.SysParamTable.FieldByName('Shate_email').AsString);
{
      Subject := inf;
      Body.Clear;
      Body.Add(subj);
}
      Body.Clear;
      Subject := subj;
      Attachment.Add(fname);
      try
        SendMail;
        MarkSending;
      except
      end;
    end;
  end;
end;

//#new
procedure TMain.EmailSaleReturnDocExecute(Sender: TObject);
var
  sFileName: string;
  aUser: TUserIDRecord;
begin
   if Data.TableReturnDocDet.RecordCount < 1 then
        exit;
    if Data.TableReturnDoc.FieldByName('ReturnDocId').AsInteger < 1 then
      exit;

  if not CheckClientId then
    Exit;
  aUser := GetCurrentUser;


   Memo.Lines.Clear;
      with Data.TableReturnDoc do
      begin
          if FieldByName('State').AsString > '0' then
            begin
              with createmessagedialog('Возможно документ уже отправлялся! Продолжить?',mtInformation,[mbYes,mbNo],mbNo) do
              begin
                if ShowModal = mrNo then
                  exit;
              end;
              sFileName := DateTimeToStr(Now)+'_.csv';
              sFileName := ReplaceStr(sFileName, ':','_');
              sFileName :=Data.Export_path+'Return_'+sNameGlobalBase+'_'+Data.TableReturnDoc.FieldByName('Date').AsString+'_'+Data.TableReturnDoc.FieldByName('ReturnDocId').AsString+'_Повтор_'+sFileName;

            end
          else
          begin
            sFileName :=Data.Export_path+'Return_'+sNameGlobalBase+'_'+Data.TableReturnDoc.FieldByName('Date').AsString+'_'+Data.TableReturnDoc.FieldByName('ReturnDocId').AsString+'.csv';
          end;
            Memo.Lines.Add('04B;'+FieldByName('Date').AsString+';USD;EUR;'+sNameGlobalBase+';'+sNameGlobalClient+';');
      end;


//
   with Data.TableReturnDocDet do
      begin
          First;
          while not Eof do
          begin
             if Data.TableReturnDoc.FieldByName('ReturnDocId').AsInteger = FieldByName('ReturnDocId').AsInteger then
                Memo.Lines.Add(FieldByName('Code').AsString+'_'+FieldByName('Brand').AsString+';'+FieldByName('Col').AsString+';'+FieldByName('Price').AsString+';');
                Next;
          end;
      end;

      Memo.Lines.SaveToFile(sFileName);
      Memo.Lines.Clear;
      with Data.TableReturnDoc do
      begin
          Edit;
          FieldByName('State').Value := 2;
          Post;
      end;

      if Data.ParamTable.FieldByName('TCP_Direct').AsBoolean then
      begin
        if Trim(aUser.sEMail) = '' then
        begin
          MessageDlg('Настройте E-Mail текушего клиента в параметрах программы!', mtError, [mbOK], 0);
          Exit;
        end;

        if SendEMailByTCP(
          Trim(aUser.sEMail),
          Trim(Data.SysParamTable.FieldByName('EmailRetSaleOrder').AsString),
          'Return ' + sNameGlobalBase + ' ' + Data.TableReturnDoc.FieldByName('Date').AsString,
          'Return ' + sNameGlobalBase + ' ' + Data.TableReturnDoc.FieldByName('Date').AsString,
          sFileName
        ) then
        begin
          with Data.TableReturnDoc do
          begin
            Edit;
            FieldByName('State').Value := 1;
            Post;
          end;

          MessageDlg('Отправлен возврат!', mtInformation, [mbOK], 0);
        end;
      end
      else
      begin
        with Mailer do
        begin
          Clear;
          Recipient.AddRecipient(Data.SysParamTable.FieldByName('EmailRetSaleOrder').AsString);
          Subject := 'Return'+sNameGlobalBase+' '+Data.TableReturnDoc.FieldByName('Date').AsString;
          Attachment.Add(sFileName);
          try
            SendMail;
            with Data.TableReturnDoc do
            begin
              Edit;
              FieldByName('State').Value := 1;
              Post;
            end;
          except
          end;
        end;
      end;
end;

//#new
procedure TMain.EmaleSaleOrderExecute(Sender: TObject);
var
  sFileName: string;
  aUser: TUserIDRecord;
  s: string;
begin
  if Data.TableSaleOrderDet.RecordCount < 1 then
     Exit;
  if Data.TableSaleOrder.FieldByName('SaleOrderID').AsInteger < 1 then
    exit;

  if not CheckClientId then
    Exit;
  aUser := GetCurrentUser;

  Memo.Lines.Clear;
  with Data.TableSaleOrder do
      begin

          Memo.Lines.Add('01B;'+FieldByName('Date').AsString+';USD;EUR;'+sNameGlobalBase+';'+sNameGlobalClient+';');
          if FieldByName('State').AsString > '0' then
          begin
            with createmessagedialog('Возможно документ уже отправлялся! Продолжить?',mtInformation,[mbYes,mbNo],mbNo) do
            begin
              if ShowModal = mrNo then
                exit;
            end;
            sFileName :=DateTimeToStr(Now)+'.csv';
            sFileName := ReplaceStr(sFileName, ':','_');
            sFileName :=Data.Export_path+'Sales_'+sNameGlobalBase+'_'+Data.TableSaleOrder.FieldByName('Date').AsString+'_'+Data.ParamTable.FieldByName('Eur_usd_rate').AsString+'_Повтор_'+sFileName;


          end
          else
          begin
            sFileName :=Data.Export_path+'Sales_'+sNameGlobalBase+'_'+Data.TableSaleOrder.FieldByName('Date').AsString+'_'+Data.ParamTable.FieldByName('Eur_usd_rate').AsString+'.csv';
          end;
      end;


  with Data.TableSaleOrderDet do
      begin
          First;
          while not Data.TableSaleOrderDet.Eof do
          begin
             if Data.TableSaleOrder.FieldByName('SaleOrderID').AsInteger = FieldByName('SaleOrderID').AsInteger then
                Memo.Lines.Add(FieldByName('Code').AsString+'_'+FieldByName('Brand').AsString+';'+FieldByName('Col').AsString+';'+FieldByName('Price').AsString+';');
                Next;
          end;
      end;

      Memo.Lines.SaveToFile(sFileName);
      Memo.Lines.Clear;
      with Data.TableSaleOrder do
      begin
          Edit;
          FieldByName('State').Value := 2;
          Post;
      end;

      if Data.ParamTable.FieldByName('TCP_Direct').AsBoolean then
      begin
        if Trim(aUser.sEMail) = '' then
        begin
          MessageDlg('Настройте E-Mail текушего клиента в параметрах программы!', mtError, [mbOK], 0);
          Exit;
        end;

        if SendEMailByTCP(
          Trim(aUser.sEMail),
          Trim(Data.SysParamTable.FieldByName('EmailSaleOrder').AsString),
          'Продажи '+sNameGlobalBase+' '+Data.TableSaleOrder.FieldByName('Date').AsString,
          'Продажи '+sNameGlobalBase+' '+Data.TableSaleOrder.FieldByName('Date').AsString,
          sFileName
        ) then
        begin
          with Data.TableSaleOrder do
          begin
            Edit;
            FieldByName('State').Value := 1;
            Post;
          end;

          MessageDlg('Отправлены продажи!', mtInformation, [mbOK],0);
        end;
      end
      else
      begin
        with Mailer do
        begin
          Clear;
          Recipient.AddRecipient(Data.SysParamTable.FieldByName('EmailSaleOrder').AsString);
          Subject := 'Продажи '+sNameGlobalBase+' '+Data.TableSaleOrder.FieldByName('Date').AsString;
          Attachment.Add(sFileName);
          try
            SendMail;
             with Data.TableSaleOrder do
             begin
                 Edit;
                 FieldByName('State').Value := 1;
                 Post;
              end;
          except
          end;
        end;
      end;
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

function TMain.SaveReturnDoc(sFileName: string): Boolean;
var
  fname: string;
  F: TextFile;
  rn: Integer;
  s: string;
  fileDate: Integer;
begin
  Result := False;
  
  if Data.ReturnDocTable.FieldByName('RetDoc_id').AsString < '1' then
    Exit;

  if not CheckClientId then
    Exit;

  if Data.ReturnDocDetTable.RecordCount < 1 then
  begin
    MessageDlg('Невозможно сохранить пустой возврат!', mtError, [mbOK], 0);
    Exit;
  end;

  if Data.ReturnDocTable.FieldByName('cli_id').AsString = '' then
  begin
    MessageDlg('Не указан идентификатор клиента в возврате!', mtError, [mbOK], 0);
    Exit;
  end;

  if Length(Data.ReturnDocTable.FieldByName('Type').AsString) < 1 then
  begin
     MessageDlg('Не указан тип возврата!', mtError, [mbOK], 0);
     Exit;
  end;

  with Data.ReturnDocTable do
  begin
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
        Exit;
      fname := FileName;
    end
  end
  else
    fname := Data.Export_Path + sFileName;
  SetCurrentDir(Data.Data_Path);

  AssignFile(F, fname);
  Rewrite(F);
  StartWait;
  try
    with Data.ReturnDocTable do
    begin
      fileDate := FileAge(Application.ExeName);
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
        FieldByName('Quantity').AsString + ';';
        s := s + FieldByName('Note').AsString + ';';
        WriteLn(F,s);
        Next;
      end;
      RecNo := rn;
      EnableControls;
    end;
  finally
    CloseFile(F);
    StopWait;
  end;

  Data.ReturnDocTable.Edit;
  Data.ReturnDocTable.FieldByName('Post').AsInteger := 1;
  Data.ReturnDocTable.Post;
  Result := True;
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


  if (Data.OrderTable.FieldByName('Type').AsString='A') or ((Data.OrderTable.FieldByName('Delivery').AsString <> '2')and(Data.OrderTable.FieldByName('Delivery').AsString <> '1')) or (Data.OrderTable.FieldByName('Currency').AsString = '') or (Data.OrderTable.FieldByName('Currency').AsString = '0') then
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

function TMain.SaveOrder_Old(FNameDialog: Boolean = True): string;
var
  fname, s: string;
  F: TextFile;
  rn, sign: integer;
begin
  Result := '';

  if sNameGlobalID = '' then
  begin
    MessageDlg('Не выбранна база данных!', mtError, [mbOK], 0);
    Exit;
  end;

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


  if (Data.OrderTable.FieldByName('Type').AsString='A') or ((Data.OrderTable.FieldByName('Delivery').AsString <> '2')and(Data.OrderTable.FieldByName('Delivery').AsString <> '1')) or (Data.OrderTable.FieldByName('Currency').AsString = '') or (Data.OrderTable.FieldByName('Currency').AsString = '0') then
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

  with Data.OrderTable do
  begin
    if FieldByName('Order_id').AsInteger = 0 then
      Exit;
    fname := 'Заказ_' + sNameGlobalID + '_' +
             FieldByName('Order_id').AsString + '_' +
             FieldByName('Date').AsString + '_' +
             FieldByName('Num').AsString +
             'C.csv';
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
      Post;
    end;
    WriteLn(F, sNameGlobalID+ ';' +
                 FieldByName('Date').AsString + ';' +
                 FieldByName('Sign').AsString + ';' +
                 'C;2;');
  end;
  with Data.OrderDetTable do
  begin
    DisableControls;
    rn := RecNo;
    First;
    while not Eof do
    begin
      s := FieldByName('ArtCode').AsString + '_' +
           FieldByName('Brand').AsString + ';' +
           FieldByName('Quantity').AsString+ ';';
      if Data.ParamTable.FieldByName('bSaveWithPrice').AsBoolean then
        s := s+  FieldByName('Price_koef').AsString+';';
      WriteLn(F,s);
      Next;

    {      WriteLn(F, FieldByName('ArtCode').AsString + '_' +
                 FieldByName('Brand').AsString + ';' +
                 FieldByName('Quantity').AsString);
      Next;}
    end;
    RecNo := rn;
    EnableControls;
  end;
  CloseFile(F);
  StopWait;
  Result := fname;

  Data.OrderTable.Edit;
  Data.OrderTable.FieldByName('Sent').AsInteger := 3;
  Data.OrderTable.Post;
end;

procedure TMain.SaveReturnDocActionExecute(Sender: TObject);
var
  s: string;
begin
   //SaveReturnDoc('');
   s := '';
   SaveReturnDoc_Old(s);
   fPostOrder := False;
end;

//sklad
function TMain.SaveReturnDoc_Old(var sFileName: string; aWithoutSaveDialog: Boolean): Boolean;
var
  fname, s: string;
  F: TextFile;
  rn: Integer;
begin
  Result := False;

  if Data.ReturnDocTable.FieldByName('RetDoc_id').AsString < '1' then
    Exit;

  if not CheckClientId then
    Exit;

  Result := False;
  if Data.ReturnDocDetTable.RecordCount < 1 then
  begin
    MessageDlg('Невозможно сохранить пустой возврат!', mtError, [mbOK], 0);
    Exit;
  end;

  if Data.ReturnDocTable.FieldByName('cli_id').AsString = '' then
  begin
    MessageDlg('Не указан идентификатор клиента в возврате!', mtError, [mbOK], 0);
    Exit;
  end;

  if Length(Data.ReturnDocTable.FieldByName('Type').AsString) < 1 then
  begin
    MessageDlg('Не указан тип возврата!', mtError, [mbOK], 0);
    Exit;
  end;

  with Data.ReturnDocTable do
  begin
    fname := Data.Export_path + 'Возврат поставщику_' + sNameGlobalClient + '_' + FieldByName('Data').AsString;
    if FieldByName('Post').AsInteger > 0 then
    begin
      if Application.MessageBox('Возможно документ уже отправлялся! Продолжить?', 'Подтверждение', MB_YESNO or MB_ICONINFORMATION) = IDYES then
      begin
        fname := fname + '_Повтор_' + ReplaceStr(DateTimeToStr(Now)+'_.csv', ':','_');
      end
      else
        Exit;
    end
    else
    begin
      fname := fname + '.csv';
    end;
  end;

  if Length(sFileName) < 1 then
  begin
    if not aWithoutSaveDialog then
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

  AssignFile(F, fname);
  Rewrite(F);
  StartWait;
  try
    with Data.ReturnDocTable do
    begin
      if(FieldByName('Sign').AsString = '') then
      begin
        Edit;
        FieldByName('Sign').AsString := IntToStr(RandomRange(1111111, 9999999));
        FieldByName('TcpAnswer').AsVariant := NULL;
        Post;
      end;

  { //первой строки нет
      if FieldByName('Type').AsString = 'A' then
      begin
        WriteLn(F, FieldByName('cli_id').AsString+';'+FieldByName('Data').AsString+';' +FieldByName('Sign').AsString+';04A;'+FieldByName('Note').AsString+';');
      end
      else
      begin
        WriteLn(F, FieldByName('cli_id').AsString+';'+FieldByName('Data').AsString+';' +FieldByName('Sign').AsString+';04B;'+  FieldByName('Note').AsString+';');
      end;
  }
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
        s := s + FieldByName('Note').AsString+';';
        WriteLn(F,s);
        Next;
      end;
      RecNo := rn;
      EnableControls;
    end;

  finally
    CloseFile(F);
    StopWait;
  end;

  Data.ReturnDocTable.Edit;
  Data.ReturnDocTable.FieldByName('Post').AsInteger := 1;
  Data.ReturnDocTable.Post;

  sFileName := fname;
  Result := True;
end;

//#new
procedure TMain.SaveSaleOrderExecute(Sender: TObject);
var sFileName:string;
begin
   if Data.TableSaleOrderDet.RecordCount < 1 then
      exit;

  Memo.Lines.Clear;
  with Data.TableSaleOrder do
      begin
          if FieldByName('SaleOrderID').AsInteger < 1 then
            exit;

          Memo.Lines.Add('01B;'+FieldByName('Date').AsString+';USD;EUR;'+sNameGlobalBase+';'+sNameGlobalClient+';');
          if FieldByName('State').AsString > '0' then
          begin
            with createmessagedialog('Возможно документ уже отправлялся! Продолжить?',mtInformation,[mbYes,mbNo],mbNo) do
            begin
              if ShowModal = mrNo then
                exit;
            end;
            sFileName:=DateTimeToStr(Now)+'.csv';
            sFileName := ReplaceStr(sFileName, ':','_');
            sFileName :=Data.Export_path+'Sales_'+sNameGlobalBase+'_'+Data.TableSaleOrder.FieldByName('Date').AsString+'_'+Data.ParamTable.FieldByName('Eur_usd_rate').AsString+'_Повтор_'+sFileName;
         end
          else
          begin
            sFileName :=Data.Export_path+'Sales_'+sNameGlobalBase+'_'+Data.TableSaleOrder.FieldByName('Date').AsString+'_'+Data.ParamTable.FieldByName('Eur_usd_rate').AsString+'.csv';
          end;
      end;


    with SaveOrderDialog do
      begin
       InitialDir := Data.Export_path;
       FileName   := sFileName;
       try
       if not Execute then
         exit;
       except
         on e: Exception do
           MessageDlg('Ошибка: ' + e.Message, mtError, [mbOK], 0);

       end;
       sFileName := FileName;
      end;

   with Data.TableSaleOrderDet do
      begin
          First;
          while not Data.TableSaleOrderDet.Eof do
          begin
             if Data.TableSaleOrder.FieldByName('SaleOrderID').AsInteger = FieldByName('SaleOrderID').AsInteger then
                Memo.Lines.Add(FieldByName('Code').AsString+'_'+FieldByName('Brand').AsString+';'+FieldByName('Col').AsString+';'+FieldByName('Price').AsString+';');
                Next;
          end;
      end;

      Memo.Lines.SaveToFile(sFileName);
      Memo.Lines.Clear;
      with Data.TableSaleOrder do
      begin
          Edit;
          FieldByName('State').Value := 2;
          Post;
      end;
end;

//#new
procedure TMain.SaveSaleReturnDocExecute(Sender: TObject);
  var sFileName:string;
begin

if Data.TableReturnDocDet.RecordCount < 1 then
        exit;
   Memo.Lines.Clear;
      with Data.TableReturnDoc do
      begin
          if FieldByName('ReturnDocId').AsInteger < 1 then
            exit;
          if FieldByName('State').AsString > '0' then
            begin
              with createmessagedialog('Возможно документ уже отправлялся! Продолжить?',mtInformation,[mbYes,mbNo],mbNo) do
              begin
                if ShowModal = mrNo then
                  exit;
              end;
              sFileName := DateTimeToStr(Now)+'_.csv';
              sFileName := ReplaceStr(sFileName, ':','_');
              sFileName :=Data.Export_path+'Return_'+sNameGlobalBase+'_'+Data.TableReturnDoc.FieldByName('Date').AsString+'_'+Data.TableReturnDoc.FieldByName('ReturnDocId').AsString+'_Повтор_'+sFileName;
            end
          else
          begin
            sFileName :=Data.Export_path+'Return_'+sNameGlobalBase+'_'+Data.TableReturnDoc.FieldByName('Date').AsString+'_'+Data.TableReturnDoc.FieldByName('ReturnDocId').AsString+'.csv';
          end;
            Memo.Lines.Add('04B;'+FieldByName('Date').AsString+';USD;EUR;'+sNameGlobalBase+';'+sNameGlobalClient+';');
      end;

 with SaveOrderDialog do
      begin
       InitialDir := Data.Export_path;
       FileName   := sFileName;
       if not Execute then
         exit;
       sFileName := FileName;
      end;

   with Data.TableReturnDocDet do
      begin
          First;
          while not Eof do
          begin
             if Data.TableReturnDoc.FieldByName('ReturnDocId').AsInteger = FieldByName('ReturnDocId').AsInteger then
                Memo.Lines.Add(FieldByName('Code').AsString+'_'+FieldByName('Brand').AsString+';'+FieldByName('Col').AsString+';'+FieldByName('Price').AsString+';');
                Next;
          end;
      end;

      Memo.Lines.SaveToFile(sFileName);
      Memo.Lines.Clear;
      with Data.TableReturnDoc do
      begin
          Edit;
          FieldByName('State').Value := 2;
          Post;
      end;
end;

procedure TMain.SaveWaitListExecute(Sender: TObject);
var sFileName, sFilter:string;
    ftFile:TextFile;
    sData:string;
    CurDate:TDate;
    rNo:integer;
begin
  //Сохранить лист ожидания
  try
    SaveFilePriceDialog.InitialDir := Data.Export_Path;
    SaveFilePriceDialog.FileName := 'WaitList.csv';
  if SaveFilePriceDialog.Execute() = false then
    exit;

  SetCurrentDir(Data.Data_Path);
  sFileName:= SaveFilePriceDialog.FileName;
  if FileExists(sFileName) then
    if MessageDlg('Файл уже существует. Переписать', mtInformation, [mbYes, MBNO],0) <> ID_YES  then
      exit;

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
   ReWrite(ftFile);
   with Data.WaitListTable do
   begin
    rNo := RecNo;
    DisableControls;
    Filtered := FALSE;
    First;
    while not EOF do
    begin
      if Data.WaitListTable.FieldByName('Data').AsString = '' then
      begin
        Edit;
        FieldByName('Data').AsString := sData;
        Post;
      end;
        WriteLn(ftFile,FieldByName('Code2').AsString +'_'+FieldByName('Brand').AsString+';'
            +FieldByName('Quantity').AsString+';'+FieldByName('Info').AsString+';');
      Next;
    end;

    Filtered := TRUE;
    RecNo := rNo;
    EnableControls;
   end;
   CloseFile(ftFile);
   except
     on E:Exception do
     begin
       MessageDlg('Ошибка - '+E.Message, mtError, [MBOK],0);
       exit;
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
  if (Data.OrderTable.FieldByName('Sent').AsString <> '')AND(Data.OrderTable.FieldByName('Sent').AsString <> '0')and (Data.OrderTable.FieldByName('Sent').AsString <> '3')then
  begin
    if (Data.OrderTable.FieldByName('LotusNumber').AsString <> '') and (Data.OrderTable.FieldByName('Type').AsString = 'A') then
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
      if (Data.OrderTable.FieldByName('LotusNumber').AsString <> '') and (Data.OrderTable.FieldByName('Type').AsString = 'A') then
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

procedure TMain.SetAnActionEnabled;
begin
  AddAnToOrderAction.Enabled  := Data.memAnalog.FieldByName('An_id').AsInteger <> 0;
  AddAnToWaitListAction.Enabled  := Data.memAnalog.FieldByName('An_id').AsInteger <> 0;
end;


function TMain.SetCarFilter(aCarId: Integer): Boolean;
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
      Data.WaitListTable.IndexName := '';
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
    else if SameText(copy(aZipName,1,6), 'quants') then
      Result := wupQuantsStock
    // картинки (частичное обновление)
    else if SameText(Copy(aZipName, 1, Length(UPD_PICTS_DISCRET)), UPD_PICTS_DISCRET) then
      Result := wupPictsDiscret;
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
  if anUpdateType <> wupQuantsStock then
    aQueueItem.VersionsInside := True //версии внутри пакета
  else
    aQueueItem.VersionsInside := False;
  UpdateThrd := TUpdateDataThrd.Create(Self.Handle);
  UpdateThrd.OnTerminate := UpdateDataThreadTerminate;
  UpdateThrd.Init(
    fUpdateQueue,
    tmp_path{aTempPath}
  );

  LockAutoUpdate(True);
  UpdateThrd.Resume;

{
      Data.LoadingLock;
      Data.QuantTable.Close;
      aZipName := tmp_path + 'qnt.csv';
      Data.LoadQuantFromExcell(aZipName);
      Data.QuantTable.Open;
      Data.LoadingUnlock;

      Data.CalcWaitList;
      Exit;
}
//********************* comment END

  //SecurityAttributes

  // CreateDir(tmp_path);
 { if True then
  
   { if not DirectoryExists(tmp_path) then
    begin
       try
        initializeSecurityDescriptor(@SecurityAttributes,SECURITY_DESCRIPTOR_REVISION);
        MessageDlg('1', mtInformation, [mbOK],0);
        SetSecurityDescriptorOwner(@SecurityAttributes, nil, TRUE);
        MessageDlg('2', mtInformation, [mbOK],0);
        CreateDirectory('C:\testlite',nil);
        MessageDlg('3', mtInformation, [mbOK],0);
       except
         on E:Exception do
          MessageDlg(E.Message, mtInformation, [mbOK],0);
       end;
    end;

    MessageDlg('4', mtInformation, [mbOK],0);
        exit;   }

(* //old mechanism start here
  if not Data.OpenZipDialog.Execute then
    exit;
    SetCurrentDir(Data.Data_Path);
  try
    StartWait;

    fname := ExtractFileName(Data.OpenZipDialog.FileName);
    if AnsiLowerCase(fname) = UPD_NEWS_ZIP then
      begin
      UnZipper.DestDir  := GetAppDir;
      UnZipper.ZipName  := Data.OpenZipDialog.FileName;
      UnZipper.Password := UPD_PWD;
      UnZipper.UnZip;
      end;

    if AnsiLowerCase(fname) = UPD_DATA_ZIP then
    begin
      Data.DoImport(Data.OpenZipDialog.FileName);
    end
    else if AnsiLowerCase(fname) = UPD_QUANTS_ZIP then
    begin
      Data.LoadingLock;
      Data.QuantTable.Close;
      Data.LoadQuantFromExcell(Data.OpenZipDialog.FileName);
      Data.QuantTable.Open;
      Data.LoadingUnlock;
    end
    else if AnsiLowerCase(fname) = UPD_NEWS_ZIP then
    begin
    end
    else
      MessageDlg('Это не файл обновления!', mtError, [mbOK], 0);
    Data.CalcWaitList;
  finally
    StopWait;
   if (Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdate').AsBoolean)
      and((Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdateProg').AsBoolean)
          or(Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdateQuants').AsBoolean))  then
      begin
        TimerUpdate.Enabled := TRUE;
      end;
  end;
  *)
end;

procedure TMain.DowebUpdate(IsExtUpdate: Boolean = False);
var
  upd_url: string;
  aModalResult: Integer;
begin
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
      if upd_url <> '' then
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

procedure TMain.DoWebUpdateStock(aAutoUpdate: Boolean);
var
  upd_url: string;
  aModalResult: Integer;
begin
  if Assigned(UpdateThrd) or (not bTerminate) then
  begin
    MessageDlg('В данный момент уже устанавливается обновление.'#13#10 +
               'Дождитесь завершения и повторите попытку.', mtInformation, [mbOK], 0);
    Exit;
  end;

  try
    aModalResult := mrNone;
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//    if MainDownLoadFileMirrors(Data.GetUpdateUrlStock(True), Data.GetUpdateUrlDestFile, Data.GetUpdateUrlStock(False, True)) then
    if MainDownLoadFileMirrors(Data.GetUpdateUrlDestFile, False, 'test/markets/test/') then
    begin
//      upd_url := Data.GetUpdateUrl(False); //without proxy args
      upd_url := Data.BuildUpdateUrl(fCurrentWorkingServer, False); //without proxy args
      if upd_url <> '' then
      begin
        with TUpdatesWindows.Create(nil) do
        try
          if SetParametrs(Data.Import_Path, upd_url, aAutoUpdate{aSilentMode}, False) then
            if (not aAutoUpdate) or (Data.ParamTable.FieldByName('iUpdateTypeLoadQuants').AsInteger = 1{сообщить}) then
              aModalResult := ShowModal
            else
            begin
              btStartClick(btStart);
              btHideClick(btHide);
              aModalResult := mrOK;
            end;

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
      Exit;
  end;
end;

procedure TMain.DownloadUpdateError(var Msg: TMessage);
begin
  MessageDlg('Загрузка обновления не выполнена! Причина - ' + PChar(msg.lParam) + '.', mtError, [mbOK], 0);
  // CheckProgrammPeriod
  VersionTimer.Enabled := True;
end;

procedure TMain.WebSearchOE(OE: string);
begin
  if (Length(OE)<1) then
    exit;
  ShellExecute(Handle, nil, PAnsiChar('http://b2b.shate-m.com/Search/No?criteria=' + OE), nil, nil, SW_SHOW);
end;

procedure TMain.WebUpdateCustomValidate(Sender: TObject; Msg, Param: string;
  var Allow: Boolean);
begin
  Allow := True;
end;


procedure TMain.WebUpdateExtActionExecute(Sender: TObject);
begin
  DoWebUpdate(True);
end;

procedure TMain.WebUpdateStockActionExecute(Sender: TObject);
begin
  DowebUpdateStock(False);
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

  if Data.OrderTable.FieldByName('LotusNumber').AsString < '1' then
    Exit;

  sLotusNumber := Data.OrderTable.FieldByName('LotusNumber').AsString;

  Path := GetAppDir + 'Импорт\';
  sFileName := Path + Data.OrderTable.FieldByName('Date').AsString + '_' + Data.OrderTable.FieldByName('Num').AsString + '_' + sLotusNumber + '.zip';
  if not FileExists(sFileName) then
  begin
    TCPClientTest := TIdTCPClient.Create(nil);
    try
      if not DoTcpConnect(TCPClientTest) then
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
            sHesh := sHesh + inttostr(((StrToInt(email[iPosFile]+ sLotusNumber[iFilePos])*iFilePos) mod iPosFile))
          else
            sHesh := sHesh + inttostr(((StrToInt(email[iPosFile]+ sLotusNumber[iFilePos])*iFilePos) div iPosFile));

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

 with Data.OrderDetTable do
 begin
   DisableControls;
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
            if (Data.QuantTable.FieldByName('Quantity').AsString <> '0')AND(Data.QuantTable.FieldByName('Quantity').AsString <> '') then
              begin
                Edit;
                FieldByName('TestQuants').AsInteger := 2;
                Post;
              end
            else
              begin
                Edit;
                FieldByName('TestQuants').AsInteger := 1;
                Post;
              end;
          end
        else
           begin
             Edit;
             FieldByName('TestQuants').AsInteger := 1;
             Post;
           end;
      end
    else
    begin
      Edit;
      FieldByName('TestQuants').AsInteger := 1;
      Post;
    end;

    Next;
   end;
   if IndexName <> 'TestQuants' then
      IndexName := 'TestQuants';

   first;
   EnableControls;
 end;

  aTestQuantsFilled := Data.OrderTableOrder_id.AsInteger;

   with TTestForQuants.Create(nil) do
   begin
        ShowModal;
        Data.OrderDetTable.Refresh;
   end;
end;

procedure TMain.LoadOrder;
var
  s, ics, cb, cat_code, cat_brand, old_br_ind: string;
  brand_id: integer;
  quant: integer;
  F: TextFile;
  iLines:integer;
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
    try
      quant := StrToInt(ExtractDelimited(2,  s, [';']));//AToFloat(ExtractDelimited(2,  s, [';']));
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
        Memo.Lines.Insert(iLines,s+'; не найден ');
        Continue;
      end;

      with Data.OrderDetTable do
      begin
        if (cat_code <> '') and
          Data.LoadCatTable.FindKey([cat_code, brand_id]) then
        begin
//Кратность!
          if ((quant mod Data.LoadCatTable.FieldByName('Mult').AsInteger) <> 0) then
          begin
            if MessageDlg('Количество не кратно рекомендуемому! Позиция: '+
                          cat_code + '. Заказать с учетом кратности?', mtWarning, [mbYes, mbNo], 0) <> mrYes then
            begin
              Memo.Lines.Insert(iLines,s+'; Количество не кратно рекомендуемому!');
              Continue;
            end;
            quant := quant + quant mod Data.LoadCatTable.FieldByName('Mult').AsInteger;
          end;


          Append;
          FieldByName('Order_id').Value :=
          Data.OrderTable.FieldByName('Order_id').AsInteger;
          FieldByName('Code2').Value := cat_code;
          FieldByName('Brand').Value := cat_brand;
          if Data.LoadCatTable.FieldByName('SaleQ').AsString <> '1' then
            FieldByName('Price').Value := Data.GetDiscount(Data.LoadCatTable.FieldByName('Group_id').AsInteger,Data.LoadCatTable.FieldByName('SubGroup_id').AsInteger,Data.LoadCatTable.FieldByName('Brand_id').AsInteger) *
              Data.LoadCatTable.FieldByName('PriceItog').AsCurrency
          else
            FieldByName('Price').Value := Data.LoadCatTable.FieldByName('PriceItog').AsCurrency;
          //price_pro???
          CalcProfitPriceForOrdetDetCurrent;
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
        else
        begin
          with Data.DoubleTable do
          begin
            Open;
            SetRange([cat_code],[cat_code]);
            if RecordCount > 1 then
            begin
              with  TSelectDetail.Create(nil) do
              begin
                Caption := 'Выберите бренд для номера "'+cat_code+'"';
                if ShowModal = mrOk then
                begin
                  cat_brand := FieldByName('BrandName').AsString;

                  with Data.OrderDetTable do
                  begin
                    if (cat_code <> '') and
                      Data.LoadCatTable.FindKey([cat_code, Data.DoubleTable.FieldByName('Brand_Id').AsInteger]) then
                    begin
                      Append;
                      FieldByName('Order_id').Value :=
                      Data.OrderTable.FieldByName('Order_id').AsInteger;
                      FieldByName('Code2').Value := cat_code;
                      FieldByName('Brand').Value := cat_brand;
                      if Data.LoadCatTable.FieldByName('SaleQ').AsString <> '1' then
                        FieldByName('Price').Value := Data.GetDiscount(Data.LoadCatTable.FieldByName('Group_id').AsInteger,Data.LoadCatTable.FieldByName('SubGroup_id').AsInteger,Data.LoadCatTable.FieldByName('Brand_id').AsInteger) * Data.LoadCatTable.FieldByName('PriceItog').AsCurrency
                      else
                        FieldByName('Price').Value := Data.LoadCatTable.FieldByName('PriceItog').AsCurrency;
                      //price_pro???
                      CalcProfitPriceForOrdetDetCurrent;

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

                  Memo.Lines.Insert(iLines,s+'; заменен на '+cat_code+'_'+cat_brand);
                end //showmodal
                else
                  Memo.Lines.Insert(iLines,s+'; не найден ');

              end; //with
            end //if RecordCount > 1 then
            else
              if RecordCount = 1 then
              begin
                cat_brand := FieldByName('BrandName').AsString;

                with Data.OrderDetTable do
                begin
                  if (cat_code <> '') and
                     Data.LoadCatTable.FindKey([cat_code, Data.DoubleTable.FieldByName('Brand_Id').AsInteger]) then
                  begin
                    Append;
                    FieldByName('Order_id').Value :=
                    Data.OrderTable.FieldByName('Order_id').AsInteger;
                    FieldByName('Code2').Value := cat_code;
                    FieldByName('Brand').Value := cat_brand;
                    if Data.LoadCatTable.FieldByName('SaleQ').AsString <> '1' then
                      FieldByName('Price').Value := Data.GetDiscount(Data.LoadCatTable.FieldByName('Group_id').AsInteger,Data.LoadCatTable.FieldByName('Subgroup_id').AsInteger,Data.LoadCatTable.FieldByName('Brand_id').AsInteger) * Data.LoadCatTable.FieldByName('PriceItog').AsCurrency
                    else
                      FieldByName('Price').Value := Data.LoadCatTable.FieldByName('PriceItog').AsCurrency;
                    //price_pro???
                    CalcProfitPriceForOrdetDetCurrent;

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

                Memo.Lines.Insert(iLines,s+'; заменен на '+cat_code+'_'+cat_brand);
              end //if RecordCount = 1 then
                else
                  Memo.Lines.Insert(iLines,s+'; не найден ');

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
        FieldByName('Info').Value := InfoEd.Text;
        Post;
      end;
      Data.CalcWaitList;
    end;
    Free;
  end;
end;


procedure TMain.AdvToolBarButton53Click(Sender: TObject);
begin
  ShellExecute(Handle, nil, PAnsiChar('http://lubematch.shell.com.ru/landing.php?setregion=349&setlanguage=14&site=58&region=349&language=14&brand=95'), nil, nil, SW_SHOW);
end;

//#new
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
  if Data.WaitListTable.FieldByName('Code2').AsString = '' then
    exit;
  if ((Data.WaitListTable.FieldByName('ArtQuant').AsString = '') or
      (Data.WaitListTable.FieldByName('ArtQuant').AsString = '0')) and
      (MessageDlg('Нет в наличии у Шате-М+! Продолжить? ', mtWarning, [mbYes, mbNo], 0) <> mrYes) then
    exit;

  if Data.OrderTable.FieldByName('Order_id').AsInteger = 0 then
    if not NewOrder then
      Exit;

    select_cli := data.OrderTable.FieldByName('Cli_id').asString;
    cut_cli := data.WaitListTable.FieldByName('Cli_id').asString;
    if select_cli <> cut_cli then
    begin
      if (MessageDlg('Несовпадение клиентов!'#13#10'Переместить позицию в заказ №'+
         data.ordertable.FieldByName('num').asString + ' для клиента ' +
         data.ordertable.FieldByName('clientInfo').asString + '?', mtWarning, [mbYes, mbNo], 0) <> mrYes) then
       exit;
    end;

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
  cnt, Pos_old,pos_new, cnt_cli : integer;
  Select_Cli, Cut_Cli : string;
  fExt, fNotAll : boolean;
begin
  fExt := false;
  cnt_cli := 0;
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
  begin                                    if MessageDlg('Добавление в выбранный заказ невозможно !!! Заказ уже был отправлен в офис компании и вероятно уже обработан. Для проверки зарезервированного товара нажмите кнопку "TCP ответ". Создать новую корзину ?',mtInformation ,[mbYes,mbNo], 0) = mrNo  then
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
  CountingOrderSum
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
    Num,Cli_id:integer;
    DocType, Note:string;
begin
  if  '' = Data.ReturnDocTable.FieldByName('Retdoc_id').AsString then
      if not NewReturnDoc then
        exit;

  with TReturnDocED.Create(nil) do
  begin
       with Data.ReturnDocTable do
        begin
          DataDoc := FieldByName('Data').Value;
          Num := FieldByName('Num').AsInteger;
          DocType := FieldByName('Type').AsString;
          Cli_id := FieldByName('Cli_id').AsInteger;
          Note := FieldByName('Note').AsString;
        end;

    if ShowModal <> mrOk then
      begin
        with Data.ReturnDocTable do
        begin
          Edit;
          FieldByName('Data').Value := DataDoc;
          FieldByName('Num').Value := Num;
          FieldByName('Type').Value := DocType;
          FieldByName('Cli_id').Value := Cli_id;
          FieldByName('Note').Value := Note;
          Post;
        end;
      end;
  end;
  Data.ReturnDocTable.Refresh;
end;

procedure TMain.EditReturnDocPosExecute(Sender: TObject);
var iPos:integer;
begin
  //EditReturnDocPos
  if Data.ReturnDocDetTable.FieldByName('ID').AsString < '1' then
  begin
    Exit;
  end;

  iPos := Data.ReturnDocDetTable.RecNo;
  with TReturnDocPos.Create(Application) do
  begin
    SetParametrValue(
      Data.ReturnDocDetTable.FieldByName('Code2').AsString,
      Data.ReturnDocDetTable.FieldByName('Brand').AsString,
      Data.ReturnDocDetTable.FieldByName('Description').Asstring,
      Data.ReturnDocDetTable.FieldByName('Note').AsString,
      Data.ReturnDocDetTable.FieldByName('Quantity').AsInteger,
      False {aIsNew}
    );
    Color := Data.ParamTable.FieldByName('ColorReturnPost').AsInteger;
    Caption := Caption + ' [редактирование]';
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
begin
  if (E is EDatabaseError) and (E is EDBISAMEngineError) then
  begin
    if (EDBISAMEngineError(E).ErrorCode=DBISAM_RECLOCKFAILED) then
    begin
      MessageDlg('Запись заблокирована другим пользователем.', mtWarning, [mbOK], 0);
      exit
    end
    else if (EDBISAMEngineError(E).ErrorCode=DBISAM_KEYORRECDELETED) then
    begin
      MessageDlg('Запись удалена другим пользователем.', mtWarning, [mbOK], 0);
      if (Sender is TDBGridEh) then
        (Sender as TDBGridEh).DataSource.DataSet.Refresh;
      exit
    end
  end;
  with TStringList.Create do
  begin
    Text := E.Message;
    SaveToFile(GetAppDir + '!!!.err');
    Free;
  end;
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
    fPopupRss.BringToFront;
    //SetWindowPos(fPopupRss.Handle, Self.Handle{HWND_TOPMOST}, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  end
  else
  begin
    fPopupRss := TInfo.Create(Self);
    fPopupRss.JvFormStorage1.Active := False;
    fPopupRss.Caption := 'Последние новости компании';
    fPopupRss.Browser.Navigate(GetAppDir + 'Rss.tmp');
    fPopupRss.HideCheckBox.Visible := False;
    fPopupRss.Width := 550;
    fPopupRss.Height := 600;
    fPopupRss.Show;
    fPopupRss.BringToFront;
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

procedure TMain.BasesPropertiesOpenExecute(Sender: TObject);
begin
  with TBasesProperties.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
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
  iStr: Integer;
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

  QueryLoadOrderISAM.SQL.Clear;
  QueryLoadOrderISAM.SQL.Add('UPDATE ' + aTableName + ' SET bDelete = 1 WHERE CLI_ID = '''+aClientID+'''');
  QueryLoadOrderISAM.ExecSQL;
  QueryLoadOrderISAM.Close;



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
          subgr     := ExtractDelimited(2,  MemoFile[iStr], [';']);
          br     := ExtractDelimited(3,  MemoFile[iStr], [';']);
          dis     := ExtractDelimited(4,  MemoFile[iStr], [';']);
          if (gr <> '') and (subgr <> '') and (br <> '') and (dis <> '') then
          begin
            sFilter := 'GR_ID = '+gr+' AND SUBGR_ID = '+subgr+ ' AND BRAND_ID = '+br;
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
               FieldByName('Margin').AsFloat := 0;
               FieldByName('bDelete').AsInteger := 0;
               Post;
            end
            else
            begin
                Edit;
                FieldByName('Discount').AsFloat := AtoFloat(dis);
                FieldByName('bDelete').AsInteger := 0;
                Post;
            end;
          end;
        end;
  end;

  MemoFile.Free;
  QueryLoadOrderISAM.SQL.Clear;
  QueryLoadOrderISAM.SQL.Add('DELETE from ' + aTableName + ' WHERE (Margin = 0 OR Margin IS NULL) AND bDelete = 1');
  QueryLoadOrderISAM.ExecSQL;
  QueryLoadOrderISAM.Close;

  QueryLoadOrderISAM.SQL.Clear;
  QueryLoadOrderISAM.SQL.Add('UPDATE ' + aTableName + ' SET Discount = NULL WHERE bDelete = 1 AND CLI_ID = '''+aClientID+'''');
  QueryLoadOrderISAM.ExecSQL;
  QueryLoadOrderISAM.Close;

  QueryLoadOrderISAM.SQL.Clear;
  QueryLoadOrderISAM.SQL.Add('UPDATE ' + aTableName + ' SET bDelete = 0 WHERE bDelete = 1 AND CLI_ID = '''+aClientID+'''');
  QueryLoadOrderISAM.ExecSQL;
  QueryLoadOrderISAM.Close;

  //обновляем версию
  if aUpdateVersion then
  begin
    Table.Open;
    if Table.Locate('CLIENT_ID', aClientID, []) then
    begin
      Table.Edit;
      Table.FieldByName('DiscountVersion').AsInteger := aDiscountVersion;
      Table.Post;
    end;
    Table.Close;
  end;
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
begin
  Result := 0;

  //не посылаем запрос на сервер если ключ не задан или неверен
  if not CheckPrivateKey(sKey) then
    Exit;

  iNewVersion := 0;
  aDiscountVersion := 0;
  DeleteFile(Data.Import_Path + 'D.zip');
  try
    with TCPClient do
    begin
      Disconnect;
      try
        {$IFDEF TEST}
        Host := cTestTCPHost;
        Port := 6003;
        {$ELSE}
      //Host := Data.SysParamTable.FieldByName('Host').AsString;
        Host := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
        Port := Data.SysParamTable.FieldByName('PortIn').AsInteger;
        {$ENDIF}
        Connect;
      except
        try
           //Host := Data.SysParamTable.FieldByName('BackHost').AsString;
           Host := Data.SysParamTable.FieldByName('Host').AsString;
           Port := Data.SysParamTable.FieldByName('PortIn').AsInteger;
           Connect;
        except
            Host := Data.SysParamTable.FieldByName('TCPHost3').AsString;
            Port := Data.SysParamTable.FieldByName('PortIn').AsInteger;
            Connect;
        end;
      end;

      pub_key := MD5.MD5DigestToStr(MD5.MD5String(sID + sKey) );
      IOHandler.Writeln(Format('DISC_%s_%s_%s', [sID, pub_key, sVersion]));
      iLine := 0;
      repeat
        s := IOHandler.ReadLnWait;
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
            IOHandler.ReadStream(aStream, -1, False);
            aStream.SaveToFile(Data.Import_Path + 'D.zip');
          finally
            aStream.Free;
          end;
        end;
      until s = 'END';
    end;
  except
   on e: Exception do
     begin
      MessageDlg('Ошибка: ' + e.Message, mtError,[mbOK],0);
      TCPClient.Disconnect;
      Exit;
     end;
  end;

  TCPClient.Disconnect;

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
  finally
    Stream.Free;
  end;

  Result := 1;
end;

procedure TMain.LoadDiscountTCPExecute(Sender: TObject);
var
  UserData: TUserIDRecord;
  aRes: Integer;
  aNewDiscVer: Integer;
begin
  if not CheckClientId then
    Exit;

  if not CheckTcpDDOS(cCallTCPDiscountsInterval) then
  begin
    MessageDlg('Подождите!', mtInformation, [mboK], 0);
    Exit;
  end;

  StartWait;
  try
    UserData := GetCurrentUser;
    aRes := LoadDescriptionsTCP(ReplaceLeftSymbol(UserData.sId), ReplaceLeftSymbolAB(UserData.sKey), inttostr(UserData.DiscountVersion), aNewDiscVer);
    if aRes = 1 then
    begin
      UpdateUserData(UserData);
      Data.OrderTable.Refresh;
      Data.OrderDetTable.Refresh;
      Data.WaitListTable.Refresh;
      if Data.CatalogDataSource.DataSet.Active then
        Data.CatalogDataSource.DataSet.Refresh;
      ShowStatusBarInfo;  
    end;
  finally
    StopWait;
  end;

  case aRes of
    0: MessageDlg('Ошибка при загрузке скидок', mtInformation, [mbOK], 0);
    1: MessageDlg('Скидки загружены', mtInformation, [mbOK], 0);
    2: MessageDlg('У Вас самая актуальная версия скидок', mtInformation, [mbOK], 0);
  end;
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
var
  IDs: TStrings;
  t: Cardinal;
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

procedure TMain.SaleOrderGridDblClick(Sender: TObject);
begin
  EditSaleOrder.Execute;
end;

procedure TMain.SaleOrderGridDetDblClick(Sender: TObject);
begin
  if not CheckDocumentEnabled(EditSaleOrder) then
    Exit;
  with TSaleOrderAdd.Create(nil) do
  begin
    SetParametrValue(Data.TableSaleOrderDet.FieldByName('Code').AsString,
                     Data.TableSaleOrderDet.FieldByName('Brand').AsString,
                     Data.TableSaleOrderDet.FieldByName('Description').AsString,
                     Data.TableSaleOrderDet.FieldByName('Price').AsString,
                     CheckNeedMult(Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger,
                                   Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
                                   Data.CatalogDataSource.DataSet.FieldByName('SubGroup_id').AsInteger,
                                   Data.CatalogDataSource.DataSet.FieldByName('Mult').AsInteger),
                     Data.TableSaleOrderDet.FieldByName('Id').AsInteger);
    EdQuantity.ReadOnly := FALSE;
    EdPrice.ReadOnly := FALSE;
    EdPrim.TabOrder := 0;
    EdPrim.Text := Data.TableSaleOrderDet.FieldByName('Comments').AsString;
    ShowModal;
  end;
  Data.TableSaleOrder.Refresh;
end;

procedure TMain.SaleOrderGridDetKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    with Data.TableSaleOrderDet do
    begin
      if FieldByName('ID').AsInteger<1 then
        Exit;

      if not CheckDocumentEnabled(DelSaleOrder) then
        Exit;

      if MessageDlg('Удалить позицию из списка?',mtInformation,[mbYes,mbNo],0) = mrNo then
        exit;
       Delete;
       Data.TableSaleOrder.Refresh;
    end;
  end;
end;

procedure TMain.SaleOrderGridDetTitleClick(Column: TColumnEh);
begin
  if not Column.Title.TitleButton then
    exit;


  if Data.TableSaleOrderDet.IndexName = Column.FieldName then
  begin
    Data.TableSaleOrderDet.IndexName := 'D'+Column.FieldName;
    Column.Title.SortMarker := smUpEh;
    exit;
  end;

  if Data.TableSaleOrderDet.IndexName = 'D'+Column.FieldName then
  begin
    Data.TableSaleOrderDet.IndexName := Column.FieldName;
    Column.Title.SortMarker := smDownEh;
    exit;
  end;

  Data.TableSaleOrderDet.IndexName := Column.FieldName;
  Column.Title.SortMarker := smDownEh;
end;

procedure TMain.SaleOrderStartChange(Sender: TObject);
begin
  Data.TableSaleOrder.SetRange([SaleOrderStart.Date], [SaleOrderEnd.Date]);
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
    if Data.ParamTable.FieldByName('Cli_ID').AsInteger < 1 then
    begin
      MessageDlg('Не выбран клиент по умолчанию!', mtInformation, [MBOK],0);
      exit;
    end;
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

procedure TMain.SaveDocLimitExecute(Sender: TObject);
var
  sFileName: string;
begin
    if Data.TableDocLimitDet.RecordCount < 1 then
      exit;

    with Data.TableDocLimit do
      begin
          if FieldByName('DocLimitID').AsInteger < 1 then
            exit;
          if FieldByName('State').AsString > '0' then
            begin
              with createmessagedialog('Возможно документ уже отправлялся! Продолжить?',mtInformation,[mbYes,mbNo],mbNo) do
              begin
                if ShowModal = mrNo then
                  exit;
              end;
              sFileName := DateTimeToStr(Now)+'_.csv';
              sFileName := ReplaceStr(sFileName, ':','_');
              sFileName :=Data.Export_path+'Лимиты_'+sNameGlobalBase+'_'+Data.TableDocLimit.FieldByName('Date').AsString+'_Повтор_'+sFileName;

            end
          else
          begin
            sFileName :=Data.Export_path+'Лимиты_'+sNameGlobalBase+'_'+Data.TableDocLimit.FieldByName('Date').AsString+'.csv';
          end;
      end;


    with SaveOrderDialog do
      begin
       InitialDir := Data.Export_path;
       FileName   := sFileName;
       if not Execute then
         exit;
       sFileName := FileName;
      end;

    Memo.Lines.Clear;
    with Data.TableDocLimitDet do
      begin
          First;
          while not Data.TableDocLimitDet.Eof do
          begin
             if Data.TableDocLimit.FieldByName('DocLimitID').AsInteger = FieldByName('DocLimitID').AsInteger then
                Memo.Lines.Add(FieldByName('Code').AsString+'_'+FieldByName('Brand').AsString+';'+FieldByName('NewValue').AsString+';'+sNameGlobalBase+';');
                Next;
          end;
      end;
      Memo.Lines.SaveToFile(sFileName);
      with Data.TableDocLimit do
      begin
          Edit;
          FieldByName('State').Value := 2;
          Post;
      end;
end;

(*
procedure TMain.LoadOrderTCP;
var
  fname, subj, email, s, fn: string;
  F: TextFile;
  TCPClientTest: TIdTCPClient;
  Path:string;
  OdrderID:string;
  DetailCode:string;
  BrandName:string;
  Quants:string;
  SQL,SQLValue:string;
  iSQL:integer;
  fieldName: TField;
  iPos:string;
  aPrice1, aPrice2: string;
  list:TStringList;
  aCurrName1, aCurrName2: string;
  anOldDoc: Boolean;
  UserData: TUserIDRecord;
  aNewDiscVer: Integer;
  aLotusNumber: string;

  //od: TOpenDialog; // тест нового формата - удалить!!!
begin
  if not CheckClientId then
    Exit;

  UserData := GetCurrentUser;

  if not UserData.bUpdateDisc then
    if LoadDescriptionsTCP(ReplaceLeftSymbol(UserData.sId), ReplaceLeftSymbolAB(UserData.sKey), inttostr(UserData.DiscountVersion), aNewDiscVer) > 0 then
      UpdateUserData(UserData);

  anOldDoc := False;
  aCurrName1 := '';
  aCurrName2 := '';
  Path := GetAppDir + 'Импорт\';
  with Data.OrderTable do
  begin

    if ((FieldByName('Sent').AsString = '')or(FieldByName('Sent').AsString = '0')) then
    begin
        MessageDlg('Невозможно получить ответ! Заказ не отсылался!', mtInformation, [mbOK], 0);
        exit;
    end;

    subj := FieldByName('cli_id').AsString + '_' +  FieldByName('Sign').AsString;
    OdrderID := FieldByName('Order_id').AsString;
  end;

// тест нового формата - откомментить!!!

  TCPClientTest := TIdTCPClient.Create(nil);
  DeleteFile(Path+'Zameny_'+subj+'.csv');
  DeleteFile(Path+'Zakazano_'+subj+'.csv');

  //with Data.Client

  
 with TCPClientTest do
     try
     ConnectTimeout := 3000;
     ReadTimeout := 3000;

     try
      Host := Data.SysParamTable.FieldByName('Host').AsString;
      TCPClientTest.Port := Data.SysParamTable.FieldByName('PortIn').AsInteger;
      Connect;
      except
      try
      Host := Data.SysParamTable.FieldByName('BackHost').AsString;
      TCPClientTest.Port := Data.SysParamTable.FieldByName('PortIn').AsInteger;
      Connect;
      except
        Host := Data.SysParamTable.FieldByName('TCPHost3').AsString;
        Port := Data.SysParamTable.FieldByName('PortIn').AsInteger;
        Connect;
      end;
      end;

      try
        email := 'TEST_'+subj;
        TCPClientTest.IOHandler.Writeln(email);
        email := TCPClientTest.IOHandler.ReadLnWait;
        if(email = 'END') then
        begin
            MessageDlg('Заявка еще не обработана. Повторите попытку позже.', mtInformation, [mbOK], 0);
            TCPClientTest.Disconnect;
            exit;
        end;
        while email <> 'END' do
        begin
            if email = 'FILE' then
               begin
               email := TCPClientTest.IOHandler.ReadLnWait;
               AssignFile(F, Path+email);
               Rewrite(F);
               end
            else
               if email = 'ENDFILE' then
                 begin
                 CloseFile(F);
                 end
               else
                begin
                  System.Writeln(F, email);
                end;
            email := TCPClientTest.IOHandler.ReadLnWait;
        end;
      finally

        TCPClientTest.Disconnect;
      end;
    except
      on e: EIdException do
      begin
        MessageDlg('Ошибка соединения: ' + e.Message, mtError, [mbOK], 0);
        exit;
      end;
      on e: Exception do
      begin
        MessageDlg('Ошибка: ' + e.Message, mtError, [mbOK], 0);
        exit;
      end;

  end;

//----------------

    QueryLoadOrderISAM.SQL.Clear;
    QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET ORDERED = -1 WHERE Order_id = '+OdrderID);
    QueryLoadOrderISAM.ExecSQL;
    QueryLoadOrderISAM.Close;

    Data.OrderTable.Edit;
    Data.OrderTable.FieldByName('Sent').AsInteger := 2;
    Data.OrderTable.Post;
    Data.OrderTable.Refresh;

    list:=TStringList.Create;
    fname := Path+'Zakazano_'+subj+'.csv';



// тест нового формата - удалить!!!
{
  list:=TStringList.Create;
  od := TOpenDialog.Create(Application);
  try
    od.InitialDir := GetAppDir + 'Экспорт\';
    if od.Execute then
      fname := od.FileName
    else
      Exit;
  finally
    od.Free;
  end;
}
//---------------------------------

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
      exit;
    end;

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
      BrandName:= StrLeft(s,StrFind(s,';')-1);
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
        QueryLoadOrderISAM.SQL.Add('SELECT * FROM [010] WHERE Code2 = '''+DetailCode+''' AND Brand = '''+BrandName+''' AND Quantity = '+Quants+' AND  Order_id = '+OdrderID);
        QueryLoadOrderISAM.Active := TRUE;
        if QueryLoadOrderISAM.FieldByName('Order_id').AsInteger > 0 then
          begin
            QueryLoadOrderISAM.Close;
            QueryLoadOrderISAM.SQL.Clear;
            QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET ORDERED = 1 WHERE Code2 = '''+DetailCode+''' AND Brand = '''+BrandName+''' AND Quantity = '+Quants+' AND  Order_id = '+OdrderID);
            QueryLoadOrderISAM.ExecSQL;
          end
         else
          begin
             QueryLoadOrderISAM.Close;
             QueryLoadOrderISAM.SQL.Clear;
             QueryLoadOrderISAM.SQL.Add('SELECT * FROM [010] WHERE Code2 = '''+DetailCode+''' AND Brand = '''+BrandName+''' AND Quantity > '+Quants+' AND  Order_id = '+OdrderID);
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
                  begin
                     SQL:= SQL + ', ' +fieldName.DisplayName;
                  end;
               end;

               SQL := StrRight(SQL,Length(SQL)-2);

               QueryLoadOrderISAM.Close;
               QueryLoadOrderISAM.SQL.Clear;
               QueryLoadOrderISAM.SQL.Add('INSERT INTO [010] ('+SQL+') SELECT '+SQL+' FROM [010] WHERE Code2 = '''+DetailCode+''' AND Brand = '''+BrandName+'''  AND  Order_id = '+OdrderID);
               QueryLoadOrderISAM.ExecSQL;

               QueryLoadOrderISAM.Close;
               QueryLoadOrderISAM.SQL.Clear;
               QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET Quantity = Quantity - '+Quants+' WHERE Code2 = '''+DetailCode+''' AND Brand = '''+BrandName+'''  AND  Order_id = '+OdrderID +' AND ID <> '+iPos);
               QueryLoadOrderISAM.ExecSQL;

               QueryLoadOrderISAM.Close;
               QueryLoadOrderISAM.SQL.Clear;
               QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET ORDERED = 1, Quantity = '+Quants+' WHERE Code2 = '''+DetailCode+''' AND Brand = '''+BrandName+'''  AND  Order_id = '+OdrderID +' AND ID = '+iPos);
               QueryLoadOrderISAM.ExecSQL;
              end;
         end;
       QueryLoadOrderISAM.Close;
      end;
      end;
    end;
     CloseFile(F);
    end;

    fname := Path+'Zameny_'+subj+'.csv';
    if FileExists(fname) then
    begin
    AssignFile(F, fname);
    Reset(F);
    Readln(F, s);
    while not System.Eof(F) do
    begin
      Readln(F, s);

      if(StrFind(S,';')>1)and(length(S)>0) then
      begin
      s:= StrRight(s,length(s)-StrFind(S,';'));
      Quants := StrLeft(s,StrFind(s,';')-1);
      s:=StrRight(s,Length(s)-Length(Quants)-1);



       while(StrFind(s,';') >-1) do
       begin
           s := StrRight(s,Length(s)-StrFind(s,';'));
       end;
       DetailCode := StrLeft(s,StrFind(s,'_')-1);
       s := StrRight(s,Length(s)-Length(DetailCode)-1);
       if(StrFind(s,';')>0)  then
         BrandName:= StrLeft(s,StrFind(s,';')-1)
       else
         BrandName:= s;
       DetailCode := Data.MakeSearchCode(DetailCode);

      s := StrRight(s,Length(s)-Length(DetailCode)-1);

      if Length(DetailCode) > 0 then
       begin
        QueryLoadOrderISAM.SQL.Clear;
        QueryLoadOrderISAM.SQL.Add('SELECT * FROM [010] WHERE Code2 ='''+DetailCode+''' AND Brand = '''+ BrandName +''' AND ORDERED = -1 AND  Order_id = '+OdrderID);
        QueryLoadOrderISAM.Active := TRUE;


        if QueryLoadOrderISAM.FieldByName('Order_id').AsInteger > 0 then
          begin
            QueryLoadOrderISAM.Close;
            QueryLoadOrderISAM.SQL.Clear;
            QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET ORDERED = 0 WHERE Code2 = '''+DetailCode+''' AND Brand = '''+ BrandName +''' AND ORDERED = -1 AND  Order_id = '+OdrderID);
            QueryLoadOrderISAM.ExecSQL;
          end;
        QueryLoadOrderISAM.Close;
      end;
      end;
     end;
     CloseFile(F);
    end;

    with TOrderAnswer.Create(Application) do
    try
      Init(List, aCurrName1, aCurrName2, aLotusNumber);
      ShowModal;
    finally
      Free;
    end;
    list.Free;
    Data.OrderDetTable.Refresh;
end;
*)

//загружает TCP-ответ по заказу и ложит его в блоб
function TMain.LoadOrderTCP1: Boolean;

  function CheckOrder(aHandler: TIdIOHandler; aClientID, aOrderNum: string): Boolean;
  var
    s, aFileName: string;
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
    if not DoTcpConnect(TCPClientTest) then
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

function TMain.LoadOrderTCP1_emul: Boolean;
begin
  Data.OrderTable.Edit;
  if FileExists(GetAppDir + 'test\Zakazano.csv') then
    TBlobField(Data.OrderTable.FieldByName('TcpAnswer')).LoadFromFile(GetAppDir + 'test\Zakazano.csv')
  else
    Data.OrderTable.FieldByName('TcpAnswer').AsVariant := NULL;

  if FileExists(GetAppDir + 'test\Zameny.csv') then
    TBlobField(Data.OrderTable.FieldByName('TcpAnswerZam')).LoadFromFile(GetAppDir + 'test\Zameny.csv')
  else
    Data.OrderTable.FieldByName('TcpAnswerZam').AsVariant := NULL;

  Data.OrderTable.FieldByName('Sent').AsString := '4';

  Data.OrderTable.Post;

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
  list:TStringList;
  aCurrName1, aCurrName2: string;
  anOldDoc: Boolean;
  aLotusNumber: string;

  aStream: TMemoryStream;
  ZakazanoFileName, ZamenyFileName: string;
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

    if not FieldByName('TcpAnswer').IsNull then
    begin
      aStream := TMemoryStream.Create;
      try
        //{EMUL}
        TBlobField(FieldByName('TcpAnswer')).SaveToFile(Path + ZakazanoFileName);
        //TBlobField(FieldByName('TcpAnswer')).SaveToStream(aStream);
        //UnzipStream2File(aStream, Path + ZakazanoFileName, ZakazanoFileName);
        //{EMUL}
      finally
        aStream.Free;
      end;
    end;

    if not FieldByName('TcpAnswerZam').IsNull then
    begin
      aStream := TMemoryStream.Create;
      try
        //{EMUL}
        TBlobField(FieldByName('TcpAnswerZam')).SaveToFile(Path + ZamenyFileName);
        //TBlobField(FieldByName('TcpAnswerZam')).SaveToStream(aStream);
        //UnzipStream2File(aStream, Path + ZamenyFileName, ZamenyFileName);
        //{EMUL}
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

  anOldDoc := False;
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
      exit;
    end;

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
        QueryLoadOrderISAM.SQL.Add('SELECT * FROM [010] WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+''' AND Quantity = '+Quants+' AND  Order_id = '+OdrderID);
        QueryLoadOrderISAM.Active := TRUE;
        if QueryLoadOrderISAM.FieldByName('Order_id').AsInteger > 0 then
          begin
            QueryLoadOrderISAM.Close;
            QueryLoadOrderISAM.SQL.Clear;
            QueryLoadOrderISAM.SQL.Add('UPDATE [010] SET ORDERED = 1 WHERE Code2 = '''+DetailCode+''' AND Upper(Brand) = '''+BrandName+''' AND Quantity = '+Quants+' AND  Order_id = '+OdrderID);
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
                  begin
                     SQL:= SQL + ', ' +fieldName.DisplayName;
                  end;
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
    end;
     CloseFile(F);
    end;

    fname := Path + ZamenyFileName;
    if FileExists(fname) then
    begin
    AssignFile(F, fname);
    Reset(F);
    Readln(F, s);
    while not System.Eof(F) do
    begin
      Readln(F, s);

      if(StrFind(S,';')>1)and(length(S)>0) then
      begin
      s:= StrRight(s,length(s)-StrFind(S,';'));
      Quants := StrLeft(s,StrFind(s,';')-1);
      s:=StrRight(s,Length(s)-Length(Quants)-1);



       while(StrFind(s,';') >-1) do
       begin
           s := StrRight(s,Length(s)-StrFind(s,';'));
       end;
       DetailCode := StrLeft(s,StrFind(s,'_')-1);
       s := StrRight(s,Length(s)-Length(DetailCode)-1);
       if(StrFind(s,';')>0)  then
         BrandName:= StrLeft(s,StrFind(s,';')-1)
       else
         BrandName:= s;
       BrandName:= AnsiUpperCase(BrandName);
       DetailCode := Data.MakeSearchCode(DetailCode);

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
     CloseFile(F);
    end;

    with TOrderAnswer.Create(Application) do
    try
      Init(List, aCurrName1, aCurrName2, aLotusNumber);
      ShowModal;
    finally
      Free;
    end;
    list.Free;
    Data.OrderDetTable.Refresh;
end;


function TMain.LoadOrderStatus: Boolean;

  function CheckOrderStatus(aHandler: TIdIOHandler; aClientID, aOrderNum: string): Integer;
  var
    s: string;
  begin
    Result := 0;
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
  TCPClientTest := TIdTCPClient.Create(nil);
  try
    if not DoTcpConnect(TCPClientTest) then
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
    s, aFileName: string;
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
    if not DoTcpConnect(TCPClientTest) then
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
procedure TMain.ApplyRetdocAnswer;
var
  fname, subj, email, s, fn: string;
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
  aLotusNumber: string;

  aStream: TMemoryStream;
  ZakazanoFileName: string;
  post: string;
begin
  Path := GetAppDir + 'Импорт\';
  with Data.ReturnDocTable do
  begin                                             
    if (FieldByName('Retdoc_id').AsInteger = 0) or (FieldByName('Post').AsString <> '4') then
      Exit;

    subj := FieldByName('cli_id').AsString + '_' +  FieldByName('Sign').AsString;
    RetDocID := FieldByName('Retdoc_id').AsString;

    ZakazanoFileName := 'Zakazano_' + subj + '.csv';

    if not fPostOrder then
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

  anOldDoc := False;
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
      exit;
    end;

    aCurrName1 := ExtractDelimited(5,  s, [';']);
    aCurrName2 := ExtractDelimited(6,  s, [';']);
    post := ExtractDelimited(7,  s, [';']);
    if post = '' then
      post := '2';
    if (post = '1') then
    begin
      WritePost(3);
      Exit;
    end;
    if (post = '5') then
    begin
      WritePost(6);
      Exit;
    end
    else  if (post <> '1') and (post <> '5') and not fPostOrder then
    begin
      WritePost(4);
      Exit;
    end;

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
                  begin
                     SQL:= SQL + ', ' +fieldName.DisplayName;
                  end;
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
      end;
      end;
    end;
     CloseFile(F);

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
    fPostOrder := false;
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
  BufferLen, fSize: LongWord;
  f: File;
  szHeaders: string;
  OpenFlags: DWORD;
begin
  {

  }
  DeleteFile(sFileName);
  OpenFlags := INTERNET_FLAG_RELOAD or INTERNET_FLAG_NO_CACHE_WRITE
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
      fSize := 0;
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
          with TStringList.Create do
          begin
          Text :=  E.Message;
          SaveToFile(GetAppDir + '!!!.err');
          Free;
          end;
          exit;
          end;
    end;
  end;
  MainDownLoadFile := TRUE;
 end;


function TMain.MainDownLoadFileMirrors(aDestFileName: string; IsExtUpdate: Boolean; aUrlDir: string): Boolean;
var
  i: Integer;
  aMirrorUrl, aTryServer: string;
  aServers: TStrings;
begin
  Result := False;

  aServers := TStringList.Create;
  try
    GetUpdateServersList(aServers);

    for i := 0 to aServers.Count - 1 do
    begin
      aTryServer := aServers[i];
      if aUrlDir <> '' then
      begin
        if aTryServer[Length(aTryServer)] <> '/' then
          aTryServer := aTryServer + '/';
        if aUrlDir[1] = '/' then
          Delete(aUrlDir, 1, 1);

        aTryServer := aTryServer + aUrlDir;
      end;

      aMirrorUrl := Data.BuildUpdateUrl(aTryServer, True, IsExtUpdate); //with proxy args
      Result := MainDownLoadFile(aMirrorUrl, aDestFileName);
      if Result then
      begin
        fCurrentWorkingServer := aTryServer;
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
  upd_url, url, sFile: string;
  iniUpdateFile: TIniFile;
  path: string;
{    iFile:integer;
    sLoadFile,localversion, customversion:string;
    f:TextFile;
    bWindow:Boolean;
    UpdateFileData:TUpdateFileData;   }

  UserData: TUserIDRecord;
  aNewDiscVer: Integer;
begin
  if fAutoUpdateLocked then
    Exit;

  //во время обновления не проверяем следующее  
  if Assigned(UpdateThrd) or (not bTerminate) then
  begin
//    MessageDlg('В данный момент уже устанавливается обновление.'#13#10 +
//               'Дождитесь завершения и повторите попытку.', mtInformation, [mbOK], 0);
    Exit;
  end;

  //закончен срок действия программы - блокируем автообновления - работаем через форму проверки версий
  if (CheckProgrammPeriod <> 0) and not CheckIsServiceOrdered then
    Exit;




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

//#new
procedure TMain.UnlockDocLimitActionExecute(Sender: TObject);
begin
  if UnlockDocument(Data.TableDocLimit) then
    Data.TableDocLimitAfterScroll(Data.TableDocLimit);
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

//#new
procedure TMain.UnlockSaleOrderExecute(Sender: TObject);
begin
  if UnlockDocument(Data.TableSaleOrder) then
    Data.TableSaleOrderAfterScroll(Data.TableSaleOrder);
end;

//#new
procedure TMain.UnlockSaleReturnDocExecute(Sender: TObject);
begin
  if UnlockDocument(Data.TableReturnDoc) then
    Data.TableReturnDocAfterScroll(Data.TableReturnDoc);
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

function TMain.UnzipStream2File(aStreamIn: TStream; const aFileOut, aFileName,
  aPassword: string): Boolean;
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
var  itog:Currency;
     iFindPos:integer;
begin

   iFindPos:=StrFind(s,',');
   if iFindPos>0 then
   begin
       s := StrLeft(s,iFindPos-1)+'.'+strRight(s,length(s)-iFindPos);
   end;

   itog := 0.0;
   try
     itog := StrToCurr(s);
   except
   begin
     iFindPos:=StrFind(s,'.');
     if iFindPos>0 then
     begin
       s := StrLeft(s,iFindPos-1)+','+strRight(s,length(s)-iFindPos);
     end;

     try
       itog := StrToCurr(s);
     except
       itog := -1;
     end;
   end;
   end;
   AToCurr := itog;
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
    ShowProgrInfo('Обновление успешно установлено');
end;

procedure TMain.PostMessageFinished(var Msg: TMessage);

  procedure DeleteUpdateTables;
  begin
    Data.RemoveTableFromBase(Data.SysParamTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.BrandTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.GroupTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.GroupBrandTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.CatalogTable.TableName + '_New');
    //Data.RemoveTableFromBase(Data.AnalogTable.TableName + '_New');
    //Data.RemoveTableFromBase(Data.OETable.TableName + '_New');
    Data.RemoveTableFromBase(Data.TableCarFilter.TableName + '_New');
    Data.RemoveTableFromBase(Data.QuantTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.ArtTypTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.KitTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.OOTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.DescriptionTable.TableName + '_New');

    Data.RemoveTableFromBase(Data.AnalogIDTable.TableName + '_New');
    Data.RemoveTableFromBase(Data.AnalogMainTable_1.TableName + '_New');
    Data.RemoveTableFromBase(Data.AnalogMainTable_2.TableName + '_New');
    Data.RemoveTableFromBase(Data.AnalogMainTable_3.TableName + '_New');
    Data.RemoveTableFromBase(Data.AnalogMainTable_4.TableName + '_New');
    Data.RemoveTableFromBase(Data.AnalogMainTable_5.TableName + '_New');
  end;


    procedure TableNewToBase(aTable: TDBISAMTable);
    begin
      if FileExists(Data.Data_Path + aTable.TableName + '_New.1') then
      begin
        aTable.Active := FALSE;
        aTable.DisableControls;
        Data.RenameTableDBI(aTable.TableName,aTable.TableName + '_Back');
        Data.RenameTableDBI(aTable.TableName + '_New',aTable.TableName);
      end;
    end;

    procedure TableBackToBase(aTable: TDBISAMTable);
    begin
      if FileExists(Data.Data_Path + aTable.TableName + '_Back.1') then
      begin
      //  aTable.Active := FALSE;
      //  aTable.DisableControls;
        Data.RemoveTableFromBase(aTable.TableName);
        Data.RenameTableDBI(aTable.TableName + '_Back', aTable.TableName);
      end;
    end;

  procedure ApplyUpdateTables_Catalog(aWithQuants: Boolean);
  begin
    Data.AllClose;
    Data.CatalogDataSource.DataSet.AfterScroll := nil;

    TableNewToBase(Data.TableCarFilter);
    TableNewToBase(Data.SysParamTable);
    TableNewToBase(Data.BrandTable);
    TableNewToBase(Data.GroupTable);
    TableNewToBase(Data.GroupBrandTable);
    TableNewToBase(Data.CatalogTable);
    //TableNewToBase(Data.AnalogTable);
    //TableNewToBase(Data.OETable);
    TableNewToBase(Data.AnalogIDTable);
    TableNewToBase(Data.AnalogMainTable_1);
    TableNewToBase(Data.AnalogMainTable_2);
    TableNewToBase(Data.AnalogMainTable_3);
    TableNewToBase(Data.AnalogMainTable_4);
    TableNewToBase(Data.AnalogMainTable_5);
    TableNewToBase(Data.OEIDTable);
    TableNewToBase(Data.OEDescrTable);

    TableNewToBase(Data.ArtTypTable);
    TableNewToBase(Data.KitTable);
    TableNewToBase(Data.OOTable);
    TableNewToBase(Data.DescriptionTable);
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
       // TableBackToBase(Data.AnalogTable);
       // TableBackToBase(Data.OETable);
{        if aWithQuants then
          TableBackToBase(Data.QuantTable);}

        TableBackToBase(Data.AnalogIDTable);
        TableBackToBase(Data.AnalogMainTable_1);
        TableBackToBase(Data.AnalogMainTable_2);
        TableBackToBase(Data.AnalogMainTable_3);
        TableBackToBase(Data.AnalogMainTable_4);
        TableBackToBase(Data.AnalogMainTable_5);
        TableBackToBase(Data.OEIDTable);
        TableBackToBase(Data.OEDescrTable);

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
    Data.RemoveTableFromBase(Data.AnalogTable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.OETable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.TableCarFilter.TableName + '_Back');
{    if aWithQuants then
      Data.RemoveTableFromBase(Data.QuantTable.TableName + '_Back');}
    Data.RemoveTableFromBase(Data.ArtTypTable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.KitTable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.OOTable.TableName + '_Back');
    Data.RemoveTableFromBase(Data.DescriptionTable.TableName + '_Back');

    Data.Ign_chars := Data.SysParamTable.FieldByName('Ign_chars').AsString;

    Data.LoadTree;
    Data.CatalogDataSource.DataSet.AfterScroll := Data.CatalogTableAfterScroll;
  end;

  procedure ApplyUpdateTables_Quants;
  begin
//    if TestString(Data.VersionTable.FieldbyName('QuantVersion').AsString, NewQuantVersion) then
      if FileExists(Data.Data_Path + Data.QuantTable.TableName +'_New.1') then
      begin
        Data.LoadingLock;
        try
          Data.QuantTable.Close;
          Data.RenameTableDBI(Data.QuantTable.TableName, Data.QuantTable.TableName + '_Back');
          Data.RenameTableDBI(Data.QuantTable.TableName + '_New', Data.QuantTable.TableName);
          Data.QuantTable.Open;
          
          Data.sIDs := sIDs;
          Data.sLatestIDs := sLatestIDs;
          if NewQuantVersion <> '' then
          begin
            Data.VersionTable.Edit;
            Data.VersionTable.FieldbyName('QuantVersion').Value := NewQuantVersion;
            Data.VersionTable.Post;
            CurrQuantVersion := NewQuantVersion;
          end;
          Data.RemoveTableFromBase(Data.QuantTable.TableName + '_Back');
        finally
          Data.LoadingUnlock;
        end;

        Data.CalcWaitList;
        Data.CatalogDataSource.Dataset.Refresh;
        Data.SetCatFilter; //для обновления если стоял фильтр по остаткам
      end;
  end;

  procedure ApplyUpdateTables_QuantsStock(const aQuantsNum: string; const aNewVersion: string);
  var
    aNumBase: string;
    aDestTable: TDBISamTable;
  begin
    aNumBase := Copy(aQuantsNum, 7, MaxInt);
//  aDestTable := TDBISamTable(Data.FindComponent('QuantTable' + aNumBase));
    aDestTable := TDBISamTable(Data.FindComponent('SkladQuants'));

    if FileExists(Data.Data_Path + aDestTable.TableName +'_New.1') then
    begin
      aDestTable.Close;
      Data.RenameTableDBI(aDestTable.TableName, aDestTable.TableName + '_Back');
      Data.RenameTableDBI(aDestTable.TableName + '_New', aDestTable.TableName);
      aDestTable.Open;

      if aNewVersion <> '' then
      begin
        Data.VersionTable.Edit;
        Data.VersionTable.FieldbyName(aQuantsNum).Value := aNewVersion;
        Data.VersionTable.Post;
      end;
      Data.RemoveTableFromBase(aDestTable.TableName + '_Back');
    end;

  end;

  procedure ApplyUpdateTables_Tires;
  var
    s: string;
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
  var
    s: string;
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
    s: string;
  begin
    if NewPictsVersion <> '' then
    begin
      s := Data.VersionTable.FieldbyName('PictsVersion').AsString;
      if POS(NewPictsVersion, s) = 0 then
      begin
        Data.VersionTable.Edit;
        Data.VersionTable.FieldbyName('PictsVersion').Value := AppendVersion(s, NewPictsVersion, Data.VersionTable.FieldbyName('PictsVersion').Size);
        Data.VersionTable.Post;
      end;
      Data.PictTable.Close;
      Data.PictTable.Open;
    end;
  end;

var
  i: Integer;
  anUpdateResult: TUpdateResult;
  aSchedulerState: Boolean;
  aQuantStockVersion, aQuantsNum: string;
begin
  aQuantsNum := ExtractFileName(Data.OpenZipDialog.FileName);
  Delete(aQuantsNum ,pos('.',aQuantsNum),4);

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
      ShowUpdateReport(anUpdateResult, fUpdateQueue);
      Application.ProcessMessages;
    end;

    if not (anUpdateResult in [urFully, urPartially]) then
      Exit;

    StartWait;
    if fUpdateQueue.PackageInstalled(wupQuantsStock) then
      Data.LoadingLock;
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
            
            wupQuantsStock:
            begin
              if fUpdateQueue[i].NewVersions.Count > 0 then
                aQuantStockVersion := fUpdateQueue[i].NewVersions[0]
              else
                aQuantStockVersion := '';
              if SameText(fUpdateQueue[i].PackageTypeCode,'quantsXX') then
                ApplyUpdateTables_QuantsStock(aQuantsNum, aQuantStockVersion)
              else
                ApplyUpdateTables_QuantsStock(fUpdateQueue[i].PackageTypeCode{quantXX}, aQuantStockVersion)
            end;

            wupPictsDiscret:
            begin
              if fUpdateQueue[i].NewVersions.Count > 0 then
                NewPictsVersion := fUpdateQueue[i].NewVersions[0];
              ApplyUpdateTables_Picts;
            end;

            wupTires:
            begin
              if fUpdateQueue[i].NewVersions.Count > 0 then
                NewTiresVersion := fUpdateQueue[i].NewVersions[0];
              ApplyUpdateTables_Tires;
            end;

            wupTyp:
            begin
              if fUpdateQueue[i].NewVersions.Count > 0 then
                NewTypVersion := fUpdateQueue[i].NewVersions[0];
              ApplyUpdateTables_Typ;
            end;

          end;
        end;

      //после установки всех остатков по рынкам
      if fUpdateQueue.PackageInstalled(wupQuantsStock) then
      begin
      //  Data.CreateQuantsLookup; //пересоздаем объединенную таблицу остатков
        Data.CatalogDataSource.Dataset.Refresh; //делаем рефреш один раз если ставилось много пакетов с остатками
        //Data.SetCatFilter; //для обновления если стоял фильтр по остаткам
      end;

    finally
      if fUpdateQueue.PackageInstalled(wupQuantsStock) then
        Data.LoadingUnLock;
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
                  +FieldByName('Data').AsString+';1;'+FieldByName('Quantity').AsString);
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
 else
  AllPost;
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
   GetErrorMessage := 'Ошибка №'+inttostr(fSize)+' - '+FErrorString;
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

procedure TMain.GridDocReturnDetDblClick(Sender: TObject);
begin
  with TAddToReturnDocWindow.Create(Application) do
  begin
    SetParametrValue(
      Data.TableReturnDocDet.FieldByName('Code').AsString,
      Data.TableReturnDocDet.FieldByName('Brand').AsString,
      Data.TableReturnDocDet.FieldByName('Description').AsString,
      Data.TableReturnDocDet.FieldByName('Comments').AsString,
      Data.TableReturnDocDet.FieldByName('Col').AsString,
      Data.TableReturnDocDet.FieldByName('Price').AsString,
      CheckNeedMult(Data.CatalogDataSource.DataSet.FieldByName('Brand_id').AsInteger,
                    Data.CatalogDataSource.DataSet.FieldByName('Group_id').AsInteger,
                    Data.CatalogDataSource.DataSet.FieldByName('SubGroup_id').AsInteger,
                    Data.CatalogDataSource.DataSet.FieldByName('Mult').AsInteger),
      Data.TableReturnDocDet.FieldByName('ID').AsInteger
    );
    EdPrice.Enabled := False;
    btOrdersInfo.Enabled := False;
    EdQuantity.Enabled := False;
    EdPrim.TabOrder := 0;
    ShowModal;
  end;
  Data.TableReturnDoc.Refresh;
end;

procedure TMain.GridDocReturnDetKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    with Data.TableReturnDocDet do
    begin
      if FieldByName('ID').AsInteger<1 then
        exit;

      if not CheckDocumentEnabled(DelSaleReturnDoc) then
        Exit;

      if MessageDlg('Удалить позицию из списка?',mtInformation,[mbYes,mbNo],0) = mrNo then
        exit;
      Delete;
    end;
    Data.TableReturnDoc.Refresh;
  end;
end;

procedure TMain.GridDocReturnDetTitleClick(Column: TColumnEh);
begin
  if not Column.Title.TitleButton then
    exit;

  if Data.TableReturnDocDet.IndexName = Column.FieldName then
  begin
    Data.TableReturnDocDet.IndexName := 'D'+Column.FieldName;
    Column.Title.SortMarker := smUpEh;
    exit;
  end;

  if Data.TableReturnDocDet.IndexName = 'D'+Column.FieldName then
  begin
    Data.TableReturnDocDet.IndexName := Column.FieldName;
    Column.Title.SortMarker := smDownEh;
    exit;
  end;

  Data.TableReturnDocDet.IndexName := Column.FieldName;
  Column.Title.SortMarker := smDownEh;
end;

procedure TMain.GridReturnDocDblClick(Sender: TObject);
begin
  EditSaleReturnDoc.Execute;
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
  i,pos : integer;
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

  if Data.ReturnMasChek.Count <> 0 then
  begin
    if (Data.ReturnDocDetTable.FieldByName('Id').AsInteger <> 0) and
       (MessageDlg('Удалить выбранные позиции (' + IntToStr(Data.ReturnMasChek.Count) + ' шт.)?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      for i := 0 to Data.ReturnMasChek.Count - 1 do
      begin
        data.ReturnDocDetTable.Locate('ID', Integer(data.ReturnMasChek.Items[i]), []);
        Data.ReturnDocDetTable.Delete;
        pos :=  Data.ReturnDocDetTable.RecNo;
      end;
    Data.ReturnDocTableBeforeScroll(Data.ReturnDocDataSource.DataSet);
  end
  else
  if (Data.ReturnDocDetTable.FieldByName('RetDoc_ID').AsInteger <> 0) and
     (MessageDlg('Удалить позицию из возврата?',
             mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    Data.ReturnDocDetTable.Delete;
    pos :=  Data.ReturnDocDetTable.RecNo;
  end;
  Data.ReturnDocDetTable.RecNo := pos - 1;
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
// проверяет версии и формирует список для закачки нужных пакетов (либо переадресует эти действия в форму TUpdatesWindows)
procedure TMain.DoAutoUpdateUpdate(var Msg: TMessage);
var
  tmp_path, upd_url, url, sFile: string;
  iniUpdateFile: TIniFile;
  iFile: Integer;
  sLoadFile, localversion, customversion: string;
  aDescretVersion: Integer;
  f: TextFile;
  bWindow, bUpdate: Boolean;
  UpdateFileData: TUpdateFileData;
  aSectionName: string;
  i, aIndex_data, aIndex_data_d, aIndex_quant: Integer;
begin
  TimerUpdate.Interval := cCheckUpdateInterval;
  TimerUpdate.Enabled := FALSE;
  if Msg.LParam = 0  then
  begin
    TimerUpdate.Enabled := TRUE;
    Exit;
  end;

  bWindow := False;
  try
    if not Data.SysParamTable.Active then
    begin
      TimerUpdate.Enabled := TRUE;
      Exit;
    end;

    ListParametrs := TList.Create;
    bUpdate := TRUE;
    sFile := Data.GetUpdateUrlDestFile;

    if MainDownLoadFileMirrors(sFile) then
    begin
//      AssignFile(f, Data.Import_Path + 'Update');
      tmp_path := Data.Import_Path;
//      Rewrite(f);
//      CloseFile(f);

      bWindow := False;
      iFile := 1;

      iniUpdateFile := TiniFile.Create(sFile);
      try
        while iniUpdateFile.ReadString('file'+inttostr(iFile), 'customversion','') <> '' do
        begin
          aSectionName := 'file' + IntToStr(iFile);
          if iniUpdateFile.ReadString(aSectionName, 'localversion','') = 'prog' then
            aSectionName := 'prog_s';

          if iniUpdateFile.ReadString(aSectionName, 'localversion', '') <> '' then
          begin
            localversion := iniUpdateFile.ReadString(aSectionName, 'localversion','');
            customversion := iniUpdateFile.ReadString(aSectionName, 'customversion','');
            aDescretVersion := iniUpdateFile.ReadInteger(aSectionName, 'DescretVersion', 0);

            if (localversion = 'prog') and (Data.ParamTable.FieldByName('bPasiveUpdateProg').AsBoolean) then
            begin
              if TestString(Data.VersionTable.FieldByName('ProgVersion').AsString,customversion) then
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
              if TestString(Data.VersionTable.FieldByName('QuantVersion').AsString,customversion) then
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
                end
                else
                begin
                  bWindow := TRUE;
                  Break;
                end;
              end;
            end;

            if (localversion = 'news') and (Data.ParamTable.FieldByName('bPasiveUpdateQuants').AsBoolean) and (not Data.fTecdocOldest) then
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

            if ((localversion = 'data') or (localversion = 'data_d')) and (Data.ParamTable.FieldByName('bPasiveUpdateProg').AsBoolean) and (not Data.fTecdocOldest) then
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
      //sklad >>
      //остатки по точкам
      if Data.ParamTable.FieldByName('bPasiveUpdateQuants').AsBoolean then
        DoWebUpdateStock(True);
      //<< sklad

      TimerUpdate.Enabled := TRUE;
      Exit;
    end;

    if bWindow then
    begin
      //upd_url := Data.GetUpdateUrl(False); //without proxy args
      upd_url := Data.BuildUpdateUrl(fCurrentWorkingServer, False); //without proxy args
      with TUpdatesWindows.Create(nil) do
      try
        if SetParametrs(Data.Import_Path, upd_url, True{aSilentMode}, False) then
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
      with TStringList.Create do
      try
        Text := E.Message;
        SaveToFile(GetAppDir + '!!!.err');
      finally
        Free;
      end;
      TimerUpdate.Enabled := TRUE;
      Exit;
    end;
  end;
end;

procedure TMain.DocLimitGridDetailDblClick(Sender: TObject);
begin
   if not CheckDocumentEnabled(DocLimitDelAction) then
     Exit;
     
   with TDocLimitWindow.Create(Application) do
   begin
         EdDescription.Text  :=  Data.TableDocLimitDet.FieldByName('Description').AsString;
         EdCode.Text := Data.TableDocLimitDet.FieldByName('Code').AsString;
         EdBrand.Text := Data.TableDocLimitDet.FieldByName('Brand').AsString;
         EdOldValue.Text := Data.TableDocLimitDet.FieldByName('OldValue').AsString;
         EdNewValue.Text := Data.TableDocLimitDet.FieldByName('NewValue').AsString;
         GlobalID := Data.TableDocLimitDet.FieldByName('DocLimitID').AsInteger;
         ShowModal;
     end;
end;

procedure TMain.DocLimitGridDetailKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_DELETE then
   begin
      with Data.TableDocLimitDet do
      begin
        if FieldByName('ID').AsInteger<1 then
          exit;
        if not CheckDocumentEnabled(DocLimitDelAction) then
          Exit;
        if MessageDlg('Удалить позицию из списка?',mtInformation,[mbYes,mbNo],0) = mrNo then
          exit;
        Delete;
      end;
   end;
end;

procedure TMain.DocLimitGridDetailTitleClick(Column: TColumnEh);
begin
  if not Column.Title.TitleButton then
    exit;


  if Data.TableDocLimitDet.IndexName = Column.FieldName then
   begin
      Data.TableDocLimitDet.IndexName := 'D'+Column.FieldName;
      Column.Title.SortMarker := smUpEh;
      exit;
   end;

   if Data.TableDocLimitDet.IndexName = 'D'+Column.FieldName then
   begin
      Data.TableDocLimitDet.IndexName := Column.FieldName;
      Column.Title.SortMarker := smDownEh;
      exit;
   end;

    Data.TableDocLimitDet.IndexName := Column.FieldName;
    Column.Title.SortMarker := smDownEh;
end;

procedure TMain.DocLimitStartAdvDateChange(Sender: TObject);
begin
  Data.TableDocLimit.SetRange([DocLimitStartAdvDate.Date], [DocLimitEndAdvDate.Date]);
end;

procedure TMain.DocReturnStartAdvDateChange(Sender: TObject);
begin
  Data.TableReturnDoc.SetRange([DocReturnStartAdvDate.Date], [DocReturnEndAdvDate.Date]);
end;

procedure TMain.ClearTestQuants;
begin
  if aTestQuantsFilled < 1 then
    Exit;
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

procedure TMain.CliChangeTimerTimer(Sender: TObject);
var
  UserData: TUserIDRecord;
  aNewDiscVer: Integer;
begin
  if Data.fDatabaseOpened then
  begin
    CliChangeTimer.Enabled := false;
    Data.OrderDetDataSource.DataSet.DisableControls;
    Data.OrderDataSource.DataSet := nil;
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
    Data.SetPriceKoef;
    ShowStatusbarInfo;
    Data.OrderDataSource.DataSet := Data.OrderTable;
    Data.OrderDetDataSource.DataSet.EnableControls;
  end;
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

procedure TMain.AllignToolBars;
begin
  if not fNeedAllignToolBars then //allign bars if ini-file has been reset
    Exit;
  FiltToolBar.Left := SearchToolBar.Left;
end;

procedure TMain.ChangeInterfaceForScladCurr(Curr: string);
var
  fCurrBYR: boolean;
begin
  fCurrBYR := not SameText(Curr,'BYR');
  //ReturnDocPage.TabVisible := fCurrBYR;
//  ReturnDocCliPage.TabVisible := fCurrBYR;
  //WaitListPage.TabVisible := fCurrBYR;
  AssortmentExpansionPage.TabVisible := fCurrBYR;

  AddAnToWaitListAction.Visible := fCurrBYR;
  MoveToListFromOrder.Visible := fCurrBYR;
  AllMoveToWaitList.Visible := fCurrBYR;

 // EmailOrderAction.Visible := fCurrBYR;
 // LoadOrderActionTCP.Visible := fCurrBYR;
  //AddToWaitListAction.Visible := fCurrBYR;
  AddAssortmentExpansion.Visible := fCurrBYR;
  //AddReturnPosAction.Visible := fCurrBYR;
  //AddToSaleOrder.Visible := fCurrBYR;
  AddAnToSaleOrder.Visible := fCurrBYR;
  //EmaleSaleOrder.Visible := fCurrBYR;
//  acApplyOrderAnswer.Visible := fCurrBYR;
  MainMenu.Items[2].Visible := fCurrBYR;
  Data.ColumnView.Edit;
  Data.ColumnView.FieldByName('Price_koef_usd').AsBoolean := TRUE;
  Data.ColumnView.Post;

  Data.SysParamTable.Edit;
  Data.SysParamTable.FieldByName('MaxDiscount').AsInteger := 25;
  Data.SysParamTable.Post;


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


 { Result := not (Data.ParamTable.FieldByName('Cli_id').AsInteger < 1);
  if not Result and aShowError then
    Application.MessageBox(
      'Не задан идентификатор клиента! Заполните "идентификатор клиента" (Настройки\Параметры программы\Основные)',
      'Внимание',
      MB_OK or MB_ICONWARNING
    );}
end;

function TMain.CheckTcpDDOS(aWaitTime: Cardinal; aRewriteCallTime: Boolean): Boolean;
begin
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
    []
  );

  Result := StrToIntDef(aCount, 0) > 0;
end;

function TMain.CheckNeedMult(brand_id, group_id, subgroup_id, Mult: integer): integer;
const
  sExcepBr_Gr_SubGr = '128;47;165/216;47;165/112;47;165/123;47;165/84;44;5';
var
  sBr_Gr_SubGr: string;
  foundPos: integer;
begin
  sBr_Gr_SubGr := IntToStr(brand_id) + ';' + IntToStr(group_id) + ';' + IntToStr(subgroup_id);
  if Pos(sBr_Gr_SubGr, sExcepBr_Gr_SubGr) > 0 then
    result := 1
  else
    result := Mult;
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
    end;
    Close;
  end;
end;

procedure TMain.LockAutoUpdate(aLock: Boolean);
begin
  fAutoUpdateLocked := aLock;
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
  if SameText(Column.FieldName, 'Quantity') then
  begin
    WithQuants.Checked := not WithQuants.Checked;
    WithQuantsClick(WithQuants);
  end;
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
var
  aQuery: TDBISAMQuery;
begin
  Result := '';
  aQuery := TDBISAMQuery.Create(nil);
  try
    aQuery.DatabaseName := Data.Database.DatabaseName;
    aQuery.SQL.Text :=
      ' SELECT Date, Num, Type FROM [009] ' +
      ' WHERE Order_id = ' + IntToStr(anOrderId);
    aQuery.Open;

    if not aQuery.Eof then
      Result := aQuery.FieldByName('Date').AsString + '  -  №' + aQuery.FieldByName('Num').AsString + '(' + aQuery.FieldByName('Type').AsString + ')';

    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;

function TMain.GetRetdocDescription(aRetdocId: Integer): string;
var
  aQuery: TDBISAMQuery;
begin
  Result := '';
  aQuery := TDBISAMQuery.Create(nil);
  try
    aQuery.DatabaseName := Data.Database.DatabaseName;
    aQuery.SQL.Text :=
      ' SELECT Data, Num, Type FROM [036] ' +
      ' WHERE Retdoc_id = ' + IntToStr(aRetdocId);
    aQuery.Open;

    if not aQuery.Eof then
      Result := aQuery.FieldByName('Data').AsString + '  -  №' + aQuery.FieldByName('Num').AsString + '(' + aQuery.FieldByName('Type').AsString + ')';

    aQuery.Close;
  finally
    aQuery.Free;
  end;
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

      //aData.Host1 := Data.SysParamTable.FieldByName('Host').AsString;
      aData.Host1 := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
      aData.Port1 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

      //aData.Host2 := Data.SysParamTable.FieldByName('BackHost').AsString;
      aData.Port2 := Data.SysParamTable.FieldByName('PortIn').AsInteger;
      aData.Host3 := Data.SysParamTable.FieldByName('TCPHost3').AsString;
      aData.Port3 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

      aData.ClientID := aUser.sId;
      aData.PrivateKey := aUser.sKey;
      aData.DiscountsVersion := aUser.DiscountVersion;

      (Sender as TTaskDiscounts).SetTaskData(aData);
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
  aQuery: TDBISAMQuery;
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

//      aData.Host1 := Data.SysParamTable.FieldByName('Host').AsString;
      aData.Host1 := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
      aData.Port1 := Data.SysParamTable.FieldByName('PortIn').AsInteger;
//      aData.Host2 := Data.SysParamTable.FieldByName('BackHost').AsString;
      aData.Port2 := Data.SysParamTable.FieldByName('PortIn').AsInteger;
      aData.Host3 := Data.SysParamTable.FieldByName('TCPHost3').AsString;
      aData.Port3 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

      aQuery := TDBISAMQuery.Create(nil);
      try
        aQuery.DatabaseName := Data.Database.DatabaseName;
        aQuery.SQL.Text :=
          ' SELECT Order_id, Cli_id, "Sign", Sent_time FROM [009] ' +
          ' WHERE "Sign" <> '''' AND Cli_id <> '''' AND (Sent = ''1'' OR Sent = ''3'') AND Sent_time IS NOT NULL ';
        aQuery.Open;
        i := 0;
        while not aQuery.Eof do
        begin
          //не опрашиваем устаревшие заказы
          anOrderAge := (Now() - aQuery.FieldByName('Sent_time').AsDateTime);
          if (anOrderAge >= 0) and (anOrderAge < cObsoleteOrderTime) then
          begin
            SetLength(aData.OrdersToCheck, i + 1);
            aData.OrdersToCheck[i].ID := aQuery.FieldByName('Order_id').AsInteger;
            aData.OrdersToCheck[i].ClientID := aQuery.FieldByName('Cli_id').AsString;
            aData.OrdersToCheck[i].OrderNum := aQuery.FieldByName('Sign').AsString;

            Inc(i);
          end;
          aQuery.Next;
        end;
        aQuery.Close;

        aQuery.SQL.Text :=
        ' SELECT RetDoc_ID, Cli_id, "Sign", Sent_time FROM [036] ' +
        ' WHERE "Sign" <> '''' AND Cli_id <> '''' AND (Post = 1 OR Post = 2) AND Sent_time IS NOT NULL ';
        aQuery.Open;
        i := 0;
        while not aQuery.Eof do
        begin
          //не опрашиваем устаревшие возвраты
          if (Now() - aQuery.FieldByName('Sent_time').AsDateTime) < cObsoleteOrderTime then
          begin
            SetLength(aData.RetdocToCheck, i + 1);
            aData.RetdocToCheck[i].ID := aQuery.FieldByName('RetDoc_ID').AsInteger;
            aData.RetdocToCheck[i].ClientID := aQuery.FieldByName('Cli_id').AsString;
            aData.RetdocToCheck[i].RetdocNum := aQuery.FieldByName('Sign').AsString;

            Inc(i);
          end;
          aQuery.Next;
        end;
        aQuery.Close;

      finally
        aQuery.Free;
      end;

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
  aQuery: TDBISamQuery;
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
    aQuery := TDBISAMQuery.Create(nil);
    try
      aQuery.DatabaseName := Data.Database.DatabaseName;
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
            aQuery.SQL.Text := ' UPDATE [009] SET Sent = ''4'', TcpAnswer = :TcpAnswer, TcpAnswerZam = :TcpAnswerZam WHERE Order_id = :Order_id ';
            aQuery.Params[0].LoadFromStream(aStreamZakazano, ftBlob);
            if aStreamZameny.Size > 0 then
              aQuery.Params[1].LoadFromStream(aStreamZameny, ftBlob)
            else
              aQuery.Params[1].AsBlob := '';//NULL
            aQuery.Params[2].AsInteger := StrToIntDef(IDs[i], 0);

            aQuery.ExecSQL;
            aQuery.Close;

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
            aQuery.SQL.Text := ' UPDATE [036] SET Post = 4, TcpAnswer = :TcpAnswer WHERE Retdoc_id = :Retdoc_id ';
            aQuery.Params[0].LoadFromStream(aStreamZakazano, ftBlob);
            aQuery.Params[1].AsInteger := StrToIntDef(IDs[i], 0);

            aQuery.ExecSQL;
            aQuery.Close;

            if aNotifyText <> '' then
              aNotifyText := aNotifyText  + #13#10;
            aNotifyText := aNotifyText + 'Получен ответ по возврату [ ' + GetRetdocDescription(StrToIntDef(IDs[i], 0)) + ' ]';
          end;
        end;

        Data.ReturnDocTable.Refresh;
      end;

      if aNotifyText <> '' then
        RaiseNotifyEvent(aNotifyText, 'Уведомление', netOrders);

    finally
      aStreamZakazano.Free;
      aStreamZameny.Free;
      IDs.Free;
      aQuery.Free;
    end;

  end;
end;

procedure TMain.Button2Click(Sender: TObject);
var
  aTaskRss: TTaskRss;
  aData: TRssTaskData;
begin
exit;
  ShowBallonInfoLink(Button2, 'hi, hello <a>Читать</a>', '2222', BallonLinkClick, 1);

  Exit;

  aTaskRss := TTaskRss.Create;
  aData.UseProxy := False;
  
  if not FileExists(Data.Data_Path + 'Latest.rss') then
    aData.RssLink := 'http://shate-m.by/ru/news/rss.html?count=30'
  else
    aData.RssLink := 'http://shate-m.by/ru/news/rss.html?count=20';

  aData.ImageDestDir := GetAppDir + 'thumbs\Rss\';
  if not DirectoryExists(aData.ImageDestDir) then
    ForceDirectories(aData.ImageDestDir);
  if not FileExists(aData.ImageDestDir + 'new_item.gif') then
    ImgRssNew.Picture.SaveToFile(aData.ImageDestDir + 'new_item.gif');
  if not FileExists(aData.ImageDestDir + 'shate.jpg') then
    ImgRssShate.Picture.SaveToFile(aData.ImageDestDir + 'shate.jpg');

  aTaskRss.SetTaskData(aData);
  aTaskRss.OnAfterEnd := TaskRssAfterEnd;
  aTaskRss.Start;
end;


procedure TMain.Button3Click(Sender: TObject);
type
  TRssNode = record
    DateAsDate: TDateTime;
    Date: string;
    Text: string;
    Image: string;
    Link: string;
  end;

  function EncodeRssNode(aNode: TXmlNode): TRssNode;
  var
    aFS: TFormatSettings;
  begin
    Result.Date := aNode.NodeByName('pubDate').ValueAsString;

    GetLocaleFormatSettings(-1{GetThreadLocale}, aFS);
    aFS.DateSeparator := '.';
    aFS.ShortDateFormat := 'dd.mm.yyyy';
    aFS.LongDateFormat := 'd MMMM yyyy';

    aFS.TimeSeparator := ':';
    aFS.ShortTimeFormat := 'HH:nn';
    aFS.LongTimeFormat := 'HH:nn:ss';

    Result.DateAsDate := StrToDateTime(Result.Date, aFS);
    Result.Date := FormatDateTime('dd.mm.yyyy HH":"nn', Result.DateAsDate);
    
    Result.Text := aNode.NodeByName('description').ValueAsString;
    Result.Image := aNode.NodeByName('enclosure').AttributeByName['url'];
    Result.Link := aNode.NodeByName('link').ValueAsString;

    while Pos('/', Result.Image) > 0 do
      Delete(Result.Image, 1, Pos('/', Result.Image));

    if Result.Image = '' then
      Result.Image := 'shate.jpg'
  end;
  
var
  aStream: TStringStream;
  s: string;
  RssPageTemplate, RowTemplate, RssList: string;

  aXMLDoc: TNativeXml;
  aNode: TXmlNode;
  aList: TList;
  i: Integer;
  aRssNode: TRssNode;
  aStrings: TStrings;
  t: Cardinal;
begin
  ShowMEssage(Data.VersionTable.FieldByName('PictsVersion').AsString);
  Data.VersionTable.Edit;
  Data.VersionTable.FieldByName('PictsVersion').Value := 'sdfsdfsdfsdfsdfsdfsdf';
  Data.VersionTable.Post;
  ShowMEssage(Data.VersionTable.FieldByName('PictsVersion').AsString);

  exit;
  aStrings := TStringList.Create;
  Data.memAnalog.First;
  while not Data.AnalogTable.eof do
  begin
    for i:=0 to Data.AnalogTable.FieldCount - 1 do
      s:= s + ';' + Data.AnalogTable.Fields[i].FieldName +  ' - ' + Data.AnalogTable.FieldByName(Data.AnalogTable.Fields[i].FieldName).AsString;
    aStrings.add(s);
    aStrings.add('*********************');
    s := '';
    Data.AnalogTable.Next;
  end;
  aStrings.SaveToFile('E:\memAnalog.csv');
  exit;
  ShowMessage(
    'cat: ' + Data.CatalogDatasource.DataSet.FieldByName('code').AsString + ' - ' + Data.CatalogDatasource.DataSet.FieldByName('QuantLocal').AsString + #13#10 +
    'ana: ' + Data.AnalogTable.FieldByName('an_code').AsString + ' - ' + Data.AnalogTable.FieldByName('QuantLocal').AsString
  );

exit;
  Data.ReturnDocTable.Close;
  Data.ReturnDocDetTable.Close;

  Data.ConvertRetDocs;

  Data.ReturnDocTable.Open;
  Data.ReturnDocDetTable.Open;

  Exit;

  t:= GetTickCount;
//  Data.CreateQuantsLookup;
  Exit;

  ShowMessage(GetAllQuantsInfo(MainGrid.DataSource.DataSet.FieldByName('CAT_ID').AsInteger));
  aStrings := TStringList.Create;
  try
    GetAllQuantsInfo(MainGrid.DataSource.DataSet.FieldByName('CAT_ID').AsInteger, aStrings);
    fQuantsInfo.SetQuants(aStrings);
  finally
    aStrings.Free;
  end;

//LoadOrderStatus;

 // RaiseNotifyEvent('Получены ответы по заказам'#13#10'Получены ответы по возвратам', 'Уведомление', netOrders);
//  RaiseNotifyEvent('Получены ответы по возвратам', 'Уведомление', netRetdocs);

  //UBallonSupport.ShowBallonInfo(btNotify, 'Получены ответы по заказам', 'Уведомление');
 // PostMessage(Handle, PROGRESS_UPDATE_RESTARTPROG, 0, 0);

// Application.Restore;
 // ImportPricesOnly;

end;

procedure TMain.TaskOrdersStatusBeforeRun(Sender: TObject;
  var aCanRun: Boolean);
var
  aData: TOrdersStatusTaskData;
  aQuery: TDBISAMQuery;
  i: Integer;
  s: string;
  anOrderAge: TDateTime;
begin
  if Sender is TTaskOrdersStatus then
  begin
    ZeroMemory(@aData, SizeOf(TOrdersStatusTaskData));

//    aData.Host1 := Data.SysParamTable.FieldByName('Host').AsString;

    aData.Port1 := Data.SysParamTable.FieldByName('PortIn').AsInteger;
    aData.Host1 := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
//    aData.Host2 := Data.SysParamTable.FieldByName('BackHost').AsString;
    aData.Port2 := Data.SysParamTable.FieldByName('PortIn').AsInteger;
    aData.Host3 := Data.SysParamTable.FieldByName('TCPHost3').AsString;
    aData.Port3 := Data.SysParamTable.FieldByName('PortIn').AsInteger;

    // !!! опрашивать только те у которых статус доставки = "Доставка"
    aQuery := TDBISAMQuery.Create(nil);
    try
      aQuery.DatabaseName := Data.Database.DatabaseName;
      aQuery.SQL.Text :=
        ' SELECT Order_id, Cli_id, "Sign", Sent_time, Sent, LotusNumber FROM [009] ' +
        ' WHERE "Sign" <> '''' AND Cli_id <> '''' AND (IsDelivered = 0 or IsDelivered IS NULL) AND (Sent <> '''' AND Sent <> ''0'') AND Sent_time IS NOT NULL ';
      aQuery.Open;
      while not aQuery.Eof do
      begin                                
        //заказ обработан и нет Лотус-номера - значит была ошибка при формировании заказа (не удалось зарезервировать ни одной позиции и др.)
        if (aQuery.FieldByName('Sent').AsString = '2') and (aQuery.FieldByName('LotusNumber').AsString = '') then
        begin
          aQuery.Next;
          Continue;
        end;

        //не опрашиваем устаревшие заказы
        anOrderAge := (Now() - aQuery.FieldByName('Sent_time').AsDateTime);
        if (anOrderAge >= 0) and (anOrderAge < cObsoleteOrderTime) then //если дата переведена назад - будет с минусом
        begin
          {<Order_Id>=<Client_Id>_<Order_Num>,<Order_Id>=<Client_Id>_<Order_Num>}
          s := Format('%s=%s_%s', [aQuery.FieldByName('Order_id').AsString, aQuery.FieldByName('Cli_id').AsString, aQuery.FieldByName('Sign').AsString]);
          if aData.OrdersToCheck = '' then
            aData.OrdersToCheck := s
          else
            aData.OrdersToCheck := aData.OrdersToCheck + ',' + s;
        end;
        aQuery.Next;
      end;
      aQuery.Close;
    finally
      aQuery.Free;
    end;

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
  aQuery: TDBISAMQuery;
  aStatus: Integer;
begin
  if not Data.fDatabaseOpened then //может в этот момент применяется обновление
    Exit;

  if (Sender is TTaskOrdersStatus) and ((Sender as TTaskOrdersStatus).HasResult) then
  begin
    aRes := TStringList.Create;
    aQuery := TDBISAMQuery.Create(nil);
    try
      aQuery.DatabaseName := Data.Database.DatabaseName;


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
            aQuery.SQL.Text := ' UPDATE [009] SET IsDelivered = :IsDelivered WHERE Order_id = :Order_id ';
            aQuery.Params[0].AsInteger := aStatus;
            aQuery.Params[1].AsInteger := StrToIntDef(aRes.Names[i], 0);

            aQuery.ExecSQL;
            aQuery.Close;

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
      aQuery.Free;
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

procedure TMain.TaskRssAfterEnd(Sender: TObject);
var
  aListOld, aListNew: TList;
  aRssFile, aRssFileRL: string;
  aOldRL, aNewRL: string;
  aOldRLDate, aNewRLDate: TDateTime;
  aHasNew, aHasNewRL: Boolean;
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

        aHasNewRL := False;
        sl.Text := (Sender as TTaskRss).GetResultRL;
        if RssTools.EncodeRssRunningLine(sl.Text, aNewRL, aNewRLDate) then
        begin
          if (aNewRLDate <> aOldRLDate) or (not FileExists(GetAppDir + 'RunningLine')) then
          begin
            aHasNewRL := Main.JvScrollText.Active;
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

procedure TMain.LoadClientsPass(aFileName: string);
var
  aReader: TCSVReader;
  aReader2: TCSVReader;
  aOldProgress: Integer;
  aFullMode, aNeedEmail: Boolean;
  aMap: TStrings;
  aDescr, aNewEmail: string;
begin
exit;
 // aFileName := ExtractFilePath(ParamStr(0)) + 'AllClients.csv';
 { if aFileName = '' then
    aFileName := '\\Doynikov\Share\714F2F25-26C9-4FE7-9587-C69D0BEFA6E5'; }
  if not FileExists(aFileName) then
    raise Exception.CreateFmt('Файл не найден "%s"', [aFileName]);

  aMap := TStringList.Create;
  if FileExists(ExtractFilePath(ParamStr(0)) + 'clients_part.csv') then
  begin
    aReader2 := TCSVReader.Create;
    aReader2.Open(ExtractFilePath(ParamStr(0)) + 'clients_part.csv');
    while not aReader2.Eof do
    begin
      aReader2.ReturnLine;
      aMap.Add(aReader2.Fields[0] + '=' + aReader2.Fields[1]);
    end;
    aReader2.Free;
  end;

  aFullMode := Application.MessageBox('Добавить новых контрагентов?'#13#10'Нажмите "нет" только для обновления существующих', 'Подтверждение', MB_YESNO or MB_ICONQUESTION) = IDYES;
  aNeedEmail := Application.MessageBox('Прописать один E-Mail для всех?', 'Подтверждение', MB_YESNO or MB_ICONQUESTION) = IDYES;
  if aNeedEmail then
    if not InputQuery('Укажите E-Mail', 'Укажите E-Mail', aNewEmail) then
      aNeedEmail := False;

  aOldProgress := -1;
  ShowProgress('Импорт');
  Data.ClIDsTable.Close;
  Data.ClIDsTable.Filtered := False;
  Data.ClIDsTable.IndexName := 'Client_ID';
  Data.ClIDsTable.Open;
  aReader := TCSVReader.Create;

  try
    aReader.Open(aFileName);

    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      if not Data.ClIDsTable.FindKey([ aReader.Fields[0] ]) then
      begin
        if aFullMode then
        begin
          Data.ClIDsTable.Append;
          Data.ClIDsTable.FieldByName('client_id').AsString := aReader.Fields[0];
        end
        else
          Continue;
      end
      else
        Data.ClIDsTable.Edit;

      Data.ClIDsTable.FieldByName('Key').AsString := aReader.Fields[1];
      if aNeedEmail then
        Data.ClIDsTable.FieldByName('email').AsString := aNewEmail;
      aDescr := aMap.Values[aReader.Fields[0]];
      if aDescr <> '' then
        Data.ClIDsTable.FieldByName('Description').AsString := aDescr;
      Data.ClIDsTable.Post;

      if aReader.FilePosPercent <> aOldProgress then
      begin
        aOldProgress := aReader.FilePosPercent;
        CurrProgress(aOldProgress);
      end;
    end;
    aReader.Close;
    if Table.Active then
      Table.Refresh;
    LoadUserID;  
    ShowMessage('Загружено');
  finally
    HideProgress;
    aReader.Free;
    aMap.Free;
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
        aItem.Enabled := AutoAction.Visible;
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
        XRoundCurr(Data.GetMargin(Data.XCatTable.FieldByName('group_id').AsInteger, Data.XCatTable.FieldByName('subgroup_id').AsInteger, Data.XCatTable.FieldByName('Brand_id').AsInteger) *
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

procedure TMain.UpdateAllQuantsInfo(aForCatalog, aForAnalog: Boolean);
var
  sl: TStrings;
begin
  if QuantsLargeMode then
    Exit;

  sl := TStringList.Create;
  try
    if aForCatalog then
      if Data.CatalogDataSource.DataSet.FieldByName('CAT_ID').AsInteger > 0 then
      begin
        GetAllQuantsInfo(Data.CatalogDataSource.DataSet.FieldByName('CAT_ID').AsInteger, sl);
        fQuantsInfo.SetQuants(sl);
      end
      else
        fQuantsInfo.Clear;


    if aForAnalog then
      if Data.memAnalog.FieldByName('An_Id').AsInteger > 0 then
      begin
        GetAllQuantsInfo(Data.memAnalog.FieldByName('An_Id').AsInteger, sl);
        fQuantsInfoAn.SetQuants(sl);
      end
      else
        fQuantsInfoAn.Clear;
  finally
    sl.Free;
  end;
end;

procedure TMain.UpdateCatalogCaption;
var
  aCat: TDataSet;
  s, sPic: string;
begin
  aCat := MainGrid.DataSource.DataSet;
  case Data.Tree_mode of
    0, 2:
    begin
      if aCat.FieldByName('BrandDescrRepl').AsString <> '' then
        sPic := '<IMG src="0">'
      else
        sPic := '';
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
  if Source <> MainGrid then
    Exit;

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

procedure TMain.KKGridEhDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := False;
  if Source <> MainGrid then
    Exit;

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
  aCapt :=lbDownloadPicture.Caption;
  lbDownloadPicture.Caption := 'загрузка...';
  lbDownloadPicture.OnClick := nil;
  lbDownloadPicture.Update;
  aRespond := TMemoryStream.Create;
  try
    aPictId := lbDownloadPicture.Tag;
    aUrl := Format(cPictUrl, [aPictId div 1000, aPictId]);
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
  aBut: TSpeedButton;
  s: string;
  i: Integer;
  sl: TStrings;
  aLogHintText: string;
begin
  fRaisedNotifyEvents[aType] := True;

  aBut := fNotifyButtons[aType];
  btNotify.Visible := True;
{
  if Assigned(aBut) then
  begin
    aBut.Visible := True;
    aBut.Hint := aCaption + ': ' + aText;
    aBut.ShowHint := True;
    ArrangeNotifyButtons;
    UBallonSupport.ShowBallonInfo(aBut, #13#10 + aText + #13#10, aCaption);
  end
  else
}  
  ArrangeNotifyButtons;
//  UBallonSupport.ShowBallonInfo(btNotify, #13#10 + aText + #13#10, aCaption);
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
//      fNotifyLog.Text := fNotifyLog.Text + {aCaption + ': ' + }aText;
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

var
  aCol: TColumnEh;
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


procedure TMain.RotateTimerTimer(Sender: TObject);
var
  iType: TNotifyEventType;
  aRaised: Boolean;
begin
  aRaised := False;
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
  aShowErrorOnFail: Boolean): Boolean;
begin
  Result := False;

  if aClient.Connected then
    aClient.Disconnect;

  aClient.ConnectTimeout := 5000;
  aClient.ReadTimeout := 5000;
  try
    try
      {$IFDEF TEST}
      aClient.Host := cTestTCPHost;
      aClient.Port := 6003;
      {$ELSE}
//      aClient.Host := Data.SysParamTable.FieldByName('Host').AsString;
      aClient.Host := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
      aClient.Port := Data.SysParamTable.FieldByName('PortIn').AsInteger;
      {$ENDIF}

      aClient.Connect;
    except
      try
//        aClient.Host := Data.SysParamTable.FieldByName('BackHost').AsString;
        aClient.Host := Data.SysParamTable.FieldByName('Host').AsString;
        aClient.Port := Data.SysParamTable.FieldByName('PortIn').AsInteger;
        aClient.Connect;
      except
        aClient.Host := Data.SysParamTable.FieldByName('TCPHost3').AsString;
        aClient.Port := Data.SysParamTable.FieldByName('PortIn').AsInteger;
        aClient.Connect;
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


procedure TMain.CreateScheduledTasks;

  function CreateTaskDiscounts: TTaskDiscounts;
  begin
    Result := TTaskDiscounts.Create;
    Result.OnBeforeRun := TaskDiscountsBeforeRun;
    Result.OnAfterEnd := TaskDiscountsAfterEnd;
    Result.LogProc := TaskLog;

    Result.Schedule.StartDelay.Interval := 5;
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

    Result.Schedule.StartDelay.Interval := 10;
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

    Result.Schedule.StartDelay.Interval := 15;
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

    Result.Schedule.StartDelay.Interval := 2;
    Result.Schedule.StartDelay.Multiply := imSecond;

    Result.Schedule.Repeatable := Data.ParamTable.FieldByName('AutoCheckRssInt').AsInteger > 0;
    Result.Schedule.RepeatEach.Interval := Data.ParamTable.FieldByName('AutoCheckRssInt').AsInteger;
    Result.Schedule.RepeatEach.Multiply := imMinute;

    Result.Schedule.Scheduled := True;
    Result.Enabled := Data.ParamTable.FieldByName('AutoCheckRss').AsBoolean;
  end;

begin
  fScheduler.AddTask(CreateTaskDiscounts);
  fScheduler.AddTask(CreateTaskOrders);
  fScheduler.AddTask(CreateTaskStatuses);
  fScheduler.AddTask(CreateTaskRss);
end;

procedure TMain.UpdateScheduledTasks;
var
  i: Integer;
  aTask: TCommonTask;
begin
  for i := 0 to fScheduler.TaskCount - 1 do
  begin
    aTask := fScheduler.GetTask(i);

    if aTask is TTaskDiscounts then
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

procedure TMain.DebugLog(const aText: string; isDebug: Boolean = False; aWithoutDateTime: Boolean = False);
var
  f: TextFile;
  aDebugLabel: string;
  fLogFileName: string;
begin
//  if isDebug and not fPrefs.DebugLogEnabled then
//    Exit;
  if not fDebugRun then
    Exit;

  fLogFileName := GetAppDir + 'Debug.log';
//  fLogLock.Enter;
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
//    fLogLock.Leave;
  end;
end;

function TMain.IsGroupNewCartNeeded(aGroupId: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(cNewOrderGroups) to High(cNewOrderGroups) do
    if aGroupId = cNewOrderGroups[i] then
    begin
      Result := True;
      Exit;
    end;
end;

function TMain.GetNewCartGroups: string;
var
  i: Integer;
begin
  Result := '';
  for i := Low(cNewOrderGroups) to High(cNewOrderGroups) do
    if Data.XGroupTable.Locate('GROUP_ID', cNewOrderGroups[i], [])  then
    begin
      if Result = '' then
        Result := '   [' + Data.XGroupTable.FieldByName('GROUP_DESCR').AsString + ']'
      else
        Result := Result + #13#10 + '   [' + Data.XGroupTable.FieldByName('GROUP_DESCR').AsString + ']';
    end;
end;

function TMain.IsOrderMixGroups: Boolean;
var
  aRecNo: Integer;
  aSimpleGoods, aExcludeGoods: Boolean;
begin
  Result := False;
  aSimpleGoods := False;
  aExcludeGoods := False;

  with Data.OrderDetTable do
  begin
    aRecNo := RecNo;
    First;
    while not Eof do
    begin
      if not IsGroupNewCartNeeded(FieldByName('ArtGroupId').AsInteger) then
        aSimpleGoods := True
      else
        aExcludeGoods := True;

      if aSimpleGoods and aExcludeGoods then
      begin
        Result := True;
        Break;
      end;
      Next;
    end;
    RecNo := aRecNo;
  end;
end;

function TMain.SplitMixOrder: Integer;
var
  aCurOrderId, aNewOrderId: Integer;
  anIDs: string;
begin
  Result := 0;
  
  aCurOrderId := Data.OrderTable.FieldByName('ORDER_ID').AsInteger;
  //собираем ID'шки для переноса
  with Data.OrderDetTable do
  begin
    anIDs := '';
    First;
    while not Eof do
    begin
      if IsGroupNewCartNeeded(FieldByName('ArtGroupId').AsInteger) then
        if anIDs = '' then
          anIDs := FieldByName('ID').AsString
        else
          anIDs := anIDs + ',' + FieldByName('ID').AsString;
      Next;
    end;
  end;

  //новая корзина
  Data.ExecuteQuery(
    ' INSERT INTO [009] ("Date", Num, Code, Cli_id, "Description", State, Type, Delivery, Currency) ' +
    ' SELECT "Date", Num, Code, Cli_id, "Description", State, Type, Delivery, Currency FROM [009] WHERE ORDER_ID = ' + IntToStr(aCurOrderId));
  aNewOrderId := StrToIntDef(Data.ExecuteSimpleSelect(' SELECT Max(ORDER_ID) FROM [009] ', []), 0);
  Result := aNewOrderId;

  //переносим товары
  Data.ExecuteQuery(' UPDATE [010] SET ORDER_ID = ' + IntToStr(aNewOrderId) + ' WHERE ID IN(' + anIDs + ')');

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

procedure TMain.IdMessageInitializeISO(var VTransferHeader: TTransfer;
  var VHeaderEncoding: Char; var VCharSet: string);
begin
  VCharSet:='windows-1251';
  VTransferHeader := bit8;
  VHeaderEncoding := '8';
end;

procedure TMain.ImportPricesOnly;
var
  aReader: TCSVReader;
  aCode, aBrand: string;
  aPrice: Double;
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
end;

//#new
function TMain.CheckDocumentEnabled(anEditAction: TAction): Boolean;
begin
  Result := anEditAction.Enabled and anEditAction.Visible;
  if not Result then
    Application.MessageBox('Документ заблокирован', 'Сообщение', MB_OK or MB_ICONWARNING);
end;

function TMain.UnlockDocument(aTable: TDBISamTable): Boolean;
begin
  Result := False;
  if aTable.FieldByName('State').AsInteger <> 0 then
  begin
    if MessageDlg('Возможно документ уже отправлялся!'#13#10'Хотите разблокировать?', mtWarning, [mbYes, mbNo], 0) = mrNo  then
      Exit;

   aTable.Edit;
   aTable.FieldByName('State').AsInteger := 0;
   aTable.Post;
   
   Result := True;
  end;
end;


procedure TMain.BasesChanged;
var
  rn: Integer;
  i: Integer;
  aCol: TColumnEh;
begin
  rn := 0;
  while rn < MainGrid.Columns.Count   do
  begin
    if MainGrid.Columns[rn].FieldName = 'Basic' then
      MainGrid.Columns.Delete(rn)
    else
      if StrLeft(MainGrid.Columns[rn].FieldName,9) = 'Quantity2' then
        MainGrid.Columns.Delete(rn)
      else
        rn := rn + 1;
  end;

  rn := 0;
  while rn < AnalogGrid.Columns.Count   do
  begin
    if AnalogGrid.Columns[rn].FieldName = 'Basic' then
      AnalogGrid.Columns.Delete(rn)
    else
      if StrLeft(AnalogGrid.Columns[rn].FieldName, 9) = 'Quantity2' then
        AnalogGrid.Columns.Delete(rn)
      else
    rn := rn + 1;
  end;

  pnAllQuantsHost.Visible := not QuantsLargeMode;
  splitterAllQuantsHost.Visible := not QuantsLargeMode;
  pnAllQuantsHostAn.Visible := not QuantsLargeMode;
  splitterAllQuantsHostAn.Visible := not QuantsLargeMode;
  if not QuantsLargeMode then
  begin
    splitterAllQuantsHost.Align := alLeft;
    splitterAllQuantsHost.Align := alRight;
    splitterAllQuantsHostAn.Align := alLeft;
    splitterAllQuantsHostAn.Align := alRight;
  end;

  fActiveBases.Clear;
  with  Data.TableBases do
  begin
    DisableControls;
    rn := RecNo;
    First;
    while not Eof do
    begin
      if FieldByName('Activate').AsInteger > 0 then
      begin
        if Data.TableBases.FieldByName('Basic').AsString <> '1' then
          fActiveBases.Add(FieldByName('CODE').AsString + '=' + FieldByName('MaskName').AsString);

        with Main.MainGrid do
        begin
          if Data.TableBases.FieldByName('Basic').AsString = '1' then
          begin
            aCol := Columns.Add;
            aCol.FieldName := 'Basic';
            aCol.Title.Caption := FieldByName('MaskName').AsString;
            aCol.MinWidth := 35;
            aCol.MaxWidth := 45;

            aCol:= AnalogGrid.Columns.Add;
            aCol.FieldName := 'Basic';
            aCol.Title.Caption := FieldByName('MaskName').AsString;
            aCol.MinWidth := 35;
            aCol.MaxWidth := 45;
          end
          else
            if QuantsLargeMode then
            begin
              aCol := Columns.Add;
              aCol.FieldName := 'Quantity2'+FieldByName('CODE').AsString;
              aCol.Title.Caption := FieldByName('MaskName').AsString;
              aCol.MinWidth := 35;
              aCol.MaxWidth := 40;

              aCol := AnalogGrid.Columns.Add;
              aCol.FieldName := 'Quantity2'+FieldByName('CODE').AsString;
              aCol.Title.Caption := FieldByName('MaskName').AsString;
              aCol.MinWidth := 35;
              aCol.MaxWidth := 40;
            end;
        end;
      end;
      Next;
    end;
    RecNo := rn;
    EnableControls;
  end;
  Data.GetQuantsNumber;//refresh sklada
  ChangeInterfaceForScladCurr(Data.CurrSclad);
end;

function TMain.GetAllQuantsInfo(aCatId: Integer): string;
var
  aList: TStrings;
begin
  aList := TStringList.Create;
  try
    GetAllQuantsInfo(aCatId, aList);
    Result := StringReplace(aList.Text, '=', ': ', [rfReplaceAll]);
  finally
    aList.Free;
  end;
end;

procedure TMain.GetAllQuantsInfo(aCatId: Integer; aRes: TStrings);
var
  i: Integer;
  aTable: TDBISAMTable;
  aQuant: string;
begin
  aRes.Clear;
  if not Data.SkladQuants.Active {Data.QuantTableJoin.Active }then
    Exit;

  aTable := TDBISAMTable.Create(nil);
  aTable.DatabaseName := Data.Database.DatabaseName;
  try

    //<код_базы_остатков>=<короткое_имя>
    for i := 0 to fActiveBases.Count - 1 do
    begin
      aQuant := '';
      //if Data.QuantTableJoin.Locate('CAT_ID', aCatId, []) then
        //aQuant := Data.QuantTableJoin.FieldByName('Q' + fActiveBases.Names[i]).AsString;
      if Data.SkladQuants.Locate('CAT_ID', aCatId, []) then
        aQuant := Data.SkladQuants.FieldByName('Q' + fActiveBases.Names[i]).AsString;

      aRes.Add(fActiveBases.ValueFromIndex[i] + '=' + aQuant);
    end;

  finally
    aTable.Free;
  end;
end;


function TMain.IsQuantsBaseActive(aBaseCode: Integer): Boolean;
begin
  Result :=
    ( sNameGlobalID = IntToStr(aBaseCode) ) or
    ( fActiveBases.IndexOfName( IntToStr(aBaseCode) ) >= 0 );
end;

function TMain.SendEMailByTCP(const aFrom, aTo, aSubject, aBody,
  aFileToAttach: string): Boolean;
var
  s: string;
  F: TextFile;
begin
  Result := False;

  with TCPClient do
  try
    Disconnect;
    try
      //оптика
      Host := Data.SysParamTable.FieldByName('TCPHostOpt').AsString;
      Port := Data.SysParamTable.FieldByName('Port').AsInteger;
      Connect;
      except
        try
          //DSL1
          Host := Data.SysParamTable.FieldByName('Host').AsString;
          Port := Data.SysParamTable.FieldByName('Port').AsInteger;
          Connect;
        except
          try
            //триджик
            Host := Data.SysParamTable.FieldByName('TCPHost3').AsString;
            Port := Data.SysParamTable.FieldByName('Port').AsInteger;
            Connect;
          except
            //DSL2
            Host := Data.SysParamTable.FieldByName('BackHost').AsString;
            Port := Data.SysParamTable.FieldByName('Port').AsInteger;
            Connect;
          end;
        end;
      end;

    try
      IOHandler.WriteLn(aFrom);               //email
      IOHandler.WriteLn('#sent_to_address#'); //subj
      IOHandler.WriteLn(aTo);                 //адреса получателей через запятую
      IOHandler.WriteLn(aSubject);            //тема
      s := StringReplace(aBody, #13#10, '  ', [rfReplaceAll]);
      IOHandler.WriteLn(s);                   //тело (!без переносов строк!)
      IOHandler.Writeln(ExtractFileName(aFileToAttach)); //имя файла (пусто если файла нет)
      //файл >>
      if FileExists(aFileToAttach) then
      begin
        AssignFile(F, aFileToAttach);
        Reset(F);
        try
          while not System.Eof(F) do
          begin
            System.Readln(F, s);
            if s <> '' then
              IOHandler.Writeln(s);
          end;
          IOHandler.Writeln('FINALYSEND');
          s := IOHandler.ReadLn;
          Result := s = 'TRUE';
        finally
          CloseFile(F);
        end;
      end
      else
        Result := True;
      //<< файл
    finally
      Disconnect;
    end;
  except
    on e: EIdException do
      MessageDlg('Ошибка соединения: ' + e.Message, mtError, [mbOK], 0);
    on e: Exception do
      MessageDlg('Ошибка: ' + e.Message, mtError, [mbOK], 0);
  end;
end;


end.

