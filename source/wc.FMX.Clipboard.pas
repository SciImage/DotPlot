unit wc.FMX.Clipboard;

// For Delphi 12 and above, since then NativeInt is a weak alias of Integer/Int64, avoiding some mess

{$I wc.Base.inc}

interface

// This unit defines TClipboardMonitor and provides function to access the Clipboard.

uses
  {$IFDEF MacOS}
  Macapi.Foundation, Macapi.AppKit,
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Winapi.Windows, Winapi.Messages,
  {$ENDIF}
  System.SysUtils, System.RTTI, System.Classes,
  FMX.Types, FMX.Surfaces, FMX.Graphics,
  wc.Types, wc.Base;

type
  TClipboardMonitor = class;
  TClipboard = class
  private
    class var FMultiFormats: NInt;
    class function GetDefaultMonitor: TClipboardMonitor;        static; inline;

    {$REGION 'MacOs-specific'}
    {$IFDEF MacOS}
    class var FPasteBoardItems: TArray<NSPasteboardItem>;
    class var FPasteBoard: NSPasteboard;

    const CF_SVG  = 'public.svg-image';
    const CF_SVG2 = 'com.microsoft.image-svg-xml';

    class constructor Create;
    class procedure CheckCF(const CF: string);
    class function  HasFormat(CF: NSString): Boolean;                           overload; static;
    class function  GetFormatSize(CF: NSString): NInt;                          overload; static;
    class function  GetFormat(CF: NSString; pTarget: Pointer): Boolean;         overload; static;
    class function  GetFormat(CF: NSString): TBytes;                            overload; static;
    class function  GetFormat(CF: NSString; Stream: TStream): Boolean;          overload; static;
    class function  GetTextFormat(CF: NSString): string;                        overload; static;

    class procedure SetFormat(CF: NSString; p: Pointer; Size: NInt);            overload; static;
    class procedure SetFormat(CF: NSString; const Value: string);               overload; static;
    class procedure SetFormat(CF: NSString; const Value: TBytes);               overload; static; inline;
    class procedure SetFormat(CF: NSString; Stream: TStream; Size: NInt);       overload; static;
    class procedure SetFormat(CF: NSString; Stream: TStream);                   overload; static; inline;
    {$ENDIF}
    {$ENDREGION}
    {$REGION 'Windows-specific'}
    {$IFDEF MSWindows}
    const CF_PNG  = 'PNG';
    const CF_JPEG = 'JFIF';
    const CF_SVG  = 'image/svg+xml';

    class function  CFName(CF: UInt32): string;                                 static;
    class function  CFIdentifier(const CF: string): UInt32;                     static;
    class function  HasFormat(CF: UInt32): Boolean;                             overload; static;
    class function  GetFormatSize(CF: UInt32): NInt;                            overload; static;
    class function  GetFormat(CF: UInt32;  pTarget: Pointer): Boolean;          overload; static;
    class function  GetFormat(CF: UInt32): TBytes;                              overload; static;
    class function  GetFormat(CF: UInt32; Stream: TStream): Boolean;            overload; static;
    class function  GetTextFormat(CF: UInt32): string;                          overload; static;

    class procedure SetDIB(Value: TBitmapSurface);                              overload; static;
    class procedure SetDIB(Value: TBitmap);                                     overload; static;
    class procedure SetFormat(CF: UInt32; Data: THandle);                       overload; static;
    class procedure SetFormat(CF: UInt32; p: Pointer; Size: NInt);              overload; static;
    class procedure SetFormat(CF: UInt32; const Value: string);                 overload; static;
    class procedure SetFormat(CF: UInt32; const Value: TBytes);                 overload; static; inline;
    class procedure SetFormat(CF: UInt32; Stream: TStream; Size: NInt);         overload; static;
    class procedure SetFormat(CF: UInt32; Stream: TStream);                     overload; static; inline;
    {$ENDIF}
    {$ENDREGION}
  public
    {$REGION 'GetClipboard'}
    class function  SequenceNumber: NInt;                                       static;

    class function  GetFormats: TStringArray;                                   static;
    class function  HasFormat(const CF: string): Boolean;                       overload; static; inline;
    class function  GetFormatSize(const CF: string): NInt;                      overload; static; inline;
    class function  GetFormat(const CF: string; pTarget: Pointer): Boolean;     overload; static; inline;
    class function  GetFormat(const CF: string): TBytes;                        overload; static; inline;
    class function  GetFormat(const CF: string; Stream: TStream): Boolean;      overload; static; inline;
    class function  GetTextFormat(const CF: string): string;                    overload; static; inline;

    class function  HasText: Boolean;                                           static;
    class function  HasImage: Boolean;                                          static;
    class function  HasSVGImage: Boolean;                                       static;
    class function  GetClipboard: TValue;                                       static;
    class function  GetText: string;                                            static;
    class function  GetImage: TBitmapSurface;                                   static;
    class function  GetBitmap: TBitmap;                                         static;
    class function  GetSVGImage: string;                                        static;
    {$ENDREGION}
    {$REGION 'SetClipboard'}
    class procedure BeginMultiFormats;                                          static;
    class procedure EndMultiFormats;                                            static;

    class procedure SetFormat(const CF: string; p: Pointer; Size: NInt);        overload; static; inline;
    class procedure SetFormat(const CF: string; const Value: string);           overload; static; inline;
    class procedure SetFormat(const CF: string; const Value: TBytes);           overload; static; inline;
    class procedure SetFormat(const CF: string; Stream: TStream; Size: NInt);   overload; static; inline;
    class procedure SetFormat(const CF: string; Stream: TStream);               overload; static; inline;

    class function  GetFormatNameFromImageExt(const ImgExt: string): string;    static;
    class procedure SetClipboard(const Value: TValue);                          static; inline;
    class procedure SetText(const Value: string);                               static;
    class procedure SetImage(Value: TBitmapSurface);                            overload; static;
    class procedure SetImage(Value: TBitmapSurface; const ImgExt: string);      overload; static;
    class procedure SetImage(Value: TBitmapSurface; const ImgExt, CF: string);  overload; static;
    class procedure SetImage(Value: TBitmap);                                   overload; static;
    class procedure SetPNGImage(Value: TBitmapSurface)                          overload; static;
    class procedure SetPNGImage(Value: TBitmap)                                 overload; static;
    class procedure SetSVGImage(const Value: string)                            overload; static;
    class procedure SetSVGImage(Stream: TStream)                                overload; static;
    {$ENDREGION}
    {$REGION 'Properties'}
    class property DefaultMonitor: TClipboardMonitor read GetDefaultMonitor;
    class property Value: TValue                read GetClipboard   write SetClipboard;
    class property AsText: string               read GetText        write SetText;
    class property AsImage: TBitmapSurface      read GetImage       write SetImage;
    class property AsBitmap: TBitmap            read GetBitmap      write SetImage;
    class property AsPNGImage: TBitmapSurface   read GetImage       write SetPNGImage;
    class property AsSVGImage: string           read GetSVGImage    write SetSVGImage;
    class property TextOfFormat[const CF: string]: string   read GetTextFormat write SetFormat;
    class property Formats[const CF: string]: TBytes        read GetFormat     write SetFormat;
    {$ENDREGION}
  end;

  {$REGION 'TClipboardMonitor'}
  TClipboardMonitor = class(TComponent)
  private
    class var FDefaultMonitor: TClipboardMonitor;
  private
    FEnabled: boolean;
    FOnClipboardChange: TNotifyEvent;
  {$IFDEF MSWINDOWS}
    FWindowHandle: HWND;
    FNextInChain: THandle;

    procedure WndProc(var Msg: TMessage);
    procedure SetOnClipboardChange(const Value: TNotifyEvent);  inline;
    procedure SetEnabled(const Value: Boolean);                 inline;
  {$ENDIF}
  {$IFDEF MACOS}
    FTimer: TTimer;
    FLastChangeCount: NInt;
    FPasteboard: NSPasteboard;

    procedure SetEnabled(const Value: Boolean);
    procedure SetOnClipboardChange(const Value: TNotifyEvent);
    procedure OnTimer(Sender: TObject);
  {$ENDIF}
  public
    class destructor Destroy;
    class function DefaultMonitor: TClipboardMonitor;           static;
    constructor Create(Owner: TComponent);                      override;
    destructor  Destroy;                                        override;
    function IsEffective: Boolean;                              // Enabled and Assigned(FOnClipboardChange)

    property Enabled: Boolean                read FEnabled      write SetEnabled;
    property OnClipboardChange: TNotifyEvent read FOnClipboardChange write SetOnClipboardChange;
  end;
  {$ENDREGION}

