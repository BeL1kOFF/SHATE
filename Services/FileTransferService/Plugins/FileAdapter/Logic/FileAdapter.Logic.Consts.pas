unit FileAdapter.Logic.Consts;

interface

const
  // �������� sender ��������
  PROC_SEL_FILESENDER = 'sel_filesender :Id_ProcessingSender';
  PARAM_ID_PROCESSINGSENDER = 'Id_ProcessingSender';
  FLD_SOURCEDIRECTORY = 'SourceDirectory';

  // �������� receiver ��������
  PROC_SEL_FILERECEIVER = 'sel_filereceiver :Id_ProcessingReceiver';
  PARAM_ID_PROCESSINGRECEIVER = 'Id_ProcessingReceiver';
  FLD_TARGETDIRECTORY = 'TargetDirectory';

resourcestring
  rsFindFile = '������ ���� %s';
  rsSendFileReceiver = '���� ������������ �����������...';

  rsSendFileComplite = '���� ��������� ����������';
  rsFileExists = '���� %s ��� ���������� � ������� ����������';

implementation

end.
