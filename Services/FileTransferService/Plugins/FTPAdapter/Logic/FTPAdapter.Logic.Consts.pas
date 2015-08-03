unit FTPAdapter.Logic.Consts;

interface

const
  // Загрузка sender адаптера
  PROC_SND_SEL_FTPSENDER = 'sel_ftpsender :Id_ProcessingSender';
  PARAM_SND_ID_PROCESSINGSENDER = 'Id_ProcessingSender';
  FLD_SND_SERVER = 'Server';
  FLD_SND_PORT = 'Port';
  FLD_SND_LOGIN = 'Login';
  FLD_SND_PASSWORD = 'Password';
  FLD_SND_DIRECTORY = 'Directory';

  // Загрузка receiver адаптера
  PROC_REC_SEL_FTPRECEIVER = 'sel_ftpreceiver :Id_ProcessingReceiver';
  PARAM_REC_ID_PROCESSINGRECEIVER = 'Id_ProcessingReceiver';
  FLD_REC_SERVER = 'Server';
  FLD_REC_PORT = 'Port';
  FLD_REC_LOGIN = 'Login';
  FLD_REC_PASSWORD = 'Password';
  FLD_REC_DIRECTORY = 'Directory';

resourcestring
  rsFindFile = 'Найден файл %s';
  rsSendFileReceiver = 'Файл отправляется получателям...';
  rsReadBytesPercent = 'Считано: %d%%';

  rsSendFileComplite = 'Файл отправлен получателю';
  rsFileExists = 'Файл %s уже существует в целевой директории';

implementation

end.
