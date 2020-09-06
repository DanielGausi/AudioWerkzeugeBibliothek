{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2020, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit Apev2Tags

    Manipulate Apev2Tags

    ---------------------------------------------------------------------------

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    ---------------------------------------------------------------------------

    Alternatively, you may use this unit under the terms of the
    MOZILLA PUBLIC LICENSE (MPL):

    The contents of this file are subject to the Mozilla Public License
    Version 1.1 (the "License"); you may not use this file except in
    compliance with the License. You may obtain a copy of the License at
    http://www.mozilla.org/MPL/

    Software distributed under the License is distributed on an "AS IS"
    basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
    License for the specific language governing rights and limitations
    under the License.

    ---------------------------------------------------------------------------
}

unit Apev2Tags;

interface

uses Windows, Messages, SysUtils, StrUtils, Variants, ContNrs, Classes,
     AudioFiles.Base, AudioFiles.Factory, AudioFiles.Declarations,
     Id3Basics, ApeTagItem;

const
    APE_PREAMBLE = 'APETAGEX';

type

    // Structure of ID3v1Tags in the file
    TID3v1Structure = record
      ID: array[1..3] of AnsiChar;
      Title: Array [1..30] of AnsiChar;
      Artist: Array [1..30] of AnsiChar;
      Album: Array [1..30] of AnsiChar;
      Year: array [1..4] of AnsiChar;
      Comment: Array [1..30] of AnsiChar;
      Genre: Byte;
    end;

    TApeHeader = record
        Preamble: Array[1..8] of AnsiChar;
        Version: DWord;
        Size: DWord;
        ItemCount: DWord;
        Flags: DWord;
        Reserved: Array[1..8] of Byte;
    end;

    TApeTag = class
        private
            fApev2TagFooter: TApeHeader;
            fApev2TagHeader: TApeHeader;
            fID3v1tag: TID3v1Structure;

            fID3v1Present: Boolean;
            fID3v1TagSize: Cardinal;
            // fID3v2TagSize: Cardinal;

            fOffset: DWord;   // Position (from End of File) where the Apev2Tag begins
            fItemList: TObjectList;

            function fIsValidHeader(aApeHeader: TApeHeader): Boolean;
            function fTagContainsHeader: Boolean;

            function fGetComment          : UnicodeString;
            function fGetSubTitle         : UnicodeString;
            function fGetDebutAlbum       : UnicodeString;
            function fGetPublisher        : UnicodeString;
            function fGetConductor        : UnicodeString;
            function fGetComposer         : UnicodeString;
            function fGetCopyright        : UnicodeString;
            function fGetPublicationright : UnicodeString;
            function fGetFile             : UnicodeString;
            function fGetEAN              : UnicodeString;
            function fGetISBN             : UnicodeString;
            function fGetCatalog          : UnicodeString;
            function fGetLC               : UnicodeString;
            function fGetRecordDate       : UnicodeString;
            function fGetRecordLocation   : UnicodeString;
            function fGetMedia            : UnicodeString;
            function fGetIndex            : UnicodeString;
            function fGetRelated          : UnicodeString;
            function fGetISRC             : UnicodeString;
            function fGetAbstract         : UnicodeString;
            function fGetLanguage         : UnicodeString;
            function fGetBibliography     : UnicodeString;
            function fGetIntroplay        : UnicodeString;

            procedure fSetComment         (aValue: UnicodeString);
            procedure fSetSubTitle        (aValue: UnicodeString);
            procedure fSetDebutAlbum      (aValue: UnicodeString);
            procedure fSetPublisher       (aValue: UnicodeString);
            procedure fSetConductor       (aValue: UnicodeString);
            procedure fSetComposer        (aValue: UnicodeString);
            procedure fSetCopyright       (aValue: UnicodeString);
            procedure fSetPublicationright(aValue: UnicodeString);
            procedure fSetFile            (aValue: UnicodeString);
            procedure fSetEAN             (aValue: UnicodeString);
            procedure fSetISBN            (aValue: UnicodeString);
            procedure fSetCatalog         (aValue: UnicodeString);
            procedure fSetLC              (aValue: UnicodeString);
            procedure fSetRecordDate      (aValue: UnicodeString);
            procedure fSetRecordLocation  (aValue: UnicodeString);
            procedure fSetMedia           (aValue: UnicodeString);
            procedure fSetIndex           (aValue: UnicodeString);
            procedure fSetRelated         (aValue: UnicodeString);
            procedure fSetISRC            (aValue: UnicodeString);
            procedure fSetAbstract        (aValue: UnicodeString);
            procedure fSetLanguage        (aValue: UnicodeString);
            procedure fSetBibliography    (aValue: UnicodeString);
            procedure fSetIntroplay       (aValue: UnicodeString);

            function fComputeNewTagSize: Integer;  // Used to get the new ApeTag size before writing (EXcluding the Header)
            function fGetTagSize: Cardinal;        // The Size of the ApeTag in the File. Including Header AND Footer.

            procedure fPrepareFooterAndHeader;
            function CheckForID3Tag(aStream: TStream): Boolean;

      protected
            fValid      : Boolean;                // ???
            function fGetValid      : Boolean;    // ???

            procedure fSetTitle  (aValue: UnicodeString);
            procedure fSetArtist (aValue: UnicodeString);
            procedure fSetAlbum  (aValue: UnicodeString);
            procedure fSetYear   (aValue: UnicodeString);
            procedure fSetTrack  (aValue: UnicodeString);
            procedure fSetGenre  (aValue: UnicodeString);

            function fGetTitle   : UnicodeString;
            function fGetArtist  : UnicodeString;
            function fGetAlbum   : UnicodeString;
            function fGetYear    : UnicodeString;
            function fGetTrack   : UnicodeString;
            function fGetGenre   : UnicodeString;

            function ReadTagFromStream(aStream: TStream; ReadItems: Boolean): TAudioError;

        public
            property ContainsHeader: Boolean read fTagContainsHeader;
            property ID3v1Present: Boolean read fID3v1Present;

            // Size of the Tag in Bytes
            property Apev2TagSize   : Cardinal read fGetTagSize;
            property ID3v1TagSize   : Cardinal read fID3v1TagSize;
            // property ID3v2TagSize   : Cardinal read fID3v2TagSize;

            property Valid      : Boolean read fValid;

            // These properties are defined in the Apev2Tag-Standard
            property Title            : UnicodeString read fGetTitle             write fSetTitle            ;
            property Artist           : UnicodeString read fGetArtist            write fSetArtist           ;
            property Album            : UnicodeString read fGetAlbum             write fSetAlbum            ;
            property Year             : UnicodeString read fGetYear              write fSetYear             ;
            property Track            : UnicodeString read fGetTrack             write fSetTrack            ;
            property Genre            : UnicodeString read fGetGenre             write fSetGenre            ;
            property Comment          : UnicodeString read fGetComment           write fSetComment          ;
            property SubTitle         : UnicodeString read fGetSubTitle          write fSetSubTitle         ;
            property DebutAlbum       : UnicodeString read fGetDebutAlbum        write fSetDebutAlbum       ;
            property Publisher        : UnicodeString read fGetPublisher         write fSetPublisher        ;
            property Conductor        : UnicodeString read fGetConductor         write fSetConductor        ;
            property Composer         : UnicodeString read fGetComposer          write fSetComposer         ;
            property Copyright        : UnicodeString read fGetCopyright         write fSetCopyright        ;
            property PublicationRight : UnicodeString read fGetPublicationright  write fSetPublicationright ;
            property FileLocation     : UnicodeString read fGetFile              write fSetFile             ;
            property EAN              : UnicodeString read fGetEAN               write fSetEAN              ;
            property ISBN             : UnicodeString read fGetISBN              write fSetISBN             ;
            property Catalog          : UnicodeString read fGetCatalog           write fSetCatalog          ;
            property LabelCode        : UnicodeString read fGetLC                write fSetLC               ;
            property RecordDate       : UnicodeString read fGetRecordDate        write fSetRecordDate       ;
            property RecordLocation   : UnicodeString read fGetRecordLocation    write fSetRecordLocation   ;
            property Media            : UnicodeString read fGetMedia             write fSetMedia            ;
            property Indexes          : UnicodeString read fGetIndex             write fSetIndex            ;
            property Related          : UnicodeString read fGetRelated           write fSetRelated          ;
            property ISRC             : UnicodeString read fGetISRC              write fSetISRC             ;
            property AbstractOfContent: UnicodeString read fGetAbstract          write fSetAbstract         ;
            property Language         : UnicodeString read fGetLanguage          write fSetLanguage         ;
            property Bibliography     : UnicodeString read fGetBibliography      write fSetBibliography     ;
            property Introplay        : UnicodeString read fGetIntroplay         write fSetIntroplay        ;


            constructor Create;
            destructor Destroy; override;

            // Clear all Items and set Footer/Header to default values
            procedure Clear;

            // Get/Set arbitrary Keys
            // Use this with caution - you probably don't need this
            function GetValueByKey(aKey: AnsiString): UnicodeString;
            procedure SetValueByKey(aKey: AnsiString; aValue: UnicodeString);
            // Set/Get Binary Data
            // You REALLY SHOULD NOT use this. ;-)
            function GetBinaryDataByKey(aKey: AnsiString; dest: TStream): Boolean;
            procedure SetBinaryByKey(aKey: AnsiString; source: TStream);
            // Get a List of all TagItems in the tag (e.g. for use in a TListBox)
            procedure GetAllFrames(dest: TStrings);

            // Get/Set Cover Art
            // return value of the getter:
            //     The cover art in Apev2tag is NOT standardized
            //     Here a special format is expected, which seems to be used by other taggers:
            //     <Key> $00 <UTF8-Encoded description> $00 <actual picture data>
            //     The getter will return TRUE if a matching TagItem in this Format was found, FALSE otherwise
            function GetPicture(aType: TApePictureTypes; dest: TStream; var description: UnicodeString): boolean; overload;
            function GetPicture(aKey: AnsiString; dest: TStream; var description: UnicodeString): boolean; overload;
            procedure SetPicture(aType: TApePictureTypes;description: String; source: TStream); overload;
            procedure SetPicture(aKey: AnsiString; description: UnicodeString; source: TStream); overload;
            // Get all available CoverArt-TagItems (e.g. for use in a TComboBox)
            procedure GetAllPictureFrames(dest: TStrings);

            function ReadFromStream(aStream: TStream): TAudioError;

            function ReadFromFile(aFilename: UnicodeString): TAudioError;
            function WriteToFile(aFilename: UnicodeString): TAudioError;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError;
    end;

