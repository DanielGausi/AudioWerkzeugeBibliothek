unit Unit1;

interface

{$DEFINE USE_PNG}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ContNrs,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, JPEG, MpegFrames, ID3v1Tags, ID3v2Tags, ID3v2Frames,
  ExtDlgs, ShellApi {$IFDEF USE_PNG}, PNGImage{$ENDIF};

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
    procedure BtnShowInfosClick(Sender: TObject);
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
  private
    { Private-Deklarationen }
    fNewLevel3PicureChoosed: Boolean;
    fNewPictureData: TMemoryStream;
    fCurrentFilename: String;
    procedure FillFrameView;
  public
    { Public-Deklarationen }
  end;

  function PicStreamToImage(aStream: TStream; Mime: AnsiString; aBmp: TBitmap): Boolean;

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

function PicStreamToImage(aStream: TStream; Mime: AnsiString; aBmp: TBitmap): Boolean;
var jp: TJPEGImage;
    {$IFDEF USE_PNG}png: TPNGImage; {$ENDIF}
begin
    result := True;
    if (mime = 'image/jpeg') or (mime = 'image/jpg') or (AnsiUpperCase(String(Mime)) = 'JPG') then
    try
        aStream.Seek(0, soFromBeginning);
        jp := TJPEGImage.Create;
        try
          try
            jp.LoadFromStream(aStream);
            jp.DIBNeeded;
            aBmp.Assign(jp);
          except
            result := False;
            aBmp.Assign(NIL);
          end;
        finally
          jp.Free;
        end;
    except
        result := False;
        aBmp.Assign(NIL);
    end
    {$IFDEF USE_PNG}
    else
        if (mime = 'image/png') or (Uppercase(String(Mime)) = 'PNG') then
        try
            aStream.Seek(0, soFromBeginning);
            png := TPNGImage.Create;
            try
              try
                png.LoadFromStream(aStream);
                aBmp.Assign(png);
              except
                result := False;
                aBmp.Assign(NIL);
              end;
            finally
              png.Free;
            end;
        except
            result := False;
            aBmp.Assign(NIL);
        end
        {$ENDIF}
        else
        if (mime = 'image/bmp') or (Uppercase(String(Mime)) = 'BMP') then
            try
                aStream.Seek(0, soFromBeginning);
                aBmp.LoadFromStream(aStream);
            except
                result := False;
                aBmp.Assign(Nil);
            end else
                begin
                    aBmp.Assign(NIL);
                end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i: Integer;
begin
  Id3v2Tag := TId3v2Tag.Create;


  for i := 0 to 20 do
    ed4_cbPictureType.Items.Add(Picture_Types[i]);

  fNewLevel3PicureChoosed := False;
  TSText.TabVisible := False;
  TSComments.TabVisible := False;
  TSURL.TabVisible := False;
  TSURLUserDefined.TabVisible := False;
  TSCoverArt.TabVisible := False;
  TSPrivate.TabVisible := False;
  TSBinary.TabVisible := False;

  //TS_4_1.TabVisible := False;
  //TS_4_2.TabVisible := False;
  //TS_4_3.TabVisible := False;
  //TS_4_4.TabVisible := False;
  //TS_4_5.TabVisible := False;
  //TS_4_6.TabVisible := False;

  PCFrameContent.ActivePageIndex := 0;
  fNewPictureData := TMemoryStream.Create;
  fCurrentFilename := '';
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
        BtnShowInfosClick(Nil);
    end;
end;

procedure TForm1.BtnShowInfosClick(Sender: TObject);
var stream: TFilestream;
begin
    if (fCurrentFilename <> '') and (FileExists(fCurrentFilename)) then
    begin

        LVFrames.Items.Clear;
        stream := TFileStream.Create(fCurrentFilename, fmOpenRead or fmShareDenyWrite);
        Id3v2Tag.ReadFromStream(stream);
        stream.free;

        Lblv2_Version         .Caption := '2.'+IntToStr(id3v2Tag.Version.Major) + '.' + IntToStr(id3v2Tag.Version.Minor);
        Lblv2_Size            .Caption := IntToStr(id3v2Tag.Size);
        Lblv2_UsedSize        .Caption := IntToStr(id3v2Tag.Size - id3v2Tag.PaddingSize);

        Lblv2_ExtendedHeader  .Caption := BoolToYesNo( id3v2Tag.FlgExtended      );
        Lblv2_Experimental    .Caption := BoolToYesNo( id3v2Tag.FlgExperimental  );
        Lblv2_Footer          .Caption := BoolToYesNo( id3v2Tag.FlgFooterPresent );
        Lblv2_Unsynced        .Caption := BoolToYesNo( id3v2Tag.FlgUnsynch       );
        Lblv2_Compression     .Caption := BoolToYesNo( id3v2Tag.FlgCompression   );
        Lblv2_UnknownFlags    .Caption := BoolToYesNo( id3v2Tag.FlgUnknown       );

        CB_UsePadding.Checked := (id3v2Tag.PaddingSize > 0);

        FillFrameView;
    end else
        MessageDlg('Please select a file first', mtInformation, [mbOK], 0)

end;

procedure TForm1.FillFrameView;
var NewItem: TListItem;
    iFrame: TID3v2Frame;
    i: Integer;
    // Framelist: a temporary list for listing all frames with a specific property
    FrameList: TObjectlist;
