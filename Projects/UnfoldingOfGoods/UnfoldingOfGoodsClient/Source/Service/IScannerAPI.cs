namespace UnfoldingOfGoods.Service
{
    using System;

    public interface IScannerAPI
    {
        String GetSerialNumber();
        void SetLabelSuffix();
        void RestoreLabelSuffix();
        Boolean IsWIFI();
    }
}