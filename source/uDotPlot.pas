unit uDotPlot;

{$I wc.Base.inc}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Rtti,
  FMX.Types, FMX.Objects, FMX.Graphics, FMX.Colors, FMX.Layouts, FMX.Controls.Presentation,
  FMX.Dialogs, FMX.Forms, FMX.Controls, FMX.StdCtrls, FMX.Edit, FMX.Memo.Types, FMX.Memo,
  FMX.ListBox, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox,
  wc.Types, wc.Base, wc.FMX.Base, wc.FMX.Clipboard, wc.FMX.ControlEx, wc.PrefFiles,
  uDataSet, uPlotSettings, System.Actions, FMX.ActnList, FMX.Menus;

type
  TForm1 = class(TForm)
    {$REGION 'Components'}
    loMenu: TLayout;
      lbEntry: TListBox;
      btnUpdateEntry: TButton;
      btnAddEntry: TButton;
      btnRemoveEntry: TButton;
      btnPaste: TButton;
      btnGomesClassic: TButton;   btnGomesAll: TButton;
      btnMTOC: TButton;
      btnCopyImage: TButton;      btnSaveSVG: TButton;
      btnSavePNG: TButton;        btnClose: TButton;
    loTop: TLayout;
      spEntry: TSplitter;
      spMemo: TSplitter;
      Grid1: TGrid;               memoSummary: TMemo;
    spTop: TSplitter;

    loLeft: TLayout;
      sbSettings: TVertScrollBox;
        ccbShared: TColorComboBox;
        loSize: TLayout;
          lbSize: TLabel;                 edWidth: TEdit;
          lbSizeX: TLabel;                edHeight: TEdit;
          btnAutoSize: TButton;           cbLockSize: TCheckBox;
          btnDecreaseWidth: TButton;      btnIncreaseWidth: TButton;
        loYRange: TLayout;
          lbYRange: TLabel;               edLowY: TEdit;
          lbYRangeTo: TLabel;             edHighY: TEdit;
          btnAuoRange: TButton;           edYSteps: TEdit;
          btnDecreaseSteps: TButton;      btnIncreaseSteps: TButton;
        loFont: TLayout;
          lbFont: TLabel;                 cbFont: TComboBox;
          tbFontSize: TTrackBar;
        loTheme: TLayout;
          lbThemes: TLabel;               cbThemes: TComboBox;
        loErrorBar: TLayout;
          lbErrorBar: TLabel;             cbErrorBar: TComboBox;
          cbSingleErrorbar: TCheckBox;    cbBlackErrorBars: TCheckBox;
          tbErrorBarLine: TTrackBar;
        loOptions: TLayout;
          cbShowOnlyMeans: TCheckBox;     cbShowAllPoints: TCheckBox;
          cbFillBackground: TCheckBox;
        expdGaps: TExpander;
          loGroupGaps: TLayout;
            lbGroupGaps: TLabel;          tbGroupGaps: TTrackBar;
          loSubgroupGaps: TLayout;
            lbSubgroupGaps: TLabel;       tbSubgroupGaps: TTrackBar;
          loSymbolMinGap: TLayout;
            lbSymbolMinGap: TLabel;       tbSymbolMinGap: TTrackBar;
        expdSubgroups: TExpander;
          cbSameSize: TCheckBox;
          loSubgroup1: TLayout;
            cbSubgroupV1: TCheckBox;      cbSubgroup1: TComboBox;
            tbSubgroup1: TTrackBar;       ccbSubgroup1: TComboColorBox;
          loSubgroup2: TLayout;
            cbSubgroupV2: TCheckBox;      cbSubgroup2: TComboBox;
            tbSubgroup2: TTrackBar;       ccbSubgroup2: TComboColorBox;
          loSubgroup3: TLayout;
            cbSubgroupV3: TCheckBox;      cbSubgroup3: TComboBox;
            tbSubgroup3: TTrackBar;       ccbSubgroup3: TComboColorBox;
          loSubgroup4: TLayout;
            cbSubgroupV4: TCheckBox;      cbSubgroup4: TComboBox;
            tbSubgroup4: TTrackBar;       ccbSubgroup4: TComboColorBox;
          loSubgroup5: TLayout;
            cbSubgroupV5: TCheckBox;      cbSubgroup5: TComboBox;
            tbSubgroup5: TTrackBar;       ccbSubgroup5: TComboColorBox;
          loSubgroup6: TLayout;
            cbSubgroupV6: TCheckBox;      cbSubgroup6: TComboBox;
            tbSubgroup6: TTrackBar;       ccbSubgroup6: TComboColorBox;
          loOverrideSymbol: TLayout;
            cbDotColor: TCheckBox;        ccbDotColor: TComboColorBox;
          loSymbolLine: TLayout;
            lbSymbolLine: TLabel;         tbSymbolLine: TTrackBar;
        expdColumn: TExpander;
          loCoumnSettings: TLayout;
            lbColumnLine: TLabel;         cbBlackColumnLine: TCheckBox;
            tbColumnLine: TTrackBar;
            cbOverrideColumn: TCheckBox;  ccbColumnFill: TComboColorBox;
            lbOpacity: TLabel;            tbOpacity: TTrackBar;
            lbGradient: TLabel;           tbGradient: TTrackBar;
        expdLines: TExpander;
          loAxis: TLayout;
            lbAxis: TLabel;             tbAxisLine: TTrackBar;
            ccbAxis: TComboColorBox;
          loTick: TLayout;
            lbTick: TLabel;             tbTickLine: TTrackBar;
            ccbTick: TComboColorBox;
          loGrid: TLayout;
            cbDrawGrid: TCheckBox;      cbShowMidlines: TCheckBox;
            tbGridLine: TTrackBar;      ccbGrid: TComboColorBox;
      lbMessage: TLabel;
    Panel1: TPanel;
    loPlot: TLayout;
      imPlot: TImage;
    memoInput: TMemo;
    SaveDialog1: TSaveDialog;
    btnFRAP: TButton;
    PopupMenu1: TPopupMenu;
    miPasteSettingsFromSVG: TMenuItem;
    miPasteSizeFromSVG: TMenuItem;
    {$ENDREGION}
    {$REGION 'UI Events'}
    procedure FormCreate(Sender: TObject);
    procedure memoInputChange(Sender: TObject);
    procedure spTopMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure btnCopyImageClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSavePNGClick(Sender: TObject);
    procedure edSettingsChange(Sender: TObject);
    procedure drawSettingsChange(Sender: TObject);
    procedure cbSameSizeChange(Sender: TObject);
    procedure tbSettingsChange(Sender: TObject);
    procedure btnAutoSizeClick(Sender: TObject);
    procedure btnAuoRangeClick(Sender: TObject);
    procedure btnDecreaseStepsClick(Sender: TObject);
    procedure btnIncreaseStepsClick(Sender: TObject);
    procedure ccbMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ccbSharedChange(Sender: TObject);
    procedure ccbSharedExit(Sender: TObject);
    procedure sbSettingsClick(Sender: TObject);
    procedure Grid1GetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
    procedure btnPasteClick(Sender: TObject);
    procedure btnMTOCClick(Sender: TObject);
    procedure btnGomesAllClick(Sender: TObject);
    procedure lbEntryMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure btnSaveSVGClick(Sender: TObject);
    procedure cbFontChange(Sender: TObject);
    procedure tbFontSizeChange(Sender: TObject);
    procedure imPlotClick(Sender: TObject);
    procedure lbSubgroup1DblClick(Sender: TObject);
    procedure lbSubgroup2DblClick(Sender: TObject);
    procedure lbSubgroup3DblClick(Sender: TObject);
    procedure lbSubgroup4DblClick(Sender: TObject);
    procedure lbSubgroup5DblClick(Sender: TObject);
    procedure lbSubgroup6DblClick(Sender: TObject);
    procedure btnDecreaseWidthClick(Sender: TObject);
    procedure btnIncreaseWidthClick(Sender: TObject);
    procedure btnGomesClassicClick(Sender: TObject);
    procedure cbShowOnlyMeansChange(Sender: TObject);
    procedure tbSettingsClick(Sender: TObject);
    procedure tbSettingsDblClick(Sender: TObject);
    procedure sbSettingsCalcContentBounds(Sender: TObject; var ContentBounds: TRectF);
    procedure cbThemesChange(Sender: TObject);
    procedure cbThemesItemPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure SubgroupVisibleChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFRAPClick(Sender: TObject);
    procedure miPasteSizeFromSVGClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    {$ENDREGION}
  private
    {$REGION 'Private variables'}
    FData: TGroupDataSets;
    FSettings: TPlotSettings;
    FChangingSettings: NInt;
    FLastLBClick: TDateTime;
    FLastLabelWidth: NInt;
    FShouldMaximize: Boolean;
    FShouldFullScreen: Boolean;
    {$ENDREGION}
  private
    {$REGION 'Private methods'}
    procedure BeginUIChange;
    procedure EndUIChange(CheckRedraw: Boolean = True);
    function  GetSettingsFromUI(var Settings: TPlotSettings): Boolean;  // Return True if changed
    procedure InputChanged;
    procedure Redraw;
    procedure SaveImageQuery(FilterIndex: Integer);
    procedure ApplySettings(const Settings: TPlotSettings);
    procedure ToggleSubgroupVisible(cb: TCombobox);
    function  GetTBHint(tb: TTrackBar): string;
    procedure LoadPrefs;
    procedure SavePrefs;
    {$ENDREGION}

    procedure EditBoxExit(Sender: TObject);
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.Math, System.SysConst, System.IOUtils,
  FMX.Surfaces, FMX.MultiResBitmap, Xml.XMLDoc, Xml.XMLIntf,
  uDrawing, uDrawCanvas, uDrawSVG;

