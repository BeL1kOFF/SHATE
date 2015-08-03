unit ERP.Admin.Module.UI.AdminProfileCross;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.ActnList, cxMaskEdit, cxLabel, cxTextEdit, Vcl.StdCtrls, Vcl.ExtCtrls, cxDropDownEdit,
  cxCheckBox, Data.DB, System.Actions, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator,
  cxGridCustomTableView, cxGridTableView, cxGridCustomView, cxClasses, cxGridLevel, cxGrid,
  ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;


type
  TTypeChild = (tcPflCrossModules=1, tcPflCrossFunctions, tcPflCrossUsers);
  TChildDescr = Record
    Kind: TTypeChild;
    caption: string;
  End;

  TfrmAdminProfileCross = class(TForm)
    cxLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    tblProfileCross: TcxGridTableView;
    qrQuery: TFDQuery;
    ActionList: TActionList;
    actSave: TAction;
    actCancel: TAction;
    ttTempTable: TsmFireDACTempTable;
    procedure FormShow(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FFDConnection: TFDConnection;
    FId_Profile: Integer;
    FDescr: TChildDescr;
    procedure Init;
    procedure LoadItems;
    function LoadGrid(const aQuerySQL: string; const aParam: array of Variant; aShadow: integer = 0): boolean;
    function Save: Boolean;
  public
    { Public declarations }

    constructor Create(aId_Profile: Integer; aChildDescr: TChildDescr; aConnection: TFDConnection; aOwner: TComponent); reintroduce;
    property Descr: TChildDescr read FDescr write FDescr;
  end;

var
  frmAdminProfileCross: TfrmAdminProfileCross;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;
resourcestring
  rspflConnectedModules = 'Подключенные модули';
  rspflAvailableFunctions = 'Доступ к функционалу';
  rspflUsersApplied = 'Применение к пользователям';

type
  TChildEntity = record
    Caption: string;
    Select: string;
    Update: string;
    Temptable: string;
  end;

const
  ARR_ADM_PFL: array[tcPflCrossModules..tcPflCrossUsers] of TChildEntity =
  ((Caption: rspflConnectedModules;
    Select: 'adm_pfl_sel_moduleaccess'; Update: 'adm_pfl_upd_moduleaccess'; Temptable: 'tblModuleProfileAccess'),
   (Caption: rspflAvailableFunctions;
    Select: 'adm_pfl_sel_funcaccess';   Update: 'adm_pfl_upd_funcaccess'; Temptable: 'tblFunctionsModuleProfileAccess'),
   (Caption: rspflUsersApplied;
    Select: 'adm_pfl_sel_usrlst';       Update: 'adm_pfl_upd_usrlst';       Temptable:  'tblProfileUsers')
   );

  COL_ID = 0;

{ TfrmAdminProfileCross }

procedure TfrmAdminProfileCross.actCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAdminProfileCross.actSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

constructor TfrmAdminProfileCross.Create(aId_Profile: integer; aChildDescr: TChildDescr; aConnection: TFDConnection; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FId_Profile := aId_Profile;
  FFDConnection := aConnection;
  FDescr := aChildDescr;

  Init();
end;

procedure TfrmAdminProfileCross.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmAdminProfileCross.FormShow(Sender: TObject);
begin
  LoadItems();
end;

procedure TfrmAdminProfileCross.Init;
begin
  if qrQuery.Active then
    qrQuery.Active := False;
  qrQuery.Connection := FFDConnection;
  ttTempTable.Connection := FFDConnection;
  Caption := Format('Профиль "%s": ' + ARR_ADM_PFL[FDescr.Kind].Caption,[FDescr.Caption]);
end;

function TfrmAdminProfileCross.LoadGrid(const aQuerySQL: string; const aParam: array of Variant;
  aShadow: integer): boolean;
var
  k, i, j: Integer;
  cxColumn: TcxGridColumn;
begin
  RESULT := False;

  qrQuery.SQL.Text := aQuerySQL;
  try
    for k := 0 to Length(aParam) - 1 do
      qrQuery.Params.Items[k].Value := aParam[k];

    qrQuery.Open();
    try
        if qrQuery.Fields.Count <= aShadow then exit;
        cxColumn:=nil;
        for k := 0 to qrQuery.Fields.Count - 1 do
         begin
          cxColumn := tblProfileCross.CreateColumn;
          cxColumn.Visible := not(k < aShadow);
          cxColumn.HeaderAlignmentHorz := taCenter;
          cxColumn.Caption := qrQuery.Fields.Fields[k].FieldName;
          cxColumn.Options.Editing := False;
          cxColumn.Width := 125;
         end;

        cxColumn.PropertiesClassName := 'TcxCheckBoxProperties'; //Last column must be boolean type
        cxColumn.Options.Editing := True;
        cxColumn.Width := 100;
        (cxColumn.Properties as TcxCheckBoxProperties).ValueChecked := 1;   //'true';
        (cxColumn.Properties as TcxCheckBoxProperties).ValueUnchecked := 0; //'false';
        (cxColumn.Properties as TcxCheckBoxProperties).NullStyle := nssUnchecked;

        if qrQuery.Eof then exit;

        tblProfileCross.BeginUpdate();
        try
          tblProfileCross.DataController.RecordCount := qrQuery.RecordCount;
          qrQuery.First;
          for i := 0 to qrQuery.RecordCount - 1 do
          begin
            for j := 0 to qrQuery.Fields.Count - 1  do
              tblProfileCross.DataController.Values[i,j] := qrQuery.Fields[j].Value;
            qrQuery.Next;
          end;
        finally
          tblProfileCross.EndUpdate;
        end;
        RESULT := qrQuery.Eof;
    finally
      qrQuery.Close();
    end;
  except on E: Exception do
    WinAPI.Windows.MessageBox(Handle,PChar(E.Message), '', MB_OK or MB_ICONERROR )
  end;
end;

procedure TfrmAdminProfileCross.LoadItems;
const MISS_ID_COLUMN = 1;
begin
  LoadGrid(ARR_ADM_PFL[FDescr.Kind].Select+' :Id_Profile', [FId_Profile], MISS_ID_COLUMN);
end;

function TfrmAdminProfileCross.Save: Boolean;
var
  k: Integer;
begin
  CreateSQLCursor();
  ttTempTable.TableName := ARR_ADM_PFL[FDescr.Kind].Temptable;
  ttTempTable.CreateTempTable();
  try
    for k := 0 to tblProfileCross.DataController.RecordCount - 1 do
      ttTempTable.InsertTempTable([TFieldValue.Create('Id', tblProfileCross.DataController.Values[k, COL_ID]),
                                   TFieldValue.Create('Applied', tblProfileCross.DataController.Values[k, tblProfileCross.ColumnCount - 1])]);
    Result := TERPQueryHelp.Open(FFDConnection, ARR_ADM_PFL[FDescr.Kind].Update + ' :Id_Profile', [TERPParamValue.Create(FId_Profile)]);
  finally
    ttTempTable.DropTempTable();
  end;
end;

end.
