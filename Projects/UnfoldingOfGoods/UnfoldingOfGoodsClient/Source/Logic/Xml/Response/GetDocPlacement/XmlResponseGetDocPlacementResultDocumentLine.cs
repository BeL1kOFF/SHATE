using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Response.GetDocPlacement
{
    public class XmlResponseGetDocPlacementResultDocumentLine : CustomXmlElement
    {

        public XmlResponseGetDocPlacementResultDocumentLine(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public String No
        {
            get { return GetAttribute("No"); }
        }

        public String ItemNo
        {
            get { return GetAttribute("ItemNo"); }
        }

        public String ItemNo2
        {
            get { return GetAttribute("ItemNo2"); }
        }

        public String Description
        {
            get { return GetAttribute("Description"); }
        }

        public String UnitOfMeasure
        {
            get { return GetAttribute("UnitOfMeasure"); }
        }

        public Int32 QtyPlacement
        {
            get { return Convert.ToInt32(GetAttribute("QtyPlacement")); }
        }

        public Int32 ProcessedQty
        {
            get { return Convert.ToInt32(GetAttribute("ProcessedQty")); }
        }

        public String BinCode
        {
            get { return GetAttribute("BinCode"); }
        }

        public Int32 BinContQty
        {
            get { return Convert.ToInt32(GetAttribute("BinContQty")); }
        }

        public Int32 LineNo
        {
            get { return Convert.ToInt32(GetAttribute("LineNo")); }
        }

        public Int32 QuantityInPackage
        {
            get { return Convert.ToInt32(GetAttribute("QuantityInPackage")); }
        }

    }
}