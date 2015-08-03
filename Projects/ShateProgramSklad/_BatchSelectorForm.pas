unit _BatchSelectorForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, JvBaseDlg, JvSelectDirectory, FileCtrl, FlCtrlEx,
  AdvEdit, AdvEdBtn, AdvDirectoryEdit, AdvGrid, AsgLinks;

type
  TBatchSelectorForm = class(TForm)
    lbDest: TListBox;
    Panel1: TPanel;
    btOK: TButton;
    bAdd: TButton;
    sdDialog: TJvSelectDirectory;
    Splitter1: TSplitter;
    Panel2: TPanel;
    btAddDir: TButton;
    Panel3: TPanel;
    cbDrive: TDriveComboBoxEx;
    lbDirs: TDirectoryListBoxEx;
    Bevel1: TBevel;
    Bevel2: TBevel;
    btLoadFromFile: TButton;
    btSaveToFile: TButton;
    od: TOpenDialog;
    sd: TSaveDialog;
    Splitter2: TSplitter;
    pnFiles: TPanel;
    lbFiles: TFileListBoxEx;
    Label1: TLabel;
    edMask: TEdit;
    btAddFile: TButton;
    btCancel: TButton;
    procedure bAddClick(Sender: TObject);
    procedure lbDirsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbDestKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btAddDirClick(Sender: TObject);
    procedure btLoadFromFileClick(Sender: TObject);
    procedure btSaveToFileClick(Sender: TObject);
    procedure edMaskExit(Sender: TObject);
    procedure edMaskKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbDirsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btAddFileClick(Sender: TObject);
    procedure lbFilesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    fFileMode: Boolean;
    fDefMask: string;
    procedure AddToList(const aItem: string; AllowDuplicates: Boolean = False);
  public
    class function Execute(aRes: TStrings; aFileMode: Boolean; const aCaption: string = ''; const aDefMask: string = '*.*'): Boolean;
  end;

implementation

{$R *.dfm}

{ TBatchSelectorForm }

procedure TBatchSelectorForm.AddToList(const aItem: string; AllowDuplicates: Boolean = False);
begin
  if AllowDuplicates or (lbDest.Items.IndexOf(aItem) = -1) then
    lbDest.Items.Add(aItem)
  else
    ShowMessage('”же есть в списке');
end;

procedure TBatchSelectorForm.bAddClick(Sender: TObject);
begin
  if sdDialog.Execute then
    AddToList(sdDialog.Directory);
end;

procedure TBatchSelectorForm.lbDirsClick(Sender: TObject);
var
 aDir: string;
begin
  aDir := lbDirs.GetItemPath(lbDirs.ItemIndex);
  lbFiles.Directory := aDir;
end;

procedure TBatchSelectorForm.lbDirsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not fFileMode then
    if (Key = VK_RETURN) and (ssCtrl in Shift) then
    begin
      Key := 0;
      btAddDirClick(nil);
    end;
end;

procedure TBatchSelectorForm.lbFilesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if fFileMode then
    if (Key = VK_RETURN) and (ssCtrl in Shift) then
    begin
      Key := 0;
      btAddFileClick(nil);
    end;
end;

procedure TBatchSelectorForm.lbDestKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  aInd: Integer;
begin
  aInd := lbDest.ItemIndex;
  if (Key = VK_DELETE) and (aInd >= 0) then
  begin
    lbDest.Items.Delete(aInd);
    if aInd >= lbDest.Count then
      lbDest.ItemIndex := lbDest.Count - 1
    else
      lbDest.ItemIndex := aInd;
  end;
end;

procedure TBatchSelectorForm.btAddDirClick(Sender: TObject);
begin
  AddToList(lbDirs.GetItemPath(lbDirs.ItemIndex));
end;

procedure TBatchSelectorForm.btAddFileClick(Sender: TObject);
begin
  AddToList(lbFiles.FileName);
end;

procedure TBatchSelectorForm.btLoadFromFileClick(Sender: TObject);
begin
  if od.Execute then
    lbDest.Items.LoadFromFile(od.FileName);
end;

procedure TBatchSelectorForm.btSaveToFileClick(Sender: TObject);
begin
  if sd.Execute then
    lbDest.Items.SaveToFile(sd.FileName);
end;

procedure TBatchSelectorForm.edMaskExit(Sender: TObject);
begin
  lbFiles.Mask := edMask.Text;
end;

procedure TBatchSelectorForm.edMaskKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    edMaskExit(nil);
end;

class function TBatchSelectorForm.Execute(aRes: TStrings; aFileMode: Boolean;
  const aCaption: string = ''; const aDefMask: string = '*.*'): Boolean;
begin
  Result := False;
  with TBatchSelectorForm.Create(Application) do
  try
    if aCaption <> '' then
      Caption := Caption + ' [' + aCaption + ']';
    fFileMode := aFileMode;
    fDefMask := aDefMask;
    if ShowModal = mrOK then
    begin
      Result := True;
      aRes.Assign(lbDest.Items);
    end;
  finally
    Free;
  end;
end;

procedure TBatchSelectorForm.FormShow(Sender: TObject);
begin
  pnFiles.Visible := fFileMode;
  btAddDir.Visible := not fFileMode;
  btAddFile.Visible := fFileMode;
  if not fFileMode then
    lbDirs.FileList := nil
  else
  begin
    edMask.Text := fDefMask;
    lbFiles.Mask := fDefMask;
  end;
end;

end.
