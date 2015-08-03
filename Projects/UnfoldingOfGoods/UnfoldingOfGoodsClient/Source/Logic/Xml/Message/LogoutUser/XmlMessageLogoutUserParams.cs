using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Message.LogoutUser
{
    public class XmlMessageLogoutUserParams : CustomXmlElement
    {

        public XmlMessageLogoutUserParams(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public String UserName
        {
            set { SetAttribute("UserName", value); }
        }

    }
}