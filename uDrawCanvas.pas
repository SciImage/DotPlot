unit uDrawCanvas;

{$I wc.Base.inc}

interface

uses
  System.Types, System.UITypes,
  FMX.Types, FMX.Graphics,
  wc.Types, wc.Base,
  uDataSet, uPlotSettings, uDrawing;

procedure DrawTo(const Data: TGroupDataSets; const Settings: TPlotSettings; Bmp: TBitmap; FillColor: TAlphaColor); overload;
procedure DrawTo(const Data: TGroupDataSets; const Settings: TPlotSettings; Bmp: TBitmap; FillColor: TAlphaColor; Scale: Float64); overload;

implementation

uses
  FMX.Platform,
  wc.Math, wc.Graphics.FMX;

function ScreenScaleFactor: Float64;
var
  ScreenService: IFMXScreenService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService))
    then Result := ScreenService.GetScreenScale
    else Result := 1;
end;

procedure DrawTo(const Data: TGroupDataSets; const Settings: TPlotSettings; Bmp: TBitmap; FillColor: TAlphaColor); overload;
begin
  DrawTo(Data, Settings, Bmp, FillColor, ScreenScaleFactor);
end;

procedure DrawTo(const Data: TGroupDataSets; const Settings: TPlotSettings; Bmp: TBitmap; FillColor: TAlphaColor; Scale: Float64);
const
  TextYOffset = 0.1;

var
  Canvas: TCanvas;
  Elements: TPlotElements;
  pElm: ^TPlotElement;
  x, y, Size, SqSize: Float32;
  sg, i: NInt;
  elmType: TPlotElementType;

  procedure DrawLine(const X1, Y1, X2, Y2: Float32; CorrectHLine: Boolean);
  begin
    if CorrectHLine
      then Canvas.DrawLineButtCap(X1, Y1, X2, Y2, 1)
      else Canvas.DrawLineSquareCap(X1, Y1, X2, Y2, 1)
  end;

  procedure DrawBox(R: TRectF; FillColor: TAlphaColor);
  begin
   { if R.Left < R.Right then
    begin
      R.Left  := R.Left  + Canvas.Stroke.Thickness / 2;
      R.Right := R.Right - Canvas.Stroke.Thickness / 2;
    end else
    begin
      R.Left  := R.Left  - Canvas.Stroke.Thickness / 2;
      R.Right := R.Right + Canvas.Stroke.Thickness / 2;
    end;
    }
    if FillColor <> NullColor then
      Canvas.FillRect(R, 1);
    Canvas.DrawRect(R, 1);
  end;

