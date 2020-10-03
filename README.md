# AudioWerkzeugeBibliothek (v2.0)

A Delphi library for audio files. 

Read and write meta tags (like artist, title, album, genre, ...) from many different audio formats, and gather information about the audio file (like duration, bitrate, samplerate). AudioWerkzeugeBibliothek comes with a very simple usage for basic information, but it also contains powerful features for an in-depth access to almost all kind of meta data.

Supported Tag formats (**bold: new in v2.0**):

* ID3Tag, Version 1 and 1.1 (mp3, **ape, mpc, ofr, tta, wv**)
* ID3Tag, Version 2.2, 2.3 and 2.4 (mp3)
* Apev2Tags (**mp3**, ape, mpc, ofr, tta, wv)
* Vorbis Comments (ogg, flac)
* QuickTime Metadata (mp4, m4a)
* WindowsMediaAudio (wma, read-only)

Limitations:
* no support for Cover Art (and other binary data) in Ogg Vorbis comments
* no support for compression and encryption in ID3Tags.

## Important changes in version 2.0

* Instead of a "super class" TGeneralAudioFile I use now a factory pattern. This has some effect on how you create instances of `TAudioFiles`, and how you access file-type-specific class methods.
* The constructor of the "File-Classes" does NOT automatically read information from the file any longer. This has to be done by `ReadfromFile(filename)`now. The reason for this change is, that some classes (= TMP3File) have now some options how exactly the information is gathered from the file.
* The unit `MP3FileUtils.pas` was split into several units, and some legacy code from it has been removed (like the type `TMP3Error`).
* Several changes in the usage of some classes. For example for the class `TMP3File`, there is now a property `TagsToBeWritten`, which is a set of `TMetaTag = (mt_Existing, mt_ID3v1, mt_ID3v2, mt_APE)`, defining which tags should be written when using `UpdatFile` . The former property of type `TTagWriteMode = (id3_both, id3_v1, id3_v2, id3_existing);` wasn't flexible enough to be extended to three different supported meta tags.

## General concept of this library

You can use this library on different "levels", but there is not a real differentiation between these levels. You can just use more or less from the features of this library. Depending on what you want to do, it is recommended to know more or less about the inner structure of "audio files".

* The first level is super easy to use, but limited in what you can get from the audio files, and what you can do with them. You just need to know that there do exist some file types containing "music", which also may contain some "meta data" (like artist or title), and have some properties (like duration or bitrate).
* The second level is little bit more complicated to use, but you'll get more information from the audio files (like Lyrics and Cover Art). You should know that there are different types of audio files like mp3 and ogg files, and that these different kind of files use different ways to store the meta data (like ID3-Tags or Vorbis Comments), and you should try to get an overview about how these ways look like.
* And there is a third level, where you can do some crazy stuff with your files. Like, storing another mp3-file within the ID3-Tag of another mp3-file. For this, you should understand a little bit more about the inner structure of ID3Tags on the frame level. This means, that you should know that an ID3v2Tag contains a list of ID3Frames, where each frame consist of a header and the actual data. 

See the demo projects for examples.

## Class structure

* `TAudioFileFactory` (unit AudioFiles.Factory.pas): The factory for use on "level 1". Based on the filename extension, an instance of one of the file-classes is created. Thus, the programmer (=you) doesn't need to care about different file formats, when you just want to display the artist, title and duration of an audio file.
* `TBaseAudioFile` (unit AudioFiles.Base.pas): An abstract class that declares some basic properties  like Title, Artist, Album, Duration and some others, which are then implemented in the following `TxxxFile`  classes.
* `TMP3File`, `TOggVorbisFile`, `TFlacFile`, ... (seperate units): Classes for the several filetypes, which implement the abstract methods declared in TBaseAudioFile, and may define some more methods. These classes are meant for use on "level 2". The file classes for the more exotic audio formats using the Apev2Tag as default tagging mechanism, are inherited not directly inherited from TBaseAudioFile, but from a `TBaseApeFile` , which handles the Apev2 and ID3v1-Tags for all classes like `TMonkeyFile` and `TMusePackFile`.
* `TID3v1Tag`, `TID3V2Tag`, `TApeTag`,`TVorbisComments` ... (separate units): Classes for a more direct manipulation of the specific tag formats. 

