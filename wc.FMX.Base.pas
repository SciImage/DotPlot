unit wc.FMX.Base;

// For Delphi 12 and above, since then NativeInt is a weak alias of Integer/Int64, avoiding some mess

{$I wc.Base.inc}

interface

uses
  System.Types, System.Rtti, System.SysUtils, System.Classes, System.UITypes, System.Actions,
  FMX.Types, FMX.Platform, FMX.Controls, FMX.ActnList, FMX.StdCtrls, FMX.Forms, FMX.Menus,
  FMX.Header, FMX.Grid, FMX.Colors, FMX.Ani,
  wc.Types, wc.Base;

type
{$REGION 'fez'}
  fez = record
    class function Align(const Left, TotalW, Width: Float32; Alignment: TTextAlign): Float32;   overload; static;
    class function Align(const Left, TotalW, Width: Float64; Alignment: TTextAlign): Float64;   overload; static;
    class function SigmoidRatio(const Range, Gamma: Float64): Float64;                                 static;
  end;
{$ENDREGION}

{$REGION 'TTaskScheduler'}
  TTaskScheduler = record
  // ID is case-sensitive and whitespace-sensitive
  // There is only one handler with one name, the old handler is removed
  private
    class var FTimers: TObjects;
    class var FLock: TObject;
    class constructor Create;
    class destructor Destroy;
    class function IndexOf(const ID: string): NInt;                             overload; static;
    class function IndexOf(ATimer: TTimer): NInt;                               overload; static;
    class procedure RemoveTimer(ATimer: TTimer);                                static;
  public
    // Delay ms milliseconds and execute Proc.
    class procedure Run(ms: NInt; Proc: TProc);                                 overload; static;
    // Delay ms milliseconds and execute Proc; May be cancelled by Remove(ID).
    class procedure Run(const ID: string; ms: NInt; Proc: TProc);               overload; static;
    // Repeatedly execute Proc until it is cancelled by Remove(ID).
    class procedure RepeatRun(const ID: string; Interval: NInt; Proc: TProc);   overload; static;
    // Execute Proc RepeatTime times.
    class procedure RepeatRun(RepeatTime, Interval: NInt; Proc: TProc);         overload; static;
    // Cancal MayRun/RepeatRun with ID
    class function  Remove(const ID: string): Boolean;                          static;
  end;
{$ENDREGION}

{$REGION 'TSystemKey/TSystemKeys: Modifier keys on keyboard'}
  // While these look similar to Helper for TShiftStateHelper, it tests the state of keys on the keyboard
  TSystemKey = (Major, Shift, Alt, Minor);
  TSystemKeyHelper = record helper for TSystemKey
  const
    {$IFDEF MSWINDOWS}
    Control = TSystemKey.Major;
    Windows = TSystemKey.Minor;
    {$ENDIF}
    {$IFDEF MACOS}
    Command = TSystemKey.Major;
    Option  = TSystemKey.Alt;
    Control = TSystemKey.Minor;
    {$ENDIF}
  end;
  TSystemKeys = set of TSystemKey;
  TSystemKeysHelper = record helper for TSystemKeys
    class function PressedKeys: TSystemKeys;          static;
    class function IsShiftPressed: Boolean;           static;
    class function IsMajorModifierPressed: Boolean;   static;
    class function IsAltPressed: Boolean;             static;
    class function IsMinorModifierPressed: Boolean;   static;
    class function IsFunctionPressed: Boolean;        static;
    class function IsCapsLockOn: Boolean;             static;
    class function IsNumLockOn: Boolean;              static;

    function ToShiftState: TShiftState;
  end;
{$ENDREGION}

// Helpers for FMX classes

{$REGION 'TColorComboBoxHelper'}
type
  TColorComboBoxHelper = class helper for TColorComboBox
  public
    procedure SetApproxColor(const Value: TAlphaColor);
  end;
{$ENDREGION}

{$REGION 'TControlHelper'}
  TControlHelper = class helper for TControl
  public
    function RelativePosition(RefControl: TControl): TPointF;
    function RelativeBoundsRect(RefControl: TControl): TRectF;
    function UsedClientRect: TRectF;            // No including Margins and hidden controls
    function GetControlByClass(AClass: TClass; Recrusive: Boolean): TControl;
    function GetControlsByClass(AClass: TClass; Recrusive: Boolean = False): TArray<TControl>;
  end;
{$ENDREGION}

