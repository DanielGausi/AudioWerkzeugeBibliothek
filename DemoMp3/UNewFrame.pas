unit UNewFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, StdCtrls, ExtCtrls, ComCtrls, JPEG, AudioFiles.Declarations,
  AudioFiles.BaseTags, ID3v2Tags, ID3v2Frames, LanguageCodeList, Vcl.Mask;

type
  TFormNewFrame = class(TForm)
    pcFrameTypeSelection: TPageControl;
    tsText: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    tsURLs: TTabSheet;
    TabSheet5: TTabSheet;
    cbTextframe: TComboBox;
    Label1: TLabel;
    Ed_TextFrame: TLabeledEdit;
    Btn_Ok: TButton;
    BtnCancel: TButton;
    Label2: TLabel;
    cbLanguageComment: TComboBox;
    Label3: TLabel;
    EdtCommentDescription: TEdit;
    MemoComments: TMemo;
    Label4: TLabel;
    Ed_UserDefURLDescription: TEdit;
    EdUserDefURL: TLabeledEdit;
    Label6: TLabel;
    Label7: TLabel;
    cbURLFrame: TComboBox;
    ED_URLFrame: TLabeledEdit;
    ImgNewPic: TImage;
    Label8: TLabel;
    cbPictureType: TComboBox;
    Label9: TLabel;
    EdtPictureDescription: TEdit;
    BtnSelectPicture: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    TabSheet6: TTabSheet;
    tsPrivate: TTabSheet;
    cbLanguageLyrics: TComboBox;
    edtLyricDescription: TEdit;
    MemoLyrics: TMemo;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    lblURLWarningURLs: TLabel;
    lblURLWarningText: TLabel;
    lblPrivateWarning: TLabel;
    edtPrivateDescription: TLabeledEdit;
    Label5: TLabel;
    OpenDialog1: TOpenDialog;
    BtnSelectPrivateFile: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Ed_TextFrameChange(Sender: TObject);
    procedure EdtCommentDescriptionChange(Sender: TObject);
    procedure EdtLyricDescriptionChange(Sender: TObject);
    procedure Ed_UserDefURLDescriptionChange(Sender: TObject);
    procedure ED_URLFrameChange(Sender: TObject);
    procedure EdtPictureDescriptionChange(Sender: TObject);
    procedure BtnSelectPictureClick(Sender: TObject);
    procedure Btn_OkClick(Sender: TObject);
    procedure pcFrameTypeSelectionChange(Sender: TObject);
    procedure BtnSelectPrivateFileClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
    fNewPictureDataLoaded: Boolean;
    fPrivateFileChoosed: Boolean;

    fNewPictureData: TMemoryStream;
    fNewMimeType: AnsiString;

    allowedTextFrameList: TList;
    allowedURLFrameList: TList;
    fFrameType: Integer;
    fID3v2Tag: TID3v2Tag;
    procedure SetFrameType(const Value: Integer);
    procedure SetID3v2Tag(const Value: TID3v2Tag);

  public
    { Public-Deklarationen }
    property FrameType: Integer read fFrameType write SetFrameType;
    property ID3v2Tag: TID3v2Tag read fID3v2Tag write SetID3v2Tag;
  end;

var
  FormNewFrame: TFormNewFrame;

const
  PRIV_FRAME_DEMO: AnsiString = 'MP3FileUtilsDemo/RecursiveMP3File';

implementation

{$R *.dfm}

procedure TFormNewFrame.FormShow(Sender: TObject);
var
  i: Integer;
  dummyStream: TMemoryStream;
  DemoFrameExists: Boolean;
