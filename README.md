# AudioWerkzeugeBibliothek

A delphi library for audio files.

Read and write meta tags from audio files like mp3, ogg (Ogg-Vorbis), flac, m4a, 
ape (Monkey), wv (WavPack), mpc (Musepack), ofr (OptimFrog), tta (TrueAudio). Also, 
quite limited, wma (WindowsMediaAudio) and wav (both read-only).

Suported Tag formats:

* ID3Tag, Version 1 and 1.1 (mp3)
* ID3Tag, Version 2.2, 2.3 and 2.4 (mp3)
* Apev2Tags (ape, mpc ofr, tta, wv)
* Vorbis Comments (ogg, flac)
* QuickTime Metadata (mp4, m4a)

Limitations:
* no support for Cover Art (and other binary data) in Ogg Vorbis comments
* no support for compression and encryption in ID3Tags.

## Unicode and compatibility to older Delphi versions

This library should work with all Delphi versions from **Delphi 7** to **Delphi 10.2** (Tokyo). However, there are some things to keep in mind with older versions without built-in Unicode support (= before Delphi 2009).

*Note*: I use "Unicode" here in the meaning of "more than ANSI". That's not 100% accurate, but I hope you know what I'm saying. ;-)

### The VCL and filenames with Unicode characters

Before Delphi 2009, the VCL was ANSI-only and did not support Unicode. This includes the display of strings with Unicode characters and opening files with Unicode characters in their filenames. For that, there has been a collection of components called "TNTUnicodeControls". Older versions of this collection were available under a Creative Commons license, and should still be found somewhere.

This library can make use of these controls by activating a compiler switch in the file `config.inc`. Just remove the "." in the line `{.$DEFINE USE_TNT_COMPOS}`.

Within the library itself the TNTs are used for the class `TNTFileStream`. Of course you can use other Unicode capable filestream classes as well. Just adjust these lines of code according to your needs: (files: AudioFileBasics.pas, Mp3FileUtils.pas and ID3v2Frames.pas)
```
{$IFDEF USE_TNT_COMPOS}
	TAudioFileStream = TTNTFileStream;  
{$ELSE}
	TAudioFileStream = TFileStream;
{$ENDIF}
```

If you are using an older Delphi Version without TNTUnicodeControls, this library will still work, but you can't open files with filenames like "จักรพรรณ์ อาบครบุรี - 10 เท่านี้ก็ตรม.mp3". When you try to display information about title and artist from such a file (after renaming it), you will see only some "?????" instead of the actual title. Note that rewriting the ID3-Tag under such conditions could lead to data loss.

*Note*: The sample projects do not use the TNTControls (like TTNTEdit instead of TEdit). Be careful there with older Delphis. ;-)

Newer Delphi versions (2009 and later) have built-in Unicode support, and therefore the use of these TNTUnicodeControls is not needed. In addtion, the definition of the type `UnicodeString` is not needed there. This is the reason for this compiler switch, which can be found in some of the files as well.
```
{$IFNDEF UNICODE}
	UnicodeString = WideString;
{$ENDIF}
```

## General concept of this library

You can use this library on different "levels". There is not a real differentiation between these levels. You can just use more or less from the features of this library. Depending on what you want to do, it is recommended to know more or less about the inner structure of "audio files".

* The first level is super easy to use, but limited in what you can get from the audio files, 
and what you can do with them. You just need to know that there are exist some file types containing "music", which also may
contain some "meta data" (like Artist or Title).
* The second level is little bit more complicated to use, but you'll get more information from the
audio files. You should know that there are different types of audio files like mp3 and ogg files, and that these different kind of files use different ways to store the meta data (like ID3-Tags or Vorbis Comments), and you should try to get an overwiew about how these ways look like.
* And there is (for mp3) a third level, where you can do some crazy stuff with your files. Like, 
storing another mp3-file within the ID3-tag of another mp3-file. For this, you should understand a little bit more about the inner structure of ID3Tags on the frame level. This means, that you should know that an ID3Tag contains a list of ID3Frames, where each frame consist of a header and the actual data.

### Possibilities on these levels:

* Level 1: Display (and edit, where possible) basic information like Artist, Title, Album, Duration, Bitrate and some more
* Level 2: Display (and edit) lyrics (different languages), Cover Art and other images, all available textual data and some more
* Level 3: Add your own private frames to an mp3 file, access to arbitrary binary frames

See the demo projects for examples.

## Class structure

