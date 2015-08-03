namespace UnfoldingOfGoods.Service
{
    using System;

    public class ScannerProxy
    {
        static private IScannerAPI FScanner = null;

        static public IScannerAPI ScannerAPI
        {
            get
            {
                if (FScanner == null)
                    InitScanner();

                return FScanner;
            }
        }

        static private void InitScanner()
        {
            if (IsWinCE6())
            {
                FScanner = new ScannerAPIWinCE6();
            }
            else
            {
                FScanner = new ScannerAPIWinCE5();
            }
        }

        static private Boolean IsWinCE6()
        {
            if (Environment.OSVersion.Platform != PlatformID.WinCE)
                throw (new Exception("Приложение работает только под Windows CE"));

            return Environment.OSVersion.Version.Major > 5;
        }
    }
}