unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls,ADODB, DB, AppEvnts, AdvOfficePager,
  AdvOfficePagerStylers, dbisamtb, RegExpr, Mask, AdvEdit, DBAdvEd, JvExMask,
  JvToolEdit, JvMaskEdit, JvDBControls;

type TPrefs = record
  {NAV CONNECTION}
  NavSqlServerName: string;
  NavDatabaseName: string;
  NavDataSource: string;

  {CONNECTION}
  SqlServerName: string;
  DatabaseName: string;

  {OTHER}
  fDebug: integer;
  DBUser: string;
  DBPassword: string;

  {PATH}
  aPathQuantsPodolsk: string;
  aPath2SaveAna: string;
  aPath2SaveOE: string;
  aPath2SaveKit: string;
  aPath2SaveItems: string;
  aPath2Savepod: string;

end;

const
  cConnectionString = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Data Source=%s;Initial Catalog=%s;';
type
  Tmain = class(TForm)
    SD: TSaveDialog;
    connService: TADOConnection;
    msQuery: TADOQuery;
    Command: TADOCommand;
    EdMagic: TEdit;
    Connection: TADOConnection;
    QueryReport: TADOQuery;
    ApplicationEvents: TApplicationEvents;
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePager11: TAdvOfficePage;
    Bevel2: TBevel;
    Panel2: TPanel;
    Bevel3: TBevel;
    pb: TProgressBar;
    MemoLog: TMemo;
    btAbort: TButton;
    PageStyler: TAdvOfficePagerOfficeStyler;
    checkOE: TCheckBox;
    CheckItems: TCheckBox;
    CheckKit: TCheckBox;
    CheckAna: TCheckBox;
    CheckPod: TCheckBox;
    btLoadItem: TButton;
    btLoadKit: TButton;
    btLoadPod: TButton;
    btLoadOE: TButton;
    btLoadAna: TButton;
    Bevel1: TBevel;
    aPathOE: TEdit;
    aPathItem: TEdit;
    aPathKit: TEdit;
    aPathAna: TEdit;
    aPathPod: TEdit;
    Bevel4: TBevel;
    Button6: TButton;
    lbProgressInfo: TLabel;
    lbProgressPercent: TLabel;
    AdvOfficePage1: TAdvOfficePage;
    OpenFile: TOpenDialog;
    Button2: TButton;
    Database: TDBISAMDatabase;
    UpdateTable: TDBISAMTable;
    memImportDiscount: TDBISAMTable;
    memImportDiscountDISCOUNT: TCurrencyField;
    memImportDiscountGROUP: TIntegerField;
    memImportDiscountSUBGROUP: TIntegerField;
    memImportDiscountBRAND: TIntegerField;
    memImportDiscountFIX: TIntegerField;
    Button1: TButton;
    procedure btAbortClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
//    procedure Button4Click(Sender: TObject);
    procedure btLoadOEClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure checkOEClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    fAborted: Boolean;
    aPrefs: TPrefs;
    
    procedure UploadItems(aPath2Save: string);
    procedure UploadOE(aPath2Save: string);
    procedure UploadAnalog(aPath2Save: string);
    procedure UploadKits(aPath2Save: string);
    procedure UploadQuantsPodolsk(aPath2Save: string);

    {TEST}
    procedure UploadDiscount(aPath2Save: string);

    procedure LoadIni();
    function CheckConnection(server, db: string): boolean;
    procedure FillEditPath();

  public
    procedure UpdateProgress(aPos: Integer; const aCaption: string = '');
    procedure WriteLog(Exception: string);
    function ExecuteQuery(const aSQL: string; aParams: array of Variant): Integer;
    function GetTableRecordCount(const aTableName: string; const aWHERE: string = ''): Integer;
    function SelectBrandOE(aReplBrands: TStrings; out aBrandList: TStringList): boolean;

    {Quants service}
    procedure PrepareEncodingFile(aFileName: string);
  end;

var
  main: Tmain;

implementation

uses
  IniFiles, uSysGlobal, _CSVReader, Math, adoDBUtils,uSelectBrandsForm;
{$R *.dfm}

procedure Tmain.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  WriteLog(E.Message);
end;

procedure Tmain.btAbortClick(Sender: TObject);
begin
  fAborted := True;
  WriteLog('***!!!ПРЕРВАНО ПОЛЬЗОВАТЕЛЕМ!!!***');
end;

procedure Tmain.btLoadOEClick(Sender: TObject);
begin
  if not SD.Execute then
    Exit;
  if Sender = btLoadItem then
    aPathItem.Text := SD.FileName;
  if Sender = btLoadKit then
    aPathKit.Text := SD.FileName;
  if Sender = btLoadPod then
    aPathPod.Text := SD.FileName;
  if Sender = btLoadOE then
    aPathOE.Text := SD.FileName;
  if Sender = btLoadAna then
    aPathAna.Text := SD.FileName;
end;

