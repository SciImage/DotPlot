unit wc.Types;

// For Delphi 12 and above, since then NativeInt is a weak alias of Integer/Int64, avoiding some mess

{$I wc.Base.inc}
// see wc.Types.help and wc.Base.help for some techincal backgrounds

interface

uses
  Types;        // Ideally, this unit should be independent of wc.Base, System.SysUtils, and System.Classes

const
{$REGION 'Constants'}
  /// <summary>
  ///   SystemIsBigEndian is a constant indicating the endianness of the platform.
  /// </summary>
  SystemIsBigEndian = {$IFDEF BIGENDIAN} True; {$ELSE} False; {$ENDIF}
  /// <summary>
  ///   PointerSize is a constant indicating the size of the pointer types.
  /// </summary>
  PointerSize       = Sizeof(Pointer);
  /// <summary>
  /// Delphi limits the size to 2GB - 1. So the range is 0 .. 2GB - 2;
  /// </summary>
  MaxFixedArraySize = High(Integer);
{$IFDEF CPU64}
  /// <summary>
  /// ByteStrings has a 12-byte header (System.StrRec, padded to 16 bytes) and need one more for #0 at the end
  /// </summary>
  MaxByteStringLength = High(Integer) - 16 - 1;
  /// <summary>
  /// Strings has a 12-byte header (System.StrRec, padded to 16 bytes) and need two more bytes for #0 at the end
  /// </summary>
  MaxStringLength     = (High(Integer) - 16) div 2 - 1;
  /// <summary>
  /// Dynamic array has a 12-byte header (System.TDynArrayRec, padded to 16 bytes)
  /// </summary>
  MaxDynamicArraySize = High(NativeInt) - 16;
{$ELSE}
  /// <summary>
  /// ByteStrings has a 12-byte header (System.StrRec) and need one more for #0 at the end
  /// </summary>
  MaxByteStringLength = High(Integer) - 12 - 1;
  /// <summary>
  /// Strings has a 12-byte header (System.StrRec) and need two more bytes for #0 at the end
  /// </summary>
  MaxStringLength     = (High(Integer) - 12) div 2 - 1;
  /// <summary>
  /// Dynamic array has a 8-byte header (System.TDynArrayRec)
  /// </summary>
  MaxDynamicArraySize = High(NativeInt) - 8;
{$ENDIF}

{$ENDREGION}

type
{$REGION 'Integer & Integer Array Types'}
(* Delphi interger types is a mess - they are inconsistent across verion and platform.

   The sizes of Integer, Cardinal, LongWord, and LongInt are platform-depedent
   NativeInt is 8-bytes in Delphi 7-2007 because the C++ version was so.
   Comparing two NativeUInts causes W1023 comparing signed and unsigned warning in 2009.
   Integer and LongInt is interchangable, but not with NativeInt in Win32.
   Int64 and LongInt, NativeInt is not interchangable in Win64.
   NativeInt can be for-loop varible in Win64. Int64 can be for-loop varible only in XE8 and later.
   Property index must be interger before Dephi 12.

   To avoid confusion and be consistent, use the following as defined in System.pas
     Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64
   For native int types, use NInt and NUInt defined here
*)

  // Int8 (ShortInt), Int16 (SmallInt), Int32 (Integer), UInt8 (Byte),
  // UInt16 (Word), and UInt32 (Cardinal) are defined in System.pas

  // PInt64, PUInt32, PUInt64 are defined in System.pas
  /// <summary>PInt8 is an alias type of PShortInt.</summary>
  PInt8         = PShortInt;
  /// <summary>PUInt8 is an alias type of PByte.</summary>
  PUInt8        = PByte;
  /// <summary>PInt16 is an alias type of PSmallInt.</summary>
  PInt16        = PShortInt;
  /// <summary>PUInt16 is an alias type of PWord.</summary>
  PUInt16       = PWord;
  /// <summary>PInt32 is an alias type of PInteger.</summary>
  PInt32        = PInteger;
  /// <summary>PUInt32 is an alias type of PCardinal.</summary>
  PUInt32       = PCardinal;            // PUint32 is also defined in System.pas

  /// <summary>TInt8s is an alias type of TShortIntDynArray.</summary>
  TInt8s        = TShortIntDynArray;
  // TBytes in Sysutils is heavily used and more useful than TByteDynArray
  // But they are interchangable thanks to the compatiblity of generic types
  /// <summary>TUInt8s is an alias type of TByteDynArray.</summary>
  TUInt8s       = TByteDynArray;
  /// <summary>TInt16s is an alias type of TSmallIntDynArray.</summary>
  TInt16s       = TSmallIntDynArray;
  /// <summary>TUInt16s is an alias type of TWordDynArray.</summary>
  TUInt16s      = TWordDynArray;
  /// <summary>TInt32s is an alias type of TIntegerDynArray.</summary>
  TInt32s       = TIntegerDynArray;
  /// <summary>TUInt32s is an alias type of TCardinalDynArray.</summary>
  TUInt32s      = TCardinalDynArray;
  /// <summary>TInt64s is an alias type of TInt64DynArray.</summary>
  TInt64s       = TInt64DynArray;
  /// <summary>TUInt64s is an alias type of TUInt64DynArray.</summary>
  TUInt64s      = TUInt64DynArray;

  /// <summary>PInt8s is pointer type for referencing a TInt8s variable.</summary>
  PInt8s        = ^TInt8s;
  /// <summary>PUInt8s is pointer type for referencing a TUInt8s variable.</summary>
  PUInt8s       = ^TUInt8s;
  /// <summary>PInt16s is pointer type for referencing a TInt16s variable.</summary>
  PInt16s       = ^TInt16s;
  /// <summary>PUInt16s is pointer type for referencing a TUInt16s variable.</summary>
  PUInt16s      = ^TUInt16s;
  /// <summary>PInt32s is pointer type for referencing a TInt32s variable.</summary>
  PInt32s       = ^TInt32s;
  /// <summary>PUInt32s is pointer type for referencing a TUInt32s variable.</summary>
  PUInt32s      = ^TUInt32s;
  /// <summary>PInt64s is pointer type for referencing a TInt64s variable.</summary>
  PInt64s       = ^TInt64s;
  /// <summary>PUInt64s is pointer type for referencing a TUInt64s variable.</summary>
  PUInt64s      = ^TUInt64s;

  // System.pas and SysUtils.pas defines some fixed-length array types but lack consistency
  // Types here are all 2 GB in storage. They are for type-cast and not for direct use.

  /// <summary>TInt8Array is a 2-GB array type for Int8. It is for type-casting only.</summary>
  TInt8Array   = array[0..$7FFFFFFF div sizeof(Int8)  - 1]  of Int8;
  /// <summary>TUInt8Array is a 2-GB array type for UInt8. It is for type-casting only.</summary>
  TUInt8Array  = array[0..$7FFFFFFF div sizeof(UInt8) - 1]  of UInt8;
  /// <summary>TInt16Array is a 2-GB array type for Int16. It is for type-casting only.</summary>
  TInt16Array  = array[0..$7FFFFFFF div sizeof(Int16) -1] of Int16;
  /// <summary>TUInt16Array is a 2-GB array type for UInt16. It is for type-casting only.</summary>
  TUInt16Array = array[0..$7FFFFFFF div sizeof(UInt16) - 1] of UInt16;
  /// <summary>TInt32Array is a 2-GB array type for Int32. It is for type-casting only.</summary>
  TInt32Array  = array[0..$7FFFFFFF div sizeof(Int32)  - 1] of Int32;
  /// <summary>TUInt32Array is a 2-GB array type for UInt32. It is for type-casting only.</summary>
  TUInt32Array = array[0..$7FFFFFFF div sizeof(UInt32) - 1] of UInt32;
  /// <summary>TInt64Array is a 2-GB array type for Int64. It is for type-casting only.</summary>
  TInt64Array  = array[0..$7FFFFFFF div sizeof(Int64)  - 1] of Int64;
  /// <summary>TUInt64Array is a 2-GB array type for UInt64. It is for type-casting only.</summary>
  TUInt64Array = array[0..$7FFFFFFF div sizeof(UInt64) - 1] of UInt64;

  /// <summary>PInt8Array is pointer type for referencing a TInt8Array variable.</summary>
  PInt8Array    = ^TInt8Array;
  /// <summary>PUInt8Array is pointer type for referencing a TUInt8Array variable.</summary>
  PUInt8Array   = ^TUInt8Array;
  /// <summary>PInt16Array is pointer type for referencing a TInt16Array variable.</summary>
  PInt16Array   = ^TInt16Array;
  /// <summary>PUInt16Array is pointer type for referencing a TUInt16Array variable.</summary>
  PUInt16Array  = ^TUInt16Array;
  /// <summary>PInt32Array is pointer type for referencing a TInt32Array variable.</summary>
  PInt32Array   = ^TInt32Array;
  /// <summary>PUInt32Array is pointer type for referencing a TUInt32Array variable.</summary>
  PUInt32Array  = ^TUInt32Array;
  /// <summary>PInt64Array is pointer type for referencing a TInt64Array variable.</summary>
  PInt64Array   = ^TInt64Array;
  /// <summary>PUInt64Array is pointer type for referencing a TUInt64Array variable.</summary>
  PUInt64Array  = ^TUInt64Array;

{$REGION 'NInt/NUInt Types'}
  // Since Delphi 12 Athens, NativeInt and NativeNInt became weak alias as they should be.
  // NInt and NUInt therefore defines as alias for all Delphi versions.
{$IFDEF CPU64}
  /// <summary>NInt is an alias type of Int64.</summary>
  NInt          = Int64;
  /// <summary>NUInt is an alias type of UInt64.</summary>
  NUInt         = UInt64;
  /// <summary>NInt is an alias type of Int64.</summary>
  XNInt         = Int32;
  /// <summary>NUInt is an alias type of UInt64.</summary>
  XNUInt        = UInt32;
  /// <summary>PNInt is an alias type of PInt64.</summary>
  PNInt         = PInt64;
  /// <summary>PNUInt is an alias type of PUInt64.</summary>
  PNUInt        = PUInt64;
  /// <summary>TNInts is an alias type of TInt64s.</summary>
  TNInts        = TInt64DynArray;
  /// <summary>TNUInts is an alias type of TUInt64s.</summary>
  TNUInts       = TUInt64DynArray;
  /// <summary>TNIntArray is an alias type of TInt64Array.</summary>
  TNIntArray    = TInt64Array;
  /// <summary>TNUIntArray is an alias type of TUInt64Array.</summary>
  TNUIntArray   = TUInt64Array;
  /// <summary>PNIntArray is an alias type of PInt64Array.</summary>
  PNIntArray    = PInt64Array;
  /// <summary>PNUIntArray is an alias type of PUInt64Array.</summary>
  PNUIntArray   = PUInt64Array;
  /// <summary>PNInts is an alias type of PInt64s.</summary>
  PNInts        = PInt64s;
  /// <summary>PNUInts is an alias type of PUInt64s.</summary>
  PNUInts       = PUInt64s;
{$ELSE}
  /// <summary>NInt is an alias type of Int32.</summary>
  NInt          = Int32;
  /// <summary>NUInt is an alias type of UInt32.</summary>
  NUInt         = UInt32;
  /// <summary>NInt is an alias type of Int64.</summary>
  XNInt         = Int64;
  /// <summary>NUInt is an alias type of UInt64.</summary>
  XNUInt        = UInt64;
  /// <summary>PNInt is an alias type of PInt32.</summary>
  PNInt         = PInt32;
  /// <summary>PNUInt is an alias type of PUInt32.</summary>
  PNUInt        = PUInt32;
  /// <summary>TNInts is an alias type of TInt32s.</summary>
  TNInts        = TIntegerDynArray;
  /// <summary>TNUInts is an alias type of TUInt32s.</summary>
  TNUInts       = TCardinalDynArray;
  /// <summary>TNIntArray is an alias type of TInt32Array.</summary>
  TNIntArray    = TInt64Array;
  /// <summary>TNUIntArray is an alias type of TUInt32Array.</summary>
  TNUIntArray   = TUInt64Array;
  /// <summary>PNIntArray is an alias type of PInt32Array.</summary>
  PNIntArray    = PInt32Array;
  /// <summary>PNUIntArray is an alias type of PUInt32Array.</summary>
  PNUIntArray   = PUInt32Array;
  /// <summary>PNInts is an alias type of PInt32s.</summary>
  PNInts        = PInt32s;
  /// <summary>PNUInts is an alias type of PUInt32s.</summary>
  PNUInts       = PUInt32s;
{$ENDIF}
{$ENDREGION}
{$ENDREGION}

{$REGION 'Boolean and Boolean Arrays Types'}
  // Boolean uses 1 as true. ByteBool, WordBool, and LongBool use -1 as True.
  // So Boolean and ByteBool are different.
  /// <summary>Bool is an alias type of Boolean.</summary>
  Bool          = Boolean;
{$ENDREGION}