implementation

{ TApeFile }

constructor TApeTag.Create;
begin
    fItemList := TObjectList.Create;
end;

destructor TApeTag.Destroy;
begin
    fItemList.Free;
    inherited;
end;


{
    Clear
    Set default values
}
procedure TApeTag.Clear;
begin
    fItemList.Clear;
    fOffset := 0;
    fPrepareFooterAndHeader;
    fID3v1TagSize := 0;
    // fID3v2TagSize := 0;

    fValid      := False;
end;

function TApeTag.fGetValid: Boolean;
begin
  result := fValid;
end;



function TApeTag.fIsValidHeader(aApeHeader: TApeHeader): Boolean;
begin
    result := aApeHeader.Preamble = AnsiString('APETAGEX');
end;


function TApeTag.fTagContainsHeader: Boolean;
begin
    result := ((fApev2TagFooter.Flags shr 31) and 1) = 1;
end;

function TApeTag.fComputeNewTagSize: Integer;
var s, i: Integer;

begin
    s := 0;
    for i := 0 to fItemList.Count - 1 do
        s := s + TApeTagItem(fItemList[i]).CompleteSize;

    result := s + 32;
end;

function TApeTag.fGetTagSize: Cardinal;
begin
    if fIsValidHeader(fApev2TagFooter) then
    begin
        result := fApev2TagFooter.Size;
        if ContainsHeader then
            result := result + 32
    end
    else
        result := 0;
