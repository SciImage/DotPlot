unit uDrawSVG;

{$I wc.Base.inc}
{.$DEFINE UseDominantBaseline}
        // {dominant-baseline: middle; } is best for vertical center-alignment, but it not supported by Powerpoint
{.$DEFINE UseColorWithAlpha}
        // Color with alpha is not poorly supported by many versions of Powerpoint; all suuport Opacity though

interface

uses
  System.SysUtils, System.UITypes, System.Classes,
  wc.Types, wc.Base,
  uDataSet, uPlotSettings, uDrawing;

procedure SaveSVG(const Data: TGroupDataSets; const Settings: TPlotSettings; const fs: TStream); overload;
procedure SaveSVG(const Data: TGroupDataSets; const Settings: TPlotSettings; const Filename: TFilename); overload;

implementation

uses
  System.Math, wc.Colors;

procedure SaveSVG(const Data: TGroupDataSets; const Settings: TPlotSettings; const fs: TStream);
const
  FontBaselineOffset = 0.312;           // By testing in PowerPoint
var
  GroupLevel: NInt;

  function Num(const Value: Float32): string;
  var
    i: NInt;
  begin
    Result := FormatFloat('0.000', Value);
    i := Length(Result);
    while (i > 1) and (Result[i] = '0') do Dec(i);
    if Result[i] = '.' then Dec(i);
    SetLength(Result, i);
  end;

  function PointsOfShape(const x, y, Size: Float32; n: NInt; const StartDegree: Float64 = 0): string;
  var
    i: NInt;
  begin
    var Ps := TPlotElements.MakePolygon(x, y, Size, n, StartDegree);
    Result := Num(Ps[0].X) + ',' + Num(Ps[0].Y);
    for i := 1 to n do
      Result := Result + ' ' + Num(Ps[i].X) + ',' + Num(Ps[i].Y);
  end;

  procedure DrawLine(const x1, y1, x2, y2: Float32; sg: NInt; IsErrorBar: Boolean);
  var
    s: string;
  begin
    if sg = TPlotElement.Axis
      then s := 'axis-line'
    else if sg = TPlotElement.Tick
      then s := 'tick-line'
    else if sg = TPlotElement.Grid
      then s := 'grid-line'
    else if IsErrorBar
      then s := 'error-bar-' + IntToStr(sg + 1)
      else s := 'symbol-' + IntToStr(sg + 1);
    fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<line x1="%s" y1="%s" x2="%s" y2="%s" class="%s"/>',
      [Num(x1), Num(y1), Num(x2), Num(y2), s]));
  end;

  procedure DrawBox(x1, y1, x2, y2: Float32; sg: NInt);
  begin
    {$IFDEF UseColorWithAlpha}
    if y2 > y1
      then fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<rect x="%s" y="%s" width="%s" height="%s" class="box-%d"/>',
                          [Num(x1), Num(y1), Num(x2 - x1), Num(y2 - y1), sg + 1]))
      else fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<rect x="%s" y="%s" width="%s" height="%s" class="box-%dd"/>',
                          [Num(x1), Num(y2), Num(x2 - x1), Num(y1 - y2), sg + 1]));
    {$ELSE}
    if y2 > y1
      then fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<rect x="%s" y="%s" width="%s" height="%s" class="box-fill-%d"/>',
                          [Num(x1), Num(y1), Num(x2 - x1), Num(y2 - y1), sg + 1]))
      else fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<rect x="%s" y="%s" width="%s" height="%s" class="box-fill-%dd"/>',
                          [Num(x1), Num(y2), Num(x2 - x1), Num(y1 - y2), sg + 1]));
    if y2 > y1
      then fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<rect x="%s" y="%s" width="%s" height="%s" class="box-%d"/>',
                          [Num(x1), Num(y1), Num(x2 - x1), Num(y2 - y1), sg + 1]))
      else fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<rect x="%s" y="%s" width="%s" height="%s" class="box-%d"/>',
                          [Num(x1), Num(y2), Num(x2 - x1), Num(y1 - y2), sg + 1]));
    {$ENDIF}
  end;

  procedure DrawPoint(x, y: Float32; sg: NInt);
  var
    Size, sqSize: Float32;
  begin
    Size := Settings.Subgroups[sg].SymbolSize / 2;
    if Settings.GetSymbolFill(sg) = Settings.GetSymbolColor(sg)
      then Size := Size + Settings.SymbolLineWidth / 2;
    case Settings.Subgroups[sg].Symbol of
      TSymbol.Circle:
        fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<circle cx="%s" cy="%s" r="%s" class="symbol-%d"/>',
                              [Num(x), Num(y), Num(Size), sg + 1]));
      TSymbol.Square:
        begin
          SqSize := Size * RectCorrection;
          fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<rect x="%s" y="%s" width="%s" height="%s" class="symbol-%d"/>',
                                [Num(x - SqSize), Num(y - SqSize), Num(2 * SqSize), Num(2 * SqSize), sg + 1]));
        end;
      TSymbol.Diamond:
          fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<polygon points="%s" class="symbol-%d"/>',
                                [PointsOfShape(x, y, Size, 4), sg + 1]));
      TSymbol.Triangle:
          fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<polygon points="%s" class="symbol-%d"/>',
                                [PointsOfShape(x, y, Size, 3), sg + 1]));
      TSymbol.DownTriangle:
          fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<polygon points="%s" class="symbol-%d"/>',
                                [PointsOfShape(x, y, Size, 3, 180), sg + 1]));
    end;
  end;

  procedure DrawText(x, y: Float32; const Text: string; sg: NInt);
  var
    s: string;
  begin
    if sg = TPlotElement.Axis
      then s := 'axis-label'
    else if sg = TPlotElement.Tick
      then s := 'tick-label'
    else if sg = TPlotElement.Grid
      then s := 'grid-label'
    else s := 'label-' + IntToStr(sg + 1);
    {$IFDEF UseDominantBaseline}
    fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<text x="%s" y="%s" class="%s">%s</text>',
                  [Num(x), Num(y), s, Text]));
    {$ELSE}
    fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + Format('<text x="%s" y="%s" class="%s">%s</text>',
                  [Num(x), Num(y + Settings.FontSize * FontBaselineOffset), s, Text]));
    {$ENDIF}
  end;

  function ColorToText(Color: TAlphaColor): string;
  begin
    if Color = NullColor then Exit('none');
    {$IFDEF UseColorWithAlpha}
    Result := Color.ToCSString;
    {$ELSE}
    if TAlphaColorRec(Color).A = $FF
      then Result := Color.ToNoAlphaString
      else Result := Format('%s; Opacity: %5.3f' , [Color.ToNoAlphaString, Color.Opacity]);
    {$ENDIF}
  end;

  function ColorToText2(Color: TAlphaColor): string;
  begin
    {$IFDEF UseColorWithAlpha}
    Result := Color.ToCSString;
    {$ELSE}
    if TAlphaColorRec(Color).A = $FF
      then Result := Color.ToNoAlphaString
      else Result := Format('%s" Opacity="%5.3f' , [Color.ToNoAlphaString, Color.Opacity]);
    {$ENDIF}
  end;
