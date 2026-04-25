# AudioWerkzeugeBibliothek (v3.3)

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

### Bug fixes and changes in 3.3

* Restored compatibilty to older Delphi versions (Delphi 7 and up)

* Basic method `TBaseAudioFile.GetPicture()` now returns a picture labeled as "Front Cover" by preference.

* Using `Nil` as destination stream in `TBaseAudioFile.GetPicture()` is possible now. In that case, only the pictures meta data is returned. 

* The function `TBaseAudioFile.SetPicture()` now prefers to replace an image of the same type. If none is available, the first one is replaced.

* New method `TBaseAudioFile.AddPicture()`. *Please read the section "Pictures and cover art" for details about this.*

* m4a files: Mime Type "image/png" was not set properly.


### Bug fixes and changes in 3.2

* Adding cover art to Flac files did not work properly. The mime type was not written correctly to the file, so some players could not display the cover.

* Fixed some issues regarding duplicate identifiers in properties and method parameters.

* Renamed property `TTagItem.Description` to `TTagItem.ReadableKey` to avoid mix-ups with the picture description in picture tags derived from TTagItem.

* Added public properties `TFlacFile.BitsPerSample` und `TFlacFile.Samples`.

* The field "nominal bitrate" (used as a backup for bitrate and duration calculation) in the OggVorbis Identification Header was misinterpreted (in kbit/s instead of bit/s).

* Bitrate was calculated as 0 for compressed wav files.

* Added property `TWavfile.WaveCodec`.

* Better exception handling: 
  Removed  `MessageBox(..)` from the exception block in some methods, added optional `out` parameter `aExceptionMessage` instead. 
  Added property `TBaseAudioFile.LastExceptionMessage`. This can be used to get more information about the last exception occured during a read/write operation on files.

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

### Bug fixes and changes in 3.1.1

* Fixed some possible Range Exceptions in "Rating" and "Private" ID3v2-Frames

### New features in version 3.0

- new: Support for Opus-Files
- new: Support for Cover Art in Vorbis Comments
- Extensive refactoring (see below).

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

You can also use `MainAudioFile.GetPicture(aStream, Mime, PicType, Description)` to get some cover art from the file. `aStream` will contain the actual picture data, `Mime`, `Pictype`and `Description` are `out` parameters containing additional meta data about the picture.
However, this is not always *that* simple.

Note that you don't need to create (or free) the AudioFileFactory-Object. This is handled by the unit `AudioFiles.Factory.pas` automatically.

See demo "DemoSimple" for details.

### Pictures and cover art

In many cases, it's pretty simple: The audio file contains an embedded image, often the album's "cover art (front)". You can use `MainAudioFile.GetPicture(aStream, Mime, PicType, Description)` to copy the actual picture data into `aStream` and display the picture in a `TImage` component. 

In some cases however, it is *not* that simple. Because most meta data formats support more than one picture element. A picture element often includes information about the image type - for example, "Front Cover", "Back Cover", or "Bright colored fish" (*the latter of which seems to be some kind of inside joke that no one understands*). However, it is often also possible to store multiple images of the same type in the metadata.

As I wrote before: Sometimes it's not that simple.

At the basic level, which uses only the basic functions from `TBaseAudioFile`, the following applies:

* `MainAudioFile.GetPicture()` will return a picture of the type "Front Cover". If there is more than one "Front Cover", the first one is returned. If there is no "Front Cover", the first picture element is returned, regardless of the type.

If you want to *add* an image, you'll face similar challenges at the basic level: Do you want to replace the image, or add a new one? And if there are already more than one, which one should be replaced?

At the basic level, `TBaseAudioFile` will work as follows when setting or adding picture data:

1. The meta tag currently contains no picture 
    * `MainAudioFile.SetPicture(SourceStream, aMime, aPicType, aDescription)` will add a picture element of type `aPicType` to the meta data.
    * `MainAudioFile.AddPicture(...)` will do the same.

2. The meta tag currently contains exactly one picture
    * `MainAudioFile.SetPicture(SourceStream, aMime, aPicType, aDescription)` will *replace* the current picture element with the new one. The picture type and description will be changed as well.
        * Special case APEv2 tags: This library does not support changing the picture type of existing picture elements in the APEv2 tags. *See "Notes regarding various metadata formats" below for more about this.* 
        Therefore, `SetPicture()` will replace the existing image with the new one, only if the current type matches `aPicType`. Otherwise, i.e. if the picture types are different, a new picture element is added to the meta tag.        
    
    * `MainAudioFile.AddPicture(SourceStream, aMime, aPicType, aDescription, true)` will *replace* the current picture element, if it's type is equal to `aPictype`. Otherwise, a new picture element is added to the meta tag. *The last boolean parameter is named `WantUniqueByType`*.
        
    * `MainAudioFile.AddPicture(SourceStream, aMime, aPicType, aDescription, false)` will  *add* a new picture element, even if the existing element is of the same type.
        * Special cases `aPictype` is `ptIcon32` or `ptOtherIcon`. All supported meta tag formats allow only one element for each of these two types. Therefore `MainAudioFile.AddPicture()` will *replace* the existing image, even if the parameter `WantUniqueByType` is set to `false`.
        * Special case APEv2 tags: This tag format does not allow multiple images of the same type. Therefore, the last parameter `WantUniqueByType` is ignored for filetypes with APEv2 tags.

