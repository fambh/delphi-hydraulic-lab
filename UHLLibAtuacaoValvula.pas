unit UHLLibAtuacaoValvula;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Math, UHLLib, IniFiles, UHLRepImages;

type
  THLAtuacaoValvula = class;
  THLAtuacoesValvula = array [1..12] of THLAtuacaoValvula;

  THLAtuacaoValvula = class
  private
    FId: Integer;
    FImagemE: TBitmap;
    FImagemD: TBitmap;    
    FTipo: THLTipoAtuacaoValvula;
  public
    property Id: Integer read FId write FId;
    property ImagemE: TBitmap read FImagemE write FImagemE;
    property ImagemD: TBitmap read FImagemD write FImagemD;
    property Tipo: THLTipoAtuacaoValvula read FTipo write FTipo;
    constructor Create;
    destructor Destroy; override;
  end;

procedure CarregarAtuacoes(var AAtuacoes: THLAtuacoesValvula);
procedure FinalizarAtuacoes(var AAtuacoes: THLAtuacoesValvula);

implementation

procedure CanvasFlipHorizontal(ABmpFrom, ABmpTo: TBitmap);
var src, dest: TRect;
begin
  dest := Bounds(0, 0, ABmpFrom.Width, ABmpFrom.Height);
  src  := Rect(ABmpFrom.Width-1, 0, 0, ABmpFrom.Height-1);
  ABmpTo.Canvas.CopyRect(dest, ABmpFrom.Canvas, src);
end;

procedure AdicionarAtuacao(var AAtuacoes: THLAtuacoesValvula; AId: Integer; ATipo: THLTipoAtuacaoValvula);
var atuacao: THLAtuacaoValvula;
begin
  atuacao := THLAtuacaoValvula.Create;
  atuacao.FId   := AId;
  atuacao.FTipo := ATipo;
  dmRepImages.imlAtuacoesE.GetBitmap(atuacao.FId-1, atuacao.FImagemE);
  dmRepImages.imlAtuacoesD.GetBitmap(atuacao.FId-1, atuacao.FImagemD);

  AAtuacoes[atuacao.FId] := atuacao;
end;

procedure CarregarAtuacoes(var AAtuacoes: THLAtuacoesValvula);
var
  sPath: String;
  atuacao: THLAtuacaoValvula;
begin
  sPath := Format('%s%s', [ExtractFilePath(ParamStr(0)), 'imagens\atuacao\']);

  AdicionarAtuacao(AAtuacoes, 1, taPiloto);
  AdicionarAtuacao(AAtuacoes, 2, taMola);
  AdicionarAtuacao(AAtuacoes, 3, taManual);
  AdicionarAtuacao(AAtuacoes, 4, taManualComTrava);
  AdicionarAtuacao(AAtuacoes, 5, taManual);
  AdicionarAtuacao(AAtuacoes, 6, taManualComTrava);
  AdicionarAtuacao(AAtuacoes, 7, taManual);
  AdicionarAtuacao(AAtuacoes, 8, taManualComTrava);
  AdicionarAtuacao(AAtuacoes, 9, taMecanica);
  AdicionarAtuacao(AAtuacoes, 10, taMecanica);
  AdicionarAtuacao(AAtuacoes, 11, taMecanica);
  AdicionarAtuacao(AAtuacoes, 12, taSolenoide);

end;

procedure FinalizarAtuacoes(var AAtuacoes: THLAtuacoesValvula);
var i: Integer;
begin
  for i := 1 to Length(AAtuacoes) do
    if Assigned(AAtuacoes[i]) then
      AAtuacoes[i].Free;
end;

{ THLAtuacaoValvula }

constructor THLAtuacaoValvula.Create;
begin
  inherited;
  FImagemE := TBitmap.Create;
  FImagemD := TBitmap.Create;

  FImagemE.Width  := 32;
  FImagemE.Height := 32;
  FImagemD.Width  := 32;
  FImagemD.Height := 32;
end;

destructor THLAtuacaoValvula.Destroy;
begin
  FImagemE.Free;
  FImagemD.Free;
  inherited;
end;

end.
