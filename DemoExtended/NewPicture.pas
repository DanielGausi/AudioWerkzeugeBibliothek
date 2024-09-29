unit NewPicture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs, AudioFiles.Declarations;

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
    function GetFilename: String;
    function GetDescription: String;
    function GetPicType: TPictureType;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    property Filename: String read GetFilename;
    property Description: String read GetDescription;
    property PicType: TPictureType read GetPicType;
  end;

var
  NewPic: TNewPic;

implementation

{$R *.dfm}

function TNewPic.GetFilename: String;
begin
  result := OpenPictureDialog1.FileName;
end;

function TNewPic.GetDescription: String;
begin
  result := EdtDescription.Text;
end;

function TNewPic.GetPicType: TPictureType;
begin
  result := TPictureType(cbPicType.ItemIndex);
end;

procedure TNewPic.BtnSearchClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    EdtDescription.Text := ExtractFilename(OpenPictureDialog1.FileName);
  end;
end;

end.