{$REGION 'Char and Char Array Types'}
  /// <summary>Char8 is an alias type of AnsiChar.</summary>
  Char8         = AnsiChar;
  /// <summary>Char16 is an alias type of Char.</summary>
  Char16        = Char;
  /// <summary>Char32 is an alias type of UCS4Char.</summary>
  Char32        = type UCS4Char;
  /// <summary>PChar8 is an alias type of PAnsiChar.</summary>
  PChar8        = PAnsiChar;
  /// <summary>PChar16 is an alias type of PChar.</summary>
  PChar16       = PChar;
  /// <summary>PChar32 is pointer type for referencing a Char32 variable.</summary>
  PChar32       = ^Char32;
  /// <summary>TChar8s is a type for dynamic array of Char8s.</summary>
  TChar8s       = TArray<Char8>;
  /// <summary>TChar16s is a type for dynamic array of Char16s.</summary>
  TChar16s      = TArray<Char16>;
  /// <summary>TChar32s is a type for dynamic array of Char32s.</summary>
  TChar32s      = TArray<Char32>;
{$ENDREGION}

{$REGION 'Float and Float Array Types'}
(* Float types can have many size, but only 32- and 64-bit float numbers are supported
   by all platforms. X86 (32-bit mode) use 80-bit FPU for calculation but the results
   can be stored as 32/64/80-bit. FPU is available in Win64/MacOS64 but is not used.
   Instead, SSE/AVX are used. These SIMD instructions supports 32 and 64 bit.
   In Delphi, the Extended type is defined differently for different platform, and can be
   64 or 80-bit in precision and 8, 10, 12, or 16-byte in storage.
*)
  /// <summary>Float32 is an alias type of Single.</summary>
  Float32       = Single;                       // 1s:08e:23m Float
  /// <summary>Float64 is an alias type of Double.</summary>
  Float64       = Double;                       // 1s:11e:52m double
  /// <summary>FloatEx is an alias type of Extended.</summary>
  FloatEx       = Extended;                     // 1s:15e:64m long double, no hidden bit
  /// <summary>PFloat32 is an alias type of PSingle.</summary>
  PFloat32      = PSingle;
  /// <summary>PFloat64 is an alias type of PDouble.</summary>
  PFloat64      = PDouble;
  /// <summary>PFloatEx is an alias type of PExtended.</summary>
  PFloatEx      = PExtended;
  /// <summary>TFloat32s is an alias type of TSingleDynArray.</summary>
  TFloat32s     = TSingleDynArray;
  /// <summary>TFloat64s is an alias type of TDoubleDynArray.</summary>
  TFloat64s     = TDoubleDynArray;
  /// <summary>TFloatExs is a type for dynamic array of FloatExs.</summary>
  TFloatExs     = TArray<FloatEx>;
  /// <summary>PFloat32s is pointer type for referencing a PFloat64s variable.</summary>
  PFloat32s     = ^TFloat32s;
  /// <summary>PFloat64s is pointer type for referencing a TFloat64s variable.</summary>
  PFloat64s     = ^TFloat64s;
  /// <summary>PFloatExs is pointer type for referencing a TFloatExs variable.</summary>
  PFloatExs     = ^TFloatExs;

  /// <summary>TFloat32Array is a 2-GB array type for Float32. It is for type-casting only.</summary>
  TFloat32Array = array[0..$7FFFFFFF div SizeOf(Float32)-1] of Float32;
  /// <summary>TFloat64Array is a 2-GB array type for Float64. It is for type-casting only.</summary>
  TFloat64Array = array[0..$7FFFFFFF div SizeOf(Float64)-1] of Float64;
  /// <summary>TFloat64Array is a 2-GB array type for FloatEx. It is for type-casting only.</summary>
  TFloatExArray = array[0..$7FFFFFFF div SizeOf(FloatEx)-1] of FloatEx;

  /// <summary>PFloat32Array is pointer type for referencing a TFloat32Array variable.</summary>
  PFloat32Array = ^TFloat32Array;
  /// <summary>PFloat64Array is pointer type for referencing a TFloat64Array variable.</summary>
  PFloat64Array = ^TFloat64Array;
  /// <summary>PFloatExArray is pointer type for referencing a TFloatExArray variable.</summary>
  PFloatExArray = ^TFloatExArray;

  {$IFDEF EXTENDED80}
  Float         = Extended;
  PFloat        = PExtended;
  TFloats       = TFloatExs;
  PFloats       = PFloatExs;
  TFloatArray   = TFloatExArray;
  PFloatArray   = PFloatExArray;
  {$ELSE}
  Float         = Double;
  PFloat        = PDouble;
  TFloats       = TFloat64s;
  PFloats       = PFloat64s;
  TFloatArray   = TFloat64Array;
  PFloatArray   = PFloat64Array;
  {$ENDIF}

  Complex32 = record
    Real, Imaginary: Float32;
  end;
  PComplex32 = ^Complex32;

  Complex64 = record
    Real, Imaginary: Float64;
  end;
  PComplex64 = ^Complex64;
{$ENDREGION}

{$REGION 'Math Consts'}
  Constant = record
    const
      Pi                = 3.141592653589793238462643383280;
      Two_Pi            = 6.283185307179586476925286766559;
      Half_Pi           = 1.570796326794896619231321691640;
      Three_Half_Pi       = 4.712388980384689857693965074919;
      Inv_Pi            = 0.318309886183790671537767526745;
      Inv_2_Pi          = 0.159154943091895335768883763373;
      RadianPerDegree   = 0.017453292519943295769236907684886;
      DegreePerRadian   = 57.29577951308232087679815481410517;
      Sqrt_2            = 1.414213562373095048801688724210;
      Sqrt_3            = 1.732050807568877293527446341506;
      Sqrt_5            = 2.236067977499789696409173668731;
      Half_Sqrt_2       = 0.707106781186547524400844362105;
      Half_Sqrt_3       = 0.866025403784438646763723170753;
      Half_Sqrt_5       = 1.118033988749894848204586834366;
      Sqrt_10           = 3.162277660168379331998893544433;
      Inv_Sqrt_3        = 0.577350269189625764509148780502;
      Inv_Sqrt_5        = 0.447213595499957939281834733746;
      Inv_Sqrt_10       = 0.316227766016837933199889354443;
      Sqrt_Pi           = 1.772453850905516027298167483341;
      Sqrt_Half         = 1.253314137315500251207882642406;
      Sqrt_2_Pi         = 2.506628274631000502415765284811;
      Inv_Half_Pi       = 0.636619772367581343075535053490;
      Inv_Sqrt_Pi       = 0.564189583547756286948079451561;
      Inv_Sqrt_Half_Pi  = 0.797884560802865355879892119869;
      Inv_Sqrt_2_Pi     = 0.398942280401432677939946059934;
      Pi_Sqr            = 9.869604401089358618834490999876;
      Inv_Pi_Sqr        = 0.101321183642337771443879463209;
      e                 = 2.718281828459045235360287471353;
      e_Sqr             = 7.389056098930650227230427460575;
      Sqrt_e            = 1.648721270700128146848650787814;
      Inv_e             = 0.367879441171442321595523770161;
      Inv_e_Sqr         = 0.135335283236612691893999494972;
      Inv_Sqrt_e        = 0.606530659712633423603799534991;
      Golden_Ratio      = 1.618033988749894848204586834366;
      Ln_2              = 0.693147180559945309417232121458;
      Ln_10             = 2.302585092994045684017991454684;
      Log10_2           = 0.301029995663981195213738894724;
      Log10_e           = 0.434294481903251827651128918917;
      log2_e            = 1.442695040888963407359924681002;
      log2_10           = 3.321928094887362347870319429489;
  end;
  Constant32 = record
    const
      Pi: Float32               = Constant.Pi;
      Two_Pi: Float32           = Constant.Two_Pi;
      Half_Pi: Float32          = Constant.Half_Pi;
      Three_Half_Pi: Float32    = Constant.Three_Half_Pi;
      Inv_Pi: Float32           = Constant.Inv_Pi;
      Inv_2_Pi: Float32         = Constant.Inv_2_Pi;
      RadianPerDegree: Float32  = Constant.RadianPerDegree;
      DegreePerRadian: Float32  = Constant.DegreePerRadian;
      Sqrt_2: Float32           = Constant.Sqrt_2;
      Sqrt_3: Float32           = Constant.Sqrt_3;
      Sqrt_5: Float32           = Constant.Sqrt_5;
      Half_Sqrt_2: Float32      = Constant.Half_Sqrt_2;
      Half_Sqrt_3: Float32      = Constant.Half_Sqrt_3;
      Half_Sqrt_5: Float32      = Constant.Half_Sqrt_5;
      Sqrt_10: Float32          = Constant.Sqrt_10;
      Inv_Sqrt_3: Float32       = Constant.Inv_Sqrt_3;
      Inv_Sqrt_5: Float32       = Constant.Inv_Sqrt_5;
      Inv_Sqrt_10: Float32      = Constant.Inv_Sqrt_10;
      Sqrt_Pi: Float32          = Constant.Sqrt_Pi;
      Sqrt_Half: Float32        = Constant.Sqrt_Half;
      Sqrt_2_Pi: Float32        = Constant.Sqrt_2_Pi;
      Inv_Half_Pi: Float32      = Constant.Inv_Half_Pi;
      Inv_Sqrt_Pi: Float32      = Constant.Inv_Sqrt_Pi;
      Inv_Sqrt_Half_Pi: Float32 = Constant.Inv_Sqrt_Half_Pi;
      Inv_Sqrt_2_Pi: Float32    = Constant.Inv_Sqrt_2_Pi;
      Pi_Sqr: Float32           = Constant.Pi_Sqr;
      Inv_Pi_Sqr: Float32       = Constant.Inv_Pi_Sqr;
      e: Float32                = Constant.e;
      e_Sqr: Float32            = Constant.e_Sqr;
      Sqrt_e: Float32           = Constant.Sqrt_e;
      Inv_e: Float32            = Constant.Inv_e;
      Inv_e_Sqr: Float32        = Constant.Inv_e_Sqr;
      Inv_Sqrt_e: Float32       = Constant.Inv_Sqrt_e;
      Golden_Ratio: Float32     = Constant.Golden_Ratio;
      Ln_2: Float32             = Constant.Ln_2;
      Ln_10: Float32            = Constant.Ln_10;
      Log10_2: Float32          = Constant.Log10_2;
      Log10_e: Float32          = Constant.Log10_e;
      log2_e: Float32           = Constant.log2_e;
      log2_10: Float32          = Constant.log2_10;
      c_90: Float32             = 90;
      c_180: Float32            = 180;
      c_360: Float32            = 360;
      Inv_180: Float32          = 1 / 180;
      Inv_360: Float32          = 1 / 360;
  end;
  Constant64 = record
    const
      Pi: Float64               = Constant.Pi;
      Two_Pi: Float64           = Constant.Two_Pi;
      Half_Pi: Float64          = Constant.Half_Pi;
      Three_Half_Pi: Float64    = Constant.Three_Half_Pi;
      Inv_Pi: Float64           = Constant.Inv_Pi;
      Inv_2_Pi: Float64         = Constant.Inv_2_Pi;
      RadianPerDegree: Float64  = Constant.RadianPerDegree;
      DegreePerRadian: Float64  = Constant.DegreePerRadian;
      Sqrt_2: Float64           = Constant.Sqrt_2;
      Sqrt_3: Float64           = Constant.Sqrt_3;
      Sqrt_5: Float64           = Constant.Sqrt_5;
      Half_Sqrt_2: Float64      = Constant.Half_Sqrt_2;
      Half_Sqrt_3: Float64      = Constant.Half_Sqrt_3;
      Half_Sqrt_5: Float64      = Constant.Half_Sqrt_5;
      Sqrt_10: Float64          = Constant.Sqrt_10;
      Inv_Sqrt_3: Float64       = Constant.Inv_Sqrt_3;
      Inv_Sqrt_5: Float64       = Constant.Inv_Sqrt_5;
      Inv_Sqrt_10: Float64      = Constant.Inv_Sqrt_10;
      Sqrt_Pi: Float64          = Constant.Sqrt_Pi;
      Sqrt_Half: Float64        = Constant.Sqrt_Half;
      Sqrt_2_Pi: Float64        = Constant.Sqrt_2_Pi;
      Inv_Half_Pi: Float64      = Constant.Inv_Half_Pi;
      Inv_Sqrt_Pi: Float64      = Constant.Inv_Sqrt_Pi;
      Inv_Sqrt_Half_Pi: Float64 = Constant.Inv_Sqrt_Half_Pi;
      Inv_Sqrt_2_Pi: Float64    = Constant.Inv_Sqrt_2_Pi;
      Pi_Sqr: Float64           = Constant.Pi_Sqr;
      Inv_Pi_Sqr: Float64       = Constant.Inv_Pi_Sqr;
      e: Float64                = Constant.e;
      e_Sqr: Float64            = Constant.e_Sqr;
      Sqrt_e: Float64           = Constant.Sqrt_e;
      Inv_e: Float64            = Constant.Inv_e;
      Inv_e_Sqr: Float64        = Constant.Inv_e_Sqr;
      Inv_Sqrt_e: Float64       = Constant.Inv_Sqrt_e;
      Golden_Ratio: Float64     = Constant.Golden_Ratio;
      Ln_2: Float64             = Constant.Ln_2;
      Ln_10: Float64            = Constant.Ln_10;
      Log10_2: Float64          = Constant.Log10_2;
      Log10_e: Float64          = Constant.Log10_e;
      log2_e: Float64           = Constant.log2_e;
      log2_10: Float64          = Constant.log2_10;
      c_90: Float64             = 90;
      c_180: Float64            = 180;
      c_360: Float64            = 360;
      Inv_180: Float64          = 1 / 180;
      Inv_360: Float64          = 1 / 360;
  end;
  ConstantEx = record
    const
      Pi: FloatEx               = Constant.Pi;
      Two_Pi: FloatEx           = Constant.Two_Pi;
      Half_Pi: FloatEx          = Constant.Half_Pi;
      Three_Half_Pi: FloatEx    = Constant.Three_Half_Pi;
      Inv_Pi: FloatEx           = Constant.Inv_Pi;
      Inv_2_Pi: FloatEx         = Constant.Inv_2_Pi;
      RadianPerDegree: FloatEx  = Constant.RadianPerDegree;
      DegreePerRadian: FloatEx  = Constant.DegreePerRadian;
      Sqrt_2: FloatEx           = Constant.Sqrt_2;
      Sqrt_3: FloatEx           = Constant.Sqrt_3;
      Sqrt_5: FloatEx           = Constant.Sqrt_5;
      Half_Sqrt_2: FloatEx      = Constant.Half_Sqrt_2;
      Half_Sqrt_3: FloatEx      = Constant.Half_Sqrt_3;
      Half_Sqrt_5: FloatEx      = Constant.Half_Sqrt_5;
      Sqrt_10: FloatEx          = Constant.Sqrt_10;
      Inv_Sqrt_3: FloatEx       = Constant.Inv_Sqrt_3;
      Inv_Sqrt_5: FloatEx       = Constant.Inv_Sqrt_5;
      Inv_Sqrt_10: FloatEx      = Constant.Inv_Sqrt_10;
      Sqrt_Pi: FloatEx          = Constant.Sqrt_Pi;
      Sqrt_Half: FloatEx        = Constant.Sqrt_Half;
      Sqrt_2_Pi: FloatEx        = Constant.Sqrt_2_Pi;
      Inv_Half_Pi: FloatEx      = Constant.Inv_Half_Pi;
      Inv_Sqrt_Pi: FloatEx      = Constant.Inv_Sqrt_Pi;
      Inv_Sqrt_Half_Pi: FloatEx = Constant.Inv_Sqrt_Half_Pi;
      Inv_Sqrt_2_Pi: FloatEx    = Constant.Inv_Sqrt_2_Pi;
      Pi_Sqr: FloatEx           = Constant.Pi_Sqr;
      Inv_Pi_Sqr: FloatEx       = Constant.Inv_Pi_Sqr;
      e: FloatEx                = Constant.e;
      e_Sqr: FloatEx            = Constant.e_Sqr;
      Sqrt_e: FloatEx           = Constant.Sqrt_e;
      Inv_e: FloatEx            = Constant.Inv_e;
      Inv_e_Sqr: FloatEx        = Constant.Inv_e_Sqr;
      Inv_Sqrt_e: FloatEx       = Constant.Inv_Sqrt_e;
      Golden_Ratio: FloatEx     = Constant.Golden_Ratio;
      Ln_2: FloatEx             = Constant.Ln_2;
      Ln_10: FloatEx            = Constant.Ln_10;
      Log10_2: FloatEx          = Constant.Log10_2;
      Log10_e: FloatEx          = Constant.Log10_e;
      log2_e: FloatEx           = Constant.log2_e;
      log2_10: FloatEx          = Constant.log2_10;
      c_90: FloatEx             = 90;
      c_180: FloatEx            = 180;
      c_360: FloatEx            = 360;
      Inv_180: FloatEx          = 1 / 180;
      Inv_360: FloatEx          = 1 / 360;
  end;
{$ENDREGION}

