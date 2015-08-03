using System;
using UnfoldingOfGoods.Logic.Xml.Message.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Message.LogoutUser
{
    public class XmlMessageLogoutUser : CustomXmlMessageParams
    {

        public XmlMessageLogoutUser()
            : base()
        {
        }

        override protected void CreateParams()
        {
            base.CreateParams();
            CreateAttribute(base.Params, "UserName");
        }

        override protected void CreateXml()
        {
            base.CreateXml();
            SetMessage("LogoutUser");
        }

        new public XmlMessageLogoutUserParams Params
        {
            get { return new XmlMessageLogoutUserParams(base.Params); }
        }

    }
}