end;

{
    fSetValueByKey
    Set the matching TagItem in the List to the given Value
      - If aValue = '', the Item will be deleted.
      - If no matching Item can be found, a new one is created
    Used for property setters for Artist, Album, etc.
}
procedure TApeTag.SetValueByKey(aKey: AnsiString; aValue: UnicodeString);
var i: Integer;
    aTagItem: TApeTagItem;
    success: Boolean;
begin
    success := False;
    for i := 0 to fItemList.Count - 1 do
    begin
        aTagItem := TApeTagItem(fItemList[i]);
        if AnsiSameText(String(aKey), String(aTagItem.Key)) then
        begin
            if aValue = '' then
                fItemList.Delete(i)
            else
                aTagItem.Value := aValue;
            success := True;
            break;
        end;
    end;

    if (not success) and (aValue <> '')  then
    begin
        // create a new item
        aTagItem := TApeTagItem.Create(aKey);
        aTagItem.Value := aValue;
        fItemList.Add(aTagItem);
    end;
end;

procedure TApeTag.fSetAbstract(aValue: UnicodeString);
begin
    SetValueByKey('Abstract', aValue);
end;
procedure TApeTag.fSetAlbum(aValue: UnicodeString);
begin
    SetValueByKey('Album', aValue);
end;
procedure TApeTag.fSetArtist(aValue: UnicodeString);
begin
    SetValueByKey('Artist', aValue);
