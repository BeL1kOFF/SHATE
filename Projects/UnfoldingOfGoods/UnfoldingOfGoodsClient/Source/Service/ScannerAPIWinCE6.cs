namespace UnfoldingOfGoods.Service
{
    using System;
    using Datalogic.API;

    public class ScannerAPIWinCE6 : IScannerAPI
    {
        static private String FLabelSuffix;

        public String GetSerialNumber() 
        {
            String result = "";

            try
            {
                result = Datalogic.API.Device.GetSerialNumber();
            }
            catch (Exception e)
            {
                throw (new Exception(string.Format("Ошибка получения уникального идентификатора устройства: {0}.", e.Message)));
            }

            if (result == "")
                throw (new Exception("Ошибка получения уникального идентификатора устройства."));
            return result;
        }

        public void SetLabelSuffix() 
        {
            if (FLabelSuffix != null)
                return;

            Decode.GetParamString(Param.LABEL_SUFFIX, out FLabelSuffix);
            Decode.SetParamString(Param.LABEL_SUFFIX, "\r");
        }

        public void RestoreLabelSuffix() 
        {
            if (FLabelSuffix == null)
                return;

            Decode.SetParamString(Param.LABEL_SUFFIX, FLabelSuffix);

            FLabelSuffix = null;
        }

        public Boolean IsWIFI() 
        {
            //TODO: не работает на последней прошивке
            //UInt32 qualityWiFi;
            //return ((Datalogic.API.Device.GetWiFiPowerStatus()) && (Datalogic.API.Device.WiFiGetSignalQuality(out qualityWiFi)));
            return true;
        }
    }
}