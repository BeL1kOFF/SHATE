using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Message.RegisterPlacement
{
    public class XmlMessageRegisterPlacementDocument : CustomXmlElement
    {

        public XmlMessageRegisterPlacementDocument(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public XmlMessageRegisterPlacementDocumentLine AddLineInDocument()
        {
            XmlElement xeLine = null;
            XmlAttribute xa = null;
            XmlDocument xDoc = XmlElement.OwnerDocument;
            xeLine = xDoc.CreateElement("Line");
            XmlElement.AppendChild(xeLine);
            xa = xDoc.CreateAttribute("No");
            xeLine.Attributes.Append(xa);
            xa = xDoc.CreateAttribute("LineNo");
            xeLine.Attributes.Append(xa);
            xa = xDoc.CreateAttribute("ItemNo");
            xeLine.Attributes.Append(xa);
            xa = xDoc.CreateAttribute("PlacedQty");
            xeLine.Attributes.Append(xa);
            xa = xDoc.CreateAttribute("BinCode");
            xeLine.Attributes.Append(xa);
            return new XmlMessageRegisterPlacementDocumentLine(xeLine);
        }

        public XmlMessageRegisterPlacementDocumentLine Item(Int32 aIndex)
        {
            return new XmlMessageRegisterPlacementDocumentLine((XmlElement)XmlElement.ChildNodes[aIndex]);
        }

        public Int32 Count
        {
            get { return XmlElement.ChildNodes.Count; }
        }

        public String No
        {
            get { return GetAttribute("No"); }
            set { SetAttribute("No", value); }
        }

    }
}