end;
procedure TApeTag.fSetBibliography(aValue: UnicodeString);
begin
    SetValueByKey('Bibliography', aValue);
end;
procedure TApeTag.fSetCatalog(aValue: UnicodeString);
begin
    SetValueByKey('Catalog', aValue);
end;
procedure TApeTag.fSetComment(aValue: UnicodeString);
begin
    SetValueByKey('Comment', aValue);
end;
procedure TApeTag.fSetComposer(aValue: UnicodeString);
begin
    SetValueByKey('Composer', aValue);
end;
procedure TApeTag.fSetConductor(aValue: UnicodeString);
begin
    SetValueByKey('Conductor', aValue);
end;
procedure TApeTag.fSetCopyright(aValue: UnicodeString);
begin
    SetValueByKey('Copyright', aValue);
end;
procedure TApeTag.fSetDebutAlbum(aValue: UnicodeString);
begin
    SetValueByKey('Debut album', aValue);
end;
procedure TApeTag.fSetEAN(aValue: UnicodeString);
begin
    SetValueByKey('EAN/UBC', aValue);
end;
procedure TApeTag.fSetFile(aValue: UnicodeString);
begin
    SetValueByKey('File', aValue);
end;
procedure TApeTag.fSetGenre(aValue: UnicodeString);
begin
    SetValueByKey('Genre', aValue);
end;
procedure TApeTag.fSetIndex(aValue: UnicodeString);
begin
    SetValueByKey('Index', aValue);
end;
procedure TApeTag.fSetIntroplay(aValue: UnicodeString);
begin
    SetValueByKey('Introplay', aValue);
end;
procedure TApeTag.fSetISBN(aValue: UnicodeString);
begin
   SetValueByKey('ISBN', aValue);
end;
procedure TApeTag.fSetISRC(aValue: UnicodeString);
begin
    SetValueByKey('ISRC', aValue);
end;
procedure TApeTag.fSetLanguage(aValue: UnicodeString);
begin
    SetValueByKey('Language', aValue);
end;
procedure TApeTag.fSetLC(aValue: UnicodeString);
begin
    SetValueByKey('LC', aValue);
end;
procedure TApeTag.fSetMedia(aValue: UnicodeString);
begin
    SetValueByKey('Media', aValue);
end;
procedure TApeTag.fSetPublicationright(aValue: UnicodeString);
begin
    SetValueByKey('Publicationright', aValue);
