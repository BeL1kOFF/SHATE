using System;
using System.Collections.Generic;
using UnfoldingOfGoods.Logic.Xml.Message.Custom;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;

namespace UnfoldingOfGoods.Logic.Requests
{
    public delegate CustomXmlResponse ResponseDelegate(CustomXmlMessage aXmlMessage, CreateInstanceCustomXmlResponse aCreateInstance);

    public static class RequestFactory
    {

        public static IRequest LoginUser(Dictionary<String, Object> aDictionary)
        {
            return new RequestLoginUser(aDictionary);
        }

        public static IRequest LogoutUser(Dictionary<String, Object> aDictionary)
        {
            return new RequestLogoutUser(aDictionary);
        }

        public static IRequest GetDocNumbers(Dictionary<String, Object> aDictionary)
        {
            return new RequestGetDocNumbers(aDictionary);
        }

        public static IRequest GetDocPlacement(Dictionary<String, Object> aDictionary)
        {
            return new RequestGetDocPlacement(aDictionary);
        }

        public static IRequest RegisterPlacement(Dictionary<String, Object> aDictionary)
        {
            return new RequestRegisterPlacement(aDictionary);
        }

        public static IRequest GetBinContent(Dictionary<String, Object> aDictionary)
        {
            return new RequestGetBinContent(aDictionary);
        }

        public static IRequest GetExpiredData(Dictionary<String, Object> aDictionary)
        {
            return new RequestGetExpiredData(aDictionary);
        }

    }
}