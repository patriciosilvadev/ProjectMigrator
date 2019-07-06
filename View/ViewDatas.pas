unit ViewDatas;

interface

uses
  System.SysUtils, System.Classes, System.Types, Winapi.Windows, Winapi.Messages, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Vcl.Buttons, Vcl.ExtCtrls,
  ViewFields, Arrays, MyUtils, MyDialogs, Configs, DataFlex, Data.DB,
  Vcl.DBGrids;

type
  TWindowDatas = class(TForm)
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
    TxtRowsLimit: TEdit;
    LblRowsLimit: TLabel;
    ActOpenFile: TAction;
    BtnOpenFile: TSpeedButton;
    OpenFile: TFileOpenDialog;
    BtnAlter: TSpeedButton;
    ActAlter: TAction;
    ActAddCell: TAction;
    ActAddRow: TAction;
    ActAddCol: TAction;
    ActDelCell: TAction;
    ActDelRow: TAction;
    ActDelCol: TAction;
    BtnActCell: TSpeedButton;
    BtnDelCell: TSpeedButton;
    BtnAddRow: TSpeedButton;
    BtnDelRow: TSpeedButton;
    BtnAddCol: TSpeedButton;
    BtnDelCol: TSpeedButton;
    BtnCancel: TSpeedButton;
    ActCancel: TAction;
    BtnSave: TSpeedButton;
    ActSave: TAction;
    ActSaveAs: TAction;
    BtnSaveAs: TSpeedButton;
    SaveFile: TFileSaveDialog;
    TxtFileName: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActOpenFileExecute(Sender: TObject);
    procedure ActConfigFieldsExecute(Sender: TObject);
    procedure ActSelectExecute(Sender: TObject);
    procedure TxtRowsLimitKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActAlterExecute(Sender: TObject);
    procedure ActSaveAsExecute(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActAddCellExecute(Sender: TObject);
    procedure ActAddRowExecute(Sender: TObject);
    procedure ActAddColExecute(Sender: TObject);
    procedure ActDelCellExecute(Sender: TObject);
    procedure ActDelRowExecute(Sender: TObject);
    procedure ActDelColExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure GridDatasSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);

  private
    procedure FillGrid;
    procedure CleanGrid;
    function GridToStrList: TStringList;
    function GridIsClean: boolean;
    procedure DisableMode;
    procedure SelectMode;
    procedure NormalMode;
    procedure AlterMode;
    procedure UpdateGrid;
    procedure GridSize(RowCount, ColCount: integer);
    procedure GridTitles;
    procedure Altered;
    procedure Done;

  public
    procedure Teste(Row, Col: integer);

  end;

var
  WindowDatas: TWindowDatas;
  DidChange: boolean = false;
  Mode: integer;

implementation

{$R *.dfm}

//Quando a janela � aberta
procedure TWindowDatas.FormActivate(Sender: TObject);
var
  FilePath: string;
begin
  FilePath := TConfigs.GetConfig('TEMP', 'FilePath');
  if FilePath <> '' then
  begin
    if FilePath <> TxtFileName.Caption then
    begin
      CleanGrid;
      SelectMode;
    end
    else
    begin
      if GridIsClean then
      begin
        SelectMode;
      end
      else
      begin
        NormalMode;
        UpdateGrid;
      end;
    end;
  end
  else
  begin
    DisableMode;
  end;
  Done;
end;

//Quando a janela � fechada
procedure TWindowDatas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if DidChange then
  begin
    case TMyDialogs.YesNoCancel('Deseja salvar as altera��es?') of
    mrYes:
      ActSave.Execute;
    mrNo:
      ActCancel.Execute;
    mrCancel:
      Action := caNone;
    end;
  end;
end;

//Abre o arquivo Dataflex
procedure TWindowDatas.ActOpenFileExecute(Sender: TObject);
begin
  if OpenFile.Execute then
  begin
    if OpenFile.FileName <> TConfigs.GetConfig('TEMP', 'FilePath') then
    begin
      TConfigs.SetConfig('TEMP', 'FilePath', OpenFile.FileName);
      CleanGrid;
      SelectMode;
    end;
  end;
end;

//Abre a configura��o de campos
procedure TWindowDatas.ActConfigFieldsExecute(Sender: TObject);
begin
  WindowFields.ShowModal;
end;

