unit Unit1;

interface

{$DEFINE USE_PNG}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ContNrs,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, JPEG, MpegFrames, ID3v1Tags, ID3v2Tags, ID3v2Frames,
  AudioFiles.Declarations, AudioFiles.BaseTags,
  ExtDlgs, ShellApi {$IFDEF USE_PNG}, PNGImage, Vcl.Mask{$ENDIF};

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    OpenPictureDialog1: TOpenPictureDialog;
    GroupBox1: TGroupBox;
    Label52: TLabel;
    Label53: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Lblv2_Unsynced: TLabel;
    Lblv2_Compression: TLabel;
    Lblv2_ExtendedHeader: TLabel;
    Lblv2_Version: TLabel;
    Lblv2_Size: TLabel;
    Lblv2_Experimental: TLabel;
    Lblv2_Footer: TLabel;
    Lblv2_UnknownFlags: TLabel;
    GroupBox13: TGroupBox;
    PCFrameContent: TPageControl;
    TSText: TTabSheet;
    Ed4_Text: TLabeledEdit;
    TSComments: TTabSheet;
    Label16: TLabel;
    Ed4_CommentLanguage: TLabeledEdit;
    Ed4_CommentDescription: TLabeledEdit;
    Ed4_CommentValue: TMemo;
    TSURLUserDefined: TTabSheet;
    ed4_UserDefURLDescription: TLabeledEdit;
    Ed4_UserDefURLValue: TLabeledEdit;
    TSURL: TTabSheet;
    Ed4_URL: TLabeledEdit;
    TSCoverArt: TTabSheet;
    Label18: TLabel;
    Ed4_Pic: TImage;
    Ed4_PicMime: TLabeledEdit;
    ed4_cbPictureType: TComboBox;
    Ed4_PicDescription: TLabeledEdit;
    BtnLoadPic: TButton;
    TSBinary: TTabSheet;
    Label2: TLabel;
    Ed4_DataMemo: TMemo;
    GrpBoxExpert: TGroupBox;
    cbGroupID: TCheckBox;
    EdGroupID: TLabeledEdit;
    CBUnsync: TCheckBox;
    Label3: TLabel;
    GroupBox14: TGroupBox;
    Label19: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    LblTagAlter: TLabel;
    LblFileAlter: TLabel;
    LblReadOnly: TLabel;
    LblSize: TLabel;
    LblUnknownFlags: TLabel;
    LblEncryption: TLabel;
    LblGrouped: TLabel;
    LblUnsynced: TLabel;
    LblLengthIndicator: TLabel;
    LblCompression: TLabel;
    Btn_ExtractData: TButton;
    SaveDialog1: TSaveDialog;
    BtnVisitURL: TButton;
    Btn_VisitUserDefURL: TButton;
    Bevel1: TBevel;
    CB_UsePadding: TCheckBox;
    BtnDeleteTag: TButton;
    Label4: TLabel;
    Lblv2_UsedSize: TLabel;
    BtnApplyChange: TButton;
    BtnAddFrame: TButton;
    BtnSaveToFile: TButton;
    BtnDeleteFrame: TButton;
    TSPrivate: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    edtPrivateDescription: TLabeledEdit;
    memoPrivateFrame: TMemo;
    Label7: TLabel;
    BtnUndo: TButton;
    BtnSavePicture: TButton;
    GroupBox2: TGroupBox;
    CBFrameTypeSelection: TComboBox;
    LVFrames: TListView;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    edtCurrentFilename: TEdit;
    BtnSelectFile: TButton;
    Label8: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnSelectFileClick(Sender: TObject);
    procedure LVFramesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure CBFrameTypeSelectionChange(Sender: TObject);
    procedure BtnLoadPicClick(Sender: TObject);
    procedure BtnDeleteFrameClick(Sender: TObject);
    procedure CBUnsyncClick(Sender: TObject);
    procedure Btn_ExtractDataClick(Sender: TObject);
    procedure BtnVisitURLClick(Sender: TObject);
    procedure Btn_VisitUserDefURLClick(Sender: TObject);
    procedure BtnDeleteTagClick(Sender: TObject);
    procedure CB_UsePaddingClick(Sender: TObject);
    procedure BtnSaveToFileClick(Sender: TObject);
    procedure BtnApplyChangeClick(Sender: TObject);
    procedure BtnAddFrameClick(Sender: TObject);
    procedure BtnSavePictureClick(Sender: TObject);
    procedure LVFramesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure BtnUndoClick(Sender: TObject);
  private
    { Private-Deklarationen }
    fNewPictureDataLoaded: Boolean;
    fNewPictureData: TMemoryStream;
    fCurrentFilename: String;
    procedure FillFrameView;
    procedure RefreshButtons;
    procedure ShowTagInfo;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  Id3v2Tag: TId3v2Tag;


