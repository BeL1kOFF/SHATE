object frmConnections: TfrmConnections
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object cxGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    TabOrder = 0
    object cxGridTableView: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object colHandle: TcxGridColumn
        Visible = False
      end
      object colIP: TcxGridColumn
        HeaderAlignmentHorz = taCenter
      end
      object ColAddress: TcxGridColumn
        HeaderAlignmentHorz = taCenter
      end
      object colDate: TcxGridColumn
        HeaderAlignmentHorz = taCenter
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridTableView
    end
  end
end
