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

## General concept of this library

You can use this library on different "levels". 

* The first level is super easy to use, but limited in what you can get from the audio files, 
and what you can do with them
* The second level is littel bit more complicated to use, but you'll get more information from the
audio files
* And there is (mainly for mp3) a third level, where you can do some crazy stuff with your files. Like, 
storing another mp3-file within the ID3-tag of anothre mp3-file

See the demo projects for examples.

## Class structure

* Class `TBaseAudioFile` (file AudioFilebasics.pas): An abstract class that declares some basic properties 
like Title, Artist, Album, Duration and some others.
* Classes `TMP3File`, `TOggVorbisFile`, `TFlacFile`, ... (seperate files): Classes for the several 
filetypes, which implement the abstract methods declared in TBaseAudioFile, and may define some more
methodes. These classes are meant for use on "level 2"
* Class `TGeneralAudioFile` (file Audiofiles.pas): A "super class" for use on "level 1". Based on the
filename extension, an instance of one of the previous classes is created. Thus, the programmer (=you)
doesn't need to care about different file formats, when you just want to display the artist and title of
an audio file. Just use something like
```pascal
MainAudioFile := TGeneralAudioFile.Create(someFileName);
EditTitle.Text  := MainAudioFile.Title;
// ... and for editing the file:
MainAudioFile.Title  := EditTitle.Text;
MainAudioFile.UpdateFile;
```
That's it (on level 1)!