## Usage, short overview

### Level 1
On "level 1", the usage of this library is super easy. Just use the factory to create an object of type `TBaseAudioFile` to display some of the properties, let the user edit some of the values and update the file. Thats all. Works on all supported file formats - mp3, ogg, flac, m4a, it doesn't matter. Same code for all.
The AudioFileFactory will make sure, that the correct actual class is created. 

```pascal
var
  MainAudioFile: TBaseAudioFile;
// ...
MainAudioFile := AudioFileFactory.CreateAudioFile(someFileName);
MainAudioFile.ReadFromFile(someFileName);
EditTitle.Text := MainAudioFile.Title;
// ... and for editing the file:
MainAudioFile.Title := EditTitle.Text;
MainAudioFile.UpdateFile;
```
Note that you don't need to create (or free) the AudioFileFactory-Object. This is handled by the unit `AudioFiles.Factory.pas` automatically.

See demo "DemoSimple" for details.

**Important note:** The factory is not thread-safe. If you want to use it in a secondary thread, you **must** create another factory within the context of the thread.

### Level 2

On the second level, you have access to some more information, but you need to understand that there are different types of audio files, and each type contains a different structure. You start with the same code as above, but after this you need to access the hidden type of the file.
```pascal
MainAudioFile := AudioFileFactory.CreateAudioFile(someFileName);
MainAudioFile.ReadFromFile(someFileName);
EditTitle.Text := MainAudioFile.Title;

case MainAudioFile.FileType of
  at_Mp3: begin
    // a TObjectList storing all "Frames" of the ID3v2Tag
    // This list is not only used in this method, so it should be a more global variable
    if not assigned(ID3v2Frames) then  
      ID3v2Frames := TObjectList.Create(False);
    // Cast the TBaseAudioFile to TMP3File to access mp3-specific data      
    TMP3File(MainAudioFile).ID3v2Tag.GetAllTextFrames(ID3v2Frames);
    // display all frames on the form
    lbKeys.Items.Clear; // a TListBox on the Form
    for i := 0 to ID3v2Frames.Count - 1 do
    begin
      iFrame := TID3v2Frame(ID3v2Frames[i]);
      lbKeys.AddItem(iFrame.FrameTypeDescription, iFrame);
    end;
  end;

  at_Ogg: begin
    TOggFile(MainAudioFile).GetAllFields(lbKeys.Items);      
  end;
end;

// ...

// display of the selected frame, e.g. in OnClick of lbKeys 
case MainAudioFile.FileType of
  at_Invalid: ;
  at_Mp3: MemoValue.Text := TID3v2Frame(lbKeys.Items.Objects[lbKeys.ItemIndex]).GetText;
  at_Ogg: MemoValue.Text := TOggVorbisFile(MainAudioFile).GetPropertyByFieldname(lbKeys.Items[lbKeys.ItemIndex]);
  at_Flac: MemoValue.Text := TFlacFile(MainAudioFile).GetPropertyByFieldname(lbKeys.Items[lbKeys.ItemIndex]);
  at_M4a:  MemoValue.Text := TM4aFile(MainAudioFile).GetTextDataByDescription(lbKeys.Items[lbKeys.ItemIndex]);
  at_Monkey,
  at_WavPack,
  at_MusePack,
  at_OptimFrog,
  at_TrueAudio: MemoValue.Text := TBaseApeFile(MainAudioFile).GetValueByKey(lbKeys.Items[lbKeys.ItemIndex]);
end;
```
You may also have access to other information like Cover-Art here. See demo "DemoExtended" for details.

### Level 3

On the "expert level" you don't use the classes `TxxxFile` any more, but you read and write the meta tags directly, using the `TXXXTags` classes. With that, you can read and write other meta data (like ID3v2-Tags in flac-files). Not everything that is possible is actually recommended. Adding "non-standard" tags to other file formats may cause problems with other tagging software or even players, which deny playback of the file after adding not supported meta data.

