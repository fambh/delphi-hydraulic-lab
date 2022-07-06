program HyLAB;

uses
  Forms,
  UHLMain in 'UHLMain.pas' {frmMain},
  UHLRepValvulas in 'UHLRepValvulas.pas' {frmHLRepValvulas},
  UHLLibProjeto in 'UHLLibProjeto.pas',
  UHLDrawPosicao in 'UHLDrawPosicao.pas',
  UHLLib in 'UHLLib.pas',
  UHLRepositorio in 'UHLRepositorio.pas',
  UHLPosicaoEdit in 'UHLPosicaoEdit.pas' {frmHLPosicaoEdit},
  UHLValvulaEdit in 'UHLValvulaEdit.pas' {frmHLValvulaEdit},
  UHLComboImage in 'UHLComboImage.pas' {frmHLComboImage},
  UHLLibAtuacaoValvula in 'UHLLibAtuacaoValvula.pas',
  UHLRepImages in 'UHLRepImages.pas',
  UHLNovoProjeto in 'UHLNovoProjeto.pas' {frmNovoProjeto};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmRepImages, dmRepImages);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