{$REGION 'TForm'}
  // This adds NormalBounds for bounds when the form is not maxmized/minimized
  // It also adds a onMove event
  TForm = class(FMX.Forms.TForm)
  private
    FNormalBounds: TRect;
    FLastBounds: TRect;
    FOnMove: TNotifyEvent;
    FOnSizeAnimation, FOnSizeAnimated: TNotifyEvent;
    {$IFDEF MacOS}
    FShouldMaximize: Boolean;           // WindowState  := wsMaximized in OnCreate works in Windows but not MacOS, this fix it
    {$ENDIF}
    function GetNormalBottom: NInt;
    function GetNormalHeight: NInt;
    function GetNormalLeft: NInt;
    function GetNormalRight: NInt;
    function GetNormalTop: NInt;
    function GetNormalWidth: NInt;
    function GetRelMonPosX: Single;
    function GetRelMonPosY: Single;
    procedure SetRelMonPosX(const Value: Single);               inline;
    procedure SetRelMonPosY(const Value: Single);               inline;
    procedure _SetRelativeMoninotPosition(const RelX, RelY, Width, Height: Single); overload;
  protected
    // procedure Resize; override;
    {$IFDEF MacOS}
    procedure DoShow; override;
    procedure DoClose(var CloseAction: TCloseAction); override;
    {$ENDIF}
  public
    procedure SetBoundsF(const ALeft, ATop, AWidth, AHeight: Single); override;
    procedure AfterConstruction; override;
    procedure UpdateNormalBounds;
    procedure SnapToEdge(Left, Top: Single; const SnapBuffer: NInt = 24);
    procedure SetRelativeMoninotPosition(const RelX, RelY: Single); overload;inline;
    procedure SetRelativeMoninotPosition(const RelX, RelY, Width, Height: Single); overload; inline;
    procedure SetRelativeMoninotPositionIfSnapped(const RelX, RelY: Single); overload; inline;
    procedure SetRelativeMoninotPositionIfSnapped(const RelX, RelY, Width, Height: Single); overload;

    function BoundsWithoutShadow: TRectF;                       {$IFNDEF MSWINDOWS}inline;{$ENDIF}
    function WorkAreaRect: TRectF;                              inline;

    property RelativeMonitorPositionX: Single   read GetRelMonPosX      write SetRelMonPosX;
    property RelativeMonitorPositionY: Single   read GetRelMonPosY      write SetRelMonPosY;
    property NormalBounds: TRect                read FNormalBounds;
    property NormalLeft: NInt                   read GetNormalLeft;
    property NormalTop: NInt                    read GetNormalTop;
    property NormalWidth: NInt                  read GetNormalWidth;
    property NormalHeight: NInt                 read GetNormalHeight;
    property NormalRight: NInt                  read GetNormalRight;
    property NormalBottom: NInt                 read GetNormalBottom;
    property OnMove: TNotifyEvent               read FOnMove            write FOnMove;
    property OnSizeAnimation: TNotifyEvent      read FOnSizeAnimation   write FOnSizeAnimation;
    property OnSizeAnimated: TNotifyEvent       read FOnSizeAnimated    write FOnSizeAnimated;
  end;
{$ENDREGION}

const
{$IFDEF MacOS}
  Wheel_Delta = 30;     // WheelDelta is in 1/8 degree; most mouse work in steps of 15 degrees
  MacAppMenu  = 'AppMenu';
{$ENDIF}
{$IFDEF MSWINDOWS}
  Wheel_Delta = 120;
{$ENDIF}

implementation

uses
  {$IFDEF MSWINDOWS}
  Windows, FMX.Platform.Win, Winapi.Dwmapi,
  {$ENDIF}
  {$IFDEF MACOS}
  Macapi.CocoaTypes,
  Macapi.ObjectiveC, Macapi.Foundation, Macapi.AppKit,
  Macapi.ObjCRuntime, Macapi.Helpers,
  {$ENDIF}
  System.UIConsts, FMX.Utils, FMX.DialogService,
  wc.Consts, wc.FMX.Clipboard;