end;
procedure TApeTag.fSetPublisher(aValue: UnicodeString);
begin
    SetValueByKey('Publisher', aValue);
end;
procedure TApeTag.fSetRecordDate(aValue: UnicodeString);
begin
    SetValueByKey('Record Date', aValue);
end;
procedure TApeTag.fSetRecordLocation(aValue: UnicodeString);
begin
    SetValueByKey('Record Location', aValue);
end;
procedure TApeTag.fSetRelated(aValue: UnicodeString);
begin
    SetValueByKey('Related', aValue);
end;
procedure TApeTag.fSetSubTitle(aValue: UnicodeString);
begin
    SetValueByKey('Subtitle', aValue);
end;
procedure TApeTag.fSetTitle(aValue: UnicodeString);
begin
    SetValueByKey('Title', aValue);
end;
procedure TApeTag.fSetTrack(aValue: UnicodeString);
begin
    SetValueByKey('Track', aValue);
end;
procedure TApeTag.fSetYear(aValue: UnicodeString);
begin
    SetValueByKey('Year', aValue);
end;

{
    fGetValueByKey
    Get the matching TagItem in the List and returns its value
    Used for property getters for Artist, Album, etc.
}
function TApeTag.GetValueByKey(aKey: AnsiString): UnicodeString;
var i: Integer;
    aTagItem: TApeTagItem;
begin
    result := '';
    for i := 0 to fItemList.Count - 1 do
    begin
        aTagItem := TApeTagItem(fItemList[i]);
        if AnsiSameText(String(aKey), String(aTagItem.Key)) then
            result := aTagItem.Value;
    end;
end;
function TApeTag.fGetAbstract: UnicodeString;
begin
    result := GetValueByKey('Abstract');
end;
function TApeTag.fGetAlbum: UnicodeString;
begin
    result := GetValueByKey('Album');
end;
function TApeTag.fGetArtist: UnicodeString;
begin
    result := GetValueByKey('Artist');
end;
function TApeTag.fGetBibliography: UnicodeString;
begin
    result := GetValueByKey('Bibliography');
end;
function TApeTag.fGetCatalog: UnicodeString;
begin
    result := GetValueByKey('Catalog');
end;
function TApeTag.fGetComment: UnicodeString;
begin
    result := GetValueByKey('Comment');
end;
function TApeTag.fGetComposer: UnicodeString;
begin
    result := GetValueByKey('Composer');
end;
function TApeTag.fGetConductor: UnicodeString;
begin
    result := GetValueByKey('Conductor');
end;
function TApeTag.fGetCopyright: UnicodeString;
begin
    result := GetValueByKey('Copyright');
end;
function TApeTag.fGetDebutAlbum: UnicodeString;
begin
    result := GetValueByKey('Debut album');
end;
function TApeTag.fGetEAN: UnicodeString;
begin
    result := GetValueByKey('EAN/UPC');
end;
function TApeTag.fGetFile: UnicodeString;
begin
    result := GetValueByKey('File');
end;
function TApeTag.fGetGenre: UnicodeString;
begin
    result := GetValueByKey('Genre');
end;
function TApeTag.fGetIndex: UnicodeString;
begin
    result := GetValueByKey('Index');
end;
function TApeTag.fGetIntroplay: UnicodeString;
begin
    result := GetValueByKey('Introplay');
end;
function TApeTag.fGetISBN: UnicodeString;
begin
    result := GetValueByKey('ISBN');
end;
function TApeTag.fGetISRC: UnicodeString;
begin
    result := GetValueByKey('ISRC');
end;
function TApeTag.fGetLanguage: UnicodeString;
begin
    result := GetValueByKey('Language');
end;
function TApeTag.fGetLC: UnicodeString;
begin
    result := GetValueByKey('LC');
end;
function TApeTag.fGetMedia: UnicodeString;
begin
    result := GetValueByKey('Media');
end;
function TApeTag.fGetPublicationright: UnicodeString;
begin
    result := GetValueByKey('Publicationright');