{$REGION 'Pointer and Object types'}
  /// <summary>TPointers is a type for dynamic array of Pointer.</summary>
  TPointers             = TArray<Pointer>;
  /// <summary>PPointers is pointer type for referencing a TPointers variable.</summary>
  PPointers             = ^TPointers;

  /// <summary>PObject is pointer type for referencing a TObject variable.</summary>
  PObject       = ^TObject;
  /// <summary>TObjects is a type for dynamic array of TObject.</summary>
  TObjects      = TArray<TObject>;
  /// <summary>PObjects is pointer type for referencing a TObjects variable.</summary>
  PObjects      = ^TObjects;
{$ENDREGION}

{$REGION 'String types'}
/// <summary>Cast a string variable as TMutableString to access Mutable type procedures.
/// It is used to separate mutable and immutable codes. It makes codes cleaner and
/// prepares for the unlike but possible change of string to be immutable.</summary>
  TMutableString        = type String;
/// <summary>MString is an alias type of TMutableString. Type-cast a string variable as
/// MString to modify it with type procedures.</summary>
  MString               = TMutableString;
/// <summary>Cast a string variable as TString to access additional type functions.</summary>
  TCodePage             = Word;

/// <summary>ByteString is an alias type of RawByteString. It is used to represent string of 8-bit chars instead of AnsiString.</summary>
  ByteString            = RawByteString;
  PByteString           = ^ByteString;
/// <summary>Cast a ByteString variable as TMutableByteString to access Mutable type procedures.
/// It is used to separate mutable and immutable codes. It makes codes cleaner and
/// prepares for the unlike but possible change of string to be immutable.</summary>
  TMutableByteString    = type ByteString;
/// <summary>MBString is an alias type of TMutableByteString. Type-cast a string variable as
/// MBString to modify it with type procedures.</summary>
  MBString              = TMutableByteString;
{$ENDREGION}

{$REGION 'TStringArray, TArrayOfBStrings'}
  /// <summary>TStringArray is a type for dynamic array of strings.</summary>
  TStringArray          = TStringDynArray;
  TFileNames            = TStringDynArray;
  /// <summary>pArrayOfStrings is pointer type for referencing a TStringArray variable.</summary>
  PArrayOfStrings       = ^TStringArray;
  /// <summary>TByteStrings is a type for dynamic array of ByteString.</summary>
  TByteStrings          = TArray<ByteString>;
  /// <summary>PByteStrings is pointer type for referencing a TByteStrings variable.</summary>
  PByteStrings          = ^TByteStrings;
{$ENDREGION}

{$REGION 'Some simple types'}
  TPointFs = array of TPointF;
  /// <summary>TBool3 is a three state boolean type. In addition to IsFalse and IsTrue,
  /// it can also have an unset state IsEmpty.</summary>
  TEndOfLineFormat      = ( elfSystem, elfWindows, elfMac, elfUnix );
  TFileSizeFormat       = ( Auto, Bytes, KiloBytes, MegaBytes, GigaBytes, TeraBytes, PetaBytes, ExaBytes );

  THitTestResult        = ( Outside,    Inside,
                            OnPoint,    TopLeft,    TopRight,   BottomLeft, BottomRight,
                            OnLine,     TopEdge,    LeftEdge,   RightEdge,  BottomEdge );
  THitTestResultHelper = record helper for THitTestResult
    const OnPoints = [THitTestResult.OnPoint, THitTestResult.TopLeft, THitTestResult.TopRight,
                      THitTestResult.BottomLeft, THitTestResult.BottomRight];
    const OnLines  = [THitTestResult.OnLine, THitTestResult.TopEdge, THitTestResult.LeftEdge,
                      THitTestResult.RightEdge, THitTestResult.BottomEdge];
    function IsOnPoints: Boolean;                       inline;
    function IsOnLines: Boolean;                        inline;
    function IsOnEdge: Boolean;                         inline;
    function IsInside: Boolean;                         inline;
    function IsOutside: Boolean;                        inline;
  end;
{$ENDREGION}

{$REGION 'Endianness'}
  Endianness = record
  private
    class procedure ConvertEndian16(pSrc, pTrg: pUInt16; Len: NInt);    static;
    class procedure ConvertEndian32(pSrc, pTrg: pUInt32; Len: NInt);    static;
    class procedure ConvertEndian64(pSrc, pTrg: pUInt64; Len: NInt);    static;
  public
    class function ChangeU16(A: UInt16): UInt16;                        static; inline; // External or inline
    class function ChangeU32(A: UInt32): UInt32;                        static; inline; // External or inline
    class function ChangeU64(A: UInt64): UInt64;                        static;

    class function ChangeI16(A: Int16): Int16;                          static; inline;
    class function ChangeI32(A: Int32): Int32;                          static; inline;
    class function ChangeI64(A: Int64): Int64;                          static; inline;
    class function ChangeF32(const A: Float32): Float32;                static; inline;
    class function ChangeF64(const A: Float64): Float64;                static; inline;
    class function ChangeC16(A: Char16): Char16;                        static; inline;

    class procedure Swap16(var Mem_16_Bits);                            static;
    class procedure Swap32(var Mem_32_Bits);                            static;
    class procedure Swap64(var Mem_64_Bits);                            static;
    class procedure Swap128(var Mem_128_Bits);                          static;
    class procedure FlipMemory(const Source; var Target; Length: NInt); static;

    class procedure Convert(var A: UInt16);                       overload; static; inline;
    class procedure Convert(var A: UInt32);                       overload; static; inline;
    class procedure Convert(var A: UInt64);                       overload; static; inline;
    class procedure Convert(var A: Int16);                        overload; static; inline;
    class procedure Convert(var A: Int32);                        overload; static; inline;
    class procedure Convert(var A: Int64);                        overload; static; inline;
    class procedure Convert(var A: Float32);                      overload; static; inline;
    class procedure Convert(var A: Float64);                      overload; static; inline;
    class procedure Convert(var A: Char16);                       overload; static; inline;

    class procedure Convert(p: pUInt16; Len: NInt);               overload; static; inline;
    class procedure Convert(p: pUInt32; Len: NInt);               overload; static; inline;
    class procedure Convert(p: pUInt64; Len: NInt);               overload; static; inline;
    class procedure Convert(p: pInt16; Len: NInt);                overload; static; inline;
    class procedure Convert(p: pInt32; Len: NInt);                overload; static; inline;
    class procedure Convert(p: pInt64; Len: NInt);                overload; static; inline;
    class procedure Convert(p: pFloat32; Len: NInt);              overload; static; inline;
    class procedure Convert(p: pFloat64; Len: NInt);              overload; static; inline;
    class procedure Convert(p: PWideChar; Len: NInt);             overload; static; inline;

    class procedure Convert(pSrc, pTrg: pUInt16; Len: NInt);      overload; static; inline;
    class procedure Convert(pSrc, pTrg: pUInt32; Len: NInt);      overload; static; inline;
    class procedure Convert(pSrc, pTrg: pUInt64; Len: NInt);      overload; static; inline;
    class procedure Convert(pSrc, pTrg: pInt16; Len: NInt);       overload; static; inline;
    class procedure Convert(pSrc, pTrg: pInt32; Len: NInt);       overload; static; inline;
    class procedure Convert(pSrc, pTrg: pInt64; Len: NInt);       overload; static; inline;
    class procedure Convert(pSrc, pTrg: pFloat32; Len: NInt);     overload; static; inline;
    class procedure Convert(pSrc, pTrg: pFloat64; Len: NInt);     overload; static; inline;
    class procedure Convert(pSrc, pTrg: PWideChar; Len: NInt);    overload; static; inline;

    class procedure Convert(var Data: TUInt16s);                  overload; static; inline;
    class procedure Convert(var Data: TUInt32s);                  overload; static; inline;
    class procedure Convert(var Data: TUInt64s);                  overload; static; inline;
    class procedure Convert(var Data: TInt16s);                   overload; static; inline;
    class procedure Convert(var Data: TInt32s);                   overload; static; inline;
    class procedure Convert(var Data: TInt64s);                   overload; static; inline;
    class procedure Convert(var Data: TFloat32s);                 overload; static; inline;
    class procedure Convert(var Data: TFloat64s);                 overload; static; inline;
    class procedure Convert(var s: String);                       overload; static; inline;
    class procedure Convert(const Src: String; var Trg: String);  overload; static; inline;
  end;
{$ENDREGION}

{$REGION 'Quick Sort'}
  QuickSort = record
  public
    type
      TCompareFunc          = reference to function(p: Pointer; m, n: NInt): NInt;       // Will swap when a>b, not a>=b
      TSwapProc             = reference to procedure(p: Pointer; m, n: NInt);
      TCompareFuncObj       = function(m, n: NInt): NInt of object;
      TSwapProcObj          = procedure(m, n: NInt) of object;
      TCompareFuncRef       = reference to function(m, n: NInt): NInt;
      TSwapProcRef          = reference to procedure(m, n: NInt);

      TComparer<T>          = reference to function (const A, B: T): Integer;
      TPointersOfTs<T>      = array of ^T;

    class procedure Sort(p: Pointer; First, Last: NInt; Compare: TCompareFunc; Swap: tSwapProc);    overload; static;
    class procedure Sort(p: Pointer; First, Last: NInt; Compare: TCompareFunc; var Index: TNInts);  overload; static;
    class procedure Sort(First, Last: NInt; Compare: TCompareFuncObj; Swap: TSwapProcObj);          overload; static;
    class procedure Sort(First, Last: NInt; Compare: TCompareFuncObj; var Index: TNInts);           overload; static;
    class procedure Sort(First, Last: NInt; Compare: TCompareFuncRef; Swap: TSwapProcRef);          overload; static;
    class procedure Sort(First, Last: NInt; Compare: TCompareFuncRef; var Index: TNInts);           overload; static;

    class procedure Sort<T>(var Items: array of T; Comparer: TComparer<T>);                         overload; static;
    class procedure Sort<T>(const Items: array of T; Comparer: TComparer<T>; var Index: TNInts);    overload; static;
    class procedure Sort<T>(var PItems: TPointersOfTs<T>; Comparer: TComparer<T>);                  overload; static;
{$IFDEF CPU64}
    class procedure Sort(p: Pointer; First, Last: NInt; Compare: TCompareFunc; var Index: TInt32s); overload; static;
    class procedure Sort(First, Last: NInt; Compare: TCompareFuncObj; var Index: TInt32s);          overload; static;
    class procedure Sort(First, Last: NInt; Compare: TCompareFuncRef; var Index: TInt32s);          overload; static;
    class procedure Sort<T>(const Items: array of T; Comparer: TComparer<T>; var Index: TInt32s);   overload; static;
{$ENDIF}
  end;
{$ENDREGION}

