
{
  Compatibilty to older Delphi Versions:
  Undef USE_DICTIONARY to use a regular TObjectList instead of TDictionary for registering audiotypes
}

{$IF CompilerVersion > 20} // Delphi 2009 or later
  {$DEFINE USE_DICTIONARY}
  {$DEFINE USE_GENERICS}
  {$DEFINE USE_PNG}
{$ifend}

{$IF CompilerVersion >= 23}  // XE2 or later
  {$DEFINE USE_UNIT_SCOPES}
{$IFEND}

{$IF CompilerVersion < 33}  // before 10.3 Rio: No Picture.LoadFromStream available
  {$DEFINE LOADIMAGE_FALLBACK}
{$IFEND}

{$IF CompilerVersion < 28}  // before XE7 (System.NetEncoding was introduced in XE7 (?))
  {$DEFINE B64_FALLBACK}
{$IFEND}

{
  Compiler-Switch-TNT:
  For reading files with "unicode filenames", some methods/types from the
  "TNT Unicode Controls" can be used:
    - WideFileExists and
    - TTntFileStream
  If you do not want to use this, only Ansi-Filenames are supported
  (in Delphi 2007 or earlier).
}

{$DEFINE USE_TNT_COMPOS}
{
  Delphi 2009: Unicode-capable by default. TNTs ar not needed.
}
{$IFDEF UNICODE}
    {$UNDEF USE_TNT_COMPOS}
{$ENDIF}


