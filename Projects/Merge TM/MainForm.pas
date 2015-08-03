unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DB, ADODB, ActnList, System.Actions, Vcl.ComCtrls;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    btnConnect: TButton;
    lbConnect: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    ADOConnection: TADOConnection;
    ADOQuery: TADOQuery;
    Label2: TLabel;
    btnGo: TButton;
    cbMainTm: TComboBox;
    lbTm: TListBox;
    lbTmChecked: TListBox;
    ActionList: TActionList;
    acExec: TAction;
    chbDoublePart: TCheckBox;
    ADOConnectionRus: TADOConnection;
    qrDeletePartRus: TADOQuery;
    lbConnectRus: TLabel;
    pbExecute: TProgressBar;
    qrDeletePart: TADOQuery;
    lbCount: TLabel;
    procedure btnConnectClick(Sender: TObject);
    procedure lbTmDblClick(Sender: TObject);
    procedure lbTmCheckedDblClick(Sender: TObject);
    procedure acExecUpdate(Sender: TObject);
    procedure acExecExecute(Sender: TObject);
  private
    function IsCheck: Boolean;
    procedure SetConnection;
    procedure FillTm;

    procedure DeleteDoublePart;
    procedure MergeTM;

    procedure SetAppRole;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  IniFiles;

const
  ConnString = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=%s;Data Source=%s;';

procedure TfrmMain.DeleteDoublePart;
var
  Script: TStringList;
  k: Integer;
begin
  try
    Screen.Cursor := crHourGlass;
    ADOQuery.Close;
    ADOQuery.SQL.Text := ';WITH CTE AS (' +
                         '              SELECT' +
                         '                p.partid,' +
                         '                p.oenum,' +
                         '                ROW_NUMBER() OVER (PARTITION BY p.oenum ORDER BY p.partid) AS rown' +
                         '              FROM' +
                         '                part p' +
                         '              WHERE' +
                         '                p.tmid = :Id_Tm' +
                         '             )' +
                         '  SELECT' +
                         '    c.partid AS Id_Part_Old,' +
                         '    rez.partid AS Id_Part_New' +
                         '  FROM' +
                         '    CTE AS c' +
                         '    CROSS APPLY (SELECT * FROM CTE AS c2 WHERE c2.oenum = c.oenum AND c2.rown = 1) rez' +
                         '  WHERE' +
                         '    c.rown > 1' +
                         '  ORDER BY' +
                         '    c.oenum,' +
                         '    c.rown';
    ADOQuery.Parameters.ParamValues['Id_Tm'] := Integer(cbMainTm.Items.Objects[cbMainTm.ItemIndex]);
    try
      ADOQuery.Open();
      pbExecute.Min := 0;
      pbExecute.Max := ADOQuery.RecordCount;
      lbCount.Caption := Format('Всего: %d', [ADOQuery.RecordCount]);
      lbCount.Update();
      qrDeletePart.Close();
      qrDeletePartRus.Close();
      Script := TStringList.Create();
      try
        Script.LoadFromFile(ExtractFilePath(Application.ExeName) + 'script_one_brand.sql');
        qrDeletePart.SQL.Text := Script.Text;
        Script.Clear();
        Script.LoadFromFile(ExtractFilePath(Application.ExeName) + 'script_one_brand_Rus.sql');
        qrDeletePartRus.SQL.Text := Script.Text;
      finally
        Script.Free();
      end;
      ADOQuery.First();
      for k := 0 to ADOQuery.RecordCount - 1 do
      begin
        pbExecute.Position := k;
        pbExecute.Update();
        ADOConnection.BeginTrans();
        try
          qrDeletePart.Parameters.ParamValues['Id_Part_New'] := ADOQuery.FieldByName('Id_Part_New').AsInteger;
          qrDeletePart.Parameters.ParamValues['Id_Part_Old'] := ADOQuery.FieldByName('Id_Part_Old').AsInteger;
          qrDeletePartRus.Parameters.ParamValues['Id_Part_New'] := ADOQuery.FieldByName('Id_Part_New').AsInteger;
          qrDeletePartRus.Parameters.ParamValues['Id_Part_Old'] := ADOQuery.FieldByName('Id_Part_Old').AsInteger;
          qrDeletePart.ExecSQL();
          ADOConnectionRus.BeginTrans();
          try
            qrDeletePartRus.ExecSQL();
            ADOConnectionRus.CommitTrans();
          except
          begin
            ADOConnectionRus.RollbackTrans();
            raise;
          end;
          end;
          ADOConnection.CommitTrans();
        except
        begin
          ADOConnection.RollbackTrans();
          raise;
        end;
        end;
        ADOQuery.Next();
      end;
    except on E: Exception do
      Application.MessageBox(PChar(E.Message), 'Сообщение', MB_OK or MB_ICONERROR);
    end;
  finally
    ADOQuery.Close();
    Screen.Cursor := crDefault;
    pbExecute.Position := pbExecute.Max;
  end;
end;

procedure TfrmMain.FillTm;
var
  k: Integer;
