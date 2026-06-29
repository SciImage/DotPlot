unit wc.FMX.ControlEx;

// For Delphi 12 and above, since then NativeInt is a weak alias of Integer/Int64, avoiding some mess

{$I wc.Base.inc}

interface

uses
  System.Types, System.SysUtils, System.Classes, System.UITypes,
  FMX.Types, FMX.Objects, FMX.Graphics, FMX.TextLayout, FMX.Controls, FMX.StdCtrls, FMX.ExtCtrls,
  FMX.ListBox, FMX.Forms, FMX.Edit,
  wc.Types, wc.Base, wc.FMX.Base;

type
  {$REGION 'TCheckBox'}
  // Add a autosize property (Default: True) that resize the control accoring to its text size;
  TCheckBox = class(FMX.StdCtrls.TCheckBox)
  private
    FAutoSize: Boolean;

    procedure AdjustSizeToText;
    procedure SetAutoSize(const Value: Boolean);
  protected
    procedure SetText(const Value: string); override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default True;
  end;
  {$ENDREGION}

  {$REGION 'TRadioButton'}
  // Add a autosize property (Default: True) that resize the control accoring to its text size;
  TRadioButton = class(FMX.StdCtrls.TRadioButton)
  private
    FAutoSize: Boolean;

    procedure AdjustSizeToText;
    procedure SetAutoSize(const Value: Boolean);
  protected
    procedure SetText(const Value: string); override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default True;
  end;
  {$ENDREGION}

  {$REGION 'TCombobox'}
  // Add a ownerdraw property to support basic drawing by TListBoxItem.OnPaint
  TCombobox = class(FMX.ListBox.TComboBox)
  private
    FOwnerDraw: Boolean;
    FOnPopup: TNotifyEvent;
  protected
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure MyOnPopup(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    property OwnerDraw: Boolean read FOwnerDraw write FOwnerDraw;
  published
    property OnPopup: TNotifyEvent read FOnPopup write FOnPopup;
  end;
  {$ENDREGION}

  {$REGION 'TTrackbar'}
  // Add  OnThumbDblClick and OnThumbClick, fix hint not show on thumb
  TTrackbar = class(FMX.StdCtrls.TTrackBar)
  private
    FOnThumbDblClick: TNotifyEvent;
    FOnThumbClick: TNotifyEvent;
    FDefaultValue: Double;
  protected
    procedure DoThumbClick(Sender: TObject);            override;
    procedure DoThumbDblClick(Sender: TObject);         override;
    procedure DoAddObject(const AObject: TFmxObject);   override;
    procedure SetHint(const AHint: string);             override;
  public
    procedure SetToDefault;
    procedure SetAsDefault;

    property DefaultValue: Double           read FDefaultValue      write FDefaultValue;
    property ThumbRect: TRectF              read GetThumbRect;
    property OnThumbDblClick: TNotifyEvent  read FOnThumbDblClick   write FOnThumbDblClick;
    property OnThumbClick: TNotifyEvent     read FOnThumbClick      write FOnThumbClick;
  end;
  {$ENDREGION}

  {$REGION 'TExpander'}
  // Add a CheckBoxEnabled property and access to CheckBox;
  TExpander = class(FMX.StdCtrls.TExpander)
  private
    FAutoSize: Boolean;
    function GetCheckBoxEnabled: Boolean; inline;
    procedure SetCheckBoxEnabled(const Value: Boolean); inline;
    procedure SetAutoSize(const Value: Boolean);
  protected
    procedure DoExpandedChanged; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetContent: TContent;
    function GetUsedContentRect: TRectF;
    function GetHeaderHeight: Single;
    function CheckBox: FMX.StdCtrls.TCheckBox;
    procedure UpdateSize;

    property CheckBoxEnabled: Boolean read GetCheckBoxEnabled write SetCheckBoxEnabled;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
  end;
  {$ENDREGION}

  {$REGION 'TEdit'}
  // Prevents beeping on Enter key and allows double click to select all, instead of a word
  TEdit = class(FMX.Edit.TEdit)
  public
    FDoubleClickSelectAll: Boolean;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure KeyDown(var Key: Word; var KeyChar: WideChar; Shift: TShiftState); override;
  public
    property DoubleClickSelectAll: Boolean read FDoubleClickSelectAll write FDoubleClickSelectAll;
  end;
  {$ENDREGION}

implementation

uses
  FMX.Edit.Style.New;

const
  // For TCheckBox and TRadioButton
  DefCheckBoxSize: Single = 22;
  ExtraWidth: Single = 4;               // For safety and extra space to click

{$REGION 'TCheckBox'}
constructor TCheckBox.Create(AOwner: TComponent);
begin
  inherited;
  FAutoSize := True;
  AdjustSizeToText;
end;

procedure TCheckBox.SetAutoSize(const Value: Boolean);
begin
  FAutoSize := Value;
  if FAutoSize then AdjustSizeToText;
end;

procedure TCheckBox.SetText(const Value: string);
begin
  inherited SetText(Value);
  if FAutoSize then AdjustSizeToText;
end;

procedure TCheckBox.Resize;
begin
  inherited;
  if FAutoSize then AdjustSizeToText;
end;

procedure TCheckBox.AdjustSizeToText;
var
  Rect: TRectF;
  TextObj: TText;
  TextX: Single;
begin
  if not Assigned(Canvas) then exit;
  if not (Align in [TAlignLayout.Client, TAlignLayout.Contents]) then
  begin
    TextObj := FindStyleResource('text') as TText;
    if Assigned(TextObj)
      then TextX := TextObj.Position.X
      else TextX := DefCheckBoxSize;   // in most style this is 21;
    if TextSettings.WordWrap
      then Rect := RectF(0, 0, Size.Width - TextX, 100000)
      else Rect := RectF(0, 0, 100000, 1000);
    Canvas.MeasureText(Rect, Text, TextSettings.WordWrap, [], TTextAlign.Leading, TTextAlign.Leading);
    SetSize(Rect.Width + TextX + ExtraWidth, Rect.Height);
  end;
end;
{$ENDREGION}

{$REGION 'TRadioButton'}
constructor TRadioButton.Create(AOwner: TComponent);
begin
  inherited;
  FAutoSize := True;
  AdjustSizeToText;
end;

procedure TRadioButton.SetAutoSize(const Value: Boolean);
begin
  FAutoSize := Value;
  if FAutoSize then AdjustSizeToText;
end;

procedure TRadioButton.SetText(const Value: string);
begin
  inherited SetText(Value);
  if FAutoSize then AdjustSizeToText;
end;

procedure TRadioButton.Resize;
begin
  inherited;
  if FAutoSize then AdjustSizeToText;
end;

procedure TRadioButton.AdjustSizeToText;
var
  Rect: TRectF;
  TextObj: TText;
  TextX: Single;
begin
  if not Assigned(Canvas) then exit;
  if not (Align in [TAlignLayout.Client, TAlignLayout.Contents]) then
  begin
    TextObj := FindStyleResource('text') as TText;
    if Assigned(TextObj)
      then TextX := TextObj.Position.X
      else TextX := DefCheckBoxSize;   // in most style this is 21;
    if TextSettings.WordWrap
      then Rect := RectF(0, 0, Size.Width - TextX, 100000)
      else Rect := RectF(0, 0, 100000, 1000);
    Canvas.MeasureText(Rect, Text, TextSettings.WordWrap, [], TTextAlign.Leading, TTextAlign.Leading);
    SetSize(Rect.Width + TextX + ExtraWidth, Rect.Height);
  end;
end;
{$ENDREGION}

{$REGION 'TExpander'}
{ TExpander }

constructor TExpander.Create(AOwner: TComponent);
begin
  inherited;
  FAutoSize := True;
end;

function TExpander.CheckBox: FMX.StdCtrls.TCheckBox;
begin
  Result := FCheck;
end;

function TExpander.GetCheckBoxEnabled: Boolean;
begin
  Result := Assigned(FCheck) and FCheck.Enabled;
end;

procedure TExpander.SetCheckBoxEnabled(const Value: Boolean);
begin
  if Assigned(FCheck) then FCheck.Enabled := Value;
end;

function TExpander.GetHeaderHeight: Single;
begin
  Result := EffectiveHeaderHeight;
end;

function TExpander.GetContent: TContent;
begin
  Result := FContent;
end;

function TExpander.GetUsedContentRect: TRectF;
begin
  if not Assigned(FContent) then Exit(TRectF.Empty);
  Result := FContent.UsedClientRect;
end;

procedure TExpander.DoExpandedChanged;
begin
  inherited;
  if FAutoSize then UpdateSize;
end;

procedure TExpander.UpdateSize;
begin
  if IsExpanded then
    Height := GetHeaderHeight + GetUsedContentRect.Bottom + Padding.bottom;
end;

procedure TExpander.SetAutoSize(const Value: Boolean);
begin
  FAutoSize := Value;
  if FAutoSize then UpdateSize;
end;
{$ENDREGION}

{$REGION 'TCombobox'}
{ TCombobox }

constructor TCombobox.Create(AOwner: TComponent);
begin
  inherited;
  inherited OnPopup := MyOnPopup;
end;

procedure TCombobox.DoAddObject(const AObject: TFmxObject);
begin
  inherited;
  if not FOwnerDraw then Exit;
  if SameText('TPopupListPicker', AObject.ClassName) then
  begin
    var LB := ListBox;
    if (LB = nil) or Assigned(LB.TagObject) then Exit;
    LB.TagObject := TControl(AObject).GetControlByClass(FMX.ListBox.TListBox, True);
  end;
end;

procedure TCombobox.MyOnPopup(Sender: TObject);
begin
  if FOwnerDraw then
  begin
    var LB := ListBox;
    if LB = nil then Exit;
    var LB2 := LB.TagObject as FMX.ListBox.TListBox;
    if LB2 = nil then Exit;
    for var i := 0 to ez.Min(LB.Count, LB2.Count) - 1 do
      LB2.ListItems[i].OnPaint := LB.ListItems[i].OnPaint;
  end;
  if Assigned(FOnPopup) then FOnPopup(Sender);
end;
{$ENDREGION}

{$REGION 'TTrackbar'}
{ TTrackbar }

procedure TTrackbar.DoThumbClick(Sender: TObject);
begin
  if Assigned(FOnThumbClick) then
  begin
    var Old := OnClick;
    inherited;
    OnClick := Old;
    FOnThumbClick(Self);
  end else inherited;
end;

procedure TTrackbar.DoThumbDblClick(Sender: TObject);
begin
  if Assigned(FOnThumbDblClick) then
  begin
    var Old := OnDblClick;
    inherited;
    OnDblClick := Old;
    FOnThumbDblClick(Self);
  end else inherited;
end;

procedure TTrackbar.DoAddObject(const AObject: TFmxObject);
begin
  inherited;
  if not (AObject is TControl) then exit;
  var Thumbs := GetControlsByClass(TThumb, True);
  for var i := 0 to Length(Thumbs) - 1 do
    TThumb(Thumbs[i]).Hint := Hint;
end;

procedure TTrackbar.SetHint(const AHint: string);
begin
  inherited;
  var Thumbs := GetControlsByClass(TThumb, True);
  for var i := 0 to Length(Thumbs) - 1 do
    TThumb(Thumbs[i]).Hint := AHint;
end;

procedure TTrackbar.SetAsDefault;
begin
  FDefaultValue := Value;
end;

procedure TTrackbar.SetToDefault;
begin
  Value := FDefaultValue;
end;
{$ENDREGION}

{$REGION 'TEdit'}
{ TEdit }

procedure TEdit.KeyDown(var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
  inherited;
  if Key = vkReturn then Key := 0      // suppress the beep
  else if Key = vkEscape then
  begin
    ResetSelection;
    Key := 0;
  end;
end;

procedure TEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if FDoubleClickSelectAll and (Button = TMouseButton.mbLeft) and (ssDouble in Shift) then
  begin
    inherited MouseDown(Button, Shift - [ssDouble], X, Y);
    // This line in TStyledEdit.MouseDown in FMX.Edit.Style.New makes it immposible to fix it completely
    //   FEditor.SelectionController.HoldSelection;
    TTaskScheduler.Run(10, procedure begin
      var StyledEdit := TStyledEdit(GetControlByClass(TStyledEdit, True));
      if Assigned(StyledEdit) then
      begin
        StyledEdit.Editor.SelectionController.UnholdSelection;
        SelectAll;
        StyledEdit.Editor.SelectionController.HoldSelection;
      end else SelectAll;
    end);
  end else inherited;
end;
{$ENDREGION}

end.
