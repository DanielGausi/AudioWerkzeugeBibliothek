object FormNewTagItem: TFormNewTagItem
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'New text tag item'
  ClientHeight = 197
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  DesignSize = (
    370
    197)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_FrameType: TLabel
    Left = 16
    Top = 24
    Width = 74
    Height = 13
    Caption = 'Key/description'
  end
  object lbl_FrameValue: TLabel
    Left = 16
    Top = 73
    Width = 26
    Height = 13
    Caption = 'Value'
  end
  object lblNoMoreFrames: TLabel
    Left = 16
    Top = 124
    Width = 170
    Height = 13
    Caption = 'No more known text items available'
  end
  object cbKey: TComboBox
    Left = 16
    Top = 41
    Width = 330
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
  end
  object edtValue: TEdit
    Left = 16
    Top = 91
    Width = 330
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object BtnOK: TButton
    Left = 271
    Top = 159
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object BtnCancel: TButton
    Left = 182
    Top = 159
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
