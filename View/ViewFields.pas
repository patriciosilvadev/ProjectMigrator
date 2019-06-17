unit ViewFields;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.Variants, Winapi.Windows, Winapi.Messages, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.Buttons, Data.DB, Vcl.DBGrids,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList, shlObj,
  Arrays, MyUtils, Configs, Fields, DAO;

type
  TWindowFields = class(TForm)
    LblTitle1: TLabel;
    GridFields: TStringGrid;
    LblTable: TLabel;
    LblTitle2: TLabel;
    LblTotFields: TLabel;
    Actions: TActionList;
    Images: TImageList;
    BtnExport: TSpeedButton;
    ActExport: TAction;
    BtnImport: TSpeedButton;
    ActImport: TAction;
    SaveFile: TFileSaveDialog;
    OpenFile: TFileOpenDialog;
    ActOrdFields: TAction;
    BtnOrdFields: TSpeedButton;
    BtnClearFields: TSpeedButton;
    ActCleanFields: TAction;
    BtnTruncFB: TSpeedButton;
    ActTruncFB: TAction;
    BtnConfigTable: TSpeedButton;
    ActConfigTable: TAction;
    procedure FormActivate(Sender: TObject);
    procedure ActExportExecute(Sender: TObject);
    procedure ActImportExecute(Sender: TObject);
    procedure ActOrdFieldsExecute(Sender: TObject);
    procedure ActCleanFieldsExecute(Sender: TObject);
    procedure ActTruncFBExecute(Sender: TObject);
    procedure ActConfigTableExecute(Sender: TObject);

  private
    procedure GridTitles;
    procedure CleanGrid;
    procedure FillGrid;

  public
    function GetOrder: TIntegerArray;
    function GetDefauts: TStringArray;

  end;

var
  WindowFields: TWindowFields;

implementation

{$R *.dfm}

procedure TWindowFields.GridTitles;
begin
  GridFields.Cells[0, 0] := 'Campo Firebird';
  GridFields.Cells[1, 0] := 'Tipo Do Campo';
  GridFields.Cells[2, 0] := 'Not Nulls';
  GridFields.Cells[3, 0] := 'N� Campo Dataflex';
  GridFields.Cells[4, 0] := 'Valor Padr�o';
end;

procedure TWindowFields.CleanGrid;
begin
  GridFields.RowCount := 2;
  GridFields.Rows[1].Clear;
end;

procedure TWindowFields.FillGrid;
var
  Cont: integer;
  Fields, Types: TStringArray;
  NotNulls: TIntegerArray;
begin
  try
    try
      if TDAO.Count <> 0 then
      begin
        LblTable.Caption := TDAO.Table;
        SetLength(Fields, TDAO.Count);
        Fields := TDAO.GetFieldsNames;
        SetLength(Types, TDAO.Count);
        Types := TDAO.GetFieldsTypes;
        SetLength(NotNulls, TDAO.Count);
        NotNulls := TDAO.GetFieldsNotNulls;
        GridFields.RowCount := TDAO.Count + 1;
        for Cont := 0 to TDAO.Count - 1 do
        begin
          GridFields.Cells[0, Cont + 1] := Fields[Cont];
          GridFields.Cells[1, Cont + 1] := Types[Cont];
          GridFields.Cells[2, Cont + 1] := TUtils.Iff(NotNulls[Cont] = 1, 'Not Null', '');
        end;
      end
      else
      begin
        CleanGrid;
      end;
    Except
      CleanGrid;
    end;
  finally
    LblTotFields.Caption := 'Total Campos Firebird: ' + TDAO.Count.ToString;
  end;
end;

procedure TWindowFields.ActCleanFieldsExecute(Sender: TObject);
begin
  GridFields.Cols[3].Clear;
  GridFields.Cols[4].Clear;
  GridTitles;
end;

procedure TWindowFields.ActConfigTableExecute(Sender: TObject);
var
  Table: string;
begin
  Table := InputBox('Configurar Tabela', 'Insira o nome da tabela', TConfigs.GetConfig('DB', 'Table')).Trim;
  TConfigs.SetConfig('DB', 'Table', Table);
  FillGrid;
  if TDAO.Count <= 0 then
  begin
    ShowMessage('Selecione uma tabela v�lida!');
  end;
