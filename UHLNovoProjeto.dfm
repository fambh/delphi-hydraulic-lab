object frmNovoProjeto: TfrmNovoProjeto
  Left = 416
  Top = 169
  Width = 613
  Height = 410
  Caption = 'Novo Projeto'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 597
    Height = 42
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 15
      Width = 118
      Height = 13
      Caption = 'Quantidade de Entradas:'
    end
    object Label2: TLabel
      Left = 224
      Top = 15
      Width = 110
      Height = 13
      Caption = 'Quantidade de Sa'#237'das:'
    end
    object sedInput: TSpinEdit
      Left = 144
      Top = 11
      Width = 49
      Height = 22
      MaxValue = 20
      MinValue = 1
      TabOrder = 0
      Value = 2
      OnChange = sedInputChange
    end
    object sedOutput: TSpinEdit
      Left = 352
      Top = 11
      Width = 49
      Height = 22
      MaxValue = 20
      MinValue = 1
      TabOrder = 1
      Value = 1
      OnChange = sedOutputChange
    end
    object btnOk: TBitBtn
      Left = 489
      Top = 9
      Width = 99
      Height = 25
      Caption = 'Processar'
      TabOrder = 2
      Kind = bkOK
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 42
    Width = 597
    Height = 329
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object grid: TStringGrid
      Left = 0
      Top = 25
      Width = 597
      Height = 215
      Align = alClient
      ColCount = 3
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      OnKeyPress = gridKeyPress
      OnSelectCell = gridSelectCell
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 597
      Height = 25
      Align = alTop
      TabOrder = 1
      object Label3: TLabel
        Left = 7
        Top = 6
        Width = 76
        Height = 13
        Caption = 'Tabela Verdade'
      end
    end
    object mem: TMemo
      Left = 0
      Top = 240
      Width = 597
      Height = 89
      Align = alBottom
      TabOrder = 2
    end
  end
end
