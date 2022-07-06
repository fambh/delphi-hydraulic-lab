unit UHLRepImages;

interface

uses
  SysUtils, Classes, ImgList, Controls;

type
  TdmRepImages = class(TDataModule)
    imlAtuacoesE: TImageList;
    imlAtuacoesD: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmRepImages: TdmRepImages;

implementation

{$R *.dfm}

end.
