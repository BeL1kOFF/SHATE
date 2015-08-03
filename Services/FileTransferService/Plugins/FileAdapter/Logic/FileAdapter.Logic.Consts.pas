unit FileAdapter.Logic.Consts;

interface

const
  // Загрузка sender адаптера
  PROC_SEL_FILESENDER = 'sel_filesender :Id_ProcessingSender';
  PARAM_ID_PROCESSINGSENDER = 'Id_ProcessingSender';
  FLD_SOURCEDIRECTORY = 'SourceDirectory';

  // Загрузка receiver адаптера
  PROC_SEL_FILERECEIVER = 'sel_filereceiver :Id_ProcessingReceiver';
  PARAM_ID_PROCESSINGRECEIVER = 'Id_ProcessingReceiver';
  FLD_TARGETDIRECTORY = 'TargetDirectory';

resourcestring
  rsFindFile = 'Найден файл %s';
  rsSendFileReceiver = 'Файл отправляется получателям...';

  rsSendFileComplite = 'Файл отправлен получателю';
  rsFileExists = 'Файл %s уже существует в целевой директории';

implementation

end.
