unit ERP.Admin.Module.UI.AdminModuleAccess;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxCheckBox, Data.DB, Vcl.ActnList, dxBar,
  cxClasses, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridCustomView, cxGrid,
  cxNavigator, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Actions, ShateM.Utils.MSSQL, ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;

type
  TfrmAdminModuleAccess = class(TForm)
    cxGrid: TcxGrid;
    tblModules: TcxGridTableView;
    cxGridLevel: TcxGridLevel;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    dxBarLargeButton4: TdxBarLargeButton;
    ActionList: TActionList;
    acRefresh: TAction;
    colName: TcxGridColumn;
    colBit: TcxGridColumn;
    qrQuery: TFDQuery;
    ttModuleAccess: TsmFireDACTempTable;
    procedure FormShow(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
  private
    FFDConnection: TFDConnection;
    FId_Module: Integer;
    FFileName: string;
    procedure RefreshData;
    procedure UpdateData;
  public
    constructor Create(aId_Module: Integer; aFileName: string; aConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.ClientClasses.TPackageModuleScan,
  ERP.Package.ClientInterface.IModuleAccess,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_ADM_MDL_SEL_MODULEACCESS = 'adm_mdl_sel_moduleaccess :Id_Module';

  PROC_ADM_MDL_UPD_MODULEACCESS = 'adm_mdl_upd_moduleaccess :Id_Module';

  PARAM_ID_MODULE = 'Id_Module';

  FLD_NAME = 'Name';
  FLD_BIT = 'Bit';

  COL_NAME = 0;
  COL_BIT = 1;

{ TfrmModuleAccess }

procedure TfrmAdminModuleAccess.acRefreshExecute(Sender: TObject);
begin
  UpdateData();
end;

constructor TfrmAdminModuleAccess.Create(aId_Module: Integer; aFileName: string; aConnection: TFDConnection; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FFDConnection := aConnection;
  FId_Module := aId_Module;
  FFileName := aFileName;
  acRefresh.ImageIndex := IL_REFRESH;
  dxBarManager.ImageOptions.LargeImages := GDDM.ilGlobal32;
  qrQuery.Connection := aConnection;
  ttModuleAccess.Connection := aConnection;
end;

procedure TfrmAdminModuleAccess.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAdminModuleAccess.RefreshData;
var
  k: Integer;
begin
  CreateSQLCursor();
  qrQuery.SQL.Text := PROC_ADM_MDL_SEL_MODULEACCESS;
  qrQuery.Params.ParamValues[PARAM_ID_MODULE] := FId_Module;
  try
    qrQuery.Open();
    tblModules.BeginUpdate();
    try
      tblModules.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to tblModules.DataController.RecordCount - 1 do
      begin
        tblModules.DataController.Values[k, COL_NAME] := qrQuery.FieldByName(FLD_NAME).AsString;
        tblModules.DataController.Values[k, COL_BIT] := qrQuery.FieldByName(FLD_BIT).AsInteger;
        qrQuery.Next();
      end;
    finally
      tblModules.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminModuleAccess.UpdateData;
var
  PackageModuleItem: TPackageModuleItem;
  ModuleAccess: IModuleAccess;
  k: Integer;
begin
  PackageModuleItem := TPackageModuleItem.Create();
  try
    PackageModuleItem.FileName := ExtractFilePath(Application.ExeName) + FFileName;
    PackageModuleItem.Open;
    ModuleAccess := PackageModuleItem.GetRegisterAccess();
    ttModuleAccess.CreateTempTable();
    try
      for k := 0 to ModuleAccess.Count - 1 do
        ttModuleAccess.InsertTempTable([TFieldValue.Create('Name', string(ModuleAccess.Items[ModuleAccess.Bit[k]]^.Caption)),
                                        TFieldValue.Create('Bit', ModuleAccess.Bit[k])]);
      TERPQueryHelp.Open(FFDConnection, PROC_ADM_MDL_UPD_MODULEACCESS, [TERPParamValue.Create(FId_Module)]);
    finally
      ttModuleAccess.DropTempTable();
    end;
  finally
    ModuleAccess := nil;
    PackageModuleItem.Close();
    PackageModuleItem.Free();
  end;
  RefreshData();
end;

end.
