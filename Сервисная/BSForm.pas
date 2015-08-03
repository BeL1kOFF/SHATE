unit BSForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  StdCtrls, ToolEdit, Grids, Comctrls, ExtCtrls, DBCtrls, GridsEh;

type
  TBaseForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ParentForm: TForm;
    AcceptEditMode: boolean;
  end;

var
  EditFormMode: integer;

const
  efmWindows = 0;
  efmDos     = 1;
  

implementation

{$R *.dfm}


procedure TBaseForm.FormCreate(Sender: TObject);
begin
  ParentForm := nil;
  AcceptEditMode := False;
end;

procedure TBaseForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = VK_UP) or (Key = VK_DOWN)) and (Shift = []) and
      (EditFormMode = efmDos) and

     (not((ActiveControl is TCustomDateEdit) and
          (ActiveControl as TCustomDateEdit).PopupVisible)) and
     (not(ActiveControl is TCustomRadioGroup)) and
     (not(ActiveControl is TCustomGrid)) and
     (not(ActiveControl is TCustomGridEh)) and
     (not((ActiveControl is TCustomComboBox) and
          (ActiveControl as TCustomComboBox).DroppedDown)) and
     (not((ActiveControl is TDBLookupComboBox) and
          (ActiveControl as TDBLookupComboBox).ListVisible)) and
     (not (ActiveControl is TCustomTreeView)) and
     (not (ActiveControl is TDBMemo)) then
  begin
    if Key = VK_DOWN then
      SelectNext(ActiveControl, True, True )
    else
      SelectNext(ActiveControl, False, True );
    Key := 0;
  end
end;


procedure TBaseForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (EditFormMode = efmDos) and
     (not((ActiveControl is TCustomDateEdit) and
          (ActiveControl as TCustomDateEdit).PopupVisible)) and
          (not(ActiveControl is TCustomGrid)) and
          (not(ActiveControl is TCustomGridEh)) and
     (not((ActiveControl is TCustomComboBox) and
          (ActiveControl as TCustomComboBox).DroppedDown)) and
     (not((ActiveControl is TDBLookupComboBox) and
          (ActiveControl as TDBLookupComboBox).ListVisible)) and
     (not (ActiveControl is TCustomTreeView)) and
     (not (ActiveControl is TDBMemo)) then
  begin
    SelectNext(ActiveControl, True, True );
    Key := #0;
  end;
end;


procedure TBaseForm.FormShow(Sender: TObject);
begin
  if AcceptEditMode then
    KeyPreview := True;
end;

initialization
  EditFormMode := efmWindows;

end.
