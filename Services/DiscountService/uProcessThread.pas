unit uProcessThread;

interface

uses
  Classes, uMain, SvcMgr;

type
  TProcessThread = class(TThread)
  private
    fOwnerService: TServiceDiscounts;
    fPrefs: TPrefs;
  protected
    procedure Execute; override;
    procedure DoExecute_Old;
    procedure DoExecute_NAV;
  public
    constructor Create(aOwnerService: TServiceDiscounts);
    destructor Destroy; override;
    procedure Init(const aPrefs: TPrefs);
  end;

implementation

uses
  SysUtils, Windows;

{ TProcessThread }

constructor TProcessThread.Create(aOwnerService: TServiceDiscounts);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  fOwnerService := aOwnerService;
end;

destructor TProcessThread.Destroy;
begin
  //...
  inherited;
end;

procedure TProcessThread.DoExecute_NAV;
var
  t: Cardinal;
  aFirstRun, aHasChanges: Boolean;
  aTask: TNAV_FileTask;
  aProcessed: Boolean;
  aNewFileName: string;
  aLockedFile: Boolean;
begin
  aFirstRun := True;
  //Sleep(15000);
  t := 0;
  while not Terminated do
  begin
    if GetTickCount - t > fPrefs.ScanFilesInterval * 1000 then
    begin
      try
        if aFirstRun then
        begin
          aFirstRun := False;
          fOwnerService.NAV_RePack(fPrefs.RebuildAllOnStartup, cAllClientRespondTypes);
        end;

        aProcessed := False;
        if not Terminated then
        begin
          fOwnerService.AddLog('Сканирую новые файлы (NAV)...', True);

          aLockedFile := False;
          aTask := fOwnerService.NAV_ScanForTask;
          case aTask.FileType of
            nftNone: {do nothing};

            nftDiscounts:
            begin
              //aProcessed := fOwnerService.NAV_LoadDiscounts(aTask.FileName);
              aProcessed := fOwnerService.LoadDiscounts(aTask.FileName);
            end;
            
            nftFullClients:
            begin
              aProcessed := fOwnerService.LoadClients(aTask.FileName, False{IsPartial});
            end;

            nftPartClients:
            begin
              aProcessed := fOwnerService.LoadClients(aTask.FileName, True{IsPartial});
            end;

            nftAgreements:
            begin
              aProcessed := fOwnerService.NAV_LoadAgreement(aTask.FileName);
            end;

            nftAddress:
            begin
              aProcessed := fOwnerService.NAV_LoadAddess(aTask.FileName);
            end;
            
            nftClientsDescr:
            begin
              aProcessed := fOwnerService.NAV_LoadClientsDescr(aTask.FileName);
            end;
            
          end;

        end;

        if aProcessed then
        begin
          //записываем время последнего обработанного файла
          fOwnerService.NAV_SaveProcessedData(aTask.FileType, aTask.FileDateTime);

          //переименовываем/удаляем
          if not aLockedFile then
          begin
          {
            if ((aTask.FileType in [ftFullDiscounts, ftPartDiscounts]) and fPrefs.RenameProcessedDiscounts) or
               ((aTask.FileType in [ftFullClients, ftPartClients]) and fPrefs.RenameProcessedClients) then
            begin //переименовать
              aNewFileName := ExtractFilePath(aTask.FileName) + FormatDateTime('YYMMDD_hh.nn.ss_', Now) + ExtractFileName(aTask.FileName);
              if RenameFile(aTask.FileName, aNewFileName) then
                fOwnerService.AddLog('переименован: ' + aTask.FileName + ' -> ' + aNewFileName)
              else
                fOwnerService.AddLog('!НЕ переименован: ' + aTask.FileName + ' -> ' + aNewFileName);
            end
            else
            begin //удалить
              if DeleteFile(PChar(aTask.FileName)) then
                fOwnerService.AddLog('удален: ' + aTask.FileName)
              else
                fOwnerService.AddLog('!НЕ удален: ' + aTask.FileName);
            end;
          }
          end;
        end;

        if not Terminated then
          case aTask.FileType of
            nftNone        : {do nothing};
            nftFullClients : fOwnerService.NAV_RePack(False{aForceAll}, cAllClientRespondTypes); //перепак. все т.к. меняется пароль
            nftPartClients : fOwnerService.NAV_RePack(False{aForceAll}, cAllClientRespondTypes); //перепак. все т.к. меняется пароль
            nftAgreements  : fOwnerService.NAV_RePack(False{aForceAll}, [crtAGREEMENTS, crtDISCOUNTS]);
            nftAddress     : fOwnerService.NAV_RePack(False{aForceAll}, [crtADDRESS]);
            nftDiscounts   : fOwnerService.NAV_RePack(False{aForceAll}, [crtDISCOUNTS]);
          end;
 
      except
        on E: Exception do
        begin
          fOwnerService.AddLog('!EXCEPTION: ' + E.Message);
          fOwnerService.AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!EXCEPTION: ' + E.Message, True);
        end;
      end;
      t := GetTickCount;
    end;
    Sleep(250);
  end;
