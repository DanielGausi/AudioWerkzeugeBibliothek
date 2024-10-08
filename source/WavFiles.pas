{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2020, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------
    contains parts of
        Audio Tools Library
        http://mac.sourceforge.net/atl/
        e-mail: macteam@users.sourceforge.net

        Copyright (c) 2000-2002 by Jurgen Faul
        Copyright (c) 2003-2005 by The MAC Team
    -----------------------------------

    Unit WavFiles

    Get audio information from Wav Files (*.wav)
    (read only)

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

unit WavFiles;

interface

uses Classes, SysUtils, AudioFiles.Base, AudioFiles.Declarations, AudioFiles.BaseTags;


type

    Twavfile = class(TBaseAudioFile)
        private
            procedure fResetData;
        protected

            procedure fSetTitle           (aValue: UnicodeString); override;
            procedure fSetArtist          (aValue: UnicodeString); override;
            procedure fSetAlbum           (aValue: UnicodeString); override;
            procedure fSetYear            (aValue: UnicodeString); override;
            procedure fSetTrack           (aValue: UnicodeString); override;
            procedure fSetGenre           (aValue: UnicodeString); override;
            procedure fSetAlbumArtist (value: UnicodeString); override;
            procedure fSetLyrics          (aValue: UnicodeString); override;

            function fGetTitle            : UnicodeString; override;
            function fGetArtist           : UnicodeString; override;
            function fGetAlbum            : UnicodeString; override;
            function fGetYear             : UnicodeString; override;
            function fGetTrack            : UnicodeString; override;
            function fGetGenre            : UnicodeString; override;
            function fGetFileType            : TAudioFileType; override;
            function fGetFileTypeDescription : String;         override;
            function fGetAlbumArtist : UnicodeString; override;
            function fGetLyrics           : UnicodeString;  override;

        public
            { Public declarations }
            constructor Create; override;
            function ReadFromFile(aFilename: UnicodeString): TAudioError;   override;
            function WriteToFile(aFilename: UnicodeString): TAudioError;    override;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError; override;
            // dummy methods
            procedure GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes); override;
            procedure DeleteTagItem(aTagItem: TTagItem); override;
            function GetUnusedTextTags: TTagItemInfoDynArray; override;
            function AddTextTagItem(aKey, aValue: UnicodeString): TTagItem; override;
            function SetPicture(Source: TStream; Mime: AnsiString; PicType: TPictureType; Description: UnicodeString): Boolean; override;
        end;

implementation

constructor TWavfile.Create;
begin
    inherited;
    fResetData;
end;

function Twavfile.fGetFileType: TAudioFileType;
begin
    result := at_Wav;

end;

function Twavfile.fGetFileTypeDescription: String;
begin
    result := cAudioFileType[at_Wav];
end;

procedure TWavfile.FResetData;
begin
    // Reset variables
    fValid := false;
    fFileSize := 0;
    fSampleRate := 0;
    fChannels := 0;
    fDuration := 0;
    fBitRate := 0;
end;

procedure TWavfile.fSetAlbum(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure Twavfile.fSetAlbumArtist(value: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TWavfile.fSetArtist(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TWavfile.fSetGenre(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure Twavfile.fSetLyrics(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TWavfile.fSetTitle(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TWavfile.fSetTrack(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

procedure TWavfile.fSetYear(aValue: UnicodeString);
begin
  inherited;
  // nothing. This Unit is read-Only
end;

{ --------------------------------------------------------------------------- }

function TWavfile.fGetAlbum: UnicodeString;
begin
    result := '';
end;

function Twavfile.fGetAlbumArtist: UnicodeString;
begin
  result := '';
end;

function TWavfile.fGetArtist: UnicodeString;
begin
    result := '';
end;

function TWavfile.fGetGenre: UnicodeString;
begin
    result := '';
end;

function Twavfile.fGetLyrics: UnicodeString;
begin
    result := '';
end;

function TWavfile.fGetTitle: UnicodeString;
begin
    result := '';
end;

function TWavfile.fGetTrack: UnicodeString;
begin
    result := '';
end;

function TWavfile.fGetYear: UnicodeString;
begin
    result := '';
end;

{ ********************** Public functions & procedures ********************** }

procedure TWavfile.GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes);
begin
  // not supported
end;

procedure TWavfile.DeleteTagItem(aTagItem: TTagItem);
begin
  // not supported
end;

function TWavfile.GetUnusedTextTags: TTagItemInfoDynArray;
begin
  // not supported
  SetLength(Result, 0);
end;

function TWavfile.AddTextTagItem(aKey, aValue: UnicodeString): TTagItem;
begin
  // not supported
  result := Nil;
end;

function TWavfile.SetPicture(Source: TStream; Mime: AnsiString; PicType: TPictureType; Description: UnicodeString): Boolean;
begin
  // not supported
  result := False;
end;



{ --------------------------------------------------------------------------- }

function TWavfile.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    groupID: array[0..3] of AnsiChar;
    riffType: array[0..3] of AnsiChar;
    BytesPerSec: Integer;
    dataSize: Integer;
    wChannels: WORD;
    dwSamplesPerSec: LongInt;
    BytesPerSample:Word;
    BitsPerSample: Word;

    function GotoChunk(ID: AnsiString): Integer;
    var chunkID: array[0..3] of AnsiChar;
        chunkSize: Integer;
    begin
        Result := -1;
        // index of first chunk
        fs.Position := 12;
        repeat
            // read next chunk
            fs.Read(chunkID, 4);
            fs.Read(chunkSize, 4);
            if chunkID <> ID then
                // skip chunk
                fs.Position := fs.Position + chunkSize;
        until (chunkID = ID) or (fs.Position >= fs.Size);

        if chunkID = ID then
            // chunk found,
            // return chunk size
            Result := chunkSize
    end;


begin
    inherited ReadFromFile(aFilename);

    // Reset variables and load file data
    fResetData;
    result := FileErr_None;

    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try
                fFileSize := fs.Size;

                fs.Read(groupID, 4);
                fs.Position := fs.Position + 4; // skip four bytes (file size)
                fs.Read(riffType, 4);
                if (groupID = 'RIFF') and (riffType = 'WAVE') then
                begin
                    // search for format chunk
                    if GotoChunk('fmt ') <> -1 then
                    begin
                        // found it
                        fs.Position := fs.Position + 2;
                        fs.Read(wChannels,2);
                        fChannels := wChannels;

                        fs.Read(dwSamplesPerSec,4);
                        fSampleRate := dwSamplesPerSec;

                        fs.Read(BytesPerSec,4);
                        fs.Read(BytesPerSample,2);
                        fs.Read(BitsPerSample,2);
                        fBitrate := wChannels * BitsPerSample * dwSamplesPerSec ;
                        // search for data chunk
                        dataSize := GotoChunk('data');

                        if dataSize <> -1 then
                            // found it
                            if BytesPerSec <> 0 then
                                fDuration := dataSize DIV BytesPerSec
                            else
                                fDuration := 0;
                    end
                end


            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenR;
        end;
    end
    else
        result := FileErr_NoFile;


    if result = FileErr_None then
    begin
        // Process data if loaded and valid
        fValid := true;

    end;
end;

function TWavfile.RemoveFromFile(aFilename: UnicodeString): TAudioError;
begin
    inherited RemoveFromFile(aFilename);
    result := TagErr_WritingNotSupported;
end;

function TWavfile.WriteToFile(aFilename: UnicodeString): TAudioError;
begin
    inherited WriteToFile(aFilename);
    result := TagErr_WritingNotSupported;
end;


end.
