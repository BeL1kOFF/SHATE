unit ERP.Package.AuthMainForm.UI.FrameConnections;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridLevel, cxGrid, cxNavigator, Winapi.WinSock;

type
  TfrmConnections = class(TFrame)
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    cxGridTableView: TcxGridTableView;
    colIP: TcxGridColumn;
    ColAddress: TcxGridColumn;
    colDate: TcxGridColumn;
    colHandle: TcxGridColumn;
  public
    procedure AddConnect(aHandle: TSocket; const aIP, aAddress: string);
    procedure DeleteConnect(aHandle: TSocket);
  end;

implementation

{$R *.dfm}

{ TfrmConnections }

procedure TfrmConnections.AddConnect(aHandle: TSocket; const aIP, aAddress: string);
begin
  cxGridTableView.BeginUpdate();
  cxGridTableView.DataController.RecordCount := cxGridTableView.DataController.RecordCount + 1;
  cxGridTableView.DataController.Values[cxGridTableView.DataController.RecordCount - 1, 0] := aHandle;
  cxGridTableView.DataController.Values[cxGridTableView.DataController.RecordCount - 1, 1] := aIP;
  cxGridTableView.DataController.Values[cxGridTableView.DataController.RecordCount - 1, 2] := aAddress;
  cxGridTableView.DataController.Values[cxGridTableView.DataController.RecordCount - 1, 3] := DateToStr(Now());
  cxGridTableView.EndUpdate;
end;

procedure TfrmConnections.DeleteConnect(aHandle: TSocket);
var
  k: Integer;
begin
  cxGridTableView.BeginUpdate();
  for k := 0 to cxGridTableView.DataController.RecordCount - 1 do
  begin
    if cxGridTableView.DataController.Values[k, 0] = aHandle then
    begin
      cxGridTableView.DataController.DeleteRecord(k);
      Break;
    end;
  end;
  cxGridTableView.EndUpdate;
end;

end.
