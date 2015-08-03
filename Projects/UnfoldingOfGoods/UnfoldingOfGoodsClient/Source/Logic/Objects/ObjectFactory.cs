using System;
using System.Data.SqlServerCe;

namespace UnfoldingOfGoods.Logic.Objects
{
    public static class ObjectFactory
    {

        public static ObjectSession Session()
        {
            return new ObjectSession();
        }

        public static ObjectSession Session(SqlCeTransaction aSqlCeTransaction)
        {
            return new ObjectSession(aSqlCeTransaction);
        }

        public static ObjectEmployee Employee()
        {
            return new ObjectEmployee();
        }

        public static ObjectWarehouseReceiptList WarehouseReceipt()
        {
            return new ObjectWarehouseReceiptList();
        }

        public static ObjectPlacementActivityHeader PlacementActivityHeader()
        {
            return new ObjectPlacementActivityHeader();
        }

        public static ObjectPlacementActivityHeader PlacementActivityHeader(SqlCeTransaction aSqlCeTransaction)
        {
            return new ObjectPlacementActivityHeader(aSqlCeTransaction);
        }

        public static ObjectPlacementActivityLineList PlacementActivityLine()
        {
            return new ObjectPlacementActivityLineList();
        }

        public static ObjectActivityLineList ActivityLine()
        {
            return new ObjectActivityLineList();
        }

    }
}