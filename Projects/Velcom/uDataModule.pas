unit uDataModule;

interface

uses
  SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  IdAntiFreezeBase, IdAntiFreeze, ImgList, Controls, cxGraphics, cxEditRepositoryItems, cxEdit, cxStyles, cxClasses,
  Dialogs;

type
  TDM = class(TDataModule)
    IdSMTP: TIdSMTP;
    IdAntiFreeze: TIdAntiFreeze;
    ilLargeImage: TcxImageList;
    cxStyleRepository: TcxStyleRepository;
    stlAbnStandart: TcxStyle;
    stlAbnGray: TcxStyle;
    cxEditRepository: TcxEditRepository;
    edtRepFloat: TcxEditRepositoryCurrencyItem;
    edtPhoneNumber: TcxEditRepositoryTextItem;
    edtTextCenter: TcxEditRepositoryTextItem;
    edtPhoneNumber9: TcxEditRepositoryMaskItem;
    sdExcel: TSaveDialog;
    stlRed: TcxStyle;
    stlGreen: TcxStyle;
    stlNavy: TcxStyle;
    stlDefault: TcxStyle;
    ilSmallImage: TcxImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

end.
