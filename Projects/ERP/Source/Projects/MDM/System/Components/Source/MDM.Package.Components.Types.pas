unit MDM.Package.Components.Types;

interface

type
  TActionEnableMethod = (aemInner, aemOuter, aemBoth);

  TCatalogActionPropertyType = (aptRefresh, aptMoveToDraft, aptCopyFrom, aptRestore, aptDraftRefresh,
                                aptDraftAdd, aptDraftEdit, aptDraftDelete, aptDraftStatusReset, aptDraftStatusReady,
                                aptDraftStatusDelete, aptDraftMerge, aptDraftAnalysis, aptDraftApprove,
                                aptExport, aptDraftImport);
  TCatalogActionPropertyTypes = set of TCatalogActionPropertyType;

  TCatalogType = (ctDraft, ctClean);

  TServiceType = (stUnknown, stMetaData, stEnabled, stStatus, stCondition, stPKClean, stPK);

  TActionInitInfo = record
    Caption: string;
  end;

const
  ACTION_INFO: array[TCatalogActionPropertyType] of TActionInitInfo = ((Caption: 'Обновить'),
                                                                       (Caption: 'В черновик'),
                                                                       (Caption: 'Копия из'),
                                                                       (Caption: 'Восстановить'),
                                                                       (Caption: 'Обновить'),
                                                                       (Caption: 'Новый...'),
                                                                       (Caption: 'Редактировать...'),
                                                                       (Caption: 'Удалить'),
                                                                       (Caption: 'Начальный'),
                                                                       (Caption: 'Готов'),
                                                                       (Caption: 'К удалению'),
                                                                       (Caption: 'Слияние...'),
                                                                       (Caption: 'Анализировать'),
                                                                       (Caption: 'Утвердить'),
                                                                       (Caption: 'Экспорт...'),
                                                                       (Caption: 'Импорт...'));

implementation

end.
