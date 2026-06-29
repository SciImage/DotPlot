unit uDataSet;

{$I wc.Base.inc}

interface

uses
  wc.Types, wc.Base;

type
  // A set of data contains multiple groups (like male and female);
  // Each contains multiple subgroup (like treatment A, B, C);
  // For each groups and subgroup combination, there are multiple repeats;
  // Each repeat itself contains an array of values; from which Mean and SD can be calculated.

  // TExpDataSet    represents the lowest level of data organization.
  // TGroupDataSets represents the highest level of data organization, contains the entire collection of data.
  //

  {$REGION 'TErrorBar'}         // How data is displayed
  // The name can be misleading but, by determining the display of error bar/whisker, TErrorBar
  // have big impacts of data presentation.
  TErrorBar = (None,
               Mean,            // Show the mean of only
               MeanSD,
               MeanSEM,
               MeanData,
               MeanSDData,
               MeanSE,
               MedianIQR,
               MedianMinMax);
  TErrorBarHelper = record helper for TErrorBar
    function IsBoxPlot: Boolean;                // MedianIQR, MedianMinMax
    function IsIndividualDataPlot: Boolean;     // TErrorBar.MeanData, TErrorBar.MeanSDData, TErrorBar.MeanSE];
    function IsDataRepeatPlot: Boolean;
    function HasErrorBar: Boolean;
  end;
  {$ENDREGION}
  {$REGION 'TExpDataSet'}       // Results from one single repeat of one single experimental condition
  TExpDataSet = record
    nData: NInt;
    Sum, SumSq: Float64;
    Data: TFloat64s;

    function HasData: Boolean;
    function Mean: Float64;
    function StDev: Float64;
    function MinValue: Float64;
    function MaxValue: Float64;
    procedure AddItem(const Item: Float64);
    procedure UpdateStatistics;
  end;
  {$ENDREGION}
  {$REGION 'TSubgroupDataSets'} // Results from multiple repeats of one single experimental condition
  TSubgroupDataSets = record
    Name: string;
    Subgroup, nRepeat, nData: NInt;             // Subgroup indicates which
    Sum, SumSq: Float64;                        // Mean of Repeat
    SumData, SumSqData: Float64;                // Individual data
    Repeats: array of TExpDataSet;
    Offset: Float64;                            // This is a number for drawing curves like time/dose response

    procedure NewRepeat;
    procedure AddItem(const Item: Float64);
    procedure UpdateStatistics;

    function  IsEmpty: Boolean;                 inline;
    function  NotEmpty: Boolean;                inline;

    function  Mean: Float64;                    inline; // Mean  of means of all repeats
    function  StDev: Float64;                           // StDev of means of all repeats
    function  SEM: Float64;                             // SEM   of means of all repeats
    function  MinRepeatMean: Float64;
    function  MaxRepeatMean: Float64;
    function  AllRepeatMeans: TFloat64s;
    function  SortedRepeatMeans: TFloat64s;
    function  GetRepeatMeans(n: NInt): Float64;

    function  MeanOfData: Float64;              inline; // Mean  of means of all individual data
    function  StDevOfData: Float64;                     // StDev of means of all individual data
    function  SEMOfData: Float64;                       // SEM   of means of all individual data
    function  MinValue: Float64;
    function  MaxValue: Float64;
    function  AllData: TFloat64s;
    function  SortedData: TFloat64s;
    function  GetDataPoint(n: NInt): Float64;

    procedure GetVariability(UseRepeatMeans, UseSEM: Boolean; var Min, Max: Float64);           // Mean - SD/SEM and Mean + SD/SEM
    procedure GetIQR(UseMeans: Boolean; const Multiplier: Float64; var Min, Max: Float64);      // P25 - Multiplier * IQR and P75 + Multiplier * IQR
    procedure GetVisualRange(ErrorBar: TErrorBar; UseMeans: Boolean; var Min, Max: Float64);    // According to ErrorBar, get the range of (data, 1.5 IQR or SD/SEM)

    property  DataPoints[n: NInt]: Float64 read GetDataPoint;
    property  RepeatMeans[n: NInt]: Float64 read GetRepeatMeans;
  end;
  {$ENDREGION}
  {$REGION 'TGroupDataSets'}    // Results from multiple repeats of multiple measures (Subgroups) of experimental conditions (Groups)
  TGroupDataSets = record
    DataSets: array of TSubgroupDataSets;       // All data, in a 1D array, Subgroups and Groups are not separated
    Groups: array of TNInts;                    // 2D Index to DataSets, Groups[i]: i-th experimental conditions, Groups[i][j]: j-th measure
    nSubgroups: NInt;                           // Number of different measures
    MinOffset, MaxOffset: Float64;              // This is the range for drawing curves like time/dose response

    // For arranging DataSets into Groups
    procedure RemoveLeadingEmpty;                       // Remove empty groups at the begining
    procedure AddToSubGroup(iDataSet, Subgroup: NInt);  // Add a Dataset to a subgoup

    function MinRepeatMean: Float64;            // MinRepeatMean of the whoe DataSets
    function MaxRepeatMean: Float64;            // MaxRepeatMean of the whoe DataSets
    function MinValue: Float64;                 // MinValue of the whoe DataSets
    function MaxValue: Float64;                 // MaxValue of the whoe DataSets

    function MaxCount: NInt;                    // Maximal count of data of all items of DataSets
    function TotalSubgroups: NInt; inline;      // = Length(DataSets);
    function HasNames: Boolean;                 // Does any subgroup has Name?
    function AllHaveMinRepeats(MinRepeats: NInt): Boolean;      // Does all subgroup has at least MinRepeats of repeats?
    procedure GetVisualRange(ErrorBar: TErrorBar; UseMeans: Boolean; var Min, Max: Float64);    // According to ErrorBar, get the range of (data, 1.5 IQR or SD/SEM)

    procedure FromStrings(const s: string);                     overload; inline;       // Get data from a LineReturn/Tab-separated string
    procedure FromStrings(const Strings: TStringArray);      overload;               // Get data from Tab-separated strings
    function  SummarizeToStrings: TStringArray;                                      // Generate summary of data
    function  SummarizeToString: string;                        inline;
  end;
  {$ENDREGION}

