unit ERP.Admin.UI.AdminMenuDesigner;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess, System.Actions, Vcl.ActnList, Vcl.ImgList, cxGraphics, dxBar, cxClasses,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, dxtree, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxCustomData,
  cxStyles, cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer, cxContainer, cxEdit, cxListView, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  ShateM.Components.TCustomTempTable, ShateM.Components.TFireDACTempTable;

type
  TfrmAdminMenuDesigner = class(TERPCustomForm)
    ActionList: TActionList;
    dxBarManager: TdxBarManager;
    acPageAdd: TAction;
    acPageDelete: TAction;
    ilTreeVew: TcxImageList;
    dxBarManagerBar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    acGroupAdd: TAction;
    acGroupDelete: TAction;
    qrQuery: TFDQuery;
    ilModules32: TcxImageList;
    Panel3: TPanel;
    tvMenu: TdxTreeView;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    lvModules: TcxListView;
    dxBarLargeButton5: TdxBarLargeButton;
    dxBarLargeButton6: TdxBarLargeButton;
    acRefresh: TAction;
    acSave: TAction;
    ilImageList: TcxImageList;
    ttMenu: TsmFireDACTempTable;
    procedure acPageAddExecute(Sender: TObject);
    procedure acPageAddUpdate(Sender: TObject);
    procedure acPageDeleteUpdate(Sender: TObject);
    procedure acGroupAddUpdate(Sender: TObject);
    procedure acGroupDeleteUpdate(Sender: TObject);
    procedure acPageDeleteExecute(Sender: TObject);
    procedure tvMenuKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure acGroupAddExecute(Sender: TObject);
    procedure acGroupDeleteExecute(Sender: TObject);
    procedure tvMenuDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure tvMenuEndDragTreeNode(Destination, Source: TTreeNode; var AttachMode: TNodeAttachMode);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvModulesEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure lvModulesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure tvMenuEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure acSaveExecute(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure tvMenuDeletion(Sender: TObject; Node: TTreeNode);
  private
    procedure AddPage;
    procedure AddGroup;
    procedure AssignImage;
    procedure ClearListView;
    procedure RefreshMenu;
    procedure RefreshModules;
  public
    constructor Create(aERPClientData: IERPClientData); reintroduce;
  end;

function CreateForm(aERPClientData: IERPClientData): THandle; stdcall;
procedure RegisterAccess(aModuleAccess: IModuleAccess); stdcall;
procedure SetModuleInfo(aModuleInfo: IModuleInfo); stdcall;

exports CreateForm;
exports RegisterAccess;
exports SetModuleInfo;

implementation

{$R *.dfm}
{$R Resource\Icon.res}

uses
  System.Generics.Collections,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.ClientClasses.TPackageModuleScan,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

type
  TModuleItem = class
    Id_MenuDesign: Variant;
    Id_Module: Variant;
    ImageIndexList: Integer;
    ImageIndexTree: Integer;
  end;

const
  MODULE_NAME            = 'Дизайнер меню';
  MODULE_GUID: TGUID     = '{8F3E9406-B05D-4C4D-97E1-8F411C5E47E8}';
  MODULE_TYPEDB          = TYPE_DATABASE_ADMIN;

  PROC_ADM_DM_UPD_MENU = 'adm_dm_upd_menu';
  PROC_ADM_DM_SEL_MENU = 'adm_dm_sel_menu';
  PROC_ADM_DM_SEL_MODULELIST = 'adm_dm_sel_modulelist';

  FLD_MENU_ID_MENUDESIGNPARENT = 'Id_MenuDesignParent';
  FLD_MENU_CAPTION = 'Caption';
  FLD_MENU_ID_MENUDESIGN = 'Id_MenuDesign';
  FLD_MENU_ID_MODULE = 'Id_Module';
  FLD_MENU_PATH = 'Path';
  FLD_MENU_FILENAME = 'FileName';

  FLD_ML_PATH = 'Path';
  FLD_ML_FILENAME = 'FileName';
  FLD_ML_NAME = 'Name';
  FLD_ML_ID_MODULE = 'Id_Module';

resourcestring
  RsItemNew = 'Новый';

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmAdminMenuDesigner;
begin
  frmForm := TfrmAdminMenuDesigner.Create(aERPClientData);
  Result := frmForm.Handle;
end;

procedure SetModuleInfo(aModuleInfo: IModuleInfo);
begin
  aModuleInfo.GUID := MODULE_GUID;
  aModuleInfo.Name := MODULE_NAME;
  aModuleInfo.TypeDB := MODULE_TYPEDB;
  aModuleInfo.TypeGuid := TYPEMODULE_ADMIN;
end;

procedure RegisterAccess(aModuleAccess: IModuleAccess);
begin
end;

{ TfrmAdminMenuDesigner }

procedure TfrmAdminMenuDesigner.acGroupAddExecute(Sender: TObject);
begin
  AddGroup();
end;

procedure TfrmAdminMenuDesigner.acGroupAddUpdate(Sender: TObject);
begin
  if tvMenu.Selected <> nil then
    if tvMenu.Selected.Level in [1, 2] then
      TAction(Sender).Enabled := True
    else
      TAction(Sender).Enabled := False
  else
    TAction(Sender).Enabled := False;
end;

procedure TfrmAdminMenuDesigner.acGroupDeleteExecute(Sender: TObject);
begin
  tvMenu.Items.BeginUpdate();
  try
    tvMenu.Selected.Delete();
  finally
    tvMenu.Items.EndUpdate();
  end;
end;

procedure TfrmAdminMenuDesigner.acGroupDeleteUpdate(Sender: TObject);
begin
  if tvMenu.Selected <> nil then
    if tvMenu.Selected.Level = 2 then
      TAction(Sender).Enabled := True
    else
      TAction(Sender).Enabled := False
  else
    TAction(Sender).Enabled := False;
end;

procedure TfrmAdminMenuDesigner.acPageAddExecute(Sender: TObject);
begin
  AddPage();
end;

procedure TfrmAdminMenuDesigner.acPageAddUpdate(Sender: TObject);
begin
  if tvMenu.Selected <> nil then
    if tvMenu.Selected.Level in [0, 1] then
      TAction(Sender).Enabled := True
    else
      TAction(Sender).Enabled := False
  else
    TAction(Sender).Enabled := False;
end;

procedure TfrmAdminMenuDesigner.acPageDeleteExecute(Sender: TObject);
begin
  tvMenu.Items.BeginUpdate();
  try
    tvMenu.Selected.Delete();
  finally
    tvMenu.Items.EndUpdate();
  end;
end;

procedure TfrmAdminMenuDesigner.acPageDeleteUpdate(Sender: TObject);
begin
  if tvMenu.Selected <> nil then
    if tvMenu.Selected.Level = 1 then
      TAction(Sender).Enabled := True
    else
      TAction(Sender).Enabled := False
  else
    TAction(Sender).Enabled := False;
end;

procedure TfrmAdminMenuDesigner.acRefreshExecute(Sender: TObject);
begin
  RefreshMenu();
  RefreshModules();
end;

procedure TfrmAdminMenuDesigner.acSaveExecute(Sender: TObject);

  procedure ScanTreeView(aNode: TTreeNode; aSortId: Integer);
  begin
    if Assigned(aNode) then
    begin
      ttMenu.InsertTempTable([TFieldValue.Create('SortId', aSortId),
                              TFieldValue.Create('Pointer', Integer(aNode)),
                              TFieldValue.Create('PointerParent', Integer(aNode.Parent)),
                              TFieldValue.Create('Index', aNode.Index),
                              TFieldValue.Create('Id_Module', TModuleItem(aNode.Data).Id_Module),
                              TFieldValue.Create('Caption', aNode.Text),
                              TFieldValue.Create('Id_MenuDesign', Null)]);
      if aNode.HasChildren then
        ScanTreeView(aNode.getFirstChild(), aSortId + 1);
      ScanTreeView(aNode.getNextSibling(), aSortId + 1);
    end;
  end;

begin
  ttMenu.CreateTempTable();
  try
    ScanTreeView(tvMenu.Items.Item[0], 1);
    TERPQueryHelp.Open(FDConnection, PROC_ADM_DM_UPD_MENU, []);
  finally
    ttMenu.DropTempTable();
  end;
  RefreshMenu();
  RefreshModules();
end;

procedure TfrmAdminMenuDesigner.AddGroup;
var
  Item: TTreeNode;
  ModuleItem: TModuleItem;
begin
  Item := tvMenu.Selected;
  case Item.Level of
    1:
      Item := tvMenu.Items.AddChild(Item, RsItemNew);
    2:
      Item := tvMenu.Items.Insert(Item, RsItemNew);
  end;
  Item.ImageIndex := 2;
  Item.SelectedIndex := 2;
  ModuleItem := TModuleItem.Create();
  ModuleItem.Id_MenuDesign := Null;
  ModuleItem.Id_Module := Null;
  ModuleItem.ImageIndexList := -1;
  ModuleItem.ImageIndexTree := -1;
  Item.Data := ModuleItem;
end;

procedure TfrmAdminMenuDesigner.AddPage;
var
  Item: TTreeNode;
  ModuleItem: TModuleItem;
begin
  Item := tvMenu.Selected;
  case Item.Level of
    0:
      Item := tvMenu.Items.AddChild(Item, RsItemNew);
    1:
      Item := tvMenu.Items.Insert(Item, RsItemNew);
  end;
  Item.ImageIndex := 1;
  Item.SelectedIndex := 1;
  ModuleItem := TModuleItem.Create();
  ModuleItem.Id_MenuDesign := Null;
  ModuleItem.Id_Module := Null;
  ModuleItem.ImageIndexList := -1;
  ModuleItem.ImageIndexTree := -1;
  Item.Data := ModuleItem;
end;

procedure TfrmAdminMenuDesigner.AssignImage;

  function CopyIL(aIndex: Integer): Integer;
  var
    Icon: TIcon;
  begin
    Icon := TIcon.Create();
    try
      GDDM.ilGlobal32.GetIcon(aIndex, Icon);
      Result := ilImageList.AddIcon(Icon);
    finally
      Icon.Free();
    end;
  end;

begin
  acPageAdd.ImageIndex := CopyIL(IL_ADD);
  acPageDelete.ImageIndex := CopyIL(IL_DELETE);
  acGroupAdd.ImageIndex := CopyIL(IL_ADD);
  acGroupDelete.ImageIndex := CopyIL(IL_DELETE);
  acRefresh.ImageIndex := CopyIL(IL_REFRESH);
  acSave.ImageIndex := 0;
end;

procedure TfrmAdminMenuDesigner.ClearListView;
var
  k: Integer;
begin
  for k := 0 to lvModules.Items.Count - 1 do
    TModuleItem(lvModules.Items.Item[k].Data).Free();
  lvModules.Items.Clear();
end;

constructor TfrmAdminMenuDesigner.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);
  qrQuery.Connection := FDConnection;
  ttMenu.Connection := FDConnection;
  AssignImage();
