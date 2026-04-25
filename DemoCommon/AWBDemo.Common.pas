unit AWBDemo.Common;

interface

{$I ..\source\config.inc}

uses
  {$IFDEF USE_UNIT_SCOPES}
  Winapi.Windows, System.SysUtils, System.Classes, VCL.ExtCtrls, VCL.Graphics, Vcl.Imaging.jpeg
  {$ELSE}
  Windows,  SysUtils, Classes, ExtCtrls, Graphics, Jpeg
  {$ENDIF}
  {$IFDEF LOADIMAGE_FALLBACK}{$IFDEF USE_PNG}, PNGImage{$ENDIF}{$ENDIF}
  ;

procedure ShowImageFromStream(aStream: TStream; DestImage: TImage);

implementation

{$IFDEF LOADIMAGE_FALLBACK}
function StreamToBitmap(aStream: TStream; aBitmap: TBitmap): Boolean;
var jp: TJPEGImage;
    {$IFDEF USE_PNG}png: TPNGImage; {$ENDIF}
    LoadingFailed: Boolean;
begin
    aStream.Position := 0;

    LoadingFailed := False;
    // try it with JPG
    jp := TJPEGImage.Create;
    try
        try
            aStream.Position := 0;
            jp.LoadFromStream(aStream);
            jp.DIBNeeded;
            aBitmap.Assign(jp);
        except
            LoadingFailed := True;
        end;
    finally
        jp.Free;
    end;

    {$IFDEF USE_PNG}
    if LoadingFailed then
    begin
        LoadingFailed := False;
        // try it with PNG
        png := TPNGImage.Create;
        try
            try
                aStream.Position := 0;
                png.LoadFromStream(aStream);
                aBitmap.Assign(png);
            except
                LoadingFailed := True;
            end;
        finally
            png.Free;
        end;
    end;
    {$ENDIF}

    result := NOT LoadingFailed;
end;
{$ENDIF}

procedure ShowImageFromStream(aStream: TStream; DestImage: TImage);
begin
  {$IFDEF LOADIMAGE_FALLBACK}
  StreamToBitmap(aStream, DestImage.Picture.Bitmap)
  {$ELSE}
  aStream.Position := 0;
  DestImage.Picture.LoadFromStream(aStream);
  {$ENDIF}
end;

end.
