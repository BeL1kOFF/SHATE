unit _grsetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvComCtrls, JvCheckTreeView, JvComponentBase,
  JvFormPlacement, StdCtrls, Buttons, DB, dbisamtb;

type
  TMyGroupSetup = class(TForm)
    Tree: TJvCheckTreeView;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FormStorage: TJvFormStorage;
    GroupTable: TDBISAMTable;
    MyGroupTable: TDBISAMTable;
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure TreeToggled(Sender: TObject; Node: TTreeNode);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadTree;
    procedure SaveTree;
  end;

var
  MyGroupSetup: TMyGroupSetup;

implementation

uses _Main;

{$R *.dfm}

procedure TMyGroupSetup.FormCreate(Sender: TObject);
begin
  LoadTree;
end;

procedure TMyGroupSetup.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F10 then
    OkBtn.Click;
end;

procedure TMyGroupSetup.LoadTree;
var
  gr_node, sgr_node: TTreeNode;
  gr: integer;
  gr_chk: boolean;
  gr_descr: string;
begin
  Tree.Items.Clear;
  with MyGroupTable do
  begin
    IndexName := 'GrDescr';
    Open;
  end;
  with GroupTable do
  begin
    IndexName := 'GrId';
    Open;
    First;
    while not Eof do
    begin
      gr := FieldByName('Group_id').AsInteger;
      gr_descr := AnsiUpperCase(FieldByName('Group_descr').AsString);
      gr_node := Tree.Items.AddObject(nil, FieldByName('Group_descr').AsString,
                                           Pointer(gr));
      gr_chk := MyGroupTable.FindKey([gr_descr, '']);
      Tree.Checked[gr_node] := gr_chk;
      while (not Eof) and (FieldByName('Group_id').AsInteger = gr) do
      begin
        sgr_node := Tree.Items.AddChildObject(gr_node,
                             FieldByName('subgroup_descr').AsString,
                             Pointer(FieldByName('subgroup_id').AsInteger));
        Tree.Checked[sgr_node] := MyGroupTable.FindKey([gr_descr,
                                   AnsiUpperCase(FieldByName('subgroup_descr').AsString)]);
        Next;
      end;
    end;
    Close;
  end;
  MyGroupTable.Close;
end;

procedure TMyGroupSetup.OkBtnClick(Sender: TObject);
begin
  SaveTree;
end;


procedure TMyGroupSetup.SaveTree;
var
  i: integer;
begin
  with MyGroupTable do
  begin
    EmptyTable;
    Open;
    for i := 0 to Tree.Items.Count - 1 do
    begin
      if Tree.Checked[Tree.Items[i]] then
      begin
        Append;
        if Tree.Items[i].Level = 0 then
        begin
          FieldByName('Group_id').Value    := Integer(Tree.Items[i].Data);
          FieldByName('Group_descr').Value := AnsiUpperCase(Tree.Items[i].Text);
          FieldByName('Subgroup_id').Value := 0;
        end
        else
        begin
          FieldByName('Group_id').Value       := Integer(Tree.Items[i].Parent.Data);
          FieldByName('Group_descr').Value    := AnsiUpperCase(Tree.Items[i].Parent.Text);
          FieldByName('Subgroup_id').Value    := Integer(Tree.Items[i].Data);
          FieldByName('Subgroup_descr').Value := AnsiUpperCase(Tree.Items[i].Text);
        end;
        Post;
      end;
    end;
    Close;
  end;
end;


procedure TMyGroupSetup.TreeToggled(Sender: TObject; Node: TTreeNode);
begin
  if Tree.Checked[Node] and (Node.Parent <> nil) then
  begin
    Tree.CheckBoxOptions.CascadeOptions := [];
    Tree.Checked[Node.Parent] := True;
    Tree.CheckBoxOptions.CascadeOptions := [poOnCheck,poOnUnCheck];
  end;
end;

end.
