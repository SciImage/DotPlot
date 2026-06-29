unit wc.Platform.Mac;

// For Delphi 12 and above, since then NativeInt is a weak alias of Integer/Int64, avoiding some mess

{$I wc.Base.inc}

interface

(* Delphi's StrToNSStr creates a temporary interface which may be released immediately after the call expression
   Codes like M.addObject(StrToNSStr(Strings[i])); raise access violation very often.
   Read MacString.CreateArray for the solution
*)

uses
  SysUtils, Classes,
  Macapi.CoreFoundation, Macapi.Foundation, Macapi.Helpers, Macapi.CocoaTypes,
  Macapi.ObjectiveC, Macapi.ObjCRuntime, Macapi.AppKit, FMX.Platform.Mac,
  wc.Types, wc.Base;

type
{$REGION 'MacString'}
  MacString = record
  public
    type
      SPString = record
      private
        FValue: CFStringRef;
      public
        class operator Initialize(out Dest: SPString);
        class operator Finalize(var Dest: SPString);
        class operator Assign(var Dest: SPString; const [ref] Src: SPString); // Do nothing
        class operator Implicit(Sp: SPString): CFStringRef;               inline;
        class operator Explicit(Sp: SPString): CFStringRef;               inline;
        class function Create(Value: CFStringRef): SPString;              static;
      end;
  public
    class function CreateCFS(const s: String): CFStringRef;                     static;
    class function CreateCFSCopy(const s: String): CFStringRef;                 static;
    class function CreateCFMS(const s: String): CFMutableStringRef;             static;
    class function CFSTR(const s: string): SPString;                            static;
    class function ToString(const cfs: CFStringRef): String;                    overload; static;
    class function ToString(const cfms: CFMutableStringRef): String;            overload; static; inline;
    class function ToString(const nss: NSString): String;                       overload; static;
    class function CreateArray(const Strings: array of string): NSArray;        static;
    class function StringTransform(S: CFMutableStringRef; range: PCFRange; transform: CFStringRef; reverse: Boolean): Boolean; overload; static; inline;
    class function StringTransform(var S: String; transform: CFStringRef; reverse: Boolean): Boolean; overload; static; inline;
    class function StringTransform(var S: String; const transform: String): Boolean; overload; static; inline;
  end;
{$ENDREGION}

{$REGION 'MacDatetime'}
  MacDatetime = record
    class function CreateCFD(const dt: TDateTime): CFDateRef;                   static;
    class function CreateNDS(const dt: TDateTime): NSDate;                      static;
    class function ToDateTime(const CFD: CFDateRef): TDateTime;                 overload; static;
    class function ToDateTime(const NSD: NSDate): TDateTime;                    overload; static;
    class function ToDate(const CFD: CFDateRef): TDateTime;                     overload; static; inline;
    class function ToDate(const NSD: NSDate): TDateTime;                        overload; static; inline;
    class function ToTime(const CFD: CFDateRef): TDateTime;                     overload; static; inline;
    class function ToTime(const NSD: NSDate): TDateTime;                        overload; static; inline;
  end;
{$ENDREGION}

{$REGION 'MacNumber'}
  MacNumber = record
    class function Create(const Float: Float32): CFNumberRef;                   overload; static;
    class function Create(const Float: Float64): CFNumberRef;                   overload; static;
    class function Create(const Int: Int32): CFNumberRef;                       overload; static;
    class function Create(const Int: Int64): CFNumberRef;                       overload; static;
    class function ToFloat32(const cfn: CFNumberRef): Float32;                  overload; static;
    class function ToFloat64(const cfn: CFNumberRef): Float64;                  overload; static;
    class function ToInt32(const cfn: CFNumberRef): Int32;                      overload; static;
    class function ToInt64(const cfn: CFNumberRef): Int64;                      overload; static;
  end;
{$ENDREGION}

// NOT WORKING
// procedure SetAppFileHanlder(OnOpenFiles: TFilesEvent);

function RunAppleScript(const s: string): Boolean;

const
  CoreServicesLib = '/System/Library/Frameworks/CoreServices.framework/CoreServices';

implementation

uses
  DateUtils, System.RTLConsts, System.Messaging,
  FMX.Forms, FMX.Helpers.Mac;

{$REGION 'TMyApplicationDelegate'}
// NOT WORKING

