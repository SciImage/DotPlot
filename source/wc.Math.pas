unit wc.Math;

{$I wc.Base.inc}
{$SCOPEDENUMS ON}

interface

uses
  Types, Math, SysUtils,
  wc.Types, wc.Base;

type
{$Region 'TFloat32sHelper'}
  TFloat32sHelper = record helper for TFloat32s
  strict private
    function GetLength: NInt;                                                   inline;
    procedure FillFloat(var Target; Count: NInt; const [Ref] Value: Float32); inline;
  public
    type TFilterFunc = reference to function(const Value: Float32): Boolean;

    class function Create(Size: NInt): TFloat32s;                               overload; static; inline;
    class function Create(Size: NInt; const FillValue: Float32): TFloat32s;     overload; static; inline;
    class function Create(const Items: Array of Float32): TFloat32s;            overload; static;
    class function Create(const s: string; Sep: Char; out Fail, Empty: NInt): TFloat32s;        overload; static; inline;
    class function Create(const s: string; out Fail, Empty: NInt): TFloat32s;                   overload; static; inline; // By Line Retrun
    class function Create(const Strings: TStringArray; out Fail, Empty: NInt): TFloat32s;       overload; static; inline;
    class function Empty: TFloat32s;                                            static; inline;

    // These will not change Self
    function  IsEmpty: Boolean;                                                 inline;
    function  NotEmpty: Boolean;                                                inline;
    function  Equals(const Items: Array of Float32): Boolean;
    function  IndexOf(const Value: Float32; fromIndex: NInt = 0): NInt;         overload;
    function  LastIndexOf(const Value: Float32): NInt;                          overload; inline;   // fromIndex is included;
    function  LastIndexOf(const Value: Float32; fromIndex: NInt): NInt;         overload;           // fromIndex is included;
    function  Includes(const Value: Float32): Boolean;                          overload; inline;
    function  CountOf(n: Float32): NInt;
    function  ToString: string;                                                 overload; inline;
    function  ToString(const Dividend: string): string;                         overload; inline;
    function  ToString(const Dividend: string; Index, Len: NInt):String;        overload;

    // These are mutable
    procedure Clear;                                                            inline;
    procedure SetLength(Size: NInt);                                            overload; inline;
    procedure SetLength(Size: NInt; const ValueForNewItems: Float32);           overload;
    procedure EnsureLength(Size: NInt);                                         inline;

    procedure Assign(const Items: Array of Float32);                            overload;
    procedure Assign(const Items: TFloat32s);                                   overload; inline;
    procedure Assign(const s: string; Sep: Char; out Fail, Empty: NInt);        overload; inline;
    procedure Assign(const s: string; out Fail, Empty: NInt);                   overload; inline; // By Line Retrun
    procedure Assign(const Strings: TStringArray; out Fail, Empty: NInt);       overload;
    procedure CopyFrom(const Items: Array of Float32; ToIndex: NInt = 0);       overload;           // May enlarge the array
    procedure CopyFrom(const Items: Array of Float32; Index, Len: NInt; ToIndex: NInt = 0);     overload;           // May enlarge the array
    function  GetSortedCopy: TFloat32s;
    function  Filter(FilterFunc: TFilterFunc): TFloat32s;

    procedure Fill(const FillValue: Float32; Index: NInt = 0);                  overload; inline;
    procedure Fill(const FillValue: Float32; Index, Len: NInt);                 overload;

    function  Add(const Value: Float32): NInt;                                  overload; inline;
    function  Add(const Items: Array of Float32): NInt;                         overload;
    function  AddUnique(const Value: Float32): NInt;                            inline;
    function  Prepend(const Value: Float32): NInt;                              inline;
    function  Insert(Index: NInt; const Value: Float32): NInt;                  overload;
    function  Insert(Index: NInt; const Items: Array of Float32): NInt;         overload;
    function  Delete(Index: NInt; Len: NInt = 1): NInt;
    function  Remove(const Value: Float32; fromIndex: NInt = 0): Boolean;
    function  RemoveAll(const Value: Float32; fromIndex: NInt = 0): NInt;
    function  Pop: Float32;                                                     inline;
    function  Dequeue: Float32;                                                 inline;

    procedure Move(FromIndex, ToIndex: NInt);
    procedure Exchange(Index1, Index2: NInt);
    procedure Reverse;                                                          overload;
    procedure Sort(Ascending: Boolean = True);                                  overload;

    property  Length: NInt               read GetLength;// write SetLength;
  // Float-specific
    function Mean: Float32;                                                     inline;
    function Sum: Float32;                                                      inline;
    function SumOfSquares: Float32;                                             inline;
    function MinValue: Float32;                                                 inline;
    function MaxValue: Float32;                                                 inline;
    function StdDev: Float32;                                                   inline;
    function PopnStdDev: Float32;                                               inline;
    function Variance: Float32;                                                 inline;
    function PopnVariance: Float32;                                             inline;
    function TotalVariance: Float32;                                            inline;
    function Norm: Float32;                                                     inline;
    procedure SumsAndSquares(var Sum, SumOfSquares: FloatEx);                   inline;
    procedure MinAndMax(var MinValue, MaxValue: Float32);
    procedure MeanAndStdDev(var Mean, StdDev: Float32);                         inline;
  end;
{$ENDREGION}

{$Region 'TFloat64sHelper'}
  TFloat64sHelper = record helper for TFloat64s
  strict private
    function GetLength: NInt;                                                   inline;
    procedure FillFloat(var Target; Count: NInt; const [Ref] Value: Float64); inline;
  public
    type TFilterFunc = reference to function(const Value: Float64): Boolean;

    class function Create(Size: NInt): TFloat64s;                               overload; static; inline;
    class function Create(Size: NInt; const FillValue: Float64): TFloat64s;     overload; static; inline;
    class function Create(const Items: Array of Float64): TFloat64s;            overload; static;
    class function Create(const s: string; Sep: Char; out Fail, Empty: NInt): TFloat64s;        overload; static; inline;
    class function Create(const s: string; out Fail, Empty: NInt): TFloat64s;                   overload; static; inline; // By Line Retrun
    class function Create(const Strings: TStringArray; out Fail, Empty: NInt): TFloat64s;       overload; static; inline;
    class function Empty: TFloat64s;                                            static; inline;

    // These will not change Self
    function  IsEmpty: Boolean;                                                 inline;
    function  NotEmpty: Boolean;                                                inline;
    function  Equals(const Items: Array of Float64): Boolean;
    function  IndexOf(const Value: Float64; fromIndex: NInt = 0): NInt;         overload;
    function  LastIndexOf(const Value: Float64): NInt;                          overload; inline;   // fromIndex is included;
    function  LastIndexOf(const Value: Float64; fromIndex: NInt): NInt;         overload;           // fromIndex is included;
    function  Includes(const Value: Float64): Boolean;                          overload; inline;
    function  CountOf(n: Float64): NInt;
    function  ToString: string;                                                 overload; inline;
    function  ToString(const Dividend: string): string;                         overload; inline;
    function  ToString(const Dividend: string; Index, Len: NInt):String;        overload;

    // These are mutable
    procedure Clear;                                                            inline;
    procedure SetLength(Size: NInt);                                            overload; inline;
    procedure SetLength(Size: NInt; const ValueForNewItems: Float64);           overload;
    procedure EnsureLength(Size: NInt);                                         inline;

    procedure Assign(const Items: Array of Float64);                            overload;
    procedure Assign(const Items: TFloat64s);                                   overload; inline;
    procedure Assign(const s: string; Sep: Char; out Fail, Empty: NInt);        overload; inline;
    procedure Assign(const s: string; out Fail, Empty: NInt);                   overload; inline; // By Line Retrun
    procedure Assign(const Strings: TStringArray; out Fail, Empty: NInt);       overload;
    procedure CopyFrom(const Items: Array of Float64; ToIndex: NInt = 0);       overload;           // May enlarge the array
    procedure CopyFrom(const Items: Array of Float64; Index, Len: NInt; ToIndex: NInt = 0);     overload;           // May enlarge the array
    function  GetSortedCopy: TFloat64s;
    function  Filter(FilterFunc: TFilterFunc): TFloat64s;

    procedure Fill(const FillValue: Float64; Index: NInt = 0);                  overload; inline;
    procedure Fill(const FillValue: Float64; Index, Len: NInt);                 overload;

    function  Add(const Value: Float64): NInt;                                  overload; inline;
    function  Add(const Items: Array of Float64): NInt;                         overload;
    function  AddUnique(const Value: Float64): NInt;                            inline;
    function  Prepend(const Value: Float64): NInt;                              inline;
    function  Insert(Index: NInt; const Value: Float64): NInt;                  overload;
    function  Insert(Index: NInt; const Items: Array of Float64): NInt;         overload;
    function  Delete(Index: NInt; Len: NInt = 1): NInt;
    function  Remove(const Value: Float64; fromIndex: NInt = 0): Boolean;
    function  RemoveAll(const Value: Float64; fromIndex: NInt = 0): NInt;
    function  Pop: Float64;                                                     inline;
    function  Dequeue: Float64;                                                 inline;

    procedure Move(FromIndex, ToIndex: NInt);
    procedure Exchange(Index1, Index2: NInt);
    procedure Reverse;                                                          overload;
    procedure Sort(Ascending: Boolean = True);                                  overload;

    property  Length: NInt               read GetLength;// write SetLength;

    // Float-specific
    function Mean: Float64;                                                     inline;
    function Sum: Float64;                                                      inline;
    function SumOfSquares: Float64;                                             inline;
    function MinValue: Float64;                                                 inline;
    function MaxValue: Float64;                                                 inline;
    function StdDev: Float64;                                                   inline;
    function PopnStdDev: Float64;                                               inline;
    function Variance: Float64;                                                 inline;
    function PopnVariance: Float64;                                             inline;
    function TotalVariance: Float64;                                            inline;
    function Norm: Float64;                                                     inline;
    procedure SumsAndSquares(var Sum, SumOfSquares: FloatEx);                   overload; inline;
    procedure SumsAndSquares(var Sum, SumOfSquares: Float64);                   overload; inline;
    procedure MinAndMax(var MinValue, MaxValue: Float64);
    procedure MeanAndStdDev(var Mean, StdDev: Float64);                         inline;

    // Float64-specific
    function Percentile(IsSorted: Boolean; const Percent: Float64): Float64;
    function PercentileExclusive(IsSorted: Boolean; const Percent: Float64): Float64;
  end;
{$ENDREGION}

{$REGION 'TArcDegree'}
  // TArcDegree is a thin wrapper that internally uses a float in radian but also provides
  // a virtual property Degree for read/write
  TArcDegree = record
  private
    Radian: Float32;
  public
    class operator Implicit(const a: TArcDegree): Float32;                      inline;
    class operator Implicit(const Degree: Float32): TArcDegree;                 inline;

    class function DegreeToRadian(const n: FloatEx): FloatEx;                   static; inline;
    class function RadianToDegree(const n: FloatEx): FloatEx;                   static; inline;
    class function RadianOfLine(const dx, dy: FloatEx): FloatEx;                overload; static; // Result is always in [0..pi)
    class function RadianOfLine(const x0, y0, x, y: FloatEx): FloatEx;          overload; static; inline;
    class function RadianBetweenTwo(const Radian1, Radian2: FloatEx): FloatEx;  static; inline;
    class function Normalize2Pi(const Radian: FloatEx): FloatEx;                static;           // Result is in [0, 2pi)
    class function NormalizePi(const Radian: FloatEx): FloatEx;                 static;           // Result is in [0, pi)
    class function NormalizeSignedPi(const Radian: FloatEx): FloatEx;           static;           // Result is in (-pi, pi]
    class function NormalizeSignedHalfPi(const Radian: FloatEx): FloatEx;       static;           // Result is in (-pi/2, pi/2]
    class function DegreeOfLine(const dx, dy: FloatEx): FloatEx;                overload; static; inline; // Result is always in [0..180)
    class function DegreeOfLine(const x0, y0, x, y: FloatEx): FloatEx;          overload; static; inline;
    class function DegreeBetweenTwo(const Degree1, Degree2: FloatEx): FloatEx;  static; inline;
    class function Normalize360(const Degree: FloatEx): FloatEx;                static;           // Result is in [0, 360)
    class function Normalize180(const Degree: FloatEx): FloatEx;                static;           // Result is in [0, 180)
    class function NormalizeSigned180(const Degree: FloatEx): FloatEx;          static;           // Result is in (-180, 180]
    class function NormalizeSigned90(const Degree: FloatEx): FloatEx;           static;           // Result is in (-90, 90]

    procedure Normalize;
    procedure NormalizeTo180;
    procedure NormalizeToPosNeg90;
    procedure NormalizeToPosNeg180;

    function  Sin: Float32;                                                     inline;
    function  Cos: Float32;                                                     inline;
    function  Tan: Float32;                                                     inline;
    function  Cot: Float32;                                                     inline;
    function  Sec: Float32;                                                     inline;
    function  Csc: Float32;                                                     inline;
    function  Cotan: Float32;                                                   inline;
    function  Secant: Float32;                                                  inline;
    function  Cosecant: Float32;                                                inline;
    procedure SinCos(var S, C: Float32);                                        inline;

    procedure SetToSin(const Value: Float32);                                   inline;
    procedure SetToCos(const Value: Float32);                                   inline;
    procedure SetToTan(const Value: Float32);                                   inline;
    procedure SetToCot(const Value: Float32);                                   inline;
    procedure SetToSec(const Value: Float32);                                   inline;
    procedure SetToCsc(const Value: Float32);                                   inline;
    procedure SetToTan2(const X, Y: Float32);                                   inline;
  end;
{$ENDREGION}

