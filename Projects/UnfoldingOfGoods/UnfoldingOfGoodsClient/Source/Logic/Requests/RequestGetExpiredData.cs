using System;
using System.Collections.Generic;
using UnfoldingOfGoods.Logic.Objects;
using UnfoldingOfGoods.Logic.Xml.Message.GetExpiredData;
using UnfoldingOfGoods.Logic.Xml.Response;
using UnfoldingOfGoods.Logic.Xml.Response.GetExpiredData;
using System.Reflection;

namespace UnfoldingOfGoods.Logic.Requests
{
    public class RequestGetExpiredData : IRequest
    {

        private Dictionary<String, Object> FDictionary = null;
        private XmlMessageGetExpiredData FXmlMessage = null;
        private XmlResponseGetExpiredData FXmlResponse = null;

        public RequestGetExpiredData(Dictionary<String, Object> aDictionary)
        {
            FDictionary = aDictionary;
        }

        public void PrepareMessage()
        {
            FXmlMessage = new XmlMessageGetExpiredData();
            FXmlMessage.Params.DateTime = ObjectFactory.Session().DateTime;
            FXmlMessage.Params.Version = Assembly.GetExecutingAssembly().GetName().Version.ToString();
        }

        public void Request(ResponseDelegate aResponseDelegate)
        {
            FXmlResponse = (XmlResponseGetExpiredData)aResponseDelegate(FXmlMessage, XmlResponseFactory.GetExpiredData);
        }

        public Boolean ExecuteAfter()
        {
            return (FXmlResponse.Result == 0);
        }

    }
}