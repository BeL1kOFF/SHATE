unit TemplateForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess;

type
  TfrmTemplate = class(TERPCustomForm)
  private
    { Private declarations }
  public
    constructor Create(aERPClientData: IERPClientData); reintroduce;
  end;

function CreateForm(aERPClientData: IERPClientData): THandle; stdcall;
function GetIcon(aSize: Integer): THandle; stdcall;
procedure RegisterAccess(aModuleAccess: IModuleAccess); stdcall;
procedure SetModuleInfo(aModuleInfo: IModuleInfo); stdcall;

exports CreateForm;
exports GetIcon;
exports RegisterAccess;
exports SetModuleInfo;

implementation

{$R *.dfm}
{$R Resource\Icon.res}

uses
  ERP.Package.CustomClasses.Consts;

const
  MODULE_NAME            = 'Новый модуль';
  MODULE_BAR             = 'Группа на вкладке где будет модуль';
  MODULE_PAGE            = 'Вкладка';
  MODULE_GUID: TGUID     = '{00000000-0000-0000-0000-000000000000}';
  MODULE_TYPEDB          = MODULE_TYPEDB_PATTERN;

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmTemplate;
begin
  frmForm := TfrmTemplate.Create(aERPClientData);
  Result := frmForm.Handle;
end;

function GetIcon(aSize: Integer): THandle;
begin
  case aSize of
  16:
    Result := LoadIcon(HInstance, PChar(Format('%s%d', [TfrmTemplate.ClassName, 16])));
  32:
    Result := LoadIcon(HInstance, PChar(Format('%s%d', [TfrmTemplate.ClassName, 32])));
  else
    Result := 0;
  end;
end;

procedure SetModuleInfo(aModuleInfo: IModuleInfo);
begin
  aModuleInfo.GUID := MODULE_GUID;
  aModuleInfo.Name := MODULE_NAME;
  aModuleInfo.PageName := MODULE_PAGE;
  aModuleInfo.BarName := MODULE_BAR;
  aModuleInfo.TypeDB := MODULE_TYPEDB;
  aModuleInfo.TypeGuid := MODULE_TYPEMODULE_PATTERN;
end;

procedure RegisterAccess(aModuleAccess: IModuleAccess);
begin
end;

{ TfrmTemplate }

constructor TfrmTemplate.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);
end;

end.