{$REGION 'TPointFsHelper'}
  TPolygon = type TPointFs;
  TPointFsHelper         = record helper for TPointFs
  public
    function Length: NInt;                                              inline;
    function IsEmpty: Boolean;                                          inline;
    function NotEmpty: Boolean;                                         inline;
    procedure SetLength(NewLength: NInt);                               inline;

    function Add(const p: TPointF): NInt;                               overload; inline;
    function Add(const x, y: Float32): NInt;                            overload; inline;
    function AddUnique(const p: TPointF): NInt;                         overload; inline;
    function AddUnique(const x, y: Float32): NInt;                      overload; inline;
    function Insert(Index: NInt; const p: TPointF): NInt;               overload;
    function Insert(Index: NInt; const x, y: Float32): NInt;            overload; inline;
    function Remove(const p: TPointF): Boolean;                         overload; inline;
    function Remove(const x, y: Float32): Boolean;                      overload; inline;
    function Delete(Index: NInt; Len: NInt = 1): NInt;
    function Pop: TPointF;                                              inline;
    function Prepend(const Value: TPointF): NInt;                       inline;
    function Dequeue: TPointF;                                          inline;

  // Mutative
    procedure Assign(const Source: TPointFs);
    procedure OffsetBy(const dx, dy: Float32);
    procedure ScaleBy(const n: Float32);                                overload;
    procedure ScaleBy(const nx, ny: Float32);                           overload;
    procedure ScaleAtBy(const x0, y0, nx, ny: Float32);                 overload;
    procedure ScaleOffsetBy(const n, dx, dy: Float32);
    procedure SortByX;
    procedure SortByY;
    function  RemoceDuplicatedNeighbors(Closed: Boolean): Boolean;
    procedure SetTo(const Xs, Ys: TFloat32s);                           overload;
    procedure SetTo(const Xs, Ys: TFloat64s);                           overload;

  // Non-Mutative
    function Clone: TPointFs;
    function Offset(const dx, dy: Float32): TPointFs;
    function Scale(const n: Float32): TPointFs;                         overload;
    function Scale(const nx, ny: Float32): TPointFs;                    overload;
    function ScaleAt(const x0, y0, nx, ny: Float32): TPointFs;          overload;
    function ScaleOffset(const n, dx, dy: Float32): TPointFs;
    function RotateAt(const x0, y0: Float32; const Radian: FloatEx): TPointFs;
    function RotateAtDeg(const x0, y0: Float32; const Degree: FloatEx): TPointFs;
    function GetBoundsAfterRotation(const x0, y0: Float32; const Radian: FloatEx): TRectF;
    function GetSizeAfterRotation(const Radian: FloatEx): TSizeF;
    function GetBounds: TRectF;
    function GetCentroid: TPointF;
    function GetCentroidF: TPointF;                                     inline;
    function MinDistance(const x, y: Float32): FloatEx;                 overload;
    function MinDistance(const p: TPointF): FloatEx;                    overload; inline;
    function MaxDistance(const x, y: Float32): FloatEx;                 overload;
    function MaxDistance(const p: TPointF): FloatEx;                    overload; inline;
    function IndexOf(const x, y: Float32): NInt;                        overload;
    function IndexOf(const p: TPointF): NInt;                           overload; inline;
    function IndexOfNearest(const x, y: Float32): NInt;                 overload;
    function IndexOfNearest(const p: TPointF): NInt;                    overload; inline;
    function IndexOfFarest(const x, y: Float32): NInt;                  overload;
    function IndexOfFarest(const p: TPointF): NInt;                     overload; inline;
    function YSortedIndexOf(const x, y: Float32): NInt;                 overload;        // for sorted by y
    function YSortedIndexOf(const p: TPointF): NInt;                    overload; inline;
    procedure LinearRegression(var k, a, r: FloatEx);
    procedure SeparateXY(var Xs, Ys: TFloat32s);                        overload;
    procedure SeparateXY(var Xs, Ys: TFloat64s);                        overload;

    function IsOnPoint(const x, y: Float32; var Index: NInt; const Tolerance: Float32 = 0.5): Boolean;                                  overload;
    function IsOnLine(const x, y: Float32; var Index: NInt; Closed: Boolean; const Tolerance: Float32 = 0.5): Boolean;                                   overload; inline;
    function HitTest(const x, y: Float32; var Index: NInt; Closed: Boolean; const PointErr: Float32 = 0.5; const LineErr: Float32 = 0.5): THitTestResult; overload;
    function IsOnPoint(const p: TPointF; var Index: NInt; const Tolerance: Float32 = 0.5): Boolean;                                     overload; inline;
    function IsOnLine(const p: TPointF; var Index: NInt; Closed: Boolean; const Tolerance: Float32 = 0.5): Boolean;                                      overload; inline;
    function HitTest(const p: TPointF; var Index: NInt; Closed: Boolean; const PointErr: Float32 = 0.5; const LineErr: Float32 = 0.5): THitTestResult;   overload; inline;

    // AddControlPointsToCurve is used to generate bezier control points to draw a smooth line/shape through all points
    // Input: P0, P1, P2, ...., Pn
    // Output: Open:   P0, C0b, C1a, P1, C1b, C2a, P2, ....., Cna, Pn
    //         Closed: P0, C0b, C1a, P1, C1b, C2a, P2, ....., Cna, Pn, Cnb, C0a, C0
    // When not Closed, the result is different from the other form of AddControlPointsToCurve because
    // a hidden Pn is inserted to the front and a hidden C0 is added to the end for the calculation.
    class function AddControlPointsToCurve(const Points: array of TPointF; Closed: boolean; const Tension: Single = 0.5): TPointFs;                             overload; static;
    function AddControlPointsToCurve(Closed: boolean; const Tension: Single = 0.5): TPointFs;                                                                   overload;
    // The following one is added because TPointFsHelper.AddControlPointsToCurve cannot compile SOMETIMES
    procedure ConvertFromCurveWithControlPoints(const Points: array of TPointF; Closed: boolean; const Tension: Single = 0.5);                                  overload;
    // AddControlPointsToCurve is used to generate bezier control points to draw a smooth line through all points
    // Because cardinal splinea require 4 control points, no line will be generated between P0 and P0, and Pn-1 and Pn.
    // ToIndex can be negative, indicating index from the end
    class function AddControlPointsToCurve(const Points: array of TPointF; FromIndex: NInt = 1; ToIndex: NInt = -2; const Tension: Single = 0.5): TPointFs;     overload; static;
    function AddControlPointsToCurve(FromIndex: NInt = 1; ToIndex: NInt = -2; const Tension: Single = 0.5): TPointFs;                                           overload;
    procedure ConvertFromCurveWithControlPoints(const Points: array of TPointF; FromIndex: NInt = 1; ToIndex: NInt = -2; const Tension: Single = 0.5);          overload;
  end;
{$ENDREGION}

{$REGION 'TPolygonHelper'}
  TPolygonHelper       = record helper for TPolygon
    class function RegularPolygon(nSides: NInt; const CenterX, CenterY, W, H: Float32; const StartingRadian: FloatEx = 0): TPolygon;    overload; static; // Radian: 0 = Right; 90: Down
    class function RegularPolygon(nSides: NInt; const W, H: Float32; const StartingRadian: FloatEx = 0): TPolygon;                      overload; static; inline;
    class function RegularPolygon(nSides: NInt; const CenterX, CenterY, Radius: Float32; const StartingRadian: FloatEx = 0): TPolygon;  overload; static; inline; // Radian: 0 = Right; 90: Down
    class function RegularPolygon(nSides: NInt; const Radius: Float32; const StartingRadian: FloatEx = 0): TPolygon;                    overload; static; inline;
    class function RegularPolygonDeg(nSides: NInt; const CenterX, CenterY, W, H: Float32; const StartingDeg: FloatEx = 0): TPolygon;    overload; static; // Degree: 0 = Right; 90: Down
    class function RegularPolygonDeg(nSides: NInt; const W, H: Float32; const StartingDeg: FloatEx = 0): TPolygon;                      overload; static; inline;
    class function RegularPolygonDeg(nSides: NInt; const CenterX, CenterY, Radius: Float32; const StartingDeg: FloatEx = 0): TPolygon;  overload; static; inline; // Degree: 0 = Right; 90: Down
    class function RegularPolygonDeg(nSides: NInt; const Radius: Float32; const StartingDeg: FloatEx = 0): TPolygon;                    overload; static; inline;
    class function Star(nSides: NInt; const CenterX, CenterY, Outer, Inner: Float32; const StartingRadian: FloatEx = 0): TPolygon;      overload; static; inline;
    class function Star(nSides: NInt; const CenterX, CenterY, Outer: Float32; const StartingRadian: FloatEx = 0): TPolygon;             overload; static; inline;
    class function StarDeg(nSides: NInt; const CenterX, CenterY, Outer, Inner: Float32; const StartingDeg: FloatEx = 0): TPolygon;      overload; static; inline;
    class function StarDeg(nSides: NInt; const CenterX, CenterY, Outer: Float32; const StartingDeg: FloatEx = 0): TPolygon;             overload; static; inline;
    class function Circle(const CenterX, CenterY, Radius: Float32): TPolygon;                                                           overload; static;
    class function Circle(const Radius: Float32): TPolygon;                                                                             overload; static;
    class function Ellipse(const CenterX, CenterY, RadiusX, RadiusY: Float32): TPolygon;                                                overload; static;
    class function Ellipse(const RadiusX, RadiusY: Float32): TPolygon;                                                                  overload; static;
    class function Square(const Width: Float32): TPolygon;                                                                              overload; static;
    class function Square(const CenterX, CenterY, Width: Float32): TPolygon;                                                            overload; static;
    class function Rectangle(const Width, Height: Float32): TPolygon;                                                                   overload; static;
    class function Rectangle(const CenterX, CenterY, Width, Height: Float32): TPolygon;                                                 overload; static;
    class function RoundSquare(const Width, Radius: Float32): TPolygon;                                                                 overload; static;
    class function RoundSquare(const CenterX, CenterY, Width, Radius: Float32): TPolygon;                                               overload; static;
    class function RoundRectangle(const Width, Height, RadiusX, RadiusY: Float32): TPolygon;                                            overload; static;
    class function RoundRectangle(const CenterX, CenterY, Width, Height, RadiusX, RadiusY: Float32): TPolygon;                          overload; static;
    class function Diamond(const Width, Height: Float32): TPolygon;                                                                     overload; static;
    class function Diamond(const CenterX, CenterY, Width, Height: Float32): TPolygon;                                                   overload; static;
    class function Cross(const Width, Height, Thickness: Float32): TPolygon;                                                            overload; static;
    class function Cross(const CenterX, CenterY, Width, Height, Thickness: Float32): TPolygon;                                          overload; static;
    class function Plus(const Width, Height, ThicknessX, ThicknessY: Float32): TPolygon;                                                overload; static;
    class function Plus(const CenterX, CenterY, Width, Height, ThicknessX, ThicknessY: Float32): TPolygon;                              overload; static;
    class function Arrow(const x0, y0, x1, y1, wBody, wHead, lHead, lSunken: Float32): TPolygon;                                                  static;
    class function PointInPolygon(const p: TPointF; const Polygon: TPolygon): Boolean;                                                            static;

  // Non-Mutative
    function Clone: TPolygon;
    function GetCentroid: TPointF;
    function GetCentroidF: TPointF;                                                                                                     inline;
    function GetArea: FloatEx;
    function GetPerimeter: FloatEx;
    function GetCircularity: FloatEx;
    function ReducePoints(MaxNumberOfPoint: NInt; MinErrorInArea: FloatEx): TPolygon;

    function IsOnPoint(const x, y: Float32; var Index: NInt; const Tolerance: Float32 = 0.5): Boolean;                                  overload;
    function IsOnLine(const x, y: Float32; var Index: NInt; const Tolerance: Float32 = 0.5): Boolean;                                   overload; inline;
    function IsInside(const x, y: Float32): Boolean;                                                                                    overload; inline;
    function HitTest(const x, y: Float32; var Index: NInt; const PointErr: Float32 = 0.5; const LineErr: Float32 = 0.5): THitTestResult; overload;
    function IsOnPoint(const p: TPointF; var Index: NInt; const Tolerance: Float32 = 0.5): Boolean;                                     overload; inline;
    function IsOnLine(const p: TPointF; var Index: NInt; const Tolerance: Float32 = 0.5): Boolean;                                      overload; inline;
    function IsInside(const p: TPointF): Boolean;                                                                                       overload; inline;
    function HitTest(const p: TPointF; var Index: NInt; const PointErr: Float32 = 0.5; const LineErr: Float32 = 0.5): THitTestResult;   overload; inline;
  end;
{$ENDREGION}

implementation

uses
  System.SysConst, RTLConsts,
  wc.Consts;//, wc.Math.SciArray;

type
  PPointFs = ^TPointFs;

const
  cPidiv180: String = '0.017453292';
  c180divPI: String = '57.29577951';
  cPidiv2: String = '1.570796326';
  cPidiv4: String = '0.785398163';
  c3PIdiv4: String = '2.35619449';
  cInv2PI: String = '1 / 6.283185307';
  cInv360: String = '1 / 360';
  c180: String = '180';
  c360: String = '360';

{$Region 'TFloat32sHelper'}
procedure TFloat32sHelper.FillFloat(var Target; Count: NInt; const [Ref] Value: Float32);
begin
  ez.FillLong(Target, Count, PInt32(@Value)^);
end;

class function TFloat32sHelper.Create(Size: NInt): TFloat32s;
begin
  System.SetLength(Result, Size);
end;

class function TFloat32sHelper.Create(Size: NInt; const FillValue: Float32): TFloat32s;
begin
  System.SetLength(Result, Size);
  Result.Fill(FillValue);
end;

class function TFloat32sHelper.Create(const Items: array of Float32): TFloat32s;
begin
  System.SetLength(Result, System.Length(Items));
  if Result.Length > 0 then
    System.Move(Items[0], Result[0],Result.Length * SizeOf(Float32));
end;

class function TFloat32sHelper.Create(const s: string; Sep: Char; out Fail, Empty: NInt): TFloat32s;
begin
  Result.Assign(s, Sep, Fail, Empty);
end;

class function TFloat32sHelper.Create(const s: string; out Fail, Empty: NInt): TFloat32s;
begin
  Result.Assign(s, Fail, Empty);
end;

class function TFloat32sHelper.Create(const Strings: TStringArray; out Fail, Empty: NInt): TFloat32s;
begin
  Result.Assign(Strings, Fail, Empty);
end;

class function TFloat32sHelper.Empty: TFloat32s;
begin
  Result := nil;
end;


function TFloat32sHelper.GetLength: NInt;
begin
  Result := System.Length(Self);
end;

function TFloat32sHelper.IsEmpty: Boolean;
begin
  Result := TNInts(Self) = nil;
end;

function TFloat32sHelper.NotEmpty: Boolean;
begin
  Result := TNInts(Self) <> nil;
end;

function TFloat32sHelper.Equals(const Items: array of Float32): Boolean;
begin
  Result := (Length = System.Length(Items)) and
            (IsEmpty or CompareMem(@Self[0], @(Items[0]), Length * SizeOf(Float32)));
end;

function TFloat32sHelper.IndexOf(const Value: Float32; fromIndex: NInt): NInt;
begin
  if fromIndex < 0 then fromIndex := 0;
  for var i := fromIndex to Length - 1 do
    if Self[i] = Value then Exit(i);
  Result := -1;
end;

function TFloat32sHelper.LastIndexOf(const Value: Float32; fromIndex: NInt): NInt;
begin
  if fromIndex >= Length then fromIndex := Length - 1;
  for var i := fromIndex downto 0 do
    if Self[i] = Value then Exit(i);
  Result := -1;
end;

function TFloat32sHelper.LastIndexOf(const Value: Float32): NInt;
begin
  Result := LastIndexOf(Value, Length - 1);
end;

function TFloat32sHelper.Includes(const Value: Float32): Boolean;
begin
  Result := IndexOf(Value, 0) >= 0;
end;

function TFloat32sHelper.CountOf(n: Float32): NInt;
begin
  Result := 0;
  for var i := 0 to Length - 1 do
    if Self[i] = n then inc(Result);
end;

function TFloat32sHelper.ToString: string;
begin
  Result := ToString(FormatSettings.ListSeparator, 0, Length);
end;

function TFloat32sHelper.ToString(const Dividend: string): string;
begin
  Result := ToString(Dividend, 0, Length);
