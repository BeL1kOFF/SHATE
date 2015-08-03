unit _ChangesInBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, ComCtrls, DBISamtb, DB,BSStrUt, BSDbiUt,
  JvExComCtrls, JvComCtrls, VirtualTrees, ExtCtrls, Menus;

type
   PVSTRecord = ^TVSTRecord;
   TVSTRecord = record
   ElementName0: string;
   ElementName1: string;
   ElementName2: string;
   ElementNumber: Integer;
   end;

  TChangesInBase = class(TForm)
    BitBtn1: TBitBtn;
    TABLE: TDBISAMTable;
    TABLEiDel: TIntegerField;
    TABLEsSubGroupe: TStringField;
    TABLEsBrand: TStringField;
    TABLEsCode: TStringField;
    TABLEsName: TStringField;
    ChangesTree: TVirtualStringTree;
    HeaderControl: THeaderControl;
    Bevel1: TBevel;
    pmTree: TPopupMenu;
    miCopy: TMenuItem;
    miSearchCode: TMenuItem;
    edCopy: TEdit;
    procedure ChangesTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ChangesTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure HeaderControlSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure FormResize(Sender: TObject);
    procedure ChangesTreeShowScrollbar(Sender: TBaseVirtualTree; Bar: Integer;
      Show: Boolean);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure miCopyClick(Sender: TObject);
    procedure miSearchCodeClick(Sender: TObject);
    procedure pmTreePopup(Sender: TObject);
  private
    { Private declarations }
    fFileName: string;
    fTreeBuilded: Boolean;
    procedure AllignHeaders;
    procedure BuildTree;
  public
    procedure Init(const aChangesFile: string);
    class function Execute(const aChangesFile: string): Integer; {ShowModal result}
  end;

var
  ChangesInBase: TChangesInBase;

implementation

uses
  _Data, _Main;

{$R *.dfm}

class function TChangesInBase.Execute(const aChangesFile: string): Integer;
begin
  Result := mrNone;

  if _Data.GetFileSize_Internal(aChangesFile) = 0 then
    Exit;
    
  with TChangesInBase.Create(Application) do
  try
    Init(aChangesFile);
    Result := ShowModal;
  finally
    Free;
  end;
end;

procedure TChangesInBase.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TChangesInBase.BuildTree;
var
  sOldSubGroupe, sOldBrand:string;
  AddItemsBase, treeGruope,treeBrand, treeElement: PVirtualNode;
  // PDNode : PDataNode;
  TreeData: PVSTRecord;
  IElement:integer;
  iGroupe,iBrand:integer;