{$REGION 'ez: Some useful inline functions'}
  // How to fit a source rectange of Width_1 x Height_1 in to another of Width_2 x Height_2
  TBestFitSetting  = (
        None,                   // No fitting, return Width_1 x Height_1
        FitSmaller,             // Fit only when the source is to small (Width_1 < Width_2 and Height_1 < Height_2)
        FitLarger,              // Fit only when the source is to big (Width_1 > Width_2 or Height_1 > Height_2)
        FitAll,                 // Fit always
        Stretch                 // return Width_2 x Height_2; aspect ratio is not maintained
    );

  ez = record
    class procedure FillIndex16(var Target; First: UInt16; Count: NInt);                static; inline;
    class procedure FillIndex32(var Target; First: UInt32; Count: NInt);                static; inline;
    class procedure FillIndex64(var Target; First: UInt64; Count: NInt);                static; inline;
    class procedure FillWord(var Target; Count: NInt; Value: UInt16);                   static; inline;
    class procedure FillLong(var Target; Count: NInt; Value: UInt32);                   static; inline;
    class procedure Fill64(var Target; Count: NInt; Value: UInt64);                     static; inline;

    class function  CountOfByte(const Source; Len: NInt; Value: UInt8): NInt;           static; inline;
    class function  CountOfWord(const Source; Len: NInt; Value: UInt16): NInt;          static; inline;
    class function  CountOfLong(const Source; Len: NInt; Value: UInt32): NInt;          static; inline;
    class function  CountOf64(const Source; Len: NInt; Value: UInt64): NInt;            static; inline;

    class function  AnsiIndexOfChar(c: AnsiChar; p: PAnsiChar; Len: NInt): NInt;        static; inline;
    class function  WideIndexOfChar(c: WideChar; p: PWideChar; Len: NInt): NInt;        static; inline;
    class function  AnsiCompareMemText(p1, p2: PAnsiChar; Len: NInt): Boolean;          static; inline;
    class function  WideCompareMemText(p1, p2: PWideChar; Len: NInt): Boolean;          static; inline;

    class procedure AnsiReplace(p: pAnsiChar; Count: NInt; Old, New: AnsiChar);         static; inline;
    class procedure AnsiReplaceIfBelow(p: pAnsiChar; Count: NInt; Old, New: AnsiChar);  static; inline;
    class procedure WideReplace(p: pWideChar; Count: NInt; Old, New: WideChar);         static; inline;
    class procedure WideReplaceIfBelow(p: pWideChar; Count: NInt; Old, New: WideChar);  static; inline;

    class function IfThen<T>(b: Boolean; const ValueTrue, ValueFalse: T): T;            static; inline;
    // Return S or AlternativeS
    class function IfEmpty(const S, AlternativeS: String): String;                      static; inline;
    // Return S or ResultStr
    class function IfNotEmpty(const S, ResultStr: String): String;                      static; inline;

    // When System.Math is used, using Min/Max with two numbers casue the "Ambiguous overloaded call" error. Use ez.Max to avoid this
    class function Min(const a, b: Int32): Int32;                               overload; static; inline;
    class function Min(const a, b: UInt32): UInt32;                             overload; static; inline;
    class function Min(const a, b: Int64): Int64;                               overload; static; inline;
    class function Min(const a, b: UInt64): UInt64;                             overload; static; inline;
    class function Min(const a, b: Float32): Float32;                           overload; static; inline;
    class function Min(const a, b: Float64): Float64;                           overload; static; inline;
    class function Max(const a, b: Int32): Int32;                               overload; static; inline;
    class function Max(const a, b: UInt32): UInt32;                             overload; static; inline;
    class function Max(const a, b: Int64): Int64;                               overload; static; inline;
    class function Max(const a, b: UInt64): UInt64;                             overload; static; inline;
    class function Max(const a, b: Float32): Float32;                           overload; static; inline;
    class function Max(const a, b: Float64): Float64;                           overload; static; inline;
    class function Min(const a, b, c: Int32): Int32;                            overload; static; inline;
    class function Min(const a, b, c: UInt32): UInt32;                          overload; static; inline;
    class function Min(const a, b, c: Int64): Int64;                            overload; static; inline;
    class function Min(const a, b, c: UInt64): UInt64;                          overload; static; inline;
    class function Min(const a, b, c: Float32): Float32;                        overload; static; inline;
    class function Min(const a, b, c: Float64): Float64;                        overload; static; inline;
    class function Max(const a, b, c: Int32): Int32;                            overload; static; inline;
    class function Max(const a, b, c: UInt32): UInt32;                          overload; static; inline;
    class function Max(const a, b, c: Int64): Int64;                            overload; static; inline;
    class function Max(const a, b, c: UInt64): UInt64;                          overload; static; inline;
    class function Max(const a, b, c: Float32): Float32;                        overload; static; inline;
    class function Max(const a, b, c: Float64): Float64;                        overload; static; inline;
    class function EnsureRange(const Value, Min, Max: Int32): Int32;            overload; static; inline;
    class function EnsureRange(const Value, Min, Max: UInt32): UInt32;          overload; static; inline;
    class function EnsureRange(const Value, Min, Max: Int64): Int64;            overload; static; inline;
    class function EnsureRange(const Value, Min, Max: UInt64): UInt64;          overload; static; inline;
    class function EnsureRange(const Value, Min, Max: Float32): Float32;        overload; static; inline;
    class function EnsureRange(const Value, Min, Max: Float64): Float64;        overload; static; inline;
    class function InRange(const AValue, AMin, AMax: Int32): Boolean;           overload; static; inline;
    class function InRange(const AValue, AMin, AMax: UInt32): Boolean;          overload; static; inline;
    class function InRange(const AValue, AMin, AMax: Int64): Boolean;           overload; static; inline;
    class function InRange(const AValue, AMin, AMax: UInt64): Boolean;          overload; static; inline;
    class function InRange(const AValue, AMin, AMax: Float32): Boolean;         overload; static; inline;
    class function InRange(const AValue, AMin, AMax: Float64): Boolean;         overload; static; inline;

    class procedure Swap(var a, b: Int8);                                       overload; static; inline;
    class procedure Swap(var a, b: Int16);                                      overload; static; inline;
    class procedure Swap(var a, b: Int32);                                      overload; static; inline;
    class procedure Swap(var a, b: Int64);                                      overload; static; inline;
    class procedure Swap(var a, b: UInt8);                                      overload; static; inline;
    class procedure Swap(var a, b: UInt16);                                     overload; static; inline;
    class procedure Swap(var a, b: UInt32);                                     overload; static; inline;
    class procedure Swap(var a, b: UInt64);                                     overload; static; inline;
    class procedure Swap(var a, b: Float32);                                    overload; static; inline;
    class procedure Swap(var a, b: Float64);                                    overload; static; inline;
    class procedure Swap(var a, b: Char8);                                      overload; static; inline;
    class procedure Swap(var a, b: Char16);                                     overload; static; inline;
    class procedure Swap(var a, b: Pointer);                                    overload; static; inline;
    class procedure Swap(var a, b: TObject);                                    overload; static; inline;
    class procedure Swap(var a, b: string);                                     overload; static; inline;
    class procedure Swap(var a, b: Bytestring);                                 overload; static; inline;

    class function HighBit8 (a: UInt8): NInt;                                   static; inline;
    class function HighBit16(a: UInt16): NInt;                                  static; inline;
    class function HighBit32(a: UInt32): NInt;                                  static; inline;
    class function HighBit64(a: UInt64): NInt;                                  static; inline;
    class function LowBit8 (a: UInt8): NInt;                                    static; inline;
    class function LowBit16(a: UInt16): NInt;                                   static; inline;
    class function LowBit32(a: UInt32): NInt;                                   static; inline;
    class function LowBit64(a: UInt64): NInt;                                   static; inline;

    class procedure ToSmaller(var a: UInt8;  const Value: UInt8);               overload; static; inline;
    class procedure ToSmaller(var a: UInt16; const Value: UInt16);              overload; static; inline;
    class procedure ToSmaller(var a: UInt32; const Value: UInt32);              overload; static; inline;
    class procedure ToSmaller(var a: UInt64; const Value: UInt64);              overload; static; inline;
    class procedure ToSmaller(var a: Int8;   const Value: Int8);                overload; static; inline;
    class procedure ToSmaller(var a: Int16;  const Value: Int16);               overload; static; inline;
    class procedure ToSmaller(var a: Int32;  const Value: Int32);               overload; static; inline;
    class procedure ToSmaller(var a: Int64;  const Value: Int64);               overload; static; inline;
    class procedure ToLarger (var a: UInt8;  const Value: UInt8);               overload; static; inline;
    class procedure ToLarger (var a: UInt16; const Value: UInt16);              overload; static; inline;
    class procedure ToLarger (var a: UInt32; const Value: UInt32);              overload; static; inline;
    class procedure ToLarger (var a: UInt64; const Value: UInt64);              overload; static; inline;
    class procedure ToLarger (var a: Int8;   const Value: Int8);                overload; static; inline;
    class procedure ToLarger (var a: Int16;  const Value: Int16);               overload; static; inline;
    class procedure ToLarger (var a: Int32;  const Value: Int32);               overload; static; inline;
    class procedure ToLarger (var a: Int64;  const Value: Int64);               overload; static; inline;
    class procedure ToSmaller(var a: Float32; const Value: Float32);            overload; static; inline;
    class procedure ToSmaller(var a: Float64; const Value: Float64);            overload; static; inline;
    class procedure ToLarger (var a: Float32; const Value: Float32);            overload; static; inline;
    class procedure ToLarger (var a: Float64; const Value: Float64);            overload; static; inline;

    class procedure ToRange(var a: UInt8;   const Low, High: UInt8);            overload; static; inline;
    class procedure ToRange(var a: UInt16;  const Low, High: UInt16);           overload; static; inline;
    class procedure ToRange(var a: UInt32;  const Low, High: UInt32);           overload; static; inline;
    class procedure ToRange(var a: UInt64;  const Low, High: UInt64);           overload; static; inline;
    class procedure ToRange(var a: Int8;    const Low, High: Int8);             overload; static; inline;
    class procedure ToRange(var a: Int16;   const Low, High: Int16);            overload; static; inline;
    class procedure ToRange(var a: Int32;   const Low, High: Int32);            overload; static; inline;
    class procedure ToRange(var a: Int64;   const Low, High: Int64);            overload; static; inline;
    class procedure ToRange(var a: Float32; const Low, High: Float32);          overload; static; inline;
    class procedure ToRange(var a: Float64; const Low, High: Float64);          overload; static; inline;

    class function Sign(const a: Int32): Int32;                                 overload;  static; inline;
    class function Sign(const a: Int64): Int32;                                 overload;  static; inline;
    class function Sign(const a: Float32): Int32;                               overload;  static; inline;
    class function Sign(const a: Float64): Int32;                               overload;  static; inline;

    class function Min(const a, b: FloatEx): FloatEx;                           overload; static; inline;
    class function Min(const a, b, c: FloatEx): FloatEx;                        overload; static; inline;
    class function Max(const a, b: FloatEx): FloatEx;                           overload; static; inline;
    class function Max(const a, b, c: FloatEx): FloatEx;                        overload; static; inline;
    class function EnsureRange(const Value, Min, Max: FloatEx): FloatEx;        overload; static; inline;
    class function InRange(const AValue, AMin, AMax: FloatEx): Boolean;         overload; static; inline;

    class procedure Swap(var a, b: FloatEx);                                    overload; static; inline;
    class procedure ToSmaller(var a: FloatEx; const Value: FloatEx);            overload; static; inline;
    class procedure ToLarger (var a: FloatEx; const Value: FloatEx);            overload; static; inline;
    class procedure ToRange(var a: FloatEx; const Low, High: FloatEx);          overload; static; inline;
    class function Sign(const a: FloatEx): Int32;                               overload;  static; inline;

    // System.Random returns Integer
    class function Random(const Range, OldValue: Integer): Integer;             static;

    class function RoundDiv(const a, b: UInt32): UInt32;                        overload;  static; inline;
    class function RoundDiv(const a, b: UInt64): UInt64;                        overload;  static; inline;
    class function RoundDiv(const a, b: Int32): Int32;                          overload;  static; inline;
    class function RoundDiv(const a, b: Int64): Int64;                          overload;  static; inline;

    class function Distance(const dx, dy: NInt): FloatEx;                       overload;  static; inline;
    class function Distance(const x1, y1, x2, y2: NInt): FloatEx;               overload;  static; inline;
    class function Distance(const p1, p2: TPoint): FloatEx;                     overload;  static; inline;
    class function Distance(const dx, dy: FloatEx): FloatEx;                    overload;  static; inline;
    class function Distance(const x1, y1, x2, y2: FloatEx): FloatEx;            overload;  static; inline;
    class function Distance(const p1, p2: TPointF): FloatEx;                    overload;  static; inline;
    class function DistanceSquare(const dx, dy: NInt): Int64;                   overload;  static; inline;
    class function DistanceSquare(const x1, y1, x2, y2: NInt): Int64;           overload;  static; inline;
    class function DistanceSquare(const p1, p2: TPoint): Int64;                 overload;  static; inline;
    class function DistanceSquare(const dx, dy: FloatEx): FloatEx;              overload;  static; inline;
    class function DistanceSquare(const x1, y1, x2, y2: FloatEx): FloatEx;      overload;  static; inline;
    class function DistanceSquare(const p1, p2: TPointF): FloatEx;              overload;  static; inline;

    /// <summary>Round the number and use High(Int32) and Low(Int32) when overflowed.</summary>
    class function RoundFitToI32(const F: FloatEx): Int32;                      static; inline;
    /// <summary>Round the number and use High(Int64) and Low(Int64) when overflowed.</summary>
    class function RoundFitToI64(const F: FloatEx): Int64;                      static; inline;
    /// <summary>Round the number and use High(UInt32) and Low(UInt32) when overflowed.</summary>
    class function RoundFitToU32(const F: FloatEx): UInt32;                     static; inline;
    /// <summary>Round the number and use High(UInt64) and Low(UInt64) when overflowed.</summary>
    class function RoundFitToU64(const F: FloatEx): UInt64;                     static; inline;

    class procedure BestFit(var Width, Height: Float32; const MaxWidth, MaxHeight: Float32; Fitting: TBestFitSetting); overload; static;
    class procedure BestFit(var Width, Height: Float64; const MaxWidth, MaxHeight: Float64; Fitting: TBestFitSetting); overload; static;
  end;
{$ENDREGION}

