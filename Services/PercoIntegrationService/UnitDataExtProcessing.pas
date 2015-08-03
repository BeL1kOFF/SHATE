unit UnitDataExtProcessing;

interface

 uses
  Classes, Windows, SysUtils, iniFiles, IBDatabase, IBCustomDataSet, IBStoredProc;
  type

    TPercoExtDataProcessor = Class;

    TPercoObjectsManager = Class
      CataloguesList: TStringList;   //, ActionsList
      RootProc: TPercoExtDataProcessor;
    private
//      ContentTag: string;
//      ObjCursor: TObject;

      FProcMsg: string;

      procedure SetCataloguesList;
//      procedure SetActionsList;

      procedure ResetCatalogueList;
//      procedure ResetActionsList;

    public
      //function GetCatalogProcObject(Datatype: string): TObject;
      function GetRoot: TObject;
      function GetProc(Tag: string): TObject;

      function PreProcessing(DataTypeTag, ActionTypeTag, ContentTag: string): boolean;
      function PostProcessing(DataTypeTag, ActionTypeTag, ContentTag: string): boolean;

      property ResultMessage: string read FProcMsg write FProcMsg;
      
      constructor Create;
      destructor Destroy; override;
    End;

    TPercoExtDataProcessor = Class
      Parent: TPercoExtDataProcessor;
      SubProcList: TStringList;
      tag: string;
      private
        //FKey: string;
      public
        function GetSubProcObject(Tag: string): TObject;  virtual;
        function isEntity: boolean; virtual;
        function PreProcessing(Tag: string): boolean; virtual; abstract;
        function PostProcessing(Tag: string): boolean; virtual; abstract;

        property Key: string read tag write tag;
    End;

    TPercoActionTypeProcessor = Class(TPercoExtDataProcessor)
    private
      Key: string;
      FReport: string;
    public  
      property Report: string read FReport write FReport;
      function PreProcessing(Tag: string): boolean; override;
      function PostProcessing(Tag: string): boolean; override;
      constructor Create(Parent: TPercoExtDataProcessor);
    End;

    TPercoDataTypeProcessor = Class(TPercoExtDataProcessor)
      Kit: TPercoActionTypeProcessor;
      ActionsList: TStringList;
    public
      //function GetActionProcObject(Actiontype: string): TObject;
      constructor Create;
      destructor Destroy; override;
      function PreProcessing(Tag: string): Boolean; override;
    function PostProcessing(Tag: string): Boolean; override;

    private
      procedure SetActionsList; virtual;
      procedure ResetActionsList; virtual;

    End;

    TStaffDscr = Record
      id_internal,
      id_external,
      id_subdiv_ext,
      id_appoint_ext: string;

      firsname, middlename, lastname: string;
      subdiv, appoint: string;

      function GenerateKeyFile: string;
      function GenerateKeyStream: string;
      procedure Reset;
      function Valid: boolean;
      function identity: string;

      function Compare(Dscr0: TStaffDscr): byte;
    End;



    TStaffProcessor = Class(TPercoDataTypeProcessor)
      public
        function isEntity: boolean; override;
//        function PreProcessing(Tag: string): boolean; override;
//        function PostProcessing(Tag: string): boolean; override;

        function GetItemPassport(Key: string): TStaffDscr;
        property ItemPassport[Key: string]: TStaffDscr read GetItemPassport;
      private
        procedure SetActionsList; override;
        procedure ResetActionsList; override;

        function GetElement(var el: TStaffDscr): boolean;

      public
        constructor Create;
        destructor Destroy; override;
    End;

    TStaffUpdate = Class(TPercoActionTypeProcessor)
      const
        MASKDIFFAPPOINT = 2;
        MASKDIFFSUBDIV = 2*2;
      var
        StaffElement: TStaffDscr;
      private
        changesmask: byte;
        function CheckAppointSubdivChange(newDscr: TStaffDscr): boolean;
        procedure ChangesReaction(newDscr: TStaffDscr);

        function GenerateMessage(NewDscr: TStaffDscr; report: string = ''): string;
      public
        function isEntity: boolean; override;
        function PreProcessing(Tag: string): boolean; override;
        function PostProcessing(Tag: string): boolean; override;

        constructor Create(Parent: TPercoExtDataProcessor);
    End;

    TAccessCardsManager = Class
      private
        FLastErrorText: string;
      public
        property LastErrorText: string read FLastErrorText write FLastErrorText;
        function ProhibitCardByEmploys(employ, id: string): boolean;
        constructor Create;
        destructor Destroy; override;
    End;



