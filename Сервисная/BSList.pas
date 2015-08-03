unit BSList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, Db, DBTables, Buttons, StdCtrls, Placemnt, Grids, DBGrids,
  ExtCtrls, Menus, ToolWin, ComCtrls, Mask, ImgList, SpeedBar,
  ActnList, ToolEdit, BSDlgFrm, inifiles, DBGridEh, AppUtils, BSColNast,
  BSForm, GridsEh, registry, AdvToolBar, AdvToolBarStylers;

type

  TPostProc = procedure of object;
  TEditFormClass = class of TForm;

  TBaseList = class(TBaseForm)
    GridPopupMenu: TPopupMenu;
    EditPopupItem: TMenuItem;
    AddPopupItem: TMenuItem;
    DelPopupItem: TMenuItem;
    CopyPopupItem: TMenuItem;
    ActionList: TActionList;
    ImageList: TImageList;
    ChooseAction: TAction;
    AddItemAction: TAction;
    DelAction: TAction;
    CopyAction: TAction;
    EditAction: TAction;
    CloseAction: TAction;
    ClearSearchAction: TAction;
    GridPanel1: TPanel;
    FiltAction: TAction;
    Grid1: TDBGridEh;
    ColNastrAction: TAction;
    AdvDockPanel1: TAdvDockPanel;
    ToolBar: TAdvToolBar;
    AddToolBtn: TAdvToolBarButton;
    DelToolBtn: TAdvToolBarButton;
    CopyToolBtn: TAdvToolBarButton;
    EditToolBtn: TAdvToolBarButton;
    SearchEd: TEdit;
    ClearSearchToolBtn: TAdvToolBarButton;
    FilterToolBtn: TAdvToolBarButton;
    ColNastrToolBtn: TAdvToolBarButton;
    ToolBarStyler: TAdvToolBarOfficeStyler;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure SearchEdChange(Sender: TObject);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure ActionExecute(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchEdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure GridPanel1Resize(Sender: TObject);
    procedure GridTitleBtnClick(Sender: TObject; ACol: Integer;
      Column: TColumnEh);
    procedure GridColWidthsChanged(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NoAppend: boolean;          // флаг запрета добавления / удаления
    NoModify: boolean;          // флаг запрета редактирование
    MenuMode: boolean;          // флаг режима меню
    ResizeFieldName: string;    // имя колонки с автоматически подстраиваемым
                                // размером
    CloseByEscape: boolean;     // флаг: закрывать по ESC
    List_Sep: string;
    SearchFiltPat: TStringList; // Шаблон фильтра
    EditFormClass: TEditFormClass;
    Grid: TDBGridEh;
    DelItemMess: string;
    DelItemsMess: string;
    NotFoundMess: string;
    CopyFlag: boolean;
    StartSearchText: string;
    procedure SetFiltPattern;
    procedure AddItem;                               virtual;
    procedure DelItem;                               virtual;
    procedure CopyItem;                              virtual;
    procedure EditItem;                              virtual;
    procedure ChooseItem;                            virtual;
    function  DoSearch(Text: string): boolean;       virtual;
    procedure DoSort(ColName: string);               virtual;
    procedure SetFilter;                             virtual;
    procedure SortMark(ColName: string);
    procedure ResizeGrid;
    function ListSepChar(s: string): boolean;
  end;

resourcestring
  BSDelItemMess       = 'Удалить запись?';
  BSDelItemsMess      = 'Удалить выделенные записи?';
  BSNotFoundMess      = 'Отсутствует в базе данных!';

implementation

{$R *.DFM}

uses BSStrUt;

procedure TBaseList.FormCreate(Sender: TObject);
var
  reg: TRegistryIniFile;
begin
  List_Sep          := '/\ ';
  NoAppend          := False;
  NoModify          := False;
  MenuMode          := False;
  ResizeFieldName   := '';
  CloseByEscape     := True;
  EditFormClass     := nil;
  SearchFiltPat     := TStringList.Create;
  Grid              := Grid1;
  DelItemMess       := BSDelItemMess;
  DelItemsMess      := BSDelItemsMess;
  NotFoundMess      := BSNotFoundMess;
  CopyFlag          := False;
  reg := TRegistryIniFile.Create('Software\' +
                  ChangeFileExt(ExtractFileName(Application.ExeName),''));
  Grid1.RestoreGridLayout(reg, Name, [grpColIndexEh,grpColWidthsEh,
                                      grpColVisibleEh, grpRowHeightEh]);
  reg.Free;
  StartSearchText   := '';
end;

procedure TBaseList.FormShow(Sender: TObject);
begin
  if NoModify then
    NoAppend := True;
  AddItemAction.Visible := not NoAppend;
  DelAction.Visible     := not NoAppend;
  CopyAction.Visible    := not NoAppend;
  EditAction.Visible    := not NoModify;
  SearchEd.Clear;
  Grid.SetFocus;
  ResizeGrid;
  Application.ProcessMessages;
  if StartSearchText <> '' then
    SearchEd.Text := StartSearchText;
end;

procedure TBaseList.GridDblClick(Sender: TObject);
begin
  ActionExecute(ChooseAction)
end;

procedure TBaseList.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  len: integer;
begin
  if Key = VK_RETURN then
  begin
    if Shift = [ssCtrl] then
      ActionExecute(EditAction)
    else
      ActionExecute(ChooseAction)
  end
  else if Key = VK_ESCAPE then
  begin
    if SearchEd.Text <> '' then
      SearchEd.Clear
    else if CloseByEscape then
      ActionExecute(CloseAction)
  end
  else if Key = VK_BACK then
  begin
    len := Length(SearchEd.Text) - 1;
    SearchEd.Text := Copy(SearchEd.Text, 1, len);
    SearchEd.SelStart := len;
  end
  else if Key = VK_DELETE then
    ActionExecute(DelAction)
end;

procedure TBaseList.GridKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if ( Key >= ' ' ) and ( Key <= 'я' ) and ( Ord(Key) <> 127 )then
  begin
    SearchEd.Text := SearchEd.Text + Key;
  end;
end;

procedure TBaseList.SearchEdChange(Sender: TObject);
begin
  inherited;
  if SearchEd.Text <> '' then
  begin
    //Grid.Multiselect := False;
    if DoSearch(SearchEd.Text) then
    begin
      if not FiltAction.Checked then
        Grid.SetFocus
    end
    else if ActiveControl <> SearchEd then
    begin
      SearchEd.SetFocus;
      SearchEd.SelStart := Length(SearchEd.Text);
    end;
    //Grid.Multiselect := True;
  end;
  SetFiltPattern;
  if FiltAction.Checked then
  begin
    SetFilter;
    Grid.Refresh;
  end;
end;

procedure TBaseList.SearchEdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key in [VK_RETURN, VK_F2]) and (SearchEd.Text <> '') then
  begin
    if DoSearch(SearchEd.Text) then
      Grid.SetFocus
    else
      MessageDlg(NotFoundMess, mtError, [ mbOk ], 0);
  end
  else if Key = VK_ESCAPE then
  begin
    SearchEd.Clear;
    Grid.SetFocus
  end
end;


procedure TBaseList.ActionExecute(Sender: TObject);
var
  i: integer;
begin
  if Sender = FiltAction then
  begin
    FiltAction.Checked := not FiltAction.Checked;
    SetFilter;
    Grid.Refresh;
  end
  else
  begin
    if Sender = ClearSearchAction then
      SearchEd.Clear
    else if Sender = ChooseAction then
    begin
      //if not FiltAction.Checked then
      SearchEd.Clear;
      if MenuMode then
        ChooseItem
      else if not NoModify then
        EditItem;
    end
    else if (Sender = AddItemAction) and (not NoAppend) then
    begin
      //if not FiltAction.Checked then
        SearchEd.Clear;
      //Grid.Multiselect := False;
      Grid.SetFocus;
      AddItem;
      EditItem;
      //Grid.Multiselect := True;
    end
    else if (Sender = DelAction) and (ActiveControl <> SearchEd)  and
                                     (not NoAppend)then
    begin
      if not FiltAction.Checked then
        SearchEd.Clear;
      DelItem
    end
    else if (Sender = CopyAction)  and (not NoAppend) then
    begin
      //if not FiltAction.Checked then
        SearchEd.Clear;
      //Grid.Multiselect := False;
      Grid.SetFocus;
      CopyItem;
      CopyFlag := True;
      EditItem;
      CopyFlag := False;
      //Grid.Multiselect := True;
    end
    else if (Sender = EditAction) and (not NoModify)  then
    begin
      //if not FiltAction.Checked then
        SearchEd.Clear;
      //Grid.Multiselect := False;
      EditItem;
      //Grid.Multiselect := True;
    end
    else if Sender = CloseAction then
    begin
      ModalResult := mrAbort;
      Close
    end
    else if Sender = ColNastrAction then
    begin
      with TColNastr.Create(Application) do
      begin
        ListBox.Items.Clear;
        for i := 0 to Grid1.Columns.Count - 1 do
        begin
          if Grid1.Columns[i].Title.Caption = 'Ц' then
            ListBox.Items.Add('Пометка')
          else
            ListBox.Items.Add(Grid1.Columns[i].Title.Caption);
          ListBox.Checked[i] := Grid1.Columns[i].Visible;
        end;
        if ShowModal = mrOk then
        begin
          for i := 0 to Grid1.Columns.Count - 1 do
            Grid1.Columns[i].Visible := ListBox.Checked[i];
        end;
        Free;
      end
    end
  end;
end;


procedure TBaseList.AddItem;
begin
  //
end;

procedure TBaseList.DelItem;
var
  i: integer;
begin
  if Grid.SelectedRows.Count > 1 then
  begin
    if MessageDlg(DelItemsMess, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      for i := 0 to Grid.SelectedRows.Count - 1 do
      with Grid.DataSource.DataSet do
      begin
        if BookmarkValid(Pointer(Grid.SelectedRows.Items[i])) then
          GotoBookMark(Pointer(Grid.SelectedRows.Items[i]));
        Delete;
      end;
    end
  end
  else
  with Grid.DataSource.DataSet do
  begin
    if (not IsEmpty) and
      (MessageDlg(DelItemMess, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      Delete;
  end;
end;

procedure TBaseList.CopyItem;
begin
  //
end;

procedure TBaseList.EditItem;
begin
  if (EditFormClass <> nil) and (not Grid.DataSource.DataSet.IsEmpty) then
  begin
    with (EditFormClass.Create(Application) as TDialogForm) do
    begin
      DataSource := Grid.DataSource;
      ParentForm := Self;
      ShowModal;
      Free;
    end;
  end;
  Grid.DataSource.DataSet.Refresh;
  if Visible then
    Grid.SetFocus;
end;

procedure TBaseList.ChooseItem;
begin
  if (not Grid.DataSource.DataSet.IsEmpty) then
    ModalResult := mrOk;
end;

function TBaseList.DoSearch(Text: string): boolean;
begin
  Result := False;
end;

procedure TBaseList.DoSort(ColName: string);
begin
  //
end;

procedure TBaseList.ResizeGrid;
var
  i, len, p, x: integer;
begin
  if ResizeFieldName = '' then
    exit;
  p := -1;
  len := 0;
  for i := 0 to Grid.Columns.Count - 1  do
  begin
    if Grid.Columns[i].Visible then
      len := len + Grid.Columns[i].Width;
    if UpperCase(Grid.Columns[i].FieldName) =
       UpperCase(ResizeFieldName) then
      p := i;
  end;
  if dgIndicator in Grid.Options then
    x := 17
  else
    x := 10;
  if p >= 0 then
    Grid.Columns[p].Width :=
         Grid.Columns[p].Width + Grid.ClientWidth - len - x;
end;


procedure TBaseList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F2) and (Shift = []) then
    SearchEd.SetFocus;
end;

procedure TBaseList.FormDestroy(Sender: TObject);
var
  reg: TRegistryIniFile;
begin
  SearchFiltPat.Free;
  reg := TRegistryIniFile.Create('Software\' +
                  ChangeFileExt(ExtractFileName(Application.ExeName),''));
  Grid1.SaveGridLayout(reg, Name);
  reg.Free;
end;

procedure TBaseList.SetFilter;
begin
  //
end;


procedure TBaseList.SetFiltPattern;
var
  str: string;
begin
  str := AnsiUpperCase(SearchEd.Text);
  if (str = '') or ((str[1] >= '0') and (str[1] <= '9')) then
    SearchFiltPat.Text := ''
  else
  begin
    if not ListSepChar(str) then
      str := '\' + str;
    SearchFiltPat.Text := StrLstToText(PChar(str), PChar(List_Sep));
  end
end;

procedure TBaseList.GridPanel1Resize(Sender: TObject);
begin
  ResizeGrid;
end;

procedure TBaseList.SortMark(ColName: string);
var
  i: integer;
begin
  for i := 0 to Grid.Columns.Count - 1  do
  begin
    if UpperCase(Grid.Columns[i].FieldName) =
       UpperCase(ColName) then
      Grid.Columns[i].Title.Font.Style := [fsBold]
    else
      Grid.Columns[i].Title.Font.Style := [];
  end;
end;



procedure TBaseList.GridTitleBtnClick(Sender: TObject; ACol: Integer;
  Column: TColumnEh);
begin
  DoSort(Column.Field.FieldName);
end;

procedure TBaseList.GridColWidthsChanged(Sender: TObject);
begin
  ResizeGrid;
end;

function TBaseList.ListSepChar(s: string): boolean;
begin
  if s = '' then
    Result := False
  else
    Result := (Pos(Copy(s, 1, 1), List_Sep) > 0);
end;

end.
