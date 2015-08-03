using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Message.RegisterPlacement
{
    public class XmlMessageRegisterPlacementDocumentLine : CustomXmlElement
    {

        public XmlMessageRegisterPlacementDocumentLine(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public Int32 No
        {
            get { return Convert.ToInt32(GetAttribute("No")); }
            set { SetAttribute("No", Convert.ToString(value)); }
        }
        public Int32 LineNo
        {
            get { return Convert.ToInt32(GetAttribute("LineNo")); }
            set { SetAttribute("LineNo", Convert.ToString(value)); }
        }
        public String ItemNo
        {
            get { return GetAttribute("ItemNo"); }
            set { SetAttribute("ItemNo", value); }
        }
        public Int32 PlacedQty
        {
            get { return Convert.ToInt32(GetAttribute("PlacedQty")); }
            set { SetAttribute("PlacedQty", Convert.ToString(value)); }
        }
        public String BinCode
        {
            get { return GetAttribute("BinCode"); }
            set { SetAttribute("BinCode", value); }
        }

    }
}