end;

function TFloat32sHelper.ToString(const Dividend: string; Index, Len: NInt):String;
begin
  if (Index < 0) then Exception.RaiseIndexError(Index);
  ez.ToSmaller(Len, Length - Index);
  if Len <= 0 then Exit('');

  var sb := TStringBuilder.Create(Len * (4 + System.Length(Dividend)));
  try
    sb.Append(Self[Index]);
    for var i := Index + 1 to Index + Len - 1 do
      sb.Append(Dividend).Append(Self[i]);
    Result := sb.ToString;
  finally
    sb.Free;
  end;
end;

procedure TFloat32sHelper.Clear;
begin
  Self := nil;
end;

procedure TFloat32sHelper.SetLength(Size: NInt);
begin
  System.SetLength(Self, Size);
end;

procedure TFloat32sHelper.SetLength(Size: NInt; const ValueForNewItems: Float32);
begin
  var OldSize := Length;
  SetLength(Size);
  if Size > OldSize then FillFloat(Self[OldSize], Size - OldSize, ValueForNewItems);
end;

procedure TFloat32sHelper.EnsureLength(Size: NInt);
begin
  if Length < Size then SetLength(Size);
end;

procedure TFloat32sHelper.Assign(const Items: array of Float32);
begin
  SetLength(System.Length(Items));
  if Length > 0 then
    System.Move(Items[0], Self[0], Length * SizeOf(Float32));
end;

procedure TFloat32sHelper.Assign(const Items: TFloat32s);
begin
  Self := System.Copy(Items);
end;

procedure TFloat32sHelper.Assign(const s: string; Sep: Char; out Fail, Empty: NInt);
begin
  var ss := TStringArray.Create(s, Sep, False);
  Assign(ss, Fail, Empty);
end;

procedure TFloat32sHelper.Assign(const s: string; out Fail, Empty: NInt);
begin
  var ss :=  TStringArray.CreateFromLines(s, False);
  Assign(ss, Fail, Empty);
end;

procedure TFloat32sHelper.Assign(const Strings: TStringArray; out Fail, Empty: NInt);
begin
  Empty := 0;
  SetLength(Strings.Length);
  var l: NInt := 0;

  for var i := 0 to Length - 1 do
  begin
    var s := Strings[i].Trim;
    if s = '' then Inc(Empty)
    else if Float32.TryParse(s, Self[l]) then Inc(l);
  end;
  SetLength(l);
  Fail := Strings.Length - l - Empty;
end;

procedure TFloat32sHelper.CopyFrom(const Items: array of Float32; ToIndex: NInt = 0);
begin
  if (ToIndex < 0) or (ToIndex > Length) then Exception.RaiseIndexError(ToIndex);

  var l := System.Length(Items);
  if ToIndex + l > Length then
    SetLength(ToIndex + l);
  System.Move(Items[0], Self[ToIndex], l * SizeOf(Float32));
end;

procedure TFloat32sHelper.CopyFrom(const Items: array of Float32; Index, Len: NInt; ToIndex: NInt = 0);
begin
  if (ToIndex < 0) or (ToIndex > Length) then Exception.RaiseIndexError(ToIndex);
  if (Index < 0) then Exception.RaiseIndexError(ToIndex);
  Len.SetToSmaller(System.Length(Items) - Index);
  if Len <= 0 then Exit;

  if ToIndex + Len > Length then
    SetLength(ToIndex + Len);
  System.Move(Items[Index], Self[ToIndex], Len * SizeOf(Float32));
end;

function TFloat32sHelper.GetSortedCopy: TFloat32s;
var
  m, n, i, j, l: NInt;
  d: Float32;
begin
  if Self = nil then Exit(nil);
  Result.SetLength(Length);
  Result[0] := Self[0];
  l := 1;

  for j := 1 to Length - 1 do
  begin
    m := 0;
    n := l - 1;
    d := Self[j];
    while m <= n do
    begin
      i := (m + n) shr 1;
      if d > Result[i]
        then m := i + 1
      else if d < Result[i]
        then n := i - 1
      else begin
         m := i;
         break;
       end;
    end;
    if (m < l) and (Result[m] <= d) then inc(m);
    inc(l);
    for i := l - 1 downto m + 1 do
      Result[i] := Result[i - 1];
    Result[m] := d;
  end;
end;

function TFloat32sHelper.Filter(FilterFunc: TFilterFunc): TFloat32s;
var
  i, l: NInt;
begin
  if Self = nil then Exit(nil);
  Result.SetLength(Length);
  l := 0;
  for i := 0 to Length - 1 do
    if FilterFunc(Self[i]) then
    begin
      Result[l] := Self[i];
      inc(l);
    end;
  Result.SetLength(l);
end;

procedure TFloat32sHelper.Fill(const FillValue: Float32; Index: NInt);
begin
  Fill(FillValue, Index, Length);
end;

procedure TFloat32sHelper.Fill(const FillValue: Float32; Index, Len: NInt);
begin
  if (Index < 0) then Exception.RaiseIndexError(Index);
  if Index >= Length then exit;
  ez.ToSmaller(Len, Length - Index);
  if Len <= 0 then Exit;
  FillFloat(Self[Index], Len, FillValue);
end;

function TFloat32sHelper.Add(const Value: Float32): NInt;
begin
  Result := Length;
  SetLength(Result + 1);
  Self[Result] := Value;
end;

function TFloat32sHelper.Add(const Items: array of Float32): NInt;
begin
  Result := Length;
  SetLength(Result + System.Length(Items));
  CopyFrom(Items, Result);
end;

function TFloat32sHelper.AddUnique(const Value: Float32): NInt;
begin
  Result := IndexOf(Value);
  if Result < 0 then Result := Add(Value);
end;

function TFloat32sHelper.Prepend(const Value: Float32): NInt;
begin
  Result := Insert(0, Value);
end;

function TFloat32sHelper.Insert(Index: NInt; const Value: Float32): NInt;
begin
  if Index < 0
    then Result := 0
  else if Index > Length
    then Result := Length
    else Result := Index;
  System.Insert(Value, Self, Result);
end;

function TFloat32sHelper.Insert(Index: NInt; const Items: array of Float32): NInt;
begin
  if (Index < 0) or (Index > Length) then Exception.RaiseIndexError(Index);
  SetLength(Length + System.Length(Items));
  if Index < Length then
    System.Move(Self[Index], Self[Index + System.Length(Items)], (Length - Index) * SizeOf(Float32));
  CopyFrom(Items, Index);
  Result := Index;
end;

function TFloat32sHelper.Delete(Index: NInt; Len: NInt): NInt;
begin
  if (Index < 0) then Exception.RaiseIndexError(Index);
  Result := ez.Min(Len, Length - Index);
  if Result <= 0 then exit(0);
  System.Delete(Self, Index, Result);
end;

function TFloat32sHelper.Remove(const Value: Float32; fromIndex: NInt): Boolean;
begin
  var i := IndexOf(Value, fromIndex);
  Result := (i >= 0);
  if Result then Delete(i);
end;

function TFloat32sHelper.RemoveAll(const Value: Float32; fromIndex: NInt): NInt;
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

function TFloat32sHelper.Pop: Float32;
begin
  Result := Self[Length - 1];
  SetLength(Length - 1);
end;

function TFloat32sHelper.Dequeue: Float32;
begin
  Result := Self[0];
  Delete(0);
end;

procedure TFloat32sHelper.Move(FromIndex, ToIndex: NInt);
begin
  if (FromIndex < 0) or (FromIndex >= Length) then Exception.RaiseIndexError(FromIndex);
  if (ToIndex < 0)   or (ToIndex >= Length)   then Exception.RaiseIndexError(ToIndex);
  if FromIndex = ToIndex then exit;

  var t := Self[FromIndex];
  if FromIndex < ToIndex
    then System.Move(Self[FromIndex + 1], Self[FromIndex], (ToIndex - FromIndex - 1) * Sizeof(Float32))
    else System.Move(Self[ToIndex], Self[ToIndex + 1], (FromIndex - ToIndex - 1) * Sizeof(Float32));
  Self[ToIndex] := t;
end;

procedure TFloat32sHelper.Exchange(Index1, Index2: NInt);
begin
  if (Index1 < 0) or (Index1 >= Length) then Exception.RaiseIndexError(Index1);
  if (Index2 < 0) or (Index2 >= Length) then Exception.RaiseIndexError(Index2);
  if Index1 = Index2 then exit;

  ez.Swap(Self[Index1], Self[Index2]);
end;

procedure TFloat32sHelper.Reverse;
begin
  if Length < 2 then Exit;              // This is necessary, or it will break when Length = 0
  var l := Length - 1;
  for var i := 0 to (l - 1) shr 1 do
    ez.Swap(Self[i], Self[l - i]);
end;

procedure TFloat32sHelper.Sort(Ascending: Boolean);
  procedure QuickSortAsc(Start, Stop: NInt);
  var
    m, lo, hi: NInt;
  begin
    if Start = Stop then exit else
    if Start + 1 = Stop then
    begin
      if Self[Start] > Self[Stop] then ez.Swap(Self[Start], Self[Stop]);
      exit;
    end else
    if Start + 2 = Stop then
    begin
      if Self[Start]     > Self[Start + 1] then ez.Swap(Self[Start], Self[Start + 1]);
      if Self[Start]     > Self[Stop]      then ez.Swap(Self[Start], Self[Stop]);
      if Self[Start + 1] > Self[Stop]      then ez.Swap(Self[Start + 1], Self[Stop]);
      exit;
    end;
    lo := Start;
    hi := Stop;
    m  := (lo + hi) div 2;
    repeat
      while Self[m] > Self[lo] do inc(lo);
      while Self[m] < Self[hi] do dec(hi);
      if lo < hi then
      begin
        ez.Swap(Self[lo], Self[hi]);
        if lo = m then m := hi else if hi = m then m := lo;
        inc(lo);
        dec(hi);
      end;
    until lo >= hi;
    if hi > Start then QuickSortAsc(Start, hi);
    if lo < Stop  then QuickSortAsc(lo, Stop);
  end;

  procedure QuickSortDsc(Start, Stop: NInt);
  var
    m, lo, hi: NInt;
  begin
    if Start = Stop then exit else
    if Start + 1 = Stop then
    begin
      if Self[Start] < Self[Stop] then ez.Swap(Self[Start], Self[Stop]);
      exit;
    end else
    if Start + 2 = Stop then
    begin
      if Self[Start]     < Self[Start + 1] then ez.Swap(Self[Start], Self[Start + 1]);
      if Self[Start]     < Self[Stop]      then ez.Swap(Self[Start], Self[Stop]);
      if Self[Start + 1] < Self[Stop]      then ez.Swap(Self[Start + 1], Self[Stop]);
      exit;
    end;
    lo := Start;
    hi := Stop;
    m  := (lo + hi) div 2;
    repeat
      while Self[m] < Self[lo] do inc(lo);
      while Self[m] > Self[hi] do dec(hi);
      if lo < hi then
      begin
        ez.Swap(Self[lo], Self[hi]);
        if lo = m then m := hi else if hi = m then m := lo;
        inc(lo);
        dec(hi);
      end;
    until lo >= hi;
    if hi > Start then QuickSortDsc(Start, hi);
    if lo < Stop  then QuickSortDsc(lo, Stop);
  end;
begin
  if Length > 1 then
  if Ascending
    then QuickSortAsc(0, Length - 1)
    else QuickSortDsc(0, Length - 1);
end;

function TFloat32sHelper.Mean: Float32;
begin
  Result := System.Math.Mean(Self);
end;

function TFloat32sHelper.Sum: Float32;
begin
  Result := System.Math.Sum(Self);
end;

function TFloat32sHelper.SumOfSquares: Float32;
begin
  Result := System.Math.SumOfSquares(Self);
end;

function TFloat32sHelper.MinValue: Float32;
begin
  Result := System.Math.MinValue(Self);
end;

function TFloat32sHelper.MaxValue: Float32;
begin
  Result := System.Math.MaxValue(Self);
end;

function TFloat32sHelper.StdDev: Float32;
begin
  Result := System.Math.StdDev(Self);
end;

function TFloat32sHelper.PopnStdDev: Float32;
begin
  Result := System.Math.PopnStdDev(Self);
end;

function TFloat32sHelper.Variance: Float32;
begin
  Result := System.Math.Variance(Self);
end;

function TFloat32sHelper.PopnVariance: Float32;
begin
  Result := System.Math.PopnVariance(Self);
end;

function TFloat32sHelper.TotalVariance: Float32;
begin
  Result := System.Math.TotalVariance(Self);
end;

function TFloat32sHelper.Norm: Float32;
begin
  Result := System.Math.Norm(Self);
end;

procedure TFloat32sHelper.SumsAndSquares(var Sum, SumOfSquares: FloatEx);
begin
  System.Math.SumsAndSquares(Self, Sum, SumOfSquares);
end;

procedure TFloat32sHelper.MinAndMax(var MinValue, MaxValue: Float32);
begin
  if Self.IsEmpty then Exit;
  MinValue := Self[0];
  MaxValue := Self[0];
  for var i := 1 to Length - 1 do
    if Self[i] > MaxValue
      then MaxValue := Self[i]
    else if Self[i] < MinValue
      then MinValue := Self[i];
end;

procedure TFloat32sHelper.MeanAndStdDev(var Mean, StdDev: Float32);
begin
  System.Math.MeanAndStdDev(Self, Mean, StdDev);
end;
{$ENDREGION}

{$Region 'TFloat64sHelper'}
procedure TFloat64sHelper.FillFloat(var Target; Count: NInt; const [Ref] Value: Float64);
begin
  ez.Fill64(Target, Count, PInt64(@Value)^);
end;

class function TFloat64sHelper.Create(Size: NInt): TFloat64s;
begin
  System.SetLength(Result, Size);
end;

class function TFloat64sHelper.Create(Size: NInt; const FillValue: Float64): TFloat64s;
begin
  System.SetLength(Result, Size);
  Result.Fill(FillValue);
end;

class function TFloat64sHelper.Create(const Items: array of Float64): TFloat64s;
begin
  System.SetLength(Result, System.Length(Items));
  if Result.Length > 0 then
    System.Move(Items[0], Result[0],Result.Length * SizeOf(Float64));
end;

class function TFloat64sHelper.Create(const s: string; Sep: Char; out Fail, Empty: NInt): TFloat64s;
begin
  Result.Assign(s, Sep, Fail, Empty);
end;

class function TFloat64sHelper.Create(const s: string; out Fail, Empty: NInt): TFloat64s;
begin
  Result.Assign(s, Fail, Empty);
end;

class function TFloat64sHelper.Create(const Strings: TStringArray; out Fail, Empty: NInt): TFloat64s;
begin
  Result.Assign(Strings, Fail, Empty);
end;

class function TFloat64sHelper.Empty: TFloat64s;
begin
  Result := nil;
end;


function TFloat64sHelper.GetLength: NInt;
begin
  Result := System.Length(Self);
end;

