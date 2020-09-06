{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2020, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit BaseApeFiles

    (was: Apev2Tags before)

    This is the base class for
        MonkeyFiles
        MusePackFiles
        OptimFrogFiles
        TrueAudioFiles
        WavePackFiles

    Use an instance of these classes to colelct data from the files.

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

unit BaseApeFiles;

interface

uses Windows, SysUtils, Classes,
     AudioFiles.Base, AudioFiles.Factory, AudioFiles.Declarations,
     Id3Basics, ApeV2Tags, ApeTagItem;

const
    APE_PREAMBLE = 'APETAGEX';

type

    TApeHeader = record
        Preamble: Array[1..8] of AnsiChar;
        Version: DWord;
        Size: DWord;
        ItemCount: DWord;
        Flags: DWord;
        Reserved: Array[1..8] of Byte;
    end;

    TBaseApeFile = class (TBaseAudioFile)
        private

            fApeTag: TApeTag;

            //fID3v1Present: Boolean;
            //fID3v1TagSize: Cardinal;
            fID3v2TagSize: Cardinal;

            function fGetID3v1TagSize: Cardinal;
            function fGetApeTagSize: Cardinal;
            function fGetCombinedTagSize: Cardinal;  // The Size of Ape, ID3v and ID3v2 together. Used for Bitrate calculation

      protected
            // Audio properties
            //fDuration   : Integer;
            //fBitrate    : Integer;
            //fSamplerate : Integer;
            //fChannels   : Integer;
            //fValid      : Boolean;
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

            function fGetTitle            : UnicodeString; override;
            function fGetArtist           : UnicodeString; override;
            function fGetAlbum            : UnicodeString; override;
            function fGetYear             : UnicodeString; override;
            function fGetTrack            : UnicodeString; override;
            function fGetGenre            : UnicodeString; override;

            function ReadAudioDataFromStream(aStream: TStream): Boolean; virtual;
            function fGetFileType            : TAudioFileType; override;
            function fGetFileTypeDescription : String;         override;


        public
            property ApeTag: TApeTag read fApeTag;

            // Size of the Tags in Bytes
            // Note: Only the Apev2Tag is really processed here
            //       The other Tags ore only considered for bitrate calculation later
            property Apev2TagSize   : Cardinal read fGetApeTagSize;
            property ID3v1TagSize   : Cardinal read fGetID3v1TagSize;
            property ID3v2TagSize   : Cardinal read fID3v2TagSize;
            property CombinedTagSize: Cardinal read fGetCombinedTagSize;

            constructor Create; override;
            destructor Destroy; override;

            procedure Clear;

            function ReadFromFile(aFilename: UnicodeString): TAudioError;   override;
            function WriteToFile(aFilename: UnicodeString): TAudioError;    override;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError; override;
    end;

implementation

{ TBaseApeFile }

constructor TBaseApeFile.Create;
begin
    fApeTag := TApeTag.Create;
end;

destructor TBaseApeFile.Destroy;
begin
    fApeTag.Free;
    inherited;
end;

function TBaseApeFile.fGetFileType: TAudioFileType;
begin
    result := at_AbstractApe;
end;

function TBaseApeFile.fGetFileTypeDescription: String;
begin
    result := TAudioFileNames[at_AbstractApe]
end;

{
    Clear
    Set default values
}
procedure TBaseApeFile.Clear;
begin
    ApeTag.Clear;
    FFileSize := 0;
    fID3v2TagSize := 0;
    fDuration   := 0;
    fBitrate    := 0;
    fSamplerate := 0;
    fChannels   := 0;
    fValid      := False;
end;



function TBaseApeFile.fGetValid: Boolean;
begin
    result := fValid;
end;
function TBaseApeFile.fGetFileSize: Int64;
begin
    result := fFileSize;
end;


// dummy getters
function TBaseApeFile.fGetDuration: Integer;
begin
    result := fDuration;
end;
function TBaseApeFile.fGetChannels: Integer;
begin
    result := fChannels;
end;
function TBaseApeFile.fGetSamplerate: Integer;
begin
    result := fSamplerate;
end;
function TBaseApeFile.fGetBitrate: Integer;
begin
    result := fBitrate;
end;

// Tag Size Getters
function TBaseApeFile.fGetID3v1TagSize: Cardinal;
begin
    Result := ApeTag.ID3v1TagSize;
end;
function TBaseApeFile.fGetApeTagSize: Cardinal;
begin
    Result := ApeTag.Apev2TagSize;
end;
function TBaseApeFile.fGetCombinedTagSize: Cardinal;
begin
    result := ApeTag.Apev2TagSize
            + ApeTag.ID3v1TagSize   // also determined and managed by TApeTag
            + fID3v2TagSize;        // determined from TBaseApeFile.ReadFromFile
end;


// Actual properties
procedure TBaseApeFile.fSetAlbum(aValue: UnicodeString);
begin
    ApeTag.Album := aValue;
end;
procedure TBaseApeFile.fSetArtist(aValue: UnicodeString);
begin
    ApeTag.Artist := aValue;
end;
procedure TBaseApeFile.fSetTitle(aValue: UnicodeString);
begin
    ApeTag.Title := aValue;
end;
procedure TBaseApeFile.fSetTrack(aValue: UnicodeString);
begin
    ApeTag.Track := aValue;
end;
procedure TBaseApeFile.fSetYear(aValue: UnicodeString);
begin
    ApeTag.Year := aValue;
end;
procedure TBaseApeFile.fSetGenre(aValue: UnicodeString);
begin
    ApeTag.Genre := aValue;
end;


function TBaseApeFile.fGetAlbum: UnicodeString;
begin
    result := ApeTag.Album;
end;
function TBaseApeFile.fGetArtist: UnicodeString;
begin
    result := ApeTag.Artist;
end;
function TBaseApeFile.fGetGenre: UnicodeString;
begin
    result := ApeTag.Genre;
end;
function TBaseApeFile.fGetTitle: UnicodeString;
begin
    result := ApeTag.Title;
end;
function TBaseApeFile.fGetTrack: UnicodeString;
begin
    result := ApeTag.Track;
end;
function TBaseApeFile.fGetYear: UnicodeString;
begin
    result := ApeTag.Year;
end;

{
    ReadAudioDataFromStream
    Read the audio data from a stream
    This should be implemented in derived classes
}
function TBaseApeFile.ReadAudioDataFromStream(aStream: TStream): Boolean;
begin
    fDuration   := 0;
    fBitrate    := 0;
    fSamplerate := 0;
    fChannels   := 0;
    result := True;
end;


function TBaseApeFile.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
begin
    inherited ReadFromFile(aFileName);
    Clear;
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try
                fFileSize := fs.Size;

                // Check for an existing ID3v2Tag and get its size
                fID3v2TagSize := GetID3Size(fs);

                // Read the APEv2Tag from the stream
                result := ApeTag.ReadFromStream(fs);

                // Read the Audio Data (duration, bitrate, ) from the file.
                // This should be done in derivate classes
                // TagSizes (all 3) may be needed there
                fs.Seek(fID3v2TagSize, soBeginning);
                ReadAudioDataFromStream(fs);
            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenR;
        end;
    end else
        result := FileErr_NoFile;
end;


function TBaseApeFile.WriteToFile(aFilename: UnicodeString): TAudioError;
begin
    inherited WriteToFile(aFilename);
    result := ApeTag.WriteToFile(aFilename);
end;

function TBaseApeFile.RemoveFromFile(aFilename: UnicodeString): TAudioError;
begin
    inherited RemoveFromFile(aFilename);
    result := ApeTag.RemoveFromFile(aFilename);
end;


end.