You may also make full usage of the features of  the class `TID3v2Tag`. With this, you can read and write your own "private" frames, that only your software will understand, but doesn't disturb other programs. A lot of mp3-players do that, and these private frames are meant exactly for such purposes.

See demo "DemoMp3" for more details of what is possible (but not always recommended, some players may stumble about these files then).

## Remarks about some heuristics used in this library

Several audio formats may contain different kinds of meta data within the file. This library uses the following assumptions

* Mp3 files usually contain ID3v1 and ID3v2-Tags. When using the class `TMP3File`, it is usually ensured that both versions stay consistent in the file. 

* Mp3 files sometimes also contain an APEv2-Tag. This tag is now also fully processed by class `TMP3File`. Setting basic properties will ensure that all meta tags remain consistent. Make sure that property `TagsToBeWritten` contains `mt_Existing` (which is the default value).

* All audio formats using APEv2-Tags by default (Monkey, WavPack, Musepack, OptimFrog, TrueAudio) may also contain ID3v1- and ID3v2-Tags. The `TxxxFile` classes for those formats do now fully process the ID3v1-Tag. The existence of an ID3v2-Tag is detected (and it's size is considered for the calculation of the duration, if needed), but otherwise ignored.

* For mp3 files and ape-based files, you may use properties `TagsToBeWritten`, `TagsToBeDeleted` and `DefaultTags` to decide which meta tags are written/removed into/from the file when using the method `UpdateFile` or  `RemoveFromFile`. The default settings are

  ``` Pascal
  // for mp3 files
  TagsToBeWritten := [mt_Existing];
  DefaultTags     := [mt_ID3v1, mt_ID3v2]; // used when there are no meta tags at all
  TagsToBeDeleted := [mt_Existing];
  // for ApeV2-based file formats
  TagsToBeWritten := [mt_Existing];
  DefaultTags     := [mt_ID3v1, mt_APE]; // used when there are no meta tags at all
  TagsToBeDeleted := [mt_Existing];
  ```

### Mp3 specific reading

If you're scanning multiple files for meta data (for example to store the data into a media library), you may want just the "title", but you don't care whether it comes from the ID3v2- or the ID3v1-Tag. To speed up the scanning (at least this is the hope), the new property `TagScanMode`is introduced. Possible values are
```pascal
TTagScanMode = (id3_read_complete, id3_read_smart, id3_read_v2_only );
```
Default value is `id3_read_smart`, where the ID3v2-Tag is checked first. This meta tag is more complex, but it needs to be read anyway to get to the audio meta data like bitrate, duration and other stuff. The ID3v1-Tag is only read from the file, if there is no proper ID3v2-Tag containing Artist, Title, Album, Track, Year and Genre. If you also want the "Comment" field included, set  `fSmartRead_IgnoreComment` to `False`.

If you change one of these properties through the setters of class `TMP3File`, the property `fSmartRead_AvoidInconsistentData` (default: `True`) will ensure that also the ID3v1-Tag is properly processed, so that `UpdateFile` will write both ID3v1- and ID3v2-Tag with consistent data (according to the setting of `TagWriteMode`).

**Note:** for ape-based files this is not needed. Detecting Ape-Tags always require checking (and reading) ID3v1-Tags as well, so there is no significant speedup possible.

### Duration and average bitrate in mp3 files with VBR

Usually, mp3 files encoded with variable bitrate contain a so-called XING-Header (or something similar) containing additional data needed for a quick calculation of the duration of the file. Recently I found some files without such a XING-Header, resulting in much longer calculated durations, and way too low bitrates (i.e. 32 kbit/s). This *was* not an issue only for this library, but still *is* for many other libraries.

For such files, the new property `TMP3File.MpegScanMode` is introduced. Possible values are
```pascal
TMpegScanMode = (MPEG_SCAN_Fast, MPEG_SCAN_Smart, MPEG_SCAN_Complete);
```
* `MPEG_SCAN_Fast` scans the file just as before, in good faith that a VBR file contains a XING-Header (or something equivalent). This works very well in most cases.
* `MPEG_SCAN_Smart` checks, whether the result from the fast scan does make sense. If the calculated bitrate is 32 kbit/s (or even lower, which would be actually invalid), then there is probably something wrong. Therefore, the file is completely processed, scanning each and every MPEG-Frame. Note that most mp3 files start with a little moment of silence. An encoder set to "VBR" will likely use the minimum possible amount of space to encode this - which is 32kbit/s.
* `MPEG_SCAN_Complete` always sans the complete file. This leads to the most accurate durations, but also require much more time.

The default mode is `MPEG_SCAN_Smart`.


## Unicode and compatibility to older Delphi versions

This library should work with all Delphi versions from **Delphi 7** to **Delphi 10.3** (probably 10.4 as well). However, there are some things to keep in mind with older versions without built-in Unicode support (= before Delphi 2009).

*Note*: I use "Unicode" here in the meaning of "more than ANSI". That's not 100% accurate, but I hope you know what I'm saying. ;-)

