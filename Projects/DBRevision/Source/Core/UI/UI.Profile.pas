unit UI.Profile;

interface

uses
  System.Classes,
  System.Actions,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ActnList,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.Stan.Async,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.DatS,
  FireDAC.Phys,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.UI.Intf,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxStyles,
  cxCustomData,
  cxFilter,
  cxData,
  cxDataStorage,
  cxEdit,
  cxNavigator,
  cxContainer,
  cxTextEdit,
  cxMaskEdit,
  cxDropDownEdit,
  cxGridCustomTableView,
  cxGridTableView,
  cxGridCustomView,
  cxClasses,
  cxGridLevel,
  cxGrid;

type
  TfrmProfile = class(TForm)
    ActionList: TActionList;
    qrQuery: TFDQuery;
    btnAdd: TButton;
    btnDelete: TButton;
    Panel3: TPanel;
    cxGridLeft: TcxGrid;
    tblDataBaseLeft: TcxGridTableView;
    tblDataBaseLeftColumn1: TcxGridColumn;
    tblDataBaseLeftColumn2: TcxGridColumn;
    tblDataBaseLeftColumn3: TcxGridColumn;
    cxLevelLeft: TcxGridLevel;
    Panel5: TPanel;
    cxGridRight: TcxGrid;
    tblDataBaseRight: TcxGridTableView;
    cxGridColumn1: TcxGridColumn;
    cxGridColumn2: TcxGridColumn;
    cxGridColumn3: TcxGridColumn;
    cxLevelRight: TcxGridLevel;
    cmbProfile: TcxComboBox;
    btnProfileAdd: TButton;
    acProfileAdd: TAction;
    Button1: TButton;
    Button2: TButton;
    acProfileEdit: TAction;
    acProfileDelete: TAction;
    acAdd: TAction;
    acDelete: TAction;
    FDConnectionCheck: TFDConnection;
    procedure acCancelExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acProfileAddExecute(Sender: TObject);
    procedure acProfileEditExecute(Sender: TObject);
    procedure acProfileEditUpdate(Sender: TObject);
    procedure acProfileDeleteUpdate(Sender: TObject);
    procedure acProfileDeleteExecute(Sender: TObject);
    procedure cmbProfilePropertiesChange(Sender: TObject);
    procedure acAddUpdate(Sender: TObject);
    procedure acDeleteUpdate(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure tblDataBaseRightCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure tblDataBaseLeftCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
  private
    function IsCheckServerList(const aServer, aDataBase: string): Boolean;
    procedure RefreshDataBaseLeft;
    procedure RefreshProfile(aId_ProfileActive: Integer);
    procedure RefreshUserDataBase(aId_Profile: Integer);
  end;

implementation

{$R *.dfm}

uses
  Winapi.Windows,
  System.SysUtils,
  Vcl.Dialogs,
  UI.Main;

const
  STR_CONNECTION = 'Server=%s;Database=%s;OSAuthent=YES;DriverID=MSSQL;LoginTimeout=5';

procedure TfrmProfile.acAddExecute(Sender: TObject);
var
  k: Integer;
begin
  for k := 0 to tblDataBaseLeft.Controller.SelectedRecordCount - 1 do
    if IsCheckServerList(tblDataBaseLeft.Controller.SelectedRecords[k].Values[1],
      tblDataBaseLeft.Controller.SelectedRecords[k].Values[2]) then
      if not tblDataBaseRight.DataController.Search.Locate(0, tblDataBaseLeft.Controller.SelectedRecords[k].Values[0]) then
      begin
        qrQuery.SQL.Text := 'prf_ins_userdatabase :Id_Profile, :Id_DataBase';
        qrQuery.Params.ParamValues['Id_Profile'] := Integer(cmbProfile.Properties.Items.Objects[cmbProfile.ItemIndex]);
        qrQuery.Params.ParamValues['Id_DataBase'] := tblDataBaseLeft.Controller.SelectedRecords[k].Values[0];
        qrQuery.ExecSQL();
      end;
  RefreshUserDataBase(Integer(cmbProfile.Properties.Items.Objects[cmbProfile.ItemIndex]));
end;

procedure TfrmProfile.acAddUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (cmbProfile.ItemIndex > -1) and (tblDataBaseLeft.Controller.SelectedRecordCount > 0);
end;

procedure TfrmProfile.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmProfile.acDeleteExecute(Sender: TObject);
var
  k: Integer;
begin
  for k := 0 to tblDataBaseRight.Controller.SelectedRecordCount - 1 do
  begin
    qrQuery.SQL.Text := 'prf_del_userdatabase :Id_Profile, :Id_DataBase';
    qrQuery.Params.ParamValues['Id_Profile'] := Integer(cmbProfile.Properties.Items.Objects[cmbProfile.ItemIndex]);
    qrQuery.Params.ParamValues['Id_DataBase'] := tblDataBaseRight.Controller.SelectedRecords[k].Values[0];
    qrQuery.ExecSQL();
  end;
  RefreshUserDataBase(Integer(cmbProfile.Properties.Items.Objects[cmbProfile.ItemIndex]));
end;

procedure TfrmProfile.acDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (tblDataBaseRight.Controller.SelectedRecordCount > 0);
end;

procedure TfrmProfile.acProfileAddExecute(Sender: TObject);
var
  Result: string;
begin
  Result := InputBox('Добавление профиля', 'Название', '');
  if Result <> '' then
    if cmbProfile.Properties.Items.IndexOf(Result) = -1 then
    begin
      qrQuery.SQL.Text := 'prf_ins_item :Name';
      qrQuery.Params.ParamValues['Name'] := Result;
      try
        qrQuery.Open();
        RefreshProfile(qrQuery.Fields.Fields[0].AsInteger);
      finally
        qrQuery.Close();
      end;
    end
    else
      Application.MessageBox('Профиль с таким именем уже существует!', 'Предупреждение', MB_OK or MB_ICONWARNING);
end;

procedure TfrmProfile.acProfileDeleteExecute(Sender: TObject);
begin
  if MessageBox(Handle, 'Вы хотите удалить профиль?', 'Вопрос', MB_YESNO or MB_ICONQUESTION) = ID_YES then
  begin
    qrQuery.SQL.Text := 'prf_del_item :Id_Profile';
    qrQuery.Params.ParamValues['Id_Profile'] := Integer(cmbProfile.Properties.Items.Objects[cmbProfile.ItemIndex]);
    qrQuery.ExecSQL();
    RefreshProfile(-1);
  end;
end;

procedure TfrmProfile.acProfileDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cmbProfile.ItemIndex > -1;
end;

procedure TfrmProfile.acProfileEditExecute(Sender: TObject);
var
  Result: string;
begin
  Result := InputBox('Изменение профиля', 'Название', cmbProfile.Properties.Items.Strings[cmbProfile.ItemIndex]);
  if Result <> '' then
    if Result <> cmbProfile.Properties.Items.Strings[cmbProfile.ItemIndex] then
      if cmbProfile.Properties.Items.IndexOf(Result) = -1 then
      begin
        qrQuery.SQL.Text := 'prf_upd_item :Id_Profile, :Name';
        qrQuery.Params.ParamValues['Id_Profile'] := Integer(cmbProfile.Properties.Items.Objects[cmbProfile.ItemIndex]);
        qrQuery.Params.ParamValues['Name'] := Result;
        qrQuery.ExecSQL();
        RefreshProfile(Integer(cmbProfile.Properties.Items.Objects[cmbProfile.ItemIndex]));
      end
      else
        Application.MessageBox('Профиль с таким именем уже существует!', 'Предупреждение', MB_OK or MB_ICONWARNING);
end;

procedure TfrmProfile.acProfileEditUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cmbProfile.ItemIndex > -1;
end;

procedure TfrmProfile.cmbProfilePropertiesChange(Sender: TObject);
begin
  if (Sender as TcxComboBox).ItemIndex > -1 then
    RefreshUserDataBase(Integer((Sender as TcxComboBox).Properties.Items.Objects[(Sender as TcxComboBox).ItemIndex]))
  else
    tblDataBaseRight.DataController.RecordCount := 0;
end;

procedure TfrmProfile.FormShow(Sender: TObject);
begin
  RefreshDataBaseLeft();
  RefreshProfile(-1);
end;

function TfrmProfile.IsCheckServerList(const aServer, aDataBase: string): Boolean;
begin
  FDConnectionCheck.ConnectionString := Format(STR_CONNECTION, [aServer, aDataBase]);
  try
    FDConnectionCheck.Connected := True;
    Result := True;
    FDConnectionCheck.Connected := False;
  except on E: Exception do
  begin
    Result := False;
    FDConnectionCheck.Connected := False;
    Application.MessageBox(PChar(Format('%s.%s'#13#10'%s', [aServer, aDataBase, E.Message])), 'Ошибка', MB_OK or MB_ICONERROR);
  end;
  end;
end;

procedure TfrmProfile.RefreshDataBaseLeft;
var
  k: Integer;
begin
  qrQuery.SQL.Text := 'prf_sel_database';
  try
    qrQuery.Open();
    qrQuery.First();
    tblDataBaseLeft.BeginUpdate();
    try
      tblDataBaseLeft.DataController.RecordCount := qrQuery.RecordCount;
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        tblDataBaseLeft.DataController.Values[k, 0] := qrQuery.FieldByName('Id_DataBase').AsInteger;
        tblDataBaseLeft.DataController.Values[k, 1] := qrQuery.FieldByName('Server').AsString;
        tblDataBaseLeft.DataController.Values[k, 2] := qrQuery.FieldByName('DataBase').AsString;
        qrQuery.Next();
      end;
    finally
      tblDataBaseLeft.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmProfile.RefreshProfile(aId_ProfileActive: Integer);
var
  k: Integer;
begin
  qrQuery.SQL.Text := 'prf_sel_itemlist';
  try
    qrQuery.Open();
    qrQuery.First();
    cmbProfile.Properties.Items.BeginUpdate();
    try
      cmbProfile.Properties.Items.Clear();
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        cmbProfile.Properties.Items.AddObject(qrQuery.FieldByName('Name').AsString,
          TObject(qrQuery.FieldByName('Id_Profile').AsInteger));
        qrQuery.Next();
      end;
    finally
      cmbProfile.Properties.Items.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
  cmbProfile.ItemIndex := cmbProfile.Properties.Items.IndexOfObject(TObject(aId_ProfileActive));
end;

procedure TfrmProfile.RefreshUserDataBase(aId_Profile: Integer);
var
  k: Integer;
begin
  qrQuery.SQL.Text := 'prf_sel_userdatabase :Id_Profile';
  qrQuery.Params.ParamValues['Id_Profile'] := aId_Profile;
  try
    qrQuery.Open();
    qrQuery.First();
    tblDataBaseRight.BeginUpdate();
    try
      tblDataBaseRight.DataController.RecordCount := qrQuery.RecordCount;
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        tblDataBaseRight.DataController.Values[k, 0] := qrQuery.FieldByName('Id_DataBase').AsInteger;
        tblDataBaseRight.DataController.Values[k, 1] := qrQuery.FieldByName('Server').AsString;
        tblDataBaseRight.DataController.Values[k, 2] := qrQuery.FieldByName('DataBase').AsString;
        qrQuery.Next();
      end;
    finally
      tblDataBaseRight.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmProfile.tblDataBaseLeftCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnAdd.Click();
end;

procedure TfrmProfile.tblDataBaseRightCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnDelete.Click();
end;

end.
