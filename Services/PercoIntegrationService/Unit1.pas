unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Menus,
  Dialogs, StdCtrls, IBDatabase, DB, IBDatabaseINI, DBLogDlg, IBCustomDataSet, IBStoredProc
  ,UnitPerco, Buttons, INIFiles, ExtCtrls, xmldom, XMLIntf, msxmldom, XMLDoc, IBQuery, ShellAPI;

type
  TForm1 = class(TForm)
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    IBDatabaseINI1: TIBDatabaseINI;
    IBStoredProc1: TIBStoredProc;
    OpenDialog1: TOpenDialog;
    BitBtn1: TBitBtn;
    LabeledEdit1: TLabeledEdit;
    XMLDocument1: TXMLDocument;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    RadioGroup1: TRadioGroup;
    SaveDialog1: TSaveDialog;
    IBQuery1: TIBQuery;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    PopupMenu1: TPopupMenu;
    Open1: TMenuItem;
    Exit1: TMenuItem;
    Button4: TButton;
    Button5: TButton;
    CheckBox2: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
    FIconData:TNotifyIconData;
  protected
    procedure WndProc(var Msg: TMessage); Override;  
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses UnitAUX, Math, UnitReporter;

var
    DataPool: TDataPool;


procedure CalculateStaffCrosses;
var
  k0, k, l: integer;
  datemark: TDateTime;
begin
  l := Length(StaffCrosses);
  if l = 0 then exit;

  for k := 1 to l - 1 do
    if (StaffCrosses[k].tabel = StaffCrosses[k-1].tabel) and (StaffCrosses[k].datetime - StaffCrosses[k-1].datetime < 1) then
      StaffCrosses[k].timelength := StaffCrosses[k].crosstype * Sign(StaffCrosses[k].crosstype - StaffCrosses[k-1].crosstype) * (StaffCrosses[k].datetime - StaffCrosses[k-1].datetime)   //Sign(StaffCrosses[k].crosstype - StaffCrosses[k-1].crosstype) *
     else
      StaffCrosses[k].timelength := 0;


  k0 := 0;
//  k := 0;
  repeat
    datemark := StaffCrosses[k0].date;  //опорная дата
    //k := k0 + 1;

    while (k0<l) do       //цикл до начала смены
      if (StaffCrosses[k0].date = datemark) and StaffCrosses[k0].previousday then
        inc(k0)
       else
        break;
    if k0 >= l then break;
    if (StaffCrosses[k0].date) <> datemark then
      continue;

    while k0 < l do  //цикл до до первого входа
      if (StaffCrosses[k0].crosstype * StaffCrosses[k0].zone  = 0) then
        inc(k0)
       else
        break;
    if k0 >= l then break;
    if (StaffCrosses[k0].date) <> datemark then
      continue;

    StaffCrosses[k0].daypoint := true;
    k := k0;
    while (k<l) do      //цикл до конца смены
      if (StaffCrosses[k].date) = datemark then
       begin
        StaffCrosses[k0].daysum := StaffCrosses[k0].daysum + StaffCrosses[k].zone * StaffCrosses[k].timelength;
        inc(k);
       end
       else
       begin
        while (k<l) do
          if (StaffCrosses[k].previousday) and (StaffCrosses[k].date = datemark + 1)  then
           begin
            StaffCrosses[k0].daysum := StaffCrosses[k0].daysum + StaffCrosses[k].zone * StaffCrosses[k].timelength;
            inc(k);
           end
           else
            break;
        break;
       end;
    k0:=k;
  until (k0>l);
end;

procedure SaveCrossesArray(resultscsv: string = '');
var k, l: integer;
  ff: Text;
  line: string;   filename: string;
begin
  l := Length(StaffCrosses);
  if l=0 then exit;

  if resultscsv = '' then
    filename := Format('discipline{%s}[%s..%s].csv',[StaffCrosses[0].tabel, DateTimeToStr(StaffCrosses[0].date),DateTimeToStr(StaffCrosses[l-1].date)])
   else
    filename := resultscsv;
  Assign(ff, filename);

  if FileExists(resultscsv) then Append(ff)
   else Rewrite(ff);

  try
    for k:=0 to l-1 do
     if StaffCrosses[k].daypoint then
      begin
        line := Concat(StaffCrosses[k].tabel, ';', DateToStr(StaffCrosses[k].date),';', FloatToStr(Round(StaffCrosses[k].daysum * 24)));
        writeln(ff, line);
      end;

  finally
    CloseFile(ff);
  end;
end;


