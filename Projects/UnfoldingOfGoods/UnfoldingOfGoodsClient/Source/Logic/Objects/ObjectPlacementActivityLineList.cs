using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlServerCe;
using System.Linq;

namespace UnfoldingOfGoods.Logic.Objects
{
    public class ObjectPlacementActivityLineList
    {

        private List<ObjectPlacementActivityLine> FPlacementActivityLine;

        public ObjectPlacementActivityLineList()
        {
            FPlacementActivityLine = new List<ObjectPlacementActivityLine>();
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT pal.Id_PlacementActivityLine, pal.ItemNo, pal.ItemNo2, pal.Description, " +
                    "pal.UnitOfMeasure, pal.QtyPlacement, pal.ProcessedQty, pal.BinCode, pal.BinContQty, pal.[LineNo], pal.QuantityInPackage " +
                    "FROM PlacementActivityLine AS pal WHERE pal.Id_PlacementActivityHeader = @Id_PlacementActivityHeader", sqlConnection))
                {
                    sqlCommand.CommandType = CommandType.Text;
                    sqlCommand.Parameters.Add(new SqlCeParameter("@Id_PlacementActivityHeader", ObjectFactory.PlacementActivityHeader().Id_PlacementActivityHeader));
                    using (SqlCeDataReader rdr = sqlCommand.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            FPlacementActivityLine.Add(new ObjectPlacementActivityLine((Int32)rdr["Id_PlacementActivityLine"], (String)rdr["ItemNo"],
                                (String)rdr["ItemNo2"], (String)rdr["Description"], (String)rdr["UnitOfMeasure"], (Int32)rdr["QtyPlacement"], (Int32)rdr["ProcessedQty"],
                                (String)rdr["BinCode"], (Int32)rdr["BinContQty"], (Int32)rdr["LineNo"], (Int32)rdr["QuantityInPackage"]));
                        }
                    }
                }
            }
        }

        public ObjectPlacementActivityLine Item(Int32 aIndex)
        {
            return FPlacementActivityLine[aIndex];
        }

        public Int32 Count { get { return FPlacementActivityLine.Count; } }

        public ObjectPlacementActivityLine ItemFromId(Int32 aId)
        {
            IEnumerable<ObjectPlacementActivityLine> itemList =
                from pal in FPlacementActivityLine
                where pal.Id_PlacementActivityLine == aId
                select pal;

            foreach (ObjectPlacementActivityLine pal in itemList)
            {
                return pal;
            }
            return null;
        }

        public ObjectPlacementActivityLine ItemFromItemNo(String aItemNo)
        {
            IEnumerable<ObjectPlacementActivityLine> itemList =
                from pal in FPlacementActivityLine
                where pal.ItemNo == aItemNo
                select pal;

            foreach (ObjectPlacementActivityLine pal in itemList)
            {
                return pal;
            }
            return null;
        }

    }
}