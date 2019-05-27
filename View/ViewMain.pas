unit ViewMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ExtDlgs,
  ViewDB;

type
  TWindowMain = class(TForm)
    Title1: TLabel;
    Title2: TLabel;
    Title3: TLabel;
    TxtLog: TMemo;
    BtnStart: TSpeedButton;
    OpenFile: TOpenTextFileDialog;
    BtnOpenFile: TSpeedButton;
    Images: TImageList;
    Actions: TActionList;
    ActOpenFile: TAction;
    SpeedButton1: TSpeedButton;
    ActConfigDB: TAction;
    procedure BtnStartClick(Sender: TObject);
    procedure Log(Msg: string);
    procedure ActOpenFileExecute(Sender: TObject);
    procedure ActConfigDBExecute(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WindowMain: TWindowMain;

implementation

{$R *.dfm}

procedure TWindowMain.ActConfigDBExecute(Sender: TObject);
begin
  WindowDB.ShowModal;
end;

procedure TWindowMain.ActOpenFileExecute(Sender: TObject);
begin
  OpenFile.Execute(Handle);
end;

procedure TWindowMain.BtnStartClick(Sender: TObject);
begin
  //
end;

procedure TWindowMain.Log(Msg: string);
begin
  TxtLog.Lines.Add(Msg);
end;

end.