{$REGION 'Get label width'}
function GetSuggesttedImageWidth(const Settings: TPlotSettings; const Data: TGroupDataSets; var LabelWidth: NInt): NInt;
begin
  Result := 60 + Length(Data.Groups) * (60 + 80 * Settings.VisibleSubGroupCount(Data.nSubgroups));
  if Settings.DrawLabels
    then LabelWidth := 5 * Round(TPlotElements.GetLabelWidth(Settings) / 5)
    else LabelWidth := 0;
  Inc(Result, LabelWidth);
end;
{$ENDREGION}

{$REGION 'GetDrawRange/ImageWidth'}
function CapNumber(const Value: Float64; const Factor: Float64 = 1.3): Float64;
const
  a: array[0..8] of Float64 = (1.0, 2.0, 2.5, 4.0, 5.0, 6.0, 8.0, 10.0, 20.0);
var
  p10: Float64;
  i: NInt;
begin
  p10 := Power(10, Floor(Log10(Value)));
  for i := Low(a) to High(a) - 1 do
    if a[i] * p10 >= Value * Factor then Exit(a[i] * p10);
  Result := a[High(a)] * p10;
end;

function GetDrawRange(const Data: TGroupDataSets; var LowY, HighY, Step: Float64; ErrorBar: TErrorBar; UseMeans: Boolean): Boolean;
const
  MinExtraSpace = 0.6;

  function LowOf(const Value, Step: Float64): Float64;
  begin
    Result := Trunc(Value / Step) * Step;
    if Value < 0 then Result := Result - Step;
    if Value - Result < MinExtraSpace * Step then Result := Result - Step;
  end;

  function HighOf(const Value, Step: Float64): Float64;
  begin
    Result := Trunc(Value / Step) * Step;
    if Value >= 0 then Result := Result + Step;
    if Result - Value < MinExtraSpace * Step then Result := Result + Step;
  end;

var
  Min, Max: Float64;
begin
  Data.GetVisualRange(ErrorBar, UseMeans, Min, Max);
  if Min = Float64.MaxValue then Exit(False);
  Result := True;

  if Min = Max then
  begin
    if Min > 0 then
    begin
      Step  := CapNumber(Min / 2, 1);
      LowY  := LowOf(Min, Step);
      HighY := HighOf(Max, Step);
    end else if Min < 0 then
    begin
      Step  := CapNumber(-Min / 2, 1);
      LowY  := LowOf(Min, Step);
      HighY := HighOf(Max, Step);
    end else
    begin
      LowY  := -1;
      HighY := 1;
      Step  := 0.5;
    end;
    Exit;
  end;

  if Min >= 0 then
  begin
    if (Min = 0) or ((Min > 0) and (Max < 2 * Min)) then
    begin
      LowY  := 0;
      Step  := CapNumber(Max / 4);
      HighY := 4 * Step;
    end else
    begin
      Step := CapNumber((Max - Min) / 4);
      LowY  := LowOf(Min, Step);
      if LowY < 0 then LowY := 0;
      HighY := HighOf(Max, Step);
    end;
  end else if Max <= 0 then
  begin
    if (Max = 0) or ((Max < 0) and (Min > 2 * Max)) then
    begin
      HighY := 0;
      Step  := CapNumber(-Min / 4);
      LowY  := - 4 * Step;
    end else
    begin
      Step := CapNumber((Max - Min) / 4);
      LowY  := LowOf(Min, Step);
      HighY := HighOf(Max, Step);
      if HighY > 0 then HighY := 0;
    end;
  end else // Min < 0 < Max
  begin
    Step := CapNumber((Max - Min) / 4);
    LowY  := LowOf(Min, Step);
    HighY := HighOf(Max, Step);
    if (-HighY > LowY) and (Min + HighY > Step * MinExtraSpace / 2)
      then LowY := -HighY;
    if (-LowY < HighY) and (-LowY - Max > Step * MinExtraSpace / 2)
      then HighY := -LowY;
  end;
end;
{$ENDREGION}

{$REGION 'UI Events'}
procedure TForm1.tbSettingsDblClick(Sender: TObject);
begin
  TTrackBar(Sender).SetToDefault;
end;

type
    THackExpander = class(TExpander);

procedure TForm1.LoadPrefs;
var
  Pref: TPrefFile;
  Value: NInt;
begin
  Pref := TPrefFile.Create('SciImage', 'Dot Plot');
  try
    if Pref.TryOpenKey('Settings') then
    begin
      if Pref.TryRead('Left', Value)   then Left := ez.Max(0, Value);
      if Pref.TryRead('Top', Value)    then Top := ez.Max(0, Value);
      if Pref.TryRead('Width', Value)  then Width := Value;
      if Pref.TryRead('Height', Value) then Height := Value;
      if Left >= Screen.WorkAreaRect.Right - 600
        then Left := Round(Screen.WorkAreaRect.Right - 600);
      if Top >= Screen.WorkAreaRect.Bottom - 500
        then Top := Round(Screen.WorkAreaRect.Bottom - 500);

      FShouldMaximize := Pref.ReadBool('Maximized', False);
      FShouldFullScreen := Pref.ReadBool('Full Screen', False);

      if Pref.TryRead('Data Panel Height', Value) then loTop.Height := Value;
      expdGaps.IsExpanded      := Pref.ReadBool('Gaps Panel Expanded', True);
      expdSubgroups.IsExpanded := Pref.ReadBool('Subgroups Panel Expanded', True);
      expdColumn.IsExpanded    := Pref.ReadBool('Column Panel Expanded', True);
      expdLines.IsExpanded     := Pref.ReadBool('Lines Panel Expanded', True);
      cbLockSize.IsChecked     := Pref.ReadBool('Lock Autosize', False);
    end;
  finally
    Pref.Free;
  end;
end;

procedure TForm1.SavePrefs;
var
  Pref: TPrefFile;
