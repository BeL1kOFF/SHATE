using System;
using System.Data;
using System.Data.SqlServerCe;
using UnfoldingOfGoods.Logic.Objects;
using System.Collections.Generic;
using UnfoldingOfGoods.Logic.Xml.Message;
using UnfoldingOfGoods.Logic.Xml.Response.GetDocNumbers;
using UnfoldingOfGoods.Logic.Xml.Response.GetDocPlacement;
using UnfoldingOfGoods.Logic.Xml.Response.GetBinContent;
using UnfoldingOfGoods.Logic.Xml.Response.LoginUser;

namespace UnfoldingOfGoods.Logic
{
    public class DataLogic
    {

        private DataBindingSource FDataBindingSource;

        public DataLogic()
        {
            FDataBindingSource = new DataBindingSource();
        }

        public DataBindingSource BindingSource
        {
            get
            {
                return FDataBindingSource;
            }
        }

        public void DeleteAllData()
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeTransaction sqlTran = sqlConnection.BeginTransaction())
                {
                    try
                    {
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("DELETE FROM BinContent", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.ExecuteNonQuery();
                        }
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("DELETE FROM ActivityLine", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.ExecuteNonQuery();
                        }
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("DELETE FROM PlacementActivityLine", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.ExecuteNonQuery();
                        }
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("DELETE FROM PlacementActivityHeader", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.ExecuteNonQuery();
                        }
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("DELETE FROM WarehouseReceipt", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.ExecuteNonQuery();
                        }
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("DELETE FROM Employee", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.ExecuteNonQuery();
                        }
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("DELETE FROM Session", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.ExecuteNonQuery();
                        }
                        sqlTran.Commit();
                    }
                    catch
                    {
                        sqlTran.Rollback();
                        throw;
                    }
                }
            }
        }

        public void DeleteActivity()
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeTransaction sqlTran = sqlConnection.BeginTransaction())
                {
                    try
                    {
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("DELETE FROM ActivityLine", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.ExecuteNonQuery();
                        }
                        sqlTran.Commit();
                    }
                    catch
                    {
                        sqlTran.Rollback();
                        throw;
                    }
                }
            }
        }

        public void InsertAuthorize(String aUserBarCode, XmlResponseLoginUserResult aResult)
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeTransaction sqlTran = sqlConnection.BeginTransaction())
                {
                    try
                    {
                        Int32 id_Session = ObjectFactory.Session(sqlTran).Id_Session;
                        if (id_Session > 0)
                        {
                            using (SqlCeCommand sqlCommand = new SqlCeCommand("UPDATE Session SET Session = @Session, [DateTime] = @DateTime", sqlConnection, sqlTran))
                            {
                                sqlCommand.CommandType = CommandType.Text;
                                sqlCommand.Parameters.Add(new SqlCeParameter("@Session", aResult.Session));
                                sqlCommand.Parameters.Add(new SqlCeParameter("@DateTime", aResult.DateTime));
                                sqlCommand.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            using (SqlCeCommand sqlCommand = new SqlCeCommand("INSERT INTO Session(Session, [DateTime]) VALUES(@Session, @DateTime)", sqlConnection, sqlTran))
                            {
                                sqlCommand.CommandType = CommandType.Text;
                                sqlCommand.Parameters.Add(new SqlCeParameter("@Session", aResult.Session));
                                sqlCommand.Parameters.Add(new SqlCeParameter("@DateTime", aResult.DateTime));
                                sqlCommand.ExecuteNonQuery();
                            }

                            using (SqlCeCommand sqlCommand = new SqlCeCommand("INSERT INTO [Employee](UserBarCode, UserName) " +
                                                                              "VALUES(@UserBarCode, @UserName)", sqlConnection, sqlTran))
                            {
                                sqlCommand.CommandType = CommandType.Text;
                                sqlCommand.Parameters.Add(new SqlCeParameter("@UserBarCode", aUserBarCode));
                                sqlCommand.Parameters.Add(new SqlCeParameter("@UserName", aResult.UserFio));
                                sqlCommand.ExecuteNonQuery();
                            }
                        }

                        sqlTran.Commit();
                    }
                    catch
                    {
                        sqlTran.Rollback();
                        throw;
                    }
                }
            }
        }

        public void InsertDocumentNumbers(XmlResponseGetDocNumbersResult aResultGetDocNumbers)
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeTransaction sqlTran = sqlConnection.BeginTransaction())
                {
                    try
                    {
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("INSERT INTO WarehouseReceipt(No) " +
                                                                          "VALUES (@No)", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;

                            SqlCeParameter param = sqlCommand.CreateParameter();
                            param.ParameterName = "@No";
                            sqlCommand.Parameters.Add(param);

                            for (Int32 k = 0; k < aResultGetDocNumbers.Documents.Count; k++)
                            {
                                sqlCommand.Parameters["@No"].Value = aResultGetDocNumbers.Documents.Document(k).No;
                                sqlCommand.ExecuteNonQuery();
                            }
                        }
                        sqlTran.Commit();
                    }
                    catch
                    {
                        sqlTran.Rollback();
                        throw;
                    }
                }
            }
        }

        public void InsertPlacementActivity(XmlResponseGetDocPlacementResult aResultGetDocPlacement)
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeTransaction sqlTran = sqlConnection.BeginTransaction())
                {
                    try
                    {
                        // Удаляем все позиции выбранного документа
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("DELETE FROM PlacementActivityLine", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.ExecuteNonQuery();
                        }

                        // Удаляем выбранный документ
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("DELETE FROM PlacementActivityHeader", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.ExecuteNonQuery();
                        }

                        if (aResultGetDocPlacement.Document.Count > 0)
                        {
                            // Вставляем новую запись выбранного документа
                            using (SqlCeCommand sqlCommand = new SqlCeCommand("INSERT INTO PlacementActivityHeader(No) VALUES(@No)", sqlConnection, sqlTran))
                            {
                                sqlCommand.CommandType = CommandType.Text;
                                sqlCommand.Parameters.Add(new SqlCeParameter("@No", aResultGetDocPlacement.Document.No));
                                sqlCommand.ExecuteNonQuery();
                            }
                            
                            // Вставляем новые позиции выбранного документа
                            using (SqlCeCommand sqlCommand = new SqlCeCommand("PlacementActivityLine", sqlConnection, sqlTran))
                            {
                                sqlCommand.CommandType = CommandType.TableDirect;
                                using (SqlCeResultSet rs = sqlCommand.ExecuteResultSet(ResultSetOptions.Updatable))
                                {
                                    SqlCeUpdatableRecord rec = rs.CreateRecord();

                                    Int32 id_PlacementActivityHeader = ObjectFactory.PlacementActivityHeader(sqlTran).Id_PlacementActivityHeader;
                                    rec["Id_PlacementActivityHeader"] = id_PlacementActivityHeader;

                                    Int32 count = aResultGetDocPlacement.Document.Count;
                                    for (Int32 k = 0; k < count; k++)
                                    {
                                        rec["ItemNo"] = aResultGetDocPlacement.Document.Line(k).ItemNo;
                                        rec["ItemNo2"] = aResultGetDocPlacement.Document.Line(k).ItemNo2;
                                        rec["Description"] = aResultGetDocPlacement.Document.Line(k).Description;
                                        rec["UnitOfMeasure"] = aResultGetDocPlacement.Document.Line(k).UnitOfMeasure;
                                        rec["QtyPlacement"] = aResultGetDocPlacement.Document.Line(k).QtyPlacement;
                                        rec["ProcessedQty"] = aResultGetDocPlacement.Document.Line(k).ProcessedQty;
                                        rec["BinCode"] = aResultGetDocPlacement.Document.Line(k).BinCode;
                                        rec["BinContQty"] = aResultGetDocPlacement.Document.Line(k).BinContQty;
                                        rec["LineNo"] = aResultGetDocPlacement.Document.Line(k).LineNo;
                                        if (aResultGetDocPlacement.Document.Line(k).QuantityInPackage == 0)
                                        {
                                            rec["QuantityInPackage"] = 1;
                                        }
                                        else
                                        {
                                            rec["QuantityInPackage"] = aResultGetDocPlacement.Document.Line(k).QuantityInPackage;
                                        }
                                        rs.Insert(rec);
                                    }
                                }
                            }
                        }

                        sqlTran.Commit();
                    }
                    catch
                    {
                        sqlTran.Rollback();
                        throw;
                    }
                }
            }
        }

        public Boolean ActiveLineIsBinCodeEmpty()
        {
            Object obj;
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT TOP (1) al.Id_ActivityLine FROM ActivityLine AS al " +
                                                                  "WHERE al.BinCode = N''", sqlConnection))
                {
                    sqlCommand.CommandType = CommandType.Text;
                    obj = sqlCommand.ExecuteScalar();
                }
            }
            return (obj != null);
        }

        public void FillBinCode(String aBinCode)
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeTransaction sqlTran = sqlConnection.BeginTransaction())
                {
                    try
                    {
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("UPDATE ActivityLine SET BinCode = @aBinCode " +
                                                                          "WHERE BinCode = N''", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.Parameters.Add(new SqlCeParameter("@aBinCode", aBinCode));
                            sqlCommand.ExecuteNonQuery();
                        }
                        sqlTran.Commit();
                    }
                    catch
                    {
                        sqlTran.Rollback();
                        throw;
                    }
                }
            }
        }

        public void FillBinContent(XmlResponseGetBinContentResult aXmlResponseResultGetBinContent)
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeTransaction sqlTran = sqlConnection.BeginTransaction())
                {
                    try
                    {
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("DELETE FROM BinContent", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.ExecuteNonQuery();
                        }
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("INSERT INTO BinContent (ItemNo, ItemNo2, BinCode, Quantity, [Fixed], [Default]) " +
                                                                          "VALUES (@ItemNo, @ItemNo2, @BinCode, @Quantity, @Fixed, @Default)", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.Parameters.Add(new SqlCeParameter("@ItemNo", aXmlResponseResultGetBinContent.BinContent.ItemNo));
                            sqlCommand.Parameters.Add(new SqlCeParameter("@ItemNo2", aXmlResponseResultGetBinContent.BinContent.ItemNo2));

                            SqlCeParameter param = sqlCommand.CreateParameter();
                            param.ParameterName = "@BinCode";
                            sqlCommand.Parameters.Add(param);

                            param = sqlCommand.CreateParameter();
                            param.ParameterName = "@Quantity";
                            sqlCommand.Parameters.Add(param);

                            param = sqlCommand.CreateParameter();
                            param.ParameterName = "@Fixed";
                            sqlCommand.Parameters.Add(param);

                            param = sqlCommand.CreateParameter();
                            param.ParameterName = "@Default";
                            sqlCommand.Parameters.Add(param);

                            for (Int32 k = 0; k < aXmlResponseResultGetBinContent.BinContent.Count; k++)
                            {
                                sqlCommand.Parameters["@BinCode"].Value = aXmlResponseResultGetBinContent.BinContent.Item(k).BinCode;
                                sqlCommand.Parameters["@Quantity"].Value = aXmlResponseResultGetBinContent.BinContent.Item(k).Quantity;
                                sqlCommand.Parameters["@Fixed"].Value = aXmlResponseResultGetBinContent.BinContent.Item(k).Fixed;
                                sqlCommand.Parameters["@Default"].Value = aXmlResponseResultGetBinContent.BinContent.Item(k).Default;
                                sqlCommand.ExecuteNonQuery();
                            }
                        }
                        sqlTran.Commit();
                    }
                    catch
                    {
                        sqlTran.Rollback();
                        throw;
                    }
                }
            }
        }

        public Boolean IsDataExists()
        {
            Object obj;
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT TOP (1) al.Id_ActivityLine FROM ActivityLine AS al ", sqlConnection))
                {
                    sqlCommand.CommandType = CommandType.Text;
                    obj = sqlCommand.ExecuteScalar();
                }
            }
            return (obj != null);
        }

        public void GetCountParamsQty(Int32 aId_PlacementActivityLine, out Int32 aPalQtyPlacement, out Int32 aPalProcessedQty, out Int32 aAlProcessedQty)
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT pal.QtyPlacement, pal.ProcessedQty, SUM(COALESCE(al.ProcessedQty, 0)) AS AlProcessedQty " +
                                                                  "FROM PlacementActivityLine AS pal LEFT JOIN ActivityLine AS al ON al.Id_PlacementActivityLine = pal.Id_PlacementActivityLine " +
                                                                  "WHERE pal.Id_PlacementActivityLine = @Id_PlacementActivityLine GROUP BY pal.QtyPlacement, pal.ProcessedQty", sqlConnection))
                {
                    sqlCommand.CommandType = CommandType.Text;
                    sqlCommand.Parameters.Add(new SqlCeParameter("@Id_PlacementActivityLine", aId_PlacementActivityLine));
                    using (SqlCeDataReader rdr = sqlCommand.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            aPalQtyPlacement = (Int32)rdr["QtyPlacement"];
                            aPalProcessedQty = (Int32)rdr["ProcessedQty"];
                            aAlProcessedQty = (Int32)rdr["AlProcessedQty"];
                        }
                        else
                        {
                            aPalQtyPlacement = 0;
                            aPalProcessedQty = 0;
                            aAlProcessedQty = 0;
                        }
                    }
                }
            }
        }

        public Int32 GetCountCurrentActivityLine(Int32 aId_ActivityLine)
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                return GetCountCurrentActivityLine(aId_ActivityLine, sqlConnection, null);
            }
        }

        private Int32 GetCountCurrentActivityLine(Int32 aId_ActivityLine, SqlCeConnection aSqlCeConnection, SqlCeTransaction aSqlCeTransaction)
        {
            Int32 result;

            using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT al.ProcessedQty FROM ActivityLine AS al " +
                                                              "WHERE al.Id_ActivityLine = @Id_ActivityLine ", aSqlCeConnection, aSqlCeTransaction))
            {
                sqlCommand.CommandType = CommandType.Text;
                sqlCommand.Parameters.Add(new SqlCeParameter("@Id_ActivityLine", aId_ActivityLine));
                result = (Int32)sqlCommand.ExecuteScalar();
            }

            return result;
        }

        public void ChangeCountAdd(Int32 aId_PlacementActivityLine, Int32 aCount)
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeTransaction sqlTran = sqlConnection.BeginTransaction())
                {
                    try
                    {
                        Int32 id_ActivityLine = -1;
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("SELECT al.Id_ActivityLine FROM ActivityLine AS al " +
                                                                          "WHERE al.Id_PlacementActivityLine = @Id_PlacementActivityLine AND al.BinCode = N''", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.Parameters.Add(new SqlCeParameter("@Id_PlacementActivityLine", aId_PlacementActivityLine));
                            object obj = sqlCommand.ExecuteScalar();
                            if (obj != null)
                            {
                                id_ActivityLine = (Int32)obj;
                            }
                        }
                        if (id_ActivityLine == -1)
                        {
                            using (SqlCeCommand sqlCommand = new SqlCeCommand("INSERT INTO ActivityLine(Id_PlacementActivityLine, BinCode, ProcessedQty) " +
                                                                              "VALUES (@Id_PlacementActivityLine, N'', @Count)", sqlConnection, sqlTran))
                            {
                                sqlCommand.CommandType = CommandType.Text;
                                sqlCommand.Parameters.Add(new SqlCeParameter("@Id_PlacementActivityLine", aId_PlacementActivityLine));
                                sqlCommand.Parameters.Add(new SqlCeParameter("@Count", aCount));
                                sqlCommand.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            using (SqlCeCommand sqlCommand = new SqlCeCommand("UPDATE ActivityLine SET ProcessedQty = ProcessedQty + @Count " +
                                                                              "WHERE Id_ActivityLine = @Id_ActivityLine", sqlConnection, sqlTran))
                            {
                                sqlCommand.CommandType = CommandType.Text;
                                sqlCommand.Parameters.Add(new SqlCeParameter("@Id_ActivityLine", id_ActivityLine));
                                sqlCommand.Parameters.Add(new SqlCeParameter("@Count", aCount));
                                sqlCommand.ExecuteNonQuery();
                            }
                        }
                        sqlTran.Commit();
                    }
                    catch
                    {
                        sqlTran.Rollback();
                        throw;
                    }
                }
            }
        }

        public void ChangeCountDec(Int32 aId_ActivityLine, Int32 aCount)
        {
            using (SqlCeConnection sqlConnection = new SqlCeConnection(MyClass.ConnectionString))
            {
                sqlConnection.Open();
                using (SqlCeTransaction sqlTran = sqlConnection.BeginTransaction())
                {
                    try
                    {
                        using (SqlCeCommand sqlCommand = new SqlCeCommand("UPDATE ActivityLine SET ProcessedQty = ProcessedQty - @Count " +
                                                                          "WHERE Id_ActivityLine = @Id_ActivityLine", sqlConnection, sqlTran))
                        {
                            sqlCommand.CommandType = CommandType.Text;
                            sqlCommand.Parameters.Add(new SqlCeParameter("@Id_ActivityLine", aId_ActivityLine));
                            sqlCommand.Parameters.Add(new SqlCeParameter("@Count", aCount));
                            sqlCommand.ExecuteNonQuery();
                        }

                        Int32 activeCount = GetCountCurrentActivityLine(aId_ActivityLine, sqlConnection, sqlTran);

                        if (activeCount == 0)
                        {
                            using (SqlCeCommand sqlCommand = new SqlCeCommand("DELETE FROM ActivityLine " +
                                                                              "WHERE Id_ActivityLine = @Id_ActivityLine", sqlConnection, sqlTran))
                            {
                                sqlCommand.CommandType = CommandType.Text;
                                sqlCommand.Parameters.Add(new SqlCeParameter("@Id_ActivityLine", aId_ActivityLine));
                                sqlCommand.ExecuteNonQuery();
                            }
                        }
                        sqlTran.Commit();
                    }
                    catch
                    {
                        sqlTran.Rollback();
                        throw;
                    }
                }
            }
        }

    }
}