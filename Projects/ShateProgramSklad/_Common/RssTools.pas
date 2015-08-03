unit RssTools;

interface

uses
  Classes;

type
  TRssNewsItem = class
    Date: TDateTime;
    GUID: string;
    DateRaw: string;
    Text: string;
    ImageName: string;
    Link: string;

    IsNew: Boolean;
    IsModified: Boolean;
  end;

function EncodeRssRunningLine(const aXml: string; out aRunningLine: string; out aDate: TDateTime): Boolean;
function EncodeRssNews(const aXml: string; aList: TList): Boolean;
function CompareRss(aListOld, aListNew: TList): Boolean;
//function AppendRss(aListOld, aListNew: TList): Boolean;
function BuildRssHtml(aList: TList; aMaxItems: Integer = -1; const aTemplate: string = ''{use Def}): string;

implementation

uses
  SysUtils, NativeXml;

const
  cRssPageTemplate =
    '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"'#13#10 +
    '"http://www.w3.org/TR/html4/loose.dtd">'#13#10 +
    '<html>'#13#10 +
    '<head>'#13#10 +
    '	<title>Последние новости Шате-М плюс</title>'#13#10 +
    '</head>'#13#10 +
    '<body bgcolor = "#FFFFEF">'#13#10 + //bgcolor = "#faf0e6"   
    '	<table width="100%" style="position:relative;left:4px;" border = "0 bgcolor="#757473">'#13#10 +
    ' #LIST#'#13#10 +
    '	</table>'#13#10 +
    '</body>'#13#10 +
    '</html>';

  // date / image / text / link
  cRssRowTemplate =
    '<!-- news row --> '#13#10 +
    '		<tr bgcolor = "#eeeeee">'#13#10 + //#eeeeee
    '			<td COLSPAN=2 align = "left" valign ="top">%s</td>'#13#10 +
    '		</tr>'#13#10 +
    '		<tr>'#13#10 +
    '			<td width = "20" valign = "top">'#13#10 +
    '				<img src="thumbs/rss/%s" style="float: left; width: 70px; margin: 0px 5px 5px 0px" />'#13#10 +
    '			</td>'#13#10 +
    '			<td align = "left">'#13#10 +
    '				<span>%s</span>'#13#10 +
    '			</td>'#13#10 +
    '		</tr>'#13#10 +
		'<tr height = "30px" valign = "top">'#13#10 +
		'	<td></td>'#13#10 +
		'	<td align = "right">'#13#10 +
		'		<A href="%s" title="Читать далее на сайте"><Font style="font-size: 12px">Читать далее...</Font</A>'#13#10 +
		'	</td>'#13#10 +
		'</tr>'#13#10;

  cRssRowTemplateModified =
    '<!-- news row --> '#13#10 +
    '		<tr bgcolor = "#eeeeee">'#13#10 + //#eeeeee
    '			<td COLSPAN=2 align = "left" valign ="top">%s <Font color = "#FF3333"><i>(дополнено)</i></td>'#13#10 +
    '		</tr>'#13#10 +
    '		<tr>'#13#10 +
    '			<td width = "20" valign = "top">'#13#10 +
    '				<img src="thumbs/rss/%s" style="float: left; width: 70px; margin: 0px 5px 5px 0px" />'#13#10 +
    '			</td>'#13#10 +
    '			<td align = "left">'#13#10 +
    '				<span>%s</span>'#13#10 +
    '			</td>'#13#10 +
    '		</tr>'#13#10 +
		'<tr height = "30px" valign = "top">'#13#10 +
		'	<td></td>'#13#10 +
		'	<td align = "right">'#13#10 +
		'		<A href="%s" title="Читать далее на сайте"><Font style="font-size: 12px">Читать далее...</Font</A>'#13#10 +
		'	</td>'#13#10 +
		'</tr>'#13#10;

  cRssRowTemplateNew =
    '<!-- news row --> '#13#10 +
    '		<tr bgcolor = "#eeeeee">'#13#10 +
    '			<td COLSPAN=2 align = "left" valign ="top"><b>%s</b> <img src="thumbs/rss/new_item.gif"/></td>'#13#10 +
    '		</tr>'#13#10 +
    '		<tr>'#13#10 +
    '			<td width = "20" valign = "top">'#13#10 +
    '				<img src="thumbs/rss/%s" style="float: left; width: 70px; margin: 0px 5px 5px 0px" />'#13#10 +
    '			</td>'#13#10 +
    '			<td align = "left">'#13#10 +
    '				<span>%s</span>'#13#10 +
    '			</td>'#13#10 +
    '		</tr>'#13#10 +
		'<tr height = "30px" valign = "top">'#13#10 +
		'	<td></td>'#13#10 +
		'	<td align = "right">'#13#10 +
		'		<A href="%s" title="Читать далее на сайте"><Font style="font-size: 12px">Читать далее...</Font</A>'#13#10 +
		'	</td>'#13#10 +
		'</tr>'#13#10;


