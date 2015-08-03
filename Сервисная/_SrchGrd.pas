unit _SrchGrd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, GridsEh, DBISAMTb, DBISAMCN, DBGridEh;

type
  TSearchGrid = class(TForm)
    Grid: TDBGridEh;
    SearchDataSource: TDataSource;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure GridEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Table:TDBISAMTable;
    procedure GoToRec;
  end;

var
  SearchGrid: TSearchGrid;

implementation

uses _Data, _Main;

{$R *.dfm}

procedure TSearchGrid.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSearchGrid.FormCreate(Sender: TObject);
var
  s: string;
begin
  s := Data.MakeSearchCode(Main.SearchEd.Text);
  if Main.CodeIgnoreSpecialSymbolsCheckBox.Checked then
  begin
     Table := Data.DoubleTableShort;
  end
  else
  begin
     Table := Data.DoubleTable;
  end;

  if length(s)<1 then
     Close;
  with Table do
      begin
        Open;
        SetRange([s], [s]);
      end;
      if Table.RecordCount < 2 then
        Close;
      
      SearchDataSource.DataSet := Table;

  Left := Main.SplitterLeft.Left + 120;
  Top  := Main.Top + Main.MainDockPanel.Height + Trunc(Main.MainGrid.Height / 2);
  Width := Main.MainGrid.Width - 240;
end;

procedure TSearchGrid.FormDeactivate(Sender: TObject);
begin

  Close;
end;

procedure TSearchGrid.FormDestroy(Sender: TObject);
begin
  Table.Close;
end;

procedure TSearchGrid.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  len: Integer;
begin
  if Key = VK_ESCAPE then
    Close
  else if Key = VK_RETURN then
    GoToRec
  else if Key = VK_BACK then
  begin
    len := Length(Main.SearchEd.Text) - 1;
    Main.SearchEd.Text := Copy(Main.SearchEd.Text, 1, len);
    Main.SearchEd.SelStart := len;
    Close;
  end

end;

procedure TSearchGrid.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in [#32..#126, #128..#255] then
  begin
    Main.SearchMode := True;
    Main.SearchEd.Text := Main.SearchEd.Text + Key;
    Main.SearchEd.SelStart := Length(Main.SearchEd.Text);
    Close;
  end;
end;

procedure TSearchGrid.GoToRec;
begin
 // Data.SearchTable.IndexName := '';
//  if Data.SearchTable.Locate('Cat_id', Data.DoubleTable.FieldByName('Cat_id').AsInteger, []) then
 //   Data.CatalogTable.GotoCurrent(Data.SearchTable);
 // Data.SearchTable.IndexName := 'Code2';
 // Main.ClearSearchMode;
  {if Data.FilterResultFind.Active then
    Data.FilterResult.GotoCurrent(Data.FilterResultFind)
  else
  Data.CatalogTable.GotoCurrent(Data.DoubleTable);}
  Data.CatalogDataSource.DataSet.Locate('Cat_id', Table.FieldByName('Cat_id').AsInteger, [loCaseInsensitive]);
  Close;
end;

procedure TSearchGrid.GridDblClick(Sender: TObject);
begin
  GoToRec
end;

procedure TSearchGrid.GridEnter(Sender: TObject);
begin
 //  GoToRec
end;

end.
