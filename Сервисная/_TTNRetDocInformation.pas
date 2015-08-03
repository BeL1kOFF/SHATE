unit _TTNRetDocInformation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GridsEh, DBGridEh, ExtCtrls;

type
  TTTNRetDocInformationForm = class(TForm)
    GridPanel: TPanel;
    TextPanel: TPanel;
    memoInfromation: TMemo;
    OrderGrid: TDBGridEh;
    procedure FormShow(Sender: TObject);
  private
    fVisiblePanel: boolean;
    fMemoLines: string;
  public
    procedure FillInformation(const aInformationMsg: string);
    procedure SetVisible();
  end;


var
  TTNRetDocInformationForm: TTTNRetDocInformationForm;

implementation

{$R *.dfm}

{ TTTNRetDocInformationForm }

procedure TTTNRetDocInformationForm.FillInformation(
  const aInformationMsg: string);
begin
  fVisiblePanel := length(aInformationMsg) > 0;
  if length(aInformationMsg) > 0 then
    fMemoLines := aInformationMsg
end;

procedure TTTNRetDocInformationForm.FormShow(Sender: TObject);
begin
  memoInfromation.Text := fMemoLines;
  SetVisible();
  Caption := 'Данные для ТТН возврата ( ' + FormatDateTime('dd.mm.yyyy', Now() + 1) + ' )';
end;

procedure TTTNRetDocInformationForm.SetVisible();
begin
  GridPanel.Visible := not fVisiblePanel;
  textPanel.Visible := fVisiblePanel;
end;

end.
