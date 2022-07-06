unit UHLLibProjeto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Math, UHLLib, UHLLibAtuacaoValvula, Inifiles;

type
  THLAction = (acNone, acSelect, acConexaoStart, acConexaoEnd, acEdited);

  THLTipoElemento = (teValvula, taCilindro, taFonte, taNo);

  THLTipoAncora = (anViaPar, anViaImpar, anPilotoE, anPilotoD, anNo);

  THLTipoLinha = (tlHVH, tlVHV);

  THLCurvePoints = array[1..4] of TPoint;

  THLVia = array [1..5, 1..5] of boolean;

  THLProjeto  = class;
  THLElemento = class;
  THLValvula = class;
  THLValvulas = class;
  THLPosicao = class;
  THLPosicoes = class;
  THLPosicoesValvula = array[1..3] of THLPosicao;
  THLMatrixConexoes = array[1..5, 1..5] of THLTipoConexao;
  THLLinhas = class;
  THLLinha = class;
  THLNos = class;
  THLNo = class;

  THLAncora = record
    Shape: TShape;
    Point: TPoint;
    Tipo: THLTipoAncora;
    Posicao: THLPosicao;
  end;

  THLProjeto = class(TComponent)
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageDblClick(Sender: TObject);
    procedure ImageClick(Sender: TObject);
    procedure AnchorDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure AnchorDragDrop(Sender, Source: TObject; X, Y: Integer);
  private
    FValvulas: THLValvulas;
    FStatusText: String;
    FParent: TPanel;
    FActiveAction: THLAction;
    FSelectedValvula: THLValvula;
    FGridSize: Integer;
    FSnapToGrid: Boolean;
    FPointIniMove: TPoint;
    FIsAboutToAdd: Boolean;
    FLinhas: THLLinhas;
    FNos: THLNos;
    procedure SetActiveAction(const Value: THLAction);
  public
    property IsAboutToAdd: Boolean read FIsAboutToAdd write FIsAboutToAdd;
    property Parent: TPanel read FParent write FParent;
    property StatusText: String read FStatusText;
    property Valvulas: THLValvulas read FValvulas write FValvulas;
    property Linhas: THLLinhas read FLinhas write FLinhas;
    property ActiveAction: THLAction read FActiveAction write SetActiveAction;
    property GridSize: Integer read FGridSize write FGridSize;
    property SnapToGrid: Boolean read FSnapToGrid write FSnapToGrid;
    function GetValvulaByImage(AImage: TImage): THLValvula;
    function GetAncoraByShape(AShape: TShape): THLAncora;
    function GetElementoByAncora(AAncora: THLAncora): THLElemento;
    procedure UnSelectAll;
    procedure Ready;
    constructor Create(AParent: TPanel);
    destructor Destroy; override;
  end;

  THLElemento = class (TCollectionItem)
  private
    FTipo: THLTipoElemento;
  public
    property Tipo: THLTipoElemento read FTipo write FTipo;
  end;

  THLValvulas = class (TCollection)
  private
    FProjeto: THLProjeto;
    function GetItem(Index: Integer): THLValvula;
    procedure SetItem(Index: Integer; const Value: THLValvula);
  public
    property Projeto: THLProjeto read FProjeto write FProjeto;
    property Items[Index: Integer]: THLValvula read GetItem write SetItem; default;
    function FindById(AId: Integer): THLValvula;
    function Add(APoint: TPoint): THLValvula;
    procedure Delete(Index: Integer);
    procedure Carregar(AAtuacoes: THLAtuacoesValvula);
    procedure Salvar;
    constructor Create;
  end;

  THLValvula = class (THLElemento)
  private
    FProjeto: THLProjeto;
    FSelected: Boolean;
    FCaption: String;
    FImagem: TImage;
    FQtdPosicoes: Integer;
    FQtdVias: Integer;
//    FPosicoes: THLPosicoes;
    FPosicao1: THLPosicao;
    FPosicao2: THLPosicao;
    FPosicao3: THLPosicao;
    FAtuacaoE: THLAtuacaoValvula;
    FAtuacaoD: THLAtuacaoValvula;
    FAncoras: Array [1..17] of THLAncora;
    FModificada: Boolean;
    FId: Integer;
    FPosicoes: THLPosicoesValvula;
    FIsMoving: Boolean;
    FMostrarAncoras: boolean;
    FMostrarAncorasAnterior: boolean;
    procedure SetSelected(const Value: Boolean);
    procedure CriarAncora(APosicao: THLPosicao; AIndice: Integer; AVia: Integer; APonto: TPoint; ATipoAncora: THLTipoAncora);
    procedure SetMostrarAncoras(const Value: boolean);
    procedure DesenhaProlongamentos;
    function GetLeft: Integer;
    function GetRight: Integer;
    function GetBottom: Integer;
    function GetTop: Integer;
  public
    property Caption: String read FCaption write FCaption;
    property Selected: Boolean read FSelected write SetSelected;
    property QtdPosicoes: Integer read FQtdPosicoes write FQtdPosicoes;
    property QtdVias: Integer read FQtdVias write FQtdVias;
    property Imagem: TImage read FImagem write FImagem;
    property Posicoes: THLPosicoesValvula read FPosicoes write FPosicoes;
    property AtuacaoE: THLAtuacaoValvula read FAtuacaoE write FAtuacaoE;
    property AtuacaoD: THLAtuacaoValvula read FAtuacaoD write FAtuacaoD;
    property Modificada: Boolean read FModificada write FModificada;
    property Id: Integer read FId write FId;
    property MostrarAncoras: boolean read FMostrarAncoras write SetMostrarAncoras;
    property Left: Integer read GetLeft;
    property Right: Integer read GetRight;
    property Top: Integer read GetTop;
    property Bottom: Integer read GetBottom;
    procedure Clone(AValvula: THLValvula);
    procedure AtualizaImagem;
    procedure AtualizaAncoras;

    destructor Destroy; override;
  end;

  THLPosicoes = class (TCollection)
  private
    function GetItem(Index: Integer): THLPosicao;
    procedure SetItem(Index: Integer; const Value: THLPosicao);
  public
    property Items[Index: Integer]: THLPosicao read GetItem write SetItem; default;
    function Add: THLPosicao;
    function IndexOf(APosicao: THLPosicao): Integer;
    function FindById(AId: Integer): THLPosicao;
    procedure Delete(Index: Integer);
    procedure Carregar;
    procedure Salvar;
    constructor Create;
  end;

  THLPosicao = class (TCollectionItem)
  private
    FConexoes: THLMatrixConexoes;
    FId: Integer;
    FQtdVias: Integer;
    FImagem: TBitmap;
    FModificada: Boolean;
    FIndice: Integer;
    FValvula: THLValvula;
  public
    property Conexoes: THLMatrixConexoes read FConexoes write FConexoes;
    property Id: Integer read FId write FId;
    property QtdVias: Integer read FQtdVias write FQtdVias;
    property Imagem: TBitmap read FImagem write FImagem;
    property Modificada: Boolean read FModificada write FModificada default True;
    procedure Inicializa;
    procedure Clone(APosicao: THLPosicao);
    procedure AdicionaConexao(ATipo: THLTipoConexao; Origem: Integer; Destino: Integer = 0);
  end;

  THLLinhas = class (TCollection)
  private
    FProjeto: THLProjeto;
    function GetItem(Index: Integer): THLLinha;
    procedure SetItem(Index: Integer; const Value: THLLinha);
  public
    property Projeto: THLProjeto read FProjeto write FProjeto;
    property Items[Index: Integer]: THLLinha read GetItem write SetItem; default;