begin
  TestTable(TABLE);
  TABLE.ImportTable(fFileName, ';');
  ChangesTree.Clear;
  IElement := 0;
  iBrand := 0;
  iGroupe := 0;
  ChangesTree.NodeDataSize := SizeOf(TVSTRecord);
  try
  with TABLE do
  begin

    AddItemsBase := ChangesTree.AddChild(ChangesTree.RootNode);//'Добавленно позиций');
    if not (vsInitialized in AddItemsBase.States) then
       ChangesTree.ReinitNode(AddItemsBase, False);
       TreeData := ChangesTree.GetNodeData(AddItemsBase);


    IndexName := 'iDel';
    Open;
    SetRange([0],[0]);
     if Assigned(TreeData) then
    begin
      TreeData.ElementName0 := 'Добавленно позиций';
      TreeData.ElementName1 := '';
      TreeData.ElementName2 := inttostr(RecordCount);
      TreeData.ElementNumber := IElement;
      IElement:=IElement+1;
    end;
    First;
    sOldSubGroupe := '';
    treeGruope:= nil;
    treeBrand := nil;
    while not TABLE.Eof do
      begin
        if sOldSubGroupe <> FieldByName('sSubGroupe').AsString then
           begin
              if treeGruope <> nil then
              begin
                TreeData := ChangesTree.GetNodeData(treeGruope);
                TreeData.ElementName2 := inttostr(iGroupe);
              end;
              iGroupe := 0;
              sOldSubGroupe := FieldByName('sSubGroupe').AsString;
              treeGruope := ChangesTree.AddChild(AddItemsBase);
              TreeData := ChangesTree.GetNodeData(treeGruope);
              if Assigned(TreeData) then
                begin
                  TreeData.ElementName0 := sOldSubGroupe;
                  TreeData.ElementName1 := '';
                  TreeData.ElementName2 := '';
                  TreeData.ElementNumber := IElement;
                  IElement:=IElement+1;
                end;
                sOldBrand :='';
                IElement:=IElement+1;

             end;

        if sOldBrand <> FieldByName('sBrand').AsString then
           begin
              if treeBrand <> nil then
              begin
                TreeData := ChangesTree.GetNodeData(treeBrand);
                TreeData.ElementName2 := inttostr(iBrand);
              end;
              iBrand:=0;
              sOldBrand := FieldByName('sBrand').AsString;
              treeBrand:=ChangesTree.AddChild(treeGruope);
              TreeData := ChangesTree.GetNodeData(treeBrand);
              if Assigned(TreeData) then
                begin
                  TreeData.ElementName0 := sOldBrand;
                  TreeData.ElementName1 := '';
                  TreeData.ElementName2 := '';
                  TreeData.ElementNumber := IElement;
                  IElement:=IElement+1;
                end;
                IElement:=IElement+1;

           end;


        treeElement := ChangesTree.AddChild(treeBrand);
        TreeData := ChangesTree.GetNodeData(treeElement);
        if Assigned(TreeData) then
           begin
             TreeData.ElementName0 := sOldBrand;
             TreeData.ElementName1 := FieldByName('sCode').AsString;
             TreeData.ElementName2 := FieldByName('sName').AsString;
             TreeData.ElementNumber := IElement;
             IElement:=IElement+1;
             iGroupe := iGroupe +1;
             iBrand:=iBrand+1;
           end;
        Next;
      end;
      if treeGruope <> nil then
        begin
          TreeData := ChangesTree.GetNodeData(treeGruope);
          TreeData.ElementName2 := inttostr(iGroupe);
        end;
       if treeBrand <> nil then
              begin
                TreeData := ChangesTree.GetNodeData(treeBrand);
                TreeData.ElementName2 := inttostr(iBrand);
              end;
    CancelRange;


    AddItemsBase := ChangesTree.AddChild(ChangesTree.RootNode);//,'Добавленно позиций');


    IndexName := 'iDel';
    Open;
    SetRange([1],[1]);
     if not (vsInitialized in AddItemsBase.States) then
       ChangesTree.ReinitNode(AddItemsBase, False);
       TreeData := ChangesTree.GetNodeData(AddItemsBase);
    if Assigned(TreeData) then
    begin
      TreeData.ElementName0 := 'Удалено позиций';
      TreeData.ElementName1 := '';
      TreeData.ElementName2 := inttostr(TABLE.RecordCount);
      TreeData.ElementNumber := IElement;
      IElement:=IElement+1;
    end;

    First;
    sOldSubGroupe := '';
    while not TABLE.Eof do
      begin
        if sOldSubGroupe <> FieldByName('sSubGroupe').AsString then
           begin
              if treeGruope <> nil then
              begin
                TreeData := ChangesTree.GetNodeData(treeGruope);
                TreeData.ElementName2 := inttostr(iGroupe);
              end;
              iGroupe := 0;

              sOldSubGroupe := FieldByName('sSubGroupe').AsString;
              treeGruope := ChangesTree.AddChild(AddItemsBase);
              TreeData := ChangesTree.GetNodeData(treeGruope);
              if Assigned(TreeData) then
                begin
                  TreeData.ElementName0 := sOldSubGroupe;
                  TreeData.ElementName1 := '';
                  TreeData.ElementName2 := '';
                  TreeData.ElementNumber := IElement;
                  IElement:=IElement+1;
                end;
                sOldBrand :='';
                IElement:=IElement+1;
             end;

        if sOldBrand <> FieldByName('sBrand').AsString then
           begin
              if treeBrand <> nil then
              begin
                TreeData := ChangesTree.GetNodeData(treeBrand);
                TreeData.ElementName2 := inttostr(iBrand);
              end;
              iBrand:=0;

              sOldBrand := FieldByName('sBrand').AsString;
              treeBrand:=ChangesTree.AddChild(treeGruope);
              TreeData := ChangesTree.GetNodeData(treeBrand);
              if Assigned(TreeData) then
                begin
                  TreeData.ElementName0 := sOldBrand;
                  TreeData.ElementName1 := '';
                  TreeData.ElementName2 := '';
                  TreeData.ElementNumber := IElement;
                  IElement:=IElement+1;
                end;
           end;


        treeElement := ChangesTree.AddChild(treeBrand);
        TreeData := ChangesTree.GetNodeData(treeElement);
        if Assigned(TreeData) then
           begin
             TreeData.ElementName0 := sOldBrand;
             TreeData.ElementName1 := FieldByName('sCode').AsString;
             TreeData.ElementName2 := FieldByName('sName').AsString;
             TreeData.ElementNumber := IElement;
             IElement:=IElement+1;
             iGroupe := iGroupe +1;
             iBrand:=iBrand+1;
           end;
        Next;
      end;
      if treeGruope <> nil then
        begin
          TreeData := ChangesTree.GetNodeData(treeGruope);
          TreeData.ElementName2 := inttostr(iGroupe);
        end;
       if treeBrand <> nil then
              begin
                TreeData := ChangesTree.GetNodeData(treeBrand);
                TreeData.ElementName2 := inttostr(iBrand);
              end;
    CancelRange;

  end;
  finally
    TABLE.Close;
    TABLE.DeleteTable;
    TABLE.Free;
  end;
  fTreeBuilded := True;