begin
  Elements.DrawWithData(Data, Settings);
  Bmp.BitmapScale := Scale;
  Bmp.SetSize(Round(Settings.Width * Scale), Round(Settings.Height * Scale));
  Canvas := Bmp.Canvas;

  Canvas.BeginScene;
  try
    Canvas.Clear(FillColor);
    Canvas.Stroke.Cap       := TStrokeCap.Flat;
    Canvas.Stroke.Join      := TStrokeJoin.Miter;
    sg := -9999999;
    elmType := TPlotElementType.Line;
    for i := 0 to Elements.Count - 1 do
    begin
      pElm := @Elements.Elements[i];
      if pElm^.ElementType = TPlotElementType.GroupBegin then continue;
      if pElm^.ElementType = TPlotElementType.GroupEnd then continue;
      if (pElm^.Subgroup <> sg) or (elmType <> pElm^.ElementType) then
      begin
        sg      := pElm^.Subgroup;
        elmType := pElm^.ElementType;
        if sg >= 0 then
        begin
          case elmType of
            TPlotElementType.Line:
              begin
                Canvas.Stroke.Thickness := Settings.SymbolLineWidth;
                Canvas.Stroke.Color     := Settings.GetSymbolColor(sg);
              end;
            TPlotElementType.ErrorBar:
              begin
                Canvas.Stroke.Thickness := Settings.ErrorBarLineWidth;
                Canvas.Stroke.Color     := Settings.GetErrorBarColor(sg);
              end;
            TPlotElementType.Point:
              begin
                Canvas.Stroke.Thickness := Settings.SymbolLineWidth;
                Canvas.Stroke.Color     := Settings.GetSymbolColor(sg);
                Canvas.Fill.Kind        := TBrushKind.Solid;
                Canvas.Fill.Color       := Settings.GetSymbolFill(sg);
              end;
            TPlotElementType.Box:
              begin
                Canvas.Stroke.Thickness := Settings.ColumnLineWidth;
                Canvas.Stroke.Color     := Settings.GetColumnLineColor(sg);
                if Settings.UseGradient then
                begin
                  Canvas.Fill.Kind := TBrushKind.Gradient;
                  Canvas.Fill.Gradient.Style := TGradientStyle.Linear;
                  Canvas.Fill.Gradient.StartPosition.Point := PointF(0, 0);
                  Canvas.Fill.Gradient.StopPosition.Point  := PointF(0, 1);
                  Canvas.Fill.Gradient.Color  := Settings.GetColFillColorOfGradient(sg, True);
                  Canvas.Fill.Gradient.Color1 := Settings.GetColFillColorOfGradient(sg, False);
                end else
                begin
                  Canvas.Fill.Kind      := TBrushKind.Solid;
                  Canvas.Fill.Color     := Settings.GetColumnFill(sg);
                end;
              end;
          end;
        end else if sg = TPlotElement.Axis then
        begin
          Canvas.Stroke.Thickness := Settings.AxisLineWidth;
          Canvas.Stroke.Color     := Settings.AxisLineColor;
          Canvas.Fill.Color       := NullColor;
        end else if sg = TPlotElement.Tick then
        begin
          Canvas.Stroke.Thickness := Settings.TickLineWidth;
          Canvas.Stroke.Color     := Settings.TickLineColor;
          Canvas.Fill.Color       := NullColor;
        end else if sg = TPlotElement.Grid then
        begin
          Canvas.Stroke.Thickness := Settings.GridLineWidth;
          Canvas.Stroke.Color     := Settings.GridLineColor;
          Canvas.Fill.Color       := NullColor;
        end;
      end;

      case pElm^.ElementType of
        TPlotElementType.Line, TPlotElementType.ErrorBar:
          DrawLine(pElm^.X1, pElm^.Y1, pElm^.X2, pElm^.Y2, sg >= 0);
        TPlotElementType.Box:
          begin
            DrawBox(pElm^.Rect, Settings.GetColumnFill(sg));
          end;
        TPlotElementType.Point:
          if sg >= 0 then
          begin
            x := pElm^.X1;
            y := pElm^.Y1;
            Size := Settings.Subgroups[sg].SymbolSize / 2;
            var SameBorder := Settings.GetSymbolColor(sg) = Settings.GetSymbolFill(sg);
            var FillSize := ez.IfThen<Float32>(SameBorder, Size + Settings.SymbolLineWidth / 2, Size);
            case Settings.Subgroups[sg].Symbol of
              TSymbol.Circle:
                begin
                  if Canvas.Fill.Color <> NullColor then
                    Canvas.FillEllipse(RectF(x - FillSize, y - FillSize, x + FillSize, y + FillSize), 1);
                  if not SameBorder then
                    Canvas.DrawEllipse(RectF(x - Size, y - size, x + size, y + Size), 1);
                end;
              TSymbol.Square:
                begin
                  SqSize := FillSize * RectCorrection;
                  if Canvas.Fill.Color <> NullColor then
                    Canvas.FillRect(RectF(x - SqSize, y - SqSize, x + SqSize, y + SqSize), 1);
                  SqSize := Size * RectCorrection;
                  if not SameBorder then
                    Canvas.DrawRect(RectF(x - SqSize, y - SqSize, x + SqSize, y + SqSize), 1);
                end;
              TSymbol.Diamond:
                begin
                  if Canvas.Fill.Color <> NullColor then
                    Canvas.FillPolygon(TPlotElements.MakePolygon(x, y, FillSize, 4), 1);
                  if not SameBorder then
                    Canvas.DrawPolygon(TPlotElements.MakePolygon(x, y, Size * Constant32.Half_Sqrt_2, 4), 1);
                end;
              TSymbol.Triangle:
                begin
                  if Canvas.Fill.Color <> NullColor then
                    Canvas.FillPolygon(TPlotElements.MakePolygon(x, y, FillSize, 3), 1);
                  if not SameBorder then
                    Canvas.DrawPolygon(TPlotElements.MakePolygon(x, y, Size * Constant32.Half_Sqrt_2, 3), 1);
                end;
              TSymbol.DownTriangle:
                begin
                  if Canvas.Fill.Color <> NullColor then
                    Canvas.FillPolygon(TPlotElements.MakePolygon(x, y, FillSize, 3, 180), 1);
                  if not SameBorder then
                    Canvas.DrawPolygon(TPlotElements.MakePolygon(x, y, Size * Constant32.Half_Sqrt_2, 3,  180), 1);
                end;
            end;
          end;
        TPlotElementType.Text:
          begin
            Canvas.Font.Family := Settings.Font;
            Canvas.Font.Size   := Settings.FontSize;
            var HAlign, VAlign: TTextAlign;
            if sg = TPlotElement.Tick then
            begin
              HAlign := TTextAlign.Trailing;
              VAlign := TTextAlign.Center;
            end else
            begin
              HAlign := TTextAlign.Center;
              VAlign := TTextAlign.Leading;
            end;
            Canvas.TextOut(Settings.TickLineColor, pElm^.TextX, pElm^.TextY - Settings.FontSize * TextYOffset, pElm^.Text, HAlign, VAlign);
          end;
      end;
    end;
  finally
    Canvas.EndScene;
  end;
end;
{$ENDREGION}

end.
