unit UHLMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList, StdActns, ExtActns, ListActns, ActnList,
  ExtCtrls, ComCtrls, Buttons, StdCtrls, UHLLibProjeto, UHLLibAtuacaoValvula,
  UHLRepValvulas, UHLRepositorio, UHLValvulaEdit;

type
  TfrmMain = class(TForm)
    mnuMain: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    OpenWith1: TMenuItem;
    N3: TMenuItem;
    PrintSetup1: TMenuItem;
    Run1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    SelectAll1: TMenuItem;
    Undo1: TMenuItem;
    aclMain: TActionList;
    RichEditBold1: TRichEditBold;
    RichEditItalic1: TRichEditItalic;
    RichEditUnderline1: TRichEditUnderline;
    RichEditStrikeOut1: TRichEditStrikeOut;
    RichEditBullets1: TRichEditBullets;
    RichEditAlignLeft1: TRichEditAlignLeft;
    RichEditAlignRight1: TRichEditAlignRight;
    RichEditAlignCenter1: TRichEditAlignCenter;
    actFileExit: TFileExit;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    EditDelete1: TEditDelete;
    DeleteAction: TAction;
    AddAction: TAction;
    ClearAction: TAction;
    ActiveAction: TAction;
    SetIndexAction: TAction;
    actFileOpen: TFileOpen;
    ColorSelect1: TColorSelect;
    OpenPicture1: TOpenPicture;
    FontEdit1: TFontEdit;
    actFileSaveAs: TFileSaveAs;
    imlMain: TImageList;
    actFileSave: TAction;
    Componentes1: TMenuItem;
    pnlClient: TPanel;
    Panel2: TPanel;
    scbProjeto: TScrollBox;
    StatusBar1: TStatusBar;
    actCompRepositorio: TAction;
    RepositriodeVlvulas1: TMenuItem;
    N1: TMenuItem;
    pnlProjeto: TPanel;
    Panel6: TPanel;
    Shape2: TShape;
    Panel7: TPanel;
    chkGrid: TCheckBox;
    Shape3: TShape;
    Shape5: TShape;
    Panel10: TPanel;
    Shape6: TShape;
    Panel11: TPanel;
    BitBtn8: TBitBtn;
    Shape7: TShape;
    BitBtn10: TBitBtn;
    Bevel2: TBevel;
    pnlLeft: TPanel;
    Bevel1: TBevel;
    pnlCollapse: TPanel;
    pnlLeftContent: TPanel;
    btnET1: TSpeedButton;
    btnET2: TSpeedButton;
    btnET3: TSpeedButton;
    btnEC1: TSpeedButton;
    btnEC2: TSpeedButton;
    btnEC3: TSpeedButton;
    btnEC4: TSpeedButton;
    btnPS1: TSpeedButton;
    btnPS2: TSpeedButton;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    imgGrid: TImage;
    procedure FormCreate(Sender: TObject);
    procedure pnlCollapseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure actCompRepositorioExecute(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pnlProjetoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkGridClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnElementoClick(Sender: TObject);
    procedure Shape9DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure BitBtn8Click(Sender: TObject);
  private
    procedure CollapseLeftPanel;
    procedure ExpandLeftPanel;
    function GetButtonDown: TSpeedButton;
    procedure DrawGrid(ADraw: Boolean; ASize: Integer);
    procedure RaiseButtons;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  bLeftPanelCollapsed: Boolean;
  Projeto: THLProjeto;

implementation

uses UHLNovoProjeto;

{$R *.dfm}

function TfrmMain.GetButtonDown: TSpeedButton;
var i: Integer;
begin
  Result := nil;
  for i := 0 to Self.ComponentCount-1 do
    if Self.Components[i] is TControl then
      if (TControl(Self.Components[i]).Parent = pnlLeftContent) and (Self.Components[i] is TSpeedButton) then
        if TSpeedButton(Self.Components[i]).Down then
        begin
          Result := TSpeedButton(Self.Components[i]);
          Exit;
        end;
end;

procedure TfrmMain.RaiseButtons;
var i: Integer;
begin
  for i := 0 to Self.ComponentCount-1 do
    if Self.Components[i] is TControl then
      if (TControl(Self.Components[i]).Parent = pnlLeftContent) and (Self.Components[i] is TSpeedButton) then
        TSpeedButton(Self.Components[i]).Down := false;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ExpandLeftPanel;

  Projeto := THLProjeto.Create(pnlProjeto);

  CarregarAtuacoes(Atuacoes);

  Posicoes := THLPosicoes.Create;
  Posicoes.Carregar;

  Valvulas := THLValvulas.Create;
  Valvulas.Carregar(Atuacoes);
end;

procedure TfrmMain.CollapseLeftPanel;
begin
  pnlLeft.Width := pnlCollapse.Width;
  pnlCollapse.Caption := '>';
  bLeftPanelCollapsed := True;
end;

procedure TfrmMain.ExpandLeftPanel;
begin
  pnlLeft.Width := 166 + pnlCollapse.Width;
  pnlCollapse.Caption := '<';
  bLeftPanelCollapsed := False;
end;

procedure TfrmMain.pnlCollapseClick(Sender: TObject);
begin
  if bLeftPanelCollapsed
  then ExpandLeftPanel
  else CollapseLeftPanel;
end;


procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Projeto.Free;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var v: THLValvula;
begin
  v := Projeto.Valvulas.Add(Point(0, 0));
end;

procedure TfrmMain.actCompRepositorioExecute(Sender: TObject);
begin
  frmHLRepValvulas := TfrmHLRepValvulas.Create(nil);
  try
    frmHLRepValvulas.ShowModal;
  finally
    frmHLRepValvulas.Free;
    frmHLRepValvulas := nil;
  end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var v: THLValvula;
begin
  v := Projeto.Valvulas.Add(Point(0, 0));
  v.QtdVias := 2;
  TfrmHLValvulaEdit.Open(v);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FinalizarAtuacoes(Atuacoes);

  Posicoes.Free;
  Posicoes := nil;

  Valvulas.Free;
  Valvulas := nil;  
end;

procedure TfrmMain.pnlProjetoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  btn: TSpeedButton;
  valvula: THLValvula;
begin
  btn := GetButtonDown;

  if btn = nil then
    Exit;

  if btn.Tag <= 10 then
  begin
    valvula := Projeto.Valvulas.Add(Point(X-32, Y));
    valvula.Clone(Valvulas.FindById(btn.Tag));

    Projeto.ActiveAction := acSelect;
  end;

  RaiseButtons;
  Projeto.IsAboutToAdd := False;
end;

procedure TfrmMain.DrawGrid(ADraw: Boolean; ASize: Integer);
var i: Integer;
begin
  with imgGrid.Canvas do
  begin
    Pen.Color   := clWhite;
    Brush.Color := clWhite;

    Rectangle(0,0,2000,2000);

    if ADraw then
    begin
      Pen.Color := $00E0E0E0;

      for i := 1 to (5000 div ASize) do
      begin
        MoveTo(i*Projeto.GridSize, 0);
        LineTo(i*Projeto.GridSize, 5000);
      end;

      for i := 1 to (5000 div ASize) do
      begin
        MoveTo(0, i*Projeto.GridSize);
        LineTo(5000, i*Projeto.GridSize);
      end;
    end;
  end;
end;

procedure TfrmMain.chkGridClick(Sender: TObject);
begin
  DrawGrid(chkGrid.Checked, Projeto.GridSize);
  Projeto.SnapToGrid := chkGrid.Checked;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  DrawGrid(chkGrid.Checked, Projeto.GridSize);

  Screen.Cursors[crNoDrop] := Screen.Cursors[crDefault];

  { EXAMPLE 1 }
  btnEC2.Down := True;
  Projeto.IsAboutToAdd := True;
  pnlProjetoMouseDown(nil, mbLeft, [], 100, 100);

  btnEC4.Down := True;
  Projeto.IsAboutToAdd := True;
  pnlProjetoMouseDown(nil, mbLeft, [], 400, 200);
  { END - EXAMPLE 1 }  
end;

procedure TfrmMain.btnElementoClick(Sender: TObject);
begin
  Projeto.IsAboutToAdd := True;
end;

procedure TfrmMain.Shape9DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if (Source is TShape) and (TShape(Source).Tag = 2) then
    Accept := True;
end;

procedure TfrmMain.BitBtn8Click(Sender: TObject);
begin
  frmNovoProjeto := TfrmNovoProjeto.Create(nil);
  try
    frmNovoProjeto.ShowModal;
  finally
    frmNovoProjeto.Free;
    frmNovoProjeto := nil;
  end;
end;

end.
