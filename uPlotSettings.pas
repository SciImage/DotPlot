unit uPlotSettings;

{$I wc.Base.inc}

interface

uses
  System.UITypes,
  wc.Types, wc.Base, wc.PrefFiles,
  uDataSet;

const
  NumberOfStyle = 6;

type
  {$REGION 'TColorTheme'}
  TStyleColors = array [0 .. NumberOfStyle - 1] of TAlphaColor;
  TColorTheme = record
    Name: string;
    Colors: TStyleColors;
    const IndexOfClassic = 1;

    class function IndexOf(const Name: string): NInt;                   static;
    class function PresetNames(Index: NInt): string;                    static;
    class function PresetColors(const Name: string): TStyleColors;      overload; static;
    class function PresetColors(Index: NInt): TStyleColors;             overload; static;
    class function PresetCount: NInt;                                   static; inline;
    class function Default: TStyleColors;                               static;
    class function Classic: TStyleColors;                               static;
  end;
  {$ENDREGION}
  {$REGION 'TSubgroupStyle'}
  TSymbol = (Circle, Square, Diamond, Triangle, DownTriangle);
  TSubgroupStyle = record
    Symbol: TSymbol;
    SymbolSize: Float32;
    Hidden, Filled: Boolean;
    SymbolColor: TAlphaColor;
    class function Make(const Color: TAlphaColor; Symbol: TSymbol; Filled: Boolean; const Size: Float32): TSubgroupStyle; overload; static;
    class function Make(const Colors: array of TAlphaColor; Symbol: TSymbol; Filled: Boolean; const Size: Float32): TArray<TSubgroupStyle>; overload; static;
  end;
  {$ENDREGION}
  {$REGION 'TPlotSettings'}
  TPlotSettings = record                // ...AAA..BBB..CCC......AAA..BBB..CCC...
    Width, Height: NInt;                // ... Half Group gap
    LowY, HighY, YSteps: Float64;       //       .. subgroup gap
    Background: TAlphaColor;            //                 ...... Group gap
    Margin, TickLength: Float32;        // 0: No group gap; 50%: half of the plot width are group gaps
    LabelGap: Float32;                  // Gap Between Tick and tick label
    GroupGaps: Float32;                 // 0: No subgroup gap; 50%: the gap is half of the width for showing data (AAA in above)
    SubgroupGaps: Float32;
    SymbolMinGap: Float32;
    ShowAllPoints, ShowOnlyMeans, ShowColumn: Boolean;
    OverrideColumnFill, OverrideDotColor, SingleErrorBar: Boolean;
    SameSize, BlackErrorBar, BlackColumnLine: Boolean;
    DrawGridLines, DrawMiddleLines: Boolean;
    AxisLineWidth: Float32;     AxisLineColor: TAlphaColor;
    TickLineWidth: Float32;     TickLineColor: TAlphaColor;
    GridLineWidth: Float32;     GridLineColor: TAlphaColor;
    SymbolLineWidth: Float32;           // color is by group
    ColumnLineWidth: Float32;           // color is by group
    ErrorBarLineWidth: Float32;         // color is by group
    ErrorBar: TErrorBar;
    ColumnFillColor, DotColor: TAlphaColor;
    ColumnFillOpacity, ColumnFillGradient: Float32;
    Font: string;
    FontSize: Float32;

    Subgroups: TArray<TSubgroupStyle>;

    function DrawLabels: Boolean;
    function VisibleSubGroupCount(sgCount: NInt): NInt;
    function GetVisibleSubGroups(sgCount, n: NInt): NInt;
    function GetIndexOfVisibles(n: NInt): NInt;
    function UseGradient: Boolean;
    function PresetColorIndex: NInt;

    function GetSymbolColor(SubGroup: NInt): TAlphaColor;
    function GetSymbolFill(SubGroup: NInt): TAlphaColor;
    function GetColumnFill(SubGroup: NInt): TAlphaColor;
    function GetErrorBarColor(SubGroup: NInt): TAlphaColor;
    function GetColumnLineColor(SubGroup: NInt): TAlphaColor;
    function GetColFillColorOfGradient(sg: Nint; Reverse: Boolean): TAlphaColor;

    procedure SaveToPref(Pref: TPrefFile; const Key: string);
    procedure LoadFromPref(Pref: TPrefFile; const Key: string);

    class function Combine(const Setting: TPlotSettings; const SubGroupStyles: TArray<TSubgroupStyle>): TPlotSettings; static;
  end;
  {$ENDREGION}
  TPresetStyle = record
    type TValueMode = (NoChange, Fixed, Auto, SymAuto);
  public
    Name: string;
    Modified: Boolean;
    mLowY, mHighY, mYStep: TValueMode;
    mWidth, mHeight: TValueMode;
    LowY, HighY, YStep: Float32;
    Width, Height, DimensionUnit: NInt;
  end;
  TPresetStyless = record
    Styles: array of TPresetStyle;
    class var DeleteStyles: TStringArray;
  end;

