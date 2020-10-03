unit MainUnit;

interface

{$DEFINE USE_PNG}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Jpeg, ContNrs, AudioFiles.Base,
  AudioFiles.Factory,  AudioFiles.Declarations, BaseApeFiles, ApeTagItem, ID3v2Frames,
  ID3v1Tags, ID3v2Tags, Apev2Tags,
  Mp3Files, FlacFiles, OggVorbisFiles, MonkeyFiles, WavPackFiles, MusePackFiles,
  OptimFrogFiles, TrueAudioFiles, M4aAtoms, M4AFiles, FileCtrl
  {$IFDEF USE_PNG}, PNGImage, Vcl.ComCtrls{$ENDIF} ;

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
    MemoSpecific: TMemo;
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
    procedure FormDestroy(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure cbPicturesChange(Sender: TObject);
    procedure BtnNewPictureClick(Sender: TObject);
    procedure BtnDeletePictureClick(Sender: TObject);
    procedure BtnRemoveTagClick(Sender: TObject);
    procedure FileListBox1Change(Sender: TObject);
  private
    { Private-Deklarationen }
    AudioFile: TBaseAudioFile;

    FlacPictureFrames: TObjectList;
    ID3v2Frames: TObjectList;
    ID3v2PictureFrames: TObjectList;

    procedure LoadImage(aKey: AnsiString);
    function StreamToBitmap(aStream: TStream; aBitmap: TBitmap): Boolean;
    procedure RefreshImageList;

    procedure ApplyUpdateSettings;

    procedure AddTagItem(Tag, Key, Value: String);
    procedure RefillTagDetailsID3v1(aTag: TID3v1Tag);
    procedure RefillTagDetailsID3v2(aTag: TID3v2Tag);
    procedure RefillTagDetailsApe(aTag: TApeTag);

    procedure RefillTagDetailsMP3;
    procedure RefillTagDetailsOgg;
    procedure RefillTagDetailsFlac;
    procedure RefillTagDetailsM4A;
    procedure RefillTagDetailsBaseApe;


    procedure RefillTagDetailsListView;


  public
    { Public-Deklarationen }
  end;

var
  MainFormAWB: TMainFormAWB;

implementation

uses NewPicture;

{$R *.dfm}


procedure TMainFormAWB.FormDestroy(Sender: TObject);
begin
    if assigned(AudioFile) then
        AudioFile.Free;
    if assigned(FlacPictureFrames) then
        FlacPictureFrames.Free;
    if assigned(ID3v2Frames) then
        ID3v2Frames.Free;
    if assigned(ID3v2PictureFrames) then
        ID3v2PictureFrames.Free;
end;


procedure TMainFormAWB.FileListBox1Change(Sender: TObject);
var EnableTagSelection: Boolean;
begin
    if assigned(AudioFile) then
        AudioFile.Free;

    AudioFile := AudioFileFactory.CreateAudioFile(FileListBox1.FileName);

    if not assigned(AudioFile) then
      exit;

    //if AudioFile.FileType = at_Mp3 then
    //   TMp3File(AudioFile).TagScanMode := id3_read_complete;

    AudioFile.ReadFromFile(FileListBox1.FileName);

    MemoSpecific.Clear;
    MemoLyrics.Clear;

    EdtArtist.Text := AudioFile.Artist;
    EdtTitle.Text  := AudioFile.Title;
    EdtAlbum.Text  := AudioFile.Album;
    EdtGenre.Text  := AudioFile.Genre;
    EdtTrack.Text  := AudioFile.Track;
    EdtYear.Text   := AudioFile.Year;

    LblAudioType.Caption  := AudioFile.FileTypeDescription;
    LblFileSize.Caption   := Format('Filesize: %d Bytes', [AudioFile.FileSize]);
    LblDuration.Caption   := Format('Duration: %d seconds', [AudioFile.Duration]);
    LblBitrate.Caption    := Format('Bitrate: %d kbit/s', [AudioFile.Bitrate div 1000]);
    LblChannels.Caption   := Format('Channels: %d, %d Hz', [AudioFile.Channels, AudioFile.Samplerate]);

    RefillTagDetailsListView;

    EnableTagSelection := false;
    case AudioFile.FileType of
          at_Invalid: begin
              ShowMessage('Invalid AudioFile');
              LblAudioType.Caption := 'Invalid Audiofile';
              LblFileSize.Caption  := 'Filesize: N/A';
              LblDuration.Caption  := 'Duration: N/A';
              LblBitrate.Caption   := 'Bitrate: N/A';
              LblChannels.Caption  := 'Channels: N/A';
          end;
          at_Mp3: begin
              MemoLyrics.Text := TMP3File(AudioFile).ID3v2Tag.Lyrics;
              MemoSpecific.Lines.Add(Format('ID3v1: %d Bytes', [TMP3File(AudioFile).ID3v1TagSize]));
              MemoSpecific.Lines.Add(Format('ID3v2: %d Bytes', [TMP3File(AudioFile).ID3v2TagSize]));
              MemoSpecific.Lines.Add(Format('Apev2: %d Bytes', [TMP3File(AudioFile).ApeTagSize]));
              EnableTagSelection := True;
          end;
          at_Ogg: begin
              MemoLyrics.Text := TOggVorbisFile(AudioFile).GetPropertyByFieldname('UNSYNCEDLYRICS');
          end;
          at_Flac: begin
              MemoLyrics.Text := TFlacFile(AudioFile).GetPropertyByFieldname('UNSYNCEDLYRICS');
          end;
          at_M4a: begin
              MemoLyrics.Text := TM4AFile(AudioFile).Lyrics;
          end;
          at_Monkey,
          at_WavPack,
          at_MusePack,
          at_OptimFrog,
          at_TrueAudio: begin
              MemoLyrics.Text := TBaseApeFile(AudioFile).ApeTag.GetValueByKey('UNSYNCEDLYRICS');

              MemoSpecific.Lines.Add(Format('ID3v1: %d Bytes', [TBaseApeFile(AudioFile).ID3v1TagSize]));
              MemoSpecific.Lines.Add(Format('ID3v2: %d Bytes', [TBaseApeFile(AudioFile).ID3v2TagSize]));
              MemoSpecific.Lines.Add(Format('ApeV2: %d Bytes', [TBaseApeFile(AudioFile).Apev2TagSize]));
              EnableTagSelection := True;
          end;
    end;

    case AudioFile.FileType of
          at_Monkey  : begin
              MemoSpecific.Lines.Add(Format('Version:%s', [TMonkeyFile(AudioFile).VersionStr]));
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
    end;

    RefreshImageList;

    grpTagSelection.Enabled := EnableTagSelection;
    cb_Existing.Enabled := EnableTagSelection;
    cb_ID3v1.Enabled := EnableTagSelection;
    cb_ID3v2.Enabled := EnableTagSelection;
    cb_Ape.Enabled := EnableTagSelection;
end;


procedure TMainFormAWB.AddTagItem(Tag, Key, Value: String);
var newListItem: TListItem;
begin
    newListItem := lvMetaTags.Items.Add;
    newListItem.Caption := Tag;
    newListItem.SubItems.Add(Key);
    newListItem.SubItems.Add(Value);
end;

procedure TMainFormAWB.RefillTagDetailsID3v1(aTag: TID3v1Tag);
begin
    AddTagItem('ID3v1', 'Artist', aTag.Artist);
    AddTagItem('ID3v1', 'Title', aTag.Title);
    AddTagItem('ID3v1', 'Album', aTag.Album);
    AddTagItem('ID3v1', 'Year', UnicodeString(aTag.Year));
    AddTagItem('ID3v1', 'Genre', aTag.Genre);
    AddTagItem('ID3v1', 'Comment', aTag.Comment);
    if aTag.Version = 1 then
        AddTagItem('ID3v1', 'Track', aTag.Track);
end;
procedure TMainFormAWB.RefillTagDetailsID3v2(aTag: TID3v2Tag);
var i: Integer;
    iFrame: TID3v2Frame;
begin
    aTag.GetAllTextFrames(ID3v2Frames);
    for i := 0 to ID3v2Frames.Count - 1 do
    begin
        iFrame := TID3v2Frame(ID3v2Frames[i]);
        AddTagItem('ID3v2', iFrame.FrameTypeDescription, iFrame.GetText);
    end;
end;
procedure TMainFormAWB.RefillTagDetailsApe(aTag: TApeTag);
var ApeKeys: TStrings;
    i: Integer;
begin
    ApeKeys := tStringList.Create;
    try
        aTag.GetAllTextFrames(ApeKeys);
        for i := 0 to ApeKeys.Count - 1 do
            AddTagItem('APEv2', ApeKeys[i], aTag.GetValueByKey(ApeKeys[i]) );
    finally
       ApeKeys.Free;
    end
end;

procedure TMainFormAWB.RefillTagDetailsMP3;
begin
    if AudioFile.FileType = at_Mp3 then
    begin
        if (AudioFile as TMp3File).ID3v1Tag.Exists then
            RefillTagDetailsID3v1((AudioFile as TMp3File).ID3v1Tag);
        if (AudioFile as TMp3File).ID3v2Tag.Exists then
            RefillTagDetailsID3v2(TMP3File(AudioFile).ID3v2Tag);
        if (AudioFile as TMp3File).ApeTag.Exists then
            RefillTagDetailsApe((AudioFile as TMp3File).ApeTag);
    end;
end;

procedure TMainFormAWB.RefillTagDetailsOgg;
var OggKeys: TStrings;
    i: Integer;
begin
    if AudioFile.FileType = at_Ogg then
    begin
        OggKeys := TStringList.Create;
        try
            TOggVorbisFile(AudioFile).GetAllFields(OggKeys);
            for i := 0 to OggKeys.Count - 1 do
                AddTagItem('OggVorbis', OggKeys[i], TOggVorbisFile(AudioFile).GetPropertyByFieldname(OggKeys[i]));
        finally
            OggKeys.Free;
        end;
    end;
end;
procedure TMainFormAWB.RefillTagDetailsFlac;
var FlacKeys: TStrings;
    i: Integer;
begin
    if AudioFile.FileType = at_Flac then
    begin
        FlacKeys := TStringList.Create;
        try
            TFlacFile(AudioFile).GetAllFields(FlacKeys);
            for i := 0 to FlacKeys.Count - 1 do
                AddTagItem('OggVorbis', FlacKeys[i], TFlacFile(AudioFile).GetPropertyByFieldname(FlacKeys[i]));
        finally
            FlacKeys.Free;
        end;
    end;
end;

procedure TMainFormAWB.RefillTagDetailsM4A;
var M4AKeys: TStrings;
    i: Integer;
begin
    if AudioFile.FileType = at_M4A then
    begin
        M4AKeys := TStringList.Create;
        try
            TM4AFile(AudioFile).GetAllTextAtomDescriptions(M4AKeys);
            for i := 0 to M4AKeys.Count - 1 do
                AddTagItem('M4A', M4AKeys[i], TM4AFile(AudioFile).GetTextDataByDescription(M4AKeys[i]));
        finally
            M4AKeys.Free;
        end;
    end;
end;
procedure TMainFormAWB.RefillTagDetailsBaseApe;
begin
    if AudioFile.FileType in [at_Monkey, at_WavPack, at_MusePack, at_OptimFrog, at_TrueAudio] then
    begin
        if (AudioFile as TBaseApeFile).ID3v1Tag.Exists then
            RefillTagDetailsID3v1((AudioFile as TBaseApeFile).ID3v1Tag);
        if (AudioFile as TBaseApeFile).ApeTag.Exists then
            RefillTagDetailsApe((AudioFile as TBaseApeFile).ApeTag);
    end;
end;


procedure TMainFormAWB.RefillTagDetailsListView;
begin
  lvMetaTags.Clear;
  if not assigned(ID3v2Frames) then
      ID3v2Frames:= TObjectList.Create(False);

  case AudioFile.FileType of
    at_Invalid: ;
    at_Mp3: RefillTagDetailsMP3;
    at_Ogg: RefillTagDetailsOgg;
    at_Flac: RefillTagDetailsFlac;
    at_M4A: RefillTagDetailsM4A;
    at_Monkey,
    at_WavPack,
    at_MusePack,
    at_OptimFrog,
    at_TrueAudio: RefillTagDetailsBaseApe;
    at_Wma: ;
    at_Wav: ;
    at_AbstractApe: ;
  end;
end;

procedure TMainFormAWB.RefreshImageList;
var i: Integer;
    PicType: Integer;
    Description: UnicodeString;
    stream: TMemoryStream;
    iFrame: TID3v2Frame;
    Mime: AnsiString;
    ID3PicType: Byte;
    m4aPicType: TM4APicTypes;
begin
    case AudioFile.FileType of
        at_Invalid: ;
        at_Mp3: begin
              if not assigned(ID3v2PictureFrames) then
                  ID3v2PictureFrames := TObjectList.Create(False);

              cbPictures.Items.Clear;
              TMP3File(AudioFile).ID3v2Tag.GetAllPictureFrames(ID3v2PictureFrames);
              for i := 0 to ID3v2PictureFrames.Count - 1 do
              begin
                  iFrame := TID3v2Frame(ID3v2PictureFrames[i]);
                  stream := TMemoryStream.Create;
                  try
                      iFrame.GetPicture(Mime, id3Pictype, description, stream);
                      cbPictures.Items.AddObject(Picture_Types[id3Pictype], iFrame);
                  finally
                      stream.Free;
                  end;
              end;

              if cbPictures.Items.Count > 0 then
              begin
                  cbPictures.ItemIndex := 0;
                  iFrame := TID3v2Frame(cbPictures.Items.Objects[0]);
                  stream := TMemoryStream.Create;
                  try
                      if iFrame.GetPicture(Mime, id3Pictype, description, stream) then
                          StreamToBitmap(stream, Image1.Picture.Bitmap)
                      else
                          Image1.Picture.Assign(Nil);
                  finally
                      stream.Free;
                  end;
              end else
                  Image1.Picture.Assign(Nil);

        end;
        at_Ogg: begin
            cbPictures.Items.Clear;
            Image1.Picture.Assign(NIL);
        end;
        at_M4a: begin
            cbPictures.Items.Clear;
            stream := TMemoryStream.Create;
            try
                if TM4aFile(AudioFile).GetPictureStream(stream, m4aPicType) then
                begin
                    StreamToBitmap(stream, Image1.Picture.Bitmap);
                    cbPictures.Items.Add('Cover');
                    cbPictures.ItemIndex := 0;
                end
                else
                    Image1.Picture.Assign(Nil);
            finally
                stream.Free;
            end;
        end;
        at_Flac: begin
            if not assigned(FlacPictureFrames) then
                    FlacPictureFrames := TObjectList.Create(False);
            TFlacFile(AudioFile).GetAllPictureBlocks(FlacPictureFrames);

            cbPictures.Items.Clear;
            for i := FlacPictureFrames.Count - 1 downto 0 do
            begin
                PicType := TFlacPictureBlock(FlacPictureFrames[i]).PictureType;
                Description := TFlacPictureBlock(FlacPictureFrames[i]).Description;
                if PicType < length(Picture_Types) then
                    cbPictures.Items.Insert(0, Format('[%s] %s', [Picture_Types[PicType], Description]))
                else
                    cbPictures.Items.Insert(0, Format('[%s] %s', [Picture_Types[0], Description]));
            end;
            if cbPictures.Items.Count > 0 then
            begin
                cbPictures.ItemIndex := 0;
                stream := TMemoryStream.Create;
                try
                    TFlacPictureBlock(FlacPictureFrames[0]).CopyPicData(stream);
                    StreamToBitmap(stream, Image1.Picture.Bitmap);
                finally
                    stream.Free;
                end;
            end else
                Image1.Picture.Assign(NIL);
        end ;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: begin
            TBaseApeFile(AudioFile).ApeTag.GetAllPictureFrames(cbPictures.Items);
            if cbPictures.Items.Count > 0 then
            begin
                cbPictures.ItemIndex := cbPictures.Items.Count - 1;
                LoadImage(AnsiString(cBPictures.Text));
            end
            else
                Image1.Picture.Assign(NIL);
        end
    end;
end;

procedure TMainFormAWB.BtnNewPictureClick(Sender: TObject);
var fs: TFileStream;
begin
    if (NewPic.ShowModal = mrOK) and AudioFileExists(NewPic.OpenPictureDialog1.FileName) then
    begin
        try
            fs := TFileStream.Create(NewPic.OpenPictureDialog1.FileName, fmOpenRead or fmShareDenyWrite);
            try
                case AudioFile.FileType of
                    at_Invalid: ;
                    at_Mp3: begin
                        if (AnsiLowerCase(ExtractFileExt(NewPic.OpenPictureDialog1.FileName)) = '.jpg')
                            or (AnsiLowerCase(ExtractFileExt(NewPic.OpenPictureDialog1.FileName)) = '.jpeg')
                        then
                            TMp3File(AudioFile).ID3v2Tag.SetPicture('image/jpeg', NewPic.cbPicType.ItemIndex, NewPic.EdtDescription.Text, fs)
                        else
                            if (AnsiLowerCase(ExtractFileExt(NewPic.OpenPictureDialog1.FileName)) = '.png') then
                                TMp3File(AudioFile).ID3v2Tag.SetPicture('image/png', NewPic.cbPicType.ItemIndex, NewPic.EdtDescription.Text, fs)
                            else
                                ShowMessage('Image type not supported. Operation cancelled');
                    end;
                    at_Ogg: ; // Nothing
                    at_Flac: begin
                        if (AnsiLowerCase(ExtractFileExt(NewPic.OpenPictureDialog1.FileName)) = '.jpg')
                            or (AnsiLowerCase(ExtractFileExt(NewPic.OpenPictureDialog1.FileName)) = '.jpeg')
                        then
                            TFlacFile(AudioFile).AddPicture(fs, NewPic.cbPicType.ItemIndex, 'image/jpeg', NewPic.EdtDescription.Text)
                        else
                            if (AnsiLowerCase(ExtractFileExt(NewPic.OpenPictureDialog1.FileName)) = '.png') then
                                TFlacFile(AudioFile).AddPicture(fs, NewPic.cbPicType.ItemIndex, 'image/png', NewPic.EdtDescription.Text)
                            else
                                ShowMessage('Image type not supported. Operation cancelled')
                    end;
                    at_M4A: begin
                        if (AnsiLowerCase(ExtractFileExt(NewPic.OpenPictureDialog1.FileName)) = '.jpg')
                            or (AnsiLowerCase(ExtractFileExt(NewPic.OpenPictureDialog1.FileName)) = '.jpeg')
                        then
                            TM4aFile(AudioFile).SetPicture(fs, M4A_JPG)
                        else
                            if (AnsiLowerCase(ExtractFileExt(NewPic.OpenPictureDialog1.FileName)) = '.png') then
                                TM4aFile(AudioFile).SetPicture(fs, M4A_PNG)
                            else
                                ShowMessage('Image type not supported. Operation cancelled');
                    end;
                    at_Monkey,
                    at_WavPack,
                    at_MusePack,
                    at_OptimFrog,
                    at_TrueAudio: TBaseApeFile(AudioFile).ApeTag.SetPicture(AnsiString(NewPic.cbPicType.Text), NewPic.EdtDescription.Text, fs);
                end;
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
    case AudioFile.FileType of
        at_Invalid: ;
        at_Mp3: TMP3File(AudioFile).ID3v2Tag.DeleteFrame(TID3v2Frame(cbPictures.Items.Objects[cbPictures.ItemIndex]));
        at_Ogg: ;
        at_Flac: TFlacFile(AudioFile).DeletePicture(TFlacPictureBlock(FlacPictureFrames[cbPictures.ItemIndex]));
        at_M4A: TM4aFile(AudioFile).SetPicture(Nil, M4A_Invalid);
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: TBaseApeFile(AudioFile).ApeTag.SetPicture(AnsiString(cBPictures.Text), '', NIL) ;
    end;
    RefreshImageList;
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
    case AudioFile.FileType of
        at_Invalid: ;
        at_Mp3:  TMP3File(AudioFile).ID3v2Tag.Lyrics := Trim(MemoLyrics.Text);
        at_Ogg:  TOggVorbisFile(AudioFile).SetPropertyByFieldname('UNSYNCEDLYRICS', Trim(MemoLyrics.Text));
        at_Flac: TFlacFile(AudioFile).SetPropertyByFieldname('UNSYNCEDLYRICS', Trim(MemoLyrics.Text));
        at_M4a:  TM4AFile(AudioFile).Lyrics := Trim(MemoLyrics.Text);
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: TBaseApeFile(AudioFile).ApeTag.SetValueByKey('UNSYNCEDLYRICS', Trim(MemoLyrics.Text));
    end;

    AudioFile.UpdateFile;
end;

procedure TMainFormAWB.cbPicturesChange(Sender: TObject);
var stream: TMemoryStream;
    iFrame: TID3v2Frame;
    Mime: AnsiString;
    ID3PicType: Byte;
    description: UnicodeString;
begin
    case AudioFile.FileType of
        at_Invalid: ;
        at_Mp3: begin
            iFrame := TID3v2Frame(cbPictures.Items.Objects[cbPictures.ItemIndex]);
            stream := TMemoryStream.Create;
            try
                if iFrame.GetPicture(Mime, id3Pictype, description, stream) then
                    StreamToBitmap(stream, Image1.Picture.Bitmap)
                else
                    Image1.Picture.Assign(Nil);
            finally
                stream.Free;
            end;
        end;
        at_Ogg: ;
        at_Flac: begin
            stream := TMemoryStream.Create;
            try
                TFlacPictureBlock(FlacPictureFrames[cbPictures.ItemIndex]).CopyPicData(stream);
                StreamToBitmap(stream, Image1.Picture.Bitmap);
            finally
                stream.Free;
            end;
        end;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: LoadImage(AnsiString(cBPictures.Items[cbPictures.ItemIndex]));
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

procedure TMainFormAWB.LoadImage(aKey: AnsiString);
var picStream: TMemoryStream;
    picDescription: UnicodeString;
begin
    if AudioFile.FileType in [at_Monkey, at_WavPack, at_MusePack, at_OptimFrog, at_TrueAudio] then
    begin
        picDescription := '';
        picStream := tMemoryStream.Create;
        try
            if TBaseApeFile(AudioFile).ApeTag.GetPicture(aKey, picStream, picDescription) then
            begin
                if not StreamToBitmap(picStream, Image1.Picture.Bitmap) then
                    Image1.Picture.Assign(NIL);
            end else
                Image1.Picture.Assign(NIL);
        finally
            picStream.Free;
        end;
    end;
end;


end.
