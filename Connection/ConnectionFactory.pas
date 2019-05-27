unit ConnectionFactory;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TConnFactory = class(TDataModule)
    Conn: TFDConnection;
    Trans: TFDTransaction;
    QuerySQL: TFDQuery;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    IntegerField3: TIntegerField;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    BCDField1: TBCDField;
    BCDField2: TBCDField;
    SQLTimeStampField1: TSQLTimeStampField;
    SQLTimeStampField2: TSQLTimeStampField;
    SQLTimeStampField3: TSQLTimeStampField;
    DateField1: TDateField;
    DateField2: TDateField;
    BCDField3: TBCDField;
    DateField3: TDateField;
    BCDField4: TBCDField;
    BCDField5: TBCDField;
    BCDField6: TBCDField;
    BCDField7: TBCDField;
    BCDField8: TBCDField;
    BCDField9: TBCDField;
    BCDField10: TBCDField;
    StringField8: TStringField;
    StringField9: TStringField;
    BCDField11: TBCDField;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    SmallintField1: TSmallintField;
    StringField13: TStringField;
    StringField14: TStringField;
    StringField15: TStringField;
    StringField16: TStringField;
    StringField17: TStringField;
    SmallintField2: TSmallintField;
    SmallintField3: TSmallintField;
    IntegerField4: TIntegerField;
    SmallintField4: TSmallintField;
    CurrencyField1: TCurrencyField;
    StringField18: TStringField;
    IntegerField5: TIntegerField;
    BCDField12: TBCDField;
    StringField19: TStringField;
    IntegerField6: TIntegerField;
    IntegerField7: TIntegerField;
    BCDField13: TBCDField;
    SmallintField5: TSmallintField;
    BCDField14: TBCDField;
    StringField20: TStringField;
    StringField21: TStringField;
    SmallintField6: TSmallintField;
    IntegerField8: TIntegerField;
    BCDField15: TBCDField;
    SmallintField7: TSmallintField;
    QueryTable: TFDQuery;
    IntegerField9: TIntegerField;
    IntegerField10: TIntegerField;
    StringField22: TStringField;
    StringField23: TStringField;
    StringField24: TStringField;
    IntegerField11: TIntegerField;
    StringField25: TStringField;
    StringField26: TStringField;
    StringField27: TStringField;
    StringField28: TStringField;
    BCDField16: TBCDField;
    BCDField17: TBCDField;
    SQLTimeStampField4: TSQLTimeStampField;
    SQLTimeStampField5: TSQLTimeStampField;
    SQLTimeStampField6: TSQLTimeStampField;
    DateField4: TDateField;
    DateField5: TDateField;
    BCDField18: TBCDField;
    DateField6: TDateField;
    BCDField19: TBCDField;
    BCDField20: TBCDField;
    BCDField21: TBCDField;
    BCDField22: TBCDField;
    BCDField23: TBCDField;
    BCDField24: TBCDField;
    BCDField25: TBCDField;
    StringField29: TStringField;
    StringField30: TStringField;
    BCDField26: TBCDField;
    StringField31: TStringField;
    StringField32: TStringField;
    StringField33: TStringField;
    SmallintField8: TSmallintField;
    StringField34: TStringField;
    StringField35: TStringField;
    StringField36: TStringField;
    StringField37: TStringField;
    StringField38: TStringField;
    SmallintField9: TSmallintField;
    SmallintField10: TSmallintField;
    IntegerField12: TIntegerField;
    SmallintField11: TSmallintField;
    CurrencyField2: TCurrencyField;
    StringField39: TStringField;
    IntegerField13: TIntegerField;
    BCDField27: TBCDField;
    StringField40: TStringField;
    IntegerField14: TIntegerField;
    IntegerField15: TIntegerField;
    BCDField28: TBCDField;
    SmallintField12: TSmallintField;
    BCDField29: TBCDField;
    StringField41: TStringField;
    StringField42: TStringField;
    SmallintField13: TSmallintField;
    IntegerField16: TIntegerField;
    BCDField30: TBCDField;
    SmallintField14: TSmallintField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConnFactory: TConnFactory;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TConnFactory.DataModuleCreate(Sender: TObject);
begin
  if FileExists(ExtractFilePath(Application.ExeName) + '..\..\DB\NSC.FDB') then
  begin
    Conn.Params.Database := ExtractFilePath(Application.ExeName) + '..\..\DB\NSC.FDB';
  end
  else
  begin
    Conn.Params.Database := ExtractFilePath(Application.ExeName) + 'DB\NSC.FDB';
  end;
end;

end.