const
  NullColor = TAlphaColorRec.Null;
  {$REGION 'Presets'}
  Gomes: TPlotSettings = (
    // Width, Height: NInt;                // ... Half Group gap
    // LowY, HighY, YSteps: Float32;       //       .. subgroup gap
    Background: NullColor;
    Margin: 20; TickLength: 20; LabelGap: 12;
    GroupGaps: 0.35;        SubgroupGaps: 0.2;          SymbolMinGap: 0.8;
    ShowAllPoints: True;    ShowOnlyMeans: False;       ShowColumn: False;
    OverrideColumnFill: True; OverrideDotColor: False;  SingleErrorBar: False;
    SameSize: True; BlackErrorBar: True; BlackColumnLine: True;
    DrawGridLines: False;   DrawMiddleLines: False;
    AxisLineWidth: 2;       AxisLineColor: TAlphaColorRec.Black;
    TickLineWidth: 2;       TickLineColor: TAlphaColorRec.Black;
    GridLineWidth: 1.0;     GridLineColor: TAlphaColorRec.Darkgray;
    SymbolLineWidth: 3;     ColumnLineWidth: 2;
    ErrorBarLineWidth: 3;   ErrorBar: TErrorBar.MedianIQR;
    ColumnFillColor: TAlphaColorRec.Darkgray;
    DotColor: $B0000000;
    ColumnFillOpacity: 0.5; ColumnFillGradient: 0;
  );
  GomesClassic: TPlotSettings = (
    Background: NullColor;
    Margin: 20; TickLength: 20; LabelGap: 12;
    GroupGaps: 0.40;        SubgroupGaps: 0.2;          SymbolMinGap: 1.1;
    ShowAllPoints: False;   ShowOnlyMeans: True;        ShowColumn: True;
    OverrideColumnFill: False;  OverrideDotColor: True; SingleErrorBar: False;
    SameSize: True; BlackErrorBar: True; BlackColumnLine: True;
    DrawGridLines: False;   DrawMiddleLines: False;
    AxisLineWidth: 2;       AxisLineColor: TAlphaColorRec.Black;
    TickLineWidth: 2;       TickLineColor: TAlphaColorRec.Black;
    GridLineWidth: 1.0;     GridLineColor: TAlphaColorRec.Darkgray;
    SymbolLineWidth: 1;     ColumnLineWidth: 1;
    ErrorBarLineWidth: 2;   ErrorBar: TErrorBar.MeanSEM;
    ColumnFillColor: TAlphaColorRec.Darkgray;
    DotColor: $C0000000;
    ColumnFillOpacity: 1; ColumnFillGradient: 0.1;
  );
  MTOC: TPlotSettings = (
    Background: NullColor;
    Margin: 20; TickLength: 20; LabelGap: 12;
    GroupGaps: 0.5;         SubgroupGaps: 0.5;          SymbolMinGap: 1.2;
    ShowAllPoints: True;    ShowOnlyMeans: False;       ShowColumn: True;
    OverrideColumnFill: True; OverrideDotColor: False;  SingleErrorBar: False;
    SameSize: True; BlackErrorBar: True; BlackColumnLine: True;
    DrawGridLines: False;   DrawMiddleLines: False;
    AxisLineWidth: 2;       AxisLineColor: TAlphaColorRec.Black;
    TickLineWidth: 2;       TickLineColor: TAlphaColorRec.Black;
    GridLineWidth: 1;       GridLineColor: TAlphaColorRec.Darkgray;
    SymbolLineWidth: 2;     ColumnLineWidth: 1.5;
    ErrorBarLineWidth: 2.5; ErrorBar: TErrorBar.MeanSEM;
    ColumnFillColor: TAlphaColorRec.Darkgray;
    DotColor: $B0000000;
    ColumnFillOpacity: 1; ColumnFillGradient: 0;
  );
  FRAP: TPlotSettings = (
    Background: NullColor;
    Margin: 20; TickLength: 20; LabelGap: 8;
    GroupGaps: 0.3;         SubgroupGaps: 0.25;         SymbolMinGap: 1.12;
    ShowAllPoints: True;    ShowOnlyMeans: False;       ShowColumn: True;
    OverrideColumnFill: False; OverrideDotColor: True;  SingleErrorBar: False;
    SameSize: True; BlackErrorBar: True; BlackColumnLine: True;
    DrawGridLines: False;   DrawMiddleLines: False;
    AxisLineWidth: 2;       AxisLineColor: TAlphaColorRec.Black;
    TickLineWidth: 2;       TickLineColor: TAlphaColorRec.Black;
    GridLineWidth: 1;       GridLineColor: TAlphaColorRec.Darkgray;
    SymbolLineWidth: 2;     ColumnLineWidth: 1.5;
    ErrorBarLineWidth: 2.5; ErrorBar: TErrorBar.MeanSEM;
    ColumnFillColor: TAlphaColorRec.Darkgray;
    DotColor: $C0000000;
    ColumnFillOpacity: 1; ColumnFillGradient: 0.1;
    Font: 'Calibri';
    FontSize: 47;
  );
{$ENDREGION}

