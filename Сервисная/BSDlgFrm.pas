unit BSDlgFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, Mask, Placemnt, Db, BSForm, StdCtrls, ExtCtrls;

type
  TDialogForm = class(TBaseForm)
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    BtnBevel: TBevel;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OkBtnClick(Sender: TObject);
    procedure CancelBtnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CancelBtnFlag: boolean;
    DataSource: TDataSource;
  end;


resourcestring
  BSSaveMess = 'Сохранить изменения?';


implementation


{$R *.DFM}


procedure TDialogForm.FormShow(Sender: TObject);
begin
  CancelBtnFlag := False;
  if DataSource <> nil then
    DataSource.DataSet.Edit;
  OkBtn.Default := (EditFormMode = efmWindows);
end;

procedure TDialogForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if DataSource <> nil then
  begin
    if (not CancelBtnFlag) and
       (DataSource.DataSet.State <> dsBrowse) and
       (DataSource.DataSet.Modified) and
       (MessageDlg(BSSaveMess, mtConfirmation,
                                         [mbYes, mbNo], 0) = mrYes) then
      DataSource.DataSet.Post
    else
      DataSource.DataSet.Cancel;
  end;
end;

procedure TDialogForm.OkBtnClick(Sender: TObject);
begin
  if DataSource <> nil then
  begin
    if DataSource.DataSet.State <> dsBrowse then
      DataSource.DataSet.Post;
  end;
end;

procedure TDialogForm.CancelBtnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CancelBtnFlag := True;
end;


procedure TDialogForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F10) or ((Key = VK_RETURN) and ( ssCtrl in Shift )) then
  begin
    ActiveControl := OkBtn;
    OkBtn.Click;
    Key := 0;
  end;
  inherited;
end;


procedure TDialogForm.FormCreate(Sender: TObject);
begin
  inherited;
  AcceptEditMode := True;
end;

end.
