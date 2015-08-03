object ShateM_QOS: TShateM_QOS
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  DisplayName = 'ShateM+ Query order service'
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 245
  Width = 278
  object TCPServer: TIdTCPServer
    Bindings = <>
    DefaultPort = 6003
    OnExecute = TCPServerExecute
    Left = 19
    Top = 17
  end
  object discountsConnection: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=Admin;Persist Security Info=True;Us' +
      'er ID=Admin;Initial Catalog=CLIENT_INFO;Data Source=AMD'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 115
    Top = 15
  end
  object answersConnection: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=Admin;Persist Security Info=True;Us' +
      'er ID=Admin;Initial Catalog=CLIENT_INFO;Data Source=AMD'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 115
    Top = 65
  end
  object HTTPRIO: THTTPRIO
    HTTPWebNode.UseUTF8InHeader = True
    HTTPWebNode.InvokeOptions = [soIgnoreInvalidCerts, soAutoCheckAccessPointViaUDDI]
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soRootRefNodesToBody, soCacheMimeResponse, soUTF8EncodeXML]
    Left = 205
    Top = 78
  end
end
