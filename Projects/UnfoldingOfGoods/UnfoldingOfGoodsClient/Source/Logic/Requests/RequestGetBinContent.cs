using System;
using System.Collections.Generic;
using UnfoldingOfGoods.Logic.Objects;
using UnfoldingOfGoods.Logic.Xml.Message.GetBinContent;
using UnfoldingOfGoods.Logic.Xml.Response;
using UnfoldingOfGoods.Logic.Xml.Response.GetBinContent;

namespace UnfoldingOfGoods.Logic.Requests
{
    public class RequestGetBinContent : IRequest
    {

        private Dictionary<String, Object> FDictionary = null;
        private XmlMessageGetBinContent FXmlMessage = null;
        private XmlResponseGetBinContent FXmlResponse = null;

        public RequestGetBinContent(Dictionary<String, Object> aDictionary)
        {
            FDictionary = aDictionary;
        }

        public void PrepareMessage()
        {
            FXmlMessage = new XmlMessageGetBinContent();
            FXmlMessage.Session = ObjectFactory.Session().Session;
            FXmlMessage.Params.ItemNo = (String)FDictionary["ItemNo"];
        }

        public void Request(ResponseDelegate aResponseDelegate)
        {
            FXmlResponse = (XmlResponseGetBinContent)aResponseDelegate(FXmlMessage, XmlResponseFactory.GetBinContent);
        }

        public Boolean ExecuteAfter()
        {
            ClassFactory.DataBase.FillBinContent(FXmlResponse.Result);
            return true;
        }

    }
}