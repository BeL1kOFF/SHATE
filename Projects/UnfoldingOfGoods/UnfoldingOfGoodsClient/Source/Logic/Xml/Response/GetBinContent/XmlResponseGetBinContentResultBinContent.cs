using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Response.GetBinContent
{
    public class XmlResponseGetBinContentResultBinContent : CustomXmlElement
    {

        public XmlResponseGetBinContentResultBinContent(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public XmlResponseGetBinContentResultBinContentItem Item(Int32 aIndex)
        {
            return new XmlResponseGetBinContentResultBinContentItem((XmlElement)XmlElement.ChildNodes[aIndex]);
        }

        public String ItemNo { get { return GetAttribute("ItemNo"); } }

        public String ItemNo2 { get { return GetAttribute("ItemNo2"); } }

        public Int32 Count { get { return XmlElement.ChildNodes.Count; } }

    }
}