//    function Add(AElemento1: THLElemento; AAncora1: Integer; AElemento2: THLElemento; AAncora2: Integer): THLLinha;
    function Add(AAncora1, AAncora2: THLAncora): THLLinha;
    constructor Create;
  end;

  THLLinha = class (TCollectionItem)
  private
    FProjeto: THLProjeto;  
    FSegmento1: TShape;
    FSegmento2: TShape;
    FSegmento3: TShape;
    FAncora1: THLAncora;
    FAncora2: THLAncora;
    procedure CriarOuAtualizarSegmento(var ASegmento: TShape; AFrom, ATo: TPoint; AColor: TColor = clBlack);
    procedure CriarSegmentos;
  public
    procedure AtualizarSegmentos;  
  end;

  THLNos = class (TCollection)
  private
    FProjeto: THLProjeto;
    function GetItem(Index: Integer): THLNo;
    procedure SetItem(Index: Integer; const Value: THLNo);
  public
    property Projeto: THLProjeto read FProjeto write FProjeto;
    property Items[Index: Integer]: THLNo read GetItem write SetItem; default;
    function Add(APosicao: TPoint): THLNo;
    constructor Create;
  end;

  THLNo = class (TCollectionItem)
  private
    FProjeto: THLProjeto;
    FAncora: THLAncora;
    FPosicao: TPoint;
    procedure CriarAncora;
  public
  end;


implementation

uses UHLRepositorio, UHLValvulaEdit;

const
  _ANCORA_SIZE = 7;
  _PROLONG_SIZE = 8;

{ THLProjeto }

procedure THLProjeto.AnchorDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  Elemento1, Elemento2: THLElemento;
  Ancora1, Ancora2: THLAncora;
begin

  if (Source is TShape) and (Sender <> Source) then
  begin
    Ancora1 := GetAncoraByShape(TShape(Source));

    Ancora2 := GetAncoraByShape(TShape(Sender));

    if Ancora1.Point.Y < Ancora2.Point.Y
    then Self.FLinhas.Add(Ancora1, Ancora2)
    else Self.FLinhas.Add(Ancora2, Ancora1);
  end;

end;

procedure THLProjeto.AnchorDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TShape) and (Sender <> Source);
end;

constructor THLProjeto.Create(AParent: TPanel);
begin
  inherited Create(nil);
  FParent := AParent;

  FValvulas := THLValvulas.Create;
  FValvulas.FProjeto := Self;

  FLinhas := THLLinhas.Create;
  FLinhas.FProjeto := Self;

  FNos := THLNos.Create;
  FNos.FProjeto := Self;

  FGridSize := 16;
  FSnapToGrid := True;

  FIsAboutToAdd := False;

  Ready;
end;

destructor THLProjeto.Destroy;
begin
  FValvulas.Free;
  FValvulas := nil;

  inherited;
end;

function THLProjeto.GetAncoraByShape(AShape: TShape): THLAncora;
var i, j: Integer;
begin
  for i := 0 to Self.FValvulas.Count-1 do
    for j := 1 to 17 do
      if Self.FValvulas[i].FAncoras[j].Shape = AShape then
      begin
        Result := Self.FValvulas[i].FAncoras[j];
        Exit;
      end;
end;

function THLProjeto.GetElementoByAncora(AAncora: THLAncora): THLElemento;
var i, j: Integer;
begin
  Result := nil;

  for i := 0 to Self.FValvulas.Count-1 do
    for j := 1 to 17 do
      if Self.FValvulas[i].FAncoras[j].Shape = AAncora.Shape then
      begin
        Result := Self.FValvulas[i];
        Exit;
      end;

  { TODO : CILINDROS E OUTROS ELEMENTOS }
end;

function THLProjeto.GetValvulaByImage(AImage: TImage): THLValvula;
var i: Integer;
begin
  Result := nil;
  for i := 0 to Self.FValvulas.Count - 1 do
    if Self.FValvulas[i].FImagem = AImage then
    begin
      Result := Self.FValvulas[i];
      Exit;
    end;
end;

procedure THLProjeto.ImageClick(Sender: TObject);
begin

end;

procedure THLProjeto.ImageDblClick(Sender: TObject);
begin
  if (FSelectedValvula = nil) then
    Exit;

  FSelectedValvula.FIsMoving := False;

  TfrmHLValvulaEdit.Open(FSelectedValvula);

  FSelectedVAlvula.AtualizaAncoras;

  FActiveAction := acEdited;
end;

procedure THLProjeto.ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  valvula: THLValvula;
  pDest: TPoint;
begin
  if (FParent <> nil) and FIsAboutToAdd then
  begin
    pDest.X := TImage(Sender).Left + X;
    pDest.Y := TImage(Sender).Top + Y;

    FParent.OnMouseDown(FParent, Button, Shift, pDest.X, pDest.Y);
    Exit;
  end;

  valvula := GetValvulaByImage(TImage(Sender));
  if valvula = nil then
    Exit;

  if FActiveAction = acSelect then
  begin
    if Assigned(valvula) then
    begin
      valvula.Selected := True;
      valvula.FIsMoving := True;
      FPointIniMove := Point(X, Y);
      valvula.FMostrarAncorasAnterior := valvula.FMostrarAncoras;
      valvula.MostrarAncoras := false;
    end;
  end
  else if FActiveAction = acEdited then
  begin
    FActiveAction := acSelect;
    valvula.Selected := True;    
  end;
end;