begin
  UpdateNormalBounds;
  Pref := TPrefFile.Create('SciImage', 'Dot Plot');
  try
    if Pref.OpenKey('Settings') then
    begin
      Pref.WriteBool('Full Screen', Self.FullScreen);
      Pref.WriteBool('Maximized', WindowState = TWindowState.wsMaximized);
      Pref.WriteInt32('Left',   NormalLeft);
      Pref.WriteInt32('Top',    NormalTop);
      Pref.WriteInt32('Width',  NormalWidth);
      Pref.WriteInt32('Height', NormalHeight);

      Pref.WriteInt32('Data Panel Height', Round(loTop.Height));
      Pref.WriteBool('Gaps Panel Expanded', expdGaps.IsExpanded);
      Pref.WriteBool('Subgroups Panel Expanded', expdSubgroups.IsExpanded);
      Pref.WriteBool('Column Panel Expanded', expdColumn.IsExpanded);
      Pref.WriteBool('Lines Panel Expanded', expdLines.IsExpanded);
      Pref.WriteBool('Lock Autosize', cbLockSize.IsChecked);
    end;
    // SameSizeSymbol
    // cbBlackColumnLine.IsChecked
    // cbBlackErrorBars.IsChecked
  finally
    Pref.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FSettings.Margin     := 20;
  FSettings.TickLength := 20;
  FSettings.LabelGap   := 12;

  ShowFullScreenIcon := True;   // Effective on Mac
  memoInput.Visible := False;
  SaveDialog1.InitialDir := TPath.GetDownloadsPath;
  DefaultSettings := FSettings;
  InputChanged;

  cbThemes.OwnerDraw := True;
  cbThemes.BeginUpdate;
  try
    for var i := 0 to TColorTheme.PresetCount - 1 do
    begin
      cbThemes.Items.Add(TColorTheme.PresetNames(i));
      cbThemes.ListItems[i].OnPaint := cbThemesItemPaint;
    end;
  finally
    cbThemes.EndUpdate;
  end;
  for var i := 0 to ComponentCount - 1 do
    if Components[i] is TTrackbar then
    begin
      TTrackbar(Components[i]).OnThumbDblClick := tbSettingsDblClick;
      TTrackbar(Components[i]).SetAsDefault;
    end;
  edWidth.DoubleClickSelectAll := True;
  edHeight.DoubleClickSelectAll := True;
  edLowY.DoubleClickSelectAll := True;
  edHighY.DoubleClickSelectAll := True;
  edYSteps.DoubleClickSelectAll := True;
  LoadPrefs;
  UpdateNormalBounds;

  if FShouldFullScreen then
  begin
    FullScreen := True;
    FShouldFullScreen := False;
  end;

  if FShouldMaximize then
  begin
    WindowState := TWindowState.wsMaximized;
    FShouldMaximize := False;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  try
    SavePrefs;
  except
  end;
end;

procedure TForm1.cbThemesItemPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
begin
  if Sender is TListBoxItem then
  begin
    var Index := TListBoxItem(Sender).Index;
    if (Index < 0) or (Index >= TColorTheme.PresetCount) then exit;
    var y := (ARect.Top + ARect.Bottom) / 2;
    var R: TRectF;
    R.Top    := y - 7;
    R.Bottom := y + 7;
    var Colors := TColorTheme.PresetColors(Index);
    for var i := 0 to NumberOfStyle - 1 do
    begin
      R.Left := ARect.Right - 16 * (NumberOfStyle - i);
      R.Right := R.Left + 14;
      Canvas.Fill.Color := Colors[i];
      Canvas.FillRect(R, 1);
//      Canvas.Stroke.Color := TAlphaColorRec.Black;
//      Canvas.Stroke.Thickness := 1;
//      Canvas.DrawRect(R, 1);
    end;
  end;
end;

procedure TForm1.memoInputChange(Sender: TObject);
begin
  InputChanged;
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  miPasteSizeFromSVG.Enabled     := TClipboard.HasSVGImage;
  miPasteSettingsFromSVG.Enabled := miPasteSizeFromSVG.Enabled;
end;

procedure TForm1.miPasteSizeFromSVGClick(Sender: TObject);
begin
  var s := TClipboard.GetSVGImage;
  if s = '' then Exit;

  BeginUIChange;
  try
  var XMLDoc: IXMLDocument;
  XMLDoc := LoadXMLData(s);
  var Node: IXMLNode;
  Node := XMLDoc.DocumentElement;
  if Node.HasAttribute('width') then
    edWidth.Text := Node.Attributes['width'];
  if Node.HasAttribute('height') then
    edHeight.Text := Node.Attributes['height'];
  finally
    EndUIChange(False);
  end;
end;

procedure TForm1.spTopMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
//  Height := Height + Round(loSymbolMinGap.Position.Y + loSymbolMinGap.Height - lbMessage.Position.Y);
end;

procedure TForm1.btnSavePNGClick(Sender: TObject);
begin
  SaveImageQuery(2);
end;

procedure TForm1.btnSaveSVGClick(Sender: TObject);
begin
  SaveImageQuery(1);
end;


procedure TForm1.btnCopyImageClick(Sender: TObject);
var
  ms: TMemoryStream;
begin
  if not Assigned(imPlot.Bitmap) then exit;
  ms := TMemoryStream.Create;
  try
    SaveSVG(FData, FSettings, ms);
    TClipboard.BeginMultiFormats;
    try
      TClipboard.SetPNGImage(imPlot.Bitmap);
      ms.Position := 0;
      TClipboard.SetSVGImage(ms);
      {$IFDEF MSWINDOWS}
      var Bmp := TBitmap.Create;
      try
        DrawTo(FData, FSettings, Bmp, TAlphaColorRec.White, 2);
        TClipboard.SetClipboard(Bmp);
      finally
        Bmp.Free;
      end;
      {$ENDIF}
    finally
      TClipboard.EndMultiFormats;
    end;
  finally
    ms.Free;
  end;
end;

procedure TForm1.ApplySettings(const Settings: TPlotSettings);
  procedure ApplySubgroup(cbv: TCheckbox; cb: TComboBox; ccb: TComboColorBox; tb: TTRackbar; const SGStyle: TSubgroupStyle);
  begin
    cbv.isChecked := not SGStyle.Hidden;
    cb.ItemIndex := NInt(SGStyle.Symbol) * 2 + ez.IfThen(SGStyle.Filled, 1, 0);
    ccb.Color    := SGStyle.SymbolColor;
    tb.Value     := SGStyle.SymbolSize;
    tb.SetAsDefault;
    tb.Hint      := GetTBHint(tb);
  end;

  procedure SetTB(tb: TTRackbar; const Value: Float32);
  begin
    tb.Value     := Value ;
    tb.SetAsDefault;
    tb.Hint      := GetTBHint(tb);
  end;
begin
  BeginUIChange;
  try
    SetTB(tbGroupGaps,      Settings.GroupGaps);
    SetTB(tbSubgroupGaps,   Settings.SubgroupGaps);
    SetTB(tbSymbolMinGap,   Settings.SymbolMinGap);
    SetTB(tbAxisLine,       Settings.AxisLineWidth);
    SetTB(tbTickLine,       Settings.TickLineWidth);
    SetTB(tbGridLine,       Settings.GridLineWidth);
    SetTB(tbSymbolLine,     Settings.SymbolLineWidth);
    SetTB(tbErrorBarLine,   Settings.ErrorBarLineWidth);
    SetTB(tbColumnLine,     Settings.ColumnLineWidth);
    // SetTB(tbFontSize,       Settings.FontSize);
    SetTB(tbGradient,       Settings.ColumnFillGradient);
    SetTB(tbOpacity,        Settings.ColumnFillOpacity);

    ccbAxis.Color               := Settings.AxisLineColor;
    ccbTick.Color               := Settings.TickLineColor;
    ccbGrid.Color               := Settings.GridLineColor;
    ccbColumnFill.Color         := Settings.ColumnFillColor;
    ccbDotColor.Color           := Settings.DotColor;

    cbErrorBar.ItemIndex        := NInt(Settings.ErrorBar);
    expdColumn.IsChecked        := Settings.ShowColumn;
    cbShowAllPoints.IsChecked   := Settings.ShowAllPoints;
    cbShowOnlyMeans.IsChecked   := Settings.ShowOnlyMeans;
    cbDrawGrid.IsChecked        := Settings.DrawGridLines;
    cbSingleErrorBar.IsChecked  := Settings.SingleErrorBar;
    cbShowMidlines.IsChecked    := Settings.DrawMiddleLines;
    cbFillBackground.IsChecked  := Settings.Background <> NullColor;
    cbOverrideColumn.IsChecked  := Settings.OverrideColumnFill;
    cbDotColor.IsChecked        := Settings.OverrideDotColor;
    cbBlackColumnLine.IsChecked := Settings.BlackColumnLine;
    cbBlackErrorBars.IsChecked  := Settings.BlackErrorBar;
    cbSameSize.IsChecked        := Settings.SameSize;

    if Length(Settings.Subgroups) > 0 then
      ApplySubgroup(cbSubgroupV1, cbSubgroup1, ccbSubgroup1, tbSubgroup1, Settings.Subgroups[0]);
    if Length(Settings.Subgroups) > 1 then
      ApplySubgroup(cbSubgroupV2, cbSubgroup2, ccbSubgroup2, tbSubgroup2, Settings.Subgroups[1]);
    if Length(Settings.Subgroups) > 2 then
      ApplySubgroup(cbSubgroupV3, cbSubgroup3, ccbSubgroup3, tbSubgroup3, Settings.Subgroups[2]);
    if Length(Settings.Subgroups) > 3 then
      ApplySubgroup(cbSubgroupV4, cbSubgroup4, ccbSubgroup4, tbSubgroup4, Settings.Subgroups[3]);
    if Length(Settings.Subgroups) > 4 then
      ApplySubgroup(cbSubgroupV5, cbSubgroup5, ccbSubgroup5, tbSubgroup5, Settings.Subgroups[4]);
    if Length(Settings.Subgroups) > 5 then
      ApplySubgroup(cbSubgroupV6, cbSubgroup6, ccbSubgroup6, tbSubgroup6, Settings.Subgroups[5]);

    FSettings.Margin := Settings.Margin;
    FSettings.TickLength := Settings.TickLength;
    FSettings.LabelGap := Settings.LabelGap;
  finally
    EndUIChange(True);
  end;
