unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, InvokeRegistry, Rio, SOAPHTTPClient, WebUniversalExportIntf, WebUniversalExportImpl,
  StdCtrls, Buttons;

type



  { Invokable interfaces must derive from IInvokable }
//  IWebUniversalExport = interface(IInvokable)
//  ['{EC4BAE45-7384-4835-8464-89E0DE034BD8}']
//    function Multiply(Num1: LongInt; Num2: LongInt): Longint; stdcall;
//    { Methods of Invokable interface must not use the default }
//    { calling convention; stdcall is recommended }
//  end;
  TForm1 = class(TForm)
    HTTPRIO1: THTTPRIO;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    BitBtn1: TBitBtn;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  //Invoke: THTTP
  WI: IWebUniversalExport;
implementation

{$R *.dfm}

function IntToBin(int: Integer): string;
var k, m: Integer;
begin
  RESULT:='';
  m := MAXINT;
  repeat
    if int mod 2 = 0 then RESULT:='0'+RESULT else RESULT:='1'+RESULT;
    int:= int div 2;
    m:=m div 2;
  until ( (m=0) OR ((int=0) AND ((length(RESULT) mod 8) = 0) ));
end;


function BinToInt(bin: string): Integer;
var k, m, p, l: Integer;
begin
RESULT:=0;
  bin:=trim(bin);
  l:=Length(bin);
  p:=1;
  for k := l downto 1 do
    begin
      if bin[k]='1' then inc(RESULT,p)
       else if bin[k] <>'0' then exit;
      p:=p*2;
    end;
    
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var NAVCl,e_mail, CY: string; mask, d: integer;
begin
  NAVcl:=trim(Edit1.Text);
  e_mail:=trim(Edit2.Text);
  mask:=StrToInt(Edit3.Text);
  ShowMessage(' Client Exports Mask: '+ IntToBin(WI.getExportsMask(1,NAVcl,e_mail,CY,false)));
end;

procedure TForm1.Button1Click(Sender: TObject);
var NAVCl,e_mail, CY: string; mask, d: integer;
begin
  NAVcl:=trim(Edit1.Text);
  e_mail:=trim(Edit2.Text);
  mask:=BinToInt(Edit3.Text);
  //h:=
  //CY
  ShowMessage('2x2 ='+IntToStr(WI.Multiply(2,2)));
  //e_mail:='';
  ShowMessage(' Client Exports Mask: 0x'+ IntToBin(WI.getExportsMask(1,NAVcl,e_mail,CY,false)));//IntToHex(,4)
  ShowMessage('e-mail: '+e_mail+'; CY='+CY);  CY:='BYR';
  Edit4.Text:= IntToBin(WI.setExportsMask(mask,1,NAVcl,e_mail,CY,true));

  Edit3.Text:=IntTobiN(mask);
  Edit2.Text:=Trim(E_mail);
  Edit1.Text := Trim(NAVcl);

end;

procedure TForm1.Button2Click(Sender: TObject);
var Login,e_mail, CY: string; mask, d, tp: integer;
begin
  //NAVcl:=trim(Edit1.Text);
  e_mail:=trim(Edit2.Text);
  mask:=BinToInt(Edit3.Text);
  Login := 'C516R92C';
ShowMessage(' Client Exports Mask: 0x'+ IntToBin(WI.getUserExportsMask(1,Login,e_mail,CY,tp)));//IntToHex(,4)
  ShowMessage('e-mail: '+e_mail+'; CY='+CY+'; tp='+IntToStr(tp));  CY:='BYR';
  Edit4.Text:= IntToBin(WI.setUserExportsMask(mask,1,Login,e_mail,CY, tp));
  Edit3.Text:=IntTobiN(mask);
  Edit2.Text:=Trim(E_mail);
  Edit1.Text := Trim(Login);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //inherited;
  //self.HTTPRIO1.URL := 'http://localhost:8081/Project1.WebApp';///Program Files/CodeGear/RAD Studio/5.0/source/webmidas/Services Program Files/CodeGear/RAD Studio/5.0/source/webmidas/
  self.HTTPRIO1.WSDLLocation := //'http://localhost:8081/Project1.WebApp.IWebUniversalExport'
                                'http://localhost:8081/Project1.WebApp/wsdl/IWebUniversalExport';
  //self.HTTPRIO1.Service :='WebApp';   self.HTTPRIO1.Port := '';
  WI:= self.HTTPRIO1 as IWebUniversalExport;
  self.HTTPRIO1.HTTPWebNode.ReceiveTimeout := 5*60000;
  self.HTTPRIO1.HTTPWebNode.SendTimeout := 5*60000;
  //ShowMessage(IntToBin(124));
  Edit1.Text := '<NAV Client>';
  Edit2.Text := 'shyngarev@mail.ru';
  Edit3.Text := IntToBin(14);
  Edit4.Text := '<RESULT>';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  WI:=nil;
end;

end.
