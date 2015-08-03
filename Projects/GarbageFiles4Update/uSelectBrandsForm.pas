unit uSelectBrandsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst;

type
  TSelectBrandsForm = class(TForm)
    clbBrands: TCheckListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    cbSelectAll: TCheckBox;
    btCancel: TButton;
    Button2: TButton;
    Button1: TButton;
    OD: TOpenDialog;
    procedure cbSelectAllClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fReplBrands: TStrings;
    procedure FillBrands;
    function IsAllSelected: Boolean;
  public
    SelectedBrands: TStrings;
    class function Execute(aReplBrands: TStrings; {out} aSelected: TStrings; out anAll: Boolean): Boolean;
  end;

var
  SelectBrandsForm: TSelectBrandsForm;

implementation

{$R *.dfm}

uses
  uMain, adoDBUtils, ADODB;

{ TSelectBrandsForm }

procedure TSelectBrandsForm.Button1Click(Sender: TObject);
var
  f: TextFile;
  s: string;
  i: Integer;
  aCountChecked, aCountUnknown: Integer;
begin
  if OD.Execute(Handle) then
  begin
    cbSelectAll.Checked := False;
    cbSelectAllClick(cbSelectAll);

    aCountChecked := 0;
    aCountUnknown := 0;

    AssignFile(f, OD.FileName);
    Reset(f);
    try
      while not System.Eof(f) do
      begin
        Readln(f, s);
        i := clbBrands.Items.IndexOf(AnsiUpperCase(s));
        if i >= 0 then
        begin
          clbBrands.Checked[i] := True;
          Inc(aCountChecked);
        end
        else
          Inc(aCountUnknown);
      end;
      ShowMessage(Format('Отмечено брендов: %d'#13#10'Нераспознано брендов: %d', [aCountChecked, aCountUnknown]));
    finally
      CloseFile(f);
    end;
  end;
end;

procedure TSelectBrandsForm.Button2Click(Sender: TObject);
var
  i: Integer;
begin

  for i := 0 to clbBrands.Count - 1 do
    if clbBrands.Checked[i] then
      SelectedBrands.Add(clbBrands.Items[i]);
end;

procedure TSelectBrandsForm.cbSelectAllClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to clbBrands.Count - 1 do
    clbBrands.Checked[i] := cbSelectAll.Checked;
end;

class function TSelectBrandsForm.Execute(aReplBrands: TStrings; aSelected: TStrings; out anAll: Boolean): Boolean;
begin
  with TSelectBrandsForm.Create(Application) do
  try
    fReplBrands := aReplBrands;
    Result := ShowModal = mrOK;
    if Result then
    begin
      aSelected.Assign(SelectedBrands);
      anAll := IsAllSelected;
    end;
  finally
    Free;
  end;
end;

procedure TSelectBrandsForm.FillBrands;
var
  q: IQuery;
  aBrandName: string;
begin
  clbBrands.Clear;
  q := makeIQuery(Main.connService, '', clUseClient, ctStatic);
  q.SQL := ' SELECT DISTINCT BRAND FROM CATALOG ORDER BY BRAND ';
  q.Open;
  while not q.EOF do
  begin
    aBrandName := fReplBrands.Values[q.Fields[0].AsString]; //<tecdoc brand>=<service brand>
    if aBrandName = '' then
      aBrandName := q.Fields[0].AsString;
    aBrandName := AnsiUpperCase(aBrandName);

    if clbBrands.Items.IndexOf(aBrandName) = -1 then
      clbBrands.Items.Add(aBrandName);
    q.Next;
  end;
end;

procedure TSelectBrandsForm.FormCreate(Sender: TObject);
begin
  SelectedBrands := TStringList.Create;
end;

procedure TSelectBrandsForm.FormDestroy(Sender: TObject);
begin
  SelectedBrands.Free;
end;

procedure TSelectBrandsForm.FormShow(Sender: TObject);
begin
  FillBrands;
end;

function TSelectBrandsForm.IsAllSelected: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to clbBrands.Count - 1 do
    if not clbBrands.Checked[i] then
      Exit;
  Result := True;
end;

end.

