using System;
using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Response.GetBinContent
{
    class XmlResponseGetBinContent : CustomXmlResponse
    {

        public XmlResponseGetBinContent(String aXml)
            : base(aXml)
        {
        }

        override protected CustomXmlResponseResult GetClass(XmlElement aXmlElement)
        {
            return new XmlResponseGetBinContentResult(aXmlElement);
        }

        new public XmlResponseGetBinContentResult Result
        {
            get { return (XmlResponseGetBinContentResult)base.Result; }
        }

    }
}