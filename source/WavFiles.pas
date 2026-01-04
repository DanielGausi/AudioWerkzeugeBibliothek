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
          fWaveCodec: String;
          function GetCodecName(aFormatTag: Word): string;
            
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

            function ReadFromStream(aStream: TStream): TAudioError; override;

        public
            { Public declarations }
            property WaveCodec: String read fWaveCodec; 
            
            constructor Create; override;          

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
    Clear;
end;

function Twavfile.fGetFileType: TAudioFileType;
begin
    result := at_Wav;

end;

function Twavfile.fGetFileTypeDescription: String;
begin
    result := cAudioFileType[at_Wav];
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


function Twavfile.GetCodecName(aFormatTag: Word): string;
begin
  // source: https://www.iana.org/assignments/wave-avi-codec-registry/wave-avi-codec-registry.xhtml
  case aFormatTag of
    $0000	: Result := 'Unknown';
    $0001	: Result := 'PCM (Uncompressed)';
    $0002	: Result := 'Microsoft ADPCM Format';
    $0003	: Result := 'IEEE Float';
    $0004	: Result := 'Compaq Computer''s VSELP';
    $0005	: Result := 'IBM CVSD';
    $0006	: Result := 'Microsoft ALAW';
    $0007	: Result := 'Microsoft MULAW';
    $0010	: Result := 'OKI ADPCM';
    $0011	: Result := 'Intel''s DVI ADPCM';
    $0012	: Result := 'Videologic''s MediaSpace ADPCM';
    $0013	: Result := 'Sierra ADPCM';
    $0014	: Result := 'G.723 ADPCM';
    $0015	: Result := 'DSP Solution''s DIGISTD';
    $0016	: Result := 'DSP Solution''s DIGIFIX';
    $0017	: Result := 'Dialogic OKI ADPCM';
    $0018	: Result := 'MediaVision ADPCM';
    $0019	: Result := 'HP CU';
    $0020	: Result := 'Yamaha ADPCM';
    $0021	: Result := 'Speech Compression''s Sonarc';
    $0022	: Result := 'DSP Group''s True Speech';
    $0023	: Result := 'Echo Speech''s EchoSC1';
    $0024	: Result := 'Audiofile AF36';
    $0025	: Result := 'APTX';
    $0026	: Result := 'AudioFile AF10';
    $0027	: Result := 'Prosody 1612';
    $0028	: Result := 'LRC';
    $0030	: Result := 'Dolby AC2';
    $0031	: Result := 'GSM610';
    $0032	: Result := 'MSNAudio';
    $0033	: Result := 'Antex ADPCME';
    $0034	: Result := 'Control Res VQLPC';
    $0035	: Result := 'Digireal';
    $0036	: Result := 'DigiADPCM';
    $0037	: Result := 'Control Res CR10';
    $0038	: Result := 'NMS VBXADPCM';
    $0039	: Result := 'Roland RDAC';
    $003A	: Result := 'EchoSC3';
    $003B	: Result := 'Rockwell ADPCM';
    $003C	: Result := 'Rockwell Digit LK';
    $003D	: Result := 'Xebec';
    $0040	: Result := 'Antex Electronics G.721';
    $0041	: Result := 'G.728 CELP';
    $0042	: Result := 'MSG723';
    $0050	: Result := 'MPEG Layer 1/2';
    $0052	: Result := 'RT24';
    $0053	: Result := 'PAC';
    $0055	: Result := 'MP3 (MPEG Layer 3)';
    $0059	: Result := 'Lucent G.723';
    $0060	: Result := 'Cirrus';
    $0061	: Result := 'ESPCM';
    $0062	: Result := 'Voxware';
    $0063	: Result := 'Canopus Atrac';
    $0064	: Result := 'G.726 ADPCM';
    $0065	: Result := 'G.722 ADPCM';
    $0066	: Result := 'DSAT';
    $0067	: Result := 'DSAT Display';
    $0069	: Result := 'Voxware Byte Aligned';
    $0070	: Result := 'Voxware AC8';
    $0071	: Result := 'Voxware AC10';
    $0072	: Result := 'Voxware AC16';
    $0073	: Result := 'Voxware AC20';
    $0074	: Result := 'Voxware MetaVoice';
    $0075	: Result := 'Voxware MetaSound';
    $0076	: Result := 'Voxware RT29HW';
    $0077	: Result := 'Voxware VR12';
    $0078	: Result := 'Voxware VR18';
    $0079	: Result := 'Voxware TQ40';
    $0080	: Result := 'Softsound';
    $0081	: Result := 'Voxware TQ60';
    $0082	: Result := 'MSRT24';
    $0083	: Result := 'G.729A';
    $0084	: Result := 'MVI MV12';
    $0085	: Result := 'DF G.726';
    $0086	: Result := 'DF GSM610';
    $0088	: Result := 'ISIAudio';
    $0089	: Result := 'Onlive';
    $0091	: Result := 'SBC24';
    $0092	: Result := 'Dolby AC3 SPDIF';
    $0097	: Result := 'ZyXEL ADPCM';
    $0098	: Result := 'Philips LPCBB';
    $0099	: Result := 'Packed';
    $0100	: Result := 'Rhetorex ADPCM';
    $0101	: Result := 'BeCubed Software''s IRAT';
    $0111	: Result := 'Vivo G.723';
    $0112	: Result := 'Vivo Siren';
    $0123	: Result := 'Digital G.723';
    $0200	: Result := 'Creative ADPCM';
    $0202	: Result := 'Creative FastSpeech8';
    $0203	: Result := 'Creative FastSpeech10';
    $0220	: Result := 'Quarterdeck';
    $0300	: Result := 'FM Towns Snd';
    $0400	: Result := 'BTV Digital';
    $0680	: Result := 'VME VMPCM';
    $1000	: Result := 'OLIGSM';
    $1001	: Result := 'OLIADPCM';
    $1002	: Result := 'OLICELP';
    $1003	: Result := 'OLISBC';
    $1004	: Result := 'OLIOPR';
    $1100	: Result := 'LH Codec';
    $1400	: Result := 'Norris';
    $1401	: Result := 'ISIAudio';
    $1500	: Result := 'Soundspace Music Compression';
    $2000	: Result := 'AC3 DVM';
    $FFFE : Result := 'Extensible (WAVE_FORMAT_EXTENSIBLE)';
  else
    Result := Format('Unknown (0x%.4x)', [aFormatTag]);
  end;  
