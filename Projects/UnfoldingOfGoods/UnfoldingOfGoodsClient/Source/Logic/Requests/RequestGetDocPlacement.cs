using System;
using System.Collections.Generic;
using UnfoldingOfGoods.Logic.Objects;
using UnfoldingOfGoods.Logic.Xml.Message.GetDocPlacement;
using UnfoldingOfGoods.Logic.Xml.Response;
using UnfoldingOfGoods.Logic.Xml.Response.GetDocPlacement;

namespace UnfoldingOfGoods.Logic.Requests
{
    public class RequestGetDocPlacement : IRequest
    {

        private Dictionary<String, Object> FDictionary = null;
        private XmlMessageGetDocPlacement FXmlMessage = null;
        private XmlResponseGetDocPlacement FXmlResponse = null;

        public RequestGetDocPlacement(Dictionary<String, Object> aDictionary)
        {
            FDictionary = aDictionary;
        }

        public void PrepareMessage()
        {
            FXmlMessage = new XmlMessageGetDocPlacement();
            FXmlMessage.Session = ObjectFactory.Session().Session;
            FXmlMessage.Params.DocNo = (String)FDictionary["DocNo"];
        }

        public void Request(ResponseDelegate aResponseDelegate)
        {
            FXmlResponse = (XmlResponseGetDocPlacement)aResponseDelegate(FXmlMessage, XmlResponseFactory.GetDocPlacement);
        }

        public Boolean ExecuteAfter()
        {
            ClassFactory.DataBase.InsertPlacementActivity(FXmlResponse.Result);
            return true;
        }

    }
}