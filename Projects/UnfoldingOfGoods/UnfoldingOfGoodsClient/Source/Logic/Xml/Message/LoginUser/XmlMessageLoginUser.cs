using System;
using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Message.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Message.LoginUser
{
    public class XmlMessageLoginUser : CustomXmlMessageParams
    {

        public XmlMessageLoginUser()
            : base()
        {
        }

        override protected void CreateParams()
        {
            base.CreateParams();
            CreateAttribute(base.Params, "UserName");
            CreateAttribute(base.Params, "UserLocation");
            CreateAttribute(base.Params, "MachineName");
            CreateAttribute(base.Params, "Version");
        }

        override protected void CreateXml()
        {
            base.CreateXml();
            SetMessage("LoginUser");
        }

        new public XmlMessageLoginUserParams Params
        {
            get { return new XmlMessageLoginUserParams(base.Params); }
        }

    }
}