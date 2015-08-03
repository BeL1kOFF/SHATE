using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Response.Custom
{
    public class XmlResponseError : CustomXmlElement
    {

        public XmlResponseError(XmlElement aXmlNode)
            : base(aXmlNode)
        {
        }

        public Int32 Code
        {
            get { return Convert.ToInt32(GetAttribute("Code")); }
        }

        public String NodeValue
        {
            get { return XmlElement.FirstChild.Value; }
        }

    }
}