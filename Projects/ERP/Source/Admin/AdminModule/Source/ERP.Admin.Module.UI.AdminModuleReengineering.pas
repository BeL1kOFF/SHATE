unit ERP.Admin.Module.UI.AdminModuleReengineering;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxButtonEdit,
  System.Actions, Vcl.ActnList, FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet;

type
  TfrmAdminModuleReengineering = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnCreate: TButton;
    cxLabel1: TcxLabel;
    edtProject: TcxTextEdit;
    cxLabel2: TcxLabel;
    edtUnit: TcxTextEdit;
    cxLabel3: TcxLabel;
    edtForm: TcxTextEdit;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cmbTypeDB: TcxComboBox;
    cxLabel6: TcxLabel;
    edtPage: TcxTextEdit;
    cxLabel7: TcxLabel;
    edtGroup: TcxTextEdit;
    cxLabel8: TcxLabel;
    edtName: TcxTextEdit;
    cxLabel9: TcxLabel;
    cmbTypeModule: TcxComboBox;
    edtGUIDModule: TcxButtonEdit;
    ActionList: TActionList;
    acCreate: TAction;
    acCancel: TAction;
    qrQuery: TFDQuery;
    cxLabel10: TcxLabel;
    edtGUIDProject: TcxButtonEdit;
    procedure acCreateExecute(Sender: TObject);
    procedure acCreateUpdate(Sender: TObject);
    procedure edtGUIDPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure acCancelExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtGUIDProjectPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
  private
    FConnection: TFDConnection;
    procedure ClearCmbTypeDB;
    procedure ClearCmbTypeModule;
    procedure FillTypeDB;
    procedure FillTypeModule;
    procedure Init;
  public
    constructor Create(aOwner: TComponent; aConnection: TFDConnection); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  Winapi.ShlObj,
  System.IOUtils,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

type
  // Запись ресурса
  TResTemplateRec = record
    ResName: string;    //Имя ресурса
    FileName: string;   //Файл лежащий в ресурсе
    IsReplace: Boolean; //Флаг: требуются ли замены в тексте файла.
  end;

  // Запись шаблона и замены
  TPatternTemplateRec = record
    Pattern: string; //Шаблон, который надо заменить (Обязательно проверить чтобы был уникален для проверки и не встречался в других файлах, иначе парсер заменит везде)
    Obj: string;     //Компонент, откуда брать текст для замены
    Param: Byte;     //Параметр. Для cmbTypeModule определяет какое поле класса взять для замены.
  end;

  TMouleType = class
    ConstName: string;
    Path: string;
  end;

