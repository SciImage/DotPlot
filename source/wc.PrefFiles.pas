unit wc.PrefFiles;

// For Delphi 12 and above, since then NativeInt is a weak alias of Integer/Int64, avoiding some mess

{$I wc.Base.inc}

interface

uses
  Types, SysUtils, Classes,
  {$IF Defined(MSWINDOWS)}
    System.Win.Registry, System.IniFiles,
  {$ELSEIF Defined(MACOS)}
    Macapi.CoreFoundation, Macapi.Foundation, System.Mac.CFUtils, wc.Platform.Mac,
  {$ELSEIF Defined(ANDROID)}
  {$ELSE}
  {$ENDIF}
   wc.Types, wc.Base;

type
{$REGION 'TPrefFile'}
(* TPrefFile always uses MySettings.FixedFormats, otherwise will have error when the system locale is changed
   Value is strictly value name. In both Mac and Windows, Value name can contain '\'
   Value name can be empty; Key name cannot eventhough it is supported by Mac
   The Mac implementation uses CF instead of NSUserDefault, because the former can store Data any where
   On Mac, editing plist file will not have an immediate effect because the settings are cached.
     Use "killall -SIGTERM cfprefsd" in Terminal to update
   Mac Keyname can be ''.
  * There are a few difference between the Mac and Windows implementation:
    1) Both key and name are case-insensitive on Windows; that are case sensitive on Mac
    2) '\' can be used as the part of key on Mac, just escape it as '|\'. Use '||' for '|'.
       Using '\\' for '\' is bad idea, like 'A\\\B' can be both 'A\' 'B' and 'A' '\B'
    3) Array is supported on Mac, use 'ArrayName\|[0]' to access the items in an array.
       |[-1]  is the last item; |[-2] is the second last item. |[+] is a new item for write.
  Escape is needed only for Key (but not Value) names on Mac. '|[' is always needed for array items in
  both Key and Value names.
*)
  TPrefFile = class
  private
    const
      Separator = '\';              // Don't change this
    var
      FCurrentKey: string;
      FHistory: TStringArray;
  {$REGION 'Windows'}{$IFDEF MSWINDOWS}
  private
    type
      TRegistry = class(System.Win.Registry.TRegistry);
    var
      FReg: TRegistry;
      FBase: string;
      FKeyOpened: Boolean;
  {$ENDIF}{$ENDREGION}
  {$REGION 'MacOS'}{$IFDEF MACOS}
  protected
    function  DoFindKey(PList: TCFPropertyList;   const Key: string): TCFPropertyList;
    function  DoForceKey(PList: TCFPropertyList;  const Key: string): TCFPropertyList;
    procedure PushKey;
    procedure PopKey;
  public
    function  FindValue(PList: TCFPropertyList; const Key: string): TCFPropertyList;
    function  FindKey(PList: TCFPropertyList;   const Key: string): TCFPropertyList;
    function  ForceKey(PList: TCFPropertyList;  const Key: string): TCFPropertyList;
  private
    type
      TPrefType  = (ptError, ptDict, ptArray, ptString, ptBool, ptNumber, ptDate, ptData);
      TPrefState = (pfEmpty, pfLoaded, pfModified);
      TOpenState = (osOff, osRead, osWrite);
      TPrefItem = record
        PL: CFPropertyListRef;
        Name: string;
        State: TPrefState;
      end;
      TPrefItems = array of  TPrefItem;

    const
      EscapeChar = '|';
    var
      FFileName: TFilename;
      FRoot: TCFPropertyList;
      FCurrent: TCFPropertyList;
      FModified: Boolean;
      FCFHistory: array of TCFPropertyList;

    class procedure ArrayItemNameError(const Key: string);      inline;
    class procedure ArrayIndexError(Index: NInt);               inline;

    procedure WriteValue(const Name: string; Value: CFPropertyListRef; FreeValue: Boolean = True);
    class procedure SeparateFirst(const Key: string; var First, Descendant: string);
    class procedure SeparateLast(const Key: string; var Ancestor, Last: string);
  public
  {$ENDIF}{$ENDREGION}
    procedure RaiseCloseSubKeyError;
    procedure RaiseDeleteCurrentKeyError;
  public
    constructor Create(const Company, AppID: string; ForSave: Boolean = False); overload;
    constructor Create(const AppID: string; ForSave: Boolean = False);          overload;
    constructor Create(ForSave: Boolean = False);                               overload;
    destructor Destroy;                                                         override;

    function  OpenKey(const Key: string): Boolean;
    function  TryOpenKey(const Key: string): Boolean;
    procedure CloseKey;
    function  KeyExists(const Key: string): Boolean;
    procedure DeleteKey(const Key: string);

    function  OpenSubKey(const Key: string): Boolean;
    function  TryOpenSubKey(const Key: string): Boolean;
    procedure CloseSubKey;
    procedure DeleteSubKey(const SubKey: string);

    function  SubKeyCount: NInt;
    function  GetSubKeys: TStringArray;
    function  HasSubKeys: Boolean;                                              inline;
    function  SubKeyExists(const Key: string): Boolean;

    function  ValueCount: NInt;
    function  GetValueNames: TStringArray;
    function  HasValues: Boolean;                                               inline;
    function  ValueExists(const Name: string): Boolean;
    procedure DeleteValue(const Name: string);

    function  ReadBool    (const Name: string; Default: Boolean): Boolean;      inline;
    function  ReadInt32   (const Name: string; Default: Int32): Int32;          inline;
    function  ReadInt64   (const Name: string; Default: Int64): Int64;          inline;
    function  ReadFloat   (const Name: string; Default: Double): Double;        inline;
    function  ReadString  (const Name: string; const Default: string): string;  inline;
    function  ReadDateTime(const Name: string; Default: TDateTime): TDateTime;  inline;
    function  ReadBinary  (const Name: string): TBytes;                         inline;

    function  TryReadBool    (const Name: string; var Value: Boolean): Boolean;
    function  TryReadInt32   (const Name: string; var Value: Int32): Boolean;
    function  TryReadInt64   (const Name: string; var Value: Int64): Boolean;
    function  TryReadFloat32 (const Name: string; var Value: Single): Boolean;  overload;
    function  TryReadFloat64 (const Name: string; var Value: Double): Boolean;  overload;
    function  TryReadString  (const Name: string; var Value: string): Boolean;
    function  TryReadDateTime(const Name: string; var Value: TDateTime): Boolean;
    function  TryReadBinary  (const Name: string; var Buffer; BufSize: NInt): NInt;     overload; // -1: Not Exist; <-1: -(required Buf +1)
    function  TryReadBinary  (const Name: string; var Bytes: TBytes): Boolean;          overload;
    function  TryReadInt     (const Name: string; var Value: Int32): Boolean;   overload; inline;
    function  TryReadInt     (const Name: string; var Value: Int64): Boolean;   overload; inline;
    function  TryReadFloat   (const Name: string; var Value: Double): Boolean;  overload; inline;
    function  TryReadFloat   (const Name: string; var Value: Single): Boolean;  overload; inline;

    function  TryRead   (const Name: string; var Value: Boolean): Boolean;      overload; inline;
    function  TryRead   (const Name: string; var Value: Int32): Boolean;        overload; inline;
    function  TryRead   (const Name: string; var Value: Int64): Boolean;        overload; inline;
    function  TryRead   (const Name: string; var Value: Single): Boolean;       overload; inline;
    function  TryRead   (const Name: string; var Value: Double): Boolean;       overload; inline;
    function  TryRead   (const Name: string; var Value: string): Boolean;       overload; inline;
    function  TryRead   (const Name: string; var Value: TDateTime): Boolean;    overload; inline;
    function  TryRead   (const Name: string; var Bytes: TBytes): Boolean;       overload; inline;

    procedure WriteBool    (const Name: string; Value: Boolean);
    procedure WriteInt32   (const Name: string; Value: Int32);
    procedure WriteInt64   (const Name: string; Value: Int64);
    procedure WriteFloat   (const Name: string; Value: Double);
    procedure WriteString  (const Name: string; const Value: string);
    procedure WriteDateTime(const Name: string; Value: TDateTime);
    procedure WriteBinary  (const Name: string; const Buffer; BufSize: Integer);        overload;
    procedure WriteBinary  (const Name: string; const Bytes: TBytes);                   overload;

    property CurrentKey: string read FCurrentKey;
  end;
{$ENDREGION}

