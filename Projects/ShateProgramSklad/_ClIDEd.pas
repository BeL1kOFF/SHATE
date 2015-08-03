unit _ClIDEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BSDlgFrm, StdCtrls, Buttons, ExtCtrls,  JvComponentBase,
  JvFormPlacement, Mask, DBCtrls, JvExStdCtrls, JvDBCombobox, ComCtrls, DB,
  dbisamtb, VirtualTrees, ImgList, BSDbiUt, Menus, DBCtrlsEh;

type
   PVSTRecord = ^TVSTRecord;
   TVSTRecord = record
   ElementName0: string;
   ElementName1: string;
   ElementName2: string;
   ElementName3: string;
   ElementName4: string;
   iGroupe, iSubGroupe, iBrand: Integer;

   end;

  TDatePickerGrid = class(TEdit)
  private
    fCancelled: Boolean;

    procedure ApplyValue;
    procedure ValueChanged(const aNodeData: TVSTRecord);
  protected
    procedure RectSet;
  public
    //не наслед, потому что другие параметры
    TreeVal:PVirtualNode;
    iColumn:integer;
    constructor MyCreate(AOwner: TComponent; Aparent : TWinControl;rec:TRect;Tree:PVirtualNode; iCol:integer); virtual;
    procedure OnExitGrid(Sender: TObject);
    procedure KeyPressEsc(Sender: TObject; var Key: Char);
    procedure OnEnterTree(Sender: TObject);
  end;

  TClientIDEdit = class(TDialogForm)
    FormStorage: TJvFormStorage;
    Label1: TLabel;
    ClientIdEd: TDBEdit;
    Label2: TLabel;
    DescriptionEd: TDBEdit;
    Label3: TLabel;
    TypeComboBox: TJvDBComboBox;
    Label4: TLabel;
    DeliveryComboBox: TJvDBComboBox;
    Email_Edit: TDBEdit;
    Label5: TLabel;
    Label6: TLabel;
    Key_Edit: TDBEdit;
    Query: TDBISAMQuery;
    LoadTree_Timer: TTimer;
    SaveToFile_BitBtn: TBitBtn;
    SaveDialog: TSaveDialog;
    LoadFromFile_BitBtn: TBitBtn;
    OpenDialog: TOpenDialog;
    Bevel1: TBevel;
    Bevel2: TBevel;
    mem038: TDBISAMTable;
    cbShowPassword: TCheckBox;
    pnDiscounts: TPanel;
    Discaunt_Tree: TVirtualStringTree;
    TabView: TTabControl;
    UpNullMargin: TButton;
    Bevel3: TBevel;
    Label7: TLabel;
    pmTree: TPopupMenu;
    miTreeExpand: TMenuItem;
    miTreeCollapse: TMenuItem;
    Bevel4: TBevel;
    lbEditData: TLabel;
    UpNullDiscount: TButton;
    Panel1: TPanel;
    Label8: TLabel;
    edDiscGlobal: TEdit;
    btLoadDiscount: TBitBtn;
    cbDiscountsMode: TJvDBComboBox;
    Label9: TLabel;

    procedure FormShow(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure Discaunt_TreeMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure Discaunt_TreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure Discaunt_TreeFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure Discaunt_TreeDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CancelBtnClick(Sender: TObject);
    procedure btLoadDiscountClick(Sender: TObject);
    procedure UpNullDiscountClick(Sender: TObject);
    procedure UpNullMarginClick(Sender: TObject);
    procedure LoadTree_TimerTimer(Sender: TObject);
    procedure Discaunt_TreeKeyPress(Sender: TObject; var Key: Char);
    procedure SaveToFile_BitBtnClick(Sender: TObject);
    procedure LoadFromFile_BitBtnClick(Sender: TObject);
    procedure TabViewChange(Sender: TObject);
    procedure cbShowPasswordClick(Sender: TObject);
    procedure miTreeExpandClick(Sender: TObject);
    procedure miTreeCollapseClick(Sender: TObject);
    procedure Key_EditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edDiscGlobalChange(Sender: TObject);
    procedure edDiscGlobalExit(Sender: TObject);
    procedure lbEditDataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbDiscountsModeChange(Sender: TObject);
    procedure Discaunt_TreeCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
  private
    { Private declarations }
    fModified: Boolean;
    fDiscountVersion: Integer;
    fLoadedClientID: string;

    procedure ClearDiscounts;
  public
    function TestEmailAdress(sEmail:string):bool;
//    procedure loadTree;
    procedure loadTreeMem;
    procedure saveTreeMem(isBrandView: Boolean);
    procedure CacheDiscounts;
    procedure SaveDiscountsToDB;

    function GetDiscountMem(gr, subgr, br: Integer; bStrictConformity: Boolean = True): Double;
    function GetMarginMem(gr, subgr, br: Integer; bStrictConformity: Boolean = True): Double;
    procedure DiscountChanged(const aNodeData: TVSTRecord; aDiscountOnly: Boolean = False);
    procedure SaveGlobalDiscount;

    procedure SetReadOnlyMode(aReadOnly: Boolean);
    function CheckPas(Pas: string): string;
  end;

implementation

uses
  _Main, _Data, BSMath, VCLUtils, _CSVReader;

{$R *.dfm}

var
  editkol:  TDatePickerGrid;


function StrToFloatDefUnic(const aValue: string; aDef: Extended): Double;
var
  aNorm: string;
begin
  aNorm := aValue;
  if DecimalSeparator <> '.' then
    aNorm := StringReplace(aNorm, '.', DecimalSeparator, [rfReplaceAll]);
  if DecimalSeparator <> ',' then
    aNorm := StringReplace(aNorm, ',', DecimalSeparator, [rfReplaceAll]);
  Result := StrToFloatDef(aNorm, aDef);
end;


constructor TDatePickerGrid.MyCreate(AOwner: TComponent; Aparent :   TWinControl;rec:TRect;Tree:PVirtualNode; iCol:integer);
var
  vFParent: TWinControl;
  NodeData: PVSTRecord;
begin
  Create(AOwner);
  SetParent(Aparent);
  TreeVal := Tree;

  vfparent := parent;
  Left:=Rec.Left;
  Top := Rec.Top;//Top + (vFParent as TStringGrid).Top;
  Width := Rec.Right-Rec.Left;// (vFParent as TStringGrid).ColWidths[(vFParent as TStringGrid).Col]+3;
  Height := Rec.Bottom - Rec.Top;

  OnExit := OnExitGrid;//когда теряем фокус
  OnKeyPress:=KeyPressEsc;
  OnEnter :=  OnEnterTree;
  BorderWidth := 1;
  iColumn := iCol;

  SetFocus;                                                         
end;

procedure TDatePickerGrid.OnExitGrid(Sender: TObject);
var FParent: TWinControl; 
begin
  if not fCancelled then
    ApplyValue;
  inherited destroy; //Ушли из ячейки ничего не меняем 
end;

procedure TDatePickerGrid.RectSet; // так будет правильно
  var vFParent: TWinControl; 
    i : integer;
    Rec:TRect;
begin 
   vfparent := parent;
  // Rec:=(parent as TStringGrid).CellRect(iColT,iRowT);
   Left:=Rec.Left;
   Top := Rec.Top;//Top + (vFParent as TStringGrid).Top;
   Width := Rec.Right-Rec.Left;// (vFParent as TStringGrid).ColWidths[(vFParent as TStringGrid).Col]+3;
   Height := Rec.Bottom - Rec.Top;//(vFParent as TStringGrid).RowHeights[(vFParent as TStringGrid).row]+3;
end;

procedure TDatePickerGrid.ValueChanged(const aNodeData: TVSTRecord);
begin
  if Owner is TClientIDEdit then
    (Owner as TClientIDEdit).DiscountChanged(aNodeData);
end;

//OnEnterTree
procedure TDatePickerGrid.OnEnterTree(Sender: TObject);
var vFParent: TWinControl;
    NodeData:PVSTRecord;
begin
  fCancelled := False;
  vfparent := parent;
  if Length(Text)<1 then
    Exit;
  try
  if strtoint(text) <1 then
    Exit;
  except
    Exit;
  end;

  NodeData := (vFParent as TVirtualStringTree).GetNodeData(TreeVal);
  NodeData.ElementName4 := Text;
  (vFParent as TVirtualStringTree).SetFocus;
end;


procedure TDatePickerGrid.ApplyValue;
var
    NodeData:PVSTRecord;
    treeNode:PVirtualNode;
    iBrand:integer;
    vfparent: TWinControl;
    aValue: string;
    dValue, dOld: Double;
begin
//Вводим значение
    vfparent := parent;

    NodeData := (vFParent as TVirtualStringTree).GetNodeData(TreeVal);

    aValue := Text;
    if aValue = '' then
      aValue := '0';

    if iColumn = 1 then
      dOld := StrToFloatDefUnic(NodeData.ElementName3, 0);
    if iColumn = 2 then
      dOld := StrToFloatDefUnic(NodeData.ElementName4, 0);

    dValue := StrToFloatDefUnic(aValue, dOld);
    if dOld = dValue then
      Exit;
    if dValue = 0 then
      aValue := ''
    else
      aValue := FormatFloat('0.##', dValue);

    if (NodeData.iBrand > 0) and (NodeData.iSubGroupe = 0) then
    begin
        iBrand := NodeData.iBrand;
        treeNode := (vFParent as TVirtualStringTree).GetNext(TreeVal, true);
        while Assigned(treeNode) do
        begin
            NodeData := (vFParent as TVirtualStringTree).GetNodeData(treeNode);
            if (iBrand > 0) and (iBrand <> NodeData.iBrand) then
              break;

             if iColumn = 1 then
                NodeData.ElementName3 := aValue;
             if iColumn = 2 then
               NodeData.ElementName4 := aValue;

            ValueChanged(NodeData^);

            treeNode := (vFParent as TVirtualStringTree).GetNext(treeNode, true);
        end;
    end
    else
    begin
      if iColumn = 1 then
        NodeData.ElementName3 := aValue;
      if iColumn = 2 then
        NodeData.ElementName4 := aValue;
      ValueChanged(NodeData^);
    end;
end;

procedure TDatePickerGrid.KeyPressEsc(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
//    ApplyValue;
    (Parent as TVirtualStringTree).SetFocus;
  end;
  if key = #27 then
  begin
    fCancelled := True;
    (Parent as TVirtualStringTree).SetFocus;
  end;
end;

procedure TClientIDEdit.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TClientIDEdit.cbDiscountsModeChange(Sender: TObject);
begin
  if Assigned(Sender) then
  begin
    if cbDiscountsMode.ItemIndex = 0 then//скидки Шате-М
      if Application.MessageBox('Скидки, установленные Вами вручную будут потеряны'#13#10'Продолжить?', '', MB_YESNO or MB_ICONQUESTION) <> IDYES then
      begin
        cbDiscountsMode.ItemIndex := 1;
        Exit;
      end;

    if cbDiscountsMode.ItemIndex = 1 then//скидки вручную
      if Application.MessageBox('Скидки, полученные по TCP, будут потеряны'#13#10'Продолжить?', '', MB_YESNO or MB_ICONQUESTION) <> IDYES then
      begin
        cbDiscountsMode.ItemIndex := 0;
        Exit;
      end;
  end;

  inherited;
  edDiscGlobal.Enabled := cbDiscountsMode.ItemIndex > 0;
  btLoadDiscount.Visible := not edDiscGlobal.Enabled;

  if Assigned(Sender) then
    ClearDiscounts;
  
  if edDiscGlobal.Enabled then
    Discaunt_Tree.Header.Columns[1].Options := Discaunt_Tree.Header.Columns[1].Options + [coVisible]
  else
    Discaunt_Tree.Header.Columns[1].Options := Discaunt_Tree.Header.Columns[1].Options - [coVisible];
end;

procedure TClientIDEdit.cbShowPasswordClick(Sender: TObject);
begin
  inherited;
  if cbShowPassword.Checked then
    Key_Edit.PasswordChar := #0
  else
    Key_Edit.PasswordChar := '*';
end;

function TClientIDEdit.CheckPas(Pas: string): string;
var
  i: integer;
begin
  for i := length(pas) DownTo 1 do
  if pas[i] in ['а'..'я']+['А'..'Я']+
    ['`']+['~']+['!']+['@']+['"']+['#']+['№']+[';']+['$']+
    ['%']+['^']+[':']+['&']+['?']+['(']+[')']+['-']+['_']+
    ['=']+['+']+['/']+[',']+['.']+['Ё']+['ё']+['|']+
    ['*']+['{']+['}']+['[']+[']']+['<']+['>']+[' ']+['!'] then
    Pas := StringReplace(Pas,Pas[i],'',[rfReplaceAll]);
  Pas := StringReplace(Pas,#13#10,'',[rfReplaceAll]);
  Pas := StringReplace(Pas,#13,'',[rfReplaceAll]);

  result := Pas;
end;

procedure TClientIDEdit.ClearDiscounts;
var
  aQuery: TDBISamQuery;
  sID: string;
begin
  mem038.Close;
  sID := Main.ReplaceLeftSymbol(ClientIdEd.Text);
  if sID = '' then
    Exit;

  aQuery := TDBISamQuery.Create(nil);
  try
    aQuery.DatabaseName := Data.Database.DatabaseName;
    aQuery.SQL.Text :=
      ' DELETE FROM "Memory\mem038" WHERE (Margin = 0 OR Margin IS NULL) AND CLI_ID = ''' + sID + '''';
    aQuery.ExecSQL;

    aQuery.SQL.Text :=
      ' UPDATE "Memory\mem038" SET Discount = NULL WHERE CLI_ID = ''' + sID + '''';
    aQuery.ExecSQL;

    loadTreeMem;
  finally
    aQuery.Free;
  end;
  fModified := True;
end;

procedure TClientIDEdit.Discaunt_TreeCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  aNodeText1, aNodeText2: string;
begin
  inherited;
  if Assigned(Sender.GetNodeData(Node1)) then
    aNodeText1 := PVSTRecord(Sender.GetNodeData(Node1))^.ElementName0;
  if Assigned(Sender.GetNodeData(Node2)) then
    aNodeText2 := PVSTRecord(Sender.GetNodeData(Node2))^.ElementName0;

  Result := CompareText(aNodeText1, aNodeText2);
end;

procedure TClientIDEdit.Discaunt_TreeDblClick(Sender: TObject);
var
  I,MX,MY, iRow,iCol:Integer;
  Rect:TRect;
  Node: PVirtualNode;
  NodeData:PVSTRecord;
  rec:TRect;
  ColIndex:TColumnIndex;
  sName:string;
  iCOlumn:integer;
  recColumn:TRect;
begin
  if Discaunt_tree.GetFirst() = nil then
    Exit;
    
    iRow :=0;
    iCol :=0;
    MX:=Mouse.CursorPos.X - Discaunt_Tree.ClientOrigin.X;
    MY:=Mouse.CursorPos.Y - Discaunt_Tree.ClientOrigin.Y;

    Node := (Sender as TVirtualStringTree).GetNodeAt(MX, MY);

    NodeData := (Sender as TVirtualStringTree).GetNodeData(Node);
    iColumn := 0;
    recColumn := Discaunt_Tree.Header.Columns[1].GetRect();
    if (recColumn.Left <= MX) and (recColumn.Right >= MX) then
        iColumn := 1;

    recColumn := Discaunt_Tree.Header.Columns[2].GetRect();
    if (recColumn.Left <= MX) and (recColumn.Right >= MX) then
        iColumn := 2;

    if iCOlumn < 1 then
      exit;

    rec := (Sender as TVirtualStringTree).GetDisplayRect(Node, iColumn, FALSE,FALSE,FALSE);
    editkol := TDatePickerGrid.MyCreate(self, (Sender as TVirtualStringTree), rec, Node, iColumn);

    if iColumn = 1 then
      editkol.Text := NodeData.ElementName3
    else
      if iColumn = 2 then
        editkol.Text := NodeData.ElementName4;

    if editkol.Text = '' then
      editkol.Text := '0';
      
  editkol.SelectAll;
end;

procedure TClientIDEdit.Discaunt_TreeFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PVSTRecord;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    Finalize(Data^);
end;

procedure TClientIDEdit.Discaunt_TreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
  var TreeData: PVSTRecord;
begin
  TreeData := Sender.GetNodeData(Node);
  if Assigned(TreeData) then
  begin
    if Column = 1 then
    begin
      CellText := TreeData.ElementName3;
      Exit;
    end;

    if Column = 2 then
    begin
      CellText := TreeData.ElementName4;
      Exit;
    end;

    if TabView.TabIndex = 0 then
    begin
      if TreeData.iBrand > 0 then
      begin
        CellText := TreeData.ElementName2;
        Exit;
      end;

      if TreeData.iSubGroupe > 0 then
      begin
        CellText := TreeData.ElementName1;
        Exit;
      end;

      CellText := TreeData.ElementName0;
      Exit;
    end;

    if TreeData.iSubGroupe > 0 then
    begin
      CellText := TreeData.ElementName1;
      Exit;
    end;

    CellText := TreeData.ElementName0;
    Exit;
   end;
end;

procedure TClientIDEdit.Discaunt_TreeKeyPress(Sender: TObject; var Key: Char);
var
  treeNode: PVirtualNode;
begin
  if Discaunt_tree.GetFirst() = nil then
    Exit;

  if GetKeyState(VK_SHIFT)<0 then
    begin
       if key = '+' then
       begin
          treeNode := Discaunt_Tree.GetFirst();
          while Assigned(treeNode) do
          begin
              if treeNode.ChildCount > 0 then
                begin
                   Discaunt_Tree.Expanded[treeNode] := TRUE;
                end;
              treeNode := Discaunt_Tree.GetNext(treeNode, true);
          end;
          treeNode := Discaunt_Tree.GetFirst();
          Discaunt_Tree.ScrollIntoView(treeNode,FALSE,FALSE);
       end;

       if key = '-' then
       begin
          treeNode := Discaunt_Tree.GetFirst();
          while Assigned(treeNode) do
          begin
              if treeNode.ChildCount > 0 then
                begin
                   Discaunt_Tree.Expanded[treeNode] := FALSE;
                end;
              treeNode := Discaunt_Tree.GetNext(treeNode, true); //First();
          end;
          treeNode := Discaunt_Tree.GetFirst();
          Discaunt_Tree.ScrollIntoView(treeNode,FALSE,FALSE);
       end;
    end;
end;

procedure TClientIDEdit.Discaunt_TreeMeasureItem(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
begin
  if Sender.MultiLine[Node] then
  begin
   TargetCanvas.Font := Sender.Font;
   NodeHeight := Discaunt_Tree.ComputeNodeHeight(TargetCanvas, Node, 0) + 10;
  end;

end;

procedure TClientIDEdit.DiscountChanged(const aNodeData: TVSTRecord; aDiscountOnly: Boolean = False);
var
  aDiscount, aMargin: Double;
begin
  aDiscount := StrToFloatDefUnic(aNodeData.ElementName3, 0.0);
  aMargin := StrToFloatDefUnic(aNodeData.ElementName4, 0.0);

  if (aNodeData.iBrand = 0) and (aNodeData.iGroupe = 0) and (aNodeData.iSubGroupe = 0) then
    edDiscGlobal.Text := FormatFloat('0.##', aDiscount);

  if not mem038.Active then
    mem038.Open;

  mem038.Filtered := False;
  mem038.Filter := '';

  fModified := True;

  if mem038.Locate('CLI_ID;GR_ID;SUBGR_ID;BRAND_ID', VarArrayOf([fLoadedClientID, aNodeData.iGroupe, aNodeData.iSubGroupe, aNodeData.iBrand]), []) then
  begin
    if aDiscountOnly then
      aMargin := mem038.FieldByName('Margin').AsFloat;
    if (aDiscount <> 0) or (aMargin <> 0) then
    begin
      mem038.Edit;
      mem038.FieldByName('Discount').AsFloat := aDiscount;
      mem038.FieldByName('Margin').AsFloat := aMargin;
      mem038.Post;
    end
    else
      mem038.Delete;
  end
  else
    if (aDiscount <> 0) or (aMargin <> 0) then
    begin
      mem038.Append;
      mem038.FieldByName('CLI_ID').AsString := fLoadedClientID;
      mem038.FieldByName('GR_ID').AsInteger := aNodeData.iGroupe;
      mem038.FieldByName('SUBGR_ID').AsInteger := aNodeData.iSubGroupe;
      mem038.FieldByName('BRAND_ID').AsInteger := aNodeData.iBrand;
      mem038.FieldByName('Discount').AsFloat := aDiscount;
      mem038.FieldByName('Margin').AsFloat := aMargin;
      mem038.Post;
    end;
end;

procedure TClientIDEdit.edDiscGlobalChange(Sender: TObject);
begin
  inherited;
  fModified := True;
end;

procedure TClientIDEdit.edDiscGlobalExit(Sender: TObject);
begin
  inherited;

  if fModified then
  begin
    SaveGlobalDiscount;
    Discaunt_tree.Repaint;
  end;
end;

procedure TClientIDEdit.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  anActiveControl: TWinControl;
begin
  anActiveControl := Self.ActiveControl;
  //DB-Aware контролы устанавливают DataSet.Modified при потере фокуса
  //поэтому принудительно заставляем потерять фокус
  Self.ActiveControl := nil;

  if DataSource <> nil then
  begin
    if (not CancelBtnFlag) and
       (DataSource.DataSet.State <> dsBrowse) and
       (DataSource.DataSet.Modified or fModified) then
    begin
      case MessageDlg(BSSaveMess, mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
        mrYes: OkBtnClick(nil);//вместо DataSource.DataSet.Post - должны выполнится еще нек. вещи
        mrNo: DataSource.DataSet.Cancel;
        mrCancel:
        begin
          CanClose := False;
          if Assigned(anActiveControl) and anActiveControl.CanFocus then
            anActiveControl.SetFocus;
        end;
      end;
    end
    else
      DataSource.DataSet.Cancel;
  end;
end;

procedure TClientIDEdit.FormCreate(Sender: TObject);
begin
  inherited;
  SetReadOnlyMode(True);
end;

procedure TClientIDEdit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if Key =  VK_RETURN then
  begin
     if ActiveControl is TDatePickerGrid then
     begin
         //MessageDlg('Enter',mtInformation,[mbOK],0);
         exit;
     end;
  end;

  if Key =  VK_ESCAPE then
  begin
     if ActiveControl is TDatePickerGrid then
     begin
         //MessageDlg('Enter',mtInformation,[mbOK],0);
         exit;
     end;
  end;

  if Key =  VK_ESCAPE then
  begin
    Close;
  end;

  if ActiveControl = Discaunt_Tree then
    Exit; //just do not call inherited

  inherited;
end;

procedure TClientIDEdit.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ActiveControl is TDatePickerGrid then
  begin
    if not (Key in ['0'..'9', #13, #27, #8, '.', ',', '-']) then
      Key := #0;
    Exit;
  end;

  inherited;
end;

procedure TClientIDEdit.FormShow(Sender: TObject);
var
  i: Integer;
  sFilter: string;
begin
  inherited;

  for i := 0 to ControlCount - 1 do
    if Controls[i] is TDBEdit then
      (Controls[i] as TDBEdit).DataSource := DataSource
    else if Controls[i] is TJvDBComboBox then
      (Controls[i] as TJvDBComboBox).DataSource := DataSource
      else
        if Controls[i] is TDBCheckBox then
        begin
          (Controls[i] as TDBCheckBox).DataSource := DataSource;
          if not (Controls[i] as TDBCheckBox).Checked then
            (Controls[i] as TDBCheckBox).Checked := false;
        end;
  cbDiscountsMode.DataSource := DataSource;

  if DataSource.DataSet.FieldByName('UpdateDisc').IsNull then
  begin
    DataSource.DataSet.FieldByName('UpdateDisc').AsBoolean := False;
    DataSource.DataSet.Post;
    DataSource.DataSet.Edit;
  end;
  cbDiscountsModeChange(nil);
  
  fDiscountVersion := DataSource.DataSet.FieldByName('DiscountVersion').AsInteger;

{  
  with Data.DiscountTable do
  begin
    DisableControls;
    if IndexName <> 'CLI' then
      IndexName := 'CLI';
    sFilter := Main.ReplaceLeftSymbol(ClientIdEd.Text);
    SetRange([sFilter], [sFilter]);
    EnableControls;
  end;
}

  if (DataSource.DataSet.State = dsInsert) or (Main.ReplaceLeftSymbol(ClientIdEd.Text) = '') then
  begin
    SetReadOnlyMode(False);
    if ClientIdEd.CanFocus then
      ClientIdEd.SetFocus;
  end
  else
    if edDiscGlobal.CanFocus then
      edDiscGlobal.SetFocus
    else
      if Discaunt_Tree.CanFocus then
        Discaunt_Tree.SetFocus;


  CacheDiscounts;
  LoadTreeMem;
  fModified := False;
end;

procedure TClientIDEdit.btLoadDiscountClick(Sender: TObject);
var
  aNewDiscVer: Integer;
  sID: string;
begin
  Key_Edit.Text := CheckPas(Key_Edit.Text);
  sID := Main.ReplaceLeftSymbol(ClientIdEd.Text);
  if sID = '' then
  begin
    MessageDlg('Введите идентификатор клиента!', mtInformation, [mbOK], 0);
    Exit;
  end;

  if not Main.CheckTcpDDOS(cCallTCPDiscountsInterval div 2) then
  begin
    MessageDlg('Подождите!', mtInformation, [mboK], 0);
    Exit;
  end;

  StartWait;
  if Main.LoadDescriptionsTCP(Main.ReplaceLeftSymbol(ClientIdEd.Text), Main.ReplaceLeftSymbolAB(Key_edit.Text), '0', aNewDiscVer, False, mem038) > 0 then
  begin
    fDiscountVersion := aNewDiscVer;
   // CacheDiscounts;
    LoadTreeMem;
    if mem038.Active then
      mem038.Refresh;
    fModified := True;
    StopWait;
    MessageDlg('Скидки загружены', mtInformation, [mbOK],0);
    exit;
  end;
  StopWait;
  MessageDlg('Ошибка при загрузке скидок', mtInformation, [mbOK],0);
end;

procedure TClientIDEdit.OkBtnClick(Sender: TObject);
var
  TreeData: PVSTRecord;
  treeNode: PVirtualNode;
  sFilter: string;
  sID: string;
begin
  Key_Edit.Text := CheckPas(Key_Edit.Text);
  if not TestEmailAdress(Email_Edit.Text) then
  begin
    MessageDlg('Проверьте email!', mtInformation, [mbOK],0);
    if Email_Edit.CanFocus then
      Email_Edit.SetFocus;
    Abort;
  end;

{  Key_edit.Text := Main.ReplaceLeftSymbolAB(Key_edit.Text);
  if Trim(Key_edit.Text) = '' then
  begin
    MessageDlg('Введите ключ клиента!', mtInformation, [mbOK],0);
    Key_edit.SetFocus;
    Abort;
  end; }

  sID := Main.ReplaceLeftSymbol(ClientIdEd.Text);
  ClientIdEd.Text := sID;

  if sID = '' then
  begin
    MessageDlg('Проверьте идентификатор клиента!', mtInformation, [mbOK], 0);
    if ClientIdEd.CanFocus then
      ClientIdEd.SetFocus;
    Abort;
  end;

  if edDiscGlobal.Focused then
    SaveGlobalDiscount;

//  saveTreeMem(TabView.TabIndex = 1);
  SaveDiscountsToDB;

  if fDiscountVersion <> DataSource.DataSet.FieldByName('DiscountVersion').AsInteger then
  begin
    DataSource.DataSet.Edit;
    DataSource.DataSet.FieldByName('DiscountVersion').AsInteger := fDiscountVersion;
  end;
  
  if DataSource.DataSet.State in [dsInsert, dsEdit] then
    DataSource.DataSet.Post;

  ModalResult := mrOK;
end;

procedure TClientIDEdit.SaveToFile_BitBtnClick(Sender: TObject);
var sFileName:string;
   TreeData: PVSTRecord;
   treeNode: PVirtualNode;
   ftFile:TextFile;
   gr, sgr, br: Integer;
   s1, s2, s3: string;
begin
  if not SaveDialog.Execute then
        exit;
  SetCurrentDir(Data.Data_Path);
  sFileName := SaveDialog.FileName;
  if (Main.StrRight(sFileName,4)<>'.csv') then
      sFileName:=sFileName+'.csv';

  if FileExists(sFileName) then
  begin
    if MessageDlg('Файл - "'+sFileName+'" уже существует. Переписать?', mtInformation, [mbYes, mbNo], 0) <> mrYes then
       exit;
  end;
  AssignFile(ftFile,sFileName);
  Rewrite(ftFile);

  mem038.Filtered := False;
  mem038.IndexName := 'CLI';
  mem038.Open;
  mem038.SetRange([fLoadedClientID], [fLoadedClientID]);
  mem038.First;
  while not mem038.Eof do
  begin
    gr := mem038.FieldByName('GR_ID').AsInteger;
    sgr := mem038.FieldByName('SUBGR_ID').AsInteger;
    br := mem038.FieldByName('BRAND_ID').AsInteger;

    s1 := '';
    s2 := '';
    s3 := '';
    if (gr > 0) then
      if Data.GroupTable.Locate('Group_id', gr, []) then
        s1 := Data.GroupTable.FieldByName('Group_Descr').AsString
      else
      begin
        mem038.Next;
        Continue;
      end;

    if (sgr > 0) then
      if Data.GroupTable.Locate('Group_id;Subgroup_id', VarArrayOf([gr, sgr]), []) then
        s2 := Data.GroupTable.FieldByName('Subgroup_Descr').AsString
      else
      begin
        mem038.Next;
        Continue;
      end;

    if (br > 0) then
      if Data.BrandTable.Locate('Brand_id', br, []) then
        s3 := Data.BrandTable.FieldByName('Description').AsString
      else
      begin
        mem038.Next;
        Continue;
      end;


    Writeln(
      ftFile,
      s1 + ';' +
      s2 + ';' +
      s3 + ';' +
      mem038.FieldByName('Discount').AsString + ';' +
      mem038.FieldByName('Margin').AsString
    );

    mem038.Next;
  end;
  CloseFile(ftFile);
end;

procedure TClientIDEdit.LoadFromFile_BitBtnClick(Sender: TObject);
var
  sFileName, s, sID: string;
  aReader: TCSVReader;

  aDiscount, aMargin: Double;
  gr, sgr, br: Integer;
begin
  sID := Main.ReplaceLeftSymbol(ClientIdEd.Text);
  if sID = '' then
  begin
    MessageDlg('Введите ключ клиента!', mtInformation, [mbOK], 0);
    Exit;
  end;

  if not OpenDialog.Execute then
    Exit;

  SetCurrentDir(Data.Data_Path);
  sFileName := OpenDialog.FileName;

  Query.SQL.Clear;
  Query.SQL.Add('DELETE from "Memory\mem038" WHERE CLI_ID = ''' + sID + '''');
  Query.ExecSQL;
  Query.Close;

  aReader := TCSVReader.Create;
  aReader.Open(sFileName);
  try
    while not aReader.Eof do
    begin
      aReader.ReturnLine;

      aDiscount := StrToFloatDefUnic(aReader.Fields[3], 0.0);
      aMargin := StrToFloatDefUnic(aReader.Fields[4], 0.0);

      if (aDiscount = 0) and (aMargin = 0) then
        Continue;

      gr := 0;
      sgr := 0;
      br := 0;
      if (aReader.Fields[0] <> '') then
        if Data.GroupTable.Locate('Group_Descr', aReader.Fields[0], []) then
          gr := Data.GroupTable.FieldByName('Group_id').AsInteger
        else
          Continue;

      if (aReader.Fields[1] <> '') then
        if Data.GroupTable.Locate('Group_Descr;Subgroup_Descr', VarArrayOf([aReader.Fields[0], aReader.Fields[1]]), []) then
          sgr := Data.GroupTable.FieldByName('Subgroup_id').AsInteger
        else
          Continue;

      if (aReader.Fields[2] <> '') then
        if Data.BrandTable.Locate('Description', aReader.Fields[2], []) then
          br := Data.BrandTable.FieldByName('Brand_id').AsInteger
        else
          Continue;

      mem038.Append;
      mem038.FieldByName('CLI_ID').AsString := sID;
      mem038.FieldByName('GR_ID').AsInteger := gr;
      mem038.FieldByName('SUBGR_ID').AsInteger := sgr;
      mem038.FieldByName('BRAND_ID').AsInteger := br;
      mem038.FieldByName('Discount').AsFloat := aDiscount;
      mem038.FieldByName('Margin').AsFloat := aMargin;
      mem038.Post;
    end;
    aReader.Close;
  finally
    aReader.Free;
  end;

  loadTreeMem;
end;

procedure TClientIDEdit.TabViewChange(Sender: TObject);
begin
  inherited;
//  saveTreeMem(TabView.TabIndex = 0);
  LoadTree_Timer.Enabled := TRUE;
  if Discaunt_Tree.CanFocus then
    Discaunt_Tree.SetFocus;
end;

function TClientIDEdit.TestEmailAdress(sEmail:string):bool;
var i:integer;
     namePart, serverPart: string;
begin

    Result:= false;
    for i:= 1 to Length(sEmail) do
     begin
       if not (sEmail[i] in ['a'..'z', 'A'..'Z', '0'..'9', '_', '-', '.','@']) then
          begin
           Exit;
          end;
     end;


  i:= Pos('@', sEmail);
  if i = 0 then
      Exit;

  namePart:= Copy(sEmail, 1, i - 1);
  serverPart:= Copy(sEmail, i + 1, Length(sEmail));
  if (Length(namePart) = 0) or ((Length(serverPart) < 3)) then
      Exit;

 i:= Pos('.', serverPart);
  if (i < 2) or (i > (Length(serverPart) - 1)) then
 begin
   Exit;
 end;
 Result:= True;
end;

procedure TClientIDEdit.UpNullDiscountClick(Sender: TObject);
var
  aQuery: TDBISamQuery;
  sID: string;
begin
  mem038.Close;
  sID := Main.ReplaceLeftSymbol(ClientIdEd.Text);
  if sID = '' then
    Exit;

  aQuery := TDBISamQuery.Create(nil);
  try
    aQuery.DatabaseName := Data.Database.DatabaseName;
    aQuery.SQL.Text :=
      ' DELETE FROM "Memory\mem038" WHERE (Margin = 0 OR Margin IS NULL) AND CLI_ID = ''' + sID + '''';
    aQuery.ExecSQL;

    aQuery.SQL.Text :=
      ' UPDATE "Memory\mem038" SET Discount = NULL WHERE CLI_ID = ''' + sID + '''';
    aQuery.ExecSQL;

    loadTreeMem;
  finally
    aQuery.Free;
  end;
  fModified := True;
  MessageDlg('Скидки обнулены', mtInformation, [mbOK], 0);
end;

procedure TClientIDEdit.UpNullMarginClick(Sender: TObject);
var
  aQuery: TDBISamQuery;
  sID: string;
begin
  mem038.Close;
  sID := Main.ReplaceLeftSymbol(ClientIdEd.Text);
  if sID = '' then
    Exit;

  aQuery := TDBISamQuery.Create(nil);
  try
    aQuery.DatabaseName := Data.Database.DatabaseName;
    aQuery.SQL.Text :=
      ' DELETE FROM "Memory\mem038" WHERE (Discount = 0 OR Discount IS NULL) AND CLI_ID = ''' + sID + '''';
    aQuery.ExecSQL;

    aQuery.SQL.Text :=
      ' UPDATE "Memory\mem038" SET Margin = NULL WHERE CLI_ID = ''' + sID + '''';
    aQuery.ExecSQL;

    loadTreeMem;
  finally
    aQuery.Free;
  end;
  fModified := True;
  MessageDlg('Наценки обнулены', mtInformation, [mbOK], 0);
end;

(*
procedure TClientIDEdit.LoadTree;
var
  gr, sgr, br: integer;
  sOldIndexName:string;
  TreeData: PVSTRecord;
  AddItemsBase, treeGruope,treeBrand, treeSubGruope: PVirtualNode;
  fDisc:real;
  sBrand, sID: string;
begin
  Discaunt_Tree.Clear;
  Query.SQL.Clear;
  Query.Close;

  sID := Main.ReplaceLeftSymbol(ClientIdEd.Text);
  if sID = '' then
    exit;

//по группам--------------------------------------------------------------------
  if TabView.TabIndex = 0 then
  begin
    Discaunt_Tree.Header.Columns[0].Text := 'Группа\Подгруппа\Бренд';

    Query.SQL.Add('SELECT DISTINCT [005].Brand_id,[005].Group_id,[005].Subgroup_id, [038].Discount,[038].Margin FROM [005] LEFT JOIN [038] on [005].Group_id = [038].Gr_id and [005].Subgroup_id = [038].SUBGR_ID AND [005].Brand_id = [038].BRAND_ID AND [038].CLI_ID = '''+sID+''' where Group_id > 0 and Subgroup_id > 0 AND Brand_id > 0 ORDER BY Group_id,Subgroup_id,Brand_id');
    {
      SELECT [005].Brand_id,[005].Group_id,[005].Subgroup_id, [038].Discount,[038].Margin FROM [005] JOIN [038] on [005].Group_id = [038].Gr_id and
      [005].Subgroup_id = [038].SUBGR_ID AND
      [005].Brand_id = [038].BRAND_ID
      AND [038].CLI_ID = '616220'

     if Data.CatFilterTable.Active then
        Query.SQL.Add('SELECT DISTINCT Group_id,Subgroup_id,Brand_id FROM [005] where Group_id > 0 and Subgroup_id > 0 AND Brand_id > 0 ORDER BY Group_id,Subgroup_id,Brand_id')
     else
        Query.SQL.Add('SELECT DISTINCT Group_id,Subgroup_id,Brand_id FROM [005] where Group_id > 0 and Subgroup_id > 0 AND Brand_id > 0 ORDER BY Group_id,Subgroup_id,Brand_id');
    }
    Query.Open;

    Discaunt_Tree.OnChange := nil;
    Discaunt_Tree.NodeDataSize := SizeOf(TVSTRecord);
    AddItemsBase := Discaunt_Tree.AddChild(Discaunt_Tree.RootNode);
    TreeData := Discaunt_Tree.GetNodeData(AddItemsBase);
    if not (vsInitialized in AddItemsBase.States) then
      Discaunt_Tree.ReinitNode(AddItemsBase, False);

    if Assigned(AddItemsBase) then
    begin
      TreeData.ElementName0 := 'Весь ассортимент';
      TreeData.ElementName1 := '';
      TreeData.ElementName2 := '';
      fDisc := Data.GetDiscount(0,0,0,TRUE);
      fDisc := (1 - fDisc)*100;
      if fDisc > 0 then
        TreeData.ElementName3 := FloatToStr(fDisc);

      fDisc := Data.GetMargin(0,0,0,TRUE);
      fDisc := (1 - fDisc)*100;
      if fDisc > 0 then
        TreeData.ElementName4 := FloatToStr(fDisc);


      TreeData.iGroupe := 0;
      TreeData.iSubGroupe := 0;
      TreeData.iBrand := 0;
    end;

    sOldIndexName := Data.GroupTable.IndexName;
    if Data.GroupTable.IndexName <> 'GrId' then
      Data.GroupTable.IndexName := 'GrId';

    gr := 0;
    sgr := 0;

    while not Query.EOF do
    begin
      if gr <> Query.FieldByName('Group_id').AsInteger then
      begin
             sgr := 0;
             gr := Query.FieldByName('Group_id').AsInteger;
             if Data.GroupTable.FindKey([gr]) then
             begin
                treeGruope := Discaunt_Tree.AddChild(AddItemsBase);
                TreeData := Discaunt_Tree.GetNodeData(treeGruope);
                if Assigned(treeGruope) then
                begin
                  TreeData.ElementName0 := Data.GroupTable.FieldByName('Group_descr').AsString;
                  TreeData.ElementName1 := '';
                  TreeData.ElementName2 := '';
                  TreeData.iGroupe := gr;
                  TreeData.iSubGroupe := 0;
                  TreeData.iBrand := 0;

                  fDisc := Data.GetDiscount(gr,0,0,TRUE);
                  fDisc := (1 - fDisc)*100;
                   if fDisc > 0 then
                    TreeData.ElementName3 := FloatToStr(fDisc);

                  fDisc := Data.GetMargin(gr,0,0,TRUE);
                  fDisc := (1 - fDisc)*100;
                   if fDisc > 0 then
                    TreeData.ElementName4 := FloatToStr(fDisc);


                end;

             end
             else
             begin
               Query.Next;
               Continue;
             end;
          end;

          if sgr <> Query.FieldByName('Subgroup_id').AsInteger then
           begin
             sgr := Query.FieldByName('Subgroup_id').AsInteger;
             if Data.GroupTable.FindKey([gr,sgr]) then
             begin

               treeSubGruope := Discaunt_Tree.AddChild(treeGruope);
               TreeData := Discaunt_Tree.GetNodeData(treeSubGruope);
               if Assigned(treeSubGruope) then
                begin
                  TreeData.ElementName0 := Data.GroupTable.FieldByName('Group_descr').AsString;
                  TreeData.ElementName1 := Data.GroupTable.FieldByName('subgroup_descr').AsString;
                  TreeData.ElementName2 := '';
                  TreeData.iGroupe := gr;
                  TreeData.iSubGroupe := sgr;

                  fDisc := Data.GetDiscount(gr,sgr,0,TRUE);
                  fDisc := (1 - fDisc)*100;
                   if fDisc > 0 then
                    TreeData.ElementName3 := FloatToStr(fDisc);

                  fDisc := Data.GetMargin(gr,sgr,0,TRUE);
                  fDisc := (1 - fDisc)*100;
                   if fDisc > 0 then
                    TreeData.ElementName4 := FloatToStr(fDisc);

                  TreeData.iBrand := 0;
                end;
             end
             else
             begin
               Query.Next;
               Continue;
             end;
          end;

          br := Query.FieldByName('Brand_id').AsInteger;
          Data.BrandTable.FindKey([br]);
            treeBrand := Discaunt_Tree.AddChild(treeSubGruope);
            TreeData := Discaunt_Tree.GetNodeData(treeBrand);
            if Assigned(treeBrand) then
                begin
                  TreeData.ElementName0 := Data.GroupTable.FieldByName('Group_descr').AsString;
                  TreeData.ElementName1 := Data.GroupTable.FieldByName('subgroup_descr').AsString;
                  TreeData.ElementName2 := Data.ReBranding(Data.BrandTable.FieldByName('Description').AsString);
                  TreeData.iGroupe := gr;
                  TreeData.iSubGroupe := sgr;
                  TreeData.iBrand := br;

//                  fDisc := Data.GetDiscount(gr,sgr,br,TRUE);
//                  fDisc := (1 - fDisc)*100;
                  fDisc := Query.FieldByName('Discount').AsFloat;
                   if fDisc > 0 then
                    TreeData.ElementName3 := FloatToStr(fDisc);

        //          fDisc := Data.GetMargin(gr,sgr,br,TRUE);
        //          fDisc := (1 - fDisc)*100;
                  fDisc := Query.FieldByName('Margin').AsFloat;
                   if fDisc > 0 then
                    TreeData.ElementName4 := FloatToStr(fDisc);

                end;

          Query.Next;
        end;
      Query.Close;
      Discaunt_Tree.SortTree(0,sdAscending,TRUE);
      Discaunt_Tree.Expanded[Discaunt_Tree.GetFirstChild(nil)] := True;
      exit;
    end;

//по брендам--------------------------------------------------------------------
    Discaunt_Tree.Header.Columns[0].Text := 'Бренд\Подгруппа';
    Query.SQL.Add('SELECT DISTINCT [005].Brand_id,[005].Group_id,[005].Subgroup_id, [038].Discount,[038].Margin FROM [005] LEFT JOIN [038] on [005].Group_id = [038].Gr_id and [005].Subgroup_id = [038].SUBGR_ID AND [005].Brand_id = [038].BRAND_ID AND [038].CLI_ID = '''+Main.ReplaceLeftSymbol(ClientIdEd.Text)+''' where Group_id > 0 and Subgroup_id > 0 AND Brand_id > 0 ORDER BY Brand_id,Group_id,Subgroup_id');
//  Query.SQL.Add('SELECT DISTINCT Brand_id,Group_id,Subgroup_id FROM [005] where Group_id > 0 and Subgroup_id > 0 AND Brand_id > 0 ORDER BY Brand_id,Subgroup_id');
      Query.Open;

     Discaunt_Tree.OnChange := nil;
     Discaunt_Tree.NodeDataSize := SizeOf(TVSTRecord);
     AddItemsBase := Discaunt_Tree.AddChild(Discaunt_Tree.RootNode);
     TreeData := Discaunt_Tree.GetNodeData(AddItemsBase);
     if not (vsInitialized in AddItemsBase.States) then
       Discaunt_Tree.ReinitNode(AddItemsBase, False);
       
     if Assigned(AddItemsBase) then
        begin
          TreeData.ElementName0 := 'Весь ассортимент';
          TreeData.ElementName1 := '';
          TreeData.ElementName2 := '';
          fDisc := Data.GetDiscount(0,0,0,TRUE);
          fDisc := (1 - fDisc)*100;
          if fDisc > 0 then
            TreeData.ElementName3 := FloatToStr(fDisc);

          fDisc := Data.GetMargin(0,0,0,TRUE);
          fDisc := (1 - fDisc)*100;
          if fDisc > 0 then
            TreeData.ElementName4 := FloatToStr(fDisc);


          TreeData.iGroupe := 0;
          TreeData.iSubGroupe := 0;
          TreeData.iBrand := 0;
        end;

     sOldIndexName := Data.GroupTable.IndexName;
     if Data.GroupTable.IndexName <> 'GrId' then
         Data.GroupTable.IndexName := 'GrId';

     gr := 0;
     sgr := 0;
     br := 0;

     while not Query.EOF do
      begin
       if br <> Query.FieldByName('Brand_id').AsInteger then
       begin
          sgr := 0;
          gr  :=0;
          br := Query.FieldByName('Brand_id').AsInteger;

          treeBrand := Discaunt_Tree.AddChild(AddItemsBase);
          TreeData := Discaunt_Tree.GetNodeData(treeBrand);
          Data.BrandTable.FindKey([br]);
          sBrand := Data.ReBranding(Data.BrandTable.FieldByName('Description').AsString);
          if Assigned(treeBrand) then
           begin
              TreeData.ElementName0 := sBrand;
              TreeData.ElementName1 := '';
              TreeData.ElementName2 := '';

              TreeData.iGroupe := 0;
              TreeData.iSubGroupe := 0;
              TreeData.iBrand := br;

              fDisc := Data.GetDiscount(gr,sgr,br,TRUE);
              fDisc := (1 - fDisc)*100;
              if fDisc > 0 then
                  TreeData.ElementName3 := FloatToStr(fDisc);

              fDisc := Data.GetMargin(gr,sgr,br,TRUE);
              fDisc := (1 - fDisc)*100;
              if fDisc > 0 then
                 TreeData.ElementName4 := FloatToStr(fDisc);
           end
           else
           begin
                Query.Next;
                 Continue;
           end;
       end;

       if gr <> Query.FieldByName('Group_id').AsInteger then
          begin
             sgr := 0;
             gr := Query.FieldByName('Group_id').AsInteger;
          end;

       if sgr <> Query.FieldByName('Subgroup_id').AsInteger then
       begin
          sgr := Query.FieldByName('Subgroup_id').AsInteger;
          if Data.GroupTable.FindKey([gr,sgr]) then
          begin
             treeSubGruope := Discaunt_Tree.AddChild(treeBrand);
             TreeData := Discaunt_Tree.GetNodeData(treeSubGruope);

             if Assigned(treeSubGruope) then
             begin
                  TreeData.ElementName0 := '';
                  TreeData.ElementName1 := Data.GroupTable.FieldByName('subgroup_descr').AsString;
                  TreeData.ElementName2 := '';
                  TreeData.iGroupe := gr;
                  TreeData.iSubGroupe := sgr;
                  TreeData.iSubGroupe:=br;

                  {


                  }
//                  fDisc := Data.GetDiscount(gr,sgr,br,TRUE);
//                  fDisc := (1 - fDisc)*100;
                   fDisc := Query.FieldByName('Discount').AsFloat;
                   if fDisc > 0 then
                    TreeData.ElementName3 := FloatToStr(fDisc);

//                   fDisc := Data.GetMargin(gr,sgr,br,TRUE);
//                   fDisc := (1 - fDisc)*100;
                   fDisc := Query.FieldByName('Margin').AsFloat;
                   if fDisc > 0 then
                    TreeData.ElementName4 := FloatToStr(fDisc);
                  TreeData.iBrand := br;
             end;
          end;
       end;
     Query.Next;
    end;
    Query.Close;
    Discaunt_Tree.SortTree(0,sdAscending,TRUE);

  Discaunt_Tree.Expanded[Discaunt_Tree.GetFirstChild(nil)] := True;
end;
*)

procedure TClientIDEdit.LoadTree_TimerTimer(Sender: TObject);
begin
  LoadTree_Timer.Enabled := FALSE;

  StartWait;
  try
    loadTreeMem;
  finally
    StopWait;
  end;
end;

procedure TClientIDEdit.miTreeCollapseClick(Sender: TObject);
var
  treeNode: PVirtualNode;
begin
  inherited;
  treeNode := Discaunt_Tree.GetFirst();
  while Assigned(treeNode) do
  begin
    if treeNode.ChildCount > 0 then
      Discaunt_Tree.Expanded[treeNode] := FALSE;
    treeNode := Discaunt_Tree.GetNext(treeNode, true);
  end;
  treeNode := Discaunt_Tree.GetFirst();
  Discaunt_Tree.ScrollIntoView(treeNode,FALSE,FALSE);
end;

procedure TClientIDEdit.miTreeExpandClick(Sender: TObject);
var
  treeNode: PVirtualNode;
begin
  inherited;
  treeNode := Discaunt_Tree.GetFirst();
  while Assigned(treeNode) do
  begin
    if treeNode.ChildCount > 0 then
      Discaunt_Tree.Expanded[treeNode] := TRUE;
    treeNode := Discaunt_Tree.GetNext(treeNode, true);
  end;
  treeNode := Discaunt_Tree.GetFirst();
  Discaunt_Tree.ScrollIntoView(treeNode,FALSE,FALSE);
end;

procedure TClientIDEdit.CacheDiscounts;
var
  aQuery: TDBISamQuery;
begin
  mem038.Close;

  if (not mem038.Exists) then
  begin
    Data.CopyMaketTable(mem038, Data.DiscountTable);
    TestTable(mem038);
  end
  else
    mem038.EmptyTable;

  aQuery := TDBISamQuery.Create(nil);
  try
    aQuery.DatabaseName := Data.Database.DatabaseName;
    aQuery.SQL.Text :=
      ' INSERT INTO "Memory\mem038" ' +
      ' SELECT * FROM [038] ';
    aQuery.ExecSQL;
  finally
    aQuery.Free;
  end;
end;


procedure TClientIDEdit.LoadTreeMem;
var
  gr, sgr, br: integer;
  sOldIndexName:string;
  TreeData: PVSTRecord;
  AddItemsBase, treeGruope,treeBrand, treeSubGruope: PVirtualNode;
  fDisc: real;
  sBrand, sFilter, sID: string;
begin
  Discaunt_Tree.Clear;
  Query.SQL.Clear;
  Query.Close;

  sID := Main.ReplaceLeftSymbol(ClientIdEd.Text);
  ClientIdEd.Text := sID;

  if sID = '' then
    Exit;

  fLoadedClientID := sID;  

  mem038.Open;
  with mem038 do
  begin
    DisableControls;
    if IndexName <> 'CLI' then
      IndexName := 'CLI';
    sFilter := sID;
    SetRange([sFilter], [sFilter]);
    EnableControls;
  end;

//по группам--------------------------------------------------------------------
  if TabView.TabIndex = 0 then
  begin
    Discaunt_Tree.Header.Columns[0].Text := 'Группа\Подгруппа\Бренд';

    Query.SQL.Text :=
      ' SELECT DISTINCT [005].Brand_id, [005].Group_id, [005].Subgroup_id, "Memory\mem038".Discount, "Memory\mem038".Margin ' +
      ' FROM [005] LEFT JOIN "Memory\mem038" on [005].Group_id = "Memory\mem038".Gr_id and [005].Subgroup_id = "Memory\mem038".SUBGR_ID AND [005].Brand_id = "Memory\mem038".BRAND_ID AND "Memory\mem038".CLI_ID = '''+Main.ReplaceLeftSymbol(ClientIdEd.Text)+'''' +
      ' where Group_id > 0 and Subgroup_id > 0 AND Brand_id > 0 ' +
      ' ORDER BY Group_id,Subgroup_id,Brand_id';
    {
      SELECT [005].Brand_id,[005].Group_id,[005].Subgroup_id, [038].Discount,[038].Margin FROM [005] JOIN [038] on [005].Group_id = [038].Gr_id and
      [005].Subgroup_id = [038].SUBGR_ID AND
      [005].Brand_id = [038].BRAND_ID
      AND [038].CLI_ID = '616220'

     if Data.CatFilterTable.Active then
        Query.SQL.Add('SELECT DISTINCT Group_id,Subgroup_id,Brand_id FROM [005] where Group_id > 0 and Subgroup_id > 0 AND Brand_id > 0 ORDER BY Group_id,Subgroup_id,Brand_id')
     else
        Query.SQL.Add('SELECT DISTINCT Group_id,Subgroup_id,Brand_id FROM [005] where Group_id > 0 and Subgroup_id > 0 AND Brand_id > 0 ORDER BY Group_id,Subgroup_id,Brand_id');
    }
    Query.Open;

    Discaunt_Tree.OnChange := nil;
    Discaunt_Tree.NodeDataSize := SizeOf(TVSTRecord);
    AddItemsBase := Discaunt_Tree.AddChild(Discaunt_Tree.RootNode);
    TreeData := Discaunt_Tree.GetNodeData(AddItemsBase);
    if not (vsInitialized in AddItemsBase.States) then
      Discaunt_Tree.ReinitNode(AddItemsBase, False);

    if Assigned(AddItemsBase) then
    begin
      TreeData.ElementName0 := 'Весь ассортимент';
      TreeData.ElementName1 := '';
      TreeData.ElementName2 := '';
      fDisc := GetDiscountMem(0, 0, 0, True);
      fDisc := (1 - fDisc)*100;
      if fDisc <> 0 then
        TreeData.ElementName3 := FloatToStr(XRound(fDisc, 2));
      edDiscGlobal.Text := FloatToStr(XRound(fDisc, 2));

      fDisc := GetMarginMem(0,0,0,TRUE);
      fDisc := (fDisc - 1)*100;
      if fDisc <> 0 then
        TreeData.ElementName4 := FloatToStr(XRound(fDisc, 2));

      TreeData.iGroupe := 0;
      TreeData.iSubGroupe := 0;
      TreeData.iBrand := 0;
    end;

    sOldIndexName := Data.GroupTable.IndexName;
    if Data.GroupTable.IndexName <> 'GrId' then
      Data.GroupTable.IndexName := 'GrId';

    gr := 0;
    sgr := 0;

    while not Query.EOF do
    begin
      if gr <> Query.FieldByName('Group_id').AsInteger then
      begin
        sgr := 0;
        gr := Query.FieldByName('Group_id').AsInteger;
        if Data.GroupTable.FindKey([gr]) then
        begin
          treeGruope := Discaunt_Tree.AddChild(AddItemsBase);
          TreeData := Discaunt_Tree.GetNodeData(treeGruope);
          if Assigned(treeGruope) then
          begin
            TreeData.ElementName0 := Data.GroupTable.FieldByName('Group_descr').AsString;
            TreeData.ElementName1 := '';
            TreeData.ElementName2 := '';
            TreeData.iGroupe := gr;
            TreeData.iSubGroupe := 0;
            TreeData.iBrand := 0;

            fDisc := GetDiscountMem(gr,0,0,TRUE);
            fDisc := (1 - fDisc)*100;
            if fDisc <> 0 then
              TreeData.ElementName3 := FloatToStr(XRound(fDisc, 2));

            fDisc := GetMarginMem(gr,0,0,TRUE);
            fDisc := (fDisc-1)*100;
            if fDisc <> 0 then
              TreeData.ElementName4 := FloatToStr(XRound(fDisc, 2));
          end;
        end
        else
          begin
            Query.Next;
            Continue;
          end;
        end;

        if sgr <> Query.FieldByName('Subgroup_id').AsInteger then
        begin
          sgr := Query.FieldByName('Subgroup_id').AsInteger;
          if Data.GroupTable.FindKey([gr,sgr]) then
          begin
            treeSubGruope := Discaunt_Tree.AddChild(treeGruope);
            TreeData := Discaunt_Tree.GetNodeData(treeSubGruope);
            if Assigned(treeSubGruope) then
            begin
              TreeData.ElementName0 := Data.GroupTable.FieldByName('Group_descr').AsString;
              TreeData.ElementName1 := Data.GroupTable.FieldByName('subgroup_descr').AsString;
              TreeData.ElementName2 := '';
              TreeData.iGroupe := gr;
              TreeData.iSubGroupe := sgr;

              fDisc := GetDiscountMem(gr,sgr,0,TRUE);
              fDisc := (1 - fDisc)*100;
              if fDisc <> 0 then
                TreeData.ElementName3 := FloatToStr(XRound(fDisc, 2));

              fDisc := GetMarginMem(gr,sgr,0,TRUE);
              fDisc := (fDisc - 1)*100;
              if fDisc <> 0 then
                TreeData.ElementName4 := FloatToStr(XRound(fDisc, 2));

              TreeData.iBrand := 0;
            end;
          end
          else
          begin
            Query.Next;
            Continue;
          end;
        end;

        br := Query.FieldByName('Brand_id').AsInteger;
        Data.BrandTable.FindKey([br]);
        treeBrand := Discaunt_Tree.AddChild(treeSubGruope);
        TreeData := Discaunt_Tree.GetNodeData(treeBrand);
        if Assigned(treeBrand) then
        begin
          TreeData.ElementName0 := Data.GroupTable.FieldByName('Group_descr').AsString;
          TreeData.ElementName1 := Data.GroupTable.FieldByName('subgroup_descr').AsString;
          TreeData.ElementName2 := Data.ReBranding(Data.BrandTable.FieldByName('Description').AsString);
          TreeData.iGroupe := gr;
          TreeData.iSubGroupe := sgr;
          TreeData.iBrand := br;

//                  fDisc := Data.GetDiscount(gr,sgr,br,TRUE);
//                  fDisc := (1 - fDisc)*100;
          fDisc := Query.FieldByName('Discount').AsFloat;
          if fDisc <> 0 then
            TreeData.ElementName3 := FloatToStr(XRound(fDisc, 2));

        //          fDisc := Data.GetMargin(gr,sgr,br,TRUE);
        //          fDisc := (1 - fDisc)*100;
          fDisc := Query.FieldByName('Margin').AsFloat;
          if fDisc <> 0 then
            TreeData.ElementName4 := FloatToStr(XRound(fDisc, 2));

        end;

        Query.Next;
      end;
      Query.Close;
      Discaunt_Tree.SortTree(0,sdAscending,TRUE);
      Discaunt_Tree.Expanded[Discaunt_Tree.GetFirstChild(nil)] := True;
      Exit;
    end;

//по брендам--------------------------------------------------------------------
    Discaunt_Tree.Header.Columns[0].Text := 'Бренд\Подгруппа';
    Query.SQL.Text :=
      ' SELECT DISTINCT [005].Brand_id, [005].Group_id, [005].Subgroup_id, "Memory\mem038".Discount, "Memory\mem038".Margin FROM [005] ' +
      ' LEFT JOIN "Memory\mem038" on [005].Group_id = "Memory\mem038".Gr_id and [005].Subgroup_id = "Memory\mem038".SUBGR_ID AND [005].Brand_id = "Memory\mem038".BRAND_ID AND "Memory\mem038".CLI_ID = '''+Main.ReplaceLeftSymbol(ClientIdEd.Text)+'''' +
      ' where Group_id > 0 and Subgroup_id > 0 AND Brand_id > 0 ' +
      ' ORDER BY Brand_id, Group_id, Subgroup_id ';
//  Query.SQL.Add('SELECT DISTINCT Brand_id,Group_id,Subgroup_id FROM [005] where Group_id > 0 and Subgroup_id > 0 AND Brand_id > 0 ORDER BY Brand_id,Subgroup_id');
    Query.Open;

    Discaunt_Tree.OnChange := nil;
    Discaunt_Tree.NodeDataSize := SizeOf(TVSTRecord);
    AddItemsBase := Discaunt_Tree.AddChild(Discaunt_Tree.RootNode);
    TreeData := Discaunt_Tree.GetNodeData(AddItemsBase);
    if not (vsInitialized in AddItemsBase.States) then
      Discaunt_Tree.ReinitNode(AddItemsBase, False);

    if Assigned(AddItemsBase) then
    begin
      TreeData.ElementName0 := 'Весь ассортимент';
      TreeData.ElementName1 := '';
      TreeData.ElementName2 := '';
      fDisc := GetDiscountMem(0, 0, 0, TRUE);
      fDisc := (1 - fDisc) * 100;
      if fDisc <> 0 then
        TreeData.ElementName3 := FloatToStr(XRound(fDisc, 2));
      edDiscGlobal.Text := FloatToStr(XRound(fDisc, 2));


      fDisc := GetMarginMem(0, 0, 0, TRUE);
      fDisc := (fDisc - 1) * 100;
      if fDisc <> 0 then
        TreeData.ElementName4 := FloatToStr(XRound(fDisc, 2));


      TreeData.iGroupe := 0;
      TreeData.iSubGroupe := 0;
      TreeData.iBrand := 0;
    end;

    sOldIndexName := Data.GroupTable.IndexName;
    if Data.GroupTable.IndexName <> 'GrId' then
      Data.GroupTable.IndexName := 'GrId';

    gr := 0;
    sgr := 0;
    br := 0;

    while not Query.EOF do
    begin
      if br <> Query.FieldByName('Brand_id').AsInteger then
      begin
        sgr := 0;
        gr  :=0;
        br := Query.FieldByName('Brand_id').AsInteger;

        treeBrand := Discaunt_Tree.AddChild(AddItemsBase);
        TreeData := Discaunt_Tree.GetNodeData(treeBrand);
        Data.BrandTable.FindKey([br]);
        sBrand := Data.ReBranding(Data.BrandTable.FieldByName('Description').AsString);
        if Assigned(treeBrand) then
        begin
          TreeData.ElementName0 := sBrand;
          TreeData.ElementName1 := '';
          TreeData.ElementName2 := '';

          TreeData.iGroupe := 0;
          TreeData.iSubGroupe := 0;
          TreeData.iBrand := br;

          fDisc := GetDiscountMem(gr,sgr,br,TRUE);
          fDisc := (1 - fDisc)*100;
          if fDisc <> 0 then
            TreeData.ElementName3 := FloatToStr(XRound(fDisc, 2));

          fDisc := GetMarginMem(gr,sgr,br,TRUE);
          fDisc := (fDisc - 1)*100;
          if fDisc <> 0 then
            TreeData.ElementName4 := FloatToStr(XRound(fDisc, 2));
        end
        else
        begin
          Query.Next;
          Continue;
        end;
      end;

       if gr <> Query.FieldByName('Group_id').AsInteger then
          begin
             sgr := 0;
             gr := Query.FieldByName('Group_id').AsInteger;
          end;

       if sgr <> Query.FieldByName('Subgroup_id').AsInteger then
       begin
          sgr := Query.FieldByName('Subgroup_id').AsInteger;
          if Data.GroupTable.FindKey([gr,sgr]) then
          begin
             treeSubGruope := Discaunt_Tree.AddChild(treeBrand);
             TreeData := Discaunt_Tree.GetNodeData(treeSubGruope);

             if Assigned(treeSubGruope) then
             begin
                  TreeData.ElementName0 := '';
                  TreeData.ElementName1 := Data.GroupTable.FieldByName('subgroup_descr').AsString;
                  TreeData.ElementName2 := '';
                  TreeData.iGroupe := gr;
                  TreeData.iSubGroupe := sgr;
                  TreeData.iBrand := br;

                  {


                  }
//                  fDisc := Data.GetDiscount(gr,sgr,br,TRUE);
//                  fDisc := (1 - fDisc)*100;
                   fDisc := Query.FieldByName('Discount').AsFloat;
                   if fDisc <> 0 then
                    TreeData.ElementName3 := FloatToStr(XRound(fDisc, 2));

//                   fDisc := Data.GetMargin(gr,sgr,br,TRUE);
//                   fDisc := (1 - fDisc)*100;
                   fDisc := Query.FieldByName('Margin').AsFloat;
                   if fDisc <> 0 then
                    TreeData.ElementName4 := FloatToStr(XRound(fDisc, 2));
                  TreeData.iBrand := br;
        end;
      end;
    end;
    Query.Next;
  end;
  Query.Close;
  Discaunt_Tree.SortTree(0, sdAscending, TRUE);

  Discaunt_Tree.Expanded[Discaunt_Tree.GetFirstChild(nil)] := True;
end;

procedure TClientIDEdit.saveTreeMem(isBrandView: Boolean);
var
  TreeData: PVSTRecord;
  treeNode: PVirtualNode;
  sFilter: string;
  sID: string;
begin
  sID := Main.ReplaceLeftSymbol(ClientIdEd.Text);
  ClientIdEd.Text := sID;

  Query.SQL.Clear;
  if isBrandView then
    Query.SQL.Add('UPDATE "Memory\mem038" SET bDelete = 1 WHERE brand_id > 0 AND CLI_ID = ''' + sID + '''')
  else
    Query.SQL.Add('UPDATE "Memory\mem038" SET bDelete = 1 WHERE CLI_ID = ''' + sID + '''');

  Query.ExecSQL;
  Query.Close;

  mem038.Open;
  with mem038 do
  begin
    DisableControls;
    if IndexName <> 'CLI' then
      IndexName := 'CLI';
    sFilter := sID;
    SetRange([sFilter], [sFilter]);
    EnableControls;
  end;

  treeNode := Discaunt_Tree.GetFirst();
  while Assigned(treeNode) do
  begin
    TreeData :=  Discaunt_Tree.GetNodeData(treeNode);
    if (TreeData.ElementName3 <> '') or (TreeData.ElementName4 <> '') then
    begin
      with mem038 do
      begin
        sFilter := 'GR_ID = '+inttostr(TreeData.iGroupe)+' AND SUBGR_ID = '+inttostr(TreeData.iSubGroupe)+ ' AND BRAND_ID = '+inttostr(TreeData.iBrand);
        Filter := sFilter;
        Filtered := TRUE;
        if EOF then
        begin
          Append;
          FieldByName('CLI_ID').AsString := sID;
          FieldByName('GR_ID').AsInteger := TreeData.iGroupe;
          FieldByName('SUBGR_ID').AsInteger := TreeData.iSubGroupe;
          FieldByName('BRAND_ID').AsInteger := TreeData.iBrand;
          if TreeData.ElementName3 <> '' then
            FieldByName('Discount').AsFloat := Main.AToFloat(TreeData.ElementName3)
          else
            FieldByName('Discount').AsFloat := 0;

          if TreeData.ElementName4 <> '' then
            FieldByName('Margin').AsFloat := Main.AToFloat(TreeData.ElementName4)
          else
            FieldByName('Margin').AsFloat := 0;

          FieldByName('bDelete').AsInteger := 0;
          Post;
        end
        else
        begin
          Edit;
          if TreeData.ElementName3 <> '' then
            FieldByName('Discount').AsFloat := Main.AToFloat(TreeData.ElementName3)
          else
            FieldByName('Discount').AsFloat := 0;

          if TreeData.ElementName4 <> '' then
            FieldByName('Margin').AsFloat := Main.AToFloat(TreeData.ElementName4)
          else
            FieldByName('Margin').AsFloat := 0;
          FieldByName('bDelete').AsInteger := 0;
          Post;
        end;
      end;
    end;
    treeNode := Discaunt_Tree.GetNext(treeNode, True); 
  end;
  mem038.Close;

  Query.SQL.Clear;
  Query.SQL.Add('DELETE from "Memory\mem038" WHERE (Margin = 0 OR Margin IS NULL) AND bDelete = 1');
  Query.ExecSQL;
  Query.Close;

  Query.SQL.Clear;
  Query.SQL.Add('UPDATE "Memory\mem038" SET Discount = NULL WHERE bDelete = 1 AND CLI_ID = '''+sID+'''');
  Query.ExecSQL;
  Query.Close;

  Query.SQL.Clear;
  Query.SQL.Add('UPDATE "Memory\mem038" SET bDelete = 0 WHERE bDelete = 1 AND CLI_ID = ''' + sID + '''');
  Query.ExecSQL;
  Query.Close;
end;


procedure TClientIDEdit.SetReadOnlyMode(aReadOnly: Boolean);
begin
  ClientIdEd.Enabled := not aReadOnly;
  DescriptionEd.Enabled := not aReadOnly;
  Email_Edit.Enabled := not aReadOnly;
  TypeComboBox.Enabled := not aReadOnly;
  DeliveryComboBox.Enabled := not aReadOnly;
  Key_Edit.Enabled := not aReadOnly;
  lbEditData.Visible := aReadOnly;
end;

function TClientIDEdit.GetDiscountMem(gr, subgr, br: Integer; bStrictConformity: Boolean = True): Double;
var
  sFilter: string;
begin
  if bStrictConformity then
    sFilter := 'GR_ID = '+inttostr(gr)+' AND SUBGR_ID = '+inttostr(subgr)+ ' AND BRAND_ID = '+inttostr(br)
  else
    sFilter := '(GR_ID = 0 OR GR_ID = '+inttostr(gr)+') AND (SUBGR_ID = 0 OR SUBGR_ID = '+inttostr(subgr)+ ') AND (BRAND_ID = 0 OR BRAND_ID = '+inttostr(br)+')';

  with mem038 do
  begin
     if IndexName <> 'CLI' then
     begin
       IndexName := 'CLI';
       Filtered := FALSE;
     end;


     if Filtered then
     begin
        if sFilter <> Filter then
        begin
          Filter := sFilter;
          Filtered := TRUE;
        end;
     end
     else
     begin
        Filter := sFilter;
        Filtered := TRUE;
     end;

     Result := 1;
     First;
     while not Eof do
     begin
       if FieldByName('Discount').AsFloat <> 0 then
       begin
         Result := 1 - FieldByName('Discount').AsFloat / 100;
         Break;
       end;
       Next;
     end;
  end;
end;

function TClientIDEdit.GetMarginMem(gr, subgr, br: Integer;
  bStrictConformity: Boolean): Double;
var
  sFilter: string;
begin
  if bStrictConformity then
    sFilter := 'GR_ID = '+inttostr(gr)+' AND SUBGR_ID = '+inttostr(subgr)+ ' AND BRAND_ID = '+inttostr(br)
  else
    sFilter := '(GR_ID = 0 OR GR_ID = '+inttostr(gr)+') AND (SUBGR_ID = 0 OR SUBGR_ID = '+inttostr(subgr)+ ') AND (BRAND_ID = 0 OR BRAND_ID = '+inttostr(br)+')';

  with mem038 do
  begin
     if IndexName <> 'CLI' then
     begin
       IndexName := 'CLI';
       Filtered := FALSE;
     end;


     if Filtered then
     begin
        if sFilter <> Filter then
        begin
          Filter := sFilter;
          Filtered := TRUE;
        end;
     end
     else
     begin
        Filter := sFilter;
        Filtered := TRUE;
     end;

     Result := 1;
     First;
     while not Eof do
     begin
       if FieldByName('Margin').AsFloat <> 0 then
       begin
         Result := 1 + FieldByName('Margin').AsFloat / 100;
         Break;
       end;
       Next;
     end;
  end;
end;


procedure TClientIDEdit.Key_EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (ssCtrl in Shift) and (ssAlt in Shift) and (ssShift in Shift) then
    if Key = 76{l} then
    begin
      Key := 0;
      LoadFromFile_BitBtnClick(nil);
    end;
end;

procedure TClientIDEdit.lbEditDataClick(Sender: TObject);
begin
  inherited;
  SetReadOnlyMode(False);
end;

procedure TClientIDEdit.SaveDiscountsToDB;
var
  aQuery: TDBISamQuery;
  sID: string;
begin
  mem038.Close;
  sID := Main.ReplaceLeftSymbol(ClientIdEd.Text);

  aQuery := TDBISamQuery.Create(nil);
  try
    aQuery.DatabaseName := Data.Database.DatabaseName;
    aQuery.SQL.Text :=
      ' DELETE FROM [038] WHERE CLI_ID = ''' + sID + '''';
    aQuery.ExecSQL;

    aQuery.SQL.Text :=
      ' INSERT INTO [038] ' +
      ' SELECT * FROM "Memory\mem038" WHERE CLI_ID = ''' + sID + '''';
    aQuery.ExecSQL;
(*
    if not DataSource.DataSet.FieldByName('UpdateDisc').AsBoolean then //скидки шате шате
    begin
      aQuery.SQL.Text :=
        ' INSERT INTO [038] ' +
        ' SELECT * FROM "Memory\mem038" WHERE CLI_ID = ''' + sID + '''';
      aQuery.ExecSQL;
    end
    else
    begin
      //сохраняем только глобальную скидку и наценку
      aQuery.SQL.Text :=
        ' INSERT INTO [038] ' +
        ' SELECT * FROM "Memory\mem038" WHERE CLI_ID = ''' + sID + ''' AND GR_ID = 0 AND SUBGR_ID = 0 AND BRAND_ID = 0 ';
      aQuery.ExecSQL;

      //наценки нужно сохранять всегда !!!
      aQuery.SQL.Text :=
        ' INSERT INTO [038] ' +
        ' SELECT * FROM "Memory\mem038" WHERE CLI_ID = ''' + sID + ''' AND Margin <> 0 AND (GR_ID <> 0 OR SUBGR_ID <> 0 OR BRAND_ID <> 0) ';
      aQuery.ExecSQL;

      //обнуляем все скидки кроме глобальной
      aQuery.SQL.Text :=
        ' UPDATE [038] ' +
        ' SET DISCOUNT = NULL WHERE CLI_ID = ''' + sID + ''' AND (GR_ID <> 0 OR SUBGR_ID <> 0 OR BRAND_ID <> 0) ';
      aQuery.ExecSQL;
    end;
*)    
  finally
    aQuery.Free;
  end;
end;

procedure TClientIDEdit.SaveGlobalDiscount;
var
  aRec: TVSTRecord;
  treeNode: PVirtualNode;
begin
  treeNode := Discaunt_Tree.GetFirst();
  if Assigned(treeNode) then
  begin
    PVSTRecord(Discaunt_Tree.GetNodeData(treeNode)).ElementName3 := edDiscGlobal.Text;
    DiscountChanged(PVSTRecord(Discaunt_Tree.GetNodeData(treeNode))^);
  end
  else
  begin
    aRec.iBrand := 0;
    aRec.iGroupe := 0;
    aRec.iSubGroupe := 0;
    aRec.ElementName3 := edDiscGlobal.Text;
    DiscountChanged(aRec, True);
  end;

end;

end.


{
SELECT * FROM [005] JOIN [038] on [005].Group_id = [038].Gr_id and
[005].Subgroup_id = [038].SUBGR_ID AND
[005].Brand_id = [038].BRAND_ID
AND [038].CLI_ID = '616220'
}
