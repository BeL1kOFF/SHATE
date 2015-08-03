using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlServerCe;
using System.Linq;
using System.Windows.Forms;

namespace UnfoldingOfGoods.Logic.Objects
{
    public class ObjectActivityLineList
    {

        private List<ObjectActivityLine> FActivityLine;

        public ObjectActivityLineList()
        {
            FActivityLine = new List<ObjectActivityLine>();
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT al.Id_ActivityLine, al.BinCode, al.ProcessedQty, al.Id_PlacementActivityLine FROM ActivityLine AS al", sqlConnection))
                {
                    sqlCommand.CommandType = CommandType.Text;
                    using (SqlCeDataReader rdr = sqlCommand.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            FActivityLine.Add(new ObjectActivityLine((Int32)rdr["Id_ActivityLine"],
                                (String)rdr["BinCode"], (Int32)rdr["ProcessedQty"], (Int32)rdr["Id_PlacementActivityLine"]));
                        }
                    }
                }
            }
        }

        public ObjectActivityLine Item(Int32 aIndex)
        {
            return FActivityLine[aIndex];
        }

        public Int32 Count { get { return FActivityLine.Count; } }

    }
}