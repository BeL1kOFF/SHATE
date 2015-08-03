unit ERP.Admin.UI.AccessData;

(*
CREATE TABLE [AdminAccessData](
	[Id_AccessGroup] [int] NOT NULL,
	[AccessCode] [int] NOT NULL,
	[Id_Data] [int] NOT NULL,
	[CreateDate] [datetimeoffset](7) NOT NULL,
	[CreateUser] [nvarchar](128) NOT NULL
)
*)

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Comp.Client, cxClasses, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridLevel, cxGrid, Vcl.ExtCtrls, System.Actions, Vcl.ActnList, Vcl.StdCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  ERP.Package.ClientInterface.IERPClientData, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  System.Generics.Collections, cxCheckBox;

type
  TfrmAccessData = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    cxGrid: TcxGrid;
    tblData: TcxGridTableView;
    colId_DataBase: TcxGridColumn;
    colId_AccessTable: TcxGridColumn;
    colDataBaseName: TcxGridColumn;
    colTableCaption: TcxGridColumn;
    colFieldCaption: TcxGridColumn;
    cxLevel: TcxGridLevel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    qrQuery: TFDQuery;
    FDConnectionRemote: TFDConnection;
    qrQueryRemote: TFDQuery;
    colTemplateName: TcxGridColumn;
    colChecked: TcxGridColumn;
    colId_Data: TcxGridColumn;
    colAccessCode: TcxGridColumn;
    colPrevChecked: TcxGridColumn;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
  private
    FConnection: TFDConnection;
    FERPClientData: IERPClientData;
    FId_AccessGroup: Integer;
    FListDataBase: TList<Integer>;
    function CheckCorrectedTable: Boolean;
    function Save: Boolean;
    procedure RefreshData;
  public
    constructor Create(aFDConnection: TFDConnection; aId_AccessGroup: Integer;
      aERPClientData: IERPClientData; aOwner: TComponent); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Admin.UI.AccessGroup;

const
  PROC_ADM_AG_AD_SEL_TABLE = 'adm_ag_ad_sel_table :Id_AccessGroup';

  PROC_SELECTREMOTEDATA = 'SELECT %s, %s AS %s, CAST(CASE WHEN aad.Id_Data IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS Checked FROM %s tmp'#13#10 +
                          '  LEFT JOIN AdminAccessData aad ON aad.Id_Data = tmp.%s AND'#13#10 +
                          '                                   aad.AccessCode = :AccessCode AND'#13#10 +
                          '                                   aad.Id_AccessGroup = :Id_AccessGroup';

  PARAM_AGADTBL_ID_ACCESSGROUP = 'Id_AccessGroup';

  FLD_AGADTBL_ID_DATABASE    = 'Id_DataBase';
  FLD_AGADTBL_ID_ACCESSTABLE = 'Id_AccessTable';
  FLD_AGADTBL_TEMPLATENAME   = 'TemplateName';
  FLD_AGADTBL_DATABASENAME   = 'DataBaseName';
  FLD_AGADTBL_TABLENAME      = 'TableName';
  FLD_AGADTBL_TABLECAPTION   = 'TableCaption';
  FLD_AGADTBL_FIELDID        = 'FieldId';
  FLD_AGADTBL_FIELDNAME      = 'FieldName';
  FLD_AGADTBL_FIELDCAPTION   = 'FieldCaption';
  FLD_AGADTBL_ACCESSCODE     = 'AccessCode';

  COL_ID_DATABASE    = 0;
  COL_ID_DATA        = 2;
  COL_ACCESSCODE     = 5;
  COL_CHECKED        = 8;
  COL_PREVCHECKED    = 9;

{ TfrmAccessData }

procedure TfrmAccessData.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAccessData.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

function TfrmAccessData.CheckCorrectedTable: Boolean;
begin
  qrQueryRemote.SQL.Text := 'IF OBJECT_ID(''AdminAccessData'') IS NOT NULL SELECT 1 ELSE SELECT 0';
  try
    Result := False;
    qrQueryRemote.Open();
    Result := qrQueryRemote.Fields.Fields[0].AsInteger = 1;
  finally
    qrQueryRemote.Close();
  end;
end;