begin
    // textframes: get list of unused frames
    cbTextframe.Items.Clear;

    allowedTextFrameList.Clear;
    Id3v2Tag.GetAllowedTextFrames(allowedTextFrameList);
    for i := 0 to allowedTextFrameList.Count-1 do
        cbTextframe.Items.Add(
          ID3v2KnownFrames[ TFrameIDs(allowedTextFrameList[i])].Description
          + ' ('
          + ID3v2KnownFrames[ TFrameIDs(allowedTextFrameList[i])].IDs[
          TID3v2FrameVersions(Id3v2Tag.Version.Major)]+') ');

    if cbTextframe.Items.Count > 0 then
        cbTextframe.ItemIndex := 0;

    // URL frames: get list of unused frames
    cbURLFrame.Items.Clear;
    allowedURLFrameList.Clear;
    Id3v2Tag.GetAllowedURLFrames(allowedURLFrameList);
    for i := 0 to allowedURLFrameList.Count-1 do
        cbURLFrame.Items.Add(
          ID3v2KnownFrames[ TFrameIDs(allowedURLFrameList[i])].Description
          + ' ('
          + ID3v2KnownFrames[ TFrameIDs(allowedURLFrameList[i])].IDs[ TID3v2FrameVersions(Id3v2Tag.Version.Major)]+') ');

    if cbURLFrame.Items.Count > 0 then
        cbURLFrame.ItemIndex := 0;

    // clear input elemets
    ED_URLFrame.Text           := '';
    Ed_TextFrame.Text          := '';
    EdtCommentDescription.Text := '';
    MemoComments.Text          := '';
    EdtLyricDescription.Text   := '';
    MemoLyrics.Text            := '';
    Ed_UserDefURLDescription.Text := '';
    EdUserDefURL.Text          := '';

    fNewPictureDataLoaded := False;
    ImgNewPic.Picture.Bitmap.Assign(Nil);
    EdtPictureDescription.Text := '';

    fPrivateFileChoosed := False;

    tsURLs.Enabled := allowedURLFrameList.Count > 0;
    lblURLWarningURLs.Visible := allowedURLFrameList.Count = 0;

    tsText.Enabled := allowedTextFrameList.Count > 0;
    lblURLWarningText.Visible := allowedTextFrameList.Count = 0;

    dummyStream := TMemoryStream.Create;
    try
        DemoFrameExists := Id3v2Tag.GetPrivateFrame(PRIV_FRAME_DEMO, dummyStream);
        tsPrivate.Enabled := Not DemoFrameExists;
        lblPrivateWarning.Visible := DemoFrameExists;
    finally
        dummyStream.Free;
    end;

    Btn_Ok.Enabled := False;
end;

procedure TFormNewFrame.pcFrameTypeSelectionChange(Sender: TObject);
begin
    Btn_Ok.Enabled := False;
end;

procedure TFormNewFrame.SetFrameType(const Value: Integer);
begin
  if (Value >= 0) and (Value <= 6) then begin
    fFrameType := Value;
    pcFrameTypeSelection.ActivePageIndex := fFrameType;
  end else begin
    fFrameType := 0;
    pcFrameTypeSelection.ActivePageIndex := 0;
  end;
end;

procedure TFormNewFrame.SetID3v2Tag(const Value: TID3v2Tag);
begin
  fID3v2Tag := Value;
end;

procedure TFormNewFrame.FormCreate(Sender: TObject);
var
  i: TPictureType;
begin
  cbLanguageLyrics.Items.AddStrings(LanguageNames);
  cbLanguageLyrics.ItemIndex := LanguageCodes.IndexOf('eng');
  cbLanguageComment.Items.AddStrings(LanguageNames);
  cbLanguageComment.ItemIndex := LanguageCodes.IndexOf('eng');

  for i := Low(TPictureType) to High(TPictureType) do
    cbPicturetype.Items.Add(cPictureTypes[i]);
  cbPictureType.ItemIndex := 0;

  edtPrivateDescription.Text := PRIV_FRAME_DEMO;
  fNewPictureData := TMemoryStream.Create;
  fNewMimeType := '';
  allowedTextFrameList := TList.Create;
  allowedURLFrameList := TList.Create;
end;

procedure TFormNewFrame.FormDestroy(Sender: TObject);
begin
  allowedTextFrameList.Free;
  allowedURLFrameList.Free;
  fNewPictureData.Free;
end;

procedure TFormNewFrame.Ed_TextFrameChange(Sender: TObject);
begin
    Btn_Ok.Enabled := Ed_TextFrame.Text <> '';
end;

procedure TFormNewFrame.EdtCommentDescriptionChange(Sender: TObject);
begin
  Btn_Ok.Enabled := (MemoComments.Text <> '')
      and ID3v2Tag.ValidNewCommentFrame(AnsiString(cbLanguageComment.Text), EdtCommentDescription.Text);
end;

procedure TFormNewFrame.EdtLyricDescriptionChange(Sender: TObject);
begin
  Btn_Ok.Enabled := (MemoLyrics.Text <> '')
      and ID3v2Tag.ValidNewLyricFrame(AnsiString(cbLanguageLyrics.Text), EdtLyricDescription.Text)
end;

