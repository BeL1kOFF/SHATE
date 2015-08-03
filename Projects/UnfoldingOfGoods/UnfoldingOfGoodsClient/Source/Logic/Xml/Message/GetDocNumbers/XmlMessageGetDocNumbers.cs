using UnfoldingOfGoods.Logic.Xml.Message.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Message.GetDocNumbers
{
    class XmlMessageGetDocNumbers : CustomXmlMessage
    {

        public XmlMessageGetDocNumbers()
            : base()
        {
        }

        override protected void CreateXml()
        {
            base.CreateXml();
            SetMessage("GetDocNumbers");
        }

    }
}