unit URepairForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, DB, dbisamtb, StdCtrls, ComCtrls, Animate, GIFCtrl,
  ImgList, ExtCtrls;

const
  cDBISAM_READERR = 9217;

type
  TRepairForm = class(TForm)
    Table: TDBISAMTable;
    DataSource1: TDataSource;
    btVerify: TButton;
    MemSearchTable: TDBISAMTable;
    MemGrid: TDBGridEh;
    MemSearchTablename: TStringField;
    MemSearchTableCheck: TBooleanField;
    SearchSource: TDataSource;
    btRepair: TButton;
    lbReport: TLabel;
    MemSearchTablestatus: TIntegerField;
    StatusImageList: TImageList;
    Panel1: TPanel;
    Progress: TProgressBar;
    animWait: TRxGIFAnimator;
    Bevel1: TBevel;
    btRaiseExc: TButton;
    procedure btVerifyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btRepairClick(Sender: TObject);
    procedure TableVerifyProgress(Sender: TObject; const Step: string;
      PercentDone: Word);
    procedure MemGridTitleClick(Column: TColumnEh);
    procedure FormDestroy(Sender: TObject);
    procedure btRaiseExcClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TableRepairProgress(Sender: TObject; const Step: string;
      PercentDone: Word);
  private
    fPath: string;
    BrokenTableList : TStringList;
    fgAbort : Boolean;
  public
    { Public declarations }
  end;

var
  RepairForm: TRepairForm;

implementation

{$R *.dfm}

uses
  _CommonTypes;
  
procedure TRepairForm.btVerifyClick(Sender: TObject);
var
  fail_verify : boolean;
begin
  fgAbort := False;

  Progress.Max := 100;
  Progress.Position := 0;

  Session.ProgressSteps := 100;
  Table.DatabaseName := fPath;
  animWait.visible := true;
  animWait.animate := true;
  MemSearchTable.First;
  fail_verify:= false;


  BrokenTableList.Clear;
  btVerify.Visible := false;
  btRepair.Enabled := false;
  btRaiseExc.Visible := true;

  while not MemSearchTable.Eof  do
  try
    if MemSearchTable.FieldByName('check').AsBoolean then
    begin
      Table.TableName:=MemSearchTable.FieldByName('name').AsString;
      if Table.Exists then
      begin
        MemSearchTable.Edit;
        if Table.VerifyTable then
        Begin
          MemSearchTable.FieldByName('Status').asInteger := 1;
          MemSearchTable.FieldByName('check').AsBoolean := false;
        End
        else
        begin
          MemSearchTable.FieldByName('Status').asInteger := 0;
          fail_verify := true;
          MemSearchTable.FieldByName('check').AsBoolean := True;
        end;
        MemSearchTable.Post;
      end;
    end;
    MemSearchTable.Next;
  except
    on E: EAbort do
    begin
      ShowMessage('Операция прервана!');
      Break;
    end;

    on E: Exception do
    begin
      MemSearchTable.Edit;
      MemSearchTable.FieldByName('Status').asInteger := 0;
      MemSearchTable.Post;
      fail_verify := true;
      MemSearchTable.Next;
    end;
  end;

  btVerify.Visible := True;
  btRepair.Enabled := True;
  btRaiseExc.Visible := false;

  if fail_verify then
    lbReport.Caption := 'Найдены сломанные таблицы!'
  else
    lbReport.Caption := 'Отмеченные таблицы пригодны для пользования!';
  animWait.Visible := false;
  Progress.Position := 0;
end;

procedure TRepairForm.btRaiseExcClick(Sender: TObject);
begin
  fgAbort := true;
end;


procedure TRepairForm.btRepairClick(Sender: TObject);
var
  i: integer;
  fail_repair : boolean;
