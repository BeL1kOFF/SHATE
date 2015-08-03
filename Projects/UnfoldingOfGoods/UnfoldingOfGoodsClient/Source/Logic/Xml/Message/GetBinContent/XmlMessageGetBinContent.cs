using System;
using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Message.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Message.GetBinContent
{
    public class XmlMessageGetBinContent : CustomXmlMessageParams
    {

        public XmlMessageGetBinContent()
            : base()
        {
        }

        override protected void CreateParams()
        {
            base.CreateParams();

            CreateAttribute(base.Params, "ItemNo");
        }

        override protected void CreateXml()
        {
            base.CreateXml();
            SetMessage("GetBinContent");
        }

        new public XmlMessageGetBinContentParams Params
        {
            get { return new XmlMessageGetBinContentParams(base.Params); }
        }

    }
}