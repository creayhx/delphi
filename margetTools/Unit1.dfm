object Form1: TForm1
  Left = 1183
  Top = 669
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Tools'
  ClientHeight = 33
  ClientWidth = 169
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 48
    Top = 5
    Width = 75
    Height = 25
    Caption = #24110#21161
    TabOrder = 0
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 160
    Top = 65528
  end
end
