unit ViewDB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.StdCtrls, Vcl.Buttons, ConnectionFactory;

type
  TWindowDB = class(TForm)
    ImageTitle: TImage;
    LblUserName: TLabel;
    TxtUserName: TEdit;
    LblPassword: TLabel;
    TxtPassword: TEdit;
    LblDatabase: TLabel;
    TxtDatabase: TEdit;
    LblTable: TLabel;
    TxtTable: TEdit;
    BtnPronto: TSpeedButton;
    BtnTestConn: TSpeedButton;
    procedure BtnTestConnClick(Sender: TObject);
    procedure BtnProntoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WindowDB: TWindowDB;

implementation

{$R *.dfm}

procedure TWindowDB.BtnProntoClick(Sender: TObject);
begin
  Close;
end;

procedure TWindowDB.BtnTestConnClick(Sender: TObject);
begin
  ConnFactory.Conn.Params.UserName := TxtUserName.Text;
  ConnFactory.Conn.Params.Password := TxtPassword.Text;
  ConnFactory.Conn.Params.Database := TxtDatabase.Text;
  try
    ConnFactory.Conn.Connected := true;
  except on E: Exception do
    ShowMessage('Erro de conex�o: ' + E.ToString);
  end;
end;

end.