end;

procedure TForm1.btnGomesAllClick(Sender: TObject);
begin
  BeginUIChange;
  try
    var MaxValue := ez.Max(abs(FData.MaxValue) * 1.2, abs(FData.MinValue));     // 1.2 is to leave room for p values
    var Range: Float64;
    if MaxValue < 0.1  then Range := 0.2
    else if MaxValue < 0.22  then Range := 0.3
    else if MaxValue < 0.32  then Range := 0.4
    else if MaxValue < 0.40  then Range := 0.5
    else if MaxValue < 0.50  then Range := 0.6
    else if MaxValue < 0.70  then Range := 0.8
    else if MaxValue < 0.80  then Range := 0.9
    else if MaxValue < 1.00  then Range := 1.0
    else if MaxValue < 10  then Range := 20
    else if MaxValue < 22  then Range := 30
    else if MaxValue < 32  then Range := 40
    else if MaxValue < 40  then Range := 50
    else if MaxValue < 50  then Range := 60
    else if MaxValue < 70  then Range := 80
    else if MaxValue < 80  then Range := 90
    else Range := 100;

    edLowY.Text   := FloatToStr(-Range);
    edHighY.Text  := FloatToStr(Range);
    edYSteps.Text := FloatToStr(Range / 2);
    cbThemes.ItemIndex := 0;
    ApplySettings(TPlotSettings.Combine(Gomes, TSubgroupStyle.Make(TColorTheme.Default, TSymbol.Circle, False, 9)));
  finally
    EndUIChange(True);
  end;
end;

procedure TForm1.btnGomesClassicClick(Sender: TObject);
var
  MinValue, MaxValue: Float64;
begin
  BeginUIChange;
  try
    if FData.AllHaveMinRepeats(2) then
    begin
      MaxValue := FData.MaxRepeatMean;
      MinValue := FData.MinRepeatMean;
    end else
    begin
      MaxValue := FData.MaxValue;
      MinValue := FData.MinValue;
    end;
    if ez.Max(Abs(MaxValue), Abs(MinValue)) < 1 then
    begin
      MinValue := Floor((MinValue * 100  - 2) / 10) * 10;
      MaxValue := Ceil ((MaxValue * 100  + 1) / 5)  * 5;
      edLowY.Text   := FloatToStr(MinValue / 100);
      edHighY.Text  := FloatToStr(MaxValue / 100);
      if (Round(MinValue) mod 10 = 0) and (Round(MaxValue) mod 10 = 0)
        then edYSteps.Text := '0.1'
        else edYSteps.Text := '0.05';
    end else
    begin
      MinValue := Floor((MinValue - 2) / 10) * 10;
      MaxValue := Ceil ((MaxValue + 1) / 5)  * 5;
      edLowY.Text   := FloatToStr(MinValue);
      edHighY.Text  := FloatToStr(MaxValue);
      if (Round(MinValue) mod 10 = 0) and (Round(MaxValue) mod 10 = 0)
        then edYSteps.Text := '10'
        else edYSteps.Text := '5';
    end;

    ApplySettings(TPlotSettings.Combine(GomesClassic, TSubgroupStyle.Make(TColorTheme.Classic, TSymbol.Circle, True, 14)));
    cbThemes.ItemIndex := TColorTheme.IndexOfClassic;
    cbShowOnlyMeans.IsChecked := FData.AllHaveMinRepeats(2);
  finally
    EndUIChange(True);
  end;
end;

procedure TForm1.btnMTOCClick(Sender: TObject);
begin
  BeginUIChange;
  try
    var MaxValue := FData.MaxValue;
    edLowY.Text := '0';
    if MaxValue > 1
      then if MaxValue > 70
        then edHighY.Text := '90'
        else edHighY.Text := '80'
      else if MaxValue > 0.7
        then edHighY.Text := '0.9'
        else edHighY.Text := '0.8';
    if MaxValue > 1
      then edYSteps.Text := '20'
      else edYSteps.Text := '0.2';

    cbThemes.ItemIndex := 0;
    ApplySettings(TPlotSettings.Combine(MTOC, TSubgroupStyle.Make(TColorTheme.Default, TSymbol.Circle, True, 13)));
  finally
    EndUIChange(True);
  end;
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.btnAutoSizeClick(Sender: TObject);
begin
  BeginUIChange;
  try
    edHeight.Text := '800';
    edWidth.Text := IntToStr(GetSuggesttedImageWidth(FSettings, FData, FLastLabelWidth));
  finally
    EndUIChange;
  end;
end;

procedure TForm1.btnDecreaseStepsClick(Sender: TObject);
var
  a, b: Float64;
begin
  a := Abs(FSettings.YSteps);
  if a = 0 then a := Abs(FSettings.HighY - FSettings.LowY);
  if a = 0 then a := 1;
  if (FSettings.HighY - FSettings.LowY) / a >= 40 then Exit;
  b := CapNumber(a * 0.92, 1);
  if b >= a then b := CapNumber(a * 0.85, 1);
  if b >= a then b := CapNumber(a * 0.7, 1);
  if b >= a then b := CapNumber(a * 0.45, 1);
  BeginUIChange;
  try
    edYSteps.Text := Numbers.ToRoundedString(b);
  finally
    EndUIChange;
  end;
end;

procedure TForm1.btnIncreaseStepsClick(Sender: TObject);
var
  a, b: Float64;
begin
  a := Abs(FSettings.YSteps);
  if a = 0 then a := Abs(FSettings.HighY - FSettings.LowY);
  if a = 0 then a := 1;
  if (FSettings.HighY - FSettings.LowY) / a <= 2 then Exit;
  b := CapNumber(a * 1.01);
  if b <= a then b := CapNumber(a * 1.2);
  if b <= a then b := CapNumber(a * 1.5);
  BeginUIChange;
  try
    edYSteps.Text := Numbers.ToRoundedString(b);
  finally
    EndUIChange;
  end;
end;

procedure TForm1.btnDecreaseWidthClick(Sender: TObject);
var
  w, nw, Step: NInt;
begin
  w := FSettings.Width;
  if w > 2000 then Step := 200
  else if w > 1600 then Step := 100
  else if w > 1200 then Step := 80
  else if w > 800  then Step := 50
  else if w > 360  then Step := 40
  else Step := 20;
  nw := (w - 1) div Step * Step;
  if nw < 200 then nw := 200;
  BeginUIChange;
  try
    edWidth.Text := nw.ToString;
  finally
    EndUIChange;
  end;
end;

procedure TForm1.btnFRAPClick(Sender: TObject);
const
  FRAPColor: TStyleColors = ($FF94B6D2, $FFD8B25C, $FFDD8047, $FFA5AB81, $FF7BA79D, $FF968C8C);
var
  i: NInt;
