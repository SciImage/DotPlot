unit wc.Colors;

// For Delphi 12 and above, since then NativeInt is a weak alias of Integer/Int64, avoiding some mess

{$I wc.Base.inc}

interface

uses
  System.UITypes, System.SysUtils,
  wc.Types, wc.Base;

type
{$REGION 'Types'}
  TAlphaColors = TArray<TAlphaColor>;                   // in System.UITypes: TAlphaColors = TAlphaColorRec;
  TAlphaColorTable  = array [Byte] of TAlphaColor;
  PAlphaColorArray  = ^TAlphaColorArray;
  TAlphaColorArray  = array[0..$7fffffff div sizeof(TAlphaColor) - 1] of TAlphaColor;
{$ENDREGION}

{$REGION 'TAlphaColorHelper'}
// ============================ Color ============================
{
  The ways colors are stored in memory is quite messy,
    especailly when GPI+ is taken into acount

    GDI:        TColor:    $00BBGGRR
                ScanLine:  BB GG RR; BB GG RR; .....
    GDI+:       TGpColor:  $AARRGGBB
                ScanLine:  BB GG RR AA; BB GG RR AA; ...... ??
    FireMonkey: TColor: $FFBBGGRR
}
  TAlphaColorHelper = record helper for TAlphaColor
    class function RGBA(R, G, B, A: Byte):TAlphaColor;                          static;
    class function RGB(R, G, B: Byte):TAlphaColor;                              static;
    class function GrayScale(R, G, B: Byte): Byte;                              overload; static;       // Y = 0.299 R + 0.587 G + 0.114 B
    class function GrayScaleF(R, G, B: Byte): Float32;                          overload; static;
    class function GrayScale(Color: TAlphaColor): Byte;                         overload; static; inline;
    class function GrayScaleF(Color: TAlphaColor): Float32;                     overload; static; inline;
    class function Luminance(R, G, B: Byte): Byte;                              overload; static;       // Y = 0.2126 R + 0.7152 G + 0.0722 B
    class function LuminanceF(R, G, B: Byte): Float32;                          overload; static;
    class function Luminance(Color: TAlphaColor): Byte;                         overload; static; inline;
    class function LuminanceF(Color: TAlphaColor): Float32;                     overload; static; inline;
    class function Mix(C1, C2: TAlphaColor): TAlphaColor;                       overload; static;
    class function Mix(C1, C2: TAlphaColor; const W1: Float32): TAlphaColor;    overload; static;
    class function RandomColor(BackGround: TAlphaColor): TAlphaColor;           overload; static;
    class function RandomColor(BackGround, Old: TAlphaColor): TAlphaColor;      overload; static;       // Make sure the result is different enough from old and background
    class function ToTColor(const Color: TAlphaColor): TColor;                  overload; static; inline;       // Just remove Alpha
    class function FromTColor(const Color: TColor): TAlphaColor;                overload; static; inline;

    // Only these change self
    procedure SetTo(R, G, B, A: Byte);                                          overload; inline;
    procedure SetTo(R, G, B: Byte);                                             overload; inline;
    procedure SetTo(Color: TColor);                                             overload; inline;
    procedure SetAlpha(Alpha: Byte);                                            inline;
    procedure SetAlphaF(const Opacity: Float32);                                inline;
    procedure MakeSolid;                                                        inline;

    procedure ToRGBA(var R, G, B, A: Byte);
    procedure ToRGB(var R, G, B: Byte);

    function  IsSolid: Boolean;                                                 inline;
    function  IsTranslucent: Boolean;                                           inline;
    function  IsGray: Boolean;                                                  inline;
    function  Opacity: Float32;                                                 inline;
    function  RGBOnly: UInt32;                                                  inline; // Same as ToTColor
    function  ToTColor: TColor;                                                 overload; inline; // Same as RGBOnly
    function  ToSolid: TAlphaColor;                                             inline; // Alpha --> 255

    function  Negative: TAlphaColor;                                            inline; // Alpha is not changed; R/G/B is changed to 256-R/G/B
    function  Multiply(const n: Float32): TAlphaColor;                                  // Alpha is not changed; n is changed to 0 if n < 0
    function  MultiplyAlpha(const n: Float32): TAlphaColor;                     inline;
    function  Add(Color: TAlphaColor): TAlphaColor;
    function  Subtract(Color: TAlphaColor): TAlphaColor;
    function  MixWith(Color: TAlphaColor): TAlphaColor;                         overload; inline;
    function  MixWith(Color: TAlphaColor; WeightColor: Float32): TAlphaColor;   overload; inline;

    function  GrayScale: Byte;                                                  overload; inline;
    function  GrayScaleF: Float32;                                              overload; inline;
    function  Luminance: Byte;                                                  overload; inline;
    function  LuminanceF: Float32;                                              overload; inline;

    function  ToDelphiString: string;                                           // $XXXXXXXX
    function  ToHexString: string;                                              // #XXXXXX or #XXXXXXXX
    function  ToCssString: string;                                              // #XXXXXX or rgba(r, g, b, a)
    function  ToNoAlphaString: string;                                          // #XXXXXX
    function  ToOpacitySeparatedString(const Name: string): string;             // Name: #XXXXXX or Name: #XXXXXX; Opacity: 0.X
  end;
{$ENDREGION}