implementation

uses UNewFrame;

{$R *.dfm}

function BoolToYesNo(b: Boolean): string;
begin
  if b then result := 'yes' else result := 'no';
end;

procedure TForm1.FormCreate(Sender: TObject);
var i: TPictureType;
begin
  Id3v2Tag := TId3v2Tag.Create;

  for i := Low(TPictureType) to High(TPictureType) do
    ed4_cbPictureType.Items.Add(cPictureTypes[i]);

  fNewPictureDataLoaded := False;
  TSText.TabVisible := False;
  TSComments.TabVisible := False;
  TSURL.TabVisible := False;
  TSURLUserDefined.TabVisible := False;
  TSCoverArt.TabVisible := False;
  TSPrivate.TabVisible := False;
  TSBinary.TabVisible := False;

  PCFrameContent.ActivePageIndex := 0;
  fNewPictureData := TMemoryStream.Create;
  fCurrentFilename := '';
  RefreshButtons;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  LVFrames.Items.Clear;
  Id3v2Tag.Free;
  fNewPictureData.Free;
end;

procedure TForm1.BtnSelectFileClick(Sender: TObject);
begin
    if Opendialog1.Execute then
    begin
        edtCurrentFilename.Text := Opendialog1.FileName;
        fCurrentFilename := OpenDialog1.FileName;
        ShowTagInfo;
    end;
end;

procedure TForm1.BtnUndoClick(Sender: TObject);
begin
  ShowTagInfo;
end;

procedure TForm1.ShowTagInfo;
begin
  if (fCurrentFilename <> '') and (FileExists(fCurrentFilename)) then begin
    Id3v2Tag.ReadFromFile(fCurrentFilename);
    FillFrameView;
    Lblv2_Version         .Caption := id3v2Tag.VersionString;
    Lblv2_Size            .Caption := IntToStr(id3v2Tag.Size);
    Lblv2_UsedSize        .Caption := IntToStr(id3v2Tag.Size - id3v2Tag.PaddingSize);
    Lblv2_ExtendedHeader  .Caption := BoolToYesNo( id3v2Tag.FlgExtended      );
    Lblv2_Experimental    .Caption := BoolToYesNo( id3v2Tag.FlgExperimental  );
    Lblv2_Footer          .Caption := BoolToYesNo( id3v2Tag.FlgFooterPresent );
    Lblv2_Unsynced        .Caption := BoolToYesNo( id3v2Tag.FlgUnsynch       );
    Lblv2_Compression     .Caption := BoolToYesNo( id3v2Tag.FlgCompression   );
    Lblv2_UnknownFlags    .Caption := BoolToYesNo( id3v2Tag.FlgUnknown       );
    CB_UsePadding.Checked := (id3v2Tag.PaddingSize > 0);
  end else
    MessageDlg('Please select a file first', mtInformation, [mbOK], 0)
end;

procedure TForm1.FillFrameView;
var NewItem: TListItem;
    iFrame: TID3v2Frame;
    i: Integer;
    FrameList: TTagItemList;