begin
  fail_repair := false;
  
  btVerify.Enabled := false;
  btRepair.Enabled := false;

  MemSearchTable.First;
  while not MemSearchTable.Eof  do
  begin
    if MemSearchTable.FieldByName('check').AsBoolean then
      BrokenTableList.Add(MemSearchTable.FieldByName('name').AsString);
    MemSearchTable.Next;
  end;

  if BrokenTableList.Count<> 0 then
  begin
    Table.DatabaseName:= fPath;
    for i:=0 to BrokenTableList.Count - 1 do
    begin
      Table.tablename := BrokenTableList[i];
      if Table.RepairTable then //да - была целая; нет - были ошибки
      begin
        MemSearchTable.Locate('Name', BrokenTableList[i], []);
        MemSearchTable.Edit;
        if Table.VerifyTable then
          MemSearchTable.FieldByName('Status').asInteger := 1
        else
        begin
          MemSearchTable.FieldByName('Status').asInteger := 0;
          fail_repair := TRUE;
        end;
        MemSearchTable.FieldByName('Check').AsBoolean := False;
        MemSearchTable.Post;
      end

      else
      begin
        MemSearchTable.Locate('Name', BrokenTableList[i], []);
        MemSearchTable.Edit;
        MemSearchTable.FieldByName('Check').AsBoolean := False;
        MemSearchTable.FieldByName('Status').AsInteger := 1;
        MemSearchTable.Post;
      end;
    end;
  end;

  if not fail_repair then
  begin
    ShowMessage('Сломанные таблицы были восстановлены');
    lbReport.Caption := '';
  end
  else
    ShowMessage('Некоторые таблицы не были восстановлены!');

  BrokenTableList.Clear;
  btVerify.Enabled := True;
  btRepair.Enabled := True;
  animWait.Visible := false;
  Progress.Position := 0;
end;

procedure TRepairForm.FormActivate(Sender: TObject);
begin
    MessageDlg('Программа запущена в сервисном режиме. '#13#10'В этом режиме '+
             'пользователь может проверить работоспособность таблиц, а в случае '+
             'возникновения неисправностей - автоматически устранить их.',mtInformation, [mbYes],0 );

end;

procedure TRepairForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MemSearchTable.Close;
  MemSearchTable.DeleteTable;
end;

procedure TRepairForm.FormCreate(Sender: TObject);



  function Wait(aHandle: Cardinal; aWaitTime: Cardinal): Boolean;
  var
    t: Cardinal;
  begin
    Result := False;

    t := GetTickCount;
    while WaitForSingleObject(aHandle, 200) = WAIT_TIMEOUT do
    begin
      if (GetTickCount - t) > aWaitTime then
        Exit;
      Application.ProcessMessages;
    end;

    Result := True;
  end;

  function KillProcess(const AProcessID: DWord; aWaitTime: Cardinal): Boolean;
  var
    lPID, lCurrentProcPID: DWord;
    lProcHandle: DWord;
  begin
    Result := False;
    try
      lCurrentProcPID := GetCurrentProcessId;
      lPID := AProcessID;
      if (lPID <> INVALID_HANDLE_VALUE) and (lCurrentProcPID <> lPID) then
      begin
        lProcHandle := OpenProcess(PROCESS_TERMINATE or SYNCHRONIZE, False, lPID);
        try
          if lProcHandle = 0 then //или нет прав или завершился
            Exit;

          if aWaitTime > 0 then
          begin
            Result := Wait(lProcHandle, aWaitTime);
            if Result then
              Exit; //сам завершился
          end;

          Windows.TerminateProcess(lProcHandle, 0);
          WaitForSingleObject(lProcHandle, Infinite);
          Result := True;
        finally
          CloseHandle(lProcHandle);
        end;
      end;
    except
      raise EExternalException.Create(SysErrorMessage(GetLastError));
    end;
  end;







var
  searchResult : TSearchRec;
  aSwitch, name : string;
  p : integer;
  isDBISAMTable: Boolean;
  aPID: Integer;
begin

  if FindCmdLineSwitchEx('ServiceMode', ['-','/'], True, True, aSwitch) then
  begin
    aPID := StrToIntDef( Copy(aSwitch, Length('ServiceMode') + 2, MaxInt), 0 );
