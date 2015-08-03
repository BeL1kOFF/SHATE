using System;
using System.Net.Sockets;
using System.Data.SqlServerCe;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;

namespace UnfoldingOfGoods.Logic
{
    public static class ExceptionMessage
    {
        private static void ShowError(String aMessage)
        {
            String dateStr = DateTime.Now.ToString("yyyy.MM.dd HH:mm:ss");

            String[] joinStr = new String[2];

            joinStr[0] = dateStr;
            joinStr[1] = aMessage;

            String errorText = String.Join("\r\n", joinStr);
            MyClass.ShowError(errorText);
        }

        private static void ShowError(SocketException aSocketException)
        {
            String errorText;
            switch (aSocketException.ErrorCode)
            {
                case 10060:
                    errorText = ExceptionStrings.ErrorWsaETimedOut;
                    break;
                case 10061:
                    errorText = ExceptionStrings.ErrorWsaEConnRefused;
                    break;
                default:
                    errorText = Convert.ToString(aSocketException.ErrorCode) + "; " + aSocketException.Message;
                    break;
            }

            ShowError(errorText);
        }

        private static void ShowError(SqlCeException aSqlCeException)
        {
            String errorText;
            switch (aSqlCeException.NativeError)
            {
                case 25046:
                    errorText = ExceptionStrings.DatabaseFileIsNotFound;
                    break;
                default:
                    errorText = Convert.ToString(aSqlCeException.NativeError) + "; " + aSqlCeException.Message;
                    break;
            }

            ShowError(errorText);
        }

        private static void ShowError(EXmlResponseException aXmlResponseException)
        {
            String errorText;
            switch (aXmlResponseException.ResultCode)
            {
                /*case 003:
                    errorText = ExceptionStrings.EmployeeIsNotFound;
                    break;
                case 004:
                    errorText = ExceptionStrings.LayoutJobsNotFound;
                    break;*/
                default:
                    errorText = String.Format(ExceptionStrings.XmlResponseException, aXmlResponseException.Message, aXmlResponseException.ResultCode);
                    break;
            }

            ShowError(errorText);
        }

        public static void ShowError(Exception aException)
        {
            if (aException is SqlCeException)
            {
                ShowError((SqlCeException)aException);
            }
            else if (aException is SocketException)
            {
                ShowError((SocketException)aException);
            }
            else if (aException is EXmlResponseException)
            {
                ShowError((EXmlResponseException)aException);
            }
            else
            {
                ShowError(aException.Message);
            }
            
        }
    }
}