end;
function TApeTag.fGetPublisher: UnicodeString;
begin
    result := GetValueByKey('Publisher');
end;
function TApeTag.fGetRecordDate: UnicodeString;
begin
    result := GetValueByKey('Record Date');
end;
function TApeTag.fGetRecordLocation: UnicodeString;
begin
    result := GetValueByKey('Record Location');
end;
function TApeTag.fGetRelated: UnicodeString;
begin
    result := GetValueByKey('Related');
end;
function TApeTag.fGetSubTitle: UnicodeString;
begin
    result := GetValueByKey('Subtitle');
end;
function TApeTag.fGetTitle: UnicodeString;
begin
    result := GetValueByKey('Title');
end;
function TApeTag.fGetTrack: UnicodeString;
begin
    result := GetValueByKey('Track');
end;
function TApeTag.fGetYear: UnicodeString;
begin
    result := GetValueByKey('Year');
end;


function TApeTag.GetBinaryDataByKey(aKey: AnsiString; dest: TStream): Boolean;
var i: Integer;
    aTagItem: TApeTagItem;
begin
    result := False;
    for i := 0 to fItemList.Count - 1 do
    begin
        aTagItem := TApeTagItem(fItemList[i]);
        if AnsiSameText(String(aKey), String(aTagItem.Key)) then
            result := aTagItem.GetBinaryData(dest);
    end;
end;
procedure TApeTag.SetBinaryByKey(aKey: AnsiString; source: TStream);
var i: Integer;
    aTagItem: TApeTagItem;
    success: Boolean;
begin
    success := False;
    for i := 0 to fItemList.Count - 1 do
    begin
        aTagItem := TApeTagItem(fItemList[i]);
        if AnsiSameText(String(aKey), String(aTagItem.Key)) then
        begin
            if assigned(source) and (source.Size > 0) then
                aTagItem.SetBinaryData(source)
            else
                fItemList.Delete(i);
            success := True;
            break;
        end;
    end;
    if not success then
    begin
        if assigned(source) and (Source.Size > 0) then
        begin
            aTagItem := TApeTagItem.Create(aKey);
            aTagItem.SetBinaryData(source);
            fItemList.Add(aTagItem);
        end;
    end;
end;

procedure TApeTag.GetAllFrames(dest: TStrings);
var i: Integer;
begin
    dest.Clear;
    for i := 0 to fItemList.Count - 1 do
        dest.Add(String(TApeTagItem(fItemList[i]).Key));
end;

procedure TApeTag.GetAllPictureFrames(dest: TStrings);
var i: Integer;
    aTagItem: TApeTagItem;
begin
    dest.Clear;
    for i := 0 to fItemList.Count - 1 do
    begin
        aTagItem := TApeTagItem(fItemList[i]);
        if AnsiStartsText('Cover Art', String(aTagItem.Key)) then
            dest.Add(String(aTagItem.Key));
    end;
end;

function TApeTag.GetPicture(aKey: AnsiString; dest: TStream; var description: UnicodeString): boolean;
var i: Integer;
    aTagItem: TApeTagItem;
begin
    result := False;
    for i := 0 to fItemList.Count - 1 do
    begin
        aTagItem := TApeTagItem(fItemList[i]);
        if AnsiSameText(String(aKey), String(aTagItem.Key))
           or ((aKey = '') and AnsiStartsText('Cover Art', String(aTagItem.Key))) then
        begin
            result := aTagItem.GetPicture(dest, description);
        end;
    end;
end;

function TApeTag.GetPicture(aType: TApePictureTypes; dest: TStream;
  var description: UnicodeString): boolean;
begin
    result := GetPicture(TPictureTypeStrings[aType], dest, description);
end;

procedure TApeTag.SetPicture(aKey: AnsiString; description: UnicodeString; source: TStream);
var i: Integer;
    aTagItem: TApeTagItem;
    success: Boolean;
