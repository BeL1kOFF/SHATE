unit MDM.Package.Classes.TCustomFormDetail;

interface

uses
  System.Classes,
  Vcl.Forms,
  FireDAC.Comp.Client,
  MDM.Package.Interfaces.ICatalogDraftController;

type
  TCustomFormDetail = class(TForm)
  private
    FCatalogDraftController: ICatalogDraftController;
    FNewItem: Boolean;
    function GetConnection: TFDConnection;
  protected
    procedure AfterInitItem; virtual;
    procedure BeforeInitItem; virtual;
    procedure DoShow; override;
    procedure InitEditItem; virtual;
    procedure InitItem;
    procedure InitNewItem; virtual;
    property FDConnection: TFDConnection read GetConnection;
  public
    constructor Create(aOwner: TComponent; aCatalogDraftController: ICatalogDraftController); reintroduce;
    property NewItem: Boolean read FNewItem write FNewItem;
    property CatalogDraftController: ICatalogDraftController read FCatalogDraftController;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  MDM.Package.Classes.TCatalogDraftController;

type
  EControllerInitItem = class(Exception);

{ TCustomFormDetail }

procedure TCustomFormDetail.AfterInitItem;
begin

end;

procedure TCustomFormDetail.BeforeInitItem;
begin

end;

constructor TCustomFormDetail.Create(aOwner: TComponent; aCatalogDraftController: ICatalogDraftController);
begin
  inherited Create(aOwner);
  if Assigned(aOwner) then
    Caption := (aOwner as TForm).Caption;
  FCatalogDraftController := aCatalogDraftController;
end;

procedure TCustomFormDetail.DoShow;
begin
  try
    InitItem();
  except on E: Exception do
    Application.MessageBox(PChar(E.ToString), 'Ошибка', MB_OK or MB_ICONERROR);
  end;
  inherited DoShow();
end;

function TCustomFormDetail.GetConnection: TFDConnection;
begin
  Result := TCatalogDraftController(FCatalogDraftController).ERPForm.FDConnection;
end;

procedure TCustomFormDetail.InitEditItem;
begin

end;

procedure TCustomFormDetail.InitItem;
begin
  try
    BeforeInitItem();
  except
    raise EControllerInitItem.Create('Ошибка выполнения BeforeInitItem');
  end;
  if FNewItem then
    try
      InitNewItem();
    except
      raise EControllerInitItem.Create('Ошибка выполнения InitNewItem');
    end
  else
  begin
    try
      TCatalogDraftController(FCatalogDraftController).ReadItem();
    except
      raise EControllerInitItem.Create('Ошибка выполнения ReadItem');
    end;
    try
      InitEditItem();
    except
      raise EControllerInitItem.Create('Ошибка выполнения InitEditItem');
    end;
  end;
  try
    AfterInitItem();
  except
    raise EControllerInitItem.Create('Ошибка выполнения AfterInitItem');
  end;
end;

procedure TCustomFormDetail.InitNewItem;
begin

end;

end.
