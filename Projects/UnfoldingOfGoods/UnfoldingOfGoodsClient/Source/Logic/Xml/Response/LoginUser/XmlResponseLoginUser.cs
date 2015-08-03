using System;
using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Response.LoginUser
{
    public class XmlResponseLoginUser : CustomXmlResponse
    {

        public XmlResponseLoginUser(String aXml)
            : base(aXml)
        {
        }

        override protected CustomXmlResponseResult GetClass(XmlElement aXmlElement)
        {
            return new XmlResponseLoginUserResult(aXmlElement);
        }

        new public XmlResponseLoginUserResult Result
        {
            get { return (XmlResponseLoginUserResult)base.Result; }
        }

    }
}