procedure THLProjeto.ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  pCursor, pPanel, pDest: TPoint;
begin
  if (FSelectedValvula = nil) or (FSelectedValvula.FImagem = nil) or (not FSelectedValvula.FIsMoving) then
    Exit;

  GetCursorPos(pCursor);

  pPanel := Point(0, 0);
  GetScreenPosition(FParent, pPanel);

  pCursor.X := pCursor.X - pPanel.X;
  pCursor.Y := pCursor.Y - pPanel.Y;

  pDest.X := pCursor.X - FPointIniMove.X;
  pDest.Y := pCursor.Y - FPointIniMove.Y;

  if FSnapToGrid then
  begin
    pDest.X := Round((pDest.X + 32) / FGridSize) * FGridSize - 32;
    pDest.Y := Round((pDest.Y + _PROLONG_SIZE) / FGridSize) * FGridSize - _PROLONG_SIZE;
  end;

  FSelectedValvula.FImagem.Left := pDest.X;
  FSelectedValvula.FImagem.Top  := pDest.Y;
end;

procedure THLProjeto.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FSelectedValvula <> nil then
  begin
    FSelectedValvula.FIsMoving := False;
    FSelectedVAlvula.AtualizaAncoras;    
    FSelectedValvula.MostrarAncoras := FSelectedValvula.FMostrarAncorasAnterior;    
  end;
end;

procedure THLProjeto.Ready;
begin
  FStatusText := 'Pronto';
end;

procedure THLProjeto.SetActiveAction(const Value: THLAction);
begin
  FActiveAction := Value;
  if FActiveAction <> acSelect then
    UnSelectAll;  
end;

procedure THLProjeto.UnSelectAll;
var i: Integer;
begin
{  FSelectedValvula := nil;
  FSelectedConexao := nil; }

  for i := 0 to FValvulas.Count - 1 do
    Self.FValvulas[i].Selected := False;

end;

{ THLValvulas }

function THLValvulas.Add(APoint: TPoint): THLValvula;
begin
  Result := inherited Add as THLValvula;

  with Result do
  begin

    if (Self.FProjeto <> nil) and (Self.FProjeto.FParent <> nil) then
    begin

      if Self.FProjeto.FSnapToGrid then
      begin
        APoint.X := Round((APoint.X + 32) / Self.FProjeto.FGridSize) * Self.FProjeto.FGridSize - 32;
        APoint.Y := Round((APoint.Y) / Self.FProjeto.FGridSize) * Self.FProjeto.FGridSize - _PROLONG_SIZE;
      end;

      Result.FProjeto := Self.FProjeto;

      FImagem := TImage.Create(FProjeto.FParent);
      FImagem.Parent := FProjeto.FParent;
      FImagem.Top := APoint.Y;
      FImagem.Left := APoint.X;
      FImagem.Transparent := True;
      FImagem.Stretch := False;

      FImagem.OnMouseDown := FProjeto.ImageMouseDown;
      FImagem.OnMouseMove := FProjeto.ImageMouseMove;
      FImagem.OnMouseUp   := FProjeto.ImageMouseUp;
      FImagem.OnDblClick  := FProjeto.ImageDblClick;
      FImagem.OnClick     := FProjeto.ImageClick;
    end
    else
      FImagem := TImage.Create(nil);

    FImagem.Height := 32;
    FImagem.Width := LarguraValvula(3);

    FQtdPosicoes := 2;

    FPosicao1 := THLPosicao.Create(nil);
    FPosicao2 := THLPosicao.Create(nil);
    FPosicao3 := THLPosicao.Create(nil);

    FPosicao1.FValvula := Result;
    FPosicao2.FValvula := Result;
    FPosicao3.FValvula := Result;

    FPosicao1.FId := -1;
    FPosicao2.FId := -1;
    FPosicao3.FId := -1;

    FPosicao1.FIndice := 1;
    FPosicao2.FIndice := 2;
    FPosicao3.FIndice := 3;

    FPosicoes[1] := FPosicao1;
    FPosicoes[2] := FPosicao2;
    FPosicoes[3] := FPosicao3;

    FModificada := True;

    FMostrarAncoras := True;


    {
    FImagem.Parent  := FProjeto.FParent;
    FImagem.Left := APoint.X;
    FImagem.Top  := APoint.Y;
    FImagem.Transparent := True;}

    {
    FPosicao1 := THLPosicao.Create(nil);
    FPosicao2 := THLPosicao.Create(nil);
    FPosicao3 := THLPosicao.Create(nil);
    }
  end;
end;

constructor THLValvulas.Create;
begin
  inherited Create(THLValvula);
end;

procedure THLValvulas.Delete(Index: Integer);
begin
  if Assigned(Items[Index].FImagem) then
  begin
    Items[Index].FImagem.Free;
    Items[Index].FImagem := nil;
  end;
  inherited Delete(Index);
end;

function THLValvulas.GetItem(Index: Integer): THLValvula;
begin
  Result := inherited Items[Index] as THLValvula;
end;

procedure THLValvulas.SetItem(Index: Integer; const Value: THLValvula);
begin
  inherited Items[Index] := Value;
end;


function THLValvulas.FindById(AId: Integer): THLValvula;
var i: Integer;
begin
  Result := nil;
  for i := 0 to Self.Count-1 do
    if Self.Items[i].FId = AId then
    begin
      Result := Self.Items[i];
      Break;
    end;
end;

{ THLValvula }

procedure THLValvula.CriarAncora(APosicao: THLPosicao; AIndice: Integer; AVia: Integer; APonto: TPoint; ATipoAncora: THLTipoAncora);
var
  Ancora: TShape;
  iRaio: Integer;
begin
  if FProjeto.FParent = nil then
    Exit;

  iRaio := Trunc(_ANCORA_SIZE div 2);

  Ancora := TShape.Create(FProjeto.FParent);
  Ancora.Parent := FProjeto.FParent;
  Ancora.Top    := APonto.Y - iRaio; // _PROLONG_SIZE + FImagem.Top  + APosicaoShape.Y;
  Ancora.Left   := APonto.X - iRaio; // FImagem.Left + APosicaoShape.X;

  Ancora.Width  := _ANCORA_SIZE;
  Ancora.Height := _ANCORA_SIZE;

  Ancora.Shape  := stCircle;

  Ancora.Pen.Style   := psSolid;
  Ancora.Pen.Color   := clBlack;
  Ancora.Pen.Width   := 1;

  //Ancora.Brush.Color := $000080FF;
  Ancora.Brush.Style := bsClear;

  Ancora.Visible := FMostrarAncoras;

  Ancora.Cursor := crHandPoint;

  Ancora.Tag := AVia;

  Ancora.DragMode   := dmAutomatic;
  Ancora.DragCursor := crHandPoint;
  Ancora.OnDragOver := FProjeto.AnchorDragOver;
  Ancora.OnDragDrop := FProjeto.AnchorDragDrop;

  FAncoras[AIndice].Shape   := Ancora;
  FAncoras[AIndice].Point   := APonto;
  FAncoras[AIndice].Tipo    := ATipoAncora;
  FAncoras[AIndice].Posicao := APosicao;
