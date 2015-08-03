unit _ServSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BSDlgFrm, StdCtrls, AdvEdit, DBAdvEd, JvComponentBase,
  JvFormPlacement, Buttons, ExtCtrls, DBCtrls, BSStrUt, Db, Mask;

type
  TServSetup = class(TDialogForm)
    FormStorage: TJvFormStorage;
    IgnCharsEd: TDBAdvEdit;
    Label1: TLabel;
    Label2: TLabel;
    ShateEmailEd: TDBAdvEdit;
    Label7: TLabel;
    ProgVersionEd: TDBAdvEdit;
    LogCheckBox: TDBCheckBox;
    Label15: TLabel;
    UpdateUrlEd: TDBAdvEdit;
    Label3: TLabel;
    DataVersionEd: TDBAdvEdit;
    Label4: TLabel;
    QuantVersionEd: TDBAdvEdit;
    Label5: TLabel;
    NewsVersionEd: TDBAdvEdit;
    Label6: TLabel;
    ActPeriodEd: TDBAdvEdit;
    Label8: TLabel;
    ActWarnPeriodEd: TDBAdvEdit;
    Label9: TLabel;
    Label10: TLabel;
    VerInfo1Ed: TDBAdvEdit;
    VerInfo2Ed: TDBAdvEdit;
    Label11: TLabel;
    HostEd: TDBAdvEdit;
    PortEd: TDBAdvEdit;
    Label12: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label13: TLabel;
    OrdSendInfoEd: TDBAdvEdit;
    Label14: TLabel;
    DBAdvEditIn: TDBAdvEdit;
    EdBackHost: TDBAdvEdit;
    Label16: TLabel;
    DBAdvEdit1: TDBAdvEdit;
    Label17: TLabel;
    Label18: TLabel;
    EdHost3: TDBAdvEdit;
    Label19: TLabel;
    DBAdvEdit2: TDBAdvEdit;
    Label20: TLabel;
    QuestionEmail: TDBAdvEdit;
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServSetup: TServSetup;

implementation

uses _Main, _Data;

{$R *.dfm}

procedure TServSetup.CancelBtnClick(Sender: TObject);
begin
  inherited;
  Data.SysParamTable.Cancel;
end;

procedure TServSetup.FormCreate(Sender: TObject);
begin
  inherited;
  DataSource := Data.VersionDataSource;
end;

procedure TServSetup.OkBtnClick(Sender: TObject);
begin
  inherited;
  Data.Load_Log := Data.SysParamTable.FieldByName('Load_log').AsBoolean;
  Data.Ign_chars := Data.SysParamTable.FieldByName('Ign_chars').AsString;
  with Data.VersionTable do
  begin
    Main.CurrProgVersion  := FieldByName('ProgVersion').AsString;
    Main.CurrDataVersion  := FieldByName('DataVersion').AsString;
    Main.CurrQuantVersion := FieldByName('QuantVersion').AsString;
    Main.CurrNewsVersion  := FieldByName('NewsVersion').AsString;
  end;
  if Data.SysParamTable.State = dsEdit then
    Data.SysParamTable.Post;
end;

end.
