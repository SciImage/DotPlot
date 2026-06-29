unit wc.Consts;

// For Delphi 12 and above, since then NativeInt is a weak alias of Integer/Int64, avoiding some mess

{$I wc.Base.inc}

interface

resourcestring
// wc.Base
  SIndexOutOfRange          = 'Index (%d) out of range.';
  SIndexOutOfRangeEx        = 'Index (%d) out of range (%d - %d).';
  SIDExists                 = 'The ID (%d) already exists.';
  SNamedItemsNameExists     = 'The name (%s) already exists.';
  SDelimiterIsUsed          = 'Delimiter (''%s'') is already used.';
  SItemNotFound0            = 'Item not found.';
  SItemNotFound1            = 'Item not found: %s';
  SIllegalDelimiter         = 'Illegal delimiter (''#%d'').';
  SIllegalDelimiter2        = 'Illegal delimiter (''%s''), use one of the following: ''%s''.';
  SPercentageRange          = 'Percentage is out of range (%g%%).';
  SInvalidnFilename1        = 'Invalid filename: %s';
  SFileNotFound1            = 'File not found: %s';
  SFileClassNotFound        = 'Class %s is not registred.';
  SStreamCannotResize       = 'This stream is not resizable.';
  SStreamCannotWrite        = 'Cannot write to readonly stream.';
  SStringTrue               = 'true';       // must be lower case
  SStringFalse              = 'false';      // must be lower case
  SStringOn                 = 'On';
  SStringOff                = 'Off';
  SSourceNotSet             = 'Source of stream sections missing.';
  SErrorNilStream           = 'Stream object is nil.';
  SErrorInvalidStream       = 'Invalid file/stream format: %s';
  SMagicNumError            = 'Mismatched file/stream signatures.';
  SBlockSizeSet             = 'Stream is not empty so block size cannot be changed.';
  SBlockSizeWrong           = 'Invalid block size.';
  SSectionIDNotSet          = 'Section ID not set.';
  SLockedFromChange         = 'Object is locked. No change is allow.';
  STimeSpanYear             = ' year';
  STimeSpanMonth            = ' month';
  STimeSpanDay              = ' day';
  STimeSpanHour             = ' hour';
  STimeSpanMinute           = ' minute';
  STimeSpanSecond           = ' second';
  STimeSpanMilliSecond      = ' millisecond';
  STimeSpanYears            = ' years';
  STimeSpanMonths           = ' months';
  STimeSpanDays             = ' days';
  STimeSpanHours            = ' hours';
  STimeSpanMinutes          = ' minutes';
  STimeSpanSeconds          = ' seconds';
  STimeSpanMilliSeconds     = ' milliseconds';
  SInvalidGuidArray         = 'Byte array for GUID must be exactly %s bytes long';

  SFileSizeFormatByte0      = '0 by';
  SFileSizeFormatKB0        = '0 KB';
  SFileSizeFormatMB0        = '0 MB';
  SFileSizeFormatGB0        = '0 GB';
  SFileSizeFormatTB0        = '0 TB';
  SFileSizeFormatPB0        = '0 PB';
  SFileSizeFormatEB0        = '0 EB';
  SFileSizeFormatByte1      = '1 by';
  SFileSizeFormatKB1        = '%s KB';
  SFileSizeFormatMB1        = '%s MB';
  SFileSizeFormatGB1        = '%s GB';
  SFileSizeFormatTB1        = '%s TB';
  SFileSizeFormatPB1        = '%s PB';
  SFileSizeFormatEB1        = '%s EB';
  SFileSizeFormatByte       = '%s by';
  SFileSizeFormatKB         = '%s KB';
  SFileSizeFormatMB         = '%s MB';
  SFileSizeFormatGB         = '%s GB';
  SFileSizeFormatTB         = '%s TB';
  SFileSizeFormatPB         = '%s PB';
  SFileSizeFormatEB         = '%s EB';
  SFileSizeLongFormatByte0  = '0 byte';
  SFileSizeLongFormatKB0    = '0 kilobyte';
  SFileSizeLongFormatMB0    = '0 megabyte';
  SFileSizeLongFormatGB0    = '0 gigabyte';
  SFileSizeLongFormatTB0    = '0 terabyte';
  SFileSizeLongFormatPB0    = '0 petabyte';
  SFileSizeLongFormatEB0    = '0 exabyte';
  SFileSizeLongFormatByte1  = '1 byte';
  SFileSizeLongFormatKB1    = '%s kilobyte';
  SFileSizeLongFormatMB1    = '%s megabyte';
  SFileSizeLongFormatGB1    = '%s gigabyte';
  SFileSizeLongFormatTB1    = '%s terabyte';
  SFileSizeLongFormatPB1    = '%s petabyte';
  SFileSizeLongFormatEB1    = '%s exabyte';
  SFileSizeLongFormatByte   = '%s bytes';
  SFileSizeLongFormatKB     = '%s kilobytes';
  SFileSizeLongFormatMB     = '%s megabytes';
  SFileSizeLongFormatGB     = '%s gigabytes';
  SFileSizeLongFormatTB     = '%s terabytes';
  SFileSizeLongFormatPB     = '%s petabytes';
  SFileSizeLongFormatEB     = '%s exabytes';