resourcestring
  SMenuItemNotCreated    = 'Menu item/ToolButton must be created before making any changes.';

{$REGION 'fez'}
class function fez.Align(const Left, TotalW, Width: Float64; Alignment: TTextAlign): Float64;
begin
  if Alignment = TTextAlign.Leading
    then Result := Left
  else if Alignment = TTextAlign.Center
    then Result := Left + (TotalW - Width) / 2
    else Result := Left + (TotalW - Width);
end;

// SigmoidRatio return a S-shape curve; both the domain and the range are [0, 1]
// Besides ArcTan, other Sigmoid functions, like logistic, Tanh, Gudermannian functions can also be used.
// the results approaches a straight line when Range approaches 0; The middle part becomes steep when Range >= 10

class function fez.SigmoidRatio(const Range, Gamma: Float64): Float64;
begin
  if Gamma <= 0 then Exit (0);
  if Gamma >= 1 then Exit (1);
  Exit(ArcTan((Gamma - 0.5) * 2 * Range) / ArcTan(Range) / 2 + 0.5);
end;

class function fez.Align(const Left, TotalW, Width: Float32; Alignment: TTextAlign): Float32;
begin
  if Alignment = TTextAlign.Leading
    then Result := Left
  else if Alignment = TTextAlign.Center
    then Result := Left + (TotalW - Width) / 2
    else Result := Left + (TotalW - Width);
end;
{$ENDREGION}

{$REGION 'TTaskScheduler'}
type
  TTaskSchedulerTimer = class(TTimer)
  private
    FProc: TProc;
    procedure TimerHandler(Sender: TObject);
    procedure KillSelf;
  public
    constructor Create(const ID: string; Interval, Times: NInt; Proc: TProc); reintroduce;
  end;

{ TTaskSchedulerTimer }

constructor TTaskSchedulerTimer.Create(const ID: string; Interval, Times: NInt; Proc: TProc);
begin
  inherited Create(nil);
  Enabled := False;
  TagString := ID;
  Tag := Times;
  Self.Interval := Interval;
  FProc := Proc;
  OnTimer := TimerHandler;
end;

procedure TTaskSchedulerTimer.TimerHandler(Sender: TObject);
begin
  FProc;
  if Tag < 0 then KillSelf else
  if Tag > 0 then
  begin
    Tag := Tag - 1;
    if Tag = 0 then KillSelf;
  end;
end;

procedure TTaskSchedulerTimer.KillSelf;
begin
  Enabled := False;
  TTaskScheduler.RemoveTimer(Self);
  DelayFree;
end;

{ TTaskScheduler }

class constructor TTaskScheduler.Create;
begin
  FLock := TObject.Create;
end;

class destructor TTaskScheduler.Destroy;
var
  i: NInt;
begin
  TMonitor.Enter(FLock);
  try
    for i := 0 to Length(FTimers) - 1 do
      FreeAndNil(FTimers[i]);
    FTimers := nil;
  finally
    TMonitor.Exit(FLock);
  end;
  FreeAndNil(FLock);
end;

class function TTaskScheduler.IndexOf(ATimer: TTimer): NInt;
var
  i: NInt;
begin
  for i := 0 to Length(FTimers) - 1 do
    if FTimers[i] = ATimer then Exit(i);
  Result := -1;
end;

class function TTaskScheduler.IndexOf(const ID: string): NInt;
var
  i: NInt;
begin
  if ID = '' then Exit(-1);
  for i := 0 to Length(FTimers) - 1 do
    if TTaskSchedulerTimer(FTimers[i]).TagString = ID then Exit(i);
  Result := -1;
end;

class procedure TTaskScheduler.RemoveTimer(ATimer: TTimer);
var
  i: NInt;
begin
  TMonitor.Enter(FLock);
  try
    i := IndexOf(ATimer);
    if i >= 0 then FTimers.Delete(i);
  finally
    TMonitor.Exit(FLock);
  end;
end;

class function TTaskScheduler.Remove(const ID: string): Boolean;
var
  Timer: TTaskSchedulerTimer;
  i: NInt;
