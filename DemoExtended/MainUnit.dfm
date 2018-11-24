object MainFormAPE: TMainFormAPE
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'AudioWerkzeugeBibliothek (Demo Level 2)'
  ClientHeight = 636
  ClientWidth = 642
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
    Top = 98
    Width = 307
    Height = 169
    Caption = 'Basic Data'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 27
      Width = 26
      Height = 13
      Caption = 'Artist'
    end
    object Label2: TLabel
      Left = 16
      Top = 57
      Width = 20
      Height = 13
      Caption = 'Title'
    end
    object Label3: TLabel
      Left = 16
      Top = 84
      Width = 29
      Height = 13
      Caption = 'Album'
    end
    object Label4: TLabel
      Left = 16
      Top = 111
      Width = 29
      Height = 13
      Caption = 'Genre'
    end
    object Label5: TLabel
      Left = 16
      Top = 138
      Width = 26
      Height = 13
      Caption = 'Track'
    end
    object Label6: TLabel
      Left = 208
      Top = 138
      Width = 22
      Height = 13
      Caption = 'Year'
    end
    object EdtArtist: TEdit
      Left = 72
      Top = 27
      Width = 220
      Height = 21
      TabOrder = 0
    end
    object EdtTitle: TEdit
      Left = 72
      Top = 54
      Width = 220
      Height = 21
      TabOrder = 1
    end
    object EdtAlbum: TEdit
      Left = 72
      Top = 81
      Width = 220
      Height = 21
      TabOrder = 2
    end
    object EdtGenre: TEdit
      Left = 72
      Top = 108
      Width = 220
      Height = 21
      TabOrder = 3
    end
    object EdtTrack: TEdit
      Left = 72
      Top = 135
      Width = 49
      Height = 21
      TabOrder = 4
    end
    object EdtYear: TEdit
      Left = 248
      Top = 135
      Width = 41
      Height = 21
      TabOrder = 5
    end
  end
  object GroupBox2: TGroupBox
    Left = 321
    Top = 9
    Width = 307
    Height = 258
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
      Left = 223
      Top = 16
      Width = 65
      Height = 25
      Caption = 'New'
      TabOrder = 1
      OnClick = BtnNewPictureClick
    end
    object BtnDeletePicture: TButton
      Left = 223
      Top = 47
      Width = 65
      Height = 25
      Caption = 'Delete'
      TabOrder = 2
      OnClick = BtnDeletePictureClick
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 8
    Width = 307
    Height = 84
    Caption = 'File selection'
    TabOrder = 2
    object BtnOpen: TButton
      Left = 16
      Top = 49
      Width = 75
      Height = 25
      Caption = 'Open file'
      TabOrder = 0
      OnClick = BtnLoadClick
    end
    object EdtFilename: TEdit
      Left = 16
      Top = 22
      Width = 281
      Height = 21
      TabOrder = 1
    end
    object BtnRemoveTag: TButton
      Left = 97
      Top = 49
      Width = 98
      Height = 25
      Caption = 'Remove Tag'
      TabOrder = 2
      OnClick = BtnRemoveTagClick
    end
    object BtnSave: TButton
      Left = 201
      Top = 49
      Width = 96
      Height = 25
      Caption = 'Save changes'
      TabOrder = 3
      OnClick = BtnSaveClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 273
    Width = 620
    Height = 168
    Caption = 'All data (here: read only, but writing is also possible)'
    TabOrder = 3
    DesignSize = (
      620
      168)
    object Label7: TLabel
      Left = 16
      Top = 24
      Width = 71
      Height = 13
      Caption = 'Available items'
    end
    object Label8: TLabel
      Left = 208
      Top = 24
      Width = 39
      Height = 13
      Caption = 'Content'
    end
    object lbKeys: TListBox
      Left = 16
      Top = 43
      Width = 179
      Height = 118
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbKeysClick
    end
    object MemoValue: TMemo
      Left = 201
      Top = 43
      Width = 416
      Height = 117
      Anchors = [akLeft, akTop, akBottom]
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
      WordWrap = False
    end
  end
  object GroupBox5: TGroupBox
    Left = 8
    Top = 447
    Width = 307
    Height = 178
    Caption = 'General audio information'
    TabOrder = 4
    object MemoAudio: TMemo
      Left = 2
      Top = 15
      Width = 303
      Height = 161
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object GroupBox6: TGroupBox
    Left = 321
    Top = 447
    Width = 304
    Height = 178
    Caption = 'Format specific information'
    TabOrder = 5
    object MemoSpecific: TMemo
      Left = 2
      Top = 15
      Width = 300
      Height = 161
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'ape'
    Filter = 
      'All Audio Files|*.mp3;*.mp2;*.mp1;*.m4a;*.ogg;*.oga;*.flac;*.fla' +
      ';*.ape;*.mac;*.wv;*.mpc;*.mp+;*.mpp;*.ofr;*.ofs;*.tta;*.wav;*.wm' +
      'a'
    FilterIndex = 2
    Left = 512
    Top = 8
  end
end
