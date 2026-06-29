unit uDrawing;

{$I wc.Base.inc}

interface

uses
  System.Types, System.Math.Vectors,
  FMX.TextLayout,
  wc.Types, wc.Base,
  uDataSet, uPlotSettings;

type
  {$REGION 'TPlotElements'}
  TPlotElementType = (GroupBegin, GroupEnd, Line, ErrorBar, Point, Box, Text);
  TPlotElement = record
    const Axis = -1;
    const Tick = -2;
    const Grid = -3;
  public
    ElementType: TPlotElementType;
    Subgroup: NInt;                     // -1: Axis; -2: Tick marks; -3: Grids;
    Text: string;
    case Integer of
      0: (X1, Y1, X2, Y2: Float32);             // Line
      1: (CX, CY, R: Float32);                  // Point
      2: (TopLeft, BottomRight: TPointF);       // Rect
      3: (Rect: TRectF);                        // Rect
      4: (TextX, TextY: Float32);               // Text
  end;
  TPlotElements = record
    Elements: array of TPlotElement;

    function Count: NInt;                      inline;
    procedure Clear;                            inline;
    procedure AddLine(const X1, Y1, X2, Y2: Float32; Subgroup: NInt);
    procedure AddErrorBar(const X1, Y1, X2, Y2: Float32; Subgroup: NInt);
    procedure AddPoint(const X, Y: Float32; Subgroup: NInt);
    procedure AddText(const X, Y: Float32; const Text: string; Subgroup: NInt);
    procedure AddBox(const X1, Y1, X2, Y2: Float32; Subgroup: NInt);
    procedure AddGroup(Subgroup: NInt);
    procedure EndGroup(Subgroup: NInt);

    class function MakePolygon(const x, y, r: Float32; n: NInt; const StartDegree: Float64 = 0): System.Math.Vectors.TPolygon; static;
    class function GetLabelWidth(const Settings: TPlotSettings): NInt; static; // to make the number looks better in svg, use NInt instaed of float

    procedure DrawWithData(const Data: TGroupDataSets; const Settings: TPlotSettings);
  end;
  {$ENDREGION}

const
  // The area of a circle = = 3.1416 r^2, an equivalent square has a side of s = 0.8862 * 2r (s^2 = 3.1414 r^2)
  // Area of inscribed N-polygon = N * r^2 * Sin(2pi/N) / 2; a factor of Sqrt(2pi/N / Sin(2pi/N))
  // N=3 --> 1.5551; N=4 --> 1.2533
  RectCorrection     = 0.85;       // This is smaller because the line width has significant impact on the area, still trying to fix it

implementation

uses
  System.SysUtils, System.Math,
  wc.Math;

{$REGION 'TPlotElements class function'}
class function TPlotElements.MakePolygon(const x, y, r: Float32; n: NInt; const StartDegree: Float64 = 0): System.Math.Vectors.TPolygon;
begin
  var An   := 2 * pi / n;
  var Ast  := pi * StartDegree / 180;
  var Correction := Sqrt(Constant64.Two_Pi / N / Sin(Constant64.Two_Pi / N)); // This gives the polygon exact size as a circle
  Correction := (1 + Correction) / 2;                   // Polygon with exact same area looks larger than a circle, make it smaller
  SetLength(Result, n + 1);
  for var i := 0 to n do
  begin
    Result[i].X := x + r * Correction * Sin(Ast + An * i);
    Result[i].Y := y - r * Correction * Cos(Ast + An * i);
  end;
end;

class function TPlotElements.GetLabelWidth(const Settings: TPlotSettings): NInt;
var
  y: Float64;