const
  NullColor      = TAlphaColorRec.Null;

implementation

uses
  System.Math;

{$REGION 'TAlphaColorHelper'}
{ TAlphaColorHelper }

{$REGION 'class functions'}
class function TAlphaColorHelper.RGB(R, G, B: Byte): TAlphaColor;
begin
  TAlphaColorRec(Result).R := R;
  TAlphaColorRec(Result).G := G;
  TAlphaColorRec(Result).B := B;
  TAlphaColorRec(Result).A := $FF;
end;

class function TAlphaColorHelper.RGBA(R, G, B, A: Byte): TAlphaColor;
begin
  TAlphaColorRec(Result).R := R;
  TAlphaColorRec(Result).G := G;
  TAlphaColorRec(Result).B := B;
  TAlphaColorRec(Result).A := A;
end;

class function TAlphaColorHelper.GrayScale(R, G, B: Byte): Byte;
begin
  Result := ((299 * UInt32(R) + 587 * UInt32(G) + 114 * UInt32(B)) + 500) div 1000;
end;

class function TAlphaColorHelper.GrayScaleF(R, G, B: Byte): Float32;
begin
  Result := 0.299 * R + 0.587 * G + 0.114 * B;
end;

class function TAlphaColorHelper.GrayScale(Color: TAlphaColor): Byte;
begin
  Result := GrayScale(TAlphaColorRec(Color).R, TAlphaColorRec(Color).G, TAlphaColorRec(Color).B);
end;

class function TAlphaColorHelper.GrayScaleF(Color: TAlphaColor): Float32;
begin
  Result := GrayScaleF(TAlphaColorRec(Color).R, TAlphaColorRec(Color).G, TAlphaColorRec(Color).B);
end;

class function TAlphaColorHelper.Luminance(R, G, B: Byte): Byte;
begin
  Result := (2126 * UInt32(R) + 7152 * UInt32(G) + 722 * UInt32(B) + 5000) div 10000;
end;

class function TAlphaColorHelper.LuminanceF(R, G, B: Byte): Float32;
begin
  Result := 0.2126 * R + 0.7152 * G + 0.722 * B;
end;

class function TAlphaColorHelper.Luminance(Color: TAlphaColor): Byte;
begin
  Result := Luminance(TAlphaColorRec(Color).R, TAlphaColorRec(Color).G, TAlphaColorRec(Color).B);
end;

class function TAlphaColorHelper.LuminanceF(Color: TAlphaColor): Float32;
begin
  Result := LuminanceF(TAlphaColorRec(Color).R, TAlphaColorRec(Color).G, TAlphaColorRec(Color).B);
end;

class function TAlphaColorHelper.Mix(C1, C2: TAlphaColor): TAlphaColor;
begin
  TAlphaColorRec(Result).R := (TAlphaColorRec(C1).R + TAlphaColorRec(C2).R) shr 1;
  TAlphaColorRec(Result).G := (TAlphaColorRec(C1).G + TAlphaColorRec(C2).G) shr 1;
  TAlphaColorRec(Result).B := (TAlphaColorRec(C1).B + TAlphaColorRec(C2).B) shr 1;
  TAlphaColorRec(Result).A := (TAlphaColorRec(C1).A + TAlphaColorRec(C2).A) shr 1;
end;

class function TAlphaColorHelper.Mix(C1, C2: TAlphaColor; const W1: Float32): TAlphaColor;
begin
  TAlphaColorRec(Result).R := ez.EnsureRange(Round(TAlphaColorRec(C1).R * W1 + TAlphaColorRec(C2).R * (1 - W1)), 0, 255);
  TAlphaColorRec(Result).G := ez.EnsureRange(Round(TAlphaColorRec(C1).G * W1 + TAlphaColorRec(C2).G * (1 - W1)), 0, 255);
  TAlphaColorRec(Result).B := ez.EnsureRange(Round(TAlphaColorRec(C1).B * W1 + TAlphaColorRec(C2).B * (1 - W1)), 0, 255);
  TAlphaColorRec(Result).A := ez.EnsureRange(Round(TAlphaColorRec(C1).A * W1 + TAlphaColorRec(C2).A * (1 - W1)), 0, 255);