implementation

uses
  {$IFDEF MACOS}
  Macapi.CocoaTypes, Macapi.Helpers, Macapi.CoreFoundation, Macapi.ObjectiveC,
  {$ENDIF}
  {$IFDEF MsWindows}
  FMX.Utils, FMX.Helpers.Win,
  {$ENDIF}
  System.RTLConsts, FMX.Consts, FMX.Platform;

{$REGION 'TClipboard'}
{ TClipboard }

{$REGION 'MacOS'}{$IFDEF MacOS}
{$REGION 'Private methods'}
class procedure TClipboard.CheckCF(const CF: string);
begin
  if CF = '' then
    raise EArgumentException.CreateFmt(SParamIsNil, ['Format Name']);
end;

class constructor TClipboard.Create;
begin
  FPasteboard := TNSPasteboard.Wrap(TNSPasteboard.OCClass.generalPasteboard);
end;
{$ENDREGION}

{$REGION 'SetFormats'}
class procedure TClipboard.BeginMultiFormats;
begin
  Inc(FMultiFormats);
end;

class procedure TClipboard.EndMultiFormats;
begin
  if FMultiFormats <= 0 then Exit;
  Dec(FMultiFormats);
  if FMultiFormats > 0 then Exit;
  if FPasteBoardItems = nil then Exit;

  var AutoReleasePool := TNSAutoreleasePool.Create;
  try
    var PBArray := TNSMutableArray.Wrap(TNSMutableArray.alloc.init);
    for var i := 0 to Length(FPasteBoardItems) - 1 do
      PBArray.addObject((FPasteBoardItems[i] as ILocalObject).GetObjectID);

    FPasteboard.clearContents;
    FPasteboard.writeObjects(PBArray);

    PBArray.release;
    for var i := 0 to Length(FPasteBoardItems) - 1 do
      FPasteBoardItems[i].release;
    FPasteBoardItems := nil;
  finally
    AutoReleasePool.release;
  end;
end;

class procedure TClipboard.SetFormat(CF: NSString; p: Pointer; Size: NInt);
begin
  if FMultiFormats > 0 then
  begin
    var PasteboardItem := TNSPasteboardItem.Wrap(TNSPasteboardItem.Alloc.init);
    if not Assigned(PasteboardItem) then  Exit;
    PasteboardItem.setData(TNSData.Wrap(TNSData.OCClass.dataWithBytes(p, Size)), CF);

    var i := Length(FPasteBoardItems);
    SetLength(FPasteBoardItems, i + 1);
    FPasteBoardItems[i] := PasteboardItem;
  end else
  begin
    var AutoReleasePool := TNSAutoreleasePool.Create;
    try
      FPasteboard.clearContents;
      FPasteboard.setData(TNSData.Wrap(TNSData.OCClass.dataWithBytes(p, Size)), CF);
    finally
      AutoReleasePool.release;
    end;
  end;
end;

class procedure TClipboard.SetFormat(const CF: string; p: Pointer; Size: NInt);
begin
  CheckCF(CF);
  SetFormat(StrToNSStr(CF), p, Size);
end;

