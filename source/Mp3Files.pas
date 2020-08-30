{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2020, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit MP3Files

    Manipulate mp3-Files

    ---------------------------------------------------------------------------

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    ---------------------------------------------------------------------------

    Alternatively, you may use this unit under the terms of the
    MOZILLA PUBLIC LICENSE (MPL):

    The contents of this file are subject to the Mozilla Public License
    Version 1.1 (the "License"); you may not use this file except in
    compliance with the License. You may obtain a copy of the License at
    http://www.mozilla.org/MPL/

    Software distributed under the License is distributed on an "AS IS"
    basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
    License for the specific language governing rights and limitations
    under the License.

    ---------------------------------------------------------------------------
}

unit Mp3Files;

interface

uses Windows, Messages, SysUtils, StrUtils, Variants, ContNrs, Classes,
     AudioFiles.Base, AudioFiles.Factory, AudioFiles.Declarations,
     Mp3FileUtils, ID3v2Frames;

type

    TTagWriteMode = (id3_both, id3_v1, id3_v2, id3_existing);
    TTagDefaultMode = (id3_def_both, id3_def_v1, id3_def_v2);
    TTagDeleteMode = (id3_del_both, id3_del_v1, id3_del_v2);

    ///  TTagReadMode
    ///  Purpose is to speed up reading file information while building up a media library (or something like that)
    ///  Often the ID3v1Tag is not needed, as everything is already covered by the ID3v2Tag.
    ///  I assume that file access is the bottleneck, so NOT searching for some more data at the very end of the file
    ///  may increase the overall speed.
    ///  * id3_read_complete : Always check for both versions
    ///  * id3_read_smart    : Check for ID3v2Tag first. If some "relevant data" is missing, try ID3v1tag as well
    ///  * id3_read_v2_only  : read only v2
    ///    (note: only v1 doesn't make much sense for faster reading)
    TTagScanMode = (id3_read_complete, id3_read_smart, id3_read_v2_only );

    ///  Notes:
    ///  - Defining what "relevant data" for "id3_read_smart" means
    ///    All possible fields in the ID3v1-Tag are rather useful and could add something
    ///    useful. However, "Comment" is rarely used. If this is not contained in the v2Tag,
    ///    we should not look for it on v1.
    ///    * use property "SmartRead_IgnoreComment" (default: True)
    ///  - Avoiding inconsistent Data
    ///    When reading only one Tag from the file, the internal Tag-Objects for the other one
    ///    remains empty. But when we want to change the meta data in the file, it should be
    ///    ensured, that these data remains consistently.
    ///    * use private field "v1Processed" , whether we've looked for that Tag in the file.
    ///      The Setter-Methods should check for that, and look after the v1Tag in the file
    ///      by re-reading it
    ///    * To deactivate this feature, use property "SmartRead_AvoidInconsistentData" (default: True)

    TMP3File = class (TBaseAudioFile)
        private
            fID3v1Tag: TID3v1Tag;
            fID3v2Tag: TID3v2Tag;
            fMpegInfo: TMpegInfo;

            fTagScanMode   : TTagScanMode;
            fTagWriteMode  : TTagWriteMode;
            fTagDefaultMode: TTagDefaultMode;
            fTagDeleteMode : TTagDeleteMode;

            fSmartRead_IgnoreComment         : Boolean;
            fSmartRead_AvoidInconsistentData : Boolean;
            fTag1Processed                   : Boolean;

            // a private field for performing a complete analysis in ReadFromFile,
            // including storing all the MPEG-Frames in the fMpegInfo
            ReadWithCompleteAnalysis: Boolean;

            function Mp3ErrorToAudioError(aErr: TMP3Error): TAudioError;

            function fGetID3v1Size: Integer;
            function fGetID3v2Size: Integer;

            procedure EnforceID3v1IsProcessed;
            function ID3v1TagIsNeeded: Boolean;

            function GetMpegScanMode: TMpegScanMode;
            procedure SetMpegScanMode(const Value: TMpegScanMode);

        protected

            function fGetFileSize   : Int64;    override;
            function fGetDuration   : Integer;  override;
            function fGetBitrate    : Integer;  override;
            function fGetSamplerate : Integer;  override;
            function fGetChannels   : Integer;  override;
            function fGetValid      : Boolean;  override;

            procedure fSetTitle           (aValue: UnicodeString); override;
            procedure fSetArtist          (aValue: UnicodeString); override;
            procedure fSetAlbum           (aValue: UnicodeString); override;
            procedure fSetYear            (aValue: UnicodeString); override;
            procedure fSetTrack           (aValue: UnicodeString); override;
            procedure fSetGenre           (aValue: UnicodeString); override;
            procedure fSetComment         (aValue: UnicodeString);

            function fGetTitle            : UnicodeString; override;
            function fGetArtist           : UnicodeString; override;
            function fGetAlbum            : UnicodeString; override;
            function fGetYear             : UnicodeString; override;
            function fGetTrack            : UnicodeString; override;
            function fGetGenre            : UnicodeString; override;
            function fGetComment          : UnicodeString;

            function fGetFileType            : TAudioFileType; override;
            function fGetFileTypeDescription : String;         override;

        public

            property ID3v1Tag: TID3v1Tag read fID3v1Tag;
            property ID3v2Tag: TID3v2Tag read fID3v2Tag;
            property MpegInfo: TMpegInfo read fMpegInfo;

            property ID3v1TagSize: Integer read fGetID3v1Size;
            property ID3v2TagSize: Integer read fGetID3v2Size;

            // Properties for "smart reading"
            property TagScanMode   : TTagScanMode read fTagScanMode write fTagScanMode;
            property SmartRead_IgnoreComment         : Boolean read fSmartRead_IgnoreComment          write fSmartRead_IgnoreComment;
            property SmartRead_AvoidInconsistentData : Boolean read fSmartRead_AvoidInconsistentData  write fSmartRead_AvoidInconsistentData;
            property Tag1Processed                   : Boolean read fTag1Processed;
            // ScanMode: "Fast", "Complete" or "Smart" scan of the file to get Bitrate and Duration
            //    * "Smart" does a "Complete" scan, if the "Fast" scan result is "32 kbit/s" (or even lower)
            //       This is often the case for vbr files without a decent VBR-Header
            property MpegScanMode: TMpegScanMode read GetMpegScanMode write SetMpegScanMode;

            // WriteMode: Define which Tag should be Updated in the file when writing
            //           (Both, only v1, only v2, only existing)
            property TagWriteMode: TTagWriteMode read fTagWriteMode write fTagWriteMode;
            // DefaultMode: Define which Tag should be written in "Only Existing Mode"
            //              in case NO Tag exists
            //              (Both, only v1, only v2)
            property TagDefaultMode: TTagDefaultMode read fTagDefaultMode write fTagDefaultMode;
            // DeleteMode: define which tag should be removed
            //              (Both, only v1, only v2)
            property TagDeleteMode : TTagDeleteMode read fTagDeleteMode write fTagDeleteMode;

            property Comment: UnicodeString read fGetComment write fSetComment;

            constructor Create; override;
            destructor Destroy; override;

            procedure Clear;
            function ReadFromFile(aFilename: UnicodeString): TAudioError;    override;
            function WriteToFile(aFilename: UnicodeString): TAudioError;     override;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError;  override;

            // AnalyseFile: This is only for a low level analysis of the file
            //              It is mainly used by myself to have a closer look on "odd" mp3 files
            //              which some properties leading to wrong results in bitrate, duration and stuff.
            function AnalyseFile(aFilename: UnicodeString): TAudioError;

    end;


