object MainFormAWB: TMainFormAWB
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'AudioWerkzeugeBibliothek (Demo Level 2)'
  ClientHeight = 604
  ClientWidth = 755
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 215
    Width = 417
    Height = 178
    Caption = 'Basic Data'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 30
      Width = 26
      Height = 13
      Caption = 'Artist'
    end
    object Label2: TLabel
      Left = 16
      Top = 59
      Width = 20
      Height = 13
      Caption = 'Title'
    end
    object Label3: TLabel
      Left = 16
      Top = 88
      Width = 29
      Height = 13
      Caption = 'Album'
    end
    object Label4: TLabel
      Left = 16
      Top = 117
      Width = 29
      Height = 13
      Caption = 'Genre'
    end
    object Label5: TLabel
      Left = 16
      Top = 146
      Width = 26
      Height = 13
      Caption = 'Track'
    end
    object Label6: TLabel
      Left = 150
      Top = 146
      Width = 22
      Height = 13
      Caption = 'Year'
    end
    object LblFileSize: TLabel
      Left = 234
      Top = 29
      Width = 38
      Height = 13
      Caption = 'File Size'
    end
    object LblDuration: TLabel
      Left = 236
      Top = 44
      Width = 41
      Height = 13
      Caption = 'Duration'
    end
    object LblBitrate: TLabel
      Left = 236
      Top = 59
      Width = 32
      Height = 13
      Caption = 'Bitrate'
    end
    object LblChannels: TLabel
      Left = 236
      Top = 74
      Width = 65
      Height = 13
      Caption = 'Channelmode'
    end
    object LblAudioType: TLabel
      Left = 234
      Top = 14
      Width = 52
      Height = 13
      Caption = 'Audio type'
    end
    object EdtArtist: TEdit
      Left = 52
      Top = 27
      Width = 176
      Height = 21
      TabOrder = 0
    end
    object EdtTitle: TEdit
      Left = 52
      Top = 56
      Width = 176
      Height = 21
      TabOrder = 1
    end
    object EdtAlbum: TEdit
      Left = 52
      Top = 85
      Width = 176
      Height = 21
      TabOrder = 2
    end
    object EdtGenre: TEdit
      Left = 52
      Top = 114
      Width = 176
      Height = 21
      TabOrder = 3
    end
    object EdtTrack: TEdit
      Left = 52
      Top = 143
      Width = 49
      Height = 21
      TabOrder = 4
    end
    object EdtYear: TEdit
      Left = 187
      Top = 143
      Width = 41
      Height = 21
      TabOrder = 5
    end
    object MemoSpecific: TMemo
      Left = 236
      Top = 48
      Width = 178
      Height = 127
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 6
      WordWrap = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 431
    Top = 8
    Width = 314
    Height = 255
    Caption = 'Cover art'
    TabOrder = 1
    object Image1: TImage
      Left = 17
      Top = 47
      Width = 200
      Height = 200
      Proportional = True
      Stretch = True
    end
    object cbPictures: TComboBox
      Left = 16
      Top = 20
      Width = 201
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbPicturesChange
    end
    object BtnNewPicture: TButton
      Left = 233
      Top = 22
      Width = 65
      Height = 25
      Caption = 'New'
      TabOrder = 1
      OnClick = BtnNewPictureClick
    end
    object BtnDeletePicture: TButton
      Left = 232
      Top = 53
      Width = 65
      Height = 25
      Caption = 'Delete'
      TabOrder = 2
      OnClick = BtnDeletePictureClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 399
    Width = 417
    Height = 155
    Caption = 'More text information (in this demo: read only)'
    TabOrder = 2
    DesignSize = (
      417
      155)
    object Label7: TLabel
      Left = 16
      Top = 16
      Width = 18
      Height = 13
      Caption = 'Key'
    end
    object Label8: TLabel
      Left = 214
      Top = 16
      Width = 26
      Height = 13
      Caption = 'Value'
    end
    object lbKeys: TListBox
      Left = 16
      Top = 35
      Width = 185
      Height = 103
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbKeysClick
    end
    object MemoValue: TMemo
      Left = 214
      Top = 35
      Width = 187
      Height = 103
      Anchors = [akLeft, akTop, akBottom]
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
      WordWrap = False
    end
  end
  object GroupBox7: TGroupBox
    Left = 7
    Top = 8
    Width = 418
    Height = 201
    Caption = 'File selection'
    TabOrder = 3
    DesignSize = (
      418
      201)
    object DriveComboBox1: TDriveComboBox
      Left = 16
      Top = 24
      Width = 209
      Height = 19
      DirList = DirectoryListBox1
      TabOrder = 0
    end
    object DirectoryListBox1: TDirectoryListBox
      Left = 16
      Top = 49
      Width = 209
      Height = 144
      Anchors = [akLeft, akTop, akBottom]
      FileList = FileListBox1
      TabOrder = 1
    end
    object FileListBox1: TFileListBox
      Left = 231
      Top = 24
      Width = 178
      Height = 169
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      Mask = 
        '*.mp3;*.mp2;*.mp1;*.m4a;*.ogg;*.oga;*.flac;*.fla;*.ape;*.mac;*.w' +
        'v;*.mpc;*.mp+;*.mpp;*.ofr;*.ofs;*.tta;*.wav;*.wma'
      TabOrder = 2
      OnChange = FileListBox1Change
    end
  end
  object GrpBoxLyrics: TGroupBox
    Left = 431
    Top = 269
    Width = 314
    Height = 285
    Caption = 'Lyrics'
    TabOrder = 4
    object MemoLyrics: TMemo
      Left = 16
      Top = 16
      Width = 281
      Height = 257
      TabOrder = 0
    end
  end
  object BtnRemoveTag: TButton
    Left = 545
    Top = 569
    Width = 98
    Height = 25
    Caption = 'Remove Tag'
    TabOrder = 5
    OnClick = BtnRemoveTagClick
  end
  object BtnSave: TButton
    Left = 649
    Top = 569
    Width = 96
    Height = 25
    Caption = 'Save changes'
    TabOrder = 6
    OnClick = BtnSaveClick
  end
end
