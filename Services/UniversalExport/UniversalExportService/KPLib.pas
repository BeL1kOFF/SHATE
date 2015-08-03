unit KpLib;

{$P-} { turn off open parameters }
{$R-}   { 12/24/98 2.17 }
{$Q-}   { 12/24/98 2.17 }
{$B-}   { turn off complete boolean eval } { 12/24/98  2.17 }

{ $Id: KPLib.pas,v 1.4 1999-01-25 19:13:01-05 kp Exp kp $ }

{ $Log: KPLib.pas,v $
{ Revision 1.4  1999-01-25 19:13:01-05  kp
{ Modifed compiler directives
{ }

{ Sun 10 May 1998   16:58:46  Version: 2.12
{ - Added TempPath property
{ - Fixed RelativePaths bug
{ - Fixed bug related to files in FilesList that don't exist
}
{
{  Mon 27 Apr 1998   18:37:41  Version: 2.11
{ Added ExtractDeviceDrive and GoodTimeStamp
}
{
{ Tue 24 Mar 1998   19:00:23
{ Modifications to allow files and paths to be stored in DOS 
{ 8.3 filename format.  New property is Store83Names.
}
{
{ Wed 11 Mar 1998   21:10:16  Version: 2.03
{ Version 2.03 Files containing many fixes
}

{ Sun 01 Mar 1998   10:25:17 
{ Modified so that D1 would recognize NT.  Modified return 
{ values for W32FindFirstFile to be LongInt instead of 
{ Integer.
}

interface

uses
    {$IFNDEF WIN32}
     WinProcs,
        {$IFNDEF NOLONGNAMES}
   kpLName,
        {$ENDIF}
    {$ELSE}
    Windows,
   {$ENDIF}
  {$IFNDEF NOSTREAMBUFF}
   kpSStrm,
  {$ENDIF}
  SysUtils, FileCtrl, Classes,
  kpMatch;

const
  WILDCARD_RECURSE = '>';
  WILDCARD_NORECURSE = '|';

type
 BYTEPTR = ^Byte;
  PSearchRec = ^TSearchRec;

 {$IFNDEF NOSTREAMBUFF}
 TLFNFileStream = class(TS_BufferStream)
  theFile: TFileStream;
  function GetHandle: Integer;
 {$ELSE}
 TLFNFileStream = class(TFileStream)
 {$ENDIF}
  public
  constructor CreateFile( const FileName: string; Mode: Word);
  destructor  Destroy; override;
  {$IFNDEF NOSTREAMBUFF}
  property Handle: Integer read GetHandle;
  {$ENDIF}
 end;

  TConversionOperation = (SHORTEN, LENGTHEN);

  TSearchData = class(TObject)
   public
     Directory:     String;
     Pattern:       String;
     SearchResult:  Integer;
     SearchRec:     TSearchRec;
     NoFiles:       Boolean;
     procedure      Next;
     constructor    Create( Path, MatchPattern: String );
     destructor     Destroy; override;
  end;

 TDirSearch = class
   private
     FDirStack:     array [0..20] of TSearchData;
     FCurrentLevel: Integer;
     FPattern:      String;
     FRecurse:      Boolean;
     FWildDirStack: TStrings;
     FNumWildDirs:  Integer;
     FWildDirID:    Integer;

     function IsChildDir( SR: TSearchRec ): Boolean;
     function IsDir( SR: TSearchRec ): Boolean;
   public
     constructor Create( const StartingDir, Pattern: String; RecurseDirs: Boolean );
     destructor  Destroy; override;
     function NextFile( var SR: TSearchRec ): String;
    Property Recurse: Boolean read FRecurse write FRecurse default False;
  end;

{$IFNDEF ISBCB}
function min( a,b: LongInt ): LongInt;
function max(a,b: LongInt): LongInt;
{$ENDIF}

function CRate( uc, c: LongInt ): LongInt;
function CBigRate( uc, c: Comp ): LongInt;
function BlockCompare(const Buf1, Buf2; Count: Integer): Boolean;
function DOSToUnixFilename( fn: PChar ): PChar;
function UnixToDOSFilename( fn: PChar ): PChar;
function RightStr( str: String; count: Integer ): String;
function LeftStr( str: String; count: Integer ): String;
function IsWildCard( fname: String ): Boolean;
function FileDate( fname: String ): TDateTime;
function GoodTimeStamp( theTimeStamp: LongInt ): LongInt;

procedure ForceDirs(Dir: string);
function DirExists(Dir: string): Boolean;
function File_Exists(const FileName: string): Boolean;
procedure GetDirectory(D: Byte; var S: String);
procedure ChDirectory(const S: string);
procedure FileCopy(const FromFile, ToFile: string);
function PCharToStr( CStr: PChar ): String;
function StrToPChar( Str: String ): PChar;

function GetVolumeLabel( Disk: String ): String;
function SetVolLabel( Disk, NewLabel: String ): LongBool;

function TempFileName( Pathname: String): String;
procedure OemFilter( var fname: String );

{$IFNDEF Ver100}
procedure Assert( Value: Boolean; Msg: String );
{$ENDIF}

{$IFDEF WIN32}
function StringAsPChar( var S: String): PChar;
{$ELSE}
procedure SetLength(var S: string; NewLength: Integer);
procedure ZeroMemory( p: Pointer; count: LongInt );
procedure MoveMemory( dest,source: Pointer; count: Integer );
function GetEnvVar(EnvVar: String): String;
function GetTempPath( BufferSize: Integer; PathBuffer: PChar ): LongInt;
function StringAsPChar( var S: OpenString): PChar;
function ExtractFileDir(FName: String): String;
function ExtractFileDrive(FName: String): String;  { 3/29/98 2.1 }

{$IFNDEF NOLONGNAMES}
function LFN_CreateFile(FName: String ): LongBool;
function LFN_FileExists(LName: String): Boolean;
function LFN_GetShortFileName(LName: String): String;
{$ENDIF}
function LFN_Shorten( LName: String ): String;
function LFN_WIN31LongPathToShort(LName: String): String;
{$ENDIF}
{$IFNDEF NOLONGNAMES}
function LFN_ConvertLFName(LName: String; ConvertOperation: TConversionOperation): String;
{$ENDIF}

{$IFNDEF WIN32} { 4/22/98 2.11 }
var
 OSVersion:  LongInt;
  IsNT:       Boolean;
{$ENDIF}

implementation

uses
  Dialogs
 {$IFNDEF WIN32}
  {$IFNDEF NODISKUTILS}
 ,kpDrvs, kpDUtil
  {$ENDIF}
 {$ENDIF};

{$IFNDEF WIN32}
var
 DOSChars: array [0..77] of char;
{$ENDIF}
const
{$IFNDEF WIN32}
 FNameChars: set of Char =
 ['A'..'Z','a'..'z','0'..'9','_','^','$','~','!','#','%','&','-','{','}','@','`','''',')','('];
{$ENDIF}
  WildCardChars: set of Char =
  ['*','?',MATCH_CHAR_RANGE_OPEN,WILDCARD_RECURSE,WILDCARD_NORECURSE];       { Removed ] added > and <  7/24/98 }

constructor TLFNFileStream.CreateFile( const FileName: string; Mode: Word);
var
 FName: String;
begin
  FName := FileName;
 {$IFNDEF WIN32}
     {$IFNDEF NOLONGNAMES}
  If OSVersion > 3 then
   begin
   If (Mode = fmCreate) then
    LFN_CreateFile( FName );
   FName := LFN_ConvertLFName( FName, SHORTEN );
   end
  Else
     {$ENDIF}
   FName := LFN_WIN31LongPathToShort(FName);
 {$ENDIF}
 {$IFNDEF NOSTREAMBUFF}
  theFile := TFileStream.Create(Fname,Mode);
  inherited Create(theFile);
 {$ELSE}
  inherited Create(FName,Mode);
 {$ENDIF}
end;

destructor TLFNFileStream.Destroy;
begin
 inherited Destroy;
 {$IFNDEF NOSTREAMBUFF}
 theFile.Free;  { Must Free after calling inherited Destroy so that }
 {$ENDIF}       { buffers can be flushed out by Destroy }
 end;

{$IFNDEF NOSTREAMBUFF}
function TLFNFileStream.GetHandle: Integer;
begin
 Result := theFile.Handle;
end;
{$ENDIF}

constructor TSearchData.Create( Path, MatchPattern: String );
begin
  NoFiles := False;
  Directory := Path;
  If RightStr( Directory, 1 ) <> '\' then
        Directory := Directory + '\';
  Pattern := MatchPattern;
  SearchResult := FindFirst( Directory + '*.*', faAnyFile, SearchRec );
  If SearchResult <> 0 then  {This should never happen though since we always use *.*}
     NoFiles := True;  {to avoid hanging on NT systems with empty directories}
end;

destructor TSearchData.Destroy;
begin
  If not NoFiles then
     FindClose(SearchRec); {don't call if FindFirst didn't find any files}
  inherited Destroy;
end;

procedure TSearchData.Next;
begin
  If (SearchResult = 0) then
     SearchResult := Findnext(SearchRec);
end;

constructor TDirSearch.Create( const StartingDir, Pattern: String; RecurseDirs: Boolean );

procedure ParseWildDir(var wilddir: String);
var
  i,j:          Integer;
  Remaining:    String;
begin
  i := 1;
  While (i <= Length(wilddir)) and not(wilddir[i] in WildCardChars) do
     Inc(i);
  j := i;
  While (wilddir[j] <> '\') do
     Dec(j);
  Remaining := RightStr(wilddir,Length(wilddir)-j);
  wilddir := LeftStr(wilddir,j);
  i := 1;
  j := 0;
  While (i <= Length(Remaining)) do
   begin
     If (Remaining[i] = '\') then
      begin
        FWildDirStack.Add(LeftStr(Remaining,i-1));
        Remaining := RightStr(Remaining,Length(Remaining)-i);
        i := 1;
        Inc(j);
      end
     Else
        Inc(i);
   end;
   FNumWildDirs := j;
end;

var
  StartDir: String;
  thisPattern: String;
begin
  inherited Create;
  StartDir := StartingDir;
  If RightStr( StartDir, 1 ) <> '\' then
        StartDir := StartDir + '\';
  If IsWildCard(StartDir) then
   begin
     FWildDirStack := TStringList.Create;
     ParseWildDir(StartDir);
     FWildDirID := 0;
   end
  Else
   begin
     FWildDirID := -1;
     FNumWildDirs := 0;
     FWildDirStack := nil;
   end;
  FCurrentLevel := 0;
  FPattern := Pattern;
  If FNumWildDirs > 0 then
     thisPattern := FWildDirStack[0]
  Else
     thisPattern := FPattern;
  FDirStack[FCurrentLevel] := TSearchData.Create( StartDir, thisPattern );
  FRecurse := RecurseDirs;
end;

destructor TDirSearch.Destroy;
begin
  FWildDirStack.Free;
end;

function TDirSearch.IsChildDir( SR: TSearchRec ): Boolean;
begin
  Result := (SR.Attr and faDirectory > 0) and (SR.Name[1] <> '.');
end;

function TDirSearch.IsDir( SR: TSearchRec ): Boolean;
begin
  Result := (SR.Attr and faDirectory > 0);
end;

function TDirSearch.NextFile( var SR: TSearchRec ): String;
var
  FullDir: String;
  SData:   TSearchData;
begin
  SData := FDirStack[FCurrentLevel];
  With SData do
   begin
     {GetDirectory(0, SaveDir);}
     {ChDirectory( SData.Directory );}
     While True do
      begin
        If SData.SearchResult <> 0 then
         begin
           SData.Free;
           FDirStack[FCurrentLevel] := nil;
           If FCurrentLevel = 0 then
            begin
              Result := '';  {Thats it folks!}
              break;
            end;
           Dec(FCurrentLevel); { Pop back up a level }
           SData := FDirStack[FCurrentLevel];
           {ChDirectory( SData.Directory );}
           {GetDirectory( 0, dbgFullDir );}
           If (FCurrentLevel < FNumWildDirs) then
              Dec(FWildDirID);
           SData.Next;
         end;
        { Added wildcards-in-paths feature 7/22/98  2.14 }
        If (FCurrentLevel < FNumWildDirs) then
         begin
           While ( (SData.SearchResult = 0) and ((not IsChildDir(SData.SearchRec)) or
                    (not IsMatch( FWildDirStack[FWildDirID],SData.SearchRec.Name )) ) ) do
              SData.Next;
           If (SData.SearchResult = 0) then
            begin
              Inc(FCurrentLevel);
              {ChDirectory( SData.SearchRec.Name );}
              {GetDirectory( 0, FullDir );}   { Get full directory name }
              FullDir := SData.Directory+SearchRec.Name;
              Inc(FWildDirID);
              If (FCurrentLevel < FNumWildDirs) then
                 FDirStack[FCurrentLevel] := TSearchData.Create( FullDir, FWildDirStack[FWildDirID] )
              Else
                 FDirStack[FCurrentLevel] := TSearchData.Create( FullDir, FPattern );
              SData := FDirStack[FCurrentLevel];
              SData.Next;
            end;
            Continue;
         end;
        While ( (SData.SearchResult = 0) and (IsDir(SData.SearchRec) and (not FRecurse)) ) do
           SData.Next;
        If (SData.SearchResult = 0) and (IsChildDir(SData.SearchRec)) and (FRecurse) then
         begin
           Inc(FCurrentLevel);
           {ChDirectory( SData.SearchRec.Name );}
           {GetDirectory( 0, FullDir );}   { Get full directory name }
           FullDir := SData.Directory+SearchRec.Name;
           FDirStack[FCurrentLevel] := TSearchData.Create( FullDir, FPattern );
           SData := FDirStack[FCurrentLevel];
         end
        Else
           If (SData.SearchResult = 0) and (not IsDir(SData.SearchRec)) then
            begin
              If ExtractFileExt(SData.SearchRec.Name) = '' then { this gets files with }
              SData.SearchRec.Name := SData.SearchRec.Name + '.';  { no extention         }
              If IsMatch( FPattern, SData.SearchRec.Name ) then
               begin
                 If SData.SearchRec.Name[Length(SData.SearchRec.Name)] = '.' then
                 SetLength(SData.SearchRec.Name, Length(SData.SearchRec.Name)-1);
                 SR := SData.SearchRec;
                 Result := SData.Directory + SData.SearchRec.Name;
                 SData.Next;
                 Break;
               end
              Else
                 SData.Next;
            end
           Else
              SData.Next;
      end;
     {ChDirectory( SaveDir );}
   end;
end;

{$IFNDEF ISBCB}
function min( a,b: LongInt ): LongInt;
begin
 If a < b then
   Result := a
  Else
   Result := b;
end;

function max(a,b: LongInt): LongInt;
begin
 If a > b then
   Result := a
  Else
   Result := b;
end;
{$ENDIF}

function CRate( uc, c: LongInt ): LongInt;
var
  R,S: Extended;
begin
  If uc > 0 then
   begin
     S := c;
     S := S * 100;
     R := S/uc;
   end
  else
     R := 0;
  Result := min(Round(R),100);
end;

function CBigRate( uc, c: Comp ): LongInt;
var
  R: Comp;
begin
  Assert( c <= uc, 'Total Done more than total' );
  If uc > 0 then
   begin
     R := (c * 100)/uc;
   end
  else
     R := 0;
  Result := min(Round(R),100);
end;

function DOSToUnixFilename( fn: PChar ): PChar;
var
  slash: PChar;
begin
   slash := StrScan( fn, '\' );
   While (slash <> nil) do
   begin
     slash[0] := '/';
     slash :=StrScan( fn, '\' );
   end;
   Result := fn;
end;

function UnixToDOSFilename( fn: PChar ): PChar;
var
 slash: PChar;
begin
  slash := StrScan( fn, '/' );
  While (slash <> nil) do
  begin
  slash[0] := '\';
  slash :=StrScan( fn, '/' );
  end;
  Result := fn;
end;

function RightStr( str: String; count: Integer ): String;
begin
  Result := Copy( str, max(1,Length(str)-(count-1)), count );
end;

function LeftStr( str: String; count: Integer ): String;
begin
  Result := Copy( str, 1, count );
end;

function IsWildCard( fname: String ): Boolean;
var
  i: Integer;
begin
  i := 1;
  While (i <= Length(fname)) and not(fname[i] in WildCardChars) do
     Inc(i);
  If i > Length(fname) then
     Result := False
  else
     Result := True;
end;

{ Added 4/21/98  2.11  to avoid date/time conversion exceptions }
function GoodTimeStamp( theTimeStamp: LongInt ): LongInt;
var
  Hour, Min, Sec: WORD;
  Year, Month, Day: WORD;
  Modified: Boolean;
begin
  Hour := LongRec(theTimeStamp).Lo shr 11;
  Min  := LongRec(theTimeStamp).Lo shr 5 and 63;
  Sec  := LongRec(theTimeStamp).Lo and 31 shl 1;

  Year  := LongRec(theTimeStamp).Hi shr 9 + 1980;
  Month := LongRec(theTimeStamp).Hi shr 5 and 15;
  Day   := LongRec(theTimeStamp).Hi and 31;

  Modified := False;
  If Hour > 24 then
   begin
     Modified := True;
     Hour := 24;
   end;
  If Min > 59 then
   begin
     Modified := True;
     Min := 59;
   end;
  If Sec > 59 then
   begin
     Modified := True;
     Sec := 59;
   end;
  If Year < 1980 then
   begin
     Modified := True;
     Year := 1980;
   end;
  If Year > 2099 then
   begin
     Modified := True;
     Year := 2099;
   end;
  If Month > 12 then
   begin
     Modified := True;
     Month := 12;
   end;
  If Month < 1 then
   begin
     Modified := True;
     Month := 1;
   end;
  If Day > 31 then
   begin
     Modified := True;
     Day := 31;
   end;
  If Day < 1 then
   begin
     Modified := True;
     Day := 1;
   end;

  If Modified then
   begin
     LongRec(theTimeStamp).Hi := Day or (Month shl 5) or ((Year - 1980) shl 9);
     LongRec(theTimeStamp).Lo := (Sec shr 1) or (Min shl 5) or (Hour shl 11);
   end;

  Result := theTimeStamp;
end;

function FileDate( fname: String ): TDateTime;
{
var
  f: Integer;
}
begin
  { Converted to using FileAge 3/29/98 2.1 }
  try
     Result := FileDateToDateTime(GoodTimeStamp(FileAge( fname )));
  except
     Result := Now;
  end;
{$IFDEF SKIPCODE}
  f := FileOpen( fname, fmOpenRead );
  Result := FileDateToDateTime(FileGetDate( f ));
  FileClose(f);
{$ENDIF}
end;

procedure ForceDirs(Dir: string);
begin
 {$IFDEF WIN32}
 ForceDirectories(Dir);
 {$ELSE}
  {$IFNDEF NOLONGNAMES}
 If OSVersion > 3 then
  begin
  if Dir[Length(Dir)] = '\' then
   SetLength(Dir, Length(Dir)-1);
  if (Length(Dir) < 3) or DirectoryExists(Dir) then Exit;
  ForceDirs(ExtractFilePath(Dir));
  W32CreateDirectory(StringAsPChar(Dir),nil,id_W32CreateDirectory);
  end
 Else
  {$ENDIF}
  begin
  Dir := LFN_WIN31LongPathToShort( Dir );
  ForceDirectories(Dir);
  end;
 {$ENDIF}
end;

function File_Exists(const FileName: string): Boolean;
begin
 {$IFDEF WIN32}
 Result := FileExists(Filename);
 {$ELSE}
   {$IFNDEF NOLONGNAMES}
  If OSVersion > 3 then
  Result := LFN_FileExists(Filename)
  Else
   {$ENDIF}
  Result := FileExists(LFN_WIN31LongPathToShort(Filename));
 {$ENDIF}
end;

function DirExists(Dir: string): Boolean;
begin
 {$IFDEF WIN32}
 Result := DirectoryExists(Dir);
 {$ELSE}
  {$IFNDEF NOLONGNAMES}
 If OSVersion > 3 then
  Result := LFN_FileExists(Dir)
 Else
  {$ENDIF}
  begin
  Dir := LFN_WIN31LongPathToShort( Dir );
  Result := DirectoryExists(Dir);
  end;
  {$ENDIF}
end;

procedure GetDirectory(D: Byte; var S: String);
{$IFNDEF WIN32}
var
 Drive: array[0..3] of Char;
 DirBuf, SaveBuf: array[0..259] of Char;
{$ENDIF}
begin
 {$IFDEF WIN32}
 GetDir(D,S);
 {$ELSE}
  {$IFNDEF NOLONGNAMES}
 If OSVersion > 3 then
  begin
  if D <> 0 then
   begin
        Drive[0] := Chr(D + Ord('A') - 1);
        Drive[1] := ':';
        Drive[2] := #0;
   W32GetCurrentDirectory(SizeOf(SaveBuf), SaveBuf, id_W32GetCurrentDirectory);
   W32SetCurrentDirectory(Drive, id_W32SetCurrentDirectory);
  end;
   W32GetCurrentDirectory(SizeOf(DirBuf), DirBuf, id_W32GetCurrentDirectory);
   if D <> 0 then W32SetCurrentDirectory(SaveBuf, id_W32SetCurrentDirectory);
   S := StrPas(PChar(@DirBuf));
  end
 Else
  {$ENDIF}
  GetDir(D,S);  {We should never be Getting a long Dirname in Win31}
 {$ENDIF}
end;

procedure ChDirectory(const S: string);
{$IFNDEF WIN32}
var
 Dir: String;
{$ENDIF}
begin
 {$IFDEF WIN32}
 ChDir(S);
 {$ELSE}
  {$IFNDEF NOLONGNAMES}
  {Added Check for NT 3/1/98 for version 2.03}
 If (OSVersion > 3)  and (not IsNT) then
  begin
  Dir := S;
  W32SetCurrentDirectory(StringAsPChar(Dir),id_W32SetCurrentDirectory)
  end
 Else If IsNT then
   begin
     {Dir := LFN_WIN31LongPathToShort(S);}
     Dir := LFN_ConvertLFName(S,SHORTEN);
     ChDir(Dir);
   end
  Else
  {$ENDIF}
   begin
     Dir := s;
     if (length(Dir)>3)and(Dir[length(Dir)]='\') then
        Delete(Dir,length(Dir),1);
  ChDir(Dir);
   end;
 {$ENDIF}
end;

{$IFDEF SKIP_CODE}
procedure FileCopy(const FromFile, ToFile: string);
 var
  FromF, ToF: file;
  NumRead, NumWritten: Integer;
  Buf: array[1..2048] of Char;
begin
  AssignFile(FromF, FromFile);
  Reset(FromF, 1);  { Record size = 1 }
  AssignFile(ToF, ToFile); { Open output file }
  Rewrite(ToF, 1);  { Record size = 1 }
  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
 CloseFile(FromF);
 CloseFile(ToF);
end;
{$ENDIF}

procedure FileCopy(const FromFile, ToFile: string);
 var
  S, T: TFileStream;
  msg: String;
begin
   S := TFileStream.Create(FromFile, fmOpenRead);
   try
      T := TFileStream.Create(ToFile, fmOpenWrite or fmCreate);
      try
         if T.CopyFrom(S, 0 ) = 0 then
          begin
            msg := 'Could not copy from ' + FromFile + ' to ' + ToFile;
            MessageDlg('msg',mtError,[mbOK],0);
          end;
      finally
      T.Free;
      end;
   finally
   S.Free;
   end;
end;

function PCharToStr( CStr: PChar ): String;
begin
  {$IFDEF WIN32}
  SetLength( Result, StrLen(CStr) );
  Move( CStr^, Result[1], Length(Result));
  {$ELSE}
  Result := StrPas( CStr );
  {$ENDIF}
end;

function StrToPChar( Str: String ): PChar;
begin
   Result := StrAlloc(Length(Str)+1);
  {$IFDEF WIN32}
   StrCopy( Result, PChar(Str));
  {$ELSE}
   StrPCopy( Result, Str );
  {$ENDIF}
end;

function SetVolLabel( Disk, NewLabel: String ): LongBool;
{$IFNDEF WIN32}
var
 DiskLabel: Str11;
 Drive: Char;
{$ENDIF}
begin
{$IFNDEF NODISKUTILS}
 {$IFDEF WIN32}
 Result := SetVolumeLabel( StringAsPChar(Disk), StringAsPChar(NewLabel) );
 {$ELSE}
  Drive := Chr(Ord(Disk[1])); { removed -64 on 3/9/98 2.03 }
  DiskLabel := NewLabel;
  SetDiskLabel( DiskLabel, Drive );
  Result := LongBool(True);
 {$ENDIF}
{$ELSE}
 Result := False;
{$ENDIF}
end;

function GetVolumeLabel( Disk: String ): String;
{$IFNDEF NODISKUTILS}
{$IFNDEF WIN32}
procedure PadVolumeLabel(var Name: Str11);
{ procedure pads Volume Label string with spaces }
var
  i: integer;
begin
  for i := Length(Name) + 1 to 11 do
    Name := Name + ' ';
end;
{$ENDIF}
var
  Dummy2,Dummy3: DWORD;
 {$IFNDEF WIN32}
  SR: TSearchRec;
  DriveLetter: Char;
  SearchString: String[7];
  tmpResult: Str11;
  P: Byte;
  Dummy1: DWORD;
  Dummy4: String;
  DiskLabel: Str11;
 {$ELSE}
  DiskLabel: array [0..13] of char;
 {$ENDIF}
{$ENDIF}
begin
{$IFNDEF NODISKUTILS}
 {$IFDEF WIN32}
 GetVolumeInformation( StringAsPChar(Disk),DiskLabel,SizeOf(DiskLabel),
          nil,Dummy2,Dummy3,nil,0);
 Result := StrPas(DiskLabel);
 {$ELSE}
 If OSVersion = 3 then
  begin
  { Replaced old call because INT call wasn't working correctly.  11/4/98  2.17 }
  SearchString := Disk[1] + ':\*.*';
  { find vol label }
  if FindFirst(SearchString, faVolumeID, SR) = 0 then begin
    P := Pos('.', SR.Name);
    if P > 0 then begin                      { if it has a dot... }
      tmpResult := '           ';               { pad spaces between name }
      Move(SR.Name[1], tmpResult[1], P - 1);    { and extension }
      Move(SR.Name[P + 1], tmpResult[9], 3);
    end
    else begin
      tmpResult := SR.Name;                     { otherwise, pad to end }
      PadVolumeLabel(tmpResult);
    end;
  end
  else
    tmpResult := '';

  Result := tmpResult;
  {DiskNum := Ord(Disk[1])-64;}
  {GetMediaID( DiskNum, info );}
  {Result := info.volName;}
  end
 Else
  begin
  GetVolumeInformation( Disk,DiskLabel,Dummy1,Dummy2,Dummy3,Dummy4);
  Result := DiskLabel;
  end;
 {$ENDIF}
{$ELSE}
 Result := '';
{$ENDIF}
end;

{ Added 5/5/98  2.12 }
function TempFileName(Pathname: String): String;
var
  TmpFileName: array[0..255] of Char;
begin
  {$IFNDEF WIN32}
  GetTempFileName('C', 'KPZ', 0, TmpFileName);
  If Pathname[Length(Pathname)] = '\' then
     Result := Pathname + ExtractFilename(PCharToStr(TmpFileName))
  Else
     Result := Pathname + '\' + ExtractFilename(PCharToStr(TmpFileName))
  {$ELSE}
  GetTempFileName(StringAsPChar(Pathname), 'KPZ', 0, TmpFileName);
  Result := PCharToStr(TmpFileName);
  {$ENDIF}
end;

procedure OemFilter( var fname: String );
begin
  {$IFDEF WIN32}
  CharToOem(@fname[1], @fname[1]);
  {$ELSE}
  AnsiToOem( StringAsPChar(fname),StringAsPChar(fname) );
  {$ENDIF}
  {$IFDEF WIN32}
  OemToChar(@fname[1], @fname[1]);
  {$ELSE}
  OemToAnsi( StringAsPChar(fname),StringAsPChar(fname) );
  {$ENDIF}
end;

{$IFNDEF Ver100}
{ A very simple assert routine for D1 and D2 }
procedure Assert( Value: Boolean; Msg: String );
begin
  {$IFDEF ASSERTS}
  If not Value then
     ShowMessage(Msg);
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF WIN32}
function BlockCompare(const Buf1, Buf2; Count: Integer): Boolean;
type
 BufArray = array[0..MaxInt - 1] of Char;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
    if BufArray(Buf1)[I] <> BufArray(Buf2)[I] then Exit;
  Result := True;
end;

function StringAsPChar( var S: String): PChar;
begin
  Result := PChar(S);
end;

{$ELSE}  { These functions are defined for 16 bit }
function BlockCompare(const Buf1, Buf2; Count: Integer): Boolean; assembler;
asm
        PUSH    DS
        LDS     SI,Buf1
        LES     DI,Buf2
        MOV     CX,Count
        XOR     AX,AX
        CLD
        REPE    CMPSB
        JNE     @@1
        INC     AX
@@1:    POP     DS
end;

procedure SetLength(var S: string; NewLength: Integer);
begin
 S[0] := Char(LoByte(NewLength));
end;

procedure ZeroMemory( p: Pointer; count: LongInt );
var
 b: BYTEPTR;
 i: LongInt;
begin
 b := BYTEPTR(p);
 for i := 0 to count-1 do
  begin
  b^ := 0;
  Inc(b);
  end;
end;

procedure MoveMemory( dest,source: Pointer; count: Integer );
var
 d,s: BYTEPTR;
  i: Integer;
begin
 d := BYTEPTR(dest);
 s := BYTEPTR(source);
 for i := 0 to count-1 do
  begin
  d^ := s^;
  Inc(d);
  Inc(s);
  end;
end;

function StringAsPChar( var S: OpenString): PChar;
begin
  If Length(S) = High(S) then
     Dec(S[0]);
  S[Ord(Length(S))+1] := #0;
  Result := @S[1];
end;

function GetEnvVar(EnvVar: String): String;
var
  P: PChar;
begin
  Result := '';
  P := GetDOSEnvironment;
  If Length(EnvVar) > 253 then
     SetLength(EnvVar, 253);
  EnvVar := EnvVar + '=';
 StringAsPChar(EnvVar);
  While P^ <> #0 do
  If StrLIComp(P, @EnvVar[1], Length(EnvVar)) <> 0 then
        Inc(P, StrLen(P)+1)
     Else
      begin
        Inc(P, Length(EnvVar));
        Result := StrPas(P);
        break;
      end;
end;

function GetTempPath( BufferSize: Integer; PathBuffer: PChar ): LongInt;
var
  thePath: String;
begin
  thePath := GetEnvVar( 'TMP' );
  If thePath = '' then
     thePath := GetEnvVar( 'TEMP' );
 If thePath = '' then
  GetDir(0,thePath);
 If thePath[Length(thePath)] <> '\' then
   thePath := thePath + '\';
 StrPCopy( PathBuffer, thePath );
  Result := Length( thePath );
end;

{ Added this function 3/29/98 2.1 }
function ExtractFileDir(FName: String): String;
{ExtractFileDir does not include the rightmost '\'}
begin
 Result := ExtractFilePath(FName);
 If (Result <> '') and (Result <> '\') and (not (RightStr(Result,2) = ':\'))  then
     SetLength(Result,Length(Result)-1);
end;

function ExtractFileDrive(FName: String): String;
begin
  Result := '';
  If (Length(FName) < 2) or (FName[2] <> ':') then
     exit;
  Result := LeftStr(FName,2);
end;

{$IFNDEF NOLONGNAMES}
function LFN_CreateFile(FName: String): LongBool;
const
 GENERIC_READ             = $80000000;
 GENERIC_WRITE            = $40000000;
 CREATE_NEW       = 1;
 CREATE_ALWAYS      = 2;
 OPEN_EXISTING      = 3;
 OPEN_ALWAYS      = 4;
 TRUNCATE_EXISTING    = 5;
 FILE_ATTRIBUTE_NORMAL    = $00000080;
var
 theHandle: LongInt;
begin
 theHandle := W32CreateFile(StringAsPChar(FName),GENERIC_WRITE,0,nil,CREATE_ALWAYS,
          FILE_ATTRIBUTE_NORMAL,0,id_W32CreateFile);
 Result := W32CloseHandle( theHandle, id_W32CloseHandle );
end;

function LFN_GetShortFileName(LName: String): String;
var
 ffd: WIN32_FIND_DATA;
 r: LongInt;
begin
 r := W32FindFirstFile(StringAsPChar(LName),ffd,id_W32FindFirstFile);
 If (r  <> -1) and (StrPas(ffd.cAlternateFileName) <> '') then
  Result := ExtractFilePath(LName) + StrPas(ffd.cAlternateFileName)
 Else
  Result := LName;
  If (r <> -1) then
     W32FindClose( r, id_W32FindClose );
end;
{$ENDIF}

function hash( S: String; M: LongInt ): LongInt;
var
 i: Integer;
  g: LongInt;
begin
 Result := 0;
 for i := 1 to Length(S) do
  begin
  Result := (Result shl 4) + Byte(S[i]);
  g := Result and $F0000000;
  If (g <> 0) then
   Result := Result xor (g shr 24);
  Result := Result and (not g);
  end;
  Result := Result mod M;
end;

function LFN_Shorten( LName: String ): String;
var
 i: Integer;
 Extent: String;
 HashChar: Char;
begin
 HashChar := #0;
 i := Length(LName);
 While (i > 0) do
  begin
  If LName[i] = '.' then
   break;
  Dec(i);
  end;
 If i > 0 then
  begin
  If Length(LName)-i > 3 then
   HashChar := DOSChars[hash(LName,78)];
  Extent := Copy(LName,i,4);
  If HashChar <> #0 then
   begin
   Extent[4] := HashChar;
   HashChar := #0;
   end;
  If i > 9 then
   HashChar := DOSChars[hash(LName,78)];
  SetLength(LName, min(i-1,8));
  If HashChar <> #0 then
   LName[8] := HashChar;
  end
 Else
  begin
  Extent := '';
  If Length(LName) > 8 then
   HashChar := DOSChars[hash(LName,78)];
  SetLength(LName, min(Length(LName),8));
  end;
 For i := 1 to Length(LName) do
  If not (LName[i] in FNameChars) then
   LName[i] := '_';
 Result := LName + Extent;
end;

function LFN_WIN31LongPathToShort(LName: String): String;
var
 tempShortPath: String;
  tmpStr: String;
 p: PChar;
 count, r, i, j: Integer;
 EndSlash: Boolean;
begin
 count := 0;
 EndSlash := False;
 tempShortPath := '';
 If (LName[2] = ':') and (LName[3] <> '\') then
  Insert('\',LName,3);
 If (LName[Length(LName)] = '\') then
  begin
  EndSlash := True;
  Dec(LName[0]);
  end;
 If (LName[1] = '\') then
  j := 2
 Else
  j := 1;

 For i := j to Length(LName) do
  If LName[i] = '\' then
   begin
   LName[i] := #0;
   Inc(count);
   end;
 LName[Length(LName)+1] := #0;
 p := @LName[j];
 If p[1] = ':' then
  begin
  tempShortPath := StrPas(p) + '\';
  p := StrEnd(p);
  Inc(p);
  Dec(count);
  end;
 For i := 0 to count do
  begin
  tmpStr := StrPas(p);
  tmpStr := LFN_Shorten(tmpStr);
  tempShortPath := tempShortPath + tmpStr + '\';
  p := StrEnd(p);
  Inc(p);
  end;
 If not EndSlash then
  Dec(tempShortPath[0]);
 Result := tempShortPath;
end;

{$IFNDEF NOLONGNAMES}
function LFN_FileExists(LName: String): Boolean;
var
 ffd: WIN32_FIND_DATA;
 r: LongInt;
begin
 If LName[Length(LName)] = '\' then
  Dec(LName[0]);
 r := W32FindFirstFile(StringAsPChar(LName),ffd,id_W32FindFirstFile);
 If r <> -1 then
   begin
  Result := True;
     W32FindClose( r, id_W32FindClose);
   end
 Else
  Result := False;

end;
{$ENDIF}
{$ENDIF}

{$IFNDEF NOLONGNAMES}
function LFN_ConvertLFName(LName: String; ConvertOperation: TConversionOperation): String;
var
 tempOrigPath: array [0..255] of char;
 tempNewPath: String;
 p: PChar;
 count, i, j: Integer;
  r: LongInt;
  {$IFDEF WIN32}
  ffd: TWin32FindData;
  {$ELSE}
 ffd: WIN32_FIND_DATA;
  {$ENDIF}
 EndSlash: Boolean;
  HasDrive: Boolean;  { For UNC's 3/26/98  2.1 }
begin
  HasDrive := False;
 count := 0;
  EndSlash := False;
  tempNewPath := '';
 tempOrigPath[0] := #0;
 If (LName[2] = ':') and (LName[3] <> '\') then
  Insert('\',LName,3);
 If (LName[Length(LName)] = '\') then
  begin
  EndSlash := True;
  SetLength(LName,Length(LName)-1);
  end;
 If (LName[1] = '\') then
  begin
  tempNewPath := '\';
  j := 2
  end
  Else If ExtractFileDrive(LName) <> '' then   { For UNC's 3/26/98  2.1 }
   begin
     j := Length(ExtractFileDrive(LName)) + 1;
     HasDrive := True;
   end
 Else
  j := 1;
 For i := j to Length(LName) do
  If LName[i] = '\' then
   begin
   LName[i] := #0;
   Inc(count);
   end;
 LName[Length(LName)+1] := #0;
  If HasDrive then
     j := 1;  { 4/12/98 2.11 }
 p := @LName[j];
 If HasDrive then
  begin
  StrCopy(tempOrigPath,p);
  StrCat(tempOrigPath,'\');
  tempNewPath := StrPas(p) + '\';
  p := StrEnd(p);
  p^ := '\';
  Inc(p);
  Dec(count);
  end;
 For i := 0 to count do
  begin
  StrCat(tempOrigPath,p);
     {$IFDEF WIN32}
     r := FindFirstFile(tempOrigPath, ffd);
     {$ELSE}
  r := W32FindFirstFile(tempOrigPath,ffd,id_W32FindFirstFile);
     {$ENDIF}
     If ConvertOperation = LENGTHEN then
      begin
     if (r <> -1) then
      tempNewPath := tempNewPath +  StrPas(ffd.cFileName) + '\'
      end
     Else
      begin
     if (r <> -1) and (StrPas(ffd.cAlternateFileName) <> '') then
      tempNewPath := tempNewPath +  StrPas(ffd.cAlternateFileName) + '\'
     Else
      tempNewPath := tempNewPath + StrPas(p) + '\';
      end;
  StrCat(tempOrigPath,'\');
  p := StrEnd(p);
  p^ := '\';
  Inc(p);
  If (r <> -1) then
        {$IFDEF WIN32}
        Windows.FindClose( r );
        {$ELSE}
        W32FindClose( r, id_W32FindClose);
        {$ENDIF}
  end;
 If not EndSlash then
  SetLength(tempNewPath, Length(tempNewPath)-1);
 Result := tempNewPath;
end;
{$ENDIF}

 {$IFNDEF WIN32}
const
  WF_WINNT = $4000;

var
 c: char;
 i: Integer;
begin
  { Added NT Check 3/1/98 for version 2.03 }
  IsNT := (GetWinFlags and WF_WINNT) <> 0;
  If IsNT then
     OSVersion := 4
  Else
   begin
    OSversion := GetVersion;
    If (Lo(LOWORD(OSversion)) > 3) or
     ((Lo(LOWORD(OSversion)) = 3) and (Hi(LOWORD(OSversion)) = 95)) then
     OSversion := 4   { WIN95 or higher }
    Else
     OSversion := 3;  { WIN31 }
   end;

  {OSVersion := 3;}  { Uncomment these 2 lines to emulate WIN31 on WIN95 or NT }
  {IsNT := False;}   { Useful for testing WIN31 long filename support }
    for c:= Low(Char) to High(Char) Do
   If c In FNameChars Then
    begin
    DOSChars[i] := c;
    Inc(i);
    end;
 {$ENDIF}
end.