implementation

uses
  wc.Consts;

{$REGION 'EZ.first part'}
class procedure ez.FillIndex16(var Target; First: UInt16; Count: NInt);
var
  i: NInt;
  pT: pUInt16;
begin
  pT := @Target;
  for i := 0 to Count - 1 do
  begin
    pT^ := First;
    Inc(First);
  end;
end;

class procedure ez.FillIndex32(var Target; First: UInt32; Count: NInt);
var
  i: NInt;
  pT: pUInt32;
begin
  pT := @Target;
  for i := 0 to Count - 1 do
  begin
    pT^ := First;
    Inc(First);
  end;
end;

class procedure ez.FillIndex64(var Target; First: UInt64; Count: NInt);
var
  i: NInt;
  pT: pUInt64;
begin
  pT := @Target;
  for i := 0 to Count - 1 do
  begin
    pT^ := First;
    Inc(First);
  end;
end;

class procedure ez.FillWord(var Target; Count: NInt; Value: UInt16);
var
  i: NInt;
  pT: pUInt16;
begin
  pT := @Target;
  for i := 0 to Count - 1 do
    pT^ := Value;
end;

class procedure ez.FillLong(var Target; Count: NInt; Value: UInt32);
var
  i: NInt;
  pT: pUInt32;
begin
  pT := @Target;
  for i := 0 to Count - 1 do
    pT^ := Value;
end;

class procedure ez.Fill64(var Target; Count: NInt; Value: UInt64);
var
  i: NInt;
  pT: pUInt64;
begin
  pT := @Target;
  for i := 0 to Count - 1 do
    pT^ := Value;
end;

class function ez.CountOfByte(const Source; Len: NInt; Value: UInt8): NInt;
var
  i: NInt;
  pS: pUInt8;
begin
  pS := @Source;
  Result := 0;
  for i := 0 to Len - 1 do
    if pS^ = Value then Inc(Result);
end;

class function ez.CountOfWord(const Source; Len: NInt; Value: UInt16): NInt;
var
  i: NInt;
  pS: pUInt16;
begin
  pS := @Source;
  Result := 0;
  for i := 0 to Len - 1 do
    if pS^ = Value then Inc(Result);
end;

class function ez.CountOfLong(const Source; Len: NInt; Value: UInt32): NInt;
var
  i: NInt;
  pS: pUInt32;
begin
  pS := @Source;
  Result := 0;
  for i := 0 to Len - 1 do
    if pS^ = Value then Inc(Result);
end;

class function ez.CountOf64(const Source; Len: NInt; Value: UInt64): NInt;
var
  i: NInt;
  pS: pUInt64;
begin
  pS := @Source;
  Result := 0;
  for i := 0 to Len - 1 do
    if pS^ = Value then Inc(Result);
end;

class function ez.AnsiIndexOfChar(c: AnsiChar; p: PAnsiChar; Len: NInt): NInt;
var
  pS, pE: PAnsiChar;
begin
  pS := p;
  pE := p + Len;
  while pS < pE do
  begin
    if pS^ = c then Exit(pS - p);
    inc(pS);
  end;
  Result := -1;
end;

class function ez.WideIndexOfChar(c: WideChar; p: PWideChar; Len: NInt): NInt;
var
  pS, pE: PWideChar;
begin
  pS := p;
  pE := p + Len;
  while pS < pE do
  begin
    if pS^ = c then Exit(pS - p);
    inc(pS);
  end;
  Result := -1;
end;

class function ez.AnsiCompareMemText(p1, p2: PAnsiChar; Len: NInt): Boolean;
var
  p1E: PAnsiChar;
begin
  p1E := p1 + Len;
  while p1 < p1E do
  begin
    if p1^ <> p2^ then
      if (p1^ >= 'A') and (p1^ <= 'Z') and (Ord(p2^) - Ord(p1^) = 32) or
         (p1^ >= 'a') and (p1^ <= 'z') and (Ord(p1^) - Ord(p2^) = 32)
        then Exit(False);
    inc(p1);
    inc(p2);
  end;
  Result := True;
end;

class function ez.WideCompareMemText(p1, p2: PWideChar; Len: NInt): Boolean;
var
  p1E: PWideChar;
begin
  p1E := p1 + Len;
  while p1 < p1E do
  begin
    if p1^ <> p2^ then
      if (p1^ >= 'A') and (p1^ <= 'Z') and (Ord(p2^) - Ord(p1^) = 32) or
         (p1^ >= 'a') and (p1^ <= 'z') and (Ord(p1^) - Ord(p2^) = 32)
        then Exit(False);
    inc(p1);
    inc(p2);
  end;
  Result := True;
end;

class procedure ez.AnsiReplace(p: pAnsiChar; Count: NInt; Old, New: AnsiChar);
var
  pE: PAnsiChar;
begin
  pE := p + Count;
  while p < pE do
  begin
    if p^ = Old then p^ := New;
    inc(p);
  end;
end;

class procedure ez.AnsiReplaceIfBelow(p: pAnsiChar; Count: NInt; Old, New: AnsiChar);
var
  pE: PAnsiChar;
begin
  pE := p + Count;
  while p < pE do
  begin
    if p^ < Old then p^ := New;
    inc(p);
  end;
end;

class procedure ez.WideReplace(p: pWideChar; Count: NInt; Old, New: WideChar);
var
  pE: PWideChar;
begin
  pE := p + Count;
  while p < pE do
  begin
    if p^ = Old then p^ := New;
    inc(p);
  end;
end;

class procedure ez.WideReplaceIfBelow(p: pWideChar; Count: NInt; Old, New: WideChar);
var
  pE: PWideChar;
begin
  pE := p + Count;
  while p < pE do
  begin
    if p^ < Old then p^ := New;
    inc(p);
  end;
end;
{$ENDREGION}


{$REGION 'THitTestResultHelper'}
{ THitTestResultHelper }

function THitTestResultHelper.IsOnPoints: Boolean;
begin
  Result := Self in OnPoints;
end;

function THitTestResultHelper.IsOnLines: Boolean;
begin
  Result := Self in OnLines;
end;

function THitTestResultHelper.IsOnEdge: Boolean;
begin
  Result := Self in (OnPoints + OnLines);
end;

function THitTestResultHelper.IsInside: Boolean;
begin
  Result := Self = THitTestResult.Inside;
end;

function THitTestResultHelper.IsOutside: Boolean;
begin
  Result := Self = THitTestResult.Outside;
end;
{$ENDREGION}

{$REGION 'Endianness'}

{$REGION 'Pure Pascal version of external methods'}
{$IFNDEF ALLOW_EXT_ASM}
class function Endianness.ChangeU16(A: UInt16): UInt16;
begin
  Result := A shl 8 + A shr 8;
end;

class function Endianness.ChangeU32(A: UInt32): UInt32;
begin
  Result := ( A                shl 24) or
            ((A and $0000FF00) shl 8) or
            ((A and $00FF0000) shr 8) or
            ( A                shr 24);
end;

class function Endianness.ChangeU64(A: UInt64): UInt64;
begin
  Result := (UInt64(ChangeU32(A)) shl 32) or UInt64(ChangeU32(A shr 32));
end;

class function Endianness.ChangeF32(const A: Float32): Float32;
begin
  var Temp := ChangeU32(PUInt32(@A)^);
  Result := PFloat32(@Temp)^;
end;

class function Endianness.ChangeF64(const A: Float64): Float64;
begin
  var Temp := ChangeU64(PUInt64(@A)^);
  Result := PFloat64(@Temp)^;
end;

class procedure Endianness.Swap16(var Mem_16_Bits);
begin
  PUInt16(@Mem_16_Bits)^ := ChangeU16(PUInt16(@Mem_16_Bits)^)
end;

class procedure Endianness.Swap32(var Mem_32_Bits);
begin
  PUInt32(@Mem_32_Bits)^ := ChangeU32(PUInt32(@Mem_32_Bits)^)
end;

class procedure Endianness.Swap64(var Mem_64_Bits);
begin
  PUInt64(@Mem_64_Bits)^ := ChangeU64(PUInt64(@Mem_64_Bits)^)
end;

class procedure Endianness.Swap128(var Mem_128_Bits);
begin
  var U64 :=  ChangeU64(PUInt64(@Mem_128_Bits)^);
  PUInt64(@Mem_128_Bits)^ := ChangeU64((PUInt64(@Mem_128_Bits) + 1)^);
  (PUInt64(@Mem_128_Bits) + 1)^ := U64;
end;

class procedure Endianness.FlipMemory(const Source; var Target; Length: NInt);
var
  p1, p0: pByte;
  i: NInt;
begin
 if Length = 0 then exit;
 p0 := pByte(@Source);
 p1 := pByte(@Target) + Length - 1;
 if p1 = p0 then
 begin
   for I := 0 to Length div 2 - 1 do
   begin
     p1^ := p0^;
     inc(p0);
     dec(p1);
   end;
 end else
 begin
   for I := 0 to Length - 1 do
   begin
     p1^ := p0^;
     inc(p0);
     dec(p1);
   end;
 end;
end;

class procedure Endianness.ConvertEndian16(pSrc, pTrg: pUInt16; Len: NInt);
begin
  for var i := 0 to Len - 1 do
  begin
    pTrg^ := ChangeU16(pSrc^);
    Inc(pTrg);
    Inc(pSrc);
  end;          
end;

class procedure Endianness.ConvertEndian32(pSrc, pTrg: pUInt32; Len: NInt);
begin
  for var i := 0 to Len - 1 do
  begin
    pTrg^ := ChangeU32(pSrc^);
    Inc(pTrg);
    Inc(pSrc);
  end;          
end;

class procedure Endianness.ConvertEndian64(pSrc, pTrg: pUInt64; Len: NInt);
begin
  for var i := 0 to Len - 1 do
  begin
    pTrg^ := ChangeU64(pSrc^);
    Inc(pTrg);
    Inc(pSrc);
  end;          
end;
{$ENDIF}
{$ENDREGION}

class function Endianness.ChangeI16(A: Int16): Int16;
begin
  Result := Int16(ChangeU16(UInt16(A)));
end;

class function Endianness.ChangeI32(A: Int32): Int32;
begin
  Result := Int32(ChangeU32(UInt32(A)));
end;

class function Endianness.ChangeI64(A: Int64): Int64;
begin
  Result := Int64(ChangeU64(UInt64(A)));
end;

class function Endianness.ChangeC16(A: Char16): Char16;
begin
  Result := Char16(ChangeU16(Int16(A)));
end;

class procedure Endianness.Convert(var A: UInt16);
begin
  Swap16(A);
end;

class procedure Endianness.Convert(var A: UInt32);
begin
  Swap32(A);
end;

class procedure Endianness.Convert(var A: UInt64);
begin
  Swap64(A);
end;

class procedure Endianness.Convert(var A: Int16);
begin
  Swap16(A);
end;

class procedure Endianness.Convert(var A: Int32);
begin
  Swap32(A);
end;

class procedure Endianness.Convert(var A: Int64);
begin
  Swap64(A);
end;

class procedure Endianness.Convert(var A: Float32);
begin
  Swap32(A);
end;

class procedure Endianness.Convert(var A: Float64);
begin
  Swap64(A);
end;

class procedure Endianness.Convert(var A: Char16);
begin
  Swap16(A);
end;


class procedure Endianness.Convert(p: pUInt16; Len: NInt);
begin
  ConvertEndian16(pUInt16(p), pUInt16(p), Len);
