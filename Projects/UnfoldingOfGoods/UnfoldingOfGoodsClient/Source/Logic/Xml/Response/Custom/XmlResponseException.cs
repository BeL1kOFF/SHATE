using System;

namespace UnfoldingOfGoods.Logic.Xml.Response.Custom
{
    public class EXmlResponseException : Exception
    {

        private Int32 FResultCode;

        public EXmlResponseException(String aMessage, Int32 aResultCode)
            : base(aMessage)
        {
            FResultCode = aResultCode;
        }

        public Int32 ResultCode
        {
            get { return FResultCode; }
        }

    }
}