var
  DefaultSettings: TPlotSettings;

implementation

uses
  System.SysUtils,
  wc.Colors;

{$REGION 'TColorTheme'}
const
  NumberOfPresetThemes = 44;
  PresetColorThemes: array [0..NumberOfPresetThemes - 1] of TColorTheme =
  ( (Name: 'Default';           Colors: ($FFA53E34, $FF2D4E9A, $FF006400, $FF8B008B, $FF808000, $FF008B8B)),
    (Name: 'Office 2013 X';     Colors: ($FFC0504D, $FF4F81BD, $FF8064A2, $FF9BBB59, $FFF79646, $FF4BACC6)),
    (Name: 'Office 2013';       Colors: ($FF4F81BD, $FFC0504D, $FF9BBB59, $FF8064A2, $FF4BACC6, $FFF79646)),
    (Name: 'Office 2023';       Colors: ($FF4472C4, $FFED7D31, $FFA5A5A5, $FFFFC000, $FF5B9BD5, $FF7030A0)),
    (Name: 'Grayscale';         Colors: ($FFDDDDDD, $FFB2B2B2, $FF969696, $FF808080, $FF5F5F5F, $FF4D4D4D)),
    (Name: 'Grayscale X';       Colors: ($FF4D4D4D, $FF5F5F5F, $FF808080, $FF969696, $FFB2B2B2, $FFDDDDDD)),
    (Name: 'Apex';              Colors: ($FFCEB966, $FF9CB084, $FF6BB1C9, $FF6585CF, $FF7E6BC9, $FFA379BB)),
    (Name: 'Aspect';            Colors: ($FFF07F09, $FF9F2936, $FF1B587C, $FF4C8540, $FF604878, $FFC19859)),
    (Name: 'Civic';             Colors: ($FFD16349, $FFCCB400, $FF8CADAE, $FF8C7B70, $FF8FB08C, $FFD19049)),
    (Name: 'Concourse';         Colors: ($FF2DA2BF, $FFDA1F28, $FFEB641B, $FF39639D, $FF474B78, $FF7D3C4A)),
    (Name: 'Equity';            Colors: ($FFD34817, $FF9B2D1F, $FFA28E6A, $FF956251, $FF918485, $FF855D5D)),
    (Name: 'Flow';              Colors: ($FF0F6FC6, $FF009DD9, $FF0BD0D9, $FF10CF9B, $FF7CCA62, $FFA5C249)),
    (Name: 'Foundry';           Colors: ($FF72A376, $FFB0CCB0, $FFA8CDD7, $FFC0BEAF, $FFCEC597, $FFE8B7B7)),
    (Name: 'Median';            Colors: ($FF94B6D2, $FFDD8047, $FFA5AB81, $FFD8B25C, $FF7BA79D, $FF968C8C)),
    (Name: 'Metro';             Colors: ($FF7FD13B, $FFEA157A, $FFFEB80A, $FF00ADDC, $FF738AC8, $FF1AB39F)),
    (Name: 'Module';            Colors: ($FFF0AD00, $FF60B5CC, $FFE66C7D, $FF6BB76D, $FFE88651, $FFC64847)),
    (Name: 'Opulent';           Colors: ($FFB83D68, $FFAC66BB, $FFDE6C36, $FFF9B639, $FFCF6DA4, $FFFA8D3D)),
    (Name: 'Oriel';             Colors: ($FFFE8637, $FF7598D9, $FFB32C16, $FFF5CD2D, $FFAEBAD5, $FF777C84)),
    (Name: 'Origin';            Colors: ($FF727CA4, $FF9FB8CD, $FFD2DA7A, $FFFADA7A, $FFB88472, $FF8E736A)),
    (Name: 'Paper';             Colors: ($FFA5B592, $FFF3A447, $FFE7BC29, $FFD092A7, $FF9C85C0, $FF809EC2)),
    (Name: 'Solstice';          Colors: ($FF3093AB, $FFFEB80A, $FFC32D2E, $FF84AA33, $FF964305, $FF475A8D)),
    (Name: 'Technic';           Colors: ($FF6EA0B0, $FFCCAF0A, $FF8D89A4, $FF748560, $FF9E9273, $FF7E848D)),
    (Name: 'Trek';              Colors: ($FFF0A22E, $FFA5644E, $FFB58B80, $FFC3986D, $FFA19574, $FFC17529)),
    (Name: 'Urban';             Colors: ($FF53548A, $FF438086, $FFA04DA3, $FFC4652D, $FF8B5D3D, $FF5C92B5)),
    (Name: 'Verve';             Colors: ($FFFF388C, $FFE40059, $FF9C007F, $FF68007F, $FF005BD3, $FF00349E)),
    (Name: 'Bright & Clean';    Colors: ($FFFF5733, $FF33C1FF, $FF28A745, $FFFFC107, $FF6F42C1, $FFE83E8C)),
    (Name: 'Pastel Harmony';    Colors: ($FFFFB3BA, $FFBAE1FF, $FFBAFFC9, $FFFFFFBA, $FFFFDFBA, $FFD7BAFF)),
    (Name: 'Modern Flat';       Colors: ($FFE63946, $FFE1FADE, $FFA8DADC, $FF457B9D, $FF1D3557, $FFF4A261)),
    (Name: 'Vibrant Tech';      Colors: ($FFFF6F61, $FF6B5B95, $FF88B04B, $FFF7CAC9, $FF92A8D1, $FF955251)),
    (Name: 'Nature Inspired';   Colors: ($FF264653, $FF2A9D8F, $FFE9C46A, $FFF4A261, $FFE76F51, $FF8AB17D)),
    (Name: 'Candy Pop';         Colors: ($FFFF4C4C, $FF4CFF4C, $FF4C4CFF, $FFFFD24C, $FFFF4CFF, $FF4CFFFF)),
    (Name: 'Elegant Contrast';  Colors: ($FFD7263D, $FFF46036, $FF2E294E, $FF1B998B, $FFC5D86D, $FFF4E04D)),
    (Name: 'Cool Breeze';       Colors: ($FF00A8E8, $FF007EA7, $FF003459, $FFF4D35E, $FFEE964B, $FFF95738)),
    (Name: 'Soft Professional'; Colors: ($FF6C757D, $FF17A2B8, $FF28A745, $FFFFC107, $FFDC3545, $FF6610F2)),
    (Name: 'Retro Fun';         Colors: ($FFFF9F1C, $FFFFBF69, $FFDFDFDF, $FFCBF3F0, $FF2EC4B6, $FFE71D36)),
    (Name: 'Oceanic';           Colors: ($FF023E8A, $FF0077B6, $FF0096C7, $FF00B4D8, $FF48CAE4, $FF90E0EF)),
    (Name: 'Sunset Glow';       Colors: ($FFFF6F61, $FFFFB347, $FFFFD700, $FFFF69B4, $FF8A2BE2, $FF00CED1)),
    (Name: 'Minimal Pastel';    Colors: ($FFFAD2E1, $FFE2F0CB, $FFB5EAD7, $FFC7CEEA, $FFFFDAC1, $FFFFB7B2)),
    (Name: 'Bold Primary';      Colors: ($FFFF0000, $FF00FF00, $FF0000FF, $FFFFFF00, $FFFF00FF, $FF00FFFF)),
    (Name: 'Earth Tones';       Colors: ($FF8D6E63, $FFA1887F, $FFD7CCC8, $FFFFAB91, $FFFFCCBC, $FFFFE0B2)),
    (Name: 'Neon Pop';          Colors: ($FFFF6EC7, $FFFFD300, $FF39FF14, $FF00FFFF, $FFFF073A, $FF8D00FF)),
    (Name: 'Corporate Cool';    Colors: ($FF0D6EFD, $FF6C757D, $FF198754, $FFDC3545, $FFFFC107, $FF6610F2)),
    (Name: 'Tropical Vibes';    Colors: ($FFFF7F50, $FFFFD700, $FFADFF2F, $FF40E0D0, $FFFF69B4, $FF00CED1)),
    (Name: 'Calm & Cool';       Colors: ($FFA2D2FF, $FFBDE0FE, $FFCDB4DB, $FFFFC8DD, $FFFFAFCC, $FFF8A9DA))
  );

