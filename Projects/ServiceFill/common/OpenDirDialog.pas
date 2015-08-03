unit OpenDirDialog;

interface

uses
  Windows, Messages, ShlObj, SysUtils;

Function OpenDirExecute(var DirName: string; const aCaption: string = ''; aOwnerHWND: Cardinal = 0): boolean;

implementation

var
  InitDir: string;


Function OpenDirExecute(var DirName: string; const aCaption: string = ''; aOwnerHWND: Cardinal = 0): boolean;
var
  bi: TBrowseInfo;
  buf: PChar;
  PIDL, ResPIDL: PItemIDList;


  procedure DirOpenCallBack(wnd: hWnd; uMsg: UINT; lParam, lpData: LParam) stdcall;
  var
    s: string;
    r: TRect;
  begin
    if uMsg = BFFM_INITIALIZED then
    begin
      s:=InitDir;
      GetWindowRect(wnd, r);

      SetWindowPos(wnd, 0, (GetSystemMetrics(SM_CXSCREEN)-(r.Right-r.Left)) div 2,
                           (GetSystemMetrics(SM_CYSCREEN)-(r.Bottom-r.Top)) div 2,
                           0, 0, SWP_NOSIZE);
      SendMessage(wnd, BFFM_SETSELECTION, 1, Integer(PChar(s)));
    end;
    //SendMessage(wnd, BFFM_ENABLEOK, 0, 1);
  end;

begin
  result:=false;
  InitDir:=DirName;
  SHGetSpecialFolderLocation(0, CSIDL_DRIVES, PIDL);
  GetMem(buf, 256); ZeroMemory(buf, sizeof(256));
  bi.hwndOwner := aOwnerHWND;
  bi.pszDisplayName := buf;
  if aCaption = '' then
    bi.lpszTitle := 'Выбор папки'
  else
    bi.lpszTitle := PChar(aCaption);
  bi.pidlRoot := PIDL;
  bi.lpfn := addr(DirOpenCallBack);
  bi.ulFlags:=0;
  ResPidl := SHBrowseForFolder(BI);
  if ResPidl<>nil then
  begin
    SHGetPathFromIDList(ResPidl, buf);
    DirName:=StrPas(buf);
    result:=true;
  end;
  FreeMem(buf, 256);
end;

end.
