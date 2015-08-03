using System;
using System.Collections.Generic;
using UnfoldingOfGoods.Logic.Objects;
using UnfoldingOfGoods.Logic.Xml.Message.RegisterPlacement;
using UnfoldingOfGoods.Logic.Xml.Response;
using UnfoldingOfGoods.Logic.Xml.Response.RegisterPlacement;

namespace UnfoldingOfGoods.Logic.Requests
{
    public class RequestRegisterPlacement : IRequest
    {

        private Dictionary<String, Object> FDictionary = null;
        private XmlMessageRegisterPlacement FXmlMessage = null;
        private XmlResponseRegisterPlacement FXmlResponse = null;

        public RequestRegisterPlacement(Dictionary<String, Object> aDictionary)
        {
            FDictionary = aDictionary;
        }

        public void PrepareMessage()
        {
            FXmlMessage = new XmlMessageRegisterPlacement();
            if ((Boolean)FDictionary["Force"])
            {
                FXmlMessage.UserName = ObjectFactory.Employee().UserBarCode;
                FXmlMessage.UserLocation = XmlOptions.Options.Location;
                FXmlMessage.Session = Guid.Empty;
            }
            else
            {
                FXmlMessage.Session = ObjectFactory.Session().Session;
            }
            ObjectActivityLineList activityLine = ObjectFactory.ActivityLine();
            FXmlMessage.Document.No = ObjectFactory.PlacementActivityHeader().No;
            for (Int32 k = 0; k < activityLine.Count; k++)
            {
                if (activityLine.Item(k).BinCode != "")
                {
                    XmlMessageRegisterPlacementDocumentLine xmlLine = FXmlMessage.Document.AddLineInDocument();
                    ObjectPlacementActivityLine pal = ObjectFactory.PlacementActivityLine().ItemFromId(activityLine.Item(k).Id_PlacementActivityLine);
                    xmlLine.No = 0;
                    xmlLine.LineNo = pal.LineNo;
                    xmlLine.ItemNo = pal.ItemNo;
                    xmlLine.PlacedQty = activityLine.Item(k).ProcessedQty;
                    xmlLine.BinCode = activityLine.Item(k).BinCode;
                }
            }
        }

        public void Request(ResponseDelegate aResponseDelegate)
        {
            FXmlResponse = (XmlResponseRegisterPlacement)aResponseDelegate(FXmlMessage, XmlResponseFactory.RegisterPlacement);
        }

        public Boolean ExecuteAfter()
        {
            return (FXmlResponse.Result == 1);
        }

    }
}