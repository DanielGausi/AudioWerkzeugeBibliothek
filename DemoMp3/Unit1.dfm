object Form1: TForm1
  Left = 284
  Top = 165
  Caption = 'MP3FileUtils Demo'
  ClientHeight = 691
  ClientWidth = 930
  Color = clBtnFace
  Constraints.MinHeight = 620
  Constraints.MinWidth = 840
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    930
    691)
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 8
    Top = 598
    Width = 890
    Height = 81
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'ID3v2-Tag properties'
    TabOrder = 3
    ExplicitWidth = 876
    object Label52: TLabel
      Left = 320
      Top = 24
      Width = 52
      Height = 15
      Caption = 'Unsynced'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ShowAccelChar = False
    end
    object Label53: TLabel
      Left = 320
      Top = 40
      Width = 70
      Height = 15
      Caption = 'Compression'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ShowAccelChar = False
    end
    object Label56: TLabel
      Left = 8
      Top = 24
      Width = 38
      Height = 15
      Caption = 'Version'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ShowAccelChar = False
    end
    object Label57: TLabel
      Left = 320
      Top = 56
      Width = 81
      Height = 15
      Caption = 'Unknown Flags'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ShowAccelChar = False
    end
    object Label58: TLabel
      Left = 168
      Top = 40
      Width = 68
      Height = 15
      Caption = 'Experimental'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ShowAccelChar = False
    end
    object Label59: TLabel
      Left = 8
      Top = 40
      Width = 20
      Height = 15
      Caption = 'Size'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ShowAccelChar = False
    end
    object Label60: TLabel
      Left = 168
      Top = 56
      Width = 34
      Height = 15
      Caption = 'Footer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ShowAccelChar = False
    end
    object Label61: TLabel
      Left = 168
      Top = 24
      Width = 84
      Height = 15
      Caption = 'Etended Header'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ShowAccelChar = False
    end
    object Lblv2_Unsynced: TLabel
      Left = 416
      Top = 24
      Width = 15
      Height = 15
      Caption = '???'
      ShowAccelChar = False
    end
    object Lblv2_Compression: TLabel
      Left = 416
      Top = 40
      Width = 15
      Height = 15
      Caption = '???'
      ShowAccelChar = False
    end
    object Lblv2_ExtendedHeader: TLabel
      Left = 264
      Top = 24
      Width = 15
      Height = 15
      Caption = '???'
      ShowAccelChar = False
    end
    object Lblv2_Version: TLabel
      Left = 104
      Top = 19
      Width = 15
      Height = 15
      Caption = '???'
      ShowAccelChar = False
    end
    object Lblv2_Size: TLabel
      Left = 104
      Top = 40
      Width = 15
      Height = 15
      Caption = '???'
      ShowAccelChar = False
    end
    object Lblv2_Experimental: TLabel
      Left = 264
      Top = 40
      Width = 15
      Height = 15
      Caption = '???'
      ShowAccelChar = False
    end
    object Lblv2_Footer: TLabel
      Left = 264
      Top = 56
      Width = 15
      Height = 15
      Caption = '???'
      ShowAccelChar = False
    end
    object Lblv2_UnknownFlags: TLabel
      Left = 416
      Top = 56
      Width = 15
      Height = 15
      Caption = '???'
      ShowAccelChar = False
    end
    object Label4: TLabel
      Left = 8
      Top = 56
      Width = 26
      Height = 15
      Caption = 'Used'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ShowAccelChar = False
    end
    object Lblv2_UsedSize: TLabel
      Left = 104
      Top = 56
      Width = 15
      Height = 15
      Caption = '???'
      ShowAccelChar = False
    end
  end
  object GroupBox13: TGroupBox
    Left = 291
    Top = 56
    Width = 607
    Height = 320
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Frame content (after editing: click "Apply changes")'
    TabOrder = 0
    ExplicitWidth = 589
    ExplicitHeight = 319
    DesignSize = (
      607
      320)
    object PCFrameContent: TPageControl
      Left = 8
      Top = 21
      Width = 466
      Height = 291
      ActivePage = TSCoverArt
      Anchors = [akLeft, akTop, akRight, akBottom]
      MultiLine = True
      Style = tsButtons
      TabOrder = 0
      ExplicitWidth = 448
      ExplicitHeight = 290
      object TSText: TTabSheet
        Caption = 'Text'
        DesignSize = (
          458
          232)
        object Ed4_Text: TLabeledEdit
          Left = 16
          Top = 24
          Width = 425
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 21
          EditLabel.Height = 15
          EditLabel.Caption = 'Text'
          TabOrder = 0
          Text = ''
          ExplicitWidth = 411
        end
      end
      object TSComments: TTabSheet
        Caption = 'Comments/Lyrics'
        ImageIndex = 1
        DesignSize = (
          458
          232)
        object Label16: TLabel
          Left = 16
          Top = 56
          Width = 94
          Height = 15
          Caption = 'Comment / Lyrics'
        end
        object Ed4_CommentLanguage: TLabeledEdit
          Left = 16
          Top = 24
          Width = 66
          Height = 23
          Color = clScrollBar
          EditLabel.Width = 52
          EditLabel.Height = 15
          EditLabel.Caption = 'Language'
          ReadOnly = True
          TabOrder = 0
          Text = ''
        end
        object Ed4_CommentDescription: TLabeledEdit
          Left = 88
          Top = 24
          Width = 353
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          Color = clScrollBar
          EditLabel.Width = 60
          EditLabel.Height = 15
          EditLabel.Caption = 'Description'
          ReadOnly = True
          TabOrder = 1
          Text = ''
        end
        object Ed4_CommentValue: TMemo
          Left = 16
          Top = 72
          Width = 425
          Height = 154
          Anchors = [akLeft, akTop, akRight, akBottom]
          ScrollBars = ssVertical
          TabOrder = 2
          ExplicitWidth = 411
        end
      end
      object TSURL: TTabSheet
        Caption = 'URLs'
        ImageIndex = 3
        DesignSize = (
          458
          232)
        object Ed4_URL: TLabeledEdit
          Left = 16
          Top = 24
          Width = 425
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 21
          EditLabel.Height = 15
          EditLabel.Caption = 'URL'
          TabOrder = 0
          Text = ''
          ExplicitWidth = 411
        end
        object BtnVisitURL: TButton
          Left = 16
          Top = 59
          Width = 145
          Height = 25
          Caption = 'Open URL in browser'
          TabOrder = 1
          OnClick = BtnVisitURLClick
        end
      end
      object TSURLUserDefined: TTabSheet
        Caption = 'URLs (user defined)'
        ImageIndex = 2
        DesignSize = (
          458
          232)
        object ed4_UserDefURLDescription: TLabeledEdit
          Left = 16
          Top = 24
          Width = 433
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          Color = clScrollBar
          EditLabel.Width = 60
          EditLabel.Height = 15
          EditLabel.Caption = 'Description'
          ReadOnly = True
          TabOrder = 0
          Text = ''
          ExplicitWidth = 419
        end
        object Ed4_UserDefURLValue: TLabeledEdit
          Left = 16
          Top = 77
          Width = 433
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 21
          EditLabel.Height = 15
          EditLabel.Caption = 'URL'
          TabOrder = 1
          Text = ''
        end
        object Btn_VisitUserDefURL: TButton
          Left = 16
          Top = 120
          Width = 152
          Height = 25
          Caption = 'Open URL in browser'
          TabOrder = 2
          OnClick = Btn_VisitUserDefURLClick
        end
      end
      object TSCoverArt: TTabSheet
        Caption = 'Cover art'
        ImageIndex = 4
        DesignSize = (
          458
          232)
        object Label18: TLabel
          Left = 172
          Top = 9
          Width = 63
          Height = 15
          Caption = 'Picture type'
        end
        object Ed4_Pic: TImage
          Left = 3
          Top = 57
          Width = 308
          Height = 170
          Anchors = [akLeft, akTop, akRight, akBottom]
          Center = True
          Proportional = True
          Stretch = True
          ExplicitWidth = 318
        end
        object Label5: TLabel
          Left = 8
          Top = 8
          Width = 57
          Height = 15
          Caption = 'Mime type'
        end
        object Label6: TLabel
          Left = 8
          Top = 35
          Width = 60
          Height = 15
          Caption = 'Description'
        end
        object Label8: TLabel
          Left = 327
          Top = 65
          Width = 119
          Height = 105
          Caption = 
            'Note: "Description" is read-only in this demo, as it should be u' +
            'nique throughout  the ID3-Tag, and I don'#39't want to add the GUI l' +
            'ogic for that here.'
          WordWrap = True
        end
        object Ed4_PicMime: TLabeledEdit
          Left = 71
          Top = 5
          Width = 75
          Height = 23
          Color = clScrollBar
          EditLabel.Width = 3
          EditLabel.Height = 23
          EditLabel.Caption = ' '
          LabelPosition = lpLeft
          ReadOnly = True
          TabOrder = 0
          Text = ''
        end
        object ed4_cbPictureType: TComboBox
          Left = 241
          Top = 5
          Width = 79
          Height = 23
          Style = csDropDownList
          TabOrder = 1
        end
        object Ed4_PicDescription: TLabeledEdit
          Left = 70
          Top = 30
          Width = 251
          Height = 23
          Color = clScrollBar
          EditLabel.Width = 3
          EditLabel.Height = 23
          EditLabel.Caption = ' '
          LabelPosition = lpLeft
          ReadOnly = True
          TabOrder = 2
          Text = ''
        end
        object BtnLoadPic: TButton
          Left = 360
          Top = 3
          Width = 95
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Load cover art'
          TabOrder = 3
          OnClick = BtnLoadPicClick
          ExplicitLeft = 342
        end
        object BtnSavePicture: TButton
          Left = 360
          Top = 34
          Width = 95
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Save to file'
          TabOrder = 4
          OnClick = BtnSavePictureClick
          ExplicitLeft = 356
        end
      end
      object TSPrivate: TTabSheet
        Caption = 'Private Frames'
        ImageIndex = 7
        DesignSize = (
          458
          232)
        object Label7: TLabel
          Left = 16
          Top = 51
          Width = 288
          Height = 15
          Caption = 'Content (binary data, no editing possible in this demo)'
        end
        object edtPrivateDescription: TLabeledEdit
          Left = 16
          Top = 24
          Width = 433
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          Color = clScrollBar
          EditLabel.Width = 276
          EditLabel.Height = 15
          EditLabel.Caption = 'Description (set by the software that uses this frame)'
          ReadOnly = True
          TabOrder = 0
          Text = ''
          ExplicitWidth = 419
        end
        object memoPrivateFrame: TMemo
          Left = 16
          Top = 70
          Width = 433
          Height = 163
          Anchors = [akLeft, akTop, akRight, akBottom]
          Color = clScrollBar
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 1
          WordWrap = False
          ExplicitWidth = 419
        end
      end
      object TSBinary: TTabSheet
        Caption = 'All data'
        ImageIndex = 5
        DesignSize = (
          458
          232)
        object Label2: TLabel
          Left = 9
          Top = 10
          Width = 288
          Height = 15
          Caption = 'Content (binary data, no editing possible in this demo)'
        end
        object Ed4_DataMemo: TMemo
          Left = 8
          Top = 35
          Width = 447
          Height = 194
          Anchors = [akLeft, akTop, akRight, akBottom]
          Color = clScrollBar
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
          ExplicitWidth = 433
        end
        object Btn_ExtractData: TButton
          Left = 339
          Top = 7
          Width = 116
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'Save data to file'
          TabOrder = 1
          OnClick = Btn_ExtractDataClick
          ExplicitLeft = 325
        end
      end
    end
    object BtnApplyChange: TButton
      Left = 487
      Top = 21
      Width = 105
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Apply changes'
      TabOrder = 1
      OnClick = BtnApplyChangeClick
      ExplicitLeft = 469
    end
    object BtnAddFrame: TButton
      Left = 487
      Top = 52
      Width = 105
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Add Frame'
      TabOrder = 2
      OnClick = BtnAddFrameClick
      ExplicitLeft = 469
    end
    object BtnSaveToFile: TButton
      Left = 487
      Top = 183
      Width = 105
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Update Mp3-File'
      TabOrder = 3
      OnClick = BtnSaveToFileClick
      ExplicitLeft = 469
    end
    object BtnDeleteFrame: TButton
      Left = 487
      Top = 83
      Width = 105
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Delete Frame'
      TabOrder = 4
      OnClick = BtnDeleteFrameClick
      ExplicitLeft = 469
    end
    object BtnUndo: TButton
      Left = 487
      Top = 152
      Width = 105
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Undo changes'
      TabOrder = 5
      OnClick = BtnUndoClick
      ExplicitLeft = 469
    end
  end
  object GrpBoxExpert: TGroupBox
    Left = 8
    Top = 382
    Width = 890
    Height = 121
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Write settings'
    TabOrder = 2
    ExplicitWidth = 876
    DesignSize = (
      890
      121)
    object Label3: TLabel
      Left = 248
      Top = 48
      Width = 627
      Height = 57
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      Caption = 
        'Be careful with these settings! Activating one of these settings' +
        ' may render the ID3Tag unusable for some software (like faulty C' +
        'over Art in the Windows Explorer). '
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      WordWrap = True
      ExplicitWidth = 645
    end
    object Bevel1: TBevel
      Left = 224
      Top = 16
      Width = 9
      Height = 89
      Shape = bsLeftLine
    end
    object cbGroupID: TCheckBox
      Left = 248
      Top = 24
      Width = 81
      Height = 17
      Caption = 'Grouping'
      TabOrder = 1
    end
    object EdGroupID: TLabeledEdit
      Left = 392
      Top = 22
      Width = 65
      Height = 23
      EditLabel.Width = 52
      EditLabel.Height = 23
      EditLabel.Caption = 'ID (0..255)'
      LabelPosition = lpLeft
      MaxLength = 3
      TabOrder = 2
      Text = '42'
    end
    object CBUnsync: TCheckBox
      Left = 504
      Top = 24
      Width = 81
      Height = 17
      Caption = 'Unsync Tag'
      TabOrder = 3
      OnClick = CBUnsyncClick
    end
    object CB_UsePadding: TCheckBox
      Left = 16
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Use Padding'
      TabOrder = 0
      OnClick = CB_UsePaddingClick
    end
    object BtnDeleteTag: TButton
      Left = 16
      Top = 72
      Width = 153
      Height = 25
      Caption = 'Delete ID3v2Tag from file'
      TabOrder = 4
      OnClick = BtnDeleteTagClick
    end
  end
  object GroupBox14: TGroupBox
    Left = 8
    Top = 510
    Width = 890
    Height = 81
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Frame properties'
    TabOrder = 1
    ExplicitWidth = 876
    object Label19: TLabel
      Left = 168
      Top = 24
      Width = 92
      Height = 15
      Caption = 'Tag alter preserve'
    end
    object Label28: TLabel
      Left = 168
      Top = 40
      Width = 91
      Height = 15
      Caption = 'File alter preserve'
    end
    object Label29: TLabel
      Left = 168
      Top = 56
      Width = 52
      Height = 15
      Caption = 'Read only'
    end
    object Label45: TLabel
      Left = 480
      Top = 24
      Width = 70
      Height = 15
      Caption = 'Compression'
    end
    object Label46: TLabel
      Left = 480
      Top = 40
      Width = 57
      Height = 15
      Caption = 'Encryption'
    end
    object Label47: TLabel
      Left = 8
      Top = 24
      Width = 20
      Height = 15
      Caption = 'Size'
    end
    object Label48: TLabel
      Left = 8
      Top = 40
      Width = 79
      Height = 15
      Caption = 'Unknown flags'
    end
    object Label49: TLabel
      Left = 320
      Top = 56
      Width = 87
      Height = 15
      Caption = 'Length indicator'
    end
    object Label50: TLabel
      Left = 320
      Top = 40
      Width = 52
      Height = 15
      Caption = 'Unsynced'
    end
    object Label51: TLabel
      Left = 320
      Top = 24
      Width = 46
      Height = 15
      Caption = 'Grouped'
    end
    object LblTagAlter: TLabel
      Left = 264
      Top = 24
      Width = 15
      Height = 15
      Caption = '???'
    end
    object LblFileAlter: TLabel
      Left = 264
      Top = 40
      Width = 15
      Height = 15
      Caption = '???'
    end
    object LblReadOnly: TLabel
      Left = 264
      Top = 56
      Width = 15
      Height = 15
      Caption = '???'
    end
    object LblSize: TLabel
      Left = 104
      Top = 24
      Width = 15
      Height = 15
      Caption = '???'
    end
    object LblUnknownFlags: TLabel
      Left = 104
      Top = 40
      Width = 15
      Height = 15
      Caption = '???'
    end
    object LblEncryption: TLabel
      Left = 576
      Top = 40
      Width = 15
      Height = 15
      Caption = '???'
    end
    object LblGrouped: TLabel
      Left = 416
      Top = 24
      Width = 15
      Height = 15
      Caption = '???'
    end
    object LblUnsynced: TLabel
      Left = 416
      Top = 40
      Width = 15
      Height = 15
      Caption = '???'
    end
    object LblLengthIndicator: TLabel
      Left = 416
      Top = 56
      Width = 15
      Height = 15
      Caption = '???'
    end
    object LblCompression: TLabel
      Left = 576
      Top = 24
      Width = 15
      Height = 15
      Caption = '???'
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 56
    Width = 277
    Height = 320
    Caption = 'Frame Selection'
    TabOrder = 4
    DesignSize = (
      277
      320)
    object CBFrameTypeSelection: TComboBox
      Left = 5
      Top = 23
      Width = 265
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Text Frames'
      OnChange = CBFrameTypeSelectionChange
      Items.Strings = (
        'Text Frames'
        'Comments'
        'Lyrics'
        'URLs'
        'User defined URLs'
        'Cover Art'
        'Private Frames'
        'Alle')
    end
    object LVFrames: TListView
      Left = 3
      Top = 50
      Width = 267
      Height = 267
      Anchors = [akLeft, akTop, akBottom]
      Columns = <
        item
          Caption = 'ID-String'
          Width = 60
        end
        item
          Caption = 'Description'
          Width = 200
        end>
      ColumnClick = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 1
      ViewStyle = vsReport
      OnChange = LVFramesChange
      OnSelectItem = LVFramesSelectItem
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 8
    Width = 900
    Height = 42
    Caption = 'File selection'
    TabOrder = 5
    object Label1: TLabel
      Left = 8
      Top = 18
      Width = 48
      Height = 15
      Caption = 'Filename'
    end
    object edtCurrentFilename: TEdit
      Left = 62
      Top = 15
      Width = 356
      Height = 23
      ReadOnly = True
      TabOrder = 0
    end
    object BtnSelectFile: TButton
      Left = 424
      Top = 15
      Width = 89
      Height = 23
      Caption = 'Select file ...'
      TabOrder = 1
      OnClick = BtnSelectFileClick
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Mp3-Dateien|*.mp3'
    Left = 784
    Top = 544
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'All supported files (*.jpg;*.jpeg;*.png;)|*.jpg;*.jpeg;*.png;'
    Left = 648
    Top = 544
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 736
    Top = 536
  end
end
