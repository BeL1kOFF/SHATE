{ [kri]
  при закрытии формы обязательно возвращать ModalResult !!!
  mrOK - если закачка начата или завершена успешно
  mrCancel - если закачку прервали или не начинали

}
unit _UpdatesWindows;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, CheckLst, IniFiles, Wininet, ExtCtrls;
const
  PROGRESS_POS = WM_USER+200;
  PROGRESS_UPDATE_NOT_FINISHED  = WM_USER+201;
  PROGRESS_UPDATE_FINISHED = WM_USER+202;
  PROGRESS_UPDATE_STATE = WM_USER+203;
  PROGRESS_SET_MAX_POS = WM_USER+204;
  PROGRESS_UPDATE_ALL_FINISHED = WM_USER+205; // кажется, не используется
  PROGRESS_UPDATE_RESTARTPROG = WM_USER+206;
  PROGRESS_START_UPDATE = WM_USER+320;

type
  TUpdateFileData= class
    State:integer;
    iPos:integer;
    url,descr:string;
    filesize:integer;
    customversion:string;
    localversion:string;
    basename:string;
    mustrestart:integer;
    DescretVersion:integer;
    bUpdate:bool;
  end;

  TUpdatesWindows = class(TForm)
    lbTitle: TLabel;
    CheckListUpdate: TCheckListBox;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    btStart: TBitBtn;
    btCancel: TBitBtn;
    btAbort: TBitBtn;
    btHide: TBitBtn;
    Label3: TLabel;
    Image1: TImage;
    Label4: TLabel;
    Label5: TLabel;
    cbShowInstalledPackages: TCheckBox;
    procedure btCancelClick(Sender: TObject);
    procedure CheckListUpdateClickCheck(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure btAbortClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btHideClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure cbShowInstalledPackagesClick(Sender: TObject);
    procedure CheckListUpdateDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
  private
    fInfCache: TStrings;
    fInfFileName: string;
    fIsExtUpdate: Boolean;
    fShowInstalledPackages: Boolean;
    fTheadCreate: Boolean;
    procedure UpdateButtons(aDownloadInProgress: Boolean);
    procedure ReloadInf(const aFileName: string);
  public
    fServer: string;
    sPath:string;
    sURL:string;
    bCanExit:bool;
    function SetParametrs(sPathName: string; sURLName: string; aSilentMode: Boolean; IsExtUpdate: Boolean): Boolean;
    function DownloadFile(const FileURL, FileName: String): Cardinal;
    procedure SetProgressPos(var Msg: TMessage); message PROGRESS_POS;
    procedure SetMessageErrorProcessUpdate(var Msg: TMessage); message PROGRESS_UPDATE_NOT_FINISHED;
    procedure SetMessageProcessUpdate(var Msg: TMessage); message PROGRESS_UPDATE_FINISHED;
    procedure SetStateProcessUpdate(var Msg: TMessage); message PROGRESS_UPDATE_STATE;
    procedure SetMaxProcess(var Msg: TMessage); message PROGRESS_SET_MAX_POS;
    procedure SetMessageProcessUpdateFinished(var Msg: TMessage);message    PROGRESS_UPDATE_ALL_FINISHED;
    procedure RestartProg(var Msg: TMessage);message   PROGRESS_UPDATE_RESTARTPROG;
    procedure DoProcessUpdate(var Msg: TMessage);message PROGRESS_START_UPDATE;
  end;

var
  UpdatesWindows: TUpdatesWindows;

implementation

uses _Main, _Data, _Downloader, _Updater, StrUtils;

{$R *.dfm}

function WinToDos(St: string): string;
var
  Ch: PChar;
begin
  Ch := StrAlloc(Length(St) + 1);
  AnsiToOem(PChar(St), Ch);
  Result := Ch;
  StrDispose(Ch)
end;

procedure TUpdatesWindows.SetProgressPos(var Msg: TMessage);
begin
    ProgressBar1.Position:=Msg.LParam;
    Application.ProcessMessages();
end;

procedure TUpdatesWindows.SetMessageProcessUpdate(var Msg: TMessage);
begin
    Label2.Caption := '';
    ProgressBar1.Position := 0;
    CheckListUpdate.Checked[Msg.LParam] := FALSE;
    CheckListUpdate.ItemEnabled[Msg.LParam] := FALSE;
end;

procedure TUpdatesWindows.DoProcessUpdate(var Msg: TMessage);
begin
   if Msg.LParam = 10 then
    exit;

   ModalResult := mrOK;
   PostMessage(Main.Handle,PROGRESS_START_UPDATE,0,Msg.LParam);
end;

procedure TUpdatesWindows.SetMessageErrorProcessUpdate(var Msg: TMessage);
begin
  MessageDlg('Обновление не выполнено! Причина - '+PChar(msg.lParam)+'.', mtError, [mbOK],0);
  Label2.Caption := '';
  ProgressBar1.Position := 0;
  CheckListUpdate.Enabled := TRUE;
  UpdateButtons(False{aDownloadInProgress});
end;

function TUpdatesWindows.SetParametrs(sPathName: string; sURLName: string; aSilentMode: Boolean; IsExtUpdate: Boolean): Boolean;
begin
  SetParametrs := TRUE;

  fIsExtUpdate := IsExtUpdate;
  cbShowInstalledPackages.Visible := IsExtUpdate;

  bTerminate := TRUE;
  sPath := sPathName;
  sURL := sURLName;
  fServer := sURLName;

  if IsExtUpdate then
    lbTitle.Caption := 'Дополнительные пакеты обновлений'
  else
    lbTitle.Caption := 'Доступные обновления';


  if fIsExtUpdate then
    fInfFileName := sPath + cUpdateInfoExtFileName
  else
    fInfFileName := sPath + cUpdateInfoFileName;

   // if Data.fTecdocOldest then
   //   sURL := StringReplace(sURL, 'service', 'service_Test_TD2014', [rfReplaceAll]);


  if DownloadFile(sURL, fInfFileName) <> 1 then
  begin
    SetParametrs := FALSE;
    Exit;
  end;
  
  fInfCache.LoadFromFile(fInfFileName);
  ReloadInf(fInfFileName);

  if fIsExtUpdate then
  begin
    //?
  end
  else
    if CheckListUpdate.Items.Count = 0 then
    begin
      if not aSilentMode then
        MessageDlg('Обновлений не найдено, у Вас самая актуальная версия данных!', mtInformation, [mbOk], 0);
      SetParametrs := FALSE;
    end;
end;

procedure TUpdatesWindows.btStartClick(Sender: TObject);
var
  i: Integer;
  UpdateFileData: TUpdateFileData;
  bStartProcess: Boolean;
begin
  Data.LoadingLock;
  bTerminate := FALSE;
  i:=0;
  bStartProcess:=FALSE;
  while i < CheckListUpdate.Count do
  begin
    UpdateFileData := Main.ListParametrs.Items[i];
    UpdateFileData.bUpdate := CheckListUpdate.Checked[i];
    if CheckListUpdate.Checked[i] then
      bStartProcess:=TRUE;
    i :=i +1;
  end;

   if bStartProcess then
   begin
      CheckListUpdate.Enabled := FALSE;
      UpdateButtons(True{aDownloadInProgress});

//      Main.DownloadThrd := TUpdateThrd.Create(true);
      fTheadCreate := True;
      Main.DownloadThrd := TDownloadThread.Create(true);
      Main.DownloadThrd.SetQueue(Main.UpdateQueue);
      Main.DownloadThrd.ListParametrs := Main.ListParametrs;
      Main.DownloadThrd.sPathUpdate := sPath;
      Main.DownloadThrd.bMain := False;
     // UpdateThrd.ThisWindow := UpdatesWindows;
      Main.DownloadThrd.hWin := Handle;
      Main.DownloadThrd.Resume;
   end
   else
      MessageDlg('Не выбраны обновления!', mtInformation, [mbOk], 0);
end;

procedure TUpdatesWindows.btCancelClick(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

procedure TUpdatesWindows.btAbortClick(Sender: TObject);
begin
  UpdateButtons(False{aDownloadInProgress});

  Main.DownloadThrd.Terminate;
  bTerminate := TRUE;
  CheckListUpdate.Enabled := TRUE;
end;

procedure TUpdatesWindows.btHideClick(Sender: TObject);
begin
  Main.SetStatusColums(TRUE);
  Main.StatusBar.Panels[5].Progress.Position := ProgressBar1.Position;
  Main.StatusBar.Panels[6].Text := ' Внимание, не разрывайте интернет соединение! ' +  Label2.Caption;
  Main.DownloadThrd.bMain := TRUE;
  //Application.ProcessMessages;
  bCanExit := TRUE;
  
  ModalResult := mrOK;
end;

procedure TUpdatesWindows.cbShowInstalledPackagesClick(Sender: TObject);
begin
  fShowInstalledPackages := cbShowInstalledPackages.Checked;
  ReloadInf(fInfFileName);
end;

procedure TUpdatesWindows.CheckListUpdateClickCheck(Sender: TObject);
var
  iPos, i: Integer;
  UpdateFileDataClick, UpdateFileData: TUpdateFileData;
begin
  iPos :=(Sender as TCheckListBox).ItemIndex;
  if (iPos < 0 ) or ( Main.ListParametrs.Count < 1 )then
    Exit;

  UpdateFileDataClick := Main.ListParametrs.Items[iPos];
  if AnsiUpperCase(UpdateFileDataClick.localversion) = AnsiUpperCase('Prog') then
  begin
     for i := 0 to Main.ListParametrs.Count - 1 do
     begin
       if iPos = i then
         Continue;
       UpdateFileData := Main.ListParametrs.Items[i];
       UpdateFileData.State := -1;
       CheckListUpdate.State[i] := cbUnchecked;
       CheckListUpdate.ItemEnabled[i] := FALSE;
     end;
   UpdateFileDataClick.State := -1;
   CheckListUpdate.State[iPos] := cbChecked;
   CheckListUpdate.ItemEnabled[iPos] := TRUE;
  end;

  if SameText(UpdateFileDataClick.localversion, 'Data_d') then
  begin
    for i := 0 to Main.ListParametrs.Count - 1 do
    begin
      if iPos = i then
        Continue;
      UpdateFileData := Main.ListParametrs.Items[i];

      if SameText(UpdateFileData.localversion, 'quants') then
         CheckListUpdate.State[i] := cbUnchecked;
      if SameText(UpdateFileData.localversion, 'Data') then
         CheckListUpdate.State[i] := cbUnchecked;
    end;
  end;

  if SameText(UpdateFileDataClick.localversion, 'Data') then
  begin
    for i := 0 to Main.ListParametrs.Count - 1 do
    begin
      if iPos = i then
        Continue;
      UpdateFileData := Main.ListParametrs.Items[i];

      if AnsiUpperCase(UpdateFileData.localversion) = AnsiUpperCase('quants') then
        CheckListUpdate.State[i] := cbUnchecked;
      if AnsiUpperCase(UpdateFileData.localversion) = AnsiUpperCase('Data_d') then
        CheckListUpdate.State[i] := cbUnchecked;
    end;
  end;

  if SameText(UpdateFileDataClick.localversion, 'Quants') then
  begin
    for i := 0 to Main.ListParametrs.Count - 1 do
    begin
      if iPos = i then
        Continue;
      UpdateFileData := Main.ListParametrs.Items[i];

      if AnsiUpperCase(UpdateFileData.localversion) = AnsiUpperCase('Data') then
        CheckListUpdate.State[i] := cbUnchecked;
      if AnsiUpperCase(UpdateFileData.localversion) = AnsiUpperCase('Data_d') then
        CheckListUpdate.State[i] := cbUnchecked;
    end;
  end;

  CheckListUpdate.Invalidate;
end;

procedure TUpdatesWindows.CheckListUpdateDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  s: string;
begin
  s := CheckListUpdate.Items[Index];
  if not (odSelected in State) then
    if SameText(StrUtils.RightStr(s, 12), '(установлен)') then
      CheckListUpdate.Canvas.Font.Color := clBlue;
  CheckListUpdate.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top, s);
end;

function TUpdatesWindows.DownloadFile(const FileURL, FileName: String): Cardinal;
var
  hSession, hFile: HInternet;
  Buffer: array[1..1024] of Byte;
  BufferLen, fSize: LongWord;
//  FErrorString: array[0..512] of Byte;
  f: File;
  upd_url:string;
   OpenFlags: DWORD;
begin
  OpenFlags := INTERNET_FLAG_RELOAD or INTERNET_FLAG_NO_CACHE_WRITE or INTERNET_FLAG_PASSIVE
    {$IFDEF DELPHI4_LVL}
    or INTERNET_FLAG_PRAGMA_NOCACHE
    {$ENDIF}
    ;
  DownloadFile := 0;
  if Data.ParamTable.FieldByName('UseProxy').AsBoolean then
     hSession := InternetOpen('Download_ShateM_Update', INTERNET_OPEN_TYPE_PROXY ,pchar(Data.ParamTable.FieldByName('ProxySRV').AsString+':'+Data.ParamTable.FieldByName('ProxyPort').AsString),nil,0)
  else
    hSession := InternetOpen('Download_ShateM_Update',INTERNET_OPEN_TYPE_PRECONFIG, nil,nil,0);

  if Assigned(hSession) then
  begin
    try
    upd_url := Data.MakeProxyUrl(FileURL,Data.ParamTable.FieldByName('ProxyUser').AsString, Data.ParamTable.FieldByName('ProxyPassword').AsString);

    hFile := InternetOpenURL(hSession, PChar(upd_url), nil, 0,
                             OpenFlags, 0);
    if Assigned(hFile) then
    begin


      AssignFile(f, FileName);
      Rewrite(f,1);

      fSize := 0;
      repeat
        if not InternetReadFile(hFile, @Buffer, SizeOf(Buffer), BufferLen)  then
        begin
           MessageDlg(Main.GetErrorMessage(GetLastError()),mtError,[mbOk],0);
           InternetCloseHandle(hFile);
           exit;
        end;
        BlockWrite(f, Buffer, BufferLen);
        fSize := fSize + BufferLen;
      until (BufferLen = 0);
      CloseFile(f);
      Result := fSize;
      InternetCloseHandle(hFile);
    end
    else
    begin
     MessageDlg(Main.GetErrorMessage(GetLastError()),mtError,[mbOk],0);
     InternetCloseHandle(hSession);
     exit;
    end;
    InternetCloseHandle(hSession);
    except
        on e: Exception do
          begin
          MessageDlg(Main.GetErrorMessage(GetLastError()),mtError,[mbOk],0);
          exit;
          end;
    end;
    DownloadFile:=1;
  end
  else
     begin
     MessageDlg(Main.GetErrorMessage(GetLastError()),mtError,[mbOk],0);
     end;
end;
                                           
procedure TUpdatesWindows.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := TRUE;    //переписать!!!
  if (not bTerminate)and(not bCanExit) then
    if MessageDlg('Прервать обновление?',mtInformation,[mbYes, mbNo],0) = mrYes then
    begin
      if fTheadCreate then
        Main.DownloadThrd.Terminate;
      bTerminate := TRUE;
      Sleep(20);
    end
    else
     CanClose := FALSE;
end;


procedure TUpdatesWindows.FormCreate(Sender: TObject);
  var hWndActive:HWND;
      dwCurThreadID,dwThreadID:DWORD;
begin
   fInfCache := TStringList.Create;

   bCanExit := FALSE;
   hWndActive := GetForegroundWindow();

   dwThreadID := GetCurrentThreadId();
   dwCurThreadID := GetWindowThreadProcessId(hWndActive);
   AttachThreadInput(dwThreadID, dwCurThreadID, TRUE);
   SetForegroundWindow(Handle);
   AttachThreadInput(dwThreadID, dwCurThreadID, FALSE);

end;

procedure TUpdatesWindows.FormDestroy(Sender: TObject);
begin
  fInfCache.Free;
end;

procedure TUpdatesWindows.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and (btCancel.Visible) then
    ModalResult := mrCancel;
end;

procedure TUpdatesWindows.FormShow(Sender: TObject);
begin
  SetWindowPos(Handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
end;

procedure TUpdatesWindows.lbTitleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssCtrl in Shift then
    ShowMessage(
      'Сервер обновления: ' + Main.CurrentWorkingServer + #13#10 +
      'INF-файл: ' + fServer
    );
end;

procedure TUpdatesWindows.SetStateProcessUpdate(var Msg: TMessage);
begin
    Label2.Caption := '';
    ProgressBar1.Position := 0;
    Label2.Caption := PChar(msg.lParam);
end;

procedure TUpdatesWindows.UpdateButtons(aDownloadInProgress: Boolean);
begin
  btStart.Visible := not aDownloadInProgress;
  btCancel.Visible := not aDownloadInProgress;
  btAbort.Visible := aDownloadInProgress;
  btHide.Visible := aDownloadInProgress;
end;

procedure TUpdatesWindows.RestartProg(var Msg: TMessage);

  procedure LogUpdateError(const aError: string; aClearLog: Boolean = False);
  var
    aLogFile: TextFile;
  begin
  {$I-} //отключаем I/O exceptions
    AssignFile(aLogFile, GetAppDir + cUpdateErrorsLogFile);
    if aClearLog or not FileExists(GetAppDir + cUpdateErrorsLogFile) then
      Rewrite(aLogFile)
    else
      Append(aLogFile);
    Writeln(aLogFile, aError);
    CloseFile(aLogFile);
  {$I+}
  end;

var   FileBat:TextFile;
      si: TStartUpInfo;
      pi:TProcessInformation;
//      szCommand: array of char;
  aNewExe, aCurExe, aBkExe: string;
begin
  ModalResult := mrOK;
  //FileExists(Data.Import_Path + 'shatemplus.exe_new')
  aNewExe := Main.NewProgFile;
  aCurExe := GetAppDir + ExtractFileName(Application.ExeName);
  aBkExe  := aCurExe + '_old';

  //new -----------------------
  if FileExists(aNewExe) then
  begin
    DeleteFile(aBkExe);
    if RenameFile(aCurExe, aBkExe) then
    begin
      if CopyFile(PChar(aNewExe), PChar(aCurExe), True) then
      begin
        if not Data.VersionTable.Active then
          Data.VersionTable.Open;
        Data.VersionTable.Edit;
        Data.VersionTable.FieldByName('ProgVersion').Value := Main.NewProgVersion;
        Data.VersionTable.Post;

        fRestProgAfterUpdate := TRUE;//чтобы не выдавало сообщение о закрытии
        MessageDlg('Установлена новая версия программы. Для применения изменений, программа будет перезапущена!'#13#10'После перезапуска, пожалуйста, выполните обновление данных.',mtInformation, [mbOK],0);

        AssignFile(FileBat, GetAppDir + 'start.bat');
        Rewrite(FileBat);
        Writeln(FileBat, WinToDos('"' + aCurExe + '" -newversion=' + IntToStr(GetCurrentProcessId)));
        CloseFile(FileBat);

        ZeroMemory(@si, SizeOf(si));
        ZeroMemory(@pi, SizeOf(pi));
        with si do
        begin
          cb := SizeOf(si);
          dwFlags := STARTF_USESHOWWINDOW;
          wShowWindow := SW_HIDE;
          hStdInput := 0;
        end;
        CreateProcess(nil, PChar(GetAppDir + 'start.bat'), nil, nil, FALSE, CREATE_NEW_CONSOLE, nil, PChar(GetAppDir), si, pi);
        Main.fMainCLose := TRUE;
        Main.Close;
        Exit;
      end
      else
      begin
        Application.MessageBox(
          PChar(
          'Ошибка при установке новой версии: невозможно скопировать файл из "' + aNewExe + '" в "' + aCurExe + '"'#13#10 +
          'Пожалуйста, свяжитесь со службой технической поддержки компании Шате-М+'),
          'Ошибка',
          MB_OK or MB_ICONERROR
        );
        LogUpdateError('Ошибка при установке новой версии: невозможно скопировать файл из "' + aNewExe + '" в "' + aCurExe + '": ' + SysErrorMessage(GetLastError));
      end;
    end
    else
    begin
      Application.MessageBox(
        PChar(
        'Ошибка при установке новой версии: невозможно переименовать файл "' + aCurExe + '" -> "' + aBkExe + '"'#13#10 +
        'Пожалуйста, свяжитесь со службой технической поддержки компании Шате-М+'),
        'Ошибка',
        MB_OK or MB_ICONERROR
      );
      LogUpdateError('Ошибка при установке новой версии: невозможно переименовать файл "' + aCurExe + '" -> "' + aBkExe + '"' + SysErrorMessage(GetLastError));
    end;
  end
  else
    Application.MessageBox(
      PChar(
      'Ошибка при установке новой версии: не найден скачанный файл "' + aNewExe + '"'#13#10 +
      'Возможно, загрузку заблокировало ваше антивирусное программное обеспечение.'#13#10 +
      'Пожалуйста, свяжитесь со службой технической поддержки компании Шате-М+'),
      'Ошибка',
      MB_OK or MB_ICONERROR
    );
end;

procedure TUpdatesWindows.SetMessageProcessUpdateFinished(var Msg: TMessage);
begin
  ModalResult := mrOK;
end;

procedure TUpdatesWindows.SetMaxProcess(var Msg: TMessage);
begin
  ProgressBar1.Max := msg.lParam;
end;

{ TUpdateFileData }


procedure TUpdatesWindows.ReloadInf(const aFileName: string);
var
  aSectionName: string;
  IsNewVer: Boolean;
  IsInstalled: Boolean;
  iFile: Integer;
  iniUpdateFile: TIniFile;
  iPos, PosQuants, PosData, j: Integer;
  UpdateFileData: TUpdateFileData;
  aCurVersion, anAssemblyVersion: string;
  NewData: string;
  UpdateData: TUpdateFileData;
  ini : TIniFile;
  cnt: integer;
  fCnt, fNeedFullUpdatePicts: boolean;
  CurPictsVersionList: TStringList;
begin
  PosQuants := -1;
  PosData := -1;
  cnt := 0;
  fCnt:= True;
  fNeedFullUpdatePicts := GetFileSize_Internal(Data.Data_Path + '027.3') < 5000000000;
  fInfCache.SaveToFile(aFileName);
  CurPictsVersionList := TStringList.Create;

  CheckListUpdate.Clear;
  if Assigned(Main.ListParametrs) then
  begin
    Main.ListParametrs.Free;
    Main.ListParametrs := nil;
  end;

  iniUpdateFile := TIniFile.Create(aFileName);
  try
    Main.ListParametrs := TList.Create;
    iFile := 1;
    iPos := 0;

    Main.SetImageByLight(Main.INDEX_OF_PROG, True);
    Main.SetImageByLight(Main.INDEX_OF_QUANTS, True);
    Main.SetImageByLight(Main.INDEX_OF_DATA, True);

    while iniUpdateFile.ReadString('file' + IntToStr(iFile), 'customversion', '') <> '' do
    begin
      aSectionName := 'file' + IntToStr(iFile);

      {$IFDEF LOCAL}
      if iniUpdateFile.ReadString(aSectionName, 'localversion', '') = 'prog' then
      begin
        if Data.isItReallyLocalMode then
        aSectionName := 'prog_local';
      end;  
      {$ENDIF}

      {$IFDEF NAVTEST}
      if iniUpdateFile.ReadString(aSectionName, 'localversion', '') = 'prog' then
        aSectionName := 'prog_test';
      {$ENDIF}
      
      if iniUpdateFile.ReadString(aSectionName, 'localversion', '') <> '' then
      begin
        UpdateFileData := TUpdateFileData.Create;
        UpdateFileData.State := 1;
        UpdateFileData.iPos := iPos;
        UpdateFileData.url := iniUpdateFile.ReadString(aSectionName, 'url', '');
        UpdateFileData.descr := iniUpdateFile.ReadString(aSectionName, 'descr', '');
        UpdateFileData.filesize := iniUpdateFile.ReadInteger(aSectionName, 'filesize', 0);
        UpdateFileData.customversion := iniUpdateFile.ReadString(aSectionName, 'customversion', '');
        UpdateFileData.localversion := iniUpdateFile.ReadString(aSectionName, 'localversion', '');
        UpdateFileData.basename := iniUpdateFile.ReadString(aSectionName, 'basename', '');
        UpdateFileData.mustrestart := iniUpdateFile.ReadInteger(aSectionName, 'mustrestart', 0);
        UpdateFileData.DescretVersion := iniUpdateFile.ReadInteger(aSectionName, 'DescretVersion', 0);
        
        if Length(UpdateFileData.basename) = 0 then
        begin
          if UpdateFileData.localversion = 'data' then
            UpdateFileData.basename := 'DataVersion'
          else if UpdateFileData.localversion = 'data_d' then
            UpdateFileData.basename := 'DataVersion'
          else if UpdateFileData.localversion = 'news' then
            UpdateFileData.basename := 'NewsVersion'
          else if UpdateFileData.localversion = 'quants' then
            UpdateFileData.basename := 'QuantVersion'
          else if UpdateFileData.localversion = 'prog' then
            UpdateFileData.basename := 'ProgVersion'
          else if UpdateFileData.localversion = 'picts_d' then
            UpdateFileData.basename := 'PictsVersion'
          else if UpdateFileData.localversion = 'tires' then
            UpdateFileData.basename := 'TiresVersion'
//          else if UpdateFileData.localversion = 'typ_d' then
//            UpdateFileData.basename := 'TypVersion';
        end;

        if UpdateFileData.basename <> '' then
        begin
           {Если старый текдок < 2014.2, запрещаем все кроме остатков}
       {   if  (Data.fTecdocOldest) and (UpdateFileData.basename <> 'QuantVersion') then
          begin
            Inc(iFile);
            Continue;
          end;  }
           {****} 
            
          aCurVersion := Data.VersionTable.FieldByName(UpdateFileData.basename).AsString;

          if UpdateFileData.basename = 'PictsVersion' then
            CurPictsVersionList.Text := Data.VersionTable.FieldByName('iNewPictsVersion').AsString;

          if UpdateFileData.basename = 'QuantVersion' then
            if Main.fLocalMode then
            begin
              ini := TIniFile.Create(Data.GetDomainName+'\ShateMPlus.ini');
              aCurVersion := ini.ReadString('Quants','Version','120101.1');
              ini.Free;
            end;

          anAssemblyVersion  := Data.VersionTable.FieldByName('AssemblyVersion').AsString;
          IsInstalled := False;

          if UpdateFileData.localversion <> 'data_d' then
          //---
          begin
            if UpdateFileData.basename = 'TiresVersion' then
            begin
              //там лежат установленные версии через запятую
              IsNewVer :=
                ( POS(UpdateFileData.customversion, aCurVersion) = 0 ) and
                ( Data.CheckVersions(anAssemblyVersion, UpdateFileData.customversion) > 0 );
              if not IsNewVer and fShowInstalledPackages then
                IsInstalled := True;
              end;
           //---
            if UpdateFileData.basename = 'TypVersion' then
            begin
              IsNewVer :=
                ( POS(UpdateFileData.customversion, aCurVersion) = 0 ) and
                ( Data.CheckVersions(anAssemblyVersion, UpdateFileData.customversion) > 0 );
              if not IsNewVer and fShowInstalledPackages then
                IsInstalled := True;
              end;
           //---

            if UpdateFileData.basename = 'PictsVersion' then
            begin
              //там лежат установленные версии через запятую
              IsNewVer :=
                 (POS(UpdateFileData.customversion, CurPictsVersionList.Text) = 0 ); //and
//                ( Data.CheckVersions(anAssemblyVersion, UpdateFileData.customversion) > 0 );

              if IsNewVer and (pos('150515.', UpdateFileData.customversion)> 0) then
                IsNewVer := fNeedFullUpdatePicts;

              if not IsNewVer and fShowInstalledPackages then
              begin
                IsNewVer := True;
                IsInstalled := True;
              end;
            end
            else
              //если версия пустая (сломана таблица) то разрешаем обновиться данным
              IsNewVer := (aCurVersion = '') and (UpdateFileData.localversion = 'data') or Main.TestString(aCurVersion, UpdateFileData.customversion);

            if IsNewVer and (UpdateFileData.basename = 'TypVersion') then
            begin
              inc(cnt);
              if cnt > 1 then
                fCnt := False;
            end
            else
              fCnt := True;


            if IsNewVer and fCnt then
            begin
              NewData := UpdateFileData.descr;
              CheckListUpdate.Items.Add(NewData);
              CheckListUpdate.Sorted := TRUE;
              iPos := CheckListUpdate.Items.IndexOf(NewData);
              Main.ListParametrs.Insert(iPos, UpdateFileData);
              CheckListUpdate.Checked[iPos] := TRUE;
              if IsInstalled then
                CheckListUpdate.Items[iPos] := CheckListUpdate.Items[iPos] + ' (установлен)';
              iPos := iPos + 1;
              if UpdateFileData.localversion = 'prog' then
                Main.SetImageByLight(Main.INDEX_OF_PROG, False);
              if UpdateFileData.localversion = 'quants' then
                Main.SetImageByLight(Main.INDEX_OF_QUANTS, False);
            end

            else
              UpdateFileData.Free;
          end
          else
          begin
            //data_d
            if (Data.VersionTable.FieldByName('DiscretNumberVersion').AsInteger + 1 = UpdateFileData.DescretVersion) and Main.TestString(Data.VersionTable.FieldByName(UpdateFileData.basename).AsString, UpdateFileData.customversion) and Data.CanViewDiscretUpdate(Data.VersionTable.FieldByName(UpdateFileData.basename).AsString) then
            begin
              NewData := UpdateFileData.descr;
              CheckListUpdate.Items.Add(NewData);
              CheckListUpdate.Sorted := TRUE;
              iPos := CheckListUpdate.Items.IndexOf(NewData);
              Main.ListParametrs.Insert(iPos, UpdateFileData);
              CheckListUpdate.Checked[iPos] := FALSE;
              //          iPosDescretUpdate:=iPos;
              iPos := iPos + 1;
              Main.SetImageByLight(Main.INDEX_OF_DATA, False);
            end
            else
              UpdateFileData.Free;
          end;
        end;
      end;
      Inc(iFile);
    end; //while
  finally
    iniUpdateFile.Free;
    CurPictsVersionList.Free;
  end;

  DeleteFile(aFileName);

  {*******Блокировка всех обновлений в режиме сохранения данных**********}
  {$IFDEF LOCAL}
    if Main.fLocalMode then
    begin
      for iPos := 0 to Main.ListParametrs.Count - 1 do
      begin
        UpdateData := Main.ListParametrs.Items[iPos];
        if SameText('quants',UpdateData.localversion) then
        begin
          CheckListUpdate.ItemEnabled[iPos] := TRUE;
          CheckListUpdate.Checked[iPos] := TRUE;
        end
        else
        begin
          CheckListUpdate.ItemEnabled[iPos] := FALSE;
          CheckListUpdate.Checked[iPos] := FALSE;
        end;
      end;
      exit;
    end;
  {$ENDIF}

  if Main.ListParametrs.Count = 1 then
        CheckListUpdate.Checked[0] := TRUE
  else

  begin
    for iPos := 0 to Main.ListParametrs.Count - 1 do
    begin
      UpdateData := Main.ListParametrs.Items[iPos];
      CheckListUpdate.Checked[iPos] := False;

      if SameText('quants',UpdateData.localversion) then
      begin
        CheckListUpdate.Checked[iPos] := true;
        exit;
      end;

      if SameText('prog', UpdateData.localversion) then
      begin
        posData:= iPos;
        for j := 0 to Main.ListParametrs.Count - 1 do
        begin
          CheckListUpdate.Checked[j] := false;
          CheckListUpdate.ItemEnabled[j] := false;
        end;
        CheckListUpdate.Checked[PosData] := TRUE;
        CheckListUpdate.ItemEnabled[PosData] := TRUE;
        exit;
      end;
    end;

    for iPos := 0 to Main.ListParametrs.Count - 1 do
    begin
      UpdateData := Main.ListParametrs.Items[iPos];

      if (PosQuants<0) and SameText('data_d',UpdateData.localversion) then
      begin
        if PosData>=0 then
        begin
          CheckListUpdate.Checked[PosData] := False;
          CheckListUpdate.Checked[iPos] := True;
          PosData:= iPos;
        end
        else
        begin
          CheckListUpdate.Checked[iPos] := True;
          PosData:= iPos;
        end;
      end;

      if (PosQuants<0) and (PosData<0) and SameText('data',UpdateData.localversion) then
      begin
        CheckListUpdate.Checked[iPos] := True;
        PosData:= iPos;
      end;
      if SameText('news',UpdateData.localversion) then
        CheckListUpdate.Checked[iPos] := True;

    end;
  end;
end;

end.
