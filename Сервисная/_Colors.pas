unit _ClIDs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, _FlatSpr, AdvToolBar, AdvToolBarStylers, ImgList, ActnList,
  JvComponentBase, JvFormPlacement, DB, dbisamtb, Menus, StdCtrls, GridsEh,
  DBGridEh, ExtCtrls;

type
  TClientIDs = class(TFlatSpr)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClientIDs: TClientIDs;

implementation

uses _Main, _Data, _ClIDEd;

{$R *.dfm}

procedure TClientIDs.FormCreate(Sender: TObject);
begin
  inherited;
  EditFormClass := TClientIDEdit;
  CodeField := 'Client_id';
  NameField := 'Description';
  NewItemDescr := 'Новый ID';
end;

end.
