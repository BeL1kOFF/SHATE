unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs
  ,ADODB, DB, DBCtrls, StdCtrls, JvExControls, JvDBLookup
  ,UNitExportsManager, JvExStdCtrls, JvDBCombobox, JvLabel, Mask, ExtCtrls,
  JvExMask, JvToolEdit, JvDBControls, ComCtrls, JvExComCtrls, JvDateTimePicker,
  JvDBDateTimePicker, Buttons, JvSpin, JvDBSpinEdit, JvDBLookupComboEdit,
  JvDBCheckBox, JvHtControls, JvStaticText, JvgLabel, JvBehaviorLabel
  ,Unit5, AclSimple;

type
  TForm2 = class(TForm)
    LabeledEdit1: TLabeledEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    JvDBSpinEdit1: TJvDBSpinEdit;
    JvDBLookupComboEdit1: TJvDBLookupComboEdit;
    JvDBLookupCombo1: TJvDBLookupCombo;
    JvDBCheckBox1: TJvDBCheckBox;
    DBEdit3: TDBEdit;
    JvBehaviorLabel1: TJvBehaviorLabel;
    Panel1: TPanel;
    JvLabel1: TJvLabel;
    JvDBComboBox1: TJvDBComboBox;
    JvDBDateEdit1: TJvDBDateEdit;
    JvDBDateEdit2: TJvDBDateEdit;
    JvDBDateTimePicker1: TJvDBDateTimePicker;
    JvDBDateTimePicker2: TJvDBDateTimePicker;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Button1: TButton;
    Panel2: TPanel;
    JvgLabel2: TJvgLabel;
    JvgLabel3: TJvgLabel;
    JvgLabel1: TJvgLabel;
    DBEdit1: TDBEdit;
    JvDirectoryEdit1: TJvDirectoryEdit;
    JvFilenameEdit1: TJvFilenameEdit;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBEdit2: TDBEdit;
    DBMemo1: TDBMemo;
    JvStaticText1: TJvStaticText;
    Panel3: TPanel;
    DBText1: TDBText;
    DBLookupComboBox3: TDBLookupComboBox;
    Label3: TLabel;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    JvDBComboBox2: TJvDBComboBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure JvDBComboBox1Enter(Sender: TObject);
    procedure JvDBComboBox1DropDown(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure DBEdit1Enter(Sender: TObject);
    procedure DBEdit2Enter(Sender: TObject);
    procedure JvFilenameEdit1Enter(Sender: TObject);
    procedure JvDBDateTimePicker2Click(Sender: TObject);
    procedure JvDBDateTimePicker1Click(Sender: TObject);
    procedure DBLookupComboBox1CloseUp(Sender: TObject);
    procedure DBLookupComboBox2CloseUp(Sender: TObject);
    procedure DBEdit2DblClick(Sender: TObject);
    procedure DBEdit1DblClick(Sender: TObject);
    procedure JvFilenameEdit1DblClick(Sender: TObject);
    procedure DBLookupComboBox3CloseUp(Sender: TObject);
    procedure JvDBComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure JvDBDateEdit2ButtonClick(Sender: TObject);
    procedure JvDBDateEdit1ButtonClick(Sender: TObject);
    procedure Panel4DblClick(Sender: TObject);
    procedure JvFilenameEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure JvFilenameEdit1BeforeDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure JvFilenameEdit1AfterDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure JvDBComboBox2Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    uploadsWH, uploadsCY: TStringList;
  public
    { Public declarations }
    FieldsControls: array[1..17] of TWinControl;
    fieldsindex: integer;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  if MessageDlg('Вы действительно хотите запретить этот экспорт?',mtWarning,mbYesNo,0)<>mrYes then exit;
  
  Form2.JvDBDateTimePicker2.DateTime := 0;
  Manager.ExportsTbl.Edit;
  Manager.ExportsTbl.FieldByName('Interval').Value := NULL; //fix switch of error  05.05.2014
  Manager.ExportsTbl.FieldByName('blocked').Value := NULL;  //increase procession speed
  Form2.JvDBComboBox1.ItemIndex := 8 -1;
  Manager.ExportsTbl.FieldByName('Next_Export').Value := NULL;
end;

procedure TForm2.DBEdit1DblClick(Sender: TObject);
var Keyboard: TKeyboardState;
begin
  GetKeyboardState(Keyboard);
  if (Keyboard[VK_CONTROL] AND 128 = 0) then Form5.ShowModal
   else
   begin
    self.DBEdit1.ReadOnly := not(self.DBEdit1.ReadOnly);  
    self.DBEdit1.ParentColor := not (self.DBEdit1.ParentColor);
      Form2.DBEdit1.SelStart:=0;
  Form2.DBEdit1.SelLength := Length(Trim(DBEdit1.DataSource.DataSet.FieldByName(DBEdit1.DataField).AsString));
   end;
  if not(self.DBEdit1.ParentColor OR self.DBEdit1.ReadOnly) then self.DBEdit1.Color := clWindow;
end;

procedure TForm2.DBEdit1Enter(Sender: TObject);
begin
  if Form2.DBEdit1.ReadOnly then exit;
  
  Form2.DBEdit1.SelStart:=0;
  Form2.DBEdit1.SelLength := Length(Trim(DBEdit1.DataSource.DataSet.FieldByName(DBEdit1.DataField).AsString));
end;

procedure TForm2.DBEdit2DblClick(Sender: TObject);
begin
  self.DBEdit2.ReadOnly := not(self.DBEdit2.ReadOnly);

  self.DBEdit2.ParentColor := not (self.DBEdit2.ParentColor);
  if not(self.DBEdit2.ParentColor OR self.DBEdit2.ReadOnly) then self.DBEdit2.Color := clWindow;

  self.DBEdit2Enter(Sender);
end;

procedure TForm2.DBEdit2Enter(Sender: TObject);
var l: integer;
begin
  l:= Length(Trim(DBEdit2.DataSource.DataSet.FieldByName(DBEdit2.DataField).AsString));
  if Form2.DBEdit2.ReadOnly then
   begin
    Form2.DBEdit2.SelStart:=0;
    Form2.DBEdit2.SelLength := l
   end
   else
   begin
    Form2.DBEdit2.SelStart:= l+1;
    Form2.DBEdit2.SelLength := 100-l;
   end;
end;

procedure TForm2.DBLookupComboBox1CloseUp(Sender: TObject);
begin

  Form2.JvFilenameEdit1.Text := Manager.generateFileName;
  if not(Form2.DBEdit2.ReadOnly) then  exit;
  Form2.DBEdit2.Text := Manager.generateMailSubject;
end;

procedure TForm2.DBLookupComboBox2CloseUp(Sender: TObject);
begin
  //if not(Manager.newExport) then  exit;
  if Form2.JvFilenameEdit1.ReadOnly then
    Form2.JvFilenameEdit1.Text := Manager.generateFileName;
  if not(Form2.DBEdit2.ReadOnly) then  exit;
  Form2.DBEdit2.Text := Manager.generateMailSubject;
end;

procedure TForm2.DBLookupComboBox3CloseUp(Sender: TObject);
begin
  if Manager.TemplatesTbl.Active then
    Form2.LabeledEdit1.Text := Manager.TemplatesTbl.FieldByName('CSV').AsString;
end;

procedure TForm2.FormActivate(Sender: TObject);
begin
 //Form2.JvDBDateTimePicker1.Checked:=not JvDBDateTimePicker1.DataSource.DataSet.FieldByName(JvDBDateTimePicker1.DataField).IsNull;
 //Form2.JvDBDateTimePicker2.Checked:=not JvDBDateTimePicker2.DataSource.DataSet.FieldByName(JvDBDateTimePicker2.DataField).IsNull;
 ;
  if Manager.newExport then Manager.ClientsTbl.Locate('ID',Manager.ClientID,[])
   else
   begin  //при связанной навигации если не выполнить перемещение в таблице клиентов возникает ошибка
    if Manager.ClientID>0 then Manager.ClientsTbl.Locate('ID',Manager.ClientID,[]);
    
    if not Manager.ExportsTbl.Locate('ID',Manager.ExportID,[]) then
      MessageDlg('Не удалось открыть экспорт!'+ IntToStr(GetLastError),mtError,[mbCancel],0);
   end;
 if Manager.newExport then self.Caption := 'Новый экспорт для клиента '
  else self.Caption := 'Экспорт для клиента ';
 self.Caption:= self.Caption+Manager.ExportsTbl.FieldByName('NAV_client').AsString
                +Manager.ClientsTbl.FieldByName('Name').AsString;

 if Manager.ExportsTbl.FieldByName('FILE_NAME').AsString = '' then
  begin
    Form2.JvDirectoryEdit1.Text := Manager.defaultfolder;
    Form2.JvFilenameEdit1.Text := 'export_'+'<city>'+'_'
     +trim(Manager.ExportsTbl.FieldByName('CY').AsString)+'_'
     +trim(Manager.ExportsTbl.FieldByName('NAV_client').AsString)+ '.csv';
  end
  else
  begin
   Form2.JvDirectoryEdit1.Text := ExtractFileDir(Manager.ExportsTbl.FieldByName('FILE_NAME').AsString);
   //if Form2.JvDirectoryEdit1.Text=''  then
   Form2.JvDirectoryEdit1.InitialDir := ExtractFileDir(Manager.ExportsTbl.FieldByName('FILE_NAME').AsString);
   Form2.JvFilenameEdit1.InitialDir :=  Form2.JvDirectoryEdit1.Text;
   Form2.JvFilenameEdit1.Text :=  ExtractFileName(Manager.ExportsTbl.FieldByName('FILE_NAME').AsString);
  end;
 //ошибка поскольку мешает генерации названия файла
 //Form2.JvFilenameEdit1.ReadOnly := (trim(Form2.JvFilenameEdit1.Text)='');
 Form2.DBEdit1.ReadOnly := True;//(trim(Form2.DBEdit1.Text) = ''); fix 06.05.2014 запрет по дефолту
 Form2.DBEdit2.ReadOnly := (trim(Form2.DBEdit1.Text) = '');
 Form2.DBEdit1.ParentColor :=  Form2.DBEdit1.ReadOnly;
 Form2.DBEdit2.ParentColor :=  Form2.DBEdit2.ReadOnly;

 if Form2.DBEdit1.Text = '' then Form2.DBEdit1.Text := Manager.ClientsTbl.FieldByName('e_mail').AsString;
 //if Form2.DBEdit2.Text = '' then Form2.DBEdit2.Text := 'Склад '+ 'Город' +' Актуальное предложение Шате-М ПЛЮС';

 Form2.JvDBDateTimePicker1.Checked := NOT Manager.ExportsTbl.FieldByName('blocked').AsBoolean; //индикация блокировки

// if self.fieldsindex = 0 then self.SetFocus
// else self.SetFocusedControl(self.FieldsControls[self.fieldsindex]);
 //self.ActiveControl:=self.FieldsControls[self.fieldsindex];
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Manager.TemplatesTbl.Close;
end;

procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var keyBoard : TKeyboardState;
begin
  GetKeyboardState(Keyboard);
  CanClose := ((Keyboard[vk_Control] or Keyboard[VK_SHIFT]) and 128) = 0;
  if CanClose then
   if ModalResult=mrOK then
    CanClose:= (
    MessageDlg('Сохранить изменения?',mtConfirmation,[mbYes,mbCancel],0)=mrYes
    )
    else
    CanClose:= (
    MessageDlg('Выйти без сохранения?',mtConfirmation,[mbYes,mbCancel],0)=mrYes
    );
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FieldsControls[1] := Form2.JvDBSpinEdit1;
  FieldsControls[2] := Form2.JvDBLookupComboEdit1;// nil;//Box1;
  FieldsControls[3]:=Form2.DBLookupComboBox1;
  FieldsControls[4]:=Form2.DBLookupComboBox2;
  FieldsControls[12]:=Form2.DBLookupComboBox3;

  FieldsControls[7]:=Form2.JvDBLookupCombo1;
  FieldsControls[5]:=Form2.JvDBCheckBox1;

  FieldsControls[6]:=Form2.DBEdit3;//Price  nil

  FieldsControls[8]:=Form2.JvDBComboBox1;
  FieldsControls[9]:=Form2.JvDBDateTimePicker1;
  FieldsControls[10]:=Form2.JvDBDateTimePicker2;

  FieldsControls[13]:=Form2.DBCheckBox1;
  FieldsControls[14]:=Form2.DBEdit1;
  FieldsControls[15]:=Form2.DBEdit2;
  FieldsControls[16]:=Form2.DBMemo1;
  FieldsControls[17]:=Form2.DBCheckBox2;


  FieldsControls[11]:=Form2.JvFilenameEdit1;

  Form2.Caption := 'Просмотр таблицы экспортов';
  
  Form2.Label1.Caption := 'Склад выгрузки';
  Form2.Label2.Caption := 'Валюта выгрузки';
  Form2.Label3.Caption := 'Шаблон выгрузки';


  Form2.JvLabel1.Caption := 'Периодичность выгрузки';
  Form2.StaticText1.Caption := 'Предыдущий экспорт';
  Form2.StaticText2.Caption := 'Следующий экспорт';

  Form2.DBCheckBox1.Caption := 'Рассылка на e-mail';
  Form2.DBCheckBox2.Caption := 'Сжать в .zip-архив';

  Form2.JvDBCheckBox1.Caption := 'блокировка';


  Form2.JvStaticText1.Caption := 'Файл:';
  Form2.JvgLabel1.Caption :='mail to:';
  Form2.JvgLabel2.Caption :='subject:';
  Form2.JvgLabel3.Caption :='body:';
//  Form2.JvDBDateTimePicker1.Kind TDateTimeKind

  Form2.JvBehaviorLabel1.Caption := 'Метка: ';

  Form2.Button1.Caption := 'ОТКЛЮЧИТЬ ЭКСПОРТ';

  Form2.uploadsWH := TStringList.Create;
  Form2.uploadsCY := TStringList.Create;
end;

procedure TForm2.FormDeactivate(Sender: TObject);
begin
try
   if Form2.ModalResult = mrOK then
    begin
      Manager.ExportsTbl.Edit;

      //подчищает ошибку с предстоящим слэшем
      if length(JvDirectoryEdit1.Text)>1 then
       if (JvDirectoryEdit1.Text[1]='\') AND (JvDirectoryEdit1.Text[2]<>'\') then
        JvDirectoryEdit1.Text:=copy(JvDirectoryEdit1.Text,2);
      //способ напрямую ввести директорию
      if (Copy(JvFilenameEdit1.Text,2,2)=':\') OR (Copy(JvFilenameEdit1.Text,1,2)='\\') then
       begin
        JvDirectoryEdit1.Text:=ExtractFilePath(JvFilenameEdit1.Text);//''
        JvFilenameEdit1.Text :=ExtractFileName(JvFilenameEdit1.Text);
       end
       else
        if JvFilenameEdit1.Text[1]='\' then
         begin
          JvDirectoryEdit1.Text:='';
          JvFilenameEdit1.Text :=ExtractFileName(JvFilenameEdit1.Text);
         end;
      if (JvDirectoryEdit1.Text='') then
        if (Manager.ExportsTbl.FieldByName('Interval').Value<>NULL) then JvDirectoryEdit1.Text := Manager.defaultfolder;

      JvDirectoryEdit1.Text := IncludeTrailingPathDelimiter(JvDirectoryEdit1.Text);
      Manager.ExportsTbl.FieldByName('FILE_NAME').Value := Concat(JvDirectoryEdit1.Text,Trim(JvFilenameEdit1.Text));

      if Manager.newExport OR (Form2.JvDBDateTimePicker1.Checked AND Form2.JvDBDateTimePicker2.Checked) then Manager.ExportsTbl.FieldByName('blocked').Value:= False;

      //проверка до проверки поля даты
      if Manager.ExportsTbl.FieldByName('blocked').Value<>NULL then    //на поля с типом блокировки NULL не разрешается влиять
        Manager.ExportsTbl.FieldByName('blocked').Value:= NOT Form2.JvDBDateTimePicker1.Checked; //управление блокировкой

      if Form2.JvDBDateEdit1.Date=0 then  Manager.ExportsTbl.FieldByName('Last_Export').Value := NULL
       else if Form2.JvDBDateEdit1.Date = 2 then Manager.ExportsTbl.FieldByName('Last_Export').Value:=DatetimeToStr(Form2.JvDBDateEdit1.Date);
        //    else Manager.ExportsTbl.FieldByName('Last_Export').Value := DatetimeToStr(Form2.JvDBDateEdit1.Date+Form2.JvDBDateTimePicker1.Time);



      if not Form2.JvDBDateTimePicker2.Checked then Manager.ExportsTbl.FieldByName('Next_Export').Value := NULL;
      //if Form2.JvDBDateEdit2.Date=0 then  Manager.ExportsTbl.FieldByName('Next_Export').Value := NULL;
      //else Manager.ExportsTbl.FieldByName('Next_Export').Value := DatetimeToStr(Form2.JvDBDateEdit2.Date+Form2.JvDBDateTimePicker2.Time);

      //проверка настроек валюта/склад/шаблон
      with Manager.ExportsTbl do 
      if not FieldByName('Interval').IsNull then
       if FieldByName('CY').IsNull OR FieldByName('ID_WH').IsNull OR FieldByName('ID_TEMPL').IsNull then
        begin
          if MessageDlg('                          В Н И М А Н И Е!!!'+ #$D#$A
                       +' Экспорт, для которого не указаны склад, валюта или шаблон не может быть активным!' //
                       +' Выполненные настройки будут сохранены, но экспорт не будет выполняться'+#$D#$A+#$D#$A
                       +'Если Вы нажмёте "Ignore" Вам потребуется заново открыть карточку экспорта чтобы исправить настройки и включить экспорт'+#$D#$A
                       +'Нажмите "Abort" чтобы отказаться от всех изменений', mtWarning,mbAbortIgnore,0) = mrAbort then 
           begin 
            Manager.ExportsTbl.CancelUpdates; 
            Exit; 
           end
          else FieldByName('INTERVAL').Value := NULL; 
        end;
       
      
      
      Manager.ExportsTbl.Post;

    end
   else Manager.ExportsTbl.CancelUpdates;
   Form2.fieldsindex := 0;
except on Err: Exception do
  MessageDlg(Err.Message,mtError,[mbAbort],0);
end;
  Manager.newExport := false;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FreeAndNil(self.uploadsWH);
  FreeAndNil(self.uploadsCY);
end;

procedure TForm2.FormShow(Sender: TObject);
var whNo,LookUpRes: Variant;
begin
  Manager.WarehousesTbl.Open;
  Form2.DBLookupComboBox1.DataSource := Manager.ExportsSrc;  //DataSource2;
  Form2.DBLookupComboBox1.DataField := 'ID_WH';
  Form2.DBLookupComboBox1.ListSource := Manager.WarehousesSrc; //DataSource1;
  Form2.DBLookupComboBox1.ListField := 'City';{ID;Code;}
  Form2.DBLookupComboBox1.KeyField:='ID';
    //Form2.ADOTable1.Active:=True;

  Manager.CurrenciesTbl.Open;
  Form2.DBLookupComboBox2.DataSource := Manager.ExportsSrc;  //DataSource2;
  Form2.DBLookupComboBox2.DataField := 'CY';
  Form2.DBLookupComboBox2.ListSource := Manager.CurrenciesSrc; //DataSource1;
  Form2.DBLookupComboBox2.ListField := 'CY';
  Form2.DBLookupComboBox2.KeyField:='cy';



  Manager.TemplatesTbl.Open;
  Form2.DBLookupComboBox3.DataSource := Manager.ExportsSrc;  //DataSource2;
  Form2.DBLookupComboBox3.DataField := 'ID_TEMPL';
  Form2.DBLookupComboBox3.ListSource := Manager.TemplatesSrc; //DataSource1;
  Form2.DBLookupComboBox3.ListField := 'ID;LABEL;CSV'; //
  Form2.DBLookupComboBox3.KeyField:='ID';
  Form2.DBText1.DataSource := Manager.TemplatesSrc;
  Form2.DBText1.DataField := 'CSV';

  Form2.DBLookupComboBox3.ReadOnly := Form2.DBLookupComboBox3.Text<>Manager.ExportsTbl.FieldByName('ID_TEMPL').AsString;
  if Form2.DBLookupComboBox3.ReadOnly then  //исправление ошибки чужого шаблона
   begin
    MessageDlg('Внимание! Текущий шаблон экспорта недоступен для редактирования!',mtWarning,[mbOK],0);
    Form2.DBLookupComboBox3.DataSource:=nil;
    Form2.DBText1.DataSource := nil;
    Form2.DBText1.Caption := VarToStr(Manager.TemplatesTbl.Lookup('ID',Manager.ExportsTbl.FieldByName('ID_TEMPL').AsString,'LABEL'));//ID;;CSV
   end;
   //ShowMessage('!'+Concat(Form2.DBLookupComboBox3.Text,'<>',Manager.ExportsTbl.FieldByName('ID_TEMPL').AsString));
  //if not Manager.ExportsTbl.Locate('ID',Manager.ExportID,[]) then exit;
  with Form2.JvDBComboBox1 do
   begin
     ;
     DataSource := Manager.ExportsSrc;
     DataField := 'INTERVAL';
     //Items.Add('Значение отображаемое пользователю вместо нуля');
     //Values.Add('30.12.1899');
   end;
   self.uploadsWH.Clear;   self.uploadsCY.Clear;
   Manager.PriceListsTbl.Open;
   with Form2.JvDBComboBox2 do
   begin
     Items.Clear; Values.Clear;
     Manager.PriceListsTbl.First;
     repeat
       if Manager.PriceListsTbl.FieldByName('Active').AsBoolean then
        begin
          Items.Add(Manager.PriceListsTbl.FieldByName('Name').AsString);
          Values.Add('-'+Manager.PriceListsTbl.FieldByName('ID').AsString);
          LookUpRes:=  Manager.PriceListsTbl.FieldByName('WarehouseNo').Value;
          if not VarIsNull(LookupRes) then
            LookUpRes := Manager.WarehousesTbl.Lookup( 'ID',LookUpRes,'City');
          self.uploadsWH.Add(trim(VarToStr(LookUpRes)));
          self.uploadsCY.Add(trim(Manager.PriceListsTbl.FieldByName('CYCode').AsString));
        end;
       Manager.PriceListsTbl.Next;
     until Manager.PriceListsTbl.Eof;
     ;
     DataSource := Manager.ExportsSrc;
     DataField := 'ID_WH';
     //Items.Add('Значение отображаемое пользователю вместо нуля');
     //Values.Add('30.12.1899');
     Visible := Manager.ExportsTbl.FieldByName('ID_WH').AsInteger<0;
   end;

  Form2.JvDBSpinEdit1.DataSource := Manager.ExportsSrc;
  Form2.JvDBSpinEdit1.DataField := 'Priority';

  Manager.ClientsTbl.Open;
  Form2.JvDBLookupCombo1.DataSource := Manager.ExportsSrc;
  Form2.JvDBLookupCombo1.DataField := 'ID_client';
  Form2.JvDBLookupCombo1.LookupSource := Manager.ClientsSrc;
  Form2.JvDBLookupCombo1.LookupField := 'ID';
  Form2.JvDBLookupComboEdit1.DataSource := Manager.ExportsSrc;
  Form2.JvDBLookupComboEdit1.DataField := 'NAV_client';
  Form2.JvDBLookupComboEdit1.LookupSource := Manager.ClientsSrc;
  Form2.JvDBLookupComboEdit1.LookupField := 'NAV_Client';


  Form2.DBEdit1.DataSource := Manager.ExportsSrc;
  Form2.DBEdit1.DataField := 'email';

  Form2.DBCheckBox1.DataSource := Manager.ExportsSrc;
  Form2.DBCheckBox1.DataField := 'emailflag';

  Form2.DBCheckBox2.DataSource := Manager.ExportsSrc;
  Form2.DBCheckBox2.DataField := 'emailzip';

  Form2.DBEdit2.DataSource := Manager.ExportsSrc;
  Form2.DBEdit2.DataField := 'emailsubj';

  Form2.DBMemo1.DataSource := Manager.ExportsSrc;
  Form2.DBMemo1.DataField := 'emailbody';

  Form2.JvDBDateEdit1.DataSource := Manager.ExportsSrc;
  Form2.JvDBDateEdit1.DataField := 'Last_Export';
  Form2.JvDBDateEdit2.DataSource := Manager.ExportsSrc;
  Form2.JvDBDateEdit2.DataField := 'Next_Export';




  Form2.JvDBDateTimePicker1.DataSource := Manager.ExportsSrc;
  Form2.JvDBDateTimePicker1.DataField := 'Last_Export';
  //JvDBDateTimePicker2.Format:='dd.MM.yyyy H:mm:ss';
  Form2.JvDBDateTimePicker2.DataSource := Manager.ExportsSrc;
  Form2.JvDBDateTimePicker2.DataField := 'Next_Export';

//  JvDBComboBox1.

  Form2.JvDBCheckBox1.DataSource := Manager.ExportsSrc;
  Form2.JvDBCheckBox1.DataField := 'blocked';

  Form2.DBEdit3.DataSource := Manager.ExportsSrc;
  Form2.DBEdit3.DataField := 'Price';


//  if self.fieldsindex = 0 then self.SetFocus
//   else self.SetFocusedControl(self.FieldsControls[self.fieldsindex]);

  //Form2.JvDBDateTimePicker2.Checked := false;

 if self.fieldsindex = 0 then self.SetFocus
 else self.SetFocusedControl(self.FieldsControls[self.fieldsindex]);

end;

procedure TForm2.JvDBComboBox1Change(Sender: TObject);
begin

   Form2.JvDBDateTimePicker2.Checked :=(Form2.JvDBComboBox1.ItemIndex +1 <> 8)
end;

procedure TForm2.JvDBComboBox1DropDown(Sender: TObject);
begin
  if self.JvDBComboBox1.ItemIndex < 0 then //ShowMessage('');
  begin
    if self.JvDBComboBox1.DataSource.DataSet.FieldByName(self.JvDBComboBox1.DataField).IsNull then exit;

    self.JvDBComboBox1.Items.Add(self.JvDBComboBox1.DataSource.DataSet.FieldByName(self.JvDBComboBox1.DataField).AsString);
    self.JvDBComboBox1.Values.Add(self.JvDBComboBox1.DataSource.DataSet.FieldByName(self.JvDBComboBox1.DataField).AsString);
  end;
end;

procedure TForm2.JvDBComboBox1Enter(Sender: TObject);
begin



  ShowMessage(IntToStr(self.JvDBComboBox1.ItemIndex));
//     self.JvDBComboBox1.Items[
end;

procedure TForm2.JvDBComboBox2Change(Sender: TObject);
begin

  self.JvFilenameEdit1.Text := 'export_'
    + trim(copy('Minsk   Podolsk   Ekaterinburg'
                ,pos(self.uploadsWH.Strings[self.JvDBComboBox2.ItemIndex]
                     , 'Минск   Подольск  Екатеринбург')
                ,length(trim(self.uploadsWH.Strings[self.JvDBComboBox2.ItemIndex]))+2)
           )
    + '_' + StringReplace(self.uploadsCY.Strings[self.JvDBComboBox2.ItemIndex],'RUB','RUR',[rfIgnoreCase])
    + '_' + trim(Manager.ClientsTbl.FieldByName('NAV_Client').AsString)
    +'.csv';

   //Manager.generateFileName;
  if not(Form2.DBEdit2.ReadOnly) then  exit;
  Form2.DBEdit2.Text :=  'Склад '+self.uploadsWH.Strings[self.JvDBComboBox2.ItemIndex] + '.'
    +' Актуальное предложение Шате-М Плюс '
    + '('+ StringReplace(self.uploadsCY.Strings[self.JvDBComboBox2.ItemIndex],'RUB','RUR',[rfIgnoreCase]) +')';

  //Manager.generateMailSubject;
  ;//если поля файла/темы не редактируемые сгенерировать для них название
end;

procedure TForm2.JvDBDateEdit1ButtonClick(Sender: TObject);
begin
   Manager.ExportsTbl.Edit;
   Manager.ExportsTbl.FieldByName('Last_Export').Value := Now;
end;

procedure TForm2.JvDBDateEdit2ButtonClick(Sender: TObject);
begin
   Manager.ExportsTbl.Edit;
   Manager.ExportsTbl.FieldByName('Next_Export').Value := Now +1;
//   Form2.JvDBDateEdit2.Date:=Now+1;
//   Form2.JvDBDateTimePicker2.DateTime :=Now()+1;
end;

procedure TForm2.JvDBDateTimePicker1Click(Sender: TObject);
var KeyboardState: TKeyboardState;
begin


    if trim(Form2.JvDBDateEdit1.EditText) = '.  .' then
     begin
       //GetKeyboardState(KeyboardState);
       //if ((KeyboardState[vk_Control] and 128) = 0) then exit;
       if Form2.JvDBDateTimePicker1.Checked then          //  Не назначено Form2.JvDBDateEdit2.EditText := '';
        begin
          Manager.ExportsTbl.Edit;
          Manager.ExportsTbl.FieldByName('Last_Export').Value := NULL;
          Form2.JvDBDateTimePicker1.NullDate := 0;
          Form2.JvDBDateTimePicker1.NullText := 'Не выполнялся';
          Form2.JvDBDateTimePicker1.DateTime := 0;
        end
        else
        begin
          Manager.ExportsTbl.Edit;
          Manager.ExportsTbl.FieldByName('Last_Export').Value := StrToDatetime('01.01.1900');
          Form2.JvDBDateTimePicker1.NullDate := 2;
          Form2.JvDBDateTimePicker1.NullText := 'Блокирован';//'Активен';
          Form2.JvDBDateTimePicker1.DateTime := 2;
          //Form2.JvDBDateEdit1.EditText := ' .  .    ';
          //exit;
        end;
     end
     else
     begin
      Form2.JvDBDateTimePicker1.NullDate := 0;
      Form2.JvDBDateTimePicker1.NullText :='Активен';   //?
     end;
    Form2.JvDBDateTimePicker1.Checked := not Form2.JvDBDateTimePicker1.Checked;
    Form2.JvDBDateEdit2.DirectInput := Form2.JvDBDateTimePicker2.Checked;

end;

procedure TForm2.JvDBDateTimePicker2Click(Sender: TObject);
var KeyboardState: TKeyboardState;
begin
//showmessage(BoolToStr(Form2.JvDBDateTimePicker2.Checked));

//showmessage(BoolToStr(Form2.JvDBDateTimePicker2.Checked));
  if Form2.JvDBDateTimePicker2.Checked then
   begin
     GetKeyboardState(KeyboardState);
     if ((KeyboardState[vk_Control] and 128) = 0) then exit;
     Form2.JvDBDateEdit2.EditText := '';//  Не назначено
   end;
  Form2.JvDBDateTimePicker2.Checked:=not (Form2.JvDBDateTimePicker2.Checked);
  Form2.JvDBDateEdit2.DirectInput := Form2.JvDBDateTimePicker2.Checked;

end;

procedure TForm2.JvFilenameEdit1AfterDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
const SVC = 'SHATE\shatem_svc';
var Keyboard: TKeyboardState;
begin
  GetKeyboardState(Keyboard);
  AName:=Trim(AName);
  AName:=ExpandUNCFileName(AName);

  if pos(':',AName)=2 then
   AName := Concat('\\',GetComputerNetName,'\',StringReplace(AName,':','$',[]));
  if not DirectoryExists(ExtractFileDir(AName)) then
    AName:=ExtractFileName(AName);
  if not CheckFileAccessRights(ExtractFileDir(AName), SVC) then
    AName:=ExtractFileName(AName);
  if ((Keyboard[VK_SHIFT] and 128) = 0) then exit;
  Manager.OpenExportFile(AName);
end;

procedure TForm2.JvFilenameEdit1BeforeDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
var Keyboard: TKeyboardState;
begin
  AAction:=True;
  GetKeyboardState(Keyboard);
  self.JvFilenameEdit1.EditText := Trim(self.JvFilenameEdit1.EditText);
  if ((Keyboard[vk_Control] and 128) = 0) then exit;
  AAction:=False;
  Manager.OpenExportFile(Manager.ExportsTbl.FieldByName('FILE_NAME').AsString);
end;

procedure TForm2.JvFilenameEdit1DblClick(Sender: TObject);
begin
 self.JvFilenameEdit1.ReadOnly := not(self.JvFilenameEdit1.ReadOnly);

  self.JvFilenameEdit1.ParentColor := not (self.JvFilenameEdit1.ParentColor);
  if not(self.JvFilenameEdit1.ParentColor OR self.JvFilenameEdit1.ReadOnly) then self.JvFilenameEdit1.Color := clWindow;

  Form2.JvFilenameEdit1.SelStart:=0;
  Form2.JvFilenameEdit1.SelLength := Length(Trim(JvFilenameEdit1.Text));  
end;

procedure TForm2.JvFilenameEdit1Enter(Sender: TObject);
begin
  Form2.JvFilenameEdit1.SelStart:=0;
  Form2.JvFilenameEdit1.SelLength := Length(Trim(JvFilenameEdit1.Text));
end;

procedure TForm2.JvFilenameEdit1KeyPress(Sender: TObject; var Key: Char);
var KeyBoard : TKeyboardState;
begin
  if self.JvFilenameEdit1.ReadOnly then
  begin
    GetKeyboardState(Keyboard);
    if ((Keyboard[vk_Control] and Keyboard[VK_RETURN] and 128) = 0) then exit;
    //ShowMessage('!');
    Key:=#0;
    Manager.OpenExportFile(Manager.ExportsTbl.FieldByName('FILE_NAME').AsString);
  end;
end;

procedure TForm2.Panel4DblClick(Sender: TObject);
var keyBoard : TKeyboardState;
begin
  GetKeyboardState(Keyboard);
  if ((Keyboard[vk_Control] and 128) = 0) then exit;
  self.JvDBComboBox2.Visible := not (self.JvDBComboBox2.Visible);
  if self.JvDBComboBox2.Visible = self.DBLookupComboBox1.Enabled then
    self.DBLookupComboBox1.Enabled := not (self.DBLookupComboBox1.Enabled);
  if self.JvDBComboBox2.Visible = self.DBLookupComboBox2.Enabled then
    self.DBLookupComboBox2.Enabled := not (self.DBLookupComboBox2.Enabled);
end;

end.
