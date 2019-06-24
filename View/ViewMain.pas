unit ViewMain;

interface

uses
  System.SysUtils, System.Classes, System.Types, Winapi.Windows, Winapi.Messages, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Vcl.ExtDlgs, Vcl.ComCtrls,
  ViewDB, ViewFields, ViewDatas, ViewConfigs, Arrays, Configs, MyUtils, DataFlex, DAO;

type
  TWindowMain = class(TForm)
    LblTitle1: TLabel;
    LblTitle3: TLabel;
    TxtLog: TMemo;
    BtnStart: TSpeedButton;
    BtnOpenFile: TSpeedButton;
    BtnDatabase: TSpeedButton;
    BtnFields: TSpeedButton;
    OpenFile: TFileOpenDialog;
    BtnDatas: TSpeedButton;
    BtnStop: TSpeedButton;
    BtnConfigs: TSpeedButton;
    ProgressBar: TProgressBar;
    Images: TImageList;
    Actions: TActionList;
    ActOpenFile: TAction;
    ActConfigDB: TAction;
    ActConfigFields: TAction;
    ActDados: TAction;
    ActConfigs: TAction;
    procedure ActOpenFileExecute(Sender: TObject);
    procedure ActConfigDBExecute(Sender: TObject);
    procedure ActConfigFieldsExecute(Sender: TObject);
    procedure ActDadosExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnStopClick(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure ActConfigsExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure Log(Msg: string);
  end;

  TMigration = class(TThread)
  protected
    procedure Execute; override;
    procedure Handle(Data: string; E: Exception);
  public
    constructor Create;
  end;


var
  WindowMain: TWindowMain;
  MigrationEnabled: boolean = false;

implementation

{
--> PROJECT DEFAULTS <--

-To keep code always clean and organized;
-To create variables, objects and components always in english;
-To comment everything that you can;

-Forms Order -> ViewMain - ViewDatas - ViewConfigs - ViewFields - ViewDB;

-Units Order -> Arrays - MyUtils - DataFlex - Configs - Fields - DAO - ConnectionFactory;

-Default Uses -> System.SysUtils, System.Classes, System.Types;

--> PROJECT IDEAS <--

-To put a DataFlex file modify option on ViewDatas;
}

{$R *.dfm}

procedure TWindowMain.ActOpenFileExecute(Sender: TObject);
begin
  if OpenFile.Execute then
  begin
    TConfigs.SetConfig('TEMP', 'FilePath', OpenFile.FileName);
    ActOpenFile.ImageIndex := 5;
    BtnOpenFile.Action := ActOpenFile;
  end;
end;

procedure TWindowMain.ActConfigDBExecute(Sender: TObject);
begin
  WindowDB.ShowModal;
end;

procedure TWindowMain.ActConfigFieldsExecute(Sender: TObject);
begin
  WindowFields.ShowModal;
end;

procedure TWindowMain.ActConfigsExecute(Sender: TObject);
begin
  WindowConfigs.ShowModal;
end;

procedure TWindowMain.ActDadosExecute(Sender: TObject);
begin
  WindowDatas.ShowModal;
  if TConfigs.GetConfig('TEMP', 'FilePath').Trim <> '' then
  begin
    ActOpenFile.ImageIndex := 5;
    BtnOpenFile.Action := ActOpenFile;
  end;
end;

procedure TWindowMain.BtnStartClick(Sender: TObject);
begin
  if TConfigs.GetConfig('TEMP', 'FilePath') = '' then
  begin
    if OpenFile.Execute then
    begin
      TConfigs.SetConfig('TEMP', 'FilePath', OpenFile.FileName);
      ActOpenFile.ImageIndex := 5;
      BtnOpenFile.Action := ActOpenFile;
      BtnStart.Enabled := false;
      BtnStop.Enabled := true;
      MigrationEnabled := true;
      TMigration.Create;
    end;
  end
  else
  begin
    BtnStart.Enabled := false;
    BtnStop.Enabled := true;
    MigrationEnabled := true;
    TMigration.Create;
  end;
end;

procedure TWindowMain.BtnStopClick(Sender: TObject);
begin
  MigrationEnabled := false;
end;

procedure TWindowMain.Log(Msg: string);
begin
  TxtLog.Lines.Add(Msg);
end;

procedure TWindowMain.FormActivate(Sender: TObject);
begin
  TConfigs.SetConfig('TEMP', 'FilePath', '');
  WindowState := TUtils.Iff(TConfigs.GetConfig('SYSTEM', 'WindowState') = '2', wsMaximized, wsNormal);
end;

procedure TWindowMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Answer: integer;
begin
  if MigrationEnabled then
  begin
    Answer := MessageDlg('Deseja cancelar a migra��o?', mtWarning, mbYesNo, 0, mbNo);

    if Answer = mrYes then
    begin
      MigrationEnabled := false;
      TConfigs.SetConfig('TEMP', 'FilePath', '');
      TConfigs.SetConfig('SYSTEM', 'WindowState', TUtils.Iff(WindowMain.WindowState = wsMaximized, '2', '0'));
    end
    else if Answer = mrNo then
    begin
      Action := caNone;
    end;

  end
  else
  begin
    TConfigs.SetConfig('TEMP', 'FilePath', '');
    TConfigs.SetConfig('SYSTEM', 'WindowState', TUtils.Iff(WindowMain.WindowState = wsMaximized, '2', '0'));
  end;
end;

{ TMyThread }

constructor TMigration.Create;
begin
  inherited Create(false);
end;

//TO COMMENT
procedure TMigration.Execute;
var
  Rows: TStringList;
  DataFlex: TDataFlex;
  Datas: TStringMatrix;
  ContRow, ContCol, Step: integer;
  Commit, Limit, TruncFB: integer;
  OutStr: string;
begin
  //Chama do m�todo sobreposto na classe m�e
  inherited;
  //Passa as linhas do arquivo dataflex para uma StringList
  Rows := TStringList.Create;
  Rows.LoadFromFile(TConfigs.GetConfig('TEMP', 'FilePath'));
  //Passa as linhas data flex para a classe de tratamento
  DataFlex := TDataFlex.Create(Rows);
  SetLength(Datas, DataFlex.GetRows, DataFlex.GetCols);
  //Tranforma as linhas do arquivo em uma matriz com linhas e colunas
  Datas := DataFlex.ToMatrix;
  try
    try
      //Verifica se o Firebird est� devidamente configurado
      if TDAO.Count <= 0 then
      begin
        ShowMessage('Selecione uma tabela v�lida!');
      end
      else if WindowFields.IsClean then
      begin
        ShowMessage('Configure os campos!');
      end
      else
      begin
        WindowMain.TxtLog.Clear;

        //Busca as configura��es
        TConfigs.GetGeneral(Commit, Limit, TruncFB);

        Commit := TUtils.Iff(Commit = -1, DataFlex.GetRows, TUtils.IfBigger(Commit, DataFlex.GetRows));
        Limit := TUtils.Iff(Limit = -1, DataFlex.GetRows, TUtils.IfBigger(Limit, DataFlex.GetRows));

        Step := Commit;

        //Trunca tabela Firebird
        if TruncFB = 1 then
        begin
          TDAO.Truncate;
        end;

        //Ajusta a barra de carregamento
        WindowMain.ProgressBar.Position := 0;
        WindowMain.ProgressBar.Max := Limit;

        //Passa por cada linha Dataflex
        for ContRow := 0 to Limit - 1 do
        begin
          //Verifica se a migra��o n�o foi parada
          if MigrationEnabled then
          begin
            //Manda os dados para classe DAO para inserir
            TDAO.Insert(Datas[ContRow], WindowFields.GetOrder, WindowFields.GetDefauts);
            //Manda os dados para o log
            WindowMain.Log('DADO ' + (ContRow + 1).ToString + ' INSERIDO -> ' + TUtils.ArrayToStr(Datas[ContRow]));
            //Atualiza a barra de carregamento
            WindowMain.ProgressBar.StepIt;
            if ContRow + 1 = Step then
            begin
              TDAO.Commit;
              WindowMain.Log('COMITADO!');
              Step := Step + Commit;
            end;
          end
          else
          begin
            //Quando a migra��o � interrompida
            WindowMain.Log('PARADO!');
            break;
          end;
        end;
        WindowMain.Log('MIGRA��O FINALIZADA!');
      end;
    except on E: Exception do
      //Tratamento de erros
      Handle((ContRow + 1).ToString, E);
    end;
  finally
    WindowMain.BtnStart.Enabled := true;
    WindowMain.BtnStop.Enabled := false;
    MigrationEnabled := false;
    FreeAndNil(Rows);
    FreeAndNil(DataFlex);
  end;
end;

procedure TMigration.Handle(Data: string; E: Exception);
begin
  WindowMain.Log('ERRO NO DADO ' + Data + ' -> ' + E.ToString);
  TDAO.Rollback;
end;

end.