class procedure TClipboard.SetFormat(CF: NSString; const Value: string);
begin
  if FMultiFormats > 0 then
  begin
    var PasteboardItem := TNSPasteboardItem.Wrap(TNSPasteboardItem.Alloc.init);
    if not Assigned(PasteboardItem) then  Exit;
    PasteboardItem.setString(StrToNSStr(Value), CF);

    var i := Length(FPasteBoardItems);
    SetLength(FPasteBoardItems, i + 1);
    FPasteBoardItems[i] := PasteboardItem;
  end else
  begin
    var AutoReleasePool := TNSAutoreleasePool.Create;
    try
      FPasteboard.clearContents;
      FPasteboard.setString(StrToNSStr(Value), CF);
    finally
      AutoReleasePool.release;
    end;
  end;
end;

class procedure TClipboard.SetFormat(const CF: string; const Value: string);
begin
  CheckCF(CF);
  SetFormat(StrToNSStr(CF), Value);
end;

class procedure TClipboard.SetFormat(CF: NSString; Stream: TStream; Size: NInt);
begin
  var pos := Stream.Position;
  Size := ez.Min(Size, Stream.Size - pos);
  if Size <= 0 then Exit;
  if Stream is TMemoryStream then
  begin
    SetFormat(CF, PByte(TMemoryStream(Stream).Memory) + Pos, Size);
    Exit;
  end;
  var ms := TMemoryStream.Create;
  try
    ms.CopyFrom(Stream, Size);
    ms.Position := 0;
    SetFormat(CF, ms.Memory, Size);
  finally
    ms.Free;
  end;
end;

class procedure TClipboard.SetFormat(const CF: string; Stream: TStream; Size: NInt);
begin
  CheckCF(CF);
  SetFormat(StrToNSStr(CF), Stream, Size);
end;

class procedure TClipboard.SetFormat(CF: NSString; Stream: TStream);
begin
  SetFormat(CF, Stream, Stream.Size - Stream.Position);
end;

class procedure TClipboard.SetFormat(const CF: string; Stream: TStream);
begin
  SetFormat(StrToNSStr(CF), Stream);
end;

class procedure TClipboard.SetFormat(CF: NSString; const Value: TBytes);
begin
  SetFormat(CF, PByte(Value), Length(Value));
end;

class procedure TClipboard.SetFormat(const CF: string; const Value: TBytes);
begin
  SetFormat(StrToNSStr(CF), Value);
end;
{$ENDREGION}

{$REGION 'SetClipboard'}
class function TClipboard.GetFormatNameFromImageExt(const ImgExt: string): string;
begin
  if SameText(ImgExt, SPNGImageExtension) then Exit(NSStrToStr(NSPasteboardTypePNG));
  if SameText(ImgExt, STIFImageExtension) or SameText(ImgExt, STIFFImageExtension)
    then Exit(NSStrToStr(NSPasteboardTypeTIFF));
  if SameText(ImgExt, SJPGImageExtension) or SameText(ImgExt, SJPEGImageExtension)
    then Exit('public.jpeg');
  if SameText(ImgExt, SBMPImageExtension) then Exit('public.bmp');
  if SameText(ImgExt, SJP2ImageExtension) then Exit('public.jp2');
  if SameText(ImgExt, SGIFImageExtension) then Exit('public.gif');
  if SameText(ImgExt, '.svg')             then Exit(CF_SVG);
  Result := 'Unknown image';
end;

class procedure TClipboard.SetText(const Value: string);
begin
  SetFormat(NSPasteboardTypeString, Value);
end;

class procedure TClipboard.SetImage(Value: TBitmapSurface; const ImgExt, CF: string);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    TBitmapCodecManager.SaveToStream(ms, Value, ImgExt);
    ms.Position := 0;
    SetFormat(CF, ms);
  finally
    ms.Free;
  end;
end;

class procedure TClipboard.SetImage(Value: TBitmapSurface; const ImgExt: string);
begin
  SetImage(Value, ImgExt, GetFormatNameFromImageExt(ImgExt));
end;

class procedure TClipboard.SetImage(Value: TBitmapSurface);
begin
  SetImage(Value, SPNGImageExtension, NSStrToStr(NSPasteboardTypePNG));
end;

class procedure TClipboard.SetImage(Value: TBitmap);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    Value.SaveToStream(ms);             // Always in PNG
    ms.Position := 0;
    SetFormat(NSPasteboardTypePNG, ms);
  finally
    ms.Free;
  end;
end;

class procedure TClipboard.SetPNGImage(Value: TBitmapSurface);
begin
  SetImage(Value);
end;

class procedure TClipboard.SetPNGImage(Value: TBitmap);
begin
  SetImage(Value);
end;

class procedure TClipboard.SetSVGImage(Stream: TStream);
begin
  TClipboard.BeginMultiFormats;
  try
    TClipboard.SetFormat(CF_SVG, Stream);
    TClipboard.SetFormat(CF_SVG2, Stream);
  finally
    TClipboard.EndMultiFormats;
  end;
end;

class procedure TClipboard.SetSVGImage(const Value: string);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    ms.WriteUTF8(Value);
    ms.Position := 0;
    SetSVGImage(ms);
  finally
    ms.Free;
  end;
end;
{$ENDREGION}

{$REGION 'GetFormat'}
class function TClipboard.SequenceNumber: NInt;
begin
  Result := FPasteboard.changeCount;
end;

class function TClipboard.GetFormats: TStringArray;
begin
  var AutoReleasePool := TNSAutoreleasePool.Create;
  try
    var Types := FPasteboard.types;
    Result.SetLength(Types.count);
    for var i := 0 to Result.Length - 1 do
      Result[i] := UTF8ToString(TNSString.Wrap(Types.objectAtIndex(i)).UTF8String);
  finally
    AutoReleasePool.release;
  end;
end;

class function TClipboard.HasFormat(CF: NSString): Boolean;
begin
  var AutoReleasePool := TNSAutoreleasePool.Create;
  try
    Result := FPasteboard.dataForType(CF) <> nil;
  finally
    AutoReleasePool.release;
  end;