function TFloat64sHelper.IsEmpty: Boolean;
begin
  Result := TNInts(Self) = nil;
end;

function TFloat64sHelper.NotEmpty: Boolean;
begin
  Result := TNInts(Self) <> nil;
end;

function TFloat64sHelper.Equals(const Items: array of Float64): Boolean;
begin
  Result := (Length = System.Length(Items)) and
            (IsEmpty or CompareMem(@Self[0], @(Items[0]), Length * SizeOf(Float64)));
end;

function TFloat64sHelper.IndexOf(const Value: Float64; fromIndex: NInt): NInt;
begin
  if fromIndex < 0 then fromIndex := 0;
  for var i := fromIndex to Length - 1 do
    if Self[i] = Value then Exit(i);
  Result := -1;
end;

function TFloat64sHelper.LastIndexOf(const Value: Float64; fromIndex: NInt): NInt;
begin
  if fromIndex >= Length then fromIndex := Length - 1;
  for var i := fromIndex downto 0 do
    if Self[i] = Value then Exit(i);
  Result := -1;
end;

function TFloat64sHelper.LastIndexOf(const Value: Float64): NInt;
begin
  Result := LastIndexOf(Value, Length - 1);
end;

function TFloat64sHelper.Includes(const Value: Float64): Boolean;
begin
  Result := IndexOf(Value, 0) >= 0;
end;

function TFloat64sHelper.CountOf(n: Float64): NInt;
begin
  Result := 0;
  for var i := 0 to Length - 1 do
    if Self[i] = n then inc(Result);
end;

function TFloat64sHelper.ToString: string;
begin
  Result := ToString(FormatSettings.ListSeparator, 0, Length);
end;

function TFloat64sHelper.ToString(const Dividend: string): string;
begin
  Result := ToString(Dividend, 0, Length);
end;

function TFloat64sHelper.ToString(const Dividend: string; Index, Len: NInt):String;
begin
  if (Index < 0) then Exception.RaiseIndexError(Index);
  ez.ToSmaller(Len, Length - Index);
  if Len <= 0 then Exit('');

  var sb := TStringBuilder.Create(Len * (4 + System.Length(Dividend)));
  try
    sb.Append(Self[Index]);
    for var i := Index + 1 to Index + Len - 1 do
      sb.Append(Dividend).Append(Self[i]);
    Result := sb.ToString;
  finally
    sb.Free;
  end;
end;


procedure TFloat64sHelper.Clear;
begin
  Self := nil;
end;

procedure TFloat64sHelper.SetLength(Size: NInt);
begin
  System.SetLength(Self, Size);
end;

procedure TFloat64sHelper.SetLength(Size: NInt; const ValueForNewItems: Float64);
begin
  var OldSize := Length;
  SetLength(Size);
  if Size > OldSize then FillFloat(Self[OldSize], Size - OldSize, ValueForNewItems);
end;

procedure TFloat64sHelper.EnsureLength(Size: NInt);
begin
  if Length < Size then SetLength(Size);
end;

procedure TFloat64sHelper.Assign(const Items: array of Float64);
begin
  SetLength(System.Length(Items));
  if Length > 0 then
    System.Move(Items[0], Self[0], Length * SizeOf(Float64));
end;

procedure TFloat64sHelper.Assign(const Items: TFloat64s);
begin
  Self := System.Copy(Items);
end;

procedure TFloat64sHelper.Assign(const s: string; Sep: Char; out Fail, Empty: NInt);
begin
  var ss := TStringArray.Create(s, Sep, False);
  Assign(ss, Fail, Empty);
end;

procedure TFloat64sHelper.Assign(const s: string; out Fail, Empty: NInt);
begin
  var ss :=  TStringArray.CreateFromLines(s, False);
  Assign(ss, Fail, Empty);
end;

procedure TFloat64sHelper.Assign(const Strings: TStringArray; out Fail, Empty: NInt);
begin
  Empty := 0;
  SetLength(Strings.Length);
  var l: NInt := 0;

  for var i := 0 to Length - 1 do
  begin
    var s := Strings[i].Trim;
    if s = '' then Inc(Empty)
    else if Float64.TryParse(s, Self[l]) then Inc(l);
  end;
  SetLength(l);
  Fail := Strings.Length - l - Empty;
end;

procedure TFloat64sHelper.CopyFrom(const Items: array of Float64; ToIndex: NInt = 0);
begin
  if (ToIndex < 0) or (ToIndex > Length) then Exception.RaiseIndexError(ToIndex);

  var l := System.Length(Items);
  if ToIndex + l > Length then
    SetLength(ToIndex + l);
  System.Move(Items[0], Self[ToIndex], l * SizeOf(Float64));
end;

procedure TFloat64sHelper.CopyFrom(const Items: array of Float64; Index, Len: NInt; ToIndex: NInt = 0);
begin
  if (ToIndex < 0) or (ToIndex > Length) then Exception.RaiseIndexError(ToIndex);
  if (Index < 0) then Exception.RaiseIndexError(ToIndex);
  Len.SetToSmaller(System.Length(Items) - Index);
  if Len <= 0 then Exit;

  if ToIndex + Len > Length then
    SetLength(ToIndex + Len);
  System.Move(Items[Index], Self[ToIndex], Len * SizeOf(Float64));
end;

function TFloat64sHelper.GetSortedCopy: TFloat64s;
var
  m, n, i, j, l: NInt;
  d: Float64;
begin
  if Self = nil then Exit(nil);
  Result.SetLength(Length);
  Result[0] := Self[0];
  l := 1;

  for j := 1 to Length - 1 do
  begin
    m := 0;
    n := l - 1;
    d := Self[j];
    while m <= n do
    begin
      i := (m + n) shr 1;
      if d > Result[i]
        then m := i + 1
      else if d < Result[i]
        then n := i - 1
      else begin
         m := i;
         break;
       end;
    end;
    if (m < l) and (Result[m] <= d) then inc(m);
    inc(l);
    for i := l - 1 downto m + 1 do
      Result[i] := Result[i - 1];
    Result[m] := d;
  end;
end;

function TFloat64sHelper.Filter(FilterFunc: TFilterFunc): TFloat64s;
var
  i, l: NInt;
begin
  if Self = nil then Exit(nil);
  Result.SetLength(Length);
  l := 0;
  for i := 0 to Length - 1 do
    if FilterFunc(Self[i]) then
    begin
      Result[l] := Self[i];
      inc(l);
    end;
  Result.SetLength(l);
end;

procedure TFloat64sHelper.Fill(const FillValue: Float64; Index: NInt);
begin
  Fill(FillValue, Index, Length);
end;

procedure TFloat64sHelper.Fill(const FillValue: Float64; Index, Len: NInt);
begin
  if (Index < 0) then Exception.RaiseIndexError(Index);
  if Index >= Length then exit;
  ez.ToSmaller(Len, Length - Index);
  if Len <= 0 then Exit;
  FillFloat(Self[Index], Len, FillValue);
end;

function TFloat64sHelper.Add(const Value: Float64): NInt;
begin
  Result := Length;
  SetLength(Result + 1);
  Self[Result] := Value;
end;

function TFloat64sHelper.Add(const Items: array of Float64): NInt;
begin
  Result := Length;
  SetLength(Result + System.Length(Items));
  CopyFrom(Items, Result);
end;

function TFloat64sHelper.AddUnique(const Value: Float64): NInt;
begin
  Result := IndexOf(Value);
  if Result < 0 then Result := Add(Value);
end;

function TFloat64sHelper.Prepend(const Value: Float64): NInt;
begin
  Result := Insert(0, Value);
end;

function TFloat64sHelper.Insert(Index: NInt; const Value: Float64): NInt;
begin
  if Index < 0
    then Result := 0
  else if Index > Length
    then Result := Length
    else Result := Index;
  System.Insert(Value, Self, Result);
end;

function TFloat64sHelper.Insert(Index: NInt; const Items: array of Float64): NInt;
begin
  if (Index < 0) or (Index > Length) then Exception.RaiseIndexError(Index);
  SetLength(Length + System.Length(Items));
  if Index < Length then
    System.Move(Self[Index], Self[Index + System.Length(Items)], (Length - Index) * SizeOf(Float64));
  CopyFrom(Items, Index);
  Result := Index;
end;

function TFloat64sHelper.Delete(Index: NInt; Len: NInt): NInt;
begin
  if (Index < 0) then Exception.RaiseIndexError(Index);
  Result := ez.Min(Len, Length - Index);
  if Result <= 0 then exit(0);
  System.Delete(Self, Index, Result);
end;

function TFloat64sHelper.Remove(const Value: Float64; fromIndex: NInt): Boolean;
begin
  var i := IndexOf(Value, fromIndex);
  Result := (i >= 0);
  if Result then Delete(i);
end;

function TFloat64sHelper.RemoveAll(const Value: Float64; fromIndex: NInt): NInt;
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

function TFloat64sHelper.Pop: Float64;
begin
  Result := Self[Length - 1];
  SetLength(Length - 1);
end;

function TFloat64sHelper.Dequeue: Float64;
begin
  Result := Self[0];
  Delete(0);
end;

procedure TFloat64sHelper.Move(FromIndex, ToIndex: NInt);
begin
  if (FromIndex < 0) or (FromIndex >= Length) then Exception.RaiseIndexError(FromIndex);
  if (ToIndex < 0)   or (ToIndex >= Length)   then Exception.RaiseIndexError(ToIndex);
  if FromIndex = ToIndex then exit;

  var t := Self[FromIndex];
  if FromIndex < ToIndex
    then System.Move(Self[FromIndex + 1], Self[FromIndex], (ToIndex - FromIndex - 1) * Sizeof(Float64))
    else System.Move(Self[ToIndex], Self[ToIndex + 1], (FromIndex - ToIndex - 1) * Sizeof(Float64));
  Self[ToIndex] := t;
end;

procedure TFloat64sHelper.Exchange(Index1, Index2: NInt);
begin
  if (Index1 < 0) or (Index1 >= Length) then Exception.RaiseIndexError(Index1);
  if (Index2 < 0) or (Index2 >= Length) then Exception.RaiseIndexError(Index2);
  if Index1 = Index2 then exit;

  ez.Swap(Self[Index1], Self[Index2]);
end;

procedure TFloat64sHelper.Reverse;
begin
  if Length < 2 then Exit;              // This is necessary, or it will break when Length = 0
  var l := Length - 1;
  for var i := 0 to (l - 1) shr 1 do
    ez.Swap(Self[i], Self[l - i]);
end;

procedure TFloat64sHelper.Sort(Ascending: Boolean);
  procedure QuickSortAsc(Start, Stop: NInt);
  var
    m, lo, hi: NInt;
  begin
    if Start = Stop then exit else
    if Start + 1 = Stop then
    begin
      if Self[Start] > Self[Stop] then ez.Swap(Self[Start], Self[Stop]);
      exit;
    end else
    if Start + 2 = Stop then
    begin
      if Self[Start]     > Self[Start + 1] then ez.Swap(Self[Start], Self[Start + 1]);
      if Self[Start]     > Self[Stop]      then ez.Swap(Self[Start], Self[Stop]);
      if Self[Start + 1] > Self[Stop]      then ez.Swap(Self[Start + 1], Self[Stop]);
      exit;
    end;
    lo := Start;
    hi := Stop;
    m  := (lo + hi) div 2;
    repeat
      while Self[m] > Self[lo] do inc(lo);
      while Self[m] < Self[hi] do dec(hi);
      if lo < hi then
      begin
        ez.Swap(Self[lo], Self[hi]);
        if lo = m then m := hi else if hi = m then m := lo;
        inc(lo);
        dec(hi);
      end;
    until lo >= hi;
    if hi > Start then QuickSortAsc(Start, hi);
    if lo < Stop  then QuickSortAsc(lo, Stop);
  end;

  procedure QuickSortDsc(Start, Stop: NInt);
  var
    m, lo, hi: NInt;
  begin
    if Start = Stop then exit else
    if Start + 1 = Stop then
    begin
      if Self[Start] < Self[Stop] then ez.Swap(Self[Start], Self[Stop]);
      exit;
    end else
    if Start + 2 = Stop then
    begin
      if Self[Start]     < Self[Start + 1] then ez.Swap(Self[Start], Self[Start + 1]);
      if Self[Start]     < Self[Stop]      then ez.Swap(Self[Start], Self[Stop]);
      if Self[Start + 1] < Self[Stop]      then ez.Swap(Self[Start + 1], Self[Stop]);
      exit;
    end;
    lo := Start;
    hi := Stop;
    m  := (lo + hi) div 2;
    repeat
      while Self[m] < Self[lo] do inc(lo);
      while Self[m] > Self[hi] do dec(hi);
      if lo < hi then
      begin
        ez.Swap(Self[lo], Self[hi]);
        if lo = m then m := hi else if hi = m then m := lo;
        inc(lo);
        dec(hi);
      end;
    until lo >= hi;
    if hi > Start then QuickSortDsc(Start, hi);
    if lo < Stop  then QuickSortDsc(lo, Stop);
  end;
begin
  if Length > 1 then
  if Ascending
    then QuickSortAsc(0, Length - 1)
    else QuickSortDsc(0, Length - 1);
end;

function TFloat64sHelper.Mean: Float64;
begin
  Result := System.Math.Mean(Self);
end;

function TFloat64sHelper.Sum: Float64;
begin
  Result := System.Math.Sum(Self);
end;

function TFloat64sHelper.SumOfSquares: Float64;
begin
  Result := System.Math.SumOfSquares(Self);
end;

function TFloat64sHelper.MinValue: Float64;
begin
  Result := System.Math.MinValue(Self);
end;

function TFloat64sHelper.MaxValue: Float64;
begin
  Result := System.Math.MaxValue(Self);
end;

function TFloat64sHelper.StdDev: Float64;
begin
  Result := System.Math.StdDev(Self);
end;

function TFloat64sHelper.PopnStdDev: Float64;
begin
  Result := System.Math.PopnStdDev(Self);
end;

function TFloat64sHelper.Variance: Float64;
begin
  Result := System.Math.Variance(Self);
end;

function TFloat64sHelper.PopnVariance: Float64;
begin
  Result := System.Math.PopnVariance(Self);
end;

function TFloat64sHelper.TotalVariance: Float64;
begin
  Result := System.Math.TotalVariance(Self);
end;

function TFloat64sHelper.Norm: Float64;
begin
  Result := System.Math.Norm(Self);
end;

procedure TFloat64sHelper.SumsAndSquares(var Sum, SumOfSquares: FloatEx);
begin
  System.Math.SumsAndSquares(Self, Sum, SumOfSquares);
end;

procedure TFloat64sHelper.SumsAndSquares(var Sum, SumOfSquares: Float64);
begin
  var S, SS: FloatEx;
  System.Math.SumsAndSquares(Self, S, SS);
  Sum := S;
  SumOfSquares := SS;
end;

procedure TFloat64sHelper.MinAndMax(var MinValue, MaxValue: Float64);
begin
  if Self.IsEmpty then Exit;
  MinValue := Self[0];
  MaxValue := Self[0];
  for var i := 1 to Length - 1 do
    if Self[i] > MaxValue
      then MaxValue := Self[i]
    else if Self[i] < MinValue
      then MinValue := Self[i];
