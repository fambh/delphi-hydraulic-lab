unit UHLValvulaEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, UHLLib, UHLComboImage, UHLRepositorio, UHLLibProjeto;

type
  TfrmHLValvulaEdit = class(TForm)
    pnlEdicao: TPanel;
    pnlBottom: TPanel;
    btnSaveVia: TBitBtn;
    btnCancelVia: TBitBtn;
    GroupBox1: TGroupBox;
    btnLMan: TSpeedButton;
    btnLPil: TSpeedButton;
    btnLMol: TSpeedButton;
    Shape1: TShape;
    GroupBox2: TGroupBox;
    imgM2: TImage;
    imgM1: TImage;
    btnM1: TSpeedButton;
    btnM2: TSpeedButton;
    btnM3: TSpeedButton;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    GroupBox4: TGroupBox;
    btnRPil: TSpeedButton;
    btnRMol: TSpeedButton;
    Shape2: TShape;
    pnlTop: TPanel;
    Label1: TLabel;
    cmbNome: TComboBox;
    btnLMec: TSpeedButton;
    btnRMan: TSpeedButton;
    btnRMec: TSpeedButton;
    Shape4: TShape;
    Shape5: TShape;
    imgM3: TImage;
    imgL: TImage;
    imgR: TImage;
    Shape3: TShape;
    Button1: TButton;
    procedure btnM1Click(Sender: TObject);
    procedure btnRManClick(Sender: TObject);
    procedure btnLMecClick(Sender: TObject);
    procedure btnRMecClick(Sender: TObject);
    procedure btnLPilClick(Sender: TObject);
    procedure btnLMolClick(Sender: TObject);
    procedure btnRPilClick(Sender: TObject);
    procedure btnRMolClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLManClick(Sender: TObject);
    procedure btnSaveViaClick(Sender: TObject);
  private
    procedure AbrirCombo(Sender: TObject; AEsquerda: Boolean; ATipo: Integer);
    procedure SetAtuacao(ALeft: Boolean; AIndice: Integer);
    procedure LevantaBotoes(ALeft: Boolean);
    { Private declarations }
  public
    { Public declarations }
    class function Open(AValvula: THLValvula): TModalResult;
  end;

var
  frmHLValvulaEdit: TfrmHLValvulaEdit;
  QtdVias: Integer;
  imgM: array [1..3] of TImage;
  Valvula: THLValvula;

implementation

uses UHLLibAtuacaoValvula, Math;

{$R *.dfm}

{ TfrmHLValvulaEdit }

class function TfrmHLValvulaEdit.Open(AValvula: THLValvula): TModalResult;
begin
  frmHLValvulaEdit := TfrmHLValvulaEdit.Create(nil);
  with frmHLValvulaEdit do
  begin
    try
      Valvula := AValvula;
      QtdVias := AValvula.QtdVias;

      Result := ShowModal;
    finally
      frmHLValvulaEdit.Free;
      frmHLValvulaEdit := nil;
    end;
  end;
end;

procedure TfrmHLValvulaEdit.btnM1Click(Sender: TObject);
var
  p: TPoint;
  r: TRect;
  images: THLComboImages;
  i: Integer;
  idPosicao: Integer;
  img: TImage;
  posicao: THLPosicao;
begin
  SetLength(images, 0);
  for i := 0 to Posicoes.Count - 1 do
    if Posicoes.Items[i].QtdVias = QtdVias then
    begin
      SetLength(images, Length(images)+1);
      images[High(images)].Bitmap := Posicoes.Items[i].Imagem;
      images[High(images)].Index := Posicoes.Items[i].Id;
    end;

  p := Point(0,0);
  GetScreenPosition(TSpeedButton(Sender), p);

  r := Rect(1, 0, 32, 31);
  idPosicao := TfrmHLComboImage.Open(p, images, r);

  img := imgM[TSpeedButton(Sender).Tag];
  img.Picture := nil;

  r := Rect(0, 0, 32, 32);

  if idPosicao >= 0 then
  begin
    posicao := Posicoes.FindById(idPosicao);

    Valvula.Posicoes[TSpeedButton(Sender).Tag].Clone(posicao);

    if posicao <> nil then
      img.Canvas.CopyRect(r, posicao.Imagem.Canvas, r);
  end
  else
  begin
    Valvula.Posicoes[TSpeedButton(Sender).Tag].Id := -1;
  end;

end;

procedure TfrmHLValvulaEdit.AbrirCombo(Sender: TObject; AEsquerda: Boolean; ATipo: Integer);
var
  p: TPoint;
  r: TRect;
  images: THLComboImages;
  i: Integer;
  idAtuacao: Integer;
