unit UHLPosicaoEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, UHLDrawPosicao, UHLLib, UHLLibProjeto;

type
  TfrmHLPosicaoEdit = class(TForm)
    pnlEdicao: TPanel;
    btnTCSimples: TSpeedButton;
    btnTCDirecional: TSpeedButton;
    btnTCBloqueio: TSpeedButton;
    Shape1: TShape;
    imgDraw: TImage;
    btnDrawClear: TSpeedButton;
    chkAnchor: TCheckBox;
    Panel1: TPanel;
    btnSaveVia: TBitBtn;
    btnCancelVia: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkAnchorClick(Sender: TObject);
    procedure btnTCDirecionalClick(Sender: TObject);
    procedure btnDrawClearClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Open(APosicao: THLPosicao; AQtdVias: Integer): TModalResult;
  end;

var
  frmHLPosicaoEdit: TfrmHLPosicaoEdit;
  draw: THLDrawPosicao;
  Posicao, PosicaoBackup: THLPosicao;
  QtdVias: Integer;

implementation

{$R *.dfm}

{ TfrmHLPosicaoEdit }

class function TfrmHLPosicaoEdit.Open(APosicao: THLPosicao; AQtdVias: Integer): TModalResult;
begin
  frmHLPosicaoEdit := TfrmHLPosicaoEdit.Create(nil);
  with frmHLPosicaoEdit do
  begin
    try
      QtdVias := AQtdVias;

      CopyCanvas(APosicao.Imagem.Canvas, imgDraw.Canvas);
      Posicao := APosicao;

      PosicaoBackup := THLPosicao.Create(nil);
      try
        PosicaoBackup.Clone(Posicao);

        Result := ShowModal;

        if Result = mrCancel then
          Posicao.Clone(PosicaoBackup);

      finally
        PosicaoBackup.Free;
      end;
    finally
      frmHLPosicaoEdit.Free;
      frmHLPosicaoEdit := nil;
    end;
  end;
end;

procedure TfrmHLPosicaoEdit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  CopyCanvas(imgDraw.Canvas, Posicao.Imagem.Canvas);

  draw.Free;
  draw := nil;
end;

procedure TfrmHLPosicaoEdit.chkAnchorClick(Sender: TObject);
begin
  draw.ExibirAncoras := chkAnchor.Checked;
  pnlEdicao.SetFocus;
end;

procedure TfrmHLPosicaoEdit.btnTCDirecionalClick(Sender: TObject);
begin
  draw.TipoConexao := THLTipoConexao(TSpeedButton(Sender).Tag);
end;

procedure TfrmHLPosicaoEdit.btnDrawClearClick(Sender: TObject);
begin
  draw.ClearCanvas;
end;

procedure TfrmHLPosicaoEdit.FormShow(Sender: TObject);
begin
  draw := THLDrawPosicao.Create(Posicao, imgDraw);
  draw.QtdVias := QtdVias;
end;

end.
