namespace UnfoldingOfGoods.Service
{
    using System;
    using datalogic.device;
    using datalogic.pdc;
    using datalogic.wireless;

    public class ScannerAPIWinCE5 : IScannerAPI
    {
        static private String FLabelSuffix;

        public String GetSerialNumber() 
        {
            String result = "";

            using (Device device = new Device())
            {
                if (!device.GetSerialNumber(out result))
                    throw (new Exception("Ошибка получения уникального идентификатора устройства."));
            }

            if (result == "")
                throw (new Exception("Ошибка получения уникального идентификатора устройства."));
            return result;
        }

        public void SetLabelSuffix() 
        {
            if (FLabelSuffix != null)
                return;

            DLScannerSetup scannerSetup = new DLScannerSetup();
            scannerSetup.init();
            FLabelSuffix = scannerSetup.getParameterString(1);
            scannerSetup.setParameterString(1, "\r");
            scannerSetup.save();
            scannerSetup.update();
        }

        public void RestoreLabelSuffix() 
        {
            if (FLabelSuffix == null)
                return;

            DLScannerSetup scannerSetup = new DLScannerSetup();
            scannerSetup.init();
            scannerSetup.setParameterString(1, FLabelSuffix);
            scannerSetup.save();
            scannerSetup.update();

            FLabelSuffix = null;
        }

        public Boolean IsWIFI() 
        {
            using (OutOfRange wirelessOutOfRange = new OutOfRange())
            {
                wirelessOutOfRange.Automatic = false;
                return wirelessOutOfRange.IsAssociated();
            }
        }
    }
}