begin
    success := False;
    for i := 0 to fItemList.Count - 1 do
    begin
        aTagItem := TApeTagItem(fItemList[i]);
        if AnsiSameText(String(aKey), String(aTagItem.Key)) then
        begin
            if assigned(source) and (source.Size > 0) then
                aTagItem.SetPicture(source, description)
            else
                fItemList.Delete(i);
            success := True;
            break;
        end;
    end;
    if not success then
    begin
        if assigned(source) and (Source.Size > 0) then
        begin
            aTagItem := TApeTagItem.Create(aKey);
            aTagItem.SetPicture(source, description);
            fItemList.Add(aTagItem);
        end;
    end;
end;

procedure TApeTag.SetPicture(aType: TApePictureTypes;description: String; source: TStream);
begin
    SetPicture(TPictureTypeStrings[aType], description, source);
end;

{
    CheckForID3Tag
    Check for an ID3v1-Tag at the end of the file.
    The TAG-identifier of ID3v1 is a substring of APETAGEX.
    So, we should test at -128 Bytes from the end of the file for "TAG"
    and verify, that this tag does not belong to the APETAGEX of the Header
    of the APE Tag.
}
function TApeTag.CheckForID3Tag(aStream: TStream): Boolean;
var aApeHeader: TApeHeader;
begin
    aStream.Seek(-128, soFromEnd);
    if (aStream.Read(fID3v1tag, 128) = 128) then
    begin
        if (fID3v1tag.ID = 'TAG') then
        begin
            // test this "TAG" for Ape-Header
            aStream.Seek(-128 - 3, soFromEnd);
            aStream.Read(aApeHeader, 32);
            // if there is no APETAGEX here, we have found a ID3v1-Tag
            result := aApeHeader.Preamble <> APE_PREAMBLE;
        end else
            result := false;
    end else
        result := false;
end;


{
    ReadTagFromStream
    Read the tag from a stream
    The parameter ReadItems is used for reading basic data (Footer, Header)
    just before writing the new Tag into the File
}
function TApeTag.ReadTagFromStream(aStream: TStream; ReadItems: Boolean): TAudioError;
var c, i: Integer;
    newItem: TApeTagItem;
begin

    result := FileErr_None;

    fID3v1Present := CheckForID3Tag(aStream);
    if fID3v1Present then
        fID3v1TagSize := 128  // the ID3v1Tag is now stored in fID3v1tag
    else
        fID3v1TagSize := 0;

    fOffset := fID3v1TagSize;

    // Check for Footer
    aStream.Seek(- 32 - Integer(fID3v1TagSize), soEnd);
    c := aStream.Read(fApev2TagFooter, 32);
    if c = 32 then
    begin
        if fIsValidHeader(fApev2TagFooter) then
        begin
            // Apev2tag is present
            if ContainsHeader then  // i.e. the flag in the footer is set
            begin
                fOffset := fApev2TagFooter.Size + 32 + fID3v1TagSize;
                aStream.Seek(- fOffset, soEnd);
                aStream.Read(fApev2TagHeader, 32);
                if Not fIsValidHeader(fApev2TagHeader) then
                begin
                    // The header is invalid, probably the flag in the footer is wrong
                    // set last Header Bit in the Footer to 0
                    fApev2TagFooter.Flags := fApev2TagFooter.Flags AND ((not 0) shr 1);
                    fOffset := fApev2TagFooter.Size + fID3v1TagSize;
                end;
            end
            else
            begin
                fOffset := fApev2TagFooter.Size + fID3v1TagSize;
                aStream.Seek(-fOffset, soEnd);
            end;

            // ReadItems
            if ReadItems then
            begin
                for i := 1 to fApev2TagFooter.ItemCount do
                begin
                    newItem := TApeTagItem.Create('');
                    if newItem.ReadFromStream(aStream) then
                        fItemList.Add(newItem)
                    else
                    begin
                        // something was wrong with the TagItem (e.g. invalid key)
                        result := ApeErr_InvalidTag;
                        // discard all Data
                        Clear;
                        break;
                    end;
                end;
            end;
        end else
            result := ApeErr_NoTag;
    end else
        result := ApeErr_NoTag;
