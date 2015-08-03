{ DDL изменения структуры

//каталог
alter table [002] add
pict_id INTEGER NOT NULL DEFAULT 0

alter table [002] add
typ_tdid INTEGER NOT NULL DEFAULT 0

alter table [002] add
param_tdid INTEGER NOT NULL DEFAULT 0

CREATE INDEX pict ON [002] (pict_id);
CREATE INDEX typ ON [002] (typ_id);
CREATE INDEX param ON [002] (param_id);


//артикула Tecdoc
alter table [110] add
  pict_id INTEGER NOT NULL DEFAULT 0

alter table [110] add
  pict_nr SMALLINT NOT NULL DEFAULT 0

alter table [110] add
  typ_id INTEGER NOT NULL DEFAULT 0

alter table [110] add
  param_id INTEGER NOT NULL DEFAULT 0

CREATE INDEX art ON [110] (Art_Id);
CREATE INDEX pict ON [110] (pict_id);
CREATE INDEX typ ON [110] (typ_id);
CREATE INDEX param ON [110] (param_id);

}

unit _Data;

interface

uses
  SysUtils, Classes, DB, Forms, DBISAMTb, DBISAMCN, BSFilMng,
  Dialogs, Controls, Windows, Variants, BSInterf, BSDbiUt, JvComponentBase,
  BSStrUt, HyperStr, ComObj, VclUtils, StrUtils, ComCtrls, BSMath,
  AdvOfficeStatusBar, Math, Graphics, VCLUnZip, VCLZip, JclFileUtils, ExtCtrls,
  ADODB, IniFiles, Registry, JvBaseDlg, JvSelectDirectory, {JvBDEFilter, }dbisamen,
  _CommonTypes;

const
  cUpdateInfoFileName = 'update.inf';
  cUpdateInfoExtFileName = 'update_ext.inf';
  cDeleteBatchCount = 1000; //размер пачки IN(...) при удалении
  cUpdateBatchCount = 200; //размер пачки IN(...) при обновлении

  cQuantBasesCount = 22;

  //идентификация сервисной программы
  cServiceProgCode2 = 'СЕРВИСНАЯПРОГРАММА'; //код сервисной программы
  cServiceProgBrand = 'CATALOG';            //бренд сервисной программы

  type MaxGenAnIDList = record
    MaxGenAnIdFromTable_1: integer;
    MaxGenAnIdFromTable_2: integer;
    MaxGenAnIdFromTable_3: integer;
    MaxGenAnIdFromTable_4: integer;
    MaxGenAnIdFromTable_5: integer;
  end;

type
  TData = class(TDataModule)
    Database: TDBISAMDatabase;
    DBEngine: TDBISAMEngine;
    ParamTable: TDBISAMTable;
    ParamTableId: TAutoIncField;
    OpenDialog: TOpenDialog;
    CatalogTable: TDBISAMTable;
    LoadCatTable: TDBISAMTable;
    BrandTable: TDBISAMTable;
    BrandTableBrand_id: TIntegerField;
    BrandTableDescription: TStringField;
    GroupTable: TDBISAMTable;
    GroupTableId: TAutoIncField;
    GroupTableGroup_id: TIntegerField;
    GroupTableGroup_descr: TStringField;
    GroupTableSubgroup_id: TIntegerField;
    GroupTableSubgroup_descr: TStringField;
    BrandTableId: TAutoIncField;
    GroupBrandTable: TDBISAMTable;
    GroupBrandTableId: TAutoIncField;
    GroupBrandTableGroup_id: TIntegerField;
    GroupBrandTableSubgroup_id: TIntegerField;
    GroupBrandTableBrand_id: TIntegerField;
    CatalogDataSource: TDataSource;
    MyGroupTable: TDBISAMTable;
    MyGroupTableId: TAutoIncField;
    MyGroupTableGroup_id: TIntegerField;
    MyGroupTableSubgroup_id: TIntegerField;
    ParamTableTree_mode: TSmallintField;
    AnalogTable: TDBISAMTable;
    AnalogTableId: TAutoIncField;
    AnalogTableAn_code: TStringField;
    LoadAnTable: TDBISAMTable;
    AnalogTableAn_brand: TStringField;
    AnalogDataSource: TDataSource;
    XCatTable: TDBISAMTable;
    AnalogTableDescription: TStringField;
    AnalogTablePrice: TCurrencyField;
    SearchTable: TDBISAMTable;
    XBrandTable: TDBISAMTable;
    XGroupTable: TDBISAMTable;
    FiltTable: TDBISAMTable;
    FiltTableId: TAutoIncField;
    FiltTableText: TStringField;
    FiltTableCnt: TIntegerField;
    FiltDataSource: TDataSource;
    ParamTableLast_Filt: TStringField;
    ParamDataSource: TDataSource;
    SFiltTable: TDBISAMTable;
    OrderTable: TDBISAMTable;
    OrderDetTable: TDBISAMTable;
    OrderTableDescription: TStringField;
    OrderTableDate: TDateField;
    OrderTableNum: TIntegerField;
    OrderTableCode: TStringField;
    OrderTableState: TSmallintField;
    OrderDetTableId: TAutoIncField;
    OrderDetTableOrder_id: TIntegerField;
    OrderDetTableArt_id: TIntegerField;
    OrderDetTableQuantity: TFloatField;
    OrderDetTablePrice: TCurrencyField;
    OrderDetTableState: TSmallintField;
    OrderDetTablePos: TSmallintField;
    OrderDataSource: TDataSource;
    OrderDetDataSource: TDataSource;
    ClIDsDataSource: TDataSource;
    OrderDetTableArtCode: TStringField;
    OrderDetTableArtDescr: TStringField;
    OrderDetTableSum: TCurrencyField;
    XClIDsTable: TDBISAMTable;
    OrderTableInfo: TStringField;
    OrderTableOrder_id: TAutoIncField;
    AnalogTableAn_id: TIntegerField;
    GroupTableDiscount: TFloatField;
    ParamTableEur_rate: TCurrencyField;
    ParamTableEur_usd_rate: TCurrencyField;
    ParamTableShow_mparam: TBooleanField;
    ParamTableCurrency: TSmallintField;
    AnalogTablePrice_koef: TCurrencyField;
    OrderDetTablePrice_koef: TCurrencyField;
    OrderTableSum: TCurrencyField;
    XOrderDetTable: TDBISAMTable;
    QuantTable: TDBISAMTable;
    QuantTableCat_id: TIntegerField;
    QuantTableId: TAutoIncField;
    BrandDataSource: TDataSource;
    GroupDataSource: TDataSource;
    AnalogTableAn_subgroup_id: TIntegerField;
    QuantTableQuantity: TStringField;
    OrderTablePos: TIntegerField;
    OrderDetTableArtPrice: TCurrencyField;
    AnalogTableQuantity: TStringField;
    AnalogTableAn_sale: TStringField;
    AnalogTableAn_new: TStringField;
    AnalogTableSale: TStringField;
    AnalogTablenew: TStringField;
    CatDetTable: TDBISAMTable;
    CatDetTableId: TAutoIncField;
    CatDetTableTecdoc_id: TIntegerField;
    CatDetTableSort: TSmallintField;
    CatDetTableParam_id: TIntegerField;
    CatDetTableParam_value: TStringField;
    CatParTable: TDBISAMTable;
    CatParTableParam_id: TIntegerField;
    CatParTableDescr: TStringField;
    CatParTableDescription: TStringField;
    CatParTableType: TStringField;
    CatParTableInterv: TBooleanField;
    CatParTableParam_id2: TIntegerField;
    CatDetTableParamDescr: TStringField;
    CatDetDataSource: TDataSource;
    OpenZipDialog: TOpenDialog;
    TDArtTable: TDBISAMTable;
    MyGroupTableGroup_descr: TStringField;
    MyGroupTableSubgroup_descr: TStringField;
    TDArtTableId: TAutoIncField;
    TDArtTableArt_Id: TIntegerField;
    TDArtTableArt_look: TStringField;
    TDArtTableSup_brand: TStringField;
    TDArtTablepict_id: TIntegerField;
    TDArtTablepict_nr: TSmallintField;
    TDArtTabletyp_id: TIntegerField;
    TDArtTableparam_id: TIntegerField;
    OETable: TDBISAMTable;
    OETableId: TAutoIncField;
    OETableCat_id: TIntegerField;
    OETableCode: TStringField;
    OETableCode2: TStringField;
    FiltTableMode: TSmallintField;
    OESearchTable: TDBISAMTable;
    OESearchTableId: TAutoIncField;
    OESearchTableCat_id: TIntegerField;
    OESearchTableCode: TStringField;
    OESearchTableCode2: TStringField;
    OESearchTableCatBrand: TIntegerField;
    OESearchTableCatGroup: TIntegerField;
    OESearchTableCatSubgroup: TIntegerField;
    ParamTableShow_start_info: TBooleanField;
    XOrderDetTable2: TDBISAMTable;
    ParamTableHide_start_info: TBooleanField;
    AnalogTableName: TStringField;
    AnalogTableName_Descr: TStringField;
    OrderTableType: TStringField;
    AnalogTableCat_id: TIntegerField;
    AnalogTableAn_Brand_id: TIntegerField;
    XCatTableCat_id: TIntegerField;
    XCatTableCode: TStringField;
    XCatTableCode2: TStringField;
    XCatTableDescription: TStringField;
    XCatTableGroup_id: TIntegerField;
    XCatTableSubgroup_id: TIntegerField;
    XCatTableBrand_id: TIntegerField;
    XCatTablePrice: TCurrencyField;
    XCatTableT1: TSmallintField;
    XCatTableT2: TSmallintField;
    XCatTableTitle: TBooleanField;
    XCatTableSale: TStringField;
    XCatTableNew: TStringField;
    XCatTableTecdoc_id: TIntegerField;
    XCatTableName: TStringField;
    XCatTableBrandDescr: TStringField;
    OrderTableSign: TStringField;
    OrderDetTableArtNameDescr: TStringField;
    OrderDetTableArtName: TStringField;
    LoadOETable: TDBISAMTable;
    LoadQuantTable: TDBISAMTable;
    AnSearchTable: TDBISAMTable;
    Zipper: TVCLZip;
    DoubleTable: TDBISAMTable;
    DoubleTableCat_id: TIntegerField;
    DoubleTableCode: TStringField;
    DoubleTableCode2: TStringField;
    DoubleTableDescription: TStringField;
    DoubleTableBrand_id: TIntegerField;
    DoubleTableBrandName: TStringField;
    SearchDoubleTimer: TTimer;
    DoubleTableName: TStringField;
    DoubleTableDescr: TStringField;
    UnloadQuantTable: TDBISAMTable;
    UnloadQuantTableId: TAutoIncField;
    UnloadQuantTableCat_id: TIntegerField;
    UnloadQuantTableQuantity: TStringField;
    UnloadQuantTableCatCode: TStringField;
    UnloadQuantTableCatBrand: TStringField;
    WaitListTable: TDBISAMTable;
    WaitListTableId: TAutoIncField;
    WaitListTablePos: TIntegerField;
    WaitListTableArt_id: TIntegerField;
    WaitListTableQuantity: TFloatField;
    WaitListTableCatCode: TStringField;
    WaitListTableArtName: TStringField;
    WaitListTableArtDescr: TStringField;
    WaitListTableArtNameDescr: TStringField;
    WaitListTableArtPrice: TCurrencyField;
    WaitListTablePrice_koef: TCurrencyField;
    WaitListDataSource: TDataSource;
    WaitListTableArtQuant: TStringField;
    WaitListTableArtBrandId: TIntegerField;
    ADOConnection: TADOConnection;
    ADODataSet: TADODataSet;
    WaitListTableArtSale: TStringField;
    ParamTableFilt_range: TStringField;
    TextAttrTable: TDBISAMTable;
    TextAttrTableId: TAutoIncField;
    TextAttrTableBavkground: TIntegerField;
    ParamTableFilt_mode: TIntegerField;
    TextAttrTableFont: TStringField;
    TextAttrDataSource: TDataSource;
    TextAttrTableSample: TStringField;
    ParamTableSale_backgr: TIntegerField;
    ParamTableSale_font: TStringField;
    ParamTableNoquant_backgr: TIntegerField;
    ParamTableNoquant_font: TStringField;
    TextAttrTableLo: TIntegerField;
    TextAttrTableHi: TIntegerField;
    TextAttrTableLoHi: TStringField;
    MTextAttrTable: TDBISAMTable;
    MTextAttrTableId: TAutoIncField;
    MTextAttrTableBackground: TIntegerField;
    MTextAttrTableFont: TStringField;
    MTextAttrTableLo: TIntegerField;
    MTextAttrTableHi: TIntegerField;
    MTextAttrTableLoHi: TStringField;
    MTextAttrDataSource: TDataSource;
    MTextAttrTableSample: TStringField;
    ParamTableCell_color: TBooleanField;
    ParamTableSCell_color: TBooleanField;
    AnalogTableMult: TIntegerField;
    XCatTableMult: TIntegerField;
    OrderTableSent_time: TDateTimeField;
    OrderTableSent: TStringField;
    ParamTablePage: TIntegerField;
    AnalogTablePrice_koef_eur: TCurrencyField;
    WaitListTablePrice_koef_eur: TCurrencyField;
    OrderDetTableArtSale: TStringField;
    OrderDetTableArtBrandId: TIntegerField;
    SysParamTable: TDBISAMTable;
    SysParamTableId: TAutoIncField;
    SysParamTableIgn_chars: TStringField;
    SysParamTableDecimal_sep: TStringField;
    SysParamTableShate_email: TStringField;
    SysParamTableLoad_log: TBooleanField;
    SysParamTableUpdate_url: TStringField;
    SysParamDataSource: TDataSource;
    ParamTableNet_interv: TIntegerField;
    NetTimer: TTimer;
    OrderDetTableCode: TStringField;
    OrderDetTableBrand: TStringField;
    WaitListTableCode: TStringField;
    WaitListTableBrand: TStringField;
    VersionTable: TDBISAMTable;
    VersionTableId: TAutoIncField;
    VersionTableProgVersion: TStringField;
    VersionTableDataVersion: TStringField;
    VersionTableQuantVersion: TStringField;
    VersionTableNewsVersion: TStringField;
    VersionDataSource: TDataSource;
    OrderTableDirty: TBooleanField;
    ParamTableUpgrade_level: TIntegerField;
    DesTextsTable: TDBISAMTable;
    DesTextsTableDes_id: TIntegerField;
    DesTextsTableTex_text: TStringField;
    CdsTextsTable: TDBISAMTable;
    CdsTextsTableCds_id: TIntegerField;
    CdsTextsTableTex_text: TStringField;
    ManufacturersTable: TDBISAMTable;
    ManufacturersTableMfa_id: TIntegerField;
    ManufacturersTableMfa_brand: TStringField;
    ModelsTable: TDBISAMTable;
    ModelsTableMod_id: TIntegerField;
    ModelsTableMfa_id: TIntegerField;
    ModelsTablePcon_start: TIntegerField;
    ModelsTablePcon_end: TIntegerField;
    ModelsTableTex_text: TStringField;
    TypesTable: TDBISAMTable;
    TypesTableTyp_id: TIntegerField;
    TypesTableMod_id: TIntegerField;
    TypesTableSort: TIntegerField;
    TypesTablePcon_start: TIntegerField;
    TypesTablePcon_end: TIntegerField;
    TypesTableKw_from: TIntegerField;
    TypesTableKw_upto: TIntegerField;
    TypesTableHp_from: TIntegerField;
    TypesTableHp_upto: TIntegerField;
    TypesTableCcm: TIntegerField;
    TypesTableCylinders: TSmallintField;
    TypesTableDoors: TSmallintField;
    TypesTableTank: TSmallintField;
    TypesTableCds_id: TIntegerField;
    TypesTableMmt_cds_id: TIntegerField;
    TypesTableVoltage_des_id: TIntegerField;
    TypesTableAbs_des_id: TIntegerField;
    TypesTableAsr_des_id: TIntegerField;
    TypesTableEngine_des_id: TIntegerField;
    TypesTableBrake_type_des_id: TIntegerField;
    TypesTableBrake_syst_des_id: TIntegerField;
    TypesTableFuel_des_id: TIntegerField;
    TypesTableCatalyst_des_id: TIntegerField;
    TypesTableBody_des_id: TIntegerField;
    TypesTableSteering_des_id: TIntegerField;
    TypesTableSteering_side_des_id: TIntegerField;
    TypesTableMax_weight: TBCDField;
    TypesTableDrive_des_id: TIntegerField;
    TypesTableTrans_des_id: TIntegerField;
    ArtTypTable: TDBISAMTable;
    ArtTypTableArt_id: TIntegerField;
    ArtTypTableTyp_id: TIntegerField;
    ArtTypTableId: TAutoIncField;
    XCatDetTable: TDBISAMTable;
    _del_CatPictTable: TDBISAMTable;
    _del_CatPictTableId: TAutoIncField;
    _del_CatPictTableTecdoc_id: TIntegerField;
    _del_CatPictTablePict_id: TIntegerField;
    _del_CatPictTablePict_type: TSmallintField;
    _del_CatPictTableSort: TSmallintField;
    _del_CatPictTableTab_nr: TSmallintField;
    PictTable: TDBISAMTable;
    PictTablePict_id: TIntegerField;
    PictTablePict_data: TBlobField;
    TypesTableTypeDescr: TStringField;
    TypesTableCdsText: TStringField;
    PrimenTable: TDBISAMTable;
    PrimenTableId: TAutoIncField;
    PrimenTableDescription: TStringField;
    PrimenDataSource: TDataSource;
    TypesTableValves: TSmallintField;
    TypesTableFuel_supply_des_id: TIntegerField;
    BrandReplTable: TDBISAMTable;
    BrandReplTableId: TAutoIncField;
    BrandReplTableBrand: TStringField;
    BrandReplTableRepl_brand: TStringField;
    TDBrandTable: TDBISAMTable;
    TDBrandTableBrand_id: TIntegerField;
    TDBrandTableBrand_descr: TStringField;
    TypesTableVoltText: TStringField;
    TypesTableAbsText: TStringField;
    TypesTableAsrText: TStringField;
    TypesTableEngText: TStringField;
    TypesTableBrTypeText: TStringField;
    TypesTableBrSysText: TStringField;
    TypesTableFuelText: TStringField;
    TypesTableCatText: TStringField;
    TypesTablePconText1: TStringField;
    TypesTablePconText2: TStringField;
    PrimenTablePcon: TStringField;
    PrimenTableHp: TIntegerField;
    PrimenTableCylinders: TIntegerField;
    PrimenTableFuel: TStringField;
    LoadArtTypTable: TDBISAMTable;
    UnknownBrandsTable: TDBISAMTable;
    UnknownBrandsTableId: TAutoIncField;
    UnknownBrandsTableBrand: TStringField;
    OrderDetTableArtCodeBrand: TStringField;
    ManufacturersTableHide: TBooleanField;
    TypesTableMfaHide: TBooleanField;
    CatTypDetTable: TDBISAMTable;
    CatTypDetTableId: TAutoIncField;
    CatTypDetTableTecdoc_id: TIntegerField;
    CatTypDetTableParam_id: TIntegerField;
    CatTypDetTableParam_value: TStringField;
    CatTypDetTableParamDescr: TStringField;
    CatTypDetTableTyp_id: TIntegerField;
    XCatTypDetTable: TDBISAMTable;
    ParamTableLoading: TBooleanField;
    LoadTimer: TTimer;
    SelectDirectory: TJvSelectDirectory;
    SysParamTableTecdoc_id: TIntegerField;
    SysParamTablePict_id: TIntegerField;
    WQuery: TDBISAMQuery;
    TDBrandTableHide: TBooleanField;
    TDBrandTableDescr_orig: TStringField;
    AnalogTableOrdQuantity: TFloatField;
    AnalogTableOrdQuantityStr: TStringField;
    OrderDetTableInfo: TStringField;
    XCatParTable: TDBISAMTable;
    UnloadQuantTableCatPrice: TCurrencyField;
    SysParamTableAct_period: TIntegerField;
    SysParamTableAct_warn_period: TIntegerField;
    ModelsTablePconText1: TStringField;
    ModelsTablePconText2: TStringField;
    TypesTableBodyText: TStringField;
    CatTypDetDataSource: TDataSource;
    PrimenTableTyp_id: TIntegerField;
    ADODataSet2: TADODataSet;
    TypesTableEng_codes: TStringField;
    PrimenTableEng_codes: TStringField;
    CatTypDetTableSort: TIntegerField;
    MyBrandTable: TDBISAMTable;
    MyBrandTableId: TAutoIncField;
    MyBrandTableBrand_descr: TStringField;
    BrandTableMy_brand: TBooleanField;
    AnalogTablePrice_pro: TCurrencyField;
    BlockMfaTable: TDBISAMTable;
    BlockMfaTableId: TAutoIncField;
    BlockMfaTableMfa_brand: TStringField;
    TypesTableMmtCdsText: TStringField;
    TypesTableTransText: TStringField;
    TypesTableFuelSupplText: TStringField;
    TypesTableDriveText: TStringField;
    TypesTableSteeringText: TStringField;
    SysParamTableVer_info1: TStringField;
    SysParamTableVer_info2: TStringField;
    ParamTableCli_id_mode: TStringField;
    OrderTableClientInfo: TStringField;
    SysParamTableHost: TStringField;
    SysParamTablePort: TIntegerField;
    ParamTableTCP_direct: TBooleanField;
    SysParamTableOrd_send_info: TStringField;
    AutoHistTable: TDBISAMTable;
    AutoHistTableId: TAutoIncField;
    AutoHistTableTyp_id: TIntegerField;
    AutoHistTableTypMmtText: TStringField;
    AutoHistTableMod_id: TIntegerField;
    AutoHistTableMfa_id: TIntegerField;
    WaitListTableInfo: TStringField;
    ParamTableLoading_comp: TStringField;
    AnalogTableUsa: TStringField;
    AnalogTableAn_usa: TStringField;
    XCatTableUsa: TStringField;
    SeachIdDetail: TDBISAMQuery;
    OrderDetTableOrdered: TSmallintField;
    SysParamTablePortIn: TIntegerField;
    ParamTableHide_NewInProg: TBooleanField;
    SysParamTableBackHOST: TStringField;
    ParamTableToForbidRemovalOrder: TBooleanField;
    ParamTableShowMessageAddOrder: TBooleanField;
    ParamTableProxySRV: TStringField;
    ParamTableProxyPort: TIntegerField;
    ParamTableProxyUser: TStringField;
    ParamTableProxyPassword: TStringField;
    ParamTableUseProxy: TBooleanField;
    ParamTableUseProxwAutoresation: TBooleanField;
    OrderDetTableNames: TStringField;
    OrderTableLotusNumber: TStringField;
    TestQuery: TDBISAMQuery;
    MainQuery: TDBISAMQuery;
    ParamTablebUnionDetailAnalog: TBooleanField;
    TableCarFilter: TDBISAMTable;
    CarFilterSource: TDataSource;
    UpdateCatalog: TDBISAMTable;
    UpdateBrand: TDBISAMTable;
    UpdateTree: TDBISAMTable;
    UpdateTreeID: TDBISAMTable;
    UpdateAnalog: TDBISAMTable;
    UpdateOE: TDBISAMTable;
    VersionTableDiscretNumberVersion: TIntegerField;
    TableCarFilterID: TAutoIncField;
    TableCarFilterType_ID: TIntegerField;
    DescriptionTable: TDBISAMTable;
    DescriptionTableID: TAutoIncField;
    DescriptionTableCat_ID: TIntegerField;
    DescriptionTableDescription: TMemoField;
    DescriptionSource: TDataSource;
    xDescriptionTable: TDBISAMTable;
    TabCarMem: TDBISAMTable;
    TabCarMemid: TAutoIncField;
    TabCarMemArt_id: TIntegerField;
    TabCarMemType_ID: TIntegerField;
    TableCarFilterCatIDS: TMemoField;
    UpdatePrimen: TDBISAMTable;
    UpdatePrimenID: TAutoIncField;
    UpdatePrimenType_Id: TIntegerField;
    UpdatePrimenCat_id: TMemoField;
    ParamTablebPasiveUpdate: TBooleanField;
    ParamTablebPasiveUpdateProg: TBooleanField;
    ParamTablebPasiveUpdateQuants: TBooleanField;
    ParamTableiUpdateTypeLoad: TIntegerField;
    FilterResult: TDBISAMTable;
    FilterResultCat_id: TIntegerField;
    FilterResultCode: TStringField;
    FilterResultCode2: TStringField;
    FilterResultName: TStringField;
    FilterResultDescription: TStringField;
    FilterResultGroup_id: TIntegerField;
    FilterResultSubgroup_id: TIntegerField;
    FilterResultBrand_id: TIntegerField;
    FilterResultPrice: TCurrencyField;
    FilterResultT1: TIntegerField;
    FilterResultT2: TIntegerField;
    FilterResultTitle: TBooleanField;
    FilterResultSale: TStringField;
    FilterResultNew: TStringField;
    FilterResultTecdoc_id: TIntegerField;
    FilterResultMult: TIntegerField;
    FilterResultUsa: TStringField;
    FilterResultName_Descr: TStringField;
    FilterResultGroupInfo: TStringField;
    FilterResultQuantity: TStringField;
    FilterResultBrandDescr: TStringField;
    FilterResultPrimen: TMemoField;
    FilterResultPrice_koef: TCurrencyField;
    FilterResultPrice_koef_eur: TCurrencyField;
    FilterResultPrice_pro: TCurrencyField;
    FilterResultOrdQuantityStr: TStringField;
    FilterResultFind: TDBISAMTable;
    FilterResultFindCat_id: TIntegerField;
    FilterResultFindCode: TStringField;
    FilterResultFindCode2: TStringField;
    FilterResultFindName: TStringField;
    FilterResultFindDescription: TStringField;
    FilterResultFindGroup_id: TIntegerField;
    FilterResultFindSubgroup_id: TIntegerField;
    FilterResultFindBrand_id: TIntegerField;
    FilterResultFindPrice: TCurrencyField;
    FilterResultFindT1: TIntegerField;
    FilterResultFindT2: TIntegerField;
    FilterResultFindTitle: TBooleanField;
    FilterResultFindSale: TStringField;
    FilterResultFindNew: TStringField;
    FilterResultFindTecdoc_id: TIntegerField;
    FilterResultFindMult: TIntegerField;
    FilterResultFindUsa: TStringField;
    ParamTableiUpdateTypeLoadQuants: TIntegerField;
    OrderDetTableTestQuants: TIntegerField;
    ParamTablebPasiveUpdateData: TBooleanField;
    ParamTablebPasiveUpdateAutoLoad: TBooleanField;
    FindBrand: TDBISAMTable;
    QuantTableSale: TStringField;
    QuantTablePrice: TCurrencyField;
    UpdateQuant: TDBISAMTable;
    UpdateQuantQuants: TStringField;
    UpdateQuantPRICE: TStringField;
    UpdateQuantSALE: TStringField;
    UpdateQuantsCode: TStringField;
    UpdateQuantsBrand: TStringField;
    _del_NomList: TDBISAMTable;
    LoadCatTableCat_id: TIntegerField;
    LoadCatTableCode: TStringField;
    LoadCatTableCode2: TStringField;
    LoadCatTableName: TStringField;
    LoadCatTableDescription: TStringField;
    LoadCatTableGroup_id: TIntegerField;
    LoadCatTableSubgroup_id: TIntegerField;
    LoadCatTableBrand_id: TIntegerField;
    LoadCatTablePrice: TCurrencyField;
    LoadCatTableT1: TSmallintField;
    LoadCatTableT2: TSmallintField;
    LoadCatTableTitle: TBooleanField;
    LoadCatTableSale: TStringField;
    LoadCatTableNew: TStringField;
    LoadCatTableTecdoc_id: TIntegerField;
    LoadCatTableMult: TIntegerField;
    LoadCatTableUsa: TStringField;
    LoadCatTablePrimen: TMemoField;
    LoadCatTablesBrand: TStringField;
    _del_NomListCat_id: TIntegerField;
    _del_NomListCode2: TStringField;
    _del_NomListsBrand: TStringField;
    XCatTablePriceItog: TCurrencyField;
    XCatTablePriceQuant: TCurrencyField;
    FilterResultPriceItog: TCurrencyField;
    FilterResultPriceQuant: TCurrencyField;
    FilterResultSaleQ: TStringField;
    AnalogTablesaleQCalc: TStringField;
    AnalogTableSaleQ: TStringField;
    AnalogTablePriceItog: TCurrencyField;
    AnalogTablePriceQuant: TCurrencyField;
    XCatTablesaleQCalc: TStringField;
    XCatTableSaleQ: TStringField;
    LoadCatTablePriceQuant: TCurrencyField;
    LoadCatTablePriceItog: TCurrencyField;
    LoadCatTableSaleQ: TStringField;
    LoadCatTablesaleQCalc: TStringField;
    ParamTablebSaveWithPrice: TBooleanField;
    QuerySelect: TDBISAMQuery;
    TimerSetCatFilter: TTimer;
    LockBrand: TDBISAMTable;
    LockBrandBrand: TStringField;
    AnalogTableLocked: TIntegerField;
    LockBrandID: TAutoIncField;
    LoadCatTableShortCode: TStringField;
    AnalogTableAn_ShortCode: TStringField;
    OETableShortOE: TStringField;
    ParamTablebSortOrderDet: TBooleanField;
    CatFilterTable: TDBISAMTable;
    CatFilterTableCat_id: TIntegerField;
    CatFilterTableGroup_id: TIntegerField;
    CatFilterTableSubgroup_id: TIntegerField;
    CatFilterTableBrand_id: TIntegerField;
    CatFilterTablePrice: TCurrencyField;
    CatFilterTableT1: TSmallintField;
    CatFilterTableT2: TSmallintField;
    CatFilterTableTitle: TBooleanField;
    CatFilterTableSale: TStringField;
    CatFilterTableNew: TStringField;
    CatFilterTableTecdoc_id: TIntegerField;
    CatFilterTableMult: TIntegerField;
    CatFilterTableUsa: TStringField;
    CatFilterTableSaleQ: TStringField;
    CatFilterTablePrice_pro: TCurrencyField;
    CatFilterTableName_Descr: TStringField;
    CatFilterTableGroupInfo: TStringField;
    CatFilterTablesaleQCalc: TStringField;
    CatFilterTablePriceQuant: TCurrencyField;
    CatFilterTablePriceItog: TCurrencyField;
    CatFilterTableGroup_descr: TStringField;
    CatFilterTableSubgrioupDescr: TStringField;
    CatFilterTablePrice_koef_eur: TCurrencyField;
    CatFilterTableOrdQuantity: TFloatField;
    CatFilterTableOrdQuantityStr: TStringField;
    CatFilterTableQuantity: TStringField;
    CatFilterTablePrice_koef: TFloatField;
    CatFilterTableDescription: TStringField;
    CatFilterTableName: TStringField;
    CatFilterTableCode2: TStringField;
    CatFilterTableCode: TStringField;
    ParamTablebVisibleRunningLine: TBooleanField;
    CatalogTableCat_id: TIntegerField;
    CatalogTableCode: TStringField;
    CatalogTableCode2: TStringField;
    CatalogTableName: TStringField;
    CatalogTableDescription: TStringField;
    CatalogTableGroup_id: TIntegerField;
    CatalogTableSubgroup_id: TIntegerField;
    CatalogTableBrand_id: TIntegerField;
    CatalogTablePrice: TCurrencyField;
    CatalogTableT1: TSmallintField;
    CatalogTableT2: TSmallintField;
    CatalogTableTitle: TBooleanField;
    CatalogTableSale: TStringField;
    CatalogTableNew: TStringField;
    CatalogTableTecdoc_id: TIntegerField;
    CatalogTableMult: TIntegerField;
    CatalogTableUsa: TStringField;
    CatalogTablePrimen: TMemoField;
    CatalogTableShortCode: TStringField;
    CatFilterTableBrandDescr: TStringField;
    SysParamTableTCPHost3: TStringField;
    BrDiscountTable: TDBISAMTable;
    BrDiscountTableId: TAutoIncField;
    BrDiscountTableBrand_descr: TStringField;
    BrDiscountTableDiscount: TFloatField;
    ShortSearchTable: TDBISAMTable;
    SysParamTableITNPort: TIntegerField;
    DoubleTableShort: TDBISAMTable;
    ShortSearchTableBrandName: TStringField;
    ShortSearchTableCat_id: TIntegerField;
    ShortSearchTableCode: TStringField;
    ShortSearchTableCode2: TStringField;
    ShortSearchTableName: TStringField;
    ShortSearchTableDescription: TStringField;
    ShortSearchTableGroup_id: TIntegerField;
    ShortSearchTableSubgroup_id: TIntegerField;
    ShortSearchTableBrand_id: TIntegerField;
    ShortSearchTablePrice: TCurrencyField;
    ShortSearchTableT1: TSmallintField;
    ShortSearchTableT2: TSmallintField;
    ShortSearchTableTitle: TBooleanField;
    ShortSearchTableSale: TStringField;
    ShortSearchTableNew: TStringField;
    ShortSearchTableTecdoc_id: TIntegerField;
    ShortSearchTableMult: TIntegerField;
    ShortSearchTableUsa: TStringField;
    ShortSearchTablePrimen: TMemoField;
    ShortSearchTableShortCode: TStringField;
    ShortSearchTableDescr: TStringField;
    DoubleTableShortCat_id: TIntegerField;
    DoubleTableShortCode: TStringField;
    DoubleTableShortCode2: TStringField;
    DoubleTableShortName: TStringField;
    DoubleTableShortDescription: TStringField;
    DoubleTableShortGroup_id: TIntegerField;
    DoubleTableShortSubgroup_id: TIntegerField;
    DoubleTableShortBrand_id: TIntegerField;
    DoubleTableShortPrice: TCurrencyField;
    DoubleTableShortT1: TSmallintField;
    DoubleTableShortT2: TSmallintField;
    DoubleTableShortTitle: TBooleanField;
    DoubleTableShortSale: TStringField;
    DoubleTableShortNew: TStringField;
    DoubleTableShortTecdoc_id: TIntegerField;
    DoubleTableShortMult: TIntegerField;
    DoubleTableShortUsa: TStringField;
    DoubleTableShortPrimen: TMemoField;
    DoubleTableShortShortCode: TStringField;
    DoubleTableShortBrandName: TStringField;
    DoubleTableShortDescr: TStringField;
    ParamTableHideTree: TBooleanField;
    ParamTableHideBrand: TBooleanField;
    ParamTableHideName: TBooleanField;
    ParamTableHideOE: TBooleanField;
    AssortmentExpansion: TDBISAMTable;
    AssortmentExpansionCode: TStringField;
    AssortmentExpansionCode2: TStringField;
    AssortmentExpansionBrand: TStringField;
    AssortmentExpansionDate: TStringField;
    AssortmentExpansionAmount: TIntegerField;
    AssortmentExpansionNameDescr: TStringField;
    AssortmentExpansionDataSource: TDataSource;
    AssortmentExpansionPrice: TCurrencyField;
    AssortmentExpansionPrice_koef: TCurrencyField;
    AssortmentExpansionArtQuant: TStringField;
    AssortmentExpansionArtSale: TIntegerField;
    AssortmentExpansionArtBrandId: TIntegerField;
    AssortmentExpansionPrice_koef_eur: TCurrencyField;
    WaitListTableData: TStringField;
    QueryFilter: TDBISAMQuery;
    CatFilterTableShortCode: TStringField;
    CatFilterTablePrice_koef_usd: TCurrencyField;
    CatFilterTablePrice_koef_rub: TCurrencyField;
    CatFilterTableBrandDescrView: TStringField;
    ColumnView: TDBISAMTable;
    ColumnViewCode: TBooleanField;
    ColumnViewBrandDescrView: TBooleanField;
    ColumnViewName_Descr: TBooleanField;
    ColumnViewPrice_koef: TBooleanField;
    ColumnViewPrice_koef_rub: TBooleanField;
    ColumnViewPrice_koef_usd: TBooleanField;
    ColumnViewPrice_koef_eur: TBooleanField;
    ColumnViewQuantity: TBooleanField;
    ColumnViewOrdQuantityStr: TBooleanField;
    ColumnViewSaleQ: TBooleanField;
    ColumnViewNew: TBooleanField;
    ColumnViewUsa: TStringField;
    ColumnViewDataSource: TDataSource;
    ParamTableColorRunString: TIntegerField;
    CatalogTableIDouble: TIntegerField;
    LoadCatTableIDouble: TIntegerField;
    CatFilterTableIDouble: TIntegerField;
    ParamTableUseMemory: TBooleanField;
    SysParamTableQuestionEmail: TStringField;
    ColumnViewID: TAutoIncField;
    AssortmentExpansionID: TAutoIncField;
    WaitListTablePost: TIntegerField;
    AssortmentExpansionPost: TIntegerField;
    LoadOE: TDBISAMTable;
    LoadOEID: TAutoIncField;
    LoadOECat_ID: TIntegerField;
    LoadOECode: TStringField;
    LoadOECode2: TStringField;
    LoadOEShortOE: TStringField;
    _del_OEMap: TDBISAMTable;
    _del_OEMapSIM: TStringField;
    _del_OEMapStartID: TIntegerField;
    _del_OEMapEndID: TIntegerField;
    _del_OEMapID: TAutoIncField;
    OESearchTableShortOE: TStringField;
    ReturnDocTable: TDBISAMTable;
    ReturnDocDetTable: TDBISAMTable;
    ReturnDocTableData: TDateField;
    ReturnDocTableNote: TStringField;
    ReturnDocTablePost: TIntegerField;
    ReturnDocTableType: TStringField;
    ReturnDocTableDataPos: TDateTimeField;
    ReturnDocTableClientName: TStringField;
    ReturnDocTableClientInfo: TStringField;
    ReturnDocDataSource: TDataSource;
    ReturnDocTableNum: TIntegerField;
    ReturnDocTableRetDoc_ID: TAutoIncField;
    ReturnDocDetDataSource: TDataSource;
    ReturnDocDetTableCode2: TStringField;
    ReturnDocDetTableBrand: TStringField;
    ReturnDocDetTableQuantity: TIntegerField;
    ReturnDocDetTableNote: TStringField;
    ReturnDocDetTableCode: TStringField;
    ReturnDocDetTableDescription: TStringField;
    ReturnDocDetTableID: TAutoIncField;
    ReturnDocDetTableRetDoc_ID: TIntegerField;
    ReturnDocTableSent_time: TDateTimeField;
    SysParamTableReturnDocEmail: TStringField;
    ParamTablebUpdateKursesWithQuants: TBooleanField;
    WaitListTableCat_ID: TIntegerField;
    AssortmentExpansionCat_Id: TIntegerField;
    ReturnDocDetTableCat_ID: TIntegerField;
    ParamTableEur_rub_rate: TCurrencyField;
    OrderTableDelivery: TIntegerField;
    OrderDetTableCat_id: TIntegerField;
    AnalogOrderDet: TDBISAMTable;
    AnalogOrderDetId: TAutoIncField;
    AnalogOrderDetCat_id: TIntegerField;
    AnalogOrderDetAn_code: TStringField;
    AnalogOrderDetAn_brand: TStringField;
    AnalogOrderDetAn_id: TIntegerField;
    AnalogOrderDetLocked: TIntegerField;
    AnalogOrderDetAn_ShortCode: TStringField;
    AnalogOrderDetQuant: TStringField;
    AnalogOrderDetSaleQ: TStringField;
    AnalogOrderDetPrice: TCurrencyField;
    AnalogOrderDetBrand_id: TIntegerField;
    XCatTablePrimen: TMemoField;
    ReturnDocTableSign: TStringField;
    QuantTableQuantNew: TStringField;
    UpdateQuantQuantNew: TStringField;
    CatFilterTableQuantNew: TStringField;
    ColumnViewQuantNew: TBooleanField;
    CatalogTablepict_id: TIntegerField;
    CatFilterTablepict_id: TIntegerField;
    LoadCatTablepict_id: TIntegerField;
    CatFilterTabletyp_tdid: TIntegerField;
    CatFilterTableparam_tdid: TIntegerField;
    CatalogTabletyp_tdid: TIntegerField;
    CatalogTableparam_tdid: TIntegerField;
    LoadCatTabletyp_tdid: TIntegerField;
    LoadCatTableparam_tdid: TIntegerField;
    OrderTableCurrency: TIntegerField;
    ParamTableHide_update_report: TBooleanField;
    adoOLEDB: TADOConnection;
    msQuery: TADOQuery;
    UpdateAnalogDel: TDBISAMTable;
    OETableSIMB: TSmallintField;
    OESearchTableSIMB: TSmallintField;
    PriceList: TDBISAMTable;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    StringField2: TStringField;
    PriceListsName: TStringField;
    PriceListsDescr: TStringField;
    UpdateQuant2: TDBISAMTable;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField9: TStringField;
    UpdateQuant2brand_id: TIntegerField;
    memBrand: TDBISAMTable;
    memBrandBrand_id: TIntegerField;
    memBrandDescription: TStringField;
    ReturnDocDetTableOrdered: TSmallintField;
    CatFilterTableBrandDescrRepl: TStringField;
    AnalogTableAn_brand_repl: TStringField;
    WaitListTableBrandRepl: TStringField;
    ReturnDocDetTableBrandRepl: TStringField;
    AssortmentExpansionBrandRepl: TStringField;
    memAnalog: TDBISAMTable;
    memAnalogAn_code: TStringField;
    memAnalogPrice_koef: TCurrencyField;
    memAnalogQuantity: TStringField;
    memAnalogNew: TStringField;
    memAnalogName_Descr: TStringField;
    memAnalogOrdQuantityStr: TStringField;
    memAnalogUsa: TStringField;
    memAnalogSaleQ: TStringField;
    memAnalogAn_brand_repl: TStringField;
    memAnalogId: TAutoIncField;
    memAnalogDataSource: TDataSource;
    memAnalogQuantityCalc: TIntegerField;
    OrderTableCli_id: TStringField;
    ReturnDocTableCli_id: TStringField;
    DiscountTable: TDBISAMTable;
    DiscountTableID: TAutoIncField;
    DiscountTableCLI_ID: TStringField;
    DiscountTableGR_ID: TIntegerField;
    DiscountTableSUBGR_ID: TIntegerField;
    DiscountTableBRAND_ID: TIntegerField;
    DiscountTableDiscount: TFloatField;
    DiscountTableMargin: TFloatField;
    DiscountTablebDelete: TIntegerField;
    DiscountTableUpdateDisc: TBooleanField;
    Query: TDBISAMQuery;
    Notes: TDBISAMTable;
    NotesID: TAutoIncField;
    NotesDate: TDateTimeField;
    NotesNote: TMemoField;
    ColumnViewPrice_pro: TBooleanField;
    AnalogTableAn_group_id: TIntegerField;
    nom: TDBISAMTable;
    IntegerField2: TIntegerField;
    StringField3: TStringField;
    nombrand_id: TIntegerField;
    ParamTableShowAllOrders: TBooleanField;
    OrderTableClientLookup: TStringField;
    ReturnDocTableClientLookup: TStringField;
    SysParamTableUpdateMirrors: TStringField;
    ParamTableAutoSwitchCurClient: TBooleanField;
    memQuants: TDBISAMTable;
    memQuantsCAT_ID: TIntegerField;
    QuantTableLatest: TIntegerField;
    CatFilterTableQuantLatest: TIntegerField;
    OrderDetTableArtGroupId: TIntegerField;
    OrderDetTableArtSubgroupId: TIntegerField;
    WaitListTableArtGroupId: TIntegerField;
    WaitListTableArtSubgroupId: TIntegerField;
    WaitListTableArtQuantLatest: TIntegerField;
    AssortmentExpansionArtGroupId: TIntegerField;
    AssortmentExpansionArtSubgroupId: TIntegerField;
    memAnalogQuantLatest: TIntegerField;
    AnalogTableQuantLatest: TIntegerField;
    OrderDetTableprice_pro: TCurrencyField;
    OrderDetTableprice_pro_koef: TCurrencyField;
    OrderDetTableSum_pro: TCurrencyField;
    OrderTablesum_pro: TCurrencyField;
    OrderTableTcpAnswer: TBlobField;
    ReturnDocTableTcpAnswer: TBlobField;
    OrderTableTcpAnswerZam: TBlobField;
    OrderTableIsDeliveredCalc: TBooleanField;
    ParamTableAutoCheckOrders: TBooleanField;
    ParamTableAutoCheckDiscounts: TBooleanField;
    ParamTableAutoCheckStatuses: TBooleanField;
    ParamTableAutoCheckOrdersInt: TIntegerField;
    ParamTableAutoCheckDiscountsInt: TIntegerField;
    ParamTableAutoCheckStatusesInt: TIntegerField;
    OrderTableIsDelivered: TIntegerField;
    ParamTableRounding: TStringField;
    XCatTableName_Descr: TStringField;
    AnalogOrderDetDescr: TStringField;
    memKK: TDBISAMTable;
    memKKCat_Id: TIntegerField;
    memKKBrand_Id: TIntegerField;
    memKKGroup_Id: TIntegerField;
    memKKSubGroup_Id: TIntegerField;
    KK: TDBISAMTable;
    KKId: TAutoIncField;
    KKCode2: TStringField;
    KKBrand: TStringField;
    KKCode: TStringField;
    KKDescr: TStringField;
    KKPrice: TCurrencyField;
    KKPrice_koef: TCurrencyField;
    KKPrice_pro: TCurrencyField;
    KKCat_Id: TIntegerField;
    KKBrand_Id: TIntegerField;
    KKGroup_Id: TIntegerField;
    KKSubGroup_Id: TIntegerField;
    KKDataSource: TDataSource;
    SysParamTableDeliveryPhone: TStringField;
    ParamTableAutoCheckRss: TBooleanField;
    ParamTableAutoCheckRssInt: TIntegerField;
    ParamTablebShowRssOnUpdate: TBooleanField;
    DataSourceReturnDocDet: TDataSource;
    TableReturnDocDet: TDBISAMTable;
    TableReturnDocDetId: TAutoIncField;
    TableReturnDocDetReturnDocId: TIntegerField;
    TableReturnDocDetCode: TStringField;
    TableReturnDocDetBrand: TStringField;
    TableReturnDocDetCol: TIntegerField;
    TableReturnDocDetDescription: TStringField;
    TableReturnDocDetPrice: TFloatField;
    TableReturnDocDetComments: TStringField;
    DataSourceReturnDoc: TDataSource;
    TableReturnDoc: TDBISAMTable;
    TableReturnDocId: TAutoIncField;
    TableReturnDocState: TIntegerField;
    TableReturnDocDate: TDateField;
    TableReturnDocComents: TStringField;
    TableReturnDocSumm: TFloatField;
    DataSourceSaleOrderDet: TDataSource;
    TableSaleOrderDet: TDBISAMTable;
    TableSaleOrderDetId: TAutoIncField;
    TableSaleOrderDetCode: TStringField;
    TableSaleOrderDetBrand: TStringField;
    TableSaleOrderDetCol: TIntegerField;
    TableSaleOrderDetDescription: TStringField;
    TableSaleOrderDetPrice: TStringField;
    TableSaleOrderDetSaleOrderID: TIntegerField;
    TableSaleOrderDetComments: TStringField;
    TableSaleOrderDetSumm: TCurrencyField;
    DataSourceSaleOrder: TDataSource;
    TableSaleOrder: TDBISAMTable;
    TableSaleOrderDate: TDateField;
    TableSaleOrderComment: TStringField;
    TableSaleOrderState: TIntegerField;
    TableSaleOrderSaleOrderID: TAutoIncField;
    TableSaleOrderSumm: TStringField;
    DataSourceDocLimitDet: TDataSource;
    TableDocLimitDet: TDBISAMTable;
    TableDocLimitDetID: TAutoIncField;
    TableDocLimitDetCode: TStringField;
    TableDocLimitDetOldValue: TIntegerField;
    TableDocLimitDetNewValue: TIntegerField;
    TableDocLimitDetBrand: TStringField;
    TableDocLimitDetDocLimitID: TIntegerField;
    TableDocLimitDetDescription: TStringField;
    DataSourceDocLimit: TDataSource;
    TableDocLimit: TDBISAMTable;
    TableDocLimitDate: TDateField;
    TableDocLimitState: TIntegerField;
    TableDocLimitDocLimitID: TAutoIncField;
    SourceBases: TDataSource;
    TableBases: TDBISAMTable;
    TableBasesID: TIntegerField;
    TableBasesName: TStringField;
    TableBasesMaskName: TStringField;
    TableBasesActivate: TIntegerField;
    TableBasesBasic: TIntegerField;
    TableBasesFileName: TStringField;
    TableBasesCode: TIntegerField;
    TableBasesCclient: TStringField;
    xSaleOrderDet: TDBISAMTable;
    xReturnDoc: TDBISAMTable;
    QuantTable7: TDBISAMTable;
    QuantTable7Id: TAutoIncField;
    QuantTable7Cat_Id: TIntegerField;
    QuantTable7Limit: TIntegerField;
    QuantTable16: TDBISAMTable;
    QuantTable16Id: TAutoIncField;
    QuantTable16Cat_id: TIntegerField;
    QuantTable16Limit: TIntegerField;
    QuantTable15: TDBISAMTable;
    QuantTable15Id: TAutoIncField;
    QuantTable15Cat_id: TIntegerField;
    QuantTable15Limit: TIntegerField;
    QuantTable14: TDBISAMTable;
    QuantTable14Id: TAutoIncField;
    QuantTable14Cat_id: TIntegerField;
    QuantTable14Limit: TIntegerField;
    QuantTable13: TDBISAMTable;
    QuantTable13Id: TAutoIncField;
    QuantTable13Cat_id: TIntegerField;
    QuantTable13Limit: TIntegerField;
    QuantTable12: TDBISAMTable;
    QuantTable12Id: TAutoIncField;
    QuantTable12Cat_id: TIntegerField;
    QuantTable12Limit: TIntegerField;
    QuantTable11: TDBISAMTable;
    QuantTable11Id: TAutoIncField;
    QuantTable11Cat_id: TIntegerField;
    QuantTable11Limit: TIntegerField;
    QuantTable10: TDBISAMTable;
    QuantTable10Id: TAutoIncField;
    QuantTable10Cat_id: TIntegerField;
    QuantTable10Limit: TIntegerField;
    QuantTable9: TDBISAMTable;
    QuantTable9Id: TAutoIncField;
    QuantTable9Cat_id: TIntegerField;
    QuantTable9Limit: TIntegerField;
    QuantTable8: TDBISAMTable;
    QuantTable8Id: TAutoIncField;
    QuantTable8Cat_id: TIntegerField;
    QuantTable8Limit: TIntegerField;
    QuantTable6: TDBISAMTable;
    QuantTable6Id: TAutoIncField;
    QuantTable6Cat_id: TIntegerField;
    QuantTable6Limit: TIntegerField;
    QuantTable5: TDBISAMTable;
    QuantTable5Id: TAutoIncField;
    QuantTable5Cat_id: TIntegerField;
    QuantTable5Limit: TIntegerField;
    QuantTable4: TDBISAMTable;
    QuantTable4Id: TAutoIncField;
    QuantTable4Cat_id: TIntegerField;
    QuantTable4Limit: TIntegerField;
    QuantTable3: TDBISAMTable;
    QuantTable3Id: TAutoIncField;
    QuantTable3Cat_id: TIntegerField;
    QuantTable3Limit: TIntegerField;
    QuantTable2: TDBISAMTable;
    QuantTable2Id: TAutoIncField;
    QuantTable2Cat_id: TIntegerField;
    QuantTable2Limit: TIntegerField;
    ParamTableColorSaleOrder: TIntegerField;
    ParamTableColorOrder: TIntegerField;
    ParamTableColorLimit: TIntegerField;
    ParamTableColorReturnOrder: TIntegerField;
    ParamTableColorReturnPost: TIntegerField;
    ParamTableBasicTextFont: TStringField;
    ParamTableBasicColor: TIntegerField;
    CatFilterTableBasic: TStringField;
    CatFilterTableReserve: TIntegerField;
    AnalogTableBasic: TStringField;
    AnalogTableReserve: TIntegerField;
    memAnalogQuantLocal: TFloatField;
    memAnalogBasic: TStringField;
    memAnalogReserve: TIntegerField;
    QueryStock: TDBISAMQuery;
    SysParamTableMaxDiscount: TIntegerField;
    ParamTableToForbidSalelOrder: TBooleanField;
    ParamTableToForbidReturnOrder: TBooleanField;
    ParamTableToForbidLimit: TBooleanField;
    ParamTableToForbidReturnDocPost: TBooleanField;
    VersionTablequants2: TStringField;
    VersionTablequants3: TStringField;
    VersionTablequants4: TStringField;
    VersionTablequants5: TStringField;
    VersionTablequants6: TStringField;
    VersionTablequants7: TStringField;
    VersionTablequants8: TStringField;
    VersionTablequants9: TStringField;
    VersionTablequants10: TStringField;
    VersionTablequants11: TStringField;
    VersionTablequants12: TStringField;
    VersionTablequants13: TStringField;
    VersionTablequants14: TStringField;
    VersionTablequants15: TStringField;
    VersionTablequants16: TStringField;
    UpdateQuant2Limit: TIntegerField;
    QuantTableJoin: TDBISAMTable;
    QuantTableJoinCAT_ID: TIntegerField;
    QuantTableJoinQ2: TFloatField;
    QuantTableJoinQ3: TFloatField;
    QuantTableJoinQ4: TFloatField;
    QuantTableJoinQ5: TFloatField;
    QuantTableJoinQ6: TFloatField;
    QuantTableJoinQ7: TFloatField;
    QuantTableJoinQ8: TFloatField;
    QuantTableJoinQ9: TFloatField;
    QuantTableJoinQ10: TFloatField;
    QuantTableJoinQ11: TFloatField;
    QuantTableJoinQ12: TFloatField;
    QuantTableJoinQ13: TFloatField;
    QuantTableJoinQ14: TFloatField;
    QuantTableJoinQ15: TFloatField;
    QuantTableJoinQ16: TFloatField;
    ParamTablebQuantsInGrid: TBooleanField;
    SysParamTableEmailReturn: TStringField;
    SysParamTableEmailRetSaleOrder: TStringField;
    SysParamTableEmailSaleOrder: TStringField;
    SysParamTableEmailLimit: TStringField;
    ParamTablebApplyColorQuantsShate: TBooleanField;
    ParamTablebApplyColorQuantsBase: TBooleanField;
    QuantTable17: TDBISAMTable;
    QuantTable20: TDBISAMTable;
    QuantTable18: TDBISAMTable;
    QuantTable21: TDBISAMTable;
    QuantTable19: TDBISAMTable;
    QuantTable22: TDBISAMTable;
    QuantTableJoinQ17: TFloatField;
    QuantTableJoinQ18: TFloatField;
    QuantTableJoinQ19: TFloatField;
    QuantTableJoinQ20: TFloatField;
    QuantTableJoinQ21: TFloatField;
    QuantTableJoinQ22: TFloatField;
    QuantTable17Id: TAutoIncField;
    QuantTable17Cat_id: TIntegerField;
    QuantTable17Limit: TIntegerField;
    QuantTable18Id: TAutoIncField;
    QuantTable18Cat_id: TIntegerField;
    QuantTable18Limit: TIntegerField;
    QuantTable19Id: TAutoIncField;
    QuantTable19Cat_id: TIntegerField;
    QuantTable19Limit: TIntegerField;
    QuantTable20Id: TAutoIncField;
    QuantTable20Cat_id: TIntegerField;
    QuantTable20Limit: TIntegerField;
    QuantTable21Id: TAutoIncField;
    QuantTable21Cat_id: TIntegerField;
    QuantTable21Limit: TIntegerField;
    QuantTable22Id: TAutoIncField;
    QuantTable22Cat_id: TIntegerField;
    QuantTable22Limit: TIntegerField;
    VersionTablequants17: TStringField;
    VersionTablequants18: TStringField;
    VersionTablequants19: TStringField;
    VersionTablequants20: TStringField;
    VersionTablequants21: TStringField;
    VersionTablequants22: TStringField;
    VersionTableTecdocVersion: TStringField;
    LoadArtTypTableAuto: TDBISAMTable;
    SysParamTableTCPHostOpt: TStringField;
    OOTable: TDBISAMTable;
    IntegerField3: TIntegerField;
    OOTableIsOrder: TBooleanField;
    KitDataSource: TDataSource;
    KitTable: TDBISAMTable;
    KitTableID: TAutoIncField;
    KitTableCAT_ID: TIntegerField;
    KitTableCHILD_CODE: TStringField;
    KitTableCHILD_BRAND: TStringField;
    KitTableCHILD_ID: TIntegerField;
    KitTableQUANTITY: TIntegerField;
    KitTableDescr: TStringField;
    KitTablePrice_koef_eur: TCurrencyField;
    KitTablePrice_koef: TCurrencyField;
    KitTableprice_koef_sum: TCurrencyField;
    KitTableQUANT_CAT: TStringField;
    KitTablePriceProEur: TCurrencyField;
    KitTablePriceProEur_sum: TCurrencyField;
    KitTablePriceEur: TCurrencyField;
    memProfit: TDBISAMTable;
    memProfitPriceFrom: TFloatField;
    memProfitPriceTo: TFloatField;
    memProfitProfit: TFloatField;
    VersionTableAssemblyVersion: TStringField;
    ParamTableSetDateRate: TIntegerField;
    OrderDetTableMult: TIntegerField;
    OrderDetTableCheckField: TBooleanField;
    KKBrandDescrRepl: TStringField;
    OrderDetTableBrandRepl: TStringField;
    WaitListTableCli_id: TStringField;
    CatFilterTableOrderOnly: TBooleanField;
    AnalogTableOrderOnly: TBooleanField;
    memAnalogOrderOnly: TBooleanField;
    WaitListTableDateCreate: TDateField;
    WaitListTableClientInfo: TStringField;
    WaitListTableClientLookup: TStringField;
    ReturnDocDetTableCheckField: TBooleanField;
    ClIDsTable: TDBISAMTable;
    ClIDsTableId: TAutoIncField;
    ClIDsTableClient_ID: TStringField;
    ClIDsTableDescription: TStringField;
    ClIDsTableOrder_type: TStringField;
    ClIDsTableDelivery: TIntegerField;
    ClIDsTableByDefault: TIntegerField;
    ClIDsTableemail: TStringField;
    ClIDsTableKey: TStringField;
    ClIDsTableUpdateDisc: TBooleanField;
    ClIDsTableDiscountVersion: TIntegerField;
    ClIDsTableUseDiffMargin: TBooleanField;
    ClIDsTableDiffMargin: TStringField;
    OrderTablepopular: TIntegerField;
    VersionTableTiresVersion: TStringField;
    DBISAMTable1: TDBISAMTable;
    AutoIncField1: TAutoIncField;
    IntegerField4: TIntegerField;
    MemoField1: TMemoField;
    DBISAMTable2: TDBISAMTable;
    TiresCarMake: TDBISAMTable;
    TiresCarMakemark_id: TIntegerField;
    TiresCarMakemark: TStringField;
    TiresCarModel: TDBISAMTable;
    TiresCarModelmodel_id: TIntegerField;
    TiresCarModelmodel: TStringField;
    TiresCarModelmark_id: TIntegerField;
    TiresCarEngine: TDBISAMTable;
    TiresCarEngineengine_id: TSmallintField;
    TiresCarEngineEngine: TStringField;
    TiresCarEnginemodel_id: TIntegerField;
    TiresDimensions: TDBISAMTable;
    TiresDimensionsid: TIntegerField;
    TiresDimensionsengine_id: TIntegerField;
    TiresDimensionsdimensions: TStringField;
    TiresDimensionsunique: TSmallintField;
    DS_TiresCarMake: TDataSource;
    DS_TiresCarModel: TDataSource;
    DS_TiresCarEngine: TDataSource;
    DS_TiresDimensions: TDataSource;
    VersionTableTypVersion: TStringField;
    TableBasesCurrency: TStringField;
    QuantTable2Price: TCurrencyField;
    QuantTable7Price: TCurrencyField;
    QuantTable12Price: TCurrencyField;
    QuantTable3Price: TCurrencyField;
    QuantTable8Price: TCurrencyField;
    QuantTable13Price: TCurrencyField;
    QuantTable4Price: TCurrencyField;
    QuantTable9Price: TCurrencyField;
    QuantTable14Price: TCurrencyField;
    QuantTable5Price: TCurrencyField;
    QuantTable10Price: TCurrencyField;
    QuantTable15Price: TCurrencyField;
    QuantTable6Price: TCurrencyField;
    QuantTable11Price: TCurrencyField;
    QuantTable16Price: TCurrencyField;
    QuantTable17Price: TCurrencyField;
    QuantTable18Price: TCurrencyField;
    QuantTable19Price: TCurrencyField;
    QuantTable20Price: TCurrencyField;
    QuantTable21Price: TCurrencyField;
    QuantTable22Price: TCurrencyField;
    QuantTable11Quantity: TStringField;
    QuantTable10Quantity: TStringField;
    QuantTable2Quantity: TStringField;
    QuantTable7Quantity: TStringField;
    QuantTable12Quantity: TStringField;
    QuantTable3Quantity: TStringField;
    QuantTable8Quantity: TStringField;
    QuantTable13Quantity: TStringField;
    QuantTable4Quantity: TStringField;
    QuantTable9Quantity: TStringField;
    QuantTable14Quantity: TStringField;
    QuantTable5Quantity: TStringField;
    QuantTable15Quantity: TStringField;
    QuantTable6Quantity: TStringField;
    QuantTable16Quantity: TStringField;
    QuantTable17Quantity: TStringField;
    QuantTable19Quantity: TStringField;
    QuantTable20Quantity: TStringField;
    QuantTable22Quantity: TStringField;
    QuantTable18Quantity: TStringField;
    QuantTable21Quantity: TStringField;
    CatFilterTableLimitsCalc: TStringField;
    CatFilterTablePriceQuantSklad: TCurrencyField;
    SkladQuants: TDBISAMTable;
    IntegerField5: TIntegerField;
    SkladQuantsPRICE: TCurrencyField;
    SkladQuantsL2: TIntegerField;
    SkladQuantsL3: TIntegerField;
    SkladQuantsL4: TIntegerField;
    SkladQuantsL5: TIntegerField;
    SkladQuantsL6: TIntegerField;
    SkladQuantsL7: TIntegerField;
    SkladQuantsL8: TIntegerField;
    SkladQuantsL9: TIntegerField;
    SkladQuantsL10: TIntegerField;
    SkladQuantsL11: TIntegerField;
    SkladQuantsL12: TIntegerField;
    SkladQuantsL13: TIntegerField;
    SkladQuantsL14: TIntegerField;
    SkladQuantsL15: TIntegerField;
    SkladQuantsL16: TIntegerField;
    SkladQuantsL17: TIntegerField;
    SkladQuantsL18: TIntegerField;
    SkladQuantsL19: TIntegerField;
    SkladQuantsL20: TIntegerField;
    SkladQuantsL21: TIntegerField;
    SkladQuantsL22: TIntegerField;
    SkladQuantsQ2: TStringField;
    SkladQuantsQ3: TStringField;
    SkladQuantsQ4: TStringField;
    SkladQuantsQ5: TStringField;
    SkladQuantsQ6: TStringField;
    SkladQuantsQ7: TStringField;
    SkladQuantsQ8: TStringField;
    SkladQuantsQ9: TStringField;
    SkladQuantsQ10: TStringField;
    SkladQuantsQ11: TStringField;
    SkladQuantsQ12: TStringField;
    SkladQuantsQ13: TStringField;
    SkladQuantsQ14: TStringField;
    SkladQuantsQ15: TStringField;
    SkladQuantsQ16: TStringField;
    SkladQuantsQ17: TStringField;
    SkladQuantsQ18: TStringField;
    SkladQuantsQ19: TStringField;
    SkladQuantsQ20: TStringField;
    SkladQuantsQ21: TStringField;
    SkladQuantsQ22: TStringField;
    VersionTablequants_all: TStringField;
    AnalogIDTable: TDBISAMTable;
    AnalogIDTableGen_An_id: TIntegerField;
    AnalogIDTableCat_id: TIntegerField;
    AnalogMainTable_1: TDBISAMTable;
    AnalogMainTable_1Gen_An_id: TIntegerField;
    AnalogMainTable_1An_code: TStringField;
    AnalogMainTable_1An_brand: TStringField;
    AnalogMainTable_1An_id: TIntegerField;
    AnalogMainTable_1Description: TStringField;
    AnalogMainTable_1Price: TCurrencyField;
    AnalogMainTable_1Price_koef: TCurrencyField;
    AnalogMainTable_1An_group_id: TIntegerField;
    AnalogMainTable_1An_subgroup_id: TIntegerField;
    AnalogMainTable_1Quantity: TStringField;
    AnalogMainTable_1An_sale: TStringField;
    AnalogMainTable_1An_new: TStringField;
    AnalogMainTable_1An_usa: TStringField;
    AnalogMainTable_1Sale: TStringField;
    AnalogMainTable_1New: TStringField;
    AnalogMainTable_1Name: TStringField;
    AnalogMainTable_1Name_Descr: TStringField;
    AnalogMainTable_1An_Brand_id: TIntegerField;
    AnalogMainTable_1Mult: TIntegerField;
    AnalogMainTable_1Price_koef_eur: TCurrencyField;
    AnalogMainTable_1OrdQuantity: TFloatField;
    AnalogMainTable_1OrdQuantityStr: TStringField;
    AnalogMainTable_1Price_pro: TCurrencyField;
    AnalogMainTable_1Usa: TStringField;
    AnalogMainTable_1saleQCalc: TStringField;
    AnalogMainTable_1SaleQ: TStringField;
    AnalogMainTable_1PriceItog: TCurrencyField;
    AnalogMainTable_1PriceQuant: TCurrencyField;
    AnalogMainTable_1Locked: TIntegerField;
    AnalogMainTable_1An_ShortCode: TStringField;
    AnalogMainTable_1An_brand_repl: TStringField;
    AnalogMainTable_1QuantLatest: TIntegerField;
    AnalogMainTable_1OrderOnly: TBooleanField;
    AnalogMainTable_2: TDBISAMTable;
    IntegerField6: TIntegerField;
    StringField8: TStringField;
    StringField10: TStringField;
    IntegerField7: TIntegerField;
    StringField11: TStringField;
    CurrencyField1: TCurrencyField;
    CurrencyField2: TCurrencyField;
    IntegerField8: TIntegerField;
    IntegerField9: TIntegerField;
    StringField12: TStringField;
    StringField13: TStringField;
    StringField14: TStringField;
    StringField15: TStringField;
    StringField16: TStringField;
    StringField17: TStringField;
    StringField18: TStringField;
    StringField19: TStringField;
    IntegerField10: TIntegerField;
    IntegerField11: TIntegerField;
    CurrencyField3: TCurrencyField;
    FloatField1: TFloatField;
    StringField20: TStringField;
    CurrencyField4: TCurrencyField;
    StringField21: TStringField;
    StringField22: TStringField;
    StringField23: TStringField;
    CurrencyField5: TCurrencyField;
    CurrencyField6: TCurrencyField;
    IntegerField12: TIntegerField;
    StringField24: TStringField;
    StringField25: TStringField;
    IntegerField13: TIntegerField;
    BooleanField1: TBooleanField;
    AnalogMainTable_3: TDBISAMTable;
    IntegerField14: TIntegerField;
    StringField26: TStringField;
    StringField27: TStringField;
    IntegerField15: TIntegerField;
    StringField28: TStringField;
    CurrencyField7: TCurrencyField;
    CurrencyField8: TCurrencyField;
    IntegerField16: TIntegerField;
    IntegerField17: TIntegerField;
    StringField29: TStringField;
    StringField30: TStringField;
    StringField31: TStringField;
    StringField32: TStringField;
    StringField33: TStringField;
    StringField34: TStringField;
    StringField35: TStringField;
    StringField36: TStringField;
    IntegerField18: TIntegerField;
    IntegerField19: TIntegerField;
    CurrencyField9: TCurrencyField;
    FloatField2: TFloatField;
    StringField37: TStringField;
    CurrencyField10: TCurrencyField;
    StringField38: TStringField;
    StringField39: TStringField;
    StringField40: TStringField;
    CurrencyField11: TCurrencyField;
    CurrencyField12: TCurrencyField;
    IntegerField20: TIntegerField;
    StringField41: TStringField;
    StringField42: TStringField;
    IntegerField21: TIntegerField;
    BooleanField2: TBooleanField;
    AnalogMainTable_4: TDBISAMTable;
    IntegerField22: TIntegerField;
    StringField43: TStringField;
    StringField44: TStringField;
    IntegerField23: TIntegerField;
    StringField45: TStringField;
    CurrencyField13: TCurrencyField;
    CurrencyField14: TCurrencyField;
    IntegerField24: TIntegerField;
    IntegerField25: TIntegerField;
    StringField46: TStringField;
    StringField47: TStringField;
    StringField48: TStringField;
    StringField49: TStringField;
    StringField50: TStringField;
    StringField51: TStringField;
    StringField52: TStringField;
    StringField53: TStringField;
    IntegerField26: TIntegerField;
    IntegerField27: TIntegerField;
    CurrencyField15: TCurrencyField;
    FloatField3: TFloatField;
    StringField54: TStringField;
    CurrencyField16: TCurrencyField;
    StringField55: TStringField;
    StringField56: TStringField;
    StringField57: TStringField;
    CurrencyField17: TCurrencyField;
    CurrencyField18: TCurrencyField;
    IntegerField28: TIntegerField;
    StringField58: TStringField;
    StringField59: TStringField;
    IntegerField29: TIntegerField;
    BooleanField3: TBooleanField;
    AnalogMainTable_5: TDBISAMTable;
    IntegerField30: TIntegerField;
    StringField60: TStringField;
    StringField61: TStringField;
    IntegerField31: TIntegerField;
    StringField62: TStringField;
    CurrencyField19: TCurrencyField;
    CurrencyField20: TCurrencyField;
    IntegerField32: TIntegerField;
    IntegerField33: TIntegerField;
    StringField63: TStringField;
    StringField64: TStringField;
    StringField65: TStringField;
    StringField66: TStringField;
    StringField67: TStringField;
    StringField68: TStringField;
    StringField69: TStringField;
    StringField70: TStringField;
    IntegerField34: TIntegerField;
    IntegerField35: TIntegerField;
    CurrencyField21: TCurrencyField;
    FloatField4: TFloatField;
    StringField71: TStringField;
    CurrencyField22: TCurrencyField;
    StringField72: TStringField;
    StringField73: TStringField;
    StringField74: TStringField;
    CurrencyField23: TCurrencyField;
    CurrencyField24: TCurrencyField;
    IntegerField36: TIntegerField;
    StringField75: TStringField;
    StringField76: TStringField;
    IntegerField37: TIntegerField;
    BooleanField4: TBooleanField;
    OEDescrSearchTable: TDBISAMTable;
    OEDescrSearchTablegen_oe_id: TIntegerField;
    StringField77: TStringField;
    StringField79: TStringField;
    SmallintField1: TSmallintField;
    OEIDTable: TDBISAMTable;
    OEIDTableGen_oe_id: TIntegerField;
    IntegerField38: TIntegerField;
    OEDescrTable: TDBISAMTable;
    IntegerField39: TIntegerField;
    StringField78: TStringField;
    StringField80: TStringField;
    SmallintField2: TSmallintField;
    OEIDSearchTable: TDBISAMTable;
    IntegerField40: TIntegerField;
    IntegerField41: TIntegerField;
    DS_OESearch: TDataSource;
    DS_OE: TDataSource;
    AutoMakerTable: TDBISAMTable;
    AutoMakerTableID: TAutoIncField;
    AutoMakerTableAutoMaker: TStringField;
    memAnalogAn_id: TIntegerField;
    memAnalogAn_group_id: TIntegerField;
    memAnalogAn_subgroup_id: TIntegerField;
    memAnalogAn_Brand_id: TIntegerField;
    memAnalogMult: TIntegerField;
    memAnalogPrice_koef_eur: TCurrencyField;
    memAnalogAn_brand: TStringField;
    memAnalogPriceItog: TCurrencyField;
    AnalogMainTable_1Reserve: TIntegerField;
    AnalogMainTable_2Reserve: TIntegerField;
    AnalogMainTable_3Reserve: TIntegerField;
    AnalogMainTable_4Reserve: TIntegerField;
    AnalogMainTable_5Reserve: TIntegerField;
    AnalogMainTable_1StringField: TStringField;
    AnalogMainTable_2StringField: TStringField;
    AnalogMainTable_3StringField: TStringField;
    AnalogMainTable_4StringField: TStringField;
    AnalogMainTable_5StringField: TStringField;
    VersionTablePictsVersion: TMemoField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure SessionPassword(Sender: TObject; var Continue: Boolean);
    procedure OrderDetTableCalcFields(DataSet: TDataSet);
    procedure OrderTableCalcFields(DataSet: TDataSet);
    procedure AnalogTableCalcFields(DataSet: TDataSet);
    procedure OrderTableAfterScroll(DataSet: TDataSet);
    procedure CatalogTableAfterScroll(DataSet: TDataSet);
    procedure TableExpImpProgress(Sender: TObject; PercentDone: Word);
    procedure SearchDoubleTimerTimer(Sender: TObject);
    procedure DoubleTableCalcFields(DataSet: TDataSet);
    procedure WaitListTableCalcFields(DataSet: TDataSet);
    procedure WaitListTableFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure TextAttrTableCalcFields(DataSet: TDataSet);
    procedure NetTimerTimer(Sender: TObject);
    procedure TypesTableCalcFields(DataSet: TDataSet);
    procedure LoadTimerTimer(Sender: TObject);
    procedure ModelsTableCalcFields(DataSet: TDataSet);
    procedure PrimenTableAfterScroll(DataSet: TDataSet);
    procedure AnalogTableAfterScroll(DataSet: TDataSet);
    procedure SysParamTableHostChange(Sender: TField);
    procedure LoadLotusTitles(st: integer);
    procedure CatalogTable_2CalcFields(DataSet: TDataSet);
  //  procedure TestQueryQueryProgress(Sender: TObject; PercentDone: Word;var Abort: Boolean);
    procedure QuerySelectQueryProgress(Sender: TObject; PercentDone: Word;
      var Abort: Boolean);
    procedure FilterResultCalcFields(DataSet: TDataSet);
    procedure FilterResultAfterScroll(DataSet: TDataSet);
    procedure QuantQueryQueryProgress(Sender: TObject; PercentDone: Word;
      var Abort: Boolean);
    procedure XCatTableCalcFields(DataSet: TDataSet);
    procedure LoadCatTableCalcFields(DataSet: TDataSet);
    procedure TimerSetCatFilterTimer(Sender: TObject);
    procedure CatFilterTableCalcFields(DataSet: TDataSet);
    procedure DoubleTableShortCalcFields(DataSet: TDataSet);
    procedure AssortmentExpansionCalcFields(DataSet: TDataSet);
    procedure CatalogTableCalcFields(DataSet: TDataSet);
    procedure ReturnDocTableCalcFields(DataSet: TDataSet);
    procedure ReturnDocDetTableCalcFields(DataSet: TDataSet);
    procedure CatFilterTableIndexProgress(Sender: TObject; PercentDone: Word);
    procedure memAnalogAfterScroll(DataSet: TDataSet);
    procedure AnalogTableAfterRefresh(DataSet: TDataSet);
    procedure KKCalcFields(DataSet: TDataSet);
    procedure TableDocLimitAfterScroll(DataSet: TDataSet);
    procedure TableSaleOrderAfterScroll(DataSet: TDataSet);
    procedure TableReturnDocAfterScroll(DataSet: TDataSet);
    procedure TableSaleOrderCalcFields(DataSet: TDataSet);
    procedure TableSaleOrderDetCalcFields(DataSet: TDataSet);
    procedure TableReturnDocCalcFields(DataSet: TDataSet);
    procedure KitTableCalcFields(DataSet: TDataSet);
    procedure OOTableCalcFields(DataSet: TDataSet);
    procedure OrderTableBeforeScroll(DataSet: TDataSet);
    procedure WaitListTableNewRecord(DataSet: TDataSet);
    procedure ReturnDocTableBeforeScroll(DataSet: TDataSet);
    procedure OrderDetTableBeforeScroll(DataSet: TDataSet);
    procedure OrderDetTableAfterScroll(DataSet: TDataSet);
    procedure AnalogMainTable_1CalcFields(DataSet: TDataSet);
    procedure AnalogMainTable_2CalcFields(DataSet: TDataSet);
    procedure AnalogMainTable_3CalcFields(DataSet: TDataSet);
    procedure AnalogMainTable_4CalcFields(DataSet: TDataSet);
    procedure AnalogMainTable_5CalcFields(DataSet: TDataSet);
    procedure AnalogIDTableAfterRefresh(DataSet: TDataSet);
(*
    {ReBranding}
    procedure BrandFieldGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
*)

  private
    procedure RunDatabaseFixes;
  public
    { Public declarations }
    fCloseControl: boolean;
    ActivePos: integer;

    sFieldGlobalName, CurrSclad:string; //sklad
    sOEValues:string;
    bOpeened:boolean;
    Data_Path: string;
    Import_Path,
    Export_Path,
    Update_Path,
    Data_psw: string;
    F, FLog: Text;
    Tree_mode: smallint;
    Group, Subgroup, fBrand: integer;
    Curr: smallint;
//    Discount_koef: real;
//    Profit_koef: real;
    Rate: Currency;
    Load_Log: boolean;
    WaitListCnt, WaitListTotal: integer;
    AssortmentExpansionCnt, AssortmentExpansionTotal: integer;
    Ign_chars: string;
    Auto_type: integer;
    Last_typ, Last_mod, Last_mfa: integer;
    td_cnt: integer;
    ld_cnt: integer;
    Tecdoc_enabled: boolean;
    Loading_flag: boolean;
    listSelect:TList;
    sAuto:string;
    sIDs: string;
    sLatestIDs: string;
    fOECurrentRange: Integer;
    CatMemoryUsed: Boolean;
    fDatabaseOpened: Boolean;

    fTecdocOldest: Boolean;
    fCurDataVersion: string;
    masChek,ReturnMasChek  : TList;
    fOrderTableInAfterScroll: Boolean;
    fWaitListTableClientFilter: string;
    
    fLockClrearSelection: Boolean;
    MaxGenAnID: MaxGenAnIDList;

    procedure RememberMaxGenAnID(Value: string; TableNum:integer);
    procedure MakeFullPrimen(const aDestFile: string) ;
    procedure UploadDescription(const aDestFile : string);
    function  CreateShortCode(Code: string; const aLiveSymbols: string = ''):string;
    procedure DataTest;
    procedure StopServer;
    procedure TestForDataMode;
    procedure LoadGrFromExcell(fname: string='');
    procedure LoadCatFromExcell(fname: string='');
    procedure LoadAnFromExcell(fname: string='');
    procedure LoadQuantFromExcell(fname: string='');
    procedure LoadOENumbersFromExcell(fname: string='');
    procedure LoadGroupBrand;
    procedure LoadCatalog;
//    procedure LoadCatalog_opt(aUseInsert: Boolean);
    procedure LoadAnalogs;
    procedure LoadQuants;
    procedure LoadOENumbers;
    procedure LoadTitles(st: integer);
    procedure LoadTree;
    procedure AfterLoadTree;
    procedure SetCatFilter;
    procedure SetTxtFilter;
    procedure GoToAnalog;
    procedure GoToSelectItem(const aCode2: string = ''; const aBrand: string = '');

    procedure AllOpen;
    procedure AllClose;
    procedure LoadBases;
    procedure SetQuantsLargeMode(aLarge: Boolean);
    procedure ConvertRetDocs;

    procedure DoSearch;
    function  CalcLineCnt: integer;
    procedure SetPriceKoef;
    function  GrDiscount(id: integer): real;
    function  BrDiscount(id: integer): real;
    function  GetDiscount(gr,subgr,br: integer; bStrictConformity:bool = FALSE): real;
    function  GetMargin(gr,subgr,br: integer; bStrictConformity:bool = FALSE): real;
    function  GetMargin2(gr, subgr, br: Integer; aPriceClient: Currency): Real;
    function  GetMarginDiff(aPriceClient: Currency): Double;

    procedure RecalcOrder;

    function  MakeSearchCode(s: string): string;
    function  DecodeCodeBrand(const aCode_Brand: string; var aCode, aBrand: string; aMakeSearchCode: Boolean = True): Boolean;

    procedure ExportTable(tbl: TDBISAMTable; fname, info: string; flds: string = '');
    procedure ImportTable(tbl: TDBISAMTable; fname, info: string; flds: string = '');
    procedure DoExport(Quants: boolean = False);
    procedure DoExportUpdate;
    procedure DoExportTEST;
    procedure DoImport(Path: string='');
    procedure LoadOEmemo;
    procedure LoadAnMemo;
    procedure PrepareUpdate;
    function  CatFieldsForExport: string;
    procedure PrepareQuantsUpdate;
    procedure StartLog(fname: string);
    procedure WLog(s: string);
    procedure StopLog;
    procedure CalcWaitList;
    procedure LoadTecdoc1;
    procedure LoadTecdoc2(lUpdate: boolean = False);
    procedure LoadTecdoc3;
    procedure LoadTextAttrList;
    procedure QuantsUnload;
//    procedure LoadBrandsDiscount;
//    procedure SaveBrandsDiscount;
    procedure TestUpgradeLevel;

    //загрузка из tecdoc
 {*}procedure LoadArtTable;
    procedure LoadTDBrandTable;
    procedure LoadDesTexts;
    procedure LoadCdsTexts;
    procedure LoadManufacturers(lUpdate: boolean = False);
    procedure LoadModels(lUpdate: boolean = False);
    procedure LoadTypes(lUpdate: boolean = False);
 {*}//procedure LoadArtTyp(lUpdate: boolean = False);
{!*}procedure LoadArtTyp_opt(lUpdate: boolean = False);
{!!*}procedure LoadArtTyp_opt2(lUpdate: boolean = False);
 {*}procedure LoadCatDet(lUpdate: boolean = False);
 {*}procedure LoadCatTypDet(lUpdate: boolean = False);
    procedure LoadCatParam(lUpdate: boolean = False);
{?*}procedure LoadCatPict(lUpdate: boolean = False);
{?*}procedure LoadCatPict_opt(lUpdate: boolean = False);
 {*}procedure LoadPict(lUpdate: boolean = False);
 {*}procedure LoadPrimenMemo; //построение списка применяемости

 {*}procedure LoadPrimen;     //построение временной таблицы применяемости
 {*}function LoadPrimen2(aLimit: Integer = -1): Boolean{True if data has truncated}; //построение временной таблицы применяемости не используя [002].Primen
    procedure GetCatIDsForCar(aTypeId: Integer; {out} anIDs: TStrings);

    procedure LoadBrandReplTable;
    procedure ShowLoadCatStat;
    procedure UnknownBrands;
    function  StartTecdoc: boolean;
    procedure ShowLoadingMess;
    procedure HideLoadingMess;
    procedure LoadingLock;
    procedure LoadingUnlock;
    procedure TestForDeadLock;
    procedure TypesUnload;

    //дозаливки из файлов
 {*}procedure LoadAddPicturesBath;
 {*}function LoadAddPictures(aDir: string = ''; aSilent: Boolean = False): Integer;
 {*}procedure LoadAddPictures2Bath;
 {*}function LoadAddPictures2(aFile: string = ''; aSilent: Boolean = False): Integer;
 {*}function  LoadAddPictureFromFile(const aPictureFileName, aCode, aBrand: string): Boolean;

 {*}procedure LoadAddTDArt(fname: string='');

    procedure LoadAddTDParamBath;
 {*}function LoadAddTDParam(fname: string=''; aSilent: Boolean = False): Integer;

 {*}procedure LoadAddTDPrimenBath;
 {*}function LoadAddTDPrimen(fname: string=''; aSilent: Boolean = False): Integer;

    procedure LoadDescriptionBath;
    function LoadDescription(sFileName: string = ''; aSilent: Boolean = False): Integer;

    procedure LoadFromBlockMfaTable;
    procedure SaveToBlockMfaTable;

    procedure RemoveTableFromBase(sTableName:string);
    procedure CopyTableBase(sTableName, sTableNameNew: string; aReplace: Boolean = True);
    procedure CopyMaketTable(tb1, tb2: TDBISAMTable);
    //moved from main
    function RenameTableDBI(sTableName, sTableNameNew: string): Boolean;

 {*}procedure LoadNewPrimen(tb1:TDBISAMTable);
    procedure CloseInfo;
    procedure CloseAllFilters;
    procedure FieldsSaveToStream(tb1:TDBISAMTable; FieldsName:string; Memory:TMemoryStream);

    //новое обновление
    procedure LoadLotusCatalog(sFileName:string);
    procedure LoadLotusAnalog(CSVFile: string);
    procedure LoadLotusAnalog_new(CSVFile: string);
    procedure LoadLotusOE(CSVFile: string);
    procedure TestLotusCatalog;
    function CanViewDiscretUpdate(aDataVersion: string): Boolean;
    function CheckVersions(Ver_Old, Ver_New: string): Integer;

    //[kri]
    function MakeProxyUrl(url, proxyuser, proxypwd: string): string;
    //function GetUpdateUrl(aBuildWithProxy: Boolean = True; IsExtUpdate: Boolean = False): string;
    //function GetUpdateUrlStock(aBuildWithProxy: Boolean = True; aGetPathOnly: Boolean = False): string;
    function BuildUpdateUrl(aUrl: string; aBuildWithProxy: Boolean = True; IsExtUpdate: Boolean = False): string;

    function GetUpdateUrlDestFile: string;
    function makeCsvRec(const aValues: array of string; aDelimitter: Char = ';'): string;
    function ExecuteSimpleSelect(const aSQL: string; const aParams: array of Variant): string;
    procedure ExecuteQuery(const aSQL: string);
    //procedure RecreateNomList(aForce: Boolean = False);
    procedure ExportPrice;

    function ReBranding(const aBrand: string; const fCanIbeOE: boolean = TRUE): string;
    procedure SetDefaultClient(const aClientID: string);

    procedure SaveCurrencyRounding(const aRounding: TCurrencyRounding; aPostData: Boolean = False);
    procedure LoadCurrencyRounding(var aRounding: TCurrencyRounding);

    procedure CreateQuantsLookup;
    function GetQuantsNumber(): string;
    function GetQuantsTableByNum(const QuantsNum: integer): TDBISAMTable;
//    function CalcCurrency(CurQuantSklad, CurQuant, CurMain: Currency; ): TCalcPrices;
    function CaclCurrency(price,priceQuants,priceQuantsSklad: Currency;
                          Group,Subgroup,Brand: integer;
                          sale: string):TCalcPrices;
    function GetCurByCode(const Cur: string): Currency; //отноешние к EUR

    procedure AnalogMainTableCalcFields(DataSet: TDataSet);                          

  end;

  TSQLConfigDataSource =
    function(hwndParent: Integer;
    fRequest: Integer;
    lpszDriverString: string;
    lpszAttributes: string): Smallint; stdcall;

var
  gCurrencyRounding: TCurrencyRounding;
  Data: TData;
  FSysLog: Text;
  Sys_Log_Flag: boolean;
  gMarginModeDiff: Boolean;
  FieldBool: TBooleanField;

const
  BS_PSW = 'bs080161';

  // Режимы работы с БД:
  DM_LOCAL  = 0;   // - локальная база данных
  DM_SERVER = 1;   // - сервер
  DM_CLIENT = 2;   // - клиент

  CURR_UPGRADE_LEVEL = 1;

  CAT_FULLTEXT_FIELDS = 'Name;Description;Oem;Analogs;Code2;Primen';

  BRA_UP_IMPEXP_FIELDS = 'ID;Brand_id;Description';
  GRU_UP_IMPEXP_FIELDS = 'ID;Group_id;Group_descr;Subgroup_id;Subgroup_descr';
  GRB_UP_IMPEXP_FIELDS = 'ID;Group_id;Subgroup_id;Brand_id';
  ANA_UP_IMPEXP_FIELDS = 'ID;Cat_id;An_code;An_brand;An_id;An_ShortCode;Locked';
  OEM_UP_IMPEXP_FIELDS = 'ID;Cat_id;Code;Code2;ShortOE;SIMB';

  BRA_IMPEXP_FIELDS = 'Brand_id;Description';
  GRU_IMPEXP_FIELDS = 'Group_id;Group_descr;Subgroup_id;Subgroup_descr';
  GRB_IMPEXP_FIELDS = 'Group_id;Subgroup_id;Brand_id';
  ANA_IMPEXP_FIELDS = 'Cat_id;An_code;An_brand;An_id';
  OEM_IMPEXP_FIELDS = 'Cat_id;Code;Code2';
  QUA_IMPEXP_FIELDS = 'Cat_id;Quantity';
  QUA_IMP_FIELDS    = 'CODE_BRAND;Quants;PRICE;SALE';
  KIT_IMP_FIELDS    = 'ID;CAT_ID;CHILD_CODE;CHILD_BRAND;CHILD_ID;QUANTITY';
  OO_IMP_FIELDS     = 'CAT_ID';

  //TIRES
  TIRES_MARKS_IMPEXP_FIELDS = 'mark_id;mark';
  TIRES_MODEL_IMPEXP_FIELDS = 'model_id;model;mark_id';
  TIRES_ENGINE_IMPEXP_FIELDS = 'engine_id;engine;model_id';
  TIRES_DIMENSIONS_IMPEXP_FIELDS = 'id;engine_id;dimensions;unique';

 // SYS_IMPEXP_FIELDS = 'Decimal_sep;Ign_chars;Shate_email;Update_url;Act_period;Act_warn_period;Ver_info1;Ver_info2;Host;Port;Ord_send_info';
  SYS_IMPEXP_FIELDS = '';

  TECDOC_SOURCE     = 'SHTMP_TECDOC';
  TRANSBASE_PREFIX  = 'Transbase ODBC';

  LOCK_FILE         = 'Loading.lck';

  SYS_LOG_NAME      = 'Sys.log';

  TMP_DIR_NAME      = 'SHATEUPD'; //подпапка в temp'е куда распаковываются обновления

resourcestring
  BSServerNotFound  = 'Сервер не запущен или неверно определены параметры'#13#10#13#10 +
                      'Address=%s или Host=%s'#13#10#13#10'в секции [Remote] в файле %s';
  BSAdministrator   = 'Администратор';
  BSStopServConfirm = 'Работающих пользователей: %d.'#13#10 +
                      'Настаиваете на остановке сервера?';

procedure ModStructMess(const s: string);
procedure ReindexMess(const s: string);

function EraseDirFiles(aPath: string; aDeleteDir: Boolean): Boolean;
function DeleteFilesByMask(aPath: string; const aMask: string; aRecursive: Boolean = False): Boolean;
function GetFileDateVersion(fname: string): string;
function FindTecdocDriver: string;
function FindTecdocSource: boolean;
function ConfigTecdocSource(Modify: boolean = False): boolean;

//[kri]
function GetFileSizeStr(aSize: Int64): string;
function GetFileSize_Internal(const aFileName: string): Int64;
function GetCurrencyCode(aCurrencyIndex: Integer): string;
function GetCurrencyShortCode(aCurrencyIndex: Integer): string;


procedure StartSysLog;
procedure WSysLog(s: string);
procedure StopSysLog;

function XRoundCurr(const aValue: Currency; aCurrency: TCurrencyType): Currency; overload;
function XRoundCurr(const aValue: Currency; aCurrency: SmallInt): Currency; overload;

function getCurCode(index: integer):string;//валюта
function getTypeCur(Curr: String): TCurrencyType;
function getCurCodeByName(const Curr: string):integer;//код валюты
implementation

uses _Main, _Splash, _SrchGrd, _LoadMess, _SelTDLoad, _CSVReader
  {$IFDEF ADMINMODE},_BatchSelectorForm{$ENDIF}, _TireCalcForm;



{$R *.dfm}
function getTypeCur(Curr: String): TCurrencyType;
begin
  Result := ctEUR;//EUR
  if Curr = 'EUR' then
    Result := ctEUR;//EUR
  if Curr = 'USD' then
    Result := ctUSD;//EUR
  if Curr = 'BYR' then
    Result := ctBYR;//EUR
  if Curr = 'RUB' then
    Result := ctRUB//EUR
end;
function getCurCodeByName(const Curr: string):integer;
begin
  Result := 0;
  if Curr = 'EUR' then
    Result := 0;//EUR
  if Curr = 'USD' then
    Result := 1;//EUR
  if Curr = 'BYR' then
    Result := 2;//EUR
  if Curr = 'RUB' then
    Result := 3//EUR
end;


function GetCurrencyCode(aCurrencyIndex: Integer): string;
begin
  case aCurrencyIndex of
    0: Result := 'EUR';//EUR
    1: Result := 'USD';//USD
    2: Result := 'BYR';//BYR
    3: Result := 'RUB';//RUB
  else
    Result := '';
  end;
end;

function GetCurrencyShortCode(aCurrencyIndex: Integer): string;
begin
  case aCurrencyIndex of
    0: Result := '€';//EUR
    1: Result := '$';//USD
    2: Result := 'BYR';//BYR
    3: Result := 'RUB';//RUB
  else
    Result := '';
  end;
end;

function XRoundCurr(const aValue: Currency; aCurrency: TCurrencyType): Currency;
var
  aSavedMode: TFPURoundingMode;
  aParams: TRoundParams;
begin
  aParams := gCurrencyRounding[aCurrency];
  //rmNearest, rmDown, rmUp, rmTruncate
  aSavedMode := GetRoundMode;
  SetRoundMode(aParams.RoundMode);
  try
    if aParams.RoundMode = rmNearest then
      Result := SimpleRoundTo(aValue, -aParams.RoundPower) //правильно учитывает 5-ку
    else
      Result := RoundTo(aValue, -aParams.RoundPower);
  finally
    SetRoundMode(aSavedMode);
  end;
end;

function XRoundCurr(const aValue: Currency; aCurrency: SmallInt): Currency;
begin
  Result := XRoundCurr(aValue, TCurrencyType(aCurrency));
end;

function GetFileSizeStr(aSize: Int64): string;
const
  cONE_KB = 1024;
  cONE_MB = cONE_KB * 1024;
  cONE_GB = cONE_MB * 1024;
begin
  if aSize > cONE_GB then
    Result := FormatFloat('0.##Гб', aSize / cONE_GB)
  else if aSize > cONE_MB then
    Result := FormatFloat('0.##Мб', aSize / cONE_MB)
  else if aSize > cONE_KB then
    Result := FormatFloat('0.##Кб', aSize / cONE_KB)
  else
    Result := IntToStr(aSize) + 'Б';
end;

function GetFileSize_Internal(const aFileName: string): Int64;
var
  aStream: TFileStream;
begin
  Result := 0;
  if not FileExists(aFileName) then
    Exit;

  aStream := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyNone);
  try
    Result := aStream.Size;
  finally
    aStream.Free;
  end;
end;

function GetFileDateVersion(fname: string): string;
var
  s: string;
begin
  s := GetFileDate(fname);
  Result := Copy(s, 9, 2) + Copy(s, 4, 2) + Copy(s, 1, 2) + '.1';
end;

//[kri]
{ рекурсивно чистит директорию с поддиректориями                               }
{ aDeleteDir - нужно ли удалить переданную директорию aPath                    }
function EraseDirFiles(aPath: string; aDeleteDir: Boolean): Boolean;
const
{$IFDEF WIN32}
  cFileNotFound = 18;
{$ELSE}
  cFileNotFound = -18;
{$ENDIF}
var
  aFileInfo: TSearchRec;
  aFound: Integer;
begin
  Result := DirectoryExists(aPath);
  if not Result then
    Exit;

  aPath := IncludeTrailingPathDelimiter(aPath);
  aFound := FindFirst(aPath + '*.*', faAnyFile, aFileInfo);
  try
    while aFound = 0 do begin
      if (aFileInfo.Name[1] <> '.') and (aFileInfo.Attr <> faVolumeID) then
      begin
        if (aFileInfo.Attr and faDirectory = faDirectory) then
          Result := EraseDirFiles(aPath + aFileInfo.Name, aDeleteDir) and Result
        else if (aFileInfo.Attr and faVolumeID <> faVolumeID) then begin
          if (aFileInfo.Attr and SysUtils.faReadOnly = SysUtils.faReadOnly) then
            FileSetAttr(aPath + aFileInfo.Name, faArchive);
          Result := SysUtils.DeleteFile(aPath + aFileInfo.Name) and Result;
        end;
      end;
      aFound := FindNext(aFileInfo);
    end;
  finally
    SysUtils.FindClose(aFileInfo);
  end;

  //папка пустая и это не корень диска
  if aDeleteDir and Result and (aFound = cFileNotFound) and
    not ( (Length(aPath) = 2) and (aPath[2] = ':') ) then
  begin
    RemoveDir(aPath);
    Result := (IOResult = 0) and Result;
  end;
end;

//[kri]
{ удаляет файлы по маске                                                       }
function DeleteFilesByMask(aPath: string; const aMask: string; aRecursive: Boolean = False): Boolean;
const
{$IFDEF WIN32}
  cFileNotFound = 18;
{$ELSE}
  cFileNotFound = -18;
{$ENDIF}
var
  aFileInfo: TSearchRec;
  aFound: Integer;
begin
  Result := DirectoryExists(aPath);
  if not Result then
    Exit;

  aPath := IncludeTrailingPathDelimiter(aPath);
  aFound := FindFirst(aPath + aMask, faAnyFile, aFileInfo);
  try
    while aFound = 0 do begin
      if (aFileInfo.Name[1] <> '.') and (aFileInfo.Attr <> faVolumeID) then
      begin
        if (aFileInfo.Attr and faDirectory = faDirectory) then
        begin
          if aRecursive then
            Result := DeleteFilesByMask(aPath + aFileInfo.Name, aMask, aRecursive) and Result
        end
        else
          if (aFileInfo.Attr and faVolumeID <> faVolumeID) then
          begin
            if (aFileInfo.Attr and SysUtils.faReadOnly = SysUtils.faReadOnly) then
              FileSetAttr(aPath + aFileInfo.Name, faArchive);
            Result := SysUtils.DeleteFile(aPath + aFileInfo.Name) and Result;
          end;
      end;
      aFound := FindNext(aFileInfo);
    end;
  finally
    SysUtils.FindClose(aFileInfo);
  end;
end;

procedure StartSysLog;
begin
  if Sys_Log_Flag then
  begin
    AssignFile(FSysLog, GetAppDir + SYS_LOG_NAME);
    Rewrite(FSysLog);
    WSysLog('Запуск: ' + DateTimeToStr(Now));
    WSysLog('-------------------------------------------------------------------');
  end;
end;

procedure WSysLog(s: string);
begin
  if Sys_Log_Flag then
    WriteLn(FSysLog, s);
end;

procedure StopSysLog;
begin
  if Sys_Log_Flag then
  begin
    WSysLog('-------------------------------------------------------------------');
    WSysLog('Останов: ' + DateTimeToStr(Now));
    CloseFile(FSysLog);
  end;
end;


procedure TData.DataModuleCreate(Sender: TObject);
var
  descr, path, addr, host: string;
begin
  masChek := TList.Create;
  ReturnMasChek := TList.Create;
  bOpeened := FALSE;
  listSelect := TList.Create;
  TestForDataMode;
  StartSysLog;
  Loading_flag := False;
  ModStructMessProc := ModStructMess;
  ReindexMessProc   := ReindexMess;
  data_psw := '';
  addr := Main.AppStorage.IniFile.ReadString('Remote', 'Address', '');
  host := Main.AppStorage.IniFile.ReadString('Remote', 'Host', '');
  Session.OnPassword := SessionPassword;
  Session.ProgressSteps := 100;
  if Data_Mode = DM_CLIENT then
  begin
    WSysLog('БД в режиме "клиент"');
    try
      with DBEngine do
      begin
        Active     := False;
        EngineType := etClient;
        Active     := True;
      end;
      with Session do
      begin
        SessionType    := stRemote;
        RemoteAddress  := addr;
        RemoteHost     := host;
        RemoteUser     := 'Admin';
        RemotePassword := 'DBAdmin';
      end;
      with Database do
      begin
        Connected := False;
        RemoteDatabase := 'SHMP_DATA';
        Connected := True;
      end;
    except
      MessageDlg(Format(BSServerNotFound,
                       [addr, host, Main.AppStorage.IniFile.FileName]),
                       mtError, [mbOK], 0);
      Application.Terminate;
    end;
  end
  else
  begin
    Data_path := GetAppDir + 'Данные\';
    if not DirectoryExists(Data_path) then
      CreateDir(Data_path);

    with Database do
    begin
      Connected := False;
      Directory := Data_path;
    end;
    WSysLog('Тестирование структуры БД');
    DataTest;
    WSysLog('Тестирование БД завершено успешно');
    if Data_Mode = DM_SERVER then
    begin
      WSysLog('Запуск в режиме "сервер"');
      with DBEngine do
      begin
        Active     := False;
        EngineType := etServer;
        Active     := True;
        try
          GetServerDatabase('SHMP_DATA', descr, path);
        except
          AddServerDatabase('SHMP_DATA', 'ShateMPlus database', Data_path);
        end;
      end;
      WSysLog('Сервер запущен');
      Application.ShowMainForm := False; // прячем главную форму
      Main.TrayIcon.Active := True;      // и выводим иконку в Трэй
      exit;
    end
    else
      WSysLog('БД в режиме "локальная"');
  end;
  WSysLog('Проверка и создание рабочих каталогов');
  Import_path := GetAppDir + 'Импорт\';
  if not DirectoryExists(Import_path) then
    CreateDir(Import_path);

  Export_path := GetAppDir + 'Экспорт\';
  if not DirectoryExists(Export_path) then
    CreateDir(Export_path);
  Update_path := GetAppDir + 'Обновление\';
  if Main.AdminMode and (not DirectoryExists(Update_path)) then
    CreateDir(Update_path);

  //удаляем мусор от запросов
  DeleteFilesByMask(Data_path, '???*.?~', False);
  DeleteFilesByMask(GetAppDir, '???*.?~', False);

  Group := 0;
  Subgroup := 0;
  fBrand := 0;
  WSysLog('Открытие БД');
  AllOpen;
  Ign_chars := SysParamTable.FieldByName('Ign_chars').AsString;
  TestUpgradeLevel;
  Tecdoc_enabled := StartTecdoc;
  //LoadBrandsDiscount;
  Tree_mode := ParamTable.FieldByName('Tree_mode').AsInteger;
  Curr      := ParamTable.FieldByName('Currency').AsInteger;
  Load_Log  := Main.AdminMode and SysParamTable.FieldByName('Load_log').AsBoolean;
  Main.CurrProgVersion  := VersionTable.FieldByName('ProgVersion').AsString;
  Main.CurrDataVersion  := VersionTable.FieldByName('DataVersion').AsString;
  Main.CurrQuantVersion := VersionTable.FieldByName('QuantVersion').AsString;
  Main.CurrNewsVersion  := VersionTable.FieldByName('NewsVersion').AsString;
  Main.CurrTecdocVersion := VersionTable.FieldByName('TecdocVersion').AsString;
  
  Main.FiltModeComboBox.ItemIndex  := ParamTable.FieldByName('Filt_mode').AsInteger;
  WSysLog('Проверка блокировки');
  TestForDeadLock;
end;


procedure TData.DataModuleDestroy(Sender: TObject);
begin
  MasChek.Free;
  ReturnMasChek.Free;
  if Data_Mode = DM_SERVER then
    exit;
  WSysLog('Закрытие БД');
{  with VersionTable do
  begin
    Refresh;
    Edit;
    FieldByName('ProgVersion').Value  := Main.CurrProgVersion;
    FieldByName('DataVersion').Value  := Main.CurrDataVersion;
    FieldByName('QuantVersion').Value := Main.CurrQuantVersion;
    FieldByName('NewsVersion').Value  := Main.CurrNewsVersion;
    Post;
  end; }
  if ParamTable.Active then
    with ParamTable do
    begin
      Refresh;
      Edit;
      FieldByName('Tree_mode').Value    := Tree_mode;
      FieldByName('Currency').Value     := Curr;
      FieldByName('Filt_mode').Value    := Main.FiltModeComboBox.ItemIndex;
      FieldByName('Page').Value         := Main.Pager.ActivePageIndex;
      Post;
    end;
  //SaveBrandsDiscount;
  AllClose;
  SetLength(Main.TextAttrList, 0);
  StopSysLog;
  inherited;
end;


procedure TData.AllOpen;

  procedure TestCreateNomList(aTable: TDBISAMTable);
  var
    aTableName: string;
    t: Cardinal;
  begin
    t := GetTickCount;
    Main.ShowProgrInfo('Загрузка - кэширование БД2...');
    Main.SetProgressMax(100);
    if aTable.Exists then
      aTable.EmptyTable
    else
      aTable.CreateTable;
    aTable.Exclusive := True;

    if SameText(aTable.DatabaseName, 'Memory') then
      aTableName := '"Memory\' + aTable.TableName + '"'
    else
      aTableName := '[' + aTable.TableName + ']';
    aTable.DeleteAllIndexes;
    QuerySelect.SQL.Text :=
      ' SELECT Cat_id, Code2, Brand_id ' +
      ' INTO ' + aTableName + ' FROM [002] ';
{    QuerySelect.SQL.Text :=
      ' INSERT INTO ' + aTableName + ' SELECT Cat_id, Code2, Brand_id FROM [002] '; }
    QuerySelect.open;
    QuerySelect.Close;
    aTable.AddIndex('Code2', 'Brand_id;Code2');
    aTable.Exclusive := False;
    ShowMessage(IntToStr(GetTickCount - t));
  end;

  function SetMaxAnalogID(TableName: string): integer;
  begin
    try
      result := -1;
      QuerySelect.SQL.Clear;
      QuerySelect.SQL.Text := ' select max(gen_an_id) as MaxGenAnId from ' + TableName;
      QuerySelect.Active := TRUE;
      if not QuerySelect.Eof then
       result := StrToIntDef(QuerySelect.FieldByName('MaxGenAnId').AsString, -1);
    except
       result := -1;
    end;
  end;

var
  DataCursor:TDataCursor;
  DestBuffer: PChar;
  DestBufferSize: Integer;
  i:integer;
  FieldText:TStringField;
  FieldCurr:TCurrencyField;
  FieldInt:TIntegerField;
  FieldFloat: TFloatField;
  MemoField: TFloatField;
  s, QuntsNumber: string;
  aStockQuantTable: TDBISamTable;
//      t: Cardinal;
begin
//t := GetTickCount;
  CatMemoryUsed := False;
  try
  SetCurrentDir(Data_Path);
  //Cli_email

  //TestCreateNomList(NomList2);

  //sklad >>
  TableBases.Open;
  QuntsNumber := GetQuantsNumber;

  for i := 2 to cQuantBasesCount do
  begin
    aStockQuantTable := TDBISamTable(Self.FindComponent('QuantTable' + IntToStr(i)));
    aStockQuantTable.IndexName := 'Cat_id';
    aStockQuantTable.Open;
  end;
  //CreateQuantsLookup;
  //<< sklad

  sIDs := '';
  with QueryFilter do
  begin
     Close;
     SQL.Clear;
     SQL.Add('SELECT DISTINCT Cat_id FROM [012] WHERE (Quantity <> '''') AND (Quantity <> ''0'')');
     Open; {![kri] slowly}
     if not EOF then
     begin
       sIDs := FieldByName('Cat_id').AsString;
       Next;
       while not EOF do
         begin
            sIDs := sIDs + ','+FieldByName('Cat_id').AsString;
            Next;
         end;
     end;
     Close;
     if sIDs <> '' then
       sIDs := '(Cat_id IN ('+sIDs+'))';
  end;

  sLatestIDs := '';
  with QueryFilter do
  begin
     Close;
     SQL.Clear;
     SQL.Add('SELECT DISTINCT Cat_id FROM [012] WHERE Latest = 1');
     Open; {![kri] slowly}
     if not EOF then
     begin
       sLatestIDs := FieldByName('Cat_id').AsString;
       Next;
       while not EOF do
         begin
            sLatestIDs := sLatestIDs + ','+FieldByName('Cat_id').AsString;
            Next;
         end;
     end;
     Close;
     if sLatestIDs <> '' then
       sLatestIDs := '(Cat_id IN ('+sLatestIDs+'))';
  end;


  DiscountTable.Open;
  memProfit.Open;
  SysParamTable.Open;
  ColumnView.Open;
  ParamTable.Open;
  VersionTable.Open;
  {with VersionTable do
  begin
    if (Fields.FindField('PictsVersion') is TStringField) then
    begin
      Open;
      s := FieldByName('PictsVersion').AsString;
      Fields.FindField('PictsVersion').SetFieldType(ftMemo);
      FieldDefs.Find('PictsVersion').DataType := ftMemo;
      TestTable(VersionTable, data_psw);
      Open;
      Edit;
      FieldByName('PictsVersion').AsString := s;
      Post;
      Close;
    end
    else
      Open;
  end;}

  fTecdocOldest := VersionTable.FieldByName('TecdocVersion').AsString <> '2014.2';
  fCurDataVersion := VersionTable.FieldByName('DataVersion').AsString;


  BrandTable.IndexName := 'BrandId';
  BrandTable.Open;
  GroupTable.IndexName := 'GrId';
  GroupTable.Open;
  QuantTable.IndexName := 'Cat_id';
  QuantTable.Open;
  OETable.IndexName := 'Cat_id';
  OETable.Open;

  OEIDTable.Open;
  OEDescrTable.Open;
{
  OEMap.IndexName := 'SIM';
  OEMap.Open;

  OESearchTable.Open;
  if OEMap.FindKey(['0']) then
  begin
    OESearchTable.SetRange([OEMap.FieldByName('StartID').AsInteger],[OEMap.FieldByName('EndID').AsInteger]);
  end;
}
  //new OE
  OESearchTable.IndexName := 'SIM';
  OESearchTable.Open;

  OEIDSearchTable.Open;
  OEDescrSearchTable.IndexName := 'SIM';
  OEDescrSearchTable.Open;

  fOECurrentRange := Ord('0');
  OESearchTable.SetRange([fOECurrentRange], [fOECurrentRange]);


  AnSearchTable.IndexName := 'AnCode2';
  AnSearchTable.Open;

  AutoMakerTable.Open;

  ManufacturersTable.Open;
  ModelsTable.Open;
  TypesTable.Open;

  ClIDsTable.IndexName := 'Descr';
  ClIDsTable.Open;

  FiltTable.IndexName := 'Cnt';
  FiltTable.Open;
  SFiltTable.Open;

  OrderDetTable.IndexName := 'Order';
  OrderDetTable.Open;
  XOrderDetTable.Open;

  TiresCarMake.Open;
  TiresCarModel.Open;
  TiresCarEngine.Open;
  TiresDimensions.Open;
  
  with OrderTable do
  begin
    IndexName := 'Date';
    Open;
    SetRange([Main.OrderDateEd1.Date,''], [Main.OrderDateEd2.Date,'']);
    Last;
  end;
  XOrderDetTable2.Open;
                            
  LoadTextAttrList;

  DescriptionTable.Open;
  if ParamTable.FieldByName('UseMemory').AsBoolean then
  begin
    Main.ShowProgrInfo('Загрузка - кэширование БД...');
    Main.SetProgressMax(100);
    CatalogTable.Open;
    CatFilterTable.IndexName := '';
    TestTable(CatFilterTable, data_psw);

    QuerySelect.Close;
    QuerySelect.SQL.Clear;
    QuerySelect.SQL.Add('SELECT ([002].Cat_ID) as Cat_ID, ([002].Group_id) as Group_id, ([002].Subgroup_id) as Subgroup_id, ([002].Brand_id) as Brand_id,([002].Code) as Code,([002].Code2) as Code2,([002].ShortCode) as ShortCode, ');
    QuerySelect.SQL.Add(' ([002].T1) as T1, ([002].T2) as T2, ');
    QuerySelect.SQL.Add(' ([002].Title) as Title, ([002].Sale) as Sale, ([002].New) as New, ');
    QuerySelect.SQL.Add(' ([002].Usa) as Usa, ');
    QuerySelect.SQL.Add(' ([002].typ_tdid) as typ_tdid');
    QuerySelect.SQL.Add(' INTO "MEMORY\CatFilterTable" FROM [002]');
    QuerySelect.open;
    QuerySelect.Close;
    CatFilterTable.OnIndexProgress := CatFilterTableIndexProgress;
    CatFilterTable.Exclusive := TRUE;
    Main.ShowProgrInfo('Загрузка - инициализация фильтров...');
    CatFilterTable.Tag := 1; //чтобы два прогресса показывались как один
    CatFilterTable.AddIndex('GrCode','T1;Group_id;Subgroup_id;Brand_id;Code');
    CatFilterTable.Tag := 2; //чтобы два прогресса показывались как один
    CatFilterTable.AddIndex('BrCode','T2;Brand_id;Group_id;Subgroup_id;Code');
    CatFilterTable.Tag := 3; //чтобы два прогресса показывались как один
    CatFilterTable.AddIndex('Typ','typ_tdid');
    CatFilterTable.Exclusive := FALSE;
    CatFilterTable.OnIndexProgress := nil;

    CatMemoryUsed := True;

    CatalogDataSource.DataSet := CatFilterTable;
    SetQuantsLargeMode(ParamTable.FieldByName('bQuantsInGrid').AsBoolean);
    LoadBases;
    CatFilterTable.Open;
  end
  else
  begin

     if CatalogTable.Fields.FindField('Name_Descr') = nil then
     begin
         FieldText:=TStringField.Create(nil);
         FieldText.FieldName := 'Name_Descr';
         FieldText.Name := CatalogTable.Name + 'Name_Descr';
         FieldText.Size := 250;
         FieldText.FieldKind := fkCalculated;
         FieldText.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('GroupInfo') = nil then
     begin
         FieldText:=TStringField.Create(nil);
          FieldText.FieldName := 'GroupInfo';
          FieldText.Name := CatalogTable.Name + 'GroupInfo';
          FieldText.Size :=100;
          FieldText.FieldKind := fkCalculated;
          FieldText.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('BrandDescr') = nil then
     begin
          FieldText:=TStringField.Create(nil);
          FieldText.FieldName := 'BrandDescr';
          FieldText.Name := CatalogTable.Name + 'BrandDescr';
          FieldText.Size :=100;
          FieldText.KeyFields := 'Brand_id';
          FieldText.LookupDataSet := BrandTable;
          FieldText.LookupKeyFields := 'Brand_id';
          FieldText.LookupResultField := 'Description';

          FieldText.FieldKind := fkLookup;

          FieldText.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('BrandDescrRepl') = nil then
     begin
          FieldText:=TStringField.Create(nil);
          FieldText.FieldName := 'BrandDescrRepl';
          FieldText.Name := CatalogTable.Name + 'BrandDescrRepl';
          FieldText.Size :=100;
          FieldText.FieldKind := fkCalculated;
          FieldText.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('BrandDescrView') = nil then
     begin
         FieldText:=TStringField.Create(nil);
          FieldText.FieldName := 'BrandDescrView';
          FieldText.Name := CatalogTable.Name + 'BrandDescrView';
          FieldText.Size :=100;
          FieldText.FieldKind := fkCalculated;
          FieldText.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('saleQCalc') = nil then
     begin
         FieldText:=TStringField.Create(nil);
          FieldText.FieldName := 'saleQCalc';
          FieldText.Name := CatalogTable.Name + 'saleQCalc';
          FieldText.Size :=1;
          FieldText.KeyFields := 'Cat_id';
          FieldText.LookupDataSet := QuantTable;
          FieldText.LookupKeyFields := 'Cat_id';
          FieldText.LookupResultField := 'Sale';

          FieldText.FieldKind := fkLookup;

          FieldText.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('saleQ') = nil then
     begin
         FieldText:=TStringField.Create(nil);
          FieldText.FieldName := 'saleQ';
          FieldText.Name := CatalogTable.Name + 'saleQ';
          FieldText.Size :=1;
          FieldText.FieldKind := fkCalculated;
          FieldText.DataSet:=CatalogTable;
     end;
//*********************Begin****************************
     if CatalogTable.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := CatalogTable.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'Cat_id';
       FieldCurr.LookupDataSet := SkladQuants; //GetQuantsTableByNum(StrToInt(QuntsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet:=CatalogTable;
     end;

     XCatTable.close;
     if XCatTable.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := XCatTable.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'Cat_id';
       FieldCurr.LookupDataSet := SkladQuants;//GetQuantsTableByNum(StrToInt(QuntsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := XCatTable;
     end;
     XCatTable.open;

     if AnalogMainTable_1.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := AnalogMainTable_1.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'An_id';
       FieldCurr.LookupDataSet := SkladQuants;//GetQuantsTableByNum(StrToInt(QuntsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := AnalogMainTable_1;
     end;
     if AnalogMainTable_2.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := AnalogMainTable_2.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'An_id';
       FieldCurr.LookupDataSet := SkladQuants;//GetQuantsTableByNum(StrToInt(QuntsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := AnalogMainTable_2;
     end;
     if AnalogMainTable_3.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := AnalogMainTable_3.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'An_id';
       FieldCurr.LookupDataSet := SkladQuants;//GetQuantsTableByNum(StrToInt(QuntsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := AnalogMainTable_3;
     end;
     if AnalogMainTable_4.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := AnalogMainTable_4.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'An_id';
       FieldCurr.LookupDataSet := SkladQuants;//GetQuantsTableByNum(StrToInt(QuntsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := AnalogMainTable_4;
     end;
     if AnalogMainTable_5.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := AnalogMainTable_5.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'An_id';
       FieldCurr.LookupDataSet := SkladQuants;//GetQuantsTableByNum(StrToInt(QuntsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := AnalogMainTable_5;
     end;

{
     if AnalogTable.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := AnalogTable.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'An_id';
       FieldCurr.LookupDataSet := SkladQuants;//GetQuantsTableByNum(StrToInt(QuntsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := AnalogTable;
     end;

     }
//*********************END****************************

     if CatalogTable.Fields.FindField('PriceQuant') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuant';
       FieldCurr.Name := CatalogTable.Name + 'PriceQuant';
       FieldCurr.KeyFields := 'Cat_id';
       FieldCurr.LookupDataSet := QuantTable;
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet:=CatalogTable;
     end;


     if CatalogTable.Fields.FindField('PriceItog') = nil then
     begin
         FieldCurr:=TCurrencyField.Create(nil);
          FieldCurr.FieldName := 'PriceItog';
          FieldCurr.Name := CatalogTable.Name + 'PriceItog';
          FieldCurr.DisplayFormat := ',0.00';
          FieldCurr.FieldKind := fkCalculated;
          FieldCurr.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('PriceItog') = nil then
     begin
         FieldCurr:=TCurrencyField.Create(nil);
          FieldCurr.FieldName := 'PriceItog';
          FieldCurr.DisplayFormat := ',0.00';
          FieldCurr.Name := CatalogTable.Name + 'PriceItog';
          FieldCurr.FieldKind := fkCalculated;
          FieldCurr.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('GroupDescr') = nil then
     begin
         FieldText:=TStringField.Create(nil);
          FieldText.FieldName := 'GroupDescr';
          FieldText.Name := CatalogTable.Name + 'GroupDescr';
          FieldText.Size :=255;
          FieldText.KeyFields := 'Group_id';
          FieldText.LookupDataSet := XGroupTable;
          FieldText.LookupKeyFields := 'Group_id';
          FieldText.LookupResultField := 'Group_descr';

          FieldText.FieldKind := fkLookup;

          FieldText.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('SubgroupDescr') = nil then
     begin
         FieldText:=TStringField.Create(nil);
          FieldText.FieldName := 'SubgroupDescr';
          FieldText.Name := CatalogTable.Name + 'SubgroupDescr';
          FieldText.Size :=255;
          FieldText.KeyFields := 'Group_id;Subgroup_id';
          FieldText.LookupDataSet := XGroupTable;
          FieldText.LookupKeyFields := 'Group_id;Subgroup_id';
          FieldText.LookupResultField := 'Subgroup_descr';

          FieldText.FieldKind := fkLookup;

          FieldText.DataSet:=CatalogTable;
     end;


      if CatalogTable.Fields.FindField('Price_koef_eur') = nil then
     begin
         FieldCurr:=TCurrencyField.Create(nil);
          FieldCurr.FieldName := 'Price_koef_eur';
          FieldCurr.Name := CatalogTable.Name + 'Price_koef_eur';
          FieldCurr.FieldKind := fkCalculated;
          FieldCurr.DisplayFormat := ',0.00';
          FieldCurr.DataSet:=CatalogTable;
     end;


     if CatalogTable.Fields.FindField('Price_koef') = nil then
     begin
         FieldCurr:=TCurrencyField.Create(nil);
          FieldCurr.FieldName := 'Price_koef';
          FieldCurr.Name := CatalogTable.Name + 'Price_koef';
          FieldCurr.FieldKind := fkCalculated;
          FieldCurr.DisplayFormat := ',0.##';
          FieldCurr.DataSet:=CatalogTable;
     end;

      if CatalogTable.Fields.FindField('Price_koef_usd') = nil then
     begin
         FieldCurr:=TCurrencyField.Create(nil);
          FieldCurr.FieldName := 'Price_koef_usd';
          FieldCurr.Name := CatalogTable.Name + 'Price_koef_usd';
          FieldCurr.FieldKind := fkCalculated;
          FieldCurr.DisplayFormat := ',0.00';
          FieldCurr.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('Price_koef_rub') = nil then
     begin
         FieldCurr:=TCurrencyField.Create(nil);
          FieldCurr.FieldName := 'Price_koef_rub';
          FieldCurr.Name := CatalogTable.Name + 'Price_koef_rub';
          FieldCurr.FieldKind := fkCalculated;
          FieldCurr.DisplayFormat := ',0';
          FieldCurr.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('Price_pro') = nil then
     begin
         FieldCurr:=TCurrencyField.Create(nil);
          FieldCurr.FieldName := 'Price_pro';
          FieldCurr.Name := CatalogTable.Name + 'Price_pro';
          FieldCurr.FieldKind := fkCalculated;
          FieldCurr.DisplayFormat := ',0.##';
          FieldCurr.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('OrdQuantity') = nil then
     begin
         FieldInt:=TIntegerField.Create(nil);
          FieldInt.FieldName := 'OrdQuantity';
          FieldInt.Name := CatalogTable.Name + 'OrdQuantity';
          FieldInt.FieldKind := fkCalculated;
          FieldInt.DataSet:=CatalogTable;
     end;
     //Price_koef_eur

     if CatalogTable.Fields.FindField('OrdQuantityStr') = nil then
     begin
         FieldText:=TStringField.Create(nil);
          FieldText.FieldName := 'OrdQuantityStr';
          FieldText.Name := CatalogTable.Name + 'OrdQuantityStr';
          FieldText.Size :=10;
          FieldText.FieldKind := fkCalculated;
          FieldText.DataSet:=CatalogTable;
     end;



     if CatalogTable.Fields.FindField('Quantity') = nil then
     begin
         FieldText:=TStringField.Create(nil);
          FieldText.FieldName := 'Quantity';
          FieldText.Name := CatalogTable.Name + 'Quantity';
          FieldText.Size :=255;
          FieldText.KeyFields := 'Cat_id';
          FieldText.LookupDataSet := QuantTable;
          FieldText.LookupKeyFields := 'Cat_id';
          FieldText.LookupResultField := 'Quantity';

          FieldText.FieldKind := fkLookup;

          FieldText.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('QuantNew') = nil then
     begin
         FieldText:=TStringField.Create(nil);
          FieldText.FieldName := 'QuantNew';
          FieldText.Name := CatalogTable.Name + 'QuantNew';
          FieldText.Size :=255;
          FieldText.KeyFields := 'Cat_id';
          FieldText.LookupDataSet := QuantTable;
          FieldText.LookupKeyFields := 'Cat_id';
          FieldText.LookupResultField := 'QuantNew';

          FieldText.FieldKind := fkLookup;

          FieldText.DataSet:=CatalogTable;
     end;

     if CatalogTable.Fields.FindField('QuantLatest') = nil then
     begin
          FieldInt:=TIntegerField.Create(nil);
          FieldInt.FieldName := 'QuantLatest';
          FieldInt.Name := CatalogTable.Name + 'QuantLatest';
          FieldInt.KeyFields := 'Cat_id';
          FieldInt.LookupDataSet := QuantTable;
          FieldInt.LookupKeyFields := 'Cat_id';
          FieldInt.LookupResultField := 'Latest';

          FieldInt.FieldKind := fkLookup;

          FieldInt.DataSet:=CatalogTable;
     end;

     //sklad
     if CatalogTable.Fields.FindField('QuantLocal') = nil then
     begin
       FieldFloat := TFloatField.Create(nil);
       FieldFloat.FieldName := 'QuantLocal';
       FieldFloat.Name := CatalogTable.Name + 'QuantLocal';
       FieldFloat.KeyFields := 'Cat_id';
       FieldFloat.LookupDataSet := nil; //вычисляется по текущей базе в LoadBases
       FieldFloat.LookupKeyFields := 'Cat_id';
       FieldFloat.LookupResultField := 'Q' + QuntsNumber; //'Quantity';

       FieldFloat.FieldKind := fkLookup;

       FieldFloat.DataSet := CatalogTable;
     end;

     if CatalogTable.Fields.FindField('OrderOnly') = nil then
     begin
       FieldBool := TBooleanField.Create(nil);
       FieldBool.FieldName := 'OrderOnly';
       FieldBool.Name := CatalogTable.Name + 'OrderOnly';
       FieldBool.KeyFields := 'Cat_id';
       FieldBool.LookupDataSet := OOTable;
       FieldBool.LookupKeyFields := 'Cat_id';
       FieldBool.LookupResultField := 'IsOrder';

       FieldBool.FieldKind := fkLookup;

       FieldBool.DataSet := CatalogTable;
     end;

     if CatalogTable.Fields.FindField('Limit') = nil then
     begin
       FieldInt := TIntegerField.Create(nil);
       FieldInt.FieldName := 'Limit';
       FieldInt.Name := CatalogTable.Name + 'Limit';
       FieldInt.KeyFields := 'Cat_id';
       FieldInt.LookupDataSet := nil; //вычисляется по текущей базе в LoadBases
       FieldInt.LookupKeyFields := 'Cat_id';
       FieldInt.LookupResultField := 'L' + QuntsNumber;//'Limit';

       FieldInt.FieldKind := fkLookup;

       FieldInt.DataSet := CatalogTable;
     end;

     if CatalogTable.Fields.FindField('Basic') = nil then
     begin
       FieldText := TStringField.Create(nil);
       FieldText.FieldName := 'Basic';
       FieldText.Name := CatalogTable.Name + 'Basic';
       FieldText.Size := 20;
       FieldText.FieldKind := fkCalculated;
       FieldText.DataSet := CatalogTable;
     end;

     if CatalogTable.Fields.FindField('Reserve') = nil then
     begin
       FieldInt := TIntegerField.Create(nil);
       FieldInt.FieldName := 'Reserve';
       FieldInt.Name := CatalogTable.Name + 'Reserve';
       FieldInt.FieldKind := fkCalculated;
       FieldInt.DataSet := CatalogTable;
     end;

     if CatalogTable.Fields.FindField('LimitsCalc') = nil then
     begin
       FieldText := TStringField.Create(nil);
       FieldText.FieldName := 'LimitsCalc';
       FieldText.Name := CatalogTable.Name + 'LimitsCalc';
       FieldText.Size := 20;
       FieldText.FieldKind := fkCalculated;
       FieldText.DataSet := CatalogTable;
     end;


     CatalogDataSource.DataSet := CatalogTable;
     SetQuantsLargeMode(ParamTable.FieldByName('bQuantsInGrid').AsBoolean);
     LoadBases;
     CatalogTable.Open;
  end;


  Main.ShowProgrInfo('Загрузка каталога...');
//  Main.ShowProgrInfo('Инициализация...');
//  SearchTable.Filtered := False;       //Code2 <> ''
  SearchTable.Open; {![kri] slowly}
  ShortSearchTable.Open;
  Main.ShowProgrInfo('Инициализация...');
  AnalogTable.Open;

  {TEST ANALOG}
  AnalogIDTable.Open;
  AnalogMainTable_1.Open;
  AnalogMainTable_2.Open;
  AnalogMainTable_3.Open;
  AnalogMainTable_4.Open;
  AnalogMainTable_5.Open;

  MaxGenAnID.MaxGenAnIdFromTable_1 := SetMaxAnalogID('[007_1m]');
  MaxGenAnID.MaxGenAnIdFromTable_2 := SetMaxAnalogID('[007_2m]');
  MaxGenAnID.MaxGenAnIdFromTable_3 := SetMaxAnalogID('[007_3m]');
  MaxGenAnID.MaxGenAnIdFromTable_4 := SetMaxAnalogID('[007_4m]');
  MaxGenAnID.MaxGenAnIdFromTable_5 := SetMaxAnalogID('[007_5m]');

  XCatTable.Open;
  CatDetTable.Open;
  PictTable.Open;
//  CatPictTable.Open; //delete

  WaitListTable.Open;
  WaitListTable.IndexName := 'Cli_date';
  WaitListTable.Refresh;

  AssortmentExpansion.Open;
  CatTypDetTable.Open;
  PrimenTable.Open;
  PrimenTableAfterScroll(PrimenTable);
  WaitListTable.Refresh;
  NetTimer.Interval := 50000;//ParamTable.FieldByName('Net_interv').AsInteger;
  NetTimer.Enabled := NetTimer.Interval > 0;
  ArtTypTable.Open;

  ReturnDocDetTable.Open;
  with ReturnDocTable do
  begin
    IndexName := 'Date';
    Open;
    SetRange([Main.DateStartReturnDoc.Date], [Main.DateEndReturnDoc.Date]);
    Last;
  end;
  Notes.Open;
  KK.Open;
  KitTable.Open;
  OOTable.Open;

  //sklad------------
  with TableDocLimit do
  begin
    IndexName := 'Date';
    Open;
    SetRange([Main.DocLimitStartAdvDate.Date], [Main.DocLimitEndAdvDate.Date]);
    Last;
  end;
  TableDocLimitDet.IndexName := 'DocLimitID';
  TableDocLimitDet.Open;
 xSaleOrderDet.Open;

  with TableSaleOrder do
  begin
    IndexName := 'Date';
    Open;
    SetRange([Main.SaleOrderStart.Date], [Main.SaleOrderEnd.Date]);
    Last;
  end;

  TableSaleOrderDet.IndexName := 'SaleOrderID';
  TableSaleOrderDet.Open;
  xReturnDoc.IndexName := 'ReturnDocId';
  xReturnDoc.Open;

  with TableReturnDoc do
  begin
    IndexName := 'Date';
    Open;
    SetRange([Main.DocReturnStartAdvDate.Date], [Main.DocReturnEndAdvDate.Date]);
    Last;
  end;

  TableReturnDocDet.IndexName := 'ReturnDocId';
  TableReturnDocDet.Open;
  //--------sklad




  fDatabaseOpened := True;
  except
    on e: Exception do
    begin
      MessageDlg('Ошибка - '+e.Message, mtInformation, [mbOk],0);
    end;
  end;
 //  TableCarFilter.IndexName := 'Type_ID';
 // TableCarFilter.Open;
 // CarFilter.IndexName := 'Cat_ID';
 // CarTable.Open;

//ShowMessage(IntToStr(GetTickCount - t));
end;


procedure TData.AllClose;
begin
  fDatabaseOpened := False;

  //sklad >>
  TableBases.Close;

  QuantTable2.Close;
  QuantTable3.Close;
  QuantTable4.Close;
  QuantTable5.Close;
  QuantTable6.Close;
  QuantTable7.Close;
  QuantTable8.Close;
  QuantTable9.Close;
  QuantTable10.Close;
  QuantTable11.Close;
  QuantTable12.Close;
  QuantTable13.Close;
  QuantTable14.Close;
  QuantTable15.Close;
  QuantTable16.Close;
  //<< sklad

//  OEMap.Close;
  CloseAllFilters;
  ColumnView.Close;
  ReturnDocTable.Close;
  ReturnDocDetTable.Close;
  AssortmentExpansion.Close;
  NetTimer.Enabled := False;
  ArtTypTable.Close;
  PrimenTable.Close;
  AnalogTable.Close;

  AnSearchTable.Close;
  WaitListTable.Close;
  CatTypDetTable.Close;
  PrimenTable.EmptyTable;
  PrimenTable.Close;
  CatDetTable.Close;
//  CatPictTable.Close; //delete
  PictTable.Close;
  XCatTable.Close;

  TiresCarMake.Close;
  TiresCarModel.Close;
  TiresCarEngine.Close;
  TiresDimensions.Close;
  
  ManufacturersTable.Close;
  ModelsTable.Close;
  TypesTable.Close;
  XBrandTable.Close;
  XGroupTable.Close;
  XCatTable.Close;
  QuantTable.Close;
  SearchTable.Close;
  ShortSearchTable.Close;
  XOrderDetTable.Close;
  XOrderDetTable2.Close;
  OrderDetTable.Close;
  OrderTable.Close;
  ClIDsTable.Close;
  FiltTable.Close;
  SFiltTable.Close;
  OETable.Close;

  OEIDTable.Close;
  OEDescrTable.Close;

  OESearchTable.Close;

  OEDescrSearchTable.Close;
  OEIDSearchTable.Close;
  
  //ColorsTable.Close;
  VersionTable.Close;

  SysParamTable.Close;
  //TableCarFilter.Close;
 // CarTable.Close;
  DescriptionTable.Close;
  FilterResultFind.Close;
  FilterResult.Close;
  CatalogTable.Close;

  if CatFilterTable.Active then
  begin
    CatFilterTable.Close;
    CatFilterTable.EmptyTable;
  end;
  BrandTable.Close;
  GroupTable.Close;
  ParamTable.Close;
  DiscountTable.Close;
  memProfit.Close;
  Notes.Close;
  KK.Close;
  KitTable.Close;
  OOTable.Close;
 
   {!!!!!! Из-за квэрика не закрывалась 007_5!!!!!!!!!!!!!}
  QuerySelect.Close;
  AutoMakerTable.Close;
    {TEST ANALOG}
  AnalogIDTable.Close;
  AnalogMainTable_1.Close;
  AnalogMainTable_2.Close;
  AnalogMainTable_3.Close;
  AnalogMainTable_4.Close;
  AnalogMainTable_5.Close;
  {END}

  memAnalog.Close; {new}
end;


{----------------------------------------------------------------------------
Тестирование базы данных
-----------------------------------------------------------------------------}
procedure TData.DataTest;
var
  i: Integer;
  s, DefaultID: string;

  sOldEmail: string;
  aOldBrandsDiscounts: TStrings;
  aOldGlobalDiscount, aOldGlobalMargin: Double;
  aNeedConvertClientID_Ord, aNeedConvertClientID_Ret: Boolean;
  aTable: TDBISamTable;
  aTableCl: TDBISamTable;
  aTableWait: TDBISamTable;
  
  procedure ParDef(fld: string; v: Variant);
  begin
    with ParamTable do
    begin
      if FieldByName(fld).Value = null then
        FieldByName(fld).Value := v;
    end
  end;

  procedure ViewDef(fld: string; v: Variant);
  begin
  //ViewDef
    with ColumnView do
    begin
      if FieldByName(fld).Value = null then
        FieldByName(fld).Value := v;
    end
  end;

  procedure SParDef(fld: string; v: Variant);
  begin
    with SysParamTable do
    begin
      if FieldByName(fld).Value = null then
        FieldByName(fld).Value := v;
    end
  end;

  procedure VParDef(fld: string; v: Variant);
  begin
    with VersionTable do
    begin
      if FieldByName(fld).Value = null then
        FieldByName(fld).Value := v;
    end
  end;

var
  aStockQuantTable: TDBISAMTable;
begin
  TestTable(SysParamTable, data_psw);

  with SysParamTable do
  begin
    Open;
    if IsEmpty then
      Append
    else
      Edit;
    SParDef('Ign_chars', ' _');
    SParDef('Decimal_sep', ',');
    SParDef('Load_log', True);
    SParDef('Tecdoc_id', 5000000);
    SParDef('Pict_id',   5000000);
    SParDef('Act_period', 90);
    SParDef('Act_warn_period', 7);
    SParDef('Ver_info1',
            'Каталог безнадежно устарел! Обновите с сайта http://shate-m.by');
    SParDef('Ver_info2',
            'Каталог устарел! Обновите с сайта http://shate-m.by');
    SParDef('Ord_send_info', 'Заказ отправлен.');

    SParDef('HOST', '178.124.153.251');     //DSL1
    SParDef('BackHOST', '178.124.153.252'); //DSL2
    SParDef('TCPHost3', '178.163.128.37');  //триджик
    SParDef('TCPHostOpt', '178.124.155.166'{mx3.shate-m.com}); //оптика

    SParDef('Port', 6002);
    SParDef('PortIn', 6003);
    SParDef('ITNPort', 6004);


    SParDef('QuestionEmail', 'QuestionFromSP@shate-m.com');
    //SParDef('ReturnDocEmail', 'shate-m@nsys.by');

    if (FieldByName('UpdateMirrors').AsString = '') or
        (FieldByName('UpdateMirrors').AsString = '0=http://shate-m.com/data/service') then
       FieldByName('UpdateMirrors').AsString :=
         '0=http://mx3.shate-m.com/service-http,' +
         '1=http://86.57.246.208/service,' +
         '2=http://shate-m.by/data/service';

    //телефон отдела поставки
    SParDef('DeliveryPhone', '(044) 595-36-30');
    if FieldByName('DeliveryPhone').AsString = '' then
      FieldByName('DeliveryPhone').AsString := '(044) 595-36-30';

    SParDef('Shate_email', 'request@shate-m.com');

    SParDef('EmailLimit',        'Olga.Parzhetskaya@shate-m.com,Dmitriy.Sak@shate-m.com,Kristina.Pavlova@shate-m.com,Ivan.Lopouh@shate-m.com');
    SParDef('EmailSaleOrder',    'Olga.Parzhetskaya@shate-m.com,Dmitriy.Sak@shate-m.com,Kristina.Pavlova@shate-m.com,Ivan.Lopouh@shate-m.com');
    SParDef('EmailRetSaleOrder', 'Olga.Parzhetskaya@shate-m.com,Dmitriy.Sak@shate-m.com,Kristina.Pavlova@shate-m.com,Ivan.Lopouh@shate-m.com');
    SParDef('EmailReturn',       'Olga.Parzhetskaya@shate-m.com,Dmitriy.Sak@shate-m.com,Kristina.Pavlova@shate-m.com,Ivan.Lopouh@shate-m.com');
    SParDef('MaxDiscount', '25');

    Post;
    Close;
  end;

  TestTable(ColumnView, data_psw);
  with ColumnView do
  begin
    Open;
    if IsEmpty then
    begin
      Append;
    end
    else
      Edit;
      ViewDef('Code',TRUE);
      ViewDef('BrandDescrView',FALSE);
      ViewDef('Name_Descr',TRUE);
      ViewDef('Price_koef',TRUE);
      ViewDef('Price_koef_rub',FALSE);
      ViewDef('Price_koef_usd',FALSE);
      ViewDef('Price_koef_eur',FALSE);
      //Quantity
      ViewDef('Quantity',TRUE);
      ViewDef('QuantNew',FALSE);
      ViewDef('OrdQuantityStr',TRUE);
      ViewDef('SaleQ',TRUE);
      ViewDef('New',TRUE);
      ViewDef('Usa',TRUE);
      ViewDef('Price_pro',FALSE);

      Post;
      Close;
  end;

  sOldEmail := '';
  aOldGlobalDiscount := 0.0;
  aOldGlobalMargin := 0.0;
  Query.SQL.Text := 'SELECT Cli_email, Discount, Profit from [001]';
  try
    Query.Open;
    if not Query.EOF then
    begin
      sOldEmail := Query.Fields[0].AsString;
      aOldGlobalDiscount := Query.Fields[1].AsFloat;
      aOldGlobalMargin := Query.Fields[2].AsFloat;
    end;
    Query.Close;
    CopyTableBase('001', '001_bk', False);
  except

  end;
  Query.Close;
  Query.SQL.Clear;

  TestTable(ParamTable, data_psw);


  with ParamTable do
  begin
    Open;
    if IsEmpty then
    begin
      Append;
      ParDef('Upgrade_level', CURR_UPGRADE_LEVEL);
    end
    else
      Edit;
    ParDef('Tree_mode', 0);
    ParDef('Show_mparam', True);
    //ParDef('Discount', 0);
    ParDef('Eur_rate', 1);
    ParDef('Eur_usd_rate', 1);
    ParDef('Currency', 0);
    ParDef('Show_start_info', True);
    ParDef('Hide_start_info', False);
    ParDef('Filt_range', '0');
    ParDef('Filt_mode', 0);
    ParDef('Sale_backgr', Main.MainGrid.Color);
    ParDef('Sale_font', FontToStr(Main.MainGrid.Font));
    ParDef('Noquant_backgr', Main.MainGrid.Color);
    ParDef('Noquant_font', FontToStr(Main.MainGrid.Font));
    ParDef('QCell_color', True);
    ParDef('SCell_color', True);
    ParDef('Page', 0);
    ParDef('Net_interv',  50000);
    ParDef('Cli_id_mode',  '0');
    ParDef('Hide_NewInProg', False);
    ParDef('TCP_direct', TRUE);
    //ShowMessageAddOrder
    ParDef('ShowMessageAddOrder', TRUE);
    ParDef('UseProxy',  False);
    ParDef('UseProxyAutoresation', False);
    ParDef('ProxyUser', '');
    ParDef('ProxyPassword','');
    ParDef('bUnionDetailAnalog',FALSE);
    ParDef('bPasiveUpdate',TRUE);
    ParDef('bPasiveUpdateProg',TRUE);
    ParDef('bPasiveUpdateQuants',TRUE);
    ParDef('iUpdateTypeLoad',1);
    ParDef('iUpdateTypeLoadQuants',1);
    ParDef('bSaveWithPrice',FALSE);
    ParDef('bSortOrderDet',TRUE);
    ParDef('bVisibleRunningLine',TRUE);
    ParDef('HideTree',FALSE);
    ParDef('HideBrand',FALSE);
    ParDef('HideName',FALSE);
    ParDef('HideOE',FALSE);
    ParDef('ColorRunString',clBlack);
    ParDef('UseMemory',TRUE);
    ParDef('bUpdateKursesWithQuants', TRUE);
    ParDef('Hide_update_report', True);
    ParDef('Hide_discountSB', False); //скрыть скидку в статус-баре
    ParDef('AnalogFilterEnabled', False); //фильтр аналогов "только с наличием"
    ParDef('ShowAllOrders', False); //видеть все заказы и возвраты (не относящиеся к текущему клиенту)
    ParDef('AutoSwitchCurClient', False); //автоматически переключать текущего клиента на тот что в заказе/возврате
    //scheduled tasks
    ParDef('AutoCheckDiscounts', True); //Автоматически получать скидки по TCP
    ParDef('AutoCheckDiscountsInt', 60);//Интервал проверки, мин
    ParDef('AutoCheckOrders', True);    //Автоматически получать TCP ответы по заказам
    ParDef('AutoCheckOrdersInt', 15);   //Интервал проверки, мин
    ParDef('AutoCheckStatuses', True);  //Автоматически проверять статусы заказов
    ParDef('AutoCheckStatusesInt', 15); //Интервал проверки, мин

    LoadCurrencyRounding(gCurrencyRounding);//from DB
    if FieldByName('Rounding').AsString = '' then
      SaveCurrencyRounding(gCurrencyRounding);//to DB

    ParDef('AutoCheckRss', True); //Автоматически получать RSS
    ParDef('AutoCheckRssInt', 30);//Интервал проверки, мин
    ParDef('bShowRssOnUpdate', True); //показывать новости после обновления(если изменились)

    //sklad >>
    ParDef('ColorSaleOrder', 8454016);
    ParDef('ColorOrder', 16777215);
    ParDef('ColorLimit', 16744448);
    ParDef('ColorReturnOrder', 8421631);
    ParDef('ColorReturnPost', 255);
    ParDef('BasicColor', 65408);
    ParDef('BasicTextFont', 'Tahoma;1;128;8;1');

    ParDef('ToForbidRemovalOrder', True);
    ParDef('ToForbidReturnDocPost', True);
    ParDef('ToForbidSalelOrder', True);
    ParDef('ToForbidReturnOrder', True);
    ParDef('ToForbidLimit', True);

    ParDef('bQuantsInGrid', False);

    ParDef('bApplyColorQuantsShate', True);
    ParDef('bApplyColorQuantsBase', True);
    //<< sklad


    //
    //FieldByName('ColorRunString').Value
    //
    //iUpdateTypeLoadQuants
    Post;
    Close;
  end;

  TestTable(VersionTable, data_psw);
  with VersionTable do
  begin
    Open;
    if IsEmpty then
      Append
    else
      Edit;
    s := GetFileDateVersion(Application.ExeName);
    VParDef('ProgVersion',  s); //!!! это надо делать всегда, а не при пустом поле
    if FieldByName('TiresVersion').asString = '' then
      VParDef('TiresVersion', '120101.1');
    if FieldByName('TypVersion').asString = '' then
      VParDef('TypVersion', '120101.1');
    if FieldByName('PictsVersion').asString = '' then
      FieldByName('PictsVersion').asString := '140609.1,140623.1'; //из-за типа Memo нельзя испольовать VParDef
    Post;
    Close;
  end;

  TestTable(CatalogTable, data_psw);
  TestTable(AnalogTable, data_psw);

  TestTable(AnalogIDTable);

  TestTable(AnalogMainTable_1);
  TestTable(AnalogMainTable_2);
  TestTable(AnalogMainTable_3);
  TestTable(AnalogMainTable_4);
  TestTable(AnalogMainTable_5);


  {discounts ----------------------------}
  //сохраняем старые скидки в TStrings <brand_id>=<discount>
  aOldBrandsDiscounts := nil;
  if BrandTable.Exists then
  begin
    aTable := TDBISAMTable.Create(nil);
    try
      aTable.DatabaseName := BrandTable.DatabaseName;
      aTable.TableName := BrandTable.TableName;
      aTable.FieldDefs.Clear;
      aTable.FieldDefs.Update;
      if aTable.FieldDefs.IndexOf('Discount') >= 0 then
      begin
        aOldBrandsDiscounts := TStringList.Create;
        aTable.Open;
        aTable.First;
        while not aTable.Eof do
        begin
          if aTable.FieldByName('Discount').AsFloat > 0 then
            aOldBrandsDiscounts.Add(aTable.FieldByName('brand_id').AsString + '=' + aTable.FieldByName('Discount').AsString);
          aTable.Next;
        end;
        aTable.Close;
      end;
    finally
      aTable.Free;
    end;
  end;

  TestTable(BrandTable, data_psw);

  TestTable(GroupTable, data_psw);
  TestTable(GroupBrandTable, data_psw);
  TestTable(MyGroupTable, data_psw);
  TestTable(FiltTable, data_psw);


  {discounts ----------------------------}
  aNeedConvertClientID_Ord := False;
  aNeedConvertClientID_Ret := False;
  aTable := TDBISAMTable.Create(nil);
  try
    if OrderTable.Exists then
    begin
      aTable.DatabaseName := OrderTable.DatabaseName;
      aTable.TableName := OrderTable.TableName;
      aTable.FieldDefs.Clear;
      aTable.FieldDefs.Update;
      if aTable.FieldDefs.IndexOf('Cli_id') >= 0 then
        aNeedConvertClientID_Ord := (aTable.FieldDefs[aTable.FieldDefs.IndexOf('Cli_id')].DataType = ftInteger) and
                                    (OrderTableCli_id.DataType = ftString);
    end;

    if ReturnDocTable.Exists then
    begin
      aTable.DatabaseName := ReturnDocTable.DatabaseName;
      aTable.TableName := ReturnDocTable.TableName;
      aTable.FieldDefs.Clear;
      aTable.FieldDefs.Update;
      if aTable.FieldDefs.IndexOf('Cli_id') >= 0 then
        aNeedConvertClientID_Ret := (aTable.FieldDefs[aTable.FieldDefs.IndexOf('Cli_id')].DataType = ftInteger) and
                                    (ReturnDocTableCli_id.DataType = ftString);
    end;
  finally
    aTable.Free;
  end;

  TestTable(OrderTable, data_psw);
  TestTable(ReturnDocTable,data_psw);

  {discounts ----------------------------}
  //замена ссылок на ID клиента на ID клиента в заказах и возвратах
  if ClIDsTable.Exists and (aNeedConvertClientID_Ord or aNeedConvertClientID_Ret) then
  begin
    try
      CopyTableBase('011', '011_bk', False);
      CopyTableBase('009', '009_bk', False);
      CopyTableBase('010', '010_bk', False);
      CopyTableBase('036', '036_bk', False);
      CopyTableBase('037', '037_bk', False);
    except
      //..
    end;


    aTable := TDBISAMTable.Create(nil);
    aTableCl := TDBISAMTable.Create(nil);
    try
      aTableCl.DatabaseName := ClIDsTable.DatabaseName;
      aTableCl.TableName := ClIDsTable.TableName;
      aTableCl.Open;

      if aNeedConvertClientID_Ord then
      begin
        aTable.DatabaseName := OrderTable.DatabaseName;
        aTable.TableName := OrderTable.TableName;
        aTable.Open;

        aTable.First;
        while not aTable.Eof do
        begin
          if aTable.FieldByName('Cli_id').AsString <> '' then
            if aTableCl.Locate('ID', aTable.FieldByName('Cli_id').AsString, []) then
            begin
              aTable.Edit;
              aTable.FieldByName('Cli_id').AsString := aTableCl.FieldByName('Client_ID').AsString;
              aTable.Post;
            end;
          aTable.Next;
        end;
        aTable.Close;
      end;

      if aNeedConvertClientID_Ret then
      begin
        aTable.DatabaseName := ReturnDocTable.DatabaseName;
        aTable.TableName := ReturnDocTable.TableName;
        aTable.Open;

        aTable.First;
        while not aTable.Eof do
        begin
          if aTable.FieldByName('Cli_id').AsString <> '' then
            if aTableCl.Locate('ID', aTable.FieldByName('Cli_id').AsString, []) then
            begin
              aTable.Edit;
              aTable.FieldByName('Cli_id').AsString := aTableCl.FieldByName('Client_ID').AsString;
              aTable.Post;
            end;
          aTable.Next;
        end;
        aTable.Close;
      end;

      aTableCl.Close;
    finally
      aTable.Free;
      aTableCl.Free;
    end;
  end;

  TestTable(ClIDsTable, data_psw);
  TestTable(OrderDetTable, data_psw);
  TestTable(ReturnDocDetTable, data_psw);

  //перенос E-Mail в таблицу клиентов
  if Length(sOldEmail) > 0 then
  begin
    try
      Query.Close;
      Query.SQL.Text := 'update [011] set email = ''' + sOldEmail + '''';
      Query.ExecSQL;
    except

    end;
    Query.Close;
    Query.SQL.Clear;
  end;
  
  TestTable(QuantTable, data_psw);
  TestTable(SkladQuants, data_psw);
  
  TestTable(CatDetTable, data_psw);
  TestTable(CatTypDetTable, data_psw);
  TestTable(CatParTable, data_psw);
  TestTable(OETable, data_psw);

  TestTable(OEIDTable, data_psw);
  TestTable(OEDescrTable, data_psw);

  TestTable(ManufacturersTable, data_psw);
  TestTable(ModelsTable, data_psw);
  TestTable(TypesTable, data_psw);
  TestTable(ArtTypTable, data_psw);
  TestTable(DesTextsTable, data_psw);
  TestTable(CdsTextsTable, data_psw);
//  TestTable(CatPictTable, data_psw); //delete
  TestTable(PictTable, data_psw);
//  TestTable(OEMap, data_psw);

  if Main.AdminMode then
  begin
    TestTable(TDArtTable);
    TestTable(TDBrandTable);
  end;
  try
    Query.Close;
    Query.SQL.Text := 'select cli_id from [017]';
    Query.ExecSQL;
  except
    TestTable(WaitListTable, data_psw);

    ClIDsTable.open;
    ClIDsTable.Locate('ByDefault','1',[]);
    DefaultID := ClIDsTable.FieldByName('Client_id').asString;
    ClIDsTable.close;

    aTableWait := TDBISAMTable.Create(nil);
    try
      aTableWait.DatabaseName := WaitListTable.DatabaseName;
      aTableWait.TableName := WaitListTable.TableName;
      aTableWait.Open;
      aTableWait.First;
      while not aTableWait.Eof do
      begin
        aTableWait.Edit;
        aTableWait.FieldByName('Cli_id').asString := DefaultID;
        aTableWait.Post;
        aTableWait.Next;
      end;
      aTableWait.close;
    Finally
      aTableWait.Free;
    end;
  end;
  Query.Close;
  Query.SQL.Clear;

  TestTable(WaitListTable, data_psw);
  TestTable(BrDiscountTable, data_psw);
  TestTable(WaitListTable, data_psw);
  TestTable(TextAttrTable, data_psw);
  TestTable(PrimenTable,data_psw);
  TestTable(MyBrandTable,data_psw);
  TestTable(BlockMfaTable,data_psw);
  TestTable(AutoHistTable,data_psw);
  TestTable(TableCarFilter,data_psw);
  TestTable(DescriptionTable,data_psw);
  TestTable(AssortmentExpansion,data_psw);
  TestTable(Notes,data_psw);

  TestTable(DiscountTable, data_psw);
  TestTable(KK, data_psw);
  TestTable(memProfit);
  TestTable(KitTable, data_psw);
  TestTable(OOTable, data_psw);

  TestTable(TiresCarMake);
  TestTable(TiresCarModel);
  TestTable(TiresCarEngine);
  TestTable(TiresDimensions);

  {discounts ----------------------------}
  //закинуть скидки по брендам и глобальные для каждого клиента
  if Assigned(aOldBrandsDiscounts) then //индикатор - если лист создан, значит переходим на новую версию скидок
  begin
    if (aOldGlobalDiscount > 0) or (aOldGlobalMargin > 0) or (aOldBrandsDiscounts.Count > 0) then
    begin
      Query.SQL.Text := 'delete from [038]';
      Query.ExecSQL;
      Query.Close;

      aTableCl := TDBISAMTable.Create(nil);
      try
        aTableCl.DatabaseName := ClIDsTable.DatabaseName;
        aTableCl.TableName := ClIDsTable.TableName;
        aTableCl.Open;
        aTableCl.First;
        //каждому клиенту одинаковае скидки
        while not aTableCl.Eof do
        begin
          //глобальные
          Query.SQL.Text := ' INSERT INTO [038] ( CLI_ID,  GR_ID,  SUBGR_ID,  BRAND_ID,  Discount,  Margin) ' +
                            '            VALUES (:CLI_ID, :GR_ID, :SUBGR_ID, :BRAND_ID, :Discount, :Margin) ';
          if (aOldGlobalDiscount > 0) or (aOldGlobalMargin > 0) then
          begin
            Query.Params[0].AsString := aTableCl.FieldByName('Client_ID').AsString;
            Query.Params[1].AsInteger := 0;
            Query.Params[2].AsInteger := 0;
            Query.Params[3].AsInteger := 0;
            Query.Params[4].AsFloat := aOldGlobalDiscount;
            Query.Params[5].AsFloat := aOldGlobalMargin;
            Query.ExecSQL;
            Query.Close;
          end;

          //по брендам
          for i := 0 to aOldBrandsDiscounts.Count - 1 do
          begin
            Query.Params.Clear;
            Query.SQL.Text :=
              ' INSERT INTO [038] (CLI_ID,  GR_ID,  SUBGR_ID,  BRAND_ID,  Discount) ' +
              '   SELECT ''' + aTableCl.FieldByName('Client_ID').AsString + ''', GROUP_ID, SUBGROUP_ID, BRAND_ID, ' + aOldBrandsDiscounts.Values[aOldBrandsDiscounts.Names[i]] + ' FROM [005] ' +
              '   WHERE BRAND_ID = ' + aOldBrandsDiscounts.Names[i];
            Query.ExecSQL;
            Query.Close;
          end;
          aTableCl.Next;
        end;
        aTableCl.Close;
      finally
        aTableCl.Free;
      end;
    end;
  end;

  //sklad >>
  TestTable(TableBases, data_psw);
  {Переход на розничные цены}
  TableBases.Open;
  while not TableBases.Eof do
  begin
    TableBases.Edit;
    TableBases.FieldByName('Currency').AsString := 'BYR';
    TableBases.Post;
    TableBases.Next;
  end;
  TableBases.Close;
  {План отхода с розничных цен}

  {  TableBases.Open;
  while not TableBases.Eof do
  begin
    TableBases.Edit;
    if TableBases.FieldByName('Code').AsInteger in [20, 21, 22] then
      TableBases.FieldByName('Currency').AsString := 'BYR'
    else
      TableBases.FieldByName('Currency').AsString := 'EUR';
    TableBases.Post;
    TableBases.Next;
  end;
  TableBases.Close;}


  for i := 2 to cQuantBasesCount do
  begin
    aStockQuantTable := TDBISamTable(Self.FindComponent('QuantTable' + IntToStr(i)));
    TestTable(aStockQuantTable, data_psw);
  end;

  TestTable(TableDocLimit);
  TestTable(TableDocLimitDet);
  TestTable(TableSaleOrder);
  TestTable(TableSaleOrderDet);
  TestTable(TableReturnDoc);
  TestTable(TableReturnDocDet);
  //<< sklad
  TestTable(AutoMakerTable, data_psw);
  ConvertRetDocs; //перенос возвратов из старых таблиц в новые
  RunDatabaseFixes;
end;


procedure TData.DoSearch;
var
//  t: Cardinal;
  lFound, lDouble: boolean;
  s, flt: string;
  len: integer;
  rn: LongInt;
  sFilter:string;
  TreeItem:TTreeNode;
  Table:TDBISAMTable;
  sFieldName:string;
  sSelCode:string;
  iSelStart, OERange:integer;
begin

  iSelStart := Main.SearchEd.SelStart;

  SearchDoubleTimer.Enabled := False;
  s := AnsiUpperCase(MakeSearchCode(Main.SearchEd.Text));

  if Main.CodeIgnoreSpecialSymbolsCheckBox.Checked then
    s := CreateShortCode(s);

  s := ReplaceStr(s,'''','''''');
  Main.SearchEd.Text := s;
//  Main.SearchEd.SelStart:= Length(s);
  if iSelStart <  Length(s) then
    Main.SearchEd.SelStart := iSelStart 
  else
    Main.SearchEd.SelStart:= Length(s);
  len := Length(s);

  if len = 0 then
  begin
    if Data.CatalogDataSource.DataSet.Active then
     begin
      Main.SearchEd.Color := clWindow;
      CatalogDataSource.DataSet.First;
     end;
    exit;
  end;

  if (Group <> 0) or (Subgroup <> 0) or (fBrand <> 0) then
     begin
       Group := 0;
       Subgroup := 0;
       fBrand := 0;
       Main.SelectInTree;
     end;
  //по коду
  if Main.SearchModeComboBox.ItemIndex = 0 then
  begin
    if Main.CodeIgnoreSpecialSymbolsCheckBox.Checked then
    begin
      Table := ShortSearchTable;
      sFieldName := 'ShortCode';
    end
    else
    begin
      Table := SearchTable;
      sFieldName := 'Code2';
    end;

    lFound := FALSE;
    lDouble := FALSE;
    Data.CatalogDataSource.DataSet.DisableControls;
    if Data.CatalogDataSource.DataSet.RecordCount < 10000 then
    begin
      if Data.CatalogDataSource.DataSet.Locate(sFieldName, s, [loCaseInsensitive, loPartialKey]) then
      begin
        lFound := TRUE;
        if CatalogDataSource.DataSet.FieldByName(sFieldName).AsString = s  then
          if Main.CodeIgnoreSpecialSymbolsCheckBox.Checked then
          begin
            if CatalogDataSource.DataSet.FieldByName('IDouble').AsInteger > 0 then
              lDouble := True;
          end
          else
            if CatalogDataSource.DataSet.FieldByName('IDouble').AsInteger = 1 then
              lDouble := True;
    end;
    end
    else
    begin
      with Table do
      begin
        if Locate(sFieldName, s, [loPartialKey]) then
          begin
            if Copy(FieldByName(sFieldName).AsString, 1, len) = s  then
            begin
              lFound := True;
              if CatalogDataSource.DataSet <> CatalogTable then
                CatalogDataSource.DataSet.Locate('Cat_id', Table.FieldByName('Cat_id').AsInteger, [loCaseInsensitive])
              else
                CatalogTable.GotoCurrent(Table);
              if CatalogDataSource.DataSet.FieldByName(sFieldName).AsString = s  then
                if Main.CodeIgnoreSpecialSymbolsCheckBox.Checked then
                  begin
                    if CatalogDataSource.DataSet.FieldByName('IDouble').AsInteger > 0 then
                        lDouble := True;
                    end
                  else
                    if CatalogDataSource.DataSet.FieldByName('IDouble').AsInteger = 1 then
                      lDouble := True;
            end;
          end;
      end;
    end;
    CatalogDataSource.DataSet.EnableControls;

    if lFound then
      begin
         Main.SearchEd.Color := clWindow;
          if lDouble then
            SearchDoubleTimer.Enabled := True;
      end
      else
      begin
         Main.SearchEd.Color := $00FF80FF;
         with Main.SearchEd do
          begin
            if CanFocus then
              SetFocus;
            //SelStart := Length(Text);
          end;
    end;
    exit;
  end; //end if по коду

  lFound := False;
  //по OE
 { if Main.SearchModeComboBox.ItemIndex = 1 then
  begin
    if Main.CodeIgnoreSpecialSymbolsCheckBox.Checked then
    begin
      sFieldName := 'ShortOE';
    end
    else
    begin
      sFieldName := 'Code2';
    end;

    with OESearchTable do
    begin
      if IndexName <> 'SIM' then
         IndexName := 'SIM';

      OERange := Ord(s[1]);
      if (not OESearchTable.Ranged) or (fOECurrentRange <> OERange) then
      begin
        OESearchTable.SetRange([OERange], [OERange]);
        fOECurrentRange := OERange;
      end;

      if OESearchTable.EOF then
        Exit;

      if Length(sAuto) > 0  then
      begin
        if OESearchTable.Filter <> sAuto then
        begin
          OESearchTable.Filter := sAuto;
          OESearchTable.Filtered := TRUE;
        end
        else
        if not OESearchTable.Filtered then
          OESearchTable.Filtered := TRUE;
      end
      else
        OESearchTable.Filtered := FALSE;

      if Locate(sFieldName, s, [loPartialKey]) then
      begin
        CatalogDataSource.DataSet.DisableControls;
        len := Length(s);
        while Copy(FieldByName(sFieldName).AsString, 1, len) = s  do
        begin
          if CatalogDataSource.DataSet <> CatalogTable then
          begin
            if CatalogDataSource.DataSet.Locate('Cat_id', OESearchTable.FieldByName('Cat_id').AsInteger, []) then
              begin
                lFound := TRUE;
                break;
              end;
          end
              else
              if SearchTable.Locate('Cat_id', OESearchTable.FieldByName('Cat_id').AsInteger, []) then
              begin
                CatalogTable.GotoCurrent(SearchTable);
                lFound := TRUE;
                break;
              end;
          Next;
        end;
        CatalogDataSource.DataSet.EnableControls;
      end;

    end;
    if lFound then
    begin
      Main.SearchEd.Color := clWindow;
    end
    else
    begin
      Main.SearchEd.Color := $00FF80FF;
      with Main.SearchEd do
      begin
        if CanFocus then
          SetFocus;
        //SelStart := Length(Text);
      end;
    end;

    exit;
  end;
  }
    if Main.SearchModeComboBox.ItemIndex = 1 then
  begin
  {  if Main.CodeIgnoreSpecialSymbolsCheckBox.Checked then
      sFieldName := 'ShortOE'
    else
      sFieldName := 'Code2';    }
      sFieldName := 'ShortOE';
    if OEDescrSearchTable.IndexName <> 'SIM' then
      OEDescrSearchTable.IndexName := 'SIM';

    OERange := Ord(s[1]);
    if (not OEDescrSearchTable.Ranged) or (fOECurrentRange <> OERange) then
    begin
      OEDescrSearchTable.SetRange([OERange], [OERange]);
      fOECurrentRange := OERange;
    end;

    if OEDescrSearchTable.EOF then
      Exit;

    if Length(sAuto) > 0  then
    begin
      if OEDescrSearchTable.Filter <> sAuto then
      begin
        OEDescrSearchTable.Filter := sAuto;
        OEDescrSearchTable.Filtered := TRUE;
      end
      else
      if not OEDescrSearchTable.Filtered then
        OEDescrSearchTable.Filtered := TRUE;
    end
    else
      OEDescrSearchTable.Filtered := FALSE;


    CatalogDataSource.DataSet.DisableControls;
    len := Length(s);

    if OEDescrSearchTable.Locate(sFieldName, s, [loPartialKey]) then
    begin
      while Copy(OEDescrSearchTable.FieldByName(sFieldName).AsString, 1, len) = s  do
      begin
        while not OEIDSearchTable.Eof do
        begin
          if CatalogDataSource.DataSet <> CatalogTable then
          begin
            if CatalogDataSource.DataSet.Locate('Cat_id', OEIDSearchTable.FieldByName('Cat_id').AsInteger, []) then
            begin
              lFound := TRUE;
              break;
            end;
          end
          else
          if SearchTable.Locate('Cat_id', OEIDSearchTable.FieldByName('Cat_id').AsInteger, []) then
          begin
            CatalogTable.GotoCurrent(SearchTable);
            lFound := TRUE;
            break;
          end;
          OEIDSearchTable.Next;
        end;
        if lFound then
          break;
        OEDescrSearchTable.Next;
      end;
    end;
    CatalogDataSource.DataSet.EnableControls;

    if lFound then
      Main.SearchEd.Color := clWindow
    else
    begin
      Main.SearchEd.Color := $00FF80FF;
        if Main.SearchEd.CanFocus then
          Main.SearchEd.SetFocus;
    end;
  end;
end;


procedure TData.DoubleTableCalcFields(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('Descr').Value := Trim(FieldByName('Name').AsString + '  ' +
                                       FieldByName('Description').AsString);
  end;
end;


procedure TData.DoubleTableShortCalcFields(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('Descr').Value := Trim(FieldByName('Name').AsString + '  ' +
                                       FieldByName('Description').AsString);
  end;
end;

procedure TData.SearchDoubleTimerTimer(Sender: TObject);
begin
  SearchDoubleTimer.Enabled := False;
  with TSearchGrid.Create(Application) do
  begin
    Show;
  end;
end;


procedure TData.GoToAnalog;
var
  iAnalog: Integer;
begin
  if memAnalog.FieldByName('An_id').AsInteger = 0 then
    exit;
  iAnalog := memAnalog.FieldByName('An_id').AsInteger;

  if CatalogDataSource.DataSet <> CatalogTable then
  begin
    Main.ResetFilter;
    CatalogDataSource.DataSet.DisableControls;
    CatalogDataSource.DataSet.Locate('Cat_id', iAnalog, [loCaseInsensitive]);
    CatalogDataSource.DataSet.EnableControls;
  end
  else
  begin
    Main.ResetFilter;
    with SearchTable do
    begin
      if IndexName <> '' then
      IndexName := '';
      if Locate('Cat_id', iAnalog, []) then
      begin
        CatalogTable.GotoCurrent(SearchTable);
        Main.MainGrid.SetFocus;
      end;
      IndexName := 'Code';
    end;
  end;
end;


procedure TData.SessionPassword(Sender: TObject; var Continue: Boolean);
begin
  Session.AddPassword(data_psw);
  Continue := True;
end;


{-----------------------------------------------------------------------------
Остановка сервера БД
-----------------------------------------------------------------------------}
procedure TData.StopServer;
var
  n: integer;
begin
  if Data_Mode <> DM_SERVER then
    exit;
  n := DBEngine.GetServerConnectedSessionCount;
  if (n > 0) and (MessageDlg(Format(BSStopServConfirm, [n]),
                             mtWarning, [mbYes, mbNo], 0) <> mrYes) then
    exit;
  DBEngine.Active := False;
  Application.Terminate;
end;

procedure TData.SysParamTableHostChange(Sender: TField);
begin

end;

//==== Определение режима доступа к данным =================
// - работа с локальной БД
// - как сервер
// - как клиент
procedure TData.TestForDataMode;
var
  i: integer;
begin
  Sys_Log_Flag := False;
  Data_Mode := DM_LOCAL;
  for i := 1 to ParamCount do
  begin
    if UpperCase(Copy(ParamStr(i), 1, 4)) = 'SERV' then
      Data_Mode := DM_SERVER
    else if UpperCase(Copy(ParamStr(i), 1, 3)) = 'CLI' then
      Data_Mode := DM_CLIENT;
    if UpperCase(Copy(ParamStr(i), 1, 3)) = 'LOG' then
      Sys_Log_Flag := True;
  end;
end;


procedure TData.TextAttrTableCalcFields(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('Sample').Value := 'Образец';
    FieldByName('LoHi').Value := IntToStr(FieldByName('Lo').AsInteger) + ' - ' +
                                 IntToStr(FieldByname('Hi').AsInteger)
  end;
end;

procedure TData.TimerSetCatFilterTimer(Sender: TObject);
begin
  TimerSetCatFilter.Enabled := FALSE;
  SetCatFilter;
end;

procedure TData.TypesTableCalcFields(DataSet: TDataSet);
var
  s: string;
begin
  with DataSet do
  begin
    if ModelsTable.Locate('Mod_id', FieldByName('Mod_id').AsInteger, []) and
       ManufacturersTable.Locate('Mfa_id', ModelsTable.FieldByName('Mfa_id').AsInteger, []) then
    begin
      FieldByName('TypeDescr').Value :=
         Trim(ManufacturersTable.FieldByName('Mfa_brand').AsString) + ' ' +
         Trim(ModelsTable.FieldByName('Tex_text').AsString) + ' ' +
         Trim(FieldByName('CdsText').AsString);
      FieldByName('MfaHide').Value := ManufacturersTable.FieldByName('Hide').AsBoolean;
    end
    else
    begin
      FieldByName('TypeDescr').Value :=
         '??? ' + Trim(FieldByName('CdsText').AsString);
      FieldByName('MfaHide').Value := False;
    end;
    s := '';
    if FieldByName('Pcon_start').AsInteger <> 0 then
    begin
      s := Copy(FieldByName('Pcon_start').AsString, 1, 4) + '/' +
           Copy(FieldByName('Pcon_start').AsString, 5, 2);
    end;
    if s <> '' then
      FieldByName('PconText1').Value := s;
    s := '';
    if (FieldByName('Pcon_end').AsInteger <> 0) and
       (FieldByName('Pcon_end').AsInteger <> FieldByName('Pcon_start').AsInteger)then
    begin
      s := Copy(FieldByName('Pcon_end').AsString, 1, 4) + '/' +
           Copy(FieldByName('Pcon_end').AsString, 5, 2);
    end;
    if s <> '' then
      FieldByName('PconText2').Value := s;
  end;
end;


procedure TData.LoadGrFromExcell(fname: string='');
begin
  if fname = '' then
  begin
    if not OpenDialog.Execute then
      exit;
    fname := OpenDialog.FileName;
  end;
  StartWait;
  AllClose;
  AssignFile(F, fname);
  Main.ShowProgress('Загрузка классификатора...', CalcLineCnt);
  LoadGroupBrand;
  CloseFile(F);
  AllOpen;
  LoadTree;
  Main.HideProgress;
  StopWait;
end;


function TData.CaclCurrency(price, priceQuants, priceQuantsSklad: Currency;
  Group, Subgroup, Brand: integer; sale: string): TCalcPrices;
var
  Prices: TCalcPrices;
  Price_pro_eur: Currency;
begin
  if priceQuantsSklad > 0 then
    Prices.PriceItog := priceQuantsSklad
  else if priceQuants > 0 then
    Prices.PriceItog := priceQuants
  else
    Prices.PriceItog := price;
  //***Конвертация в EUR***
  if priceQuantsSklad > 0 then
    Prices.PriceItog :=
      XRoundCurr(
      Prices.PriceItog / GetCurByCode(CurrSclad),
      ctEUR
      );

  if sale <> '1' then
    Prices.Price_koef_eur :=
      XRoundCurr(GetDiscount(Group,Subgroup,Brand) * Prices.PriceItog, ctEUR)
  else
    Prices.Price_koef_eur := Prices.PriceItog;

  //***Не переводить в случае совпадения валюты***
  if (CurrSclad = GetCurrencyCode(Curr)) and (PriceQuantsSklad > 0) then
    Prices.Price_koef:=
      XRoundCurr(
        GetDiscount(Group,Subgroup,Brand) * PriceQuantsSklad,
        getTypeCur(CurrSclad)
      )
  else
    Prices.Price_koef := XRoundCurr(Rate * Prices.Price_koef_eur,Curr);

  Prices.Price_koef_usd := XRoundCurr(ParamTable.FieldByName('Eur_usd_rate').AsCurrency *
                             Prices.Price_koef_eur,
                             ctUSD
                           );
  Prices.Price_koef_rub := XRoundCurr(ParamTable.FieldByName('Eur_rate').AsCurrency *
                            Prices.Price_koef_eur,
                             ctBYR
                           );
  if (CurrSclad = GetCurrencyCode(Curr)) then
  begin
    Price_pro_eur := XRoundCurr(Prices.Price_koef * GetMargin(Group,Subgroup,Brand),getTypeCur(CurrSclad));
    Prices.Price_pro := XRoundCurr( Price_pro_eur, Curr );
  end
  else
  begin
    Price_pro_eur := XRoundCurr(Prices.Price_koef_eur * GetMargin(Group, Subgroup,Brand),ctEUR);
    Prices.Price_pro := XRoundCurr( Price_pro_eur * Rate, Curr );
  end;
{
//******************************************
  if priceQuantsSklad > 0 then
    Prices.PriceItog := priceQuantsSklad
  else if priceQuants > 0 then
    Prices.PriceItog := priceQuants
  else
    Prices.PriceItog := Price;

  //***Конвертация***
  if (CurrSclad <> 'EUR') and (priceQuantsSklad > 0) then
    Prices.PriceItog := XRoundCurr(Prices.PriceItog / GetCurByCode(CurrSclad),ctEUR);

  if sale <> '1' then
     Prices.Price_koef_eur :=
       XRoundCurr(GetDiscount(Group,Subgroup,Brand) * Prices.PriceItog, ctEUR)
  else
    Prices.Price_koef_eur := Prices.PriceItog;

//***Не переводить в случае совпадения валюты***
  if (CurrSclad = GetCurrencyCode(Curr)) and (PriceQuantsSklad > 0) then
    Prices.Price_koef := PriceQuantsSklad
  else
    Prices.Price_koef := XRoundCurr(Rate * Prices.Price_koef_eur,Curr);

  Prices.Price_koef_usd :=
          XRoundCurr(ParamTable.FieldByName('Eur_usd_rate').AsCurrency * Prices.Price_koef_eur, ctUSD);

  Prices.Price_koef_rub :=
          XRoundCurr(ParamTable.FieldByName('Eur_rate').AsCurrency * Prices.Price_koef_eur, ctBYR);
  }
  result := Prices;
end;

function TData.CalcLineCnt: integer;
var
  cnt: integer;
  s: string;
begin
  cnt := 0;
  Reset(F);
  while not Eof(F) do
  begin
    Readln(F, s);
    Inc(cnt);
  end;
  Reset(F);
  Result := cnt;
end;


procedure TData.LoadGroupBrand;
var
  i, j: integer;
  s, gr, sgr, br: string;
  sSale_fl,sNew_fl,sUSA:string;
  bSale,bNew,bUSA:boolean;

  procedure AddToTable;
  begin
    with BrandTable do
    begin
      if not FindKey([br]) then
      begin
        Append;
        FieldByName('Description').Value := br;
        Post;
      end;
    end;
    with GroupTable do
    begin
      if not FindKey([gr, sgr]) then
      begin
        Append;
        FieldByName('Group_descr').Value    := gr;
        FieldByName('Subgroup_descr').Value := sgr;
        ///
        Post;
      end;
    end;
    if i mod 1000 = 0 then
      Main.CurrProgress(i);
  end;

begin
  with BrandTable do
  begin
    EmptyTable;
    Open;
    IndexName := 'Descr';
  end;
  with GroupTable do
  begin
    EmptyTable;
    Open;
    IndexName := 'GrDescr';
  end;
  i := 1;
  Reset(F);
  while not Eof(F) do
  begin
    Readln(F, s);
    br  := ExtractDelimited(1, s, [';']);
    gr  := ExtractDelimited(6, s, [';']);
    sgr := ExtractDelimited(7, s, [';']);
    AddToTable;
    Inc(i);
  end;
  Main.ShowProgrInfo('Перенумерация классификатора...');
  Application.ProcessMessages;
  with BrandTable do
  begin
    First;
    i := 1;
    while not Eof do
    begin
      Edit;
      FieldByName('Brand_id').Value := i;
      Post;
      Inc(i);
      Next;
    end;
    Close;
  end;
  with GroupTable do
  begin
    First;
    i := 1;
    while not Eof do
    begin
      gr := FieldByName('Group_descr').AsString;
      j := 1;
      while (not Eof) and (FieldByName('Group_descr').AsString = gr) do
      begin
        Edit;
        FieldByName('Group_id').Value := i;
        FieldByname('Subgroup_id').Value := j;
        Post;
        Inc(j);
        Next;
      end;
      Inc(i);
    end;
    Close;
  end;
end;

procedure TData.StartLog(fname: string);
begin
  if Load_Log then
  begin
    AssignFile(FLog, GetAppDir + fname);
    Rewrite(FLog);
    WLog('Начало обработки: ' + DateTimeToStr(Now));
    WLog('-------------------------------------------------------------------');
  end;
end;

procedure TData.WaitListTableCalcFields(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('BrandRepl').AsString := ReBranding(FieldByName('Brand').AsString); {ReBranding}
    if BrandTable.Locate('Description', FieldByName('Brand').AsString, []) and
       XCatTable.FindKey([FieldByName('Code2').AsString,
                          BrandTable.FieldByName('Brand_id').AsInteger]) then
    begin
      FieldByname('Cat_Id').Value := XCatTable.FieldByName('Cat_Id').AsInteger;
      FieldByname('ArtCode').Value := XCatTable.FieldByName('Code').AsString;
      FieldByname('ArtName').Value := XCatTable.FieldByName('Name').AsString;
      FieldByname('ArtDescr').Value := XCatTable.FieldByName('Description').AsString;
      FieldByname('ArtPrice').Value := XCatTable.FieldByName('PriceItog').AsFloat;
      FieldByname('ArtGroupId').Value := XCatTable.FieldByName('Group_ID').AsFloat;
      FieldByname('ArtSubgroupId').Value := XCatTable.FieldByName('Subgroup_ID').AsFloat;


      if XCatTable.FieldByName('SaleQ').AsString = '1' then
        FieldByname('ArtSale').Value := XCatTable.FieldByName('SaleQ').AsInteger
      else
        FieldByname('ArtSale').Value := 0;

      FieldByname('ArtBrandId').Value := XCatTable.FieldByName('Brand_id').AsString;
      if QuantTable.FindKey([XCatTable.FieldByName('Cat_id').AsInteger]) then
      begin
        FieldByName('ArtQuant').Value := QuantTable.FieldByName('Quantity').AsString;
        FieldByName('ArtQuantLatest').Value := QuantTable.FieldByName('Latest').AsInteger;
      end;
    end;

{    if FieldByName('ArtSale').AsString <> '1' then
      FieldByName('Price_koef_eur').Value :=
           XRoundCurr(
             GetDiscount(
               FieldByName('ArtGroupId').AsInteger,
               FieldByName('ArtSubgroupId').AsInteger,
               FieldByName('ArtBrandId').AsInteger
             ) * FieldByName('ArtPrice').AsCurrency, ctEUR
           )
    else}
     //FieldByName('Price_koef_eur').Value := XCatTable.FieldByName('Price_koef_eur').AsFloat;//FieldByName('ArtPrice').AsCurrency;
     //FieldByName('Price_koef').Value := XCatTable.FieldByName('Price_koef').AsFloat;

    FieldByName('ArtNameDescr').Value := Trim(FieldByName('ArtName').AsString + ' ' +
                                              FieldByname('ArtDescr').AsString);
    if (FieldByName('ClientLookup').IsNull) or (ParamTable.FieldByName('Cli_id_mode').AsString <> '1') then
      FieldByName('ClientInfo').Value := FieldByName('Cli_id').AsString
    else
      FieldByName('ClientInfo').Value := FieldByName('ClientLookup').AsString;
  end;
end;

procedure TData.WaitListTableFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
var
  v, v1: variant;
  s: string;
  aLatest: Boolean;
  aClientAccept: Boolean;
begin
  if BrandTable.Locate('Description', DataSet.FieldByName('Brand').AsString, []) and
     XCatTable.FindKey([DataSet.FieldByName('Code2').AsString,
                        BrandTable.FieldByName('Brand_id').AsInteger]) then
  begin
    v := QuantTable.Lookup('Cat_id', XCatTable.FieldByName('Cat_id').AsInteger, 'Quantity');
    v1 := QuantTable.Lookup('Cat_id', XCatTable.FieldByName('Cat_id').AsInteger, 'Latest');
  end
  else
  begin
    v := null;
    v1 := null;
  end;
  
  if v <> null then
    s := string(v)
  else
    s := '';

  if v1 <> null then
    aLatest := Integer(v1) = 1
  else
    aLatest := False;

  aClientAccept := (fWaitListTableClientFilter = '') or (fWaitListTableClientFilter = DataSet.FieldByName('cli_id').AsString);

  case Main.WaitListViewComboBox.ItemIndex of
    0: Accept := True;
    1: Accept := (s <> '') and (s <> '0');
    2: Accept := (s = '') or (s = '0');
    3: Accept := aLatest;
  end;
  Accept := Accept and aClientAccept;
end;

procedure TData.WaitListTableNewRecord(DataSet: TDataSet);
begin
  WaitListTable.FieldByName('DateCreate').value := Now;
end;

procedure TData.WLog(s: string);
begin
  if Load_Log then
    WriteLn(FLog, s);
end;


procedure TData.XCatTableCalcFields(DataSet: TDataSet);
var
  prices: TCalcPrices;
begin
  if not fDatabaseOpened then
    exit;
  with Dataset do
  begin
   FieldByName('SaleQ').Value := FieldByName('saleQCalc').Value;
 {
    if FieldByName('PriceQuant').AsCurrency > 0 then
       FieldByName('PriceItog').AsCurrency := FieldByName('PriceQuant').AsCurrency
    else
       FieldByName('PriceItog').AsCurrency := FieldByName('Price').AsCurrency;
  }
    Prices := CaclCurrency(FieldByName('Price').AsCurrency,FieldByName('PriceQuant').AsCurrency,FieldByName('PriceQuantSklad').AsCurrency,
                           FieldByName('Group_id').AsInteger,FieldByName('SubGroup_id').AsInteger,FieldByName('Brand_id').AsInteger,
                           FieldByName('SaleQ').AsString
                        );
    FieldByName('PriceItog').AsCurrency := Prices.Price_koef;

    FieldByName('Name_Descr').Value := Trim(FieldByName('Name').AsString + ' ' +
                                       FieldByname('Description').AsString);
  end;
end;

procedure TData.StopLog;
begin
  if Load_Log then
  begin
    WLog('-------------------------------------------------------------------');
    WLog('Конец обработки: ' + DateTimeToStr(Now));
    CloseFile(FLog);
  end;
end;

procedure TData.LoadCatFromExcell(fname: string='');
begin

  if fname = '' then
  begin
    if not OpenDialog.Execute then
      exit;
    fname := OpenDialog.FileName;
  end;
  StartWait;

  StartLog('LoadCatalog.log');

  AllClose;

  LoadBrandReplTable;

  ParamTable.Open;
  CatalogTable.AfterScroll := nil;
  Main.LoadTDInfoTimer.Enabled := False;
  AssignFile(F, fname);
  Main.ShowProgress('Загрузка классификатора...', CalcLineCnt);
  LoadGroupBrand;

  Main.ShowProgress('Загрузка каталога...', CalcLineCnt);
  LoadCatalog;
  CloseFile(F);
  ParamTable.Close;
  AllOpen;
  //LoadPrimenMemo;
  LoadTree;
  CatalogDataSource.DataSet.AfterScroll := Data.CatalogTableAfterScroll;
  Main.HideProgress;
  StopLog;
  BrandReplTable.Close;
  BrandReplTable.DeleteTable;
  StopWait;
  ShowLoadCatStat;
end;

procedure TData.ShowLoadCatStat;
begin
  MessageDlg('Загружено позиций: ' + IntToStr(ld_cnt) + #13#10 +
             'Распознано в Tecdoc: ' + IntToStr(td_cnt) +
             ' (' +  FloatToStr(Round(td_cnt / ld_cnt * 100)) + '%)', mtInformation, [mbOK], 0);
end;


procedure TData.LoadTextAttrList;
var
  i: integer;
begin
  SetLength(Main.TextAttrList, 0);
  with TextAttrTable do
  begin
    Open;
    First;
    i := 0;
    while not Eof do
    begin
      Inc(i);
      SetLength(Main.TextAttrList, i);
      Main.TextAttrList[i-1].Lo         := FieldByName('Lo').AsInteger;
      Main.TextAttrList[i-1].Hi         := FieldByName('Hi').AsInteger;
      Main.TextAttrList[i-1].BackGround := FieldByName('Background').AsInteger;
      Main.TextAttrList[i-1].Font       := StrToFont(FieldByName('Font').AsString);
      Next;
    end;
    Close;
  end;
  with ParamTable do
  begin
    Main.SaleFont      := StrToFont(FieldByName('Sale_font').AsString);
    Main.NoQuantFont   := StrToFont(FieldByName('NoQuant_font').AsString);
    Main.SaleBackgr    := FieldByName('Sale_backgr').AsInteger;
    Main.NoQuantBackgr := FieldByName('NoQuant_backgr').AsInteger;
    Main.QCellColor    := FieldByName('QCell_color').AsBoolean;
    Main.SCellColor    := FieldByName('SCell_color').AsBoolean;
  end;
end;

procedure TData.LoadCatalog;
var
  i: integer;
  s, gr, sgr, br, code, code2, nam, descr, rp: string;
  gi, si, bi: integer;
  price: Currency;
  oldDS: char;
  td_id: integer;
  new_fl, sale_fl, usa_fl: string;
  mult: integer;
  IDouble:integer;
  sSpeed: string;

  procedure AddToTable;
  var
    pict_id, typ_id, param_id: Integer;
  begin
    pict_id := 0;
    typ_id := 0;
    param_id := 0;
    
    BrandTable.FindKey([br]);
    bi := BrandTable.FieldByName('Brand_id').AsInteger;
    GroupTable.FindKey([gr, sgr]);
    gi := GroupTable.FieldByName('Group_id').AsInteger;
    si := GroupTable.FieldByName('Subgroup_id').AsInteger;

    if BrandReplTable.FindKey([br]) and
       (BrandReplTable.FieldByName('Repl_brand').AsString <> '') then
      rp := BrandReplTable.FieldByName('Repl_brand').AsString
    else
      rp := br;

    if TDArtTable.FindKey([code2, rp]) then //[pict]
    begin
      Inc(td_cnt);
      td_id := TDArtTable.FieldByName('Art_id').AsInteger;

      //[pict, typ, param] - привязка к tecdoc
      pict_id := TDArtTable.FieldByName('pict_id').AsInteger;
      typ_id := TDArtTable.FieldByName('typ_id').AsInteger;
      param_id := TDArtTable.FieldByName('param_id').AsInteger;
    end
    else
    begin
      //WLog('Поз. не найдена в Tecdoc <' + code + ' / ' + br + '> в строке ' + IntToStr(i));
      td_id := 0;
    end;

    with LoadCatTable do
    begin
      if not FindKey([code2,bi]) then
      begin

        if Locate('Code2', code2, []) then
        begin
          Edit;
          IDouble := 1;
          FieldByName('IDouble').Value := IDouble;
          Post;
        end
        else
          if Locate('ShortCode', CreateShortCode(code), []) then
          begin
            if FieldByName('IDouble').Value <> 1 then
            Begin
              Edit;
              IDouble := 2 ;
              FieldByName('IDouble').Value := IDouble;
              Post;
            End;
          end
          else
            IDouble := 0;

        Append;
        FieldByName('Cat_id').Value      := i;
        FieldByName('Brand_id').Value    := bi;
        FieldByName('Group_id').Value    := gi;
        FieldByName('Subgroup_id').Value := si;
        FieldByName('Code').Value        := code;
        FieldByName('ShortCode').Value   := CreateShortCode(code);
        FieldByName('Code2').Value       := code2;
        FieldByName('Name').Value        := nam;
        FieldByName('Description').Value := descr;
        FieldByName('Price').AsCurrency  := price;
        FieldByName('T1').Value          := 1;
        FieldByName('T2').Value          := 1;
        FieldByName('Tecdoc_id').Value   := td_id;
        FieldByName('New').Value         := new_fl;
        FieldByName('Sale').Value        := sale_fl;
        FieldByName('Mult').Value        := mult;
        FieldByName('Usa').Value         := usa_fl;
        FieldByName('IDouble').Value     := IDouble;

        //[pict, typ, param]
        FieldByName('pict_id').AsInteger := pict_id;
        FieldByName('typ_tdid').AsInteger := typ_id;
        FieldByName('param_tdid').AsInteger := param_id;

        Post;
      end
      else
        WLog('Поз. уже содержиться в каталоге <' + code + ' / ' + br + '> в строке ' + IntToStr(i));
    end;

    with GroupBrandTable do
    begin
      if not FindKey([gi, si, bi]) then
      begin
        Append;
        FieldByname('Group_id').Value    := gi;
        FieldByname('Subgroup_id').Value := si;
        FieldByname('Brand_id').Value    := bi;
        Post;
      end;

    end;
    if i mod 100 = 0 then
    begin
      Main.CurrProgress(i);
      Main.ShowProgrInfo('speed: ' + sSpeed + ' rec/sec');
    end;
  end;

var
  t1, t2: Cardinal;
  i1: integer;
begin
  BrandTable.IndexName := 'Descr';
  BrandTable.Open;
  GroupTable.IndexName := 'GrDescr';
  GroupTable.Open;
  GroupBrandTable.EmptyTable;
  GroupBrandTable.IndexName := 'GrBrand';
  GroupBrandTable.Open;
  TDArtTable.Open;

  try
    with LoadCatTable do
    begin
      Close;
      EmptyTable;
      Exclusive := True;
      Open;
    end;

    i := 1;
    i1 := 1;
    td_cnt := 0;
    (*
    Reset(F);
    oldDs := DecimalSeparator;
    if not System.Eof(F) then
    begin
      Readln(F, s);
      s := ExtractDelimited(3, s, [';']);
      if Pos(',', s) > 0 then
        DecimalSeparator := ','
      else if Pos('.', s) > 0 then
        DecimalSeparator := '.'
      else
        DecimalSeparator := SysParamTable.FieldByName('Decimal_sep').AsString[1];
    end;
    *)
    Reset(F);
    t1 := GetTickCount;
    while not System.Eof(F) do
    begin
      Readln(F, s);
      br    := ExtractDelimited(1,  s, [';']);
      gr    := ExtractDelimited(6,  s, [';']);
      sgr   := ExtractDelimited(7,  s, [';']);
      code  := ExtractDelimited(2,  s, [';']);
      code2 := MakeSearchCode(code);
      nam   := ExtractDelimited(5,  s, [';']);
      descr := ExtractDelimited(8, s, [';']);
      price := Main.AToCurr(ExtractDelimited(3, s, [';']));
      sale_fl := ExtractDelimited(10, s, [';']);
      new_fl  := ExtractDelimited(11, s, [';']);
      mult    := StrInt(ExtractDelimited(12, s, [';']));
      usa_fl  := ExtractDelimited(13, s, [';']);
      AddToTable;
      Inc(i);
      //calc speed
      t2 := GetTickCount;
      if (t2 - t1) >= 1000 then
      begin
        sSpeed := IntToStr(i - i1);
        t1 := t2;
        i1 := i;
      end;
    end;
    ld_cnt := i - 1;
//    DecimalSeparator := oldDs;
    LoadTitles(i);
  finally
    LoadCatTable.Close;
    LoadCatTable.Exclusive := False;

    TDArtTable.Close;
    BrandTable.Close;
    GroupTable.Close;
    GroupBrandTable.Close;
  end;
end;

(*
procedure TData.LoadCatalog_opt(aUseInsert: Boolean);
var
  i: integer;
  s, gr, sgr, br, code, code2, nam, descr, rp: string;
  gi, si, bi: integer;
  price: Currency;
  oldDS: char;
  td_id: integer;
  new_fl, sale_fl, usa_fl: string;
  mult: integer;
  IDouble:integer;
  aQuery: TDBISamQuery;
  aTable: TDBISamTable;
  aCatMem: TDBISamTable;


  procedure prepareQuery;
  var
    aDef: TDBISAMFieldDef;
  begin
    aCatMem := TDBISamTable.Create(nil);
    aCatMem.DatabaseName := 'Memory';
    aCatMem.TableName := 'CATMEM';
    aCatMem.FieldDefs := LoadCatTable.FieldDefs;
    aCatMem.CreateTable;
    
    aCatMem.Open;
    aCatMem.Close;


    aQuery := TDBISamQuery.Create(nil);
    aQuery.DatabaseName := Database.DatabaseName;
    aQuery.SQL.Text :=
      'INSERT INTO /*[002]*/ "MEMORY\CATMEM" ( Cat_id,  Brand_id,  Group_id,  Subgroup_id,  Code,  ShortCode,  Code2,  Name,  Description,  Price,  T1,  T2,  Tecdoc_id,  New,  Sale,  Mult,  Usa,  IDouble,  pict_id,  typ_tdid,  param_tdid) ' +
      'VALUES            (:Cat_id, :Brand_id, :Group_id, :Subgroup_id, :Code, :ShortCode, :Code2, :Name, :Description, :Price, :T1, :T2, :Tecdoc_id, :New, :Sale, :Mult, :Usa, :IDouble, :pict_id, :typ_tdid, :param_tdid)';
    if aUseInsert then
      aQuery.Prepare;


    aTable := TDBISamTable.Create(nil);
    aTable.DatabaseName := 'Memory';
    aTable.TableName := 'BrandCache';
    aDef := aTable.FieldDefs.AddFieldDef;
    aDef.Name := 'Code2';
    aDef.DataType := ftString;
    aDef.Size := 50;
    aDef := aTable.FieldDefs.AddFieldDef;
    aDef.Name := 'Brand_id';
    aDef.DataType := ftInteger;
    aTable.CreateTable;
    aTable.AddIndex('Code2', 'Code2;Brand_id', [ixUnique]);
    aTable.IndexName := 'Code2';
    aTable.Open;
  end;

  procedure AddToTable;
  var
    pict_id, typ_id, param_id: Integer;
    bExists: Boolean;
  begin
    pict_id := 0;
    typ_id := 0;
    param_id := 0;

    BrandTable.FindKey([br]);
    bi := BrandTable.FieldByName('Brand_id').AsInteger;
    GroupTable.FindKey([gr, sgr]);
    gi := GroupTable.FieldByName('Group_id').AsInteger;
    si := GroupTable.FieldByName('Subgroup_id').AsInteger;
    if BrandReplTable.FindKey([br]) and
       (BrandReplTable.FieldByName('Repl_brand').AsString <> '') then
      rp := BrandReplTable.FieldByName('Repl_brand').AsString
    else
      rp := br;

    if TDArtTable.FindKey([code2, rp]) then //[pict]
    begin
      Inc(td_cnt);
      td_id := TDArtTable.FieldByName('Art_id').AsInteger;

      //[pict, typ, param] - привязка к tecdoc
      pict_id := TDArtTable.FieldByName('pict_id').AsInteger;
      typ_id := TDArtTable.FieldByName('typ_id').AsInteger;
      param_id := TDArtTable.FieldByName('param_id').AsInteger;
    end
    else
    begin
      WLog('Поз. не найдена в Tecdoc <' + code + ' / ' + br + '> в строке ' + IntToStr(i));
      td_id := 0;
    end;

    with LoadCatTable do
    begin
      bExists := False;      {
      try
        aTable.Append;
        aTable.FieldByName('Code2').AsString := Code2;
        aTable.FieldByName('Brand_id').AsInteger := bi;
        aTable.Post;
      except
        aTable.Delete;
        bExists := True;
      end;
                              }
      //if not FindKey([code2,bi]) then
      //if not aTable.FindKey([code2,bi]) then
      if not bExists then
      begin
        {if Locate('Code2', code2, []) then
        begin
          Edit;
          IDouble := 1;
          FieldByName('IDouble').Value := IDouble;
          Post;
        end
        else
          if Locate('ShortCode', CreateShortCode(code), []) then
          begin
            if FieldByName('IDouble').Value <> 1 then
            Begin
              Edit;
              IDouble := 2 ;
              FieldByName('IDouble').Value := IDouble;
              Post;
            End;
          end
          else
         }   IDouble := 0;

        if aUseInsert then
        begin
          aQuery.Params[0].AsInteger  := i;
          aQuery.Params[1].AsInteger  := bi;
          aQuery.Params[2].AsInteger  := gi;
          aQuery.Params[3].AsInteger  := si;
          aQuery.Params[4].AsString   := code;
          aQuery.Params[5].AsString   := CreateShortCode(code);
          aQuery.Params[6].AsString   := code2;
          aQuery.Params[7].AsString   := nam;
          aQuery.Params[8].AsString   := descr;
          aQuery.Params[9].AsCurrency := price;
          aQuery.Params[10].AsInteger  := 1;
          aQuery.Params[11].AsInteger  := 1;
          aQuery.Params[12].AsInteger  := td_id;
          aQuery.Params[13].AsString   := new_fl;
          aQuery.Params[14].AsString   := sale_fl;
          aQuery.Params[15].AsInteger  := mult;
          aQuery.Params[16].AsString   := usa_fl;
          aQuery.Params[17].AsInteger  := IDouble;
          aQuery.Params[18].AsInteger  := pict_id;
          aQuery.Params[19].AsInteger  := typ_id;
          aQuery.Params[20].AsInteger  := param_id;
          aQuery.ExecSQL;
        end
        else
        begin
          Append;
          FieldByName('Cat_id').Value      := i;
          FieldByName('Brand_id').Value    := bi;
          FieldByName('Group_id').Value    := gi;
          FieldByName('Subgroup_id').Value := si;
          FieldByName('Code').Value        := code;
          FieldByName('ShortCode').Value   := CreateShortCode(code);
          FieldByName('Code2').Value       := code2;
          FieldByName('Name').Value        := nam;
          FieldByName('Description').Value := descr;
          FieldByName('Price').Value       := price;
          FieldByName('T1').Value          := 1;
          FieldByName('T2').Value          := 1;
          FieldByName('Tecdoc_id').Value   := td_id;
          FieldByName('New').Value         := new_fl;
          FieldByName('Sale').Value        := sale_fl;
          FieldByName('Mult').Value        := mult;
          FieldByName('Usa').Value         := usa_fl;
          FieldByName('IDouble').Value     := IDouble;

          //[pict, typ, param]
          FieldByName('pict_id').AsInteger := pict_id;
          FieldByName('typ_tdid').AsInteger := typ_id;
          FieldByName('param_tdid').AsInteger := param_id;

          Post;

        end;
      end
      else
        WLog('Поз. уже содержиться в каталоге <' + code + ' / ' + br + '> в строке ' + IntToStr(i));
    end;
    
    with GroupBrandTable do
    begin
      if not FindKey([gi, si, bi]) then
      begin
        Append;
        FieldByname('Group_id').Value    := gi;
        FieldByname('Subgroup_id').Value := si;
        FieldByname('Brand_id').Value    := bi;
        Post;
      end;
    end;

    if i mod 100 = 0 then
      Main.CurrProgress(i);
  end;

var
  t: Cardinal;
begin
  BrandTable.IndexName := 'Descr';
  BrandTable.Open;
  GroupTable.IndexName := 'GrDescr';
  GroupTable.Open;
  GroupBrandTable.EmptyTable;
  GroupBrandTable.IndexName := 'GrBrand';
  GroupBrandTable.Open;
  TDArtTable.Open;
  //TDBrandTable.IndexName := 'Descr';
  //TDBrandTable.Open;
  with LoadCatTable do
  begin
    Close;
    EmptyTable;
   // Exclusive := not aUseInsert;
    Open;
  //*******************
  {
    Close;
    Exclusive := True;
    Open;
    DeleteAllIndexes;
    Close;
    Exclusive := False;
   // AddIndex('Code2', 'Code2;Brand_Id');
   // IndexName := 'Code2';
    OnCalcFields := nil;
    Open;
  }
  //*******************
  end;

  i := 1;
  td_cnt := 0;
  Reset(F);
  oldDs := DecimalSeparator;
  if not System.Eof(F) then
  begin
    Readln(F, s);
    s := ExtractDelimited(3, s, [';']);
    if Pos(',', s) > 0 then
      DecimalSeparator := ','
    else if Pos('.', s) > 0 then
      DecimalSeparator := '.'
    else
      DecimalSeparator := SysParamTable.FieldByName('Decimal_sep').AsString[1];
  end;

  prepareQuery;
  try
    Reset(F);
    t := GetTickCount;
    while not System.Eof(F) do
    begin
      Readln(F, s);
      br    := ExtractDelimited(1,  s, [';']);
      gr    := ExtractDelimited(6,  s, [';']);
      sgr   := ExtractDelimited(7,  s, [';']);
      code  := ExtractDelimited(2,  s, [';']);
      code2 := MakeSearchCode(code);
      nam   := ExtractDelimited(5,  s, [';']);
      descr := ExtractDelimited(8, s, [';']);
      price := StrToCurr(ExtractDelimited(3, s, [';']));
      sale_fl := ExtractDelimited(10, s, [';']);
      new_fl  := ExtractDelimited(11, s, [';']);
      mult    := StrInt(ExtractDelimited(12, s, [';']));
      usa_fl  := ExtractDelimited(13, s, [';']);
      AddToTable;
      Inc(i);


      if (i mod 3000 = 0) or (System.Eof(F)) then
      begin
        aQuery.UnPrepare;
        Database.Execute('Insert INTO [002] SELECT * FROM "MEMORY\CATMEM"');
        Database.Execute('EMPTY TABLE "MEMORY\CATMEM"');
        aQuery.Prepare;
      end;

      
    end;

    if aUseInsert then
      ShowMessage('Insert: ' + IntToStr(GetTickCount - t))
    else
      ShowMessage('Append_opt: ' + IntToStr(GetTickCount - t));
  finally
    aQuery.UnPrepare;
    aQuery.Free;

    aTable.Close;
    aTable.DeleteTable;
    aTable.Free;

    aCatMem.Close;
    aCatMem.DeleteTable;
    aCatMem.Free;
  end;
  ld_cnt := i - 1;
  DecimalSeparator := oldDs;
  LoadTitles(i);
  TDArtTable.Close;
  //TDBrandTable.Close;
  //TDBrandTable.IndexName := '';
  LoadCatTable.Close;
  LoadCatTable.Exclusive := False;
  //*****************
  //LoadCatTable.OnCalcFields := LoadCatTableCalcFields;
  //*****************

  BrandTable.Close;
  GroupTable.Close;
  GroupBrandTable.Close;
end;
*)

function TData.MakeSearchCode(s: string): string;
var
  i: integer;
begin
  for i := 1 to Length(Ign_chars) do
    s := AnsiReplaceStr(s, Copy(Ign_chars, i, 1), '');
  Result := AnsiUpperCase(s);
end;

function TData.DecodeCodeBrand(const aCode_Brand: string; var aCode,
  aBrand: string; aMakeSearchCode: Boolean): Boolean;
var
  aPos: Integer;
begin
  aPos := Pos('_', aCode_Brand);
  if aPos > 0 then
  begin
    aCode := Copy(aCode_Brand, 1,  aPos - 1);
    aBrand := Copy(aCode_Brand, aPos + 1, MaxInt);
    if aMakeSearchCode then
      aCode := Data.MakeSearchCode(aCode);
  end
  else
  begin
    aCode := '';
    aBrand := '';
  end;

  Result := (aCode <> '') and (aBrand <> '');
end;


procedure TData.ModelsTableCalcFields(DataSet: TDataSet);
var
  s: string;
begin
  with DataSet do
  begin
    s := '';
    if FieldByName('Pcon_start').AsInteger <> 0 then
    begin
      s := Copy(FieldByName('Pcon_start').AsString, 1, 4) + '/' +
           Copy(FieldByName('Pcon_start').AsString, 5, 2);
    end;
    if s <> '' then
      FieldByName('PconText1').Value := s;
    s := '';
    if (FieldByName('Pcon_end').AsInteger <> 0) and
       (FieldByName('Pcon_end').AsInteger <> FieldByName('Pcon_start').AsInteger)then
    begin
      s := Copy(FieldByName('Pcon_end').AsString, 1, 4) + '/' +
           Copy(FieldByName('Pcon_end').AsString, 5, 2);
    end;
    if s <> '' then
      FieldByName('PconText2').Value := s;
  end
end;

procedure TData.NetTimerTimer(Sender: TObject);
begin
///------------ check lock
  OrderTable.Refresh;
  OrderDetTable.Refresh;
  WaitListTable.Refresh;
  AssortmentExpansion.Refresh;
  if CatalogDataSource.DataSet.Active then
    CatalogDataSource.DataSet.Refresh;
end;

procedure TData.LoadTitles(st: integer);
var
  i, gr, sgr, br: integer;
begin
  i := st;
  BrandTable.IndexName := 'BrandId';
  with GroupTable do
  begin
    IndexName := 'GrId';
    First;
    while not Eof do
    begin
      gr := FieldByName('Group_id').AsInteger;
      with LoadCatTable do
      begin
        Append;
        FieldByName('Cat_id').Value := i;
        FieldByName('Group_id').Value := gr;
        FieldByName('Subgroup_id').Value := 0;
        FieldByName('Brand_id').Value := 0;
        FieldByName('Description').Value :=
           GroupTable.FieldByName('Group_descr').AsString;
        FieldByName('T1').Value := 1;
        FieldByName('T2').Value := 0;
        FieldByName('Title').Value := True;
        Post;
      end;
      Inc(i);
      while (not Eof) and (FieldByName('Group_id').AsInteger = gr) do
      begin
        sgr := FieldByName('Subgroup_id').AsInteger;
        with LoadCatTable do
        begin
          Append;
          FieldByName('Cat_id').Value := i;
          FieldByName('Group_id').Value := gr;
          FieldByName('Subgroup_id').Value := sgr;
          FieldByName('Brand_id').Value := 0;
          FieldByName('Description').Value :=
             GroupTable.FieldByname('Subgroup_descr').AsString;
          FieldByName('T1').Value := 1;
          FieldByName('T2').Value := 0;
          FieldByName('Title').Value := True;
          Post;
        end;
        Inc(i);
        with GroupBrandTable do
        begin
          SetRange([gr, sgr], [gr, sgr]);
          First;
          while not Eof do
          begin
            with LoadCatTable do
            begin
              Append;
              FieldByName('Cat_id').Value := i;
              FieldByName('Group_id').Value := gr;
              FieldByName('Subgroup_id').Value := sgr;
              br := GroupBrandTable.FieldByName('Brand_id').AsInteger;
              FieldByName('Brand_id').Value := br;
              BrandTable.FindKey([br]);
              FieldByName('Description').Value :=
                 BrandTable.FieldByName('Description').AsString;
              FieldByName('T1').Value := 1;
              FieldByName('T2').Value := 0;
              FieldByName('Title').Value := True;
              Post;
            end;
            Inc(i);
            Next;
          end;
        end;
        Next;
      end;
    end;
  end;
  GroupBrandTable.IndexName := 'BrGroup';
  with BrandTable do
  begin
    First;
    while not Eof do
    begin
      br := FieldByName('Brand_id').AsInteger;
      with LoadCatTable do
      begin
        Append;
        FieldByName('Cat_id').Value      := i;
        FieldByName('Group_id').Value    := 0;
        FieldByName('Subgroup_id').Value := 0;
        FieldByName('Brand_id').Value    := br;
        FieldByName('Description').Value :=
             BrandTable.FieldByname('Description').AsString;
        FieldByName('T1').Value := 0;
        FieldByName('T2').Value := 1;
        FieldByName('Title').Value := True;
        Post;
      end;
      Inc(i);
      with GroupBrandTable do
      begin
        SetRange([br], [br]);
        First;
        while not Eof do
        begin
          gr  := FieldByName('Group_id').AsInteger;
          while (not Eof) and (FieldByName('Group_id').AsInteger = gr) do
          begin
            sgr := FieldByName('Subgroup_id').AsInteger;
            with LoadCatTable do
            begin
              Append;
              FieldByName('Cat_id').Value   := i;
              FieldByName('Brand_id').Value := br;
              FieldByName('Group_id').Value := gr;
              FieldByName('Subgroup_id').Value := sgr;
              GroupTable.FindKey([gr, sgr]);
              FieldByName('Description').Value :=
                 GroupTable.FieldByName('Subgroup_descr').AsString;
              FieldByName('T1').Value := 0;
              FieldByName('T2').Value := 1;
              FieldByName('Title').Value := True;
              Post;
            end;
            Inc(i);
            Next;
          end;
        end;
      end;
      Next;
    end;
  end;
end;


procedure TData.LoadAnFromExcell(fname: string='');
begin
  if fname = '' then
  begin
    if not OpenDialog.Execute then
      exit;
    fname := OpenDialog.FileName;
  end;
  StartWait;
  StartLog('LoadAnalogs.log');
  CatalogTable.AfterScroll := nil;
  Main.LoadTDInfoTimer.Enabled := False;
  AnalogTable.Close;
  AnSearchTable.Close;
  AssignFile(F, fname);
  Main.ShowProgress('Заполнение базы аналогов...', CalcLineCnt);
  LoadAnalogs;
  CloseFile(F);
  AnalogTable.Open;
  AnSearchTable.Open;
  SetCatFilter;
  CatalogDataSource.DataSet.AfterScroll := Data.CatalogTableAfterScroll;
  Main.HideProgress;
  StopLog;
  StopWait;
  LoadAnMemo;
end;


procedure TData.LoadAnalogs;
var
  i: integer;
  s, cat_br_str, an_br_str, cat_code, an_code: string;
  cat_br_id, an_br_id, cat_id, an_id: integer;
  fname, br: string;
  FBrandFile:TextFile;

  procedure AddToTable;
  begin
    with BrandTable do
    begin
      if FindKey([Cat_br_str]) then
        cat_br_id := FieldByName('Brand_id').AsInteger
      else
      begin
        WLog('Бренд не распознан <' + Cat_br_str + '> в строке ' + IntToStr(i));
        cat_br_id := 0;
      end;
      if FindKey([An_br_str]) then
        an_br_id := FieldByName('Brand_id').AsInteger
      else
      begin
        WLog('Бренд не распознан <' + Cat_br_str + '> в строке ' + IntToStr(i));
        an_br_id := 0;
      end;
    end;
    with LoadCatTable do
    begin
      if FindKey([MakeSearchCode(cat_code), cat_br_id]) then
        cat_id := FieldByName('Cat_id').AsInteger
      else
      begin
        WLog('Базовая позиция не идентифицирована <' +
              Cat_code + ' / ' + Cat_br_str + '> в строке ' + IntToStr(i));
        cat_id := 0;
      end;
      if FindKey([MakeSearchCode(an_code), an_br_id]) then
        an_id := FieldByName('Cat_id').AsInteger
      else
      begin
        WLog('Позиция аналога не идентифицирована <' +
              Cat_code + ' / ' + Cat_br_str + '> в строке ' + IntToStr(i));
        an_id := 0;
      end;
    end;
    with LoadAnTable do
    begin
      if cat_id = 0 then
      begin
        if (an_id <> 0) and (not FindKey([an_id, cat_code])) then
        begin
          Append;
          FieldByName('Cat_id').Value   := an_id;
          FieldByName('An_Code').Value  := cat_code;
          FieldByName('An_ShortCode').Value  := CreateShortCode(cat_code);
          FieldByName('An_id').Value    := 0;
          if  LockBrand.FindKey([Cat_br_str]) then
              begin
                FieldByName('An_Brand').Value := '';
               FieldByName('Locked').Value    := 1;
              end
            else
              begin
               FieldByName('An_Brand').Value := cat_br_str;
               FieldByName('Locked').Value    := 0;
              end;


          Post;
        end
        else if an_id <> 0 then
          WLog('Повтор позиции <' +
                Cat_code + ' / ' + Cat_br_str + '> в строке ' + IntToStr(i));
      end
      else
      begin
        if not FindKey([cat_id, an_code]) then
        begin
          Append;
          FieldByName('Cat_id').Value   := cat_id;
          FieldByName('An_Code').Value  := an_code;
          FieldByName('An_ShortCode').Value  := CreateShortCode(an_code);
          FieldByName('An_Brand').Value := an_br_str;
          FieldByName('An_id').Value    := an_id;
          if LockBrand.FindKey([Cat_br_str]) then
              begin
                FieldByName('An_Brand').Value := '';
                FieldByName('Locked').Value    := 1;
              end
            else
             begin
               FieldByName('An_Brand').Value := an_br_str;
               FieldByName('Locked').Value    := 0;
             end;
         Post;
        end
        else
          WLog('Повтор аналога <' +
                An_code + ' / ' + An_br_str + '> в строке ' + IntToStr(i));

      end;
    end;
    if i mod 1000 = 0 then
      Main.CurrProgress(i);
  end;

begin
  TestTable(LockBrand);
  LockBrand.Open;
  fname := GetAppDir + 'LockedBrand.txt';
  if not FileExists(fname) then
    exit;
  AssignFile(FBrandFile, fname);
  Reset(FBrandFile);
  while not System.Eof(FBrandFile) do
  begin
    Readln(FBrandFile, s);
    br := ExtractDelimited(1,  s, [';']);
    with LockBrand do
    begin
      Append;
      FieldByName('Brand').Value := br;
      Post;
    end;
  end;
  CloseFile(FBrandFile);
  LockBrand.IndexName := 'Brand';
  BrandTable.IndexName := 'Descr';
  LoadCatTable.Open;
  LoadCatTable.IndexName := 'Code2';
  with LoadAnTable do
  begin
    EmptyTable;
    Open;
  end;
  i := 1;
  Reset(F);
  while not System.Eof(F) do
  begin
    Readln(F, s);
    cat_br_str := ExtractDelimited(1,  s, [';']);
    cat_code   := ExtractDelimited(2,  s, [';']);
    an_br_str  := ExtractDelimited(3,  s, [';']);
    an_code    := ExtractDelimited(4,  s, [';']);
    AddToTable;
    Inc(i);
  end;
  LoadAnTable.Close;
  LoadCatTable.IndexName := '';
  LoadCatTable.Close;
  BrandTable.IndexName := 'BrandId';
  LockBrand.Close;
  LockBrand.Free;
end;



procedure TData.LoadQuantFromExcell(fname: string='');
var
  old_br_ind: string;
  Stream:TStringStream;
  MemoFile:TStringList;
  s, cb, cat_code, cat_brand, quant, price, sNew: string;
  iStr:integer;
  sBr:string;
  sCo:string;
  sMessage:string;
begin
 { if fname = '' then
    if OpenDialog.Execute then
      fname := OpenDialog.FileName
    else
      Exit;

   TestTable(UpdateQuant, data_psw);
   Main.UnZipper.ZipName  := fname;
   Main.UnZipper.Password := UPD_PWD;
   Main.UnZipper.ReadZip;
   Stream := TStringStream.Create('');
   if Main.UnZipper.UnZipToStream(Stream,'qnt.csv') < 1 then
      begin
        Stream.Free;
        exit;
      end;
   MemoFile := TStringList.Create;
   Stream.Position := 0;
   MemoFile.LoadFromStream(Stream);
   Stream.Free;

   with UpdateQuant do
   begin
     EmptyTable;
     IndexName := '';
     Open;
     iStr := 1;
     Main.ShowProgress('Загрузка файла остатков...', MemoFile.Count);
     for iStr := 0 to MemoFile.Count - 1 do
     begin
      cb := ExtractDelimited(1,  MemoFile[iStr], [';']);
      DecodeCodeBrand(cb, cat_code, cat_brand);
      quant     := ExtractDelimited(2,  MemoFile[iStr], [';']);
      price     := ExtractDelimited(3,  MemoFile[iStr], [';']);
      sNew:= ExtractDelimited(4,  MemoFile[iStr], [';']);
      Append;
        FieldByName('sCode').AsString := cat_code;
        FieldByName('sBrand').AsString := cat_brand;
        FieldByName('Quants').AsString := quant;
        FieldByName('PRICE').AsString := price;
        FieldByName('SALE').AsString := sNew;
      Post;

      if iStr mod 1000 = 0 then
        begin
            Main.CurrProgress(iStr);
        end;

     end;
      Main.HideProgress;
     MemoFile.Free;






     IndexName := 'Code';




     QuantTable.Close;
     QuantTable.EmptyTable;
     QuantTable.Open;

     LoadCatTable.IndexName := 'Code2';
     LoadCatTable.Open;

     Main.ShowProgress('Загрузка цен и наличия...', LoadCatTable.RecordCount);
     first;
     while not LoadCatTable.EOF do
     begin
      if FieldByName('sCode').AsString = '5505XS' then
      begin
         sMessage := 'sdfsd';
      end;

      if LoadCatTable.FieldByName('Code2').AsString = FieldByName('sCode').AsString then
        begin
           while LoadCatTable.FieldByName('sBrand').AsString > UpdateQuant.FieldByName('sBrand').AsString do
           begin
              sCo:=FieldByName('sCode').AsString;
              sBr:=FieldByName('sBrand').AsString;

              UpdateQuant.Next;
              if UpdateQuant.Eof then
                break;
              if LoadCatTable.FieldByName('Code2').AsString <> FieldByName('sCode').AsString then
                break;
           end;
           if LoadCatTable.FieldByName('Code2').AsString = FieldByName('sCode').AsString then 
           if LoadCatTable.FieldByName('sBrand').AsString = FieldByName('sBrand').AsString then
           begin
               QuantTable.Append;
               QuantTable.FieldByName('Cat_id').Value   := LoadCatTable.FieldByName('Cat_id').AsInteger;
               QuantTable.FieldByName('Quantity').Value := FieldByName('Quants').AsString;
               QuantTable.FieldByName('Price').Value := Main.AToCurr(FieldByName('PRICE').AsString);
               if FieldByName('SALE').AsString = '1' then
                   QuantTable.FieldByName('Sale').AsString := '1'
               else
                   QuantTable.FieldByName('Sale').AsString := '0';
               QuantTable.Post;
               if Trim(FieldByName('PRICE').AsString) <> '' then
               begin
                   LoadCatTable.Edit;
                   LoadCatTable.FieldByName('Price').Value := Main.AToCurr(FieldByName('PRICE').AsString);
                   if FieldByName('SALE').AsString = '1' then
                      LoadCatTable.FieldByName('Sale').AsString := '1'
                   else
                      LoadCatTable.FieldByName('Sale').AsString := '0';
                   LoadCatTable.Post;
               end;
               Next;
               if EOF then
                Break;
          end
        end
      else
         if LoadCatTable.FieldByName('Code2').AsString > FieldByName('sCode').AsString then
         begin
            Next;
               if EOF then
                Break;
         end;
        if LoadCatTable.RecNo mod 1000 = 0 then
          Main.CurrProgress(LoadCatTable.RecNo);
      LoadCatTable.Next;
     end;
     LoadCatTable.Close;
     UpdateQuant.Close;
     UpdateQuant.EmptyTable;
     Main.HideProgress;
   end;

        }


 if fname = '' then
  begin
    if not OpenDialog.Execute then
      exit;
    fname := OpenDialog.FileName;
  end;
  StartWait;
  StartLog('LoadQuant.log');
//  AllClose;
  with LoadCatTable do
  begin
    IndexName := 'Code2';
    Open;
  end;
  with QuantTable do
  begin
    Close;
    EmptyTable;
    Open;
  end;
  old_br_ind := BrandTable.IndexName;
  BrandTable.IndexName := 'Descr';

  AssignFile(F, fname);
  Main.ShowProgress('Загрузка цен и наличия...', CalcLineCnt);
  LoadQuants;
  CloseFile(F);
  //AllOpen;
  LoadCatTable.Close;
  BrandTable.IndexName := old_br_ind;
  CatalogTable.Refresh;
  AnalogTable.Refresh;
  Main.HideProgress;
  StopLog;
  StopWait;
     //       }
end;


procedure TData.LoadQuants;
var
  i, brand_id: integer;
  s, cb, cat_code, cat_brand, quant, price, sNew: string;
  oldDS: char;

  procedure AddToTable;
  begin
    with BrandTable do
    begin
      if FindKey([Cat_brand]) then
        brand_id := FieldByName('Brand_id').AsInteger
      else
      begin
        WLog('Бренд не распознан <' + Cat_brand + '> в строке ' + IntToStr(i));
        brand_id := 0;
      end;
    end;
    with QuantTable do
    begin
      if (cat_code <> '') and
         LoadCatTable.FindKey([cat_code, brand_id]) then
      begin
        Append;
        FieldByName('Cat_id').Value   := LoadCatTable.FieldByName('Cat_id').AsInteger;
        FieldByName('Quantity').Value := quant;
        Post;
        if Trim(price) <> '' then
        begin
          with LoadCatTable do
          begin
            Edit;
            FieldByName('Price').Value := Main.AToCurr(price);
            if sNew = '1' then
               FieldByName('Sale').Value := 1
            else
               FieldByName('Sale').Value := 0;
            Post;
          end;
        end;

      end
      else
        WLog('Поз. не найдена <' + Cat_code + ' / ' + Cat_brand + '> остаток '+quant+' в строке ' + IntToStr(i));
    end;
    if i mod 1000 = 0 then
      Main.CurrProgress(i);
  end;

begin
  i := 1;
  Reset(F);
  oldDs := DecimalSeparator;
  if not System.Eof(F) then
  begin
    Readln(F, s);
    s := ExtractDelimited(3, s, [';']);
    if Pos(',', s) > 0 then
      DecimalSeparator := ','
    else if Pos('.', s) > 0 then
      DecimalSeparator := '.'
    else
      DecimalSeparator := SysParamTable.FieldByName('Decimal_sep').AsString[1];
  end;
  Reset(F);
  while not System.Eof(F) do
  begin
    Readln(F, s);
    cb := ExtractDelimited(1,  s, [';']);
    DecodeCodeBrand(cb, cat_code, cat_brand);
    quant     := ExtractDelimited(2,  s, [';']);
    price     := ExtractDelimited(3,  s, [';']);
    sNew:= ExtractDelimited(4,  s, [';']);
 //   MessageDlg(cat_code+' '+cat_brand+' '+quant+' '+price+' '+sNew,mtInformation,[mbOk],0);
 //   exit;
    AddToTable;
    Inc(i);
  end;
  DecimalSeparator := oldDs;
end;


procedure TData.LoadOENumbersFromExcell(fname: string='');
var
  old_br_ind: string;
begin
  if fname = '' then
  begin
    if not OpenDialog.Execute then
      exit;
    fname := OpenDialog.FileName;
  end;
  StartWait;
  StartLog('LoadOE.log');
  //AllClose;
  OESearchTable.Close;
  with LoadCatTable do
  begin
    IndexName := 'Code2';
    Open;
  end;
  with OETable do
  begin
    Close;
    EmptyTable;
    Open;
  end;
  old_br_ind := BrandTable.IndexName;
  BrandTable.IndexName := 'Descr';
  AssignFile(F, fname);
  Main.ShowProgress('Заполнение базы OE-номеров...', CalcLineCnt);
  LoadOENumbers;
  CloseFile(F);
  //AllOpen;
  OESearchTable.Open;
  LoadCatTable.Close;
  BrandTable.IndexName := old_br_ind;
  CatalogTable.Refresh;
  AnalogTable.Refresh;
  Main.HideProgress;
  StopLog;
  StopWait;
  LoadOEMemo;
end;


procedure TData.LoadOENumbers;
var
  i, brand_id: integer;
  s, cb, cat_code, cat_brand, oe_code: string;
  sValue:string;
  iIDStart, iIDEnd:integer;
  procedure AddToTableMemory;
  begin
     try
        with BrandTable do
          begin
            if FindKey([Cat_brand]) then
              brand_id := FieldByName('Brand_id').AsInteger
            else
            begin
              WLog('Бренд не распознан <' + Cat_brand + '> в строке ' + IntToStr(i));
              brand_id := 0;
            end;
          end;

        with LoadOE do
          begin
            if (cat_code <> '') and
               LoadCatTable.FindKey([cat_code, brand_id]) then
              begin
              Append;
              FieldByName('Cat_id').Value   := LoadCatTable.FieldByName('Cat_id').AsInteger;
              FieldByName('Code').Value     := AnsiUpperCase(oe_code);
              FieldByName('Code2').Value    := MakesearchCode(AnsiUpperCase(oe_code));
              FieldByName('ShortOE').Value  := CreateShortCode(oe_code);
              Post;
              end
            else
              WLog('Поз. не найдена <' + Cat_code + ' / ' + Cat_brand + '> в строке ' + IntToStr(i));
          end;
        if i mod 1000 = 0 then
          Main.CurrProgress(i);
      except
         On E:Exception do
          MessageDlg(E.Message, mtInformation, [mbOK],0);
      end;
  end;


  procedure AddToTable;
  begin
  try
      while not LoadOE.Eof do
        begin
          if LoadOE.FieldByName('ShortOE').AsString <> ''  then
            begin
             OETable.Append;
             OETable.FieldByName('Cat_id').Value   := LoadOE.FieldByName('Cat_id').Value;
             OETable.FieldByName('Code').Value     := LoadOE.FieldByName('Code').Value;
             OETable.FieldByName('Code2').Value    := LoadOE.FieldByName('Code2').Value;
             OETable.FieldByName('ShortOE').Value    := LoadOE.FieldByName('ShortOE').Value;
             if LoadOE.FieldByName('ShortOE').AsString <> '' then
               OETable.FieldByName('SIMB').AsInteger := Ord( LoadOE.FieldByName('ShortOE').AsString[1] )
             else
               OETable.FieldByName('SIMB').AsInteger := Ord('?');
             OETable.Post;
            end;
        Inc(i);
        if i mod 1000 = 0 then
        Main.CurrProgress(i);
           LoadOE.Next;
        end;
  except
     On E:Exception do
      MessageDlg(E.Message, mtInformation, [mbOK],0);
  end;
  end;

begin
  i := 1;
  Reset(F);
  TestTable(LoadOE);
  LoadOE.EmptyTable;
  LoadOE.IndexName := '';
  LoadOE.Open;
  while not System.Eof(F) do
  begin
    Readln(F, s);
    cb := ExtractDelimited(1,  s, [';']);
    DecodeCodeBrand(cb, cat_code, cat_brand);
    oe_code   := ExtractDelimited(2,  s, [';']);
    AddToTableMemory;
    Inc(i);
  end;
  LoadOE.IndexName := 'Code2';
  LoadOE.First;
  Main.HideProgress;
  Main.ShowProgress('Загружаем ОЕ...', LoadOE.RecordCount);
  i:=0;
  sValue := ' ';
  iIDStart := 0;
  iIDEnd := 0;
  AddToTable;
  LoadOE.Close;
  LoadOE.EmptyTable;

{
  with OETable do
    begin
    MasterFields := '';
    MasterSource := Nil;
    OEMap.Close;
    OEMap.EmptyTable;
    OEMap.Open;
    IndexName := 'ShortOE';
    First;
    while not OETable.Eof do
    begin
      oe_code := FieldByName('ShortOE').AsString;
      if sValue[1] <> oe_code[1] then
      begin
        if sValue[1] <> ' ' then
        begin
          OEMap.Append;
          OEMap.FieldByName('SIM').Value     := sValue[1];
          OEMap.FieldByName('StartID').Value := iIDStart;
          OEMap.FieldByName('EndID').Value := iIDEnd;
          OEMap.Post;
        end;
        sValue[1] := oe_code[1];
        iIDStart :=  OETable.FieldByName('ID').AsInteger;
      end;
      iIDEnd :=  OETable.FieldByName('ID').AsInteger;
      Next;
    end;
    IndexName := 'Cat_id';
    MasterFields := 'Cat_id';
    MasterSource := CatalogDataSource;
  end;

  if iIDEnd > 0 then
  begin
    OEMap.Append;
    OEMap.FieldByName('SIM').Value     := sValue[1];
    OEMap.FieldByName('StartID').Value := iIDStart;
    OEMap.FieldByName('EndID').Value := iIDEnd;
    OEMap.Post;
  end;
}

end;

procedure TData.LoadTree;
var
  gr, sgr, br: integer;
  root, gr_node, sgr_node, br_node, aNode: TTreeNode;
  gr_chk: boolean;
  gr_descr, sgr_descr: string;
  bAddSub_Group,bAddGroup:boolean;
  sFilter, sOldIndexName:string;
begin
//  MessageDlg(BrandTable.IndexName,mtInformation,[MBOK],0);
try
  //CatFilterTable
 (* if (Main.UsaCheckBox.Checked) or (Main.NewCheckBox.Checked) then
  begin
    if Tree_mode in [0, 2] then
    begin
      if (CatalogDataSource.DataSet as TDBISAMTABLE).IndexName <> 'GrCode' then
      begin
        if (CatalogDataSource.DataSet as TDBISAMTABLE).IndexDefs.Find('GrCode') = nil then
          (CatalogDataSource.DataSet as TDBISAMTABLE).AddIndex('GrCode','T1;Group_id;Subgroup_id;Brand_id;Code');
        (CatalogDataSource.DataSet as TDBISAMTABLE).IndexName := 'GrCode'
      end;
    end
    else
    begin
      if (CatalogDataSource.DataSet as TDBISAMTABLE).IndexName <> 'BrCode' then
      begin
        (CatalogDataSource.DataSet as TDBISAMTABLE).IndexName := 'BrCode';
      end;
    end;


     QueryFilter.Close;
     QueryFilter.SQL.Clear;
     if CatFilterTable.Active then
       QueryFilter.SQL.Add('SELECT DISTINCT Group_id,Subgroup_id,Brand_id FROM "MEMORY\CatFilterTable" WHERE')
     else
       QueryFilter.SQL.Add('SELECT DISTINCT Group_id,Subgroup_id,Brand_id FROM [002] WHERE');
     sFilter := '';
     //sFilter
     if Main.UsaCheckBox.Checked then
       sFilter := ' USA = ''1''';
     if Main.NewCheckBox.Checked then
       if Length(sFilter) < 1 then
         sFilter :=sFilter+ ' New = ''1'''
       else
         sFilter :=sFilter+ ' AND New = ''1''';

     QueryFilter.SQL.Add(sFilter);

     if (Tree_mode = 0)or(Tree_mode = 2) then
       QueryFilter.SQL.Add(' ORDER BY Group_id,Subgroup_id,Brand_id')
     else
       QueryFilter.SQL.Add(' ORDER BY Brand_id,Group_id,Subgroup_id');
     QueryFilter.Open;
     (CatalogDataSource.DataSet as TDBISAMTABLE).SetRange([1], [1]);
     (CatalogDataSource.DataSet as TDBISAMTABLE).First;
     SetCatFilter;
     Application.ProcessMessages;
     if Tree_mode = 0 then
     begin
        gr_node:=nil;
        GroupBrandTable.Open;
        Group := 0;
        Subgroup := 0;
        fBrand := 0;
        Main.Tree.OnChange := nil;
        Main.Tree.Items.Clear;

        Main.Tree.Visible := True;
        root := Main.Tree.Items.AddObject(nil, 'Весь ассортимент', Pointer(0));
        sOldIndexName := GroupTable.IndexName;
        if GroupTable.IndexName <> 'GrId' then
            GroupTable.IndexName := 'GrId';
        gr := 0;
        sgr := 0;
        while not QueryFilter.EOF do
        begin
          if gr <> QueryFilter.FieldByName('Group_id').AsInteger then
          begin
             sgr := 0;
             gr := QueryFilter.FieldByName('Group_id').AsInteger;
             if GroupTable.FindKey([gr]) then
             begin
                gr_node := Main.Tree.Items.AddChildObject(root,
                GroupTable.FieldByName('Group_descr').AsString, Pointer(gr));
             end
             else
             begin
               QueryFilter.Next;
               Continue;
             end;
          end;

          if sgr <> QueryFilter.FieldByName('Subgroup_id').AsInteger then
           begin
             sgr := QueryFilter.FieldByName('Subgroup_id').AsInteger;
             if GroupTable.FindKey([gr,sgr]) then
             begin
                  sgr_node := Main.Tree.Items.AddChildObject(gr_node,
                  GroupTable.FieldByName('subgroup_descr').AsString, Pointer(sgr));
             end
             else
             begin
               QueryFilter.Next;
               Continue;
             end;
          end;

          br := QueryFilter.FieldByName('Brand_id').AsInteger;
          BrandTable.FindKey([br]);
          aNode :=  Main.Tree.Items.AddChildObject(sgr_node,
          ReBranding(BrandTable.FieldByName('Description').AsString), {ReBranding}
          Pointer(br));
          QueryFilter.Next;
        end;
      Main.Tree.AlphaSort(TRUE);
      Main.Tree.OnChange := Main.TreeChange;
      root.Expand(False);
      root.Selected := True;
     end;

     if Tree_mode = 1 then
     begin
        GroupBrandTable.Open;
        Group := 0;
        Subgroup := 0;
        fBrand := 0;
        Main.Tree.OnChange := nil;
        Main.Tree.Items.Clear;

        Main.Tree.Visible := True;
        root := Main.Tree.Items.AddObject(nil, 'Все бренды', Pointer(0));
        sOldIndexName := GroupTable.IndexName;
        if GroupTable.IndexName <> 'GrId' then
            GroupTable.IndexName := 'GrId';
        br := 0;
        while not QueryFilter.EOF do
        begin
          if br <> QueryFilter.FieldByName('Brand_id').AsInteger then
          begin
             gr := 0;
             br := QueryFilter.FieldByName('Brand_id').AsInteger;
             if BrandTable.FindKey([br]) then
             begin
                gr_node := Main.Tree.Items.AddChildObject(root,
                ReBranding(BrandTable.FieldByName('Description').AsString), Pointer(br)); {ReBranding}
             end
             else
             begin
               QueryFilter.Next;
               Continue;
             end;
          end;

          if gr <> QueryFilter.FieldByName('Group_id').AsInteger then
          begin
             sgr := 0;
             gr := QueryFilter.FieldByName('Group_id').AsInteger;
             if not GroupTable.FindKey([gr]) then
             begin
               QueryFilter.Next;
               Continue;
             end;
          end;

          if sgr <> QueryFilter.FieldByName('Subgroup_id').AsInteger then
           begin
             sgr := QueryFilter.FieldByName('Subgroup_id').AsInteger;
             if GroupTable.FindKey([gr,sgr]) then
             begin
                  sgr_node := Main.Tree.Items.AddChildObject(gr_node,
                  GroupTable.FieldByName('subgroup_descr').AsString, Pointer(gr * 1000 + sgr));
             end
             else
             begin
               QueryFilter.Next;
               Continue;
             end;
          end;
          
          QueryFilter.Next;
        end;
      Main.Tree.AlphaSort(TRUE);
      Main.Tree.OnChange := Main.TreeChange;
      root.Expand(False);
      root.Selected := True;
     end;

     if Tree_mode = 2 then
     begin
        gr_node:=nil;
        GroupBrandTable.Open;
        Group := 0;
        Subgroup := 0;
        fBrand := 0;
        Main.Tree.OnChange := nil;
        Main.Tree.Items.Clear;
        Main.Tree.Visible := True;
        with MyGroupTable do
          begin
            IndexName := 'GrDescr';
            Open;
          end;
        if GroupBrandTable.IndexName <> 'GrBrand' then
            GroupBrandTable.IndexName := 'GrBrand';
        with GroupTable do
          begin
            First;
            while not Eof do
            begin
              gr := FieldByName('Group_id').AsInteger;
              gr_descr := AnsiUpperCase(FieldByName('Group_descr').AsString);
              gr_chk := MyGroupTable.FindKey([gr_descr, '']);
              if gr_chk then
              begin
                if not QueryFilter.Locate('Group_id',gr,[]) then
                    begin
                      Next;
                      Continue;
                    end;
                gr_node := Main.Tree.Items.AddObject(nil, FieldByName('Group_descr').AsString, Pointer(gr));
              end
              else
                if not QueryFilter.Locate('Group_id',gr,[]) then
                    begin
                      Next;
                      Continue;
                    end;

              while (not Eof) and (FieldByName('Group_id').AsInteger = gr) do
                begin
                  sgr := FieldByName('Subgroup_id').AsInteger;
                  sgr_descr := AnsiUpperCase(FieldByName('Subgroup_descr').AsString);
                  if gr_chk and MyGroupTable.FindKey([gr_descr, sgr_descr]) then
                    begin
                    if not QueryFilter.Locate('Group_id;Subgroup_id',VarArrayOf([gr,sgr]),[]) then
                    begin
                      Next;
                      Continue;
                    end;
                      sgr_node := Main.Tree.Items.AddChildObject(gr_node, FieldByName('subgroup_descr').AsString, Pointer(sgr));

                   with GroupBrandTable do
                    begin
                      SetRange([gr, sgr], [gr, sgr]);
                      First;
                      while not Eof do
                      begin
                        br := FieldByName('Brand_id').AsInteger;
                        if not QueryFilter.Locate('Group_id;Subgroup_id;Brand_id',VarArrayOf([gr,sgr,br]),[]) then
                          begin
                            Next;
                            Continue;
                           end;
                        BrandTable.FindKey([br]); {ReBranding}
                        aNode := Main.Tree.Items.AddChildObject(sgr_node, ReBranding(BrandTable.FieldByName('Description').AsString), Pointer(br));
                        Next;
                      end;
                    end;
                end;
            Next;
            end;
          end;
        end;

      MyGroupTable.Close;
    Main.TreePanel.Text := '<br><br><br>Для настройки Ваших групп выберите пункт меню <B>"Настройка / Настройка моих групп"</B>.';
    Main.Tree.Visible := (Main.Tree.Items.Count > 0);
    if Main.Tree.Items.Count > 0 then
    begin
      Main.Tree.AlphaSort(TRUE);
      Main.Tree.OnChange := Main.TreeChange;
      Main.Tree.Items[0].Selected := TRUE;

    end;
  end;


  if Tree_mode = 3 then
   begin
      gr_node:=nil;
        GroupBrandTable.Open;
        Group := 0;
        Subgroup := 0;
        fBrand := 0;
        Main.Tree.OnChange := nil;
        Main.Tree.Items.Clear;
        Main.Tree.Visible := True; 
     if GroupBrandTable.IndexName <> 'BrGroup' then
        GroupBrandTable.IndexName := 'BrGroup';
        MyBrandTable.Open;
        with BrandTable do
        begin
            First;
            while not Eof do
            begin
            if MyBrandTable.FindKey([FieldByName('Description').AsString]) then
            begin
                br := FieldByName('Brand_id').AsInteger;
                if not QueryFilter.Locate('Brand_id',VarArrayOf([br]),[]) then
                  begin
                    Next;
                    Continue;
                  end;

                br_node := Main.Tree.Items.AddObject(nil,
                ReBranding(FieldByName('Description').AsString), Pointer(br)); {ReBranding(}

                with GroupBrandTable do
                  begin
                    SetRange([br], [br]);
                    First;
                    while not Eof do
                    begin
                      gr := FieldByName('Group_id').AsInteger;
                      if not QueryFilter.Locate('Group_id;Brand_id',VarArrayOf([gr,br]),[]) then
                          begin
                            Next;
                            Continue;
                           end;
                      while (not Eof) and (FieldByName('Group_id').AsInteger = gr) do
                      begin
                        sgr := FieldByName('Subgroup_id').AsInteger;
                        if not QueryFilter.Locate('Group_id;Subgroup_id;Brand_id',VarArrayOf([gr,sgr,br]),[]) then
                          begin
                            Next;
                            Continue;
                           end;
                        GroupTable.FindKey([gr, sgr]);
                        aNode := Main.Tree.Items.AddChildObject(br_node,
                               GroupTable.FieldByName('subgroup_descr').AsString,
                              Pointer(gr * 1000 + sgr));
                        Next;
                      end;
                  end;
              end;
          end;
        Next;
      end;
    end;
    MyBrandTable.Close;

    Main.TreePanel.Text := '<br><br><br>Для настройки Ваших брендов выберите пункт меню <B>"Настройка / Настройка моих брендов"</B>.';
    Main.Tree.Visible := (Main.Tree.Items.Count > 0);
    if Main.Tree.Items.Count > 0 then
    begin
      Main.Tree.AlphaSort(TRUE);
      Main.Tree.OnChange := Main.TreeChange;
      Main.Tree.Items[0].Selected := TRUE;
    end;

    end;
    QueryFilter.Close;

  GroupBrandTable.Close;
  AfterLoadTree;
  exit;
  end;  *)

  gr_node:=nil;
  GroupBrandTable.Open;
  Group := 0;
  Subgroup := 0;
  fBrand := 0;
  Main.Tree.OnChange := nil;
  Main.Tree.Items.Clear;

  if Tree_mode = 0 then
  begin
    Main.Tree.Visible := True;
    if GroupBrandTable.IndexName <> 'GrBrand' then
      GroupBrandTable.IndexName := 'GrBrand';
    root := Main.Tree.Items.AddObject(nil, 'Весь ассортимент', Pointer(0));
    with GroupTable do
    begin
      First;
      while not Eof do
      begin
        gr := FieldByName('Group_id').AsInteger;
        gr_node := Main.Tree.Items.AddChildObject(root,
                             FieldByName('Group_descr').AsString, Pointer(gr));
        bAddGroup := FALSE;
        while (not Eof) and (FieldByName('Group_id').AsInteger = gr) do
        begin
          sgr := FieldByName('Subgroup_id').AsInteger;
          sgr_node := Main.Tree.Items.AddChildObject(gr_node,
          FieldByName('subgroup_descr').AsString, Pointer(sgr));
          with GroupBrandTable do
          begin
            SetRange([gr, sgr], [gr, sgr]);
            First;
            while not Eof do
            begin
              br := FieldByName('Brand_id').AsInteger;
              {if Main.UsaCheckBox.Checked then
                if not FieldByName('bUSA').AsBoolean then
                begin
                  Next;
                  Continue;
                end;

              if Main.NewCheckBox.Checked then
                if not FieldByName('bNew').AsBoolean then
                begin
                  Next;
                  Continue;
                end;        }
              BrandTable.FindKey([br]);
              aNode := Main.Tree.Items.AddChildObject(sgr_node,
              ReBranding(BrandTable.FieldByName('Description').AsString), {ReBranding}
              Pointer(br));
              Next;
            end;
            if sgr_node.getFirstChild = nil then
              Main.Tree.Items.Delete(sgr_node);
          end;
          Next;
        end;
         if gr_node.getFirstChild = nil then
              Main.Tree.Items.Delete(gr_node);
      end;

    end;
    Main.Tree.AlphaSort(TRUE);
    root.Expand(False);
    root.Selected := True;
  end
  else if Tree_mode = 1 then
  begin
    Main.Tree.Visible := True;
    root := Main.Tree.Items.AddObject(nil, 'Все бренды', Pointer(0));
    if GroupBrandTable.IndexName <> 'BrGroup' then
    GroupBrandTable.IndexName := 'BrGroup';

    with BrandTable do
    begin
      First;
      while not Eof do
      begin
        br := FieldByName('Brand_id').AsInteger;
        br_node := Main.Tree.Items.AddChildObject(root,
                             ReBranding(FieldByName('Description').AsString), Pointer(br)); {ReBranding}
        with GroupBrandTable do
        begin
          SetRange([br], [br]);
          First;
          while not Eof do
          begin
            gr := FieldByName('Group_id').AsInteger;
            while (not Eof) and (FieldByName('Group_id').AsInteger = gr) do
            begin
              sgr := FieldByName('Subgroup_id').AsInteger;
              GroupTable.FindKey([gr, sgr]);
              Main.Tree.Items.AddChildObject(br_node,
              GroupTable.FieldByName('subgroup_descr').AsString,
              Pointer(gr * 1000 + sgr));
              Next;
            end;
          end;
        end;
        Next;
      end;
    end;
    Main.Tree.AlphaSort(TRUE);
    //Main.Tree.SelectItem(root);
    root.Expand(False);
    root.Selected := True;
  end
  else if Tree_mode = 2 then
  begin
    with MyGroupTable do
    begin
      IndexName := 'GrDescr';
      Open;
    end;
    if GroupBrandTable.IndexName <> 'GrBrand' then
    GroupBrandTable.IndexName := 'GrBrand';
    with GroupTable do
    begin
      First;
      while not Eof do
      begin
        gr := FieldByName('Group_id').AsInteger;
        gr_descr := AnsiUpperCase(FieldByName('Group_descr').AsString);
        gr_chk := MyGroupTable.FindKey([gr_descr, '']);
        if gr_chk then
          gr_node := Main.Tree.Items.AddObject(nil,
                             FieldByName('Group_descr').AsString, Pointer(gr));
        while (not Eof) and (FieldByName('Group_id').AsInteger = gr) do
        begin
          sgr := FieldByName('Subgroup_id').AsInteger;
          sgr_descr := AnsiUpperCase(FieldByName('Subgroup_descr').AsString);
          if gr_chk and MyGroupTable.FindKey([gr_descr, sgr_descr]) then
          begin
            sgr_node := Main.Tree.Items.AddChildObject(gr_node,
                               FieldByName('subgroup_descr').AsString, Pointer(sgr));
            with GroupBrandTable do
            begin
              SetRange([gr, sgr], [gr, sgr]);
              First;
              while not Eof do
              begin
                br := FieldByName('Brand_id').AsInteger;
                BrandTable.FindKey([br]);
                aNode := Main.Tree.Items.AddChildObject(sgr_node,
                               ReBranding(BrandTable.FieldByName('Description').AsString), {ReBranding(}
                               Pointer(br));
                Next;
              end;
            end;
          end;
          Next;
        end;
      end;
    end;
    if Main.Tree.Items.Count > 0 then
    begin
      Group := Integer(Main.Tree.Items[0].Data);
      //Main.Tree.SelectItem(Main.Tree.Items[0]);
      Main.Tree.Items[0].Selected := True;
    end;
    MyGroupTable.Close;
    Main.TreePanel.Text := '<br><br><br>Для настройки Ваших групп выберите пункт меню <B>"Настройка / Настройка моих групп"</B>.';
    Main.Tree.Visible := (Main.Tree.Items.Count > 0);
    if Main.Tree.Items.Count > 0 then
      Main.Tree.AlphaSort(TRUE);
  end
  else if Tree_mode = 3 then
  begin
     if GroupBrandTable.IndexName <> 'BrGroup' then
    GroupBrandTable.IndexName := 'BrGroup';
    MyBrandTable.Open;
    with BrandTable do
    begin
      First;
      while not Eof do
      begin
        if MyBrandTable.FindKey([FieldByName('Description').AsString]) then
        begin
          br := FieldByName('Brand_id').AsInteger;
          br_node := Main.Tree.Items.AddObject(nil,
          ReBranding(FieldByName('Description').AsString), Pointer(br)); {ReBranding}

          with GroupBrandTable do
          begin
            SetRange([br], [br]);
            First;
            while not Eof do
            begin
              gr := FieldByName('Group_id').AsInteger;
              while (not Eof) and (FieldByName('Group_id').AsInteger = gr) do
              begin
                sgr := FieldByName('Subgroup_id').AsInteger;
                GroupTable.FindKey([gr, sgr]);
                aNode := Main.Tree.Items.AddChildObject(br_node,
                                 GroupTable.FieldByName('subgroup_descr').AsString,
                                 Pointer(gr * 1000 + sgr));
                Next;
              end;
            end;
          end;
        end;
        Next;
      end;
    end;
    MyBrandTable.Close;
    if Main.Tree.Items.Count > 0 then
    begin
      fBrand := Integer(Main.Tree.Items[0].Data);
      Main.Tree.SelectItem(Main.Tree.Items[0]);
      Main.Tree.Items[0].Selected := True;
    end;
    Main.TreePanel.Text := '<br><br><br>Для настройки Ваших брендов выберите пункт меню <B>"Настройка / Настройка моих брендов"</B>.';
    Main.Tree.Visible := (Main.Tree.Items.Count > 0);
    if Main.Tree.Items.Count > 0 then
      Main.Tree.AlphaSort(TRUE);
  end;
  Main.Tree.OnChange := Main.TreeChange;
  GroupBrandTable.Close;

  if Tree_mode in [0, 2] then
    begin
      if (CatalogDataSource.DataSet as TDBISAMTABLE).IndexName <> 'GrCode' then
        begin
             try
               (CatalogDataSource.DataSet as TDBISAMTABLE).IndexName := 'GrCode';
             except
             {  CatFilterTable.Close;
               CatFilterTable.Exclusive := TRUE;
               CatFilterTable.AddIndex('GrCode','T1;Group_id;Subgroup_id;Brand_id;Code');
               CatFilterTable.Exclusive := FALSE;
               CatFilterTable.IndexName := 'GrCode';
               CatFilterTable.Open;}
             end; 
        end;
    end
  else
     begin
        if (CatalogDataSource.DataSet as TDBISAMTABLE).IndexName <> 'BrCode' then
        begin
         { if CatFilterTable.IndexName = 'GrCode' then
            begin
              CatFilterTable.IndexName := '';
              CatFilterTable.DeleteIndex('GrCode');
            end;
          CatFilterTable.AddIndex('BrCode','T2;Brand_id;Group_id;Subgroup_id;Code');
          }
          (CatalogDataSource.DataSet as TDBISAMTABLE).IndexName := 'BrCode';
        end;
     end;

  (CatalogDataSource.DataSet as TDBISAMTABLE).SetRange([1], [1]);
  (CatalogDataSource.DataSet as TDBISAMTABLE).First;
  SetCatFilter;
  AfterLoadTree;
  Application.ProcessMessages;
except
  on e: Exception do
     begin
         MessageDlg(e.Message, mtInformation, [mbOK],0);
         Exit;
     end;
end;
end;

procedure TData.OOTableCalcFields(DataSet: TDataSet);
begin
  OOTableIsOrder.AsBoolean := True;
end;

procedure TData.OrderDetTableAfterScroll(DataSet: TDataSet);
begin
  OrderDetTable.EnableControls;
  fCloseControl := True;
end;

procedure TData.OrderDetTableBeforeScroll(DataSet: TDataSet);
begin
  if fCloseControl then
  begin
    OrderDetTable.DisableControls;
    fCloseControl := False;
  end
  else
    OrderDetTable.EnableControls; 
end;

procedure TData.OrderDetTableCalcFields(DataSet: TDataSet);
var
  k: integer;
  s: string;
begin
  with DataSet do
  begin
    k := masChek.IndexOf(Pointer(FieldByName('id').AsInteger));
    FieldByname('CheckField').AsBoolean :=  k >= 0;
    if BrandTable.Locate('Description', FieldByName('Brand').AsString, [loCaseInsensitive]) and
       XCatTable.FindKey([FieldByName('Code2').AsString,
                          BrandTable.FieldByName('Brand_id').AsInteger]) then
    begin
      FieldByname('BrandRepl').AsString := ReBranding(BrandTable.FieldByName('Description').AsString);
      FieldByname('Cat_id').Value := XCatTable.FieldByName('Cat_id').AsInteger;
      FieldByname('ArtCode').Value := XCatTable.FieldByName('Code').AsString;
      FieldByname('ArtName').Value := XCatTable.FieldByName('Name').AsString;
      FieldByname('ArtDescr').Value := XCatTable.FieldByName('Description').AsString;
      FieldByname('ArtPrice').Value := XCatTable.FieldByName('PriceItog').AsFloat;
      FieldByname('ArtSale').Value := XCatTable.FieldByName('SaleQ').AsString;
      FieldByname('ArtBrandId').Value := XCatTable.FieldByName('Brand_id').AsString;
      FieldByname('ArtGroupId').Value := XCatTable.FieldByName('Group_id').AsString;
      FieldByname('ArtSubgroupId').Value := XCatTable.FieldByName('Subgroup_id').AsString;
      FieldByname('Mult').Value := XCatTable.FieldByName('Mult').AsString;
    end;

    FieldByName('Price_koef').Value := FieldByname('ArtPrice').Value;//валюта + скидка

    FieldByName('Sum').Value :=
                XRoundCurr(FieldByName('Price_koef').AsCurrency *
                FieldByName('Quantity').AsFloat, Curr);
    FieldByName('ArtNameDescr').Value := Trim(FieldByName('ArtName').AsString + ' ' +
                                              FieldByname('ArtDescr').AsString);
    FieldByName('ArtCodeBrand').Value := Trim(FieldByName('ArtCode').AsString + '_' +
                                              FieldByname('Brand').AsString);

    //в розничных ценах
    FieldByName('Price_pro_koef').Value :=
         XRoundCurr(Rate * FieldByName('Price_pro').AsCurrency, Curr);
    FieldByName('Sum_pro').Value :=
                XRoundCurr(FieldByName('Price_pro_koef').AsCurrency *
                FieldByName('Quantity').AsFloat, Curr);
  end;
end;


 procedure TData.AfterLoadTree;
type
  TNodeStates = (nsRoot, nsGroup, nsGroupRed, nsGroupHalf, nsBrand, nsBrandRed, nsBrandHalf);
const
  cImgIndexes: array[TNodeStates] of Integer = (
    6, //nsRoot
    0, //nsGroup
    1, //nsGroupRed
    11, //nsGroupHalf
    0, //nsBrand
    1, //nsBrandRed
    11  //nsBrandHalf
  );


  function GetTreeIdent(aNode: TTreeNode): string;
  var
    g, s, b: Integer;
  begin
    if Self.Tree_mode = 0 then
    begin
      case aNode.Level of
        0:
        begin
          g := 0;
          s := 0;
          b := 0;
        end;
        1:
        begin
          g := Integer(aNode.Data);
          s := 0;
          b := 0;
        end;
        2:
        begin
          g := Integer(aNode.Parent.Data);
          s := Integer(aNode.Data);
          b := 0;
        end;
        3:
        begin
          g := Integer(aNode.Parent.Parent.Data);
          s := Integer(aNode.Parent.Data);
          b := Integer(aNode.Data);
        end;
      end;//case
    end
    else if Self.Tree_mode = 1 then
    begin
      case aNode.Level of
        0:
        begin
          g := 0;
          s := 0;
          b := 0;
        end;
        1:
        begin
          b := Integer(aNode.Data);
          g := 0;
          s := 0;
        end;
        2:
        begin
          b := Integer(aNode.Parent.Data);
          g := Integer(aNode.Data) div 1000;
          s := Integer(aNode.Data) mod 1000;
        end;
      end;//case
    end
    else if Self.Tree_mode = 2 then
    begin
      case aNode.Level of
        0:
        begin
          g := Integer(aNode.Data);
          s := 0;
          b := 0;
        end;
        1:
        begin
          g := Integer(aNode.Parent.Data);
          s := Integer(aNode.Data);
          b := 0;
        end;
        2:
        begin
          g := Integer(aNode.Parent.Parent.Data);
          s := Integer(aNode.Parent.Data);
          b := Integer(aNode.Data);
        end;
      end;//case
    end
    else if Self.Tree_mode = 3 then
    begin
      case aNode.Level of
        0:
        begin
          b := Integer(aNode.Data);
          g := 0;
          s := 0;
        end;
        1:
        begin
          b := Integer(aNode.Parent.Data);
          g := Integer(aNode.Data) div 1000;
          s := Integer(aNode.Data) mod 1000;
        end;
      end;
    end;
    Result := Format('%d,%d,%d', [g, s, b]);
  end;

var
  aQueryOO: TDBISAMQuery;
  aRootNode, aGroupNode, aSubgroupNode, aBrandNode: TTreeNode;
  OOList: TStrings;
  s: string;
  AllChildRed, AllChildRed1, aHasRed, aHasRed1: Boolean;
  sGr, sSGr, sB: string;
  isHalf: Boolean;
  aValue, aSaveIndex: string;
begin
  OOList := TStringList.Create;
  aQueryOO := TDBISAMQuery.Create(nil);
  aSaveIndex := XCatTable.IndexName;
  XCatTable.IndexName := 'GrCode';
  try
    aQueryOO.DatabaseName := Database.DatabaseName;
    aQueryOO.SQL.Text :=
      ' SELECT CAT_ID FROM [042] ';
    aQueryOO.Open;
    while not aQueryOO.Eof do
    begin
      if XCatTable.Locate('CAT_ID', aQueryOO.Fields[0].AsInteger, []) then
      begin
        sGr := XCatTable.FieldByName('Group_id').AsString;
        sSGr := XCatTable.FieldByName('SubGroup_id').AsString;
        sB := XCatTable.FieldByName('Brand_id').AsString;

        s := XCatTable.FieldByName('Group_id').AsString + ',' + XCatTable.FieldByName('SubGroup_id').AsString + ',' + XCatTable.FieldByName('Brand_id').AsString;
        if OOList.IndexOfName(s) = -1 then
        begin
          XCatTable.SetRange([1, sGr, sSGr, sB], [1, sGr, sSGr, sB]);
          XCatTable.First;
          isHalf := False;
          while not XCatTable.Eof do
          begin
            if XCatTable.FieldByName('TITLE').AsBoolean then
            begin
              XCatTable.Next;
              Continue;
            end;
            if not OOTable.Locate('CAT_ID', XCatTable.FieldByName('CAT_ID').AsInteger, []) then
            begin
              isHalf := True;
              Break;
            end;
            XCatTable.Next;
          end;
          XCatTable.CancelRange;

          if isHalf then
            OOList.Add(s + '=' + '0')
          else
            OOList.Add(s + '=' + '1');
        end;
      end;
      aQueryOO.Next;
    end;
  finally
    XCatTable.IndexName := aSaveIndex;
    aQueryOO.Free;
  end;

  aRootNode := Main.Tree.Items.GetFirstNode;
  if not Assigned(aRootNode) then
    Exit;

  if (Tree_mode in [2, 3]) then //мои группы, мои бренды - там нет RootNode
  begin

  end
  else
  begin
    aRootNode.ImageIndex := cImgIndexes[nsRoot];
    aRootNode.SelectedIndex := cImgIndexes[nsRoot];
    aRootNode := aRootNode.getFirstChild;
  end;


  if Tree_mode in [0, 2] then //по группам
  begin
    aGroupNode := aRootNode;
    while Assigned(aGroupNode) do
    begin

      aSubgroupNode := aGroupNode.getFirstChild;
      AllChildRed1 := Assigned(aSubgroupNode);
      aHasRed1 := False;
      while Assigned(aSubgroupNode) do
      begin

        aBrandNode := aSubgroupNode.getFirstChild;
        AllChildRed := Assigned(aBrandNode);
        aHasRed := False;
        while Assigned(aBrandNode) do
        begin
          aValue := OOList.Values[GetTreeIdent(aBrandNode)];
          if aValue = '1' then
          begin
            aBrandNode.ImageIndex := cImgIndexes[nsBrandRed];
            aHasRed := True;
          end
          else if aValue = '0' then
          begin
            aBrandNode.ImageIndex := cImgIndexes[nsBrandHalf];
            aHasRed := True;
            AllChildRed := False;
          end
          else
          begin
            aBrandNode.ImageIndex := cImgIndexes[nsBrand];
            AllChildRed := False;
          end;
          aBrandNode.SelectedIndex := aBrandNode.ImageIndex;

          aBrandNode := aBrandNode.getNextSibling;
        end;

        if AllChildRed then
        begin
          aSubgroupNode.ImageIndex := cImgIndexes[nsGroupRed];
          aHasRed1 := True;
        end
        else
          if aHasRed then
          begin
            aSubgroupNode.ImageIndex := cImgIndexes[nsGroupHalf];
            aHasRed1 := True;
            AllChildRed1 := False;
          end
          else
          begin
            aSubgroupNode.ImageIndex := cImgIndexes[nsGroup];
            AllChildRed1 := False;
          end;

        aSubgroupNode.SelectedIndex := aSubgroupNode.ImageIndex;
        aSubgroupNode := aSubgroupNode.getNextSibling;
      end;

      if AllChildRed1 then
        aGroupNode.ImageIndex := cImgIndexes[nsGroupRed]
      else
        if aHasRed1 then
          aGroupNode.ImageIndex := cImgIndexes[nsGroupHalf]
        else
          aGroupNode.ImageIndex := cImgIndexes[nsGroup];
      aGroupNode.SelectedIndex := aGroupNode.ImageIndex;
      aGroupNode := aGroupNode.getNextSibling;
    end;
  end
  else //по брендам
  begin

    aBrandNode := aRootNode;
    while Assigned(aBrandNode) do
    begin

      aSubgroupNode := aBrandNode.getFirstChild;
      AllChildRed := Assigned(aSubgroupNode);
      aHasRed := False;
      while Assigned(aSubgroupNode) do
      begin
        aValue := OOList.Values[GetTreeIdent(aSubgroupNode)];
        if aValue = '1' then
        begin
          aSubgroupNode.ImageIndex := cImgIndexes[nsGroupRed];
          aHasRed := True;
        end
        else if aValue = '0' then
        begin
          aSubgroupNode.ImageIndex := cImgIndexes[nsGroupHalf];
          aHasRed := True;
          AllChildRed := False;
        end
        else
        begin
          aSubgroupNode.ImageIndex := cImgIndexes[nsGroup];
          AllChildRed := False;
        end;
        aSubgroupNode.SelectedIndex := aSubgroupNode.ImageIndex;

        aSubgroupNode := aSubgroupNode.getNextSibling;
      end;

      if AllChildRed then
        aBrandNode.ImageIndex := cImgIndexes[nsBrandRed]
      else
        if aHasRed then
          aBrandNode.ImageIndex := cImgIndexes[nsBrandHalf]
        else
          aBrandNode.ImageIndex := cImgIndexes[nsBrand];
      aBrandNode.SelectedIndex := aBrandNode.ImageIndex;

      aBrandNode := aBrandNode.getNextSibling;
    end;
  end;

  OOList.Free;
  Main.Tree.Repaint;
end;

procedure TData.OrderTableAfterScroll(DataSet: TDataSet);
begin
  fOrderTableInAfterScroll := True;
  try
    Main.ZakTabInfo;
    Main.ClearTestQuants;
  finally
    fOrderTableInAfterScroll := False;
  end;
end;

procedure TData.OrderTableBeforeScroll(DataSet: TDataSet);
begin
  if main.fClearSelection then
    main.ClearSelection;
  OrderDetTable.Resync([rmCenter]);
end;

procedure TData.OrderTableCalcFields(DataSet: TDataSet);
var
  sum: Currency;
  sum_pro: Currency;
  cnt: integer;
begin
  with DataSet do
  begin
    FieldByname('Info').Value := FieldByName('Description').AsString;

    if (FieldByName('ClientLookup').IsNull) or (ParamTable.FieldByName('Cli_id_mode').AsString <> '1') then
      FieldByName('ClientInfo').Value := FieldByName('Cli_id').AsString
    else
      FieldByName('ClientInfo').Value := FieldByName('ClientLookup').AsString;
{
    if Main.UserIds_Combo.ItemIndex > -1 then
      FieldByName('ClientInfo').Value := Main.UserIds_Combo.Text;
}
  end;

  sum := 0;
  sum_pro := 0;
  cnt := 0;
  with OrderDetTable do
  begin
    SetRange([DataSet.FieldByName('Order_id').AsInteger],
             [DataSet.FieldByName('Order_id').AsInteger]);
    First;
    while not Eof do
    begin
      sum := sum + XRoundCurr(FieldByName('Price_koef').AsCurrency * FieldByName('Quantity').AsFloat, Curr);
      {XRoundCurr(XRoundCurr(Rate * FieldByName('ArtPrice').AsCurrency, Curr) *
                           FieldByName('Quantity').AsFloat, Curr);  }

      sum_pro := sum_pro + XRoundCurr(XRoundCurr(Rate * FieldByName('Price_pro').AsCurrency, Curr) *
                           FieldByName('Quantity').AsFloat, Curr);
      Inc(cnt);
      Next;
    end;
  end;
  DataSet.FieldByName('Sum').Value := sum;
  DataSet.FieldByName('Sum_pro').Value := sum_pro;
  DataSet.FieldByName('Pos').Value := cnt;
  DataSet.FieldByName('IsDeliveredCalc').AsBoolean := (DataSet.FieldByName('IsDelivered').AsInteger = 1) and
                                                      (DataSet.FieldByName('Sent').AsString <> '' ) and
                                                      (DataSet.FieldByName('Sent').AsString <> '0') and
                                                      (DataSet.FieldByName('Delivery').AsInteger = 1) and
                                                      (DataSet.FieldByName('Sign').AsString <> '');
end;



function TData.ReBranding(const aBrand: string; const fCanIbeOE: boolean = TRUE): string;
var
  i : integer;
begin
  Result := aBrand;
  
  if aBrand = 'LPR' then
    Result := 'AP'

  else if aBrand = 'CLEAN FILTER' then
    Result := 'CLEAN FILTERS'

  else if (AutoMakerTable.Active) and (fCanIbeOE) then
  begin
    if AutoMakerTable.Locate('AutoMaker', aBrand, [])then
        Result := 'OE ' + aBrand;
  end
end;

procedure TData.RecalcOrder;
var
  UserData: TUserIDRecord;
  aOldClientId: string;
begin
  if MessageDlg('Пересчитать заказ с учетом изменившихся цен и скидок?',
         mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  //устанавливаем скидки для клиента из заказа

  aOldClientId := '';
  UserData := Main.GetCurrentUser;
  if Assigned(UserData) then
    aOldClientId := UserData.sId;

  with DiscountTable do
  begin
    DisableControls;
    if IndexName <> 'CLI' then
      IndexName := 'CLI';
    SetRange([OrderTable.FieldByName('Cli_id').AsString], [OrderTable.FieldByName('Cli_id').AsString]);
    EnableControls;
  end;

  try
    with OrderDetTable do
    begin
      DisableControls;
      First;
      while not Eof do
      begin
        Edit;

        if FieldByName('ArtSale').Asstring <> '1' then
          FieldByName('Price').Value :=
                 XRoundCurr(GetDiscount(FieldByName('ArtGroupId').AsInteger,
                                    FieldByName('ArtSubGroupId').AsInteger,
                                    FieldByName('ArtBrandId').AsInteger) *
                        FieldByName('ArtPrice').AsCurrency, ctEUR)
        else
          FieldByName('Price').Value :=
                 FieldByName('ArtPrice').AsCurrency;

        FieldByName('Price_pro').Value :=
                 XRoundCurr(GetMargin(FieldByName('ArtGroupId').AsInteger,
                                    FieldByName('ArtSubGroupId').AsInteger,
                                    FieldByName('ArtBrandId').AsInteger) *
                        FieldByName('Price').AsCurrency, ctEUR);

        Post;
        Next;
      end;
      First;
      EnableControls;
    end;

  finally
    with DiscountTable do
    begin
      DisableControls;
      if IndexName <> 'CLI' then
        IndexName := 'CLI';
      SetRange([aOldClientId], [aOldClientId]);
      EnableControls;
    end;
  end;

  OrderTable.Refresh;
  OrderTableAfterScroll(OrderTable);
end;



procedure TData.SetCatFilter;
var
  sFilter, s1,s2,s: string;
  iPos: Integer;
begin
  sFilter := sAuto;
  if (Main.WithQuants.Checked) and (sIDs <> '') then
  begin
     if sFilter <> '' then
     begin
       sFilter :='('+ sFilter + ') AND ' + sIDs
     end
     else
       sFilter := sIDs;
  end;

  if (Main.WithLatestQuants.Checked) and (sLatestIDs <> '') then
  begin
     if sFilter <> '' then
     begin
       sFilter :='('+ sFilter + ') AND ' + sLatestIDs
     end
     else
       sFilter := sLatestIDs;
  end;


  {if Main.SaleCheckBox.Checked then
      begin
        if sFilter <> '' then
          sFilter :='('+ sFilter + ') AND ';
        sFilter := sFilter + '(Sale = ''1'')';
      end;

  if Main.NewCheckBox.Checked then
   begin
        if sFilter <> '' then
           sFilter :='('+ sFilter + ') AND ';
        sFilter := sFilter + '(New = ''1'')';
      end;

  if Main.UsaCheckBox.Checked then
      begin
        if sFilter <> '' then
          sFilter :='('+ sFilter + ') AND ';
        sFilter:= sFilter + '(Usa = ''1'')';
      end;
               }

  with (CatalogDataSource.DataSet as TDBISAMTABLE) do
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




  exit;
  CloseInfo;
  if bOpeened then
  begin
    Main.bAbort := TRUE;
    TimerSetCatFilter.Enabled := TRUE;
    exit;
  end
  else
     Main.bAbort := FALSE;

  if (Length(sAuto) > 0) then
  begin
    if (Main.bAbort)and((Main.FiltModeComboBox.ItemIndex = 0)and(Auto_type > 0)) then
      Main.bAbort := FALSE;

    if not Main.bAbort then
    begin
         Main.ShowProgress('Обработка результата...');
         if CatalogDataSource.DataSet <> FilterResult then
          begin
            CatalogDataSource.DataSet := FilterResult;
            fBrand := 0;
            Subgroup:=0;
            Group:=0;
          end
          else
            begin
             try
               FilterResultFind.Close;
               FilterResult.Close;
               FilterResult.EmptyTable;
             except
               on e: Exception do
                 begin
                   exit;
                 end;
            end;
    end;



    QuerySelect.Close;
    QuerySelect.SQL.Clear;
    QuerySelect.SQL.Add('SELECT [002].*,([012].Price) as PriceQuant , ([012].Sale) as SaleQ ,(Name+'' ''+Description) as Name_Descr, (Group_descr+''/''+Subgroup_descr)  as GroupInfo, ([012].Quantity) As Quantity,');
    QuerySelect.SQL.Add(' ([003].Description) as BrandDescr ');
    QuerySelect.SQL.Add(' INTO "MEMORY\FilterResult"');
    QuerySelect.SQL.Add(' FROM [002] join [004] on [004].Subgroup_id = [002].Subgroup_id AND [004].Group_id = [002].Group_id');
    QuerySelect.SQL.Add(' join [003] on [003].Brand_id = [002].Brand_id left join [012] on [012].Cat_id = [002].Cat_id WHERE '+Data.sAuto);

    if fBrand > 0 then
    begin
      QuerySelect.SQL.Add(' AND [003].Brand_id = '+inttostr(fBrand));
    end;

    if Subgroup > 0 then
    begin
      QuerySelect.SQL.Add(' AND [004].Subgroup_id = '+inttostr(Subgroup));
    end;

    if Group > 0 then
    begin
      QuerySelect.SQL.Add(' AND [004].Group_id = '+inttostr(Group));
    end;

      {if Main.SaleCheckBox.Checked then
      begin
        QuerySelect.SQL.Add(' AND [002].Sale = ''1''');
      end;   }
      {if Main.NewCheckBox.Checked then
      begin
        QuerySelect.SQL.Add(' AND [002].New = ''1''');
      end;
      if Main.UsaCheckBox.Checked then
      begin
        QuerySelect.SQL.Add(' AND [002].USA = ''1''');
      end;   }

      if Main.FiltModeComboBox.ItemIndex = 0 then
        begin
          if Main.FiltEd.Text <> '' then
          begin
           sFilter:=AnsiUpperCase(Main.FiltEd.Text);
           while(sFilter <> ReplaceStr(sFilter,'''','''''')) do
               sFilter := ReplaceStr(sFilter,'''','''''');
           while(sFilter <> ReplaceStr(sFilter,'%',' ')) do
               sFilter := ReplaceStr(sFilter,'%',' ');

           sFilter := ReplaceStr(sFilter,' ','%');
           while(sFilter <> ReplaceStr(sFilter,':%',':')) do
                  sFilter := ReplaceStr(sFilter,':%',':');
           while(sFilter <> ReplaceStr(sFilter,'%:',':')) do
                  sFilter := ReplaceStr(sFilter,'%:',':');
           while(sFilter <> ReplaceStr(sFilter,'%%','%')) do
               sFilter := ReplaceStr(sFilter,'%%','%');
           while '%' = Main.StrLeft(sFilter,1) do
               sFilter := Main.StrRight(sFilter,length(sFilter)-1);
           while '%' = Main.StrLeft(sFilter,2) do
               sFilter := Main.StrLeft(sFilter,length(sFilter)-1);

           iPos := Main.StrFind(sFilter,':');
            if iPos>0 then
              begin
              s1:=Main.StrLeft(sFilter,iPos-1);
              s2:=Main.StrRight(sFilter,Length(sFilter)-iPos);
              if s1<> '' then
                begin
                  s := 'upper(Name) LIKE('+'''%''+'''+s1+'''+''%'')';
                  QuerySelect.SQL.Add(' AND upper([002].Name) LIKE('+'''%''+'''+s1+'''+''%'')');
                  if s2<> '' then
                     QuerySelect.SQL.Add(' AND upper([002].Description) LIKE('+'''%''+'''+s2+'''+''%'')');
                end
              else
                   if s2<> '' then
                     QuerySelect.SQL.Add(' AND upper([002].Description) LIKE('+'''%''+'''+s2+'''+''%'')');
              end
            else
              QuerySelect.SQL.Add(' AND( upper([002].Name) LIKE('+'''%''+'''+sFilter+'''+''%'') OR upper([002].Description) LIKE('+'''%''+'''+sFilter+'''+''%''))');
        end;
     end;
   QuerySelect.SQL.Add(' ORDER BY CODE, BrandDescr, GroupInfo');

    if Main.bAbort  then
    begin
       Main.HideProgress; 
       Main.bAbort := FALSE; 
       exit;
    end;
    bOpeened := TRUE;
    QuerySelect.open;
    QuerySelect.Close;
    bOpeened := FALSE;
    if Main.bAbort  then
    begin
       Main.HideProgress; 
       Main.bAbort := FALSE; 
       exit;
    end;

     if Main.bAbort  then
    begin
       Main.HideProgress; 
       Main.bAbort := FALSE; 
       exit;
    end;
    Main.HideProgress;
    FilterResult.Open;
    FilterResultFind.Open;
     if Main.bAbort  then
    begin
      FilterResult.Close;
      FilterResultFind.Close;
      Main.bAbort := FALSE; 
      exit;
    end;

    if not Main.bAbort then
    begin
      exit;
    end
    else
      begin
        if (Main.FiltModeComboBox.ItemIndex = 0)and(Auto_type > 0) then
          exit;
        CatalogDataSource.DataSet :=  CatalogTable;
        FilterResult.Close;
        FilterResultFind.Close;
        Main.bAbort := FALSE;
      end;
    end;
  end
  else
  begin
      if CatalogDataSource.DataSet <> nil then
      if CatalogDataSource.DataSet <>  CatalogTable then
        begin
        FilterResultFind.Close;
        FilterResult.Close;
        FilterResult.EmptyTable;
        FilterResultFind.EmptyTable;
        QuerySelect.Close;
        CatalogDataSource.DataSet :=  CatalogTable;
        if not CatalogTable.Active then
          CatalogTable.Open;
      end;
  end;

  if not CatalogTable.Active then
  begin
    CatalogTable.Open;
  end;

  with CatalogTable do
  begin
    StartWait;
    if Tree_mode in [0, 2] then
    begin
      if fBrand <> 0 then
        SetRange([1, Group, Subgroup, fBrand], [1, Group, Subgroup, fBrand])
      else if Subgroup <> 0 then
        SetRange([1, Group, Subgroup], [1, Group, Subgroup])
      else if Group <> 0 then
        SetRange([1, Group], [1, Group])
      else
        SetRange([1], [1]);
      First;
    end
    else if Tree_mode in [1, 3] then
    begin
      if Subgroup <> 0 then
        SetRange([1, fBrand, Group, Subgroup], [1, fBrand, Group, Subgroup])
      else if fBrand <> 0 then
        SetRange([1, fBrand], [1, fBrand])
      else
        SetRange([1], [1]);
      First;
    end;
    StopWait;
    SetTxtFilter;
  end;
end;


procedure TData.SetDefaultClient(const aClientID: string);
begin
  if aClientID <> '' then
  begin
    Query.Close;
    Query.SQL.Text := 'UPDATE [011] SET BYDEFAULT = 0';
    Query.ExecSQL;

    Query.Close;
    Query.SQL.Text := 'UPDATE [011] SET BYDEFAULT = 1 WHERE CLIENT_ID = ''' + aClientID + '''';
    Query.ExecSQL;

    Query.Close;
  end;
end;

procedure TData.SetTxtFilter;
var
  s, s1,s2: string;
  sFilter:string;
  iPos:integer;
begin
  StartWait;
  with CatalogTable do
  begin
    if (Main.FiltEd.Text <> '') or (Auto_type <> 0){ or
        {Main.SaleCheckBox.Checked or Main.NewCheckBox.Checked or
        Main.UsaCheckBox.Checked }then
    begin
      DisableControls;
      Application.ProcessMessages;
      if Main.FiltEd.Text <> '' then
      begin
         sFilter:=AnsiUpperCase(Main.FiltEd.Text);

        while(sFilter <> ReplaceStr(sFilter,'%',' ')) do
               sFilter := ReplaceStr(sFilter,'%',' ');

        if Main.FiltModeComboBox.ItemIndex = 0 then
        begin

          sFilter := ReplaceStr(sFilter,' ','%');
          while(sFilter <> ReplaceStr(sFilter,':%',':')) do
                  sFilter := ReplaceStr(sFilter,':%',':');

          while(sFilter <> ReplaceStr(sFilter,'%:',':')) do
                  sFilter := ReplaceStr(sFilter,'%:',':');

          while(sFilter <> ReplaceStr(sFilter,'%%','%')) do
               sFilter := ReplaceStr(sFilter,'%%','%');


          while '%' = Main.StrLeft(sFilter,1) do
                  sFilter := Main.StrRight(sFilter,length(sFilter)-1);

          while '%' = Main.StrLeft(sFilter,2) do
                  sFilter := Main.StrLeft(sFilter,length(sFilter)-1);

          sFilter := ReplaceStr(sFilter,'''','''''');
          
         iPos := Main.StrFind(sFilter,':');
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
                     s := s + 'upper(Description) LIKE('+'''%''+'''+s2+'''+''%'')';
              end
          else
              s := 'upper(Name) LIKE('+'''%''+'''+sFilter+'''+''%'') OR upper(Description) LIKE('+'''%''+'''+sFilter+'''+''%'')';

          if Auto_type < 1 then
            sAuto :='';
             
        end
        else if Main.FiltModeComboBox.ItemIndex = 1 then
        begin
       
          //  s := 'upper(Code2) LIKE('+'''%''+'''+sFilter+'''+''%'')';
        end
        else if Main.FiltModeComboBox.ItemIndex = 2 then
          begin
         { TestQuery.Close;
          TestQuery.SQL.Clear;
          TestQuery.SQL.Add('SELECT [016].Cat_id FROM [016] WHERE upper(Code2) LIKE('+'''%''+'''+sFilter+'''+''%'')');
          TestQuery.Active:= TRUE;
          if not TestQuery.Eof then
          begin
          while not TestQuery.Eof do
          begin
             s := s + ' OR Cat_id = '+TestQuery.FieldByName('Cat_id').AsString;
             TestQuery.Next;
          end;
          TestQuery.Close;

          s := Main.StrRight(s,Length(s)-4);

          if (Brand <> 0) then
      if SearchTable.FieldByName('Brand_id').AsInteger <> Brand then
        begin
          CatalogTable.CancelRange;
        end
        else
        if Subgroup <> 0 then
        begin
          if SearchTable.FieldByName('Subgroup_id').AsInteger <> Subgroup then
          begin
              CatalogTable.CancelRange;
          end
          else
          if Group <> 0 then
          begin
             if SearchTable.FieldByName('Group_id').AsInteger <> Group then
              begin
                CatalogTable.CancelRange;
              end
          end;
        end;

          end
          else
            s := 'Cat_id = -1';
          //s := 'upper(Oem) LIKE('+'''%''+'''+sFilter+'''+''%'')';
          }
          end
        else if Main.FiltModeComboBox.ItemIndex = 3 then
        begin
    {     AnSearchTable.SetRange([sFilter], [sFilter]);
          with AnSearchTable do
            begin
              if not AnSearchTable.Eof then
                begin
                  while not AnSearchTable.Eof do
                    begin
                    s := s + ' OR Cat_id = '+FieldByName('Cat_id').AsString;
                    Next;
                    end;
                  s := Main.StrRight(s,Length(s)-4);

      if (Brand <> 0) then
      if SearchTable.FieldByName('Brand_id').AsInteger <> Brand then
        begin
          CatalogTable.CancelRange;
        end
        else
        if Subgroup <> 0 then
        begin
          if SearchTable.FieldByName('Subgroup_id').AsInteger <> Subgroup then
          begin
              CatalogTable.CancelRange;
          end
          else
          if Group <> 0 then
          begin
             if SearchTable.FieldByName('Group_id').AsInteger <> Group then
              begin
                CatalogTable.CancelRange;
              end
          end;  }
        end;
          { end
              else
                  s := 'Cat_id = -1';
                  AnSearchTable.CancelRange;
             end;
          end; }
      end;
      //else
       { if Auto_type <> 0 then
            begin
             if s <> '' then
               s :='('+ s + ') AND ';
               s:=s+sAuto;
            end; }
      if length(sAuto) > 0 then
            begin
             if s <> '' then
               s :='('+ s + ') AND ';
               s:=s+'('+sAuto+')';
            end;


    {  if Main.SaleCheckBox.Checked then
      begin
        if s <> '' then
          s :='('+ s + ') AND ';
        s := s + '(Sale = ''1'')';
      end;
      if Main.NewCheckBox.Checked then
      begin
        if s <> '' then
           s :='('+ s + ') AND ';
        s := s + '(New = ''1'')';
      end;
      if Main.UsaCheckBox.Checked then
      begin
        if s <> '' then
          s :='('+ s + ') AND ';
        s := s + '(Usa = ''1'')';
      end;   }

      if Filter <> s then
      begin
        Filter := s;
        Filtered := True;
      end;
      if not Filtered then
      begin

        Filtered := True;
      end;

//      Application.ProcessMessages;
    end
    else
    begin
      Filter := '';
      Filtered := False;
    end;
    EnableControls;
  end;
  StopWait;  
end;

function getCurCode(index: integer):string;
begin
  case index of
    0: result := 'EUR';
    1: result := 'USD';
    2: result := 'BYR';
    3: result := 'RUB';
  end;
end;


function TData.GetCurByCode(const Cur: string): Currency;
begin
  if Cur = 'EUR' then
    result := 1;
  if Cur = 'USD' then
    result := ParamTable.FieldByName('Eur_usd_rate').AsCurrency;
  if Cur = 'BYR' then
    result := ParamTable.FieldByName('Eur_rate').AsCurrency;
  if Cur = 'RUB' then
    result := ParamTable.FieldByName('Eur_RUB_rate').AsCurrency;
end;


procedure TData.SetPriceKoef;
begin
//  Discount_koef := 1 - Data.ParamTable.FieldByName('Discount').AsCurrency / 100;
//  Profit_koef   := 1 + Data.ParamTable.FieldByName('Profit').AsCurrency / 100;
  case Curr of
    0: Rate := 1;
    1: Rate := Data.ParamTable.FieldByName('Eur_usd_rate').AsCurrency;
    2: Rate := Data.ParamTable.FieldByName('Eur_rate').AsCurrency;
    3: Rate := Data.ParamTable.FieldByName('Eur_RUB_rate').AsCurrency;
  end;

  if Data.CatalogDataSource.DataSet.Active then
    CatalogDataSource.DataSet.Refresh;
  AnalogTable.Refresh;
  OrderDetTable.Refresh;
  OrderTable.Refresh;
  WaitListTable.Refresh;
  AssortmentExpansion.Refresh;
  KK.Refresh;
  KitTable.Refresh;
  Main.KitGridEh.SumList.RecalcAll;
  
  Main.CurrencyChanged;
end;

procedure TData.CatalogTable_2CalcFields(DataSet: TDataSet);
var
  quant: real;
begin
  with DataSet do
  begin
    FieldByName('SaleQ').Value := FieldByName('saleQCalc').Value;

    if FieldByName('PriceQuant').AsCurrency > 0 then
       FieldByName('PriceItog').AsCurrency := FieldByName('PriceQuant').AsCurrency
    else
       FieldByName('PriceItog').AsCurrency := FieldByName('Price').AsCurrency;

    FieldByName('GroupInfo').Value := FieldByName('GroupDescr').AsString +
      iif(FieldByName('SubgroupDescr').AsString <> '', ' / ' +
          FieldByName('SubgroupDescr').AsString, '');
    if not FieldByName('Title').AsBoolean  then
    begin
      if FieldByName('SaleQ').AsString <> '1' then
        FieldByName('Price_koef_eur').Value :=
           XRoundCurr(GetDiscount(FieldByName('Group_id').AsInteger, FieldByName('Subgroup_id').AsInteger, FieldByName('Brand_id').AsInteger) *
                  FieldByName('PriceItog').AsCurrency, ctEUR)
      else
        FieldByName('Price_koef_eur').Value := FieldByName('PriceItog').AsCurrency;
      FieldByName('Price_koef').Value :=
           XRoundCurr(Rate * FieldByName('Price_koef_eur').AsCurrency, Curr);
      FieldByName('Price_pro').Value :=
           XRoundCurr(GetMargin(FieldByName('Group_id').AsInteger, FieldByName('Subgroup_id').AsInteger, FieldByName('Brand_id').AsInteger) *
                  FieldByName('Price_koef').AsCurrency, Curr);
    end;
    XOrderDetTable2.SetRange([OrderTable.FieldByName('Order_id').AsInteger,
                              FieldByName('Code2').AsString,
                              FieldByName('BrandDescr').AsString],
                             [OrderTable.FieldByName('Order_id').AsInteger,
                              FieldByName('Code2').AsString,
                              FieldByName('BrandDescr').AsString]);
    with XOrderDetTable2 do
    begin
      First;
      quant := 0;
      while not Eof do
      begin
        quant := quant + FieldByName('Quantity').AsFloat;
        Next;
      end;
    end;
    FieldByName('OrdQuantity').Value := quant;
    if quant <> 0 then
      FieldByName('OrdQuantityStr').Value := CurrToStr(quant)
    else
      FieldByName('OrdQuantityStr').Value := '';
    FieldByName('Name_Descr').Value := Trim(FieldByName('Name').AsString + ' ' +
                                       FieldByname('Description').AsString);
  end;

end;

procedure TData.CatalogTableAfterScroll(DataSet: TDataSet);
begin
{
  Main.pnDetailsLoad.SetBounds(0, 0, Main.pnDetailsLoad.Parent.ClientWidth, Main.pnDetailsLoad.Parent.ClientHeight);
  Main.pnDetailsLoad.Visible := True;
  Main.pnDetailsLoad.BringToFront;
}
  Main.LoadTDInfoTimer.Enabled := False;
  Main.LoadTDInfoTimer.Enabled := True;

  //подпись пути в катагоге
  Main.UpdateCatalogCaption;
  Main.UpdateAllQuantsInfo(True, False);
end;

procedure TData.CatalogTableCalcFields(DataSet: TDataSet);
var
  quant : double;
  Price_pro_eur: Double;
  sKov, sSQL: string;
begin
  if not fDatabaseOpened then
    exit;
  with DataSet do
  begin
    if FieldByName('Limit').Value > 0 then
      FieldByName('LimitsCalc').AsString := FieldByName('Limit').AsString;
    // ([002].Code) as Code, ([002].Code2) as Code2,
    FieldByName('BrandDescrRepl').Value := ReBranding(FieldByName('BrandDescr').AsString); {ReBranding}
    if not FieldByName('Title').AsBoolean then
      FieldByName('BrandDescrView').Value := FieldByName('BrandDescrRepl').AsString;

    FieldByName('SaleQ').Value := FieldByName('saleQCalc').Value;

    if FieldByName('PriceQuantSklad').AsCurrency > 0 then
      FieldByName('PriceItog').AsCurrency := FieldByName('PriceQuantSklad').AsCurrency
    else if FieldByName('PriceQuant').AsCurrency > 0 then
      FieldByName('PriceItog').AsCurrency := FieldByName('PriceQuant').AsCurrency
    else
      FieldByName('PriceItog').AsCurrency := FieldByName('Price').AsCurrency;

    FieldByName('GroupInfo').Value := FieldByName('GroupDescr').AsString +
      iif(FieldByName('SubgroupDescr').AsString <> '', ' / ' +
          FieldByName('SubgroupDescr').AsString, '');
    if not FieldByName('Title').AsBoolean  then
    begin
      if FieldByName('CODE2').AsString = '' then
        exit;

    //***Конвертация в EUR***
      if (FieldByName('PriceQuantSklad').AsCurrency > 0) then
        FieldByName('PriceItog').AsCurrency :=
        XRoundCurr(
          FieldByName('PriceItog').AsCurrency / GetCurByCode(CurrSclad),
          ctEUR
        );

      if FieldByName('SaleQ').AsString <> '1' then
        FieldByName('Price_koef_eur').Value :=
           XRoundCurr(GetDiscount(FieldByName('Group_id').AsInteger ,FieldByName('Subgroup_id').AsInteger,FieldByName('Brand_id').AsInteger) *
                  FieldByName('PriceItog').AsCurrency, ctEUR)
      else
        FieldByName('Price_koef_eur').Value := FieldByName('PriceItog').AsCurrency;

    //***Не переводить в случае совпадения валюты***
      if (CurrSclad = GetCurrencyCode(Curr)) and (FieldByName('PriceQuantSklad').AsCurrency > 0) then
        FieldByName('Price_koef').Value :=
        XRoundCurr(
          GetDiscount(FieldByName('Group_id').AsInteger ,FieldByName('Subgroup_id').AsInteger,FieldByName('Brand_id').AsInteger) *
          FieldByName('PriceQuantSklad').AsCurrency,
          getTypeCur(CurrSclad)
        )
      else
        FieldByName('Price_koef').Value := XRoundCurr(Rate * FieldByName('Price_koef_eur').AsCurrency,Curr);

      FieldByName('Price_koef_usd').Value :=
          XRoundCurr(ParamTable.FieldByName('Eur_usd_rate').AsCurrency * FieldByName('Price_koef_eur').AsCurrency, ctUSD);

      FieldByName('Price_koef_rub').Value :=
          XRoundCurr(ParamTable.FieldByName('Eur_rate').AsCurrency * FieldByName('Price_koef_eur').AsCurrency, ctBYR);

      if (CurrSclad = GetCurrencyCode(Curr)) then
      begin
        Price_pro_eur := XRoundCurr(
          FieldByName('Price_koef').Value * GetMargin(FieldByName('Group_id').AsInteger, FieldByName('Subgroup_id').AsInteger, FieldByName('Brand_id').AsInteger),
          getTypeCur(CurrSclad)
        );
        FieldByName('Price_pro').Value := XRoundCurr( Price_pro_eur, Curr );
      end
      else
      begin
        Price_pro_eur := XRoundCurr(
          FieldByName('Price_koef_eur').Value * GetMargin(FieldByName('Group_id').AsInteger, FieldByName('Subgroup_id').AsInteger, FieldByName('Brand_id').AsInteger),
          ctEUR
        );
        FieldByName('Price_pro').Value := XRoundCurr( Price_pro_eur * Rate, Curr );
      end;

    end;
    XOrderDetTable2.SetRange([OrderTable.FieldByName('Order_id').AsInteger,
                              FieldByName('Code2').AsString,
                              FieldByName('BrandDescr').AsString],
                             [OrderTable.FieldByName('Order_id').AsInteger,
                              FieldByName('Code2').AsString,
                              FieldByName('BrandDescr').AsString]);
    with XOrderDetTable2 do
    begin
      First;
      quant := 0;
      while not Eof do
      begin
        quant := quant + FieldByName('Quantity').AsFloat;
        Next;
      end;
    end;
    FieldByName('OrdQuantity').Value := quant;
    if quant <> 0 then
      FieldByName('OrdQuantityStr').Value := CurrToStr(quant)
    else
      FieldByName('OrdQuantityStr').Value := '';
    FieldByName('Name_Descr').Value := Trim(FieldByName('Name').AsString + ' ' +
                                       FieldByname('Description').AsString);
    {ReBranding}
    if FieldByName('Title').AsBoolean then
      FieldByName('Name_Descr').AsString := ReBranding(FieldByName('Name_Descr').AsString); {ReBranding}

    //sklad
    if (sFieldGlobalName <> '') and (FieldByName('Code2').AsString <> '') then
    begin
        sKov := '''';
        sKov := ReplaceStr(FieldByName('BrandDescr').AsString,sKov,sKov+sKov);
        sSQL := 'SELECT SUM(Col) as CL FROM [52],[53] WHERE [52].STATE < 1  AND [52].SaleOrderID = [53].SaleOrderID';
        sSQL := sSQL +' AND Code = '''+ FieldByName('Code').AsString+''' AND BRAND = '''+sKov+'''';

        QueryStock.SQL.Clear;
        QueryStock.SQL.Add(sSQL);
        QueryStock.Active := TRUE;

        if QueryStock.Eof then
          FieldByName('Reserve').Value := 0
         else
         if QueryStock.FieldByName('CL').AsString = '' then
            FieldByName('Reserve').Value := 0
         else
            FieldByName('Reserve').Value := QueryStock.FieldByName('CL').AsInteger;



        QueryStock.Active := FALSE;
        if FieldByName('Reserve').AsInteger>0 then
           FieldByName('Basic').Value := FieldByName(sFieldGlobalName).AsString + '('+FieldByName('Reserve').AsString+')'
        else
           FieldByName('Basic').Value := FieldByName(sFieldGlobalName).AsString;
    end
    else
        FieldByName('Reserve').Value := 0;
  end;
end;

(*
procedure TData.BrandFieldGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if DisplayText then
    Text := ReBranding(Text); {ReBranding}
end;
*)
procedure TData.AnalogIDTableAfterRefresh(DataSet: TDataSet);
begin
  Main.RefreshMemAnalogs;
end;

procedure TData.AnalogMainTableCalcFields(DataSet: TDataSet);
{var
  quant: real;
begin
  with DataSet do
  begin
    FieldByName('An_brand_repl').AsString := ReBranding(FieldByName('An_brand').AsString);
   //TecDoc_id
    FieldByName('SaleQ').Value := FieldByName('saleQCalc').Value;

    if FieldByName('PriceQuant').AsCurrency > 0 then
       FieldByName('PriceItog').AsCurrency := FieldByName('PriceQuant').AsCurrency
    else
       FieldByName('PriceItog').AsCurrency := FieldByName('Price').AsCurrency;

    if FieldByName('SaleQ').AsString <> '1' then
      FieldByName('Price_koef_eur').Value :=
           XRoundCurr(GetDiscount(
                        FieldByName('An_group_id').AsInteger,
                        FieldByName('An_subgroup_id').AsInteger,
                        FieldByName('An_Brand_id').AsInteger
                      ) *
                  FieldByName('PriceItog').AsCurrency, ctEUR)
    else
      FieldByName('Price_koef_eur').Value := FieldByName('PriceItog').AsCurrency;

    FieldByName('Price_koef').Value :=
           XRoundCurr(Rate * FieldByName('Price_koef_eur').AsCurrency, Curr);
    FieldByName('Price_pro').Value :=
           XRoundCurr(GetMargin2(FieldByName('An_group_id').AsInteger, FieldByName('An_subgroup_id').AsInteger, FieldByName('An_Brand_id').AsInteger, FieldByName('Price_koef_eur').AsCurrency) * FieldByName('Price_koef').AsCurrency,
                  Curr);
    FieldByName('New').value := FieldByName('An_new').AsString;
    FieldByName('Sale').value := FieldByName('An_sale').AsString;
    FieldByName('Usa').value := FieldByName('An_usa').AsString;
    FieldByName('Name_Descr').value := FieldByName('Name').AsString + ' ' +
                                       FieldByName('Description').AsString;


    XOrderDetTable2.SetRange([OrderTable.FieldByName('Order_id').AsInteger,
                              MakeSearchCode(FieldByName('An_code').AsString),
                              FieldByName('An_brand').AsString],
                             [OrderTable.FieldByName('Order_id').AsInteger,
                              MakeSearchCode(FieldByName('An_code').AsString),
                              FieldByName('An_brand').AsString]);
    with XOrderDetTable2 do
    begin
      First;
      quant := 0;
      while not Eof do
      begin
        quant := quant + FieldByName('Quantity').AsFloat;
        Next;
      end;
    end;
    FieldByName('OrdQuantity').Value := quant;
    if quant <> 0 then
      FieldByName('OrdQuantityStr').Value := CurrToStr(quant)
    else
      FieldByName('OrdQuantityStr').Value := '';
  end;  }
  var
  quant: real;
  sKov, sSQL: string;
  Prices: TCalcPrices;
begin
  with DataSet do
  begin
    FieldByName('An_brand_repl').AsString := ReBranding(FieldByName('An_brand').AsString); {ReBranding}
   //TecDoc_id
    FieldByName('SaleQ').Value := FieldByName('saleQCalc').Value;
    Prices := CaclCurrency(FieldByName('Price').AsCurrency,FieldByName('PriceQuant').AsCurrency,FieldByName('PriceQuantSklad').AsCurrency,
                FieldByName('An_Group_id').AsInteger,FieldByName('An_SubGroup_id').AsInteger,FieldByName('An_Brand_id').AsInteger,
                FieldByName('SaleQ').AsString
              );
    FieldByName('PriceItog').AsCurrency := Prices.PriceItog;
    FieldByName('Price_koef_eur').Value := Prices.Price_koef_eur;
    FieldByName('Price_koef').Value := Prices.Price_koef; //catalogdatasource.dataset.FieldByName('Price_koef').asCurrency;
    FieldByName('Price_pro').Value := Prices.Price_Pro;
    FieldByName('New').value := FieldByName('An_new').AsString;
    FieldByName('Sale').value := FieldByName('An_sale').AsString;
    FieldByName('Usa').value := FieldByName('An_usa').AsString;
    FieldByName('Name_Descr').value := FieldByName('Name').AsString + ' ' +
                                       FieldByName('Description').AsString;


    XOrderDetTable2.SetRange([OrderTable.FieldByName('Order_id').AsInteger,
                              MakeSearchCode(FieldByName('An_code').AsString),
                              FieldByName('An_brand').AsString],
                             [OrderTable.FieldByName('Order_id').AsInteger,
                              MakeSearchCode(FieldByName('An_code').AsString),
                              FieldByName('An_brand').AsString]);
    with XOrderDetTable2 do
    begin
      First;
      quant := 0;
      while not Eof do
      begin
        quant := quant + FieldByName('Quantity').AsFloat;
        Next;
      end;
    end;
    FieldByName('OrdQuantity').Value := quant;
    if quant <> 0 then
      FieldByName('OrdQuantityStr').Value := CurrToStr(quant)
    else
      FieldByName('OrdQuantityStr').Value := '';


    //sklad
    if (length(sFieldGlobalName)>0)and(FieldByName('An_code').AsString <> '') then
    begin
      sKov := '''';
      sKov := ReplaceStr(FieldByName('An_brand').AsString,sKov,sKov+sKov);
      sSQL := 'SELECT SUM(Col) as CL FROM [52],[53] WHERE [52].STATE < 1  AND [52].SaleOrderID = [53].SaleOrderID';
      sSQL := sSQL +' AND Code = '''+ FieldByName('An_code').AsString+''' AND BRAND = '''+sKov+'''';

      QueryStock.SQL.Clear;
      QueryStock.SQL.Add(sSQL);
      QueryStock.Open;
      if QueryStock.Eof then
        FieldByName('Reserve').Value := 0
      else
        if QueryStock.FieldByName('CL').AsString = '' then
          FieldByName('Reserve').Value := 0
        else
          FieldByName('Reserve').Value := QueryStock.FieldByName('CL').AsInteger;
      QueryStock.Close;

      if FieldByName('Reserve').AsInteger>0 then
        FieldByName('Basic').Value := FieldByName(sFieldGlobalName).AsString + '('+FieldByName('Reserve').AsString+')'
      else
        FieldByName('Basic').Value := FieldByName(sFieldGlobalName).AsString;
    end
    else
      FieldByName('Reserve').Value := 0;
  end;
end;

procedure TData.AnalogMainTable_1CalcFields(DataSet: TDataSet);
begin
  AnalogMainTableCalcFields(DataSet);
end;

procedure TData.AnalogMainTable_2CalcFields(DataSet: TDataSet);
begin
  AnalogMainTableCalcFields(DataSet);
end;

procedure TData.AnalogMainTable_3CalcFields(DataSet: TDataSet);
begin
  AnalogMainTableCalcFields(DataSet);
end;

procedure TData.AnalogMainTable_4CalcFields(DataSet: TDataSet);
begin
  AnalogMainTableCalcFields(DataSet);
end;

procedure TData.AnalogMainTable_5CalcFields(DataSet: TDataSet);
begin
  AnalogMainTableCalcFields(DataSet);
end;

procedure TData.AnalogTableAfterRefresh(DataSet: TDataSet);
begin
//  Main.RefreshMemAnalogs;
end;

procedure TData.AnalogTableAfterScroll(DataSet: TDataSet);
begin
  Main.ShowStatusBarInfo2;
end;

procedure TData.AnalogTableCalcFields(DataSet: TDataSet);
var
  quant: real;
  sKov, sSQL: string;
  Prices: TCalcPrices;
begin
  exit; {в случае возврщанеия на старые аналоги вернуть лукапное поле PriceQuantSklad}

  with DataSet do
  begin
    FieldByName('An_brand_repl').AsString := ReBranding(FieldByName('An_brand').AsString); {ReBranding}
   //TecDoc_id
    FieldByName('SaleQ').Value := FieldByName('saleQCalc').Value;
    Prices := CaclCurrency(FieldByName('Price').AsCurrency,FieldByName('PriceQuant').AsCurrency,FieldByName('PriceQuantSklad').AsCurrency,
                FieldByName('An_Group_id').AsInteger,FieldByName('An_SubGroup_id').AsInteger,FieldByName('An_Brand_id').AsInteger,
                FieldByName('SaleQ').AsString
              );
    FieldByName('PriceItog').AsCurrency := Prices.PriceItog;
    FieldByName('Price_koef_eur').Value := Prices.Price_koef_eur;
    FieldByName('Price_koef').Value := Prices.Price_koef; //catalogdatasource.dataset.FieldByName('Price_koef').asCurrency;
    FieldByName('Price_pro').Value := Prices.Price_Pro;

    FieldByName('New').value := FieldByName('An_new').AsString;
    FieldByName('Sale').value := FieldByName('An_sale').AsString;
    FieldByName('Usa').value := FieldByName('An_usa').AsString;
    FieldByName('Name_Descr').value := FieldByName('Name').AsString + ' ' +
                                       FieldByName('Description').AsString;


    XOrderDetTable2.SetRange([OrderTable.FieldByName('Order_id').AsInteger,
                              MakeSearchCode(FieldByName('An_code').AsString),
                              FieldByName('An_brand').AsString],
                             [OrderTable.FieldByName('Order_id').AsInteger,
                              MakeSearchCode(FieldByName('An_code').AsString),
                              FieldByName('An_brand').AsString]);
    with XOrderDetTable2 do
    begin
      First;
      quant := 0;
      while not Eof do
      begin
        quant := quant + FieldByName('Quantity').AsFloat;
        Next;
      end;
    end;
    FieldByName('OrdQuantity').Value := quant;
    if quant <> 0 then
      FieldByName('OrdQuantityStr').Value := CurrToStr(quant)
    else
      FieldByName('OrdQuantityStr').Value := '';


    //sklad
    if (length(sFieldGlobalName)>0)and(FieldByName('An_code').AsString <> '') then
    begin
      sKov := '''';
      sKov := ReplaceStr(FieldByName('An_brand').AsString,sKov,sKov+sKov);
      sSQL := 'SELECT SUM(Col) as CL FROM [52],[53] WHERE [52].STATE < 1  AND [52].SaleOrderID = [53].SaleOrderID';
      sSQL := sSQL +' AND Code = '''+ FieldByName('An_code').AsString+''' AND BRAND = '''+sKov+'''';

      QueryStock.SQL.Clear;
      QueryStock.SQL.Add(sSQL);
      QueryStock.Open;
      if QueryStock.Eof then
        FieldByName('Reserve').Value := 0
      else
        if QueryStock.FieldByName('CL').AsString = '' then
          FieldByName('Reserve').Value := 0
        else
          FieldByName('Reserve').Value := QueryStock.FieldByName('CL').AsInteger;
      QueryStock.Close;

      if FieldByName('Reserve').AsInteger>0 then
        FieldByName('Basic').Value := FieldByName(sFieldGlobalName).AsString + '('+FieldByName('Reserve').AsString+')'
      else
        FieldByName('Basic').Value := FieldByName(sFieldGlobalName).AsString;
    end
    else
      FieldByName('Reserve').Value := 0;
  end;
end;


procedure TData.AssortmentExpansionCalcFields(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('BrandRepl').AsString := ReBranding(FieldByName('Brand').AsString); {ReBranding}
    if BrandTable.Locate('Description', FieldByName('Brand').AsString, []) and
       XCatTable.FindKey([FieldByName('Code2').AsString,
                          BrandTable.FieldByName('Brand_id').AsInteger]) then
    begin
      FieldByname('Cat_Id').Value := XCatTable.FieldByName('Cat_Id').AsInteger;
      FieldByname('Price').Value := XCatTable.FieldByName('PriceItog').AsFloat;
      if XCatTable.FieldByName('SaleQ').AsString = '1' then
        FieldByname('ArtSale').Value := XCatTable.FieldByName('SaleQ').AsInteger
      else
        FieldByname('ArtSale').Value := 0;

      FieldByname('ArtBrandId').AsInteger := XCatTable.FieldByName('Brand_id').AsInteger;
      FieldByName('ArtGroupId').AsInteger := XCatTable.FieldByName('Group_id').AsInteger;
      FieldByName('ArtSubgroupId').AsInteger := XCatTable.FieldByName('Subgroup_id').AsInteger;

      if QuantTable.FindKey([XCatTable.FieldByName('Cat_id').AsInteger]) then
        FieldByName('ArtQuant').Value := QuantTable.FieldByName('Quantity').AsString;

      if FieldByName('ArtSale').AsString <> '1' then
        FieldByName('Price_koef_eur').Value :=
          XRoundCurr(
            GetDiscount(
              FieldByName('ArtGroupId').AsInteger,
              FieldByName('ArtSubgroupId').AsInteger,
              FieldByName('ArtBrandId').AsInteger
            ) * FieldByName('Price').AsCurrency, ctEUR
          )
      else
        FieldByName('Price_koef_eur').Value := FieldByName('Price').AsCurrency;

      FieldByName('Price_koef').Value :=
        XRoundCurr(Rate * FieldByName('Price_koef_eur').AsCurrency, Curr);
      FieldByName('NameDescr').Value := Trim(XCatTable.FieldByName('Name').AsString + ' ' +
                                             XCatTable.FieldByName('Description').AsString);
    end;
  end;
end;

procedure ModStructMess(const s: string);
begin
  if Assigned(Splash) then
    Splash.InfoLabel.Caption := 'Преобразование формата БД...';
end;


procedure ReindexMess(const s: string);
begin
  if Assigned(Splash) then
    Splash.InfoLabel.Caption := 'Переиндексация БД...';
end;

function TData.GrDiscount(id: integer): real;
begin
  if GroupTable.FindKey([id, 1]) then
    Result := GroupTable.fieldByName('Discount').AsFloat
  else
    Result := 0;
end;


function TData.BrDiscount(id: integer): real;
begin
  if BrandTable.FindKey([id]) then
    Result := BrandTable.fieldByName('Discount').AsFloat
  else
    Result := 0;
end;

function TData.LoadPrimen2(aLimit: Integer): Boolean;
var
  s: string;
  sl: TStrings;
  aCatTypId: Integer;
begin
  Result := False;
  PrimenTable.DisableControls;
  PrimenTable.AfterScroll := nil;
  try

    with PrimenTable do
    begin
      Close;
      EmptyTable;
      Open;
    end;

    if CatalogDataSource.DataSet.FieldByName('typ_tdid').AsInteger = 0 then
      Exit;

    aCatTypId := CatalogDataSource.DataSet.FieldByName('typ_tdid').AsInteger;

    if ArtTypTable.IndexName <> 'Art' then
      ArtTypTable.IndexName := 'Art';
    ArtTypTable.SetRange([aCatTypId], [aCatTypId]);
    ArtTypTable.First;
    while not ArtTypTable.Eof do
    begin
      if TypesTable.Locate('Typ_id', ArtTypTable.FieldByName('Typ_id').AsInteger, []) then
        if not TypesTable.FieldByName('MfaHide').AsBoolean then
        begin
          PrimenTable.Append;
          PrimenTable.FieldByName('Typ_id').Value := TypesTable.FieldByName('Typ_id').AsInteger;
          PrimenTable.FieldByName('Description').Value := TypesTable.FieldByName('TypeDescr').AsString;
          PrimenTable.FieldByName('Pcon').Value := TypesTable.FieldByName('PconText1').AsString + '-' + TypesTable.FieldByName('PconText2').AsString;
          PrimenTable.FieldByName('Hp').Value := TypesTable.FieldByName('Hp_from').AsInteger;
          PrimenTable.FieldByName('Cylinders').Value := TypesTable.FieldByName('Cylinders').AsInteger;
          PrimenTable.FieldByName('Fuel').Value := TypesTable.FieldByName('FuelText').AsString;
          PrimenTable.FieldByName('Eng_codes').Value := TypesTable.FieldByName('Eng_codes').AsString;
          PrimenTable.Post;

          if aLimit <> -1 then
            if PrimenTable.RecordCount = aLimit then
            begin
              Result := True;
              Break;
            end;
        end;

      ArtTypTable.Next;
    end;

    with PrimenTable do
    begin
      if Auto_type <> 0 then
      begin
        if not Locate('Typ_Id', Auto_type, []) then
        begin
          if TypesTable.Locate('Typ_id', Auto_type, []) then
            if not TypesTable.FieldByName('MfaHide').AsBoolean then
            begin
              PrimenTable.Append;
              PrimenTable.FieldByName('Typ_id').Value := TypesTable.FieldByName('Typ_id').AsInteger;
              PrimenTable.FieldByName('Description').Value := TypesTable.FieldByName('TypeDescr').AsString;
              PrimenTable.FieldByName('Pcon').Value := TypesTable.FieldByName('PconText1').AsString + '-' + TypesTable.FieldByName('PconText2').AsString;
              PrimenTable.FieldByName('Hp').Value := TypesTable.FieldByName('Hp_from').AsInteger;
              PrimenTable.FieldByName('Cylinders').Value := TypesTable.FieldByName('Cylinders').AsInteger;
              PrimenTable.FieldByName('Fuel').Value := TypesTable.FieldByName('FuelText').AsString;
              PrimenTable.FieldByName('Eng_codes').Value := TypesTable.FieldByName('Eng_codes').AsString;
              PrimenTable.Post;
            end;
          Locate('Typ_Id', Auto_type, []);
        end;
      end
      else
        First;
    end;
    PrimenTable.IndexName := 'Descr';

  finally
    PrimenTable.AfterScroll := PrimenTableAfterScroll;
    PrimenTableAfterScroll(PrimenTable);
    Main.ParamTypGrid.Datasource := CatTypDetDataSource;
    PrimenTable.EnableControls;
  end;
end;

procedure TData.GetCatIDsForCar(aTypeId: Integer; anIDs: TStrings);
var
  aQuery: TDBISAMQuery;
  s: string;
  anArtId: Integer;
  sl: TStrings;
begin
  anIDs.Clear;

  if aTypeId = 0 then
    Exit;

  if not TypesTable.Locate('Typ_id', aTypeId, []) then
    Exit;

  if TypesTable.FieldByName('MfaHide').AsBoolean then
    Exit;

  aQuery := TDBISAMQuery.Create(nil);
  try
    aQuery.DatabaseName := Database.DatabaseName;

    aQuery.SQL.Text := 'SELECT art_id FROM [023] WHERE typ_id = ' + IntToStr(aTypeId);
    aQuery.Open;
    while not aQuery.Eof do
    begin
      anIDs.Add(aQuery.Fields[0].AsString);
      aQuery.Next;
    end;
    aQuery.Close;
    Exit; //---------------------->

    LoadArtTypTableAuto.Open;
    if LoadArtTypTableAuto.IndexName <> 'Typ' then
      LoadArtTypTableAuto.IndexName := 'Typ';
    LoadArtTypTableAuto.SetRange([aTypeId], [aTypeId]);
    LoadArtTypTableAuto.First;
    //LoadArtTypTableAuto.Locate('Typ_id', aTypeId, []);
    sl := TStringList.Create;
    while not LoadArtTypTableAuto.Eof do
    begin
     // if LoadArtTypTableAuto.FieldByName('Typ_id').AsInteger <> aTypeId then
       // Break;
     // sl.Add(LoadArtTypTableAuto.FieldByName('Art_id').AsString);
{      anArtId := LoadArtTypTableAuto.FieldByName('Art_id').AsInteger;

      LoadCatTable.SetRange([anArtId], [anArtId]);
      LoadCatTable.First;
      while not LoadCatTable.Eof do
      begin
        anIDs.Add(LoadCatTable.FieldByName('CAT_ID').AsString);
        LoadCatTable.Next;
      end;
}
{      aQuery.SQL.Text := 'SELECT CAT_ID FROM [002] WHERE typ_tdid = ' + IntToStr(anArtId);
      aQuery.Open;
      while not aQuery.Eof do
      begin
        anIDs.Add(aQuery.Fields[0].AsString);
        aQuery.Next;
      end;
      aQuery.Close;
}

      LoadArtTypTableAuto.Next;
    end;
    anIDs.Assign(sl);
    {
    if sl.Count > 0 then
    begin
      aQuery.SQL.Text := 'SELECT CAT_ID FROM [002] WHERE typ_tdid IN (' + sl.CommaText + ')';
      aQuery.Open;
      while not aQuery.Eof do
      begin
        anIDs.Add(aQuery.Fields[0].AsString);
        aQuery.Next;
      end;
      aQuery.Close;
    end;
    sl.Free;
    }
    LoadArtTypTableAuto.Close;
  finally
    aQuery.Free;
  end;
end;

function TData.GetDiscount(gr,subgr,br: integer; bStrictConformity:bool = FALSE): real;
var sFilter:string;
begin
  {
   if BrDiscount(br) <> 0 then
    Result := 1 - BrDiscount(br) / 100
  else
    Result := Discount_koef;
  }

  if bStrictConformity then
    sFilter := 'GR_ID = '+inttostr(gr)+' AND SUBGR_ID = '+inttostr(subgr)+ ' AND BRAND_ID = '+inttostr(br)
  else
    sFilter := '(GR_ID = 0 OR GR_ID = '+inttostr(gr)+') AND (SUBGR_ID = 0 OR SUBGR_ID = '+inttostr(subgr)+ ') AND (BRAND_ID = 0 OR BRAND_ID = '+inttostr(br)+')';

  with DiscountTable do
  begin
     if IndexName <> 'CLI' then
     begin
       IndexName := 'CLI';
       Filtered := FALSE;
     end;

     if Filtered then
     begin
        if sFilter <> Filter then
        begin
          Filter := sFilter;
          Filtered := TRUE;
        end;
     end
     else
     begin
        Filter := sFilter;
        Filtered := TRUE;
     end;

     GetDiscount := 1;
     First;
     while not Eof do
     begin
       if FieldByName('Discount').AsFloat <> 0 then
       begin
         GetDiscount := 1 - FieldByName('Discount').AsFloat / 100;
         Break;
       end;
       Next;
     end;
  end;
end;

function  TData.GetMargin(gr,subgr,br: integer; bStrictConformity:bool = FALSE): real;
var sFilter:string;
begin
  if bStrictConformity then
    sFilter := 'GR_ID = '+inttostr(gr)+' AND SUBGR_ID = '+inttostr(subgr)+ ' AND BRAND_ID = '+inttostr(br)
  else
    sFilter := '(GR_ID = 0 OR GR_ID = '+inttostr(gr)+') AND (SUBGR_ID = 0 OR SUBGR_ID = '+inttostr(subgr)+ ') AND (BRAND_ID = 0 OR BRAND_ID = '+inttostr(br)+')';

  with DiscountTable do
  begin
     if Filtered then
     begin
        if sFilter <> Filter then
        begin
          Filter := sFilter;
          Filtered := TRUE;
        end;
     end
     else
     begin
        Filter := sFilter;
        Filtered := TRUE;
     end;

     GetMargin := 1;
     First;
     while not Eof do
     begin
       if FieldByName('Margin').AsFloat <> 0 then
       begin
         GetMargin := 1 + FieldByName('Margin').AsFloat / 100;
         Break;
       end;
       Next;
     end;
  end;
end;

function TData.GetMargin2(gr, subgr, br: Integer; aPriceClient: Currency): Real;
begin
  if gMarginModeDiff then
    Result := GetMarginDiff(aPriceClient)
  else
    Result := GetMargin(gr, subgr, br);
end;

function TData.GetMarginDiff(aPriceClient: Currency): Double;
begin
  Result := 1;

  if not memProfit.Active then
    memProfit.Open;

  memProfit.First;
  while not memProfit.Eof do
  begin
    if aPriceClient >= memProfit.FieldByName('PriceFrom').AsCurrency then
      if (aPriceClient < memProfit.FieldByName('PriceTo').AsCurrency) or (memProfit.FieldByName('PriceTo').AsString = '') then
      begin
        Result := 1 + memProfit.FieldByName('Profit').AsFloat / 100;
        Exit;
      end;
    memProfit.Next;
  end;
end;


function TData.GetQuantsNumber: string;
begin
  Result := '';
  if TableBases.Locate('Basic','1',[]) then
  begin
    Result := TableBases.FieldByName('Code').AsString;
    CurrSclad := TableBases.FieldByName('Currency').AsString;
    if CurrSclad = '' then
      CurrSclad := 'EUR';
  end;
end;

function TData.GetQuantsTableByNum(const QuantsNum: integer): TDBISAMTable;
begin
  case QuantsNum of
    10: Result := QuantTable10;//Лошица
    2: Result := QuantTable2;//Малиновка 7
    3: Result := QuantTable3;
    4: Result := QuantTable4;
    5: Result := QuantTable5;
    6: Result := QuantTable6;
    7: Result := QuantTable7;
    8: Result := QuantTable8;
    9: Result := QuantTable9;
   11: Result := QuantTable11;
   12: Result := QuantTable12;
   13: Result := QuantTable13;
   14: Result := QuantTable14;
   16: Result := QuantTable16;
   17: Result := QuantTable17;
   18: Result := QuantTable18;
   20: Result := QuantTable20;
   21: Result := QuantTable21;
   22: Result := QuantTable22;
  end;
end;

procedure TData.ExportTable(tbl: TDBISAMTable; fname, info: string; flds: string = '');
var
  fld_list: TStringList;
  i: integer;
  s: string;
begin
  StartWait;
  fld_list := TStringList.Create;
  tbl.OnExportProgress := TableExpImpProgress;
  Main.ShowProgress(info);
  if flds <> '' then
  begin
    i := 1;
    while True do
    begin
      s := ExtractDelimited(i,  flds, [';']);
      if s = '' then
        break;
      fld_list.Add(s);
      Inc(i);
    end;
    tbl.ExportTable(fname, ';', False, fld_list);
  end
  else
    tbl.ExportTable(fname, ';');
  Main.HideProgress;
  tbl.OnExportProgress := nil;
  fld_list.Free;
  StopWait;
end;


procedure TData.FilterResultAfterScroll(DataSet: TDataSet);
begin
   Main.LoadTDInfoTimer.Enabled := False;
   Main.LoadTDInfoTimer.Enabled := True;
end;

procedure TData.FilterResultCalcFields(DataSet: TDataSet);
var
  quant: real;
begin
  with DataSet do
  begin
     if not FieldByName('Title').AsBoolean  then
    begin
   {   if CatFilterTable.FindKey([FieldByName('Cat_id').AsInteger]) then
      begin
         FieldByName('Code').AsString := CatFilterTable.FieldByName('Code').AsString;
         FieldByName('Code2').AsString := CatFilterTable.FieldByName('Code2').AsString;
      end;}

{      if FieldByName('PriceQuant').AsCurrency > 0 then
         FieldByName('PriceItog').AsCurrency := FieldByName('PriceQuant').AsCurrency
      else
         FieldByName('PriceItog').AsCurrency := FieldByName('Price').AsCurrency;

      if FieldByName('SaleQ').AsString <> '1' then
        FieldByName('Price_koef_eur').Value :=
           XRound(GetDiscount(FieldByName('Brand_id').AsInteger) *
                  FieldByName('PriceItog').AsCurrency, 2)
      else
        FieldByName('Price_koef_eur').Value := FieldByName('PriceItog').AsCurrency;
        
      FieldByName('Price_koef').Value :=
           XRound(Rate * FieldByName('Price_koef_eur').AsCurrency,
                  iif(Curr = 2, -1, 2));
      FieldByName('Price_pro').Value :=
           XRound(Profit_koef * FieldByName('Price_koef').AsCurrency,
                  iif(Curr = 2, -1, 2));

      XOrderDetTable2.SetRange([OrderTable.FieldByName('Order_id').AsInteger,
                              FieldByName('Code2').AsString,
                              FieldByName('BrandDescr').AsString],
                             [OrderTable.FieldByName('Order_id').AsInteger,
                              FieldByName('Code2').AsString,
                              FieldByName('BrandDescr').AsString]);

      with XOrderDetTable2 do
      begin
        First;
        quant := 0;
          while not Eof do
            begin
            quant := quant + FieldByName('Quantity').AsFloat;
            Next;
            end;
      end;

      if quant <> 0 then
        FieldByName('OrdQuantityStr').Value := CurrToStr(quant)
      else
        FieldByName('OrdQuantityStr').Value := '';
   }
    end;

  end;
end;

procedure TData.TableDocLimitAfterScroll(DataSet: TDataSet);
var
  aEnabled: Boolean;
begin
  aEnabled := DataSet.FieldByName('State').AsInteger = 0;
  Main.DocLimitDelAction.Enabled := aEnabled;
  Main.UnlockDocLimitAction.Visible := not aEnabled;
end;

procedure TData.TableExpImpProgress(Sender: TObject; PercentDone: Word);
begin
  Main.CurrProgress(PercentDone);
end;

procedure TData.TableReturnDocAfterScroll(DataSet: TDataSet);
var
  aEnabled: Boolean;
begin
  aEnabled := DataSet.FieldByName('State').AsInteger = 0;
  Main.EditSaleReturnDoc.Enabled := aEnabled;
  Main.DelSaleReturnDoc.Enabled := aEnabled;
  Main.UnlockSaleReturnDoc.Visible := not aEnabled;
end;

procedure TData.TableReturnDocCalcFields(DataSet: TDataSet);
var
  sum: Currency;
begin
  sum := 0;
  with xReturnDoc do
  begin
    SetRange([DataSet.FieldByName('ReturnDocId').AsInteger],
             [DataSet.FieldByName('ReturnDocId').AsInteger]);
    First;
    while not Eof do
    begin
      sum := sum +  XRoundCurr(FieldByName('Price').AsCurrency*FieldByName('Col').AsInteger, Curr);
      Next;
    end;
    DataSet.FieldByName('Summ').Value:= sum;
  end;
end;

procedure TData.TableSaleOrderAfterScroll(DataSet: TDataSet);
var
  aEnabled: Boolean;
begin
  aEnabled := DataSet.FieldByName('State').AsInteger = 0;
  Main.EditSaleOrder.Enabled := aEnabled;
  Main.DelSaleOrder.Enabled := aEnabled;
  Main.UnlockSaleOrder.Visible := not aEnabled;
end;

procedure TData.TableSaleOrderCalcFields(DataSet: TDataSet);
var
  sum: Currency;
begin
  sum := 0;
  with xSaleOrderDet do
  begin
    SetRange([DataSet.FieldByName('SaleOrderID').AsInteger],
             [DataSet.FieldByName('SaleOrderID').AsInteger]);
    First;
    while not Eof do
    begin
      if FieldByName('Price').AsString <> '' then
        sum := sum +  XRoundCurr(Main.AtoCurr(FieldByName('Price').AsString) * FieldByName('Col').AsInteger, Curr);
      Next;
    end;

    DataSet.FieldByName('Summ').Value := sum;
  end;
end;

procedure TData.TableSaleOrderDetCalcFields(DataSet: TDataSet);
begin
  with Dataset do
  begin
    if FieldByName('Price').AsString <> '' then
      FieldByName('Summ').Value := XRoundCurr(FieldByName('Col').AsInteger * Main.AToCurr(FieldByName('Price').AsString), Curr)
    else
      FieldByName('Summ').Value := 0;
  end;
end;

procedure TData.ImportTable(tbl: TDBISAMTable; fname, info: string; flds: string = '');
var
  fld_list: TStringList;
  i: integer;
  s: string;
begin
  StartWait;
  tbl.OnImportProgress := TableExpImpProgress;
  Main.ShowProgress(info);
  tbl.EmptyTable;
  fld_list := TStringList.Create;
  try
    //exception raised when tbl.ImportTable try process empty file
    if GetFileSize_Internal(fname) = 0 then
      Exit;

    if flds <> '' then
    begin
      i := 1;
      while True do
      begin
        s := ExtractDelimited(i,  flds, [';']);
        if s = '' then
          Break;
        fld_list.Add(s);
        Inc(i);
      end;
      tbl.ImportTable(fname, ';', False, fld_list);
    end
    else
      tbl.ImportTable(fname, ';');

  finally
    fld_list.Free;
    Main.HideProgress;
    tbl.OnImportProgress := nil;
    StopWait;
  end;
end;


procedure TData.KitTableCalcFields(DataSet: TDataSet);
var
  aPriceEUR: Currency;
begin
  if not XCatTable.Active then
    Exit;

  if (DataSet.FieldByName('CHILD_ID').AsInteger > 0) and (XCatTable.Locate('CAT_ID', Dataset.FieldByName('CHILD_ID').AsInteger, [])) then
    with DataSet do
    begin
      //Описание
      FieldByName('Descr').AsString := XCatTable.FieldByName('Name_Descr').AsString;

      FieldByName('Price_koef').AsCurrency := XCatTable.FieldByName('PriceItog').AsCurrency;
      //сумма в тек валюте со скидкой (с учетом кол-ва в комплекте)
      FieldByName('Price_koef_sum').AsCurrency := FieldByName('Price_koef').AsCurrency * FieldByName('QUANTITY').AsInteger;

      //цена в тек валюте с наценкой
      FieldByName('PriceProEur').AsCurrency := XRoundCurr(XCatTable.FieldByName('PriceItog').AsCurrency * GetMargin(XCatTable.FieldByName('Group_id').AsInteger
                                    ,XCatTable.FieldByName('SubGroup_id').AsInteger
                                    ,XCatTable.FieldByName('Brand_id').AsInteger),
                                    Curr);
      FieldByName('PriceProEur_sum').asCurrency := FieldByName('PriceProEur').asCurrency * FieldByName('QUANTITY').AsInteger;

      //цена в евро со скидкой
{      if XCatTable.FieldByName('SaleQ').AsString <> '1' then
        aPriceEUR :=
          XRoundCurr(GetDiscount(XCatTable.FieldByName('Group_id').AsInteger, XCatTable.FieldByName('Subgroup_id').AsInteger, XCatTable.FieldByName('Brand_id').AsInteger) *
                     XCatTable.FieldByName('PriceItog').AsCurrency, ctEUR)
        else
          aPriceEUR := XCatTable.FieldByName('PriceItog').AsCurrency;

      //цена в Евро со скидкой
      FieldByName('Price_koef_eur').AsCurrency := aPriceEUR;

      //цена в тек валюте со скидкой
      FieldByName('Price_koef').AsCurrency := XRoundCurr(Rate * aPriceEUR, Curr);

      //сумма в тек валюте со скидкой (с учетом кол-ва в комплекте)
      FieldByName('Price_koef_sum').AsCurrency := FieldByName('Price_koef').AsCurrency * FieldByName('QUANTITY').AsInteger;
      }
      if QuantTable.FindKey([XCatTable.FieldByName('Cat_id').AsInteger]) then
        FieldByName('Quant_cat').Value := QuantTable.FieldByName('Quantity').AsString;
      {
      //цена в Евро с наценкой
      FieldByName('PriceEur').AsCurrency := aPriceEUR * GetMargin2(xCatTable.FieldByName('Group_id').AsInteger, xCatTable.FieldByName('Subgroup_id').AsInteger, xCatTable.FieldByName('Brand_id').AsInteger, aPriceEUR);
      //цена в тек валюте с наценкой
      FieldByName('PriceProEur').AsCurrency := XRoundCurr(Rate * FieldByName('PriceEur').AsCurrency, Curr);
      //сумма в тек валюте с наценкой
      FieldByName('PriceProEur_sum').asCurrency :=  FieldByName('PriceProEur').asCurrency * FieldByName('QUANTITY').AsInteger;
    }
    end;
end;

procedure TData.KKCalcFields(DataSet: TDataSet);
var
  Price_pro_eur: Currency;
begin
  with DataSet do
  begin
    if BrandTable.Locate('Description', FieldByName('Brand').AsString, []) and
      XCatTable.FindKey([FieldByName('Code2').AsString,
                            BrandTable.FieldByName('Brand_id').AsInteger]) then
    begin
      FieldByName('Cat_Id').AsInteger := XCatTable.FieldByName('Cat_Id').AsInteger;
      FieldByName('Brand_Id').AsInteger := XCatTable.FieldByName('Brand_Id').AsInteger;
      FieldByName('Group_Id').AsInteger := XCatTable.FieldByName('Group_Id').AsInteger;
      FieldByName('SubGroup_Id').AsInteger := XCatTable.FieldByName('SubGroup_Id').AsInteger;

      FieldByName('Code').AsString := XCatTable.FieldByName('Code').AsString;
      FieldByName('Descr').AsString := XCatTable.FieldByName('Name_Descr').AsString;

      //цена в евро со скидкой
    {  if XCatTable.FieldByName('SaleQ').AsString <> '1' then
        FieldByName('Price').Value :=
           XRoundCurr(GetDiscount(XCatTable.FieldByName('Group_id').AsInteger, XCatTable.FieldByName('Subgroup_id').AsInteger, XCatTable.FieldByName('Brand_id').AsInteger) *
                      XCatTable.FieldByName('PriceItog').AsCurrency, ctEUR)
      else
        FieldByName('Price').Value := XCatTable.FieldByName('PriceItog').AsCurrency;

      //цена в тек валюте со скидкой
      FieldByName('Price_koef').Value :=
           XRoundCurr(Rate * FieldByName('Price').AsCurrency, Curr);

      //цена в евро с наценкой
      Price_pro_eur := XRoundCurr(
        FieldByName('Price').Value * GetMargin(XCatTable.FieldByName('Group_id').AsInteger, XCatTable.FieldByName('Subgroup_id').AsInteger, XCatTable.FieldByName('Brand_id').AsInteger),
        ctEUR
      );

      //цена в тек валюте с наценкой
      FieldByName('Price_pro').Value := XRoundCurr( Price_pro_eur * Rate, Curr );       }
        FieldByName('Price_pro').Value := XRoundCurr(XCatTable.FieldByName('PriceItog').AsCurrency * GetMargin(XCatTable.FieldByName('Group_id').AsInteger
                                    ,XCatTable.FieldByName('SubGroup_id').AsInteger
                                    ,XCatTable.FieldByName('Brand_id').AsInteger),
                                    Curr);

      FieldByName('BrandDescrRepl').Value := ReBranding(FieldByName('Brand').AsString);
    end
    else
      FieldByName('Descr').AsString := '!Позиция не найдена';
  end;
end;

function TData.CatFieldsForExport: string;
var
  i: integer;
  s: string;
begin
  s := '';
  with CatalogTable do
  for i := 0 to Fields.Count - 1 do
  begin
    if (Fields[i].FieldKind = fkData) and (Fields[i].FieldName <> 'Oem') and
                                          (Fields[i].FieldName <> 'Analogs') then
      s := s + Fields[i].FieldName + ';';
  end;
  Result := s;
end;

procedure TData.CatFilterTableCalcFields(DataSet: TDataSet);
var
  quant: real;
  sKov, sSQL: string;
  Prices: TCalcPrices;
begin
  if not fDatabaseOpened then
    exit;
  with DataSet do
  begin
    if FieldByName('Limit').Value > 0 then
      FieldByName('LimitsCalc').AsString := FieldByName('Limit').AsString;
    // ([002].Code) as Code, ([002].Code2) as Code2,
    if CatalogTable.IndexName <> '' then
      CatalogTable.IndexName := '';

    if CatalogTable.FindKey([FieldByName('Cat_id').AsInteger]) then
    begin
      // FieldByName('Primen').Value := CatalogTable.FieldByName('Primen').Value;
      FieldByName('Description').Value := CatalogTable.FieldByName('Description').Value;
      FieldByName('Name').Value := CatalogTable.FieldByName('Name').Value;
      FieldByName('Price').Value := CatalogTable.FieldByName('Price').Value;
      FieldByName('Mult').Value := CatalogTable.FieldByName('Mult').Value;
      FieldByName('Tecdoc_id').Value := CatalogTable.FieldByName('Tecdoc_id').Value;
      FieldByName('IDouble').Value := CatalogTable.FieldByName('IDouble').Value;

      //[pict, typ, param]
      FieldByName('pict_id').Value := CatalogTable.FieldByName('pict_id').Value;
      //FieldByName('typ_tdid').Value := CatalogTable.FieldByName('typ_tdid').Value;
      FieldByName('param_tdid').Value := CatalogTable.FieldByName('param_tdid').Value;
    end;

    FieldByName('BrandDescrRepl').Value := ReBranding(FieldByName('BrandDescr').AsString); {ReBranding}
    if not FieldByName('Title').AsBoolean then
      FieldByName('BrandDescrView').Value := FieldByName('BrandDescrRepl').AsString;

    FieldByName('SaleQ').Value := FieldByName('saleQCalc').Value;

    Prices := CaclCurrency(FieldByName('Price').AsCurrency,FieldByName('PriceQuant').AsCurrency,FieldByName('PriceQuantSklad').AsCurrency,
                           FieldByName('Group_id').AsInteger,FieldByName('SubGroup_id').AsInteger,FieldByName('Brand_id').AsInteger,
                           FieldByName('SaleQ').AsString);
    FieldByName('PriceItog').AsCurrency := Prices.PriceItog;

    FieldByName('GroupInfo').Value := FieldByName('GroupDescr').AsString +
      iif(FieldByName('SubgroupDescr').AsString <> '', ' / ' +
          FieldByName('SubgroupDescr').AsString, '');
    if not FieldByName('Title').AsBoolean  then
    begin
      FieldByName('Price_koef').Value := Prices.Price_koef;
      FieldByName('Price_koef_eur').Value := Prices.Price_koef_eur;
      FieldByName('Price_koef_usd').Value := Prices.Price_koef_usd;
      FieldByName('Price_koef_rub').Value := Prices.Price_koef_rub;
      FieldByName('Price_pro').Value :=  Prices.Price_pro;
    end;
{    if FieldByName('PriceQuant').AsCurrency > 0 then
       FieldByName('PriceItog').AsCurrency := FieldByName('PriceQuant').AsCurrency
    else
       FieldByName('PriceItog').AsCurrency := FieldByName('Price').AsCurrency;

    FieldByName('GroupInfo').Value := FieldByName('GroupDescr').AsString +
      iif(FieldByName('SubgroupDescr').AsString <> '', ' / ' +
          FieldByName('SubgroupDescr').AsString, '');
    if not FieldByName('Title').AsBoolean  then
    begin
      if FieldByName('SaleQ').AsString <> '1' then
        FieldByName('Price_koef_eur').Value :=
           XRoundCurr(GetDiscount(FieldByName('Group_id').AsInteger  ,FieldByName('Subgroup_id').AsInteger,FieldByName('Brand_id').AsInteger) *
                  FieldByName('PriceItog').AsCurrency, ctEUR)
      else
        FieldByName('Price_koef_eur').Value := FieldByName('PriceItog').AsCurrency;
      FieldByName('Price_koef').Value :=
           XRoundCurr(Rate * FieldByName('Price_koef_eur').AsCurrency,
                  Curr);

       FieldByName('Price_koef_usd').Value :=
           XRoundCurr(ParamTable.FieldByName('Eur_usd_rate').AsCurrency * FieldByName('Price_koef_eur').AsCurrency, ctUSD);

       FieldByName('Price_koef_rub').Value :=
           XRoundCurr(ParamTable.FieldByName('Eur_rate').AsCurrency * FieldByName('Price_koef_eur').AsCurrency, ctBYR);

      FieldByName('Price_pro').Value :=
           XRoundCurr(GetMargin(FieldByName('group_id').AsInteger, FieldByName('subgroup_id').AsInteger, FieldByName('brand_id').AsInteger) * FieldByName('Price_koef').AsCurrency,
                  Curr);

    end;}
    XOrderDetTable2.SetRange([OrderTable.FieldByName('Order_id').AsInteger,
                              FieldByName('Code2').AsString,
                              FieldByName('BrandDescr').AsString],
                             [OrderTable.FieldByName('Order_id').AsInteger,
                              FieldByName('Code2').AsString,
                              FieldByName('BrandDescr').AsString]);
    with XOrderDetTable2 do
    begin
      First;
      quant := 0;
      while not Eof do
      begin
        quant := quant + FieldByName('Quantity').AsFloat;
        Next;
      end;
    end;
    FieldByName('OrdQuantity').Value := quant;
    if quant <> 0 then
      FieldByName('OrdQuantityStr').Value := CurrToStr(quant)
    else
      FieldByName('OrdQuantityStr').Value := '';
    FieldByName('Name_Descr').Value := Trim(FieldByName('Name').AsString + ' ' +
                                       FieldByname('Description').AsString);
    {ReBranding}
    if FieldByName('Title').AsBoolean then
      FieldByName('Name_Descr').AsString := ReBranding(FieldByName('Name_Descr').AsString); {ReBranding}

    //sklad
    if (sFieldGlobalName <> '') and (FieldByName('Code2').AsString <> '') then
    begin
        sKov := '''';
        sKov := ReplaceStr(FieldByName('BrandDescr').AsString,sKov,sKov+sKov);
        sSQL := 'SELECT SUM(Col) as CL FROM [52],[53] WHERE [52].STATE < 1  AND [52].SaleOrderID = [53].SaleOrderID';
        sSQL := sSQL +' AND Code = '''+ FieldByName('Code').AsString+''' AND BRAND = '''+sKov+'''';

        QueryStock.SQL.Clear;
        QueryStock.SQL.Add(sSQL);
        QueryStock.Active := TRUE;

        if QueryStock.Eof then
          FieldByName('Reserve').Value := 0
         else
         if QueryStock.FieldByName('CL').AsString = '' then
            FieldByName('Reserve').Value := 0
         else
            FieldByName('Reserve').Value := QueryStock.FieldByName('CL').AsInteger;



        QueryStock.Active := FALSE;
        if FieldByName('Reserve').AsInteger>0 then
           FieldByName('Basic').Value := FieldByName(sFieldGlobalName).AsString + '('+FieldByName('Reserve').AsString+')'
        else
           FieldByName('Basic').Value := FieldByName(sFieldGlobalName).AsString;
    end
    else
        FieldByName('Reserve').Value := 0;
  end;
end;

procedure TData.CatFilterTableIndexProgress(Sender: TObject; PercentDone: Word);
begin
  if CatFilterTable.Tag = 1 then
    Main.CurrProgress(PercentDone div 3)
  else if CatFilterTable.Tag = 2 then
    Main.CurrProgress(33 + PercentDone div 3)
  else if CatFilterTable.Tag = 3 then
    Main.CurrProgress(67 + PercentDone div 3)
  else
    Main.CurrProgress(PercentDone);
end;

function TData.CheckVersions(Ver_Old, Ver_New: string): Integer;

  function CompareInt(aOld, aNew: Integer): Integer;
  begin
    if aOld = aNew then
      Result := 0
    else
      if aNew > aOld then
        Result := 1
      else
        Result := -1;
  end;

var
  y, m, d, p_old, p_new: Word;
  dt_old, dt_new: TDate;
begin
  if Ver_Old = Ver_New then
  begin
    Result := 0;
    Exit;
  end;

  //120501.1
  y := 2000 + StrToIntDef( Copy(Ver_Old, 1, 2) , 0);
  m := StrToIntDef( Copy(Ver_Old, 3, 2) , 1);
  d := StrToIntDef( Copy(Ver_Old, 5, 2) , 1);
  p_old := StrToIntDef( Copy(Ver_Old, 8, 1) , 0);
  dt_old := EncodeDate(y, m, d);

  y := 2000 + StrToIntDef( Copy(Ver_New, 1, 2) , 0);
  m := StrToIntDef( Copy(Ver_New, 3, 2) , 1);
  d := StrToIntDef( Copy(Ver_New, 5, 2) , 1);
  p_new := StrToIntDef( Copy(Ver_New, 8, 1) , 0);
  dt_new := EncodeDate(y, m, d);

  if Trunc(dt_old) = Trunc(dt_new) then
    Result := CompareInt(p_old, p_new)
  else
    if Trunc(dt_new) > Trunc(dt_old) then
      Result := 1
    else
      Result := -1;
end;


procedure TData.DoExport(Quants: boolean = False);
var fileCSV:TextFile;
    sName, sText:string;

begin
  ExportTable(BrandTable, Export_Path      + 'bra.csv', 'Выгрузка брендов...',
                                             BRA_IMPEXP_FIELDS);
  ExportTable(GroupTable, Export_Path      + 'gru.csv', 'Выгрузка групп...',
                                             GRU_IMPEXP_FIELDS);
  ExportTable(GroupBrandTable, Export_Path + 'grb.csv', 'Выгрузка дерева классификатора...',
                                             GRB_IMPEXP_FIELDS);
  ExportTable(LoadCatTable, Export_Path    + 'cat.csv', 'Выгрузка каталога...',
                                             CatFieldsForExport);
  ExportTable(LoadAnTable, Export_Path     + 'ana.csv', 'Выгрузка аналогов...',
                                             ANA_IMPEXP_FIELDS);
  ExportTable(LoadOETable, Export_Path     + 'oem.csv', 'Выгрузка OE-номеров...',
                                             OEM_IMPEXP_FIELDS);
  ExportTable(SysParamTable, Export_Path      + 'sys.csv', 'Выгрузка настроек...',
                                             SYS_IMPEXP_FIELDS);
  ExportTable(TableCarFilter, Export_Path      + 'car.csv', 'Выгрузка привязок...','TYPE_ID');

  kittable.MasterSource := nil;
  kittable.IndexFieldNames:= 'ID';
  ExportTable(KitTable, Export_Path      + 'kit.csv', 'Выгрузка комплектов...',
                                              KIT_IMP_FIELDS);
  kittable.MasterSource := CatalogDataSource;
  ExportTable(OOTable, Export_Path      + 'OO.csv', 'Выгрузка товаров под заказ...',
                                              OO_IMP_FIELDS);

  UploadDescription(Export_Path + 'descr.csv');
  MakeFullPrimen(Export_Path    + 'typ.csv');

 { AssignFile(fileCSV, Export_Path+ 'car.csv');
  Rewrite(fileCSV);
  Main.ShowProgress('Выгрузка привязок...');
  with TableCarFilter do
  begin
    first;
    sName :='';
    sText := '';
    while not EOF do
    begin
      Writeln(fileCSV, FieldByName('Type_ID').AsString+';'+FieldByName('Cat_ID').AsString + ';');
      Main.CurrProgress((RecNo*100) div RecordCount);
      Next;
    end;

    CloseFile(fileCSV);
    Main.HideProgress;
    {if not EOF then
    begin
      sName := FieldByName('Type_ID').AsString;
      sText := sName+';'+FieldByName('Cat_ID').AsString + ';';
      Next;
      while not EOF do
      begin
       if sName <> FieldByName('Type_ID').AsString then
          begin
             Writeln(fileCSV, sText);
             sName := FieldByName('Type_ID').AsString;
             sText := sName+';';
          end;
       sText := sText+FieldByName('Cat_ID').AsString + ';';


      Main.CurrProgress((RecNo*100) div RecordCount );

       Next;
      end;
      if Length(sText) > 0 then
         Writeln(fileCSV, sText);
         CloseFile(fileCSV);
         
    end;
  end; }

  //TableCarFilter.CancelRange;

  if Quants then
    ExportTable(LoadQuantTable, Export_Path  + 'qua.csv', 'Выгрузка наличия...',
                                             QUA_IMPEXP_FIELDS);
  AssignFile(fileCSV, Export_Path+ '0');
  Rewrite(fileCSV);
  Writeln(fileCSV, VersionTable.FieldByName('DataVersion').AsString);
  Writeln(fileCSV, VersionTable.FieldByName('DiscretNumberVersion').AsString);
  CloseFile(fileCSV);

end;


procedure TData.DoExportUpdate;
var fileCSV:TextFile;
    sName, sText:string;

begin
  ExportTable(BrandTable, Export_Path      + 'bra.csv', 'Выгрузка брендов...',
                                             BRA_UP_IMPEXP_FIELDS);
  ExportTable(GroupTable, Export_Path      + 'gru.csv', 'Выгрузка групп...',
                                             GRU_UP_IMPEXP_FIELDS);
  ExportTable(GroupBrandTable, Export_Path + 'grb.csv', 'Выгрузка дерева классификатора...',
                                             GRB_UP_IMPEXP_FIELDS);
  ExportTable(LoadCatTable, Export_Path    + 'cat.csv', 'Выгрузка каталога...',
                                             CatFieldsForExport);
  ExportTable(LoadAnTable, Export_Path     + 'ana.csv', 'Выгрузка аналогов...',
                                             ANA_UP_IMPEXP_FIELDS);
  ExportTable(LoadOETable, Export_Path     + 'oem.csv', 'Выгрузка OE-номеров...',
                                             OEM_UP_IMPEXP_FIELDS);
  ExportTable(SysParamTable, Export_Path      + 'sys.csv', 'Выгрузка настроек...',
                                             SYS_IMPEXP_FIELDS);
  ExportTable(TableCarFilter, Export_Path      + 'car.csv', 'Выгрузка привязок...','TYPE_ID');

  kittable.MasterSource := nil;
  kittable.IndexFieldNames:= 'ID';
  ExportTable(KitTable, Export_Path      + 'kit.csv', 'Выгрузка комплектов...',
                                              KIT_IMP_FIELDS);
  kittable.MasterSource := CatalogDataSource;
  ExportTable(OOTable, Export_Path      + 'OO.csv', 'Выгрузка товаров под заказ...',
                                              OO_IMP_FIELDS);
  UploadDescription(Export_Path);
  MakeFullPrimen(Export_Path + 'typ.csv');

  AssignFile(fileCSV, Export_Path+ '0');
  Rewrite(fileCSV);
  Writeln(fileCSV, VersionTable.FieldByName('DataVersion').AsString);
  Writeln(fileCSV, VersionTable.FieldByName('DiscretNumberVersion').AsString);
  CloseFile(fileCSV);
end;

//выгрузка только ID'шек (для сравнения полного и частичного обновлений)
procedure TData.DoExportTEST;
begin
  ExportTable(BrandTable, Export_Path      + 'bra.csv', 'Выгрузка брендов...', 'ID');
  ExportTable(GroupTable, Export_Path      + 'gru.csv', 'Выгрузка групп...', 'ID');
  ExportTable(GroupBrandTable, Export_Path + 'grb.csv', 'Выгрузка дерева классификатора...', 'ID');
  ExportTable(LoadCatTable, Export_Path    + 'cat.csv', 'Выгрузка каталога...', 'CAT_ID');
  ExportTable(LoadAnTable, Export_Path     + 'ana.csv', 'Выгрузка аналогов...', 'ID');
  ExportTable(LoadOETable, Export_Path     + 'oem.csv', 'Выгрузка OE-номеров...', 'ID');
  ExportTable(TableCarFilter, Export_Path  + 'car.csv', 'Выгрузка привязок...','TYPE_ID');
  ExportTable(KitTable, Export_Path        + 'kit.csv',  'Выгрузка комлектов...','ID');
  ExportTable(OOTable, Export_Path         + 'OO.csv',   'Выгрузка товаров под заказ...','ID');
end;

procedure TData.DoImport(Path: string='');
var
  fname: string;
begin
  LoadingLock;
  StartWait;
  if Path = '' then
    Path := Import_Path;
  AllClose;
  CatalogTable.AfterScroll := nil;
  Main.LoadTDInfoTimer.Enabled := False;
//  fname := Path + 'sys.csv';
//DoImport


  if FileExists(fname) then
  begin

    ImportTable(SysParamTable, fname, 'Загрузка настроек...', SYS_IMPEXP_FIELDS);

    
  end;
  fname := Path + 'bra.csv';
  if FileExists(fname) then
  begin
    ImportTable(BrandTable, fname, 'Загрузка брендов...', BRA_IMPEXP_FIELDS);
  end;
  fname := Path + 'gru.csv';
  if FileExists(fname) then
    ImportTable(GroupTable, fname, 'Загрузка групп...', GRU_IMPEXP_FIELDS);
  fname := Path + 'grb.csv';
  if FileExists(fname) then
    ImportTable(GroupBrandTable, fname, 'Загрузка дерева классификатора...',
                                        GRB_IMPEXP_FIELDS);
  fname := Path + 'cat.csv';
  if FileExists(fname) then
  begin
    //LoadCatTable.DeleteAllIndexes;
    ImportTable(LoadCatTable, fname, 'Загрузка каталога...', CatFieldsForExport);
    //TestTable(CatalogTable, data_psw, CAT_FULLTEXT_FIELDS);
    LoadPrimenMemo;
  end;
  fname := Path + 'ana.csv';
  if FileExists(fname) then
  begin
    ImportTable(LoadAnTable, fname, 'Заполнение базы аналогов...', ANA_IMPEXP_FIELDS);
    LoadAnMemo;
  end;
  fname := Path + 'oem.csv';
  if FileExists(fname) then
  begin
    ImportTable(LoadOETable, fname, 'Заполнение базы OE-номеров...', OEM_IMPEXP_FIELDS);
    LoadOEMemo;
  end;
  fname := Path + 'qua.csv';
  if FileExists(fname) then
    ImportTable(LoadQuantTable, fname, 'Загрузка наличия...', QUA_IMPEXP_FIELDS);
  AllOpen;
  Ign_chars := SysParamTable.FieldByName('Ign_chars').AsString;
  //LoadBrandsDiscount;
  LoadTree;
  CatalogDataSource.DataSet.AfterScroll := Data.CatalogTableAfterScroll;
  StopWait;
  LoadingUnlock;
end;


procedure TData.LoadOEMemo;
var
  s: string;
  cnt: integer;
begin
  exit;
  StartWait;
  Main.ShowProgress('Загрузка OE-номеров в каталог...');
  with LoadOETable do
  begin
    IndexName := 'Cat_id';
    Open;
  end;
  with LoadCatTable do
  begin
    Open;
    Main.SetProgressMax(RecordCount);
    cnt := 0;
    First;
    while not Eof do
    begin
      s := '';
      with LoadOETable do
      begin
        SetRange([LoadCatTable.FieldByName('Cat_id').AsInteger],
                 [LoadCatTable.FieldByName('Cat_id').AsInteger]);
        First;
        while not Eof do
        begin
          if s <> '' then
            s := s + ', ';
          s := s + FieldByName('Code').AsString;
          Next;
        end;
        CancelRange;
      end;
      if s <> '' then
      begin
        Edit;
        FieldByName('Oem').Text := s;
        Post;
      end;
      Inc(cnt);
      if cnt mod 1000 = 0 then
        Main.CurrProgress(cnt);
      Next;
    end;
  end;
  Main.HideProgress;
  with LoadOETable do
  begin
    Close;
    IndexName := '';
  end;
  StopWait;
end;


procedure TData.LoadAnMemo;
var
  s: string;
  cnt: integer;
begin
  exit;
  StartWait;
  Main.ShowProgress;
  Main.ShowProgrInfo('Загрузка кодов аналогов в каталог...');
  LoadAnTable.Open;
  with LoadCatTable do
  begin
    Open;
    Main.SetProgressMax(RecordCount);
    cnt := 0;
    First;
    while not Eof do
    begin
      s := '';
      with LoadAnTable do
      begin
        SetRange([LoadCatTable.FieldByName('Cat_id').AsInteger],
                 [LoadCatTable.FieldByName('Cat_id').AsInteger]);
        First;
        while not Eof do
        begin
          if s <> '' then
            s := s + ', ';
          s := s + FieldByName('An_code').AsString;
          Next;
        end;
        CancelRange;
      end;
      if s <> '' then
      begin
        Edit;
        FieldByName('Analogs').Text := s;
        Post;
      end;
      Inc(cnt);
      if cnt mod 1000 = 0 then
        Main.CurrProgress(cnt);
      Next;
    end;
  end;
  Main.HideProgress;
  LoadAnTable.Close;
  StopWait;
end;


procedure TData.PrepareUpdate;
var
  d, m, y: Word;
  fsize: Integer;
  upd_url: string;
  sver: string;

  aDiscretUpdateSize: Cardinal;
  aDiscretUpdateFile: string;
begin
  if MessageDlg('Выгрузить обновление для клиентов?',
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  upd_url := SysParamTable.FieldByName('Update_url').AsString;
  if (upd_url <> '') and (Right(upd_url, 1) <> '/') then
    upd_url := upd_url + '/'
  else
    upd_url := 'c:\update\';

  DoExportUpdate;

  QuantsUnload;

  StartWait;

  DecodeDate(Date, y, m, d);

  AssignFile(F, Update_Path + cUpdateInfoFileName);
  Rewrite(F);
  Writeln(F, '[files]');
  Writeln(F, 'count=5');
  Writeln(F);
  
  Main.ShowProgrInfo(' Упаковка...');
  with Zipper do
  begin
    FileCopy(Application.ExeName, Update_path + UPD_PROG_NAME, True);
    fsize := FileGetSize(Application.ExeName);
    sver  := GetFileDateVersion(Application.ExeName);
    Writeln(F, '[file1]');
    Writeln(F, 'url=' + upd_url + UPD_PROG_NAME);
    Writeln(F, 'descr=Программа  [' + sver + '] ' +  GetFileSizeStr(fsize));
    Writeln(F, 'filesize=' + IntToStr(fsize));
    Writeln(F, 'customversion=' + sver);
    Writeln(F, 'localversion=prog');
    Writeln(F);

    RootDir := GetAppDir;
    ZipName := Update_path + UPD_NEWS_ZIP;
    if FileExists(ZipName) then
      SysUtils.DeleteFile(ZipName);
    FilesList.Clear;
    FilesList.Add('News.html');
    FilesList.Add('News.files\*.*');
    FilesList.Add('Rules.html');
    FilesList.Add('Rules.files\*.*');
    FilesList.Add('Brands.html');
    FilesList.Add('Brands.files\*.*');
    FilesList.Add('Orders.html');
    FilesList.Add('Orders.files\*.*');
    FilesList.Add('About.html');
    FilesList.Add('About.files\*.*');
    FilesList.Add('RunningLine');
    StorePaths := True;
    RelativePaths := True;
    Zip;
    sver := StrZero(y - 2000, 2) + StrZero(m, 2) + StrZero(d, 2) + '.1';
    Writeln(F, '[file2]');
    Writeln(F, 'url=' + upd_url + UPD_NEWS_ZIP);
    Writeln(F, 'descr=Новости  [' + sver + '] ' + GetFileSizeStr(ZipSize));
    Writeln(F, 'filesize=' + IntToStr(ZipSize));
    Writeln(F, 'targetdir={APP}\Импорт');
    Writeln(F, 'customversion=' + sver);
    Writeln(F, 'localversion=news');
    Writeln(F);

    RootDir := Export_path;
    ZipName := Update_path + UPD_DATA_ZIP;
    Password := UPD_PWD;
    if FileExists(ZipName) then
      SysUtils.DeleteFile(ZipName);
    FilesList.Clear;
    FilesList.Add('sys.csv');
    FilesList.Add('bra.csv');
    FilesList.Add('gru.csv');
    FilesList.Add('grb.csv');
    FilesList.Add('cat.csv');
    FilesList.Add('ana.csv');
    FilesList.Add('oem.csv');
    FilesList.Add('car.csv');
    FilesList.Add('kit.csv');
    FilesList.Add('oo.csv');
    FilesList.Add('descr.csv');
    FilesList.Add('typ.csv');
    FilesList.Add('0');
    FilesList.Add(Update_Path+ 'UpdateInfo.csv');
    StorePaths := False;
    Zip;
    sver := StrZero(y - 2000, 2) + StrZero(m, 2) + StrZero(d, 2) + '.1';
    Writeln(F, '[file3]');
    Writeln(F, 'url=' + upd_url + UPD_DATA_ZIP);
    Writeln(F, 'descr=Данные  [' + sver + '] ' + GetFileSizeStr(ZipSize));
    Writeln(F, 'filesize=' + IntToStr(ZipSize));
    DecodeDate(Date, y, m, d);
    Writeln(F, 'targetdir={APP}\Импорт');
    Writeln(F, 'customversion=' + sver);
    Writeln(F, 'localversion=data');
    Writeln(F);

    ZipName := Update_path + UPD_QUANTS_ZIP;
    FilesList.Clear;
    FilesList.Add('qnt.csv');
    Zip;
    sver := StrZero(y - 2000, 2) + StrZero(m, 2) + StrZero(d, 2) + '.1';
    Writeln(F, '[file4]');
    Writeln(F, 'url=' + upd_url + UPD_QUANTS_ZIP);
    Writeln(F, 'descr=Цены, наличие, курсы валют  [' + sver + '] ' + GetFileSizeStr(ZipSize));
    Writeln(F, 'filesize=' + IntToStr(ZipSize));
    Writeln(F, 'targetdir={APP}\Импорт');
    Writeln(F, 'customversion=' + sver);
    Writeln(F, 'localversion=quants');
    Writeln(F);

    Writeln(F, '[application]');
    Writeln(F, 'appupdate=1');
    Writeln(F, 'appname=ShateMPlus.exe');
    Writeln(F, 'appcomps=' + UPD_PROG_NAME);
    Writeln(F, 'silentrestart=1');

  end;
  CloseFile(F);
  Main.HideProgress;
  StopWait;
  MessageDlg('Данные успешно выгружены в каталог ' + Update_path + '.',
     mtInformation, [mbOK], 0);
end;

procedure TData.UploadDescription(const aDestFile : string);
var
  descr,id,cat_id, new: string;
  DescrFile : TextFile;
  t, i, iMax: Cardinal;
begin
  Main.ShowProgress('Выгрузка текстовых описаний');

  AssignFile(DescrFile, aDestFile);
  rewrite(DescrFile);
  DescriptionTable.DisableControls;
  try
    DescriptionTable.MasterSource := nil;
    i := 0;
    iMax := DescriptionTable.RecordCount;
    DescriptionTable.IndexFieldNames:= 'ID';
    DescriptionTable.First;
    while not DescriptionTable.Eof do
    begin
      descr := DescriptionTable.FieldByName('Description').AsString;
      descr := StringReplace(descr,#13,'~13',[rfReplaceAll]);
      descr := StringReplace(descr,';','~59',[rfReplaceAll]);
      id := DescriptionTable.FieldByName('ID').AsString;
      cat_id := DescriptionTable.FieldByName('CAT_ID').AsString;
      Writeln(DescrFile, id + ';' + cat_id + ';' + descr);

      DescriptionTable.Next;
      Inc(i);
      if i mod 100 = 0 then
        Main.CurrProgress(i * 100 div iMax);
    end;
    CloseFile(DescrFile);
    DescriptionTable.MasterSource := CatalogDataSource;
  finally
    DescriptionTable.EnableControls;
    Main.HideProgress;
  end;
end;


procedure TData.PrimenTableAfterScroll(DataSet: TDataSet);
begin
  CatTypDetTable.SetRange(
    [CatalogDataSource.DataSet.FieldByName('typ_tdid').AsInteger, PrimenTable.FieldByName('Typ_id').AsInteger],
    [CatalogDataSource.DataSet.FieldByName('typ_tdid').AsInteger, PrimenTable.FieldByName('Typ_id').AsInteger]
  );
end;

procedure TData.QuantQueryQueryProgress(Sender: TObject; PercentDone: Word;
  var Abort: Boolean);
begin
  Main.CurrProgress(PercentDone);
end;

procedure TData.QuantsUnload;
var
  i: integer;
  fname, old_ind: string;
begin
  fname := Export_path + 'qnt.csv';
  AssignFile(F, fname);
  Rewrite(F);
  Main.ShowProgress('Выгрузка остатков...');
  i := 0;
  old_ind := XCatTable.IndexName;
  XCatTable.IndexName := '';
  with UnloadQuantTable do
  begin
    Open;
    Main.SetProgressMax(RecordCount);
    First;
    while not Eof do
    begin
      Writeln(F, FieldByName('CatCode').AsString + '_' +
                 FieldByName('CatBrand').AsString + ';' +
                 FieldByName('Quantity').AsString + ';' +
                 FieldByName('CatPrice').AsString);
      Next;
      Inc(i);
      if i mod 100 = 0 then
        Main.CurrProgress(i);
    end;
    Close;
  end;
  XCatTable.IndexName := old_ind;
  CloseFile(F);
  Main.HideProgress;
end;


procedure TData.QuerySelectQueryProgress(Sender: TObject; PercentDone: Word;
  var Abort: Boolean);
begin
  if Main.bAbort then
  begin
    Abort := Main.bAbort;
  end
  else
    // if PercentDone mod 5 = 0 then
  begin
    Main.CurrProgress(PercentDone);
  end;
end;

procedure TData.PrepareQuantsUpdate;
var
  d, m, y: Word;
  sver, cver: string;
  sz: integer;
begin
  if MessageDlg('Выгрузить обновление с остатками и ценами?', mtConfirmation,
                [mbYes, mbNo], 0) <> mrYes then
    Exit;
  StartWait;
  QuantsUnload;
  Main.ShowProgrInfo('Упаковка...');
  with Zipper do
  begin
    RootDir := Export_path;
    Password := UPD_PWD;
    ZipName := Update_path + UPD_QUANTS_ZIP;
    if FileExists(ZipName) then
      SysUtils.DeleteFile(ZipName);
    FilesList.Clear;
    FilesList.Add('qnt.csv');
    StorePaths := False;
    Zip;
    sz := ZipSize;
  end;
  Main.ShowProgrInfo('');
  DecodeDate(Date, y, m, d);
  sver := StrZero(y - 2000, 2) + StrZero(m, 2) + StrZero(d, 2) + '.1';
  with TIniFile.Create(Update_Path + cUpdateInfoFileName) do
  begin
    cver := ReadString('file4', 'customversion', '');
    if Copy(cver, 1, 6) = Copy(sver, 1, 6) then
      sver := Copy(sver, 1, 6) + '.' + IntToStr(StrInt(Copy(cver, 8, 5)) + 1);
    WriteString('file4', 'descr', 'Цены, наличие, курсы валют [' + sver + '] ' +
                 FloatToStr(XRound(sz / (1024), 2)) + 'Кб');
    WriteString('file4', 'filesize', IntToStr(sz));
    WriteString('file4', 'customversion', sver);
    Free;
  end;
  StopWait;
  MessageDlg('Остатки успешно выгружены в каталог ' + Update_path + '.',
     mtInformation, [mbOK], 0);
end;



procedure TData.CalcWaitList;
var
  rn: integer;
  bFiltered:boolean;
begin
  StartWait;
  with WaitListTable do
  begin
    DisableControls;
    rn := RecNo;
    bFiltered := Filtered;
    Filtered := False;
    First;
    WaitListTotal := 0;
    WaitListCnt := 0;
    while not Eof do
    begin
      Inc(WaitListTotal);
      if (FieldByName('ArtQuant').AsString <> '') and
         (FieldByName('ArtQuant').AsString <> '0') then
        Inc(WaitListCnt);
      Next;
    end;
    Filtered := bFiltered;
    RecNo := rn;
    EnableControls;
  end;

  StopWait;
  if WaitListTotal > 0 then
    Main.WaitListPage.Caption := 'Лист ожидания (' + IntToStr(WaitListCnt) + '/' +
                                                     IntToStr(WaitListTotal) + ')'
  else
    Main.WaitListPage.Caption := 'Лист ожидания';
//  if WaitListCnt > 0 then
//    Main.WaitListPage.ImageIndex := 45
//  else
//    Main.WaitListPage.ImageIndex := 35;
  if WaitListCnt > 0 then
  begin
    if not Main.Wait_Flash_flag then
      Main.WaitListFlashTimer.Enabled := True
    else
      Main.WaitListPage.ImageIndex := 45;
  end
  else
  begin
    Main.WaitListFlashTimer.Enabled := False;
    Main.WaitListPage.ImageIndex := 35;
  end;



  StartWait;
  with AssortmentExpansion do
  begin
    DisableControls;
    rn := RecNo;
    bFiltered := Filtered;
    Filtered := False;
    First;
    AssortmentExpansionTotal := 0;
    AssortmentExpansionCnt := 0;
    //AssortmentExpansionCnt, AssortmentExpansionTotal: integer;
    while not Eof do
    begin
      Inc(AssortmentExpansionTotal);
      if (FieldByName('ArtQuant').AsString <> '') and
         (FieldByName('ArtQuant').AsString <> '0') then
        Inc(AssortmentExpansionCnt);
      Next;
    end;
    Filtered := Filtered;
    RecNo := rn;
    EnableControls;
  end;

   if AssortmentExpansionTotal > 0 then
    Main.AssortmentExpansionPage.Caption := 'Расширение ассортимента (' + IntToStr(AssortmentExpansionCnt) + '/' +
                                                     IntToStr(AssortmentExpansionTotal) + ')'
  else
    Main.AssortmentExpansionPage.Caption := 'Расширение ассортимента';
//  if WaitListCnt > 0 then
//    Main.WaitListPage.ImageIndex := 45
//  else
//    Main.WaitListPage.ImageIndex := 35;

  {
  if WaitListCnt > 0 then
  begin
    if not Main.Wait_Flash_flag then
      Main.WaitListFlashTimer.Enabled := True
    else
      Main.WaitListPage.ImageIndex := 45;
  end
  else
  begin
    Main.WaitListFlashTimer.Enabled := False;
    Main.WaitListPage.ImageIndex := 35;
  end;
  }
  if AssortmentExpansionCnt > 0 then
  begin
      Main.AssortmentExpansionTimer.Enabled := True
  end
  else
  begin
    Main.AssortmentExpansionTimer.Enabled := False;
    Main.AssortmentExpansionPage.ImageIndex := 47;
  end;

  StopWait;
  //Main.AllWaitListOrderMoveAction.Enabled := WaitListCnt > 0;}
end;

(*
procedure TData.LoadBrandsDiscount;
var
  rn: integer;
begin
  StartWait;
  BrDiscountTable.Open;
  with BrandTable do
  begin
    try
      DisableControls;
      rn := RecNo;
      First;
      while not Eof do
      begin
        if BrDiscountTable.FindKey([FieldByname('Description').AsString]) then
        begin
          Edit;
          FieldByName('Discount').Value := BrDiscountTable.FieldByName('Discount').AsFloat;
          Post;
        end
        else if FieldByName('Discount').Value <> null then
        begin
          Edit;
          FieldByName('Discount').Clear;
          Post;
        end;
        Next;
      end;
      RecNo := rn;
    finally
      EnableControls;
    end;
  end;
  BrDiscountTable.Close;
  StopWait;
end;


procedure TData.SaveBrandsDiscount;
var
  rn: integer;
begin
  startWait;
  BrDiscountTable.EmptyTable;
  BrDiscountTable.Open;
  with BrandTable do
  begin
    try
      DisableControls;
      rn := RecNo;
      First;
      while not Eof do
      begin
        if FieldByName('Discount').AsCurrency <> 0 then
        begin
          BrDiscountTable.Append;
          BrDiscountTable.FieldByName('Brand_descr').Value := FieldByName('Description').AsString;
          BrDiscountTable.FieldByName('Discount').Value := FieldByName('Discount').AsFloat;
          BrDiscountTable.Post;
        end;
        Next;
      end;
      RecNo := rn;
    finally
      EnableControls;
    end;
  end;
  BrDiscountTable.Close;
  StopWait;
end;
*)

procedure TData.TestUpgradeLevel;
begin
  if ParamTable.FieldByName('Upgrade_level').AsInteger >= CURR_UPGRADE_LEVEL then
    exit;
  if ParamTable.FieldByName('Upgrade_level').AsInteger < 1 then
  begin
    with OrderDetTable do
    begin
      MasterSource := nil;
      First;
      while not Eof do
      begin
        if (FieldByName('Art_id').AsInteger <> 0) and
           (FieldByName('Code2').AsString = '') then
        begin
          if CatalogTable.Locate('Cat_id', FieldByName('Art_id').AsInteger, []) then
          begin
            Edit;
            FieldByName('Code2').Value := CatalogTable.FieldByName('Code2').AsString;
            FieldByName('Brand').Value := CatalogTable.FieldByName('BrandDescr').AsString;
            FieldByName('Art_id').Value := 0;
            Post;
          end;
        end;
        next;
      end;
      MasterSource := OrderDataSource;
    end;
    with WaitListTable do
    begin
      First;
      while not Eof do
      begin
        if (FieldByName('Art_id').AsInteger <> 0) and
           (FieldByName('Code2').AsString = '') then
        begin
          if CatalogTable.Locate('Cat_id', FieldByName('Art_id').AsInteger, []) then
          begin
            Edit;
            FieldByName('Code2').Value := CatalogTable.FieldByName('Code2').AsString;
            FieldByName('Brand').Value := CatalogTable.FieldByName('BrandDescr').AsString;
            FieldByName('Art_id').Value := 0;
            Post;
          end;
        end;
        next;
      end;
    end;
  end;
  with ParamTable do
  begin
    Edit;
    FieldByName('Upgrade_level').Value := CURR_UPGRADE_LEVEL;
    Post;
  end;
end;


procedure TData.LoadTDBrandTable;
var
  n: integer;
begin
  n := 0;
  StartWait;
  with TDBrandTable do
  begin
    EmptyTable;
    Open;
  end;
  LoadBrandReplTable;
  Main.ShowProgrInfo('Загрузка таблицы брэндов: 0');
  Application.ProcessMessages;
  try
    with ADODataSet do
    begin
      CommandText := 'SELECT * FROM TOF_BRANDS';
      Open;
      while not Eof do
      begin
        TDBrandTable.Append;
        TDBrandTable.FieldByName('Brand_id').Value := FieldByName('BRA_ID').AsInteger;
        if BrandReplTable.FindKey([FieldByName('BRA_BRAND').AsString]) then
          TDBrandTable.FieldByName('Brand_descr').Value :=
                   BrandReplTable.FieldByName('Repl_brand').AsString
        else
          TDBrandTable.FieldByName('Brand_descr').Value := FieldByName('BRA_BRAND').AsString;
        TDBrandTable.FieldByName('Descr_orig').Value := FieldByName('BRA_BRAND').AsString;
        TDBrandTable.FieldByName('Hide').Value := False;
        TDBrandTable.Post;
        Inc(n);
        if n mod 100 = 0 then
          Main.ShowProgrInfo('Загрузка таблицы брэндов: ' + IntToStr(n));
        Next;
      end;
      Close;
      TDBrandTable.Close;
    end;
    StopWait;
    Main.ShowProgrInfo('');
  except
    TDBrandTable.Close;
    StopWait;
    MessageDlg('Ошибка загрузки таблицы брэндов!', mtError, [mbOK], 0);
  end;
  BrandReplTable.Close;
  BrandReplTable.DeleteTable;
end;


procedure TData.LoadTecdoc1;
begin
  if MessageDlg('Загрузить массив данных Tecdoc?', mtConfirmation,
                         [mbYes, mbNo], 0) <> mrYes then
    exit;
  LoadDesTexts;
  LoadCdsTexts;
  LoadArtTable;
  //LoadTDBrandTable;
  MessageDlg('Загрузка завершена!', mtInformation, [mbOK], 0);
end;

procedure TData.LoadArtTable;
var
  n: integer;
begin
  n := 0;
  StartWait;
  with TDArtTable do
  begin
    Close;
    EmptyTable;
    Open;
  end;
  TDBrandTable.IndexName := 'Descr2';
  TDBrandTable.Open;
  Main.ShowProgrInfo('Загрузка таблицы артикулов(new): 0');
  Application.ProcessMessages;
  try
    with ADODataSet do
    begin
      CommandText := 'SELECT ART_ID, ART_ARTICLE_NR, ART_SUP_ID, SUP_BRAND'#13#10 +
                     'FROM TOF_ARTICLES INNER JOIN TOF_SUPPLIERS on ART_SUP_ID=SUP_ID';
      Open;

      while not Eof do
      begin
        if not (TDBrandTable.FindKey([FieldByName('SUP_BRAND').AsString]) and
                TDBrandTable.FieldByName('Hide').AsBoolean) then
        begin
          TDArtTable.Append;
          TDArtTable.FieldByName('Art_id').Value := FieldByName('ART_ID').AsInteger;
          TDArtTable.FieldByName('Art_look').Value := MakeSearchCode(FieldByName('ART_ARTICLE_NR').AsString);
          TDArtTable.FieldByName('Sup_brand').Value := FieldByName('SUP_BRAND').AsString;

          //[pict]
          TDArtTable.FieldByName('pict_id').Value := 0;
          TDArtTable.FieldByName('typ_id').Value := TDArtTable.FieldByName('Art_id').Value;
          TDArtTable.FieldByName('param_id').Value := TDArtTable.FieldByName('Art_id').Value;

          TDArtTable.Post;
        end;
        Inc(n);
        if n mod 1000 = 0 then
          Main.ShowProgrInfo('Загрузка таблицы артикулов(new): ' + IntToStr(n));
        Next;
      end;
      Close;
      TDArtTable.Close;
    end;
    TDBrandTable.Close;
    TDBrandTable.IndexName := '';
    StopWait;
    Main.ShowProgrInfo('');
  except
    TDBrandTable.Close;
    TDBrandTable.IndexName := '';
    TDArtTable.Close;
    StopWait;
    MessageDlg('Ошибка загрузки таблицы артикулов(new)!', mtError, [mbOK], 0);
  end;
end;

procedure TData.LoadDesTexts;
var
  n: integer;
begin
  n := 0;
  StartWait;
  with DesTextsTable do
  begin
    Close;
    EmptyTable;
    Open;
  end;
  Main.ShowProgrInfo('Загрузка текстовых данных(1): 0');
  Application.ProcessMessages;
  try
    with ADODataSet do
    begin
      CommandText := 'SELECT DES_ID, MAX(DISTINCT TEX_TEXT) AS TEX_TEXT'#13#10 +
                     'FROM TOF_DESIGNATIONS INNER JOIN TOF_DES_TEXTS ON DES_TEX_ID=TEX_ID'#13#10 +
                     'WHERE (DES_LNG_ID = 16) OR (DES_LNG_ID = 255)'#13#10 +
                     'GROUP BY DES_ID';
      Open;
      while not Eof do
      begin
        DesTextsTable.Append;
        DesTextsTable.FieldByName('Des_id').Value := FieldByName('DES_ID').AsInteger;
        DesTextsTable.FieldByName('Tex_text').Value := FieldByName('TEX_TEXT').AsString;
        DesTextsTable.Post;
        Inc(n);
        if n mod 1000 = 0 then
          Main.ShowProgrInfo('Загрузка текстовых данных(1): ' + IntToStr(n));
        Next;
      end;
      Close;
      DesTextsTable.Close;
    end;
    StopWait;
    Main.ShowProgrInfo('');
  except
    DesTextsTable.Close;
    StopWait;
    MessageDlg('Ошибка загрузки текстовых данных(1)!', mtError, [mbOK], 0);
  end;
end;


procedure TData.LoadCdsTexts;
var
  n: integer;
begin
  n := 0;
  StartWait;
  with CdsTextsTable do
  begin
    Close;
    EmptyTable;
    Open;
  end;
  Main.ShowProgrInfo('Загрузка текстовых данных(2): 0');
  Application.ProcessMessages;
  try
    with ADODataSet do
    begin
      CommandText := 'SELECT CDS_ID, MAX(DISTINCT TEX_TEXT) AS TEX_TEXT'#13#10 +
                     'FROM TOF_COUNTRY_DESIGNATIONS INNER JOIN TOF_DES_TEXTS ON CDS_TEX_ID=TEX_ID'#13#10 +
                     'WHERE ((CDS_LNG_ID = 16) OR (CDS_LNG_ID = 255)) AND (CDS_CTM Subrange(185 cast integer) = 1)'#13#10 +
                     'GROUP BY CDS_ID';
      Open;
      while not Eof do
      begin
        CdsTextsTable.Append;
        CdsTextsTable.FieldByName('Cds_id').Value := FieldByName('CDS_ID').AsInteger;
        CdsTextsTable.FieldByName('Tex_text').Value := FieldByName('TEX_TEXT').AsString;
        CdsTextsTable.Post;
        Inc(n);
        if n mod 1000 = 0 then
          Main.ShowProgrInfo('Загрузка текстовых данных(2): ' + IntToStr(n));
        Next;
      end;
      Close;
      cdsTextsTable.Close;
    end;
    StopWait;
    Main.ShowProgrInfo('');
  except
    CdsTextsTable.Close;
    StopWait;
    MessageDlg('Ошибка загрузки текстовых данных(2)!', mtError, [mbOK], 0);
  end;
end;

procedure TData.LoadTecdoc2(lUpdate: boolean = False);
var
  s: string;
begin
  if lUpdate then
    s := 'Обновить вытяжки данных Tecdoc? Данные будут добавлены к имеющимся в таблицах.'
  else
    s := 'Загрузить новые вытяжки данных Tecdoc? Прежние значения в таблицах будут удалены!';
  if MessageDlg(s, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  LoadArtTyp_opt2(lUpdate); {!}
  LoadTypes(lUpdate);
  LoadModels(lUpdate);
  LoadManufacturers(lUpdate);
  LoadCatDet(lUpdate);
  LoadCatTypDet(lUpdate);
  LoadCatParam(lUpdate);
  LoadCatPict_opt(lUpdate);
  LoadPict(lUpdate);
  LoadPrimenMemo;
  CatalogTable.Refresh;
  MessageDlg('Загрузка завершена!', mtInformation, [mbOK], 0);
end;


procedure TData.LoadTecdoc3;
begin
  with TSelectTDLoad.Create(Application) do
  begin
    if ShowModal = mrOk then
    begin
      if DesTextCheckBox.Checked then
        LoadDesTexts;
      if CdsTextCheckBox.Checked then
        LoadCdsTexts;

      if ArtCheckBox.Checked then
        LoadArtTable;            

      if ArtTypCheckBox.Checked then
        LoadArtTyp_opt2; {!}
      if TypesCheckBox.Checked then
        LoadTypes;
      if ModelsCheckBox.Checked then
        LoadModels;
      if MfaCheckBox.Checked then
        LoadManufacturers;
      if CatDetCheckBox.Checked then
        LoadCatDet;
      if CatTypDetCheckBox.Checked then
        LoadCatTypDet;
      if CatParCheckBox.Checked then
        LoadCatParam;

      if CatPictCheckBox.Checked then
        LoadCatPict_opt;

      if PictCheckBox.Checked then
        LoadPict;

      if PrimenCheckBox.Checked then
        LoadPrimenMemo;
      MessageDlg('Загрузка завершена!', mtInformation, [mbOK], 0);
    end;
    Free;
    CatalogTable.Refresh;
  end;
end;

(*
//[typ] - грузим не через [002].tecdoc_id, а через [002].typ_tdid
procedure TData.LoadArtTyp(lUpdate: boolean = False);
var
  i, n, t: integer;
  fl: boolean;
begin
  n := 0;
  i := 0;
  t := 0;
  StartWait;
  Main.ShowProgress('Загрузка привязки артикулов к типам(new): 0');
  Application.ProcessMessages;
  with ArtTypTable do
  begin
    if not lUpdate then
    begin
      Close;
      EmptyTable;
      Open;
    end;
  end;
  with ADODataSet do
  begin
    CommandText := 'SELECT DISTINCT LA_ART_ID, LAT_TYP_ID'#13#10 +
                   'FROM TOF_LINK_LA_TYP INNER JOIN TOF_LINK_ART ON LAT_LA_ID=LA_ID'#13#10 +
                   'WHERE LA_ART_ID=:CAT_ID';
  end;
  try

{ вместо LoadCatTable
select cat.typ_tdid from [002] cat
left join [023] typ on (cat.typ_tdid = typ.art_id)
where cat.typ_tdid > 0 and typ.art_id is NULL
}

    with LoadCatTable do
    begin
      Open;
      First;
      Main.SetProgressMax(RecordCount);
      while not Eof do
      begin
        if (FieldByName('typ_tdid').AsInteger <> 0) and
           (not ArtTypTable.Locate('Art_id',
                                   FieldByName('typ_tdid').AsInteger, [])) then
        begin
          with ADODataSet do
          begin
            Parameters.ParamByName('CAT_ID').Value :=
                       LoadCatTable.FieldByName('typ_tdid').AsInteger;
            Open;
            fl := True;
            while not Eof do
            begin
              if fl then
              begin
                Inc(t);
                fl := False;
              end;
              ArtTypTable.Append;
              ArtTypTable.FieldByName('Art_id').Value := FieldByName('LA_ART_ID').AsInteger;
              ArtTypTable.FieldByName('Typ_id').Value := FieldByName('LAT_TYP_ID').AsInteger;
              ArtTypTable.Post;
              Inc(n);
              if n mod 100 = 0 then
                Main.ShowProgrInfo('Загрузка привязки артикулов к типам(new): ' + IntToStr(t) + '/' + IntToStr(n));
              Next;
            end;
            Close;
          end;
        end;
        Inc(i);
        if i mod 100 = 0 then
          Main.CurrProgress(i);
        Next;
      end;
      Close;
    end;
    StopWait;
  except
    StopWait;
    MessageDlg('Ошибка загрузки привязки артикулов к типам(new)!', mtError, [mbOK], 0);
  end;
  Main.HideProgress;
end;
*)

//[typ] - грузим не через [002].tecdoc_id, а через [002].typ_tdid
procedure TData.LoadArtTyp_opt(lUpdate: boolean = False);
var
  i, n, t: integer;
  fl: boolean;
  aQuery: TDBISAMQuery;
  anIDs: TStrings;
begin
  n := 0;
  i := 0;
  t := 0;
  StartWait;
  Main.ShowProgress('Загрузка привязки артикулов к типам(new): 0');
  anIDs := TStringList.Create;
  aQuery := TDBISAMQuery.Create(nil);
  try //finally
    try //except
      with ArtTypTable do
      begin
        if not lUpdate then
        begin
          Close;
          EmptyTable;
          Open;
        end;
      end;

      aQuery.DatabaseName := Database.DatabaseName;
      //все IDшки tecdoc типов, для которых нет записей в таблице привязок
      aQuery.SQL.Text :=
        'select distinct cat.typ_tdid from [002] cat ' +
        'left join [023] typ on (cat.typ_tdid = typ.art_id) ' +
        'where cat.typ_tdid > 0 and typ.art_id is NULL ';

      aQuery.Open;
      Main.SetProgressMax(aQuery.RecordCount);
      while not aQuery.Eof do
      begin
        anIDs.Add(aQuery.FieldByName('typ_tdid').AsString);
        aQuery.Next;

        //выполняем пачками по 100 tecdoc_id
        if (anIDs.Count >= 100) or (aQuery.Eof) then
        begin
          Inc(t, anIDs.Count);

          ADODataSet.CommandText :=
            'SELECT DISTINCT LA_ART_ID, LAT_TYP_ID'#13#10 +
            'FROM TOF_LINK_LA_TYP INNER JOIN TOF_LINK_ART ON LAT_LA_ID=LA_ID'#13#10 +
            'WHERE LA_ART_ID IN (' + anIDs.CommaText + ')';
          ADODataSet.Open;

          while not ADODataSet.Eof do
          begin
            //if not ArtTypTable.Locate('Art_id;Typ_id', VarArrayOf([ADODataSet.FieldByName('LA_ART_ID').AsInteger, ADODataSet.FieldByName('LAT_TYP_ID').AsInteger]), []) then
            begin
              ArtTypTable.Append;
              ArtTypTable.FieldByName('Art_id').Value := ADODataSet.FieldByName('LA_ART_ID').AsInteger;
              ArtTypTable.FieldByName('Typ_id').Value := ADODataSet.FieldByName('LAT_TYP_ID').AsInteger;
              ArtTypTable.Post;
              Inc(n);
            end;
            ADODataSet.Next;

            if (n mod 100 = 0) or (ADODataSet.Eof) then
              Main.ShowProgrInfo('Загрузка привязки артикулов к типам(new): ' + IntToStr(t) + '/' + IntToStr(n) + ' из ' + IntToStr(aQuery.RecordCount));
          end;

          ADODataSet.Close;
          anIDs.Clear;
        end;

        Inc(i);
        if i mod 100 = 0 then
          Main.CurrProgress(i);
      end;
    finally
      aQuery.Free;
      anIDs.Free;
      Main.HideProgress;
      StopWait;
    end;

  except
    MessageDlg('Ошибка загрузки привязки артикулов к типам(new)!', mtError, [mbOK], 0);
  end;
end;

//[typ] - грузим не через [002].tecdoc_id, а через [002].typ_tdid
procedure TData.LoadArtTyp_opt2(lUpdate: boolean = False);
var
  i, n, t: integer;
  fl: boolean;
  aQuery: TDBISAMQuery;
  anIDs: TStrings;
begin
  n := 0;
  i := 0;
  t := 0;
  StartWait;
  Main.ShowProgress('Загрузка привязки артикулов к типам(new2): 0');
  anIDs := TStringList.Create;
  aQuery := TDBISAMQuery.Create(nil);
  adoOleDB.Connected := True;
  try //except
    try //finally
      with ArtTypTable do
      begin
        if not lUpdate then
        begin
          Close;
          EmptyTable;
          Open;
        end;
      end;

      aQuery.DatabaseName := Database.DatabaseName;
      //все IDшки tecdoc типов, для которых нет записей в таблице привязок
      aQuery.SQL.Text :=
        'select distinct cat.typ_tdid from [002] cat ' +
        'left join [023] typ on (cat.typ_tdid = typ.art_id) ' +
        'where cat.typ_tdid > 0 and typ.art_id is NULL ';

      aQuery.Open;

      Main.SetProgressMax(aQuery.RecordCount);
      while not aQuery.Eof do
      begin
        anIDs.Add(aQuery.FieldByName('typ_tdid').AsString);
        aQuery.Next;

        //выполняем пачками по 50 tecdoc_id
        if (anIDs.Count >= 50) or (aQuery.Eof) then
        begin
          Inc(t, anIDs.Count);

          msQuery.SQL.Text :=
            'SELECT ART_ID, TYP_ID ' +
            'FROM ART_TYP ' +
            'WHERE ART_ID IN (' + anIDs.CommaText + ')';
          msQuery.Open;

          while not msQuery.Eof do
          begin
            //if not ArtTypTable.Locate('Art_id;Typ_id', VarArrayOf([ADODataSet.FieldByName('LA_ART_ID').AsInteger, ADODataSet.FieldByName('LAT_TYP_ID').AsInteger]), []) then
            begin
              ArtTypTable.Append;
              ArtTypTable.FieldByName('Art_id').Value := msQuery.FieldByName('ART_ID').AsInteger;
              ArtTypTable.FieldByName('Typ_id').Value := msQuery.FieldByName('TYP_ID').AsInteger;
              ArtTypTable.Post;
              Inc(n);
            end;
            msQuery.Next;

            if (n mod 100 = 0) or (msQuery.Eof) then
              Main.ShowProgrInfo('Загрузка привязки артикулов к типам(new2): ' + IntToStr(t) + '/' + IntToStr(n) + ' из ' + IntToStr(aQuery.RecordCount));
          end;

          msQuery.Close;
          anIDs.Clear;
        end;

        Inc(i);
        if i mod 100 = 0 then
          Main.CurrProgress(i);
      end;
    finally
      adoOLEDB.Connected := False;
      aQuery.Free;
      anIDs.Free;
      Main.HideProgress;
      StopWait;
    end;

  except
    MessageDlg('Ошибка загрузки привязки артикулов к типам(new2)!', mtError, [mbOK], 0);
  end;
end;

procedure TData.LoadTypes(lUpdate: boolean=False);
var
  n: integer;
  codes: string;
begin
  n := 0;
  StartWait;
  if not lUpdate then
  begin
    with TypesTable do
    begin
      Close;
      EmptyTable;
      Open;
    end;
  end;
  ArtTypTable.IndexName := 'Typ';
  Main.ShowProgrInfo('Загрузка типов: 0');
  try
    with ADODataSet do
    begin
      CommandText := 'SELECT * FROM TOF_TYPES';
      Open;
      while not Eof do
      begin
        if ArtTypTable.FindKey([FieldByName('TYP_ID').AsInteger]) and
           (not TypesTable.Locate('Typ_id', FieldByName('TYP_ID').AsInteger, [])) then
        begin
          TypesTable.Append;
          TypesTable.FieldByName('Typ_id').Value := FieldByName('TYP_ID').AsInteger;
          TypesTable.FieldByName('Mod_id').Value := FieldByName('TYP_MOD_ID').AsInteger;
          TypesTable.FieldByName('Cds_id').Value := FieldByName('TYP_CDS_ID').AsInteger;
          TypesTable.FieldByName('Mmt_cds_id').Value := FieldByName('TYP_MMT_CDS_ID').AsInteger;
          TypesTable.FieldByName('Sort').Value := FieldByName('TYP_SORT').AsInteger;
          TypesTable.FieldByName('Pcon_start').Value := FieldByName('TYP_PCON_START').AsInteger;
          TypesTable.FieldByName('Pcon_end').Value := FieldByName('TYP_PCON_END').AsInteger;
          TypesTable.FieldByName('Kw_from').Value := FieldByName('TYP_KW_FROM').AsInteger;
          TypesTable.FieldByName('Kw_upto').Value := FieldByName('TYP_KW_UPTO').AsInteger;
          TypesTable.FieldByName('Hp_from').Value := FieldByName('TYP_HP_FROM').AsInteger;
          TypesTable.FieldByName('Hp_upto').Value := FieldByName('TYP_HP_UPTO').AsInteger;
          TypesTable.FieldByName('Ccm').Value := FieldByName('TYP_CCM').AsInteger;
          TypesTable.FieldByName('Cylinders').Value := FieldByName('TYP_CYLINDERS').AsInteger;
          TypesTable.FieldByName('Doors').Value := FieldByName('TYP_DOORS').AsInteger;
          TypesTable.FieldByName('Tank').Value := FieldByName('TYP_TANK').AsInteger;
          TypesTable.FieldByName('Voltage_des_id').Value := FieldByName('TYP_KV_VOLTAGE_DES_ID').AsInteger;
          TypesTable.FieldByName('Abs_des_id').Value := FieldByName('TYP_KV_ABS_DES_ID').AsInteger;
          TypesTable.FieldByName('Asr_des_id').Value := FieldByName('TYP_KV_ASR_DES_ID').AsInteger;
          TypesTable.FieldByName('Engine_des_id').Value := FieldByName('TYP_KV_ENGINE_DES_ID').AsInteger;
          TypesTable.FieldByName('Brake_type_des_id').Value := FieldByName('TYP_KV_BRAKE_TYPE_DES_ID').AsInteger;
          TypesTable.FieldByName('Brake_syst_des_id').Value := FieldByName('TYP_KV_BRAKE_SYST_DES_ID').AsInteger;
          TypesTable.FieldByName('Fuel_des_id').Value := FieldByName('TYP_KV_FUEL_DES_ID').AsInteger;
          TypesTable.FieldByName('Catalyst_des_id').Value := FieldByName('TYP_KV_CATALYST_DES_ID').AsInteger;
          TypesTable.FieldByName('Body_des_id').Value := FieldByName('TYP_KV_BODY_DES_ID').AsInteger;
          TypesTable.FieldByName('Steering_des_id').Value := FieldByName('TYP_KV_STEERING_DES_ID').AsInteger;
          TypesTable.FieldByName('Steering_side_des_id').Value := FieldByName('TYP_KV_STEERING_SIDE_DES_ID').AsInteger;
          TypesTable.FieldByName('Max_weight').AsBCD := FieldByName('TYP_MAX_WEIGHT').AsBCD;
          TypesTable.FieldByName('Drive_des_id').Value := FieldByName('TYP_KV_DRIVE_DES_ID').AsInteger;
          TypesTable.FieldByName('Trans_des_id').Value := FieldByName('TYP_KV_TRANS_DES_ID').AsInteger;
          TypesTable.FieldByName('Fuel_supply_des_id').Value := FieldByName('TYP_KV_FUEL_SUPPLY_DES_ID').AsInteger;
          TypesTable.FieldByName('Valves').Value := FieldByName('TYP_VALVES').AsInteger;
          codes := '';
          with ADODataSet2 do
          begin                                                                           
            CommandText := 'SELECT ENG_CODE FROM TOF_LINK_TYP_ENG'#13#10 +
                           'JOIN TOF_ENGINES ON LTE_ENG_ID = ENG_ID'#13#10 +
                           'WHERE LTE_TYP_ID = :TYP_ID';
            Parameters.ParamByName('TYP_ID').Value :=
                           ADODataSet.FieldByName('TYP_ID').AsInteger;
            Open;
            while not Eof do
            begin
              if codes <> '' then
                codes := codes + ', ';
              codes := codes + FieldByName('ENG_CODE').AsString;
              Next;
            end;
            Close;
          end;
          TypesTable.FieldByName('Eng_codes').Value := codes;
          TypesTable.Post;
          Inc(n);
          if n mod 100 = 0 then
            Main.ShowProgrInfo('Загрузка типов: ' + IntToStr(n));
        end;
        Next;
      end;
      Close;
    end;
    Main.ShowProgrInfo('');
    StopWait;
  except
    StopWait;
    MessageDlg('Ошибка загрузки типов!', mtError, [mbOK], 0);
  end;
  ArtTypTable.IndexName := 'Art';
end;


procedure TData.LoadModels(lUpdate: boolean=False);
var
  n: integer;
  v: Variant;
begin
  n := 0;
  StartWait;
  if not lUpdate then
  begin
    with ModelsTable do
    begin
      Close;
      EmptyTable;
      Open;
    end;
  end;
  TypesTable.IndexName := 'Model';
  CdsTextsTable.Open;
  Main.ShowProgrInfo('Загрузка моделей: 0');
  Application.ProcessMessages;
  try
    with ADODataSet do
    begin
//      CommandText := 'SELECT * FROM TOF_MODELS'#13#10 +
//                     'WHERE MOD_PC = 1';
      CommandText := 'SELECT * FROM TOF_MODELS';
      Open;
      while not Eof do
      begin
        if TypesTable.Locate('Mod_id', FieldByName('MOD_ID').AsInteger, []) and
           (not ModelsTable.Locate('Mod_id', FieldByName('MOD_ID').AsInteger, [])) then
        begin
          ModelsTable.Append;
          ModelsTable.FieldByName('Mod_id').Value := FieldByName('MOD_ID').AsInteger;
          ModelsTable.FieldByName('Mfa_id').Value := FieldByName('MOD_MFA_ID').AsInteger;
          ModelsTable.FieldByName('Pcon_start').Value := FieldByName('MOD_PCON_START').AsInteger;
          ModelsTable.FieldByName('Pcon_end').Value := FieldByName('MOD_PCON_END').AsInteger;
          v := CdsTextsTable.Lookup('CDS_ID', FieldByName('MOD_CDS_ID').AsInteger, 'Tex_text');
          if v <> NULL then
            ModelsTable.FieldByName('Tex_text').AsString := v
          else
            ModelsTable.FieldByName('Tex_text').AsString := '';

          ModelsTable.Post;
          Inc(n);
          if n mod 100 = 0 then
            Main.ShowProgrInfo('Загрузка моделей: ' + IntToStr(n));
        end;
        Next;
      end;
      Close;
    end;
    StopWait;
    Main.ShowProgrInfo('');
  except
    StopWait;
    MessageDlg('Ошибка загрузки моделей!', mtError, [mbOK], 0);
  end;
  CdsTextsTable.Close;
  TypesTable.IndexName := '';
end;


procedure TData.LoadManufacturers(lUpdate: boolean=False);
var
  n: integer;
begin
  n := 0;
  StartWait;
  if not lUpdate then
  begin
    with ManufacturersTable do
    begin
      Close;
      EmptyTable;
      Open;
    end;
  end;
  ModelsTable.IndexName := 'Mfa';
  CdsTextsTable.Open;
  Main.ShowProgrInfo('Загрузка производителей: 0');
  Application.ProcessMessages;
  try
    with ADODataSet do
    begin
//      CommandText := 'SELECT MFA_ID, MFA_BRAND FROM TOF_MANUFACTURERS'#13#10 +
//                     'WHERE MFA_PC_MFC = 1';
      CommandText := 'SELECT MFA_ID, MFA_BRAND FROM TOF_MANUFACTURERS';
      Open;
      while not Eof do
      begin
        if ModelsTable.Locate('Mfa_id', FieldByName('MFA_ID').AsInteger, []) and
           (not ManufacturersTable.Locate('Mfa_id', FieldByName('MFA_ID').AsInteger, [])) then
        begin
          ManufacturersTable.Append;
          ManufacturersTable.FieldByName('Mfa_id').Value := FieldByName('MFA_ID').AsInteger;
          if FieldByName('MFA_BRAND').AsString = 'CITRO?N' then
            ManufacturersTable.FieldByName('Mfa_brand').Value := 'CITROEN'
          else
            ManufacturersTable.FieldByName('Mfa_brand').Value := FieldByName('MFA_BRAND').AsString;
          ManufacturersTable.FieldByName('Hide').Value := False;
          ManufacturersTable.Post;
          Inc(n);
          if n mod 10 = 0 then
            Main.ShowProgrInfo('Загрузка производителей: ' + IntToStr(n));
        end;
        Next;
      end;
      Close;
    end;
    StopWait;
    Main.ShowProgrInfo('');
  except
    StopWait;
    MessageDlg('Ошибка загрузки производителей!', mtError, [mbOK], 0);
  end;
  ModelsTable.IndexName := '';
  CdsTextsTable.Close;
end;

//[param] - грузим не через [002].tecdoc_id, а через [002].param_tdid
procedure TData.LoadCatDet(lUpdate: boolean = False);
var
  i, n, t, j, p: integer;
  fl, fl2: boolean;
  pars: array of integer;
  v: Variant;
begin
  n := 0;
  i := 0;
  t := 0;
  SetLength(pars, 0);
  StartWait;
  Main.ShowProgress('Загрузка подробностей товара(new): 0');
  Application.ProcessMessages;
  CatDetTable.Close;
  with XCatDetTable do
  begin
    if not lUpdate then
      EmptyTable;
    Open;
  end;
  with ADODataSet do          
  begin
    CommandText := 'SELECT * FROM TOF_ARTICLE_CRITERIA'#13#10 +
                   'WHERE ACR_ART_ID=:CAT_ID';
  end;
  DesTextsTable.Open;
  try
    with LoadCatTable do
    begin
      Open;
      First;
      Main.SetProgressMax(RecordCount);
      while not Eof do
      begin
        if (FieldByName('param_tdid').AsInteger <> 0) and
           (not XCatDetTable.Locate('Tecdoc_id',
                FieldByName('param_tdid').AsInteger, [])) then
        begin
          with ADODataSet do
          begin
            Parameters.ParamByName('CAT_ID').Value :=
                       LoadCatTable.FieldByName('param_tdid').AsInteger;
            Open;
            fl := True;
            SetLength(pars, 0);
            p := 0;
            while not Eof do
            begin
              if fl then
              begin
                Inc(t);
                fl := False;
              end;
              fl2 := False;
              for j := 0 to p - 1 do
              begin
                if pars[j] = FieldByName('ACR_CRI_ID').AsInteger then
                begin
                  fl2 := True;
                  break;
                end;
              end;
              if not fl2 then
              begin
                XCatDetTable.Append;
                XCatDetTable.FieldByName('Tecdoc_id').Value := FieldByName('ACR_ART_ID').AsInteger;
                XCatDetTable.FieldByName('Sort').Value := FieldByName('ACR_SORT').AsInteger;
                XCatDetTable.FieldByName('Param_id').Value := FieldByName('ACR_CRI_ID').AsInteger;
                if FieldByName('ACR_KV_DES_ID').AsInteger <> 0 then
                begin
                  v := DesTextsTable.Lookup('DES_ID', FieldByName('ACR_KV_DES_ID').AsInteger, 'Tex_text');
                  if v <> NULL then
                    XCatDetTable.FieldByName('Param_value').AsString := v
                  else
                    XCatDetTable.FieldByName('Param_value').AsString := '';
                end
                else
                  XCatDetTable.FieldByName('Param_value').Value := FieldByName('ACR_VALUE').AsString;
                XCatDetTable.Post;
                Inc(n);
                if n mod 100 = 0 then
                  Main.ShowProgrInfo('Загрузка подробностей товара(new): ' + IntToStr(t) + '/' + IntToStr(n));
                Inc(p);
                SetLength(pars, p);
                pars[p - 1] := FieldByName('ACR_CRI_ID').AsInteger;
              end;
              Next;
            end;
            Close;
          end;
        end;
        Inc(i);
        if i mod 100 = 0 then
          Main.CurrProgress(i);
        Next;
      end;
      Close;
    end;
    StopWait;
  except
    StopWait;
    MessageDlg('Ошибка загрузки подробностей товара(new)!', mtError, [mbOK], 0);
  end;
  SetLength(pars, 0);
  DesTextsTable.Close;
  XCatDetTable.Close;
  CatDetTable.Open;
  Main.HideProgress;
end;

//procedure TData.LoadCatTypDet(lUpdate: boolean = False);
//var
//  i, n, t, j, p: integer;
//  fl, fl2: boolean;
//  pars: array of integer;
//begin
//  n := 0;
//  i := 0;
//  t := 0;
//  SetLength(pars, 0);
//  StartWait;
//  Main.ShowProgress('Загрузка подробностей товара по типам: 0');
//  Application.ProcessMessages;
//  CatTypDetTable.Close;
//  with XCatTypDetTable do
//  begin
//    if not lUpdate then
//      EmptyTable;
//    Open;
//  end;
//  with ADODataSet do
//  begin
//    CommandText := 'SELECT * FROM TOF_ARTICLE_LIST_CRITERIA'#13#10 +
//                   'WHERE ALC_ALI_ART_ID=:CAT_ID';
//  end;
//  DesTextsTable.Open;
//  try
//    with LoadCatTable do
//    begin
//      Open;
//      First;
//      Main.SetProgressMax(RecordCount);
//      while not Eof do
//      begin
////        if (FieldByName('Tecdoc_id').AsInteger <> 0) and
////           ((not lUpdate) or (not XCatTypDetTable.Locate('Tecdoc_id',
////                          FieldByName('Tecdoc_id').AsInteger, []))) then
//        if (FieldByName('Tecdoc_id').AsInteger <> 0) then
//        begin
//          with ADODataSet do
//          begin
//            Parameters.ParamByName('CAT_ID').Value :=
//                       LoadCatTable.FieldByName('Tecdoc_id').AsInteger;
//            Open;
//            fl := True;
//            SetLength(pars, 0);
//            p := 0;
//            while not Eof do
//            begin
//              if fl then
//              begin
//                Inc(t);
//                fl := False;
//              end;
//              fl2 := False;
//              for j := 0 to p - 1 do
//              begin
//                if pars[j] = FieldByName('ALC_CRI_ID').AsInteger then
//                begin
//                  fl2 := True;
//                  break;
//                end;
//              end;
//              if not fl2 then
//              begin
//                XCatTypDetTable.Append;
//                XCatTypDetTable.FieldByName('Tecdoc_id').Value := FieldByName('ALC_ALI_ART_ID').AsInteger;
//                XCatTypDetTable.FieldByName('Typ_id').Value := FieldByName('ALC_TYP_ID').AsInteger;
//                XCatTypDetTable.FieldByName('Eng_id').Value := FieldByName('ALC_ENG_ID').AsInteger;
//                XCatTypDetTable.FieldByName('Sort1').Value := FieldByName('ALC_ALI_SORT').AsInteger;
//                XCatTypDetTable.FieldByName('Sort2').Value := FieldByName('ALC_SORT').AsInteger;
//                XCatTypDetTable.FieldByName('Param_id').Value := FieldByName('ALC_CRI_ID').AsInteger;
//                if FieldByName('ALC_KV_DES_ID').AsInteger <> 0 then
//                  XCatTypDetTable.FieldByName('Param_value').AsString :=
//                      DesTextsTable.Lookup('DES_ID', FieldByName('ALC_KV_DES_ID').AsInteger, 'Tex_text')
//                else
//                  XCatTypDetTable.FieldByName('Param_value').Value := FieldByName('ALC_VALUE').AsString;
//                XCatTypDetTable.Post;
//                Inc(n);
//                if n mod 100 = 0 then
//                  Main.ShowProgrInfo('Загрузка подробностей товара по типам: ' + IntToStr(t) + '/' + IntToStr(n));
//                Inc(p);
//                SetLength(pars, p);
//                pars[p - 1] := FieldByName('ALC_CRI_ID').AsInteger;
//              end;
//              Next;
//            end;
//            Close;
//          end;
//        end;
//        Inc(i);
//        if i mod 100 = 0 then
//          Main.CurrProgress(i);
//        Next;
//      end;
//      Close;
//    end;
//    StopWait;
//  except
//    StopWait;
//    MessageDlg('Ошибка загрузки подробностей товара по типам!', mtError, [mbOK], 0);
//  end;
//  SetLength(pars, 0);
//  DesTextsTable.Close;
//  XCatTypDetTable.Close;
//  CatTypDetTable.Open;
//  Main.HideProgress;
//end;


 procedure TData.LoadCatTableCalcFields(DataSet: TDataSet);
begin
  with Dataset do
  begin
       FieldByName('SaleQ').Value := FieldByName('saleQCalc').Value;
       if FieldByName('PriceQuant').AsCurrency > 0 then
         FieldByName('PriceItog').AsCurrency := FieldByName('PriceQuant').AsCurrency
        else
         FieldByName('PriceItog').AsCurrency := FieldByName('Price').AsCurrency;
  end;
end;

//[param] - грузим не через [002].tecdoc_id, а через [002].param_tdid
procedure TData.LoadCatTypDet(lUpdate: boolean = False);
var
  i, n, t, j, p: integer;
  fl, fl2: boolean;
  pars: array of array[1..2] of integer;
  v: Variant;
begin
  n := 0;
  i := 0;
  t := 0;
  SetLength(pars, 0);
  StartWait;
  Main.ShowProgress('Загрузка подробностей товара по типам(new): 0');
  Application.ProcessMessages;
  CatTypDetTable.Close;
  with XCatTypDetTable do
  begin
    if not lUpdate then
      EmptyTable;
    Open;
  end;
  with ADODataSet do
  begin
    CommandText := 'SELECT LA_ART_ID, LAT_TYP_ID, LAC_SORT, LAC_CRI_ID, LAC_VALUE, LAC_KV_DES_ID'#13#10 +
                   'FROM TOF_LINK_LA_TYP'#13#10 +
                   'JOIN TOF_LA_CRITERIA ON LAT_LA_ID = LAC_LA_ID'#13#10 +
                   'JOIN TOF_LINK_ART ON LAT_LA_ID = LA_ID'#13#10 +
                   'WHERE LA_ART_ID=:CAT_ID';
  end;
  DesTextsTable.Open;
  try
    with LoadCatTable do
    begin
      Open;
      First;
      Main.SetProgressMax(RecordCount);
      while not Eof do
      begin
        if (FieldByName('param_tdid').AsInteger <> 0) and
           (not XCatTypDetTable.Locate('Tecdoc_id', FieldByName('param_tdid').AsInteger, [])) then
//        if (FieldByName('param_tdid').AsInteger <> 0) then
        begin
          with ADODataSet do
          begin
            Parameters.ParamByName('CAT_ID').Value :=
                       LoadCatTable.FieldByName('param_tdid').AsInteger;
            Open;
            fl := True;
            SetLength(pars, 0);
            p := 0;
            while not Eof do
            begin
              if fl then
              begin
                Inc(t);
                fl := False;
              end;
              fl2 := False;
              for j := 0 to p - 1 do
              begin
                if (pars[j][1] = FieldByName('LAT_TYP_ID').AsInteger) and
                   (pars[j][2] = FieldByName('LAC_CRI_ID').AsInteger) then
                begin
                  fl2 := True;
                  break;
                end;
              end;
              if not fl2 then
              begin
                XCatTypDetTable.Append;
                XCatTypDetTable.FieldByName('Tecdoc_id').Value := FieldByName('LA_ART_ID').AsInteger;
                XCatTypDetTable.FieldByName('Typ_id').Value := FieldByName('LAT_TYP_ID').AsInteger;
                XCatTypDetTable.FieldByName('Sort').Value := FieldByName('LAC_SORT').AsInteger;
                XCatTypDetTable.FieldByName('Param_id').Value := FieldByName('LAC_CRI_ID').AsInteger;
                if FieldByName('LAC_KV_DES_ID').AsInteger <> 0 then
                begin
                  v := DesTextsTable.Lookup('DES_ID', FieldByName('LAC_KV_DES_ID').AsInteger, 'Tex_text');
                  if v <> NULL then
                    XCatTypDetTable.FieldByName('Param_value').AsString := v
                  else
                    XCatTypDetTable.FieldByName('Param_value').AsString := '';
                end
                else
                  XCatTypDetTable.FieldByName('Param_value').Value := FieldByName('LAC_VALUE').AsString;
                XCatTypDetTable.Post;
                Inc(n);
                if n mod 100 = 0 then
                  Main.ShowProgrInfo('Загрузка подробностей товара по типам(new): ' + IntToStr(t) + '/' + IntToStr(n));
                Inc(p);
                SetLength(pars, p);
                pars[p - 1][1] := FieldByName('LAT_TYP_ID').AsInteger;
                pars[p - 1][2] := FieldByName('LAC_CRI_ID').AsInteger;
              end;
              Next;
            end;
            Close;
          end;
        end;
        Inc(i);
        if i mod 100 = 0 then
          Main.CurrProgress(i);
        Next;
      end;
      Close;
    end;
    StopWait;
  except
    StopWait;
    MessageDlg('Ошибка загрузки подробностей товара по типам(new)!', mtError, [mbOK], 0);
  end;
  SetLength(pars, 0);
  DesTextsTable.Close;
  XCatTypDetTable.Close;
  CatTypDetTable.Open;
  Main.HideProgress;
end;

procedure TData.LoadCatParam(lUpdate: boolean=False);
var
  n: integer;
  v: Variant;
begin
  n := 0;
  StartWait;
  if not lUpdate then
  begin
    with CatParTable do
    begin
      Close;
      EmptyTable;
      Open;
    end;
  end;
  XCatDetTable.Open;
  DesTextsTable.Open;
  Main.ShowProgrInfo('Загрузка описаний параметров: 0');
  try
    with ADODataSet do
    begin
      CommandText := 'SELECT * FROM TOF_CRITERIA';
      Open;
      while not Eof do
      begin
        if not CatParTable.Locate('Param_id', FieldByName('CRI_ID').AsInteger, []) then
        begin
          CatParTable.Append;
          CatParTable.FieldByName('Param_id').Value := FieldByName('CRI_ID').AsInteger;
          v := DesTextsTable.Lookup('DES_ID', FieldByName('CRI_SHORT_DES_ID').AsInteger, 'Tex_text');
          if v <> NULL then
            CatParTable.FieldByName('Descr').Value := v
          else
            CatParTable.FieldByName('Descr').Value := '';
                         
          v := DesTextsTable.Lookup('DES_ID', FieldByName('CRI_DES_ID').AsInteger, 'Tex_text');
          if v <> NULL then
            CatParTable.FieldByName('Description').Value := v
          else
            CatParTable.FieldByName('Description').Value := '';

          CatParTable.FieldByName('Type').Value := Copy(FieldByName('CRI_TYPE').AsString, 1, 1);
          CatParTable.FieldByName('Interv').Value := FieldByName('CRI_IS_INTERVAL').AsInteger = 1;
          CatParTable.FieldByName('Param_id2').Value := FieldByName('CRI_SUCCESSOR').AsInteger;
          CatParTable.Post;
          Inc(n);
          if n mod 100 = 0 then
            Main.ShowProgrInfo('Загрузка описаний параметров: ' + IntToStr(n));
        end;
        Next;
      end;
      Close;
    end;
    Main.ShowProgrInfo('');
    StopWait;
  except
    StopWait;
    MessageDlg('Ошибка загрузки описаний параметров!', mtError, [mbOK], 0);
  end;
  DesTextsTable.Close;
  XCatDetTable.Close;
end;

//[pict]
//CatPictTable - этой таблицы не будет, нужно проставлять pict_id прямо в TDArtTable
procedure TData.LoadCatPict(lUpdate: boolean = False);
var
  i: integer;
  aQuery: TDBISAMQuery;
begin
  i := 0;
  StartWait;
  Main.ShowProgress('Загрузка кодов картинок(new)');

  if not lUpdate then
  begin
    Database.Execute('UPDATE [110] SET pict_id = 0 WHERE pict_id > 0');
    Database.Execute('UPDATE [002] SET pict_id = 0 WHERE pict_id > 0');
  end;

  with ADODataSet do
  begin
    CommandText := 'SELECT LGA_ART_ID, LGA_SORT, GRA_GRD_ID, GRA_TAB_NR'#13#10 +
                   'FROM TOF_LINK_GRA_ART INNER JOIN TOF_GRAPHICS ON LGA_GRA_ID = GRA_ID'#13#10 +
                   'WHERE (GRA_GRD_ID IS NOT NULL) AND (LGA_ART_ID=:CAT_ID)'#13#10 +
                   'ORDER BY LGA_SORT';
  end;
  
  try //except

    aQuery := TDBISAMQuery.Create(nil);
    aQuery.DatabaseName := Database.DatabaseName;
    //все IDшки tecdoc, для которых не заданы картинки
    aQuery.SQL.Text :=
      'select distinct cat.Tecdoc_id, cat.pict_id from [002] cat ' +
      'where cat.Tecdoc_id > 0 and cat.pict_id = 0 ';
    aQuery.Open;
    Main.SetProgressMax(aQuery.RecordCount);
    while not aQuery.Eof do //перебираем весь каталог
    begin
      ADODataSet.Parameters.ParamByName('CAT_ID').Value := aQuery.FieldByName('Tecdoc_id').AsInteger;
      ADODataSet.Open;
      try
        //грузим только первую по сортировке картинку - нужны ли все???
        if not ADODataSet.Eof then
        begin
          Database.Execute(
            ' UPDATE [110] SET pict_id = ' + ADODataSet.FieldByName('GRA_GRD_ID').AsString +
            ' , pict_nr = ' + ADODataSet.FieldByName('GRA_TAB_NR').AsString +
            ' WHERE pict_id = 0 AND art_id = ' + aQuery.FieldByName('Tecdoc_id').AsString
          );
          Database.Execute(
            ' UPDATE [002] SET pict_id = ' + ADODataSet.FieldByName('GRA_GRD_ID').AsString +
            ' WHERE pict_id = 0 AND Tecdoc_id = ' + aQuery.FieldByName('Tecdoc_id').AsString
          );
        end;
      finally
        ADODataSet.Close;
      end;

      aQuery.Next;

      Inc(i);
      if i mod 100 = 0 then
        Main.CurrProgress(i);

    end; //while
    aQuery.Close;
    aQuery.Free;

    //чистка мусора - картинок на кот. никто не ссылается
    //Database.Execute(' DELETE FROM [027] WHERE pict_id NOT IN ( SELECT pict_id FROM [110] ) ');

    StopWait;
  except
    StopWait;
    MessageDlg('Ошибка загрузки кодов картинок(new)!', mtError, [mbOK], 0);
  end;
  Main.HideProgress;
end;

procedure TData.LoadCatPict_opt(lUpdate: boolean = False);
var
  i: integer;
  aQuery: TDBISAMQuery;
begin
  i := 0;
  StartWait;
  Main.ShowProgress('Загрузка кодов картинок(new)');

  if not lUpdate then
  begin
    Database.Execute('UPDATE [110] SET pict_id = 0 WHERE pict_id > 0');
    Database.Execute('UPDATE [002] SET pict_id = 0 WHERE pict_id > 0');
  end;

  with ADODataSet do
  begin
    CommandText := 'SELECT LGA_ART_ID, LGA_SORT, GRA_GRD_ID, GRA_TAB_NR'#13#10 +
                   'FROM TOF_LINK_GRA_ART INNER JOIN TOF_GRAPHICS ON LGA_GRA_ID = GRA_ID'#13#10 +
                   'WHERE (GRA_GRD_ID IS NOT NULL) AND (LGA_ART_ID=:CAT_ID)'#13#10 +
                   'ORDER BY LGA_SORT';
  end;

  try //except
    TDArtTable.Close;
    TDArtTable.IndexName := 'Art';
    TDArtTable.Open;

    LoadCatTable.Open;
    LoadCatTable.First;
    Main.SetProgressMax(LoadCatTable.RecordCount);
    while not LoadCatTable.Eof do //перебираем весь каталог
    begin
      if (LoadCatTable.FieldByName('Tecdoc_id').AsInteger > 0) and (LoadCatTable.FieldByName('pict_id').AsInteger = 0) then
      begin
        ADODataSet.Parameters.ParamByName('CAT_ID').Value := LoadCatTable.FieldByName('Tecdoc_id').AsInteger;
        ADODataSet.Open;
        try
          //грузим только первую по сортировке картинку - нужны ли все???
          if not ADODataSet.Eof then
          begin
            LoadCatTable.Edit;
            LoadCatTable.FieldByName('pict_id').AsInteger := ADODataSet.FieldByName('GRA_GRD_ID').AsInteger;
            LoadCatTable.Post;

            if TDArtTable.Locate('art_id', LoadCatTable.FieldByName('Tecdoc_id').AsInteger, []) then
              while (not TDArtTable.Eof) and (TDArtTable.FieldByName('Art_id').AsInteger = LoadCatTable.FieldByName('Tecdoc_id').AsInteger) do
              begin
                if TDArtTable.FieldByName('Pict_id').AsInteger = 0 then
                begin
                  TDArtTable.Edit;
                  TDArtTable.FieldByName('Pict_id').AsInteger := ADODataSet.FieldByName('GRA_GRD_ID').AsInteger;
                  TDArtTable.FieldByName('pict_nr').AsInteger := ADODataSet.FieldByName('GRA_TAB_NR').AsInteger;
                  TDArtTable.Post;
                end;
                TDArtTable.Next;
              end;
          end;
        finally
          ADODataSet.Close;
        end;
      end;

      LoadCatTable.Next;

      Inc(i);
      if i mod 100 = 0 then
        Main.CurrProgress(i);
    end; //while
    LoadCatTable.Close;
    TDArtTable.Close;
    TDArtTable.IndexName := '';

    //чистка мусора - картинок на кот. никто не ссылается
    //Database.Execute(' DELETE FROM [027] WHERE pict_id NOT IN ( SELECT pict_id FROM [110] ) ');

    StopWait;
  except
    StopWait;
    MessageDlg('Ошибка загрузки кодов картинок(new)!', mtError, [mbOK], 0);
  end;
  Main.HideProgress;
end;

procedure TData.LoadPict(lUpdate: boolean = False);
var
  i, n: integer;
  aQuery: TDBISAMQuery;
begin
  n := 0;
  i := 0;
  StartWait;
  Main.ShowProgress('Загрузка картинок(new): 0');
  Application.ProcessMessages;
  with PictTable do
  begin
    if not lUpdate then
    begin
      Close;
      EmptyTable;
      Open;
    end;
  end;

  try //except
    aQuery := TDBISAMQuery.Create(nil);
    try //finally
      aQuery.DatabaseName := Database.DatabaseName;

{
/* 40 sec
SELECT DISTINCT art.pict_id, art.pict_nr FROM [110] art
LEFT JOIN [027] pic ON (pic.Pict_id = art.pict_id)
LEFT JOIN [002] cat ON (cat.Pict_id = art.pict_id)
WHERE pic.Pict_id is NULL AND
      cat.Pict_id is NOT NULL AND
      art.pict_id > 0 AND
      art.pict_nr > 0
*/
/* 23 sec
SELECT DISTINCT pict_id, pict_nr FROM [110]
WHERE pict_id > 0 AND
      pict_nr > 0 AND
      pict_id in (select pict_id from [002]) AND
      pict_id NOT IN (select pict_id from [027])
*/
}

      aQuery.SQL.Text :=
        ' SELECT DISTINCT pict_id, pict_nr FROM [110]      ' +
        ' WHERE pict_id > 0 AND                            ' +
        '       pict_nr > 0 AND                            ' +
        '       pict_id in (select pict_id from [002]) AND ' +
        '       pict_id NOT IN (select pict_id from [027]) ';
      aQuery.Open;
      Main.SetProgressMax(aQuery.RecordCount);

      //[pict-OK] CatPictTable - этой таблицы не будет, загружать по таблице артикулов TDArtTable
      while not aQuery.Eof do
      begin
        //если картинки нет - добавляем из tecdoc'а
        //if not PictTable.Locate('Pict_id', aQuery.FieldByName('pict_id').AsInteger, []) then
        begin
          with ADODataSet do
          begin
            CommandText := 'SELECT GRD_ID, GRD_GRAPHIC'#13#10 +
                   'FROM TOF_GRA_DATA_' + aQuery.FieldByName('pict_nr').AsString + #13#10 +
                   'WHERE GRD_ID=' + aQuery.FieldByName('Pict_id').AsString;
            Open;
            if not Eof then
            begin
              PictTable.Append;
              PictTable.FieldByName('Pict_id').Value := FieldByName('GRD_ID').AsInteger;
              PictTable.FieldByName('Pict_data').Value := FieldByName('GRD_GRAPHIC').Value;
              PictTable.Post;
              Inc(n);
              if n mod 10 = 0 then
                Main.ShowProgrInfo('Загрузка картинок(new): ' + IntToStr(n) + ' из ' + IntToStr(aQuery.RecordCount));
            end;
            Close;
          end;
        end;
        
        Inc(i);
        if i mod 10 = 0 then
          Main.CurrProgress(i);

        aQuery.Next;
      end;
      
    finally
      aQuery.Free;
    end;

    StopWait;
  except
    StopWait;
    MessageDlg('Ошибка загрузки картинок(new)!', mtError, [mbOK], 0);
  end;
  Main.HideProgress;
end;

//[typ] - грузим не через [002].tecdoc_id, а через [002].typ_tdid
procedure TData.LoadPrimen;
var
  i: Integer;
  s: string;
  sValue: string;
  aListTypes: TStrings;
begin
  PrimenTable.DisableControls;
  PrimenTable.AfterScroll := nil;
  try

    with PrimenTable do
    begin
      Close;
      EmptyTable;
      Open;
    end;

    if CatalogDataSource.DataSet.FieldByName('typ_tdid').AsInteger = 0 then
      Exit;

    if CatalogDataSource.DataSet <> CatalogTable then
    begin
      if CatalogTable.IndexName <> '' then
        CatalogTable.IndexName := '';

      if CatalogDataSource.DataSet.FieldByName('Cat_id').AsInteger  <> CatalogTable.FieldByName('Cat_id').AsInteger then
        if not CatalogTable.FindKey([CatalogDataSource.DataSet.FieldByName('Cat_id').AsInteger]) then
          Exit;
    end;

    sValue := CatalogTable.FieldByName('Primen').Value;

    aListTypes := TStringList.Create;
    try
      aListTypes.CommaText := sValue;
      for i := 0 to aListTypes.Count - 1 do
        if ( StrToIntDef(aListTypes[i], 0) > 0 ) and
           ( TypesTable.Locate('Typ_id', aListTypes[i], []) ) and
           ( not TypesTable.FieldByName('MfaHide').AsBoolean ) then
        begin
          PrimenTable.Append;
          PrimenTable.FieldByName('Typ_id').Value := TypesTable.FieldByName('Typ_id').AsInteger;
          PrimenTable.FieldByName('Description').Value := TypesTable.FieldByName('TypeDescr').AsString;
          PrimenTable.FieldByName('Pcon').Value := TypesTable.FieldByName('PconText1').AsString + '-' + TypesTable.FieldByName('PconText2').AsString;
          PrimenTable.FieldByName('Hp').Value := TypesTable.FieldByName('Hp_from').AsInteger;
          PrimenTable.FieldByName('Cylinders').Value := TypesTable.FieldByName('Cylinders').AsInteger;
          PrimenTable.FieldByName('Fuel').Value := TypesTable.FieldByName('FuelText').AsString;
          PrimenTable.FieldByName('Eng_codes').Value := TypesTable.FieldByName('Eng_codes').AsString;
          PrimenTable.Post;
        end;
    finally
      aListTypes.Free;
    end;

    with PrimenTable do
    begin
      if Auto_type <> 0 then
        Locate('Typ_Id', Auto_type, [])
      else
        First;
    end;

  finally
    PrimenTable.AfterScroll := PrimenTableAfterScroll;
    PrimenTableAfterScroll(PrimenTable);
    Main.ParamTypGrid.Datasource := CatTypDetDataSource;
    PrimenTable.EnableControls;
  end;
end;

procedure TData.LoadBases;
var
  rn: Integer;
  aCatalogActive, aAnalogActive: Boolean;
  aDS: TDataSet;
  FieldCurr:TCurrencyField;
  FieldInt:TIntegerField;
  FieldText:TStringField;
  FieldFloat: TFloatField;
  numSklad: string;
begin
  TableBases.DisableControls;
  rn := TableBases.RecNo;
  if TableBases.Locate('Activate;Basic', VarArrayOf([1, 1]), []) then
  begin
    sFieldGlobalName := 'QuantLocal';//'Quantity2' + FieldByName('CODE').AsString;
    numSklad := TableBases.FieldByName('Code').AsString;

    aCatalogActive := CatalogDataSource.DataSet.Active;
    aAnalogActive := AnalogTable.Active;
    try
      CatalogDataSource.DataSet.Close;
      //AnalogTable.Close;

      AnalogIDTable.Close;
      AnalogMainTable_1.Close;
      AnalogMainTable_2.Close;
      AnalogMainTable_3.Close;
      AnalogMainTable_4.Close;
      AnalogMainTable_5.Close;
      
      aDS := SkladQuants;//TDataSet(FindComponent('QuantTable' + TableBases.FieldByName('CODE').AsString)); 


      if CatFilterTable.Fields.FindField('PriceQuantSklad') <> nil then
        CatalogDataSource.DataSet.FieldByName('PriceQuantSklad').LookupDataSet := aDS;
{
 if AnalogTable.Fields.FindField('PriceQuantSklad') <> nil then
        AnalogDataSource.DataSet.FieldByName('PriceQuantSklad').LookupDataSet := aDS;
 }
      if AnalogMainTable_1.Fields.FindField('PriceQuantSklad') <> nil then
        AnalogMainTable_1.FieldByName('PriceQuantSklad').LookupDataSet := aDS;
      if AnalogMainTable_2.Fields.FindField('PriceQuantSklad') <> nil then
        AnalogMainTable_2.FieldByName('PriceQuantSklad').LookupDataSet := aDS;
      if AnalogMainTable_3.Fields.FindField('PriceQuantSklad') <> nil then
        AnalogMainTable_3.FieldByName('PriceQuantSklad').LookupDataSet := aDS;
      if AnalogMainTable_4.Fields.FindField('PriceQuantSklad') <> nil then
        AnalogMainTable_4.FieldByName('PriceQuantSklad').LookupDataSet := aDS;
      if AnalogMainTable_5.Fields.FindField('PriceQuantSklad') <> nil then
        AnalogMainTable_5.FieldByName('PriceQuantSklad').LookupDataSet := aDS;

      XCatTable.Close;
      if XCatTable.Fields.FindField('PriceQuantSklad') <> nil then
        XCatTable.FieldByName('PriceQuantSklad').LookupDataSet := aDS;


      if XCatTable.Fields.FindField('PriceQuantSklad') = nil then
      begin
        FieldCurr:=TCurrencyField.Create(nil);
        FieldCurr.FieldName := 'PriceQuantSklad';
        FieldCurr.Name := XCatTable.Name + 'PriceQuantSklad';
        FieldCurr.KeyFields := 'Cat_id';
        FieldCurr.LookupDataSet := aDS; //GetQuantsTableByNum(StrToInt(GetQuantsNumber));
        FieldCurr.LookupKeyFields := 'Cat_id';
        FieldCurr.LookupResultField := 'Price';
        FieldCurr.DisplayFormat := ',0.00';
        FieldCurr.FieldKind := fkLookup;
        FieldCurr.DataSet := XCatTable;
      end;
      XCatTable.Open;
{     if AnalogTable.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := AnalogTable.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'An_id';
       FieldCurr.LookupDataSet := aDS;//GetQuantsTableByNum(StrToInt(GetQuantsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := AnalogTable;
     end;}
     if AnalogMainTable_1.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := AnalogMainTable_1.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'An_id';
       FieldCurr.LookupDataSet := aDS;//GetQuantsTableByNum(StrToInt(GetQuantsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := AnalogMainTable_1;
     end;
          if AnalogMainTable_2.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := AnalogMainTable_2.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'An_id';
       FieldCurr.LookupDataSet := aDS;//GetQuantsTableByNum(StrToInt(GetQuantsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := AnalogMainTable_2;
     end;
          if AnalogMainTable_3.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := AnalogMainTable_3.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'An_id';
       FieldCurr.LookupDataSet := aDS;//GetQuantsTableByNum(StrToInt(GetQuantsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := AnalogMainTable_3;
     end;
          if AnalogMainTable_4.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := AnalogMainTable_4.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'An_id';
       FieldCurr.LookupDataSet := aDS;//GetQuantsTableByNum(StrToInt(GetQuantsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := AnalogMainTable_4;
     end;
     if AnalogMainTable_5.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := AnalogMainTable_5.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'An_id';
       FieldCurr.LookupDataSet := aDS;//GetQuantsTableByNum(StrToInt(GetQuantsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := AnalogMainTable_5;
     end;

{     if CatFilterTable.Fields.FindField('PriceQuantSklad') = nil then
     begin
       FieldCurr:=TCurrencyField.Create(nil);
       FieldCurr.FieldName := 'PriceQuantSklad';
       FieldCurr.Name := CatFilterTable.Name + 'PriceQuantSklad';
       FieldCurr.KeyFields := 'Cat_id';
       FieldCurr.LookupDataSet := GetQuantsTableByNum(StrToInt(GetQuantsNumber));
       FieldCurr.LookupKeyFields := 'Cat_id';
       FieldCurr.LookupResultField := 'Price';
       FieldCurr.DisplayFormat := ',0.00';
       FieldCurr.FieldKind := fkLookup;
       FieldCurr.DataSet := CatFilterTable;
     end;
 }
    { if AnalogTable.Fields.FindField('QuantLocal') = nil then
     begin
       FieldFloat := TFloatField.Create(nil);
       FieldFloat.FieldName := 'QuantLocal';
       FieldFloat.Name := AnalogTable.Name + 'QuantLocal';
       FieldFloat.KeyFields := 'An_id';
       FieldFloat.LookupDataSet := aDS;
       FieldFloat.LookupKeyFields := 'Cat_id';
       FieldFloat.LookupResultField := 'Q' + numSklad; //'Quantity';
       FieldFloat.FieldKind := fkLookup;
       FieldFloat.DataSet := AnalogTable;
     end;  }

     if AnalogMainTable_1.Fields.FindField('QuantLocal') = nil then
     begin
       FieldFloat := TFloatField.Create(nil);
       FieldFloat.FieldName := 'QuantLocal';
       FieldFloat.Name := AnalogMainTable_1.Name + 'QuantLocal';
       FieldFloat.KeyFields := 'An_id';
       FieldFloat.LookupDataSet := aDS;
       FieldFloat.LookupKeyFields := 'Cat_id';
       FieldFloat.LookupResultField := 'Q' + numSklad; //'Quantity';
       FieldFloat.FieldKind := fkLookup;
       FieldFloat.DataSet := AnalogMainTable_1;
     end;
         if AnalogMainTable_2.Fields.FindField('QuantLocal') = nil then
     begin
       FieldFloat := TFloatField.Create(nil);
       FieldFloat.FieldName := 'QuantLocal';
       FieldFloat.Name := AnalogMainTable_2.Name + 'QuantLocal';
       FieldFloat.KeyFields := 'An_id';
       FieldFloat.LookupDataSet := aDS;
       FieldFloat.LookupKeyFields := 'Cat_id';
       FieldFloat.LookupResultField := 'Q' + numSklad; //'Quantity';
       FieldFloat.FieldKind := fkLookup;
       FieldFloat.DataSet := AnalogMainTable_2;
     end;
         if AnalogMainTable_3.Fields.FindField('QuantLocal') = nil then
     begin
       FieldFloat := TFloatField.Create(nil);
       FieldFloat.FieldName := 'QuantLocal';
       FieldFloat.Name := AnalogMainTable_3.Name + 'QuantLocal';
       FieldFloat.KeyFields := 'An_id';
       FieldFloat.LookupDataSet := aDS;
       FieldFloat.LookupKeyFields := 'Cat_id';
       FieldFloat.LookupResultField := 'Q' + numSklad; //'Quantity';
       FieldFloat.FieldKind := fkLookup;
       FieldFloat.DataSet := AnalogMainTable_3;
     end;
         if AnalogMainTable_4.Fields.FindField('QuantLocal') = nil then
     begin
       FieldFloat := TFloatField.Create(nil);
       FieldFloat.FieldName := 'QuantLocal';
       FieldFloat.Name := AnalogMainTable_4.Name + 'QuantLocal';
       FieldFloat.KeyFields := 'An_id';
       FieldFloat.LookupDataSet := aDS;
       FieldFloat.LookupKeyFields := 'Cat_id';
       FieldFloat.LookupResultField := 'Q' + numSklad; //'Quantity';
       FieldFloat.FieldKind := fkLookup;
       FieldFloat.DataSet := AnalogMainTable_4;
     end;
         if AnalogMainTable_5.Fields.FindField('QuantLocal') = nil then
     begin
       FieldFloat := TFloatField.Create(nil);
       FieldFloat.FieldName := 'QuantLocal';
       FieldFloat.Name := AnalogMainTable_5.Name + 'QuantLocal';
       FieldFloat.KeyFields := 'An_id';
       FieldFloat.LookupDataSet := aDS;
       FieldFloat.LookupKeyFields := 'Cat_id';
       FieldFloat.LookupResultField := 'Q' + numSklad; //'Quantity';
       FieldFloat.FieldKind := fkLookup;
       FieldFloat.DataSet := AnalogMainTable_5;
     end;

     if CatFilterTable.Fields.FindField('QuantLocal') <> nil then
       CatFilterTable.Fields.FindField('QuantLocal').Destroy;

     if CatFilterTable.Fields.FindField('QuantLocal') = nil then
     begin
       FieldFloat := TFloatField.Create(nil);
       FieldFloat.FieldName := 'QuantLocal';
       FieldFloat.Name := CatFilterTable.Name + 'QuantLocal';
       FieldFloat.KeyFields := 'Cat_id';
       FieldFloat.LookupDataSet := aDS;
       FieldFloat.LookupKeyFields := 'Cat_id';
       FieldFloat.LookupResultField := 'Q' + numSklad; //'Quantity';
       FieldFloat.FieldKind := fkLookup;
       FieldFloat.DataSet := CatFilterTable;
     end;

     if CatFilterTable.Fields.FindField('Limit') <> nil then
       CatFilterTable.Fields.FindField('Limit').Destroy;

     if CatFilterTable.Fields.FindField('Limit') = nil then
     begin
       FieldInt := TIntegerField.Create(nil);
       FieldInt.FieldName := 'Limit';
       FieldInt.Name := CatFilterTable.Name + 'Limit';
       FieldInt.KeyFields := 'Cat_id';
       FieldInt.LookupDataSet := aDS; //вычисляется по текущей базе в LoadBases
       FieldInt.LookupKeyFields := 'Cat_id';
       FieldInt.LookupResultField := 'L' + numSklad; //'Quantity';
       FieldInt.FieldKind := fkLookup;
       FieldInt.DataSet := CatFilterTable;
     end;

      CatalogDataSource.DataSet.FieldByName(sFieldGlobalName).LookupDataSet := aDS;
      CatalogDataSource.DataSet.FieldByName('Limit').LookupDataSet := aDS;

//     ShowMEssage(AnalogTable.FieldByName(sFieldGlobalName).LookupResultField);
//     AnalogTable.FieldByName(sFieldGlobalName).LookupDataSet := aDS;


      Main.sNameGlobalBase := TableBases.FieldByName('Name').AsString;
      Main.sNameGlobalQuants := 'QuantLocal';//'Quantity2' + FieldByName('CODE').AsString;
      Main.sNameGlobalClient := TableBases.FieldByName('Client').AsString;
      Main.sNameGlobalID := TableBases.FieldByName('Code').AsString;
    finally
      CatalogDataSource.DataSet.Active := aCatalogActive;
     // AnalogTable.Active := aAnalogActive;
      AnalogIDTable.Open;
      AnalogMainTable_1.Open;
      AnalogMainTable_2.Open;
      AnalogMainTable_3.Open;
      AnalogMainTable_4.Open;
      AnalogMainTable_5.Open;
    end;
  end;
  TableBases.RecNo := rn;
  TableBases.EnableControls;

  if Data <> nil then
    Main.BasesChanged;
  if aCatalogActive then
    LoadTree;
end;


procedure TData.SetQuantsLargeMode(aLarge: Boolean);
var
  i: Integer;
  s: string;
  aCatalog: TDataSet;
  aNewField: TFloatField;
  aField: TField;
  aCatalogActive: Boolean;
  aAnalogActive: Boolean;
begin
  Main.QuantsLargeMode := aLarge;

  aCatalog := CatalogDataSource.DataSet;
  aCatalogActive := aCatalog.Active;
  aAnalogActive := AnalogIDTable.Active;
  aCatalog.Close;
  AnalogIDTable.Close;
  AnalogMainTable_1.Close;
  AnalogMainTable_2.Close;
  AnalogMainTable_3.Close;
  AnalogMainTable_4.Close;
  AnalogMainTable_5.Close;
  memAnalog.Close;
  try
    for i := 2 to cQuantBasesCount do
    begin
      s := 'Quantity2' + IntToStr(i);
      aField := aCatalog.Fields.FindField(s);
      if aField = nil then
      begin
        if aLarge then
        begin
          aNewField := TFloatField.Create(nil);
          aNewField.FieldName := s;
          aNewField.Name := aCatalog.Name + s;
          aNewField.KeyFields := 'Cat_id';
          aNewField.LookupDataSet := SkladQuants; //QuantTableJoin;
          aNewField.LookupKeyFields := 'Cat_id';
          aNewField.LookupResultField := 'Q' + IntToStr(i);

          aNewField.FieldKind := fkLookup;
          aNewField.DataSet := aCatalog;


          aNewField := TFloatField.Create(nil);
          aNewField.FieldName := s;
          aNewField.Name := aCatalog.Name + s;
          aNewField.KeyFields := 'An_id';
          aNewField.LookupDataSet := SkladQuants;//QuantTableJoin;
          aNewField.LookupKeyFields := 'Cat_id';
          aNewField.LookupResultField := 'Q' + IntToStr(i);

          aNewField.FieldKind := fkLookup;
          aNewField.DataSet := memAnalog;
        end;
      end
      else
        if not aLarge then
        begin
          aCatalog.Fields.Remove(aField);
//          AnalogTable.Fields.Remove(AnalogTable.Fields.FindField(s));
            memAnalog.Fields.Remove(memAnalog.Fields.FindField(s));

        end;
    end;
  finally
    aCatalog.Active := aCatalogActive;
//    AnalogTable.Active := aAnalogActive;
    AnalogMainTable_1.Active := aAnalogActive;
    AnalogMainTable_2.Active := aAnalogActive;
    AnalogMainTable_3.Active := aAnalogActive;
    AnalogMainTable_4.Active := aAnalogActive;
    AnalogMainTable_5.Active := aAnalogActive;
    AnalogIDTable.Active := aAnalogActive;

    if aCatalogActive then
      LoadTree;
  end;
end;

procedure TData.LoadBrandReplTable;
var
  fname, s, br, rp: string;
begin

  TestTable(BrandReplTable);
  BrandReplTable.Open;
  fname := GetAppDir + 'BrandRpl.txt';
  if not FileExists(fname) then
    exit;
  AssignFile(F, fname);
  Reset(F);
  while not System.Eof(F) do
  begin
    Readln(F, s);
    br := ExtractDelimited(2,  s, [';']);
    rp := ExtractDelimited(1,  s, [';']);
    with BrandReplTable do
    begin
      Append;
      FieldByName('Brand').Value := br;
      FieldByName('Repl_brand').Value := rp;
      Post;
    end;
  end;
  CloseFile(F);

end;

//[typ] - грузим не через [002].tecdoc_id, а через [002].typ_tdid
procedure TData.LoadPrimenMemo;
var
  s: string;
  cnt: integer;
begin
  Main.ShowProgress;
  Main.ShowProgrInfo('Загрузка списка авто в каталог(new)...');
  LoadArtTypTable.Open;
//  TableCarFilter.Close;
  TableCarFilter.EmptyTable;
  TableCarFilter.Open;
  with TypesTable do
  begin
      first;
      cnt:=0;
      while not EOF do
      begin
        if not FieldByName('MfaHide').AsBoolean then
          begin
           TableCarFilter.Append;
           TableCarFilter.FieldByName('Type_ID').Value:= FieldByName('Typ_id').AsInteger;
          TableCarFilter.Post;
           end;

        if cnt <> (RecNo*100) div RecordCount then
          begin
            cnt := (RecNo*100) div RecordCount;
            Main.CurrProgress(cnt);
            Application.ProcessMessages;
          end;

        Next;

      end;
      //MfaHide
  end;
  Main.HideProgress;



  Main.ShowProgress;
  Main.ShowProgrInfo('Загрузка применяемости в каталог(new)...');

  with LoadCatTable do
  begin
    Open;
    cnt := 0;
    First;
    while not Eof do
    begin
      if FieldByName('typ_tdid').AsInteger <> 0 then
      begin
        s := '';
        with LoadArtTypTable do
        begin
          SetRange([LoadCatTable.FieldByName('typ_tdid').AsInteger], [LoadCatTable.FieldByName('typ_tdid').AsInteger]);
          First;
          while not Eof do
          begin
            if  TableCarFilter.Locate('Type_ID', LoadArtTypTable.FieldByName('Typ_id').AsInteger, []) then
            begin
              s := s + LoadArtTypTable.FieldByName('Typ_id').AsString+',';
              TableCarFilter.Edit;
              if Length(TableCarFilter.FieldByName('Cat_ID').AsString) > 0 then
                TableCarFilter.FieldByName('Cat_ID').Value:= TableCarFilter.FieldByName('Cat_ID').AsString +', '+ LoadCatTable.FieldByName('Cat_ID').AsString
              else
                TableCarFilter.FieldByName('Cat_ID').Value:= loadCatTable.FieldByName('Cat_ID').AsString;
              TableCarFilter.Post;
            end;
            Next;
          end;
          LoadCatTable.Edit;
          LoadCatTable.FieldByName('Primen').Value := s;
          LoadCatTable.Post;
          CancelRange;
        end;
      end;
      if cnt <> (RecNo*100) div RecordCount then
      begin
              cnt := (RecNo*100) div RecordCount;
              Main.CurrProgress(cnt);
              Application.ProcessMessages;
      end;

      Next;
    end;
  end;
  LoadArtTypTable.Close;
  TableCarFilter.Close;
  Main.HideProgress;
//  TableCarFilter.Open;
end;


procedure TData.UnknownBrands;
var
  cnt, i, total: integer;
begin
  StartWait;
  StartLog('UnknownBrands.txt');
  BrandTable.IndexName := 'Descr';
  with TDBrandTable do
  begin
    IndexName := 'Descr';
    Open;
    First;
    total := RecordCount;
    cnt := 0;
    Main.ShowProgress('Поиск нераспознанных брендов...', total);
    i := 0;
    while not Eof do
    begin
      if not BrandTable.FindKey([FieldByName('Brand_descr').AsString]) then
      begin
        Inc(cnt);
        WLog(FieldByName('Brand_descr').AsString);
      end;
      Inc(i);
      if i mod 10 = 0 then
        Main.CurrProgress(i);
      Next;
    end;
    Close;
    IndexName := '';
    Main.HideProgress;
  end;
  BrandTable.IndexName := 'BrandId';
  StopLog;
  StopWait;
  MessageDlg('Обнаружено позиций: ' + IntToStr(cnt) + ' из ' + IntToStr(total), mtInformation, [mbOK], 0);
end;


function ConfigTecdocSource(Modify: boolean = False): boolean;
var
  func: TSQLConfigDataSource;
  OdbccpHMODULE: HMODULE;
  drv: string;
  res: SmallInt;
  reg: TRegistry;
begin
  Result := False;
  drv := FindTecdocDriver;
  if drv = '' then
    exit;
  OdbccpHMODULE := LoadLibrary('odbccp32.dll');
  if OdbccpHMODULE = 0 then
    exit;
  func := GetProcAddress(OdbccpHMODULE, PChar('SQLConfigDataSource'));
  if @func = nil then
    exit;
  res := func(0, iif(Modify, 5, 4), drv,
                              'DSN=' + TECDOC_SOURCE +
                             ';Database=' + 'TECDOC_CD_' + Right(drv, 6) +
          ';Description=Tecdoc For ShateMPlus;Server=localhost;Port=;PWD=tcd_error_0;UID=tecdoc');
  if res <> 1 then
    WSysLog('Ошибка выполнения SQLConfigDataSource.')
  else
    WSysLog('Функция SQLConfigDataSource выполнена успешно.');
  FreeLibrary(OdbccpHMODULE);
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKey('\Software\ODBC\ODBC.INI\ODBC Data Sources', False) then
      reg.WriteString(TECDOC_SOURCE, drv);
    WSysLog('Запись в реестр \Software\ODBC\ODBC.INI\ODBC Data Sources: ' +
          TECDOC_SOURCE + '=' + drv);
  finally
    reg.CloseKey;
    FreeAndNil(reg);
  end;
  Result := (res = 1);
end;

function FindTecdocSource: boolean;
var
  reg: TRegistry;
  SrcLst: TStringList;
  i: integer;
  lFound: boolean;
begin
  SrcLst := TStringList.Create;
  lFound := False;
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKey('\Software\ODBC\ODBC.INI\ODBC Data Sources', False) then
    begin
      reg.GetValueNames(SrcLst);
      for i := 0 to SrcLst.Count - 1 do
        if SrcLst[i] = TECDOC_SOURCE then
        begin
          lFound := True;
          break;
        end;
    end;
  finally
    reg.CloseKey;
    FreeAndNil(reg);
    SrcLst.Free;
  end;
  Result := lFound;
end;

function FindTecdocDriver: string;
var
  reg: TRegistry;
  DrvLst: TStringList;
  i, len: integer;
  drv: string;
begin
  DrvLst := TStringList.Create;
  drv := '';
  len := Length(TRANSBASE_PREFIX);
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKey('\Software\ODBC\ODBCINST.INI\ODBC Drivers', False) then
    begin
      reg.GetValueNames(DrvLst);
      for i := 0 to DrvLst.Count - 1 do
        if Copy(DrvLst[i], 1, len) = TRANSBASE_PREFIX then
        begin
          drv := DrvLst[i];
          break;
        end;
    end;
  finally
    reg.CloseKey;
    FreeAndNil(reg);
    DrvLst.Free;
  end;                                     
  Result := drv;
end;

function TData.StartTecdoc: boolean;
begin
  Result := False;
  if not Main.AdminMode then
    exit;
  if not FindTecdocSource then
  begin
    WSysLog('Источник Tecdoc не найден - будет создан новый.');
    if not ConfigTecdocSource then
    begin
      WSysLog('Попытка создать источник не удалась.');
      exit;
    end;
  end;
  try
    ADOConnection.Connected := True;
    Result := True;
  except
    WSysLog('Неудачное соединение. Источник будет исправлен.');
    if ConfigTecdocSource(True) then
    begin
      try
        ADOConnection.Connected := True;
        Result := True;
      except
        WSysLog('Попытка исправить источник не удалась.');
        Result := False;
      end;
    end;
  end;
end;


procedure TData.LoadTimerTimer(Sender: TObject);    //[kri] ???
begin
  ParamTable.Refresh;
  if ParamTable.FieldByName('Loading').AsBoolean then
  begin
    if not Loading_flag then
    begin
      //Main.TimerUpdate.Enabled := False;
      Loading_flag := True;
      QuantTable.Close;
      Main.UpdateMenu.Visible := FALSE;
     // AllClose;
      CatalogTable.AfterScroll := nil;
     // ShowLoadingMess;

      with main do //!!! [kri] переписать
      begin
        if not bTerminate then
        begin
          DownloadThrd.Terminate;
          bTerminate := TRUE;
          Sleep(200);
          CloseStatusColums;
        end;

        if Assigned(UpdateThrd) then
        begin
          UpdateThrd.Terminate;
          Sleep(200);
          CloseStatusColums;
        end
      end;
    end;
  end
  else
    if Loading_flag then
    begin
      Main.UpdateMenu.Visible := TRUE;
      Loading_flag := False;
      QuantTable.Open;
      with Main do
      begin
        Main.LockAutoUpdate(False);
      {
        if (Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdate').AsBoolean)
          and((Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdateProg').AsBoolean)
          or(Data.ParamDataSource.DataSet.FieldByName('bPasiveUpdateQuants').AsBoolean))  then
        begin
          TimerUpdate.Enabled := TRUE;
        end;
      }  
      end;
//    AllOpen;
//    LoadTree;
      CatalogDataSource.DataSet.AfterScroll := Data.CatalogTableAfterScroll;
      QuantTable.Open;
      Main.UpdateMenu.Visible := True;
    end;
end;


procedure TData.ShowLoadingMess;
begin
  LoadingMess := TLoadingMess.Create(Application);
  LoadingMess.ShowModal;
end;


procedure TData.HideLoadingMess;
begin
  LoadingMess.ModalResult := mrOk;
end;


procedure TData.LoadingLock;
var
  F: Text;
begin
  LoadTimer.Enabled := False;
  with ParamTable do
  begin
    Edit;
    FieldByName('Loading').Value := True;
    FieldByName('Loading_comp').Value := GetComputer;
    Post;
  end;
  AssignFile(F, GetAppDir + LOCK_FILE);
  Rewrite(F);
  CloseFile(F);
  Sleep(2000);
end;

procedure TData.LoadingUnlock;
begin
  with ParamTable do
  begin
    Edit;
    FieldByName('Loading').Value := False;
    FieldByName('Loading_comp').Value := '';
    Post;
  end;
  SysUtils.DeleteFile(GetAppDir + LOCK_FILE);
  LoadTimer.Enabled := True;
end;

procedure TData.TestForDeadLock;
begin
  with ParamTable do
  begin
    if FieldByName('Loading').AsBoolean then
    begin
      if (FieldByName('Loading_comp').AsString = GetComputer) or
       (not FileExists(GetAppDir + LOCK_FILE)) then
      begin
        Edit;
        FieldByName('Loading').Value := False;
        FieldByName('Loading_comp').Value := '';
        Post;
        SysUtils.DeleteFile(GetAppDir + LOCK_FILE);
      end;
    end
    else if FileExists(GetAppDir + LOCK_FILE) then
      SysUtils.DeleteFile(GetAppDir + LOCK_FILE);
  end;
end;


procedure TData.LoadAddPicturesBath;
var
  aRes: TStrings;
  i: Integer;
  anAddedCount: Integer;
begin
{$IFDEF ADMINMODE}
  aRes := TStringList.Create;
  try
    if TBatchSelectorForm.Execute(aRes, False, 'ПАПКИ КАРТИНОК') then
    begin
      anAddedCount := 0;
      for i := 0 to aRes.Count - 1 do
        anAddedCount := anAddedCount + LoadAddPictures(aRes[i], True);
      MessageDlg('Загружено картинок: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
    end;
  finally
    aRes.Free;
  end;
{$ENDIF}
end;

procedure TData.LoadAddPictures2Bath;
var
  aRes: TStrings;
  i: Integer;
  anAddedCount: Integer;
begin
{$IFDEF ADMINMODE}
  aRes := TStringList.Create;
  try
    if TBatchSelectorForm.Execute(aRes, True {FilesMode}, 'CSV для картинок', '*.csv') then
    begin
      anAddedCount := 0;
      for i := 0 to aRes.Count - 1 do
        anAddedCount := anAddedCount + LoadAddPictures(aRes[i], True);
      MessageDlg('Загружено картинок: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
    end;
  finally
    aRes.Free;
  end;
{$ENDIF}  
end;

{ дозагрузка картинок }
function TData.LoadAddPictures(aDir: string = ''; aSilent: Boolean = False): Integer;
var
  aFound: integer;
  SearchRec: TSearchRec;
  aPath, ext, nam: string;
  anAddedCount, aProcessedCount: Integer;
  code, brand: string;
begin
  Result := 0;

  if aDir = '' then
    if SelectDirectory.Execute then
      aDir := SelectDirectory.Directory
    else
      Exit;


  anAddedCount := 0;
  aProcessedCount := 0;

  StartWait;
  Main.ShowProgress('Дозагрузка картинок(new): 0');

  LoadBrandReplTable;
  TDArtTable.Open;
  BrandTable.IndexName := 'Descr';
  SearchTable.IndexName := 'Code2';
  TDArtTable.Open;
  try //finally
    aPath := StdPath(aDir);
    aFound := FindFirst(aPath + '*.*', faAnyFile - faDirectory, SearchRec);
    while aFound = 0 do
    begin
      ext := UpperCase(ExtractFileExt(aPath + SearchRec.Name));
      if (ext = '.JPG') or (ext = '.JP2') or (ext = '.PNG') or (ext = '.BMP') or
         (ext = '.JPEG') or (ext = '.GIF') or (ext = '.PCX') or (ext = '.WMF') then
      begin
        nam := ChangeFileExt(SearchRec.Name, '');
        if not DecodeCodeBrand(nam, code, brand) then
          Continue;

        if LoadAddPictureFromFile(aPath + SearchRec.Name, code, brand) then
          Inc(anAddedCount);
        Inc(aProcessedCount);

        if aProcessedCount mod 50 = 0 then
          Main.ShowProgrInfo('Дозагрузка картинок(new): ' + IntToStr(aProcessedCount) + ' ' + brand);
      end;
      aFound := FindNext(SearchRec);
    end;
    SysUtils.FindClose(SearchRec);
  finally
    TDArtTable.Close;
    BrandTable.IndexName := 'BrandId';
    BrandReplTable.Close;
    BrandReplTable.DeleteTable;

    Main.HideProgress;
    StopWait;
  end;
  if not aSilent then
    MessageDlg('Загружено картинок: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
  Result := anAddedCount;
end;

//[OK]
{ дозагрузка картинок по списку }
function TData.LoadAddPictures2(aFile: string = ''; aSilent: Boolean = False): Integer;
var
  anAddedCount, aProcessedCount: Integer;
  code_brand, code, brand: string;
  aFileName: string;
  aReader: TCSVReader;
begin
  Result := 0;

  if aFile = '' then
    if OpenDialog.Execute then
      aFile := OpenDialog.FileName
    else
      Exit;

  anAddedCount := 0;
  aProcessedCount := 0;

  StartWait;
  Main.ShowProgress('Дозагрузка картинок(new): 0');

  LoadBrandReplTable;
  BrandTable.IndexName := 'Descr';
  SearchTable.IndexName := 'Code2';
  TDArtTable.Open;

  aReader := TCSVReader.Create;
  try //finally
    aReader.Open(aFile);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      code_brand := aReader.Fields[0];
      aFileName  := aReader.Fields[1];

      if (code_brand = '') or (aFileName = '') then
        Continue;

      if not DecodeCodeBrand(code_brand, code, brand) then
        Continue;

      //если задан относительный путь или просто имя файла, то добавляем путь откуда брали файл списка
      if (Copy(aFileName, 2, 1) <> ':') and (Copy(aFileName, 1, 2) <> '\\') then
        aFileName := ExtractFilePath(aFile) + aFileName;

      if LoadAddPictureFromFile(aFileName, code, brand) then
        Inc(anAddedCount);
      Inc(aProcessedCount);

      if aProcessedCount mod 10 = 0 then
        Main.ShowProgrInfo('Дозагрузка картинок(new): ' + IntToStr(aProcessedCount) + ' ' + brand);
      Main.CurrProgress(aReader.FilePosPercent);

      //сравнить по ХЭШу
    end;
    aReader.Close;

  finally
    aReader.Free;
    TDArtTable.Close;
    BrandTable.IndexName := 'BrandId';
    BrandReplTable.Close;
    BrandReplTable.DeleteTable;

    Main.HideProgress;
    StopWait;
  end;

  if not aSilent then
    MessageDlg('Загружено картинок: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
  Result := anAddedCount;
end;


//используется функциями LoadAddPictures, LoadAddPictures2
//дозагружает новую картинку для заданного кода/бренда 
function TData.LoadAddPictureFromFile(const aPictureFileName, aCode,
  aBrand: string): Boolean;
var
//  id_param, id_pict, id_type: Integer;
  tecdoc_id, pict_id: Integer;
  rp: string;
  isNewRec: Boolean;
  aRefCount: Integer;
  aPictSizeFile, aPictSizeDB: Int64;
begin
  Result := False;

  if not FileExists(aPictureFileName) then
    Exit;

  if BrandReplTable.FindKey([aBrand]) and
     (BrandReplTable.FieldByName('Repl_brand').AsString <> '') then
    rp := BrandReplTable.FieldByName('Repl_brand').AsString
  else
    rp := aBrand;

  isNewRec := False;
  //ищем по коду/бренду в [110]
  if not TDArtTable.FindKey([aCode, rp]) then
  begin //не нашли - добавляем запись с новым Tecdoc_id
    tecdoc_id := SysParamTable.FieldByName('Tecdoc_id').AsInteger + 1;
    SysParamTable.Edit;
    SysParamTable.FieldByName('Tecdoc_id').Value := tecdoc_id;
    SysParamTable.Post;

    TDArtTable.Append;
    TDArtTable.FieldByName('Art_id').Value    := tecdoc_id;
    TDArtTable.FieldByName('Art_look').Value  := aCode;
    TDArtTable.FieldByName('Sup_brand').Value := rp;
    TDArtTable.FieldByName('pict_id').Value := 0;
    TDArtTable.FieldByName('typ_id').Value := tecdoc_id;
    TDArtTable.FieldByName('param_id').Value := tecdoc_id;
    TDArtTable.Post;
    isNewRec := True;
  end;
  tecdoc_id := TDArtTable.FieldByName('Art_id').AsInteger;

  //есть ли уже картинка для этого кода/бренда?
  pict_id := TDArtTable.FieldByName('pict_id').AsInteger;

  //ссылаются ли другие записи на эту картинку?
  //если на картинку ссылаются другие записи ее нельзя заменять
  if pict_id > 0 then
  begin
    //переделать на сравнение по хэшу
    if PictTable.Locate('Pict_id', pict_id, []) then
    begin
      aPictSizeFile := GetFileSize_Internal(aPictureFileName);
      aPictSizeDB := TBlobField(PictTable.FieldByName('Pict_data')).BlobSize;
      if aPictSizeFile = aPictSizeDB then
        Exit;
    end;


    aRefCount := StrToIntDef(
      ExecuteSimpleSelect('SELECT Count(pict_id) FROM [110] WHERE pict_id = ' + IntToStr(pict_id), []),
      0
    );

    if aRefCount > 1 then
      pict_id := 0; //обнуляем, чтобы не заменить картинку
  end;

  if pict_id = 0 then //добавить новую id
  begin
    pict_id := SysParamTable.FieldByName('Pict_id').AsInteger + 1;
    SysParamTable.Edit;
    SysParamTable.FieldByName('Pict_id').Value := pict_id;
    SysParamTable.Post;
  end;


  //ищем картинку
  if not PictTable.Locate('Pict_id', pict_id, []) then
  begin
    PictTable.Append;
    PictTable.FieldByName('Pict_id').Value := pict_id;

    //перебить ID'шки на картинки в таблице каталога [002]
    if BrandTable.FindKey([aBrand]) and
       SearchTable.FindKey([aCode, BrandTable.FieldByName('Brand_id').AsInteger]) then
    begin
      with SearchTable do
      begin
        Edit;
        if FieldByname('Tecdoc_id').AsInteger = 0 then
          FieldByname('Tecdoc_id').Value := tecdoc_id;

        //[pict]
        FieldByname('pict_id').Value := pict_id;
        //если запись не добавлялась в [110], typ_id и param_id - остаются те же
        if isNewRec then
        begin
          FieldByname('typ_tdid').Value := tecdoc_id;
          FieldByname('param_tdid').Value := tecdoc_id;
        end;
        Post;
      end;
    end;

  end
  else
    PictTable.Edit;

  TBlobField(PictTable.FieldByName('Pict_data')).LoadFromFile(aPictureFileName);
  PictTable.Post;

  TDArtTable.Edit;
  TDArtTable.FieldByName('pict_id').Value := pict_id;
  TDArtTable.FieldByName('pict_nr').Value := 0;
  TDArtTable.Post;

  Result := True;
end;
//---------------------------------------------------------------------------------------------------------

//дозагрузка артикулов tecdoc
//[pict]
//дозагрузка артикулов tecdoc
procedure TData.LoadAddTDArt(fname: string='');
var
  cnt: integer;
  s, code_brand, code, brand, rp: string;
  pict_id, pict_nr, typ_id, param_id: Integer;
  td_id_int: Integer;
  aTDFound: Boolean;
begin
  if fname = '' then
  begin
    if not OpenDialog.Execute then
      exit;
    fname := OpenDialog.FileName;
  end;
  StartWait;
  LoadBrandReplTable;
  AssignFile(F, fname);
  TDArtTable.Open;
  BrandTable.IndexName := 'Descr';
  SearchTable.IndexName := 'Code2';
  cnt := 0;
  Reset(F);
  while not System.Eof(F) do
  begin
    Readln(F, s);
    code_brand  := ExtractDelimited(1, s, [';']);
    td_id_int := StrInt(ExtractDelimited(2, s, [';']));

    if td_id_int < 1 then
      Continue;

    DecodeCodeBrand(code_brand, code, brand);
    if BrandReplTable.FindKey([brand]) and
       (BrandReplTable.FieldByName('Repl_brand').AsString <> '') then
      rp := BrandReplTable.FieldByName('Repl_brand').AsString
    else
      rp := brand;

    with TDArtTable do
    begin
      if Locate('Art_id', td_id_int, []) then
      begin
        aTDFound := True;
        pict_id := FieldByName('pict_id').AsInteger;
        pict_nr := FieldByName('pict_nr').AsInteger;
        typ_id  := FieldByName('typ_id').AsInteger;
        param_id:= FieldByName('param_id').AsInteger;
      end
      else
      begin
        aTDFound := False;
        pict_id := 0;
        pict_nr := 0;
        typ_id  := td_id_int;
        param_id:= td_id_int;
      end;


      if not FindKey([code, rp]) then
      begin
        Append;
        //хотим добавить привязку к td_id - нужно взять параметры из существующего td_id в [110]
      end
      else
      begin //хотим перебить привязку
        if td_id_int = FieldByName('Art_id').AsInteger then //такая привязка уже добавлялась - ничего не делаем
          Continue;

        Edit;
      end;

      FieldByName('Art_id').Value    := td_id_int;
      FieldByName('Art_look').Value  := code;
      FieldByName('Sup_brand').Value := rp;
      FieldByName('pict_id').Value := pict_id;
      FieldByName('pict_nr').Value := pict_nr;
      FieldByName('typ_id').Value    := typ_id;
      FieldByName('param_id').Value  := param_id;
      Post;
      if BrandTable.FindKey([brand]) and
         SearchTable.FindKey([code, BrandTable.FieldByName('Brand_id').AsInteger]) then
      begin
        with SearchTable do
        begin
          Edit;
          FieldByName('Tecdoc_id').Value := TDArtTable.FieldByName('Art_id').Value;
          FieldByName('pict_id').Value := TDArtTable.FieldByName('pict_id').Value;
          FieldByName('typ_tdid').Value := TDArtTable.FieldByName('typ_id').Value;
          FieldByName('param_tdid').Value := TDArtTable.FieldByName('param_id').Value;
          Post;
        end;
      end;
      Inc(cnt);
    end;
  end;
  CloseFile(F);
  TDArtTable.Close;
  BrandTable.IndexName := 'BrandId';
  BrandReplTable.Close;
  BrandReplTable.DeleteTable;
  StopWait;
  MessageDlg('Загружено позиций(new): ' + IntToStr(cnt), mtInformation, [mbOK], 0);
end;

procedure TData.LoadAddTDParamBath;
var
  aRes: TStrings;
  i: Integer;
  anAddedCount: Integer;
begin
{$IFDEF ADMINMODE}
  aRes := TStringList.Create;
  try
    if TBatchSelectorForm.Execute(aRes, True {FilesMode}, 'Доп. параметры - таблица', '*.csv') then
    begin
      anAddedCount := 0;
      for i := 0 to aRes.Count - 1 do
        anAddedCount := anAddedCount + LoadAddTDParam(aRes[i], True);
      MessageDlg('Загружено параметров: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
    end;
  finally
    aRes.Free;
  end;
{$ENDIF}
end;


//дозагрузка параметров
// - параметры всегда добавляются, никогда не заменяются (в рамках одного набора)
//[param]
//дозагрузка параметров
//вопрос к Роме - здесь лучше бы реализовать 2 варианта:
//  1.только дополнить текущий набор параметров для кода/брэнда
//  2.нужно завести новый набор параметров для кода/брэнда и залить туда
//сейчас реализован 2й - ok
function TData.LoadAddTDParam(fname: string = ''; aSilent: Boolean = False): Integer;

  function GetNewTecdocID: Integer;
  begin
    Result := SysParamTable.FieldByName('Tecdoc_id').AsInteger + 1;
    SysParamTable.Edit;
    SysParamTable.FieldByName('Tecdoc_id').AsInteger := Result;
    SysParamTable.Post;
  end;

  //находит параметр по имени (или добавляет, если такого еще нет)
  function GetParamIdByName(const aParamName: string): Integer;
  begin
    if not XCatParTable.Active then
      XCatParTable.Open;

    with XCatParTable do
    begin
      if not FindKey([aParamName]) then
      begin
        IndexName := '';
        Last;
        Result := FieldByName('Param_id').AsInteger + 1;
        IndexName := 'Descr';
        Append;
        FieldByName('Param_id').Value := Result;
        FieldByName('Descr').Value := aParamName;
        FieldByName('Description').Value := aParamName;
        Post;
      end
      else
        Result := FieldByName('Param_id').AsInteger;
    end;
  end;

var
  cnt: integer;
  tecdoc_id, p, srt: integer;
  code_brand, code, brand, rp,
  param_str, param_name, param_value: string;
  lFound: boolean;

  aParamID, aParamSetID: Integer;
  aFirstTecdocID: Integer;
  aNeedRelinkCatalog: Boolean;
  aReader: TCSVReader;
begin
  Result := 0;
  
  if fname = '' then
  begin
    if not OpenDialog.Execute then
      exit;
    fname := OpenDialog.FileName;
  end;

  StartWait;
  LoadBrandReplTable;
  TDArtTable.Open;
  BrandTable.IndexName := 'Descr';
  SearchTable.IndexName := 'Code2';
  XCatDetTable.Open;
  XCatParTable.Open;

  if not SysParamTable.Active then
    SysParamTable.Open;
  aFirstTecdocID := SysParamTable.FieldByName('Tecdoc_id').AsInteger;

  cnt := 0;
  Main.ShowProgress('Дозагрузка подробностей(new)');
  aReader := TCSVReader.Create;
  try //finally
    aReader.Open(fname);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      code_brand  := aReader.Fields[0];
      if not DecodeCodeBrand(code_brand, code, brand) then
        continue;

      param_str   := aReader.Fields[1];
      param_name  := ExtractDelimited(1, param_str, ['=']);
      param_value := ExtractDelimited(2, param_str, ['=']);
      if BrandReplTable.FindKey([brand]) and
         (BrandReplTable.FieldByName('Repl_brand').AsString <> '') then
        rp := BrandReplTable.FieldByName('Repl_brand').AsString
      else
        rp := brand;

      aNeedRelinkCatalog := False;
      //ищем в артикулах
      with TDArtTable do
      begin
        if not FindKey([code, rp]) then //не нашли - добавляем
        begin
          tecdoc_id := GetNewTecdocID;

          Append;
          FieldByName('Art_id').Value    := tecdoc_id;
          FieldByName('Art_look').Value  := code;
          FieldByName('Sup_brand').Value := rp;
          FieldByName('pict_id').Value := 0;
          FieldByName('typ_id').Value := tecdoc_id;
          FieldByName('param_id').Value := tecdoc_id;
          Post;
          aNeedRelinkCatalog := True;
        end
        else //нашли - нужно добавить новую группу параметров, но
          //если еще не добавляли tecdoc_id для этого кода/бренда в этом файле
          if FieldByName('param_id').Value <= 5000000 {FirstTecdocID} then
          begin
            tecdoc_id := GetNewTecdocID;

            Edit;
            FieldByName('param_id').Value := tecdoc_id;
            //tecdoc_id оставляем тот же
            Post;
            aNeedRelinkCatalog := True;
          end;
      end;

      aParamSetID := TDArtTable.FieldByName('param_id').Value;

      //замена ссылок в каталоге
      if aNeedRelinkCatalog then //оптимизация, перепривязываем только для первого параметра
        if BrandTable.FindKey([brand]) and
           SearchTable.FindKey([code, BrandTable.FieldByName('Brand_id').AsInteger]) then
        begin
          with SearchTable do
          begin
            Edit;
            FieldByname('Tecdoc_id').Value := TDArtTable.FieldByName('art_id').Value;
            FieldByname('pict_id').Value := TDArtTable.FieldByName('pict_id').Value;
            FieldByname('typ_tdid').Value := TDArtTable.FieldByName('typ_id').Value;
            FieldByname('param_tdid').Value := TDArtTable.FieldByName('param_id').Value;
            Post;
          end;
        end;

      //находим или добавляем параметр, если такого еще нет
      aParamID := GetParamIdByName(param_name);

      //заливаем значения параметров - добавляем в текущий набор
      //нужно ли заменять значение если имя параметра совпадает???
      with XCatDetTable do
      begin
        lFound := False;
        srt := 0;
        if Locate('Tecdoc_id', aParamSetID, []) then
        begin
          //перебираем все параметры набора param_tdid
          while (not Eof) and (FieldByName('Tecdoc_id').AsInteger = aParamSetID) do
          begin
            if FieldByName('Param_id').AsInteger = aParamID then
            begin
              lFound := True;
              break;
            end;
            srt := FieldByName('Sort').AsInteger;
            next;
          end;
        end;
        if not lFound then
        begin
          Append;
          FieldByName('Tecdoc_id').Value := aParamSetID;
          FieldByName('Sort').Value      := srt + 1;
          FieldByName('Param_id').Value  := aParamID;
          FieldByName('Param_value').Value := param_value;
          Post;
          Inc(cnt);
        end;
      end;

      Main.CurrProgress(aReader.FilePosPercent);
    end;
    aReader.Close;

    //чистка мусора - удаляем старые параметры если на них никто не ссылается
//    Database.Execute('DELETE FROM [014] WHERE Tecdoc_id NOT IN ( SELECT param_id FROM [110] )');
  finally
    aReader.Free;
    XCatParTable.Close;
    XCatDetTable.Close;
    TDArtTable.Close;
    BrandTable.IndexName := 'BrandId';
    BrandReplTable.Close;
    BrandReplTable.DeleteTable;

    Main.HideProgress;
    StopWait;
  end;
  
  if not aSilent then
    MessageDlg('Загружено позиций(new): ' + IntToStr(cnt), mtInformation, [mbOK], 0);
  Result := cnt;
end;

procedure TData.LoadAddTDPrimenBath;
var
  aRes: TStrings;
  i: Integer;
  anAddedCount: Integer;
begin
{$IFDEF ADMINMODE}
  aRes := TStringList.Create;
  try
    if TBatchSelectorForm.Execute(aRes, True {FilesMode}, 'Применяемость', '*.csv') then
    begin
      anAddedCount := 0;
      for i := 0 to aRes.Count - 1 do
        anAddedCount := anAddedCount + LoadAddTDPrimen(aRes[i], True);
      MessageDlg('Загружено позиций: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
    end;
  finally
    aRes.Free;
  end;
{$ENDIF}  
end;

//[typ]
//дозагрузка применяемости
function TData.LoadAddTDPrimen(fname: string = ''; aSilent: Boolean = False): Integer;

  function GetNewTecdocID: Integer;
  begin
    Result := SysParamTable.FieldByName('Tecdoc_id').AsInteger + 1;
    SysParamTable.Edit;
    SysParamTable.FieldByName('Tecdoc_id').AsInteger := Result;
    SysParamTable.Post;
  end;

var
  anAddedCount: Integer;
  tecdoc_id, typ_id: integer;
  s, code_brand, code, brand, rp, prim: string;
  lFound: boolean;
  TypSetID: Integer;
  aReader: TCSVReader;
  aNeedRebuildMemo: Boolean;
  aFirstTecdocID: Integer;
begin
  Result := 0;
  
  if fname = '' then
    if OpenDialog.Execute then
      fname := OpenDialog.FileName
    else
      Exit;

  StartWait;
  LoadBrandReplTable;
  TDArtTable.Open;
  BrandTable.IndexName := 'Descr';
  SearchTable.IndexName := 'Code2';
  anAddedCount := 0;

  if not SysParamTable.Active then
    SysParamTable.Open;

  //применяемость идет несортированная, используем aFirstTecdocID чтобы знать
  //добавлялся ли новый tecdoc_id для группы типов
  aFirstTecdocID := SysParamTable.FieldByName('Tecdoc_id').AsInteger;

  Main.ShowProgress('Дозагрузка применяемости(new)');
  aReader := TCSVReader.Create;
  try //finally
    aReader.Open(fname);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      code_brand  := aReader.Fields[0];
      if not DecodeCodeBrand(code_brand, code, brand) then
        Continue;

      typ_id := StrInt(aReader.Fields[1]);
      if BrandReplTable.FindKey([brand]) and
         (BrandReplTable.FieldByName('Repl_brand').AsString <> '') then
        rp := BrandReplTable.FieldByName('Repl_brand').AsString
      else
        rp := brand;

      //ищем в артикулах
      with TDArtTable do
      begin
        if not FindKey([code, rp]) then //не нашли - добавляем
        begin
          tecdoc_id := GetNewTecdocID;
          Append;
          FieldByName('Art_id').Value    := tecdoc_id;
          FieldByName('Art_look').Value  := code;
          FieldByName('Sup_brand').Value := rp;
          FieldByName('pict_id').Value := 0;
          FieldByName('typ_id').Value := tecdoc_id;
          FieldByName('param_id').Value := tecdoc_id;
          Post;
        end
        else //нашли - заводим новый ID для набора применяемости, но
          //если еще не добавляли tecdoc_id для этого кода/бренда в этом файле
          if FieldByName('typ_id').AsInteger <= aFirstTecdocID then
          begin
            tecdoc_id := GetNewTecdocID;

            Edit;
            //удалить записи из [023] на кот. раньше ссылалась эта запись, если больше никто не ссылается
            // - это делается вконце после обработки всего файла
            FieldByName('typ_id').AsInteger := tecdoc_id;
            //поле tecdoc_id оставляем то же
            Post;
          end;
      end;

      TypSetID := TDArtTable.FieldByName('typ_id').AsInteger;

      //добавляем ссылку на тип, если такого еще нет
      with ArtTypTable do //[23]
      begin
        s := Data.ExecuteSimpleSelect(
          ' SELECT COUNT(ID) FROM [023] ' +
          ' WHERE Art_id = ' + IntToStr(TypSetID) + ' AND Typ_id = ' + IntToStr(typ_id),
          []
        );
        lFound := StrToIntDef(s, 0) > 0;

        if not lFound then
        begin
          Append;
          FieldByName('Art_id').Value := TypSetID;
          FieldByName('Typ_id').Value := typ_id;
          Inc(anAddedCount);
          Post;
        end;
      end;

      //замена ссылок в каталоге
      if BrandTable.FindKey([brand]) and
         SearchTable.FindKey([code, BrandTable.FieldByName('Brand_id').AsInteger]) then
      begin
        with SearchTable do
        begin
          Edit;
          aNeedRebuildMemo := FieldByname('typ_tdid').AsInteger <> TDArtTable.FieldByName('typ_id').AsInteger;
          FieldByname('Tecdoc_id').Value := TDArtTable.FieldByName('art_id').Value;
          FieldByname('pict_id').Value := TDArtTable.FieldByName('pict_id').Value;
          FieldByname('typ_tdid').Value := TDArtTable.FieldByName('typ_id').Value;
          FieldByname('param_tdid').Value := TDArtTable.FieldByName('param_id').Value;

          //если поменялся typ_tdid, то нужно пересобрать все поле Primen
          if aNeedRebuildMemo then
          begin
            FieldByName('Primen').Value := IntToStr(typ_id);
          end
          else
            if not lFound then
            begin
              prim := FieldByName('Primen').AsString;
              if prim <> '' then
                prim := prim + ', ';
              FieldByName('Primen').Value := prim + IntToStr(typ_id);
            end;
          Post;
        end;
      end;

      Main.CurrProgress(aReader.FilePosPercent);
    end;
    aReader.Close;

    //чистка мусора - удаляем записи на кот. никто не ссылается
//    Database.Execute('DELETE FROM [023] WHERE art_id NOT IN ( SELECT typ_id FROM [110] )');
  finally
    aReader.Free;

    TDArtTable.Close;
    BrandTable.IndexName := 'BrandId';
    BrandReplTable.Close;
    BrandReplTable.DeleteTable;

    Main.HideProgress;
    StopWait;
  end;

  if not aSilent then
    MessageDlg('Загружено позиций(new): ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
  Result := anAddedCount;
end;

procedure TData.TypesUnload;
begin
  StartWait;
  with WQuery do
  begin
    SQL.Add('select typ_id, mfa.mfa_brand, mdl.tex_text, cds.tex_text from "022" as typ');
    SQL.Add('inner join "025" as cds on cds.cds_id = typ.cds_id');
    SQL.Add('inner join "021" as mdl on mdl.mod_id = typ.mod_id');
    SQL.Add('inner join "020" as mfa on mfa.mfa_id = mdl.mfa_id');
    SQL.Add('where mfa.hide <> true');
    SQL.Add('order by 2, 3, 4');
    Open;
    ExportTable('Types.txt', ';');
    Close;
  end;
  StopWait;
  MessageDlg('Выгружено в файл: Types.txt', mtInformation, [mbOK], 0);
end;



procedure TData.LoadFromBlockMfaTable;
begin
  StartWait;
  BlockMfaTable.Open;
  with ManufacturersTable do
  begin
    First;
    while not Eof  do
    begin
      Edit;
      FieldByName('Hide').Value :=
           BlockMfaTable.FindKey([FieldByName('Mfa_brand').AsString]);
      Post;
      Next;
    end;
  end;
  BlockMfaTable.Close;
  StopWait;
end;


procedure TData.SaveToBlockMfaTable;
begin
  StartWait;
  BlockMfaTable.EmptyTable;
  BlockMfaTable.Open;
  with ManufacturersTable do
  begin
    DisableControls;
    First;
    while not Eof  do
    begin
      if FieldByName('Hide').AsBoolean then
      begin
        BlockMfaTable.Append;
        BlockMfaTable.FieldByName('Mfa_brand').Value :=
                      FieldByName('Mfa_brand').AsString;
        BlockMfaTable.Post;
      end;
      Next;
    end;
    EnableControls;
  end;
  BlockMfaTable.Close;
  StopWait;
end;


procedure TData.GoToSelectItem(const aCode2: string = ''; const aBrand: string = '');
var
  sCode, sBrand, anOldIndex: String;
  aCatId: Integer;
begin
  if (aCode2 <> '') and (aBrand <> '') then
  begin
    sCode := aCode2;
    sBrand := aBrand;
  end
  else
  begin
    sCode := OrderDetTable.FieldByName('Code2').AsString;
    sBrand := OrderDetTable.FieldByName('Brand').AsString;
  end;
  if (sCode = '') or (sBrand = '') then
    Exit;

  Auto_type := 0;
  Main.AutoPanel.Hide;
  sAuto:='';

  SeachIdDetail.SQL.Clear;
    SeachIdDetail.SQL.Add('SELECT Cat_id, USA,NEW,SALE  FROM [002], [003] WHERE [002].Brand_Id = [003].Brand_Id AND Code2 = '''+sCode+''' AND UPPER([003].Description) = UPPER('''+sBrand+''')');
  SeachIdDetail.Active := TRUE;
  aCatId := SeachIdDetail.FieldByName('Cat_id').AsInteger;
  SeachIdDetail.Active := False;

  if aCatId > 0  Then
  begin
    Main.ResetFilter;
    (CatalogDataSource.DataSet as TDBISAMTABLE).DisableControls;
    try
      if CatalogDataSource.DataSet <> CatalogTable then
      begin
        CatalogDataSource.DataSet.DisableControls;
        CatalogDataSource.DataSet.Locate('Cat_Id', aCatId, []);
        CatalogDataSource.DataSet.EnableControls;
        Exit;
      end;

      with SearchTable do
      begin
        anOldIndex := IndexName;
        if IndexName <> '' then
          IndexName := '';
        if Locate('Cat_id', aCatId, []) then
        begin
          CatalogTable.GotoCurrent(SearchTable);
        end;
        IndexName := anOldIndex;
      end;
    finally
      (CatalogDataSource.DataSet as TDBISAMTABLE).EnableControls;
    end;
  end;
end;

procedure TData.LoadLotusCatalog(sFileName:string);
var
  sValue: string;
  sBrand, sCode: string;
  brand_id, td_id: Integer;
  sGroupe,rp, sSubGroupe: string;
  iCatalog, iGroupe, iSubGroupe: Integer;
  flPrice, flPriceNew: Real;
  sPrice: string;

  aReader: TCSVReader;
  pict_id, typ_id, param_id: Integer;
  aDescription: string;
begin
  LoadBrandReplTable;
  TDArtTable.Open;

  Main.ShowProgrInfo('Удаление');
  RemoveTableFromBase('TREEID');
  RemoveTableFromBase('CATALOG');
  RemoveTableFromBase('BRAND');
  RemoveTableFromBase('TREE');
  RemoveTableFromBase('ANALOG');
  RemoveTableFromBase('ANALOGDEL');
  RemoveTableFromBase('OE');
  RemoveTableFromBase('Primen');

  Main.ShowProgrInfo('Копирование [005]');
  TestQuery.Close;
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('SELECT [005].*, 1 AS DELITEM, 0 AS NEWITEM INTO TREEID FROM [005]');
  Main.bAbort := FALSE;
  TestQuery.Active:= TRUE;
  TestQuery.Active:= FALSE;


  UpdateTreeID.AddIndex('GIDSIDBID','Group_id;Subgroup_id;Brand_id',  [ixCaseInsensitive]);
  UpdateTreeID.Open;
  UpdateTreeID.IndexName := 'GIDSIDBID';

  Main.ShowProgrInfo('Копирование [002]');
  TestQuery.Close;
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('SELECT [002].*, 1 AS DELITEM, 0 AS EDITNAME, 0 AS EDITGRITEM, 0 AS NEWITEM, 0 AS EDITITEM, 0 AS EDITPRICE, 0 AS EDITTDLINKS INTO CATALOG FROM [002] WHERE CODE2 <>''''');
  Main.bAbort := FALSE;
  TestQuery.Active:= TRUE;
  TestQuery.Active:= FALSE;

  UpdateCatalog.AddIndex('CodeBrand','Code;Brand_Id',  [ixCaseInsensitive]);
  UpdateCatalog.AddIndex('CodeBrandDel','Code2;Brand_Id;DELITEM',  [ixCaseInsensitive]);

  UpdateCatalog.Open;
  UpdateCatalog.IndexName := 'CodeBrand';

  TestTable(BrandReplTable);
  BrandReplTable.Open;

  TestQuery.Close;
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('SELECT MAX(Cat_Id) as NUM FROM CATALOG');
  TestQuery.ExecSQL;
  if not TestQuery.Eof then
    iCatalog := TestQuery.FieldByName('NUM').AsInteger + 1
  else
    iCatalog := 1;
  TestQuery.Close;

  Main.ShowProgrInfo('Копирование [003]');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('SELECT [003].*, 1 AS DELITEM, 0 AS NEWITEM, 0 AS SORT INTO BRAND FROM [003]');
  TestQuery.Active := True;
  TestQuery.Active := False;

  UpdateBrand.AddIndex('Descr','Description',  [ixCaseInsensitive]);
  UpdateBrand.AddIndex('DescrDel','Description;DELITEM',  [ixCaseInsensitive]);
  UpdateBrand.Open;
  UpdateBrand.IndexName := 'Descr';


  Main.ShowProgrInfo('Копирование [004]');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('SELECT [004].*, 1 AS DELITEM, 0 AS NEWITEM INTO TREE FROM [004]');
  TestQuery.Active := True;
  TestQuery.Active := False;

  UpdateTree.AddIndex('Descr', 'Group_descr;Subgroup_descr', [ixCaseInsensitive]);
  UpdateTree.AddIndex('GrDescr', 'Group_descr', [ixCaseInsensitive]);
  UpdateTree.Open;
  UpdateTree.IndexName := 'Descr';

  brand_id := -1;
  iSubGroupe := -1;
  iGroupe := -1;

  Main.ShowProgress('Загрузка каталога...');

  aReader := TCSVReader.Create;
  try //finally
    aReader.Open(sFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;

      try //except
        sValue  := aReader.Fields[0];
        if sBrand <> sValue then
        begin
          if UpdateBrand.FindKey([sValue]) then
          begin
            brand_id := UpdateBrand.FieldByName('Brand_id').AsInteger;
            UpdateBrand.Edit;
            UpdateBrand.FieldByName('DELITEM').Value := 0;
            UpdateBrand.Post;
          end
          else
          begin
            TestQuery.Close;
            TestQuery.SQL.Clear;
            TestQuery.SQL.Add('SELECT MAX(Brand_id) as NUM FROM BRAND');
            TestQuery.ExecSQL;
            if not TestQuery.Eof then
              brand_id := TestQuery.FieldByName('NUM').AsInteger+1
            else
              brand_id := 1;
            TestQuery.Close;

            UpdateBrand.Append;
            UpdateBrand.FieldByName('Brand_id').Value := brand_id;
            UpdateBrand.FieldByName('Description').Value := sValue;
            UpdateBrand.FieldByName('DELITEM').Value := 0;
            UpdateBrand.FieldByName('NEWITEM').Value := 1;
            UpdateBrand.Post;
          end;
          sBrand := sValue;
        end;

        if (sGroupe <> aReader.Fields[5]) or (sSubGroupe <> aReader.Fields[6]) then
        begin
          sGroupe := aReader.Fields[5];
          sSubGroupe := aReader.Fields[6];
          if UpdateTree.FindKey([sGroupe, sSubGroupe]) then
          begin
            iGroupe := UpdateTree.FieldByName('Group_id').AsInteger;
            iSubGroupe := UpdateTree.FieldByName('Subgroup_id').AsInteger;
            UpdateTree.Edit;
            UpdateTree.FieldByName('DELITEM').Value := 0;
            UpdateTree.Post;
          end
          else
          begin
            UpdateTree.IndexName := 'GrDescr';
            if UpdateTree.FindKey([sGroupe]) then
            begin
              iGroupe := UpdateTree.FieldByName('Group_id').AsInteger;
              TestQuery.Close;
              TestQuery.SQL.Clear;
              TestQuery.SQL.Add('SELECT MAX(Subgroup_id) as NUM FROM TREE');
              TestQuery.ExecSQL;
              if not TestQuery.Eof then
                iSubGroupe := TestQuery.FieldByName('NUM').AsInteger + 1
              else
                iSubGroupe := 1;
              TestQuery.Close;
              UpdateTree.Append;
              UpdateTree.FieldByName('Group_id').Value := iGroupe;
              UpdateTree.FieldByName('Subgroup_id').Value := iSubGroupe;
              UpdateTree.FieldByName('Group_descr').Value := sGroupe;
              UpdateTree.FieldByName('Subgroup_descr').Value := sSubGroupe;
              UpdateTree.FieldByName('DELITEM').Value := 0;
              UpdateTree.FieldByName('NEWITEM').Value := 1;
              UpdateTree.Post;
            end
            else
            begin
              TestQuery.Close;
              TestQuery.SQL.Clear;
              TestQuery.SQL.Add('SELECT MAX(Group_id) as NUM FROM TREE');
              TestQuery.ExecSQL;
              if not TestQuery.Eof then
                iGroupe := TestQuery.FieldByName('NUM').AsInteger+1
              else
                iGroupe := 1;
              TestQuery.Close;
              TestQuery.Close;
              TestQuery.SQL.Clear;
              TestQuery.SQL.Add('SELECT MAX(Subgroup_id) as NUM FROM TREE');
              TestQuery.ExecSQL;
              if not TestQuery.Eof then
                iSubGroupe := TestQuery.FieldByName('NUM').AsInteger+1
              else
                iSubGroupe := 1;
              TestQuery.Close;
              UpdateTree.Append;
              UpdateTree.FieldByName('Group_id').Value := iGroupe;
              UpdateTree.FieldByName('Subgroup_id').Value := iSubGroupe;
              UpdateTree.FieldByName('Group_descr').Value := sGroupe;
              UpdateTree.FieldByName('Subgroup_descr').Value := sSubGroupe;
              UpdateTree.FieldByName('DELITEM').Value := 0;
              UpdateTree.FieldByName('NEWITEM').Value := 1;
              UpdateTree.Post;
            end;
            UpdateTree.IndexName := 'Descr';
          end;
        end;

        if UpdateTreeID.FindKey([iGroupe, iSubGroupe, brand_id]) then
        begin
          UpdateTreeID.Edit;
          UpdateTreeID.FieldByName('DELITEM').Value := 0;
          UpdateTreeID.Post;
        end
        else
        begin
          UpdateTreeID.Append;
          UpdateTreeID.FieldByName('Group_id').Value := iGroupe;
          UpdateTreeID.FieldByName('Subgroup_id').Value := iSubGroupe;
          UpdateTreeID.FieldByName('Brand_id').Value := brand_id;
          UpdateTreeID.FieldByName('DELITEM').Value := 0;
          UpdateTreeID.FieldByName('NEWITEM').Value := 1;
          UpdateTreeID.Post;
        end;

        sCode  := aReader.Fields[1];
        if UpdateCatalog.FindKey([sCode, brand_id]) then
        begin
          UpdateCatalog.Edit;

          if (UpdateCatalog.FieldByName('Group_id').AsInteger <> iGroupe) and
             (UpdateCatalog.FieldByName('Subgroup_id').AsInteger <> iSubGroupe) then
          begin
            UpdateCatalog.FieldByName('Group_id').Value := iGroupe;
            UpdateCatalog.FieldByName('Subgroup_id').Value := iSubGroupe;
            UpdateCatalog.FieldByName('EDITGRITEM').Value := 1;
          end;

          flPrice  := Main.AToCurr(aReader.Fields[2]);
          flPriceNew := Main.AToCurr(UpdateCatalog.FieldByName('Price').AsString);
          if flPriceNew <> flPrice then
          begin
            UpdateCatalog.FieldByName('Price').Value := flPrice;
            UpdateCatalog.FieldByName('EDITPRICE').Value := 1;
          end;

          aDescription := TrimRight(aReader.Fields[7]);
          if (UpdateCatalog.FieldByName('Name').AsString <> aReader.Fields[4]) or
             (UpdateCatalog.FieldByName('Description').AsString <> aDescription) then
          begin
            UpdateCatalog.FieldByName('Name').Value        := aReader.Fields[4];
            UpdateCatalog.FieldByName('Description').Value := aReader.Fields[7];
            UpdateCatalog.FieldByName('EDITNAME').Value    := 1;
          end;

          //EDITTDLINKS - измененные ссылки на tecdoc --------------------------
          if BrandReplTable.FindKey([sBrand]) and (BrandReplTable.FieldByName('Repl_brand').AsString <> '') then
            rp := BrandReplTable.FieldByName('Repl_brand').AsString
          else
            rp := sBrand;

          if TDArtTable.FindKey([MakeSearchCode(sCode), rp]) then
          begin
            Inc(td_cnt);
            td_id := TDArtTable.FieldByName('Art_id').AsInteger;
            //[pict]
            pict_id := TDArtTable.FieldByName('pict_id').AsInteger;
            typ_id := TDArtTable.FieldByName('typ_id').AsInteger;
            param_id := TDArtTable.FieldByName('param_id').AsInteger;
          end
          else
          begin
            td_id := 0;
            pict_id := 0;
            typ_id := 0;
            param_id := 0;
          end;

          if ( UpdateCatalog.FieldByName('Tecdoc_id').AsInteger <> td_id ) or
             ( UpdateCatalog.FieldByName('pict_id').AsInteger <> pict_id ) or
             ( UpdateCatalog.FieldByName('typ_tdid').AsInteger <> typ_id ) or
             ( UpdateCatalog.FieldByName('param_tdid').AsInteger <> param_id ) then
          begin
            UpdateCatalog.FieldByName('EDITTDLINKS').Value := 1;
            UpdateCatalog.FieldByName('Tecdoc_id').AsInteger := td_id;
            UpdateCatalog.FieldByName('pict_id').AsInteger := pict_id;
            UpdateCatalog.FieldByName('typ_tdid').AsInteger := typ_id;
            UpdateCatalog.FieldByName('param_tdid').AsInteger := param_id;
          end;
          //--------------------------------------------------------------------


          if
          (
            ( (UpdateCatalog.FieldByName('EDITNAME').Value = 1) and ( (UpdateCatalog.FieldByName('EDITPRICE').Value = 1) or (UpdateCatalog.FieldByName('EDITGRITEM').Value = 1)) )
            or
            ( (UpdateCatalog.FieldByName('EDITPRICE').Value = 1) and (UpdateCatalog.FieldByName('EDITGRITEM').Value = 1) )
            or
            ( (UpdateCatalog.FieldByName('EDITTDLINKS').Value = 1) and ( (UpdateCatalog.FieldByName('EDITGRITEM').Value = 1) or (UpdateCatalog.FieldByName('EDITPRICE').Value = 1) or (UpdateCatalog.FieldByName('EDITNAME').Value = 1)) )
          )then
          begin
            UpdateCatalog.FieldByName('EDITNAME').Value := 0;
            UpdateCatalog.FieldByName('EDITPRICE').Value := 0;
            UpdateCatalog.FieldByName('EDITGRITEM').Value := 0;
            UpdateCatalog.FieldByName('EDITTDLINKS').Value := 0;
            UpdateCatalog.FieldByName('EDITITEM').Value := 1;
          end;
          UpdateCatalog.FieldByName('DELITEM').Value := 0;
          UpdateCatalog.Post;
        end
        else
        begin
          if BrandReplTable.FindKey([sBrand]) and (BrandReplTable.FieldByName('Repl_brand').AsString <> '') then
            rp := BrandReplTable.FieldByName('Repl_brand').AsString
          else
            rp := sBrand;

          if TDArtTable.FindKey([MakeSearchCode(sCode), rp]) then
          begin
            Inc(td_cnt);
            td_id := TDArtTable.FieldByName('Art_id').AsInteger;
            //[pict]
            pict_id := TDArtTable.FieldByName('pict_id').AsInteger;
            typ_id := TDArtTable.FieldByName('typ_id').AsInteger;
            param_id := TDArtTable.FieldByName('param_id').AsInteger;
          end
          else
          begin
            td_id := 0;
            pict_id := 0;
            typ_id := 0;
            param_id := 0;
          end;

          UpdateCatalog.Append;
          UpdateCatalog.FieldByName('Cat_id').Value      := iCatalog;
          UpdateCatalog.FieldByName('Brand_id').Value    := brand_id;
          UpdateCatalog.FieldByName('Group_id').Value    := iGroupe;
          UpdateCatalog.FieldByName('Subgroup_id').Value := iSubGroupe;
          UpdateCatalog.FieldByName('Code').Value        := sCode;
          UpdateCatalog.FieldByName('Code2').Value       := MakeSearchCode(sCode);
          UpdateCatalog.FieldByName('Name').Value        := aReader.Fields[4];
          UpdateCatalog.FieldByName('Description').Value := aReader.Fields[7];
          UpdateCatalog.FieldByName('Price').Value       := Main.AToCurr(aReader.Fields[2]);
          UpdateCatalog.FieldByName('T1').Value          := 1;
          UpdateCatalog.FieldByName('T2').Value          := 1;
          UpdateCatalog.FieldByName('Tecdoc_id').Value   := td_id;
          UpdateCatalog.FieldByName('New').Value         := aReader.Fields[10];
          UpdateCatalog.FieldByName('Sale').Value        := aReader.Fields[9];
          UpdateCatalog.FieldByName('Mult').Value        := StrInt(aReader.Fields[11]);
          UpdateCatalog.FieldByName('Usa').Value         := aReader.Fields[12];
          UpdateCatalog.FieldByName('NewItem').Value     := 1;
          UpdateCatalog.FieldByName('DELITEM').Value     := 0;

          //[pict]
          UpdateCatalog.FieldByName('pict_id').AsInteger := pict_id;
          UpdateCatalog.FieldByName('typ_tdid').AsInteger := typ_id;
          UpdateCatalog.FieldByName('param_tdid').AsInteger := param_id;

          UpdateCatalog.Post;
          Inc(iCatalog);
        end;
      except
        on E: Exception do
        begin
          MessageDlg(e.Message, mtError, [mbOk], 0);
          Break;
        end;
      end;

      Main.CurrProgress(aReader.FilePosPercent);
    end; //while

    LoadLotusTitles(iCatalog);
  finally
    aReader.Free;
    TDArtTable.Close;
    BrandReplTable.Close;
    BrandReplTable.DeleteTable;
    UpdateBrand.Close;
    UpdateTree.Close;
    LoadNewPrimen(UpdateCatalog);
    UpdateCatalog.Close;
    BrandReplTable.Close;
    Main.HideProgress;

    MessageDlg('Загрузка завершена', mtInformation, [mbOk], 0);
  end;
end;


//загрузка применяемости для нового обновления
procedure TData.LoadNewPrimen(tb1:TDBISAMTable);
var
  s: string;
  cnt: integer;
begin
  Main.ShowProgress;
  Main.ShowProgrInfo('Загрузка списка авто в каталог...');
  //LoadArtTypTable.Open;
  TestTable(UpdatePrimen);

  UpdatePrimen.Close;
  UpdatePrimen.EmptyTable;
  UpdatePrimen.Open;

  with TypesTable do
  begin
    First;
    cnt := 0;
    while not EOF do
    begin
      if not FieldByName('MfaHide').AsBoolean then
      begin
        UpdatePrimen.Append;
        UpdatePrimen.FieldByName('Type_ID').Value:= FieldByName('Typ_id').AsInteger;
        UpdatePrimen.Post;
      end;

      if cnt <> (RecNo*100) div RecordCount then
      begin
        cnt := (RecNo*100) div RecordCount;
        Main.CurrProgress(cnt);
      end;

      Next;
    end;
  end;

  Main.HideProgress;

  Main.ShowProgress;
  Main.ShowProgrInfo('Загрузка применяемости в каталог...');
  LoadArtTypTable.Open;
  cnt := 0;

  with tb1 do
  begin
    First;
    while not EOF do
    begin
      if FieldByName('typ_tdid').AsInteger <> 0 then
      begin
        s := '';
        with LoadArtTypTable do
        begin
          SetRange([tb1.FieldByName('typ_tdid').AsInteger], [tb1.FieldByName('typ_tdid').AsInteger]);
          First;
          while not Eof do
          begin
            if  UpdatePrimen.Locate('Type_ID', LoadArtTypTable.FieldByName('Typ_id').AsInteger, []) then
            begin
              s := s + LoadArtTypTable.FieldByName('Typ_id').AsString+',';
              UpdatePrimen.Edit;
              if UpdatePrimen.FieldByName('Cat_ID').AsString <> '' then
                UpdatePrimen.FieldByName('Cat_ID').Value:= TableCarFilter.FieldByName('Cat_ID').AsString +', '+ tb1.FieldByName('Cat_ID').AsString
              else
                UpdatePrimen.FieldByName('Cat_ID').Value:= tb1.FieldByName('Cat_ID').AsString;
              UpdatePrimen.Post;
            end;
            Next;
          end;

          tb1.Edit;
          tb1.FieldByName('Primen').Value := s;
          tb1.Post;
          CancelRange;
        end;
      end;

      if cnt <> (RecNo*100) div RecordCount then
      begin
        cnt := (RecNo*100) div RecordCount;
        Main.CurrProgress(cnt);
      end;

      Next;
    end;
  end;

  LoadArtTypTable.Close;
  UpdatePrimen.Close;
  Main.HideProgress;
end;



procedure TData.LoadLotusTitles(st: integer);
var
  i, gr, sgr, br: integer;
begin
  i := st;
  UpdateBrand.IndexName := 'Descr';
  with UpdateTree do
  begin
    IndexName := 'Descr';
    First;
    while not Eof do
    begin
      if FieldByName('DELITEM').AsInteger = 0 then
      begin
        gr := FieldByName('Group_id').AsInteger;
        with UpdateCatalog do
        begin
          Append;
          FieldByName('Cat_id').Value := i;
          FieldByName('Group_id').Value := gr;
          FieldByName('Subgroup_id').Value := 0;
          FieldByName('Brand_id').Value := 0;
          FieldByName('Description').Value :=
          UpdateTree.FieldByName('Group_descr').AsString;
          FieldByName('T1').Value := 1;
          FieldByName('T2').Value := 0;
          FieldByName('Title').Value := True;
          FieldByName('NewItem').Value := 1;
          Post;
        end;
        Inc(i);


        while (not Eof) and (FieldByName('Group_id').AsInteger = gr)and(FieldByName('DELITEM').AsInteger = 0) do
        begin
          sgr := FieldByName('Subgroup_id').AsInteger;
          with UpdateCatalog do
          begin
            Append;
            FieldByName('Cat_id').Value := i;
            FieldByName('Group_id').Value := gr;
            FieldByName('Subgroup_id').Value := sgr;
            FieldByName('Brand_id').Value := 0;
            FieldByName('Description').Value := UpdateTree.FieldByname('Subgroup_descr').AsString;
            FieldByName('T1').Value := 1;
            FieldByName('T2').Value := 0;
            FieldByName('Title').Value := True;
            FieldByName('NewItem').Value := 1;
            Post;
          end;
          Inc(i);

          TestQuery.Close;
          TestQuery.SQL.Clear;
          TestQuery.SQL.Add('SELECT * FROM TREEID, BRAND WHERE TREEID.DELITEM = 0 AND BRAND.DELITEM = 0 AND TREEID.Group_id ='+IntToStr(gr)+' AND TREEID.Subgroup_id = '+IntToStr(sgr)+' AND TREEID.Brand_id = BRAND.Brand_id ORDER BY BRAND.Description');
          TestQuery.Active:= TRUE;
          while not TestQuery.EOF do
            begin
              with UpdateCatalog do
                begin
                Append;
                FieldByName('Cat_id').Value := i;
                FieldByName('Group_id').Value := gr;
                FieldByName('Subgroup_id').Value := sgr;
                br := TestQuery.FieldByName('Brand_id').AsInteger;
                FieldByName('Brand_id').Value := br;
                FieldByName('Description').Value := TestQuery.FieldByName('Description').AsString;
                FieldByName('T1').Value := 1;
                FieldByName('T2').Value := 0;
                FieldByName('Title').Value := True;
                FieldByName('NewItem').Value := 1;
                Post;
                end;
              Inc(i);
              TestQuery.Next;
            end;
          TestQuery.Active:= FALSE;
          Next;
          end;
      end
      else
      Next;
    end;
  end;


  with TestQuery do
  begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TREEID, BRAND, TREE WHERE BRAND.DELITEM = 0 AND TREEID.DELITEM = 0');
      SQL.Add('AND TREE.DELITEM = 0 AND TREEID.Subgroup_id = TREE.Subgroup_id AND TREEID.Group_id = TREE.Group_id AND TREEID.Brand_id = BRAND.Brand_id ORDER BY BRAND.Description, Group_descr, Subgroup_descr');
      Active:= TRUE;
      while not Eof do
      begin
      br := FieldByName('Brand_id').AsInteger;
      with UpdateCatalog do
      begin
        Append;
        FieldByName('Cat_id').Value      := i;
        FieldByName('Group_id').Value    := 0;
        FieldByName('Subgroup_id').Value := 0;
        FieldByName('Brand_id').Value    := br;
        FieldByName('Description').Value := TestQuery.FieldByname('Description').AsString;
        FieldByName('T1').Value := 0;
        FieldByName('T2').Value := 1;
        FieldByName('Title').Value := True;
        FieldByName('NewItem').Value := 1;
        Post;
      end;
      Inc(i);
      gr := -1;
      while (br = TestQuery.FieldByName('Brand_id').AsInteger)AND not Eof do
      begin
         if gr <> TestQuery.FieldByName('Group_id').AsInteger then
         begin
           gr  := TestQuery.FieldByName('Group_id').AsInteger;
         end;

         with UpdateCatalog do
            begin
              Append;
              FieldByName('Cat_id').Value   := i;
              FieldByName('Brand_id').Value := br;
              FieldByName('Group_id').Value := gr;
              FieldByName('Subgroup_id').Value := TestQuery.FieldByName('Subgroup_id').AsInteger;
              FieldByName('Description').Value := TestQuery.FieldByName('Subgroup_descr').AsString;
              FieldByName('T1').Value := 0;
              FieldByName('T2').Value := 1;
              FieldByName('Title').Value := True;
              FieldByName('NewItem').Value := 1;
              Post;
            end;
            Inc(i);
            Next;
          end;
        end;
    Active:= FALSE;
  end;
end;


procedure TData.CopyTableBase(sTableName, sTableNameNew: string; aReplace: Boolean = True);
begin
  if FileExists(Data_Path + sTableNameNew + '.1') and not aReplace then
    Exit;
    
  CopyFile(PANSIChar(Data_Path+sTableName+'.1'),PANSIChar(Data_Path+sTableNameNew+'.1'),False);
  CopyFile(PANSIChar(Data_Path+sTableName+'.2'),PANSIChar(Data_Path+sTableNameNew+'.2'),False);
  CopyFile(PANSIChar(Data_Path+sTableName+'.3'),PANSIChar(Data_Path+sTableNameNew+'.3'),False);
end;

procedure TData.RememberMaxGenAnID(Value: string; TableNum: integer);
begin
  case TableNum of
    1: MaxGenAnID.MaxGenAnIdFromTable_1 := StrToIntDef(Value, -1);
    2: MaxGenAnID.MaxGenAnIdFromTable_2 := StrToIntDef(Value, -1);
    3: MaxGenAnID.MaxGenAnIdFromTable_3 := StrToIntDef(Value, -1);
    4: MaxGenAnID.MaxGenAnIdFromTable_4 := StrToIntDef(Value, -1);
    5: MaxGenAnID.MaxGenAnIdFromTable_5 := StrToIntDef(Value, -1);
  end;
end;

procedure TData.RemoveTableFromBase(sTableName:string);
begin
  DeleteFile(PANSIChar(Data_Path+sTableName+'.1'));
  DeleteFile(PANSIChar(Data_Path+sTableName+'.2'));
  DeleteFile(PANSIChar(Data_Path+sTableName+'.3'));
  DeleteFile(PANSIChar(Data_Path+sTableName+'.1_'));
  DeleteFile(PANSIChar(Data_Path+sTableName+'.2_'));
  DeleteFile(PANSIChar(Data_Path+sTableName+'.3_'));
  DeleteFile(PANSIChar(Data_Path+sTableName+'.1~'));
  DeleteFile(PANSIChar(Data_Path+sTableName+'.2~'));
  DeleteFile(PANSIChar(Data_Path+sTableName+'.3~'));
  DeleteFile(PANSIChar(Data_Path+sTableName+'.1$'));
  DeleteFile(PANSIChar(Data_Path+sTableName+'.2$'));
  DeleteFile(PANSIChar(Data_Path+sTableName+'.3$'));
end;


function TData.RenameTableDBI(sTableName, sTableNameNew: string): Boolean;
begin
  DeleteFile(PANSIChar(Data_Path+sTableNameNew+'.1'));
  DeleteFile(PANSIChar(Data_Path+sTableNameNew+'.2'));
  DeleteFile(PANSIChar(Data_Path+sTableNameNew+'.3'));
  DeleteFile(PANSIChar(Data_Path+sTableNameNew+'.1_'));
  DeleteFile(PANSIChar(Data_Path+sTableNameNew+'.2_'));
  DeleteFile(PANSIChar(Data_Path+sTableNameNew+'.3_'));
  DeleteFile(PANSIChar(Data_Path+sTableNameNew+'.1~'));
  DeleteFile(PANSIChar(Data_Path+sTableNameNew+'.2~'));
  DeleteFile(PANSIChar(Data_Path+sTableNameNew+'.3~'));
  DeleteFile(PANSIChar(Data_Path+sTableNameNew+'.1$'));
  DeleteFile(PANSIChar(Data_Path+sTableNameNew+'.2$'));
  DeleteFile(PANSIChar(Data_Path+sTableNameNew+'.3$'));

  RenameFile(PANSIChar(Data_Path+sTableName+'.1'),PANSIChar(Data_Path+sTableNameNew+'.1'));
  RenameFile(PANSIChar(Data_Path+sTableName+'.2'),PANSIChar(Data_Path+sTableNameNew+'.2'));
  RenameFile(PANSIChar(Data_Path+sTableName+'.3'),PANSIChar(Data_Path+sTableNameNew+'.3'));

  RenameFile(PANSIChar(Data_Path+sTableName+'.1_'),PANSIChar(Data_Path+sTableNameNew+'.1_'));
  RenameFile(PANSIChar(Data_Path+sTableName+'.2_'),PANSIChar(Data_Path+sTableNameNew+'.2_'));
  RenameFile(PANSIChar(Data_Path+sTableName+'.3_'),PANSIChar(Data_Path+sTableNameNew+'.3_'));


  RenameFile(PANSIChar(Data_Path+sTableName+'.1~'),PANSIChar(Data_Path+sTableNameNew+'.1~'));
  RenameFile(PANSIChar(Data_Path+sTableName+'.2~'),PANSIChar(Data_Path+sTableNameNew+'.2~'));
  RenameFile(PANSIChar(Data_Path+sTableName+'.3~'),PANSIChar(Data_Path+sTableNameNew+'.3~'));

  RenameFile(PANSIChar(Data_Path+sTableName+'.1$'),PANSIChar(Data_Path+sTableNameNew+'.1$'));
  RenameFile(PANSIChar(Data_Path+sTableName+'.2$'),PANSIChar(Data_Path+sTableNameNew+'.2$'));
  RenameFile(PANSIChar(Data_Path+sTableName+'.3$'),PANSIChar(Data_Path+sTableNameNew+'.3$'));

  Result := True;
end;

procedure TData.ReturnDocDetTableCalcFields(DataSet: TDataSet);
var
  k :integer;
begin
  with DataSet do
  begin
    k := ReturnMasChek.IndexOf(Pointer(FieldByName('id').AsInteger));
    FieldByname('CheckField').AsBoolean :=  k >= 0;

    FieldByName('BrandRepl').AsString := ReBranding(FieldByName('Brand').AsString); {ReBranding}
    if BrandTable.Locate('Description', FieldByName('Brand').AsString, []) and
       XCatTable.FindKey([FieldByName('Code2').AsString,
                          BrandTable.FieldByName('Brand_id').AsInteger]) then
    begin
      FieldByname('Code').Value := XCatTable.FieldByName('Code').AsString;
      FieldByname('Cat_ID').Value := XCatTable.FieldByName('Cat_ID').AsInteger;
      FieldByname('Description').Value :=XCatTable.FieldByName('Name').AsString +' '+ XCatTable.FieldByName('Description').AsString;
    end;
  end;
end;

procedure TData.ReturnDocTableBeforeScroll(DataSet: TDataSet);
begin
 if main.fClearSelection then
 begin
   Main.ReturnDocDetGrid.Columns.Items[0].Title.ImageIndex := 2;
   Data.ReturnMasChek.Clear;
 end;
 ReturnDocDetTable.Resync([rmCenter]);

end;

procedure TData.ReturnDocTableCalcFields(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if (FieldByName('ClientLookup').IsNull) or (ParamTable.FieldByName('Cli_id_mode').AsString <> '1') then
      FieldByName('ClientInfo').Value := FieldByName('Cli_id').AsString
    else
      FieldByName('ClientInfo').Value := FieldByName('ClientLookup').AsString;
{
     if Main.UserIds_Combo.ItemIndex > -1 then
      FieldByName('ClientInfo').Value := Main.UserIds_Combo.Text;
}      
  end;
end;

procedure TData.LoadLotusAnalog(CSVFile: string);
var
  logFile: TextFile;
  i: Integer;
  cat_br_str, cat_code, an_br_str, an_code: string;
  cat_br_id, cat_id, an_id, an_br_id: Integer;
  bDelete: string;

  aReader: TCSVReader;
begin
  RemoveTableFromBase('ANALOG');
  Main.ShowProgrInfo('Копирование [007]');

  TestQuery.Close;
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('SELECT [007].*, 1 AS DELITEM, 0 AS EDITITEM, 0 AS NEWITEM INTO ANALOG FROM [007]');
  TestQuery.Active := True;
  TestQuery.Active := False;

  UpdateBrand.IndexName := 'DescrDel';
  UpdateBrand.Open;
  UpdateCatalog.IndexName := 'CodeBrandDel';
  UpdateCatalog.Open;
  try //except
    UpdateAnalog.AddIndex('Descr', 'Cat_id;An_code;An_Brand', [ixCaseInsensitive]);
    UpdateAnalog.Open;
    UpdateAnalog.IndexName := 'Descr';

    AssignFile(logFile, GetAppDir + 'LoadAnalogs.log');
    Rewrite(logFile);
    Writeln(logFile, 'Начало обработки!');

    cat_id := 0;
    an_id := 0;

    Main.ShowProgress('Загрузка базы аналогов...');
    aReader := TCSVReader.Create;
    try //finally
      aReader.Open(CSVFile);
      while not aReader.Eof do
      begin
        aReader.ReturnLine;
        Main.CurrProgress(aReader.FilePosPercent);

        cat_br_str := aReader.Fields[0];
        cat_code   := aReader.Fields[1];
        an_br_str  := aReader.Fields[2];
        an_code    := aReader.Fields[3];
        an_br_id   := 0;

        with UpdateBrand do
        begin
          First;
          if FindKey([Cat_br_str,0]) then
          begin
            cat_br_id := FieldByName('Brand_id').AsInteger;
            if FieldByName('DELITEM').AsInteger = 1 then
            begin
              //Writeln(logFile, 'Бренд удален <' + Cat_br_str + '> в строке ' + aReader.CurrentLine);
              Continue;
            end;
          end
          else
          begin
            //Writeln(logFile, 'Бренд не распознан <' + Cat_br_str + '> в строке ' + aReader.CurrentLine);
            cat_br_id := 0;
            Continue;
          end;
          First;
          if FindKey([An_br_str,0]) then
          begin
            if FieldByName('DELITEM').AsInteger = 1 then
            begin
              //Writeln(logFile, 'Бренд удален <' + An_br_str + '> в строке ' + aReader.CurrentLine)
            end
            else
              an_br_id := FieldByName('Brand_id').AsInteger
          end
          else
          begin
            //Writeln(logFile, 'Бренд не распознан <' + An_br_str + '> в строке ' + aReader.CurrentLine);
            an_br_id := 0;
          end;
        end;

        with UpdateCatalog do
        begin
          if FindKey([MakeSearchCode(cat_code), cat_br_id, 0]) then
          begin
            if FieldByName('DELITEM').AsInteger = 0 then
              cat_id := FieldByName('Cat_id').AsInteger
            else
            begin
              //Writeln(logFile, 'Позиция удалена <' + Cat_code + ' ' + Cat_br_str + '> в строке ' + aReader.CurrentLine);
              Continue;
            end;
          end
          else
          begin
            //Writeln(logFile, 'Базовая позиция не идентифицирована <' +
              //      Cat_code + ' ' + Cat_br_str + '> в строке ' + aReader.CurrentLine);
            cat_id := 0;
            Continue;
          end;

          if FindKey([MakeSearchCode(an_code), an_br_id, 0]) then
          begin
            if FieldByName('DELITEM').AsInteger = 1 then
              an_id := 0
            else
              an_id := FieldByName('Cat_id').AsInteger;
          end
          else
          begin
            //Writeln(logFile,'Позиция аналога не идентифицирована в строке ' + aReader.CurrentLine);
            an_id := 0;
          end;
        end;


        with UpdateAnalog do
        begin
          if cat_id = 0 then
          begin
            //Writeln(logFile, '!!!Проверь код!!! - '+ Cat_code + '_' + Cat_br_str);
            cat_id := 0;
          end
          else
          begin
            if not FindKey([cat_id, an_code, an_br_str]) then
            begin
              Append;
              FieldByName('Cat_id').Value   := cat_id;
              FieldByName('An_Code').Value  := an_code;
              FieldByName('An_Brand').Value := an_br_str;
              FieldByName('An_id').Value    := an_id;
              FieldByName('NEWITEM').Value  := 1;
              Post;
            end
            else
              if FieldByName('DELITEM').AsString = '1' then
              begin
                Edit;
                if FieldByName('An_id').Value <> an_id then
                begin
                  FieldByName('An_id').Value := an_id;
                  FieldByName('EDITITEM').Value := 1;
                end;
                FieldByName('DELITEM').Value := 0;
                Post;
              end
              else
              begin
                //Writeln(logFile, '!!!Повтор аналога!!! - ' + Cat_code + '_' + Cat_br_str + ';' + an_code + '_' + an_br_str);
              end;
          end;
        end;
      end; //while

      aReader.Close;
      UpdateCatalog.Close;
      UpdateBrand.Close;
      UpdateAnalog.Close;
      Writeln(logFile, 'Конец обработки!');

    finally
      aReader.Free;
      CloseFile(logFile);
      Main.HideProgress;
    end;

  except
    on E: Exception do
      MessageDlg(e.Message, mtError, [mbOk], 0);
  end;
  
  MessageDlg('Загрузка завершена', mtInformation, [mbOk], 0);
end;

procedure TData.LoadLotusAnalog_new(CSVFile: string);
var
  i: integer;
  s, cat_br_str, an_br_str, cat_code, an_code: string;
  cat_br_id, an_br_id, cat_id, an_id: integer;
  fname, br: string;
  FBrandFile:TextFile;
  aReader: TCSVReader;
  aNewID: Integer;

  procedure AddToTable;
  begin
    with UpdateBrand do
    begin
      if FindKey([Cat_br_str, 0]) then
        cat_br_id := FieldByName('Brand_id').AsInteger
      else
      begin
        WLog('Бренд не распознан <' + Cat_br_str + '> в строке ' + IntToStr(i));
        cat_br_id := 0;
      end;
      if FindKey([An_br_str, 0]) then
        an_br_id := FieldByName('Brand_id').AsInteger
      else
      begin
        WLog('Бренд не распознан <' + Cat_br_str + '> в строке ' + IntToStr(i));
        an_br_id := 0;
      end;
    end;

    with UpdateCatalog do
    begin
      if FindKey([MakeSearchCode(cat_code), cat_br_id, 0]) then
        cat_id := FieldByName('Cat_id').AsInteger
      else
      begin
        WLog('Базовая позиция не идентифицирована <' +
              Cat_code + ' / ' + Cat_br_str + '> в строке ' + IntToStr(i));
        cat_id := 0;
      end;
      if FindKey([MakeSearchCode(an_code), an_br_id, 0]) then
        an_id := FieldByName('Cat_id').AsInteger
      else
      begin
        WLog('Позиция аналога не идентифицирована <' +
              Cat_code + ' / ' + Cat_br_str + '> в строке ' + IntToStr(i));
        an_id := 0;
      end;
    end;

    with UpdateAnalog do
    begin
      if cat_id = 0 then
      begin
        if (an_id <> 0) and (not FindKey([an_id, cat_code])) then
        begin
          Append;
          FieldByName('DELITEM').AsString := '0';
          FieldByName('Cat_id').Value   := an_id;
          FieldByName('An_Code').Value  := cat_code;
          FieldByName('An_ShortCode').Value  := CreateShortCode(cat_code);
          FieldByName('An_id').Value    := 0;
          if  LockBrand.FindKey([Cat_br_str]) then
              begin
                FieldByName('An_Brand').Value := '';
               FieldByName('Locked').Value    := 1;
              end
            else
              begin
               FieldByName('An_Brand').Value := cat_br_str;
               FieldByName('Locked').Value    := 0;
              end;

          //получить ID из старой таблицы
          if LoadAnTable.Locate(
            'Cat_id;An_Code;An_Brand',
            VarArrayOf([FieldByName('Cat_id').Value, FieldByName('An_Code').Value, FieldByName('An_Brand').Value]),
            []) then
          begin
            FieldByName('id').Value := LoadAnTable.FieldByName('id').Value;
            FieldByName('NEWITEM').AsString := '0';
            if FieldByName('An_id').AsInteger <> LoadAnTable.FieldByName('An_id').AsInteger then
              FieldByName('EDITITEM').AsString := '1'
            else
              FieldByName('EDITITEM').AsString := '0'; //не изменен

            UpdateAnalogDel.Locate('id', FieldByName('id').Value, []);
            UpdateAnalogDel.Edit;
            UpdateAnalogDel.FieldByName('DELITEM').AsString := '0';
            UpdateAnalogDel.Post;
          end
          else
          begin
            FieldByName('id').AsInteger := aNewID;
            Inc(aNewID);
            FieldByName('NEWITEM').AsString := '1';
            FieldByName('EDITITEM').AsString := '0';
          end;

          Post;
        end
        else if an_id <> 0 then
          WLog('Повтор позиции <' +
                Cat_code + ' / ' + Cat_br_str + '> в строке ' + IntToStr(i));
      end
      else
      begin
        if not FindKey([cat_id, an_code]) then
        begin
          Append;
          FieldByName('DELITEM').AsString := '0';
          FieldByName('Cat_id').Value   := cat_id;
          FieldByName('An_Code').Value  := an_code;
          FieldByName('An_ShortCode').Value  := CreateShortCode(an_code);
          FieldByName('An_Brand').Value := an_br_str;
          FieldByName('An_id').Value    := an_id;
          if LockBrand.FindKey([Cat_br_str]) then
              begin
                FieldByName('An_Brand').Value := '';
                FieldByName('Locked').Value    := 1;
              end
            else
             begin
               FieldByName('An_Brand').Value := an_br_str;
               FieldByName('Locked').Value    := 0;
             end;


          //получить ID из старой таблицы
          if LoadAnTable.Locate(
            'Cat_id;An_Code;An_Brand',
            VarArrayOf([FieldByName('Cat_id').Value, FieldByName('An_Code').Value, FieldByName('An_Brand').Value]),
            []) then
          begin
            FieldByName('id').Value := LoadAnTable.FieldByName('id').Value;
            FieldByName('NEWITEM').AsString := '0';
            if FieldByName('An_id').AsInteger <> LoadAnTable.FieldByName('An_id').AsInteger then
              FieldByName('EDITITEM').AsString := '1'
            else
              FieldByName('EDITITEM').AsString := '0'; //не изменен

            UpdateAnalogDel.Locate('id', FieldByName('id').Value, []);
            UpdateAnalogDel.Edit;
            UpdateAnalogDel.FieldByName('DELITEM').AsString := '0';
            UpdateAnalogDel.Post;
          end
          else
          begin
            FieldByName('id').AsInteger := aNewID;
            Inc(aNewID);
            FieldByName('NEWITEM').AsString := '1';
            FieldByName('EDITITEM').AsString := '0';
          end;

         Post;
        end
        else
          WLog('Повтор аналога <' +
                An_code + ' / ' + An_br_str + '> в строке ' + IntToStr(i));

      end;
    end;
  end;

begin
  Main.ShowProgress('Загрузка базы аналогов...');
  TestTable(LockBrand);
  LockBrand.Open;
  fname := GetAppDir + 'LockedBrand.txt';
  if not FileExists(fname) then
    exit;
  AssignFile(FBrandFile, fname);
  Reset(FBrandFile);
  while not System.Eof(FBrandFile) do
  begin
    Readln(FBrandFile, s);
    br := ExtractDelimited(1,  s, [';']);
    with LockBrand do
    begin
      Append;
      FieldByName('Brand').Value := br;
      Post;
    end;
  end;
  CloseFile(FBrandFile);
  LockBrand.IndexName := 'Brand';


  RemoveTableFromBase('ANALOG');
  RemoveTableFromBase('ANALOGDEL');
  Main.ShowProgrInfo('Копирование [007]');

  TestQuery.Close;
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('SELECT [007].*, 1 AS DELITEM, 0 AS EDITITEM, 0 AS NEWITEM INTO ANALOG FROM [007] TOP 1');
  TestQuery.Active := True;
  TestQuery.Active := False;

  with UpdateAnalog do
  begin
    EmptyTable;
    UpdateAnalog.AddIndex('Descr', 'Cat_id;An_code', [ixCaseInsensitive]);
    UpdateAnalog.IndexName := 'Descr';
    Open;
  end;

  TestQuery.Close;
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('SELECT [007].ID, 1 AS DELITEM INTO ANALOGDEL FROM [007]');
  TestQuery.Active := True;
  TestQuery.Active := False;
  UpdateAnalogDel.AddIndex('delid', 'id', [ixUnique]);
  UpdateAnalogDel.IndexName := 'delid';
  UpdateAnalogDel.Open;

  LoadAnTable.Open;
  LoadAnTable.IndexName := '';
  LoadAnTable.Last;
  aNewID := LoadAnTable.FieldByName('id').AsInteger + 1;
  LoadAnTable.First;


  UpdateBrand.IndexName := 'DescrDel';
  UpdateBrand.Open;

  UpdateCatalog.IndexName := 'CodeBrandDel';
  UpdateCatalog.Open;

  StartLog('LoadAnalogsNew.log');
  i := 1;
  aReader := TCSVReader.Create;
  try //finally
    aReader.Open(CSVFile);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;

      cat_br_str := aReader.Fields[0];
      cat_code   := aReader.Fields[1];
      an_br_str  := aReader.Fields[2];
      an_code    := aReader.Fields[3];
      AddToTable;
      Inc(i);
      if i mod 500 = 0 then
        Main.CurrProgress(aReader.FilePosPercent);
    end;
  finally
    aReader.Free;
  end;
  StopLog;
  LoadAnTable.Close;
  UpdateAnalogDel.Close;
  
  UpdateAnalog.Close;
  UpdateCatalog.Close;
  UpdateBrand.Close;

  LockBrand.Close;
  LockBrand.Free;
  Main.HideProgress;
end;

procedure TData.LoadLotusOE(CSVFile: string);

  function GetNormOE(const aOE: string): string;
  const
    aSupportsSimbols: set of char = ['a'..'z', 'A'..'Z', 'а'..'я', 'А'..'Я', '1'..'9', '0', '.', ' ', '-'];
  var
    i, aLen: Integer;
  begin
    Result := '';
    aLen := Length(aOE);
    for i := 1 to aLen do
      if aOE[i] in aSupportsSimbols then
        Result := Result + aOE[i];
  end;

var
  logFile: TextFile;
  cat_code, cat_brand, cb, oe_code: string;
  brand_id, cat_id: Integer;

  aReader: TCSVReader;
begin
  RemoveTableFromBase('OE');
  Main.ShowProgrInfo('Копирование [016]');
  TestQuery.Close;
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('SELECT [016].*, 1 AS DELITEM, 0 AS NEWITEM INTO OE FROM [016]');
  TestQuery.Active:= TRUE;
  TestQuery.Active:= FALSE;

  try //except
    UpdateOE.AddIndex('Descr','Cat_id;Code',  [ixCaseInsensitive]);
    UpdateOE.Open;
    UpdateOE.IndexName := 'Descr';

    AssignFile(logFile, GetAppDir + 'LoadOE.log');
    Rewrite(logFile);
    Writeln(logFile,'Начало обработки!');

    Main.ShowProgress('Загрузка базы OE...');

    UpdateBrand.Open;
    UpdateBrand.IndexName := 'DescrDel';

    UpdateCatalog.Open;
    UpdateCatalog.IndexName := 'CodeBrandDel';

    aReader := TCSVReader.Create;
    try //finally
      aReader.Open(CSVFile);
      while not aReader.Eof do
      begin
        aReader.ReturnLine;
        Main.CurrProgress(aReader.FilePosPercent);

        cb := aReader.Fields[0];
        DecodeCodeBrand(cb, cat_code, cat_brand);
        oe_code := GetNormOE(aReader.Fields[1]);

        with UpdateBrand do
        begin
          if FindKey([Cat_brand, 0]) then
            if FieldByName('DELITEM').AsInteger = 0 then
              brand_id := FieldByName('Brand_id').AsInteger
            else
            begin
              //Writeln( logFile, Format('Бренд удален в строке [%d]%s', [aReader.LineNum, aReader.CurrentLine]) );
              brand_id := 0;
              Continue;
            end
          else
          begin
            //Writeln( logFile, Format('Бренд не распознан <%s> в строке [%d]%s', [cat_brand, aReader.LineNum, aReader.CurrentLine]) );
            brand_id := 0;
          end;
        end;

        if (cat_code <> '') and (brand_id > 0) then
        begin
          with UpdateOE do
          begin
            if UpdateCatalog.FindKey([cat_code, brand_id, 0]) then
            begin
              if not FindKey([UpdateCatalog.FieldByName('Cat_id').AsInteger, oe_code]) then
              begin
                Append;
                FieldByName('Cat_id').Value   := UpdateCatalog.FieldByName('Cat_id').AsInteger;
                FieldByName('Code').Value     := oe_code;
                FieldByName('Code2').Value    := MakesearchCode(oe_code);
                FieldByName('NEWITEM').Value  := 1;
                Post;
              end
              else
              begin
                if UpdateCatalog.FieldByName('DELITEM').AsInteger = 0 then
                begin
                  Edit;
                  FieldByName('DELITEM').Value := 0;
                  Post;
                end
                else
                begin
                  //Writeln( logFile, Format('Поз. удалена <%s> в строке [%d]%s', [Cat_brand, aReader.LineNum, aReader.CurrentLine]) );
                end;
              end;
            end
            else
            begin
              //Writeln( logFile, Format('Поз. не найдена <%s/%s> в строке [%d]%s', [Cat_code, Cat_brand, aReader.LineNum, aReader.CurrentLine]));
            end;

          end;
        end;
      end;

      aReader.Close;
      UpdateCatalog.Close;
      UpdateBrand.Close;
      UpdateOE.Close;
      Writeln(logFile, 'Конец обработки!');

    finally
      aReader.Free;
      CloseFile(logFile);
      Main.HideProgress;
    end;
    
  except
    on E: Exception do
      MessageDlg(e.Message, mtError, [mbOk], 0);
  end;

  MessageDlg('Загрузка завершена', mtInformation, [mbOk], 0);
end;

function TData.makeCsvRec(const aValues: array of string; aDelimitter: Char = ';'): string;
var
  i: Integer;
begin
  Result := '';
  for i := Low(aValues) to High(aValues) do
    Result := Result + aValues[i] + aDelimitter;
end;

procedure TData.TestLotusCatalog;
  //возвращает позицию в процентах (для прогресса)
  function GetPercent(aPos, aMax: Integer): Integer;
  begin
    if aMax = 0 then
      Result := 100
    else
      Result := (aPos * 100) div aMax;
  end;
var
  fileCSV: TextFile;
  s: string;
  iPos, iField: Integer;

 // d, m, y: Word;
  aDiscretUpdateSize: Cardinal;
  anUpdUrl, aVer: string;
begin
//Выгрузка файла изменений
{
   Select TREE.Subgroup_descr, Brand.Description, Code, Name, CATALOG.Group_id, TREE.Group_id, CATALOG.Subgroup_id, TREE.Subgroup_id, CATALOG.Brand_Id, BRAND.Brand_Id, CATALOG.NEWITEM,CATALOG.DELITEM,Code2
   from CATALOG, BRAND, TREE WHERE (CATALOG.DELITEM = 1 OR CATALOG.NEWITEM = 1 )AND(Code2 <> '') And (CATALOG.Brand_Id = BRAND.Brand_Id) AND (CATALOG.Group_id = TREE.Group_id)AND(CATALOG.Subgroup_id = TREE.Subgroup_id) ORDER BY DELITEM, TREE.Subgroup_descr, Brand.Description
}


  Main.ShowProgress('Выгрузка списка изменений...');
  TestQuery.Close;
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select CATALOG.DELITEM,TREE.Subgroup_descr, Brand.Description, Code, Name, CATALOG.Group_id, TREE.Group_id, CATALOG.Subgroup_id, TREE.Subgroup_id,');
  TestQuery.SQL.Add(' CATALOG.Brand_Id, BRAND.Brand_Id, CATALOG.NEWITEM,Code2 from CATALOG, BRAND, TREE WHERE (CATALOG.DELITEM = 1 OR ');
  TestQuery.SQL.Add('CATALOG.NEWITEM = 1 )AND(Code2 <> '''+''') And (CATALOG.Brand_Id = BRAND.Brand_Id) AND (CATALOG.Group_id = TREE.Group_id)AND(CATALOG.Subgroup_id = TREE.Subgroup_id) ORDER BY DELITEM, TREE.Subgroup_descr, Brand.Description');
  TestQuery.ExecSQL;


  AssignFile(fileCSV, Update_Path + 'UpdateInfo.csv');
  Rewrite(fileCSV);
  iPos := 0;

  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
       iPos:=iPos+1;
       s:='';
       for iField := 0 to 4 do
       begin
         s := s + Fields[iField].AsString+';';
       end;
       Writeln(fileCSV, s);
      {if FieldByName('DELITEM').AsInteger = 0 then
       begin
         s := '0;';
         s := s + FieldByName('Id').AsString+';';
         s := s + FieldByName('Brand_id').AsString+';';
         s := s + FieldByName('Description').AsString+';';
         Writeln(fileCSV, s);
       end
       else
       begin
         s := '1;';
         s := s + FieldByName('Id').AsString+';';
         s := s + FieldByName('Brand_id').AsString+';';
         s := s + FieldByName('Description').AsString+';';
         Writeln(fileCSV, s);
       end;}
       Main.CurrProgress( GetPercent(iPos, RecordCount) );
       Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
//<<<<<<<<<<<<<<<<<<<<

  // бренды --------------------------------------------------------------------
  Main.ShowProgress('Выгрузка брендов...');
  TestQuery.Close;
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select * from BRAND WHERE NEWITEM <> 0 OR DELITEM <> 0 ORDER BY Brand_id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'bra.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      if FieldByName('DELITEM').AsInteger = 0 then
      begin
        s := makeCsvRec([
          '0',
          FieldByName('Id').AsString,
          FieldByName('Brand_id').AsString,
          FieldByName('Description').AsString
        ]);
        Writeln(fileCSV, s);
      end
      else
      begin
        s := makeCsvRec(['1', FieldByName('Id').AsString]);
        Writeln(fileCSV, s);
      end;

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;

  // группы --------------------------------------------------------------------
  Main.ShowProgress('Выгрузка групп...');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select * from TREE WHERE NEWITEM <> 0 OR DELITEM <> 0 ORDER BY Id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'gru.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      if FieldByName('DELITEM').AsInteger = 0 then
      begin
        s := makeCsvRec([
          '0',
          FieldByName('Id').AsString,
          FieldByName('Group_id').AsString,
          FieldByName('Group_descr').AsString,
          FieldByName('Subgroup_id').AsString,
          FieldByName('Subgroup_descr').AsString
        ]);
        Writeln(fileCSV, s);
      end
      else
      begin
        s := makeCsvRec(['1', FieldByName('Id').AsString]);
        Writeln(fileCSV, s);
      end;

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;


  // группы (дерево) -----------------------------------------------------------
  Main.ShowProgress('Выгрузка групп...');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select * from TREEID WHERE NEWITEM <> 0 OR DELITEM <> 0 ORDER BY Id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'grb.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      if FieldByName('DELITEM').AsInteger = 0 then
      begin
        s := makeCsvRec([
          '0',
          FieldByName('Id').AsString,
          FieldByName('Group_id').AsString,
          FieldByName('Subgroup_id').AsString,
          FieldByName('Brand_id').AsString
        ]);
        Writeln(fileCSV, s);
      end
      else
      begin
        s := makeCsvRec(['1', FieldByName('Id').AsString]);
        Writeln(fileCSV, s);
      end;

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;

  // каталог 0 -----------------------------------------------------------------
  Main.ShowProgress('0 - Выгрузка каталога...');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select Cat_id from CATALOG WHERE DELITEM = 1 ORDER BY Cat_id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'cat_0.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      s := makeCsvRec(['0', FieldByName('Cat_id').AsString]);
      Writeln(fileCSV, s);

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;

  // каталог 1 -----------------------------------------------------------------
  Main.ShowProgress('1 - Выгрузка каталога...');
  TestQuery.SQL.Clear;
  // /* AND TITLE <> TRUE skip categories */
  TestQuery.SQL.Add('Select * from CATALOG WHERE NEWITEM = 1 ORDER BY Cat_id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'cat_1.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      s := makeCsvRec([
        '1',                                 // 0
        FieldByName('Cat_id').AsString,      // 1
        FieldByName('Brand_id').AsString,    // 2
        FieldByName('Group_id').AsString,    // 3
        FieldByName('Subgroup_id').AsString, // 4
        FieldByName('Code').AsString,        // 5
        FieldByName('Code2').AsString,       // 6
        FieldByName('Name').AsString,        // 7
        FieldByName('Description').AsString, // 8
        FieldByName('Price').AsString,       // 9
        FieldByName('T1').AsString,          // 10
        FieldByName('T2').AsString,          // 11
        FieldByName('Tecdoc_id').AsString,   // 12
        FieldByName('New').AsString,         // 13
        FieldByName('Sale').AsString,        // 14
        FieldByName('Mult').AsString,        // 15
        FieldByName('Usa').AsString,         // 16
        FieldByName('Title').AsString,       // 17

        //новые поля после реструктуризации
        FieldByName('pict_id').AsString,     // 18
        FieldByName('typ_tdid').AsString,    // 19
        FieldByName('param_tdid').AsString   // 20
      ]);
      Writeln(fileCSV, s);

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;

  // каталог 2 -----------------------------------------------------------------
  Main.ShowProgress('2 - Выгрузка каталога...');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select Cat_id, Price from CATALOG WHERE EDITPRICE = 1 ORDER BY Cat_id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'cat_2.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      s := makeCsvRec([
        '2',
        FieldByName('Cat_id').AsString,
        FieldByName('Price').AsString
      ]);
      Writeln(fileCSV, s);

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;


  // каталог 3 -----------------------------------------------------------------
  Main.ShowProgress('3 - Выгрузка каталога...');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select * from CATALOG WHERE EDITITEM = 1 ORDER BY Cat_id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'cat_3.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      s := makeCsvRec([
        '3',                                 // 0
        FieldByName('Cat_id').AsString,      // 1
        FieldByName('Brand_id').AsString,    // 2
        FieldByName('Group_id').AsString,    // 3
        FieldByName('Subgroup_id').AsString, // 4
        FieldByName('Code').AsString,        // 5
        FieldByName('Code2').AsString,       // 6
        FieldByName('Name').AsString,        // 7
        FieldByName('Description').AsString, // 8
        FieldByName('Price').AsString,       // 9
        FieldByName('T1').AsString,          // 10
        FieldByName('T2').AsString,          // 11
        FieldByName('Tecdoc_id').AsString,   // 12
        FieldByName('New').AsString,         // 13
        FieldByName('Sale').AsString,        // 14
        FieldByName('Mult').AsString,        // 15
        FieldByName('Usa').AsString,         // 16
        FieldByName('Title').AsString,       // 17

        //новые поля после реструктуризации
        FieldByName('pict_id').AsString,     // 18
        FieldByName('typ_tdid').AsString,    // 19
        FieldByName('param_tdid').AsString   // 20
      ]);
      Writeln(fileCSV, s);

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;

  // каталог 4 -----------------------------------------------------------------
  Main.ShowProgress('4 - Выгрузка каталога...');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select Cat_id, Group_id, Subgroup_id from CATALOG WHERE EDITGRITEM = 1 ORDER BY Cat_id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'cat_4.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      s := makeCsvRec([
        '4',
        FieldByName('Cat_id').AsString,
        FieldByName('Group_id').AsString,
        FieldByName('Subgroup_id').AsString
      ]);
      Writeln(fileCSV, s);

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;

  // каталог 5 -----------------------------------------------------------------
  Main.ShowProgress('5 - Выгрузка каталога...');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select Cat_id, Name, Description from CATALOG WHERE EDITNAME = 1 ORDER BY Cat_id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'cat_5.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      s := makeCsvRec([
        '5',
        FieldByName('Cat_id').AsString,
        FieldByName('Name').AsString,
        FieldByName('Description').AsString
      ]);
      Writeln(fileCSV, s);

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;

  // каталог 6 -----------------------------------------------------------------
  Main.ShowProgress('6 - Выгрузка каталога...');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select Cat_id, Tecdoc_id, pict_id, typ_tdid, param_tdid from CATALOG WHERE EDITTDLINKS = 1 ORDER BY Cat_id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'cat_6.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      s := makeCsvRec([
        '6',
        FieldByName('Cat_id').AsString,
        IntToStr(FieldByName('Tecdoc_id').AsInteger),  //can be NULL
        FieldByName('pict_id').AsString,
        FieldByName('typ_tdid').AsString,
        FieldByName('param_tdid').AsString
      ]);
      Writeln(fileCSV, s);

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;

  
  // аналоги (удаленные) -------------------------------------------------------
  Main.ShowProgress('Выгрузка удаляемых аналогов...');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select Id from ANALOGDEL WHERE DELITEM = 1 ORDER BY Id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'ana_0.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      s := makeCsvRec(['0', FieldByName('Id').AsString]);
      Writeln(fileCSV, s);

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;

  // аналоги (новые) -----------------------------------------------------------
  Main.ShowProgress('Выгрузка новых аналогов...');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select Id, Cat_id, An_code, An_brand, An_id, Locked from ANALOG WHERE NEWITEM = 1 ORDER BY Id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'ana_1.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      s := makeCsvRec([
        '1',
        FieldByName('Id').AsString,
        FieldByName('Cat_id').AsString,
        FieldByName('An_code').AsString,
        FieldByName('An_brand').AsString,
        FieldByName('An_id').AsString,
        FieldByName('Locked').AsString
      ]);  
      Writeln(fileCSV, s);

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;

  // аналоги (измененные) ------------------------------------------------------
  Main.ShowProgress('Выгрузка обновленных аналогов...');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select Id, Cat_id, An_code, An_brand, An_id, Locked from ANALOG WHERE EDITITEM = 1 ORDER BY Id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'ana_2.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    //нет цикла 
    while not TestQuery.Eof do
    begin
      s := makeCsvRec([
        '1',
        FieldByName('Id').AsString,
        FieldByName('Cat_id').AsString,
        FieldByName('An_code').AsString,
        FieldByName('An_brand').AsString,
        FieldByName('An_id').AsString,
        FieldByName('Locked').AsString
      ]);  
      Writeln(fileCSV, s);

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;

  // ОЕ (удаленные) ------------------------------------------------------------
  Main.ShowProgress('Выгрузка удаляемых ОЕ...');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select id from OE WHERE DELITEM = 1 ORDER BY Id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'oe_0.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      s := makeCsvRec(['0', FieldByName('Id').AsString]);
      Writeln(fileCSV, s);

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;

  // ОЕ (новые) ----------------------------------------------------------------
  Main.ShowProgress('Выгрузка новых ОЕ...');
  TestQuery.SQL.Clear;
  TestQuery.SQL.Add('Select Id, Cat_id, Code, Code2 from OE WHERE NEWITEM = 1 ORDER BY Id');
  TestQuery.ExecSQL;

  AssignFile(fileCSV, Update_Path + 'oe_1.csv');
  Rewrite(fileCSV);
  iPos := 0;
  with TestQuery do
  begin
    while not TestQuery.Eof do
    begin
      s := makeCsvRec([
        '1',
        FieldByName('Id').AsString,
        FieldByName('Cat_id').AsString,
        FieldByName('Code').AsString,
        FieldByName('Code2').AsString
      ]);  
      Writeln(fileCSV, s);

      Inc(iPos);
      Main.CurrProgress( GetPercent(iPos, RecordCount) );
      Next;
    end;
  end;
  TestQuery.Close;
  CloseFile(fileCSV);
  Main.HideProgress;

  // выгрузка версий  ----------------------------------------------------------
  AssignFile(fileCSV, Update_Path + '0');
  Rewrite(fileCSV);
  Writeln(fileCSV, VersionTable.FieldByName('DataVersion').AsString);
  Writeln(fileCSV, VersionTable.FieldByName('DiscretNumberVersion').AsString);
  CloseFile(fileCSV);

// выгрузка настроек  --------------------------------------------------------
{
  AllClose - не нужно, эксклюзивный доступ не требуется для экстпорта
  из хелпа DBISAM:
To export a table to a delimited text file, you must specify the DatabaseName and TableName properties of
the TDBISAMTable component and then call the ExportTable method.  When using a TDBISAMTable
component, the table can be open or closed when this method is called, and the table
does NOT NEED TO BE OPENED EXCLUSIVELY.
}
  ExportTable(SysParamTable, Update_path + 'sys.csv', 'Выгрузка настроек...', SYS_IMPEXP_FIELDS);

  // упаковка ------------------------------------------------------------------
  Main.ShowProgress('Упаковка...');
  with Zipper do
  begin
    RootDir := Update_path;
    ZipName := Update_path + 'data_d' + VersionTable.FieldByName('DataVersion').AsString + '.zip';
    Password := UPD_PWD + '-' + VersionTable.FieldByName('DataVersion').AsString;

    if FileExists(ZipName) then
      SysUtils.DeleteFile(ZipName);
      
    FilesList.Clear;
    FilesList.Add(Update_path + 'bra.csv');
    FilesList.Add(Update_path + 'gru.csv');
    FilesList.Add(Update_path + 'grb.csv');
    FilesList.Add(Update_path + 'cat_0.csv');
    FilesList.Add(Update_path + 'cat_1.csv');
    FilesList.Add(Update_path + 'cat_2.csv');
    FilesList.Add(Update_path + 'cat_3.csv');
    FilesList.Add(Update_path + 'cat_4.csv');
    FilesList.Add(Update_path + 'cat_5.csv');
    FilesList.Add(Update_path + 'cat_6.csv');
    FilesList.Add(Update_path + 'ana_0.csv');
    FilesList.Add(Update_path + 'oe_0.csv');
    FilesList.Add(Update_path + 'ana_1.csv');
    FilesList.Add(Update_path + 'ana_2.csv');
    FilesList.Add(Update_path + 'oe_1.csv');
    FilesList.Add(Update_path + 'sys.csv');
{kri}    FilesList.Add(Update_Path+ 'UpdateInfo.csv');
    FilesList.Add(Update_path + '0');
    StorePaths := False;
    Zip;
  end;
  Main.HideProgress;

  
  // формируем файл обновления (нужную часть) ----------------------------------
  anUpdUrl := SysParamTable.FieldByName('Update_url').AsString;
  if (anUpdUrl = '') then
    anUpdUrl := 'c:\update\'
  else
    if (anUpdUrl[Length(anUpdUrl)] <> '/') then
      anUpdUrl := anUpdUrl + '/';

            
  aDiscretUpdateSize := Zipper.ZipSize;
  with TIniFile.Create(Update_Path + cUpdateInfoFileName) do
  try
{    aVer := ReadString('file3', 'customversion', ''); //берем версию из версии данных
    if aVer = '' then
    begin
      DecodeDate(Date, y, m, d);
      aVer := StrZero(y - 2000, 2) + StrZero(m, 2) + StrZero(d, 2) + '.1';
    end;
}
    if not VersionTable.Active then
      VersionTable.Open;

    aVer := VersionTable.FieldByName('DataVersion').AsString;
    WriteString('file5', 'url', anUpdUrl + UPD_DATA_DISCRET + aVer + '.zip');
    WriteString('file5', 'descr', 'Данные(частичное обновление) [' + aVer + '] ' + GetFileSizeStr(aDiscretUpdateSize));
    WriteInteger('file5', 'filesize', aDiscretUpdateSize);
    WriteString('file5', 'targetdir', '{APP}\Импорт');
    WriteString('file5', 'customversion', aVer);
    WriteString('file5', 'localversion', 'data_d');
    WriteInteger('file5', 'descretversion', VersionTable.FieldByName('DiscretNumberVersion').AsInteger);
  finally
    Free;
  end;

  MessageDlg('Выгрузка завершена!', mtInformation, [mbOk], 0);
end;

//переносит возвраты поставщику из старых таблиц (56, 57) в новые (036, 037)
procedure TData.ConvertRetDocs;

  function MakeSearchCode_Local(s: string): string;
  const
    cIgn_chars = ' _';
  var
    i: Integer;
  begin
    for i := 1 to Length(cIgn_chars) do
      s := AnsiReplaceStr(s, cIgn_chars[i], '');
    Result := AnsiUpperCase(s);
  end;

  function CreateTable(const aTableName: string): TDBISamTable;
  begin
    Result := TDBISamTable.Create(nil);
    Result.DatabaseName := Database.DatabaseName;
    Result.TableName := aTableName;
  end;
  {
  function GetGoodsDescription(const aCode2, aBrand: string): string;
  begin
    Result := '';

    XBrandTable.Open;
    XCatTable.Open;
    if XBrandTable.Locate('Description', aBrand, [loCaseInsensitive]) and
       XCatTable.FindKey([aCode2, XBrandTable.FieldByName('Brand_id').AsInteger]) then
    begin
      Result := XCatTable.FieldByName('Name').AsString + ' ' + XCatTable.FieldByName('Description').AsString;
    end;
    XBrandTable.Close;
    XCatTable.Close;
  end;
  }
var
  i: Integer;
  aRet_old, aRetDet_old: TDBISamTable;
  aRet_new, aRetDet_new: TDBISamTable;
  aNumDoc: Integer;
begin
  if not FileExists(Data_Path + '56.1') then
    Exit;

  aRet_old := CreateTable('56');
  aRetDet_old := CreateTable('57');
  aRet_new := CreateTable('036');
  aRetDet_new := CreateTable('037');
  try

    aRet_old.Open;
    aRetDet_old.IndexName := 'RetDocPostID';
    aRetDet_old.Open;

    aRet_new.EmptyTable;
    aRetDet_new.EmptyTable;
    aRet_new.Open;
    aRetDet_new.Open;

    aNumDoc := 0;
    aRet_old.First;
    while not aRet_old.Eof do
    begin
      Inc(aNumDoc);
      aRet_new.Append;
      //RetDoc_ID - autoinc
      aRet_new.FieldByName('Data').Value := aRet_old.FieldByName('Data').Value;
      aRet_new.FieldByName('Note').AsString := aRet_old.FieldByName('Comments').AsString;
      if aRet_old.FieldByName('State').AsInteger = 1 then
        aRet_new.FieldByName('Post').AsInteger := 2
      else
        if aRet_old.FieldByName('State').AsInteger = 2 then
          aRet_new.FieldByName('Post').AsInteger := 1
        else
          aRet_new.FieldByName('Post').AsInteger := aRet_old.FieldByName('State').AsInteger;
      aRet_new.FieldByName('CLI_ID').AsString := '0000000000';
      aRet_new.FieldByName('Num').AsInteger := aNumDoc;
      aRet_new.FieldByName('Type').AsString := 'A';
      //Sent_time
      //Sign
      //TCP_Answer
      //DataPos
      aRet_new.Post;

      // details -----
      aRetDet_old.SetRange([aRet_old.FieldByName('RetDocPostID').AsInteger], [aRet_old.FieldByName('RetDocPostID').AsInteger]);
      aRetDet_old.First;
      while not aRetDet_old.Eof do
      begin
        aRetDet_new.Append;
        aRetDet_new.FieldByName('RetDoc_ID').AsInteger := aRet_new.FieldByName('RetDoc_ID').AsInteger;
        aRetDet_new.FieldByName('Brand').AsString := AnsiUpperCase(aRetDet_old.FieldByName('Brand').AsString);
        aRetDet_new.FieldByName('Code2').AsString := MakeSearchCode_Local(aRetDet_old.FieldByName('Code').AsString);
        aRetDet_new.FieldByName('Quantity').AsInteger := aRetDet_old.FieldByName('Col').AsInteger;
        aRetDet_new.FieldByName('Note').AsString := aRetDet_old.FieldByName('Comments').AsString;
        //Ordered
        aRetDet_new.Post;

        aRetDet_old.Next;
      end;

      aRet_old.Next;
    end;

    aRet_new.Close;
    aRetDet_new.Close;
    aRet_old.Close;
    aRetDet_old.Close;
    RenameTableDBI('56', '56_old');
    RenameTableDBI('57', '57_old');
  finally
    aRet_old.Free;
    aRetDet_old.Free;
    aRet_new.Free;
    aRetDet_new.Free;
  end;
end;

procedure TData.CopyMaketTable(tb1, tb2: TDBISAMTable);
var iField:integer;
begin
  tb1.Fields.Clear;
  tb1.FieldDefs := tb2.FieldDefs;
  tb1.IndexDefs := tb2.IndexDefs;
end;

procedure TData.LoadDescriptionBath;
var
  aRes: TStrings;
  i: Integer;
  anAddedCount: Integer;
begin
{$IFDEF ADMINMODE}
  aRes := TStringList.Create;
  try
    if TBatchSelectorForm.Execute(aRes, True {FilesMode}, 'Описания', '*.csv') then
    begin
      anAddedCount := 0;
      for i := 0 to aRes.Count - 1 do
        anAddedCount := anAddedCount + LoadDescription(aRes[i], True);
      MessageDlg('Загружено позиций: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
    end;
  finally
    aRes.Free;
  end;
{$ENDIF}  
end;

function TData.LoadDescription(sFileName: string = ''; aSilent: Boolean = False): Integer;
var f:TextFile;
    sRead:string;
    sCode, sBrand, sDescription:string;
    fStream: TFileStream;
    iFileSize,i,brand_id, iFilePos:integer;
begin
  Result := 0;

  if sFileName = '' then
    if Main.OpenDialogCSV.Execute then
    begin
      SetCurrentDir(Data.Data_Path);
      sFileName := Main.OpenDialogCSV.FileName;
    end
    else
      Exit;


 try
  DescriptionTable.Close;
  BrandTable.IndexName := 'Descr';
  with LoadCatTable do
    begin
     IndexName := 'Code2';
     Open;
    end;

   brand_id := 0; 
   fStream:=TFileStream.Create(sFileName, fmOpenRead);
   iFileSize := fStream.size;
   fStream.Free;
   iFilePos:=0;
   Main.ShowProgress('Загрузка описаний...');
   AssignFile(f,sFileName);
   Reset(f);
   xDescriptionTable.Open;
   while not System.Eof(f) do
   begin
      Readln(f,sRead);
      iFilePos:=iFilePos+1+Length(sRead);
      i:=iFileSize div 100;
      i:=iFilePos div i;
      Main.CurrProgress(i);

      DecodeCodeBrand(ExtractDelimited(1,  sRead, [';']), sCode, sBrand);
      sDescription     := ExtractDelimited(2,  sRead, [';']);

      with BrandTable do
        begin
          if FindKey([sBrand]) then
            brand_id := FieldByName('Brand_id').AsInteger
          else
            Continue;
        end;

    with xDescriptionTable do
    begin
       if UpperCase(sDescription) <> 'DELETE' then
        begin
          if (sCode <> '') and
             LoadCatTable.FindKey([sCode, brand_id]) then
          begin
              if not FindKey([LoadCatTable.FieldByName('Cat_id').AsInteger]) then
                Append
              else
                Edit;

             FieldByName('Cat_id').Value   := LoadCatTable.FieldByName('Cat_id').AsInteger;
             FieldByName('Description').Value := FieldByName('Description').AsString + sDescription+#13;
             Post;
             Inc(Result);
          end;
        end
        else
        begin
          if (sCode <> '') and
             LoadCatTable.FindKey([sCode, brand_id]) then
             begin
                if FindKey([LoadCatTable.FieldByName('Cat_id').AsInteger]) then
                  Delete;
             end;
        end;
    end;
   end;
   Close(f);
   xDescriptionTable.Close;
   LoadCatTable.Close;
   DescriptionTable.Open;
   Main.HideProgress;
 except
  on e:Exception do
   begin
     Close(f);
     LoadCatTable.Close;
     DescriptionTable.Open;
     Main.HideProgress;
     MessageDlg(e.Message,mtError,[mbOk],0);
     exit;
   end;
end;

  if not aSilent then
    MessageDlg('Загрузка завершена', mtInformation, [mbOk], 0);
end;

procedure TData.CloseInfo;
begin
  PrimenTable.Close;
  PrimenTable.EmptyTable;
  Main.DBAdvMemo.Visible := FALSE;
  Main.ParamGrid.Visible := TRUE;
  Main.ParamTypGrid.Visible := TRUE;
  Main.AdvSplitter5.Visible := TRUE;
  Main.CatalogPicture.Hide;

  Main.PrimGrid.DataSource := nil;
  Main.ParamTypGrid.DataSource := nil;
  Main.ParamGrid.DataSource := nil;
  Main.AnalogGrid.DataSource := nil;
end;

procedure TData.CloseAllFilters;
begin
   CloseInfo;
   if Auto_type > 0 then
   begin
     Auto_type := 0;
     sAuto := '';
     Main.AutoPanel.Hide;
   end;

   if sAuto <> '' then
     sAuto:= '';
end;

function  TData.CreateShortCode(Code: string; const aLiveSymbols: string = ''):string;
var sCode:string;
    sRes:string;
    i:integer;
begin
try
   sRes := '';
   sCode := AnsiUpperCase(Code);
   if Length(sCode) > 0 then
   for I := 0 to Length(sCode) do
   begin
      if ((sCode[i]<='Z')and(sCode[i]>='A'))
         or((sCode[i]<='Я')and(sCode[i]>='А'))
         or((sCode[i]<='9')and(sCode[i]>='0'))
         or(POS(sCode[i], aLiveSymbols) > 0) //не игнорировать эти символы
      then
      begin
        sRes := sRes + sCode[i];
      end;
   end;

   CreateShortCode := sRes;
    except
     On E:Exception do
      MessageDlg('CreateShortCode - '+Code+'-'+ E.Message, mtError, [mbOK],0);
  end;

end;

procedure TData.FieldsSaveToStream(tb1:TDBISAMTable; FieldsName:string; Memory:TMemoryStream);
     var DataCursor:TDataCursor;
      DestBuffer: PChar;
      DestBufferSize: Integer;
      TempRecordCount: Integer;
      TempRecordBuffer: PChar;
      CatTempRecordBuffer: PChar;
      TempFieldBuffer: array [0..MAX_EXPORT_SIZE] of Char;
      CatTableDataCursor:TDataCursor;
      FieldNum: Word;
      IsBlank: Boolean;
begin
   if tb1.Active then
    tb1.Close;

   //SetDBFlag(dbfTable,True);
   DataCursor:=TDataCursor.Create(Database.Handle,False);
   CatTableDataCursor:=TDataCursor.Create(Database.Handle,False);
   with DataCursor do
      begin
      TableName:=tb1.TableName;
      Exclusive:=FALSE;
      ReadOnly:=FALSE;
      if TRUE then
         OpenCursor(False);
      DestBuffer:=nil;
      DestBufferSize:=0;
      end;


      try
      with DataCursor do
         begin
         DestBuffer:=nil;
         DestBufferSize:=0;
         TempRecordBuffer:=AllocMem(DataCursor.RecordSize);
         CatTempRecordBuffer:=AllocMem(CatTableDataCursor.RecordSize);
         CatTableDataCursor.InitRecord(TempRecordBuffer);
         while DataCursor.GetNextRecord(TempRecordBuffer)=DBISAM_NONE do
         begin
            PutRecordNo(DataCursor.PhysicalRecordNumber,TempRecordBuffer);
            FieldNum := 1;
            IsBlank := FALSE;
            GetField(FieldNum,TempRecordBuffer,  @TempFieldBuffer,IsBlank);
            CatTableDataCursor.AppendRecord(CatTempRecordBuffer,FAlse);
         end;
         //SaveToStream(DestBuffer,DestBufferSize,STREAM_NORMAL,Assigned(FOnSaveToStreamProgress));
         //TempRecordBuffer:=AllocMem(RecordSize);




         {procedure TDataCursor.SaveToStream(var DestBuffer: PChar;
                                   var DestBufferSize: Integer;
                                   Mode: Byte;
                                   SendProgress: Boolean);
var
   CurDestBytes: Integer;
   TempSaveBuffer: PChar;
   CurSaveBytes: Integer;
   TempFieldBuffer: array [0..MAX_EXPORT_SIZE] of Char;
   TempPercentDone: Word;
   TempLastPercentDone: Word;
   TempRecordNumber: Integer;
   TempContinue: Boolean;
   TempRecordCount: Integer;
   TempRecordBuffer: PChar;
   IsBlank: Boolean;
   I: Integer;
   TempBlobSize: Integer;
   SaveIndexPos: Byte;
   SaveRangeInEffect: Boolean;

   procedure CheckSaveBufferSize(NewBytes: Integer);
   begin
      if ((CurSaveBytes+NewBytes) > SAVE_WRITE_SIZE) then
         begin
         ResizeBuffer((CurDestBytes+CurSaveBytes),DestBuffer,DestBufferSize);
         Move(TempSaveBuffer^,(DestBuffer+CurDestBytes)^,CurSaveBytes);
         Inc(CurDestBytes,CurSaveBytes);
         CurSaveBytes:=0;
         end;
   end;

   procedure MoveSaveBuffer;
   begin
      if (CurSaveBytes > 0) then
         begin
         ResizeBuffer((CurDestBytes+CurSaveBytes),DestBuffer,DestBufferSize);
         Move(TempSaveBuffer^,(DestBuffer+CurDestBytes)^,CurSaveBytes);
         Inc(CurDestBytes,CurSaveBytes);
         CurSaveBytes:=0;
         end;
   end;

   function GetNextStreamRecord: Boolean;
   begin
      Result:=False;
      if (Mode=STREAM_FROM_CACHE) then
         begin
         if (TempRecordNumber <= TempRecordCount) then
            begin
            SetCurrentRecord(TempRecordNumber);
            Move(CurrentRecordBuffer^,TempRecordBuffer^,FRecordSize);
            Result:=True;
            end;
         end
      else
         begin
         if (GetNextRecord(TempRecordBuffer)=DBISAM_NONE) then
            begin
            PutRecordNo(PhysicalRecordNumber,TempRecordBuffer);
            Result:=True;
            end;
         end;
   end;

begin
         TempRecordBuffer:=AllocMem(FRecordSize);
         TempSaveBuffer:=AllocMem(SAVE_WRITE_SIZE);
            try
               CurSaveBytes:=0;
               { Write out the signature
               CheckSaveBufferSize(SizeOf(TMD5Digest));
               pMD5Digest(TempSaveBuffer+CurSaveBytes)^:=DataEngine.SignatureDigest;
               Inc(CurSaveBytes,SizeOf(TMD5Digest));
               { Write out the engine version number
               CheckSaveBufferSize(SizeOf(Currency));
               pCurrency(TempSaveBuffer+CurSaveBytes)^:=ENGINE_VERSION_NUM;
               Inc(CurSaveBytes,SizeOf(Currency));
               { Write out the field definitions
               CheckSaveBufferSize(SizeOf(Word));
               pWord(TempSaveBuffer+CurSaveBytes)^:=FFieldCount;
               Inc(CurSaveBytes,SizeOf(Word));
               for I:=1 to FFieldCount do
                  begin
                  with FFieldDefinitions[I]^ do
                     begin
                     CheckSaveBufferSize(SizeOf(Byte));
                     Byte((TempSaveBuffer+CurSaveBytes)^):=DataType;
                     Inc(CurSaveBytes,SizeOf(Byte));
                     CheckSaveBufferSize(SizeOf(Word));
                     pWord(TempSaveBuffer+CurSaveBytes)^:=DataSize;
                     Inc(CurSaveBytes,SizeOf(Word));
                     CheckSaveBufferSize(SizeOf(Byte));
                     Byte((TempSaveBuffer+CurSaveBytes)^):=DataDecimals;
                     Inc(CurSaveBytes,SizeOf(Byte));
                     CheckSaveBufferSize(SizeOf(Byte));
                     (TempSaveBuffer+CurSaveBytes)^:=FieldName[0];
                     Inc(CurSaveBytes,SizeOf(Byte));
                     CheckSaveBufferSize(Byte(FieldName[0]));
                     Move(FieldName[1],(TempSaveBuffer+CurSaveBytes)^,Byte(FieldName[0]));
                     Inc(CurSaveBytes,Byte(FieldName[0]));
                     end;
                  end;
               TempLastPercentDone:=0;
               TempRecordNumber:=1;
               if (Mode=STREAM_FROM_CACHE) then
                  TempRecordCount:=PhysicalRecordsUsed
               else
                  begin
                  TempRecordCount:=RecordCount;
                  SetToBegin;
                  end;
               while GetNextStreamRecord do
                  begin
                  if (Mode <> STREAM_NORMAL) then
                     begin
                     if (Mode=STREAM_TO_CACHE) or
                        ((Mode=STREAM_FROM_CACHE) and
                         (GetRecordStatus(TempRecordBuffer) <> RECORD_VALID)) then
                        begin
                        CheckSaveBufferSize(SizeOf(Integer));
                        pInteger(TempSaveBuffer+CurSaveBytes)^:=GetRecordNo(TempRecordBuffer);
                        Inc(CurSaveBytes,SizeOf(Integer));
                        CheckSaveBufferSize(SizeOf(Integer));
                        pInteger(TempSaveBuffer+CurSaveBytes)^:=GetRecordID(TempRecordBuffer);
                        Inc(CurSaveBytes,SizeOf(Integer));
                        if (ENGINE_VERSION_NUM >= 4.18) then
                           begin
                           CheckSaveBufferSize(SizeOf(TMD5Digest));
                           pMD5Digest(TempSaveBuffer+CurSaveBytes)^:=GetRecordHash(TempRecordBuffer);
                           Inc(CurSaveBytes,SizeOf(TMD5Digest));
                           end;
                        CheckSaveBufferSize(SizeOf(Byte));
                        Byte((TempSaveBuffer+CurSaveBytes)^):=GetRecordStatus(TempRecordBuffer);
                        Inc(CurSaveBytes,SizeOf(Byte));
                        TempContinue:=True;
                        end
                     else
                        TempContinue:=False;
                     end
                  else
                     TempContinue:=True;
                  if TempContinue then
                     begin
                     for I:=1 to FFieldCount do
                        begin
                        IsBlank:=False;
                        with FFieldDefinitions[I]^ do
                           begin
                           GetField(FieldNum,TempRecordBuffer,
                                    @TempFieldBuffer,IsBlank);
                           CheckSaveBufferSize(SizeOf(Boolean));
                           Boolean((TempSaveBuffer+CurSaveBytes)^):=(not IsBlank);
                           Inc(CurSaveBytes,SizeOf(Boolean));
                           if (not IsBlank) then
                              begin
                              if (DataType <> TYPE_BLOB) then
                                 begin
                                 CheckSaveBufferSize(DataSize);
                                 Move(TempFieldBuffer,(TempSaveBuffer+CurSaveBytes)^,DataSize);
                                 Inc(CurSaveBytes,DataSize);
                                 end
                              else
                                 begin
                                 OpenBlob(FieldNum,TempRecordBuffer,BLOB_OPENREADONLY,False,True,
                                          TempBlobSize,False);
                                 try
                                    CheckSaveBufferSize(SizeOf(Integer));
                                    pInteger(TempSaveBuffer+CurSaveBytes)^:=TempBlobSize;
                                    Inc(CurSaveBytes,SizeOf(Integer));
                                    MoveSaveBuffer;
                                    { Just put the BLOB data directly into the destination buffer
                                    ResizeBuffer((CurDestBytes+TempBlobSize),DestBuffer,DestBufferSize);
                                    GetBlob(FieldNum,TempRecordBuffer,0,(DestBuffer+CurDestBytes),
                                            TempBlobSize,TempBlobSize,False);
                                    Inc(CurDestBytes,TempBlobSize);
                                 finally
                                    FreeBlob(FieldNum,TempRecordBuffer,False,True);
                                 end;
                                 end;
                              end;
                           end;
                        end;
                     end;
                  TempPercentDone:=Trunc(((TempRecordNumber/TempRecordCount)*100));
                  if (TempPercentDone >= (TempLastPercentDone+ProgressPercent)) then
                     begin
                     DoProgress(TempPercentDone);
                     TempLastPercentDone:=TempPercentDone;
                     end;
                  Inc(TempRecordNumber);
                  end;
               MoveSaveBuffer;
               if (TempLastPercentDone <> 100) then
                  DoProgress(100);
            finally
               DeAllocMem(TempSaveBuffer);
            end;
         finally
            DeAllocMem(TempRecordBuffer);
         end;
      finally
         if (Mode=STREAM_FROM_CACHE) then
            begin
            InternalSetIndexPos(SaveIndexPos);
            FRangeInEffect:=SaveRangeInEffect;
            CheckForActiveFilters;
            end;
      end;
      end;
end;}





         try
            with Memory do
               begin
               Size:=0;
               Position:=0;
               WriteBuffer(DestBuffer^,DestBufferSize);
               end;
         finally
             if (Pointer(DestBuffer) <> nil) then
               begin
                FreeMem(Pointer(DestBuffer));
                Pointer(DestBuffer):=nil;
              end;
      //DeAllocMem(DestBuffer);
         end;
         end;
   finally
       DataCursor.CloseCursor(True);
       DataCursor.Free;
      //FreeTempCursor(DataCursor);
   end;

   //SetDBFlag(dbfTable,False);



 {  with DataCursor do
      begin
      TableName:=tb1.TableName;
      Exclusive:=FALSE;
      ReadOnly:=FALSE;
      if TRUE then
         OpenCursor(False);
      DestBuffer:=nil;
      DestBufferSize:=0;
      end;}

end;

procedure TData.MakeFullPrimen(const aDestFile: string) ;
var
  aQuery: TAdoQuery;
  f: file of Integer;
  aType, aArt: Integer;
  i, iMax: Integer;
  aFirst: Boolean;
  aSavedIndexName: string;
begin
  ArtTypTable.DisableControls;
  try
    Main.ShowProgress('Выгрузка применяемости...');
    AssignFile(f, aDestFile);
    Rewrite(f);
    i := 0;
    ArtTypTable.IndexName := 'Typ';
    ArtTypTable.first;
    aType := ArtTypTableTyp_id.AsInteger;
    aFirst := True;

  finally
    CloseFile(f);
    ArtTypTable.IndexName := 'art';
    ArtTypTable.EnableControls;
    Main.HideProgress;
  end;
end;

function TData.MakeProxyUrl(url, proxyuser, proxypwd: string): string;
begin
  Result := url;

  if (Pos('HTTP://', Uppercase(url)) = 1) and (Data.ParamTable.FieldByName('UseProxy').AsBoolean) then
  begin
    Delete(url, 1, 7);
    Result := 'http://' + Data.ParamTable.FieldByName('ProxyUser').AsString + ':' + Data.ParamTable.FieldByName('ProxyPassword').AsString + '@' + url;
  end;
end;

function TData.BuildUpdateUrl(aUrl: string; aBuildWithProxy: Boolean; IsExtUpdate: Boolean): string;
begin
  Result := aUrl;
  if (Result <> '') and (Right(Result, 1) <> '/') then
    Result := Result + '/';
  if Result <> '' then
  begin
    if IsExtUpdate then
      Result := Result + cUpdateInfoExtFileName
    else
      Result := Result + cUpdateInfoFileName;
    if aBuildWithProxy and ParamTable.FieldByName('UseProxy').AsBoolean then
      Result := MakeProxyUrl(Result, ParamTable.FieldByName('ProxyUser').AsString, ParamTable.FieldByName('ProxyPassword').AsString);
  end;
end;

{
function TData.GetUpdateUrl(aBuildWithProxy: Boolean; IsExtUpdate: Boolean): string;
begin
  Result := BuildUpdateUrl(SysParamTable.FieldByName('Update_url').AsString, aBuildWithProxy, IsExtUpdate);
end;
}
(*1
function TData.GetUpdateUrlStock(aBuildWithProxy: Boolean; aGetPathOnly: Boolean): string;
var
  s: string;
begin
  s := SysParamTable.FieldByName('Update_url').AsString;
  if (s <> '') and (Right(s, 1) <> '/') then
    s := s + '/';

  Result := s + 'test/markets/';
  if aGetPathOnly then
    Exit;
  Result := BuildUpdateUrl(Result, aBuildWithProxy, False {IsExtUpdate});
end;
*)

function TData.GetUpdateUrlDestFile: string;
begin
  Result := IncludeTrailingPathDelimiter(Import_Path) + cUpdateInfoFileName;
end;

function TData.ExecuteSimpleSelect(const aSQL: string; const aParams: array of Variant): string;
var
  aQuery: TDBISAMQuery;
  i: Integer;
begin
  aQuery := TDBISAMQuery.Create(nil);
  try
    aQuery.DatabaseName := Database.DatabaseName;
    aQuery.SQL.Text := aSQL;

    for i := Low(aParams) to High(aParams) do
      aQuery.Params[i].Value := aParams[i];

    aQuery.Open;
    if not aQuery.Eof then
      Result := aQuery.Fields[0].AsString
    else
      Result := '';
  finally
    aQuery.Free;
  end;
end;

procedure TData.ExecuteQuery(const aSQL: string);
var
  aQuery: TDBISAMQuery;
begin
  aQuery := TDBISAMQuery.Create(nil);
  try
    aQuery.DatabaseName := Database.DatabaseName;
    aQuery.SQL.Text := aSQL;
    aQuery.ExecSQL;
  finally
    aQuery.Free;
  end;
end;

//исправления ошибок в логике БД - запускается сразу после DataTest
procedure TData.RunDatabaseFixes;
var
  NomCount, CatCount: Integer;
begin
  SetCurrentDir(Data_Path);

{
  //исправление пустых ShortCode
  if ExecuteSimpleSelect('select Count(CAT_ID) from [002] where code IS NOT NULL AND SHORTCODE IS NULL', []) <> '0' then
  begin
    CatalogTable.Open;
    try
      CatalogTable.First;
      while not CatalogTable.Eof do
      begin
        if CatalogTable.FieldByName('ShortCode').IsNull and
           not CatalogTable.FieldByName('Code').IsNull then
        begin
          CatalogTable.Edit;
          CatalogTable.FieldByName('ShortCode').AsString := CreateShortCode(CatalogTable.FieldByName('Code').AsString);
          CatalogTable.Post;
        end;

        CatalogTable.Next;
      end;
    finally
      CatalogTable.Close;
    end;
  end;
}

{
  //исправление NomList (после частичного обновления он не перестраивался)
  if NomList.Exists then
  begin
//    NomCount := StrToIntDef(ExecuteSimpleSelect('select Count(*) from [002_]'), 0);
//    CatCount := StrToIntDef(ExecuteSimpleSelect('select Count(*) from [002]'), 0) -
//                StrToIntDef(ExecuteSimpleSelect('select Count(*) from [002] WHERE Code2 = '''' '), 0);
//    if CatCount <> NomCount then
//      RecreateNomList(True );

    NomCount := StrToIntDef(ExecuteSimpleSelect(' select MIN(CAT_ID) from [002] where code2 = '''' '), 0);
    NomCount := StrToIntDef(ExecuteSimpleSelect(' select MAX(CAT_ID) from [002] where CAT_ID < ' + IntToStr(NomCount)), 0);
    CatCount := StrToIntDef(ExecuteSimpleSelect(' select CAT_ID from [002_] where CAT_ID = ' + IntToStr(NomCount)), 0);
    if CatCount = 0 then
      RecreateNomList(True );

  end; //иначе создастся в DataTest;
}

{
  //исправление пустых ShortOE
  if ExecuteSimpleSelect(' select Count(*) from [016] where SHORTOE IS NULL AND CODE2 IS NOT NULL ', []) <> '0' then
  begin
    OETable.IndexName := '';
    OETable.MasterFields := '';
    OETable.MasterSource := Nil;
    OETable.Open;
    try
      OETable.First;
      while not OETable.Eof do
      begin
        if OETable.FieldByName('ShortOE').IsNull then
        begin
          OETable.Edit;
          OETable.FieldByName('ShortOE').AsString := CreateShortCode(OETable.FieldByName('Code').AsString);
          if OETable.FieldByName('ShortOE').AsString = '' then
            OETable.FieldByName('ShortOE').AsString := '?';
          OETable.Post;
        end;

        OETable.Next;
      end;
    finally
      OETable.Close;
      OETable.IndexName := 'Cat_id';
      OETable.MasterFields := 'Cat_id';
      OETable.MasterSource := CatalogDataSource;
    end;
  end;
}
  //переиндексация OE - заливка первой буквы Code - убрать после того как ServiceFill будет это лить
  if ExecuteSimpleSelect(' select Count(*) from [016] where SIMB IS NULL ', []) <> '0' then
  begin
    OETable.IndexName := '';
    OETable.MasterFields := '';
    OETable.MasterSource := nil;
    OETable.Open;
    try
      OETable.First;
      while not OETable.Eof do
      begin
        if OETable.FieldByName('SIMB').IsNull then
        begin
          OETable.Edit;
          if OETable.FieldByName('ShortOE').AsString <> '' then
            OETable.FieldByName('SIMB').AsInteger := Ord( OETable.FieldByName('ShortOE').AsString[1] )
          else
            OETable.FieldByName('SIMB').AsInteger := Ord('?');
          OETable.Post;
        end;
        
        OETable.Next;
      end;
    finally
      OETable.Close;
      OETable.IndexName := 'Cat_id';
      OETable.MasterFields := 'Cat_id';
      OETable.MasterSource := CatalogDataSource;
    end;
  end;
end;

function TData.CanViewDiscretUpdate(aDataVersion: string): Boolean;
var
  y, m, d: Word;
begin
  y := 2000 + StrToIntDef( Copy(aDataVersion, 1, 2) , 0);
  m := StrToIntDef( Copy(aDataVersion, 3, 2) , 0);
  d := StrToIntDef( Copy(aDataVersion, 5, 2) , 0);

  //версия начиная с 110725.1 может видеть частичное обновление
  Result := EncodeDate(y, m, d) >= EncodeDate(2011, 7, 25);
end;

(*
procedure TData.RecreateNomList(aForce: Boolean);
begin
  if NomList.Active then
    NomList.Close;

  if not aForce then
    if NomList.Exists then
    begin
      NomList.Open;
      aForce := NomList.RecordCount = 0;
      NomList.Close;
    end;

  if aForce then
    RemoveTableFromBase(NomList.TableName);


  if not NomList.Exists then
  begin
    // * ExecuteQuery('SELECT [002].Cat_id,[002].Code2,[003].Description as sBrand INTO [002_] FROM [002] join [003] on [003].Brand_id = [002].Brand_id WHERE [002].Code2 <> '''' ORDER BY [002].Code2,sBrand');
    //этот запрос сносит индексы и идет заново переиндексация,
    //поэтому сначала создаем пустую таблицу со всеми индексами (TestTable),
    //а потом заливаем INSERT'ом
    TestTable(NomList, data_psw);
    ExecuteQuery(
      ' INSERT INTO [002_] ' +
      '   SELECT [002].Cat_id,[002].Code2, [003].Description as sBrand ' +
      '   FROM [002] join [003] on [003].Brand_id = [002].Brand_id ' +
      '   WHERE [002].Code2 <> '''' ORDER BY [002].Code2, sBrand '
    );
  end;
end;
*)

procedure TData.ExportPrice;
begin
  if PriceList.Active then
    PriceList.Close;

  if PriceList.Exists then
    PriceList.EmptyTable
  else
    PriceList.CreateTable;

  ExecuteQuery(
    ' INSERT INTO MEMORY\price ' +
    '   SELECT [002].Cat_id, [002].Code2, [003].Description as sBrand, [002].Name as sName, [002].Description as sDescr' +
    '   FROM [002] join [003] on [003].Brand_id = [002].Brand_id ' +
    '   WHERE [002].Code2 <> '''' and [003].Description <> ''CROSS'' ORDER BY [002].Code2, sBrand '
  );

  ExportTable(PriceList, GetAppDir + 'Экспорт\price.csv', 'Экспорт прайса', 'Code2;sBrand;sName;sDescr');
end;

procedure TData.memAnalogAfterScroll(DataSet: TDataSet);
begin
  //AnalogTable.Locate('ID', memAnalog.FieldByName('ID').AsInteger, []);

  Main.ShowStatusBarInfo2;
  Main.UpdateAllQuantsInfo(False, True);  
end;

procedure TData.SaveCurrencyRounding(const aRounding: TCurrencyRounding; aPostData: Boolean);
var
  i: TCurrencyType;
  s: string;
begin
  s := '';
  for i := Low(TCurrencyType) to High(TCurrencyType) do
  begin
    if s = '' then
      s := Format('%d;%d;%d', [Ord(i), aRounding[i].RoundPower, Ord(aRounding[i].RoundMode)])
    else
      s := s + #13#10 + Format('%d;%d;%d', [Ord(i), aRounding[i].RoundPower, Ord(aRounding[i].RoundMode)]);
  end;

  ParamTable.Edit;
  ParamTable.FieldByname('Rounding').AsString := s;
  if aPostData then
    ParamTable.Post;
end;

procedure TData.LoadCurrencyRounding(var aRounding: TCurrencyRounding);
var
  i, p: Integer;
  s: string;
  sl: TStrings;
  aCurrency: TCurrencyType;
begin
  if ParamTable.FieldByname('Rounding').AsString = '' then
  begin
    with aRounding[ctEUR] do
    begin
      RoundMode := rmNearest;
      RoundPower := 2; //до 0.01
    end;
    with aRounding[ctUSD] do
    begin
      RoundMode := rmNearest;
      RoundPower := 2; //до 0.01
    end;
    with aRounding[ctBYR] do
    begin
      RoundMode := rmNearest;
      RoundPower := -2; //до 100
    end;
    with aRounding[ctRUB] do
    begin
      RoundMode := rmNearest;
      RoundPower := 2; //до 0.01
    end;

    Exit;
  end;

  sl := TStringList.Create;
  try
    sl.Text := ParamTable.FieldByname('Rounding').AsString;
    for i := 0 to sl.Count - 1 do
    begin
      s := sl[i];
      p := POS(';', s);
      if p > 0 then
      begin
        aCurrency := TCurrencyType(StrToIntDef(Copy(s, 1, p - 1), 0));
        Delete(s, 1, p);

        p := POS(';', s);
        if p > 0 then
        begin
          aRounding[aCurrency].RoundPower := StrToIntDef(Copy(s, 1, p - 1), 0);
          Delete(s, 1, p);

          aRounding[aCurrency].RoundMode := TFPURoundingMode(StrToIntDef(s, 0));
        end;
      end;
    end;
  finally
    sl.Free;
  end;
end;

procedure TData.CreateQuantsLookup;

  procedure AddQuantsField(aSource: TDBISamTable; const aNumQuant: string);
  begin
    aSource.Filter := 'Quantity <>'''' ';
    aSource.Filtered := True;
    aSource.First;
    while not aSource.Eof do
    begin
      if not QuantTableJoin.FindKey([aSource.FieldByName('CAT_ID').AsInteger]) then
      begin
        QuantTableJoin.Append;
        QuantTableJoin.FieldByName('CAT_ID').AsInteger := aSource.FieldByName('CAT_ID').AsInteger;
      end
      else
{        if aSource.FieldByName('Quantity').AsString <> '' then
        begin}
        QuantTableJoin.Edit;

      QuantTableJoin.FieldByName('Q' + aNumQuant).Value := aSource.FieldByName('Quantity').Value;
      QuantTableJoin.Post;
//        end;
      aSource.Next;
    end;
    aSource.Filtered := False;
  end;
  

var
  i: Integer;
  aStockQuantTable: TDBISamTable;
begin
  QuantTableJoin.DisableControls;
  try
    QuantTableJoin.Close;
    if not QuantTableJoin.Exists then
    begin
      QuantTableJoin.CreateTable;
      QuantTableJoin.AddIndex('', 'CAT_ID', [ixPrimary, ixUnique]);
    end
    else
      QuantTableJoin.EmptyTable;

    QuantTableJoin.IndexName := '';
    QuantTableJoin.Open;

    for i := 2 to cQuantBasesCount do
    begin
      aStockQuantTable := TDBISamTable(Self.FindComponent('QuantTable' + IntToStr(i)));
      AddQuantsField(aStockQuantTable, IntToStr(i));
    end;

  finally
    QuantTableJoin.Open;
    QuantTableJoin.EnableControls;
  end;

end;


end.

//CROSS
//08-303-020
