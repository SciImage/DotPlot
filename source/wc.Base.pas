unit wc.Base;

{$I wc.Base.inc}

interface

uses
  Types, SysUtils, Classes, Character,
  wc.Types, wc.Base.StringWrapper, wc.Consts;

{$WARN IMMUTABLE_STRINGS ON}

type
{$REGION 'TInt8Helper'}
  TInt8Helper = record helper for Int8
  public
    const
      MinValue = -128;
      MaxValue = 127;
      Size     = SizeOf(Int8);

    class function ToString(const Value: Int8): string;                         overload; inline; static;               // built-in
    class function Parse(const S: string): Int8;                                overload; static;                       // built-in
    class function Parse(const S: string; const Default: Int8): Int8;           overload; static;
    class function TryParse(const S: string; out Value: Int8): Bool;            static;                                 // built-in
    class function TryParseWithSeparators(const s: string; out Value: Int8; Sep: char): Bool;   static; inline;
    class function TryParseWithComma(const s: string; out Value: Int8): Bool;                   static; inline;
    class function TryParseWithLocalSeparators(const s: string; out Value: Int8): Bool;         static; inline;

    function ToString: string;                                  overload; inline;       // built-in
    function ToHexString: string;                               overload; inline;       // built-in
    function ToHexString(const MinDigits: Integer): string;     overload; inline;       // built-in
    function ToStringWithSeparators(Separator: char): string;   inline;
    function ToCommaString: string;                             inline;
    function ToLocaleString: string;                            inline;
    function ToPaddedString(MinWidth: NInt; Pad: Char = ' '; Sep: Char = #0): string;  inline;

    function ToBoolean: Bool;                                   inline;                 // built-in
    function ToSingle: Single;                                  inline;                 // built-in
    function ToDouble: Double;                                  inline;                 // built-in
    function ToExtended: Extended;                              inline;                 // built-in

    function Min(const a: Int8): Int8;                          overload; inline;
    function Min(const a, b: Int8): Int8;                       overload; inline;
    function Max(const a: Int8): Int8;                          overload; inline;
    function Max(const a, b: Int8): Int8;                       overload; inline;
    function EnsureRange(const Min, Max: Int8): Int8;           inline;
    function InRange(const Min, Max: Int8): Bool;               inline;
    function Sign: NInt;                                        inline;
    function Abs: Int8;                                         inline;
    function NearestMultiple(n: Int8): Int8;                    inline;

    procedure SetToSmaller(const a: Int8);                      overload; inline;
    procedure SetToSmaller(const a, b: Int8);                   overload; inline;
    procedure SetToSmaller(const a, b, c: Int8);                overload; inline;
    procedure SetToLarger(const a: Int8);                       overload; inline;
    procedure SetToLarger(const a, b: Int8);                    overload; inline;
    procedure SetToLarger(const a, b, c: Int8);                 overload; inline;
    procedure SetToRange(const Min, Max: Int8);                 inline;
    procedure SwapWith(var a: Int8);                            inline;
  end;
{$ENDREGION}
{$REGION 'TUInt8Helper'}
  TUInt8Helper = record helper for UInt8
  public
    const
      MinValue = 0;
      MaxValue = 255;
      Size     = SizeOf(UInt8);

    class function ToString(const Value: UInt8): string;                        overload; inline; static;
    class function Parse(const S: string): UInt8;                               overload; static;
    class function Parse(const S: string; const Default: UInt8): UInt8;         overload; static;
    class function TryParse(const S: string; out Value: UInt8): Bool;           static;
    class function TryParseWithSeparators(const s: string; out Value: UInt8; Sep: char): Bool;  static; inline;
    class function TryParseWithComma(const s: string; out Value: UInt8): Bool;                  static; inline;
    class function TryParseWithLocalSeparators(const s: string; out Value: UInt8): Bool;        static; inline;

    function ToString: string;                                  overload; inline;
    function ToHexString: string;                               overload; inline;
    function ToHexString(const MinDigits: Integer): string;     overload; inline;
    function ToStringWithSeparators(Separator: char): string;   inline;
    function ToCommaString: string;                             inline;
    function ToLocaleString: string;                            inline;
    function ToPaddedString(MinWidth: NInt; Pad: Char = ' '; Sep: Char = #0): string;   inline;

    function ToBoolean: Bool;                                   inline;
    function ToSingle: Single;                                  inline;
    function ToDouble: Double;                                  inline;
    function ToExtended: Extended;                              inline;

    function Min(const a: UInt8): UInt8;                        overload; inline;
    function Min(const a, b: UInt8): UInt8;                     overload; inline;
    function Max(const a: UInt8): UInt8;                        overload; inline;
    function Max(const a, b: UInt8): UInt8;                     overload; inline;
    function EnsureRange(const Min, Max: UInt8): UInt8;         inline;
    function InRange(const Min, Max: UInt8): Bool;              inline;
    function Sign: NInt;                                        inline;
    function Abs: UInt8;                                        inline;
    function NearestMultiple(n: UInt8): UInt8;                  inline;

    procedure SetToSmaller(const a: UInt8);                     overload; inline;
    procedure SetToSmaller(const a, b: UInt8);                  overload; inline;
    procedure SetToSmaller(const a, b, c: UInt8);               overload; inline;
    procedure SetToLarger(const a: UInt8);                      overload; inline;
    procedure SetToLarger(const a, b: UInt8);                   overload; inline;
    procedure SetToLarger(const a, b, c: UInt8);                overload; inline;
    procedure SetToRange(const Min, Max: UInt8);                inline;
    procedure SwapWith(var a: UInt8);                           inline;
  end;
{$ENDREGION}
{$REGION 'TInt16Helper'}
  TInt16Helper = record helper for Int16
  private
    function GetBytes(i: NUInt): UInt8;                         inline;
    procedure SetBytes(i: NUInt; Value: UInt8);                 inline;
  public
    const
      MinValue = -32768;
      MaxValue = 32767;
      Size     = SizeOf(Int16);

    class function ToString(const Value: Int16): string;                        overload; inline; static;
    class function Parse(const S: string): Int16;                               overload; static;
    class function Parse(const S: string; const Default: Int16): Int16;         overload; static;
    class function TryParse(const S: string; out Value: Int16): Bool;           static;
    class function TryParseWithSeparators(const s: string; out Value: Int16; Sep: char): Bool;  static; inline;
    class function TryParseWithComma(const s: string; out Value: Int16): Bool;                  static; inline;
    class function TryParseWithLocalSeparators(const s: string; out Value: Int16): Bool;        static; inline;

    function ToString: string;                                  overload; inline;
    function ToHexString: string;                               overload; inline;
    function ToHexString(const MinDigits: Integer): string;     overload; inline;
    function ToStringWithSeparators(Separator: char): string;   inline;
    function ToCommaString: string;                             inline;
    function ToLocaleString: string;                            inline;
    function ToPaddedString(MinWidth: NInt; Pad: Char = ' '; Sep: Char = #0): string;   inline;

    function ToBoolean: Bool;                                   inline;
    function ToSingle: Single;                                  inline;
    function ToDouble: Double;                                  inline;
    function ToExtended: Extended;                              inline;

    function Min(const a: Int16): Int16;                        overload; inline;
    function Min(const a, b: Int16): Int16;                     overload; inline;
    function Max(const a: Int16): Int16;                        overload; inline;
    function Max(const a, b: Int16): Int16;                     overload; inline;
    function EnsureRange(const Min, Max: Int16): Int16;         inline;
    function InRange(const Min, Max: Int16): Bool;              inline;
    function Sign: NInt;                                        inline;
    function Abs: Int16;                                        inline;
    function NearestMultiple(n: Int16): Int16;                  inline;

    procedure SetToSmaller(const a: Int16);                     overload; inline;
    procedure SetToSmaller(const a, b: Int16);                  overload; inline;
    procedure SetToSmaller(const a, b, c: Int16);               overload; inline;
    procedure SetToLarger(const a: Int16);                      overload; inline;
    procedure SetToLarger(const a, b: Int16);                   overload; inline;
    procedure SetToLarger(const a, b, c: Int16);                overload; inline;
    procedure SetToRange(const Min, Max: Int16);                inline;
    procedure SwapWith(var a: Int16);                           inline;

    property Bytes[i: NUInt]: UInt8 read GetBytes write SetBytes;
  end;
{$ENDREGION}
{$REGION 'TUInt16Helper'}
  TUInt16Helper = record helper for UInt16
  private
    function GetBytes(i: NUInt): UInt8;                          inline;
    procedure SetBytes(i: NUInt; Value: UInt8);                  inline;
  public
    const
      MinValue = 0;
      MaxValue = 65535;
      Size     = SizeOf(UInt16);

    class function ToString(const Value: UInt16): string;                       overload; inline; static;
    class function Parse(const S: string): UInt16;                              overload; static;
    class function Parse(const S: string; const Default: UInt16): UInt16;       overload; static;
    class function TryParse(const S: string; out Value: UInt16): Bool;          static;
    class function TryParseWithSeparators(const s: string; out Value: UInt16; Sep: char): Bool; static; inline;
    class function TryParseWithComma(const s: string; out Value: UInt16): Bool;                 static; inline;
    class function TryParseWithLocalSeparators(const s: string; out Value: UInt16): Bool;       static; inline;

    function ToString: string;                                  overload; inline;
    function ToHexString: string;                               overload; inline;
    function ToHexString(const MinDigits: Integer): string;     overload; inline;
    function ToStringWithSeparators(Separator: char): string;   inline;
    function ToCommaString: string;                             inline;
    function ToLocaleString: string;                            inline;
    function ToPaddedString(MinWidth: NInt; Pad: Char = ' '; Sep: Char = #0): string;   inline;

    function ToBoolean: Bool;                                   inline;
    function ToSingle: Single;                                  inline;
    function ToDouble: Double;                                  inline;
    function ToExtended: Extended;                              inline;

    function Min(const a: UInt16): UInt16;                      overload; inline;
    function Min(const a, b: UInt16): UInt16;                   overload; inline;
    function Max(const a: UInt16): UInt16;                      overload; inline;
    function Max(const a, b: UInt16): UInt16;                   overload; inline;
    function EnsureRange(const Min, Max: UInt16): UInt16;       inline;
    function InRange(const Min, Max: UInt16): Bool;             inline;
    function Sign: NInt;                                        inline;
    function Abs: UInt16;                                       inline;
    function NearestMultiple(n: UInt16): UInt16;                inline;

    procedure SetToSmaller(const a: UInt16);                    overload; inline;
    procedure SetToSmaller(const a, b: UInt16);                 overload; inline;
    procedure SetToSmaller(const a, b, c: UInt16);              overload; inline;
    procedure SetToLarger(const a: UInt16);                     overload; inline;
    procedure SetToLarger(const a, b: UInt16);                  overload; inline;
    procedure SetToLarger(const a, b, c: UInt16);               overload; inline;
    procedure SetToRange(const Min, Max: UInt16);               inline;
    procedure SwapWith(var a: UInt16);                          inline;

    property Bytes[i: NUInt]: UInt8 read GetBytes write SetBytes;
  end;
{$ENDREGION}
{$REGION 'TInt32Helper'}
  TInt32Helper = record helper for Int32
  private
    function GetBytes(i: NUInt): UInt8;                          inline;
    function GetWords(i: NUInt): UInt16;                         inline;
    procedure SetBytes(i: NUInt; Value: UInt8);                  inline;
    procedure SetWords(i: NUInt; Value: UInt16);                 inline;
  public
    const
      MinValue = -214748364;
      MaxValue = 2147483647;
      Size     = SizeOf(Int32);

    class function ToString(const Value: Int32): string;                        overload; inline; static;
    class function Parse(const S: string): Int32;                               overload; static;
    class function Parse(const S: string; const Default: Int32): Int32;         overload; static;
    class function TryParse(const S: string; out Value: Int32): Bool;           static;
    class function TryParseWithSeparators(const s: string; out Value: Int32; Sep: char): Bool;  static; inline;
    class function TryParseWithComma(const s: string; out Value: Int32): Bool;                  static; inline;
    class function TryParseWithLocalSeparators(const s: string; out Value: Int32): Bool;        static; inline;

    function ToString: string;                                  overload; inline;
    function ToHexString: string;                               overload; inline;
    function ToHexString(const MinDigits: Integer): string;     overload; inline;
    function ToStringWithSeparators(Separator: char): string;   inline;
    function ToCommaString: string;                             inline;
    function ToLocaleString: string;                            inline;
    function ToPaddedString(MinWidth: NInt; Pad: Char = ' '; Sep: Char = #0): string;   inline;

    function ToBoolean: Bool;                                   inline;
    function ToSingle: Single;                                  inline;
    function ToDouble: Double;                                  inline;
    function ToExtended: Extended;                              inline;

    function Min(const a: Int32): Int32;                        overload; inline;
    function Min(const a, b: Int32): Int32;                     overload; inline;
    function Max(const a: Int32): Int32;                        overload; inline;
    function Max(const a, b: Int32): Int32;                     overload; inline;
    function EnsureRange(const Min, Max: Int32): Int32;         inline;
    function InRange(const Min, Max: Int32): Bool;              inline;
    function Sign: NInt;                                        inline;
    function Abs: Int32;                                        inline;
    function NearestMultiple(n: Int32): Int32;                  inline;

    procedure SetToSmaller(const a: Int32);                     overload; inline;
    procedure SetToSmaller(const a, b: Int32);                  overload; inline;
    procedure SetToSmaller(const a, b, c: Int32);               overload; inline;
    procedure SetToLarger(const a: Int32);                      overload; inline;
    procedure SetToLarger(const a, b: Int32);                   overload; inline;
    procedure SetToLarger(const a, b, c: Int32);                overload; inline;
    procedure SetToRange(const Min, Max: Int32);                inline;
    procedure SwapWith(var a: Int32);                           inline;

    property Bytes[i: NUInt]: UInt8 read GetBytes write SetBytes;
    property Words[i: NUInt]: UInt16 read GetWords write SetWords;
  end;
{$ENDREGION}
{$REGION 'TUInt32Helper'}
  TUInt32Helper = record helper for UInt32
  private
    function GetBytes(i: NUInt): UInt8;                          inline;
    function GetWords(i: NUInt): UInt16;                         inline;
    procedure SetBytes(i: NUInt; Value: UInt8);                  inline;
    procedure SetWords(i: NUInt; Value: UInt16);                 inline;
  public
    const
      MinValue = 0;
      MaxValue = 4294967295;
      Size     = SizeOf(UInt32);

    class function ToString(const Value: UInt32): string;                       overload; inline; static;
    class function Parse(const S: string): UInt32;                              overload; static;
    class function Parse(const S: string; const Default: UInt32): UInt32;       overload; static;
    class function TryParse(const S: string; out Value: UInt32): Bool;          static;
    class function TryParseWithSeparators(const s: string; out Value: UInt32; Sep: char): Bool; static; inline;
    class function TryParseWithComma(const s: string; out Value: UInt32): Bool;                 static; inline;
    class function TryParseWithLocalSeparators(const s: string; out Value: UInt32): Bool;       static; inline;

    function ToString: string;                                  overload; inline;
    function ToHexString: string;                               overload; inline;
    function ToHexString(const MinDigits: Integer): string;     overload; inline;
    function ToStringWithSeparators(Separator: char): string;   inline;
    function ToCommaString: string;                             inline;
    function ToLocaleString: string;                            inline;
    function ToPaddedString(MinWidth: NInt; Pad: Char = ' '; Sep: Char = #0): string;  inline;

    function ToBoolean: Bool;                                   inline;
    function ToSingle: Single;                                  inline;
    function ToDouble: Double;                                  inline;
    function ToExtended: Extended;                              inline;

    function Min(const a: UInt32): UInt32;                      overload; inline;
    function Min(const a, b: UInt32): UInt32;                   overload; inline;
    function Max(const a: UInt32): UInt32;                      overload; inline;
    function Max(const a, b: UInt32): UInt32;                   overload; inline;
    function EnsureRange(const Min, Max: UInt32): UInt32;       inline;
    function InRange(const Min, Max: UInt32): Bool;             inline;
    function Sign: NInt;                                        inline;
    function Abs: UInt32;                                       inline;
    function NearestMultiple(n: UInt32): UInt32;                inline;

    procedure SetToSmaller(const a: UInt32);                    overload; inline;
    procedure SetToSmaller(const a, b: UInt32);                 overload; inline;
    procedure SetToSmaller(const a, b, c: UInt32);              overload; inline;
    procedure SetToLarger(const a: UInt32);                     overload; inline;
    procedure SetToLarger(const a, b: UInt32);                  overload; inline;
    procedure SetToLarger(const a, b, c: UInt32);               overload; inline;
    procedure SetToRange(const Min, Max: UInt32);               inline;
    procedure SwapWith(var a: UInt32);                          inline;

    property Bytes[i: NUInt]: UInt8 read GetBytes write SetBytes;
    property Words[i: NUInt]: UInt16 read GetWords write SetWords;
  end;
{$ENDREGION}
{$REGION 'TInt64Helper'}
  TInt64Helper = record helper for Int64
  private
    function GetBytes(i: NUInt): UInt8;                          inline;
    function GetWords(i: NUInt): UInt16;                         inline;
    function GetLongs(i: NUInt): UInt32;                         inline;
    procedure SetBytes(i: NUInt; Value: UInt8);                  inline;
    procedure SetWords(i: NUInt; Value: UInt16);                 inline;
    procedure SetLongs(i: NUInt; Value: UInt32);                 inline;
  public
    const
      MinValue = -9223372036854775808;
      MaxValue = 9223372036854775807;
      Size     = SizeOf(Int64);

    class function ToString(const Value: Int64): string;                        overload; inline; static;
    class function Parse(const S: string): Int64;                               overload; static;
    class function Parse(const S: string; const Default: Int64): Int64;         overload; static;
    class function TryParse(const S: string; out Value: Int64): Bool;           static;
    class function TryParseWithSeparators(const s: string; out Value: Int64; Sep: char): Bool;  static; inline;
    class function TryParseWithComma(const s: string; out Value: Int64): Bool;                  static; inline;
    class function TryParseWithLocalSeparators(const s: string; out Value: Int64): Bool;        static; inline;

    function ToString: string;                                  overload; inline;
    function ToHexString: string;                               overload; inline;
    function ToHexString(const MinDigits: Integer): string;     overload; inline;
    function ToStringWithSeparators(Separator: char): string;   inline;
    function ToCommaString: string;                             inline;
    function ToLocaleString: string;                            inline;
    function ToPaddedString(MinWidth: NInt; Pad: Char = ' '; Sep: Char = #0): string;   inline;

    function ToBoolean: Bool;                                   inline;
    function ToSingle: Single;                                  inline;
    function ToDouble: Double;                                  inline;
    function ToExtended: Extended;                              inline;

    function Min(const a: Int64): Int64;                        overload; inline;
    function Min(const a, b: Int64): Int64;                     overload; inline;
    function Max(const a: Int64): Int64;                        overload; inline;
    function Max(const a, b: Int64): Int64;                     overload; inline;
    function EnsureRange(const Min, Max: Int64): Int64;         inline;
    function InRange(const Min, Max: Int64): Bool;              inline;
    function Sign: NInt;                                        inline;
    function Abs: Int64;                                        inline;
    function NearestMultiple(n: Int64): Int64;                  inline;

    procedure SetToSmaller(const a: Int64);                     overload; inline;
    procedure SetToSmaller(const a, b: Int64);                  overload; inline;
    procedure SetToSmaller(const a, b, c: Int64);               overload; inline;
    procedure SetToLarger(const a: Int64);                      overload; inline;
    procedure SetToLarger(const a, b: Int64);                   overload; inline;
    procedure SetToLarger(const a, b, c: Int64);                overload; inline;
    procedure SetToRange(const Min, Max: Int64);                inline;
    procedure SwapWith(var a: Int64);                           inline;

    property Bytes[i: NUInt]: UInt8 read GetBytes write SetBytes;
    property Words[i: NUInt]: UInt16 read GetWords write SetWords;
    property Longs[i: NUInt]: UInt32 read GetLongs write SetLongs;
  end;
{$ENDREGION}
{$REGION 'TUInt64Helper'}
  TUInt64Helper = record helper for UInt64
  private
    function GetBytes(i: NUInt): UInt8;                          inline;
    function GetWords(i: NUInt): UInt16;                         inline;
    function GetLongs(i: NUInt): UInt32;                         inline;
    procedure SetBytes(i: NUInt; Value: UInt8);                  inline;
    procedure SetWords(i: NUInt; Value: UInt16);                 inline;
    procedure SetLongs(i: NUInt; Value: UInt32);                 inline;
  public
    const
      MinValue = 0;
      MaxValue = 18446744073709551615;
      Size     = SizeOf(UInt64);

    class function ToString(const Value: UInt64): string;                       overload; inline; static;
    class function Parse(const S: string): UInt64;                              overload; static;
    class function Parse(const S: string; const Default: UInt64): UInt64;       overload; static;
    class function TryParse(const S: string; out Value: UInt64): Bool;          static;
    class function TryParseWithSeparators(const s: string; out Value: UInt64; Sep: char): Bool; static; inline;
    class function TryParseWithComma(const s: string; out Value: UInt64): Bool;                 static; inline;
    class function TryParseWithLocalSeparators(const s: string; out Value: UInt64): Bool;       static; inline;

    function ToString: string;                                  overload; inline;
    function ToHexString: string;                               overload; inline;
    function ToHexString(const MinDigits: Integer): string;     overload; inline;
    function ToStringWithSeparators(Separator: char): string;   inline;
    function ToCommaString: string;                             inline;
    function ToLocaleString: string;                            inline;
    function ToPaddedString(MinWidth: NInt; Pad: Char = ' '; Sep: Char = #0): string;   inline;

    function ToBoolean: Bool;                                   inline;
    function ToSingle: Single;                                  inline;
    function ToDouble: Double;                                  inline;
    function ToExtended: Extended;                              inline;

    function Min(const a: UInt64): UInt64;                      overload; inline;
    function Min(const a, b: UInt64): UInt64;                   overload; inline;
    function Max(const a: UInt64): UInt64;                      overload; inline;
    function Max(const a, b: UInt64): UInt64;                   overload; inline;
    function EnsureRange(const Min, Max: UInt64): UInt64;       inline;
    function InRange(const Min, Max: UInt64): Bool;             inline;
    function Sign: NInt;                                        inline;
    function Abs: UInt64;                                       inline;
    function NearestMultiple(n: UInt64): UInt64;                inline;

    procedure SetToSmaller(const a: UInt64);                    overload; inline;
    procedure SetToSmaller(const a, b: UInt64);                 overload; inline;
    procedure SetToSmaller(const a, b, c: UInt64);              overload; inline;
    procedure SetToLarger(const a: UInt64);                     overload; inline;
    procedure SetToLarger(const a, b: UInt64);                  overload; inline;
    procedure SetToLarger(const a, b, c: UInt64);               overload; inline;
    procedure SetToRange(const Min, Max: UInt64);               inline;
    procedure SwapWith(var a: UInt64);                          inline;

    property Bytes[i: NUInt]: UInt8 read GetBytes write SetBytes;
    property Words[i: NUInt]: UInt16 read GetWords write SetWords;
    property Longs[i: NUInt]: UInt32 read GetLongs write SetLongs;
  end;
{$ENDREGION}

{$REGION 'TChar8Helper'}
  TChar8Helper = record helper for Char8
  {$REGION 'Constants'}
  public
    const
      CharSize              = SizeOf(AnsiChar);
      Size                  = CharSize;
      LineFeed              = AnsiChar(#$0A);
      CarriageReturn        = AnsiChar(#$0D);
      TabChar               = AnsiChar(#$09);
      SpaceChar             = AnsiChar(#$20);
      EnterChar             = AnsiChar(#$0D);
      IllegalChar           = '?';
      HexChars: ByteString  = '0123456789ABCDEF';
      ControlChars          = [Ansichar(#00)..AnsiChar(#31), AnsiChar(#$7F)];
      WhitSpaceChars        = [TabChar, LineFeed, CarriageReturn, SpaceChar];
      SeparatorChars        = [Ansichar(#00), TabChar, LineFeed, #$0c, CarriageReturn];
      LineBreakChars        = [LineFeed, CarriageReturn];
      PunctuationChars      = [Ansichar('`'),  '~', '!', '(', ')', '-', '{',
                                        '}', '[', ']', ':', ';', '"', '''', ',', '.', '?'];
      NumbersChars          = [Ansichar('0')..'9'];
      AlphaNumChars         = [Ansichar('0')..'9', 'A'..'Z', 'a'..'z'];
      LetterChars           = [Ansichar('A')..'Z', 'a'..'z'];
      UpcaseChars           = [Ansichar('A')..'Z'];
      LowcaseChars          = [Ansichar('a')..'a'];
      HexNumChars           = [Ansichar('0')..'9', 'A'..'F', 'a'..'f'];
  {$ENDREGION}
  public
    // Test if the AnsiChar belongs to a type; returns false for $80..$FF
    function IsControlA: Boolean;                               inline;
    function IsDigitA: Boolean;                                 inline;
    function IsDigitOrDotA: Boolean;                            inline;
    function IsHexDigitA: Boolean;                              inline;
    function IsLetterA: Boolean;                                inline;
    function IsLetterOrDigitA: Boolean;                         inline;
    function IsLowerA: Boolean;                                 inline;
    function IsUpperA: Boolean;                                 inline;
    function IsSeparatorA: Boolean;                             inline;
    function IsPunctuationA: Boolean;                           inline;
    function IsWhiteSpaceA: Boolean;                            inline;
    function IsLineBreakA: Boolean;                             inline;
    // Test if the ansichar is in the set.
    function IsInSet(const ASet: TSysCharSet): Boolean;         inline;
    // Test if the ansichar is in the array.
    function IsInArray(const AnArray: array of Char8): Boolean;
    function InRange(const Min, Max: Char8): Bool;              inline;

    function ToUpperA: AnsiChar;                                inline;
    function ToLowerA: AnsiChar;                                inline;
    function ToInteger: Integer;                                inline; // = ord(self);
    function ToHexString: string;                               overload; inline;
    function ToHexString(const MinDigits: Integer): string;     overload; inline;
    function ToIntString: string;                               inline; // Dec code
    function ToChar16A: Char16;                                 inline; // Should be good only for #$00..#$7F
    function ToChar32A: Char32;                                 inline; // Should be good only for #$00..#$7F

    procedure ChangeToUpper;                                    inline;
    procedure ChangeToLower;                                    inline;
    procedure SwapWith(var a: Char8);                           inline;
  end;
{$ENDREGION}
{$REGION 'TChar16Helper'}
  // All the built-in string-related class functions are not included.
  // All the built-in USC4Char-related class functions are moved to TChar32Helper.
  TChar16Helper = record helper for Char16
  {$REGION 'Constants'}
  public
    const
      CharSize              = SizeOf(Char);
      Size                  = CharSize;
      LineFeed              = #$000A;
      CarriageReturn        = #$000D;
      TabChar               = #$0009;
      SpaceChar             = #$0020;
      EnterChar             = #$000D;
      IllegalChar           = '?';

      MinHighSurrogate      = #$D800;
      MaxHighSurrogate      = #$DBFF;
      MinLowSurrogate       = #$DC00;
      MaxLowSurrogate       = #$DFFF;
      MinSurrogate          = #$D800;
      MaxSurrogate          = #$DFFF;

      MinHighSurrogateCode  = $D800;
      MaxHighSurrogateCode  = $DBFF;
      MinLowSurrogateCode   = $DC00;
      MaxLowSurrogateCode   = $DFFF;
      MinSurrogateCode      = $D800;
      MaxSurrogateCode      = $DFFF;

      SurrogateTestMask     = $F800;    // Is Surrogate?      Ord(Char16) and SurrogateTestMask = SurrogateTestValue
      SurrogateTestValue    = $D800;
      SurrogateTestMask2    = $FC00;    // Is High surrogate? Ord(Char16) and SurrogateTestMask2 = SurrogateTestHigh
      SurrogateTestHigh     = $D800;    // Is Low surrogate?  Ord(Char16) and SurrogateTestMask2 = SurrogateTestLow
      SurrogateTestLow      = $D800;

      SurrogateCodeBase     = $10000;
      SurrogateBitShift     = 10;
      SurrogateBitMask      = $03FF;
      HexChars: string      = '0123456789ABCDEF';
  {$ENDREGION}
  {$REGION 'Delphi built-in functions'}
  public
    function GetNumericValue: Double;                                   inline;
    function GetUnicodeCategory: TUnicodeCategory;                      inline;
    function IsControl: Boolean;                                        inline;
    function IsDefined: Boolean;                                        inline;
    function IsDigit: Boolean;                                          inline;
    function IsHighSurrogate: Boolean;                                  inline;
    function IsInArray(const SomeChars: array of Char): Boolean;
    function IsLetter: Boolean;                                         inline;
    function IsLetterOrDigit: Boolean;                                  inline;
    function IsLower: Boolean;                                          inline;
    function IsLowSurrogate: Boolean;                                   inline;
    function IsNumber: Boolean;                                         inline;
    function IsPunctuation: Boolean;                                    inline;
    function IsSeparator: Boolean;                                      inline;
    function IsSurrogate: Boolean;                                      inline;
    function IsSymbol: Boolean;                                         inline;
    function IsUpper: Boolean;                                          inline;
    function IsWhiteSpace: Boolean;                                     inline;
    function ToLower: Char;                                             inline;
    function ToUpper: Char;                                             inline;
    function ToUCS4Char: UCS4Char;                                      inline;
  {$ENDREGION}
  public
    function IsASCII: Boolean;                                          inline;
    function IsControlA: Boolean;                                       inline;
    function IsDigitA: Boolean;                                         inline;
    function IsDigitOrDotA: Boolean;                                    inline;
    function IsHexDigitA: Boolean;                                      inline;
    function IsLetterA: Boolean;                                        inline;
    function IsLetterOrDigitA: Boolean;                                 inline;
    function IsLowerA: Boolean;                                         inline;
    function IsUpperA: Boolean;                                         inline;
    function IsSeparatorA: Boolean;                                     inline;
    function IsPunctuationA: Boolean;                                   inline;
    function IsWhiteSpaceA: Boolean;                                    inline;
    function IsLineBreakA: Boolean;                                     inline;
    function IsInSet(const ASet: TSysCharSet): Boolean;                 inline;
    function InRange(const Min, Max: Char16): Bool;                     inline;

    // These functions directly test the code points, should be faster but may be inaccurate
    function IsChineseLetter: Boolean;
    function IsCJK: Boolean;                                            inline;
    function IsPunctuationCJK: Boolean;
    function IsLineBreakCJK: Boolean;                                   inline;
    function IsWordCharCJK: Boolean;                                    inline;
    function IsWordChar: Boolean;                                       inline;

    function ToUpperA: WideChar;                                        inline;
    function ToLowerA: WideChar;                                        inline;
    function ToInteger: Integer;                                        inline; // = ord(self);
    function ToHexString: string;                                       overload; inline;
    function ToHexString(const MinDigits: Integer): string;             overload; inline;
    function ToIntString: string;                                       inline; // Dec code
    function ToChar32: Char32;                                          inline;

    procedure ChangeToUpper;                                            inline;
    procedure ChangeToLower;                                            inline;
    procedure ChangeToUpperA;                                           inline;
    procedure ChangeToLowerA;                                           inline;
    procedure SwapWith(var a: Char16);                                  inline;
  end;
{$ENDREGION}

{$REGION 'TFloat32Helper'}
  TFloat32Helper = record helper for Float32
  private
    function InternalGetBytes(i: NUInt): UInt8;                 inline;
    function InternalGetWords(i: NUInt): UInt16;                inline;
    procedure InternalSetBytes(i: NUInt; const Value: UInt8);   inline;
    procedure InternalSetWords(i: NUInt; const Value: UInt16);  inline;

    function  GetBytes(i: NUInt): UInt8;                        inline;
    function  GetWords(i: NUInt): UInt16;                       inline;
    procedure SetBytes(i: NUInt; Value: UInt8);                 inline;
    procedure SetWords(i: NUInt; Value: UInt16);                inline;

    function GetExp: UInt64;                                    inline;
    function GetFrac: UInt64;                                   inline;
    function GetSign: Bool;                                     inline;
    procedure SetExp(NewExp: UInt64);
    procedure SetFrac(NewFrac: UInt64);
    procedure SetSign(NewSign: Bool);
  public        // Built-in
    const
     // Unlike SysUtils.Float32Helper, this is defined without type, so that it can be used to define other consts
      Epsilon                   = Float32(1.4012984643248170709e-45);
      MaxValue                  = Float32(+340282346638528859811704183484516925440.0);
      MinValue                  = Float32(-340282346638528859811704183484516925440.0);
      PositiveInfinity          = Float32(+1.0 / 0.0);
      NegativeInfinity          = Float32(-1.0 / 0.0);
      NaN                       = Float32( 0.0 / 0.0);
      Size                      = SizeOf(Float32);

    class function ToString(const Value: Float32): string;                                              overload; inline; static;
    class function ToString(const Value: Float32; const AFormatSettings: TFormatSettings): string;      overload; inline; static;
    class function ToString(const Value: Float32; const Format: TFloatFormat; const Precision, Digits: NInt): string;   overload; inline; static;
    class function ToString(const Value: Float32; const Format: TFloatFormat; const Precision, Digits: NInt;
                               const AFormatSettings: TFormatSettings): string;                         overload; inline; static;
    class function Parse(const S: string; const AFormatSettings: TFormatSettings): Float32;             overload; static;
    class function Parse(const S: string): Float32;                                                     overload; inline; static;
    class function TryParse(const S: string; out Value: Float32; const AFormatSettings: TFormatSettings): Bool;         overload; static;
    class function TryParse(const S: string; out Value: Float32; AllowPrecent: Boolean = False): Bool;  overload; inline; static;
    class function IsNan(const Value: Float32): Bool;                                                   overload; inline; static;
    class function IsInfinity(const Value: Float32): Bool;                                              overload; inline; static;
    class function IsNegativeInfinity(const Value: Float32): Bool;                                      overload; inline; static;
    class function IsPositiveInfinity(const Value: Float32): Bool;                                      overload; inline; static;

    function Exponent: Int32;
    function Fraction: Extended;
    function Mantissa: UInt64;

    function SpecialType: TFloatSpecial;
    procedure BuildUp(const SignFlag: Bool; const Mantissa: UInt64; const Exponent: Int32);
    function ToString: string;                                                                          overload; inline;
    function ToString(const AFormatSettings: TFormatSettings): string;                                  overload; inline;
    function ToString(const Format: TFloatFormat; const Precision, Digits: NInt): string;               overload; inline;
    function ToString(const Format: TFloatFormat; const Precision, Digits: NInt;
                         const AFormatSettings: TFormatSettings): string;                               overload; inline;
    function IsNan: Bool;                                                                               overload; inline;
    function IsInfinity: Bool;                                                                          overload; inline;
    function IsNegativeInfinity: Bool;                                                                  overload; inline;
    function IsPositiveInfinity: Bool;                                                                  overload; inline;

    property Sign: Bool                 read GetSign    write SetSign;
    property Exp: UInt64                read GetExp     write SetExp;
    property Frac: UInt64               read GetFrac    write SetFrac;
    property Bytes[i: NUInt]: UInt8     read GetBytes   write SetBytes;
    property Words[i: NUInt]: UInt16    read GetWords   write SetWords;
  public
    const
      TotalBits                 = 32;                                   // 32
      ExponentBits              = 8;                                    //  8
      FractionBits              = TotalBits - 1 - ExponentBits;         // 23
      SignBit                   = (TotalBits - 1);                      // 31
      ExponentBitH              = SignBit - 1;                          // 30
      ExponentBitL              = SignBit - ExponentBits;               // 23
      FractionBitH              = ExponentBitL - 1;                     // 22
      FractionBitL              = 0;                                    //  0
      SignMask                  = 1 shl SignBit;                        // $80000000
      ShiftedExponentMask       = (1 shl ExponentBits - 1);             // $000000FF
      ExponentMask              = ShiftedExponentMask shl ExponentBitL; // $7F100000
      FractionMask              = (1 shl FractionBits - 1);             // $007FFFFF
      ExponentBias              = ShiftedExponentMask shr 1;            // $0000007F = 127
      DenormalExpBias           = ExponentBias - 1 + FractionBits;      // $00000095 = 149

    class function Parse(const S: string; const Default: Float32): Float32;                                     overload; static; inline;
    class function TryParseWithSeparators(const s: string; out Value: Float32; KSep, DSep, FSep: char): Bool;   overload; static; inline;
    class function TryParseWithSeparators(const s: string; out Value: Float32; KSep, DSep: char): Bool;         overload; static; inline;
    class function TryParseWithComma(const s: string; out Value: Float32): Bool;                                static; inline;
    class function TryParseWithLocalSeparators(const s: string; out Value: Float32): Bool;                      static; inline;

    function ToStringWithSeparators(nFrac: NInt; KSep, DSep, FSep: char): string;                       overload; inline;
    function ToStringWithSeparators(nFrac: NInt; KSep, DSep: char): string;                             overload; inline;
    function ToCommaString(nFrac: NInt; NoTraillingZero: Bool = False): string;                         overload; inline;
    function ToLocaleString(nFrac: NInt; NoTraillingZero: Bool = False): string;                        overload; inline;
    function ToScientificString(nFrac: NInt; DSep, FSep: Char): string;                                 inline;
    function ToRoundedString: string;                                                                   overload;
    function ToRoundedString(const Fmt: string): string;                                                overload;        // can use one and only one %g or %s

    function ToFloat64: Float64;                                inline;
    function ToFloatEx: FloatEx;                                inline;
    function RoundTo(nFrac: NInt): Float32;                     inline;
    function Round: Int64;                                      inline;         // Round toward nearest
    function RoundUp: Int64;                                    inline;         // Round toward larger
    function RoundDown: Int64;                                  inline;         // Round toward smaller
    function Trunc: Int64;                                      inline;         // Round toward 0
    function SignInt: NInt;                                     inline;
    function Abs: Float32;                                      inline;

    function Min(const a: Float32): Float32;                    overload; inline;
    function Min(const a, b: Float32): Float32;                 overload; inline;
    function Max(const a: Float32): Float32;                    overload; inline;
    function Max(const a, b: Float32): Float32;                 overload; inline;
    function EnsureRange(const Min, Max: Float32): Float32;     inline;
    function InRange(const Min, Max: Float32): Bool;            inline;
    function NearestMultiple(n: Int64): Int64;                  inline;
    function NearestMultipleF(n: Float32): Float32;             inline;

    procedure SetToSmaller(const a: Float32);                   overload; inline;
    procedure SetToSmaller(const a, b: Float32);                overload; inline;
    procedure SetToSmaller(const a, b, c: Float32);             overload; inline;
    procedure SetToLarger(const a: Float32);                    overload; inline;
    procedure SetToLarger(const a, b: Float32);                 overload; inline;
    procedure SetToLarger(const a, b, c: Float32);              overload; inline;
    procedure SetToRange(const Min, Max: Float32);              inline;
    procedure SwapWith(var a: Float32);                         inline;
  end;
{$ENDREGION}
{$REGION 'TFloat64Helper'}
  TFloat64Helper = record helper for Float64
  private
    function InternalGetBytes(i: NUInt): UInt8;                 inline;
    function InternalGetWords(i: NUInt): UInt16;                inline;
    procedure InternalSetBytes(i: NUInt; const Value: UInt8);   inline;
    procedure InternalSetWords(i: NUInt; const Value: UInt16);  inline;

    function  GetBytes(i: NUInt): UInt8;                        inline;
    function  GetWords(i: NUInt): UInt16;                       inline;
    procedure SetBytes(i: NUInt; Value: UInt8);                 inline;
    procedure SetWords(i: NUInt; Value: UInt16);                inline;

    function GetExp: UInt64;                                    inline;
    function GetFrac: UInt64;                                   inline;
    function GetSign: Bool;                                     inline;
    procedure SetExp(NewExp: UInt64);
    procedure SetFrac(NewFrac: UInt64);
    procedure SetSign(NewSign: Bool);
  public        // Built-in
    const
      Epsilon                   = Float64(4.9406564584124654418e-324);
      MaxValue                  = Float64(+1.7976931348623157081e+308);
      MinValue                  = Float64(-1.7976931348623157081e+308);
      PositiveInfinity          = Float64(+1.0 / 0.0);
      NegativeInfinity          = Float64(-1.0 / 0.0);
      NaN: Float64              = Float64( 0.0 / 0.0);
      Size                      = SizeOf(Float64);

    class function ToString(const Value: Float64): string;                                              overload; inline; static;
    class function ToString(const Value: Float64; const AFormatSettings: TFormatSettings): string;      overload; inline; static;
    class function ToString(const Value: Float64; const Format: TFloatFormat; const Precision, Digits: NInt): string;   overload; inline; static;
    class function ToString(const Value: Float64; const Format: TFloatFormat; const Precision, Digits: NInt;
                               const AFormatSettings: TFormatSettings): string;                         overload; inline; static;
    class function Parse(const S: string; const AFormatSettings: TFormatSettings): Float64;             overload; static;
    class function Parse(const S: string): Float64;                                                     overload; inline; static;
    class function TryParse(const S: string; out Value: Float64; const AFormatSettings: TFormatSettings): Bool;         overload; static;
    class function TryParse(const S: string; out Value: Float64; AllowPrecent: Boolean = False): Bool;  overload; inline; static;
    class function IsNan(const Value: Float64): Bool;                                                   overload; inline; static;
    class function IsInfinity(const Value: Float64): Bool;                                              overload; inline; static;
    class function IsNegativeInfinity(const Value: Float64): Bool;                                      overload; inline; static;
    class function IsPositiveInfinity(const Value: Float64): Bool;                                      overload; inline; static;

    function Exponent: Int32;
    function Fraction: Extended;
    function Mantissa: UInt64;

    function SpecialType: TFloatSpecial;
    procedure BuildUp(const SignFlag: Bool; const Mantissa: UInt64; const Exponent: Int32);
    function ToString: string;                                                                          overload; inline;
    function ToString(const AFormatSettings: TFormatSettings): string;                                  overload; inline;
    function ToString(const Format: TFloatFormat; const Precision, Digits: NInt): string;               overload; inline;
    function ToString(const Format: TFloatFormat; const Precision, Digits: NInt;
                         const AFormatSettings: TFormatSettings): string;                               overload; inline;
    function IsNan: Bool;                                                                               overload; inline;
    function IsInfinity: Bool;                                                                          overload; inline;
    function IsNegativeInfinity: Bool;                                                                  overload; inline;
    function IsPositiveInfinity: Bool;                                                                  overload; inline;

    property Sign: Bool                 read GetSign    write SetSign;
    property Exp: UInt64                read GetExp     write SetExp;
    property Frac: UInt64               read GetFrac    write SetFrac;
    property Bytes[i: NUInt]: UInt8     read GetBytes   write SetBytes;
    property Words[i: NUInt]: UInt16    read GetWords   write SetWords;
  public
    const
      TotalBits                 = 64;                                   // 64
      ExponentBits              = 11;                                   // 11
      FractionBits              = TotalBits - 1 - ExponentBits;         // 52
      SignBit                   = (TotalBits - 1);                      // 63
      ExponentBitH              = SignBit - 1;                          // 62
      ExponentBitL              = SignBit - ExponentBits;               // 52
      FractionBitH              = ExponentBitL - 1;                     // 51
      FractionBitL              = 0;                                    //  0
      // Delphi will treated this as Integers if not explicited defined
      SignMask                  = $8000000000000000;                    // 1 shl SignBit;
      ShiftedExponentMask       = (1 shl ExponentBits - 1);             // $00000000 000007FF
      ExponentMask              = $7FF0000000000000;                    // ShiftedExponentMask shl ExponentBitL;
      FractionMask              = $007FFFFFFFFFFFFF;                    // (1 shl FractionBits - 1);
      ExponentBias              = ShiftedExponentMask shr 1;            // $00000000 000003FF = 1023
      DenormalExpBias           = ExponentBias - 1 + FractionBits;      // $00000000 00000432 = 1074

    class function Parse(const S: string; const Default: Float64): Float64;                                       overload; static; inline;
    class function TryParseWithSeparators(const s: string; out Value: Float64; KSep, DSep, FSep: char): Bool;  overload; static; inline;
    class function TryParseWithSeparators(const s: string; out Value: Float64; KSep, DSep: char): Bool;        overload; static; inline;
    class function TryParseWithComma(const s: string; out Value: Float64): Bool;                               static; inline;
    class function TryParseWithLocalSeparators(const s: string; out Value: Float64): Bool;                     static; inline;

    function ToStringWithSeparators(nFrac: NInt; KSep, DSep, FSep: char): string;                       overload; inline;
    function ToStringWithSeparators(nFrac: NInt; KSep, DSep: char): string;                             overload; inline;
    function ToCommaString(nFrac: NInt; NoTraillingZero: Bool = False): string;                         overload; inline;
    function ToLocaleString(nFrac: NInt; NoTraillingZero: Bool = False): string;                        overload; inline;
    function ToScientificString(nFrac: NInt; DSep, FSep: Char): string;                                 inline;
    function ToRoundedString: string;                                                                   overload;
    function ToRoundedString(const Fmt: string): string;                                                overload;        // can use one and only one %g or %s

    function ToFloat32: Float32;                                inline;
    function ToFloatEx: FloatEx;                                inline;
    function RoundTo(nFrac: NInt): Float64;                     inline;
    function Round: Int64;                                      inline;         // Round toward nearest
    function RoundUp: Int64;                                    inline;         // Round toward larger
    function RoundDown: Int64;                                  inline;         // Round toward smaller
    function Trunc: Int64;                                      inline;         // Round toward 0
    function SignInt: NInt;                                     inline;
    function Abs: Float64;                                      inline;

    function Min(const a: Float64): Float64;                    overload; inline;
    function Min(const a, b: Float64): Float64;                 overload; inline;
    function Max(const a: Float64): Float64;                    overload; inline;
    function Max(const a, b: Float64): Float64;                 overload; inline;
    function EnsureRange(const Min, Max: Float64): Float64;     inline;
    function InRange(const Min, Max: Float64): Bool;            inline;
    function NearestMultiple(n: Int64): Int64;                  inline;
    function NearestMultipleF(n: Float64): Float64;             inline;

    procedure SetToSmaller(const a: Float64);                   overload; inline;
    procedure SetToSmaller(const a, b: Float64);                overload; inline;
    procedure SetToSmaller(const a, b, c: Float64);             overload; inline;
    procedure SetToLarger(const a: Float64);                    overload; inline;
    procedure SetToLarger(const a, b: Float64);                 overload; inline;
    procedure SetToLarger(const a, b, c: Float64);              overload; inline;
    procedure SetToRange(const Min, Max: Float64);              inline;
    procedure SwapWith(var a: Float64);                         inline;
  end;
{$ENDREGION}
{$REGION 'TFloatExHelper'}
  // This of course is needed for 32-bit Intel system, but it is also needed for 64-but system
  // On 64-bit Delphi programs, division of two integers returns Extended; and also Extended is same as
  // Double, they are different types. With defining this helper, this code failed on 64-bit program:
  //   (i / 255).RoundTo(3);
  TFloatExHelper = record helper for Extended   // Extended not FloatEx
  private
    function InternalGetBytes(i: NUInt): UInt8;                 inline;
    function InternalGetWords(i: NUInt): UInt16;                inline;
    procedure InternalSetBytes(i: NUInt; const Value: UInt8);   inline;
    procedure InternalSetWords(i: NUInt; const Value: UInt16);  inline;

    function  GetBytes(i: NUInt): UInt8;                        inline;
    function  GetWords(i: NUInt): UInt16;                       inline;
    procedure SetBytes(i: NUInt; Value: UInt8);                 inline;
    procedure SetWords(i: NUInt; Value: UInt16);                inline;

    function GetExp: UInt64;                                    inline;
    function GetFrac: UInt64;                                   inline;
    function GetSign: Bool;                                     inline;
    procedure SetExp(NewExp: UInt64);
    procedure SetFrac(NewFrac: UInt64);
    procedure SetSign(NewSign: Bool);
  public        // Built-in
    const
     // Unlike SysUtils.FloatExHelper, this is defined without type, so that it can be used to define other consts
      Epsilon           = FloatEx(3.64519953188247460253e-4951);
      MaxValue          = FloatEx(+1.18973149535723176505e+4932);
      MinValue          = FloatEx(-1.18973149535723176505e+4932);
      PositiveInfinity  = FloatEx(+1.0 / 0.0);
      NegativeInfinity  = FloatEx(-1.0 / 0.0);
      NaN               = FloatEx( 0.0 / 0.0);
      Size              = SizeOf(FloatEx);

    class function ToString(const Value: FloatEx): string;                                              overload; inline; static;
    class function ToString(const Value: FloatEx; const AFormatSettings: TFormatSettings): string;      overload; inline; static;
    class function ToString(const Value: FloatEx; const Format: TFloatFormat; const Precision, Digits: NInt): string;   overload; inline; static;
    class function ToString(const Value: FloatEx; const Format: TFloatFormat; const Precision, Digits: NInt;
                               const AFormatSettings: TFormatSettings): string;                         overload; inline; static;
    class function Parse(const S: string; const AFormatSettings: TFormatSettings): FloatEx;             overload; static;
    class function Parse(const S: string): FloatEx;                                                     overload; inline; static;
    class function TryParse(const S: string; out Value: FloatEx; const AFormatSettings: TFormatSettings): Bool;         overload; static;
    class function TryParse(const S: string; out Value: FloatEx; AllowPrecent: Boolean = False): Bool;  overload; inline; static;
    class function IsNan(const Value: FloatEx): Bool;                                                   overload; inline; static;
    class function IsInfinity(const Value: FloatEx): Bool;                                              overload; inline; static;
    class function IsNegativeInfinity(const Value: FloatEx): Bool;                                      overload; inline; static;
    class function IsPositiveInfinity(const Value: FloatEx): Bool;                                      overload; inline; static;

    function Exponent: Int32;
    function Fraction: Extended;
    function Mantissa: UInt64;

    function SpecialType: TFloatSpecial;
    procedure BuildUp(const SignFlag: Bool; const Mantissa: UInt64; const Exponent: Int32);
    function ToString: string;                                                                          overload; inline;
    function ToString(const AFormatSettings: TFormatSettings): string;                                  overload; inline;
    function ToString(const Format: TFloatFormat; const Precision, Digits: NInt): string;               overload; inline;
    function ToString(const Format: TFloatFormat; const Precision, Digits: NInt;
                         const AFormatSettings: TFormatSettings): string;                               overload; inline;
    function IsNan: Bool;                                                                               overload; inline;
    function IsInfinity: Bool;                                                                          overload; inline;
    function IsNegativeInfinity: Bool;                                                                  overload; inline;
    function IsPositiveInfinity: Bool;                                                                  overload; inline;

    property Sign: Bool                 read GetSign    write SetSign;
    property Exp: UInt64                read GetExp     write SetExp;
    property Frac: UInt64               read GetFrac    write SetFrac;
    property Bytes[i: NUInt]: UInt8     read GetBytes   write SetBytes;
    property Words[i: NUInt]: UInt16    read GetWords   write SetWords;
  public
    const
      TotalBits                 = 80;                                   // 80
      ExponentBits              = 15;                                   // 15
      IntegerBits               = 1;
      FractionBits              = TotalBits - 1 - ExponentBits - IntegerBits; // 63
      SignBit                   = (TotalBits - 1);                      // 79
      ExponentBitH              = SignBit - 1;                          // 78
      ExponentBitL              = SignBit - ExponentBits;               // 64
      IntegerBit                = 63;                                   // 63
      FractionBitH              = IntegerBit - 1;                       // 62
      FractionBitL              = 0;                                    //  0
      // SignMask                  = 1 shl SignBit;                     // Out of Range
      ShiftedExponentMask       = (1 shl ExponentBits - 1);             // $00007FFF
      // ExponentMask              = ShiftedExponentMask shl ExponentBitL; // Out of Range
      // FractionMask              = (1 shl FractionBits - 1);             // $3FFF_FFFF_FFFF_FFFF
      FractionMask              = $3FFF_FFFF_FFFF_FFFF;
      ExponentBias              = ShiftedExponentMask shr 1;            // $00003FFF = 16383
      DenormalExpBias           = ExponentBias - 1 + FractionBits;      // $0000403D = 16445

    class function Parse(const S: string; const Default: FloatEx): FloatEx;                                     overload; static; inline;
    class function TryParseWithSeparators(const s: string; out Value: FloatEx; KSep, DSep, FSep: char): Bool;   overload; static; inline;
    class function TryParseWithSeparators(const s: string; out Value: FloatEx; KSep, DSep: char): Bool;         overload; static; inline;
    class function TryParseWithComma(const s: string; out Value: FloatEx): Bool;                                static; inline;
    class function TryParseWithLocalSeparators(const s: string; out Value: FloatEx): Bool;                      static; inline;

    function ToStringWithSeparators(nFrac: NInt; KSep, DSep, FSep: char): string;                       overload; inline;
    function ToStringWithSeparators(nFrac: NInt; KSep, DSep: char): string;                             overload; inline;
    function ToCommaString(nFrac: NInt; NoTraillingZero: Bool = False): string;                         overload; inline;
    function ToLocaleString(nFrac: NInt; NoTraillingZero: Bool = False): string;                        overload; inline;
    function ToScientificString(nFrac: NInt; DSep, FSep: Char): string;                                 inline;
    function ToRoundedString: string;                                                                   overload;
    function ToRoundedString(const Fmt: string): string;                                                overload;        // can use one and only one %g or %s

    function ToFloat64: Float64;                                inline;
    function ToFloat32: Float32;                                inline;
    function RoundTo(nFrac: NInt): FloatEx;                     inline;
    function Round: Int64;                                      inline;         // Round toward nearest
    function RoundUp: Int64;                                    inline;         // Round toward larger
    function RoundDown: Int64;                                  inline;         // Round toward smaller
    function Trunc: Int64;                                      inline;         // Round toward 0
    function SignInt: NInt;                                     inline;
    function Abs: FloatEx;                                      inline;

    function Min(const a: FloatEx): FloatEx;                    overload; inline;
    function Min(const a, b: FloatEx): FloatEx;                 overload; inline;
    function Max(const a: FloatEx): FloatEx;                    overload; inline;
    function Max(const a, b: FloatEx): FloatEx;                 overload; inline;
    function EnsureRange(const Min, Max: FloatEx): FloatEx;     inline;
    function InRange(const Min, Max: FloatEx): Bool;            inline;
    function NearestMultiple(n: Int64): Int64;                  inline;
    function NearestMultipleF(n: FloatEx): FloatEx;             inline;

    procedure SetToSmaller(const a: FloatEx);                   overload; inline;
    procedure SetToSmaller(const a, b: FloatEx);                overload; inline;
    procedure SetToSmaller(const a, b, c: FloatEx);             overload; inline;
    procedure SetToLarger(const a: FloatEx);                    overload; inline;
    procedure SetToLarger(const a, b: FloatEx);                 overload; inline;
    procedure SetToLarger(const a, b, c: FloatEx);              overload; inline;
    procedure SetToRange(const Min, Max: FloatEx);              inline;
    procedure SwapWith(var a: FloatEx);                         inline;
  end;
{$ENDREGION}

{$Region 'TNIntsHelper'}
type
  TNIntsHelper = record helper for TNInts
  strict private
    function GetLength: NInt;                                                   inline;
  public
    type TFilterFunc = reference to function(const Value: NInt): Boolean;

    class function Create(Size: NInt): TNInts;                                 overload; static; inline;
    class function Create(Size: NInt; const FillValue: NInt): TNInts;         overload; static; inline;
    class function Empty: TNInts;                                              static; inline;

    // These will not change Self
    function  IsEmpty: Boolean;                                                           inline;
    function  NotEmpty: Boolean;                                                          inline;
    function  Equals(const Items: array of NInt): Boolean;
    function  IndexOf(const Value: NInt; fromIndex: NInt = 0): NInt;           overload;
    function  LastIndexOf(const Value: NInt): NInt;                            overload; inline;   // fromIndex is included;
    function  LastIndexOf(const Value: NInt; fromIndex: NInt): NInt;           overload;           // fromIndex is included;
    function  Includes(const Value: NInt): Boolean;                            overload; inline;

    // These are mutable
    procedure Clear;                                                                      inline;
    procedure SetLength(Size: NInt);                                            overload; inline;
    procedure SetLength(Size: NInt; const ValueForNewItems: NInt);             overload;
    procedure EnsureLength(Size: NInt);                                                   inline;

    procedure Fill(const FillValue: NInt; Index: NInt = 0);                    overload; inline;
    procedure Fill(const FillValue: NInt; Index, Len: NInt);                   overload;
    procedure FillIndex;                                                        overload; inline;
    procedure FillIndex(Size: NInt);                                            overload; inline;   // Set the Length to Size;
    procedure FillIndexFrom(StartNum: NInt; Index: NInt = 0);                  overload;
    procedure FillIndexFrom(StartNum: NInt; Index, Len: NInt);                 overload;           // May enlarge the array

    function  Add(const Value: NInt): NInt;                                    overload; inline;
    function  AddUnique(const Value: NInt): NInt;                                        inline;
    function  Prepend(const Value: NInt): NInt;                                          inline;
    function  Insert(Index: NInt; const Value: NInt): NInt;                    overload;
    function  Delete(Index: NInt; Len: NInt = 1): NInt;
    function  Remove(const Value: NInt; fromIndex: NInt = 0): Boolean;
    function  RemoveAll(const Value: NInt; fromIndex: NInt = 0): NInt;
    function  Pop: NInt;                                                                 inline;
    function  Dequeue: NInt;                                                             inline;

    procedure Move(FromIndex, ToIndex: NInt);
    procedure Exchange(Index1, Index2: NInt);

    property  Length: NInt               read GetLength;// write SetLength;
  end;
{$ENDREGION}
{$Region 'TObjectsHelper'}
  TObjectsHelper = record helper for TObjects
  strict private
    function GetLength: NInt;                                                   inline;
  public
    class function Create(Size: NInt): TObjects;                                overload; static; inline;
    class function Create(Size: NInt; FillNil: Boolean): TObjects;              overload; static; inline;
    class function Empty: TObjects;                                             static; inline;

    // These will not change Self
    function  IsEmpty: Boolean;                                                           inline;
    function  NotEmpty: Boolean;                                                          inline;
    function  Equals(const Items: array of TObject): Boolean;
    function  IndexOf(const Value: TObject; fromIndex: NInt = 0): NInt;         overload; inline;
    function  LastIndexOf(const Value: TObject): NInt;                          overload; inline;   // fromIndex is included;
    function  LastIndexOf(const Value: TObject; fromIndex: NInt): NInt;         overload; inline;   // fromIndex is included;
    function  Includes(const Value: TObject): Boolean;                          overload; inline;

    // These are mutable
    procedure Clear;                                                                      inline;
    procedure FreeObjectsAndClear;
    procedure SetLength(Size: NInt);                                            overload; inline;
    procedure SetLength(Size: NInt; const ValueForNewItems: TObject);           overload; inline;
    procedure EnsureLength(Size: NInt);                                                   inline;

    procedure Fill(const FillValue: TObject; Index: NInt = 0);                  overload; inline;
    procedure Fill(const FillValue: TObject; Index, Len: NInt);                 overload; inline;
    procedure FillWithNil(Index: NInt = 0);                                     overload; inline;
    procedure FillWithNil(Index, Len: NInt);                                    overload; inline;

    function  Add(const Value: TObject): NInt;                                  overload; inline;
    function  AddUnique(const Value: TObject): NInt;                                      inline;
    function  Prepend(const Value: TObject): NInt;                                        inline;
    function  Insert(Index: NInt; const Value: TObject): NInt;                  overload; inline;
    function  Delete(Index: NInt; Len: NInt = 1): NInt;                         inline;
    function  Remove(const Value: TObject; fromIndex: NInt = 0): Boolean;       inline;
    function  RemoveAll(const Value: TObject; fromIndex: NInt = 0): NInt;       inline;
    function  Pop: TObject;                                                     inline;
    function  Dequeue: TObject;                                                 inline;

    procedure Move(FromIndex, ToIndex: NInt);                                   inline;
    procedure Exchange(Index1, Index2: NInt);                                   inline;

    property  Length: NInt               read GetLength;// write SetLength;
  end;
{$ENDREGION}

{$REGION 'TStringHelper - All immutabale'}
  TFilename = SysUtils.TFileName;
  TStringHelper = record helper for string
  {$REGION 'Delphi Built-in'}
  strict private
    function GetLength: NInt;                                                                   inline;
    function GetChars(Index: NInt): Char;                                                       inline;
  public
    class function Create(const Value: array of Char; StartIndex, Length: NInt): string;        overload; static;
    class function Create(const Value: array of Char): string;                                  overload; static;
    class function Create(C: Char; Count: NInt): string;                                        overload; static; inline;
    class function Copy(const Str: string): string;                                             static; inline;

    class function Format(const Format: string; const args: array of const): string;                                    overload; static;
    class function Join(const Separator: string; const Values: array of string; StartIndex: NInt; Count: NInt): string; overload; static;
    class function Join(const Separator: string; const Values: array of const): string;                                 overload; static;
    class function Join(const Separator: string; const Values: array of string): string;                                overload; static;
    class function Join(const Separator: string; const Values: IEnumerator<string>): string;                            overload; static; inline;
    class function Join(const Separator: string; const Values: IEnumerable<string>): string;                            overload; static; inline;

    class function Compare(const StrA: string; const StrB: string): NInt;                                                                                           overload; static; inline;
    class function Compare(const StrA: string; const StrB: string; IgnoreCase: Boolean): NInt;                                                                      overload; static; inline;
    class function Compare(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt): NInt;                                                 overload; static; inline;
    class function Compare(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt; IgnoreCase: Boolean): NInt;                            overload; static; inline;
    class function Compare(const StrA: string; const StrB: string; LocaleID: TLocaleID): NInt;                                                                      overload; static; inline;
    class function Compare(const StrA: string; const StrB: string; IgnoreCase: Boolean; LocaleID: TLocaleID): NInt;                                                 overload; static; inline;
    class function Compare(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt; LocaleID: TLocaleID): NInt;                            overload; static; inline;
    class function Compare(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt; IgnoreCase: Boolean; LocaleID: TLocaleID): NInt;       overload; static; inline;
    class function Compare(const StrA: string; const StrB: string; Options: TCompareOptions): NInt;                                                                 overload; static; inline;
    class function Compare(const StrA: string; const StrB: string; Options: TCompareOptions; LocaleID: TLocaleID): NInt;                                            overload; static; inline;
    class function Compare(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt; Options: TCompareOptions): NInt;                       overload; static; inline;
    class function Compare(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt; Options: TCompareOptions; LocaleID: TLocaleID): NInt;  overload; static; inline;
    class function CompareOrdinal(const StrA: string; const StrB: string): NInt;                                                                                    overload; static; inline;
    class function CompareOrdinal(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt): NInt;                                          overload; static; inline;
    class function CompareText(const StrA: string; const StrB: string): NInt;                                                                                       overload; static; inline;

    class function Parse(const Value: Integer): string;                                                 overload; static; inline;
    class function Parse(const Value: Int64): string;                                                   overload; static; inline;
    class function Parse(const Value: Boolean): string;                                                 overload; static; inline;
    class function Parse(const Value: Extended): string;                                                overload; static; inline;
    class function ToBoolean(const S: string): Boolean;                                                 overload; static; inline;
    class function ToInteger(const S: string): Int32;                                                 overload; static; inline;
    class function ToInt64(const S: string): Int64;                                                     overload; static; inline;
    class function ToSingle(const S: string): Single;                                                   overload; static; inline;
    class function ToDouble(const S: string): Double;                                                   overload; static; inline;
    class function ToExtended(const S: string): Extended;                                               overload; static; inline;

    class function LowerCase(const S: string): string;                                                  overload; static; inline;
    class function LowerCase(const S: string; LocaleOptions: TLocaleOptions): string;                   overload; static; inline;
    class function UpperCase(const S: string): string;                                                  overload; static; inline;
    class function UpperCase(const S: string; LocaleOptions: TLocaleOptions): string;                   overload; static; inline;

    class function StartsText(const ASubText, AText: string): Boolean;                                  overload; static; inline;
    class function EndsText(const ASubText, AText: string): Boolean;                                    overload; static; inline;
    class function Equals(const StrA, StrB: string): Boolean;                                           overload; static; inline;
    class function IsNullOrEmpty(const Value: string): Boolean;                                         static; inline;
    class function IsNullOrWhiteSpace(const Value: string): Boolean;                                    static; inline;

    function IsEmpty: Boolean;                                                                          inline;
    function GetHashCode: NInt;                                                                         inline;
    function CompareTo(const strB: string): NInt;                                                       overload; inline;
    function Equals(const Value: string): Boolean;                                                      overload; inline;
    function Contains(const Value: string): Boolean;                                                    overload; inline;
    function StartsWith(const Value: string): Boolean;                                                  overload; inline;
    function StartsWith(const Value: string; IgnoreCase: Boolean): Boolean;                             overload;
    function EndsWith(const Value: string): Boolean;                                                    overload; inline;
    function EndsWith(const Value: string; IgnoreCase: Boolean): Boolean;                               overload;

    function IndexOf(value: Char): NInt;                                                                overload; inline;
    function IndexOf(const Value: string): NInt;                                                        overload; inline;
    function IndexOf(Value: Char; StartIndex: NInt): NInt;                                              overload; inline;
    function IndexOf(const Value: string; StartIndex: NInt): NInt;                                      overload; inline;
    function IndexOf(Value: Char; StartIndex: NInt; Count: NInt): NInt;                                 overload; inline;
    function IndexOf(const Value: string; StartIndex: NInt; Count: NInt): NInt;                         overload; inline;
    function LastIndexOf(Value: Char): NInt;                                                            overload; inline;
    function LastIndexOf(const Value: string): NInt;                                                    overload; inline;
    function LastIndexOf(Value: Char; StartIndex: NInt): NInt;                                          overload; inline;
    function LastIndexOf(const Value: string; StartIndex: NInt): NInt;                                  overload; inline;
    function LastIndexOf(Value: Char; StartIndex: NInt; Count: NInt): NInt;                             overload; inline;
    function LastIndexOf(const Value: string; StartIndex: NInt; Count: NInt): NInt;                     overload; inline;
    function IndexOfAny(const AnyOf: array of Char): NInt;                                              overload;
    function IndexOfAny(const AnyOf: array of Char; StartIndex: NInt): NInt;                            overload;
    function IndexOfAny(const AnyOf: array of Char; StartIndex: NInt; Count: NInt): NInt;               overload;
    function IndexOfAnyUnquoted(const AnyOf: array of Char; StartQuote, EndQuote: Char): NInt;          overload;
    function IndexOfAnyUnquoted(const AnyOf: array of Char; StartQuote, EndQuote: Char; StartIndex: NInt): NInt;                overload;
    function IndexOfAnyUnquoted(const AnyOf: array of Char; StartQuote, EndQuote: Char; StartIndex: NInt; Count: NInt): NInt;   overload;
    function LastIndexOfAny(const AnyOf: array of Char): NInt;                                                                  overload;
    function LastIndexOfAny(const AnyOf: array of Char; StartIndex: NInt): NInt;                        overload;
    function LastIndexOfAny(const AnyOf: array of Char; StartIndex: NInt; Count: NInt): NInt;           overload;

    function PadLeft(TotalWidth: NInt): string;                                                         overload; inline;
    function PadLeft(TotalWidth: NInt; PaddingChar: Char): string;                                      overload;
    function PadRight(TotalWidth: NInt): string;                                                        overload; inline;
    function PadRight(TotalWidth: NInt; PaddingChar: Char): string;                                     overload;
    function Trim: string;                                                                              overload; inline;
    function TrimLeft: string;                                                                          overload; inline;
    function TrimRight: string;                                                                         overload; inline;
    function Trim(const TrimChars: array of Char): string;                                              overload;
    function TrimLeft(const TrimChars: array of Char): string;                                          overload;
    function TrimRight(const TrimChars: array of Char): string;                                         overload;
    function TrimEnd(const TrimChars: array of Char): string; deprecated 'Use TrimRight';
    function TrimStart(const TrimChars: array of Char): string; deprecated 'Use TrimLeft';

    procedure CopyTo(SourceIndex: NInt; var destination: array of Char; DestinationIndex: NInt; Count: NInt);   overload;

    // SysUtils.TStringHelper has only one mutable method: Insert. It changes Self and return it.
    // To me, TStringHelper should be kept immutable and mutable methods should be procedure.
    function Insert(StartIndex: NInt; const Value: string): string; deprecated 'Use MString.Insert or the immutable InsertAt.'; inline;
    function Remove(StartIndex: NInt): string;                                                          overload; inline;
    function Remove(StartIndex: NInt; Count: NInt): string;                                             overload; inline;
    function Substring(StartIndex: NInt): string;                                                       overload; inline;
    function Substring(StartIndex: NInt; Length: NInt): string;                                         overload; inline;

    function IsDelimiter(const Delimiters: string; Index: NInt): Boolean;                               inline;
    function CountChar(const C: Char): NInt;                                                            overload; inline;
    function LastDelimiter(const Delims: string): NInt;                                                 overload; inline;
    function LastDelimiter(const Delims: TSysCharSet): NInt;                                            overload; inline;

    function Replace(OldChar, NewChar: Char): string;                                                   overload; inline;       // Replace all
    function Replace(OldChar: Char; NewChar: Char; ReplaceFlags: TReplaceFlags): string;                overload; inline;
    function Replace(const OldValue, NewValue: string): string;                                         overload; inline;       // Replace all
    function Replace(const OldValue, NewValue: string; ReplaceFlags: TReplaceFlags): string;            overload; inline;

    function DeQuotedString: string;                                                                    overload; inline;
    function DeQuotedString(const QuoteChar: Char): string;                                             overload; inline;
    function QuotedString: string;                                                                      overload; inline;
    function QuotedString(const QuoteChar: Char): string;                                               overload; inline;

    function Split(const Separator: array of Char): TArray<string>;                                                                             overload;
    function Split(const Separator: array of Char; Count: NInt): TArray<string>;                                                                overload;
    function Split(const Separator: array of Char; Options: TStringSplitOptions): TArray<string>;                                               overload;
    function Split(const Separator: array of Char; Count: NInt; Options: TStringSplitOptions): TArray<string>;                                  overload;
    function Split(const Separator: array of string): TArray<string>;                                                                           overload;
    function Split(const Separator: array of string; Count: NInt): TArray<string>;                                                              overload;
    function Split(const Separator: array of string; Options: TStringSplitOptions): TArray<string>;                                             overload;
    function Split(const Separator: array of string; Count: NInt; Options: TStringSplitOptions): TArray<string>;                                overload;
    function Split(const Separator: array of Char; Quote: Char): TArray<string>;                                                                overload;
    function Split(const Separator: array of Char; QuoteStart, QuoteEnd: Char): TArray<string>;                                                 overload;
    function Split(const Separator: array of Char; QuoteStart, QuoteEnd: Char; Options: TStringSplitOptions): TArray<string>;                   overload;
    function Split(const Separator: array of Char; QuoteStart, QuoteEnd: Char; Count: NInt): TArray<string>;                                    overload;
    function Split(const Separator: array of Char; QuoteStart, QuoteEnd: Char; Count: NInt; Options: TStringSplitOptions): TArray<string>;      overload;
    function Split(const Separator: array of string; Quote: Char): TArray<string>;                                                              overload;
    function Split(const Separator: array of string; QuoteStart, QuoteEnd: Char): TArray<string>;                                               overload;
    function Split(const Separator: array of string; QuoteStart, QuoteEnd: Char; Options: TStringSplitOptions): TArray<string>;                 overload;
    function Split(const Separator: array of string; QuoteStart, QuoteEnd: Char; Count: NInt): TArray<string>;                                  overload;
    function Split(const Separator: array of string; QuoteStart, QuoteEnd: Char; Count: NInt; Options: TStringSplitOptions): TArray<string>;    overload;

    function ToBoolean: Boolean;                                                                        overload; inline;
    function ToInteger: Int32;                                                                           overload; inline;
    function ToInt64: Int64;                                                                            overload; inline;
    function ToSingle: Single;                                                                          overload; inline;
    function ToDouble: Double;                                                                          overload; inline;
    function ToExtended: Extended;                                                                      overload; inline;
    function ToCharArray: TArray<Char>;                                                                 overload; inline;
    function ToCharArray(StartIndex: NInt; Length: NInt): TArray<Char>;                                 overload; inline;
    function ToLower: string;                                                                           overload; inline;
    function ToLower(LocaleID: TLocaleID): string;                                                      overload; inline;
    function ToLowerInvariant: string;                                                                  inline;
    function ToUpper: string;                                                                           overload; inline;
    function ToUpper(LocaleID: TLocaleID): string;                                                      overload; inline;
    function ToUpperInvariant: string;                                                                  inline;
  public
    const Empty = '';
    property Chars[Index: NInt]: Char read GetChars;
    property Length: NInt read GetLength;
  {$ENDREGION}
  {$REGION 'My Methods'}
  // While it is convinient to have both class function and regular function, like String.Equals and s.Equals
  // It is not very useful and can cause confusions.
  // Here, class functions are defined only for functions that take two or more comparable parameters,
  // like compare(A, B) and CombineString(A, sep, B), here A and B are comparable
  // Any functions regarding one string should be regular. For exmaple, Trim(), HasChar(C), EndsWith(Sub)...
  private
    function GetPointer: PChar;                 inline;
    function GetPLast: PChar;                   inline;
    function GetSafeChars(Index: NInt): Char;   inline;
  public
    const CharSize  = SizeOf(Char);
  public
    class function Create(p: pChar; Len: NInt): string;                                                 overload; static; inline;
    class function CreateFromNullString(p: pChar; MaxLen: NInt): string;                                overload; static;
    class function FromVarRec(const VarRec: tVarRec; var s: string): Bool;                              static;
    class function TryGetUnicodeText(p: Pointer; l: NUInt; var s: string): Bool;                        static;
    class function TryGetUTF8Text(p: Pointer; l: NUInt; var s: string): Bool;                           static;
    class function TryGetAnsiText(p: Pointer; l: NUInt; var s: string): Bool;                           static;
    class function Join(const Values: array of string): string;                                         overload; static;

    class function CompareStr(const StrA, StrB: string): NInt;                                                  overload; static; inline;
    class function CompareStr(const StrA, StrB: string; Locale: TLocaleOptions): NInt;                          overload; static; inline;
    class function CompareText(const StrA, StrB: string; Locale: TLocaleOptions): NInt;                         overload; static; inline;
    class function TextEquals(const StrA, StrB: string): Bool;                                                  overload; static; inline;

    // Return S1+ConditionalSeparator+S2 or S2; regardless if S2 is empty or not
    class function CombineTestLeft(const S1, ConditionalSeparator, S2: string): string;                 overload; static; inline;
    class function CombineTestLeft(const S1: string; cSeparator: Char; const S2: string): string;       overload; static; inline;
    // Return S1 or S1+ConditionalSeparator+S2; regardless if S1 is empty or not
    class function CombineTestRight(const S1, ConditionalSeparator, S2: string): string;                overload; static; inline;
    class function CombineTestRight(const S1: string; cSeparator: Char; const S2: string): string;      overload; static; inline;
    // Return S1 or S1+ConditionalSeparator+S2 or S2
    class function CombineTestBoth(const S1, ConditionalSeparator, S2: string): string;                 overload; static; inline;
    class function CombineTestBoth(const S1: string; cSeparator: Char; const S2: string): string;       overload; static; inline;

    class function IsCharRepeated(p: pChar; Sep: Char; Interval, Count: NInt): Bool;                    overload; static;
    // Is the composed of '0'-'9' only?
    class function IsNaturalNumber(p: pChar): Bool;                                                     overload; static;

    // Char/PChar functions
    function FirstChar: Char;                                                                           inline;         // #0 for empty string
    function LastChar: Char;                                                                            inline;         // #0 for empty string

    // Bool functions
    function NotEmpty: Bool;                                                                            inline;
    function HasChar(Ch: Char): Bool;                                                                   inline;
    function HasChars(const CharSet: string): Bool;                                                     overload;
    function HasChars(const CharSet: TSysCharSet): Bool;                                                overload;

    function IsASCII: Bool;
    function IsASCIILatin: Bool;
    function IsSingleUncodeChar: Bool;
    function IsInteger: Bool;                                                                           inline;
    function IsDecimalInteger: Bool;
    function IsNaturalNumber: Bool;                                                                     overload; inline;
    function IsHexadecimal: Bool;
    function IsStringAt(const Value: string; Pos: NInt): Bool;                                          overload;
    function IsTextAt(const Value: string; Pos: NInt): Bool;                                            overload;

    function Equals(const S: string; IgnoreCase: Bool): Bool;                                           overload; inline;
    function TextEquals(const S: string): Bool;                                                         overload; inline;
    function Contains(const S: string; IgnoreCase: Bool): Bool;                                         overload; inline;
    function ContainsText(const S: string): Bool;                                                       inline;
    function StartsText(const S: string): Bool;                                                         overload; inline;
    function EndsText(const S: string): Bool;                                                           overload; inline;

    // Int functions
    function CountChars(const CharSet: string): NInt;
    function IndexOf(const Value: string; IgnoreCase: Bool; StartIndex: NInt = 0): NInt;                overload; inline;
    function IndexOfAny(const Values: array of string; var Index: NInt; StartIndex: NInt): NInt;        overload;
    function IndexOfWord(const Value: string; StartIndex: NInt = 0; MustStartWord: Bool = True; MustEndWord: Bool = True): NInt; overload;
    function IndexOfText(const Value: string; StartIndex: NInt = 0): NInt;                              overload;
    function LastIndexOfText(const Value: string; StartIndex: NInt): NInt;                              overload;
    function LastIndexOfText(const Value: string): NInt;                                                overload; inline;
    function CompareTextTo(const S: string): NInt;                                                      overload; inline;
    function CompareTo(const S: string; IgnoreCase: Bool): NInt;                                        overload; inline;

    // String functions
    function Left(MaxLen: NInt): string;                                                                inline;
    function Right(MaxLen: NInt): string;                                                               inline;
    function Between(Start, ExclusiveEnd: NInt): string;                                                overload; inline;
    function ExcludeLeft(ExcludeLen: NInt): string;                                                     inline;
    function ExcludeRight(ExcludeLen: NInt): string;                                                    inline;
    function ExcludeBoth(ExcludeLeft, ExcludeRight: NInt): string;                                      inline;
    // From StartIndex to before [s or end]
    function LeftOf(const S: string; StartIndex: NInt = 0): string;                                     overload; inline;
    function LeftOfText(const S: string; StartIndex: NInt = 0): string;                                 overload; inline;
    // From [StartIndex to before s] or ''
    function LazyLeftOf(const S: string; StartIndex: NInt = 0): string;                                 inline;
    function LazyLeftOfText(const S: string; StartIndex: NInt = 0): string;                             inline;
    // From StartIndex or [ after s] to end
    function RightOf(const S: string; StartIndex: NInt = 0): string;                                    inline;
    function RightOfText(const S: string; StartIndex: NInt = 0): string;                                inline;
    // From [after s to end] or ''
    function LazyRightOf(const S: string; StartIndex: NInt = 0): string;                                inline;
    function LazyRightOfText(const S: string; StartIndex: NInt = 0): string;                            inline;
    // From StartIndex or [after L] to [before R] or end
    function Between(const L, R: string; StartIndex: NInt = 0): string;                                 overload;
    function BetweenText(const L, R: string; StartIndex: NInt = 0): string;
    // From [after L] to [before R] or ''
    function LazyBetween(const L, R: string; StartIndex: NInt = 0): string;
    function LazyBetweenText(const  L, R: string; StartIndex: NInt = 0): string;

    function ExtractFilePath: string;                                                                   overload; inline; // with trailling pathdelim
    function ExtractFileDir: string;                                                                    overload; inline; // without trailling pathdelim
    function ExtractFileDrive: string;                                                                  overload; inline; // returns '<drive>:' or '\\<servername>\<sharename>'
    function ExtractFileName: string;                                                                   overload; inline; // returns '<Name>.<Ext>' or '<Name>'
    function ExtractFileExt: string;                                                                    overload; inline; // returns '.<Ext>' or '';
    function ExtractOnlyFileName: string;                                                               overload;         // returns '<Name>';
    function ExtractOnlyFileExt: string;                                                                overload;         // returns '<Ext>';
    function ExtractRelativePath(const BasePath: string): string;                                       overload; inline;
    function ChangeFileExt(const Extension: string): string;                                            overload; inline; // Remove Ext and add Extension; so Extension can be any text
    function ChangeFilePath(const Path: string): string;                                                overload; inline; // Path does not need to have trailling pathdelim
    function IncludeTrailingPathDelimiter: string;                                                      overload; inline;
    function ExcludeTrailingPathDelimiter: string;                                                      overload; inline;

    function Replace(const OldValue, NewValue: string; IgnoreCase: Bool; ReplaceAll: Bool = True): string;      overload; inline;       // Replace all
    function ReplaceText(const OldText, NewText: string): string;                                       inline;       // Replace all
    function ReplaceOne(const OldText, NewText: string; StartIndex: NInt = 0): string;                  overload; inline;       // Replace all
    function ReplaceOne(const OldText, NewText: string; IgnoreCase: Bool; StartIndex: NInt = 0): string;        overload; inline;  // Replace all
    function ReplaceOneText(const OldText, NewText: string; StartIndex: NInt = 0): string;              inline;       // Replace all
    function RepeatReplace(const OldText, NewText: string; IgnoreCase: Bool): string;                   overload; inline;       // Replace all
    function RepeatReplace(const OldText, NewText: string): string;                                     overload; inline;       // Replace all
    function RepeatReplaceText(const OldText, NewText: string): string;                                 inline;       // Replace all

    function ToTitleCase: string;
    function ToLowerA: string;  // only change 'A'..'Z'
    function ToUpperA: string;  // only change 'a'..'Z'

    function RemoveFloatTrailingZeros(DecimalSeparator: char): string;                                  overload;
    function RemoveFloatTrailingZeros: string;                                                          overload; inline;
    function RemoveFloatTrailingZerosLocal: string;                                                     inline;

    function InsertAt(StartIndex: NInt; const Value: string): string;
    function Append(const Value: string): string;                                                       inline;
    function AddPrefix(const Value: string): string;                                                    inline;
    // Add Seps at given GroupWidth     abcdefg.('|', 3) --> abc|def|g
    function AddSepatorsFromLeft(Sep: Char; GroupWidth: NInt): string;
    // Add Seps at given GroupWidth     abcdefg.('|', 3) --> a|bcd|efg
    function AddSepatorsFromRight(Sep: Char; GroupWidth: NInt): string;

    // Procedures
    function  CopyTo(p: pChar): NInt;                                                                   overload; inline;
    function  CopyTo(p: pChar; AddEndZero: Bool): NInt;                                                 overload; inline;
    procedure CopyAndMovePointer(var p: pChar; AddEndZero: Bool = False);                               overload; inline;

    property SafeChars[Index: NInt]: Char read GetSafeChars;
    property AsPChar: PChar     read GetPointer;
    property PFirst: PChar      read GetPointer;
    property PLast: PChar       read GetPLast;
  {$ENDREGION}
  end;
{$ENDREGION}
{$REGION 'TMStringHelper - All mutable'}
  TMStringHelper = record helper for MString
  strict private
    function  GetLength: NInt;                                          inline;
    function  GetChars(Index: NInt): Char;                              inline;
    procedure SetChars(Index: NInt; Value: Char);                       inline;
    function  GetPChars(Index: NInt): PChar;                            inline;
    function  GetPointer: PChar;                                        inline;
    function  GetPLast: PChar;                                          inline;
  public
    procedure MakeUnique; inline;
    procedure SetLength(const NewLength: NInt);                         inline;
    procedure SetTo(p: PChar);                                          overload;
    procedure SetTo(p: PChar; Len: NInt);                               overload; inline;

    procedure Append(const s: string);                                  inline;
    procedure AddPrefix(const s: string);                               inline;
    procedure Insert(StartIndex: NInt; const Value: string);            inline;
    procedure Delete(StartIndex: NInt; Count: NInt);                    overload; inline;
    procedure Delete(StartIndex: NInt);                                 overload; inline;
    procedure DeleteLeft(Count: NInt);                                  inline;
    procedure DeleteRight(Count: NInt);                                 inline;

    function DeleteSepatorsFromLeft(Sep: Char; GroupWidth: NInt): boolean;
    function DeleteSepatorsFromRight(Sep: Char; GroupWidth: NInt): boolean;

    property AsPChar: PChar             read GetPointer;
    property PFirst: PChar              read GetPointer;
    property PLast: PChar               read GetPLast;
    property Chars[Index: NInt]: Char   read GetChars           write SetChars;
    property PChars[Index: NInt]: PChar read GetPChars;
    property Length: NInt               read GetLength;//  write SetLength;
  end;
{$ENDREGION}

{$REGION 'TStringArrayHelper'}
  TStringArrayHelper = record helper for TStringArray
  public
    const Empty = nil;
  {$REGION 'Private functions'}
  strict private
    function  GetCount: NInt;                                                          inline;
  {$ENDREGION}
  public
    class function  Create(Size: NInt): TStringArray;                                                           overload; static; inline;
    class function  Create(const s: string; const Separator: string; SkipEmpty: Bool = False): TStringArray;    overload; static; inline;
    class function  CreateFromLines(const s: string; SkipEmpty: Bool = False): TStringArray;                    overload; static; inline;
    class function  Create(Items: TStrings; SkipEmpty: Bool = False): TStringArray;                     overload;

    procedure Clear;                                                                                    inline;
    procedure SetLength(Size: NInt);                                                                    inline;
    procedure EnsureLength(Size: NInt);                                                                 inline;

    function  IsEmpty: Bool;                                                                            inline;
    function  NotEmpty: Bool;                                                                           inline;
    function  Equals(const Items: array of string): Bool;
    function  TextEquals(const Items: array of string): Bool;
    function  IndexOf(const S: string; fromIndex: NInt = 0): NInt;
    function  IndexOfText(const S: string; fromIndex: NInt = 0): NInt;
    function  LastIndexOf(const S: string): NInt;                                                       overload; inline;
    function  LastIndexOf(const S: string; fromIndex: NInt): NInt;                                      overload;
    function  LastIndexOfText(const S: string): NInt;                                                   overload; inline;
    function  LastIndexOfText(const S: string; fromIndex: NInt): NInt;                                  overload;
    function  Includes(const S: string; fromIndex: NInt = 0): Bool;                                     inline;

    function  AreAllEmpty: Bool;
    function  AreAllNumbers(AcceptPercent: Bool = False): Bool;
    function  AreAllEmptyOrNumbers(AcceptPercent: Bool = False): Bool;
    function  AllStartWith(const s: string; MatchEmpty: Bool = False; IgnoreCase: Bool = False): Bool;
    function  AllEndWith(const s: string; MatchEmpty: Bool = False; IgnoreCase: Bool = False): Bool;
    function  AllContain(const s: string; MatchEmpty: Bool = False; IgnoreCase: Bool = False): Bool;

    // Return the added count
    function  Add(Items: TStrings; SkipEmpty: Bool = False): NInt;                                      overload;

    procedure Assign(Source: TStrings; SkipEmpty: Bool = False);                                        overload; inline;
    procedure AssignTo(Strings: TStrings);                                                              inline;
    function  AddStrings(const s: string; Separator: Char; SkipEmpty: Bool = False): NInt;              overload;  // Nested Call, don't inline
    function  AddStringsStr(const s, Separator: string; SkipEmpty: Bool = False): NInt;
    function  AddLines(const s: string; SkipEmpty: Bool = False): NInt;

    procedure AssignStrings(const S: string; Separator: Char; SkipEmpty: Bool = False);                 inline;
    procedure AssignStringsStr(const S, Separator: string; SkipEmpty: Bool = False);                    inline;
    function  AssignLines(const S: string; SkipEmpty: Bool = False): NInt;                              inline;

    procedure CopyFrom(const Source: array of string; SrcIndex, Len: NInt; TrgIndex: NInt = 0);         overload;   // May change size
    procedure CopyFrom(const Source: TStringArray; SrcIndex, Len: NInt; TrgIndex: NInt = 0);            overload;   // May change size
    function  Slice(Start, ExclusiveEnd: NInt): TStringArray;                                           overload; inline;
    function  Slice(Start: NInt): TStringArray;                                                         overload; inline;

    // Return the index
    function  Add(const s: string): NInt;                                                               overload;
    function  Insert(Index: NInt; const s: string): NInt;                                               overload; inline;
    function  Prepend(const s: string): NInt;                                                           inline;
    function  AddUnique(const s: string): NInt;                                                         inline;
    function  AddUniqueText(const s: string): NInt;                                                     inline;
    function  Push(const s: string): NInt;                                                              inline;
    function  Pop: string;                                                                              inline;
    function  DeQueue: string;                                                                          inline;
    function  Delete(Index: NInt; Len: NInt = 1): NInt;                                                 inline;
    function  Remove(const s: string; fromIndex: NInt = 0): Bool;                                       inline;
    function  RemoveAll(const s: string; fromIndex: NInt = 0): Bool;
    function  RemoveEmptyStrings: NInt;         // Return number of removed items
    function  RemoveDuplicatedStrings: NInt;    // Return number of removed items

    procedure Move(FromIndex, ToIndex: NInt);
    procedure Exchange(Index1, Index2: NInt);                                                           inline;

    procedure Fill(const FillValue: string; Index, Len: NInt);                                          overload;
    procedure Fill(const FillValue: string; Index: NInt = 0);                                           overload; inline;
    procedure TrimStrings;

    function  Join(const Separator: string; Index, Len: NInt): string;
    function  ToString(const Separator: string): string;                                                overload; inline;
    function  ToString(EOLFormat: TEndOfLineFormat): string;                                            overload; inline;
    function  ToString: string;                                                                         overload; inline;

    property  Count: NInt  read GetCount;
    property  Length: NInt read GetCount;// write SetLength;
end;
{$ENDREGION}

{$REGION 'TPointFHelper'}
  // The functions use the Cartesian coordinate system, Use the _Scr version for screen coordinates
  TPointFHelper = record helper for TPointF
  public
    const Origin: TPointF = (X: 0.0; Y: 0.0);
    function  Equals(const Rhs : TPointF) : Bool;                       overload; inline;
    function  NotEqual(const Rhs : TPointF): Bool;                      overload; inline;
    function  Equals(x, y: Float32): Bool;                              overload; inline;
    function  NotEqual(x, y: Float32): Bool;                            overload; inline;
    function  InRect(const Rect: TRectF): Bool;                         inline;

    function  ToString: string;
  end;
{$ENDREGION}

{$REGION 'Numbers'}
type
  Numbers           = record
  public                // Number <-> String
    const Thousand      = 1000;                         // 10 ^ 3
    const Million       = 1000000;                      // 10 ^ 6
    const Billion       = 1000000000;                   // 10 ^ 9
    const Trillion      = 1000000000000;                // 10 ^ 12
    const Quadrillion   = 1000000000000000;             // 10 ^ 15
    const Quintillion   = 1000000000000000000;          // 10 ^ 18
    const KiloByte      = 1024;                         // 2 ^ 10
    const MegaByte      = 1048576;                      // 2 ^ 20
    const GigaByte      = 1073741824;                   // 2 ^ 30
    const TeraByte      = 1099511627776;                // 2 ^ 40
    const PetaByte      = 1125899906842624;             // 2 ^ 50
    const ExaByte       = 1152921504606846976;          // 2 ^ 60

    const HoursPerDay           = 24;
    const MinsPerHour           = 60;
    const SecsPerMin            = 60;
    const MSecsPerSec           = 1000;
    const MinsPerDay            = HoursPerDay * MinsPerHour;
    const SecsPerDay            = MinsPerDay  * SecsPerMin;
    const MSecsPerDay           = SecsPerDay  * MSecsPerSec;
    const SecsPerHour           = MinsPerHour * SecsPerMin;
    const MSecsPerHour          = SecsPerHour * MSecsPerSec;
    const MSecsPerMin           = SecsPerMin  * MSecsPerSec;
    const Days                  = 1;
    const Hours                 = Days / HoursPerDay;
    const Minutes               = Days / MinsPerDay;
    const Seconds               = Days / SecsPerDay;
    const MSeconds              = Days / MSecsPerDay;
    const MilliSeconds          = MSeconds;

    const HexPrefixC: string = '0x';
    const HexPrefixPas: string = '$';

    // When arrays need to grow in size, the step need to be optimized to balance memory
    /// reallocation and memory watse.
    /// Use Grow is calculate the new, expanded size from current Size.
    class function Grow(Size: NInt): NInt;                                                              static;
    // When arrays need to grow in size, the step need to be optimized to balance memory
    /// reallocation and memory watse.
    /// Use GrowSlowly is calculate the new, expanded size from current Size.
    class function GrowSlowly(Size: NInt): NInt;                                                        static;

    // Add the ability to handle hex number starting with 0x.
    class function TryParse(const S: string; out Value: Int32): Boolean;                                overload; static;
    // Add the ability to handle hex number starting with 0x.
    class function TryParse(const S: string; out Value: UInt32): Boolean;                               overload; static;
    // Add the ability to handle hex number starting with 0x.
    class function TryParse(const S: string; out Value: Int64): Boolean;                                overload; static;
    // Add the ability to handle hex number starting with 0x.
    class function TryParse(const S: string; out Value: UInt64): Boolean;                               overload; static;

    // Return string with Separator as the thousand separators.
    class function ToStringWithSeparators(n: UInt64; Separator: char): string;                          overload; static;
    // Return string with "," thousand separators.
    class function ToCommaString(n: UInt64): string;                                                    overload; static; inline;
    // Return string with thousand separators of current locale.
    class function ToLocaleString(n: UInt64): string;                                                   overload; static; inline;
    // Return string with thousand separators of current locale.
    class function ToPaddedString(n: UInt64; MinWidth: NInt; Pad: Char = ' '; Sep: Char = #0): string;  overload; static; inline;
    // Depends on the value (Self = 0, Self = 1, or otherwise), use respctive format string to return the text.
    class function ToReadableString(n: UInt64; const Zero, One, More: string): string;                  overload; static;
    // Return string with Separator as the thousand separators.
    class function ToStringWithSeparators(n: Int64; Separator: char): string;                           overload; static;
    // Return string with "," thousand separators.
    class function ToCommaString(n: Int64): string;                                                     overload; static; inline;
    // Return string with thousand separators of current locale.
    class function ToLocaleString(n: Int64): string;                                                    overload; static; inline;
    // Return string with thousand separators of current locale.
    class function ToPaddedString(n: Int64; MinWidth: NInt; Pad: Char = ' '; Sep: Char = #0): string;   overload; static; inline;

    // Return string with Separator as the thousand separators.
    class function TryParseWithSeparators(const s: string; out Value: UInt64; Sep: char): Boolean;      overload; static;
    // Return string with "," thousand separators.
    class function TryParseWithComma(const s: string; out Value: UInt64): Boolean;                      overload; static; inline;
    // Return string with thousand separators of current locale.
    class function TryParseWithLocalSeparators(const s: string; out Value: UInt64): Boolean;            overload; static; inline;
    // Return string with Separator as the thousand separators.
    class function TryParseWithSeparators(const s: string; out Value: Int64; Sep: char): Boolean;       overload; static;
    // Return string with "," thousand separators.
    class function TryParseWithComma(const s: string; out Value: Int64): Boolean;                       overload; static; inline;
    // Return string with thousand separators of current locale.
    class function TryParseWithLocalSeparators(const s: string; out Value: Int64): Boolean;             overload; static; inline;

    // Return string with thousand separator (KSep), decimal separator (DSep) and
    /// thousandth separator (FSep).
    class function ToStringWithSeparators(const f: FloatEx; nFrac: NInt; KSep, DSep, FSep: char): string;    overload; static;
    // Return string with thousand separator (KSep) and decimal separator (DSep).
    class function ToStringWithSeparators(const f: FloatEx; nFrac: NInt; KSep, DSep: char): string;          overload; static; inline;
    // Return string with "," thousand separators.
    class function ToCommaString(const f: FloatEx; nFrac: NInt; NoTraillingZero: Boolean = False): string;      overload; static; inline;
    // Return string with thousand separators of current locale.
    class function ToLocaleString(const f: FloatEx; nFrac: NInt; NoTraillingZero: Boolean = False): string;     overload;  static; inline;
    // Return Scientific notation with thousandth separator (Sep).
    class function ToScientificString(const f: FloatEx; nFrac: NInt; DSep, FSep: Char): string;                 static;
    // Return string without unncessary precision (anything after 4 0s or 3 9s are removed. That is, 12,000,011 --> 12,000,000;  3,000.06 --> 3,000
    class function ToRoundedString(const f: FloatEx): string;                                           overload; static;
    // Return string without unncessary precision (anything after 4 0s or 3 9s are removed. That is, 12,000,011 --> 12,000,000;  3,000.06 --> 3,000
    class function ToRoundedString(const Fmt: string; const f: FloatEx): string;                        overload; static;       // can use one and only one %g or %s

    // Parse string assuming that it uses thousand separator (KSep), decimal separator (DSep) and thousandth separator (FSep).
    /// It can also parse regular, separator-less strings.
    class function TryParseWithSeparators(const s: string; KSep, DSep, FSep: Char; out Value: FloatEx): boolean;overload; static;
    // Parse string assuming that it uses thousand separator (KSep), decimal separator (DSep).
    /// It can also parse regular, separator-less strings.
    class function TryParseWithSeparators(const s: string; KSep, DSep: Char; out Value: FloatEx): boolean;      overload; static; inline;
    // Parse string with '.' thousand separators and '.' decimal separator and returns if it succeeds. If so, set self to it. The function will not actively check the range.
    class function TryParseWithComma(const s: string; out Value: FloatEx): Boolean;                             overload; static; inline;
    // Parse string with thousand and decimal separators of current locale and returns if it succeeds. If so, set self to it. The function will not actively check the range.
    class function TryParseWithLocalSeparators(const s: string; out Value: FloatEx): Boolean;                   overload; static; inline;
    // Parse string assuming that it uses thousand separator (KSep), decimal separator (DSep) and thousandth separator (FSep).
    /// It can also parse regular, separator-less strings.
    class function TryParseWithSeparators(const s: string; KSep, DSep, FSep: Char; out Value: Float64): boolean;overload; static;
    // Parse string assuming that it uses thousand separator (KSep), decimal separator (DSep).
    /// It can also parse regular, separator-less strings.
    class function TryParseWithSeparators(const s: string; KSep, DSep: Char; out Value: Float64): boolean;      overload; static; inline;
    // Parse string with '.' thousand separators and '.' decimal separator and returns if it succeeds. If so, set self to it. The function will not actively check the range.
    class function TryParseWithComma(const s: string; out Value: Float64): Boolean;                             overload; static; inline;
    // Parse string with thousand and decimal separators of current locale and returns if it succeeds. If so, set self to it. The function will not actively check the range.
    class function TryParseWithLocalSeparators(const s: string; out Value: Float64): Boolean;                   overload; static; inline;
    // Parse string assuming that it uses thousand separator (KSep), decimal separator (DSep).
    /// It can also parse regular, separator-less strings.
    class function TryParseWithSeparators(const s: string; KSep, DSep: Char; out Value: Float32): boolean;      overload; static; inline;
    // Parse string assuming that it uses thousand separator (KSep), decimal separator (DSep) and thousandth separator (FSep).
    /// It can also parse regular, separator-less strings.
    class function TryParseWithSeparators(const s: string; KSep, DSep, FSep: Char; out Value: Float32): boolean;overload; static;
    // Parse string with '.' thousand separators and '.' decimal separator and returns if it succeeds. If so, set self to it. The function will not actively check the range.
    class function TryParseWithComma(const s: string; out Value: Float32): Boolean;                             overload; static; inline;
    // Parse string with thousand and decimal separators of current locale and returns if it succeeds. If so, set self to it. The function will not actively check the range.
    class function TryParseWithLocalSeparators(const s: string; out Value: Float32): Boolean;                   overload; static; inline;

    class function  GetFirstDigits(const Value: FloatEx): NInt;                 overload; static;
    class function  GetFirstDigits(Value: UInt64): NInt;                        overload; static;
    class function  GetLastPrecisionDigits(const Value: Float64): NInt;         overload; static;
    class function  GetLastPrecisionDigits(const Value: Float32): NInt;         overload; static;
    {$IFDEF EXTENDED80}
    class function  GetLastPrecisionDigits(const Value: FloatEx): NInt;         overload; static;
    {$ENDIF}
  end;
{$ENDREGION}

{$REGION 'TObjectHelper'}
  TObjectHelper = class helper for TObject
  protected
    type
      TDestructorThread = class(TThread)
      private
        FObjToFree: TObject;
      protected
        class var FCount: NInt;
        procedure Execute; override;
      public
        constructor Create(ObjToFree: TObject);
        class destructor Destroy;
      end;
  public
    class procedure DelayFree(ObjToFree: TObject);      overload;
    procedure DelayFree; overload;                      inline;
  end;
{$ENDREGION}
{$REGION 'TExceptionHelper'}
  // When ReturnAddress is used in an inline function, it provides the return address of the call site of the inline function.
  TExceptionHelper = class helper for Exception
  public
    // When {$TYPEDADDRESS ON}, CreateRes(@AResSourceString) will fail; these are to make it work; but it is unsafe.
    constructor CreateRes(P: PString);                                                          overload;
    constructor CreateResFmt(P: PString; const Args: array of Const);                           overload;
    constructor CreateResHelp(P: PString; AHelpContext: Int32);                                 overload;
    constructor CreateResFmtHelp(P: PString; const Args: array of Const; AHelpContext: Int32);  overload;
    // Without the Static declaration, EXXX.RaiseError will raise exception of EXXX type
    class procedure RaiseError(const Msg: string);                                              overload;
    class procedure RaiseError(const Msg: string; const Args: array of Const);                  overload;

    class procedure RaiseConvertBoolError(const Value: string);                                 static;
    class procedure RaiseConvertIntError(const Value, TypeName: string);                        overload; static;
    class procedure RaiseConvertIntError(const Value: string);                                  overload; static;
    class procedure RaiseConvertFloatError(const Value, TypeName: string);                      overload; static;
    class procedure RaiseConvertFloatError(const Value: string);                                overload; static;
    class procedure RaiseConvertDateError(const Value: string);                                 static;
    class procedure RaiseConvertTimeError(const Value: string);                                 static;
    class procedure RaiseConvertDateTimeError(const Value: string);                             static;
    class procedure RaiseIncompatibleTypes(const SrcType, TrgType: string);                     static;
    class procedure RaisePercentRangeError(const p: Float);                                     static;
    class procedure RaiseFilenameError(const Filename: TFilename);                              static;
    class procedure RaiseFileNotFound(const Filename: TFilename);                               static;
    class procedure RaiseOpenFileError(const Filename: TFilename);                              static;
    class procedure RaiseCreateFileError(const Filename: TFilename);                            static;
    class procedure RaiseInvalidPointerOperation;                                               static;
    class procedure RaiseIndexError(Index: NInt);                                               overload; static;
    class procedure RaiseIndexError(Index, Upper: NInt);                                        overload; static;
    class procedure RaiseIndexError(Index, Lower, Upper: NInt);                                 overload; static;
    class procedure RaiseDifferentArraySizes;                                                   static;
    class procedure RaiseDifferentImageSizes;                                                   static;
    class procedure RaiseIf_DifferentArraySizes(Len1, Len2: NInt);                              static;
    class procedure RaiseIf_DifferentImageSizes(W1, H1, W2, H2: NInt);                          static;
    class procedure RaiseInvalidFloatingOperation;                                              static;
    class procedure RaiseItemNotFound;                                                          overload; static;
    class procedure RaiseItemNotFound(n: NInt);                                                 overload; static;
    class procedure RaiseItemNotFound(const Value: string);                                     overload; static;
    class procedure RaiseEmptyArrayError;                                                       static;
  end;
{$ENDREGION}
{$REGION 'TFileStreamHelper'}
  TFileStreamHelper = class helper for TFileStream
  public
    constructor CreateForRead(const Filename: TFilename);
    constructor CreateForReadWrite(const Filename: TFilename; AutoCreate: Boolean = False);
    constructor CreateForWrite(const Filename: TFilename);
    constructor CreateForAppend(const Filename: TFilename);
  end;
{$ENDREGION}
{$REGION 'TStreamHelper'}
  TStreamHelper = class helper for TStream
  public
    class function ReadAll(const Filename: TFilename; var Bytes: TBytes): Boolean; overload;
    class function ReadAll(const Filename: TFilename; var S: ByteString): Boolean; overload;

    procedure ReadAll(var Bytes: TBytes);                                       overload;
    procedure ReadAll(var s: ByteString);                                       overload;

    {$REGION 'ReadData/ReadType/ReadRecord/CurrentType'}
    procedure ReadData(var a: Boolean);                        overload; inline;
    procedure ReadData(var a: Char8);                          overload; inline;
    procedure ReadData(var a: Char16);                         overload; inline;
    procedure ReadData(var a: Char32);                         overload; inline;
    procedure ReadData(var a: UInt8);                          overload; inline;
    procedure ReadData(var a: UInt16);                         overload; inline;
    procedure ReadData(var a: UInt32);                         overload; inline;
    procedure ReadData(var a: UInt64);                         overload; inline;
    procedure ReadData(var a: Int8);                           overload; inline;
    procedure ReadData(var a: Int16);                          overload; inline;
    procedure ReadData(var a: Int32);                          overload; inline;
    procedure ReadData(var a: Int64);                          overload; inline;
    procedure ReadData(var a: Float32);                        overload; inline;
    procedure ReadData(var a: Float64);                        overload; inline;
    {$IFDEF EXTENDED80}
    procedure ReadData(var a: FloatEx);                        overload; inline;
    {$ENDIF}
    procedure ReadRecord<T>(var a: T);                         overload; inline;

    procedure ReadBool(var a: Boolean);                        overload; inline;
    procedure ReadChar(var a: Char8);                          overload; inline;
    procedure ReadChar(var a: Char16);                         overload; inline;
    procedure ReadChar(var a: Char32);                         overload; inline;
    procedure ReadUInt(var a: UInt8);                          overload; inline;
    procedure ReadUInt(var a: UInt16);                         overload; inline;
    procedure ReadUInt(var a: UInt32);                         overload; inline;
    procedure ReadUInt(var a: UInt64);                         overload; inline;
    procedure ReadInt(var a: Int8);                            overload; inline;
    procedure ReadInt(var a: Int16);                           overload; inline;
    procedure ReadInt(var a: Int32);                           overload; inline;
    procedure ReadInt(var a: Int64);                           overload; inline;
    procedure ReadFloat(var a: Float32);                       overload; inline;
    procedure ReadFloat(var a: Float64);                       overload; inline;
    {$IFDEF EXTENDED80}
    procedure ReadFloat(var a: FloatEx);                       overload; inline;
    {$ENDIF}
    procedure ReadDateTime(var a: tDateTime);                  overload; inline;
    procedure ReadByte(var a: UInt8);                          overload; inline;
    procedure ReadWord(var a: UInt16);                         overload; inline;
    procedure ReadLong(var a: UInt32);                         overload; inline;

    function  ReadBool: Boolean;                               overload; inline;
    function  ReadChar8: Char8;                                overload; inline;
    function  ReadChar16: Char16;                              overload; inline;
    function  ReadUCS4Char: Char32;                            overload; inline;
    function  ReadUInt8: UInt8;                                overload; inline;
    function  ReadUInt16: UInt16;                              overload; inline;
    function  ReadUInt32: UInt32;                              overload; inline;
    function  ReadUInt64: UInt64;                              overload; inline;
    function  ReadInt8: Int8;                                  overload; inline;
    function  ReadInt16: Int16;                                overload; inline;
    function  ReadInt32: Int32;                                overload; inline;
    function  ReadInt64: Int64;                                overload; inline;
    function  ReadFloat32: Float32;                            overload; inline;
    function  ReadFloat64: Float64;                            overload; inline;
    function  ReadFloatEx: FloatEx;                            overload; inline;
    function  ReadDateTime: tDateTime;                         overload; inline;
    function  ReadRecord<T>: T;                                overload; inline;
    function  ReadChar: Char16;                                overload; inline;
    function  ReadFloat: Float64;                              overload; inline;
    function  ReadByte: UInt8;                                 overload; inline;
    function  ReadWord: UInt16;                                overload; inline;
    function  ReadLong: UInt32;                                overload; inline;

    function  ReadU32VL: UInt32;                                overload;               // XX or FE XXXX or FF XXXX_XXXX
    procedure ReadU32VL(var a: UInt32);                         overload; inline;
    function  ReadU64VL: UInt64;                                overload;               // XX or FD XXXX or FE XXXX_XXXX or FF XXXX_XXXX_XXXX_XXXX
    procedure ReadU64VL(var a: UInt64);                         overload; inline;
    function  ReadU64VL16: UInt64;                              overload;               // XXXX or FFFE XXXX_XXXX or FFFF_FFFF XXXX_XXXX_XXXX_XXXX
    procedure ReadU64VL16(var a: UInt64);                       overload; inline;
    function  ReadU64VL32: UInt64;                              overload;               // XXXX_XXXX or FFFF_FFFF XXXX_XXXX_XXXX_XXXX
    procedure ReadU64VL32(var a: UInt64);                       overload; inline;
    {$ENDREGION}
    {$REGION 'WriteData/WriteType/WriteRecord'}
    procedure WriteBool(const a: Boolean);                     overload; inline;
    procedure WriteChar8(const a: Char8);                      overload; inline;
    procedure WriteChar16(const a: Char16);                    overload; inline;
    procedure WriteUCS4Char(const a: Char32);                  overload; inline;
    procedure WriteUInt8(const a: UInt8);                      overload; inline;
    procedure WriteUInt16(const a: UInt16);                    overload; inline;
    procedure WriteUInt32(const a: UInt32);                    overload; inline;
    procedure WriteUInt64(const a: UInt64);                    overload; inline;
    procedure WriteInt8(const a: Int8);                        overload; inline;
    procedure WriteInt16(const a: Int16);                      overload; inline;
    procedure WriteInt32(const a: Int32);                      overload; inline;
    procedure WriteInt64(const a: Int64);                      overload; inline;
    procedure WriteFloat32(const a: Float32);                  overload; inline;
    procedure WriteFloat64(const a: Float64);                  overload; inline;
    procedure WriteFloatEx(const a: FloatEx);                  overload; inline;
    procedure WriteDateTime(const a: tDateTime);               overload; inline;
    procedure WriteRecord<T>({$IFDEF DELPHI_2010}const{$ELSE}var{$ENDIF} a: T);       inline;  // D2009: (A: T) or (const A: T) cause C8253 internal Error when TStream is subclasses
    procedure WriteChar(const a: Char16);                      overload; inline;
    procedure WriteFloat(const a: Float64);                    overload; inline;
    procedure WriteByte(const a: UInt8);                       overload; inline;
    procedure WriteWord(const a: UInt16);                      overload; inline;
    procedure WriteLong(const a: UInt32);                      overload; inline;

    procedure WriteData(const a: Boolean);                     overload; inline;
    procedure WriteData(const a: Char8);                       overload; inline;
    procedure WriteData(const a: Char16);                      overload; inline;
    procedure WriteData(const a: UInt32);                      overload; inline;
//    procedure WriteData(const a: UInt64);                      overload; inline;
//    procedure WriteData(const a: Double);                      overload; inline;  //  Don't add this; otherwise even the integer will call this

    procedure WriteU32VL(l: UInt32);
    procedure WriteU64VL(l: UInt64);
    procedure WriteU64VL16(l: UInt64);
    procedure WriteU64VL32(l: UInt64);
    {$ENDREGION}
    {$REGION 'ReadStr'}
    // Read.write Strings with prefix 4-byte size
    procedure ReadStr(var s: string; LenChar16: Integer);      overload; inline;
    procedure ReadStrA(var s: ByteString; LenChar8: Integer);  overload; //inline;
    procedure ReadUTF8(var s: string; LenChar8: Integer);      overload; inline;
    function  ReadStr(LenChar16: Integer): string;             overload; inline;
    function  ReadStrA(LenChar8: Integer): ByteString;         overload; inline;
    function  ReadUTF8(LenChar8: Integer): string;             overload; inline;

    procedure ReadStrL(var s: string);                         overload;
    procedure ReadStrLA(var s: ByteString);                    overload;
    procedure ReadUTF8L(var s: string);                        overload; inline;
    function  ReadStrL: string;                                overload; inline;
    function  ReadStrLA: ByteString;                           overload; inline;
    function  ReadUTF8L: string;                               overload; inline;

    procedure ReadStrVL(var s: string);                        overload;
    procedure ReadStrVLA(var s: ByteString);                   overload;
    procedure ReadStrVLX(var s: string);                       overload;        // The shorter of UTF8String ot string
    procedure ReadUTF8VL(var s: string);                       overload; inline;
    function  ReadStrVL: string;                               overload; inline;
    function  ReadStrVLA: ByteString;                          overload; inline;
    function  ReadStrVLX: string;                              overload; inline;
    function  ReadUTF8VL: string;                              overload; inline;
    {$ENDREGION}
    {$REGION 'WriteStr'}
    // Just write the content of a String; There is no way to read because the length is unknown
    // Uses ReadLn or WriteStrL
    procedure WriteStr(const s: string);                            overload; inline;
    procedure WriteStr(const s: string; Start, Len: Integer);       overload; inline;
    procedure WriteStrA(const s: ByteString);                       overload; inline;
    procedure WriteStrA(const s: ByteString; Start, Len: Integer);  overload; inline;
    procedure WriteUTF8(const s: string);                           overload; inline;
    procedure WriteUTF8(const s: string; Start, Len: Integer);      overload; inline;

    procedure WriteStrL(const s: string);                                inline;
    procedure WriteStrLA(const s: ByteString);                           inline;
    procedure WriteUTF8L(const s: string);                               inline;

    // Read.write Strings with prefix 1,3,5-byte size
    procedure WriteStrVL(const s: string);                               inline;
    procedure WriteStrVLA(const s: ByteString);                          inline;
    procedure WriteStrVLX(const s: string);                              inline;
    procedure WriteUTF8VL(const s: string);                              inline;
    {$ENDREGION}
    {$REGION 'Writeln'}
    procedure Writeln;                                         overload; inline;
    procedure WritelnA;                                        overload; inline;
    procedure Writeln(const s: string);                        overload; inline;
    procedure WritelnA(const s: ByteString);                   overload; inline;
    procedure WriteUTF8Ln(const s: string);
    {$ENDREGION}
    {$REGION 'Read/Write Tbytes'}
    function ReadBytes(var Bytes: TBytes; Offset, Count: NInt): NInt;           overload; inline;
    function ReadBytes(var Bytes: TBytes; Count: NInt): NInt;                   overload; inline;
    function WriteBytes(const Bytes: TBytes; Offset, Count: NInt): NInt;        overload; inline;
    function WriteBytes(const Bytes: TBytes; Count: NInt): NInt;                overload; inline;
    {$ENDREGION}
  end;
{$ENDREGION}

const
  {$REGION 'Constants'}
  {$REGION 'Useful Chars'}
  LineFeed              = Char16.LineFeed;
  CarriageReturn        = Char16.CarriageReturn;
  TabChar               = Char16.TabChar;
  SpaceChar             = Char16.SpaceChar;
  MacLineReturn         = CarriageReturn;
  UnixLineReturn        = LineFeed;
  WindowsLineReturn     = CarriageReturn + LineFeed;
  LineReturn1           = CarriageReturn;
  LineReturn2           = LineFeed;
  LineReturnA           : AnsiString = WindowsLineReturn;
  LineReturnW           : string = WindowsLineReturn;
  XMLLineReturn         = Char16(LineReturn2);
  LineReturnXE1         = #$0D00;               // Endian Changed
  LineReturnXE2         = #$0A00;               // Endian Changed
  ExtensionSep          = '.';  // Interestingly, this is not defined by Delphi, probably because it is universally used.

  {$IFDEF MSWINDOWS}
  SystemEOF     = TEndOfLineFormat.elfWindows;
  LineReturn    = WindowsLineReturn;
  {$ENDIF MSWINDOWS}
  {$IFDEF POSIX}
  SystemEOF     = TEndOfLineFormat.elfUnix;
  LineReturn    = UnixLineReturn;
  {$ENDIF POSIX}
  {$IFDEF LINUX}
  SystemEOF     = TEndOfLineFormat.elfUnix;
  LineReturn    = UnixLineReturn;
  {$ENDIF LINUX}
  NewLineStr:  Array[TEndOfLineFormat] of String = (LineReturn, WindowsLineReturn, MacLineReturn, UnixLineReturn);
  NewLineStrA: Array[TEndOfLineFormat] of AnsiString = (LineReturn, WindowsLineReturn, MacLineReturn, UnixLineReturn);
  {$ENDREGION}
  MaximalDate           = Float64.MaxValue;
  vkEnter               = 201;  // private vk for Enter key in numpad
  vkNumpadEqual         = 202;  // private vk for = key in numpad
  {$ENDREGION}

implementation

uses
  System.RTLConsts, System.SysConst, System.Math, System.DateUtils, System.UITypes;

const
  Str_Num0      = '0';
  Str_Num1      = '1';
  Str_NumNeg1   = '-1';

{$REGION 'TInt8Helper'}
{ TInt8Helper }

class function TInt8Helper.ToString(const Value: Int8): string;
begin
  Result := IntToStr(Value);
end;

class function TInt8Helper.Parse(const S: string): Int8;
begin
  if not TryParse(S, Result) then
    Exception.RaiseConvertIntError(s, 'Int8');
end;

class function TInt8Helper.Parse(const S: string; const Default: Int8): Int8;
begin
  if not TryParse(S, Result) then
    Result := Default;
end;

class function TInt8Helper.TryParse(const S: string; out Value: Int8): Boolean;
var
  E: Integer;
begin
  if S.Startswith(Numbers.HexPrefixC)
    then Val(Numbers.HexPrefixPas + S.Substring(2), Value, E)
    else Val(S, Value, E);
  Result := E = 0;
end;

class function TInt8Helper.TryParseWithComma(const s: string; out Value: Int8): Boolean;
var
  Temp: Int64;
begin
  Result := Numbers.TryParseWithComma(s, Temp) and (Temp <= MaxValue) and (Temp >= MinValue);
  if Result then Value := Temp;
end;

class function TInt8Helper.TryParseWithLocalSeparators(const s: string; out Value: Int8): Boolean;
var
  Temp: Int64;
begin
  Result := Numbers.TryParseWithLocalSeparators(s, Temp) and (Temp <= MaxValue) and (Temp >= MinValue);
  if Result then Value := Temp;
end;

class function TInt8Helper.TryParseWithSeparators(const s: string; out Value: Int8; Sep: char): Boolean;
var
  Temp: Int64;
begin
  Result := Numbers.TryParseWithSeparators(s, Temp, Sep) and (Temp <= MaxValue) and (Temp >= MinValue);
  if Result then Value := Temp;
end;

function TInt8Helper.ToString: string;
begin
  Result := IntToStr(Self);
end;

function TInt8Helper.ToHexString: string;
begin
  Result := IntToHex(Self);
end;

function TInt8Helper.ToHexString(const MinDigits: Integer): string;
begin
  Result := IntToHex(Self, MinDigits);
end;

function TInt8Helper.ToStringWithSeparators(Separator: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, Separator);
end;

function TInt8Helper.ToCommaString: string;
begin
  Result := Numbers.ToCommaString(Self);
end;

function TInt8Helper.ToLocaleString: string;
begin
  Result := Numbers.ToLocaleString(Self);
end;

function TInt8Helper.ToPaddedString(MinWidth: NInt; Pad, Sep: Char): string;
begin
  Result := Numbers.ToPaddedString(Self, MinWidth, Pad, Sep);
end;

function TInt8Helper.ToBoolean: Boolean;
begin
  Result := Self <> 0;
end;

function TInt8Helper.ToSingle: Single;
begin
  Result := Self;
end;

function TInt8Helper.ToDouble: Double;
begin
  Result := Self;
end;

function TInt8Helper.ToExtended: Extended;
begin
  Result := Self;
end;


function TInt8Helper.Sign: NInt;
begin
  if Self > 0
    then Result := 1
    else if Self < 0
      then Result := -1
      else Result := 0;
end;

function TInt8Helper.Abs: Int8;
begin
  if Self < 0
    then Result := -Self
    else Result := Self;
end;

function TInt8Helper.EnsureRange(const Min, Max: Int8): Int8;
begin
  if Self > Max then Exit(Max)
  else if Self < Min then Exit(Min)
  else Exit(Self);
end;

function TInt8Helper.InRange(const Min, Max: Int8): Bool;
begin
  Result := (Self >= Min) and (Self <= Max);
end;

function TInt8Helper.Max(const a: Int8): Int8;
begin
  if Self >= a
    then Result := Self
    else Result := a;
end;

function TInt8Helper.Max(const a, b: Int8): Int8;
begin
  Result := ez.Max(Self, a, b);
end;

function TInt8Helper.Min(const a: Int8): Int8;
begin
  if Self <= a
    then Result := Self
    else Result := a;
end;

function TInt8Helper.Min(const a, b: Int8): Int8;
begin
  Result := ez.Min(Self, a, b);
end;

function TInt8Helper.NearestMultiple(n: Int8): Int8;
begin
  Result := (Self + n shr 1) div n * n;
end;

procedure TInt8Helper.SetToLarger(const a: Int8);
begin
  if Self < a then Self := a;
end;

procedure TInt8Helper.SetToLarger(const a, b: Int8);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
end;

procedure TInt8Helper.SetToLarger(const a, b, c: Int8);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
  if Self < c then Self := c;
end;

procedure TInt8Helper.SetToSmaller(const a: Int8);
begin
  if Self > a then Self := a;
end;

procedure TInt8Helper.SetToSmaller(const a, b: Int8);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
end;

procedure TInt8Helper.SetToSmaller(const a, b, c: Int8);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
  if Self > c then Self := c;
end;

procedure TInt8Helper.SetToRange(const Min, Max: Int8);
begin
  if Self > Max then Self := Max
  else if Self < Min then Self := Min;
end;

procedure TInt8Helper.SwapWith(var a: Int8);
begin
  var Temp := a;
  a := Self;
  Self := Temp;
end;
{$ENDREGION}

{$REGION 'TUInt8Helper'}
{ TUInt8Helper }

class function TUInt8Helper.ToString(const Value: UInt8): string;
begin
  Result := IntToStr(Value);
end;

class function TUInt8Helper.Parse(const S: string): UInt8;
begin
  if not TryParse(S, Result) then
    Exception.RaiseConvertIntError(s, 'UInt8');
end;

class function TUInt8Helper.Parse(const S: string; const Default: UInt8): UInt8;
begin
  if not TryParse(S, Result) then
    Result := Default;
end;

class function TUInt8Helper.TryParse(const S: string; out Value: UInt8): Boolean;
var
  E: Integer;
begin
  if S.Startswith(Numbers.HexPrefixC)
    then Val(Numbers.HexPrefixPas + S.Substring(2), Value, E)
    else Val(S, Value, E);
  Result := E = 0;
end;

class function TUInt8Helper.TryParseWithComma(const s: string; out Value: UInt8): Boolean;
var
  Temp: UInt64;
begin
  Result := Numbers.TryParseWithComma(s, Temp) and (Temp <= MaxValue);
  if Result then Value := Temp;
end;

class function TUInt8Helper.TryParseWithLocalSeparators(const s: string; out Value: UInt8): Boolean;
var
  Temp: UInt64;
begin
  Result := Numbers.TryParseWithLocalSeparators(s, Temp) and (Temp <= MaxValue);
  if Result then Value := Temp;
end;

class function TUInt8Helper.TryParseWithSeparators(const s: string; out Value: UInt8; Sep: char): Boolean;
var
  Temp: UInt64;
begin
  Result := Numbers.TryParseWithSeparators(s, Temp, Sep) and (Temp <= MaxValue);
  if Result then Value := Temp;
end;

function TUInt8Helper.ToString: string;
begin
  Result := IntToStr(Self);
end;

function TUInt8Helper.ToHexString: string;
begin
  Result := IntToHex(Self);
end;

function TUInt8Helper.ToHexString(const MinDigits: Integer): string;
begin
  Result := IntToHex(Self, MinDigits);
end;

function TUInt8Helper.ToStringWithSeparators(Separator: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, Separator);
end;

function TUInt8Helper.ToCommaString: string;
begin
  Result := Numbers.ToCommaString(Self);
end;

function TUInt8Helper.ToLocaleString: string;
begin
  Result := Numbers.ToLocaleString(Self);
end;

function TUInt8Helper.ToPaddedString(MinWidth: NInt; Pad, Sep: Char): string;
begin
  Result := Numbers.ToPaddedString(Self, MinWidth, Pad, Sep);
end;

function TUInt8Helper.ToBoolean: Boolean;
begin
  Result := Self <> 0;
end;

function TUInt8Helper.ToSingle: Single;
begin
  Result := Self;
end;

function TUInt8Helper.ToDouble: Double;
begin
  Result := Self;
end;

function TUInt8Helper.ToExtended: Extended;
begin
  Result := Self;
end;


function TUInt8Helper.Sign: NInt;
begin
  if Self > 0
    then Result := 1
    else Result := 0;
end;

function TUInt8Helper.Abs: UInt8;
begin
  Result := Self;
end;

function TUInt8Helper.EnsureRange(const Min, Max: UInt8): UInt8;
begin
  if Self > Max then Exit(Max)
  else if Self < Min then Exit(Min)
  else Exit(Self);
end;

function TUInt8Helper.InRange(const Min, Max: UInt8): Bool;
begin
  Result := (Self >= Min) and (Self <= Max);
end;

function TUInt8Helper.Max(const a: UInt8): UInt8;
begin
  if Self >= a
    then Result := Self
    else Result := a;
end;

function TUInt8Helper.Max(const a, b: UInt8): UInt8;
begin
  Result := ez.Max(Self, a, b);
end;

function TUInt8Helper.Min(const a: UInt8): UInt8;
begin
  if Self <= a
    then Result := Self
    else Result := a;
end;

function TUInt8Helper.Min(const a, b: UInt8): UInt8;
begin
  Result := ez.Min(Self, a, b);
end;

function TUInt8Helper.NearestMultiple(n: UInt8): UInt8;
begin
  Result := (Self + n shr 1) div n * n;
end;


procedure TUInt8Helper.SetToLarger(const a: UInt8);
begin
  if Self < a then Self := a;
end;

procedure TUInt8Helper.SetToLarger(const a, b: UInt8);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
end;

procedure TUInt8Helper.SetToLarger(const a, b, c: UInt8);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
  if Self < c then Self := c;
end;

procedure TUInt8Helper.SetToSmaller(const a: UInt8);
begin
  if Self > a then Self := a;
end;

procedure TUInt8Helper.SetToSmaller(const a, b: UInt8);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
end;

procedure TUInt8Helper.SetToSmaller(const a, b, c: UInt8);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
  if Self > c then Self := c;
end;

procedure TUInt8Helper.SetToRange(const Min, Max: UInt8);
begin
  if Self > Max then Self := Max
  else if Self < Min then Self := Min;
end;

procedure TUInt8Helper.SwapWith(var a: UInt8);
begin
  var Temp := a;
  a := Self;
  Self := Temp;
end;
{$ENDREGION}

{$REGION 'TInt16Helper'}
{ TInt16Helper }

class function TInt16Helper.ToString(const Value: Int16): string;
begin
  Result := IntToStr(Value);
end;

class function TInt16Helper.Parse(const S: string): Int16;
begin
  if not TryParse(S, Result) then
    Exception.RaiseConvertIntError(s, 'Int16');
end;

class function TInt16Helper.Parse(const S: string; const Default: Int16): Int16;
begin
  if not TryParse(S, Result) then
    Result := Default;
end;

class function TInt16Helper.TryParse(const S: string; out Value: Int16): Boolean;
var
  E: Integer;
begin
  if S.Startswith(Numbers.HexPrefixC)
    then Val(Numbers.HexPrefixPas + S.Substring(2), Value, E)
    else Val(S, Value, E);
  Result := E = 0;
end;

class function TInt16Helper.TryParseWithComma(const s: string; out Value: Int16): Boolean;
var
  Temp: Int64;
begin
  Result := Numbers.TryParseWithComma(s, Temp) and (Temp <= MaxValue) and (Temp >= MinValue);
  if Result then Value := Temp;
end;

class function TInt16Helper.TryParseWithLocalSeparators(const s: string; out Value: Int16): Boolean;
var
  Temp: Int64;
begin
  Result := Numbers.TryParseWithLocalSeparators(s, Temp) and (Temp <= MaxValue) and (Temp >= MinValue);
  if Result then Value := Temp;
end;

class function TInt16Helper.TryParseWithSeparators(const s: string; out Value: Int16; Sep: char): Boolean;
var
  Temp: Int64;
begin
  Result := Numbers.TryParseWithSeparators(s, Temp, Sep) and (Temp <= MaxValue) and (Temp >= MinValue);
  if Result then Value := Temp;
end;

function TInt16Helper.ToString: string;
begin
  Result := IntToStr(Self);
end;

function TInt16Helper.ToHexString: string;
begin
  Result := IntToHex(Self);
end;

function TInt16Helper.ToHexString(const MinDigits: Integer): string;
begin
  Result := IntToHex(Self, MinDigits);
end;

function TInt16Helper.ToStringWithSeparators(Separator: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, Separator);
end;

function TInt16Helper.ToCommaString: string;
begin
  Result := Numbers.ToCommaString(Self);
end;

function TInt16Helper.ToLocaleString: string;
begin
  Result := Numbers.ToLocaleString(Self);
end;

function TInt16Helper.ToPaddedString(MinWidth: NInt; Pad, Sep: Char): string;
begin
  Result := Numbers.ToPaddedString(Self, MinWidth, Pad, Sep);
end;

function TInt16Helper.ToBoolean: Boolean;
begin
  Result := Self <> 0;
end;

function TInt16Helper.ToSingle: Single;
begin
  Result := Self;
end;

function TInt16Helper.ToDouble: Double;
begin
  Result := Self;
end;

function TInt16Helper.ToExtended: Extended;
begin
  Result := Self;
end;


function TInt16Helper.Sign: NInt;
begin
  if Self > 0
    then Result := 1
    else if Self < 0
      then Result := -1
      else Result := 0;
end;

function TInt16Helper.Abs: Int16;
begin
  if Self < 0
    then Result := -Self
    else Result := Self;
end;

function TInt16Helper.EnsureRange(const Min, Max: Int16): Int16;
begin
  if Self > Max then Exit(Max)
  else if Self < Min then Exit(Min)
  else Exit(Self);
end;

function TInt16Helper.InRange(const Min, Max: Int16): Bool;
begin
  Result := (Self >= Min) and (Self <= Max);
end;

function TInt16Helper.Max(const a: Int16): Int16;
begin
  if Self >= a
    then Result := Self
    else Result := a;
end;

function TInt16Helper.Max(const a, b: Int16): Int16;
begin
  Result := ez.Max(Self, a, b);
end;

function TInt16Helper.Min(const a: Int16): Int16;
begin
  if Self <= a
    then Result := Self
    else Result := a;
end;

function TInt16Helper.Min(const a, b: Int16): Int16;
begin
  Result := ez.Min(Self, a, b);
end;

function TInt16Helper.NearestMultiple(n: Int16): Int16;
begin
  Result := (Self + n shr 1) div n * n;
end;

function TInt16Helper.GetBytes(i: NUInt): UInt8;
begin
  if i >= Size then System.Error(reRangeError);
  Result := PInt8Array(@Self)^[i];
end;

procedure TInt16Helper.SetBytes(i: NUInt; Value: UInt8);
begin
  if i >= Size then System.Error(reRangeError);
  PInt8Array(@Self)^[i] := Value;
end;


procedure TInt16Helper.SetToLarger(const a: Int16);
begin
  if Self < a then Self := a;
end;

procedure TInt16Helper.SetToLarger(const a, b: Int16);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
end;

procedure TInt16Helper.SetToLarger(const a, b, c: Int16);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
  if Self < c then Self := c;
end;

procedure TInt16Helper.SetToSmaller(const a: Int16);
begin
  if Self > a then Self := a;
end;

procedure TInt16Helper.SetToSmaller(const a, b: Int16);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
end;

procedure TInt16Helper.SetToSmaller(const a, b, c: Int16);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
  if Self > c then Self := c;
end;

procedure TInt16Helper.SetToRange(const Min, Max: Int16);
begin
  if Self > Max then Self := Max
  else if Self < Min then Self := Min;
end;

procedure TInt16Helper.SwapWith(var a: Int16);
begin
  var Temp := a;
  a := Self;
  Self := Temp;
end;
{$ENDREGION}

{$REGION 'TUInt16Helper'}
{ TUInt16Helper }

class function TUInt16Helper.ToString(const Value: UInt16): string;
begin
  Result := IntToStr(Value);
end;

class function TUInt16Helper.Parse(const S: string): UInt16;
begin
  if not TryParse(S, Result) then
    Exception.RaiseConvertIntError(s, 'UInt16');
end;

class function TUInt16Helper.Parse(const S: string; const Default: UInt16): UInt16;
begin
  if not TryParse(S, Result) then
    Result := Default;
end;

class function TUInt16Helper.TryParse(const S: string; out Value: UInt16): Boolean;
var
  E: Integer;
begin
  if S.Startswith(Numbers.HexPrefixC)
    then Val(Numbers.HexPrefixPas + S.Substring(2), Value, E)
    else Val(S, Value, E);
  Result := E = 0;
end;

class function TUInt16Helper.TryParseWithComma(const s: string; out Value: UInt16): Boolean;
var
  Temp: UInt64;
begin
  Result := Numbers.TryParseWithComma(s, Temp) and (Temp <= MaxValue);
  if Result then Value := Temp;
end;

class function TUInt16Helper.TryParseWithLocalSeparators(const s: string; out Value: UInt16): Boolean;
var
  Temp: UInt64;
begin
  Result := Numbers.TryParseWithLocalSeparators(s, Temp) and (Temp <= MaxValue);
  if Result then Value := Temp;
end;

class function TUInt16Helper.TryParseWithSeparators(const s: string; out Value: UInt16; Sep: char): Boolean;
var
  Temp: UInt64;
begin
  Result := Numbers.TryParseWithSeparators(s, Temp, Sep) and (Temp <= MaxValue);
  if Result then Value := Temp;
end;

function TUInt16Helper.ToString: string;
begin
  Result := IntToStr(Self);
end;

function TUInt16Helper.ToHexString: string;
begin
  Result := IntToHex(Self);
end;

function TUInt16Helper.ToHexString(const MinDigits: Integer): string;
begin
  Result := IntToHex(Self, MinDigits);
end;

function TUInt16Helper.ToStringWithSeparators(Separator: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, Separator);
end;

function TUInt16Helper.ToCommaString: string;
begin
  Result := Numbers.ToCommaString(Self);
end;

function TUInt16Helper.ToLocaleString: string;
begin
  Result := Numbers.ToLocaleString(Self);
end;

function TUInt16Helper.ToPaddedString(MinWidth: NInt; Pad, Sep: Char): string;
begin
  Result := Numbers.ToPaddedString(Self, MinWidth, Pad, Sep);
end;

function TUInt16Helper.ToBoolean: Boolean;
begin
  Result := Self <> 0;
end;

function TUInt16Helper.ToSingle: Single;
begin
  Result := Self;
end;

function TUInt16Helper.ToDouble: Double;
begin
  Result := Self;
end;

function TUInt16Helper.ToExtended: Extended;
begin
  Result := Self;
end;


function TUInt16Helper.Sign: NInt;
begin
  if Self > 0
    then Result := 1
    else Result := 0;
end;

function TUInt16Helper.Abs: UInt16;
begin
  Result := Self;
end;

function TUInt16Helper.EnsureRange(const Min, Max: UInt16): UInt16;
begin
  if Self > Max then Exit(Max)
  else if Self < Min then Exit(Min)
  else Exit(Self);
end;

function TUInt16Helper.InRange(const Min, Max: UInt16): Bool;
begin
  Result := (Self >= Min) and (Self <= Max);
end;

function TUInt16Helper.Max(const a: UInt16): UInt16;
begin
  if Self >= a
    then Result := Self
    else Result := a;
end;

function TUInt16Helper.Max(const a, b: UInt16): UInt16;
begin
  Result := ez.Max(Self, a, b);
end;

function TUInt16Helper.Min(const a: UInt16): UInt16;
begin
  if Self <= a
    then Result := Self
    else Result := a;
end;

function TUInt16Helper.Min(const a, b: UInt16): UInt16;
begin
  Result := ez.Min(Self, a, b);
end;

function TUInt16Helper.NearestMultiple(n: UInt16): UInt16;
begin
  Result := (Self + n shr 1) div n * n;
end;

function TUInt16Helper.GetBytes(i: NUInt): UInt8;
begin
  if i >= Size then System.Error(reRangeError);
  Result := PInt8Array(@Self)^[i];
end;

procedure TUInt16Helper.SetBytes(i: NUInt; Value: UInt8);
begin
  if i >= Size then System.Error(reRangeError);
  PInt8Array(@Self)^[i] := Value;
end;


procedure TUInt16Helper.SetToLarger(const a: UInt16);
begin
  if Self < a then Self := a;
end;

procedure TUInt16Helper.SetToLarger(const a, b: UInt16);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
end;

procedure TUInt16Helper.SetToLarger(const a, b, c: UInt16);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
  if Self < c then Self := c;
end;

procedure TUInt16Helper.SetToSmaller(const a: UInt16);
begin
  if Self > a then Self := a;
end;

procedure TUInt16Helper.SetToSmaller(const a, b: UInt16);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
end;

procedure TUInt16Helper.SetToSmaller(const a, b, c: UInt16);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
  if Self > c then Self := c;
end;

procedure TUInt16Helper.SetToRange(const Min, Max: UInt16);
begin
  if Self > Max then Self := Max
  else if Self < Min then Self := Min;
end;

procedure TUInt16Helper.SwapWith(var a: UInt16);
begin
  var Temp := a;
  a := Self;
  Self := Temp;
end;
{$ENDREGION}

{$REGION 'TInt32Helper'}
{ TInt32Helper }

class function TInt32Helper.ToString(const Value: Int32): string;
begin
  Result := IntToStr(Value);
end;

class function TInt32Helper.Parse(const S: string): Int32;
begin
  if not TryParse(S, Result) then
    Exception.RaiseConvertIntError(s, 'Int32');
end;

class function TInt32Helper.Parse(const S: string; const Default: Int32): Int32;
begin
  if not TryParse(S, Result) then
    Result := Default;
end;

class function TInt32Helper.TryParse(const S: string; out Value: Int32): Boolean;
var
  E: Integer;
begin
  if S.Startswith(Numbers.HexPrefixC)
    then Val(Numbers.HexPrefixPas + S.Substring(2), Value, E)
    else Val(S, Value, E);
  Result := E = 0;
end;

class function TInt32Helper.TryParseWithComma(const s: string; out Value: Int32): Boolean;
var
  Temp: Int64;
begin
  Result := Numbers.TryParseWithComma(s, Temp) and (Temp <= MaxValue) and (Temp >= MinValue);
  if Result then Value := Temp;
end;

class function TInt32Helper.TryParseWithLocalSeparators(const s: string; out Value: Int32): Boolean;
var
  Temp: Int64;
begin
  Result := Numbers.TryParseWithLocalSeparators(s, Temp) and (Temp <= MaxValue) and (Temp >= MinValue);
  if Result then Value := Temp;
end;

class function TInt32Helper.TryParseWithSeparators(const s: string; out Value: Int32; Sep: char): Boolean;
var
  Temp: Int64;
begin
  Result := Numbers.TryParseWithSeparators(s, Temp, Sep) and (Temp <= MaxValue) and (Temp >= MinValue);
  if Result then Value := Temp;
end;

function TInt32Helper.ToString: string;
begin
  Result := IntToStr(Self);
end;

function TInt32Helper.ToHexString: string;
begin
  Result := IntToHex(Self);
end;

function TInt32Helper.ToHexString(const MinDigits: Integer): string;
begin
  Result := IntToHex(Self, MinDigits);
end;

function TInt32Helper.ToStringWithSeparators(Separator: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, Separator);
end;

function TInt32Helper.ToCommaString: string;
begin
  Result := Numbers.ToCommaString(Self);
end;

function TInt32Helper.ToLocaleString: string;
begin
  Result := Numbers.ToLocaleString(Self);
end;

function TInt32Helper.ToPaddedString(MinWidth: NInt; Pad, Sep: Char): string;
begin
  Result := Numbers.ToPaddedString(Self, MinWidth, Pad, Sep);
end;

function TInt32Helper.ToBoolean: Boolean;
begin
  Result := Self <> 0;
end;

function TInt32Helper.ToSingle: Single;
begin
  Result := Self;
end;

function TInt32Helper.ToDouble: Double;
begin
  Result := Self;
end;

function TInt32Helper.ToExtended: Extended;
begin
  Result := Self;
end;


function TInt32Helper.Sign: NInt;
begin
  if Self > 0
    then Result := 1
    else if Self < 0
      then Result := -1
      else Result := 0;
end;

function TInt32Helper.Abs: Int32;
begin
  if Self < 0
    then Result := -Self
    else Result := Self;
end;

function TInt32Helper.EnsureRange(const Min, Max: Int32): Int32;
begin
  if Self > Max then Exit(Max)
  else if Self < Min then Exit(Min)
  else Exit(Self);
end;

function TInt32Helper.InRange(const Min, Max: Int32): Bool;
begin
  Result := (Self >= Min) and (Self <= Max);
end;

function TInt32Helper.Max(const a: Int32): Int32;
begin
  if Self >= a
    then Result := Self
    else Result := a;
end;

function TInt32Helper.Max(const a, b: Int32): Int32;
begin
  Result := ez.Max(Self, a, b);
end;

function TInt32Helper.Min(const a: Int32): Int32;
begin
  if Self <= a
    then Result := Self
    else Result := a;
end;

function TInt32Helper.Min(const a, b: Int32): Int32;
begin
  Result := ez.Min(Self, a, b);
end;

function TInt32Helper.NearestMultiple(n: Int32): Int32;
begin
  Result := (Self + n shr 1) div n * n;
end;

function TInt32Helper.GetBytes(i: NUInt): UInt8;
begin
  if i >= Size then System.Error(reRangeError);
  Result := PInt8Array(@Self)^[i];
end;

function TInt32Helper.GetWords(i: NUInt): UInt16;
begin
  if i >= Size div 2 then System.Error(reRangeError);
  Result := PInt16Array(@Self)^[i];
end;

procedure TInt32Helper.SetBytes(i: NUInt; Value: UInt8);
begin
  if i >= Size then System.Error(reRangeError);
  PInt8Array(@Self)^[i] := Value;
end;

procedure TInt32Helper.SetWords(i: NUInt; Value: UInt16);
begin
  if i >= Size div 2 then System.Error(reRangeError);
  PInt16Array(@Self)^[i] := Value;
end;


procedure TInt32Helper.SetToLarger(const a: Int32);
begin
  if Self < a then Self := a;
end;

procedure TInt32Helper.SetToLarger(const a, b: Int32);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
end;

procedure TInt32Helper.SetToLarger(const a, b, c: Int32);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
  if Self < c then Self := c;
end;

procedure TInt32Helper.SetToSmaller(const a: Int32);
begin
  if Self > a then Self := a;
end;

procedure TInt32Helper.SetToSmaller(const a, b: Int32);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
end;

procedure TInt32Helper.SetToSmaller(const a, b, c: Int32);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
  if Self > c then Self := c;
end;

procedure TInt32Helper.SetToRange(const Min, Max: Int32);
begin
  if Self > Max then Self := Max
  else if Self < Min then Self := Min;
end;

procedure TInt32Helper.SwapWith(var a: Int32);
begin
  var Temp := a;
  a := Self;
  Self := Temp;
end;
{$ENDREGION}

{$REGION 'TUInt32Helper'}
{ TUInt32Helper }

class function TUInt32Helper.ToString(const Value: UInt32): string;
begin
  Result := IntToStr(Value);
end;

class function TUInt32Helper.Parse(const S: string): UInt32;
begin
  if not TryParse(S, Result) then
    Exception.RaiseConvertIntError(s, 'UInt32');
end;

class function TUInt32Helper.Parse(const S: string; const Default: UInt32): UInt32;
begin
  if not TryParse(S, Result) then
    Result := Default;
end;

class function TUInt32Helper.TryParse(const S: string; out Value: UInt32): Boolean;
var
  E: Integer;
begin
  if S.Startswith(Numbers.HexPrefixC)
    then Val(Numbers.HexPrefixPas + S.Substring(2), Value, E)
    else Val(S, Value, E);
  Result := E = 0;
end;

class function TUInt32Helper.TryParseWithComma(const s: string; out Value: UInt32): Boolean;
var
  Temp: UInt64;
begin
  Result := Numbers.TryParseWithComma(s, Temp) and (Temp <= MaxValue);
  if Result then Value := Temp;
end;

class function TUInt32Helper.TryParseWithLocalSeparators(const s: string; out Value: UInt32): Boolean;
var
  Temp: UInt64;
begin
  Result := Numbers.TryParseWithLocalSeparators(s, Temp) and (Temp <= MaxValue);
  if Result then Value := Temp;
end;

class function TUInt32Helper.TryParseWithSeparators(const s: string; out Value: UInt32; Sep: char): Boolean;
var
  Temp: UInt64;
begin
  Result := Numbers.TryParseWithSeparators(s, Temp, Sep) and (Temp <= MaxValue);
  if Result then Value := Temp;
end;

function TUInt32Helper.ToString: string;
begin
  Result := IntToStr(Self);
end;

function TUInt32Helper.ToHexString: string;
begin
  Result := IntToHex(Self);
end;

function TUInt32Helper.ToHexString(const MinDigits: Integer): string;
begin
  Result := IntToHex(Self, MinDigits);
end;

function TUInt32Helper.ToStringWithSeparators(Separator: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, Separator);
end;

function TUInt32Helper.ToCommaString: string;
begin
  Result := Numbers.ToCommaString(Self);
end;

function TUInt32Helper.ToLocaleString: string;
begin
  Result := Numbers.ToLocaleString(Self);
end;

function TUInt32Helper.ToPaddedString(MinWidth: NInt; Pad, Sep: Char): string;
begin
  Result := Numbers.ToPaddedString(Self, MinWidth, Pad, Sep);
end;

function TUInt32Helper.ToBoolean: Boolean;
begin
  Result := Self <> 0;
end;

function TUInt32Helper.ToSingle: Single;
begin
  Result := Self;
end;

function TUInt32Helper.ToDouble: Double;
begin
  Result := Self;
end;

function TUInt32Helper.ToExtended: Extended;
begin
  Result := Self;
end;


function TUInt32Helper.Sign: NInt;
begin
  if Self > 0
    then Result := 1
    else Result := 0;
end;

function TUInt32Helper.Abs: UInt32;
begin
  Result := Self;
end;

function TUInt32Helper.EnsureRange(const Min, Max: UInt32): UInt32;
begin
  if Self > Max then Exit(Max)
  else if Self < Min then Exit(Min)
  else Exit(Self);
end;

function TUInt32Helper.InRange(const Min, Max: UInt32): Bool;
begin
  Result := (Self >= Min) and (Self <= Max);
end;

function TUInt32Helper.Max(const a: UInt32): UInt32;
begin
  if Self >= a
    then Result := Self
    else Result := a;
end;

function TUInt32Helper.Max(const a, b: UInt32): UInt32;
begin
  Result := ez.Max(Self, a, b);
end;

function TUInt32Helper.Min(const a: UInt32): UInt32;
begin
  if Self <= a
    then Result := Self
    else Result := a;
end;

function TUInt32Helper.Min(const a, b: UInt32): UInt32;
begin
  Result := ez.Min(Self, a, b);
end;

function TUInt32Helper.NearestMultiple(n: UInt32): UInt32;
begin
  Result := (Self + n shr 1) div n * n;
end;

function TUInt32Helper.GetBytes(i: NUInt): UInt8;
begin
  if i >= Size then System.Error(reRangeError);
  Result := PInt8Array(@Self)^[i];
end;

function TUInt32Helper.GetWords(i: NUInt): UInt16;
begin
  if i >= Size div 2 then System.Error(reRangeError);
  Result := PInt16Array(@Self)^[i];
end;

procedure TUInt32Helper.SetBytes(i: NUInt; Value: UInt8);
begin
  if i >= Size then System.Error(reRangeError);
  PInt8Array(@Self)^[i] := Value;
end;

procedure TUInt32Helper.SetWords(i: NUInt; Value: UInt16);
begin
  if i >= Size div 2 then System.Error(reRangeError);
  PInt16Array(@Self)^[i] := Value;
end;


procedure TUInt32Helper.SetToLarger(const a: UInt32);
begin
  if Self < a then Self := a;
end;

procedure TUInt32Helper.SetToLarger(const a, b: UInt32);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
end;

procedure TUInt32Helper.SetToLarger(const a, b, c: UInt32);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
  if Self < c then Self := c;
end;

procedure TUInt32Helper.SetToSmaller(const a: UInt32);
begin
  if Self > a then Self := a;
end;

procedure TUInt32Helper.SetToSmaller(const a, b: UInt32);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
end;

procedure TUInt32Helper.SetToSmaller(const a, b, c: UInt32);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
  if Self > c then Self := c;
end;

procedure TUInt32Helper.SetToRange(const Min, Max: UInt32);
begin
  if Self > Max then Self := Max
  else if Self < Min then Self := Min;
end;

procedure TUInt32Helper.SwapWith(var a: UInt32);
begin
  var Temp := a;
  a := Self;
  Self := Temp;
end;
{$ENDREGION}

{$REGION 'TInt64Helper'}
{ TInt64Helper }

class function TInt64Helper.ToString(const Value: Int64): string;
begin
  Result := IntToStr(Value);
end;

class function TInt64Helper.Parse(const S: string): Int64;
begin
  if not TryParse(S, Result) then
    Exception.RaiseConvertIntError(s, 'Int64');
end;

class function TInt64Helper.Parse(const S: string; const Default: Int64): Int64;
begin
  if not TryParse(S, Result) then
    Result := Default;
end;

class function TInt64Helper.TryParse(const S: string; out Value: Int64): Boolean;
var
  E: Integer;
begin
  if S.Startswith(Numbers.HexPrefixC)
    then Val(Numbers.HexPrefixPas + S.Substring(2), Value, E)
    else Val(S, Value, E);
  Result := E = 0;
end;

class function TInt64Helper.TryParseWithComma(const s: string; out Value: Int64): Boolean;
begin
  Result := Numbers.TryParseWithComma(s, Value);
end;

class function TInt64Helper.TryParseWithLocalSeparators(const s: string; out Value: Int64): Boolean;
begin
  Result := Numbers.TryParseWithLocalSeparators(s, Value);
end;

class function TInt64Helper.TryParseWithSeparators(const s: string; out Value: Int64; Sep: char): Boolean;
begin
  Result := Numbers.TryParseWithSeparators(s, Value, Sep);
end;

function TInt64Helper.ToString: string;
begin
  Result := IntToStr(Self);
end;

function TInt64Helper.ToHexString: string;
begin
  Result := IntToHex(Self);
end;

function TInt64Helper.ToHexString(const MinDigits: Integer): string;
begin
  Result := IntToHex(Self, MinDigits);
end;

function TInt64Helper.ToStringWithSeparators(Separator: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, Separator);
end;

function TInt64Helper.ToCommaString: string;
begin
  Result := Numbers.ToCommaString(Self);
end;

function TInt64Helper.ToLocaleString: string;
begin
  Result := Numbers.ToLocaleString(Self);
end;

function TInt64Helper.ToPaddedString(MinWidth: NInt; Pad, Sep: Char): string;
begin
  Result := Numbers.ToPaddedString(Self, MinWidth, Pad, Sep);
end;

function TInt64Helper.ToBoolean: Boolean;
begin
  Result := Self <> 0;
end;

function TInt64Helper.ToSingle: Single;
begin
  Result := Self;
end;

function TInt64Helper.ToDouble: Double;
begin
  Result := Self;
end;

function TInt64Helper.ToExtended: Extended;
begin
  Result := Self;
end;


function TInt64Helper.Sign: NInt;
begin
  if Self > 0
    then Result := 1
    else if Self < 0
      then Result := -1
      else Result := 0;
end;

function TInt64Helper.Abs: Int64;
begin
  if Self < 0
    then Result := -Self
    else Result := Self;
end;

function TInt64Helper.EnsureRange(const Min, Max: Int64): Int64;
begin
  if Self > Max then Exit(Max)
  else if Self < Min then Exit(Min)
  else Exit(Self);
end;

function TInt64Helper.InRange(const Min, Max: Int64): Bool;
begin
  Result := (Self >= Min) and (Self <= Max);
end;

function TInt64Helper.Max(const a: Int64): Int64;
begin
  if Self >= a
    then Result := Self
    else Result := a;
end;

function TInt64Helper.Max(const a, b: Int64): Int64;
begin
  Result := ez.Max(Self, a, b);
end;

function TInt64Helper.Min(const a: Int64): Int64;
begin
  if Self <= a
    then Result := Self
    else Result := a;
end;

function TInt64Helper.Min(const a, b: Int64): Int64;
begin
  Result := ez.Min(Self, a, b);
end;

function TInt64Helper.NearestMultiple(n: Int64): Int64;
begin
  Result := (Self + n shr 1) div n * n;
end;

function TInt64Helper.GetBytes(i: NUInt): UInt8;
begin
  if i >= Size then System.Error(reRangeError);
  Result := PInt8Array(@Self)^[i];
end;

function TInt64Helper.GetWords(i: NUInt): UInt16;
begin
  if i >= Size div 2 then System.Error(reRangeError);
  Result := PInt16Array(@Self)^[i];
end;

function TInt64Helper.GetLongs(i: NUInt): UInt32;
begin
  if i >= Size div 4 then System.Error(reRangeError);
  Result := PInt32Array(@Self)^[i];
end;

procedure TInt64Helper.SetBytes(i: NUInt; Value: UInt8);
begin
  if i >= Size then System.Error(reRangeError);
  PInt8Array(@Self)^[i] := Value;
end;

procedure TInt64Helper.SetWords(i: NUInt; Value: UInt16);
begin
  if i >= Size div 2 then System.Error(reRangeError);
  PInt16Array(@Self)^[i] := Value;
end;

procedure TInt64Helper.SetLongs(i: NUInt; Value: UInt32);
begin
  if i >= Size div 4 then System.Error(reRangeError);
  PInt32Array(@Self)^[i] := Value;
end;


procedure TInt64Helper.SetToLarger(const a: Int64);
begin
  if Self < a then Self := a;
end;

procedure TInt64Helper.SetToLarger(const a, b: Int64);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
end;

procedure TInt64Helper.SetToLarger(const a, b, c: Int64);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
  if Self < c then Self := c;
end;

procedure TInt64Helper.SetToSmaller(const a: Int64);
begin
  if Self > a then Self := a;
end;

procedure TInt64Helper.SetToSmaller(const a, b: Int64);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
end;

procedure TInt64Helper.SetToSmaller(const a, b, c: Int64);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
  if Self > c then Self := c;
end;

procedure TInt64Helper.SetToRange(const Min, Max: Int64);
begin
  if Self > Max then Self := Max
  else if Self < Min then Self := Min;
end;

procedure TInt64Helper.SwapWith(var a: Int64);
begin
  var Temp := a;
  a := Self;
  Self := Temp;
end;
{$ENDREGION}

{$REGION 'TUInt64Helper'}
{ TUInt64Helper }

class function TUInt64Helper.ToString(const Value: UInt64): string;
begin
  Result := IntToStr(Value);
end;

class function TUInt64Helper.Parse(const S: string): UInt64;
begin
  if not TryParse(S, Result) then
    Exception.RaiseConvertIntError(s, 'UInt64');
end;

class function TUInt64Helper.Parse(const S: string; const Default: UInt64): UInt64;
begin
  if not TryParse(S, Result) then
    Result := Default;
end;

class function TUInt64Helper.TryParse(const S: string; out Value: UInt64): Boolean;
var
  E: Integer;
begin
  if S.Startswith(Numbers.HexPrefixC)
    then Val(Numbers.HexPrefixPas + S.Substring(2), Value, E)
    else Val(S, Value, E);
  Result := E = 0;
end;

class function TUInt64Helper.TryParseWithComma(const s: string; out Value: UInt64): Boolean;
begin
  Result := Numbers.TryParseWithComma(s, Value);
end;

class function TUInt64Helper.TryParseWithLocalSeparators(const s: string; out Value: UInt64): Boolean;
begin
  Result := Numbers.TryParseWithLocalSeparators(s, Value);
end;

class function TUInt64Helper.TryParseWithSeparators(const s: string; out Value: UInt64; Sep: char): Boolean;
begin
  Result := Numbers.TryParseWithSeparators(s, Value, Sep);
end;

function TUInt64Helper.ToString: string;
begin
  Result := IntToStr(Self);
end;

function TUInt64Helper.ToHexString: string;
begin
  Result := IntToHex(Self);
end;

function TUInt64Helper.ToHexString(const MinDigits: Integer): string;
begin
  Result := IntToHex(Self, MinDigits);
end;

function TUInt64Helper.ToStringWithSeparators(Separator: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, Separator);
end;

function TUInt64Helper.ToCommaString: string;
begin
  Result := Numbers.ToCommaString(Self);
end;

function TUInt64Helper.ToLocaleString: string;
begin
  Result := Numbers.ToLocaleString(Self);
end;

function TUInt64Helper.ToPaddedString(MinWidth: NInt; Pad, Sep: Char): string;
begin
  Result := Numbers.ToPaddedString(Self, MinWidth, Pad, Sep);
end;

function TUInt64Helper.ToBoolean: Boolean;
begin
  Result := Self <> 0;
end;

function TUInt64Helper.ToSingle: Single;
begin
  Result := Self;
end;

function TUInt64Helper.ToDouble: Double;
begin
  Result := Self;
end;

function TUInt64Helper.ToExtended: Extended;
begin
  Result := Self;
end;


function TUInt64Helper.Sign: NInt;
begin
  if Self > 0
    then Result := 1
    else Result := 0;
end;

function TUInt64Helper.Abs: UInt64;
begin
  Result := Self;
end;

function TUInt64Helper.EnsureRange(const Min, Max: UInt64): UInt64;
begin
  if Self > Max then Exit(Max)
  else if Self < Min then Exit(Min)
  else Exit(Self);
end;

function TUInt64Helper.InRange(const Min, Max: UInt64): Bool;
begin
  Result := (Self >= Min) and (Self <= Max);
end;

function TUInt64Helper.Max(const a: UInt64): UInt64;
begin
  if Self >= a
    then Result := Self
    else Result := a;
end;

function TUInt64Helper.Max(const a, b: UInt64): UInt64;
begin
  Result := ez.Max(Self, a, b);
end;

function TUInt64Helper.Min(const a: UInt64): UInt64;
begin
  if Self <= a
    then Result := Self
    else Result := a;
end;

function TUInt64Helper.Min(const a, b: UInt64): UInt64;
begin
  Result := ez.Min(Self, a, b);
end;

function TUInt64Helper.NearestMultiple(n: UInt64): UInt64;
begin
  Result := (Self + n shr 1) div n * n;
end;

function TUInt64Helper.GetBytes(i: NUInt): UInt8;
begin
  if i >= Size then System.Error(reRangeError);
  Result := PInt8Array(@Self)^[i];
end;

function TUInt64Helper.GetWords(i: NUInt): UInt16;
begin
  if i >= Size div 2 then System.Error(reRangeError);
  Result := PInt16Array(@Self)^[i];
end;

function TUInt64Helper.GetLongs(i: NUInt): UInt32;
begin
  if i >= Size div 4 then System.Error(reRangeError);
  Result := PInt32Array(@Self)^[i];
end;

procedure TUInt64Helper.SetBytes(i: NUInt; Value: UInt8);
begin
  if i >= Size then System.Error(reRangeError);
  PInt8Array(@Self)^[i] := Value;
end;

procedure TUInt64Helper.SetWords(i: NUInt; Value: UInt16);
begin
  if i >= Size div 2 then System.Error(reRangeError);
  PInt16Array(@Self)^[i] := Value;
end;

procedure TUInt64Helper.SetLongs(i: NUInt; Value: UInt32);
begin
  if i >= Size div 4 then System.Error(reRangeError);
  PInt32Array(@Self)^[i] := Value;
end;


procedure TUInt64Helper.SetToLarger(const a: UInt64);
begin
  if Self < a then Self := a;
end;

procedure TUInt64Helper.SetToLarger(const a, b: UInt64);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
end;

procedure TUInt64Helper.SetToLarger(const a, b, c: UInt64);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
  if Self < c then Self := c;
end;

procedure TUInt64Helper.SetToSmaller(const a: UInt64);
begin
  if Self > a then Self := a;
end;

procedure TUInt64Helper.SetToSmaller(const a, b: UInt64);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
end;

procedure TUInt64Helper.SetToSmaller(const a, b, c: UInt64);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
  if Self > c then Self := c;
end;

procedure TUInt64Helper.SetToRange(const Min, Max: UInt64);
begin
  if Self > Max then Self := Max
  else if Self < Min then Self := Min;
end;

procedure TUInt64Helper.SwapWith(var a: UInt64);
begin
  var Temp := a;
  a := Self;
  Self := Temp;
end;
{$ENDREGION}


{$REGION 'TChar8Helper'}
{ TChar8Helper }

function TChar8Helper.IsControlA: Boolean;
begin
  Result := Self in ControlChars;           // Delphi genertes highly optimized code for set test
end;

function TChar8Helper.IsDigitA: Boolean;
begin
  Result := Self in NumbersChars;
end;

function TChar8Helper.IsDigitOrDotA: Boolean;
begin
  Result := Self in (NumbersChars + ['.']);
end;

function TChar8Helper.IsHexDigitA: Boolean;
begin
  Result := Self in HexNumChars;
end;

function TChar8Helper.IsLetterA: Boolean;
begin
  Result := Self in LetterChars;
end;

function TChar8Helper.IsLetterOrDigitA: Boolean;
begin
  Result := Self in AlphaNumChars;
end;

function TChar8Helper.IsLowerA: Boolean;
begin
  Result := Self in LowcaseChars;
end;

function TChar8Helper.IsUpperA: Boolean;
begin
  Result := Self in UpcaseChars;
end;

function TChar8Helper.IsSeparatorA: Boolean;
begin
  Result := Self in SeparatorChars;
end;

function TChar8Helper.IsWhiteSpaceA: Boolean;
begin
  Result := Self in WhitSpaceChars;
end;

function TChar8Helper.IsPunctuationA: Boolean;
begin
  Result := Self in PunctuationChars;
end;

function TChar8Helper.IsLineBreakA: Boolean;
begin
  Result := Self in LineBreakChars;
end;

function TChar8Helper.IsInSet(const ASet: TSysCharSet): Boolean;
begin
  Result := Self in ASet;
end;

function TChar8Helper.IsInArray(const AnArray: array of Char8): Boolean;
begin
  for var AChar in AnArray do
    if AChar = Self then Exit(True);
  Result := False;
end;

function TChar8Helper.InRange(const Min, Max: Char8): Bool;
begin
  Result := (Self >= Min) and (Self <= Max);
end;

function TChar8Helper.ToHexString: string;
begin
  Result := IntToHex(UInt8(Self), 1);
end;

function TChar8Helper.ToHexString(const MinDigits: Integer): string;
begin
  Result := IntToHex(UInt8(Self), MinDigits);
end;

function TChar8Helper.ToInteger: Integer;
begin
  Result := UInt8(Self);                        // As simple as this function, Delphi will not inline it
end;

function TChar8Helper.ToIntString: string;
begin
  Result := IntToStr(UInt8(Self));
end;

function TChar8Helper.ToLowerA: AnsiChar;
begin
  if Self in UpcaseChars
    then Result := AnsiChar(Ord(Self) + $20)
    else Result := Self;
end;

function TChar8Helper.ToUpperA: AnsiChar;
begin
  if Self in LowcaseChars
    then Result := AnsiChar(Ord(Self) - $20)
    else Result := Self;
end;

function TChar8Helper.ToChar16A: Char16;
begin
  Result := Char16(Self);
end;

function TChar8Helper.ToChar32A: Char32;
begin
  Result := Char32(Ord(Char16(Self)));
end;

procedure TChar8Helper.ChangeToLower;
begin
  if Self in UpcaseChars
    then Inc(Self, $20);
end;

procedure TChar8Helper.ChangeToUpper;
begin
  if Self in LowcaseChars
    then Dec(Self, $20);
end;

procedure TChar8Helper.SwapWith(var a: Char8);
begin
  var Temp := a;
  a := Self;
  Self := Temp;
end;
{$ENDREGION}

{$REGION 'TChar16Helper'}
{ TChar16Helper }

{$WARN SYMBOL_DEPRECATED OFF}

function TChar16Helper.GetNumericValue: Double;
begin
  Result := Character.GetNumericValue(Self);
end;

function TChar16Helper.GetUnicodeCategory: TUnicodeCategory;
begin
  Result := Character.GetUnicodeCategory(Self);
end;

function TChar16Helper.IsControl: Boolean;
begin
  Result := Character.IsControl(Self);
end;

function TChar16Helper.IsDefined: Boolean;
begin
  Result := Character.IsDefined(Self);
end;

function TChar16Helper.IsDigit: Boolean;
begin
  Result := Character.IsDigit(Self);
end;

function TChar16Helper.IsHighSurrogate: Boolean;
begin
  Result := Character.IsHighSurrogate(Self);
end;

function TChar16Helper.IsInArray(const SomeChars: array of Char): Boolean;
begin
  for var AChar in SomeChars do
    if AChar = Self then Exit(True);
  Result := False;
end;

function TChar16Helper.IsLetter: Boolean;
begin
  Result := Character.IsLetter(Self);
end;

function TChar16Helper.IsLetterOrDigit: Boolean;
begin
  Result := Character.IsLetterOrDigit(Self);
end;

function TChar16Helper.IsLower: Boolean;
begin
  Result := Character.IsLower(Self);
end;

function TChar16Helper.IsLowSurrogate: Boolean;
begin
  Result := Character.IsLowSurrogate(Self);
end;

function TChar16Helper.IsNumber: Boolean;
begin
  Result := Character.IsNumber(Self);
end;

function TChar16Helper.IsPunctuation: Boolean;
begin
  Result := Character.IsPunctuation(Self);
end;

function TChar16Helper.IsSeparator: Boolean;
begin
  Result := Character.IsSeparator(Self);
end;

function TChar16Helper.IsSurrogate: Boolean;
begin
  Result := Character.IsSurrogate(Self);
end;

function TChar16Helper.IsSymbol: Boolean;
begin
  Result := Character.IsSymbol(Self);
end;

function TChar16Helper.IsUpper: Boolean;
begin
  Result := Character.IsUpper(Self);
end;

function TChar16Helper.IsWhiteSpace: Boolean;
begin
  Result := Character.IsWhiteSpace(Self);
end;

function TChar16Helper.ToLower: Char;
begin
  Result := Character.ToLower(Self);
end;

function TChar16Helper.ToUpper: Char;
begin
  Result := Character.ToUpper(Self);
end;

function TChar16Helper.ToUCS4Char: UCS4Char;
begin
  Result := UCS4Char(Self);
end;
{$WARN SYMBOL_DEPRECATED ON}

function TChar16Helper.IsASCII: Boolean;
begin
  Result := Self < #$80;
end;

function TChar16Helper.IsControlA: Boolean;
begin
  Result := (Self < #$80) and Char8(Self).IsControlA;
end;

function TChar16Helper.IsDigitA: Boolean;
begin
  Result := (Self < #$80) and Char8(Self).IsDigitA;
end;

function TChar16Helper.IsDigitOrDotA: Boolean;
begin
  Result := (Self < #$80) and Char8(Self).IsDigitOrDotA;
end;

function TChar16Helper.IsHexDigitA: Boolean;
begin
  Result := (Self < #$80) and Char8(Self).IsHexDigitA;
end;

function TChar16Helper.IsLetterA: Boolean;
begin
  Result := (Self < #$80) and Char8(Self).IsLetterA;
end;

function TChar16Helper.IsLetterOrDigitA: Boolean;
begin
  Result := (Self < #$80) and Char8(Self).IsLetterOrDigitA;
end;

function TChar16Helper.IsLowerA: Boolean;
begin
  Result := (Self < #$80) and Char8(Self).IsLowerA;
end;

function TChar16Helper.IsUpperA: Boolean;
begin
  Result := (Self < #$80) and Char8(Self).IsUpperA;
end;

function TChar16Helper.IsSeparatorA: Boolean;
begin
  Result := (Self < #$80) and Char8(Self).IsSeparatorA;
end;

function TChar16Helper.IsPunctuationA: Boolean;
begin
  Result := (Self < #$80) and Char8(Self).IsPunctuationA;
end;

function TChar16Helper.IsWhiteSpaceA: Boolean;
begin
  Result := (Self < #$80) and Char8(Self).IsWhiteSpaceA;
end;

function TChar16Helper.IsLineBreakA: Boolean;
begin
  Result := (Self < #$80) and Char8(Self).IsLineBreakA;
end;

function TChar16Helper.IsInSet(const ASet: TSysCharSet): Boolean;
begin
  Result := (Self < #$80) and Char8(Self).IsInSet(ASet);
end;

function TChar16Helper.InRange(const Min, Max: Char16): Bool;
begin
  Result := (Self >= Min) and (Self <= Max);
end;

function TChar16Helper.IsChineseLetter: Boolean;
begin
  Result := (Self >= #$2E80) and (Self <= #$2FDF) or    // Radicals
            (Self >= #$3105) and (Self <= #$312D) or    // Bopomofo
            (Self >= #$4E00) and (Self <= #$9FFF) or
            (Self >= #$3400) and (Self <= #$4DBF) or
            (Self >= #$F900) and (Self <= #$FA6F);
end;

function TChar16Helper.IsCJK: Boolean;
begin
  Result := IsChineseLetter or
            (Self >= #$3041) and (Self <= #$30FF) or
            (Self >= #$3131) and (Self <= #$319F) or
            (Self >= #$AC00) and (Self <= #$D7FF);
end;

function TChar16Helper.IsPunctuationCJK: Boolean;
begin
  Result := (Self >= #$0021) and (Self <= #$0022) or
            (Self >= #$0027) and (Self <= #$0029) or
            (Self >= #$002C) and (Self <= #$002E) or
            (Self >= #$003A) and (Self <= #$003B) or
            (Self  = #$003F) or  (Self =  #$005B) or
            (Self  = #$005D) or  (Self =  #$0060) or
            (Self  = #$007B) or  (Self =  #$007D) or
            (Self  = #$007E) or  (Self =  #$00A0) or
            (Self >= #$00B7) or
            (Self >= #$0300) and (Self <= #$031B) or
            (Self >= #$2010) and (Self <= #$2027) or
            (Self >= #$3001) and (Self <= #$302F) or
            (Self >= #$FE30) and (Self <= #$FE5F) or
            (Self >= #$FF01) and (Self <= #$FF0F) or
            (Self >= #$FF1A) and (Self <= #$FF1F) or
            (Self >= #$FF3B) and (Self <= #$FF40) or
            (Self >= #$FF5B) and (Self <= #$FE65);
end;

function TChar16Helper.IsLineBreakCJK: Boolean;
begin
  result := (Self = #$09)or
            (Self = #$20) or
           ((Self >= #$2E80) and (Self <= #$A4CF)) or
           ((Self >= #$AC00) and (Self <= #$D7FF)) or
           ((Self >= #$F900) and (Self <= #$FAFF)) or
           ((Self >= #$FF00) and (Self <= #$FFEF)) or
           ((Self >= #$DC00) and (Self <= #$DFFF));
end;

function TChar16Helper.IsWordChar: Boolean;
begin
  Result := IsLetter or IsSurrogate or IsDigit;
end;

function TChar16Helper.IsWordCharCJK: Boolean;
begin
  Result := IsLetter or IsCJK and IsDigitA;
end;

function TChar16Helper.ToLowerA: Char;
begin
  if (Self >= 'A') and (Self <= 'Z')
    then Result := Char(Ord(Self) + $20)
    else Result := Self;
end;

function TChar16Helper.ToUpperA: Char;
begin
  if (Self >= 'a') and (Self <= 'z')
    then Result := Char(Ord(Self) - $20)
    else Result := Self;
end;

function TChar16Helper.ToChar32: Char32;
begin
  Result := Char(Self).ToUCS4Char;
end;

procedure TChar16Helper.ChangeToLowerA;
begin
  if (Self >= 'A') and (Self <= 'Z')
    then Inc(Self, $20);
end;

procedure TChar16Helper.ChangeToUpperA;
begin
  if (Self >= 'a') and (Self <= 'z')
    then Dec(Self, $20);
end;

procedure TChar16Helper.ChangeToLower;
begin
  Self := Self.ToLower;
end;

procedure TChar16Helper.ChangeToUpper;
begin
  Self := Self.ToUpper;
end;

function TChar16Helper.ToHexString: string;
begin
  Result := IntToHex(UInt16(Self), 1);
end;

function TChar16Helper.ToHexString(const MinDigits: Integer): string;
begin
  Result := IntToHex(UInt16(Self), MinDigits);
end;

function TChar16Helper.ToInteger: Integer;
begin
  Result := Integer(UInt16(Self));
end;

function TChar16Helper.ToIntString: string;
begin
  Result := IntToStr(UInt16(Self));
end;

procedure TChar16Helper.SwapWith(var a: Char16);
begin
  var Temp := a;
  a := Self;
  Self := Temp;
end;
{$ENDREGION}


{$REGION 'TFloat32Helper'}
class function TFloat32Helper.ToString(const Value: Float32): string;
begin
  Result := FloatToStr(Value);
end;

class function TFloat32Helper.ToString(const Value: Float32; const AFormatSettings: TFormatSettings): string;
begin
  Result := FloatToStr(Value, AFormatSettings);
end;

class function TFloat32Helper.ToString(const Value: Float32; const Format: TFloatFormat; const Precision, Digits: NInt): string;
begin
  Result := FloatToStrF(Value, Format, Precision, Digits);
end;

class function TFloat32Helper.ToString(const Value: Float32; const Format: TFloatFormat; const Precision, Digits: NInt;
  const AFormatSettings: TFormatSettings): string;
begin
  Result := FloatToStrF(Value, Format, Precision, Digits, AFormatSettings);
end;

class function TFloat32Helper.Parse(const S: string; const AFormatSettings: TFormatSettings): Float32;
begin
  if not TryParse(S, Result, AFormatSettings) then
    Exception.RaiseConvertFloatError(s, 'Float32');
end;

class function TFloat32Helper.Parse(const S: string): Float32;
begin
  Result := Parse(S, FormatSettings);
end;

class function TFloat32Helper.TryParse(const S: string; out Value: Float32; const AFormatSettings: TFormatSettings): Boolean;
var
  E: Extended;
begin
  Result := TryStrToFloat(S, E, AFormatSettings);
  Result := Result and (Float32.MinValue <= E) and (E <= Float32.MaxValue);
  if Result then
    Value := E;
end;

class function TFloat32Helper.TryParse(const S: string; out Value: Float32; AllowPrecent: Boolean = False): Boolean;
begin
  if AllowPrecent and s.EndsWith('%')
    then Result := TryParse(S.ExcludeRight(1), Value, FormatSettings)
    else Result := TryParse(S, Value, FormatSettings);
end;

class function TFloat32Helper.IsNan(const Value: Float32): Boolean;
begin
  Result := (Value.SpecialType = TFloatSpecial.fsNan);
end;

class function TFloat32Helper.IsInfinity(const Value: Float32): Boolean;
begin
  var FloatType := Value.SpecialType;
  Result := (FloatType = fsInf) or (FloatType = fsNInf);
end;

class function TFloat32Helper.IsNegativeInfinity(const Value: Float32): Boolean;
begin
  Result := (Value.SpecialType = TFloatSpecial.fsNInf);
end;

class function TFloat32Helper.IsPositiveInfinity(const Value: Float32): Boolean;
begin
  Result := (Value.SpecialType = TFloatSpecial.fsInf);
end;


function TFloat32Helper.InternalGetBytes(i: NUInt): UInt8;
begin
  Result := PByteArray(@Self)[i];
end;

function TFloat32Helper.InternalGetWords(i: NUInt): UInt16;
begin
  Result := PWordArray(@Self)[i];
end;

procedure TFloat32Helper.InternalSetBytes(i: NUInt; const Value: UInt8);
begin
  PByteArray(@Self)[i] := Value;
end;

procedure TFloat32Helper.InternalSetWords(i: NUInt; const Value: UInt16);
begin
  PWordArray(@Self)[i] := Value;
end;

function TFloat32Helper.GetBytes(i: NUInt): UInt8;
begin
  if i >= Size then System.Error(reRangeError);
  Result := InternalGetBytes(i);
end;

function TFloat32Helper.GetWords(i: NUInt): UInt16;
begin
  if i >= Size div 2 then System.Error(reRangeError);
  Result := InternalGetWords(i);
end;

procedure TFloat32Helper.SetBytes(i: NUInt; Value: UInt8);
begin
  if i >= Size then System.Error(reRangeError);
  InternalSetBytes(i, Value);
end;

procedure TFloat32Helper.SetWords(i: NUInt; Value: UInt16);
begin
  if i >= Size div 2 then System.Error(reRangeError);
  InternalSetWords(i, Value);
end;

function TFloat32Helper.GetExp: UInt64;
begin
  Result := (InternalGetWords(1) shr 7) and $FF;
end;

function TFloat32Helper.GetFrac: UInt64;
begin
  Result := PUInt32(@Self)^ and $007FFFFF;
end;

function TFloat32Helper.GetSign: Boolean;
begin
  Result := InternalGetBytes(3) >= $80;
end;

procedure TFloat32Helper.SetExp(NewExp: UInt64);
begin
  var W := InternalGetWords(1);
  W := (W and $807F) or ((NewExp and $FF) shl 7);
  InternalSetWords(1, W);
end;

procedure TFloat32Helper.SetFrac(NewFrac: UInt64);
begin
  var LW := PUInt32(@Self)^;
  LW := (LW and $FF800000) or (NewFrac and $007FFFFF);
  PUInt32(@Self)^ := LW;
end;

procedure TFloat32Helper.SetSign(NewSign: Boolean);
begin
  var B := InternalGetBytes(3);
  if NewSign then B := B or $80
  else            B := B and $7F;
  InternalSetBytes(3, B);
end;


function TFloat32Helper.ToString: string;
begin
  Result := FloatToStr(Self);
end;

function TFloat32Helper.ToString(const AFormatSettings: TFormatSettings): string;
begin
  Result := FloatToStr(Self, AFormatSettings);
end;

function TFloat32Helper.ToString(const Format: TFloatFormat; const Precision, Digits: NInt): string;
begin
  Result := FloatToStrF(Self, Format, Precision, Digits);
end;

function TFloat32Helper.ToString(const Format: TFloatFormat; const Precision, Digits: NInt;
                         const AFormatSettings: TFormatSettings): string;
begin
  Result := FloatToStrF(Self, Format, Precision, Digits, AFormatSettings);
end;

function TFloat32Helper.IsNan: Boolean;
begin
  Result := (Self.SpecialType = TFloatSpecial.fsNan);
end;

function TFloat32Helper.IsInfinity: Boolean;
begin
  var FloatType := Self.SpecialType;
  Result := (FloatType = fsInf) or (FloatType = fsNInf);
end;

function TFloat32Helper.IsNegativeInfinity: Boolean;
begin
  Result := (Self.SpecialType = TFloatSpecial.fsNInf);
end;

function TFloat32Helper.IsPositiveInfinity: Boolean;
begin
  Result := (Self.SpecialType = TFloatSpecial.fsInf);
end;

procedure TFloat32Helper.BuildUp(const SignFlag: Boolean; const Mantissa: UInt64; const Exponent: Int32);
begin
  Self := 0.0;
  Sign := SignFlag;
  Exp := Exponent + $7F;
  Frac := Mantissa and $007FFFFF;
end;

{$WARN SYMBOL_DEPRECATED OFF}
function TFloat32Helper.Exponent: Int32;
begin
  Result := TSingleRec(Self).Exponent;
end;

function TFloat32Helper.Fraction: Extended;
begin
  Result := TSingleRec(Self).Fraction;
end;

function TFloat32Helper.Mantissa: UInt64;
begin
  Result := TSingleRec(Self).Mantissa;
end;

function TFloat32Helper.SpecialType: TFloatSpecial;
begin
  Result := TSingleRec(Self).SpecialType;
end;
{$WARN SYMBOL_DEPRECATED ON}

class function TFloat32Helper.Parse(const S: string; const Default: Float32): Float32;
begin
  if not TryParse(s, Result) then Result := Default;
end;

class function TFloat32Helper.TryParseWithSeparators(const s: string; out Value: Float32; KSep, DSep, FSep: char): Boolean;
begin
  Result := Numbers.TryParseWithSeparators(s, KSep, DSep, FSep, Value);
end;

class function TFloat32Helper.TryParseWithSeparators(const s: string; out Value: Float32; KSep, DSep: char): Boolean;
begin
  Result := Numbers.TryParseWithSeparators(s, KSep, DSep, Value);
end;

class function TFloat32Helper.TryParseWithComma(const s: string; out Value: Float32): Boolean;
begin
  Result := Numbers.TryParseWithComma(s, Value);
end;

class function TFloat32Helper.TryParseWithLocalSeparators(const s: string; out Value: Float32): Boolean;
begin
  Result := Numbers.TryParseWithLocalSeparators(s, Value);
end;

function TFloat32Helper.ToStringWithSeparators(nFrac: NInt; KSep, DSep, FSep: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, nFrac, KSep, DSep, FSep);
end;

function TFloat32Helper.ToStringWithSeparators(nFrac: NInt; KSep, DSep: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, nFrac, KSep, DSep);
end;

function TFloat32Helper.ToCommaString(nFrac: NInt; NoTraillingZero: Boolean = False): string;
begin
  Result := Numbers.ToCommaString(Self, nFrac, NoTraillingZero);
end;

function TFloat32Helper.ToLocaleString(nFrac: NInt; NoTraillingZero: Boolean = False): string;
begin
  Result := Numbers.ToLocaleString(Self, nFrac, NoTraillingZero);
end;

function TFloat32Helper.ToScientificString(nFrac: NInt; DSep, FSep: Char): string;
begin
  Result := Numbers.ToScientificString(Self, nFrac, DSep, FSep);
end;

function TFloat32Helper.ToRoundedString: string;
begin
  Result := Numbers.ToRoundedString(Self);
end;

function TFloat32Helper.ToRoundedString(const Fmt: string): string;
begin
  Result := Numbers.ToRoundedString(Fmt, Self);
end;

function TFloat32Helper.ToFloat64: Float64;
begin
  Result := Self;
end;

function TFloat32Helper.ToFloatEx: FloatEx;
begin
  Result := Self;
end;

function TFloat32Helper.RoundTo(nFrac: NInt): Float32;
begin
  Result := System.Math.RoundTo(Self, nFrac);
end;

function TFloat32Helper.Round: Int64;
begin
  Result := System.Round(Self);
end;

function TFloat32Helper.RoundUp: Int64;
begin
  Result := System.Trunc(Self);
  if Frac > 0 then Inc(Result);
end;

function TFloat32Helper.RoundDown: Int64;
begin
  Result := System.Trunc(Self);
  if Frac < 0 then Dec(Result);
end;

function TFloat32Helper.Trunc: Int64;
begin
  Result := System.Trunc(Self);
end;

function TFloat32Helper.SignInt: NInt;
begin
  if Self = 0 then Result := 0
  else if Self > 0 then Result := 1
  else Result := -1;
end;

function TFloat32Helper.Abs: Float32;
begin
  if Self < 0
    then Result := -Self
    else Result := Self;
end;

function TFloat32Helper.EnsureRange(const Min, Max: Float32): Float32;
begin
  if Self > Max then Exit(Max)
  else if Self < Min then Exit(Min)
  else Exit(Self);
end;

function TFloat32Helper.InRange(const Min, Max: Float32): Bool;
begin
  Result := (Self >= Min) and (Self <= Max);
end;

function TFloat32Helper.Max(const a: Float32): Float32;
begin
  if Self >= a
    then Result := Self
    else Result := a;
end;

function TFloat32Helper.Max(const a, b: Float32): Float32;
begin
  Result := ez.Max(Self, a, b);
end;

function TFloat32Helper.Min(const a: Float32): Float32;
begin
  if Self <= a
    then Result := Self
    else Result := a;
end;

function TFloat32Helper.Min(const a, b: Float32): Float32;
begin
  Result := ez.Min(Self, a, b);
end;

function TFloat32Helper.NearestMultiple(n: Int64): Int64;
begin
  Result := System.Round(Self / n) * n;
end;

function TFloat32Helper.NearestMultipleF(n: Float32): Float32;
begin
  Result := System.Round(Self / n) * n;
end;

procedure TFloat32Helper.SetToLarger(const a: Float32);
begin
  if Self < a then Self := a;
end;

procedure TFloat32Helper.SetToLarger(const a, b: Float32);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
end;

procedure TFloat32Helper.SetToLarger(const a, b, c: Float32);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
  if Self < c then Self := c;
end;

procedure TFloat32Helper.SetToSmaller(const a: Float32);
begin
  if Self > a then Self := a;
end;

procedure TFloat32Helper.SetToSmaller(const a, b: Float32);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
end;

procedure TFloat32Helper.SetToSmaller(const a, b, c: Float32);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
  if Self > c then Self := c;
end;

procedure TFloat32Helper.SetToRange(const Min, Max: Float32);
begin
  if Self > Max then Self := Max
  else if Self < Min then Self := Min;
end;

procedure TFloat32Helper.SwapWith(var a: Float32);
begin
  var Temp := a;
  a := Self;
  Self := Temp;
end;
{$ENDREGION}

{$REGION 'TFloat64Helper'}
class function TFloat64Helper.ToString(const Value: Float64): string;
begin
  Result := FloatToStr(Value);
end;

class function TFloat64Helper.ToString(const Value: Float64; const AFormatSettings: TFormatSettings): string;
begin
  Result := FloatToStr(Value, AFormatSettings);
end;

class function TFloat64Helper.ToString(const Value: Float64; const Format: TFloatFormat; const Precision, Digits: NInt): string;
begin
  Result := FloatToStrF(Value, Format, Precision, Digits);
end;

class function TFloat64Helper.ToString(const Value: Float64; const Format: TFloatFormat; const Precision, Digits: NInt;
  const AFormatSettings: TFormatSettings): string;
begin
  Result := FloatToStrF(Value, Format, Precision, Digits, AFormatSettings);
end;

class function TFloat64Helper.Parse(const S: string; const AFormatSettings: TFormatSettings): Float64;
begin
  if not TryParse(S, Result, AFormatSettings) then
    Exception.RaiseConvertFloatError(s, 'Float64');
end;

class function TFloat64Helper.Parse(const S: string): Float64;
begin
  Result := Parse(S, FormatSettings);
end;

class function TFloat64Helper.TryParse(const S: string; out Value: Float64; const AFormatSettings: TFormatSettings): Boolean;
{$IFDEF EXTENDED80}
var
  E: Extended;
begin
  Result := TryStrToFloat(S, E, AFormatSettings);
  Result := Result and (Double.MinValue <= E) and (E <= Double.MaxValue);
  if Result then
    Value := E;
end;
{$ELSE}
begin
  Result := TryStrToFloat(S, Value, AFormatSettings);
end;
{$ENDIF}

class function TFloat64Helper.TryParse(const S: string; out Value: Float64; AllowPrecent: Boolean = False): Boolean;
begin
  if AllowPrecent and s.EndsWith('%')
    then Result := TryParse(S.ExcludeRight(1), Value, FormatSettings)
    else Result := TryParse(S, Value, FormatSettings);
end;

class function TFloat64Helper.IsNan(const Value: Float64): Boolean;
begin
  Result := (Value.SpecialType = TFloatSpecial.fsNan);
end;

class function TFloat64Helper.IsInfinity(const Value: Float64): Boolean;
begin
  var FloatType := Value.SpecialType;
  Result := (FloatType = fsInf) or (FloatType = fsNInf);
end;

class function TFloat64Helper.IsNegativeInfinity(const Value: Float64): Boolean;
begin
  Result := (Value.SpecialType = TFloatSpecial.fsNInf);
end;

class function TFloat64Helper.IsPositiveInfinity(const Value: Float64): Boolean;
begin
  Result := (Value.SpecialType = TFloatSpecial.fsInf);
end;


function TFloat64Helper.InternalGetBytes(i: NUInt): UInt8;
begin
  Result := PByteArray(@Self)[i];
end;

function TFloat64Helper.InternalGetWords(i: NUInt): UInt16;
begin
  Result := PWordArray(@Self)[i];
end;

procedure TFloat64Helper.InternalSetBytes(i: NUInt; const Value: UInt8);
begin
  PByteArray(@Self)[i] := Value;
end;

procedure TFloat64Helper.InternalSetWords(i: NUInt; const Value: UInt16);
begin
  PWordArray(@Self)[i] := Value;
end;

function TFloat64Helper.GetBytes(i: NUInt): UInt8;
begin
  if i >= Size then System.Error(reRangeError);
  Result := InternalGetBytes(i);
end;

function TFloat64Helper.GetWords(i: NUInt): UInt16;
begin
  if i >= Size div 2 then System.Error(reRangeError);
  Result := InternalGetWords(i);
end;

procedure TFloat64Helper.SetBytes(i: NUInt; Value: UInt8);
begin
  if i >= Size then System.Error(reRangeError);
  InternalSetBytes(i, Value);
end;

procedure TFloat64Helper.SetWords(i: NUInt; Value: UInt16);
begin
  if i >= Size div 2 then System.Error(reRangeError);
  InternalSetWords(i, Value);
end;

function TFloat64Helper.GetExp: UInt64;
begin
  Result := (InternalGetWords(3) shr 4) and $7FF;
end;

function TFloat64Helper.GetFrac: UInt64;
begin
  Result := PUInt64(@Self)^ and $000FFFFFFFFFFFFF;
end;

function TFloat64Helper.GetSign: Boolean;
begin
  Result := InternalGetBytes(7) >= $80;
end;

procedure TFloat64Helper.SetExp(NewExp: UInt64);
begin
  var W := InternalGetWords(3);
  W := (W and $800F) or ((NewExp and $7FF) shl 4);
  InternalSetWords(3, W);
end;

procedure TFloat64Helper.SetFrac(NewFrac: UInt64);
begin
  var U64 := PUInt64(@Self)^;
  U64 := (U64 and $FFF0000000000000) or (NewFrac and $000FFFFFFFFFFFFF);
  PUInt64(@Self)^ := U64;
end;

procedure TFloat64Helper.SetSign(NewSign: Boolean);
begin
  var B := InternalGetBytes(7);
  if NewSign then B := B or $80
  else            B := B and $7F;
  InternalSetBytes(7, B);
end;

function TFloat64Helper.ToString: string;
begin
  Result := FloatToStr(Self);
end;

function TFloat64Helper.ToString(const AFormatSettings: TFormatSettings): string;
begin
  Result := FloatToStr(Self, AFormatSettings);
end;

function TFloat64Helper.ToString(const Format: TFloatFormat; const Precision, Digits: NInt): string;
begin
  Result := FloatToStrF(Self, Format, Precision, Digits);
end;

function TFloat64Helper.ToString(const Format: TFloatFormat; const Precision, Digits: NInt;
                         const AFormatSettings: TFormatSettings): string;
begin
  Result := FloatToStrF(Self, Format, Precision, Digits, AFormatSettings);
end;

function TFloat64Helper.IsNan: Boolean;
begin
  Result := (Self.SpecialType = TFloatSpecial.fsNan);
end;

function TFloat64Helper.IsInfinity: Boolean;
begin
  var FloatType := Self.SpecialType;
  Result := (FloatType = fsInf) or (FloatType = fsNInf);
end;

function TFloat64Helper.IsNegativeInfinity: Boolean;
begin
  Result := (Self.SpecialType = TFloatSpecial.fsNInf);
end;

function TFloat64Helper.IsPositiveInfinity: Boolean;
begin
  Result := (Self.SpecialType = TFloatSpecial.fsInf);
end;

procedure TFloat64Helper.BuildUp(const SignFlag: Boolean; const Mantissa: UInt64; const Exponent: Int32);
begin
  Self := 0.0;
  SetSign(SignFlag);
  SetExp(Exponent + $3FF);
  SetFrac(Mantissa and $000FFFFFFFFFFFFF);
end;

{$WARN SYMBOL_DEPRECATED OFF}
function TFloat64Helper.Exponent: Int32;
begin
  Result := TDoubleRec(Self).Exponent;
end;

function TFloat64Helper.Fraction: Extended;
begin
  Result := TDoubleRec(Self).Fraction;
end;

function TFloat64Helper.Mantissa: UInt64;
begin
  Result := TDoubleRec(Self).Mantissa;
end;

function TFloat64Helper.SpecialType: TFloatSpecial;
begin
  Result := TDoubleRec(Self).SpecialType;
end;
{$WARN SYMBOL_DEPRECATED ON}

class function TFloat64Helper.Parse(const S: string; const Default: Float64): Float64;
begin
  if not TryParse(s, Result) then Result := Default;
end;

class function TFloat64Helper.TryParseWithSeparators(const s: string; out Value: Float64; KSep, DSep, FSep: char): Boolean;
begin
  Result := Numbers.TryParseWithSeparators(s, KSep, DSep, FSep, Value);
end;

class function TFloat64Helper.TryParseWithSeparators(const s: string; out Value: Float64; KSep, DSep: char): Boolean;
begin
  Result := Numbers.TryParseWithSeparators(s, KSep, DSep, Value);
end;

class function TFloat64Helper.TryParseWithComma(const s: string; out Value: Float64): Boolean;
begin
  Result := Numbers.TryParseWithComma(s, Value);
end;

class function TFloat64Helper.TryParseWithLocalSeparators(const s: string; out Value: Float64): Boolean;
begin
  Result := Numbers.TryParseWithLocalSeparators(s, Value);
end;

function TFloat64Helper.ToStringWithSeparators(nFrac: NInt; KSep, DSep, FSep: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, nFrac, KSep, DSep, FSep);
end;

function TFloat64Helper.ToStringWithSeparators(nFrac: NInt; KSep, DSep: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, nFrac, KSep, DSep);
end;

function TFloat64Helper.ToCommaString(nFrac: NInt; NoTraillingZero: Boolean = False): string;
begin
  Result := Numbers.ToCommaString(Self, nFrac, NoTraillingZero);
end;

function TFloat64Helper.ToLocaleString(nFrac: NInt; NoTraillingZero: Boolean = False): string;
begin
  Result := Numbers.ToLocaleString(Self, nFrac, NoTraillingZero);
end;

function TFloat64Helper.ToScientificString(nFrac: NInt; DSep, FSep: Char): string;
begin
  Result := Numbers.ToScientificString(Self, nFrac, DSep, FSep);
end;

function TFloat64Helper.ToRoundedString: string;
begin
  Result := Numbers.ToRoundedString(Self);
end;

function TFloat64Helper.ToRoundedString(const Fmt: string): string;
begin
  Result := Numbers.ToRoundedString(Fmt, Self);
end;

function TFloat64Helper.ToFloat32: Float32;
begin
  Result := Self;
end;

function TFloat64Helper.ToFloatEx: FloatEx;
begin
  Result := Self;
end;

function TFloat64Helper.RoundTo(nFrac: NInt): Float64;
begin
  Result := System.Math.RoundTo(Self, nFrac);
end;

function TFloat64Helper.Round: Int64;
begin
  Result := System.Round(Self);
end;

function TFloat64Helper.RoundUp: Int64;
begin
  Result := System.Trunc(Self);
  if Frac > 0 then Inc(Result);
end;

function TFloat64Helper.RoundDown: Int64;
begin
  Result := System.Trunc(Self);
  if Frac < 0 then Dec(Result);
end;

function TFloat64Helper.Trunc: Int64;
begin
  Result := System.Trunc(Self);
end;

function TFloat64Helper.SignInt: NInt;
begin
  if Self = 0 then Result := 0
  else if Self > 0 then Result := 1
  else Result := -1;
end;

function TFloat64Helper.Abs: Float64;
begin
  if Self < 0
    then Result := -Self
    else Result := Self;
end;

function TFloat64Helper.EnsureRange(const Min, Max: Float64): Float64;
begin
  if Self > Max then Exit(Max)
  else if Self < Min then Exit(Min)
  else Exit(Self);
end;

function TFloat64Helper.InRange(const Min, Max: Float64): Bool;
begin
  Result := (Self >= Min) and (Self <= Max);
end;

function TFloat64Helper.Max(const a: Float64): Float64;
begin
  if Self >= a
    then Result := Self
    else Result := a;
end;

function TFloat64Helper.Max(const a, b: Float64): Float64;
begin
  Result := ez.Max(Self, a, b);
end;

function TFloat64Helper.Min(const a: Float64): Float64;
begin
  if Self <= a
    then Result := Self
    else Result := a;
end;

function TFloat64Helper.Min(const a, b: Float64): Float64;
begin
  Result := ez.Min(Self, a, b);
end;

function TFloat64Helper.NearestMultiple(n: Int64): Int64;
begin
  Result := System.Round(Self / n) * n;
end;

function TFloat64Helper.NearestMultipleF(n: Float64): Float64;
begin
  Result := System.Round(Self / n) * n;
end;

procedure TFloat64Helper.SetToLarger(const a: Float64);
begin
  if Self < a then Self := a;
end;

procedure TFloat64Helper.SetToLarger(const a, b: Float64);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
end;

procedure TFloat64Helper.SetToLarger(const a, b, c: Float64);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
  if Self < c then Self := c;
end;

procedure TFloat64Helper.SetToSmaller(const a: Float64);
begin
  if Self > a then Self := a;
end;

procedure TFloat64Helper.SetToSmaller(const a, b: Float64);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
end;

procedure TFloat64Helper.SetToSmaller(const a, b, c: Float64);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
  if Self > c then Self := c;
end;

procedure TFloat64Helper.SetToRange(const Min, Max: Float64);
begin
  if Self > Max then Self := Max
  else if Self < Min then Self := Min;
end;

procedure TFloat64Helper.SwapWith(var a: Float64);
begin
  var Temp := a;
  a := Self;
  Self := Temp;
end;
{$ENDREGION}

{$REGION 'TFloatExHelper'}
class function TFloatExHelper.ToString(const Value: FloatEx): string;
begin
  Result := FloatToStr(Value);
end;

class function TFloatExHelper.ToString(const Value: FloatEx; const AFormatSettings: TFormatSettings): string;
begin
  Result := FloatToStr(Value, AFormatSettings);
end;

class function TFloatExHelper.ToString(const Value: FloatEx; const Format: TFloatFormat; const Precision, Digits: NInt): string;
begin
  Result := FloatToStrF(Value, Format, Precision, Digits);
end;

class function TFloatExHelper.ToString(const Value: FloatEx; const Format: TFloatFormat; const Precision, Digits: NInt;
  const AFormatSettings: TFormatSettings): string;
begin
  Result := FloatToStrF(Value, Format, Precision, Digits, AFormatSettings);
end;

class function TFloatExHelper.Parse(const S: string; const AFormatSettings: TFormatSettings): FloatEx;
begin
  if not TryParse(S, Result, AFormatSettings) then
    Exception.RaiseConvertFloatError(s, 'FloatEx');
end;

class function TFloatExHelper.Parse(const S: string): FloatEx;
begin
  Result := Parse(S, FormatSettings);
end;

class function TFloatExHelper.TryParse(const S: string; out Value: FloatEx; const AFormatSettings: TFormatSettings): Boolean;
begin
  Result := TryStrToFloat(S, Value, AFormatSettings);
end;

class function TFloatExHelper.TryParse(const S: string; out Value: FloatEx; AllowPrecent: Boolean = False): Boolean;
begin
  if AllowPrecent and s.EndsWith('%')
    then Result := TryParse(S.ExcludeRight(1), Value, FormatSettings)
    else Result := TryParse(S, Value, FormatSettings);
end;

class function TFloatExHelper.IsNan(const Value: FloatEx): Boolean;
begin
  Result := (Value.SpecialType = TFloatSpecial.fsNan);
end;

class function TFloatExHelper.IsInfinity(const Value: FloatEx): Boolean;
begin
  var FloatType := Value.SpecialType;
  Result := (FloatType = fsInf) or (FloatType = fsNInf);
end;

class function TFloatExHelper.IsNegativeInfinity(const Value: FloatEx): Boolean;
begin
  Result := (Value.SpecialType = TFloatSpecial.fsNInf);
end;

class function TFloatExHelper.IsPositiveInfinity(const Value: FloatEx): Boolean;
begin
  Result := (Value.SpecialType = TFloatSpecial.fsInf);
end;


function TFloatExHelper.InternalGetBytes(i: NUInt): UInt8;
begin
  Result := PByteArray(@Self)[i];
end;

function TFloatExHelper.InternalGetWords(i: NUInt): UInt16;
begin
  Result := PWordArray(@Self)[i];
end;

procedure TFloatExHelper.InternalSetBytes(i: NUInt; const Value: UInt8);
begin
  PByteArray(@Self)[i] := Value;
end;

procedure TFloatExHelper.InternalSetWords(i: NUInt; const Value: UInt16);
begin
  PWordArray(@Self)[i] := Value;
end;

function TFloatExHelper.GetBytes(i: NUInt): UInt8;
begin
  if i >= Size then System.Error(reRangeError);
  Result := InternalGetBytes(i);
end;

function TFloatExHelper.GetWords(i: NUInt): UInt16;
begin
  if i >= Size div 2 then System.Error(reRangeError);
  Result := InternalGetWords(i);
end;

procedure TFloatExHelper.SetBytes(i: NUInt; Value: UInt8);
begin
  if i >= Size then System.Error(reRangeError);
  InternalSetBytes(i, Value);
end;

procedure TFloatExHelper.SetWords(i: NUInt; Value: UInt16);
begin
  if i >= Size div 2 then System.Error(reRangeError);
  InternalSetWords(i, Value);
end;

function TFloatExHelper.GetExp: UInt64;
begin
  Result := InternalGetWords(4) and $7FFF;
end;

function TFloatExHelper.GetFrac: UInt64;
begin
  Result := PUInt64(@Self)^; // first 4 bytes are fraction part.
end;

function TFloatExHelper.GetSign: Boolean;
begin
  Result := InternalGetBytes(9) >= $80;
end;

procedure TFloatExHelper.SetExp(NewExp: UInt64);
begin
  var W := InternalGetWords(4);
  W := (W and $8000) or (NewExp and $7FFF);
  InternalSetWords(4, W);
end;

procedure TFloatExHelper.SetFrac(NewFrac: UInt64);
begin
  PUint64(@Self)^ := NewFrac;
end;

procedure TFloatExHelper.SetSign(NewSign: Boolean);
begin
  var B := InternalGetBytes(9);
  if NewSign then B := B or $80
  else            B := B and $7F;
  InternalSetBytes(9, B);
end;


function TFloatExHelper.ToString: string;
begin
  Result := FloatToStr(Self);
end;

function TFloatExHelper.ToString(const AFormatSettings: TFormatSettings): string;
begin
  Result := FloatToStr(Self, AFormatSettings);
end;

function TFloatExHelper.ToString(const Format: TFloatFormat; const Precision, Digits: NInt): string;
begin
  Result := FloatToStrF(Self, Format, Precision, Digits);
end;

function TFloatExHelper.ToString(const Format: TFloatFormat; const Precision, Digits: NInt;
                         const AFormatSettings: TFormatSettings): string;
begin
  Result := FloatToStrF(Self, Format, Precision, Digits, AFormatSettings);
end;

function TFloatExHelper.IsNan: Boolean;
begin
  Result := (Self.SpecialType = TFloatSpecial.fsNan);
end;

function TFloatExHelper.IsInfinity: Boolean;
begin
  var FloatType := Self.SpecialType;
  Result := (FloatType = fsInf) or (FloatType = fsNInf);
end;

function TFloatExHelper.IsNegativeInfinity: Boolean;
begin
  Result := (Self.SpecialType = TFloatSpecial.fsNInf);
end;

function TFloatExHelper.IsPositiveInfinity: Boolean;
begin
  Result := (Self.SpecialType = TFloatSpecial.fsInf);
end;

procedure TFloatExHelper.BuildUp(const SignFlag: Boolean; const Mantissa: UInt64; const Exponent: Int32);
begin
  Self := 0.0;
  SetSign(SignFlag);
  SetExp(Exponent + $3FFF);
  SetFrac(Mantissa);
end;

{$WARN SYMBOL_DEPRECATED OFF}
function TFloatExHelper.Exponent: Int32;
begin
  Result := TExtendedRec(Self).Exponent;
end;

function TFloatExHelper.Fraction: Extended;
begin
  Result := TExtendedRec(Self).Fraction;
end;

function TFloatExHelper.Mantissa: UInt64;
begin
  Result := TExtendedRec(Self).Mantissa;
end;

function TFloatExHelper.SpecialType: TFloatSpecial;
begin
  Result := TExtendedRec(Self).SpecialType;
end;
{$WARN SYMBOL_DEPRECATED ON}

class function TFloatExHelper.Parse(const S: string; const Default: FloatEx): FloatEx;
begin
  if not TryParse(s, Result) then Result := Default;
end;

class function TFloatExHelper.TryParseWithSeparators(const s: string; out Value: FloatEx; KSep, DSep, FSep: char): Boolean;
begin
  Result := Numbers.TryParseWithSeparators(s, KSep, DSep, FSep, Value);
end;

class function TFloatExHelper.TryParseWithSeparators(const s: string; out Value: FloatEx; KSep, DSep: char): Boolean;
begin
  Result := Numbers.TryParseWithSeparators(s, KSep, DSep, Value);
end;

class function TFloatExHelper.TryParseWithComma(const s: string; out Value: FloatEx): Boolean;
begin
  Result := Numbers.TryParseWithComma(s, Value);
end;

class function TFloatExHelper.TryParseWithLocalSeparators(const s: string; out Value: FloatEx): Boolean;
begin
  Result := Numbers.TryParseWithLocalSeparators(s, Value);
end;

function TFloatExHelper.ToStringWithSeparators(nFrac: NInt; KSep, DSep, FSep: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, nFrac, KSep, DSep, FSep);
end;

function TFloatExHelper.ToStringWithSeparators(nFrac: NInt; KSep, DSep: char): string;
begin
  Result := Numbers.ToStringWithSeparators(Self, nFrac, KSep, DSep);
end;

function TFloatExHelper.ToCommaString(nFrac: NInt; NoTraillingZero: Boolean = False): string;
begin
  Result := Numbers.ToCommaString(Self, nFrac, NoTraillingZero);
end;

function TFloatExHelper.ToLocaleString(nFrac: NInt; NoTraillingZero: Boolean = False): string;
begin
  Result := Numbers.ToLocaleString(Self, nFrac, NoTraillingZero);
end;

function TFloatExHelper.ToScientificString(nFrac: NInt; DSep, FSep: Char): string;
begin
  Result := Numbers.ToScientificString(Self, nFrac, DSep, FSep);
end;

function TFloatExHelper.ToRoundedString: string;
begin
  Result := Numbers.ToRoundedString(Self);
end;

function TFloatExHelper.ToRoundedString(const Fmt: string): string;
begin
  Result := Numbers.ToRoundedString(Fmt, Self);
end;

function TFloatExHelper.ToFloat64: Float64;
begin
  Result := Self;
end;

function TFloatExHelper.ToFloat32: Float32;
begin
  Result := Self;
end;

function TFloatExHelper.RoundTo(nFrac: NInt): FloatEx;
begin
  Result := System.Math.RoundTo(Self, nFrac);
end;

function TFloatExHelper.Round: Int64;
begin
  Result := System.Round(Self);
end;

function TFloatExHelper.RoundUp: Int64;
begin
  Result := System.Trunc(Self);
  if Frac > 0 then Inc(Result);
end;

function TFloatExHelper.RoundDown: Int64;
begin
  Result := System.Trunc(Self);
  if Frac < 0 then Dec(Result);
end;

function TFloatExHelper.Trunc: Int64;
begin
  Result := System.Trunc(Self);
end;

function TFloatExHelper.SignInt: NInt;
begin
  if Self = 0 then Result := 0
  else if Self > 0 then Result := 1
  else Result := -1;
end;

function TFloatExHelper.Abs: FloatEx;
begin
  if Self < 0
    then Result := -Self
    else Result := Self;
end;

function TFloatExHelper.EnsureRange(const Min, Max: FloatEx): FloatEx;
begin
  if Self > Max then Exit(Max)
  else if Self < Min then Exit(Min)
  else Exit(Self);
end;

function TFloatExHelper.InRange(const Min, Max: FloatEx): Bool;
begin
  Result := (Self >= Min) and (Self <= Max);
end;

function TFloatExHelper.Max(const a: FloatEx): FloatEx;
begin
  if Self >= a
    then Result := Self
    else Result := a;
end;

function TFloatExHelper.Max(const a, b: FloatEx): FloatEx;
begin
  Result := ez.Max(Self, a, b);
end;

function TFloatExHelper.Min(const a: FloatEx): FloatEx;
begin
  if Self <= a
    then Result := Self
    else Result := a;
end;

function TFloatExHelper.Min(const a, b: FloatEx): FloatEx;
begin
  Result := ez.Min(Self, a, b);
end;

function TFloatExHelper.NearestMultiple(n: Int64): Int64;
begin
  Result := System.Round(Self / n) * n;
end;

function TFloatExHelper.NearestMultipleF(n: FloatEx): FloatEx;
begin
  Result := System.Round(Self / n) * n;
end;

procedure TFloatExHelper.SetToLarger(const a: FloatEx);
begin
  if Self < a then Self := a;
end;

procedure TFloatExHelper.SetToLarger(const a, b: FloatEx);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
end;

procedure TFloatExHelper.SetToLarger(const a, b, c: FloatEx);
begin
  if Self < a then Self := a;
  if Self < b then Self := b;
  if Self < c then Self := c;
end;

procedure TFloatExHelper.SetToSmaller(const a: FloatEx);
begin
  if Self > a then Self := a;
end;

procedure TFloatExHelper.SetToSmaller(const a, b: FloatEx);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
end;

procedure TFloatExHelper.SetToSmaller(const a, b, c: FloatEx);
begin
  if Self > a then Self := a;
  if Self > b then Self := b;
  if Self > c then Self := c;
end;

procedure TFloatExHelper.SetToRange(const Min, Max: FloatEx);
begin
  if Self > Max then Self := Max
  else if Self < Min then Self := Min;
end;

procedure TFloatExHelper.SwapWith(var a: FloatEx);
begin
  var Temp := a;
  a := Self;
  Self := Temp;
end;
{$ENDREGION}


{$Region 'TNIntsHelper'}
class function TNIntsHelper.Create(Size: NInt): TNInts;
begin
  System.SetLength(Result, Size);
end;

class function TNIntsHelper.Create(Size: NInt; const FillValue: NInt): TNInts;
begin
  System.SetLength(Result, Size);
  Result.Fill(FillValue);
end;


class function TNIntsHelper.Empty: TNInts;
begin
  Result := nil;
end;


function TNIntsHelper.GetLength: NInt;
begin
  Result := System.Length(Self);
end;

function TNIntsHelper.IsEmpty: Boolean;
begin
  Result := TNInts(Self) = nil;
end;

function TNIntsHelper.NotEmpty: Boolean;
begin
  Result := TNInts(Self) <> nil;
end;

function TNIntsHelper.Equals(const Items: array of NInt): Boolean;
begin
  Result := (Length = System.Length(Items)) and
            (IsEmpty or CompareMem(@Self[0], @(Items[0]), Length * SizeOf(NInt)));
end;

function TNIntsHelper.IndexOf(const Value: NInt; fromIndex: NInt): NInt;
begin
  if fromIndex < 0 then fromIndex := 0;
  for var i := fromIndex to Length - 1 do
    if Self[i] = Value then Exit(i);
  Result := -1;
end;

function TNIntsHelper.LastIndexOf(const Value: NInt; fromIndex: NInt): NInt;
begin
  if fromIndex >= Length then fromIndex := Length - 1;
  for var i := fromIndex downto 0 do
    if Self[i] = Value then Exit(i);
  Result := -1;
end;

function TNIntsHelper.LastIndexOf(const Value: NInt): NInt;
begin
  Result := LastIndexOf(Value, Length - 1);
end;

function TNIntsHelper.Includes(const Value: NInt): Boolean;
begin
  Result := IndexOf(Value, 0) >= 0;
end;

procedure TNIntsHelper.Clear;
begin
  Self := nil;
end;

procedure TNIntsHelper.SetLength(Size: NInt);
begin
  System.SetLength(Self, Size);
end;

procedure TNIntsHelper.SetLength(Size: NInt; const ValueForNewItems: NInt);
begin
  var OldSize := Length;
  SetLength(Size);
  if Size > OldSize then ez.FillLong(Self[OldSize], Size - OldSize, ValueForNewItems);
end;

procedure TNIntsHelper.EnsureLength(Size: NInt);
begin
  if Length < Size then SetLength(Size);
end;

procedure TNIntsHelper.Fill(const FillValue: NInt; Index: NInt);
begin
  Fill(FillValue, Index, Length);
end;

procedure TNIntsHelper.Fill(const FillValue: NInt; Index, Len: NInt);
begin
  if (Index < 0) then Exception.RaiseIndexError(Index);
  if Index >= Length then exit;
  ez.ToSmaller(Len, Length - Index);
  if Len <= 0 then Exit;
  ez.FillLong(Self[Index], Len, FillValue);
end;

procedure TNIntsHelper.FillIndex;
begin
  if NotEmpty then
    ez.FillIndex32(Self[0], 0, Length);
end;

procedure TNIntsHelper.FillIndex(Size: NInt);
begin
  SetLength(Size);
  FillIndex;
end;

procedure TNIntsHelper.FillIndexFrom(StartNum: NInt; Index: NInt);
begin
  FillIndexFrom(StartNum, Index, Length);
end;

procedure TNIntsHelper.FillIndexFrom(StartNum: NInt; Index, Len: NInt);
begin
  if (Index < 0) then Exception.RaiseIndexError(Index);
  if Index >= Length then exit;
  ez.ToSmaller(Len, Length - Index);
  if Len <= 0 then Exit;
  ez.FillIndex32(Self[Index], Len, StartNum);
end;

function TNIntsHelper.Add(const Value: NInt): NInt;
begin
  Result := Length;
  SetLength(Result + 1);
  Self[Result] := Value;
end;

function TNIntsHelper.AddUnique(const Value: NInt): NInt;
begin
  Result := IndexOf(Value);
  if Result < 0 then Result := Add(Value);
end;

function TNIntsHelper.Prepend(const Value: NInt): NInt;
begin
  Result := Insert(0, Value);
end;

function TNIntsHelper.Insert(Index: NInt; const Value: NInt): NInt;
begin
  if Index < 0
    then Result := 0
  else if Index > Length
    then Result := Length
    else Result := Index;
  System.Insert(Value, Self, Result);
end;

function TNIntsHelper.Delete(Index: NInt; Len: NInt): NInt;
begin
  if (Index < 0) then Exception.RaiseIndexError(Index);
  Result := ez.Min(Len, Length - Index);
  if Result <= 0 then exit(0);
  System.Delete(Self, Index, Result);
end;

function TNIntsHelper.Remove(const Value: NInt; fromIndex: NInt): Boolean;
begin
  var i := IndexOf(Value, fromIndex);
  Result := (i >= 0);
  if Result then Delete(i);
end;

function TNIntsHelper.RemoveAll(const Value: NInt; fromIndex: NInt): NInt;
var
  i, j: NInt;
begin
  i := IndexOf(Value, fromIndex);
  if i >= 0 then
  begin
    j := i;
    for i := i + 1 to Length - 1  do
      if Self[i] <> Value then
      begin
        Self[j] := Self[i];
        Inc(j);
      end;
    Result := Length - j;
    SetLength(j);
  end else Result := 0;
end;

function TNIntsHelper.Pop: NInt;
begin
  Result := Self[Length - 1];
  SetLength(Length - 1);
end;

function TNIntsHelper.Dequeue: NInt;
begin
  Result := Self[0];
  Delete(0);
end;

procedure TNIntsHelper.Move(FromIndex, ToIndex: NInt);
begin
  if (FromIndex < 0) or (FromIndex >= Length) then Exception.RaiseIndexError(FromIndex);
  if (ToIndex < 0)   or (ToIndex >= Length)   then Exception.RaiseIndexError(ToIndex);
  if FromIndex = ToIndex then exit;

  var t := Self[FromIndex];
  if FromIndex < ToIndex
    then System.Move(Self[FromIndex + 1], Self[FromIndex], (ToIndex - FromIndex - 1) * Sizeof(NInt))
    else System.Move(Self[ToIndex], Self[ToIndex + 1], (FromIndex - ToIndex - 1) * Sizeof(NInt));
  Self[ToIndex] := t;
end;

procedure TNIntsHelper.Exchange(Index1, Index2: NInt);
begin
  if (Index1 < 0) or (Index1 >= Length) then Exception.RaiseIndexError(Index1);
  if (Index2 < 0) or (Index2 >= Length) then Exception.RaiseIndexError(Index2);
  if Index1 = Index2 then exit;

  ez.Swap(Self[Index1], Self[Index2]);
end;
{$ENDREGION}

{$Region 'TObjectsHelper'}
class function TObjectsHelper.Create(Size: NInt): TObjects;
begin
  System.SetLength(Result, Size);
end;

class function TObjectsHelper.Create(Size: NInt; FillNil: Boolean): TObjects;
begin
  System.SetLength(Result, Size);
  if FillNil then Result.FillWithNil;
end;

class function TObjectsHelper.Empty: TObjects;
begin
  Result := nil;
end;


function TObjectsHelper.GetLength: NInt;
begin
  Result := System.Length(Self);
end;

function TObjectsHelper.IsEmpty: Boolean;
begin
  Result := Self = nil;
end;

function TObjectsHelper.NotEmpty: Boolean;
begin
  Result := Self <> nil;
end;

function TObjectsHelper.Equals(const Items: array of TObject): Boolean;
begin
  Result := (Length = System.Length(Items)) and
            (IsEmpty or CompareMem(@Self[0], @(Items[0]), Length * SizeOf(NInt)));
end;

function TObjectsHelper.IndexOf(const Value: TObject; fromIndex: NInt): NInt;
begin
  Result := TNInts(Self).IndexOf(NInt(Value), fromIndex);
end;

function TObjectsHelper.LastIndexOf(const Value: TObject; fromIndex: NInt): NInt;
begin
  Result := TNInts(Self).LastIndexOf(NInt(Value), fromIndex);
end;

function TObjectsHelper.LastIndexOf(const Value: TObject): NInt;
begin
  Result := TNInts(Self).LastIndexOf(NInt(Value));
end;

function TObjectsHelper.Includes(const Value: TObject): Boolean;
begin
  Result := TNInts(Self).Includes(NInt(Value));
end;

procedure TObjectsHelper.Clear;
begin
  Self := nil;
end;

procedure TObjectsHelper.FreeObjectsAndClear;
begin
  for var i := Length - 1 downto 0 do
    FreeAndnil(Self[i]);
  Clear;
end;

procedure TObjectsHelper.SetLength(Size: NInt);
begin
  System.SetLength(Self, Size);
end;

procedure TObjectsHelper.SetLength(Size: NInt; const ValueForNewItems: TObject);
begin
  TNInts(Self).SetLength(Size, NInt(ValueForNewItems));
end;

procedure TObjectsHelper.EnsureLength(Size: NInt);
begin
  if Length < Size then SetLength(Size);
end;

procedure TObjectsHelper.Fill(const FillValue: TObject; Index: NInt);
begin
  TNInts(Self).Fill(NInt(FillValue), Index, Length);
end;

procedure TObjectsHelper.Fill(const FillValue: TObject; Index, Len: NInt);
begin
  TNInts(Self).Fill(NInt(FillValue), Index, Len);
end;

procedure TObjectsHelper.FillWithNil(Index: NInt = 0);
begin
  TNInts(Self).Fill(NInt(Nil), Index);
end;

procedure TObjectsHelper.FillWithNil(Index, Len: NInt);
begin
  TNInts(Self).Fill(NInt(Nil), Index, Len);
end;

function TObjectsHelper.Add(const Value: TObject): NInt;
begin
  Result := TNInts(Self).Add(NInt(Value));
end;

function TObjectsHelper.AddUnique(const Value: TObject): NInt;
begin
  Result := TNInts(Self).AddUnique(NInt(Value));
end;

function TObjectsHelper.Prepend(const Value: TObject): NInt;
begin
  Result := Insert(0, Value);
end;

function TObjectsHelper.Insert(Index: NInt; const Value: TObject): NInt;
begin
  Result := TNInts(Self).Insert(Index, NInt(Value));
end;

function TObjectsHelper.Delete(Index: NInt; Len: NInt): NInt;
begin
  Result := TNInts(Self).Delete(Index, Len);
end;

function TObjectsHelper.Remove(const Value: TObject; fromIndex: NInt): Boolean;
begin
  Result := TNInts(Self).Remove(NInt(Value), fromIndex);
end;

function TObjectsHelper.RemoveAll(const Value: TObject; fromIndex: NInt): NInt;
begin
  Result := TNInts(Self).RemoveAll(NInt(Value), fromIndex);
end;

function TObjectsHelper.Pop: TObject;
begin
  Result := Self[Length - 1];
  SetLength(Length - 1);
end;

function TObjectsHelper.Dequeue: TObject;
begin
  Result := Self[0];
  Delete(0);
end;

procedure TObjectsHelper.Move(FromIndex, ToIndex: NInt);
begin
  TNInts(Self).Move(FromIndex, ToIndex);
end;

procedure TObjectsHelper.Exchange(Index1, Index2: NInt);
begin
  TNInts(Self).Move(Index1, Index2);
end;
{$ENDREGION}


{$REGION 'TStringHelper'}
{$REGION 'Private methods'}
{$ZEROBASEDSTRINGS ON}
function TStringHelper.GetChars(Index: NInt): Char;
begin
  Result := Self[Index];
end;

function TStringHelper.GetSafeChars(Index: NInt): Char;
begin
  if Index >= Length then Result := #0 else Result := Self[Index];
end;
{$ZEROBASEDSTRINGS OFF}

function TStringHelper.GetLength: NInt;
begin
  Result := System.Length(Self);
end;

function TStringHelper.GetPointer: PChar;
begin
  Result := PChar(Self);
end;

function TStringHelper.GetPLast: PChar;
begin
  Result := PChar(Self);
  if Result <> nil then inc(Result, Length - 1);
end;
{$ENDREGION}

{$REGION 'Delphi Built-in class methods'}
class function TStringHelper.Create(C: Char; Count: NInt): string;
begin
  Result := StringOfChar(C, Count);
end;

class function TStringHelper.Create(const Value: array of Char; StartIndex, Length: NInt): string;
begin
  SetLength(Result, Length);
  Move(Value[StartIndex], PChar(Result)^, Length * SizeOf(Char));
end;

class function TStringHelper.Create(const Value: array of Char): string;
begin
  SetLength(Result, System.Length(Value));
  Move(Value[0], PChar(Result)^, System.Length(Value) * SizeOf(Char));
end;

class function TStringHelper.Copy(const Str: string): string;
begin
  Result := System.Copy(Str, 1, Str.Length);
end;

class function TStringHelper.Format(const Format: string; const args: array of const): string;
begin
  Result := System.SysUtils.Format(Format, args);
end;

class function TStringHelper.Join(const Separator: string; const Values: array of const): string;
begin
  Result := _StringWrapper.Join(Separator, Values);
end;

class function TStringHelper.Join(const Separator: string; const Values: array of string): string;
begin
  Result := _StringWrapper.Join(Separator, Values, 0, System.Length(Values));
end;

class function TStringHelper.Join(const Separator: string; const Values: array of string; StartIndex, Count: NInt): string;
begin
  Result := _StringWrapper.Join(Separator, Values, StartIndex, Count);
end;

class function TStringHelper.Join(const Separator: string; const Values: IEnumerable<string>): string;
begin
  if Values <> nil then
    Result := _StringWrapper.Join(Separator, Values.GetEnumerator)
  else
    Result := '';
end;

class function TStringHelper.Join(const Separator: string; const Values: IEnumerator<string>): string;
begin
  Result := _StringWrapper.Join(Separator, Values);
end;

class function TStringHelper.Compare(const StrA: string; const StrB: string): NInt;
begin
  Result := _StringWrapper.Compare(StrA, StrB, [], SysLocale.DefaultLCID);
end;

class function TStringHelper.Compare(const StrA: string; const StrB: string; LocaleID: TLocaleID): NInt;
begin
  Result := _StringWrapper.Compare(StrA, StrB, [], LocaleID);
end;

class function TStringHelper.Compare(const StrA: string; const StrB: string; Options: TCompareOptions): NInt;
begin
  Result := _StringWrapper.Compare(StrA, StrB, Options, SysLocale.DefaultLCID);
end;

class function TStringHelper.Compare(const StrA: string; const StrB: string; Options: TCompareOptions; LocaleID: TLocaleID): NInt;
begin
  Result := _StringWrapper.Compare(StrA, StrB, Options, LocaleID);
end;

class function TStringHelper.Compare(const StrA: string; const StrB: string; IgnoreCase: Boolean): NInt;
begin
  if IgnoreCase
    then Result := _StringWrapper.Compare(StrA, StrB, [coIgnoreCase], SysLocale.DefaultLCID)
    else Result := _StringWrapper.Compare(StrA, StrB, [], SysLocale.DefaultLCID);
end;

class function TStringHelper.Compare(const StrA: string; const StrB: string; IgnoreCase: Boolean; LocaleID: TLocaleID): NInt;
begin
  if IgnoreCase
    then Result := _StringWrapper.Compare(StrA, StrB, [coIgnoreCase], LocaleID)
    else Result := _StringWrapper.Compare(StrA, StrB, [], LocaleID);
end;

class function TStringHelper.Compare(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt): NInt;
begin
  Result := _StringWrapper.Compare(StrA, IndexA, StrB, IndexB, Length, [], SysLocale.DefaultLCID);
end;

class function TStringHelper.Compare(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt; LocaleID: TLocaleID): NInt;
begin
  Result := _StringWrapper.Compare(StrA, IndexA, StrB, IndexB, Length, [], LocaleID);
end;

class function TStringHelper.Compare(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt; Options: TCompareOptions): NInt;
begin
  Result := _StringWrapper.Compare(StrA, IndexA, StrB, IndexB, Length, Options, SysLocale.DefaultLCID);
end;

class function TStringHelper.Compare(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt; Options: TCompareOptions; LocaleID: TLocaleID): NInt;
begin
  Result := _StringWrapper.Compare(StrA, IndexA, StrB, IndexB, Length, Options, LocaleID);
end;

class function TStringHelper.Compare(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt; IgnoreCase: Boolean): NInt;
begin
  if IgnoreCase
    then Result := _StringWrapper.Compare(StrA, IndexA, StrB, IndexB, Length, [coIgnoreCase], SysLocale.DefaultLCID)
    else Result := _StringWrapper.Compare(StrA, IndexA, StrB, IndexB, Length, [], SysLocale.DefaultLCID);
end;

class function TStringHelper.Compare(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt; IgnoreCase: Boolean; LocaleID: TLocaleID): NInt;
begin
  if IgnoreCase
    then Result := _StringWrapper.Compare(StrA, IndexA, StrB, IndexB, Length, [coIgnoreCase], LocaleID)
    else Result := _StringWrapper.Compare(StrA, IndexA, StrB, IndexB, Length, [], LocaleID);
end;

class function TStringHelper.CompareOrdinal(const StrA: string; const StrB: string): NInt;
begin
  if StrA = ''
    then if StrB = ''
      then Result := 0
      else Result := -1
    else Result := System.SysUtils.StrLComp(PChar(StrA), PChar(StrB), ez.Max(StrA.Length, StrB.Length));
end;

class function TStringHelper.CompareOrdinal(const StrA: string; IndexA: NInt; const StrB: string; IndexB: NInt; Length: NInt): NInt;
begin
  Result := System.SysUtils.StrLComp(PChar(StrA) + IndexA, PChar(StrB) + IndexB, Length);
end;

class function TStringHelper.CompareText(const StrA: string; const StrB: string): NInt;
begin
  if PChar(StrA) = PChar(StrB) then Exit(0);
  Result := System.SysUtils.CompareText(StrA, StrB);
end;

class function TStringHelper.Parse(const Value: Integer): string;
begin
  Result := IntToStr(Value);
end;

class function TStringHelper.Parse(const Value: Int64): string;
begin
  Result := IntToStr(Value);
end;

class function TStringHelper.Parse(const Value: Boolean): string;
begin
  Result := BoolToStr(Value);
end;

class function TStringHelper.Parse(const Value: Extended): string;
begin
  Result := FloatToStr(Value);
end;

class function TStringHelper.ToBoolean(const S: string): Boolean;
begin
  Result := StrToBool(S);
end;

class function TStringHelper.ToInteger(const S: string): Integer;
begin
  Result := Integer.Parse(S);
end;

class function TStringHelper.ToInt64(const S: string): Int64;
begin
  Result := Int64.Parse(S);
end;

class function TStringHelper.ToSingle(const S: string): Single;
begin
  Result := Single.Parse(S);
end;

class function TStringHelper.ToDouble(const S: string): Double;
begin
  Result := Double.Parse(S);
end;

class function TStringHelper.ToExtended(const S: string): Extended;
begin
  Result := Extended.Parse(S);
end;

class function TStringHelper.LowerCase(const S: string): string;
begin
  Result := System.SysUtils.LowerCase(S);
end;

class function TStringHelper.LowerCase(const S: string; LocaleOptions: TLocaleOptions): string;
begin
  Result := System.SysUtils.LowerCase(S, LocaleOptions);
end;

class function TStringHelper.UpperCase(const S: string): string;
begin
  Result := System.SysUtils.UpperCase(S);
end;

class function TStringHelper.UpperCase(const S: string; LocaleOptions: TLocaleOptions): string;
begin
  Result := System.SysUtils.UpperCase(S, LocaleOptions);
end;

class function TStringHelper.StartsText(const ASubText, AText: string): Boolean;
begin
  Result := _StringWrapper.StartsText(ASubText, AText);
end;

class function TStringHelper.EndsText(const ASubText, AText: string): Boolean;
begin
  Result := _StringWrapper.EndsText(ASubText, AText);
end;

class function TStringHelper.Equals(const StrA: string; const StrB: string): Boolean;
begin
  Result := StrA = StrB;
end;

class function TStringHelper.IsNullOrEmpty(const Value: string): Boolean;
begin
  Result := Value = Empty;
end;

class function TStringHelper.IsNullOrWhiteSpace(const Value: string): Boolean;
begin
  Result := Value.Trim.Length = 0;
end;
{$ENDREGION}

{$REGION 'Delphi Built-in instance methods'}
procedure TStringHelper.CopyTo(SourceIndex: NInt; var destination: array of Char; DestinationIndex: NInt; Count: NInt);
begin
  Move((PChar(Self) + SourceIndex)^, Destination[DestinationIndex], Count * SizeOf(Char));
end;

function TStringHelper.IsEmpty: Boolean;
begin
  Result := Self = Empty;
end;

function TStringHelper.GetHashCode: NInt;
begin
  Result := _StringWrapper(Self).GetHashCode;
end;

function TStringHelper.CompareTo(const strB: string): NInt;
begin
  Result := System.SysUtils.StrComp(PChar(Self), PChar(strB));
end;

function TStringHelper.Equals(const Value: string): Boolean;
begin
  Result := Self = Value;
end;

function TStringHelper.Contains(const Value: string): Boolean;
begin
  Result := System.Pos(Value, Self) > 0;
end;

function TStringHelper.StartsWith(const Value: string): Boolean;
begin
  Result := StartsWith(Value, False);
end;

function TStringHelper.StartsWith(const Value: string; IgnoreCase: Boolean): Boolean;
begin
  if Value = ''
    then Result := True
  else if Value.Length > Length
    then Result := False
  else if IgnoreCase
    then Result := AnsiStrLIComp(PChar(Value), PChar(Self), Value.Length) = 0
    else Result := CompareMem(PChar(Value), PChar(Self), Value.Length * CharSize);
end;

function TStringHelper.EndsWith(const Value: string): Boolean;
begin
  Result := EndsWith(Value, False);
end;

function TStringHelper.EndsWith(const Value: string; IgnoreCase: Boolean): Boolean;
begin
  if Value = ''
    then Result := True
  else if Value.Length > Length
    then Result := False
  else begin
    var i := Length - Value.Length;
    if IgnoreCase
      then Result := AnsiStrLIComp(PChar(Value), PChar(Self) + i, Value.Length) = 0
      else Result := CompareMem(PChar(Value), PChar(Self) + i, Value.Length * CharSize);
  end;
end;

function TStringHelper.IndexOf(value: Char): NInt;           // In SysUtils it calls pos()......
begin
  Result := ez.WideIndexOfChar(Value, PChar(self), Self.Length);
end;

function TStringHelper.IndexOf(Value: Char; StartIndex: NInt): NInt;      // In SysUtils it calls pos()......
begin
  StartIndex.SetToLarger(0);
  if StartIndex >= Length then Exit(-1);
  Result := ez.WideIndexOfChar(Value, AsPChar + StartIndex, Length - StartIndex);
  if Result >= 0 then inc(Result, StartIndex);
end;

function TStringHelper.IndexOf(Value: Char; StartIndex: NInt; Count: NInt): NInt;
begin
  StartIndex.SetToLarger(0);
  if StartIndex >= Length then Exit(-1);
  Result := ez.WideIndexOfChar(Value, AsPChar + StartIndex, ez.Min(Count, Length - StartIndex));
  if Result >= 0 then inc(Result, StartIndex);
end;

function TStringHelper.IndexOf(const Value: string): NInt;
begin
  Result := System.Pos(Value, Self) - 1;
end;

function TStringHelper.IndexOf(const Value: string; StartIndex: NInt): NInt;
begin
  Result := System.Pos(Value, Self, StartIndex + 1) - 1;
end;

function TStringHelper.IndexOf(const Value: string; StartIndex: NInt; Count: NInt): NInt;
begin
  Result := System.Pos(Value, Self, StartIndex + 1) - 1;
  if (Result + Value.Length) > (StartIndex + Count) then
    Result := -1;
end;

function TStringHelper.LastIndexOf(Value: Char): NInt;
begin
  Result := _StringWrapper(Self).LastIndexOf(Value, Self.Length - 1, Self.Length);
end;

function TStringHelper.LastIndexOf(const Value: string): NInt;
begin
  Result := _StringWrapper(Self).LastIndexOf(Value, Self.Length - 1, Self.Length);
end;

function TStringHelper.LastIndexOf(Value: Char; StartIndex: NInt): NInt;
begin
  Result := _StringWrapper(Self).LastIndexOf(Value, StartIndex, StartIndex + 1);
end;

function TStringHelper.LastIndexOf(const Value: string; StartIndex: NInt): NInt;
begin
  Result := _StringWrapper(Self).LastIndexOf(Value, StartIndex, StartIndex + 1);
end;

function TStringHelper.LastIndexOf(Value: Char; StartIndex: NInt; Count: NInt): NInt;
begin
  Result := _StringWrapper(Self).LastIndexOf(Value, StartIndex, Count);
end;

function TStringHelper.LastIndexOf(const Value: string; StartIndex: NInt; Count: NInt): NInt;
begin
  Result := _StringWrapper(Self).LastIndexOf(Value, StartIndex, Count);
end;

function TStringHelper.IndexOfAny(const AnyOf: array of Char): NInt;
begin
  Result := _StringWrapper(Self).IndexOfAny(AnyOf, 0, Length);
end;

function TStringHelper.IndexOfAny(const AnyOf: array of Char; StartIndex: NInt): NInt;
begin
  Result := _StringWrapper(Self).IndexOfAny(AnyOf, StartIndex, Length);
end;

function TStringHelper.IndexOfAny(const AnyOf: array of Char; StartIndex: NInt; Count: NInt): NInt;
begin
  Result := _StringWrapper(Self).IndexOfAny(AnyOf, StartIndex, Count);
end;

function TStringHelper.IndexOfAnyUnquoted(const AnyOf: array of Char; StartQuote, EndQuote: Char): NInt;
begin
  Result := _StringWrapper(Self).IndexOfAnyUnquoted(AnyOf, StartQuote, EndQuote, 0, Length);
end;

function TStringHelper.IndexOfAnyUnquoted(const AnyOf: array of Char; StartQuote, EndQuote: Char; StartIndex: NInt): NInt;
begin
  Result := _StringWrapper(Self).IndexOfAnyUnquoted(AnyOf, StartQuote, EndQuote, StartIndex, Length);
end;

function TStringHelper.IndexOfAnyUnquoted(const AnyOf: array of Char; StartQuote, EndQuote: Char; StartIndex: NInt; Count: NInt): NInt;
begin
  Result := _StringWrapper(Self).IndexOfAnyUnquoted(AnyOf, StartQuote, EndQuote, StartIndex, Count);
end;

function TStringHelper.LastIndexOfAny(const AnyOf: array of Char): NInt;
begin
  Result := _StringWrapper(Self).LastIndexOfAny(AnyOf, Length - 1, Length);
end;

function TStringHelper.LastIndexOfAny(const AnyOf: array of Char; StartIndex: NInt): NInt;
begin
  Result := _StringWrapper(Self).LastIndexOfAny(AnyOf, StartIndex, Length);
end;

function TStringHelper.LastIndexOfAny(const AnyOf: array of Char; StartIndex: NInt; Count: NInt): NInt;
begin
  Result := _StringWrapper(Self).LastIndexOfAny(AnyOf, StartIndex, Count);
end;

function TStringHelper.PadLeft(TotalWidth: NInt): string;
begin
  Result := PadLeft(TotalWidth, ' ');
end;

function TStringHelper.PadLeft(TotalWidth: NInt; PaddingChar: Char): string;
begin
  TotalWidth := TotalWidth - Length;
  if TotalWidth > 0 then
    Result := System.StringOfChar(PaddingChar, TotalWidth) + Self
  else
    Result := Self;
end;

function TStringHelper.PadRight(TotalWidth: NInt): string;
begin
  Result := PadRight(TotalWidth, ' ');
end;

function TStringHelper.PadRight(TotalWidth: NInt; PaddingChar: Char): string;
begin
  TotalWidth := TotalWidth - Length;
  if TotalWidth > 0 then
    Result := Self + System.StringOfChar(PaddingChar, TotalWidth)
  else
    Result := Self;
end;

function TStringHelper.Trim: string;
begin
  Result := System.SysUtils.Trim(Self);
end;

function TStringHelper.TrimLeft: string;
begin
  Result := System.SysUtils.TrimLeft(Self);
end;

function TStringHelper.TrimRight: string;
begin
  Result := System.SysUtils.TrimRight(Self);
end;

function TStringHelper.Trim(const TrimChars: array of Char): string;
begin
  Result := _StringWrapper(Self).Trim(TrimChars);
end;

function TStringHelper.TrimLeft(const TrimChars: array of Char): string;
begin
  Result := _StringWrapper(Self).TrimLeft(TrimChars);
end;

function TStringHelper.TrimRight(const TrimChars: array of Char): string;
begin
  Result := _StringWrapper(Self).TrimRight(TrimChars);
end;

function TStringHelper.TrimStart(const TrimChars: array of Char): string;
begin
  Result := _StringWrapper(Self).TrimLeft(TrimChars);
end;

function TStringHelper.TrimEnd(const TrimChars: array of Char): string;
begin
  Result := _StringWrapper(Self).TrimRight(TrimChars);
end;

function TStringHelper.Insert(StartIndex: NInt; const Value: string): string;
begin
  System.Insert(Value, Self, StartIndex + 1);
  Result := Self;
end;

function TStringHelper.Remove(StartIndex: NInt): string;
begin
  Result := Self;
  System.Delete(Result, StartIndex + 1, Result.Length);
end;

function TStringHelper.Remove(StartIndex: NInt; Count: NInt): string;
begin
  Result := Self;
  System.Delete(Result, StartIndex + 1, Count);
end;

function TStringHelper.Substring(StartIndex: NInt): string;
begin
  Result := System.Copy(Self, StartIndex + 1, Self.Length);
end;

function TStringHelper.Substring(StartIndex, Length: NInt): string;
begin
  Result := System.Copy(Self, StartIndex + 1, Length);
end;

function TStringHelper.IsDelimiter(const Delimiters: string; Index: NInt): Boolean;
begin
  Result := System.SysUtils.IsDelimiter(Delimiters, Self, Index);
end;

function TStringHelper.CountChar(const C: Char): NInt;
begin
  if Self = ''
    then Result := 0
    else Result := ez.CountOfWord(PFirst^, Length, UInt16(C));
end;

function TStringHelper.LastDelimiter(const Delims: string): NInt;
begin
  Result := System.SysUtils.LastDelimiter(Delims, Self);
  if Result > 0 then Dec(Result);
end;

function TStringHelper.LastDelimiter(const Delims: TSysCharSet): NInt;
begin
  Result := _StringWrapper(Self).LastDelimiter(Delims);
end;

function TStringHelper.Replace(OldChar, NewChar: Char): string;
begin
  Result := System.SysUtils.StringReplace(Self, OldChar, NewChar, [rfReplaceAll]);
end;

function TStringHelper.Replace(OldChar: Char; NewChar: Char; ReplaceFlags: TReplaceFlags): string;
begin
  Result := System.SysUtils.StringReplace(Self, OldChar, NewChar, ReplaceFlags);
end;

function TStringHelper.Replace(const OldValue, NewValue: string): string;
begin
  Result := System.SysUtils.StringReplace(Self, OldValue, NewValue, [rfReplaceAll]);
end;

function TStringHelper.Replace(const OldValue, NewValue: string; ReplaceFlags: TReplaceFlags): string;
begin
  Result := System.SysUtils.StringReplace(Self, OldValue, NewValue, ReplaceFlags);
end;

function TStringHelper.DeQuotedString: string;
begin
  Result := _StringWrapper(Self).DeQuotedString('''');
end;

function TStringHelper.DeQuotedString(const QuoteChar: Char): string;
begin
  Result := _StringWrapper(Self).DeQuotedString(QuoteChar);
end;

function TStringHelper.QuotedString: string;
begin
  Result := _StringWrapper(Self).QuotedString('''');
end;

function TStringHelper.QuotedString(const QuoteChar: Char): string;
begin
  Result := _StringWrapper(Self).QuotedString(QuoteChar);
end;

function TStringHelper.Split(const Separator: array of Char): TArray<string>;
begin
  Result := _StringWrapper(Self).Split(Separator, MaxInt, TStringSplitOptions.None);
end;

function TStringHelper.Split(const Separator: array of Char; Count: NInt): TArray<string>;
begin
  Result := _StringWrapper(Self).Split(Separator, Count, TStringSplitOptions.None);
end;

function TStringHelper.Split(const Separator: array of Char; Options: TStringSplitOptions): TArray<string>;
begin
  Result := _StringWrapper(Self).Split(Separator, MaxInt, Options);
end;

function TStringHelper.Split(const Separator: array of Char; Count: NInt; Options: TStringSplitOptions): TArray<string>;
begin
  Result := _StringWrapper(Self).Split(Separator, Count, Options);
end;

function TStringHelper.Split(const Separator: array of string): TArray<string>;
begin
  Result := _StringWrapper(Self).Split(Separator, MaxInt, TStringSplitOptions.None);
end;

function TStringHelper.Split(const Separator: array of string; Count: NInt): TArray<string>;
begin
  Result := _StringWrapper(Self).Split(Separator, Count, TStringSplitOptions.None);
end;

function TStringHelper.Split(const Separator: array of string; Options: TStringSplitOptions): TArray<string>;
begin
  Result := _StringWrapper(Self).Split(Separator, MaxInt, Options);
end;

function TStringHelper.Split(const Separator: array of string; Count: NInt; Options: TStringSplitOptions): TArray<string>;
begin
  Result := _StringWrapper(Self).Split(Separator, Count, Options);
end;

function TStringHelper.Split(const Separator: array of Char; Quote: Char): TArray<string>;
begin
  Result :=_StringWrapper(Self).Split(Separator, Quote, Quote, MaxInt, TStringSplitOptions.None);
end;

function TStringHelper.Split(const Separator: array of Char; QuoteStart, QuoteEnd: Char): TArray<string>;
begin
  Result :=_StringWrapper(Self).Split(Separator, QuoteStart, QuoteEnd, MaxInt, TStringSplitOptions.None);
end;

function TStringHelper.Split(const Separator: array of Char; QuoteStart, QuoteEnd: Char; Options: TStringSplitOptions): TArray<string>;
begin
  Result :=_StringWrapper(Self).Split(Separator, QuoteStart, QuoteEnd, MaxInt, Options);
end;

function TStringHelper.Split(const Separator: array of Char; QuoteStart, QuoteEnd: Char; Count: NInt): TArray<string>;
begin
  Result :=_StringWrapper(Self).Split(Separator, QuoteStart, QuoteEnd, Count, TStringSplitOptions.None);
end;

function TStringHelper.Split(const Separator: array of Char; QuoteStart, QuoteEnd: Char; Count: NInt; Options: TStringSplitOptions): TArray<string>;
begin
  Result :=_StringWrapper(Self).Split(Separator, QuoteStart, QuoteEnd, Count, Options);
end;

function TStringHelper.Split(const Separator: array of string; Quote: Char): TArray<string>;
begin
  Result :=_StringWrapper(Self).Split(Separator, Quote, Quote, MaxInt, TStringSplitOptions.None);
end;

function TStringHelper.Split(const Separator: array of string; QuoteStart, QuoteEnd: Char): TArray<string>;
begin
  Result :=_StringWrapper(Self).Split(Separator, QuoteStart, QuoteEnd, MaxInt, TStringSplitOptions.None);
end;

function TStringHelper.Split(const Separator: array of string; QuoteStart, QuoteEnd: Char; Options: TStringSplitOptions): TArray<string>;
begin
  Result :=_StringWrapper(Self).Split(Separator, QuoteStart, QuoteEnd, MaxInt, Options);
end;

function TStringHelper.Split(const Separator: array of string; QuoteStart, QuoteEnd: Char; Count: NInt): TArray<string>;
begin
  Result :=_StringWrapper(Self).Split(Separator, QuoteStart, QuoteEnd, Count, TStringSplitOptions.None);
end;

function TStringHelper.Split(const Separator: array of string; QuoteStart, QuoteEnd: Char; Count: NInt; Options: TStringSplitOptions): TArray<string>;
begin
  Result :=_StringWrapper(Self).Split(Separator, QuoteStart, QuoteEnd, Count, Options);
end;

function TStringHelper.ToBoolean: Boolean;
begin
  Result := StrToBool(Self);
end;

function TStringHelper.ToInteger: Int32;
begin
  Result := Integer.Parse(Self);
end;

function TStringHelper.ToInt64: Int64;
begin
  Result := Int64.Parse(Self);
end;

function TStringHelper.ToSingle: Single;
begin
  Result := Single.Parse(Self);
end;

function TStringHelper.ToDouble: Double;
begin
  Result := Double.Parse(Self);
end;

function TStringHelper.ToExtended: Extended;
begin
  Result := Extended.Parse(Self);
end;

function TStringHelper.ToCharArray: TArray<Char>;
begin
  Result := ToCharArray(0, Self.Length);
end;

function TStringHelper.ToCharArray(StartIndex, Length: NInt): TArray<Char>;
begin
  SetLength(Result, Length);
  Move((PChar(Self) + StartIndex)^, Result[0], Length * SizeOf(Char));
end;

function TStringHelper.ToLower: string;
begin
  Result := _StringWrapper(Self).ToLower(SysLocale.DefaultLCID);
end;

function TStringHelper.ToLower(LocaleID: TLocaleID): string;
begin
  Result := _StringWrapper(Self).ToLower(LocaleID);
end;

function TStringHelper.ToLowerInvariant: string;
begin
  Result := _StringWrapper(Self).ToLowerInvariant;
end;

function TStringHelper.ToUpper: string;
begin
  Result := _StringWrapper(Self).ToUpper(SysLocale.DefaultLCID);
end;

function TStringHelper.ToUpper(LocaleID: TLocaleID): string;
begin
  Result := _StringWrapper(Self).ToUpper(LocaleID);
end;

function TStringHelper.ToUpperInvariant: string;
begin
  Result := _StringWrapper(Self).ToUpperInvariant;
end;
{$ENDREGION}

{$REGION 'My Class functions'}
class function TStringHelper.Create(p: pChar; Len: NInt): string;
begin
  SetString(Result, p, ez.Max(0, Len));
end;

class function TStringHelper.CreateFromNullString(p: pChar; MaxLen: NInt): string;
var
  p0, pe: pChar;
begin
  if MaxLen <= 0 then Exit('');
  p0 := p;
  pe := p + MaxLen;
  while (p0 < pe) and (p0^ <> #0) do
    inc(p0);
  SetString(Result, p, p0 - p);
end;

class function TStringHelper.FromVarRec(const VarRec: tVarRec; var s: string): boolean;
begin
  Result := true;
  case VarRec.VType of
    vtChar:          s :=  Char    (VarRec.VChar);
    vtPChar:         s :=  Char    (VarRec.VPChar^);
    vtWideChar:      s :=  Char    (VarRec.VWideChar);
    vtPWideChar:     s :=  Char    (VarRec.VPWideChar^);
    vtString:        s :=  string  (VarRec.VString^);
    vtAnsiString:    s :=  string  (pAnsiChar(VarRec.VAnsiString));
    vtWideString:    s :=  pWideChar(VarRec.VWideString);
    vtUnicodeString: s :=  pWideChar(VarRec.VUnicodeString);
    else Result := False;
  end;
end;

{$WARN IMMUTABLE_STRINGS OFF}
class function TStringHelper.TryGetAnsiText(p: Pointer; l: NUInt; var s: string): Boolean;
var
  s1, s2: AnsiString;
begin
  if l = 0 then Exit(False);
  SetLength(s1, l);
  Move(p^, s1[1], l);
  s := string(s1);
  s2 := AnsiString(s);
  Result := s1 = s2;
end;

class function TStringHelper.TryGetUTF8Text(p: Pointer; l: NUInt; var s: string): Boolean;
var
  UTF8, UTF8b: UTF8String;
begin
  if l = 0 then Exit(False);
  SetLength(UTF8, l);
  Move(p^, UTF8[1], l);
  s := string(UTF8);
  UTF8b := UTF8String(s);
  Result := UTF8 = UTF8b;
end;

class function TStringHelper.TryGetUnicodeText(p: Pointer; l: NUInt; var s: string): Boolean;
var
  t: string;
  UTF8: UTF8String;
begin
  if (l = 0) or (l mod 2 = 1) then Exit(False);
  SetLength(s, l div 2);
  Move(p^, s[1], l);
  UTF8 := UTF8String(s);
  t := string(UTF8);
  Result := s = t;
end;
{$WARN IMMUTABLE_STRINGS ON}

class function TStringHelper.Join(const Values: array of string): string;
begin
  Result := Join(LineReturn, Values);
end;

class function TStringHelper.CompareStr(const StrA, StrB: string): NInt;
begin
  Result := SysUtils.CompareStr(StrA, StrB);
end;

class function TStringHelper.CompareStr(const StrA, StrB: string; Locale: TLocaleOptions): NInt;
begin
  Result := SysUtils.CompareStr(StrA, StrB, Locale);
end;

class function TStringHelper.CompareText(const StrA, StrB: string; Locale: TLocaleOptions): NInt;
begin
  if PChar(StrA) = PChar(StrB) then Exit(0);
  Result := SysUtils.CompareText(StrA, StrB, Locale);
end;

class function TStringHelper.TextEquals(const StrA, StrB: string): Boolean;
begin
  Result := (StrA.Length = StrB.Length) and (CompareText(StrA, StrB) = 0);
end;


class function TStringHelper.CombineTestLeft(const S1, ConditionalSeparator, S2: string): string;
begin
  if S1 = '' then Result := S2 else Result := S1 + ConditionalSeparator + S2;
end;

class function TStringHelper.CombineTestRight(const S1, ConditionalSeparator, S2: string): string;
begin
  if S2 = '' then Result := S1 else Result := S1 + ConditionalSeparator + S2;
end;

class function TStringHelper.CombineTestBoth(const S1, ConditionalSeparator, S2: string): string;
begin
  if S1 = ''
    then Result := S2
    else if S2 = ''
      then Result := S1
      else Result := S1 + ConditionalSeparator + S2;
end;

class function TStringHelper.CombineTestLeft(const S1: string; cSeparator: Char; const S2: string): string;
begin
  if S1 = '' then Result := S2 else Result := S1 + cSeparator + S2;
end;

class function TStringHelper.CombineTestRight(const S1: string; cSeparator: Char; const S2: string): string;
begin
  if S2 = '' then Result := S1 else Result := S1 + cSeparator + S2;
end;

class function TStringHelper.CombineTestBoth(const S1: string; cSeparator: Char; const S2: string): string;
begin
  if S1 = ''
    then Result := S2
    else if S2 = ''
      then Result := S1
      else Result := S1 + cSeparator + S2;
end;

class function TStringHelper.IsNaturalNumber(p: pChar): Boolean;
begin
  Result := (p <> nil) and (p^ >= '0') and (p^ <= '9');
  while Result do
  begin
    inc(p);
    if p^ = #0 then Exit;
    Result := (p^ >= '0') and (p^ <= '9');
  end;
end;

class function TStringHelper.IsCharRepeated(p: pChar; Sep: Char; Interval, Count: NInt): Boolean;
var
  i: NInt;
begin
  for i := 1 to Count do
  begin
    if p^ <> Sep then Exit(False);
    inc(p, Interval);
  end;
  Result := True;
end;
{$ENDREGION}

{$REGION 'My functions - Char/Boolean functions'}
function TStringHelper.FirstChar: Char;
begin
  if IsEmpty
    then Result := #0
    else Result := Chars[0];
end;

function TStringHelper.LastChar: Char;
begin
  if IsEmpty
    then Result := #0
    else Result := Chars[Length - 1];
end;

function TStringHelper.NotEmpty: Boolean;
begin
  Result := not IsEmpty;
end;

function TStringHelper.HasChar(Ch: Char): Boolean;
begin
  Result := IndexOf(Ch) >= 0;
end;

function TStringHelper.HasChars(const CharSet: string): Boolean;
var
  c: Char;
begin
  for c in CharSet do
    if HasChar(c) then Exit(True);
  Exit(False);
end;

function TStringHelper.HasChars(const CharSet: TSysCharSet): Boolean;
var
  p, pE: pChar;
begin
  if Self = '' then Exit(False);
  p := pFirst;
  pE := pLast;
  while p <= pE do
  begin
    if (p^ < #$80) and CharInSet(AnsiChar(p^), Charset)
      then Exit(True);
    inc(p);
  end;
  Exit(False);
end;

function TStringHelper.IsASCII: Boolean;
var
  i: NInt;
begin
  for i := 1 to Length do
    if Self[i] >= #$80 then Exit(False);
  Result := True;
end;

function TStringHelper.IsASCIILatin: Boolean;
var
  i: NInt;
begin
  for i := 1 to Length do
    if not ((Self[i] < #$80) or
            ((Self[i] >= #$0100) and (Self[i] <= #$024F)) or      // $0100 - $017F, 0180-024F
            ((Self[i] >= #$1E00) and (Self[i] <= #$1EFF)) or      // $1E00 - $1EFF
            ((Self[i] >= #$2C60) and (Self[i] <= #$2C7F)) or      // $2C60 - $2C7F
            ((Self[i] >= #$A720) and (Self[i] <= #$A7FF)) or      // $A720 - $A7FF
            ((Self[i] >= #$AB30) and (Self[i] <= #$AB6F)))        // $AB30 - $AB6F
      then Exit(False);
  Result := True;
end;

function TStringHelper.IsSingleUncodeChar: boolean;
begin
  Result := ((Length = 1) and not Chars[0].IsHighSurrogate) or
            ((Length = 2) and Chars[0].IsHighSurrogate and Chars[1].IsLowSurrogate);
end;

function TStringHelper.IsInteger: Boolean;
begin
  var i: Int64;
  Result := Int64.TryParse(Self, i);
end;

function TStringHelper.IsDecimalInteger: Boolean;
begin
  if IsEmpty then Exit(False);
  if Chars[0] = '-'
    then Result := (Length > 1) and IsNaturalNumber(PChar(Self) + 1)
    else Result := IsNaturalNumber(PChar(Self));
end;

function TStringHelper.IsNaturalNumber: Boolean;
begin
  Result := IsNaturalNumber(PChar(Self));
end;

function TStringHelper.IsHexadecimal: Boolean;
begin
  if IsEmpty then Exit(False);
  for var i := 0 to Length - 1 do
    if not Chars[i].IsHexDigitA then Exit(False);
  Result := True;
end;

function TStringHelper.IsStringAt(const Value: string; Pos: NInt): Boolean;
begin
  var l := Value.Length;
  if l = 0 then Exit(False);
  if l + Pos > Length then Exit(False);
  Result := CompareMem(PFirst + Pos, PChar(Value), l);
end;

function TStringHelper.IsTextAt(const Value: string; Pos: NInt): Boolean;
begin
  var l := Value.Length;
  if l = 0 then  Exit(False);
  if l + Pos > Length then Exit(False);
  Result := StrLIComp(PFirst + Pos, PChar(Value), l) = 0;
end;

function TStringHelper.Equals(const S: string; IgnoreCase: Boolean): Boolean;
begin
  if IgnoreCase
    then Result := CompareText(Self, S) = 0
    else Result := Self = S;
end;

function TStringHelper.TextEquals(const S: string): Boolean;
begin
  Result := CompareText(Self, S) = 0;
end;

function TStringHelper.Contains(const S: string; IgnoreCase: Boolean): Boolean;
begin
  if IgnoreCase
    then Result := ContainsText(S)
    else Result := Contains(S);
end;

function TStringHelper.ContainsText(const S: string): Boolean;
begin
  Result := Self.IndexOfText(S) >= 0;
end;

function TStringHelper.StartsText(const S: string): Boolean;
begin
  Result := StartsText(S, Self);
end;

function TStringHelper.EndsText(const S: string): Boolean;
begin
  Result := EndsText(S, Self);
end;
{$ENDREGION}

{$REGION 'My Functions - Int functions'}
function TStringHelper.CountChars(const CharSet: string): NInt;
var
  i: NInt;
begin
  Result := 0;
  for i := 0 to Length - 1 do
    if CharSet.HasChar(Chars[i]) then inc(Result);    // This works even it Chars contains duplicated chars
end;

function TStringHelper.IndexOf(const Value: string; IgnoreCase: Boolean; StartIndex: NInt = 0): NInt;
begin
  if IgnoreCase
    then Result := IndexOfText(Value, StartIndex)
    else Result := IndexOf(Value, StartIndex);
end;

function TStringHelper.IndexOfAny(const Values: array of string; var Index: NInt; StartIndex: NInt): NInt;
var
  C, P, IoA: NInt;
begin
  IoA := -1;
  for C := 0 to High(Values) do
  begin
    P := IndexOf(Values[C], StartIndex);
    if (P >= 0) and((P < IoA) or (IoA = -1)) then
    begin
      IoA := P;
      Index := C;
    end;
  end;
  Result := IoA;
end;

function TStringHelper.IndexOfWord(const Value: string; StartIndex: NInt; MustStartWord, MustEndWord: Boolean): NInt;
var
  l, l2: NInt;
begin
  if (Value = '') or IsEmpty then Exit(-1);
  if not (MustEndWord or MustStartWord) then Exit(IndexOf(Value, StartIndex));

  l2 := Value.Length;
  l  := Length - l2;    // Last possible
  Result := StartIndex;
  repeat
     Result := IndexOf(Value, Result);
     if Result < 0 then exit;
     if MustStartWord then
       if (Result = 0) or not Chars[Result - 1].IsLetterOrDigitA then Exit;
     if MustEndWord then
       if (Result = l) and Chars[Result + l2].IsLetterOrDigitA then Exit;
     inc(Result);
  until False;
end;

function TStringHelper.IndexOfText(const Value: string; StartIndex: NInt): NInt;
var
  c, cL: Char;
  p0, p: pChar;
begin
  if Value = '' then Exit(-1);
  if StartIndex < 0 then StartIndex := 0;
  if StartIndex >= Length then Exit(-1);

  p0 := AsPChar + (Length - Value.Length);
  p  := AsPChar + StartIndex;
  c  := Value.Chars[0].ToUpper;
  cL := c.ToLower;
  if c = cL then
  begin
    while (p <= p0) do
      if (p^ = c) and ez.WideCompareMemText(p, PChar(Value), Value.Length)
        then Exit(p - AsPChar)
        else Inc(p);
  end else
  begin
    while (p <= p0) do
      if ((p^ = c) or (p^ = cL)) and ez.WideCompareMemText(p, PChar(Value), Value.Length)
        then Exit(p - AsPChar)
        else Inc(p);
  end;
  Result := -1;
end;

function TStringHelper.LastIndexOfText(const Value: string): NInt;
begin
  Result := LastIndexOfText(Value, Length - 1);
end;

function TStringHelper.LastIndexOfText(const Value: string; StartIndex: NInt): NInt;
var
  c, cL: Char;
  p0, p: pChar;
begin
  if Value = '' then Exit(-1);
  if StartIndex >= Length then StartIndex := Length - 1;
  if StartIndex < 0 then Exit(-1);

  p0 := AsPChar;
  p  := p0 + (StartIndex - Value.Length + 1);
  c  := Value.Chars[0].ToUpper;
  cL := c.ToLower;
  if c = cL then
  begin
    while (p >= p0) do
      if (p^ = c) and ez.WideCompareMemText(p, PChar(Value), Value.Length)
        then Exit(p - AsPChar)
        else dec(p);
  end else
  begin
    while (p >= p0) do
      if ((p^ = c) or (p^ = cL)) and ez.WideCompareMemText(p, PChar(Value), Value.Length)
        then Exit(p - AsPChar)
        else dec(p);
  end;
  Result := -1;
end;

function TStringHelper.CompareTextTo(const S: string): NInt;
begin
  Result := CompareText(Self, S);
end;

function TStringHelper.CompareTo(const S: string; IgnoreCase: Boolean): NInt;
begin
  if IgnoreCase
    then Result := CompareTextTo(S)
    else Result := CompareTo(S);
end;
{$ENDREGION}

{$REGION 'My Functions - Substrings'}
function TStringHelper.Left(MaxLen: NInt): string;
begin
  Result := Substring(0, MaxLen);
end;

function TStringHelper.Right(MaxLen: NInt): string;
begin
  Result := Substring(ez.Max(0, Length - MaxLen), MaxLen);
end;

function TStringHelper.Between(Start, ExclusiveEnd: NInt): string;
begin
  if Start < 0 then Start := 0;
  Result := Substring(Start, ExclusiveEnd - Start);
end;

function TStringHelper.ExcludeLeft(ExcludeLen: NInt): string;
begin
  Result := Substring(ExcludeLen, Length);
end;

function TStringHelper.ExcludeRight(ExcludeLen: NInt): string;
begin
  Result := Substring(0, Length - ExcludeLen);
end;

function TStringHelper.ExcludeBoth(ExcludeLeft, ExcludeRight: NInt): string;
begin
  Result := Substring(ExcludeLeft, Length - ExcludeLeft - ExcludeRight);
end;

function TStringHelper.LeftOf(const S: string; StartIndex: NInt = 0): string;
var
  i: NInt;
begin
  i := IndexOf(s, StartIndex);
  if i >= 0
    then Result := SubString(StartIndex, i - StartIndex)
    else Result := SubString(StartIndex, Length);
end;

function TStringHelper.LeftOfText(const S: string; StartIndex: NInt = 0): string;
var
  i: NInt;
begin
  i := IndexOfText(s, StartIndex);
  if i >= 0
    then Result := SubString(StartIndex, i - StartIndex)
    else Result := SubString(StartIndex, Length);
end;

function TStringHelper.LazyLeftOf(const S: string; StartIndex: NInt = 0): string;
var
  i: NInt;
begin
  i := IndexOf(s, StartIndex);
  if i >= 0
    then Result := SubString(StartIndex, i - StartIndex)
    else Result := '';
end;

function TStringHelper.LazyLeftOfText(const S: string; StartIndex: NInt = 0): string;
var
  i: NInt;
begin
  i := IndexOfText(s, StartIndex);
  if i >= 0
    then Result := SubString(StartIndex, i - StartIndex)
    else Result := '';
end;

function TStringHelper.RightOf(const S: string; StartIndex: NInt = 0): string;
var
  i: NInt;
begin
  i := IndexOf(s, StartIndex);
  if i >= 0
    then Result := SubString(StartIndex + S.Length, Length)
    else Result := SubString(StartIndex, Length);
end;

function TStringHelper.RightOfText(const S: string; StartIndex: NInt = 0): string;
var
  i: NInt;
begin
  i := IndexOfText(s, StartIndex);
  if i >= 0
    then Result := SubString(StartIndex + S.Length, Length)
    else Result := SubString(StartIndex, Length);
end;

function TStringHelper.LazyRightOf(const S: string; StartIndex: NInt = 0): string;
var
  i: NInt;
begin
  i := IndexOf(s, StartIndex);
  if i >= 0
    then Result := SubString(StartIndex + s.Length, Length)
    else Result := '';
end;

function TStringHelper.LazyRightOfText(const S: string; StartIndex: NInt = 0): string;
var
  i: NInt;
begin
  i := IndexOfText(s, StartIndex);
  if i >= 0
    then Result := SubString(StartIndex + s.Length, Length)
    else Result := '';
end;

function TStringHelper.Between(const L, R: string; StartIndex: NInt = 0): string;
var
  i, j: NInt;
begin
  i := IndexOf(L, StartIndex);
  if i >= 0 then
  begin
    Inc(i, L.Length);
    j := IndexOf(R, i);
    if j >= 0
      then Result := SubString(i, j - i)
      else Result := SubString(i, Length);
  end else
  begin
    j := IndexOf(R, StartIndex);
    if j >= 0
      then Result := SubString(StartIndex, j - StartIndex)
      else Result := SubString(StartIndex, Length);
  end;
end;

function TStringHelper.BetweenText(const L, R: string; StartIndex: NInt = 0): string;
var
  i, j: NInt;
begin
  i := IndexOfText(L, StartIndex);
  if i >= 0 then
  begin
    Inc(i, L.Length);
    j := IndexOfText(R, i);
    if j >= 0
      then Result := SubString(i, j - i)
      else Result := SubString(i, Length);
  end else
  begin
    j := IndexOfText(R, StartIndex);
    if j >= 0
      then Result := SubString(StartIndex, j - StartIndex)
      else Result := SubString(StartIndex, Length);
  end;
end;

function TStringHelper.LazyBetween(const L, R: string; StartIndex: NInt = 0): string;
var
  i, j: NInt;
begin
  i := IndexOf(L, StartIndex);
  if i >= 0 then
  begin
    Inc(i, L.Length);
    j := IndexOf(R, i);
    if j >= 0
      then Result := SubString(i, j - i)
      else Result := '';
  end else Result := '';
end;

function TStringHelper.LazyBetweenText(const L, R: string; StartIndex: NInt = 0): string;
var
  i, j: NInt;
begin
  i := IndexOfText(L, StartIndex);
  if i >= 0 then
  begin
    Inc(i, L.Length);
    j := IndexOfText(R, i);
    if j >= 0
      then Result := SubString(i, j - i)
      else Result := '';
  end else Result := '';
end;
{$ENDREGION}

{$REGION 'My Functions - Filename - Simple, no I/O needs'}
function TStringHelper.ExtractFilePath: string;                         // with trailling pathdelim
begin
  Result := SysUtils.ExtractFilePath(Self);
end;

function TStringHelper.ExtractFileDir: string;                          // without trailling pathdelim
begin
  Result := SysUtils.ExtractFileDir(Self);
end;

function TStringHelper.ExtractFileDrive: string;                        // returns '<drive>:' or '\\<servername>\<sharename>'
begin
  Result := SysUtils.ExtractFileDrive(Self);
end;

function TStringHelper.ExtractFileName: string;                         // returns '<Name>.<Ext>' or '<Name>'
begin
  Result := SysUtils.ExtractFileName(Self);
end;

function TStringHelper.ExtractFileExt: string;                          // returns '.<Ext>' or '';
begin
  Result := SysUtils.ExtractFileExt(Self);
end;

function TStringHelper.ExtractOnlyFileName: string;                     // returns '<Name>';
var
  i, j: NInt;
begin
  i := LastDelimiter(PathDelim + DriveDelim);
  j := LastDelimiter(ExtensionSep + PathDelim + DriveDelim);
  if (j >= 0) and (Chars[j] = ExtensionSep)
    then Result := SubString(i + 1, j - i - 1)
    else Result := SubString(i + 1, Length);
end;

function TStringHelper.ExtractOnlyFileExt: string;                      // returns '<Ext>';
var
  i: NInt;
begin
  i := LastDelimiter(ExtensionSep + PathDelim + DriveDelim);
  if (i >= 0) and (Chars[i] = ExtensionSep)
    then Result := SubString(i + 1, Length)
    else Result := '';
end;

function TStringHelper.ExtractRelativePath(const BasePath: string): string;
begin
  Result := SysUtils.ExtractRelativePath(BasePath, Self);
end;

function TStringHelper.ChangeFileExt(const Extension: string): string;  // Remove Ext and add Extension; so Extension can be any text
begin
  Result := SysUtils.ChangeFileExt(Self, Extension);
end;

function TStringHelper.ChangeFilePath(const Path: string): string;      // Path does not need to have trailling pathdelim
begin
  Result := SysUtils.ChangeFilePath(Self, Path);
end;

function TStringHelper.IncludeTrailingPathDelimiter: string;
begin
  Result := SysUtils.IncludeTrailingPathDelimiter(Self);
end;

function TStringHelper.ExcludeTrailingPathDelimiter: string;
begin
  Result := SysUtils.ExcludeTrailingPathDelimiter(Self);
end;
{$ENDREGION}

{$REGION 'My Functions - String replace'}
function TStringHelper.Replace(const OldValue, NewValue: string; IgnoreCase: Boolean; ReplaceAll: Bool = True): string;
begin
  if IgnoreCase
    then if ReplaceAll
      then Result := StringReplace(Self, OldValue, NewValue, [rfReplaceAll, rfIgnoreCase])
      else Result := StringReplace(Self, OldValue, NewValue, [rfIgnoreCase])
    else if ReplaceAll
      then Result := StringReplace(Self, OldValue, NewValue, [rfReplaceAll])
      else Result := StringReplace(Self, OldValue, NewValue, []);
end;

function TStringHelper.ReplaceText(const OldText, NewText: string): string;
begin
  Result := StringReplace(Self, OldText, NewText, [rfReplaceAll, rfIgnoreCase]);
end;

function TStringHelper.ReplaceOne(const OldText, NewText: string; StartIndex: NInt = 0): string;
var
  i: NInt;
begin
  i := IndexOf(OldText);
  if i >= 0
    then Result := SubString(0, i) + NewText + SubString(i + OldText.Length)
    else Result := Self;
end;

function TStringHelper.ReplaceOne(const OldText, NewText: string; IgnoreCase: Boolean; StartIndex: NInt = 0): string;
begin
  if IgnoreCase
    then Result := ReplaceOneText(OldText, NewText, StartIndex)
    else Result := ReplaceOne(OldText, NewText, StartIndex);
end;

function TStringHelper.ReplaceOneText(const OldText, NewText: string; StartIndex: NInt = 0): string;
var
  i: NInt;
begin
  i := IndexOfText(OldText);
  if i >= 0
    then Result := SubString(0, i) + NewText + SubString(i + OldText.Length)
    else Result := Self;
end;

function TStringHelper.RepeatReplace(const OldText, NewText: string; IgnoreCase: Boolean): string;
begin
  if IgnoreCase
    then Result := RepeatReplaceText(OldText, NewText)
    else Result := RepeatReplace(OldText, NewText);
end;

function TStringHelper.RepeatReplace(const OldText, NewText: string): string;
begin
  Result := Replace(OldText, NewText);
  if not NewText.Contains(OldText) then                 // avoid endless loop
    while Result.IndexOf(OldText) >= 0 do
      Result := Result.Replace(OldText, NewText);
end;

function TStringHelper.RepeatReplaceText(const OldText, NewText: string): string;
begin
  Result := ReplaceText(OldText, NewText);
  if not NewText.ContainsText(OldText) then             // avoid endless loop
    while Result.IndexOfText(OldText) >= 0 do
      Result := StringReplace(Result, OldText, NewText, [rfReplaceAll, rfIgnoreCase])
end;
{$ENDREGION}

{$REGION 'My Functions - String functions'}
function TStringHelper.ToTitleCase: string;
var
  pS, pT, pE: PChar;
begin
  if Self = '' then Exit('');
  pS := PChar(Self);
  pE := pS + Length;
  Setlength(Result, Length);
  pT := PChar(Result);
  if (pS^ >= 'a') and (pS^ <= 'z')
    then pT^ := Char(Ord(pS^) - $20)
    else pT^ := pS^;
  Inc(pS);  Inc(pT);
  while pS < pE do
  begin
    if (pS^ >= 'A') and (pS^ <= 'Z') and (pS - 1)^.IsLetterOrDigit
      then pT^ := Char(Ord(pS^) + $20)
      else pT^ := pS^;
    Inc(pS);  Inc(pT);
  end;
end;

function TStringHelper.ToLowerA: string;
begin
  Result := System.SysUtils.LowerCase(Self);
end;

function TStringHelper.ToUpperA: string;
begin
  Result := System.SysUtils.UpperCase(Self);
end;

function TStringHelper.RemoveFloatTrailingZeros(DecimalSeparator: char): string;
var
  p: NInt;
begin
  p := IndexOf(DecimalSeparator);
  if p >= 0 then
  begin
    p := Length - 1;
    while Chars[p] = '0' do dec(p);
    if Chars[p] = DecimalSeparator then dec(p);
    Result := Substring(0, p + 1);
  end else Result := Self;
end;

function TStringHelper.RemoveFloatTrailingZeros: string;
begin
  Result := RemoveFloatTrailingZeros('.');
end;

function TStringHelper.RemoveFloatTrailingZerosLocal: string;
begin
  Result := RemoveFloatTrailingZeros(FormatSettings.DecimalSeparator);
end;

function TStringHelper.InsertAt(StartIndex: NInt; const Value: string): string;
begin
  if StartIndex >= Length
    then Result := Self + Value
    else if StartIndex = 0
      then Result := Value + Self
      else Result := SubString(0, StartIndex) + Value + SubString(StartIndex, Length);
end;

function TStringHelper.AddPrefix(const Value: string): string;
begin
  Result := Value + Self;
end;

function TStringHelper.Append(const Value: string): string;
begin
  Result := Self + Value;
end;

{$WARN IMMUTABLE_STRINGS OFF}
function TStringHelper.AddSepatorsFromLeft(Sep: Char; GroupWidth: NInt): string;
var
  i, n: NInt;
  p1, p2: PChar;
begin
  n := (Length - 1) div GroupWidth;
  if n = 0 then Exit(Self);
  SetLength(Result, Length + n);
  p1 := PChar(Self);
  p2 := PChar(Result);
  for i := 1 to n do
  begin
    Move(p1^, p2^, GroupWidth * SizeOf(Char));
    inc(p1, GroupWidth);
    inc(p2, GroupWidth);
    p2^ := Sep;
    inc(p2);
  end;
  Move(p1^, p2^, (Length - n * GroupWidth) * SizeOf(Char));
end;

function TStringHelper.AddSepatorsFromRight(Sep: Char; GroupWidth: NInt): string;
var
  i, n: NInt;
  p1, p2: PChar;
begin
  n := (Length - 1) div GroupWidth;
  if n = 0 then Exit(Self);
  SetLength(Result, Length + n);
  p1 := PChar(Self);
  p2 := PChar(Result);
  Move(p1^, p2^, (Length - n * GroupWidth) * SizeOf(Char));
  inc(p1, (Length - n * GroupWidth));
  inc(p2, (Length - n * GroupWidth));
  for i := 1 to n do
  begin
    p2^ := Sep;
    inc(p2);
    Move(p1^, p2^, GroupWidth * SizeOf(Char));
    inc(p1, GroupWidth);
    inc(p2, GroupWidth);
  end;
end;
{$WARN IMMUTABLE_STRINGS ON}
{$ENDREGION}

{$REGION 'My Procedure'}
function TStringHelper.CopyTo(p: pChar): NInt;
begin
  if Self <> '' then
    Move(PChar(Self)^, p^, Length * CharSize);
  Result := Length;
end;

function TStringHelper.CopyTo(p: PChar; AddEndZero: Boolean): NInt;
begin
  Result := CopyTo(p);
  if AddEndZero then
  begin
    (p + Result)^ :=#0;
    inc(Result);
  end;
end;

procedure TStringHelper.CopyAndMovePointer(var p: pChar; AddEndZero: Boolean);
begin
  Inc(p, CopyTo(p, AddEndZero));
end;
{$ENDREGION}
{$ENDREGION}

{$REGION 'TMStringHelper'}
{$WARN IMMUTABLE_STRINGS OFF}

{$REGION 'Private Functions'}
{$ZEROBASEDSTRINGS ON}
function TMStringHelper.GetChars(Index: NInt): Char;
begin
  Result := Self[Index];
end;

procedure TMStringHelper.SetChars(Index: NInt; Value: Char);
begin
  Self[Index] := Value;
end;

function TMStringHelper.GetPChars(Index: NInt): PChar;
begin
   Result := @Self[Index];
end;
{$ZEROBASEDSTRINGS OFF}

function TMStringHelper.GetLength;
begin
  Result := System.Length(Self);
end;

procedure TMStringHelper.SetLength(const NewLength: NInt);
begin
  System.SetLength(Self, NewLength);
end;

function TMStringHelper.GetPointer: PChar;
begin
  Result := PChar(Self);
end;

function TMStringHelper.GetPLast: PChar;
begin
  Result := PChar(Self);
  if Result <> nil then inc(Result, Length - 1);
end;
{$ENDREGION}

{$REGION 'My Functions - Simple'}
procedure TMStringHelper.MakeUnique;
begin
  UniqueString(String(Self));
end;

procedure TMStringHelper.SetTo(p: PChar);
var
  pT: pChar;
begin
  pT := p;
  while pT^ <> #0 do
    inc(pT);
  SetTo(p, (NInt(pT) - NInt(p)) div string.CharSize);
end;

procedure TMStringHelper.SetTo(p: PChar; Len: NInt);
begin
  System.SetString(Self, P, ez.Max(0, Len));
end;

procedure TMStringHelper.Append(const s: string);
begin
  Self := Self + s;
end;

procedure TMStringHelper.AddPrefix(const s: string);
begin
  Self := s + Self;
end;

procedure TMStringHelper.Insert(StartIndex: NInt; const Value: string);
{$ZEROBASEDSTRINGS ON}
begin
  System.Insert(Value, Self, StartIndex);
end;
{$ZEROBASEDSTRINGS OFF}

procedure TMStringHelper.Delete(StartIndex, Count: NInt);
begin
{$ZEROBASEDSTRINGS ON}
  System.Delete(Self, StartIndex, Count);
{$ZEROBASEDSTRINGS OFF}
end;

procedure TMStringHelper.Delete(StartIndex: NInt);
begin
  SetLength(StartIndex);
end;

procedure TMStringHelper.DeleteLeft(Count: NInt);
begin
  Delete(0, Count);
end;

procedure TMStringHelper.DeleteRight(Count: NInt);
begin
  SetLength(ez.Max(0, Length - Count));
end;
{$ENDREGION}

{$REGION 'My Functions - DeleteSepatorsFrom'}
function TMStringHelper.DeleteSepatorsFromLeft(Sep: Char; GroupWidth: NInt): boolean;
var
  i, n: NInt;
  p1, p2: PChar;
begin
  if Length <= GroupWidth then Exit(true);
  if Length mod (GroupWidth + 1) = 0 then Exit(False);
  n := Length div (GroupWidth + 1);
  p1 := PChar(Self) + GroupWidth;
  if not string.IsCharRepeated(p1, Sep, GroupWidth, Length div (GroupWidth + 1)) then Exit(False);

  p2 := p1;
  inc(p1);
  for i := 1 to n - 1 do
  begin
    Move(p1^, p2^, GroupWidth * SizeOf(Char));
    inc(p1, GroupWidth + 1);
    inc(p2, GroupWidth);
  end;

  Move(p1^, p2^, (Length mod (GroupWidth + 1)) * SizeOf(Char));
  SetLength(Length - n);
  Result := True;
end;

function TMStringHelper.DeleteSepatorsFromRight(Sep: Char; GroupWidth: NInt): boolean;
var
  i, n: NInt;
  p1, p2: PChar;
begin
  if Length <= GroupWidth then Exit(true);
  if Length mod (GroupWidth + 1) = 0 then Exit(False);
  n := Length div (GroupWidth + 1);
  p1 := PChar(Self) + Length mod (GroupWidth + 1);
  if not string.IsCharRepeated(p1, Sep, GroupWidth, Length div (GroupWidth + 1)) then Exit(False);

  p2 := p1;
  inc(p1);
  for i := 1 to n do
  begin
    Move(p1^, p2^, GroupWidth * SizeOf(Char));
    inc(p1, GroupWidth + 1);
    inc(p2, GroupWidth);
  end;
  SetLength(Length - n);
  Result := True;
end;
{$ENDREGION}

{$WARN IMMUTABLE_STRINGS ON}
{$ENDREGION}


{$REGION 'TStringArrayHelper'}
{ TStringArrayHelper }

{$Region 'Class functions'}
class function TStringArrayHelper.Create(Size: NInt): TStringArray;
begin
  System.SetLength(Result, Size);
end;

class function TStringArrayHelper.Create(const s: string; const Separator: string; SkipEmpty: Bool): TStringArray;
begin
  Result.AddStringsStr(s, Separator, SkipEmpty);
end;

class function TStringArrayHelper.Create(Items: TStrings; SkipEmpty: Bool): TStringArray;
begin
  Result.Assign(Items);
end;

class function TStringArrayHelper.CreateFromLines(const s: string; SkipEmpty: Bool): TStringArray;
begin
  Result.AddLines(s, SkipEmpty);
end;
{$ENDREGION}

{$Region 'private functions'}
function TStringArrayHelper.GetCount: NInt;
begin
  Result := System.Length(Self);
end;
{$ENDREGION}

{$REGION 'Boolean functions and IndexOf'}
function TStringArrayHelper.IsEmpty: Bool;
begin
  Result := Self = nil;
end;

function TStringArrayHelper.NotEmpty: Bool;
begin
  Result := Self <> nil;
end;

function TStringArrayHelper.Equals(const Items: array of string): Bool;
var
  i: NInt;
begin
  Result := Self.Count = System.Length(Items);
  if Result then
    for i := 0 to Count - 1 do
      if Self[i] <> Items[i] then exit(False);
end;

function TStringArrayHelper.TextEquals(const Items: array of string): Bool;
var
  i: NInt;
begin
  Result := Self.Count = System.Length(Items);
  if Result then
  begin
    for i := 0 to Count - 1 do
      if Self[i] <> Items[i] then exit(False);
  end;
end;

function TStringArrayHelper.IndexOf(const S: string; fromIndex: NInt): NInt;
begin
  if fromIndex < 0 then fromIndex := 0;
  for Result := fromIndex to Length - 1 do
    if Self[Result] = S then exit;
  Result := -1;
end;

function TStringArrayHelper.IndexOfText(const S: string; fromIndex: NInt): NInt;
begin
  if fromIndex < 0 then fromIndex := 0;
  for Result := fromIndex to Length - 1 do
    if string.CompareText(Self[Result], S) = 0 then exit;
  Result := -1;
end;

function TStringArrayHelper.LastIndexOf(const S: string; fromIndex: NInt): NInt;
begin
  if fromIndex >= Length then fromIndex := Length - 1;
  for Result := fromIndex downto 0 do
    if Self[Result] = S then exit;
  Result := -1;
end;

function TStringArrayHelper.LastIndexOf(const S: string): NInt;
begin
  Result := LastIndexOf(s, Length - 1);
end;

function TStringArrayHelper.LastIndexOfText(const S: string; fromIndex: NInt): NInt;
begin
  if fromIndex >= Length then fromIndex := Length - 1;
  for Result := fromIndex downto 0 do
    if string.CompareText(Self[Result], S) = 0 then exit;
  Result := -1;
end;

function TStringArrayHelper.LastIndexOfText(const S: string): NInt;
begin
  Result := LastIndexOfText(s, Length - 1);
end;

function TStringArrayHelper.Includes(const S: string; fromIndex: NInt): Bool;
begin
  Result := IndexOf(S, fromIndex) >= 0;
end;

function TStringArrayHelper.AreAllEmpty: Bool;
begin
  for var i := 0 to Length - 1 do
    if Self[i] <> '' then Exit(False);
  Result := True;
end;

function TStringArrayHelper.AreAllNumbers(AcceptPercent: Bool = False): Bool;
var
  f: FloatEx;
begin
  for var i := 0 to Length - 1 do
    if not FloatEx.TryParse(Self[i], f, AcceptPercent) then Exit(False);
  Result := True;
end;

function TStringArrayHelper.AreAllEmptyOrNumbers(AcceptPercent: Bool = False): Bool;
var
  i: NInt;
  f: FloatEx;
begin
  for i := 0 to Length - 1 do
    if (Self[i] <> '') and not FloatEx.TryParse(Self[i], f, AcceptPercent) then Exit(False);
  Result := True;
end;

function TStringArrayHelper.AllStartWith(const s: string; MatchEmpty: Bool = False; IgnoreCase: Bool = False): Bool;
begin
  for var i := 0 to Length - 1 do
    if Self[i] <> ''
      then if not Self[i].StartsWith(s, IgnoreCase) then Exit(False) else
      else if not MatchEmpty then Exit(False);
  Result := True;
end;

function TStringArrayHelper.AllEndWith(const s: string; MatchEmpty: Bool = False; IgnoreCase: Bool = False): Bool;
begin
  for var i := 0 to Length - 1 do
    if Self[i] <> ''
      then if not Self[i].EndsWith(s, IgnoreCase) then Exit(False) else
      else if not MatchEmpty then Exit(False);
  Result := True;
end;

function TStringArrayHelper.AllContain(const s: string; MatchEmpty: Bool = False; IgnoreCase: Bool = False): Bool;
begin
  for var i := 0 to Length - 1 do
    if Self[i] <> ''
      then if not Self[i].Contains(s, IgnoreCase) then Exit(False) else
      else if not MatchEmpty then Exit(False);
  Result := True;
end;
{$ENDREGION}

{$REGION 'Add/Assign strings'}
function TStringArrayHelper.Add(Items: TStrings; SkipEmpty: Bool): NInt;
var
  i, l: NInt;
begin
  if Items.Count = 0 then Exit(0);

  l := Length;
  SetLength(l + Items.Count);
  for i := 0 to Items.Count - 1 do
    if not SkipEmpty or (Items[i] <> '') then
    begin
      Self[l] := Items[i];
      inc(l);
    end;
  Result := l - Length;
  SetLength(l);
end;

function TStringArrayHelper.AddLines(const S: string; SkipEmpty: Bool): NInt;
var
  i, j, l, Len: NInt;

  procedure AddStr(i, ls: NInt);
  begin
    if SkipEmpty and (ls <= 0) then exit;
    if Length <= Len then SetLength(Numbers.GrowSlowly(Len));
    Self[Len] := s.SubString(i, ls);
    inc(Len);
  end;
begin
  Len := Length;
  Result := Len;
  l := s.Length;

  i := 0;
  j := 0;
  while j < l do
  begin
    if (s.Chars[j] = LineReturn1) then
    begin
      AddStr(i, j - i);
      i := j + 1;
      if (i < l) and (s.Chars[i] = LineReturn2)
        then inc(i);
      j := i;
    end else if (s.Chars[j] = LineReturn2) then
    begin
      AddStr(i, j - i);
      i := j + 1;
      j := i;
    end else inc(j);
  end;

  AddStr(i, l - i);
  Result := Len - Result;
  SetLength(Len);
end;

function TStringArrayHelper.AddStrings(const S: string; Separator: Char; SkipEmpty: Bool): NInt;
var
  Len: NInt;
  i, j, l: NInt;

  procedure AddStr(i, ls: NInt);
  begin
    if SkipEmpty and (ls = 0) then exit;
    if Length <= Len then SetLength(Numbers.GrowSlowly(Len));
    Self[Len] := s.SubString(i, ls);
    inc(Len);
  end;
begin
  Len := Length;
  Result := Len;
  l := s.Length;

  i := 0;      j := 0;
  while i < l do
  begin
    while (i < l) and (s.Chars[i] <> Separator) do inc(i);
    if i >= l then break;
    AddStr(j, i - j);
    inc(i);
    j := i;
  end;
  AddStr(j, l - j);
  Result := Len - Result;
  SetLength(Len);
end;

function TStringArrayHelper.AddStringsStr(const S, Separator: string; SkipEmpty: Bool): NInt;
var
  Len: NInt;
  i, j, l: NInt;

  procedure AddStr(i, ls: NInt);
  begin
    if SkipEmpty and (ls = 0) then exit;
    if Length <= Len then SetLength(Numbers.GrowSlowly(Len));
    Self[Len] := s.SubString(i, ls);
    inc(Len);
  end;
begin
  Len := Length;
  Result := Len;
  l := s.Length;

  i := 0;
  while i < l do
  begin
    j := S.IndexOf(Separator, i);
    if j < 0 then break;
    AddStr(i, j - i);
    i := j + Separator.Length;
  end;
  AddStr(i, l - i);
  Result := Len - Result;
  SetLength(Len);
end;

procedure TStringArrayHelper.AssignStrings(const S: string; Separator: Char; SkipEmpty: Bool);
begin
  Clear;
  AddStrings(S, Separator, SkipEmpty);
end;

procedure TStringArrayHelper.Assign(Source: TStrings; SkipEmpty: Bool);
var
  i, l: NInt;
begin
  l := 0;
  SetLength(Source.Count);
  for i := 0 to Source.Count - 1 do
    if not SkipEmpty or (Source[i] <> '') then
    begin
      Self[l] := Source[i];
      inc(l);
    end;
  SetLength(l);
end;

function  TStringArrayHelper.AssignLines(const S: string; SkipEmpty: Bool): NInt;
begin
  Clear;
  Result := AddLines(S, SkipEmpty);
end;

procedure TStringArrayHelper.AssignStringsStr(const S, Separator: string; SkipEmpty: Bool);
begin
  Clear;
  AddStringsStr(S, Separator, SkipEmpty);
end;

procedure TStringArrayHelper.AssignTo(Strings: TStrings);
begin
  Strings.BeginUpdate;
  try
    Strings.Clear;
    Strings.Capacity := Count;
    for var i := 0 to Count - 1 do
      Strings.Append(Self[i]);
  finally
    Strings.EndUpdate;
  end;
end;
{$ENDREGION}

{$REGION 'Partial Add/Copy'}
procedure TStringArrayHelper.CopyFrom(const Source: array of string; SrcIndex, Len, TrgIndex: NInt);
var
  i, d, l: NInt;
begin
  l := System.Length(Source);
  if (SrcIndex < 0 ) then Exception.RaiseIndexError(SrcIndex);
  if (SrcIndex >= l) then exit;
  ez.ToSmaller(Len, l - SrcIndex);
  if Len <= 0 then Exit;

  if (TrgIndex < 0) or (TrgIndex > Length) then Exception.RaiseIndexError(TrgIndex);
  if Length < TrgIndex + Len
    then SetLength(TrgIndex + Len);
  d := TrgIndex - SrcIndex;
  for i := SrcIndex to SrcIndex + Len - 1 do
    Self[i + d] := Source[i];
end;

procedure TStringArrayHelper.CopyFrom(const Source: TStringArray; SrcIndex, Len, TrgIndex: NInt);
var
  i, d, l: NInt;
begin
  l := Source.Length;
  if (SrcIndex < 0 ) then Exception.RaiseIndexError(SrcIndex);
  if (SrcIndex >= l) then exit;
  ez.ToSmaller(Len, l - SrcIndex);
  if Len <= 0 then Exit;

  if (TrgIndex < 0) or (TrgIndex > Length) then Exception.RaiseIndexError(TrgIndex);
  if Length < TrgIndex + Len
    then SetLength(TrgIndex + Len);
  d := TrgIndex - SrcIndex;
  for i := SrcIndex to SrcIndex + Len - 1 do
    Self[i + d] := Source[i];
end;

function TStringArrayHelper.Slice(Start, ExclusiveEnd: NInt): TStringArray;
begin
  if Start < 0 then Exception.RaiseIndexError(Start);
  if ExclusiveEnd > Length then ExclusiveEnd := Length;
  Result := System.Copy(Self, Start, ExclusiveEnd - Start);
end;

function TStringArrayHelper.Slice(Start: NInt): TStringArray;
begin
  if Start < 0 then Inc(Start, Length);
  if Start < 0 then Exception.RaiseIndexError(Start);
  Result := System.Copy(Self, Start, Length);
end;
{$ENDREGION}

{$REGION 'Add/Insert/Delete'}
function TStringArrayHelper.Add(const s: string): NInt;
begin
  Result := Length;
  SetLength(Result + 1);
  Self[Result] := s;
end;

function TStringArrayHelper.Insert(Index: NInt; const s: string): NInt;
begin
  if Index < 0
    then Result := 0
  else if Index > Length
    then Result := Length
    else Result := Index;
  System.Insert(s, Self, Result);
end;

function TStringArrayHelper.Prepend(const s: string): NInt;
begin
  Result := Insert(0, s);
end;

function TStringArrayHelper.AddUnique(const s: string): NInt;
begin
  Result := IndexOf(s);
  if Result < 0 then Result := Add(s);
end;

function TStringArrayHelper.AddUniqueText(const s: string): NInt;
begin
  Result := IndexOfText(s);
  if Result < 0 then Result := Add(s);
end;

function TStringArrayHelper.Push(const s: string): NInt;
begin
  Result := Add(s);
end;

function TStringArrayHelper.Pop: string;
begin
  if IsEmpty then Exception.RaiseIndexError(-1);
  Result := Self[Length - 1];
  SetLength(Length - 1);
end;

function TStringArrayHelper.DeQueue: string;
begin
  if IsEmpty then Exception.RaiseIndexError(-1);
  Result := Self[0];
  System.Delete(Self, 0, 1);
end;

function TStringArrayHelper.Delete(Index: NInt; Len: NInt = 1): NInt;
begin
  if (Index < 0) then Exception.RaiseIndexError(Index);
  Result := ez.Min(Len, Length - Index);
  if Result <= 0 then exit(0);
  System.Delete(Self, Index, Result);
end;

function TStringArrayHelper.Remove(const s: string; fromIndex: NInt = 0): Bool;
var
  i: NInt;
begin
  i := IndexOf(s, fromIndex);
  Result := i >= 0;
  if Result then System.Delete(Self, i, 1);
end;

function TStringArrayHelper.RemoveAll(const s: string; fromIndex: NInt = 0): Bool;
var
  i, j: NInt;
begin
  i := IndexOf(s, fromIndex);
  Result := i >= 0;
  if Result then
  begin
    for j := i + 1 to Length - 1 do
      if s[j] <> s then
      begin
        Self[i] := s[j];
        inc(i);
      end;
      SetLength(i);
  end;
end;

function TStringArrayHelper.RemoveEmptyStrings: NInt;
var
  i, j, l: NInt;
begin
  i := 0;
  l := Length;
  while (i < l) and (Self[i] <> '') do inc(i);

  j := i + 1;
  while j < l do
  begin
    if Self[j] <> '' then
    begin
      Self[i] := Self[j];
      inc(i);
    end;
    inc(j);
  end;
  Result := Length - i;
  SetLength(i);
end;

function TStringArrayHelper.RemoveDuplicatedStrings: NInt;
var
  i, j, First0, l: NInt;
begin
  first0 := -1;
  i := 0;
  l := Length;
  while i < l do
    if Self[i] = '' then
    begin
      First0 := i;
      break;
    end;

  for i := 0 to l - 2 do
    if Self[i] <> '' then
      for j := i + 1 to l - 1 do
        if Self[i] = Self[j] then
          Self[j] := '';

  j := 0;
  for i := 0 to Length - 1 do
    if (i = First0) or (Self[i] <> '') then
    begin
      if i <> j then Self[j] := Self[i];
      inc(j);
    end;
  Result := Length - j;
  SetLength(j);
end;
{$ENDREGION}

{$REGION 'Change order'}
procedure TStringArrayHelper.Move(FromIndex, ToIndex: NInt);
var
  i: NInt;
  t: string;
begin
  if Self.IsEmpty then exit;
  if (FromIndex < 0) or (FromIndex >= Length) then Exception.RaiseIndexError(FromIndex);
  if (ToIndex < 0) or (ToIndex >= Length) then Exception.RaiseIndexError(FromIndex);
  if FromIndex = ToIndex then exit;
  t := Self[FromIndex];
  if ToIndex > FromIndex
   then for i := FromIndex to ToIndex - 1 do Self[i] := Self[i + 1]
   else for i := FromIndex downto ToIndex + 1 do Self[i] := Self[i - 1];
  Self[ToIndex] := t;
end;

procedure TStringArrayHelper.Exchange(Index1, Index2: NInt);
begin
  ez.Swap(Self[Index1], Self[Index2]);
end;
{$ENDREGION}

{$REGION 'Changing many'}
procedure TStringArrayHelper.Clear;
begin
  System.SetLength(Self, 0);
end;

procedure TStringArrayHelper.SetLength(Size: NInt);
begin
  System.SetLength(Self, Size);
end;

procedure TStringArrayHelper.EnsureLength(Size: NInt);
begin
  if Length < Size then SetLength(Size);
end;

procedure TStringArrayHelper.Fill(const FillValue: string; Index, Len: NInt);
var
  i: NInt;
begin
  if Index < 0 then Exception.RaiseIndexError(Index);
  ez.ToSmaller(Len, Length - Index);
  for i := Index to Index + Len - 1 do
    Self[i] := FillValue;
end;

procedure TStringArrayHelper.Fill(const FillValue: string; Index: NInt = 0);
begin
  Fill(FillValue, Index, Length);
end;

procedure TStringArrayHelper.TrimStrings;
begin
  for var i := 0 to Length - 1 do
    Self[i] := Trim(Self[i]);
end;
{$ENDREGION}

{$REGION 'Join/Tostring'}
function TStringArrayHelper.Join(const Separator: string; Index, Len: NInt): string;
var
//  sb: TStringBuilder;
  i, l: NInt;
  c12: UInt32;
  p: pChar;
begin
{$WARN IMMUTABLE_STRINGS OFF}
  if Index < 0 then Exception.RaiseIndexError(Index);
  ez.ToSmaller(Len, Length - Index);
  if Len <= 0 then Exit('');
  if Len = 1 then Exit(Self[Index]);
  if Separator.Length = 1 then Exit(Join(Separator.Chars[0], Index, Len));
  l := 0;
  for i := Index to Index + Len - 1 do
    Inc(l, Self[i].Length);

  System.SetLength(Result, l + Separator.Length * (Len - 1));
  p := PChar(Result);
  Self[Index].CopyAndMovePointer(p);

  if Separator = '' then
  begin
    for i := Index + 1 to Index + Len - 1 do
      Self[i].CopyAndMovePointer(p);
  end else if Separator.Length = 2 then
  begin
    c12 := PUInt32(PChar(Separator))^;
    for i := Index + 1 to Index + Len - 1 do
    begin
      PUInt32(p)^ := c12;
      inc(p, 2);
      Self[i].CopyAndMovePointer(p);
    end;
  end else
  begin
    for i := Index + 1 to Index + Len - 1 do
    begin
      Separator.CopyAndMovePointer(p);
      Self[i].CopyAndMovePointer(p);
    end;
  end;
{$WARN IMMUTABLE_STRINGS ON}
{  sb := TStringBuilder.Create(CharCount + (Count - 1) * System.Length((Separator)));
  try
    sb.Append(Self[Start]);
    for i := Start + 1 to Start + Count - 1 do
      sb.Append(Separator).Append(Self[i]);
    Result := sb.ToString;
  finally
    sb.Free;
  end;
}
end;

function TStringArrayHelper.ToString(const Separator: string): string;
begin
  Result := Join(Separator, 0, Length);
end;

function TStringArrayHelper.ToString(EOLFormat: TEndOfLineFormat): string;
begin
  if EOLFormat = TEndOfLineFormat.elfSystem then EOLFormat := SystemEOF;
  if EOLFormat = TEndOfLineFormat.elfWindows
    then Result := ToString(WindowsLineReturn)
  else if EOLFormat = TEndOfLineFormat.elfUnix
    then Result := ToString(Char16(UnixLineReturn))
    else Result := ToString(Char16(MacLineReturn));
end;

function TStringArrayHelper.ToString: string;
begin
  Result := ToString(TEndOfLineFormat.elfSystem);
end;
{$ENDREGION}
{$ENDREGION}


{$REGION 'TPointFHelper'}
function TPointFHelper.Equals(const Rhs: TPointF): Boolean;
begin
  Result := (X = Rhs.X) and (Y = Rhs.Y)
end;

function TPointFHelper.NotEqual(const Rhs: TPointF): Boolean;
begin
  Result := (X <> Rhs.X) or (Y <> Rhs.Y)
end;

function TPointFHelper.Equals(x, y: Float32): Boolean;
begin
  Result := (Self.X = X) and (Self.Y = Y)
end;

function TPointFHelper.NotEqual(x, y: Float32): Boolean;
begin
  Result := (Self.X <> X) or (Self.Y <> Y)
end;

function TPointFHelper.InRect(const Rect: TRectF): Boolean;
begin
  Result := (X >= Rect.Left) and (X < Rect.Right) and
            (Y >= Rect.Top)  and (Y < Rect.Bottom);
end;

function TPointFHelper.ToString: string;
begin
  Result := Format('(%g, %g)', [X.RoundTo(2), X.RoundTo(2)]);
end;
{$ENDREGION}


{$REGION 'Numbers'}
{$IFDEF EXTENDED80}
class function Numbers.GetLastPrecisionDigits(const Value: FloatEx): NInt;
const
  Epsilon = 1e-8;
  SignificantDigits = 18;      // for double, this can be 18-21
var
  l: NInt;
  v, w: FloatEx;
begin
  v := Abs(Value);
  if v < Epsilon then Exit(0);
  Result := Floor(log10(v));
  w := abs(v - SimpleRoundTo(v, Result));
  l := 0;
  while (Frac(w) > Epsilon) and (l < SignificantDigits) do
  begin
    Dec(Result); inc(l);
    w := abs(v - SimpleRoundTo(v, Result));
  end;
end;
{$ENDIF}

class function Numbers.GetLastPrecisionDigits(const Value: Float64): NInt;
const
  Epsilon = 1e-7;
  SignificantDigits = 15;      // for double, this can be 15-17
var
  l: NInt;
  v, w: FloatEx;
begin
  v := Abs(Value);
  if v < Epsilon then Exit(0);
  Result := Floor(log10(v));
  w := abs(v - SimpleRoundTo(v, Result));
  l := 0;
  while (Frac(w) > Epsilon) and (l < SignificantDigits) do
  begin
    Dec(Result); inc(l);
    w := abs(v - SimpleRoundTo(v, Result));
  end;
end;

class function Numbers.GetLastPrecisionDigits(const Value: Float32): NInt;
const
  Epsilon = 1e-5;
  SignificantDigits = 6;        // for Single, the significant digits can be 6-9
var
  l: NInt;
  v, w: FloatEx;
begin
  v := Abs(Value);
  if v < Epsilon then Exit(0);
  Result := Floor(log10(v));
  w := abs(v - SimpleRoundTo(v, Result));
  l := 0;
  while (Frac(w) > Epsilon) and (l < SignificantDigits) do
  begin
    Dec(Result); inc(l);
    w := abs(v - SimpleRoundTo(v, Result));
  end;
end;

class function Numbers.GetFirstDigits(const Value: FloatEx): NInt;
begin
  if Value = 0
    then Result := 0
    else Result := Floor(log10(Abs(Value)));
end;

class function Numbers.GetFirstDigits(Value: UInt64): NInt;
begin
  Result := 0;
  while Value >= 10 do
  begin
    Inc(Result);
    Value := Value div 10;
  end;
end;

class function Numbers.Grow(Size: NInt): NInt;
begin
  if Size <   64 then Exit(  64) else
  if Size <  256 then Exit( 256) else
  if Size < 1024 then Exit(1024) else
  if Size <   4 * Numbers.Kilobyte then Exit(  4 * Numbers.Kilobyte) else
  if Size <  16 * Numbers.Kilobyte then Exit( 16 * Numbers.Kilobyte) else
  if Size <  64 * Numbers.Kilobyte then Exit( 64 * Numbers.Kilobyte) else
  if Size < 256 * Numbers.Kilobyte then Exit(256 * Numbers.Kilobyte)
                                   else Exit((Size + 256 * Numbers.Kilobyte) and not (256 * Numbers.Kilobyte - 1));
end;

class function Numbers.GrowSlowly(Size: NInt): NInt;
begin
  if Size <   16 then Exit(  16) else
  if Size <   32 then Exit(  32) else
  if Size <   64 then Exit(  64) else
  if Size <  128 then Exit( 128) else
  if Size <  256 then Exit( 256) else
  if Size <  512 then Exit( 512) else
  if Size < 1024 then Exit(1024) else
  if Size <  2 * Numbers.Kilobyte then Exit(  2 * Numbers.Kilobyte) else
  if Size <  4 * Numbers.Kilobyte then Exit(  4 * Numbers.Kilobyte) else
  if Size <  8 * Numbers.Kilobyte then Exit(  8 * Numbers.Kilobyte)
                                  else Exit((Size + 8 * Numbers.Kilobyte) and not (8 * Numbers.Kilobyte - 1));
end;

class function Numbers.TryParse(const S: string; out Value: Int32): Boolean;
begin
  Result := Int32.TryParse(S, Value);
end;

class function Numbers.TryParse(const S: string; out Value: UInt32): Boolean;
begin
  Result := UInt32.TryParse(S, Value);
end;

class function Numbers.TryParse(const S: string; out Value: Int64): Boolean;
begin
  Result := Int64.TryParse(S, Value);
end;

class function Numbers.TryParse(const S: string; out Value: UInt64): Boolean;
begin
  Result := UInt64.TryParse(S, Value);
end;

class function Numbers.ToStringWithSeparators(n: UInt64; Separator: char): string;
var
  d: UInt64;
begin
  if (Separator = #0) or (n < 1000) then Exit(IntToStr(n));
  Result := '';
  repeat
    d := n mod 1000;
    n := n div 1000;
    Result := Separator + Char(48 + d div 100) + Char(48 + (d mod 100) div 10) + char(48 + d mod 10) + Result;
  until n < 1000;
  Result := IntToStr(n) + Result;
end;

class function Numbers.ToCommaString(n: UInt64): string;
begin
  Result := ToStringWithSeparators(n, ',');
end;

class function Numbers.ToLocaleString(n: UInt64): string;
begin
  Result := ToStringWithSeparators(n, FormatSettings.ThousandSeparator);
end;

class function Numbers.ToPaddedString(n: UInt64; MinWidth: NInt; Pad: Char = ' '; Sep: Char = #0): string;
begin
  Result := ToStringWithSeparators(n, Sep);
  if Length(Result) < MinWidth then
    Result := StringOfChar(Pad, MinWidth - Length(Result)) + Result;
end;

class function Numbers.ToReadableString(n: UInt64; const Zero, One, More: string): string;
begin
  if n = 0
    then Result := Format(Zero, [n])
  else if n = 1
    then Result := Format(One, [n])
    else Result := Format(More, [n]);
end;

class function Numbers.ToRoundedString(const Fmt: string; const f: FloatEx): string;
begin
  Result := Format(Fmt.Replace('%g', '%s'), [ToRoundedString(f)]);
end;

class function Numbers.ToRoundedString(const f: FloatEx): string;
begin
  var d := GetLastPrecisionDigits(f);
  if d >= 0
    then Result := IntToStr(Round(f))
    else Result := Format('%.*f', [-d, SimpleRoundTo(f, d)]);
end;

class function Numbers.ToStringWithSeparators(n: Int64; Separator: char): string;
begin
  if n >= 0
    then Result := ToStringWithSeparators(UInt64(n), Separator)
    else Result := '-' + ToStringWithSeparators(UInt64(-n), Separator);
end;

class function Numbers.ToCommaString(n: Int64): string;
begin
  Result := ToStringWithSeparators(n, ',');
end;

class function Numbers.ToLocaleString(n: Int64): string;
begin
  Result := ToStringWithSeparators(n, FormatSettings.ThousandSeparator);
end;

class function Numbers.ToPaddedString(n: Int64; MinWidth: NInt; Pad: Char = ' '; Sep: Char = #0): string;
begin
  Result := ToStringWithSeparators(n, Sep);
  if Length(Result) < MinWidth then
    if (n >= 0) or (Pad <> '0')
      then Result := StringOfChar(Pad, MinWidth - Length(Result)) + Result
      else Result := '-' + StringOfChar('0', MinWidth - Length(Result)) + Copy(Result, 2, Length(Result));
end;

class function Numbers.TryParseWithSeparators(const s: string; out Value: UInt64; Sep: char): Boolean;
var
  t: string;
begin
  t := s;
  Result := MString(t).DeleteSepatorsFromRight(Sep, 3) and UInt64.TryParse(t, Value);
end;

class function Numbers.TryParseWithComma(const s: string; out Value: UInt64): Boolean;
begin
  Result := TryParseWithSeparators(s, Value, ',');
end;

class function Numbers.TryParseWithLocalSeparators(const s: string; out Value: UInt64): Boolean;
begin
  Result := TryParseWithSeparators(s, Value, FormatSettings.ThousandSeparator);
end;

class function Numbers.TryParseWithSeparators(const s: string; out Value: Int64; Sep: char): Boolean;
var
  t: string;
begin
  if s = '' then Exit(False);
  if s[1] = '-' then
  begin
    t := Copy(s, 2, Length(s));
    Result := MString(t).DeleteSepatorsFromRight(Sep, 3) and Int64.TryParse('-' + t, Value);
  end else
  begin
    if s[1] = '+'
      then t := Copy(s, 2, Length(s))
      else t := s;
    Result := MString(t).DeleteSepatorsFromRight(Sep, 3) and Int64.TryParse(t, Value);
  end;
end;

class function Numbers.TryParseWithComma(const s: string; out Value: Int64): Boolean;
begin
  Result := TryParseWithSeparators(s, Value, ',');
end;

class function Numbers.TryParseWithLocalSeparators(const s: string; out Value: Int64): Boolean;
begin
  Result := TryParseWithSeparators(s, Value, FormatSettings.ThousandSeparator);
end;

class function Numbers.ToStringWithSeparators(const f: FloatEx; nFrac: NInt; KSep, DSep, FSep: char): string;
var
  FS: TFormatSettings;
  p: NInt;
begin
  FS.ThousandSeparator := KSep;
  FS.DecimalSeparator  := DSep;
  Result := FloatToStrF(F, TFloatFormat.ffFixed, 24, nFrac, FS);
  if (FSep <> #0) and (nFrac > 3) then
  begin
    p := Pos(DSep, Result);
    Result := Copy(Result, 1, p) + Copy(Result, p + 1, nFrac).AddSepatorsFromLeft(FSep, 3);
  end;
end;

class function Numbers.ToStringWithSeparators(const f: FloatEx; nFrac: NInt; KSep, DSep: char): string;
begin
  Result := ToStringWithSeparators(f, nFrac, KSep, DSep, #0);
end;

class function Numbers.ToCommaString(const f: FloatEx; nFrac: NInt; NoTraillingZero: Boolean = False): string;
begin
  Result := ToStringWithSeparators(f, nFrac, ',', '.', #0);
  if NoTraillingZero then Result := Result.RemoveFloatTrailingZeros;
end;

class function Numbers.ToLocaleString(const f: FloatEx; nFrac: NInt; NoTraillingZero: Boolean = False): string;
begin
  Result := ToStringWithSeparators(f, nFrac, FormatSettings.ThousandSeparator, FormatSettings.DecimalSeparator, #0);
  if NoTraillingZero then Result := Result.RemoveFloatTrailingZerosLocal;
end;

class function Numbers.ToScientificString(const f: FloatEx; nFrac: NInt; DSep, FSep: Char): string;
var
  FS: TFormatSettings;
  p1, p2: Int32;
begin
  FS.ThousandSeparator := FSep;
  FS.DecimalSeparator  := DSep;
  Result := FloatToStrF(f, TFloatFormat.ffExponent, nFrac + 1, nFrac, FS);
  if (FSep = #0) or (nFrac <= 3) then Exit;

  p1 := Pos(DSep, Result);
  if p1 <= 0 then Exit;
  p2 := Pos('E', Result);
  if p2 <= 0 then p2 := Pos('e', Result);

  Result := Copy(Result, 1, p1) +
            Copy(Result, p1 + 1, p2 - p1 - 1).AddSepatorsFromLeft(FSep, 3) +
            Copy(Result, p2, Length(Result));
end;

class function Numbers.TryParseWithSeparators(const s: string; KSep, DSep, FSep: Char; out Value: FloatEx): boolean;
var
  p1, p2: Int32;
  t: string;
  FS: TFormatSettings;
begin
  t := s;
  if FSep <> #0 then
  begin
    p1 := Pos(DSep, s);
    if p1 > 0 then
    begin
      p2 := Pos('E', s, p1 + 1);
      if p2 <= 0 then p2 := Pos('e', s, p1 + 1);
      if { (p2 > 0) and } p2 - p1 > 5 then      // Only need to process if the length of t (p2 - p1 - 1) is larger than 4; 4-->Error
      begin
        t := Copy(s, p1 + 1, p2 - p1 - 1);
        if not MString(t).DeleteSepatorsFromLeft(FSep, 3) then exit(false);
        t := Copy(s, 1, p1) + t + Copy(s, p2, Length(s));
      end;
    end;
  end;
  FS.ThousandSeparator := KSep;
  FS.DecimalSeparator  := DSep;
  Result := TryStrToFloat(s, Value, FS);
end;

class function Numbers.TryParseWithSeparators(const s: string; KSep, DSep: Char; out Value: FloatEx): boolean;
begin
  Result := TryParseWithSeparators(s, KSep, DSep, #0, Value);
end;

class function Numbers.TryParseWithComma(const s: string; out Value: FloatEx): Boolean;
begin
  Result := TryParseWithSeparators(s, ',', '.', #0, Value);
end;

class function Numbers.TryParseWithLocalSeparators(const s: string; out Value: FloatEx): Boolean;
begin
  Result := TryParseWithSeparators(s, FormatSettings.ThousandSeparator, FormatSettings.DecimalSeparator, #0, Value);
end;

class function Numbers.TryParseWithSeparators(const s: string; KSep, DSep, FSep: Char; out Value: Float64): boolean;
var
  Ex: FloatEx;
begin
  Result := TryParseWithSeparators(s, KSep, DSep, FSep, Ex);
  if Result then Value := Ex;
end;

class function Numbers.TryParseWithSeparators(const s: string; KSep, DSep: Char; out Value: Float64): boolean;
var
  Ex: FloatEx;
begin
  Result := TryParseWithSeparators(s, KSep, DSep, Ex);
  if Result then Value := Ex;
end;

class function Numbers.TryParseWithComma(const s: string; out Value: Float64): Boolean;
var
  Ex: FloatEx;
begin
  Result := TryParseWithComma(s, Ex);
  if Result then Value := Ex;
end;

class function Numbers.TryParseWithLocalSeparators(const s: string; out Value: Float64): Boolean;
var
  Ex: FloatEx;
begin
  Result := TryParseWithLocalSeparators(s, Ex);
  if Result then Value := Ex;
end;

class function Numbers.TryParseWithSeparators(const s: string; KSep, DSep, FSep: Char; out Value: Float32): boolean;
var
  Ex: FloatEx;
begin
  Result := TryParseWithSeparators(s, KSep, DSep, FSep, Ex);
  if Result then Value := Ex;
end;

class function Numbers.TryParseWithSeparators(const s: string; KSep, DSep: Char; out Value: Float32): boolean;
var
  Ex: FloatEx;
begin
  Result := TryParseWithSeparators(s, KSep, DSep, Ex);
  if Result then Value := Ex;
end;

class function Numbers.TryParseWithComma(const s: string; out Value: Float32): Boolean;
var
  Ex: FloatEx;
begin
  Result := TryParseWithComma(s, Ex);
  if Result then Value := Ex;
end;

class function Numbers.TryParseWithLocalSeparators(const s: string; out Value: Float32): Boolean;
var
  Ex: FloatEx;
begin
  Result := TryParseWithLocalSeparators(s, Ex);
  if Result then Value := Ex;
end;
{$ENDREGION}


{$REGION 'TObjectHelper'}
{ TObjectHelper }

{$REGION 'TObjectHelper.TDestructorThread'}

{ TObjectHelper.TDestructorThread }

class destructor TObjectHelper.TDestructorThread.Destroy;
var
  SleepTime: Int32;
begin
  SleepTime := 0;
  while (FCount > 0) and (SleepTime < 100) do
  begin
    Sleep(5);
    Inc(SleepTime);
  end;
end;

constructor TObjectHelper.TDestructorThread.Create(ObjToFree: TObject);
begin
  Inc(FCount);
  FObjToFree := ObjToFree;
  FreeOnTerminate := True;
  Inherited Create(False);
end;

procedure TObjectHelper.TDestructorThread.Execute;
begin
  Sleep(2);
  if Assigned(FObjToFree) then FObjToFree.Free;
  Dec(FCount);
end;
{$ENDREGION}

class procedure TObjectHelper.DelayFree(ObjToFree: TObject);
begin
  TDestructorThread.Create(ObjToFree);
end;

procedure TObjectHelper.DelayFree;
begin
  DelayFree(Self);
end;
{$ENDREGION}

{$REGION 'TExceptionHelper'}
{ TExceptionHelper }

constructor TExceptionHelper.CreateRes(P: PString);
begin
  inherited CreateRes(PResStringRec(P));
end;

constructor TExceptionHelper.CreateResFmt(P: PString; const Args: array of Const);
begin
  inherited CreateResFmt(PResStringRec(P), Args);
end;

constructor TExceptionHelper.CreateResFmtHelp(P: PString; const Args: array of Const; AHelpContext: Int32);
begin
  inherited CreateResFmtHelp(PResStringRec(P), Args, AHelpContext);
end;

constructor TExceptionHelper.CreateResHelp(P: PString; AHelpContext: Int32);
begin
  inherited CreateResHelp(PResStringRec(P), AHelpContext);
end;

class procedure TExceptionHelper.RaiseError(const Msg: string);
begin
  raise Create(Msg) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseEmptyArrayError;
begin
  raise Exception.Create(SArrayItemNameError) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseError(const Msg: string; const Args: array of Const);
begin
  raise CreateFmt(Msg, Args) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseConvertBoolError(const Value: string);
begin
  raise EConvertError.CreateResFmt(@SInvalidBoolean, [Value]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseConvertIntError(const Value, TypeName: string);
begin
  raise EConvertError.CreateResFmt(@SInvalidInteger2, [Value, TypeName]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseConvertIntError(const Value: string);
begin
  raise EConvertError.CreateResFmt(@SInvalidInteger, [Value]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseConvertFloatError(const Value, TypeName: string);
begin
  raise EConvertError.CreateResFmt(@SInvalidFloat2, [Value, TypeName]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseConvertFloatError(const Value: string);
begin
  raise EConvertError.CreateResFmt(@SInvalidFloat, [Value]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseConvertDateError(const Value: string);
begin
  raise EConvertError.CreateResFmt(@SInvalidDate, [Value]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseConvertTimeError(const Value: string);
begin
  raise EConvertError.CreateResFmt(@SInvalidTime, [Value]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseConvertDateTimeError(const Value: string);
begin
  raise EConvertError.CreateResFmt(@SInvalidDateTime, [Value]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseIncompatibleTypes(const SrcType, TrgType: string);
begin
  raise EConvertError.CreateResFmt(@SConvIncompatibleTypes2, [SrcType, TrgType]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaisePercentRangeError(const p: Float);
begin
  raise EConvertError.CreateResFmt(@SPercentageRange, [p * 100]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseFilenameError(const Filename: TFilename);
begin
  raise EConvertError.CreateResFmt(@SInvalidnFilename1, [Filename]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseFileNotFound(const Filename: TFilename);
begin
  raise EConvertError.CreateResFmt(@SFileNotFound1, [Filename]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseOpenFileError(const Filename: TFilename);
begin
  raise EConvertError.CreateResFmt(@SFOpenError, [Filename]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseCreateFileError(const Filename: TFilename);
begin
  raise EConvertError.CreateResFmt(@SFCreateError, [Filename]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseInvalidPointerOperation;
begin
  raise EConvertError.CreateRes(@SInvalidPointer) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseIndexError(Index: NInt);
begin
  raise EConvertError.CreateResFmt(@wc.Consts.SIndexOutOfRange, [Index]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseIndexError(Index, Upper: NInt);
begin
  raise EConvertError.CreateResFmt(@SIndexOutOfRangeEx, [Index, 0, Upper]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseIndexError(Index, Lower, Upper: NInt);
begin
  raise EConvertError.CreateResFmt(@SIndexOutOfRangeEx, [Index, Lower, Upper]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseDifferentArraySizes;
begin
  raise EConvertError.CreateRes(@SArrayDimensionError) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseDifferentImageSizes;
begin
  raise EConvertError.CreateRes(@SImageDimensionError) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseIf_DifferentArraySizes(Len1, Len2: NInt);
begin
  if Len1 <> Len2 then
    raise EConvertError.CreateRes(@SArrayDimensionError) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseIf_DifferentImageSizes(W1, H1, W2, H2: NInt);
begin
  if (W1 <> W2) or (H1 <> H2) then
    raise EConvertError.CreateRes(@SArrayDimensionError) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseInvalidFloatingOperation;
begin
  raise EConvertError.CreateRes(@SInvalidOp) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseItemNotFound;
begin
  raise EConvertError.CreateRes(@SItemNotFound0) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseItemNotFound(n: NInt);
begin
  raise EConvertError.CreateResFmt(@SItemNotFound1, [N.ToString]) at ReturnAddress;
end;

class procedure TExceptionHelper.RaiseItemNotFound(const Value: string);
begin
  raise EConvertError.CreateResFmt(@SItemNotFound1, [Value]) at ReturnAddress;
end;
{$ENDREGION}

{$REGION 'TFileStreamHelper'}
{$REGION 'constructors'}
constructor TFileStreamHelper.CreateForRead(const Filename: TFilename);
begin
  Create(Filename, fmOpenRead + fmShareDenyWrite);
end;

constructor TFileStreamHelper.CreateForAppend(const Filename: TFilename);
begin
  CreateForReadWrite(Filename);
  Position := Size;
end;

constructor TFileStreamHelper.CreateForReadWrite(const Filename: TFilename; AutoCreate: Boolean = False);
begin
  if AutoCreate and not FileExists(Filename)
    then Create(Filename, fmCreate)
    else Create(Filename, fmOpenReadWrite + fmShareDenyWrite);
end;

constructor TFileStreamHelper.CreateForWrite(const Filename: TFilename);
begin
  Create(Filename, fmCreate);
end;
{$ENDREGION}
{$ENDREGION}

{$REGION 'TStreamHelper'}
{ TStreamHelper }

{$REGION 'ReadAll'}
class function TStreamHelper.ReadAll(const Filename: TFilename; var S: ByteString): Boolean;
var
  fs: TFileStream;
begin
  fs := TFileStream.CreateForRead(Filename);
  Result := True;
  try
    fs.ReadAll(s);
    fs.Free;
  except
    Result := False;
    fs.Free;
  end;
end;

class function TStreamHelper.ReadAll(const Filename: TFilename; var Bytes: TBytes): Boolean;
var
  fs: TFileStream;
begin
  fs := TFileStream.CreateForRead(Filename);
  Result := True;
  try
    fs.ReadAll(Bytes);
    fs.Free;
  except
    Result := False;
    fs.Free;
  end;
end;

procedure TStreamHelper.ReadAll(var s: ByteString);
{$WARN IMMUTABLE_STRINGS OFF}
begin
  SetLength(s, Size - Position);
  if s <> '' then
    ReadBuffer(PAnsiChar(s)^, Size - Position);
end;
{$WARN IMMUTABLE_STRINGS ON}

procedure TStreamHelper.ReadAll(var Bytes: TBytes);
begin
  SetLength(Bytes, Size - Position);
  if Bytes <> nil then
    ReadBuffer(Bytes[0], Size - Position);
end;
{$ENDREGION}

{$REGION 'ReadData/ReadType/ReadRecord/CurrentType'}
procedure TStreamHelper.ReadData(var a: Boolean);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadData(var a: Char8);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadData(var a: Char16);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadData(var a: Char32);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadData(var a: UInt8);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadData(var a: UInt16);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadData(var a: UInt32);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadData(var a: UInt64);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadData(var a: Int8);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadData(var a: Int16);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadData(var a: Int32);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadData(var a: Int64);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadData(var a: Float32);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadData(var a: Float64);
begin
  ReadBuffer(a, SizeOf(a));
end;

{$IFDEF EXTENDED80}
procedure TStreamHelper.ReadData(var a: FloatEx);
begin
  ReadBuffer(a, SizeOf(a));
end;
{$ENDIF}

procedure TStreamHelper.ReadRecord<T>(var a: T);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadBool(var a: Boolean);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadChar(var a: Char8);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadChar(var a: Char16);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadChar(var a: Char32);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadUInt(var a: UInt8);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadUInt(var a: UInt16);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadUInt(var a: UInt32);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadUInt(var a: UInt64);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadInt(var a: Int8);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadInt(var a: Int16);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadInt(var a: Int32);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadInt(var a: Int64);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadFloat(var a: Float32);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadFloat(var a: Float64);
begin
  ReadBuffer(a, SizeOf(a));
end;

{$IFDEF EXTENDED80}
procedure TStreamHelper.ReadFloat(var a: FloatEx);
begin
  ReadBuffer(a, SizeOf(a));
end;
{$ENDIF}

procedure TStreamHelper.ReadDateTime(var a: tDateTime);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadByte(var a: UInt8);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadWord(var a: UInt16);
begin
  ReadBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.ReadLong(var a: UInt32);
begin
  ReadBuffer(a, SizeOf(a));
end;

function TStreamHelper.ReadBool: Boolean;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadChar8: Char8;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadChar16: Char16;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadUCS4Char: Char32;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadUInt8: UInt8;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadUInt16: UInt16;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadUInt32: UInt32;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadUInt64: UInt64;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadInt8: Int8;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadInt16: Int16;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadInt32: Int32;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadInt64: Int64;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadFloat32: Float32;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadFloat64: Float64;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadFloatEx: FloatEx;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadDateTime: tDateTime;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadRecord<T>: T;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadChar: Char16;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadFloat: Float64;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadByte: UInt8;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadWord: UInt16;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadLong: UInt32;
begin
  ReadBuffer(Result, SizeOf(Result));
end;

function TStreamHelper.ReadU32VL: UInt32;
begin
  Result := ReadUInt8;
  if Result = $FE then Result := ReadUInt16
  else if Result = $FF then Result := ReadUInt32;
end;

procedure TStreamHelper.ReadU32VL(var a: UInt32);
begin
  a := ReadU32VL;
end;

function TStreamHelper.ReadU64VL: UInt64;
begin
  Result := ReadUInt8;
  if Result = $FD then Result := ReadUInt16
  else if Result = $FE then Result := ReadUInt32
  else if Result = $FF then Result := ReadUInt64;
end;

procedure TStreamHelper.ReadU64VL(var a: UInt64);
begin
  a := ReadU64VL;
end;

function TStreamHelper.ReadU64VL16: UInt64;
begin
  Result := ReadUInt16;
  if Result = $FFFE then Result := ReadUInt32
  else if Result = $FFFF_FFFF then Result := ReadUInt64;
end;

procedure TStreamHelper.ReadU64VL16(var a: UInt64);
begin
  a := ReadU64VL16;
end;

function TStreamHelper.ReadU64VL32: UInt64;
begin
  Result := ReadUInt32;
  if Result = $FFFF_FFFF then Result := ReadUInt64;
end;

procedure TStreamHelper.ReadU64VL32(var a: UInt64);
begin
  a := ReadU64VL32;
end;
{$ENDREGION}

{$REGION 'WriteData/WriteType/WriteRecord'}
procedure TStreamHelper.WriteBool(const a: Boolean);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteChar8(const a: Char8);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteChar16(const a: Char16);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteUCS4Char(const a: Char32);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteUInt8(const a: UInt8);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteUInt16(const a: UInt16);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteUInt32(const a: UInt32);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteUInt64(const a: UInt64);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteInt8(const a: Int8);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteInt16(const a: Int16);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteInt32(const a: Int32);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteInt64(const a: Int64);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteFloat32(const a: Float32);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteFloat64(const a: Float64);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteFloatEx(const a: FloatEx);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteDateTime(const a: tDateTime);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteRecord<T>({$IFDEF DELPHI_2010}const{$ELSE}var{$ENDIF} a: T);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteChar(const a: Char16);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteFloat(const a: Float64);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteByte(const a: UInt8);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteWord(const a: UInt16);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteLong(const a: UInt32);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteData(const a: Boolean);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteData(const a: Char8);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteData(const a: Char16);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteData(const a: UInt32);
begin
  WriteBuffer(a, SizeOf(a));
end;

procedure TStreamHelper.WriteU32VL(l: UInt32);
begin
  if l < $FE then WriteUInt8(l)
  else if l <= $FFFF then
  begin
    WriteUInt8($FE);
    WriteUInt16(l);
  end else
  begin
    WriteUInt8($FF);
    WriteUInt32(l);
  end;
end;

procedure TStreamHelper.WriteU64VL(l: UInt64);
begin
  if l < $FD then WriteUInt8(l)
  else if l <= $FFFF then
  begin
    WriteUInt8($FD);
    WriteUInt16(l);
  end else if l <= $FFFF_FFFF then
  begin
    WriteUInt8($FE);
    WriteUInt32(l);
  end else
  begin
    WriteUInt8($FF);
    WriteUInt64(l);
  end;
end;

procedure TStreamHelper.WriteU64VL16(l: UInt64);
begin
  if l < $FFFE then WriteUInt16(l) else
  if l <= $FFFF_FFFF then
  begin
    WriteUInt16($FFFE);
    WriteUInt32(l);
  end else
  begin
    WriteUInt16($FFFF);
    WriteUInt64(l);
  end;
end;

procedure TStreamHelper.WriteU64VL32(l: UInt64);
begin
  if l < $FFFF_FFFF then WriteUInt32(l) else
  begin
    WriteUInt32($FFFF_FFFF);
    WriteUInt64(l);
  end;
end;
{$ENDREGION}

{$REGION 'ReadStr'}
{$WARN IMMUTABLE_STRINGS OFF}
procedure TStreamHelper.ReadStr(var s: string; LenChar16: Integer);
begin
  SetLength(s, LenChar16);
  if LenChar16 >= 0 then
    ReadBuffer(PChar(s)^, LenChar16 shl 1);
end;

procedure TStreamHelper.ReadStrA(var s: ByteString; LenChar8: Integer);
begin
  SetLength(s, LenChar8);
  if LenChar8 >= 0 then
    ReadBuffer(PAnsiChar(s)^, LenChar8);
end;

procedure TStreamHelper.ReadUTF8(var s: string; LenChar8: Integer);
var
  s8: UTF8String;
begin
  SetLength(s8, LenChar8);
  if LenChar8 >= 0 then
    ReadBuffer(PAnsiChar(s8)^, LenChar8);
  s := String(s8);
end;

function TStreamHelper.ReadStr(LenChar16: Integer): string;
begin
  SetLength(Result, LenChar16);
  if LenChar16 >= 0 then
    ReadBuffer(PChar(Result)^, LenChar16 shl 1);
end;

function TStreamHelper.ReadStrA(LenChar8: Integer): ByteString;
begin
  SetLength(Result, LenChar8);
  if LenChar8 >= 0 then
    ReadBuffer(PAnsiChar(Result)^, LenChar8);
end;

function TStreamHelper.ReadUTF8(LenChar8: Integer): string;
var
  s8: UTF8String;
begin
  SetLength(s8, LenChar8);
  if LenChar8 >= 0 then
    ReadBuffer(PAnsiChar(s8)^, LenChar8);
  Result := String(s8);
end;

procedure TStreamHelper.ReadStrL(var s: string);
var
  i: integer;
begin
  ReadBuffer(i, Sizeof(i));
  SetLength(s, i);
  if i > 0 then ReadBuffer(PChar(s)^, i shl 1);
end;

procedure TStreamHelper.ReadStrLA(var s: ByteString);
var
  i: integer;
begin
  ReadBuffer(i, Sizeof(i));
  SetLength(s, i);
  if i > 0 then ReadBuffer(PAnsiChar(s)^, i);
end;

procedure TStreamHelper.ReadUTF8L(var s: string);
begin
  var utf8: UTF8String;
  ReadStrLA(ByteString(utf8));
  s := String(utf8);
end;

function TStreamHelper.ReadStrL: string;
begin
  ReadStrL(Result);
end;

function TStreamHelper.ReadStrLA: ByteString;
begin
  ReadStrLA(Result);
end;

function TStreamHelper.ReadUTF8L: string;
begin
  var utf8: UTF8String;
  ReadStrLA(ByteString(utf8));
  Result := String(utf8);
end;

procedure TStreamHelper.ReadStrVLX(var s: string);
begin
  var i: UInt32 := ReadUInt8;
  if i = $FD then
  begin
    i := ReadU32VL;
    var UTF8: UTF8String;
    SetLength(UTF8, i);
    ReadBuffer(UTF8[1], i);
    s := string(UTF8);
  end else
  begin
    if i = $FF then i := ReadUInt32
    else if i = $FE then i := ReadUInt16;
    SetLength(s, i);
    if i > 0 then ReadBuffer(PChar(s)^, i shl 1);
  end;
end;

procedure TStreamHelper.ReadStrVL(var s: string);
var
  i: integer;
begin
  i := ReadU32VL;
  SetLength(s, i);
  if i > 0 then ReadBuffer(PChar(s)^, i shl 1);
end;

procedure TStreamHelper.ReadStrVLA(var s: ByteString);
var
  i: integer;
begin
  i := ReadU32VL;
  SetLength(s, i);
  if i > 0 then ReadBuffer(PAnsiChar(s)^, i);
end;

procedure TStreamHelper.ReadUTF8VL(var s: string);
begin
  var utf8: UTF8String;
  ReadStrVLA(ByteString(utf8));
  s := String(utf8);
end;

function TStreamHelper.ReadStrVLX: string;
begin
  ReadStrVLX(Result);
end;

function TStreamHelper.ReadStrVL: string;
begin
  ReadStrVL(Result);
end;

function TStreamHelper.ReadStrVLA: ByteString;
begin
  ReadStrVLA(Result);
end;

function TStreamHelper.ReadUTF8VL: string;
begin
  var utf8: UTF8String;
  ReadStrVLA(ByteString(utf8));
  Result := String(utf8);
end;
{$WARN IMMUTABLE_STRINGS ON}
{$ENDREGION}

{$REGION 'WriteStr'}
procedure TStreamHelper.WriteStr(const s: string);
begin
  if s <> '' then
    WriteBuffer(PChar(s)^, Length(s) shl 1);
end;

procedure TStreamHelper.WriteStr(const s: string; Start, Len: Integer);
begin
  if Start < 0 then Start := 0;
  if Start >= Length(s) then exit;
  if Len <= 0 then exit;
  if Start + Len > Length(s) then
    Len := Length(s) - Start;
  Write((PChar(s) + Start)^, Len shl 1)
end;

procedure TStreamHelper.WriteStrA(const s: ByteString);
begin
  if s <> '' then
    WriteBuffer(PAnsiChar(s)^, Length(s));
end;

procedure TStreamHelper.WriteStrA(const s: ByteString; Start, Len: Integer);
begin
  if Start < 0 then Start := 0;
  if Start >= Length(s) then exit;
  if Len <= 0 then exit;
  if Start + Len > Length(s) then
    Len := Length(s) - Start;
  Write((PAnsiChar(s) + Start)^, Len shl 1)
end;

procedure TStreamHelper.WriteUTF8(const s: string);
begin
  var utf8 := UTF8String(s);
  WriteStrA(ByteString(utf8));
end;

procedure TStreamHelper.WriteUTF8(const s: string; Start, Len: Integer);
begin
  if Start < 0 then Start := 0;
  if Start >= Length(s) then exit;
  if Len <= 0 then exit;
  if Start + Len > Length(s) then
    Len := Length(s) - Start;
  var utf8 := UTF8String(s.Substring(Start, Len));
  WriteStrA(ByteString(utf8));
end;

procedure TStreamHelper.WriteStrL(const s: string);
begin
  WriteInt32(Length(s));
  if s <> '' then WriteBuffer(pChar(s)^, Length(s) shl 1);
end;

procedure TStreamHelper.WriteStrLA(const s: ByteString);
begin
  WriteInt32(Length(s));
  if s <> '' then WriteBuffer(pAnsiChar(s)^, Length(s));
end;

procedure TStreamHelper.WriteUTF8L(const s: string);
begin
  var utf8 := UTF8String(s);
  WriteStrLA(ByteString(utf8));
end;

procedure TStreamHelper.WriteStrVLX(const s: string);
begin
  var UTF8: UTF8String := UTF8String(s);
  if Length(UTF8) < Length(s) * 2 then
  begin
    WriteUInt8($FD);
    WriteU32VL(Length(UTF8));
    WriteBuffer(PChar8(UTF8)^, Length(UTF8));
  end else
  begin
    var l := Length(s);
    if l < $FD then WriteUInt8(l)
    else if l <= $FFFF then
    begin
      WriteUInt8($FE);
      WriteUInt16(l);
    end else
    begin
      WriteUInt8($FF);
      WriteUInt32(l);
    end;
    if s <> '' then WriteBuffer(pChar(s)^, Length(s) shl 1);
  end;
end;

procedure TStreamHelper.WriteStrVL(const s: string);
begin
  WriteU32VL(Length(s));
  if s <> '' then WriteBuffer(pChar(s)^, Length(s) shl 1);
end;

procedure TStreamHelper.WriteStrVLA(const s: ByteString);
begin
  WriteU32VL(Length(s));
  if s <> '' then WriteBuffer(pAnsiChar(s)^, Length(s));
end;

procedure TStreamHelper.WriteUTF8VL(const s: string);
begin
  var utf8 := UTF8String(s);
  WriteStrVLA(ByteString(utf8));
end;
{$ENDREGION}

{$REGION 'Writeln'}
procedure TStreamHelper.Writeln;
begin
  WriteStr(LineReturn);
end;

procedure TStreamHelper.WritelnA;
begin
  WriteStrA(LineReturn);
end;

procedure TStreamHelper.Writeln(const s: string);
begin
  WriteStr(s);
  Writeln;
end;

procedure TStreamHelper.WritelnA(const s: ByteString);
begin
  WriteStrA(s);
  WritelnA;
end;

procedure TStreamHelper.WriteUTF8Ln(const s: string);
begin
  var utf8 := UTF8String(s);
  WriteStrA(ByteString(utf8));
  WritelnA;
end;
{$ENDREGION}

{$REGION 'Read/Write Tbytes'}
function TStreamHelper.ReadBytes(var Bytes: TBytes; Offset, Count: NInt): NInt;
begin
  Result := Read(Bytes[Offset], ez.Min(Length(Bytes) - Offset, Count));
end;

function TStreamHelper.ReadBytes(var Bytes: TBytes; Count: NInt): NInt;
begin
  SetLength(Bytes, Count);
  if Count > 0
    then Result := Read(Bytes[0], Count)
    else Exit(0);
end;

function TStreamHelper.WriteBytes(const Bytes: TBytes; Offset, Count: NInt): NInt;
begin
  if Offset >= Length(Bytes)
    then Exit(0)
    else Result := Write(Bytes[Offset], ez.Min(Length(Bytes) - Offset, Count));
end;

function TStreamHelper.WriteBytes(const Bytes: TBytes; Count: NInt): NInt;
begin
  if Bytes = nil
    then Exit(0)
    else Result := Write(Bytes[0], ez.Min(Length(Bytes), Count));
end;
{$ENDREGION}
{$ENDREGION}

end.
