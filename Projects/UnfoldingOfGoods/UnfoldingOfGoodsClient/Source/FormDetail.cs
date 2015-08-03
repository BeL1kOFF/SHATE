using System;
using System.Linq;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using UnfoldingOfGoods.Logic;
using UnfoldingOfGoods.Logic.Objects;
using UnfoldingOfGoods.Logic.Pick;

namespace UnfoldingOfGoods
{
    public partial class FormDetail : Form
    {

        private Byte FStatus;

        public FormDetail()
        {
            InitializeComponent();

            ClassFactory.Logic.DeleteActivityData();
            InitEnterItem();
            CheckActiveTab();
        }

        private void InitEnterItem()
        {
            FStatus = 1;
            edtItemNo2.Text = "";
            bsLocate.Filter = "";
        }

        private void PrepareEnterBarCodeItem(ObjectPlacementActivityLine aObjectPlacementActivityLine)
        {
            edtItemNo2.Text = aObjectPlacementActivityLine.ItemNo2;
            bsLocate.Filter = String.Format("ItemNo = '{0}'", aObjectPlacementActivityLine.ItemNo);
            grLocate.CurrentRowIndex = 0;
        }

        private void EnterBarCodeItem(String aText)
        {
            ObjectPlacementActivityLine pal = ClassFactory.Logic.IsCorrectItem(aText);
            if (pal != null)
            {
                PrepareEnterBarCodeItem(pal);
            }
            else
            {
                MyClass.ShowWarning("Товар не найден");
            }
        }

        private void EnterCell(String aCell)
        {
            if (ClassFactory.DataBase.ActiveLineIsBinCodeEmpty())
            {
                DataRow row = (DataRow)edtBinCode.Tag;
                if (!cbChangeCell.Checked)
                {
                    String binCode = ((String)row["BinCode"]);
                    if (aCell.Substring(0, Math.Min(7, aCell.Length)).Equals(binCode.Substring(0, Math.Min(7, binCode.Length))))
                    {
                        ClassFactory.Logic.FillBinCode(binCode);
                        InitEnterItem();
                    }
                    else
                    {
                        if (binCode.Equals(String.Empty))
                        {
                            ClassFactory.Logic.FillBinCode(aCell);
                            InitEnterItem();
                        }
                        else
                        {
                            MyClass.ShowWarning(@"Введенная ячейка не совпадает с ""по умолчанию""");
                        }
                    }
                }
                else
                {
                    ClassFactory.Logic.FillBinCode(aCell);
                    InitEnterItem();
                }
            }
            else
            {
                MyClass.ShowWarning("Нет товаров без ячеек");
            }
        }

        private void EnterItemQuantity(PickInstanceDelegate aCreateInstance, Int32 aId, Int32 aQuantity)
        {
            IPick pick = aCreateInstance(aId, aQuantity);

            Boolean solve = pick.IsCorrectQuantity();
            if (!solve)
                solve = pick.ShowDialog();
            if (solve)
                pick.ChangeQuantity();            
        }

        private void EnterQuantity(Int32 aQuantity)
        {
            DataRow row = (DataRow)edtBinCode.Tag;
            Boolean enabled = false;
            if (aQuantity % (Int32)row["QuantityInPackage"] == 0)
            {
                enabled = true;
            }
            else
            {
                if (MyClass.ShowQuestion("Введено не кратное кол-во значению по умолчанию. Продолжить?"))
                {
                    enabled = true;
                }
            }
            if (enabled)
            {
                EnterItemQuantity(PickFactory.Locate, (Int32)row["Id_PlacementActivityLine"], aQuantity);
            }
        }

        private void EnterItem(String aItemNo)
        {
            ObjectPlacementActivityLine pal = ClassFactory.Logic.IsCorrectItem(aItemNo);
            if (pal != null)
            {
                DataRow row = (DataRow)edtBinCode.Tag;
                if (aItemNo == (String)(row["ItemNo"]))
                {
                    EnterItemQuantity(PickFactory.Locate, (Int32)row["Id_PlacementActivityLine"], pal.QuantityInPackage);
                }
                else
                {
                    if (ClassFactory.DataBase.ActiveLineIsBinCodeEmpty())
                    {
                        MyClass.ShowWarning(String.Format("Подтвердите ячейку раскладки для товара {0}", (String)(row["ItemNo2"])));
                    }
                    else
                    {
                        PrepareEnterBarCodeItem(pal);
                    }
                }
            }
            else
            {
                MyClass.ShowWarning("Товар не найден");
            }
        }

        private void EnterItemOrCountOrCell(String aText)
        {
            if (aText.Contains("-"))
            {
                EnterCell(aText);
            }
            else
            {
                Boolean isQuantity;
                Int32 quantity = 0;
                if (aText.Length < 5)
                {
                    try
                    {
                        quantity = Convert.ToInt32(aText);
                        isQuantity = ((quantity >= 1) && (quantity <= 1000));
                    }
                    catch
                    {
                        isQuantity = false;
                    }
                }
                else
                {
                    isQuantity = false;
                }
                if (isQuantity)
                {
                    EnterQuantity(quantity);
                }
                else
                {
                    EnterItem(aText);
                }
            }
        }