end;


procedure TProcessThread.DoExecute_Old;
var
  t: Cardinal;
  aFirstRun, aHasChanges: Boolean;
  aTask: TFileTask;
  aProcessed: Boolean;
  aNewFileName: string;
  aLockedFile: Boolean;
begin
  aFirstRun := True;
  
  t := 0;
  while not Terminated do
  begin
    if GetTickCount - t > fPrefs.ScanFilesInterval * 1000 then
    begin
      try
        if aFirstRun then
        begin
          aFirstRun := False;

          //fOwnerService.LoadMap(ExtractFilePath(ParamStr(0)) + fPrefs.LotusMapFile);
          fOwnerService.RePack(fPrefs.RebuildAllOnStartup);
        end;

        aProcessed := False;
        if not Terminated then
        begin

          {
          fOwnerService.AddLog('Листинг файлов...', True);
          fOwnerService.SaveFileList;
          }

          fOwnerService.AddLog('Сканирую новые файлы...', True);

          aLockedFile := False;
          aTask := fOwnerService.ScanForTask;
          case aTask.FileType of
            ftNone: {do nothing};

            ftFullDiscounts:
            begin
              aProcessed := fOwnerService.LoadDiscounts(aTask.FileName);
            end;

            ftFullClients:
            begin
              aProcessed := fOwnerService.LoadClients(aTask.FileName, False{IsPartial});
            end;

            //импорт описаний клиентов из \\10.0.0.1\Part-kom 
            ftClientsDescr:
            begin
              aProcessed := fOwnerService.LoadClientsDescr(aTask.FileName);
              //файл нельзя удалять/перемещать, т.к. он используется еще и для сайта
              aLockedFile := True;
            end;

            ftPartDiscounts:
            begin
              aProcessed := fOwnerService.LoadDiscounts(aTask.FileName);
            end;

            ftPartClients:
            begin
              aProcessed := fOwnerService.LoadClients(aTask.FileName, True{IsPartial});
            end;
          end;

        end;

        if aProcessed then
        begin
          //записываем время последнего обработанного файла
          fOwnerService.SaveProcessedData(aTask.FileType, aTask.FileDateTime);

          //переименовываем/удаляем
          if not aLockedFile then
          begin
          {
            if ((aTask.FileType in [ftFullDiscounts, ftPartDiscounts]) and fPrefs.RenameProcessedDiscounts) or
               ((aTask.FileType in [ftFullClients, ftPartClients]) and fPrefs.RenameProcessedClients) then
            begin //переименовать
              aNewFileName := ExtractFilePath(aTask.FileName) + FormatDateTime('YYMMDD_hh.nn.ss_', Now) + ExtractFileName(aTask.FileName);
              if RenameFile(aTask.FileName, aNewFileName) then
                fOwnerService.AddLog('переименован: ' + aTask.FileName + ' -> ' + aNewFileName)
              else
                fOwnerService.AddLog('!НЕ переименован: ' + aTask.FileName + ' -> ' + aNewFileName);
            end
            else
            begin //удалить
              if DeleteFile(PChar(aTask.FileName)) then
                fOwnerService.AddLog('удален: ' + aTask.FileName)
              else
                fOwnerService.AddLog('!НЕ удален: ' + aTask.FileName);
            end;
          }
          end;
        end;

        if not Terminated then
          if (aTask.FileType <> ftNone) and (aTask.FileType <> ftClientsDescr) then
            fOwnerService.RePack(False{aForceAll});

      except
        on E: Exception do
        begin
          fOwnerService.AddLog('!EXCEPTION: ' + E.Message);
          fOwnerService.AddEmailReport(FormatDateTime('DD.MM.YYYY hh.nn.ss - ', Now) + '!EXCEPTION: ' + E.Message, True);
        end;
      end;
      t := GetTickCount;
    end;
    Sleep(250);
  end;
end;

procedure TProcessThread.Execute;
begin
  fOwnerService.AddLog('TProcessThread started', True);
  //DoExecute_Old; 
  
  //!!! откоментить после перехода на NAV
  DoExecute_NAV; 
  
  fOwnerService.AddLog('TProcessThread stopped', True);
end;

procedure TProcessThread.Init(const aPrefs: TPrefs);
begin
  fPrefs := aPrefs;
end;

end.
