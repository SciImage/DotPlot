unit wc.Graphics.FMX;

// For Delphi 12 and above, since then NativeInt is a weak alias of Integer/Int64, avoiding some mess

{$I wc.Base.inc}

interface

{ This may also be true in Delphi 12, not tested
  In Delphi 11, Windows without GlobalUseGPUCanvas, drawing have at least two bugs:
      1) !!! When TBrush.Gradient.Style is TGradientStyle.Radial, the brush does not translate
         so a shape must have a TopLeft of (0,0) to be rendered correctly.
      2) The TopLeft, Padding properties of TTextLayout have no effect
    With GlobalUseGPUCanvas, there are more problems:
      1) Anti-aliasing don't always work, this can produce pixelated lines.
      2) !!! Stroke is always solid using Stroke.Color; It never use Gradient.Color
      3) !!! Text spacing can be different from drawing without GlobalUseGPUCanvas
  // On Mac, it behavirs like windows with GPU, but set GlobalUseGPUCanvas to true may cause the app to fail at launch
      1) !!! Stroke is always solid using Stroke.Color; It never use Gradient.Color
      2) Padding of TextLayout is ignored
      3) !!! Filling is inclusive, not alternative
  // Should use Skia4Delphi on Mac
  // Other general bugs:
  // Changing Fill/Stroke.Color sometime changes Gradient.Color, sometimes doesn't
}

uses
  System.Types, System.UITypes, System.SysUtils, System.Classes, System.Math.Vectors,
  FMX.Types, FMX.Graphics, FMX.TextLayout, FMX.Surfaces,
  wc.Types, wc.Graphics;

