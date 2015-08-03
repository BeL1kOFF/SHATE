unit _Auto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponentBase, JvFormPlacement, StdCtrls, Buttons, ComCtrls,
  JvExComCtrls, JvComCtrls, VclUtils, BSStrUt;

type
  TAuto = class(TForm)
    Tree: TJvTreeView;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FormStorage: TJvFormStorage;
    HeaderControl: THeaderControl;
    DetailsBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure TreeExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TreeDblClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure TreeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeSelectionChange(Sender: TObject);
    procedure DetailsBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadTree;
  end;

var
  Auto: TAuto;

implementation

uses _Main, _Data, _AutoInf;

{$R *.dfm}


procedure TAuto.FormCreate(Sender: TObject);
begin
  Data.ManufacturersTable.IndexName := 'Brand';
  Data.ModelsTable.IndexName        := 'MfaText';
  Data.TypesTable.IndexName         := 'Model';
  LoadTree;
  //OkBtn.Enabled := False;
  OkBtn.Enabled := (Tree.Selected <> nil) and (Tree.Selected.Level = 2);
  DetailsBtn.Enabled := (Tree.Selected <> nil) and (Tree.Selected.Level = 2);
end;

procedure TAuto.FormDestroy(Sender: TObject);
begin
  Data.ManufacturersTable.IndexName := '';
  Data.ModelsTable.IndexName        := '';
  Data.TypesTable.IndexName         := '';
end;

procedure TAuto.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F10 then
    OkBtn.Click;
end;

procedure TAuto.FormShow(Sender: TObject);
begin
  Tree.SetFocus;
end;

procedure TAuto.LoadTree;
var
  node: TTreeNode;
begin
  StartWait;
  with Data.ManufacturersTable do
  begin
    IndexName := 'Brand';
    First;
    while not Eof do
    begin
      if not FieldByName('Hide').AsBoolean then
      begin
        node := Tree.Items.AddChildObject(nil, FieldByName('Mfa_brand').AsString,
                                       Pointer(FieldByName('Mfa_id').AsInteger));
        node.HasChildren := True;
        if (Data.Last_mfa <> 0) and (Integer(node.Data) = Data.Last_mfa) then
          node.Expand(False);
      end;
      Next;
    end;
    IndexName := '';
  end;
  StopWait;
end;

procedure TAuto.OkBtnClick(Sender: TObject);
begin
  Data.Auto_type := Integer(Tree.Selected.Data);
  Data.Last_typ  := Integer(Tree.Selected.Data);
  Data.Last_mod  := Integer(Tree.Selected.Parent.Data);
  Data.Last_mfa  := Integer(Tree.Selected.Parent.Parent.Data);
end;

procedure TAuto.DetailsBtnClick(Sender: TObject);
begin
  with TAutoInfo.Create(Application) do
  begin
    Auto_type := Integer(Tree.Selected.Data);
    ShowModal;
    Free;
  end;
  Tree.SetFocus;
end;

procedure TAuto.TreeClick(Sender: TObject);
begin
  //OkBtn.Enabled := (Tree.Selected <> nil) and (Tree.Selected.Level = 2);
end;

procedure TAuto.TreeDblClick(Sender: TObject);
begin
  if Tree.Selected.Level = 2 then
    OkBtn.Click;
end;

procedure TAuto.TreeExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var
  nd: TTreeNode;
begin
  if Node.getFirstChild <> nil then
    exit;
  StartWait;
  if Node.Level = 0 then
  with Data.ModelsTable do
  begin
    SetRange([Integer(Node.Data)], [Integer(Node.Data)]);
    First;
    while not Eof do
    begin
      nd := Tree.Items.AddChildObject(Node,
           LeftStr(Copy(FieldByName('Tex_text').AsString, 1, 26), 26) +
           '   ' + FieldByName('PConText1').AsString + ' - ' +
           FieldByName('PConText2').AsString,
           Pointer(FieldByName('Mod_id').AsInteger));
      nd.HasChildren := True;
      if (Data.Last_mod <> 0) and (Integer(nd.Data) = Data.Last_mod) then
        nd.Expand(False);
      Next;
    end;
    CancelRange;
  end
  else if Node.Level = 1 then
  with Data.TypesTable do
  begin
    SetRange([Integer(Node.Data)], [Integer(Node.Data)]);
    First;
    while not Eof do
    begin
   {  MessageDlg(LeftStr(Copy(FieldByName('CdsText').AsString, 1, 25), 25) + ' ' +
              LeftStr(FieldByName('PConText1').AsString + ' - ' +
              FieldByName('PConText2').AsString, 17) + ' ' +
              LeftStr(FieldByName('Hp_from').AsString + ' л.с.', 9) + ' ' +
              LeftStr(FieldByName('Cylinders').AsString + ' цил.', 6) + ' ' +
              LeftStr(FieldByName('FuelText').AsString, 8) + ' ' +
              FieldByName('Eng_codes').AsString, mtInformation, [mbOk],0);}
      nd := Tree.Items.AddChildObject(Node,
              LeftStr(Copy(FieldByName('CdsText').AsString, 1, 25), 25) + ' ' +
              LeftStr(FieldByName('PConText1').AsString + ' - ' +
              FieldByName('PConText2').AsString, 17) + ' ' +
              LeftStr(FieldByName('Hp_from').AsString + ' л.с.', 9) + ' ' +
              LeftStr(FieldByName('Cylinders').AsString + ' цил.', 6) + ' ' +
              LeftStr(FieldByName('FuelText').AsString, 8) + ' ' +
              FieldByName('Eng_codes').AsString,
              Pointer(FieldByName('Typ_id').AsInteger));
      if (Data.Last_typ <> 0) and (Integer(nd.Data) = Data.Last_typ) then
        nd.Selected := True;
      Next;
    end;
    CancelRange;
  end;
  AllowExpansion := True;
  StopWait;
end;

procedure TAuto.TreeSelectionChange(Sender: TObject);
begin
  OkBtn.Enabled := (Tree.Selected <> nil) and (Tree.Selected.Level = 2);
  DetailsBtn.Enabled := (Tree.Selected <> nil) and (Tree.Selected.Level = 2);
end;

end.