end;

class function TAlphaColorHelper.RandomColor(BackGround: TAlphaColor): TAlphaColor;
begin
  var gg := GrayScaleF(BackGround);
  repeat
    Result := $FF_00_00_00 or UInt32(Random($1_00_00_00));
  until Abs(GrayScaleF(Result) - gg) > 100;
end;

class function TAlphaColorHelper.RandomColor(BackGround, Old: TAlphaColor): TAlphaColor;
begin
  var gg := GrayScaleF(BackGround);
  var og := GrayScaleF(Old);
  var ng: Float32;
  repeat
    Result := $FF_00_00_00 or UInt32(Random($1_00_00_00));
    ng := GrayScaleF(Result);
  until (Abs(gg - ng) > 90) and  (Abs(og - ng) > 20);
end;

class function TAlphaColorHelper.FromTColor(const Color: TColor): TAlphaColor;
begin
  {$IFDEF MSWINDOWS}
  if Color and $FF000000 = 0
    then Result := UInt32(Color) or $FF000000
    else Result := UInt32(System.UITypes.TColorRec.ColorToRGB(Color)) or $FF000000;
  {$ELSE}
  Result := UInt32(Color) or $FF000000;
  {$ENDIF}
end;

class function TAlphaColorHelper.ToTColor(const Color: TAlphaColor): TColor;
begin
  Result := Color and $FFFFFF;
end;
{$ENDREGION}

{$REGION 'Functions'}
procedure TAlphaColorHelper.SetTo(R, G, B: Byte);
begin
  TAlphaColorRec(Self).R := R;
  TAlphaColorRec(Self).G := G;
  TAlphaColorRec(Self).B := B;
  TAlphaColorRec(Self).A := $FF;
end;

procedure TAlphaColorHelper.SetTo(R, G, B, A: Byte);
begin
  TAlphaColorRec(Self).R := R;
  TAlphaColorRec(Self).G := G;
  TAlphaColorRec(Self).B := B;
  TAlphaColorRec(Self).A := A;
end;

procedure TAlphaColorHelper.SetTo(Color: TColor);
begin
  Self := FromTColor(Color);
end;

procedure TAlphaColorHelper.SetAlpha(Alpha: Byte);
begin
  TAlphaColorRec(Self).A := Alpha;
end;

procedure TAlphaColorHelper.SetAlphaF(const Opacity: Float32);
begin
  TAlphaColorRec(Self).A := ez.EnsureRange(Round(255 * Opacity), 0, 255);
end;

procedure TAlphaColorHelper.MakeSolid;
begin
  TAlphaColorRec(Self).A := $FF;
end;

procedure TAlphaColorHelper.ToRGB(var R, G, B: Byte);
begin
  R := TAlphaColorRec(Self).R;
  G := TAlphaColorRec(Self).G;
  B := TAlphaColorRec(Self).B;
end;

procedure TAlphaColorHelper.ToRGBA(var R, G, B, A: Byte);
begin
  R := TAlphaColorRec(Self).R;
  G := TAlphaColorRec(Self).G;
  B := TAlphaColorRec(Self).B;
  A := TAlphaColorRec(Self).A;
end;

function TAlphaColorHelper.IsSolid: Boolean;
begin
  Result := TAlphaColorRec(Self).A = $FF;
end;

function TAlphaColorHelper.IsTranslucent: Boolean;
begin
  Result := TAlphaColorRec(Self).A <> $FF;
end;

function TAlphaColorHelper.IsGray: Boolean;
begin
  Result := (TAlphaColorRec(Self).R = TAlphaColorRec(Self).G) and (TAlphaColorRec(Self).G = TAlphaColorRec(Self).B);
end;

function TAlphaColorHelper.Opacity: Float32;
begin
  Result := (TAlphaColorRec(Self).A / 255).RoundTo(-3);
end;

function TAlphaColorHelper.RGBOnly: UInt32;
begin
  Result := Self and $FF_FF_FF;
end;

function TAlphaColorHelper.ToTColor: TColor;
begin
  Result := Self and $FF_FF_FF;
end;

function TAlphaColorHelper.ToSolid: TAlphaColor;
begin
  Result := Self or $FF_00_00_00;
end;