end;

class function TClipboard.HasFormat(const CF: string): Boolean;
begin
  CheckCF(CF);
  Result := HasFormat(StrToNSStr(CF));
end;

class function TClipboard.GetFormatSize(CF: NSString): NInt;
begin
  var AutoReleasePool := TNSAutoreleasePool.Create;
  try
    var Data := FPasteboard.dataForType(CF);
    if Data = nil then Exit(-1);
    Result := Data.length;
  finally
    AutoReleasePool.release;
  end;
end;

class function TClipboard.GetFormatSize(const CF: string): NInt;
begin
  CheckCF(CF);
  Result := GetFormatSize(StrToNSStr(CF));
end;

class function TClipboard.GetFormat(CF: NSString; pTarget: Pointer): Boolean;
begin
  var AutoReleasePool := TNSAutoreleasePool.Create;
  try
    var Data := FPasteboard.dataForType(CF);
    if Data = nil then Exit(False);
    Result := True;
    if Data.length > 0 then Move(Data.bytes^, pTarget^, Data.length);
  finally
    AutoReleasePool.release;
  end;
end;

class function TClipboard.GetFormat(const CF: string; pTarget: Pointer): Boolean;
begin
  CheckCF(CF);
  Result := GetFormat(StrToNSStr(CF), pTarget);
end;

class function TClipboard.GetFormat(CF: NSString; Stream: TStream): Boolean;
begin
  var AutoReleasePool := TNSAutoreleasePool.Create;
  try
    var Data := FPasteboard.dataForType(CF);
    if Data = nil then Exit(False);
    Result := True;
    if Data.length > 0 then Stream.WriteBuffer(Data.bytes^, Data.length);
  finally
    AutoReleasePool.release;
  end;
end;

class function TClipboard.GetFormat(const CF: string; Stream: TStream): Boolean;
begin
  CheckCF(CF);
  Result := GetFormat(StrToNSStr(CF), Stream);
end;

class function TClipboard.GetFormat(CF: NSString): TBytes;
begin
  var AutoReleasePool := TNSAutoreleasePool.Create;
  try
    var Data := FPasteboard.dataForType(CF);
    if Data = nil then Exit(nil);
    SetLength(Result, Data.length);
    if Data.length > 0 then Move(Data.bytes^, Result[0], Data.length);
  finally
    AutoReleasePool.release;
  end;
end;

class function TClipboard.GetFormat(const CF: string): TBytes;
begin
  CheckCF(CF);
  Result := GetFormat(StrToNSStr(CF));
end;

class function TClipboard.GetTextFormat(CF: NSString): string;
begin
  var AutoReleasePool := TNSAutoreleasePool.Create;
  try
    var StrData := FPasteboard.stringForType(CF);
    if StrData <> nil
      then Result := NSStrToStr(StrData)
      else Result := '';
  finally
    AutoReleasePool.release;
  end;
end;

class function TClipboard.GetTextFormat(const CF: string): string;
begin
  Result := GetTextFormat(StrToNSStr(CF));
end;
{$ENDREGION}

{$REGION 'GetClipboard'}
class function TClipboard.HasText: Boolean;
begin
  var AutoReleasePool := TNSAutoreleasePool.Create;
  try
    Result := FPasteboard.stringForType(NSPasteboardTypeString) <> nil;
  finally
    AutoReleasePool.release;
  end;
end;

class function TClipboard.HasImage: Boolean;
begin
  var AutoReleasePool := TNSAutoreleasePool.Create;
  try
    Result := (FPasteboard.dataForType(NSPasteboardTypePNG) <> nil) or (FPasteboard.dataForType(NSPasteboardTypeTIFF) <> nil);
  finally
    AutoReleasePool.release;
  end;
end;

class function TClipboard.HasSVGImage: Boolean;
begin
  Result := HasFormat(CF_SVG) or HasFormat(CF_SVG2);
end;

class function TClipboard.GetText: string;
begin
  var AutoReleasePool := TNSAutoreleasePool.Create;
  try
    var StrData := FPasteboard.stringForType(NSPasteboardTypeString);
    if StrData <> nil
      then Result := NSStrToStr(StrData)
      else Result := '';
  finally
    AutoReleasePool.release;
  end;
end;

class function TClipboard.GetImage: TBitmapSurface;
begin
  var AutoReleasePool := TNSAutoreleasePool.Create;
  try
    var ImageData := FPasteboard.dataForType(NSPasteboardTypePNG);
    if ImageData = nil then
      ImageData := FPasteboard.dataForType(NSPasteboardTypeTIFF);
    if ImageData = nil then Exit(nil);

    var Stream := TPointerStream.Create(ImageData.bytes, ImageData.length);
    try
      Result := TBitmapSurface.Create;
      try
        if TBitmapCodecManager.LoadFromStream(Stream, Result) then Exit;
        Result.Free;
      except
        Result.Free;
      end;
      Result := nil;
    finally
      Stream.Free;
    end;
  finally
    AutoReleasePool.release;
  end;
end;

class function TClipboard.GetSVGImage: string;
begin
  if HasFormat(CF_SVG)
    then Result := GetTextFormat(CF_SVG)
  else if HasFormat(CF_SVG2)
    then Result := GetTextFormat(CF_SVG2)
  else Result := '';
end;
{$ENDREGION}
{$ENDIF}{$ENDREGION}

{$REGION 'Windows'}{$IFDEF MSWINDOWS}
{$REGION 'SetFormats'}
class procedure TClipboard.BeginMultiFormats;
begin
  if FMultiFormats = 0 then
  begin
    OpenClipboard(0);
    EmptyClipboard;
  end;
  Inc(FMultiFormats);
end;

class procedure TClipboard.EndMultiFormats;
begin
  if FMultiFormats <= 0 then Exit;
  Dec(FMultiFormats);
  if FMultiFormats > 0 then Exit;

  CloseClipboard;
end;

