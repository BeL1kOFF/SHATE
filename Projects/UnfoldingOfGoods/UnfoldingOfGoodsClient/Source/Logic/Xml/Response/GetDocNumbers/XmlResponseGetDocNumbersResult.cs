using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Response.GetDocNumbers
{
    public class XmlResponseGetDocNumbersResult : CustomXmlResponseResult
    {

        public XmlResponseGetDocNumbersResult(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public XmlResponseGetDocNumbersResultDocuments Documents
        {
            get { return new XmlResponseGetDocNumbersResultDocuments(GetElement("Documents")); }
        }

    }
}