{$IFDEF MacOS}
type
  TCFPropertyListHelper = record helper for TCFPropertyList
    function Exists: Boolean;                   inline;
    function NotExists: Boolean;                inline;
    function IsKey: Boolean;                    inline;
    function IsValue: Boolean;                  inline;
  end;

  TCFDictionaryHelper = record helper for TCFDictionary
    function SafeGetValue(const Key: string): CFPropertyListRef;
  end;
{$ENDIF}

implementation

uses
  System.NetEncoding,
  {$IF Defined(MSWINDOWS)}Windows,
  {$ELSEIF Defined(MACOS)}
  {$ENDIF}
  System.SysConst, System.IOUtils,
  wc.Base.StringWrapper, wc.Consts;

{$REGION 'TCFPropertyListHelper/TCFDictionaryHelper'}{$IFDEF MACOS}
{ TCFPropertyListHelper }

function TCFPropertyListHelper.Exists: Boolean;
begin
  Result := Value <> nil;
end;


function TCFPropertyListHelper.NotExists: Boolean;
begin
  Result := Value = nil;
end;

function TCFPropertyListHelper.IsKey: Boolean;
begin
  if Value = nil then Exit(False);
  var CFID := PropertyListKind;
  Result := (CFID = TCFPropertyListKind.vkDictionary) or (CFID = TCFPropertyListKind.vkDictionary);
end;

function TCFPropertyListHelper.IsValue: Boolean;
begin
  if Value = nil then Exit(False);
  var CFID := PropertyListKind;
  Result := (CFID <> TCFPropertyListKind.vkDictionary) and (CFID <> TCFPropertyListKind.vkDictionary);
end;

{ TCFDictionaryHelper }

function TCFDictionaryHelper.SafeGetValue(const Key: string): CFPropertyListRef;
var
  LKey: TCFString;
begin
  LKey := TCFString.Create(Key);
  try
    if not CFDictionaryGetValueIfPresent(Value, LKey.Value, @Result)
      then Result := nil;
  finally
    CFRelease(LKey.Value);
  end;
end;
{$ENDIF}
{$ENDREGION}

{$REGION 'TPrefFile'}
{ TPrefFile }

{$REGION 'TPrefFile - MacOS'}{$IFDEF MACOS}
class procedure TPrefFile.ArrayItemNameError(const Key: string);
begin
  raise Exception.CreateFmt(SArrayItemNameError, [Key]);
end;

class procedure TPrefFile.ArrayIndexError(Index: NInt);
begin
  raise Exception.CreateFmt(SIndexOutOfRange, [Index]);
end;

