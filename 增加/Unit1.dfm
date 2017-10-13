object Form1: TForm1
  Left = 692
  Top = 207
  Width = 798
  Height = 565
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ComboBox1: TComboBox
    Left = 136
    Top = 32
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'ComboBox1'
  end
  object ListBox1: TListBox
    Left = 32
    Top = 96
    Width = 305
    Height = 249
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBox1Click
  end
  object ListBox2: TListBox
    Left = 400
    Top = 96
    Width = 257
    Height = 241
    ItemHeight = 13
    TabOrder = 2
  end
  object Button1: TButton
    Left = 32
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 256
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 4
    OnClick = Button2Click
  end
end
