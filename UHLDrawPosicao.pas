unit UHLDrawPosicao;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Math, UHLLib, UHLLibProjeto;

type THLStatusDrawPosicao = (sdPronto, sdOrigemSelecionada, sdDestinoSelecionado);

type
  THLDrawPosicao = class
  private
    FDestinoSelecionado: Integer;
    FOrigemSelecionada: Integer;
    FTipoConexao: THLTipoConexao;
    FStatus: THLStatusDrawPosicao;
    FAnchors: array [1..5] of TShape;
    FAnchor1: TShape;
    FAnchor3: TShape;
    FAnchor5: TShape;
    FAnchor2: TShape;
    FAnchor4: TShape;
    FImage: TImage;
    FImageDrawing: TImage;
    FExibirAncoras: boolean;
    FQtdVias: Integer;
    FPosicao: THLPosicao;
    function CreateAnchor(ATag: Integer): TShape;
    function PointOf(AAnchorTag: Integer): TPoint;
    procedure AnchorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AnchorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure AnchorMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AnchorDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure AnchorDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure AnchorEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure AnchorStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ImageDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure SelectAnchor(AAnchor: TShape);
    procedure UnselectAnchor(AAnchor: TShape);
    procedure ClearOtherSelections(AOrigem, ADestino: Integer);
    procedure ClearDrawingCanvas;
    procedure DrawLine(AImage: TImage; AFrom, ATo: TPoint; AArrow: Boolean);
    procedure DrawBloqueio(APoint: TPoint);
    procedure SetExibirAncoras(const Value: boolean);
    procedure SetQtdVias(const Value: Integer);
    procedure UpdateAnchors;
  public
    property ExibirAncoras: boolean read FExibirAncoras write SetExibirAncoras;
    property TipoConexao: THLTipoConexao read FTipoConexao write FTipoConexao;
    property OrigemSelecionada: Integer read FOrigemSelecionada write FOrigemSelecionada;
    property DestinoSelecionado: Integer read FDestinoSelecionado write FDestinoSelecionado;
    property Status: THLStatusDrawPosicao read FStatus write FStatus;
    property QtdVias: Integer read FQtdVias write SetQtdVias;
    property Posicao: THLPosicao read FPosicao write FPosicao;
    procedure ClearCanvas;
    constructor Create(APosicao: THLPosicao; AImage: TImage);
  end;


implementation

uses Types;

const
  _TamanhoSeta = 8;
  _AnguloSeta = 14;

{ THLDrawPosicao }

constructor THLDrawPosicao.Create(APosicao: THLPosicao; AImage: TImage);
begin
  // TELA DE PINTURA DA VÁLVULA

  FImage := AImage;

  FImage.DragCursor := crDefault;
  FImage.OnDragOver := ImageDragOver;
  ClearCanvas;

  // TELA TEMPORÁRIA DE PINTURA DA VÁLVULA

  FImageDrawing := TImage.Create(FImage.Owner);
  FImageDrawing.Parent := FImage.Parent;
  FImageDrawing.Width  := FImage.Width;
  FImageDrawing.Height := FImage.Height;
  FImageDrawing.Left   := FImage.Left;
  FImageDrawing.Top    := FImage.Top;
  FImageDrawing.Transparent := True;

  FImageDrawing.DragCursor := crDefault;
  FImageDrawing.OnDragOver := ImageDragOver;

  // INICIALIZAÇÃO DE PROPRIEDADES

  FStatus        := sdPronto;
  FTipoConexao   := tcDirecional;
  FExibirAncoras := True;
  FQtdVias       := 2;

  FOrigemSelecionada  := 0;
  FDestinoSelecionado := 0;

  // CRIAÇÃO DAS ÂNCORAS

  FAnchor1 := CreateAnchor(1);
  FAnchor2 := CreateAnchor(2);
  FAnchor3 := CreateAnchor(3);
  FAnchor4 := CreateAnchor(4);
  FAnchor5 := CreateAnchor(5);

  UpdateAnchors;

  // OBJETO POSICAO

  FPosicao := APosicao;

  //FPosicao := THLPosicao.Create(nil);
  //FPosicao.Inicializa;  

end;

procedure THLDrawPosicao.UpdateAnchors;
var i: Integer;
begin
  for i := 1 to 5 do
    FAnchors[i].Visible := FExibirAncoras and (FQtdVias >= i);

  for i := 1 to 5 do
  begin
    FAnchors[i].Left := FImage.Left + PointOf(i).X - 2;
    if Odd(i)
    then FAnchors[i].Top  := FImage.Top  + PointOf(i).Y
    else FAnchors[i].Top  := FImage.Top  + PointOf(i).Y - 5;
  end;

  {
  FAnchor1.Left    := FImage.Left + 13;
  FAnchor1.Top     := FImage.Top  + 32;

  FAnchor2.Left   := FImage.Left + 4;
  FAnchor2.Top    := FImage.Top  - 5;

  FAnchor3.Visible := FQtdVias >= 3;
  FAnchor3.Left    := FImage.Left + 4;
  FAnchor3.Top     := FImage.Top  + 32;

  FAnchor4.Visible := FQtdVias >= 4;
  FAnchor4.Left   := FImage.Left + 23;                                                   
  FAnchor4.Top    := FImage.Top  - 5;

  FAnchor5.Visible := FQtdVias >= 5;
  FAnchor5.Left   := FImage.Left + 23;
  FAnchor5.Top    := FImage.Top  + 32;    }