type
  {$REGION 'TPathDataHelper'}
  TPathDataHelper = class helper for TPathData
    procedure MoveTo(const X, Y: Single);                                                       overload; inline;
    procedure MoveToRel(const X, Y: Single);                                                    overload; inline;
    procedure LineTo(const X, Y: Single);                                                       overload; inline;
    procedure LineToRel(const X, Y: Single);                                                    overload; inline;

    procedure AddLine(const P1, P2: TPointF);                                                   overload; inline;
    procedure AddLine(const X1, Y1, X2, Y2: Single);                                            overload; inline;
    procedure AddBezier(const P1, P2, P3, P4: TPointF);                                         overload; inline;
    procedure AddBezier(const X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single);                          overload; inline;

    procedure AddLines(const Points: array of TPointF);
    procedure AddPolygon(const Points: array of TPointF);
    procedure AddBeziers(const Points: array of TPointF);

    procedure AddRectangle(const P1, P2: TPointF);                                              overload; inline;
    procedure AddRectangle(const X1, Y1, X2, Y2: Single);                                       overload; inline;
    procedure AddRectangleSize(const Left, Top, Width, Height: Single);                         overload; inline;
    procedure AddEllipse(const P1, P2: TPointF);                                                overload; inline;
    procedure AddEllipse(const X1, Y1, X2, Y2: Single);                                         overload; inline;
    procedure AddEllipseSize(const Left, Top, Width, Height: Single);                           overload; inline;
    procedure AddEllipseRad(const X0, Y0, RX, RY: Single);                                      overload; inline;
    procedure AddEllipseRad(const CT: TPointF; const RX, RY: Single);                           overload; inline;
    procedure AddCircle(const X0, Y0, R: Single);                                               overload; inline;
    procedure AddCircle(const CT: TPointF; const R: Single);                                    overload; inline;
    procedure AddRoundRectangle(const RT: TRectF; const RX, RY: Single);                        overload; inline;
    procedure AddRoundRectangle(const P1, P2: TPointF; const RX, RY: Single);                   overload; inline;
    procedure AddRoundRectangle(const X1, Y1, X2, Y2, RX, RY: Single);                          overload; inline;
    procedure AddRoundRectangleSize(const Left, Top, Width, Height, RX, RY: Single);            overload; inline;

    procedure AddArc(const RT: TRectF; const StartAngle, SweepAngle: Single);                   overload; inline;
    procedure AddArc(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single);          overload; inline;
    procedure AddArc(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single);                     overload; inline;
    procedure AddPie(const RT: TRectF; const StartAngle, SweepAngle: Single);                   overload; inline;
    procedure AddPie(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single);          overload; inline;
    procedure AddPie(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single);                     overload; inline;

    procedure AddText(Canvas: TCanvas; Font: TFont; const RT: TRectF;
                      const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                      VAlign: TTextAlign = TTextAlign.Center; Flags: TFillTextFlags = []);      overload;
    procedure AddText(Canvas: TCanvas; const RT: TRectF; const Text: string; WordWrap: Boolean;
                      HAlign: TTextAlign; VAlign: TTextAlign = TTextAlign.Center;
                      Flags: TFillTextFlags = []);                                              overload; inline;
    procedure AddText(Font: TFont; const RT: TRectF; const Text: string;
                      WordWrap: Boolean; HAlign: TTextAlign;
                      VAlign: TTextAlign = TTextAlign.Center; Flags: TFillTextFlags = []);      overload; inline;
    procedure AddText(Canvas: TCanvas; Font: TFont; const X, Y: Single;
                      const Text: string);                                                      overload; inline;
    procedure AddText(Canvas: TCanvas; const X, Y: Single; const Text: string);           overload; inline;
    procedure AddText(Font: TFont; const X, Y: Single; const Text: string);               overload; inline;
  end;
  {$ENDREGION}

  {$REGION 'TCanvasHelper'}
  TCanvasHelper = class helper for TCanvas
    {$REGION 'Draw bitmap'}
    procedure DrawBitmap(Bmp: TBitmap; const X, Y: Single; const Opacity: Single = 1);                                    overload; inline;
    procedure DrawBitmap(Bmp: TBitmap; const P: TPointF; const Opacity: Single = 1);                                      overload; inline;
    procedure DrawBitmap(Bmp: TBitmap; const DstRect: TRectF; const Opacity: Single = 1);                                 overload; inline;
    {$ENDREGION}
    {$REGION 'Draw lines'}
    procedure DrawLine(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                                overload; inline;
    procedure DrawLineSquareCap(const P1, P2: TPointF; const Opacity: Single = 1);                                              overload;
    procedure DrawLineButtCap(const P1, P2: TPointF; const Opacity: Single = 1);                                                overload;
    procedure DrawLineSquareCap(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                       overload; inline;
    procedure DrawLineButtCap(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                         overload; inline;
    procedure DrawArc(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);                       overload; inline;
    procedure DrawArc(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);              overload; inline;
    procedure DrawArc(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);                         overload; inline;
    procedure DrawBezier(const P1, P2, P3, P4: TPointF; const Opacity: Single = 1);                                             overload; inline;
    procedure DrawBezier(const X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; const Opacity: Single = 1);                              overload; inline;
    procedure DrawLines(const Points: array of TPointF; const Opacity: Single = 1);                                             overload;
    procedure DrawBeziers(const Points: array of TPointF; const Opacity: Single = 1);                                           overload;
    {$ENDREGION}
    {$REGION 'Draw shapes'}
    procedure DrawPolygonWithOpenArray(const Points: array of TPointF; const Opacity: Single = 1);                              overload;
    procedure DrawRect(const P1, P2: TPointF; const Opacity: Single = 1);                                                       overload; inline;
    procedure DrawRect(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                                overload; inline;
    procedure DrawRectSize(const Left, Top, Width, Height: Single; const Opacity: Single = 1);                                  overload; inline;
    procedure DrawRoundRect(const RT: TRectF; const RX, RY: Single; const Opacity: Single = 1);                                 overload; inline;
    procedure DrawRoundRect(const P1, P2: TPointF; const RX, RY: Single; const Opacity: Single = 1);                            overload; inline;
    procedure DrawRoundRect(const X1, Y1, X2, Y2, RX, RY: Single; const Opacity: Single = 1);                                   overload; inline;
    procedure DrawRoundRectSize(const Left, Top, Width, Height, RX, RY: Single; const Opacity: Single = 1);                     overload; inline;
    procedure DrawEllipse(const P1, P2: TPointF; const Opacity: Single = 1);                                                    overload; inline;
    procedure DrawEllipse(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                             overload; inline;
    procedure DrawEllipseSize(const Left, Top, Width, Height: Single; const Opacity: Single = 1);                               overload; inline;
    procedure DrawEllipseRad(const X0, Y0, RX, RY: Single; const Opacity: Single = 1);                                          overload; inline;
    procedure DrawEllipseRad(const CT: TPointF; const RX, RY: Single; const Opacity: Single = 1);                               overload; inline;
    procedure DrawCircle(const X0, Y0, R: Single; const Opacity: Single = 1);                                                   overload; inline;
    procedure DrawCircle(const CT: TPointF; const R: Single; const Opacity: Single = 1);                                        overload; inline;
    procedure DrawClosedArc(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);                 overload; inline;
    procedure DrawClosedArc(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);        overload; inline;
    procedure DrawClosedArc(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);                   overload; inline;
    procedure DrawPie(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);                       overload; inline;
    procedure DrawPie(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);              overload; inline;
    procedure DrawPie(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);                         overload; inline;
    {$ENDREGION}
    {$REGION 'Fill shapes'}
    procedure FillPolygonWithOpenArray(const Points: array of TPointF; const Opacity: Single = 1);                              overload;
    procedure FillRect(const P1, P2: TPointF; const Opacity: Single = 1);                                                       overload; inline;
    procedure FillRect(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                                overload; inline;
    procedure FillRectSize(const Left, Top, Width, Height: Single; const Opacity: Single = 1);                                  overload; inline;
    procedure FillRoundRect(const RT: TRectF; const RX, RY: Single; const Opacity: Single = 1);                                 overload; inline;
    procedure FillRoundRect(const P1, P2: TPointF; const RX, RY: Single; const Opacity: Single = 1);                            overload; inline;
    procedure FillRoundRect(const X1, Y1, X2, Y2, RX, RY: Single; const Opacity: Single = 1);                                   overload; inline;
    procedure FillRoundRectSize(const Left, Top, Width, Height, RX, RY: Single; const Opacity: Single = 1);                     overload; inline;
    procedure FillEllipse(const P1, P2: TPointF; const Opacity: Single = 1);                                                    overload; inline;
    procedure FillEllipse(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                             overload; inline;
    procedure FillEllipseSize(const Left, Top, Width, Height: Single; const Opacity: Single = 1);                               overload; inline;
    procedure FillEllipseRad(const X0, Y0, RX, RY: Single; const Opacity: Single = 1);                                          overload; inline;
    procedure FillEllipseRad(const CT: TPointF; const RX, RY: Single; const Opacity: Single = 1);                               overload; inline;
    procedure FillCircle(const X0, Y0, R: Single; const Opacity: Single = 1);                                                   overload; inline;
    procedure FillCircle(const CT: TPointF; const R: Single; const Opacity: Single = 1);                                        overload; inline;
    procedure FillArc(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);                       overload; inline;
    procedure FillArc(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);              overload; inline;
    procedure FillArc(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);                         overload; inline;
    procedure FillPie(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);                       overload; inline;
    procedure FillPie(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);              overload; inline;
    procedure FillPie(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);                         overload; inline;
    {$ENDREGION}
    {$REGION 'Fill and Draw shapes'}
    procedure FillDrawPolygon(const Points: array of TPointF; const Opacity: Single = 1);                                       overload;
    procedure FillDrawRect(const RT: TRectF; const Opacity: Single = 1);                                                        overload; inline;
    procedure FillDrawRect(const P1, P2: TPointF; const Opacity: Single = 1);                                                   overload; inline;
    procedure FillDrawRect(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                            overload; inline;
    procedure FillDrawRectSize(const Left, Top, Width, Height: Single; const Opacity: Single = 1);                              overload; inline;
    procedure FillDrawRoundRect(const RT: TRectF; const RX, RY: Single; const Opacity: Single = 1);                             overload; inline;
    procedure FillDrawRoundRect(const P1, P2: TPointF; const RX, RY: Single; const Opacity: Single = 1);                        overload; inline;
    procedure FillDrawRoundRect(const X1, Y1, X2, Y2, RX, RY: Single; const Opacity: Single = 1);                               overload; inline;
    procedure FillDrawRoundRectSize(const Left, Top, Width, Height, RX, RY: Single; const Opacity: Single = 1);                 overload; inline;
    procedure FillDrawEllipse(const RT: TRectF; const Opacity: Single = 1);                                                     overload; inline;
    procedure FillDrawEllipse(const P1, P2: TPointF; const Opacity: Single = 1);                                                overload; inline;
    procedure FillDrawEllipse(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                         overload; inline;
    procedure FillDrawEllipseSize(const Left, Top, Width, Height: Single; const Opacity: Single = 1);                           overload; inline;
    procedure FillDrawEllipseRad(const X0, Y0, RX, RY: Single; const Opacity: Single = 1);                                      overload; inline;
    procedure FillDrawEllipseRad(const CT: TPointF; const RX, RY: Single; const Opacity: Single = 1);                           overload; inline;
    procedure FillDrawCircle(const X0, Y0, R: Single; const Opacity: Single = 1);                                               overload; inline;
    procedure FillDrawCircle(const CT: TPointF; const R: Single; const Opacity: Single = 1);                                    overload; inline;
    procedure FillDrawArc(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);                   overload; inline;
    procedure FillDrawArc(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);          overload; inline;
    procedure FillDrawArc(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);                     overload;
    procedure FillDrawPie(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);                   overload; inline;
    procedure FillDrawPie(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);          overload; inline;
    procedure FillDrawPie(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);                     overload; inline;
    procedure FillDrawPath(const PathData: TPathData; const Opacity: Single = 1);                                               overload; inline;
    {$ENDREGION}
    {$REGION 'Draw lines'}
    procedure DrawLine(Pen: TStrokeBrush; const P1, P2: TPointF; const Opacity: Single = 1);                                                      overload; inline;
    procedure DrawLine(Pen: TStrokeBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                               overload; inline;
    procedure DrawLineSquareCap(Pen: TStrokeBrush; const P1, P2: TPointF; const Opacity: Single = 1);                                             overload;
    procedure DrawLineButtCap(Pen: TStrokeBrush; const P1, P2: TPointF; const Opacity: Single = 1);                                               overload;
    procedure DrawLineSquareCap(Pen: TStrokeBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                      overload; inline;
    procedure DrawLineButtCap(Pen: TStrokeBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                        overload; inline;
    procedure DrawArc(Pen: TStrokeBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);                      overload; inline;
    procedure DrawArc(Pen: TStrokeBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);             overload; inline;
    procedure DrawArc(Pen: TStrokeBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);                        overload; inline;
    procedure DrawBezier(Pen: TStrokeBrush; const P1, P2, P3, P4: TPointF; const Opacity: Single = 1);                                            overload; inline;
    procedure DrawBezier(Pen: TStrokeBrush; const X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; const Opacity: Single = 1);                             overload; inline;
    procedure DrawLines(Pen: TStrokeBrush; const Points: array of TPointF; const Opacity: Single = 1);                                            overload;
    procedure DrawBeziers(Pen: TStrokeBrush; const Points: array of TPointF; const Opacity: Single = 1);                                          overload;
    {$ENDREGION}
    {$REGION 'Draw shapes'}
    procedure DrawPolygon(Pen: TStrokeBrush; const Points: array of TPointF; const Opacity: Single = 1);                                          overload;
    procedure DrawRect(Pen: TStrokeBrush; const RT: TRectF; const Opacity: Single = 1);                                                           overload; inline;
    procedure DrawRect(Pen: TStrokeBrush; const P1, P2: TPointF; const Opacity: Single = 1);                                                      overload; inline;
    procedure DrawRect(Pen: TStrokeBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                               overload; inline;
    procedure DrawRectSize(Pen: TStrokeBrush; const Left, Top, Width, Height: Single; const Opacity: Single = 1);                                 overload; inline;
    procedure DrawRoundRect(Pen: TStrokeBrush; const RT: TRectF; const RX, RY: Single; const Opacity: Single = 1);                                overload; inline;
    procedure DrawRoundRect(Pen: TStrokeBrush; const P1, P2: TPointF; const RX, RY: Single; const Opacity: Single = 1);                           overload; inline;
    procedure DrawRoundRect(Pen: TStrokeBrush; const X1, Y1, X2, Y2, RX, RY: Single; const Opacity: Single = 1);                                  overload; inline;
    procedure DrawRoundRectSize(Pen: TStrokeBrush; const Left, Top, Width, Height, RX, RY: Single; const Opacity: Single = 1);                    overload; inline;
    procedure DrawEllipse(Pen: TStrokeBrush; const RT: TRectF; const Opacity: Single = 1);                                                        overload; inline;
    procedure DrawEllipse(Pen: TStrokeBrush; const P1, P2: TPointF; const Opacity: Single = 1);                                                   overload; inline;
    procedure DrawEllipse(Pen: TStrokeBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                            overload; inline;
    procedure DrawEllipseSize(Pen: TStrokeBrush; const Left, Top, Width, Height: Single; const Opacity: Single = 1);                              overload; inline;
    procedure DrawEllipseRad(Pen: TStrokeBrush; const X0, Y0, RX, RY: Single; const Opacity: Single = 1);                                         overload; inline;
    procedure DrawEllipseRad(Pen: TStrokeBrush; const CT: TPointF; const RX, RY: Single; const Opacity: Single = 1);                              overload; inline;
    procedure DrawCircle(Pen: TStrokeBrush; const X0, Y0, R: Single; const Opacity: Single = 1);                                                  overload; inline;
    procedure DrawCircle(Pen: TStrokeBrush; const CT: TPointF; const R: Single; const Opacity: Single = 1);                                       overload; inline;
    procedure DrawClosedArc(Pen: TStrokeBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);                overload; inline;
    procedure DrawClosedArc(Pen: TStrokeBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);       overload; inline;
    procedure DrawClosedArc(Pen: TStrokeBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);                  overload; inline;
    procedure DrawPie(Pen: TStrokeBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);                      overload; inline;
    procedure DrawPie(Pen: TStrokeBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);             overload; inline;
    procedure DrawPie(Pen: TStrokeBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);                        overload; inline;
    procedure DrawPath(Pen: TStrokeBrush; const PathData: TPathData; const Opacity: Single = 1);                                                  overload; inline;
    {$ENDREGION}
    {$REGION 'Fill shapes'}
    procedure FillPolygon(Brush: TBrush; const Points: array of TPointF; const Opacity: Single = 1);                                      overload;
    procedure FillRect(Brush: TBrush; const RT: TRectF; const Opacity: Single = 1);                                                       overload; inline;
    procedure FillRect(Brush: TBrush; const P1, P2: TPointF; const Opacity: Single = 1);                                                  overload; inline;
    procedure FillRect(Brush: TBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                           overload; inline;
    procedure FillRectSize(Brush: TBrush; const Left, Top, Width, Height: Single; const Opacity: Single = 1);                             overload; inline;
    procedure FillRoundRect(Brush: TBrush; const RT: TRectF; const RX, RY: Single; const Opacity: Single = 1);                            overload; inline;
    procedure FillRoundRect(Brush: TBrush; const P1, P2: TPointF; const RX, RY: Single; const Opacity: Single = 1);                       overload; inline;
    procedure FillRoundRect(Brush: TBrush; const X1, Y1, X2, Y2, RX, RY: Single; const Opacity: Single = 1);                              overload; inline;
    procedure FillRoundRectSize(Brush: TBrush; const Left, Top, Width, Height, RX, RY: Single; const Opacity: Single = 1);                overload; inline;
    procedure FillEllipse(Brush: TBrush; const RT: TRectF; const Opacity: Single = 1);                                                    overload; inline;
    procedure FillEllipse(Brush: TBrush; const P1, P2: TPointF; const Opacity: Single = 1);                                               overload; inline;
    procedure FillEllipse(Brush: TBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                        overload; inline;
    procedure FillEllipseSize(Brush: TBrush; const Left, Top, Width, Height: Single; const Opacity: Single = 1);                          overload; inline;
    procedure FillEllipseRad(Brush: TBrush; const X0, Y0, RX, RY: Single; const Opacity: Single = 1);                                     overload; inline;
    procedure FillEllipseRad(Brush: TBrush; const CT: TPointF; const RX, RY: Single; const Opacity: Single = 1);                          overload; inline;
    procedure FillCircle(Brush: TBrush; const X0, Y0, R: Single; const Opacity: Single = 1);                                              overload; inline;
    procedure FillCircle(Brush: TBrush; const CT: TPointF; const R: Single; const Opacity: Single = 1);                                   overload; inline;
    procedure FillArc(Brush: TBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);                  overload; inline;
    procedure FillArc(Brush: TBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);         overload; inline;
    procedure FillArc(Brush: TBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);                    overload; inline;
    procedure FillPie(Brush: TBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);                  overload; inline;
    procedure FillPie(Brush: TBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);         overload; inline;
    procedure FillPie(Brush: TBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);                    overload; inline;
    procedure FillPath(Brush: TBrush; const PathData: TPathData; const Opacity: Single = 1);                                              overload; inline;
    {$ENDREGION}
    {$REGION 'Fill and Draw shapes'}
    procedure FillDrawPolygon(Pen: TStrokeBrush; Brush: TBrush; const Points: array of TPointF; const Opacity: Single = 1);                                 overload;
    procedure FillDrawRect(Pen: TStrokeBrush; Brush: TBrush; const RT: TRectF; const Opacity: Single = 1);                                                  overload; inline;
    procedure FillDrawRect(Pen: TStrokeBrush; Brush: TBrush; const P1, P2: TPointF; const Opacity: Single = 1);                                             overload; inline;
    procedure FillDrawRect(Pen: TStrokeBrush; Brush: TBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                      overload; inline;
    procedure FillDrawRectSize(Pen: TStrokeBrush; Brush: TBrush; const Left, Top, Width, Height: Single; const Opacity: Single = 1);                        overload; inline;
    procedure FillDrawRoundRect(Pen: TStrokeBrush; Brush: TBrush; const RT: TRectF; const RX, RY: Single; const Opacity: Single = 1);                       overload; inline;
    procedure FillDrawRoundRect(Pen: TStrokeBrush; Brush: TBrush; const P1, P2: TPointF; const RX, RY: Single; const Opacity: Single = 1);                  overload; inline;
    procedure FillDrawRoundRect(Pen: TStrokeBrush; Brush: TBrush; const X1, Y1, X2, Y2, RX, RY: Single; const Opacity: Single = 1);                         overload; inline;
    procedure FillDrawRoundRectSize(Pen: TStrokeBrush; Brush: TBrush; const Left, Top, Width, Height, RX, RY: Single; const Opacity: Single = 1);           overload; inline;
    procedure FillDrawEllipse(Pen: TStrokeBrush; Brush: TBrush; const RT: TRectF; const Opacity: Single = 1);                                               overload; inline;
    procedure FillDrawEllipse(Pen: TStrokeBrush; Brush: TBrush; const P1, P2: TPointF; const Opacity: Single = 1);                                          overload; inline;
    procedure FillDrawEllipse(Pen: TStrokeBrush; Brush: TBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);                                   overload; inline;
    procedure FillDrawEllipseSize(Pen: TStrokeBrush; Brush: TBrush; const Left, Top, Width, Height: Single; const Opacity: Single = 1);                     overload; inline;
    procedure FillDrawEllipseRad(Pen: TStrokeBrush; Brush: TBrush; const X0, Y0, RX, RY: Single; const Opacity: Single = 1);                                overload; inline;
    procedure FillDrawEllipseRad(Pen: TStrokeBrush; Brush: TBrush; const CT: TPointF; const RX, RY: Single; const Opacity: Single = 1);                     overload; inline;
    procedure FillDrawCircle(Pen: TStrokeBrush; Brush: TBrush; const X0, Y0, R: Single; const Opacity: Single = 1);                                         overload; inline;
    procedure FillDrawCircle(Pen: TStrokeBrush; Brush: TBrush; const CT: TPointF; const R: Single; const Opacity: Single = 1);                              overload; inline;
    procedure FillDrawArc(Pen: TStrokeBrush; Brush: TBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);             overload; inline;
    procedure FillDrawArc(Pen: TStrokeBrush; Brush: TBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);    overload; inline;
    procedure FillDrawArc(Pen: TStrokeBrush; Brush: TBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);               overload;
    procedure FillDrawPie(Pen: TStrokeBrush; Brush: TBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);             overload; inline;
    procedure FillDrawPie(Pen: TStrokeBrush; Brush: TBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);    overload; inline;
    procedure FillDrawPie(Pen: TStrokeBrush; Brush: TBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);               overload; inline;
    procedure FillDrawPath(Pen: TStrokeBrush; Brush: TBrush; const PathData: TPathData; const Opacity: Single = 1);                                         overload; inline;
    {$ENDREGION}
    {$REGION 'MeasureText'}
    function MeasureText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                          VAlign: TTextAlign = TTextAlign.Center; Flags: TFillTextFlags = []): TRectF;                          overload; inline;
    function MeasureText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                          VAlign: TTextAlign = TTextAlign.Center; Flags: TFillTextFlags = []): TRectF;                          overload;
    function TextExtent(const Text: string): TSizeF;                                                                            overload;
    function TextExtent(const Text: string; const MaxWidth: Single): TSizeF;                                                    overload;
    {$ENDREGION}
    {$REGION 'TextOut'}
    // Use solid Canvas.Fill.Color to fill, ignore the gradient/bitmap of Canvas.Fill and Canvas.Stroke; This is the behavior of FMX.Canvas.FillText
    // TextOut use VCenter VAlign by default
    procedure TextOut(const X, Y: Single; const Text: string; const Opacity: Single = 1);                                       overload; inline;
    procedure TextOut(const X, Y, MaxWidth: Single; const Text: string; const Opacity: Single = 1);                             overload; inline;
    procedure TextOut(const X, Y: Single; const Text: string; HAlign, VAlign: TTextAlign; const Opacity: Single = 1);           overload; inline;
    procedure TextOut(const X, Y, MaxWidth: Single; const Text: string; HAlign, VAlign: TTextAlign; const Opacity: Single = 1); overload; inline;
    procedure TextOut(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign; const Opacity: Single = 1);  overload; inline;
    procedure TextOut(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                      VAlign: TTextAlign = TTextAlign.Center; Flags: TFillTextFlags = []; const Opacity: Single = 1);          overload; inline;

    procedure TextOut(Font: TFont; const X, Y: Single; const Text: string; const Opacity: Single = 1);                          overload; inline;
    procedure TextOut(Font: TFont; const X, Y, MaxWidth: Single; const Text: string; const Opacity: Single = 1);                overload; inline;
    procedure TextOut(Font: TFont; const X, Y: Single; const Text: string; HAlign, VAlign: TTextAlign;
                      const Opacity: Single = 1);                                                                               overload; inline;
    procedure TextOut(Font: TFont; const X, Y, MaxWidth: Single; const Text: string; HAlign, VAlign: TTextAlign;
                      const Opacity: Single = 1);                                                                               overload; inline;
    procedure TextOut(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                      const Opacity: Single = 1);                                                                               overload; inline;
    procedure TextOut(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                      VAlign: TTextAlign = TTextAlign.Center; Flags: TFillTextFlags = []; const Opacity: Single = 1);          overload; inline;

    procedure TextOut(Color: TAlphaColor; const X, Y: Single; const Text: string; const Opacity: Single = 1);                   overload; inline;
    procedure TextOut(Color: TAlphaColor; const X, Y, MaxWidth: Single; const Text: string; const Opacity: Single = 1);         overload; inline;
    procedure TextOut(Color: TAlphaColor; const X, Y: Single; const Text: string; HAlign, VAlign: TTextAlign;
                      const Opacity: Single = 1);                                                                               overload; inline;
    procedure TextOut(Color: TAlphaColor; const X, Y, MaxWidth: Single; const Text: string; HAlign, VAlign: TTextAlign;
                      const Opacity: Single = 1);                                                                               overload; inline;
    procedure TextOut(Color: TAlphaColor; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                      const Opacity: Single = 1);                                                                               overload; inline;
    procedure TextOut(Color: TAlphaColor; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                      VAlign: TTextAlign = TTextAlign.Center; Flags: TFillTextFlags = []; const Opacity: Single = 1);          overload; inline;

    procedure TextOut(Font: TFont; Color: TAlphaColor; const X, Y: Single; const Text: string;
                      const Opacity: Single = 1);                                                                               overload; inline;
    procedure TextOut(Font: TFont; Color: TAlphaColor; const X, Y, MaxWidth: Single; const Text: string;
                      const Opacity: Single = 1);                                                                               overload; inline;
    procedure TextOut(Font: TFont; Color: TAlphaColor; const X, Y: Single; const Text: string; HAlign, VAlign: TTextAlign;
                      const Opacity: Single = 1);                                                                               overload; inline;
    procedure TextOut(Font: TFont; Color: TAlphaColor; const X, Y, MaxWidth: Single; const Text: string;
                      HAlign, VAlign: TTextAlign; const Opacity: Single = 1);                                                   overload; inline;
    procedure TextOut(Font: TFont; Color: TAlphaColor; const RT: TRectF; const Text: string; WordWrap: Boolean;
                      HAlign: TTextAlign; const Opacity: Single = 1);                                                           overload; inline;
    procedure TextOut(Font: TFont; Color: TAlphaColor; const RT: TRectF; const Text: string; WordWrap: Boolean;
                      HAlign: TTextAlign; VAlign: TTextAlign = TTextAlign.Center; Flags: TFillTextFlags = [];
                      const Opacity: Single = 1);                                                                               overload;

    procedure TextOutLT(const X, Y: Single; const Text: string; const Opacity: Single = 1);                                     overload; inline;
    procedure TextOutLT(const X, Y, MaxWidth: Single; const Text: string; const Opacity: Single = 1);                           overload; inline;
    procedure TextOutLT(Color: TAlphaColor; const X, Y: Single; const Text: string; const Opacity: Single = 1);                 overload; inline;
    procedure TextOutLT(Color: TAlphaColor; const X, Y, MaxWidth: Single; const Text: string; const Opacity: Single = 1);       overload; inline;
    {$ENDREGION}
    {$REGION 'Drawing Text'}
    // Draw the outline with Canvas.Stroke
    procedure DrawText(const X, Y: Single; const Text: string; const Opacity: Single = 1);                                      overload; inline;
    procedure DrawText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       const Opacity: Single = 1);                                                                              overload; inline;
    procedure DrawText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);                              overload; inline;

    procedure DrawText(Font: TFont; const X, Y: Single; const Text: string; const Opacity: Single = 1);                         overload; inline;
    procedure DrawText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       const Opacity: Single = 1);                                                                              overload; inline;
    procedure DrawText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);                              overload; inline;

    // Fill the shape with Canvas.Fill
    procedure FillText(const X, Y: Single; const Text: string; const Opacity: Single = 1);                                      overload; inline;
    procedure FillText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       const Opacity: Single = 1);                                                                              overload; inline;
    procedure FillText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);                              overload; inline;

    procedure FillText(Font: TFont; const X, Y: Single; const Text: string; const Opacity: Single = 1);                         overload; inline;
    procedure FillText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       const Opacity: Single = 1);                                                                              overload; inline;
    procedure FillText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);                              overload; inline;

    // Fill the inside with Canvas.Fill then draw the outline with Canvas.Stroke
    procedure FillDrawText(const X, Y: Single; const Text: string; const Opacity: Single = 1);                                  overload; inline;
    procedure FillDrawText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                           const Opacity: Single = 1);                                                                          overload; inline;
    procedure FillDrawText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                           VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);                          overload; inline;

    procedure FillDrawText(Font: TFont; const X, Y: Single; const Text: string; const Opacity: Single = 1);                     overload; inline;
    procedure FillDrawText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                           const Opacity: Single = 1);                                                                          overload; inline;
    procedure FillDrawText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                           VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);                          overload; inline;
    {$ENDREGION}
    {$REGION 'Drawing Text with Pen and Brush'}
    procedure DrawText(Pen: TStrokeBrush;
                       const X, Y: Single; const Text: string; const Opacity: Single = 1);                                      overload; inline;
    procedure DrawText(Pen: TStrokeBrush;
                       const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       const Opacity: Single = 1);                                                                              overload; inline;
    procedure DrawText(Pen: TStrokeBrush;
                       const RT: TRectF;const Text: string; WordWrap: Boolean; HAlign, VAlign: TTextAlign;
                       Flags: TFillTextFlags = []; const Opacity: Single = 1);                                                  overload; inline;

    procedure DrawText(Pen: TStrokeBrush; Font: TFont;
                       const X, Y: Single; const Text: string; const Opacity: Single = 1);                                      overload; inline;
    procedure DrawText(Pen: TStrokeBrush; Font: TFont;
                       const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign; const Opacity: Single = 1); overload; inline;
    procedure DrawText(Pen: TStrokeBrush; Font: TFont;
                       const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign, VAlign: TTextAlign;
                       Flags: TFillTextFlags = []; const Opacity: Single = 1);                                                  overload; inline;

    procedure FillText(Brush: TBrush;
                       const X, Y: Single; const Text: string; const Opacity: Single = 1);                                      overload; inline;
    procedure FillText(Brush: TBrush;
                       const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       const Opacity: Single = 1);                                                                              overload; inline;
    procedure FillText(Brush: TBrush;
                       const RT: TRectF;const Text: string; WordWrap: Boolean; HAlign, VAlign: TTextAlign;
                       Flags: TFillTextFlags = []; const Opacity: Single = 1);                                                  overload; inline;

    procedure FillText(Brush: TBrush; Font: TFont;
                       const X, Y: Single; const Text: string; const Opacity: Single = 1);                                      overload; inline;
    procedure FillText(Brush: TBrush; Font: TFont;
                       const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign; const Opacity: Single = 1); overload; inline;
    procedure FillText(Brush: TBrush; Font: TFont;
                       const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign, VAlign: TTextAlign;
                       Flags: TFillTextFlags = []; const Opacity: Single = 1);                                                  overload; inline;

    procedure FillDrawText(Pen: TStrokeBrush; Brush: TBrush;
                           const X, Y: Single; const Text: string; const Opacity: Single = 1);                                  overload; inline;
    procedure FillDrawText(Pen: TStrokeBrush; Brush: TBrush;
                           const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                           const Opacity: Single = 1);                                                                          overload; inline;
    procedure FillDrawText(Pen: TStrokeBrush; Brush: TBrush;
                           const RT: TRectF;const Text: string; WordWrap: Boolean; HAlign, VAlign: TTextAlign;
                           Flags: TFillTextFlags = []; const Opacity: Single = 1);                                              overload; inline;

    procedure FillDrawText(Pen: TStrokeBrush; Brush: TBrush; Font: TFont;
                           const X, Y: Single; const Text: string; const Opacity: Single = 1);                                  overload; inline;
    procedure FillDrawText(Pen: TStrokeBrush; Brush: TBrush; Font: TFont;
                           const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                           const Opacity: Single = 1);                                                                          overload; inline;
    procedure FillDrawText(Pen: TStrokeBrush; Brush: TBrush; Font: TFont;
                           const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign, VAlign: TTextAlign;
                           Flags: TFillTextFlags = []; const Opacity: Single = 1);                                              overload;
    {$ENDREGION}
    {$REGION 'Draw Shape'}
    procedure DrawShape(const PT: TPointF; Shape: TSimpleShape;
                        const OuterSize: Single; const RelSize: Single = 0; const Opacity: Single = 0); overload; inline;
    procedure DrawShape(Pen: TStrokeBrush; const PT: TPointF; Shape: TSimpleShape;
                        const OuterSize: Single; const RelSize: Single = 0; const Opacity: Single = 0); overload; inline;
    procedure DrawShape(Brush: TBrush; const PT: TPointF; Shape: TSimpleShape;
                        const OuterSize: Single; const RelSize: Single = 0; const Opacity: Single = 0); overload; inline;
    procedure DrawShape(Pen: TStrokeBrush; Brush: TBrush; const PT: TPointF; Shape: TSimpleShape;
                        const OuterSize: Single; const RelSize: Single = 0; const Opacity: Single = 0); overload; inline;
    procedure DrawShape(const X, Y: Single; Shape: TSimpleShape;
                        const OuterSize: Single; const RelSize: Single = 0; const Opacity: Single = 0); overload; inline;
    procedure DrawShape(Pen: TStrokeBrush; const X, Y: Single; Shape: TSimpleShape;
                        const OuterSize: Single; const RelSize: Single = 0; const Opacity: Single = 0); overload; inline;
    procedure DrawShape(Brush: TBrush; const X, Y: Single; Shape: TSimpleShape;
                        const OuterSize: Single; const RelSize: Single = 0; const Opacity: Single = 0); overload; inline;
    procedure DrawShape(Pen: TStrokeBrush; Brush: TBrush; const X, Y: Single; Shape: TSimpleShape;
                        const OuterSize: Single; const RelSize: Single = 0; const Opacity: Single = 0); overload;
   {$ENDREGION}
  end;
{$ENDREGION}

{$REGION 'FMX bug fixers'}
procedure TextLayoutToPath(Layout: TTextLayout; Path: TPathData); {$IFNDEF FMXFixTextLayoutBug}inline;{$ENDIF}
{$ENDREGION}

implementation

uses
  wc.Math;


{$REGION 'FMX bug fixers'}
procedure TextLayoutToPath(Layout: TTextLayout; Path: TPathData);
begin
  {$IFDEF FMXFixTextLayoutBug}
  var
    TempPath: TPathData;
  if GlobalUseGPUCanvas then
  begin
    Layout.ConvertToPath(Path);
    Exit;
  end;
  if Path.IsEmpty then
  begin
    Layout.ConvertToPath(Path);
    Path.Translate(Layout.TopLeft.X + Layout.Padding.Left, Layout.TopLeft.Y + Layout.Padding.Top);
  end else
  begin
    TempPath := TPathData.Create;
    try
      Layout.ConvertToPath(TempPath);
      TempPath.Translate(Layout.TopLeft.X + Layout.Padding.Left, Layout.TopLeft.Y + Layout.Padding.Top);
      Path.AddPath(TempPath);
    finally
      TempPath.Free;
    end;
  end;
  {$ELSE}
  Layout.ConvertToPath(Path);
  {$ENDIF}
end;
{$ENDREGION}

{$REGION 'TPathDataHelper'}
procedure TPathDataHelper.MoveTo(const X, Y: Single);
begin
  MoveTo(PointF(X, Y));
end;

procedure TPathDataHelper.MoveToRel(const X, Y: Single);
begin
  MoveToRel(PointF(X, Y));
end;

procedure TPathDataHelper.LineTo(const X, Y: Single);
begin
  LineTo(PointF(X, Y));
end;

procedure TPathDataHelper.LineToRel(const X, Y: Single);
begin
  LineToRel(PointF(X, Y));
end;

procedure TPathDataHelper.AddLine(const P1, P2: TPointF);
begin
  MoveTo(P1);
  LineTo(P2);
end;

procedure TPathDataHelper.AddLine(const X1, Y1, X2, Y2: Single);
begin
  MoveTo(PointF(X1, Y1));
  LineTo(PointF(X2, Y2));
end;

procedure TPathDataHelper.AddBezier(const P1, P2, P3, P4: TPointF);
begin
  MoveTo(P1);
  CurveTo(P2, P3, P4);
end;

procedure TPathDataHelper.AddBezier(const X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single);
begin
  MoveTo(PointF(X1, Y1));
  CurveTo(PointF(X2, Y2), PointF(X4, Y4), PointF(X4, Y4));
end;

procedure TPathDataHelper.AddLines(const Points: array of TPointF);
var
  i: NInt;
begin
  if Length(Points) = 0 then Exit;
  MoveTo(Points[0]);
  for i := 1 to Length(Points) - 1 do
    LineTo(Points[i]);
end;

procedure TPathDataHelper.AddPolygon(const Points: array of TPointF);
var
  i: NInt;
begin
  if Length(Points) = 0 then Exit;
  MoveTo(Points[0]);
  for i := 1 to Length(Points) - 1 do
    LineTo(Points[i]);
  ClosePath;
end;

procedure TPathDataHelper.AddBeziers(const Points: array of TPointF);
var
  i: NInt;
begin
  if Length(Points) = 0 then Exit;
  MoveTo(Points[0]);
  for i := 1 to (Length(Points) - 1) div 3 do
    CurveTo(Points[3 * i - 2], Points[3 * i - 1], Points[3 * i]);
end;

procedure TPathDataHelper.AddRectangle(const P1, P2: TPointF);
begin
  AddRectangle(TRectF.Create(P1, P2), 0, 0, []);
end;

procedure TPathDataHelper.AddRectangle(const X1, Y1, X2, Y2: Single);
begin
  AddRectangle(TRectF.Create(X1, Y1, X2, Y2), 0, 0, []);
end;

procedure TPathDataHelper.AddRectangleSize(const Left, Top, Width, Height: Single);
begin
  AddRectangle(TRectF.Create(Left, Top, Left + Width, Top + Height), 0, 0, []);
end;

procedure TPathDataHelper.AddEllipse(const P1, P2: TPointF);
begin
  AddEllipse(TRectF.Create(P1, P2));
end;

procedure TPathDataHelper.AddEllipse(const X1, Y1, X2, Y2: Single);
begin
  AddEllipse(TRectF.Create(X1, Y1, X2, Y2));
end;

procedure TPathDataHelper.AddEllipseSize(const Left, Top, Width, Height: Single);
begin
  AddEllipse(TRectF.Create(Left, Top, Left + Width, Top + Height));
end;

procedure TPathDataHelper.AddEllipseRad(const X0, Y0, RX, RY: Single);
begin
  AddEllipse(TRectF.Create(X0 - RX, Y0 - RY, X0 + RX, Y0 + RY));
end;

procedure TPathDataHelper.AddEllipseRad(const CT: TPointF; const RX, RY: Single);
begin
  AddEllipse(TRectF.Create(CT.X - RX, CT.Y - RY, CT.X + RX, CT.Y + RY));
end;

procedure TPathDataHelper.AddCircle(const X0, Y0, R: Single);
begin
  AddEllipse(TRectF.Create(X0 - R, Y0 - R, X0 + R, Y0 + R));
end;

procedure TPathDataHelper.AddCircle(const CT: TPointF; const R: Single);
begin
  AddEllipse(TRectF.Create(CT.X - R, CT.Y - R, CT.X + R, CT.Y + R));
end;

procedure TPathDataHelper.AddRoundRectangle(const RT: TRectF; const RX, RY: Single);
begin
  AddRectangle(RT, RX, RY, AllCorners);
end;

procedure TPathDataHelper.AddRoundRectangle(const P1, P2: TPointF; const RX, RY: Single);
begin
  AddRectangle(TRectF.Create(P1, P2), RX, RY, AllCorners);
end;

procedure TPathDataHelper.AddRoundRectangle(const X1, Y1, X2, Y2, RX, RY: Single);
begin
  AddRectangle(TRectF.Create(X1, Y1, X2, Y2), RX, RY, AllCorners);
end;

procedure TPathDataHelper.AddRoundRectangleSize(const Left, Top, Width, Height, RX, RY: Single);
begin
  AddRectangle(TRectF.Create(Left, Top, Left + Width, Top + Height), RX, RY, AllCorners);
end;

procedure TPathDataHelper.AddArc(const RT: TRectF; const StartAngle, SweepAngle: Single);
begin
  AddArc(RT.CenterPoint, PointF(RT.Width/2, RT.Height/2), StartAngle, SweepAngle);
end;

procedure TPathDataHelper.AddArc(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single);
begin
  AddArc(PointF(X0, Y0), PointF(RX, RY), StartAngle, SweepAngle);
end;

procedure TPathDataHelper.AddArc(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single);
begin
  AddArc(CT, PointF(RX, RY), StartAngle, SweepAngle);
end;

procedure TPathDataHelper.AddPie(const RT: TRectF; const StartAngle, SweepAngle: Single);
begin
  AddArc(RT.CenterPoint, PointF(RT.Width/2, RT.Height/2), StartAngle, SweepAngle);
  LineTo(RT.CenterPoint);
  ClosePath;
end;

procedure TPathDataHelper.AddPie(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single);
begin
  AddArc(PointF(X0, Y0), PointF(RX, RY), StartAngle, SweepAngle);
  LineTo(PointF(X0, Y0));
  ClosePath;
end;

procedure TPathDataHelper.AddPie(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single);
begin
  AddArc(CT, PointF(RX, RY), StartAngle, SweepAngle);
  LineTo(CT);
  ClosePath;
end;

procedure TPathDataHelper.AddText(Canvas: TCanvas; Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean;
  HAlign, VAlign: TTextAlign; Flags: TFillTextFlags);
var
  Layout: TTextLayout;
begin
  if Text= '' then Exit;

  if Canvas = nil
    then Layout := TTextLayoutManager.DefaultTextLayout.Create
    else Layout := TTextLayoutManager.TextLayoutByCanvas(Canvas.ClassType).Create(Canvas);
  try
    Layout.BeginUpdate;
    try
      Layout.TopLeft := RT.TopLeft;
      Layout.MaxSize := PointF(RT.Width, RT.Height);
      Layout.Text := Text;
      Layout.WordWrap := WordWrap;
      Layout.HorizontalAlign := HAlign;
      Layout.VerticalAlign := VAlign;
      Layout.RightToLeft := TFillTextFlag.RightToLeft in Flags;
      Layout.Font := Font;
    finally
      Layout.EndUpdate;
    end;
    TextLayoutToPath(Layout, Self);
  finally
    FreeAndNil(Layout);
  end;
end;

procedure TPathDataHelper.AddText(Canvas: TCanvas; const RT: TRectF; const Text: string; WordWrap: Boolean;
  HAlign, VAlign: TTextAlign; Flags: TFillTextFlags);
begin
  AddText(Canvas, Canvas.Font, RT, Text, WordWrap, HAlign, VAlign, Flags);
end;

procedure TPathDataHelper.AddText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign, VAlign: TTextAlign; Flags: TFillTextFlags);
begin
  AddText(nil, Font, RT, Text, WordWrap, HAlign, VAlign, Flags);
end;

procedure TPathDataHelper.AddText(Canvas: TCanvas; Font: TFont; const X, Y: Single; const Text: string);
begin
  AddText(Canvas, Font, TREctF.Create(X, Y, X + TextOutMaxSize, Y + TextOutMaxSize), Text, False, TTextAlign.Leading, TTextAlign.Leading, []);
end;

procedure TPathDataHelper.AddText(Canvas: TCanvas; const X, Y: Single; const Text: string);
begin
  AddText(Canvas, Canvas.Font, X, Y, Text);
end;

procedure TPathDataHelper.AddText(Font: TFont; const X, Y: Single; const Text: string);
begin
  AddText(nil, Font, X, Y, Text);
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.Draw bitmap'}
procedure TCanvasHelper.DrawBitmap(Bmp: TBitmap; const X, Y: Single; const Opacity: Single = 1);
begin
  DrawBitmap(Bmp, Bmp.BoundsF, RectF(X, Y, Bmp.Width, Bmp.Height), Opacity);
end;

procedure TCanvasHelper.DrawBitmap(Bmp: TBitmap; const P: TPointF; const Opacity: Single = 1);
begin
  DrawBitmap(Bmp, Bmp.BoundsF, RectF(P.X, P.Y, Bmp.Width, Bmp.Height), Opacity);
end;

procedure TCanvasHelper.DrawBitmap(Bmp: TBitmap; const DstRect: TRectF; const Opacity: Single = 1);
begin
  DrawBitmap(Bmp, Bmp.BoundsF, DstRect, Opacity);
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.Draw lines'}
procedure TCanvasHelper.DrawLine(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  DrawLine(PointF(X1, Y1), PointF(X2, Y2), Opacity);
end;

{$IFDEF MSWINDOWS}
procedure TCanvasHelper.DrawLineButtCap(const P1, P2: TPointF; const Opacity: Single = 1);
var
 d, dx, dy: Float64;
begin
  d := ez.Distance(P1.X - P2.X, P1.Y - P2.Y);
  if d = 0
    then DrawLine(P1, P2, Opacity)
  else begin
    dx := (P2.X - P1.X) * Stroke.Thickness / 2 / d;
    dy := (P2.Y - P1.Y) * Stroke.Thickness / 2 / d;
    DrawLine(PointF(P1.X + dx, P1.Y + dy), PointF(P2.X - dx, P2.Y - dy), Opacity)
  end;
end;

procedure TCanvasHelper.DrawLineSquareCap(const P1, P2: TPointF; const Opacity: Single = 1);
begin
  DrawLine(P1, P2, Opacity);
end;
{$ENDIF}

{$IFDEF MacOS}
procedure TCanvasHelper.DrawLineButtCap(const P1, P2: TPointF; const Opacity: Single = 1);
begin
  DrawLine(P1, P2, Opacity);
end;

procedure TCanvasHelper.DrawLineSquareCap(const P1, P2: TPointF; const Opacity: Single = 1);
var
 d, dx, dy: Float64;
begin
  d := ez.Distance(P1.X - P2.X, P1.Y - P2.Y);
  if d = 0
    then DrawLine(P1, P2, Opacity)
  else begin
    dx := (P2.X - P1.X) * Stroke.Thickness / 2 / d;
    dy := (P2.Y - P1.Y) * Stroke.Thickness / 2 / d;
    DrawLine(PointF(P1.X - dx, P1.Y - dy), PointF(P2.X + dx, P2.Y + dy), Opacity)
  end;
end;
{$ENDIF}

procedure TCanvasHelper.DrawLineSquareCap(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  DrawLineSquareCap(PointF(X1, Y1), PointF(X2, Y2), Opacity);
end;

procedure TCanvasHelper.DrawLineButtCap(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  DrawLineButtCap(PointF(X1, Y1), PointF(X2, Y2), Opacity);
end;

procedure TCanvasHelper.DrawArc(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  DrawArc(RT.CenterPoint, PointF(RT.Width / 2, RT.Height / 2), StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawArc(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  DrawArc(CT, PointF(RX, RY), StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawArc(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  DrawArc(PointF(X0, Y0), PointF(RX, RY), StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawBezier(const P1, P2, P3, P4: TPointF; const Opacity: Single = 1);
begin
  DrawBezier(Stroke, P1, P2, P3, P4, Opacity);
end;

procedure TCanvasHelper.DrawBezier(const X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; const Opacity: Single = 1);
begin
  DrawBezier(Stroke, X1, Y1, X2, Y2, X3, Y3, X4, Y4, Opacity);
end;

procedure TCanvasHelper.DrawLines(const Points: array of TPointF; const Opacity: Single = 1);
begin
  DrawLines(Stroke, Points, Opacity);
end;

procedure TCanvasHelper.DrawBeziers(const Points: array of TPointF; const Opacity: Single = 1);
begin
  DrawBeziers(Stroke, Points, Opacity);
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.Draw closed shapes'}
procedure TCanvasHelper.DrawPolygonWithOpenArray(const Points: array of TPointF; const Opacity: Single = 1);
begin
  FillDrawPolygon(Stroke, nil, Points, Opacity);
end;

procedure TCanvasHelper.DrawRect(const P1, P2: TPointF; const Opacity: Single = 1);
begin
  DrawRect(TRectF.Create(P1, P2), Opacity);
end;

procedure TCanvasHelper.DrawRect(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  DrawRect(TRectF.Create(X1, Y1, X2, Y2), Opacity);
end;

procedure TCanvasHelper.DrawRectSize(const Left, Top, Width, Height: Single; const Opacity: Single = 1);
begin
  DrawRect(TRectF.Create(Left, Top, Left + Width, Top + Height), Opacity);
end;

procedure TCanvasHelper.DrawRoundRect(const RT: TRectF; const RX, RY: Single; const Opacity: Single = 1);
begin
  DrawRect(RT, RX, RY, AllCorners, Opacity);
end;

procedure TCanvasHelper.DrawRoundRect(const P1, P2: TPointF; const RX, RY: Single; const Opacity: Single = 1);
begin
  DrawRect(TRectF.Create(P1, P2), RX, RY, AllCorners, Opacity);
end;

procedure TCanvasHelper.DrawRoundRect(const X1, Y1, X2, Y2, RX, RY: Single; const Opacity: Single = 1);
begin
  DrawRect(TRectF.Create(X1, Y1, X2, Y2), RX, RY, AllCorners, Opacity);
end;

procedure TCanvasHelper.DrawRoundRectSize(const Left, Top, Width, Height, RX, RY: Single; const Opacity: Single = 1);
begin
  DrawRect(TRectF.Create(Left, Top, Left + Width, Top + Height), RX, RY, AllCorners, Opacity);
end;

procedure TCanvasHelper.DrawEllipse(const P1, P2: TPointF; const Opacity: Single = 1);
begin
  DrawEllipse(TRectF.Create(P1, P2), Opacity);
end;

procedure TCanvasHelper.DrawEllipse(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  DrawEllipse(TRectF.Create(X1, Y1, X2, Y2), Opacity);
end;

procedure TCanvasHelper.DrawEllipseSize(const Left, Top, Width, Height: Single; const Opacity: Single = 1);
begin
  DrawEllipse(TRectF.Create(Left, Top, Left + Width, Top + Height), Opacity);
end;

procedure TCanvasHelper.DrawEllipseRad(const X0, Y0, RX, RY: Single; const Opacity: Single = 1);
begin
  DrawEllipse(TRectF.Create(X0 - RX, Y0 - RY, X0 + RX, Y0 + RY), Opacity);
end;

procedure TCanvasHelper.DrawEllipseRad(const CT: TPointF; const RX, RY: Single; const Opacity: Single = 1);
begin
  DrawEllipse(TRectF.Create(CT.X - RX, CT.Y - RY, CT.X + RX, CT.Y + RY), Opacity);
end;

procedure TCanvasHelper.DrawCircle(const X0, Y0, R: Single; const Opacity: Single = 1);
begin
  DrawEllipse(TRectF.Create(X0 - R, Y0 - R, X0 + R, Y0 + R), Opacity);
end;

procedure TCanvasHelper.DrawCircle(const CT: TPointF; const R: Single; const Opacity: Single = 1);
begin
  DrawEllipse(CT.X - R, CT.Y - R, CT.X + R, CT.Y + R);
end;

procedure TCanvasHelper.DrawClosedArc(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(Stroke, nil, RT, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawClosedArc(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(Stroke, nil, CT, RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawClosedArc(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(Stroke, nil, PointF(X0, Y0), RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawPie(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(Stroke, nil, RT, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawPie(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(Stroke, nil, CT, RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawPie(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(Stroke, nil, PointF(X0, Y0), RX, RY, StartAngle, SweepAngle, Opacity);
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.Fill closed shapes'}
procedure TCanvasHelper.FillPolygonWithOpenArray(const Points: array of TPointF; const Opacity: Single = 1);
begin
  FillDrawPolygon(nil, Fill, Points, Opacity);
end;

procedure TCanvasHelper.FillRect(const P1, P2: TPointF; const Opacity: Single = 1);
begin
  FillRect(TRectF.Create(P1, P2), Opacity);
end;

procedure TCanvasHelper.FillRect(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  FillRect(TRectF.Create(X1, Y1, X2, Y2), Opacity);
end;

procedure TCanvasHelper.FillRectSize(const Left, Top, Width, Height: Single; const Opacity: Single = 1);
begin
  FillRect(TRectF.Create(Left, Top, Left + Width, Top + Height), Opacity);
end;

procedure TCanvasHelper.FillRoundRect(const RT: TRectF; const RX, RY: Single; const Opacity: Single = 1);
begin
  FillRect(RT, RX, RY, AllCorners, Opacity);
end;

procedure TCanvasHelper.FillRoundRect(const P1, P2: TPointF; const RX, RY: Single; const Opacity: Single = 1);
begin
  FillRect(TRectF.Create(P1, P2), RX, RY, AllCorners, Opacity);
end;

procedure TCanvasHelper.FillRoundRect(const X1, Y1, X2, Y2, RX, RY: Single; const Opacity: Single = 1);
begin
  FillRect(TRectF.Create(X1, Y1, X2, Y2), RX, RY, AllCorners, Opacity);
end;

procedure TCanvasHelper.FillRoundRectSize(const Left, Top, Width, Height, RX, RY: Single; const Opacity: Single = 1);
begin
  FillRect(TRectF.Create(Left, Top, Left + Width, Top + Height), RX, RY, AllCorners, Opacity);
end;

procedure TCanvasHelper.FillEllipse(const P1, P2: TPointF; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(P1, P2), Opacity);
end;

procedure TCanvasHelper.FillEllipse(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(X1, Y1, X2, Y2), Opacity);
end;

procedure TCanvasHelper.FillEllipseSize(const Left, Top, Width, Height: Single; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(Left, Top, Left + Width, Top + Height), Opacity);
end;

procedure TCanvasHelper.FillEllipseRad(const X0, Y0, RX, RY: Single; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(X0 - RX, Y0 - RY, X0 + RX, Y0 + RY), Opacity);
end;

procedure TCanvasHelper.FillEllipseRad(const CT: TPointF; const RX, RY: Single; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(CT.X - RX, CT.Y - RY, CT.X + RX, CT.Y + RY), Opacity);
end;

procedure TCanvasHelper.FillCircle(const X0, Y0, R: Single; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(X0 - R, Y0 - R, X0 + R, Y0 + R), Opacity);
end;

procedure TCanvasHelper.FillCircle(const CT: TPointF; const R: Single; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(CT.X - R, CT.Y - R, CT.X + R, CT.Y + R), Opacity);
end;

procedure TCanvasHelper.FillArc(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(nil, Fill, RT, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillArc(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(nil, Fill, CT, RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillArc(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(nil, Fill, PointF(X0, Y0), RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillPie(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(nil, Fill, RT, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillPie(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(nil, Fill, CT, RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillPie(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(nil, Fill, PointF(X0, Y0), RX, RY, StartAngle, SweepAngle, Opacity);
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.Fill and Draw shapes'}
procedure TCanvasHelper.FillDrawPolygon(const Points: array of TPointF; const Opacity: Single = 1);
begin
  FillDrawPolygon(Stroke, Fill, Points, Opacity);
end;

procedure TCanvasHelper.FillDrawRect(const RT: TRectF; const Opacity: Single = 1);
begin
  FillRect(RT, Opacity);
  DrawRect(RT, Opacity);
end;

procedure TCanvasHelper.FillDrawRect(const P1, P2: TPointF; const Opacity: Single = 1);
begin
  FillRect(P1, P2, Opacity);
  DrawRect(P1, P2, Opacity);
end;

procedure TCanvasHelper.FillDrawRect(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  FillRect(X1, Y1, X2, Y2, Opacity);
  DrawRect(X1, Y1, X2, Y2, Opacity);
end;

procedure TCanvasHelper.FillDrawRectSize(const Left, Top, Width, Height: Single; const Opacity: Single = 1);
begin
  FillRectSize(Left, Top, Width, Height, Opacity);
  DrawRectSize(Left, Top, Width, Height, Opacity);
end;

procedure TCanvasHelper.FillDrawRoundRect(const RT: TRectF; const RX, RY: Single; const Opacity: Single = 1);
begin
  FillRoundRect(RT, RX, RY, Opacity);
  DrawRoundRect(RT, RX, RY, Opacity);
end;

procedure TCanvasHelper.FillDrawRoundRect(const P1, P2: TPointF; const RX, RY: Single; const Opacity: Single = 1);
begin
  FillRoundRect(P1, P2, RX, RY, Opacity);
  DrawRoundRect(P1, P2, RX, RY, Opacity);
end;

procedure TCanvasHelper.FillDrawRoundRect(const X1, Y1, X2, Y2, RX, RY: Single; const Opacity: Single = 1);
begin
  FillRoundRect(X1, Y1, X2, Y2, RX, RY, Opacity);
  DrawRoundRect(X1, Y1, X2, Y2, RX, RY, Opacity);
end;

procedure TCanvasHelper.FillDrawRoundRectSize(const Left, Top, Width, Height, RX, RY: Single; const Opacity: Single = 1);
begin
  FillRoundRectSize(Left, Top, Width, Height, RX, RY, Opacity);
  DrawRoundRectSize(Left, Top, Width, Height, RX, RY, Opacity);
end;

procedure TCanvasHelper.FillDrawEllipse(const RT: TRectF; const Opacity: Single = 1);
begin
  FillEllipse(RT, Opacity);
  DrawEllipse(RT, Opacity);
end;

procedure TCanvasHelper.FillDrawEllipse(const P1, P2: TPointF; const Opacity: Single = 1);
begin
  FillEllipse(P1, P2, Opacity);
  DrawEllipse(P1, P2, Opacity);
end;

procedure TCanvasHelper.FillDrawEllipse(const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  FillEllipse(X1, Y1, X2, Y2, Opacity);
  DrawEllipse(X1, Y1, X2, Y2, Opacity);
end;

procedure TCanvasHelper.FillDrawEllipseSize(const Left, Top, Width, Height: Single; const Opacity: Single = 1);
begin
  FillEllipseSize(Left, Top, Width, Height, Opacity);
  DrawEllipseSize(Left, Top, Width, Height, Opacity);
end;

procedure TCanvasHelper.FillDrawEllipseRad(const X0, Y0, RX, RY: Single; const Opacity: Single = 1);
begin
  FillEllipseRad(X0, Y0, RX, RY, Opacity);
  DrawEllipseRad(X0, Y0, RX, RY, Opacity);
end;

procedure TCanvasHelper.FillDrawEllipseRad(const CT: TPointF; const RX, RY: Single; const Opacity: Single = 1);
begin
  FillEllipseRad(CT, RX, RY, Opacity);
  DrawEllipseRad(CT, RX, RY, Opacity);
end;

procedure TCanvasHelper.FillDrawCircle(const X0, Y0, R: Single; const Opacity: Single = 1);
begin
  FillEllipseRad(X0, Y0, R, R, Opacity);
  DrawEllipseRad(X0, Y0, R, R, Opacity);
end;

procedure TCanvasHelper.FillDrawCircle(const CT: TPointF; const R: Single; const Opacity: Single = 1);
begin
  FillEllipseRad(CT, R, R, Opacity);
  DrawEllipseRad(CT, R, R, Opacity);
end;

procedure TCanvasHelper.FillDrawArc(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(Stroke, Fill, RT, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillDrawArc(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(Stroke, Fill, CT, RX, Ry, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillDrawArc(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(Stroke, Fill, PointF(X0, Y0), RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillDrawPie(const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(Stroke, Fill, RT, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillDrawPie(const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(Stroke, Fill, CT, RX, Ry, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillDrawPie(const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(Stroke, Fill, PointF(X0, Y0), RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillDrawPath(const PathData: TPathData; const Opacity: Single = 1);
begin
  FillPath(PathData, Opacity);
  DrawPath(PathData, Opacity);
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.Draw lines with Pen'}
procedure TCanvasHelper.DrawLine(Pen: TStrokeBrush; const P1, P2: TPointF; const Opacity: Single = 1);
begin
  DrawLine(P1, P2, Opacity, Pen);
end;

procedure TCanvasHelper.DrawLine(Pen: TStrokeBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  DrawLine(PointF(X1, Y1), PointF(X2, Y2), Opacity, Pen);
end;

{$IFDEF MSWINDOWS}
procedure TCanvasHelper.DrawLineSquareCap(Pen: TStrokeBrush; const P1, P2: TPointF; const Opacity: Single = 1);
var
 d, dx, dy: Float64;
begin
  d := ez.Distance(P1.X - P2.X, P1.Y - P2.Y);
  if d = 0
    then DrawLine(P1, P2, Opacity)
  else begin
    dx := (P2.X - P1.X) * (d + Pen.Thickness / 2) / d;
    dy := (P2.Y - P1.Y) * (d + Pen.Thickness / 2) / d;
    DrawLine(PointF(P1.X + dx, P1.Y + dy), PointF(P2.X - dx, P2.Y - dy), Opacity, Pen)
  end;
end;

procedure TCanvasHelper.DrawLineButtCap(Pen: TStrokeBrush; const P1, P2: TPointF; const Opacity: Single = 1);
begin
  DrawLine(P1, P2, Opacity, Pen);
end;
{$ENDIF}

{$IFDEF MacOS}
procedure TCanvasHelper.DrawLineSquareCap(Pen: TStrokeBrush; const P1, P2: TPointF; const Opacity: Single = 1);
begin
  DrawLine(P1, P2, Opacity, Pen);
end;

procedure TCanvasHelper.DrawLineButtCap(Pen: TStrokeBrush; const P1, P2: TPointF; const Opacity: Single = 1);
var
 d, dx, dy: Float64;
begin
  d := ez.Distance(P1.X - P2.X, P1.Y - P2.Y);
  if d = 0
    then DrawLine(P1, P2, Opacity)
  else begin
    dx := (P2.X - P1.X) * (d + Pen.Thickness / 2) / d;
    dy := (P2.Y - P1.Y) * (d + Pen.Thickness / 2) / d;
    DrawLine(PointF(P1.X - dx, P1.Y - dy), PointF(P2.X + dx, P2.Y + dy), Opacity, Pen)
  end;
end;
{$ENDIF}

procedure TCanvasHelper.DrawLineSquareCap(Pen: TStrokeBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  DrawLineSquareCap(Pen, PointF(X1, Y1), PointF(X2, Y2), Opacity);
end;

procedure TCanvasHelper.DrawLineButtCap(Pen: TStrokeBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  DrawLineButtCap(Pen, PointF(X1, Y1), PointF(X2, Y2), Opacity);
end;

procedure TCanvasHelper.DrawArc(Pen: TStrokeBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  DrawArc(RT.CenterPoint, PointF(RT.Width / 2, RT.Height / 2), StartAngle, SweepAngle, Opacity, Pen);
end;

procedure TCanvasHelper.DrawArc(Pen: TStrokeBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  DrawArc(CT, PointF(RX, RY), StartAngle, SweepAngle, Opacity, Pen);
end;

procedure TCanvasHelper.DrawArc(Pen: TStrokeBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  DrawArc(PointF(X0, Y0), PointF(RX, RY), StartAngle, SweepAngle, Opacity, Pen);
end;

procedure TCanvasHelper.DrawBezier(Pen: TStrokeBrush; const P1, P2, P3, P4: TPointF; const Opacity: Single = 1);
var
  Path: TPathData;
begin
  Path := TPathData.Create;
  try
    Path.AddBezier(P1, P2, P3, P4);
    DrawPath(Path, Opacity, Pen);
  finally
    Path.Free;
  end;
end;

procedure TCanvasHelper.DrawBezier(Pen: TStrokeBrush; const X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; const Opacity: Single = 1);
var
  Path: TPathData;
begin
  Path := TPathData.Create;
  try
    Path.AddBezier(X1, Y1, X2, Y2, X3, Y3, X4, Y4);
    DrawPath(Path, Opacity, Pen);
  finally
    Path.Free;
  end;
end;

procedure TCanvasHelper.DrawLines(Pen: TStrokeBrush; const Points: array of TPointF; const Opacity: Single = 1);
var
  Path: TPathData;
begin
  if Length(Points) = 0 then exit;
  Path := TPathData.Create;
  try
    Path.AddLines(Points);
    DrawPath(Path, Opacity, Pen);
  finally
    Path.Free;
  end;
end;

procedure TCanvasHelper.DrawBeziers(Pen: TStrokeBrush; const Points: array of TPointF; const Opacity: Single = 1);
var
  Path: TPathData;
begin
  if Length(Points) = 0 then exit;
  Path := TPathData.Create;
  try
    Path.AddBeziers(Points);
    DrawPath(Path, Opacity, Pen);
  finally
    Path.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.Draw closed shapes with Pen'}
procedure TCanvasHelper.DrawPolygon(Pen: TStrokeBrush; const Points: array of TPointF; const Opacity: Single = 1);
begin
  FillDrawPolygon(Pen, nil, Points, Opacity);
end;

procedure TCanvasHelper.DrawRect(Pen: TStrokeBrush; const RT: TRectF; const Opacity: Single = 1);
begin
  DrawRect(RT, Opacity, Pen);
end;

procedure TCanvasHelper.DrawRect(Pen: TStrokeBrush; const P1, P2: TPointF; const Opacity: Single = 1);
begin
  DrawRect(TRectF.Create(P1, P2), Opacity, Pen);
end;

procedure TCanvasHelper.DrawRect(Pen: TStrokeBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  DrawRect(TRectF.Create(X1, Y1, X2, Y2), Opacity, Pen);
end;

procedure TCanvasHelper.DrawRectSize(Pen: TStrokeBrush; const Left, Top, Width, Height: Single; const Opacity: Single = 1);
begin
  DrawRect(TRectF.Create(Left, Top, Left + Width, Top + Height), Opacity, Pen);
end;

procedure TCanvasHelper.DrawRoundRect(Pen: TStrokeBrush; const RT: TRectF; const RX, RY: Single; const Opacity: Single = 1);
begin
  DrawRect(RT, RX, RY, AllCorners, Opacity, Pen);
end;

procedure TCanvasHelper.DrawRoundRect(Pen: TStrokeBrush; const P1, P2: TPointF; const RX, RY: Single; const Opacity: Single = 1);
begin
  DrawRect(TRectF.Create(P1, P2), RX, RY, AllCorners, Opacity, Pen);
end;

procedure TCanvasHelper.DrawRoundRect(Pen: TStrokeBrush; const X1, Y1, X2, Y2, RX, RY: Single; const Opacity: Single = 1);
begin
  DrawRect(TRectF.Create(X1, Y1, X2, Y2), RX, RY, AllCorners, Opacity, Pen);
end;

procedure TCanvasHelper.DrawRoundRectSize(Pen: TStrokeBrush; const Left, Top, Width, Height, RX, RY: Single; const Opacity: Single = 1);
begin
  DrawRect(TRectF.Create(Left, Top, Left + Width, Top + Height), RX, RY, AllCorners, Opacity, Pen);
end;

procedure TCanvasHelper.DrawEllipse(Pen: TStrokeBrush; const RT: TRectF; const Opacity: Single = 1);
begin
  DrawEllipse(RT, Opacity, Pen);
end;

procedure TCanvasHelper.DrawEllipse(Pen: TStrokeBrush; const P1, P2: TPointF; const Opacity: Single = 1);
begin
  DrawEllipse(TRectF.Create(P1, P2), Opacity, Pen);
end;

procedure TCanvasHelper.DrawEllipse(Pen: TStrokeBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  DrawEllipse(TRectF.Create(X1, Y1, X2, Y2), Opacity, Pen);
end;

procedure TCanvasHelper.DrawEllipseSize(Pen: TStrokeBrush; const Left, Top, Width, Height: Single; const Opacity: Single = 1);
begin
  DrawEllipse(TRectF.Create(Left, Top, Left + Width, Top + Height), Opacity, Pen);
end;

procedure TCanvasHelper.DrawEllipseRad(Pen: TStrokeBrush; const X0, Y0, RX, RY: Single; const Opacity: Single = 1);
begin
  DrawEllipse(TRectF.Create(X0 - RX, Y0 - RY, X0 + RX, Y0 + RY), Opacity, Pen);
end;

procedure TCanvasHelper.DrawEllipseRad(Pen: TStrokeBrush; const CT: TPointF; const RX, RY: Single; const Opacity: Single = 1);
begin
  DrawEllipse(TRectF.Create(CT.X - RX, CT.Y - RY, CT.X + RX, CT.Y + RY), Opacity, Pen);
end;

procedure TCanvasHelper.DrawCircle(Pen: TStrokeBrush; const X0, Y0, R: Single; const Opacity: Single = 1);
begin
  DrawEllipse(TRectF.Create(X0 - R, Y0 - R, X0 + R, Y0 + R), Opacity, Pen);
end;

procedure TCanvasHelper.DrawCircle(Pen: TStrokeBrush; const CT: TPointF; const R: Single; const Opacity: Single = 1);
begin
  DrawEllipse(CT.X - R, CT.Y - R, CT.X + R, CT.Y + R);
end;

procedure TCanvasHelper.DrawClosedArc(Pen: TStrokeBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(Pen, nil, RT, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawClosedArc(Pen: TStrokeBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(Pen, nil, CT, RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawClosedArc(Pen: TStrokeBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(Pen, nil, PointF(X0, Y0), RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawPie(Pen: TStrokeBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(Pen, nil, RT, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawPie(Pen: TStrokeBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(Pen, nil, CT, RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawPie(Pen: TStrokeBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(Pen, nil, PointF(X0, Y0), RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.DrawPath(Pen: TStrokeBrush; const PathData: TPathData; const Opacity: Single = 1);
begin
  DrawPath(PathData, Opacity, Pen);
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.Fill closed shapes with Brush'}
procedure TCanvasHelper.FillPolygon(Brush: TBrush; const Points: array of TPointF; const Opacity: Single = 1);
begin
  FillDrawPolygon(nil, Brush, Points, Opacity);
end;

procedure TCanvasHelper.FillRect(Brush: TBrush; const RT: TRectF; const Opacity: Single = 1);
begin
  FillRect(RT, Opacity, Brush);
end;

procedure TCanvasHelper.FillRect(Brush: TBrush; const P1, P2: TPointF; const Opacity: Single = 1);
begin
  FillRect(TRectF.Create(P1, P2), Opacity);
end;

procedure TCanvasHelper.FillRect(Brush: TBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  FillRect(TRectF.Create(X1, Y1, X2, Y2), Opacity, Brush);
end;

procedure TCanvasHelper.FillRectSize(Brush: TBrush; const Left, Top, Width, Height: Single; const Opacity: Single = 1);
begin
  FillRect(TRectF.Create(Left, Top, Left + Width, Top + Height), Opacity, Brush);
end;

procedure TCanvasHelper.FillRoundRect(Brush: TBrush; const RT: TRectF; const RX, RY: Single; const Opacity: Single = 1);
begin
  FillRect(RT, RX, RY, AllCorners, Opacity, Brush);
end;

procedure TCanvasHelper.FillRoundRect(Brush: TBrush; const P1, P2: TPointF; const RX, RY: Single; const Opacity: Single = 1);
begin
  FillRect(TRectF.Create(P1, P2), RX, RY, AllCorners, Opacity, Brush);
end;

procedure TCanvasHelper.FillRoundRect(Brush: TBrush; const X1, Y1, X2, Y2, RX, RY: Single; const Opacity: Single = 1);
begin
  FillRect(TRectF.Create(X1, Y1, X2, Y2), RX, RY, AllCorners, Opacity, Brush);
end;

procedure TCanvasHelper.FillRoundRectSize(Brush: TBrush; const Left, Top, Width, Height, RX, RY: Single; const Opacity: Single = 1);
begin
  FillRect(TRectF.Create(Left, Top, Left + Width, Top + Height), RX, RY, AllCorners, Opacity, Brush);
end;

procedure TCanvasHelper.FillEllipse(Brush: TBrush; const RT: TRectF; const Opacity: Single = 1);
begin
  FillEllipse(RT, Opacity, Brush);
end;

procedure TCanvasHelper.FillEllipse(Brush: TBrush; const P1, P2: TPointF; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(P1, P2), Opacity, Brush);
end;

procedure TCanvasHelper.FillEllipse(Brush: TBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(X1, Y1, X2, Y2), Opacity, Brush);
end;

procedure TCanvasHelper.FillEllipseSize(Brush: TBrush; const Left, Top, Width, Height: Single; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(Left, Top, Left + Width, Top + Height), Opacity, Brush);
end;

procedure TCanvasHelper.FillEllipseRad(Brush: TBrush; const X0, Y0, RX, RY: Single; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(X0 - RX, Y0 - RY, X0 + RX, Y0 + RY), Opacity, Brush);
end;

procedure TCanvasHelper.FillEllipseRad(Brush: TBrush; const CT: TPointF; const RX, RY: Single; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(CT.X - RX, CT.Y - RY, CT.X + RX, CT.Y + RY), Opacity, Brush);
end;

procedure TCanvasHelper.FillCircle(Brush: TBrush; const X0, Y0, R: Single; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(X0 - R, Y0 - R, X0 + R, Y0 + R), Opacity, Brush);
end;

procedure TCanvasHelper.FillCircle(Brush: TBrush; const CT: TPointF; const R: Single; const Opacity: Single = 1);
begin
  FillEllipse(TRectF.Create(CT.X - R, CT.Y - R, CT.X + R, CT.Y + R), Opacity, Brush);
end;

procedure TCanvasHelper.FillArc(Brush: TBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(nil, Brush, RT, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillArc(Brush: TBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(nil, Brush, CT, RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillArc(Brush: TBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(nil, Brush, PointF(X0, Y0), RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillPie(Brush: TBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(nil, Brush, RT, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillPie(Brush: TBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(nil, Brush, CT, RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillPie(Brush: TBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(nil, Brush, PointF(X0, Y0), RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillPath(Brush: TBrush; const PathData: TPathData; const Opacity: Single = 1);
begin
  FillPath(PathData, Opacity, Brush);
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.Fill and Draw shapes with Pen and Brush'}
procedure TCanvasHelper.FillDrawPolygon(Pen: TStrokeBrush; Brush: TBrush; const Points: array of TPointF; const Opacity: Single = 1);
var
  Path: TPathData;
begin
  Path := TPathData.Create;
  try
    Path.AddPolygon(Points);
    if Assigned(Brush) then FillPath(Path, Opacity, Brush);
    if Assigned(Pen)   then DrawPath(Path, Opacity, Pen);
  finally
    Path.Free;
  end;
end;

procedure TCanvasHelper.FillDrawRect(Pen: TStrokeBrush; Brush: TBrush; const RT: TRectF; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillRect(RT, Opacity, Brush);
  if Assigned(Pen)   then FillRect(RT, Opacity, Pen);
end;

procedure TCanvasHelper.FillDrawRect(Pen: TStrokeBrush; Brush: TBrush; const P1, P2: TPointF; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillRect(Brush, P1, P2, Opacity);
  if Assigned(Pen)   then DrawRect(Pen,   P1, P2, Opacity);
end;

procedure TCanvasHelper.FillDrawRect(Pen: TStrokeBrush; Brush: TBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillRect(Brush, X1, Y1, X2, Y2, Opacity);
  if Assigned(Pen)   then DrawRect(Pen,   X1, Y1, X2, Y2, Opacity);
end;

procedure TCanvasHelper.FillDrawRectSize(Pen: TStrokeBrush; Brush: TBrush; const Left, Top, Width, Height: Single; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillRectSize(Brush, Left, Top, Width, Height, Opacity);
  if Assigned(Pen)   then DrawRectSize(Pen,   Left, Top, Width, Height, Opacity);
end;

procedure TCanvasHelper.FillDrawRoundRect(Pen: TStrokeBrush; Brush: TBrush; const RT: TRectF; const RX, RY: Single; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillRoundRect(Brush, RT, RX, RY, Opacity);
  if Assigned(Pen)   then DrawRoundRect(Pen,   RT, RX, RY, Opacity);
end;

procedure TCanvasHelper.FillDrawRoundRect(Pen: TStrokeBrush; Brush: TBrush; const P1, P2: TPointF; const RX, RY: Single; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillRoundRect(Brush, P1, P2, RX, RY, Opacity);
  if Assigned(Pen)   then DrawRoundRect(Pen,   P1, P2, RX, RY, Opacity);
end;

procedure TCanvasHelper.FillDrawRoundRect(Pen: TStrokeBrush; Brush: TBrush; const X1, Y1, X2, Y2, RX, RY: Single; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillRoundRect(Brush, X1, Y1, X2, Y2, RX, RY, Opacity);
  if Assigned(Pen)   then DrawRoundRect(Pen,   X1, Y1, X2, Y2, RX, RY, Opacity);
end;

procedure TCanvasHelper.FillDrawRoundRectSize(Pen: TStrokeBrush; Brush: TBrush; const Left, Top, Width, Height, RX, RY: Single; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillRoundRectSize(Brush, Left, Top, Width, Height, RX, RY, Opacity);
  if Assigned(Pen)   then DrawRoundRectSize(Pen,   Left, Top, Width, Height, RX, RY, Opacity);
end;

procedure TCanvasHelper.FillDrawEllipse(Pen: TStrokeBrush; Brush: TBrush; const RT: TRectF; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillEllipse(Brush, RT, Opacity);
  if Assigned(Pen)   then DrawEllipse(Pen,   RT, Opacity);
end;

procedure TCanvasHelper.FillDrawEllipse(Pen: TStrokeBrush; Brush: TBrush; const P1, P2: TPointF; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillEllipse(Brush, P1, P2, Opacity);
  if Assigned(Pen)   then DrawEllipse(Pen,   P1, P2, Opacity);
end;

procedure TCanvasHelper.FillDrawEllipse(Pen: TStrokeBrush; Brush: TBrush; const X1, Y1, X2, Y2: Single; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillEllipse(Brush, X1, Y1, X2, Y2, Opacity);
  if Assigned(Pen)   then DrawEllipse(Pen,   X1, Y1, X2, Y2, Opacity);
end;

procedure TCanvasHelper.FillDrawEllipseSize(Pen: TStrokeBrush; Brush: TBrush; const Left, Top, Width, Height: Single; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillEllipseSize(Brush, Left, Top, Width, Height, Opacity);
  if Assigned(Pen)   then DrawEllipseSize(Pen,   Left, Top, Width, Height, Opacity);
end;

procedure TCanvasHelper.FillDrawEllipseRad(Pen: TStrokeBrush; Brush: TBrush; const X0, Y0, RX, RY: Single; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillEllipseRad(Brush, X0, Y0, RX, RY, Opacity);
  if Assigned(Pen)   then DrawEllipseRad(Pen,   X0, Y0, RX, RY, Opacity);
end;

procedure TCanvasHelper.FillDrawEllipseRad(Pen: TStrokeBrush; Brush: TBrush; const CT: TPointF; const RX, RY: Single; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillEllipseRad(Brush, CT, RX, RY, Opacity);
  if Assigned(Pen)   then DrawEllipseRad(Pen,   CT, RX, RY, Opacity);
end;

procedure TCanvasHelper.FillDrawCircle(Pen: TStrokeBrush; Brush: TBrush; const X0, Y0, R: Single; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillEllipseRad(Brush, X0, Y0, R, R, Opacity);
  if Assigned(Pen)   then DrawEllipseRad(Pen,   X0, Y0, R, R, Opacity);
end;

procedure TCanvasHelper.FillDrawCircle(Pen: TStrokeBrush; Brush: TBrush; const CT: TPointF; const R: Single; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillEllipseRad(Brush, CT, R, R, Opacity);
  if Assigned(Pen)   then DrawEllipseRad(Pen,   CT, R, R, Opacity);
end;

procedure TCanvasHelper.FillDrawArc(Pen: TStrokeBrush; Brush: TBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(Pen, Brush, (RT.Right + RT.Left) / 2, (RT.Bottom + RT.Top) / 2,
                          (RT.Right - RT.Left) / 2, (RT.Bottom - RT.Top) / 2, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillDrawArc(Pen: TStrokeBrush; Brush: TBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
var
  Path: TPathData;
begin
  Path := TPathData.Create;
  try
    Path.AddArc(CT, RX, RY, StartAngle, SweepAngle);
    Path.MoveTo(CT.X + RX * Cos(StartAngle), CT.Y + RY - Sin(StartAngle));
    Path.LineTo(CT.X + RX * Cos(StartAngle + SweepAngle), CT.Y + RY - Sin(StartAngle + SweepAngle));
    if Assigned(Brush) then FillPath(Brush, Path, Opacity);
    if Assigned(Pen)   then DrawPath(Pen,   Path, Opacity);
  finally
    Path.Free;
  end;
end;

procedure TCanvasHelper.FillDrawArc(Pen: TStrokeBrush; Brush: TBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawArc(Pen, Brush, PointF(X0, Y0), RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillDrawPie(Pen: TStrokeBrush; Brush: TBrush; const RT: TRectF; const StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(Pen, Brush, (RT.Right + RT.Left) / 2, (RT.Bottom + RT.Top) / 2,
                          (RT.Right - RT.Left) / 2, (RT.Bottom - RT.Top) / 2, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillDrawPie(Pen: TStrokeBrush; Brush: TBrush; const CT: TPointF; const RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
var
  Path: TPathData;
begin
  Path := TPathData.Create;
  try
    Path.AddArc(CT, RX, RY, StartAngle, SweepAngle);
    Path.MoveTo(CT.X + RX * Cos(StartAngle), CT.Y + RY - Sin(StartAngle));
    Path.LineTo(CT);
    Path.LineTo(CT.X + RX * Cos(StartAngle + SweepAngle), CT.Y + RY - Sin(StartAngle + SweepAngle));
    if Assigned(Brush) then FillPath(Brush, Path, Opacity);
    if Assigned(Pen)   then DrawPath(Pen,   Path, Opacity);
  finally
    Path.Free;
  end;
end;

procedure TCanvasHelper.FillDrawPie(Pen: TStrokeBrush; Brush: TBrush; const X0, Y0, RX, RY, StartAngle, SweepAngle: Single; const Opacity: Single = 1);
begin
  FillDrawPie(Pen, Brush, PointF(X0, Y0), RX, RY, StartAngle, SweepAngle, Opacity);
end;

procedure TCanvasHelper.FillDrawPath(Pen: TStrokeBrush; Brush: TBrush; const PathData: TPathData; const Opacity: Single = 1);
begin
  if Assigned(Brush) then FillPath(PathData, Opacity, Brush);
  if Assigned(Pen)   then DrawPath(PathData, Opacity, Pen);
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.Measure Text'}
function TCanvasHelper.MeasureText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                      VAlign: TTextAlign = TTextAlign.Center; Flags: TFillTextFlags = []): TRectF;
begin
  MeasureText(Font, RT, Text, WordWrap, HAlign, VAlign, Flags);
end;

function TCanvasHelper.MeasureText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                      VAlign: TTextAlign = TTextAlign.Center; Flags: TFillTextFlags = []): TRectF;
var
  Layout: TTextLayout;
begin
  if Text.IsEmpty then
  begin
    Result.TopLeft := RT.TopLeft;
    Result.BottomRight := RT.TopLeft;
    Exit;
  end;

  Layout := TTextLayoutManager.TextLayoutByCanvas(Self.ClassType).Create(Self);
  try
    Layout.BeginUpdate;
    try
      Layout.TopLeft := RT.TopLeft;
      Layout.MaxSize := PointF(RT.Width, RT.Height);
      Layout.Text := Text;
      Layout.WordWrap := WordWrap;
      Layout.HorizontalAlign := HAlign;
      Layout.VerticalAlign := VAlign;
      Layout.Font := Font;
      Layout.RightToLeft := TFillTextFlag.RightToLeft in Flags;
    finally
      Layout.EndUpdate;
    end;
    Result := Layout.TextRect;
  finally
    FreeAndNil(Layout);
  end;
end;

function TCanvasHelper.TextExtent(const Text: string): TSizeF;
var
  R: TRectF;
begin
  R := RectF(0, 0, TextOutMaxSize, TextOutMaxSize);
  MeasureText(R, Text, False, [], TTextAlign.Leading, TTextAlign.Leading);
  Result.cx := R.Right;
  Result.cy := R.Bottom;
end;

function TCanvasHelper.TextExtent(const Text: string; const MaxWidth: Single): TSizeF;
var
  R: TRectF;
begin
  if MaxWidth >= 0
    then R := RectF(0, 0, MaxWidth, TextOutMaxSize)
    else R := RectF(0, 0, TextOutMaxSize, TextOutMaxSize);
  MeasureText(R, Text, True, [], TTextAlign.Leading, TTextAlign.Leading);
  Result.cx := R.Right;
  Result.cy := R.Bottom;
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.TextOut'}
procedure TCanvasHelper.TextOut(const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  TextOut(Font, Fill.Color, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.TextOut(const X, Y, MaxWidth: Single; const Text: string; const Opacity: Single = 1);
begin
  TextOut(Font, Fill.Color, X, Y, MaxWidth, Text, Opacity);
end;

procedure TCanvasHelper.TextOut(const X, Y: Single; const Text: string; HAlign, VAlign: TTextAlign; const Opacity: Single = 1);
begin
  TextOut(Font, Fill.Color, X, Y, Text, HAlign, VAlign, Opacity);
end;

procedure TCanvasHelper.TextOut(const X, Y, MaxWidth: Single; const Text: string; HAlign, VAlign: TTextAlign; const Opacity: Single = 1);
begin
  TextOut(Font, Fill.Color, X, Y, MaxWidth, Text, HAlign, VAlign, Opacity);
end;

procedure TCanvasHelper.TextOut(const RT: TRectF; const Text: string; WordWrap: Boolean;
                                HAlign: TTextAlign; const Opacity: Single = 1);
begin
  TextOut(Font, Fill.Color, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.TextOut(const RT: TRectF; const Text: string; WordWrap: Boolean;
                                HAlign: TTextAlign; VAlign: TTextAlign = TTextAlign.Center;
                                Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  TextOut(Font, Fill.Color, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;

procedure TCanvasHelper.TextOut(Font: TFont; const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  TextOut(Font, Fill.Color, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.TextOut(Font: TFont; const X, Y, MaxWidth: Single; const Text: string; const Opacity: Single = 1);
begin
  TextOut(Font, Fill.Color, X, Y, MaxWidth, Text, Opacity);
end;

procedure TCanvasHelper.TextOut(Font: TFont; const X, Y: Single; const Text: string; HAlign, VAlign: TTextAlign; const Opacity: Single = 1);
begin
  TextOut(Font, Fill.Color, X, Y, Text, HAlign, VAlign, Opacity);
end;

procedure TCanvasHelper.TextOut(Font: TFont; const X, Y, MaxWidth: Single; const Text: string; HAlign, VAlign: TTextAlign; const Opacity: Single = 1);
begin
  TextOut(Font, Fill.Color, X, Y, MaxWidth, Text, HAlign, VAlign, Opacity);
end;

procedure TCanvasHelper.TextOut(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean;
                                HAlign: TTextAlign; const Opacity: Single = 1);
begin
  TextOut(Font, Fill.Color, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.TextOut(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean;
                                HAlign: TTextAlign; VAlign: TTextAlign = TTextAlign.Center;
                                Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  TextOut(Font, Fill.Color, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;

procedure TCanvasHelper.TextOut(Color: TAlphaColor; const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  TextOut(Font, Color, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.TextOut(Color: TAlphaColor; const X, Y, MaxWidth: Single; const Text: string; const Opacity: Single = 1);
begin
  TextOut(Font, Color, X, Y, MaxWidth, Text, Opacity);
end;

procedure TCanvasHelper.TextOut(Color: TAlphaColor; const X, Y: Single; const Text: string; HAlign, VAlign: TTextAlign; const Opacity: Single = 1);
begin
  TextOut(Font, Color, X, Y, Text, HAlign, VAlign, Opacity);
end;

procedure TCanvasHelper.TextOut(Color: TAlphaColor; const X, Y, MaxWidth: Single; const Text: string; HAlign, VAlign: TTextAlign; const Opacity: Single = 1);
begin
  TextOut(Font, Color, X, Y, MaxWidth, Text, HAlign, VAlign, Opacity);
end;

procedure TCanvasHelper.TextOut(Color: TAlphaColor; const RT: TRectF; const Text: string; WordWrap: Boolean;
                                HAlign: TTextAlign; const Opacity: Single = 1);
begin
  TextOut(Font, Color, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.TextOut(Color: TAlphaColor; const RT: TRectF; const Text: string; WordWrap: Boolean;
                                HAlign: TTextAlign; VAlign: TTextAlign = TTextAlign.Center;
                                Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  TextOut(Font, Color, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;


procedure TCanvasHelper.TextOut(Font: TFont; Color: TAlphaColor; const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  TextOut(Font, Color, X, Y, Text, TTextAlign.Leading, TTextAlign.Center,  Opacity);
end;

procedure TCanvasHelper.TextOut(Font: TFont; Color: TAlphaColor; const X, Y, MaxWidth: Single; const Text: string; const Opacity: Single = 1);
begin
  TextOut(Font, Color, X, Y, MaxWidth, Text, TTextAlign.Leading, TTextAlign.Center,  Opacity);
end;

procedure TCanvasHelper.TextOut(Font: TFont; Color: TAlphaColor; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                  const Opacity: Single = 1);
begin
  TextOut(Font, Color, RT, Text, WordWrap, HAlign, TTextAlign.Center, [], Opacity);
end;

procedure TCanvasHelper.TextOut(Font: TFont; Color: TAlphaColor; const X, Y: Single; const Text: string; HAlign, VAlign: TTextAlign; const Opacity: Single = 1);
begin
  var Size := TextExtent(Text);
  var R: TRectF;
  case HAlign of
    TTextAlign.Leading: R.Left := X;
    TTextAlign.Center:  R.Left := X - Size.Width / 2;
    else                R.Left := X - Size.Width;
  end;
  case VAlign of
    TTextAlign.Leading: R.Top := Y;
    TTextAlign.Center:  R.Top := Y - Size.Height / 2;
    else                R.Top := Y - Size.Height;
  end;
  R.Right  := R.Left + Size.Width;
  R.Bottom := R.Top  + Size.Height;
  TextOut(Font, Color, R, Text, False, HAlign, VAlign, [], Opacity);
end;

procedure TCanvasHelper.TextOut(Font: TFont; Color: TAlphaColor; const X, Y, MaxWidth: Single; const Text: string; HAlign, VAlign: TTextAlign; const Opacity: Single = 1);
begin
  var Size := TextExtent(Text, MaxWidth);
  var R: TRectF;
  case HAlign of
    TTextAlign.Leading: R.Left := X;
    TTextAlign.Center:  R.Left := X - Size.Width / 2;
    else                R.Left := X - Size.Width;
  end;
  case VAlign of
    TTextAlign.Leading: R.Top := Y;
    TTextAlign.Center:  R.Top := Y - Size.Height / 2;
    else                R.Top := Y - Size.Height;
  end;
  R.Right  := R.Left + Size.Width;
  R.Bottom := R.Top  + Size.Height;
  TextOut(Font, Color, R, Text, False, HAlign, VAlign, [], Opacity);
end;

procedure TCanvasHelper.TextOut(Font: TFont; Color: TAlphaColor; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                  VAlign: TTextAlign = TTextAlign.Center; Flags: TFillTextFlags = []; const Opacity: Single = 1);
var
  Layout: TTextLayout;
begin
  Layout := TTextLayoutManager.TextLayoutByCanvas(Self.ClassType).Create(Self);
  try
    Layout.BeginUpdate;
    try
      Layout.TopLeft := RT.TopLeft;
      Layout.MaxSize := PointF(RT.Width, RT.Height);
      Layout.Text := Text;
      Layout.WordWrap := WordWrap;
      Layout.HorizontalAlign := HAlign;
      Layout.VerticalAlign := VAlign;
      Layout.RightToLeft := TFillTextFlag.RightToLeft in Flags;
      Layout.Opacity := Opacity;
      Layout.Color := Color;
      if Font = nil
        then Layout.Font := Self.Font
        else Layout.Font := Font;
    finally
      Layout.EndUpdate;
    end;
    Layout.RenderLayout(Self);
  finally
    FreeAndNil(Layout);
  end;
end;

procedure TCanvasHelper.TextOutLT(const X, Y, MaxWidth: Single; const Text: string; const Opacity: Single);
begin
  TextOut(X, Y, MaxWidth, Text, TTextAlign.Leading, TTextAlign.Leading, Opacity);
end;

procedure TCanvasHelper.TextOutLT(const X, Y: Single; const Text: string; const Opacity: Single);
begin
  TextOut(X, Y, Text, TTextAlign.Leading, TTextAlign.Leading, Opacity);
end;

procedure TCanvasHelper.TextOutLT(Color: TAlphaColor; const X, Y: Single; const Text: string;
  const Opacity: Single);
begin
  TextOut(Color, X, Y, Text, TTextAlign.Leading, TTextAlign.Leading, Opacity);
end;

procedure TCanvasHelper.TextOutLT(Color: TAlphaColor; const X, Y, MaxWidth: Single; const Text: string;
  const Opacity: Single);
begin
  TextOut(Color, X, Y, MaxWidth, Text, TTextAlign.Leading, TTextAlign.Leading, Opacity);
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.Draw Text with built-in pen/brush'}
procedure TCanvasHelper.DrawText(const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  FillDrawText(Stroke, nil, Font, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.DrawText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                   const Opacity: Single = 1);
begin
  FillDrawText(Stroke, nil, Font, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.DrawText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                   VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  FillDrawText(Stroke, nil, Font, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;

procedure TCanvasHelper.DrawText(Font: TFont; const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  FillDrawText(Stroke, nil, Font, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.DrawText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                   const Opacity: Single = 1);
begin
  FillDrawText(Stroke, nil, Font, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.DrawText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                   VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  FillDrawText(Stroke, nil, Font, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;

procedure TCanvasHelper.FillText(const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  FillDrawText(nil, Fill, Font, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.FillText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                   const Opacity: Single = 1);
begin
  FillDrawText(nil, Fill, Font, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.FillText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                   VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  FillDrawText(nil, Fill, Font, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;

procedure TCanvasHelper.FillText(Font: TFont; const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  FillDrawText(nil, Fill, Font, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.FillText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                   const Opacity: Single = 1);
begin
  FillDrawText(nil, Fill, Font, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.FillText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                   VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  FillDrawText(nil, Fill, Font, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;

procedure TCanvasHelper.FillDrawText(const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  FillDrawText(Stroke, Fill, Font, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.FillDrawText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       const Opacity: Single = 1);
begin
  FillDrawText(Stroke, Fill, Font, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.FillDrawText(const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  FillDrawText(Stroke, Fill, Font, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;

procedure TCanvasHelper.FillDrawText(Font: TFont; const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  FillDrawText(Stroke, Fill, Font, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.FillDrawText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       const Opacity: Single = 1);
begin
  FillDrawText(Stroke, Fill, Font, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.FillDrawText(Font: TFont; const RT: TRectF; const Text: string; WordWrap: Boolean; HAlign: TTextAlign;
                       VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  FillDrawText(Stroke, Fill, Font, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.Draw Text with spefice pen/brush'}
procedure TCanvasHelper.DrawText(Pen: TStrokeBrush; const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  FillDrawText(Pen, nil, Font, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.DrawText(Pen: TStrokeBrush; const RT: TRectF; const Text: string; WordWrap: Boolean;
            HAlign: TTextAlign; const Opacity: Single = 1);
begin
  FillDrawText(Pen, nil, Font, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.DrawText(Pen: TStrokeBrush; const RT: TRectF;const Text: string; WordWrap: Boolean;
            HAlign, VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  FillDrawText(Pen, nil, Font, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;

procedure TCanvasHelper.DrawText(Pen: TStrokeBrush; Font: TFont; const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  FillDrawText(Pen, nil, Font, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.DrawText(Pen: TStrokeBrush; Font: TFont; const RT: TRectF; const Text: string;
            WordWrap: Boolean; HAlign: TTextAlign; const Opacity: Single = 1);
begin
  FillDrawText(Pen, nil, Font, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.DrawText(Pen: TStrokeBrush; Font: TFont; const RT: TRectF; const Text: string;
            WordWrap: Boolean; HAlign, VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  FillDrawText(Pen, nil, Font, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;

procedure TCanvasHelper.FillText(Brush: TBrush; const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  FillDrawText(nil, Brush, Font, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.FillText(Brush: TBrush; const RT: TRectF; const Text: string; WordWrap: Boolean;
            HAlign: TTextAlign; const Opacity: Single = 1);
begin
  FillDrawText(nil, Brush, Font, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.FillText(Brush: TBrush; const RT: TRectF;const Text: string; WordWrap: Boolean;
            HAlign, VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  FillDrawText(nil, Brush, Font, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;

procedure TCanvasHelper.FillText(Brush: TBrush; Font: TFont; const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  FillDrawText(nil, Brush, Font, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.FillText(Brush: TBrush; Font: TFont; const RT: TRectF; const Text: string;
            WordWrap: Boolean; HAlign: TTextAlign; const Opacity: Single = 1);
begin
  FillDrawText(nil, Brush, Font, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.FillText(Brush: TBrush; Font: TFont; const RT: TRectF; const Text: string;
            WordWrap: Boolean; HAlign, VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  FillDrawText(nil, Brush, Font, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;

procedure TCanvasHelper.FillDrawText(Pen: TStrokeBrush; Brush: TBrush; const X, Y: Single; const Text: string; const Opacity: Single = 1);
begin
  FillDrawText(Pen, Brush, Font, X, Y, Text, Opacity);
end;

procedure TCanvasHelper.FillDrawText(Pen: TStrokeBrush; Brush: TBrush; const RT: TRectF; const Text: string;
            WordWrap: Boolean; HAlign: TTextAlign; const Opacity: Single = 1);
begin
  FillDrawText(Pen, Brush, Font, RT, Text, WordWrap, HAlign, Opacity);
end;

procedure TCanvasHelper.FillDrawText(Pen: TStrokeBrush; Brush: TBrush; const RT: TRectF;const Text: string;
            WordWrap: Boolean; HAlign, VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);
begin
  FillDrawText(Pen, Brush, Font, RT, Text, WordWrap, HAlign, VAlign, Flags, Opacity);
end;

procedure TCanvasHelper.FillDrawText(Pen: TStrokeBrush; Brush: TBrush; Font: TFont; const X, Y: Single;
            const Text: string; const Opacity: Single = 1);
begin
  FillDrawText(Pen, Brush, Font, TRectF.Create(X, Y, X + TextOutMaxSize, Y + TextOutMaxSize), Text, False, TTextAlign.Leading, TTextAlign.Leading, [], Opacity);
end;

procedure TCanvasHelper.FillDrawText(Pen: TStrokeBrush; Brush: TBrush; Font: TFont; const RT: TRectF;
            const Text: string; WordWrap: Boolean; HAlign: TTextAlign; const Opacity: Single = 1);
begin
  FillDrawText(Pen, Brush, Font, RT, Text, WordWrap, HAlign, TTextAlign.Center, [], Opacity);
end;

procedure TCanvasHelper.FillDrawText(Pen: TStrokeBrush; Brush: TBrush; Font: TFont; const RT: TRectF;
            const Text: string; WordWrap: Boolean; HAlign, VAlign: TTextAlign; Flags: TFillTextFlags = []; const Opacity: Single = 1);
var
  Layout: TTextLayout;
  Path: TPathData;
begin
  Layout := TTextLayoutManager.TextLayoutByCanvas(Self.ClassType).Create(Self);
  try
    Layout.BeginUpdate;
    try
      Layout.TopLeft := RT.TopLeft;
      Layout.MaxSize := PointF(RT.Width, RT.Height);
      Layout.Text := Text;
      Layout.WordWrap := WordWrap;
      Layout.HorizontalAlign := HAlign;
      Layout.VerticalAlign := VAlign;
      Layout.RightToLeft := TFillTextFlag.RightToLeft in Flags;
      if Font = nil
        then Layout.Font := Self.Font
        else Layout.Font := Font;
    finally
      Layout.EndUpdate;
    end;
    Path := TPathData.Create;
    try
      TextLayoutToPath(Layout, Path);
      if Assigned(Brush) then FillPath(Path, Opacity, Brush);
      if Assigned(Pen)   then DrawPath(Path, Opacity, Pen);
    finally
      Path.Free;
    end;
  finally
    Layout.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TCanvasHelper.Draw Shape'}
procedure TCanvasHelper.DrawShape(const PT: TPointF; Shape: TSimpleShape;
                    const OuterSize: Single; const RelSize: Single; const Opacity: Single);
begin
  DrawShape(Stroke, Fill, PT.X, PT.Y, Shape, OuterSize, RelSize, Opacity);
end;

procedure TCanvasHelper.DrawShape(Pen: TStrokeBrush; const PT: TPointF; Shape: TSimpleShape;
                    const OuterSize: Single; const RelSize: Single; const Opacity: Single);
begin
  DrawShape(Pen, Fill, PT.X, PT.Y, Shape, OuterSize, RelSize, Opacity);
end;

procedure TCanvasHelper.DrawShape(Brush: TBrush; const PT: TPointF; Shape: TSimpleShape;
                    const OuterSize: Single; const RelSize: Single; const Opacity: Single);
begin
  DrawShape(Stroke, Brush, PT.X, PT.Y, Shape, OuterSize, RelSize, Opacity);
end;

procedure TCanvasHelper.DrawShape(Pen: TStrokeBrush; Brush: TBrush; const PT: TPointF; Shape: TSimpleShape;
                    const OuterSize: Single; const RelSize: Single; const Opacity: Single);
begin
  DrawShape(Pen, Brush, PT.X, PT.Y, Shape, OuterSize, RelSize, Opacity);
end;

procedure TCanvasHelper.DrawShape(const X, Y: Single; Shape: TSimpleShape;
                    const OuterSize: Single; const RelSize: Single; const Opacity: Single);
begin
  DrawShape(Stroke, Fill, X, Y, Shape, OuterSize, RelSize, Opacity);
end;

procedure TCanvasHelper.DrawShape(Pen: TStrokeBrush; const X, Y: Single; Shape: TSimpleShape;
                    const OuterSize: Single; const RelSize: Single; const Opacity: Single);
begin
  DrawShape(Pen, Fill, X, Y, Shape, OuterSize, RelSize, Opacity);
end;

procedure TCanvasHelper.DrawShape(Brush: TBrush; const X, Y: Single; Shape: TSimpleShape;
                    const OuterSize: Single; const RelSize: Single; const Opacity: Single);
begin
  DrawShape(Stroke, Brush, X, Y, Shape, OuterSize, RelSize, Opacity);
end;

procedure TCanvasHelper.DrawShape(Pen: TStrokeBrush; Brush: TBrush; const X, Y: Single; Shape: TSimpleShape;
                    const OuterSize: Single; const RelSize: Single; const Opacity: Single);
var
  Path: TPathData;

  procedure AddRegular(nSide: NInt; const Degree: FloatEx);
  begin
    Path.AddPolygon(TPolygon.RegularPolygonDeg(nSide, X, Y, OuterSize, OuterSize, Degree));
    if (RelSize < 1) and (RelSize > 0) then
      Path.AddPolygon(TPolygon.RegularPolygonDeg(nSide, X, Y, OuterSize * RelSize, OuterSize * RelSize, Degree));
  end;

  procedure AddStar(nPoint: NInt);
  begin
    Path.AddPolygon(TPolygon.StarDeg(nPoint, X, Y, OuterSize, -90));
    if (RelSize < 1) and (RelSize > 0) then
      Path.AddPolygon(TPolygon.StarDeg(nPoint, X, Y, OuterSize * RelSize, -90));
  end;

  function CompressSize: TSizeF;
  begin
    if RelSize >= 1
      then Result := TSizeF.Create(0, OuterSize)
    else if RelSize >= 0
      then Result := TSizeF.Create(OuterSize * (1 - RelSize), OuterSize)
    else if RelSize > -1
      then Result := TSizeF.Create(OuterSize, OuterSize * (1 - RelSize))
      else Result := TSizeF.Create(OuterSize, 0);
  end;

  function Thinkness: FloatEx;
  begin
    Result := OuterSize * ez.Min(0.8, ez.Max(0, RelSize + 0.2));
  end;

  function RoundRad: FloatEx;
  begin
    Result := OuterSize * ez.Min(1, ez.Max(0, RelSize + 0.2));
  end;
begin
  Path := TPathData.Create;
  try
    case Shape of
      TSimpleShape.Circle:
        begin
          Path.AddCircle(X, Y, OuterSize);
          if (RelSize < 1) and (RelSize > 0) then
            Path.AddCircle(X, Y, OuterSize * RelSize);
        end;
      TSimpleShape.Triangle:      AddRegular(3, -90);
      TSimpleShape.LeftTriangle:  AddRegular(3, 0);
      TSimpleShape.DownTriangle:  AddRegular(3, 90);
      TSimpleShape.RightTriangle: AddRegular(3, 180);
      TSimpleShape.Square:        AddRegular(4, -45);
      TSimpleShape.Diamond:       AddRegular(4, 0);
      TSimpleShape.Pentagon:      AddRegular(5, -90);
      TSimpleShape.PentagonDown:  AddRegular(5, 90);
      TSimpleShape.Hexagon:       AddRegular(6, -90);
      TSimpleShape.HexagonH:      AddRegular(6, 0);
      TSimpleShape.Octagon:       AddRegular(8, -90);
      TSimpleShape.OctagonH:      AddRegular(8, 0);
      TSimpleShape.Star4:         AddStar(4);
      TSimpleShape.Star5:         AddStar(5);
      TSimpleShape.Star6:         AddStar(6);
      TSimpleShape.Star8:         AddStar(8);
      TSimpleShape.Ellipse:       with CompressSize do Path.AddEllipse(X, Y, cx, cy);
      TSimpleShape.Rectangle:     with CompressSize do Path.AddRectangle(X, Y, cx, cy);
      TSimpleShape.Diamond2:      with CompressSize do Path.AddPolygon(TPolygon.Diamond(X, Y, cx, cy));
      TSimpleShape.X:             Path.AddPolygon(TPolygon.Cross(X, Y, OuterSize, OuterSize, Thinkness));
      TSimpleShape.Plus:          Path.AddPolygon(TPolygon.Plus(X, Y, OuterSize, OuterSize,Thinkness, Thinkness));
      TSimpleShape.RoundSquare:   Path.AddRoundRectangle(X - OuterSize, Y - OuterSize, X + OuterSize, Y - OuterSize, RoundRad, RoundRad);
      TSimpleShape.Sun:
        begin
          Path.AddCircle(X, Y, OuterSize * RelSize);
          var Step := Constant32.Two_Pi / 8;
          var InnerSize := OuterSize + (0.8 + 0.2 * RelSize);
          for var i := 0 to 7 do
            Path.AddLine(X + OuterSize * Cos(Step * i), Y + OuterSize * Sin(Step * i),
                         X + InnerSize * Cos(Step * i), Y + InnerSize * Sin(Step * i));
        end;
    end;
    FillDrawPath(Pen, Brush, Path, Opacity);
  finally
    Path.Free;
  end;
end;
{$ENDREGION}

end.