end;

class procedure Endianness.Convert(p: pUInt32; Len: NInt);
begin
  ConvertEndian32(pUInt32(p), pUInt32(p), Len);
end;

class procedure Endianness.Convert(p: pUInt64; Len: NInt);
begin
  ConvertEndian64(pUInt64(p), pUInt64(p), Len);
end;

class procedure Endianness.Convert(p: pInt16; Len: NInt);
begin
  ConvertEndian16(pUInt16(p), pUInt16(p), Len);
end;

class procedure Endianness.Convert(p: pInt32; Len: NInt);
begin
  ConvertEndian32(pUInt32(p), pUInt32(p), Len);
end;

class procedure Endianness.Convert(p: pInt64; Len: NInt);
begin
  ConvertEndian64(pUInt64(p), pUInt64(p), Len);
end;

class procedure Endianness.Convert(p: pFloat32; Len: NInt);
begin
  ConvertEndian32(pUInt32(p), pUInt32(p), Len);
end;

class procedure Endianness.Convert(p: pFloat64; Len: NInt);
begin
  ConvertEndian64(pUInt64(p), pUInt64(p), Len);
end;

class procedure Endianness.Convert(p: PWideChar; Len: NInt);
begin
  ConvertEndian16(pUInt16(p), pUInt16(p), Len);
end;


class procedure Endianness.Convert(pSrc, pTrg: pUInt16; Len: NInt);     
begin
  ConvertEndian16(pUInt16(pSrc), pUInt16(pTrg), Len);
end;

class procedure Endianness.Convert(pSrc, pTrg: pUInt32; Len: NInt);     
begin
  ConvertEndian32(pUInt32(pSrc), pUInt32(pTrg), Len);
end;

class procedure Endianness.Convert(pSrc, pTrg: pUInt64; Len: NInt);     
begin
  ConvertEndian64(pUInt64(pSrc), pUInt64(pTrg), Len);
end;

class procedure Endianness.Convert(pSrc, pTrg: pInt16; Len: NInt);     
begin
  ConvertEndian16(pUInt16(pSrc), pUInt16(pTrg), Len);
end;

class procedure Endianness.Convert(pSrc, pTrg: pInt32; Len: NInt);     
begin
  ConvertEndian32(pUInt32(pSrc), pUInt32(pTrg), Len);
end;

class procedure Endianness.Convert(pSrc, pTrg: pInt64; Len: NInt);     
begin
  ConvertEndian64(pUInt64(pSrc), pUInt64(pTrg), Len);
end;

class procedure Endianness.Convert(pSrc, pTrg: pFloat32; Len: NInt);     
begin
  ConvertEndian32(pUInt32(pSrc), pUInt32(pTrg), Len);
end;

class procedure Endianness.Convert(pSrc, pTrg: pFloat64; Len: NInt);     
begin
  ConvertEndian64(pUInt64(pSrc), pUInt64(pTrg), Len);
end;

class procedure Endianness.Convert(pSrc, pTrg: PWideChar; Len: NInt);
begin
  ConvertEndian16(pUInt16(pSrc), pUInt16(pTrg), Len);
end;


class procedure Endianness.Convert(var Data: TUInt16s);
begin
  ConvertEndian16(pUInt16(Data), pUInt16(Data), Length(Data));
end;

class procedure Endianness.Convert(var Data: TUInt32s);
begin
  ConvertEndian32(pUInt32(Data), pUInt32(Data), Length(Data));
end;

class procedure Endianness.Convert(var Data: TUInt64s);
begin
  ConvertEndian64(pUInt64(Data), pUInt64(Data), Length(Data));
end;

class procedure Endianness.Convert(var Data: TInt16s);
begin
  ConvertEndian16(pUInt16(Data), pUInt16(Data), Length(Data));
end;

class procedure Endianness.Convert(var Data: TInt32s);
begin
  ConvertEndian32(pUInt32(Data), pUInt32(Data), Length(Data));
end;

class procedure Endianness.Convert(var Data: TInt64s);
begin
  ConvertEndian64(pUInt64(Data), pUInt64(Data), Length(Data));
end;

class procedure Endianness.Convert(var Data: TFloat32s);
begin
  ConvertEndian32(pUInt32(Data), pUInt32(Data), Length(Data));
end;

class procedure Endianness.Convert(var Data: TFloat64s);
begin
  ConvertEndian64(pUInt64(Data), pUInt64(Data), Length(Data));
end;

class procedure Endianness.Convert(var s: String);
begin
  Convert(PChar(s), Length(s));
end;

class procedure Endianness.Convert(const Src: String; var Trg: String);
begin
  SetLength(Trg, Length(Src));
  Convert(PChar(Src), PChar(Trg), Length(Src));
end;
{$ENDREGION}

{$REGION 'Quick Sort'}
class procedure QuickSort.Sort(p: Pointer; First, Last: NInt; Compare: tCompareFunc; var Index: TNInts);
  procedure _Sort(First, Last: NInt);
  var
    m, lo, hi: NInt;
  begin
    if First = Last then exit else
    if First + 1 = Last then
    begin
      if Compare(p, Index[First], Index[Last]) > 0 then ez.Swap(Index[First], Index[Last]);
      exit;
    end else
    if First + 2 = Last then
    begin
      if Compare(p, Index[First], Index[First+ 1]) > 0 then ez.Swap(Index[First], Index[First+ 1]);
      if Compare(p, Index[First], Index[Last])     > 0 then ez.Swap(Index[First], Index[Last]);
      if Compare(p, Index[First+ 1], Index[Last])  > 0 then ez.Swap(Index[First+ 1], Index[Last]);
      exit;
    end;

    lo := First;
    hi := Last;
    m  := (lo + hi) shr 1;
    repeat
      while Compare(p, Index[m], Index[lo]) > 0 do inc(lo);
      while Compare(p, Index[hi], Index[m]) > 0 do dec(hi);
      if lo < hi then
      begin
        ez.Swap(Index[lo], Index[hi]);
        if lo = m
          then m := hi
          else if hi = m then m:=lo;
        inc(lo);
        dec(hi);
      end;
    until lo >= hi;
    if hi > First then _Sort(First, hi);
    if lo < Last  then _Sort(lo, Last);
  end;
begin
  if First < Last then _Sort(First, Last);
end;

class procedure QuickSort.Sort(p: Pointer; First, Last: NInt; Compare: tCompareFunc; Swap: tSwapProc);
  procedure _Sort(First, Last: NInt);
  var
    m, lo, hi: NInt;
  begin
    if First = Last then exit else
    if First + 1 = Last then
    begin
      if Compare(p, First, Last) > 0 then Swap(p, First, Last);
      exit;
    end else
    if First + 2 = Last then
    begin
      if Compare(p, First, First + 1) > 0 then Swap(p, First, First + 1);
      if Compare(p, First, Last)      > 0 then Swap(p, First, Last);
      if Compare(p, First + 1, Last)  > 0 then Swap(p, First + 1, Last);
      exit;
    end;

    lo := First;
    hi := Last;
    m  := (lo + hi) shr 1;
    repeat
      while Compare(p, m, lo) > 0 do inc(lo);
      while Compare(p, hi, m) > 0 do dec(hi);
      if lo < hi then
      begin
        Swap(p, lo, hi);
        if lo = m
          then m := hi
          else if hi = m then m:=lo;
        inc(lo);
        dec(hi);
      end;
    until lo >= hi;
    if hi > First then _Sort(First, hi);
    if lo < Last  then _Sort(lo, Last);
  end;
begin
  if First < Last then _Sort(First, Last);
end;

class procedure QuickSort.Sort(First, Last: NInt; Compare: tCompareFuncObj; Swap: tSwapProcObj);
  procedure _Sort(First, Last: NInt);
  var
    m, lo, hi: NInt;
  begin
    if First = Last then exit else
    if First + 1 = Last then
    begin
      if Compare(First, Last) > 0 then Swap(First, Last);
      exit;
    end else
    if First + 2 = Last then
    begin
      if Compare(First, First + 1) > 0 then Swap(First, First + 1);
      if Compare(First, Last)      > 0 then Swap(First, Last);
      if Compare(First + 1, Last)  > 0 then Swap(First + 1, Last);
      exit;
    end;

    lo := First;
    hi := Last;
    m  := (lo + hi) shr 1;
    repeat
      while Compare(m, lo) > 0 do inc(lo);
      while Compare(hi, m) > 0 do dec(hi);
      if lo < hi then
      begin
        Swap(lo, hi);
        if lo = m
          then m := hi
          else if hi = m then m:=lo;
        inc(lo);
        dec(hi);
      end;
    until lo >= hi;
    if hi > First then _Sort(First, hi);
    if lo < Last  then _Sort(lo, Last);
  end;
begin
  if First < Last then _Sort(First, Last);
end;

class procedure QuickSort.Sort(First, Last: NInt; Compare: tCompareFuncObj; var Index: TNInts);
  procedure _Sort(First, Last: NInt);
  var
    m, lo, hi: NInt;
  begin
    if First = Last then exit else
    if First + 1 = Last then
    begin
      if Compare(Index[First], Index[Last]) > 0 then ez.Swap(Index[First], Index[Last]);
      exit;
    end else
    if First + 2 = Last then
    begin
      if Compare(Index[First], Index[First+ 1]) > 0 then ez.Swap(Index[First], Index[First+ 1]);
      if Compare(Index[First], Index[Last])     > 0 then ez.Swap(Index[First], Index[Last]);
      if Compare(Index[First+ 1], Index[Last])  > 0 then ez.Swap(Index[First+ 1], Index[Last]);
      exit;
    end;

    lo := First;
    hi := Last;
    m  := (lo + hi) shr 1;
    repeat
      while Compare(Index[m], Index[lo]) > 0 do inc(lo);
      while Compare(Index[hi], Index[m]) > 0 do dec(hi);
      if lo < hi then
      begin
        ez.Swap(Index[lo], Index[hi]);
        if lo = m
          then m := hi
          else if hi = m then m:=lo;
        inc(lo);
        dec(hi);
      end;
    until lo >= hi;
    if hi > First then _Sort(First, hi);
    if lo < Last  then _Sort(lo, Last);
  end;
begin
  if First < Last then _Sort(First, Last);
end;

class procedure QuickSort.Sort(First, Last: NInt; Compare: tCompareFuncRef; Swap: tSwapProcRef);
  procedure _Sort(First, Last: NInt);
  var
    m, lo, hi: NInt;
  begin
    if First = Last then exit else
    if First + 1 = Last then
    begin
      if Compare(First, Last) > 0 then Swap(First, Last);
      exit;
    end else
    if First + 2 = Last then
    begin
      if Compare(First, First + 1) > 0 then Swap(First, First + 1);
      if Compare(First, Last)      > 0 then Swap(First, Last);
      if Compare(First + 1, Last)  > 0 then Swap(First + 1, Last);
      exit;
    end;

    lo := First;
    hi := Last;
    m  := (lo + hi) shr 1;
    repeat
      while Compare(m, lo) > 0 do inc(lo);
      while Compare(hi, m) > 0 do dec(hi);
      if lo < hi then
      begin
        Swap(lo, hi);
        if lo = m
          then m := hi
          else if hi = m then m:=lo;
        inc(lo);
        dec(hi);
      end;
    until lo >= hi;
    if hi > First then _Sort(First, hi);
    if lo < Last  then _Sort(lo, Last);
  end;
begin
  if First < Last then _Sort(First, Last);
end;

class procedure QuickSort.Sort(First, Last: NInt; Compare: tCompareFuncRef; var Index: TNInts);
  procedure _Sort(First, Last: NInt);
  var
    m, lo, hi: NInt;
  begin
    if First = Last then exit else
    if First + 1 = Last then
    begin
      if Compare(Index[First], Index[Last]) > 0 then ez.Swap(Index[First], Index[Last]);
      exit;
    end else
    if First + 2 = Last then
    begin
      if Compare(Index[First], Index[First+ 1]) > 0 then ez.Swap(Index[First], Index[First+ 1]);
      if Compare(Index[First], Index[Last])     > 0 then ez.Swap(Index[First], Index[Last]);
      if Compare(Index[First+ 1], Index[Last])  > 0 then ez.Swap(Index[First+ 1], Index[Last]);
      exit;
    end;

    lo := First;
    hi := Last;
    m  := (lo + hi) shr 1;
    repeat
      while Compare(Index[m], Index[lo]) > 0 do inc(lo);
      while Compare(Index[hi], Index[m]) > 0 do dec(hi);
      if lo < hi then
      begin
        ez.Swap(Index[lo], Index[hi]);
        if lo = m
          then m := hi
          else if hi = m then m:=lo;
        inc(lo);
        dec(hi);
      end;
    until lo >= hi;
    if hi > First then _Sort(First, hi);
    if lo < Last  then _Sort(lo, Last);
  end;
begin
  if First < Last then _Sort(First, Last);
end;

class procedure QuickSort.Sort<T>(var Items: array of T; Comparer: TComparer<T>);
type
  PT = ^T;
begin
  if Length(Items) >= 2 then
    Sort(@Items[0], 0, High(Items),
      function(p: Pointer; m, n: NInt): NInt
      begin
        Result := Comparer((PT(p) + m)^, (PT(p) + n)^);
      end,
      procedure(p: Pointer; m, n: NInt)
      var
        Temp: T;
      begin
        Temp := (PT(p) + m)^;
        (PT(p) + m)^ := (PT(p) + n)^;
        (PT(p) + n)^:= Temp;
      end);