end;

procedure THLDrawPosicao.AnchorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Anchor: TShape;
begin
  Anchor := TShape(Sender);

  if FTipoConexao = tcBloqueio then
  begin
    DrawBloqueio(PointOf(Anchor.Tag));

    FPosicao.AdicionaConexao(tcBloqueio, Anchor.Tag);

    Exit;
  end;

  if FOrigemSelecionada = 0 then
  begin
    FOrigemSelecionada := Anchor.Tag;
    Anchor.Pen.Color   := clRed;
    Anchor.Brush.Color := clRed;

    Anchor.BeginDrag(True);
  end;
end;

procedure THLDrawPosicao.AnchorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var Anchor: TShape;
begin
  Anchor := TShape(Sender);

  if (FOrigemSelecionada > 0) and (FDestinoSelecionado = 0) then
  begin
    Anchor.Pen.Color := clRed;
    Anchor.Brush.Color := clRed;
  end;
end;

procedure THLDrawPosicao.AnchorMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THLDrawPosicao.SelectAnchor(AAnchor: TShape);
begin
  AAnchor.Pen.Color := clRed;
  AAnchor.Brush.Color := clRed;
end;

procedure THLDrawPosicao.UnselectAnchor(AAnchor: TShape);
begin
  AAnchor.Pen.Color := clBlack;
  AAnchor.Brush.Color := clBlack;
end;


procedure THLDrawPosicao.ClearOtherSelections(AOrigem, ADestino: Integer);
var i: Integer;
begin
  for i := 1 to 5 do
    if (FAnchors[i].Tag <> AOrigem) and (FAnchors[i].Tag <> ADestino) then
      UnselectAnchor(FAnchors[i]);
end;

procedure THLDrawPosicao.AnchorDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var Anchor: TShape;
begin
  Anchor := TShape(Sender);

  if (FOrigemSelecionada > 0) and (Anchor.Tag <> FOrigemSelecionada) and (FDestinoSelecionado = 0) then
  begin
    ClearOtherSelections(FOrigemSelecionada, Anchor.Tag);

    ClearDrawingCanvas;    
    DrawLine(FImageDrawing, PointOf(FOrigemSelecionada), PointOf(Anchor.Tag), True);

    SelectAnchor(Anchor);
  end;
end;

procedure THLDrawPosicao.ClearDrawingCanvas;
begin
  FImageDrawing.Canvas.Brush.Color := clWhite;
  FImageDrawing.Canvas.FillRect(Rect(0,0,FImageDrawing.Width,FImageDrawing.Height));
end;

procedure THLDrawPosicao.ImageDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  ClearOtherSelections(FOrigemSelecionada, 0);

  ClearDrawingCanvas;
  DrawLine(FImageDrawing, PointOf(FOrigemSelecionada), Point(X, Y), True);
end;

procedure THLDrawPosicao.DrawLine(AImage: TImage; AFrom, ATo: TPoint; AArrow: Boolean);
var
  a0, a1, a2: Extended; // Ângulos para desenho das setas
  pArrow: array[1..3] of TPoint;
  iOffSet: Integer;

  procedure DrawSeta(AFrom, ATo: TPoint);
  begin
    pArrow[1] := ATo;

    if pArrow[1].Y = 0
    then pArrow[1].Y := 1
    else pArrow[1].Y := pArrow[1].Y - 1;

    if ATo.X = AFrom.X then
      a0 := pi/2
    else
      a0 := ArcTan( -1*(ATo.Y - AFrom.Y) / (ATo.X - AFrom.X) );

    a1 := DegToRad(_AnguloSeta) - a0;
    a2 := DegToRad(90 - _AnguloSeta) - a0;

    if (ATo.X > AFrom.X) or ((ATo.X = AFrom.X) and (ATo.Y < AFrom.Y)) then
    begin
      pArrow[2].X := ATo.X - Round(_TamanhoSeta*cos(a1));
      pArrow[2].Y := ATo.Y - Round(_TamanhoSeta*sin(a1));

      pArrow[3].X := ATo.X - Round(_TamanhoSeta*sin(a2));
      pArrow[3].Y := ATo.Y + Round(_TamanhoSeta*cos(a2));
    end
    else
    begin
      pArrow[2].X := ATo.X + Round(_TamanhoSeta*cos(a1));
      pArrow[2].Y := ATo.Y + Round(_TamanhoSeta*sin(a1));

      pArrow[3].X := ATo.X + Round(_TamanhoSeta*sin(a2));
      pArrow[3].Y := ATo.Y - Round(_TamanhoSeta*cos(a2));
    end;
  end;

