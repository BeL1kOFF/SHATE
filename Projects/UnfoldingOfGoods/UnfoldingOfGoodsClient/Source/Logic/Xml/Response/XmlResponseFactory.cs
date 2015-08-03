using System;
using UnfoldingOfGoods.Logic.Xml.Response.GetBinContent;
using UnfoldingOfGoods.Logic.Xml.Response.RegisterPlacement;
using UnfoldingOfGoods.Logic.Xml.Response.GetDocPlacement;
using UnfoldingOfGoods.Logic.Xml.Response.GetDocNumbers;
using UnfoldingOfGoods.Logic.Xml.Response.LogoutUser;
using UnfoldingOfGoods.Logic.Xml.Response.LoginUser;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;
using UnfoldingOfGoods.Logic.Xml.Response.GetExpiredData;

namespace UnfoldingOfGoods.Logic.Xml.Response
{
    public static class XmlResponseFactory
    {

        public static CustomXmlResponse LoginUser(String aXml)
        {
            return new XmlResponseLoginUser(aXml);
        }

        public static CustomXmlResponse LogoutUser(String aXml)
        {
            return new XmlResponseLogoutUser(aXml);
        }

        public static CustomXmlResponse GetDocNumbers(String aXml)
        {
            return new XmlResponseGetDocNumbers(aXml);
        }

        public static CustomXmlResponse GetDocPlacement(String aXml)
        {
            return new XmlResponseGetDocPlacement(aXml);
        }

        public static CustomXmlResponse GetBinContent(String aXml)
        {
            return new XmlResponseGetBinContent(aXml);
        }

        public static CustomXmlResponse RegisterPlacement(String aXml)
        {
            return new XmlResponseRegisterPlacement(aXml);
        }

        public static CustomXmlResponse GetExpiredData(String aXml)
        {
            return new XmlResponseGetExpiredData(aXml);
        }

    }
}