//Joga os dados Dataflex na tabela
procedure TWindowDatas.ActSelectExecute(Sender: TObject);
begin
  try
    UpdateGrid;
    FillGrid;
    NormalMode;
    Done;
  Except on E: Exception do
    ShowMessage('Arquivo Inv�lido: ' + E.ToString);
  end;
end;

//Quando o enter � pressionado no TxtRowsLimit
procedure TWindowDatas.TxtRowsLimitKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key.ToString = '13' then
  begin
    ActSelect.Execute;
  end;
end;

//Quando uma Cell da Grid � editada
procedure TWindowDatas.GridDatasSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  if ARow = GridDatas.RowCount - 1 then
  begin
    ActAddRow.Execute;
  end;

  if ACol = GridDatas.ColCount - 1 then
  begin
    ActAddCol.Execute;
  end;

  Altered;
end;

//Ativa o modo de edi��o da Grid
procedure TWindowDatas.ActAlterExecute(Sender: TObject);
begin
  AlterMode;
end;

//Salva as altera��es feitas no aquivo
procedure TWindowDatas.ActSaveExecute(Sender: TObject);
begin
  UpdateGrid;
  GridToStrList.SaveToFile(TConfigs.GetConfig('TEMP', 'FilePath'));
  NormalMode;
  Done;
end;

//Salva as altera��es feitas em um novo arquivo
procedure TWindowDatas.ActSaveAsExecute(Sender: TObject);
begin
  SaveFile.FileName := 'NovoDataflex';
  if SaveFile.Execute then
  begin
    GridToStrList.SaveToFile(SaveFile.FileName);
  end;
end;

//Cancela as altera��e
procedure TWindowDatas.ActCancelExecute(Sender: TObject);
begin
  UpdateGrid;
  if DidChange then
  begin
    FillGrid;
  end;
  NormalMode;
  Done;
end;

//Adiciona uma nova c�lula na Grid
procedure TWindowDatas.ActAddCellExecute(Sender: TObject);
var
  Row, Col, Cont: integer;
begin
  Row := GridDatas.Row;
  Col := GridDatas.Col;

  for Cont := -(GridDatas.ColCount - 1) to -Col - 1 do
  begin
    GridDatas.Cells[-Cont, Row] := GridDatas.Cells[(-Cont) - 1, Row];
  end;

  GridDatas.Cells[Col, Row] := '';

  Altered;
end;

//Remove a c�lula selecionada na Grid
procedure TWindowDatas.ActDelCellExecute(Sender: TObject);
var
  Row, Col, Cont: integer;
begin
  Row := GridDatas.Row;
  Col := GridDatas.Col;

  for Cont := Col to GridDatas.ColCount - 1 do
  begin
    GridDatas.Cells[Cont, Row] := GridDatas.Cells[Cont + 1, Row];
  end;

  Altered;
end;

//Adiona uma nova linha na Grid
procedure TWindowDatas.ActAddRowExecute(Sender: TObject);
var
  Row, Cont: integer;
begin
  Row := GridDatas.Row;

  GridDatas.RowCount := GridDatas.RowCount + 1;

  for Cont := -(GridDatas.RowCount - 1) to -Row - 1 do
  begin
    GridDatas.Rows[-Cont] := GridDatas.Rows[(-Cont) - 1];
  end;

  GridDatas.Rows[Row].Clear;

  GridTitles;

  UpdateGrid;

  Altered;
end;

//Remove a linha selecionada na Grid
procedure TWindowDatas.ActDelRowExecute(Sender: TObject);
var
  Row, Cont: integer;
begin
  Row := GridDatas.Row;

  if (GridDatas.RowCount > 2) and (Row <> GridDatas.RowCount - 1) then
  begin
    GridDatas.RowCount := GridDatas.RowCount - 1;

    for Cont := Row to GridDatas.RowCount - 1 do
    begin
      GridDatas.Rows[Cont] := GridDatas.Rows[Cont + 1];
    end;

    GridTitles;

    UpdateGrid;

    Altered;
  end;
end;

//Adiciona uma nova coluna na Grid
procedure TWindowDatas.ActAddColExecute(Sender: TObject);
var
  Col, Cont: integer;
begin
  Col := GridDatas.Col;

  GridDatas.ColCount := GridDatas.ColCount + 1;

  for Cont := -(GridDatas.ColCount - 1) to -Col - 1 do
  begin
    GridDatas.Cols[-Cont] := GridDatas.Cols[(-Cont) - 1];
  end;

  GridDatas.Cols[Col].Clear;

  GridTitles;

  UpdateGrid;

  Altered;
