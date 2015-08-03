unit _OrderRp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QRCtrls, QuickRpt, ExtCtrls, QRExport;

type
  TOrderReport = class(TForm)
    Report: TQuickRep;
    QRBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRShape1: TQRShape;
    QRBand2: TQRBand;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRBand3: TQRBand;
    QRLabel8: TQRLabel;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    TextPrice: TQRDBText;
    QRDBText6: TQRDBText;
    TextSum: TQRDBText;
    SumExpr: TQRExpr;
    QRDBText8: TQRDBText;
    QRLabel9: TQRLabel;
    QRRTFFilter: TQRRTFFilter;
    QRTextFilter: TQRTextFilter;
    CurrLabel: TQRLabel;
    QRDBText9: TQRDBText;
    QRShape6: TQRShape;
    QRLabel10: TQRLabel;
    QRDBText5: TQRDBText;
    procedure CurrLabelPrint(sender: TObject; var Value: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OrderReport: TOrderReport;

implementation

uses _Data;

{$R *.dfm}

procedure TOrderReport.CurrLabelPrint(sender: TObject; var Value: string);
begin
  case Data.Curr of
  0: Value := 'EUR';
  1: Value := 'USD';
  2: Value := 'бел.руб.';
  3: Value := 'руб.';
  end;
end;

end.