end;

procedure TfrmAdminMenuDesigner.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClearListView();
  tvMenu.Items.Clear();
end;

procedure TfrmAdminMenuDesigner.FormShow(Sender: TObject);
begin
  RefreshMenu();
  RefreshModules();
end;

procedure TfrmAdminMenuDesigner.lvModulesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
  TreeView: TdxTreeView;
begin
  if (Source as TDragControlObject).Control is TdxTreeView then
  begin
    TreeView := (Source as TDragControlObject).Control as TdxTreeView;
    Accept := TreeView.Selected.Level = 3;
  end
  else
    Accept := False;
end;

procedure TfrmAdminMenuDesigner.lvModulesEndDrag(Sender, Target: TObject; X, Y: Integer);
var
  ListView: TcxListView;
  TreeView: TdxTreeView;
  NodeDest: TTreeNode;
  Node: TTreeNode;
  Icon: TIcon;
begin
  if Target is TdxTreeView then
  begin
    ListView := Sender as TcxListView;
    TreeView := Target as TdxTreeView;
    if Assigned(ListView) and Assigned(TreeView) then
    begin
      NodeDest := TreeView.GetNodeAt(X, Y);
      if Assigned(NodeDest) then
      begin
        case NodeDest.Level of
          2:
            Node := TreeView.Items.AddChild(NodeDest, ListView.Selected.Caption);
          3:
            Node := TreeView.Items.Insert(NodeDest, ListView.Selected.Caption);
          else
            Node := nil;
        end;
        if Assigned(Node) then
        begin
          Node.Data := ListView.Selected.Data;
          if TModuleItem(ListView.Selected.Data).ImageIndexTree = -1 then
          begin
            Icon := TIcon.Create();
            try
              ilModules32.GetIcon(ListView.Selected.ImageIndex, Icon);
              Node.ImageIndex := ilTreeVew.AddIcon(Icon);
              Node.SelectedIndex := Node.ImageIndex;
              TModuleItem(Node.Data).ImageIndexTree := Node.ImageIndex;
            finally
              Icon.Free();
            end;
          end
          else
          begin
            Node.ImageIndex := TModuleItem(ListView.Selected.Data).ImageIndexTree;
            Node.SelectedIndex := Node.ImageIndex;
          end;
          ListView.Selected.Delete();
        end;
      end;
    end;
  end;
