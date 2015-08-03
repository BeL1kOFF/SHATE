using System;
using System.Data;
using System.Data.SqlServerCe;

namespace UnfoldingOfGoods.Logic.Objects
{
    public class ObjectEmployee
    {

        private Int32 FId_Employee;
        private String FUserBarCode;
        private String FUserName;

        public ObjectEmployee()
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT e.Id_Employee, e.UserBarCode, e.UserName FROM Employee AS e", sqlConnection))
                {
                    sqlCommand.CommandType = CommandType.Text;
                    using (SqlCeDataReader rdr = sqlCommand.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            FId_Employee = (Int32)rdr["Id_Employee"];
                            FUserBarCode = (String)rdr["UserBarCode"];
                            FUserName = (String)rdr["UserName"];
                        }
                    }
                }
            }
        }

        public Int32 Id_Employee { get { return FId_Employee; } }

        public String UserBarCode { get { return FUserBarCode; } }

        public String UserName { get { return FUserName; } }

    }
}