end;

procedure THLValvula.AtualizaAncoras;
var
  i, j, iX: Integer;
  pAncora: TPoint;
begin
  for i := 1 to 17 do
    if Assigned(FAncoras[i].Shape) then
    begin
      FAncoras[i].Shape.Free;
      FAncoras[i].Shape := nil;
      FAncoras[i].Point := Point(0, 0);
    end;

  if Assigned(AtuacaoE) and (AtuacaoE.Tipo = taPiloto) then
  begin
    pAncora.X := Imagem.Left;
    pAncora.Y := Imagem.Top + _PROLONG_SIZE + 16;

    CriarAncora(FPosicao1, 1, 0, pAncora, anPilotoE);
  end;

                       { TODO : PONTOS 0 0 }

  if Assigned(AtuacaoD) and (AtuacaoD.Tipo = taPiloto) then
  begin
    iX := 126;

    if Self.QtdPosicoes = 3 then
      iX := 158;

    pAncora.X := Imagem.Left + iX;
    pAncora.Y := Imagem.Top + _PROLONG_SIZE + 16;

    CriarAncora(Posicoes[FQtdPosicoes], 2, 0, pAncora, anPilotoD);
  end;

  for i := 1 to FQtdPosicoes do
    for j := 1 to FQtdVias do
    begin
      pAncora   := PointOfAnchor(FQtdVias, j);

      pAncora.X := Imagem.Left + InicioPosicao(i) + pAncora.X;
      pAncora.Y := Imagem.Top + iif(Odd(j), 2*_PROLONG_SIZE-1, 0) +  pAncora.Y;

{
      pShape.X  := pAncora.X - iRaio;
      pShape.Y  := pAncora.Y - iRaio;
}

      CriarAncora(Posicoes[i], 2 + Pred(i)*FQtdVias + j, j, pAncora, iif(Odd(j), anViaImpar, anViaPar));
    end;
             {
  if Self.FQtdVias = 2 then
  begin
    pSaida    := PointOfAncora(2, 1);
    pAncora.X := 32 + pSaida.X;
    pAncora.Y := _PROLONG_SIZE + pSaida.Y;

    pAncora.X := pAncora.X - iRaio;
    pAncora.Y := pAncora.Y - iRaio - 1;

    CriarAncora(3, pAncora);
  end;        }
end;

procedure THLValvula.DesenhaProlongamentos;
var i, j: Integer;
    pFrom, pTo: TPoint;
begin
  for i := 1 to FQtdPosicoes do
    for j := 1 to FQtdVias do
    begin
      pFrom.X := InicioPosicao(i) + PointOfAnchor(FQtdVias,j).X;
      pTo.X   := pFrom.X;

      if Odd(j) then
      begin
        pFrom.Y := _PROLONG_SIZE + 32;
        pTo.Y   := pFrom.Y + _PROLONG_SIZE;
      end
      else
      begin
        pFrom.Y := 0;
        pTo.Y   := _PROLONG_SIZE;
      end;

      FImagem.Canvas.Pen.Color := clBlack;
      FImagem.Canvas.Pen.Style := psSolid;

      FImagem.Canvas.MoveTo(pFrom.X, pFrom.Y);
      FImagem.Canvas.LineTo(pTo.X, pTo.Y);
    end;
end;

procedure THLValvula.AtualizaImagem;
var
  rFrom, rTo: TRect;
begin
  Self.Imagem.Width  := LarguraValvula(3);
  Self.Imagem.Height := 32 + _PROLONG_SIZE*2;

  rFrom := Rect(0, 0, LarguraValvula(3), 32 + _PROLONG_SIZE*2);

  Self.Imagem.Canvas.Pen.Style := psClear;
  Self.Imagem.Canvas.Brush.Color := clWhite;  
  Self.Imagem.Canvas.FillRect(rFrom);

  rFrom := Rect(0, 0, 32, 32);

  rTo   := Rect(0, _PROLONG_SIZE, 32, 32 + _PROLONG_SIZE);
  if Self.AtuacaoE <> nil then
    Self.Imagem.Canvas.CopyRect(rTo, Self.AtuacaoE.ImagemE.Canvas, rFrom);

  rTo := Rect(InicioPosicao(1), _PROLONG_SIZE, FimPosicao(1), 32 + _PROLONG_SIZE);
  Self.Imagem.Canvas.CopyRect(rTo, Self.Posicoes[1].Imagem.Canvas, rFrom);

  rTo := Rect(InicioPosicao(2), _PROLONG_SIZE, FimPosicao(2), 32 + _PROLONG_SIZE);
  Self.Imagem.Canvas.CopyRect(rTo, Self.Posicoes[2].Imagem.Canvas, rFrom);

  if Self.QtdPosicoes = 2 then
  begin
    rTo := Rect(FimPosicao(2), _PROLONG_SIZE, FimPosicao(2)+32, 32 + _PROLONG_SIZE);
    if Self.AtuacaoD <> nil then
      Self.Imagem.Canvas.CopyRect(rTo, Self.AtuacaoD.ImagemD.Canvas, rFrom);
  end
  else
  begin
    rTo := Rect(InicioPosicao(3), _PROLONG_SIZE, FimPosicao(3), 32 + _PROLONG_SIZE);
    Self.Imagem.Canvas.CopyRect(rTo, Self.Posicoes[3].Imagem.Canvas, rFrom);

    rTo := Rect(FimPosicao(3), _PROLONG_SIZE, FimPosicao(3)+32, 32 + _PROLONG_SIZE);
    if Self.AtuacaoD <> nil then
      Self.Imagem.Canvas.CopyRect(rTo, Self.AtuacaoD.ImagemD.Canvas, rFrom);
  end;

  DesenhaProlongamentos;
{  AtualizaAncoras;}
end;

procedure THLValvula.Clone(AValvula: THLValvula);
var
  r: TRect;
begin
  FId := AValvula.FId;
  FQtdVias     := AValvula.FQtdVias;
  FQtdPosicoes := AValvula.FQtdPosicoes;

  FPosicao1.Clone(AValvula.FPosicao1);
  FPosicao2.Clone(AValvula.FPosicao2);
  FPosicao3.Clone(AValvula.FPosicao3);

  FAtuacaoE    := AValvula.FAtuacaoE;
  FAtuacaoD    := AValvula.FAtuacaoD;

  r := Rect(0, 0, LarguraValvula(3), 32);

  //FImagem.Canvas.CopyRect(r, AValvula.FImagem.Canvas, r);
  AtualizaImagem;
  AtualizaAncoras;