constructor TPrefFile.Create(const Company, AppID: string; ForSave: Boolean = False);
begin
  FFileName := TPath.Combine(TPath.GetHomePath, 'Library/Preferences/') +
                ez.IfNotEmpty(Company, Company.ToLower + '.') +
                ez.IfEmpty(AppID, string(ParamStr(0)).ExtractOnlyFileName).Replace(' ', '-').ToLower +
                '.plist';
  // This is a fixed a random bug that newly create TCFPropertyList may failed to save
  if ForSave and not TFile.Exists(FFileName) then
  begin
    var fs := TFileStream.CreateForWrite(FFilename);
    try
      fs.WriteInt32($696C7062);
      fs.WriteInt32($30307473);
      fs.WriteInt32($000008D0);
      fs.WriteInt32($00000000);
      fs.WriteInt32($00000101);
      fs.WriteInt32($00000000);
      fs.WriteInt32($00000100);
      fs.WriteInt32($00000000);
      fs.WriteInt32($00000000);
      fs.WriteInt32($00000000);
      fs.WriteInt16($0900);
    finally
      fs.Free;
    end;
  end;

  if TFile.Exists(FFileName) then
  begin
    FRoot := TCFPropertyList.CreateFromFile(FFileName, kCFPropertyListMutableContainersAndLeaves);
    if FRoot.Value = nil then
      FRoot.Value := CFDictionaryCreateMutable(nil, 0, nil, nil);
  end else FRoot.Value := CFDictionaryCreateMutable(nil, 0, nil, nil);
  FCurrent := FRoot;
end;


destructor TPrefFile.Destroy;
begin
  if FModified and (FFileName <> '') then
    FRoot.SaveToFile(FFilename, kCFPropertyListBinaryFormat_v1_0);
  if FRoot.Exists
    then CFRelease(FRoot.Value);
  inherited;
end;

procedure TPrefFile.PushKey;
begin
  var l := Length(FCFHistory);
  SetLength(FCFHistory, l + 1);
  FCFHistory[l] := FCurrent;
  FHistory.Push(FCurrentKey);
end;

procedure TPrefFile.PopKey;
begin
  var l := Length(FCFHistory);
  if l > 0 then
  begin
    FCurrent := FCFHistory[l - 1];
    SetLength(FCFHistory, l - 1);
    FCurrentKey := FHistory.Pop;
  end else
  begin
    FCurrent := FRoot;
    FCurrentKey := '';
  end;
end;

function TPrefFile.DoFindKey(PList: TCFPropertyList; const Key: string): TCFPropertyList;
begin
  var index: NInt;
  var s, t: string;
  if PList.Value = nil then Exit(nil);
  SeparateFirst(Key, s, t);

  Result := nil;
  if PList.PropertyListKind = TCFPropertyListKind.vkDictionary then
  begin
    var sKey := ez.IfThen(s = '', PList.Value, TCFDictionary(PList).SafeGetValue(s));
    if Assigned(sKey) and (t <> '')
        then Result := DoFindKey(sKey, t)
        else Result := sKey
  end else if (PList.PropertyListKind = TCFPropertyListKind.vkArray) and
               NInt.TryParse(s, Index) and (index > 0) then
  begin
    var Arr := TCFArray(PList);
    if Index <= Arr.Count then
    begin
      var item := CFArrayGetValueAtIndex(Arr.Value, Index - 1);
      if t = ''
        then Result := item
        else Result := DoFindKey(item, t)
    end else Result := nil;
  end else Result := nil;
end;

function TPrefFile.DoForceKey(PList: TCFPropertyList; const Key: string): TCFPropertyList;
begin
  var index: NInt;
  var s, t: string;
  SeparateFirst(Key, s, t);

  if PList.PropertyListKind = TCFPropertyListKind.vkDictionary then
  begin
    var sKey := ez.IfThen(s = '', PList.Value, TCFDictionary(PList).SafeGetValue(s));
    if Assigned(sKey) then
      if t = ''
        then Result := sKey
        else Result := DoForceKey(sKey, t)
    else begin
      var Dict := CFDictionaryCreateMutable(nil, 0, nil, nil);
      TCFDictionary(PList).SetValue(s, Dict);
      sKey := TCFDictionary(PList).SafeGetValue(s);
      if t = ''
        then Result := sKey
        else Result := DoForceKey(sKey, t);
    end;
  end else if (PList.PropertyListKind = TCFPropertyListKind.vkArray) then
  begin
    Result := nil;
    if NInt.TryParse(s, Index) and (index > 0) then
    begin
      var Arr := TCFArray(PList);
      if Index < Arr.Count then
      begin
        var item := CFArrayGetValueAtIndex(Arr.Value, Index - 1);
        if t = ''
          then Result := item
          else Result := DoForceKey(item, t)
      end else if (Index = Arr.Count) then
      begin
        var Dict := CFDictionaryCreateMutable(nil, 0, nil, nil);
        CFArrayAppendValue(Arr.Value, Dict);
        if t = ''
          then Result := CFArrayGetValueAtIndex(Arr.Value, Index)
          else Result := DoForceKey(CFArrayGetValueAtIndex(Arr.Value, Index), t);
      end else ArrayIndexError(Index);
    end else ArrayItemNameError(s);
  end else Result := nil;
end;

function TPrefFile.FindKey(PList: TCFPropertyList; const Key: string): TCFPropertyList;
begin
  Result := DoFindKey(PList, Key);
  if PList.IsValue then Result := nil;
end;

function TPrefFile.ForceKey(PList: TCFPropertyList; const Key: string): TCFPropertyList;
begin
  Result := DoForceKey(PList, Key);
  if PList.IsValue then Result := nil;
end;

function TPrefFile.FindValue(PList: TCFPropertyList; const Key: string): TCFPropertyList;
begin
  var index: NInt;
  var s, t: string;
  SeparateLast(Key, s, t);

  if s <> '' then PList := DoFindKey(PList, s);
  Result := nil;
  if PList.NotExists then Exit;
  if PList.PropertyListKind = TCFPropertyListKind.vkDictionary then
  begin
    Result := TCFDictionary(PList).SafeGetValue(t);
  end else if (PList.PropertyListKind = TCFPropertyListKind.vkArray) and
               NInt.TryParse(s, Index) and (index > 0) then
  begin
    var Arr := TCFArray(PList);
    if Index <= Arr.Count
      then Result := CFArrayGetValueAtIndex(Arr.Value, Index - 1);
  end;

  if Result.IsKey then Result := nil;
end;