{ TColorTheme }

class function TColorTheme.PresetCount: NInt;
begin
  Result := NumberOfPresetThemes;
end;

class function TColorTheme.IndexOf(const Name: string): NInt;
begin
  for var i := 0 to NumberOfPresetThemes - 1 do
    if SameText(Name, PresetColorThemes[i].Name)
      then Exit(i);
  Result := -1;
end;

class function TColorTheme.PresetNames(Index: NInt): string;
begin
  Result := PresetColorThemes[Index].Name;
end;

class function TColorTheme.PresetColors(Index: NInt): TStyleColors;
begin
  Result := PresetColorThemes[Index].Colors;
end;

class function TColorTheme.PresetColors(const Name: string): TStyleColors;
begin
  var i := IndexOf(Name);
  if i >= 0
    then Result := PresetColorThemes[i].Colors
    else Result := PresetColorThemes[0].Colors;
end;

class function TColorTheme.Classic: TStyleColors;
begin
  Result := PresetColorThemes[IndexOfClassic].Colors;
end;

class function TColorTheme.Default: TStyleColors;
begin
  Result := PresetColorThemes[0].Colors;
end;
{$ENDREGION}

{$REGION 'TSubgroupStyle'}
{ TSubgroupStyle }

class function TSubgroupStyle.Make(const Color: TAlphaColor; Symbol: TSymbol; Filled: Boolean; const Size: Float32): TSubgroupStyle;
begin
  Result.Symbol      := Symbol;
  Result.SymbolColor := Color;
  Result.Hidden      := False;
  Result.SymbolSize  := Size;
  Result.Filled      := Filled;