function EncodeRssRunningLine(const aXml: string; out aRunningLine: string; out aDate: TDateTime): Boolean;

  function EncodeRssNode(aNode: TXmlNode; aFS: TFormatSettings; out aDateTime: TDateTime): string;
  begin
    aDateTime := StrToDateTime(aNode.NodeByName('pubDate').ValueAsString, aFS);
    Result := aNode.NodeByName('description').ValueAsString;
  end;

var
  i: Integer;
  aXMLDoc: TNativeXml;
  aNode: TXmlNode;
  aChannelItems: TList;
  aNewsItem: TRssNewsItem;

  aFS: TFormatSettings;
begin
  Result := False;

try  
  aXMLDoc := TNativeXml.Create;
  aXMLDoc.ReadFromString(aXml);

  //RSS/Channel/...Item
  if not Assigned(aXMLDoc.Root) then
    Exit;
  if not Assigned(aXMLDoc.Root.NodeByName('Channel')) then
    Exit;

  GetLocaleFormatSettings(-1{GetThreadLocale}, aFS);
  aFS.DateSeparator := '.';
  aFS.ShortDateFormat := 'dd.mm.yyyy';
  aFS.LongDateFormat := 'd MMMM yyyy';

  aFS.TimeSeparator := ':';
  aFS.ShortTimeFormat := 'HH:nn';
  aFS.LongTimeFormat := 'HH:nn:ss';

  aChannelItems := TList.Create;
  try
    aXMLDoc.Root.NodeByName('Channel').NodesByName('Item', aChannelItems);

    for i := 0 to aChannelItems.Count - 1 do
    begin
      aNode := aChannelItems[i];
      aRunningLine := EncodeRssNode(aNode, aFS, aDate);
    end;

  finally
    aChannelItems.Free;
  end;
except
  Exit;
end;

  Result := True;
end;

function EncodeRssNews(const aXml: string; aList: TList): Boolean;

  function EncodeRssNode(aNode: TXmlNode; aFS: TFormatSettings): TRssNewsItem;
  begin
    Result := TRssNewsItem.Create;

    Result.Date := StrToDateTime(aNode.NodeByName('pubDate').ValueAsString, aFS);
    Result.DateRaw := FormatDateTime('dd.mm.yyyy HH":"nn', Result.Date);

    Result.Text := aNode.NodeByName('description').ValueAsString;
    Result.ImageName := aNode.NodeByName('enclosure').AttributeByName['url'];
    Result.Link := aNode.NodeByName('link').ValueAsString;
    Result.GUID := aNode.NodeByName('GUID').ValueAsString;

    while Pos('/', Result.ImageName) > 0 do
      Delete(Result.ImageName, 1, Pos('/', Result.ImageName));

    if Result.ImageName = '' then
      Result.ImageName := 'shate.jpg'
  end;
var
  i: Integer;
  aXMLDoc: TNativeXml;
  aNode: TXmlNode;
  aChannelItems: TList;
  aNewsItem: TRssNewsItem;

  aFS: TFormatSettings;
begin
  Result := False;

