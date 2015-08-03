using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Message.GetBinContent
{
    public class XmlMessageGetBinContentParams : CustomXmlElement
    {

        public XmlMessageGetBinContentParams(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public String ItemNo
        {
            set { SetAttribute("ItemNo", value); }
        }

    }
}