implementation

uses
  System.SysUtils, System.Math,
  wc.Math;

function TryParse(const s: string; var F64: Float64): Boolean;   // Treat % as numbers, multiplied by 100
begin
  if s.EndsWith('%')
    then Result := Float64.TryParse(s.Substring(0, s.Length - 1).Trim(), F64)
    else Result := Float64.TryParse(s, F64);
end;
{$ENDREGION}

{$REGION 'TErrorBarHelper'}
{ TErrorBarHelper }

function TErrorBarHelper.HasErrorBar: Boolean;
begin
  Result := Self in [TErrorBar.MeanSD, TErrorBar.MeanSEM, TErrorBar.MeanSDData, TErrorBar.MeanSE];
end;

function TErrorBarHelper.IsBoxPlot: Boolean;
begin
  Result := Self in [TErrorBar.MedianIQR, TErrorBar.MedianMinMax];
end;

function TErrorBarHelper.IsDataRepeatPlot: Boolean;
begin
  Result := Self in [TErrorBar.Mean, TErrorBar.MeanSD, TErrorBar.MeanSEM];
end;

function TErrorBarHelper.IsIndividualDataPlot: Boolean;
begin
  Result := Self in [TErrorBar.MeanData, TErrorBar.MeanSDData, TErrorBar.MeanSE];
end;
{$ENDREGION}

{$REGION 'TExpDataSet'}
{ TExpDataSet }

procedure TExpDataSet.AddItem(const Item: Float64);
var
  l: NInt;
begin
  l := Length(Data);
  SetLength(Data, l + 1);
  Data[l] := Item;
end;

procedure TExpDataSet.UpdateStatistics;
begin
  nData := Length(Self.Data);
  Data.SumsAndSquares(Sum, SumSq);
end;

function TExpDataSet.HasData: Boolean;
begin
  Result := Self.Data <> nil;
end;

function TExpDataSet.Mean: Float64;
begin
  if nData = 0
    then Result := 0
    else Result := Sum / nData;
end;

function TExpDataSet.StDev: Float64;
begin
  if nData = 0
    then Result := 0
  else if nData = 1
    then Result := -1
    else Result := Sqrt((SumSq - Sqr(Sum) / nData) / (nData - 1));
end;

function TExpDataSet.MinValue: Float64;
begin
  if Data = nil
    then Result := Float64.MaxValue
    else Result := System.Math.MinValue(Data);
end;

