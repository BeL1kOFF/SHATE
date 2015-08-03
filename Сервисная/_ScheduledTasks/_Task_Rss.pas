unit _Task_Rss;

interface

uses
  _ScheduledTask, Classes, StdCtrls, IdTCPClient;
  
type
  TRssTaskData = record
    RssLink: string;
    RssLinkRL: string;
    ImageDestDir: string;

    UseProxy: Boolean;
    ProxyHost: string;
    ProxyPort: Integer;
    UseProxyAutority: Boolean;
    ProxyUser: string;
    ProxyPass: string;
  end;

  TRssTaskResult = record
    Res_OK: Boolean;
    RssXml: string;
    RssXmlRL: string;
    ErrorText: string;
  end;

  TTaskRss = class(TCommonTask)
  private
    fData: TRssTaskData;
    fDataAssigned: Boolean;

    fResult: TRssTaskResult;

    procedure ClearResults;
  protected
    function InitThread(aThread: TCommonTaskThread): Boolean; override;   //перед запуском потока
    procedure DoWorkThreadTerminate(aThread: TCommonTaskThread); override;//после завершения потока (еще не разрушен)
  public
    constructor Create; override;
    destructor Destroy; override;

    //inner data
    procedure SetTaskData(const aData: TRssTaskData);
    function  GetTaskData: TRssTaskData;

    //results
    function HasResult: Boolean;

    function GetResult: string;
    function GetResultRL: string;
    function GetErrorText: string; //assigned, if HasResult = False

    class function GetTaskName: string; override;
    class function GetWorkThreadClass: TTaskThreadClass; override;
  end;

  TTaskThreadRss = class(TCommonTaskThread)
  private
    fOwner: TTaskRss;
    fTCPClient: TIdTCPClient;

    fCurProgress: string;

    fData: TRssTaskData;
    fResult: TRssTaskResult;

    procedure OutProgress;
  protected
    procedure DoExecute; override;
    procedure CallProgress(const aCaption: string);
    procedure OwnerIsDestroing; override;
  public
    procedure Init(const aData: TRssTaskData);
    function GetResult: TRssTaskResult;

    constructor Create(aOwnerTask: TCommonTask); override;
    Destructor Destroy; override;
  end;

implementation

uses
  Windows, SysUtils, IdHTTP, NativeXml;

{ TTaskRss }


class function TTaskRss.GetTaskName: string;
begin
  Result := 'Проверка остатков по TCP';
end;

class function TTaskRss.GetWorkThreadClass: TTaskThreadClass;
begin
  Result := TTaskThreadRss;
end;

constructor TTaskRss.Create;
begin
  inherited;

end;

destructor TTaskRss.Destroy;
begin
  ClearResults;
  inherited;
end;

procedure TTaskRss.ClearResults;
begin
  ZeroMemory(@fResult, SizeOf(TRssTaskResult));
end;

function TTaskRss.InitThread(aThread: TCommonTaskThread): Boolean;
begin
  Result := fDataAssigned;
  if fDataAssigned then
    (aThread as TTaskThreadRss).Init(fData);

  ClearResults;
end;

procedure TTaskRss.DoWorkThreadTerminate(aThread: TCommonTaskThread);
begin
  inherited;
  //забрать данные из потока
  fResult := (aThread as TTaskThreadRss).GetResult;
end;

function TTaskRss.HasResult: Boolean;
begin
  Result := fResult.Res_OK;
end;

function TTaskRss.GetResult: string;
begin
  Result := fResult.RssXml;
end;

function TTaskRss.GetResultRL: string;
begin
  Result := fResult.RssXmlRL;
end;

function TTaskRss.GetErrorText: string;
begin
  Result := fResult.ErrorText;
end;

function TTaskRss.GetTaskData: TRssTaskData;
begin
  Result := fData;
end;

procedure TTaskRss.SetTaskData(const aData: TRssTaskData);
begin
  fData := aData;
  fDataAssigned := True;
end;

{ TTaskThreadRss }

