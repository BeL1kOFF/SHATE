namespace UnfoldingOfGoods
{
    partial class FormDetail
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.panel1 = new System.Windows.Forms.Panel();
            this.cbChangeCell = new System.Windows.Forms.CheckBox();
            this.edtBinCode = new System.Windows.Forms.TextBox();
            this.btnRegister = new System.Windows.Forms.Button();
            this.btnFull = new System.Windows.Forms.Button();
            this.btnOne = new System.Windows.Forms.Button();
            this.edtItemNo2 = new System.Windows.Forms.TextBox();
            this.edtInfo = new System.Windows.Forms.TextBox();
            this.edtScan = new System.Windows.Forms.TextBox();
            this.panel2 = new System.Windows.Forms.Panel();
            this.mDetails = new System.Windows.Forms.TextBox();
            this.panel3 = new System.Windows.Forms.Panel();
            this.tcDetail = new System.Windows.Forms.TabControl();
            this.tpLocate = new System.Windows.Forms.TabPage();
            this.bsLocate = new System.Windows.Forms.BindingSource(this.components);
            this.grLocate = new System.Windows.Forms.DataGrid();
            this.tblStyle = new System.Windows.Forms.DataGridTableStyle();
            this.colLocateBinCode = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colLocateItemNo2 = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colLocateQtyPlacement = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colLocateProcessedQty = new System.Windows.Forms.DataGridTextBoxColumn();
            this.tblStyle2 = new System.Windows.Forms.DataGridTableStyle();
            this.colLocateQtyPlacement2 = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colLocateProcessedQty2 = new System.Windows.Forms.DataGridTextBoxColumn();
            this.tpProcessed = new System.Windows.Forms.TabPage();
            this.bsProcessed = new System.Windows.Forms.BindingSource(this.components);
            this.grProcessed = new System.Windows.Forms.DataGrid();
            this.tblProcessedStyle = new System.Windows.Forms.DataGridTableStyle();
            this.colProcessedItemNo2 = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colProcessedBinCode = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colProcessedProcessedQty = new System.Windows.Forms.DataGridTextBoxColumn();
            this.tpItemBinCode = new System.Windows.Forms.TabPage();
            this.bsItemCell = new System.Windows.Forms.BindingSource(this.components);
            this.grItemCell = new System.Windows.Forms.DataGrid();
            this.tblItemCellStyle = new System.Windows.Forms.DataGridTableStyle();
            this.colItemCellItemNo2 = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colItemCellItemNo = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colItemCellBinCode = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colItemCellQuantity = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colItemCellFixed = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colItemCellDefault = new System.Windows.Forms.DataGridTextBoxColumn();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel3.SuspendLayout();
            this.tcDetail.SuspendLayout();
            this.tpLocate.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.bsLocate)).BeginInit();
            this.tpProcessed.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.bsProcessed)).BeginInit();
            this.tpItemBinCode.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.bsItemCell)).BeginInit();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.cbChangeCell);
            this.panel1.Controls.Add(this.edtBinCode);
            this.panel1.Controls.Add(this.btnRegister);
            this.panel1.Controls.Add(this.btnFull);
            this.panel1.Controls.Add(this.btnOne);
            this.panel1.Controls.Add(this.edtItemNo2);
            this.panel1.Controls.Add(this.edtInfo);
            this.panel1.Controls.Add(this.edtScan);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(638, 83);
            // 
            // cbChangeCell
            // 
            this.cbChangeCell.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.cbChangeCell.Location = new System.Drawing.Point(614, 52);
            this.cbChangeCell.Name = "cbChangeCell";
            this.cbChangeCell.Size = new System.Drawing.Size(24, 20);
            this.cbChangeCell.TabIndex = 7;
            // 
            // edtBinCode
            // 
            this.edtBinCode.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.edtBinCode.BackColor = System.Drawing.SystemColors.InactiveBorder;
            this.edtBinCode.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.edtBinCode.Location = new System.Drawing.Point(526, 53);
            this.edtBinCode.Name = "edtBinCode";
            this.edtBinCode.ReadOnly = true;
            this.edtBinCode.Size = new System.Drawing.Size(86, 19);
            this.edtBinCode.TabIndex = 6;
            // 
            // btnRegister
            // 
            this.btnRegister.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnRegister.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.btnRegister.Location = new System.Drawing.Point(613, 3);
            this.btnRegister.Name = "btnRegister";
            this.btnRegister.Size = new System.Drawing.Size(21, 20);
            this.btnRegister.TabIndex = 5;
            this.btnRegister.Text = "R";
            this.btnRegister.Click += new System.EventHandler(this.btnRegister_Click);
            // 
            // btnFull
            // 
            this.btnFull.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnFull.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.btnFull.Location = new System.Drawing.Point(581, 3);
            this.btnFull.Name = "btnFull";
            this.btnFull.Size = new System.Drawing.Size(21, 20);
            this.btnFull.TabIndex = 4;
            this.btnFull.Text = "+N";
            this.btnFull.Click += new System.EventHandler(this.btnFull_Click);
            // 
            // btnOne
            // 
            this.btnOne.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnOne.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.btnOne.Location = new System.Drawing.Point(548, 3);
            this.btnOne.Name = "btnOne";
            this.btnOne.Size = new System.Drawing.Size(21, 20);
            this.btnOne.TabIndex = 3;
            this.btnOne.Text = "+1";
            this.btnOne.Click += new System.EventHandler(this.btnOne_Click);
            // 
            // edtItemNo2
            // 
            this.edtItemNo2.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.edtItemNo2.BackColor = System.Drawing.SystemColors.InactiveBorder;
            this.edtItemNo2.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.edtItemNo2.Location = new System.Drawing.Point(4, 53);
            this.edtItemNo2.Name = "edtItemNo2";
            this.edtItemNo2.ReadOnly = true;
            this.edtItemNo2.Size = new System.Drawing.Size(518, 19);
            this.edtItemNo2.TabIndex = 2;
            // 
            // edtInfo
            // 
            this.edtInfo.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.edtInfo.BackColor = System.Drawing.SystemColors.InactiveBorder;
            this.edtInfo.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.edtInfo.Location = new System.Drawing.Point(4, 28);
            this.edtInfo.Name = "edtInfo";
            this.edtInfo.ReadOnly = true;
            this.edtInfo.Size = new System.Drawing.Size(630, 19);
            this.edtInfo.TabIndex = 1;
            // 
            // edtScan
            // 
            this.edtScan.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.edtScan.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.edtScan.Location = new System.Drawing.Point(4, 3);
            this.edtScan.Name = "edtScan";
            this.edtScan.Size = new System.Drawing.Size(530, 19);
            this.edtScan.TabIndex = 0;
            this.edtScan.KeyUp += new System.Windows.Forms.KeyEventHandler(this.edtScan_KeyUp);
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.mDetails);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel2.Location = new System.Drawing.Point(0, 404);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(638, 51);
            // 
            // mDetails
            // 
            this.mDetails.BackColor = System.Drawing.SystemColors.InactiveBorder;
            this.mDetails.Dock = System.Windows.Forms.DockStyle.Fill;
            this.mDetails.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.mDetails.Location = new System.Drawing.Point(0, 0);
            this.mDetails.Multiline = true;
            this.mDetails.Name = "mDetails";
            this.mDetails.ReadOnly = true;
            this.mDetails.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.mDetails.Size = new System.Drawing.Size(638, 51);
            this.mDetails.TabIndex = 0;
            // 
            // panel3
            // 
            this.panel3.Controls.Add(this.tcDetail);
            this.panel3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel3.Location = new System.Drawing.Point(0, 83);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(638, 321);
            // 
            // tcDetail
            // 
            this.tcDetail.Controls.Add(this.tpLocate);
            this.tcDetail.Controls.Add(this.tpProcessed);
            this.tcDetail.Controls.Add(this.tpItemBinCode);
            this.tcDetail.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tcDetail.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.tcDetail.Location = new System.Drawing.Point(0, 0);
            this.tcDetail.Name = "tcDetail";
            this.tcDetail.SelectedIndex = 0;
            this.tcDetail.Size = new System.Drawing.Size(638, 321);
            this.tcDetail.TabIndex = 0;
            this.tcDetail.SelectedIndexChanged += new System.EventHandler(this.tcDetail_SelectedIndexChanged);
            // 
            // tpLocate
            // 
            this.tpLocate.Controls.Add(this.grLocate);
            this.tpLocate.Location = new System.Drawing.Point(4, 22);
            this.tpLocate.Name = "tpLocate";
            this.tpLocate.Size = new System.Drawing.Size(630, 295);
            this.tpLocate.Text = "Разместить";
            // 
            // grLocate
            // 
            this.grLocate.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            this.grLocate.DataSource = this.bsLocate;
            this.grLocate.Dock = System.Windows.Forms.DockStyle.Fill;
            this.grLocate.Location = new System.Drawing.Point(0, 0);
            this.grLocate.Name = "grLocate";
            this.grLocate.Size = new System.Drawing.Size(630, 295);
            this.grLocate.TabIndex = 0;
            this.grLocate.TableStyles.Add(this.tblStyle);
            this.grLocate.TableStyles.Add(this.tblStyle2);
            this.grLocate.CurrentCellChanged += new System.EventHandler(this.grLocate_CurrentCellChanged);
            // 
            // tblStyle
            // 
            this.tblStyle.GridColumnStyles.Add(this.colLocateBinCode);
            this.tblStyle.GridColumnStyles.Add(this.colLocateItemNo2);
            this.tblStyle.GridColumnStyles.Add(this.colLocateQtyPlacement);
            this.tblStyle.GridColumnStyles.Add(this.colLocateProcessedQty);
            this.tblStyle.MappingName = "Locate";
            // 
            // colLocateBinCode
            // 
            this.colLocateBinCode.Format = "";
            this.colLocateBinCode.FormatInfo = null;
            this.colLocateBinCode.HeaderText = "Ячейка";
            this.colLocateBinCode.MappingName = "BinCode";
            // 
            // colLocateItemNo2
            // 
            this.colLocateItemNo2.Format = "";
            this.colLocateItemNo2.FormatInfo = null;
            this.colLocateItemNo2.HeaderText = "Товар";
            this.colLocateItemNo2.MappingName = "ItemNo2";
            // 
            // colLocateQtyPlacement
            // 
            this.colLocateQtyPlacement.Format = "";
            this.colLocateQtyPlacement.FormatInfo = null;
            this.colLocateQtyPlacement.HeaderText = "Кол-во";
            this.colLocateQtyPlacement.MappingName = "QtyPlacement";
            // 
            // colLocateProcessedQty
            // 
            this.colLocateProcessedQty.Format = "";
            this.colLocateProcessedQty.FormatInfo = null;
            this.colLocateProcessedQty.HeaderText = "Обраб.";
            this.colLocateProcessedQty.MappingName = "ProcessedQty";
            // 
            // tblStyle2
            // 
            this.tblStyle2.GridColumnStyles.Add(this.colLocateQtyPlacement2);
            this.tblStyle2.GridColumnStyles.Add(this.colLocateProcessedQty2);
            this.tblStyle2.MappingName = "Locate2";
            // 
            // colLocateQtyPlacement2
            // 
            this.colLocateQtyPlacement2.Format = "";
            this.colLocateQtyPlacement2.FormatInfo = null;
            this.colLocateQtyPlacement2.HeaderText = "Кол-во";
            this.colLocateQtyPlacement2.MappingName = "QtyPlacement";
            // 
            // colLocateProcessedQty2
            // 
            this.colLocateProcessedQty2.Format = "";
            this.colLocateProcessedQty2.FormatInfo = null;
            this.colLocateProcessedQty2.HeaderText = "Обраб.";
            this.colLocateProcessedQty2.MappingName = "ProcessedQty";
            // 
            // tpProcessed
            // 
            this.tpProcessed.Controls.Add(this.grProcessed);
            this.tpProcessed.Location = new System.Drawing.Point(4, 22);
            this.tpProcessed.Name = "tpProcessed";
            this.tpProcessed.Size = new System.Drawing.Size(630, 295);
            this.tpProcessed.Text = "Обработано";
            // 
            // grProcessed
            // 
            this.grProcessed.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            this.grProcessed.DataSource = this.bsProcessed;
            this.grProcessed.Dock = System.Windows.Forms.DockStyle.Fill;
            this.grProcessed.Location = new System.Drawing.Point(0, 0);
            this.grProcessed.Name = "grProcessed";
            this.grProcessed.Size = new System.Drawing.Size(630, 295);
            this.grProcessed.TabIndex = 0;
            this.grProcessed.TableStyles.Add(this.tblProcessedStyle);
            this.grProcessed.CurrentCellChanged += new System.EventHandler(this.grProcessed_CurrentCellChanged);
            // 
            // tblProcessedStyle
            // 
            this.tblProcessedStyle.GridColumnStyles.Add(this.colProcessedItemNo2);
            this.tblProcessedStyle.GridColumnStyles.Add(this.colProcessedBinCode);
            this.tblProcessedStyle.GridColumnStyles.Add(this.colProcessedProcessedQty);
            this.tblProcessedStyle.MappingName = "Processed";
            // 
            // colProcessedItemNo2
            // 
            this.colProcessedItemNo2.Format = "";
            this.colProcessedItemNo2.FormatInfo = null;
            this.colProcessedItemNo2.HeaderText = "Товар";
            this.colProcessedItemNo2.MappingName = "ItemNo2";
            // 
            // colProcessedBinCode
            // 
            this.colProcessedBinCode.Format = "";
            this.colProcessedBinCode.FormatInfo = null;
            this.colProcessedBinCode.HeaderText = "Ячейка";
            this.colProcessedBinCode.MappingName = "BinCode";
            // 
            // colProcessedProcessedQty
            // 
            this.colProcessedProcessedQty.Format = "";
            this.colProcessedProcessedQty.FormatInfo = null;
            this.colProcessedProcessedQty.HeaderText = "Кол-во";
            this.colProcessedProcessedQty.MappingName = "ProcessedQty";
            // 
            // tpItemBinCode
            // 
            this.tpItemBinCode.Controls.Add(this.grItemCell);
            this.tpItemBinCode.Location = new System.Drawing.Point(4, 22);
            this.tpItemBinCode.Name = "tpItemBinCode";
            this.tpItemBinCode.Size = new System.Drawing.Size(630, 295);
            this.tpItemBinCode.Text = "Товар-Ячейка";
            // 
            // grItemCell
            // 
            this.grItemCell.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            this.grItemCell.DataSource = this.bsItemCell;
            this.grItemCell.Dock = System.Windows.Forms.DockStyle.Fill;
            this.grItemCell.Location = new System.Drawing.Point(0, 0);
            this.grItemCell.Name = "grItemCell";
            this.grItemCell.Size = new System.Drawing.Size(630, 295);
            this.grItemCell.TabIndex = 0;
            this.grItemCell.TableStyles.Add(this.tblItemCellStyle);
            // 
            // tblItemCellStyle
            // 
            this.tblItemCellStyle.GridColumnStyles.Add(this.colItemCellItemNo2);
            this.tblItemCellStyle.GridColumnStyles.Add(this.colItemCellItemNo);
            this.tblItemCellStyle.GridColumnStyles.Add(this.colItemCellBinCode);
            this.tblItemCellStyle.GridColumnStyles.Add(this.colItemCellQuantity);
            this.tblItemCellStyle.GridColumnStyles.Add(this.colItemCellFixed);
            this.tblItemCellStyle.GridColumnStyles.Add(this.colItemCellDefault);
            this.tblItemCellStyle.MappingName = "ItemCell";
            // 
            // colItemCellItemNo2
            // 
            this.colItemCellItemNo2.Format = "";
            this.colItemCellItemNo2.FormatInfo = null;
            this.colItemCellItemNo2.HeaderText = "Товар 2";
            this.colItemCellItemNo2.MappingName = "ItemNo2";
            // 
            // colItemCellItemNo
            // 
            this.colItemCellItemNo.Format = "";
            this.colItemCellItemNo.FormatInfo = null;
            this.colItemCellItemNo.HeaderText = "Товар";
            this.colItemCellItemNo.MappingName = "ItemNo";
            // 
            // colItemCellBinCode
            // 
            this.colItemCellBinCode.Format = "";
            this.colItemCellBinCode.FormatInfo = null;
            this.colItemCellBinCode.HeaderText = "Ячейка";
            this.colItemCellBinCode.MappingName = "BinCode";
            // 
            // colItemCellQuantity
            // 
            this.colItemCellQuantity.Format = "";
            this.colItemCellQuantity.FormatInfo = null;
            this.colItemCellQuantity.HeaderText = "Кол-во";
            this.colItemCellQuantity.MappingName = "Quantity";
            // 
            // colItemCellFixed
            // 
            this.colItemCellFixed.Format = "";
            this.colItemCellFixed.FormatInfo = null;
            this.colItemCellFixed.HeaderText = "Фикс.";
            this.colItemCellFixed.MappingName = "Fixed";
            // 
            // colItemCellDefault
            // 
            this.colItemCellDefault.Format = "";
            this.colItemCellDefault.FormatInfo = null;
            this.colItemCellDefault.HeaderText = "Умолч.";
            this.colItemCellDefault.MappingName = "Default";
            // 
            // FormDetail
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(638, 455);
            this.Controls.Add(this.panel3);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.panel1);
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "FormDetail";
            this.Text = "Раскладка товара (Подробно)";
            this.TopMost = true;
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.FormDetail_Load);
            this.Closing += new System.ComponentModel.CancelEventHandler(this.FormDetail_Closing);
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.FormDetail_KeyUp);
            this.panel1.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            this.panel3.ResumeLayout(false);
            this.tcDetail.ResumeLayout(false);
            this.tpLocate.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.bsLocate)).EndInit();
            this.tpProcessed.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.bsProcessed)).EndInit();
            this.tpItemBinCode.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.bsItemCell)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.TextBox mDetails;
        private System.Windows.Forms.BindingSource bsLocate;
        private System.Windows.Forms.TextBox edtScan;
        private System.Windows.Forms.TextBox edtInfo;
        private System.Windows.Forms.TextBox edtItemNo2;
        private System.Windows.Forms.Button btnOne;
        private System.Windows.Forms.Button btnRegister;
        private System.Windows.Forms.Button btnFull;
        private System.Windows.Forms.TextBox edtBinCode;
        private System.Windows.Forms.BindingSource bsProcessed;
        private System.Windows.Forms.TabControl tcDetail;
        private System.Windows.Forms.TabPage tpLocate;
        private System.Windows.Forms.DataGrid grLocate;
        private System.Windows.Forms.DataGridTableStyle tblStyle;
        private System.Windows.Forms.DataGridTextBoxColumn colLocateBinCode;
        private System.Windows.Forms.DataGridTextBoxColumn colLocateItemNo2;
        private System.Windows.Forms.DataGridTextBoxColumn colLocateQtyPlacement;
        private System.Windows.Forms.TabPage tpProcessed;
        private System.Windows.Forms.DataGrid grProcessed;
        private System.Windows.Forms.DataGridTableStyle tblProcessedStyle;
        private System.Windows.Forms.DataGridTextBoxColumn colProcessedItemNo2;
        private System.Windows.Forms.DataGridTextBoxColumn colProcessedBinCode;
        private System.Windows.Forms.DataGridTextBoxColumn colProcessedProcessedQty;
        private System.Windows.Forms.TabPage tpItemBinCode;
        private System.Windows.Forms.DataGrid grItemCell;
        private System.Windows.Forms.BindingSource bsItemCell;
        private System.Windows.Forms.DataGridTableStyle tblItemCellStyle;
        private System.Windows.Forms.DataGridTextBoxColumn colItemCellItemNo2;
        private System.Windows.Forms.DataGridTextBoxColumn colItemCellItemNo;
        private System.Windows.Forms.DataGridTextBoxColumn colItemCellBinCode;
        private System.Windows.Forms.DataGridTextBoxColumn colItemCellQuantity;
        private System.Windows.Forms.DataGridTextBoxColumn colItemCellFixed;
        private System.Windows.Forms.DataGridTextBoxColumn colItemCellDefault;
        private System.Windows.Forms.DataGridTextBoxColumn colLocateProcessedQty;
        private System.Windows.Forms.DataGridTableStyle tblStyle2;
        private System.Windows.Forms.DataGridTextBoxColumn colLocateQtyPlacement2;
        private System.Windows.Forms.DataGridTextBoxColumn colLocateProcessedQty2;
        private System.Windows.Forms.CheckBox cbChangeCell;
    }
}