function TExpDataSet.MaxValue: Float64;
begin
  if Data = nil
    then Result := Float64.MinValue
    else Result := System.Math.MaxValue(Data);
end;
{$ENDREGION}

{$REGION 'TSubgroupDataSets'}
{ TSubgroupDataSets }

procedure TSubgroupDataSets.NewRepeat;
var
  l: NInt;
begin
  l := Length(Repeats);
  if (l > 0) and Repeats[l - 1].HasData then
    SetLength(Repeats, l + 1);
end;

procedure TSubgroupDataSets.AddItem(const Item: Float64);
var
  l: NInt;
begin
  l := Length(Repeats);
  if l = 0 then
  begin
    SetLength(Repeats, 1);
    l := 1;
  end;
  Repeats[l - 1].AddItem(Item);
end;

procedure TSubgroupDataSets.UpdateStatistics;
var
  i, l: NInt;
  Temp: TFloat64s;
begin
  l := Length(Repeats);
  if (l > 0) and not Repeats[l - 1].HasData then
    SetLength(Repeats, l - 1);

  nRepeat := Length(Repeats);
  SetLength(Temp, nRepeat);

  nData := 0;
  SumData := 0;         SumSqData := 0;
  for i := 0 to nRepeat - 1 do
  begin
    Repeats[i].UpdateStatistics;
    Temp[i] := Repeats[i].Mean;
    Inc(nData, Repeats[i].nData);
    SumData   := SumData +   Repeats[i].Sum;
    SumSqData := SumSqData + Repeats[i].SumSq;
  end;
  Temp.SumsAndSquares(Sum, SumSq);
end;

function TSubgroupDataSets.IsEmpty: Boolean;
begin
  Result := Repeats = nil;
end;

function TSubgroupDataSets.NotEmpty: Boolean;
begin
  Result := Repeats <> nil;
end;

function TSubgroupDataSets.Mean: Float64;
begin
  if nRepeat = 0
    then Result := 0
    else Result := Sum / nRepeat;
end;

function TSubgroupDataSets.StDev: Float64;
begin
  if nRepeat = 0
    then Result := 0
  else if nRepeat = 1
    then Result := -1
    else Result := Sqrt((SumSq - Sqr(Sum) / nRepeat) / (nRepeat - 1));
end;

function TSubgroupDataSets.SEM: Float64;
begin
  if nRepeat = 0
    then Result := 0
  else if nRepeat = 1
    then Result := -1
    else Result := Sqrt((SumSq - Sqr(Sum) / nRepeat) / (nRepeat - 1) / nRepeat);
end;

function TSubgroupDataSets.MeanOfData: Float64;
begin
  if nData = 0
    then Result := 0
    else Result := SumData / nData;
end;

function TSubgroupDataSets.StDevOfData: Float64;
begin
  if nData = 0
    then Result := 0
  else if nData = 1
    then Result := -1
    else Result := Sqrt((SumSqData - Sqr(SumData) / nData) / (nData - 1));
end;

function TSubgroupDataSets.SEMOfData: Float64;
begin
  if nData = 0
    then Result := 0
  else if nData = 1
    then Result := -1
    else Result := Sqrt((SumSqData - Sqr(SumData) / nData) / (nData - 1) / nData);
end;


function TSubgroupDataSets.MinValue: Float64;
var
  i: NInt;
begin
  Result := Float64.MaxValue;
  for i := 0 to Length(Repeats) - 1 do
    ez.ToSmaller(Result, Repeats[i].MinValue);
end;

function TSubgroupDataSets.MaxValue: Float64;
var
  i: NInt;
begin
  Result := Float64.MinValue;
  for i := 0 to Length(Repeats) - 1 do
    ez.ToLarger(Result, Repeats[i].MaxValue);
end;

function TSubgroupDataSets.AllData: TFloat64s;
var
  i, l: NInt;
begin
  SetLength(Result, nData);
  l := 0;
  for i := 0 to nRepeat - 1 do
    if Repeats[i].Data <> nil then
    begin
      Move(Repeats[i].Data[0], Result[l], Length(Repeats[i].Data) * SizeOf(Float64));
      inc(l, Length(Repeats[i].Data));
    end;
end;

function TSubgroupDataSets.GetDataPoint(n: NInt): Float64;
var
  i, l: NInt;