try
  aXMLDoc := TNativeXml.Create;
  aXMLDoc.ReadFromString(aXml);

  //RSS/Channel/...Item
  if not Assigned(aXMLDoc.Root) then
    Exit;
  if not Assigned(aXMLDoc.Root.NodeByName('Channel')) then
    Exit;

  GetLocaleFormatSettings(-1{GetThreadLocale}, aFS);
  aFS.DateSeparator := '.';
  aFS.ShortDateFormat := 'dd.mm.yyyy';
  aFS.LongDateFormat := 'd MMMM yyyy';

  aFS.TimeSeparator := ':';
  aFS.ShortTimeFormat := 'HH:nn';
  aFS.LongTimeFormat := 'HH:nn:ss';

  aChannelItems := TList.Create;
  try
    aXMLDoc.Root.NodeByName('Channel').NodesByName('Item', aChannelItems);

    for i := 0 to aChannelItems.Count - 1 do
    begin
      aNode := aChannelItems[i];
      aNewsItem := EncodeRssNode(aNode, aFS);
      aList.Add(aNewsItem);
    end;

  finally
    aChannelItems.Free;
  end;
except
  Exit;
end;
  Result := True;
end;

function CompareRss(aListOld, aListNew: TList): Boolean;
var
  i, j: Integer;
  aItemNew, aItemOld: TRssNewsItem;
  aNextNew: Boolean;
begin
  Result := False;

  aNextNew := True;
  for i := 0 to aListNew.Count - 1 do
  begin
    aItemNew := aListNew[i];
    aItemNew.IsNew := aNextNew;

    for j := 0 to aListOld.Count - 1 do
    begin
      aItemOld := aListOld[j];
      if (aItemOld.GUID = aItemNew.GUID) then
      begin
        if (aItemOld.Date = aItemNew.Date) then
          aItemNew.IsNew := False
        else
        begin
          aItemNew.IsNew := False;
          aItemNew.IsModified := True;
        end;
      end;
    end;
    aNextNew := aItemNew.IsNew;
    Result := Result or aItemNew.IsNew or aItemNew.IsModified;
  end;
end;

{
function AppentRss(aListOld, aListNew: TList): Boolean;
var
  i, j: Integer;
  aItemNew, aItemOld: TRssNewsItem;
begin
  Result := False;

  for i := 0 to aListNew.Count - 1 do
  begin
    aItemNew := aListNew[i];
    aItemNew.IsNew := True;

    for j := 0 to aListOld.Count - 1 do
    begin
      aItemOld := aListOld[j];
      if (aItemOld.GUID = aItemNew.GUID) and (aItemOld.Date = aItemNew.Date) then
      begin
        aItemNew.IsNew := False;
        Exit;
      end;
    end;
    Result := True;
  end;
end;
}

function BuildRssHtml(aList: TList; aMaxItems: Integer; const aTemplate: string): string;
var
  i: Integer;
  aItem: TRssNewsItem;
  aRssHtml: string;
begin
  aRssHtml := '';

  for i := 0 to aList.Count - 1 do
  begin
    aItem := aList[i];
  
    if aMaxItems > 0 then
      if i >= aMaxItems then
        if not aItem.IsNew then
          Break;

    if aItem.IsNew then
      aRssHtml := aRssHtml + Format(cRssRowTemplateNew, [aItem.DateRaw, aItem.ImageName, aItem.Text, aItem.Link])
    else
      if aItem.IsModified then
        aRssHtml := aRssHtml + Format(cRssRowTemplateModified, [aItem.DateRaw, aItem.ImageName, aItem.Text, aItem.Link])
      else
        aRssHtml := aRssHtml + Format(cRssRowTemplate, [aItem.DateRaw, aItem.ImageName, aItem.Text, aItem.Link]);
  end;

  if aTemplate <> '' then
    Result := StringReplace(aTemplate, '#LIST#', aRssHtml, [rfReplaceAll])
  else
    Result := StringReplace(cRssPageTemplate, '#LIST#', aRssHtml, [rfReplaceAll]);
end;

end.