begin
  LVFrames.Items.Clear;
  fNewPictureDataLoaded := False;
  fNewPictureData.Clear;

  CBUnsync.OnClick := NIL;
  CBUnsync.Checked := ID3v2Tag.FlgUnsynch;
  CBUnsync.OnClick := CBUnsyncClick;

  FrameList := TTagItemList.Create;
  try
      case CBFrameTypeSelection.ItemIndex of
          0: ID3v2Tag.GetAllTextFrames(FrameList) ;     //  Text-Frames
          1: ID3v2Tag.GetAllCommentFrames(FrameList) ;  //  Comments
          2: ID3v2Tag.GetAllLyricFrames(FrameList) ;    //  Lyrics
          3: ID3v2Tag.GetAllURLFrames(FrameList) ;      //  URLs
          4: ID3v2Tag.GetAllUserDefinedURLFrames(FrameList);  //  User-defined URLs
          5: ID3v2Tag.GetAllPictureFrames(FrameList);   //  Cover Art
          6: ID3v2Tag.GetAllPrivateFrames(FrameList);   //  private Frames
      else
          ID3v2Tag.GetAllFrames(FrameList) ;         //  All Frames (viewed as binary data)
      end;

      for i := 0 to FrameList.Count - 1 do
      begin
          iFrame := (FrameList[i] as TID3v2Frame);
          NewItem := LVFrames.Items.Add;
          NewItem.Caption := String(iFrame.FrameIDString);
          NewItem.SubItems.Add(iFrame.FrameTypeDescription);
          NewItem.Data := iFrame;
      end;
  finally
    FrameList.Free;
  end;
end;

procedure TForm1.RefreshButtons;
begin
  BtnApplyChange.Enabled := (fCurrentFilename <> '') and (CBFrameTypeSelection.ItemIndex in [0..5]);
  BtnAddFrame.Enabled := (fCurrentFilename <> '');
  BtnDeleteFrame.Enabled := (fCurrentFilename <> '') and (LVFrames.ItemIndex <> - 1);
  BtnUndo.Enabled := (fCurrentFilename <> '');
  BtnSaveToFile.Enabled := (fCurrentFilename <> '');
end;

procedure TForm1.CBFrameTypeSelectionChange(Sender: TObject);
begin
    case CBFrameTypeSelection.ItemIndex of
        0: PCFrameContent.ActivePageIndex := 0;     //  Text-Frames
        1: PCFrameContent.ActivePageIndex := 1;     //  Comments
        2: PCFrameContent.ActivePageIndex := 1;     //  Lyrics
        3: PCFrameContent.ActivePageIndex := 2;     //  URLs
        4: PCFrameContent.ActivePageIndex := 3;     //  User-defined URLs
        5: PCFrameContent.ActivePageIndex := 4;     //  Cover Art
        6: PCFrameContent.ActivePageIndex := 5;     //  Private Frames
        7: PCFrameContent.ActivePageIndex := 6;     //  All frames (as binary data)
    end;
    FillFrameView;
    RefreshButtons;
end;

procedure TForm1.LVFramesChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  RefreshButtons;
end;

procedure TForm1.LVFramesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var iFrame: TID3v2Frame;
    value, Description: UnicodeString;
    language, mime, privDescription: AnsiString;
    PicType: TPictureType;
    PictureData, Data: TStream;

    function StreamToString(aStream: TStream): String;
    var
      tmpstr: AnsiString;
      i: Integer;
    begin
      setlength(tmpstr, aStream.Size);
      aStream.Position := 0;
      aStream.Read(tmpstr[1], length(tmpstr));
      for i := 1 to length(tmpstr) do
        if (ord(tmpstr[i]) < 32) or (ord(tmpstr[i]) = 127) then
          tmpstr[i] := '.';
      result := String(tmpstr);
    end;

