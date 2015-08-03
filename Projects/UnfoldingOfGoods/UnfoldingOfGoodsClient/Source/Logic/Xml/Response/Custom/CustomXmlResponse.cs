using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Response.Custom
{

    abstract public class CustomXmlResponse : CustomXml
    {

        private XmlDocument FXmlDocument;

        public CustomXmlResponse(String aXml)
            : base()
        {
            FXmlDocument = new XmlDocument();
            FXmlDocument.LoadXml(aXml);
        }

        abstract protected CustomXmlResponseResult GetClass(XmlElement aXmlNode);

        protected XmlDocument XmlDocument
        {
            get { return FXmlDocument; }
        }

        public String Type
        {
            get { return GetAttribute(XmlDocument.DocumentElement, "Type"); }
        }

        public XmlResponseError Error
        {
            get { return new XmlResponseError(GetElement(XmlDocument.DocumentElement, "Error")); }
        }

        public CustomXmlResponseResult Result
        {
            get { return GetClass(GetElement(XmlDocument.DocumentElement, "Result")); }
        }

    }
}