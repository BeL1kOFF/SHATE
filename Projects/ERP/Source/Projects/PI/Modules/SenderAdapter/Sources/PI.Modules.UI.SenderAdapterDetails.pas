unit PI.Modules.UI.SenderAdapterDetails;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  ERP.Package.ClientInterface.IERPClientData, cxStyles, cxInplaceContainer, cxVGrid, Xml.xmldom, Xml.XMLIntf,
  Xml.Win.msxmldom, Xml.XMLDoc, Vcl.ExtCtrls, Vcl.StdCtrls, System.Actions, Vcl.ActnList, cxCustomData, cxTL,
  cxTLdxBarBuiltInMenu, Vcl.ComCtrls, cxTreeView, Data.DB;

type
  TfrmSenderAdapterDetails = class(TForm)
    XMLDocument: TXMLDocument;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    ActionList: TActionList;
    acCancel: TAction;
    acSave: TAction;
    Panel2: TPanel;
    cxLabel1: TcxLabel;
    cmbPlugins: TcxComboBox;
    Panel3: TPanel;
    Panel4: TPanel;
    tlProperty: TcxTreeList;
    tlPropertyColumn1: TcxTreeListColumn;
    tlPropertyColumn2: TcxTreeListColumn;
    procedure FormShow(Sender: TObject);
    procedure cmbPluginsPropertiesChange(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure tlPropertyEditing(Sender: TcxCustomTreeList; AColumn: TcxTreeListColumn; var Allow: Boolean);
  private
    FERPClientData: IERPClientData;
    FId_SenderAdapter: Integer;
    FId_Plugin: Integer;
    function CallBackClassNotFound(aControl: TControl; aField: TField): Boolean;
    function Save: Boolean;
    procedure ClearPluginList;
    procedure FillAdapterList;
    procedure Init;
    procedure InitNew;
    procedure InitOld;
    procedure LoadXmlToTree(aNode: IXMLNode; aParentTreeNode: TcxTreeListNode);
  public
    constructor Create(aOwner: TComponent; aId_SenderAdapter: Integer; aERPClientData: IERPClientData); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  FireDAC.Comp.Client,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

type
  TPlugin = class
    Id_Plugin: Integer;
    Version: Integer;
  end;

{ TfrmSenderAdapterDetails }

procedure TfrmSenderAdapterDetails.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmSenderAdapterDetails.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmSenderAdapterDetails.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cmbPlugins.ItemIndex > -1;
end;

function TfrmSenderAdapterDetails.CallBackClassNotFound(aControl: TControl; aField: TField): Boolean;

  function GetPluginItemIndexOfIdPlugin(aId_Plugin: Integer): Integer;
  var
    k: Integer;
  begin
    for k := 0 to cmbPlugins.Properties.Items.Count - 1 do
      if (cmbPlugins.Properties.Items.Objects[k] as TPlugin).Id_Plugin = aId_Plugin then
        Exit(k);
    Result := -1;
  end;

begin
  Result := True;
  if aControl = cmbPlugins then
  begin
    cmbPlugins.ItemIndex := GetPluginItemIndexOfIdPlugin(aField.AsInteger);
    cmbPlugins.Properties.ReadOnly := True;
    cmbPlugins.ParentColor := True;
  end
  else
    Result := False;
end;

procedure TfrmSenderAdapterDetails.ClearPluginList;
var
  k: Integer;
begin
  for k := 0 to cmbPlugins.Properties.Items.Count - 1 do
    cmbPlugins.Properties.Items.Objects[k].Free();
  cmbPlugins.Properties.Items.Clear();
end;

procedure TfrmSenderAdapterDetails.cmbPluginsPropertiesChange(Sender: TObject);
var
  Query: TFDQuery;
begin
  tlProperty.Clear();
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FERPClientData.ERPApplication.ModuleConnection.FDConnection;
    Query.SQL.Text := 'cln.sa_item_properties_sel :Id_Plugin, :Id_SenderAdapter';
    Query.Params.ParamValues['Id_Plugin'] := (cmbPlugins.ItemObject as TPlugin).Id_Plugin;
    if FId_SenderAdapter = -1 then
    begin
      Query.Params.ParamByName('Id_SenderAdapter').DataType := ftInteger;
      Query.Params.ParamByName('Id_SenderAdapter').Value := Null();
    end
    else
      Query.Params.ParamByName('Id_SenderAdapter').Value := FId_SenderAdapter;
    Query.Open();
    XMLDocument.LoadFromXML(Query.FieldByName('Properties').AsString);
    LoadXMLToTree(XMLDocument.DocumentElement, tlProperty.Root);
  finally
    Query.Free();
  end;
  if Assigned(tlProperty.Root) then
    tlProperty.Root.Expand(True);
end;

constructor TfrmSenderAdapterDetails.Create(aOwner: TComponent; aId_SenderAdapter: Integer;
  aERPClientData: IERPClientData);
begin
  FId_SenderAdapter := aId_SenderAdapter;
  FERPClientData := aERPClientData;
  inherited Create(aOwner);
end;

procedure TfrmSenderAdapterDetails.FillAdapterList;
var
  Query: TFDQuery;
  Plugin: TPlugin;
begin
  ClearPluginList();
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FERPClientData.ERPApplication.ModuleConnection.FDConnection;
    Query.SQL.Text := 'cln.sa_item_plugins_sel :Id_SenderAdapter';
    if FId_SenderAdapter = -1 then
    begin
      Query.Params.ParamByName('Id_SenderAdapter').DataType := ftInteger;
      Query.Params.ParamByName('Id_SenderAdapter').Value := Null();
    end
    else
      Query.Params.ParamByName('Id_SenderAdapter').AsInteger := FId_SenderAdapter;
    Query.Open();
    Query.First();
    while not Query.Eof do
    begin
      Plugin := TPlugin.Create();
      try
        Plugin.Id_Plugin := Query.FieldByName('Id_Plugin').AsInteger;
        Plugin.Version := Query.FieldByName('Version').AsInteger;
        cmbPlugins.Properties.Items.AddObject(Query.FieldByName('Name').AsString, Plugin);
      except
      begin
        FreeAndNil(Plugin);
        raise;
      end;
      end;
      Query.Next();
    end;
  finally
    Query.Free();
  end;
end;

procedure TfrmSenderAdapterDetails.FormDestroy(Sender: TObject);
begin
  ClearPluginList();
end;

procedure TfrmSenderAdapterDetails.FormShow(Sender: TObject);
begin
  Init();
end;

procedure TfrmSenderAdapterDetails.Init;
begin
  FillAdapterList();
  if FId_SenderAdapter = -1 then
    InitNew()
  else
    InitOld();
end;

procedure TfrmSenderAdapterDetails.InitNew;
begin
  FId_Plugin := -1;
  cmbPlugins.ItemIndex := -1;
  tlProperty.Clear();
end;

procedure TfrmSenderAdapterDetails.InitOld;
begin
  TERPQueryHelp.ReadItem(FERPClientData.ERPApplication.ModuleConnection.FDConnection,
    'cln.sa_item_sel :Id_SenderAdapter', [TERPParamValue.Create(FId_SenderAdapter)],
    [TERPControlValue.Create(cmbPlugins, 'Id_Plugin', False)], CallBackClassNotFound);
end;

procedure TfrmSenderAdapterDetails.LoadXMLToTree(aNode: IXMLNode; aParentTreeNode: TcxTreeListNode);
var
  TreeNode: TcxTreeListNode;
  TextValue: string;
begin
  if not Assigned(aNode) or (SameText(aNode.NodeName, '#text')) then
    Exit;
  if aNode.IsTextElement then
    TextValue := aNode.NodeValue
  else
    TextValue := '';
  TreeNode := aParentTreeNode.AddChild;
  TreeNode.Data := Pointer(aNode);
  TreeNode.Values[0] := aNode.NodeName;
  TreeNode.Values[1] := TextValue;
  if aNode.HasChildNodes then
    LoadXMLToTree(aNode.ChildNodes.First, TreeNode);
  LoadXMLToTree(aNode.NextSibling, aParentTreeNode);
end;

function TfrmSenderAdapterDetails.Save: Boolean;
var
  k: Integer;
  Value: Variant;
begin

  for k := 0 to tlProperty.AbsoluteCount - 1 do
  begin
    Value := tlProperty.AbsoluteItems[k].Values[1];
    if not tlProperty.AbsoluteItems[k].HasChildren and
       (Value <> IXMLNode(tlProperty.AbsoluteItems[k].Data).NodeValue) then
      IXMLNode(tlProperty.AbsoluteItems[k].Data).NodeValue := Value;
  end;

  if FId_SenderAdapter = -1 then
    Result := TERPQueryHelp.Open(FERPClientData.ERPApplication.ModuleConnection.FDConnection,
                'cln.sa_item_ins :Id_Plugin, :Properties, :Version',
                [TERPParamValue.Create((cmbPlugins.ItemObject as TPlugin).Id_Plugin),
                 TERPParamValue.Create(XMLDocument.DocumentElement.XML),
                 TERPParamValue.Create((cmbPlugins.ItemObject as TPlugin).Version)])
  else
    Result := TERPQueryHelp.Open(FERPClientData.ERPApplication.ModuleConnection.FDConnection,
                'cln.sa_item_upd :Id_SenderAdapter, :Properties',
                [TERPParamValue.Create(FId_SenderAdapter),
                 TERPParamValue.Create(XMLDocument.DocumentElement.XML)]);
end;

procedure TfrmSenderAdapterDetails.tlPropertyEditing(Sender: TcxCustomTreeList; AColumn: TcxTreeListColumn;
  var Allow: Boolean);
begin
  Allow := not Sender.FocusedNode.HasChildren;
end;

end.
