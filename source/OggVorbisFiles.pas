{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2010-2024, Daniel Gaussmann
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

    Unit OggVorbisFiles

    Manipulate *.ogg files

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

unit OggVorbisFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, ContNrs, Classes,  Dialogs,
  VorbisComments, ID3Basics, OggContainer,
  AudioFiles.Base, AudioFiles.Declarations, BaseVorbisFiles;

type

    TOggIdentificationPacket = class(TOggPacket)
      private
        fVorbisIdentification: TVorbisIdentification;
        procedure StreamDataToRecord;
      public

    end;

    TOggVorbisCommentPacket = class(TOggPacket)
      private
        fComments: TVorbisComments;
        procedure StreamDataToRecord;

      public
        constructor Create;
        destructor Destroy; override;
        procedure Clear; override;
    end;



    {
    MainClass for tagging .ogg-Files
    }
    TOggVorbisFile = class(TBaseVorbisFile)
        private
            fMaxSamples: Integer;
            fBitRateNominal: Word;

            fUsePadding: Boolean;
            fDefaultPadding: Integer;
            fMaxPadding: Integer;

            fIdentificationHeader: TOggIdentificationPacket;
            fCommentHeader: TOggVorbisCommentPacket;
            fSetupHeader: TOggPacket;

            procedure SetMaxPadding(Value: Integer);
            procedure SetDefaultPadding(Value: Integer);

            function ReadIdentificationHeader(aContainer: TOggContainer; Target: TOggIdentificationPacket): TAudioError;
            function ReadCommentHeader(aContainer: TOggContainer; Target: TOggVorbisCommentPacket): TAudioError;
            function ReadSectionHeader(aContainer: TOggContainer; Target: TOggPacket): TAudioError;

        protected
            function GetVorbisComments: TVorbisComments; override;
            function fGetDuration   : Integer;  override;
            function fGetBitrate    : Integer;  override;
            function fGetFileType            : TAudioFileType; override;
            function fGetFileTypeDescription : String;         override;

        public
            property Samples: Integer read fMaxSamples;
            property BitRateNominal: Word read FBitRateNominal; // Nominal bit rate
            property UsePadding: Boolean read fUsePadding write fUsePadding;
            property DefaultPadding: Integer read fDefaultPadding write SetDefaultPadding;
            property MaxPadding: Integer read fMaxPadding write SetMaxPadding;

            constructor Create; override;
            destructor Destroy; override;

            procedure ClearData;
            function ReadFromFile(aFilename: UnicodeString): TAudioError; override;
            function WriteToFile(aFilename: UnicodeString): TAudioError; override;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError; override;
    end;


implementation


{ TOggVorbisFile }

constructor TOggVorbisFile.Create;
begin
    fIdentificationHeader := TOggIdentificationPacket.Create;
    fCommentHeader := TOggVorbisCommentPacket.Create;
    fSetupHeader := TOggPacket.Create;
    fMaxPadding := 25500;
    fDefaultPadding := 2550;
    fUsePadding     := True;

    ClearData;
end;

destructor TOggVorbisFile.Destroy;
begin
    fIdentificationHeader.Free;
    fCommentHeader.Free;
    fSetupHeader.Free;

    inherited;
end;

function TOggVorbisFile.fGetFileType: TAudioFileType;
begin
    result := at_Ogg;
end;

function TOggVorbisFile.fGetFileTypeDescription: String;
begin
    result := cAudioFileType[at_Ogg];
end;

procedure TOggVorbisFile.ClearData;
begin
    fFileSize       := 0;
    fMaxSamples     := 0;
    fSampleRate     := 0;
    fBitRateNominal := 0;
    fValid          := False;
    fChannels       := 0;
    fIdentificationHeader.Clear;
    fCommentHeader.Clear;
    fSetupHeader.Clear;
end;


function TOggVorbisFile.GetVorbisComments: TVorbisComments;
begin
  result := fCommentHeader.fComments;
end;

procedure TOggVorbisFile.SetMaxPadding(Value: Integer);
begin
  if Value >= 0 then
    fMaxPadding := Value;
  if fMaxPadding > 250*255 then
    fMaxPadding := 250*255;
end;

procedure TOggVorbisFile.SetDefaultPadding(Value: Integer);
begin
  if Value >= 0 then
    fDefaultPadding := Value;
  if fDefaultPadding > 250*255 then
    fDefaultPadding := 250*255;
end;


// This function is copied from the "AudioToolsLibrary"
function TOggVorbisFile.fGetDuration: Integer;
begin
  // Calculate duration time
  if fMaxSamples > 0 then
      if fSampleRate > 0 then
          Result := Round(fMaxSamples / fSampleRate)
      else
          Result := 0
  else
      if (fBitRateNominal > 0) and (fChannels > 0) then
          Result := Round((fFileSize {- FID3v2Size}) /
              fBitRateNominal / fChannels / 125 * 2)
      else
          Result := 0;
end;

function TOggVorbisFile.fGetBitrate: Integer;
begin
    // Calculate average bit rate
    if Duration > 0 then
        result := Round((fFileSize - fCommentHeader.Data.Size) * 8  / Duration)
    else
        result := fBitRateNominal * 1000;
end;


function TOggVorbisFile.ReadIdentificationHeader(aContainer: TOggContainer; Target: TOggIdentificationPacket): TAudioError;
begin
  result := aContainer.ReadPacket(Target);

  if result = FileErr_None then begin
    if (aContainer.CurrentPage.SegmentCount <> 1)
        or (Target.Data.Size <> 30)
        or (not Target.FinishesPage)
    then
      result := OVErr_InvalidHeader;
  end;

  if result = FileErr_None then begin
    Target.StreamDataToRecord;

    if not (
             (Target.fVorbisIdentification.PacketType = 1)
         and (Target.fVorbisIdentification.ID = 'vorbis')
         and (Target.fVorbisIdentification.ChannelMode > 0)
         and (Target.fVorbisIdentification.SampleRate > 0)
         and (Target.fVorbisIdentification.StopFlag <> 0) )
    then
      result := OVErr_InvalidHeader;
  end;
end;

function TOggVorbisFile.ReadCommentHeader(aContainer: TOggContainer; Target: TOggVorbisCommentPacket): TAudioError;
begin
  result := aContainer.ReadPacket(Target);
  if result = FileErr_None then begin
    Target.StreamDataToRecord;
    if not Target.fComments.ValidComment then
      result := OVErr_InvalidComment;
  end;
end;

function TOggVorbisFile.ReadSectionHeader(aContainer: TOggContainer; Target: TOggPacket): TAudioError;
begin
  result := aContainer.ReadPacket(Target);
  if not Target.FinishesPage then
    result := OVErr_InvalidHeader;
end;


function TOggVorbisFile.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    OggContainer: TOggContainer;
begin
    inherited ReadFromFile(aFilename);
    ClearData;
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite);
            try
                OggContainer := TOggContainer.Create(fs);
                try
                    fFileSize := fs.Size;

                    result := ReadIdentificationHeader(OggContainer, fIdentificationHeader);
                    if result = FileErr_None then
                      result := ReadCommentHeader(OggContainer, fCommentHeader);
                    if result = FileErr_None then
                      result := ReadSectionHeader(OggContainer, fSetupHeader);

                    // set some private variables from these headers
                    if result = FileErr_None then
                    begin
                        fSampleRate    := fIdentificationHeader.fVorbisIdentification.SampleRate;
                        fChannels      := fIdentificationHeader.fVorbisIdentification.ChannelMode;
                        fBitRateNominal:= fIdentificationHeader.fVorbisIdentification.BitRateNominal;
                        // get number of samples in the File
                        // "GetMaxSample" searches from the end of the file and is usually faster.
                        // However, parsing the complete OggContainer may be safer.
                        fMaxSamples := GetMaxSample(fs);
                        if fMaxSamples <= 0 then
                          fMaxSamples := OggContainer.GetMaxGranulePosition(0);
                        fValid := True;
                    end else
                        fValid := False;
                finally
                    OggContainer.Free;
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