function TPrefFile.OpenKey(const Key: string): Boolean;
begin
  FHistory := nil;
  FCFHistory := nil;
  var PList := ForceKey(FRoot, Key);
  if PList.Exists then
  begin
    FCurrent := PList;
    FCurrentKey := Key;
  end else
  begin
    FCurrent := FRoot;
    FCurrentKey := '';
  end;
  Result := PList.Exists;
end;

function  TPrefFile.TryOpenKey(const Key: string): Boolean;
begin
  FHistory := nil;
  var PList := FindKey(FRoot, Key);
  Result := PList.Exists;
  if Result then
  begin
    FCurrent := PList;
    FCurrentKey := Key;
  end else
  begin
    FCurrent := FRoot;
    FCurrentKey := '';
  end;
end;

procedure TPrefFile.CloseKey;
begin
  FHistory := nil;
  FCurrentKey := '';
  FCurrent := FRoot;
end;

function TPrefFile.OpenSubKey(const Key: string): Boolean;
begin
  var PList := ForceKey(FCurrent, Key);
  if PList.Exists then
  begin
    PushKey;
    FCurrent := PList;
  end;
  Result := PList.Exists;
end;

function  TPrefFile.TryOpenSubKey(const Key: string): Boolean;
begin
  var PList := ForceKey(FCurrent, Key);
  Result := PList.Exists;
  if Result then
  begin
    PushKey;
    FCurrent := PList;
  end;
end;

procedure TPrefFile.CloseSubKey;
begin
  PopKey;
end;

function  TPrefFile.KeyExists(const Key: string): Boolean;
begin
  Result := FindKey(FRoot, Key).Exists;
end;

function TPrefFile.SubKeyExists(const Key: string): Boolean;
begin
  Result := FindKey(FCurrent, Key).Exists;
end;

function TPrefFile.ValueExists(const Name: string): Boolean;
begin
  Result := FindValue(FCurrent, Name).Exists;
end;

procedure TPrefFile.DeleteKey(const Key: string);
begin
  if (FCurrentKey = Key) or FCurrentKey.StartsWith(Key + Separator) then
    RaiseDeleteCurrentKeyError;

  var s, t: string;
  var Index: NInt;
  SeparateLast(Key, s, t);
  var Parent := FindKey(FRoot, s);
  if Parent.NotExists then exit;
  if FindKey(Parent, t).NotExists then exit;          // Make sure that it is a key

  if Parent.PropertyListKind = TCFPropertyListKind.vkDictionary then
    TCFDictionary(Parent).SetValue(t, nil)
  else if (Parent.PropertyListKind = TCFPropertyListKind.vkArray) and NInt.TryParse(t, Index) and (index > 0) then
    CFArrayRemoveValueAtIndex(Parent.Value, Index);
end;

procedure TPrefFile.DeleteSubKey(const SubKey: string);
begin
  var s, t: string;
  var Index: NInt;
  SeparateLast(SubKey, s, t);
  var Parent := FindKey(FCurrent, s);
  if Parent.NotExists then exit;
  if FindKey(Parent, t).NotExists then exit;

  if Parent.PropertyListKind = TCFPropertyListKind.vkDictionary then
    TCFDictionary(Parent).SetValue(t, nil)
  else if (Parent.PropertyListKind = TCFPropertyListKind.vkArray) and NInt.TryParse(t, Index) and (index > 0) then
    CFArrayRemoveValueAtIndex(Parent.Value, Index);
end;

procedure TPrefFile.DeleteValue(const Name: string);
begin
  var s, t: string;
  var Index: NInt;
  SeparateLast(Name, s, t);
  var Parent := FindKey(FCurrent, s);
  if Parent.NotExists then exit;
  if FindValue(Parent, t).NotExists then exit;          // Make sure that it is a value

  if Parent.PropertyListKind = TCFPropertyListKind.vkDictionary then
    TCFDictionary(Parent).SetValue(t, nil)
  else if (Parent.PropertyListKind = TCFPropertyListKind.vkArray) and NInt.TryParse(t, Index) and (index > 0) then
    CFArrayRemoveValueAtIndex(Parent.Value, Index);
end;

function TPrefFile.GetSubKeys: TStringArray;
begin
  if FCurrent.PropertyListKind = TCFPropertyListKind.vkDictionary then
  begin
    var LKeys: TArray<CFStringRef>;
    var LValues: TArray<CFPropertyListRef>;
    var LCount := TCFDictionary(FCurrent).Count;
    SetLength(LKeys, LCount);
    SetLength(LValues, LCount);
    CFDictionaryGetKeysAndValues(FCurrent.Value, @LKeys[0], @LValues[0]);

    var l := 0;
    Result.SetLength(l);
    for var i := 0 to LCount - 1 do
    begin
      if TCFPropertyList(LValues[i]).IsKey then
      begin
        Result[l] := TCFString(LKeys[i]).AsString;
        inc(l);
      end;
      CFRelease(LValues[i]);
    end;
    Result.SetLength(l);
  end else if (FCurrent.PropertyListKind = TCFPropertyListKind.vkArray) then
  begin
    var LValues: TArray<CFPropertyListRef>;
    var LCount := TCFArray(FCurrent).Count;

    SetLength(LValues, LCount);
    CFArrayGetValues(FCurrent.Value, CFRangeMake(0, LCount), @LValues[0]);

    var l := 0;
    Result.SetLength(l);
    for var i := 0 to LCount - 1 do
    begin
      if TCFPropertyList(LValues[i]).IsKey then
      begin
        Result[l] := i.ToString;
        inc(l);
      end;
      CFRelease(LValues[i]);
    end;
    Result.SetLength(l);
  end else Result := nil;
end;

