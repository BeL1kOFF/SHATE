using System;
using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Response.LoginUser
{
    public class XmlResponseLoginUserResult : CustomXmlResponseResult
    {
        private static System.Globalization.CultureInfo provider = System.Globalization.CultureInfo.InvariantCulture;

        public XmlResponseLoginUserResult(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public String UserFio
        {
            get { return GetValue("UserFio"); }
        }

        public Guid Session
        {
            get { return new Guid(GetValue("Session")); }
        }

        public DateTime DateTime
        {
            get { return DateTime.ParseExact(GetValue("DateTime"), "dd.MM.yyyy HH:mm:ss", provider); }
        }

    }
}