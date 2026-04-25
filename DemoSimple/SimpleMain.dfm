object SimpleTagger: TSimpleTagger
  Left = 0
  Top = 0
  Width = 635
  Height = 472
  Caption = 'AudioWerkzeugeBibliothek (Demo Level 1)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  DesignSize = (
    627
    441)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 606
    Height = 208
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'File selection'
    TabOrder = 0
    DesignSize = (
      606
      208)
    object DriveComboBox1: TDriveComboBox
      Left = 16
      Top = 24
      Width = 177
      Height = 19
      DirList = DirectoryListBox1
      TabOrder = 0
    end
    object DirectoryListBox1: TDirectoryListBox
      Left = 16
      Top = 49
      Width = 258
      Height = 156
      Anchors = [akLeft, akTop, akBottom]
      FileList = FileListBox1
      ItemHeight = 16
      TabOrder = 1
    end
    object FileListBox1: TFileListBox
      Left = 280
      Top = 16
      Width = 318
      Height = 189
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      Mask = 
        '*.mp3;*.mp2;*.mp1;*.m4a;*.ogg;*.oga;*.flac;*.fla;*.ape;*.mac;*.w' +
        'v;*.mpc;*.mp+;*.mpp;*.ofr;*.ofs;*.tta;*.wav;*.wma;*.opus'
      TabOrder = 2
      OnChange = FileListBox1Change
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 223
    Width = 606
    Height = 210
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'File properties'
    TabOrder = 1
    DesignSize = (
      606
      210)
    object Label1: TLabel
      Left = 16
      Top = 27
      Width = 20
      Height = 13
      Caption = 'Title'
    end
    object Label2: TLabel
      Left = 16
      Top = 54
      Width = 26
      Height = 13
      Caption = 'Artist'
    end
    object Label4: TLabel
      Left = 16
      Top = 81
      Width = 29
      Height = 13
      Caption = 'Album'
    end
    object Label3: TLabel
      Left = 16
      Top = 109
      Width = 29
      Height = 13
      Caption = 'Genre'
    end
    object Label6: TLabel
      Left = 144
      Top = 136
      Width = 26
      Height = 13
      Caption = 'Track'
    end
    object Label5: TLabel
      Left = 16
      Top = 136
      Width = 22
      Height = 13
      Caption = 'Year'
    end
    object Image1: TImage
      Left = 461
      Top = 24
      Width = 128
      Height = 128
      Anchors = [akTop, akRight]
      Proportional = True
      Stretch = True
    end
    object EdtTitle: TEdit
      Left = 72
      Top = 24
      Width = 177
      Height = 21
      TabOrder = 0
    end
    object EdtArtist: TEdit
      Left = 72
      Top = 51
      Width = 177
      Height = 21
      TabOrder = 1
    end
    object EdtAlbum: TEdit
      Left = 72
      Top = 78
      Width = 177
      Height = 21
      TabOrder = 2
    end
    object EdtGenre: TEdit
      Left = 72
      Top = 106
      Width = 177
      Height = 21
      TabOrder = 3
    end
    object EdtYear: TEdit
      Left = 72
      Top = 133
      Width = 57
      Height = 21
      TabOrder = 4
    end
    object EdtTrack: TEdit
      Left = 176
      Top = 133
      Width = 73
      Height = 21
      TabOrder = 5
    end
    object Memo1: TMemo
      Left = 264
      Top = 24
      Width = 191
      Height = 129
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
    end
    object BtnSave: TButton
      Left = 152
      Top = 168
      Width = 97
      Height = 25
      Caption = 'Save changes'
      TabOrder = 7
      OnClick = BtnSaveClick
    end
  end
end