end;

//Remove a coluna selecionada na Grid
procedure TWindowDatas.ActDelColExecute(Sender: TObject);
var
  Col, Cont: integer;
begin
  Col := GridDatas.Col;

  if (GridDatas.ColCount > 2) and (Col <> GridDatas.ColCount - 1) then
  begin
    GridDatas.ColCount := GridDatas.ColCount - 1;

    for Cont := Col to GridDatas.ColCount - 1 do
    begin
      GridDatas.Cols[Cont] := GridDatas.Cols[Cont + 1];
    end;

    GridTitles;

    UpdateGrid;

    Altered;
  end;
end;

//Insere os dados do arquivo Dataflex na Grid
procedure TWindowDatas.FillGrid;
var
  Rows: TStringList;
  DataFlex: TDataFlex;
  Datas: TStringMatrix;
  ContRow, ContCol, TotRows: integer;
begin
  Rows := TStringList.Create;
  Rows.LoadFromFile(TConfigs.GetConfig('TEMP', 'FilePath'));
  DataFlex := TDataFlex.Create(Rows, ';');
  SetLength(Datas, DataFlex.GetRows, DataFlex.GetCols);
  Datas := DataFlex.ToMatrix;

  if Trim(TxtRowsLimit.Text) = '' then
  begin
    TotRows := 0;
  end
  else
  begin
    TotRows := StrToInt(TxtRowsLimit.Text);
  end;

  if (TotRows > DataFlex.GetRows) or (TotRows = 0) then
  begin
    TotRows := DataFlex.GetRows;
    TxtRowsLimit.Text := DataFlex.GetRows.ToString;
  end;

  CleanGrid;

  GridSize(TotRows, DataFlex.GetCols);

  GridTitles;

  for ContRow := 1 to TotRows do
  begin
    for ContCol := 1 to DataFlex.GetCols do
    begin
      GridDatas.Cells[ContCol, ContRow] := Datas[ContRow - 1, ContCol - 1];
    end;
  end;
end;

//Limpa os dados da Grid
procedure TWindowDatas.CleanGrid;
begin
  GridDatas.RowCount := 2;
  GridDatas.ColCount := 2;
  GridDatas.Rows[0].Clear;
  GridDatas.Cols[0].Clear;
  GridDatas.Cols[1].Clear;
end;

//Retorna os dados da Grid em linhas numa StringList
function TWindowDatas.GridToStrList: TStringList;
var
  Cont: integer;
begin
  Result := TStringList.Create;
  for Cont := 1 to GridDatas.RowCount - 2 do
  begin
    Result.Add(TUtils.ArrayToStr(GridDatas.Rows[Cont].ToStringArray, 1, GridDatas.ColCount - 2, ';', ''));
  end;
end;

//Verifica se a Grid est� vazia
function TWindowDatas.GridIsClean: boolean;
begin
  Result := GridDatas.Cells[0, 1].IsEmpty and GridDatas.Cells[1, 0].IsEmpty and GridDatas.Cells[1, 1].IsEmpty;
end;

//Modo Buttons desabilitados
procedure TWindowDatas.DisableMode;
begin
  TxtRowsLimit.Enabled := false;
  ActSelect.Enabled := false;
  ActAlter.Enabled := false;
  ActSave.Enabled := false;
  ActSaveAs.Enabled := false;
  ActCancel.Enabled := false;
  ActAddCell.Enabled := false;
  ActDelCell.Enabled := false;
  ActAddRow.Enabled := false;
  ActDelRow.Enabled := false;
  ActAddCol.Enabled := false;
  ActDelCol.Enabled := false;
  GridDatas.Options := GridDatas.Options - [goEditing];
  LblTotRows.Caption := 'Dados:';
  LblTotCols.Caption := 'Campos:';
  TxtRowsLimit.Clear;
  Mode := 0;
end;