end;

procedure TFloat64sHelper.MeanAndStdDev(var Mean, StdDev: Float64);
begin
  System.Math.MeanAndStdDev(Self, Mean, StdDev);
end;

function TFloat64sHelper.Percentile(IsSorted: Boolean; const Percent: Float64): Float64;
var
  n: NInt;
  d: Float64;
  Floats: TFloat64s;
begin
  if Length = 0 then Exception.RaiseEmptyArrayError;
  if (Percent < 0) and (Percent > 1) then Exception.RaisePercentRangeError(Percent);
  if Length = 1 then Exit(Self[0]);
  d := (Length - 1) * Percent;
  n := Trunc(d);

  if IsSorted
    then Floats := Self
    else Floats := Self.GetSortedCopy;
  Result := Floats[n] + (Floats[n + 1] - Floats[n]) * (d - n);
end;

function TFloat64sHelper.PercentileExclusive(IsSorted: Boolean; const Percent: Float64): Float64;
var
  n: NInt;
  d: Float64;
  Floats: TFloat64s;
begin
  if Length = 0 then Exception.RaiseEmptyArrayError;
  d := Length * Percent - 1;
  n := Floor(d);
  if (n < 0) or (n >= Length - 1) then Exception.RaisePercentRangeError(Percent);

  if IsSorted
    then Floats := Self
    else Floats := Self.GetSortedCopy;
  Result := Floats[n] + (Floats[n + 1] - Floats[n]) * (d - n);
end;
{$ENDREGION}

{$REGION 'TArcDegree'}
{ TArcDegree }

class operator TArcDegree.Implicit(const Degree: Float32): TArcDegree;
begin
  Result.Radian := Degree * Constant32.RadianPerDegree;
end;

class operator TArcDegree.Implicit(const a: TArcDegree): Float32;
begin
  Result := a.Radian * Constant32.DegreePerRadian;
end;

class function TArcDegree.DegreeToRadian(const n: FloatEx): FloatEx;
begin
  Result := n * Constant32.RadianPerDegree;
end;

class function TArcDegree.RadianToDegree(const n: FloatEx): FloatEx;
begin
  Result := n * Constant32.DegreePerRadian;
end;

class function TArcDegree.RadianBetweenTwo(const Radian1, Radian2: FloatEx): FloatEx;
begin
  Result := NormalizePi(Radian1 - Radian2);
end;

class function TArcDegree.RadianOfLine(const x0, y0, x, y: FloatEx): FloatEx;
begin
  Result := RadianOfLine(x0 - x, y0 - y);
end;

class function TArcDegree.RadianOfLine(const dx, dy: FloatEx): FloatEx;
begin
  if dx = 0
    then if dy >= 0
      then Result := ConstantEx.Half_Pi
      else Result := ConstantEx.Three_Half_Pi
    else if dx < 0
      then Result := ConstantEx.Pi + ArcTan(dy / dx)
      else if dy < 0
        then Result := ConstantEx.Two_Pi + ArcTan(dy / dx)
        else Result := ArcTan(dy / dx);
end;

class function TArcDegree.DegreeOfLine(const dx, dy: FloatEx): FloatEx;
begin
  Result := RadianOfLine(dx, dy) * ConstantEx.DegreePerRadian;
end;

class function TArcDegree.DegreeOfLine(const x0, y0, x, y: FloatEx): FloatEx;
begin
  Result := RadianOfLine(x0, y0, x, y) * ConstantEx.DegreePerRadian;
end;

class function TArcDegree.DegreeBetweenTwo(const Degree1, Degree2: FloatEx): FloatEx;
begin
  Result := Normalize360(Degree1 - Degree2);
end;

class function TArcDegree.Normalize2Pi(const Radian: FloatEx): FloatEx;
begin
  Result := Radian - Int(Radian * ConstantEx.Inv_2_Pi) * ConstantEx.Two_Pi;
  if Result < 0 then
    Result := Result + ConstantEx.Two_Pi;
end;

class function TArcDegree.NormalizePi(const Radian: FloatEx): FloatEx;
begin
  Result := Radian - Int(Radian * ConstantEx.Inv_Pi) * ConstantEx.Pi;
  if Result < 0 then
    Result := Result + ConstantEx.Pi;
end;

class function TArcDegree.NormalizeSignedPi(const Radian: FloatEx): FloatEx;
begin
  Result := Radian - Int(Radian * ConstantEx.Inv_2_Pi) * ConstantEx.Two_Pi;
  if Result <= -ConstantEx.Pi
    then Result := Result + ConstantEx.Two_Pi
    else if Result > ConstantEx.Pi
      then Result := Result - ConstantEx.Two_Pi;
end;

class function TArcDegree.NormalizeSignedHalfPi(const Radian: FloatEx): FloatEx;
begin
  Result := Radian - Int(Radian * ConstantEx.Inv_Pi) * ConstantEx.Pi;
  if Result <= - ConstantEx.Half_Pi
    then Result := Result + ConstantEx.Pi
    else if Result > ConstantEx.Half_Pi
      then Result := Result - ConstantEx.Pi;
end;

class function TArcDegree.Normalize360(const Degree: FloatEx): FloatEx;
begin
  Result := Degree - Int(Degree * ConstantEx.Inv_360) * ConstantEx.c_360;
  if Result < 0 then
    Result := Result + ConstantEx.c_360;
end;

class function TArcDegree.Normalize180(const Degree: FloatEx): FloatEx;
begin
  Result := Degree - Int(Degree * ConstantEx.Inv_180) * ConstantEx.c_180;
  if Result < 0 then
    Result := Result + ConstantEx.c_180;
end;

class function TArcDegree.NormalizeSigned180(const Degree: FloatEx): FloatEx;
begin
  Result := Degree - Int(Degree * ConstantEx.Inv_360) * ConstantEx.c_360;
  if Result <= -ConstantEx.Inv_180
    then Result := Result + ConstantEx.c_360
    else if Result > ConstantEx.c_180
      then Result := Result - ConstantEx.c_360;
end;

class function TArcDegree.NormalizeSigned90(const Degree: FloatEx): FloatEx;
begin
  Result := Degree - Int(Degree * ConstantEx.Inv_180) * ConstantEx.c_180;
  if Result <= -ConstantEx.c_90
    then Result := Result + ConstantEx.c_180
    else if Result > ConstantEx.c_90
      then Result := Result - ConstantEx.c_180;
end;

procedure TArcDegree.Normalize;
begin
  Radian := Radian - Int(Radian * Constant32.Two_Pi) * Constant32.Two_Pi;
  if Radian < 0 then
    Radian := Radian + Constant32.Two_Pi;
end;

procedure TArcDegree.NormalizeTo180;
begin
  Radian := Radian - Int(Radian * Constant32.Pi) * Constant32.Pi;
  if Radian < 0 then
    Radian := Radian + Constant32.Pi;
end;

procedure TArcDegree.NormalizeToPosNeg180;
begin
  Radian := Radian - Int(Radian * Constant32.Two_Pi) * Constant32.Two_Pi;
  if Radian <= -Constant32.Pi
    then Radian := Radian + Constant32.Two_Pi
    else if Radian > Constant32.Pi
      then Radian := Radian - Constant32.Two_Pi;

end;

procedure TArcDegree.NormalizeToPosNeg90;
begin
  Radian := Radian - Int(Radian * Constant32.Pi) * Constant32.Pi;
  if Radian <= -Constant32.Half_Pi
    then Radian := Radian + Constant32.Pi
    else if Radian > Constant32.Half_Pi
      then Radian := Radian - Constant32.Pi;

end;

function TArcDegree.Sin: Float32;
begin
  Result := System.Sin(Radian);
end;

function TArcDegree.Cos: Float32;
begin
  Result := System.Cos(Radian);
end;

function TArcDegree.Tan: Float32;
begin
  Result := System.math.Tan(Radian);
end;

function TArcDegree.Cot: Float32;
begin
  Result := System.math.Cotan(Radian);
end;

function TArcDegree.Sec: Float32;
begin
  Result := System.math.Secant(Radian);
end;

function TArcDegree.Csc: Float32;
begin
  Result := System.math.Cosecant(Radian);
end;

function TArcDegree.Cotan: Float32;
begin
  Result := System.math.Cotan(Radian);
end;

function TArcDegree.Secant: Float32;
begin
  Result := System.math.Secant(Radian);
end;

function TArcDegree.Cosecant: Float32;
begin
  Result := System.math.Cosecant(Radian);
end;

procedure TArcDegree.SinCos(var S, C: Float32);
begin
  System.Math.SinCos(Radian, S, C);
end;

procedure TArcDegree.SetToSin(const Value: Float32);
begin
  Radian := ArcSin(Value);
end;

procedure TArcDegree.SetToCos(const Value: Float32);
begin
  Radian := ArcCos(Value);
end;

procedure TArcDegree.SetToTan(const Value: Float32);
begin
  Radian := ArcTan(Value);
end;

procedure TArcDegree.SetToCot(const Value: Float32);
begin
  Radian := ArcCot(Value);
end;

procedure TArcDegree.SetToSec(const Value: Float32);
begin
  Radian := ArcSec(Value);
end;

procedure TArcDegree.SetToCsc(const Value: Float32);
begin
  Radian := ArcCsc(Value);
end;

procedure TArcDegree.SetToTan2(const X, Y: Float32);
begin
  Radian := ArcTan2(X, Y);
end;
{$ENDREGION}

{$REGION 'TPointFsHelper'}
{ TPointFsHelper }

function TPointFsHelper.Length: NInt;
begin
  Result := System.Length(Self);
end;

function TPointFsHelper.IsEmpty: Boolean;
begin
  Result := Self = nil;
end;

function TPointFsHelper.NotEmpty: Boolean;
begin
  Result := Self <> nil;
end;

procedure TPointFsHelper.SetLength(NewLength: NInt);
begin
  System.SetLength(Self, NewLength);
end;

function TPointFsHelper.Add(const p: TPointF): NInt;
begin
  Result := Length;
  SetLength(Result + 1);
  Self[Result] := p;
end;

function TPointFsHelper.Add(const x, y: Float32): NInt;
begin
  Result := Add(PointF(x, y));
end;

function TPointFsHelper.AddUnique(const p: TPointF): NInt;
begin
  Result := IndexOf(p);
  if Result < 0 then Result := Add(p);
end;

function TPointFsHelper.AddUnique(const x, y: Float32): NInt;
begin
  Result := AddUnique(PointF(x, y));
end;

function TPointFsHelper.Insert(Index: NInt; const p: TPointF): NInt;
begin
  if Index < 0
    then Result := 0
  else if Index > Length
    then Result := Length
    else Result := Index;
  System.Insert(p, Self, Result);
end;

function TPointFsHelper.Insert(Index: NInt; const x, y: Float32): NInt;
begin
  Result := Insert(Index, PointF(x, y));
end;

function TPointFsHelper.Delete(Index: NInt; Len: NInt = 1 ):  NInt;
begin
  if (Index < 0) then Exception.RaiseIndexError(Index);
  Result := ez.Min(Len, Length - Index);
  if Result <= 0 then exit(0);
  System.Delete(Self, Index, Result);
end;

function TPointFsHelper.Remove(const p: TPointF): Boolean;
begin
  var i := IndexOf(p);
  Result := i >= 0;
  if Result then Delete(i);
end;

function TPointFsHelper.Remove(const x, y: Float32): Boolean;
begin
  var i := IndexOf(x, y);
  Result := i >= 0;
  if Result then Delete(i);
end;

function TPointFsHelper.Pop: TPointF;
begin
  Result := Self[Length - 1];
  SetLength(Length - 1);
end;

function TPointFsHelper.Prepend(const Value: TPointF): NInt;
begin
  Result := Insert(0, Value);
end;

function TPointFsHelper.Dequeue: TPointF;
begin
  Result := Self[0];
  Delete(0);
end;

procedure TPointFsHelper.Assign(const Source: TPointFs);
begin
  SetLength(Source.Length);
  if Self <> nil then
    Move(Source[0], Self[0], Source.Length * SizeOf(TPointF));
end;

procedure TPointFsHelper.OffsetBy(const dx, dy: Float32);
var
  i: NInt;
begin
  if SameValue(dx, 0) and SameValue(dy, 0) then Exit;
  for i := 0 to Length - 1 do
  begin
    Self[i].X := Self[i].X + dx;
    Self[i].Y := Self[i].Y + dy;
  end;
end;

procedure TPointFsHelper.ScaleBy(const n: Float32);
var
  i: NInt;
begin
  if n = Float32(1.0) then Exit;
  for i := 0 to Length - 1 do
  begin
    Self[i].X := Self[i].X * n;
    Self[i].Y := Self[i].Y * n;
  end;
end;

procedure TPointFsHelper.ScaleBy(const nx, ny: Float32);
var
  i: NInt;
begin
  if (nx = Float32(1.0)) and (ny = Float32(1.0)) then Exit;
  for i := 0 to Length - 1 do
  begin
    Self[i].X := Self[i].X * nx;
    Self[i].Y := Self[i].Y * ny;
  end;
end;

procedure TPointFsHelper.ScaleAtBy(const x0, y0, nx, ny: Float32);
var
  i: NInt;
begin
  if (x0 = Float32(0)) and (y0 = Float32(0)) then
  begin
    ScaleBy(nx, ny);
    exit;
  end;
  for i := 0 to Length - 1 do
  begin
    Self[i].X := (Self[i].X - x0) * nx + x0;
    Self[i].Y := (Self[i].Y - y0) * ny + y0;
  end;
end;

procedure TPointFsHelper.ScaleOffsetBy(const n, dx, dy: Float32);
var
  i: NInt;
begin
  if n = Float32(1.0)
    then OffsetBy(dx, dy)
  else if (dx = Float32(1.0)) and (dy = Float32(1.0))
    then ScaleBy(n)
  else begin
    for i := 0 to Length - 1 do
    begin
      Self[i].X := Self[i].X * n + dx;
      Self[i].Y := Self[i].Y * n + dy;
    end;
  end;
end;

function FComparePointsByX(p: Pointer; m, n: NInt): NInt;
begin
  Result := ez.Sign(PPointFs(p)^[m].X - PPointFs(p)^[n].X);
  if Result = 0 then
    Result := ez.Sign(PPointFs(p)^[m].Y - PPointFs(p)^[n].Y);
end;

function FComparePointsByY(p: Pointer; m, n: NInt): NInt;
begin
  Result := ez.Sign(PPointFs(p)^[m].Y - PPointFs(p)^[n].Y);
  if Result = 0 then
    Result := ez.Sign(PPointFs(p)^[m].X - PPointFs(p)^[n].X);
end;

procedure FSwapPoints(p: Pointer; m, n: NInt);
begin
  ez.Swap(PPointFs(p)^[m].x, PPointFs(p)^[n].x);
  ez.Swap(PPointFs(p)^[m].y, PPointFs(p)^[n].y);
end;