end;

procedure TfrmAdminMenuDesigner.RefreshMenu;
var
  k: Integer;
  ModuleItem: TModuleItem;
  TreeNode: TTreeNode;
  PackageModuleItem: TPackageModuleItem;
  Icon: TIcon;

  function GetNode(aId_MenuDesign: Integer): TTreeNode;
  var
    k: Integer;
  begin
    Result := nil;
    for k := 0 to tvMenu.Items.Count - 1 do
      if TModuleItem(tvMenu.Items.Item[k].Data).Id_MenuDesign = aId_MenuDesign then
      begin
        Result := tvMenu.Items.Item[k];
        Break;
      end;
  end;

begin
  qrQuery.SQL.Text := PROC_ADM_DM_SEL_MENU;
  try
    qrQuery.Open();
    tvMenu.Items.BeginUpdate();
    try
      tvMenu.Items.Clear();
      qrQuery.First();
      for k := 0 to qrQuery.RecordCount - 1 do
      begin
        if VarIsNull(qrQuery.FieldByName(FLD_MENU_ID_MENUDESIGNPARENT).AsVariant) then
          TreeNode := tvMenu.Items.Add(nil, qrQuery.FieldByName(FLD_MENU_CAPTION).AsString)
        else
          TreeNode := tvMenu.Items.AddChild(GetNode(qrQuery.FieldByName(FLD_MENU_ID_MENUDESIGNPARENT).AsInteger),
            qrQuery.FieldByName(FLD_MENU_CAPTION).AsString);
        ModuleItem := TModuleItem.Create();
        ModuleItem.Id_MenuDesign := qrQuery.FieldByName(FLD_MENU_ID_MENUDESIGN).AsInteger;
        ModuleItem.Id_Module := qrQuery.FieldByName(FLD_MENU_ID_MODULE).AsVariant;
        if not VarIsNull(ModuleItem.Id_Module) then
        begin
          PackageModuleItem := TPackageModuleItem.Create();
          try
            PackageModuleItem.FileName := ExtractFilePath(Application.ExeName) + qrQuery.FieldByName(FLD_MENU_PATH).AsString +
              qrQuery.FieldByName(FLD_MENU_FILENAME).AsString;
            try
              if PackageModuleItem.Open() then
              begin
                Icon := TIcon.Create;
                try
                  Icon.Handle := PackageModuleItem.GetIcon(32);
                  ModuleItem.ImageIndexList := ilModules32.AddIcon(Icon);
                  ModuleItem.ImageIndexTree := ilTreeVew.AddIcon(Icon);
                finally
                  Icon.Free();
                end;
              end;
            except
            end;
          finally
            PackageModuleItem.Free();
          end;
        end
        else
        begin
          ModuleItem.ImageIndexList := -1;
          ModuleItem.ImageIndexTree := TreeNode.Level;
        end;
        TreeNode.Data := ModuleItem;
        TreeNode.ImageIndex := ModuleItem.ImageIndexTree;
        TreeNode.SelectedIndex := TreeNode.ImageIndex;
        qrQuery.Next();
      end;
    finally
      tvMenu.Items.EndUpdate();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminMenuDesigner.RefreshModules;