end;

class procedure QuickSort.Sort<T>(var PItems: TPointersOfTs<T>; Comparer: TComparer<T>);
begin
  if Length(PItems) >= 2 then
    Sort(@PItems, 0, High(PItems),
      function(p: Pointer; m, n: NInt): NInt
      begin
        Result := Comparer(TPointersOfTs<T>(p)[m]^, TPointersOfTs<T>(p)[n]^);
      end,
      procedure(p: Pointer; m, n: NInt)
      var
        Temp: Pointer;
      begin
        Temp := TPointersOfTs<T>(p)[m];
        TPointersOfTs<T>(p)[m] := TPointersOfTs<T>(p)[n];
        TPointersOfTs<T>(p)[n] := Temp;
      end);
end;

class procedure QuickSort.Sort<T>(const Items: array of T; Comparer: TComparer<T>; var Index: TNInts);
type
  PT = ^T;
begin
  if Length(Items) >= 2 then
    Sort(@Items[0], 0, High(Items),
      function(p: Pointer; m, n: NInt): NInt
      begin
        Result := Comparer((PT(p) + m)^, (PT(p) + n)^);
      end,
      Index);
end;

{$IFDEF CPU64}
class procedure QuickSort.Sort(p: Pointer; First, Last: NInt; Compare: tCompareFunc; var Index: TInt32s);
  procedure _Sort(First, Last: NInt);
  var
    m, lo, hi: NInt;
  begin
    if First = Last then exit else
    if First + 1 = Last then
    begin
      if Compare(p, Index[First], Index[Last]) > 0 then ez.Swap(Index[First], Index[Last]);
      exit;
    end else
    if First + 2 = Last then
    begin
      if Compare(p, Index[First], Index[First+ 1]) > 0 then ez.Swap(Index[First], Index[First+ 1]);
      if Compare(p, Index[First], Index[Last])     > 0 then ez.Swap(Index[First], Index[Last]);
      if Compare(p, Index[First+ 1], Index[Last])  > 0 then ez.Swap(Index[First+ 1], Index[Last]);
      exit;
    end;

    lo := First;
    hi := Last;
    m  := (lo + hi) shr 1;
    repeat
      while Compare(p, Index[m], Index[lo]) > 0 do inc(lo);
      while Compare(p, Index[hi], Index[m]) > 0 do dec(hi);
      if lo < hi then
      begin
        ez.Swap(Index[lo], Index[hi]);
        if lo = m
          then m := hi
          else if hi = m then m:=lo;
        inc(lo);
        dec(hi);
      end;
    until lo >= hi;
    if hi > First then _Sort(First, hi);
    if lo < Last  then _Sort(lo, Last);
  end;
begin
  if First < Last then _Sort(First, Last);
end;

class procedure QuickSort.Sort(First, Last: NInt; Compare: tCompareFuncObj; var Index: TInt32s);
  procedure _Sort(First, Last: NInt);
  var
    m, lo, hi: NInt;
  begin
    if First = Last then exit else
    if First + 1 = Last then
    begin
      if Compare(Index[First], Index[Last]) > 0 then ez.Swap(Index[First], Index[Last]);
      exit;
    end else
    if First + 2 = Last then
    begin
      if Compare(Index[First], Index[First+ 1]) > 0 then ez.Swap(Index[First], Index[First+ 1]);
      if Compare(Index[First], Index[Last])     > 0 then ez.Swap(Index[First], Index[Last]);
      if Compare(Index[First+ 1], Index[Last])  > 0 then ez.Swap(Index[First+ 1], Index[Last]);
      exit;
    end;

    lo := First;
    hi := Last;
    m  := (lo + hi) shr 1;
    repeat
      while Compare(Index[m], Index[lo]) > 0 do inc(lo);
      while Compare(Index[hi], Index[m]) > 0 do dec(hi);
      if lo < hi then
      begin
        ez.Swap(Index[lo], Index[hi]);
        if lo = m
          then m := hi
          else if hi = m then m:=lo;
        inc(lo);
        dec(hi);
      end;
    until lo >= hi;
    if hi > First then _Sort(First, hi);
    if lo < Last  then _Sort(lo, Last);
  end;
begin
  if First < Last then _Sort(First, Last);
end;

class procedure QuickSort.Sort(First, Last: NInt; Compare: tCompareFuncRef; var Index: TInt32s);
  procedure _Sort(First, Last: NInt);
  var
    m, lo, hi: NInt;
  begin
    if First = Last then exit else
    if First + 1 = Last then
    begin
      if Compare(Index[First], Index[Last]) > 0 then ez.Swap(Index[First], Index[Last]);
      exit;
    end else
    if First + 2 = Last then
    begin
      if Compare(Index[First], Index[First+ 1]) > 0 then ez.Swap(Index[First], Index[First+ 1]);
      if Compare(Index[First], Index[Last])     > 0 then ez.Swap(Index[First], Index[Last]);
      if Compare(Index[First+ 1], Index[Last])  > 0 then ez.Swap(Index[First+ 1], Index[Last]);
      exit;
    end;

    lo := First;
    hi := Last;
    m  := (lo + hi) shr 1;
    repeat
      while Compare(Index[m], Index[lo]) > 0 do inc(lo);
      while Compare(Index[hi], Index[m]) > 0 do dec(hi);
      if lo < hi then
      begin
        ez.Swap(Index[lo], Index[hi]);
        if lo = m
          then m := hi
          else if hi = m then m:=lo;
        inc(lo);
        dec(hi);
      end;
    until lo >= hi;
    if hi > First then _Sort(First, hi);
    if lo < Last  then _Sort(lo, Last);
  end;
begin
  if First < Last then _Sort(First, Last);
end;

class procedure QuickSort.Sort<T>(const Items: array of T; Comparer: TComparer<T>; var Index: TInt32s);
type
  PT = ^T;
begin
  if Length(Items) >= 2 then
    Sort(@Items[0], 0, High(Items),
      function(p: Pointer; m, n: NInt): NInt
      begin
        Result := Comparer((PT(p) + m)^, (PT(p) + n)^);
      end,
      Index);
end;
{$ENDIF}
{$ENDREGION}

{$REGION 'ez: Some useful inline functions'}

{$REGION 'Pure Pascal version of external methods'}
{$IFNDEF ALLOW_EXT_ASM}
class function ez.HighBit32(a: UInt32): NInt;
begin
  if a = 0 then Exit(-1);
  Result := 0;
  if a >= $00010000 then
  begin
    a := a shr 16;
    Inc(Result, 16);
  end;
  if a >= $00000100 then
  begin
    a := a shr 8;
    Inc(Result, 8);
  end;
  if a >= $00000010 then
  begin
    a := a shr 4;
    Inc(Result, 4);
  end;
  if a >= $00000004 then
  begin
    a := a shr 2;
    Inc(Result, 2);
  end;
  if a >= $00000002 then
    Inc(Result, 1);
end;

class function ez.HighBit64(a: UInt64): NInt;
begin
  if a >= $1_0000_0000
    then Result := 32 + HighBit32(a shr 32)
    else Result := HighBit32(a);
end;

class function ez.LowBit32(a: UInt32): NInt;
begin
  if a = 0 then Exit(-1);
  Result := 0;
  if (a and $0000FFFF) = 0 then
  begin
    a := a shr 16;
    Inc(Result, 16);
  end;
  if (a and $000000FF) = 0 then
  begin
    a := a shr 8;
    Inc(Result, 8);
  end;
  if (a and $0000000F) = 0 then
  begin
    a := a shr 4;
    Inc(Result, 4);
  end;
  if (a and $00000003) = 0 then
  begin
    a := a shr 2;
    Inc(Result, 2);
  end;
  if (a and $00000001) = 0 then
    Inc(Result, 1);
end;

class function ez.LowBit64(a: UInt64): NInt;
begin
  if a = 0 then Exit(-1);
  if a and $FFFF_FFFF = 0
    then Result := 32 + LowBit32(a shr 32)
    else Result := HighBit32(a);
end;
{$ENDIF}
{$ENDREGION}


class function ez.HighBit16(a: UInt16): NInt;
begin
  Result := HighBit32(a);
end;

class function ez.HighBit8(a: UInt8): NInt;
begin
  Result := HighBit32(a);
end;

class function ez.IfEmpty(const S, AlternativeS: String): String;
begin
  if S = '' then Result := AlternativeS else Result := S;
end;

class function ez.IfNotEmpty(const S, ResultStr: String): String;
begin
  if s = '' then Result := '' else Result := ResultStr;
end;

class function ez.IfThen<T>(b: Boolean; const ValueTrue, ValueFalse: T): T;
begin
  if b then Result := ValueTrue else Result := ValueFalse;
end;

class function ez.LowBit16(a: UInt16): NInt;
begin
  Result := LowBit32(a);
end;

class function ez.LowBit8(a: UInt8): NInt;
begin
  Result := LowBit32(a);
end;

class procedure ez.ToRange(var a: UInt64; const Low, High: UInt64);
begin
  if a < Low
    then a := Low
    else if a > High
      then a := High;
end;

class procedure ez.ToRange(var a: UInt32; const Low, High: UInt32);
begin
  if a < Low
    then a := Low
    else if a > High
      then a := High;
end;

class procedure ez.ToRange(var a: UInt16; const Low, High: UInt16);
begin
  if a < Low
    then a := Low
    else if a > High
      then a := High;
end;

class procedure ez.ToRange(var a: UInt8; const Low, High: UInt8);
begin
  if a < Low
    then a := Low
    else if a > High
      then a := High;
end;

class procedure ez.ToRange(var a: Int64; const Low, High: Int64);
begin
  if a < Low
    then a := Low
    else if a > High
      then a := High;
end;

class procedure ez.ToRange(var a: Int32; const Low, High: Int32);
begin
  if a < Low
    then a := Low
    else if a > High
      then a := High;
end;

class procedure ez.ToRange(var a: Int8; const Low, High: Int8);
begin
  if a < Low
    then a := Low
    else if a > High
      then a := High;
end;

class procedure ez.ToRange(var a: Int16; const Low, High: Int16);
begin
  if a < Low
    then a := Low
    else if a > High
      then a := High;
end;

class procedure ez.ToRange(var a: Float32; const Low, High: Float32);
begin
  if a < Low
    then a := Low
    else if a > High
      then a := High;
end;

class procedure ez.ToRange(var a: Float64; const Low, High: Float64);
begin
  if a < Low
    then a := Low
    else if a > High
      then a := High;
end;

class procedure ez.BestFit(var Width, Height: Float64; const MaxWidth, MaxHeight: Float64;
  Fitting: TBestFitSetting);
var
  Ratio: Float64;
begin
  if Fitting = TBestFitSetting.None then Exit;
  if (Fitting = TBestFitSetting.FitSmaller) and ((Width >= MaxWidth) or (Height >= MaxHeight)) then Exit;
  if (Fitting = TBestFitSetting.FitLarger)  and ((Width <= MaxWidth) and (Height <= MaxHeight)) then Exit;

  if (Width = 0) then
  begin
    if Height > 0 then Height := MaxHeight;
    Exit;
  end;
  if (Height = 0) then
  begin
    if Width > 0  then Width := MaxHeight;
    Exit;
  end;

  if Fitting = TBestFitSetting.Stretch then
  begin
    Width := MaxWidth;
    Height := MaxHeight;
  end else
  begin
    Ratio := ez.Min(MaxWidth / Width, MaxHeight / Height);
    Width := Ratio * MaxWidth;
    Height := Ratio * MaxHeight;
  end;
end;

class procedure ez.BestFit(var Width, Height: Float32; const MaxWidth, MaxHeight: Float32;
  Fitting: TBestFitSetting);
var
  Ratio: Float32;
begin
  if Fitting = TBestFitSetting.None then Exit;
  if (Fitting = TBestFitSetting.FitSmaller) and ((Width >= MaxWidth) or (Height >= MaxHeight)) then Exit;
  if (Fitting = TBestFitSetting.FitLarger)  and ((Width <= MaxWidth) and (Height <= MaxHeight)) then Exit;

  if (Width = 0) then
  begin
    if Height > 0 then Height := MaxHeight;
    Exit;
  end;
  if (Height = 0) then
  begin
    if Width > 0  then Width := MaxHeight;
    Exit;
  end;

  if Fitting = TBestFitSetting.Stretch then
  begin
    Width := MaxWidth;
    Height := MaxHeight;
  end else
  begin
    Ratio := ez.Min(MaxWidth / Width, MaxHeight / Height);
    Width := Ratio * Width;
    Height := Ratio * Height;
  end;
end;

class function ez.EnsureRange(const Value, Min, Max: Int32): Int32;
begin
  if Value <= Min
    then Result := Min
    else if Value > Max
      then Result := Max
      else Result := Value;
end;

class function ez.EnsureRange(const Value, Min, Max: UInt32): UInt32;
begin
  if Value <= Min
    then Result := Min
    else if Value > Max
      then Result := Max
      else Result := Value;
end;

class function ez.EnsureRange(const Value, Min, Max: Int64): Int64;
begin
  if Value <= Min
    then Result := Min
    else if Value > Max
      then Result := Max
      else Result := Value;
end;

