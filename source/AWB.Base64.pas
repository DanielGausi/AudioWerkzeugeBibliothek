{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2026, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit AWB.Base64

    Fallback for older Delphi versions without System.NetEncoding

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


unit AWB.Base64;

{$I config.inc}

{$IFNDEF B64_FALLBACK} Do not use this unit, if System.NetEncoding is available!{$ENDIF}

interface

uses
  {$IFDEF USE_UNIT_SCOPES}
  Winapi.Windows, System.SysUtils, System.ContNrs, System.Classes;
  {$ELSE}
  Windows, SysUtils, ContNrs, Classes;
  {$ENDIF}
type

{
  Note: This class is not intended to be a complete replacement for a
  Base64 class.
  It implements exactly the two methods that are needed in the context
  of this library. Hence the unusual combination of a procedure and
  a class procedure.
}

  TAwbBase64Encoding = class
    public
      procedure Encode(Input, Output: TStream);
      class procedure Decode(Input, Output: TStream);
  end;



implementation

function Base64CharValue(C: AnsiChar): Byte;
begin
  case C of
    'A'..'Z': Result := Ord(C) - Ord('A');
    'a'..'z': Result := Ord(C) - Ord('a') + 26;
    '0'..'9': Result := Ord(C) - Ord('0') + 52;
    '+': Result := 62;
    '/': Result := 63;
    '=': Result := 0;
  else
    Result := 0; // invalid
  end;
end;


{ TAwbBase64Encoding }

// Base64-Input to "real data"
class procedure TAwbBase64Encoding.Decode(Input, Output: TStream);
var
  InBuffer: array[0..3] of AnsiChar;
  OutBytes: array[0..2] of Byte;
  ValidCount, r: Integer;
  InputSize, Processed: Int64;
begin
  Input.Position := 0;
  InputSize := Input.Size;
  Processed := 0;

  while Processed < InputSize do begin
    r := Input.Read(InBuffer[0], 4);
    if r <> 4 then begin
      // add padding (should never happen, padding is REQUIRED for VorbisComments PictureBlock Encoding)
      if r <= 3 then InBuffer[3] := '=';
      if r <= 2 then InBuffer[2] := '=';
      if r <= 1 then InBuffer[1] := '=';
    end;
    Processed := Processed + r;

    // convert 4 * 6 Bits to 3 * 8 Bits
    OutBytes[0] := (Base64CharValue(InBuffer[0]) shl 2) or (Base64CharValue(InBuffer[1]) shr 4);
    ValidCount := 1;
    if InBuffer[2] <> '=' then begin
      OutBytes[1] := ((Base64CharValue(InBuffer[1]) and $0F) shl 4) or (Base64CharValue(InBuffer[2]) shr 2);
      inc(ValidCount);
    end;
    if InBuffer[3] <> '=' then begin
      OutBytes[2] := ((Base64CharValue(InBuffer[2]) and $03) shl 6) or Base64CharValue(InBuffer[3]);
      inc(ValidCount);
    end;

    Output.Write(OutBytes[0], ValidCount);
  end;
end;

procedure TAwbBase64Encoding.Encode(Input, Output: TStream);
const
  Base64Table: AnsiString = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
var
  cDiv, cRemain, i: Integer;
  Buffer: array[0..2] of Byte;
  OutStr: AnsiString;
begin
  cDiv := Input.Size Div 3;
  cRemain := Input.Size Mod 3;

  for i := 1 to cDiv do begin
    Input.Read(Buffer[0], 3);
    OutStr := Base64Table[(Buffer[0] shr 2) + 1]
            + Base64Table[(((Buffer[0] and $03) shl 4) or (Buffer[1] shr 4)) + 1]
            + Base64Table[(((Buffer[1] and $0F) shl 2) or (Buffer[2] shr 6)) + 1]
            + Base64Table[(Buffer[2] and $3F) + 1];
    Output.Write(OutStr[1], 4);
  end;

  if cRemain > 0 then begin
    Input.Read(Buffer[0], cRemain);
    case cRemain of
      1: OutStr := Base64Table[(Buffer[0] shr 2) + 1]
                + Base64Table[((Buffer[0] and $03) shl 4) + 1]
                + '==';
      2: OutStr := Base64Table[(Buffer[0] shr 2) + 1]
                + Base64Table[(((Buffer[0] and $03) shl 4) or (Buffer[1] shr 4)) + 1]
                + Base64Table[((Buffer[1] and $0F) shl 2) + 1]
                + '=';
    else
      OutStr := '====' // should never happen
    end;
    Output.Write(OutStr[1], 4);
  end;

end;

end.