function TPrefFile.SubKeyCount: NInt;
begin
  if FCurrent.PropertyListKind = TCFPropertyListKind.vkDictionary then
  begin
    var LKeys: TArray<CFStringRef>;
    var LValues: TArray<CFPropertyListRef>;
    var LCount := TCFDictionary(FCurrent).Count;
    SetLength(LKeys, LCount);
    SetLength(LValues, LCount);
    CFDictionaryGetKeysAndValues(FCurrent.Value, @LKeys[0], @LValues[0]);

    Result := 0;
    for var i := 0 to LCount - 1 do
    begin
      if TCFPropertyList(LValues[i]).IsKey then
        Inc(Result);
      CFRelease(LValues[i]);
    end;
  end else if (FCurrent.PropertyListKind = TCFPropertyListKind.vkArray) then
  begin
    var LValues: TArray<CFPropertyListRef>;
    var LCount := TCFArray(FCurrent).Count;

    SetLength(LValues, LCount);
    CFArrayGetValues(FCurrent.Value, CFRangeMake(0, LCount), @LValues[0]);

    Result := 0;
    for var i := 0 to LCount - 1 do
    begin
      if TCFPropertyList(LValues[i]).IsKey then
        inc(Result);
      CFRelease(LValues[i]);
    end;
  end else Result := 0;
end;

function TPrefFile.GetValueNames: TStringArray;
begin
  if FCurrent.PropertyListKind = TCFPropertyListKind.vkDictionary then
  begin
    var LKeys: TArray<CFStringRef>;
    var LValues: TArray<CFPropertyListRef>;
    var LCount := TCFDictionary(FCurrent).Count;
    SetLength(LKeys, LCount);
    SetLength(LValues, LCount);
    CFDictionaryGetKeysAndValues(FCurrent.Value, @LKeys[0], @LValues[0]);

    var l := 0;
    Result.SetLength(l);
    for var i := 0 to LCount - 1 do
    begin
      if TCFPropertyList(LValues[i]).IsValue then
      begin
        Result[l] := TCFString(LKeys[i]).AsString;
        inc(l);
      end;
      CFRelease(LValues[i]);
    end;
    Result.SetLength(l);
  end else if (FCurrent.PropertyListKind = TCFPropertyListKind.vkArray) then
  begin
    var LValues: TArray<CFPropertyListRef>;
    var LCount := TCFArray(FCurrent).Count;

    SetLength(LValues, LCount);
    CFArrayGetValues(FCurrent.Value, CFRangeMake(0, LCount), @LValues[0]);

    var l := 0;
    Result.SetLength(l);
    for var i := 0 to LCount - 1 do
    begin
      if TCFPropertyList(LValues[i]).IsValue then
      begin
        Result[l] := i.ToString;
        inc(l);
      end;
      CFRelease(LValues[i]);
    end;
    Result.SetLength(l);
  end else Result := nil;
end;

function TPrefFile.ValueCount: NInt;
begin
  if FCurrent.PropertyListKind = TCFPropertyListKind.vkDictionary
    then Result := TCFDictionary(FCurrent).Count - SubKeyCount
  else if (FCurrent.PropertyListKind = TCFPropertyListKind.vkArray)
    then Result := TCFArray(FCurrent).Count - SubKeyCount
    else Result := 0;
end;

function TPrefFile.TryReadBool(const Name: string; var Value: Boolean): Boolean;
begin
  var PList := FindValue(FCurrent, Name);
  Result := (PList.Exists) and (PList.PropertyListKind = TCFPropertyListKind.vkBoolean);
  if Result then
    Value := TCFBoolean(PList).AsBoolean;
end;

function TPrefFile.TryReadInt32(const Name: string; var Value: Int32): Boolean;
begin
  var PList := FindValue(FCurrent, Name);
  Result := (PList.Exists) and (PList.PropertyListKind = TCFPropertyListKind.vkNumber);
  if Result then
    Value := TCFNumber(PList).AsType<Int32>;
end;

function TPrefFile.TryReadInt64(const Name: string; var Value: Int64): Boolean;
begin
  var PList := FindValue(FCurrent, Name);
  Result := (PList.Exists) and (PList.PropertyListKind = TCFPropertyListKind.vkNumber);
  if Result then
    Value := TCFNumber(PList).AsType<Int64>;
end;

function TPrefFile.TryReadFloat64(const Name: string; var Value: Double): Boolean;
begin
  var PList := FindValue(FCurrent, Name);
  Result := (PList.Exists) and (PList.PropertyListKind = TCFPropertyListKind.vkNumber);
  if Result then
    Value := TCFNumber(PList).AsType<Double>;
end;

function TPrefFile.TryReadFloat32(const Name: string; var Value: Single): Boolean;
begin
  var PList := FindValue(FCurrent, Name);
  Result := (PList.Exists) and (PList.PropertyListKind = TCFPropertyListKind.vkNumber);
  if Result then
    Value := TCFNumber(PList).AsType<Single>;
end;

function TPrefFile.TryReadDateTime(const Name: string; var Value: TDateTime): Boolean;
begin
  var PList := FindValue(FCurrent, Name);
  Result := (PList.Exists) and (PList.PropertyListKind = TCFPropertyListKind.vkDate);
  if Result then
    Value := TCFDate(PList).AsTDateTime;
end;

function TPrefFile.TryReadString(const Name: string; var Value: string): Boolean;
begin
  var PList := FindValue(FCurrent, Name);
  Result := (PList.Exists) and (PList.PropertyListKind = TCFPropertyListKind.vkString);
  if Result then
    Value := TCFString(PList).AsString;
end;

function TPrefFile.TryReadBinary(const Name: string; var Buffer; BufSize: NInt): NInt;
begin
  var PList := FindValue(FCurrent, Name);
  if (PList.NotExists) or (PList.PropertyListKind = TCFPropertyListKind.vkData)
    then Exit(-1);

  Result := ez.Min(BufSize, CFDataGetLength(PList.Value));
  if (@Buffer <> nil) and (BufSize > 0) then
    CFDataGetBytes(PList.Value, CFRangeMake(0, Result), @Buffer);
end;

