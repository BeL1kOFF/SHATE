unit _BigPict;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponentBase, JvFormPlacement, AdvPicture, StdCtrls, Buttons,
  ExtCtrls, JvExExtCtrls, JvImage, Printers;

type
  TBigPicture = class(TForm)
    FormStorage: TJvFormStorage;
    ExitBtn: TBitBtn;
    Image: TJvImage;
    BitBtn1: TBitBtn;
    PrintDialog: TPrintDialog;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GetPrinterInfo;
  end;

var
  BigPicture: TBigPicture;
//  Printer:TPrinter;
  PixPerInchX,PixPerInchY,PageWidthInMM,PageHeightInMM,PhysOffsetX,PhysOffsetY,
  PageResX,PageResY,PhysPageWidth,PhysPageHeigth:integer;
  Margins:TRect;

implementation

uses _Main, _Data;

{$R *.dfm}

procedure TBigPicture.GetPrinterInfo;
var
  DC:HDC;
begin
  DC:=Printer.Handle;
  PixPerInchX:=GetDeviceCaps(DC,LOGPIXELSX);
  PixPerInchY:=GetDeviceCaps(DC,LOGPIXELSY);
  PageWidthInMM:=GetDeviceCaps(DC,HORZSIZE);
  PageHeightInMM:=GetDeviceCaps(DC,VERTSIZE);

  PhysOffsetX:=GetDeviceCaps(DC,PHYSICALOFFSETX);
  PhysOffsetY:=GetDeviceCaps(DC,PHYSICALOFFSETY);

  PhysPageWidth:=GetDeviceCaps(DC,PHYSICALWIDTH);
  PhysPageHeigth:=GetDeviceCaps(DC,PHYSICALHEIGHT);

  PageResX:=GetDeviceCaps(DC,HORZRES);
  PageResY:=GetDeviceCaps(DC,VERTRES);

  // границы печати
  Margins.Top:=round(PhysOffsetY/PixPerInchY*25.4);
  Margins.Left:=round(PhysOffsetX/PixPerInchX*25.4);

  Margins.Bottom:=round((PhysPageHeigth-PageResY-PhysOffsetY)/PixPerInchY*25.4);
  Margins.Right:=round((PhysPageWidth-PageResX-PhysOffsetX)/PixPerInchX*25.4);
end;

procedure TBigPicture.BitBtn1Click(Sender: TObject);
begin
  printDialog.Copies:=0;
  if printDialog.Execute then
  begin

  Printer.Copies := printDialog.Copies;
  GetPrinterInfo;
  Printer.BeginDoc;
//  if Printer.Orientation = poLandscape then
    //  Printer.Canvas.StretchDraw(Rect(100,100,100+Image.Picture.Height*8,100+Image.Picture.Width*8),Image.Picture.Graphic)
  //else
      Printer.Canvas.StretchDraw(Rect(100,100,100+Image.Picture.Width*8,100+Image.Picture.Height*8),Image.Picture.Graphic);
  Printer.EndDoc;
  end;
end;

procedure TBigPicture.FormShow(Sender: TObject);
begin
  Caption := Data.CatalogDataSource.DataSet.FieldByName('Code').AsString + '   ' +
             Data.CatalogDataSource.DataSet.FieldByName('Name').AsString +' '+
             Data.CatalogDataSource.DataSet.FieldByName('Description').AsString;
  Image.Picture.Assign(Main.CatalogPicture.Picture);
end;

end.
