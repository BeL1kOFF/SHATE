unit MDM.Package.Components.CatalogActionOptions;

interface

uses
  System.Classes,
  MDM.Package.Components.Types;

type
  TCatalogActionOptions = class(TPersistent)
  private
    FEnableExecute: TActionEnableMethod;
    FEnableUpdate: TActionEnableMethod;
  published
    property EnableExecute: TActionEnableMethod read FEnableExecute write FEnableExecute default aemInner;
    property EnableUpdate: TActionEnableMethod read FEnableUpdate write FEnableUpdate default aemInner;
  end;

implementation

end.