end;


{ --------------------------------------------------------------------------- }

function Twavfile.ReadFromStream(aStream: TStream): TAudioError;
var
    groupID: array[0..3] of AnsiChar;
    riffType: array[0..3] of AnsiChar;
    BytesPerSec: Integer;
    dataSize: Integer;
    wFormatTag: WORD;
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
        aStream.Position := 12;
        repeat
            // read next chunk
            aStream.Read(chunkID, 4);
            aStream.Read(chunkSize, 4);
            if chunkID <> ID then
                // skip chunk
                aStream.Position := aStream.Position + chunkSize;
        until (chunkID = ID) or (aStream.Position >= aStream.Size);

        if chunkID = ID then
            // chunk found,
            // return chunk size
            Result := chunkSize
    end;
begin
  fFileSize := aStream.Size;
  result := FileErr_None;

  aStream.Read(groupID, 4);
  aStream.Position := aStream.Position + 4; // skip four bytes (file size)
  aStream.Read(riffType, 4);
  if (groupID = 'RIFF') and (riffType = 'WAVE') then
  begin
      // search for format chunk
      if GotoChunk('fmt ') <> -1 then
      begin
          // found it
          // aStream.Position := aStream.Position + 2;
          aStream.Read(wFormatTag, 2);
          fWaveCodec := GetCodecName(wFormatTag);
          aStream.Read(wChannels,2);
          fChannels := wChannels;

          aStream.Read(dwSamplesPerSec,4);
          fSampleRate := dwSamplesPerSec;

          aStream.Read(BytesPerSec,4);
          aStream.Read(BytesPerSample,2);
          aStream.Read(BitsPerSample,2);
          fBitrate := wChannels * BitsPerSample * dwSamplesPerSec ;
          // search for data chunk
          dataSize := GotoChunk('data');

          if dataSize <> -1 then begin
              // found it
              if BytesPerSec <> 0 then
                  fDuration := dataSize DIV BytesPerSec
              else
                  fDuration := 0;
          end;

          if (dataSize >= 0) and (fBitrate = 0) and (fDuration <> 0) then begin
            // for compressed files, it is often BitsPerSample = 0, therefore the calculated Bitrate is also zero.
            // in that case: get the Bitrate by the datasize and duration
            fBitrate := Round(dataSize * 8 / fDuration);

          end;

          fValid := true;
      end
  end else
    result := FileErr_Invalid;
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
