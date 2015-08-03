{ ********************************************************************************** }
{                                                                                    }
{ 	 COPYRIGHT 1997 Kevin Boylan                                                    }
{     Source File: Deflate.pas                                                       }
{     Description: VCLZip component - native Delphi zip component.                   }
{     Date:        March 1997                                                        }
{     Author:      Kevin Boylan, CIS: boylank                                        }
{                                Internet: boylank@compuserve.com                    }
{                                                                                    }
{ ********************************************************************************** }

{ $Log:  D:\Util\GP-Version\Archives\Components\VCLZip\Component Files\kpDFLT.UFV 
{
{   Rev 1.1    7/9/98 6:47:18 PM  Supervisor
{ Version 2.13
{ 
{ 1) New property ResetArchiveBitOnZip causes each file's 
{ archive bit to be turned  off after being zipped.
{ 
{ 2) New Property SkipIfArchiveBitNotSet causes files 
{ who's archive bit is not set to be skipped during zipping 
{ operations.
{ 
{ 3) A few modifications were made to allow more 
{ compatibility with BCB 1.
{ 
{ 4) Modified how directory information is used when 
{ comparing filenames to be unzipped.  Now it is always 
{ used.
}
{
{   Rev 1.2    Sun 25 Jan 1998   21:05:51  KP    Version: 2.00
}
{
{   Rev 1.1    Sun 25 Jan 1998   20:32:07  KP
{ Modified an Assert which was broken from 
{ changing array access to pointers for D1.
}

{$P-} { turn off open parameters }
{$Q-} { turn off overflow checking }
{$R-} { turn off range checking }
{$B-} { turn off complete boolean eval } { 12/24/98  2.17 }

function TVCLZip.Deflate: LongInt;

type
  {read_buf_proc = file_read which is in zipup}
  read_buf_proc = function( w: PByte; size: usigned ): LongInt of Object;
	PosPtr = ^WPos;
  uchp = ^uch;
  configtype = packed Record
  	good_length:	WORD;
     max_lazy:		WORD;
     nice_length:	WORD;
     max_chain:		WORD;
  end;
  { TREES }
  extra_lbitsPtr = ^extra_lbits_type;
  extra_dbitsPtr = ^extra_dbits_type;
  extra_blbitsPtr = ^extra_blbits_type;
  extra_lbits_type = array[0..LENGTH_CODES-1] of Integer;
  extra_dbits_type = array[0..D_CODES-1] of Integer;
  extra_blbits_type = array[0..BL_CODES-1] of Integer;
  tree_desc = packed Record
     dyn_tree:      ct_dataArrayPtr;
     static_tree:   ct_dataArrayPtr;
     extra_bits:    IntegerArrayPtr;
     extra_base:    Integer;
     elems:         Integer;
     max_length:    Integer;
     max_code:      Integer;
  end;
  dyn_ltreePtr = ^dyn_ltree_type;
  dyn_dtreePtr = ^dyn_dtree_type;
  bl_treePtr = ^bl_tree_type;
  dyn_ltree_type = array [0..HEAP_SIZE-1] of ct_data;
  dyn_dtree_type = array [0..(2*D_CODES)] of ct_data;
  bl_tree_type = array [0..(2*BL_CODES)] of ct_data;

var
  read_buf:      read_buf_proc;
  window_size: 	LongInt;
  block_start:	LongInt;
  sliding:			short_int;
  ins_h:			usigned;
  prev_length:	usigned;
  strstart:		usigned;
  match_start:	usigned;
  endfile:			Boolean;
  lookahead:		usigned;
  max_chain_length: usigned;
  max_lazy_match: usigned;
  good_match:		usigned;
{$IFNDEF FULL_SEARCH}
  nice_match:		Integer;
{$ENDIF}
  { TREES }
  dyn_ltree:     dyn_ltree_type;
  dyn_dtree:     dyn_dtree_type;
  bl_tree:       bl_tree_type;
  l_desc:        tree_desc;
  d_desc:        tree_desc;
  bl_desc:       tree_desc;
  heap:          array [0..2*L_CODES] of Integer;
  heap_len:      Integer;
  heap_max:      Integer;
  depth:         array [0..2*L_CODES] of Byte;
  last_lit:      usigned;
  last_dist:     usigned;
  last_flags:    usigned;
  flags:         Byte;
  flag_bit:      Byte;
  opt_len:       LongInt;
  static_len:    LongInt;
  compressed_len: LongInt;
  input_len:     LongInt;
  file_type:     ^WORD;
  file_method:   ^WORD;
  { BITS }
  bi_buf:        WORD;
  bi_valid:      Integer;
  file_outbuf:   array [0..1024-1] of char;
  {$IFOPT D+}
  bits_sent:     LongInt;   { bit length of the compressed data }
 {$ENDIF}
  out_buf: ByteArrayPtr;
  out_offset: usigned;
  out_size: usigned;

const
  configuration_table: array[0..9] of configtype =
  (
  	(good_length:    0; max_lazy:    0; nice_length:    0; max_chain:    0),
  	(good_length:    4; max_lazy:    4; nice_length:    8; max_chain:    4),
  	(good_length:    4; max_lazy:    5; nice_length:   16; max_chain:    8),
  	(good_length:    4; max_lazy:    6; nice_length:   32; max_chain:   32),
  	(good_length:    4; max_lazy:    4; nice_length:   16; max_chain:   16),
  	(good_length:    8; max_lazy:   16; nice_length:   32; max_chain:   32),
  	(good_length:    8; max_lazy:   16; nice_length:  128; max_chain:  128),
  	(good_length:    8; max_lazy:   32; nice_length:  128; max_chain:  256),
  	(good_length:   32; max_lazy:  128; nice_length:  258; max_chain: 1024),
  	(good_length:   32; max_lazy:  258; nice_length:  258; max_chain: 4096)
  );

  { TREES }
  extra_lbits: extra_lbits_type =
  (  0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0 );

  extra_dbits: extra_dbits_type =
  (  0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13 );

  extra_blbits: extra_blbits_type =
  (  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,7 );

  bl_order: array [0..BL_CODES-1] of Byte =
  (  16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15 );


  {$I kpBITS.PAS }
  {$I kpTREES.PAS}

procedure UPDATE_HASH( var h: usigned; c: usigned );
begin
  h := ((h shl H_SHIFT) xor c) and HASH_MASK;
end;

procedure INSERT_STRING( s: usigned; var match_head: IPos );
begin
  UPDATE_HASH( ins_h, window^[s+MIN_MATCH-1] );
  prev^[s and WMASK] := head^[ins_h];
  match_head := head^[ins_h];
  head^[ins_h] := s;
end;

procedure fill_window;
var
  n, m:    usigned;
  more:    usigned;
  {$IFNDEF WIN32}
  wsise:   LongInt;
  {$ENDIF}
begin
  Repeat
     more := usigned(U_LONG(window_size) - U_LONG(lookahead) - U_LONG(strstart));
     If (more = usigned(EOFile)) then
        Dec(more)
     Else If (strstart >= WSIZE+MAX_DIST) and (sliding <> 0) then
      begin
        {$IFNDEF WIN16}
        MoveMemory( @window^[0], @window^[WSIZE], WSIZE );
        {$ELSE}
        wsise := WSIZE;
        HMemCpy( @window^[0], @window^[wsise], WSIZE );
        {$ENDIF}
        Dec(match_start,WSIZE);
        Dec(strstart,WSIZE);
        Dec(block_start,WSIZE);
        for n := 0 to HASH_SIZE-1 do
          begin
           m := head^[n];
           If (m >= WSIZE) then
              head^[n] := m-WSIZE
           Else
              head^[n] := 0;
          end; { for n := 0 to HASH_SIZE-1 }
        for n := 0 to WSIZE-1 do
         begin
           m := prev^[n];
           If (m >= WSIZE) then
              prev^[n] := m-WSIZE
           Else
              prev^[n] := 0;
         end;  { for n := 0 to WSIZE-1 }
        Inc(more,WSIZE);
      end;  { Else If (strstart >= WSIZE+MAXDIST) and (sliding <> 0) }
     If (endfile) then
        exit;

     {$IFDEF ASSERTS}
     Assert( more >= 2, 'more < 2' );
     {$ENDIF}

     If (strstart+lookahead) > (2*WSIZE-1) then
        ShowMessage('out of range for window! - ' + IFileName);
     n := read_buf( @window^[strstart+lookahead], more );
     if (n = 0) or (n = usigned(EOFile)) then
        endfile := True
     Else
        Inc(lookahead,n);
  Until (lookahead >= MIN_LOOKAHEAD) or (endfile);
end;

procedure lm_init;
var
  j: usigned;
  hsize: LongInt;
begin
  sliding := 0;
  If (window_size = 0) then
   begin
     sliding := 1;
     window_size := 2 * WSIZE;
   end; { If (window_size = 0) }

  hsize := HASH_SIZE-1;
  head^[hsize] := 0;
  FillMemory( @head^[0], (HASH_SIZE-1)*SizeOf(head^[0]), 0 );

  max_lazy_match := configuration_table[FPackLevel].max_lazy;
  good_match := configuration_table[FPackLevel].good_length;
{$IFNDEF FULL_SEARCH}
  nice_match := configuration_table[FPackLevel].nice_length;
{$ENDIF}
  max_chain_length := configuration_table[FPackLevel].max_chain;
  If (FPackLevel <= 2) then
     tmpfile_info.general_purpose_bit_flag := tmpfile_info.general_purpose_bit_flag or FAST
  Else If (FPackLevel >= 8) then
     tmpfile_info.general_purpose_bit_flag := tmpfile_info.general_purpose_bit_flag or SLOW;
  strstart := 0;
  block_start := 0;
  j := WSIZE;
 { if (SizeOf(Integer) > 2) then
     j := j shl 1;  }
  lookahead := read_buf( @window^[0], j );
  If (lookahead = 0) or (lookahead = usigned(EOFile)) then
   begin
     endfile := True;
     lookahead := 0;
     exit;
   end;  { If (lookahead = 0) or (lookahead = EOFile) }
  endfile := False;
  If (lookahead < MIN_LOOKAHEAD) then
     fill_window;
  ins_h := 0;
  for j := 0 to MIN_MATCH-2 do
     UPDATE_HASH( ins_h, window^[j] );
end;

function longest_match( cur_match: IPos ): Integer;
var
  chain_length:     usigned;
  scan:             PWord;
  match:            PWord;
  len:              usigned;
  best_len:         usigned;
  limit:            IPos;
  strend:           PByte;
  scan_start:       PWord;
  scan_end:         PWord;
  DoneLooping:      Boolean;
  i:                usigned;
  {scanptr:          PWord;}
  {matchptr:         PWord;}

begin
  chain_length := max_chain_length;
  scan := PWord(@window^[strstart]);
  best_len := prev_length;
  if strstart > IPos(MAX_DIST) then
     limit := strstart - IPos(MAX_DIST)
  Else
     limit := 0;

  strend := @window^[strstart+MAX_MATCH-1];
  scan_start := scan;
  scan_end := PWord(@window^[strstart+best_len-1]);

  If (prev_length >= good_match) then
     chain_length := chain_length shr 2;

  {$IFDEF ASSERTS}
  Assert( strstart <= window_size - MIN_LOOKAHEAD, 'Insufficient lookahead');
  {$ENDIF}

  Repeat
     {$IFDEF ASSERTS}
     Assert( cur_match < strstart, 'No Future' );
     {$ENDIF}
     match := PWord(@window^[cur_match]);
     If (PWord(LongInt(match)+best_len-1)^ <> scan_end^    ) or
        (match^ <> scan_start^) then
      begin
        cur_match := prev^[cur_match and WMASK];
        If (cur_match > limit) then
           Dec(chain_length);
        continue;
      end;

     Inc(PByte(scan));
     Inc(PByte(match));

     DoneLooping := False;
     Repeat
        for i := 1 to 4 do
         begin
           Inc(scan);
           Inc(match);
           If (scan^ <> match^) then
            begin
              DoneLooping := True;
              break;
            end;
         end;
     Until (DoneLooping) or (LongInt(scan) >= LongInt(strend));

     {$IFDEF ASSERTS}
     Assert( LongInt(scan) <= LongInt(@window^[window_size-1]), 'Wild Scan' );
     {$ENDIF}

     If (PByte(scan)^  = PByte(match)^) then
        Inc(PByte(scan));

     len := (MAX_MATCH-1) - Word(LongInt(strend)-LongInt(scan));
     scan := PWord(LongInt(strend) - (MAX_MATCH-1));

     If (len > best_len) then
      begin
        match_start := cur_match;
        best_len := len;
        If (len >= nice_match) then
           break;
        scan_end := PWord(LongInt(scan)+best_len-1);
      end;

     cur_match := prev^[cur_match and WMASK];
     If (cur_match > limit) then
        Dec(chain_length);

  Until (cur_match <= limit) or (chain_length = 0);

  Result := best_len;

end;

{$IFOPT D+}
{$IFNDEF WIN16}
procedure check_match( start, match: IPos; mlength: Integer );
begin
  If ( not BlockCompare( window^[match], window^[start], mlength ) ) then
     raise EInvalidMatch.CreateFmt('Start: %d, Match: %d, Length: %d', [Start,Match,mlength]);
end;
{$ENDIF}
{$ENDIF}

function FLUSH_BLOCK( eofblock: Integer ): LongInt;
begin
  {flush_the_block is in trees.pas}
  If (block_start >= 0) then
     Result := flush_the_block( @window^[block_start], strstart-block_start, eofblock )
  Else
     Result := flush_the_block( nil, strstart-block_start, eofblock );
end;

procedure init_desc;
begin
  With l_desc do
   begin
     dyn_tree := ct_dataArrayPtr(@dyn_ltree);        { added typecast 5/18/98  2.13 }
     static_tree := ct_dataArrayPtr(@static_ltree);  { added typecast 5/18/98  2.13 }
     extra_bits := IntegerArrayPtr(@extra_lbits);    { added typecast 5/18/98  2.13 }
     extra_base := LITERALS+1;
     elems := L_CODES;
     max_length := MAX_ZBITS;
     max_code := 0;
   end;
  With d_desc do
   begin
     dyn_tree := ct_dataArrayPtr(@dyn_dtree);        { added typecast 5/18/98  2.13 }
     static_tree := ct_dataArrayPtr(@static_dtree);  { added typecast 5/18/98  2.13 }
     extra_bits := IntegerArrayPtr(@extra_dbits);    { added typecast 5/18/98  2.13 }
     extra_base := 0;
     elems := D_CODES;
     max_length := MAX_ZBITS;
     max_code := 0;
   end;
  With bl_desc do
   begin
     dyn_tree := ct_dataArrayPtr(@bl_tree);          { added typecast 5/18/98  2.13 }
     static_tree := nil;
     extra_bits := IntegerArrayPtr(@extra_blbits);   { added typecast 5/18/98  2.13 }
     extra_base := 0;
     elems := BL_CODES;
     max_length := MAX_BL_BITS;
     max_code := 0;
   end;
end;

function deflate_fast: LongInt;
var
  hash_head:     IPos;
  flush:         Boolean;
  match_length:  usigned;
begin
  match_length := 0;
  prev_length := MIN_MATCH - 1;

  while (lookahead <> 0) do
   begin
     {If (lookahead >= MIN_MATCH) then}
        INSERT_STRING( strstart, hash_head );
     If (hash_head <> 0) and (strstart - hash_head <= MAX_DIST) then
      begin
        match_length := longest_match( hash_head );
        If (match_length > lookahead) then
           match_length := lookahead;
      end; { If (hash_head <> 0) and (strstart - hash_head <= MAX_DIST) }
     If (match_length >= MIN_MATCH) then
      begin
        {$IFOPT D+}
        {$IFNDEF WIN16}
        check_match( strstart, match_start, match_length );
        {$ENDIF}
        {$ENDIF}
        {ct_tally is in trees}
        flush := ct_tally( strstart-match_start, match_length-MIN_MATCH );
        Dec(lookahead,match_length);
        If (match_length <= max_lazy_match) then
         begin
           Dec(match_length);
           Repeat
              Inc(strstart);
              INSERT_STRING( strstart, hash_head );
              Dec(match_length);
           Until (match_length = 0);
           Inc(strstart);
         end { If (match_length <= max_insert_length) }
        Else
         begin
           Inc(strstart,match_length);
           match_length := 0;
           ins_h := window^[strstart];
           UPDATE_HASH( ins_h, window^[strstart+1] );
         end; { If (match_length <= max_insert_length) Else }
      end  { If (match_length >= MIN_MATCH) }
     Else
      begin
        flush := ct_tally( 0, window^[strstart]);
        Dec(lookahead);
        Inc(strstart);
      end; { If (match_length >= MIN_MATCH) Else }
     If (flush) then
      begin
        FLUSH_BLOCK(0);
        block_start := strstart;
      end;
     If (lookahead < MIN_LOOKAHEAD) then
        fill_window;
   end; { while (lookahead <> 0) }

  Result := FLUSH_BLOCK(1);
end;  { function deflate_fast }

{=========================  Main Deflate Procedure  =================================}

var
  hash_head:        IPos;
  prev_match:       IPos;
  flush:            Boolean;
  match_available:  Integer;
  match_length:     usigned;
  {max_Insert:       LongInt;}
begin
  window_size := 0;
  init_desc;
  bi_init;
  ct_init;
  lm_init;
  match_available := 0;
  match_length := MIN_MATCH-1;
  If (FPackLevel <= 3) then
   begin
     Result := deflate_fast;
     exit;
   end;  { If (FPackLevel <= 3) }

  While (lookahead <> 0) do
   begin
     {If (lookahead >= MIN_MATCH) then}
        INSERT_STRING( strstart, hash_head );
     prev_length := match_length;
     prev_match := match_start;
     match_length := MIN_MATCH - 1;

     If (hash_head <> 0) and (prev_length < max_lazy_match) and
        (strstart - hash_head <= MAX_DIST) then
      begin
        match_length := longest_match( hash_head );
        If (match_length > lookahead) then
           match_length := lookahead;
        If (match_length = MIN_MATCH) and (strstart-match_start > TOO_FAR) then
           match_length := MIN_MATCH-1;
      end;  { If (hash_head <> 0) and (prev_length < max_lazy_match) and
                 (strstart - hash_head <= MAX_DIST) }
     If (prev_length >= MIN_MATCH) and (match_length <= prev_length) then
      begin
        {$IFOPT D+}
        {$IFNDEF WIN16}
        check_match( strstart-1, prev_match, prev_length );
        {$ENDIF}
        {$ENDIF}
        {max_Insert := strstart + lookahead - MIN_MATCH;}
        flush := ct_tally(strstart-1-prev_match, prev_length - MIN_MATCH);
        Dec(lookahead, prev_length-1);
        Dec(prev_length,2);
        Repeat
           Inc(strstart);
           {If (strstart >= max_Insert) then}
              INSERT_STRING( strstart, hash_head );
           Dec(prev_length);
        Until (prev_length = 0);
        match_available := 0;
        match_length := MIN_MATCH-1;
        Inc(strstart);
        If (flush) then
         begin
           FLUSH_BLOCK(0);
           block_start := strstart;
         end; { If (flush <> 0) }
      end  { If (prev_length >= MIN_MATCH) and (match_length <= prev_length) }
     Else If (match_available <> 0) then
      begin
        If (ct_tally( 0, window^[strstart-1])) then
         begin
           FLUSH_BLOCK(0);
           block_start := strstart;
         end;  { If (ct_tally( 0, window[strstart-1]) }
        Inc(strstart);
        Dec(lookahead);
      end { If (prev_length >= MIN_MATCH) and (match_length <= prev_length) }
     Else
      begin
        match_available := 1;
        Inc(strstart);
        Dec(lookahead);
      end;  { If (prev_length >= MIN_MATCH) and (match_length <= prev_length) Else }

     {$IFDEF ASSERTS}
     Assert( (strstart <= isize) and (lookahead <= isize), 'a bit too far - deflate');
     {$ENDIF}

     If (lookahead < MIN_LOOKAHEAD) then
        fill_window;
   end; { While (lookahead <> 0) }
  If (match_available <> 0) then
     {flush :=} ct_tally( 0, window^[strstart-1] );
  Result := FLUSH_BLOCK(1);
end;