3. The meta tag currently contains more than one picture
    * `MainAudioFile.SetPicture(SourceStream, aMime, aPicType, aDescription)` will *replace* the first picture element of type `aPicType`. If there is no element of this type, the first picture element is replaced, regardless of it's type. *The comments regarding Apev2 in case (2) also apply here.*        

    *  `MainAudioFile.AddPicture(SourceStream, aMime, aPicType, aDescription, true)` will *replace* the first picture element of type `aPicType`, if there is one. Otherwise, a new picture element is added to the meta tag.

    * `MainAudioFile.AddPicture(SourceStream, aMime, aPicType, aDescription, false)`. See case (2)

#### Notes regarding various metadata formats

* For ID3v2 tags (used in mp3 files), the `Description` field within the picture elements must be unique. At the basic level, this library ensures that the description remains unique when adding or modifying picture elements. To do this, a counter (1), (2), ... is automatically added to the passed description in case of conflicts.

* The difference between APEv2 and other formats is as follows: In other formats (which are essentially based on the format used in ID3v2 tags), the list looks like this (in very simplified terms):\
` PicElement1 = Type, ImageData; PicElement2 = Type, ImageData; PicElement3 = Type, ImageData; ...`\
In APEv2 tags, the type is part of the key: `FrontCoverPic = ImageData; BackCoverPic = ImageData; ComposerPic = ImageData; BrightColouredFishPic = ImageData; ...`\
As the key of each element must be unique, there is only one picture element of each type allowed in this format. Also (by design of this library) a tag element cannot change it's own key, and therefore it is not possible to change the picture type of an element afterwards in APEv2 tags.

* This library offers only limited support for cover art in m4a/mp4 files. There is only one picture element supported by this library. Therefore, `SetPicture()` and `AddPicture()` will always replace the existing image.

* No support for cover art in wma and wav files.
    

### Advanced

If you want to display more information than the values provided by the basic properties like artist, title, duration and some others, you'll need to write a few more lines of code.

One option to display all text information from the meta tag is to use the `AudioFile.GetTagList()` method. This allows you to list and edit all data elements in a file.

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

Another option would be to directly access the meta data in the different file types. To do this, however, you must check the file type and cast the `TBaseAudioFile` variable to the specific class in order to access the format-specific properties. For example, to retrieve the disc number, you can use the following code

```pascal
  case AudioFile.FileType of
      at_Invalid: ;
      at_Mp3:  CD  := TMp3File(AudioFile).ID3v2Tag.GetText(IDv2_PARTOFASET); 
      at_Ogg: CD := TOggVorbisFile(AudioFile).GetPropertyByFieldname(VORBIS_DISCNUMBER);
      at_Opus: CD := TOpusFile(AudioFile).GetPropertyByFieldname(VORBIS_DISCNUMBER);
      at_Flac: CD := TFlacFile(AudioFile).GetPropertyByFieldname(VORBIS_DISCNUMBER);
      at_M4A: CD := TM4aFile(AudioFile).Disc;
      at_Monkey,
      at_WavPack,
      at_MusePack,
      at_OptimFrog,
      at_TrueAudio: CD := TBaseApeFile(AudioFile).ApeTag.GetValueByKey(APE_DISCNUMBER);
      at_Wma: ; // N/A
      at_wav: ; // N/A
  end;
```

Predefined keys for some other properties can be found in the Units `ID3v2Frames.pas`, `VorbisComments`, `ApeTagItem.pas` and `M4aAtoms.pas`. Some meta tag formats also allow arbitrary keys (with certain syntactic restrictions). You can use your own key names - but this is generally not recommended, so that the metadata can be interpreted properly by other applications as well.



#### Some notes about different types of TagItems

While most meta data in audio files contains text, there is some data that has a more complex structure or even contains pure binary data. How the type of data can be recognized differs from format to format. The possible types are also sometimes more and sometimes less differentiated. And there are also some subtleties to consider with the "texts", especially with the ID3v2 tag. There, for example, "lyrics" contain not only the text itself, but also some additional data - e.g. the language.
For this purpose, the Audio Werkzeuge Bibliothek provides the enumeration types `teTagContentType` and `teTextMode`. The TagContentType provides information about the type of content. In addition to a few generally valid types (`tctText, tctPicture, tctBinary`), there are various format-specific types such as `tctLyrics` or `tctUserText` for ID3v2, `tctExternal` for Apev2 or `tctGenre` for M4A files.
For some of these types, it is reasonable to consider them as text, even if they have a different internal structure and should be treated separately. The TextMode parameter can be set to `tmReasonable` for this purpose. When reading the data, `tmForced` is also available. Binary data is then also displayed in text form (non-printable characters are replaced with dots ".").

The method `AudioFile.GetTagList(TagItems);`has an optional parameter, where you can define which kind of tags you want to be included in the TagItems list.

`procedure GetTagList(Dest: TTagItemList; ContentTypes: TTagContentTypes = cDefaultTagContentTypes);`

The default value will return all kinds of tags that can be interpreted as text, i.e.

`cDefaultTagContentTypes = [tctText, tctComment, tctLyrics, tctURL, tctUserText, tctUserURL, tctExternal, tctTrackOrDiskNumber, tctGenre, tctSpecialText];`

If you want to list all embedded Pictures, you can use the ContentType `tctPicture`:

```pascal
picList := TTagItemList.Create;
try
  AudioFile.GetTagList(picList, [tctPicture]);
  if picList.Count > 0 then begin
    // Add items to some GUI element - TComboBox, ListView, whatever
  end;
finally
  picList.Free; // the tag items will not be destroyed here, only the list
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