begin
  if not Settings.DrawLabels then Exit(0);

  var MaxWidth: Float32 := 0;
  var Layout := TTextLayoutManager.DefaultTextLayout.Create;
  var Digits := ez.Min(Numbers.GetLastPrecisionDigits(Settings.LowY),
                   Numbers.GetLastPrecisionDigits(Settings.HighY),
                   Numbers.GetLastPrecisionDigits(Settings.YSteps));
  try
    Layout.Font.Family := Settings.Font;
    Layout.WordWrap := False;
    Layout.Font.Size := Settings.FontSize;

    var d := (Settings.HighY - Settings.LowY) * 0.001;
    y := Trunc(Settings.LowY / Settings.YSteps) * Settings.YSteps;
    if (y > Settings.LowY) and (Y - Settings.YSteps > Settings.LowY - d)
      then Y := Y - Settings.YSteps;

    while y <= Settings.HighY + d do
    begin
      if Digits >= 0
        then Layout.Text := IntToStr(Round(y))
        else if SimpleRoundTo(y, Digits) = 0
          then Layout.Text := '0'
          else Layout.Text := Format('%.*f', [-Digits, SimpleRoundTo(y, Digits)]);
      ez.ToLarger(MaxWidth, Layout.TextWidth);
      y := y + Settings.YSteps;
    end;
    if MaxWidth = 0
      then Result := 0
      else Result := Round(MaxWidth + Settings.LabelGap);
  finally
    Layout.Free;
  end;
end;
{$ENDREGION}

{$REGION 'TPlotElements'}
function TPlotElements.Count: NInt;
begin
  Result := System.Length(Elements);
end;

procedure TPlotElements.Clear;
begin
  Elements := nil;
end;

procedure TPlotElements.AddLine(const X1, Y1, X2, Y2: Float32; Subgroup: NInt);
var
  i: NInt;
begin
  i := Count;
  SetLength(Elements, i + 1);
  Elements[i].ElementType := TPlotElementType.Line;
  Elements[i].X1 := X1;
  Elements[i].Y1 := Y1;
  Elements[i].X2 := X2;
  Elements[i].Y2 := Y2;
  Elements[i].Subgroup := Subgroup;
end;

procedure TPlotElements.AddErrorBar(const X1, Y1, X2, Y2: Float32; Subgroup: NInt);
var
  i: NInt;
begin
  i := Count;
  SetLength(Elements, i + 1);
  Elements[i].ElementType := TPlotElementType.ErrorBar;
  Elements[i].X1 := X1;
  Elements[i].Y1 := Y1;
  Elements[i].X2 := X2;
  Elements[i].Y2 := Y2;
  Elements[i].Subgroup := Subgroup;
end;

procedure TPlotElements.AddGroup(Subgroup: NInt);
var
  i: NInt;
begin
  i := Count;
  SetLength(Elements, i + 1);
  Elements[i].ElementType := TPlotElementType.GroupBegin;
  Elements[i].Subgroup := Subgroup;
end;

procedure TPlotElements.EndGroup(Subgroup: NInt);
var
  i: NInt;
begin
  i := Count;
  SetLength(Elements, i + 1);
  Elements[i].ElementType := TPlotElementType.GroupEnd;
  Elements[i].Subgroup := Subgroup;
end;

procedure TPlotElements.AddPoint(const X, Y: Float32; Subgroup: NInt);
var
  i: NInt;
begin
  i := Count;
  SetLength(Elements, i + 1);
  Elements[i].ElementType := TPlotElementType.Point;
  Elements[i].CX := X;
  Elements[i].CY := Y;
  Elements[i].Subgroup := Subgroup;
end;

procedure TPlotElements.AddText(const X, Y: Float32; const Text: string; Subgroup: NInt);
var
  i: NInt;
begin
  i := Count;
  SetLength(Elements, i + 1);
  Elements[i].ElementType := TPlotElementType.Text;
  Elements[i].TextX := X;
  Elements[i].TextY := Y;
  Elements[i].Text := Text;
  Elements[i].Subgroup := Subgroup;
end;

procedure TPlotElements.AddBox(const X1, Y1, X2, Y2: Float32; Subgroup: NInt);
var
  i: NInt;
begin
  i := Count;
  SetLength(Elements, i + 1);
  Elements[i].ElementType := TPlotElementType.Box;
  Elements[i].X1 := X1;
  Elements[i].Y1 := Y1;
  Elements[i].X2 := X2;
  Elements[i].Y2 := Y2;
  Elements[i].Subgroup := Subgroup;
end;
{$ENDREGION}