begin
  AImage.Canvas.Brush.Style := bsSolid;
  AImage.Canvas.Brush.Color := clBlack;

  if (AFrom.Y = ATo.Y) then
  begin
    if AFrom.Y = 0
    then iOffSet := 10     // PARTE SUPERIOR DA CAIXA DE POSIÇÃO
    else iOffSet := -10;   // PARTE INFERIOR DA CAIXA DE POSIÇÃO

    AImage.Canvas.MoveTo(AFrom.X, AFrom.Y);
    AImage.Canvas.LineTo(AFrom.X, AFrom.Y + iOffSet);
    AImage.Canvas.LineTo(ATo.X, AFrom.Y + iOffSet);
    AImage.Canvas.LineTo(ATo.X, ATo.Y);

    // SETA
    if FTipoConexao = tcDirecional then
      DrawSeta(Point(ATo.X, AFrom.Y + iOffSet), ATo);
  end
  else
  begin
    AImage.Canvas.MoveTo(AFrom.X, AFrom.Y);
    AImage.Canvas.LineTo(ATo.X, ATo.Y);

    // SETA
    if FTipoConexao = tcDirecional then
      DrawSeta(AFrom, ATo);
  end;

  AImage.Canvas.Polygon(pArrow);
  AImage.Canvas.Brush.Color := clWhite;
end;

procedure THLDrawPosicao.AnchorDragDrop(Sender, Source: TObject; X, Y: Integer);
begin

end;

procedure THLDrawPosicao.AnchorStartDrag(Sender: TObject; var DragObject: TDragObject);
begin

end;

procedure THLDrawPosicao.AnchorEndDrag(Sender, Target: TObject; X, Y: Integer);
var Anchor: TShape;
begin
  ClearDrawingCanvas;

  if (Target <> nil) and (Target is TShape) then
  begin
    Anchor := TShape(Target);

    if (FOrigemSelecionada > 0) and (Anchor.Tag <> FOrigemSelecionada) then
    begin
      FDestinoSelecionado := Anchor.Tag;

      DrawLine(FImage, PointOf(FOrigemSelecionada), PointOf(FDestinoSelecionado), True);

      FPosicao.AdicionaConexao(THLTipoConexao(FTipoConexao), FOrigemSelecionada, FDestinoSelecionado);
    end;
  end;

  FOrigemSelecionada := 0;
  FDestinoSelecionado := 0;
  ClearOtherSelections(0, 0);
end;

function THLDrawPosicao.CreateAnchor(ATag: Integer): TShape;
begin
  Result := TShape.Create(FImage.Owner);
  Result.Parent := FImage.Parent;
  Result.Width  := 5;
  Result.Height := 5;
  Result.Brush.Color := clBlack;
  Result.Tag := ATag;
  Result.Cursor := crHandPoint;
  Result.DragCursor := crHandPoint;

  Result.OnMouseDown := AnchorMouseDown;
  Result.OnMouseMove := AnchorMouseMove;
  Result.OnMouseUp   := AnchorMouseUp;
  Result.OnDragDrop  := AnchorDragDrop;
  Result.OnDragOver  := AnchorDragOver;
  Result.OnStartDrag := AnchorStartDrag;
  Result.OnEndDrag   := AnchorEndDrag;

  FAnchors[ATag] := Result;
end;

function THLDrawPosicao.PointOf(AAnchorTag: Integer): TPoint;
begin
  case AAnchorTag of
  1:begin
      if FQtdVias in [3,4]
      then Result := Point(6, 32)
      else Result := Point(15, 32);
    end;
  3:begin
      if FQtdVias < 5
      then Result := Point(25, 32)
      else Result := Point(6, 32);
    end;
  5:begin
      Result := Point(25, 32);
    end;
  2:begin
      if FQtdVias = 2
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

procedure THLDrawPosicao.SetExibirAncoras(const Value: boolean);
begin
  FExibirAncoras := Value;

  UpdateAnchors;
end;

procedure THLDrawPosicao.ClearCanvas;
begin
  FImage.Canvas.Brush.Color := RGB(254, 254, 254);
  FImage.Canvas.FillRect(Rect(0,0,FImage.Width,FImage.Height));

  FImage.Canvas.Rectangle(0,0,FImage.Width,FImage.Height);
end;

procedure THLDrawPosicao.DrawBloqueio(APoint: TPoint);
var iOffSet: Integer;
begin
  if APoint.Y = 0
  then iOffSet := 7    // PARTE SUPERIOR DA CAIXA DE POSIÇÃO
  else iOffSet := -7;  // PARTE INFERIOR DA CAIXA DE POSIÇÃO

  FImage.Canvas.MoveTo(APoint.X, APoint.Y);
  FImage.Canvas.LineTo(APoint.X, APoint.Y + iOffSet);
  FImage.Canvas.MoveTo(APoint.X - 3, APoint.Y + iOffSet);
  FImage.Canvas.LineTo(APoint.X + 4, APoint.Y + iOffSet);
end;

procedure THLDrawPosicao.SetQtdVias(const Value: Integer);
begin
  FQtdVias := Value;

  FPosicao.QtdVias := FQtdVias;
  FPosicao.Inicializa;

  UpdateAnchors;
  ClearCanvas;
end;

end.