// wc.Generics
  SQueueEmpty               = 'Queue is empty.';
  SStackEmpty               = 'Stack is empty.';

// wcFileSearch
  SCannotResumeFileSearch   = 'Cannot resume file search';
  SFileSearchIsLocked       = 'File search is locked from changing settings.';

// wc.IOUtils
  SFileSignatureEmpty       = 'File signature cannot be empty.';
  SFileSignatureNoLastID    = 'Last ID does not eixst.';

// Timespan
{$IFNDEF DELPHI_2010}
  sTimespanTooLong          = 'Timespan too long';
  sInvalidTimespanDuration  = 'The duration cannot be returned because the absolute value exceeds the value of TTimeSpan.MaxValue';
  sTimespanValueCannotBeNan = 'Value cannot be NaN';
  sCannotNegateTimespan     = 'Negating the minimum value of a Timespan is invalid';
  sInvalidTimespanFormat    = 'Invalid Timespan format';
  sTimespanElementTooLong   = 'Timespan element too long';
{$ENDIF}

{$IFNDEF DELPHI_XE8}
  SHashCanNotUpdateMD5      = 'MD5: Cannot update a finalized hash';
  SHashCanNotUpdateSHA1     = 'SHA1: Cannot update a finalized hash';
  SHashCanNotUpdateSHA2     = 'SHA2: Cannot update a finalized hash';
{$ENDIF}

// wc.TextStream
  SEOLNotFound              = 'End of line char not found.';
  SStreamEnd                = 'Reach the end of a stream.';
  SUnknownTextEncoding      = 'Unknown text encoding.';
  STextStreamSizeError      = 'Size mismatch: %d chars translated but %d chars are expected.';
  SHexTextStream            = 'Hex text stream';
  SASCIITextStream          = 'ASCII text stream';
  SUTF8TextStream           = 'UTF-8 unicode text stream';
  SBig5TextStream           = 'Big5 traditional Chinese text stream';
  SGBTextStream             = 'GB2312/GBK traditional Chinese text stream';
  SUTF16TextStream          = 'Unicode text stream';
  SUTF16beTextStream        = 'Unicode (big endian) text stream';
  SUTF32TextStream          = 'UTF-32 unicode text stream';
  SUTF32beTextStream        = 'UTF-32 unicode (big endian) text stream';
  SCP1252TextStream         = 'Code page Windows-1252 text stream';

  SIndexOutOfRangePos       = 'Index of position (%d) out of range.';
  SIndexOutOfRangeZ         = 'Index of plane (%d) out of range.';
  SIndexOutOfRangeTime      = 'Index of time point (%d) out of range.';
  SIndexOutOfRangeC         = 'Index of channel (%d) out of range.';
  SIndexOutOfRangeDim       = 'Index of a dimension is out of range.';
  SNoImageFileIsOpened      = 'No Image file is opened.';
  SCannotOpenFileFormat     = 'Invalid format. Cannot open file (%s).';
  SFileNotExist             = 'File (%s) doesn''t exists.';
  SCannotReadFrameIndex     = 'Can not read frame (%d).';
  SCannotReadFrame          = 'Can not read frame.';
  SCannotLoadLibrary        = 'Can not load library of "%s".';

  STiffTagNotFound          = 'Tag %d not found.';
  STiffDecoderNotFound      = 'Compression #%d is not supported.';
  STiffDecoderFailed        = 'Decoder (%s) failed to uncompress data with #%d compression.';
  STiffUnexpectedCount      = 'Unexpected count (%d), should be %d.';
  STiffUnknownPhotometric   = 'Unknown TIFF Photometric value (%d).';
  STooManyBits              = 'Number of bits cannot exceed %d.';

  {$IFNDEF DELPHI_XE}
  SInvalidKnownFileName     = 'Invalid file name - %s';
  {$ELSE}{$IFNDEF DELPHI_XE6}
  SInvalidKnownFileName     = SInvalidFileName;
  {$ENDIF}{$ENDIF}

  // wc.SciArray
  SEmptyArrayError          = 'Array is empty!';
  SArrayDimensionError      = 'Arrays have different dimensions.';
  SImageDimensionError      = 'Images have different dimensions.';
  SImageWidthError          = 'Images have different widths.';

  //wc.Base.AppInfo - Mac
  SNotAnArrayError          = '%s is not an array.';
  SNotASimpleDataError      = '%s is not a simple data.';
  SNotADictError            = '%s is not a dictionary.';
  SArrayItemNameError       = 'Array item cannot have name.';
  SInvalidCharForShortCut   = 'Invalid char for shortcut';

implementation

end.