end;

class function TSubgroupStyle.Make(const Colors: array of TAlphaColor; Symbol: TSymbol; Filled: Boolean; const Size: Float32): TArray<TSubgroupStyle>;
var
  i: NInt;
begin
  SetLength(Result, Length(Colors));
  for i := 0 to Length(Colors) - 1 do
    Result[i] := Make(Colors[i], Symbol, Filled, Size);
end;
{$ENDREGION}

{$REGION 'TPlotSettings'}
{ TPlotSettings }

class function TPlotSettings.Combine(const Setting: TPlotSettings; const SubGroupStyles: TArray<TSubgroupStyle>): TPlotSettings;
var
  i: NInt;
begin
  Result := Setting;
  Result.Subgroups := Copy(SubGroupStyles);
  if Length(SubGroupStyles) < Length(DefaultSettings.Subgroups) then
  begin
    SetLength(Result.Subgroups, Length(DefaultSettings.Subgroups));
    for i := Length(SubGroupStyles) to Length(DefaultSettings.Subgroups) - 1 do
      Result.Subgroups[i] := DefaultSettings.Subgroups[i];
  end;
end;

function TPlotSettings.DrawLabels: Boolean;
begin
 Result := (Font <> '') and not SameText(Font, 'None');
end;

function TPlotSettings.GetIndexOfVisibles(n: NInt): NInt;
begin
  if Subgroups[n].Hidden then Exit(-1);
  Result := 0;
  for var i := 0 to n - 1 do
    if not Subgroups[i].Hidden then inc(Result);