var
  k: Integer;
  PackageModuleItem: TPackageModuleItem;
  Icon: TIcon;
  ListItem: TListItem;
  ModuleItem: TModuleItem;
begin
  ClearListView();
  qrQuery.SQL.Text := PROC_ADM_DM_SEL_MODULELIST;
  try
    qrQuery.Open();
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      PackageModuleItem := TPackageModuleItem.Create();
      try
        PackageModuleItem.FileName := ExtractFilePath(Application.ExeName) + qrQuery.FieldByName(FLD_ML_PATH).AsString +
          qrQuery.FieldByName(FLD_ML_FILENAME).AsString;
        try
          PackageModuleItem.Open();
          lvModules.Items.BeginUpdate();
          try
            ListItem := lvModules.Items.Add;
            ListItem.Caption := qrQuery.FieldByName(FLD_ML_NAME).AsString;
            ModuleItem := TModuleItem.Create();
            ModuleItem.Id_MenuDesign := Null;
            ModuleItem.Id_Module := qrQuery.FieldByName(FLD_ML_ID_MODULE).AsInteger;
            ModuleItem.ImageIndexTree := -1;
            Icon := TIcon.Create;
            try
              Icon.Handle := PackageModuleItem.GetIcon(32);
              ListItem.ImageIndex := ilModules32.AddIcon(Icon);
            finally
              Icon.Free();
            end;
            ModuleItem.ImageIndexList := ListItem.ImageIndex;
            ListItem.Data := ModuleItem;
          finally
            lvModules.Items.EndUpdate();
          end;
        except
        end;
      finally
        PackageModuleItem.Free();
      end;
      qrQuery.Next();
    end;
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminMenuDesigner.tvMenuDeletion(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node.Data) then
    TModuleItem(Node.Data).Free();
