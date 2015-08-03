object OrdServiceIMAP: TOrdServiceIMAP
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  AllowPause = False
  DisplayName = 'ShateM+ order processing service'
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 256
  Width = 362
  object Zipper: TVCLZip
    OverwriteMode = Always
    KeepZipOpen = True
    PackLevel = 9
    Left = 110
    Top = 18
  end
  object IdIMAP: TIdIMAP4
    Host = '10.0.0.1'
    SASLMechanisms = <>
    MilliSecsToWaitToClearBuffer = 20
    Left = 35
    Top = 20
  end
  object HTTPRIO1: THTTPRIO
    HTTPWebNode.UseUTF8InHeader = True
    HTTPWebNode.InvokeOptions = [soIgnoreInvalidCerts, soAutoCheckAccessPointViaUDDI]
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soRootRefNodesToBody, soCacheMimeResponse, soUTF8EncodeXML]
    Left = 35
    Top = 80
  end
end
