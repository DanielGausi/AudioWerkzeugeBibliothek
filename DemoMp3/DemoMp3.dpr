program DemoMp3;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UNewFrame in 'UNewFrame.pas' {FormNewFrame},
  Id3v2Frames in '..\Id3v2Frames.pas',
  Mp3FileUtils in '..\Mp3FileUtils.pas',
  U_CharCode in '..\U_CharCode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormNewFrame, FormNewFrame);
  Application.Run;
end.