//    Splash.InfoLabel.Caption := 'Перезапуск...';
//    Splash.Update;
    if aPID > 0 then
      KillProcess(aPID, 1000 * 10{подождем 10 сек});
  end;

  fPath := ExtractFilePath(Application.exename)+'Данные\';
  BrokenTableList := TStringList.Create;
  fgAbort:= false;

  Engine.Active := false;
  Engine.TableBlobExtension := '.3';
  Engine.TableBlobBackupExtension := '.3_';
  Engine.TableBlobUpgradeExtension := '.3$';
  Engine.TableBlobTempExtension := '.3~';
  Engine.TableDataExtension:= '.1';
  Engine.TableDataBackupExtension := '.1_';
  Engine.TableDataUpgradeExtension := '.1$';
  Engine.TableDataTempExtension := '.1~';
  Engine.TableIndexExtension := '.2';
  Engine.TableIndexBackupExtension := '.2_';
  Engine.TableIndexUpgradeExtension := '.2$';
  Engine.TableIndexTempExtension := '.2~';
  Engine.Active := True;

  MemSearchTable.CreateTable;
  MemSearchTable.Open;
  MemGrid.Columns.Items[1].Title.ImageIndex:=3;
  Table.DatabaseName := fPath;

  if FindFirst(fPath+'*.1', faAnyFile, searchResult) = 0 then
  begin
    repeat
      name:= SearchResult.Name;
      p := pos('.1',name);
      delete(name,p,2);
      Table.TableName := name;
       try
         isDBISAMTable := True;
         table.Open;
         table.Close;
       except
         on E: EDBISAMEngineError do
           if E.ErrorCode = cDBISAM_READERR then
             isDBISAMTable := False;
         on E: Exception do
         begin
           //ignore
         end;
       end;
       if isDBISAMTable then
       begin
         MemSearchTable.Append;
         MemSearchTable.FieldByName('Name').asString := name;
         MemSearchTable.FieldByName('Check').AsBoolean := False;
         MemSearchTable.FieldByName('Status').asInteger := 2;
         MemSearchTable.Post;
       end;
    until FindNext(searchResult) <> 0;
    FindClose(searchResult);
    MemSearchTable.Active := true;
  end;
end;

procedure TRepairForm.FormDestroy(Sender: TObject);
begin
  BrokenTableList.free;
end;

procedure TRepairForm.MemGridTitleClick(Column: TColumnEh);
begin
  if Column.Index = 1 then
    if MemGrid.Columns.Items[1].Title.ImageIndex = 3 then
    Begin
      MemGrid.Columns.Items[1].Title.ImageIndex := 4;
      MemSearchTable.First;
      while not MemSearchTable.Eof  do
      Begin
        MemSearchTable.Edit;
        MemSearchTable.FieldByName('Check').asBoolean := true;
        MemSearchTable.Post;
        MemSearchTable.Next;
      End;
    End
    else
    Begin
      MemGrid.Columns.Items[1].Title.ImageIndex := 3;
      MemSearchTable.First;
      While not MemSearchTable.eof do
      Begin
        MemSearchTable.Edit;
        MemSearchTable.FieldByName('Check').asBoolean := false;
        MemSearchTable.Post;
        MemSearchTable.Next;
      End;
    End;
end;

procedure TRepairForm.TableRepairProgress(Sender: TObject; const Step: string;
  PercentDone: Word);
begin
  Progress.position := PercentDone;
  lbReport.Caption := Step+'('+ IntToStr(PercentDone) +')';
  Application.ProcessMessages;
  if fgAbort then
      Abort;
end;

procedure TRepairForm.TableVerifyProgress(Sender: TObject; const Step: string;
  PercentDone: Word);
begin
  Progress.position := PercentDone;
  lbReport.Caption := Step+'('+ IntToStr(PercentDone) +')';
  Application.ProcessMessages;
  if fgAbort then
      Abort;
end;

end.