constructor TTaskThreadRss.Create(aOwnerTask: TCommonTask);
begin
  inherited;
  if Assigned(aOwnerTask) then
    if aOwnerTask is TTaskRss then
      fOwner := aOwnerTask as TTaskRss;

  fTCPClient := TIdTCPClient.Create(nil);
end;

destructor TTaskThreadRss.Destroy;
begin
  fTCPClient.Disconnect;
  fTCPClient.Free;

  inherited;
end;

procedure TTaskThreadRss.CallProgress(const aCaption: string);
begin
  fCurProgress := aCaption;
  Synchronize(OutProgress);
end;

procedure TTaskThreadRss.DoExecute;
var
  i: Integer;
  s: string;
  aHttp: TIdHTTP;
  aStream: TStringStream;

  aList: TList;
  aXMLDoc: TNativeXml;
  aNode: TXmlNode;
  aImageUrl, aImageName: string;
  aImageStream: TMemoryStream;
begin
  inherited;

  CallProgress('TTaskThreadRss.DoExecute');

  if Terminated then
    Exit;

  if not Assigned(fOwner) then
    Exit;

  fResult.Res_OK := False;

  aHttp := TIdHTTP.Create(nil);
  aList := TList.Create;
  try
    if fData.UseProxy then
    begin
      aHttp.ProxyParams.ProxyServer := fData.ProxyHost;
      aHttp.ProxyParams.ProxyPort := fData.ProxyPort;
      aHttp.ProxyParams.BasicAuthentication := fData.UseProxyAutority;
      if fData.UseProxyAutority then
      begin
        aHttp.ProxyParams.ProxyUsername := fData.ProxyUser;
        aHttp.ProxyParams.ProxyPassword := fData.ProxyPass;
      end;
    end;

    aStream := TStringStream.Create('');
    try

      try
        aHttp.Get(fData.RssLinkRL, aStream);
        s := Utf8ToAnsi(aStream.DataString);
        fResult.RssXmlRL := s;

        s := '';
        aStream.Free;
        aStream := TStringStream.Create('');

        aHttp.Get(fData.RssLink, aStream);
        s := Utf8ToAnsi(aStream.DataString);
        fResult.RssXml := s;
      except
        on E: Exception do
        begin
          fResult.ErrorText := 'Нет связи с сервером!'#13#10 + E.Message; //get error
          Exit;
        end;
      end;

    finally
      aStream.Free;
    end;

//parse XML and download images
    fData.ImageDestDir := IncludeTrailingPathDelimiter(fData.ImageDestDir);
    if not DirectoryExists(fData.ImageDestDir) then
      ForceDirectories(fData.ImageDestDir);

    aXMLDoc := TNativeXml.Create;
    aXMLDoc.ReadFromString(s);
    //RSS/Channel/...Item
    aXMLDoc.Root.NodeByName('Channel').NodesByName('Item', aList);

    for i := 0 to aList.Count - 1 do
    begin
      aNode := aList[i];
      aImageUrl := aNode.NodeByName('enclosure').AttributeByName['url'];
      aImageName := aImageUrl;
      while Pos('/', aImageName) > 0 do
        Delete(aImageName, 1, Pos('/', aImageName));

      if aImageName <> '' then
      begin
        if not FileExists(fData.ImageDestDir + aImageName) then
        begin
          aImageStream := TMemoryStream.Create;
          try
            try
              aHttp.Get(aImageUrl, aImageStream);
              aImageStream.SaveToFile(fData.ImageDestDir + aImageName);
            except
            end;
          finally
            aImageStream.Free;
          end;
        end;
      end;
    end;

    fResult.Res_OK := True;
  finally
    aList.Free;
    aHttp.Free;
  end;
end;

function TTaskThreadRss.GetResult: TRssTaskResult;
begin
  Result := fResult;
end;

procedure TTaskThreadRss.Init(const aData: TRssTaskData);
begin
  fData := aData;
  ZeroMemory(@fResult, SizeOf(TRssTaskResult));
end;

procedure TTaskThreadRss.OutProgress;
begin
  //do nothing
end;

procedure TTaskThreadRss.OwnerIsDestroing;
begin
  inherited;
  fOwner := nil;
end;

end.