begin
  l := 0;
  for i := 0 to nRepeat - 1 do
    if n < l + Repeats[i].nData
      then Exit(Repeats[i].Data[n - l])
      else inc(l, Repeats[i].nData);
  Result := 0;
end;

procedure TSubgroupDataSets.GetVariability(UseRepeatMeans, UseSEM: Boolean; var Min, Max: Float64);
var
  m, d: Float64;
begin
  if UseRepeatMeans then
  begin
    m := Mean;
    d := ez.IfThen(UseSEM, SEM, StDev);
  end else
  begin
    m := MeanOfData;
    d := ez.IfThen(UseSEM, SEMOfData, StDevOfData);
  end;
  Min := m - d;
  Max := m + d;
end;

procedure TSubgroupDataSets.GetIQR(UseMeans: Boolean; const Multiplier: Float64; var Min, Max: Float64);
begin
  var DataPoints: TFloat64s;
  if UseMeans
    then DataPoints := SortedRepeatMeans
    else DataPoints := SortedData;
  var y1 := DataPoints.Percentile(True, 0.25);
  var y2 := DataPoints.Percentile(True, 0.75);
  var d := (y2 - y1) * Multiplier;
  Min := y1 - d;
  Max := y2 + d;
end;

procedure TSubgroupDataSets.GetVisualRange(ErrorBar: TErrorBar; UseMeans: Boolean; var Min, Max: Float64);
begin
  if UseMeans then
  begin
    Min := MinRepeatMean;
    Max := MaxRepeatMean;
  end else
  begin
    Min := MinValue;
    Max := MaxValue;
  end;
  // if ErrorBar in [TErrorBar.None, TErrorBar.Mean, TErrorBar.MeanSD, TErrorBar.MeanSEM] then

  if ErrorBar in [TErrorBar.MeanData, TErrorBar.MeanSDData, TErrorBar.MeanSE] then
  begin
    var m := MeanOfData;
    var s: Float32;
    if ErrorBar = TErrorBar.MeanSDData
      then s := Self.StDevOfData
    else if ErrorBar = TErrorBar.MeanSE
      then s := Self.SEMOfData
      else s := 0;
    if m - s < Min then Min := m - s;
    if m + s > Max then Max := m + s;
  end else if ErrorBar = TErrorBar.MedianIQR then
  begin
    var DataPoints: TFloat64s;
    if UseMeans
      then DataPoints := SortedRepeatMeans
      else DataPoints := SortedData;
    var y1 := DataPoints.Percentile(True, 0.25);
    var y2 := DataPoints.Percentile(True, 0.75);
    var d := (y2 - y1) * 1.5;
    if y1 - d < Min then Min := y1 - d;
    if y2 + d > Max then Max := y2 + d;
  end;
end;

function TSubgroupDataSets.SortedData: TFloat64s;
begin
  Result := AllData.GetSortedCopy;
end;


function TSubgroupDataSets.MinRepeatMean: Float64;
var
  i: NInt;
begin
  Result := Float64.MaxValue;
  for i := 0 to Length(Repeats) - 1 do
    ez.ToSmaller(Result, Repeats[i].Mean);
end;

function TSubgroupDataSets.MaxRepeatMean: Float64;
var
  i: NInt;
begin
  Result := Float64.MinValue;
  for i := 0 to Length(Repeats) - 1 do
    ez.ToLarger(Result, Repeats[i].Mean);
end;

function TSubgroupDataSets.GetRepeatMeans(n: NInt): Float64;
begin
  Result := Repeats[n].Mean;
end;

function TSubgroupDataSets.AllRepeatMeans: TFloat64s;
var
  i: NInt;
begin
  SetLength(Result, nRepeat);
  for i := 0 to nRepeat - 1 do
    Result[i] := Repeats[i].Mean;
end;

function TSubgroupDataSets.SortedRepeatMeans: TFloat64s;
begin
  Result := AllRepeatMeans.GetSortedCopy;
end;
{$ENDREGION}

{$REGION 'TGroupDataSets: Numbers'}
{ TGroupDataSets }

procedure TGroupDataSets.RemoveLeadingEmpty;
var
  i, j: NInt;
begin
  j := 0;
  while (j < Length(DataSets)) and (DataSets[j].Repeats = nil) do
    inc(j);
  if j = 0 then Exit;

  for i := j to Length(DataSets) - 1 do
    DataSets[i - j] := DataSets[i];
  SetLength(DataSets, Length(DataSets) - j);
