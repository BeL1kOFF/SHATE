using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Response.GetDocPlacement
{
    public class XmlResponseGetDocPlacementResultDocument : CustomXmlElement
    {

        public XmlResponseGetDocPlacementResultDocument(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public XmlResponseGetDocPlacementResultDocumentLine Line(Int32 aIndex)
        {
            return new XmlResponseGetDocPlacementResultDocumentLine((XmlElement)XmlElement.ChildNodes[aIndex]);
        }

        public String No
        {
            get { return GetAttribute("No"); }
        }

        public Int32 Count
        {
            get { return XmlElement.ChildNodes.Count; }
        }

    }
}