procedure DatasetToArray(DataSet: TIBDataSet);
const
  FLD_TABEL_NO = 'TABEL_NO';
  FLD_DATEPASS = 'DATEPASS';
  FLD_TIMEPASS = 'TIMEPASS';
  FLD_SHIFTING = 'SHIFTING';
  FLD_CODEPASS = 'CODEPASS';
  FLD_AREA = 'AREA';
  FLD_DEVICE = 'DEVICE';
  FLD_ZONE = 'ZONE';
const   SHIFTHOUR = 7;
var
  i {, j}: integer;
begin
  i := 0;
  SetLength(StaffCrosses,0);
  DataSet.Last;
  SetLength(StaffCrosses, Dataset.RecordCount);
  if DataSet.RecordCount = 0 then exit;

  DataSet.First;
  repeat  //цикл по табельному номеру
    //i:= DataSet.RecNo - 1;
    with StaffCrosses[i] do
     begin
      tabel :=  Trim(DataSet.FieldByName(FLD_TABEL_NO).AsString);
      date  := DataSet.FieldByName(FLD_DATEPASS).AsDateTime;
      time :=  DataSet.FieldByName(FLD_TIMEPASS).AsDateTime;
      crosstype := Dataset.FieldByName(FLD_CODEPASS).AsInteger;
      zone := DataSet.FieldByName(FLD_ZONE).AsInteger;
      datetime := date + time;
      previousday := DataSet.FieldByName(FLD_SHIFTING).AsInteger > 0; //time < SHIFTHOUR / 24
     end;
     inc(i);
    DataSet.Next;
  until DataSet.Eof;
  SetLength(StaffCrosses, Dataset.RecordCount);

  CalculateStaffCrosses;
  SaveCrossesArray(ChangeFileExt(DataPool.datacsv, '.out.csv'));
end;

procedure externalprocessing(DataSet: TIBDataSet);
begin
  Reporter.Init(ChangeFileExt(DataPool.datacsv, '.out.csv'));
  Reporter.ProcessDataset(DataSet);
end;

procedure proc(DataSet: TIBDataSet);
var
  ff: Text;
  {i,} j, l: integer;
  line: string;     output: string;

begin
  output := transformFileName('resultdataset.csv');
  output := ExtractFilePath(Paramstr(0))+output;
  Assign(ff, output);
  if FileExists(output) then Append(ff)
   else
   begin
    rewrite(ff);
    for j := 0 to Dataset.Fields.Count - 1 do
       line:=line+Dataset.Fields[j].FieldName+';';
    l := length(line);
    if l>0 then
     begin
      SetLength(line, l-1);
      writeln(ff, line);
     end;
   end;

  try
    DataSet.First;
    repeat
      line:='';
      for j := 0 to Dataset.Fields.Count - 1 do
       begin
        line := line+Dataset.Fields[j].AsString+';';
       end;
      l := length(line);
      if l>0 then
       begin
        SetLength(line, l-1);
        writeln(ff, line);
       end;
      Dataset.Next;
    until DataSet.Eof;
  finally
    CloseFile(ff);
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
//var DataPool: TDataPool;
begin
  DataPool.kit := PROC_DOCS_INS;
  if Self.LabeledEdit1.Text<>'' then
    DataPool.kit := Trim(Self.LabeledEdit1.Text);
  if self.OpenDialog1.Execute() then
   begin
    DataPool.datacsv := self.OpenDialog1.FileName;
    DataPool.safe := Self.CheckBox1.Checked;
    self.IBStoredProc1.StoredProcName := DataPool.kit;

    //if PercoImport.FDBName = '' then
      //PercoImport.FDBName := InputBox('Perco Import Direct','Perco Database Local Path', 'SCD17K.FDB');
    PercoImport.IBInit(self.IBStoredProc1);

    if pos(Concat('##',DataPool.kit,'##'), Concat('##',PROC_DOCS_INS, '##',PROC_STAFF_CROSSES_GET, '##')) = 0  then
      if MessageDlg('Выполнение предполагает выгрузку результата?',mtConfirmation,mbYesNo,0)=mrYes then
       begin
        DataPool.safe := True;
        DataPool.extproc := externalprocessing;//proc;  DatasetToArray
       end
       else
        DataPool.extproc := nil;

    PercoImport.ProcessingDataPool(DataPool);