begin
  TMonitor.Enter(FLock);
  try
    i := IndexOf(ID);
    if i < 0 then Exit(False);
    Timer := TTaskSchedulerTimer(FTimers[i]);
    FreeAndNil(Timer);
    FTimers.Delete(i);
    Result := True;
  finally
    TMonitor.Exit(FLock);
  end;
end;

class procedure TTaskScheduler.Run(ms: NInt; Proc: TProc);
var
  Timer: TTaskSchedulerTimer;
begin
  TMonitor.Enter(FLock);
  try
    Timer := TTaskSchedulerTimer.Create('', ms, -1, Proc);       // -1: Run once
    FTimers.Add(Timer);         // Always Add it so that it can be freed if not finished
    Timer.Enabled := True;
  finally
    TMonitor.Exit(FLock);
  end;
end;

class procedure TTaskScheduler.Run(const ID: string; ms: NInt; Proc: TProc);
var
  Timer: TTaskSchedulerTimer;
  i: NInt;
begin
  TMonitor.Enter(FLock);
  try
    i := IndexOf(ID);
    if i >= 0 then
    begin
      Timer := TTaskSchedulerTimer(FTimers[i]);
      Timer.Enabled := False;
      Timer.TagString := ID;
      Timer.Tag := -1;          // Run once
      Timer.FProc := Proc;
      Timer.Interval := ms;
    end else
    begin
      Timer := TTaskSchedulerTimer.Create(ID, ms, -1, Proc);
      FTimers.Add(Timer);
    end;
    Timer.Enabled := True;
  finally
    TMonitor.Exit(FLock);
  end;
end;

class procedure TTaskScheduler.RepeatRun(const ID: string; Interval: NInt; Proc: TProc);
var
  Timer: TTaskSchedulerTimer;
  i: NInt;
begin
  TMonitor.Enter(FLock);
  try
    i := IndexOf(ID);
    if i >= 0 then
    begin
      Timer := TTaskSchedulerTimer(FTimers[i]);
      Timer.Enabled := False;
      Timer.TagString := ID;
      Timer.Tag := 0;           // Run infinitively
      Timer.FProc := Proc;
      Timer.Interval := Interval;
    end else
    begin
      Timer := TTaskSchedulerTimer.Create(ID, Interval, 0, Proc);
      FTimers.Add(Timer);
    end;
    Timer.Enabled := True;
  finally
    TMonitor.Exit(FLock);
  end;end;

class procedure TTaskScheduler.RepeatRun(RepeatTime, Interval: NInt; Proc: TProc);
var
  Timer: TTaskSchedulerTimer;
begin
  if RepeatTime <=0 then exit;
  TMonitor.Enter(FLock);
  try
    Timer := TTaskSchedulerTimer.Create('', Interval, RepeatTime, Proc );
    FTimers.Add(Timer);
    Timer.Enabled := True;
  finally
    TMonitor.Exit(FLock);
  end;
end;
{$ENDREGION}

{$REGION 'Keyboard and Mouse'}
{ TSystemKeysHelper }

class function TSystemKeysHelper.PressedKeys: TSystemKeys;
{$IFDEF MSWINDOWS}
begin
  Result := [];
  if GetKeyState(VK_SHIFT) and $8000 <> 0
    then Include(Result, TSystemKey.Shift);
  if GetKeyState(VK_CONTROL) and $8000 <> 0
    then Include(Result, TSystemKey.Control);
  if GetKeyState(VK_MENU) and $8000 <> 0
    then Include(Result, TSystemKey.Alt);
  if (GetKeyState(VK_LWIN) and $8000 <> 0) or (GetKeyState(VK_RWIN) and $8000 <> 0)
    then Include(Result, TSystemKey.Windows);
end;
{$ENDIF}
{$IFDEF MACOS}
var
  Keys: NSUInteger;
begin
  // Keys := TNSApplication.Wrap(TNSApplication.OCClass.sharedApplication).currentEvent.modifierFlags;
  Keys := TNSEvent.OCClass.modifierFlags;
  Result := [];
  if Keys and NSShiftKeyMask <> 0
    then Include(Result, TSystemKey.Shift);
  if Keys and NSCommandKeyMask <> 0
    then Include(Result, TSystemKey.Command);
  if Keys and NSAlternateKeyMask <> 0
    then Include(Result, TSystemKey.Alt);
  if Keys and NSControlKeyMask <> 0
    then Include(Result, TSystemKey.Control);