//Modo Button Select ativado
procedure TWindowDatas.SelectMode;
begin
  TxtRowsLimit.Enabled := true;
  TxtFileName.Caption := TConfigs.GetConfig('TEMP', 'FilePath');
  ActOpenFile.ImageIndex := 2;
  BtnOpenFile.Action := ActOpenFile;
  ActSelect.Enabled := true;
  ActAlter.Enabled := false;
  ActSave.Enabled := false;
  ActSaveAs.Enabled := false;
  ActCancel.Enabled := false;
  ActAddCell.Enabled := false;
  ActDelCell.Enabled := false;
  ActAddRow.Enabled := false;
  ActDelRow.Enabled := false;
  ActAddCol.Enabled := false;
  ActDelCol.Enabled := false;
  GridDatas.Options := GridDatas.Options - [goEditing];
  LblTotRows.Caption := 'Dados:';
  LblTotCols.Caption := 'Campos:';
  TxtRowsLimit.Clear;
  Mode := 1;
end;

//Modo Buttons normais
procedure TWindowDatas.NormalMode;
begin
  TxtRowsLimit.Enabled := true;
  TxtFileName.Caption := TConfigs.GetConfig('TEMP', 'FilePath');
  ActOpenFile.ImageIndex := 2;
  BtnOpenFile.Action := ActOpenFile;
  ActSelect.Enabled := true;
  ActAlter.Enabled := true;
  ActSave.Enabled := false;
  ActSaveAs.Enabled := true;
  ActCancel.Enabled := false;
  ActAddCell.Enabled := false;
  ActDelCell.Enabled := false;
  ActAddRow.Enabled := false;
  ActDelRow.Enabled := false;
  ActAddCol.Enabled := false;
  ActDelCol.Enabled := false;
  GridDatas.Options := GridDatas.Options - [goEditing];
  Mode := 2;
end;

//Modo Buttons em altera��o
procedure TWindowDatas.AlterMode;
begin
  TxtRowsLimit.Enabled := true;
  TxtFileName.Caption := TConfigs.GetConfig('TEMP', 'FilePath');
  ActOpenFile.ImageIndex := 2;
  BtnOpenFile.Action := ActOpenFile;
  ActSelect.Enabled := true;
  ActAlter.Enabled := false;
  ActSave.Enabled := false;
  ActSaveAs.Enabled := true;
  ActCancel.Enabled := true;
  ActAddCell.Enabled := true;
  ActDelCell.Enabled := true;
  ActAddRow.Enabled := true;
  ActDelRow.Enabled := true;
  ActAddCol.Enabled := true;
  ActDelCol.Enabled := true;
  GridDatas.Options := GridDatas.Options + [goEditing];
  Mode := 3;
end;

//Muda a Cell selecionada na Grid para atualiz�-la
procedure TWindowDatas.UpdateGrid;
begin
  TxtRowsLimit.SetFocus;
  GridDatas.SetFocus;
  LblTotRows.Caption := 'Dados: ' + (GridDatas.RowCount - 2).ToString;
  LblTotCols.Caption := 'Campos: ' + (GridDatas.ColCount - 2).ToString;
end;

//Define o tamanho da Grid
procedure TWindowDatas.GridSize(RowCount, ColCount: integer);
begin
  GridDatas.RowCount := RowCount + 2;
  GridDatas.ColCount := ColCount + 2;
  UpdateGrid;
end;

//Insere os titulos das linhas e colunas fixadas na Grid
procedure TWindowDatas.GridTitles;
var
  Cont: integer;
begin
  for Cont := 1 to GridDatas.RowCount - 2 do
  begin
    GridDatas.Cells[0, Cont] := 'Dado ' + Cont.ToString;
  end;

  GridDatas.Rows[GridDatas.RowCount - 1].Clear;

  GridDatas.Cells[0, GridDatas.RowCount - 1] := '      +';

  for Cont := 1 to GridDatas.ColCount - 2 do
  begin
    GridDatas.Cells[Cont, 0] := 'Campo ' + Cont.ToString;
  end;

  GridDatas.Cols[GridDatas.ColCount - 1].Clear;

  GridDatas.Cells[GridDatas.ColCount - 1, 0] := '    +';
end;

//Quando a Grid � editada
procedure TWindowDatas.Altered;
begin
  DidChange := true;
  ActSave.Enabled := true;
end;

//Quando as alter���es s�o salvas ou descartadas
procedure TWindowDatas.Done;
begin
  DidChange := false;
  ActSave.Enabled := false;
end;

//Only a test
procedure TWindowDatas.Teste(Row, Col: integer);
begin
  if (Mode = 1) or (Mode = 2) then
  begin
    TxtRowsLimit.Text := '';
    ActSelect.Execute;
    GridDatas.Row := Row;
    GridDatas.Col := Col;
  end;
  ShowModal;
end;

end.