class function ez.EnsureRange(const Value, Min, Max: UInt64): UInt64;
begin
  if Value <= Min
    then Result := Min
    else if Value > Max
      then Result := Max
      else Result := Value;
end;

class function ez.EnsureRange(const Value, Min, Max: Float32): Float32;
begin
  if Value <= Min
    then Result := Min
    else if Value > Max
      then Result := Max
      else Result := Value;
end;

class function ez.EnsureRange(const Value, Min, Max: Float64): Float64;
begin
  if Value <= Min
    then Result := Min
    else if Value > Max
      then Result := Max
      else Result := Value;
end;

class function ez.InRange(const AValue, AMin, AMax: Int32): Boolean;
begin
  Result := (AValue >= AMin) and (AValue <= AMax);
end;

class function ez.InRange(const AValue, AMin, AMax: UInt32): Boolean;
begin
  Result := (AValue >= AMin) and (AValue <= AMax);
end;

class function ez.InRange(const AValue, AMin, AMax: Int64): Boolean;
begin
  Result := (AValue >= AMin) and (AValue <= AMax);
end;

class function ez.InRange(const AValue, AMin, AMax: UInt64): Boolean;
begin
  Result := (AValue >= AMin) and (AValue <= AMax);
end;

class function ez.InRange(const AValue, AMin, AMax: Float32): Boolean;
begin
  Result := (AValue >= AMin) and (AValue <= AMax);
end;

class function ez.InRange(const AValue, AMin, AMax: Float64): Boolean;
begin
  Result := (AValue >= AMin) and (AValue <= AMax);
end;

class function ez.Max(const a, b: Int64): Int64;
begin
  if a > b then Result := a else Result := b;
end;

class function ez.Max(const a, b: UInt32): UInt32;
begin
  if a > b then Result := a else Result := b;
end;

class function ez.Max(const a, b: Int32): Int32;
begin
  if a > b then Result := a else Result := b;
end;

class function ez.Max(const a, b: UInt64): UInt64;
begin
  if a > b then Result := a else Result := b;
end;

class function ez.Max(const a, b: Float64): Float64;
begin
  if a > b then Result := a else Result := b;
end;

class function ez.Max(const a, b: Float32): Float32;
begin
  if a > b then Result := a else Result := b;
end;

class function ez.Min(const a, b: Int64): Int64;
begin
  if a < b then Result := a else Result := b;
end;

class function ez.Min(const a, b: UInt32): UInt32;
begin
  if a < b then Result := a else Result := b;
end;

class function ez.Min(const a, b: Int32): Int32;
begin
  if a < b then Result := a else Result := b;
end;

class function ez.Min(const a, b: UInt64): UInt64;
begin
  if a < b then Result := a else Result := b;
end;

class function ez.Min(const a, b: Float64): Float64;
begin
  if a < b then Result := a else Result := b;
end;

class function ez.Min(const a, b: Float32): Float32;
begin
  if a < b then Result := a else Result := b;
end;

class function ez.Min(const a, b, c: Int32): Int32;
begin
  Result := a;
  if b < Result then Result := b;
  if c < Result then Result := c;
end;

class function ez.Min(const a, b, c: Int64): Int64;
begin
  Result := a;
  if b < Result then Result := b;
  if c < Result then Result := c;
end;

class function ez.Min(const a, b, c: UInt32): UInt32;
begin
  Result := a;
  if b < Result then Result := b;
  if c < Result then Result := c;
end;

class function ez.Min(const a, b, c: UInt64): UInt64;
begin
  Result := a;
  if b < Result then Result := b;
  if c < Result then Result := c;
end;

class function ez.Min(const a, b, c: Float32): Float32;
begin
  Result := a;
  if b < Result then Result := b;
  if c < Result then Result := c;
end;

class function ez.Min(const a, b, c: Float64): Float64;
begin
  Result := a;
  if b < Result then Result := b;
  if c < Result then Result := c;
end;

class function ez.Max(const a, b, c: Int32): Int32;
begin
  Result := a;
  if b > Result then Result := b;
  if c > Result then Result := c;
end;

class function ez.Max(const a, b, c: UInt32): UInt32;
begin
  Result := a;
  if b > Result then Result := b;
  if c > Result then Result := c;
end;

class function ez.Max(const a, b, c: Int64): Int64;
begin
  Result := a;
  if b > Result then Result := b;
  if c > Result then Result := c;
end;

class function ez.Max(const a, b, c: UInt64): UInt64;
begin
  Result := a;
  if b > Result then Result := b;
  if c > Result then Result := c;
end;

class function ez.Max(const a, b, c: Float32): Float32;
begin
  Result := a;
  if b > Result then Result := b;
  if c > Result then Result := c;
end;

class function ez.Max(const a, b, c: Float64): Float64;
begin
  Result := a;
  if b > Result then Result := b;
  if c > Result then Result := c;
end;

class function ez.Sign(const a: Int32): Int32;
begin
  if a > 0
    then Result := 1
  else if a = 0
    then Result := 0
    else Result := -1;
end;

class function ez.Sign(const a: Int64): Int32;
begin
  if a > 0
    then Result := 1
  else if a = 0
    then Result := 0
    else Result := -1;
end;

class function ez.Sign(const a: Float32): Int32;
begin
  if a > 0
    then Result := 1
  else if a = 0
    then Result := 0
    else Result := -1;
end;

class function ez.Sign(const a: Float64): Int32;
begin
  if a > 0
    then Result := 1
  else if a = 0
    then Result := 0
    else Result := -1;
end;

class function ez.RoundDiv(const a, b: UInt64): UInt64;
begin
  Result := (a + b shr 1) div b;
end;

class function ez.RoundDiv(const a, b: UInt32): UInt32;
begin
  Result := (a + b shr 1) div b;
end;

class function ez.RoundDiv(const a, b: Int32): Int32;
begin
  Result := (a + b shr 1) div b;
end;

class function ez.Random(const Range, OldValue: Integer): Integer;
begin
  if Range <= 1 then Exit(0);
  repeat
    Result := System.Random(Range);
  until Result <> OldValue;
end;

class function ez.RoundDiv(const a, b: Int64): Int64;
begin
  Result := (a + b shr 1) div b;
end;

class function ez.DistanceSquare(const dx, dy: NInt): Int64;
begin
  Result := Int64(dx) * dx + Int64(dy) * dy;
end;

class function ez.DistanceSquare(const x1, y1, x2, y2: NInt): Int64;
begin
  Result := DistanceSquare(x1 - x2, y1 - y2);
end;

class function ez.DistanceSquare(const p1, p2: TPoint): Int64;
begin
  Result := DistanceSquare(p1.X - p2.X, p1.Y -p2.Y);
end;

class function ez.DistanceSquare(const dx, dy: FloatEx): FloatEx;
begin
  Result := dx * dx + dy * dy;
end;

class function ez.DistanceSquare(const x1, y1, x2, y2: FloatEx): FloatEx;
begin
  Result := DistanceSquare(x1 - x2, y1 - y2);
end;

class function ez.DistanceSquare(const p1, p2: TPointF): FloatEx;
begin
  Result := DistanceSquare(p1.X - p2.X, p1.Y -p2.Y);
end;

class function ez.Distance(const dx, dy: NInt): FloatEx;
begin
  Result := Sqrt(Int64(dx) * dx + Int64(dy) * dy);
end;

class function ez.Distance(const x1, y1, x2, y2: NInt): FloatEx;
begin
  Result := Distance(x1 - x2, y1 - y2);
end;

class function ez.Distance(const p1, p2: TPoint): FloatEx;
begin
  Result := Distance(p1.X - p2.X, p1.Y -p2.Y);
end;

class function ez.Distance(const dx, dy: FloatEx): FloatEx;
begin
  Result := Sqrt(dx * dx + dy * dy);
end;

class function ez.Distance(const x1, y1, x2, y2: FloatEx): FloatEx;
begin
  Result := Distance(x1 - x2, y1 - y2);
end;

class function ez.Distance(const p1, p2: TPointF): FloatEx;
begin
  Result := Distance(p1.X - p2.X, p1.Y -p2.Y);
end;

class function ez.RoundFitToI32(const F: FloatEx): Int32;
begin
  if F >= High(Int32)
    then Result := High(Int32)
  else if F <= Low(Int32)
    then Result := Low(Int32)
    else Result := Round(F);
end;

class function ez.RoundFitToI64(const F: FloatEx): Int64;
begin
  if F >= High(Int64)
    then Result := High(Int64)
  else if F <= Low(Int64)
    then Result := Low(Int64)
    else Result := Round(F);
end;

class function ez.RoundFitToU32(const F: FloatEx): UInt32;
begin
  if F >= High(UInt32)
    then Result := High(UInt32)
  else if F <= 0
    then Result := 0
    else Result := Round(F);
end;

class function ez.RoundFitToU64(const F: FloatEx): UInt64;
begin
  if F >= High(UInt64)
    then Result := High(UInt64)
  else if F <= 0
    then Result := 0
    else Result := Round(F);    // I think Delphi maps this to System._RoundU, not sure
end;

class procedure ez.Swap(var a, b: Int64);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: UInt8);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: Int8);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: Int16);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: Int32);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: UInt16);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: Float32);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: Float64);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: UInt32);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: UInt64);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: Char16);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: Char8);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: Pointer);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: TObject);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: string);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.Swap(var a, b: ByteString);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.ToSmaller(var a: UInt8; const Value: UInt8);
begin
  if a > Value then a := Value;
end;

class procedure ez.ToSmaller(var a: UInt16; const Value: UInt16);
begin
  if a > Value then a := Value;
end;

class procedure ez.ToSmaller(var a: UInt32; const Value: UInt32);
begin
  if a > Value then a := Value;
end;

class procedure ez.ToSmaller(var a: UInt64; const Value: UInt64);
begin
  if a > Value then a := Value;
end;

class procedure ez.ToSmaller(var a: Int8; const Value: Int8);
begin
  if a > Value then a := Value;
end;

class procedure ez.ToSmaller(var a: Int16; const Value: Int16);
begin
  if a > Value then a := Value;
end;

class procedure ez.ToSmaller(var a: Int32; const Value: Int32);
begin
  if a > Value then a := Value;
end;

class procedure ez.ToSmaller(var a: Int64; const Value: Int64);
begin
  if a > Value then a := Value;
end;

class procedure ez.ToSmaller(var a: Float32; const Value: Float32);
begin
  if a > Value then a := Value;
end;

class procedure ez.ToSmaller(var a: Float64; const Value: Float64);
begin
  if a > Value then a := Value;
end;

class procedure ez.ToLarger(var a: UInt8; const Value: UInt8);
begin
  if a < Value then a := Value;
end;

class procedure ez.ToLarger(var a: UInt16; const Value: UInt16);
begin
  if a < Value then a := Value;
end;

class procedure ez.ToLarger(var a: UInt32; const Value: UInt32);
begin
  if a < Value then a := Value;
end;

class procedure ez.ToLarger(var a: UInt64; const Value: UInt64);
begin
  if a < Value then a := Value;
end;

class procedure ez.ToLarger(var a: Int8; const Value: Int8);
begin
  if a < Value then a := Value;
end;

class procedure ez.ToLarger(var a: Int16; const Value: Int16);
begin
  if a < Value then a := Value;
end;

class procedure ez.ToLarger(var a: Int32; const Value: Int32);
begin
  if a < Value then a := Value;
end;

class procedure ez.ToLarger(var a: Int64; const Value: Int64);
begin
  if a < Value then a := Value;
end;

class procedure ez.ToLarger(var a: Float32; const Value: Float32);
begin
  if a < Value then a := Value;
end;

class procedure ez.ToLarger(var a: Float64; const Value: Float64);
begin
  if a < Value then a := Value;
end;



class procedure ez.ToRange(var a: FloatEx; const Low, High: FloatEx);
begin
  if a < Low
    then a := Low
    else if a > High
      then a := High;
end;

class function ez.EnsureRange(const Value, Min, Max: FloatEx): FloatEx;
begin
  if Value <= Min
    then Result := Min
    else if Value > Max
      then Result := Max
      else Result := Value;
end;

class function ez.InRange(const AValue, AMin, AMax: FloatEx): Boolean;
begin
  Result := (AValue >= AMin) and (AValue <= AMax);
end;

class function ez.Sign(const a: FloatEx): Int32;
begin
  if a > 0
    then Result := 1
  else if a = 0
    then Result := 0
    else Result := -1;
end;

class function ez.Max(const a, b: FloatEx): FloatEx;
begin
  if a > b then Result := a else Result := b;
end;

class function ez.Min(const a, b: FloatEx): FloatEx;
begin
  if a < b then Result := a else Result := b;
end;

class function ez.Min(const a, b, c: FloatEx): FloatEx;
begin
  Result := a;
  if b < Result then Result := b;
  if c < Result then Result := c;
end;

class function ez.Max(const a, b, c: FloatEx): FloatEx;
begin
  Result := a;
  if b > Result then Result := b;
  if c > Result then Result := c;
end;

class procedure ez.Swap(var a, b: FloatEx);
begin
  var t := a;
  a := b; b := t;
end;

class procedure ez.ToSmaller(var a: FloatEx; const Value: FloatEx);
begin
  if a > Value then a := Value;
end;

class procedure ez.ToLarger(var a: FloatEx; const Value: FloatEx);
begin
  if a < Value then a := Value;
end;
{$ENDREGION}

initialization
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
end.
