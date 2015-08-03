unit _QMovEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BSDlgFrm, JvComponentBase, JvFormPlacement, StdCtrls, Mask, JvExMask,
  JvToolEdit, JvBaseEdits, Buttons, ExtCtrls, AdvAppStyler, AdvPanel, DB,
  dbisamtb, Grids, DBGrids, GridsEh, DBGridEh;

type
  TQuantityMoveEdit = class(TDialogForm)
    FormStorage: TJvFormStorage;
    FormStyler: TAdvFormStyler;
    MemoryTable: TDBISAMTable;
    MemoryTablecode2: TStringField;
    MemoryTablebrand: TStringField;
    MemoryTablepos_info: TStringField;
    MemoryTableprice: TCurrencyField;
    MemoryTablekol: TFloatField;
    MemorySource: TDataSource;
    MemoryTableID: TIntegerField;
    MemoryGrid: TDBGridEh;
    Label3: TLabel;
    Label4: TLabel;
    OrderInfo1: TEdit;
    OrderInfo2: TEdit;
    MemoryTableKolMax: TIntegerField;
    ReturnDocMemoryTable: TDBISAMTable;
    ReturnDocMemoryTablecode2: TStringField;
    ReturnDocMemoryTablebrand: TStringField;
    ReturnDocMemoryTablepos_info: TStringField;
    ReturnDocMemoryTablekol: TIntegerField;
    ReturnDocMemoryTablekolMax: TIntegerField;
    ReturnDocMemoryTableordered: TSmallintField;
    ReturnDocMemoryTableID: TIntegerField;
    procedure QuantityEdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OkBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  QuantityMoveEdit: TQuantityMoveEdit;

implementation

uses _Main;

{$R *.dfm}

procedure TQuantityMoveEdit.FormCreate(Sender: TObject);
begin
  inherited;
   if Main.fOrderMasCheck then
   begin
     Self.Caption := 'Перемещение из заказа в другой заказ';
     MemoryTable.CreateTable;
     MemorySource.DataSet := MemoryTable;
     MemoryTable.Open;
   end
   else
   begin
     Self.Caption := 'Перемещение из возврата в другой возврат';
     Label3.caption := 'Из возврата';
     Label4.caption := 'В возврат';
     ReturnDocMemoryTable.CreateTable;
     MemorySource.DataSet := ReturnDocMemoryTable;
     ReturnDocMemoryTable.Open;
   end;

end;

procedure TQuantityMoveEdit.FormDestroy(Sender: TObject);
begin
  inherited;
  if Main.fOrderMasCheck then
  begin
    MemoryTable.Close;
    MemoryTable.DeleteTable;
    main.OrderDetGrid.SelectedRows.clear;
  end
  else
  begin
    ReturnDocMemoryTable.Close;
    ReturnDocMemoryTable.DeleteTable;
    main.ReturnDocDetGrid.SelectedRows.clear;
  end;
end;

procedure TQuantityMoveEdit.OkBtnClick(Sender: TObject);
var
  rez: integer;
begin
  inherited;
    rez:=0;
    if Main.fOrderMasCheck then
    begin
    memorytable.First;
      while not MemoryTable.Eof  do
      begin
         if  ((MemoryTable.FieldByName('kol').AsFloat  >  MemoryTable.FieldByName('kolMax').AsFloat) or
              (MemoryTable.FieldByName('kol').AsFloat <= 0))    then
         begin
           rez:=1;
           break;
         end;
         MemoryTable.Next;
      end;
    end
    else
    begin
      ReturnDocMemoryTable.First;
      while not ReturnDocMemoryTable.Eof  do
      begin
         if  ((ReturnDocMemoryTable.FieldByName('kol').AsFloat  >  ReturnDocMemoryTable.FieldByName('kolMax').AsFloat) or
              (ReturnDocMemoryTable.FieldByName('kol').AsFloat <= 0))    then
         begin
           rez:=1;
           break;
         end;
         ReturnDocMemoryTable.Next;
      end;
    end;

    if rez = 1 then
       MessageDlg('Введено неверное количество!', mtError, [mbOk], 0)
    else
       ModalResult := MrOk;
end;

procedure TQuantityMoveEdit.QuantityEdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
     OkBtn.Click
  else
    inherited;
end;

end.
