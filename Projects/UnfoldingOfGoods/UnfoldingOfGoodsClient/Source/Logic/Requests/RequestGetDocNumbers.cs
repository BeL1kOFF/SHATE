using System;
using System.Collections.Generic;
using UnfoldingOfGoods.Logic.Objects;
using UnfoldingOfGoods.Logic.Xml.Message.GetDocNumbers;
using UnfoldingOfGoods.Logic.Xml.Response;
using UnfoldingOfGoods.Logic.Xml.Response.GetDocNumbers;

namespace UnfoldingOfGoods.Logic.Requests
{

    public class RequestGetDocNumbers : IRequest
    {

        private Dictionary<String, Object> FDictionary = null;
        private XmlMessageGetDocNumbers FXmlMessage = null;
        private XmlResponseGetDocNumbers FXmlResponse = null;
        
        public RequestGetDocNumbers(Dictionary<String, Object> aDictionary)
        {
            FDictionary = aDictionary;
        }

        public void PrepareMessage()
        {
            FXmlMessage = new XmlMessageGetDocNumbers();
            FXmlMessage.Session = ObjectFactory.Session().Session;
        }

        public void Request(ResponseDelegate aResponseDelegate)
        {
            FXmlResponse = (XmlResponseGetDocNumbers)aResponseDelegate(FXmlMessage, XmlResponseFactory.GetDocNumbers);
        }

        public Boolean ExecuteAfter()
        {
            ClassFactory.DataBase.InsertDocumentNumbers(FXmlResponse.Result);
            return true;
        }

    }
}