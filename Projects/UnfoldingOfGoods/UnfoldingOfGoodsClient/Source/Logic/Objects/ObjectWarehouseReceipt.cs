using System;

namespace UnfoldingOfGoods.Logic.Objects
{
    public class ObjectWarehouseReceipt
    {

        private Int32 FId_WarehouseReceipt;
        private String FNo;

        public ObjectWarehouseReceipt(Int32 aId_WarehouseReceipt, String aNo)
        {
            FId_WarehouseReceipt = aId_WarehouseReceipt;
            FNo = aNo;
        }

        public Int32 Id_WarehouseReceipt { get { return FId_WarehouseReceipt; } }

        public String No { get { return FNo; } }

    }
}