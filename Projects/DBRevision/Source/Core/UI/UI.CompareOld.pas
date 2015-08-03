unit UI.CompareOld;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridLevel, cxGrid, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, SynMemo;

type
  TfrmCompareOld = class(TForm)
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    tblDiff: TcxGridTableView;
    colIdSQLScriptOld: TcxGridColumn;
    colCreateUser: TcxGridColumn;
    colCreateDate: TcxGridColumn;
    qrQuery: TFDQuery;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure tblDiffCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
  private
    FId_SQLScript: Integer;
    FSynMemo: TSynMemo;
    procedure Compare;
    procedure RefreshDiff;
  public
    constructor Create(aOwner: TComponent; aId_SQLScript: Integer; aSynMemo: TSynMemo); reintroduce;
  end;

implementation

uses
  Winapi.ShellAPI,
  System.IOUtils,
  UI.Main;

{$R *.dfm}

procedure TfrmCompareOld.Compare;
var
  TmpPath: string;
  TempPathLen: DWORD;
  FileName1, FileName2: string;
  ShellExecuteInfo: TShellExecuteInfo;
begin
  qrQuery.SQL.Text := 'diff_sel_itemdiff :Id_SQLScriptOld';
  qrQuery.Params.ParamValues['Id_SQLScriptOld'] := tblDiff.Controller.FocusedRecord.Values[0];
  try
    qrQuery.Open();
    SetLength(TmpPath, MAX_PATH + 1);
    TempPathLen := GetTempPath(MAX_PATH, PChar(TmpPath));
    SetLength(TmpPath, TempPathLen);
    FileName1 := Format('%sNow.sql', [TmpPath]);
    if TFile.Exists(FileName1) then
      TFile.Delete(FileName1);
    TFile.WriteAllText(FileName1, FSynMemo.Lines.Text);
    FileName2 := Format('%s%d.sql', [TmpPath, Integer(tblDiff.Controller.FocusedRecord.Values[0])]);
    if TFile.Exists(FileName2) then
      TFile.Delete(FileName2);
    if FSynMemo = frmMain.SynMemoCommit then
      TFile.WriteAllText(FileName2, qrQuery.FieldByName('BodyCommit').AsString)
    else
      TFile.WriteAllText(FileName2, qrQuery.FieldByName('BodyRollback').AsString);
    ZeroMemory(@ShellExecuteInfo, SizeOf(ShellExecuteInfo));
    ShellExecuteInfo.cbSize := SizeOf(ShellExecuteInfo);
    ShellExecuteInfo.fMask := SEE_MASK_DEFAULT;
    ShellExecuteInfo.Wnd := Application.Handle;
    ShellExecuteInfo.lpVerb := 'open';
    ShellExecuteInfo.lpFile := PChar(frmMain.ComparePath);
    ShellExecuteInfo.lpParameters := PChar(Format('%s %s', [FileName2, FileName1]));
    ShellExecuteInfo.nShow := SW_SHOW;
    Win32Check(ShellExecuteEx(@ShellExecuteInfo));
  finally
    qrQuery.Close();
  end;
end;

constructor TfrmCompareOld.Create(aOwner: TComponent; aId_SQLScript: Integer; aSynMemo: TSynMemo);
begin
  inherited Create(aOwner);
  FId_SQLScript := aId_SQLScript;
  FSynMemo := aSynMemo;
end;

procedure TfrmCompareOld.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #27:
      Close();
  end;
end;

procedure TfrmCompareOld.FormShow(Sender: TObject);
begin
  RefreshDiff();
end;

procedure TfrmCompareOld.RefreshDiff;
var
  k: Integer;
begin
  qrQuery.SQL.Text := 'diff_sel_itemlist :Id_SQLScript';
  qrQuery.Params.ParamValues['Id_SQLScript'] := FId_SQLScript;
  try
    qrQuery.Open();
    tblDiff.BeginUpdate();
    try
      tblDiff.DataController.RecordCount := qrQuery.RecordCount;
      qrQuery.First();
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        tblDiff.DataController.Values[k, 0] := qrQuery.FieldByName('Id_SQLScriptOld').AsInteger;
        tblDiff.DataController.Values[k, 1] := qrQuery.FieldByName('CreateUser').AsString;
        tblDiff.DataController.Values[k, 2] := qrQuery.FieldByName('CreateDate').AsDateTime;
        qrQuery.Next();
      end;
    finally
      tblDiff.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmCompareOld.tblDiffCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  Compare();
end;

end.