var PercoObjectsManager: TPercoObjectsManager;
    AccessCardsManager: TAccessCardsManager;


implementation

  uses UnitPerco, UnitCSVReader, MSXML2_TLB;

  type
    TCSVStreamWriter = Class(TCSVStreamsManager)
    public
      class function DatasetToStream(Dataset: TIBDataset): string;
    End;



//     = 0;
//     = 1;
  var DataBuffer: string;
//      CSVStreamWriter: TCSVStreamWriter;

//  function BirthCSVInterface(CSVInterfaceType: TCSVInterfaceType): IUniversalCSVReader;
//  begin
//    RESULT := nil;
//    case CSVInterfaceType of
//      CSVINTERFACEFILE:
//        RESULT := TInterfacedCSVFileReader.Create;
//      CSVINTERFACEMEMORY:
//        RESULT := TInterfacedCSVStreamReader.Create;
//    end;
//  end;
{ TPercoExtDataProcessor }

function TPercoExtDataProcessor.GetSubProcObject(Tag: string): TObject;
var k: integer;
begin
  RESULT := nil;
  k := Self.SubProcList.IndexOf(Tag); //Name
  if k < 0 then exit;

  RESULT :=  Self.SubProcList.Objects[k];
end;

function TPercoExtDataProcessor.isEntity: boolean;
begin
  RESULT := False;
end;

{ TStaffProcessor }

constructor TStaffProcessor.Create;
begin
  Self.tag := 'staff';
  Self.SetActionsList;
end;

procedure ExtSaveDataToFileCSV(Dataset: TIBDataSet);

var
  line: string;
  ff: text;
  {i,} j: integer;
begin
  {refactoring}
  TCSVStreamWriter.DatasetToStream(Dataset);
  exit;
  {end refactoring}

  if Dataset.RecordCount = 0 then exit;

  DataBuffer := ChangeFileExt(DataBuffer, '..csv');

  Assign(ff, DataBuffer);
  Rewrite(ff);
  try
    line := '';
    for j := 0 to Dataset.FieldCount - 1 do
      line := line + Dataset.Fields[j].FieldName + ';';
    SetLength(line, Length(line) - 1);
    writeln(ff, line);
    line := '';
    DataSet.First;
    repeat
      for j := 0 to DataSet.FieldCount - 1 do
        line := line + Dataset.Fields[j].AsString + ';';

      SetLength(line, Length(line) - 1);
      writeln(ff, line);
      DataSet.Next;
    until DataSet.Eof;

  finally
    CloseFile(ff);
  end;
  

        
 
  ;
end;

destructor TStaffProcessor.Destroy;
begin
  Self.ResetActionsList;
  inherited;
end;

function TStaffProcessor.GetElement(var el: TStaffDscr): boolean; 
const GETSTAFFELEMENT = 'STAFF_FOR_1C_$GET';
  FILEINCSV = '';
  FILEOUTCSV = '';
var PercoKit: TPercoDataLoader;
  pool: TDataPool;
  CSVReader: IUniversalCSVReader; //TCSVXReader;
  Transaction: TIBTransaction;
  Proc: TIBStoredProc;
begin
  RESULT := False;
  if PercoImport = nil then exit;

  PercoKit := PercoImport;
  

  DataBuffer := {el.GenerateKeyFile} el.GenerateKeyStream;

  if DataBuffer = '' then exit;


  pool.datacsv :=  DataBuffer; //FILEINCSV;
  pool.kit := GETSTAFFELEMENT;
  pool.extproc :=  ExtSaveDataToFileCSV;

  pool.safe := True;//False; => Grabbing linking params error

  Transaction := TIBTransaction.Create(nil);
  try
    Proc := TIBStoredProc.Create(nil);
    try
      Proc.Transaction := Transaction;
      PercoKit.IBInit(Proc);
      if PercoKit.ProcessingDataPool(pool) then
       begin
        CSVReader := BirthCSVInterface(Pool.datainterface);//{TCSVXReader} TInterfacedCSVStreamReader.Create; //TInterfacedCSVFileReader.Create;
        try
          CSVReader.Line0Titles := True;
          if CSVReader.Open(DataBuffer) then
           try
            CSVReader.ReturnLine;
            el.id_internal := CSVReader.Field['F_ID_STAFF'];
            el.id_subdiv_ext := CSVReader.Field['F_ID_SUBDIV'];
            el.id_appoint_ext := CSVReader.Field['F_ID_APPOINT'];

            el.firsname := Utf8ToAnsi(CSVReader.Field['F_FIRST_NAME']);
            el.middlename := Utf8ToAnsi(CSVReader.Field['F_MIDDLE_NAME']);
            el.lastname := Utf8ToAnsi(CSVReader.Field['F_LAST_NAME']);

            el.subdiv := Utf8ToAnsi(CSVReader.Field['F_NAME_SUBDIV']);
            el.appoint := Utf8ToAnsi(CSVReader.Field['F_NAME_APPOINT']);
            //...and other needed fields may be loaded here...
            RESULT := True;
           finally
            CSVReader.Close;
            DeleteFile(DataBuffer);
           end;
        finally
          {CSVReader.Free;}
        end; 
       ;
       end;
    finally
      FreeAndNil(Proc);
    end;
  finally
    Transaction.Free;
  end;
  DeleteFile(pool.datacsv);