end;

procedure TGroupDataSets.AddToSubGroup(iDataSet, Subgroup: NInt);
var
  i, l, lg: NInt;
begin
  l := 0;
  for i := 0 to iDataSet - 1 do
    if DataSets[i].Subgroup = Subgroup then inc(l);

  if l >= Length(Groups) then
  begin
    SetLength(Groups, l + 1);
    Groups[l].Fill(-1);
  end;
  lg := Length(Groups[l]);
  if lg <= SubGroup then
  begin
    SetLength(Groups[l], SubGroup + 1);
    Groups[l].Fill(-1, lg, SubGroup - lg);
  end;
  Groups[l][Subgroup] := iDataSet;
  DataSets[iDataSet].Subgroup := Subgroup;
end;

function TGroupDataSets.HasNames: Boolean;
var
  i: NInt;
begin
  for i := 0 to Length(DataSets) - 1 do
    if DataSets[i].Name <> '' then Exit(True);
  Result := False;
end;

function TGroupDataSets.TotalSubgroups: NInt;
begin
  Result := Length(DataSets);
end;

function TGroupDataSets.MaxCount: NInt;
var
  i: NInt;
begin
  Result := 0;
  for i := 0 to Length(DataSets) - 1 do
    ez.ToLarger(Result, DataSets[i].nData);
end;

function TGroupDataSets.MinValue: Float64;
var
  i: NInt;
begin
  Result := Float64.MaxValue;
  for i := 0 to Length(DataSets) - 1 do
    ez.ToSmaller(Result, DataSets[i].MinValue);
end;

function TGroupDataSets.MaxValue: Float64;
var
  i: NInt;
begin
  Result := Float64.MinValue;
  for i := 0 to Length(DataSets) - 1 do
    ez.ToLarger(Result, DataSets[i].MaxValue);
end;

function TGroupDataSets.MinRepeatMean: Float64;
var
  i: NInt;
begin
  Result := Float64.MaxValue;
  for i := 0 to Length(DataSets) - 1 do
    ez.ToSmaller(Result, DataSets[i].MinRepeatMean);
end;

function TGroupDataSets.MaxRepeatMean: Float64;
var
  i: NInt;
begin
  Result := Float64.MinValue;
  for i := 0 to Length(DataSets) - 1 do
    ez.ToLarger(Result, DataSets[i].MaxRepeatMean);
end;

function TGroupDataSets.AllHaveMinRepeats(MinRepeats: NInt): Boolean;
var
  i: NInt;
begin
  for i := 0 to Length(DataSets) - 1 do
    if DataSets[i].nRepeat < MinRepeats then Exit(False);
  Result := DataSets <> nil;
end;

procedure TGroupDataSets.GetVisualRange(ErrorBar: TErrorBar; UseMeans: Boolean; var Min, Max: Float64);
var
  i: NInt;
  tMin, tMax: Float64;
begin
  if not AllHaveMinRepeats(2) then UseMeans := False;
  if DataSets = nil then
  begin
    Min := 0;
    Max := 0;
    Exit;
  end;

  DataSets[0].GetVisualRange(ErrorBar, UseMeans, Min, Max);
  for i := 1 to Length(DataSets) - 1 do
  begin
    DataSets[i].GetVisualRange(ErrorBar, UseMeans, tMin, tMax);
    if tMin < Min then Min := tMin;
    if tMax > Max then Max := tMax;
  end;
end;
{$ENDREGION}

{$REGION 'TGroupDataSets: to and from strings'}
procedure TGroupDataSets.FromStrings(const s: string);
begin
  FromStrings(TStringArray.CreateFromLines(s, False));
end;

procedure TGroupDataSets.FromStrings(const Strings: TStringArray);
var
  i, j, sg, l: NInt;
  ss: TStringArray;
  hasData: Boolean;
  Temp: Float64;