implementation

{ TMP3File }

procedure TMP3File.Clear;
begin
    fID3v2Tag.Clear;
    fID3v1Tag.Clear;

    FFileSize := 0;

    fDuration   := 0;
    fBitrate    := 0;
    fSamplerate := 0;
    fChannels   := 0;
    fValid      := False;
    fTag1Processed := False;
end;

constructor TMP3File.Create;
begin
    fID3v1Tag := TID3v1Tag.Create;
    fID3v2Tag := TID3v2Tag.Create;
    fMpegInfo := TMpegInfo.create;

    fTagWriteMode   := id3_existing;
    fTagDefaultMode := id3_def_both;
    fTagDeleteMode  := id3_del_both;

    fTagScanMode := id3_read_smart;
    fTag1Processed                   := False;
    fSmartRead_IgnoreComment         := True;
    fSmartRead_AvoidInconsistentData := True;
    ReadWithCompleteAnalysis         := False;
end;

destructor TMP3File.Destroy;
begin
    fID3v1Tag.Free;
    fID3v2Tag.Free;
    fMpegInfo.Free;

    inherited;
end;

procedure TMP3File.EnforceID3v1IsProcessed;
var fs: TAudioFileStream;
    tmp1: TMP3Error;
begin
  if SmartRead_AvoidInconsistentData and (not fTag1Processed) then
  begin
    // try to read the v1Tag from the file
    if AudioFileExists(self.Filename) then
    begin
      try
        fs := TAudioFileStream.Create(self.Filename, fmOpenRead or fmShareDenyWrite);
        try
          tmp1 := fID3v1Tag.ReadFromStream(fs);
          // if nothing wrong happens there, we will consider the ID3v1Tag "processed"
          fTag1Processed := (tmp1 = MP3ERR_None) or (tmp1 = ID3ERR_NoTag);
        finally
          fs.Free;
        end;
      except
        ; //nothing to do. Reading failed (again)
      end;
    end
  end;