var
  i: NInt;
  Elements: TPlotElements;
  pElm: ^TPlotElement;
  c: TAlphaColor;
begin
  Elements.DrawWithData(Data, Settings);

//  fs.WriteUTF8Ln('<?xml version="1.0" encoding="UTF-8" standalone="no"?>');
  fs.WriteUTF8Ln(Format('<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d">', [Settings.Width, Settings.Height]));
  if Settings.Background <> NullColor then
    fs.WriteUTF8Ln('  <rect width="100%" height="100%" fill="' + ColorToText2(Settings.Background) + '"/>');

  if Settings.UseGradient then
  begin
    fs.WriteUTF8Ln('  <defs>');
    for i := 0 to ez.Min(Data.nSubgroups, Length(Settings.Subgroups)) - 1 do
      if not Settings.Subgroups[i].Hidden then
      begin
        fs.WriteUTF8Ln(Format('    <linearGradient id="Gradient-%d" x1="0" x2="0" y1="0" y2="1">', [i + 1]));
        {$IFDEF UseColorWithAlpha}
        fs.WriteUTF8Ln(Format('      <stop offset="0%%" stop-color="%s" />',
          [Settings.GetColFillColorOfGradient(i, True).ToCSString]));
        fs.WriteUTF8Ln(Format('      <stop offset="100%%" stop-color="%s" />',
          [Settings.GetColFillColorOfGradient(i, False).ToCSString]));
        {$ELSE}
        fs.WriteUTF8Ln(Format('      <stop offset="0%%" stop-color="%s"/>',
          [Settings.GetColFillColorOfGradient(i, True).ToNoAlphaString]));
        fs.WriteUTF8Ln(Format('      <stop offset="100%%" stop-color="%s"/>',
          [Settings.GetColFillColorOfGradient(i, False).ToNoAlphaString]));
        fs.WriteUTF8Ln('    </linearGradient>');
        {$ENDIF}
        fs.WriteUTF8Ln(Format('    <linearGradient id="Gradient-%dd" x1="0" x2="0" y1="0" y2="1">', [i + 1]));
        {$IFDEF UseColorWithAlpha}
        fs.WriteUTF8Ln(Format('      <stop offset="0%%" stop-color="%s" />',
          [Settings.GetColFillColorOfGradient(i, True).ToCSString]));
        fs.WriteUTF8Ln(Format('      <stop offset="100%%" stop-color="%s" />',
          [Settings.GetColFillColorOfGradient(i, False).ToCSString]));
        {$ELSE}
        fs.WriteUTF8Ln(Format('      <stop offset="0%%" stop-color="%s"/>',
          [Settings.GetColFillColorOfGradient(i, False).ToNoAlphaString]));
        fs.WriteUTF8Ln(Format('      <stop offset="100%%" stop-color="%s"/>',
          [Settings.GetColFillColorOfGradient(i, True).ToNoAlphaString]));
        fs.WriteUTF8Ln('    </linearGradient>');
        {$ENDIF}
      end;
    fs.WriteUTF8Ln('  </defs>');
  end;

  fs.WriteUTF8Ln('  <style>');
  fs.WriteUTF8Ln(Format('    .axis-line {stroke: %s; stroke-width: %s; stroke-linecap: square;}',
                     [ColorToText(Settings.AxisLineColor), Num(Settings.AxisLineWidth)]));
  fs.WriteUTF8Ln(Format('    .tick-line {stroke: %s; stroke-width: %s; stroke-linecap: square;}',
                     [ColorToText(Settings.TickLineColor), Num(Settings.TickLineWidth)]));
  {$IFDEF UseDominantBaseline}
  if Settings.DrawLabels then
    fs.WriteUTF8Ln(Format('    .tick-label {font-family: %s; fill: %s; font-size: %spx; text-anchor: end; dominant-baseline: middle;}',
                     [Settings.Font, ColorToText(Settings.TickLineColor), Num(Settings.FontSize)]));
  {$ELSE}
  if Settings.DrawLabels then
    fs.WriteUTF8Ln(Format('    .tick-label {font-family: %s; fill: %s; font-size: %spx; text-anchor: end;}',
                     [Settings.Font, ColorToText(Settings.TickLineColor), Num(Settings.FontSize)]));
  {$ENDIF}

  if Settings.DrawGridLines or Settings.DrawMiddleLines then
    fs.WriteUTF8Ln(Format('    .grid-line {stroke: %s; stroke-width: %s; stroke-linecap: square;}',
                     [ColorToText(Settings.GridLineColor), Num(Settings.GridLineWidth)]));

  for i := 0 to ez.Min(Data.nSubgroups, Length(Settings.Subgroups)) - 1 do
    if not Settings.Subgroups[i].Hidden then
    begin
      c := Settings.GetSymbolFill(i);
      if c = Settings.GetSymbolColor(i)
        then fs.WriteUTF8(Format('    .symbol-%d {stroke: none;', [i + 1]))
        else fs.WriteUTF8(Format('    .symbol-%d {stroke: %s; stroke-width: %s;',
                         [i + 1, ColorToText(Settings.GetSymbolColor(i)), Num(Settings.SymbolLineWidth)]));

      fs.WriteUTF8Ln(' fill: ' + ColorToText(c) + ';}');

      if Settings.ShowColumn or Settings.ErrorBar.IsBoxPlot then
      begin
        c := Settings.GetColumnFill(i);
        {$IFDEF UseColorWithAlpha}
        if (c <> NullColor) and Settings.UseGradient then
        begin
          fs.WriteUTF8Ln(Format('    .box-%d {stroke: %s; stroke-width: %s; fill: url("#Gradient-%d");',
                             [i + 1, ColorToText(Settings.Subgroups[i].ColumnColor), Num(Settings.ColumnLineWidth), i + 1]));
          fs.WriteUTF8Ln(Format('    .box-%dd {stroke: %s; stroke-width: %s; fill: url("#Gradient-%dd");',
                             [i + 1, ColorToText(Settings.Subgroups[i].ColumnColor), Num(Settings.ColumnLineWidth), i + 1]));
        end else
        begin
          fs.WriteUTF8Ln(Format('    .box-%d {stroke: %s; stroke-width: %s; fill: %s;',
                             [i + 1, ColorToText(Settings.Subgroups[i].ColumnColor), Num(Settings.ColumnLineWidth), ColorToText(c)]));
        end;
        {$ELSE}
        fs.WriteUTF8Ln(Format('    .box-%d {stroke: %s; stroke-width: %s; fill: none;}',
                           [i + 1, ColorToText(Settings.GetColumnLineColor(i)), Num(Settings.ColumnLineWidth)]));
        if c <> NullColor then
        begin
          if not Settings.UseGradient then
          begin
            fs.WriteUTF8Ln(Format('    .box-fill-%d {stroke: none; fill: %s;}', [i + 1, ColorToText(c)]));
            fs.WriteUTF8Ln(Format('    .box-fill-%dd {stroke: none; fill: %s;}', [i + 1, ColorToText(c)]));
          end else
          begin
            fs.WriteUTF8Ln(Format('    .box-fill-%d {stroke: none; fill: url("#Gradient-%d");%s}', [i + 1, i + 1,
                                       ez.IfThen(c.IsTranslucent, Format(' Opacity: %5.3f;', [c.Opacity]), '')]));
            fs.WriteUTF8Ln(Format('    .box-fill-%dd {stroke: none; fill: url("#Gradient-%dd");%s}', [i + 1, i + 1,
                                       ez.IfThen(c.IsTranslucent, Format(' Opacity: %5.3f;', [c.Opacity]), '')]));
          end;
        end;
        {$ENDIF}
      end;

      if Settings.ErrorBar <> TErrorBar.None then
        fs.WriteUTF8Ln(Format('    .error-bar-%d {stroke: %s; stroke-width: %s;}',
                           [i + 1, ColorToText(Settings.GetErrorBarColor(i)), Num(Settings.ErrorBarLineWidth)]));
    end;

  fs.WriteUTF8Ln('  </style>');
  fs.WriteUTF8Ln('');

  GroupLevel := 1;
  for i := 0 to Elements.Count - 1 do
  begin
    pElm := @Elements.Elements[i];
    case pElm^.ElementType of
      TPlotElementType.GroupBegin:
        begin
          fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + '<g>');
          Inc(GroupLevel);
        end;
      TPlotElementType.GroupEnd:
        begin
          Dec(GroupLevel);
          fs.WriteUTF8Ln(StringOfChar(' ', 2 * GroupLevel) + '</g>');
        end;
      TPlotElementType.Line:
        DrawLine(pElm^.X1, pElm^.Y1, pElm^.X2, pElm^.Y2, pElm^.Subgroup, False);
      TPlotElementType.ErrorBar:
        DrawLine(pElm^.X1, pElm^.Y1, pElm^.X2, pElm^.Y2, pElm^.Subgroup, True);
      TPlotElementType.Box:
        DrawBox(pElm^.X1, pElm^.Y1, pElm^.X2, pElm^.Y2, pElm^.Subgroup);
      TPlotElementType.Point:
        DrawPoint(pElm^.CX, pElm^.CY, pElm^.Subgroup);
      TPlotElementType.Text:
        DrawText(pElm^.TextX, pElm^.TextY, pElm^.Text, pElm^.Subgroup);
    end;
  end;

  fs.WriteUTF8('</svg>');
end;

procedure SaveSVG(const Data: TGroupDataSets; const Settings: TPlotSettings; const Filename: TFilename);
var
  fs: TFileStream;
begin
  fs := TFileStream.CreateForWrite(Filename);
  try
    SaveSVG(Data, Settings, fs);
  finally
    fs.Free;
  end;
end;

end.