end;

function TPlotSettings.GetSymbolColor(SubGroup: NInt): TAlphaColor;
begin
  if OverrideDotColor
    then Result := DotColor
    else Result := Subgroups[SubGroup].SymbolColor;
end;

function TPlotSettings.GetErrorBarColor(SubGroup: NInt): TAlphaColor;
begin
  if BlackErrorBar
    then Result := TAlphaColorRec.Black
    else Result := Subgroups[SubGroup].SymbolColor;
end;

function TPlotSettings.GetColumnLineColor(SubGroup: NInt): TAlphaColor;
begin
  if BlackColumnLine
    then Result := TAlphaColorRec.Black
    else Result := Subgroups[SubGroup].SymbolColor;
end;

function TPlotSettings.GetSymbolFill(SubGroup: NInt): TAlphaColor;
begin
  if Subgroups[SubGroup].Filled
    then if OverrideDotColor
      then Result := DotColor
      else Result := Subgroups[SubGroup].SymbolColor
    else Result := NullColor;
end;

function TPlotSettings.GetColumnFill(SubGroup: NInt): TAlphaColor;
begin
  if OverrideColumnFill
    then Result := ColumnFillColor
    else {if OverrideDotColor and (Subgroups[SubGroup].ColumnFill <> NullColor)
      then Result := Subgroups[SubGroup].ColumnFill.MultiplyAlpha(2.01)
      else }Result := Subgroups[SubGroup].SymbolColor.MultiplyAlpha(ColumnFillOpacity);
end;

function TPlotSettings.GetVisibleSubGroups(sgCount, n: NInt): NInt;
begin
  var l := 0;
  for var i := 0 to ez.Min(sgCount, Length(Subgroups)) - 1 do
    if not Subgroups[i].Hidden then
    begin
      if l = n then Exit(i);
      inc(l);
    end;
  Result := -1;
end;

function TPlotSettings.PresetColorIndex: NInt;
begin
  for var i := 0 to NumberOfPresetThemes - 1 do
  begin
    var Diff := False;
    for var j := 0 to ez.Min(NumberOfStyle, Length(Subgroups)) - 1 do
      if PresetColorThemes[i].Colors[j] <> Subgroups[j].SymbolColor then
      begin
        Diff := True;
        break;
      end;
    if not Diff then Exit(i);
  end;
  Result := -1;
end;

function TPlotSettings.UseGradient: Boolean;
begin
  Result := Abs(ColumnFillGradient) >= 0.01;
end;

function TPlotSettings.GetColFillColorOfGradient(sg: Nint; Reverse: Boolean): TAlphaColor;
const
  MinLum = $30;
