using System;
using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Response.GetExpiredData
{
    public class XmlResponseGetExpiredData : CustomXmlResponse
    {

        public XmlResponseGetExpiredData(String aXml)
            : base(aXml)
        {
        }

        override protected CustomXmlResponseResult GetClass(XmlElement aXmlElement)
        {
            throw new System.NotImplementedException();
        }

        new public Int32 Result
        {
            get { return Convert.ToInt32(GetValue(XmlDocument.DocumentElement, "Result")); }
        }

    }
}