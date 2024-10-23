# AudioWerkzeugeBibliothek (v3.1)

A Delphi library for audio files. 

Read and write meta tags (like artist, title, album, genre, ...) from many different audio formats, and gather information about the audio file (like duration, bitrate, samplerate). AudioWerkzeugeBibliothek comes with a very simple usage for basic information, but it also contains powerful features for an in-depth access to almost all kind of meta data.

Supported Tag formats (**bold: new in v3.0**):

* ID3Tag, Version 1 and 1.1 (mp3, ape, mpc, ofr, tta, wv)
* ID3Tag, Version 2.2, 2.3 and 2.4 (mp3)
* Apev2Tags (mp3, ape, mpc, ofr, tta, wv)
* Vorbis Comments (ogg, flac, **opus**)
* QuickTime Metadata (mp4, m4a)
* WindowsMediaAudio (wma, read-only)

Limitations:

* no support for compression and encryption in ID3v2-Tags.

## New features in version 3.0

* new: Support for Opus-Files
* new: Support for Cover Art in Vorbis Comments
* Extensive refactoring (see below).

### New in version 3.1

+ Property `TTagItem.DataSize`.

+ Added URL frames and Comment to `TID3v2Tag.GetUnusedTextTags`.

+ Method `TOggContainer.ReadPackets(Target: TObjectList)` to get all packets from the OggStream. 

+ Property `TOpusFile.VBR` *(which should be `True` in almost every case)**

+ Methods to read/write Integer atoms in m4a Files. 
  *Note: Use with caution. I need this in my main project "Nemp" for the "tmpo" atom (aka BPM, Beats Per Minute), but this is not widely tested for other atoms. The documentation there is not very helpful, and there are some inconsistencies regarding Signed/Unsigned Integers and the size of the values (8, 16, 24, 32 Bit).*

### Bug fixes in 3.1

* TagType in `TApeTag.GetUnusedTextTags` was `ttVorbis`, correct is `ttApev2`.

* Getter and Setter for `TApeTag.EAN` used different keys.

* Fixed the clutter with Cardinal/Integer type for SerialNumber in OggPages.

* Flac files: deleted deprecated function fIsValid

* Fixed a parsing error regarding OggPages and OggPackets (which had actually no effect on Ogg/Opus files, but on the new method ReadPackets).

## Important note for upgrading from version 2.0

The library AudioWerkzeugeBibliothek originated from several format-specific libraries for mp3, flag, ogg and others. Because of that, there were a lot burden of the past contained in the code. Some duplicates, no consistency in parameter order, type or naming, and some other inconveniences.

With version 3.0, I try to improve the overall consistency and usability of the provided methods. However, it is not possible to do this downward compatible.

There are many, many changes, and you'll need to make corresponding changes in your code.

See ChangeLog for some details.

## General concept of this library

You can use this library on different "levels", but there is not a real differentiation between these levels. You can just use more or less from the features of this library. Depending on what you want to do, it is recommended to know more or less about the inner structure of "audio files".

* The basic properties are super easy to use, but there are limits in what you can get from the audio files, and what you can do with them. You just need to know that there do exist some file types containing "music", which also may contain some "meta data" (like "artist" or "title"), and have some properties (like "duration" or "bitrate").
* If you want to extract more information from the metadata, you should understand that the metadata consists of individual pieces of data. In the context of this library, a single such data set is an object of the `TTagItem` class. Many of these objects contain text information, but images or other binary data are also possible.
* On expert level you can do some crazy stuff with your files. Like, storing another mp3-file within the ID3-Tag of another mp3-file. For this, you should understand a little bit more about the inner structure of ID3Tags on the frame level. This means, that you should know that an ID3v2Tag contains a list of ID3Frames, where each frame consist of a header and the actual data. The same applies to the other tag formats. You can do a lot with the methods in this library - but you'll have to decide whether that really makes sense. ;-)

See the demo projects for examples.

## Class structure

* `TBaseAudioFile` (unit AudioFiles.Base.pas): An abstract class that declares some basic properties like Title, Artist, Album, Duration and some others, which are then implemented in the following `TxxxFile` classes.
* `TMP3File`, `TOggVorbisFile`, `TFlacFile`, ... (seperate units): Classes for the several filetypes, which implement the abstract methods declared in TBaseAudioFile, and may define some more methods. If you want more information about a file, you may need to explicitly access the properties and methods of these derived classes. There are also some "intermediate classes" like
  `TBaseApeFile`  or `TBaseVorbisFile` for several file types that contain APEv2-Tags or Vorbis Comments.
