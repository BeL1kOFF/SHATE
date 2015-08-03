using System;
using System.Linq;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlServerCe;
using Datalogic.API;
using System.IO;
using System.Reflection;
using UnfoldingOfGoods.Logic;
using UnfoldingOfGoods.Logic.Xml.Response;
using UnfoldingOfGoods.Logic.Objects;

namespace UnfoldingOfGoods
{
    public partial class FormMain : Form
    {

        private Boolean FFirstLogin;

        public FormMain()
        {
            GC.Collect();
            InitializeComponent();
            FFirstLogin = true;
            grDetail.DataSource = bsDetail;
            PrepareComponentLogin();
        }

        private void FillDocumentNumbers()
        {
            cmbBarCode.Items.Clear();
            ObjectWarehouseReceiptList warehouseReceipt = ObjectFactory.WarehouseReceipt();

            for (Int32 k = 0; k < warehouseReceipt.Count; k++)
            {
                cmbBarCode.Items.Add(warehouseReceipt.Item(k).No);
            }
        }

        private void PrepareComponentLogin()
        {
            PrepareComponentWarehouseReceipt();
            edtName.Text = "";
            edtUserCode.Text = "";
        }

        private void PrepareComponentWarehouseReceipt()
        {
            PrepareComponentPlacementActivity();
            cmbBarCode.Text = "";
            cmbBarCode.Items.Clear();
        }

        private void PrepareComponentPlacementActivity()
        {
            mDetails.Text = "";
            bsDetail.DataSource = null;
            edtNumber.Text = "";
            btnSubmit.Enabled = false;
        }

        private void InitLogin(String aUserBarCode)
        {
            using (CursorWait cw = CursorWait.CreateWaitCursor())
            {
                GC.Collect();
                Boolean correctLogin = true;
                if (ClassFactory.DataBase.IsDataExists())
                {
                    correctLogin = ClassFactory.Logic.ProcessedLiveExpiredData();
                }
                if (correctLogin)
                {
                    if (!FFirstLogin)
                    {
                        ClassFactory.Logic.Logout();
                    }
                    if (ClassFactory.Logic.DeleteAllData())
                    {
                        if (ClassFactory.Logic.Login(aUserBarCode))
                        {
                            FFirstLogin = false;
                            ObjectEmployee employee = ObjectFactory.Employee();
                            edtName.Tag = employee;
                            edtName.Text = employee.UserName;
                            if (ClassFactory.Logic.LoadDocNumbers())
                            {
                                FillDocumentNumbers();
                            }

                            cmbBarCode.Enabled = true;
                            cmbBarCode.BackColor = SystemColors.Window;
                            cmbBarCode.Focus();
                            PrepareComponentPlacementActivity();
                        }
                        else
                        {
                            PrepareComponentLogin();
                        }
                    }
                    else
                    {
                        MyClass.ShowWarning("Данные не очищенны для работы.");
                    }
                }
            }
        }

        private void InitPlacementActivity(String aDocumentNo)
        {
            using (CursorWait cw = CursorWait.CreateWaitCursor())
            {
                PrepareComponentPlacementActivity();
                if (ClassFactory.Logic.LoadDocPlacementDetails(aDocumentNo))
                {
                    ObjectPlacementActivityHeader pah = ObjectFactory.PlacementActivityHeader();
                    if (pah.Id_PlacementActivityHeader != 0)
                    {
                        cmbBarCode.Tag = pah;
                        ClassFactory.DataBase.BindingSource.AssignDetail(bsDetail);
                        btnSubmit.Enabled = true;
                        if (bsDetail.Count > 0)
                        {
                            grDetail.CurrentRowIndex = 0;
                            ShowLineDetailFromGrid(grDetail);
                        }
                    }
                    else
                    {
                        MyClass.ShowWarning("Заданий на раскладку не найдено");
                        PrepareComponentPlacementActivity();
                        cmbBarCode.Focus();
                    }
                }
                else
                {
                    PrepareComponentPlacementActivity();
                    cmbBarCode.Focus();
                }
            }
        }

        private void ShowLineDetailFromGrid(DataGrid aDataGrid)
        {
            DataTable dt = (DataTable)bsDetail.DataSource;
            DataRow row = dt.Rows[aDataGrid.CurrentRowIndex];
            mDetails.Text = String.Concat((String)row["ItemNo"], "\r\n", (String)row["UnitOfMeasure"], "\r\n", (String)row["Description"]);
        }

        private void ShowDetailForm()
        {
            Form frmDetail = new FormDetail();
            frmDetail.ShowDialog();
        }

        private void edtUserCode_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                if (((TextBox)sender).Text.Equals("0000admin"))
                {
                    Form frmOptions = new FormOptions();
                    frmOptions.ShowDialog();
                }
                else
                {
                    InitLogin(((TextBox)sender).Text);
                }
            }
        }

        private void frmMain_Load(object sender, EventArgs e)
        {
            edtUserCode.Focus();
        }

        private void cmbBarCode_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                InitPlacementActivity(((ComboBox)sender).Text);
            }
        }

        private void cmbBarCode_SelectedIndexChanged(object sender, EventArgs e)
        {
            InitPlacementActivity(((ComboBox)sender).Text);
        }

        private void grDetail_CurrentCellChanged(object sender, EventArgs e)
        {
            using (CursorWait cw = CursorWait.CreateWaitCursor())
            {
                ShowLineDetailFromGrid(((DataGrid)sender));
            }
        }

        private void btnSubmit_Click(object sender, EventArgs e)
        {
            ShowDetailForm();
        }

        private void FormMain_Closing(object sender, CancelEventArgs e)
        {
            using (CursorWait cw = CursorWait.CreateWaitCursor())
            {
                e.Cancel = false;
                if (ObjectFactory.Session().Id_Session > 0)
                {
                    if (!ClassFactory.Logic.Logout())
                    {
                        if (!MyClass.ShowQuestion("Не удалось корректно завершить сессию. Продолжить выход из программы?"))
                        {
                            e.Cancel = true;
                        }
                    }
                }
            }
        }

    }
}