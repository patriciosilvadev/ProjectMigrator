unit DataFlex;

interface

uses
  System.SysUtils, System.Classes, System.Types, Vcl.Forms,
  Arrays, MyUtils;

type

  TDataFlex = class
  private
    StrList: TStringList;
    Separator: string;
    RowCount: integer;
    ColCount: integer;

  public
    constructor Create(StrList: TStringList; Separator: string);

    function GetRowCount: integer;
    function GetColCount: integer;

    function ToMatrix: TStringMatrix;
  end;

implementation

//Cria o objeto e define os atributos
constructor TDataFlex.Create(StrList: TStringList; Separator: string);
begin
  self.StrList := StrList;
  self.Separator := Separator;
  self.RowCount := StrList.Count;
  self.ColCount := Length(TUtils.Cut(StrList[0], self.Separator));
end;

//Retorna a quantidade de linhas
function TDataFlex.GetRowCount: integer;
begin
  Result := self.RowCount;
end;

//Retorna a quantidade de colunas
function TDataFlex.GetColCount: integer;
begin
  Result := self.ColCount;
end;

//Retorna uma matrix com os dados
function TDataFlex.ToMatrix: TStringMatrix;
var
  Cont: integer;
begin
  SetLength(Result, GetRowCount, GetColCount);
  for Cont := 0 to GetRowCount - 1 do
  begin
    Result[Cont] := TUtils.Cut(StrList[Cont], self.Separator);
  end;
end;

end.
