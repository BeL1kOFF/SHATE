unit MDM.Catalog.Logic.Consts;

interface

const
  A1_DRAFTCREATE              = 1;
  A2_DRAFTEDIT                = 2;
  A3_DRAFTDELETE              = 3;
  A4_DRAFTRESET               = 4;
  A5_DRAFTREADY               = 5;
  A6_DRAFTTODELETE            = 6;
  A7_DRAFTMERGE               = 7;
  A8_DRAFTANALYSIS            = 8;
  A9_DRAFTAPPROVE             = 9;
  A10_DRAFTIMPORT             = 10;
  A11_TODRAFT                 = 11;
  A12_COPY                    = 12;
  A13_RESTORE                 = 13;
  A14_EXPORT                  = 14;
  A15_VIEWALLDRAFT            = 15;

  // Чистовик
  PROC_TM_ITEMLIST_SEL         = 'tm_itemlist_sel';
  PROC_TM_TODRAFT_UPD          = 'tm_todraft_upd :UserName';
  PROC_TM_TODRAFT_CHECK        = 'tm_todraft_check :UserName';
  PROC_TM_COPYFROM_INS         = 'tm_copyfrom_ins :UserName';
  PROC_TM_RESTORE_UPD          = 'tm_restore_upd';
  PROC_TM_ITEMLIST_DETAILS_SEL = 'tm_itemlist_details_sel :Id_TradeMark';
  PROC_TM_ITEMLIST_EXPORT_META = 'tm_itemlist_export_meta';
  PROC_TM_ITEMLIST_EXPORT      = 'tm_itemlist_export';

  // Черновик
  PROC_TM_DRAFT_ITEMLIST_SEL         = 'tm_draft_itemlist_sel :UserName';
  PROC_TM_DRAFT_ITEM_SEL             = 'tm_draft_item_sel :Id_TradeMarkDraft';
  PROC_TM_DRAFT_ITEM_INS             = 'tm_draft_item_ins :UserName, :Name, :FullName, :Description, :IsOriginal, :Logo, :URLSite, :URLCatalog';
  PROC_TM_DRAFT_ITEM_UPD             = 'tm_draft_item_upd :UserName, :Id_TradeMarkDraft, :Name, :FullName, :Description, :IsOriginal, :Logo, :URLSite, :URLCatalog';
  PROC_TM_DRAFT_DEL                  = 'tm_draft_del';
  PROC_TM_DRAFT_STATUS_CHANGE        = 'tm_draft_status_change :Id_StatusDraft';
  PROC_TM_DRAFT_ANALYSIS             = 'tm_draft_analysis';
  PROC_TM_DRAFT_APPROVE              = 'tm_draft_approve';
  PROC_TM_DRAFT_ITEMLIST_DETAILS_SEL = 'tm_draft_itemlist_details_sel :Id_TradeMarkDraft';
  PROC_TM_DRAFT_MERGE_META           = 'tm_draft_merge_meta';
  PROC_TM_DRAFT_MERGE_SEL            = 'tm_draft_merge_sel :Id_TradeMarkDraft';
  PROC_TM_DRAFT_MERGE                = 'tm_draft_merge :UserName, :Version';

implementation

end.
