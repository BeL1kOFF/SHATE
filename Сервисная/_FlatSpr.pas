unit _FlatSpr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Placemnt, ImgList, ActnList, Menus, StdCtrls, ComCtrls, ToolWin,
  Grids, DBGrids, ExtCtrls, Db, DBISAMTb, inifiles,
  DBGridEh, Variants, ToolEdit, BSList, BSDbiUt, GridsEh, JvComponentBase,
  JvFormPlacement, JvToolEdit, AdvToolBar, AdvToolBarStylers;

type
  TFlatSpr = class(TBaseList)
    Table: TDBISAMTable;
    DataSource: TDataSource;
    NvgTable: TDBISAMTable;
    FormStorage: TJvFormStorage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Func: string;
    NewItemDescr: string;
    IdField,
    CodeField,
    NameField,
    DescrField,
    SortField: string;
    procedure AddItem;                               override;
    procedure CopyItem;                              override;
    procedure SortKey(Key: string);                  virtual;
    procedure DoSort(ColName: string);               override;
    function  DoSearch(Text: string): boolean;       override;
    function  SearchByCode(Text: string): Boolean;   virtual;
    function  SearchByName(Text: string): Boolean;   virtual;
    procedure SetFilter;                             override;
    procedure TableFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    function  GoToKey(Id: Integer): Boolean;         virtual;
    function  ExactFound(Text: string): Boolean;     virtual;
    function  GetDescr(id: integer): string;         virtual;
  end;

  TFlatSprClass = class of TFlatSpr;


var
  FlatSpr: TFlatSpr;

function SprComboEdit(FlatSprClass: TFlatSprClass;
                      ComboEd: TJvComboEdit; input_flag: boolean): boolean;
function SprComboEditButton(SprClass: TFlatSprClass;
                                 ComboEd: TJvComboEdit): boolean;
function SprComboEditExit(SprClass: TFlatSprClass;
                          ComboEd: TJvComboEdit): boolean;

implementation

uses BSStrUt, _Main;

{$R *.DFM}

//------------- Создание справочника -----------------------
procedure TFlatSpr.FormCreate(Sender: TObject);
begin
  inherited;
  NewItemDescr := '';
  IdField      := 'Id';
  CodeField    := '';
  NameField    := '';
  SortField    := '';
  DescrField   := '';
  NvgTable.TableName := Table.TableName;
  NvgTable.Open;
  Table.Open;
  MenuMode := True;
  MenuMode := False;
end;

//------------- Показ формы -------------------------------
procedure TFlatSpr.FormShow(Sender: TObject);
begin
  inherited;
  if SortField = '' then
    SortField := CodeField;
  if DescrField = '' then
    DescrField := NameField;
  if SortField <> '' then
    SortKey(SortField);
  if not MenuMode then
    Table.First;
end;

//------------- Добавление элемента ------------------------
procedure TFlatSpr.AddItem;
var
  NewKod: Integer;
  OldKey: string;
begin
  inherited;

  NewKod := 0;
  with Table do
  begin
    DisableControls;
    NvgTable.Refresh;
    NvgTable.Last;
    if (CodeField <> '') and (FieldByName(CodeField).DataType in
                              [ftSmallInt, ftInteger]) then
    begin
      Filtered := False;
      OldKey := IndexName;
      IndexName := CodeField;
      Last;
      NewKod := FieldByName(CodeField).AsInteger + 1;
      SortKey(OldKey);
      Filtered := True;
    end;
    Append;
    if (CodeField <> '') and (FieldByName(CodeField).DataType in
                              [ftSmallInt, ftInteger]) then
      FieldByName(CodeField).Value := NewKod;
    if NameField <> '' then
      FieldByName(NameField).Value := NewItemDescr;
    if FindField('Active') <> nil then
      FieldByName('Active').Value := True;
    Post;
    Edit;
    EnableControls;
  end;
end;

//------------- Копирование элемента ------------------------
procedure TFlatSpr.CopyItem;
var
  aField : Variant;
  i      : Integer;
begin
  with Table do
  begin
    aField := VarArrayCreate([0, Fieldcount - 1], VarVariant);
    for i := 0 to (Fieldcount - 1) do
      aField[i] := Fields[i].Value;
    AddItem;
    for i := 0 to (Fieldcount - 1) do
      if (Fields[i].FieldName <> IdField) and
         (Fields[i].FieldName <> CodeField) then
       Fields[i].Value := aField[i]
  end
end;

//---------------- Установка ключа сортировки ----------------
procedure TFlatSpr.SortKey(Key: string);
var
  id: integer;
begin
  with Table do
  begin
    id := FieldByName(IdField).AsInteger;
    IndexName := Key;
    NvgTable.Refresh;
    if NvgTable.FindKey([id]) then
    try
      GotoCurrent(NvgTable);
    except
      First;
    end;
  end;
  SortMark(Key);
end;

//------------- Сортировка справочника -----------------------
procedure TFlatSpr.DoSort(ColName: string);
begin
  SortKey(ColName)
end;

//------------- Поиск по тексту ------------------------
function TFlatSpr.DoSearch(Text: string): boolean;
var
  FirstChar: string[1];
begin
  Result := Text <> '';
  if Result then
  begin
    with Table do
    begin
      FirstChar := Copy(Text, 1, 1);
      if (CodeField <> '') and (FirstChar >= '0') and (FirstChar <= '9') then
        Result := SearchByCode(Text)
      else
        Result := SearchByName(Text);
    end
  end
end;

