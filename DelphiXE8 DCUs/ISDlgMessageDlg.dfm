object TISShowMessageDlg: TTISShowMessageDlg
  Left = 192
  Top = 114
  BorderStyle = bsSingle
  Caption = 'TISShowMessageDlg'
  ClientHeight = 98
  ClientWidth = 597
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object BtnOk: TButton
    Left = 104
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = BtnOkClick
  end
  object MmoMessage: TMemo
    Left = 0
    Top = 0
    Width = 597
    Height = 58
    Align = alTop
    Alignment = taCenter
    BorderStyle = bsNone
    Lines.Strings = (
      '12345678901234567890123456789012345678901234567890'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '88888')
    TabOrder = 1
  end
end
