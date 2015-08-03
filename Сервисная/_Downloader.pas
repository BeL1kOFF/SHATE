unit _Downloader;

interface

uses
  Classes, Windows, _Updater;

type
  //загружает выбранные пакеты обновлений
  TDownloadThread = class(TThread)
    ListParametrs:TList;
    sPathUpdate:string;
    iProgressPos: Integer;
    sMessage:string;
    sMaxPos: Cardinal;
    hWin: HWnd;
    bMain:bool;
    bMessage:bool;
    fUpdateQueue: TUpdateQueue;

    fResult: Integer;
    fResultError: string;

    function DownloadUpdateFile(const FileURL, FileName: String; iSizeFile:integer): Boolean;
    procedure SetProgressPos;
    procedure KillProgressPos;
  protected
    procedure Execute; override;
  public
    procedure SetQueue(aQueue: TUpdateQueue);
    function GetQueue: TUpdateQueue;
  end;

implementation

uses
  WinInet, SysUtils, AdvOfficeStatusBar,
  _Data, _Main, _UpdatesWindows;

{ TDownloadThread }

function TDownloadThread.DownloadUpdateFile(const FileURL, FileName: String; iSizeFile:integer): Boolean;
var
  hSession, hFile: HInternet;
  Buffer: array[1..1024] of Byte;
  BufferLen, fSize: LongWord;
  f: File;
  OpenFlags: DWORD;
  upd_url: string;
  aPrevProgress: Integer;
