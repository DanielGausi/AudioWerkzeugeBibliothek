program DemoExtended;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainFormAWB},
  NewPicture in 'NewPicture.pas' {NewPic},
  Apev2Tags in '..\source\Apev2Tags.pas',
  ApeTagItem in '..\source\ApeTagItem.pas',
  MonkeyFiles in '..\source\MonkeyFiles.pas',
  WavPackFiles in '..\source\WavPackFiles.pas',
  MusePackFiles in '..\source\MusePackFiles.pas',
  OptimFrogFiles in '..\source\OptimFrogFiles.pas',
  TrueAudioFiles in '..\source\TrueAudioFiles.pas',
  FlacFiles in '..\source\FlacFiles.pas',
  OggVorbisFiles in '..\source\OggVorbisFiles.pas',
  VorbisComments in '..\source\VorbisComments.pas',
  Mp3Files in '..\source\Mp3Files.pas',
  Id3Basics in '..\source\Id3Basics.pas',
  Id3v2Frames in '..\source\Id3v2Frames.pas',
  MpegFrames in '..\source\MpegFrames.pas',
  U_CharCode in '..\source\U_CharCode.pas',
  WmaFiles in '..\source\WmaFiles.pas',
  WavFiles in '..\source\WavFiles.pas',
  M4aAtoms in '..\source\M4aAtoms.pas',
  M4aFiles in '..\source\M4aFiles.pas',
  ID3GenreList in '..\source\ID3GenreList.pas',
  AudioFiles.Base in '..\source\AudioFiles.Base.pas',
  AudioFiles.Declarations in '..\source\AudioFiles.Declarations.pas',
  AudioFiles.Factory in '..\source\AudioFiles.Factory.pas',
  BaseApeFiles in '..\source\BaseApeFiles.pas',
  ID3v1Tags in '..\source\ID3v1Tags.pas',
  ID3v2Tags in '..\source\ID3v2Tags.pas',
  LanguageCodeList in '..\source\LanguageCodeList.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFormAWB, MainFormAWB);
  Application.CreateForm(TNewPic, NewPic);
  Application.Run;
end.
