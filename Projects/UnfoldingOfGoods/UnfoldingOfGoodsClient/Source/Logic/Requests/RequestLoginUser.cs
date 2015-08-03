using System;
using System.Collections.Generic;
using UnfoldingOfGoods.Logic.Xml.Message.LoginUser;
using UnfoldingOfGoods.Logic.Xml.Response;
using UnfoldingOfGoods.Logic.Xml.Response.LoginUser;
using UnfoldingOfGoods.Service;
using System.Reflection;


namespace UnfoldingOfGoods.Logic.Requests
{
    public class RequestLoginUser : IRequest
    {

        private Dictionary<String, Object> FDictionary = null;
        private XmlMessageLoginUser FXmlMessage = null;
        private XmlResponseLoginUser FXmlResponse = null;

        public RequestLoginUser(Dictionary<String, Object> aDictionary)
        {
            FDictionary = aDictionary;
        }

        public void PrepareMessage()
        {
            FXmlMessage = new XmlMessageLoginUser();
            FXmlMessage.Params.UserName = (String)FDictionary["UserBarCode"];
            FXmlMessage.Params.UserLocation = XmlOptions.Options.Location;
            FXmlMessage.Params.MachineName = ScannerProxy.ScannerAPI.GetSerialNumber();
            FXmlMessage.Params.Version = Assembly.GetExecutingAssembly().GetName().Version.ToString();
        }

        public void Request(ResponseDelegate aResponseDelegate)
        {
            FXmlResponse = (XmlResponseLoginUser)aResponseDelegate(FXmlMessage, XmlResponseFactory.LoginUser);
        }

        public Boolean ExecuteAfter()
        {
            ClassFactory.DataBase.InsertAuthorize((String)FDictionary["UserBarCode"], FXmlResponse.Result);
            return true;
        }

    }
}