using System;
using System.Collections.Generic;
using UnfoldingOfGoods.Logic.Objects;
using UnfoldingOfGoods.Logic.Requests;
using UnfoldingOfGoods.Logic.Xml.Message.Custom;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;

namespace UnfoldingOfGoods.Logic
{

    public delegate IRequest CreateInstanceRequest(Dictionary<String, Object> aDictionary);

    public class LogicClass
    {

        private Boolean FGlobalResult = false;

        private Boolean ProcessedResponse(CustomXmlMessage aMessage, CustomXmlResponse aResponse)
        {
            switch (aResponse.Error.Code)
            {
                case 0:
                    if (aResponse.Type != aMessage.Type)
                    {
                        throw new EDataCommunication(String.Format(ExceptionStrings.ItIsExpectedMessage, aMessage.Type, aResponse.Type));
                    }
                    break;
                case 3:
                    Boolean resultLogin = Login(ObjectFactory.Employee().UserBarCode);
                    if (resultLogin)
                    {
                        aMessage.Session = ObjectFactory.Session().Session; // На случай перелогинивания
                    }
                    return resultLogin;
                default:
                    throw new EXmlResponseException(String.Format(ExceptionStrings.CallFailed, aResponse.Type, aResponse.Error.NodeValue), aResponse.Error.Code);
            }
            return false;
        }

        private CustomXmlResponse Response(CustomXmlMessage aXmlMessage, CreateInstanceCustomXmlResponse aCreateInstance)
        {
            CustomXmlResponse xmlResponse = null;
            do
            {
                xmlResponse = ClassFactory.Tcp.GetResponse(aXmlMessage, aCreateInstance);
            }
            while (ProcessedResponse(aXmlMessage, xmlResponse));

            return xmlResponse;
        }

        private Boolean ProcessedRequest(CreateInstanceRequest aCreateInstance, Dictionary<String, Object> aDictionary)
        {
            Boolean result = false;
            try
            {
                IRequest r = aCreateInstance(aDictionary);
                r.PrepareMessage();
                r.Request(Response);
                FGlobalResult = r.ExecuteAfter();
                result = true;
            }
            catch (Exception ex)
            {
                ExceptionMessage.ShowError(ex);
                result = false;
            }
            return result;
        }

        public Boolean Login(String aUserBarCode)
        {
            Dictionary<String, Object> list = new Dictionary<String, Object>();
            list.Add("UserBarCode", aUserBarCode);
            return ProcessedRequest(RequestFactory.LoginUser, list);
        }

        public Boolean LoadDocNumbers()
        {
            return ProcessedRequest(RequestFactory.GetDocNumbers, null);
        }

        public Boolean LoadDocPlacementDetails(String aNo)
        {
            Dictionary<String, Object> list = new Dictionary<String, Object>();
            list.Add("DocNo", aNo);
            return ProcessedRequest(RequestFactory.GetDocPlacement, list);
        }

        public Boolean ProcessedLiveExpiredData()
        {
            if (ProcessedRequest(RequestFactory.GetExpiredData, null))
            {
                if (FGlobalResult)
                {
                    if (MyClass.ShowQuestion(String.Format("Остались незарегистрированные данные от пользователя {0}. Зарегистрировать?", ObjectFactory.Employee().UserName)))
                    {
                        return RegisterPlacement(true);
                    }
                }
                return true;
            }
            else
            {
                return false;
            }
        }

        public Boolean RegisterPlacement(Boolean aForce)
        {
            Dictionary<String, Object> list = new Dictionary<String, Object>();
            list.Add("Force", aForce);
            return ProcessedRequest(RequestFactory.RegisterPlacement, list);
        }

        public Boolean LoadBinContent(String aItemNo)
        {
            Dictionary<String, Object> list = new Dictionary<String, Object>();
            list.Add("ItemNo", aItemNo);
            return ProcessedRequest(RequestFactory.GetBinContent, list);
        }

        public Boolean Logout()
        {
            if (ProcessedRequest(RequestFactory.LogoutUser, null))
            {
                return FGlobalResult;
            }
            else
            {
                return false;
            }
        }

        public ObjectPlacementActivityLine IsCorrectItem(String aItemNo)
        {
            ObjectPlacementActivityLineList palList = ObjectFactory.PlacementActivityLine();
            return palList.ItemFromItemNo(aItemNo);
        }

        public Boolean DeleteAllData()
        {
            Boolean result = false;
            try
            {
                ClassFactory.DataBase.DeleteAllData();
                result = true;
            }
            catch (Exception ex)
            {
                ExceptionMessage.ShowError(ex);
                result = false;
            }
            return result;
        }

        public Boolean DeleteActivityData()
        {
            Boolean result = false;
            try
            {
                ClassFactory.DataBase.DeleteActivity();
                result = true;
            }
            catch (Exception ex)
            {
                ExceptionMessage.ShowError(ex);
                result = false;
            }
            return result;
        }

        public Boolean FillBinCode(String aBinCode)
        {
            Boolean result = false;
            try
            {
                ClassFactory.DataBase.FillBinCode(aBinCode);
                result = true;
            }
            catch (Exception ex)
            {
                ExceptionMessage.ShowError(ex);
                result = false;
            }
            return result;
        }

    }
}