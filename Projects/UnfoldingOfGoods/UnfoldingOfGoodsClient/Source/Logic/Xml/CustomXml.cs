using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml
{
    abstract public class CustomXml
    {
        
        public CustomXml()
        {
        }
        
        protected String GetAttribute(XmlElement aXmlElement, String aName)
        {
            return aXmlElement.GetAttribute(aName);
        }

        protected void SetAttribute(XmlElement aXmlElement, String aName, String aValue)
        {
            aXmlElement.SetAttribute(aName, aValue);
        }

        protected XmlElement GetElement(XmlElement aXmlElement, String aName)
        {
            return (XmlElement)aXmlElement.GetElementsByTagName(aName).Item(0);
        }

        protected String GetValue(XmlElement aXmlElement, String aName)
        {
            return GetElement(aXmlElement, aName).FirstChild.Value;
        }

    }
}