procedure TPointFsHelper.SortByX;
begin
  QuickSort.Sort(@Self, 0, Length - 1, FComparePointsByX, FSwapPoints);
end;

procedure TPointFsHelper.SortByY;
begin
  QuickSort.Sort(@Self, 0, Length - 1, FComparePointsByY, FSwapPoints);
end;

function TPointFsHelper.RemoceDuplicatedNeighbors(Closed: Boolean): Boolean;
var
  i, j, Last: NInt;
begin
  Last := Length - 1;
  if Last = 0 then Exit(false);

  i := 1;
  while (i <= Last) and not Self[i].Equals(Self[i - 1])
    do inc(i);
  j := i;       // First one this is duplicated

  for i := j + 1 to Last do
    if not Self[i].Equals(Self[j - 1]) then
    begin
      Self[j] := Self[i];
      inc(j);
    end;
  if Closed and (j > 1) then
    if Self[0].Equals(Self[j - 1]) then dec(j);
  Result := j <> Last + 1;
  if Result then SetLength(j);
end;

function TPointFsHelper.Offset(const dx, dy: Float32): TPointFs;
var
  i: NInt;
begin
  Result.SetLength(Length);
  for i := 0 to Length - 1 do
  begin
    Result[i].X := Self[i].X + dx;
    Result[i].Y := Self[i].Y + dy;
  end;
end;

function TPointFsHelper.Scale(const n: Float32): TPointFs;
var
  i: NInt;
begin
  Result.SetLength(Length);
  for i := 0 to Length - 1 do
  begin
    Result[i].X := Self[i].X * n;
    Result[i].Y := Self[i].Y * n;
  end;
end;


function TPointFsHelper.Scale(const nx, ny: Float32): TPointFs;
var
  i: NInt;
begin
  Result.SetLength(Length);
  for i := 0 to Length - 1 do
  begin
    Result[i].X := Self[i].X * nx;
    Result[i].Y := Self[i].Y * ny;
  end;
end;

function TPointFsHelper.ScaleAt(const x0, y0, nx, ny: Float32): TPointFs;
var
  i: NInt;
begin
  if (x0 = Float32(0)) and (y0 = Float32(0)) then Exit(Scale(nx, ny));
  Result.SetLength(Length);
  for i := 0 to Length - 1 do
  begin
    Self[i].X := (Self[i].X - x0) * nx + x0;
    Self[i].Y := (Self[i].Y - y0) * ny + y0;
  end;
end;

function TPointFsHelper.ScaleOffset(const n, dx, dy: Float32): TPointFs;
var
  i: NInt;
begin
  if n = Float32(1.0)
    then Exit(Offset(dx, dy))
  else if (dx = Float32(1.0)) and (dy = Float32(1.0))
    then Exit(Scale(n));
  Result.SetLength(Length);
  for i := 0 to Length - 1 do
  begin
    Result[i].X := Self[i].X * n + dx;
    Result[i].Y := Self[i].Y * n + dy;
  end;
end;

function TPointFsHelper.Clone: TPointFs;
begin
  Result.Assign(Self);
end;

function TPointFsHelper.GetBounds: TRectF;
var
  i: NInt;
begin
  if Self = nil then
  begin
    Result.Left   := 0;
    Result.Top    := 0;
    Result.Right  := 0;
    Result.Bottom := 0;
    Exit;
  end;
  Result.TopLeft     := Self[0];
  Result.BottomRight := Self[0];
  for i := 0 to Length - 1 do
  begin
    if Self[i].X > Result.Right
      then Result.Right := Self[i].X
    else if Self[i].X < Result.Left
      then Result.Left := Self[i].X;
    if Self[i].Y > Result.Bottom
      then Result.Bottom := Self[i].Y
    else if Self[i].Y < Result.Top
      then Result.Top := Self[i].Y;
  end;
end;

function TPointFsHelper.GetCentroid: TPointF;
var
  sx, sy: FloatEx;
  i: NInt;
begin
  if Self = nil then Exit(TPointF.Zero);
  sx := 0;      sy := 0;
  for i := 0 to Length - 1 do
  begin
    sx := sx + Self[i].X;
    sy := sy + Self[i].Y;
  end;
  Result.X := sx / Length;
  Result.Y := sy / Length;
end;

function TPointFsHelper.GetCentroidF: TPointF;
begin
  Result := GetCentroid;
end;

function TPointFsHelper.MaxDistance(const p: TPointF): FloatEx;
begin
  Result := MaxDistance(p.X, p.Y);
end;

function TPointFsHelper.MaxDistance(const x, y: Float32): FloatEx;
var
  n: FloatEx;
  i: NInt;
begin
  if Self = nil then Exit(0);
  n := ez.DistanceSquare(x - Self[0].X, y - Self[0].Y);
  for i := 1 to Length - 1 do
    ez.ToLarger(n, ez.DistanceSquare(x - Self[i].X, y - Self[i].Y));
  Result := Sqrt(n);
end;

function TPointFsHelper.MinDistance(const p: TPointF): FloatEx;
begin
  Result := MinDistance(p.X, p.Y);
end;

function TPointFsHelper.MinDistance(const x, y: Float32): FloatEx;
var
  n: FloatEx;
  i: NInt;
begin
  if Self = nil then Exit(0);
  n := ez.DistanceSquare(x - Self[0].X, y - Self[0].Y);
  for i := 1 to Length - 1 do
    ez.ToSmaller(n, ez.DistanceSquare(x - Self[i].X, y - Self[i].Y));
  Result := Sqrt(n);
end;

function TPointFsHelper.IndexOf(const x, y: Float32): NInt;
begin
  for Result := 0 to Length - 1 do
    if (Self[Result].X = X) and (Self[Result].Y = Y) then
      Exit;
  Result := -1;
end;

function TPointFsHelper.IndexOf(const p: TPointF): NInt;
begin
  Result := IndexOf(P.X, P.Y);
end;

function TPointFsHelper.IndexOfNearest(const x, y: Float32): NInt;
var
  n, d: FloatEx;
  i: NInt;
begin
  if Self = nil then Exit(-1);
  Result := 0;
  n := ez.DistanceSquare(x - Self[0].X, y - Self[0].Y);
  for i := 1 to Length - 1 do
  begin
    d := ez.DistanceSquare(x - Self[i].X, y - Self[i].Y);
    if d < n then
    begin
      n := d;
      Result := i;
    end;
  end;
end;

function TPointFsHelper.IndexOfNearest(const p: TPointF): NInt;
begin
  Result := IndexOfNearest(P.X, P.Y);
end;

function TPointFsHelper.IndexOfFarest(const x, y: Float32): NInt;
var
  n, d: FloatEx;
  i: NInt;
begin
  if Self = nil then Exit(-1);
  Result := 0;
  n := ez.DistanceSquare(x - Self[0].X, y - Self[0].Y);
  for i := 1 to Length - 1 do
  begin
    d := ez.DistanceSquare(x - Self[i].X, y - Self[i].Y);
    if d > n then
    begin
      n := d;
      Result := i;
    end;
  end;
end;

function TPointFsHelper.IndexOfFarest(const p: TPointF): NInt;
begin
  Result := IndexOfFarest(P.X, P.Y);
end;

function TPointFsHelper.RotateAt(const x0, y0: Float32; const Radian: FloatEx): TPointFs;
var
  i: NInt;
  C, S: FloatEx;
begin
  // make l to be the length and a to be the angle of the line; the angle of the new line is a+b
  // x2 = l * cos (a+b) = l cos a cos b - l sin a sin b = x cos b - y sin b
  // y2 = l * sin (a+b) = l sin a cos b + l cos a sin b = y cos b + x sin b
  // y is flipped because of the flipped coordinations in delphi graphics
  C := Cos(Radian);
  S := Sin(Radian);
  Result.SetLength(Length);
  for i := 0 to Length - 1 do
  begin
    Result[i].X := x0 + ((Self[i].X - x0) * C - (Self[i].Y - y0) * S);
    Result[i].Y := y0 - ((Self[i].X - x0) * S - (Self[i].Y - y0) * C);
  end;
end;

function TPointFsHelper.RotateAtDeg(const x0, y0: Float32; const Degree: FloatEx): TPointFs;
begin
  Result := RotateAt(x0, y0, Degree * ConstantEx.RadianPerDegree);
end;

function TPointFsHelper.GetBoundsAfterRotation(const x0, y0: Float32; const Radian: FloatEx): TRectF;
begin
  if Self.IsEmpty then Exit(TRect.Empty);

  var s := Sin(Radian);              //
  var c := Cos(Radian);
  var MinX := x0 + (Self[0].X - x0) * C - (Self[0].Y - y0) * S;
  var MinY := y0 - (Self[0].X - x0) * S - (Self[0].Y - y0) * C;
  var MaxX := MinX;
  var MaxY := MinY;

  for var i := 1 to Length - 1 do
  begin
    var X := x0 + (Self[i].X - x0) * C - (Self[i].Y - y0) * S;
    var Y := y0 - (Self[i].X - x0) * S - (Self[i].Y - y0) * C;
    if X < MinX then MinX := X
    else if X > MaxX then MaxX := X;
    if Y < MinY then MinY := Y
    else if Y > MaxY then MaxY := Y;
  end;
  Result.Left   := MinX.Round;
  Result.Right  := MaxX.Round;
  Result.Top    := MinY.Round;
  Result.Bottom := MaxY.Round;
end;

function TPointFsHelper.GetSizeAfterRotation(const Radian: FloatEx): TSizeF;
begin
  Result := GetBoundsAfterRotation(0, 0, Radian).Size;
end;

function TPointFsHelper.YSortedIndexOf(const x, y: Float32): NInt;
var
  m, n: NInt;
begin
  m := 0;
  n := Length - 1;
  while m <= n do
  begin
    Result := (m + n) div 2;
    if (Y = Self[Result].Y) then
    begin
      if X = Self[Result].X then exit;
      if (X > Self[Result].X)
        then m := Result + 1
        else n := Result - 1;
    end else if (Y > Self[Result].Y)
      then m := Result + 1
      else n := Result - 1;
  end;
  Result := -1;
end;

function TPointFsHelper.YSortedIndexOf(const p: TPointF): NInt;
begin
  Result := YSortedIndexOf(p.X, p.Y);
end;

procedure TPointFsHelper.LinearRegression(var k, a, r: FloatEx);
var
  Sx, Sxx, Sy, Syy, Sxy: FloatEx;
  i, n: NInt;
begin
  n := Length;
  Sx := 0;  Sy := 0;  Sxx := 0;  Syy := 0;  Sxy := 0;
  for i := 0 to Length - 1 do
  begin
    Sx  := Sx  + Self[i].x;
    Sxx := Sxx + Self[i].x * Self[i].x;
    Sy  := Sy  + Self[i].y;
    Syy := Syy + Self[i].y * Self[i].y;
    Sxy := Sxy + Self[i].x * Self[i].y;
  end;

  if (n * Sxx - Sx * Sx) = 0
    then if Sy > 0
      then k := 1e300
      else k := -1e300
    else k := (n*Sxy - Sx*Sy) / (n*Sxx - Sx*Sx);
  a := (Sy - k*Sx) / n;
  r := (n*Sxy - Sx*Sy) / Sqrt((n*Sxx - Sx*Sx) * (n*Syy - Sy*Sy));
end;

class function TPointFsHelper.AddControlPointsToCurve(const Points: array of TPointF; Closed: boolean; const Tension: Single = 0.5): TPointFs;
// This is based on https://arxiv.org/pdf/2011.08232.pdf and
//   https://stackoverflow.com/questions/1257168/how-do-i-create-a-bezier-curve-to-represent-a-smoothed-polyline
//   https://www.ibiblio.org/e-notes/Splines/Cardinal.htm
// Tension factor have different definitions. Here I used the one used in GDI+, so the default is 0.5; Tension = 0 makes a straight line
// In 1st reference, the factor is 1/6t, Tension = 0.5 means t = 1
// In the 2nd & 3rd reference, the factor 1/3a, Tension = 0.5 means a = 2 and produce the Catmul-Rom spline.
var
  i, n: NativeInt;
  tf: Float32;
begin
  n := System.Length(Points);
  if n <= 1 then Exit(nil);
  if n = 2 then
  begin
    Result.SetLength(4);
    Result[0] := Points[0];
    Result[3] := Points[1];
    Result[1].X := (2 * Points[0].X + Points[1].X) / 3;                     // P1 := (2P0 + P3) / 3
    Result[1].Y := (2 * Points[0].Y + Points[1].Y) / 3;
    Result[2].X := 2 * Result[1].X - Points[0].X;                         // P2 := (P0 + 2P3) / 3 = 2P1 - P0
    Result[2].Y := 2 * Result[1].Y - Points[0].Y;
    Exit;
  end;

  tf := Tension / 3;
  if Closed then
  begin
    Result.SetLength(3 * n + 1);
    Result[3 * n - 1].X := Points[0].X - tf * (Points[1].X - Points[n-1].X);
    Result[3 * n - 1].Y := Points[0].Y - tf * (Points[1].Y - Points[n-1].Y);
    Result[3 * n]       := Points[0];
  end else Result.SetLength(3 * n - 2);
  Result[0]           := Points[0];
  Result[1].X         := Points[0].X + tf * (Points[1].X - Points[n-1].X);
  Result[1].Y         := Points[0].Y + tf * (Points[1].Y - Points[n-1].Y);
  for i := 1 to n - 2 do
  begin
    Result[3 * i - 1].X := Points[i].X - tf * (Points[i + 1].X - Points[i - 1].X);
    Result[3 * i - 1].Y := Points[i].Y - tf * (Points[i + 1].Y - Points[i - 1].Y);
    Result[3 * i]       := Points[i];
    Result[3 * i + 1].X := Points[i].X + tf * (Points[i + 1].X - Points[i - 1].X);
    Result[3 * i + 1].Y := Points[i].Y + tf * (Points[i + 1].Y - Points[i - 1].Y);
  end;
  Result[3 * n - 4].X := Points[n - 1].X - tf * (Points[0].X - Points[n - 2].X);
  Result[3 * n - 4].Y := Points[n - 1].Y - tf * (Points[0].Y - Points[n - 2].Y);
  Result[3 * n - 3]   := Points[n - 1];
  if Closed then
  begin
    Result[3 * n - 2].X := Points[n - 1].X + tf * (Points[0].X - Points[n - 2].X);
    Result[3 * n - 2].Y := Points[n - 1].Y + tf * (Points[0].Y - Points[n - 2].Y);
  end;
end;

function TPointFsHelper.AddControlPointsToCurve(Closed: boolean; const Tension: Single = 0.5): TPointFs;
begin
  Result := AddControlPointsToCurve(Self, Closed, Tension);
end;

procedure TPointFsHelper.ConvertFromCurveWithControlPoints(const Points: array of TPointF; Closed: boolean; const Tension: Single);
begin
  Self := AddControlPointsToCurve(Points, Closed, Tension);
end;

