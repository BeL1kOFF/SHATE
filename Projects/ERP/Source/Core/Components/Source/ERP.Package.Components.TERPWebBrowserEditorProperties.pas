unit ERP.Package.Components.TERPWebBrowserEditorProperties;

interface

uses
  Vcl.Dialogs,
  VCLEditors;

type
  TWebBrowserFileNameProperty = class(TFileNameProperty)
  protected
    procedure GetDialogOptions(Dialog: TOpenDialog); override;
  end;

implementation

{ TWebBrowserFileNameProperty }

procedure TWebBrowserFileNameProperty.GetDialogOptions(Dialog: TOpenDialog);
begin
  inherited GetDialogOptions(Dialog);
  Dialog.Filter := 'Html Files (*.html)|*.html';
end;

end.
