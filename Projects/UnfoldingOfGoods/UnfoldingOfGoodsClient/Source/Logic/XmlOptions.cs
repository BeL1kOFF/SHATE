using System;
using System.Xml;

namespace UnfoldingOfGoods.Logic
{

    class XmlOptions
    {

        static private XmlOptions FXmlOptions = null;

        private XmlDocument FOptions;

        protected XmlOptions()
        {
            FOptions = new XmlDocument();
            FOptions.Load(MyClass.AppPath + @"\Options.xml");
        }

        static public XmlOptions Options
        {
            get
            {
                if (FXmlOptions == null)
                {
                    FXmlOptions = new XmlOptions();
                }
                return FXmlOptions;
            }
        }

        public void Save()
        {
            FOptions.Save(MyClass.AppPath + @"\Options.xml");
        }

        public String Server
        {
            get
            {
                return FOptions.DocumentElement.GetElementsByTagName("Server").Item(0).InnerText;
            }
            set
            {
                FOptions.DocumentElement.GetElementsByTagName("Server").Item(0).InnerText = value;
            }
        }

        public Int32 Port
        {
            get
            {
                return Convert.ToInt32(FOptions.DocumentElement.GetElementsByTagName("Port").Item(0).InnerText);
            }
            set
            {
                FOptions.DocumentElement.GetElementsByTagName("Port").Item(0).InnerText = value.ToString();
            }
        }

        public Int32 Timeout
        {
            get
            {
                return Convert.ToInt32(FOptions.DocumentElement.GetElementsByTagName("Timeout").Item(0).InnerText);
            }
            set
            {
                FOptions.DocumentElement.GetElementsByTagName("Timeout").Item(0).InnerText = value.ToString();
            }
        }

        public String Location
        {
            get
            {
                return FOptions.DocumentElement.GetElementsByTagName("Location").Item(0).InnerText;
            }
            set
            {
                FOptions.DocumentElement.GetElementsByTagName("Location").Item(0).InnerText = value;
            }
        }

    }
}