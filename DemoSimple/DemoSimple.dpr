program DemoSimple;

uses
  Forms,
  SimpleMain in 'SimpleMain.pas' {SimpleTagger},
  ApeTagItem in '..\source\ApeTagItem.pas',
  Apev2Tags in '..\source\Apev2Tags.pas',
  AudioFiles.Base in '..\source\AudioFiles.Base.pas',
  AudioFiles.Declarations in '..\source\AudioFiles.Declarations.pas',
  AudioFiles.Factory in '..\source\AudioFiles.Factory.pas',
  BaseApeFiles in '..\source\BaseApeFiles.pas',
  FlacFiles in '..\source\FlacFiles.pas',
  Id3Basics in '..\source\Id3Basics.pas',
  ID3GenreList in '..\source\ID3GenreList.pas',
  ID3v1Tags in '..\source\ID3v1Tags.pas',
  Id3v2Frames in '..\source\Id3v2Frames.pas',
  ID3v2Tags in '..\source\ID3v2Tags.pas',
  LanguageCodeList in '..\source\LanguageCodeList.pas',
  M4aAtoms in '..\source\M4aAtoms.pas',
  M4aFiles in '..\source\M4aFiles.pas',
  MonkeyFiles in '..\source\MonkeyFiles.pas',
  Mp3Files in '..\source\Mp3Files.pas',
  MpegFrames in '..\source\MpegFrames.pas',
  MusePackFiles in '..\source\MusePackFiles.pas',
  OggVorbisFiles in '..\source\OggVorbisFiles.pas',
  OptimFrogFiles in '..\source\OptimFrogFiles.pas',
  TrueAudioFiles in '..\source\TrueAudioFiles.pas',
  U_CharCode in '..\source\U_CharCode.pas',
  VorbisComments in '..\source\VorbisComments.pas',
  WavFiles in '..\source\WavFiles.pas',
  WavPackFiles in '..\source\WavPackFiles.pas',
  WmaFiles in '..\source\WmaFiles.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSimpleTagger, SimpleTagger);
  Application.Run;
end.