begin
  BeginUIChange;
  try
    var MaxValue := FData.MaxValue;
    edLowY.Text := '0';
         if MaxValue > 200000 then i := 100000
    else if MaxValue > 90000  then i := 50000
    else if MaxValue > 40000  then i := 20000
    else if MaxValue > 20000  then i := 10000
    else if MaxValue > 9000   then i := 5000
    else if MaxValue > 4000   then i := 2000
    else if MaxValue > 2000   then i := 1000
    else if MaxValue > 900    then i := 500
    else if MaxValue > 400    then i := 200
    else if MaxValue > 200    then i := 100
    else if MaxValue > 90     then i := 50
    else if MaxValue > 40     then i := 20
    else if MaxValue > 20     then i := 10
    else if MaxValue > 9      then i := 5
    else if MaxValue > 4      then i := 2
                              else i := 1;

    edHighY.Text  := IntToStr((Round(MaxValue / i + 1.3)) * i);
    edYSteps.Text := IntToStr(i);

    cbThemes.ItemIndex := 0;
    ApplySettings(TPlotSettings.Combine(FRAP, TSubgroupStyle.Make(FRAPColor, TSymbol.Circle, True, 13)));
  finally
    EndUIChange(True);
  end;
end;

procedure TForm1.btnIncreaseWidthClick(Sender: TObject);
var
  w, nw, Step: NInt;
begin
  w := FSettings.Width;
  if w < 360 then Step := 20
  else if w < 800 then Step := 40
  else if w < 1200 then Step := 50
  else if w < 1600 then Step := 80
  else if w < 2000 then Step := 100
  else Step := 200;
  nw := (w + Step) div Step * Step;
  BeginUIChange;
  try
    edWidth.Text := nw.ToString;
  finally
    EndUIChange;
  end;
end;

procedure TForm1.btnPasteClick(Sender: TObject);
begin
  BeginUIChange;
  try
    cbSubGroupV1.IsChecked := True;
    cbSubGroupV2.IsChecked := True;
    cbSubGroupV3.IsChecked := True;
    cbSubGroupV4.IsChecked := True;
    cbSubGroupV5.IsChecked := True;
    cbSubGroupV6.IsChecked := True;
    memoInput.Text := TClipboard.AsText;
  finally
    EndUIChange;
  end;
end;

procedure TForm1.btnAuoRangeClick(Sender: TObject);
var
  Low, High, Step: Float64;
begin
  if GetDrawRange(FData, Low, High, Step, FSettings.ErrorBar, FSettings.ShowOnlyMeans) then
  begin
    BeginUIChange;
    try
      edLowY.Text   := Numbers.ToRoundedString(Low);
      edHighY.Text  := Numbers.ToRoundedString(High);
      edYSteps.Text := Numbers.ToRoundedString(Step);
    finally
      EndUIChange;
    end;
  end;
end;

procedure TForm1.drawSettingsChange(Sender: TObject);
begin
  if FChangingSettings > 0 then exit;
  if GetSettingsFromUI(FSettings) then Redraw;
end;

procedure TForm1.edSettingsChange(Sender: TObject);
begin
  if FChangingSettings > 0 then exit;
  if GetSettingsFromUI(FSettings) then Redraw;
end;

function TForm1.GetTBHint(tb: TTrackBar): string;
begin
  if tb = tbGroupGaps    then Exit(Numbers.ToRoundedString('Gap between groups = %g%%',         100 * tb.Value));
  if tb = tbSubgroupGaps then Exit(Numbers.ToRoundedString('Gap between subgroups = %g%%',      100 * tb.Value));
  if tb = tbAxisLine     then Exit(Numbers.ToRoundedString('Axis line thickness = %g pt',       tb.Value));
  if tb = tbTickLine     then Exit(Numbers.ToRoundedString('Tick mark thickness = %g pt',       tb.Value));
  if tb = tbGridLine     then Exit(Numbers.ToRoundedString('Grid line thickness = %g pt',       tb.Value));
  if tb = tbSymbolLine   then Exit(Numbers.ToRoundedString('Symbol line thickness = %g pt',     tb.Value));
  if tb = tbSymbolMinGap then Exit(Numbers.ToRoundedString('Distance between data points = %g%%', 100 * tb.Value));
  if tb = tbErrorBarLine then Exit(Numbers.ToRoundedString('Error bar line thickness = %g pt',  tb.Value));
  if tb = tbColumnLine   then Exit(Numbers.ToRoundedString('Column line thickness = %g pt',     tb.Value));
  if tb = tbFontSize     then Exit(Numbers.ToRoundedString('Font size = %g pt',                 tb.Value));
  if tb = tbGradient     then Exit(Numbers.ToRoundedString('Column fill gradient = %g',         tb.Value));
  if string(tb.Name).StartsText('tbSubgroup')
    then Exit(Format('Symbols line thickness of subgroup %s = %s pt', [string(tb.Name).SubString(10, 1), Numbers.ToRoundedString(tb.Value)]));
  Result := '';
end;

procedure TForm1.tbSettingsChange(Sender: TObject);
var
  tb: TTrackbar;
begin
  tb := Sender as TTrackbar;
  var s := GetTBHint(tb);
  tb.Hint := s;

  if FChangingSettings > 0 then exit;
  lbMessage.Text := s;

  if tb = tbAxisLine then
  begin
    BeginUIChange;
    try
      if tbAxisLine.Value < tbTickLine.Value then tbTickLine.Value := tbAxisLine.Value;
      if tbAxisLine.Value < tbGridLine.Value then tbGridLine.Value := tbAxisLine.Value;
    finally
      EndUIChange(False);
    end;
  end else if tb = tbTickLine then
  begin
    try
      if tbAxisLine.Value < tbTickLine.Value then tbAxisLine.Value := tbTickLine.Value;
      if tbTickLine.Value < tbGridLine.Value then tbGridLine.Value := tbTickLine.Value;
    finally
      EndUIChange(False);
    end;
  end else if tb = tbGridLine then
  begin
    try
      if tbAxisLine.Value < tbGridLine.Value then tbAxisLine.Value := tbGridLine.Value;
      if tbTickLine.Value < tbGridLine.Value then tbTickLine.Value := tbGridLine.Value;
    finally
      EndUIChange(False);
    end;
  end else if (tb <> tbSubGroupGaps) and string(tb.Name).StartsText('tbSubgroup') then
    begin
    if FSettings.SameSize then
    begin
      BeginUIChange;
      try
        tbSubgroup1.Value := tb.Value;
        tbSubgroup2.Value := tb.Value;
        tbSubgroup3.Value := tb.Value;
        tbSubgroup4.Value := tb.Value;
        tbSubgroup5.Value := tb.Value;
        tbSubgroup6.Value := tb.Value;
      finally
        EndUIChange(False);
      end;
    end;
  end;
  if GetSettingsFromUI(FSettings) then Redraw;
end;

procedure TForm1.cbFontChange(Sender: TObject);
begin
  if FChangingSettings > 0 then exit;
  if GetSettingsFromUI(FSettings) then
  begin
    var ExtraWidth := 5 * Round(TPlotElements.GetLabelWidth(FSettings) / 5);
    if FLastLabelWidth <> ExtraWidth then
    begin
      FSettings.Width := FSettings.Width - FLastLabelWidth + ExtraWidth;
      BeginUIChange;
      try
        edWidth.Text := IntToStr(FSettings.Width);
      finally
        EndUIChange(False);
      end;
      FLastLabelWidth := ExtraWidth;
    end;
    Redraw;
  end;
end;

procedure TForm1.tbFontSizeChange(Sender: TObject);
begin
  if FChangingSettings > 0 then exit;
  if GetSettingsFromUI(FSettings) then
  begin
    var ExtraWidth := 5 * Round(TPlotElements.GetLabelWidth(FSettings) / 5);
    if FLastLabelWidth <> ExtraWidth then
    begin
      FSettings.Width := FSettings.Width - FLastLabelWidth + ExtraWidth;
      BeginUIChange;
      try
        edWidth.Text := IntToStr(FSettings.Width);
      finally
        EndUIChange(False);
      end;
      FLastLabelWidth := ExtraWidth;
    end;
    Redraw;
  end;
  tbSettingsChange(Sender);
end;

procedure TForm1.tbSettingsClick(Sender: TObject);
begin
  lbMessage.Text := GetTBHint(TTrackbar(Sender));
end;

procedure TForm1.cbSameSizeChange(Sender: TObject);
begin
  if cbSameSize.IsChecked then
  begin
    BeginUIChange;
    try
      tbSubgroup2.Value := tbSubgroup1.Value;
      tbSubgroup3.Value := tbSubgroup1.Value;
      tbSubgroup4.Value := tbSubgroup1.Value;
      tbSubgroup5.Value := tbSubgroup1.Value;
      tbSubgroup6.Value := tbSubgroup1.Value;
    finally
      EndUIChange;
    end;
  end;