* `TAudioFileFactory` (unit AudioFiles.Factory.pas): The factory class for creating the correct audio file instances based on the file extension.
* `TTagItem` (unit AudioFiles.BaseTags.pas): The abstract base class for all individual elements in a metadata container. Essentially, a "key" and a "value" are provided, supplemented by a few other pieces of information about the data element.
  Derived from this are the classes `TID3v2Frame`,  `TApeTagItem`, `TCommentVector` and some others.
* `TID3v1Tag`, `TID3V2Tag`, `TApeTag`,`TVorbisComments` ... (separate units, no common ancestor): Implementation of the individual metadata containers. Extremely simplified: A list of TTagItems.

## Usage, short overview

### Basics

For beginners, the usage of this library is super easy. Just use the factory to create an object of type `TBaseAudioFile` to display some of the properties, let the user edit some of the values and update the file. Thats all. Works on all supported file formats - mp3, ogg, flac, m4a, it doesn't matter. Same code for all.

```pascal
var
  MainAudioFile: TBaseAudioFile;
// ...
MainAudioFile := AudioFileFactory.CreateAudioFile(aFileName);
MainAudioFile.ReadFromFile(aFileName);
EditTitle.Text := MainAudioFile.Title;
// ... and for editing the file:
MainAudioFile.Title := EditTitle.Text;
MainAudioFile.UpdateFile;
```

Note that you don't need to create (or free) the AudioFileFactory-Object. This is handled by the unit `AudioFiles.Factory.pas` automatically.

See demo "DemoSimple" for details.

**Important note:** The factory is probably not thread-safe. If you want to use it in a secondary thread, you should create another factory within the context of the thread.

### Advanced

If the named properties provided (such as artist, title and others) are not sufficient, there is the AudioFile.GetTagList method (new in version 3 of this library). This allows you to list and edit all data elements in a file.

```pascal
lvMetaTags.Clear; // a ListView on the Form
TagItems := TTagItemList.Create;
try
  AudioFile.GetTagList(TagItems);
  for i := 0 to TagItems.Count - 1 do begin
    newListItem := lvMetaTags.Items.Add;
    newListItem.Data := TagItems[i];
    newListItem.Caption := cTagTypes[TagItems[i].TagType];
    newListItem.SubItems.Add(TagItems[i].Key);
    newListItem.SubItems.Add(TagItems[i].Description);
    newListItem.SubItems.Add(TagItems[i].GetText(tmReasonable));
  end;    
finally
  TagItems.Free;
end;
```

To edit an element from this list, you can use the following code:

```pascal
editItem := TTagItem(lvMetaTags.Selected.Data);
editValue := editItem.GetText(tmReasonable);
if InputQuery('Edit Item', 'New value:', editValue) then begin
  if editValue = '' then
    AudioFile.DeleteTagItem(editItem)
  else
    TTagItem(editItem).SetText(editValue, tmReasonable);
end;
```

#### Some notes about different types of TagItems

While most metadata in audio files contains text, there is some data that has a more complex structure or even contains pure binary data. How the type of data can be recognized differs from format to format. The possible types are also sometimes more and sometimes less differentiated. And there are also some subtleties to consider with the "texts", especially with the ID3v2 tag. There, for example, "lyrics" contain not only the text itself, but also some additional data - e.g. the language.
For this purpose, the Audio Werkzeuge Bibliothek provides the enumeration types `teTagContentType` and `teTextMode`. The TagContentType provides information about the type of content. In addition to a few generally valid types (`tctText, tctPicture, tctBinary`), there are various format-specific types such as `tctLyrics` or `tctUserText` for ID3v2, `tctExternal` for Apev2 or `tctGenre` for M4A files.
For some of these types, it is reasonable to consider them as text, even if they have a different internal structure and should be treated separately. The TextMode parameter can be set to `tmReasonable` for this purpose. When reading the data, `tmForced` is also available. Binary data is then also displayed in text form (non-printable characters are replaced with dots ".").

The method `AudioFile.GetTagList(TagItems);`has an optional parameter, where you can define which kind of tags you want to be included in the TagItems list.

`procedure GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes);`

The default value will return all kinds of tags that can be interpreted as text, i.e.

`cDefaultTagContentTypes = [tctText, tctComment, tctLyrics, tctURL, tctUserText, tctUserURL, tctExternal, tctTrackOrDiskNumber, tctGenre, tctSpecialText];`

#### Pictures

Most metadata container allow more than one picture, aka "Cover Art". If you want to display the cover art, you need to get a list of all picture tag items first.