function TPrefFile.TryReadBinary(const Name: string; var Bytes: TBytes): Boolean;
begin
  var PList := FindValue(FCurrent, Name);
  Result := (PList.Exists) and (PList.PropertyListKind = TCFPropertyListKind.vkData);
  if Result then
    Bytes := TCFData(PList).AsTBytes;
end;

procedure TPrefFile.WriteValue(const Name: string; Value: CFPropertyListRef; FreeValue: Boolean);
begin
  FModified := True;
  try
    var s, t: string;
    SeparateLast(Name, s, t);
    var PList := ForceKey(FCurrent, s);
    if PList.Exists then
    begin
      if PList.PropertyListKind = TCFPropertyListKind.vkDictionary then
      begin
        TCFDictionary(PList).SetValue(t, Value);
      end else if (PList.PropertyListKind = TCFPropertyListKind.vkArray) then
      begin
        var Index: NInt;
        if NInt.TryParse(s, Index) and (index > 0) then
        begin
          var Arr := TCFArray(PList);
          if Index <= Arr.Count
            then CFArraySetValueAtIndex(PList.Value, Index, Value)
            else ArrayIndexError(Index);
        end else ArrayItemNameError(s);
      end;
    end;
  finally
    if FreeValue then CFRelease(Value);
  end;
end;

class procedure TPrefFile.SeparateFirst(const Key: string; var First, Descendant: string);
begin
  var p := Key.IndexOf(Separator);
  if p < 0 then
  begin
    First := Key;
    Descendant := '';
  end else
  begin
    First := Key.Substring(0, p);
    Descendant := key.Substring(p + 1);
  end;
end;

class procedure TPrefFile.SeparateLast(const Key: string; var Ancestor, Last: string);
begin
  var p := Key.LastIndexOf(Separator);
  if p < 0 then
  begin
    Ancestor := '';
    Last     := Key;
  end else
  begin
    Ancestor := Key.Substring(0, p);
    Last     := key.Substring(p + 1);
  end;
end;

procedure TPrefFile.WriteBool(const Name: string; Value: Boolean);
begin
  if Value
    then WriteValue(Name, kCFBooleanTrue, False)
    else WriteValue(Name, kCFBooleanFalse, False)
end;

procedure TPrefFile.WriteInt32(const Name: string; Value: Int32);
begin
  WriteValue(Name, MacNumber.Create(Value));
end;

procedure TPrefFile.WriteInt64(const Name: string; Value: Int64);
begin
  WriteValue(Name, MacNumber.Create(Value));
end;

procedure TPrefFile.WriteFloat(const Name: string; Value: Double);
begin
  WriteValue(Name, MacNumber.Create(Value));
end;

procedure TPrefFile.WriteDateTime(const Name: string; Value: TDateTime);
begin
  WriteValue(Name, MacDateTime.CreateCFD(Value));
end;

procedure TPrefFile.WriteString(const Name, Value: string);
begin
  WriteValue(Name, MacString.CreateCFS(Value));
end;

procedure TPrefFile.WriteBinary(const Name: string; const Buffer; BufSize: Integer);
begin
  WriteValue(Name, CFDataCreate(nil, @Buffer, BufSize));
end;

procedure TPrefFile.WriteBinary(const Name: string; const Bytes: TBytes);
begin
  if Bytes = nil
    then WriteValue(Name, CFDataCreate(nil, nil, 0))
    else WriteValue(Name, CFDataCreate(nil, @Bytes[0], Length(Bytes)))
end;
{$ENDIF}{$ENDREGION}

{$REGION 'TPrefFile - Windows'}{$IFDEF MSWINDOWS}
function ProperKey(const s: string): string;
begin
  if s = ''
    then Result := ''
  else if s[Length(s)] = '\'
    then Result := Copy(s, 1, Length(s) - 1)
    else Result := s;;
end;

constructor TPrefFile.Create(const Company, AppID: string; ForSave: Boolean = False);
begin
  FReg := TRegistry.Create;
  FBase := '\Software\' +
             ez.IfNotEmpty(Company, Company + Separator) +
             ez.IfEmpty(AppID, ParamStr(0).ExtractOnlyFileName) + Separator;
  OpenKey('');
end;

destructor TPrefFile.Destroy;
begin
  FreeAndNil(FReg);
end;

function TPrefFile.OpenKey(const Key: string): Boolean;
begin
  FHistory.Clear;
  if FKeyOpened then FReg.CloseKey;
  FCurrentKey := ProperKey(Key);
  Result := FReg.OpenKey(FBase + FCurrentKey, True);
  FKeyOpened := Result;
  if not Result then
  begin
    FCurrentKey := '';
    FReg.OpenKey(FBase + FCurrentKey, True);
  end;
end;

function TPrefFile.TryOpenKey(const Key: string): Boolean;
begin
  FHistory.Clear;
  if FKeyOpened then FReg.CloseKey;
  FCurrentKey := ProperKey(Key);
  Result := FReg.KeyExists(FBase + Key);
  if not Result then FCurrentKey := '';
  FReg.OpenKey(FBase + FCurrentKey, False);
end;

procedure TPrefFile.CloseKey;
begin
  if FKeyOpened then FReg.CloseKey;
  FKeyOpened := False;
  FHistory.Clear;
  FCurrentKey := '';
end;

function TPrefFile.OpenSubKey(const Key: string): Boolean;
begin
  if FKeyOpened then FReg.CloseKey;
  FHistory.Push(FCurrentKey);
  FCurrentKey := string.CombineTestBoth(FCurrentKey, Separator, ProperKey(Key));
  Result := FReg.OpenKey(FBase + FCurrentKey, True);
  if not Result then
    FCurrentKey := FHistory.Pop;
end;

function TPrefFile.TryOpenSubKey(const Key: string): Boolean;
begin
  Result := FReg.KeyExists(FBase + string.CombineTestBoth(FCurrentKey, Separator, ProperKey(Key)));
  if Result then OpenSubKey(Key);
