unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs
  ,ADODB,DB,DBGrids,ExtCtrls, Grids
  ,UnitExportsManager, StdCtrls;

type
  TForm4 = class(TForm)
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    DBGrid1: TDBGrid;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.FormCreate(Sender: TObject);
begin
  self.Caption := 'Exports Queue';
  self.CheckBox1.Caption := 'Freeze refresh';
end;

procedure TForm4.FormHide(Sender: TObject);
begin
  Form4.Timer1.Enabled := False;
  Form4.ADOQuery1.Close;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
  Form4.ADOQuery1.Connection := Manager.Connection;

  ;
  //ShowMessage(Form4.ADOQuery1.SQL.Text);
  Form4.ADOQuery1.Open;
  Form4.Timer1.Enabled := True;
end;

procedure TForm4.Timer1Timer(Sender: TObject);
var tag: string;
begin
  if Form4.CheckBox1.Checked then exit;

  tag := Form4.ADOQuery1.Fields[0].AsString;
  Form4.ADOQuery1.Close; Form4.ADOQuery1.Open;
  Form4.ADOQuery1.Locate('ID',tag,[]);
end;

end.
 //Form4.ADOQuery1.SQL.Text :=
 { var
  sql string;
begin
  sql := 'SELECT A.ID,ROW_NUMBER() OVER ( ORDER BY stt, ' + #10
       + '							SIGN(stt)*CONVERT(INT,IIF(NEXT_EXPORT<DATEADD(mi, A.INTERVAL,LAST_EXPORT),NEXT_EXPORT,DATEADD(mi, A.INTERVAL,LAST_EXPORT))), ' + #10
       + '							COALESCE(A.Priority,A.ID)	 ' + #10
       + ') AS position , ' + #10
       + 'A.stt,CASE stt ' + #10
       + 'WHEN 0 THEN ''???????????'' ' + #10
       + 'WHEN 1 THEN ''?????????'' ' + #10
       + 'WHEN 2 THEN ''?????'' ' + #10
       + 'WHEN 3 THEN ''??????????'' ' + #10
       + 'WHEN 4 THEN ''?? ?????????????'' ' + #10
       + 'WHEN 5 THEN ''?? ?????'' ' + #10
       + 'WHEN 6 THEN ''?????????????'' ' + #10
       + 'WHEN 7 THEN ''????????'' ' + #10
       + 'END AS ''Status'' ' + #10
       + ',   A.Interval, A.blocked, A.Last_Export, A.Next_Export FROM  ' + #10
       + '( ' + #10
       + '	 ' + #10
       + '	SELECT ID, ex.Priority, ex.INTERVAL, ex.blocked,ex.LAST_EXPORT, ex.NEXT_EXPORT, iif(ISNULL(blocked,0)=0,0/*''???????????''*/,3/*''??????????''*/) AS stt ' + #10
       + '	  ' + #10
       + '	 ' + #10
       + '	FROM Exports ex ' + #10
       + '	WHERE LAST_Export = 0 ' + #10
       + '	 ' + #10
       + '	UNION ' + #10
       + '	 ' + #10
       + '	SELECT ID, ex.Priority, ex.INTERVAL, ex.blocked,ex.LAST_EXPORT, ex.NEXT_EXPORT, iif(ISNULL(blocked,0)=0,1/*''?????????''*/,4/*''?? ?????????????''*/) AS stt	 ' + #10
       + '	FROM Exports ex ' + #10
       + '	WHERE LAST_Export > 0	 ' + #10
       + '	AND IIF(NEXT_EXPORT<DATEADD(mi, ex.INTERVAL,LAST_EXPORT),NEXT_EXPORT,DATEADD(mi, ex.INTERVAL,LAST_EXPORT))<GETDATE() ' + #10
       + '	 ' + #10
       + '	 ' + #10
       + '	UNION ' + #10
       + '	 ' + #10
       + '	SELECT ID, ex.Priority, ex.INTERVAL, ex.blocked,ex.LAST_EXPORT, ex.NEXT_EXPORT, iif(ISNULL(blocked,1)=1,7/*''????????''*/,6/*''?????????????''*/) AS stt	 ' + #10
       + '	FROM Exports ex ' + #10
       + '	WHERE LAST_Export > 0	 ' + #10
       + '	AND NOT(IIF(NEXT_EXPORT<DATEADD(mi, ex.INTERVAL,LAST_EXPORT),NEXT_EXPORT,DATEADD(mi, ex.INTERVAL,LAST_EXPORT))<GETDATE()) ' + #10
       + '	AND DATEDIFF(mi,LAST_EXPORT,NEXT_EXPORT)>0.666*[INTERVAL] ' + #10
       + '	 ' + #10
       + '	UNION ' + #10
       + '	 ' + #10
       + '	SELECT ID, ex.Priority, ex.INTERVAL, ex.blocked,ex.LAST_EXPORT, ex.NEXT_EXPORT, iif(ISNULL(blocked,0)=0,2/*''?????''*/, 5/*''?? ?????''*/) AS stt	 ' + #10
       + '	FROM Exports ex ' + #10
       + '	WHERE LAST_Export > 0	 ' + #10
       + '	AND NOT(IIF(NEXT_EXPORT<DATEADD(mi, ex.INTERVAL,LAST_EXPORT),NEXT_EXPORT,DATEADD(mi, ex.INTERVAL,LAST_EXPORT))<GETDATE()) ' + #10
       + '	AND NOT(DATEDIFF(mi,LAST_EXPORT,NEXT_EXPORT)>0.666*[INTERVAL])	 ' + #10
       + '	 ' + #10
       + ') AS A';
end;}
