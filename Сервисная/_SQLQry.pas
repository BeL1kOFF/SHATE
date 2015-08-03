unit _SQLQry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, dbisamtb, Placemnt, StdCtrls, Buttons, RXSplit, ExtCtrls,
  Grids, DBGrids, ImgList, ActnList, VCLUtils, JvComponentBase, JvFormPlacement,
  ADODB, AdvToolBar, GridsEh, DBGridEh;

type
  TSQLQuery = class(TForm)
    SQLPanel: TPanel;
    RxSplitter1: TRxSplitter;
    Memo: TMemo;
    Query1: TDBISAMQuery;
    SQLSource: TDataSource;
    ActionList: TActionList;
    DoItAction: TAction;
    CloseAction: TAction;
    ImageList: TImageList;
    LoadAction: TAction;
    SQLOpenDialog: TOpenDialog;
    Query2: TADOQuery;
    ADOConnection: TADOConnection;
    FormStorage: TJvFormStorage;
    AdvDockPanel1: TAdvDockPanel;
    AdvToolBar1: TAdvToolBar;
    AdvToolBarButton1: TAdvToolBarButton;
    AdvToolBarButton2: TAdvToolBarButton;
    AdvToolBarButton3: TAdvToolBarButton;
    BDComboBox: TComboBox;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    SQLSaveDialog: TSaveDialog;
    SaveAction: TAction;
    AdvToolBarButton4: TAdvToolBarButton;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    Grid: TDBGridEh;
    SaveToFile: TAction;
    AdvToolBarButton5: TAdvToolBarButton;
    procedure ActionExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure SaveToFileExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SQLQuery: TSQLQuery;


implementation

uses _Main, _Data;

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
  else if Sender = SaveAction then
  begin
    if SQLSaveDialog.Execute then
      Memo.Lines.SaveToFile(SQLSaveDialog.FileName);
  end
  else if Sender = DoItAction then
  begin
    if Memo.Text = '' then
    begin
      MessageDlg('Введите текст SQL-запроса!', mtError, [mbOK], 0);
      Memo.SetFocus;
      Exit;
    end;
    StartWait;
    if Query1.Active then
      Query1.Close;
    if Query2.Active then
      Query2.Close;
    try
      try
        if BDComboBox.ItemIndex = 0 then
        begin
          SQLSource.DataSet := Query1;
          Query1.SQL.Clear;
          Query1.SQL.AddStrings(Memo.Lines);
          try
            Query1.Open;
          except
            SQLSource.DataSet := nil;
            Query1.ExecSQL;
            MessageDlg('Готово!', mtInformation, [mbOK], 0);
          end;
        end
        else
        begin
          SQLSource.DataSet := Query2;
          Query2.SQL.Clear;
          Query2.SQL.AddStrings(Memo.Lines);
          try
            Query2.Open;
          except
            SQLSource.DataSet := nil;
            Query2.ExecSQL;
            MessageDlg('Готово!', mtInformation, [mbOK], 0);
          end;
        end
      finally
        StopWait;
      end;
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
  end
  else if Sender = CloseAction then
    Close
end;

procedure TSQLQuery.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Query1.Active then
    Query1.Close;
  if Query2.Active then
    Query2.Close;
end;


procedure TSQLQuery.FormCreate(Sender: TObject);
begin
  SQLOpenDialog.InitialDir := ExtractFilePath(Application.ExeName);
  SQLSaveDialog.InitialDir := ExtractFilePath(Application.ExeName);
  if BDComboBox.ItemIndex = -1 then
    BDComboBox.ItemIndex := 0;
end;


procedure TSQLQuery.SaveToFileExecute(Sender: TObject);
var f:TextFile;
    s:string;
    i:integer;
begin
   if not SQLSaveDialog.Execute then
    exit;
   AssignFile(f,SQLSaveDialog.FileName);
   Rewrite(f);
   with Query1 do
   begin
      DisableControls;
      First;
     while not EOF do
     begin
       s:='';

       for I := 0 to Fields.Count - 1 do
       begin
        s := s + Fields[i].AsString + ';';

       end;
       Writeln(f,s);
       Next;
       EnableControls;
     end;
   end;
   CloseFile(f);
end;

end.