const
  RESOURCE_TEMPLATE:
    array[0..7] of TResTemplateRec = ((ResName: 'Template_DPK';   FileName: 'TemplatePackage.dpk';         IsReplace: True),
                                      (ResName: 'Template_DPROJ'; FileName: 'TemplatePackage.dproj';       IsReplace: True),
                                      (ResName: 'Template_RES';   FileName: 'TemplatePackage.res';         IsReplace: False),
                                      (ResName: 'Template_IMG16'; FileName: 'Img\TemplatePackage16.ico';   IsReplace: False),
                                      (ResName: 'Template_IMG32'; FileName: 'Img\TemplatePackage32.ico';   IsReplace: False),
                                      (ResName: 'Template_RC';    FileName: 'Resource\Icon.rc';            IsReplace: True),
                                      (ResName: 'Template_DFM';   FileName: 'Sources\TemplateForm.dfm';    IsReplace: True),
                                      (ResName: 'Template_PAS';   FileName: 'Sources\TemplateForm.pas';    IsReplace: True));

  PATTERN_TEMPLATE:
    array[0..10] of TPatternTemplateRec = ((Pattern: 'TemplatePackage';                        Obj: 'edtProject';     Param: 0),
                                           (Pattern: 'TemplateForm';                           Obj: 'edtUnit';        Param: 0),
                                           (Pattern: 'frmTemplate';                            Obj: 'edtForm';        Param: 0),
                                           (Pattern: 'Новый модуль';                           Obj: 'edtName';        Param: 0),
                                           (Pattern: 'Группа на вкладке где будет модуль';     Obj: 'edtGroup';       Param: 0),
                                           (Pattern: 'Вкладка';                                Obj: 'edtPage';        Param: 0),
                                           (Pattern: '{00000000-0000-0000-0000-000000000000}'; Obj: 'edtGUIDModule';  Param: 0),
                                           (Pattern: 'MODULE_TYPEDB_PATTERN';                  Obj: 'cmbTypeDB';      Param: 0),
                                           (Pattern: 'MODULE_TYPEMODULE_PATTERN';              Obj: 'cmbTypeModule';  Param: 1),
                                           (Pattern: '{11111111-1111-1111-1111-111111111111}'; Obj: 'edtGUIDProject'; Param: 0),
                                           (Pattern: 'Modules\';                               Obj: 'cmbTypeModule';  Param: 2));

  RES_TYPE = 'RCDATA';

  PROC_ADM_MDL_SEL_RITYPEDB = 'adm_mdl_sel_ritypedb';
  FLD_TDB_CONSTNAME = 'ConstName';
  FLD_TDB_NAME = 'Name';

  PROC_ADM_MDL_SEL_RITYPEMODULE = 'adm_mdl_sel_ritypemodule';
  FLD_TM_CONSTNAME = 'ConstName';
  FLD_TM_NAME = 'Name';
  FLD_TM_PATH = 'Path';

resourcestring
  RsOpenDialogSelectDir = 'Выберите директорию';
  RsTemplateSuccess = 'Шаблон модуля успешно создан';
  RsMessage = 'Сообщение';

procedure TfrmAdminModuleReengineering.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAdminModuleReengineering.acCreateExecute(Sender: TObject);
var
  ItemIDList: PItemIDList;
  BrowseInfo: TBrowseInfo;
  DisplayName: string;
  Path: string;
  k: Integer;

  function GetTextControl(const aName: string; aParam: Byte): string;
  var
    aControl: TComponent;
  begin
    aControl := FindComponent(aName);
    if aControl.ClassType = TcxTextEdit then
      Result := (aControl as TcxTextEdit).Text
    else
      if aControl.ClassType = TcxButtonEdit then
        Result := (aControl as TcxButtonEdit).Text
      else
        if aControl.ClassType = TcxComboBox then
          if aControl.Name = 'cmbTypeDB' then
            Result := PChar((aControl as TcxComboBox).Properties.Items.Objects[(aControl as TcxComboBox).ItemIndex])
          else
            if aControl.Name = 'cmbTypeModule' then
              case aParam of
                1:
                  Result := TMouleType((aControl as TcxComboBox).Properties.Items.Objects[(aControl as TcxComboBox).ItemIndex]).ConstName;
                2:
                  Result := TMouleType((aControl as TcxComboBox).Properties.Items.Objects[(aControl as TcxComboBox).ItemIndex]).Path;
                else
                  Result := '';
              end
            else
              Result := ''
        else
          Result := '';
  end;

  procedure ExtractRes(const aResTemplate: TResTemplateRec; const aResType, aPath: string);
  var
    Res: TResourceStream;
    tmpStr: TStringList;
    i: Integer;
    aOutFile: string;
  begin
    Res := TResourceStream.Create(HInstance, aResTemplate.ResName, RT_RCDATA);
    try
      aOutFile := aResTemplate.FileName;
      for i := Low(PATTERN_TEMPLATE) to High(PATTERN_TEMPLATE) do
        aOutFile :=
          StringReplace(aOutFile,
                        PATTERN_TEMPLATE[i].Pattern,
                        GetTextControl(PATTERN_TEMPLATE[i].Obj, PATTERN_TEMPLATE[i].Param),
                        [rfReplaceAll, rfIgnoreCase]);
      if aResTemplate.IsReplace then
      begin
        tmpStr := TStringList.Create();
        try
          tmpStr.LoadFromStream(Res);
          for i := Low(PATTERN_TEMPLATE) to High(PATTERN_TEMPLATE) do
            tmpStr.Text :=
              StringReplace(tmpStr.Text,
                            PATTERN_TEMPLATE[i].Pattern,
                            GetTextControl(PATTERN_TEMPLATE[i].Obj, PATTERN_TEMPLATE[i].Param),
                            [rfReplaceAll, rfIgnoreCase]);
          tmpStr.SaveToFile(aPath + aOutFile);
        finally
          tmpStr.Free();
        end;
      end
      else
        Res.SaveToFile(aPath + aOutFile);
    finally
      Res.Free();
    end;
  end;

begin
  SetLength(DisplayName, MAX_PATH + 1);
  ZeroMemory(@BrowseInfo, SizeOf(TBrowseInfo));
  BrowseInfo.hwndOwner := Handle;
  BrowseInfo.pszDisplayName := PChar(DisplayName);
  BrowseInfo.lpszTitle := PChar(RsOpenDialogSelectDir);
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  ItemIDList := SHBrowseForFolder(BrowseInfo);
  if ItemIDList <> nil then
  begin
    SetLength(Path, MAX_PATH + 1);
    SHGetPathFromIDList(ItemIDList, PChar(Path));
    GlobalFreePtr(ItemIDList);
    Path := IncludeTrailingPathDelimiter(Copy(Path, 1, Pos(#0, Path) - 1));
    TDirectory.CreateDirectory(Path + 'Img');
    TDirectory.CreateDirectory(Path + 'Resource');
    TDirectory.CreateDirectory(Path + 'Sources');
    for k := Low(RESOURCE_TEMPLATE) to High(RESOURCE_TEMPLATE) do
      ExtractRes(RESOURCE_TEMPLATE[k], RES_TYPE, Path);
    Application.MessageBox(PChar(RsTemplateSuccess), PChar(RsMessage), MB_OK or MB_ICONINFORMATION);
    Close();
  end;
end;

procedure TfrmAdminModuleReengineering.acCreateUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (edtProject.Text <> '') and (edtUnit.Text <> '') and (edtForm.Text <> '') and
    (edtPage.Text <> '') and (edtGroup.Text <> '') and (edtName.Text <> '') and
    (edtGUIDModule.Text <> '') and (cmbTypeDB.ItemIndex <> -1) and (cmbTypeModule.ItemIndex <> -1) and
    (edtGUIDProject.Text <> '');
end;

procedure TfrmAdminModuleReengineering.ClearCmbTypeDB;
var
  k: Integer;
begin
  for k := 0 to cmbTypeDB.Properties.Items.Count - 1 do
    StrDispose(PChar(cmbTypeDB.Properties.Items.Objects[k]));
  cmbTypeDB.Properties.Items.Clear();
end;

procedure TfrmAdminModuleReengineering.ClearCmbTypeModule;
var
  k: Integer;
begin
  for k := 0 to cmbTypeModule.Properties.Items.Count - 1 do
    TMouleType(cmbTypeModule.Properties.Items.Objects[k]).Free();
  cmbTypeModule.Properties.Items.Clear();
end;

constructor TfrmAdminModuleReengineering.Create(aOwner: TComponent; aConnection: TFDConnection);
begin
  inherited Create(aOwner);
  FConnection := aConnection;
end;

procedure TfrmAdminModuleReengineering.edtGUIDProjectPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
  GUID: TGUID;
begin
  CreateGUID(GUID);
  (Sender as TcxButtonEdit).Text := GUIDToString(GUID);
end;

procedure TfrmAdminModuleReengineering.edtGUIDPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
  GUID: TGUID;
begin
  CreateGUID(GUID);
  (Sender as TcxButtonEdit).Text := GUIDToString(GUID);
end;

procedure TfrmAdminModuleReengineering.FillTypeDB;
var
  k: Integer;
  p: PChar;
begin
  ClearCmbTypeDB();
  qrQuery.SQL.Text := PROC_ADM_MDL_SEL_RITYPEDB;
  try
    qrQuery.Open();
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      p := StrNew(PChar(qrQuery.FieldByName(FLD_TDB_CONSTNAME).AsString));
      cmbTypeDB.Properties.Items.AddObject(qrQuery.FieldByName(FLD_TDB_NAME).AsString, TObject(p));
      qrQuery.Next();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminModuleReengineering.FillTypeModule;
var
  k: Integer;
  ModuleType: TMouleType;
begin
  ClearCmbTypeModule();
  qrQuery.SQL.Text := PROC_ADM_MDL_SEL_RITYPEMODULE;
  try
    qrQuery.Open();
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      ModuleType := TMouleType.Create();
      ModuleType.ConstName := qrQuery.FieldByName(FLD_TM_CONSTNAME).AsString;
      ModuleType.Path := qrQuery.FieldByName(FLD_TM_PATH).AsString;
      cmbTypeModule.Properties.Items.AddObject(qrQuery.FieldByName(FLD_TM_NAME).AsString, ModuleType);
      qrQuery.Next();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminModuleReengineering.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClearCmbTypeDB();
  ClearCmbTypeModule();
end;

procedure TfrmAdminModuleReengineering.FormShow(Sender: TObject);
begin
  Init();
end;

procedure TfrmAdminModuleReengineering.Init;
begin
  qrQuery.Connection := FConnection;
  FillTypeDB();
  FillTypeModule();
  edtProject.SetFocus();
end;

end.