end;
{$ENDIF}

function TSystemKeysHelper.ToShiftState: TShiftState;
begin
  Result := [];
  if TSystemKey.Shift in Self then Include(Result, ssShift);
  if TSystemKey.Alt in Self then Include(Result, ssAlt);
  if TSystemKey.Control in Self then Include(Result, ssCtrl);
  {$IFDEF MacOS}
  if TSystemKey.Command in Self then Include(Result, ssCommand);
  {$ENDIF}
end;

class function TSystemKeysHelper.IsShiftPressed: Boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := (GetKeyState(VK_SHIFT) and $8000) <> 0;
  {$ENDIF}
  {$IFDEF MACOS}
  Result := (TNSEvent.OCClass.modifierFlags and NSShiftKeyMask) <> 0;
  // Result := (TNSApplication.Wrap(TNSApplication.OCClass.sharedApplication).currentEvent.modifierFlags and NSShiftKeyMask) <> 0;
  {$ENDIF}
end;

class function TSystemKeysHelper.IsMajorModifierPressed: Boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := (GetKeyState(VK_CONTROL) and $8000) <> 0;
  {$ENDIF}
  {$IFDEF MACOS}
  Result := (TNSEvent.OCClass.modifierFlags and NSCommandKeyMask) <> 0;
  // Result := (TNSApplication.Wrap(TNSApplication.OCClass.sharedApplication).currentEvent.modifierFlags and NSCommandKeyMask) <> 0;
  {$ENDIF}
end;

class function TSystemKeysHelper.IsMinorModifierPressed: Boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := (GetKeyState(VK_LWIN) and $8000 <> 0) or (GetKeyState(VK_RWIN) and $8000 <> 0);
  {$ENDIF}
  {$IFDEF MACOS}
  Result := (TNSEvent.OCClass.modifierFlags and NSControlKeyMask) <> 0;
  // Result := (TNSApplication.Wrap(TNSApplication.OCClass.sharedApplication).currentEvent.modifierFlags and NSControlKeyMask) <> 0;
  {$ENDIF}
end;

class function TSystemKeysHelper.IsAltPressed: Boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := (GetKeyState(VK_MENU) and $8000) <> 0;
  {$ENDIF}
  {$IFDEF MACOS}
  Result := (TNSEvent.OCClass.modifierFlags and NSAlternateKeyMask) <> 0;
  // Result := (TNSApplication.Wrap(TNSApplication.OCClass.sharedApplication).currentEvent.modifierFlags and NSAlternateKeyMask) <> 0;
  {$ENDIF}
end;

class function TSystemKeysHelper.IsFunctionPressed: Boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := false;      // not possible
  {$ENDIF}
  {$IFDEF MACOS}
  Result := (TNSEvent.OCClass.modifierFlags and NSFunctionKeyMask) <> 0;
  // Result := (TNSApplication.Wrap(TNSApplication.OCClass.sharedApplication).currentEvent.modifierFlags and NSFunctionKeyMask) <> 0;
  {$ENDIF}
end;

class function TSystemKeysHelper.IsCapsLockOn: Boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := (GetKeyState(VK_CAPITAL) and 1) <> 0;
  {$ENDIF}
  {$IFDEF MACOS}
  Result := (TNSEvent.OCClass.modifierFlags and NSAlphaShiftKeyMask) <> 0;
  // Result := (TNSApplication.Wrap(TNSApplication.OCClass.sharedApplication).currentEvent.modifierFlags and NSAlphaShiftKeyMask) <> 0;
  {$ENDIF}
end;

class function TSystemKeysHelper.IsNumLockOn: Boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := (GetKeyState(VK_NUMLOCK) and 1) <> 0;
  {$ENDIF}
  {$IFDEF MACOS}
  Result := false;
  {$ENDIF}
end;
{$ENDREGION}

{$REGION 'TColorComboBoxHelper'}
{ TColorComboBoxHelper }

procedure TColorComboBoxHelper.SetApproxColor(const Value: TAlphaColor);
var
  i, minI: NInt;
  c: Int32;  // TAlphaColor
  r, g, b, dr, dg, db: Int32;
  Min, d: Int32;