procedure Tmain.Button2Click(Sender: TObject);
function LoadQuery(FileName: string; modeLoad: string): string;
  var
    aPath , res: string;
    Str4File: TMemo;
    posStr: integer;
  begin
    result := '';
    try
      Str4File := TMemo.Create(nil);
      Str4File.Parent := Main;
      aPath := ExtractFilePath(Application.ExeName) + 'Query\' + FileName + '.q';
      if FileExists(aPath) then
      begin
        Str4File.Lines.LoadFromFile(aPath);

        if SameText(modeLoad,'cntQuery') then
          result := Copy(Str4File.Text, Pos('#COUNT#' , Str4File.text) + 7, Pos('#MAIN#' , Str4File.text)- 8)
        else if SameText(modeLoad,'mainQuery') then
        begin
          posStr := Pos('#PREPARE#' , Str4File.text);
          if posStr > 0 then
            result := Copy(Str4File.Text, Pos('#MAIN#' , Str4File.text) + 6, posStr - Pos('#MAIN#' , Str4File.text)-6)
          else
            result :=Copy(Str4File.Text, Pos('#MAIN#' , Str4File.text) + 6,MaxInt);
        end
        else if SameText(modeLoad,'prepareQuery') then
        begin
          posStr := Pos('#PREPARE#' , Str4File.text);
          if posStr > 0 then
            result := Copy(Str4File.Text, posStr + 9, MaxInt)
          else
            result := '';
        end;
      end;
    finally
      Str4File.Free;
    end;
  end;

  function PrepareSQL(SqlText: string): string;
  begin
    SqlText := StringReplace(SqlText, '#9', '', [rfReplaceAll]);
    SqlText := StringReplace(SqlText, #13, ' ', [rfReplaceAll]);
    SqlText := StringReplace(SqlText, #10, ' ', [rfReplaceAll]);
    SqlText := StringReplace(SqlText, #13#10, ' ', [rfReplaceAll]);
    SqlText := StringReplace(SqlText, '#DateStart#', FormatDateTime('yyyymmdd' ,Now()), [rfReplaceAll]);
    SqlText := StringReplace(SqlText, '#DateEnd#', FormatDateTime('yyyymmdd' ,Now()), [rfReplaceAll]);
    SqlText := StringReplace(SqlText, '#DB#', aPrefs.NavDataSource, [rfReplaceAll]);
    result := SqlText;
  end;

  procedure RemoveDuplicate(fileName: string);
  var
    aReader:TCSVReader;
    aReaderLine, prevLine, prevCode, prevPrice, prevSale, sale: string;
    finalVersionFile: TStringList;
    endPos, startPos, i: integer;
  begin
    aReader := TCSVReader.Create;
    finalVersionFile := TStringList.Create;

    if not FileExists(fileName) then
      exit;

    try
      aReader.Open(fileName);

      while not aReader.Eof do
      begin
        aReaderLine := aReader.ReturnLine;
        if (aReader.Fields[13] = prevCode) then
        begin
          if (aReader.Fields[2] < prevPrice) or (aReader.Fields[8] > prevSale) then
          begin
            finalVersionFile.Delete(finalVersionFile.Count-1);
            finalVersionFile.Add(aReaderLine);
          end;
        end
        else
        begin
          try
            if (aReader.Fields[8] <> '1') and (aReader.Fields[8] <> '0') and (aReader.Fields[8] <> '') then
            begin
              aReaderLine := '';
              for i := 0 to 12 do
                if i=8 then
                  aReaderLine := aReaderLine + '0;'
                else aReaderLine := aReaderLine + aReader.Fields[i] + ';';
            end;
          finally
            finalVersionFile.Add(aReaderLine);
          end;
        end;

        prevCode := aReader.Fields[13];
        prevPrice := aReader.Fields[2];
        prevSale := aReader.Fields[8];
      end;
        aReader.Close;
        //RenameFile(fileName, fileName + '_old');
        if FileExists(FileName) then
          DeleteFile(FileName);
        finalVersionFile.SaveToFile(fileName);
    finally
      aReader.Free;
      finalVersionFile.Free;
    end;
  end;

var
  i, j, cntRec, fix: integer;
  strToWrite, Field, sNo, SQL, pSQL: string;

  Dis, globalDis: string;
  gr,subgr,br: integer;

  tFile: textFile;
  iPercent, recCnt:longint;
  PrepareParamList: TStringList;
  aReader:TCSVReader;
  aLine2write:TStrings;
  LastValue,LastValueID,LastValueBrand, aReaderLine: string;
  aRes: TStringList;
begin

  if not memImportDiscount.Exists then
    memImportDiscount.CreateTable;
  memImportDiscount.Open;
  aRes := TStringList.Create;

  aReader := TCSVReader.Create;
  aReader.Open('D:\lOTUSMAO.csv');
  aReaderLine := aReader.ReturnLine;
  while not aReader.Eof do
  begin
    aReaderLine := aReader.ReturnLine;
    dis := aReader.Fields[0];
    gr := StrToIntDef(aReader.Fields[1], 0);
    subgr := StrToIntDef(aReader.Fields[2], 0);
    br := StrToIntDef(aReader.Fields[3], 0);
    fix := StrToIntDef(aReader.Fields[4],0);

    if (gr = 0)  and (subgr = 0) and (br = 0) then
      globalDis := dis;

    if memImportDiscount.Locate('GROUP;SUBGROUP;BRAND', VarArrayOf([gr,subgr,br]), []) then
    begin
      if fix > memImportDiscount.FieldByName('FIX').AsInteger then
      begin
        memImportDiscount.Edit;
        memImportDiscount.FieldByName('FIX').AsInteger := fix;
        memImportDiscount.FieldByName('DISCOUNT').Value := dis;
        memImportDiscount.Post;
      end
      else if (fix = memImportDiscount.FieldByName('FIX').AsInteger)
          and (StrToFloat(dis) > memImportDiscount.FieldByName('DISCOUNT').AsFloat) then
      begin
        memImportDiscount.Edit;
        memImportDiscount.FieldByName('DISCOUNT').Value := dis;
        memImportDiscount.Post;
      end;
    end

    else
    begin
      if (fix = 0) and (globalDis > dis) then
        Continue;

      memImportDiscount.Append;
      memImportDiscount.FieldByName('GROUP').Value := gr;
      memImportDiscount.FieldByName('SUBGROUP').Value := subgr;
      memImportDiscount.FieldByName('BRAND').Value := br;
      memImportDiscount.FieldByName('DISCOUNT').Value := dis;
      memImportDiscount.FieldByName('FIX').Value := fix;
      memImportDiscount.Post;
    end;
  end;

  memImportDiscount.First;
  while not memImportDiscount.Eof do
  begin
    aRes.Add(
      Format('%d;%d;%d;%0.2f',
      [
        memImportDiscount.FieldByName('GROUP').AsInteger,
        memImportDiscount.FieldByName('SUBGROUP').AsInteger,
        memImportDiscount.FieldByName('BRAND').AsInteger,
        memImportDiscount.FieldByName('DISCOUNT').AsCurrency
      ])
    );
    memImportDiscount.Next;
  end;

  ShowMEssage(aRes.Text);
  


 exit;
 try

      aReader := TCSVReader.Create;
      aReader.Open('e:\all_007.csv');
      aLine2write := TStringList.Create;
      LastValue := '';
      i:= 0;
      LastValueID := '';
      aReader.ReturnLine;
      while not aReader.Eof do
      begin
        aReaderLine := aReader.ReturnLine;
        if (aReader.Fields[6] = LastValue)  and (LastValueBrand = aReader.Fields[3]) then
          aLine2write.Append( LastValueID + ';' + aReader.Fields[1]+ ';' + aReader.Fields[2]+ ';' +
                              aReader.Fields[3]+ ';' + aReader.Fields[4]+ ';' + aReader.Fields[5]+ ';' +
                              aReader.Fields[6])
        else
        begin
          aLine2write.Append(aReaderLine);
          LastValueID := aReader.Fields[0];
        end;

        LastValue := aReader.Fields[6];
        LastValueBrand := aReader.Fields[3];
        inc(i);

        if i mod 1000 = 0 then
        begin
          lbProgressInfo.Caption := IntToStr(i);
          Application.ProcessMessages;
        end;

{        if i mod 1000000 = 0 then
        begin
          aLine2write.SaveToFile('E:\ana_part_' + inttostr(i div 1000000) + '.csv');
          aLine2write.Clear;
        end;}
      end;
      aLine2write.SaveToFile('E:\ana.csv');
 finally

 end;
    exit;
  if not CheckConnection(aPrefs.NavSqlServerName, aPrefs.NavDatabaseName) then
    exit;
  Command.CommandText := EdMagic.text;
  Command.Execute;

  sNo := '';
  WriteLog('***Выгрузка договоров***');
  UpdateProgress(-1, 'Сканирование NAV...');

{  if not SD.Execute then
    Exit;
  aPath := SD.FileName;
}
  AssignFile(tFile, 'E:\custagreement_' + FormatDateTime('dd.mm.yyyy_hh.mm' ,Now()) + '.csv');
  Rewrite(tFile);
  cntRec := 0;
  PrepareParamList := TStringList.Create;

  try
    try
      QueryReport.SQL.Text := 'SELECT  WebUser.[Service Prog_ User ID], ' +
		' Agreement.[No_], '+
		' Agreement.[External Agreement No_], '+
		' Agreement.[Description 2], '+
		' Agreement.[Agreement Group], '+
		' Agreement.[Currency Code], '+
		' Agreement.[Shipment Method Code], '+
		' ShipmentMethod.[Description], '+
		' Agreement.[Payment Terms Code], '+
		' PaymentTerms.[Description], '+
		' Agreement.[Customer Price Group], '+
		' CustomerPriceGroup.[Description], '+
		' Agreement.[Customer Disc_ Group], '+
		' CustomerDiscountGroup.[Description], '+
		' Agreement.[Legal Entity], '+
    ' Agreement.[Ship-to Code], '+
		' Agreement.[Allow Multi-Currency] '+
    ' FROM [Shate-M$Web User] as WebUser '+

	' left join [Shate-M$Customer Agreement] Agreement on (Agreement.[customer No_] = WebUser.[customer No_]) '+
	' left join [Shate-M$Shipment Method] ShipmentMethod on (ShipmentMethod.[Code] = Agreement.[Shipment Method Code]) '+
	' left join [Shate-M$Payment Terms] PaymentTerms on (PaymentTerms.[Code] = Agreement.[Payment Terms Code]) '+
	' left join [Shate-M$Customer Price Group] CustomerPriceGroup on (CustomerPriceGroup.[Code] = Agreement.[Customer Price Group]) '+
	' left join [Shate-M$Customer Discount Group] CustomerDiscountGroup on (CustomerDiscountGroup.[Code] = Agreement.[Customer Disc_ Group]) '+
  ' WHERE WebUser.[Service Prog_ User ID] <> :par1 and Agreement.[No_] <> :par2 and Agreement.[Active] = :Par3 and ' +
  ' (CONVERT (nchar , Agreement.[Expire Date], 112) >= :dataNow) ' ;
  {and Agreement.[Active] = :Par1}
    QueryReport.Prepared := True;
    QueryReport.Parameters[0].Value := '''''';
    QueryReport.Parameters[1].Value := '''''';
    QueryReport.Parameters[2].Value := 1;
    QueryReport.Parameters[3].Value := FormatDateTime('yyyymmdd' ,Now());
   // QueryReport.Parameters[1].Value := FormatDateTime('yy-mm-dd hh:mm:ss.ms', Now);

      QueryReport.CommandTimeout := 180;
      QueryReport.Open;
      QueryReport.DisableControls;
      QueryReport.First;

      while not QueryReport.Eof do
      begin
        for j := 0 to QueryReport.FieldCount -1 do
        begin
          Field := StringReplace(QueryReport.FieldByName(QueryReport.Fields.Fields[j].FieldName).AsString, ';', ',', [rfReplaceAll]);
          Field := StringReplace(Field, #10, '', [rfReplaceAll]);
          Field := StringReplace(Field, #13, '', [rfReplaceAll]);
          strToWrite := strToWrite + Field + ';';
        end;
        inc(cntRec);
        strToWrite := strToWrite + #13#10;
        if cntRec mod 1000 = 0  then
        begin
          UpdateProgress(-1, 'Экспорт в файл...'+ IntToStr(cntRec));
          CharToOem(pChar(strToWrite), pChar(strToWrite));
          Write(tFile, strToWrite);
          strToWrite := '';
        end;
        Field := '';
        QueryReport.Next;
      end;

      if strToWrite <> '' then
      begin
        CharToOem(pChar(strToWrite), pChar(strToWrite));
        Write(tFile, strToWrite);
        strToWrite := '';
      end;

      //      QueryReport.SaveToFile('E:\1111111.csv',pfADTG);
      QueryReport.EnableControls;

      //***DEBUG***
      if aPrefs.fDebug = 1 then
        WriteLog('START QUERY!');
      //******



    finally
      CloseFile(tFile);
//      RemoveDuplicate('E:\new.csv');//удаление дублей
      UpdateProgress(1, 'Экспорт удачно завершен');
      WriteLog('***Выгрузка товаров завершена***');
    end;

  except
    on E: Exception do
    begin
      WriteLog(E.Message);
      UpdateProgress(-1, 'Найдена ошибка! Откройте файл лога.');
    end;
  end;
end;

procedure Tmain.Button3Click(Sender: TObject);
begin

end;

{procedure Tmain.Button4Click(Sender: TObject);
begin
  UploadAnalog(aPathAna.Text);
end;  }


procedure Tmain.Button6Click(Sender: TObject);
var
  st: TstringList;
  i: integer;
  Field, strToWrite: string;
begin
  WriteLog('***Старт загрузчика***');
  {if not CheckConnection(aPrefs.NavSqlServerName, aPrefs.NavDatabaseName) then
    exit;
  Command.CommandText := EdMagic.text;
  Command.Execute;   }
  {st := TstringList.Create;

  QueryReport.SQL.Text := 'exec get_all_stock_qnt :sklad_retail_Price';
  QueryReport.Prepared := TRUE;
  QueryReport.Parameters[0].value := 'SHOP-P03';
      QueryReport.CommandTimeout := 180;
      QueryReport.Active := TRUE;
      QueryReport.DisableControls;
      QueryReport.First;
      while not QueryReport.Eof do
      begin
          for i := 0 to QueryReport.FieldCount -1 do
          begin
            Field := StringReplace(QueryReport.FieldByName(QueryReport.Fields.Fields[i].FieldName).AsString, ';', ',', [rfReplaceAll]);
            Field := StringReplace(Field, #10, '', [rfReplaceAll]);
            Field := StringReplace(Field, #13, '', [rfReplaceAll]);
            strToWrite := strToWrite + Field + ';';
          end;
          st.Append(strToWrite);
        QueryReport.Next;
      end;
      st.SaveToFile('E:\newQNT.csv');
  exit;     }
  //////

  try
    if (CheckAna.Checked) and (Length(aPathAna.Text)>3) then
      UploadAnalog(aPathAna.Text);

    if (CheckItems.Checked) and (Length(aPathItem.Text)>3) then
      UploadItems(aPathItem.Text);

    if (checkOE.Checked) and (Length(aPathOE.Text)>3) and CheckConnection(aPrefs.SqlServerName, aPrefs.DatabaseName) then
        UploadOE(aPathOE.Text);

    if (CheckKit.Checked) and (Length(aPathKit.Text)>3) and CheckConnection(aPrefs.SqlServerName, aPrefs.DatabaseName)then
        UploadKits(aPathKit.Text);

    if (CheckPod.Checked) and (Length(aPathPod.Text)>3) then
      UploadQuantsPodolsk(aPathPod.Text);

  finally
    WriteLog('***Завершено***');
  end;
end;

function Tmain.CheckConnection(server, db: string): boolean;
begin
  Connection.Connected := FALSE;
  Connection.ConnectionTimeout := 120;
  Connection.ConnectionString := Format(cConnectionString,[Server, DB]);
  try
  Connection.Connected := TRUE;
  result := TRUE;
  except
    result := FALSE;
    WriteLog('Не удалось пдключиться к ' + aPrefs.SqlServerName + ' ' + aPrefs.DatabaseName);
    MessageDlg('Проверьте подключение к БД!', mtError, [mbOK], 0);
  end;
end;

procedure Tmain.checkOEClick(Sender: TObject);
begin
  if (Sender = checkOE) then
  begin
    aPathOE.Visible := checkOE.Checked;
    btLoadOE.Visible := checkOE.Checked;
  end

  else if (Sender = CheckPod) then
  begin
    aPathPod.Visible := CheckPod.Checked;
    btLoadPod.Visible := CheckPod.Checked;
  end

  else if (Sender = CheckAna) then
  begin
    aPathAna.Visible := CheckAna.Checked;
    btLoadAna.Visible := CheckAna.Checked;
  end

  else if (Sender = CheckKit) then
  begin
    aPathKit.Visible := CheckKit.Checked;
    btLoadKit.Visible := CheckKit.Checked;
  end

  else if (Sender = CheckItems) then
  begin
    aPathItem.Visible := CheckItems.Checked;
    btLoadItem.Visible := CheckItems.Checked;
  end;

end;

function Tmain.ExecuteQuery(const aSQL: string;
  aParams: array of Variant): Integer;
var
  i: Integer;
  aQuery: TADOQuery;
begin
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.CommandTimeout := 5 * 60;
    aQuery.SQL.Text := aSQL;

    for i := Low(aParams) to High(aParams) do
      aQuery.Parameters[i].Value := aParams[i];

    Result := aQuery.ExecSQL;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;

procedure Tmain.FillEditPath;
begin
  aPathAna.Text := aPrefs.aPath2SaveAna;
  aPathOE.Text := aPrefs.aPath2SaveOE;
  aPathKit.Text := aPrefs.aPath2SaveKit;
  aPathItem.Text := aPrefs.aPath2SaveItems;
  aPathPod.Text := aPrefs.aPath2SavePod;
end;

procedure Tmain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    ini.WriteString('Path', 'aPath2SavePod', aPathPod.Text);
    ini.WriteString('Path', 'aPath2SaveOE', aPathOE.Text);
    ini.WriteString('Path', 'aPath2SaveKit', aPathKit.Text);
    ini.WriteString('Path', 'aPath2SaveItems', aPathItem.Text);
    ini.WriteString('Path', 'aPath2SaveAna', aPathAna.Text);
  finally
    ini.Free;
  end;
end;

procedure Tmain.FormCreate(Sender: TObject);
begin
  LoadIni();
  FillEditPath;
{  if not CheckConnection(aPrefs.NavSqlServerName, aPrefs.NavDatabaseName) then
  begin
    MessageDlg('Проверьте подключение к БД!', mtError, [mbOK], 0);
    exit;
  end;
  Command.CommandText := EdMagic.text;
  Command.Execute;
 }
end;

function Tmain.GetTableRecordCount(const aTableName, aWHERE: string): Integer;
var
  aQuery: TADOQuery;
begin
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := connection;//connService;
    aQuery.SQL.Text := 'SELECT COUNT(*) FROM [' + aTableName + ']';
    if aWHERE <> '' then
      aQuery.SQL.Add(' WHERE ' + aWHERE);
    aQuery.Open;
    Result := aQuery.Fields[0].AsInteger;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;

procedure Tmain.LoadIni;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    ZeroMemory(@aPrefs, SizeOf(aPrefs));

    aPrefs.NavSqlServerName := ini.ReadString('NavConnection', 'ServerName', '');
    aPrefs.NavDatabaseName := ini.ReadString('NavConnection', 'DatabaseName', '');
    aPrefs.NavDataSource := ini.ReadString('NavConnection', 'DataSource', '');

    aPrefs.SqlServerName := ini.ReadString('Connection', 'ServerName', '');
    aPrefs.DatabaseName := ini.ReadString('Connection', 'DatabaseName', '');

    aPrefs.aPathQuantsPodolsk := ini.ReadString('Path', 'aPathQuantsPodolsk', '');
    aPrefs.fDebug := ini.ReadInteger('Mode', 'DEBUG', 0);

    aPrefs.aPath2SaveAna := ini.ReadString('Path', 'aPath2SaveAna', '');
    aPrefs.aPath2SaveOE := ini.ReadString('Path', 'aPath2SaveOE', '');
    aPrefs.aPath2SaveKit := ini.ReadString('Path', 'aPath2SaveKit', '');
    aPrefs.aPath2SaveItems := ini.ReadString('Path', 'aPath2SaveItems', '');
    aPrefs.aPath2SavePod := ini.ReadString('Path', 'aPath2SavePod', '');

  finally
    ini.Free;
  end;
end;

procedure Tmain.PrepareEncodingFile(aFileName: string);
var
  str: string;
  aReader: TCSVReader;
  F: textfile;

    function DosToWin(St: string): string;
    var
      Ch: PChar;
    begin
      Ch := StrAlloc(Length(St) + 1);
      OemToAnsi(PChar(St), Ch);
      Result := Ch;
      StrDispose(Ch)
    end;

begin
  DeleteFile(aFileName + '_Old');
  aReader := TCSVReader.Create;
  //try
  AssignFile(F, aFileName + '_New');
  try
    Rewrite(F);
    aReader.Open(aFileName);
    while not aReader.Eof do
    begin
      str := DosToWin(aReader.ReturnLine);
      Writeln(F, str);
    end;
  finally
    CloseFile(F);
    aReader.Free;
    RenameFile(aFileName, aFileName + '_Old');
    RenameFile(aFileName + '_New', aFileName);
  end;

{      RenameFile(aFileName, aFileName + '_Old');
      RenameFile(aFileName + '_New', aFileName);
  except
    Result := FALSE;
    RenameFile(aFileName, aFileName + '_New_Error');
    RenameFile(aFileName + '_Old', aFileName);
    //>>В лог ошибку
  end;
 }
end;

function TMain.SelectBrandOE(aReplBrands: TStrings; out aBrandList: TStringList): boolean;
var
  q: IQuery;
  aBrandName: string;
begin
  result:= TRUE;
  q := makeIQuery(Main.connection{connService}, '', clUseClient, ctStatic);
  q.SQL := ' SELECT DISTINCT BRAND FROM CATALOG ORDER BY BRAND ';
  try
    q.Open;
    while not q.EOF do
    begin
      aBrandName := aReplBrands.Values[q.Fields[0].AsString]; //<tecdoc brand>=<service brand>
      if aBrandName = '' then
        aBrandName := q.Fields[0].AsString;
      aBrandName := AnsiUpperCase(aBrandName);

      aBrandList.Add(aBrandName);
      q.Next;
    end;
  except
    result:= FALSE;
    aBrandList.Clear;
  end;
end;



procedure Tmain.UpdateProgress(aPos: Integer; const aCaption: string);
begin
  if pb.Position <> aPos then
  begin
    pb.Position := aPos;
   // lbProgressPercent.Caption := IntToStr(aPos) + '%';

    if aCaption <> '' then
      lbProgressInfo.Caption := aCaption;

    Application.ProcessMessages;
  end
  else
    if aCaption <> '' then
    begin
      lbProgressInfo.Caption := aCaption;
      Application.ProcessMessages;
    end;
end;

procedure Tmain.UploadAnalog(aPath2Save: string);
var
  aQuery: TADOQuery;

  fOut: TextFile;
  sOut: string;

  p, aLastCrossId: Integer;
  i, iMax: Int64;
  aCode, aBrand: string;
  aErrCount: Integer;
  aWhere: string;
  fTMCodes: TStringList;
begin
  {if not SD.Execute then
    Exit;}
  UpdateProgress(0, 'Выгрузка аналогов..');
  WriteLog('***Выгрузка аналогов***');
  aErrCount := 0;
  aLastCrossId := 0;
  AssignFile(fOut, aPath2Save);
  Rewrite(fOut);

  try
    aQuery := TADOQuery.Create(nil);
    fTMCodes := TStringList.Create;
    fTMCodes.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Brands_analogs.csv');
    try
      aQuery.DisableControls;
      aQuery.Connection := Connection;
      aQuery.CursorLocation := clUseClient;
      aQuery.CursorType := ctStatic;
      aQuery.CommandTimeout := 30000;

      aWhere := ' WHERE c.[crossid] > :last_crossid and (p.[Created] <> :CreatedMan1  and  p1.[Created] <> :CreatedMan2 ) ' +
      ' and c.Cross_source in (''NAV'', ''SHATE'', ''OE SP'', '''') ' +
      ' and p.remarks in (''NAV'', ''SHATE'', ''OE SP'', '''') ' +
      ' and p1.remarks in (''NAV'', ''SHATE'', ''OE SP'', '''') ';
      if fTMCodes.Count > 0 then
        aWhere := aWhere + ' AND t.[Trade Mark Code] IN (' + fTMCodes.CommaText + ') AND t1.[Trade Mark Code] IN (' + fTMCodes.CommaText + ') ';


  {   if edBrandFilterLeft.Text <> '' then
        aWhere := aWhere + ' AND t.[Trade Mark Name] = ''' + edBrandFilterLeft.Text + '''';

      if edBrandFilterRight.Text <> '' then
        aWhere := aWhere + ' AND t1.[Trade Mark Name] = ''' + edBrandFilterRight.Text + '''';         }

       {aQuery.SQL.Text :=
         ' ;WITH ' +
          '	C as (SELECT [crossid], [partid], [Cross_source] FROM [CROSSES] where Cross_source in (''NAV'', ''SHATE'', ''OE SP'', '''') and [crossid] > :ID), ' +
          '	PART_FILTER as (select [oenum], [tmid], [partid] FROM [PART]  where remarks in (''NAV'', ''SHATE'', ''OE SP'', '''') and [Created] <> :CREATER ), ' +
          '	TM_FILTER as (SELECT * FROM [TM] WHERE [Trade Mark Code] IN (' + fTMCodes.CommaText + ')) ' +
          ' SELECT TOP 100000 ' +
          '    t.[Trade Mark Name] as BRAND, ' +
          '	   p.[oenum] as CODE, ' +
          '	   t1.[Trade Mark Name] as AN_BRAND, ' +
          '	   p1.[oenum] as AN_CODE, ' +
          '	   c.[crossid] ' +
          ' FROM C ' +
          '	INNER JOIN PART_FILTER as p ON (p.[partid] = c.[partid]) ' +
          ' INNER JOIN TM_FILTER as t ON (p.tmid = t.[Trade Mark Code]) ' +
          ' INNER JOIN PART_FILTER as p1 ON (p1.[partid] = c.[partid]) ' +
          ' INNER JOIN  TM_FILTER as t1 ON (p1.tmid = t1.[Trade Mark Code]) ' +
          ' ORDER BY C.[crossid]; ';

       }

      aQuery.SQL.Text :=
        ' SELECT TOP 100000 ' +
        '   t.[Trade Mark Name] as BRAND, p.[oenum] as CODE, t1.[Trade Mark Name] as AN_BRAND, p1.[oenum] as AN_CODE, c.[crossid] '+
        ' FROM [CROSSES] c ' +
        ' INNER JOIN [PART] p ON (p.[partid] = c.[partid]) ' +
        ' INNER JOIN [TM] t ON (p.tmid = t.[Trade Mark Code]) ' +
        ' INNER JOIN [PART] p1 ON (p1.[partid] = c.[cpartid]) ' +
        ' INNER JOIN [TM] t1 ON (p1.tmid = t1.[Trade Mark Code]) ' +
        aWhere +
        ' ORDER BY c.[crossid] ';
      aQuery.Prepared := True;

      i := 0;
      while True do
      begin
        aQuery.Parameters[0].Value := aLastCrossId;
        aQuery.Parameters[1].Value := 'KUSHEL';
        aQuery.Parameters[2].Value := 'KUSHEL';

        aQuery.Open;

        if aQuery.Eof then
          Break;

        while not aQuery.Eof do
        begin
          Inc(i);

          sOut :=
            aQuery.Fields[0].AsString + ';' +
            aQuery.Fields[1].AsString + ';' +
            aQuery.Fields[2].AsString + ';' +
            aQuery.Fields[3].AsString;
          Writeln(fOut, sOut);
          aLastCrossId := aQuery.Fields[4].AsInteger;

          aQuery.Next;
          if i mod 1000 = 0 then
            UpdateProgress(0, 'Выгрузка аналогов.. ' + IntToStr(i));
        end;
        aQuery.Close;
      end;

    finally
      fTMCodes.Free;
      aQuery.Connection.ConnectionString;
      aQuery.Free;
    end;

  finally
    UpdateProgress(0, 'OK');
    CloseFile(fOut);
    WriteLog('***Выгрузка аналогов завершена***');
  end;
end;

procedure Tmain.UploadDiscount(aPath2Save: string);

function LoadQuery(FileName: string; modeLoad: string): string;
  var
    aPath , res: string;
    Str4File: TMemo;
    posStr: integer;
  begin
    result := '';
    try
      Str4File := TMemo.Create(nil);
      Str4File.Parent := Main;
      aPath := ExtractFilePath(Application.ExeName) + 'Query\' + FileName + '.q';
      if FileExists(aPath) then
      begin
        Str4File.Lines.LoadFromFile(aPath);

        if SameText(modeLoad,'cntQuery') then
          result := Copy(Str4File.Text, Pos('#COUNT#' , Str4File.text) + 7, Pos('#MAIN#' , Str4File.text)- 8)
        else if SameText(modeLoad,'mainQuery') then
        begin
          posStr := Pos('#PREPARE#' , Str4File.text);
          if posStr > 0 then
            result := Copy(Str4File.Text, Pos('#MAIN#' , Str4File.text) + 6, posStr - Pos('#MAIN#' , Str4File.text)-6)
          else
            result :=Copy(Str4File.Text, Pos('#MAIN#' , Str4File.text) + 6,MaxInt);
        end
        else if SameText(modeLoad,'prepareQuery') then
        begin
          posStr := Pos('#PREPARE#' , Str4File.text);
          if posStr > 0 then
            result := Copy(Str4File.Text, posStr + 9, MaxInt)
          else
            result := '';
        end;
      end;
    finally
      Str4File.Free;
    end;
  end;

var
  i, j, cntRec: integer;
  strToWrite, Field, sNo, SQL, pSQL: string;
  tFile: textFile;
  iPercent, recCnt:longint;
  PrepareParamList: TStringList;
begin
  sNo := '';
  WriteLog('***Выгрузка ТЕСТ***');
  UpdateProgress(-1, 'Сканирование NAV...');
  aPath2Save := 'E:\OLOLO.csv';
  AssignFile(tFile, aPath2Save);
  Rewrite(tFile);
  cntRec := 0;
  PrepareParamList := TStringList.Create;

  try
    try
       sql :=  ' SELECT TOP 1000 [ID] ,[GROUP_ID],[SUBGROUP_ID],[BRAND_ID] '+
               ' ,[DISCOUNT],[FIX] FROM [SERVICE].[dbo].[testDis] ';
        {
        sql := ' SELECT d.DISCOUNT DISCOUNT, m.GROUP_ID, m.SUBGROUP_ID, m.BRAND_ID ' +
               ' FROM [CLIENT_INFO].[dbo].DISCOUNTS d ' +
               ' LEFT JOIN [CLIENT_INFO].[dbo].LOTUSMAP m ON (m.CAT_CODE = d.CAT_CODE) ' +
               ' WHERE (CLIENT_ID = :ID ) AND (m.ID IS NOT NULL OR d.CAT_CODE = :GLOBAL) ' +
               ' order by m.BRAND_ID,m.GROUP_ID, m.SUBGROUP_ID ';
        }

        msQuery.SQL.Text :=  sql;
        //msQuery.Prepared := TRUE;
        //msQuery.Parameters[0].Value := '0296315463';
        //msQuery.Parameters[1].Value := '#GLOBAL#';
        msQuery.Active := TRUE;
        msQuery.DisableControls;
        msQuery.First;

        while not msQuery.Eof do
        begin
          for j := 0 to msQuery.FieldCount -1 do
          begin
            Field := StringReplace(msQuery.FieldByName(msQuery.Fields.Fields[j].FieldName).AsString, ';', ',', [rfReplaceAll]);
            Field := StringReplace(Field, #10, '', [rfReplaceAll]);
            Field := StringReplace(Field, #13, '', [rfReplaceAll]);
            strToWrite := strToWrite + Field + ';';
          end;
          inc(cntRec);
          strToWrite := strToWrite + #13#10;
          if cntRec mod 1000 = 0  then
          begin
            UpdateProgress(-1, 'Экспорт в файл...'+ IntToStr(cntRec));
            CharToOem(pChar(strToWrite), pChar(strToWrite));
            Write(tFile, strToWrite);
            strToWrite := '';
          end;
          Field := '';
          msQuery.Next;
        end;

        if strToWrite <> '' then
        begin
          CharToOem(pChar(strToWrite), pChar(strToWrite));
          Write(tFile, strToWrite);
          strToWrite := '';
        end;


      msQuery.Active := FALSE;
      msQuery.EnableControls;


    finally
      CloseFile(tFile);

      UpdateProgress(1, 'Экспорт удачно завершен');
      WriteLog('***Выгрузка ТЕСТ завершена***');
    end;

  except
    on E: Exception do
    begin
      WriteLog(E.Message);
      UpdateProgress(-1, 'Найдена ошибка! Откройте файл лога.');
    end;
  end;

end;

procedure Tmain.UploadItems(aPath2Save: string);

  function LoadQuery(FileName: string; modeLoad: string): string;
  var
    aPath , res: string;
    Str4File: TMemo;
    posStr: integer;
  begin
    result := '';
    try
      Str4File := TMemo.Create(nil);
      Str4File.Parent := Main;
      aPath := ExtractFilePath(Application.ExeName) + 'Query\' + FileName + '.q';
      if FileExists(aPath) then
      begin
        Str4File.Lines.LoadFromFile(aPath);

        if SameText(modeLoad,'cntQuery') then
          result := Copy(Str4File.Text, Pos('#COUNT#' , Str4File.text) + 7, Pos('#MAIN#' , Str4File.text)- 8)
        else if SameText(modeLoad,'mainQuery') then
        begin
          posStr := Pos('#PREPARE#' , Str4File.text);
          if posStr > 0 then
            result := Copy(Str4File.Text, Pos('#MAIN#' , Str4File.text) + 6, posStr - Pos('#MAIN#' , Str4File.text)-6)
          else
            result :=Copy(Str4File.Text, Pos('#MAIN#' , Str4File.text) + 6,MaxInt);
        end
        else if SameText(modeLoad,'prepareQuery') then
        begin
          posStr := Pos('#PREPARE#' , Str4File.text);
          if posStr > 0 then
            result := Copy(Str4File.Text, posStr + 9, MaxInt)
          else
            result := '';
        end;
      end;
    finally
      Str4File.Free;
    end;
  end;

  function PrepareSQL(SqlText: string): string;
  begin
    SqlText := StringReplace(SqlText, '#9', '', [rfReplaceAll]);
    SqlText := StringReplace(SqlText, #13, ' ', [rfReplaceAll]);
    SqlText := StringReplace(SqlText, #10, ' ', [rfReplaceAll]);
    SqlText := StringReplace(SqlText, #13#10, ' ', [rfReplaceAll]);
    SqlText := StringReplace(SqlText, '#DateStart#', FormatDateTime('yyyymmdd' ,Now()), [rfReplaceAll]);
    SqlText := StringReplace(SqlText, '#DateEnd#', FormatDateTime('yyyymmdd' ,Now()), [rfReplaceAll]);
    SqlText := StringReplace(SqlText, '#DB#', aPrefs.NavDataSource, [rfReplaceAll]);
    result := SqlText;
  end;

  procedure RemoveDuplicate(fileName: string);
  var
    aReader:TCSVReader;
    aReaderLine, prevLine, prevCode, prevPrice, prevSale, sale: string;
    finalVersionFile: TStringList;
    endPos, startPos, i: integer;
  begin
    aReader := TCSVReader.Create;
    finalVersionFile := TStringList.Create;

    if not FileExists(fileName) then
      exit;

    try
      aReader.Open(fileName);

      while not aReader.Eof do
      begin
        aReaderLine := aReader.ReturnLine;
        if (aReader.Fields[13] = prevCode) then
        begin
          if (aReader.Fields[2] < prevPrice) or (aReader.Fields[8] > prevSale) then
          begin
            finalVersionFile.Delete(finalVersionFile.Count-1);
            finalVersionFile.Add(aReaderLine);
          end;
        end
        else
        begin
          try
            if (aReader.Fields[8] <> '1') and (aReader.Fields[8] <> '0') and (aReader.Fields[8] <> '') then
            begin
              aReaderLine := '';
              for i := 0 to 12 do
                if i=8 then
                  aReaderLine := aReaderLine + '0;'
                else aReaderLine := aReaderLine + aReader.Fields[i] + ';';
            end;
          finally
            finalVersionFile.Add(aReaderLine);
          end;
        end;

        prevCode := aReader.Fields[13];
        prevPrice := aReader.Fields[2];
        prevSale := aReader.Fields[8];
      end;
        aReader.Close;
        //RenameFile(fileName, fileName + '_old');
        if FileExists(FileName) then
          DeleteFile(FileName);
        finalVersionFile.SaveToFile(fileName);
    finally
      aReader.Free;
      finalVersionFile.Free;
    end;
  end;

var
  i, j, cntRec: integer;
  strToWrite, Field, sNo, SQL, pSQL: string;
  tFile: textFile;
  iPercent, recCnt:longint;
  PrepareParamList: TStringList;
begin
  sNo := '';
  WriteLog('***Выгрузка товаров***');
  UpdateProgress(-1, 'Сканирование NAV...');

{  if not SD.Execute then
    Exit;
  aPath := SD.FileName;
}
  AssignFile(tFile, aPath2Save);
  Rewrite(tFile);
  cntRec := 0;
  PrepareParamList := TStringList.Create;

  SQL := PrepareSQL(LoadQuery('ITEMS', 'mainQuery'));
  pSQL := PrepareSQL(LoadQuery('ITEMS', 'prepareQuery'));

  try
    try
      QueryReport.SQL.Text := pSQL;
      QueryReport.CommandTimeout := 180;
      QueryReport.Active := TRUE;
      QueryReport.DisableControls;
      QueryReport.First;
      while not QueryReport.Eof do
      begin
        PrepareParamList.Add(QueryReport.Fields.FieldByNumber(1).AsString);
        QueryReport.Next;
      end;
      QueryReport.Active := FALSE;
      QueryReport.EnableControls;

      //***DEBUG***
      if aPrefs.fDebug = 1 then
        WriteLog('START QUERY!');
      //******

      for i := 0 to PrepareParamList.Count - 1 do
      begin
        QueryReport.SQL.Text :=  StringReplace(SQL, '#No#', PrepareParamList.Strings[i], [rfReplaceAll]);
        QueryReport.Active := TRUE;
        QueryReport.DisableControls;
        QueryReport.First;

        while not QueryReport.Eof do
        begin
          for j := 0 to QueryReport.FieldCount -1 do
          begin
            Field := StringReplace(QueryReport.FieldByName(QueryReport.Fields.Fields[j].FieldName).AsString, ';', ',', [rfReplaceAll]);
            Field := StringReplace(Field, #10, '', [rfReplaceAll]);
            Field := StringReplace(Field, #13, '', [rfReplaceAll]);
            strToWrite := strToWrite + Field + ';';
          end;
          inc(cntRec);
          strToWrite := strToWrite + #13#10;
          if cntRec mod 1000 = 0  then
          begin
            UpdateProgress(-1, 'Экспорт в файл...'+ IntToStr(cntRec));
            CharToOem(pChar(strToWrite), pChar(strToWrite));
            Write(tFile, strToWrite);
            strToWrite := '';
          end;
          Field := '';
          QueryReport.Next;
        end;

        if strToWrite <> '' then
        begin
          CharToOem(pChar(strToWrite), pChar(strToWrite));
          Write(tFile, strToWrite);
          strToWrite := '';
        end;
      end;//FOR

      QueryReport.Active := FALSE;
      QueryReport.EnableControls;


    finally
      CloseFile(tFile);
      RemoveDuplicate(aPath2Save);//удаление дублей
      UpdateProgress(1, 'Экспорт удачно завершен');
      WriteLog('***Выгрузка товаров завершена***');
    end;

  except
    on E: Exception do
    begin
      WriteLog(E.Message);
      UpdateProgress(-1, 'Найдена ошибка! Откройте файл лога.');
    end;
  end;
end;

procedure Tmain.UploadKits(aPath2Save: string);
var
  f: TextFile;
  q: IQuery;
  i, iMax: Cardinal;
  strToWrite: string;
begin
{  if not SD.Execute then
    Exit;
 }
  fAborted := False;
  UpdateProgress(0, 'Выгрузка комплектов...');
  WriteLog('***Выгрузка комплектов***');
  iMax := GetTableRecordCount('KIT_LINKS');
  i := 0;

  AssignFile(f, aPath2Save);
  Rewrite(f);
  try
    q := makeIQuery(connection{connService});
    q.Query.CursorLocation := clUseClient;
    q.Query.CursorType := ctStatic;
    q.SQL :=
      ' SELECT ' +
      '   kp.CODE + ''_'' + kp.BRAND CODE_BRAND, ' +
      '   kd.CODE + ''_'' + kd.BRAND CODE_BRAND_CHILD, ' +
      '   kl.QUANTITY ' +
      ' FROM [KIT_LINKS] kl ' +
      ' LEFT JOIN [KIT_CODES] kp ON (kp.ID = kl.PARENT_ID) ' +
      ' LEFT JOIN [KIT_CODES] kd ON (kd.ID = kl.CHILD_ID) ' +
      ' ORDER BY ' +
      '   kp.BRAND, kp.CODE, kl.SORT ';
    q.Open;
    q.Query.DisableControls;
    while not q.EOF do
    begin
      strToWrite := strToWrite + q.Fields[0].AsString + ';' + q.Fields[1].AsString + ';' + q.Fields[2].AsString + #13#10;
      Inc(i);
      if i mod 1000 = 0 then
      begin
        UpdateProgress(i * 100 div iMax, 'Выгрузка комлектов для сервисной... ' + IntToStr(i));
        Write(f, strToWrite);
        strToWrite := '';
        if fAborted then
          Break;
      end;
      q.Next;
    end;
    if strToWrite <> '' then
      Write(f, strToWrite);
  finally
    CloseFile(f);
    UpdateProgress(0, ' ');
    WriteLog('***Выгрузка комплектов завершена***');
  end;
end;

procedure Tmain.UploadOE(aPath2Save: string);
var
  i: Integer;
  sl: TStrings;
  q: IQuery;
  aDestFileName: string;
  f: TextFile;
  aBrands: TStringList;
  aBrandsWhere, aWhere: string;
  allBrands: Boolean;
begin
  WriteLog('***Выгрузка ОЕ***');
  if not FileExists(ExtractFilePath(ParamStr(0)) + 'BrandRplFull.txt') then
    raise Exception.Create('Не найден файл замены брендов для сервисной "BrandRplFull.txt"');

  {*******ЕСЛИ СЕЛЕКТИТЬ НЕ ВСЕ БРЕНДЫ*****}
{  aBrandsWhere := '''#NULL#''';
  sl := makeStrings;
  aBrands := makeStrings;
  try
    //<tecdoc brand>;<service brand>
    sl.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'BrandRplFull.txt');
    sl.Text := StringReplace(sl.Text, ';', '=', [rfReplaceAll]);

    if not TSelectBrandsForm.Execute(sl, aBrands, allBrands) then
      Exit;

     if not SelectBrandOE(sl, aBrands) then
       exit;
       raise Exception.Create('Не отработал SELECT брендов!!! ');

    for i := 0 to aBrands.Count - 1 do
      aBrandsWhere := aBrandsWhere + ',''' + StringReplace(aBrands[i], '''', '''''', [rfReplaceAll]) + '''';
  finally
    sl.Free;
    aBrands.Free;
  end;

  if not SD.Execute then
    Exit;
  aDestFileName := SD.FileName;
}

  UpdateProgress(0, 'очистка таблицы... ');
  try
    ExecuteQuery('DROP TABLE OE_SP', []);
  except
    //таблицы может не быть
  end;

  UpdateProgress(0, 'построение таблицы для выгрузки... ');
  ExecuteQuery(
    ' select ' +
    '   c.CODE, ' +
    '   c.BRAND, ' +
    '   o.CODE OE_CODE ' +
    ' into OE_SP ' +
    ' from OE_CODES o ' +
    ' INNER join dbo.OE_ART_LINK al on (al.OE_ID = o.ID) ' +
    ' INNER join dbo.CATALOG c on (c.CAT_ID = al.CAT_ID) ' +
    ' ORDER BY c.BRAND, c.CODE ',
    []
  );

  sl := makeStrings;
  //<tecdoc brand>;<service brand>
  sl.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'BrandRplFull.txt');
  sl.Text := StringReplace(sl.Text, ';', '=', [rfReplaceAll]);

  for i := 0 to sl.Count - 1 do
  begin
    UpdateProgress(0, 'переименование брендов... ' + sl[i]);
    ExecuteQuery(
      ' update OE_SP set brand = :brand_SP where brand = :brand_TD ',
      [sl.ValueFromIndex[i], sl.Names[i]]
    );
  end;
  sl.Free;
  UpdateProgress(0, ' ');

  UpdateProgress(0, 'получение данных... ');
  AssignFile(f, aPath2Save);
  Rewrite(f);
  try
 {   if allBrands then
      aWhere := ' '
    else
      aWhere := ' where o.BRAND in (' + aBrandsWhere + ') ';   }

    q := makeIQuery(connection{connService}, '', clUseClient, ctStatic);
    q.SQL :=
      ' select ' +
      '   o.CODE + ''_'' + o.BRAND CODE_BRAND, ' +
      '   o.OE_CODE ' +
      ' from OE_SP o ' +
   //   aWhere +
      ' order by o.BRAND, o.code ';

//    MemoLog.Lines.Add(q.SQL);

    i := 0;
    q.Open;
    q.Query.DisableControls;
    while not q.EOF do
    begin
      Writeln(f, q.Fields[0].AsString + ';' + q.Fields[1].AsString);
      q.Next;

      Inc(i);
      if i mod 500 = 0 then
        UpdateProgress(0, 'Выгрузка в файл [' + IntToStr(q.Query.RecordCount) + ']... ' + IntToStr(i));
      if fAborted then
        Break;  
    end;
  finally
    CloseFile(f);
    WriteLog('***Выгрузка ОЕ завершена***');
  end;
end;

procedure Tmain.UploadQuantsPodolsk(aPath2Save: string);
begin
  WriteLog('***Выгрузка цен для Подольска***');
  try
    CopyFile(pChar(aPrefs.aPathQuantsPodolsk), pChar(aPath2Save), TRUE);
  finally
    WriteLog('***Выгрузка цен для Подольска завершена***');
  end;
end;

procedure Tmain.WriteLog(Exception: string);
var
  FileLog: TextFile;
  fName: string;
begin
  fName := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName)) + 'Error.inf';
  AssignFile(FileLog, fName);
  if FileExists(fName) then
    Append(FileLog)
  else
    Rewrite(FileLog);
  Writeln(FileLog,DateTimeToStr(Now()) + ' >> ' +  Exception + ';');
  MemoLog.Lines.Add(DateTimeToStr(Now()) + ' >> ' +  Exception + ';');
  CloseFile(FileLog);
end;

end.