type
  TMyApplicationDelegate = class(TOCLocal, NSApplicationDelegate)
  private
    class var FOnOpenFiles: TFilesEvent;
    class var Delegate: TMyApplicationDelegate;
  public
    // From FMX.platform.Mac
    function applicationShouldTerminate(Notification: NSNotification): NSInteger; cdecl;
    procedure applicationWillTerminate(Notification: NSNotification); cdecl;
    procedure applicationDidFinishLaunching(Notification: NSNotification); cdecl;
    function applicationDockMenu(sender: NSApplication): NSMenu; cdecl;
    procedure applicationDidHide(Notification: NSNotification); cdecl;
    procedure applicationDidUnhide(Notification: NSNotification); cdecl;
    procedure onMenuClicked(sender: NSMenuItem); cdecl;
    function applicationSupportsSecureRestorableState(app: NSApplication): Boolean; cdecl;

    // My handlers
    procedure application_openFiles(sender: NSApplication; filenames: NSArray); cdecl;

    constructor Create;  // Always use Delegate even if created many times
  end;

procedure SetAppFileHanlder(OnOpenFiles: TFilesEvent);
begin
  if not Assigned(TMyApplicationDelegate.Delegate) then
  begin
    TMyApplicationDelegate.Delegate := TMyApplicationDelegate.Create;
    var NSApp := TNSApplication.Wrap(TNSApplication.OCClass.sharedApplication);
    NSApp.setDelegate(TMyApplicationDelegate.Delegate);
  end;
  TMyApplicationDelegate.FOnOpenFiles := OnOpenFiles;
end;

{ TMyApplicationDelegate }

{$REGION 'From FMX.Platform.Mac, with one change'}
function SendOSXMessage(const Sender: TObject; const OSXMessageClass: TOSXMessageClass; const NSSender: NSObject): NSObject;
var
  MessageObject: TOSXMessageObject;
begin
  if OSXMessageClass = nil then
    raise EArgumentNilException.Create(SArgumentNil);
  MessageObject := TOSXMessageObject.Create(NSSender);
  try
    TMessageManager.DefaultManager.SendMessage(Sender, OSXMessageClass.Create(MessageObject, False), True);
    Result := MessageObject.ReturnValue;
  finally
    MessageObject.Free;
  end;
end;

function TMyApplicationDelegate.applicationDockMenu(sender: NSApplication): NSMenu;
var
  ReturnValue: NSObject;
begin
  ReturnValue := SendOSXMessage(Self, TApplicationDockMenuMessage, sender);
  if ReturnValue <> nil then
    Result := ReturnValue as NSMenu
  else
    Result := nil;
end;

function TMyApplicationDelegate.applicationShouldTerminate(Notification: NSNotification): NSInteger;
begin
  if (Application = nil) {or (PlatformCocoa = nil) or PlatformCocoa.Terminating or    // Not checking PlatformCocoa
    PlatformCocoa.DefaultAction('Q', [ssCommand])} then
    Result := NSTerminateNow
  else
    Result := NSTerminateCancel;
end;

function TMyApplicationDelegate.applicationSupportsSecureRestorableState(app: NSApplication): Boolean;
begin
  Result := True;
end;

procedure TMyApplicationDelegate.applicationDidHide(Notification: NSNotification);
begin
end;

procedure TMyApplicationDelegate.applicationWillTerminate(Notification: NSNotification);
begin
  SendOSXMessage(Self, TApplicationWillTerminateMessage, Notification);
end;

procedure TMyApplicationDelegate.applicationDidUnhide(Notification: NSNotification);
begin
end;

procedure TMyApplicationDelegate.onMenuClicked(sender: NSMenuItem);
begin
  SendOSXMessage(Self, TApplicationMenuClickedMessage, sender);
end;

procedure TMyApplicationDelegate.applicationDidFinishLaunching(Notification: NSNotification);
begin
  SendOSXMessage(Self, TApplicationDidFinishLaunchingMessage, Notification);
end;
{$ENDREGION}

constructor TMyApplicationDelegate.Create;
begin
  inherited Create;
end;

procedure TMyApplicationDelegate.application_openFiles(sender: NSApplication; filenames: NSArray);
var
  Files: TFilenames;