begin
  LVFrames.Items.Clear;
  fNewLevel3PicureChoosed := False;
  fNewPictureData.Clear;

  CBUnsync.OnClick := NIL;
  CBUnsync.Checked := ID3v2Tag.FlgUnsynch;
  CBUnsync.OnClick := CBUnsyncClick;

  FrameList := TObjectlist.Create;
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
          NewItem.Caption := iFrame.FrameIDString;
          NewItem.SubItems.Add(iFrame.FrameTypeDescription);
          NewItem.Data := iFrame;
      end;
  finally
    FrameList.Free;
  end;
end;

procedure TForm1.CBFrameTypeSelectionChange(Sender: TObject);
begin
    Case CBFrameTypeSelection.ItemIndex of
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
end;

procedure TForm1.LVFramesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var iFrame: TID3v2Frame;
    value, Description: UnicodeString;
    language, mime, tmpstr, privDescription: AnsiString;
    PicType: Byte;
    PictureData, Data: TStream;
    i: Integer;
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
       0: begin //  Normale Text-Frames
            Ed4_Text.Text := iFrame.GetText;
       end;
       1,2: begin //  Kommentare //  Lyrics
          value := iFrame.GetCommentsLyrics(Language, Description);
          Ed4_CommentLanguage.Text    := Language;
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

       5: begin //  Bilder
          PictureData := TMemoryStream.Create;
          try
              iFrame.GetPicture(Mime, PicType, Description, PictureData);
              PicStreamToImage(PictureData, Mime, Ed4_Pic.Picture.Bitmap);
              Ed4_PicMime.Text := Mime;
              Ed4_PicDescription.Text := Description;
              if PicType in [0..20] then
                  ed4_cbPictureType.ItemIndex := PicType
              else
                  ed4_cbPictureType.ItemIndex := 0;
          finally
              PictureData.Free;
          end;

       end;
       6: begin  // Private Frames
          Data := TMemoryStream.Create;
          try
              iFrame.GetPrivateFrame(privDescription, data);
              setlength(tmpstr, Data.Size);
              Data.Position := 0;
              Data.Read(tmpstr[1], length(tmpstr));
              for i := 1 to length(tmpstr) do
                  if ord(tmpstr[i]) < 32 then
                      tmpstr[i] := '.';

              edtPrivateDescription.Text := privDescription;
              memoPrivateFrame.Text :=tmpstr;
          finally
              Data.Free;
          end;
       end;
       7: begin //  Alle (Daten)
          Data := TMemoryStream.Create;
          try
              iFrame.GetData(Data);
              setlength(tmpstr, Data.Size);
              Data.Position := 0;
              Data.Read(tmpstr[1], length(tmpstr));
              // replace non-printable bytes with "."
              for i := 1 to length(tmpstr) do
                  if ord(tmpstr[i]) < 32 then
                      tmpstr[i] := '.';
              Ed4_DataMemo.Text := tmpstr;
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
    PicType: Byte;
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
            iFrame.GetPicture(Mime, PicType, Description, stream);

            // Get proper Filter for SaveDialog
            if (mime = 'image/png') or (Uppercase(UnicodeString(Mime)) = 'PNG') then
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
        BtnShowInfosClick(Nil);
    end;
end;


procedure TForm1.BtnLoadPicClick(Sender: TObject);
var aStream: TFileStream;
begin
    if OpenPictureDialog1.Execute then
    begin
        aStream := TFileStream.Create(OpenPictureDialog1.FileName, fmOpenRead or fmShareDenyWrite);
        try
            try
                if (AnsiLowerCase(ExtractFileExt(OpenPictureDialog1.FileName))='.png') then
                begin
                    PicStreamToImage(aStream, 'image/png', Ed4_Pic.Picture.Bitmap);
                    Ed4_PicMime.Text := 'image/png';
                end else
                begin
                    PicStreamToImage(aStream, 'image/jpeg', Ed4_Pic.Picture.Bitmap);
                    Ed4_PicMime.Text := 'image/jpeg';
                end;
                fNewPictureData.Clear;
                fNewPictureData.LoadFromFile(OpenPictureDialog1.FileName);
                fNewLevel3PicureChoosed := True;
            except
                Ed4_Pic.Picture.Assign(NIL);
                fNewLevel3PicureChoosed := False;
                fNewPictureData.Clear;
            end;
        finally
            aStream.Free;
        end;
    end;
end;

procedure TForm1.BtnApplyChangeClick(Sender: TObject);
var iFrame: TID3v2Frame;
    dummyMime: AnsiString;
    dummyTyp: Byte;
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

                if fNewLevel3PicureChoosed then
                begin
                    // write the new picture into the frame
                    iFrame.SetPicture(AnsiString(Ed4_PicMime.Text), ed4_cbPictureType.ItemIndex, Ed4_PicDescription.Text, fNewPictureData);
                end else
                begin
                    // just write the new "text settings" => load the existing picture data first
                    fNewPictureData.Clear;
                    iFrame.GetPicture(dummyMime, dummyTyp, dummyDesc, fNewPictureData);
                    iFrame.SetPicture(AnsiString(Ed4_PicMime.Text), ed4_cbPictureType.ItemIndex, Ed4_PicDescription.Text, fNewPictureData);
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
    if LVFrames.ItemIndex <> - 1 then
    begin
        id3v2Tag.DeleteFrame(TID3v2Frame(LVFrames.Items[LVFrames.ItemIndex].Data));
        LVFrames.DeleteSelected;
    end;
end;



procedure TForm1.BtnDeleteTagClick(Sender: TObject);
begin
    if (fCurrentFilename <> '') and (FileExists(fCurrentFilename)) then
        id3v2Tag.RemoveFromFile(fCurrentFilename);
end;



end.
