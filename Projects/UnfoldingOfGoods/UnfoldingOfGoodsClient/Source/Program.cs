using System;
using System.Reflection;
using System.Windows.Forms;
using OpenNETCF.Threading;
using UnfoldingOfGoods.Service;

namespace UnfoldingOfGoods
{
    static class Program
    {

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [MTAThread]
        static void Main()
        {
            Boolean firstInstance;

            using (NamedMutex mx = new NamedMutex(false, "2D2EBFAC-543A-4FE8-A4E6-D88F5A76B2A1", out firstInstance))
            {
                if (firstInstance)
                {
                    try
                    {
                        ScannerProxy.ScannerAPI.SetLabelSuffix();

                        Boolean start = true;
                        try
                        {
                            Assembly.Load("System.Data.SqlServerCe, Version=3.5.0.0, Culture=neutral, PublicKeyToken=3BE235DF1C8D2AD3");
                        }
                        catch
                        {
                            start = false;
                            MyClass.ShowError("Не установлен Sql Server Compact 3.5");
                        }
                        if (start)
                        {
                            Application.Run(new FormMain());
                        }
                        GC.KeepAlive(mx);
                    }
                    finally
                    {
                        ScannerProxy.ScannerAPI.RestoreLabelSuffix();
                    }
                }
            }
        }
    }
}