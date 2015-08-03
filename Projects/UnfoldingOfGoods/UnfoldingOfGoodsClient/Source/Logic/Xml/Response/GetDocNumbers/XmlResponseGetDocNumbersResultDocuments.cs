using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Response.GetDocNumbers
{
    public class XmlResponseGetDocNumbersResultDocuments : CustomXmlElement
    {

        public XmlResponseGetDocNumbersResultDocuments(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public XmlResponseGetDocNumbersResultDocumentsDocument Document(Int32 aIndex)
        {
            return new XmlResponseGetDocNumbersResultDocumentsDocument((XmlElement)XmlElement.ChildNodes[aIndex]);
        }

        public Int32 Count
        {
            get { return XmlElement.ChildNodes.Count; }
        }

    }
}