end;

destructor THLValvula.Destroy;
begin
  FImagem.Free;

{  if Assigned(FPosicoes) then
    FPosicoes.Free;}
    
  FPosicao1.Free;
  FPosicao2.Free;
  FPosicao3.Free;
  
  inherited;
end;

procedure THLValvulas.Carregar(AAtuacoes: THLAtuacoesValvula);
var
  sPath, sValvula, sImageFileName: String;
  fileValvulas: TIniFile;
  i, j, iQtd, iIdPosicao, iIdAtuacao: Integer;
  Valvula: THLValvula;
begin
  sPath := ExtractFilePath(ParamStr(0));

  fileValvulas := TIniFile.Create(sPath + 'config_valvulas.ini');
  try
    iQtd := fileValvulas.ReadInteger('Valvulas', 'MaxId', 0);

    for i := 1 to iQtd do
    begin
      sValvula := Format('Valvula_%d', [i]);

      if not fileValvulas.SectionExists(sValvula) then
        Continue;

      Valvula := Self.Add(Point(0, 0));

      Valvula.FModificada  := False;
      Valvula.FId          := fileValvulas.ReadInteger(sValvula, 'Id', 0);
      Valvula.FQtdVias     := fileValvulas.ReadInteger(sValvula, 'QtdVias', 0);
      Valvula.FQtdPosicoes := fileValvulas.ReadInteger(sValvula, 'QtdPosicoes', 0);

      sImageFileName := Format('%srepositorio\valvulas\v%d.bmp', [sPath, Valvula.FId]);

      iIdAtuacao := fileValvulas.ReadInteger(sValvula, 'AtuacaoE', 0);
      if iIdAtuacao > 0 then
        Valvula.FAtuacaoE := AAtuacoes[iIdAtuacao];

      iIdAtuacao := fileValvulas.ReadInteger(sValvula, 'AtuacaoD', 0);
      if iIdAtuacao > 0 then
        Valvula.FAtuacaoD := AAtuacoes[iIdAtuacao];

      if FileExists(sImageFileName) then
        Valvula.FImagem.Picture.LoadFromFile(sImageFileName);
//          showmessage(colortostring(Valvula.FImagem.Canvas.Pixels[32,1]));

      for j := 1 to Valvula.FQtdPosicoes do
      begin
        iIdPosicao := fileValvulas.ReadInteger(sValvula, Format('Posicao_%d', [j]), 0);

        Valvula.Posicoes[j].Clone(UHLRepositorio.Posicoes.FindById(iIdPosicao));
      end;

    end;

  finally
    fileValvulas.Free;
  end;
end;


procedure THLValvulas.Salvar;
var
  i, j: Integer;
  iMaxId: Integer;
  sPath, sImageFileName, sValvula, sPosicao: String;
  fileValvulas: TIniFile;
  Valvula: THLValvula;
begin
  sPath := ExtractFilePath(ParamStr(0));

  fileValvulas := TIniFile.Create(sPath + 'config_valvulas.ini');
  try
    iMaxId := fileValvulas.ReadInteger('Valvulas', 'MaxId', 0);

    for i := 0 to Self.Count-1 do
    begin
      Valvula := Items[i];
      if Valvula.Modificada then
      begin
        if Valvula.FId = 0 then
        begin
          Inc(iMaxId);        
          Valvula.FId := iMaxId;
          fileValvulas.WriteInteger('Valvulas', 'MaxId', iMaxId);
        end;

        sValvula := Format('Valvula_%d', [Valvula.FId]);

        fileValvulas.WriteInteger(sValvula, 'Id', Valvula.FId);
        fileValvulas.WriteInteger(sValvula, 'QtdVias', Valvula.FQtdVias);
        fileValvulas.WriteInteger(sValvula, 'QtdPosicoes', Valvula.FQtdPosicoes);

        for j := 1 to Valvula.FQtdPosicoes do
        begin
          sPosicao := Format('Posicao_%d', [j]);
          fileValvulas.WriteInteger(sValvula, sPosicao, Valvula.Posicoes[j].FId);
        end;

        if Valvula.AtuacaoE <> nil then
          fileValvulas.WriteInteger(sValvula, 'AtuacaoE', Valvula.FAtuacaoE.Id);

        if Valvula.AtuacaoD <> nil then
          fileValvulas.WriteInteger(sValvula, 'AtuacaoD', Valvula.FAtuacaoD.Id);

        sImageFileName := Format('%srepositorio\valvulas\v%d.bmp', [sPath, Valvula.FId]);

        if FileExists(sImageFileName) then
          DeleteFile(sImageFileName);

        try
          Valvula.FImagem.Picture.SaveToFile(sImageFileName);
        except
          MessageDlg('Erro ao atualizar imagem da válvula', mtError, [mbOk], 0);
        end;

        Valvula.FModificada := False;
      end;
    end;

    fileValvulas.WriteInteger('Valvulas', 'MaxId', iMaxId);
  finally
    fileValvulas.Free;
  end;
end;

procedure THLValvula.SetSelected(const Value: Boolean);
begin
  FSelected := Value;
  if FSelected then
  begin
    FProjeto.UnSelectAll;
    FProjeto.FSelectedValvula := Self;
    PaintImage(Self.FImagem, clRed);
  end
  else
  begin
    PaintImage(Self.FImagem, clBlack);  
  end;
end;


procedure THLValvula.SetMostrarAncoras(const Value: boolean);
var i: Integer;
begin
  FMostrarAncoras := Value;

  for i := 1 to 17 do
    if Assigned(FAncoras[i].Shape) then
      FAncoras[i].Shape.Visible := FMostrarAncoras;
end;

function THLValvula.GetLeft: Integer;
begin
  Result := iif(FImagem <> nil, FImagem.Left, 0);
end;

function THLValvula.GetRight: Integer;
begin
  Result := GetLeft + LarguraValvula(FQtdPosicoes);
end;

function THLValvula.GetTop: Integer;
begin
  Result := iif(FImagem <> nil, FImagem.Top, 0);
end;

function THLValvula.GetBottom: Integer;
begin
  Result := GetTop + 32;
end;

{ THLPosicoes }

function THLPosicoes.Add: THLPosicao;
begin
  Result := inherited Add as THLPosicao;
  Result.Inicializa;
end;

procedure THLPosicoes.Carregar;
var
  sPath, sPosicao, sConexao, sImageFileName: String;
  filePosicoes: TIniFile;
  i, j, k, iQtd: Integer;
  Posicao: THLPosicao;
  TipoConexao: THLTipoConexao;
  slConexoes: TStringList;