begin
  if not Assigned(FOnOpenFiles) then Exit;

  Files.SetLength(filenames.count);
  for var i := 0 to filenames.count - 1 do
    Files[i] :=UTF8ToString(TNSString.Wrap(filenames.objectAtIndex(i)).UTF8String);

  TThread.Queue(nil, procedure
      begin
        FOnOpenFiles(Self, Files);
      end);
end;
{$ENDREGION}

function RunAppleScript(const s: string): Boolean;
var
  Script: NSString;
  AppleScript: NSAppleScript;
  Error: ^NSDictionary;
begin
  Script := StrToNSStr(s);
  AppleScript := TNSAppleScript.Wrap(TNSAppleScript.Alloc.initWithSource(Script));
  Result := AppleScript.executeAndReturnError(PPointer(@Error)) <> nil;
end;

{ MacString.SPString }

class operator MacString.SPString.Assign(var Dest: SPString; const [ref] Src: SPString);
begin
  // do nothing
end;

class operator MacString.SPString.Initialize(out Dest: SPString);
begin
  Dest.FValue := nil;
end;

class operator MacString.SPString.Finalize(var Dest: SPString);
begin
  If Dest.FValue <> nil then CFRelease(Dest.FValue);
end;

class function MacString.SPString.Create(Value: CFStringRef): SPString;
begin
  Result.FValue := Value;
end;

class operator MacString.SPString.Implicit(Sp: SPString): CFStringRef;
begin
  Result := Sp.FValue;
end;

class operator MacString.SPString.Explicit(Sp: SPString): CFStringRef;
begin
  Result := Sp.FValue;
end;


{$REGION 'MacString - Conversion'}
{ MacString }

class function MacString.CreateCFS(const s: String): CFStringRef;
begin
  Result := CFStringCreateWithCharactersNoCopy(nil, PChar(S), System.Length(S), kCFAllocatorNull);
end;

class function MacString.CreateCFSCopy(const s: String): CFStringRef;
begin
  Result := CFStringCreateWithCharacters(nil, PChar(S), System.Length(S));
end;

class function MacString.CFSTR(const s: string): SPString;
begin
  Result := SPString.Create(CreateCFS(s));
end;

class function MacString.CreateCFMS(const s: String): CFMutableStringRef;
var
  CFS: CFStringRef;
begin
  CFS := CreateCFS(s);
  Result := CFStringCreateMutableCopy(nil, System.Length(S) + 1, cfs);
  CFRelease(CFS);
end;

class function MacString.ToString(const cfs: CFStringRef): String;
var
  Range: CFRange;
begin
  if cfs = nil then Exit('');
  Range.location := 0;
  Range.length := CFStringGetLength(cfs);
  SetLength(Result, Range.length);
  CFStringGetCharacters(cfs, Range, PChar(Result));
end;

class function MacString.ToString(const cfms: CFMutableStringRef): String;
begin
  Result := ToString(CFStringRef(cfms));
end;

class function MacString.ToString(const nss: NSString): String;
var
  s: UTF8String;
begin
  s := TNSString.Wrap(nss).UTF8String;
  Result := String(s);
//  Result := NSStrToStr(nss);    // Not working?????
end;

class function MacString.StringTransform(S: CFMutableStringRef; range: PCFRange; transform: CFStringRef; reverse: Boolean): Boolean;
begin
  Result := Macapi.CoreFoundation.CFStringTransform(S, range, transform, reverse);
end;

class function MacString.StringTransform(var S: String; transform: CFStringRef; reverse: Boolean): Boolean;
var
  CFS: CFMutableStringRef;
begin
  CFS := CreateCFMS(S);
  try
    Result := StringTransform(CFS, nil, transform, reverse);
    If Result then S := ToString(CFS);
  finally
    CFRelease(CFS);
  end;
end;

class function MacString.StringTransform(var S: String; const transform: String): Boolean;
var
  CFS: CFStringRef;
begin
  CFS := CreateCFS(transform);
  try
    Result := StringTransform(S, CFS, False);
  finally
    CFRelease(CFS);
  end;
end;

class function MacString.CreateArray(const Strings: array of string): NSArray;
begin
  var M := TNSMutableArray.Create;
  for var i := 0 to High(Strings) do
  begin
    M.addObject(TNSString.Alloc.initWithCharacters(PChar(Strings[i]), Strings[i].Length));
    // M.addObject(StrToNSStr(Strings[i]));  // Cause access violation;
  end;
  Result := M;