end;

function TMP3File.ID3v1TagIsNeeded: Boolean;
var BasePropertyMissing, CommentMissing: Boolean;
begin
    case fTagScanMode of

        id3_read_complete: result := True;

        id3_read_v2_only: result := False;

        id3_read_smart: begin
            if not ID3v2tag.Exists then
                result := True
            else
            begin
                BasePropertyMissing := (ID3v2tag.Artist = '')
                                OR (ID3v2tag.Title = '')
                                OR (ID3v2tag.Album = '')
                                OR (ID3v2tag.Track = '')
                                OR (ID3v2tag.Year = '')
                                OR (ID3v2tag.Genre = '');
                CommentMissing := (ID3v2tag.Comment = '');

                if fSmartRead_IgnoreComment then
                    result :=  BasePropertyMissing
                else
                  result := BasePropertyMissing or CommentMissing;
            end;
        end;
    else
        result := False;
    end;
end;

function TMP3File.GetMpegScanMode: TMpegScanMode;
begin
    result := fMpegInfo.MpegScanMode;
end;

procedure TMP3File.SetMpegScanMode(const Value: TMpegScanMode);
begin
    fMpegInfo.MpegScanMode := Value;
end;

function TMP3File.fGetFileType: TAudioFileType;
begin
    result := at_Mp3;
end;

function TMP3File.fGetFileTypeDescription: String;
begin
    result := TAudioFileNames[at_Mp3];
end;

function TMP3File.fGetFileSize: Int64;
begin
    result := fFileSize;
end;

function TMP3File.fGetBitrate: Integer;
begin
    result := fBitrate;
end;
function TMP3File.fGetDuration: Integer;
begin
    result := fDuration;
end;
function TMP3File.fGetSamplerate: Integer;
begin
    result := fSamplerate;
end;
function TMP3File.fGetChannels: Integer;
begin
    result := fChannels;
end;

function TMP3File.fGetComment: UnicodeString;
begin
    result := fID3v2tag.Comment;
    if result = '' then
        result := fID3v1Tag.Comment;
end;

function TMP3File.fGetAlbum: UnicodeString;
begin
    result := fID3v2Tag.Album;
    if result = '' then
        result := fID3v1Tag.Album;
end;
function TMP3File.fGetArtist: UnicodeString;
begin
    result := fID3v2Tag.Artist;
    if result = '' then
        result := fID3v1Tag.Artist;
end;
function TMP3File.fGetGenre: UnicodeString;
begin
    result := fID3v2Tag.Genre;
    if result = '' then
        result := fID3v1Tag.Genre;
end;
function TMP3File.fGetTitle: UnicodeString;
begin
    result := fID3v2Tag.Title;
    if result = '' then
        result := fID3v1Tag.Title;