begin
  sPath := ExtractFilePath(ParamStr(0));

  filePosicoes := TIniFile.Create(sPath + 'config_posicoes.ini');
  try
    iQtd := filePosicoes.ReadInteger('Posicoes', 'MaxId', 0);

    for i := 1 to iQtd do
    begin
      sPosicao := Format('Posicao_%d', [i]);

      if not filePosicoes.SectionExists(sPosicao) then
        Continue;

      Posicao := Self.Add;
      Posicao.Inicializa;

      Posicao.FModificada := False;
      Posicao.FId         := filePosicoes.ReadInteger(sPosicao, 'Id', 0);
      Posicao.FQtdVias    := filePosicoes.ReadInteger(sPosicao, 'QtdVias', 0);

      sImageFileName := Format('%srepositorio\caixas\cp%d.bmp', [sPath, Posicao.FId]);

      if FileExists(sImageFileName) then
        Posicao.FImagem.LoadFromFile(sImageFileName);

      for j := 1 to Posicao.FQtdVias do
      begin
        sConexao := Format('Conexoes_%d', [j]);

        slConexoes := TStringList.Create;
        try
          slConexoes.DelimitedText := filePosicoes.ReadString(sPosicao, sConexao, '');

          for k := 1 to slConexoes.Count do
          begin
            TipoConexao := CharToTipoConexao(slConexoes[k-1][1]);
            if TipoConexao <> tcNone then
              Posicao.AdicionaConexao(TipoConexao, j, k);
          end;
        finally
          slConexoes.Free;
        end;
      end;
    end;

  finally
    filePosicoes.Free;
  end;
end;

constructor THLPosicoes.Create;
begin
  inherited Create(THLPosicao);
end;

procedure THLPosicoes.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;

function THLPosicoes.FindById(AId: Integer): THLPosicao;
var i: Integer;
begin
  Result := nil;
  for i := 0 to Self.Count-1 do
    if Self.Items[i].FId = AId then
    begin
      Result := Self.Items[i];
      Break;
    end;
end;

function THLPosicoes.GetItem(Index: Integer): THLPosicao;
begin
  Result := inherited Items[Index] as THLPosicao;
end;

function THLPosicoes.IndexOf(APosicao: THLPosicao): Integer;
var i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Count-1 do
    if Self.Items[i] = APosicao then
      Result := i;
end;

procedure THLPosicoes.Salvar;
var
  i, j, k: Integer;
  iMaxId: Integer;
  sPath, sImageFileName, sPosicao, sConexao: String;
  filePosicoes: TIniFile;
  Posicao: THLPosicao;
  slConexoes: TStringList;
begin
  sPath := ExtractFilePath(ParamStr(0));

  filePosicoes := TIniFile.Create(sPath + 'config_posicoes.ini');
  try
    iMaxId := filePosicoes.ReadInteger('Posicoes', 'MaxId', 0);

    for i := 0 to Self.Count-1 do
    begin
      Posicao := Items[i];
      if Posicao.Modificada then
      begin
        if Posicao.FId = 0 then
        begin
          Inc(iMaxId);        
          Posicao.FId := iMaxId;
          filePosicoes.WriteInteger('Posicoes', 'MaxId', iMaxId);
        end;

        sPosicao := Format('Posicao_%d', [Posicao.FId]);

        filePosicoes.WriteInteger(sPosicao, 'Id', Posicao.FId);
        filePosicoes.WriteInteger(sPosicao, 'QtdVias', Posicao.FQtdVias);

        for j := 1 to Posicao.FQtdVias do
        begin
          slConexoes := TStringList.Create;
          try
            sConexao := Format('Conexoes_%d', [j]);

            for k := 1 to Posicao.FQtdVias do
              slConexoes.Add(TipoConexaoToChar(Posicao.FConexoes[j,k]));

            filePosicoes.WriteString(sPosicao, sConexao, slConexoes.DelimitedText);
          finally
            slConexoes.Free;
          end;
        end;

        sImageFileName := Format('%srepositorio\caixas\cp%d.bmp', [sPath, Posicao.FId]);

        if FileExists(sImageFileName) then
          DeleteFile(sImageFileName);

        try
          Posicao.FImagem.SaveToFile(sImageFileName);
        except
          MessageDlg('Erro ao atualizar imagem da caixa de posição', mtError, [mbOk], 0);
        end;

        Posicao.FModificada := False;
      end;
    end;

    filePosicoes.WriteInteger('Posicoes', 'MaxId', iMaxId);
  finally
    filePosicoes.Free;
  end;
end;

procedure THLPosicoes.SetItem(Index: Integer; const Value: THLPosicao);
begin
  inherited Items[Index] := Value;
end;


{ THLPosicao }

procedure THLPosicao.AdicionaConexao(ATipo: THLTipoConexao; Origem, Destino: Integer);
begin
  if Destino = 0 then
    Destino := Origem;

  FConexoes[Origem, Destino] := ATipo;

  if ATipo = tcDirecional then
    FConexoes[Destino, Origem] := tcDirecionalReversa;

  if ATipo = tcSimples then
    FConexoes[Destino, Origem] := tcSimples;

  FModificada := True;
end;

procedure THLPosicao.Clone(APosicao: THLPosicao);
var
  r: TRect;
begin
  if APosicao = nil then
    Exit;

  Inicializa;

  FId := APosicao.FId;
  FQtdVias := APosicao.FQtdVias;
  FConexoes := APosicao.FConexoes;
  FModificada := APosicao.FModificada;

  r := Rect(0, 0, 32, 32);
  if APosicao.FImagem <> nil then
    FImagem.Canvas.CopyRect(r, APosicao.FImagem.Canvas, r);
end;

procedure THLPosicao.Inicializa;
var i, j: Integer;
begin
  for i := 1 to 5 do
    for j := 1 to 5 do
      FConexoes[i, j] := tcNone;

  if FImagem <> nil then
  begin
    FImagem.Free;
    FImagem := nil;
  end;

  FImagem := TBitmap.Create;
  FImagem.Width := 32;
  FImagem.Height := 32;
  FImagem.Canvas.Rectangle(0,0,FImagem.Width,FImagem.Height);

  FModificada := True;
end;

{ THLLinhas }


function THLLinhas.Add(AAncora1, AAncora2: THLAncora): THLLinha;
begin
  Result := inherited Add as THLLinha;

  if Self.FProjeto <> nil then
    Result.FProjeto := Self.FProjeto;

  with Result do
  begin
    FAncora1 := AAncora1;
    FAncora2 := AAncora2;

    CriarSegmentos;
  end;
end;

constructor THLLinhas.Create;
begin
  inherited Create(THLLinha);
end;