class procedure TClipboard.SetFormat(CF: UInt32; Data: THandle);
begin
  if FMultiFormats = 0 then
  begin
    OpenClipboard(0);
    EmptyClipboard;
    try
      SetClipboardData(CF, Data);
    finally
      CloseClipboard;
    end;
  end else SetClipboardData(CF, Data);
end;

class procedure TClipboard.SetFormat(CF: UInt32; p: Pointer; Size: NInt);
begin
  var hGlobal := GlobalAlloc(GMEM_MOVEABLE or GMEM_DDESHARE, Size);
  if hGlobal = 0 then Exit;
  var pGlobal := GlobalLock(hGlobal);
  if Assigned(pGlobal) then
  begin
    Move(p^, pGlobal^, Size);
    GlobalUnlock(hGlobal);
    SetFormat(CF, hGlobal);
  end;
end;

class procedure TClipboard.SetFormat(const CF: string; p: Pointer; Size: NInt);
begin
  SetFormat(CFIdentifier(CF), p, Size);
end;

class procedure TClipboard.SetFormat(CF: UInt32; const Value: string);
begin
  SetFormat(CF, PChar(Value), Length(Value) * 2 + 2);   // Must include the ending #0
end;

class procedure TClipboard.SetFormat(const CF: string; const Value: string);
begin
  SetFormat(CFIdentifier(CF), Value);
end;

class procedure TClipboard.SetFormat(CF: UInt32; Stream: TStream; Size: NInt);
begin
  var pos := Stream.Position;
  Size := ez.Min(Size, Stream.Size - pos);
  if Size <= 0 then Exit;
  if Stream is TMemoryStream then
  begin
    SetFormat(CF, PByte(TMemoryStream(Stream).Memory) + Pos, Size);
    Exit;
  end;
  var ms := TMemoryStream.Create;
  try
    ms.CopyFrom(Stream, Size);
    ms.Position := 0;
    SetFormat(CF, ms.Memory, Size);
  finally
    ms.Free;
  end;
end;

class procedure TClipboard.SetFormat(const CF: string; Stream: TStream; Size: NInt);
begin
  SetFormat(CFIdentifier(CF), Stream, Size);
end;

class procedure TClipboard.SetFormat(CF: UInt32; Stream: TStream);
begin
  SetFormat(CF, Stream, Stream.Size - Stream.Position);
end;

class procedure TClipboard.SetFormat(const CF: string; Stream: TStream);
begin
  SetFormat(CFIdentifier(CF), Stream);
end;

class procedure TClipboard.SetFormat(CF: UInt32; const Value: TBytes);
begin
  SetFormat(CF, PByte(Value), Length(Value));
end;

class procedure TClipboard.SetFormat(const CF: string; const Value: TBytes);
begin
  SetFormat(CFIdentifier(CF), Value);
end;
{$ENDREGION}

{$REGION 'MyRegion'}
const
  ClipboardFormats_1: array[$01..$11] of string =
    ('CF_Text', 'CF_Bitmap', 'CF_MetafilePict', 'CF_SYLK', 'CF_DIF', 'CF_TIFF', 'CF_OEMText', 'CF_DIB',
     'CF_Palette', 'CF_PenData', 'CF_RIFF', 'CF_Wave', 'CF_UnicodeText', 'CF_EnhMetafile', 'CF_HDrop',
     'CF_Locale', 'CF_DIBv5');
  ClipboardFormats_2: array[$80..$83] of string =
    ('CF_OwnerDisplay', 'CF_DspText', 'CF_DspBitmap', 'CF_DspMetafilePict');
  ClipboardFormats_3: string = 'CF_DspEnhMetafile';

class function TClipboard.CFName(CF: UInt32): string;
begin
  var FormatName: array[0..255] of Char;
  if Winapi.Windows.GetClipboardFormatName(CF, FormatName, Length(FormatName)) > 0
    then Exit(FormatName);
  if (CF >= Low(ClipboardFormats_1)) and (CF <= High(ClipboardFormats_1))
    then Exit(ClipboardFormats_1[CF]);
  if (CF >= Low(ClipboardFormats_2)) and (CF <= High(ClipboardFormats_2))
    then Exit(ClipboardFormats_2[CF]);
  if CF = $8E
    then Result := ClipboardFormats_3
    else Result := 'CF_' + CF.ToString;
end;

class function TClipboard.CFIdentifier(const CF: string): UInt32;
begin
  if SameText(CF, 'Text') then Exit(CF_UNICODETEXT);
  if String.StartsText('CF_', CF) then
  begin
    for var i := Low(ClipboardFormats_1) to High(ClipboardFormats_1) do
      if SameText(CF, ClipboardFormats_1[i]) then Exit(i);
    for var i := Low(ClipboardFormats_2) to High(ClipboardFormats_2) do
      if SameText(CF, ClipboardFormats_2[i]) then Exit(i);
    if SameText(CF, ClipboardFormats_3) then Exit($8E);
    var n: UInt32;
    if UInt32.TryParse(CF.Substring(3), n) then Exit(n);
  end;
  Result := RegisterClipboardFormat(PChar(CF));
end;

class function TClipboard.GetFormatNameFromImageExt(const ImgExt: string): string;
begin
  if SameText(ImgExt, SPNGImageExtension) then Exit(CF_PNG);     // Used by Microsoft Office
  if SameText(ImgExt, SJPGImageExtension) or SameText(ImgExt, SJPEGImageExtension)
    then Exit(CF_JPEG);
  if SameText(ImgExt, SGIFImageExtension) then Exit('GIF');
  if SameText(ImgExt, STIFImageExtension) or SameText(ImgExt, STIFFImageExtension)
    then Exit(ClipboardFormats_1[CF_TIFF]);
  if SameText(ImgExt, SBMPImageExtension) then Exit(ClipboardFormats_1[CF_DIB]);
  // if SameText(ImgExt, SJP2ImageExtension) then Exit('public.jp2');
  if SameText(ImgExt, '.svg')             then Exit(CF_SVG);
  Result := 'Unknown image';
