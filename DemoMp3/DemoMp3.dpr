program DemoMp3;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UNewFrame in 'UNewFrame.pas' {FormNewFrame},
  ID3GenreList in '..\source\ID3GenreList.pas',
  Id3v2Frames in '..\source\Id3v2Frames.pas',
  Mp3FileUtils in '..\source\Mp3FileUtils.pas',
  U_CharCode in '..\source\U_CharCode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormNewFrame, FormNewFrame);
  Application.Run;
end.
