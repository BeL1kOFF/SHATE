unit PI.Modules.UI.ReceiverAdapter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridCustomView, cxGrid, System.Actions, Vcl.ActnList, dxBar,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess;

type
  TfrmReceiverAdapter = class(TERPCustomForm)
    dxBarManager: TdxBarManager;
    barMain: TdxBar;
    btnAdd: TdxBarLargeButton;
    btnEdit: TdxBarLargeButton;
    btnDelete: TdxBarLargeButton;
    btnRefresh: TdxBarLargeButton;
    ActionList: TActionList;
    acAdd: TAction;
    acEdit: TAction;
    acDelete: TAction;
    acRefresh: TAction;
    cxGrid1: TcxGrid;
    tblReceiverAdapter: TcxGridTableView;
    tblReceiverAdapterColumn1: TcxGridColumn;
    tblReceiverAdapterColumn2: TcxGridColumn;
    tblReceiverAdapterColumn3: TcxGridColumn;
    tblReceiverAdapterColumn4: TcxGridColumn;
    cxGrid1Level1: TcxGridLevel;
    procedure FormShow(Sender: TObject);
  private
    procedure RefreshData;
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

uses
  ERP.Package.CustomClasses.Consts;

const
  MODULE_NAME            = 'Адаптеры приемники';
  MODULE_GUID: TGUID     = '{7C717522-9F4F-4AAF-AB44-D32F09EA3DA0}';
  MODULE_TYPEDB          = TYPE_DATABASE_PI;

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmReceiverAdapter;
begin
  frmForm := TfrmReceiverAdapter.Create(aERPClientData);
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

{ TForm1 }

constructor TfrmReceiverAdapter.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);
end;

procedure TfrmReceiverAdapter.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmReceiverAdapter.RefreshData;
begin

end;

end.