end;

procedure TfrmAdminMenuDesigner.tvMenuDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
  TreeView: TdxTreeView;
  ListView: TcxListView;
  NodeSource: TTreeNode;
  NodeDest: TTreeNode;
  ListItemSource: TListItem;
begin
  NodeDest := (Sender as TdxTreeView).GetNodeAt(X, Y);
  if Assigned(NodeDest) then
  begin
    if (Source as TDragControlObject).Control is TdxTreeView then
    begin
      TreeView := (Source as TDragControlObject).Control as TdxTreeView;
      NodeSource := TreeView.DragSourceTreeNode;
      if Assigned(NodeSource) then
        Accept := NodeSource.Level = NodeDest.Level
      else
        Accept := False;
    end
    else
      if (Source as TDragControlObject).Control is TcxListView then
      begin
        ListView := (Source as TDragControlObject).Control as TcxListView;
        ListItemSource := ListView.Selected;
        if Assigned(ListItemSource) then
          Accept := NodeDest.Level in [2, 3]
        else
          Accept := False;
      end
      else
        Accept := False;
  end
  else
    Accept := False;
end;

procedure TfrmAdminMenuDesigner.tvMenuEndDrag(Sender, Target: TObject; X, Y: Integer);
var
  ListView: TcxCustomInnerListView;
  TreeView: TdxTreeView;
  ListItem: TListItem;
begin
  if Target is TcxCustomInnerListView then
  begin
    TreeView := Sender as TdxTreeView;
    ListView := Target as TcxCustomInnerListView;
    if Assigned(ListView) and Assigned(TreeView) then
      if TreeView.Selected.Level = 3 then
      begin
        ListItem := lvModules.Items.Add();
        ListItem.Caption := TreeView.Selected.Text;
        ListItem.Data := TreeView.Selected.Data;
        ListItem.ImageIndex := TModuleItem(TreeView.Selected.Data).ImageIndexList;
        TModuleItem(ListItem.Data).Id_MenuDesign := Null;
        TreeView.Selected.Data := nil;
        TreeView.Selected.Delete();
      end;
  end;
end;

procedure TfrmAdminMenuDesigner.tvMenuEndDragTreeNode(Destination, Source: TTreeNode; var AttachMode: TNodeAttachMode);
begin
  AttachMode := naInsert;
end;

procedure TfrmAdminMenuDesigner.tvMenuKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F2 then
    if Assigned((Sender as TdxTreeView).Selected) then
      if (Sender as TdxTreeView).Selected.Level <> 0 then
        (Sender as TdxTreeView).Selected.EditText();
end;

end.
