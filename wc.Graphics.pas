unit wc.Graphics;

// For Delphi 12 and above, since then NativeInt is a weak alias of Integer/Int64, avoiding some mess

{$I wc.Base.inc}
{$SCOPEDENUMS ON}

interface

uses
  System.UITypes,
  wc.Types;

type
  {$REGION 'TSimpleShape'}
  TSimpleShape = (
    // The second size paramter is the relatice inner hole size, 0: no inner hole; 1: same size as the outer
    Circle, Triangle, LeftTriangle, RightTriangle, DownTriangle, Square, Diamond,
    Pentagon, PentagonDown, Hexagon, HexagonH, Octagon, OctagonH,
    // The second size paramter: 0: circle; positive: horizontally compressed; negative: verizontally compressed;
    Ellipse, Rectangle, Diamond2,
    // The second size parameter is (the relative thickness - 0.2)
    X, Plus,
    // The second size parameter is (the relative radius of round cornors - 0.2)
    RoundSquare,
    // The second size parameter is relative offset of the concave; 0: prefect stars; -1: Ray lines; 1: 2x Polygon
    Star4, Star5, Star6, Star8,
    // The second size parameter is (the relative size of the the inner circle - 0.6)
    Sun);
  {$ENDREGION}

const
  TextOutMaxSize = 100000;      // For TextOut/TextExtent without a TRectF parameter
  HitTestCursor: array[tHitTestResult] of TCursor =
    ( crDefault,      crSizeAll,
      crHandpoint,    crSizeNWSE,     crSizeNESW,     crSizeNESW,     crSizeNWSE,
      crCross,        crSizeNS,       crSizeWE,       crSizeWE,       crSizeNS);

implementation

end.
