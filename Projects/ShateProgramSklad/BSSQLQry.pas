unit BSSQLQry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, dbisamtb, Placemnt, StdCtrls, Buttons, RXSplit, ExtCtrls,
  Grids, DBGrids, ImgList, ActnList, VCLUtils;

type
  TSQLQuery = class(TForm)
    Grid: TDBGrid;
    Panel1: TPanel;
    RxSplitter1: TRxSplitter;
    Memo: TMemo;
    DoItBtn: TBitBtn;
    CloseBtn: TBitBtn;
    FormStorage: TFormStorage;
    Qry: TDBISAMQuery;
    Src: TDataSource;
    ActionList: TActionList;
    DoItAction: TAction;
    CloseAction: TAction;
    ImageList: TImageList;
    LoadAction: TAction;
    LoadBtn: TBitBtn;
    SQLOpenDialog: TOpenDialog;
    procedure ActionExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SQLQuery: TSQLQuery;

procedure SQLQueryFor(DBName: string);

implementation

{$R *.dfm}

procedure TSQLQuery.ActionExecute(Sender: TObject);
begin
  if Sender = LoadAction then
  begin
    if SQLOpenDialog.Execute then
    begin
      Memo.Clear;
      Memo.Lines.LoadFromFile(SQLOpenDialog.FileName);
    end;
  end
  else if Sender = DoItAction then
  begin
    if Memo.Text = '' then
      Exit;
    if Qry.Active then
      Qry.Close;
    StartWait;
    Qry.SQL.Clear;
    Qry.SQL.AddStrings(Memo.Lines);
    try
      Qry.Open;
      StopWait;
    except
      try
        Qry.ExecSQL
      finally
        StopWait;
      end
    end;
  end
  else if Sender = CloseAction then
    Close
end;

procedure TSQLQuery.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Qry.Active then
    Qry.Close;
end;


procedure TSQLQuery.FormCreate(Sender: TObject);
begin
  SQLOpenDialog.InitialDir := ExtractFilePath(Application.ExeName);
end;

procedure SQLQueryFor(DBName: string);
begin
  with TSQLQuery.Create(Application) do
  begin
    Qry.DataBaseName := DBName;
    ShowModal;
    Free;
  end
end;

end.