begin
   if (Item = Nil) or (not selected) then exit;
   try
      iFrame := TID3v2Frame(Item.Data);
   except
      exit;
   end;

   LblTagAlter    .caption := BoolToYesNo(iFrame.FlagTagAlterPreservation  );
   LblFileAlter   .caption := BoolToYesNo(iFrame.FlagFileAlterPreservation );
   LblReadOnly    .caption := BoolToYesNo(iFrame.FlagReadOnly              );
   LblSize        .caption := IntToStr   (iFrame.DataSize                  );
   LblUnknownFlags.caption := BoolToYesNo(iFrame.FlagUnknownEncoding or iFrame.FlagUnknownStatus  );

   if not iFrame.FlagGroupingIndentity
   then
       LblGrouped.caption := BoolToYesNo(iFrame.FlagGroupingIndentity)
   else
       LblGrouped.caption := IntToStr(iFrame.GroupID);

   LblUnsynced       .caption := BoolToYesNo(iFrame.FlagUnsynchronisation  );
   LblLengthIndicator.caption := BoolToYesNo(iFrame.FlagDataLengthIndicator);
   LblCompression    .caption := BoolToYesNo(iFrame.FlagCompression        );
   LblEncryption     .caption := BoolToYesNo(iFrame.FlagEncryption         );

   case CBFrameTypeSelection.ItemIndex of
       0: begin // Text-Frames
            Ed4_Text.Text := iFrame.GetText;
       end;

       1,2: begin // Comments, Lyrics
          value := iFrame.GetCommentsLyrics(Language, Description);
          Ed4_CommentLanguage.Text    := String(Language);
          Ed4_CommentDescription.Text := Description;
          Ed4_CommentValue.Text         := Value;
       end;

       3: begin//  URLs
          Ed4_URL.Text := iFrame.GetURL;
       end;

       4: begin //  User-definierte URLs
          value := iFrame.GetUserdefinedURL(Description);
          ed4_UserDefURLDescription.Text := Description;
          Ed4_UserDefURLValue.Text       := Value;
       end;

       5: begin //  Pictures
          PictureData := TMemoryStream.Create;
          try
              iFrame.GetPicture(PictureData, Mime, PicType, Description);
              PictureData.Position := 0;
              Ed4_Pic.Picture.LoadFromStream(PictureData);
              Ed4_PicMime.Text := Mime;
              Ed4_PicDescription.Text := Description;
              ed4_cbPictureType.ItemIndex := Integer(PicType)
          finally
              PictureData.Free;
          end;

       end;
       6: begin  // Private Frames
          Data := TMemoryStream.Create;
          try
            iFrame.GetPrivateFrame(privDescription, data);
            edtPrivateDescription.Text := privDescription;
            memoPrivateFrame.Text := StreamToString(Data);
          finally
            Data.Free;
          end;
       end;

       7: begin // all frames as binary
          Data := TMemoryStream.Create;
          try
            iFrame.GetData(Data);
            Ed4_DataMemo.Text := StreamToString(Data);
          finally
            Data.Free;
          end;
       end;
   end;
end;


procedure TForm1.CB_UsePaddingClick(Sender: TObject);
begin
  id3v2Tag.UsePadding := CB_UsePadding.Checked;
end;

procedure TForm1.CBUnsyncClick(Sender: TObject);
begin
  ID3v2Tag.FlgUnsynch := CBUnsync.Checked;
end;

procedure TForm1.BtnAddFrameClick(Sender: TObject);
begin
  FormNewFrame.FrameType := CBFrameTypeSelection.ItemIndex;
  FormNewFrame.ID3v2Tag := ID3v2Tag;
  if FormNewFrame.ShowModal = mrOK then
    FillFrameView;
end;

procedure TForm1.BtnVisitURLClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(Ed4_URL.Text), nil, nil, SW_SHOW);
end;

procedure TForm1.Btn_VisitUserDefURLClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(Ed4_UserDefURLValue.Text), nil, nil, SW_SHOW);
end;


procedure TForm1.Btn_ExtractDataClick(Sender: TObject);
var iFrame: TID3v2Frame;
    aStream: TFileStream;
