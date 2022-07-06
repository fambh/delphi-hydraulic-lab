unit UHLRepValvulas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, UHLRepositorio,
  ImgList, UHLPosicaoEdit, UHLLibProjeto, UHLValvulaEdit, UHLLib;

type
  TfrmHLRepValvulas = class(TForm)
    pnlBottom: TPanel;
    BitBtn1: TBitBtn;
    imlPosicoes: TImageList;
    Panel1: TPanel;
    Label3: TLabel;
    btnQtdVias2: TSpeedButton;
    btnQtdVias3: TSpeedButton;
    btnQtdVias4: TSpeedButton;
    btnQtdVias5: TSpeedButton;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    tabPosicao: TTabSheet;
    Label1: TLabel;
    btnAddVia: TSpeedButton;
    btnDelVia: TSpeedButton;
    lvwPosicoes: TListView;
    Label2: TLabel;
    btnAddValvula: TSpeedButton;
    btnDelValvula: TSpeedButton;
    scbValvulas: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure btnAddViaClick(Sender: TObject);
    procedure btnQtdVias2Click(Sender: TObject);
    procedure btnDelViaClick(Sender: TObject);
    procedure btnAddValvulaClick(Sender: TObject);
  private
    procedure AdicionaPosicao(APosicao: THLPosicao);
    procedure EditaPosicao(APosicao: THLPosicao);
    function BuscaItemPorPosicao(APosicao: THLPosicao): TListItem;
    procedure CarregaPosicoes;
    procedure AdicionaValvula(AValvula: THLValvula);
    procedure CarregaValvulas;
    procedure EditaValvula(AValvula: THLValvula);
    procedure AtualizaImagemValvula(AImage: TImage; AValvula: THLValvula);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHLRepValvulas: TfrmHLRepValvulas;
  QtdVias: Integer;
  NovaPosicao: TListItem;
  NovaValvula: TImage;


implementation

{$R *.dfm}


procedure TfrmHLRepValvulas.AtualizaImagemValvula(AImage: TImage; AValvula: THLValvula);
var
  rFrom, rTo: TRect;
begin
  rFrom := Rect(0, 0, LarguraValvula(AValvula.QtdPosicoes), 32);
  rTo   := Rect(5, 10, LarguraValvula(AValvula.QtdPosicoes)+5, 42);

  AImage.Picture := nil;
  AImage.Canvas.CopyRect(rTo, AValvula.Imagem.Canvas, rFrom);
//  AImage.Canvas.CopyRect(Rect(0,0,200,32), AValvula.Imagem.Canvas, Rect(0,0,200,32));
end;

procedure TfrmHLRepValvulas.CarregaPosicoes;
var i: Integer;
begin
  lvwPosicoes.Clear;
  imlPosicoes.Clear;

  for i := 0 to Posicoes.Count-1 do
  begin
    if Posicoes.Items[i].QtdVias = QtdVias then
      AdicionaPosicao(Posicoes.Items[i]);
  end;
end;

procedure TfrmHLRepValvulas.AdicionaPosicao(APosicao: THLPosicao);
var
  iImage: Integer;
  item: TListItem;
begin
  iImage := imlPosicoes.AddMasked(APosicao.Imagem, clNone);

  item := lvwPosicoes.Items.Add;
  item.Data := APosicao;
  item.ImageIndex := iImage;

  NovaPosicao := item;
end;

procedure TfrmHLRepValvulas.FormCreate(Sender: TObject);
begin
  QtdVias := 2;

  CarregaPosicoes;

  CarregaValvulas;  
end;

procedure TfrmHLRepValvulas.btnAddViaClick(Sender: TObject);
var posicao: THLPosicao;
begin
  posicao := Posicoes.Add;
  posicao.QtdVias := QtdVias;

  AdicionaPosicao(posicao);

{  lvwPosicoes.Selected := lvwPosicoes.Items[lvwPosicoes.Items.Count-1];
  lvwPosicoes.SetFocus;}

  EditaPosicao(posicao);
end;

procedure TfrmHLRepValvulas.EditaPosicao(APosicao: THLPosicao);
var
  iImage: Integer;
  item: TListItem;
begin
  if TfrmHLPosicaoEdit.Open(APosicao, QtdVias) = mrOk then
  begin
    Posicoes.Salvar;

    item := BuscaItemPorPosicao(APosicao);
    if item <> nil then
    begin
      iImage := imlPosicoes.AddMasked(APosicao.Imagem, clNone);
      item.ImageIndex := iImage;
    end;

    NovaPosicao := nil;
  end
  else
  begin
    if (NovaPosicao <> nil) and (TObject(NovaPosicao.Data) is THLPosicao) then
    begin
      Posicoes.Delete(Posicoes.IndexOf(THLPosicao(NovaPosicao.Data)));
      NovaPosicao.Delete;
      NovaPosicao := nil;
    end;
  end;
end;

function TfrmHLRepValvulas.BuscaItemPorPosicao(APosicao: THLPosicao): TListItem;
var i: Integer;
begin
  Result := nil;

  for i := 0 to lvwPosicoes.Items.Count do
    if lvwPosicoes.Items[i].Data = APosicao then
    begin
      Result := lvwPosicoes.Items[i];
      Exit;
    end;
end;


procedure TfrmHLRepValvulas.btnQtdVias2Click(Sender: TObject);
begin
  QtdVias := TSpeedButton(Sender).Tag;

  CarregaPosicoes;

  CarregaValvulas;
end;

procedure TfrmHLRepValvulas.btnDelViaClick(Sender: TObject);
begin
  NovaPosicao := Nil;
end;

procedure TfrmHLRepValvulas.btnAddValvulaClick(Sender: TObject);
var valvula: THLValvula;
begin
  valvula := Valvulas.Add(Point(0, 0));
  valvula.QtdVias := QtdVias;

  AdicionaValvula(valvula);

  EditaValvula(valvula);
end;

procedure TfrmHLRepValvulas.CarregaValvulas;
var i: Integer;
begin
  for i := scbValvulas.ComponentCount-1 downto 0 do
    if (scbValvulas.Components[i] is TControl) then
      scbValvulas.Components[i].Free;

  for i := Valvulas.Count-1 downto 0 do
  begin
    if Valvulas.Items[i].QtdVias = QtdVias then
      AdicionaValvula(Valvulas.Items[i]);
  end;
end;

procedure TfrmHLRepValvulas.AdicionaValvula(AValvula: THLValvula);
var
  img: TImage;
begin
  img := TImage.Create(scbValvulas);
  img.Parent := scbValvulas;
  img.Height := 52;
  img.Align  := alTop;
  img.Width  := LarguraValvula(3)+5;

  AtualizaImagemValvula(img, AValvula);

  NovaValvula := img;
end;

procedure TfrmHLRepValvulas.EditaValvula(AValvula: THLValvula);
begin
  if TfrmHLValvulaEdit.Open(AValvula) = mrOk then
  begin
    Valvulas.Salvar;

    if (NovaValvula <> nil) then
      AtualizaImagemValvula(NovaValvula, AValvula);

    NovaValvula := nil;
  end
  else
  begin
    if (NovaValvula <> nil) then
    begin
      NovaValvula.Free;
      NovaValvula := nil;
    end;
  end;
end;

end.


