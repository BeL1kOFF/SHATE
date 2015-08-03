using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Message.Custom
{
    abstract public class CustomXmlMessage : CustomXml
    {

        private XmlDocument FXmlDocument;

        public CustomXmlMessage()
            : base()
        {
            FXmlDocument = new XmlDocument();
            CreateXml();
        }

        private void CreateRoot()
        {
            XmlElement xe = FXmlDocument.CreateElement("Message");
            FXmlDocument.AppendChild(xe);
        }

        protected XmlElement CreateNode(XmlElement aXmlElement, String aName)
        {
            XmlElement xe = aXmlElement.OwnerDocument.CreateElement(aName);
            return (XmlElement)aXmlElement.AppendChild(xe);
        }

        protected XmlAttribute CreateAttribute(XmlElement aXmlElement, String aName)
        {
            XmlAttribute xa = aXmlElement.OwnerDocument.CreateAttribute(aName);
            return aXmlElement.Attributes.Append(xa);
        }

        protected void SetMessage(String aType)
        {
            SetAttribute(XmlDocument.DocumentElement, "Type", aType);
        }

        virtual protected void CreateXml()
        {
            CreateRoot();

            CreateAttribute(FXmlDocument.DocumentElement, "Type");
            CreateAttribute(FXmlDocument.DocumentElement, "Session");
        }

        protected XmlDocument XmlDocument
        {
            get { return FXmlDocument; }
        }

        public String Type
        {
            get { return GetAttribute(FXmlDocument.DocumentElement, "Type"); }
        }

        public Guid Session
        {
            set { SetAttribute(FXmlDocument.DocumentElement, "Session", value.ToString("B")); }
        }

        public String Xml
        {
            get { return FXmlDocument.InnerXml; }
        }

    }
}