* Class `TBaseAudioFile` (file AudioFilebasics.pas): An abstract class that declares some basic properties 
like Title, Artist, Album, Duration and some others.
* Classes `TMP3File`, `TOggVorbisFile`, `TFlacFile`, ... (seperate files): Classes for the several 
filetypes, which implement the abstract methods declared in TBaseAudioFile, and may define some more
methods. These classes are meant for use on "level 2". Some of these "file classes" are not inherited
directly from TBaseAudioFile, but from a "BaseTagTypeClass" like `TBaseApeFile`
* Class `TGeneralAudioFile` (file Audiofiles.pas): A "super class" for use on "level 1". Based on the
filename extension, an instance of one of the previous classes is created. Thus, the programmer (=you)
doesn't need to care about different file formats, when you just want to display the artist and title of
an audio file. 

## Usage, short overview

### Level 1
On "level 1", the usage of this library is super easy. Just create an object of type `TGeneralAudioFile` 
display some of the properties, let the user edit some of the values and update the file. Thats all. Works 
on all supported file formats - mp3, ogg, flac, m4a, it doesn't matter. Same code for all.
```pascal
MainAudioFile := TGeneralAudioFile.Create(someFileName);
EditTitle.Text := MainAudioFile.Title;
// ... and for editing the file:
MainAudioFile.Title := EditTitle.Text;
MainAudioFile.UpdateFile;
```
See demo "DemoSimple" for details.

### Level 2
On the second level, you have access to some more information, but you need to understand that there are 
different types of audio file, and each type contains a different structure. You start with the same code
as above, but after this you need to access the hidden type of the file
```pascal
MainAudioFile := TGeneralAudioFile.Create(someFileName);
EditTitle.Text := MainAudioFile.Title;

case MainAudioFile.FileType of
  
  at_Invalid: begin
      ShowMessage('Invalid AudioFile');
  end;
  
  at_Mp3: begin
      if not assigned(ID3v2Frames) then  // a TObjectList storing all "Frames" of the ID3Tag
          ID3v2Frames:= TObjectList.Create(False);

      // note that ".mp3File" only exists, if the file type is actual mp3!
      // note also, that we get only all TEXT frames here, not really all frames (with binary data)
      MainAudioFile.MP3File.ID3v2Tag.GetAllTextFrames(ID3v2Frames);

      // display all frames on the form
      lbKeys.Items.Clear; // a TListBox on the Form
      for i := 0 to ID3v2Frames.Count - 1 do
      begin
          iFrame := TID3v2Frame(ID3v2Frames[i]);
          lbKeys.AddItem(iFrame.FrameTypeDescription, iFrame);
      end;

      MemoSpecific.Lines.Add(Format('ID3v1    : %d Bytes', [MainAudioFile.MP3File.ID3v1TagSize]));
      MemoSpecific.Lines.Add(Format('ID3v2    : %d Bytes', [MainAudioFile.MP3File.ID3v2TagSize]));
  end;

  at_Ogg: begin
      MainAudioFile.OggFile.GetAllFields(lbKeys.Items);      
  end;

// ...

// display of the selected frame, e.g. in OnClick of lbKeys 
case MainAudioFile.FileType of
    at_Invalid: ;
    at_Mp3: MemoValue.Text := TID3v2Frame(lbKeys.Items.Objects[lbKeys.ItemIndex]).GetText;
    at_Ogg: MemoValue.Text := MainAudioFile.OggFile.GetPropertyByFieldname(lbKeys.Items[lbKeys.ItemIndex]);
    at_Flac: MemoValue.Text := MainAudioFile.FlacFile.GetPropertyByFieldname(lbKeys.Items[lbKeys.ItemIndex]);
    at_Monkey,
    at_WavPack,
    at_MusePack,
    at_OptimFrog,
    at_TrueAudio: MemoValue.Text := MainAudioFile.BaseApeFile.GetValueByKey(lbKeys.Items[lbKeys.ItemIndex]);
end;
```
You may also have access to other information like Cover Art here. See demo "DemoExtended" for details.

### Level 3

The "expert level" is only for mp3 files with the ID3v2-Tag. Originally this was only a project 
called "Mp3fileUtils", so I know a lot more stuff about mp3 files than about other files. Also, the 
documentation for ID3Tags is the best I have ever seen. ;-)

On this level, you may have access to the raw data of the frames within the ID3v2 Tag. With this, you 
can read and write your own "private" frames, that only your software will understand, but doesn't disturbe
other programs. A lot of mp3-players do that, and these private frames are meant exactly for such purposes.

See demo "DemoMp3" for more details of what is possible (but not always recommended, some players 
may stumble about these files then).
