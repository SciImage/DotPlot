{$IFDEF VER360}   {$DEFINE DELPHI_12}   {$DEFINE IS_DELPHI_12}   {$ENDIF}
{$IFDEF VER370}   {$DEFINE DELPHI_13}   {$DEFINE IS_DELPHI_13}   {$ENDIF}
{$IFDEF DELPHI_13}   {$DEFINE DELPHI_12}   {$ENDIF}

{$IF SizeOf(Pointer) = 4} {$DEFINE CPU32BITS} {$IFEND}
{$IF SizeOf(Pointer) = 8} {$DEFINE CPU64BITS} {$IFEND}

{$IFDEF MACOS}                                // Test for macOS, iOS, and iOS simulator
  {$IFDEF IOS}                                // Test for iOS and iOS simulator
    {$IFDEF CPUX86}                           // Test for iOS simulator
      {$DEFINE IOSVM}                           // IOSVM   fully defined
      {$DEFINE IOSVM32}                         // IOSVM32 fully defined
      {$DEFINE CPUINTEL}
    {$ELSE}
      {$DEFINE _IOS}                            // _IOS     fully defined
      {$IFDEF IOS64}
        {$DEFINE _IOS64}                        // _IOS64   fully defined
      {$ELSE}
        {$DEFINE IOS32}                         // IOS32    fully defined (added for XE4-XE7)
        {$DEFINE _IOS32}                        // _IOS32   fully defined
        {$DEFINE CPUARM32}                      //                        (added for XE4-XE7)
      {$ENDIF}
    {$ENDIF}
  {$ELSE}                                     // Mac
    {$DEFINE MAC}                               // MAC      fully defined
    {$IFDEF CPU32BITS}
      {$DEFINE MAC32}                           // MAC32    fully defined
      {$DEFINE MACINTEL}
      {$DEFINE CPUINTEL}
    {$ELSE}
      {$DEFINE MAC64}                           // MAC64    fully defined
      {$IFDEF CPUARM}
        {$DEFINE MAC64A}                        // MAC64A   fully defined
        {$DEFINE MACARM}                        // MACARM   fully defined
      {$ELSE}
        {$DEFINE MAC64X}                        // MAC64X   fully defined
        {$DEFINE MACINTEL}                      // MACINTEL fully defined
        {$DEFINE CPUINTEL}
        {$DEFINE OSX}                           // OSX      fully defined (added for 10.32-10.4)
        {$DEFINE OSX64}                         // OSX64    fully defined (added for 10.32-10.4)
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ELSE}                                       // Windows, Android, and Linux
  {$IFDEF ANDROID}                            // Test for Android
    {$IFDEF CPU32BITS}
      {$DEFINE ANDROID32}                       // ANDROID32 fully defined (added for XE5-XE7)
      {$DEFINE CPUARM32}                        // CPUARM32  fully defined (added for XE5-XE7)
    {$ENDIF}
  {$ELSE}                                     // Windows and Linux
    {$DEFINE CPUINTEL}                          // CPUINTEL  fully defined
  {$ENDIF}
{$ENDIF}

{$IFDEF CPU32BITS}
  {$DEFINE CPU32}
  {$IFDEF CPUARM}
    {$DEFINE CPUA32}
  {$ELSE}
    {$DEFINE CPUX32}
  {$ENDIF}
{$ELSE}
  {$DEFINE CPU64}
  {$IFDEF CPUARM}
    {$DEFINE CPUA64}
  {$ELSE}
    {$DEFINE CPUX64}
  {$ENDIF}
{$ENDIF}
{$DEFINE LITTLEENDIAN}                          // In iOS and Android, ARM are little endian.
{$UNDEF BIGENDIAN}                              // In most ARM implementation code is always LE, data can be either or switchable

{$IFDEF DELPHI_2009}
  {$IFDEF CPUX32}
    {$DEFINE EXTENDED_FPU}
    {$DEFINE EXTENDED80}
  {$ELSE}
    {$DEFINE EXTENDED64}
  {$ENDIF}
  {$IF SizeOf(Extended) = 8}   {$DEFINE EXTENDED8}    {$IFEND}
  {$IF SizeOf(Extended) = 10}  {$DEFINE EXTENDED10}   {$IFEND}
  {$IF SizeOf(Extended) = 12}  {$DEFINE EXTENDED12}   {$IFEND}    // According to system.pas, this is possible????
  {$IF SizeOf(Extended) = 16}  {$DEFINE EXTENDED16}   {$IFEND}
{$ELSE}
  {$DEFINE EXTENDED10}
  {$DEFINE EXTENDED_FPU}
{$ENDIF}

{$MINENUMSIZE 1}                // Use minumum size for enum types
{$EXTENDEDSYNTAX ON}            // Enables Delphi's extended syntax (discard result of function call; Use Result in functions; Assign 0-based array to string; Omit ^ in p^.XXX)
{$WRITEABLECONST OFF}           // Cannot write constants
{$TYPEDADDRESS ON}              // Check types of pointers
{$SCOPEDENUMS ON}               // Force to Type.Enum1 instead of Enum1
{$POINTERMATH ON}               // Allow arithmetics of pointer types
{$STRINGCHECKS OFF}             // Don't check string type, needed only when assign C++ AnsiString to Delphi UnicodeString

{$EXCESSPRECISION ON}           // Use double for intermediate in calculating singles in x64 platforms
{$EXTENDEDCOMPATIBILITY OFF}    // Enables the Extended type on all platforms with 10-byte storage for compatibility. Precision is not always 10-byte.
{$WARN IMMUTABLE_STRINGS OFF}   // Turn off warning "Modifying strings in place may not be supported in the future"
{$ZEROBASEDSTRINGS OFF}         // 0-based string is used by default in mobile in XE4-10.2. It is removed in 10.4.

{$IFDEF DEBUG}
   {.$RANGECHECKS ON}            // Turn on range checking during debugging;
   {$ASSERTIONS ON}             // Turn assertions on
   {$DEBUGINFO ON}
   {$OPTIMIZATION OFF}
   {$INLINE OFF}
{$ELSE}
   {$RANGECHECKS OFF}          // The project determines if range checking is on or off
   {$ASSERTIONS OFF}            // Turn assertions off
   {$DEBUGINFO OFF}             // It does not affect the size or speed of the executable program
  {$OPTIMIZATION ON}              // Turn optimization on in release mode
  {$INLINE ON}                    // Turn on code inlining in release mode
{$ENDIF}

{$WARN DUPLICATE_CTOR_DTOR OFF} // Supress C++ compatibility warning

{$IFDEF MSWINDOWS}
  {$SETPEFLAGS $0200 or $0004 or $0008 or $0001}
    // Same as IMAGE_FILE_DEBUG_STRIPPED or IMAGE_FILE_LINE_NUMS_STRIPPED or
    //         IMAGE_FILE_LOCAL_SYMS_STRIPPED OR IMAGE_FILE_RELOCS_STRIPPED
{$ENDIF}