end;
{$ENDREGION}

{$REGION 'MacDateTime'}
{ MacDateTime }

class function MacDateTime.CreateCFD(const dt: TDateTime): CFDateRef;
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  gDate: CFGregorianDate;
  cftz: CFTimeZoneRef;
begin
  DecodeDateTime(dt, Year, Month, Day, Hour, Min, Sec, MSec);
  gDate.year := Year;
  gDate.month := Month;
  gDate.day := Day;
  gDate.hour := Hour;
  gDate.minute := Min;
  gDate.second := Sec + MSec / 1000;
  cftz := CFTimeZoneCopyDefault;
  Result := CFDateCreate(nil, CFGregorianDateGetAbsoluteTime(gDate, cftz));
  CFRelease(cftz);
end;

class function MacDateTime.ToDateTime(const CFD: CFDateRef): TDateTime;
var
  gDate: CFGregorianDate;
  cftz: CFTimeZoneRef;
begin
  cftz := CFTimeZoneCopyDefault;
  gDate := CFAbsoluteTimeGetGregorianDate(CFDateGetAbsoluteTime(CFD), cftz);
  CFRelease(cftz);
  Result := EncodeDateTime(gDate.year, gDate.month, gDate.day,
                           gDate.hour, gDate.minute, Trunc(gDate.second), Trunc(gDate.second * 1000) mod 1000);
end;

class function MacDatetime.CreateNDS(const dt: TDateTime): NSDate;
begin
  Result := DateTimeToNSDate(dt);
end;

class function MacDatetime.ToDateTime(const nsd: NSDate): TDateTime;
begin
  Result := NSDateToDateTime(nsd);
end;

class function MacDateTime.ToDate(const CFD: CFDateRef): TDateTime;
begin
  Result := Trunc(ToDateTime(CFD));
end;

class function MacDatetime.ToDate(const nsd: NSDate): TDateTime;
begin
  Result := Trunc(NSDateToDateTime(nsd));
end;

class function MacDateTime.ToTime(const CFD: CFDateRef): TDateTime;
begin
  Result := Frac(ToDateTime(CFD));
end;

class function MacDatetime.ToTime(const nsd: NSDate): TDateTime;
begin
  Result := Frac(NSDateToDateTime(nsd));
end;
{$ENDREGION}

{$REGION 'TCFNumberHelper'}
function CFNumberGetAsDouble(Number: CFNumberRef): Double; inline;
begin
  CFNumberGetValue(Number, kCFNumberFloat64Type, @Result)
end;

function CFNumberGetAsInt32(Number: CFNumberRef): Int32; inline;
begin
  CFNumberGetValue(Number, kCFNumberSInt32Type, @Result)
end;

{ MacNumber }

class function MacNumber.Create(const Float: Float32): CFNumberRef;
begin
  Result := CFNumberCreate(nil, kCFNumberFloat32Type, @Float);
end;

class function MacNumber.Create(const Float: Float64): CFNumberRef;
begin
  Result := CFNumberCreate(nil, kCFNumberFloat64Type, @Float);
end;

class function MacNumber.Create(const Int: Int32): CFNumberRef;
begin
  Result := CFNumberCreate(nil, kCFNumberSInt32Type, @Int);
end;

class function MacNumber.Create(const Int: Int64): CFNumberRef;
begin
  Result := CFNumberCreate(nil, kCFNumberSInt64Type, @Int);
end;

class function MacNumber.ToFloat32(const cfn: CFNumberRef): Float32;
begin
  CFNumberGetValue(cfn, kCFNumberFloat32Type, @Result)
end;

class function MacNumber.ToFloat64(const cfn: CFNumberRef): Float64;
begin
  CFNumberGetValue(cfn, kCFNumberFloat64Type, @Result)
end;

class function MacNumber.ToInt32(const cfn: CFNumberRef): Int32;
begin
  CFNumberGetValue(cfn, kCFNumberSInt32Type, @Result)
end;

class function MacNumber.ToInt64(const cfn: CFNumberRef): Int64;
begin
  CFNumberGetValue(cfn, kCFNumberSInt64Type, @Result)
end;
{$ENDREGION}

end.
