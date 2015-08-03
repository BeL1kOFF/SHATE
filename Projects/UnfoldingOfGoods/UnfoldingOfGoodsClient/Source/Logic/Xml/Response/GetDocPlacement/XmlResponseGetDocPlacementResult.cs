using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Response.GetDocPlacement
{
    public class XmlResponseGetDocPlacementResult : CustomXmlResponseResult
    {

        public XmlResponseGetDocPlacementResult(XmlElement aXmlElement)
            : base(aXmlElement)
        {
        }

        public XmlResponseGetDocPlacementResultDocument Document
        {
            get { return new XmlResponseGetDocPlacementResultDocument(GetElement("Document")); }
        }

    }
}