end;

procedure TChangesInBase.ChangesTreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PVSTRecord;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    Finalize(Data^);
end;

procedure TChangesInBase.ChangesTreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
 var TreeData: PVSTRecord;
begin
  TreeData := Sender.GetNodeData(Node);
  if Assigned(TreeData) then
  begin
    if Column = 0 then
      CellText := TreeData.ElementName0;
    if Column = 1 then
      CellText := TreeData.ElementName1;
    if Column = 2 then
      CellText := TreeData.ElementName2;
  end;
end;

procedure TChangesInBase.FormResize(Sender: TObject);
begin
  AllignHeaders;
end;

procedure TChangesInBase.FormShow(Sender: TObject);
begin
  if fTreeBuilded then
    Exit;
    
  if (fFileName <> '') and FileExists(fFileName) then
    BuildTree;
end;

procedure TChangesInBase.HeaderControlSectionResize(
  HeaderControl: THeaderControl; Section: THeaderSection);
begin
  AllignHeaders;
end;

procedure TChangesInBase.Init(const aChangesFile: string);
begin
  fFileName := aChangesFile;
end;

procedure TChangesInBase.ChangesTreeShowScrollbar(Sender: TBaseVirtualTree;
  Bar: Integer; Show: Boolean);
begin
  AllignHeaders;
end;

procedure TChangesInBase.AllignHeaders;
begin
  HeaderControl.Sections.Items[2].Width := ChangesTree.ClientWidth - HeaderControl.Sections.Items[1].Width - HeaderControl.Sections.Items[0].Width - 3;
  ChangesTree.Header.Columns[0].Width := HeaderControl.Sections.Items[0].Width;
  ChangesTree.Header.Columns[1].Width := HeaderControl.Sections.Items[1].Width;
  ChangesTree.Header.Columns[2].Width := HeaderControl.Sections.Items[2].Width;
end;

procedure TChangesInBase.miCopyClick(Sender: TObject);
begin
  if Assigned(Changestree.FocusedNode) then
  begin
    edCopy.Text := Changestree.Text[Changestree.FocusedNode, Changestree.FocusedColumn];
    edCopy.SelectAll;
    edCopy.CopyToClipboard;
  end;
end;

procedure TChangesInBase.miSearchCodeClick(Sender: TObject);
begin
  if Assigned(Changestree.FocusedNode) then
  begin
    if Main.SearchEd.CanFocus then
      Main.SearchEd.SetFocus;
    Main.SearchEd.Text := Changestree.Text[Changestree.FocusedNode, Changestree.FocusedColumn];
    ChangesTree.SetFocus;
  end;
end;


procedure TChangesInBase.pmTreePopup(Sender: TObject);
begin
  miSearchCode.Enabled := Changestree.FocusedColumn = 1;
  miCopy.Enabled := Changestree.FocusedNode <> nil;
end;

end.



