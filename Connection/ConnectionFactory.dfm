object ConnFactory: TConnFactory
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 139
  Width = 161
  object Conn: TFDConnection
    Params.Strings = (
      'DriverID=FB'
      'User_Name=sysdba'
      'Password=masterkey')
    LoginPrompt = False
    Left = 24
    Top = 16
  end
  object Trans: TFDTransaction
    Connection = Conn
    Left = 104
    Top = 16
  end
  object QuerySQL: TFDQuery
    Connection = Conn
    Left = 24
    Top = 80
    object IntegerField1: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object IntegerField2: TIntegerField
      FieldName = 'CODGRU'
      Origin = 'CODGRU'
    end
    object StringField1: TStringField
      FieldName = 'CODPRO'
      Origin = 'CODPRO'
      Required = True
      Size = 14
    end
    object StringField2: TStringField
      FieldName = 'CODBAR'
      Origin = 'CODBAR'
    end
    object StringField3: TStringField
      FieldName = 'NOMPRO'
      Origin = 'NOMPRO'
      Size = 120
    end
    object IntegerField3: TIntegerField
      FieldName = 'CODFOR'
      Origin = 'CODFOR'
    end
    object StringField4: TStringField
      FieldName = 'NOMFOR'
      Origin = 'NOMFOR'
      Size = 60
    end
    object StringField5: TStringField
      FieldName = 'UN'
      Origin = 'UN'
      Size = 6
    end
    object StringField6: TStringField
      FieldName = 'TRIBUT'
      Origin = 'TRIBUT'
      Size = 3
    end
    object StringField7: TStringField
      FieldName = 'REF'
      Origin = 'REF'
    end
    object BCDField1: TBCDField
      FieldName = 'IPI_E'
      Origin = 'IPI_E'
      Precision = 18
      Size = 2
    end
    object BCDField2: TBCDField
      FieldName = 'ICMS_E'
      Origin = 'ICMS_E'
      Precision = 18
      Size = 2
    end
    object SQLTimeStampField1: TSQLTimeStampField
      FieldName = 'DH_CAD'
      Origin = 'DH_CAD'
      Required = True
    end
    object SQLTimeStampField2: TSQLTimeStampField
      FieldName = 'DH_ALT'
      Origin = 'DH_ALT'
    end
    object SQLTimeStampField3: TSQLTimeStampField
      FieldName = 'DH_ESTOQUE'
      Origin = 'DH_ESTOQUE'
    end
    object DateField1: TDateField
      FieldName = 'DT_UVENDA'
      Origin = 'DT_UVENDA'
    end
    object DateField2: TDateField
      FieldName = 'DT_UCOMPRA'
      Origin = 'DT_UCOMPRA'
    end
    object BCDField3: TBCDField
      FieldName = 'UPVEN'
      Origin = 'UPVEN'
      Precision = 18
      Size = 2
    end
    object DateField3: TDateField
      FieldName = 'DT_ALT_PRECO'
      Origin = 'DT_ALT_PRECO'
    end
    object BCDField4: TBCDField
      FieldName = 'LUCRO1'
      Origin = 'LUCRO1'
      Precision = 18
      Size = 3
    end
    object BCDField5: TBCDField
      FieldName = 'PVENDA'
      Origin = 'PVENDA'
      Precision = 18
      Size = 2
    end
    object BCDField6: TBCDField
      FieldName = 'PCUSTOL'
      Origin = 'PCUSTOL'
      Precision = 18
      Size = 2
    end
    object BCDField7: TBCDField
      FieldName = 'PCUSTOB'
      Origin = 'PCUSTOB'
      Precision = 18
      Size = 2
    end
    object BCDField8: TBCDField
      FieldName = 'PCUSTOM'
      Origin = 'PCUSTOM'
      Precision = 18
      Size = 2
    end
    object BCDField9: TBCDField
      FieldName = 'ESTOQUE'
      Origin = 'ESTOQUE'
      Precision = 18
      Size = 2
    end
    object BCDField10: TBCDField
      FieldName = 'ESTMIN'
      Origin = 'ESTMIN'
      Precision = 18
      Size = 2
    end
    object StringField8: TStringField
      FieldName = 'GRADE'
      Origin = 'GRADE'
      Size = 5
    end
    object StringField9: TStringField
      FieldName = 'QUANTINV'
      Origin = 'QUANTINV'
      Size = 5
    end
    object BCDField11: TBCDField
      FieldName = 'ALIQUOTA'
      Origin = 'ALIQUOTA'
      Precision = 18
      Size = 2
    end
    object StringField10: TStringField
      FieldName = 'OBSERVACAO'
      Origin = 'OBSERVACAO'
      Size = 300
    end
    object StringField11: TStringField
      FieldName = 'CST'
      Origin = 'CST'
      FixedChar = True
      Size = 3
    end
    object StringField12: TStringField
      FieldName = 'NCM'
      Origin = 'NCM'
      Size = 8
    end
    object SmallintField1: TSmallintField
      FieldName = 'TIPO'
      Origin = 'TIPO'
    end
    object StringField13: TStringField
      FieldName = 'IAT'
      Origin = 'IAT'
      Required = True
      FixedChar = True
      Size = 1
    end
    object StringField14: TStringField
      FieldName = 'IPPT'
      Origin = 'IPPT'
      Required = True
      FixedChar = True
      Size = 1
    end
    object StringField15: TStringField
      FieldName = 'ATIVO'
      Origin = 'ATIVO'
      Size = 5
    end
    object StringField16: TStringField
      FieldName = 'MARCA'
      Origin = 'MARCA'
      Size = 5
    end
    object StringField17: TStringField
      FieldName = 'ORIG'
      Origin = 'ORIG'
      Required = True
      Size = 1
    end
    object SmallintField2: TSmallintField
      FieldName = 'ID_PIS_COFINS'
      Origin = 'ID_PIS_COFINS'
    end
    object SmallintField3: TSmallintField
      FieldName = 'ID_SECAO'
      Origin = 'ID_SECAO'
    end
    object IntegerField4: TIntegerField
      FieldName = 'SECAO_POS'
      Origin = 'SECAO_POS'
    end
    object SmallintField4: TSmallintField
      FieldName = 'CODPOSSE'
      Origin = 'CODPOSSE'
    end
    object CurrencyField1: TCurrencyField
      FieldName = 'IBPT_ALIQ'
      Origin = 'IBPT_ALIQ'
    end
    object StringField18: TStringField
      FieldName = 'COMPOSICAO'
      Origin = 'COMPOSICAO'
      Size = 5
    end
    object IntegerField5: TIntegerField
      FieldName = 'PESO_G'
      Origin = 'PESO_G'
    end
    object BCDField12: TBCDField
      FieldName = 'ESTFIS'
      Origin = 'ESTFIS'
      Precision = 18
      Size = 2
    end
    object StringField19: TStringField
      FieldName = 'LINK'
      Origin = 'LINK'
      Size = 125
    end
    object IntegerField6: TIntegerField
      FieldName = 'COD_BALANCA'
      Origin = 'COD_BALANCA'
    end
    object IntegerField7: TIntegerField
      FieldName = 'ID_SUBSECAO'
      Origin = 'ID_SUBSECAO'
    end
    object BCDField13: TBCDField
      FieldName = 'PESO_BRUTO'
      Origin = 'PESO_BRUTO'
      Precision = 18
      Size = 3
    end
    object SmallintField5: TSmallintField
      FieldName = 'USA_INDICE'
      Origin = 'USA_INDICE'
    end
    object BCDField14: TBCDField
      FieldName = 'VR_INDICE'
      Origin = 'VR_INDICE'
      Precision = 18
      Size = 2
    end
    object StringField20: TStringField
      FieldName = 'CEST'
      Origin = 'CEST'
      Size = 7
    end
    object StringField21: TStringField
      FieldName = 'OBS_NFE'
      Origin = 'OBS_NFE'
      Size = 1
    end
    object SmallintField6: TSmallintField
      FieldName = 'ID_EMP'
      Origin = 'ID_EMP'
      Required = True
    end
    object IntegerField8: TIntegerField
      FieldName = 'ID_MARCAS'
      Origin = 'ID_MARCAS'
    end
    object BCDField15: TBCDField
      FieldName = 'PVENDAP'
      Origin = 'PVENDAP'
      Precision = 18
      Size = 2
    end
    object SmallintField7: TSmallintField
      FieldName = 'ALT'
      Origin = 'ALT'
    end
  end
  object QueryTable: TFDQuery
    Connection = Conn
    Left = 104
    Top = 80
    object IntegerField9: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object IntegerField10: TIntegerField
      FieldName = 'CODGRU'
      Origin = 'CODGRU'
    end
    object StringField22: TStringField
      FieldName = 'CODPRO'
      Origin = 'CODPRO'
      Required = True
      Size = 14
    end
    object StringField23: TStringField
      FieldName = 'CODBAR'
      Origin = 'CODBAR'
    end
    object StringField24: TStringField
      FieldName = 'NOMPRO'
      Origin = 'NOMPRO'
      Size = 120
    end
    object IntegerField11: TIntegerField
      FieldName = 'CODFOR'
      Origin = 'CODFOR'
    end
    object StringField25: TStringField
      FieldName = 'NOMFOR'
      Origin = 'NOMFOR'
      Size = 60
    end
    object StringField26: TStringField
      FieldName = 'UN'
      Origin = 'UN'
      Size = 6
    end
    object StringField27: TStringField
      FieldName = 'TRIBUT'
      Origin = 'TRIBUT'
      Size = 3
    end
    object StringField28: TStringField
      FieldName = 'REF'
      Origin = 'REF'
    end
    object BCDField16: TBCDField
      FieldName = 'IPI_E'
      Origin = 'IPI_E'
      Precision = 18
      Size = 2
    end
    object BCDField17: TBCDField
      FieldName = 'ICMS_E'
      Origin = 'ICMS_E'
      Precision = 18
      Size = 2
    end
    object SQLTimeStampField4: TSQLTimeStampField
      FieldName = 'DH_CAD'
      Origin = 'DH_CAD'
      Required = True
    end
    object SQLTimeStampField5: TSQLTimeStampField
      FieldName = 'DH_ALT'
      Origin = 'DH_ALT'
    end
    object SQLTimeStampField6: TSQLTimeStampField
      FieldName = 'DH_ESTOQUE'
      Origin = 'DH_ESTOQUE'
    end
    object DateField4: TDateField
      FieldName = 'DT_UVENDA'
      Origin = 'DT_UVENDA'
    end
    object DateField5: TDateField
      FieldName = 'DT_UCOMPRA'
      Origin = 'DT_UCOMPRA'
    end
    object BCDField18: TBCDField
      FieldName = 'UPVEN'
      Origin = 'UPVEN'
      Precision = 18
      Size = 2
    end
    object DateField6: TDateField
      FieldName = 'DT_ALT_PRECO'
      Origin = 'DT_ALT_PRECO'
    end
    object BCDField19: TBCDField
      FieldName = 'LUCRO1'
      Origin = 'LUCRO1'
      Precision = 18
      Size = 3
    end
    object BCDField20: TBCDField
      FieldName = 'PVENDA'
      Origin = 'PVENDA'
      Precision = 18
      Size = 2
    end
    object BCDField21: TBCDField
      FieldName = 'PCUSTOL'
      Origin = 'PCUSTOL'
      Precision = 18
      Size = 2
    end
    object BCDField22: TBCDField
      FieldName = 'PCUSTOB'
      Origin = 'PCUSTOB'
      Precision = 18
      Size = 2
    end
    object BCDField23: TBCDField
      FieldName = 'PCUSTOM'
      Origin = 'PCUSTOM'
      Precision = 18
      Size = 2
    end
    object BCDField24: TBCDField
      FieldName = 'ESTOQUE'
      Origin = 'ESTOQUE'
      Precision = 18
      Size = 2
    end
    object BCDField25: TBCDField
      FieldName = 'ESTMIN'
      Origin = 'ESTMIN'
      Precision = 18
      Size = 2
    end
    object StringField29: TStringField
      FieldName = 'GRADE'
      Origin = 'GRADE'
      Size = 5
    end
    object StringField30: TStringField
      FieldName = 'QUANTINV'
      Origin = 'QUANTINV'
      Size = 5
    end
    object BCDField26: TBCDField
      FieldName = 'ALIQUOTA'
      Origin = 'ALIQUOTA'
      Precision = 18
      Size = 2
    end
    object StringField31: TStringField
      FieldName = 'OBSERVACAO'
      Origin = 'OBSERVACAO'
      Size = 300
    end
    object StringField32: TStringField
      FieldName = 'CST'
      Origin = 'CST'
      FixedChar = True
      Size = 3
    end
    object StringField33: TStringField
      FieldName = 'NCM'
      Origin = 'NCM'
      Size = 8
    end
    object SmallintField8: TSmallintField
      FieldName = 'TIPO'
      Origin = 'TIPO'
    end
    object StringField34: TStringField
      FieldName = 'IAT'
      Origin = 'IAT'
      Required = True
      FixedChar = True
      Size = 1
    end
    object StringField35: TStringField
      FieldName = 'IPPT'
      Origin = 'IPPT'
      Required = True
      FixedChar = True
      Size = 1
    end
    object StringField36: TStringField
      FieldName = 'ATIVO'
      Origin = 'ATIVO'
      Size = 5
    end
    object StringField37: TStringField
      FieldName = 'MARCA'
      Origin = 'MARCA'
      Size = 5
    end
    object StringField38: TStringField
      FieldName = 'ORIG'
      Origin = 'ORIG'
      Required = True
      Size = 1
    end
    object SmallintField9: TSmallintField
      FieldName = 'ID_PIS_COFINS'
      Origin = 'ID_PIS_COFINS'
    end
    object SmallintField10: TSmallintField
      FieldName = 'ID_SECAO'
      Origin = 'ID_SECAO'
    end
    object IntegerField12: TIntegerField
      FieldName = 'SECAO_POS'
      Origin = 'SECAO_POS'
    end
    object SmallintField11: TSmallintField
      FieldName = 'CODPOSSE'
      Origin = 'CODPOSSE'
    end
    object CurrencyField2: TCurrencyField
      FieldName = 'IBPT_ALIQ'
      Origin = 'IBPT_ALIQ'
    end
    object StringField39: TStringField
      FieldName = 'COMPOSICAO'
      Origin = 'COMPOSICAO'
      Size = 5
    end
    object IntegerField13: TIntegerField
      FieldName = 'PESO_G'
      Origin = 'PESO_G'
    end
    object BCDField27: TBCDField
      FieldName = 'ESTFIS'
      Origin = 'ESTFIS'
      Precision = 18
      Size = 2
    end
    object StringField40: TStringField
      FieldName = 'LINK'
      Origin = 'LINK'
      Size = 125
    end
    object IntegerField14: TIntegerField
      FieldName = 'COD_BALANCA'
      Origin = 'COD_BALANCA'
    end
    object IntegerField15: TIntegerField
      FieldName = 'ID_SUBSECAO'
      Origin = 'ID_SUBSECAO'
    end
    object BCDField28: TBCDField
      FieldName = 'PESO_BRUTO'
      Origin = 'PESO_BRUTO'
      Precision = 18
      Size = 3
    end
    object SmallintField12: TSmallintField
      FieldName = 'USA_INDICE'
      Origin = 'USA_INDICE'
    end
    object BCDField29: TBCDField
      FieldName = 'VR_INDICE'
      Origin = 'VR_INDICE'
      Precision = 18
      Size = 2
    end
    object StringField41: TStringField
      FieldName = 'CEST'
      Origin = 'CEST'
      Size = 7
    end
    object StringField42: TStringField
      FieldName = 'OBS_NFE'
      Origin = 'OBS_NFE'
      Size = 1
    end
    object SmallintField13: TSmallintField
      FieldName = 'ID_EMP'
      Origin = 'ID_EMP'
      Required = True
    end
    object IntegerField16: TIntegerField
      FieldName = 'ID_MARCAS'
      Origin = 'ID_MARCAS'
    end
    object BCDField30: TBCDField
      FieldName = 'PVENDAP'
      Origin = 'PVENDAP'
      Precision = 18
      Size = 2
    end
    object SmallintField14: TSmallintField
      FieldName = 'ALT'
      Origin = 'ALT'
    end
  end
end
