using System;
using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Response.GetDocPlacement
{
    public class XmlResponseGetDocPlacement : CustomXmlResponse
    {

        public XmlResponseGetDocPlacement(String aXml)
            : base(aXml)
        {
        }

        override protected CustomXmlResponseResult GetClass(XmlElement aXmlElement)
        {
            return new XmlResponseGetDocPlacementResult(aXmlElement);
        }

        new public XmlResponseGetDocPlacementResult Result
        {
            get { return (XmlResponseGetDocPlacementResult)base.Result; }
        }

    }
}