```pascal
picList := TTagItemList.Create;
try
  AudioFile.GetTagList(picList, [tctPicture]);
  if picList.Count > 0 then begin
    // show first picture in the list, or try to get the "Front Cover"
    // here: Just diplay the first one in the list (which ist often 
    // the only one)
    stream := TMemoryStream.Create;
    try    
      if picList[0].GetPicture(stream, Mime, PicType, Description) 
      then begin
        Stream.Position := 0;
        // Modern versions of Delphi also recognize the graphic type when
        // using LoadFromStream
        // For older versions, you may have to adapt the code depending 
        // on the mimetype.
        Image1.Picture.LoadFromStream(Stream);
      end;
    finally
      stream.Free;
    end;
  end;
finally
  picList.Free;
end;
```

See demo "DemoExtended" for details.

### Expert

At expert level, you no longer use the basic class `TBaseAudioFile` that often. Instead, you work directly with the derived classes and the specific metadata containers.

As this gives you very basic access to the files and their internal structure, you can also do a lot of nonsense with them, which may lead to problems with other programs. Be it because you do not adhere to the documented standard or because you break generally recognized unofficial rules. Writing an ID3v2 tag in an Ogg file is possible, but certainly not a good idea. Neither is writing a Vorbis comment to an mp3 file.

Use the options provided with caution - especially with write access.

See demo "DemoMp3" for more details of what is possible (but not always recommended, some players may stumble about these files then).

## Remarks about some heuristics used in this library

Several audio formats may contain different kinds of meta data within the file. This library uses the following assumptions

* Mp3 files usually contain ID3v1 and ID3v2-Tags. When using the class `TMP3File`, it is usually ensured that both versions stay consistent in the file. 

* Mp3 files sometimes also contain an APEv2-Tag. This tag is now also fully processed by class `TMP3File`. Setting basic properties will ensure that all meta tags remain consistent. Make sure that property `TagsToBeWritten` contains `mt_Existing` (which is the default value).

* There is no standard key defined for "Lyrics" in Vorbis comments and Apev2 tags. According to my research, the following variants are in use: `UNSYNCEDLYRICS`, `UNSYNCED LYRICS` (with a space) and `LYRICS`. These three keys are taken into account when reading 'Lyrics'. When writing, the existing key is used. If none of the three variants is available, the key set in the global variable `AWB_DefaultLyricsKey` is used. The default value is `UNSYNCEDLYRICS`.

* All audio formats using APEv2-Tags by default (Monkey, WavPack, Musepack, OptimFrog, TrueAudio) may also contain ID3v1- and ID3v2-Tags. The `TxxxFile` classes for those formats do now fully process the ID3v1-Tag. The existence of an ID3v2-Tag is detected (and it's size is considered for the calculation of the duration, if needed), but otherwise ignored.

* For mp3 files and ape-based files, you may use properties `TagsToBeWritten`, `TagsToBeDeleted` and `DefaultTags` to decide which meta tags are written/removed into/from the file when using the method `UpdateFile` or  `RemoveFromFile`. The default settings are
  
  ```Pascal
  // for mp3 files
  TagsToBeWritten := [mt_Existing];
  DefaultTags     := [mt_ID3v1, mt_ID3v2]; // **
  TagsToBeDeleted := [mt_Existing];
  // for ApeV2-based file formats
  TagsToBeWritten := [mt_Existing];
  DefaultTags     := [mt_ID3v1, mt_APE]; // **
  TagsToBeDeleted := [mt_Existing];
  // ** used when there are no meta tags at all
  ```

### Mp3 specific reading

If you're scanning multiple files for meta data (for example to store the data into a media library), you may want just the "title", but you don't care whether it comes from the ID3v2- or the ID3v1-Tag. To speed up the scanning (at least this is the hope), the property `TagScanMode`is introduced. Possible values are

```pascal
TTagScanMode = (id3_read_complete, id3_read_smart, id3_read_v2_only );
```

Default value is `id3_read_complete`, where all contained Tags are processed. The option`id3_read_smart`will check the ID3v2-Tag first. This meta tag is more complex, but it needs to be read anyway to get to the audio meta data like bitrate, duration and other stuff. In smart mode, the ID3v1-Tag is only read from the file, if there is no proper ID3v2-Tag containing Artist, Title, Album, Track, Year and Genre. If you also want the "Comment" field included, set  `fSmartRead_IgnoreComment` to `False`.

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

This library should work with all Delphi versions from **Delphi 7** to **Delphi 12** . However, there are some things to keep in mind with older versions without built-in Unicode support (= before Delphi 2009).

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
