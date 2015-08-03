using UnfoldingOfGoods.Logic.Xml.Message.Custom;

namespace UnfoldingOfGoods.Logic.Xml.Message.GetExpiredData
{
    public class XmlMessageGetExpiredData : CustomXmlMessageParams
    {

        public XmlMessageGetExpiredData()
            : base()
        {
        }

        override protected void CreateParams()
        {
            base.CreateParams();
            CreateAttribute(base.Params, "DateTime");
            CreateAttribute(base.Params, "Version");
        }

        override protected void CreateXml()
        {
            base.CreateXml();
            SetMessage("GetExpiredData");
        }

        new public XmlMessageGetExpiredDataParams Params
        {
            get { return new XmlMessageGetExpiredDataParams(base.Params); }
        }

    }
}