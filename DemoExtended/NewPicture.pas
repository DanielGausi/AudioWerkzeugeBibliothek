unit NewPicture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs;

type
  TNewPic = class(TForm)
    cbPicType: TComboBox;
    EdtDescription: TEdit;
    Image1: TImage;
    BtnSearch: TButton;
    BtnOK: TButton;
    BtnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure BtnSearchClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  NewPic: TNewPic;

implementation

{$R *.dfm}

procedure TNewPic.BtnSearchClick(Sender: TObject);
begin
    if OpenPictureDialog1.Execute then
    begin
        Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
        EdtDescription.Text := ExtractFilename(OpenPictureDialog1.FileName);
    end;
end;

end.