//    if Assigned(DataPool.extproc) then
//     begin
//      CalculateStaffCrosses;
//      SaveCrossesArray;
//     end;

    try
      ;
    finally

    end;
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  self.XMLDocument1.Active := False;
  self.XMLDocument1.XML.Text := '';

  //PercoCOM.LoadPercoSubdivsEx; //STAFF;
  //;

  OpenDialog1.Filter := 'Файлы данных интеграции (*[<ключ>]*.csv) |*[*]*.csv';
  if OpenDialog1.Execute then
   begin
     PercoCOM.ProcessingDataFile(OpenDialog1.FileName);
   end;
  OpenDialog1.Filter := 'Все файлы (*.*)|*';
  self.Memo1.Lines.Text := PercoCOM.Text;//XMLDocument1.XML. FormatXMLData();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  self.XMLDocument1.Active := False;
  self.XMLDocument1.XML.Text := '';
  OpenDialog1.Filter := 'Файлы XML-запросов|*.xml';
  if OpenDialog1.Execute then
    PercoCOM.SendFileRequest(OpenDialog1.FileName);
  OpenDialog1.Filter := 'Все файлы (*.*)|*';
  self.Memo1.Lines.Text := self.XMLDocument1.XML.Text;//FormatXMLData()
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  saveFileName: string;
  datatype: string;
