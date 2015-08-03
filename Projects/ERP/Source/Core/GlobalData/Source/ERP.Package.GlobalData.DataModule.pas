unit ERP.Package.GlobalData.DataModule;

interface

uses
  System.SysUtils, System.Classes, Vcl.ImgList, Vcl.Controls, cxGraphics;

type
  TGDDM = class(TDataModule)
    ilGlobal32: TcxImageList;
    ilGlobalMDMCatalog32: TcxImageList;
  end;

var
  GDDM: TGDDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Vcl.Forms;

end.