begin
  ADOQuery.Close;
  ADOQuery.SQL.Text := 'SELECT * FROM tm ORDER BY [Trade Mark Name]';
  ADOQuery.Open;
  ADOQuery.First;
  cbMainTm.Items.Clear;
  lbTm.Items.Clear;
  lbTmChecked.Items.Clear;
  for k := 0 to ADOQuery.RecordCount - 1 do
  begin
    cbMainTm.Items.AddObject(ADOQuery.FieldByName('Trade Mark Name').AsString,
      TObject(ADOQuery.FieldByName('Trade Mark Code').AsInteger));
    ADOQuery.Next;
  end;
  try
    lbTm.Items.BeginUpdate;
    lbTm.Items.Assign(cbMainTm.Items);
  finally
    lbTm.Items.EndUpdate;
  end;
  ADOQuery.Close;
  pbExecute.Position := 0;
end;

function TfrmMain.IsCheck: Boolean;
var
  k: Integer;
begin
  if (lbTmChecked.Items.Count > 0) and (cbMainTm.ItemIndex > -1) then
  begin
    for k := 0 to lbTmChecked.Items.Count - 1 do
    begin
      if Integer(lbTmChecked.Items.Objects[k]) = Integer(cbMainTm.Items.Objects[cbMainTm.ItemIndex]) then
      begin
        Result := False;
        Exit;
      end;
    end;
    Result := True;
  end
  else
    Result := False;
end;

procedure TfrmMain.lbTmCheckedDblClick(Sender: TObject);
begin
  if lbTmChecked.ItemIndex < 0 then
    Exit;
  lbTm.Items.AddObject(lbTmChecked.Items[lbTmChecked.ItemIndex],
    lbTmChecked.Items.Objects[lbTmChecked.ItemIndex]);
  lbTmChecked.Items.Delete(lbTmChecked.ItemIndex);
end;

procedure TfrmMain.lbTmDblClick(Sender: TObject);
begin
  if lbTm.ItemIndex < 0 then
    Exit;
  lbTmChecked.Items.AddObject(lbTm.Items[lbTm.ItemIndex],
    lbTm.Items.Objects[lbTm.ItemIndex]);
  lbTm.Items.Delete(lbTm.ItemIndex);
end;

procedure TfrmMain.MergeTM;
var
  SQLText: string;
  TMReplace: string;
  Script: TStringList;
  k: Integer;
begin
  try
    Screen.Cursor := crHourGlass;
    ADOQuery.Close();
    SQLText := ';WITH CTE AS (' +
               '              SELECT' +
               '                p.tmid,' +
               '                p.partid,' +
               '                p.oenum,' +
               '                1 AS IsSave' +
               '              FROM' +
               '                part AS p' +
               '              WHERE' +
               '                p.tmid = :Id_Tm1' +
               '              UNION ALL' +
               '              SELECT' +
               '                p.tmid,' +
               '                p.partid,' +
               '                p.oenum,' +
               '                0 AS IsSave' +
               '              FROM' +
               '                part AS p' +
               '              WHERE' +
               '                p.tmid IN (:Id_Tm_Replace)' +
               '             )' +
               '  SELECT' +
               '    c.tmid AS Id_Tm_Old,' +
               '    c.partid AS Id_Part_Old,' +
               '    :Id_Tm2 AS Id_Tm_New,' +
               '    rez.partid AS Id_Part_New' +
               '  FROM' +
               '    CTE AS c' +
               '    OUTER APPLY (SELECT TOP 1 c2.partid FROM CTE AS c2 WHERE c2.oenum = c.oenum AND c2.IsSave = 1) rez' +
               '  WHERE' +
               '    c.IsSave = 0' +
               '  ORDER BY' +
               '    rez.partid';
    TMReplace := '';
    for k := 0 to lbTmChecked.Items.Count - 1 do
      TMReplace := TMReplace + Format('%d, ', [Integer(lbTmChecked.Items.Objects[k])]);
    Delete(TMReplace, Length(TMReplace) - 1, 2);
    SQLText := StringReplace(SQLText, ':Id_Tm_Replace', TMReplace, [rfReplaceAll, rfIgnoreCase]);
    ADOQuery.SQL.Text := SQLText;
    ADOQuery.Parameters.ParamValues['Id_Tm1'] := Integer(cbMainTm.Items.Objects[cbMainTm.ItemIndex]);
    ADOQuery.Parameters.ParamValues['Id_Tm2'] := Integer(cbMainTm.Items.Objects[cbMainTm.ItemIndex]);
    try
      ADOQuery.Open();
      pbExecute.Min := 0;
      pbExecute.Max := ADOQuery.RecordCount;
      lbCount.Caption := Format('Всего: %d', [ADOQuery.RecordCount]);
      lbCount.Update();
      qrDeletePart.Close();
      qrDeletePartRus.Close();
      Script := TStringList.Create();
      try
        Script.LoadFromFile(ExtractFilePath(Application.ExeName) + 'script.sql');
        qrDeletePart.SQL.Text := Script.Text;
        Script.Clear();
        Script.LoadFromFile(ExtractFilePath(Application.ExeName) + 'script_Rus.sql');
        qrDeletePartRus.SQL.Text := Script.Text;
      finally
        Script.Free();
      end;
      ADOQuery.First();
      for k := 0 to ADOQuery.RecordCount - 1 do
      begin
        pbExecute.Position := k;
        pbExecute.Update();
        ADOConnection.BeginTrans();
        try
          if VarIsNull(ADOQuery.FieldByName('Id_Part_New').AsVariant) then
          begin
            qrDeletePart.Parameters.ParamByName('Id_Part_New').DataType := ftInteger;
            qrDeletePartRus.Parameters.ParamByName('Id_Part_New').DataType := ftInteger;
          end;
          qrDeletePart.Parameters.ParamValues['Id_Part_New'] := ADOQuery.FieldByName('Id_Part_New').AsVariant;
          qrDeletePart.Parameters.ParamValues['Id_Part_Old'] := ADOQuery.FieldByName('Id_Part_Old').AsInteger;
          qrDeletePart.Parameters.ParamValues['Id_Tm_New'] := ADOQuery.FieldByName('Id_Tm_New').AsInteger;
          qrDeletePart.Parameters.ParamValues['Id_Tm_Old'] := ADOQuery.FieldByName('Id_Tm_Old').AsInteger;
          qrDeletePartRus.Parameters.ParamValues['Id_Part_New'] := ADOQuery.FieldByName('Id_Part_New').AsVariant;
          qrDeletePartRus.Parameters.ParamValues['Id_Part_Old'] := ADOQuery.FieldByName('Id_Part_Old').AsInteger;
          qrDeletePartRus.Parameters.ParamValues['Id_Tm_New'] := ADOQuery.FieldByName('Id_Tm_New').AsInteger;
          qrDeletePartRus.Parameters.ParamValues['Id_Tm_Old'] := ADOQuery.FieldByName('Id_Tm_Old').AsInteger;
          qrDeletePart.ExecSQL();
          ADOConnectionRus.BeginTrans();
          try
            qrDeletePartRus.ExecSQL();
            ADOConnectionRus.CommitTrans();
          except
          begin
            ADOConnectionRus.RollbackTrans();
            raise;
          end;
          end;
          ADOConnection.CommitTrans();
        except
        begin
          ADOConnection.RollbackTrans();
          raise;
        end;
        end;
        ADOQuery.Next();
      end;
    except on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message), 'Сообщение', MB_OK or MB_ICONERROR);
    end;
    end;
  finally
    ADOQuery.Close();
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.SetAppRole;
var
  Query: TADOQuery;
