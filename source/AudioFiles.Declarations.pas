unit AudioFiles.Declarations;

interface

{$I config.inc}


uses Classes, SysUtils
    {$IFDEF USE_TNT_COMPOS}, TntSysUtils, TntClasses{$ENDIF}
    ;

type
    {$IFNDEF UNICODE}
        UnicodeString = WideString;
    {$ENDIF}

    {$IFDEF USE_TNT_COMPOS}
      TAudioFileStream = TTNTFileStream;
    {$ELSE}
      TAudioFileStream = TFileStream;
    {$ENDIF}

    TAudioFileType = (at_Invalid,
                      at_Mp3,
                      at_Ogg,
                      at_Flac,
                      at_M4A,
                      at_Monkey,
                      at_WavPack,
                      at_MusePack,
                      at_OptimFrog,
                      at_TrueAudio,
                      at_Wma,
                      at_Wav,
                      at_AbstractApe);

    TAudioError = (
          FileErr_None,
          FileErr_NoFile,
          FileErr_FileCreate,
          FileErr_FileOpenR,
          FileErr_FileOpenRW,
          FileErr_ReadOnly,

          MP3ERR_StreamRead,
          MP3ERR_StreamWrite,
          Mp3ERR_Cache,
          Mp3ERR_NoTag,
          MP3ERR_Invalid_Header,
          Mp3ERR_Compression,
          Mp3ERR_Unclassified,
          MP3ERR_NoMpegFrame,

          // OggFiles
          OVErr_InvalidFirstPageHeader,
          OVErr_InvalidFirstPage,
          OVErr_InvalidSecondPageHeader,
          OVErr_InvalidSecondPage,
          OVErr_CommentTooLarge,
          OVErr_BackupFailed,
          OVErr_DeleteBackupFailed,
          OVErr_RemovingNotSupported,

          // FlacFiles
          FlacErr_InvalidFlacFile,
          FlacErr_MetaDataTooLarge,
          FlacErr_BackupFailed,
          FlacErr_DeleteBackupFailed,
          FlacErr_RemovingNotSupported,

          // ApeFiles
          ApeErr_InvalidApeFile,
          ApeErr_InvalidTag,
          ApeErr_NoTag,

          // WMA Files
          WmaErr_WritingNotSupported,

          // Wav Files
          WavErr_WritingNotSupported,

          // M4a Files
          M4AErr_64BitNotSupported,
          M4aErr_Invalid_TopLevelAtom,
          M4aErr_Invalid_UDTA,
          // M4aErr_Invalid_META,
          M4aErr_Invalid_METAVersion,
          M4aErr_Invalid_MDHD,
          M4aErr_Invalid_STSD,
          M4aErr_Invalid_STCO,
          M4aErr_Invalid_STBL,
          M4aErr_Invalid_TRAK,
          M4aErr_Invalid_MDIA,
          M4aErr_Invalid_MINF,
          M4aErr_Invalid_MOOV,
          M4aErr_Invalid_DuplicateUDTA,
          M4aErr_Invalid_DuplicateTRAK,

          M4aErr_RemovingNotSupported,

          //
          FileErr_NotSupportedFileType
          );

const    TAudioFileNames: Array[TAudioFileType] of String =
          ( 'Invalid Audiofile',
            'MPEG Audio',
            'Ogg/Vorbis',
            'Free Lossless Audio Codec',
            'MPEG-4',
            'Monkey''s Audio',
            'WavPack',
            'Musepack',
            'OptimFROG',
            'The True Audio',
            'Windows Media Audio',
            'RIFF WAVE',
            'APE (abstract)');

    function AudioFileExists(aString: UnicodeString):boolean;
    function ConvertUTF8ToString(aUTF8String: UTF8String): UnicodeString;
    function ConvertStringToUTF8(aString: UnicodeString): UTF8String;

implementation

function ConvertUTF8ToString(aUTF8String: UTF8String): UnicodeString;
begin
    {$IFDEF UNICODE}
        result := UnicodeString(aUTF8String);
    {$ELSE}
        result := Utf8Decode(aUTF8String);
    {$ENDIF}
end;

function ConvertStringToUTF8(aString: UnicodeString): UTF8String;
begin
    {$IFDEF UNICODE}
        result := UTF8String(aString);
    {$ELSE}
        result := Utf8Encode(aString);
    {$ENDIF}
end;

function AudioFileExists(aString: UnicodeString):boolean;
begin
    {$IFDEF USE_TNT_COMPOS}
        result := WideFileExists(aString);
    {$ELSE}
        result := FileExists(aString);
    {$ENDIF}
end;

end.
