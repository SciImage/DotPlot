unit wc.Base.StringWrapper;

// For Delphi 12 and above, since then NativeInt is a weak alias of Integer/Int64, avoiding some mess

{$I wc.Base.inc}
{$INLINE ON}

interface

uses
  System.SysUtils;

type
  _StringWrapper = type string;
  _StringWrapperHelper = record helper for _StringWrapper
    // inlined
    class function Compare(const StrA: string; const StrB: string; Options: TCompareOptions; LocaleID: TLocaleID): Integer;                                                     overload; static; inline;
    class function Compare(const StrA: string; IndexA: Integer; const StrB: string; IndexB: Integer; Length: Integer; Options: TCompareOptions; LocaleID: TLocaleID): Integer;  overload; static; inline;
    class function Join(const Separator: string; const Values: IEnumerator<string>): string;                                            overload; static; inline;
    class function StartsText(const ASubText, AText: string): Boolean;                                                                  static; inline;
    class function EndsText(const ASubText, AText: string): Boolean;                                                                    static; inline;
    // not inlined
    class function Join(const Separator: string; const Values: array of const): string;                                                 overload; static;
    class function Join(const Separator: string; const Values: array of string; StartIndex: Integer; Count: Integer): string;           overload; static;
(*
    class function Create(C: Char; Count: Integer): string;                                                                                                                     overload; static; inline;
    class function Create(const Value: array of Char; StartIndex: Integer; Length: Integer): string;                                                                            overload; static;
    class function Create(const Value: array of Char): string;                                                                                                                  overload; static;
    class function Copy(const Str: string): string;                                                                                     static; inline;
    class function Format(const Format: string; const args: array of const): string;                                                    overload; static;
    class function Equals(const a: string; const b: string): Boolean;                                                                   overload; static; inline;
    class function IsNullOrEmpty(const Value: string): Boolean;                                                                         static; inline;
    class function IsNullOrWhiteSpace(const Value: string): Boolean;                                                                    static; inline;
    class function CompareOrdinal(const StrA: string; const StrB: string): Integer;                                                     overload; static; inline;
    class function CompareOrdinal(const StrA: string; IndexA: Integer; const StrB: string; IndexB: Integer; Length: Integer): Integer;  overload; static; inline;
    class function CompareText(const StrA: string; const StrB: string): Integer;                                                        static; inline;
    class function Parse(const Value: Boolean): string;                                                                                 overload; static; inline;
    class function Parse(const Value: Extended): string;                                                                                overload; static; inline;
    class function Parse(const Value: Int64): string;                                                                                   overload; static; inline;
    class function Parse(const Value: Integer): string;                                                                                 overload; static; inline;
    class function ToBoolean(const S: string): Boolean;                                                                                 overload; static; inline;
    class function ToDouble(const S: string): Double;                                                                                   overload; static; inline;
    class function ToExtended(const S: string): Extended;                                                                               overload; static; inline;
    class function ToInt64(const S: string): Int64;                                                                                     overload; static; inline;
    class function ToInteger(const S: string): Integer;                                                                                 overload; static; inline;
    class function ToSingle(const S: string): Single;                                                                                   overload; static; inline;
    class function LowerCase(const S: string; LocaleOptions: TLocaleOptions): string;                                                   overload; static; inline;
    class function LowerCase(const S: string): string;                                                                                  overload; static; inline;
    class function UpperCase(const S: string; LocaleOptions: TLocaleOptions): string;                                                   overload; static; inline;
    class function UpperCase(const S: string): string;                                                                                  overload; static; inline;
    class function Compare(const StrA: string; const StrB: string; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;                                                          overload; static; inline; //deprecated 'Use same with TCompareOptions';
    class function Compare(const StrA: string; const StrB: string; IgnoreCase: Boolean): Integer;                                                                               overload; static; inline; //deprecated 'Use same with TCompareOptions';
    class function Compare(const StrA: string; const StrB: string; LocaleID: TLocaleID): Integer;                                                                               overload; static; inline;
    class function Compare(const StrA: string; const StrB: string; Options: TCompareOptions): Integer;                                                                          overload; static; inline;
    class function Compare(const StrA: string; const StrB: string): Integer;                                                                                                    overload; static; inline;
    class function Compare(const StrA: string; IndexA: Integer; const StrB: string; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;       overload; static; inline; //deprecated 'Use same with TCompareOptions';
    class function Compare(const StrA: string; IndexA: Integer; const StrB: string; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer;                            overload; static; inline; //deprecated 'Use same with TCompareOptions';
    class function Compare(const StrA: string; IndexA: Integer; const StrB: string; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer;                            overload; static; inline;
    class function Compare(const StrA: string; IndexA: Integer; const StrB: string; IndexB: Integer; Length: Integer; Options: TCompareOptions): Integer;                       overload; static; inline;
    class function Compare(const StrA: string; IndexA: Integer; const StrB: string; IndexB: Integer; Length: Integer): Integer;                                                 overload; static; inline;
    class function Join(const Separator: string; const Values: IEnumerable<string>): string;                                            overload; static; inline;
    class function Join(const Separator: string; const Values: array of string): string;                                                overload; static;
*)
    // inlined;
    function GetHashCode: Integer;                                                                                                      inline;
    function LastIndexOf(Value: Char; StartIndex: Integer; Count: Integer): Integer;                                                    overload; inline;
    function LastIndexOf(const Value: string; StartIndex: Integer; Count: Integer): Integer;                                            overload; inline;
    function LastDelimiter(const Delims: TSysCharSet): Integer;                                                                         inline;
    function DeQuotedString(const QuoteChar: Char): string;                                                                             inline;
    function QuotedString(const QuoteChar: Char): string;                                                                               inline;
    function ToLower(LocaleID: TLocaleID): string;                                                                                      inline;
    function ToLowerInvariant: string;                                                                                                  inline;
    function ToUpper(LocaleID: TLocaleID): string;                                                                                      inline;
    function ToUpperInvariant: string;                                                                                                  inline;
    // not inlined
    function IndexOfAny(const AnyOf: array of Char; StartIndex: Integer; Count: Integer): Integer;
    function IndexOfAnyUnquoted(const AnyOf: array of Char; StartQuote, EndQuote: Char; StartIndex: Integer; Count: Integer): Integer;
    function LastIndexOfAny(const AnyOf: array of Char; StartIndex: Integer; Count: Integer): Integer;
    function Trim(const TrimChars: array of Char): string;
    function TrimLeft(const TrimChars: array of Char): string;
    function TrimRight(const TrimChars: array of Char): string;
    function Split(const Separator: array of Char; Count: Integer; Options: TStringSplitOptions): TArray<string>;                               overload;
    function Split(const Separator: array of string; Count: Integer; Options: TStringSplitOptions): TArray<string>;                             overload;
    function Split(const Separator: array of Char; QuoteStart, QuoteEnd: Char; Count: Integer; Options: TStringSplitOptions): TArray<string>;   overload;
    function Split(const Separator: array of string; QuoteStart, QuoteEnd: Char; Count: Integer; Options: TStringSplitOptions): TArray<string>; overload;
(*
    procedure CopyTo(SourceIndex: Integer; var destination: array of Char; DestinationIndex: Integer; Count: Integer);
    function CompareTo(const strB: string): Integer;
    function Contains(const Value: string): Boolean;
    function CountChar(const C: Char): Integer;
    function DeQuotedString: string; overload;
    function EndsWith(const Value: string): Boolean; overload; inline;
    function EndsWith(const Value: string; IgnoreCase: Boolean): Boolean; overload;
    function Equals(const Value: string): Boolean; overload;
    function IndexOf(Value: Char): Integer; overload;
    function IndexOf(const Value: string): Integer; overload; inline;
    function IndexOf(Value: Char; StartIndex: Integer): Integer; overload;
    function IndexOf(const Value: string; StartIndex: Integer): Integer; overload;
    function IndexOf(Value: Char; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOf(const Value: string; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOfAny(const AnyOf: array of Char): Integer; overload;
    function IndexOfAny(const AnyOf: array of Char; StartIndex: Integer): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of Char; StartQuote, EndQuote: Char): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of Char; StartQuote, EndQuote: Char; StartIndex: Integer): Integer; overload;
    function Insert(StartIndex: Integer; const Value: string): string;
    function IsDelimiter(const Delimiters: string; Index: Integer): Boolean;
    function IsEmpty: Boolean; inline;
    function LastDelimiter(const Delims: string): Integer; overload;
    function LastIndexOf(Value: Char): Integer; overload;
    function LastIndexOf(const Value: string): Integer; overload;
    function LastIndexOf(Value: Char; StartIndex: Integer): Integer; overload;
    function LastIndexOf(const Value: string; StartIndex: Integer): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of Char): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of Char; StartIndex: Integer): Integer; overload;
    function PadLeft(TotalWidth: Integer): string; overload; inline;
    function PadLeft(TotalWidth: Integer; PaddingChar: Char): string; overload; inline;
    function PadRight(TotalWidth: Integer): string; overload; inline;
    function PadRight(TotalWidth: Integer; PaddingChar: Char): string; overload; inline;
    function QuotedString: string; overload;
    function Remove(StartIndex: Integer): string; overload; inline;
    function Remove(StartIndex: Integer; Count: Integer): string; overload; inline;
    function Replace(OldChar: Char; NewChar: Char): string; overload;
    function Replace(OldChar: Char; NewChar: Char; ReplaceFlags: TReplaceFlags): string; overload;
    function Replace(const OldValue: string; const NewValue: string): string; overload;
    function Replace(const OldValue: string; const NewValue: string; ReplaceFlags: TReplaceFlags): string; overload;
    function Split(const Separator: array of Char): TArray<string>; overload;
    function Split(const Separator: array of Char; Count: Integer): TArray<string>; overload;
    function Split(const Separator: array of Char; Options: TStringSplitOptions): TArray<string>; overload;
    function Split(const Separator: array of string): TArray<string>; overload;
    function Split(const Separator: array of string; Count: Integer): TArray<string>; overload;
    function Split(const Separator: array of string; Options: TStringSplitOptions): TArray<string>; overload;
    function Split(const Separator: array of Char; Quote: Char): TArray<string>; overload;
    function Split(const Separator: array of Char; QuoteStart, QuoteEnd: Char): TArray<string>; overload;
    function Split(const Separator: array of Char; QuoteStart, QuoteEnd: Char; Options: TStringSplitOptions): TArray<string>; overload;
    function Split(const Separator: array of Char; QuoteStart, QuoteEnd: Char; Count: Integer): TArray<string>; overload;
    function Split(const Separator: array of string; Quote: Char): TArray<string>; overload;
    function Split(const Separator: array of string; QuoteStart, QuoteEnd: Char): TArray<string>; overload;
    function Split(const Separator: array of string; QuoteStart, QuoteEnd: Char; Options: TStringSplitOptions): TArray<string>; overload;
    function Split(const Separator: array of string; QuoteStart, QuoteEnd: Char; Count: Integer): TArray<string>; overload;
    function StartsWith(const Value: string): Boolean; overload; inline;
    function StartsWith(const Value: string; IgnoreCase: Boolean): Boolean; overload;
    function Substring(StartIndex: Integer): string; overload; inline;
    function Substring(StartIndex: Integer; Length: Integer): string; overload; inline;
    function ToBoolean: Boolean; overload; inline;
    function ToInteger: Integer; overload; inline;
    function ToInt64: Int64; overload; inline;
    function ToSingle: Single; overload; inline;
    function ToDouble: Double; overload; inline;
    function ToExtended: Extended; overload; inline;
    function ToCharArray: TArray<Char>; overload;
    function ToCharArray(StartIndex: Integer; Length: Integer): TArray<Char>; overload;
    function ToLower: string; overload; inline;
    function ToUpper: string; overload; inline;
    function Trim: string; overload;
    function TrimLeft: string; overload;
    function TrimRight: string; overload;
    function TrimEnd(const TrimChars: array of Char): string; deprecated 'Use TrimRight';
    function TrimStart(const TrimChars: array of Char): string; deprecated 'Use TrimLeft';
    property Chars[Index: Integer]: Char read GetChars;
    property Length: Integer read GetLength;
*)
  end;

implementation

{$REGION 'Delphi Built-in class methods'}
class function _StringWrapperHelper.Join(const Separator: string; const Values: array of const): string;
begin
  Result := String.Join(Separator, Values);
end;

class function _StringWrapperHelper.Join(const Separator: string; const Values: array of string; StartIndex: Integer; Count: Integer): string;
begin
  Result := String.Join(Separator, Values, StartIndex, Count);
end;

class function _StringWrapperHelper.Join(const Separator: string; const Values: IEnumerator<string>): string;
begin
  Result := String.Join(Separator, Values);
end;
{
class function _StringWrapperHelper.Compare(const StrA: string; const StrB: string): Integer;
begin
  Result := String.Compare(StrA, StrB);
end;

class function _StringWrapperHelper.Compare(const StrA: string; const StrB: string; IgnoreCase: Boolean): Integer;
begin
  Result := String.Compare(StrA, StrB, IgnoreCase);
end;

class function _StringWrapperHelper.Compare(const StrA: string; IndexA: Integer; const StrB: string; IndexB: Integer; Length: Integer): Integer;
begin
  Result := String.Compare(StrA, IndexA, StrB, IndexB, Length);
end;

class function _StringWrapperHelper.Compare(const StrA: string; IndexA: Integer; const StrB: string; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer;
begin
  Result := String.Compare(StrA, IndexA, StrB, IndexB, Length, IgnoreCase);
end;

class function _StringWrapperHelper.Compare(const StrA: string; const StrB: string; LocaleID: TLocaleID): Integer;
begin
  Result := String.Compare(StrA, StrB, LocaleID);
end;

class function _StringWrapperHelper.Compare(const StrA: string; const StrB: string; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin
  Result := String.Compare(StrA, StrB, IgnoreCase, LocaleID);
end;

class function _StringWrapperHelper.Compare(const StrA: string; IndexA: Integer; const StrB: string; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer;
begin
  Result := String.Compare(StrA, IndexA, StrB, IndexB, Length, LocaleID);
end;

class function _StringWrapperHelper.Compare(const StrA: string; IndexA: Integer; const StrB: string; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin
  Result := String.Compare(StrA, IndexA, StrB, IndexB, Length, IgnoreCase, LocaleID);
end;

class function _StringWrapperHelper.Compare(const StrA: string; const StrB: string; Options: TCompareOptions): Integer;
begin
  Result := String.Compare(StrA, StrB, Options);
end;

class function _StringWrapperHelper.Compare(const StrA: string; IndexA: Integer; const StrB: string; IndexB: Integer; Length: Integer; Options: TCompareOptions): Integer;
begin
  Result := String.Compare(StrA, IndexA, StrB, IndexB, Length, Options);
end;
}
class function _StringWrapperHelper.Compare(const StrA: string; const StrB: string; Options: TCompareOptions; LocaleID: TLocaleID): Integer;
begin
  Result := String.Compare(StrA, StrB, Options, LocaleID);
end;

class function _StringWrapperHelper.Compare(const StrA: string; IndexA: Integer; const StrB: string; IndexB: Integer; Length: Integer; Options: TCompareOptions; LocaleID: TLocaleID): Integer;
begin
  Result := String.Compare(StrA, IndexA, StrB, IndexB, Length, Options, LocaleID);
end;

class function _StringWrapperHelper.StartsText(const ASubText, AText: string): Boolean;
begin
  Result := String.StartsText(ASubText, AText);
end;

class function _StringWrapperHelper.EndsText(const ASubText, AText: string): Boolean;
begin
  Result := String.EndsText(ASubText, AText);
end;
{$ENDREGION}

function _StringWrapperHelper.GetHashCode: Integer;
begin
  Result := string(Self).GetHashCode;
end;

function _StringWrapperHelper.LastIndexOf(const Value: string; StartIndex, Count: Integer): Integer;
begin
  Result := string(Self).LastIndexOf(Value, StartIndex, Count);
end;

function _StringWrapperHelper.LastIndexOf(Value: Char; StartIndex, Count: Integer): Integer;
begin
  Result := string(Self).LastIndexOf(Value, StartIndex, Count);
end;

function _StringWrapperHelper.IndexOfAny(const AnyOf: array of Char; StartIndex,
  Count: Integer): Integer;
begin
  Result := string(Self).IndexOfAny(AnyOf, StartIndex, Count);
end;

function _StringWrapperHelper.IndexOfAnyUnquoted(const AnyOf: array of Char; StartQuote, EndQuote: Char; StartIndex: Integer; Count: Integer): Integer;
begin
  Result := string(Self).IndexOfAnyUnquoted(AnyOf, StartQuote, EndQuote, StartIndex, Count);
end;

function _StringWrapperHelper.LastIndexOfAny(const AnyOf: array of Char; StartIndex,
  Count: Integer): Integer;
begin
  Result := string(Self).LastIndexOfAny(AnyOf, StartIndex, Count);
end;

function _StringWrapperHelper.Trim(const TrimChars: array of Char): string;
begin
  Result := string(Self).Trim(TrimChars);
end;

function _StringWrapperHelper.TrimLeft(const TrimChars: array of Char): string;
begin
  Result := string(Self).TrimLeft(TrimChars);
end;

function _StringWrapperHelper.TrimRight(const TrimChars: array of Char): string;
begin
  Result := string(Self).TrimRight(TrimChars);
end;

function _StringWrapperHelper.LastDelimiter(const Delims: TSysCharSet): Integer;
begin
  Result := string(Self).LastDelimiter(Delims);
end;

function _StringWrapperHelper.DeQuotedString(const QuoteChar: Char): string;
begin
  Result := string(Self).DeQuotedString(QuoteChar);
end;

function _StringWrapperHelper.QuotedString(const QuoteChar: Char): string;
begin
  Result := string(Self).QuotedString(QuoteChar);
end;

function _StringWrapperHelper.Split(const Separator: array of Char; Count: Integer;
  Options: TStringSplitOptions): TArray<string>;
begin
  Result := String(Self).Split(Separator, Count, Options);
end;

function _StringWrapperHelper.Split(const Separator: array of string; Count: Integer;
  Options: TStringSplitOptions): TArray<string>;
begin
  Result := String(Self).Split(Separator, Count, Options);
end;

function _StringWrapperHelper.Split(const Separator: array of Char; QuoteStart, QuoteEnd: Char;
  Count: Integer; Options: TStringSplitOptions): TArray<string>;
begin
  Result := String(Self).Split(Separator, QuoteStart, QuoteEnd, Count, Options);
end;

function _StringWrapperHelper.Split(const Separator: array of string; QuoteStart, QuoteEnd: Char;
  Count: Integer; Options: TStringSplitOptions): TArray<string>;
begin
  Result := String(Self).Split(Separator, QuoteStart, QuoteEnd, Count, Options);
end;

function _StringWrapperHelper.ToLower(LocaleID: TLocaleID): string;
begin
  Result := String(Self).ToLower(LocaleID);
end;

function _StringWrapperHelper.ToLowerInvariant: string;
begin
  Result := String(Self).ToLowerInvariant;
end;

function _StringWrapperHelper.ToUpper(LocaleID: TLocaleID): string;
begin
  Result := String(Self).ToUpper(LocaleID);
end;

function _StringWrapperHelper.ToUpperInvariant: string;
begin
  Result := String(Self).ToUpperInvariant;
end;


end.
