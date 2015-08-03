unit MDM.Catalog.UI.TradeMarkDetail;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Actions,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ActnList,
  Data.DB,
  FireDAC.Comp.Client,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxContainer,
  cxEdit,
  cxLabel,
  cxTextEdit,
  cxCheckBox,
  cxImage,
  MDM.Package.Classes.TCustomFormDetail,
  MDM.Package.Interfaces.ICatalogDraftController,
  MDM.Catalog.Logic.TTradeMarkDraft, cxMemo;

type
  TfrmMDMTradeMarkDetail = class(TCustomFormDetail)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acCancel: TAction;
    acSave: TAction;
    edtName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    edtFullName: TcxTextEdit;
    cbOriginal: TcxCheckBox;
    cxLabel3: TcxLabel;
    imgLogo: TcxImage;
    odLogo: TOpenDialog;
    edtVersion: TcxTextEdit;
    cxLabel4: TcxLabel;
    lbWarning: TcxLabel;
    edtIdTradeMark: TcxTextEdit;
    cxLabel5: TcxLabel;
    edtURLCatalog: TcxTextEdit;
    cxLabel6: TcxLabel;
    edtURLSite: TcxTextEdit;
    mDescription: TcxMemo;
    cxLabel7: TcxLabel;
    procedure acCancelExecute(Sender: TObject);
    procedure imgLogoDblClick(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtNameExit(Sender: TObject);
  private
    FOldName: string;
    FUserName: string;
    FIsSaveEnabled: Boolean;
    function Save: Boolean;
    function IsLogicExists: Boolean;

    function GetTradeMarkDraft: TTradeMarkDraft;
    property TradeMarkDraft: TTradeMarkDraft read GetTradeMarkDraft;
  protected
    procedure AfterInitItem; override;
    procedure InitEditItem; override;
    procedure InitNewItem; override;
  public
    constructor Create(aOwner: TComponent; aCatalogDraftController: ICatalogDraftController;
      const aUserName: string); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  Vcl.Graphics,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_TM_DRAFT_ITEM_CHECK  = 'tm_draft_item_check :UserName, :Name';

procedure TfrmMDMTradeMarkDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmMDMTradeMarkDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmMDMTradeMarkDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (edtName.Text <> '') and FIsSaveEnabled;
end;

procedure TfrmMDMTradeMarkDetail.AfterInitItem;
begin
  inherited AfterInitItem();
  FOldName := edtName.Text;
  edtName.SetFocus();
end;

constructor TfrmMDMTradeMarkDetail.Create(aOwner: TComponent; aCatalogDraftController: ICatalogDraftController;
  const aUserName: string);
begin
  inherited Create(aOwner, aCatalogDraftController);
  FUserName := aUserName;
end;

procedure TfrmMDMTradeMarkDetail.edtNameExit(Sender: TObject);
begin
  if TradeMarkDraft.IsNewItem() or (FOldName <> edtName.Text) then
    lbWarning.Visible := IsLogicExists()
  else
    lbWarning.Visible := False;
end;

procedure TfrmMDMTradeMarkDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

function TfrmMDMTradeMarkDetail.GetTradeMarkDraft: TTradeMarkDraft;
begin
  Result := inherited CatalogDraftController as TTradeMarkDraft;
end;

procedure TfrmMDMTradeMarkDetail.imgLogoDblClick(Sender: TObject);
var
  Stream: TBytesStream;
begin
  if odLogo.Execute() then
  begin
    Stream := TBytesStream.Create();
    try
      Stream.LoadFromFile(odLogo.FileName);
      imgLogo.Properties.GraphicClassName := TERPMethodHelp.GetImageClassNameFromHeader(Stream.Bytes);
      if not SameText(imgLogo.Properties.GraphicClassName, '') then
        imgLogo.Picture.LoadFromFile(odLogo.FileName)
      else
        imgLogo.Picture.Graphic := nil;
    finally
      Stream.Free();
    end;
  end;
end;

procedure TfrmMDMTradeMarkDetail.InitEditItem;
var
  ImgBuffer: TBytes;
  Stream: TBytesStream;
  Graphic: TGraphic;
begin
  inherited InitEditItem();
  edtName.Text := TradeMarkDraft.Item.Name;
  edtFullName.Text := TradeMarkDraft.Item.FullName;
  cbOriginal.Checked := TradeMarkDraft.Item.IsOriginal;
  edtVersion.EditValue := TradeMarkDraft.Item.Version;
  edtIdTradeMark.EditValue := TradeMarkDraft.Item.Id_TradeMark;
  edtURLSite.Text := TradeMarkDraft.Item.URLSite;
  edtURLCatalog.Text := TradeMarkDraft.Item.URLCatalog;
  mDescription.Lines.Text := TradeMarkDraft.Item.Description;
  if not VarIsNull(TradeMarkDraft.Item.Logo) then
  begin
    ImgBuffer := TradeMarkDraft.Item.Logo;
    imgLogo.Properties.GraphicClassName := TERPMethodHelp.GetImageClassNameFromHeader(ImgBuffer);
    if not SameText(imgLogo.Properties.GraphicClassName, '') then
    begin
      Stream := TBytesStream.Create(ImgBuffer);
      try
        Graphic := imgLogo.Properties.GraphicClass.Create();
        try
          Graphic.LoadFromStream(Stream);
          imgLogo.Picture.Graphic := Graphic;
        finally
          Graphic.Free();
        end;
      finally
        Stream.Free();
      end;
    end
    else
      imgLogo.Picture.Graphic := nil;
  end
  else
    imgLogo.Picture.Graphic := nil;
  FIsSaveEnabled := True;
end;

procedure TfrmMDMTradeMarkDetail.InitNewItem;
begin
  inherited InitNewItem();
  FIsSaveEnabled := False;
  edtName.Text := '';
  edtFullName.Text := '';
  mDescription.Lines.Clear();
  cbOriginal.Checked := False;
  imgLogo.Picture.Graphic := nil;
  edtURLCatalog.Text := '';
  edtURLSite.Text := '';
  edtVersion.EditValue := Null();
  edtIdTradeMark.EditValue := Null();
end;

function TfrmMDMTradeMarkDetail.IsLogicExists: Boolean;
var
  QueryResult: TERPQueryResult;
begin
  QueryResult := TERPQueryHelp.Check(FDConnection, PROC_TM_DRAFT_ITEM_CHECK, [TERPParamValue.Create(FUserName),
                                                                              TERPParamValue.Create(edtName.Text)]);
  lbWarning.Caption := QueryResult.Text;
  FIsSaveEnabled := (QueryResult.Status <> QUERY_RESULT_ERROR) or not (VarIsNull(edtIdTradeMark.EditValue));
  Result := QueryResult.Status <> QUERY_RESULT_OK;
end;

function TfrmMDMTradeMarkDetail.Save: Boolean;
var
  Stream: TBytesStream;
begin
  CreateSQLCursor();
  TradeMarkDraft.Item.Name := edtName.Text;
  TradeMarkDraft.Item.FullName := edtFullName.Text;
  TradeMarkDraft.Item.IsOriginal := cbOriginal.Checked;
  TradeMarkDraft.Item.Description := mDescription.Lines.Text;
  TradeMarkDraft.Item.URLSite := edtURLSite.Text;
  TradeMarkDraft.Item.URLCatalog := edtURLCatalog.Text;
  if Assigned(imgLogo.Picture.Graphic) then
  begin
    Stream := TBytesStream.Create();
    try
      imgLogo.Picture.Graphic.SaveToStream(Stream);
      TradeMarkDraft.Item.Logo := Stream.Bytes;
    finally
      Stream.Free();
    end;
  end
  else
    TradeMarkDraft.Item.Logo := Null();
  Result := TradeMarkDraft.Save();
end;

end.
