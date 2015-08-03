unit ERP.Package.CustomForm.TERPCustomForm;

interface

uses
  Winapi.Messages,
  System.Types,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  FireDAC.Comp.Client,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.ClientInterface.IERPClientData;

type
  TERPCustomForm = class(TForm)
  private
    FFDConnection: TFDConnection;
    FERPClientData: IERPClientData;
    FMonitorMaximized: THandle;
    procedure WMMainResize(var aMessage: TMessage); message ERPM_MAIN_RESIZE;
    procedure WMGetMinMaxInfo(var aMessage: TWMGetMinmaxInfo); message WM_GETMINMAXINFO;
  protected
    procedure CreateParams(var aParam: TCreateParams); override;
    procedure DoClose(var aAction: TCloseAction); override;
    procedure ShowError(aText: string);
    procedure ShowMessage(aText: string);
  public
    constructor Create(const aCaption: string; aERPClientData: IERPClientData); reintroduce;
    destructor Destroy; override;
    property FDConnection: TFDConnection read FFDConnection;
    property ERPClientData: IERPClientData read FERPClientData;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  System.Variants,
  FireDAC.Stan.Option;

{ TERPCustomForm }

procedure TERPCustomForm.CreateParams(var aParam: TCreateParams);
begin
  inherited CreateParams(aParam);
  aParam.Style := aParam.Style or WS_MAXIMIZE;
end;

constructor TERPCustomForm.Create(const aCaption: string; aERPClientData: IERPClientData);
begin
  inherited Create(nil);
  FERPClientData := aERPClientData;
  { TODO 1 : Временное решение до устранения бага Embracadero с SharedCliHandle }
{  FFDConnection := TFDConnection.Create(Self);
  FFDConnection.LoginPrompt := False;
  FFDConnection.FetchOptions.Mode := fmAll;
  FFDConnection.ResourceOptions.SilentMode := True;
  FFDConnection.SharedCliHandle := aERPClientData.ERPApplication.ModuleConnection.FDConnectionHandle;}
  FFDConnection := aERPClientData.ERPApplication.ModuleConnection.FDConnection;
  Caption := aERPClientData.ERPApplication.ModuleConnection.DataBaseCaption + ' - ' + aCaption;
  BorderIcons := BorderIcons - [biMinimize];
end;

destructor TERPCustomForm.Destroy;
begin
  PostMessage(FERPClientData.ERPApplication.ApplicationHandle, ERPM_CHILD_CLOSE, Handle, 0);
  FERPClientData := nil;
  inherited Destroy();
end;

procedure TERPCustomForm.DoClose(var aAction: TCloseAction);
begin
  aAction := caFree;
  inherited DoClose(aAction);
end;

procedure TERPCustomForm.ShowError(aText: string);
begin
  Application.MessageBox(PChar(aText), 'Ошибка', MB_OK or MB_ICONERROR);
end;

procedure TERPCustomForm.ShowMessage(aText: string);
begin
  Application.MessageBox(PChar(aText), 'Сообщение', MB_OK or MB_ICONINFORMATION);
end;

procedure TERPCustomForm.WMGetMinMaxInfo(var aMessage: TWMGetMinmaxInfo);
var
  RectClient: TRect;
begin
  if Assigned(FERPClientData) then
  begin
    if FERPClientData.ERPApplication.ApplicationMonitor = Monitor.Handle then
    begin
        RectClient := FERPClientData.ERPApplication.ApplicationClientBounds;
        aMessage.MinMaxInfo^.ptMaxPosition := RectClient.TopLeft - Point(Monitor.Left, Monitor.Top);
        aMessage.MinMaxInfo^.ptMaxSize.Create(RectClient.Width, RectClient.Height);
        aMessage.Result := 0;
        FMonitorMaximized := 0;
    end
    else
      FMonitorMaximized := Monitor.Handle;
  end;
end;

procedure TERPCustomForm.WMMainResize(var aMessage: TMessage);
var
  RectClient: TRect;
begin
  if WindowState = wsMaximized then
  begin
    if (FERPClientData.ERPApplication.ApplicationMonitor = Monitor.Handle) or (FMonitorMaximized = 0) then
    begin
      RectClient := FERPClientData.ERPApplication.ApplicationClientBounds;
      SetBounds(RectClient.Left, RectClient.Top, RectClient.Width, RectClient.Height);
      FMonitorMaximized := 0;
    end;
  end;
end;

end.