begin
  // Get data
  DataSets   := nil;
  Groups     := nil;
  nSubgroups := 0;
  hasData := False;

  // Extract names and titles, oragnized in datasets/repeats
  for i := 0 to Strings.Count - 1 do
  begin
    ss.AssignStrings(Strings[i], TabChar, False);
    ss.TrimStrings;
    if ss.Length = 0 then continue;
    if ss.Length > Length(DataSets) then
      SetLength(DataSets, ss.Length);

    if not ss.AreAllEmptyOrNumbers(True) then
    begin
      if hasData then continue;
      if ss.AllStartWith('X:', True, True) and not ss.AreAllEmpty then
      begin
        for j := 0 to ss.Length - 1 do
          if TryParse(ss[j].Substring(2).Trim, Temp)
            then DataSets[j].Offset := Temp;
        continue;
      end;

      for j := 0 to ss.Length - 1 do
      begin
        DataSets[j].Name   := Trim(ss[j]);
        DataSets[j].Offset := Float64.MinValue;
      end;
      continue;
    end;

    hasData := True;
    for j := 0 to ss.Length - 1 do
    begin
      if ss[j] = '' then
      begin
        DataSets[j].NewRepeat;
        continue;
      end;
      if not TryParse(ss[j], Temp) then continue;
      DataSets[j].AddItem(Temp);
    end;
  end;

  RemoveLeadingEmpty;
  if DataSets = nil then
  begin
    nSubgroups := 0;
    Groups     := nil;
    Exit;
  end;

  l := 0;
  if not HasNames then    // Separate datasets into groups, using with empty columns
  begin
    sg := 0;
    for i := 0 to Length(DataSets) - 1 do
    begin
      if DataSets[i].Repeats = nil then    // There is no repeats --> No data at all
      begin
        sg := 0;
      end else
      begin
        if i <> l then DataSets[l] := DataSets[i];
        AddToSubGroup(l, sg);
        inc(sg);
        inc(l);
      end;
    end;
  end else                              // Separate groups with names
  begin
    ss.Clear;
    for i := 0 to Length(DataSets) - 1 do
    begin
      if DataSets[i].Repeats = nil then continue;

      if i <> l then DataSets[l] := DataSets[i];
      sg := ss.AddUniqueText(DataSets[l].Name);
      AddToSubGroup(l, sg);
      inc(l);
    end;
  end;
  SetLength(DataSets, l);

  MaxOffset := Float64.MinValue;
  MinOffset := Float64.MaxValue;
  for i := 0 to Length(DataSets) - 1 do
  begin
    if (i > 0) and (DataSets[i].Offset = Float64.MinValue)
      then DataSets[i].Offset := DataSets[i - 1].Offset;
    MaxOffset := ez.Max(MaxOffset, DataSets[i].Offset);
    MinOffset := ez.Min(MinOffset, DataSets[i].Offset);
    DataSets[i].UpdateStatistics;
  end;

  if (Length(Groups) = 1) and (Length(DataSets) > 1) then
  begin
    SetLength(Groups, Length(DataSets));
    for i := Length(DataSets) - 1 downto 0 do
    begin
      SetLength(Groups[i], 1);
      Groups[i][0] := i;
      DataSets[i].Subgroup := 0;
    end;
    nSubgroups := 1;
  end;
  nSubgroups := 0;
  for i := 0 to Length(Groups) - 1 do
    nSubgroups := ez.Max(nSubgroups, Groups[i].Length);
end;

function  TGroupDataSets.SummarizeToStrings: TStringArray;
var
  i: NInt;
begin
  Result.Clear;
  Result.Add(Format('Groups: %d', [Length(DataSets)]));
  for i := 0 to Length(DataSets) - 1 do
    with DataSets[i] do
    begin
      if Name = ''
        then Result.Add(Format('Group %d:', [Subgroup]))
        else Result.Add(Format('Group %d - %s:', [Subgroup, Name]));
      if ez.Max(Abs(MaxValue), Abs(MinValue)) > 1 then
      begin
        Result.Add(Format('  N = %d: %5.3f '#$00B1' %5.3f', [nRepeat, Mean, SEM]));
        Result.Add(Format('  n = %d: %5.3f '#$00B1' %5.3f', [nData, MeanOfData, SEMOfData]));
      end else
      begin
        Result.Add(Format('  N = %d: %5.4f '#$00B1' %5.4f', [nRepeat, Mean, SEM]));
        Result.Add(Format('  n = %d: %5.4f '#$00B1' %5.4f', [nData, MeanOfData, SEMOfData]));
      end;
    end;
end;

function TGroupDataSets.SummarizeToString: string;
begin
  Result := SummarizeToStrings.ToString;
end;
{$ENDREGION}

end.
