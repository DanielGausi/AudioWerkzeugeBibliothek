program DemoSimple;

uses
  Forms,
  SimpleMain in 'SimpleMain.pas' {SimpleTagger},
  ApeTagItem in '..\source\ApeTagItem.pas',
  Apev2Tags in '..\source\Apev2Tags.pas',
  AudioFileBasics in '..\source\AudioFileBasics.pas',
  AudioFiles in '..\source\AudioFiles.pas',
  FlacFiles in '..\source\FlacFiles.pas',
  Id3Basics in '..\source\Id3Basics.pas',
  Id3v2Frames in '..\source\Id3v2Frames.pas',
  MonkeyFiles in '..\source\MonkeyFiles.pas',
  Mp3Files in '..\source\Mp3Files.pas',
  Mp3FileUtils in '..\source\Mp3FileUtils.pas',
  MusePackFiles in '..\source\MusePackFiles.pas',
  OggVorbisFiles in '..\source\OggVorbisFiles.pas',
  OptimFrogFiles in '..\source\OptimFrogFiles.pas',
  TrueAudioFiles in '..\source\TrueAudioFiles.pas',
  U_CharCode in '..\source\U_CharCode.pas',
  VorbisComments in '..\source\VorbisComments.pas',
  WavPackFiles in '..\source\WavPackFiles.pas',
  WavFiles in '..\source\WavFiles.pas',
  WmaFiles in '..\source\WmaFiles.pas',
  ID3GenreList in '..\source\ID3GenreList.pas',
  M4aAtoms in '..\source\M4aAtoms.pas',
  M4aFiles in '..\source\M4aFiles.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSimpleTagger, SimpleTagger);
  Application.Run;
end.