end;
function TMP3File.fGetTrack: UnicodeString;
begin
    result := fID3v2Tag.Track;
    if result = '' then
        result := fID3v1Tag.Track;
end;
function TMP3File.fGetYear: UnicodeString;
begin
    result := fID3v2Tag.Year;
    if result = '' then
        result := UnicodeString(fID3v1Tag.Year);
end;



procedure TMP3File.fSetAlbum(aValue: UnicodeString);
begin
  inherited;
  EnforceID3v1IsProcessed;
  fID3v1Tag.Album := aValue;
  fID3v2Tag.Album := aValue;
end;

procedure TMP3File.fSetArtist(aValue: UnicodeString);
begin
  inherited;
  EnforceID3v1IsProcessed;
  fID3v1Tag.Artist := aValue;
  fID3v2Tag.Artist := aValue;
end;

procedure TMP3File.fSetComment(aValue: UnicodeString);
begin
  EnforceID3v1IsProcessed;
  fID3v1Tag.Comment := aValue;
  fID3v2Tag.Comment := aValue;
end;

procedure TMP3File.fSetGenre(aValue: UnicodeString);
begin
  inherited;
  EnforceID3v1IsProcessed;
  fID3v1Tag.Genre := aValue;
  fID3v2Tag.Genre := aValue;
end;

procedure TMP3File.fSetTitle(aValue: UnicodeString);
begin
  inherited;
  EnforceID3v1IsProcessed;
  fID3v1Tag.Title := aValue;
  fID3v2Tag.Title := aValue;
end;

procedure TMP3File.fSetTrack(aValue: UnicodeString);
begin
  inherited;
  EnforceID3v1IsProcessed;
  fID3v1Tag.Track := aValue;
  fID3v2Tag.Track := aValue;
end;

procedure TMP3File.fSetYear(aValue: UnicodeString);
begin
  inherited;
  EnforceID3v1IsProcessed;
  fID3v1Tag.Year := ShortString(aValue);
  fID3v2Tag.Year := aValue;
end;


function TMP3File.Mp3ErrorToAudioError(aErr: TMP3Error): TAudioError;
begin
    case aErr of
        MP3ERR_None     : result := FileErr_None;
        MP3ERR_NoFile   : result := FileErr_NoFile;
        MP3ERR_FOpenCrt : result := FileErr_FileCreate;
        MP3ERR_FOpenR   : result := FileErr_FileOpenR;
        MP3ERR_FOpenRW,
        MP3ERR_FOpenW   : result := FileErr_FileOpenRW;
        MP3ERR_SRead    : result := MP3ERR_StreamRead;
        MP3ERR_SWrite   : result := MP3ERR_StreamWrite;
        ID3ERR_Cache    : result := MP3ERR_Cache;
        ID3ERR_NoTag    : result := MP3ERR_NoTag;
        ID3ERR_Invalid_Header : result := MP3ERR_Invalid_Header;
        ID3ERR_Compression    : result := MP3ERR_Compression;
        ID3ERR_Unclassified   : result := MP3ERR_Unclassified;
        MPEGERR_NoFrame       : result := MP3ERR_NoMpegFrame;
    else
        result := MP3ERR_Unclassified;
    end;
end;

function TMP3File.fGetID3v1Size: Integer;
begin
    if fId3v1Tag.Exists then
        result := 128
    else
        result := 0;
end;
function TMP3File.fGetID3v2Size: Integer;
begin
    if fID3v2Tag.Exists then
        result := fId3v2Tag.Size
    else
        result := 0;
end;

function TMP3File.fGetValid: Boolean;
begin
    result := fValid;
end;