begin
  // ATipo: 1 - Manual; 2 - Mecanico; 3- Solenoide

  SetLength(images, 0);
  for i := 1 to Length(Atuacoes) do
  begin
    if Assigned(Atuacoes[i]) then
    begin
      if ((ATipo = 1) and (Atuacoes[i].Tipo in [taManual, taManualComTrava])) or
         ((ATipo = 2) and (Atuacoes[i].Tipo in [taMecanica])) or
         ((ATipo = 3) and (Atuacoes[i].Tipo in [taSolenoide])) then
      begin
        SetLength(images, Length(images)+1);
        if AEsquerda
        then images[High(images)].Bitmap := Atuacoes[i].ImagemE
        else images[High(images)].Bitmap := Atuacoes[i].ImagemD;
        images[High(images)].Index := i;
      end;
    end;
  end;

  if AEsquerda
  then p := Point(52,0)
  else p := Point(0,0);
  
  GetScreenPosition(TSpeedButton(Sender), p);

  r := Rect(0, 0, 32, 32);
  idAtuacao := TfrmHLComboImage.Open(p, images, r);

  SetAtuacao(AEsquerda, idAtuacao);
end;

procedure TfrmHLValvulaEdit.btnLManClick(Sender: TObject);
begin
  AbrirCombo(Sender, True, 1);
end;

procedure TfrmHLValvulaEdit.btnRManClick(Sender: TObject);
begin
  AbrirCombo(Sender, False, 1);
end;

procedure TfrmHLValvulaEdit.btnLMecClick(Sender: TObject);
begin
  AbrirCombo(Sender, True, 2);
end;

procedure TfrmHLValvulaEdit.btnRMecClick(Sender: TObject);
begin
  AbrirCombo(Sender, False, 2);
end;

procedure TfrmHLValvulaEdit.LevantaBotoes(ALeft: Boolean);
begin
  if ALeft then
  begin
    btnLPil.Down := False;
    btnLMol.Down := False;
    btnLMan.Down := False;
    btnLMec.Down := False;
  end
  else
  begin
    btnRPil.Down := False;
    btnRMol.Down := False;
    btnRMan.Down := False;
    btnRMec.Down := False;
  end;
end;

procedure TfrmHLValvulaEdit.SetAtuacao(ALeft: Boolean; AIndice: Integer);
var r: TRect; imgTo: TImage; imgFrom: TBitmap;
begin
  r := Rect(0, 0, 32, 32);

  if AIndice = -1 then
  begin
    if ALeft then
    begin
      imgTo := imgL;
      Valvula.AtuacaoE := nil;
    end
    else
    begin
      imgTo := imgR;
      Valvula.AtuacaoD := nil;
    end;

    imgTo.Picture := nil;

    LevantaBotoes(ALeft);
  end
  else
  begin
    if ALeft then
    begin
      imgTo := imgL;
      imgFrom := Atuacoes[AIndice].ImagemE;
      Valvula.AtuacaoE := Atuacoes[AIndice];
    end
    else
    begin
      imgTo := imgR;
      imgFrom := Atuacoes[AIndice].ImagemD;
      Valvula.AtuacaoD := Atuacoes[AIndice];
    end;
    
    imgTo.Canvas.CopyRect(r, imgFrom.Canvas, r);
  end;

  imgTo.Canvas.Brush.Style := bsClear;
  imgTo.Canvas.Rectangle(r);
end;


procedure TfrmHLValvulaEdit.btnLPilClick(Sender: TObject);
begin
  SetAtuacao(True, 1);
end;

procedure TfrmHLValvulaEdit.btnLMolClick(Sender: TObject);
begin
  SetAtuacao(True, 2);
end;

procedure TfrmHLValvulaEdit.btnRPilClick(Sender: TObject);
begin
  SetAtuacao(False, 1);
end;

procedure TfrmHLValvulaEdit.btnRMolClick(Sender: TObject);
begin
  SetAtuacao(False, 2);
end;

procedure TfrmHLValvulaEdit.FormShow(Sender: TObject);
var
  i: Integer;
  r: TRect;
begin
  imgM[1] := imgM1;
  imgM[2] := imgM2;
  imgM[3] := imgM3;

  r := Rect(0, 0, 32, 32);

  for i := 1 to 3 do
    imgM[i].Canvas.CopyRect(r, Valvula.Posicoes[i].Imagem.Canvas, r);

  if Assigned(Valvula.AtuacaoE) then
  begin
    imgL.Canvas.CopyRect(r, Valvula.AtuacaoE.ImagemE.Canvas, r);
    imgL.Canvas.Brush.Style := bsClear;
    imgL.Canvas.Rectangle(r);
  end;

  if Assigned(Valvula.AtuacaoD) then
  begin
    imgR.Canvas.CopyRect(r, Valvula.AtuacaoD.ImagemD.Canvas, r);
    imgR.Canvas.Brush.Style := bsClear;
    imgR.Canvas.Rectangle(r);
  end;
    
end;


procedure TfrmHLValvulaEdit.btnSaveViaClick(Sender: TObject);
begin
  if (Valvula.Posicoes[1].Id = -1) or (Valvula.Posicoes[2].Id = -1) then
  begin
    MessageDlg('A válvula precisa possuir pelo menos 2 posições', mtInformation, [mbOk], 0);
    ModalResult := mrNone;
    Exit;
  end;

  if (Valvula.Posicoes[3].Id = -1)
  then Valvula.QtdPosicoes := 2
  else Valvula.QtdPosicoes := 3;

  Valvula.AtualizaImagem;
end;

end.

