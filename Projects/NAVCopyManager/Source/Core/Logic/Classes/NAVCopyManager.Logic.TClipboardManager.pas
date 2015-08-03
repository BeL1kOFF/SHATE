unit NAVCopyManager.Logic.TClipboardManager;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  NAVCopyManager.Logic.IClipboardManager,
  NAVCopyManager.Logic.TLoggedObject;

type
  TClipboardManager = class(TLoggedObject, IClipboardManager)
  strict private
    FHandle: HWND;
    function GetHandle(): HWND;
  strict protected
    procedure WndProc(var aMessage: TMessage);
  public
    property Handle: HWND read GetHandle;
    procedure AfterConstruction(); override;
    procedure BeforeDestruction(); override;
    procedure ClipboardProcessing(const aList: TStrings = nil; const aSaveUncommonFormatData: Boolean = False);
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils;

const
  PREDEFINED_CLIPBOARD_FORMATS: array [1 .. 16] of string = ('CF_TEXT', 'CF_BITMAP', 'CF_METAFILEPICT', 'CF_SYLK',
    'CF_DIF', 'CF_TIFF', 'CF_OEMTEXT', 'CF_DIB', 'CF_PALETTE', 'CF_PENDATA', 'CF_RIFF', 'CF_WAVE', 'CF_UNICODETEXT',
    'CF_ENHMETAFILE', 'CF_HDROP', 'CF_LOCALE');

  NAV = 'Microsoft Dynamics NAV';
  DATA_OBJECT = 'DataObject';
  OLE_PRIVATE_DATA = 'Ole Private Data';

resourcestring
  RsHandleAllocateSuccess = 'Оконная функция успешно зарегистрирована (Handle = %d).';
  RsHandleAllocateError = 'Не удалось выполнить регистрацию оконной функции.';
  RsHandleDeallocateSuccess = 'Оконная функция успешно отрегистрирована (Handle = %d).';
  RsClipboardFormatListenerAddSuccess = 'Окно (Handle = %d) успешно добавлено в список наблюдателей за буфером обмена.';
  RsClipboardFormatListenerAddError = 'Окно (Handle = %d) не удалось добавить в список наблюдателей за буфером обмена.';
  RsClipboardFormatListenerRemoveSuccess =
    'Окно (Handle = %d) успешно убрано из списка наблюдателей за буфером обмена.';
  RsClipboardFormatListenerRemoveError =
    'Окно (Handle = %d) не удалось убрать из списка наблюдателей за буфером обмена.';
  RsClipboardWasChanged = 'Содержимое буфера обмена было изменено.';
  RsForbiddenClipboardDataFounded = 'Обнаружена попытка копирования в буфер обмена запрещённых данных.';
  RsOpenClipboardError = 'Не удалось открыть буфер обмена.';
  RsCloseClipboardError = 'Не удалось закрыть буфер обмена.';
  RsEmptyClipboardSuccess = 'Буфер обмена успешно очищен.';
  RsEmptyClipboardError = 'Не удалось очистить буфер обмена.';
  RsFreeMemoryError = 'Не удалось освободить память, выделенную под буфер.';
  RsGetClipboardDataError = 'Не удалось получить доступ к данным буфера обмена.';
  RsGetClipboardDataSizeError = 'Не удалось получить размер данных буфера обмена.';
  RsGlobalLockError = 'Не удалось закрепить область памяти, содержащую данные буфера обмена.';
  RsGlobalUnlockError = 'Не удалось открепить область памяти, содержащую данные буфера обмена.';
  RsSetParentError = 'Не удалось сделать окно (HWND = %d) не имеющим интерфейса и только получающим сообщения.';

procedure TClipboardManager.AfterConstruction;
begin
  inherited;
  FHandle := AllocateHWnd(WndProc);
  if SetParent(FHandle, HWND_MESSAGE) = 0 then
  begin
    LogMessage(Format(RsSetParentError + RsLastError, [FHandle, GetLastError(), SysErrorMessage(GetLastError())]),
      EVENTLOG_ERROR_TYPE);
  end;
  if GetHandle() <> 0 then
  begin
{$IFDEF DEBUG}
    LogMessage(Format(RsHandleAllocateSuccess, [GetHandle()]), EVENTLOG_SUCCESS);
{$ENDIF}
    if AddClipboardFormatListener(GetHandle()) then
    begin
{$IFDEF DEBUG}
      LogMessage(Format(RsClipboardFormatListenerAddSuccess, [GetHandle()]), EVENTLOG_SUCCESS);
{$ENDIF}
    end
    else
    begin
      LogMessage(Format(RsClipboardFormatListenerAddError + RsLastError, [GetHandle(), GetLastError(),
        SysErrorMessage(GetLastError())]), EVENTLOG_ERROR_TYPE);
    end;
  end
  else
  begin
    LogMessage(Format(RsHandleAllocateError + RsLastError, [GetLastError(), SysErrorMessage(GetLastError())]),
      EVENTLOG_ERROR_TYPE);
  end;
end;

