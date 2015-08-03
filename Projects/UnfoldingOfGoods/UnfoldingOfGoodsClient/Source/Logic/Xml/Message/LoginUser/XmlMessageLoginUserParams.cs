using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Message.LoginUser
{
    public class XmlMessageLoginUserParams : CustomXmlElement
    {

        public XmlMessageLoginUserParams(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public String UserName
        {
            set { SetAttribute("UserName", value); }
        }

        public String UserLocation
        {
            set { SetAttribute("UserLocation", value); }
        }

        public String MachineName
        {
            set { SetAttribute("MachineName", value); }
        }

        public String Version
        {
            set { SetAttribute("Version", value); }
        }

    }
}