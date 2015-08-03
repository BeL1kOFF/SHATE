unit Logic.InterfaceImpl;

interface

uses
  Logic.InterfaceList;

type
  TDataBase = class(TInterfacedObject, IDataBase)
  private
    FId_DataBase: Integer;
    FServer: string;
    FDataBase: string;
    FId_Template: Integer;
    function GetId_DataBase: Integer;
    function GetServer: string;
    function GetDataBase: string;
    function GetId_Template: Integer;

    procedure SetId_DataBase(aId_DataBase: Integer);
    procedure SetServer(const aServer: string);
    procedure SetDataBase(const aDataBase: string);
    procedure SetId_Template(aId_Template: Integer);
  end;

implementation

{ TDataBase }

function TDataBase.GetDataBase: string;
begin
  Result := FDataBase;
end;

function TDataBase.GetId_DataBase: Integer;
begin
  Result := FId_DataBase;
end;

function TDataBase.GetServer: string;
begin
  Result := FServer;
end;

function TDataBase.GetId_Template: Integer;
begin
  Result := FId_Template;
end;

procedure TDataBase.SetDataBase(const aDataBase: string);
begin
  FDataBase := aDataBase;
end;

procedure TDataBase.SetId_DataBase(aId_DataBase: Integer);
begin
  FId_DataBase := aId_DataBase;
end;

procedure TDataBase.SetServer(const aServer: string);
begin
  FServer := aServer;
end;

procedure TDataBase.SetId_Template(aId_Template: Integer);
begin
  FId_Template := aId_Template;
end;

end.