end;

procedure TPrefFile.CloseSubKey;
begin
  if FHistory.IsEmpty then RaiseCloseSubKeyError;
  if FKeyOpened then FReg.CloseKey;
  FCurrentKey := FHistory.Pop;
  FReg.OpenKey(FBase + FCurrentKey, False);
end;

procedure TPrefFile.DeleteKey(const Key: string);
begin
  var Temp := ProperKey(Key);
  if SameText(FCurrentKey, Temp) or string(FCurrentKey).StartsText(Temp + Separator) then
    RaiseDeleteCurrentKeyError;
  FReg.DeleteKey(FBase + Key);
end;

procedure TPrefFile.DeleteSubKey(const SubKey: string);
begin
  FReg.DeleteKey(SubKey);
end;

procedure TPrefFile.DeleteValue(const Name: string);
begin
  FReg.DeleteValue(Name);
end;

function TPrefFile.KeyExists(const Key: string): Boolean;
begin
  Result := FReg.KeyExists(FBase + Key);
end;

function TPrefFile.SubKeyExists(const Key: string): Boolean;
begin
  Result := FReg.KeyExists(Key);
end;

function TPrefFile.GetSubKeys: TStringArray;
begin
  var Strings := TStringList.Create;
  try
    FReg.GetKeyNames(Strings);
    Result.Assign(Strings);
  finally
    Strings.Free;
  end;
end;

function TPrefFile.SubKeyCount: NInt;
var
  Value: TRegKeyInfo;
begin
  if FReg.GetKeyInfo(Value)
      then Result := Value.NumSubKeys
      else Result := 0;
end;

function TPrefFile.ValueExists(const Name: string): Boolean;
begin
  Result := FReg.ValueExists(Name);
end;

function TPrefFile.GetValueNames: TStringArray;
begin
  var Strings := TStringList.Create;
  try
    FReg.GetValueNames(Strings);
    Result.Assign(Strings);
  finally
    Strings.Free;
  end;
end;

function TPrefFile.ValueCount: NInt;
var
  Value: TRegKeyInfo;
begin
  if FReg.GetKeyInfo(Value)
    then Result := Value.NumValues
    else Result := 0;
end;

function TPrefFile.TryReadBool(const Name: string; var Value: Boolean): Boolean;
var
  Data: Integer;
  RegData: TRegDataType;
begin
  if not FReg.ValueExists(Name) then Exit(False);
  FReg.GetData(Name, @Data, SizeOf(Integer), RegData);
  Result := RegData = TRegDataType.rdInteger;
  if Result then Value := Data <> 0;
end;

function TPrefFile.TryReadInt32(const Name: string; var Value: Int32): Boolean;
var
  Info: TRegDataInfo;
begin
  Result := FReg.GetDataInfo(Name, Info) and
           ((Info.RegData = TRegDataType.rdInteger) or (Info.RegData = TRegDataType.rdInt64));
  if Result
    then if Info.RegData = TRegDataType.rdInteger
      then Value := FReg.ReadInteger(Name)
    else if Info.RegData = TRegDataType.rdInt64
      then Value := FReg.ReadInt64(Name);
end;

function TPrefFile.TryReadInt64(const Name: string; var Value: Int64): Boolean;
var
  Info: TRegDataInfo;
begin
  Result := FReg.GetDataInfo(Name, Info) and
           ((Info.RegData = TRegDataType.rdInteger) or (Info.RegData = TRegDataType.rdInt64));
  if Result
    then if Info.RegData = TRegDataType.rdInteger
      then Value := FReg.ReadInteger(Name)
    else if Info.RegData = TRegDataType.rdInt64
      then Value := FReg.ReadInt64(Name);
end;

function TPrefFile.TryReadDateTime(const Name: string; var Value: TDateTime): Boolean;
var
  Len: Integer;
  RegData: TRegDataType;
begin
  if not FReg.ValueExists(Name) then Exit(False);
  Len := FReg.GetData(Name, @Value, SizeOf(TDateTime), RegData);
  Result := (RegData = TRegDataType.rdBinary) and (Len = SizeOf(TDateTime));
end;

function TPrefFile.TryReadFloat64(const Name: string; var Value: Double): Boolean;
var
  Len: Integer;
  RegData: TRegDataType;
begin
  if not FReg.ValueExists(Name) then Exit(False);
  Len := FReg.GetData(Name, @Value, SizeOf(Double), RegData);
  Result := (RegData = TRegDataType.rdBinary) and (Len = SizeOf(Double));
end;

function TPrefFile.TryReadFloat32(const Name: string; var Value: Single): Boolean;
var
  d: Double;
begin
  Result := TryReadFloat(Name, d);
  if Result then Value := d;
end;

function TPrefFile.TryReadString(const Name: string; var Value: string): Boolean;
var
  Len: Integer;
  Info: TRegDataInfo;
begin
  Result := FReg.GetDataInfo(Name, Info) and
           ((Info.RegData = TRegDataType.rdString) or (Info.RegData = TRegDataType.rdExpandString));
  if Result then
  begin
    Len := Info.DataSize;
    if Len > 0 then
    begin
      SetLength(Value, Len div SizeOf(Char));
      FReg.GetData(Name, PChar(Value), Len, Info.RegData);
      SetLength(Value, StrLen(PChar(Value)))
    end else Value := '';
  end;
end;

function TPrefFile.TryReadBinary(const Name: string; var Buffer; BufSize: NInt): NInt;
var
  Info: TRegDataInfo;
begin
  if FReg.GetDataInfo(Name, Info) and
     ((Info.RegData = TRegDataType.rdBinary) or (Info.RegData = TRegDataType.rdUnknown)) then
  begin
    if Info.DataSize > BufSize then Exit(-Info.DataSize - 1);
    Result := Info.DataSize;
    if Result > 0 then
      FReg.GetData(Name, @Buffer, Result, Info.RegData)
  end else Result := -1;