function TOggVorbisFile.WriteToFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    existingContainer: TOggContainer;
    existingIDHdr: TOggIdentificationPacket;
    existingCommentHdr: TOggVorbisCommentPacket;
    existingSetupHeader: TOggPacket;
    backupFilename: String;

    function CacheAudioData: TAudioError;
    var
      CacheStream: TAudioFileStream;
    begin
      result := FileErr_None;
      CacheStream := TAudioFileStream.Create(backupFilename, fmCreate);
      try
        try
          existingContainer.CopyRemainsTo(CacheStream)
        finally
          CacheStream.Free;
        end;
      except
        result := FileErr_BackupFailed;
      end;
    end;

    function RestoreCacheAudioData: TAudioError;
    var
      CacheStream: TAudioFileStream;
    begin
      result := FileErr_None;
      CacheStream := TAudioFileStream.Create(backupFilename, fmOpenRead);
      try
        try
          existingContainer.CopyRemainsFrom(CacheStream, True);
        finally
          CacheStream.Free;
        end;
      except
        result := FileErr_BackupFailed;
      end;
    end;

begin
  inherited WriteToFile(aFilename);

  result := FileErr_NoFile;
  if AudioFileExists(aFilename) then begin
    try
      fs := TAudioFileStream.Create(aFilename, fmOpenReadWrite or fmShareDenyWrite);
      try
        existingContainer := TOggContainer.Create(fs);
        existingIDHdr := TOggIdentificationPacket.Create;
        existingCommentHdr := TOggVorbisCommentPacket.Create;
        existingSetupHeader := TOggPacket.Create;
        try

            fCommentHeader.Data.Clear;
            fCommentHeader.fComments.WriteToStream(fCommentHeader.Data);   // change to method of TVorbisCommentPacket ?

            result := ReadIdentificationHeader(existingContainer, existingIDHdr);
            if result = FileErr_None then begin

              // Store the SerialNumber of the first Page, it may be needed later
              existingContainer.KeepSerial;

              // try to replace the CommentHeader
              // allow max. "100 LacingValues" (~ a half OggPage)
              if not existingContainer.ReplacePacket(fCommentHeader, MaxPadding) then
              begin
                // if a quick replacement of the Comment Header fails, we have to rewrite the whole file
                if fUsePadding then
                  AddZeroPadding(fCommentHeader.Data, DefaultPadding); // add "10 LacingValue", 2550 Bytes of padding

                if result = FileErr_None then
                  result := ReadCommentHeader(existingContainer, existingCommentHdr);
                if result = FileErr_None then
                  result := ReadSectionHeader(existingContainer, existingSetupHeader);

                if result = FileErr_None then begin
                  backupFilename := GetBackupFilename(aFilename);
                  result := CacheAudioData;
                end;

                // now we can rewrite the file
                if result = FileErr_None then begin
                  existingContainer.Reset; // The serial number will stay the same!
                  // Write the 3 Header Packets
                  existingContainer.WritePacket(existingIDHdr, True);
                  existingContainer.WritePacket(fCommentHeader, False);
                  existingContainer.WritePacket(existingSetupHeader, True);
                  // Write the Audio Data
                  RestoreCacheAudioData;  // this will also renumber the pages, if necessary
                  existingContainer.SetEndOfStream;

                  //delete backupfile
                  if not DeleteFile(backupFilename) then
                      result := FileErr_DeleteBackupFailed;
                end;
              end;
            end;

        finally
          existingContainer.Free;
          existingIDHdr.Free;
          existingCommentHdr.Free;
          existingSetupHeader.Free;
        end;

      finally
        fs.Free;
      end;
    except
      result := FileErr_FileOpenRW;
    end;
  end;
end;

function TOggVorbisFile.RemoveFromFile(aFilename: UnicodeString): TAudioError;
begin
    inherited RemoveFromFile(aFilename);
    result := TagErr_RemovingNotSupported;
end;


{ TOggIdentificationPacket }

procedure TOggIdentificationPacket.StreamDataToRecord;
begin
  Data.Position := 0;
  Data.Read(fVorbisIdentification, SizeOf(fVorbisIdentification));
end;

{ TVorbisCommentPacket }

procedure TOggVorbisCommentPacket.Clear;
begin
  inherited;
  fComments.Clear;
end;

constructor TOggVorbisCommentPacket.Create;
begin
  inherited Create;
  fComments := TVorbisComments.Create;
  fComments.ContainerType := octOgg;
end;

destructor TOggVorbisCommentPacket.Destroy;
begin
  fComments.Free;
  inherited;
end;

procedure TOggVorbisCommentPacket.StreamDataToRecord;
begin
  Data.Position := 0;
  fComments.ReadFromStream(Data, Data.Size);
end;

end.
