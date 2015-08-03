unit _ErrReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TErrReportForm = class(TForm)
    MemErr: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ErrReportForm: TErrReportForm;

implementation
uses
  _Main;
{$R *.dfm}

procedure TErrReportForm.FormCreate(Sender: TObject);
begin
  MemErr.Lines.LoadFromFile(GetAppDir + '!!!.err');
end;

end.
