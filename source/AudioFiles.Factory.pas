{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2020, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit AudioFiles.Factory

    "Factory class" for all types of Audiofiles
           * Use "AudioFileFactory.CreateAudioFile(aFileName)" to create
             a proper AudioFile-Object. Relevant is the FileName Extension (like ".mp3")

    Notes: * This Unit uses a TDictionary for registering the different
             types auf audiofiles (like mp3, ogg, whatever).
           * If you want to use it with an older Delphi version, undef the
             Compiler Directive "$DEFINE USE_DICTIONARY" in config.inc
             Then, a simple ObjectList is used for the registered FileClasses
             Access to a FileClass within in ths ObjectList will move this entry
             upwards. Thus, successive access to the same FileClass will be faster.


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

unit AudioFiles.Factory;

{$I config.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, ContNrs,
  {$IFDEF USE_DICTIONARY}
  System.Generics.Collections,
  {$ENDIF}
  AudioFiles.Declarations,
  AudioFiles.Base;

type
    {$IFDEF USE_DICTIONARY}
    TRegFileTypesDict = TDictionary<string, TBaseAudioFileClass>;
    {$ELSE}
    TAudioFileClassData = class
        Extension: String;
        AudioClass: TBaseAudioFileClass;
        constructor Create(aExt: String; aClass: TBaseAudioFileClass);
    end;
    {$ENDIF}


type
    TAudioFileFactory = class
        private
          {$IFDEF USE_DICTIONARY}
          FRegisteredFileTypes: TRegFileTypesDict;
          {$ELSE}
          // If tDictionary is unknown, use a List for registering classes
          // No Generics, just a plain TObjectlist
          FRegisteredFileTypes: TObjectList;
          {$ENDIF}

          {$IFNDEF USE_DICTIONARY}
          // Implement some functionality of TDictionary with basic methods
          procedure AddOrSetType(aExt: String; aClass: TBaseAudioFileClass);
          function IndexOf(aExt: String): Integer;
          function GetType(aExt: String): TBaseAudioFileClass;
          procedure RemoveType(aClass: TBaseAudioFileClass);
          {$ENDIF}


        public
            constructor Create;
            destructor Destroy; override;

            procedure RegisterClass(aClass: TBaseAudioFileClass; Extension: string);
            procedure UnRegisterClass(aClass: TBaseAudioFileClass);

            function GetClass(const Extension: string): TBaseAudioFileClass;
            function CreateAudioFile(aFilename: UnicodeString): TBaseAudioFile;
    end;

function AudioFileFactory: TAudioFileFactory;

implementation

var fLocalAudioFileFactory: TAudioFileFactory;


function AudioFileFactory: TAudioFileFactory;
begin
    if not Assigned(fLocalAudioFileFactory) then
        fLocalAudioFileFactory := TAudioFileFactory.Create;

    Result := fLocalAudioFileFactory;
end;


{$IFNDEF USE_DICTIONARY}
{ TAudioFileClassData }
constructor TAudioFileClassData.Create(aExt: String;
  aClass: TBaseAudioFileClass);
begin
    Extension := AnsiLowerCase(aExt);
    AudioClass := aClass;
end;
{$ENDIF}



{ TAudioFileFactory }
constructor TAudioFileFactory.Create;
begin
    {$IFDEF USE_DICTIONARY}
    FRegisteredFileTypes := TRegFileTypesDict.Create;
    {$ELSE}
    FRegisteredFileTypes := TObjectList.Create(True);
    {$ENDIF}
end;

destructor TAudioFileFactory.Destroy;
begin
    {$IFDEF USE_DICTIONARY}
    FRegisteredFileTypes.Free;
    {$ELSE}
    FRegisteredFileTypes.Free;
    {$ENDIF}
    inherited;
end;


{$IFNDEF USE_DICTIONARY}
procedure TAudioFileFactory.AddOrSetType(aExt: String; aClass: TBaseAudioFileClass);
var newClass: TAudioFileClassData;
    idx: Integer;
begin
    idx := IndexOf(aExt);
    if idx >= 0 then
        TAudioFileClassData(FRegisteredFileTypes[idx]).AudioClass := aClass
    else
    begin
        newClass := TAudioFileClassData.Create(aExt, aClass);
        FRegisteredFileTypes.Add(newClass);
    end;
end;

procedure TAudioFileFactory.RemoveType(aClass: TBaseAudioFileClass);
var i: Integer;
begin
    for i := FRegisteredFileTypes.Count - 1 downto 0 do
    begin
        if TAudioFileClassData(FRegisteredFileTypes[i]).AudioClass = aClass then
            FRegisteredFileTypes.Delete(i);
    end;
end;

function TAudioFileFactory.GetType(aExt: String): TBaseAudioFileClass;
var idx: Integer;
begin
    // get the Index of the Extension in the List of registered types
    idx := IndexOf(aExt);
    if idx >= 0 then
    begin
        // Get the AudioClass from that index
        result := TAudioFileClassData(FRegisteredFileTypes[idx]).AudioClass;
        // Move this Class upwards, so it can be found faster next time
        if idx > 0 then
            FRegisteredFileTypes.Exchange(idx, idx-1);
    end else
        result := Nil;
end;

function TAudioFileFactory.IndexOf(aExt: String): Integer;
var i: Integer;
begin
    result := -1;

    aExt := AnsiLowercase(aExt);
    for i := 0 to FRegisteredFileTypes.Count - 1 do
    begin
        if TAudioFileClassData(FRegisteredFileTypes[i]).Extension = aExt then
        begin
            result := i;
            break;
        end;
    end;
end;
{$ENDIF}


procedure TAudioFileFactory.RegisterClass(aClass: TBaseAudioFileClass; Extension: string);
begin
    {$IFDEF USE_DICTIONARY}
    FRegisteredFileTypes.AddorSetValue(Extension, aClass);
    {$ELSE}
    AddOrSetType(Extension, aClass);
    {$ENDIF}
end;



procedure TAudioFileFactory.UnRegisterClass(aClass: TBaseAudioFileClass);
var Extension: string;
begin
    {$IFDEF USE_DICTIONARY}
    for Extension in FRegisteredFileTypes.Keys do
        if FRegisteredFileTypes[Extension] = aClass then
          FRegisteredFileTypes.Remove(Extension);
    {$ELSE}
    RemoveType(aClass);
    {$ENDIF}
end;

function TAudioFileFactory.GetClass(const Extension: string): TBaseAudioFileClass;
begin
    {$IFDEF USE_DICTIONARY}
    if not FRegisteredFileTypes.TryGetValue(Extension, Result) then
        Result := Nil;
    {$ELSE}
    Result := GetType(Extension);
    {$ENDIF}
end;


function TAudioFileFactory.CreateAudioFile( aFilename: UnicodeString): TBaseAudioFile;
var ext: UnicodeString;
    aClass: TBaseAudioFileClass;
begin
    ext := AnsiLowercase(ExtractFileExt(aFileName));

    aClass := GetClass(ext);
    if assigned(aClass) then
        Result := aClass.Create
    else
        Result := Nil;
end;



initialization

  fLocalAudioFileFactory := nil;

finalization

  if assigned(fLocalAudioFileFactory) then
    fLocalAudioFileFactory.Free;

end.