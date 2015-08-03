unit PI.Modules.UI.SenderAdapter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess, cxClasses, dxBar, System.Actions, Vcl.ActnList, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridLevel, cxGrid;

type
  TfrmSenderAdapter = class(TERPCustomForm)
    dxBarManager: TdxBarManager;
    barMain: TdxBar;
    btnAdd: TdxBarLargeButton;
    btnEdit: TdxBarLargeButton;
    btnDelete: TdxBarLargeButton;
    ActionList: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    btnRefresh: TdxBarLargeButton;
    acRefresh: TAction;
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    tblSenderAdapter: TcxGridTableView;
    colId_SenderAdapter: TcxGridColumn;
    colTaskName: TcxGridColumn;
    colPluginName: TcxGridColumn;
    colProperties: TcxGridColumn;
    colId_Plugin: TcxGridColumn;
    procedure acAddExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acEditUpdate(Sender: TObject);
    procedure tblSenderAdapterCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
  private
    procedure AssignImage;
    procedure RefreshData;
    procedure ShowChild(aId_SenderAdapter: Integer);
  public
    constructor Create(aERPClientData: IERPClientData); reintroduce;
  end;

function CreateForm(aERPClientData: IERPClientData): THandle; stdcall;
procedure RegisterAccess(aModuleAccess: IModuleAccess); stdcall;
procedure SetModuleInfo(aModuleInfo: IModuleInfo); stdcall;

exports CreateForm;
exports RegisterAccess;
exports SetModuleInfo;

implementation

{$R *.dfm}
{$R Resource\Icon.res}

uses
  FireDAC.Comp.Client,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.GlobalData.DataModule,
  PI.Modules.UI.SenderAdapterDetails;

const
  MODULE_NAME            = 'Адаптеры источники';
  MODULE_GUID: TGUID     = '{1D189DE5-56B5-4402-86C7-0FB19D987272}';
  MODULE_TYPEDB          = TYPE_DATABASE_PI;

  COL_ID_SENDERADAPTER = 0;
  COL_ID_PLUGIN = 1;

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmSenderAdapter;
begin
  frmForm := TfrmSenderAdapter.Create(aERPClientData);
  Result := frmForm.Handle;
end;

procedure SetModuleInfo(aModuleInfo: IModuleInfo);
begin
  aModuleInfo.GUID := MODULE_GUID;
  aModuleInfo.Name := MODULE_NAME;
  aModuleInfo.TypeDB := MODULE_TYPEDB;
  aModuleInfo.TypeGuid := TYPEMODULE_MODULES;
end;

procedure RegisterAccess(aModuleAccess: IModuleAccess);
begin

end;

{ TfrmSenderAdapter }

procedure TfrmSenderAdapter.acAddExecute(Sender: TObject);
begin
  ShowChild(-1);
end;

procedure TfrmSenderAdapter.acEditExecute(Sender: TObject);
begin
  ShowChild(tblSenderAdapter.Controller.FocusedRecord.Values[COL_ID_SENDERADAPTER]);
end;

procedure TfrmSenderAdapter.acEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := tblSenderAdapter.Controller.SelectedRecordCount = 1;
end;

procedure TfrmSenderAdapter.acRefreshExecute(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmSenderAdapter.AssignImage;
begin
  acAdd.ImageIndex := IL_ADD;
  acEdit.ImageIndex := IL_EDIT;
  acDelete.ImageIndex := IL_DELETE;
  acRefresh.ImageIndex := IL_REFRESH;

  dxBarManager.ImageOptions.LargeImages := GDDM.ilGlobal32;
end;

constructor TfrmSenderAdapter.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);

  AssignImage();
end;

procedure TfrmSenderAdapter.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmSenderAdapter.RefreshData;
var
  Query: TFDQuery;
  k: Integer;
begin
  CreateSQLCursor();
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FDConnection;
    Query.SQL.Text := 'cln.sa_itemlist_sel';
    Query.Open();
    tblSenderAdapter.DataController.RecordCount := Query.RecordCount;
    Query.First();
    for k := 0 to tblSenderAdapter.DataController.RecordCount - 1 do
    begin
      tblSenderAdapter.DataController.Values[k, COL_ID_SENDERADAPTER] := Query.FieldByName('Id_SenderAdapter').AsInteger;
      tblSenderAdapter.DataController.Values[k, COL_ID_PLUGIN] := Query.FieldByName('Id_Plugin').AsInteger;
      tblSenderAdapter.DataController.Values[k, 2] := Query.FieldByName('TaskName').AsString;
      tblSenderAdapter.DataController.Values[k, 3] := Query.FieldByName('PluginName').AsString;
      tblSenderAdapter.DataController.Values[k, 4] := Query.FieldByName('Properties').AsString;
      Query.Next();
    end;
  finally
    Query.Free();
  end;
end;

procedure TfrmSenderAdapter.ShowChild(aId_SenderAdapter: Integer);
var
  frmSenderAdapterDetails: TfrmSenderAdapterDetails;
begin
  frmSenderAdapterDetails := TfrmSenderAdapterDetails.Create(Self, aId_SenderAdapter, ERPClientData);
  try
    frmSenderAdapterDetails.ShowModal();
  finally
    frmSenderAdapterDetails.Free();
  end;
  RefreshData();
end;

procedure TfrmSenderAdapter.tblSenderAdapterCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnEdit.Click();
end;

end.