begin
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := ADOConnection;
    Query.SQL.Text := 'EXEC sp_setapprole ''$ndo$shadow'', ''FF5EC4E40F67BD4EDF3D04F8B84364DAD0'', ''none'', 0, 0';
    Query.ExecSQL();
  finally
    Query.Free();
  end;
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := ADOConnectionRus;
    Query.SQL.Text := 'EXEC sp_setapprole ''$ndo$shadow'', ''FF5EC4E40F67BD4EDF3D04F8B84364DAD0'', ''none'', 0, 0';
    Query.ExecSQL();
  finally
    Query.Free();
  end;
end;

procedure TfrmMain.SetConnection;
var
  ini: TIniFile;
  server, db: string;
  server_rus, db_rus: string;
begin
  Screen.Cursor := crHourGlass;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Options.ini');
  try
    server := ini.ReadString('Connect', 'Server', '');
    db := ini.ReadString('Connect', 'DataBase', '');
    server_rus := ini.ReadString('Connect', 'ServerRus', '');
    db_rus := ini.ReadString('Connect', 'DataBaseRus', '');
  finally
    ini.Free();
  end;
  ADOConnection.ConnectionString := Format(ConnString, [db, server]);
  ADOConnectionRus.ConnectionString := Format(ConnString, [db_rus, server_rus]);
  try
    ADOConnection.Connected := True;
    ADOConnectionRus.Connected := True;
    SetAppRole();
    lbConnect.Caption := 'Подключились к РБ серверу: ' + server;
    lbConnectRus.Caption := 'Подключились к РФ серверу: ' + server_rus;
    btnConnect.Enabled := False;
    FillTm;
  except on E: Exception do
  begin
    lbConnect.Caption := E.Message;
    lbConnectRus.Caption := '';
  end;
  end;
  Screen.Cursor := crDefault;
end;

procedure TfrmMain.acExecExecute(Sender: TObject);
begin
  if chbDoublePart.Checked then
    DeleteDoublePart()
  else
    MergeTM();
  FillTm;
end;

procedure TfrmMain.acExecUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (not chbDoublePart.Checked and (cbMainTm.ItemIndex > -1) and (lbTmChecked.Items.Count > 0) and (IsCheck)) or
                             (chbDoublePart.Checked and (cbMainTm.ItemIndex > -1));
  lbTm.Enabled := not chbDoublePart.Checked;
  lbTmChecked.Enabled := lbTm.Enabled;
end;

procedure TfrmMain.btnConnectClick(Sender: TObject);
begin
  SetConnection();
end;

end.
