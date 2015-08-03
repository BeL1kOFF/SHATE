using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml
{
    abstract public class CustomXmlElement : CustomXml
    {

        private XmlElement FXmlElement;

        public CustomXmlElement(XmlElement aXmlElement)
            : base()
        {
            FXmlElement = aXmlElement;
        }

        protected XmlElement XmlElement
        {
            get { return FXmlElement; }
        }

        protected String GetAttribute(String aName)
        {
            return GetAttribute(FXmlElement, aName);
        }

        protected void SetAttribute(String aName, String aValue)
        {
            SetAttribute(FXmlElement, aName, aValue);
        }

        protected XmlElement GetElement(String aName)
        {
            return GetElement(FXmlElement, aName);
        }

        protected String GetValue(String aName)
        {
            return GetValue(FXmlElement, aName);
        }

    }
}