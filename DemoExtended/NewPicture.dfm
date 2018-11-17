object NewPic: TNewPic
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Select cover art'
  ClientHeight = 314
  ClientWidth = 337
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 16
    Top = 120
    Width = 177
    Height = 177
    Proportional = True
    Stretch = True
  end
  object Label1: TLabel
    Left = 16
    Top = 13
    Width = 24
    Height = 13
    Caption = 'Type'
  end
  object Label2: TLabel
    Left = 16
    Top = 59
    Width = 155
    Height = 13
    Caption = 'Short description (e.g. filename)'
  end
  object cbPicType: TComboBox
    Left = 16
    Top = 32
    Width = 177
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 3
    TabOrder = 0
    Text = 'Cover Art (front)'
    Items.Strings = (
      'Cover Art (other)'
      'Cover Art (icon)'
      'Cover Art (other icon)'
      'Cover Art (front)'
      'Cover Art (back)'
      'Cover Art (leaflet)'
      'Cover Art (media)'
      'Cover Art (lead)'
      'Cover Art (artist)'
      'Cover Art (conductor)'
      'Cover Art (band)'
      'Cover Art (composer)'
      'Cover Art (lyricist)'
      'Cover Art (studio)'
      'Cover Art (recording)'
      'Cover Art (performance)'
      'Cover Art (movie scene)'
      'Cover Art (colored fish)'
      'Cover Art (illustration)'
      'Cover Art (band logo)'
      'Cover Art (publisher logo)')
  end
  object EdtDescription: TEdit
    Left = 16
    Top = 80
    Width = 177
    Height = 21
    TabOrder = 1
  end
  object BtnSearch: TButton
    Left = 216
    Top = 30
    Width = 106
    Height = 25
    Caption = 'Open picture'
    TabOrder = 2
    OnClick = BtnSearchClick
  end
  object BtnOK: TButton
    Left = 247
    Top = 272
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
  end
  object BtnCancel: TButton
    Left = 247
    Top = 241
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 264
    Top = 120
  end
end
