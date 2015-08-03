unit ERP.ComServ;

interface

uses
  System.Win.ComObj;

const
  GUID_MDMIMAGEPROTOCOL: TGUID = '{C379EAD1-CB34-4B09-AF6B-7E587F8BCD80}';

type
  TMainComServ = class
  private
    FComObjectFactory: TComObjectFactory;
  public
    procedure AppStart;
    procedure AppStop;
  end;

implementation

uses
  System.Win.ComServ,
  System.SysUtils,
  ERP.TAsyncPlugProt;

{ TMainComServ }

procedure TMainComServ.AppStart;
begin
  FComObjectFactory := TComObjectFactory.Create(ComServer, TAsyncPlugProt, GUID_MDMIMAGEPROTOCOL,
    'AsyncPlugProt', 'AsyncPlugProt', ciMultiInstance);
  FComObjectFactory.RegisterClassObject;
end;

procedure TMainComServ.AppStop;
begin
  {if Assigned(FComObjectFactory) then
    FreeAndNil(FComObjectFactory);}
end;

end.