{$REGION 'Data to elements'}
procedure TPlotElements.DrawWithData(const Data: TGroupDataSets; const Settings: TPlotSettings);
var
  LowY, HighY, YSteps, YRatio, PlotAreaHeight: Float64;

  function Yof(const Y: Float64): Float64;
  begin
    Result := Settings.Margin + (HighY - Y) * YRatio;
  end;

  function IsYInRange(const Y: Float64): Boolean;
  // 0.01 is error
  begin
    var Error := PlotAreaHeight * 0.001;
    Result := (Y > Settings.Margin - Error) and (Y < Settings.Margin + PlotAreaHeight + Error);
  end;

  procedure DrawSubgroup(Datasets: TSubgroupDataSets; Left, Width, maxWidth: Float64);
    function GetPositions(const Data: TFloat64s; const DisSq: Float64): TPointFs;
    var
      n, i, j, LastMiddleN: NInt;
      Good: Boolean;
      x, y: Float64;
    begin
      SetLength(Result, Length(Data));
      LastMiddleN := 0;
      for n := 0 to Length(Data) - 1 do
      begin
        y := Yof(Data[n]);
        Result[n].Y := y;
        i := 0;
        repeat
          Good := True;
          for j := LastMiddleN to n - 1 do
            if ez.DistanceSquare(Result[j].X - i, Result[j].Y - y) < DisSq then
            begin
              Good := False;
              Break;
            end;
          if Good then
          begin
            Result[n].X := i;
            if i = 0 then
            begin
              if n > LastMiddleN then
              begin
                x := 0;
                var min := Result[LastMiddleN].X;
                var max := min;
                for j := LastMiddleN to n - 1 do
                begin
                  x := x + Result[j].X;
                  ez.ToSmaller(min, Result[j].X);
                  ez.ToLarger(max, Result[j].X);
                end;
                x := x / (n - LastMiddleN);
                var Scale := 1.0;
                if (max - min) > maxWidth
                  then Scale := maxWidth / (max - min);
                for j := LastMiddleN to n - 1 do
                  Result[j].X := (Result[j].X - x) * Scale;
              end;
              LastMiddleN := n;
            end;
            break;
          end;

          if i > 0 then
          begin
            Good := True;
            for j := LastMiddleN to n - 1 do
              if ez.DistanceSquare(Result[j].X + i, Result[j].Y - y) < DisSq then
              begin
                Good := False;
                Break;
              end;
            if Good then
            begin
              Result[n].X := -i;
              break;
            end;
          end;
          Inc(i);
        until False;
      end;
      if Length(Data) > LastMiddleN then
      begin
        x := 0;
        for j := LastMiddleN to Length(Data) - 1 do
          x := x + Result[j].X;
        x := x / (Length(Data) - LastMiddleN);
        for j := LastMiddleN to Length(Data) - 1 do
          Result[j].X := Result[j].X - x;
      end;
    end;

  var
    DataPoints: TFloat64s;
    DisSq: Float64;
    i, sg: NInt;
    y, dy, y1, y2: Float64;
    ErrorBar: TErrorBar;
    Points: TPointFs;
  begin
    sg := DataSets.Subgroup;
    if Settings.ShowOnlyMeans and Data.AllHaveMinRepeats(2)
      then DataPoints := DataSets.SortedRepeatMeans
      else DataPoints := DataSets.SortedData;
    DisSq := Sqr((Settings.Subgroups[sg].SymbolSize + Settings.SymbolLineWidth / 2) * Settings.SymbolMinGap);

    ErrorBar := Settings.ErrorBar;
    if DataSets.nData <= 1
      then ErrorBar := TErrorBar.None
    else if DataSets.nRepeat <= 1
      then if ErrorBar = TErrorBar.Mean
          then ErrorBar := TErrorBar.MeanData
        else if ErrorBar = TErrorBar.MeanSD
          then ErrorBar := TErrorBar.MeanSDData
        else if ErrorBar = TErrorBar.MeanSEM
          then ErrorBar := TErrorBar.MeanSE;

    if Settings.DrawMiddleLines then
      AddLine(Left + Width / 2, Settings.Margin, Left + Width / 2, Settings.Margin + PlotAreaHeight, TPlotElement.Grid);

    AddGroup(sg);
    if ErrorBar.IsBoxPlot then
    begin
      AddGroup(sg);
      y := DataPoints.Percentile(True, 0.5);
      y1 := DataPoints.Percentile(True, 0.25);
      y2 := DataPoints.Percentile(True, 0.75);
      if (y2 > LowY) and (y1 <= HighY)
        then AddBox(Left, ez.Min(Yof(y1), Settings.Margin + PlotAreaHeight),
                             Left + Width, ez.Max(Yof(y2), Settings.Margin), sg);
      if (y > LowY) and (y <= HighY)
        then AddErrorBar(Left, Yof(y), Left + Width, Yof(y), sg);

      if ErrorBar = TErrorBar.MedianIQR
        then y := y1 - 1.5 * (y2 - y1)
        else y := DataPoints[0];
      if (y1 >= LowY) and (y <= HighY)
        then AddErrorBar(Left + Width / 2, ez.Min(Settings.Margin + PlotAreaHeight, YOf(y)),
                              Left + Width / 2, ez.Max(Settings.Margin , Yof(y1)), sg);
      if (ErrorBar = TErrorBar.MedianMinMax) and (y > LowY) and (y <= HighY)
        then AddErrorBar(Left + Width / 4, YOf(y), Left + Width * 3 / 4, Yof(y), sg);

      if ErrorBar = TErrorBar.MedianIQR
        then y := y2 + 1.5 * (y2 - y1)
        else y := DataPoints[Length(DataPoints) - 1];
      if (y >= LowY) and (y2 <= HighY)
        then AddErrorBar(Left + Width / 2, ez.Min(Settings.Margin + PlotAreaHeight, YOf(y2)),
                              Left + Width / 2, ez.Max(Settings.Margin , Yof(y)), sg);
      if (ErrorBar = TErrorBar.MedianMinMax) and (y > LowY) and (y <= HighY)
        then AddErrorBar(Left + Width / 4, YOf(y), Left + Width * 3 / 4, Yof(y), sg);
      EndGroup(sg);

      AddGroup(sg);
      y := 1.5 * (y2 - y1);
      y1 := y1 - y;
      y2 := y2 + y;
      // Draw data points
      if Settings.ShowAllPoints or (ErrorBar <> TErrorBar.MedianIQR)
        then Points := GetPositions(DataPoints, DisSq)
        else Points := GetPositions(DataPoints.Filter(function (const Value: Float64): Boolean
                                      begin
                                        Result := (Value < y1) or (Value > y2);
                                      end), DisSq);
      for i := 0 to Length(Points) - 1 do
        if IsYInRange(Points[i].y)
          then AddPoint(Points[i].x + Left + Width / 2, Points[i].y, sg);
      EndGroup(sg);
    end else
    begin
      AddGroup(sg);
      // Draw Box
      if Settings.ShowColumn and (DataSets.nData > 0) then
      begin
        if ErrorBar.IsIndividualDataPlot
          then y := DataSets.MeanOfData
          else y := DataSets.Mean;

        if (y >= 0) and (y > LowY) and (0 <= HighY)
          then AddBox(Left, ez.Min(Yof(0), Settings.Margin + PlotAreaHeight),
                               Left + Width, ez.Max(Yof(y), Settings.Margin), sg);
        if (y < 0) and (0 >= LowY) and (y < HighY)
          then AddBox(Left, ez.Max(Yof(0), Settings.Margin),
                               Left + Width, ez.Min(Yof(y), Settings.Margin + PlotAreaHeight), sg);
      end;

      // Draw Error bar
      if ErrorBar <> TErrorBar.None then
      begin
        if ErrorBar.IsIndividualDataPlot
          then y := DataSets.MeanOfData
          else y := DataSets.Mean;
        case ErrorBar of
          TErrorBar.MeanSD: dy := DataSets.StDev;
          TErrorBar.MeanSEM: dy := DataSets.SEM;
          TErrorBar.MeanSDData: dy := DataSets.StDevOfData;
          TErrorBar.MeanSE: dy := DataSets.SEMOfData;
          else dy := 0;
        end;

        if not Settings.ShowColumn then
          if (y >= LowY) and (y <= HighY)
            then AddErrorBar(Left, YOf(y), Left + Width, Yof(y), sg);

        if not (ErrorBar in [TErrorBar.Mean, TErrorBar.MeanData]) then
        begin
          y1 := y - dy;
          y2 := y + dy;
          if not (Settings.SingleErrorBar and Settings.ShowColumn) or (y >= 0) then
            if (y2 >= LowY) and (y2 <= HighY)
              then AddErrorBar(Left + Width / 6, YOf(y2), Left + Width * 5 / 6, Yof(y2), sg);
          if not (Settings.SingleErrorBar and Settings.ShowColumn) or (y < 0) then
            if (y1 >= LowY) and (y1 <= HighY)
              then AddErrorBar(Left + Width / 6, YOf(y1), Left + Width * 5 / 6, Yof(y1), sg);

          if Settings.SingleErrorBar and Settings.ShowColumn
            then if y >= 0
              then y1 := y
              else y2 := y;

          if (y2 >= LowY) and (y1 <= HighY)
            then AddErrorBar(Left + Width / 2, ez.Min(Settings.Margin + PlotAreaHeight, YOf(y1)),
                                      Left + Width / 2, ez.Max(Settings.Margin , Yof(y2)), sg);
        end;
      end;
      EndGroup(sg);

      AddGroup(sg);
      // Draw data points
      Points := GetPositions(DataPoints, DisSq);
      for i := 0 to Length(Points) - 1 do
        if IsYInRange(Points[i].y)
          then AddPoint(Points[i].x + Left + Width / 2, Points[i].y, sg);
      EndGroup(sg);
    end;
    EndGroup(sg);
  end;

  procedure DrawGroup(g: NInt; Left, Width, MaxWidth: Float64);
  var
    sgGap, sgWidth, maxSGWidth: Float64;
    i: NInt;
  begin
    var nSubGroups := Settings.VisibleSubGroupCount(Data.nSubgroups);
    sgWidth := Width / (nSubgroups + Settings.SubgroupGaps * (nSubgroups - 1));
    if nSubgroups = 1
      then maxSGWidth := MaxWidth
      else maxSGWidth := Width / nSubgroups;
    sgGap   := sgWidth * Settings.SubgroupGaps;
    for i := 0 to Length(Data.Groups[g]) - 1 do
    begin
      var n := Settings.GetIndexOfVisibles(i);
      if (n >= 0) and (Data.Groups[g][i] >= 0) then
        DrawSubgroup(Data.DataSets[Data.Groups[g][i]], Left + n * (sgWidth + sgGap), sgWidth, maxSGWidth);
    end;
  end;

  procedure DrawLinkedGroup(sg: NInt; Left, Width, MaxWidth: Float64);
  var
    x0, y0, x, y, sgWidth, maxSGWidth: Float64;
    First: Boolean;
    i: NInt;
  begin
    x0 := 0; y0 := 0;
    First := True;
    for i := 0 to Length(Data.DataSets) - 1 do
      if Data.DataSets[i].Subgroup = sg then
      begin
        x := Left + Width * (Data.DataSets[i].Offset - Data.MinOffset) / (Data.MaxOffset - Data.MinOffset);
        if Settings.ErrorBar.IsBoxPlot
          then y := Data.DataSets[i].SortedData.Percentile(True, 0.5)
        else if Settings.ErrorBar.IsIndividualDataPlot
          then y := Data.DataSets[i].MeanOfData
          else y := Data.DataSets[i].Mean;
        y := YOf(y);
        if First
          then First := False
        else AddLine(x0, y0, x, y, sg);
        x0 := x; y0 := y;
      end;

    var nSubGroups := Settings.VisibleSubGroupCount(Data.nSubgroups);
    sgWidth := Width / Length(Data.Groups) / nSubgroups * ez.Max(0.05, 1 - Settings.SubgroupGaps);
    if nSubgroups = 1
      then maxSGWidth := MaxWidth
      else maxSGWidth := Width / nSubgroups;
    for i := 0 to Length(Data.DataSets) - 1 do
    begin
      var n := Settings.GetIndexOfVisibles(i);
      if (n >= 0) and (Data.DataSets[i].Subgroup = sg) then
      begin
        x := Left + Width * (Data.DataSets[i].Offset - Data.MinOffset) / (Data.MaxOffset - Data.MinOffset);
        DrawSubgroup(Data.DataSets[i], x - sgWidth / 2, sgWidth, maxSGWidth);
      end;
    end;
  end;

