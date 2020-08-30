unit SimpleMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FileCtrl, StdCtrls, AudioFiles.Factory, AudioFiles.Base, AudioFiles.Declarations;

type
  TSimpleTagger = class(TForm)
    GroupBox1: TGroupBox;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    GroupBox2: TGroupBox;
    EdtTitle: TEdit;
    EdtArtist: TEdit;
    EdtAlbum: TEdit;
    EdtGenre: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    EdtYear: TEdit;
    EdtTrack: TEdit;
    Label6: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    BtnSave: TButton;
    procedure FileListBox1Change(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
  private
    { Private-Deklarationen }
    MainAudioFile: TBaseAudioFile;
  public
    { Public-Deklarationen }
  end;

var
  SimpleTagger: TSimpleTagger;

implementation

{$R *.dfm}

procedure TSimpleTagger.FileListBox1Change(Sender: TObject);
begin
    if FileListBox1.FileName = '' then
        exit;

    if assigned(MainAudioFile) then
        MainAudioFile.Free;

    MainAudioFile := AudioFileFactory.CreateAudioFile(FileListBox1.FileName);
    if assigned(MainAudioFile) then
    begin
        MainAudioFile.ReadFromFile(FileListBox1.FileName);

        EdtTitle.Text  := MainAudioFile.Title;
        EdtArtist.Text := MainAudioFile.Artist;
        EdtAlbum.Text  := MainAudioFile.Album;
        EdtGenre.Text  := MainAudioFile.Genre;
        EdtYear.Text   := MainAudioFile.Year;
        EdtTrack.Text  := MainAudioFile.Track;
        Memo1.Clear;
        Memo1.Lines.Add(Format('Type:      %s',       [MainAudioFile.FileTypeDescription] ));
        Memo1.Lines.Add(Format('FileSize   %d Bytes', [MainAudioFile.FileSize]     ));
        Memo1.Lines.Add(Format('Duration   %d sec',   [MainAudioFile.Duration]     ));
        Memo1.Lines.Add(Format('Bitrate    %d kBit/s',[MainAudioFile.Bitrate div 1000]));
        Memo1.Lines.Add(Format('Samplerate %d Hz',    [MainAudioFile.Samplerate]   ));
        Memo1.Lines.Add(Format('Channels:  %d',       [MainAudioFile.Channels]     ));
    end else
    begin
        EdtTitle.Text  := '';
        EdtArtist.Text := '';
        EdtAlbum.Text  := '';
        EdtGenre.Text  := '';
        EdtYear.Text   := '';
        EdtTrack.Text  := '';
        Memo1.Clear;
    end;
end;

procedure TSimpleTagger.BtnSaveClick(Sender: TObject);
begin
    if assigned(MainAudioFile) then
    begin
        MainAudioFile.Title  := EdtTitle.Text ;
        MainAudioFile.Artist := EdtArtist.Text;
        MainAudioFile.Album  := EdtAlbum.Text ;
        MainAudioFile.Genre  := EdtGenre.Text ;
        MainAudioFile.Year   := EdtYear.Text  ;
        MainAudioFile.Track  := EdtTrack.Text ;
        MainAudioFile.UpdateFile;
    end;
end;

end.


