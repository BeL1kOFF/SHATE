unit MDM.Package.Interfaces.ICatalogDraftController;

interface

uses
  MDM.Package.Interfaces.ICustomCatalogController;

type
  ICatalogDraftController = interface(ICustomCatalogController)
  ['{1615DA42-5F05-4EE4-8247-1FC00BA908FD}']
    function UpdateAdd: Boolean;
    function UpdateEdit: Boolean;
    function UpdateDelete: Boolean;
    function UpdateChangeStatusReset: Boolean;
    function UpdateChangeStatusReady: Boolean;
    function UpdateChangeStatusDelete: Boolean;
    function UpdateMerge: Boolean;
    function UpdateAnalysis: Boolean;
    function UpdateApprove: Boolean;
    function UpdateImportDraft: Boolean;
    procedure Add;
    procedure Edit;
    procedure Delete;
    procedure ChangeStatusReset;
    procedure ChangeStatusReady;
    procedure ChangeStatusDelete;
    procedure Merge;
    procedure Analysis;
    procedure Approve;
    procedure ImportDraft;
  end;

implementation

end.
