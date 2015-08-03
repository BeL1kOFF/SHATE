unit _SelectDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, DB, StdCtrls;

type
  TSelectDetail = class(TForm)
    DBGridEh: TDBGridEh;
    DataSource: TDataSource;
    procedure DBGridEhDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sBrand, sCode:string;
    Brand_id:integer;
  end;

var
  SelectDetail: TSelectDetail;

implementation
uses _Data, _Main;
{$R *.dfm}

procedure TSelectDetail.DBGridEhDblClick(Sender: TObject);
begin
  //
  ModalResult := mrOk;
end;

end.
