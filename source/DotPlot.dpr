program DotPlot;

{$I wc.Base.inc}

uses
  System.StartUpCopy, Xml.xmldom, Xml.omnixmldom,
  FMX.Forms,
  uDotPlot in 'uDotPlot.pas' {Form1},
  uDataSet in 'uDataSet.pas',
  uPlotSettings in 'uPlotSettings.pas',
  uDrawing in 'uDrawing.pas',
  uDrawSVG in 'uDrawSVG.pas',
  uDrawCanvas in 'uDrawCanvas.pas';

{$R *.res}

begin
  DefaultDOMVendor := sOmniXmlVendor;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
