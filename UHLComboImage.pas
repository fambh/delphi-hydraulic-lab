unit UHLComboImage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, UHLLib;

type
  TfrmHLComboImage = class(TForm)
    scbCombo: TScrollBox;
    procedure FormShow(Sender: TObject);
    procedure ImageClick(Sender: TObject);
    procedure ShapeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Open(APosition: TPoint; AImages: THLComboImages; ARect: TRect; AMostraNulo: Boolean = True): Integer;
  end;

var
  frmHLComboImage: TfrmHLComboImage;
  Images: THLComboImages;
  ImageHeight: Integer;
  ImageWidth: Integer;
  RectImg: TRect;
  WindowPosition: TPoint;
  MostraNulo: Boolean;
  SelectedId: Integer = -1;

implementation

class function TfrmHLComboImage.Open(APosition: TPoint; AImages: THLComboImages; ARect: TRect; AMostraNulo: Boolean): Integer;
begin
  frmHLComboImage := TfrmHLComboImage.Create(nil);
  with frmHLComboImage do
  begin
    try
      Images         := AImages;
      ImageWidth     := ARect.Right - ARect.Left;
      ImageHeight    := ARect.Bottom - ARect.Top;
      RectImg        := ARect;
      WindowPosition := APosition;
      MostraNulo     := AMostraNulo;
      
      Result := -1;

      ShowModal;
      Result := SelectedId;
    finally
      frmHLComboImage.Free;
      frmHLComboImage := nil;
    end;
  end;
end;

{$R *.dfm}

procedure TfrmHLComboImage.FormShow(Sender: TObject);
var
  i: Integer;
  img: TImage;
  shp: TShape;
  qtdExibicao: Integer;
begin
  if MostraNulo
  then qtdExibicao := Length(Images) + 1
  else qtdExibicao := Length(Images);
  
  Self.ClientWidth := ImageWidth;
  scbCombo.VertScrollBar.Visible := False;

  if qtdExibicao > 8 then
  begin
    qtdExibicao := 8;
    Self.ClientWidth := ImageWidth + 19;
    scbCombo.VertScrollBar.Visible := True;
  end;

  Self.ClientHeight := ImageHeight*qtdExibicao+1;

  Self.Left := WindowPosition.X;
  Self.Top := WindowPosition.Y;

  for i := Length(Images)-1 downto 0 do
  begin
    img := TImage.Create(scbCombo);
    img.Parent := scbCombo;
    img.Height := ImageHeight;
    img.Align  := alTop;
    img.Canvas.CopyRect(Rect(0,0,ImageWidth,ImageHeight), Images[i].Bitmap.Canvas, RectImg);
    img.Tag := Images[i].Index;
    img.OnClick := ImageClick;
  end;

  if MostraNulo then
  begin
    shp := TShape.Create(scbCombo);
    shp.Parent := scbCombo;
    shp.Height := ImageHeight;
    shp.Align  := alTop;
    shp.Tag := -1;
    shp.Pen.Color := clWhite;
    shp.OnMouseDown := ShapeMouseDown;
  end;
end;

procedure TfrmHLComboImage.ImageClick(Sender: TObject);
begin
  SelectedId := TImage(Sender).Tag;
  Self.ModalResult := mrOk;
  Self.Close;
end;

procedure TfrmHLComboImage.ShapeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectedId := TShape(Sender).Tag;
  Self.ModalResult := mrOk;
  Self.Close;
end;

end.
