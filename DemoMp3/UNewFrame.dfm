object FormNewFrame: TFormNewFrame
  Left = 1190
  Top = 162
  Caption = 'Add a new Frame to the ID3-Tag'
  ClientHeight = 289
  ClientWidth = 448
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    448
    289)
  PixelsPerInch = 96
  TextHeight = 13
  object pcFrameTypeSelection: TPageControl
    Left = 8
    Top = 8
    Width = 432
    Height = 234
    ActivePage = TabSheet3
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    OnChange = pcFrameTypeSelectionChange
    object tsText: TTabSheet
      Caption = 'Text'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 87
        Height = 13
        Caption = 'Kind of information'
      end
      object lblURLWarningText: TLabel
        Left = 8
        Top = 120
        Width = 359
        Height = 13
        Caption = 
          'Hint: All possible Text-Frames are already set. Editing disabled' +
          '.'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object cbTextframe: TComboBox
        Left = 8
        Top = 32
        Width = 393
        Height = 21
        Style = csDropDownList
        TabOrder = 0
      end
      object Ed_TextFrame: TLabeledEdit
        Left = 8
        Top = 80
        Width = 393
        Height = 21
        EditLabel.Width = 37
        EditLabel.Height = 13
        EditLabel.Caption = 'Content'
        TabOrder = 1
        OnChange = Ed_TextFrameChange
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Comment'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 48
        Height = 13
        Caption = 'Language'
      end
      object Label3: TLabel
        Left = 104
        Top = 8
        Width = 79
        Height = 13
        Caption = 'Short description'
      end
      object Label6: TLabel
        Left = 8
        Top = 64
        Width = 44
        Height = 13
        Caption = 'Comment'
      end
      object cbLanguageComment: TComboBox
        Left = 8
        Top = 24
        Width = 73
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = EdtCommentDescriptionChange
      end
      object EdtCommentDescription: TEdit
        Left = 104
        Top = 24
        Width = 297
        Height = 21
        TabOrder = 1
        OnChange = EdtCommentDescriptionChange
      end
      object MemoComments: TMemo
        Left = 8
        Top = 80
        Width = 393
        Height = 121
        TabOrder = 2
        OnChange = EdtCommentDescriptionChange
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Lyrics'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label10: TLabel
        Left = 8
        Top = 8
        Width = 48
        Height = 13
        Caption = 'Language'
      end
      object Label11: TLabel
        Left = 104
        Top = 8
        Width = 79
        Height = 13
        Caption = 'Short description'
      end
      object Label12: TLabel
        Left = 8
        Top = 64
        Width = 27
        Height = 13
        Caption = 'Lyrics'
      end
      object cbLanguageLyrics: TComboBox
        Left = 8
        Top = 24
        Width = 73
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = EdtCommentDescriptionChange
      end
      object edtLyricDescription: TEdit
        Left = 104
        Top = 24
        Width = 297
        Height = 21
        TabOrder = 1
        OnChange = EdtCommentDescriptionChange
      end
      object MemoLyrics: TMemo
        Left = 8
        Top = 80
        Width = 393
        Height = 121
        TabOrder = 2
        OnChange = EdtCommentDescriptionChange
      end
    end
    object tsURLs: TTabSheet
      Caption = 'URLs'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label7: TLabel
        Left = 8
        Top = 16
        Width = 76
        Height = 13
        Caption = 'Kind of the URL'
      end
      object lblURLWarningURLs: TLabel
        Left = 8
        Top = 120
        Width = 321
        Height = 13
        Caption = 'Hint: All possible URLs are already set. Editing disabled.'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object cbURLFrame: TComboBox
        Left = 8
        Top = 32
        Width = 329
        Height = 21
        Style = csDropDownList
        TabOrder = 0
      end
      object ED_URLFrame: TLabeledEdit
        Left = 8
        Top = 80
        Width = 329
        Height = 21
        EditLabel.Width = 22
        EditLabel.Height = 13
        EditLabel.Caption = 'URL'
        TabOrder = 1
        OnChange = ED_URLFrameChange
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Userdef. IRL'
      ImageIndex = 2
      object Label4: TLabel
        Left = 8
        Top = 5
        Width = 79
        Height = 13
        Caption = 'Short description'
      end
      object Ed_UserDefURLDescription: TEdit
        Left = 8
        Top = 24
        Width = 193
        Height = 21
        TabOrder = 0
        OnChange = Ed_UserDefURLDescriptionChange
      end
      object EdUserDefURL: TLabeledEdit
        Left = 8
        Top = 64
        Width = 385
        Height = 21
        EditLabel.Width = 13
        EditLabel.Height = 13
        EditLabel.Caption = 'Url'
        TabOrder = 1
        OnChange = Ed_UserDefURLDescriptionChange
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Cover art'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ImgNewPic: TImage
        Left = 8
        Top = 8
        Width = 193
        Height = 185
        Center = True
        Proportional = True
        Stretch = True
      end
      object Label8: TLabel
        Left = 208
        Top = 8
        Width = 64
        Height = 13
        Caption = 'Kind of image'
      end
      object Label9: TLabel
        Left = 208
        Top = 56
        Width = 79
        Height = 13
        Caption = 'Short description'
      end
      object cbPictureType: TComboBox
        Left = 208
        Top = 24
        Width = 193
        Height = 21
        Style = csDropDownList
        TabOrder = 0
      end
      object EdtPictureDescription: TEdit
        Left = 208
        Top = 72
        Width = 193
        Height = 21
        TabOrder = 1
        OnChange = EdtPictureDescriptionChange
      end
      object BtnSelectPicture: TButton
        Left = 304
        Top = 99
        Width = 97
        Height = 25
        Caption = 'Select picture'
        TabOrder = 2
        OnClick = BtnSelectPictureClick
      end
    end
    object tsPrivate: TTabSheet
      Caption = 'Private Frame'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        424
        206)
      object lblPrivateWarning: TLabel
        Left = 16
        Top = 170
        Width = 353
        Height = 26
        Caption = 
          'Hint: The Private Frame for this demo already exists. It cannot ' +
          'be created again.'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        WordWrap = True
      end
      object Label5: TLabel
        Left = 16
        Top = 51
        Width = 353
        Height = 30
        AutoSize = False
        Caption = 
          'Content: We will do some funny stuff here and write another mp3-' +
          'file into the ID3-Tag. Select the file you want to embed into th' +
          'e ID3-Tag.'
        WordWrap = True
      end
      object edtPrivateDescription: TLabeledEdit
        Left = 16
        Top = 24
        Width = 356
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Color = clScrollBar
        EditLabel.Width = 227
        EditLabel.Height = 13
        EditLabel.Caption = 'Description (set by the software, not by the user)'
        ReadOnly = True
        TabOrder = 0
      end
      object BtnSelectPrivateFile: TButton
        Left = 294
        Top = 93
        Width = 75
        Height = 25
        Caption = 'Select file'
        TabOrder = 1
        OnClick = BtnSelectPrivateFileClick
      end
    end
  end
  object Btn_Ok: TButton
    Left = 276
    Top = 256
    Width = 83
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 1
    OnClick = Btn_OkClick
  end
  object BtnCancel: TButton
    Left = 365
    Top = 256
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'All supported files (*.jpg;*.jpeg;*.png;)|*.jpg;*.jpeg;*.png;'
    Left = 104
    Top = 240
  end
  object OpenDialog1: TOpenDialog
    Filter = 'MP3 files|*.mp3'
    Left = 24
    Top = 240
  end
end
