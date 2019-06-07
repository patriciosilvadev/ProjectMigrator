unit ViewDados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Vcl.Buttons, DAO, MyUtils, Vcl.ExtCtrls;

type
  TWindowDados = class(TForm)
    LblFileName: TLabel;
    GridDatas: TStringGrid;
    LblTotRows: TLabel;
    LblTotCols: TLabel;
    BtnFields: TSpeedButton;
    Images: TImageList;
    Actions: TActionList;
    ActConfigFields: TAction;
    BtnSelect: TSpeedButton;
    ActSelect: TAction;
    PanelSearch: TPanel;
    TxtTotRows: TEdit;
    LblTotRowsSelect: TLabel;
    ActOpenFile: TAction;
    SpeedButton1: TSpeedButton;
    OpenFile: TFileOpenDialog;
    procedure ActConfigFieldsExecute(Sender: TObject);
    procedure ActSelectExecute(Sender: TObject);
    procedure ActOpenFileExecute(Sender: TObject);
  private
    procedure FillGrid;
  public
    { Public declarations }
  end;

var
  WindowDados: TWindowDados;

implementation

{$R *.dfm}

uses ViewFields;

procedure TWindowDados.ActConfigFieldsExecute(Sender: TObject);
begin
  WindowFields.ShowModal;
end;

procedure TWindowDados.ActOpenFileExecute(Sender: TObject);
begin
  if OpenFile.Execute then
  begin
    LblFileName.Caption := OpenFile.FileName;
    TConfigs.SetFilePath(OpenFile.FileName);
  end;
end;

procedure TWindowDados.ActSelectExecute(Sender: TObject);
begin
  FillGrid;
end;

procedure TWindowDados.FillGrid;
var
  Rows: TStringList;
  DataFlex: TDataFlex;
  Datas: TStringMatrix;
  ContRow, ContCol, TotRows: integer;
begin
  LblFileName.Caption := 'Arquivo Dataflex: ' + TConfigs.GetFilePath;

  TotRows := StrToInt(TxtTotRows.Text);

  Rows := TStringList.Create;
  Rows.LoadFromFile(TConfigs.GetFilePath);
  DataFlex := TDataFlex.Create(Rows);
  SetLength(Datas, DataFlex.GetRows, DataFlex.GetCols);
  Datas := DataFlex.ToMatrix;

  if TotRows > DataFlex.GetRows then
  begin
    TotRows := DataFlex.GetRows;
    TxtTotRows.Text := DataFlex.GetRows.ToString;
  end;

  GridDatas.RowCount := TotRows + 1;
  GridDatas.ColCount := DataFlex.GetCols + 1;
  LblTotRows.Caption := 'Linhas: ' + DataFlex.GetRows.ToString;
  LblTotCols.Caption := 'Colunas: ' + DataFlex.GetCols.ToString;

  for ContRow := 1 to TotRows do
  begin
    GridDatas.Cells[0, ContRow] := 'Dado ' + ContRow.ToString;
  end;

  for ContCol := 1 to DataFlex.GetCols do
  begin
    GridDatas.Cells[ContCol, 0] := 'Campo ' + ContCol.ToString;
  end;

  for ContRow := 1 to TotRows do
  begin
    for ContCol := 1 to DataFlex.GetCols do
    begin
      GridDatas.Cells[ContCol, ContRow] := Datas[ContRow - 1, ContCol - 1];
    end;
  end;
end;

end.