end;

//TO COMMENT
procedure TWindowFields.ActExportExecute(Sender: TObject);
var
  Arq: TextFile;
  Cont: integer;
begin
  SaveFile.FileName := 'Campos ' + TDAO.Table;
  if SaveFile.Execute then
  begin
    AssignFile(Arq, SaveFile.FileName);
    Rewrite(Arq);
    for Cont := 1 to GridFields.RowCount - 1 do
    begin
      Writeln(Arq, GridFields.Cells[3, Cont]);
    end;
    Writeln(Arq, '{$DEFAULTS$}');
    for Cont := 1 to GridFields.RowCount - 1 do
    begin
      Writeln(Arq, GridFields.Cells[4, Cont]);
    end;
    CloseFile(Arq);
  end;
end;

//TO COMMENT
procedure TWindowFields.ActImportExecute(Sender: TObject);
var
  Arq: TStringList;
  Rows: TStringList;
  Cont: integer;
begin
  Arq := TStringList.Create;
  Rows := TStringList.Create;
  try
    if OpenFile.Execute then
    begin
      Arq.LoadFromFile(OpenFile.FileName);

      Rows := TFields.ExtractOrder(Arq);
      GridFields.Cols[3].Clear;
      GridFields.Cells[3, 0] := 'N� Campo Dataflex';
      for  Cont := 0 to TUtils.Iff(Rows.Count > GridFields.RowCount, GridFields.RowCount, Rows.Count) - 1 do
      begin
        GridFields.Cells[3, Cont + 1] := Rows[Cont];
      end;

      Rows := TFields.ExtractDefaults(Arq);
      GridFields.Cols[4].Clear;
      GridFields.Cells[4, 0] := 'Valor Padr�o';
      for  Cont := 0 to TUtils.Iff(Rows.Count > GridFields.RowCount, GridFields.RowCount, Rows.Count) - 1 do
      begin
        GridFields.Cells[4, Cont + 1] := Rows[Cont];
      end;

    end;
  finally
    FreeAndNil(Rows);
  end;
end;

//TO COMMENT
procedure TWindowFields.ActOrdFieldsExecute(Sender: TObject);
var
  Cont: integer;
begin
  for Cont := 0 to GridFields.RowCount - 1 do
  begin
    GridFields.Cells[3, Cont + 1] := IntToStr(Cont + 1);
  end;
end;

//TO COMMENT
procedure TWindowFields.FormActivate(Sender: TObject);
begin
  GridFields.ColWidths[1] := 100;
  GridFields.ColWidths[2] := 50;
  GridFields.ColWidths[3] := 100;
  GridFields.ColWidths[4] := 100;
  GridTitles;
  FillGrid;
end;

//TO COMMENT
function TWindowFields.GetOrder: TIntegerArray;
var
  Cont: integer;
begin
  GridFields.RowCount := TDAO.Count + 1;
  SetLength(Result, TDAO.Count);
  for Cont := 0 to TDAO.Count - 1 do
  begin
    if (GridFields.Cells[3, Cont + 1].IsEmpty) or (StrToInt(GridFields.Cells[3, Cont + 1]) <= 0) then
    begin
      Result[Cont] := -1;
    end
    else
    begin
      Result[Cont] := GridFields.Cells[3, Cont + 1].ToInteger;
    end;
  end;
end;

//TO COMMENT
function TWindowFields.GetDefauts: TStringArray;
var
  Cont: integer;
begin
  GridFields.RowCount := TDAO.Count + 1;
  SetLength(Result, TDAO.Count);
  for Cont := 0 to TDAO.Count do
  begin
    if GridFields.Cells[4, Cont + 1].IsEmpty then
    begin
      Result[Cont] := '';
    end
    else
    begin
      Result[Cont] := GridFields.Cells[4, Cont + 1];
    end;
  end;
end;

procedure TWindowFields.ActTruncFBExecute(Sender: TObject);
begin
  if MessageDlg('Deseja apagar todos os dados da tabela ' + TDAO.Table + '?', mtConfirmation, mbYesNo, 2) = 6 then
  begin
    TDAO.Truncate;
  end;
end;

end.