end;

procedure TForm1.cbShowOnlyMeansChange(Sender: TObject);
begin
  if FChangingSettings > 0 then exit;
  if GetSettingsFromUI(FSettings) then Redraw;
  if not cbLockSize.IsChecked then
    btnAuoRangeClick(btnAuoRange);
end;

procedure TForm1.cbThemesChange(Sender: TObject);
begin
  if cbThemes.ItemIndex < 0 then Exit;
  BeginUIChange;
  try
    var i := cbThemes.ItemIndex;

    var Colors := TColorTheme.PresetColors(i);
    ccbSubgroup1.Color := Colors[0];
    ccbSubgroup2.Color := Colors[1];
    ccbSubgroup3.Color := Colors[2];
    ccbSubgroup4.Color := Colors[3];
    ccbSubgroup5.Color := Colors[4];
    ccbSubgroup6.Color := Colors[5];
  finally
    EndUIChange(True);
  end;
end;

procedure TForm1.ccbMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  ccb: TComboColorBox;
  p0, p1: TPointF;
begin
  if Button = TMouseButton.mbRight then
  begin
    if ccbShared.Visible then
      ccbShared.TagObject := nil;
    ccb := Sender as TComboColorBox;
    p0 := ccbShared.LocalToScreen(PointF(0, 0));
    p1 := ccb.LocalToScreen(PointF(0, 0));
    ccbShared.Position.Y := ccbShared.Position.Y - p0.Y + p1.Y;
    ccbShared.Position.X := ccbShared.Position.X - p0.X + p1.X - 64;
    ccbShared.Width      := ccb.Width + 64;
    ccbShared.SetApproxColor(ccb.Color);
    // if ccb.Color <> ccbShared.Color then ccb.Color := ccbShared.Color;
    ccbShared.TagObject  := ccb;
    ccbShared.Visible    := True;
    ccbShared.DropDown;
  end;
end;
procedure TForm1.ccbSharedChange(Sender: TObject);
begin
  if ccbShared.Visible and Assigned(ccbShared.TagObject) then
  begin
    TComboColorBox(ccbShared.TagObject).Color := ccbShared.Color;
    ccbshared.Visible := False;
    ccbShared.TagObject :=  nil;
  end;
end;

procedure TForm1.ccbSharedExit(Sender: TObject);
begin
  ccbshared.Visible := False;
  ccbShared.TagObject :=  nil;
end;
{$ENDREGION}

{$REGION 'Get Settings'}
procedure TForm1.InputChanged;
  procedure SetLo(lo: TLayout; n: NInt);
  begin
    lo.Visible := FData.nSubgroups > n;
    if lo.Visible then lo.Position.Y := n * lo.Height;
  end;
var
  Low, High, Step: Float64;
begin
  FData.FromStrings(TStringArray.Create(memoInput.Lines));
  FData.SummarizeToStrings.AssignTo(memoSummary.Lines);
  if not cbLockSize.IsChecked and GetDrawRange(FData, Low, High, Step, FSettings.ErrorBar, FSettings.ShowOnlyMeans) then
  begin
    BeginUIChange;
    try
      edLowY.Text := Format('%g', [Low]);
      edHighY.Text := Format('%g', [High]);
      edYSteps.Text := Format('%g', [Step]);
    finally
      EndUIChange(False);
    end;
  end;

  SetLo(loSubgroup2, 1);
  SetLo(loSubgroup3, 2);
  SetLo(loSubgroup4, 3);
  SetLo(loSubgroup5, 4);
  SetLo(loSubgroup6, 5);
  expdSubGroups.UpdateSize;
//  Height := Height + Round(expdLines.Position.Y + expdLines.Height - lbMessage.Position.Y);

  cbShowOnlyMeans.Enabled := FData.AllHaveMinRepeats(2);
  if not cbShowOnlyMeans.Enabled then cbShowOnlyMeans.IsChecked := False;

  GetSettingsFromUI(FSettings); // This is needed
  if not cbLockSize.IsChecked then
  begin
    BeginUIChange;
    try
      edHeight.Text := '800';
      edWidth.Text := IntToStr(GetSuggesttedImageWidth(FSettings, FData, FLastLabelWidth));
    finally
      EndUIChange(False);
    end;
  end;

  GetSettingsFromUI(FSettings);
  Redraw;

  Grid1.BeginUpdate;
  try
    Grid1.ClearColumns;
    Grid1.RowCount := FData.MaxCount;
    for var i := 0 to FData.TotalSubgroups - 1 do
    begin
      var Column := TFloatColumn.Create(Grid1);
      Column.Width := 80;
      Column.Header := FData.DataSets[i].Name;
      Column.HeaderSettings.StyledSettings := [TStyledSetting.Family, TStyledSetting.Size, TStyledSetting.Other];
      Column.HeaderSettings.TextSettings.HorzAlign := TTextAlign.Center;
      Column.HeaderSettings.TextSettings.FontColor := FSettings.Subgroups[FData.DataSets[i].Subgroup].SymbolColor;
      Column.HeaderSettings.TextSettings.Font.Style := [TFontStyle.fsBold];
      Grid1.AddObject(Column);
    end;
  finally
    Grid1.EndUpdate;
  end;
end;

procedure TForm1.lbEntryMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
var
  EditBox: TEdit;
  ItemRect: TRectF;
  Item: TListBoxItem;
  OldTime: TDateTime;
begin
  OldTime := FLastLBClick;
  FLastLBClick := Now;
  Item := lbEntry.ItemByPoint(X, Y);
  if not assigned(Item) then exit;
  if lbEntry.ItemByIndex(lbEntry.ItemIndex) <> Item then exit;
  if FLastLBClick - OldTime < 250 * Numbers.MilliSeconds then exit;

  EditBox := TEdit.Create(lbEntry);
  EditBox.Parent := lbEntry;
  ItemRect := Item.BoundsRect;
  EditBox.Position.X := ItemRect.Left;
  EditBox.Position.Y := ItemRect.Top;
  EditBox.Width := ItemRect.Width;
  EditBox.Height := ItemRect.Height;
  EditBox.Text := lbEntry.Items[lbEntry.ItemIndex];
  EditBox.SetFocus;

  EditBox.OnExit := EditBoxExit;
end;

procedure TForm1.SubgroupVisibleChange(Sender: TObject);
begin
  if FChangingSettings > 0 then exit;
  if GetSettingsFromUI(FSettings) then
  begin
    if not cbLockSize.IsChecked then
    begin
      BeginUIChange;
      try
        edWidth.Text := IntToStr(GetSuggesttedImageWidth(FSettings, FData, FLastLabelWidth));
        if tbGroupGaps.DefaultValue >= 0.4
          then tbGroupGaps.Value := ez.Min(0.8, 2 / (3 + FSettings.VisibleSubGroupCount(FData.nSubgroups)))
          else tbGroupGaps.Value := ez.Min(0.8, 1.05 / (1 + FSettings.VisibleSubGroupCount(FData.nSubgroups)));
      finally
        EndUIChange(False);
      end;
      GetSettingsFromUI(FSettings);
    end;
    Redraw;
  end;
end;

procedure TForm1.ToggleSubgroupVisible(cb: TCombobox);
begin
end;


procedure TForm1.lbSubgroup1DblClick(Sender: TObject);
begin
  if TSystemKeys.IsMajorModifierPressed
    then ccbSubgroup1.Color := $FF_00_00_00 or UInt32(Random($1_00_00_00))
    else ToggleSubgroupVisible(cbSubgroup1);
end;

procedure TForm1.lbSubgroup2DblClick(Sender: TObject);
begin
  if TSystemKeys.IsMajorModifierPressed
    then ccbSubgroup2.Color := $FF_00_00_00 or UInt32(Random($1_00_00_00))
    else ToggleSubgroupVisible(cbSubgroup2);
end;

procedure TForm1.lbSubgroup3DblClick(Sender: TObject);
begin
  if TSystemKeys.IsMajorModifierPressed
    then ccbSubgroup3.Color := $FF_00_00_00 or UInt32(Random($1_00_00_00))
    else ToggleSubgroupVisible(cbSubgroup3);