begin
  Min := $FFFFFF;
  minI := 0;
  r := (Value and $FF_00_00) shr 16;
  g := (Value and $FF_00) shr 8;
  b := (Value and $FF);

  for i := 0 to Self.Count - 1 do
  begin
    c := Int32(StringToAlphaColor(Items[i]));
    dr := (c and $FF_00_00) shr 16 - r;
    dg := (c and $FF_00) shr 8 - g;
    db := b - c and $FF;
    d := Abs(dr) + Abs(dg) + Abs(db);// dr * dr + dg * dg + db * db;
    if d < Min then
    begin
      minI := i;
      Min := d;
    end;
  end;
  ItemIndex := minI;
end;
{$ENDREGION}

{$REGION 'TControlHelper'}
{ TControlHelper }

function TControlHelper.RelativePosition(RefControl: TControl): TPointF;
begin
  Result := Self.LocalToScreen(PointF(0, 0)) - RefControl.LocalToScreen(PointF(0, 0));
end;

function TControlHelper.UsedClientRect: TRectF;
var
  j: Nint;
begin
  j := -1;
  for var i := 0 to ControlsCount - 1 do
    if Controls[i].IsVisible then
    begin
      j := i;
      break;
    end;

  if j < 0
    then Result := TRectF.Empty
    else Result := Controls[j].BoundsRect;
  for var i := j + 1 to ControlsCount - 1 do
    if Controls[i].IsVisible then
    begin
      var r := Controls[i].BoundsRect;
      if r.Left < Result.Left then Result.Left := r.Left;
      if r.Right > Result.Right then Result.Right := r.Right;
      if r.Top < Result.Top then Result.Top := r.Top;
      if r.Bottom > Result.Bottom then Result.Bottom := r.Bottom;
    end;
end;

function TControlHelper.RelativeBoundsRect(RefControl: TControl): TRectF;
begin
  Result.TopLeft := Self.LocalToScreen(PointF(0, 0)) - RefControl.LocalToScreen(PointF(0, 0));
  Result.Right   := Result.Left + Width;
  Result.Bottom  := Result.Top + Height;
end;

function TControlHelper.GetControlByClass(AClass: TClass; Recrusive: Boolean): TControl;
begin
  for var i := 0 to ControlsCount - 1 do
    if Controls[i] is AClass then Exit(Controls[i]);
  if Recrusive then
    for var i := 0 to ControlsCount - 1 do
    begin
      Result := Controls[i].GetControlByClass(AClass, True);
      if Assigned(Result) then exit;
    end;
  Result := nil;
end;

function TControlHelper.GetControlsByClass(AClass: TClass; Recrusive: Boolean): TArray<TControl>;
var
  l: NInt;

  procedure Test(AControl: TControl);
  begin
    for var i := 0 to AControl.ControlsCount - 1 do
      if AControl.Controls[i] is AClass then
      begin
        SetLength(Result, l + 1);
        Result[l] := AControl.Controls[i];
        inc(l);
      end;
    if Recrusive then
      for var i := 0 to AControl.ControlsCount - 1 do
        Test(AControl.Controls[i]);
  end;
begin
  l := 0;
  Test(Self);
end;
{$ENDREGION}

{$REGION 'TForm'}
{ TForm }

function TForm.WorkAreaRect: TRectF;
begin
  Result := Screen.DisplayFromForm(Self).WorkAreaRect;
end;

function TForm.BoundsWithoutShadow: TRectF;
{$IFDEF MSWINDOWS}
const
  CorrectionT = 0;
  CorrectionL = 1.5;
  CorrectionR = 1.5;
  CorrectionB = 1;
var
  Handle: HWND;
  Rect: TRect;
begin
  Handle := WindowHandleToPlatform(Self.Handle).Wnd;
  if DwmGetWindowAttribute(Handle, DWMWA_EXTENDED_FRAME_BOUNDS, @Rect, SizeOf(Rect)) = S_OK then
  begin
    var ScreenService: IFMXScreenService;
    var Scale: Single;
    if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
    begin
      Scale := 1 / ScreenService.GetScreenScale;
      Result.Left   := Rect.Left * Scale + CorrectionL;
      Result.Top    := Rect.Top * Scale + CorrectionT;
      Result.Right  := Rect.Right * Scale - CorrectionR;
      Result.Bottom := Rect.Bottom * Scale - CorrectionB;
    end;
  end else Result := Self.BoundsF;