//------------- Поиск по коду ------------------------
function TFlatSpr.SearchByCode(Text: string): Boolean;
begin
  if CodeField = '' then
  begin
    Result := False;
    exit;
  end;
  if Table.IndexName <> CodeField then
    SortKey(CodeField);
  if (CodeField <> '') and (Table.FieldByName(CodeField).DataType in
                              [ftSmallInt, ftInteger]) then
    Result := Table.FindKey([StrInt(Text)])
  else if (Table.FieldByName(CodeField).DataType in [ftString]) then
    Result := Table.Locate(CodeField, Text, [loPartialKey])
  else
    Result := False;
end;


//------------- Поиск по наименованию ------------------------
function TFlatSpr.SearchByName(Text: string): Boolean;
begin
  if NameField = '' then
  begin
    Result := False;
    exit;
  end;
  if (Table.IndexName <> NameField) and FindIndex(Table, NameField) then
    SortKey(NameField);
  Result := DbSearchLike(Table, NameField, Text, List_Sep);
end;


//------------- Установка фильтра ------------------------
procedure TFlatSpr.SetFilter;
var
  rn: Longint;
begin
  inherited;
  with Table do
  begin
    rn := RecNo;
    if FiltAction.Checked then
    begin
      OnFilterRecord := TableFilterRecord;
      Filtered := True
    end
    else
    begin
      OnFilterRecord := nil;
      Filtered := False
    end;
    RecNo := rn;
    Refresh;
  end;
end;

//------------- Процедура фильтрации ------------------------
procedure TFlatSpr.TableFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  inherited;
  Accept := StrLikeLst(AnsiUpperCase(DataSet.FieldByName(NameField).AsString),
                       SearchFiltPat)
end;


//------------- Перейти по идентификатору --------------------
function TFlatSpr.GoToKey(Id: Integer): Boolean;
begin
  Result := False;
  with Table do
  begin
    DisableControls;
    NvgTable.Refresh;
    if NvgTable.FindKey([Id]) then
    begin
      try
        GotoCurrent(NvgTable);
        Result := True;
      except
        First
      end;
    end;
    EnableControls;
  end
end;

//------------- Уничтожение формы ----------------------------
procedure TFlatSpr.FormDestroy(Sender: TObject);
begin
  inherited;
  Table.Close;
  NvgTable.Close;
end;


//--------- Поиск по шаблону --------------------------------
function TFlatSpr.ExactFound(Text: string): Boolean;
var
  FirstChar: string[1];
begin
  with Table do
  begin
    if Trim(Text) <> '' then
    begin
      Result := False;
      FirstChar := Copy(Text, 1, 1);
      if (FirstChar >= '0') and (FirstChar <= '9') then
        Result := Locate(CodeField, Text, [])
      else
      begin
        if not ListSepChar(Text) then
          Text := '\' + Text;
        if DbSearchLike(Table, NameField, Text, List_Sep) then
          Result := not DbSearchLike(Table, NameField, Text, List_Sep, False);
      end
    end
    else
      Result := True;
  end
end;

//------------- получить описание ---------------------------

function TFlatSpr.GetDescr(id: integer): string;
var
  fld: string;
begin
  if DescrField <> '' then
    fld := DescrField
  else
    fld := NameField;
  with Table do
  begin
    if (FieldByName(IdField).AsInteger = id) or Locate(IdField, id, []) then
      Result := FieldByName(fld).AsString
    else
      Result := '';
  end
end;

//-------------- Отработка в ComboEdit -----------------------
function SprComboEdit(FlatSprClass: TFlatSprClass;
                      ComboEd: TJvComboEdit; input_flag: boolean): boolean;
begin
  Result := False;
  with FlatSprClass.Create(Application) do
  begin
    MenuMode := True;
    if input_flag then
      StartSearchText := ComboEd.Text
    else
      GotoKey(ComboEd.Tag);
    if (input_flag and ExactFound(ComboEd.Text)) or (ShowModal = mrOk) then
    begin
      if input_flag and (Trim(ComboEd.Text) = '') then
        ComboEd.Tag  := 0
      else
      begin
        ComboEd.Tag  := Table.FieldByName(IdField).AsInteger;
        ComboEd.Text := GetDescr(ComboEd.Tag);
      end;
      Result := True;
    end
    else if input_flag then
      ComboEd.Text := GetDescr(ComboEd.Tag);
    Free;
  end
end;

function SprComboEditButton(SprClass: TFlatSprClass;
                            ComboEd: TJvComboEdit): boolean;
begin
  Result := False;
  with SprClass.Create(Application) do
  begin
    MenuMode := True;
    GotoKey(ComboEd.Tag);
    if ShowModal = mrOk then
    begin
      ComboEd.Tag  := Table.FieldByName(IdField).AsInteger;
      ComboEd.Text := GetDescr(ComboEd.Tag);
      Result := True;
    end;
    Free;
  end
end;

function SprComboEditExit(SprClass: TFlatSprClass;
                          ComboEd: TJvComboEdit): boolean;
begin
  Result := False;
  with SprClass.Create(Application) do
  begin
    MenuMode := True;
    StartSearchText := ComboEd.Text;
    if ExactFound(ComboEd.Text) or (ShowModal = mrOk) then
    begin
      if Trim(ComboEd.Text) = '' then
        ComboEd.Tag  := 0
      else
      begin
        ComboEd.Tag  := Table.FieldByName(IdField).AsInteger;
        ComboEd.Text := GetDescr(ComboEd.Tag);
      end;
      Result := True;
    end;
    ComboEd.Text := GetDescr(ComboEd.Tag);
    Free;
  end
end;

end.