end;

function TApeTag.ReadFromStream(aStream: TStream): TAudioError;
begin
    result := ReadTagFromStream(aStream, True);
end;


function TApeTag.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
begin
    Clear;
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try

                // Check for an existing ID3v2Tag and get its size
                // fID3v2TagSize := GetID3Size(fs);
                // Read the APEv2Tag from the stream
                result := ReadTagFromStream(fs, True);

                // Read the Audio Data (duration, bitrate, ) from the file.
                // This should be done in derivate classes
                // TagSizes (all 3) may be needed there
                // fs.Seek(fID3v2TagSize, soBeginning);
                // ReadAudioDataFromStream(fs);
            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenR;
        end;
    end else
        result := FileErr_NoFile;
end;

procedure TApeTag.fPrepareFooterAndHeader;
var b: DWord;
begin
    b := 1;
    fApev2TagFooter.Preamble  := APE_PREAMBLE;
    fApev2TagFooter.Version   := 2000;
    fApev2TagFooter.Size      := fComputeNewTagSize;
    fApev2TagFooter.ItemCount := fItemList.Count;
    fApev2TagFooter.Flags     := b shl 31;  // Header is present
                                            // (we will write a header by default)
    fApev2TagHeader.Preamble  := APE_PREAMBLE;
    fApev2TagHeader.Version   := 2000;
    fApev2TagHeader.Size      := fApev2TagFooter.Size;
    fApev2TagHeader.ItemCount := fItemList.Count;
    fApev2TagHeader.Flags     := (b shl 31) or (b shl 29);
end;

function TApeTag.WriteToFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    oldTag: TApeTag;
    i: Integer;
begin
    result := FileErr_None;

    fPrepareFooterAndHeader;

    if fItemList.Count = 0 then
        RemoveFromFile(aFilename)
    else
    begin
        if AudioFileExists(aFilename) then
        begin
            try
                fs := TAudioFileStream.Create(aFilename, fmOpenReadWrite or fmShareDenyWrite);
                try
                    /// Check the file for an existing tag
                    oldTag := TApeTag.Create;
                    try
                        oldTag.ReadTagFromStream(fs, False); // items there are not needed
                        fs.Seek(- oldTag.fOffset, soEnd);
                        // Write new Data into the Stream
                        if ContainsHeader then
                            fs.Write(fApev2TagHeader, 32);
                        for i := 0 to fItemList.Count - 1 do
                            TApeTagItem(fItemList[i]).WriteToStream(fs);
                        fs.Write(fApev2TagFooter, 32);

                        // copy old ID3Tag back to the file
                        if oldTag.fID3v1Present then
                            fs.Write(oldTag.fID3v1tag, 128);

                        SetEndOfFile(fs.Handle);
                    finally
                        oldTag.Free;
                    end;
                finally
                    fs.Free;
                end;
            except
                result := FileErr_FileOpenRW;
            end;
        end else
            result := FileErr_NoFile;
    end;
end;

function TApeTag.RemoveFromFile(aFilename: UnicodeString): TAudioError;
var fs: TAudioFileStream;
    oldTag: TApeTag;
begin
    result := FileErr_None;

    if AudioFileExists(aFilename) then
    begin
        try
            fs := TAudioFileStream.Create(aFilename, fmOpenReadWrite or fmShareDenyWrite);
            try
                /// Check the file for an existing tag
                oldTag := TApeTag.Create;
                try
                    oldTag.ReadTagFromStream(fs, False); // items there are not needed
                    if oldTag.fOffset > 0 then
                    begin
                        fs.Seek(- oldTag.fOffset, soEnd);

                        // copy old ID3Tag back to the file
                        if oldTag.fID3v1Present then
                            fs.Write(oldTag.fID3v1tag, 128);

                        SetEndOfFile(fs.Handle);
                    end;
                finally
                    oldTag.Free;
                end;
            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenRW;
        end;
    end else
        result := FileErr_NoFile;
end;


end.
