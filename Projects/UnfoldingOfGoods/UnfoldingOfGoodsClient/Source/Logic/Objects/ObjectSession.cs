using System;
using System.Data;
using System.Data.Common;
using System.Data.SqlServerCe;

namespace UnfoldingOfGoods.Logic.Objects
{
    public class ObjectSession
    {

        private Int32 FId_Session;
        private Guid FSession;
        private DateTime FDateTime;

        private void OpenConnection(SqlCeConnection aSqlCeConnection, SqlCeTransaction aSqlCeTransaction)
        {
            using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT s.Id_Session, s.Session, s.[DateTime] FROM Session AS s", aSqlCeConnection, aSqlCeTransaction))
            {
                sqlCommand.CommandType = CommandType.Text;
                using (SqlCeDataReader rdr = sqlCommand.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        FId_Session = (Int32)rdr["Id_Session"];
                        FSession = (Guid)rdr["Session"];
                        FDateTime = (DateTime)rdr["DateTime"];
                    }
                }
            }
        }

        public ObjectSession()
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                OpenConnection(sqlConnection, null);
            }
        }

        public ObjectSession(SqlCeTransaction aSqlCeTransaction)
        {
            OpenConnection((SqlCeConnection)aSqlCeTransaction.Connection, aSqlCeTransaction);
        }

        public Int32 Id_Session
        {
            get { return FId_Session; }
        }

        public Guid Session
        {
            get { return FSession; }
        }

        public DateTime DateTime
        {
            get { return FDateTime; }
        }
    }
}