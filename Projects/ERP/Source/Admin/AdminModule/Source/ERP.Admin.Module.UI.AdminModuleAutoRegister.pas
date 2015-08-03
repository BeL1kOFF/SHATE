unit ERP.Admin.Module.UI.AdminModuleAutoRegister;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridLevel, cxGrid, Vcl.ActnList, dxBar, Data.DB, dxStatusBar, cxContainer, cxProgressBar,
  cxTextEdit, cxMemo, cxNavigator, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.Actions, ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;

type
  TfrmAdminModuleAutoRegister = class(TForm)
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    ActionList: TActionList;
    acScan: TAction;
    acRegister: TAction;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    tblModules: TcxGridTableView;
    colId_TemplateDataBase: TcxGridColumn;
    colTemplateDataBaseName: TcxGridColumn;
    colModuleName: TcxGridColumn;
    colGUID: TcxGridColumn;
    colFileName: TcxGridColumn;
    dxStatusBar1: TdxStatusBar;
    dxStatusBar1Container0: TdxStatusBarContainerControl;
    pbScan: TcxProgressBar;
    mLog: TcxMemo;
    qrQuery: TFDQuery;
    ttModuleAccess: TsmFireDACTempTable;
    procedure acScanExecute(Sender: TObject);
    procedure acRegisterUpdate(Sender: TObject);
    procedure acRegisterExecute(Sender: TObject);
  private
    FFDConnection: TFDConnection;
    procedure OnPackageScanOnScanEvent(aIndex, aCount: Integer; const aFileName: string);
    procedure Scan;
  public
    constructor Create(aConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomClasses.Consts,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.ClientClasses.TPackageModuleScan,
  ERP.Package.ClientClasses.ERPOptions,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_ADM_MDL_UPD_AUTOREGISTER = 'adm_mdl_upd_autoregister :TypeModuleGUID, :Id_TemplateDataBase, :Name, :Guid, :FileName';
  PROC_ADM_MDL_SEL_ISREGISTERMODULE = 'adm_mdl_sel_isregistermodule :Guid';
  PROC_ADM_MDL_SEL_TEMPLATEDB = 'adm_mdl_sel_templatedb :TypeDB';

  PARAM_AR_TYPEMODULEGUID = 'TypeModuleGUID';
  PARAM_AR_ID_TEMPLATEDATABASE = 'Id_TemplateDataBase';
  PARAM_AR_NAME = 'Name';
  PARAM_AR_GUID = 'Guid';
  PARAM_AR_FILENAME = 'FileName';

  PARAM_IRM_GUID = 'Guid';

  PARAM_TDB_TYPEDB = 'TypeDB';

  FLD_IRM_RESULT = 'Result';

  FLD_TDB_ID_TEMPLATEDATABASE = 'Id_TemplateDataBase';
  FLD_TDB_NAME = 'Name';

  COL_ID_TEMPLATEDATABASE = 0;
  COL_TEMPLATEDATABASENAME = 1;
  COL_MODULENAME = 2;
  COL_MODULEGUID = 3;
  COL_MODULEFILENAME = 4;

  SEARCH_MASK = '*.bpl'#13#10'*.dll';

resourcestring
  RsAutoRegisterError = 'Îøèáêà: %s (%s); %s';
  RsAutoRegisterSuccess = '%s (%s); %s';

function GetOptions: IXMLOptionsType;
begin
  Result := LoadOptions(ExtractFilePath(Application.ExeName) + 'ERP.xml');
end;

{ TfrmAdminModuleAutoRegister }

procedure TfrmAdminModuleAutoRegister.acRegisterExecute(Sender: TObject);
var
  k, i: Integer;
  PackageModuleItem: TPackageModuleItem;
  ResultText: string;
  ResultType: Integer;
  FDMemTable: TFDMemTable;
begin
  CreateSQLCursor();
  ResultType := -1;
  for k := 0 to tblModules.Controller.SelectedRecordCount - 1 do
  begin
    ttModuleAccess.CreateTempTable();
    try
      PackageModuleItem := TPackageModuleItem.Create();
      try
        PackageModuleItem.FileName := tblModules.Controller.SelectedRecords[k].Values[COL_MODULEFILENAME];
        PackageModuleItem.Open();
        for i := 0 to PackageModuleItem.GetRegisterAccess.Count - 1 do
          ttModuleAccess.InsertTempTable([TFieldValue.Create('Name', string(PackageModuleItem.GetRegisterAccess.Items[PackageModuleItem.GetRegisterAccess.Bit[i]]^.Caption)),
                                          TFieldValue.Create('Bit', PackageModuleItem.GetRegisterAccess.Bit[i])]);
        qrQuery.SQL.Text := PROC_ADM_MDL_UPD_AUTOREGISTER;
        qrQuery.Params.ParamValues[PARAM_AR_TYPEMODULEGUID] := GUIDToString(PackageModuleItem.GetModuleInfo.TypeGuid);
        qrQuery.Params.ParamValues[PARAM_AR_ID_TEMPLATEDATABASE] := tblModules.Controller.SelectedRecords[k].Values[COL_ID_TEMPLATEDATABASE];
        qrQuery.Params.ParamValues[PARAM_AR_NAME] := string(PackageModuleItem.GetModuleInfo.Name);
        qrQuery.Params.ParamValues[PARAM_AR_GUID] := GUIDToString(PackageModuleItem.GetModuleInfo.GUID);
        qrQuery.Params.ParamValues[PARAM_AR_FILENAME] := ExtractFileName(PackageModuleItem.FileName);
        try
          qrQuery.Open();
          FDMemTable := TFDMemTable.Create(nil);
          try
            while qrQuery.Active do
            begin
              FDMemTable.Close();
              FDMemTable.Data := qrQuery.Data;
              qrQuery.NextRecordSet();
            end;
            ResultType := FDMemTable.Fields.Fields[0].AsInteger;
            ResultText := FDMemTable.Fields.Fields[1].AsString;
          finally
            FDMemTable.Free();
          end;
        except on E: Exception do
        begin
          ResultType := -1;
          ResultText := E.Message;
        end;
        end;
        qrQuery.Close();
        case ResultType of
          -1:
            mLog.Lines.Add(Format(RsAutoRegisterError, [GUIDToString(PackageModuleItem.GetModuleInfo.GUID),
              string(PackageModuleItem.GetModuleInfo.Name), ResultText]));
          1:
            mLog.Lines.Add(Format(RsAutoRegisterSuccess, [GUIDToString(PackageModuleItem.GetModuleInfo.GUID),
              string(PackageModuleItem.GetModuleInfo.Name), ResultText]));
        end;
        mLog.Update();
      finally
        PackageModuleItem.Close();
        PackageModuleItem.Free();
      end;
    finally
      ttModuleAccess.DropTempTable();
    end;
  end;
  Scan();
end;

procedure TfrmAdminModuleAutoRegister.acRegisterUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblModules.Controller.SelectedRecordCount > 0;
end;

procedure TfrmAdminModuleAutoRegister.acScanExecute(Sender: TObject);
begin
  Scan();
end;

constructor TfrmAdminModuleAutoRegister.Create(aConnection: TFDConnection; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FFDConnection := aConnection;
  acScan.ImageIndex := IL_FIND;
  acRegister.ImageIndex := IL_AUTOREGISTER;
  dxBarManager.ImageOptions.LargeImages := GDDM.ilGlobal32;
  qrQuery.Connection := aConnection;
  ttModuleAccess.Connection := aConnection;
  mLog.Lines.Clear();
end;

procedure TfrmAdminModuleAutoRegister.OnPackageScanOnScanEvent(aIndex, aCount: Integer; const aFileName: string);
begin
  pbScan.Position := aIndex * 100 / aCount;
  pbScan.Properties.Text := FloatToStr(pbScan.Position) + '%  ' + ExtractFileName(aFileName);
  pbScan.Update();
end;

procedure TfrmAdminModuleAutoRegister.Scan;
var
  PackageModuleScan: TPackageModuleScan;
  k: Integer;
  tmpString: string;
  Index: Integer;

  function CheckRegister(const aGuid: TGUID): Boolean;
  begin
    qrQuery.SQL.Text := PROC_ADM_MDL_SEL_ISREGISTERMODULE;
    qrQuery.Params.ParamValues[PARAM_IRM_GUID] := GUIDToString(aGuid);
    try
      Result := False;
      qrQuery.Open;
      Result := qrQuery.FieldByName(FLD_IRM_RESULT).AsBoolean;
    finally
      qrQuery.Close;
    end;
  end;

begin
  CreateSQLCursor();
  pbScan.Properties.Min := 0;
  pbScan.Properties.Max := 100;
  PackageModuleScan := TPackageModuleScan.Create();
  try
    PackageModuleScan.OnPackageScanOnScanEvent := OnPackageScanOnScanEvent;
    tmpString := '';
    for k := 0 to GetOptions().Packages.Count - 1 do
      tmpString := tmpString + ExtractFilePath(Application.ExeName) + GetOptions().Packages.Path[k] + #13#10;
    Delete(tmpString, Length(tmpString) - 1, 2);
    PackageModuleScan.MultiPath := tmpString;
    PackageModuleScan.MultiMask := SEARCH_MASK;
    PackageModuleScan.Clear();
    PackageModuleScan.MultiScan(False);
    tblModules.BeginUpdate();
    try
      tblModules.DataController.RecordCount := 0;
      for k := 0 to PackageModuleScan.Count - 1 do
      begin
        if not CheckRegister((PackageModuleScan.Items[k] as TPackageModuleItem).GetModuleInfo.GUID) then
        begin
          qrQuery.SQL.Text := PROC_ADM_MDL_SEL_TEMPLATEDB;
          qrQuery.Params.ParamValues[PARAM_TDB_TYPEDB] := (PackageModuleScan.Items[k] as TPackageModuleItem).GetModuleInfo.TypeDB;
          try
            qrQuery.Open();
            tblModules.DataController.RecordCount := tblModules.DataController.RecordCount + 1;
            Index := tblModules.DataController.RecordCount - 1;
            tblModules.DataController.Values[Index, COL_ID_TEMPLATEDATABASE] := qrQuery.FieldByName(FLD_TDB_ID_TEMPLATEDATABASE).AsInteger;
            tblModules.DataController.Values[Index, COL_TEMPLATEDATABASENAME] := qrQuery.FieldByName(FLD_TDB_NAME).AsString;
            tblModules.DataController.Values[Index, COL_MODULENAME] := string((PackageModuleScan.Items[k] as TPackageModuleItem).GetModuleInfo.Name);
            tblModules.DataController.Values[Index, COL_MODULEGUID] := GUIDToString((PackageModuleScan.Items[k] as TPackageModuleItem).GetModuleInfo.GUID);
            tblModules.DataController.Values[Index, COL_MODULEFILENAME] := (PackageModuleScan.Items[k] as TPackageModuleItem).FileName;
          finally
            qrQuery.Close();
          end;
        end
      end;
    finally
      tblModules.EndUpdate();
    end;
  finally
    PackageModuleScan.Free();
  end;
end;

end.
