unit UnitFileUpLoad;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes,{} IdFTP , SyncObjs,
  inifiles, UnitConfig;
  { Graphics, Controls, Forms,
  Dialogs, Buttons, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, , UtilityPasZLib
   }
  function PutFTP(const sendfilename: string): boolean;
                   // ftp: TIdFTP;
implementation
const FILEINI = 'WebConfig.ini';
var FTPSect: TCriticalSection;
    ftp: TIdFTP;
    dir: string;
function PutFTP(const sendfilename: string): boolean;
var ms:  TMemoryStream;
begin
  RESULT:=false;



//    ftp.Host:='ftp.shate-m.by';// ftp адрес сервера
//    ftp.Port:=21;
//    ftp.Username:='uniexport';
//    ftp.Password:='ibyufhtd';

    ms:=TMemoryStream.Create;
    FTPSect.Enter;
    try
      try
        ftp.Connect;                    //   (true, 2000)
        AssErt(ftp.Connected);
        try
          ftp.ChangeDir(dir);//Установить папку на сервере
          ftp.Put(sendfilename,extractFileName(sendfilename));
        finally
          ftp.Disconnect;
        end;//Файл Откуда-Куда     'c:\file.txt','file.txt',false

      finally
        FTPSect.Leave;
        ms.Free; //ftp.Free;
      end;
      RESULT:=true;// exit;
    except
      //ShowMessage('Неудачная попытка отправки файла на сервер');
    end;

end;

initialization
  FTPSect:=TCriticalSection.Create;
  FTP:=TIdFTP.Create(nil);

  iniFile:=TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+FILEINI);
  try
    FTP.Host:=ReadFTPServer;
    FTP.Port:=ReadFTPPort;
    FTP.Username := ReadFTPUsername;
    FTP.Password := ReadFTPPassword;
    dir := ReadFTPDir;
  finally
    iniFile.Free;
  end;


finalization
  FreeAndNil(FTP);
  FTPSect.Free;
end.