        private void CheckScan(String aText)
        {
            using (CursorWait cw = CursorWait.CreateWaitCursor())
            {
                switch (FStatus)
                {
                    case 1:
                        EnterBarCodeItem(aText);
                        break;
                    case 2:
                        EnterItemOrCountOrCell(aText);
                        break;
                    default:
                        MyClass.ShowError("Неизвестный статус");
                        break;
                }
                CheckActiveTab();
            }
        }

        private void edtScan_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                CheckScan(((TextBox)sender).Text);
                ((TextBox)sender).Text = "";
            }
        }

        private void grLocate_CurrentCellChanged(object sender, EventArgs e)
        {
            ChangeLocateRowGrid();
        }

        private void tcDetail_SelectedIndexChanged(object sender, EventArgs e)
        {
            CheckActiveTab();
        }

        private void btnOne_Click(object sender, EventArgs e)
        {
            using (CursorWait cw = CursorWait.CreateWaitCursor())
            {
                switch (tcDetail.SelectedIndex)
                {
                    case 0:
                        EnterItemQuantity(PickFactory.Locate, (Int32)LocateCurrentRow["Id_PlacementActivityLine"], 1);
                        break;
                    case 1:
                        EnterItemQuantity(PickFactory.Processed, (Int32)ProcessedCurrentRow["Id_ActivityLine"], 1);
                        break;
                    case 2:
                        break;
                    default:
                        break;
                }
                CheckActiveTab();
            }
        }

        private DataRow LocateCurrentRow
        {
            get
            {
                return ((DataRowView)bsLocate.Current).Row;
            }
        }

        private DataRow ProcessedCurrentRow
        {
            get
            {
                return ((DataRowView)bsProcessed.Current).Row;
            }
        }

        private void CheckInfo(String aText)
        {
            if (aText == "")
            {
                FStatus = 1;
                edtInfo.Text = "Введите ШК товара";

            }
            else
            {
                FStatus = 2;
                edtInfo.Text = "Подтвердите Количество / Ячейку";
            }
        }

        private void UpdateAction()
        {
            switch (tcDetail.SelectedIndex)
            {
                case 0:
                    btnOne.Enabled = ((bsLocate.Current != null) && (FStatus == 2));
                    btnFull.Enabled = ((bsLocate.Current != null) && (FStatus == 2));
                    switch (FStatus)
                    {
                        case 1:
                            grLocate.TableStyles[1].MappingName = "L1";
                            grLocate.TableStyles[0].MappingName = "Locate";
                            break;
                        case 2:
                            grLocate.TableStyles[0].MappingName = "L2";
                            grLocate.TableStyles[1].MappingName = "Locate";
                            break;
                        default:
                            break;
                    }
                    break;
                case 1:
                    btnOne.Enabled = ((bsProcessed.Current != null) && (FStatus == 2));
                    btnFull.Enabled = ((bsProcessed.Current != null) && (FStatus == 2));
                    break;
                case 2:
                    btnOne.Enabled = false;
                    btnFull.Enabled = false;
                    break;
                default:
                    btnOne.Enabled = false;
                    btnFull.Enabled = false;
                    break;
            }
        }

        private void ChangeLocateRowGrid()
        {
            using (CursorWait cw = CursorWait.CreateWaitCursor())
            {
                edtBinCode.Tag = LocateCurrentRow;
                edtBinCode.Text = (String)LocateCurrentRow["BinCode"];
                mDetails.Text = String.Concat((String)LocateCurrentRow["ItemNo"], "      ", (String)LocateCurrentRow["UnitOfMeasure"], "\r\n", (String)LocateCurrentRow["Description"], "\r\n", Convert.ToString((Int32)LocateCurrentRow["BinContQty"]));
            }
        }

        private void RefreshLocateGrid()
        {
            Int32 currentIndex = grLocate.CurrentRowIndex;
            ClassFactory.DataBase.BindingSource.AssignLocate(bsLocate);
            if (((currentIndex == -1) && (bsLocate.Count > 0)) || (currentIndex >= bsLocate.Count))
            {
                if (bsLocate.Count > 0)
                {
                    grLocate.CurrentRowIndex = 0;
                }
            }
            else
            {
                if (bsLocate.Count > 0)
                {
                    grLocate.CurrentRowIndex = currentIndex;
                }
            }
            if (bsLocate.Count > 0)
            {
                ChangeLocateRowGrid();
            }
        }

        private void ChangeProcessedRowGrid()
        {
            using (CursorWait cw = CursorWait.CreateWaitCursor())
            {
                mDetails.Text = String.Concat((String)ProcessedCurrentRow["ItemNo"], "\r\n", (String)ProcessedCurrentRow["UnitOfMeasure"], "\r\n", (String)ProcessedCurrentRow["Description"]);
            }
        }

        private void RefreshProcessedGrid()
        {
            ClassFactory.DataBase.BindingSource.AssignProcessed(bsProcessed);
            if (bsProcessed.Count > 0)
            {
                ChangeProcessedRowGrid();
            }
            else
            {
                mDetails.Text = "";
            }
        }

        private void RefreshItemCellGrid()
        {
            mDetails.Text = "";
            if (FStatus == 2)
            {
                DataRow row = (DataRow)edtBinCode.Tag;
                if (ClassFactory.Logic.LoadBinContent((String)row["ItemNo"]))
                {
                    ClassFactory.DataBase.BindingSource.AssignItemCell(bsItemCell);
                }
            }
            else
            {
                MyClass.ShowWarning("Введите код товара");
            }
        }

        private void CheckActiveTab()
        {
            using (CursorWait cw = CursorWait.CreateWaitCursor())
            {
                GC.Collect();
                CheckInfo(edtItemNo2.Text);
                RefreshLocateGrid();
                bsItemCell.DataSource = null;
                cbChangeCell.Checked = false;
                switch (tcDetail.SelectedIndex)
                {
                    case 0:
                        btnOne.Text = "+1";
                        btnFull.Text = "+N";
                        break;
                    case 1:
                        btnOne.Text = "-1";
                        btnFull.Text = "-N";
                        RefreshProcessedGrid();
                        break;
                    case 2:
                        btnOne.Text = "";
                        btnFull.Text = "";
                        RefreshItemCellGrid();
                        break;
                    default:
                        btnOne.Text = "";
                        btnFull.Text = "";
                        break;
                }
                UpdateAction();
            }
        }

        private void btnFull_Click(object sender, EventArgs e)
        {
            using (CursorWait cw = CursorWait.CreateWaitCursor())
            {
                Int32 activeCount = 0;
                switch (tcDetail.SelectedIndex)
                {
                    case 0:
                        Int32 totalCount;
                        Int32 predCount;
                        ClassFactory.DataBase.GetCountParamsQty((Int32)LocateCurrentRow["Id_PlacementActivityLine"], out totalCount, out predCount, out activeCount);
                        if (predCount + activeCount < totalCount)
                        {
                            EnterItemQuantity(PickFactory.Locate, (Int32)LocateCurrentRow["Id_PlacementActivityLine"], totalCount - predCount - activeCount);
                        }
                        break;
                    case 1:
                        activeCount = ClassFactory.DataBase.GetCountCurrentActivityLine((Int32)ProcessedCurrentRow["Id_ActivityLine"]);
                        EnterItemQuantity(PickFactory.Processed, (Int32)ProcessedCurrentRow["Id_ActivityLine"], activeCount);
                        break;
                    case 2:
                        break;
                    default:
                        break;
                }
                CheckActiveTab();
            }
        }

        private void grProcessed_CurrentCellChanged(object sender, EventArgs e)
        {
            ChangeProcessedRowGrid();
        }

        private void RegisterDocument()
        {
            using (CursorWait cw = CursorWait.CreateWaitCursor())
            {
                if (ObjectFactory.ActivityLine().Count > 0)
                {
                    if (!ClassFactory.DataBase.ActiveLineIsBinCodeEmpty())
                    {
                        if (ClassFactory.Logic.RegisterPlacement(false))
                        {
                            ClassFactory.Logic.DeleteActivityData();
                            ClassFactory.Logic.LoadDocPlacementDetails(ObjectFactory.PlacementActivityHeader().No);                            
                            InitEnterItem();
                        }
                    }
                    else
                    {
                        MyClass.ShowWarning("Регистрация невозможна. Укажите ячейки");
                    }
                }
                else
                {
                    ClassFactory.Logic.DeleteActivityData();
                    InitEnterItem();
                }

                CheckActiveTab();
            }
        }

        private void btnRegister_Click(object sender, EventArgs e)
        {
            RegisterDocument();
        }

        private void FormDetail_Load(object sender, EventArgs e)
        {
            edtScan.Focus();
        }

        private void FormDetail_Closing(object sender, CancelEventArgs e)
        {
            e.Cancel = false;
            using (CursorWait cw = CursorWait.CreateWaitCursor())
            {
                if (ObjectFactory.ActivityLine().Count != 0)
                {
                    e.Cancel = true;
                    MyClass.ShowWarning("Остались незарегистрированные строки!");
                }
            }
        }

        private void FormDetail_KeyUp(object sender, KeyEventArgs e)
        {
            e.Handled = false;
            if ((e.KeyCode == Keys.F5) && (btnRegister.Enabled))
            {
                e.Handled = true;
                RegisterDocument();
            }
        }

    }
}