end;

class procedure TClipboard.SetDIB(Value: TBitmapSurface);
var
  Data: THandle;
  DataPtr: Pointer;
  BitmapHeader: TBitmapInfoHeader;
  I, J: Integer;
  DIBDataPtr: Pointer;
begin
  FillChar(BitmapHeader, SizeOf(BitmapHeader), 0);
  BitmapHeader.biSize := SizeOf(TBitmapInfoHeader);
  BitmapHeader.biPlanes := 1;
  BitmapHeader.biBitCount := 32;
  BitmapHeader.biCompression := BI_RGB;

  BitmapHeader.biWidth := Value.Width;
  BitmapHeader.biHeight := Value.Height;
  BitmapHeader.biSizeImage := Value.BytesPerPixel * Value.Width * Value.Height;

  if BitmapHeader.biWidth <= 0 then
    BitmapHeader.biWidth := 1;
  if BitmapHeader.biHeight <= 0 then
    BitmapHeader.biHeight := 1;

  Data := GlobalAlloc(GMEM_MOVEABLE, BitmapHeader.biWidth * Abs(BitmapHeader.biHeight) * 4 + SizeOf(BitmapHeader));
  try
    DataPtr := GlobalLock(Data);
    try
      Move(BitmapHeader, DataPtr^, SizeOf(BitmapHeader));
      DIBDataPtr := @(PByteArray(DataPtr)[SizeOf(BitmapHeader)]);

      if Value.PixelFormat = TPixelFormat.BGRA then
        for I := 0 to Value.Height - 1 do
          Move(Value.Scanline[I]^,
            PAlphaColorArray(DIBDataPtr)[(Value.Height - 1 - I) * Value.Width], Value.Width * 4)
      else
        for I := 0 to Value.Height - 1 do
          for J := 0 to Value.Width - 1 do
            PAlphaColorArray(DIBDataPtr)[(Value.Height - 1 - I) * Value.Width + J] := Value.Pixels[J, I];
    finally
      GlobalUnlock(Data);
    end;
    SetFormat(CF_DIB, Data);
  except
    GlobalFree(Data);
    raise;
  end;
end;

class procedure TClipboard.SetDIB(Value: TBitmap);
var
  Data: THandle;
  DataPtr: Pointer;
  BitmapHeader: TBitmapInfoHeader;
  I, J: Integer;
  DIBDataPtr: Pointer;
  BitmapData: TBitmapData;
begin
  FillChar(BitmapHeader, SizeOf(BitmapHeader), 0);
  BitmapHeader.biSize := SizeOf(TBitmapInfoHeader);
  BitmapHeader.biPlanes := 1;
  BitmapHeader.biBitCount := 32;
  BitmapHeader.biCompression := BI_RGB;

  BitmapHeader.biWidth := Value.Width;
  BitmapHeader.biHeight := Value.Height;
  BitmapHeader.biSizeImage := Value.BytesPerPixel * Value.Width * Value.Height;

  if BitmapHeader.biWidth <= 0 then
    BitmapHeader.biWidth := 1;
  if BitmapHeader.biHeight <= 0 then
    BitmapHeader.biHeight := 1;

  Data := GlobalAlloc(GMEM_MOVEABLE, BitmapHeader.biWidth * Abs(BitmapHeader.biHeight) * 4 + SizeOf(BitmapHeader));
  try
    DataPtr := GlobalLock(Data);
    try
      Move(BitmapHeader, DataPtr^, SizeOf(BitmapHeader));
      DIBDataPtr := @(PByteArray(DataPtr)[SizeOf(BitmapHeader)]);

      if Value.Map(TMapAccess.Read, BitmapData) then
      try
        if BitmapData.PixelFormat = TPixelFormat.BGRA then
          for I := 0 to Value.Height - 1 do
            Move(PAlphaColorArray(BitmapData.Data)[I * (BitmapData.Pitch div 4)],
              PAlphaColorArray(DIBDataPtr)[(Value.Height - 1 - I) * Value.Width], Value.Width * 4)
        else
          for I := 0 to Value.Height - 1 do
            for J := 0 to Value.Width - 1 do
              PAlphaColorArray(DIBDataPtr)[(Value.Height - 1 - I) * Value.Width + J] :=
                BitmapData.GetPixel(J, I);
      finally
        Value.Unmap(BitmapData);
      end;
    finally
      GlobalUnlock(Data);
    end;
    SetFormat(CF_DIB, Data);
  except
    GlobalFree(Data);
    raise;
  end;
end;
{$ENDREGION}

{$REGION 'SetClipboard'}
class procedure TClipboard.SetText(const Value: string);
begin
  SetFormat(CF_UNICODETEXT, Value);
end;

class procedure TClipboard.SetImage(Value: TBitmapSurface; const ImgExt, CF: string);
var
  ms: TMemoryStream;
begin
  if SameText(CF, ClipboardFormats_1[CF_DIB]) then
  begin
    SetDIB(Value);
    Exit;
  end;
  ms := TMemoryStream.Create;
  try
    TBitmapCodecManager.SaveToStream(ms, Value, ImgExt);
    ms.Position := 0;
    SetFormat(CF, ms);
  finally
    ms.Free;
  end;
end;

class procedure TClipboard.SetImage(Value: TBitmapSurface; const ImgExt: string);
begin
  SetImage(Value, ImgExt, GetFormatNameFromImageExt(ImgExt));
end;

class procedure TClipboard.SetImage(Value: TBitmapSurface);
begin
  SetDIB(Value);
end;

class procedure TClipboard.SetImage(Value: TBitmap);
begin
  SetDIB(Value);
end;

class procedure TClipboard.SetPNGImage(Value: TBitmapSurface);
begin
  SetImage(Value, SPNGImageExtension, CF_PNG);
end;

class procedure TClipboard.SetPNGImage(Value: TBitmap);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    Value.SaveToStream(ms);             // Always in PNG
    ms.Position := 0;
    SetFormat(CF_PNG, ms);
  finally
    ms.Free;
  end;