class function TPointFsHelper.AddControlPointsToCurve(const Points: array of TPointF; FromIndex: NInt = 1; ToIndex: NInt = -2; const Tension: Single = 0.5): TPointFs;
var
  First, Last, i: NInt;
  tf: Float32;
begin
  First := ez.Max(1, FromIndex);
  Last  := ez.Min(System.Length(Points) - 2, ez.IfThen<NInt>(ToIndex >= 0, ToIndex, System.Length(Points) + ToIndex));
  if Last - First <= 1 then Exit(nil);
  tf := Tension / 3;
  Result.SetLength(3 * (Last - First) + 1);

  Result[0] := Points[First];
  for i := First to Last - 1 do
  begin
    Result[3 * (i - First) + 1].X := Points[i].X   + tf * (Points[i + 1].X - Points[i - 1].X);
    Result[3 * (i - First) + 1].Y := Points[i].Y   + tf * (Points[i + 1].Y - Points[i - 1].Y);
    Result[3 * (i - First) + 2].X := Points[i+1].X - tf * (Points[i + 2].X - Points[i].X);
    Result[3 * (i - First) + 2].Y := Points[i+1].Y - tf * (Points[i + 2].Y - Points[i].Y);
    Result[3 * (i - First) + 3]   := Points[i+1];
  end;
end;

function TPointFsHelper.AddControlPointsToCurve(FromIndex: NInt = 1; ToIndex: NInt = -2; const Tension: Single = 0.5): TPointFs;
begin
  Result := AddControlPointsToCurve(Self, FromIndex, ToIndex, Tension);
end;

procedure TPointFsHelper.ConvertFromCurveWithControlPoints(const Points: array of TPointF; FromIndex, ToIndex: NInt; const Tension: Single);
begin
  Self := AddControlPointsToCurve(Points, FromIndex, ToIndex, Tension);
end;

function TPointFsHelper.IsOnPoint(const x, y: Float32; var Index: NInt; const Tolerance: Float32): Boolean;
var
  Min, d: FloatEx;
  i: NInt;
  Error: Int64;
begin
  if Self = nil then Exit(False);
  if Tolerance < 0
    then Error := 0
    else if Tolerance > Float32.MaxValue
      then Error := 1 shl 62
      else Error := Floor(Tolerance * Tolerance);

  Min := Error + 1;
  Result := False;
  for i := 0 to Length - 1 do
  begin
    d := ez.DistanceSquare(x - Self[i].X, y - Self[i].Y);
    if (d < Min) then
    begin
      Min := d;
      Index := i;
      Result := True;
    end;
  end;
end;

function TPointFsHelper.IsOnLine(const x, y: Float32; var Index: NInt; Closed: Boolean; const Tolerance: Float32): Boolean;
begin
  Result := HitTest(x, y, Index, Closed, Tolerance, Tolerance)
                 in [THitTestResult.OnPoint, THitTestResult.OnLine];
end;

function TPointFsHelper.HitTest(const x, y: Float32; var Index: NInt; Closed: Boolean; const PointErr, LineErr: Float32): THitTestResult;
var
  Inside: NInt;
  lError: Double;

  function Test(i, j: NInt): boolean;    // Test if (x,y) is on the line, and also if line (y=y) crosses the line)
  var                                    // Changes Index and Inside
    x1, x2, y1, y2: Float32;
    dx, dy: Float32;
    c: Double;
    CanBeInside: Boolean;
  begin
    x1 := Self[i].x;      y1 := Self[i].y;
    x2 := Self[j].x;      y2 := Self[j].y;
    Result := false;
    CanBeInside := (y > y1) = (y <= y2);

    if y1 = y2 then           // y1=y2
    begin
      if abs(y - y1) <= lError then Result := (x1 > x) <> (x2 > x);
    end else
    begin
      dx := x2 - x1;
      dy := y2 - y1;
      if Abs(dy) >= abs(dx) then
      begin
        c := dx / dy * (y-y1) + x1;
        if Abs(c - x) <= lError
          then Result := CanBeInside
          else if CanBeInside and (x > c)
            then inc(Inside);
      end else
      begin
        c := dy / dx * (x-x1) + y1;
        if (Abs(c - y) <= lError) and ((x1 > x) <> (x2 > x))    // (x1>x2) <> (y1>y2)  / line
          then Result:=true                // (x1>x2) == (y1>y2)  \ line
          else if CanBeInside and
                  ((y > c) <> ((x1 < x2) = (y1 < y2)))
             then Inc(Inside);
      end;
    end;

    if Result then Index := i;
  end;
var
  i: NInt;
begin
  if IsOnPoint(x, y, Index, PointErr) then Exit(THitTestResult.OnPoint);

  Inside := 0;
  if LineErr < 0
    then lError := 0
    else lError := LineErr;
  for i := 0 to Length - 1 do
    if Test(i, i + 1) then Exit(THitTestResult.OnLine);
  if Closed and (Length > 2) and Test(High(Self), Low(Self)) then
    Exit(THitTestResult.OnLine);

  Index  := Inside;
  if Closed and (Length >= 3) and (Inside mod 2 = 1)
    then result := THitTestResult.Inside
    else result := THitTestResult.Outside;
end;

function TPointFsHelper.IsOnPoint(const p: TPointF; var Index: NInt; const Tolerance: Float32): Boolean;
begin
  Result := IsOnPoint(p.X, p.Y, Index, Tolerance);
end;

function TPointFsHelper.IsOnLine(const p: TPointF; var Index: NInt; Closed: Boolean; const Tolerance: Float32): Boolean;
begin
  Result := IsOnLine(p.X, p.Y, Index, Closed, Tolerance);
end;

function TPointFsHelper.HitTest(const p: TPointF; var Index: NInt; Closed: Boolean; const PointErr, LineErr: Float32): THitTestResult;
begin
  Result := HitTest(P.X, p.Y, Index, Closed, PointErr, LineErr);
end;

procedure TPointFsHelper.SetTo(const Xs, Ys: TFloat32s);
begin
  if Xs.Length <> Ys.Length then Exception.RaiseDifferentArraySizes;
  Self.SetLength(Xs.Length);
  for var i := 0 to Length - 1 do
  begin
    Self[i].X := Xs[i];
    Self[i].Y := Ys[i];
  end;
end;

procedure TPointFsHelper.SetTo(const Xs, Ys: TFloat64s);
begin
  if Xs.Length <> Ys.Length then Exception.RaiseDifferentArraySizes;
  Self.SetLength(Xs.Length);
  for var i := 0 to Length - 1 do
  begin
    Self[i].X := Xs[i];
    Self[i].Y := Ys[i];
  end;
end;

procedure TPointFsHelper.SeparateXY(var Xs, Ys: TFloat32s);
begin
  Xs.SetLength(Length);
  Ys.SetLength(Length);
  for var i := 0 to Length - 1 do
  begin
    Xs[i] := Self[i].X;
    Ys[i] := Self[i].Y;
  end;
end;

procedure TPointFsHelper.SeparateXY(var Xs, Ys: TFloat64s);
begin
  Xs.SetLength(Length);
  Ys.SetLength(Length);
  for var i := 0 to Length - 1 do
  begin
    Xs[i] := Self[i].X;
    Ys[i] := Self[i].Y;
  end;
end;
{$ENDREGION}

{$REGION 'TPolygonHelper'}
class function TPolygonHelper.RegularPolygon(nSides: NInt; const CenterX, CenterY, W, H: Float32; const StartingRadian: FloatEx): TPolygon;
var
  i: NInt;
  Step: FloatEx;
begin
  SetLength(Result, nSides);
  Step := ConstantEx.Two_Pi / nSides;
  for i := 0 to nSides - 1 do
  begin
    Result[i].X := CenterX + W * Cos(StartingRadian + Step * i);
    Result[i].Y := CenterY + H * Sin(StartingRadian + Step * i);
  end;
end;

class function TPolygonHelper.RegularPolygon(nSides: NInt; const W, H: Float32; const StartingRadian: FloatEx): TPolygon;
begin
  Result := RegularPolygon(nSides, 0, 0, W, H, StartingRadian);
end;

class function TPolygonHelper.RegularPolygon(nSides: NInt; const CenterX, CenterY, Radius: Float32; const StartingRadian: FloatEx): TPolygon;
begin
  Result := RegularPolygon(nSides, CenterX, CenterX, Radius, Radius, StartingRadian);
end;

class function TPolygonHelper.RegularPolygon(nSides: NInt; const Radius: Float32; const StartingRadian: FloatEx): TPolygon;
begin
  Result := RegularPolygon(nSides, 0, 0, Radius, Radius, StartingRadian);
end;

class function TPolygonHelper.RegularPolygonDeg(nSides: NInt; const CenterX, CenterY, W, H: Float32; const StartingDeg: FloatEx): TPolygon;
begin
  Result := RegularPolygon(nSides, CenterX, CenterX, W, H, StartingDeg * ConstantEx.RadianPerDegree);
end;

class function TPolygonHelper.RegularPolygonDeg(nSides: NInt; const W, H: Float32; const StartingDeg: FloatEx): TPolygon;
begin
  Result := RegularPolygonDeg(nSides, 0, 0, W, H, StartingDeg);
end;

class function TPolygonHelper.RegularPolygonDeg(nSides: NInt; const CenterX, CenterY, Radius: Float32; const StartingDeg: FloatEx): TPolygon;
begin
  Result := RegularPolygonDeg(nSides, CenterX, CenterX, Radius, Radius, StartingDeg);
end;

class function TPolygonHelper.RegularPolygonDeg(nSides: NInt; const Radius: Float32; const StartingDeg: FloatEx): TPolygon;
begin
  Result := RegularPolygonDeg(nSides, 0, 0, Radius, Radius, StartingDeg);
end;

function AddArcClockwise(var pg: TPolygon; Count, i0: NInt; const x0, y0, Rx, Ry: Float32; const StartAngle, ArcAngle: FloatEx): NInt; // Returns number of points added
var
  i, l: NInt;
  Step: FloatEx;
begin
  Count := ez.Max(Count, Round(ez.Max(RX, RY) * 5));
  Step := ArcAngle / (Count - 1);
  l := i0;
  for i := 0 to Count - 1 do
  begin
    if l >= Length(pg) then
      SetLength(pg, l + Count - i);
    pg[l].X := x0 + Rx * Cos(StartAngle + Step * i);
    pg[l].Y := y0 + Ry * Sin(StartAngle + Step * i);
    inc(l);
  end;
  Result := l - i0;
end;

class function TPolygonHelper.Ellipse(const CenterX, CenterY, RadiusX, RadiusY: Float32): TPolygon;
var
  l: NInt;
begin
  l := AddArcClockwise(Result, 0, 30, CenterX, CenterY, RadiusX, RadiusX, 0, ConstantEx.Two_Pi);
  if (l > 3) and (Result[l-1].X = Result[0].X) and (Result[l-1].Y = Result[0].Y) then dec(l);
  SetLength(Result, l);
end;

class function TPolygonHelper.Ellipse(const RadiusX, RadiusY: Float32): TPolygon;
begin
  Result := Ellipse(0, 0, RadiusX, RadiusY);
end;

class function TPolygonHelper.Circle(const CenterX, CenterY, Radius: Float32): TPolygon;
begin
  Result := Ellipse(CenterX, CenterY, Radius, Radius);
end;

class function TPolygonHelper.Circle(const Radius: Float32): TPolygon;
begin
  Result := Ellipse(0, 0, Radius, Radius);
end;

class function TPolygonHelper.Square(const Width: Float32): TPolygon;
begin
  Result := Rectangle(0, 0, Width, Width);
end;

class function TPolygonHelper.Square(const CenterX, CenterY, Width: Float32): TPolygon;
begin
  Result := Rectangle(CenterX, CenterY, Width, Width);
end;

class function TPolygonHelper.Star(nSides: NInt; const CenterX, CenterY, Outer, Inner: Float32; const StartingRadian: FloatEx): TPolygon;
var
  i: NInt;
  Step: FloatEx;
  Raidan2: FloatEx;
begin
  SetLength(Result, nSides);
  Step := ConstantEx.Two_Pi / nSides;
  Raidan2 := StartingRadian + Step / 2;
  for i := 0 to nSides - 1 do
  begin
    Result[i].X := Round(CenterX + Outer * Cos(StartingRadian + Step * i));
    Result[i].Y := Round(CenterY + Outer * Sin(StartingRadian + Step * i));
    Result[i].X := Round(CenterX + Inner * Cos(Raidan2 + Step * i));
    Result[i].Y := Round(CenterY + Inner * Sin(Raidan2 + Step * i));
  end;
end;

class function TPolygonHelper.Star(nSides: NInt; const CenterX, CenterY, Outer: Float32; const StartingRadian: FloatEx): TPolygon;
begin
  if nSides > 4
    then Result := Star(nSides, CenterX, CenterY, Outer, Outer * Cos(ConstantEx.Two_Pi / nSides) / Cos(ConstantEx.Pi / nSides), StartingRadian)
  else if nSides = 4
    then Result := Star(nSides, CenterX, CenterY, Outer, Outer * 0.4, StartingRadian)
  else if nSides = 3
    then Result := Star(nSides, CenterX, CenterY, Outer, Outer * 0.3, StartingRadian)
    else Result := Star(nSides, CenterX, CenterY, Outer, Outer, StartingRadian);
end;

class function TPolygonHelper.StarDeg(nSides: NInt; const CenterX, CenterY, Outer, Inner: Float32; const StartingDeg: FloatEx): TPolygon;
begin
  Result := Star(nSides, CenterX, CenterY, Outer, Inner, StartingDeg * ConstantEx.RadianPerDegree);
end;

class function TPolygonHelper.StarDeg(nSides: NInt; const CenterX, CenterY, Outer: Float32; const StartingDeg: FloatEx): TPolygon;
begin
  Result := Star(nSides, CenterX, CenterY, Outer, StartingDeg * ConstantEx.RadianPerDegree);
end;

class function TPolygonHelper.Rectangle(const Width, Height: Float32): TPolygon;
begin
  Result := Rectangle(0, 0, Width, Height);
end;

class function TPolygonHelper.Rectangle(const CenterX, CenterY, Width, Height: Float32): TPolygon;
begin
  SetLength(Result, 4);
  Result[0].X := CenterX + Width / 2;
  Result[0].Y := CenterY - Height / 2;
  Result[1].X := CenterX + Width / 2;
  Result[1].Y := CenterY + Height / 2;
  Result[2].X := CenterX - Width / 2;
  Result[2].Y := CenterY + Height / 2;
  Result[3].X := CenterX - Width / 2;
  Result[3].Y := CenterY - Height / 2;
end;

class function TPolygonHelper.RoundSquare(const Width, Radius: Float32): TPolygon;
begin
  Result := RoundRectangle(0, 0, Width, Width, Radius, Radius);
end;

class function TPolygonHelper.RoundSquare(const CenterX, CenterY, Width, Radius: Float32): TPolygon;
begin
  Result := RoundRectangle(CenterX, CenterY, Width, Width, Radius, Radius);
end;

class function TPolygonHelper.RoundRectangle(const Width, Height, RadiusX, RadiusY: Float32): TPolygon;
begin
  Result := RoundRectangle(0, 0, Width, Height, RadiusX, RadiusY);
