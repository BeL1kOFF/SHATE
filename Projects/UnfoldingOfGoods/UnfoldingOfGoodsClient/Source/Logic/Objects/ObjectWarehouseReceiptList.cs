using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlServerCe;

namespace UnfoldingOfGoods.Logic.Objects
{
    public class ObjectWarehouseReceiptList
    {

        private List<ObjectWarehouseReceipt> FWarehouseReceipt;

        public ObjectWarehouseReceiptList()
        {
            FWarehouseReceipt = new List<ObjectWarehouseReceipt>();
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT wr.Id_WarehouseReceipt, wr.No FROM WarehouseReceipt AS wr", sqlConnection))
                {
                    sqlCommand.CommandType = CommandType.Text;
                    using (SqlCeDataReader rdr = sqlCommand.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            FWarehouseReceipt.Add(new ObjectWarehouseReceipt((Int32)rdr["Id_WarehouseReceipt"], (String)rdr["No"]));
                        }
                    }
                }
            }
        }

        public ObjectWarehouseReceipt Item(Int32 aIndex)
        {
            return FWarehouseReceipt[aIndex];
        }

        public Int32 Count { get { return FWarehouseReceipt.Count; } }

    }
}