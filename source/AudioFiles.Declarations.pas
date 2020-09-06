{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2020, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit AudioFiles.Declarations

    * Some basic Declarations and Functions
}

unit AudioFiles.Declarations;

interface

{$I config.inc}


uses Classes, SysUtils, Windows
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

    TBuffer = Array of byte;

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
    TMP3Error = (MP3ERR_None, MP3ERR_NoFile, MP3ERR_FOpenCrt, MP3ERR_FOpenR,
               MP3ERR_FOpenRW, MP3ERR_FOpenW, MP3ERR_SRead, MP3ERR_SWrite,
               ID3ERR_Cache, ID3ERR_NoTag, ID3ERR_Invalid_Header, ID3ERR_Compression,
               ID3ERR_Unclassified,
               MPEGERR_NoFrame );


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

const
      AudioErrorString: Array[TAudioError] of String = (
              'No Error',                                               //FileErr_None,
              'File not found',                                         //FileErr_NoFile,
              'FileCreate failed.',                                     //FileErr_FileCreate,
              'Could not read from file',                               //FileErr_FileOpenR,
              'Could not write into file',                              //FileErr_FileOpenRW,
              'File is read-only',                                      //FileErr_ReadOnly,
              'Reading from stream failed',                             //MP3ERR_StreamRead,
              'Writing to stream failed',                               //MP3ERR_StreamWrite,
              // Id3
              'Caching audiodata failed',                               //Mp3ERR_Cache,
              'No ID3-Tag found',                                       //Mp3ERR_NoTag,
              'Invalid header for ID3v2-Tag',                           //MP3ERR_Invalid_Header,
              'Compressed ID3-Tag found',                               //Mp3ERR_Compression,
              'Unknown ID3-Error',                                      //Mp3ERR_Unclassified,
              // mpeg
              'Invalid MP3-File: No audioframe found',                  //MP3ERR_NoMpegFrame,
              // Ogg
              'Invalid Ogg-Vorbis-File: First Vorbis-Header corrupt',   //OVErr_InvalidFirstPageHeader,
              'Invalid Ogg-Vorbis-File: First Ogg-Page corrupt',        //OVErr_InvalidFirstPage,
              'Invalid Ogg-Vorbis-File: Second Vorbis-Header corrupt',  //OVErr_InvalidSecondPageHeader,
              'Invalid Ogg-Vorbis-File: Second Ogg-Page corrupt',       //OVErr_InvalidSecondPage,
              'Comment too large (sorry, Flogger limitation)',          //OVErr_CommentTooLarge,
              'Backup failed',                                          //OVErr_BackupFailed,
              'Delete backup failed',                                   //OVErr_DeleteBackupFailed,
              'Removing Tag not supported.',                            //OVErr_RemovingNotSupported,
              // Flac
              'Invalid Flac-File',                          //FlacErr_InvalidFlacFile,
              'Metadata-Block exceeds maximum size',        //FlacErr_MetaDataTooLarge,
              'Backup failed',                              //FlacErr_BackupFailed,
              'Delete backup failed',                       //FlacErr_DeleteBackupFailed,
              'Removing Tag not supported.',                //FlacErr_RemovingNotSupported,
               // ApeFiles
               'Invalid Apev2 file',                        //ApeErr_InvalidApeFile,
               'Invalid Apev2Tag',                          //ApeErr_InvalidTag,
               'No Apev2tag found',                         //ApeErr_NoTag,
               // WMA Files
               'Writing not supported on WMA',              //WmaErr_WritingNotSupported,
               // Wav Files
               'Writing not supported on WAV',              //WavErr_WritingNotSupported,
               // M4a Files
               'M4A: 64Bit not supported',                  //M4AErr_64BitNotSupported,
               'M4A: Invalid TopLevelAtom,',                //M4aErr_Invalid_TopLevelAtom,
               'M4A: Invalid UDTA,',                        //M4aErr_Invalid_UDTA,
               'M4A: Invalid METAVersion,',                 //M4aErr_Invalid_METAVersion,
               'M4A: Invalid MDHD,',                        //M4aErr_Invalid_MDHD,
               'M4A: Invalid STSD,',                        //M4aErr_Invalid_STSD,
               'M4A: Invalid STCO,',                        //M4aErr_Invalid_STCO,
               'M4A: Invalid STBL,',                        //M4aErr_Invalid_STBL,
               'M4A: Invalid TRAK,',                        //M4aErr_Invalid_TRAK,
               'M4A: Invalid MDIA,',                        //M4aErr_Invalid_MDIA,
               'M4A: Invalid MINF,',                        //M4aErr_Invalid_MINF,
               'M4A: Invalid MOOV,',                        //M4aErr_Invalid_MOOV,
               'M4A: Invalid Duplicate UDTA,',              //M4aErr_Invalid_DuplicateUDTA,
               'M4A: Invalid Duplicate TRAK,',              //M4aErr_Invalid_DuplicateTRAK,
               'M4A: removing Meta data not supported',     //M4aErr_RemovingNotSupported,

               'File type not supported'                    //FileErr_NotSupportedFileType
               );

    function AudioFileExists(aString: UnicodeString):boolean;
    function AudioExtractFileDrive(aString: UnicodeString): UnicodeString;
    function ConvertUTF8ToString(aUTF8String: UTF8String): UnicodeString;
    function ConvertStringToUTF8(aString: UnicodeString): UTF8String;

    procedure SetStreamEnd(aStream: TStream);
    function GetTempFile: String;

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

function AudioExtractFileDrive(aString: UnicodeString): UnicodeString;
begin
    {$IFDEF USE_TNT_COMPOS}
        result := WideExtractFileDrive(aString);
    {$ELSE}
        result := ExtractFileDrive(aString);
    {$ENDIF}
end;

procedure SetStreamEnd(aStream: TStream);
begin
  if aStream is THandleStream then
    SetEndOfFile((aStream as THandleStream).Handle)
  else
    if aStream is TMemoryStream then
      TMemoryStream(aStream).SetSize(aStream.Position);
end;


//--------------------------------------------------------------------
// Get a temporary filename
//--------------------------------------------------------------------
function GetTempFile: String;
var
  Path: String;
  i: Integer;
begin
  SetLength(Path, 256);
  FillChar(PChar(Path)^, 256 * sizeOf(Char), 0);
  GetTempPath(256, PChar(Path));
  Path := Trim(Path);
  if Path[Length(Path)] <> '\' then
    Path := Path + '\';
  i := 0;
  repeat
    result := Path + 'TagTemp.t' + IntToHex(i, 2);
    inc(i);
  until not FileExists(result);
end;


end.