begin
  var g := ez.IfThen<Float32>(Reverse, -ColumnFillGradient, ColumnFillGradient);
  if g >= 0 then
  begin
    var c := GetColumnFill(sg);
    if c.RGBOnly = 0 then c := TAlphaColor.RGB(MinLum, MinLum, MinLum)
    else if c.GrayScaleF < MinLum then
    begin
      var f := MinLum / c.GrayScaleF;
      c := c.Multiply(f);
    end;
    Result := c.Multiply(1 + g);
  end else Result := GetColumnFill(sg).Multiply(1 / (1 - g));
end;

function TPlotSettings.VisibleSubGroupCount(sgCount: NInt): NInt;
begin
  Result := 0;
  for var i := 0 to ez.Min(sgCount, Length(Subgroups)) - 1 do
    if not Subgroups[i].Hidden then inc(Result);
end;

procedure TPlotSettings.LoadFromPref(Pref: TPrefFile; const Key: string);
var
  ValueB: Boolean;
  ValueI: Int32;
begin
  Self := DefaultSettings;
  Subgroups := Copy(DefaultSettings.Subgroups);
  if not Pref.TryOpenKey(Key) then Exit;

  //  Width, Height: NInt;                // ... Half Group gap
  //  LowY, HighY, YSteps: Float64;       //       .. subgroup gap
  Pref.TryReadFloat('Margin',             Margin);
  Pref.TryReadFloat('Tick Length',        TickLength);
  Pref.TryReadFloat('Label Gap',          LabelGap);
  Pref.TryReadFloat('Group Gaps',         GroupGaps);
  Pref.TryReadFloat('Subgroup Gaps',      SubgroupGaps);
  Pref.TryReadFloat('Symbol Min Gap',     SymbolMinGap);

  if Pref.TryReadBool('Background',           ValueB) then
    Background := ez.IfThen(ValueB, TAlphaColorRec.White, NullColor);
  Pref.TryReadBool('Show All Points',     ShowAllPoints);
  Pref.TryReadBool('Show Only Means',     ShowOnlyMeans);
  Pref.TryReadBool('Show Column',         ShowColumn);
  Pref.TryReadBool('Override Column Fill', OverrideColumnFill);
  Pref.TryReadBool('Override Dot Color',  OverrideDotColor);
  Pref.TryReadBool('Single Errorbar',     SingleErrorBar);
  Pref.TryReadBool('Same Size',           SameSize);
  Pref.TryReadBool('Black Errorbar',      BlackErrorBar);
  Pref.TryReadBool('Black Column Line',   BlackColumnLine);
  Pref.TryReadBool('Draw Grid Lines',     DrawGridLines);
  Pref.TryReadBool('Draw Middle Lines',   DrawMiddleLines);

  Pref.TryReadFloat('Axis Linewidth',     AxisLineWidth);
  Pref.TryReadFloat('Tick Linewidth',     TickLineWidth);
  Pref.TryReadFloat('Grid Linewidth',     GridLineWidth);
  Pref.TryReadFloat('Symbol Linewidth',   SymbolLineWidth);
  Pref.TryReadFloat('Column Linewidth',   ColumnLineWidth);
  Pref.TryReadFloat('Errorbar Linewidth', ErrorBarLineWidth);
  Pref.TryReadInt32('Axis Line Color',    Int32(AxisLineColor));
  Pref.TryReadInt32('Tick Line Color',    Int32(TickLineColor));
  Pref.TryReadInt32('Grid Line Color',    Int32(GridLineColor));
  Pref.TryReadFloat('Column Opacity',     ColumnFillOpacity);
  Pref.TryReadFloat('Column Gradient',    ColumnFillGradient);
  Pref.TryReadInt32('Column Fill Color',  Int32(ColumnFillColor));
  Pref.TryReadInt32('Dot Color',          Int32(DotColor));

  if Pref.TryReadInt ('Errorbar Style',   ValueI) then ErrorBar := TErrorbar(ValueI);
  Pref.TryReadString('Font Name',         Font);
  Pref.TryReadFloat ('Font Size',         FontSize);

  for var i := 0 to Length(Subgroups) - 1 do
  begin
    if Pref.TryReadInt('Symbol-' + IntToStr(i+1), ValueI)
      then Subgroups[i].Symbol := TSymbol(ValueI);
    Pref.TryReadInt32('Symbol-' + IntToStr(i+1) + ' Color',  Int32(Subgroups[i].SymbolColor));
    Pref.TryReadBool ('Symbol-' + IntToStr(i+1) + ' Filled', Subgroups[i].Filled);
    Pref.TryReadFloat('Symbol-' + IntToStr(i+1) + ' Size',   Subgroups[i].SymbolSize);
  end;