end;

procedure TForm1.lbSubgroup4DblClick(Sender: TObject);
begin
  if TSystemKeys.IsMajorModifierPressed
    then ccbSubgroup4.Color := $FF_00_00_00or UInt32(Random($1_00_00_00))
    else ToggleSubgroupVisible(cbSubgroup4);
end;

procedure TForm1.lbSubgroup5DblClick(Sender: TObject);
begin
  if TSystemKeys.IsMajorModifierPressed
    then ccbSubgroup5.Color := $FF_00_00_00a or UInt32(Random($1_00_00_00))
    else ToggleSubgroupVisible(cbSubgroup5);
end;

procedure TForm1.lbSubgroup6DblClick(Sender: TObject);
begin
  if TSystemKeys.IsMajorModifierPressed
    then ccbSubgroup6.Color := $FF_00_00_00 or UInt32(Random($1_00_00_00))
    else ToggleSubgroupVisible(cbSubgroup6);
end;

procedure TForm1.EditBoxExit(Sender: TObject);
begin
  lbEntry.Items[lbEntry.ItemIndex] := (Sender as TEdit).Text;
  (Sender as TEdit).Free;
end;

procedure TForm1.sbSettingsCalcContentBounds(Sender: TObject; var ContentBounds: TRectF);
begin
  {$IFDEF MSWINDOWS}
  if ContentBounds.Height > sbSettings.Height then
  begin
    loLeft.Width := 322 + 16;
    expdLines.Padding.Right := 0;
    expdSubgroups.Padding.Right := 0;
    expdColumn.Padding.Right := 0;
  end else
  begin
    loLeft.Width := 322;
    expdLines.Padding.Right := 4;
    expdSubgroups.Padding.Right := 4;
    expdColumn.Padding.Right := 4;
  end;
  {$ENDIF}
end;

procedure TForm1.sbSettingsClick(Sender: TObject);
begin
  ccbShared.Visible := False;
end;

procedure TForm1.BeginUIChange;
begin
  Inc(FChangingSettings);
end;

procedure TForm1.EndUIChange(CheckRedraw: Boolean = True);
begin
  if FChangingSettings > 0 then
  begin
    Dec(FChangingSettings);
    if CheckRedraw and (FChangingSettings = 0) and GetSettingsFromUI(FSettings)
      then Redraw;
  end;
end;

function TForm1.GetSettingsFromUI(var Settings: TPlotSettings): Boolean;
var
  Changed: Boolean;

  procedure SetTo(var i: NInt; const Value: NInt);              overload;
  begin
    if i = Value then exit;
    i := Value;
    Changed := True;
  end;

  procedure SetTo(var i: Float32; const Value: Float32);        overload;
  begin
    if i = Value then exit;
    i := Value;
    Changed := True;
  end;

  procedure SetTo(var i: Float64; const Value: Float64);        overload;
  begin
    if i = Value then exit;
    i := Value;
    Changed := True;
  end;

  procedure SetTo(var i: Boolean; const Value: Boolean);        overload;
  begin
    if i = Value then exit;
    i := Value;
    Changed := True;
  end;

  procedure SetTo(var i: string; const Value: string);        overload;
  begin
    if i = Value then exit;
    i := Value;
    Changed := True;
  end;

  procedure SetTo(var i: TAlphaColor; const Value: TAlphaColor); overload;
  begin
    if i = Value then exit;
    i := Value;
    Changed := True;
  end;

  procedure SetTo(var i: TSymbol; const Value: TSymbol);        overload;
  begin
    if i = Value then exit;
    i := Value;
    Changed := True;
  end;

  procedure SetTo(var i: TErrorBar; const Value: TErrorBar);    overload;
  begin
    if i = Value then exit;
    i := Value;
    Changed := True;
  end;

  procedure TryGetIntFromEdit(Edit: TEdit; var i: NInt; const Min, Max: NInt);
  var
    Temp, i2: NInt;
  begin
    if NInt.TryParse(Edit.Text.Trim, Temp) and (Temp > 0) then
    begin
      i2 := ez.EnsureRange(Temp, Min, Max);
      if i2 <> Temp then Edit.Text := i2.ToString;
      SetTo(i, i2);
    end else Edit.Text := i.ToString;
  end;

  procedure TryGetFloatFromEdit(Edit: TEdit; var f: Float32); overload;
  var
    Temp: Float32;
  begin
    if Float32.TryParse(Edit.Text.Trim, Temp)
      then SetTo(f, Temp)
      else Edit.Text := f.ToString;
  end;

  procedure TryGetFloatFromEdit(Edit: TEdit; var f: Float64); overload;
  var
    Temp: Float64;
  begin
    if Float64.TryParse(Edit.Text.Trim, Temp)
      then SetTo(f, Temp)
      else Edit.Text := f.ToString;
  end;

  procedure GetGroupStyle(Index: NInt; var Style: TSubgroupStyle; cbv: TCheckBox; cb: TComboBox; tb: TTrackBar; ccb: TComboColorBox; const FillOpacity: Float32);
  var
    SavedChanged: Boolean;
  begin
    SavedChanged := Changed;

    if cb.ItemIndex < 0
      then SetTo(Style.Symbol, Low(TSymbol))
      else SetTo(Style.Symbol, TSymbol(cb.ItemIndex div 2));
    SetTo(Style.Hidden, not cbv.IsChecked);
    SetTo(Style.SymbolSize,    tb.Value);
    SetTo(Style.SymbolColor,   ccb.Color);
    SetTo(Style.Filled, cb.ItemIndex mod 2 <> 0);

    if Index >= FData.nSubgroups then   // not in use, restore SavedChanged
      Changed := SavedChanged;

    cb.Enabled  := not Style.Hidden;
    tb.Enabled  := not Style.Hidden;
    ccb.Enabled := not Style.Hidden;
  end;