end;

function TStaffProcessor.GetItemPassport(Key: string): TStaffDscr;
var Dscr: TStaffDscr;
begin
  Dscr.id_external := Trim(Key);
  if Self.GetElement(Dscr) then
    RESULT := Dscr
   else
    RESULT.id_external := ''; 
end;

function TStaffProcessor.isEntity: boolean;
begin
  RESULT :=True;
end;


procedure TStaffProcessor.ResetActionsList;
var k: integer;
begin
  while Self.ActionsList.Count > 0 do
   begin
    k := Self.ActionsList.Count - 1;
    Self.ActionsList.Objects[k].Free;
    Self.ActionsList.Delete(k);
   end;
end;

procedure TStaffProcessor.SetActionsList;
begin
  Self.ActionsList := TStringList.Create;
  Self.ActionsList.AddObject('update',TStaffUpdate.Create(Self));

  Self.SubProcList := Self.ActionsList;
end;

{ TStaffUpdate }

procedure TStaffUpdate.ChangesReaction(newDscr: TStaffDscr);
begin

  Self.Report := Self.GenerateMessage(newDscr, ' '); //просто сгенерировать сообщение
  exit; // из-за отказа от блокировки карт доступа

     { TODO : Insert Staff Card Lock here }
  if AccessCardsManager.ProhibitCardByEmploys(Self.Key, newDscr.id_internal) then
    Self.Report := Self.GenerateMessage(newDscr)
   else
    Self.Report := Self.GenerateMessage(newDscr, ' ' + AccessCardsManager.LastErrorText);

end;

function TStaffUpdate.CheckAppointSubdivChange(newDscr: TStaffDscr): boolean;
begin
  RESULT := False;
  if Self.StaffElement.identity <> newDscr.identity then exit;

  if Self.StaffElement.Valid and newDscr.Valid  then
   begin
    Self.changesmask := newDscr.Compare(Self.StaffElement);
    RESULT := (Self.changesmask AND (MASKDIFFAPPOINT OR MASKDIFFSUBDIV))> 0;
   end;

end;

constructor TStaffUpdate.Create(Parent: TPercoExtDataProcessor);
begin
  inherited;
  Self.tag := 'update';
end;

function TStaffUpdate.GenerateMessage(NewDscr: TStaffDscr; report: string = ''): string;
var staffmsg: string;
  subdivchange, appointchange: string;