procedure TClipboardManager.BeforeDestruction();
begin
  try
    try
      if RemoveClipboardFormatListener(GetHandle()) then
      begin
{$IFDEF DEBUG}
        LogMessage(Format(RsClipboardFormatListenerRemoveSuccess, [GetHandle()]), EVENTLOG_SUCCESS);
{$ENDIF}
      end
      else
      begin
        LogMessage(Format(RsClipboardFormatListenerRemoveError + RsLastError, [GetHandle(), GetLastError(),
          SysErrorMessage(GetLastError())]), EVENTLOG_ERROR_TYPE);
      end;
    finally
      if GetHandle() <> 0 then
      begin
        DeallocateHWnd(GetHandle());
{$IFDEF DEBUG}
        LogMessage(Format(RsHandleDeallocateSuccess, [GetHandle()]), EVENTLOG_SUCCESS);
{$ENDIF}
        FHandle := 0;
      end;
    end;
  finally
    inherited;
  end;
end;

procedure TClipboardManager.ClipboardProcessing(const aList: TStrings = nil;
  const aSaveUncommonFormatData: Boolean = False);
var
  tmpClipboardFormatId: Cardinal;
  tmpClipboardFormatName: string;
  tmpGlobalMemoryHandle: HGLOBAL;
  tmpClipboardData: PAnsiChar;
  tmpClipboardDataSize: NativeUInt;

  tmpNAVClassicDataFormatExists: Boolean;
  tmpDataObjectDataFormatExists: Boolean;
  tmpOlePrivateDataFormatExists: Boolean;
  tmpMicrosoftDynamixNAVWindowActive: Boolean;
  tmpCFTextDataLength: NativeUInt;

  function GetClipboardFormatName(const aClipboardFormatId: Cardinal): string;
  var
    tmpNameBuffer: PChar;
  begin
    Result := EmptyStr;
    if aClipboardFormatId in [1 .. 16] then
    begin
      Result := PREDEFINED_CLIPBOARD_FORMATS[aClipboardFormatId];
    end
    else
    begin
      tmpNameBuffer := StrAlloc(1000);
      try
        if Winapi.Windows.GetClipboardFormatName(aClipboardFormatId, tmpNameBuffer, StrBufSize(tmpNameBuffer)) > 0 then
        begin
          Result := tmpNameBuffer;
        end;
      finally
        StrDispose(tmpNameBuffer);
      end;
    end;
  end;

  function GetClipboardDataSize(const aClipboardDataMemoryHandle: NativeUInt): NativeUInt;
  begin
    Result := GlobalSize(aClipboardDataMemoryHandle);
    if Result = 0 then
    begin
      LogMessage(Format(RsGetClipboardDataSizeError + RsLastError, [GetLastError(), SysErrorMessage(GetLastError())]),
        EVENTLOG_ERROR_TYPE);
    end;
  end;

  procedure DoClearClipboard();
  begin
    if EmptyClipboard() then
    begin
      LogMessage(RsEmptyClipboardSuccess, EVENTLOG_SUCCESS);
    end
    else
    begin
      LogMessage(Format(RsEmptyClipboardError + RsLastError, [GetLastError(), SysErrorMessage(GetLastError())]),
        EVENTLOG_ERROR_TYPE);
    end;
  end;

  procedure DoCloseClipboard();
  begin
    if not CloseClipboard() then
    begin
      LogMessage(Format(RsCloseClipboardError + RsLastError, [GetLastError(), SysErrorMessage(GetLastError())]),
        EVENTLOG_ERROR_TYPE);
    end;
  end;

  procedure DoSaveDataToFile(const aFileName: string; const aData: PAnsiChar; const aDataSize: NativeUInt);
  var
    tmpStream: TBytesStream;
  begin
    tmpStream := TBytesStream.Create();
    try
      tmpStream.SetSize(aDataSize);
      tmpStream.Seek(0, soFromBeginning);
      tmpStream.WriteBuffer(aData^, aDataSize);
      tmpStream.Seek(0, soFromBeginning);
      tmpStream.SaveToFile(aFileName);
    finally
      tmpStream.Free();
    end;
  end;

  function LockClipboardData(const aClipboardDataMemoryHandle: NativeUInt): PAnsiChar;
  begin
    Result := GlobalLock(aClipboardDataMemoryHandle);
    if not Assigned(Result) then
    begin
      LogMessage(Format(RsGlobalLockError + RsLastError, [GetLastError(), SysErrorMessage(GetLastError())]),
        EVENTLOG_ERROR_TYPE);
    end;
  end;

  procedure UnlockClipboardData(const aClipboardDataMemoryHandle: NativeUInt);
  begin
    if not GlobalUnlock(aClipboardDataMemoryHandle) then
    begin
      if not(GetLastError() = NO_ERROR) then
      begin
        LogMessage(Format(RsGlobalUnlockError + RsLastError, [GetLastError(), SysErrorMessage(GetLastError())]),
          EVENTLOG_ERROR_TYPE);
      end;
    end;
  end;

  function GetClipboardDataMemoryHandle(const aClipboardFormatId: Cardinal): NativeUInt;
  begin
    Result := GetClipboardData(aClipboardFormatId);
    if Result = 0 then
    begin
      LogMessage(Format(RsGetClipboardDataError + RsLastError, [GetLastError(), SysErrorMessage(GetLastError())]),
        EVENTLOG_ERROR_TYPE);
    end;
  end;

  function GetActiveWindowCaption(): string;
  var
    tmpActiveWindowHandle: HWND;
    tmpNameBuffer: PChar;
  begin
    { TODO : Можно заменить на вызов функции класса TWindows из ShateM.Utils.Windows.pas }
    Result := EmptyStr;
    tmpNameBuffer := StrAlloc(1000);
    try
      tmpActiveWindowHandle := GetForegroundWindow();
      if GetWindowText(tmpActiveWindowHandle, tmpNameBuffer, StrBufSize(tmpNameBuffer)) = 0 then
      begin
        Exit();
      end;
      Result := tmpNameBuffer;
    finally
      StrDispose(tmpNameBuffer);
    end;
  end;

