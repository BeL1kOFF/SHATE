using System;
using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Response.GetBinContent
{
    public class XmlResponseGetBinContentResult : CustomXmlResponseResult
    {

        public XmlResponseGetBinContentResult(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public XmlResponseGetBinContentResultBinContent BinContent
        {
            get { return new XmlResponseGetBinContentResultBinContent(GetElement("BinContent")); }
        }

    }
}