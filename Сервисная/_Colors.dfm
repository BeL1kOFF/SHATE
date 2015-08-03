inherited ClientIDs: TClientIDs
  Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088#1099' '#1082#1083#1080#1077#1085#1090#1072
  PixelsPerInch = 96
  TextHeight = 13
  inherited GridPanel1: TPanel
    inherited Grid1: TDBGridEh
      AutoFitColWidths = True
      ParentFont = False
      TitleFont.Style = [fsBold]
      Columns = <
        item
          EditButtons = <>
          FieldName = 'Client_ID'
          Footers = <>
          Title.Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
          Width = 104
        end
        item
          EditButtons = <>
          FieldName = 'Description'
          Footers = <>
          Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
          Width = 269
        end>
    end
    inherited AdvDockPanel1: TAdvDockPanel
      ToolBarStyler = Main.ToolBarStyler
      inherited ToolBar: TAdvToolBar
        ToolBarStyler = Main.ToolBarStyler
        inherited FilterToolBtn: TAdvToolBarButton
          Visible = False
        end
        inherited ColNastrToolBtn: TAdvToolBarButton
          Visible = False
        end
      end
    end
  end
  inherited Table: TDBISAMTable
    IndexName = 'Client_ID'
    TableName = '011'
  end
  inherited NvgTable: TDBISAMTable
    TableName = '011'
  end
  inherited FormStorage: TJvFormStorage
    AppStorage = Main.AppStorage
    AppStoragePath = 'ClientIDs\'
  end
end
