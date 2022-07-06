unit UHLNovoProjeto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, Spin, ExtCtrls, Math;

type
  TfrmNovoProjeto = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    sedInput: TSpinEdit;
    Label2: TLabel;
    sedOutput: TSpinEdit;
    btnOk: TBitBtn;
    grid: TStringGrid;
    Panel3: TPanel;
    Label3: TLabel;
    mem: TMemo;
    procedure sedInputChange(Sender: TObject);
    procedure sedOutputChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
    procedure gridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    procedure UpdateGrid;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNovoProjeto: TfrmNovoProjeto;
  SelectedCell: TPoint;

implementation

{$R *.dfm}

procedure TfrmNovoProjeto.sedInputChange(Sender: TObject);
begin
  UpdateGrid;
end;

procedure TfrmNovoProjeto.sedOutputChange(Sender: TObject);
begin
  UpdateGrid;
end;

procedure TfrmNovoProjeto.UpdateGrid;
var
  i, j, qtdCol, qtdBits, iCol: Integer;
  EhVerdadeiro: Boolean;
begin
  qtdCol := sedInput.Value + sedOutput.Value;
  grid.ColCount := qtdCol;
  grid.RowCount := Trunc(Power(2, sedInput.Value)) + 1;

  for i := 0 to sedInput.Value-1 do
  begin
    grid.Cells[i,0] := 'Entrada ' + IntToStr(i+1);
  end;

  for i := 0 to sedOutput.Value-1 do
  begin
    grid.Cells[i+sedInput.Value,0] := 'Saída ' + IntToStr(i+1);

    for j := 1 to grid.RowCount do
    begin
      grid.Cells[i+sedInput.Value,j] := '';
    end;
  end;

  EhVerdadeiro := False;
  for i := sedInput.Value-1 downto 0 do
  begin
    iCol := (sedInput.Value-1)-i;
    qtdBits := Trunc(Power(2,i));
    for j := 1 to grid.RowCount-1 do
    begin
      if EhVerdadeiro
      then grid.Cells[iCol, j] := '1'
      else grid.Cells[iCol, j] := '0';

      if j mod QtdBits = 0 then
        EhVerdadeiro := not EhVerdadeiro;
    end;
  end;
end;

procedure TfrmNovoProjeto.FormShow(Sender: TObject);
begin
  UpdateGrid;
end;

procedure TfrmNovoProjeto.gridKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (grid.Row < grid.RowCount-1) then
  begin
    grid.Row := grid.Row + 1;
  end;

  if not ((Key in [#8, #10, #13]) or ((Key in ['0', '1']) and (Length(grid.Cells[SelectedCell.X, SelectedCell.Y]) = 0))) then
  begin
     Key := #0;
  end;
end;

procedure TfrmNovoProjeto.gridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  SelectedCell := Point(ACol, ARow);
end;

end.