end;

class procedure TClipboard.SetSVGImage(Stream: TStream);
begin
  SetFormat(CF_SVG, Stream);
end;

class procedure TClipboard.SetSVGImage(const Value: string);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    ms.WriteUTF8(Value);
    ms.Position := 0;
    SetSVGImage(ms);
  finally
    ms.Free;
  end;
end;
{$ENDREGION}

{$REGION 'GetFormat'}
class function TClipboard.SequenceNumber: NInt;
begin
  Result := GetClipboardSequenceNumber;
end;

class function TClipboard.GetFormats: TStringArray;
begin
  Result.Clear;
  if OpenClipboard(0) then
  try
    var AFormat := EnumClipboardFormats(0);
    while AFormat <> 0 do
    begin
      Result.Add(CFName(AFormat));
      AFormat := EnumClipboardFormats(AFormat);
    end;
  finally
    CloseClipboard;
  end;
end;

class function TClipboard.HasFormat(CF: UInt32): Boolean;
begin
  Result := IsClipboardFormatAvailable(CF);
end;

class function TClipboard.HasFormat(const CF: string): Boolean;
begin
  Result := HasFormat(CFIdentifier(CF));
end;

class function TClipboard.GetFormatSize(CF: UInt32): NInt;
begin
  if not IsClipboardFormatAvailable(CF) then Exit(-1);
  OpenClipboard(0);
  try
    var Data := GetClipboardData(CF);
    if Data <> 0
      then Result := GlobalSize(Data)
      else Result := 0;
  finally
    CloseClipboard;
  end;
end;

class function TClipboard.GetFormatSize(const CF: string): NInt;
begin
  Result := GetFormatSize(CFIdentifier(CF));
end;

class function TClipboard.GetFormat(CF: UInt32;  pTarget: Pointer): Boolean;
begin
  if not IsClipboardFormatAvailable(CF) then Exit(False);
  OpenClipboard(0);
  try
    var Data := GetClipboardData(CF);
    if Data <> 0 then
    begin
      var DataPtr := GlobalLock(Data);
      try
        Move(DataPtr^, pTarget^, GlobalSize(Data));
      finally
        GlobalUnlock(Data);
      end;
    end;
    Result := True;
  finally
    CloseClipboard;
  end;
end;

class function TClipboard.GetFormat(const CF: string; pTarget: Pointer): Boolean;
begin
  Result := GetFormat(CFIdentifier(CF), pTarget);
end;

class function TClipboard.GetFormat(CF: UInt32; Stream: TStream): Boolean;
begin
  if not IsClipboardFormatAvailable(CF) then Exit(False);
  OpenClipboard(0);
  try
    var Data := GetClipboardData(CF);
    if Data <> 0 then
    begin
      var DataPtr := GlobalLock(Data);
      try
        var Position := Stream.Position;
        Stream.Write(DataPtr^, GlobalSize(Data));
        Stream.Position := Position;
      finally
        GlobalUnlock(Data);
      end;
    end;
    Result := True;
  finally
    CloseClipboard;
  end;
end;

class function TClipboard.GetFormat(const CF: string; Stream: TStream): Boolean;
begin
  Result := GetFormat(CFIdentifier(CF),Stream);
end;

class function TClipboard.GetFormat(CF: UInt32): TBytes;
begin
  if not IsClipboardFormatAvailable(CF) then Exit(nil);
  OpenClipboard(0);
  try
    var Data := GetClipboardData(CF);
    if Data <> 0 then
    begin
      var DataPtr := GlobalLock(Data);
      SetLength(Result, GlobalSize(Data));
      try
        if Result <> nil then Move(DataPtr^, Result[0], Length(Result));
      finally
        GlobalUnlock(Data);
      end;
    end else Exit(nil)
  finally
    CloseClipboard;
  end;
end;

class function TClipboard.GetFormat(const CF: string): TBytes;
begin
  Result := GetFormat(CFIdentifier(CF));
end;

class function TClipboard.GetTextFormat(CF: UInt32): string;
begin
  if not IsClipboardFormatAvailable(CF) then Exit('');
  OpenClipboard(0);
  try
    var Data := GetClipboardData(CF);
    if Data <> 0 then
    begin
      var p := PChar(GlobalLock(Data));
      var l := GlobalSize(Data);
      try
        if not (string.TryGetUTF8Text(p, l, Result) or
                string.TryGetAnsiText(p, l, Result) or
                string.TryGetUnicodeText(p, l, Result))
          then Result := '';
      finally
        GlobalUnlock(Data);
      end;
    end else Result := '';
  finally
    CloseClipboard;
  end;
end;

class function TClipboard.GetTextFormat(const CF: string): string;
begin
  Result := GetTextFormat(CFIdentifier(CF));
end;
{$ENDREGION}

{$REGION 'GetClipboard'}
class function TClipboard.HasText: Boolean;
begin
  Result := IsClipboardFormatAvailable(CF_UNICODETEXT);
end;

class function TClipboard.HasImage: Boolean;
begin
  Result := IsClipboardFormatAvailable(CF_DIB) or
            IsClipboardFormatAvailable(CFIdentifier(CF_PNG));
end;

class function TClipboard.HasSVGImage: Boolean;
begin
  Result := HasFormat(CF_SVG);
end;

class function TClipboard.GetText: string;
var
  Data: THandle;
  TextData: string;
begin
  OpenClipboard(0);
  try
    Data := GetClipboardData(CF_UNICODETEXT);
    if Data <> 0 then
    begin
      TextData := PChar(GlobalLock(Data));
      try
        Result := TextData;
      finally
        GlobalUnlock(Data);
      end;
    end else Result := '';
  finally
    CloseClipboard;
  end;
end;