begin
  if not OpenClipboard(GetHandle()) then
  begin
    LogMessage(Format(RsOpenClipboardError + RsLastError, [GetLastError(), SysErrorMessage(GetLastError())]),
      EVENTLOG_ERROR_TYPE);
    Exit;
  end;

  try
    tmpNAVClassicDataFormatExists := False;
    tmpDataObjectDataFormatExists := False;
    tmpOlePrivateDataFormatExists := False;
    tmpMicrosoftDynamixNAVWindowActive := ContainsText(GetActiveWindowCaption(), NAV);

    tmpClipboardFormatId := 0;
    tmpCFTextDataLength := 0;

    if Assigned(aList) then
    begin
      aList.BeginUpdate();
    end;

    try
      if Assigned(aList) then
      begin
        aList.Clear();
      end;

      repeat
        tmpClipboardFormatId := EnumClipboardFormats(tmpClipboardFormatId);
        if tmpClipboardFormatId = 0 then
        begin
          Exit();
        end;

        tmpClipboardFormatName := GetClipboardFormatName(tmpClipboardFormatId);

        tmpNAVClassicDataFormatExists := tmpNAVClassicDataFormatExists or ContainsText(tmpClipboardFormatName, NAV);
        tmpDataObjectDataFormatExists := tmpDataObjectDataFormatExists or
          ContainsText(tmpClipboardFormatName, DATA_OBJECT);
        tmpOlePrivateDataFormatExists := tmpOlePrivateDataFormatExists or
          ContainsText(tmpClipboardFormatName, OLE_PRIVATE_DATA);

        if not(tmpClipboardFormatId in [2 .. 16]) then
        begin
          tmpGlobalMemoryHandle := GetClipboardDataMemoryHandle(tmpClipboardFormatId);
          if tmpGlobalMemoryHandle > 0 then
          begin
            tmpClipboardDataSize := GetClipboardDataSize(tmpGlobalMemoryHandle);
            if tmpClipboardFormatId = 1 then
            begin
              tmpCFTextDataLength := tmpClipboardDataSize;
            end
            else
            begin
              if aSaveUncommonFormatData then
              begin
                tmpClipboardData := LockClipboardData(tmpGlobalMemoryHandle);
                if Assigned(tmpClipboardData) then
                begin
                  try
                    DoSaveDataToFile(ChangeFileExt(tmpClipboardFormatName, '.txt'), tmpClipboardData,
                      tmpClipboardDataSize);
                  finally
                    UnlockClipboardData(tmpGlobalMemoryHandle);
                  end;
                end;
              end;
            end;
          end;

          if tmpNAVClassicDataFormatExists or (tmpDataObjectDataFormatExists and tmpOlePrivateDataFormatExists and
            tmpMicrosoftDynamixNAVWindowActive and (tmpCFTextDataLength > 255)) then
          begin
            LogMessage(RsForbiddenClipboardDataFounded, EVENTLOG_WARNING_TYPE);
            DoClearClipboard();
          end;
        end;
        if Assigned(aList) then
        begin
          aList.Add(Format('[%d] %s', [tmpClipboardFormatId, tmpClipboardFormatName]));
        end;
      until False;
    finally
      if Assigned(aList) then
      begin
        aList.EndUpdate();
      end;
    end;
  finally
    DoCloseClipboard();
  end;
end;

function TClipboardManager.GetHandle: HWND;
begin
  Result := FHandle;
end;

procedure TClipboardManager.WndProc(var aMessage: TMessage);
begin
  if aMessage.Msg = WM_CLIPBOARDUPDATE then
  begin
{$IFDEF DEBUG}
    LogMessage(RsClipboardWasChanged, EVENTLOG_INFORMATION_TYPE);
{$ENDIF}
    ClipboardProcessing();
  end;

  aMessage.Result := DefWindowProc(FHandle, aMessage.Msg, aMessage.WParam, aMessage.LParam);
end;

end.
