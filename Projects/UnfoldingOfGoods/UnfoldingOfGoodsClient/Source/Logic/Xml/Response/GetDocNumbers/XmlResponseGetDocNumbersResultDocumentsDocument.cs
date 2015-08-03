using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Response.GetDocNumbers
{
    public class XmlResponseGetDocNumbersResultDocumentsDocument : CustomXmlElement
    {

        public XmlResponseGetDocNumbersResultDocumentsDocument(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public String No
        {
            get { return GetAttribute("No"); }
        }

    }
}