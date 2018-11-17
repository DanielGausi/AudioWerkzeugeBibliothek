program DemoExtended;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainFormAPE},
  NewPicture in 'NewPicture.pas' {NewPic},
  Apev2Tags in '..\source\Apev2Tags.pas',
  ApeTagItem in '..\source\ApeTagItem.pas',
  MonkeyFiles in '..\source\MonkeyFiles.pas',
  WavPackFiles in '..\source\WavPackFiles.pas',
  MusePackFiles in '..\source\MusePackFiles.pas',
  OptimFrogFiles in '..\source\OptimFrogFiles.pas',
  TrueAudioFiles in '..\source\TrueAudioFiles.pas',
  AudioFileBasics in '..\source\AudioFileBasics.pas',
  FlacFiles in '..\source\FlacFiles.pas',
  OggVorbisFiles in '..\source\OggVorbisFiles.pas',
  VorbisComments in '..\source\VorbisComments.pas',
  Mp3Files in '..\source\Mp3Files.pas',
  Id3Basics in '..\source\Id3Basics.pas',
  Id3v2Frames in '..\source\Id3v2Frames.pas',
  Mp3FileUtils in '..\source\Mp3FileUtils.pas',
  U_CharCode in '..\source\U_CharCode.pas',
  AudioFiles in '..\source\AudioFiles.pas',
  WmaFiles in '..\source\WmaFiles.pas',
  WavFiles in '..\source\WavFiles.pas',
  M4aAtoms in '..\source\M4aAtoms.pas',
  M4aFiles in '..\source\M4aFiles.pas',
  ID3GenreList in '..\source\ID3GenreList.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFormAPE, MainFormAPE);
  Application.CreateForm(TNewPic, NewPic);
  Application.Run;
end.