begin
  Result := False;
  fResult := PROGRESS_UPDATE_NOT_FINISHED;

  DeleteFile(FileName);
  OpenFlags := INTERNET_FLAG_RELOAD or INTERNET_FLAG_NO_CACHE_WRITE or INTERNET_FLAG_PASSIVE {for FTP support}
    {$IFDEF DELPHI4_LVL}
    or INTERNET_FLAG_PRAGMA_NOCACHE
    {$ENDIF}
    ;
  aPrevProgress := -1;

  if Data.ParamTable.FieldByName('UseProxy').AsBoolean then
    hSession := InternetOpen('Download_ShateM_Update', INTERNET_OPEN_TYPE_PROXY, pchar(Data.ParamTable.FieldByName('ProxySRV').AsString + ':' + Data.ParamTable.FieldByName('ProxyPort').AsString), nil, 0)
  else
    hSession := InternetOpen('Download_ShateM_Update', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if not Assigned(hSession) then
  begin
    fResultError := SysErrorMessage(GetLastError);
    Exit;
  end;

  fSize := 0;
  try //except
    upd_url := Data.MakeProxyUrl(FileURL, Data.ParamTable.FieldByName('ProxyUser').AsString, Data.ParamTable.FieldByName('ProxyPassword').AsString);
    hFile := InternetOpenURL(hSession, PChar(upd_url), nil, 0, OpenFlags, 0);
    if not Assigned(hFile) then
    begin
      fResultError := Main.GetErrorMessage(GetLastError());
      Exit;
    end;

    AssignFile(f, FileName);
    Rewrite(f, 1);
    try
      repeat
        if Terminated or bTerminate then //check terminated
        begin
          fResultError := 'Прерванно пользователем!';
          Exit;
        end;

        if not InternetReadFile(hFile, @Buffer, SizeOf(Buffer), BufferLen) then
        begin
          fResultError := Main.GetErrorMessage(GetLastError());
          Exit;
        end;

        BlockWrite(f, Buffer, BufferLen);
//        Sleep(1); //замедлил для теста - !!! убрать !!!

        //сильно забивало очередь сообщений - сделал посылку реже
        iProgressPos := (fSize * 100) div sMaxPos;
        if iProgressPos <> aPrevProgress then
        begin
          aPrevProgress := iProgressPos;

          if bMain then
            Synchronize(SetProgressPos)
          else
            PostMessage(hWin, PROGRESS_POS, 0, iProgressPos);
        end;

        fSize := fSize + BufferLen;
        if fSize >= sMaxPos then
          Break;
      until (BufferLen = 0);

      if bMain then
        Synchronize(KillProgressPos);
    finally
      CloseFile(f);
      InternetCloseHandle(hFile);
      InternetCloseHandle(hSession);
    end;

  except
    on E: Exception do
    begin
      fResultError := E.Message;
      Exit;
    end;
  end;

  if fSize = sMaxPos then
    Result := True
  else
    fResultError := 'Ошибка при скачивании файла обновления! ';
end;

procedure TDownloadThread.Execute;
var
  i: Integer;
  UpdateFileData: TUpdateFileData;
  sFileName: string;
  iDownLoad: Integer;
  aQueueItem: TUpdateQueueItem;
begin
  i := 0;

  if Assigned(fUpdateQueue) then
    fUpdateQueue.Clear;

  try //except
    iDownLoad := 1;
//    AssignFile(f, sPathUpdate + 'Update');
//    Rewrite(f);
//    Close(f);

    while i < ListParametrs.Count do
    begin
      if Terminated or bTerminate then //check terminated
      begin
//        DeleteFile(sPathUpdate + 'Update');
        PostMessage(hWin, PROGRESS_UPDATE_NOT_FINISHED, 0, DWORD(PChar('Прерванно пользователем!')));
        Exit;
      end;

      UpdateFileData := ListParametrs.Items[i];
      if UpdateFileData.bUpdate then
      begin
        sFileName := ExtractFileName(UpdateFileData.url); //[kri] ???
        while Main.StrFind(sFileName,'\') > 0 do
          sFileName := Main.StrRight(sFileName,Length(sFileName)- Main.StrFind(sFileName,'\'));

        while Main.StrFind(sFileName,'/') > 0 do
          sFileName := Main.StrRight(sFileName,Length(sFileName)- Main.StrFind(sFileName,'/'));

        sMessage := 'Загрузка файла: ' + sFileName;
        sMaxPos := UpdateFileData.filesize;
        PostMessage(hWin, PROGRESS_UPDATE_STATE, 0, DWORD(PChar(sMessage)));
        PostMessage(hWin, PROGRESS_SET_MAX_POS, 0, 100);
        sFileName := sPathUpdate + sFileName;
        if UpdateFileData.localversion = 'prog' then
        begin
//          DeleteFile(sPathUpdate + 'Update');
        end;


        if not DownloadUpdateFile(UpdateFileData.url, sFileName, UpdateFileData.filesize) then
        begin
//          DeleteFile(sPathUpdate + 'Update');
          DeleteFile(sFileName);
          bTerminate := True;
          if not bMain then
          begin
            PostMessage(hWin, PROGRESS_START_UPDATE, 0, 10);
            PostMessage(hWin, fResult, 0, DWORD(PChar(fResultError)));
          end
          else
          begin
            PostMessage(Main.Handle, PROGRESS_START_UPDATE, 0, 10);
            PostMessage(Main.Handle, fResult, 0, DWORD(PChar(fResultError)));
          end;

          Exit;
        end;

        iDownLoad := 0;

        if Terminated or bTerminate then //check terminated
        begin
//          DeleteFile(sPathUpdate + 'Update');
          PostMessage(hWin, PROGRESS_UPDATE_NOT_FINISHED, 0, DWORD(PChar('Прерванно пользователем!')));//MessageDlg(E.Message, mtInformation, [mbOK],0);
          Exit;
        end;

        if UpdateFileData.localversion = 'prog' then
        begin
//          DeleteFile(sPathUpdate + 'Update');
          Main.NewProgVersion := UpdateFileData.customversion;
          Main.NewProgFile := sFileName;
          if bMain then
            PostMessage(Main.Handle, PROGRESS_UPDATE_RESTARTPROG, 0, DWORD(PChar(SysErrorMessage(GetLastError))))
          else
            PostMessage(hWin, PROGRESS_UPDATE_RESTARTPROG, 0, DWORD(PChar(SysErrorMessage(GetLastError))));
          bTerminate := True;
          Exit;
        end
        else
        begin
//          AssignFile(f, sPathUpdate + 'Update');
//          Append(f);
//          WriteLn(f, UpdateFileData.localversion);
//          WriteLn(f, sFileName);
//          WriteLn(f, UpdateFileData.customversion);
//          WriteLn(f, IntToStr(UpdateFileData.DescretVersion));
//          Close(f);
          if Assigned(fUpdateQueue) then
          begin
            aQueueItem := fUpdateQueue.Add;
            aQueueItem.PackageTypeCode := UpdateFileData.localversion;
            aQueueItem.ZipFile := sFileName;
            aQueueItem.PackageDescription := UpdateFileData.descr;
            aQueueItem.NewVersions.Add(UpdateFileData.customversion);
            aQueueItem.NewVersions.Add( IntToStr(UpdateFileData.DescretVersion) );
          end;
        end;
      end;
      Inc(i);
    end;

    //PostMessage(hWin,PROGRESS_UPDATE_ALL_FINISHED,0,i);
  except
    on E: Exception do
    begin    //[kri] ???
      // PostMessage(hWin,PROGRESS_UPDATE_NOT_FINISHED,0, DWORD(PChar(E.Message)));//MessageDlg(E.Message, mtInformation, [mbOK],0);
      Exit;
    end;
  end;

  if Terminated or bTerminate then
  begin
//    DeleteFile(sPathUpdate + 'Update');
    PostMessage(hWin, PROGRESS_UPDATE_NOT_FINISHED, 0, DWORD(PChar('Прерванно пользователем!')));
    bTerminate := True;
    Exit;
  end;

  bTerminate := True;
  if not bMain then
    PostMessage(hWin, PROGRESS_START_UPDATE, 0, iDownLoad)
  else
    PostMessage(Main.Handle, PROGRESS_START_UPDATE, 0, iDownLoad);
end;

procedure TDownloadThread.SetProgressPos;
begin
  if not bTerminate then
  begin
    Main.StatusBar.Panels[5].Style := psProgress;
    Main.StatusBar.Panels[5].Progress.Position  := iProgressPos;
    Main.StatusBar.Panels[5].Progress.Max  := 100;
    Main.StatusBar.Panels[6].Text          := ' Внимание, не разрывайте интернет соединение !!! ' + sMessage;
  end;
end;

procedure TDownloadThread.KillProgressPos;
begin
  if not bTerminate then
  begin
    Main.StatusBar.Panels[5].Style := AdvOfficeStatusBar.psHTML;
    Main.StatusBar.Panels[6].Style := AdvOfficeStatusBar.psOwnerDraw;
    Main.StatusBar.Panels[6].Text  := '';
  end;
end;

function TDownloadThread.GetQueue: TUpdateQueue;
begin
  Result := fUpdateQueue;
end;

procedure TDownloadThread.SetQueue(aQueue: TUpdateQueue);
begin
  fUpdateQueue := aQueue;
end;

end.