function TMP3File.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    tmp1, tmp2, tmpMpeg: TMP3Error;
begin
    inherited;

    Clear;
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try
                fFileSize := fs.Size;

                fs.Seek(0, sobeginning);
                tmp2 := id3v2tag.ReadFromStream(fs);
                if fID3v2Tag.exists then
                    fs.Seek(id3v2tag.size, soBeginning)
                else
                    fs.Seek(0, sobeginning);

                if ReadWithCompleteAnalysis then
                    tmpMpeg := fMpegInfo.StoreFrames(fs)
                else
                    tmpMpeg := fMpegInfo.LoadFromStream(fs);

                result := Mp3ErrorToAudioError(tmpMpeg);

                if ID3v1TagIsNeeded or ReadWithCompleteAnalysis then
                begin
                    tmp1 := fID3v1Tag.ReadFromStream(fs);
                    fTag1Processed := True;
                end
                else
                    tmp1 := MP3ERR_None;

                if result = FileErr_None then
                begin
                    if (tmp1 = ID3Err_NoTag) and (tmp2 = ID3Err_NoTag) then
                        result := MP3Err_NoTag
                    else
                        result := Mp3ErrorToAudioError(tmp2);
                end else
                    result := Mp3ErrorToAudioError(tmp2);  // Error on ID3v2Tag has higher priority

                fValid := tmpMpeg = MP3Err_None;
                if fValid then
                begin
                    fDuration    := fMpegInfo.Duration;
                    fBitrate     := fMpegInfo.Bitrate * 1000;
                    fSamplerate  := fMpegInfo.Samplerate;
                    case fMpegInfo.Channelmode of
                        0: fChannels := 2;
                        1: fChannels := 2;
                        2: fChannels := 2;
                        3: fChannels := 1;
                    else
                         fChannels := 0;
                    end;
                end;

            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenR;
        end;
    end else
        result := FileErr_NoFile;
end;


function TMP3File.AnalyseFile(aFilename: UnicodeString): TAudioError;
begin
    ReadWithCompleteAnalysis := True;
    result := ReadFromFile(aFileName);
    ReadWithCompleteAnalysis := False;
end;


function TMP3File.RemoveFromFile(aFilename: UnicodeString): TAudioError;
var tmp: TMP3Error;
begin
    inherited;

    tmp := MP3ERR_None;
    if fTagDeleteMode in [id3_del_both, id3_del_v1] then
        tmp := fId3v1Tag.RemoveFromFile(aFilename);
    if fTagDeleteMode in [id3_del_both, id3_del_v2] then
        tmp := fId3v2Tag.RemoveFromFile(aFilename);
    result := Mp3ErrorToAudioError(tmp);
end;

function TMP3File.WriteToFile(aFilename: UnicodeString): TAudioError;
var tmp: TMP3Error;
    TagWritten: Boolean;
begin
    inherited;
    tmp := MP3ERR_None;

    case fTagWriteMode of
        id3_both: begin
            tmp := fId3v1Tag.WriteToFile(aFilename);
            if tmp = MP3ERR_None then
                tmp := fId3v2Tag.WriteToFile(aFilename);
        end;

        id3_v1: tmp := fId3v1Tag.WriteToFile(aFilename);

        id3_v2: tmp := fId3v2Tag.WriteToFile(aFilename);

        id3_existing: begin
            TagWritten := False;
            if fId3v1Tag.Exists then
            begin
                tmp := fId3v1Tag.WriteToFile(aFilename);
                TagWritten := True;
            end;
            if fId3v2Tag.Exists then
            begin
                tmp := fId3v2Tag.WriteToFile(aFilename);
                TagWritten := True;
            end;

            if Not TagWritten then
            begin
                // Create Tag(s)
                case fTagDefaultMode of
                  id3_def_both: begin
                      tmp := fId3v1Tag.WriteToFile(aFilename);
                      if tmp = MP3ERR_None then
                          tmp := fId3v2Tag.WriteToFile(aFilename);
                  end;
                  id3_def_v1: tmp := fId3v1Tag.WriteToFile(aFilename);
                  id3_def_v2: tmp := fId3v2Tag.WriteToFile(aFilename);
                end;
            end;
        end;
    end;

    result := Mp3ErrorToAudioError(tmp);
end;

initialization

  AudioFileFactory.RegisterClass(TMP3File, '.mp3');
  AudioFileFactory.RegisterClass(TMP3File, '.mp2');
  AudioFileFactory.RegisterClass(TMP3File, '.mp1');

end.
