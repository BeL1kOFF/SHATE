using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic.Xml.Message.GetDocPlacement
{
    public class XmlMessageGetDocPlacementResult : CustomXmlElement
    {

        public XmlMessageGetDocPlacementResult(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public String DocNo
        {
            set { SetAttribute("DocNo", value); }
        }

    }
}