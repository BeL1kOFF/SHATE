unit uDM;

interface

uses
  SysUtils, Classes, DB, dbisamtb;

type
  TDM = class(TDataModule)
    DBISAMEngine: TDBISAMEngine;
    Database: TDBISAMDatabase;
    DBITable: TDBISAMTable;
  private
    { Private declarations }
  public
    procedure InitDatabase(const aDatabaseDir: string);
    function GetCrosses(const aCode, aBrand: string): string;
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

{ TDM }

function TDM.GetCrosses(const aCode, aBrand: string): string;
begin
  Result := '<crosses />';

  { TODO : достать аналоги из таблиц также как сервисная }

{упаковать в XML
  <crosses>
    <item>
      <an_code>код аналога1</an_code>
      <an_brand>бренд аналога1</an_brand>
    </item>
    <item>
      <an_code>код аналога2</an_code>
      <an_brand>бренд аналога2</an_brand>
    </item>
    ...
  </crosses>
}
end;

procedure TDM.InitDatabase(const aDatabaseDir: string);
begin
  Database.Directory := aDatabaseDir;
  Database.Connected := True;
end;

end.