begin
  BeginUIChange;
  Changed := False;

  try
    // Fixed values for now
    // These subgroup settings are calculated from SymbolColor: SymbolFill, BoxColor, BoxFill, ErrorBarColor
    TryGetIntFromEdit  (edWidth,  Settings.Width,  120, 3000);
    TryGetIntFromEdit  (edHeight, Settings.Height, 120, 2000);
    TryGetFloatFromEdit(edLowY,   Settings.LowY);
    TryGetFloatFromEdit(edHighY,  Settings.HighY);
    TryGetFloatFromEdit(edYSteps, Settings.YSteps);
    if Settings.YSteps < 0 then
    begin
      Settings.YSteps := -Settings.YSteps;
      edYSteps.Text := Format('%g', [Settings.YSteps]);
    end else if Settings.YSteps = 0 then
    begin
      Settings.YSteps := (Settings.HighY - Settings.LowY) / 4;
      if Settings.YSteps = 0 then Settings.YSteps := Settings.HighY / 2;
      if Settings.YSteps = 0 then Settings.YSteps := 1;
      edYSteps.Text := Format('%g', [Settings.YSteps]);
    end;

    SetTo(Settings.GroupGaps,         tbGroupGaps.Value);
    SetTo(Settings.SubgroupGaps,      tbSubgroupGaps.Value);
    SetTo(Settings.AxisLineWidth,     tbAxisLine.Value);
    SetTo(Settings.SymbolLineWidth,   tbSymbolLine.Value);
    SetTo(Settings.SymbolMinGap,      tbSymbolMinGap.Value);
    SetTo(Settings.ErrorBarLineWidth, tbErrorBarLine.Value);
    SetTo(Settings.AxisLineColor,     ccbAxis.Color);
    SetTo(Settings.ShowColumn,        expdColumn.IsChecked);
    SetTo(Settings.ShowAllPoints,     cbShowAllPoints.IsChecked);
    SetTo(Settings.ShowOnlyMeans,     cbShowOnlyMeans.IsChecked);
    SetTo(Settings.DrawGridLines,     cbDrawGrid.IsChecked);
    SetTo(Settings.SingleErrorbar,    cbSingleErrorbar.IsChecked);
    SetTo(Settings.ErrorBar,          TErrorBar(cbErrorBar.ItemIndex));
    SetTo(Settings.TickLineWidth,     tbTickLine.Value);
    SetTo(Settings.TickLineColor,     ccbTick.Color);
    SetTo(Settings.GridLineWidth,     tbGridLine.Value);
    SetTo(Settings.GridLineColor,     ccbGrid.Color);
    SetTo(Settings.DrawMiddleLines,   cbShowMidlines.IsChecked);
    SetTo(Settings.ColumnLineWidth,   tbColumnLine.Value);
    SetTo(Settings.ColumnFillGradient, tbGradient.Value);
    SetTo(Settings.ColumnFillOpacity, tbOpacity.Value);

    if cbFillBackground.IsChecked
      then SetTo(Settings.Background, TAlphaColorRec.White)
      else SetTo(Settings.Background, NullColor);
    SetTo(Settings.OverrideColumnFill, cbOverrideColumn.IsChecked);
    SetTo(Settings.ColumnFillColor,   ccbColumnFill.Color);
    SetTo(Settings.OverrideDotColor,  cbDotColor.IsChecked);
    SetTo(Settings.DotColor,          ccbDotColor.Color);
    SetTo(Settings.Font,              cbFont.Text);
    SetTo(Settings.FontSize,          tbFontSize.Value);
    SetTo(Settings.BlackColumnLine, cbBlackColumnLine.IsChecked);
    SetTo(Settings.BlackErrorBar,     cbBlackErrorBars.IsChecked);
    SetTo(Settings.SameSize,          cbSameSize.IsChecked);

    SetLength(Settings.Subgroups, 6);
    GetGroupStyle(0, Settings.Subgroups[0], cbSubgroupV1, cbSubgroup1, tbSubgroup1, ccbSubgroup1, Settings.ColumnFillOpacity);
    GetGroupStyle(1, Settings.Subgroups[1], cbSubgroupV2, cbSubgroup2, tbSubgroup2, ccbSubgroup2, Settings.ColumnFillOpacity);
    GetGroupStyle(2, Settings.Subgroups[2], cbSubgroupV3, cbSubgroup3, tbSubgroup3, ccbSubgroup3, Settings.ColumnFillOpacity);
    GetGroupStyle(3, Settings.Subgroups[3], cbSubgroupV4, cbSubgroup4, tbSubgroup4, ccbSubgroup4, Settings.ColumnFillOpacity);
    GetGroupStyle(4, Settings.Subgroups[4], cbSubgroupV5, cbSubgroup5, tbSubgroup5, ccbSubgroup5, Settings.ColumnFillOpacity);
    GetGroupStyle(5, Settings.Subgroups[5], cbSubgroupV6, cbSubgroup6, tbSubgroup6, ccbSubgroup6, Settings.ColumnFillOpacity);
    cbThemes.ItemIndex := Settings.PresetColorIndex;
  finally
    if Settings.ErrorBar.IsBoxPlot then expdColumn.IsChecked := True;
    cbShowAllPoints.Enabled    := Settings.ErrorBar.IsBoxPlot;
    expdColumn.CheckBoxEnabled := not Settings.ErrorBar.IsBoxPlot;
    cbBlackColumnLine.Enabled  := Settings.ShowColumn or Settings.ErrorBar.IsBoxPlot;
    tbErrorBarLine.Enabled     := Settings.ErrorBar <> TErrorBar.None;
    cbBlackErrorBars.Enabled   := Settings.ErrorBar <> TErrorBar.None;
    cbSingleErrorBar.Enabled   := Settings.ErrorBar.HasErrorBar and Settings.ShowColumn;

    ccbGrid.Enabled            := Settings.DrawGridLines or Settings.DrawMiddleLines;
    tbGridLine.Enabled         := Settings.DrawGridLines or Settings.DrawMiddleLines;
    tbFontSize.Enabled         := Settings.DrawLabels;
    ccbColumnFill.Enabled      := Settings.OverrideColumnFill;
    ccbDotColor.Enabled        := Settings.OverrideDotColor;
    tbFontSize.Enabled         := Settings.DrawLabels;
    tbOpacity.Enabled          := not Settings.OverrideColumnFill;

    EndUIChange(False);
  end;
  Result := Changed;
end;

procedure TForm1.Grid1GetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
begin
  if (ACol < FData.TotalSubgroups) and (ARow < FData.DataSets[ACol].nData)
    then Value := FData.DataSets[ACol].DataPoints[ARow];
end;

procedure TForm1.imPlotClick(Sender: TObject);
begin
  ccbShared.Visible := False;
  if Assigned(imPlot) then
  begin
    var y := imPlot.ScreenToLocal(Screen.MousePos).Y;
    y := y / imPlot.Height * FSettings.Height;
    var LowY   := ez.Min(FSettings.LowY, FSettings.HighY);
    var HighY  := ez.Max(FSettings.LowY, FSettings.HighY);
    var YSteps := FSettings.YSteps;
    if YSteps = 0 then YSteps := (HighY - LowY) / 4;
    if YSteps = 0 then YSteps := 10;
    if LowY = HighY then
    begin
      LowY  := LowY  - 2 * YSteps;
      HighY := HighY + 2 * YSteps;
    end;
    var YRatio := (FSettings.Height - 2 * FSettings.Margin) / (HighY - LowY);
    var Value := HighY - (Y - FSettings.Margin) / YRatio;
    lbMessage.Text := Format('Value at this point = %5.3f', [Value]);
  end;
end;

{$ENDREGION}

{$REGION 'Draw/Save Image'}
procedure TForm1.Redraw;
begin
  if not Assigned(imPlot.Bitmap) then imPlot.Bitmap := TBitmap.Create;
  DrawTo(FData, FSettings, imPlot.Bitmap, FSettings.Background);
end;

procedure TForm1.SaveImageQuery(FilterIndex: Integer);
  procedure SaveAs(Bmp: TBitmap; const Filename: TFilename; WhiteBK: Boolean = false; SP: Integer = -1);
  var
    CodecSP: TBitmapCodecSaveParams;
    BmpSurf: TBitmapSurface;
    Bmp2: TBitmap;
  begin
    BmpSurf := TBitmapSurface.Create;
    try
      Bmp2 := TBitmap.Create;
      try
        if WhiteBK
          then DrawTo(FData, FSettings, Bmp2, TAlphaColorRec.White, 2)
          else DrawTo(FData, FSettings, Bmp2, NullColor, 2);
        BmpSurf.Assign(Bmp2);
      finally
        Bmp2.Free;
      end;
      CodecSp.Quality := SP;
      if SP >= 0
        then TBitmapCodecManager.SaveToFile(FileName, BmpSurf, @CodecSP)
        else TBitmapCodecManager.SaveToFile(FileName, BmpSurf);
    finally
      BmpSurf.Free;
    end;
  end;

var
  Ext, Filename: TFilename;
begin
  case FilterIndex of
    2: Ext := '.png';
    3: Ext := '.tif';
    4: Ext := '.jpg';
    else Ext := '.svg';
  end;
  // MacOS always change files without Ext to SVG, can't find a fix yet
  {$IFNDEF MacOS}
  SaveDialog1.FilterIndex := FilterIndex;
  {$ENDIF}
  if SaveDialog1.FileName <> ''
    then SaveDialog1.FileName := string(SaveDialog1.FileName).ChangeFileExt(Ext)
    else SaveDialog1.FileName := 'Untitled' + Ext;
  if SaveDialog1.Execute then
  begin
    {$IFDEF MacOS}
    Filename := string(SaveDialog1.FileName).ChangeFileExt(Ext);
    {$ELSE}
    Filename := SaveDialog1.FileName;
    {$ENDIF}
    Ext := string(string(FileName).ExtractFileExt).ToLowerA;
    if Ext = '.png'
      then SaveAs(imPlot.Bitmap, FileName)
    else if (Ext = '.tif') or (Ext = '.tiff')
      then SaveAs(imPlot.Bitmap, FileName)
    else if (Ext = '.jpg') or (Ext = '.jpeg')
      then SaveAs(imPlot.Bitmap, FileName, True, 90)
    else begin
      if Ext <> '.svg' then
        FileName := string(FileName).ChangeFileExt('.svg');
      SaveSVG(FData, FSettings, FileName);
    end;

    SaveDialog1.InitialDir := string(SaveDialog1.FileName).ExtractFilePath;
    SaveDialog1.FileName := string(FileName).ExtractFileName;
  end;
end;
{$ENDREGION}

end.