begin
    if LVFrames.ItemIndex <> - 1 then
    begin
        SaveDialog1.DefaultExt := '';
        SaveDialog1.Filter := '*.*|*.*;';

        if SaveDialog1.Execute then
        begin
            iFrame := TID3v2Frame(LVFrames.Items[LVFrames.ItemIndex].Data);
            aStream := TFileStream.Create(SaveDialog1.FileName, fmCreate or fmOpenReadWrite);
            iFrame.GetData(aStream);
            aStream.Free;
        end;
    end;
end;


procedure TForm1.BtnSavePictureClick(Sender: TObject);
var Stream: TMemoryStream;
    mime: AnsiString;
    PicType: TPictureType;
    Description: UnicodeString;
    iFrame: TID3v2Frame;

begin
    if LVFrames.ItemIndex <> - 1 then
    begin
        Stream := TMemoryStream.Create;
        try
            mime := ''; // invalid
            // Get Picture-Data from current Frame/MetaBlock
            iFrame := TID3v2Frame(LVFrames.Items[LVFrames.ItemIndex].Data);
            iFrame.GetPicture(stream, Mime, PicType, Description);

            // Get proper Filter for SaveDialog
            if (mime = AWB_MimePNG) or (Uppercase(UnicodeString(Mime)) = 'PNG') then
            begin
                SaveDialog1.DefaultExt := 'png';
                SaveDialog1.Filter := '*.png|*.png;';
            end else
            begin
                SaveDialog1.DefaultExt := 'jpg';
                SaveDialog1.Filter := '*.jpg;*.jpeg;|*.jpg;*.jpeg;';
            end;

            // Save the Picture
            if SaveDialog1.execute then
            begin
                try
                    Stream.SaveToFile(saveDialog1.FileName);
                except
                    on E: Exception do MessageDLG(E.Message, mtError, [mbOK], 0);
                end;
            end;
        finally
            stream.Free;
        end;
    end;
end;

procedure TForm1.BtnSaveToFileClick(Sender: TObject);
begin
    if (fCurrentFilename <> '') and (FileExists(fCurrentFilename)) then
    begin
        id3v2Tag.WriteToFile(fCurrentFilename);
        ShowTagInfo;
    end;
end;

procedure TForm1.BtnLoadPicClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then begin
    Ed4_Pic.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    if SameText(ExtractFileExt(OpenPictureDialog1.FileName), '.png') then
      Ed4_PicMime.Text := AWB_MimePNG
    else
      Ed4_PicMime.Text := AWB_MimeJPEG;

    fNewPictureData.Clear;
    fNewPictureData.LoadFromFile(OpenPictureDialog1.FileName);
    fNewPictureDataLoaded := True;
  end;
end;

procedure TForm1.BtnApplyChangeClick(Sender: TObject);
var iFrame: TID3v2Frame;
    dummyMime: AnsiString;
    dummyTyp: TPictureType;
    dummyDesc: UnicodeString;