### The VCL and filenames with Unicode characters

Before Delphi 2009, the VCL was ANSI-only and did not support Unicode. This includes the display of strings with Unicode characters and opening files with Unicode characters in their filenames. For that, there has been a collection of components called "TNTUnicodeControls". Older versions of this collection were available under a Creative Commons license, and should still be found somewhere.

This library can make use of these controls by activating a compiler switch in the file `config.inc`. Just remove the "." in the line `{.$DEFINE USE_TNT_COMPOS}`.

Within the library itself the TNTs are used for the class `TNTFileStream`. Of course you can use other Unicode capable FileStream classes as well. Just adjust these lines of code according to your needs: (file: AudioFiles.Declarations.pas)
```pascal
{$IFDEF USE_TNT_COMPOS}
	TAudioFileStream = TTNTFileStream;  
{$ELSE}
	TAudioFileStream = TFileStream;
{$ENDIF}
```

If you are using an older Delphi Version without TNTUnicodeControls, this library will still work, but you can't open files with filenames like "จักรพรรณ์ อาบครบุรี - 10 เท่านี้ก็ตรม.mp3". When you try to display information about title and artist from such a file (after renaming it), you will see only some "?????" instead of the actual title. Note that rewriting the meta tags under such conditions could lead to data loss.

*Note*: The sample projects do not use the TNTControls (like TTNTEdit instead of TEdit). Be careful there with older Delphis. ;-)

Newer Delphi versions (2009 and later) have built-in Unicode support, and therefore the use of these TNTUnicodeControls is not needed. In addition, the definition of the type `UnicodeString` is not needed there. This is the reason for this compiler switch:
```
{$IFNDEF UNICODE}
	UnicodeString = WideString;
{$ENDIF}
```

### TDictionary vs. TObjectList

In version 2.0 of this library, I use a factory pattern for the different types of audiofiles. A class for a specific audio file format is registered in the factory class. For managing all registered classes, the factory class uses a TDictionary by default. If your Delphi version doesn't support TDictionary, undefine its usage in the `confic.inc`. In that case, a regular TObjectList will be used for that.

```
{$DEFINE USE_DICTIONARY}
```

To increase access speed in the TObjectList, it is implemented as a self-organizing list, using the "transpose method". If an audio file with a specific filename extension is created through the factory, this extension/class will be moved upwards in the list, reducing the time to find it again.

## Bug fixes and "odd" audio files

This library should correctly read information from all kind of audio files in most cases. However, there are some odd audio files "in the wild", using methods or variants not properly handled by this library. I think that after severals years I'm coping with almost everything right now, but there could be still some rare cases that I'm missing.

If you found a bug, or if you have some audio files (especially mp3 files!), where the methods of this library provide wrong data, please contact me and/or send some sample files to [mail@gausi.de](mailto:mail@gausi.de).

*But I can't (and will not) fix everything. The most craziest thing I have ever seen was an ID3v2Tag with the following encoding: UTF-16 (fine), null-terminated (more or less standard), starting with a BOM (ok...), character-by-character (wtf...?) - yes, no kidding. A total of 6 bytes per character ...* 

