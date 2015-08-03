using System.Data;
using System.Data.SqlServerCe;
using System.Windows.Forms;

namespace UnfoldingOfGoods.Logic
{
    public class DataBindingSource
    {

        public void AssignLocate(BindingSource aBindingSource)
        {
            DataSet ds = new DataSet();
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT pal.BinCode, pal.ItemNo2, pal.QtyPlacement, pal.ItemNo, " +
                    "pal.UnitOfMeasure, pal.Description, pal.BinContQty, pal.Id_PlacementActivityLine, pal.ProcessedQty + SUM(COALESCE(al.ProcessedQty, 0)) AS ProcessedQty, pal.QuantityInPackage FROM PlacementActivityLine AS pal " +
                    "LEFT JOIN ActivityLine AS al ON al.Id_PlacementActivityLine = pal.Id_PlacementActivityLine " +
                    "GROUP BY pal.BinCode, pal.ItemNo2, pal.QtyPlacement, pal.ItemNo, pal.UnitOfMeasure, pal.Description, pal.BinContQty, " +
                    "pal.Id_PlacementActivityLine, pal.ProcessedQty, pal.QuantityInPackage", sqlConnection))
                {
                    sqlCommand.CommandType = CommandType.Text;
                    using (SqlCeDataAdapter adapter = new SqlCeDataAdapter(sqlCommand))
                    {
                        adapter.Fill(ds, "Locate");
                    }
                }
            }
            aBindingSource.DataSource = ds.Tables["Locate"];
        }

        public void AssignProcessed(BindingSource aBindingSource)
        {
            DataSet ds = new DataSet();
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT al.Id_ActivityLine, al.BinCode, pal.ItemNo2, al.ProcessedQty, pal.ItemNo, pal.UnitOfMeasure, pal.Description FROM ActivityLine AS al " +
                    "JOIN PlacementActivityLine AS pal ON pal.Id_PlacementActivityLine = al.Id_PlacementActivityLine", sqlConnection))
                {
                    sqlCommand.CommandType = CommandType.Text;
                    using (SqlCeDataAdapter adapter = new SqlCeDataAdapter(sqlCommand))
                    {
                        adapter.Fill(ds, "Processed");
                    }
                }
            }
            aBindingSource.DataSource = ds.Tables["Processed"];
        }

        public void AssignItemCell(BindingSource aBindingSource)
        {
            DataSet ds = new DataSet();
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT bc.ItemNo, bc.ItemNo2, bc.BinCode, bc.Quantity, bc.[Fixed], bc.[Default] FROM BinContent AS bc", sqlConnection))
                {
                    sqlCommand.CommandType = CommandType.Text;
                    using (SqlCeDataAdapter adapter = new SqlCeDataAdapter(sqlCommand))
                    {
                        adapter.Fill(ds, "ItemCell");
                    }
                }
            }
            aBindingSource.DataSource = ds.Tables["ItemCell"];
        }

        public void AssignDetail(BindingSource aBindingSource)
        {
            DataSet ds = new DataSet();
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT pal.ItemNo2, pal.BinCode, pal.QtyPlacement, pal.ProcessedQty, pal.ItemNo, " +
                    "pal.UnitOfMeasure, pal.Description FROM PlacementActivityLine AS pal", sqlConnection))
                {
                    sqlCommand.CommandType = CommandType.Text;
                    using (SqlCeDataAdapter adapter = new SqlCeDataAdapter(sqlCommand))
                    {
                        adapter.Fill(ds, "Detail");
                    }
                }
            }
            aBindingSource.DataSource = ds.Tables["Detail"];
        }

    }
}