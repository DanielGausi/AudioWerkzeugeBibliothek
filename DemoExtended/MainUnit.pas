unit MainUnit;

interface

{$DEFINE USE_PNG}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Jpeg, ContNrs, AudioFiles.Base, AudioFiles.BaseTags,
  AudioFiles.Factory,  AudioFiles.Declarations, BaseApeFiles, ApeTagItem, ID3v2Frames,
  ID3v1Tags, ID3v2Tags, Apev2Tags, VorbisComments,
  Mp3Files, FlacFiles, BaseVorbisFiles, OggVorbisFiles, MonkeyFiles, WavPackFiles,
  MusePackFiles, OptimFrogFiles, TrueAudioFiles, WavFiles,
  M4aAtoms, M4AFiles, FileCtrl, ComCtrls
  {$IFDEF USE_PNG}, PNGImage, Vcl.Menus{$ENDIF} ;

type
  TMainFormAWB = class(TForm)
    GroupBox1: TGroupBox;
    EdtArtist: TEdit;
    EdtTitle: TEdit;
    EdtAlbum: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    Image1: TImage;
    cbPictures: TComboBox;
    BtnNewPicture: TButton;
    BtnDeletePicture: TButton;
    EdtGenre: TEdit;
    Label4: TLabel;
    EdtTrack: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    EdtYear: TEdit;
    GroupBox3: TGroupBox;
    GroupBox7: TGroupBox;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    GrpBoxLyrics: TGroupBox;
    MemoLyrics: TMemo;
    BtnRemoveTag: TButton;
    BtnSave: TButton;
    GroupBox4: TGroupBox;
    LblAudioType: TLabel;
    LblBitrate: TLabel;
    LblChannels: TLabel;
    LblDuration: TLabel;
    LblFileSize: TLabel;
    lvMetaTags: TListView;
    Label7: TLabel;
    grpTagSelection: TGroupBox;
    cb_Existing: TCheckBox;
    cb_ID3v1: TCheckBox;
    cb_ID3v2: TCheckBox;
    cb_Ape: TCheckBox;
    PopupMenu1: TPopupMenu;
    pmEdit: TMenuItem;
    pmNew: TMenuItem;
    MemoSpecific: TMemo;
    procedure FormDestroy(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure cbPicturesChange(Sender: TObject);
    procedure BtnNewPictureClick(Sender: TObject);
    procedure BtnDeletePictureClick(Sender: TObject);
    procedure BtnRemoveTagClick(Sender: TObject);
    procedure FileListBox1Change(Sender: TObject);
    procedure lvMetaTagsCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure pmNewClick(Sender: TObject);
    procedure pmEditClick(Sender: TObject);
  private
    { Private-Deklarationen }
    AudioFile: TBaseAudioFile;

    function StreamToBitmap(aStream: TStream; aBitmap: TBitmap): Boolean;
    procedure RefreshImageList;

    procedure ApplyUpdateSettings;

    function AllowEdit(TagItem: TTagItem): Boolean;
    procedure AddTagItem(TagItem: TTagItem; Tag, Key, Description, Value: String);
    procedure RefillTagItems;

  public
    { Public-Deklarationen }
  end;

var
  MainFormAWB: TMainFormAWB;

implementation

uses NewPicture, FNewTagItem;

{$R *.dfm}

procedure TMainFormAWB.FormDestroy(Sender: TObject);
begin
  if assigned(AudioFile) then
    AudioFile.Free;
end;

function TMainFormAWB.AllowEdit(TagItem: TTagItem): Boolean;
begin
  result := TagItem.TagContentType = tctText;
end;

procedure TMainFormAWB.lvMetaTagsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if not AllowEdit(TTagItem(Item.Data)) then
    Sender.Canvas.Font.Color := clGray;
end;

procedure TMainFormAWB.pmEditClick(Sender: TObject);
var
  newValue: String;
begin
  if not assigned(AudioFile) then
    exit;
  if not assigned(lvMetaTags.Selected) then
    exit;
  if not AllowEdit(TTagItem(lvMetaTags.Selected.Data)) then
    exit;

  newValue := TTagItem(lvMetaTags.Selected.Data).GetText(tmReasonable);

  if InputQuery('Edit TagItem',
      Format('New value for "%s (%s)"', [TTagItem(lvMetaTags.Selected.Data).ReadableKey, TTagItem(lvMetaTags.Selected.Data).Key]),
      newValue)
  then begin
    if newValue = '' then
      AudioFile.DeleteTagItem(TTagItem(lvMetaTags.Selected.Data))
    else
      TTagItem(lvMetaTags.Selected.Data).SetText(newValue, tmReasonable);
    RefillTagItems;
  end;
end;

procedure TMainFormAWB.pmNewClick(Sender: TObject);
begin
  if not assigned(AudioFile) then
    exit;
  FormNewTagItem.AvailableTagItems := AudioFile.GetUnusedTextTags;
  if FormNewTagItem.ShowModal = mrOK then begin
    AudioFile.AddTextTagItem(FormNewTagItem.SelectedTagItemInfo.Key, FormNewTagItem.Value);
    RefillTagItems;
  end;
end;

procedure TMainFormAWB.FileListBox1Change(Sender: TObject);
var EnableTagSelection: Boolean;
begin
    if assigned(AudioFile) then
      AudioFile.Free;

    AudioFile := AudioFileFactory.CreateAudioFile(FileListBox1.FileName);

    if not assigned(AudioFile) then
      exit;

    if AudioFile.ReadFromFile(FileListBox1.FileName) <> FileErr_None then
      Showmessage(AudioFile.LastExceptionMessage);

    MemoSpecific.Clear;
    MemoLyrics.Clear;

    EdtArtist.Text := AudioFile.Artist;
    EdtTitle.Text  := AudioFile.Title;
    EdtAlbum.Text  := AudioFile.Album;
    EdtGenre.Text  := AudioFile.Genre;
    EdtTrack.Text  := AudioFile.Track;
    EdtYear.Text   := AudioFile.Year;
    MemoLyrics.Text := AudioFile.Lyrics;

    LblAudioType.Caption  := AudioFile.FileTypeDescription;
    LblFileSize.Caption   := Format('Filesize: %d Bytes', [AudioFile.FileSize]);
    LblDuration.Caption   := Format('Duration: %d seconds', [AudioFile.Duration]);
    LblBitrate.Caption    := Format('Bitrate: %d kbit/s', [AudioFile.Bitrate div 1000]);
    LblChannels.Caption   := Format('Channels: %d, %d Hz', [AudioFile.Channels, AudioFile.Samplerate]);

    RefillTagItems;
    RefreshImageList;

    EnableTagSelection := false;
    case AudioFile.FileType of
        at_Invalid: begin
            LblAudioType.Caption := 'Invalid Audiofile';
            LblFileSize.Caption  := 'Filesize: N/A';
            LblDuration.Caption  := 'Duration: N/A';
            LblBitrate.Caption   := 'Bitrate: N/A';
            LblChannels.Caption  := 'Channels: N/A';
        end;
        at_Mp3: begin
            MemoSpecific.Lines.Add(Format('ID3v1: %d Bytes', [TMP3File(AudioFile).ID3v1TagSize]));
            MemoSpecific.Lines.Add(Format('ID3v2: %d Bytes', [TMP3File(AudioFile).ID3v2TagSize]));
            MemoSpecific.Lines.Add(Format('Apev2: %d Bytes', [TMP3File(AudioFile).ApeTagSize]));
            EnableTagSelection := True;
        end;
        at_Ogg, at_Opus: ;
        at_Flac: ;
        at_M4a: ;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: begin
            MemoSpecific.Lines.Add(Format('ID3v1: %d Bytes', [TBaseApeFile(AudioFile).ID3v1TagSize]));
            MemoSpecific.Lines.Add(Format('ID3v2: %d Bytes', [TBaseApeFile(AudioFile).ID3v2TagSize]));
            MemoSpecific.Lines.Add(Format('ApeV2: %d Bytes', [TBaseApeFile(AudioFile).Apev2TagSize]));
            EnableTagSelection := True;
        end;

    end;

    case AudioFile.FileType of
        at_Monkey  : begin
            MemoSpecific.Lines.Add(Format('Version: %s', [TMonkeyFile(AudioFile).VersionStr]));
            MemoSpecific.Lines.Add(Format('Compression: %s', [TMonkeyFile(AudioFile).CompressionModeStr]));
            MemoSpecific.Lines.Add(Format('Bits/Sample: %d',[TMonkeyFile(AudioFile).Bits]));
        end;
        at_WavPack : begin
            MemoSpecific.Lines.Add(Format('Enoder: %s', [TWavPackFile(AudioFile).Encoder]));
            MemoSpecific.Lines.Add(Format('Channelmode: %s', [TWavPackFile(AudioFile).ChannelMode]));
            MemoSpecific.Lines.Add(Format('Bits/Sample: %d',[TWavPackFile(AudioFile).Bits]));
        end;
        at_MusePack: begin
            MemoSpecific.Lines.Add(Format('Version: %s', [TMusePackFile(AudioFile).VersionString]));
            MemoSpecific.Lines.Add(Format('Channelmode: %s', [TMusePackFile(AudioFile).ChannelMode]));
        end;
        at_OptimFrog: begin
            MemoSpecific.Lines.Add(Format('Version: %s', [TOptimFrogFile(AudioFile).Version]));
            MemoSpecific.Lines.Add(Format('Compression: %s', [TOptimFrogFile(AudioFile).Compression]));
            MemoSpecific.Lines.Add(Format('Bits/Sample: %d', [TOptimFrogFile(AudioFile).Bits]));
        end;
        at_TrueAudio: begin
            MemoSpecific.Lines.Add(Format('AudioFormat: %d', [TTrueAudioFile(AudioFile).AudioFormat]));
            MemoSpecific.Lines.Add(Format('Bits/Sample: %d', [TTrueAudioFile(AudioFile).Bits]));
        end;

        at_Wav: begin
          //LblAudioType.Caption  := AudioFile.FileTypeDescription + ' (' + TWavFile(AudioFile).WaveCodec + ')';
          MemoSpecific.Lines.Add(Format('Codec: %s', [TWavFile(AudioFile).WaveCodec]));
        end;
    end;

    grpTagSelection.Enabled := EnableTagSelection;
    cb_Existing.Enabled := EnableTagSelection;
    cb_ID3v1.Enabled := EnableTagSelection;
    cb_ID3v2.Enabled := EnableTagSelection;
    cb_Ape.Enabled := EnableTagSelection;
end;


procedure TMainFormAWB.AddTagItem(TagItem: TTagItem; Tag, Key, Description, Value: String);
var
  newListItem: TListItem;
begin
  newListItem := lvMetaTags.Items.Add;
  newListItem.Data := TagItem;
  newListItem.Caption := Tag;
  newListItem.SubItems.Add(Key);
  newListItem.SubItems.Add(Description);
  newListItem.SubItems.Add(Value);
end;


procedure TMainFormAWB.RefillTagItems;
var
  i: Integer;
  TagItems: TTagItemList;
begin
  lvMetaTags.Clear;
  TagItems := TTagItemList.Create;
  try
    AudioFile.GetTagList(TagItems, [tctAll]);
    for i := 0 to TagItems.Count - 1 do
      AddTagItem(TagItems[i], cTagTypes[TagItems[i].TagType], TagItems[i].Key, TagItems[i].ReadableKey, TagItems[i].GetText(tmForced));
  finally
    TagItems.Free;
  end;
end;

procedure TMainFormAWB.RefreshImageList;
var i: Integer;
    PicType: TPictureType;
    Description: UnicodeString;
    stream: TMemoryStream;
    Mime: AnsiString;
    picList: TTagItemList;
    ImageAssigned: Boolean;
begin

  ImageAssigned := False;
  cbPictures.Items.Clear;

  picList := TTagItemList.Create;
  try
    AudioFile.GetTagList(picList, [tctPicture]);
    if picList.Count > 0 then begin

  stream := TMemoryStream.Create;
  try
    for i := 0 to picList.Count - 1 do begin
      Stream.Clear;
      if picList[i].GetPicture(stream, Mime, PicType, Description) then begin
        cbPictures.Items.AddObject(cPictureTypes[PicType], picList[i]);
        if not ImageAssigned then begin
          ImageAssigned := True;
          cbPictures.ItemIndex := 0;
          Stream.Position := 0;
          Image1.Picture.LoadFromStream(Stream);
          //StreamToBitmap(stream, Image1.Picture.Bitmap)
        end;
      end;
    end;
  finally
    stream.Free;
  end;
    end;
  finally
    picList.Free;
  end;

  if not ImageAssigned then
    Image1.Picture.Assign(Nil);
end;

procedure TMainFormAWB.BtnNewPictureClick(Sender: TObject);
var fs: TFileStream;
  aMimeType: AnsiString;
begin
    if (NewPic.ShowModal = mrOK) and AudioFileExists(NewPic.OpenPictureDialog1.FileName) then
    begin
        if SameText(ExtractFileExt(NewPic.FileName), '.jpg')
            or SameText(ExtractFileExt(NewPic.FileName), '.jpeg')
        then
          aMimeType := AWB_MimeJpeg
        else
          if SameText(ExtractFileExt(NewPic.FileName), '.png') then
            aMimeType := AWB_MimePNG
          else begin
            aMimeType := '';
            ShowMessage('Image type not supported. Operation cancelled');
            exit;
          end;

        try
          fs := TFileStream.Create(NewPic.FileName, fmOpenRead or fmShareDenyWrite);
          try
            AudioFile.SetPicture(fs, aMimeType, NewPic.PicType, NewPic.Description);
            RefreshImageList;
          finally
              fs.Free;
          end;
        except
          // nothing
        end;
    end;
end;

procedure TMainFormAWB.ApplyUpdateSettings;
var mp3File: TMp3File;
    apeFile: TBaseApeFile;
begin
    case AudioFile.FileType of

        at_Mp3: begin
            mp3File := TMp3File(AudioFile);
            mp3File.TagsToBeWritten := [];
            if cb_Existing.Checked then mp3File.TagsToBeWritten := mp3File.TagsToBeWritten + [mt_Existing];
            if cb_ID3v1.Checked    then mp3File.TagsToBeWritten := mp3File.TagsToBeWritten + [mt_ID3v1];
            if cb_ID3v2.Checked    then mp3File.TagsToBeWritten := mp3File.TagsToBeWritten + [mt_ID3v2];
            if cb_Ape.Checked      then mp3File.TagsToBeWritten := mp3File.TagsToBeWritten + [mt_Ape];

            mp3File.TagsToBeDeleted := mp3File.TagsToBeWritten;
        end;

        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: begin
            apeFile := TBaseApeFile(AudioFile);
            apeFile.TagsToBeWritten := [];
            if cb_Existing.Checked then apeFile.TagsToBeWritten := apeFile.TagsToBeWritten + [mt_Existing];
            if cb_ID3v1.Checked    then apeFile.TagsToBeWritten := apeFile.TagsToBeWritten + [mt_ID3v1];
            if cb_ID3v2.Checked    then apeFile.TagsToBeWritten := apeFile.TagsToBeWritten + [mt_ID3v2];
            if cb_Ape.Checked      then apeFile.TagsToBeWritten := apeFile.TagsToBeWritten + [mt_Ape];

            apeFile.TagsToBeDeleted := apeFile.TagsToBeWritten;
        end;
    else
      // nothing to do;
    end;
end;

procedure TMainFormAWB.BtnRemoveTagClick(Sender: TObject);
begin
    ApplyUpdateSettings;
    AudioFile.RemoveFromFile(AudioFile.Filename);
end;

procedure TMainFormAWB.BtnDeletePictureClick(Sender: TObject);
begin
  AudioFile.DeleteTagItem(TTagItem(cbPictures.Items.Objects[cbPictures.ItemIndex]));
  RefreshImageList;
  RefillTagItems;
end;

procedure TMainFormAWB.BtnSaveClick(Sender: TObject);
begin
    ApplyUpdateSettings;
    // Set basic data
    AudioFile.Artist := EdtArtist.Text ;
    AudioFile.Title  := EdtTitle.Text  ;
    AudioFile.Album  := EdtAlbum.Text  ;
    AudioFile.Genre  := EdtGenre.Text  ;
    AudioFile.Track  := EdtTrack.Text  ;
    AudioFile.Year   := EdtYear.Text   ;
    // Set Lyrics
    AudioFile.Lyrics := Trim(MemoLyrics.Text);
    AudioFile.UpdateFile;
end;

procedure TMainFormAWB.cbPicturesChange(Sender: TObject);
var
  stream: TMemoryStream;
  Mime: AnsiString;
  PicType: TPictureType;
  description: UnicodeString;
begin
  stream := TMemoryStream.Create;
  try
    if TTagItem(cbPictures.Items.Objects[cbPictures.ItemIndex]).GetPicture(stream, Mime, PicType, Description) then begin
      //StreamToBitmap(stream, Image1.Picture.Bitmap)
      Stream.Position := 0;
      Image1.Picture.LoadFromStream(Stream);
    end
    else
      Image1.Picture.Assign(Nil);
  finally
    stream.Free;
  end;
end;

function TMainFormAWB.StreamToBitmap(aStream: TStream; aBitmap: TBitmap): Boolean;
var jp: TJPEGImage;
    {$IFDEF USE_PNG}png: TPNGImage; {$ENDIF}
    LoadingFailed: Boolean;
begin
    aStream.Position := 0;

    LoadingFailed := False;
    // try it with JPG
    jp := TJPEGImage.Create;
    try
        try
            aStream.Position := 0;
            jp.LoadFromStream(aStream);
            jp.DIBNeeded;
            aBitmap.Assign(jp);
        except
            LoadingFailed := True;
        end;
    finally
        jp.Free;
    end;

    {$IFDEF USE_PNG} 
    if LoadingFailed then
    begin
        LoadingFailed := False;
        // try it with PNG
        png := TPNGImage.Create;
        try
            try
                aStream.Position := 0;
                png.LoadFromStream(aStream);
                aBitmap.Assign(png);
            except
                LoadingFailed := True;
            end;
        finally
            png.Free;
        end;
    end;
    {$ENDIF}

    result := NOT LoadingFailed;
end;

end.