procedure TFormNewFrame.Ed_UserDefURLDescriptionChange(Sender: TObject);
begin
  Btn_Ok.Enabled := (EdUserDefURL.Text <> '')
      and ID3v2Tag.ValidNewUserDefUrlFrame(Ed_UserDefURLDescription.Text);
end;

procedure TFormNewFrame.ED_URLFrameChange(Sender: TObject);
begin
  Btn_Ok.Enabled := ED_URLFrame.Text <> ''
end;

procedure TFormNewFrame.EdtPictureDescriptionChange(Sender: TObject);
begin
  Btn_Ok.Enabled := ID3v2Tag.ValidNewPictureFrame(EdtPictureDescription.Text)
      and fNewPictureDataLoaded;
end;

procedure TFormNewFrame.BtnSelectPictureClick(Sender: TObject);
begin

  if OpenPictureDialog1.Execute then begin
    ImgNewPic.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    if SameText(ExtractFileExt(OpenPictureDialog1.FileName), '.png') then
      fNewMimeType := AWB_MimePNG
    else
      fNewMimeType := AWB_MimeJPEG;

    fNewPictureData.Clear;
    fNewPictureData.LoadFromFile(OpenPictureDialog1.FileName);
    fNewPictureDataLoaded := True;
  end;
  Btn_Ok.Enabled := ID3v2Tag.ValidNewPictureFrame(EdtPictureDescription.Text)
                    and fNewPictureDataLoaded;
end;

procedure TFormNewFrame.BtnSelectPrivateFileClick(Sender: TObject);
begin
    if OpenDialog1.Execute then
    begin
        fPrivateFileChoosed := True;
        Btn_Ok.Enabled := True;
    end;
end;

procedure TFormNewFrame.Btn_OkClick(Sender: TObject);
var newFrame: TID3v2Frame;
    PicStream, DataStream: TMemoryStream;
begin
    case pcFrameTypeSelection.TabIndex of
        0: begin  //  Text-Frames
            NewFrame := Id3v2Tag.AddFrame(TFrameIDs(allowedTextFrameList.Items[cbTextframe.ItemIndex]));
            NewFrame.SetText(Ed_TextFrame.Text);
        end;
        1: begin  // Comments
            NewFrame := Id3v2Tag.AddFrame(IDv2_COMMENT);
            NewFrame.SetCommentsLyrics(AnsiString(cbLanguageComment.Text), EdtCommentDescription.Text, MemoComments.Text);
        end;
        2: begin  //  Lyrics
            NewFrame := Id3v2Tag.AddFrame(IDv2_LYRICS);
            NewFrame.SetCommentsLyrics(AnsiString(cbLanguageLyrics.Text), EdtLyricDescription.Text, MemoLyrics.Text);
        end;
        3: begin  //  URLs
            NewFrame := Id3v2Tag.AddFrame(TFrameIDs(allowedURLFrameList.Items[cbURLFrame.ItemIndex]));
            NewFrame.SetURL(AnsiString(ED_URLFrame.Text));
        end;
        4: begin  //  User-defined URLs
            NewFrame := Id3v2Tag.AddFrame(IDv2_USERDEFINEDURL);
            NewFrame.SetUserdefinedURL(Ed_UserDefURLDescription.Text, AnsiString(EdUserDefURL.Text));
        end;

        5: begin  //  Cover art
            if fNewPictureDataLoaded then
            begin
                NewFrame := Id3v2Tag.AddFrame(IDv2_PICTURE);
                PicStream := TMemorystream.Create;
                try
                    PicStream.LoadFromFile(OpenPictureDialog1.FileName);
                    NewFrame.SetPicture(PicStream, AWB_MimeJPEG, TPictureType(cbPictureType.ItemIndex), EdtPictureDescription.Text);
                finally
                    PicStream.Free;
                end;
            end else
                MessageDlg('Please select a cover art first', mtInformation, [mbOK], 0)
        end;
        6: begin  //  Private Frame
            if fPrivateFileChoosed then
            begin
                NewFrame := Id3v2Tag.AddFrame(IDv2_PRIVATE);
                DataStream := TMemorystream.Create;
                try
                    DataStream.LoadFromFile(OpenDialog1.FileName);
                    NewFrame.SetPrivateFrame(PRIV_FRAME_DEMO, DataStream);
                finally
                    DataStream.Free;
                end;
            end else
                MessageDlg('Please select a file first', mtInformation, [mbOK], 0)
        end;
    end;
end;

end.
