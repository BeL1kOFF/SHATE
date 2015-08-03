unit ShateM.Components.TsmGridColumnHide.UI.ColumnCaption;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxCheckListBox, Vcl.StdCtrls, Vcl.ExtCtrls, System.Actions, Vcl.ActnList, Data.DB, cxGridTableView;

type
  TfrmColumnCaption = class(TForm)
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    Panel2: TPanel;
    clbTableColumn: TcxCheckListBox;
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FQuery: TDataSet;
    FTableView: TcxGridTableView;
    FUserName: string;
    FModuleName: string;
    function Check: Boolean;
    procedure ClearBoxColumns;
    procedure FillBoxColumns(aQuery: TDataSet);
    procedure Save;
  public
    constructor Create(aOwner: TComponent; aQuery: TDataSet; aTableView: TcxGridTableView;
      const aUserName, aModuleName: string); reintroduce;
  end;

const
  DATASOURCE_LOCATE_FIELDS = 'UserName;ModuleName;TableName;ColumnName';

implementation

resourcestring
  RsSaveNotHideColumn = 'Нельзя спрятать все колонки!';
  RsSaveWarning = 'Предупреждение';

{$R *.dfm}

{ TfrmColumnCaption }

procedure TfrmColumnCaption.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmColumnCaption.acSaveExecute(Sender: TObject);
begin
  if Check() then
  begin
    Save();
    Close();
  end
  else
    MessageBox(Handle, PChar(RsSaveNotHideColumn), PChar(RsSaveWarning), MB_OK or MB_ICONWARNING);
end;

function TfrmColumnCaption.Check: Boolean;
var
  k: Integer;
begin
  Result := False;
  for k := 0 to Length(string(clbTableColumn.EditValue)) - 1 do
    if string(clbTableColumn.EditValue)[k + 1] = '1' then
    begin
      Result := True;
      Break;
    end;
end;

procedure TfrmColumnCaption.ClearBoxColumns;
var
  k: Integer;
begin
  for k := 0 to clbTableColumn.Items.Count - 1 do
    StrDispose(PChar(clbTableColumn.Items[k].ItemObject));
  clbTableColumn.Items.Clear();
end;

constructor TfrmColumnCaption.Create(aOwner: TComponent; aQuery: TDataSet; aTableView: TcxGridTableView;
  const aUserName, aModuleName: string);
begin
  inherited Create(aOwner);
  FQuery := aQuery;
  FTableView := aTableView;
  FUserName := aUserName;
  FModuleName := aModuleName;
  FillBoxColumns(FQuery);
end;

procedure TfrmColumnCaption.FillBoxColumns(aQuery: TDataSet);
var
  k: Integer;
  CheckListBoxItem: TcxCheckListBoxItem;
begin
  ClearBoxColumns();
  try
    aQuery.Open();
    for k := 0 to FTableView.ColumnCount - 1 do
      if FTableView.Columns[k].Caption <> '' then
      begin
        CheckListBoxItem := clbTableColumn.Items.Add;
        CheckListBoxItem.Text := FTableView.Columns[k].Caption;
        CheckListBoxItem.ItemObject := Pointer(StrNew(PChar(FTableView.Columns[k].Name)));
        aQuery.First();
        if aQuery.Locate(DATASOURCE_LOCATE_FIELDS,
                         VarArrayOf([FUserName, FModuleName, FTableView.Name, FTableView.Columns[k].Name]), []) then
          CheckListBoxItem.State := cbsUnChecked
        else
          CheckListBoxItem.State := cbsChecked;
      end;
  finally
    aQuery.Close();
  end;
end;

procedure TfrmColumnCaption.FormDestroy(Sender: TObject);
begin
  ClearBoxColumns();
end;

procedure TfrmColumnCaption.Save;
var
  k: Integer;
begin
  try
    FQuery.Open();
    for k := 0 to Length(string(clbTableColumn.EditValue)) - 1 do
      if FQuery.Locate(DATASOURCE_LOCATE_FIELDS,
                       VarArrayOf([FUserName, FModuleName, FTableView.Name, string(PChar(clbTableColumn.Items[k].ItemObject))]), []) then
      begin
        if string(clbTableColumn.EditValue)[k + 1] = '1' then
          FQuery.Delete();
      end
      else
      if string(clbTableColumn.EditValue)[k + 1] = '0' then
        begin
          FQuery.Insert();
          FQuery.FieldByName('UserName').AsString := FUserName;
          FQuery.FieldByName('ModuleName').AsString := FModuleName;
          FQuery.FieldByName('TableName').AsString := FTableView.Name;
          FQuery.FieldByName('ColumnName').AsString := string(PChar(clbTableColumn.Items[k].ItemObject));
          FQuery.Post();
        end;
  finally
    FQuery.Close();
  end;
end;

end.
