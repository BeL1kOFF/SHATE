unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, INIFiles, IBCustomDataSet, IBStoredProc, IBDatabase,
  UnitPerco, UnitReporter, Grids, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    StringGrid1: TStringGrid;
    BitBtn1: TBitBtn;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  DataLoader: TPercoDataLoader;
implementation
  uses DateUtils, UnitAUX;
{$R *.dfm}

procedure externalprocedure(Dataset: TIBDataSet);
begin
  Reporter.ProcessDataSet(Dataset);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
const
  CAPTIONSCSV = 'Дата;Вход;Присутствие;Выход;Сутки';
var
  tabno: string;
  Code: integer;
  tabelnumber: integer;
  DataPool: TDataPool;
  Proc: TIBStoredProc;
  Transaction: TIBTransaction;
  i, j: integer;
begin
  tabno := InputBox('Табельный номер для расчёта','Укажите табельный номер:', '00000');
  Val(tabno,tabelnumber,Code);
  if (Code > 0) or (tabno <= '00000') then exit;

  Reporter.SetPeriod(DateTimePicker1.Date, DateTimePicker2.Date + 1);
  DataPool.datacsv := Format('%s[%s..%s]{%s}discipline',[ExtractFilePath(Paramstr(0)),DateTimeToStr(Trunc(DateTimePicker1.DateTime)), DateTimeToStr(Trunc(DateTimePicker2.DateTime)),tabno]);
  DataPool.datacsv := transformFileName(DataPool.datacsv) + '.csv';
  if Reporter.produceStaffCrossesDataPool(tabno, DataPool.datacsv) then
   begin
    DataPool.kit := PROC_STAFF_CROSSES_GET;
    DataPool.safe := True;
    DataPool.extproc := externalprocedure;


    Reporter.fileout := Format('discipline{%s}[%s..%s].csv',[tabno, DateTimeToStr(Trunc(DateTimePicker1.DateTime)) , DateTimeToStr(Trunc(DateTimePicker2.DateTime))]);

    if SaveDialog1.FileName = '' then
      SaveDialog1.FileName := ExtractFilePath(Paramstr(0))+Reporter.fileout
     else
      SaveDialog1.FileName := StringReplace(SaveDialog1.FileName, ExtractFileName(SaveDialog1.FileName), Reporter.fileout, []);
    if SaveDialog1.Execute then
      Reporter.fileout := SaveDialog1.FileName
     else
      Reporter.fileout := '';


    if FileExists(DataPool.datacsv) then
     begin
      Transaction := TIBTransaction.Create(nil);
      try
        Proc := TIBStoredProc.Create(nil);
        try
          Proc.Transaction := Transaction;
          DataLoader.IBInit(Proc);
          DataLoader.ProcessingDataPool(DataPool);
        finally
          FreeAndNil(Proc);
        end;
      finally
        Transaction.Free;
      end;
      DeleteFile(DataPool.datacsv);
     end;



    Self.StringGrid1.Rows[0].Text := StringReplace(CAPTIONSCSV,';',#$D#$A,[rfReplaceAll]);

    if DateTimePicker2.DateTime < DateTimePicker1.DateTime then
       StringGrid1.RowCount := StringGrid1.FixedRows
     else
       StringGrid1.RowCount := 1 + StringGrid1.FixedRows + Round(DateTimePicker2.DateTime - DateTimePicker1.DateTime);

     Reporter.SetPeriod(DateTimePicker1.DateTime, DateTimePicker2.DateTime + 1);
     for i:= 0 to StringGrid1.RowCount-1-StringGrid1.FixedRows do
      for j := 0 to StringGrid1.ColCount-1 do
        StringGrid1.Cells[j, StringGrid1.FixedRows + i] := Reporter.DateCrossPassport[i, j];


   end;

  if Self.CheckBox1.Checked then
   begin
    Reporter.SetPeriod(DateTimePicker1.DateTime, DateTimePicker2.DateTime);
    //if Reporter.CheckEmployee(tabno) then
    Self.Edit1.Text := Reporter.LiveWorkerSum(tabno);

//     else
//      Self.Edit1.Text := '<??>';
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var DataPool: TDataPool;
    Proc: TIBStoredProc;
    Transaction: TIBTransaction;
begin
  if OpenDialog1.Execute then
   begin
    DataPool.datacsv := OpenDialog1.FileName;
    DataPool.kit := PROC_STAFF_CROSSES_GET;
    DataPool.safe := True;
    DataPool.extproc := externalprocedure;

    if SaveDialog1.Execute then
      Reporter.fileout := SaveDialog1.FileName
     else
      Reporter.fileout := '';

    if FileExists(DataPool.datacsv) then
     begin
      Transaction := TIBTransaction.Create(nil);
      try
        Proc := TIBStoredProc.Create(nil);
        try
          Proc.Transaction := Transaction;
          DataLoader.IBInit(Proc);
          DataLoader.ProcessingDataPool(DataPool);
        finally
          FreeAndNil(Proc);
        end;
      finally
        Transaction.Free;
      end;
     end
   end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  Self.Edit1.Visible := Self.CheckBox1.Checked;
end;

procedure TForm1.FormCreate(Sender: TObject);
const FILEINI = 'Disciplinizer.ini';
var  iniFile: TINIFile;
  RepScan: TScanRepLoader;
  workbook: string;
begin
inherited;
  Self.Caption := 'Время присутствия';
  Self.Button1.Caption := 'Выгрузить для списка';
  Self.BitBtn1.Caption := 'Выгрузить для сотрудника за период';

  Self.OpenDialog1.Filter := 'Файлы разделённых значений |*.csv';
  Self.SaveDialog1.Filter := 'Файлы разделённых значений |*.csv';

  Self.OpenDialog1.DefaultExt := '.csv';
  Self.SaveDialog1.DefaultExt := '.csv';

  Self.OpenDialog1.Title := 'Открыть файл списка запросов';
  Self.SaveDialog1.Title := 'Сохранить результаты как...';

  Self.DateTimePicker1.DateTime := Now() - DayOfTheMonth(Now()) - DayOfTheMonth(Now() - DayOfTheMonth(Now()) - 1);
  Self.DateTimePicker2.DateTime := Now() - DayOfTheMonth(Now());

  
  DataLoader := TPercoDataLoader.Create;
  DataLoader.Init(ChangeFileExt(Paramstr(0),'.ini'));//ExtractFilePath+FILEINI;


  Self.CheckBox1.Caption := 'Сумма RepScan ';
  Self.Edit1.Text := '';
  Self.Edit1.ReadOnly := True;
  Self.Edit1.Visible := Self.CheckBox1.Checked;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(DataLoader);
end;

end.
