unit ConnectionFactory;

interface

uses
  System.SysUtils, System.Classes, System.Types, Vcl.Forms, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  Config;

type
  TConnFactory = class(TDataModule)
    Conn: TFDConnection;
    Trans: TFDTransaction;
    QuerySQL: TFDQuery;
    QueryFields: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);

  end;

var
  ConnFactory: TConnFactory;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TConnFactory.DataModuleCreate(Sender: TObject);
var
  UserName, Password, Database: string;
begin
  TConfig.GetDB(UserName, Password, Database);
  Conn.Params.UserName := UserName;
  Conn.Params.Password := Password;
  Conn.Params.Database := Database;
end;

end.