end;

procedure TPlotSettings.SaveToPref(Pref: TPrefFile; const Key: string);
begin
  if not Pref.OpenKey(Key) then Exit;
  //  Width, Height: NInt;                // ... Half Group gap
  //  LowY, HighY, YSteps: Float64;       //       .. subgroup gap
  Pref.WriteFloat('Margin',             Margin);
  Pref.WriteFloat('Tick Length',        TickLength);
  Pref.WriteFloat('Label Gap',          LabelGap);
  Pref.WriteFloat('Group Gaps',         GroupGaps);
  Pref.WriteFloat('Subgroup Gaps',      SubgroupGaps);
  Pref.WriteFloat('Symbol Min Gap',     SymbolMinGap);

  Pref.WriteBool('Background',          Background <> NullColor);
  Pref.WriteBool('Show All Points',     ShowAllPoints);
  Pref.WriteBool('Show Only Means',     ShowOnlyMeans);
  Pref.WriteBool('Show Column',         ShowColumn);
  Pref.WriteBool('Override Column Fill', OverrideColumnFill);
  Pref.WriteBool('Override Dot Color',  OverrideDotColor);
  Pref.WriteBool('Single Errorbar',     SingleErrorBar);
  Pref.WriteBool('Same Size',           SameSize);
  Pref.WriteBool('Black Errorbar',      BlackErrorBar);
  Pref.WriteBool('Black Column Line',   BlackColumnLine);
  Pref.WriteBool('Draw Grid Lines',     DrawGridLines);
  Pref.WriteBool('Draw Middle Lines',   DrawMiddleLines);

  Pref.WriteFloat('Axis Linewidth',     AxisLineWidth);
  Pref.WriteFloat('Tick Linewidth',     TickLineWidth);
  Pref.WriteFloat('Grid Linewidth',     GridLineWidth);
  Pref.WriteFloat('Symbol Linewidth',   SymbolLineWidth);
  Pref.WriteFloat('Column Linewidth',   ColumnLineWidth);
  Pref.WriteFloat('Errorbar Linewidth', ErrorBarLineWidth);
  Pref.WriteInt32('Axis Line Color',    AxisLineColor);
  Pref.WriteInt32('Tick Line Color',    TickLineColor);
  Pref.WriteInt32('Grid Line Color',    GridLineColor);
  Pref.WriteFloat('Column Opacity',     ColumnFillOpacity);
  Pref.WriteFloat('Column Gradient',    ColumnFillGradient);
  Pref.WriteInt32('Column Fill Color',  ColumnFillColor);
  Pref.WriteInt32('Dot Color',          DotColor);

  Pref.WriteInt32 ('Errorbar Style',    Int32(ErrorBar));
  Pref.WriteString('Font Name',         Font);
  Pref.WriteFloat ('Font Size',         FontSize);

  for var i := 0 to Length(Subgroups) - 1 do
  begin
    Pref.WriteInt32('Symbol-' + IntToStr(i+1),             Int32(Subgroups[i].Symbol));
    Pref.WriteInt32('Symbol-' + IntToStr(i+1) + ' Color',  Subgroups[i].SymbolColor);
    Pref.WriteBool ('Symbol-' + IntToStr(i+1) + ' Filled', Subgroups[i].Filled);
    Pref.WriteFloat('Symbol-' + IntToStr(i+1) + ' Size',   Subgroups[i].SymbolSize);
  end;
end;
{$ENDREGION}

end.