begin
  self.XMLDocument1.Active := False;
  self.XMLDocument1.XML.Text := '';

  Self.SaveDialog1.DefaultExt := '.xml';
  Self.SaveDialog1.Filter := 'XML-файлы|*.xml';

  case Self.RadioGroup1.ItemIndex of
    0: datatype:='=staff=';
    1: datatype:='=appoints=';
    2: datatype:='=subdivs=';
  end;



  {saveFilename := DateTimeToStr(Now());
  saveFileName := StringReplace(saveFilename,':','-',[rfReplaceAll]);
  saveFileName := StringReplace(saveFilename,'/','',[rfReplaceAll]);
  saveFileName := StringReplace(saveFilename,'\','',[rfReplaceAll]);
  saveFileName := StringReplace(saveFilename,' ','_',[rfReplaceAll])};

  saveFileName := FormatDateTime('[yyyy-mm-dd hh-mm-ss]',Now());
  Self.SaveDialog1.Filename := ExtractFilePath(Paramstr(0)) +'Data'+datatype+'['+ saveFilename+'].XML';



  if Self.SaveDialog1.Execute then
   begin
    if PercoCOM.LoadFileRequest(Self.RadioGroup1.ItemIndex, SaveDialog1.FileName) then
      if MessageDlg('Файл выгружен. Загрузить данные обратно?',mtConfirmation,mbYesNo,0)<> mrYes then exit;
   end
   else
    if MessageDlg('Загрузка файла. Продолжить?',mtConfirmation,mbYesNo,0)<> mrYes then exit;

  OpenDialog1.InitialDir := ExtractFileDir(SaveDialog1.FileName);
  OpenDialog1.FileName := ExtractFileName(SaveDialog1.FileName);
  OpenDialog1.Filter := 'Файлы XML-запросов|*.xml';
  if OpenDialog1.Execute then
    PercoCOM.UpdateFileRequest(OpenDialog1.FileName);
  OpenDialog1.Filter := 'Все файлы (*.*)|*';
  OpenDialog1.FileName := '';
  self.Memo1.Lines.Text := PercoCOM.Text; //self.XMLDocument1.XML.Text;//FormatXMLData()

  self.Button3.Enabled := False;
  Self.RadioGroup1.ItemIndex := -1;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  preSavedCatalogue: string;
  confirmRequest: string;
begin
  preSavedCatalogue := '';
  if Self.CheckBox2.Checked then
   begin
    OpenDialog1.Filter := 'Файлы внешних справочников (Data=<ключ>=*.xml) |Data=*=*.xml';
    OpenDialog1.InitialDir := ExtractFileDir(ExtractFileDir(Paramstr(0)));
    OpenDialog1.Title := 'Открытие XML-справочника Perco';
    if OpenDialog1.Execute then
      preSavedCatalogue := OpenDialog1.FileName
   end;

  if Self.CheckBox2.State <> cbUnchecked then
   begin
    SaveDialog1.Title := 'Сохранить XML-дерево разницы как...';
    SaveDialog1.InitialDir := ExtractFileDir(ExtractFileDir(Paramstr(0)));
    SaveDialog1.FileName := Format('Delta[%s].xml',[FormatDateTime('dd.mm.yyyy hh-nn-ss', Now())]);
    SaveDialog1.Filter := 'XML-дерево разности|*.xml';
    if SaveDialog1.Execute then
     begin
      if Self.CheckBox2.State = cbGrayed then
        confirmRequest := 'Выполнение актуальной выгрузки из Perco без обновления данных'
       else
        confirmRequest := 'Выполнение сопоставления с сохранённым справочником Perco без обновления данных';
      if MessageDlg(confirmRequest, mtConfirmation, mbOKCancel, 0) <> mrOK then exit;
     end
     else
     begin
      SaveDialog1.FileName := '';
      CheckBox2.State := cbGrayed;
      if preSavedCatalogue = '' then
       begin
        confirmRequest := 'Продолжить без сохранения дерева разницы обновление данных Perco?';
        if MessageDlg(confirmRequest, mtConfirmation, mbYesNo, 0) <> mrYes then exit;
       end
       else
        exit;
     end;
   end
   else
   begin
     SaveDialog1.FileName := '';
     confirmRequest := 'Будет произведена попытка привести справочник Perco в соответствие с внешним справочником';
     if MessageDlg(confirmRequest, mtConfirmation, mbOKCancel, 0) <> mrOK then
      begin
        CheckBox2.State := cbGrayed;
        exit;
      end;
   end;

  OpenDialog1.Title := 'Открытие csv-справочника 1С';
  OpenDialog1.Filter := 'Файлы внешних справочников (*=<ключ>=*.csv) |*=*=*.csv';
  OpenDialog1.InitialDir := ExtractFileDir(ExtractFileDir(Paramstr(0)));
  OpenDialog1.FileName := '';
  if OpenDialog1.Execute then
  try
    if (preSavedCatalogue='') and (SaveDialog1.FileName = '') then
      confirmRequest := 'Выполнение ОБНОВЛЕНИЕ ДАННЫХ PERCO '
     else
      confirmRequest := 'Построение разности БЕЗ обновления данных PERCO ';

    confirmRequest := confirmRequest + #$D#$A + ' на основании cопоставления';

    if preSavedCatalogue>'' then
      confirmRequest := confirmRequest + #$D#$A +  '"'+preSavedCatalogue+'"'
     else
      confirmRequest := confirmRequest + ' справочника Perco';

    confirmRequest := Concat(confirmRequest,#$D#$A+'и'+#$D#$A,'"'+OpenDialog1.FileName+'"');

    if MessageDlg(confirmRequest, mtWarning, mbOKCancel, 0)<>mrOK then exit;

    if PercoCOM.ProcessingCatalogue(OpenDialog1.FileName, preSavedCatalogue, SaveDialog1.FileName) then
      MessageDlg('Операция завершена успешно',mtInformation,[mbOK],0)
     else
      MessageDlg('Не удалось завершить операцию',mtWarning,[mbCancel],0);
  finally
    OpenDialog1.Filter := 'Все файлы (*.*)|*';
    OpenDialog1.Title := 'Открыть';
  end;

end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if Self.Button5.Caption = 'Дисциплина труДА!' then
   begin
    Self.LabeledEdit1.Text := PROC_STAFF_CROSSES_GET;
    Self.CheckBox1.Checked := True;
    DataPool.extproc := DatasetToArray;
    Self.Button5.Caption := 'Загрузка документов';
   end
   else
   begin
    Self.LabeledEdit1.Text := PROC_DOCS_INS;
    Self.CheckBox1.Checked := False;
    DataPool.extproc := nil;
    Self.Button5.Caption := 'Дисциплина труДА!';
   end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  self.Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
const FILEINI = 'PercoDataLoader.ini';
//var  iniFile: TINIFile;
     //fileini: string;
//     dbfile: string;
begin
  inherited;

  Application.ShowMainForm:=False;
  with FIconData do begin
    cbSize:=SizeOf(FIconData);
    Wnd:=Handle;
    uID:=100;
    uFlags:=NIF_MESSAGE+NIF_ICON+NIF_TIP;
    uCallbackMessage:=WM_USER+1;
    hIcon:=Application.Icon.Handle;
    szTip:='Perco Data Loader';
  end;
  // Все готово - помещаем иконку в System Tray
  Shell_NotifyIcon(NIM_ADD, @FIconData);

  Self.Caption := 'Perco Data Kit';
  Self.BitBtn1.Caption := 'DO!';

  Self.LabeledEdit1.EditLabel.Caption := 'Perco Stored Procedure Kit';
  Self.LabeledEdit1.Text := PROC_DOCS_INS;

  PercoImport:= TPercoDataLoader.Create();
  PercoCOM := TPercoCOMProcessor.Create();  //self.XMLDocument1
  ScanDaemon := TPercoDataScaner.Create();

//  dbfile:=InputBox('Perco Import Direct','Perco Database Local Path', 'd:\WORK\perco\SCD17K.FDB');
  //fileini :=  ChangeFileExt(Paramstr(0),'.ini');
  PercoCOM.Init(ExtractFilePath(Paramstr(0))+FILEINI);
  ScanDaemon.Init(ExtractFilePath(Paramstr(0))+FILEINI);

  PercoImport.Init(ExtractFilePath(Paramstr(0))+FILEINI);


  Self.Button1.Caption := 'Операция справочника (CSV-параметризированный запрос)';
  Self.Button2.Caption := 'Команда файла разметки (XML-параметризированный запрос)';
  Self.Button3.Caption := 'Выгрузить/Загрузить данные';
  Self.Button4.Caption := 'Синхронизировать справочники';

  Self.Button5.Caption := 'Дисциплина труДА!';

  Self.Edit1.Text := '';
  Self.CheckBox1.Caption := 'Первая строка содержит имена параметров';
  //Self.Button4.Caption := 'Unlock/Lock';
  Self.CheckBox2.Caption := 'Только сопоставить файлы';

  Self.RadioGroup1.Caption := 'Справочник для внешнего обновления';
  Memo1.Clear;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(PercoImport);
  FreeAndNil(PercoCOM);

  Shell_NotifyIcon(NIM_DELETE, @FIconData);
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  ShowWindow(Handle, SW_NORMAL);
  self.Show;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  Self.Button3.Enabled := Self.RadioGroup1.ItemIndex+1 >0
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Self.SpeedButton1.Enabled := False;
  Self.Timer1.Enabled := True;

  Self.SpeedButton2.Caption := #8;//Self.SpeedButton2.Color := clRed;
  Self.SpeedButton2.Font.Size := 24;
  Self.SpeedButton2.Font.Color := clRed;
  Self.SpeedButton2.Enabled := True;

  if Trim(Self.Edit1.Text) = '' then exit;

  Self.Edit1.Enabled := False;
  Self.IBQuery1.Prepare;
  Self.IBQuery1.ParamByName('P_TABEL_ID').Value := Trim(Self.Edit1.Text);
  Self.IBQuery1.ParamByName('P_UNLOCK_SPIN').Value := 1;
  Self.IBQuery1.ExecSQL;

end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  Self.SpeedButton2.Enabled := False;
  Self.Timer1.Enabled := False;

  Self.SpeedButton1.Caption := #7;// Color := clGreen;
  Self.SpeedButton1.Font.Size := 24;
  Self.SpeedButton1.Font.Color := clGreen;  
  Self.SpeedButton1.Enabled := True;

  if Trim(Self.Edit1.Text) = '' then exit;

  Self.Edit1.Enabled := True;
  Self.IBQuery1.Prepare;
  Self.IBQuery1.ParamByName('P_TABEL_ID').Value := Trim(Self.Edit1.Text);
  Self.IBQuery1.ParamByName('P_UNLOCK_SPIN').Value := 0;
  Self.IBQuery1.ExecSQL;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Self.Timer1.Enabled := False;
  Self.Timer1.Interval := ScanDaemon.ScanInterval;
  if ScanDaemon.ScanInterval > 0 then
    ScanDaemon.Scan; //ScanDaemon.Resume;
  try
   ScanDaemon.ScenAct;
  except
    on E: Exception do
   ShowMessage(E.Message);
  end;
  Self.Timer1.Enabled := True;
end;

procedure TForm1.WndProc(var Msg: TMessage);
var
  Pt: TPoint;
begin
  inherited;
  if Msg.Msg=WM_USER+1 then begin
    case Msg.LParam of
      WM_LBUTTONDBLCLK:
        begin
            ShowWindow(Handle, SW_NORMAL);
            self.Show;
        end;
      WM_LBUTTONDOWN:
        begin
          SetForegroundWindow(Handle);      // Восстанавливаем программу в качестве переднего окна
          GetCursorPos(Pt);                  // Запоминаем координаты курсора мыши
          PopupMenu1.Popup(Pt.X,Pt.Y);        // Показываем pop-up меню
          PostMessage(Handle,WM_NULL,0,0)   // Обнуляем сообщение
        end;
      WM_RBUTTONDOWN:  // Нажата правая кнопка мыши - показываем pop-up меню
        begin
          SetForegroundWindow(Handle);      // Восстанавливаем программу в качестве переднего окна
          GetCursorPos(Pt);                  // Запоминаем координаты курсора мыши
          PopupMenu1.Popup(Pt.X,Pt.Y);        // Показываем pop-up меню
          PostMessage(Handle,WM_NULL,0,0)   // Обнуляем сообщение
        end;
    end;
  end;
end;

end.
