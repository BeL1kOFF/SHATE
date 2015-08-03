unit _BasesProperties;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, StdCtrls, Buttons, _EditBase, ImgList, DB,
  dbisamtb;

type
  TBasesProperties = class(TForm)
    GridBases: TDBGridEh;
    BtnAddBase: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    ImageList1: TImageList;
    Query: TDBISAMQuery;
    BitBtn1: TBitBtn;
    procedure BtnAddBaseClick(Sender: TObject);
    procedure GridBasesCellClick(Column: TColumnEh);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure GridBasesDblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BasesProperties: TBasesProperties;
 implementation
uses _Main, _Data;
{$R *.dfm}

procedure TBasesProperties.BitBtn1Click(Sender: TObject);
begin
   Close;
end;

procedure TBasesProperties.BitBtn4Click(Sender: TObject);
begin
   if Data.TableBases.FieldByName('ID').AsInteger < 1 then
    exit;

  if MessageDlg('Очистить данные о базе: "'+Data.TableBases.FieldByName('Name').AsString+'"', mtWarning, [mbYes, mbNo],0) = mrNo then
    exit;


  // Data.TableBases.Delete;
     with Data.TableBases do
      begin
      Edit;
       FieldByName('Name').Clear;
       FieldByName('MaskName').Clear;
       FieldByName('Activate').Clear;
       FieldByName('Client').Clear;
       FieldByName('Basic').Clear;
      Post;
      end;
end;

procedure TBasesProperties.BitBtn5Click(Sender: TObject);
begin
  if Data.TableBases.FieldByName('ID').AsInteger < 1 then
    exit;

  with TEditBase.Create(nil) do
  begin
    iGlobalCode := Data.TableBases.FieldByName('ID').AsInteger;
    TextCode.Text:= Data.TableBases.FieldByName('Code').AsString;
    TextName.Text :=  Data.TableBases.FieldByName('Name').AsString;
    TextSystemName.Text :=  Data.TableBases.FieldByName('MaskName').AsString;
    TextFileName.Text :=  Data.TableBases.FieldByName('FileName').AsString;
    EdClient.Text := Data.TableBases.FieldByName('Client').AsString;
    ShowModal;
    Free;
  end;

end;

procedure TBasesProperties.BtnAddBaseClick(Sender: TObject);
begin
  with TEditBase.Create(nil) do
  begin
    iGlobalCode := -1;
    ShowModal;
    Free;
  end;

end;

procedure TBasesProperties.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
  var
  rn:integer;
  bSelect:bool;
  bItem:bool;
begin
   CanClose := TRUE;
   bItem:= FALSE;
   with  Data.TableBases do
   begin
      rn := RecNo;
      DisableControls;
      First;
      while not Eof do
      begin
         if FieldByName('Name').AsString <> '' then
         begin
           bItem := TRUE;
         end;

         if (FieldByName('Basic').AsString = '1') and (FieldByName('Activate').AsString = '1') then
         begin
           bSelect := TRUE;
         end;
         Next;
      end;
      EnableControls;
      RecNo := rn;
   end;
   if (not bSelect) and(bItem) then
   begin
     MessageDlg('Не выбрана активная база!',mtInformation,[mbOk],0);
     CanClose := FALSE;
   end;
   bItem := FALSE;
   with  Data.TableBases do
   begin
      rn := RecNo;
      DisableControls;
      First;
      while not Eof do
      begin
         if (FieldByName('Name').AsString = '')and(FieldByName('Activate').AsString = '1') then
         begin
           bItem := TRUE;
         end;
         Next;
      end;
      EnableControls;
      RecNo := rn;
   end;
   if bItem then
   begin
     MessageDlg('Уберите признак активности с недоступных баз!!!',mtInformation,[mbOk],0);
     CanClose := FALSE;
   end;

   Data.LoadBases;

end;

procedure TBasesProperties.FormCreate(Sender: TObject);
begin
  
  BitBtn4.Visible := Main.WriteBasesMode;
  BitBtn5.Visible := Main.WriteBasesMode;
  GridBases.Columns[3].ReadOnly := TRUE;
end;

procedure TBasesProperties.GridBasesCellClick(Column: TColumnEh);
begin
  if Data.TableBases.FieldByName('ID').AsInteger < 1 then
    exit;
  if Data.TableBases.FieldByName('Name').AsString = '' then
    exit;

  If Column.FieldName = 'Basic' then
  begin
     if not Main.WriteBasesMode then
         exit;
     Query.SQL.Clear;
     Query.SQL.Add('UPDATE [090] SET Basic = 0 WHERE ID <> '+Data.TableBases.FieldByName('ID').AsString);
     Query.ExecSQL;
     Query.Close;
      with Data.TableBases do
      begin
          Edit;
            if FieldByName(Column.FieldName).AsInteger > 0  then
               FieldByName(Column.FieldName).Value :=  0
            else
               FieldByName(Column.FieldName).Value :=  1;
          Post;
          Update;
      end;
      exit;
 end;

     If (Column.FieldName = 'Activate') then
     begin
     with Data.TableBases do
     begin
         Edit;
           if FieldByName(Column.FieldName).AsInteger > 0  then
              FieldByName(Column.FieldName).Value :=  0
           else
              FieldByName(Column.FieldName).Value :=  1;
         Post;
         Update;
     end;
          exit;
     end;
end;

procedure TBasesProperties.GridBasesDblClick(Sender: TObject);
begin

  if not Main.WriteBasesMode then
    exit;

  if Data.TableBases.FieldByName('ID').AsInteger < 1 then
    exit;

  with TEditBase.Create(nil) do
  begin
    iGlobalCode := Data.TableBases.FieldByName('ID').AsInteger;
    TextCode.Text:= Data.TableBases.FieldByName('Code').AsString;
    TextName.Text :=  Data.TableBases.FieldByName('Name').AsString;
    TextSystemName.Text :=  Data.TableBases.FieldByName('MaskName').AsString;
    TextFileName.Text :=  Data.TableBases.FieldByName('FileName').AsString;
    EdClient.Text := Data.TableBases.FieldByName('Client').AsString;
    ShowModal;
    Free;
  end;
end;

end.
