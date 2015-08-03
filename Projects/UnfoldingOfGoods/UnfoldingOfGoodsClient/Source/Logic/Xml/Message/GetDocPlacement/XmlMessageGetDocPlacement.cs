using System;
using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Message.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Message.GetDocPlacement
{
    class XmlMessageGetDocPlacement : CustomXmlMessageParams
    {

        public XmlMessageGetDocPlacement()
            : base()
        {
        }

        override protected void CreateParams()
        {
            base.CreateParams();

            CreateAttribute(base.Params, "DocNo");
        }

        override protected void CreateXml()
        {
            base.CreateXml();
            SetMessage("GetDocPlacement");
        }

        new public XmlMessageGetDocPlacementResult Params
        {
            get { return new XmlMessageGetDocPlacementResult(base.Params); }
        }

    }

}