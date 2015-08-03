{ ********************************************************************************** }
{                                                                                    }
{   COPYRIGHT 1997 Kevin Boylan                                                    }
{     Source File: VCLZip.pas                                                        }
{     Description: VCLZip component - native Delphi unzip component.                 }
{     Date:        March 1997                                                        }
{     Author:      Kevin Boylan, boylank@bigfoot.com                                 }
{                                                                                    }
{                                                                                    }
{ ********************************************************************************** }
unit VCLZip;
{$IFDEF VER110}
{$ObjExportAll On}     { 4/20/98  2.11}
{$ENDIF}

{$P-} { turn off open parameters }
{$R-}   { 3/10/98 2.03 }
{$Q-}   { 3/10/98 2.03 }
{$B-} { turn off complete boolean eval } { 12/24/98  2.17 }

{ $Id: VCLZip.pas,v 1.6 1999-01-12 20:23:34-05 kp Exp kp $ }

{ $Log: VCLZip.pas,v $
{ Revision 1.6  1999-01-12 20:23:34-05  kp
{ -Slight modifications to the precompiler conditionals
{ -Added the PreserveStubs public property
{ }

{ Sat 04 Jul 1998   16:16:01
{ Added SkipIfArchiveBitNotSet property
{ Added ResetArchiveBitOnZip property
}
{
{  Sun 10 May 1998   16:58:46   Version: 2.12
{ - Added TempPath property
{ - Fixed RelativePaths bug
{ - Fixed bug related to files in FilesList that don't exist
}
{
{ Mon 27 Apr 1998   18:22:44   Version: 2.11
{ Added BCB 3 support
{ Invalid Pointer operation bug fix
{ CalcCRC for D1 bug fix
{ Quit during wildcard expansion bug fix
{ Straightened out some conditional directives
}
{
{  Sun 29 Mar 1998   10:51:35  Version: 2.1
{ Version 2.1 additions
{ 
{ - Capability of 16bit VCLZip to store long filenames/paths 
{ when running on 32 bit OS.
{ - New Store83Names property to force storing short 
{ filenames and paths
{ - Better UNC path support.
{ - Fixed a bug to allow adding files to an empty archive.
}
{
{   Tue 24 Mar 1998   19:00:22
{ Modifications to allow files and paths to be stored in DOS 
{ 8.3 filename format.  New property is Store83Names.
}
{
{   Wed 11 Mar 1998   21:10:16  Version: 2.03
{ Version 2.03 Files containing many fixes
}

interface

uses
{$IFDEF WIN32}
 Windows,
{$ELSE}
 WinTypes, WinProcs, kpSHuge,
{$ENDIF}
  SysUtils, Messages, Classes, Dialogs, Forms, Controls,
 KpLib, VCLUnZip, kpZipObj, kpMatch;

{$IFNDEF WIN32}
  {$DEFINE WIN16}
{$ELSE}
  {$IFOPT C+}
     {$DEFINE ASSERTS}
  {$ENDIF}
{$ENDIF}

type
  usigned = word;
  WPos = WORD;
  IPos = usigned;
  uch = Byte;
  EInvalidMatch = Class( Exception );
  ct_dataPtr = ^ct_data;
  ct_data = packed Record
     fc: Record
           Case Integer of
              0: (freq:   WORD );
              1: (code:   WORD );
         end;
     dl: Record
           Case Integer of
              0: (dad:    WORD );
              1: (len:    WORD );
         end;
  end;
  ct_dataArrayPtr = ^ct_dataArray;
 ct_dataArray = array [0..(MAX_USHORT div SizeOf(ct_data))-1] of ct_data;
  static_ltreePtr = ^static_ltree_type;
  static_dtreePtr = ^static_dtree_type;
  static_ltree_type = array [0..L_CODES+1] of ct_data;
  static_dtree_type = array [0..D_CODES-1] of ct_data;

  windowtypePtr = ^windowtype;
  prevtypePtr = ^prevtype;
  headtypePtr = ^headtype;
  l_buftypePtr = ^l_buftype;
  d_buftypePtr = ^d_buftype;
  flag_buftypePtr = ^flag_buftype;

  {$IFDEF WIN32}
  windowtype = array[0..2*WSIZE-1] of uch;
  prevtype = array[0..WSIZE-1] of WPos;
  headtype =  array[0..HASH_SIZE-1] of WPos;
  l_buftype = array [0..LIT_BUFSIZE-1] of Byte;
  d_buftype = array [0..DIST_BUFSIZE-1] of WORD;
  flag_buftype = array [0..(LIT_BUFSIZE div 8)-1] of Byte;
  {$ELSE}
  windowtype = array[0..0] of Byte;
  prevtype = array[0..0] of Word;
  headtype = array[0..0] of Word;
  l_buftype = array[0..0] of Byte;
  d_buftype = array[0..0] of Word;
  flag_buftype = array[0..0] of Byte;
  {$ENDIF}

  TZipAction = (zaUpdate, zaReplace, zaFreshen);

  TStartZipInfo = procedure( Sender: TObject; NumFiles: Integer; TotalBytes: Comp;
              var EndCentralRecord: TEndCentral; var StopNow: Boolean ) of Object;
  TStartZipEvent = procedure( Sender: TObject; FName: String;
                 var ZipHeader: TZipHeaderInfo; var Skip: Boolean ) of Object;
  TEndZipFileEvent = procedure( Sender: TObject; FName: String; UncompressedSize,
                             CompressedSize, CurrentZipSize: LongInt ) of Object;
  TDisposeEvent = procedure( Sender: TObject; FName: String; var Skip: Boolean ) of Object;
  TDeleteEvent = procedure( Sender: TObject; FName: String ; var Skip: Boolean ) of Object;
  TNoSuchFileEvent = procedure( Sender: TObject; FName: String ) of Object;

 TMultiZipInfo = class(TPersistent)
  private
    FBlockSize: LongInt;
    FFirstBlockSize: LongInt;
    FMultiMode: TMultiMode;
    FCheckDiskLabels: Boolean;
    FWriteDiskLabels: Boolean;

  public
    Constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property BlockSize: LongInt read FBlockSize write FBlockSize default 1457600;
    property FirstBlockSize: LongInt read FFirstBlockSize write FFirstBlockSize default 1457600;
    property MultiMode: TMultiMode read FMultiMode write FMultiMode default mmNone;
    property CheckDiskLabels: Boolean read FCheckDiskLabels write FCheckDiskLabels default True;
    property WriteDiskLabels: Boolean read FWriteDiskLabels write FWriteDiskLabels default True;
 end;

 TVCLZip = class(TVCLUnZip)
  private
     FPackLevel:    Integer;
     FRecurse:      Boolean;
     FDispose:      Boolean;
     FStorePaths:   Boolean;
     FRelativePaths: Boolean;
     FStoreVolumes: Boolean;
     FZipAction:    TZipAction;
     FBlockSize:    LongInt;
     FMultiZipInfo: TMultiZipInfo;
     FStore83Names: Boolean;
     FTempPath:     String;
     FSkipIfArchiveBitNotSet: Boolean; { 7/4/98 2.13 }
     FResetArchiveBitOnZip: Boolean; { Added 4-Jun-98 SPF 2.13 }
     FExcludeList: TStrings;    { 9/27/98  2.15 }
     FNoCompressList: TStrings; { 9/27/98  2.15 }

     FOnStartZipInfo: TStartZipInfo;
     FOnStartZip:   TStartZipEvent;
     FOnDisposeFile: TDisposeEvent;
     FOnEndZip: TEndZipFileEvent;
     FOnDeleteEntry: TDeleteEvent;
     FOnNoSuchFile: TNoSuchFileEvent;

     AmountWritten: LongInt;
     AmountToWrite: LongInt;
     UsingTempFile: Boolean;
     CreatingSFX: Boolean;
     SFXStubFile: TLFNFileStream;
     FPreserveStubs: Boolean;

  protected
    { Protected declarations }
     zfile:         TStream; { output compression file }
     IFile:         TStream; { input file to compress }
     mfile:         TStream; { temporary file during spanned file creation }
     IFileName:     String;
     isize:         LongInt;
     tmpfiles:      TSortedZip;
     tmpfiles2:     TSortedZip;
     tmpecrec:      TEndCentral;
     tmpfile_info:  TZipHeaderInfo;
     tmpZipName:    String;
     mZipName:      String;
     Deleting:      Boolean;
     FileBytes:     LongInt;
     SaveNewName:   String;

  static_ltree:  static_ltree_type;
  static_dtree:  static_dtree_type;
  bl_count:      array [0..MAX_ZBITS] of WORD;
  base_dist:     array [0..D_CODES-1] of Integer;
  length_code:   array [0..MAX_MATCH-MIN_MATCH] of Byte;
  dist_code:     array [0..511] of Byte;
  base_length:   array [0..LENGTH_CODES-1] of Integer;
  TRInitialized: Boolean;
  {$IFDEF WIN16}
  windowObj:     TkpHugeByteArray;
  prevObj:       TkpHugeWordArray;
  headObj:       TkpHugeWordArray;
  l_bufObj:      TkpHugeByteArray;
  d_bufObj:      TkpHugeWordArray;
  flag_bufObj:   TkpHugeByteArray;
  {$ENDIF}
  window:        windowtypePtr;
  prev:          prevtypePtr;
  head:          headtypePtr;
  l_buf:         l_buftypePtr;
  d_buf:         d_buftypePtr;
  flag_buf:      flag_buftypePtr;

    function zfwrite(buf: BytePtr; item_size, nb: Integer): LongInt;
    function zencode(c: Byte): Byte;
    function file_read( w: BytePtr; size: usigned ): LongInt;
    procedure CreateTempZip;
    function Deflate: LongInt;
    function ProcessFiles: Integer;
    function AddFileToZip( FName: String ): Boolean;
    {procedure MoveExistingFiles;}
    procedure MoveFile( Index: Integer );
    procedure MoveTempFile;
    procedure StaticInit;
    procedure CryptHead( passwrd: String );

    procedure SetZipName( ZName: String ); override;
    function GetIsModified: Boolean;
    procedure SetMultiZipInfo(Value: TMultiZipInfo);
    function GetCheckDiskLabels: Boolean; override;
    procedure SetStoreVolumes( Value: Boolean );
    function GetMultiMode: TMultiMode; override;
    procedure SetCheckDiskLabels( Value: Boolean ); override;
    procedure SetMultiMode( Value: TMultiMode ); override;
    procedure ResetArchiveBit(AFileName: string); { Added 4-Jun-98 SPF 2.13? }
    function DiskRoom: LongInt;
    function RoomLeft: LongInt;
    procedure NextPart;
    procedure LabelDisk;

    procedure SetPathname(Index: Integer; Value: TZipPathname);
    procedure SetFilename(Index: Integer; Value: String);
    procedure SetStorePaths(Value: Boolean);
    procedure SetRelativePaths(Value: Boolean);

    function  TemporaryPath: String;
    procedure SetExcludeList(Value: TStrings);             { 9/27/98  2.15 }
    procedure SetNoCompressList(Value: TStrings);          { 9/27/98  2.15 }
    function IsInExcludeList( N: String ): Boolean;        { 9/27/98  2.15 }
    function IsInNoCompressList( N: String ): Boolean;     { 9/27/98  2.15 }

    procedure Loaded; override;

  public
    { Public declarations }
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function Zip: Integer;
    function DeleteEntries: Integer;
    procedure SaveModifiedZipFile;
    function ZipFromStream( theStream: TStream; FName: String ): Integer;
    function FixZip( InputFile, OutputFile: String): Integer;
    procedure MakeSFX( SFXStub: String; ModHeaders: Boolean );
    function ZipFromBuffer( Buffer: PChar; Amount: Longint; FName: String ): Integer;
    
    property FileComment[Index: Integer]: String read GetFileComment write SetFileComment;
    property ZipComment: String read GetZipComment write SetZipComment;
    property IsModified: Boolean read GetIsModified;
    property CheckDiskLabels: Boolean read GetCheckDiskLabels write SetCheckDiskLabels;
    property MultiMode: TMultiMode read GetMultiMode write SetMultiMode;

    property Pathname[Index: Integer]: TZipPathname read GetPathname write SetPathname;
    property Filename[Index: Integer]: String read GetFilename write SetFilename;
    property PreserveStubs: Boolean read FPreserveStubs write FPreserveStubs default False;

  published
    { Published declarations }
    property PackLevel: Integer read FPackLevel write FPackLevel default 6;
    property Recurse: Boolean read FRecurse write FRecurse default False;
    property Dispose: Boolean read FDispose write FDispose default False;
    property StorePaths: Boolean read FStorePaths write SetStorePaths default False;
    property RelativePaths: Boolean read FRelativePaths write SetRelativePaths default False;
    property StoreVolumes: Boolean read FStoreVolumes write SetStoreVolumes default False;
    property ZipAction: TZipAction read FZipAction write FZipAction default zaUpdate;
    property MultiZipInfo: TMultiZipInfo read FMultiZipInfo write SetMultiZipInfo;
    property Store83Names: Boolean read FStore83Names write FStore83Names default False;
    property TempPath: String read FTempPath write FTempPath;  { 5/5/98  2.12 }
    property SkipIfArchiveBitNotSet: Boolean read FSkipIfArchiveBitNotSet
              write FSkipIfArchiveBitNotSet default False; { 7/4/98  2.13 }
    property ResetArchiveBitOnZip: Boolean read FResetArchiveBitOnZip
              write FResetArchiveBitOnZip default False; { Added 4-Jun-98 SPF 2.13? }
    property ExcludeList: TStrings read FExcludeList write SetExcludeList;  { 9/27/98  2.15 }
    property NoCompressList: TStrings read FNoCompressList write SetNoCompressList;  { 9/27/98  2.15 }

    { Event Properties }
    property OnStartZip: TStartZipEvent read FOnStartZip write FOnStartZip;
    property OnStartZipInfo: TStartZipInfo read FOnStartZipInfo write FOnStartZipInfo;
    property OnEndZip: TEndZipFileEvent read FOnEndZip write FOnEndZip;
    property OnDisposeFile: TDisposeEvent read FOnDisposeFile write FOnDisposeFile;
    property OnDeleteEntry: TDeleteEvent read FOnDeleteEntry write FOnDeleteEntry;
    property OnNoSuchFile: TNoSuchFileEvent read FOnNoSuchFile write FOnNoSuchFile;
  end;

  procedure Register;

implementation

{$I kpDFLT.PAS}

constructor TMultiZipInfo.Create;
begin
  Inherited Create;
  MultiMode := mmNone;
  FBlockSize := 1457600;
  FFirstBlockSize := 1457600;
  CheckDiskLabels := True;
  FWriteDiskLabels := True;
end;

procedure TMultiZipInfo.Assign(Source: TPersistent);
var
  Src: TMultiZipInfo;
begin
  If Source is TMultiZipInfo then
   begin
     Src := TMultiZipInfo(Source);
     FMultiMode := Src.MultiMode;
     FBlockSize := Src.BlockSize;
     FFirstBlockSize := Src.FirstBlockSize;
     FCheckDiskLabels := Src.CheckDiskLabels;
     FWriteDiskLabels := Src.WriteDiskLabels;
   end
 else inherited Assign(Source);
end;

constructor TVCLZip.Create( AOwner: TComponent );
begin
  inherited Create(AOwner);
  FMultiZipInfo := TMultiZipInfo.Create;
  FPackLevel := 6;
  FRecurse := False;
  FDispose := False;
  FStorePaths := False;
  FStoreVolumes := False;
  FZipAction := zaUpdate;  {update only if newer}
  FBlockSize := 1457600;
  FRelativePaths := False;
  FStore83Names := False;
  FTempPath := '';
  Deleting := False;
  zfile := nil;
  tmpfiles := nil;
  tmpecrec := nil;
  TRInitialized := False;
  SaveNewName := '';
  StaticInit;
  CreatingSFX := False;
  FSkipIfArchiveBitNotSet := False; { 7/4/98 2.13 }
  FResetArchiveBitOnZip := False; { Added 4-Jun-98 SPF 2.13? }
  FExcludeList := TStringList.Create;  { 9/27/98  2.15 }
  FnoCompressList := TStringList.Create;  { 9/27/98  2.15 }
  FPreserveStubs := False; { 01/12/99  2.17 }
end;

destructor TVCLZip.Destroy;
begin
  FMultiZipInfo.Free;
  FMultiZipInfo := nil; { 4/25/98  2.11 }
  If (FExcludeList <> nil) then
     FExcludeList.Free;  { 9/27/98  2.15 }
  If (FNoCompressList <> nil) then
     FNoCompressList.Free;  { 9/27/98  2.15 }
  inherited Destroy;
end;

procedure TVCLZip.Loaded;
begin
  inherited Loaded;
  SetCheckDiskLabels( FMultiZipInfo.CheckDiskLabels );
  SetMultiMode( FMultiZipInfo.MultiMode );
end;
procedure TVCLZip.StaticInit;
begin
  ZeroMemory( @static_ltree, SizeOf(static_ltree) );
  ZeroMemory( @static_dtree,  SizeOf(static_dtree) );
  ZeroMemory( @bl_count, SizeOf(bl_count) );
  ZeroMemory( @base_dist, SizeOf(base_dist) );
  ZeroMemory( @length_code, SizeOf(length_code) );
  ZeroMemory( @dist_code, SizeOf(dist_code) );
  ZeroMemory( @base_length, SizeOf(base_length) );
end;

procedure TVClZip.SetPathname( Index: Integer; Value: TZipPathname );
var
 finfo: TZipHeaderInfo;
  tmpValue: String;
begin
 If (Index > -1) and (Index < Count) then
   begin
    finfo := sortfiles.Items[Index] as TZipHeaderInfo;
     If (Length(Value) > 0) and (Value[Length(Value)] <> '\') then
        tmpValue := Value + '\'
     Else
        tmpValue := Value;
     If tmpValue <> finfo.directory then
      begin
        finfo.directory := tmpValue;
        ecrec.Modified := True;
      end;
   end
  else Raise EListError.CreateFmt('Index %d is out of range',[Index]);
end;

procedure TVClZip.SetFilename( Index: Integer; Value: TZipPathname );
var
 finfo: TZipHeaderInfo;
begin
 If (Index > -1) and (Index < Count) then
   begin
    finfo := sortfiles.Items[Index] as TZipHeaderInfo;
     If Value <> finfo.filename then
      begin
        finfo.filename := Value;
        ecrec.Modified := True;
      end;
   end
  else Raise EListError.CreateFmt('Index %d is out of range',[Index]);
end;

procedure TVCLZip.SetMultiZipInfo(Value: TMultiZipInfo);
begin
  FMultiZipInfo.Assign(Value);
end;

function TVCLZip.GetMultiMode: TMultiMode;
begin
  Result := FMultiZipInfo.FMultiMode;
end;

procedure TVCLZip.SetMultiMode( Value: TMultiMode );
begin
  If FMultiZipInfo = nil then  { 4/26/98  2.11 }
     exit;  { to avoid illegal pointer operation error during Destroy method }
  If Value <> FMultiZipInfo.FMultiMode then
     FMultiZipInfo.FMultiMode := Value;
  FMultiMode := Value;
end;

function TVCLZip.GetCheckDiskLabels: Boolean;
begin
  Result := FMultiZipInfo.CheckDiskLabels;
end;

procedure TVCLZip.SetCheckDiskLabels( Value: Boolean );
begin
  If Value <> FMultiZipInfo.CheckDiskLabels then
     FMultiZipInfo.CheckDiskLabels := Value;
  FCheckDiskLabels := Value;
end;

procedure TVCLZip.SetStoreVolumes( Value: Boolean );
begin
  If Value <> FStoreVolumes then
   begin
     FStoreVolumes := Value;
     If Value = True then
        FStorePaths := True;
   end;
end;

procedure TVCLZip.SetStorePaths( Value: Boolean);
begin
  If Value <> FStorePaths then
   begin
     If Value = False then
      begin
        FStoreVolumes := False;
        FRelativePaths := False;
      end;
     FStorePaths := Value;
   end;
end;

procedure TVCLZip.SetRelativePaths( Value: Boolean );
begin
  If Value <> FRelativePaths then
   begin
     If Value = True then
      begin
        FStorePaths := True;
        FRecurse := True;
      end;
     FRelativePaths := Value;
   end;
end;

{ Added 4-Jun-98 SPF 2.13? }
procedure TVCLZip.ResetArchiveBit(AFileName: string);
begin
    FileSetAttr(AFileName, (FileGetAttr(AFileName) and not faArchive));
end;

function TVCLZip.ZipFromStream( theStream: TStream; FName: String ): Integer;
begin
  CancelOperation := False;
  StreamZipping := True;
  ZipStream := theStream;
  ZipStream.Position := 0;
  FilesList.Clear;
  FilesList.Add( FName );
  try
     Result := Zip;
  finally
     StreamZipping := False;
     CloseZip;
  end;
end;

function TVCLZip.ZipFromBuffer( Buffer: PChar; Amount: LongInt; FName: String ): Integer;
begin
  MemBuffer := Buffer;
  CurrMem := Buffer;
  MemLen := Amount;
  MemLeft := Amount;
  MemZipping := True;
  FilesList.Clear;
  FilesList.Add(Fname);
  try
     Result := Zip;
  finally
     MemZipping := False;
     CloseZip;
  end;
end;

function TVCLZip.Zip: Integer;
begin
  Result := ProcessFiles;
end;

function TVCLZip.IsInExcludeList( N: String ): Boolean;
var
  i: Integer;
  M,M1,M2: String;  { 11/27/98  2.16+}
begin
  Result := False;
  i := 0;
  M1 := LowerCase(ExtractFilename(N));   { 10/23/98  2.16+ }
  M2 := LowerCase(N);
  While i < FExcludeList.Count do
   begin
     {If this exclude list item doesn't include path info then ignore
      path info for the file being tested too}
     If (Pos('\',FExcludeList[i]) = 0) then  { 11/27/98  2.16+}
        M := M1
     Else
        M := M2;
     If IsMatch(LowerCase(FExcludeList[i]),M) then
      begin
        Result := True;
        break;
      end;
     Inc(i);
   end;
end;

function TVCLZip.IsInNoCompressList( N: String ): Boolean;
var
  i: Integer;
  M,M1,M2: String;
begin
  Result := False;
  i := 0;
  M1 := LowerCase(ExtractFilename(N));   { 10/23/98  2.16+ }
  M2 := LowerCase(N);
  While i < FNoCompressList.Count do
   begin
     {If this exclude list item doesn't include path info then ignore
      path info for the file being tested too}
     If (Pos('\',FNoCompressList[i]) = 0) then  { 11/27/98  2.16+}
        M := M1
     Else
        M := M2;
     If IsMatch(LowerCase(FNoCompressList[i]),M) then
      begin
        Result := True;
        break;
      end;
     Inc(i);
   end;
end;

function TVCLZip.ProcessFiles: Integer;
var
  DisposeFiles: TStrings;

  procedure AddTheNewFile(i: Integer);
  begin
     Inc(Result);
     tmpecrec.num_entries := tmpecrec.num_entries + 1;
     tmpecrec.num_entries_this_disk := tmpecrec.num_entries_this_disk + 1;
     tmpfiles.AddObject( tmpfile_info );
     tmpfiles2.AddObject( tmpfile_info );
     If Dispose then
        DisposeFiles.Add(FilesList[i]);
  end;

  Procedure DisposeOfFiles;
  var
     x: Integer;
     Skip: Boolean;
  begin
     Skip := False;
     For x := 0 to DisposeFiles.Count-1 do
      begin
        If Assigned(FOnDisposeFile) then
         begin
           Skip := False;
           FOnDisposeFile( Self, DisposeFiles[x], Skip );
         end;
        If not Skip then
           SysUtils.DeleteFile(DisposeFiles[x]);
      end;
     DisposeFiles.Free;
     DisposeFiles := nil;
  end;

  function ComparePath( P: String ): String;
  { This function expects P and RootDir to include full path information
    including disk information.  Also it is assumed that if RelativePaths
    is True then the path information for P contains RootDir. }
  begin
     If StorePaths then
      begin
       Result := ExtractFilePath(P);
       If FRelativePaths then
           Delete(Result, 1, Length(FRootDir))
       Else
        begin
        { modified the following to handle UNC paths  3/26/98  2.1 }
           If (not FStoreVolumes) and (ExtractFileDrive(Result) <> '') {(Result[2] = ':')} then
           Result := RightStr(Result,Length(Result)-(Length(ExtractFileDrive(Result))+1));
           {Result := RightStr(Result,Length(Result)-3);}
        end;
      end
     Else
        Result := '';
  end;

  procedure MoveExistingFiles;

   function FilesListMatches(FName: String): Boolean;
   var
     tmpFName: String;
   begin
     OemFilter(Fname);
     tmpFName := LowerCase(FName);
     If (Deleting) and (IsWildCard( FName )) then
      begin    { Wildcards should only be there if deleting }
        If (Pos('\',FName) > 0) then
           Result := IsMatch(tmpFName,LowerCase(tmpfile_info.directory+tmpfile_info.filename))
        Else
           Result := IsMatch(tmpFName,LowerCase(tmpfile_info.filename));
      end
     Else
      begin
        If not Deleting then
         begin
           tmpFName := ComparePath(tmpFName) + ExtractFilename(tmpFName);
         end;
        Result := tmpFName = LowerCase(tmpfile_info.directory+tmpfile_info.filename);
      end;
   end;

  var
    i,j: Integer;
    MoveTheFile: Boolean;
    Skip: Boolean;

  begin
  If files = nil then  { 3/28/98 2.1 }
     exit;             { fixed GPF when adding to empty archive }
  For i := 0 to files.Count-1 do  { Check each file in existing zip }
   begin
     tmpfile_info := TZipHeaderInfo.Create;
     tmpfile_info.Assign(files.Items[i] as TZipHeaderInfo);
     if ((i = 0) and (tmpfile_info.relative_offset > 0) and (FPreserveStubs)) then
      begin   { save sfx stub from beginning of file }
        theZipFile.Seek(0,soFromBeginning);
        zfile.CopyFrom(theZipFile, tmpfile_info.relative_offset);
      end;
     if (tmpfile_info.FileIsOK = 2) then  { skip files that are corrupted }
      begin
        tmpfile_info.Free;
        continue;
      end;
     If (tmpfile_info.file_comment_length > 0) and (tmpfile_info.filecomment = nil) then
        tmpfile_info.filecomment := StrToPChar(FileComment[i]);
     MoveTheFile := True;
     If FilesList.Count > 0 then
     For j := 0 to FilesList.Count-1 do  { Compare to each file in FilesList }
      begin
        If FilesListMatches(FilesList[j]) then
         begin  { This file is in zip file and fileslist too }
           If  (StreamZipping) or (MemZipping) or (ZipAction = zaReplace) or
               (Deleting) or (((ZipAction = zaUpdate) or (ZipAction = zaFreshen))
               and (DateTime[i] < FileDate(FilesList[j]))) then
            begin                     { Don't move files that will be replaced }
              Skip := False;
              If (Deleting) and (Assigned(FOnDeleteEntry)) then
                 FOnDeleteEntry(Self, tmpfile_info.directory+tmpfile_info.filename, Skip );
              If (Deleting) and (not Skip) then
                 Inc(Result);  { 5/18/98  2.13 }
              If not Skip then
               begin
                 MoveTheFile := False;   { or deleted. }
                 If (Deleting) and (not IsWildcard(FilesList[j])) then
                    FilesList.Delete(j);  { We're deleting, not zipping }
                 If (not Deleting) then
                  begin
                    tmpfile_info.Free;
                    tmpfile_info := TZipHeaderInfo.Create;
                    try
                       If AddFileToZip(FilesList[j]) then
                          AddTheNewFile(j)
                       Else
                        begin
                          tmpfile_info.Free;
                          tmpfile_info := nil;
                        end;
                    except
                       tmpfile_info.Free;
                       tmpfile_info := nil;
                       raise;
                    end;
                    FilesList.Delete(j);
                  end;
               end
              Else
               begin
                 MoveTheFile := True;    { File should just be saved from current zip }
                 FilesList.Delete(j);    { because current file is not older }
               end;
            end
           Else
            begin
              MoveTheFile := True;    { File should just be saved from current zip }
              FilesList.Delete(j);    { because disk file is not newer }
            end;
           Break;
         end;
      end;

     If MoveTheFile then  { Save this old file into new zip }
      begin
        MoveFile(i);
        tmpfiles.AddObject( tmpfile_info );  { Add info to new stuff }
        tmpfiles2.AddObject( tmpfile_info );
        tmpecrec.num_entries := tmpecrec.num_entries + 1;
        tmpecrec.num_entries_this_disk := tmpecrec.num_entries_this_disk + 1;
      end
     Else
        If (Deleting) then
           tmpfile_info.Free;
   end;
   tmpfile_info := nil;
  end;


  Procedure ExpandForWildCards;
  var
     i: Integer;
     WildFiles: TStrings;
     DirSearch: TDirSearch;
     theFile, StartDir: String;
     SearchRec: TSearchRec;
     tmpsearchinfo: TZipHeaderInfo;
     Idx: Integer;
     IsAnEntry: Boolean;
     doRecurse: Boolean;
     tmpWildFile: String;
     tmpName: String;
  begin
     WildFiles := TStringList.Create;
     TotalUncompressedSize := 0;
     TotalBytesDone := 0;
     i := 0;
     If ZipAction = zaFreshen then
        Sort( ByName );  { so we can check FilesList agains whats there already }
     While (FilesList.Count > 0) and (i < FilesList.Count) do
      begin
        If IsWildcard(FilesList[i]) then
         begin
           WildFiles.Add( FilesList[i] );
           FilesList.Delete(i);
         end
        Else
         begin  { See if file exists }
          If ExtractFilePath(FilesList[i]) = '' then
           FilesList[i] := FRootDir + FilesList[i];
          If IsInExcludeList(FilesList[i]) then    { 9/28/98  2.15 }
           begin
              FilesList.Delete(i);
              Continue;
           end;
          If FindFirst( FilesList[i], faAnyFile, SearchRec ) = 0 then
           begin
              If ((FSkipIfArchiveBitNotSet) and ((FileGetAttr(FilesList[i]) and faArchive)>0)) then
               begin
                 FilesList.Delete(i);
                 Continue;  { Skip if only zipping files with archive bit set }
               end;
              If ZipAction = zaFreshen then
               begin
                { Ignore it if it's not already in the zip }
                tmpName := FilesList[i];
                OemFilter( tmpName );
                tmpsearchinfo := TZipHeaderInfo.Create;
                tmpsearchinfo.filename := ExtractFilename(tmpName);
                tmpsearchinfo.directory :=  ComparePath(tmpName);
                IsAnEntry := sortfiles.Search( Pointer(tmpsearchinfo), Idx );
                tmpsearchinfo.Free;
                If not IsAnEntry then { Delete this entry from fileslist }
                 begin
                    FilesList.Delete(i);
                    Continue;  { Skip if freshening and file's not in zip already }
                 end;
               end;
              TotalUncompressedSize := TotalUncompressedSize + SearchRec.Size;
              Inc(i);
              FindClose( SearchRec );  {1/28/98 moved inside here so wouldn't be called if}
           end                         {FindFirst didn't find anything    v2.00+}
          Else
           begin
					If Assigned( FOnNoSuchFile ) then
                 OnNoSuchFile( Self, FilesList[i] );
              { Moved following line down 1 to fix 'List out of bounds' error. 5/5/98 2.12 }
              FilesList.Delete(i);  { No such file to zip }
           end;
         end;
      end;

   If WildFiles.Count > 0 then
     For i := 0 to WildFiles.Count-1 do
      begin
        { Added recursion override feature 7/22/98  2.14 }
        If (WildFiles[i][1] = WILDCARD_NORECURSE) then  { No recursing }
         begin
           doRecurse := False;
           tmpWildFile := WildFiles[i];
           Delete(tmpWildFile,1,1);
           WildFiles[i] := tmpWildFile;
         end
        Else If (WildFiles[i][1] = WILDCARD_RECURSE) then  { Recurse }
         begin
           doRecurse := True;
           tmpWildFile := WildFiles[i];
           Delete(tmpWildFile,1,1);
           WildFiles[i] := tmpWildFile;
         end
        Else doRecurse := FRecurse;

        StartDir := ExtractFileDir(WildFiles[i]);
        If StartDir = '' then
           StartDir := FRootDir;
        If not DirExists(StartDir) then   { 10/23/98  2.16+ }
           continue;
        DirSearch := TDirSearch.Create( StartDir,
                                     ExtractFilename(WildFiles[i]), doRecurse);
        theFile := DirSearch.NextFile(SearchRec);
        While (theFile <> '') do
         begin
          If IsInExcludeList(theFile) then   { 9/28/98  2.15 }
           begin
              theFile := DirSearch.NextFile(SearchRec);
              Continue;
           end;
           {Don't archive the archive we are creating right now}
           If (ArchiveIsStream) or (AnsiCompareText(theFile,ZipName) <> 0) then
            begin
              If ((FSkipIfArchiveBitNotSet) and ((FileGetAttr(theFile) and not faArchive)>0)) then
               begin
                 theFile := DirSearch.NextFile(SearchRec);
                 Continue;  { Skip if only zipping files with archive bit set }
               end;
              If ZipAction = zaFreshen then { skip if its not already in zip file }
               begin
                 { Ignore it if it's not already in the zip }
                 tmpName := theFile;
                 OemFilter( tmpName );
                 tmpsearchinfo := TZipHeaderInfo.Create;
                 tmpsearchinfo.filename := ExtractFilename(tmpName);
                 tmpsearchinfo.directory := ComparePath(tmpName);
                 IsAnEntry := sortfiles.Search( Pointer(tmpsearchinfo), Idx );
                 tmpsearchinfo.Free;
                 If not IsAnEntry then
                  begin
                    theFile := DirSearch.NextFile(SearchRec);
                    Continue;  { Skip if freshening and file's not in zip already }
                  end;
               end;
              FilesList.Add( theFile );
              TotalUncompressedSize := TotalUncompressedSize + SearchRec.Size;
            end;
           theFile := DirSearch.NextFile(SearchRec);
         end;
        DirSearch.Free;
      end;

     WildFiles.Free;
     If ZipAction = zaFreshen then
       Sort( ByNone );  { Set back }
  end;

  procedure AllocateZipArrays;
  begin
  {$IFDEF WIN16}
     If windowObj = nil then
      begin
        windowObj := TkpHugeByteArray.Create(2*WSIZE);
        window := windowtypePtr(windowObj.AddrOf[0]);
        prevObj := TkpHugeWordArray.Create(WSIZE);
        prev := prevtypePtr(prevObj.AddrOf[0]);
        headObj :=  TkpHugeWordArray.Create(HASH_SIZE);
        head := headtypePtr(headObj.AddrOf[0]);
        l_bufObj := TkpHugeByteArray.Create(LIT_BUFSIZE);
        l_buf := l_buftypePtr(l_bufObj.AddrOf[0]);
        d_bufObj := TkpHugeWordArray.Create(DIST_BUFSIZE);
        d_buf := d_buftypePtr(d_bufObj.AddrOf[0]);
        flag_bufObj := TkpHugeByteArray.Create(LIT_BUFSIZE div 8);
        flag_buf := flag_buftypePtr(flag_bufObj.AddrOf[0]);
      end;
  {$ELSE}
     If window = nil then
      begin
        New(window);
        New(prev);
        New(head);
        New(l_buf);
        New(d_buf);
        New(flag_buf);
      end;
  {$ENDIF}
  end;

  procedure DeAllocateZipArrays;
  begin
  {$IFDEF WIN16}
     windowObj.Free;
     windowObj := nil;
     prevObj.Free;
     prevObj := nil;
     headObj.Free;
     headObj := nil;
     l_bufObj.Free;
     l_bufObj := nil;
     d_bufObj.Free;
     d_bufObj := nil;
     flag_bufObj.Free;
     flag_bufObj := nil;
  {$ELSE}
     System.Dispose(window);
     window := nil;
     System.Dispose(prev);
     prev := nil;
     System.Dispose(head);
     head := nil;
     System.Dispose(l_buf);
     l_buf := nil;
     System.Dispose(d_buf);
     d_buf := nil;
     System.Dispose(flag_buf);
     flag_buf := nil;
  {$ENDIF}
  end;

var
  i: Integer;
  FinishedOK: Boolean;
  SaveSortedFiles: TSortedZip;
  SaveSortMode: TZipSortMode;
  SaveKeepZipOpen: Boolean;
  SaveZipName: String;
  StopNow: Boolean;
  TotalCentralSize: LongInt;
  SaveCentralPos: LongInt;

begin  {************** ProcessFiles Main Body ****************}
  Result := 0;
  If FilesList = nil then
     exit;
  FBusy := True;
  FinishedOK := False;
  CurrentDisk := 0;
  SaveSortedFiles := sortfiles;
  SaveSortMode := SortMode;
  SaveKeepZipOpen := KeepZipOpen;
  KeepZipOpen := True;
  sortfiles := files;
  SortMode := ByNone;

  If MultiZipInfo.MultiMode = mmSpan then
     AmountToWrite := DiskRoom
  Else If MultiZipInfo.MultiMode = mmBlocks then
     AmountToWrite := MultiZipInfo.FirstBlockSize;
  If Dispose then
     DisposeFiles := TStringList.Create;
  If (not Deleting) and (not StreamZipping) and (not MemZipping) and (FilesList.Count > 0) then
     ExpandForWildCards;

  try  { Moved up to here 4/12/98  2.11 }
  If ((ArchiveIsStream) and (theZipFile.Size > 0)) or (File_Exists(ZipName)) then
   begin
     AllocateZipArrays;
     { create new file in temporary directory }
     UsingTempFile := True;
     If not ArchiveIsStream then
      begin
        {PathSize := GetTempPath( SizeOf(tempPathPStr), @tempPathPStr[0] );}
        { Changed to TempFilename  5/5/98  2.12 }
        tmpZipName := TempFilename(TemporaryPath);
        {tmpZipName := StrPas(tempPathPStr) + ExtractFileName( ZipName );}
      end;
     CreateTempZip;
     OpenZip; { open existing zip so we can move existing files }
     MoveExistingFiles;  {Move those existing files}
   end
  Else
   begin
     AllocateZipArrays;
     If not ArchiveIsStream then
        tmpZipName := ZipName;
     UsingTempFile := False;
     CreateTempZip;
   end;

  If (not Deleting) and (FilesList.Count > 0) then
   begin
     StopNow := False;
     If Assigned(FOnStartZipInfo) then
        FOnStartZipInfo( Self, FilesList.Count, TotalUncompressedSize, tmpecrec, StopNow );
     If StopNow then
        raise EUserCanceled.Create('User canceled Zip operation.');
   end;

  { For each file in the FilesList AddFileToZip }
  If (not Deleting) and (FilesList.Count > 0) then
   begin
     For i := 0 to FilesList.Count-1 do
      begin
        tmpfile_info := TZipHeaderInfo.Create;
        try
           If AddFileToZip(FilesList[i]) then
              AddTheNewFile(i)
           Else
            begin
              tmpfile_info.Free;
              tmpfile_info := nil;
            end;
        except
           tmpfile_info.Free;
           tmpfile_info := nil;
           raise;
        end;
      end;
   end;  { If not Deleting }
  tmpecrec.offset_central := zfile.Position;
  tmpecrec.start_central_disk := CurrentDisk;
  totalCentralSize := 0;
  saveCentralPos := tmpecrec.offset_central;
  For i := 0 to tmpfiles2.Count-1 do
   begin
     tmpfile_info := tmpfiles2.Items[i] as TZipHeaderInfo;
     If (MultiZipInfo.MultiMode <> mmNone) and (RoomLeft < tmpfile_info.CentralSize) then
      begin
        Inc(TotalCentralSize,zfile.Position - saveCentralPos);
        saveCentralPos := 0;
        NextPart;
        If i = 0 then
         begin
           tmpecrec.offset_central := 0;
           tmpecrec.start_central_disk := CurrentDisk;
         end;
      end;
     tmpfile_info.SaveCentralToStream( zfile );
   end;
  Inc(TotalCentralSize,zfile.Position - saveCentralPos);
  tmpecrec.size_central := TotalCentralSize;
  If (MultiZipInfo.MultiMode <> mmNone) and (RoomLeft < tmpecrec.EndCentralSize) then
     NextPart;
  tmpecrec.this_disk := CurrentDisk;
  tmpecrec.SaveToStream(zfile);
  If MultiZipInfo.MultiMode = mmSpan then
     LabelDisk;
  FinishedOK := True;
  finally
   DeAllocateZipArrays;
   If (not ArchiveIsStream) then
    begin
     zfile.Free;   { close the temp zip file }
     zfile := nil;
    end;
   If FinishedOK then
    begin
     If (not ArchiveIsStream) and (not CreatingSFX) then
        SaveZipName := ZipName;
     If (not CreatingSFX) and ((not ArchiveIsStream) and (UsingTempFile)) then
        ClearZip;
     If (MultiZipInfo.MultiMode = mmBlocks) then
      begin
        If (CurrentDisk > 0) then
           ZipName := ChangeFileExt(SaveZipName,'.'+Format('%3.3d',[CurrentDisk+1]))
        Else
         begin  { No need for the multi file extention so change back to .zip }
           ZipName := SaveZipName;
           SaveZipName := ChangeFileExt(SaveZipName,'.'+Format('%3.3d',[CurrentDisk+1]));
           RenameFile(SaveZipName, ZipName);
         end;
      end
     Else If (not ArchiveIsStream) and (not CreatingSFX) then
        ZipName := SaveZipName;
     If (UsingTempFile) then
        MoveTempFile
     Else If ArchiveIsStream then
        zfile := nil;  {2/11/98}
     If (Dispose) then
        DisposeOfFiles;

     If not CreatingSFX then
      begin    { We'll point everyting to the newly created information }
        ecrec.Assign( tmpecrec );
        files := tmpfiles2;
        sortfiles := files;
        SortMode := ByNone;
      end
     Else  { We're going back to the same zip file }
      begin
        tmpfiles2.Free;
        tmpfiles2 := nil;
        sortfiles := SaveSortedFiles;
      end;

     If (not ArchiveIsStream) and (not CreatingSFX) then
        filesDate := FileDate( ZipName );
     If (SaveSortMode <> ByName) and (not CreatingSFX) then
        Sort(SaveSortMode)
     Else If (not CreatingSFX) then
      begin
        sortfiles := tmpfiles;  { already sorted by name }
        tmpfiles := nil;
      end;
     WriteNumDisks( CurrentDisk+1 );
    end
   Else
    begin
     tmpfiles2.Free;
     tmpfiles2 := nil;
     SysUtils.DeleteFile( tmpZipName );
    end;
   SortMode := SaveSortMode;
   KeepZipOpen := SaveKeepZipOpen;
   tmpfiles.Free;
   tmpfiles := nil;
   tmpecrec.Free;
   tmpecrec := nil;
   CloseZip;
   If ArchiveIsStream then
     GetFileInfo;
   FBusy := False;
  end;
end;

procedure TVCLZip.CreateTempZip;
begin
  If MultiZipInfo.MultiMode = mmBlocks then
     tmpZipName := ChangeFileExt(tmpZipName,'.'+Format('%3.3d',[CurrentDisk+1]));
  If not ArchiveIsStream then
     zfile := TLFNFileStream.CreateFile( tmpZipName, fmCreate )
  Else
   begin
     If UsingTempFile then
        zfile := TMemoryStream.Create
     Else
        zfile := theZipFile;   {2/11/98}
   end;
  If CreatingSFX then
     zfile.CopyFrom( SFXStubFile, SFXStubFile.Size );
  tmpfiles := TSortedZip.Create( DupError );
  tmpfiles.SortMode := ByName;
  tmpfiles.DestroyObjects := False;
  tmpfiles2 := TSortedZip.Create( DupError );
  tmpfiles2.SortMode := ByNone;
  tmpecrec := TEndCentral.Create;
  If UsingTempFile then
   begin
     tmpecrec.Assign( ecrec );
     If (tmpecrec.zip_comment_length > 0) and (tmpecrec.ZipComment = nil) then
        tmpecrec.ZipComment := StrToPChar(ZipComment);
     tmpecrec.num_entries := 0;
     tmpecrec.num_entries_this_disk := 0;
   end;
end;

function TVCLZip.DiskRoom: LongInt;
  var
     Disk: Byte;
  begin
     If ZipName[2] <> ':' then
        Disk := 0
     Else
      begin
        Disk := Ord(ZipName[1])-64;
        If Disk > 32 then
           Dec(Disk,32);
      end;
     Result := DiskFree( Disk );
  end;

function TVCLZip.RoomLeft: LongInt;
begin
  Result := AmountToWrite - zfile.Size;
end;

procedure TVCLZip.LabelDisk;
var
  Disk: String;
  NewLabel: String;
  {Rslt: LongBool;}
begin
  If (MultiZipInfo.MultiMode = mmSpan) and  (MultiZipInfo.WriteDiskLabels) then
   begin
     Disk := ZipName[1];
     Disk := UpperCase(Disk);
     If (Disk = 'A') or (Disk = 'B') then  { Only label floppies }
      begin
        Disk := Disk + ':\';
        NewLabel := 'PKBACK# ' + Format('%3.3d',[CurrentDisk+1]);
   {Rslt :=} SetVolLabel(Disk, NewLabel);
      end;
   end;
end;

procedure TVCLZip.NextPart;
begin
 If MultiZipInfo.MultiMode <> mmNone then
 begin
  If MultiZipInfo.MultiMode = mmSpan then
   begin
     If Assigned(FOnGetNextDisk) then
      begin
        zfile.Free;
        zfile := nil;
        LabelDisk; { Label disk before they change it }
        OnGetNextDisk(Self, CurrentDisk+2, tmpZipName);
        If tmpZipName = '' then
           raise EUserCanceled.Create('User canceled Zip operation.');
        Inc(CurrentDisk);
        AmountToWrite := DiskRoom;
      end
   end
  Else
   begin
     zfile.Free;
     zfile := nil;
     Inc(CurrentDisk);
     tmpZipName := ChangeFileExt(tmpZipName, '.'+Format('%3.3d',[CurrentDisk+1]));
     AmountToWrite := MultiZipInfo.BlockSize;
   end;
  zfile := TLFNFileStream.CreateFile( tmpZipName, fmCreate );
  AmountWritten := 0;
  tmpecrec.num_entries_this_disk := 0;
 end;
end;

function TVCLZip.AddFileToZip( FName: String ): Boolean;
var
  SavePos: LongInt;
  tmpDir: String;
  Idx: Integer;
  Skip: Boolean;
  {tempPathPStr: array [0..PATH_LEN] of char;}
  {PathSize: LongInt;}

  procedure CalcFileCRC;
  { Modified to use a PChar for cbuffer 4/12/98  2.11 }
  const
     BLKSIZ = 4096;
  var
     cbuffer: PChar;
     AmountRead: LongInt;
     AmtLeft: LongInt;
  begin
     AmtLeft := 0;
     cbuffer := nil;
     If (not MemZipping) then
     GetMem(cbuffer,BLKSIZ);
     try
        Crc32Val := $FFFFFFFF;
        If (MemZipping) then
         begin
           cbuffer := MemBuffer;
           AmountRead := min(MemLen,BLKSIZ);
           AmtLeft := MemLen - AmountRead;
         end
        Else
        AmountRead := IFile.Read(cbuffer^, BLKSIZ);
        While AmountRead <> 0 do
         begin
           Update_CRC_buff(BytePtr(cbuffer), AmountRead);
           If (MemZipping) then
            begin
              AmountRead := min(AmtLeft, BLKSIZ);
              Inc(cbuffer, AmountRead);
              Dec(AmtLeft, AmountRead);
            end
           Else
           AmountRead := IFile.Read(cbuffer^, BLKSIZ);
         end;
         If (not MemZipping) then
         IFile.Seek(0, soFromBeginning);
     finally
         If (not MemZipping) then
        FreeMem(cbuffer,BLKSIZ);
     end;
  end;

  procedure SaveMFile;
  var
     AmtToCopy: LongInt;
     TotalAmtToCopy: LongInt;
  begin
     If RoomLeft = 0 then
        NextPart;
     mfile.Seek(0, soFromBeginning);
     TotalAmtToCopy := mfile.Size;
     AmtToCopy := min( RoomLeft, TotalAmtToCopy );
     If (mfile.Size = 0) then
        AmtToCopy := 0;
     While (TotalAmtToCopy > 0) and (AmtToCopy > 0) do
      begin
        zfile.CopyFrom( mfile, AmtToCopy );
        Dec(TotalAmtToCopy,AmtToCopy);
        If (TotalAmtToCopy > 0) or (RoomLeft = 0) then
           NextPart;
        AmtToCopy := min( RoomLeft, TotalAmtToCopy );
      end;
  end;

  procedure StoreFile;
  const
     BLKSIZ = 4096;
  var
     storeBuf: BytePtr;
     bytesRead: LongInt;
  begin
     GetMem(storeBuf, BLKSIZ);
     try
         bytesRead := file_read(storeBuf,BLKSIZ);
         While bytesRead > 0 do
          begin
           zfwrite(storeBuf,1,bytesRead);
           bytesRead := file_read(storeBuf,BLKSIZ);
          end;
     finally
        FreeMem(storeBuf,BLKSIZ);
     end;
  end;

var
  tmpRootDir: String;
  DrivePart:  String;

begin   { ************* AddFileToZip Procedure ***************** }
  Result := False;
  FileBytes := 0;
  IFileName := FName;
  tmpRootDir := RootDir; { 5/3/98 2.12 }
  {tmpfile_info := TZipHeaderInfo.Create;} {Moved to ProcessFiles 11/27/98 2.16+}
  If (not StreamZipping) and (not MemZipping) then
   begin
     If not FileExists( FName ) then
        exit;
     tmpfile_info.external_file_attributes := FileGetAttr( FName );
     try
        IFile := TLFNFileStream.CreateFile( FName, fmOpenRead or fmShareDenyNone );
     except
        result := False;
        If Assigned( FOnSkippingFile ) then
           FOnSkippingFile( self, srFileOpenError, FName, -1 );
        exit;
     end;
     tmpfile_info.last_mod_file_date_time := FileGetDate( TLFNFileStream(IFile).Handle );
  end
  Else
   begin
     If (StreamZipping) then
        IFile := ZipStream;
     tmpfile_info.last_mod_file_date_time := DateTimeToFileDate( Now );
   end;
  mfile := nil;
 try
  If (MemZipping) then
     tmpfile_info.uncompressed_size := MemLen
  Else
  tmpfile_info.uncompressed_size := IFile.Size;
  {$IFDEF WIN32}
  If FStore83Names then
   begin
    FName := LFN_ConvertLFName(FName,SHORTEN);
    If tmpRootDir <> '' then
     tmpRootDir := LFN_ConvertLFName(RootDir,SHORTEN);
   end;
  {$ELSE}
  {$IFNDEF NOLONGNAMES}  { 4/12/98 2.11 }
  If (not FStore83Names) and (OSVersion > 3) then
   begin
     FName := LFN_ConvertLFName(FName,LENGTHEN);
     If tmpRootDir <> '' then
        tmpRootDir := LFN_ConvertLFName(RootDir,LENGTHEN);
   end;
  {$ENDIF}
  {$ENDIF}
  OEMFilter(FName);
  tmpfile_info.filename := ExtractFileName(FName);
  tmpfile_info.relative_offset := zfile.Position;
  tmpfile_info.internal_file_attributes := UNKNOWN;
  tmpfile_info.disk_number_start := CurrentDisk;
 If FStorePaths then
  begin
  tmpDir := ExtractFileDir(Fname) + '\';
     If RightStr( tmpDir, 2 ) = '\\' then      {Incase it's the root directory 3/10/98 2.03}
        SetLength(tmpDir, Length(tmpDir)-1);
     If (tmpRootDir <> '') and (RelativePaths) and (AnsiCompareText(LeftStr(tmpDir,Length(tmpRootDir)),tmpRootDir)=0) then
      begin
        If (AnsiCompareText(tmpRootDir,tmpDir)=0) then
           tmpDir := ''
        Else
           Delete( tmpDir, 1, Length(tmpRootDir));
      end;
     { added the following 3/26/98 to handle UNC paths. 2.1 }
     If (not RelativePaths) and (not FStoreVolumes) and (tmpDir <> '') then
      begin
        DrivePart := ExtractFileDrive(tmpdir);
        if DrivePart <> '' then
           Delete(tmpdir, 1, Length(DrivePart));
        if LeftStr(tmpdir,1) = '\' then
           Delete(tmpdir,1,1);
      end;
  tmpfile_info.directory := tmpDir;
     {The filename_length now gets set automatically when setting the directory
      or filename  Nov 16, 1997 KLB }
  {tmpfile_info.filename_length := Length(tmpfile_info.directory+tmpfile_info.filename);}
  end;
   {The filename_length now gets set automatically when setting the directory
    or filename  Nov 16, 1997 KLB }
 {Else
  tmpfile_info.filename_length := Length(tmpfile_info.filename);}

  { If a file by the same name is already archived then skip this one }
  If tmpfiles.Search( Pointer(tmpfile_info), Idx ) then
   begin
     Result := False;
     { This is sort of a cludge but it works for now }
  If Assigned( FOnSkippingFile ) then
      begin
        FOnSkippingFile( self, srNoOverwrite, FName, -1 );
      end;
     If (not StreamZipping) and (not MemZipping) then
      begin
        TotalUncompressedSize := TotalUncompressedSize - IFile.Size;
        IFile.Free;
        IFile := nil;
      end;
     exit;
   end;

  Skip := False;
  If Assigned( FOnStartZip ) then
     FOnStartZip( Self, FName, tmpfile_info, Skip );
  If Skip then
   begin
     If (not StreamZipping) and (not MemZipping) then
      begin
        TotalUncompressedSize := TotalUncompressedSize - IFile.Size;
        IFile.Free;
        IFile := nil;
      end;
     Result := False;
     exit;
   end;

  {Save local header for now, will update when done}
  If (MultiZipInfo.MultiMode <> mmNone) and (RoomLeft <= tmpfile_info.LocalSize) then
   begin                                  { 2/1/98 Changed the above from < to <= }
     NextPart;
     tmpfile_info.disk_number_start := CurrentDisk; { 2/1/98 }
   end;
  If MultiZipInfo.MultiMode <> mmNone then
    begin
     {PathSize := GetTempPath( SizeOf(tempPathPStr), @tempPathPStr[0] );}
     { Changed to TempFilename  5/5/98  2.12 }
     mZipName := TempFilename(TemporaryPath);
     {mZipName := StrPas(tempPathPStr) + 'KPy76p09.tmp';}
     mfile := TLFNFileStream.CreateFile( mZipName, fmCreate );
    end;
  tmpfile_info.SaveLocalToStream( zfile );
  {SavePos := zfile.Position;}
  If Password <> '' then
   begin
     CalcFileCRC;
     Crc32Val := not Crc32Val;
     tmpfile_info.crc32 := Crc32Val;
     crypthead( Password );
   end;
  Crc32Val := $FFFFFFFF;
  {$IFDEF KPDEMO}
     If not DR then
        tmpfile_info.filename := '';
  {$ENDIF}

  {*************** HERE IS THE CALL TO ZIP ************************}
  If (PackLevel = 0) or (IsInNoCompressList(tmpfile_info.filename)) then  { 10/23/98  2.16+ }
   begin
     StoreFile;
     tmpfile_info.compressed_size := tmpfile_info.uncompressed_size;
     tmpfile_info.compression_method := STORED;
     tmpfile_info.internal_file_attributes := BINARY; { assume binary if STOREing - for now. 10/18/98 }
   end
  Else
     tmpfile_info.compressed_size := Deflate;  { Compress the file!! }
  {****************************************************************}

{  Assert(  tmpfile_info.compressed_size = zfile.Seek(0, soFromCurrent) - SavePos, }
{           'Deflate returned wrong compressed size.');         }
  Crc32Val := not Crc32Val;
  SavePos := zfile.Position;
  zfile.Seek(tmpfile_info.relative_offset, soFromBeginning);
  tmpfile_info.crc32 := Crc32Val;
  If Password <> '' then
   begin  { Mark the file as encrypted and modify compressed size
            to take into account the 12 byte encryption header    }
     tmpfile_info.general_purpose_bit_flag := tmpfile_info.general_purpose_bit_flag or 1;
     tmpfile_info.compressed_size := tmpfile_info.compressed_size + 12;
   end;
  { Save the final local header }
  tmpfile_info.SaveLocalToStream( zfile );
  If MultiZipInfo.MultiMode <> mmNone then
     SaveMFile
  Else
     zfile.Seek(SavePos, soFromBeginning);
  Result := True;
 finally
  mfile.Free;
  mfile := nil;
  SysUtils.DeleteFile( mZipName );
  If (not StreamZipping) and (not MemZipping) then
   begin
     IFile.Free;
     IFile := nil;
   end;
 end;

 { Added 4-Jun-98 by SPF to support reset of archive bit after the file
      has been zipped }
 if FResetArchiveBitOnZip and (not StreamZipping) and (not MemZipping) then
  ResetArchiveBit(FName);

  If Assigned(FOnEndZip) then
     FOnEndZip( Self, FName, tmpfile_info.uncompressed_size,
                 tmpfile_info.compressed_size, zfile.Size );

end;

procedure TVCLZip.CryptHead( passwrd: String );
var
  i: Integer;
  c: Byte;
begin
  Init_Keys( passwrd );
  Randomize;
  For i := 1 to 10 do
   begin
     c := zencode( Byte(random($7FFF) shr 7) );
     If MultiZipInfo.MultiMode = mmNone then
        zfile.Write( c, 1 )
     Else
        mfile.Write( c, 1 );
   end;
  c := zencode(LOBYTE(HIWORD(tmpfile_info.crc32)));
  If MultiZipInfo.MultiMode = mmNone then
     zfile.Write(c,1)
  Else
     mfile.Write(c,1);
  c := zencode(HIBYTE(HIWORD(tmpfile_info.crc32)));
  If MultiZipInfo.MultiMode = mmNone then
     zfile.Write(c,1)
  Else
     mfile.Write(c,1);
end;


procedure TVCLZip.MoveFile( Index: Integer );
var
  lrc: local_file_header;
begin
  theZipFile.Seek( tmpfile_info.relative_offset, soFromBeginning );
  { Filename length may have changed from original so we have to get }
  { it from the original local file header - 10/29/97 KLB }
  theZipFile.Read( lrc, SizeOf(local_file_header));
  theZipFile.Seek( lrc.filename_length, soFromCurrent );
  tmpfile_info.relative_offset := zfile.Position;
  tmpfile_info.SaveLocalToStream( zfile );
  {Added following test for zero length because it was doubling archive size - 01/21/97 KLB}
  If (tmpfile_info.compressed_size + tmpfile_info.extra_field_length) > 0 then
     zfile.CopyFrom(theZipFile, tmpfile_info.compressed_size + tmpfile_info.extra_field_length);
end;

procedure TVCLZip.MoveTempFile;
begin
  If ArchiveIsStream then
   begin
     theZipFile.Free;
     theZipFile := zfile;
     zfile := nil;
   end
  Else
   begin
     If SaveNewName = '' then
      begin
        SysUtils.DeleteFile( ZipName );
        FileCopy( tmpZipName, ZipName );
      end
     Else
        FileCopy( tmpZipName, SaveNewName );
     SysUtils.DeleteFile( tmpZipName );
   end;
end;

function TVCLZip.DeleteEntries: Integer;
begin
  Deleting := True;
  Result := ProcessFiles;
  Deleting := False;
end;

procedure TVCLZip.SetZipName( ZName: String );
begin
  if not (csDesigning In ComponentState) then
   begin
     If AnsiCompareText(ZName,ZipName) = 0 then
        exit;
     If ecrec.Modified then
      begin
        FilesList.Clear;
        ProcessFiles;
        ecrec.Modified := False;
      end;
   end;
  inherited SetZipName( ZName );
end;

procedure TVCLZip.SaveModifiedZipFile;
begin
  If ecrec.Modified then
   begin
     FilesList.Clear;
     ProcessFiles;
     ecrec.Modified := False;
     ReadZip;
   end;
end;

function TVCLZip.GetIsModified: Boolean;
begin
  Result := ecrec.Modified;
end;

function TVCLZip.FixZip( InputFile, OutputFile: String ): Integer;
var
  Canceled: Boolean;
  tmpFilesList: TStrings;
  i: Integer;
  {$IFNDEF WIN32}
  j: Boolean;
  {$ENDIF}
begin
  Canceled := False;
  Result := 0;
  If InputFile <> '' then
     ZipName := InputFile
  Else
  If (Count = 0) or (not ZipIsBad) then
   begin
    try
     ZipName := ExtractFileDir(ZipName) + '\?';
    except
     On EUserCanceled do
      exit;
     Else
         raise;    { If not EUserCanceled then re-raise the exception }
    end;
     Fixing := True;
     Screen.Cursor := crHourGlass;
     try
        ReadZip;
        for i := 0 to Count-1 do
           {$IFNDEF WIN32} j := {$ENDIF}  FileIsOK[i];
     finally
        Screen.Cursor := crDefault;
     end;
     Fixing := False;
   end;
  If OutputFile <> '' then
     SaveNewName := OutputFile
  Else
  begin
  OpenZipDlg := TOpenDialog.Create(Application);
  try
     OpenZipDlg.Title := 'Select a new name for the fixed file.';
     OpenZipDlg.Filter := 'Zip Files (*.ZIP)';
  If DirExists(ExtractFilePath(ZipName)) then
   OpenZipDlg.InitialDir := ExtractFilePath(ZipName)
  Else
      OpenZipDlg.InitialDir := 'C:\';
  If OpenZipDlg.Execute then
   SaveNewName := OpenZipDlg.Filename
  Else
   Canceled := True;
  finally
  OpenZipDlg.Free;
  end;
  end;
  If not Canceled then
   begin
     tmpFilesList := TStringList.Create;
     tmpFilesList.Assign(FilesList);
     FilesList.Clear;
     Screen.Cursor := crHourGlass;
     try
        Result := ProcessFiles;
     finally
        Screen.Cursor := crDefault;
        FilesList.Assign(tmpFilesList);
        tmpFilesList.Free;
     end;
     ZipName := SaveNewName;
   end;
  SaveNewName := '';
end;

procedure TVCLZip.MakeSFX( SFXStub: String; ModHeaders: Boolean );
begin
  If ZipName = '' then
     exit;
  SFXStubFile := TLFNFileStream.CreateFile(SFXStub, fmOpenRead);
  try
     CreatingSFX := True;
     SaveNewName := ChangeFileExt( ZipName, '.EXE');
     ProcessFiles;
     CreatingSFX := False;
     SaveNewName := '';
  finally
     SFXStubFile.Free;
     SFXStubFile := nil;
  end;
end;

{***********************************************************************
 * If requested, encrypt the data in buf, and in any case call fwrite()
 * with the arguments to zfwrite().  Return what fwrite() returns.
 *}
function TVCLZip.zfwrite(buf: BytePtr; item_size, nb: Integer): LongInt;
{    voidp *buf;               /* data buffer */
    extent item_size;         /* size of each item in bytes */
    extent nb;                /* number of items */
    FILE *f;                  /* file to write to */  }
var
  size:   LongInt;
  p:      BytePtr;
  AmountToWrite: LongInt;
begin
    Result := 0;
    if (Password <> '') then       { key is the global password pointer }
     begin
        p := buf;               { steps through buffer }
        { Encrypt data in buffer }
        for size := item_size*nb downto 1 do
         begin
            p^ := zencode(p^);
            Inc(p);
         end;
     end;

    { Write the buffer out }
    AmountToWrite := item_size*nb;
    If MultiZipInfo.MultiMode = mmNone then
     Inc(Result,zfile.Write( buf^, AmountToWrite )) {return fwrite(buf, item_size, nb, f);}
    Else
     Inc(Result,mfile.Write( buf^, AmountToWrite ));
    Inc(AmountWritten,Result);
    If DoProcessMessages then
      begin
        Application.ProcessMessages;
        If CancelOperation then
         begin
           CancelOperation := False;
           raise EUserCanceled.Create('User Aborted Operation');
         end;
      end;
end;

function TVCLZip.zencode(c: Byte): Byte;
var
  temp: Byte;
begin
  temp := decrypt_byte;
  update_keys(Char(c));
  Result := temp xor c;
end;

function TVCLZip.file_read( w: BytePtr; size: usigned ): LongInt;
var
  Percent: LongInt;
begin
  If (MemZipping) then        { 7/13/98  2.14 }
   begin
     Result := min(MemLeft,size);
     If (Result > 0) then
      begin
        MoveMemory(w,CurrMem,Result);
        Inc(CurrMem,Result);
        Dec(MemLeft,Result);
      end;
   end
  Else
  Result := IFile.Read( w^, size );
  If Result = 0 then
   begin
 {    If isize <> tmpfile_info.uncompressed_size then
        ShowMessage('isize <> amtread - ' + IFileName);  }
     exit;
   end;
 If Assigned(FOnFilePercentDone) then
   begin
     Inc(FileBytes, Result);
     Percent := CRate( tmpfile_info.uncompressed_size, FileBytes );
     OnFilePercentDone( self, Percent );
   end;
  If Assigned(FOnTotalPercentDone) then
   begin
     TotalBytesDone := TotalBytesDone + Result;
     Percent := CBigRate( TotalUncompressedSize, TotalBytesDone );
     OnTotalPercentDone( self, Percent );
   end;
  Update_CRC_buff(w, Result);
  Inc(isize, Result);
end;

{ Added 5/5/98 2.12 }
function TVCLZip.TemporaryPath: String;
var
  tempPathPStr: array [0..PATH_LEN] of char;
  {PathSize: LongInt;}
begin
  If (FTempPath = '') or (not DirExists(FTempPath)) then
   begin
     {PathSize :=} GetTempPath( SizeOf(tempPathPStr), @tempPathPStr[0] );
     Result := PCharToStr(tempPathPStr);
   end
  Else
     Result := FTempPath;
end;

procedure TVCLZip.SetExcludeList(Value: TStrings);
begin
  FExcludeList.Assign(Value);
end;

procedure TVCLZip.SetNoCompressList(Value: TStrings);
begin
  FNoCompressList.Assign(Value);
end;

procedure Register;
begin
  RegisterComponents('Samples', [TVCLZip]);
end;

end.