end;

function TPrefFile.TryReadBinary(const Name: string; var Bytes: TBytes): Boolean;
var
  Info: TRegDataInfo;
begin
  Result := FReg.GetDataInfo(Name, Info) and
            ((Info.RegData = TRegDataType.rdBinary) or (Info.RegData = TRegDataType.rdUnknown));
  if Result then
  begin
    SetLength(Bytes, Info.DataSize);
    if Info.DataSize > 0 then
      FReg.GetData(Name, @Bytes[0], Info.DataSize, Info.RegData)
  end;
end;

procedure TPrefFile.WriteBool(const Name: string; Value: Boolean);
begin
  FReg.WriteBool(Name, Value);
end;

procedure TPrefFile.WriteInt32(const Name: string; Value: Int32);
begin
  FReg.WriteInteger(Name, Value);
end;

procedure TPrefFile.WriteInt64(const Name: string; Value: Int64);
begin
  FReg.WriteInt64(Name, Value);
//  FReg.WriteBinaryData(Name, Value, SizeOf(Int64));
  // Because of the way delphi handles it, REG_QWORD cannot be used unless use API drectly
end;

procedure TPrefFile.WriteDateTime(const Name: string; Value: TDateTime);
begin
  FReg.WriteDateTime(Name, Value);
end;

procedure TPrefFile.WriteFloat(const Name: string; Value: Double);
begin
  FReg.WriteFloat(Name, Value);
end;

procedure TPrefFile.WriteString(const Name, Value: string);
begin
  FReg.WriteString(Name, Value);
end;

procedure TPrefFile.WriteBinary(const Name: string; const Buffer; BufSize: Integer);
begin
  FReg.WriteBinaryData(Name, Buffer, BufSize);
end;

procedure TPrefFile.WriteBinary(const Name: string; const Bytes: TBytes);
begin
  if Bytes = nil
    then FReg.WriteBinaryData(Name, Bytes, 0)             // Bytes is okay
    else FReg.WriteBinaryData(Name, Bytes[0], Length(Bytes));
end;
{$ENDIF}{$ENDREGION}

{$REGION 'TPrefFile - Shared'}
constructor TPrefFile.Create(ForSave: Boolean = False);
begin
  Create('', '', ForSave);
end;

constructor TPrefFile.Create(const AppID: string; ForSave: Boolean = False);
begin
  Create('', AppID, ForSave);
end;

procedure TPrefFile.RaiseCloseSubKeyError;
begin
  raise Exception.Create('No sub key is opened.');
end;

procedure TPrefFile.RaiseDeleteCurrentKeyError;
begin
  raise Exception.Create('Cannot delete an opened key.');
end;

function TPrefFile.HasSubKeys: Boolean;
begin
  Result := SubKeyCount > 0;
end;

function TPrefFile.HasValues: Boolean;
begin
  Result := ValueCount > 0;
end;

function TPrefFile.TryReadInt(const Name: string; var Value: Int32): Boolean;
begin
  Result := TryReadInt32(Name, Value);
end;

function TPrefFile.TryReadInt(const Name: string; var Value: Int64): Boolean;
begin
  Result := TryReadInt64(Name, Value);
end;

function TPrefFile.TryReadFloat(const Name: string; var Value: Double): Boolean;
begin
  Result := TryReadFloat64(Name, Value);
end;

function TPrefFile.TryReadFloat(const Name: string; var Value: Single): Boolean;
begin
  Result := TryReadFloat32(Name, Value);
end;

function TPrefFile.TryRead(const Name: string; var Value: Boolean): Boolean;
begin
  Result := TryReadBool(Name, Value);
end;

function TPrefFile.TryRead(const Name: string; var Value: Int32): Boolean;
begin
  Result := TryReadInt32(Name, Value);
end;

function TPrefFile.TryRead(const Name: string; var Value: Int64): Boolean;
begin
  Result := TryReadInt64(Name, Value);
end;

function TPrefFile.TryRead(const Name: string; var Value: Double): Boolean;
begin
  Result := TryReadFloat64(Name, Value);
end;

function TPrefFile.TryRead(const Name: string; var Value: Single): Boolean;
begin
  Result := TryReadFloat32(Name, Value);
end;

function TPrefFile.TryRead(const Name: string; var Value: string): Boolean;
begin
  Result := TryReadString(Name, Value);
end;

function TPrefFile.TryRead(const Name: string; var Value: TDateTime): Boolean;
begin
  Result := TryReadDateTime(Name, Value);
end;

function TPrefFile.TryRead(const Name: string; var Bytes: TBytes): Boolean;
begin
  Result := TryReadBinary(Name, Bytes);
end;

function TPrefFile.ReadBinary(const Name: string): TBytes;
begin
  if not TryReadBinary(Name, Result) then Result := nil;
end;

function TPrefFile.ReadBool(const Name: string; Default: Boolean): Boolean;
begin
  if not TryReadBool(Name, Result) then Result := Default;
end;

function TPrefFile.ReadDateTime(const Name: string; Default: TDateTime): TDateTime;
begin
  if not TryReadDateTime(Name, Result) then Result := Default;
end;

function TPrefFile.ReadFloat(const Name: string; Default: Double): Double;
begin
  if not TryReadFloat64(Name, Result) then Result := Default;
end;

function TPrefFile.ReadInt64(const Name: string; Default: Int64): Int64;
begin
  if not TryReadInt64(Name, Result) then Result := Default;
end;

function TPrefFile.ReadInt32(const Name: string; Default: Int32): Int32;
begin
  if not TryReadInt32(Name, Result) then Result := Default;
end;

function TPrefFile.ReadString(const Name, Default: string): string;
begin
  if not TryReadString(Name, Result) then Result := Default;
end;
{$ENDREGION}
{$ENDREGION}

end.
