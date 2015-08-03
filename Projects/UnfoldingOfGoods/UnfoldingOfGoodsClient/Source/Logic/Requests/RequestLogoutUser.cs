using System;
using System.Collections.Generic;
using UnfoldingOfGoods.Logic.Objects;
using UnfoldingOfGoods.Logic.Xml.Message.LogoutUser;
using UnfoldingOfGoods.Logic.Xml.Response.LogoutUser;
using UnfoldingOfGoods.Logic.Xml.Response;

namespace UnfoldingOfGoods.Logic.Requests
{
    public class RequestLogoutUser : IRequest
    {

        private Dictionary<String, Object> FDictionary = null;
        private XmlMessageLogoutUser FXmlMessage = null;
        private XmlResponseLogoutUser FXmlResponse = null;
        
        public RequestLogoutUser(Dictionary<String, Object> aDictionary)
        {
            FDictionary = aDictionary;
        }

        public void PrepareMessage()
        {
            FXmlMessage = new XmlMessageLogoutUser();
            FXmlMessage.Session = ObjectFactory.Session().Session;
            FXmlMessage.Params.UserName = ObjectFactory.Employee().UserBarCode;
        }

        public void Request(ResponseDelegate aResponseDelegate)
        {
            FXmlResponse = (XmlResponseLogoutUser)aResponseDelegate(FXmlMessage, XmlResponseFactory.LogoutUser);
        }

        public Boolean ExecuteAfter()
        {
            if (FXmlResponse.Result == 1)
            {
                ClassFactory.DataBase.DeleteAllData();
            }
            return FXmlResponse.Result == 1;
        }

    }
}