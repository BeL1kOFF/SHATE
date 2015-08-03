using System;
using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Response.GetDocNumbers
{
    public class XmlResponseGetDocNumbers : CustomXmlResponse
    {

        public XmlResponseGetDocNumbers(String aXml)
            : base(aXml)
        {
        }

        override protected CustomXmlResponseResult GetClass(XmlElement aXmlElement)
        {
            return new XmlResponseGetDocNumbersResult(aXmlElement);
        }

        new public XmlResponseGetDocNumbersResult Result
        {
            get { return (XmlResponseGetDocNumbersResult)base.Result; }
        }

    }
}