using System;
using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Message.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Message.RegisterPlacement
{
    public class XmlMessageRegisterPlacement : CustomXmlMessage
    {

        public XmlMessageRegisterPlacement()
            : base()
        {
        }

        private void CreateAdditional()
        {
            CreateAttribute(XmlDocument.DocumentElement, "UserName");
            CreateAttribute(XmlDocument.DocumentElement, "UserLocation");
            XmlElement xeDocument = CreateNode(XmlDocument.DocumentElement, "Document");
            XmlAttribute xa = CreateAttribute(xeDocument, "Type");
            xa.Value = "Registered Placement Activity Line";
            CreateAttribute(xeDocument, "No");
        }

        override protected void CreateXml()
        {
            base.CreateXml();
            SetMessage("RegisterPlacement");

            CreateAdditional();            
        }

        public XmlMessageRegisterPlacementDocument Document
        {
            get { return new XmlMessageRegisterPlacementDocument(GetElement(XmlDocument.DocumentElement, "Document")); }
        }

        public String UserName
        {
            set { SetAttribute(XmlDocument.DocumentElement, "UserName", value); }
        }

        public String UserLocation
        {
            set { SetAttribute(XmlDocument.DocumentElement, "UserLocation", value); }
        }

    }
}