using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Message.GetExpiredData
{
    public class XmlMessageGetExpiredDataParams : CustomXmlElement
    {

        public XmlMessageGetExpiredDataParams(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public DateTime DateTime
        {
            set { SetAttribute("DateTime", value.ToString("dd.MM.yyyy HH:mm:ss")); }
        }

        public String Version
        {
            set { SetAttribute("Version", value); }
        }

    }
}