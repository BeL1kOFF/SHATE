using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Message.Custom
{
    public abstract class CustomXmlMessageParams : CustomXmlMessage
    {

        public CustomXmlMessageParams()
            : base()
        {
        }

        virtual protected void CreateParams()
        {
            CreateNode(XmlDocument.DocumentElement, "params");
        }

        override protected void CreateXml()
        {
            base.CreateXml();

            CreateParams();
        }

        protected XmlElement Params
        {
            get { return GetElement(XmlDocument.DocumentElement, "params"); }
        }

    }
}