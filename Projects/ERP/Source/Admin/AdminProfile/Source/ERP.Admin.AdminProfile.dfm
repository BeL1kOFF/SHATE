object frmAdminProfile: TfrmAdminProfile
  Left = 0
  Top = 0
  Caption = 'frmAdminProfile'
  ClientHeight = 396
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 46
    Width = 594
    Height = 350
    Align = alClient
    TabOrder = 4
    object tblViewProfiles: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      OnCellDblClick = tblViewProfilesCellDblClick
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnMoving = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsSelection.InvertSelect = False
      OptionsSelection.MultiSelect = True
      OptionsSelection.UnselectFocusedRecordOnExit = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object cxTblProfilesClmn0ProfileID: TcxGridColumn
        Visible = False
      end
      object cxTblProfilesClmn1Name: TcxGridColumn
        Caption = #1055#1088#1086#1092#1080#1083#1100
        HeaderAlignmentHorz = taCenter
        Options.Moving = False
        Width = 93
      end
      object cxTblProfilesClmn2Description: TcxGridColumn
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        HeaderAlignmentHorz = taCenter
        Options.Moving = False
        Width = 79
      end
      object cxTblProfilesClmn3Enabled: TcxGridColumn
        Caption = #1056#1072#1079#1088#1077#1096#1077#1085
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        Options.Moving = False
        Width = 83
      end
    end
    object cxLevel: TcxGridLevel
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1087#1088#1086#1092#1080#1083#1077#1081
      GridView = tblViewProfiles
    end
  end
  object ActionList: TActionList
    Left = 304
    Top = 328
    object actAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnExecute = actAddExecute
    end
    object actEdit: TAction
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      OnExecute = actEditExecute
      OnUpdate = actEditUpdate
    end
    object actDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnExecute = actDeleteExecute
      OnUpdate = actDeleteUpdate
    end
    object actRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      OnExecute = actRefreshExecute
    end
    object actModules: TAction
      Caption = #1052#1086#1076#1091#1083#1080'...'
      ImageIndex = 0
      OnExecute = actModulesExecute
      OnUpdate = actModulesUpdate
    end
    object actFunctions: TAction
      Caption = #1060#1091#1085#1082#1094#1080#1086#1085#1072#1083'...'
      ImageIndex = 1
      OnExecute = actFunctionsExecute
      OnUpdate = actFunctionsUpdate
    end
    object actUsers: TAction
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080'...'
      ImageIndex = 2
      OnExecute = actUsersExecute
      OnUpdate = actUsersUpdate
    end
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    CanCustomize = False
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 304
    Top = 272
    DockControlHeights = (
      0
      0
      46
      0)
    object dxBarManager1Bar1: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 506
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarLargeButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton3'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton4'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton7'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = actAdd
      Category = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Action = actEdit
      Category = 0
    end
    object dxBarLargeButton3: TdxBarLargeButton
      Action = actDelete
      Category = 0
    end
    object dxBarLargeButton4: TdxBarLargeButton
      Action = actRefresh
      Category = 0
    end
    object dxBarLargeButton5: TdxBarLargeButton
      Action = actModules
      Category = 0
    end
    object dxBarLargeButton6: TdxBarLargeButton
      Action = actFunctions
      Category = 0
    end
    object dxBarLargeButton7: TdxBarLargeButton
      Action = actUsers
      Category = 0
    end
  end
  object qrQuery: TFDQuery
    Left = 496
    Top = 240
  end
  object cxImageList: TcxImageList
    Height = 32
    Width = 32
    FormatVersion = 1
    DesignInfo = 21495840
    ImageInfo = <
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000200000004000000020000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000020000000600000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000600000026000000440000002C0000
          000C000000020000000000000000000000000000000000000000000000000000
          000000000000000000000000000E0000003600000046000000280000000A0000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000010000912481C62ACC958A0E9F30E4176AD0004
          08560000002A0000000A00000000000000000000000000000000000000000000
          0000000000020000001C23010070A03E37EBAF5951F1430703A5030000520000
          00260000000A0000000000000000000000000000000000000000000000000000
          0000000000040000001E042542783F9AE4EFA8DEFFFFB8E6FFFFA0DBFFFF4CA3
          E5F10B3F6CA700030552000000280000000A0000000000000000000000000000
          000A02000032560F05A9C66F5DFDEAC6B4FFEAC7B6FFDEA996FFA54737ED3D07
          029D0200004E0000002400000008000000000000000000000000000000000000
          000A000406360F558BB15BBFFEFF98DEFFFFA3E2FFFFA9E5FFFF9DE0FFFF92DC
          FFFF75CEFFFF349AE0EF083B5AA100020350000000260000000A000000141206
          005A963918DBDD996EFFEABD95FFEDC7A1FFEEC7A2FFEABE95FFE6B287FFD88D
          63FFA13D21E93A0901990100004A000000200000000600000000000000060317
          27561F86CCDF5EC8FFFF79D6FFFF86DBFFFF91E0FFFF9EE3FFFF8CDEFFFF81D9
          FFFF73D3FFFF62CBFFFF3BB5E5FF1788BBED04324B9B0001015235160391965B
          22F7E7A363FFEEB676FFF1C182FFF4CB93FFF4CC94FFF2C386FFEEB877FFE9A8
          68FFE19354FFD06733FF93270CE33305009300000038000000040109101A1F9E
          F4F749C2FFFF5ACCFFFF68D3FFFF72D8FFFF81DDFFFF95E3FFFF83DEFFFF72D8
          FFFF62D1FFFF53C8FFFF37B9E7FF22A9DBFF1398D9FF35667FEFA2651CFFB292
          3BFFF4B057FFF9BF66FFFCC870FFFDD488FFFDD489FFFCD082FFFAC269FFF5B3
          59FFEC9E48FFDF8032FFCB561AFFB32906FF4C07009B0000000A02141F281BAB
          FFFF2CBBFFFF44C8FFFF55D0FFFF62D6FFFF75DCFFFF8FE3FFFF7BDEFFFF70D9
          FFFF52CEFFFF43C6FFFF2AB7E8FF19AADCFF13A0DAFF49858EFFB07D14FFBB9B
          23FFFCB643FFFEC354FFFFCD65FFFFD67EFFFFD67EFFFFD783FFFECB67FFFDBA
          49FFF6A639FFE78725FFD76714FFC6490BFF671A04AB0000000A03151F281FB5
          FFFF24C1FFFF27CBFFFF39D4FFFF60DBFFFF6EDCFFFF8CE4FFFF78DEFFFF76DC
          FFFF4FCFFFFF31C3FFFF21BFE9FF1AB8DEFF16ABDCFF509991FFBFA019FFC2AD
          1EFFFFBD27FFFEC83FFFFDD368FFFDD778FFFDD776FFFDDA88FFFBCE6DFFF8B8
          44FFF5A629FFFAA41FFFEE8E19FFDA6B12FF712C07AB0000000A03161F2822BE
          FFFF27CAFFFF31D5FFFF4EE2FFFF6DEBFFFF68EAFFFF8BE8FFFF77DFFFFF81DF
          FFFF5BD8FFFF39D9FFFF23CFEAFF1CC2DFFF18B4DDFF55A994FFC2B21FFFC2BD
          23FFFFCF39FFFFDD59FFFFE778FFFEE572FFFADA70FFF9DC90FFF6D179FFF8C9
          53FFFEC531FFFFB824FFFDA91FFFEC8A18FF7B3C0AAB0000000A04171F2824C5
          FFFF31D2FFFF4FE1FFFF6FECFFFF85F3FFFF7AF5FFFFC2FBFFFF67F3FFFF83F0
          FFFF78F0FFFF54E7FFFF2BD8EBFF1EC9E1FF1ABCDEFF57B396FFC2C023FFC2CE
          34FFFFE25CFFFFED7CFFFFF380FFFFF7A3FFFFF8B3FFFEEF6EFFFDEC83FFFFE7
          72FFFFD84DFFFFC52DFFFFB724FFFAA31DFF834A0DAB0000000A04171F2828CA
          FFFF4FDDFFFF6FEAFFFF72F1FFFF6BF7FFFF88FEFFFF7CFFFFFF96FEFFFF78F9
          FFFF5DF2FFFF60EDFFFF3FE1ECFF22D0E2FF1CC1DFFF57BA98FFC2CD2FFFC2DF
          53FFFFF07CFFFFF76FFFFFFB8CFFFFFDA7FFFFFDA2FFFFFCACFFFFF779FFFFEE
          5EFFFFE55EFFFFD443FFFFC129FFFEB121FF8A580FAB0000000A04181F282DCE
          FFFF6CE5FFFF5EEBFFFF6BF8FFFF62FDFFFF3AFBFFFF37F9FFFF38F7FFFF52F5
          FFFF70F4FFFF60EEFFFF3BE4EDFF29D3DBFF1DC5E0FF59BF9AFFC2D93DFFC2EB
          66FFFFF360FFFFF673FFFFF95AFFFFFB4EFFFFFB4FFFFFF947FFFFF458FFFFEE
          71FFFFE85EFFFFDC45FFFFCB34FFFFB823FF8E6011AB0000000A04181F282DCF
          FFFF4DE2FFFF5CF0FFFF3FEDFFFF32EAFFFF33E7FFFF32E4FFFF31E1FFFF30DE
          FFFF2FDBFFFF36D4EFFF2DAA65FF5EB267FF1DA674FF58BD8AFFC3DE39FFD8E0
          4DFFFFDE52FFFFE238FFFFEA39FFFFEE3DFFFFEF3DFFFFEB3CFFFFE439FFFFD9
          34FFFFD03CFFFFCD48FFFECC40FFFFBE2AFF8F6312A90000000804191F2439D6
          FFFF41DEFFFF3BDBFFFF45DBFFFF48D9FFFF47D6FFFF47D4FFFF45D1FFFF45CE
          FFFF31BAC2FF33A24FFFA1D6A9FFBBE0C0FFAAD8B0FF58AF57FF75A928FFEFBD
          33FFFFCE40FFFFD84DFFFFDE51FFFFE152FFFFE152FFFFDE51FFFFD94FFFFFD2
          4CFFFFC848FFFEBD43FFF6A537FFE78B25FF7B4A0E9100000002000303041364
          7D7E2DB7EAEB55CFFFFF64D1FFFF63CFFFFF62CDFFFF62CBFFFF5FC7FBFF2EA3
          7EFF44A94FFF86D098FF98D5A5FFA7DAB0FF99D4A4FF87CF97FF6AC37CFF3A9F
          38FF89AA37FFF3CF64FFFFD76BFFFFD96CFFFFDA6CFFFFD86BFFFFD46AFFFFCF
          68FFFEC765FFF7B75FFFE18531FD773309950702000C00000000000000000000
          0000000507080C48696A2F99DCDD61BFFFFF81CBFFFF6CBFDBFF239542FF45AA
          50FF63C076FF70CB88FF7DD297FF93DAA9FF7CD296FF6DCB88FF5FC075FF4DB4
          5EFF34A340FF24901CFF8FB049FFF6D484FFFFD889FFFFD689FFFED388FFFCCD
          86FFF2B166FFBF6A1FDB33170440000000000000000000000000000000000000
          0000000000000000000000010102063155562479CCCD108718FF2C9C36FF3FAF
          54FF4EBF6DFF58CA7EFF67D28FFF88DDA9FF6AD492FF5DCC84FF4ABF6BFF3BAF
          53FF299D36FF158E1BFF038003FF378C17FFF6BD75FFF9D4A6FFF6CDA0FFE393
          4EFD7A3B0B930803000C00000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000006008306FF099722FF21AD
          47FF37BF64FF44CB78FF59D68EFF83E1ABFF5ED792FF5CD28BFF37C066FF26AF
          4BFF169B2CFF06850BFF007D00FF006E00EB3E1F055E9F5420BBA5501DC92D13
          033A000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000006009217FF00A32DFF00B3
          41FF0EC45AFF3DD581FF53DB92FF83E6B1FF55DC94FF62DA96FF36C76DFF12B0
          43FF049F29FF008D12FF007E00FF006D00E90000001A00000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000006009F28FF00B340FF06C6
          5AFF25DA7EFF49E99FFF48EDA4FF83F0BDFF4FE39AFF6EE2A5FF41D381FF14C3
          5CFF00AE3BFF009B23FF008609FF006D00E90000001A00000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000600AB36FF07C155FF27DA
          80FF4BEDA4FF66F9BDFF5BFDBEFFCBFEEAFF47FBB4FF5BF4B3FF5CECA9FF32D8
          81FF0BBD51FF00A530FF009015FF006E00E90000001A00000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000600B441FF28D275FF4DE9
          A0FF51F8B4FF54FEBDFFA6FFDCFFC5FFE8FFC0FFE6FF74FDC8FF34F2A2FF35E2
          8FFF27CD6FFF05AF3DFF00971EFF007004E90000001A00000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000602B948FF4CDE92FF39EC
          9CFF40F7ACFF4BFEBAFF59FFBFFF7EFFCDFF71FFC8FF50FFBCFF48FBB5FF40E9
          9BFF1ED06FFF10B74BFF009B24FF007307E90000001A00000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000602BA49FF25D376FF32DD
          87FF10E888FF04F998FF24FEABFF3DFFB5FF36FFB2FF15FEA4FF03F28FFF0CDF
          7AFF23CF6FFF22BC58FF099F2CFF007508E90000001800000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000410AD3FFF18B850FF13CA
          63FF21DD81FF26EC95FF26F6A2FF29FAA8FF28F9A6FF26F29DFF26E68DFF26D7
          7AFF25C665FF1FB24BFF149B2AFF037107DF0000000A00000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000003B0A6609902FDB34C4
          69FF4DD88BFF4DE197FF4DE89FFF4DEBA3FF4DEAA2FF4DE59CFF4DDD92FF4DD3
          85FF4DC675FF33AE4EFF06710FD1001700320000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000100020038
          1254129542CB46CF7DFF72E0A4FF74E3A8FF74E2A7FF74DFA3FF74D99CFF6CCF
          8DFF27A845FB00480A8300020006000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000002C0F40108238B552C77AFD93DEADFF9BDFB1FF69C883FF0E80
          28CD0019042E0000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000001B072C0B6721A1258838CF00460C7C0002
          0006000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFC7FF8FFF81FE03FE007C00FC00100038000
          0001800000018000000180000001800000018000000180000001800000018000
          0001C0000003F000000FFC00001FFE00027FFE0003FFFE0003FFFE0003FFFE00
          03FFFE0003FFFE0003FFFE0003FFFF0007FFFFC00FFFFFF03FFFFFFCFFFFFFFF
          FFFF}
      end
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000040000000A000000100000
          0006000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000012000000501F1B188D544F4BAB1110
          106C0000002A0000000800000002000000020000000200000002000000040000
          000600000006000000080000000A0000000C0000001000000012000000140000
          001200000010020202120505050C000000000000000000000000000000000000
          0000000000000000000000000000000000061F1B1856B6A294FFE4D6CEFFDACC
          C6FB817A75CD1A18177A000000400000002A000000280000002C000000320000
          00380000003E000000440000004A00000050000000520C0C0C66272727875B5B
          5BAB8D8D8DD3BFBFBFF936363664000000000000000000000000000000000000
          0000000000000000000000000000000000004940396EBFADA0FFE5D7CFFFE4D7
          D0FFE5D8D0FFE1D4CCFD918985DF252322B30000009100000083000000830000
          00870202028F161616A7393939BF717171D9A5A5A5F3CCCCCCFFE5E5E5FFE5E5
          E5FFE3E3E3FFE3E3E3FF68686897000000000000000000000000000000000000
          0000000000000000000000000000000000006C5D52ABD0C0B5FFE5D8D1FFE6D8
          D1FFE6D8D1FFE5D8D1FFDFD4CDFFD9CFC9FF85807CF1252525D94D4D4DDB8585
          85EDB7B7B7FDDADADAFFEBEBEBFFE9E9E9FFE8E8E8FFE8E8E8FFE7E7E7FFE6E6
          E6FFE6E6E6FFE5E5E5FF949494C7000000000000000000000000000000000000
          000000000000000000000000000000000000907D6EE5DDCEC6FFE5D9D2FFE6D9
          D2FFE6D9D2FFE0D5CEFFD3CAC4FFADACABFFC7C7C7FFE9E9E9FFEFEFEFFFEEEE
          EEFFEDEDEDFFECECECFFECECECFFEBEBEBFFE7E7E7FFD6D6D6FFC6C6C6FFBEBE
          BEFFBEBEBEFFE5E5E5FFBFBFBFF5010101020000000000000000000000000000
          000000000000000000000000000016131122A38E7EFFE6D9D2FFE7DAD3FFE7DA
          D3FFE6DAD3FFE5D9D2FFD2C8C1FFF1F0F0FFF1F1F1FFF1F1F1FFF0F0F0FFE6E6
          E6FFEEEEEEFFE4E4E4FFC0C0C0FFC0C0C0FFC4C4C4FFD3D3D3FFE3E3E3FFEAEA
          EAFFE9E9E9FFE8E8E8FFDFDFDFFF1111112A0000000000000000000000000000
          00000000000000000000000000003E36315CAC998CFFE6DBD4FFE7DBD4FFE7DB
          D4FFE7DBD4FFE8DBD5FFD3C9C3FFEAE7E5FFF4F4F4FFAEB0CBFF3E43C3FF9899
          B4FFE2E2E2FFEEEEEEFFEFEFEFFFEEEEEEFFEDEDEDFFEDEDEDFFE6E6E6FFD7D7
          D7FFC7C7C7FFD6D6D6FFEBEBEBFF3535355C0000000000000000000000000000
          00000000000000000000000000005F524899C0AFA3FFE9DDD7FFE7DCD5FFE8DC
          D5FFE7DCD6FFE8DCD6FFDAD0CAFFDFDAD8FFF6F6F6FF8994E1FF4C5EE3FF2137
          DEFF5A60BDFFD4D4DFFFDADADAFFC7C7C7FFC1C1C1FFC1C1C1FFC7C7C7FFD5D5
          D5FFE4E4E4FFEBEBEBFFEAEAEAFF6565658D0000000000000000000000000000
          00000000000000000000000000007C6B5DD3D5C7BDFFEADFD9FFE9DED9FFE8DD
          D7FFE9DDD7FFE9DDD7FFE4D9D3FFD2CCC8FFF8F8F7FF6C7CE3FFEBEAEDFFBCC2
          DFFF4E5DDAFF2A2EBEFFE4E4E3FFEBEBEBFFF0F0F0FFEFEFEFFFEFEFEFFFEEEE
          EEFFE5E5E5FFD8D8D8FFECECECFF929292BD0000000000000000000000000000
          000000000000000000000B090812968272FBE2D7D0FFEBE1DBFFEAE1DBFFEAE0
          DAFFE9DED8FFE9DED8FFE9DED8FFCBC3BEFFF7F7F7FFE7E8EAFFDDDDDDFFEAEA
          EAFFF4F3F3FFEAEBF2FFF1F1F1FFE3E3E3FFD3D3D3FFC5C5C5FFC2C2C2FFC2C2
          C2FFCACACAFFDADADAFFEEEEEEFFC0C0C0ED0101010200000000000000000000
          00000000000000000000312B264A9D897AFFECE3DEFFECE3DEFFECE2DDFFEBE2
          DCFFEBE1DCFFE9E0DAFFE9DFDAFFD2CAC4FFEDECEBFFF8F8F8FFDDDDDDFFD7D7
          D7FFCFCFCFFFEEEEEEFFE6E6E6FFD3D3D3FFE2E2E2FFF0F0F0FFF2F2F2FFF1F1
          F1FFF0F0F0FFF0F0F0FFEFEFEFFFE1E1E1FF1010102000000000000000000000
          00000000000000000000574C4485AB9A8EFFEEE6E1FFEDE5E0FFECE4DFFFECE3
          DEFFECE3DDFFECE2DDFFEBE1DCFFE0D7D2FFDFDCDAFFF9F9F9FFD7D7D7FFF8F8
          F8FFEEEEEEFFE1E1E1FFF6F6F6FFF5F5F5FFF1F1F1FFE2E2E2FFD2D2D2FFC4C4
          C4FFC3C3C3FFC3C3C3FFE1E1E1FFF0F0F0FF3131315200000000000000000000
          0000000000000000000074655AC1C5B6ABFFEFE7E3FFEEE6E2FFEEE6E1FFEDE5
          E0FFEDE5E0FFEDE4DFFFECE4DFFFEBE2DDFFD4CFCDFFFAFAFAFFD8D8D8FFFAFA
          FAFFF8F8F8FFD7D7D7FFF8F8F8FFCCCCCCFFC8C8C8FFD7D7D7FFE6E6E6FFF2F2
          F2FFF3F3F3FFF3F3F3FFF2F2F2FFF1F1F1FF6060608300000000000000000000
          00000000000003030206907D6FF5DBCFC7FFF0E9E5FFEFE8E4FFEFE8E3FFEFE7
          E2FFEEE6E2FFEEE6E1FFEDE5E0FFEDE5E0FFD4CECAFFFBFBFBFFE4E4E4FFD9D9
          D9FFDADADAFFEBEBEBFFF9F9F9FFF8F8F8FFF7F7F7FFF7F7F7FFF2F2F2FFE3E3
          E3FFD4D4D4FFC7C7C7FFCDCDCDFFF3F3F3FF909090B300000000000000000000
          00000000000024201C38988677FFE9E1DBFFF1EBE7FFF1EAE6FFF0E9E5FFEFE8
          E4FFEFE8E4FFEFE7E3FFEEE7E2FFEEE6E2FFDDD5D1FFF5F4F4FFFBFBFBFFE7E7
          F2FFC8C8E0FFD6D6D6FFF8F8F8FFE8E8E8FFCFCFCFFFC9C9C9FFC9C9C9FFD7D7
          D7FFE5E5E5FFF2F2F2FFF5F5F5FFF4F4F4FFBEBEBEE300000000000000000000
          0000000000004B413A72A08F82FFF3EDEAFFF2EDEAFFF2ECE8FFF1EBE8FFF1EA
          E7FFF0EAE6FFF0E9E5FFEFE8E4FFEFE8E4FFEDE6E2FFE6E4E3FFFCFCFCFF8289
          D1FF3F4DE2FF7278C9FFD9D9E4FFFBFBFBFFFAFAFAFFF9F9F9FFF8F8F8FFF8F8
          F8FFF3F3F3FFE6E6E6FFD7D7D7FFEDEDEDFFE4E4E4FF0C0C0C16000000000000
          00000000000070635AAFB3A499FFF4F0EDFFF4EEECFFF3EEEAFFF2EDEAFFF2EC
          E9FFF1EBE8FFF1EBE7FFF1EAE6FFF1EAE6FFF0E9E5FFE6E3E1FFFDFDFCFF6D7D
          E5FFC9CFF2FF7D90F6FF424ED5FF9A9BD0FFDCDCDBFFD1D1D1FFCFCFCFFFCBCB
          CBFFC9C9C9FFD6D6D6FFE4E4E4FFF4F4F4FFF5F5F5FF2C2C2C48000000000000
          0000000000008E7E71E9CEC2BAFFF5F1EFFFF5F0EEFFF4EFEDFFF4EFECFFF3EE
          EBFFF3EDEAFFF2ECE9FFF1ECE8FFF1EBE7FFF1EAE7FFE9E4E1FFFAFAFDFFA2AA
          DAFFDBDBDBFFDBDBDBFFB8BCE0FFB4B6EDFFF2F2F2FFFAFAFAFFFBFBFBFFFAFA
          FAFFF9F9F9FFF9F9F9FFF8F8F8FFF8F8F8FFF7F7F7FF58585876000000000000
          00001815132697877AFFF0EBE8FFF6F2EFFFF6F2F0FFF5F1EFFFF5F0EEFFF4EF
          EDFFF4EFECFFF3EEEBFFF3EDEAFFF2EDE9FFF2ECE9FFEEE8E5FFFCFCFCFFFBFB
          FBFFFDFDFDFFFDFDFDFFFCFCFCFFFDFDFDFFFDFDFDFFFDFDFDFFFCFCFCFFFCFC
          FCFFFAFAFAFFD0CFCFD59C9C9CA17676767A5151515415151518000000000000
          00003F373160998A80FFA89B92FFD4C9C2FFF2EDEAFFF6F2F0FFF6F2F0FFF5F1
          EFFFF4F0EEFFF4EFEDFFF4EFECFFF3EEEBFFF3EEEBFFF2EDEAFFFBFAF9FFFEFE
          FEFFFEFEFEFFFDFDFDFFFBFAFAFFF9F7F6FFF6F3F2FFF5F1EFFFF3EFECFFF2EC
          E9FFF1EBE8FF3836363C00000000000000000000000000000000000000000000
          0000695C529BC2B2A5FFB1A194FF9B8D82FF9B8C81FFC5BAB1FFEDE7E3FFF7F3
          F1FFF6F2EFFFF5F1EFFFF5F0EEFFF4F0EDFFF4EFECFFF4EFECFFF6F2EFFFF6F2
          F0FFF3EFEDFFF2EDEAFFF1ECE9FFF2ECEAFFF1EBE8FFF2EBE8FFF2ECE9FFF1EC
          E9FFEFEAE7FD1010101200000000000000000000000000000000000000000000
          00009A897DD7C8B7ABFFC6B5A9FFC5B4A8FFBDACA0FFA6988DFF998B81FFBBAE
          A5FFE6DED9FFF6F3F1FFF6F2EFFFF5F1EFFFF5F1EEFFF4F0EDFFF4F0EDFFF4EF
          EDFFF4EFECFFF4EEECFFF3EEEBFFF2EEEBFFF2EEEBFFF2EDEAFFF2EDEAFFF3ED
          EAFFD9D4D2E50000000000000000000000000000000000000000000000000D0B
          0A14BDA99CFDD0C0B5FFCFBFB4FFCEBDB2FFCDBBB0FFCBBAAEFFC7B6ABFFB2A3
          98FF9E9187FFB1A399FFDCD2CBFFF4EFEDFFF6F2F0FFF5F2EFFFF5F1EFFFF4F1
          EEFFF4F0EEFFF4F0EDFFF4F0EDFFF4EFEDFFF3EFECFFF3EFECFFF3EEEBFFF2EE
          EBFFAFABAAB90000000000000000000000000000000000000000000000003B37
          344CD5C7BCFFDACBC0FFD8CABEFFD7C8BCFFD6C6BBFFD4C4B9FFD3C2B7FFD1C1
          B6FFCFBFB4FFC0B0A6FFA99C92FFA6988EFFBEB1A8FFE5DDD8FFF6F2F0FFF6F2
          F0FFF5F1EFFFF5F1EFFFF5F1EFFFF4F1EEFFF4F0EEFFF4F0EEFFF4F0EEFFF4EF
          EDFF8785848F0000000000000000000000000000000000000000000000003837
          363EDDD1C9FDE1D3CAFFE1D3CAFFDFD2C8FFDED0C6FFDDCEC4FFDBCDC2FFDACB
          C0FFD8CABFFFD7C8BDFFD6C6BBFFADA098FF9C9189FFA9988CFFF7F4F2FFF6F3
          F1FFF6F3F1FFF6F2F0FFF6F2F0FFF5F2F0FFF6F2F0FFF5F1EFFFF5F1EFFFF5F1
          EFFF5F5D5C640000000000000000000000000000000000000000000000000000
          0000181514225C524A85B1A397E3DDCFC6FFE5D8CFFFE4D7CEFFE3D6CDFFE2D5
          CCFFE1D3CAFFDFD2C8FFDED0C7FFC8BBB2FFA39991FFAB9E94FFEEE7E3FFF7F5
          F3FFF7F4F3FFF7F4F2FFF6F3F2FFF6F3F1FFF6F3F1FFF6F3F1FFF6F2F1FFF5F2
          F1FF3736363A0000000000000000000000000000000000000000000000000000
          0000000000000000000002020204302A254A81756DADCBBCB2F9E4D8CFFFE4D7
          CEFFE5D8CFFFE5D8CFFFE4D7CEFFE0D3CAFF9F958FED82766DC9DFD4CCFFF8F6
          F4FFF8F5F4FFF7F5F3FFF7F4F3FFF7F4F3FFF6F4F3FFF6F4F2FFF7F3F2FFF6F3
          F1FF0E0E0E100000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000D0B0A144B423B6EA093
          89CFD6C8BDFFE5D8CFFFE5D8CFFFB9AEA7CF1F1D1C26000000006C676578F6F2
          F0FFF9F7F6FFF8F6F5FFF8F6F4FFF8F5F4FFF8F5F4FFF7F5F4FFF8F5F3FFDBD9
          D7E3000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00001C18152C5249427646413E54050404060000000000000000000000002724
          222E7B74708BD4CDC8E5F7F4F2FFF8F6F6FFF8F6F5FFF8F6F5FFF8F6F5FFB1AF
          AFB7000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000030303043E39364A9B9590ABEAE4E0F9F9F7F6FFF8F7F6FF8988
          878D000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000100F0E14605A566EA19C99AD2C2C
          2B2E000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFE7FFFFFFE1FFF0FFE000007FC000007FC000007FC000007FC00
          0007F8000003F8000003F8000003F8000003F0000003F0000001F0000001F000
          0001F0000001E0000001E0000001E0000007E000001FC000001FC000001FC000
          001FC000001FC000003FE000003FFC00003FFF83803FFFFFC03FFFFFF83FFFFF
          FF7F}
      end
      item
        Image.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000040000000A000000080000000A01010112020202140202
          0214020202140202021402020214020202140202021401010110000000080000
          000E0000000A0000000400000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000006000000140B0B0B3C292B2A74424443954B4D4D9D4D514E9F4D51
          4E9F4D514E9F4D514E9F4D514E9F4D514E9F4D504E9F494B4A9B303231811313
          134E0000001E0000001200000002000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000404041E37393985ACB0AFF5D7DAD9FFE6E8E8FFE9EBEBFFEAEBEBFFEAEC
          ECFFEAECECFFEBECECFFEAECECFFEAEBEBFFE9EBEBFFE7E9E8FFDBDDDDFFB9BD
          BCFD525454AF0D0E0E400000000A000000020000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000292A2A62A8ABAAEDE7E9E9FFE3E5E5FFE3E5E5FFE4E6E6FFE5E7E7FFE6E9
          E9FFE7E9E9FFE7E9E9FFE7E9E9FFE5E8E8FFE4E7E7FFE3E5E5FFE3E5E5FFDFE1
          E1FFB8BABAF9515453A50000000A000000000000000000000000000000000000
          000000000000000000000000000400000006000000060101010A0202020E0404
          04148A8D8DD7D1D2D2FFDBDDDDFFE1E4E4FFE4E7E7FFE6E8E8FFE8EAEAFFE9EB
          EBFFEAECECFFEAECECFFE9EBEBFFE8EAEAFFE6E9E9FFE4E7E7FFE3E5E5FFC8CA
          CAFFC2C4C4FFB7BAB9FD1313132C000000000000000000000000000000000000
          00000000000000000008010101180F10103E2E3130703D3F3E7E43454485484B
          4995B8BCBBFDD5D7D7FFD0D2D2FFE5E7E7FFE7E9E9FFE9EBEBFFEBEDEDFFECEE
          EEFFEEEFEFFFEEEFEFFFEDEEEEFFEBEDEDFFE9EBEBFFE7E9E9FFE4E6E6FFC4C7
          C7FFD1D4D4FFCFD2D2FF33343360030303060000000000000000000000000000
          0000000000060404041E4B4E4C93959696C7B8B9B9CFBABCBCCDBEBFBFCDAEB1
          B0DBC5C8C7FFE5E7E7FFCED0D0FFE3E6E6FFE9EBEBFFECEEEEFFEEF0F0FFF0F1
          F1FFF1F2F2FFF1F2F2FFF0F1F1FFEEF0F0FFECEEEEFFEAECECFFE3E5E5FFD6D8
          D8FFE4E6E6FFD4D7D6FF36383868030303060000000000000000000000000000
          00000101010A2F313068A3A5A4CDB5B6B6C9B2B3B3C9B2B4B4C9B4B6B6C9A9AC
          ABD3BFC2C1FFE8EBEBFFDDDFDFFFE1E4E4FFECEDEDFFEFF0F0FFF1F2F2FFF3F4
          F4FFF5F5F5FFF5F5F5FFF4F5F5FFF1F3F3FFEFF0F0FFECEEEEFFE6E8E8FFE3E5
          E5FFE7EAEAFFC4C7C6FF1F20203E010101020000000000000000000000000000
          00002527264C848585B7A8A9A9C9ADAFAFC9B2B4B4C9B4B6B6C9B6B7B7C9B5B7
          B7CBB1B3B2F9E7E8E8FFE5E8E8FFE8EAEAFFEDEFEFFFF0F1F1FFF4F5F5FFF6F6
          F6FFF7F7F7FFF7F7F7FFF6F7F7FFF4F5F5FFF0F2F2FFEDEFEFFFEAECECFFE6E9
          E9FFE7E9E8FF939695D902020204000000000000000000000000000000000000
          000050535391A0A2A1C5A1A3A3C9A8A9A9C9B5B6B6C9B6B7B7C9B7BABAC9BABC
          BCC9ABADACE7D8DAD9FFE9EBEBFFEAECECFFEEEFEFFFF2F2F2FFECEDEDFFE5E6
          E6FFE0E0E1FFE1E1E1FFE6E7E7FFEEEFEFFFF2F3F3FFEEF0F0FFEAECECFFEBED
          EDFFCDD0CFF74749497800000000000000000000000000000000000000000000
          0000686B69AFAAACACCBAEB0B0C9A4A6A6C9B6B7B7C9B7BABAC9BABBBBC9BCBE
          BEC9B7B9B8CFAAADADF1EAEBEBFFECEDEDFFEBECECFFDFE1E1FFC5C6C6FFB3B5
          B4FFA8AAA9FFA8AAA9FFB3B4B3FFC6C7C7FFE1E1E1FFECEDEDFFEDEFEFFFE7E8
          E8FF6A6D6CAD0C0C0C1800000000000000000000000000000000000000000000
          000056585797A3A5A4C7B3B6B6C9ADAEAEC9B5B7B7C9BABBBBC9BDBEBEC9BEBF
          BFC9C0C1C1C9B2B4B4D5B6B9B8FBEBEDEDFFDFE1E1FFBCBEBDFF9DA1A0FFAEB1
          B0FFBCBFBFFFBDC1C0FFB0B4B3FF9FA3A2FFBABCBCFFE2E3E3FFE9EBEAFF9598
          97DB1516152A0000000000000000000000000000000000000000000000000000
          000022252548838685B3BABBBBC9B6B6B6C9B7B9B9C9BBBCBCC9BEBEBEC9C0C1
          C1C9C1C1C1C9C4C4C4C9B2B5B5D5A9ACABF1B2B4B3FFA9ADACFFD8DBDBFFDCDF
          DFFFD7DBDBFFD7DBDBFFDCDFDFFFDBDEDEFFAFB2B1FFADB0AFFF6F7271B51718
          172E000000000000000000000000000000000000000000000000000000000000
          00000607070E4A4D4B7EBABCBCCDB7B8B8C9B8BABAC9BCBDBDC9BEBEBEC9B8B9
          B9C9B1B1B1C9AFAFAFC9B0B0B0C9A3A4A3D59EA3A1FFD7DADAFFD4D8D8FFD2D6
          D6FFD3D7D7FFD3D7D7FFD2D6D6FFD4D8D8FFDADDDCFFA6A9A8FD191A19400000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000C0D0C1A7F8180B5B9BABACBB9BBBBC9B9BABAC9A8A9A9C99698
          98C9878887C9838584C9848685C9878A89E1D0D3D2FFD6DADAFFD5D9D9FFD9DC
          DCFFDADDDDFFDADDDDFFDADDDDFFD8DBDBFFD7DADAFFD9DDDCFF4F5251950304
          0408000000000000000000000000000000000000000000000000000000000000
          000000000000000000002B2C2C4C8B8D8CBDBFBFBFCBADADADC9878A89C97E81
          80C9909392C9999C9BC9969998CD949896EFDEE1E0FFD7DADAFFDBDDDDFFDEE1
          E1FFE0E3E3FFE1E3E3FFDFE2E2FFDEE0E0FFDADDDDFFE0E3E3FF848787C91011
          1020000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000001A1C1B34737674AF858887C9909492C9ADAF
          AFC9ABAEAEC9A8ABABC9A6A8A8CFABAEADF5E0E3E3FFDBDEDEFFE1E4E4FFE4E7
          E7FFE7EAEAFFE8EBEBFFE7E9E9FFE3E7E7FFDFE1E1FFE3E5E5FF9B9E9DD91718
          172E000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000023242352848786C3AEAFAFC9A7A9
          A9C9A6A8A8C9A7A9A9C9A3A6A6CDA6A9A8F3E3E5E5FFDEE1E1FFE6E8E8FFEAEC
          ECFFEDEEEEFFEEF0F0FFECEEEEFFE9EBEBFFE3E5E5FFE7E9E9FF979999D51516
          152A000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000005457568DAAACACCBA7A9A9C9A8AB
          ABC9ABAEAEC9ACAFAFC9ABAEAEC99A9D9DE7DEE0E0FFE4E6E6FFE9EBEBFFEEF0
          F0FFF4F5F5FFF5F6F6FFF2F4F4FFEEEFEFFFE7EAEAFFE8EAEAFF696C6BAF0909
          0912000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000030303067F8282BDABAEAFC9A9ACACC9ACAF
          AFC9AFB2B2C9B1B3B3C9B2B3B3C9A6A9A8D5BEC2C1FFE9EBEBFFEAECECFFF1F2
          F2FFF8F9F9FFFBFCFCFFF5F7F7FFEFF0F0FFEEEFF0FFCDCFCFFF2E302F5A0101
          0102000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000B0B0B168C8F8FC7AFB1B1C9AEB0B0C9B2B4
          B4C9B4B6B6C9B6B8B8C9B6B8B8C9B6B8B8C9A2A5A4E5C5C8C7FDEFF0F0FFF2F3
          F3FFF7F7F7FFF9F9F9FFF6F7F7FFF3F4F4FFCDCFCEF9606261A1000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000607060E8B8E8CC7B0B3B3C9B1B3B3C9B5B7
          B7C9B9BABAC9BBBDBDC9BBBDBDC9BABCBCC9B4B5B4CDA2A5A4E5B9BCBBFDE1E3
          E2FFF4F4F4FFF4F5F5FFE6E8E7FFC0C2C1FD585A5A970F10101E000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000006466659BB1B3B3CBB3B5B5C9B7B9
          B9C9BEBEBEC9C1C1C1C9C1C2C2C9BFBFBFC9BABBBBC9B7B9B9C9A4A6A5D36165
          63AF575A589D5B5D5CA3444645811D1F1E3A0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000002F3130529C9E9EC5B9BABAC9B9BA
          BAC9BFC0C0C9C3C4C4C9C5C5C5C9C1C1C1C9BBBDBDC9BDBEBEC9868887B71B1B
          1B320505050A0707070E01010102000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000707070C43444476A8AAAACBBBBD
          BDC9C0C0C0C9C2C2C2C9C3C3C3C9C1C1C1C9BDBDBDCB9B9D9DC72A2C2B500202
          0204000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000090909124B4D4C7E8D90
          8FC3B8B9B9CFC3C4C4CFC2C3C3CFB1B3B2CD7F8282B937393860030303060000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000010101021111
          1122383B3A6C474A4887454746833133315E090A0A1400000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000405050A0A0B0B1608090812030403080000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Mask.Data = {
          BE000000424DBE000000000000003E0000002800000020000000200000000100
          010000000000800000000000000000000000020000000000000000000000FFFF
          FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFC007FFFE0001FFFE0000FFFC0000FFF00
          000FF000000FF000000FE000000FC000001FC000001FC000003FE000007FF000
          00FFF000007FF800007FFC00007FFE00007FFC00007FFC0000FFFC0000FFFC00
          01FFFC0007FFFE007FFFFF00FFFFFF81FFFFFFE7FFFFFFFFFFFFFFFFFFFFFFFF
          FFFF}
      end>
  end
  object ttDelProfile: TsmFireDACTempTable
    Fields = <
      item
        Attributes = [fttaRequired]
        FieldName = 'Id_Profile'
      end>
    TableName = 'tmpDelProfile'
    Left = 192
    Top = 280
  end
end