end;
{$ELSE}
begin
  Result := Self.BoundsF;
end;
{$ENDIF}

procedure TForm.SnapToEdge(Left, Top: Single; const SnapBuffer: NInt);
begin
  var R := Screen.DisplayFromForm(Self).WorkAreaRect;
  {$IFDEF MSWINDOWS}
  var BR := BoundsWithoutShadow;
  var Width  := BR.Width;
  var Height := BR.Height;
  {$ENDIF}
  if Abs(Left - R.Left) < SnapBuffer
      then Left := R.Left
  else if Abs(Left + Width - R.Right) < SnapBuffer
      then Left := R.Right - Width;
  if Abs(Top - R.Top) < SnapBuffer
    then Top := R.Top
  else if Abs(Top + Height - R.Bottom) < SnapBuffer
    then Top := R.Bottom - Height;
  {$IFDEF MSWINDOWS}
  Left := Left - (Br.Left - Self.Left);
  Top  := Top  - (Br.Top - Self.Top);
  {$ENDIF}
  SetBoundsF(Left, Top, Self.Width, Self.Height);
end;

function TForm.GetRelMonPosX: Single;
begin
  var R := Screen.DisplayFromForm(Self).WorkAreaRect;
  var BR := BoundsWithoutShadow;
  if BR.Width > R.Width - 0.5
    then if BR.Left + BR.Right <= R.Left + R.Right      // Compare the center
      then Exit(0)
      else Exit(1);
  Result := ez.EnsureRange((BR.Left - R.Left) / (R.Width - BR.Width), 0, 1);
end;

function TForm.GetRelMonPosY: Single;
begin
  var R := Screen.DisplayFromForm(Self).WorkAreaRect;
  var BR := BoundsWithoutShadow;
  if BR.Height > R.Height - 0.5
    then if BR.Top + BR.Bottom <= R.Top + R.Bottom
      then Exit(0)
      else Exit(1);
  Result := ez.EnsureRange((BR.Top - R.Top) / (R.Height - BR.Height), 0, 1);
end;

procedure TForm._SetRelativeMoninotPosition(const RelX, RelY, Width, Height: Single);
begin
  var R := Screen.DisplayFromForm(Self).WorkAreaRect;
  var BR := BoundsWithoutShadow;
  var X, Y: Single;
  BR.Right  := BR.Right + Width - Self.Width;
  BR.Bottom := BR.Bottom + Height - Self.Height;

  if RelX < 0 then X := Self.Left else  // Do not change
  begin
    if RelX >= 1 then X := ez.Max(R.Left, R.Right - BR.Width)
    else if BR.Width > R.Width - 0.5
      then X := R.Left
      else X := R.Left + (R.Width - BR.Width) * RelX;
  {$IFDEF MSWINDOWS}
    X := X - (BR.Left - Self.Left);
  {$ENDIF}
  end;

  if RelY < 0 then Y := Self.Top else  // Do not change
  begin
    if RelY >= 1 then Y := ez.Max(R.Left, R.Bottom - BR.Height)
    else if BR.Height > R.Height - 0.5
      then Y := R.Top
      else Y := R.Top + (R.Height - BR.Height) * RelY;
  {$IFDEF MSWINDOWS}
    Y := Y - (BR.Top - Self.Top);
  {$ENDIF}
  end;

  SetBoundsF(X, Y, Width, Height);
end;

procedure TForm.SetBoundsF(const ALeft, ATop, AWidth, AHeight: Single);
begin
  var OldLeft := Self.Left;
  var OldTop := Self.Top;
  inherited;
  if Assigned(FOnMove) and ((OldLeft <> Self.Left) or (OldTop <> Self.Top))
    then FOnMove(Self);
  UpdateNormalBounds;
end;

procedure TForm.SetRelativeMoninotPosition(const RelX, RelY, Width, Height: Single);
begin
  _SetRelativeMoninotPosition(ez.Max(0, RelX), ez.Max(0, RelY), Width, Height);