function THLLinhas.GetItem(Index: Integer): THLLinha;
begin
  Result := inherited Items[Index] as THLLinha;
end;

procedure THLLinhas.SetItem(Index: Integer; const Value: THLLinha);
begin
  inherited Items[Index] := Value;
end;

{ THLLinha }

procedure THLLinha.AtualizarSegmentos;
var
  p1From, p1To, p3From, p3To: TPoint;
begin
{
  p1From.X := FAncora1.Point.X;
  p1From.Y := FAncora1.Point.Y;

  p1To.X := FSegmento2.Left;
  p1To.Y := FSegmento2.Top + 1;

  CriarOuAtualizarSegmento(FSegmento1, p1From, p1To, clRed);

  p3From.X := FSegmento2.Left + FSegmento2.Width;
  p3From.Y := FSegmento2.Top  + FSegmento2.Height - 1;

  p3To.X := FAncora2.Point.X;
  p3To.Y := FAncora2.Point.Y;

  CriarOuAtualizarSegmento(FSegmento3, p3From, p3To, clBlue);
}
  p1From.X := FAncora1.Point.X;
  p1From.Y := FAncora1.Point.Y;

  p1To.X := FAncora1.Point.X;
  p1To.Y := FSegmento2.Top + iif(FAncora1.Point.Y > FSegmento2.Top, 0, 1);

  CriarOuAtualizarSegmento(FSegmento1, p1From, p1To, clRed);

  p3From.X := FAncora2.Point.X;
  p3From.Y := FSegmento2.Top + FSegmento2.Height + iif(FSegmento2.Top > FAncora2.Point.Y, 0, -1);

  p3To.X := FAncora2.Point.X;
  p3To.Y := FAncora2.Point.Y;

  CriarOuAtualizarSegmento(FSegmento3, p3From, p3To, clBlue);
end;

procedure THLLinha.CriarSegmentos;
var
  p2From, p2To, pNo: TPoint;
  tpLinha: THLTipoLinha;
  iXE, iXD, iXM: Integer;
  no: THLNo;
  ancora3: THLAncora;
begin



{
  if (FAncora1.Tipo in [anViaPar, anViaImpar]) and (FAncora2.Tipo in [anViaPar, anViaImpar]) then
    tpLinha := tlVHV
  else
  begin
    if Abs(FAncora1.Point.X - FAncora2.Point.X) > Abs(FAncora1.Point.Y - FAncora2.Point.Y)
    then tpLinha := tlHVH
    else tpLinha := tlVHV;
  end;

  if tpLinha = tlHVH then
  begin
    p2From.X := FAncora1.Point.X + (FAncora2.Point.X - FAncora1.Point.X) div 2;
    p2From.Y := FAncora1.Point.Y;

    p2To.X := p2From.X;
    p2To.Y := FAncora2.Point.Y;

    CriarOuAtualizarSegmento(FSegmento2, p2From, p2To);
  end
  else}

  tpLinha := tlVHV;

  if (FAncora1.Tipo = anNo) or (FAncora2.Tipo = anNo) then
  begin

    if (FAncora2.Tipo = anViaPar) then
    begin
      p2From.X := FAncora1.Point.X;
      p2From.Y := (FAncora1.Point.Y + FAncora2.Posicao.FValvula.Top) div 2;

      p2To.X := FAncora2.Point.X;
      p2To.Y := p2From.Y;
    end
    else if (FAncora2.Tipo = anViaImpar) then
    begin
      p2From.X := FAncora1.Point.X;
      p2From.Y := FAncora2.Point.Y + 30;

      p2To.X := FAncora2.Point.X;
      p2To.Y := p2From.Y;
    end
    else if (FAncora2.Tipo in [anPilotoE, anPilotoD]) then
    begin
      p2From.X := FAncora1.Point.X;
      p2From.Y := FAncora2.Point.Y;

      p2To.X := FAncora2.Point.X;
      p2To.Y := p2From.Y;
    end;

    CriarOuAtualizarSegmento(FSegmento2, p2From, p2To);
    AtualizarSegmentos;

  end
  else if (FAncora1.Tipo = anViaImpar) and (FAncora2.Tipo = anViaPar) then
  begin
    p2From.X := FAncora1.Point.X;
    p2From.Y := (FAncora1.Point.Y + FAncora2.Point.Y) div 2;

    p2To.X := FAncora2.Point.X;
    p2To.Y := p2From.Y;

    CriarOuAtualizarSegmento(FSegmento2, p2From, p2To);
    AtualizarSegmentos;
  end
  else
  begin
    pNo.Y := (FAncora1.Shape.Top + FAncora2.Shape.Top) div 2;

    iXE := Menor(FAncora1.Posicao.FValvula.Left, FAncora2.Posicao.FValvula.Left) - 16;
    iXD := Maior(FAncora1.Posicao.FValvula.Right, FAncora2.Posicao.FValvula.Right) + 17;
    iXM := (Menor(FAncora1.Posicao.FValvula.Right, FAncora2.Posicao.FValvula.Right) + Maior(FAncora1.Posicao.FValvula.Left, FAncora2.Posicao.FValvula.Left)) div 2;

    if (FAncora1.Tipo = anPilotoE) and (FAncora1.Point.X < FAncora2.Point.X) then
      pNo.X := iXE
    else if (FAncora2.Tipo = anPilotoE) and (FAncora2.Point.X < FAncora1.Point.X) then
      pNo.X := iXE
    else if (FAncora1.Tipo = anPilotoD) and (FAncora1.Point.X > FAncora2.Point.X) then
      pNo.X := iXD
    else if (FAncora2.Tipo = anPilotoD) and (FAncora1.Point.X < FAncora2.Point.X) then
      pNo.X := iXD
    else if (FAncora1.Tipo = anViaPar) and (FAncora2.Tipo = anViaPar) and
       ((FAncora2.Point.X < FAncora1.Posicao.FValvula.Left) or (FAncora2.Point.X > FAncora1.Posicao.FValvula.Right)) then
      pNo.X := FAncora2.Point.X
    else if (Maior(FAncora1.Posicao.FValvula.Left, FAncora2.Posicao.FValvula.Left) - Menor(FAncora1.Posicao.FValvula.Right, FAncora2.Posicao.FValvula.Right) > 20) then
      pNo.X := iXM
    else if (FAncora2.Tipo = anPilotoE) then
      pNo.X := iXE
    else if (FAncora2.Tipo = anPilotoD) then
      pNo.X := iXD
    else if (FAncora1.Posicao.FIndice = 1) then
      pNo.X := iXE
    else
      pNo.X := iXD;

    no := FProjeto.FNos.Add(pNo);

    ancora3 := FAncora2;
    FAncora2 := no.FAncora;

    if (FAncora1.Tipo in [anPilotoE, anPilotoD]) then
    begin
      p2From.X := FAncora1.Point.X;
      
      if (ancora3.Tipo in [anPilotoE, anPilotoD])
      then p2From.Y := (FAncora1.Point.Y + FAncora2.Point.Y) div 2
      else p2From.Y := FAncora1.Point.Y;
    end
    else if (FAncora1.Tipo = anViaPar) then
    begin
      p2From.X := FAncora1.Point.X;
      p2From.Y := FAncora1.Point.Y - 30;
    end
    else {if (FAncora1.Tipo = anViaImpar) then}
    begin
      p2From.X := FAncora1.Point.X;
      p2From.Y := (FAncora1.Point.Y + FAncora2.Point.Y) div 2;
    end;

    p2To.X := FAncora2.Point.X;
    p2To.Y := p2From.Y;    

    CriarOuAtualizarSegmento(FSegmento2, p2From, p2To);
    AtualizarSegmentos;

    Self.FProjeto.FLinhas.Add(no.FAncora, ancora3);
  end;