class function TClipboard.GetImage: TBitmapSurface;
begin
  if HasFormat(CF_PNG) then
  begin
    OpenClipboard(0);
    try
      var Data := GetClipboardData(CFIdentifier(CF_PNG));
      if Data <> 0 then
      begin
        var ImageData := PChar(GlobalLock(Data));
        var Stream := TPointerStream.Create(ImageData, GlobalSize(Data));
        try
          Result := TBitmapSurface.Create;
          try
            if TBitmapCodecManager.LoadFromStream(Stream, Result) then Exit;
            Result.Free;
          except
            Result.Free;
          end;
        finally
          Stream.Free;
        end;
      end;
    finally
      CloseClipboard;
    end;
  end;

  Result := nil;
  OpenClipboard(0);
  try
    var Data := GetClipboardData(CF_DIB);
    if Data <> 0 then
    begin
      var ImageData := GlobalLock(Data);
      try
        Result := DIBDataToBitmapSurface(ImageData);
      finally
        GlobalUnlock(Data);
      end;
    end;
  finally
    CloseClipboard;
  end;
end;

class function TClipboard.GetSVGImage: string;
begin
  if HasFormat(CF_SVG)
    then Result := GetTextFormat(CF_SVG)
    else Result := '';
end;
{$ENDREGION}
{$ENDIF}{$ENDREGION}

{$REGION 'Shared'}
class function TClipboard.GetDefaultMonitor: TClipboardMonitor;
begin
  Result := TClipboardMonitor.DefaultMonitor;
end;

class procedure TClipboard.SetClipboard(const Value: TValue);
begin
  if Value.IsType<TBitmap> then
    SetImage(Value.AsType<TBitmap>)
  else if Value.IsType<TBitmapSurface> then
    SetImage(Value.AsType<TBitmapSurface>)
  else if not Value.IsEmpty then
    SetText(Value.ToString);
end;

class function TClipboard.GetClipboard: TValue;
begin
  if HasText
    then Result := GetText
  else if HasImage
    then Result := GetImage
    else Result := TValue.Empty;
end;

class function TClipboard.GetBitmap: TBitmap;
begin
  var BmpSurf := GetImage;
  if Assigned(BmpSurf) then
  begin
    Result := TBitmap.Create;
    Result.Assign(BmpSurf);
    BmpSurf.Free;
  end else Result := nil;
end;
{$ENDREGION}
{$ENDREGION}

{$REGION 'TClipboardMonitor'}
{ TClipboardMonitor }

{$REGION 'MacOS'}{$IFDEF MACOS}
constructor TClipboardMonitor.Create(Owner: TComponent);
begin
  FEnabled := True;
  FTimer := TTimer.Create(Self);
  FTimer.OnTimer := OnTimer;
  FTimer.Interval := 200;
  FTimer.Enabled := FEnabled and Assigned(FOnClipboardChange);
  FPasteboard := TNSPasteboard.Wrap(TNSPasteboard.OCClass.generalPasteboard);
end;

procedure TClipboardMonitor.OnTimer(Sender: TObject);
var
  ChangeCount: NInt;
begin
  ChangeCount := FPasteboard.changeCount;
  if ChangeCount <> FLastChangeCount then
  begin
    FLastChangeCount := ChangeCount;
    FOnClipboardChange(Self);
  end;
end;

procedure TClipboardMonitor.SetEnabled(const Value: boolean);
begin
  if FEnabled = Value then Exit;
  FEnabled := Value;
  FTimer.Enabled := FEnabled and Assigned(FOnClipboardChange);
end;

procedure TClipboardMonitor.SetOnClipboardChange(const Value: TNotifyEvent);
begin
  if @FOnClipboardChange = @Value then Exit;
  FOnClipboardChange := Value;
  FTimer.Enabled := FEnabled and Assigned(FOnClipboardChange);
end;
destructor TClipboardMonitor.Destroy;
begin
  //
  inherited;
end;
{$ENDIF}{$ENDREGION}

{$REGION 'Windows'}{$IFDEF MSWINDOWS}
constructor TClipboardMonitor.Create(Owner: TComponent);
begin
  inherited;
  FEnabled      := True;
  FWindowHandle := AllocateHWnd(WndProc);
  FNextInChain  := SetClipboardViewer(FWindowHandle);  // Clipboard Monitor
end;

destructor TClipboardMonitor.Destroy;
begin
  ChangeClipboardChain(FWindowHandle, FNextInChain);
  DeallocateHWnd(FWindowHandle);
  inherited;
end;

procedure TClipboardMonitor.WndProc(var Msg: TMessage);
var
  Remove, Next: THandle;
begin
  if Msg.Msg = WM_CHANGECBCHAIN then
  begin
    Remove := Msg.WParam;
    Next := Msg.LParam;
    if FNextInChain = Remove
      then fNextInChain := Next
      else if FNextInChain <> 0
        then SendMessage(FNextInChain, WM_ChangeCBChain, Remove, Next);
  end else if Msg.Msg = WM_DRAWCLIPBOARD then
  begin
    if FEnabled and Assigned(FOnClipboardChange) then FOnClipboardChange(Self);
    if FNextInChain <> 0 then
      SendMessage(FNextInChain, WM_DrawClipboard, 0, 0);
  end else With Msg do
    Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam)
end;

procedure TClipboardMonitor.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
end;

procedure TClipboardMonitor.SetOnClipboardChange(const Value: TNotifyEvent);
begin
  FOnClipboardChange := Value;
end;
{$ENDIF}{$ENDREGION}

class function TClipboardMonitor.DefaultMonitor: TClipboardMonitor;
begin
  if FDefaultMonitor = nil then
    FDefaultMonitor := TClipboardMonitor.Create(nil);
  Result := FDefaultMonitor;
end;

class destructor TClipboardMonitor.Destroy;
begin
  if Assigned(FDefaultMonitor) then FreeAndNil(FDefaultMonitor);
end;

function TClipboardMonitor.IsEffective: Boolean;
begin
  Result := FEnabled and Assigned(FOnClipboardChange);
end;
{$ENDREGION}

end.


