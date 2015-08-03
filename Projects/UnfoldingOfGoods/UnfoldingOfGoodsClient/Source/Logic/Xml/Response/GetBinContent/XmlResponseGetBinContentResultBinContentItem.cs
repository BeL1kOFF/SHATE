using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Response.GetBinContent
{
    public class XmlResponseGetBinContentResultBinContentItem : CustomXmlElement
    {

        public XmlResponseGetBinContentResultBinContentItem(XmlElement aXmlElement)
            : base (aXmlElement)
        {
        }

        public String BinCode { get { return GetAttribute("BinCode"); } }

        public Decimal Quantity { get { return Convert.ToDecimal(GetAttribute("Quantity")); } }

        public Byte Fixed { get { return Convert.ToByte(GetAttribute("Fixed")); } }

        public Byte Default { get { return Convert.ToByte(GetAttribute("Default")); } }

    }
}