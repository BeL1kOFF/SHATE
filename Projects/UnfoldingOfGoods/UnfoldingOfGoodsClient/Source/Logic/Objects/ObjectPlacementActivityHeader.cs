using System;
using System.Data;
using System.Data.SqlServerCe;

namespace UnfoldingOfGoods.Logic.Objects
{
    public class ObjectPlacementActivityHeader
    {

        private Int32 FId_PlacementActivityHeader = 0;
        private String FNo = null;

        public ObjectPlacementActivityHeader()
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                OpenConnection(sqlConnection, null);
            }
        }

        public ObjectPlacementActivityHeader(SqlCeTransaction aSqlCeTransaction)
        {
            OpenConnection((SqlCeConnection)aSqlCeTransaction.Connection, aSqlCeTransaction);
        }

        private void OpenConnection(SqlCeConnection aSqlCeConnection, SqlCeTransaction aSqlCeTransaction)
        {
            using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT pah.Id_PlacementActivityHeader, pah.No FROM PlacementActivityHeader AS pah", aSqlCeConnection, aSqlCeTransaction))
            {
                sqlCommand.CommandType = CommandType.Text;
                using (SqlCeDataReader rdr = sqlCommand.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        FId_PlacementActivityHeader = (Int32)rdr["Id_PlacementActivityHeader"];
                        FNo = (String)rdr["No"];
                    }
                }
            }
        }

        public Int32 Id_PlacementActivityHeader { get { return FId_PlacementActivityHeader; } }

        public String No { get { return FNo; } }

    }
}