end;

procedure TForm.SetRelativeMoninotPositionIfSnapped(const RelX, RelY: Single);
begin
  SetRelativeMoninotPositionIfSnapped(RelX, RelY, Width, Height);
end;

procedure TForm.SetRelativeMoninotPositionIfSnapped(const RelX, RelY, Width, Height: Single);
begin
  var R := Screen.DisplayFromForm(Self).WorkAreaRect;
  var BR := BoundsWithoutShadow;
  var X, Y: Single;
  BR.Right  := BR.Right + Width - Self.Width;
  BR.Bottom := BR.Bottom + Height - Self.Height;

  if RelX <= 0.0005 then
    X := R.Left
  else if RelX >= 0.9995 then
    X := ez.Max(R.Left, R.Right - BR.Width)
  else if BR.Left <= R.Left then
    X := R.Left
  else if BR.Right >= R.Right then
    X := ez.Max(R.Left, R.Right - BR.Width)
  else X := BR.Left;
  {$IFDEF MSWINDOWS}
  X := X - (BR.Left - Self.Left);
  {$ENDIF}

  if RelY <= 0.0005 then
    Y := R.Top
  else if RelY >= 0.9995 then
    Y := ez.Max(R.Top, R.Bottom - BR.Height)
  else if BR.Top <= R.Top then
    Y := R.Top
  else if BR.Bottom >= R.Bottom then
    Y := ez.Max(R.Top, R.Bottom - BR.Height)
  else Y := BR.Top;
  {$IFDEF MSWINDOWS}
  Y := Y - (BR.Top - Self.Top);
  {$ENDIF}

  SetBoundsF(X, Y, Width, Height);
  {$IFDEF MSWINDOWS}
  // For some reason the height can be off by 1.......
  if Height > Self.Height then
  begin
    SetBoundsF(X, Y, Width, Height + 0.5);
    if Height > Self.Height then
      SetBoundsF(X, Y, Width, Height + 0.75);
  end;
  {$ENDIF}
end;

procedure TForm.SetRelativeMoninotPosition(const RelX, RelY: Single);
begin
  _SetRelativeMoninotPosition(ez.Max(0, RelX), ez.Max(0, RelY), Width, Height);
end;

procedure TForm.SetRelMonPosX(const Value: Single);
begin
  _SetRelativeMoninotPosition(ez.Max(0, Value), -1, Width, Height);
end;

procedure TForm.SetRelMonPosY(const Value: Single);
begin
  _SetRelativeMoninotPosition(-1, ez.Max(0, Value), Width, Height);
end;

procedure TForm.AfterConstruction;
begin
  FLastBounds   := Bounds;
  FNormalBounds := Bounds;
  inherited;
  {$IFDEF MacOS}
  FShouldMaximize := WindowState = TWindowState.wsMaximized;
  {$ENDIF}
end;

{$IFDEF MacOS}
procedure TForm.DoClose(var CloseAction: TCloseAction);
begin
  inherited;
  // This cause many bugs
//  if (CloseAction = TCloseAction.caFree) or (CloseAction = TCloseAction.caHide) then
//    if Assigned(OnDestroy) then OnDestroy(Self);
end;

procedure TForm.DoShow;
begin
  inherited;
  if FShouldMaximize then
  begin
    WindowState := TWindowState.wsMaximized;
    FShouldMaximize := False;
  end;
end;
{$ENDIF}

procedure TForm.UpdateNormalBounds;
begin
  if (not FullScreen) and (WindowState = TWindowState.wsNormal)
    then FNormalBounds := Bounds;
end;

function TForm.GetNormalBottom: NInt;
begin
  Result := FNormalBounds.Bottom;
end;

function TForm.GetNormalHeight: NInt;
begin
  Result := FNormalBounds.Height;
end;

function TForm.GetNormalLeft: NInt;
begin
  Result := FNormalBounds.Left;
end;

function TForm.GetNormalRight: NInt;
begin
  Result := FNormalBounds.Right;
end;

function TForm.GetNormalTop: NInt;
begin
  Result := FNormalBounds.Top;
end;

function TForm.GetNormalWidth: NInt;
begin
  Result := FNormalBounds.Width;
end;
{$ENDREGION}

end.