{

  if (FAncora1.Tipo = anNo) or (FAncora2.Tipo = anNo) then
  begin
    p2From.X := FAncora1.Point.X;
    p2From.Y := (FAncora1.Point.Y + FAncora2.Point.Y) div 2;

    p2To.X := FAncora2.Point.X;
    p2To.Y := p2From.Y;

    CriarOuAtualizarSegmento(FSegmento2, p2From, p2To);
  end
  else
  begin
    if (FAncora1.Tipo = anViaImpar) and (FAncora2.Tipo = anViaImpar) then
    begin
      p2From.X := FAncora1.Point.X;
      p2From.Y := FAncora2.Point.Y + 30;
      p2To.X := FAncora2.Point.X;
      p2To.Y := p2From.Y;

      CriarOuAtualizarSegmento(FSegmento2, p2From, p2To);
    end
    else if (FAncora1.Tipo = anViaPar) and (FAncora2.Tipo = anViaPar) then
    begin
      p2From.X := FAncora1.Point.X;
      p2From.Y := FAncora1.Point.Y - 30;
      p2To.X := FAncora2.Point.X;
      p2To.Y := p2From.Y;
      CriarOuAtualizarSegmento(FSegmento2, p2From, p2To);
    end
    else if (FAncora1.Tipo = anViaPar) and (FAncora2.Tipo = anViaImpar) then
    begin
      p2From.X := FAncora1.Point.X;
      p2From.Y := FAncora1.Point.Y - 30;

      pNo.Y := ((FAncora1.Posicao.FValvula.Top + 24) + (FAncora2.Posicao.FValvula.Top + 24)) div 2;

      if (FAncora1.Posicao.FIndice = 1)
      then pNo.X := Menor(FAncora1.Posicao.FValvula.Left, FAncora2.Posicao.FValvula.Left) - 16
      else pNo.X := Maior(FAncora1.Posicao.FValvula.Right, FAncora2.Posicao.FValvula.Right) + 17;

      no := FProjeto.FNos.Add(pNo);

      ancora3 := FAncora2;
      FAncora2 := no.FAncora;

      p2To.X := FAncora2.Point.X;
      p2To.Y := p2From.Y;

      CriarOuAtualizarSegmento(FSegmento2, p2From, p2To);

      Self.FProjeto.FLinhas.Add(no.FAncora, ancora3)
    end
    else
    begin
      p2From.X := FAncora1.Point.X;
      p2From.Y := FAncora1.Point.Y + (FAncora2.Point.Y - FAncora1.Point.Y) div 2;
      p2To.X := FAncora2.Point.X;
      p2To.Y := p2From.Y;
      CriarOuAtualizarSegmento(FSegmento2, p2From, p2To);
    end;
  end;

  AtualizarSegmentos;       }
end;


procedure THLLinha.CriarOuAtualizarSegmento(var ASegmento: TShape; AFrom, ATo: TPoint; AColor: TColor);
begin
  if not Assigned(ASegmento) then
  begin
    ASegmento := TShape.Create(FProjeto.FParent);

    ASegmento.Parent := FProjeto.FParent;

    ASegmento.Shape  := stRectangle;

    ASegmento.Pen.Style   := psSolid;
    ASegmento.Pen.Color   := AColor;
    ASegmento.Pen.Width   := 1;

    ASegmento.Brush.Style := bsClear;    
  end;

  ASegmento.Left := AFrom.X;
  ASegmento.Top  := AFrom.Y;

  ASegmento.Width  := iif(ATo.X - AFrom.X = 0, 1, ATo.X - AFrom.X);
  ASegmento.Height := iif(ATo.Y - AFrom.Y = 0, 1, ATo.Y - AFrom.Y);
end;


{ THLNos }

function THLNos.Add(APosicao: TPoint): THLNo;
begin
  Result := inherited Add as THLNo;

  if Self.FProjeto <> nil then
    Result.FProjeto := Self.FProjeto;

  Result.FPosicao := APosicao;

  Result.CriarAncora;
end;

constructor THLNos.Create;
begin
  inherited Create(THLNo);
end;

function THLNos.GetItem(Index: Integer): THLNo;
begin
  Result := inherited Items[Index] as THLNo;
end;

procedure THLNos.SetItem(Index: Integer; const Value: THLNo);
begin
  inherited Items[Index] := Value;
end;

procedure THLNo.CriarAncora;
var
  iRaio: Integer;
begin
  if FProjeto.FParent = nil then
    Exit;

  iRaio := Trunc(_ANCORA_SIZE div 2);

  FAncora.Point := FPosicao;
  FAncora.Tipo  := anNo;

  if Assigned(FAncora.Shape) then
  begin
    FAncora.Shape.Free;
    FAncora.Shape := nil;
  end;

  FAncora.Shape := TShape.Create(FProjeto.FParent);

  with FAncora.Shape do
  begin
    Parent := FProjeto.FParent;
    Top    := FPosicao.Y - iRaio;
    Left   := FPosicao.X - iRaio;

    Width  := _ANCORA_SIZE;
    Height := _ANCORA_SIZE;

    Shape  := stCircle;

    Pen.Style   := psSolid;
    Pen.Color   := clBlack;
    Pen.Width   := 1;

    Brush.Style := bsClear;

    Visible := True;

    Cursor := crHandPoint;

    Tag := 0;

    DragMode   := dmAutomatic;
    DragCursor := crHandPoint;
    OnDragOver := FProjeto.AnchorDragOver;
    OnDragDrop := FProjeto.AnchorDragDrop;
  end;
end;

end.


