unit DAO;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.Variants, FireDAC.Comp.Client,
  Arrays, Config, ConnectionFactory;

type

  TDAO = class
  private
    class function Connection: TFDConnection;
    class function QueryFields: TFDQuery;
    class function QuerySQL: TFDQuery;
    class function Table: string;

    class procedure Select;

  public
    class procedure GetParams(var UserName, Password, Database: string);
    class procedure SetParams(UserName, Password, Database: string);

    class procedure CreateTable(Name: string; FieldsName, FieldsType: TStringArray);
    class procedure Insert(Datas: TStringArray; Order: TIntegerArray; Defaults: TStringArray);

    class function GetFieldsNames: TStringArray;
    class function GetFieldsTypes: TStringArray;
    class function GetFieldsTypesNumber: TIntegerArray;
    class function GetFieldsNotNulls: TIntegerArray;

    class procedure TestConn;
    class function Count: integer;
    class procedure Truncate;
    class procedure Commit;
    class procedure Rollback;

  end;

implementation

{ TDAO }

//Retorna a conex�o no DataModel
class function TDAO.Connection: TFDConnection;
begin
  Result := ConnFactory.Conn;
end;

//Retorna a Query dos campos firebird
class function TDAO.QueryFields: TFDQuery;
begin
  Result := ConnFactory.QueryFields
end;

//Retorna a Query para comandos espec�ficos
class function TDAO.QuerySQL: TFDQuery;
begin
  Result := ConnFactory.QuerySQL;
end;

//Retorna a tabela definida nas configura��es
class function TDAO.Table: string;
begin
  Result := TConfig.GetConfig('DB', 'Table');
end;

//Seleciona os campos na QueryFields
class procedure TDAO.Select;
begin
  QueryFields.Close;
  QueryFields.ParamByName('TABLE_NAME').AsString := Table;
  QueryFields.Open;
end;

//Retorna os par�metros do Connection por refer�ncia
class procedure TDAO.GetParams(var UserName, Password, Database: string);
begin
  UserName := Connection.Params.UserName;
  Password := Connection.Params.Password;
  Database := Connection.Params.Database;
end;

//Define os par�metros do Connection
class procedure TDAO.SetParams(UserName, Password, Database: string);
begin
  Connection.Params.UserName := UserName;
  Connection.Params.Password := Password;
  Connection.Params.Database := Database;
end;

//Ativa o Connection para testar a conex�o
class procedure TDAO.TestConn;
begin
  Connection.Connected := true;
end;

//Cria uma Tabela no DB selecionado
class procedure TDAO.CreateTable(Name: string; FieldsName, FieldsType: TStringArray);
begin
  //
end;

//Insere os dados no banco
class procedure TDAO.Insert(Datas: TStringArray; Order: TIntegerArray; Defaults: TStringArray);
var
  Cont: Integer;
  Tipos: TIntegerArray;
  Fields: TStringArray;
begin
  SetLength(Tipos, Count);
  Tipos := GetFieldsTypesNumber;
  SetLength(Fields, Count);
  Fields := GetFieldsNames;
  QuerySQL.SQL.Clear;
  QuerySQL.Open('select * from ' + Table);
  QuerySQL.Insert;
  for Cont := 0 to Count - 1 do
  begin
    if (Order[Cont] <> -1) and (Trim(Datas[Order[Cont] - 1]) <> '') then
    begin
      case Tipos[Cont] of
      7, 8:
        QuerySQL.FieldByName(Fields[Cont]).AsInteger := Datas[Order[Cont] - 1].ToInteger;
      12:
        QuerySQL.FieldByName(Fields[Cont]).AsDateTime := StrToDate(Datas[Order[Cont] - 1]);
      14:
        QuerySQL.FieldByName(Fields[Cont]).AsWideString := Datas[Order[Cont] - 1];
      16:
        QuerySQL.FieldByName(Fields[Cont]).AsFloat := Datas[Order[Cont] - 1].ToDouble;
      35:
        QuerySQL.FieldByName(Fields[Cont]).AsDateTime := StrToDateTime(Datas[Order[Cont] - 1]);
      37:
        QuerySQL.FieldByName(Fields[Cont]).AsString := Datas[Order[Cont] - 1];
      end;
    end
    else if Defaults[Cont] <> '' then
    begin
      case Tipos[Cont] of
      7, 8:
        QuerySQL.FieldByName(Fields[Cont]).AsInteger := Defaults[Cont].ToInteger;
      12:
        QuerySQL.FieldByName(Fields[Cont]).AsDateTime := StrToDate(Defaults[Cont]);
      14:
        QuerySQL.FieldByName(Fields[Cont]).AsWideString := Defaults[Cont];
      16:
        QuerySQL.FieldByName(Fields[Cont]).AsFloat := Defaults[Cont].ToDouble;
      35:
        QuerySQL.FieldByName(Fields[Cont]).AsDateTime := StrToDateTime(Defaults[Cont]);
      37:
        QuerySQL.FieldByName(Fields[Cont]).AsString := Defaults[Cont];
      end;
    end;
  end;
  QuerySQL.Post;
end;

//Retorna o nome dos campos
class function TDAO.GetFieldsNames: TStringArray;
var
  Cont: integer;
begin
  Select;
  if Count <> 0 then
  begin
    SetLength(Result, Count);
    QueryFields.First;
    for Cont := 0 to Count - 1 do
    begin
      Result[Cont] := QueryFields.FieldByName('FIELD_NAME').AsString;
      QueryFields.Next;
    end;
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := '';
  end;
end;

//Retorna o tipo dos campos
class function TDAO.GetFieldsTypes: TStringArray;
var
  Cont: integer;
begin
  Select;
  if Count <> 0 then
  begin
    SetLength(Result, Count);
    QueryFields.First;
    for Cont := 0 to Count - 1 do
    begin
      Result[Cont] := QueryFields.FieldByName('FIELD_TYPE').AsString;
      QueryFields.Next;
    end;
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := '';
  end;
end;

//Retorna o tipo dos campos por numero
class function TDAO.GetFieldsTypesNumber: TIntegerArray;
var
  Cont: integer;
begin
  Select;
  if Count <> 0 then
  begin
    SetLength(Result, Count);
    QueryFields.First;
    for Cont := 0 to Count - 1 do
    begin
      Result[Cont] := QueryFields.FieldByName('FIELD_NUMBER').AsInteger;
      QueryFields.Next;
    end;
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := 0;
  end;
end;

//Retorna os campos Not Null
class function TDAO.GetFieldsNotNulls: TIntegerArray;
var
  Cont: integer;
begin
  Select;
  if Count <> 0 then
  begin
    SetLength(Result, Count);
    QueryFields.First;
    for Cont := 0 to Count - 1 do
    begin
      Result[Cont] := QueryFields.FieldByName('FIELD_NULL').AsInteger;
      QueryFields.Next;
    end;
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := 0;
  end;
end;

//Retorna quantos campos h� na QueryFields
class function TDAO.Count: integer;
begin
  Select;
  Result := QueryFields.RowsAffected;
end;

//Apaga todos os dados da tabela
class procedure TDAO.Truncate;
begin
  QuerySQL.SQL.Clear;
  QuerySQL.SQL.Add('delete from ' + Table +' where id >= 0');
  QuerySQL.ExecSQL;
  QuerySQL.SQL.Clear;
end;

//Aplica todas as altera��es
class procedure TDAO.Commit;
begin
  Connection.Commit;
end;

//Defaz todas as altera��es
class procedure TDAO.Rollback;
begin
  Connection.Rollback;
end;

end.
