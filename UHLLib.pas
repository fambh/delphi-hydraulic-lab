unit UHLLib;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, ExtCtrls, Forms;

type THLTipoConexao = (tcNone, tcBloqueio, tcSimples, tcDirecional, tcDirecionalReversa);

type THLTipoAtuacaoValvula = (taNenhuma, taPiloto, taMola, taManual, taManualComTrava, taMecanica, taSolenoide);

type THLComboImage = record
  Bitmap: TBitmap;
  Index: Integer;
end;

type THLComboImages = array of THLComboImage;

function iif(ACondition: Boolean; AThen, AElse: Variant): Variant;

function TipoConexaoToChar(ATipo: THLTipoConexao): Char;
function CharToTipoConexao(ATipo: Char): THLTipoConexao;
procedure CopyCanvas(CanvasFrom, CanvasTo: TCanvas);
procedure GetScreenPosition(AControl: TControl; var APoint: TPoint);
procedure PaintImage(AImage: TImage; AColor: TColor);

// MEDIDAS E PONTOS
function LarguraValvula(AQtdPosicoes: Integer): Integer;
function PointOfAnchor(AQtdVias: Integer; AAnchorTag: Integer): TPoint;
function InicioPosicao(APosicao: Integer): Integer;
function FimPosicao(APosicao: Integer): Integer;

// MATEMATICA
function Maior(i1, i2: Integer): Integer;
function Menor(i1, i2: Integer): Integer;

implementation

function iif(ACondition: Boolean; AThen, AElse: Variant): Variant;
begin
  if ACondition
  then Result := AThen
  else Result := AElse;
end;

function InicioPosicao(APosicao: IntegeR): Integer;
begin
  case APosicao of
    1: Result := 32;
    2: Result := 63;
    3: Result := 94;
  else
    Result := 0;
  end;
end;

function FimPosicao(APosicao: IntegeR): Integer;
begin
  case APosicao of
    1: Result := 64;
    2: Result := 95;
    3: Result := 126;
  else
    Result := 0;
  end;
end;

function PointOfAnchor(AQtdVias: Integer; AAnchorTag: Integer): TPoint;
begin
  case AAnchorTag of
  1:begin
      if AQtdVias in [3,4]
      then Result := Point(6, 32)
      else Result := Point(15, 32);
    end;
  3:begin
      if AQtdVias < 5
      then Result := Point(25, 32)
      else Result := Point(6, 32);
    end;
  5:begin
      Result := Point(25, 32);
    end;
  2:begin
      if AQtdVias = 2
      then Result := Point(15, 0)
      else Result := Point(6, 0);
    end;
  4:begin
      Result := Point(25, 0);
    end;
  else
    Result := Point(0, 0);
  end;
end;

procedure PaintImage(AImage: TImage; AColor: TColor);
var x,y: Integer;
begin
  for x := 0 to AImage.Width do
    for y := 0 to AImage.Height do
    begin
      if AImage.Canvas.Pixels[x, y] < 16000000 then
        AImage.Canvas.Pixels[x, y] := AColor;
    end;
end;

function LarguraValvula(AQtdPosicoes: Integer): Integer;
begin
  Result := 65 + 31*AQtdPosicoes;
end;

function TipoConexaoToChar(ATipo: THLTipoConexao): Char;
begin
  case ATipo of
    tcBloqueio          : Result := 'B';
    tcSimples           : Result := 'S';
    tcDirecional        : Result := 'D';
    tcDirecionalReversa : Result := 'R';
  else
    Result := 'N';
  end;
end;

function CharToTipoConexao(ATipo: Char): THLTipoConexao;
begin
  case ATipo of
    'B' : Result := tcBloqueio;
    'S' : Result := tcSimples;
    'D' : Result := tcDirecional;
    'R' : Result := tcDirecionalReversa;
  else
    Result := tcNone;
  end;
end;

procedure CopyCanvas(CanvasFrom, CanvasTo: TCanvas);
var r: TRect;
begin
  r := Rect(0, 0, 32, 32);
  CanvasTo.CopyRect(r, CanvasFrom, r);
end;

procedure GetScreenPosition(AControl: TControl; var APoint: TPoint);
begin
  if AControl is TForm then
  begin
    APoint.X := APoint.X + TForm(AControl).ClientOrigin.X;
    APoint.Y := APoint.Y + TForm(AControl).ClientOrigin.Y;
  end
  else
  begin
    APoint.X := APoint.X + AControl.Left;
    APoint.Y := APoint.Y + AControl.Top;
  end;

  if (AControl.Parent <> nil) and (AControl.Parent is TControl) then
    GetScreenPosition(AControl.Parent, APoint);
end;

function Maior(i1, i2: Integer): Integer;
begin
  Result := iif(i1 > i2, i1, i2);
end;

function Menor(i1, i2: Integer): Integer;
begin
  Result := iif(i1 < i2, i1, i2);
end;

end.



