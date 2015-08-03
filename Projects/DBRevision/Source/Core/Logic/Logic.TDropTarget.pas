unit Logic.TDropTarget;

interface

uses
  Winapi.ActiveX,
  System.Types;

type
  IDragDrop = interface
    function MSSQLDropAllowed(const aObjName: string; pt: TPoint): Boolean;
    function MSSQLIsAccessObject(const aObjName: string): Boolean;
    procedure MSSQLDrop(const aObjName: string);
  end;

  TDropTarget = class(TInterfacedObject, IDropTarget)
  private
    FHandle: THandle;
    FDragDrop: IDragDrop;
    FDropAllowed: Boolean;
    FIsObj: Boolean;
    FObjName: string;
    function GetObjectName(aDataObj: IDataObject): string;
  private
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
  public
    constructor Create(aHandle: THandle; aDragDrop: IDragDrop);
  end;

implementation

uses
  Winapi.Windows, Vcl.Dialogs;

{ TDropTarget }

constructor TDropTarget.Create(aHandle: THandle; aDragDrop: IDragDrop);
begin
  FHandle := AHandle;
  FDragDrop := aDragDrop;
end;

function TDropTarget.DragEnter(const dataObj: IDataObject; grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
begin
  Result := S_OK;
  try
    FObjName := GetObjectName(dataObj);
    FIsObj := (Length(FObjName) > 0) and FDragDrop.MSSQLIsAccessObject(FObjName);
    if FIsObj then
      dwEffect := DROPEFFECT_COPY
    else
      dwEffect := DROPEFFECT_NONE;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TDropTarget.DragLeave: HResult;
begin
  FObjName := '';
  Result := S_OK;
end;

function TDropTarget.DragOver(grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  Result := S_OK;
  try
    FDropAllowed := FIsObj and (Length(FObjName) > 0) and FDragDrop.MSSQLDropAllowed(FObjName, pt);
    if FDropAllowed then
      dwEffect := DROPEFFECT_COPY
    else
      dwEffect := DROPEFFECT_NONE;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TDropTarget.Drop(const dataObj: IDataObject; grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  ObjName: string;
begin
  Result := S_OK;
  ObjName := GetObjectName(dataObj);
  if Length(ObjName) > 0 then
    FDragDrop.MSSQLDrop(ObjName);
end;

function TDropTarget.GetObjectName(aDataObj: IDataObject): string;
var
  FormatEtc: TFormatEtc;
  StgMedium: TStgMedium;
  pData: PChar;
begin
  FormatEtc.cfFormat := CF_UNICODETEXT;
  FormatEtc.ptd := nil;
  FormatEtc.dwAspect := DVASPECT_CONTENT;
  FormatEtc.lindex := -1;
  FormatEtc.tymed := TYMED_HGLOBAL;
  if Succeeded(aDataObj.GetData(FormatEtc, StgMedium)) then
  begin
    pData := GlobalLock(StgMedium.hGlobal);
    if Assigned(pData) then
    begin
      try
        Result := pData;
      finally
        GlobalUnlock(StgMedium.hGlobal);
      end;
    end;
    ReleaseStgMedium(StgMedium);
  end;
end;

end.