begin
  RESULT := '';
  staffmsg := Format('******* %s %s *******',[Self.StaffElement.firsname, Self.StaffElement.lastname]); //Cотрудник

  if (Self.changesmask AND MASKDIFFSUBDIV) > 0 then
    subdivchange := Format('подразделение "%s" --> "%s"' + #$D#$A,[Self.StaffElement.subdiv, NewDscr.subdiv])
   else 
    subdivchange := '';
    
  if (Self.changesmask AND MASKDIFFAPPOINT) > 0 then
    appointchange := Format('должность "%s" --> "%s"' + #$D#$A,[Self.StaffElement.appoint, NewDscr.appoint]);
     
  if report = '' then
    report := '#!#  арта доступа заблокирована #!#'
   else
    report := '#!# Ѕлокировка карты не выполнена. ¬озможно, требуетс€ изменить права доступа' + #$D#$A + report;

  RESULT := Concat(#$D#$A, staffmsg, #$D#$A, subdivchange + appointchange, #$D#$A, report);


  
end;

function TStaffUpdate.isEntity: boolean;
begin
  RESULT := True;
end;

function TStaffUpdate.PostProcessing(Tag: string): boolean;
var StaffDscr: TStaffDscr;
begin
  RESULT := inherited PostProcessing(Tag);
 { TODO : insert Staff Update postprocessing here }
 if Result then
 begin
  StaffDscr := (Self.Parent as TStaffProcessor).ItemPassport[Tag];
  if Self.CheckAppointSubdivChange(StaffDscr) then
    Self.ChangesReaction(StaffDscr);
  RESULT := Trim(Self.Report) > '';
 end;
end;

function TStaffUpdate.PreProcessing(Tag: string): boolean;
var StaffDscr: TStaffDscr;
begin
 { TODO :  insert Staff Update preprocessing here }
  Self.Report := '';
  StaffDscr := (Self.Parent as TStaffProcessor).ItemPassport[Tag];
  if StaffDscr.Valid then  //id_external > ''
    Self.StaffElement := StaffDscr
   else
    Self.StaffElement.Reset; 
  RESULT := inherited PreProcessing(Tag);
end;

{ TPercoObjectsManager }

constructor TPercoObjectsManager.Create;
begin
  Self.CataloguesList := TStringList.Create;
  Self.RootProc := TPercoDataTypeProcessor.Create;

  Self.SetCataloguesList;

  //SQLKit := TPercoSQL.Create;
  //SQLKit.Init();  //ExtractFilePath(Paramstr(0))
end;

destructor TPercoObjectsManager.Destroy;
begin
  //SQLKit.Free;

  Self.ResetCatalogueList;
  Self.RootProc.SubProcList:=nil;      { TODO : abstract error here }
  //Self.CataloguesList.Free;
  inherited;
end;

function TPercoObjectsManager.GetProc(Tag: string): TObject;
begin
  RESULT := nil;
  if Assigned(Self.RootProc) then
   begin
    RESULT := Self.RootProc.GetSubProcObject(Tag);
   end;
end;

function TPercoObjectsManager.GetRoot: TObject;
begin
  RESULT := Self.RootProc;
end;



function TPercoObjectsManager.PostProcessing(DataTypeTag, ActionTypeTag, ContentTag: string): boolean;
var ObjCtlg, ObjAct: TObject;
begin
//  RESULT := False;
  ObjCtlg := Self.GetProc(DataTypeTag); //GetCatalogProcObject(DataTypeTag);
  RESULT := ObjCtlg = nil;
  if RESULT then exit;

  ObjAct := (ObjCtlg as TPercoDataTypeProcessor).GetSubProcObject(ActionTypeTag);
  if RESULT then exit;

  if (ObjAct as TPercoActionTypeProcessor).isEntity then
    RESULT := (ObjAct as TPercoActionTypeProcessor).PostProcessing(ContentTag);

  if RESULT then
    Self.FProcMsg := (ObjAct as TPercoActionTypeProcessor).Report;
  //RESULT := True;
end;

function TPercoObjectsManager.PreProcessing(DataTypeTag, ActionTypeTag, ContentTag: string): boolean;
var ObjCtlg, ObjAct: TObject;
begin
//  RESULT := False;
  Self.FProcMsg := '';
  
  ObjCtlg := Self.GetProc(DataTypeTag);
  RESULT := ObjCtlg = nil;
  if RESULT then exit;

  ObjAct := (ObjCtlg as TPercoDataTypeProcessor).GetSubProcObject(ActionTypeTag);

  RESULT := ObjAct = nil;
  if RESULT then exit;

  if (ObjAct as TPercoActionTypeProcessor).isEntity then
    RESULT := (ObjAct as TPercoActionTypeProcessor).PreProcessing(ContentTag);

  //RESULT := True;
end;



//procedure TPercoObjectsManager.ResetActionsList;
//begin
//  inherited;
//end;

procedure TPercoObjectsManager.ResetCatalogueList;
var k: integer;
begin
  Self.RootProc.SubProcList := nil;
  while Self.CataloguesList.Count > 0 do
   begin
    k := Self.CataloguesList.Count - 1;
    Self.CataloguesList.Objects[k].Free;
    Self.CataloguesList.Delete(k);
   end;
end;



//procedure TPercoObjectsManager.]SetActionsList;
//begin
//  inherited;
//end;

procedure TPercoObjectsManager.SetCataloguesList;
//var CtlgObj: TObject;
begin
  Self.CataloguesList.AddObject('staff', TStaffProcessor.Create);
  //Self.CataloguesList.AddObject('appoint', T)
  //...
  Self.RootProc.SubProcList := Self.CataloguesList;
end;

{ TPercoDataTypeProcessor }

constructor TPercoDataTypeProcessor.Create;
begin
  inherited;


end;

destructor TPercoDataTypeProcessor.Destroy;
begin
  //Self.ResetActionsList;
  Self.ActionsList.Free;
  inherited;
end;

function TPercoDataTypeProcessor.PostProcessing(Tag: string): Boolean;
begin
  Result := inherited PostProcessing(Tag);
end;

function TPercoDataTypeProcessor.PreProcessing(Tag: string): Boolean;
begin
  Result := inherited PreProcessing(Tag);
end;

procedure TPercoDataTypeProcessor.ResetActionsList;
begin
  inherited;
end;

procedure TPercoDataTypeProcessor.SetActionsList;
begin
  inherited;
end;

//function TPercoDataTypeProcessor.GetActionProcObject(Actiontype: string): TObject;
//var k: integer;
//begin
//  RESULT := nil;
//
//  k := Self.ActionsList.IndexOf(Actiontype);
//  if k < 0  then exit;
//
//  RESULT := Self.ActionsList.Objects[k];
//end;

{ TPercoActionTypeProcessor }

constructor TPercoActionTypeProcessor.Create(Parent: TPercoExtDataProcessor);
begin
  Self.Parent := Parent;
end;

function TPercoActionTypeProcessor.PostProcessing(Tag: string): boolean;
begin
  RESULT := False;
  if Tag <> Key then exit;
  //Self.Key:='';
end;

function TPercoActionTypeProcessor.PreProcessing(Tag: string): boolean;
begin
  Self.Key := Tag;
  RESULT := True;
end;

{ TPercoSQL }

//constructor TPercoSQL.Create;
//begin
//  Self.FIBDatabase := TIBDatabase.Create(nil);
//  Self.FIBQuery := TIBDataSet.Create(nil);
//end;
//
//destructor TPercoSQL.Destroy;
//begin
//  Self.FIBQuery.Free;
//  Self.FIBDatabase.Free;
//  inherited;
//end;
//
//procedure TPercoSQL.Init(fileini: string);
//var
//  iniFile: TINIFile;
//begin
//  iniFile := TINIFile.Create(fileini);
//  try
//    Self.FFDBServer := iniFile.ReadString('Perco', 'Host', '');
//    Self.FFDBName := iniFile.ReadString('FirebirdDB','File','');
//    Self.FUserName := iniFile.ReadString('FirebirdDB','user_name','SYSDBA');
//    Self.FPassword := iniFile.ReadString('FirebirdDB','password','masterke');
//  finally
//    iniFile.Free;
//  end;
//
//  Self.FIBDatabase.DatabaseName := Concat(Self.FFDBServer, ':', Self.FFDBName);
//  Self.FIBQuery.Database := Self.FIBDatabase;
//  Self.FIBDatabase.LoginPrompt := False;
//
//end;
//
//function TPercoSQL.SelectStaffDscr(var StaffDscr: TStaffDscr): boolean;
//begin
//  Self.FIBQuery.Active := False;
//
//  Self.FIBQuery.SelectSQL.Text := 'Select 1';
//  Self.FIBQuery.Open;
//  ;
////end;
//
//end;

{ TStaffDscr }

function TStaffDscr.Compare(Dscr0: TStaffDscr): byte;
var h: byte;
begin
  RESULT := 0;
  h:=1;
  if Dscr0.id_internal <> Self.id_internal then exit;
  
  h:=h*2;
  if Dscr0.id_appoint_ext <> Self.id_appoint_ext then
    RESULT := RESULT OR h;

  h := h*2;
  if Dscr0.id_subdiv_ext <> Self.id_subdiv_ext then
    RESULT := RESULT OR h;
  //... here may be checked other filelds
end;

function TStaffDscr.GenerateKeyFile: string;
const STAFFFILENAME = 'STAFF[##].csv';
var filecsv: string; ff: text;
  line: string;
begin
  RESULT := '';

  try
    filecsv := ExtractFilePath(Paramstr(0)) + StringReplace(STAFFFILENAME, '##', Trim(self.id_external), []);
    Assign(ff, filecsv);
    Rewrite(ff);
    try
      writeln(ff,'P_ID_STAFF_1C');
      line := self.id_external;
      writeln(ff, line);
    finally
      CloseFile(ff);
    end;
    RESULT := filecsv;
  except on E: Exception do
  end;
end;

function TStaffDscr.GenerateKeyStream: string;
const STAFFFILENAME = 'STAFF[##].csv';
var streamcsv: string; id: integer;
  line: string;
begin
  RESULT := '';

  try
    streamcsv := StringReplace(STAFFFILENAME, '##', Trim(self.id_external), []);
    StringStreamsManager.Assign(id, streamcsv);
    StringStreamsManager.Rewrite(id);
    try
      StringStreamsManager.writeln(id,'P_ID_STAFF_1C');
      line := self.id_external;
      StringStreamsManager.writeln(id, line);
    finally
      StringStreamsManager.Finit(id);
    end;
    RESULT := streamcsv;
  except on E: Exception do
  end;
end;

function TStaffDscr.identity: string;
begin
  RESULT := self.id_external;
end;

procedure TStaffDscr.Reset;
begin
  id_external := '';
  id_subdiv_ext := '';
  id_appoint_ext := '';
end;

function TStaffDscr.Valid: boolean;
begin
  RESULT := id_external > '';
end;

{ TAccessCardsManager }

constructor TAccessCardsManager.Create;
begin

end;

destructor TAccessCardsManager.Destroy;
begin

  inherited;
end;

function TAccessCardsManager.ProhibitCardByEmploys(employ, id: string): boolean;
var
  Kit: TPercoCOMProcessor;
  CommandXML: IXMLDOMDocument;
  attributes: TAttributesArray;
  AttrProducer: TAttributesProducer;
  specification: string;
  {NodeChild,} Node: IXMLDOMNode;
begin
  RESULT := False;
  Self.FLastErrorText := '';
  if PercoCOM = nil then exit;

  Kit := PercoCOM;

  attributes := TAttributesProducer.ProduceAttributes('type;mode','sendcards;prohibit_card_selected_employs');
  CommandXML := Kit.GenerateDocumentRequest(attributes, Node);

  specification := 'login;employs;employ';

  AttrProducer := TAttributesProducer.Create(CommandXML,specification);
  try
    AttrProducer.NodeAttributesStr['login']:= Format('loginname=%s',[Kit.Login]);
    AttrProducer.NodeAttributesStr['employ']:= Format('id_external=%s;id_internal=%s',[employ, id]);
    Node := Kit.GenerateNodesStairs(Node, specification, AttrProducer);
    //Node := Node.appendChild(CommandXML.createElement(Self.FDataType));

  finally
    FreeAndNil(AttrProducer);
  end;
  //CommandXML.save('C:\rfgdgeurfheirufhCard.xml');
  { TODO : save operation result into text variable and send to Perco Support }
  RESULT := Kit.Intf.ExecuteAccessCardsAction(CommandXML as IDispatch) = 0;
  if NOT RESULT then
    Self.LastErrorText := Kit.ErrorXMLtoString(Kit.ErrorRequest);
end;

{ TCSVStreamWriter }

class function TCSVStreamWriter.DatasetToStream(Dataset: TIBDataset): string;
var
  line: string;
//  pp: pointer;
  id: integer;
  {i,} j: integer;
begin
  if Dataset.RecordCount = 0 then exit;

  DataBuffer := ChangeFileExt(DataBuffer, '..csv');

  StringStreamsManager.Assign(id, DataBuffer);
  StringStreamsManager.Rewrite(id);
  try
    line := '';
    for j := 0 to Dataset.FieldCount - 1 do
      line := line + Dataset.Fields[j].FieldName + ';';
    SetLength(line, Length(line) - 1);
    StringStreamsManager.writeln(id, line);
    line := '';
    DataSet.First;
    repeat
      for j := 0 to DataSet.FieldCount - 1 do
        line := line + Dataset.Fields[j].AsString + ';';

      SetLength(line, Length(line) - 1);
      StringStreamsManager.writeln(id, line);
      DataSet.Next;
    until DataSet.Eof;

  finally
    StringStreamsManager.Finit(id);
  end;
end;

initialization
  PercoObjectsManager :=TPercoObjectsManager.Create;
  AccessCardsManager := TAccessCardsManager.Create;
finalization
  AccessCardsManager.Free;
  PercoObjectsManager.Free;
end.