begin
    // Update the Frame, but do not write it into the file yet
    case CBFrameTypeSelection.ItemIndex of
        0: begin // Text Frames
            if LVFrames.ItemIndex <> - 1 then
            begin
                iFrame := TID3v2Frame(LVFrames.Items[LVFrames.ItemIndex].Data);

                iFrame.FlagGroupingIndentity := cbGroupID.Checked;
                if StrToIntDef(EdGroupID.Text, 1) > 255 then
                    iFrame.GroupID := 1
                else
                    iFrame.GroupID := StrToIntDef(EdGroupID.Text, 1);

                iFrame.SetText(Ed4_Text.Text);
            end;
        end;

        1, 2: begin  //  Comments and Lyrics
            if LVFrames.ItemIndex <> - 1 then
            begin
                iFrame := TID3v2Frame(LVFrames.Items[LVFrames.ItemIndex].Data);

                iFrame.FlagGroupingIndentity := cbGroupID.Checked;
                if StrToIntDef(EdGroupID.Text, 1) > 255 then
                    iFrame.GroupID := 1
                else
                    iFrame.GroupID := StrToIntDef(EdGroupID.Text, 1);

                iFrame.SetCommentsLyrics(AnsiString(Ed4_CommentLanguage.Text), Ed4_CommentDescription.Text,
                        Ed4_CommentValue.Text);
            end;
        end;

        3: begin //  URLs
            if LVFrames.ItemIndex <> - 1 then
            begin
                iFrame := TID3v2Frame(LVFrames.Items[LVFrames.ItemIndex].Data);

                iFrame.FlagGroupingIndentity := cbGroupID.Checked;
                if StrToIntDef(EdGroupID.Text, 1) > 255 then
                    iFrame.GroupID := 1
                else
                    iFrame.GroupID := StrToIntDef(EdGroupID.Text, 1);

                iFrame.SetURL(AnsiString(Ed4_URL.Text));
            end;
        end;

        4: begin  //  User-defined URLs
            if LVFrames.ItemIndex <> - 1 then
            begin
                iFrame := TID3v2Frame(LVFrames.Items[LVFrames.ItemIndex].Data);

                iFrame.FlagGroupingIndentity := cbGroupID.Checked;
                if StrToIntDef(EdGroupID.Text, 1) > 255 then
                    iFrame.GroupID := 1
                else
                    iFrame.GroupID := StrToIntDef(EdGroupID.Text, 1);

                iFrame.SetUserdefinedURL(ed4_UserDefURLDescription.Text,
                      AnsiString(Ed4_UserDefURLValue.Text));
            end;
        end;

        5: begin // Pictures
            if LVFrames.ItemIndex <> - 1 then
            begin
                iFrame := TID3v2Frame(LVFrames.Items[LVFrames.ItemIndex].Data);

                iFrame.FlagGroupingIndentity := cbGroupID.Checked;
                if StrToIntDef(EdGroupID.Text, 1) > 255 then
                    iFrame.GroupID := 1
                else
                    iFrame.GroupID := StrToIntDef(EdGroupID.Text, 1);

                if fNewPictureDataLoaded then
                begin
                    // write the new picture into the frame
                    iFrame.SetPicture(fNewPictureData, AnsiString(Ed4_PicMime.Text), TPictureType(ed4_cbPictureType.ItemIndex), Ed4_PicDescription.Text);
                end else
                begin
                    // just write the new "text settings" => load the existing picture data first
                    fNewPictureData.Clear;
                    iFrame.GetPicture(fNewPictureData, dummyMime, dummyTyp, dummyDesc);
                    iFrame.SetPicture(fNewPictureData, AnsiString(Ed4_PicMime.Text), TPictureType(ed4_cbPictureType.ItemIndex), Ed4_PicDescription.Text);
                end;
            end;
        end;

        6: begin  //  private Frames
            // not supported here, use method
            //** iFrame.SetPrivateFrame(aOwnerID: AnsiString; Data: TStream); **//
            // note: In most cases you should not write Private Frames except "your" private frames defined by your own software
        end;

        7: begin
            // Not supported here, use method
            //** iFrame.SetData(Data: TStream); **//
            // !! but be very careful with it !!
        end;
    end;
end;

procedure TForm1.BtnDeleteFrameClick(Sender: TObject);
begin
  if LVFrames.ItemIndex <> - 1 then begin
    id3v2Tag.DeleteTagItem(TID3v2Frame(LVFrames.Items[LVFrames.ItemIndex].Data));
    LVFrames.DeleteSelected;
  end;
end;



procedure TForm1.BtnDeleteTagClick(Sender: TObject);
begin
  if (fCurrentFilename <> '') and (FileExists(fCurrentFilename)) then begin
    if MessageDlg('This will delete the ID3Tag from the file and delete all metadata. Continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
      id3v2Tag.RemoveFromFile(fCurrentFilename);
      ShowTagInfo;
    end;
  end;
end;



end.