function TAlphaColorHelper.Negative: TAlphaColor;
begin
  Result := (Self and $FF_00_00_00) or ($FF_FF_FF - (Self and $FF_FF_FF));
end;

function TAlphaColorHelper.Multiply(const n: Float32): TAlphaColor;
begin
  Result := Self;
  TAlphaColorRec(Result).R := ez.EnsureRange(Round(TAlphaColorRec(Self).R * n), 0, 255);
  TAlphaColorRec(Result).G := ez.EnsureRange(Round(TAlphaColorRec(Self).G * n), 0, 255);
  TAlphaColorRec(Result).B := ez.EnsureRange(Round(TAlphaColorRec(Self).B * n), 0, 255);
end;

function TAlphaColorHelper.MultiplyAlpha(const n: Float32): TAlphaColor;
begin
  Result := Self;
  TAlphaColorRec(Result).A := ez.EnsureRange(Round(TAlphaColorRec(Self).A * n), 0, 255);
end;

function TAlphaColorHelper.Add(Color: TAlphaColor): TAlphaColor;
begin
  TAlphaColorRec(Result).R := ez.Min(255, UInt32(TAlphaColorRec(Self).R) + TAlphaColorRec(Color).R);
  TAlphaColorRec(Result).G := ez.Min(255, UInt32(TAlphaColorRec(Self).G) + TAlphaColorRec(Color).G);
  TAlphaColorRec(Result).B := ez.Min(255, UInt32(TAlphaColorRec(Self).B) + TAlphaColorRec(Color).B);
  TAlphaColorRec(Result).A := ez.Max(TAlphaColorRec(Self).A, TAlphaColorRec(Color).A);
end;

function TAlphaColorHelper.Subtract(Color: TAlphaColor): TAlphaColor;
begin
  TAlphaColorRec(Result).R := ez.Max(0, Int32(TAlphaColorRec(Self).R) - TAlphaColorRec(Color).R);
  TAlphaColorRec(Result).G := ez.Max(0, Int32(TAlphaColorRec(Self).G) - TAlphaColorRec(Color).G);
  TAlphaColorRec(Result).B := ez.Max(0, Int32(TAlphaColorRec(Self).B) - TAlphaColorRec(Color).B);
  TAlphaColorRec(Result).A := ez.Min(TAlphaColorRec(Self).A, TAlphaColorRec(Color).A);
end;

function TAlphaColorHelper.MixWith(Color: TAlphaColor): TAlphaColor;
begin
  Result := Mix(Color, Self);
end;

function TAlphaColorHelper.MixWith(Color: TAlphaColor; WeightColor: Float32): TAlphaColor;
begin
  Result := Mix(Color, Self, WeightColor);
end;

function TAlphaColorHelper.GrayScale: Byte;
begin
  Result := TAlphaColor.GrayScale(Self);
end;

function TAlphaColorHelper.GrayScaleF: Float32;
begin
  Result := TAlphaColor.GrayScaleF(Self);
end;

function TAlphaColorHelper.Luminance: Byte;
begin
  Result := TAlphaColor.Luminance(Self);
end;

function TAlphaColorHelper.LuminanceF: Float32;
begin
  Result := TAlphaColor.LuminanceF(Self);
end;

function TAlphaColorHelper.ToDelphiString: string;
begin
  Result := '$' + IntToHex(Self, 8);
end;

function TAlphaColorHelper.ToHexString: string;
begin
  if TAlphaColorRec(Self).A = $FF
    then Result := '#' + IntToHex(Self and $FF_FF_FF, 6)
    else Result := '#' + IntToHex(Self, 8);
end;

function TAlphaColorHelper.ToNoAlphaString: string;
begin
  Result := '#' + IntToHex(Self and $FF_FF_FF, 6);
end;

function TAlphaColorHelper.ToOpacitySeparatedString(const Name: string): string;
begin
  if TAlphaColorRec(Self).A = $FF
    then Result := Format('%s: #%s;' , [Name, IntToHex(Self and $FF_FF_FF, 6)])
    else Result := Format('%s: #%s; Opacity: %g;' , [Name, IntToHex(Self and $FF_FF_FF, 6), Opacity]);
end;

function TAlphaColorHelper.ToCssString: string;
begin
  if TAlphaColorRec(Self).A = $FF
    then Result := '#' + IntToHex(Self and $FF_FF_FF, 6)
    else Result := Format('rgba(%d, %d, %d, %g)', [TAlphaColorRec(Self).R, TAlphaColorRec(Self).G,
                                                   TAlphaColorRec(Self).B, Opacity]);
end;
{$ENDREGION}
{$ENDREGION}

end.