end;

class function TPolygonHelper.RoundRectangle(const CenterX, CenterY, Width, Height, RadiusX, RadiusY: Float32): TPolygon;
var
  l: NInt;
  rx, ry: FloatEx;

  procedure TryAdd(x, y: FloatEx);
  begin
    if (x <> Result[l - 1].X) or (y <> Result[l - 1].Y) then
    begin
      if l >= Length(Result) then
        SetLength(Result, l + 1);
      Result[l].X := x;
      Result[l].Y := y;
      inc(l);
    end;
  end;

begin
  rx := ez.Min(Width, RadiusX);
  ry := ez.Min(Height, RadiusY);

  l :=     AddArcClockwise(Result, 30, 0, CenterX + Width - rx, CenterY - Height + ry, rx, ry, 0, pi/2);
  TryAdd(CenterX + Width - rx, CenterY + Height);
  TryAdd(CenterX - Width + rx, CenterY + Height);

  l := l + AddArcClockwise(Result, 30, l, CenterX - Width + rx, CenterY - Height + ry, rx, ry, pi/2, pi/2);
  TryAdd(CenterX - Width, CenterY + Height - ry);
  TryAdd(CenterX - Width, CenterY - Height + ry);

  l := l + AddArcClockwise(Result, 30, l, CenterX - Width + rx, CenterY + Height - ry, rx, ry, pi, pi/2);
  TryAdd(CenterX - Width + rx, CenterY - Height);
  TryAdd(CenterX + Width - rx, CenterY - Height);

  l := l + AddArcClockwise(Result, 30, l, CenterX + Width - rx, CenterY + Height - ry, rx, ry, pi*3/2, pi/2);
  TryAdd(CenterX + Width, CenterY - Height + ry);
  TryAdd(CenterX + Width, CenterY + Height - ry);

  if (l > 3) and (Result[l-1].X = Result[0].X) and (Result[l-1].Y = Result[0].Y) then dec(l);
  SetLength(Result, l);
end;

class function TPolygonHelper.Diamond(const Width, Height: Float32): TPolygon;
begin
  Result := Diamond(0, 0, Width, Height);
end;

class function TPolygonHelper.Diamond(const CenterX, CenterY, Width, Height: Float32): TPolygon;
begin
  SetLength(Result, 4);
  Result[0].X := CenterX + Width / 2;
  Result[0].Y := CenterY;
  Result[1].X := CenterX;
  Result[1].Y := CenterY + Height / 2;
  Result[2].X := CenterX - Width / 2;
  Result[2].Y := Result[0].Y;
  Result[3].X := Result[1].X;
  Result[3].Y := CenterY - Height / 2;
end;

class function TPolygonHelper.Plus(const Width, Height, ThicknessX, ThicknessY: Float32): TPolygon;
begin
  Result := Plus(0, 0, Width, Height, ThicknessX, ThicknessY);
end;

class function TPolygonHelper.Plus(const CenterX, CenterY, Width, Height, ThicknessX, ThicknessY: Float32): TPolygon;
var
  dx, dy, w, h: FloatEx;
begin
  w := Width / 2;
  h := Height / 2;
  dx := ez.Min(ThicknessX / 2, w);
  dy := ez.Min(ThicknessY / 2, h);

  SetLength(Result, 12);
  Result[ 0].X := CenterX + w;     Result[ 0].Y := CenterY - dy;
  Result[ 1].X := CenterX + dx;    Result[ 1].Y := CenterY - dy;
  Result[ 2].X := CenterX + dx;    Result[ 2].Y := CenterY - h;
  Result[ 3].X := CenterX - dx;    Result[ 3].Y := CenterY - h;
  Result[ 4].X := CenterX - dx;    Result[ 4].Y := CenterY - dy;
  Result[ 5].X := CenterX - w;     Result[ 5].Y := CenterY - dy;
  Result[ 6].X := CenterX - w;     Result[ 6].Y := CenterY + dy;
  Result[ 7].X := CenterX - dx;    Result[ 7].Y := CenterY + dy;
  Result[ 8].X := CenterX - dx;    Result[ 8].Y := CenterY + h;
  Result[ 9].X := CenterX + dx;    Result[ 9].Y := CenterY + h;
  Result[10].X := CenterX + dx;    Result[10].Y := CenterY + dy;
  Result[11].X := CenterX + w;     Result[11].Y := CenterY + dy;
end;

class function TPolygonHelper.Cross(const Width, Height, Thickness: Float32): TPolygon;
begin
  Result := Cross(0, 0, Width, Height, Thickness);
end;

class function TPolygonHelper.Cross(const CenterX, CenterY, Width, Height, Thickness: Float32): TPolygon;
var
  dx, dy, w, h: FloatEx;
begin
  w := Width / 2;
  h := Height / 2;
  dx := Thickness / Sqrt(1 + h * h / (w * w));
  dy := Thickness / Sqrt(1 + w * w / (h * h));

  SetLength(Result, 12);
  Result[ 0].X := CenterX + dx;        Result[ 0].Y := CenterY;
  Result[ 1].X := CenterX + w;         Result[ 1].Y := CenterY - h + dy;
  Result[ 2].X := CenterX + w - dx;    Result[ 2].Y := CenterY - h;
  Result[ 3].X := CenterX;             Result[ 3].Y := CenterY - dy;
  Result[ 4].X := CenterX - w + dx;    Result[ 4].Y := CenterY - h;
  Result[ 5].X := CenterX - w;         Result[ 5].Y := CenterY - h + dy;
  Result[ 6].X := CenterX - dx;        Result[ 6].Y := CenterY;
  Result[ 7].X := CenterX - w;         Result[ 7].Y := CenterY + h - dy;
  Result[ 8].X := CenterX - dx;        Result[ 8].Y := CenterY + h;
  Result[ 9].X := CenterX - w + dx;    Result[ 9].Y := CenterY + dy;
  Result[10].X := CenterX;             Result[10].Y := CenterY + h;
  Result[11].X := CenterX + w - dx;    Result[11].Y := CenterY + h - dy;
end;

class function TPolygonHelper.Arrow(const x0, y0, x1, y1, wBody, wHead, lHead, lSunken: Float32): TPolygon;
var
  Angle: FloatEx;
  S, C, lSk: FloatEx;
begin
  SetLength(Result, 7);
  Angle  := TArcDegree.RadianOfLine(x0 - x1, y0 - y1);
  S := Sin(Angle);
  C := Cos(Angle);
  lSk := lHead - lSunken;

  Result[0].X := x1;                         Result[0].Y := y1;
  Result[1].X := x1 - lHead*C - wHead*S;     Result[1].Y := y1 - lHead*S + wHead*C;
  Result[6].X := x1 - lHead*C + wHead*S;     Result[6].Y := y1 - lHead*S - wHead*C;
  Result[2].X := x1 - lSk*C   - wBody*S;     Result[2].Y := y1 - lSk*S   + wBody*C;
  Result[5].X := x1 - lSk*C   + wBody*S;     Result[5].Y := y1 - lSk*S   - wBody*C;
  Result[3].X := x0           - wBody*S;     Result[3].Y := y0           + wBody*C;
  Result[4].X := x0           + wBody*S;     Result[4].Y := y0           - wBody*C;
end;

class function TPolygonHelper.PointInPolygon(const p: TPointF; const Polygon: TPolygon): Boolean;
begin
  Result := Polygon.IsInside(p.X, p.Y);
end;

function TPolygonHelper.Clone: TPolygon;
begin
  Result := Copy(Self);
end;

function TPolygonHelper.GetCentroidF: TPointF;
begin
  Result := GetCentroid;
end;

function TPolygonHelper.GetCentroid: TPointF;
var
  i, l: NInt;
  s, a_2, tx, ty: FloatEx;
begin
  if Length(Self) < 3 then Exit(TPointFs(Self).GetCentroidF);
  l := Length(Self) - 1;
  a_2 := Self[l].X * Self[0].Y - Self[l].Y * Self[0].X;
  tx  := a_2 * (Self[l].X + Self[0].X);
  ty  := a_2 * (Self[l].Y + Self[0].Y);
  for i := 1 to l do
  begin
    s   := Self[i-1].X * Self[i].Y - Self[i-1].Y * Self[i].X;
    a_2 := a_2 + s;
    tx  := tx + s * (Self[i-1].X + Self[i].X);
    ty  := ty + s * (Self[i-1].Y + Self[i].Y);
  end;
  if a_2 = 0 then Exit(TPointFs(Self).GetCentroidF);
  Result.X := tx / 3 / a_2;
  Result.Y := ty / 3 / a_2;
end;

function TPolygonHelper.GetArea: FloatEx;
var
  S: FloatEx;
  i, l: NInt;
begin
  if Length(Self) < 3 then Exit(0);
  l := Length(Self) - 1;
  S := Self[l].X * Self[0].Y - Self[l].Y * Self[0].X;
  for i := 1 to l do
    S := S + Self[i-1].X * Self[i].Y - Self[i-1].Y * Self[i].X;
  Result := Abs(S)/2;
end;

function TPolygonHelper.GetPerimeter: FloatEx;
var
  i: NInt;
begin
  if Length(Self) < 2 then Exit(0);
  Result := ez.Distance(Self[Length(Self) - 1], Self[0]);
  for i := 1 to Length(Self) - 1 do
    Result := Result + ez.Distance(Self[i-1], Self[i]);
end;

function TPolygonHelper.GetCircularity: FloatEx;
var
  p: FloatEx;
begin
  p := GetPerimeter;
  if p = 0
    then Result := 1
    else Result := 4 * pi * GetArea / (p * p);
end;


function TPolygonHelper.ReducePoints(MaxNumberOfPoint: NInt; MinErrorInArea: FloatEx): TPolygon;
var
  i, m, n, l, len: NInt;
  b: boolean;
  a: array of NInt;
  max, d, MaxDis2: FloatEx;

// totally maths
{  line y = ax+b has two points (x1, y1) (x2, y2); point(m, n) is anywhere;
   y = [(y1-y2)/(x1-x2)] * x - (x1y2-x2y1)/(x1-x2) = (dy/dx) * x - ds/dx
   here dx = x1-x2;  y = y1-y2;  ds = x1y2-x2y1
   a = dy/dx; b = -ds/dx
   d^2 = (am-n+b)^2/(a^2+1) = dx^2*(am-n+b)^2/dx^2*(a^2+1) = (dy*m-dx*n-ds)^2/(dy^2+dx^2)
}
  procedure FindMaxDistanceToLineSegmentInNew(u, v: NInt);   // Line segments of new polygon
  var
    dx, dy, ds, MaxS, ls: FloatEx;
    MaxI: NInt;

    procedure TestPointsInOldBetween(First, Last: NInt);
    var
      i: NInt;
      s: FloatEx;
    begin
      for i := First to Last do
      begin
        s := Abs(dy * Self[i].x - dx * Self[i].y - ds);
        if (s > MaxS) then
        begin
          MaxS := s;
          MaxI := i;
        end;
      end;
    end;
  begin
    dx := Self[a[v]].x - Self[a[u]].x;
    dy := Self[a[v]].y - Self[a[u]].y;
    ds := Self[a[u]].x * Self[a[v]].y - Self[a[v]].x * Self[a[u]].y;
    MaxS := 0;
    if a[u] < a[v] then TestPointsInOldBetween(a[u]+1, a[v]-1) else
    begin
      TestPointsInOldBetween(a[u]+1, len-1);
      TestPointsInOldBetween(0, a[v]-1);
    end;
    if MaxS > 0 then
    begin
      ls := 0.5 * MaxS;
      if ls > MaxDis2 then
      begin
        MaxDis2 := ls;
        m := MaxI;
        n := u;
      end;
    end;
  end;

begin
  if Length(Self) <= MaxNumberOfPoint then Exit(Clone);
  Len:=Length(Self);
  SetLength(A, MaxNumberOfPoint);
  if MinErrorInArea<1 then MinErrorInArea:=1;

  // Find Points m & n with the max distance
  m := 0;  n := 0;  max := 0;  b := true;
  while b do
  begin
    b := false;
    for i := 0 to length(Self) - 1 do
      if (i <> m) and (i <> n) then
      begin
        d := ez.DistanceSquare(Self[i], Self[m]);
        if d > max then
        begin
          b := true;
          max := d;
          n := i;
        end;
      end;
    if b then ez.Swap(m, n);
  end;
  if m > n then ez.Swap(m, n);

  l := 2;
  a[0] := m;  a[1] := n;
  // Add Point that's the farest from current points
  while l < MaxNumberOfPoint do
  begin
    MaxDis2 := 0;               // Max ; set by Test
    m := 0;                     // index in Self; set by Test
    n := 0;                     // index in A; set by Test
    for i := 0 to l - 2 do
      FindMaxDistanceToLineSegmentInNew(i, i + 1);
    FindMaxDistanceToLineSegmentInNew(l - 1, 0);
    if MaxDis2 < MinErrorInArea
      then break;

    for i := l - 1 downto n+1 do
      a[i+1] := a[i];
    a[n+1] := m;
    inc(l);
  end;

  SetLength(Result, l);
  for i := 0 to l - 1 do
    Result[i] := Self[a[i]];
end;

function TPolygonHelper.IsOnPoint(const x, y: Float32; var Index: NInt; const Tolerance: Float32): Boolean;
begin
  Result := TPointFs(Self).IsOnPoint(x, y, Index, Tolerance);
end;

function TPolygonHelper.IsOnLine(const x, y: Float32; var Index: NInt; const Tolerance: Float32): Boolean;
begin
  Result := TPointFs(Self).HitTest(x, y, Index, True, Tolerance, Tolerance)
                in [THitTestResult.OnPoint, THitTestResult.OnLine];
end;

function TPolygonHelper.IsInside(const x, y: Float32): Boolean;
var
  Index: NInt;
begin
  Result := TPointFs(Self).HitTest(x, y, Index, True, 0, 0) <> THitTestResult.Outside;
end;

function TPolygonHelper.HitTest(const x, y: Float32; var Index: NInt; const PointErr, LineErr: Float32): THitTestResult;
begin
  Result := TPointFs(Self).HitTest(x, y, Index, True, PointErr, LineErr);
end;

function TPolygonHelper.IsOnPoint(const p: TPointF; var Index: NInt; const Tolerance: Float32): Boolean;
begin
  Result := IsOnPoint(p.X, p.Y, Index, Tolerance);
end;

function TPolygonHelper.IsOnLine(const p: TPointF; var Index: NInt; const Tolerance: Float32): Boolean;
begin
  Result := IsOnLine(p.X, p.Y, Index, Tolerance);
end;

function TPolygonHelper.IsInside(const p: TPointF): Boolean;
begin
  Result := IsInside(p.X, p.Y);
end;

function TPolygonHelper.HitTest(const p: TPointF; var Index: NInt; const PointErr, LineErr: Float32): THitTestResult;
begin
  Result := HitTest(P.X, p.Y, Index, PointErr, LineErr);
end;
{$ENDREGION}

end.