constructor TfrmAccessData.Create(aFDConnection: TFDConnection; aId_AccessGroup: Integer;
  aERPClientData: IERPClientData; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FERPClientData := aERPClientData;
  FId_AccessGroup := aId_AccessGroup;
  FConnection := aFDConnection;
  qrQuery.Connection := FConnection;
  FListDataBase := TList<Integer>.Create();
end;

procedure TfrmAccessData.FormDestroy(Sender: TObject);
begin
  FListDataBase.Free();
end;

procedure TfrmAccessData.FormShow(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmAccessData.RefreshData;

type
  TAccessTable = packed record
    Id_DataBase: Integer;
    Id_AccessTable: Integer;
    TemplateName: string;
    DataBaseName: string;
    TableName: string;
    TableCaption: string;
    FieldId: string;
    FieldName: string;
    FieldCaption: string;
    AccessCode: Integer;
  end;
var
  k, i: Integer;
  Index: Integer;
  AccessTable: TAccessTable;

  function GetConnection(aId_DataBase: Integer): Pointer;
  var
    k: Integer;
  begin
    Result := nil;
    for k := 0 to FERPClientData.DBConnectionManager.Count - 1 do
      if FERPClientData.DBConnectionManager.Items[k].Id_DataBase = aId_DataBase then
      begin
        Result := FERPClientData.DBConnectionManager.Items[k].FDConnectionHandle;
        Break;
      end;
  end;

  procedure SetRemouteConnection(aRemoteConnection: TFDConnection);
  begin
    if FListDataBase.IndexOf(AccessTable.Id_DataBase) = -1 then
    begin
      aRemoteConnection.SharedCliHandle :=
        FERPClientData.ERPApplication.CreateFDConnection(AccessTable.Id_DataBase, MODULE_GUID).FDConnectionHandle;
      FListDataBase.Add(AccessTable.Id_DataBase);
    end
    else
      aRemoteConnection.SharedCliHandle := GetConnection(AccessTable.Id_DataBase);
  end;

begin
  CreateSQLCursor();
  tblData.BeginUpdate();
  try
    tblData.DataController.RecordCount := 0;
    Index := -1;
    qrQuery.SQL.Text := PROC_ADM_AG_AD_SEL_TABLE;
    qrQuery.Params.ParamValues[PARAM_AGADTBL_ID_ACCESSGROUP] := FId_AccessGroup;
    try
      qrQuery.Open();
      qrQuery.First();
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        ZeroMemory(@AccessTable, SizeOf(AccessTable));
        AccessTable.Id_DataBase := qrQuery.FieldByName(FLD_AGADTBL_ID_DATABASE).AsInteger;
        AccessTable.Id_AccessTable := qrQuery.FieldByName(FLD_AGADTBL_ID_ACCESSTABLE).AsInteger;
        AccessTable.TemplateName := qrQuery.FieldByName(FLD_AGADTBL_TEMPLATENAME).AsString;
        AccessTable.DataBaseName := qrQuery.FieldByName(FLD_AGADTBL_DATABASENAME).AsString;
        AccessTable.TableName := qrQuery.FieldByName(FLD_AGADTBL_TABLENAME).AsString;
        AccessTable.TableCaption := qrQuery.FieldByName(FLD_AGADTBL_TABLECAPTION).AsString;
        AccessTable.FieldId := qrQuery.FieldByName(FLD_AGADTBL_FIELDID).AsString;
        AccessTable.FieldName := qrQuery.FieldByName(FLD_AGADTBL_FIELDNAME).AsString;
        AccessTable.FieldCaption := qrQuery.FieldByName(FLD_AGADTBL_FIELDCAPTION).AsString;
        AccessTable.AccessCode := qrQuery.FieldByName(FLD_AGADTBL_ACCESSCODE).AsInteger;
        SetRemouteConnection(FDConnectionRemote);
        try
          FDConnectionRemote.Connected := True;
          if CheckCorrectedTable() then
          begin
            qrQueryRemote.SQL.Text := Format(PROC_SELECTREMOTEDATA, [AccessTable.FieldId, AccessTable.FieldName,
              AccessTable.FieldCaption, AccessTable.TableName, AccessTable.FieldId]);
            qrQueryRemote.Params.ParamValues['AccessCode'] := AccessTable.AccessCode;
            qrQueryRemote.Params.ParamValues['Id_AccessGroup'] := FId_AccessGroup;
            try
              qrQueryRemote.Open();
              tblData.DataController.RecordCount := tblData.DataController.RecordCount + qrQueryRemote.RecordCount;
              qrQueryRemote.First();
              for i := 0 to qrQueryRemote.RecordCount - 1 do
              begin
                Inc(Index);
                tblData.DataController.Values[Index, COL_ID_DATABASE] := AccessTable.Id_DataBase;
                tblData.DataController.Values[Index, 1] := AccessTable.Id_AccessTable;
                tblData.DataController.Values[Index, COL_ID_DATA] := qrQueryRemote.FieldByName(AccessTable.FieldId).AsInteger;
                tblData.DataController.Values[Index, 3] := AccessTable.TemplateName;
                tblData.DataController.Values[Index, 4] := AccessTable.DataBaseName;
                tblData.DataController.Values[Index, COL_ACCESSCODE] := AccessTable.AccessCode;
                tblData.DataController.Values[Index, 6] := AccessTable.TableCaption;
                tblData.DataController.Values[Index, 7] := qrQueryRemote.FieldByName(AccessTable.FieldCaption).AsString;
                tblData.DataController.Values[Index, COL_CHECKED] := qrQueryRemote.FieldByName('Checked').AsBoolean;
                tblData.DataController.Values[Index, COL_PREVCHECKED] := qrQueryRemote.FieldByName('Checked').AsBoolean;
                qrQueryRemote.Next();
              end;
            finally
              qrQueryRemote.Close();
            end;
          end
          else
            MessageBox(Handle,
              PChar(Format('В базе данных %s отсутствует таблица AdminAccessData. Доступы по ней не могут быть прочитаны!', [AccessTable.DataBaseName])),
              'Предупреждение', MB_OK or MB_ICONWARNING);
        finally
          FDConnectionRemote.Connected := False;
        end;
        qrQuery.Next();
      end;
    finally
      qrQuery.Close();
    end;
  finally
    tblData.EndUpdate();
  end;
end;

function TfrmAccessData.Save: Boolean;
type
  PAccessData = ^TAccessData;
  TAccessData = packed record
    Id_AccessGroup: Integer;
    AccessCode: Integer;
    Id_Data: Integer;
    IsDelete: Boolean;
  end;

var
  k, i: Integer;
  ListChange: TDictionary<Integer, TList<PAccessData>>;
  ListData: TList<PAccessData>;
  AccessData: PAccessData;
  Id_DataBase: Integer;

begin
  Result := False;
  CreateSQLCursor();
  ListChange := TDictionary<Integer, TList<PAccessData>>.Create();
  try
    for k := 0 to tblData.DataController.RecordCount - 1 do
      if tblData.DataController.Values[k, COL_CHECKED] <> tblData.DataController.Values[k, COL_PREVCHECKED] then
      begin
        if not ListChange.ContainsKey(tblData.DataController.Values[k, COL_ID_DATABASE]) then
        begin
          ListData := TList<PAccessData>.Create();
          ListChange.Add(tblData.DataController.Values[k, COL_ID_DATABASE], ListData);
        end
        else
          ListData := ListChange.Items[tblData.DataController.Values[k, COL_ID_DATABASE]];
        New(AccessData);
        try
          AccessData^.Id_AccessGroup := FId_AccessGroup;
          AccessData^.AccessCode := tblData.DataController.Values[k, COL_ACCESSCODE];
          AccessData^.Id_Data := tblData.DataController.Values[k, COL_ID_DATA];
          AccessData^.IsDelete := not tblData.DataController.Values[k, COL_CHECKED];
          ListData.Add(AccessData);
        except on E: Exception do
        begin
          Dispose(AccessData);
          raise;
        end;
        end;
      end;
    for k := 0 to ListChange.Keys.Count - 1 do
    begin
      Id_DataBase := ListChange.Keys.ToArray[k];
      ListData := ListChange.Items[Id_DataBase];
      FDConnectionRemote.SharedCliHandle := FERPClientData.ERPApplication.CreateFDConnection(Id_DataBase, MODULE_GUID).FDConnectionHandle;
      FDConnectionRemote.Connected := True;
      try
        if CheckCorrectedTable() then
          for i := 0 to ListData.Count - 1 do
          begin
            if ListData.Items[i]^.IsDelete then
              qrQueryRemote.SQL.Text := 'DELETE FROM AdminAccessData'#13#10 +
                                        'WHERE Id_AccessGroup = :Id_AccessGroup AND AccessCode = :AccessCode AND Id_Data = :Id_Data'
            else
              qrQueryRemote.SQL.Text := 'INSERT INTO AdminAccessData (Id_AccessGroup, AccessCode, Id_Data, CreateDate, CreateUser)'#13#10 +
                                        'VALUES(:Id_AccessGroup, :AccessCode, :Id_Data, SYSDATETIMEOFFSET(), SUSER_NAME())';
            qrQueryRemote.Params.ParamValues['Id_AccessGroup'] := ListData.Items[i]^.Id_AccessGroup;
            qrQueryRemote.Params.ParamValues['AccessCode'] := ListData.Items[i]^.AccessCode;
            qrQueryRemote.Params.ParamValues['Id_Data'] := ListData.Items[i]^.Id_Data;
            qrQueryRemote.ExecSQL();
          end
        else
          MessageBox(Handle,
            PChar(Format('В базе данных %d отсутствует таблица AdminAccessData. Доступы по ней не могут быть сохранены!', [Id_DataBase])),
            'Предупреждение', MB_OK or MB_ICONWARNING);
      finally
        FDConnectionRemote.Connected := False;
      end;
    end;
    Result := True;
  finally
  begin
    for k := 0 to ListChange.Keys.Count - 1 do
    begin
      for i := 0 to ListChange.Items[ListChange.Keys.ToArray[k]].Count - 1 do
        Dispose(ListChange.Items[ListChange.Keys.ToArray[k]].Items[i]);
      ListChange.Items[ListChange.Keys.ToArray[k]].Free();
    end;
    ListChange.Free();
  end;
  end;
end;

end.