var
  y, y2, GroupWidth, PlotAreaLeft, PlotAreaWidth: Float64;
  i: NInt;
begin
  LowY   := ez.Min(Settings.LowY, Settings.HighY);
  HighY  := ez.Max(Settings.LowY, Settings.HighY);
  YSteps := Settings.YSteps;
  if YSteps = 0 then YSteps := (HighY - LowY) / 4;
  if YSteps = 0 then YSteps := 10;
  if LowY = HighY then
  begin
    LowY  := LowY  - 2 * YSteps;
    HighY := HighY + 2 * YSteps;
  end;
  PlotAreaHeight := Settings.Height - 2 * Settings.Margin;
  YRatio     := PlotAreaHeight / (HighY - LowY);

  PlotAreaLeft   := Settings.Margin + Settings.TickLength + GetLabelWidth(Settings);
  PlotAreaWidth  := Settings.Width  - Settings.Margin - PlotAreaLeft;

  AddGroup(TPlotElement.Axis);
  // Draw grid lines and ticks
  y := Trunc(LowY / YSteps) * YSteps;           // Floor returns Integer; Trunc returns Int64;
  if (y > LowY) and IsYInRange(Yof(y- YSteps)) then Y := Y - YSteps;

  y2 := Yof(Y);
  while IsYInRange(y2) do
  begin
    if Settings.DrawGridLines and (abs(y) > YSteps / 100) then        // Also don't draw at 0
      AddLine(PlotAreaLeft, y2,
                       Settings.Width - Settings.Margin, y2, TPlotElement.Grid);
    AddLine(PlotAreaLeft - Settings.TickLength, y2,
                     PlotAreaLeft, y2, TPlotElement.Tick);
    y := y + YSteps;
    y2 := Yof(Y);
  end;
  // Draw Axis
  AddLine(PlotAreaLeft, Settings.Margin,
                   PlotAreaLeft, Settings.Margin + PlotAreaHeight, TPlotElement.Axis);
  y2 := Yof(0);
  if IsYInRange(y2) then
    AddLine(PlotAreaLeft, y2,
                     Settings.Width - Settings.Margin, y2, TPlotElement.Axis);
  EndGroup(TPlotElement.Axis);

  // Draw tick labels
  if Settings.DrawLabels then
  begin
    AddGroup(TPlotElement.Axis);
    y := Trunc(LowY / YSteps) * YSteps;           // Floor returns Integer; Trunc returns Int64;
    if (y > LowY) and IsYInRange(Yof(y- YSteps)) then Y := Y - YSteps;
    y2 := Yof(Y);
    while IsYInRange(y2) do
    begin
      var s: string;
      var Digits := ez.Min(Numbers.GetLastPrecisionDigits(Settings.LowY),
                       Numbers.GetLastPrecisionDigits(Settings.HighY),
                       Numbers.GetLastPrecisionDigits(Settings.YSteps));
      if Digits > 0
        then s:= IntToStr(Round(y))
        else if SimpleRoundTo(y, Digits) = 0
          then s := '0'
          else s := Format('%.*f', [-Digits, SimpleRoundTo(y, Digits)]);
      AddText(PlotAreaLeft - Settings.TickLength - Settings.LabelGap, y2,
                       s,
                       TPlotElement.Tick);
      y := y + YSteps;
      y2 := Yof(Y);
    end;
    EndGroup(TPlotElement.Axis);
  end;

  if Data.Groups = nil then exit;
  GroupWidth := PlotAreaWidth / Length(Data.Groups);
  if (Data.MinOffset > Float64.MinValue) and (Data.MinOffset <> Data.MaxOffset) then
  begin
    for i := 0 to Data.nSubgroups - 1 do
      DrawLinkedGroup(i, PlotAreaLeft + GroupWidth * (0.25 + Settings.GroupGaps / 2),
                         PlotAreaWidth - GroupWidth * (0.5 + Settings.GroupGaps),
                         GroupWidth * 0.98);
  end else
  begin
    for i := 0 to Length(Data.Groups) - 1 do
      DrawGroup(i, PlotAreaLeft + GroupWidth * i + GroupWidth * Settings.GroupGaps / 2,
                   GroupWidth * (1 - Settings.GroupGaps), GroupWidth * 0.98);
  end;
end;
{$ENDREGION}

end.
